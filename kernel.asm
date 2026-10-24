
kernel:     file format elf64-x86-64


Disassembly of section .text:

0000080000100000 <multiboot_header>:
 80000100000:	02 b0 ad 1b 00 00    	add    0x1bad(%rax),%dh
 80000100006:	00 00                	add    %al,(%rax)
 80000100008:	fe 4f 52             	decb   0x52(%rdi)
 8000010000b:	e4                   	.byte 0xe4

000008000010000c <entry>:

# Entering xv6 on boot processor, with paging off, in protected mode.
.globl entry
entry:
  # Enable physical-address extensions (PAE).
  movl    %cr4, %eax
 8000010000c:	0f 20 e0             	mov    %cr4,%rax
  orl     $(CR4_PAE), %eax
 8000010000f:	83 c8 20             	or     $0x20,%eax
  movl    %eax, %cr4
 80000100012:	0f 22 e0             	mov    %rax,%cr4

  # Load CR3 with the physical address of PML4.
  movl    $(V2P_WO(entrypml4)), %eax
 80000100015:	b8 00 d0 10 00       	mov    $0x10d000,%eax
  movl    %eax, %cr3
 8000010001a:	0f 22 d8             	mov    %rax,%cr3

  # Enable IA-32e mode by setting IA32_EFER.LME = 1.
  movl    $EFER_MSR, %ecx
 8000010001d:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
 80000100022:	0f 32                	rdmsr
  orl     $EFER_MSR_LME, %eax
 80000100024:	0d 00 01 00 00       	or     $0x100,%eax
  wrmsr
 80000100029:	0f 30                	wrmsr

  # Enable paging.
  # This causes the processor to set the IA32_EFER.LMA bit to 1.
  movl    %cr0, %eax
 8000010002b:	0f 20 c0             	mov    %cr0,%rax
  orl     $CR0_PG, %eax
 8000010002e:	0d 00 00 00 80       	or     $0x80000000,%eax
  movl    %eax, %cr0
 80000100033:	0f 22 c0             	mov    %rax,%cr0

  # We are now in the 32-bit compatibility submode of IA-32e mode.
  # To complete the transition to 64-bit submode, we have to load 
  # a gdt with the 64-bit flag set (in the code segment), and then 
  # use a far jump to reload %cs and %rip.
  lgdt    (V2P_WO(gdt64desc))
 80000100036:	0f 01 15 18 c0 10 00 	lgdt   0x10c018(%rip)        # 8000020c055 <end+0xec0b5>
  ljmp    $(SEG_KCODE<<3), $(V2P_WO(start64))
 8000010003d:	ea                   	(bad)
 8000010003e:	50                   	push   %rax
 8000010003f:	00 10                	add    %dl,(%rax)
 80000100041:	00 08                	add    %cl,(%rax)
 80000100043:	00 66 66             	add    %ah,0x66(%rsi)
 80000100046:	2e 0f 1f 84 00 00 00 	cs nopl 0x0(%rax,%rax,1)
 8000010004d:	00 00 
 8000010004f:	90                   	nop

0000080000100050 <start64>:
start64:
  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  movabs  $(stack + KSTACKSIZE), %rsp
 80000100050:	48 bc a0 ff 11 00 00 	movabs $0x8000011ffa0,%rsp
 80000100057:	08 00 00 
  movabs  $main, %rax
 8000010005a:	48 b8 9e 3b 10 00 00 	movabs $0x80000103b9e,%rax
 80000100061:	08 00 00 
  jmp     *%rax
 80000100064:	ff e0                	jmp    *%rax
 80000100066:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 8000010006d:	00 00 00 
 80000100070:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 80000100077:	00 00 00 
 8000010007a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000080000100080 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
 80000100080:	55                   	push   %rbp
 80000100081:	48 89 e5             	mov    %rsp,%rbp
 80000100084:	41 55                	push   %r13
 80000100086:	41 54                	push   %r12
 80000100088:	53                   	push   %rbx
 80000100089:	48 83 ec 08          	sub    $0x8,%rsp
 8000010008d:	41 89 fc             	mov    %edi,%r12d
 80000100090:	41 89 f5             	mov    %esi,%r13d
  struct buf *b;

  acquire(&bcache.lock);
 80000100093:	48 bb 60 0d 11 00 00 	movabs $0x80000110d60,%rbx
 8000010009a:	08 00 00 
 8000010009d:	48 89 df             	mov    %rbx,%rdi
 800001000a0:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 800001000a7:	08 00 00 
 800001000aa:	ff d0                	call   *%rax

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
 800001000ac:	48 8b 9b a8 51 00 00 	mov    0x51a8(%rbx),%rbx
 800001000b3:	eb 12                	jmp    800001000c7 <bget+0x47>
 800001000b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 800001000bc:	00 00 00 00 
 800001000c0:	48 8b 9b a0 00 00 00 	mov    0xa0(%rbx),%rbx
 800001000c7:	48 b8 68 5e 11 00 00 	movabs $0x80000115e68,%rax
 800001000ce:	08 00 00 
 800001000d1:	48 39 c3             	cmp    %rax,%rbx
 800001000d4:	74 46                	je     8000010011c <bget+0x9c>
    if(b->dev == dev && b->blockno == blockno){
 800001000d6:	44 39 63 04          	cmp    %r12d,0x4(%rbx)
 800001000da:	75 e4                	jne    800001000c0 <bget+0x40>
 800001000dc:	44 39 6b 08          	cmp    %r13d,0x8(%rbx)
 800001000e0:	75 de                	jne    800001000c0 <bget+0x40>
      b->refcnt++;
 800001000e2:	8b 83 90 00 00 00    	mov    0x90(%rbx),%eax
 800001000e8:	83 c0 01             	add    $0x1,%eax
 800001000eb:	89 83 90 00 00 00    	mov    %eax,0x90(%rbx)
      release(&bcache.lock);
 800001000f1:	48 bf 60 0d 11 00 00 	movabs $0x80000110d60,%rdi
 800001000f8:	08 00 00 
 800001000fb:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000100102:	08 00 00 
 80000100105:	ff d0                	call   *%rax
      acquiresleep(&b->lock);
 80000100107:	48 8d 7b 10          	lea    0x10(%rbx),%rdi
 8000010010b:	48 b8 4d 52 10 00 00 	movabs $0x8000010524d,%rax
 80000100112:	08 00 00 
 80000100115:	ff d0                	call   *%rax
      return b;
 80000100117:	e9 86 00 00 00       	jmp    800001001a2 <bget+0x122>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
 8000010011c:	48 8d 80 98 00 00 00 	lea    0x98(%rax),%rax
 80000100123:	48 8b 18             	mov    (%rax),%rbx
 80000100126:	eb 1f                	jmp    80000100147 <bget+0xc7>
 80000100128:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 8000010012f:	00 00 00 00 
 80000100133:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 8000010013a:	00 00 00 00 
 8000010013e:	66 90                	xchg   %ax,%ax
 80000100140:	48 8b 9b 98 00 00 00 	mov    0x98(%rbx),%rbx
 80000100147:	48 b8 68 5e 11 00 00 	movabs $0x80000115e68,%rax
 8000010014e:	08 00 00 
 80000100151:	48 39 c3             	cmp    %rax,%rbx
 80000100154:	74 5a                	je     800001001b0 <bget+0x130>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
 80000100156:	83 bb 90 00 00 00 00 	cmpl   $0x0,0x90(%rbx)
 8000010015d:	75 e1                	jne    80000100140 <bget+0xc0>
 8000010015f:	f6 03 04             	testb  $0x4,(%rbx)
 80000100162:	75 dc                	jne    80000100140 <bget+0xc0>
      b->dev = dev;
 80000100164:	44 89 63 04          	mov    %r12d,0x4(%rbx)
      b->blockno = blockno;
 80000100168:	44 89 6b 08          	mov    %r13d,0x8(%rbx)
      b->flags = 0;
 8000010016c:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
      b->refcnt = 1;
 80000100172:	c7 83 90 00 00 00 01 	movl   $0x1,0x90(%rbx)
 80000100179:	00 00 00 
      release(&bcache.lock);
 8000010017c:	48 bf 60 0d 11 00 00 	movabs $0x80000110d60,%rdi
 80000100183:	08 00 00 
 80000100186:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 8000010018d:	08 00 00 
 80000100190:	ff d0                	call   *%rax
      acquiresleep(&b->lock);
 80000100192:	48 8d 7b 10          	lea    0x10(%rbx),%rdi
 80000100196:	48 b8 4d 52 10 00 00 	movabs $0x8000010524d,%rax
 8000010019d:	08 00 00 
 800001001a0:	ff d0                	call   *%rax
      return b;
    }
  }
  panic("bget: no buffers");
}
 800001001a2:	48 89 d8             	mov    %rbx,%rax
 800001001a5:	48 83 c4 08          	add    $0x8,%rsp
 800001001a9:	5b                   	pop    %rbx
 800001001aa:	41 5c                	pop    %r12
 800001001ac:	41 5d                	pop    %r13
 800001001ae:	5d                   	pop    %rbp
 800001001af:	c3                   	ret
  panic("bget: no buffers");
 800001001b0:	48 bf a0 a9 10 00 00 	movabs $0x8000010a9a0,%rdi
 800001001b7:	08 00 00 
 800001001ba:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001001c1:	08 00 00 
 800001001c4:	ff d0                	call   *%rax

00000800001001c6 <binit>:
{
 800001001c6:	55                   	push   %rbp
 800001001c7:	48 89 e5             	mov    %rsp,%rbp
 800001001ca:	41 54                	push   %r12
 800001001cc:	53                   	push   %rbx
  initlock(&bcache.lock, "bcache");
 800001001cd:	48 be b1 a9 10 00 00 	movabs $0x8000010a9b1,%rsi
 800001001d4:	08 00 00 
 800001001d7:	48 bb 60 0d 11 00 00 	movabs $0x80000110d60,%rbx
 800001001de:	08 00 00 
 800001001e1:	48 89 df             	mov    %rbx,%rdi
 800001001e4:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 800001001eb:	08 00 00 
 800001001ee:	ff d0                	call   *%rax
  bcache.head.prev = &bcache.head;
 800001001f0:	48 8d 83 08 51 00 00 	lea    0x5108(%rbx),%rax
 800001001f7:	48 89 83 a0 51 00 00 	mov    %rax,0x51a0(%rbx)
  bcache.head.next = &bcache.head;
 800001001fe:	48 89 83 a8 51 00 00 	mov    %rax,0x51a8(%rbx)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
 80000100205:	48 8d 5b 68          	lea    0x68(%rbx),%rbx
 80000100209:	eb 60                	jmp    8000010026b <binit+0xa5>
    b->next = bcache.head.next;
 8000010020b:	49 bc 60 0d 11 00 00 	movabs $0x80000110d60,%r12
 80000100212:	08 00 00 
 80000100215:	49 8b 84 24 a8 51 00 	mov    0x51a8(%r12),%rax
 8000010021c:	00 
 8000010021d:	48 89 83 a0 00 00 00 	mov    %rax,0xa0(%rbx)
    b->prev = &bcache.head;
 80000100224:	49 8d 84 24 08 51 00 	lea    0x5108(%r12),%rax
 8000010022b:	00 
 8000010022c:	48 89 83 98 00 00 00 	mov    %rax,0x98(%rbx)
    initsleeplock(&b->lock, "buffer");
 80000100233:	48 8d 7b 10          	lea    0x10(%rbx),%rdi
 80000100237:	48 be b8 a9 10 00 00 	movabs $0x8000010a9b8,%rsi
 8000010023e:	08 00 00 
 80000100241:	48 b8 10 52 10 00 00 	movabs $0x80000105210,%rax
 80000100248:	08 00 00 
 8000010024b:	ff d0                	call   *%rax
    bcache.head.next->prev = b;
 8000010024d:	49 8b 84 24 a8 51 00 	mov    0x51a8(%r12),%rax
 80000100254:	00 
 80000100255:	48 89 98 98 00 00 00 	mov    %rbx,0x98(%rax)
    bcache.head.next = b;
 8000010025c:	49 89 9c 24 a8 51 00 	mov    %rbx,0x51a8(%r12)
 80000100263:	00 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
 80000100264:	48 81 c3 b0 02 00 00 	add    $0x2b0,%rbx
 8000010026b:	48 b8 68 5e 11 00 00 	movabs $0x80000115e68,%rax
 80000100272:	08 00 00 
 80000100275:	48 39 c3             	cmp    %rax,%rbx
 80000100278:	72 91                	jb     8000010020b <binit+0x45>
}
 8000010027a:	5b                   	pop    %rbx
 8000010027b:	41 5c                	pop    %r12
 8000010027d:	5d                   	pop    %rbp
 8000010027e:	c3                   	ret

000008000010027f <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
 8000010027f:	55                   	push   %rbp
 80000100280:	48 89 e5             	mov    %rsp,%rbp
 80000100283:	53                   	push   %rbx
 80000100284:	48 83 ec 08          	sub    $0x8,%rsp
  struct buf *b;

  b = bget(dev, blockno);
 80000100288:	48 b8 80 00 10 00 00 	movabs $0x80000100080,%rax
 8000010028f:	08 00 00 
 80000100292:	ff d0                	call   *%rax
 80000100294:	48 89 c3             	mov    %rax,%rbx
  if((b->flags & B_VALID) == 0) {
 80000100297:	f6 00 02             	testb  $0x2,(%rax)
 8000010029a:	74 0a                	je     800001002a6 <bread+0x27>
    iderw(b);
  }
  return b;
}
 8000010029c:	48 89 d8             	mov    %rbx,%rax
 8000010029f:	48 83 c4 08          	add    $0x8,%rsp
 800001002a3:	5b                   	pop    %rbx
 800001002a4:	5d                   	pop    %rbp
 800001002a5:	c3                   	ret
    iderw(b);
 800001002a6:	48 89 c7             	mov    %rax,%rdi
 800001002a9:	48 b8 88 2a 10 00 00 	movabs $0x80000102a88,%rax
 800001002b0:	08 00 00 
 800001002b3:	ff d0                	call   *%rax
  return b;
 800001002b5:	eb e5                	jmp    8000010029c <bread+0x1d>

00000800001002b7 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
 800001002b7:	55                   	push   %rbp
 800001002b8:	48 89 e5             	mov    %rsp,%rbp
 800001002bb:	53                   	push   %rbx
 800001002bc:	48 83 ec 08          	sub    $0x8,%rsp
 800001002c0:	48 89 fb             	mov    %rdi,%rbx
  if(!holdingsleep(&b->lock))
 800001002c3:	48 8d 7f 10          	lea    0x10(%rdi),%rdi
 800001002c7:	48 b8 fe 52 10 00 00 	movabs $0x800001052fe,%rax
 800001002ce:	08 00 00 
 800001002d1:	ff d0                	call   *%rax
 800001002d3:	85 c0                	test   %eax,%eax
 800001002d5:	74 1d                	je     800001002f4 <bwrite+0x3d>
    panic("bwrite");
  b->flags |= B_DIRTY;
 800001002d7:	8b 03                	mov    (%rbx),%eax
 800001002d9:	83 c8 04             	or     $0x4,%eax
 800001002dc:	89 03                	mov    %eax,(%rbx)
  iderw(b);
 800001002de:	48 89 df             	mov    %rbx,%rdi
 800001002e1:	48 b8 88 2a 10 00 00 	movabs $0x80000102a88,%rax
 800001002e8:	08 00 00 
 800001002eb:	ff d0                	call   *%rax
}
 800001002ed:	48 83 c4 08          	add    $0x8,%rsp
 800001002f1:	5b                   	pop    %rbx
 800001002f2:	5d                   	pop    %rbp
 800001002f3:	c3                   	ret
    panic("bwrite");
 800001002f4:	48 bf bf a9 10 00 00 	movabs $0x8000010a9bf,%rdi
 800001002fb:	08 00 00 
 800001002fe:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000100305:	08 00 00 
 80000100308:	ff d0                	call   *%rax

000008000010030a <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
 8000010030a:	55                   	push   %rbp
 8000010030b:	48 89 e5             	mov    %rsp,%rbp
 8000010030e:	41 54                	push   %r12
 80000100310:	53                   	push   %rbx
 80000100311:	48 89 fb             	mov    %rdi,%rbx
  if(!holdingsleep(&b->lock))
 80000100314:	4c 8d 67 10          	lea    0x10(%rdi),%r12
 80000100318:	4c 89 e7             	mov    %r12,%rdi
 8000010031b:	48 b8 fe 52 10 00 00 	movabs $0x800001052fe,%rax
 80000100322:	08 00 00 
 80000100325:	ff d0                	call   *%rax
 80000100327:	85 c0                	test   %eax,%eax
 80000100329:	0f 84 af 00 00 00    	je     800001003de <brelse+0xd4>
    panic("brelse");

  releasesleep(&b->lock);
 8000010032f:	4c 89 e7             	mov    %r12,%rdi
 80000100332:	48 b8 b1 52 10 00 00 	movabs $0x800001052b1,%rax
 80000100339:	08 00 00 
 8000010033c:	ff d0                	call   *%rax

  acquire(&bcache.lock);
 8000010033e:	48 bf 60 0d 11 00 00 	movabs $0x80000110d60,%rdi
 80000100345:	08 00 00 
 80000100348:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 8000010034f:	08 00 00 
 80000100352:	ff d0                	call   *%rax
  b->refcnt--;
 80000100354:	8b 83 90 00 00 00    	mov    0x90(%rbx),%eax
 8000010035a:	83 e8 01             	sub    $0x1,%eax
 8000010035d:	89 83 90 00 00 00    	mov    %eax,0x90(%rbx)
  if (b->refcnt == 0) {
 80000100363:	75 5e                	jne    800001003c3 <brelse+0xb9>
    // no one is waiting for it.
    b->next->prev = b->prev;
 80000100365:	48 8b 93 a0 00 00 00 	mov    0xa0(%rbx),%rdx
 8000010036c:	48 8b 83 98 00 00 00 	mov    0x98(%rbx),%rax
 80000100373:	48 89 82 98 00 00 00 	mov    %rax,0x98(%rdx)
    b->prev->next = b->next;
 8000010037a:	48 8b 93 a0 00 00 00 	mov    0xa0(%rbx),%rdx
 80000100381:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->next = bcache.head.next;
 80000100388:	48 b8 60 0d 11 00 00 	movabs $0x80000110d60,%rax
 8000010038f:	08 00 00 
 80000100392:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
 80000100399:	48 89 93 a0 00 00 00 	mov    %rdx,0xa0(%rbx)
    b->prev = &bcache.head;
 800001003a0:	48 8d 88 08 51 00 00 	lea    0x5108(%rax),%rcx
 800001003a7:	48 89 8b 98 00 00 00 	mov    %rcx,0x98(%rbx)
    bcache.head.next->prev = b;
 800001003ae:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
 800001003b5:	48 89 9a 98 00 00 00 	mov    %rbx,0x98(%rdx)
    bcache.head.next = b;
 800001003bc:	48 89 98 a8 51 00 00 	mov    %rbx,0x51a8(%rax)
  }
  
  release(&bcache.lock);
 800001003c3:	48 bf 60 0d 11 00 00 	movabs $0x80000110d60,%rdi
 800001003ca:	08 00 00 
 800001003cd:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001003d4:	08 00 00 
 800001003d7:	ff d0                	call   *%rax
}
 800001003d9:	5b                   	pop    %rbx
 800001003da:	41 5c                	pop    %r12
 800001003dc:	5d                   	pop    %rbp
 800001003dd:	c3                   	ret
    panic("brelse");
 800001003de:	48 bf c6 a9 10 00 00 	movabs $0x8000010a9c6,%rdi
 800001003e5:	08 00 00 
 800001003e8:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001003ef:	08 00 00 
 800001003f2:	ff d0                	call   *%rax
 800001003f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001003fb:	00 00 00 
 800001003fe:	66 90                	xchg   %ax,%ax

0000080000100400 <_va_arg>:
// Retrieve the next argument from the va_list.
static inline void *_va_arg(va_list *args)
{
    // Returns the next argument from registers if _index < 6, 
    // otherwise from the stack.
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 80000100400:	8b 47 38             	mov    0x38(%rdi),%eax
 80000100403:	83 f8 05             	cmp    $0x5,%eax
 80000100406:	77 0d                	ja     80000100415 <_va_arg+0x15>
 80000100408:	8d 50 01             	lea    0x1(%rax),%edx
 8000010040b:	89 57 38             	mov    %edx,0x38(%rdi)
 8000010040e:	89 c0                	mov    %eax,%eax
 80000100410:	48 8b 04 c7          	mov    (%rdi,%rax,8),%rax
 80000100414:	c3                   	ret
                                  : args->more_argint[(args->_index++)-6]);
 80000100415:	8d 50 01             	lea    0x1(%rax),%edx
 80000100418:	89 57 38             	mov    %edx,0x38(%rdi)
 8000010041b:	8d 40 fa             	lea    -0x6(%rax),%eax
 8000010041e:	48 c1 e0 03          	shl    $0x3,%rax
 80000100422:	48 03 47 30          	add    0x30(%rdi),%rax
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 80000100426:	48 8b 00             	mov    (%rax),%rax
}
 80000100429:	c3                   	ret

000008000010042a <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
 8000010042a:	55                   	push   %rbp
 8000010042b:	48 89 e5             	mov    %rsp,%rbp
 8000010042e:	41 56                	push   %r14
 80000100430:	41 55                	push   %r13
 80000100432:	41 54                	push   %r12
 80000100434:	53                   	push   %rbx
 80000100435:	49 89 fd             	mov    %rdi,%r13
 80000100438:	49 89 f4             	mov    %rsi,%r12
 8000010043b:	89 d3                	mov    %edx,%ebx
  uint target;
  int c;

  iunlock(ip);
 8000010043d:	48 b8 2a 20 10 00 00 	movabs $0x8000010202a,%rax
 80000100444:	08 00 00 
 80000100447:	ff d0                	call   *%rax
  target = n;
 80000100449:	41 89 de             	mov    %ebx,%r14d
  acquire(&cons.lock);
 8000010044c:	48 bf c0 61 11 00 00 	movabs $0x800001161c0,%rdi
 80000100453:	08 00 00 
 80000100456:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 8000010045d:	08 00 00 
 80000100460:	ff d0                	call   *%rax
  while(n > 0){
 80000100462:	85 db                	test   %ebx,%ebx
 80000100464:	0f 8e c1 00 00 00    	jle    8000010052b <consoleread+0x101>
    while(input.r == input.w){
 8000010046a:	48 ba 20 61 11 00 00 	movabs $0x80000116120,%rdx
 80000100471:	08 00 00 
 80000100474:	8b 82 80 00 00 00    	mov    0x80(%rdx),%eax
 8000010047a:	3b 82 84 00 00 00    	cmp    0x84(%rdx),%eax
 80000100480:	75 69                	jne    800001004eb <consoleread+0xc1>
      if(myproc()->killed){
 80000100482:	b0 00                	mov    $0x0,%al
 80000100484:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 8000010048b:	08 00 00 
 8000010048e:	ff d2                	call   *%rdx
 80000100490:	83 78 40 00          	cmpl   $0x0,0x40(%rax)
 80000100494:	75 22                	jne    800001004b8 <consoleread+0x8e>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
 80000100496:	48 be c0 61 11 00 00 	movabs $0x800001161c0,%rsi
 8000010049d:	08 00 00 
 800001004a0:	48 bf a0 61 11 00 00 	movabs $0x800001161a0,%rdi
 800001004a7:	08 00 00 
 800001004aa:	48 b8 03 4e 10 00 00 	movabs $0x80000104e03,%rax
 800001004b1:	08 00 00 
 800001004b4:	ff d0                	call   *%rax
 800001004b6:	eb b2                	jmp    8000010046a <consoleread+0x40>
        release(&cons.lock);
 800001004b8:	48 bf c0 61 11 00 00 	movabs $0x800001161c0,%rdi
 800001004bf:	08 00 00 
 800001004c2:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001004c9:	08 00 00 
 800001004cc:	ff d0                	call   *%rax
        ilock(ip);
 800001004ce:	4c 89 ef             	mov    %r13,%rdi
 800001004d1:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 800001004d8:	08 00 00 
 800001004db:	ff d0                	call   *%rax
        return -1;
 800001004dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
 800001004e2:	5b                   	pop    %rbx
 800001004e3:	41 5c                	pop    %r12
 800001004e5:	41 5d                	pop    %r13
 800001004e7:	41 5e                	pop    %r14
 800001004e9:	5d                   	pop    %rbp
 800001004ea:	c3                   	ret
    c = input.buf[input.r++ % INPUT_BUF];
 800001004eb:	8d 48 01             	lea    0x1(%rax),%ecx
 800001004ee:	89 8a 80 00 00 00    	mov    %ecx,0x80(%rdx)
 800001004f4:	89 c1                	mov    %eax,%ecx
 800001004f6:	83 e1 7f             	and    $0x7f,%ecx
 800001004f9:	8a 0c 0a             	mov    (%rdx,%rcx,1),%cl
 800001004fc:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
 800001004ff:	83 fa 04             	cmp    $0x4,%edx
 80000100502:	74 19                	je     8000010051d <consoleread+0xf3>
    *dst++ = c;
 80000100504:	49 8d 44 24 01       	lea    0x1(%r12),%rax
 80000100509:	41 88 0c 24          	mov    %cl,(%r12)
    --n;
 8000010050d:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
 80000100510:	83 fa 0a             	cmp    $0xa,%edx
 80000100513:	74 16                	je     8000010052b <consoleread+0x101>
    *dst++ = c;
 80000100515:	49 89 c4             	mov    %rax,%r12
 80000100518:	e9 45 ff ff ff       	jmp    80000100462 <consoleread+0x38>
      if(n < target){
 8000010051d:	44 39 f3             	cmp    %r14d,%ebx
 80000100520:	73 09                	jae    8000010052b <consoleread+0x101>
        input.r--;
 80000100522:	a3 a0 61 11 00 00 08 	movabs %eax,0x800001161a0
 80000100529:	00 00 
  release(&cons.lock);
 8000010052b:	48 bf c0 61 11 00 00 	movabs $0x800001161c0,%rdi
 80000100532:	08 00 00 
 80000100535:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 8000010053c:	08 00 00 
 8000010053f:	ff d0                	call   *%rax
  ilock(ip);
 80000100541:	4c 89 ef             	mov    %r13,%rdi
 80000100544:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 8000010054b:	08 00 00 
 8000010054e:	ff d0                	call   *%rax
  return target - n;
 80000100550:	44 89 f0             	mov    %r14d,%eax
 80000100553:	29 d8                	sub    %ebx,%eax
 80000100555:	eb 8b                	jmp    800001004e2 <consoleread+0xb8>

0000080000100557 <panic>:
{
 80000100557:	55                   	push   %rbp
 80000100558:	48 89 e5             	mov    %rsp,%rbp
 8000010055b:	41 54                	push   %r12
 8000010055d:	53                   	push   %rbx
 8000010055e:	48 83 ec 50          	sub    $0x50,%rsp
 80000100562:	49 89 fc             	mov    %rdi,%r12
}

static inline void
cli(void)
{
    asm volatile("cli");
 80000100565:	fa                   	cli
  cons.locking = 0;
 80000100566:	48 b8 28 62 11 00 00 	movabs $0x80000116228,%rax
 8000010056d:	08 00 00 
 80000100570:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  cprintf("lapicid %d: panic: ", lapicid());
 80000100576:	48 b8 a4 31 10 00 00 	movabs $0x800001031a4,%rax
 8000010057d:	08 00 00 
 80000100580:	ff d0                	call   *%rax
 80000100582:	89 c6                	mov    %eax,%esi
 80000100584:	48 bf cd a9 10 00 00 	movabs $0x8000010a9cd,%rdi
 8000010058b:	08 00 00 
 8000010058e:	b0 00                	mov    $0x0,%al
 80000100590:	48 bb f9 08 10 00 00 	movabs $0x800001008f9,%rbx
 80000100597:	08 00 00 
 8000010059a:	ff d3                	call   *%rbx
  cprintf(s);
 8000010059c:	4c 89 e7             	mov    %r12,%rdi
 8000010059f:	b0 00                	mov    $0x0,%al
 800001005a1:	ff d3                	call   *%rbx
  cprintf("\n");
 800001005a3:	48 bf 5a ae 10 00 00 	movabs $0x8000010ae5a,%rdi
 800001005aa:	08 00 00 
 800001005ad:	b0 00                	mov    $0x0,%al
 800001005af:	ff d3                	call   *%rbx

static inline uint64
rrbp(void)
{
  uint64 val;
  asm volatile("movq %%rbp,%0" : "=r" (val));
 800001005b1:	48 89 ef             	mov    %rbp,%rdi
  getcallerpcs((uint64*) rrbp(), pcs);
 800001005b4:	48 8d 75 a0          	lea    -0x60(%rbp),%rsi
 800001005b8:	48 b8 73 53 10 00 00 	movabs $0x80000105373,%rax
 800001005bf:	08 00 00 
 800001005c2:	ff d0                	call   *%rax
  for(i=0; i<10; i++)
 800001005c4:	bb 00 00 00 00       	mov    $0x0,%ebx
 800001005c9:	eb 23                	jmp    800001005ee <panic+0x97>
    cprintf(" %p", pcs[i]);
 800001005cb:	48 63 c3             	movslq %ebx,%rax
 800001005ce:	48 8b 74 c5 a0       	mov    -0x60(%rbp,%rax,8),%rsi
 800001005d3:	48 bf e1 a9 10 00 00 	movabs $0x8000010a9e1,%rdi
 800001005da:	08 00 00 
 800001005dd:	b0 00                	mov    $0x0,%al
 800001005df:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 800001005e6:	08 00 00 
 800001005e9:	ff d2                	call   *%rdx
  for(i=0; i<10; i++)
 800001005eb:	83 c3 01             	add    $0x1,%ebx
 800001005ee:	83 fb 09             	cmp    $0x9,%ebx
 800001005f1:	7e d8                	jle    800001005cb <panic+0x74>
  panicked = 1; // freeze other CPU
 800001005f3:	48 b8 30 62 11 00 00 	movabs $0x80000116230,%rax
 800001005fa:	08 00 00 
 800001005fd:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
 80000100603:	90                   	nop
  for(;;)
 80000100604:	eb fe                	jmp    80000100604 <panic+0xad>

0000080000100606 <cgaputc>:
{
 80000100606:	55                   	push   %rbp
 80000100607:	48 89 e5             	mov    %rsp,%rbp
 8000010060a:	41 54                	push   %r12
 8000010060c:	53                   	push   %rbx
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 8000010060d:	41 b8 d4 03 00 00    	mov    $0x3d4,%r8d
 80000100613:	b0 0e                	mov    $0xe,%al
 80000100615:	44 89 c2             	mov    %r8d,%edx
 80000100618:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0" : "=a" (data) : "d" (port));
 80000100619:	be d5 03 00 00       	mov    $0x3d5,%esi
 8000010061e:	89 f2                	mov    %esi,%edx
 80000100620:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
 80000100621:	0f b6 c8             	movzbl %al,%ecx
 80000100624:	c1 e1 08             	shl    $0x8,%ecx
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 80000100627:	b0 0f                	mov    $0xf,%al
 80000100629:	44 89 c2             	mov    %r8d,%edx
 8000010062c:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0" : "=a" (data) : "d" (port));
 8000010062d:	89 f2                	mov    %esi,%edx
 8000010062f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
 80000100630:	0f b6 c0             	movzbl %al,%eax
 80000100633:	09 c8                	or     %ecx,%eax
  if(c == '\n')
 80000100635:	83 ff 0a             	cmp    $0xa,%edi
 80000100638:	74 70                	je     800001006aa <cgaputc+0xa4>
  else if(c == BACKSPACE){
 8000010063a:	81 ff 00 01 00 00    	cmp    $0x100,%edi
 80000100640:	0f 84 87 00 00 00    	je     800001006cd <cgaputc+0xc7>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
 80000100646:	40 0f b6 ff          	movzbl %dil,%edi
 8000010064a:	8d 58 01             	lea    0x1(%rax),%ebx
 8000010064d:	48 98                	cltq
 8000010064f:	81 cf 00 07 00 00    	or     $0x700,%edi
 80000100655:	48 ba 00 80 0b 00 00 	movabs $0x800000b8000,%rdx
 8000010065c:	08 00 00 
 8000010065f:	66 89 3c 42          	mov    %di,(%rdx,%rax,2)
  if(pos < 0 || pos > 25*80)
 80000100663:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
 80000100669:	77 6f                	ja     800001006da <cgaputc+0xd4>
  if((pos/80) >= 24){  // Scroll up.
 8000010066b:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
 80000100671:	7f 7d                	jg     800001006f0 <cgaputc+0xea>
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 80000100673:	be d4 03 00 00       	mov    $0x3d4,%esi
 80000100678:	b0 0e                	mov    $0xe,%al
 8000010067a:	89 f2                	mov    %esi,%edx
 8000010067c:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
 8000010067d:	0f b6 c7             	movzbl %bh,%eax
 80000100680:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
 80000100685:	89 ca                	mov    %ecx,%edx
 80000100687:	ee                   	out    %al,(%dx)
 80000100688:	b0 0f                	mov    $0xf,%al
 8000010068a:	89 f2                	mov    %esi,%edx
 8000010068c:	ee                   	out    %al,(%dx)
 8000010068d:	88 d8                	mov    %bl,%al
 8000010068f:	89 ca                	mov    %ecx,%edx
 80000100691:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
 80000100692:	48 63 db             	movslq %ebx,%rbx
 80000100695:	48 b8 00 80 0b 00 00 	movabs $0x800000b8000,%rax
 8000010069c:	08 00 00 
 8000010069f:	66 c7 04 58 20 07    	movw   $0x720,(%rax,%rbx,2)
}
 800001006a5:	5b                   	pop    %rbx
 800001006a6:	41 5c                	pop    %r12
 800001006a8:	5d                   	pop    %rbp
 800001006a9:	c3                   	ret
    pos += 80 - pos%80;
 800001006aa:	48 63 d0             	movslq %eax,%rdx
 800001006ad:	48 69 d2 67 66 66 66 	imul   $0x66666667,%rdx,%rdx
 800001006b4:	48 c1 fa 25          	sar    $0x25,%rdx
 800001006b8:	8d 0c 92             	lea    (%rdx,%rdx,4),%ecx
 800001006bb:	c1 e1 04             	shl    $0x4,%ecx
 800001006be:	89 c2                	mov    %eax,%edx
 800001006c0:	29 ca                	sub    %ecx,%edx
 800001006c2:	bb 50 00 00 00       	mov    $0x50,%ebx
 800001006c7:	29 d3                	sub    %edx,%ebx
 800001006c9:	01 c3                	add    %eax,%ebx
 800001006cb:	eb 96                	jmp    80000100663 <cgaputc+0x5d>
    if(pos > 0) --pos;
 800001006cd:	85 c0                	test   %eax,%eax
 800001006cf:	7e 05                	jle    800001006d6 <cgaputc+0xd0>
 800001006d1:	8d 58 ff             	lea    -0x1(%rax),%ebx
 800001006d4:	eb 8d                	jmp    80000100663 <cgaputc+0x5d>
  pos |= inb(CRTPORT+1);
 800001006d6:	89 c3                	mov    %eax,%ebx
 800001006d8:	eb 89                	jmp    80000100663 <cgaputc+0x5d>
    panic("pos under/overflow");
 800001006da:	48 bf e5 a9 10 00 00 	movabs $0x8000010a9e5,%rdi
 800001006e1:	08 00 00 
 800001006e4:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001006eb:	08 00 00 
 800001006ee:	ff d0                	call   *%rax
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
 800001006f0:	ba 60 0e 00 00       	mov    $0xe60,%edx
 800001006f5:	48 be a0 80 0b 00 00 	movabs $0x800000b80a0,%rsi
 800001006fc:	08 00 00 
 800001006ff:	49 bc 00 80 0b 00 00 	movabs $0x800000b8000,%r12
 80000100706:	08 00 00 
 80000100709:	4c 89 e7             	mov    %r12,%rdi
 8000010070c:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 80000100713:	08 00 00 
 80000100716:	ff d0                	call   *%rax
    pos -= 80;
 80000100718:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
 8000010071b:	ba 80 07 00 00       	mov    $0x780,%edx
 80000100720:	29 da                	sub    %ebx,%edx
 80000100722:	48 63 c3             	movslq %ebx,%rax
 80000100725:	49 8d 3c 44          	lea    (%r12,%rax,2),%rdi
 80000100729:	d1 e2                	shl    $1,%edx
 8000010072b:	be 00 00 00 00       	mov    $0x0,%esi
 80000100730:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000100737:	08 00 00 
 8000010073a:	ff d0                	call   *%rax
 8000010073c:	e9 32 ff ff ff       	jmp    80000100673 <cgaputc+0x6d>

0000080000100741 <consputc>:
  if(panicked){
 80000100741:	a1 30 62 11 00 00 08 	movabs 0x80000116230,%eax
 80000100748:	00 00 
 8000010074a:	85 c0                	test   %eax,%eax
 8000010074c:	74 04                	je     80000100752 <consputc+0x11>
    asm volatile("cli");
 8000010074e:	fa                   	cli
 8000010074f:	90                   	nop
    for(;;)
 80000100750:	eb fe                	jmp    80000100750 <consputc+0xf>
{
 80000100752:	55                   	push   %rbp
 80000100753:	48 89 e5             	mov    %rsp,%rbp
 80000100756:	41 54                	push   %r12
 80000100758:	53                   	push   %rbx
 80000100759:	89 fb                	mov    %edi,%ebx
  if(c == BACKSPACE){
 8000010075b:	81 ff 00 01 00 00    	cmp    $0x100,%edi
 80000100761:	74 1f                	je     80000100782 <consputc+0x41>
    uartputc(c);
 80000100763:	48 b8 77 72 10 00 00 	movabs $0x80000107277,%rax
 8000010076a:	08 00 00 
 8000010076d:	ff d0                	call   *%rax
  cgaputc(c);
 8000010076f:	89 df                	mov    %ebx,%edi
 80000100771:	48 b8 06 06 10 00 00 	movabs $0x80000100606,%rax
 80000100778:	08 00 00 
 8000010077b:	ff d0                	call   *%rax
}
 8000010077d:	5b                   	pop    %rbx
 8000010077e:	41 5c                	pop    %r12
 80000100780:	5d                   	pop    %rbp
 80000100781:	c3                   	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
 80000100782:	bf 08 00 00 00       	mov    $0x8,%edi
 80000100787:	49 bc 77 72 10 00 00 	movabs $0x80000107277,%r12
 8000010078e:	08 00 00 
 80000100791:	41 ff d4             	call   *%r12
 80000100794:	bf 20 00 00 00       	mov    $0x20,%edi
 80000100799:	41 ff d4             	call   *%r12
 8000010079c:	bf 08 00 00 00       	mov    $0x8,%edi
 800001007a1:	41 ff d4             	call   *%r12
 800001007a4:	eb c9                	jmp    8000010076f <consputc+0x2e>

00000800001007a6 <printint>:
{
 800001007a6:	55                   	push   %rbp
 800001007a7:	48 89 e5             	mov    %rsp,%rbp
 800001007aa:	53                   	push   %rbx
 800001007ab:	48 83 ec 18          	sub    $0x18,%rsp
 800001007af:	41 89 f1             	mov    %esi,%r9d
 800001007b2:	41 89 d2             	mov    %edx,%r10d
  if(sign && (sign = xx < 0))
 800001007b5:	85 d2                	test   %edx,%edx
 800001007b7:	74 10                	je     800001007c9 <printint+0x23>
 800001007b9:	49 89 fa             	mov    %rdi,%r10
 800001007bc:	49 c1 ea 3f          	shr    $0x3f,%r10
 800001007c0:	45 0f b6 d2          	movzbl %r10b,%r10d
 800001007c4:	48 85 ff             	test   %rdi,%rdi
 800001007c7:	78 7d                	js     80000100846 <printint+0xa0>
  i = 0;
 800001007c9:	bb 00 00 00 00       	mov    $0x0,%ebx
 800001007ce:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 800001007d5:	00 00 00 00 
 800001007d9:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 800001007e0:	00 00 00 00 
 800001007e4:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 800001007eb:	00 00 00 00 
 800001007ef:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 800001007f6:	00 00 00 00 
 800001007fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    buf[i++] = digits[x % base];
 80000100800:	49 63 c9             	movslq %r9d,%rcx
 80000100803:	48 89 f8             	mov    %rdi,%rax
 80000100806:	ba 00 00 00 00       	mov    $0x0,%edx
 8000010080b:	48 f7 f1             	div    %rcx
 8000010080e:	89 de                	mov    %ebx,%esi
 80000100810:	83 c3 01             	add    $0x1,%ebx
 80000100813:	49 b8 10 af 10 00 00 	movabs $0x8000010af10,%r8
 8000010081a:	08 00 00 
 8000010081d:	45 8a 04 10          	mov    (%r8,%rdx,1),%r8b
 80000100821:	48 63 d6             	movslq %esi,%rdx
 80000100824:	44 88 44 15 e0       	mov    %r8b,-0x20(%rbp,%rdx,1)
  }while((x /= base) != 0);
 80000100829:	48 89 fa             	mov    %rdi,%rdx
 8000010082c:	48 89 c7             	mov    %rax,%rdi
 8000010082f:	48 39 ca             	cmp    %rcx,%rdx
 80000100832:	73 cc                	jae    80000100800 <printint+0x5a>
  if(sign)
 80000100834:	45 85 d2             	test   %r10d,%r10d
 80000100837:	74 29                	je     80000100862 <printint+0xbc>
    buf[i++] = '-';
 80000100839:	48 63 db             	movslq %ebx,%rbx
 8000010083c:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 80000100841:	8d 5e 02             	lea    0x2(%rsi),%ebx
 80000100844:	eb 1c                	jmp    80000100862 <printint+0xbc>
    x = -xx;
 80000100846:	48 f7 df             	neg    %rdi
 80000100849:	e9 7b ff ff ff       	jmp    800001007c9 <printint+0x23>
    consputc(buf[i]);
 8000010084e:	48 63 c3             	movslq %ebx,%rax
 80000100851:	0f be 7c 05 e0       	movsbl -0x20(%rbp,%rax,1),%edi
 80000100856:	48 b8 41 07 10 00 00 	movabs $0x80000100741,%rax
 8000010085d:	08 00 00 
 80000100860:	ff d0                	call   *%rax
  while(--i >= 0)
 80000100862:	83 eb 01             	sub    $0x1,%ebx
 80000100865:	79 e7                	jns    8000010084e <printint+0xa8>
}
 80000100867:	48 83 c4 18          	add    $0x18,%rsp
 8000010086b:	5b                   	pop    %rbx
 8000010086c:	5d                   	pop    %rbp
 8000010086d:	c3                   	ret

000008000010086e <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
 8000010086e:	55                   	push   %rbp
 8000010086f:	48 89 e5             	mov    %rsp,%rbp
 80000100872:	41 56                	push   %r14
 80000100874:	41 55                	push   %r13
 80000100876:	41 54                	push   %r12
 80000100878:	53                   	push   %rbx
 80000100879:	49 89 fe             	mov    %rdi,%r14
 8000010087c:	49 89 f5             	mov    %rsi,%r13
 8000010087f:	41 89 d4             	mov    %edx,%r12d
  int i;

  iunlock(ip);
 80000100882:	48 b8 2a 20 10 00 00 	movabs $0x8000010202a,%rax
 80000100889:	08 00 00 
 8000010088c:	ff d0                	call   *%rax
  acquire(&cons.lock);
 8000010088e:	48 bf c0 61 11 00 00 	movabs $0x800001161c0,%rdi
 80000100895:	08 00 00 
 80000100898:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 8000010089f:	08 00 00 
 800001008a2:	ff d0                	call   *%rax
  for(i = 0; i < n; i++)
 800001008a4:	bb 00 00 00 00       	mov    $0x0,%ebx
 800001008a9:	eb 18                	jmp    800001008c3 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
 800001008ab:	48 63 c3             	movslq %ebx,%rax
 800001008ae:	41 0f b6 7c 05 00    	movzbl 0x0(%r13,%rax,1),%edi
 800001008b4:	48 b8 41 07 10 00 00 	movabs $0x80000100741,%rax
 800001008bb:	08 00 00 
 800001008be:	ff d0                	call   *%rax
  for(i = 0; i < n; i++)
 800001008c0:	83 c3 01             	add    $0x1,%ebx
 800001008c3:	44 39 e3             	cmp    %r12d,%ebx
 800001008c6:	7c e3                	jl     800001008ab <consolewrite+0x3d>
  release(&cons.lock);
 800001008c8:	48 bf c0 61 11 00 00 	movabs $0x800001161c0,%rdi
 800001008cf:	08 00 00 
 800001008d2:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001008d9:	08 00 00 
 800001008dc:	ff d0                	call   *%rax
  ilock(ip);
 800001008de:	4c 89 f7             	mov    %r14,%rdi
 800001008e1:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 800001008e8:	08 00 00 
 800001008eb:	ff d0                	call   *%rax

  return n;
}
 800001008ed:	44 89 e0             	mov    %r12d,%eax
 800001008f0:	5b                   	pop    %rbx
 800001008f1:	41 5c                	pop    %r12
 800001008f3:	41 5d                	pop    %r13
 800001008f5:	41 5e                	pop    %r14
 800001008f7:	5d                   	pop    %rbp
 800001008f8:	c3                   	ret

00000800001008f9 <cprintf>:
{
 800001008f9:	55                   	push   %rbp
 800001008fa:	48 89 e5             	mov    %rsp,%rbp
 800001008fd:	41 57                	push   %r15
 800001008ff:	41 56                	push   %r14
 80000100901:	41 55                	push   %r13
 80000100903:	41 54                	push   %r12
 80000100905:	53                   	push   %rbx
 80000100906:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
 8000010090d:	49 89 fd             	mov    %rdi,%r13
 80000100910:	48 89 b5 28 ff ff ff 	mov    %rsi,-0xd8(%rbp)
 80000100917:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
 8000010091e:	48 89 8d 38 ff ff ff 	mov    %rcx,-0xc8(%rbp)
 80000100925:	4c 89 85 40 ff ff ff 	mov    %r8,-0xc0(%rbp)
 8000010092c:	4c 89 8d 48 ff ff ff 	mov    %r9,-0xb8(%rbp)
 80000100933:	84 c0                	test   %al,%al
 80000100935:	74 29                	je     80000100960 <cprintf+0x67>
 80000100937:	0f 29 85 50 ff ff ff 	movaps %xmm0,-0xb0(%rbp)
 8000010093e:	0f 29 8d 60 ff ff ff 	movaps %xmm1,-0xa0(%rbp)
 80000100945:	0f 29 95 70 ff ff ff 	movaps %xmm2,-0x90(%rbp)
 8000010094c:	0f 29 5d 80          	movaps %xmm3,-0x80(%rbp)
 80000100950:	0f 29 65 90          	movaps %xmm4,-0x70(%rbp)
 80000100954:	0f 29 6d a0          	movaps %xmm5,-0x60(%rbp)
 80000100958:	0f 29 75 b0          	movaps %xmm6,-0x50(%rbp)
 8000010095c:	0f 29 7d c0          	movaps %xmm7,-0x40(%rbp)
    asm volatile("movq %%rdi, %0;" 
 80000100960:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
 80000100967:	48 89 b5 e8 fe ff ff 	mov    %rsi,-0x118(%rbp)
 8000010096e:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
 80000100975:	48 89 8d f8 fe ff ff 	mov    %rcx,-0x108(%rbp)
 8000010097c:	4c 89 85 00 ff ff ff 	mov    %r8,-0x100(%rbp)
 80000100983:	4c 89 8d 08 ff ff ff 	mov    %r9,-0xf8(%rbp)
    asm volatile("leaq 16(%%rbp), %0" : "=r" (args->more_argint));
 8000010098a:	48 8d 45 10          	lea    0x10(%rbp),%rax
 8000010098e:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
    args->_index = 1;
 80000100995:	c7 85 18 ff ff ff 01 	movl   $0x1,-0xe8(%rbp)
 8000010099c:	00 00 00 
  locking = cons.locking;
 8000010099f:	48 b8 28 62 11 00 00 	movabs $0x80000116228,%rax
 800001009a6:	08 00 00 
 800001009a9:	44 8b 30             	mov    (%rax),%r14d
  if(locking)
 800001009ac:	45 85 f6             	test   %r14d,%r14d
 800001009af:	75 0c                	jne    800001009bd <cprintf+0xc4>
  if (fmt == 0)
 800001009b1:	4d 85 ed             	test   %r13,%r13
 800001009b4:	74 19                	je     800001009cf <cprintf+0xd6>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
 800001009b6:	bb 00 00 00 00       	mov    $0x0,%ebx
 800001009bb:	eb 37                	jmp    800001009f4 <cprintf+0xfb>
    acquire(&cons.lock);
 800001009bd:	48 8d 78 98          	lea    -0x68(%rax),%rdi
 800001009c1:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 800001009c8:	08 00 00 
 800001009cb:	ff d0                	call   *%rax
 800001009cd:	eb e2                	jmp    800001009b1 <cprintf+0xb8>
    panic("null fmt");
 800001009cf:	48 bf ff a9 10 00 00 	movabs $0x8000010a9ff,%rdi
 800001009d6:	08 00 00 
 800001009d9:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001009e0:	08 00 00 
 800001009e3:	ff d0                	call   *%rax
      consputc(c);
 800001009e5:	48 b8 41 07 10 00 00 	movabs $0x80000100741,%rax
 800001009ec:	08 00 00 
 800001009ef:	ff d0                	call   *%rax
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
 800001009f1:	83 c3 01             	add    $0x1,%ebx
 800001009f4:	48 63 c3             	movslq %ebx,%rax
 800001009f7:	41 0f b6 7c 05 00    	movzbl 0x0(%r13,%rax,1),%edi
 800001009fd:	85 ff                	test   %edi,%edi
 800001009ff:	0f 84 1c 01 00 00    	je     80000100b21 <cprintf+0x228>
    if(c != '%'){
 80000100a05:	83 ff 25             	cmp    $0x25,%edi
 80000100a08:	75 db                	jne    800001009e5 <cprintf+0xec>
    c = fmt[++i] & 0xff;
 80000100a0a:	83 c3 01             	add    $0x1,%ebx
 80000100a0d:	48 63 c3             	movslq %ebx,%rax
 80000100a10:	45 0f b6 64 05 00    	movzbl 0x0(%r13,%rax,1),%r12d
    if(c == 0)
 80000100a16:	45 85 e4             	test   %r12d,%r12d
 80000100a19:	0f 84 02 01 00 00    	je     80000100b21 <cprintf+0x228>
    switch(c){
 80000100a1f:	41 83 fc 70          	cmp    $0x70,%r12d
 80000100a23:	74 69                	je     80000100a8e <cprintf+0x195>
 80000100a25:	7f 3e                	jg     80000100a65 <cprintf+0x16c>
 80000100a27:	41 83 fc 25          	cmp    $0x25,%r12d
 80000100a2b:	0f 84 da 00 00 00    	je     80000100b0b <cprintf+0x212>
 80000100a31:	41 83 fc 64          	cmp    $0x64,%r12d
 80000100a35:	75 3a                	jne    80000100a71 <cprintf+0x178>
      printint(va_arg(argp, int), 10, 1);
 80000100a37:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 80000100a3e:	48 b8 00 04 10 00 00 	movabs $0x80000100400,%rax
 80000100a45:	08 00 00 
 80000100a48:	ff d0                	call   *%rax
 80000100a4a:	48 63 f8             	movslq %eax,%rdi
 80000100a4d:	ba 01 00 00 00       	mov    $0x1,%edx
 80000100a52:	be 0a 00 00 00       	mov    $0xa,%esi
 80000100a57:	48 b8 a6 07 10 00 00 	movabs $0x800001007a6,%rax
 80000100a5e:	08 00 00 
 80000100a61:	ff d0                	call   *%rax
      break;
 80000100a63:	eb 8c                	jmp    800001009f1 <cprintf+0xf8>
    switch(c){
 80000100a65:	41 83 fc 73          	cmp    $0x73,%r12d
 80000100a69:	74 54                	je     80000100abf <cprintf+0x1c6>
 80000100a6b:	41 83 fc 78          	cmp    $0x78,%r12d
 80000100a6f:	74 1d                	je     80000100a8e <cprintf+0x195>
      consputc('%');
 80000100a71:	bf 25 00 00 00       	mov    $0x25,%edi
 80000100a76:	49 bf 41 07 10 00 00 	movabs $0x80000100741,%r15
 80000100a7d:	08 00 00 
 80000100a80:	41 ff d7             	call   *%r15
      consputc(c);
 80000100a83:	44 89 e7             	mov    %r12d,%edi
 80000100a86:	41 ff d7             	call   *%r15
      break;
 80000100a89:	e9 63 ff ff ff       	jmp    800001009f1 <cprintf+0xf8>
      printint(va_arg(argp, uint64), 16, 0);
 80000100a8e:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 80000100a95:	48 b8 00 04 10 00 00 	movabs $0x80000100400,%rax
 80000100a9c:	08 00 00 
 80000100a9f:	ff d0                	call   *%rax
 80000100aa1:	48 89 c7             	mov    %rax,%rdi
 80000100aa4:	ba 00 00 00 00       	mov    $0x0,%edx
 80000100aa9:	be 10 00 00 00       	mov    $0x10,%esi
 80000100aae:	48 b8 a6 07 10 00 00 	movabs $0x800001007a6,%rax
 80000100ab5:	08 00 00 
 80000100ab8:	ff d0                	call   *%rax
      break;
 80000100aba:	e9 32 ff ff ff       	jmp    800001009f1 <cprintf+0xf8>
      if((s = va_arg(argp, char*)) == 0)
 80000100abf:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 80000100ac6:	48 b8 00 04 10 00 00 	movabs $0x80000100400,%rax
 80000100acd:	08 00 00 
 80000100ad0:	ff d0                	call   *%rax
 80000100ad2:	49 89 c4             	mov    %rax,%r12
 80000100ad5:	48 85 c0             	test   %rax,%rax
 80000100ad8:	75 20                	jne    80000100afa <cprintf+0x201>
        s = "(null)";
 80000100ada:	49 bc f8 a9 10 00 00 	movabs $0x8000010a9f8,%r12
 80000100ae1:	08 00 00 
 80000100ae4:	eb 14                	jmp    80000100afa <cprintf+0x201>
        consputc(*s);
 80000100ae6:	40 0f be ff          	movsbl %dil,%edi
 80000100aea:	48 b8 41 07 10 00 00 	movabs $0x80000100741,%rax
 80000100af1:	08 00 00 
 80000100af4:	ff d0                	call   *%rax
      for(; *s; s++)
 80000100af6:	49 83 c4 01          	add    $0x1,%r12
 80000100afa:	41 8a 3c 24          	mov    (%r12),%dil
 80000100afe:	40 0f be c7          	movsbl %dil,%eax
 80000100b02:	85 c0                	test   %eax,%eax
 80000100b04:	75 e0                	jne    80000100ae6 <cprintf+0x1ed>
 80000100b06:	e9 e6 fe ff ff       	jmp    800001009f1 <cprintf+0xf8>
      consputc('%');
 80000100b0b:	bf 25 00 00 00       	mov    $0x25,%edi
 80000100b10:	48 b8 41 07 10 00 00 	movabs $0x80000100741,%rax
 80000100b17:	08 00 00 
 80000100b1a:	ff d0                	call   *%rax
      break;
 80000100b1c:	e9 d0 fe ff ff       	jmp    800001009f1 <cprintf+0xf8>
  if(locking)
 80000100b21:	45 85 f6             	test   %r14d,%r14d
 80000100b24:	75 12                	jne    80000100b38 <cprintf+0x23f>
}
 80000100b26:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
 80000100b2d:	5b                   	pop    %rbx
 80000100b2e:	41 5c                	pop    %r12
 80000100b30:	41 5d                	pop    %r13
 80000100b32:	41 5e                	pop    %r14
 80000100b34:	41 5f                	pop    %r15
 80000100b36:	5d                   	pop    %rbp
 80000100b37:	c3                   	ret
    release(&cons.lock);
 80000100b38:	48 bf c0 61 11 00 00 	movabs $0x800001161c0,%rdi
 80000100b3f:	08 00 00 
 80000100b42:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000100b49:	08 00 00 
 80000100b4c:	ff d0                	call   *%rax
}
 80000100b4e:	eb d6                	jmp    80000100b26 <cprintf+0x22d>

0000080000100b50 <consoleintr>:
{
 80000100b50:	55                   	push   %rbp
 80000100b51:	48 89 e5             	mov    %rsp,%rbp
 80000100b54:	41 55                	push   %r13
 80000100b56:	41 54                	push   %r12
 80000100b58:	53                   	push   %rbx
 80000100b59:	48 83 ec 08          	sub    $0x8,%rsp
 80000100b5d:	49 89 fc             	mov    %rdi,%r12
  acquire(&cons.lock);
 80000100b60:	48 bf c0 61 11 00 00 	movabs $0x800001161c0,%rdi
 80000100b67:	08 00 00 
 80000100b6a:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000100b71:	08 00 00 
 80000100b74:	ff d0                	call   *%rax
  int c, doprocdump = 0;
 80000100b76:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  while((c = getc()) >= 0){
 80000100b7c:	e9 25 01 00 00       	jmp    80000100ca6 <consoleintr+0x156>
    switch(c){
 80000100b81:	83 fb 7f             	cmp    $0x7f,%ebx
 80000100b84:	0f 84 04 01 00 00    	je     80000100c8e <consoleintr+0x13e>
      if(c != 0 && input.e-input.r < INPUT_BUF){
 80000100b8a:	85 db                	test   %ebx,%ebx
 80000100b8c:	0f 84 14 01 00 00    	je     80000100ca6 <consoleintr+0x156>
 80000100b92:	48 ba 20 61 11 00 00 	movabs $0x80000116120,%rdx
 80000100b99:	08 00 00 
 80000100b9c:	8b 82 88 00 00 00    	mov    0x88(%rdx),%eax
 80000100ba2:	89 c6                	mov    %eax,%esi
 80000100ba4:	2b b2 80 00 00 00    	sub    0x80(%rdx),%esi
 80000100baa:	83 fe 7f             	cmp    $0x7f,%esi
 80000100bad:	0f 87 f3 00 00 00    	ja     80000100ca6 <consoleintr+0x156>
        c = (c == '\r') ? '\n' : c;
 80000100bb3:	83 fb 0d             	cmp    $0xd,%ebx
 80000100bb6:	0f 84 33 01 00 00    	je     80000100cef <consoleintr+0x19f>
        input.buf[input.e++ % INPUT_BUF] = c;
 80000100bbc:	48 ba 20 61 11 00 00 	movabs $0x80000116120,%rdx
 80000100bc3:	08 00 00 
 80000100bc6:	8d 48 01             	lea    0x1(%rax),%ecx
 80000100bc9:	89 8a 88 00 00 00    	mov    %ecx,0x88(%rdx)
 80000100bcf:	83 e0 7f             	and    $0x7f,%eax
 80000100bd2:	88 1c 02             	mov    %bl,(%rdx,%rax,1)
        consputc(c);
 80000100bd5:	89 df                	mov    %ebx,%edi
 80000100bd7:	48 b8 41 07 10 00 00 	movabs $0x80000100741,%rax
 80000100bde:	08 00 00 
 80000100be1:	ff d0                	call   *%rax
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
 80000100be3:	83 fb 0a             	cmp    $0xa,%ebx
 80000100be6:	0f 94 c0             	sete   %al
 80000100be9:	83 fb 04             	cmp    $0x4,%ebx
 80000100bec:	0f 94 c2             	sete   %dl
 80000100bef:	09 d0                	or     %edx,%eax
 80000100bf1:	a8 ff                	test   $0xff,%al
 80000100bf3:	75 1f                	jne    80000100c14 <consoleintr+0xc4>
 80000100bf5:	48 ba 20 61 11 00 00 	movabs $0x80000116120,%rdx
 80000100bfc:	08 00 00 
 80000100bff:	8b 82 80 00 00 00    	mov    0x80(%rdx),%eax
 80000100c05:	83 e8 80             	sub    $0xffffff80,%eax
 80000100c08:	39 82 88 00 00 00    	cmp    %eax,0x88(%rdx)
 80000100c0e:	0f 85 92 00 00 00    	jne    80000100ca6 <consoleintr+0x156>
          input.w = input.e;
 80000100c14:	48 b8 20 61 11 00 00 	movabs $0x80000116120,%rax
 80000100c1b:	08 00 00 
 80000100c1e:	8b 90 88 00 00 00    	mov    0x88(%rax),%edx
 80000100c24:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
          wakeup(&input.r);
 80000100c2a:	48 8d b8 80 00 00 00 	lea    0x80(%rax),%rdi
 80000100c31:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 80000100c38:	08 00 00 
 80000100c3b:	ff d0                	call   *%rax
 80000100c3d:	eb 67                	jmp    80000100ca6 <consoleintr+0x156>
        input.e--;
 80000100c3f:	a3 a8 61 11 00 00 08 	movabs %eax,0x800001161a8
 80000100c46:	00 00 
        consputc(BACKSPACE);
 80000100c48:	bf 00 01 00 00       	mov    $0x100,%edi
 80000100c4d:	48 b8 41 07 10 00 00 	movabs $0x80000100741,%rax
 80000100c54:	08 00 00 
 80000100c57:	ff d0                	call   *%rax
      while(input.e != input.w &&
 80000100c59:	48 ba 20 61 11 00 00 	movabs $0x80000116120,%rdx
 80000100c60:	08 00 00 
 80000100c63:	8b 82 88 00 00 00    	mov    0x88(%rdx),%eax
 80000100c69:	3b 82 84 00 00 00    	cmp    0x84(%rdx),%eax
 80000100c6f:	74 35                	je     80000100ca6 <consoleintr+0x156>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
 80000100c71:	83 e8 01             	sub    $0x1,%eax
 80000100c74:	89 c2                	mov    %eax,%edx
 80000100c76:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
 80000100c79:	48 b9 20 61 11 00 00 	movabs $0x80000116120,%rcx
 80000100c80:	08 00 00 
 80000100c83:	0f be 14 11          	movsbl (%rcx,%rdx,1),%edx
 80000100c87:	83 fa 0a             	cmp    $0xa,%edx
 80000100c8a:	75 b3                	jne    80000100c3f <consoleintr+0xef>
 80000100c8c:	eb 18                	jmp    80000100ca6 <consoleintr+0x156>
      if(input.e != input.w){
 80000100c8e:	48 ba 20 61 11 00 00 	movabs $0x80000116120,%rdx
 80000100c95:	08 00 00 
 80000100c98:	8b 82 88 00 00 00    	mov    0x88(%rdx),%eax
 80000100c9e:	3b 82 84 00 00 00    	cmp    0x84(%rdx),%eax
 80000100ca4:	75 2a                	jne    80000100cd0 <consoleintr+0x180>
  while((c = getc()) >= 0){
 80000100ca6:	41 ff d4             	call   *%r12
 80000100ca9:	89 c3                	mov    %eax,%ebx
 80000100cab:	85 c0                	test   %eax,%eax
 80000100cad:	78 4a                	js     80000100cf9 <consoleintr+0x1a9>
    switch(c){
 80000100caf:	83 fb 15             	cmp    $0x15,%ebx
 80000100cb2:	74 a5                	je     80000100c59 <consoleintr+0x109>
 80000100cb4:	0f 8f c7 fe ff ff    	jg     80000100b81 <consoleintr+0x31>
 80000100cba:	83 fb 08             	cmp    $0x8,%ebx
 80000100cbd:	74 cf                	je     80000100c8e <consoleintr+0x13e>
 80000100cbf:	83 fb 10             	cmp    $0x10,%ebx
 80000100cc2:	0f 85 c2 fe ff ff    	jne    80000100b8a <consoleintr+0x3a>
 80000100cc8:	41 bd 01 00 00 00    	mov    $0x1,%r13d
 80000100cce:	eb d6                	jmp    80000100ca6 <consoleintr+0x156>
        input.e--;
 80000100cd0:	83 e8 01             	sub    $0x1,%eax
 80000100cd3:	a3 a8 61 11 00 00 08 	movabs %eax,0x800001161a8
 80000100cda:	00 00 
        consputc(BACKSPACE);
 80000100cdc:	bf 00 01 00 00       	mov    $0x100,%edi
 80000100ce1:	48 b8 41 07 10 00 00 	movabs $0x80000100741,%rax
 80000100ce8:	08 00 00 
 80000100ceb:	ff d0                	call   *%rax
 80000100ced:	eb b7                	jmp    80000100ca6 <consoleintr+0x156>
        c = (c == '\r') ? '\n' : c;
 80000100cef:	bb 0a 00 00 00       	mov    $0xa,%ebx
 80000100cf4:	e9 c3 fe ff ff       	jmp    80000100bbc <consoleintr+0x6c>
  release(&cons.lock);
 80000100cf9:	48 bf c0 61 11 00 00 	movabs $0x800001161c0,%rdi
 80000100d00:	08 00 00 
 80000100d03:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000100d0a:	08 00 00 
 80000100d0d:	ff d0                	call   *%rax
  if(doprocdump) {
 80000100d0f:	45 85 ed             	test   %r13d,%r13d
 80000100d12:	75 0b                	jne    80000100d1f <consoleintr+0x1cf>
}
 80000100d14:	48 83 c4 08          	add    $0x8,%rsp
 80000100d18:	5b                   	pop    %rbx
 80000100d19:	41 5c                	pop    %r12
 80000100d1b:	41 5d                	pop    %r13
 80000100d1d:	5d                   	pop    %rbp
 80000100d1e:	c3                   	ret
    procdump();  // now call procdump() wo. cons.lock held
 80000100d1f:	48 b8 03 51 10 00 00 	movabs $0x80000105103,%rax
 80000100d26:	08 00 00 
 80000100d29:	ff d0                	call   *%rax
}
 80000100d2b:	eb e7                	jmp    80000100d14 <consoleintr+0x1c4>

0000080000100d2d <consoleinit>:

void
consoleinit(void)
{
 80000100d2d:	55                   	push   %rbp
 80000100d2e:	48 89 e5             	mov    %rsp,%rbp
 80000100d31:	53                   	push   %rbx
 80000100d32:	48 83 ec 08          	sub    $0x8,%rsp
  initlock(&cons.lock, "console");
 80000100d36:	48 be 08 aa 10 00 00 	movabs $0x8000010aa08,%rsi
 80000100d3d:	08 00 00 
 80000100d40:	48 bb c0 61 11 00 00 	movabs $0x800001161c0,%rbx
 80000100d47:	08 00 00 
 80000100d4a:	48 89 df             	mov    %rbx,%rdi
 80000100d4d:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 80000100d54:	08 00 00 
 80000100d57:	ff d0                	call   *%rax

  devsw[CONSOLE].write = consolewrite;
 80000100d59:	48 b8 60 72 11 00 00 	movabs $0x80000117260,%rax
 80000100d60:	08 00 00 
 80000100d63:	48 ba 6e 08 10 00 00 	movabs $0x8000010086e,%rdx
 80000100d6a:	08 00 00 
 80000100d6d:	48 89 50 18          	mov    %rdx,0x18(%rax)
  devsw[CONSOLE].read = consoleread;
 80000100d71:	48 b9 2a 04 10 00 00 	movabs $0x8000010042a,%rcx
 80000100d78:	08 00 00 
 80000100d7b:	48 89 48 10          	mov    %rcx,0x10(%rax)
  cons.locking = 1;
 80000100d7f:	c7 43 68 01 00 00 00 	movl   $0x1,0x68(%rbx)

  ioapicenable(IRQ_KBD, 0);
 80000100d86:	be 00 00 00 00       	mov    $0x0,%esi
 80000100d8b:	bf 01 00 00 00       	mov    $0x1,%edi
 80000100d90:	48 b8 91 2c 10 00 00 	movabs $0x80000102c91,%rax
 80000100d97:	08 00 00 
 80000100d9a:	ff d0                	call   *%rax
}
 80000100d9c:	48 83 c4 08          	add    $0x8,%rsp
 80000100da0:	5b                   	pop    %rbx
 80000100da1:	5d                   	pop    %rbp
 80000100da2:	c3                   	ret
 80000100da3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 80000100daa:	00 00 00 
 80000100dad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 80000100db4:	00 00 00 
 80000100db7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 80000100dbe:	00 00 

0000080000100dc0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
 80000100dc0:	55                   	push   %rbp
 80000100dc1:	48 89 e5             	mov    %rsp,%rbp
 80000100dc4:	41 57                	push   %r15
 80000100dc6:	41 56                	push   %r14
 80000100dc8:	41 55                	push   %r13
 80000100dca:	41 54                	push   %r12
 80000100dcc:	53                   	push   %rbx
 80000100dcd:	48 81 ec c8 01 00 00 	sub    $0x1c8,%rsp
 80000100dd4:	48 89 fb             	mov    %rdi,%rbx
 80000100dd7:	48 89 bd 20 fe ff ff 	mov    %rdi,-0x1e0(%rbp)
 80000100dde:	48 89 b5 28 fe ff ff 	mov    %rsi,-0x1d8(%rbp)
  uint64 argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pml4e_t *pml4, *oldpml4;
  struct proc *curproc = myproc();
 80000100de5:	b0 00                	mov    $0x0,%al
 80000100de7:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000100dee:	08 00 00 
 80000100df1:	ff d2                	call   *%rdx
 80000100df3:	48 89 85 18 fe ff ff 	mov    %rax,-0x1e8(%rbp)

  begin_op();
 80000100dfa:	b0 00                	mov    $0x0,%al
 80000100dfc:	48 ba 72 37 10 00 00 	movabs $0x80000103772,%rdx
 80000100e03:	08 00 00 
 80000100e06:	ff d2                	call   *%rdx

  if((ip = namei(path)) == 0){
 80000100e08:	48 89 df             	mov    %rbx,%rdi
 80000100e0b:	48 b8 c3 27 10 00 00 	movabs $0x800001027c3,%rax
 80000100e12:	08 00 00 
 80000100e15:	ff d0                	call   *%rax
 80000100e17:	48 85 c0             	test   %rax,%rax
 80000100e1a:	0f 84 80 00 00 00    	je     80000100ea0 <exec+0xe0>
 80000100e20:	48 89 c3             	mov    %rax,%rbx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
 80000100e23:	48 89 c7             	mov    %rax,%rdi
 80000100e26:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 80000100e2d:	08 00 00 
 80000100e30:	ff d0                	call   *%rax
  pml4 = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
 80000100e32:	48 8d b5 70 fe ff ff 	lea    -0x190(%rbp),%rsi
 80000100e39:	b9 40 00 00 00       	mov    $0x40,%ecx
 80000100e3e:	ba 00 00 00 00       	mov    $0x0,%edx
 80000100e43:	48 89 df             	mov    %rbx,%rdi
 80000100e46:	48 b8 bd 21 10 00 00 	movabs $0x800001021bd,%rax
 80000100e4d:	08 00 00 
 80000100e50:	ff d0                	call   *%rax
 80000100e52:	83 f8 40             	cmp    $0x40,%eax
 80000100e55:	75 0c                	jne    80000100e63 <exec+0xa3>
    goto bad;
  if(elf.magic != ELF_MAGIC)
 80000100e57:	81 bd 70 fe ff ff 7f 	cmpl   $0x464c457f,-0x190(%rbp)
 80000100e5e:	45 4c 46 
 80000100e61:	74 6a                	je     80000100ecd <exec+0x10d>
  return 0;

 bad:
  if(pml4)
    freevm(pml4);
  if(ip){
 80000100e63:	48 85 db             	test   %rbx,%rbx
 80000100e66:	0f 84 81 03 00 00    	je     800001011ed <exec+0x42d>
    iunlockput(ip);
 80000100e6c:	48 89 df             	mov    %rbx,%rdi
 80000100e6f:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000100e76:	08 00 00 
 80000100e79:	ff d0                	call   *%rax
    end_op();
 80000100e7b:	b0 00                	mov    $0x0,%al
 80000100e7d:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000100e84:	08 00 00 
 80000100e87:	ff d2                	call   *%rdx
  }
  return -1;
 80000100e89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 80000100e8e:	48 81 c4 c8 01 00 00 	add    $0x1c8,%rsp
 80000100e95:	5b                   	pop    %rbx
 80000100e96:	41 5c                	pop    %r12
 80000100e98:	41 5d                	pop    %r13
 80000100e9a:	41 5e                	pop    %r14
 80000100e9c:	41 5f                	pop    %r15
 80000100e9e:	5d                   	pop    %rbp
 80000100e9f:	c3                   	ret
    end_op();
 80000100ea0:	b0 00                	mov    $0x0,%al
 80000100ea2:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000100ea9:	08 00 00 
 80000100eac:	ff d2                	call   *%rdx
    cprintf("exec: fail\n");
 80000100eae:	48 bf 10 aa 10 00 00 	movabs $0x8000010aa10,%rdi
 80000100eb5:	08 00 00 
 80000100eb8:	b0 00                	mov    $0x0,%al
 80000100eba:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000100ec1:	08 00 00 
 80000100ec4:	ff d2                	call   *%rdx
    return -1;
 80000100ec6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000100ecb:	eb c1                	jmp    80000100e8e <exec+0xce>
  if((pml4 = setupkvm()) == 0)
 80000100ecd:	48 b8 d3 8a 10 00 00 	movabs $0x80000108ad3,%rax
 80000100ed4:	08 00 00 
 80000100ed7:	ff d0                	call   *%rax
 80000100ed9:	49 89 c7             	mov    %rax,%r15
 80000100edc:	48 85 c0             	test   %rax,%rax
 80000100edf:	74 82                	je     80000100e63 <exec+0xa3>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
 80000100ee1:	8b 95 90 fe ff ff    	mov    -0x170(%rbp),%edx
  sz = 0;
 80000100ee7:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
 80000100eed:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 80000100ef3:	eb 08                	jmp    80000100efd <exec+0x13d>
 80000100ef5:	41 83 c4 01          	add    $0x1,%r12d
 80000100ef9:	41 8d 56 38          	lea    0x38(%r14),%edx
 80000100efd:	0f b7 85 a8 fe ff ff 	movzwl -0x158(%rbp),%eax
 80000100f04:	44 39 e0             	cmp    %r12d,%eax
 80000100f07:	0f 8e a7 00 00 00    	jle    80000100fb4 <exec+0x1f4>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
 80000100f0d:	41 89 d6             	mov    %edx,%r14d
 80000100f10:	48 8d b5 30 fe ff ff 	lea    -0x1d0(%rbp),%rsi
 80000100f17:	b9 38 00 00 00       	mov    $0x38,%ecx
 80000100f1c:	48 89 df             	mov    %rbx,%rdi
 80000100f1f:	48 b8 bd 21 10 00 00 	movabs $0x800001021bd,%rax
 80000100f26:	08 00 00 
 80000100f29:	ff d0                	call   *%rax
 80000100f2b:	83 f8 38             	cmp    $0x38,%eax
 80000100f2e:	0f 85 d5 00 00 00    	jne    80000101009 <exec+0x249>
    if(ph.type != ELF_PROG_LOAD)
 80000100f34:	83 bd 30 fe ff ff 01 	cmpl   $0x1,-0x1d0(%rbp)
 80000100f3b:	75 b8                	jne    80000100ef5 <exec+0x135>
    if(ph.memsz < ph.filesz)
 80000100f3d:	48 8b 95 58 fe ff ff 	mov    -0x1a8(%rbp),%rdx
 80000100f44:	48 3b 95 50 fe ff ff 	cmp    -0x1b0(%rbp),%rdx
 80000100f4b:	0f 82 b8 00 00 00    	jb     80000101009 <exec+0x249>
    if(ph.vaddr + ph.memsz < ph.vaddr)
 80000100f51:	48 03 95 40 fe ff ff 	add    -0x1c0(%rbp),%rdx
 80000100f58:	0f 82 ab 00 00 00    	jb     80000101009 <exec+0x249>
    if((sz = allocuvm(pml4, sz, ph.vaddr + ph.memsz)) == 0)
 80000100f5e:	4c 89 ee             	mov    %r13,%rsi
 80000100f61:	4c 89 ff             	mov    %r15,%rdi
 80000100f64:	48 b8 a3 88 10 00 00 	movabs $0x800001088a3,%rax
 80000100f6b:	08 00 00 
 80000100f6e:	ff d0                	call   *%rax
 80000100f70:	4c 63 e8             	movslq %eax,%r13
 80000100f73:	4d 85 ed             	test   %r13,%r13
 80000100f76:	0f 84 8d 00 00 00    	je     80000101009 <exec+0x249>
    if(ph.vaddr % PGSIZE != 0)
 80000100f7c:	48 8b b5 40 fe ff ff 	mov    -0x1c0(%rbp),%rsi
 80000100f83:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
 80000100f89:	75 7e                	jne    80000101009 <exec+0x249>
    if(loaduvm(pml4, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
 80000100f8b:	4c 8b 85 50 fe ff ff 	mov    -0x1b0(%rbp),%r8
 80000100f92:	8b 8d 38 fe ff ff    	mov    -0x1c8(%rbp),%ecx
 80000100f98:	48 89 da             	mov    %rbx,%rdx
 80000100f9b:	4c 89 ff             	mov    %r15,%rdi
 80000100f9e:	48 b8 d1 86 10 00 00 	movabs $0x800001086d1,%rax
 80000100fa5:	08 00 00 
 80000100fa8:	ff d0                	call   *%rax
 80000100faa:	85 c0                	test   %eax,%eax
 80000100fac:	0f 89 43 ff ff ff    	jns    80000100ef5 <exec+0x135>
 80000100fb2:	eb 55                	jmp    80000101009 <exec+0x249>
  iunlockput(ip);
 80000100fb4:	48 89 df             	mov    %rbx,%rdi
 80000100fb7:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000100fbe:	08 00 00 
 80000100fc1:	ff d0                	call   *%rax
  end_op();
 80000100fc3:	b0 00                	mov    $0x0,%al
 80000100fc5:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000100fcc:	08 00 00 
 80000100fcf:	ff d2                	call   *%rdx
  sz = PGROUNDUP(sz);
 80000100fd1:	49 8d b5 ff 0f 00 00 	lea    0xfff(%r13),%rsi
 80000100fd8:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  if((sz = allocuvm(pml4, sz, sz + 2*PGSIZE)) == 0)
 80000100fdf:	48 8d 96 00 20 00 00 	lea    0x2000(%rsi),%rdx
 80000100fe6:	4c 89 ff             	mov    %r15,%rdi
 80000100fe9:	48 b8 a3 88 10 00 00 	movabs $0x800001088a3,%rax
 80000100ff0:	08 00 00 
 80000100ff3:	ff d0                	call   *%rax
 80000100ff5:	4c 63 f0             	movslq %eax,%r14
 80000100ff8:	4c 89 b5 10 fe ff ff 	mov    %r14,-0x1f0(%rbp)
 80000100fff:	4d 85 f6             	test   %r14,%r14
 80000101002:	75 19                	jne    8000010101d <exec+0x25d>
  ip = 0;
 80000101004:	bb 00 00 00 00       	mov    $0x0,%ebx
    freevm(pml4);
 80000101009:	4c 89 ff             	mov    %r15,%rdi
 8000010100c:	48 b8 76 8a 10 00 00 	movabs $0x80000108a76,%rax
 80000101013:	08 00 00 
 80000101016:	ff d0                	call   *%rax
 80000101018:	e9 46 fe ff ff       	jmp    80000100e63 <exec+0xa3>
  clearpteu(pml4, (char*)(sz - 2*PGSIZE));
 8000010101d:	49 8d b6 00 e0 ff ff 	lea    -0x2000(%r14),%rsi
 80000101024:	4c 89 ff             	mov    %r15,%rdi
 80000101027:	48 b8 8e 8b 10 00 00 	movabs $0x80000108b8e,%rax
 8000010102e:	08 00 00 
 80000101031:	ff d0                	call   *%rax
  for(argc = 0; argv[argc]; argc++) {
 80000101033:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 80000101039:	eb 0c                	jmp    80000101047 <exec+0x287>
    ustack[1+argc] = sp;
 8000010103b:	49 83 c4 01          	add    $0x1,%r12
 8000010103f:	4e 89 b4 e5 b0 fe ff 	mov    %r14,-0x150(%rbp,%r12,8)
 80000101046:	ff 
  for(argc = 0; argv[argc]; argc++) {
 80000101047:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
 8000010104e:	4e 8d 2c e0          	lea    (%rax,%r12,8),%r13
 80000101052:	49 8b 5d 00          	mov    0x0(%r13),%rbx
 80000101056:	48 85 db             	test   %rbx,%rbx
 80000101059:	74 58                	je     800001010b3 <exec+0x2f3>
    if(argc >= MAXARG)
 8000010105b:	49 83 fc 1f          	cmp    $0x1f,%r12
 8000010105f:	0f 87 7e 01 00 00    	ja     800001011e3 <exec+0x423>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~7;
 80000101065:	48 89 df             	mov    %rbx,%rdi
 80000101068:	48 bb e9 57 10 00 00 	movabs $0x800001057e9,%rbx
 8000010106f:	08 00 00 
 80000101072:	ff d3                	call   *%rbx
 80000101074:	83 c0 01             	add    $0x1,%eax
 80000101077:	48 98                	cltq
 80000101079:	4c 89 f2             	mov    %r14,%rdx
 8000010107c:	48 29 c2             	sub    %rax,%rdx
 8000010107f:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
 80000101083:	49 89 d6             	mov    %rdx,%r14
    if(copyout(pml4, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
 80000101086:	49 8b 7d 00          	mov    0x0(%r13),%rdi
 8000010108a:	ff d3                	call   *%rbx
 8000010108c:	8d 48 01             	lea    0x1(%rax),%ecx
 8000010108f:	49 8b 55 00          	mov    0x0(%r13),%rdx
 80000101093:	44 89 f6             	mov    %r14d,%esi
 80000101096:	4c 89 ff             	mov    %r15,%rdi
 80000101099:	48 b8 6f 8d 10 00 00 	movabs $0x80000108d6f,%rax
 800001010a0:	08 00 00 
 800001010a3:	ff d0                	call   *%rax
 800001010a5:	85 c0                	test   %eax,%eax
 800001010a7:	79 92                	jns    8000010103b <exec+0x27b>
  ip = 0;
 800001010a9:	bb 00 00 00 00       	mov    $0x0,%ebx
 800001010ae:	e9 56 ff ff ff       	jmp    80000101009 <exec+0x249>
  ustack[1+argc] = 0;
 800001010b3:	49 8d 44 24 01       	lea    0x1(%r12),%rax
 800001010b8:	48 c7 84 c5 b0 fe ff 	movq   $0x0,-0x150(%rbp,%rax,8)
 800001010bf:	ff 00 00 00 00 
  ustack[0] = 0xffffffffffffffff;  // fake return PC
 800001010c4:	48 c7 85 b0 fe ff ff 	movq   $0xffffffffffffffff,-0x150(%rbp)
 800001010cb:	ff ff ff ff 
  curproc->tf->rdi = argc;
 800001010cf:	48 8b 8d 18 fe ff ff 	mov    -0x1e8(%rbp),%rcx
 800001010d6:	48 8b 51 28          	mov    0x28(%rcx),%rdx
 800001010da:	4c 89 62 30          	mov    %r12,0x30(%rdx)
  curproc->tf->rsi = sp - (argc+1)*8;  // argv pointer
 800001010de:	48 c1 e0 03          	shl    $0x3,%rax
 800001010e2:	48 8b 51 28          	mov    0x28(%rcx),%rdx
 800001010e6:	4c 89 f1             	mov    %r14,%rcx
 800001010e9:	48 29 c1             	sub    %rax,%rcx
 800001010ec:	48 89 4a 28          	mov    %rcx,0x28(%rdx)
  sp -= (1+argc+1) * 8;
 800001010f0:	49 83 c4 02          	add    $0x2,%r12
 800001010f4:	4a 8d 04 e5 00 00 00 	lea    0x0(,%r12,8),%rax
 800001010fb:	00 
 800001010fc:	49 29 c6             	sub    %rax,%r14
  if(copyout(pml4, sp, ustack, (1+argc+1)*8) < 0)
 800001010ff:	42 8d 0c e5 00 00 00 	lea    0x0(,%r12,8),%ecx
 80000101106:	00 
 80000101107:	48 8d 95 b0 fe ff ff 	lea    -0x150(%rbp),%rdx
 8000010110e:	44 89 f6             	mov    %r14d,%esi
 80000101111:	4c 89 ff             	mov    %r15,%rdi
 80000101114:	48 b8 6f 8d 10 00 00 	movabs $0x80000108d6f,%rax
 8000010111b:	08 00 00 
 8000010111e:	ff d0                	call   *%rax
 80000101120:	85 c0                	test   %eax,%eax
 80000101122:	0f 88 e1 fe ff ff    	js     80000101009 <exec+0x249>
  for(last=s=path; *s; s++)
 80000101128:	48 8b b5 20 fe ff ff 	mov    -0x1e0(%rbp),%rsi
 8000010112f:	eb 17                	jmp    80000101148 <exec+0x388>
 80000101131:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000101138:	00 00 00 00 
 8000010113c:	0f 1f 40 00          	nopl   0x0(%rax)
 80000101140:	48 83 85 20 fe ff ff 	addq   $0x1,-0x1e0(%rbp)
 80000101147:	01 
 80000101148:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
 8000010114f:	8a 00                	mov    (%rax),%al
 80000101151:	0f be d0             	movsbl %al,%edx
 80000101154:	85 d2                	test   %edx,%edx
 80000101156:	74 15                	je     8000010116d <exec+0x3ad>
    if(*s == '/')
 80000101158:	0f be c0             	movsbl %al,%eax
 8000010115b:	83 f8 2f             	cmp    $0x2f,%eax
 8000010115e:	75 e0                	jne    80000101140 <exec+0x380>
      last = s+1;
 80000101160:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
 80000101167:	48 8d 70 01          	lea    0x1(%rax),%rsi
 8000010116b:	eb d3                	jmp    80000101140 <exec+0x380>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
 8000010116d:	48 8b 9d 18 fe ff ff 	mov    -0x1e8(%rbp),%rbx
 80000101174:	48 8d bb d0 00 00 00 	lea    0xd0(%rbx),%rdi
 8000010117b:	ba 10 00 00 00       	mov    $0x10,%edx
 80000101180:	48 b8 93 57 10 00 00 	movabs $0x80000105793,%rax
 80000101187:	08 00 00 
 8000010118a:	ff d0                	call   *%rax
  oldpml4 = curproc->pml4;
 8000010118c:	48 89 df             	mov    %rbx,%rdi
 8000010118f:	48 8b 5b 08          	mov    0x8(%rbx),%rbx
  curproc->pml4 = pml4;
 80000101193:	4c 89 7f 08          	mov    %r15,0x8(%rdi)
  curproc->sz = sz;
 80000101197:	48 8b 8d 10 fe ff ff 	mov    -0x1f0(%rbp),%rcx
 8000010119e:	48 89 0f             	mov    %rcx,(%rdi)
  curproc->tf->rip = elf.entry;  // main
 800001011a1:	48 8b 47 28          	mov    0x28(%rdi),%rax
 800001011a5:	48 8b 95 88 fe ff ff 	mov    -0x178(%rbp),%rdx
 800001011ac:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
  curproc->tf->rsp = sp;
 800001011b3:	48 8b 47 28          	mov    0x28(%rdi),%rax
 800001011b7:	4c 89 b0 a0 00 00 00 	mov    %r14,0xa0(%rax)
  switchuvm(curproc);
 800001011be:	48 b8 4c 84 10 00 00 	movabs $0x8000010844c,%rax
 800001011c5:	08 00 00 
 800001011c8:	ff d0                	call   *%rax
  freevm(oldpml4);
 800001011ca:	48 89 df             	mov    %rbx,%rdi
 800001011cd:	48 b8 76 8a 10 00 00 	movabs $0x80000108a76,%rax
 800001011d4:	08 00 00 
 800001011d7:	ff d0                	call   *%rax
  return 0;
 800001011d9:	b8 00 00 00 00       	mov    $0x0,%eax
 800001011de:	e9 ab fc ff ff       	jmp    80000100e8e <exec+0xce>
  ip = 0;
 800001011e3:	bb 00 00 00 00       	mov    $0x0,%ebx
 800001011e8:	e9 1c fe ff ff       	jmp    80000101009 <exec+0x249>
  return -1;
 800001011ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 800001011f2:	e9 97 fc ff ff       	jmp    80000100e8e <exec+0xce>

00000800001011f7 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
 800001011f7:	55                   	push   %rbp
 800001011f8:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ftable.lock, "ftable");
 800001011fb:	48 be 1c aa 10 00 00 	movabs $0x8000010aa1c,%rsi
 80000101202:	08 00 00 
 80000101205:	48 bf 40 62 11 00 00 	movabs $0x80000116240,%rdi
 8000010120c:	08 00 00 
 8000010120f:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 80000101216:	08 00 00 
 80000101219:	ff d0                	call   *%rax
}
 8000010121b:	5d                   	pop    %rbp
 8000010121c:	c3                   	ret

000008000010121d <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
 8000010121d:	55                   	push   %rbp
 8000010121e:	48 89 e5             	mov    %rsp,%rbp
 80000101221:	53                   	push   %rbx
 80000101222:	48 83 ec 08          	sub    $0x8,%rsp
  struct file *f;

  acquire(&ftable.lock);
 80000101226:	48 bf 40 62 11 00 00 	movabs $0x80000116240,%rdi
 8000010122d:	08 00 00 
 80000101230:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000101237:	08 00 00 
 8000010123a:	ff d0                	call   *%rax
  for(f = ftable.file; f < ftable.file + NFILE; f++){
 8000010123c:	48 bb a8 62 11 00 00 	movabs $0x800001162a8,%rbx
 80000101243:	08 00 00 
 80000101246:	48 b8 48 72 11 00 00 	movabs $0x80000117248,%rax
 8000010124d:	08 00 00 
 80000101250:	48 39 c3             	cmp    %rax,%rbx
 80000101253:	73 33                	jae    80000101288 <filealloc+0x6b>
    if(f->ref == 0){
 80000101255:	83 7b 04 00          	cmpl   $0x0,0x4(%rbx)
 80000101259:	74 06                	je     80000101261 <filealloc+0x44>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
 8000010125b:	48 83 c3 28          	add    $0x28,%rbx
 8000010125f:	eb e5                	jmp    80000101246 <filealloc+0x29>
      f->ref = 1;
 80000101261:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%rbx)
      release(&ftable.lock);
 80000101268:	48 bf 40 62 11 00 00 	movabs $0x80000116240,%rdi
 8000010126f:	08 00 00 
 80000101272:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000101279:	08 00 00 
 8000010127c:	ff d0                	call   *%rax
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
 8000010127e:	48 89 d8             	mov    %rbx,%rax
 80000101281:	48 83 c4 08          	add    $0x8,%rsp
 80000101285:	5b                   	pop    %rbx
 80000101286:	5d                   	pop    %rbp
 80000101287:	c3                   	ret
  release(&ftable.lock);
 80000101288:	48 8d b8 f8 ef ff ff 	lea    -0x1008(%rax),%rdi
 8000010128f:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000101296:	08 00 00 
 80000101299:	ff d0                	call   *%rax
  return 0;
 8000010129b:	bb 00 00 00 00       	mov    $0x0,%ebx
 800001012a0:	eb dc                	jmp    8000010127e <filealloc+0x61>

00000800001012a2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
 800001012a2:	55                   	push   %rbp
 800001012a3:	48 89 e5             	mov    %rsp,%rbp
 800001012a6:	53                   	push   %rbx
 800001012a7:	48 83 ec 08          	sub    $0x8,%rsp
 800001012ab:	48 89 fb             	mov    %rdi,%rbx
  acquire(&ftable.lock);
 800001012ae:	48 bf 40 62 11 00 00 	movabs $0x80000116240,%rdi
 800001012b5:	08 00 00 
 800001012b8:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 800001012bf:	08 00 00 
 800001012c2:	ff d0                	call   *%rax
  if(f->ref < 1)
 800001012c4:	8b 43 04             	mov    0x4(%rbx),%eax
 800001012c7:	85 c0                	test   %eax,%eax
 800001012c9:	7e 26                	jle    800001012f1 <filedup+0x4f>
    panic("filedup");
  f->ref++;
 800001012cb:	83 c0 01             	add    $0x1,%eax
 800001012ce:	89 43 04             	mov    %eax,0x4(%rbx)
  release(&ftable.lock);
 800001012d1:	48 bf 40 62 11 00 00 	movabs $0x80000116240,%rdi
 800001012d8:	08 00 00 
 800001012db:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001012e2:	08 00 00 
 800001012e5:	ff d0                	call   *%rax
  return f;
}
 800001012e7:	48 89 d8             	mov    %rbx,%rax
 800001012ea:	48 83 c4 08          	add    $0x8,%rsp
 800001012ee:	5b                   	pop    %rbx
 800001012ef:	5d                   	pop    %rbp
 800001012f0:	c3                   	ret
    panic("filedup");
 800001012f1:	48 bf 23 aa 10 00 00 	movabs $0x8000010aa23,%rdi
 800001012f8:	08 00 00 
 800001012fb:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000101302:	08 00 00 
 80000101305:	ff d0                	call   *%rax

0000080000101307 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
 80000101307:	55                   	push   %rbp
 80000101308:	48 89 e5             	mov    %rsp,%rbp
 8000010130b:	53                   	push   %rbx
 8000010130c:	48 83 ec 38          	sub    $0x38,%rsp
 80000101310:	48 89 fb             	mov    %rdi,%rbx
  struct file ff;

  acquire(&ftable.lock);
 80000101313:	48 bf 40 62 11 00 00 	movabs $0x80000116240,%rdi
 8000010131a:	08 00 00 
 8000010131d:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000101324:	08 00 00 
 80000101327:	ff d0                	call   *%rax
  if(f->ref < 1)
 80000101329:	8b 43 04             	mov    0x4(%rbx),%eax
 8000010132c:	85 c0                	test   %eax,%eax
 8000010132e:	0f 8e 93 00 00 00    	jle    800001013c7 <fileclose+0xc0>
    panic("fileclose");
  if(--f->ref > 0){
 80000101334:	83 e8 01             	sub    $0x1,%eax
 80000101337:	89 43 04             	mov    %eax,0x4(%rbx)
 8000010133a:	85 c0                	test   %eax,%eax
 8000010133c:	0f 8f 9b 00 00 00    	jg     800001013dd <fileclose+0xd6>
    release(&ftable.lock);
    return;
  }
  ff = *f;
 80000101342:	48 8b 03             	mov    (%rbx),%rax
 80000101345:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
 80000101349:	48 8b 43 08          	mov    0x8(%rbx),%rax
 8000010134d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
 80000101351:	48 8b 43 10          	mov    0x10(%rbx),%rax
 80000101355:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
 80000101359:	48 8b 43 18          	mov    0x18(%rbx),%rax
 8000010135d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
 80000101361:	48 8b 43 20          	mov    0x20(%rbx),%rax
 80000101365:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  f->ref = 0;
 80000101369:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
  f->type = FD_NONE;
 80000101370:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  release(&ftable.lock);
 80000101376:	48 bf 40 62 11 00 00 	movabs $0x80000116240,%rdi
 8000010137d:	08 00 00 
 80000101380:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000101387:	08 00 00 
 8000010138a:	ff d0                	call   *%rax

  if(ff.type == FD_PIPE)
 8000010138c:	8b 45 c0             	mov    -0x40(%rbp),%eax
 8000010138f:	83 f8 01             	cmp    $0x1,%eax
 80000101392:	74 66                	je     800001013fa <fileclose+0xf3>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
 80000101394:	83 f8 02             	cmp    $0x2,%eax
 80000101397:	75 5a                	jne    800001013f3 <fileclose+0xec>
    begin_op();
 80000101399:	b0 00                	mov    $0x0,%al
 8000010139b:	48 ba 72 37 10 00 00 	movabs $0x80000103772,%rdx
 800001013a2:	08 00 00 
 800001013a5:	ff d2                	call   *%rdx
    iput(ff.ip);
 800001013a7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
 800001013ab:	48 b8 80 20 10 00 00 	movabs $0x80000102080,%rax
 800001013b2:	08 00 00 
 800001013b5:	ff d0                	call   *%rax
    end_op();
 800001013b7:	b0 00                	mov    $0x0,%al
 800001013b9:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001013c0:	08 00 00 
 800001013c3:	ff d2                	call   *%rdx
 800001013c5:	eb 2c                	jmp    800001013f3 <fileclose+0xec>
    panic("fileclose");
 800001013c7:	48 bf 2b aa 10 00 00 	movabs $0x8000010aa2b,%rdi
 800001013ce:	08 00 00 
 800001013d1:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001013d8:	08 00 00 
 800001013db:	ff d0                	call   *%rax
    release(&ftable.lock);
 800001013dd:	48 bf 40 62 11 00 00 	movabs $0x80000116240,%rdi
 800001013e4:	08 00 00 
 800001013e7:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001013ee:	08 00 00 
 800001013f1:	ff d0                	call   *%rax
  }
}
 800001013f3:	48 83 c4 38          	add    $0x38,%rsp
 800001013f7:	5b                   	pop    %rbx
 800001013f8:	5d                   	pop    %rbp
 800001013f9:	c3                   	ret
    pipeclose(ff.pipe, ff.writable);
 800001013fa:	0f be 75 c9          	movsbl -0x37(%rbp),%esi
 800001013fe:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
 80000101402:	48 b8 32 41 10 00 00 	movabs $0x80000104132,%rax
 80000101409:	08 00 00 
 8000010140c:	ff d0                	call   *%rax
 8000010140e:	eb e3                	jmp    800001013f3 <fileclose+0xec>

0000080000101410 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
 80000101410:	83 3f 02             	cmpl   $0x2,(%rdi)
 80000101413:	75 4a                	jne    8000010145f <filestat+0x4f>
{
 80000101415:	55                   	push   %rbp
 80000101416:	48 89 e5             	mov    %rsp,%rbp
 80000101419:	41 54                	push   %r12
 8000010141b:	53                   	push   %rbx
 8000010141c:	48 89 fb             	mov    %rdi,%rbx
 8000010141f:	49 89 f4             	mov    %rsi,%r12
    ilock(f->ip);
 80000101422:	48 8b 7f 18          	mov    0x18(%rdi),%rdi
 80000101426:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 8000010142d:	08 00 00 
 80000101430:	ff d0                	call   *%rax
    stati(f->ip, st);
 80000101432:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
 80000101436:	4c 89 e6             	mov    %r12,%rsi
 80000101439:	48 b8 94 21 10 00 00 	movabs $0x80000102194,%rax
 80000101440:	08 00 00 
 80000101443:	ff d0                	call   *%rax
    iunlock(f->ip);
 80000101445:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
 80000101449:	48 b8 2a 20 10 00 00 	movabs $0x8000010202a,%rax
 80000101450:	08 00 00 
 80000101453:	ff d0                	call   *%rax
    return 0;
 80000101455:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
 8000010145a:	5b                   	pop    %rbx
 8000010145b:	41 5c                	pop    %r12
 8000010145d:	5d                   	pop    %rbp
 8000010145e:	c3                   	ret
  return -1;
 8000010145f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 80000101464:	c3                   	ret

0000080000101465 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
 80000101465:	55                   	push   %rbp
 80000101466:	48 89 e5             	mov    %rsp,%rbp
 80000101469:	41 55                	push   %r13
 8000010146b:	41 54                	push   %r12
 8000010146d:	53                   	push   %rbx
 8000010146e:	48 83 ec 08          	sub    $0x8,%rsp
  int r;

  if(f->readable == 0)
 80000101472:	0f be 47 08          	movsbl 0x8(%rdi),%eax
 80000101476:	85 c0                	test   %eax,%eax
 80000101478:	0f 84 91 00 00 00    	je     8000010150f <fileread+0xaa>
 8000010147e:	48 89 fb             	mov    %rdi,%rbx
 80000101481:	49 89 f4             	mov    %rsi,%r12
 80000101484:	41 89 d5             	mov    %edx,%r13d
    return -1;
  if(f->type == FD_PIPE)
 80000101487:	8b 07                	mov    (%rdi),%eax
 80000101489:	83 f8 01             	cmp    $0x1,%eax
 8000010148c:	74 56                	je     800001014e4 <fileread+0x7f>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
 8000010148e:	83 f8 02             	cmp    $0x2,%eax
 80000101491:	75 66                	jne    800001014f9 <fileread+0x94>
    ilock(f->ip);
 80000101493:	48 8b 7f 18          	mov    0x18(%rdi),%rdi
 80000101497:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 8000010149e:	08 00 00 
 800001014a1:	ff d0                	call   *%rax
    if((r = readi(f->ip, addr, f->off, n)) > 0)
 800001014a3:	8b 53 20             	mov    0x20(%rbx),%edx
 800001014a6:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
 800001014aa:	44 89 e9             	mov    %r13d,%ecx
 800001014ad:	4c 89 e6             	mov    %r12,%rsi
 800001014b0:	48 b8 bd 21 10 00 00 	movabs $0x800001021bd,%rax
 800001014b7:	08 00 00 
 800001014ba:	ff d0                	call   *%rax
 800001014bc:	41 89 c4             	mov    %eax,%r12d
 800001014bf:	85 c0                	test   %eax,%eax
 800001014c1:	7e 03                	jle    800001014c6 <fileread+0x61>
      f->off += r;
 800001014c3:	01 43 20             	add    %eax,0x20(%rbx)
    iunlock(f->ip);
 800001014c6:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
 800001014ca:	48 b8 2a 20 10 00 00 	movabs $0x8000010202a,%rax
 800001014d1:	08 00 00 
 800001014d4:	ff d0                	call   *%rax
    return r;
  }
  panic("fileread");
}
 800001014d6:	44 89 e0             	mov    %r12d,%eax
 800001014d9:	48 83 c4 08          	add    $0x8,%rsp
 800001014dd:	5b                   	pop    %rbx
 800001014de:	41 5c                	pop    %r12
 800001014e0:	41 5d                	pop    %r13
 800001014e2:	5d                   	pop    %rbp
 800001014e3:	c3                   	ret
    return piperead(f->pipe, addr, n);
 800001014e4:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 800001014e8:	48 b8 b7 42 10 00 00 	movabs $0x800001042b7,%rax
 800001014ef:	08 00 00 
 800001014f2:	ff d0                	call   *%rax
 800001014f4:	41 89 c4             	mov    %eax,%r12d
 800001014f7:	eb dd                	jmp    800001014d6 <fileread+0x71>
  panic("fileread");
 800001014f9:	48 bf 35 aa 10 00 00 	movabs $0x8000010aa35,%rdi
 80000101500:	08 00 00 
 80000101503:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 8000010150a:	08 00 00 
 8000010150d:	ff d0                	call   *%rax
    return -1;
 8000010150f:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 80000101515:	eb bf                	jmp    800001014d6 <fileread+0x71>

0000080000101517 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
 80000101517:	55                   	push   %rbp
 80000101518:	48 89 e5             	mov    %rsp,%rbp
 8000010151b:	41 57                	push   %r15
 8000010151d:	41 56                	push   %r14
 8000010151f:	41 55                	push   %r13
 80000101521:	41 54                	push   %r12
 80000101523:	53                   	push   %rbx
 80000101524:	48 83 ec 18          	sub    $0x18,%rsp
 80000101528:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  int r;

  if(f->writable == 0)
 8000010152c:	0f be 47 09          	movsbl 0x9(%rdi),%eax
 80000101530:	85 c0                	test   %eax,%eax
 80000101532:	0f 84 1b 01 00 00    	je     80000101653 <filewrite+0x13c>
 80000101538:	49 89 fc             	mov    %rdi,%r12
 8000010153b:	41 89 d7             	mov    %edx,%r15d
    return -1;
  if(f->type == FD_PIPE)
 8000010153e:	8b 07                	mov    (%rdi),%eax
 80000101540:	83 f8 01             	cmp    $0x1,%eax
 80000101543:	74 14                	je     80000101559 <filewrite+0x42>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
 80000101545:	83 f8 02             	cmp    $0x2,%eax
 80000101548:	0f 85 ef 00 00 00    	jne    8000010163d <filewrite+0x126>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
 8000010154e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 80000101554:	e9 8d 00 00 00       	jmp    800001015e6 <filewrite+0xcf>
    return pipewrite(f->pipe, addr, n);
 80000101559:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 8000010155d:	48 b8 ca 41 10 00 00 	movabs $0x800001041ca,%rax
 80000101564:	08 00 00 
 80000101567:	ff d0                	call   *%rax
 80000101569:	e9 bb 00 00 00       	jmp    80000101629 <filewrite+0x112>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
 8000010156e:	b0 00                	mov    $0x0,%al
 80000101570:	48 ba 72 37 10 00 00 	movabs $0x80000103772,%rdx
 80000101577:	08 00 00 
 8000010157a:	ff d2                	call   *%rdx
      ilock(f->ip);
 8000010157c:	49 8b 7c 24 18       	mov    0x18(%r12),%rdi
 80000101581:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 80000101588:	08 00 00 
 8000010158b:	ff d0                	call   *%rax
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
 8000010158d:	41 8b 54 24 20       	mov    0x20(%r12),%edx
 80000101592:	49 63 f5             	movslq %r13d,%rsi
 80000101595:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
 80000101599:	48 01 c6             	add    %rax,%rsi
 8000010159c:	49 8b 7c 24 18       	mov    0x18(%r12),%rdi
 800001015a1:	44 89 f1             	mov    %r14d,%ecx
 800001015a4:	48 b8 04 23 10 00 00 	movabs $0x80000102304,%rax
 800001015ab:	08 00 00 
 800001015ae:	ff d0                	call   *%rax
 800001015b0:	89 c3                	mov    %eax,%ebx
 800001015b2:	85 c0                	test   %eax,%eax
 800001015b4:	7e 05                	jle    800001015bb <filewrite+0xa4>
        f->off += r;
 800001015b6:	41 01 44 24 20       	add    %eax,0x20(%r12)
      iunlock(f->ip);
 800001015bb:	49 8b 7c 24 18       	mov    0x18(%r12),%rdi
 800001015c0:	48 b8 2a 20 10 00 00 	movabs $0x8000010202a,%rax
 800001015c7:	08 00 00 
 800001015ca:	ff d0                	call   *%rax
      end_op();
 800001015cc:	b0 00                	mov    $0x0,%al
 800001015ce:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001015d5:	08 00 00 
 800001015d8:	ff d2                	call   *%rdx

      if(r < 0)
 800001015da:	85 db                	test   %ebx,%ebx
 800001015dc:	78 41                	js     8000010161f <filewrite+0x108>
        break;
      if(r != n1)
 800001015de:	41 39 de             	cmp    %ebx,%r14d
 800001015e1:	75 26                	jne    80000101609 <filewrite+0xf2>
        panic("short filewrite");
      i += r;
 800001015e3:	41 01 dd             	add    %ebx,%r13d
    while(i < n){
 800001015e6:	45 39 fd             	cmp    %r15d,%r13d
 800001015e9:	7d 34                	jge    8000010161f <filewrite+0x108>
      int n1 = n - i;
 800001015eb:	45 89 fe             	mov    %r15d,%r14d
 800001015ee:	45 29 ee             	sub    %r13d,%r14d
      if(n1 > max)
 800001015f1:	41 81 fe 00 06 00 00 	cmp    $0x600,%r14d
 800001015f8:	0f 8e 70 ff ff ff    	jle    8000010156e <filewrite+0x57>
        n1 = max;
 800001015fe:	41 be 00 06 00 00    	mov    $0x600,%r14d
 80000101604:	e9 65 ff ff ff       	jmp    8000010156e <filewrite+0x57>
        panic("short filewrite");
 80000101609:	48 bf 3e aa 10 00 00 	movabs $0x8000010aa3e,%rdi
 80000101610:	08 00 00 
 80000101613:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 8000010161a:	08 00 00 
 8000010161d:	ff d0                	call   *%rax
    }
    return i == n ? n : -1;
 8000010161f:	45 39 fd             	cmp    %r15d,%r13d
 80000101622:	74 14                	je     80000101638 <filewrite+0x121>
 80000101624:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
 80000101629:	48 83 c4 18          	add    $0x18,%rsp
 8000010162d:	5b                   	pop    %rbx
 8000010162e:	41 5c                	pop    %r12
 80000101630:	41 5d                	pop    %r13
 80000101632:	41 5e                	pop    %r14
 80000101634:	41 5f                	pop    %r15
 80000101636:	5d                   	pop    %rbp
 80000101637:	c3                   	ret
    return i == n ? n : -1;
 80000101638:	44 89 f8             	mov    %r15d,%eax
 8000010163b:	eb ec                	jmp    80000101629 <filewrite+0x112>
  panic("filewrite");
 8000010163d:	48 bf 44 aa 10 00 00 	movabs $0x8000010aa44,%rdi
 80000101644:	08 00 00 
 80000101647:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 8000010164e:	08 00 00 
 80000101651:	ff d0                	call   *%rax
    return -1;
 80000101653:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000101658:	eb cf                	jmp    80000101629 <filewrite+0x112>
 8000010165a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000080000101660 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
 80000101660:	55                   	push   %rbp
 80000101661:	48 89 e5             	mov    %rsp,%rbp
 80000101664:	41 55                	push   %r13
 80000101666:	41 54                	push   %r12
 80000101668:	53                   	push   %rbx
 80000101669:	48 83 ec 08          	sub    $0x8,%rsp
 8000010166d:	49 89 f4             	mov    %rsi,%r12
  char *s;
  int len;

  while(*path == '/')
 80000101670:	eb 12                	jmp    80000101684 <skipelem+0x24>
 80000101672:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000101679:	00 00 00 00 
 8000010167d:	0f 1f 00             	nopl   (%rax)
    path++;
 80000101680:	48 83 c7 01          	add    $0x1,%rdi
  while(*path == '/')
 80000101684:	8a 07                	mov    (%rdi),%al
 80000101686:	0f be d0             	movsbl %al,%edx
 80000101689:	83 fa 2f             	cmp    $0x2f,%edx
 8000010168c:	74 f2                	je     80000101680 <skipelem+0x20>
  if(*path == 0)
 8000010168e:	85 d2                	test   %edx,%edx
 80000101690:	0f 84 84 00 00 00    	je     8000010171a <skipelem+0xba>
 80000101696:	48 89 fb             	mov    %rdi,%rbx
 80000101699:	eb 09                	jmp    800001016a4 <skipelem+0x44>
 8000010169b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
 800001016a0:	48 83 c3 01          	add    $0x1,%rbx
  while(*path != '/' && *path != 0)
 800001016a4:	8a 03                	mov    (%rbx),%al
 800001016a6:	0f be d0             	movsbl %al,%edx
 800001016a9:	83 fa 2f             	cmp    $0x2f,%edx
 800001016ac:	74 04                	je     800001016b2 <skipelem+0x52>
 800001016ae:	85 d2                	test   %edx,%edx
 800001016b0:	75 ee                	jne    800001016a0 <skipelem+0x40>
  len = path - s;
 800001016b2:	49 89 dd             	mov    %rbx,%r13
 800001016b5:	49 29 fd             	sub    %rdi,%r13
  if(len >= DIRSIZ)
 800001016b8:	41 83 fd 0d          	cmp    $0xd,%r13d
 800001016bc:	7e 19                	jle    800001016d7 <skipelem+0x77>
    memmove(name, s, DIRSIZ);
 800001016be:	ba 0e 00 00 00       	mov    $0xe,%edx
 800001016c3:	48 89 fe             	mov    %rdi,%rsi
 800001016c6:	4c 89 e7             	mov    %r12,%rdi
 800001016c9:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 800001016d0:	08 00 00 
 800001016d3:	ff d0                	call   *%rax
 800001016d5:	eb 2d                	jmp    80000101704 <skipelem+0xa4>
  else {
    memmove(name, s, len);
 800001016d7:	44 89 ea             	mov    %r13d,%edx
 800001016da:	48 89 fe             	mov    %rdi,%rsi
 800001016dd:	4c 89 e7             	mov    %r12,%rdi
 800001016e0:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 800001016e7:	08 00 00 
 800001016ea:	ff d0                	call   *%rax
    name[len] = 0;
 800001016ec:	4d 63 ed             	movslq %r13d,%r13
 800001016ef:	43 c6 04 2c 00       	movb   $0x0,(%r12,%r13,1)
 800001016f4:	eb 0e                	jmp    80000101704 <skipelem+0xa4>
 800001016f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001016fd:	00 00 00 
  }
  while(*path == '/')
    path++;
 80000101700:	48 83 c3 01          	add    $0x1,%rbx
  while(*path == '/')
 80000101704:	0f be 03             	movsbl (%rbx),%eax
 80000101707:	83 f8 2f             	cmp    $0x2f,%eax
 8000010170a:	74 f4                	je     80000101700 <skipelem+0xa0>
  return path;
}
 8000010170c:	48 89 d8             	mov    %rbx,%rax
 8000010170f:	48 83 c4 08          	add    $0x8,%rsp
 80000101713:	5b                   	pop    %rbx
 80000101714:	41 5c                	pop    %r12
 80000101716:	41 5d                	pop    %r13
 80000101718:	5d                   	pop    %rbp
 80000101719:	c3                   	ret
    return 0;
 8000010171a:	bb 00 00 00 00       	mov    $0x0,%ebx
 8000010171f:	eb eb                	jmp    8000010170c <skipelem+0xac>

0000080000101721 <bzero>:
{
 80000101721:	55                   	push   %rbp
 80000101722:	48 89 e5             	mov    %rsp,%rbp
 80000101725:	53                   	push   %rbx
 80000101726:	48 83 ec 08          	sub    $0x8,%rsp
  bp = bread(dev, bno);
 8000010172a:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 80000101731:	08 00 00 
 80000101734:	ff d0                	call   *%rax
 80000101736:	48 89 c3             	mov    %rax,%rbx
  memset(bp->data, 0, BSIZE);
 80000101739:	48 8d b8 b0 00 00 00 	lea    0xb0(%rax),%rdi
 80000101740:	ba 00 02 00 00       	mov    $0x200,%edx
 80000101745:	be 00 00 00 00       	mov    $0x0,%esi
 8000010174a:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000101751:	08 00 00 
 80000101754:	ff d0                	call   *%rax
  log_write(bp);
 80000101756:	48 89 df             	mov    %rbx,%rdi
 80000101759:	48 b8 ec 38 10 00 00 	movabs $0x800001038ec,%rax
 80000101760:	08 00 00 
 80000101763:	ff d0                	call   *%rax
  brelse(bp);
 80000101765:	48 89 df             	mov    %rbx,%rdi
 80000101768:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 8000010176f:	08 00 00 
 80000101772:	ff d0                	call   *%rax
}
 80000101774:	48 83 c4 08          	add    $0x8,%rsp
 80000101778:	5b                   	pop    %rbx
 80000101779:	5d                   	pop    %rbp
 8000010177a:	c3                   	ret

000008000010177b <bfree>:
{
 8000010177b:	55                   	push   %rbp
 8000010177c:	48 89 e5             	mov    %rsp,%rbp
 8000010177f:	41 54                	push   %r12
 80000101781:	53                   	push   %rbx
 80000101782:	41 89 f4             	mov    %esi,%r12d
  bp = bread(dev, BBLOCK(b, sb));
 80000101785:	c1 ee 0c             	shr    $0xc,%esi
 80000101788:	a1 b8 9d 11 00 00 08 	movabs 0x80000119db8,%eax
 8000010178f:	00 00 
 80000101791:	01 c6                	add    %eax,%esi
 80000101793:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 8000010179a:	08 00 00 
 8000010179d:	ff d0                	call   *%rax
 8000010179f:	48 89 c3             	mov    %rax,%rbx
  bi = b % BPB;
 800001017a2:	44 89 e2             	mov    %r12d,%edx
 800001017a5:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
 800001017ab:	44 89 e1             	mov    %r12d,%ecx
 800001017ae:	83 e1 07             	and    $0x7,%ecx
 800001017b1:	b8 01 00 00 00       	mov    $0x1,%eax
 800001017b6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
 800001017b8:	c1 fa 03             	sar    $0x3,%edx
 800001017bb:	48 63 ca             	movslq %edx,%rcx
 800001017be:	8a 8c 0b b0 00 00 00 	mov    0xb0(%rbx,%rcx,1),%cl
 800001017c5:	0f b6 f1             	movzbl %cl,%esi
 800001017c8:	85 c6                	test   %eax,%esi
 800001017ca:	74 31                	je     800001017fd <bfree+0x82>
  bp->data[bi/8] &= ~m;
 800001017cc:	f7 d0                	not    %eax
 800001017ce:	48 63 d2             	movslq %edx,%rdx
 800001017d1:	21 c8                	and    %ecx,%eax
 800001017d3:	88 84 13 b0 00 00 00 	mov    %al,0xb0(%rbx,%rdx,1)
  log_write(bp);
 800001017da:	48 89 df             	mov    %rbx,%rdi
 800001017dd:	48 b8 ec 38 10 00 00 	movabs $0x800001038ec,%rax
 800001017e4:	08 00 00 
 800001017e7:	ff d0                	call   *%rax
  brelse(bp);
 800001017e9:	48 89 df             	mov    %rbx,%rdi
 800001017ec:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 800001017f3:	08 00 00 
 800001017f6:	ff d0                	call   *%rax
}
 800001017f8:	5b                   	pop    %rbx
 800001017f9:	41 5c                	pop    %r12
 800001017fb:	5d                   	pop    %rbp
 800001017fc:	c3                   	ret
    panic("freeing free block");
 800001017fd:	48 bf 4e aa 10 00 00 	movabs $0x8000010aa4e,%rdi
 80000101804:	08 00 00 
 80000101807:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 8000010180e:	08 00 00 
 80000101811:	ff d0                	call   *%rax

0000080000101813 <balloc>:
{
 80000101813:	55                   	push   %rbp
 80000101814:	48 89 e5             	mov    %rsp,%rbp
 80000101817:	41 56                	push   %r14
 80000101819:	41 55                	push   %r13
 8000010181b:	41 54                	push   %r12
 8000010181d:	53                   	push   %rbx
 8000010181e:	41 89 fe             	mov    %edi,%r14d
  for(b = 0; b < sb.size; b += BPB){
 80000101821:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 80000101827:	eb 16                	jmp    8000010183f <balloc+0x2c>
    brelse(bp);
 80000101829:	4c 89 ef             	mov    %r13,%rdi
 8000010182c:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 80000101833:	08 00 00 
 80000101836:	ff d0                	call   *%rax
  for(b = 0; b < sb.size; b += BPB){
 80000101838:	41 81 c4 00 10 00 00 	add    $0x1000,%r12d
 8000010183f:	a1 a0 9d 11 00 00 08 	movabs 0x80000119da0,%eax
 80000101846:	00 00 
 80000101848:	41 39 c4             	cmp    %eax,%r12d
 8000010184b:	73 7e                	jae    800001018cb <balloc+0xb8>
    bp = bread(dev, BBLOCK(b, sb));
 8000010184d:	41 8d b4 24 ff 0f 00 	lea    0xfff(%r12),%esi
 80000101854:	00 
 80000101855:	45 85 e4             	test   %r12d,%r12d
 80000101858:	41 0f 49 f4          	cmovns %r12d,%esi
 8000010185c:	c1 fe 0c             	sar    $0xc,%esi
 8000010185f:	a1 b8 9d 11 00 00 08 	movabs 0x80000119db8,%eax
 80000101866:	00 00 
 80000101868:	01 c6                	add    %eax,%esi
 8000010186a:	44 89 f7             	mov    %r14d,%edi
 8000010186d:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 80000101874:	08 00 00 
 80000101877:	ff d0                	call   *%rax
 80000101879:	49 89 c5             	mov    %rax,%r13
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
 8000010187c:	ba 00 00 00 00       	mov    $0x0,%edx
 80000101881:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
 80000101887:	7f a0                	jg     80000101829 <balloc+0x16>
 80000101889:	41 8d 1c 14          	lea    (%r12,%rdx,1),%ebx
 8000010188d:	a1 a0 9d 11 00 00 08 	movabs 0x80000119da0,%eax
 80000101894:	00 00 
 80000101896:	39 c3                	cmp    %eax,%ebx
 80000101898:	73 8f                	jae    80000101829 <balloc+0x16>
      m = 1 << (bi % 8);
 8000010189a:	89 d1                	mov    %edx,%ecx
 8000010189c:	83 e1 07             	and    $0x7,%ecx
 8000010189f:	b8 01 00 00 00       	mov    $0x1,%eax
 800001018a4:	d3 e0                	shl    %cl,%eax
 800001018a6:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
 800001018a8:	8d 42 07             	lea    0x7(%rdx),%eax
 800001018ab:	85 d2                	test   %edx,%edx
 800001018ad:	0f 49 c2             	cmovns %edx,%eax
 800001018b0:	c1 f8 03             	sar    $0x3,%eax
 800001018b3:	48 63 f0             	movslq %eax,%rsi
 800001018b6:	41 8a b4 35 b0 00 00 	mov    0xb0(%r13,%rsi,1),%sil
 800001018bd:	00 
 800001018be:	40 0f b6 fe          	movzbl %sil,%edi
 800001018c2:	85 cf                	test   %ecx,%edi
 800001018c4:	74 1b                	je     800001018e1 <balloc+0xce>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
 800001018c6:	83 c2 01             	add    $0x1,%edx
 800001018c9:	eb b6                	jmp    80000101881 <balloc+0x6e>
  panic("balloc: out of blocks");
 800001018cb:	48 bf 61 aa 10 00 00 	movabs $0x8000010aa61,%rdi
 800001018d2:	08 00 00 
 800001018d5:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001018dc:	08 00 00 
 800001018df:	ff d0                	call   *%rax
        bp->data[bi/8] |= m;  // Mark block in use.
 800001018e1:	48 98                	cltq
 800001018e3:	09 f1                	or     %esi,%ecx
 800001018e5:	41 88 8c 05 b0 00 00 	mov    %cl,0xb0(%r13,%rax,1)
 800001018ec:	00 
        log_write(bp);
 800001018ed:	4c 89 ef             	mov    %r13,%rdi
 800001018f0:	48 b8 ec 38 10 00 00 	movabs $0x800001038ec,%rax
 800001018f7:	08 00 00 
 800001018fa:	ff d0                	call   *%rax
        brelse(bp);
 800001018fc:	4c 89 ef             	mov    %r13,%rdi
 800001018ff:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 80000101906:	08 00 00 
 80000101909:	ff d0                	call   *%rax
        bzero(dev, b + bi);
 8000010190b:	89 de                	mov    %ebx,%esi
 8000010190d:	44 89 f7             	mov    %r14d,%edi
 80000101910:	48 b8 21 17 10 00 00 	movabs $0x80000101721,%rax
 80000101917:	08 00 00 
 8000010191a:	ff d0                	call   *%rax
}
 8000010191c:	89 d8                	mov    %ebx,%eax
 8000010191e:	5b                   	pop    %rbx
 8000010191f:	41 5c                	pop    %r12
 80000101921:	41 5d                	pop    %r13
 80000101923:	41 5e                	pop    %r14
 80000101925:	5d                   	pop    %rbp
 80000101926:	c3                   	ret

0000080000101927 <bmap>:
{
 80000101927:	55                   	push   %rbp
 80000101928:	48 89 e5             	mov    %rsp,%rbp
 8000010192b:	41 56                	push   %r14
 8000010192d:	41 55                	push   %r13
 8000010192f:	41 54                	push   %r12
 80000101931:	53                   	push   %rbx
 80000101932:	49 89 fc             	mov    %rdi,%r12
 80000101935:	89 f3                	mov    %esi,%ebx
  if(bn < NDIRECT){
 80000101937:	83 fe 0b             	cmp    $0xb,%esi
 8000010193a:	76 56                	jbe    80000101992 <bmap+0x6b>
  bn -= NDIRECT;
 8000010193c:	83 eb 0c             	sub    $0xc,%ebx
  if(bn < NINDIRECT){
 8000010193f:	83 fb 7f             	cmp    $0x7f,%ebx
 80000101942:	0f 87 bc 00 00 00    	ja     80000101a04 <bmap+0xdd>
    if((addr = ip->addrs[NDIRECT]) == 0)
 80000101948:	8b b7 d0 00 00 00    	mov    0xd0(%rdi),%esi
 8000010194e:	85 f6                	test   %esi,%esi
 80000101950:	74 6c                	je     800001019be <bmap+0x97>
    bp = bread(ip->dev, addr);
 80000101952:	41 8b 3c 24          	mov    (%r12),%edi
 80000101956:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 8000010195d:	08 00 00 
 80000101960:	ff d0                	call   *%rax
 80000101962:	49 89 c6             	mov    %rax,%r14
    if((addr = a[bn]) == 0){
 80000101965:	89 db                	mov    %ebx,%ebx
 80000101967:	48 8d 9c 98 b0 00 00 	lea    0xb0(%rax,%rbx,4),%rbx
 8000010196e:	00 
 8000010196f:	44 8b 2b             	mov    (%rbx),%r13d
 80000101972:	45 85 ed             	test   %r13d,%r13d
 80000101975:	74 64                	je     800001019db <bmap+0xb4>
    brelse(bp);
 80000101977:	4c 89 f7             	mov    %r14,%rdi
 8000010197a:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 80000101981:	08 00 00 
 80000101984:	ff d0                	call   *%rax
}
 80000101986:	44 89 e8             	mov    %r13d,%eax
 80000101989:	5b                   	pop    %rbx
 8000010198a:	41 5c                	pop    %r12
 8000010198c:	41 5d                	pop    %r13
 8000010198e:	41 5e                	pop    %r14
 80000101990:	5d                   	pop    %rbp
 80000101991:	c3                   	ret
    if((addr = ip->addrs[bn]) == 0)
 80000101992:	89 f0                	mov    %esi,%eax
 80000101994:	44 8b ac 87 a0 00 00 	mov    0xa0(%rdi,%rax,4),%r13d
 8000010199b:	00 
 8000010199c:	45 85 ed             	test   %r13d,%r13d
 8000010199f:	75 e5                	jne    80000101986 <bmap+0x5f>
      ip->addrs[bn] = addr = balloc(ip->dev);
 800001019a1:	8b 3f                	mov    (%rdi),%edi
 800001019a3:	48 b8 13 18 10 00 00 	movabs $0x80000101813,%rax
 800001019aa:	08 00 00 
 800001019ad:	ff d0                	call   *%rax
 800001019af:	41 89 c5             	mov    %eax,%r13d
 800001019b2:	89 db                	mov    %ebx,%ebx
 800001019b4:	41 89 84 9c a0 00 00 	mov    %eax,0xa0(%r12,%rbx,4)
 800001019bb:	00 
    return addr;
 800001019bc:	eb c8                	jmp    80000101986 <bmap+0x5f>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
 800001019be:	8b 3f                	mov    (%rdi),%edi
 800001019c0:	48 b8 13 18 10 00 00 	movabs $0x80000101813,%rax
 800001019c7:	08 00 00 
 800001019ca:	ff d0                	call   *%rax
 800001019cc:	89 c6                	mov    %eax,%esi
 800001019ce:	41 89 84 24 d0 00 00 	mov    %eax,0xd0(%r12)
 800001019d5:	00 
 800001019d6:	e9 77 ff ff ff       	jmp    80000101952 <bmap+0x2b>
      a[bn] = addr = balloc(ip->dev);
 800001019db:	41 8b 3c 24          	mov    (%r12),%edi
 800001019df:	48 b8 13 18 10 00 00 	movabs $0x80000101813,%rax
 800001019e6:	08 00 00 
 800001019e9:	ff d0                	call   *%rax
 800001019eb:	41 89 c5             	mov    %eax,%r13d
 800001019ee:	89 03                	mov    %eax,(%rbx)
      log_write(bp);
 800001019f0:	4c 89 f7             	mov    %r14,%rdi
 800001019f3:	48 b8 ec 38 10 00 00 	movabs $0x800001038ec,%rax
 800001019fa:	08 00 00 
 800001019fd:	ff d0                	call   *%rax
 800001019ff:	e9 73 ff ff ff       	jmp    80000101977 <bmap+0x50>
  panic("bmap: out of range");
 80000101a04:	48 bf 77 aa 10 00 00 	movabs $0x8000010aa77,%rdi
 80000101a0b:	08 00 00 
 80000101a0e:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000101a15:	08 00 00 
 80000101a18:	ff d0                	call   *%rax

0000080000101a1a <iget>:
{
 80000101a1a:	55                   	push   %rbp
 80000101a1b:	48 89 e5             	mov    %rsp,%rbp
 80000101a1e:	41 56                	push   %r14
 80000101a20:	41 55                	push   %r13
 80000101a22:	41 54                	push   %r12
 80000101a24:	53                   	push   %rbx
 80000101a25:	41 89 fd             	mov    %edi,%r13d
 80000101a28:	41 89 f6             	mov    %esi,%r14d
  acquire(&icache.lock);
 80000101a2b:	48 bf 00 73 11 00 00 	movabs $0x80000117300,%rdi
 80000101a32:	08 00 00 
 80000101a35:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000101a3c:	08 00 00 
 80000101a3f:	ff d0                	call   *%rax
  empty = 0;
 80000101a41:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
 80000101a47:	48 bb 68 73 11 00 00 	movabs $0x80000117368,%rbx
 80000101a4e:	08 00 00 
 80000101a51:	eb 0c                	jmp    80000101a5f <iget+0x45>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
 80000101a53:	4d 85 e4             	test   %r12,%r12
 80000101a56:	74 49                	je     80000101aa1 <iget+0x87>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
 80000101a58:	48 81 c3 d8 00 00 00 	add    $0xd8,%rbx
 80000101a5f:	48 b8 98 9d 11 00 00 	movabs $0x80000119d98,%rax
 80000101a66:	08 00 00 
 80000101a69:	48 39 c3             	cmp    %rax,%rbx
 80000101a6c:	73 3c                	jae    80000101aaa <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
 80000101a6e:	8b 43 08             	mov    0x8(%rbx),%eax
 80000101a71:	85 c0                	test   %eax,%eax
 80000101a73:	7e de                	jle    80000101a53 <iget+0x39>
 80000101a75:	44 39 2b             	cmp    %r13d,(%rbx)
 80000101a78:	75 d9                	jne    80000101a53 <iget+0x39>
 80000101a7a:	44 39 73 04          	cmp    %r14d,0x4(%rbx)
 80000101a7e:	75 d3                	jne    80000101a53 <iget+0x39>
      ip->ref++;
 80000101a80:	83 c0 01             	add    $0x1,%eax
 80000101a83:	89 43 08             	mov    %eax,0x8(%rbx)
      release(&icache.lock);
 80000101a86:	48 bf 00 73 11 00 00 	movabs $0x80000117300,%rdi
 80000101a8d:	08 00 00 
 80000101a90:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000101a97:	08 00 00 
 80000101a9a:	ff d0                	call   *%rax
      return ip;
 80000101a9c:	49 89 dc             	mov    %rbx,%r12
 80000101a9f:	eb 42                	jmp    80000101ae3 <iget+0xc9>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
 80000101aa1:	85 c0                	test   %eax,%eax
 80000101aa3:	75 b3                	jne    80000101a58 <iget+0x3e>
      empty = ip;
 80000101aa5:	49 89 dc             	mov    %rbx,%r12
 80000101aa8:	eb ae                	jmp    80000101a58 <iget+0x3e>
  if(empty == 0)
 80000101aaa:	4d 85 e4             	test   %r12,%r12
 80000101aad:	74 40                	je     80000101aef <iget+0xd5>
  ip->dev = dev;
 80000101aaf:	45 89 2c 24          	mov    %r13d,(%r12)
  ip->inum = inum;
 80000101ab3:	45 89 74 24 04       	mov    %r14d,0x4(%r12)
  ip->ref = 1;
 80000101ab8:	41 c7 44 24 08 01 00 	movl   $0x1,0x8(%r12)
 80000101abf:	00 00 
  ip->valid = 0;
 80000101ac1:	41 c7 84 24 90 00 00 	movl   $0x0,0x90(%r12)
 80000101ac8:	00 00 00 00 00 
  release(&icache.lock);
 80000101acd:	48 bf 00 73 11 00 00 	movabs $0x80000117300,%rdi
 80000101ad4:	08 00 00 
 80000101ad7:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000101ade:	08 00 00 
 80000101ae1:	ff d0                	call   *%rax
}
 80000101ae3:	4c 89 e0             	mov    %r12,%rax
 80000101ae6:	5b                   	pop    %rbx
 80000101ae7:	41 5c                	pop    %r12
 80000101ae9:	41 5d                	pop    %r13
 80000101aeb:	41 5e                	pop    %r14
 80000101aed:	5d                   	pop    %rbp
 80000101aee:	c3                   	ret
    panic("iget: no inodes");
 80000101aef:	48 bf 8a aa 10 00 00 	movabs $0x8000010aa8a,%rdi
 80000101af6:	08 00 00 
 80000101af9:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000101b00:	08 00 00 
 80000101b03:	ff d0                	call   *%rax

0000080000101b05 <readsb>:
{
 80000101b05:	55                   	push   %rbp
 80000101b06:	48 89 e5             	mov    %rsp,%rbp
 80000101b09:	41 54                	push   %r12
 80000101b0b:	53                   	push   %rbx
 80000101b0c:	49 89 f4             	mov    %rsi,%r12
  bp = bread(dev, 1);
 80000101b0f:	be 01 00 00 00       	mov    $0x1,%esi
 80000101b14:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 80000101b1b:	08 00 00 
 80000101b1e:	ff d0                	call   *%rax
 80000101b20:	48 89 c3             	mov    %rax,%rbx
  memmove(sb, bp->data, sizeof(*sb));
 80000101b23:	48 8d b0 b0 00 00 00 	lea    0xb0(%rax),%rsi
 80000101b2a:	ba 1c 00 00 00       	mov    $0x1c,%edx
 80000101b2f:	4c 89 e7             	mov    %r12,%rdi
 80000101b32:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 80000101b39:	08 00 00 
 80000101b3c:	ff d0                	call   *%rax
  brelse(bp);
 80000101b3e:	48 89 df             	mov    %rbx,%rdi
 80000101b41:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 80000101b48:	08 00 00 
 80000101b4b:	ff d0                	call   *%rax
}
 80000101b4d:	5b                   	pop    %rbx
 80000101b4e:	41 5c                	pop    %r12
 80000101b50:	5d                   	pop    %rbp
 80000101b51:	c3                   	ret

0000080000101b52 <iinit>:
{
 80000101b52:	55                   	push   %rbp
 80000101b53:	48 89 e5             	mov    %rsp,%rbp
 80000101b56:	41 54                	push   %r12
 80000101b58:	53                   	push   %rbx
 80000101b59:	41 89 fc             	mov    %edi,%r12d
  initlock(&icache.lock, "icache");
 80000101b5c:	48 be 9a aa 10 00 00 	movabs $0x8000010aa9a,%rsi
 80000101b63:	08 00 00 
 80000101b66:	48 bf 00 73 11 00 00 	movabs $0x80000117300,%rdi
 80000101b6d:	08 00 00 
 80000101b70:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 80000101b77:	08 00 00 
 80000101b7a:	ff d0                	call   *%rax
  for(i = 0; i < NINODE; i++) {
 80000101b7c:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000101b81:	eb 33                	jmp    80000101bb6 <iinit+0x64>
    initsleeplock(&icache.inode[i].lock, "inode");
 80000101b83:	48 63 c3             	movslq %ebx,%rax
 80000101b86:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 80000101b8a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
 80000101b8e:	48 b8 00 73 11 00 00 	movabs $0x80000117300,%rax
 80000101b95:	08 00 00 
 80000101b98:	48 8d 7c d0 78       	lea    0x78(%rax,%rdx,8),%rdi
 80000101b9d:	48 be a1 aa 10 00 00 	movabs $0x8000010aaa1,%rsi
 80000101ba4:	08 00 00 
 80000101ba7:	48 b8 10 52 10 00 00 	movabs $0x80000105210,%rax
 80000101bae:	08 00 00 
 80000101bb1:	ff d0                	call   *%rax
  for(i = 0; i < NINODE; i++) {
 80000101bb3:	83 c3 01             	add    $0x1,%ebx
 80000101bb6:	83 fb 31             	cmp    $0x31,%ebx
 80000101bb9:	7e c8                	jle    80000101b83 <iinit+0x31>
  readsb(dev, &sb);
 80000101bbb:	48 bb a0 9d 11 00 00 	movabs $0x80000119da0,%rbx
 80000101bc2:	08 00 00 
 80000101bc5:	48 89 de             	mov    %rbx,%rsi
 80000101bc8:	44 89 e7             	mov    %r12d,%edi
 80000101bcb:	48 b8 05 1b 10 00 00 	movabs $0x80000101b05,%rax
 80000101bd2:	08 00 00 
 80000101bd5:	ff d0                	call   *%rax
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
 80000101bd7:	8b 4b 08             	mov    0x8(%rbx),%ecx
 80000101bda:	8b 53 04             	mov    0x4(%rbx),%edx
 80000101bdd:	8b 33                	mov    (%rbx),%esi
 80000101bdf:	8b 43 18             	mov    0x18(%rbx),%eax
 80000101be2:	50                   	push   %rax
 80000101be3:	8b 43 14             	mov    0x14(%rbx),%eax
 80000101be6:	50                   	push   %rax
 80000101be7:	44 8b 4b 10          	mov    0x10(%rbx),%r9d
 80000101beb:	44 8b 43 0c          	mov    0xc(%rbx),%r8d
 80000101bef:	48 bf 28 af 10 00 00 	movabs $0x8000010af28,%rdi
 80000101bf6:	08 00 00 
 80000101bf9:	b0 00                	mov    $0x0,%al
 80000101bfb:	49 ba f9 08 10 00 00 	movabs $0x800001008f9,%r10
 80000101c02:	08 00 00 
 80000101c05:	41 ff d2             	call   *%r10
}
 80000101c08:	48 83 c4 10          	add    $0x10,%rsp
 80000101c0c:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
 80000101c10:	5b                   	pop    %rbx
 80000101c11:	41 5c                	pop    %r12
 80000101c13:	5d                   	pop    %rbp
 80000101c14:	c3                   	ret

0000080000101c15 <ialloc>:
{
 80000101c15:	55                   	push   %rbp
 80000101c16:	48 89 e5             	mov    %rsp,%rbp
 80000101c19:	41 57                	push   %r15
 80000101c1b:	41 56                	push   %r14
 80000101c1d:	41 55                	push   %r13
 80000101c1f:	41 54                	push   %r12
 80000101c21:	53                   	push   %rbx
 80000101c22:	48 83 ec 18          	sub    $0x18,%rsp
 80000101c26:	41 89 fe             	mov    %edi,%r14d
 80000101c29:	89 75 cc             	mov    %esi,-0x34(%rbp)
  for(inum = 1; inum < sb.ninodes; inum++){
 80000101c2c:	bb 01 00 00 00       	mov    $0x1,%ebx
 80000101c31:	41 89 df             	mov    %ebx,%r15d
 80000101c34:	a1 a8 9d 11 00 00 08 	movabs 0x80000119da8,%eax
 80000101c3b:	00 00 
 80000101c3d:	39 c3                	cmp    %eax,%ebx
 80000101c3f:	73 53                	jae    80000101c94 <ialloc+0x7f>
    bp = bread(dev, IBLOCK(inum, sb));
 80000101c41:	48 63 d3             	movslq %ebx,%rdx
 80000101c44:	48 c1 ea 03          	shr    $0x3,%rdx
 80000101c48:	a1 b4 9d 11 00 00 08 	movabs 0x80000119db4,%eax
 80000101c4f:	00 00 
 80000101c51:	8d 34 10             	lea    (%rax,%rdx,1),%esi
 80000101c54:	44 89 f7             	mov    %r14d,%edi
 80000101c57:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 80000101c5e:	08 00 00 
 80000101c61:	ff d0                	call   *%rax
 80000101c63:	49 89 c4             	mov    %rax,%r12
    dip = (struct dinode*)bp->data + inum%IPB;
 80000101c66:	89 d8                	mov    %ebx,%eax
 80000101c68:	83 e0 07             	and    $0x7,%eax
 80000101c6b:	48 c1 e0 06          	shl    $0x6,%rax
 80000101c6f:	4d 8d ac 04 b0 00 00 	lea    0xb0(%r12,%rax,1),%r13
 80000101c76:	00 
    if(dip->type == 0){  // a free inode
 80000101c77:	41 0f bf 45 00       	movswl 0x0(%r13),%eax
 80000101c7c:	85 c0                	test   %eax,%eax
 80000101c7e:	74 2a                	je     80000101caa <ialloc+0x95>
    brelse(bp);
 80000101c80:	4c 89 e7             	mov    %r12,%rdi
 80000101c83:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 80000101c8a:	08 00 00 
 80000101c8d:	ff d0                	call   *%rax
  for(inum = 1; inum < sb.ninodes; inum++){
 80000101c8f:	83 c3 01             	add    $0x1,%ebx
 80000101c92:	eb 9d                	jmp    80000101c31 <ialloc+0x1c>
  panic("ialloc: no inodes");
 80000101c94:	48 bf a7 aa 10 00 00 	movabs $0x8000010aaa7,%rdi
 80000101c9b:	08 00 00 
 80000101c9e:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000101ca5:	08 00 00 
 80000101ca8:	ff d0                	call   *%rax
      memset(dip, 0, sizeof(*dip));
 80000101caa:	ba 40 00 00 00       	mov    $0x40,%edx
 80000101caf:	be 00 00 00 00       	mov    $0x0,%esi
 80000101cb4:	4c 89 ef             	mov    %r13,%rdi
 80000101cb7:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000101cbe:	08 00 00 
 80000101cc1:	ff d0                	call   *%rax
      dip->type = type;
 80000101cc3:	8b 45 cc             	mov    -0x34(%rbp),%eax
 80000101cc6:	66 41 89 45 00       	mov    %ax,0x0(%r13)
      log_write(bp);   // mark it allocated on the disk
 80000101ccb:	4c 89 e7             	mov    %r12,%rdi
 80000101cce:	48 b8 ec 38 10 00 00 	movabs $0x800001038ec,%rax
 80000101cd5:	08 00 00 
 80000101cd8:	ff d0                	call   *%rax
      brelse(bp);
 80000101cda:	4c 89 e7             	mov    %r12,%rdi
 80000101cdd:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 80000101ce4:	08 00 00 
 80000101ce7:	ff d0                	call   *%rax
      return iget(dev, inum);
 80000101ce9:	44 89 fe             	mov    %r15d,%esi
 80000101cec:	44 89 f7             	mov    %r14d,%edi
 80000101cef:	48 b8 1a 1a 10 00 00 	movabs $0x80000101a1a,%rax
 80000101cf6:	08 00 00 
 80000101cf9:	ff d0                	call   *%rax
}
 80000101cfb:	48 83 c4 18          	add    $0x18,%rsp
 80000101cff:	5b                   	pop    %rbx
 80000101d00:	41 5c                	pop    %r12
 80000101d02:	41 5d                	pop    %r13
 80000101d04:	41 5e                	pop    %r14
 80000101d06:	41 5f                	pop    %r15
 80000101d08:	5d                   	pop    %rbp
 80000101d09:	c3                   	ret

0000080000101d0a <iupdate>:
{
 80000101d0a:	55                   	push   %rbp
 80000101d0b:	48 89 e5             	mov    %rsp,%rbp
 80000101d0e:	41 54                	push   %r12
 80000101d10:	53                   	push   %rbx
 80000101d11:	48 89 fb             	mov    %rdi,%rbx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
 80000101d14:	8b 77 04             	mov    0x4(%rdi),%esi
 80000101d17:	c1 ee 03             	shr    $0x3,%esi
 80000101d1a:	a1 b4 9d 11 00 00 08 	movabs 0x80000119db4,%eax
 80000101d21:	00 00 
 80000101d23:	01 c6                	add    %eax,%esi
 80000101d25:	8b 3f                	mov    (%rdi),%edi
 80000101d27:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 80000101d2e:	08 00 00 
 80000101d31:	ff d0                	call   *%rax
 80000101d33:	49 89 c4             	mov    %rax,%r12
  dip = (struct dinode*)bp->data + ip->inum%IPB;
 80000101d36:	8b 43 04             	mov    0x4(%rbx),%eax
 80000101d39:	83 e0 07             	and    $0x7,%eax
 80000101d3c:	48 c1 e0 06          	shl    $0x6,%rax
 80000101d40:	49 8d bc 04 b0 00 00 	lea    0xb0(%r12,%rax,1),%rdi
 80000101d47:	00 
  dip->type = ip->type;
 80000101d48:	8b 83 94 00 00 00    	mov    0x94(%rbx),%eax
 80000101d4e:	66 89 07             	mov    %ax,(%rdi)
  dip->major = ip->major;
 80000101d51:	66 8b 83 96 00 00 00 	mov    0x96(%rbx),%ax
 80000101d58:	66 89 47 02          	mov    %ax,0x2(%rdi)
  dip->minor = ip->minor;
 80000101d5c:	8b 83 98 00 00 00    	mov    0x98(%rbx),%eax
 80000101d62:	66 89 47 04          	mov    %ax,0x4(%rdi)
  dip->nlink = ip->nlink;
 80000101d66:	66 8b 83 9a 00 00 00 	mov    0x9a(%rbx),%ax
 80000101d6d:	66 89 47 06          	mov    %ax,0x6(%rdi)
  dip->size = ip->size;
 80000101d71:	8b 83 9c 00 00 00    	mov    0x9c(%rbx),%eax
 80000101d77:	89 47 08             	mov    %eax,0x8(%rdi)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
 80000101d7a:	48 8d b3 a0 00 00 00 	lea    0xa0(%rbx),%rsi
 80000101d81:	48 83 c7 0c          	add    $0xc,%rdi
 80000101d85:	ba 34 00 00 00       	mov    $0x34,%edx
 80000101d8a:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 80000101d91:	08 00 00 
 80000101d94:	ff d0                	call   *%rax
  log_write(bp);
 80000101d96:	4c 89 e7             	mov    %r12,%rdi
 80000101d99:	48 b8 ec 38 10 00 00 	movabs $0x800001038ec,%rax
 80000101da0:	08 00 00 
 80000101da3:	ff d0                	call   *%rax
  brelse(bp);
 80000101da5:	4c 89 e7             	mov    %r12,%rdi
 80000101da8:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 80000101daf:	08 00 00 
 80000101db2:	ff d0                	call   *%rax
}
 80000101db4:	5b                   	pop    %rbx
 80000101db5:	41 5c                	pop    %r12
 80000101db7:	5d                   	pop    %rbp
 80000101db8:	c3                   	ret

0000080000101db9 <itrunc>:
{
 80000101db9:	55                   	push   %rbp
 80000101dba:	48 89 e5             	mov    %rsp,%rbp
 80000101dbd:	41 56                	push   %r14
 80000101dbf:	41 55                	push   %r13
 80000101dc1:	41 54                	push   %r12
 80000101dc3:	53                   	push   %rbx
 80000101dc4:	49 89 fc             	mov    %rdi,%r12
  for(i = 0; i < NDIRECT; i++){
 80000101dc7:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000101dcc:	eb 15                	jmp    80000101de3 <itrunc+0x2a>
 80000101dce:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000101dd5:	00 00 00 00 
 80000101dd9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 80000101de0:	83 c3 01             	add    $0x1,%ebx
 80000101de3:	83 fb 0b             	cmp    $0xb,%ebx
 80000101de6:	7f 30                	jg     80000101e18 <itrunc+0x5f>
    if(ip->addrs[i]){
 80000101de8:	48 63 c3             	movslq %ebx,%rax
 80000101deb:	41 8b b4 84 a0 00 00 	mov    0xa0(%r12,%rax,4),%esi
 80000101df2:	00 
 80000101df3:	85 f6                	test   %esi,%esi
 80000101df5:	74 e9                	je     80000101de0 <itrunc+0x27>
      bfree(ip->dev, ip->addrs[i]);
 80000101df7:	41 8b 3c 24          	mov    (%r12),%edi
 80000101dfb:	48 b8 7b 17 10 00 00 	movabs $0x8000010177b,%rax
 80000101e02:	08 00 00 
 80000101e05:	ff d0                	call   *%rax
      ip->addrs[i] = 0;
 80000101e07:	48 63 c3             	movslq %ebx,%rax
 80000101e0a:	41 c7 84 84 a0 00 00 	movl   $0x0,0xa0(%r12,%rax,4)
 80000101e11:	00 00 00 00 00 
 80000101e16:	eb c8                	jmp    80000101de0 <itrunc+0x27>
  if(ip->addrs[NDIRECT]){
 80000101e18:	41 8b b4 24 d0 00 00 	mov    0xd0(%r12),%esi
 80000101e1f:	00 
 80000101e20:	85 f6                	test   %esi,%esi
 80000101e22:	75 24                	jne    80000101e48 <itrunc+0x8f>
  ip->size = 0;
 80000101e24:	41 c7 84 24 9c 00 00 	movl   $0x0,0x9c(%r12)
 80000101e2b:	00 00 00 00 00 
  iupdate(ip);
 80000101e30:	4c 89 e7             	mov    %r12,%rdi
 80000101e33:	48 b8 0a 1d 10 00 00 	movabs $0x80000101d0a,%rax
 80000101e3a:	08 00 00 
 80000101e3d:	ff d0                	call   *%rax
}
 80000101e3f:	5b                   	pop    %rbx
 80000101e40:	41 5c                	pop    %r12
 80000101e42:	41 5d                	pop    %r13
 80000101e44:	41 5e                	pop    %r14
 80000101e46:	5d                   	pop    %rbp
 80000101e47:	c3                   	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
 80000101e48:	41 8b 3c 24          	mov    (%r12),%edi
 80000101e4c:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 80000101e53:	08 00 00 
 80000101e56:	ff d0                	call   *%rax
 80000101e58:	49 89 c6             	mov    %rax,%r14
    a = (uint*)bp->data;
 80000101e5b:	4c 8d a8 b0 00 00 00 	lea    0xb0(%rax),%r13
    for(j = 0; j < NINDIRECT; j++){
 80000101e62:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000101e67:	eb 1a                	jmp    80000101e83 <itrunc+0xca>
 80000101e69:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000101e70:	00 00 00 00 
 80000101e74:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000101e7b:	00 00 00 00 
 80000101e7f:	90                   	nop
 80000101e80:	83 c3 01             	add    $0x1,%ebx
 80000101e83:	83 fb 7f             	cmp    $0x7f,%ebx
 80000101e86:	77 1e                	ja     80000101ea6 <itrunc+0xed>
      if(a[j])
 80000101e88:	48 63 c3             	movslq %ebx,%rax
 80000101e8b:	41 8b 74 85 00       	mov    0x0(%r13,%rax,4),%esi
 80000101e90:	85 f6                	test   %esi,%esi
 80000101e92:	74 ec                	je     80000101e80 <itrunc+0xc7>
        bfree(ip->dev, a[j]);
 80000101e94:	41 8b 3c 24          	mov    (%r12),%edi
 80000101e98:	48 b8 7b 17 10 00 00 	movabs $0x8000010177b,%rax
 80000101e9f:	08 00 00 
 80000101ea2:	ff d0                	call   *%rax
 80000101ea4:	eb da                	jmp    80000101e80 <itrunc+0xc7>
    brelse(bp);
 80000101ea6:	4c 89 f7             	mov    %r14,%rdi
 80000101ea9:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 80000101eb0:	08 00 00 
 80000101eb3:	ff d0                	call   *%rax
    bfree(ip->dev, ip->addrs[NDIRECT]);
 80000101eb5:	41 8b 3c 24          	mov    (%r12),%edi
 80000101eb9:	41 8b b4 24 d0 00 00 	mov    0xd0(%r12),%esi
 80000101ec0:	00 
 80000101ec1:	48 b8 7b 17 10 00 00 	movabs $0x8000010177b,%rax
 80000101ec8:	08 00 00 
 80000101ecb:	ff d0                	call   *%rax
    ip->addrs[NDIRECT] = 0;
 80000101ecd:	41 c7 84 24 d0 00 00 	movl   $0x0,0xd0(%r12)
 80000101ed4:	00 00 00 00 00 
 80000101ed9:	e9 46 ff ff ff       	jmp    80000101e24 <itrunc+0x6b>

0000080000101ede <idup>:
{
 80000101ede:	55                   	push   %rbp
 80000101edf:	48 89 e5             	mov    %rsp,%rbp
 80000101ee2:	41 54                	push   %r12
 80000101ee4:	53                   	push   %rbx
 80000101ee5:	48 89 fb             	mov    %rdi,%rbx
  acquire(&icache.lock);
 80000101ee8:	49 bc 00 73 11 00 00 	movabs $0x80000117300,%r12
 80000101eef:	08 00 00 
 80000101ef2:	4c 89 e7             	mov    %r12,%rdi
 80000101ef5:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000101efc:	08 00 00 
 80000101eff:	ff d0                	call   *%rax
  ip->ref++;
 80000101f01:	8b 43 08             	mov    0x8(%rbx),%eax
 80000101f04:	83 c0 01             	add    $0x1,%eax
 80000101f07:	89 43 08             	mov    %eax,0x8(%rbx)
  release(&icache.lock);
 80000101f0a:	4c 89 e7             	mov    %r12,%rdi
 80000101f0d:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000101f14:	08 00 00 
 80000101f17:	ff d0                	call   *%rax
}
 80000101f19:	48 89 d8             	mov    %rbx,%rax
 80000101f1c:	5b                   	pop    %rbx
 80000101f1d:	41 5c                	pop    %r12
 80000101f1f:	5d                   	pop    %rbp
 80000101f20:	c3                   	ret

0000080000101f21 <ilock>:
{
 80000101f21:	55                   	push   %rbp
 80000101f22:	48 89 e5             	mov    %rsp,%rbp
 80000101f25:	41 54                	push   %r12
 80000101f27:	53                   	push   %rbx
  if(ip == 0 || ip->ref < 1)
 80000101f28:	48 85 ff             	test   %rdi,%rdi
 80000101f2b:	74 27                	je     80000101f54 <ilock+0x33>
 80000101f2d:	48 89 fb             	mov    %rdi,%rbx
 80000101f30:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
 80000101f34:	7e 1e                	jle    80000101f54 <ilock+0x33>
  acquiresleep(&ip->lock);
 80000101f36:	48 8d 7f 10          	lea    0x10(%rdi),%rdi
 80000101f3a:	48 b8 4d 52 10 00 00 	movabs $0x8000010524d,%rax
 80000101f41:	08 00 00 
 80000101f44:	ff d0                	call   *%rax
  if(ip->valid == 0){
 80000101f46:	83 bb 90 00 00 00 00 	cmpl   $0x0,0x90(%rbx)
 80000101f4d:	74 1b                	je     80000101f6a <ilock+0x49>
}
 80000101f4f:	5b                   	pop    %rbx
 80000101f50:	41 5c                	pop    %r12
 80000101f52:	5d                   	pop    %rbp
 80000101f53:	c3                   	ret
    panic("ilock");
 80000101f54:	48 bf b9 aa 10 00 00 	movabs $0x8000010aab9,%rdi
 80000101f5b:	08 00 00 
 80000101f5e:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000101f65:	08 00 00 
 80000101f68:	ff d0                	call   *%rax
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
 80000101f6a:	8b 73 04             	mov    0x4(%rbx),%esi
 80000101f6d:	c1 ee 03             	shr    $0x3,%esi
 80000101f70:	a1 b4 9d 11 00 00 08 	movabs 0x80000119db4,%eax
 80000101f77:	00 00 
 80000101f79:	01 c6                	add    %eax,%esi
 80000101f7b:	8b 3b                	mov    (%rbx),%edi
 80000101f7d:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 80000101f84:	08 00 00 
 80000101f87:	ff d0                	call   *%rax
 80000101f89:	49 89 c4             	mov    %rax,%r12
    dip = (struct dinode*)bp->data + ip->inum%IPB;
 80000101f8c:	8b 43 04             	mov    0x4(%rbx),%eax
 80000101f8f:	83 e0 07             	and    $0x7,%eax
 80000101f92:	48 c1 e0 06          	shl    $0x6,%rax
 80000101f96:	49 8d b4 04 b0 00 00 	lea    0xb0(%r12,%rax,1),%rsi
 80000101f9d:	00 
    ip->type = dip->type;
 80000101f9e:	8b 06                	mov    (%rsi),%eax
 80000101fa0:	66 89 83 94 00 00 00 	mov    %ax,0x94(%rbx)
    ip->major = dip->major;
 80000101fa7:	66 8b 46 02          	mov    0x2(%rsi),%ax
 80000101fab:	66 89 83 96 00 00 00 	mov    %ax,0x96(%rbx)
    ip->minor = dip->minor;
 80000101fb2:	8b 46 04             	mov    0x4(%rsi),%eax
 80000101fb5:	66 89 83 98 00 00 00 	mov    %ax,0x98(%rbx)
    ip->nlink = dip->nlink;
 80000101fbc:	66 8b 46 06          	mov    0x6(%rsi),%ax
 80000101fc0:	66 89 83 9a 00 00 00 	mov    %ax,0x9a(%rbx)
    ip->size = dip->size;
 80000101fc7:	8b 46 08             	mov    0x8(%rsi),%eax
 80000101fca:	89 83 9c 00 00 00    	mov    %eax,0x9c(%rbx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
 80000101fd0:	48 83 c6 0c          	add    $0xc,%rsi
 80000101fd4:	48 8d bb a0 00 00 00 	lea    0xa0(%rbx),%rdi
 80000101fdb:	ba 34 00 00 00       	mov    $0x34,%edx
 80000101fe0:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 80000101fe7:	08 00 00 
 80000101fea:	ff d0                	call   *%rax
    brelse(bp);
 80000101fec:	4c 89 e7             	mov    %r12,%rdi
 80000101fef:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 80000101ff6:	08 00 00 
 80000101ff9:	ff d0                	call   *%rax
    ip->valid = 1;
 80000101ffb:	c7 83 90 00 00 00 01 	movl   $0x1,0x90(%rbx)
 80000102002:	00 00 00 
    if(ip->type == 0)
 80000102005:	0f bf 83 94 00 00 00 	movswl 0x94(%rbx),%eax
 8000010200c:	85 c0                	test   %eax,%eax
 8000010200e:	0f 85 3b ff ff ff    	jne    80000101f4f <ilock+0x2e>
      panic("ilock: no type");
 80000102014:	48 bf bf aa 10 00 00 	movabs $0x8000010aabf,%rdi
 8000010201b:	08 00 00 
 8000010201e:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000102025:	08 00 00 
 80000102028:	ff d0                	call   *%rax

000008000010202a <iunlock>:
{
 8000010202a:	55                   	push   %rbp
 8000010202b:	48 89 e5             	mov    %rsp,%rbp
 8000010202e:	41 54                	push   %r12
 80000102030:	53                   	push   %rbx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
 80000102031:	48 85 ff             	test   %rdi,%rdi
 80000102034:	74 34                	je     8000010206a <iunlock+0x40>
 80000102036:	48 89 fb             	mov    %rdi,%rbx
 80000102039:	4c 8d 67 10          	lea    0x10(%rdi),%r12
 8000010203d:	4c 89 e7             	mov    %r12,%rdi
 80000102040:	48 b8 fe 52 10 00 00 	movabs $0x800001052fe,%rax
 80000102047:	08 00 00 
 8000010204a:	ff d0                	call   *%rax
 8000010204c:	85 c0                	test   %eax,%eax
 8000010204e:	74 1a                	je     8000010206a <iunlock+0x40>
 80000102050:	83 7b 08 00          	cmpl   $0x0,0x8(%rbx)
 80000102054:	7e 14                	jle    8000010206a <iunlock+0x40>
  releasesleep(&ip->lock);
 80000102056:	4c 89 e7             	mov    %r12,%rdi
 80000102059:	48 b8 b1 52 10 00 00 	movabs $0x800001052b1,%rax
 80000102060:	08 00 00 
 80000102063:	ff d0                	call   *%rax
}
 80000102065:	5b                   	pop    %rbx
 80000102066:	41 5c                	pop    %r12
 80000102068:	5d                   	pop    %rbp
 80000102069:	c3                   	ret
    panic("iunlock");
 8000010206a:	48 bf ce aa 10 00 00 	movabs $0x8000010aace,%rdi
 80000102071:	08 00 00 
 80000102074:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 8000010207b:	08 00 00 
 8000010207e:	ff d0                	call   *%rax

0000080000102080 <iput>:
{
 80000102080:	55                   	push   %rbp
 80000102081:	48 89 e5             	mov    %rsp,%rbp
 80000102084:	41 56                	push   %r14
 80000102086:	41 55                	push   %r13
 80000102088:	41 54                	push   %r12
 8000010208a:	53                   	push   %rbx
 8000010208b:	48 89 fb             	mov    %rdi,%rbx
  acquiresleep(&ip->lock);
 8000010208e:	4c 8d 67 10          	lea    0x10(%rdi),%r12
 80000102092:	4c 89 e7             	mov    %r12,%rdi
 80000102095:	48 b8 4d 52 10 00 00 	movabs $0x8000010524d,%rax
 8000010209c:	08 00 00 
 8000010209f:	ff d0                	call   *%rax
  if(ip->valid && ip->nlink == 0){
 800001020a1:	83 bb 90 00 00 00 00 	cmpl   $0x0,0x90(%rbx)
 800001020a8:	74 0b                	je     800001020b5 <iput+0x35>
 800001020aa:	0f bf 83 9a 00 00 00 	movswl 0x9a(%rbx),%eax
 800001020b1:	85 c0                	test   %eax,%eax
 800001020b3:	74 49                	je     800001020fe <iput+0x7e>
  releasesleep(&ip->lock);
 800001020b5:	4c 89 e7             	mov    %r12,%rdi
 800001020b8:	48 b8 b1 52 10 00 00 	movabs $0x800001052b1,%rax
 800001020bf:	08 00 00 
 800001020c2:	ff d0                	call   *%rax
  acquire(&icache.lock);
 800001020c4:	49 bc 00 73 11 00 00 	movabs $0x80000117300,%r12
 800001020cb:	08 00 00 
 800001020ce:	4c 89 e7             	mov    %r12,%rdi
 800001020d1:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 800001020d8:	08 00 00 
 800001020db:	ff d0                	call   *%rax
  ip->ref--;
 800001020dd:	8b 43 08             	mov    0x8(%rbx),%eax
 800001020e0:	83 e8 01             	sub    $0x1,%eax
 800001020e3:	89 43 08             	mov    %eax,0x8(%rbx)
  release(&icache.lock);
 800001020e6:	4c 89 e7             	mov    %r12,%rdi
 800001020e9:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001020f0:	08 00 00 
 800001020f3:	ff d0                	call   *%rax
}
 800001020f5:	5b                   	pop    %rbx
 800001020f6:	41 5c                	pop    %r12
 800001020f8:	41 5d                	pop    %r13
 800001020fa:	41 5e                	pop    %r14
 800001020fc:	5d                   	pop    %rbp
 800001020fd:	c3                   	ret
    acquire(&icache.lock);
 800001020fe:	49 bd 00 73 11 00 00 	movabs $0x80000117300,%r13
 80000102105:	08 00 00 
 80000102108:	4c 89 ef             	mov    %r13,%rdi
 8000010210b:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000102112:	08 00 00 
 80000102115:	ff d0                	call   *%rax
    int r = ip->ref;
 80000102117:	44 8b 73 08          	mov    0x8(%rbx),%r14d
    release(&icache.lock);
 8000010211b:	4c 89 ef             	mov    %r13,%rdi
 8000010211e:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000102125:	08 00 00 
 80000102128:	ff d0                	call   *%rax
    if(r == 1){
 8000010212a:	41 83 fe 01          	cmp    $0x1,%r14d
 8000010212e:	75 85                	jne    800001020b5 <iput+0x35>
      itrunc(ip);
 80000102130:	48 89 df             	mov    %rbx,%rdi
 80000102133:	48 b8 b9 1d 10 00 00 	movabs $0x80000101db9,%rax
 8000010213a:	08 00 00 
 8000010213d:	ff d0                	call   *%rax
      ip->type = 0;
 8000010213f:	66 c7 83 94 00 00 00 	movw   $0x0,0x94(%rbx)
 80000102146:	00 00 
      iupdate(ip);
 80000102148:	48 89 df             	mov    %rbx,%rdi
 8000010214b:	48 b8 0a 1d 10 00 00 	movabs $0x80000101d0a,%rax
 80000102152:	08 00 00 
 80000102155:	ff d0                	call   *%rax
      ip->valid = 0;
 80000102157:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%rbx)
 8000010215e:	00 00 00 
 80000102161:	e9 4f ff ff ff       	jmp    800001020b5 <iput+0x35>

0000080000102166 <iunlockput>:
{
 80000102166:	55                   	push   %rbp
 80000102167:	48 89 e5             	mov    %rsp,%rbp
 8000010216a:	53                   	push   %rbx
 8000010216b:	48 83 ec 08          	sub    $0x8,%rsp
 8000010216f:	48 89 fb             	mov    %rdi,%rbx
  iunlock(ip);
 80000102172:	48 b8 2a 20 10 00 00 	movabs $0x8000010202a,%rax
 80000102179:	08 00 00 
 8000010217c:	ff d0                	call   *%rax
  iput(ip);
 8000010217e:	48 89 df             	mov    %rbx,%rdi
 80000102181:	48 b8 80 20 10 00 00 	movabs $0x80000102080,%rax
 80000102188:	08 00 00 
 8000010218b:	ff d0                	call   *%rax
}
 8000010218d:	48 83 c4 08          	add    $0x8,%rsp
 80000102191:	5b                   	pop    %rbx
 80000102192:	5d                   	pop    %rbp
 80000102193:	c3                   	ret

0000080000102194 <stati>:
  st->dev = ip->dev;
 80000102194:	8b 07                	mov    (%rdi),%eax
 80000102196:	89 46 04             	mov    %eax,0x4(%rsi)
  st->ino = ip->inum;
 80000102199:	8b 47 04             	mov    0x4(%rdi),%eax
 8000010219c:	89 46 08             	mov    %eax,0x8(%rsi)
  st->type = ip->type;
 8000010219f:	8b 87 94 00 00 00    	mov    0x94(%rdi),%eax
 800001021a5:	66 89 06             	mov    %ax,(%rsi)
  st->nlink = ip->nlink;
 800001021a8:	66 8b 87 9a 00 00 00 	mov    0x9a(%rdi),%ax
 800001021af:	66 89 46 0c          	mov    %ax,0xc(%rsi)
  st->size = ip->size;
 800001021b3:	8b 87 9c 00 00 00    	mov    0x9c(%rdi),%eax
 800001021b9:	89 46 10             	mov    %eax,0x10(%rsi)
}
 800001021bc:	c3                   	ret

00000800001021bd <readi>:
{
 800001021bd:	55                   	push   %rbp
 800001021be:	48 89 e5             	mov    %rsp,%rbp
 800001021c1:	41 57                	push   %r15
 800001021c3:	41 56                	push   %r14
 800001021c5:	41 55                	push   %r13
 800001021c7:	41 54                	push   %r12
 800001021c9:	53                   	push   %rbx
 800001021ca:	48 83 ec 18          	sub    $0x18,%rsp
 800001021ce:	49 89 ff             	mov    %rdi,%r15
 800001021d1:	49 89 f6             	mov    %rsi,%r14
 800001021d4:	89 4d c4             	mov    %ecx,-0x3c(%rbp)
  if(ip->type == T_DEV){
 800001021d7:	0f bf 87 94 00 00 00 	movswl 0x94(%rdi),%eax
 800001021de:	83 f8 03             	cmp    $0x3,%eax
 800001021e1:	74 32                	je     80000102215 <readi+0x58>
 800001021e3:	41 89 d4             	mov    %edx,%r12d
  if(off > ip->size || off + n < off)
 800001021e6:	8b 87 9c 00 00 00    	mov    0x9c(%rdi),%eax
 800001021ec:	39 d0                	cmp    %edx,%eax
 800001021ee:	0f 82 02 01 00 00    	jb     800001022f6 <readi+0x139>
 800001021f4:	8b 55 c4             	mov    -0x3c(%rbp),%edx
 800001021f7:	44 01 e2             	add    %r12d,%edx
 800001021fa:	0f 82 fd 00 00 00    	jb     800001022fd <readi+0x140>
  if(off + n > ip->size)
 80000102200:	39 d0                	cmp    %edx,%eax
 80000102202:	73 06                	jae    8000010220a <readi+0x4d>
    n = ip->size - off;
 80000102204:	44 29 e0             	sub    %r12d,%eax
 80000102207:	89 45 c4             	mov    %eax,-0x3c(%rbp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
 8000010220a:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 80000102210:	e9 b8 00 00 00       	jmp    800001022cd <readi+0x110>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
 80000102215:	66 8b 87 96 00 00 00 	mov    0x96(%rdi),%ax
 8000010221c:	0f b7 d0             	movzwl %ax,%edx
 8000010221f:	83 fa 09             	cmp    $0x9,%edx
 80000102222:	0f 87 c0 00 00 00    	ja     800001022e8 <readi+0x12b>
 80000102228:	48 0f bf c0          	movswq %ax,%rax
 8000010222c:	48 c1 e0 04          	shl    $0x4,%rax
 80000102230:	48 ba 60 72 11 00 00 	movabs $0x80000117260,%rdx
 80000102237:	08 00 00 
 8000010223a:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
 8000010223e:	48 85 c0             	test   %rax,%rax
 80000102241:	0f 84 a8 00 00 00    	je     800001022ef <readi+0x132>
    return devsw[ip->major].read(ip, dst, n);
 80000102247:	89 ca                	mov    %ecx,%edx
 80000102249:	ff d0                	call   *%rax
 8000010224b:	e9 89 00 00 00       	jmp    800001022d9 <readi+0x11c>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
 80000102250:	44 89 e6             	mov    %r12d,%esi
 80000102253:	c1 ee 09             	shr    $0x9,%esi
 80000102256:	4c 89 ff             	mov    %r15,%rdi
 80000102259:	48 b8 27 19 10 00 00 	movabs $0x80000101927,%rax
 80000102260:	08 00 00 
 80000102263:	ff d0                	call   *%rax
 80000102265:	89 c6                	mov    %eax,%esi
 80000102267:	41 8b 3f             	mov    (%r15),%edi
 8000010226a:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 80000102271:	08 00 00 
 80000102274:	ff d0                	call   *%rax
 80000102276:	48 89 c1             	mov    %rax,%rcx
    m = min(n - tot, BSIZE - off%BSIZE);
 80000102279:	44 89 e0             	mov    %r12d,%eax
 8000010227c:	25 ff 01 00 00       	and    $0x1ff,%eax
 80000102281:	bb 00 02 00 00       	mov    $0x200,%ebx
 80000102286:	29 c3                	sub    %eax,%ebx
 80000102288:	8b 55 c4             	mov    -0x3c(%rbp),%edx
 8000010228b:	44 29 ea             	sub    %r13d,%edx
 8000010228e:	39 d3                	cmp    %edx,%ebx
 80000102290:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
 80000102293:	89 c0                	mov    %eax,%eax
 80000102295:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 80000102299:	48 8d b4 01 b0 00 00 	lea    0xb0(%rcx,%rax,1),%rsi
 800001022a0:	00 
 800001022a1:	89 da                	mov    %ebx,%edx
 800001022a3:	4c 89 f7             	mov    %r14,%rdi
 800001022a6:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 800001022ad:	08 00 00 
 800001022b0:	ff d0                	call   *%rax
    brelse(bp);
 800001022b2:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
 800001022b6:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 800001022bd:	08 00 00 
 800001022c0:	ff d0                	call   *%rax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
 800001022c2:	41 01 dd             	add    %ebx,%r13d
 800001022c5:	41 01 dc             	add    %ebx,%r12d
 800001022c8:	89 db                	mov    %ebx,%ebx
 800001022ca:	49 01 de             	add    %rbx,%r14
 800001022cd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
 800001022d0:	41 39 c5             	cmp    %eax,%r13d
 800001022d3:	0f 82 77 ff ff ff    	jb     80000102250 <readi+0x93>
}
 800001022d9:	48 83 c4 18          	add    $0x18,%rsp
 800001022dd:	5b                   	pop    %rbx
 800001022de:	41 5c                	pop    %r12
 800001022e0:	41 5d                	pop    %r13
 800001022e2:	41 5e                	pop    %r14
 800001022e4:	41 5f                	pop    %r15
 800001022e6:	5d                   	pop    %rbp
 800001022e7:	c3                   	ret
      return -1;
 800001022e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 800001022ed:	eb ea                	jmp    800001022d9 <readi+0x11c>
 800001022ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 800001022f4:	eb e3                	jmp    800001022d9 <readi+0x11c>
    return -1;
 800001022f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 800001022fb:	eb dc                	jmp    800001022d9 <readi+0x11c>
 800001022fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000102302:	eb d5                	jmp    800001022d9 <readi+0x11c>

0000080000102304 <writei>:
{
 80000102304:	55                   	push   %rbp
 80000102305:	48 89 e5             	mov    %rsp,%rbp
 80000102308:	41 57                	push   %r15
 8000010230a:	41 56                	push   %r14
 8000010230c:	41 55                	push   %r13
 8000010230e:	41 54                	push   %r12
 80000102310:	53                   	push   %rbx
 80000102311:	48 83 ec 18          	sub    $0x18,%rsp
 80000102315:	49 89 ff             	mov    %rdi,%r15
 80000102318:	49 89 f6             	mov    %rsi,%r14
 8000010231b:	89 4d c4             	mov    %ecx,-0x3c(%rbp)
  if(ip->type == T_DEV){
 8000010231e:	0f bf 87 94 00 00 00 	movswl 0x94(%rdi),%eax
 80000102325:	83 f8 03             	cmp    $0x3,%eax
 80000102328:	74 30                	je     8000010235a <writei+0x56>
 8000010232a:	41 89 d4             	mov    %edx,%r12d
  if(off > ip->size || off + n < off)
 8000010232d:	39 97 9c 00 00 00    	cmp    %edx,0x9c(%rdi)
 80000102333:	0f 82 3b 01 00 00    	jb     80000102474 <writei+0x170>
 80000102339:	8b 45 c4             	mov    -0x3c(%rbp),%eax
 8000010233c:	01 d0                	add    %edx,%eax
 8000010233e:	0f 82 37 01 00 00    	jb     8000010247b <writei+0x177>
  if(off + n > MAXFILE*BSIZE)
 80000102344:	3d 00 18 01 00       	cmp    $0x11800,%eax
 80000102349:	0f 87 33 01 00 00    	ja     80000102482 <writei+0x17e>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
 8000010234f:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 80000102355:	e9 c9 00 00 00       	jmp    80000102423 <writei+0x11f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
 8000010235a:	66 8b 87 96 00 00 00 	mov    0x96(%rdi),%ax
 80000102361:	0f b7 d0             	movzwl %ax,%edx
 80000102364:	83 fa 09             	cmp    $0x9,%edx
 80000102367:	0f 87 f9 00 00 00    	ja     80000102466 <writei+0x162>
 8000010236d:	48 0f bf c0          	movswq %ax,%rax
 80000102371:	48 c1 e0 04          	shl    $0x4,%rax
 80000102375:	48 ba 60 72 11 00 00 	movabs $0x80000117260,%rdx
 8000010237c:	08 00 00 
 8000010237f:	48 8b 44 02 08       	mov    0x8(%rdx,%rax,1),%rax
 80000102384:	48 85 c0             	test   %rax,%rax
 80000102387:	0f 84 e0 00 00 00    	je     8000010246d <writei+0x169>
    return devsw[ip->major].write(ip, src, n);
 8000010238d:	89 ca                	mov    %ecx,%edx
 8000010238f:	ff d0                	call   *%rax
 80000102391:	e9 a9 00 00 00       	jmp    8000010243f <writei+0x13b>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
 80000102396:	44 89 e6             	mov    %r12d,%esi
 80000102399:	c1 ee 09             	shr    $0x9,%esi
 8000010239c:	4c 89 ff             	mov    %r15,%rdi
 8000010239f:	48 b8 27 19 10 00 00 	movabs $0x80000101927,%rax
 800001023a6:	08 00 00 
 800001023a9:	ff d0                	call   *%rax
 800001023ab:	89 c6                	mov    %eax,%esi
 800001023ad:	41 8b 3f             	mov    (%r15),%edi
 800001023b0:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 800001023b7:	08 00 00 
 800001023ba:	ff d0                	call   *%rax
 800001023bc:	48 89 c1             	mov    %rax,%rcx
    m = min(n - tot, BSIZE - off%BSIZE);
 800001023bf:	44 89 e0             	mov    %r12d,%eax
 800001023c2:	25 ff 01 00 00       	and    $0x1ff,%eax
 800001023c7:	bb 00 02 00 00       	mov    $0x200,%ebx
 800001023cc:	29 c3                	sub    %eax,%ebx
 800001023ce:	8b 55 c4             	mov    -0x3c(%rbp),%edx
 800001023d1:	44 29 ea             	sub    %r13d,%edx
 800001023d4:	39 d3                	cmp    %edx,%ebx
 800001023d6:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
 800001023d9:	89 c0                	mov    %eax,%eax
 800001023db:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 800001023df:	48 8d bc 01 b0 00 00 	lea    0xb0(%rcx,%rax,1),%rdi
 800001023e6:	00 
 800001023e7:	89 da                	mov    %ebx,%edx
 800001023e9:	4c 89 f6             	mov    %r14,%rsi
 800001023ec:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 800001023f3:	08 00 00 
 800001023f6:	ff d0                	call   *%rax
    log_write(bp);
 800001023f8:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
 800001023fc:	48 b8 ec 38 10 00 00 	movabs $0x800001038ec,%rax
 80000102403:	08 00 00 
 80000102406:	ff d0                	call   *%rax
    brelse(bp);
 80000102408:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
 8000010240c:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 80000102413:	08 00 00 
 80000102416:	ff d0                	call   *%rax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
 80000102418:	41 01 dd             	add    %ebx,%r13d
 8000010241b:	41 01 dc             	add    %ebx,%r12d
 8000010241e:	89 db                	mov    %ebx,%ebx
 80000102420:	49 01 de             	add    %rbx,%r14
 80000102423:	8b 45 c4             	mov    -0x3c(%rbp),%eax
 80000102426:	41 39 c5             	cmp    %eax,%r13d
 80000102429:	0f 82 67 ff ff ff    	jb     80000102396 <writei+0x92>
  if(n > 0 && off > ip->size){
 8000010242f:	85 c0                	test   %eax,%eax
 80000102431:	74 09                	je     8000010243c <writei+0x138>
 80000102433:	45 39 a7 9c 00 00 00 	cmp    %r12d,0x9c(%r15)
 8000010243a:	72 12                	jb     8000010244e <writei+0x14a>
  return n;
 8000010243c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
}
 8000010243f:	48 83 c4 18          	add    $0x18,%rsp
 80000102443:	5b                   	pop    %rbx
 80000102444:	41 5c                	pop    %r12
 80000102446:	41 5d                	pop    %r13
 80000102448:	41 5e                	pop    %r14
 8000010244a:	41 5f                	pop    %r15
 8000010244c:	5d                   	pop    %rbp
 8000010244d:	c3                   	ret
    ip->size = off;
 8000010244e:	45 89 a7 9c 00 00 00 	mov    %r12d,0x9c(%r15)
    iupdate(ip);
 80000102455:	4c 89 ff             	mov    %r15,%rdi
 80000102458:	48 b8 0a 1d 10 00 00 	movabs $0x80000101d0a,%rax
 8000010245f:	08 00 00 
 80000102462:	ff d0                	call   *%rax
 80000102464:	eb d6                	jmp    8000010243c <writei+0x138>
      return -1;
 80000102466:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8000010246b:	eb d2                	jmp    8000010243f <writei+0x13b>
 8000010246d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000102472:	eb cb                	jmp    8000010243f <writei+0x13b>
    return -1;
 80000102474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000102479:	eb c4                	jmp    8000010243f <writei+0x13b>
 8000010247b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000102480:	eb bd                	jmp    8000010243f <writei+0x13b>
    return -1;
 80000102482:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000102487:	eb b6                	jmp    8000010243f <writei+0x13b>

0000080000102489 <namecmp>:
{
 80000102489:	55                   	push   %rbp
 8000010248a:	48 89 e5             	mov    %rsp,%rbp
  return strncmp(s, t, DIRSIZ);
 8000010248d:	ba 0e 00 00 00       	mov    $0xe,%edx
 80000102492:	48 b8 f5 56 10 00 00 	movabs $0x800001056f5,%rax
 80000102499:	08 00 00 
 8000010249c:	ff d0                	call   *%rax
}
 8000010249e:	5d                   	pop    %rbp
 8000010249f:	c3                   	ret

00000800001024a0 <dirlookup>:
{
 800001024a0:	55                   	push   %rbp
 800001024a1:	48 89 e5             	mov    %rsp,%rbp
 800001024a4:	41 56                	push   %r14
 800001024a6:	41 55                	push   %r13
 800001024a8:	41 54                	push   %r12
 800001024aa:	53                   	push   %rbx
 800001024ab:	48 83 ec 10          	sub    $0x10,%rsp
  if(dp->type != T_DIR)
 800001024af:	0f bf 87 94 00 00 00 	movswl 0x94(%rdi),%eax
 800001024b6:	83 f8 01             	cmp    $0x1,%eax
 800001024b9:	75 10                	jne    800001024cb <dirlookup+0x2b>
 800001024bb:	49 89 fc             	mov    %rdi,%r12
 800001024be:	49 89 f5             	mov    %rsi,%r13
 800001024c1:	49 89 d6             	mov    %rdx,%r14
  for(off = 0; off < dp->size; off += sizeof(de)){
 800001024c4:	bb 00 00 00 00       	mov    $0x0,%ebx
 800001024c9:	eb 2f                	jmp    800001024fa <dirlookup+0x5a>
    panic("dirlookup not DIR");
 800001024cb:	48 bf d6 aa 10 00 00 	movabs $0x8000010aad6,%rdi
 800001024d2:	08 00 00 
 800001024d5:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001024dc:	08 00 00 
 800001024df:	ff d0                	call   *%rax
      panic("dirlookup read");
 800001024e1:	48 bf e8 aa 10 00 00 	movabs $0x8000010aae8,%rdi
 800001024e8:	08 00 00 
 800001024eb:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001024f2:	08 00 00 
 800001024f5:	ff d0                	call   *%rax
  for(off = 0; off < dp->size; off += sizeof(de)){
 800001024f7:	83 c3 10             	add    $0x10,%ebx
 800001024fa:	41 3b 9c 24 9c 00 00 	cmp    0x9c(%r12),%ebx
 80000102501:	00 
 80000102502:	73 5c                	jae    80000102560 <dirlookup+0xc0>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
 80000102504:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
 80000102508:	b9 10 00 00 00       	mov    $0x10,%ecx
 8000010250d:	89 da                	mov    %ebx,%edx
 8000010250f:	4c 89 e7             	mov    %r12,%rdi
 80000102512:	48 b8 bd 21 10 00 00 	movabs $0x800001021bd,%rax
 80000102519:	08 00 00 
 8000010251c:	ff d0                	call   *%rax
 8000010251e:	83 f8 10             	cmp    $0x10,%eax
 80000102521:	75 be                	jne    800001024e1 <dirlookup+0x41>
    if(de.inum == 0)
 80000102523:	0f b7 45 d0          	movzwl -0x30(%rbp),%eax
 80000102527:	85 c0                	test   %eax,%eax
 80000102529:	74 cc                	je     800001024f7 <dirlookup+0x57>
    if(namecmp(name, de.name) == 0){
 8000010252b:	48 8d 75 d2          	lea    -0x2e(%rbp),%rsi
 8000010252f:	4c 89 ef             	mov    %r13,%rdi
 80000102532:	48 b8 89 24 10 00 00 	movabs $0x80000102489,%rax
 80000102539:	08 00 00 
 8000010253c:	ff d0                	call   *%rax
 8000010253e:	85 c0                	test   %eax,%eax
 80000102540:	75 b5                	jne    800001024f7 <dirlookup+0x57>
      if(poff)
 80000102542:	4d 85 f6             	test   %r14,%r14
 80000102545:	74 03                	je     8000010254a <dirlookup+0xaa>
        *poff = off;
 80000102547:	41 89 1e             	mov    %ebx,(%r14)
      inum = de.inum;
 8000010254a:	0f b7 75 d0          	movzwl -0x30(%rbp),%esi
      return iget(dp->dev, inum);
 8000010254e:	41 8b 3c 24          	mov    (%r12),%edi
 80000102552:	48 b8 1a 1a 10 00 00 	movabs $0x80000101a1a,%rax
 80000102559:	08 00 00 
 8000010255c:	ff d0                	call   *%rax
 8000010255e:	eb 05                	jmp    80000102565 <dirlookup+0xc5>
  return 0;
 80000102560:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000102565:	48 83 c4 10          	add    $0x10,%rsp
 80000102569:	5b                   	pop    %rbx
 8000010256a:	41 5c                	pop    %r12
 8000010256c:	41 5d                	pop    %r13
 8000010256e:	41 5e                	pop    %r14
 80000102570:	5d                   	pop    %rbp
 80000102571:	c3                   	ret

0000080000102572 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
 80000102572:	55                   	push   %rbp
 80000102573:	48 89 e5             	mov    %rsp,%rbp
 80000102576:	41 57                	push   %r15
 80000102578:	41 56                	push   %r14
 8000010257a:	41 55                	push   %r13
 8000010257c:	41 54                	push   %r12
 8000010257e:	53                   	push   %rbx
 8000010257f:	48 83 ec 08          	sub    $0x8,%rsp
 80000102583:	48 89 fb             	mov    %rdi,%rbx
 80000102586:	41 89 f7             	mov    %esi,%r15d
 80000102589:	49 89 d6             	mov    %rdx,%r14
  struct inode *ip, *next;

  if(*path == '/')
 8000010258c:	0f be 07             	movsbl (%rdi),%eax
 8000010258f:	83 f8 2f             	cmp    $0x2f,%eax
 80000102592:	74 26                	je     800001025ba <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
 80000102594:	b0 00                	mov    $0x0,%al
 80000102596:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 8000010259d:	08 00 00 
 800001025a0:	ff d2                	call   *%rdx
 800001025a2:	48 8b b8 c8 00 00 00 	mov    0xc8(%rax),%rdi
 800001025a9:	48 b8 de 1e 10 00 00 	movabs $0x80000101ede,%rax
 800001025b0:	08 00 00 
 800001025b3:	ff d0                	call   *%rax
 800001025b5:	49 89 c4             	mov    %rax,%r12
 800001025b8:	eb 73                	jmp    8000010262d <namex+0xbb>
    ip = iget(ROOTDEV, ROOTINO);
 800001025ba:	be 01 00 00 00       	mov    $0x1,%esi
 800001025bf:	bf 01 00 00 00       	mov    $0x1,%edi
 800001025c4:	48 b8 1a 1a 10 00 00 	movabs $0x80000101a1a,%rax
 800001025cb:	08 00 00 
 800001025ce:	ff d0                	call   *%rax
 800001025d0:	49 89 c4             	mov    %rax,%r12
 800001025d3:	eb 58                	jmp    8000010262d <namex+0xbb>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
 800001025d5:	4c 89 e7             	mov    %r12,%rdi
 800001025d8:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 800001025df:	08 00 00 
 800001025e2:	ff d0                	call   *%rax
      return 0;
 800001025e4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
 800001025ea:	4c 89 e0             	mov    %r12,%rax
 800001025ed:	48 83 c4 08          	add    $0x8,%rsp
 800001025f1:	5b                   	pop    %rbx
 800001025f2:	41 5c                	pop    %r12
 800001025f4:	41 5d                	pop    %r13
 800001025f6:	41 5e                	pop    %r14
 800001025f8:	41 5f                	pop    %r15
 800001025fa:	5d                   	pop    %rbp
 800001025fb:	c3                   	ret
    if((next = dirlookup(ip, name, 0)) == 0){
 800001025fc:	ba 00 00 00 00       	mov    $0x0,%edx
 80000102601:	4c 89 f6             	mov    %r14,%rsi
 80000102604:	4c 89 e7             	mov    %r12,%rdi
 80000102607:	48 b8 a0 24 10 00 00 	movabs $0x800001024a0,%rax
 8000010260e:	08 00 00 
 80000102611:	ff d0                	call   *%rax
 80000102613:	49 89 c5             	mov    %rax,%r13
 80000102616:	48 85 c0             	test   %rax,%rax
 80000102619:	74 6d                	je     80000102688 <namex+0x116>
    iunlockput(ip);
 8000010261b:	4c 89 e7             	mov    %r12,%rdi
 8000010261e:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000102625:	08 00 00 
 80000102628:	ff d0                	call   *%rax
    ip = next;
 8000010262a:	4d 89 ec             	mov    %r13,%r12
  while((path = skipelem(path, name)) != 0){
 8000010262d:	4c 89 f6             	mov    %r14,%rsi
 80000102630:	48 89 df             	mov    %rbx,%rdi
 80000102633:	48 b8 60 16 10 00 00 	movabs $0x80000101660,%rax
 8000010263a:	08 00 00 
 8000010263d:	ff d0                	call   *%rax
 8000010263f:	48 89 c3             	mov    %rax,%rbx
 80000102642:	48 85 c0             	test   %rax,%rax
 80000102645:	74 58                	je     8000010269f <namex+0x12d>
    ilock(ip);
 80000102647:	4c 89 e7             	mov    %r12,%rdi
 8000010264a:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 80000102651:	08 00 00 
 80000102654:	ff d0                	call   *%rax
    if(ip->type != T_DIR){
 80000102656:	41 0f bf 84 24 94 00 	movswl 0x94(%r12),%eax
 8000010265d:	00 00 
 8000010265f:	83 f8 01             	cmp    $0x1,%eax
 80000102662:	0f 85 6d ff ff ff    	jne    800001025d5 <namex+0x63>
    if(nameiparent && *path == '\0'){
 80000102668:	45 85 ff             	test   %r15d,%r15d
 8000010266b:	74 8f                	je     800001025fc <namex+0x8a>
 8000010266d:	0f be 03             	movsbl (%rbx),%eax
 80000102670:	85 c0                	test   %eax,%eax
 80000102672:	75 88                	jne    800001025fc <namex+0x8a>
      iunlock(ip);
 80000102674:	4c 89 e7             	mov    %r12,%rdi
 80000102677:	48 b8 2a 20 10 00 00 	movabs $0x8000010202a,%rax
 8000010267e:	08 00 00 
 80000102681:	ff d0                	call   *%rax
      return ip;
 80000102683:	e9 62 ff ff ff       	jmp    800001025ea <namex+0x78>
      iunlockput(ip);
 80000102688:	4c 89 e7             	mov    %r12,%rdi
 8000010268b:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000102692:	08 00 00 
 80000102695:	ff d0                	call   *%rax
      return 0;
 80000102697:	4d 89 ec             	mov    %r13,%r12
 8000010269a:	e9 4b ff ff ff       	jmp    800001025ea <namex+0x78>
  if(nameiparent){
 8000010269f:	45 85 ff             	test   %r15d,%r15d
 800001026a2:	0f 84 42 ff ff ff    	je     800001025ea <namex+0x78>
    iput(ip);
 800001026a8:	4c 89 e7             	mov    %r12,%rdi
 800001026ab:	48 b8 80 20 10 00 00 	movabs $0x80000102080,%rax
 800001026b2:	08 00 00 
 800001026b5:	ff d0                	call   *%rax
    return 0;
 800001026b7:	49 89 dc             	mov    %rbx,%r12
 800001026ba:	e9 2b ff ff ff       	jmp    800001025ea <namex+0x78>

00000800001026bf <dirlink>:
{
 800001026bf:	55                   	push   %rbp
 800001026c0:	48 89 e5             	mov    %rsp,%rbp
 800001026c3:	41 57                	push   %r15
 800001026c5:	41 56                	push   %r14
 800001026c7:	41 55                	push   %r13
 800001026c9:	41 54                	push   %r12
 800001026cb:	53                   	push   %rbx
 800001026cc:	48 83 ec 18          	sub    $0x18,%rsp
 800001026d0:	49 89 fc             	mov    %rdi,%r12
 800001026d3:	49 89 f6             	mov    %rsi,%r14
 800001026d6:	41 89 d7             	mov    %edx,%r15d
  if((ip = dirlookup(dp, name, 0)) != 0){
 800001026d9:	ba 00 00 00 00       	mov    $0x0,%edx
 800001026de:	48 b8 a0 24 10 00 00 	movabs $0x800001024a0,%rax
 800001026e5:	08 00 00 
 800001026e8:	ff d0                	call   *%rax
 800001026ea:	48 85 c0             	test   %rax,%rax
 800001026ed:	75 3e                	jne    8000010272d <dirlink+0x6e>
  for(off = 0; off < dp->size; off += sizeof(de)){
 800001026ef:	bb 00 00 00 00       	mov    $0x0,%ebx
 800001026f4:	41 89 dd             	mov    %ebx,%r13d
 800001026f7:	41 3b 9c 24 9c 00 00 	cmp    0x9c(%r12),%ebx
 800001026fe:	00 
 800001026ff:	73 58                	jae    80000102759 <dirlink+0x9a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
 80000102701:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
 80000102705:	b9 10 00 00 00       	mov    $0x10,%ecx
 8000010270a:	89 da                	mov    %ebx,%edx
 8000010270c:	4c 89 e7             	mov    %r12,%rdi
 8000010270f:	48 b8 bd 21 10 00 00 	movabs $0x800001021bd,%rax
 80000102716:	08 00 00 
 80000102719:	ff d0                	call   *%rax
 8000010271b:	83 f8 10             	cmp    $0x10,%eax
 8000010271e:	75 23                	jne    80000102743 <dirlink+0x84>
    if(de.inum == 0)
 80000102720:	0f b7 45 c0          	movzwl -0x40(%rbp),%eax
 80000102724:	85 c0                	test   %eax,%eax
 80000102726:	74 31                	je     80000102759 <dirlink+0x9a>
  for(off = 0; off < dp->size; off += sizeof(de)){
 80000102728:	83 c3 10             	add    $0x10,%ebx
 8000010272b:	eb c7                	jmp    800001026f4 <dirlink+0x35>
    iput(ip);
 8000010272d:	48 89 c7             	mov    %rax,%rdi
 80000102730:	48 b8 80 20 10 00 00 	movabs $0x80000102080,%rax
 80000102737:	08 00 00 
 8000010273a:	ff d0                	call   *%rax
    return -1;
 8000010273c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000102741:	eb 5b                	jmp    8000010279e <dirlink+0xdf>
      panic("dirlink read");
 80000102743:	48 bf f7 aa 10 00 00 	movabs $0x8000010aaf7,%rdi
 8000010274a:	08 00 00 
 8000010274d:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000102754:	08 00 00 
 80000102757:	ff d0                	call   *%rax
  strncpy(de.name, name, DIRSIZ);
 80000102759:	48 8d 5d c0          	lea    -0x40(%rbp),%rbx
 8000010275d:	48 8d 7d c2          	lea    -0x3e(%rbp),%rdi
 80000102761:	ba 0e 00 00 00       	mov    $0xe,%edx
 80000102766:	4c 89 f6             	mov    %r14,%rsi
 80000102769:	48 b8 2b 57 10 00 00 	movabs $0x8000010572b,%rax
 80000102770:	08 00 00 
 80000102773:	ff d0                	call   *%rax
  de.inum = inum;
 80000102775:	66 44 89 7d c0       	mov    %r15w,-0x40(%rbp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
 8000010277a:	b9 10 00 00 00       	mov    $0x10,%ecx
 8000010277f:	44 89 ea             	mov    %r13d,%edx
 80000102782:	48 89 de             	mov    %rbx,%rsi
 80000102785:	4c 89 e7             	mov    %r12,%rdi
 80000102788:	48 b8 04 23 10 00 00 	movabs $0x80000102304,%rax
 8000010278f:	08 00 00 
 80000102792:	ff d0                	call   *%rax
 80000102794:	83 f8 10             	cmp    $0x10,%eax
 80000102797:	75 14                	jne    800001027ad <dirlink+0xee>
  return 0;
 80000102799:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8000010279e:	48 83 c4 18          	add    $0x18,%rsp
 800001027a2:	5b                   	pop    %rbx
 800001027a3:	41 5c                	pop    %r12
 800001027a5:	41 5d                	pop    %r13
 800001027a7:	41 5e                	pop    %r14
 800001027a9:	41 5f                	pop    %r15
 800001027ab:	5d                   	pop    %rbp
 800001027ac:	c3                   	ret
    panic("dirlink");
 800001027ad:	48 bf 65 ad 10 00 00 	movabs $0x8000010ad65,%rdi
 800001027b4:	08 00 00 
 800001027b7:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001027be:	08 00 00 
 800001027c1:	ff d0                	call   *%rax

00000800001027c3 <namei>:

struct inode*
namei(char *path)
{
 800001027c3:	55                   	push   %rbp
 800001027c4:	48 89 e5             	mov    %rsp,%rbp
 800001027c7:	48 83 ec 10          	sub    $0x10,%rsp
  char name[DIRSIZ];
  return namex(path, 0, name);
 800001027cb:	48 8d 55 f2          	lea    -0xe(%rbp),%rdx
 800001027cf:	be 00 00 00 00       	mov    $0x0,%esi
 800001027d4:	48 b8 72 25 10 00 00 	movabs $0x80000102572,%rax
 800001027db:	08 00 00 
 800001027de:	ff d0                	call   *%rax
}
 800001027e0:	48 89 ec             	mov    %rbp,%rsp
 800001027e3:	5d                   	pop    %rbp
 800001027e4:	c3                   	ret

00000800001027e5 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
 800001027e5:	55                   	push   %rbp
 800001027e6:	48 89 e5             	mov    %rsp,%rbp
 800001027e9:	48 89 f2             	mov    %rsi,%rdx
  return namex(path, 1, name);
 800001027ec:	be 01 00 00 00       	mov    $0x1,%esi
 800001027f1:	48 b8 72 25 10 00 00 	movabs $0x80000102572,%rax
 800001027f8:	08 00 00 
 800001027fb:	ff d0                	call   *%rax
}
 800001027fd:	5d                   	pop    %rbp
 800001027fe:	c3                   	ret
 800001027ff:	90                   	nop

0000080000102800 <idewait>:
    asm volatile("in %1,%0" : "=a" (data) : "d" (port));
 80000102800:	ba f7 01 00 00       	mov    $0x1f7,%edx
 80000102805:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
 80000102806:	89 c2                	mov    %eax,%edx
 80000102808:	81 e2 c0 00 00 00    	and    $0xc0,%edx
 8000010280e:	83 fa 40             	cmp    $0x40,%edx
 80000102811:	75 ed                	jne    80000102800 <idewait>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
 80000102813:	85 ff                	test   %edi,%edi
 80000102815:	74 09                	je     80000102820 <idewait+0x20>
 80000102817:	a8 21                	test   $0x21,%al
 80000102819:	75 08                	jne    80000102823 <idewait+0x23>
    return -1;
  return 0;
 8000010281b:	bf 00 00 00 00       	mov    $0x0,%edi
}
 80000102820:	89 f8                	mov    %edi,%eax
 80000102822:	c3                   	ret
    return -1;
 80000102823:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 80000102828:	eb f6                	jmp    80000102820 <idewait+0x20>

000008000010282a <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
 8000010282a:	55                   	push   %rbp
 8000010282b:	48 89 e5             	mov    %rsp,%rbp
 8000010282e:	41 54                	push   %r12
 80000102830:	53                   	push   %rbx
  if(b == 0)
 80000102831:	48 85 ff             	test   %rdi,%rdi
 80000102834:	0f 84 99 00 00 00    	je     800001028d3 <idestart+0xa9>
 8000010283a:	48 89 fb             	mov    %rdi,%rbx
    panic("idestart");
  if(b->blockno >= FSSIZE)
 8000010283d:	44 8b 67 08          	mov    0x8(%rdi),%r12d
 80000102841:	41 81 fc e7 03 00 00 	cmp    $0x3e7,%r12d
 80000102848:	0f 87 9b 00 00 00    	ja     800001028e9 <idestart+0xbf>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
 8000010284e:	bf 00 00 00 00       	mov    $0x0,%edi
 80000102853:	48 b8 00 28 10 00 00 	movabs $0x80000102800,%rax
 8000010285a:	08 00 00 
 8000010285d:	ff d0                	call   *%rax
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 8000010285f:	b0 00                	mov    $0x0,%al
 80000102861:	ba f6 03 00 00       	mov    $0x3f6,%edx
 80000102866:	ee                   	out    %al,(%dx)
 80000102867:	b0 01                	mov    $0x1,%al
 80000102869:	ba f2 01 00 00       	mov    $0x1f2,%edx
 8000010286e:	ee                   	out    %al,(%dx)
 8000010286f:	ba f3 01 00 00       	mov    $0x1f3,%edx
 80000102874:	44 88 e0             	mov    %r12b,%al
 80000102877:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
 80000102878:	44 89 e0             	mov    %r12d,%eax
 8000010287b:	0f b6 c4             	movzbl %ah,%eax
 8000010287e:	ba f4 01 00 00       	mov    $0x1f4,%edx
 80000102883:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
 80000102884:	44 89 e0             	mov    %r12d,%eax
 80000102887:	c1 f8 10             	sar    $0x10,%eax
 8000010288a:	ba f5 01 00 00       	mov    $0x1f5,%edx
 8000010288f:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
 80000102890:	8b 43 04             	mov    0x4(%rbx),%eax
 80000102893:	c1 e0 04             	shl    $0x4,%eax
 80000102896:	83 e0 10             	and    $0x10,%eax
 80000102899:	41 c1 fc 18          	sar    $0x18,%r12d
 8000010289d:	41 83 e4 0f          	and    $0xf,%r12d
 800001028a1:	44 09 e0             	or     %r12d,%eax
 800001028a4:	83 c8 e0             	or     $0xffffffe0,%eax
 800001028a7:	ba f6 01 00 00       	mov    $0x1f6,%edx
 800001028ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
 800001028ad:	f6 03 04             	testb  $0x4,(%rbx)
 800001028b0:	74 4d                	je     800001028ff <idestart+0xd5>
 800001028b2:	b0 30                	mov    $0x30,%al
 800001028b4:	ba f7 01 00 00       	mov    $0x1f7,%edx
 800001028b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
 800001028ba:	48 8d b3 b0 00 00 00 	lea    0xb0(%rbx),%rsi
    asm volatile("cld; rep outsl" :
 800001028c1:	b9 80 00 00 00       	mov    $0x80,%ecx
 800001028c6:	ba f0 01 00 00       	mov    $0x1f0,%edx
 800001028cb:	fc                   	cld
 800001028cc:	f3 6f                	rep outsl %ds:(%rsi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
 800001028ce:	5b                   	pop    %rbx
 800001028cf:	41 5c                	pop    %r12
 800001028d1:	5d                   	pop    %rbp
 800001028d2:	c3                   	ret
    panic("idestart");
 800001028d3:	48 bf 04 ab 10 00 00 	movabs $0x8000010ab04,%rdi
 800001028da:	08 00 00 
 800001028dd:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001028e4:	08 00 00 
 800001028e7:	ff d0                	call   *%rax
    panic("incorrect blockno");
 800001028e9:	48 bf 0d ab 10 00 00 	movabs $0x8000010ab0d,%rdi
 800001028f0:	08 00 00 
 800001028f3:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001028fa:	08 00 00 
 800001028fd:	ff d0                	call   *%rax
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 800001028ff:	b0 20                	mov    $0x20,%al
 80000102901:	ba f7 01 00 00       	mov    $0x1f7,%edx
 80000102906:	ee                   	out    %al,(%dx)
}
 80000102907:	eb c5                	jmp    800001028ce <idestart+0xa4>

0000080000102909 <ideinit>:
{
 80000102909:	55                   	push   %rbp
 8000010290a:	48 89 e5             	mov    %rsp,%rbp
  initlock(&idelock, "ide");
 8000010290d:	48 be 1f ab 10 00 00 	movabs $0x8000010ab1f,%rsi
 80000102914:	08 00 00 
 80000102917:	48 bf e0 9d 11 00 00 	movabs $0x80000119de0,%rdi
 8000010291e:	08 00 00 
 80000102921:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 80000102928:	08 00 00 
 8000010292b:	ff d0                	call   *%rax
  ioapicenable(IRQ_IDE, ncpu - 1);
 8000010292d:	a1 04 a0 11 00 00 08 	movabs 0x8000011a004,%eax
 80000102934:	00 00 
 80000102936:	8d 70 ff             	lea    -0x1(%rax),%esi
 80000102939:	bf 0e 00 00 00       	mov    $0xe,%edi
 8000010293e:	48 b8 91 2c 10 00 00 	movabs $0x80000102c91,%rax
 80000102945:	08 00 00 
 80000102948:	ff d0                	call   *%rax
  idewait(0);
 8000010294a:	bf 00 00 00 00       	mov    $0x0,%edi
 8000010294f:	48 b8 00 28 10 00 00 	movabs $0x80000102800,%rax
 80000102956:	08 00 00 
 80000102959:	ff d0                	call   *%rax
 8000010295b:	b0 f0                	mov    $0xf0,%al
 8000010295d:	ba f6 01 00 00       	mov    $0x1f6,%edx
 80000102962:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
 80000102963:	b9 00 00 00 00       	mov    $0x0,%ecx
 80000102968:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
 8000010296e:	7f 22                	jg     80000102992 <ideinit+0x89>
    asm volatile("in %1,%0" : "=a" (data) : "d" (port));
 80000102970:	ba f7 01 00 00       	mov    $0x1f7,%edx
 80000102975:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
 80000102976:	0f b6 c0             	movzbl %al,%eax
 80000102979:	85 c0                	test   %eax,%eax
 8000010297b:	75 05                	jne    80000102982 <ideinit+0x79>
  for(i=0; i<1000; i++){
 8000010297d:	83 c1 01             	add    $0x1,%ecx
 80000102980:	eb e6                	jmp    80000102968 <ideinit+0x5f>
      havedisk1 = 1;
 80000102982:	48 b8 c0 9d 11 00 00 	movabs $0x80000119dc0,%rax
 80000102989:	08 00 00 
 8000010298c:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 80000102992:	b0 e0                	mov    $0xe0,%al
 80000102994:	ba f6 01 00 00       	mov    $0x1f6,%edx
 80000102999:	ee                   	out    %al,(%dx)
}
 8000010299a:	5d                   	pop    %rbp
 8000010299b:	c3                   	ret

000008000010299c <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
 8000010299c:	55                   	push   %rbp
 8000010299d:	48 89 e5             	mov    %rsp,%rbp
 800001029a0:	53                   	push   %rbx
 800001029a1:	48 83 ec 08          	sub    $0x8,%rsp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
 800001029a5:	48 bf e0 9d 11 00 00 	movabs $0x80000119de0,%rdi
 800001029ac:	08 00 00 
 800001029af:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 800001029b6:	08 00 00 
 800001029b9:	ff d0                	call   *%rax

  if((b = idequeue) == 0){
 800001029bb:	48 b8 c8 9d 11 00 00 	movabs $0x80000119dc8,%rax
 800001029c2:	08 00 00 
 800001029c5:	48 8b 18             	mov    (%rax),%rbx
 800001029c8:	48 85 db             	test   %rbx,%rbx
 800001029cb:	74 71                	je     80000102a3e <ideintr+0xa2>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
 800001029cd:	48 8b 83 a8 00 00 00 	mov    0xa8(%rbx),%rax
 800001029d4:	48 a3 c8 9d 11 00 00 	movabs %rax,0x80000119dc8
 800001029db:	08 00 00 

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
 800001029de:	f6 03 04             	testb  $0x4,(%rbx)
 800001029e1:	74 73                	je     80000102a56 <ideintr+0xba>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
 800001029e3:	8b 03                	mov    (%rbx),%eax
 800001029e5:	89 c2                	mov    %eax,%edx
 800001029e7:	83 ca 02             	or     $0x2,%edx
 800001029ea:	89 13                	mov    %edx,(%rbx)
  b->flags &= ~B_DIRTY;
 800001029ec:	83 e0 fb             	and    $0xfffffffb,%eax
 800001029ef:	83 c8 02             	or     $0x2,%eax
 800001029f2:	89 03                	mov    %eax,(%rbx)
  wakeup(b);
 800001029f4:	48 89 df             	mov    %rbx,%rdi
 800001029f7:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 800001029fe:	08 00 00 
 80000102a01:	ff d0                	call   *%rax

  // Start disk on next buf in queue.
  if(idequeue != 0)
 80000102a03:	48 a1 c8 9d 11 00 00 	movabs 0x80000119dc8,%rax
 80000102a0a:	08 00 00 
 80000102a0d:	48 85 c0             	test   %rax,%rax
 80000102a10:	74 0f                	je     80000102a21 <ideintr+0x85>
    idestart(idequeue);
 80000102a12:	48 89 c7             	mov    %rax,%rdi
 80000102a15:	48 b8 2a 28 10 00 00 	movabs $0x8000010282a,%rax
 80000102a1c:	08 00 00 
 80000102a1f:	ff d0                	call   *%rax

  release(&idelock);
 80000102a21:	48 bf e0 9d 11 00 00 	movabs $0x80000119de0,%rdi
 80000102a28:	08 00 00 
 80000102a2b:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000102a32:	08 00 00 
 80000102a35:	ff d0                	call   *%rax
}
 80000102a37:	48 83 c4 08          	add    $0x8,%rsp
 80000102a3b:	5b                   	pop    %rbx
 80000102a3c:	5d                   	pop    %rbp
 80000102a3d:	c3                   	ret
    release(&idelock);
 80000102a3e:	48 bf e0 9d 11 00 00 	movabs $0x80000119de0,%rdi
 80000102a45:	08 00 00 
 80000102a48:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000102a4f:	08 00 00 
 80000102a52:	ff d0                	call   *%rax
    return;
 80000102a54:	eb e1                	jmp    80000102a37 <ideintr+0x9b>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
 80000102a56:	bf 01 00 00 00       	mov    $0x1,%edi
 80000102a5b:	48 b8 00 28 10 00 00 	movabs $0x80000102800,%rax
 80000102a62:	08 00 00 
 80000102a65:	ff d0                	call   *%rax
 80000102a67:	85 c0                	test   %eax,%eax
 80000102a69:	0f 88 74 ff ff ff    	js     800001029e3 <ideintr+0x47>
    insl(0x1f0, b->data, BSIZE/4);
 80000102a6f:	48 8d bb b0 00 00 00 	lea    0xb0(%rbx),%rdi
    asm volatile("cld; rep insl" :
 80000102a76:	b9 80 00 00 00       	mov    $0x80,%ecx
 80000102a7b:	ba f0 01 00 00       	mov    $0x1f0,%edx
 80000102a80:	fc                   	cld
 80000102a81:	f3 6d                	rep insl (%dx),%es:(%rdi)
}
 80000102a83:	e9 5b ff ff ff       	jmp    800001029e3 <ideintr+0x47>

0000080000102a88 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
 80000102a88:	55                   	push   %rbp
 80000102a89:	48 89 e5             	mov    %rsp,%rbp
 80000102a8c:	53                   	push   %rbx
 80000102a8d:	48 83 ec 08          	sub    $0x8,%rsp
 80000102a91:	48 89 fb             	mov    %rdi,%rbx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
 80000102a94:	48 8d 7f 10          	lea    0x10(%rdi),%rdi
 80000102a98:	48 b8 fe 52 10 00 00 	movabs $0x800001052fe,%rax
 80000102a9f:	08 00 00 
 80000102aa2:	ff d0                	call   *%rax
 80000102aa4:	85 c0                	test   %eax,%eax
 80000102aa6:	74 4d                	je     80000102af5 <iderw+0x6d>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
 80000102aa8:	8b 03                	mov    (%rbx),%eax
 80000102aaa:	83 e0 06             	and    $0x6,%eax
 80000102aad:	83 f8 02             	cmp    $0x2,%eax
 80000102ab0:	74 59                	je     80000102b0b <iderw+0x83>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
 80000102ab2:	83 7b 04 00          	cmpl   $0x0,0x4(%rbx)
 80000102ab6:	74 0d                	je     80000102ac5 <iderw+0x3d>
 80000102ab8:	a1 c0 9d 11 00 00 08 	movabs 0x80000119dc0,%eax
 80000102abf:	00 00 
 80000102ac1:	85 c0                	test   %eax,%eax
 80000102ac3:	74 5c                	je     80000102b21 <iderw+0x99>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
 80000102ac5:	48 bf e0 9d 11 00 00 	movabs $0x80000119de0,%rdi
 80000102acc:	08 00 00 
 80000102acf:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000102ad6:	08 00 00 
 80000102ad9:	ff d0                	call   *%rax

  // Append b to idequeue.
  b->qnext = 0;
 80000102adb:	48 c7 83 a8 00 00 00 	movq   $0x0,0xa8(%rbx)
 80000102ae2:	00 00 00 00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
 80000102ae6:	48 ba c8 9d 11 00 00 	movabs $0x80000119dc8,%rdx
 80000102aed:	08 00 00 
 80000102af0:	48 8b 02             	mov    (%rdx),%rax
 80000102af3:	eb 5c                	jmp    80000102b51 <iderw+0xc9>
    panic("iderw: buf not locked");
 80000102af5:	48 bf 23 ab 10 00 00 	movabs $0x8000010ab23,%rdi
 80000102afc:	08 00 00 
 80000102aff:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000102b06:	08 00 00 
 80000102b09:	ff d0                	call   *%rax
    panic("iderw: nothing to do");
 80000102b0b:	48 bf 39 ab 10 00 00 	movabs $0x8000010ab39,%rdi
 80000102b12:	08 00 00 
 80000102b15:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000102b1c:	08 00 00 
 80000102b1f:	ff d0                	call   *%rax
    panic("iderw: ide disk 1 not present");
 80000102b21:	48 bf 4e ab 10 00 00 	movabs $0x8000010ab4e,%rdi
 80000102b28:	08 00 00 
 80000102b2b:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000102b32:	08 00 00 
 80000102b35:	ff d0                	call   *%rax
 80000102b37:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 80000102b3e:	00 00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
 80000102b40:	48 8b 02             	mov    (%rdx),%rax
 80000102b43:	48 8d 90 a8 00 00 00 	lea    0xa8(%rax),%rdx
 80000102b4a:	48 8b 80 a8 00 00 00 	mov    0xa8(%rax),%rax
 80000102b51:	48 85 c0             	test   %rax,%rax
 80000102b54:	75 ea                	jne    80000102b40 <iderw+0xb8>
    ;
  *pp = b;
 80000102b56:	48 89 1a             	mov    %rbx,(%rdx)

  // Start disk if necessary.
  if(idequeue == b)
 80000102b59:	48 a1 c8 9d 11 00 00 	movabs 0x80000119dc8,%rax
 80000102b60:	08 00 00 
 80000102b63:	48 39 d8             	cmp    %rbx,%rax
 80000102b66:	75 2a                	jne    80000102b92 <iderw+0x10a>
    idestart(b);
 80000102b68:	48 89 df             	mov    %rbx,%rdi
 80000102b6b:	48 b8 2a 28 10 00 00 	movabs $0x8000010282a,%rax
 80000102b72:	08 00 00 
 80000102b75:	ff d0                	call   *%rax
 80000102b77:	eb 19                	jmp    80000102b92 <iderw+0x10a>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
 80000102b79:	48 be e0 9d 11 00 00 	movabs $0x80000119de0,%rsi
 80000102b80:	08 00 00 
 80000102b83:	48 89 df             	mov    %rbx,%rdi
 80000102b86:	48 b8 03 4e 10 00 00 	movabs $0x80000104e03,%rax
 80000102b8d:	08 00 00 
 80000102b90:	ff d0                	call   *%rax
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
 80000102b92:	8b 03                	mov    (%rbx),%eax
 80000102b94:	83 e0 06             	and    $0x6,%eax
 80000102b97:	83 f8 02             	cmp    $0x2,%eax
 80000102b9a:	75 dd                	jne    80000102b79 <iderw+0xf1>
  }


  release(&idelock);
 80000102b9c:	48 bf e0 9d 11 00 00 	movabs $0x80000119de0,%rdi
 80000102ba3:	08 00 00 
 80000102ba6:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000102bad:	08 00 00 
 80000102bb0:	ff d0                	call   *%rax
}
 80000102bb2:	48 83 c4 08          	add    $0x8,%rsp
 80000102bb6:	5b                   	pop    %rbx
 80000102bb7:	5d                   	pop    %rbp
 80000102bb8:	c3                   	ret

0000080000102bb9 <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
 80000102bb9:	48 b8 48 9e 11 00 00 	movabs $0x80000119e48,%rax
 80000102bc0:	08 00 00 
 80000102bc3:	48 8b 10             	mov    (%rax),%rdx
 80000102bc6:	89 3a                	mov    %edi,(%rdx)
  return ioapic->data;
 80000102bc8:	48 8b 00             	mov    (%rax),%rax
 80000102bcb:	8b 40 10             	mov    0x10(%rax),%eax
}
 80000102bce:	c3                   	ret

0000080000102bcf <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
 80000102bcf:	48 b8 48 9e 11 00 00 	movabs $0x80000119e48,%rax
 80000102bd6:	08 00 00 
 80000102bd9:	48 8b 10             	mov    (%rax),%rdx
 80000102bdc:	89 3a                	mov    %edi,(%rdx)
  ioapic->data = data;
 80000102bde:	48 8b 00             	mov    (%rax),%rax
 80000102be1:	89 70 10             	mov    %esi,0x10(%rax)
}
 80000102be4:	c3                   	ret

0000080000102be5 <ioapicinit>:

void
ioapicinit(void)
{
 80000102be5:	55                   	push   %rbp
 80000102be6:	48 89 e5             	mov    %rsp,%rbp
 80000102be9:	41 56                	push   %r14
 80000102beb:	41 55                	push   %r13
 80000102bed:	41 54                	push   %r12
 80000102bef:	53                   	push   %rbx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)DEV_P2V(IOAPIC);
 80000102bf0:	48 b8 48 9e 11 00 00 	movabs $0x80000119e48,%rax
 80000102bf7:	08 00 00 
 80000102bfa:	48 c7 00 00 00 c0 fe 	movq   $0xfffffffffec00000,(%rax)
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
 80000102c01:	bf 01 00 00 00       	mov    $0x1,%edi
 80000102c06:	48 bb b9 2b 10 00 00 	movabs $0x80000102bb9,%rbx
 80000102c0d:	08 00 00 
 80000102c10:	ff d3                	call   *%rbx
 80000102c12:	c1 e8 10             	shr    $0x10,%eax
 80000102c15:	44 0f b6 e8          	movzbl %al,%r13d
  id = ioapicread(REG_ID) >> 24;
 80000102c19:	bf 00 00 00 00       	mov    $0x0,%edi
 80000102c1e:	ff d3                	call   *%rbx
 80000102c20:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
 80000102c23:	48 ba 00 a0 11 00 00 	movabs $0x8000011a000,%rdx
 80000102c2a:	08 00 00 
 80000102c2d:	0f b6 12             	movzbl (%rdx),%edx
 80000102c30:	39 c2                	cmp    %eax,%edx
 80000102c32:	75 07                	jne    80000102c3b <ioapicinit+0x56>
{
 80000102c34:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000102c39:	eb 48                	jmp    80000102c83 <ioapicinit+0x9e>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
 80000102c3b:	48 bf 80 af 10 00 00 	movabs $0x8000010af80,%rdi
 80000102c42:	08 00 00 
 80000102c45:	b0 00                	mov    $0x0,%al
 80000102c47:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000102c4e:	08 00 00 
 80000102c51:	ff d2                	call   *%rdx
 80000102c53:	eb df                	jmp    80000102c34 <ioapicinit+0x4f>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
 80000102c55:	8d 73 20             	lea    0x20(%rbx),%esi
 80000102c58:	81 ce 00 00 01 00    	or     $0x10000,%esi
 80000102c5e:	44 8d 64 1b 10       	lea    0x10(%rbx,%rbx,1),%r12d
 80000102c63:	44 89 e7             	mov    %r12d,%edi
 80000102c66:	49 be cf 2b 10 00 00 	movabs $0x80000102bcf,%r14
 80000102c6d:	08 00 00 
 80000102c70:	41 ff d6             	call   *%r14
    ioapicwrite(REG_TABLE+2*i+1, 0);
 80000102c73:	41 8d 7c 24 01       	lea    0x1(%r12),%edi
 80000102c78:	be 00 00 00 00       	mov    $0x0,%esi
 80000102c7d:	41 ff d6             	call   *%r14
  for(i = 0; i <= maxintr; i++){
 80000102c80:	83 c3 01             	add    $0x1,%ebx
 80000102c83:	44 39 eb             	cmp    %r13d,%ebx
 80000102c86:	7e cd                	jle    80000102c55 <ioapicinit+0x70>
  }
}
 80000102c88:	5b                   	pop    %rbx
 80000102c89:	41 5c                	pop    %r12
 80000102c8b:	41 5d                	pop    %r13
 80000102c8d:	41 5e                	pop    %r14
 80000102c8f:	5d                   	pop    %rbp
 80000102c90:	c3                   	ret

0000080000102c91 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
 80000102c91:	55                   	push   %rbp
 80000102c92:	48 89 e5             	mov    %rsp,%rbp
 80000102c95:	41 55                	push   %r13
 80000102c97:	41 54                	push   %r12
 80000102c99:	53                   	push   %rbx
 80000102c9a:	48 83 ec 08          	sub    $0x8,%rsp
 80000102c9e:	89 f3                	mov    %esi,%ebx
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
 80000102ca0:	8d 77 20             	lea    0x20(%rdi),%esi
 80000102ca3:	44 8d 64 3f 10       	lea    0x10(%rdi,%rdi,1),%r12d
 80000102ca8:	44 89 e7             	mov    %r12d,%edi
 80000102cab:	49 bd cf 2b 10 00 00 	movabs $0x80000102bcf,%r13
 80000102cb2:	08 00 00 
 80000102cb5:	41 ff d5             	call   *%r13
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
 80000102cb8:	c1 e3 18             	shl    $0x18,%ebx
 80000102cbb:	89 de                	mov    %ebx,%esi
 80000102cbd:	41 8d 7c 24 01       	lea    0x1(%r12),%edi
 80000102cc2:	41 ff d5             	call   *%r13
}
 80000102cc5:	48 83 c4 08          	add    $0x8,%rsp
 80000102cc9:	5b                   	pop    %rbx
 80000102cca:	41 5c                	pop    %r12
 80000102ccc:	41 5d                	pop    %r13
 80000102cce:	5d                   	pop    %rbp
 80000102ccf:	c3                   	ret

0000080000102cd0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
 80000102cd0:	55                   	push   %rbp
 80000102cd1:	48 89 e5             	mov    %rsp,%rbp
 80000102cd4:	53                   	push   %rbx
 80000102cd5:	48 83 ec 08          	sub    $0x8,%rsp
  struct run *r;

  if((uint64)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
 80000102cd9:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
 80000102cdf:	75 6c                	jne    80000102d4d <kfree+0x7d>
 80000102ce1:	48 89 fb             	mov    %rdi,%rbx
 80000102ce4:	48 b8 a0 ff 11 00 00 	movabs $0x8000011ffa0,%rax
 80000102ceb:	08 00 00 
 80000102cee:	48 39 c7             	cmp    %rax,%rdi
 80000102cf1:	72 5a                	jb     80000102d4d <kfree+0x7d>
 80000102cf3:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 80000102cfa:	f8 ff ff 
 80000102cfd:	48 01 f8             	add    %rdi,%rax
 80000102d00:	48 3d ff ff ff 0d    	cmp    $0xdffffff,%rax
 80000102d06:	77 45                	ja     80000102d4d <kfree+0x7d>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
 80000102d08:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000102d0d:	be 01 00 00 00       	mov    $0x1,%esi
 80000102d12:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000102d19:	08 00 00 
 80000102d1c:	ff d0                	call   *%rax

  if(kmem.use_lock)
 80000102d1e:	a1 c8 9e 11 00 00 08 	movabs 0x80000119ec8,%eax
 80000102d25:	00 00 
 80000102d27:	85 c0                	test   %eax,%eax
 80000102d29:	75 38                	jne    80000102d63 <kfree+0x93>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
 80000102d2b:	48 b8 60 9e 11 00 00 	movabs $0x80000119e60,%rax
 80000102d32:	08 00 00 
 80000102d35:	48 8b 50 70          	mov    0x70(%rax),%rdx
 80000102d39:	48 89 13             	mov    %rdx,(%rbx)
  kmem.freelist = r;
 80000102d3c:	48 89 58 70          	mov    %rbx,0x70(%rax)
  if(kmem.use_lock)
 80000102d40:	83 78 68 00          	cmpl   $0x0,0x68(%rax)
 80000102d44:	75 35                	jne    80000102d7b <kfree+0xab>
    release(&kmem.lock);
}
 80000102d46:	48 83 c4 08          	add    $0x8,%rsp
 80000102d4a:	5b                   	pop    %rbx
 80000102d4b:	5d                   	pop    %rbp
 80000102d4c:	c3                   	ret
    panic("kfree");
 80000102d4d:	48 bf 6c ab 10 00 00 	movabs $0x8000010ab6c,%rdi
 80000102d54:	08 00 00 
 80000102d57:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000102d5e:	08 00 00 
 80000102d61:	ff d0                	call   *%rax
    acquire(&kmem.lock);
 80000102d63:	48 bf 60 9e 11 00 00 	movabs $0x80000119e60,%rdi
 80000102d6a:	08 00 00 
 80000102d6d:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000102d74:	08 00 00 
 80000102d77:	ff d0                	call   *%rax
 80000102d79:	eb b0                	jmp    80000102d2b <kfree+0x5b>
    release(&kmem.lock);
 80000102d7b:	48 89 c7             	mov    %rax,%rdi
 80000102d7e:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000102d85:	08 00 00 
 80000102d88:	ff d0                	call   *%rax
}
 80000102d8a:	eb ba                	jmp    80000102d46 <kfree+0x76>

0000080000102d8c <freerange>:
{
 80000102d8c:	55                   	push   %rbp
 80000102d8d:	48 89 e5             	mov    %rsp,%rbp
 80000102d90:	41 54                	push   %r12
 80000102d92:	53                   	push   %rbx
 80000102d93:	49 89 f4             	mov    %rsi,%r12
  p = (char*)PGROUNDUP((uint64)vstart);
 80000102d96:	48 81 c7 ff 0f 00 00 	add    $0xfff,%rdi
 80000102d9d:	48 81 e7 00 f0 ff ff 	and    $0xfffffffffffff000,%rdi
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
 80000102da4:	eb 0f                	jmp    80000102db5 <freerange+0x29>
    kfree(p);
 80000102da6:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 80000102dad:	08 00 00 
 80000102db0:	ff d0                	call   *%rax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
 80000102db2:	48 89 df             	mov    %rbx,%rdi
 80000102db5:	48 8d 9f 00 10 00 00 	lea    0x1000(%rdi),%rbx
 80000102dbc:	49 39 dc             	cmp    %rbx,%r12
 80000102dbf:	73 e5                	jae    80000102da6 <freerange+0x1a>
}
 80000102dc1:	5b                   	pop    %rbx
 80000102dc2:	41 5c                	pop    %r12
 80000102dc4:	5d                   	pop    %rbp
 80000102dc5:	c3                   	ret

0000080000102dc6 <kinit1>:
{
 80000102dc6:	55                   	push   %rbp
 80000102dc7:	48 89 e5             	mov    %rsp,%rbp
 80000102dca:	41 55                	push   %r13
 80000102dcc:	41 54                	push   %r12
 80000102dce:	53                   	push   %rbx
 80000102dcf:	48 83 ec 08          	sub    $0x8,%rsp
 80000102dd3:	48 89 fb             	mov    %rdi,%rbx
 80000102dd6:	49 89 f4             	mov    %rsi,%r12
  initlock(&kmem.lock, "kmem");
 80000102dd9:	48 be 72 ab 10 00 00 	movabs $0x8000010ab72,%rsi
 80000102de0:	08 00 00 
 80000102de3:	49 bd 60 9e 11 00 00 	movabs $0x80000119e60,%r13
 80000102dea:	08 00 00 
 80000102ded:	4c 89 ef             	mov    %r13,%rdi
 80000102df0:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 80000102df7:	08 00 00 
 80000102dfa:	ff d0                	call   *%rax
  kmem.use_lock = 0;
 80000102dfc:	41 c7 45 68 00 00 00 	movl   $0x0,0x68(%r13)
 80000102e03:	00 
  freerange(vstart, vend);
 80000102e04:	4c 89 e6             	mov    %r12,%rsi
 80000102e07:	48 89 df             	mov    %rbx,%rdi
 80000102e0a:	48 b8 8c 2d 10 00 00 	movabs $0x80000102d8c,%rax
 80000102e11:	08 00 00 
 80000102e14:	ff d0                	call   *%rax
}
 80000102e16:	48 83 c4 08          	add    $0x8,%rsp
 80000102e1a:	5b                   	pop    %rbx
 80000102e1b:	41 5c                	pop    %r12
 80000102e1d:	41 5d                	pop    %r13
 80000102e1f:	5d                   	pop    %rbp
 80000102e20:	c3                   	ret

0000080000102e21 <kinit2>:
{
 80000102e21:	55                   	push   %rbp
 80000102e22:	48 89 e5             	mov    %rsp,%rbp
  freerange(vstart, vend);
 80000102e25:	48 b8 8c 2d 10 00 00 	movabs $0x80000102d8c,%rax
 80000102e2c:	08 00 00 
 80000102e2f:	ff d0                	call   *%rax
  kmem.use_lock = 1;
 80000102e31:	48 b8 c8 9e 11 00 00 	movabs $0x80000119ec8,%rax
 80000102e38:	08 00 00 
 80000102e3b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
}
 80000102e41:	5d                   	pop    %rbp
 80000102e42:	c3                   	ret

0000080000102e43 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
 80000102e43:	55                   	push   %rbp
 80000102e44:	48 89 e5             	mov    %rsp,%rbp
 80000102e47:	53                   	push   %rbx
 80000102e48:	48 83 ec 08          	sub    $0x8,%rsp
  struct run *r;

  if(kmem.use_lock)
 80000102e4c:	a1 c8 9e 11 00 00 08 	movabs 0x80000119ec8,%eax
 80000102e53:	00 00 
 80000102e55:	85 c0                	test   %eax,%eax
 80000102e57:	75 36                	jne    80000102e8f <kalloc+0x4c>
    acquire(&kmem.lock);
  r = kmem.freelist;
 80000102e59:	48 b8 d0 9e 11 00 00 	movabs $0x80000119ed0,%rax
 80000102e60:	08 00 00 
 80000102e63:	48 8b 18             	mov    (%rax),%rbx
  if(r)
 80000102e66:	48 85 db             	test   %rbx,%rbx
 80000102e69:	74 0d                	je     80000102e78 <kalloc+0x35>
    kmem.freelist = r->next;
 80000102e6b:	48 8b 03             	mov    (%rbx),%rax
 80000102e6e:	48 a3 d0 9e 11 00 00 	movabs %rax,0x80000119ed0
 80000102e75:	08 00 00 
  if(kmem.use_lock)
 80000102e78:	a1 c8 9e 11 00 00 08 	movabs 0x80000119ec8,%eax
 80000102e7f:	00 00 
 80000102e81:	85 c0                	test   %eax,%eax
 80000102e83:	75 22                	jne    80000102ea7 <kalloc+0x64>
    release(&kmem.lock);
  return (char*)r;
}
 80000102e85:	48 89 d8             	mov    %rbx,%rax
 80000102e88:	48 83 c4 08          	add    $0x8,%rsp
 80000102e8c:	5b                   	pop    %rbx
 80000102e8d:	5d                   	pop    %rbp
 80000102e8e:	c3                   	ret
    acquire(&kmem.lock);
 80000102e8f:	48 bf 60 9e 11 00 00 	movabs $0x80000119e60,%rdi
 80000102e96:	08 00 00 
 80000102e99:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000102ea0:	08 00 00 
 80000102ea3:	ff d0                	call   *%rax
 80000102ea5:	eb b2                	jmp    80000102e59 <kalloc+0x16>
    release(&kmem.lock);
 80000102ea7:	48 bf 60 9e 11 00 00 	movabs $0x80000119e60,%rdi
 80000102eae:	08 00 00 
 80000102eb1:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000102eb8:	08 00 00 
 80000102ebb:	ff d0                	call   *%rax
  return (char*)r;
 80000102ebd:	eb c6                	jmp    80000102e85 <kalloc+0x42>

0000080000102ebf <kbdgetc>:
    asm volatile("in %1,%0" : "=a" (data) : "d" (port));
 80000102ebf:	ba 64 00 00 00       	mov    $0x64,%edx
 80000102ec4:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
 80000102ec5:	a8 01                	test   $0x1,%al
 80000102ec7:	0f 84 ef 00 00 00    	je     80000102fbc <kbdgetc+0xfd>
 80000102ecd:	ba 60 00 00 00       	mov    $0x60,%edx
 80000102ed2:	ec                   	in     (%dx),%al
 80000102ed3:	88 c1                	mov    %al,%cl
    return -1;
  data = inb(KBDATAP);
 80000102ed5:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
 80000102ed8:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
 80000102ede:	74 7f                	je     80000102f5f <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
 80000102ee0:	a8 80                	test   $0x80,%al
 80000102ee2:	0f 85 8e 00 00 00    	jne    80000102f76 <kbdgetc+0xb7>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
 80000102ee8:	a1 d8 9e 11 00 00 08 	movabs 0x80000119ed8,%eax
 80000102eef:	00 00 
 80000102ef1:	a8 40                	test   $0x40,%al
 80000102ef3:	74 12                	je     80000102f07 <kbdgetc+0x48>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
 80000102ef5:	83 c9 80             	or     $0xffffff80,%ecx
 80000102ef8:	0f b6 d1             	movzbl %cl,%edx
    shift &= ~E0ESC;
 80000102efb:	83 e0 bf             	and    $0xffffffbf,%eax
 80000102efe:	a3 d8 9e 11 00 00 08 	movabs %eax,0x80000119ed8
 80000102f05:	00 00 
  }

  shift |= shiftcode[data];
 80000102f07:	89 d2                	mov    %edx,%edx
 80000102f09:	48 b8 20 b3 10 00 00 	movabs $0x8000010b320,%rax
 80000102f10:	08 00 00 
 80000102f13:	0f b6 0c 10          	movzbl (%rax,%rdx,1),%ecx
 80000102f17:	48 b8 d8 9e 11 00 00 	movabs $0x80000119ed8,%rax
 80000102f1e:	08 00 00 
 80000102f21:	0b 08                	or     (%rax),%ecx
 80000102f23:	89 08                	mov    %ecx,(%rax)
  shift ^= togglecode[data];
 80000102f25:	48 be 20 b2 10 00 00 	movabs $0x8000010b220,%rsi
 80000102f2c:	08 00 00 
 80000102f2f:	0f b6 34 16          	movzbl (%rsi,%rdx,1),%esi
 80000102f33:	31 f1                	xor    %esi,%ecx
 80000102f35:	89 08                	mov    %ecx,(%rax)
  c = charcode[shift & (CTL | SHIFT)][data];
 80000102f37:	89 ce                	mov    %ecx,%esi
 80000102f39:	83 e6 03             	and    $0x3,%esi
 80000102f3c:	48 b8 00 b2 10 00 00 	movabs $0x8000010b200,%rax
 80000102f43:	08 00 00 
 80000102f46:	48 8b 04 f0          	mov    (%rax,%rsi,8),%rax
 80000102f4a:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  if(shift & CAPSLOCK){
 80000102f4e:	f6 c1 08             	test   $0x8,%cl
 80000102f51:	74 6e                	je     80000102fc1 <kbdgetc+0x102>
    if('a' <= c && c <= 'z')
 80000102f53:	8d 50 9f             	lea    -0x61(%rax),%edx
 80000102f56:	83 fa 19             	cmp    $0x19,%edx
 80000102f59:	77 55                	ja     80000102fb0 <kbdgetc+0xf1>
      c += 'A' - 'a';
 80000102f5b:	83 e8 20             	sub    $0x20,%eax
 80000102f5e:	c3                   	ret
    shift |= E0ESC;
 80000102f5f:	48 ba d8 9e 11 00 00 	movabs $0x80000119ed8,%rdx
 80000102f66:	08 00 00 
 80000102f69:	8b 02                	mov    (%rdx),%eax
 80000102f6b:	83 c8 40             	or     $0x40,%eax
 80000102f6e:	89 02                	mov    %eax,(%rdx)
    return 0;
 80000102f70:	b8 00 00 00 00       	mov    $0x0,%eax
 80000102f75:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
 80000102f76:	a1 d8 9e 11 00 00 08 	movabs 0x80000119ed8,%eax
 80000102f7d:	00 00 
 80000102f7f:	a8 40                	test   $0x40,%al
 80000102f81:	75 05                	jne    80000102f88 <kbdgetc+0xc9>
 80000102f83:	89 ca                	mov    %ecx,%edx
 80000102f85:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
 80000102f88:	89 d2                	mov    %edx,%edx
 80000102f8a:	48 b9 20 b3 10 00 00 	movabs $0x8000010b320,%rcx
 80000102f91:	08 00 00 
 80000102f94:	8a 14 11             	mov    (%rcx,%rdx,1),%dl
 80000102f97:	83 ca 40             	or     $0x40,%edx
 80000102f9a:	0f b6 d2             	movzbl %dl,%edx
 80000102f9d:	f7 d2                	not    %edx
 80000102f9f:	21 d0                	and    %edx,%eax
 80000102fa1:	a3 d8 9e 11 00 00 08 	movabs %eax,0x80000119ed8
 80000102fa8:	00 00 
    return 0;
 80000102faa:	b8 00 00 00 00       	mov    $0x0,%eax
 80000102faf:	c3                   	ret
    else if('A' <= c && c <= 'Z')
 80000102fb0:	8d 50 bf             	lea    -0x41(%rax),%edx
 80000102fb3:	83 fa 19             	cmp    $0x19,%edx
 80000102fb6:	77 09                	ja     80000102fc1 <kbdgetc+0x102>
      c += 'a' - 'A';
 80000102fb8:	83 c0 20             	add    $0x20,%eax
  }
  return c;
 80000102fbb:	c3                   	ret
    return -1;
 80000102fbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 80000102fc1:	c3                   	ret

0000080000102fc2 <kbdintr>:

void
kbdintr(void)
{
 80000102fc2:	55                   	push   %rbp
 80000102fc3:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(kbdgetc);
 80000102fc6:	48 bf bf 2e 10 00 00 	movabs $0x80000102ebf,%rdi
 80000102fcd:	08 00 00 
 80000102fd0:	48 b8 50 0b 10 00 00 	movabs $0x80000100b50,%rax
 80000102fd7:	08 00 00 
 80000102fda:	ff d0                	call   *%rax
}
 80000102fdc:	5d                   	pop    %rbp
 80000102fdd:	c3                   	ret
 80000102fde:	66 90                	xchg   %ax,%ax

0000080000102fe0 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
 80000102fe0:	48 b8 e0 9e 11 00 00 	movabs $0x80000119ee0,%rax
 80000102fe7:	08 00 00 
 80000102fea:	48 63 ff             	movslq %edi,%rdi
 80000102fed:	48 8b 10             	mov    (%rax),%rdx
 80000102ff0:	48 8d 14 ba          	lea    (%rdx,%rdi,4),%rdx
 80000102ff4:	89 32                	mov    %esi,(%rdx)
  lapic[ID];  // wait for write to finish, by reading
 80000102ff6:	48 8b 00             	mov    (%rax),%rax
 80000102ff9:	8b 40 20             	mov    0x20(%rax),%eax
}
 80000102ffc:	c3                   	ret

0000080000102ffd <cmos_read>:
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 80000102ffd:	ba 70 00 00 00       	mov    $0x70,%edx
 80000103002:	40 88 f8             	mov    %dil,%al
 80000103005:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0" : "=a" (data) : "d" (port));
 80000103006:	ba 71 00 00 00       	mov    $0x71,%edx
 8000010300b:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
 8000010300c:	0f b6 c0             	movzbl %al,%eax
}
 8000010300f:	c3                   	ret

0000080000103010 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
 80000103010:	55                   	push   %rbp
 80000103011:	48 89 e5             	mov    %rsp,%rbp
 80000103014:	41 54                	push   %r12
 80000103016:	53                   	push   %rbx
 80000103017:	48 89 fb             	mov    %rdi,%rbx
  r->second = cmos_read(SECS);
 8000010301a:	bf 00 00 00 00       	mov    $0x0,%edi
 8000010301f:	49 bc fd 2f 10 00 00 	movabs $0x80000102ffd,%r12
 80000103026:	08 00 00 
 80000103029:	41 ff d4             	call   *%r12
 8000010302c:	89 03                	mov    %eax,(%rbx)
  r->minute = cmos_read(MINS);
 8000010302e:	bf 02 00 00 00       	mov    $0x2,%edi
 80000103033:	41 ff d4             	call   *%r12
 80000103036:	89 43 04             	mov    %eax,0x4(%rbx)
  r->hour   = cmos_read(HOURS);
 80000103039:	bf 04 00 00 00       	mov    $0x4,%edi
 8000010303e:	41 ff d4             	call   *%r12
 80000103041:	89 43 08             	mov    %eax,0x8(%rbx)
  r->day    = cmos_read(DAY);
 80000103044:	bf 07 00 00 00       	mov    $0x7,%edi
 80000103049:	41 ff d4             	call   *%r12
 8000010304c:	89 43 0c             	mov    %eax,0xc(%rbx)
  r->month  = cmos_read(MONTH);
 8000010304f:	bf 08 00 00 00       	mov    $0x8,%edi
 80000103054:	41 ff d4             	call   *%r12
 80000103057:	89 43 10             	mov    %eax,0x10(%rbx)
  r->year   = cmos_read(YEAR);
 8000010305a:	bf 09 00 00 00       	mov    $0x9,%edi
 8000010305f:	41 ff d4             	call   *%r12
 80000103062:	89 43 14             	mov    %eax,0x14(%rbx)
}
 80000103065:	5b                   	pop    %rbx
 80000103066:	41 5c                	pop    %r12
 80000103068:	5d                   	pop    %rbp
 80000103069:	c3                   	ret

000008000010306a <lapicinit>:
  if(!lapic)
 8000010306a:	48 a1 e0 9e 11 00 00 	movabs 0x80000119ee0,%rax
 80000103071:	08 00 00 
 80000103074:	48 85 c0             	test   %rax,%rax
 80000103077:	0f 84 26 01 00 00    	je     800001031a3 <lapicinit+0x139>
{
 8000010307d:	55                   	push   %rbp
 8000010307e:	48 89 e5             	mov    %rsp,%rbp
 80000103081:	53                   	push   %rbx
 80000103082:	48 83 ec 08          	sub    $0x8,%rsp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
 80000103086:	be 3f 01 00 00       	mov    $0x13f,%esi
 8000010308b:	bf 3c 00 00 00       	mov    $0x3c,%edi
 80000103090:	48 bb e0 2f 10 00 00 	movabs $0x80000102fe0,%rbx
 80000103097:	08 00 00 
 8000010309a:	ff d3                	call   *%rbx
  lapicw(TDCR, X1);
 8000010309c:	be 0b 00 00 00       	mov    $0xb,%esi
 800001030a1:	bf f8 00 00 00       	mov    $0xf8,%edi
 800001030a6:	ff d3                	call   *%rbx
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
 800001030a8:	be 20 00 02 00       	mov    $0x20020,%esi
 800001030ad:	bf c8 00 00 00       	mov    $0xc8,%edi
 800001030b2:	ff d3                	call   *%rbx
  lapicw(TICR, 10000000);
 800001030b4:	be 80 96 98 00       	mov    $0x989680,%esi
 800001030b9:	bf e0 00 00 00       	mov    $0xe0,%edi
 800001030be:	ff d3                	call   *%rbx
  lapicw(LINT0, MASKED);
 800001030c0:	be 00 00 01 00       	mov    $0x10000,%esi
 800001030c5:	bf d4 00 00 00       	mov    $0xd4,%edi
 800001030ca:	ff d3                	call   *%rbx
  lapicw(LINT1, MASKED);
 800001030cc:	be 00 00 01 00       	mov    $0x10000,%esi
 800001030d1:	bf d8 00 00 00       	mov    $0xd8,%edi
 800001030d6:	ff d3                	call   *%rbx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
 800001030d8:	48 a1 e0 9e 11 00 00 	movabs 0x80000119ee0,%rax
 800001030df:	08 00 00 
 800001030e2:	8b 40 30             	mov    0x30(%rax),%eax
 800001030e5:	a9 00 00 fc 00       	test   $0xfc0000,%eax
 800001030ea:	0f 85 a2 00 00 00    	jne    80000103192 <lapicinit+0x128>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
 800001030f0:	be 33 00 00 00       	mov    $0x33,%esi
 800001030f5:	bf dc 00 00 00       	mov    $0xdc,%edi
 800001030fa:	48 bb e0 2f 10 00 00 	movabs $0x80000102fe0,%rbx
 80000103101:	08 00 00 
 80000103104:	ff d3                	call   *%rbx
  lapicw(ESR, 0);
 80000103106:	be 00 00 00 00       	mov    $0x0,%esi
 8000010310b:	bf a0 00 00 00       	mov    $0xa0,%edi
 80000103110:	ff d3                	call   *%rbx
  lapicw(ESR, 0);
 80000103112:	be 00 00 00 00       	mov    $0x0,%esi
 80000103117:	bf a0 00 00 00       	mov    $0xa0,%edi
 8000010311c:	ff d3                	call   *%rbx
  lapicw(EOI, 0);
 8000010311e:	be 00 00 00 00       	mov    $0x0,%esi
 80000103123:	bf 2c 00 00 00       	mov    $0x2c,%edi
 80000103128:	ff d3                	call   *%rbx
  lapicw(ICRHI, 0);
 8000010312a:	be 00 00 00 00       	mov    $0x0,%esi
 8000010312f:	bf c4 00 00 00       	mov    $0xc4,%edi
 80000103134:	ff d3                	call   *%rbx
  lapicw(ICRLO, BCAST | INIT | LEVEL);
 80000103136:	be 00 85 08 00       	mov    $0x88500,%esi
 8000010313b:	bf c0 00 00 00       	mov    $0xc0,%edi
 80000103140:	ff d3                	call   *%rbx
  while(lapic[ICRLO] & DELIVS)
 80000103142:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000103149:	00 00 00 00 
 8000010314d:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000103154:	00 00 00 00 
 80000103158:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 8000010315f:	00 
 80000103160:	48 a1 e0 9e 11 00 00 	movabs 0x80000119ee0,%rax
 80000103167:	08 00 00 
 8000010316a:	8b 80 00 03 00 00    	mov    0x300(%rax),%eax
 80000103170:	f6 c4 10             	test   $0x10,%ah
 80000103173:	75 eb                	jne    80000103160 <lapicinit+0xf6>
  lapicw(TPR, 0);
 80000103175:	be 00 00 00 00       	mov    $0x0,%esi
 8000010317a:	bf 20 00 00 00       	mov    $0x20,%edi
 8000010317f:	48 b8 e0 2f 10 00 00 	movabs $0x80000102fe0,%rax
 80000103186:	08 00 00 
 80000103189:	ff d0                	call   *%rax
}
 8000010318b:	48 83 c4 08          	add    $0x8,%rsp
 8000010318f:	5b                   	pop    %rbx
 80000103190:	5d                   	pop    %rbp
 80000103191:	c3                   	ret
    lapicw(PCINT, MASKED);
 80000103192:	be 00 00 01 00       	mov    $0x10000,%esi
 80000103197:	bf d0 00 00 00       	mov    $0xd0,%edi
 8000010319c:	ff d3                	call   *%rbx
 8000010319e:	e9 4d ff ff ff       	jmp    800001030f0 <lapicinit+0x86>
 800001031a3:	c3                   	ret

00000800001031a4 <lapicid>:
  if (!lapic)
 800001031a4:	48 a1 e0 9e 11 00 00 	movabs 0x80000119ee0,%rax
 800001031ab:	08 00 00 
 800001031ae:	48 85 c0             	test   %rax,%rax
 800001031b1:	74 07                	je     800001031ba <lapicid+0x16>
  return lapic[ID] >> 24;
 800001031b3:	8b 40 20             	mov    0x20(%rax),%eax
 800001031b6:	c1 e8 18             	shr    $0x18,%eax
 800001031b9:	c3                   	ret
    return 0;
 800001031ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
 800001031bf:	c3                   	ret

00000800001031c0 <lapiceoi>:
  if(lapic)
 800001031c0:	48 a1 e0 9e 11 00 00 	movabs 0x80000119ee0,%rax
 800001031c7:	08 00 00 
 800001031ca:	48 85 c0             	test   %rax,%rax
 800001031cd:	74 1c                	je     800001031eb <lapiceoi+0x2b>
{
 800001031cf:	55                   	push   %rbp
 800001031d0:	48 89 e5             	mov    %rsp,%rbp
    lapicw(EOI, 0);
 800001031d3:	be 00 00 00 00       	mov    $0x0,%esi
 800001031d8:	bf 2c 00 00 00       	mov    $0x2c,%edi
 800001031dd:	48 b8 e0 2f 10 00 00 	movabs $0x80000102fe0,%rax
 800001031e4:	08 00 00 
 800001031e7:	ff d0                	call   *%rax
}
 800001031e9:	5d                   	pop    %rbp
 800001031ea:	c3                   	ret
 800001031eb:	c3                   	ret

00000800001031ec <microdelay>:
}
 800001031ec:	c3                   	ret

00000800001031ed <lapicstartap>:
{
 800001031ed:	55                   	push   %rbp
 800001031ee:	48 89 e5             	mov    %rsp,%rbp
 800001031f1:	41 56                	push   %r14
 800001031f3:	41 55                	push   %r13
 800001031f5:	41 54                	push   %r12
 800001031f7:	53                   	push   %rbx
 800001031f8:	41 89 fc             	mov    %edi,%r12d
 800001031fb:	41 89 f5             	mov    %esi,%r13d
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 800001031fe:	b0 0f                	mov    $0xf,%al
 80000103200:	ba 70 00 00 00       	mov    $0x70,%edx
 80000103205:	ee                   	out    %al,(%dx)
 80000103206:	b0 0a                	mov    $0xa,%al
 80000103208:	ba 71 00 00 00       	mov    $0x71,%edx
 8000010320d:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
 8000010320e:	48 b8 67 04 00 00 00 	movabs $0x80000000467,%rax
 80000103215:	08 00 00 
 80000103218:	66 c7 00 00 00       	movw   $0x0,(%rax)
  wrv[1] = addr >> 4;
 8000010321d:	89 f0                	mov    %esi,%eax
 8000010321f:	c1 e8 04             	shr    $0x4,%eax
 80000103222:	66 a3 69 04 00 00 00 	movabs %ax,0x80000000469
 80000103229:	08 00 00 
  lapicw(ICRHI, apicid<<24);
 8000010322c:	41 c1 e4 18          	shl    $0x18,%r12d
 80000103230:	44 89 e6             	mov    %r12d,%esi
 80000103233:	bf c4 00 00 00       	mov    $0xc4,%edi
 80000103238:	48 bb e0 2f 10 00 00 	movabs $0x80000102fe0,%rbx
 8000010323f:	08 00 00 
 80000103242:	ff d3                	call   *%rbx
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
 80000103244:	be 00 c5 00 00       	mov    $0xc500,%esi
 80000103249:	bf c0 00 00 00       	mov    $0xc0,%edi
 8000010324e:	ff d3                	call   *%rbx
  lapicw(ICRLO, INIT | LEVEL);
 80000103250:	be 00 85 00 00       	mov    $0x8500,%esi
 80000103255:	bf c0 00 00 00       	mov    $0xc0,%edi
 8000010325a:	ff d3                	call   *%rbx
  for(i = 0; i < 2; i++){
 8000010325c:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000103261:	eb 2c                	jmp    8000010328f <lapicstartap+0xa2>
    lapicw(ICRHI, apicid<<24);
 80000103263:	44 89 e6             	mov    %r12d,%esi
 80000103266:	bf c4 00 00 00       	mov    $0xc4,%edi
 8000010326b:	49 be e0 2f 10 00 00 	movabs $0x80000102fe0,%r14
 80000103272:	08 00 00 
 80000103275:	41 ff d6             	call   *%r14
    lapicw(ICRLO, STARTUP | (addr>>12));
 80000103278:	44 89 ee             	mov    %r13d,%esi
 8000010327b:	c1 ee 0c             	shr    $0xc,%esi
 8000010327e:	81 ce 00 06 00 00    	or     $0x600,%esi
 80000103284:	bf c0 00 00 00       	mov    $0xc0,%edi
 80000103289:	41 ff d6             	call   *%r14
  for(i = 0; i < 2; i++){
 8000010328c:	83 c3 01             	add    $0x1,%ebx
 8000010328f:	83 fb 01             	cmp    $0x1,%ebx
 80000103292:	7e cf                	jle    80000103263 <lapicstartap+0x76>
}
 80000103294:	5b                   	pop    %rbx
 80000103295:	41 5c                	pop    %r12
 80000103297:	41 5d                	pop    %r13
 80000103299:	41 5e                	pop    %r14
 8000010329b:	5d                   	pop    %rbp
 8000010329c:	c3                   	ret

000008000010329d <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
 8000010329d:	55                   	push   %rbp
 8000010329e:	48 89 e5             	mov    %rsp,%rbp
 800001032a1:	41 55                	push   %r13
 800001032a3:	41 54                	push   %r12
 800001032a5:	53                   	push   %rbx
 800001032a6:	48 83 ec 48          	sub    $0x48,%rsp
 800001032aa:	49 89 fc             	mov    %rdi,%r12
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
 800001032ad:	bf 0b 00 00 00       	mov    $0xb,%edi
 800001032b2:	48 b8 fd 2f 10 00 00 	movabs $0x80000102ffd,%rax
 800001032b9:	08 00 00 
 800001032bc:	ff d0                	call   *%rax

  bcd = (sb & (1 << 2)) == 0;
 800001032be:	83 e0 04             	and    $0x4,%eax
 800001032c1:	41 89 c5             	mov    %eax,%r13d

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
 800001032c4:	48 8d 7d c0          	lea    -0x40(%rbp),%rdi
 800001032c8:	48 b8 10 30 10 00 00 	movabs $0x80000103010,%rax
 800001032cf:	08 00 00 
 800001032d2:	ff d0                	call   *%rax
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
 800001032d4:	bf 0a 00 00 00       	mov    $0xa,%edi
 800001032d9:	48 b8 fd 2f 10 00 00 	movabs $0x80000102ffd,%rax
 800001032e0:	08 00 00 
 800001032e3:	ff d0                	call   *%rax
 800001032e5:	a8 80                	test   $0x80,%al
 800001032e7:	75 db                	jne    800001032c4 <cmostime+0x27>
        continue;
    fill_rtcdate(&t2);
 800001032e9:	48 8d 5d a0          	lea    -0x60(%rbp),%rbx
 800001032ed:	48 89 df             	mov    %rbx,%rdi
 800001032f0:	48 b8 10 30 10 00 00 	movabs $0x80000103010,%rax
 800001032f7:	08 00 00 
 800001032fa:	ff d0                	call   *%rax
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
 800001032fc:	48 8d 7d c0          	lea    -0x40(%rbp),%rdi
 80000103300:	ba 18 00 00 00       	mov    $0x18,%edx
 80000103305:	48 89 de             	mov    %rbx,%rsi
 80000103308:	48 b8 3b 56 10 00 00 	movabs $0x8000010563b,%rax
 8000010330f:	08 00 00 
 80000103312:	ff d0                	call   *%rax
 80000103314:	85 c0                	test   %eax,%eax
 80000103316:	75 ac                	jne    800001032c4 <cmostime+0x27>
      break;
  }

  // convert
  if(bcd) {
 80000103318:	45 85 ed             	test   %r13d,%r13d
 8000010331b:	75 78                	jne    80000103395 <cmostime+0xf8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
 8000010331d:	8b 45 c0             	mov    -0x40(%rbp),%eax
 80000103320:	89 c2                	mov    %eax,%edx
 80000103322:	c1 ea 04             	shr    $0x4,%edx
 80000103325:	8d 14 92             	lea    (%rdx,%rdx,4),%edx
 80000103328:	83 e0 0f             	and    $0xf,%eax
 8000010332b:	8d 04 50             	lea    (%rax,%rdx,2),%eax
 8000010332e:	89 45 c0             	mov    %eax,-0x40(%rbp)
    CONV(minute);
 80000103331:	8b 45 c4             	mov    -0x3c(%rbp),%eax
 80000103334:	89 c2                	mov    %eax,%edx
 80000103336:	c1 ea 04             	shr    $0x4,%edx
 80000103339:	8d 14 92             	lea    (%rdx,%rdx,4),%edx
 8000010333c:	83 e0 0f             	and    $0xf,%eax
 8000010333f:	8d 04 50             	lea    (%rax,%rdx,2),%eax
 80000103342:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    CONV(hour  );
 80000103345:	8b 45 c8             	mov    -0x38(%rbp),%eax
 80000103348:	89 c2                	mov    %eax,%edx
 8000010334a:	c1 ea 04             	shr    $0x4,%edx
 8000010334d:	8d 14 92             	lea    (%rdx,%rdx,4),%edx
 80000103350:	83 e0 0f             	and    $0xf,%eax
 80000103353:	8d 04 50             	lea    (%rax,%rdx,2),%eax
 80000103356:	89 45 c8             	mov    %eax,-0x38(%rbp)
    CONV(day   );
 80000103359:	8b 45 cc             	mov    -0x34(%rbp),%eax
 8000010335c:	89 c2                	mov    %eax,%edx
 8000010335e:	c1 ea 04             	shr    $0x4,%edx
 80000103361:	8d 14 92             	lea    (%rdx,%rdx,4),%edx
 80000103364:	83 e0 0f             	and    $0xf,%eax
 80000103367:	8d 04 50             	lea    (%rax,%rdx,2),%eax
 8000010336a:	89 45 cc             	mov    %eax,-0x34(%rbp)
    CONV(month );
 8000010336d:	8b 45 d0             	mov    -0x30(%rbp),%eax
 80000103370:	89 c2                	mov    %eax,%edx
 80000103372:	c1 ea 04             	shr    $0x4,%edx
 80000103375:	8d 14 92             	lea    (%rdx,%rdx,4),%edx
 80000103378:	83 e0 0f             	and    $0xf,%eax
 8000010337b:	8d 04 50             	lea    (%rax,%rdx,2),%eax
 8000010337e:	89 45 d0             	mov    %eax,-0x30(%rbp)
    CONV(year  );
 80000103381:	8b 45 d4             	mov    -0x2c(%rbp),%eax
 80000103384:	89 c2                	mov    %eax,%edx
 80000103386:	c1 ea 04             	shr    $0x4,%edx
 80000103389:	8d 14 92             	lea    (%rdx,%rdx,4),%edx
 8000010338c:	83 e0 0f             	and    $0xf,%eax
 8000010338f:	8d 04 50             	lea    (%rax,%rdx,2),%eax
 80000103392:	89 45 d4             	mov    %eax,-0x2c(%rbp)
#undef     CONV
  }

  *r = t1;
 80000103395:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
 80000103399:	49 89 04 24          	mov    %rax,(%r12)
 8000010339d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
 800001033a1:	49 89 44 24 08       	mov    %rax,0x8(%r12)
 800001033a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
 800001033aa:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  r->year += 2000;
 800001033af:	41 8b 44 24 14       	mov    0x14(%r12),%eax
 800001033b4:	05 d0 07 00 00       	add    $0x7d0,%eax
 800001033b9:	41 89 44 24 14       	mov    %eax,0x14(%r12)
}
 800001033be:	48 83 c4 48          	add    $0x48,%rsp
 800001033c2:	5b                   	pop    %rbx
 800001033c3:	41 5c                	pop    %r12
 800001033c5:	41 5d                	pop    %r13
 800001033c7:	5d                   	pop    %rbp
 800001033c8:	c3                   	ret
 800001033c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001033d0:	00 00 00 
 800001033d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001033da:	00 00 00 
 800001033dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001033e4:	00 00 00 
 800001033e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001033ee:	00 00 00 
 800001033f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001033f8:	00 00 00 
 800001033fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000080000103400 <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
 80000103400:	55                   	push   %rbp
 80000103401:	48 89 e5             	mov    %rsp,%rbp
 80000103404:	53                   	push   %rbx
 80000103405:	48 83 ec 08          	sub    $0x8,%rsp
  struct buf *buf = bread(log.dev, log.start);
 80000103409:	48 bb 00 9f 11 00 00 	movabs $0x80000119f00,%rbx
 80000103410:	08 00 00 
 80000103413:	8b 73 68             	mov    0x68(%rbx),%esi
 80000103416:	8b 7b 78             	mov    0x78(%rbx),%edi
 80000103419:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 80000103420:	08 00 00 
 80000103423:	ff d0                	call   *%rax
 80000103425:	48 89 c7             	mov    %rax,%rdi
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
 80000103428:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
 8000010342e:	89 43 7c             	mov    %eax,0x7c(%rbx)
  for (i = 0; i < log.lh.n; i++) {
 80000103431:	ba 00 00 00 00       	mov    $0x0,%edx
 80000103436:	eb 28                	jmp    80000103460 <read_head+0x60>
 80000103438:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 8000010343f:	00 
    log.lh.block[i] = lh->block[i];
 80000103440:	48 63 ca             	movslq %edx,%rcx
 80000103443:	44 8b 84 8f b4 00 00 	mov    0xb4(%rdi,%rcx,4),%r8d
 8000010344a:	00 
 8000010344b:	48 be 00 9f 11 00 00 	movabs $0x80000119f00,%rsi
 80000103452:	08 00 00 
 80000103455:	44 89 84 8e 80 00 00 	mov    %r8d,0x80(%rsi,%rcx,4)
 8000010345c:	00 
  for (i = 0; i < log.lh.n; i++) {
 8000010345d:	83 c2 01             	add    $0x1,%edx
 80000103460:	39 d0                	cmp    %edx,%eax
 80000103462:	7f dc                	jg     80000103440 <read_head+0x40>
  }
  brelse(buf);
 80000103464:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 8000010346b:	08 00 00 
 8000010346e:	ff d0                	call   *%rax
}
 80000103470:	48 83 c4 08          	add    $0x8,%rsp
 80000103474:	5b                   	pop    %rbx
 80000103475:	5d                   	pop    %rbp
 80000103476:	c3                   	ret

0000080000103477 <install_trans>:
{
 80000103477:	55                   	push   %rbp
 80000103478:	48 89 e5             	mov    %rsp,%rbp
 8000010347b:	41 56                	push   %r14
 8000010347d:	41 55                	push   %r13
 8000010347f:	41 54                	push   %r12
 80000103481:	53                   	push   %rbx
  for (tail = 0; tail < log.lh.n; tail++) {
 80000103482:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 80000103488:	e9 81 00 00 00       	jmp    8000010350e <install_trans+0x97>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
 8000010348d:	48 bb 00 9f 11 00 00 	movabs $0x80000119f00,%rbx
 80000103494:	08 00 00 
 80000103497:	44 89 e6             	mov    %r12d,%esi
 8000010349a:	03 73 68             	add    0x68(%rbx),%esi
 8000010349d:	83 c6 01             	add    $0x1,%esi
 800001034a0:	8b 7b 78             	mov    0x78(%rbx),%edi
 800001034a3:	49 be 7f 02 10 00 00 	movabs $0x8000010027f,%r14
 800001034aa:	08 00 00 
 800001034ad:	41 ff d6             	call   *%r14
 800001034b0:	49 89 c5             	mov    %rax,%r13
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
 800001034b3:	49 63 c4             	movslq %r12d,%rax
 800001034b6:	8b b4 83 80 00 00 00 	mov    0x80(%rbx,%rax,4),%esi
 800001034bd:	8b 7b 78             	mov    0x78(%rbx),%edi
 800001034c0:	41 ff d6             	call   *%r14
 800001034c3:	48 89 c3             	mov    %rax,%rbx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
 800001034c6:	49 8d b5 b0 00 00 00 	lea    0xb0(%r13),%rsi
 800001034cd:	48 8d b8 b0 00 00 00 	lea    0xb0(%rax),%rdi
 800001034d4:	ba 00 02 00 00       	mov    $0x200,%edx
 800001034d9:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 800001034e0:	08 00 00 
 800001034e3:	ff d0                	call   *%rax
    bwrite(dbuf);  // write dst to disk
 800001034e5:	48 89 df             	mov    %rbx,%rdi
 800001034e8:	48 b8 b7 02 10 00 00 	movabs $0x800001002b7,%rax
 800001034ef:	08 00 00 
 800001034f2:	ff d0                	call   *%rax
    brelse(lbuf);
 800001034f4:	4c 89 ef             	mov    %r13,%rdi
 800001034f7:	49 bd 0a 03 10 00 00 	movabs $0x8000010030a,%r13
 800001034fe:	08 00 00 
 80000103501:	41 ff d5             	call   *%r13
    brelse(dbuf);
 80000103504:	48 89 df             	mov    %rbx,%rdi
 80000103507:	41 ff d5             	call   *%r13
  for (tail = 0; tail < log.lh.n; tail++) {
 8000010350a:	41 83 c4 01          	add    $0x1,%r12d
 8000010350e:	a1 7c 9f 11 00 00 08 	movabs 0x80000119f7c,%eax
 80000103515:	00 00 
 80000103517:	44 39 e0             	cmp    %r12d,%eax
 8000010351a:	0f 8f 6d ff ff ff    	jg     8000010348d <install_trans+0x16>
}
 80000103520:	5b                   	pop    %rbx
 80000103521:	41 5c                	pop    %r12
 80000103523:	41 5d                	pop    %r13
 80000103525:	41 5e                	pop    %r14
 80000103527:	5d                   	pop    %rbp
 80000103528:	c3                   	ret

0000080000103529 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
 80000103529:	55                   	push   %rbp
 8000010352a:	48 89 e5             	mov    %rsp,%rbp
 8000010352d:	41 54                	push   %r12
 8000010352f:	53                   	push   %rbx
  struct buf *buf = bread(log.dev, log.start);
 80000103530:	49 bc 00 9f 11 00 00 	movabs $0x80000119f00,%r12
 80000103537:	08 00 00 
 8000010353a:	41 8b 74 24 68       	mov    0x68(%r12),%esi
 8000010353f:	41 8b 7c 24 78       	mov    0x78(%r12),%edi
 80000103544:	48 b8 7f 02 10 00 00 	movabs $0x8000010027f,%rax
 8000010354b:	08 00 00 
 8000010354e:	ff d0                	call   *%rax
 80000103550:	48 89 c3             	mov    %rax,%rbx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
 80000103553:	41 8b 74 24 7c       	mov    0x7c(%r12),%esi
 80000103558:	89 b0 b0 00 00 00    	mov    %esi,0xb0(%rax)
  for (i = 0; i < log.lh.n; i++) {
 8000010355e:	b8 00 00 00 00       	mov    $0x0,%eax
 80000103563:	eb 39                	jmp    8000010359e <write_head+0x75>
 80000103565:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 8000010356c:	00 00 00 00 
 80000103570:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000103577:	00 00 00 00 
 8000010357b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    hb->block[i] = log.lh.block[i];
 80000103580:	48 63 d0             	movslq %eax,%rdx
 80000103583:	48 b9 00 9f 11 00 00 	movabs $0x80000119f00,%rcx
 8000010358a:	08 00 00 
 8000010358d:	8b 8c 91 80 00 00 00 	mov    0x80(%rcx,%rdx,4),%ecx
 80000103594:	89 8c 93 b4 00 00 00 	mov    %ecx,0xb4(%rbx,%rdx,4)
  for (i = 0; i < log.lh.n; i++) {
 8000010359b:	83 c0 01             	add    $0x1,%eax
 8000010359e:	39 c6                	cmp    %eax,%esi
 800001035a0:	7f de                	jg     80000103580 <write_head+0x57>
  }
  bwrite(buf);
 800001035a2:	48 89 df             	mov    %rbx,%rdi
 800001035a5:	48 b8 b7 02 10 00 00 	movabs $0x800001002b7,%rax
 800001035ac:	08 00 00 
 800001035af:	ff d0                	call   *%rax
  brelse(buf);
 800001035b1:	48 89 df             	mov    %rbx,%rdi
 800001035b4:	48 b8 0a 03 10 00 00 	movabs $0x8000010030a,%rax
 800001035bb:	08 00 00 
 800001035be:	ff d0                	call   *%rax
}
 800001035c0:	5b                   	pop    %rbx
 800001035c1:	41 5c                	pop    %r12
 800001035c3:	5d                   	pop    %rbp
 800001035c4:	c3                   	ret

00000800001035c5 <recover_from_log>:

static void
recover_from_log(void)
{
 800001035c5:	55                   	push   %rbp
 800001035c6:	48 89 e5             	mov    %rsp,%rbp
  read_head();
 800001035c9:	48 b8 00 34 10 00 00 	movabs $0x80000103400,%rax
 800001035d0:	08 00 00 
 800001035d3:	ff d0                	call   *%rax
  install_trans(); // if committed, copy from log to disk
 800001035d5:	48 b8 77 34 10 00 00 	movabs $0x80000103477,%rax
 800001035dc:	08 00 00 
 800001035df:	ff d0                	call   *%rax
  log.lh.n = 0;
 800001035e1:	48 b8 7c 9f 11 00 00 	movabs $0x80000119f7c,%rax
 800001035e8:	08 00 00 
 800001035eb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  write_head(); // clear the log
 800001035f1:	48 b8 29 35 10 00 00 	movabs $0x80000103529,%rax
 800001035f8:	08 00 00 
 800001035fb:	ff d0                	call   *%rax
}
 800001035fd:	5d                   	pop    %rbp
 800001035fe:	c3                   	ret

00000800001035ff <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
 800001035ff:	55                   	push   %rbp
 80000103600:	48 89 e5             	mov    %rsp,%rbp
 80000103603:	41 56                	push   %r14
 80000103605:	41 55                	push   %r13
 80000103607:	41 54                	push   %r12
 80000103609:	53                   	push   %rbx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
 8000010360a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 80000103610:	e9 85 00 00 00       	jmp    8000010369a <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
 80000103615:	49 bd 00 9f 11 00 00 	movabs $0x80000119f00,%r13
 8000010361c:	08 00 00 
 8000010361f:	44 89 e6             	mov    %r12d,%esi
 80000103622:	41 03 75 68          	add    0x68(%r13),%esi
 80000103626:	83 c6 01             	add    $0x1,%esi
 80000103629:	41 8b 7d 78          	mov    0x78(%r13),%edi
 8000010362d:	49 be 7f 02 10 00 00 	movabs $0x8000010027f,%r14
 80000103634:	08 00 00 
 80000103637:	41 ff d6             	call   *%r14
 8000010363a:	48 89 c3             	mov    %rax,%rbx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
 8000010363d:	49 63 c4             	movslq %r12d,%rax
 80000103640:	41 8b b4 85 80 00 00 	mov    0x80(%r13,%rax,4),%esi
 80000103647:	00 
 80000103648:	41 8b 7d 78          	mov    0x78(%r13),%edi
 8000010364c:	41 ff d6             	call   *%r14
 8000010364f:	49 89 c5             	mov    %rax,%r13
    memmove(to->data, from->data, BSIZE);
 80000103652:	48 8d b0 b0 00 00 00 	lea    0xb0(%rax),%rsi
 80000103659:	48 8d bb b0 00 00 00 	lea    0xb0(%rbx),%rdi
 80000103660:	ba 00 02 00 00       	mov    $0x200,%edx
 80000103665:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 8000010366c:	08 00 00 
 8000010366f:	ff d0                	call   *%rax
    bwrite(to);  // write the log
 80000103671:	48 89 df             	mov    %rbx,%rdi
 80000103674:	48 b8 b7 02 10 00 00 	movabs $0x800001002b7,%rax
 8000010367b:	08 00 00 
 8000010367e:	ff d0                	call   *%rax
    brelse(from);
 80000103680:	4c 89 ef             	mov    %r13,%rdi
 80000103683:	49 bd 0a 03 10 00 00 	movabs $0x8000010030a,%r13
 8000010368a:	08 00 00 
 8000010368d:	41 ff d5             	call   *%r13
    brelse(to);
 80000103690:	48 89 df             	mov    %rbx,%rdi
 80000103693:	41 ff d5             	call   *%r13
  for (tail = 0; tail < log.lh.n; tail++) {
 80000103696:	41 83 c4 01          	add    $0x1,%r12d
 8000010369a:	a1 7c 9f 11 00 00 08 	movabs 0x80000119f7c,%eax
 800001036a1:	00 00 
 800001036a3:	44 39 e0             	cmp    %r12d,%eax
 800001036a6:	0f 8f 69 ff ff ff    	jg     80000103615 <write_log+0x16>
  }
}
 800001036ac:	5b                   	pop    %rbx
 800001036ad:	41 5c                	pop    %r12
 800001036af:	41 5d                	pop    %r13
 800001036b1:	41 5e                	pop    %r14
 800001036b3:	5d                   	pop    %rbp
 800001036b4:	c3                   	ret

00000800001036b5 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
 800001036b5:	a1 7c 9f 11 00 00 08 	movabs 0x80000119f7c,%eax
 800001036bc:	00 00 
 800001036be:	85 c0                	test   %eax,%eax
 800001036c0:	7f 01                	jg     800001036c3 <commit+0xe>
 800001036c2:	c3                   	ret
{
 800001036c3:	55                   	push   %rbp
 800001036c4:	48 89 e5             	mov    %rsp,%rbp
 800001036c7:	53                   	push   %rbx
 800001036c8:	48 83 ec 08          	sub    $0x8,%rsp
    write_log();     // Write modified blocks from cache to log
 800001036cc:	48 b8 ff 35 10 00 00 	movabs $0x800001035ff,%rax
 800001036d3:	08 00 00 
 800001036d6:	ff d0                	call   *%rax
    write_head();    // Write header to disk -- the real commit
 800001036d8:	48 bb 29 35 10 00 00 	movabs $0x80000103529,%rbx
 800001036df:	08 00 00 
 800001036e2:	ff d3                	call   *%rbx
    install_trans(); // Now install writes to home locations
 800001036e4:	48 b8 77 34 10 00 00 	movabs $0x80000103477,%rax
 800001036eb:	08 00 00 
 800001036ee:	ff d0                	call   *%rax
    log.lh.n = 0;
 800001036f0:	48 b8 7c 9f 11 00 00 	movabs $0x80000119f7c,%rax
 800001036f7:	08 00 00 
 800001036fa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    write_head();    // Erase the transaction from the log
 80000103700:	ff d3                	call   *%rbx
  }
}
 80000103702:	48 83 c4 08          	add    $0x8,%rsp
 80000103706:	5b                   	pop    %rbx
 80000103707:	5d                   	pop    %rbp
 80000103708:	c3                   	ret

0000080000103709 <initlog>:
{
 80000103709:	55                   	push   %rbp
 8000010370a:	48 89 e5             	mov    %rsp,%rbp
 8000010370d:	41 54                	push   %r12
 8000010370f:	53                   	push   %rbx
 80000103710:	48 83 ec 20          	sub    $0x20,%rsp
 80000103714:	41 89 fc             	mov    %edi,%r12d
  initlock(&log.lock, "log");
 80000103717:	48 be 77 ab 10 00 00 	movabs $0x8000010ab77,%rsi
 8000010371e:	08 00 00 
 80000103721:	48 bb 00 9f 11 00 00 	movabs $0x80000119f00,%rbx
 80000103728:	08 00 00 
 8000010372b:	48 89 df             	mov    %rbx,%rdi
 8000010372e:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 80000103735:	08 00 00 
 80000103738:	ff d0                	call   *%rax
  readsb(dev, &sb);
 8000010373a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
 8000010373e:	44 89 e7             	mov    %r12d,%edi
 80000103741:	48 b8 05 1b 10 00 00 	movabs $0x80000101b05,%rax
 80000103748:	08 00 00 
 8000010374b:	ff d0                	call   *%rax
  log.start = sb.logstart;
 8000010374d:	8b 45 e0             	mov    -0x20(%rbp),%eax
 80000103750:	89 43 68             	mov    %eax,0x68(%rbx)
  log.size = sb.nlog;
 80000103753:	8b 45 dc             	mov    -0x24(%rbp),%eax
 80000103756:	89 43 6c             	mov    %eax,0x6c(%rbx)
  log.dev = dev;
 80000103759:	44 89 63 78          	mov    %r12d,0x78(%rbx)
  recover_from_log();
 8000010375d:	48 b8 c5 35 10 00 00 	movabs $0x800001035c5,%rax
 80000103764:	08 00 00 
 80000103767:	ff d0                	call   *%rax
}
 80000103769:	48 83 c4 20          	add    $0x20,%rsp
 8000010376d:	5b                   	pop    %rbx
 8000010376e:	41 5c                	pop    %r12
 80000103770:	5d                   	pop    %rbp
 80000103771:	c3                   	ret

0000080000103772 <begin_op>:
{
 80000103772:	55                   	push   %rbp
 80000103773:	48 89 e5             	mov    %rsp,%rbp
  acquire(&log.lock);
 80000103776:	48 bf 00 9f 11 00 00 	movabs $0x80000119f00,%rdi
 8000010377d:	08 00 00 
 80000103780:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000103787:	08 00 00 
 8000010378a:	ff d0                	call   *%rax
 8000010378c:	eb 19                	jmp    800001037a7 <begin_op+0x35>
      sleep(&log, &log.lock);
 8000010378e:	48 bf 00 9f 11 00 00 	movabs $0x80000119f00,%rdi
 80000103795:	08 00 00 
 80000103798:	48 89 fe             	mov    %rdi,%rsi
 8000010379b:	48 b8 03 4e 10 00 00 	movabs $0x80000104e03,%rax
 800001037a2:	08 00 00 
 800001037a5:	ff d0                	call   *%rax
    if(log.committing){
 800001037a7:	a1 74 9f 11 00 00 08 	movabs 0x80000119f74,%eax
 800001037ae:	00 00 
 800001037b0:	85 c0                	test   %eax,%eax
 800001037b2:	75 da                	jne    8000010378e <begin_op+0x1c>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
 800001037b4:	48 b9 00 9f 11 00 00 	movabs $0x80000119f00,%rcx
 800001037bb:	08 00 00 
 800001037be:	8b 41 70             	mov    0x70(%rcx),%eax
 800001037c1:	83 c0 01             	add    $0x1,%eax
 800001037c4:	8d 34 80             	lea    (%rax,%rax,4),%esi
 800001037c7:	8d 14 36             	lea    (%rsi,%rsi,1),%edx
 800001037ca:	03 51 7c             	add    0x7c(%rcx),%edx
 800001037cd:	83 fa 1e             	cmp    $0x1e,%edx
 800001037d0:	7e 14                	jle    800001037e6 <begin_op+0x74>
      sleep(&log, &log.lock);
 800001037d2:	48 89 cf             	mov    %rcx,%rdi
 800001037d5:	48 89 ce             	mov    %rcx,%rsi
 800001037d8:	48 b8 03 4e 10 00 00 	movabs $0x80000104e03,%rax
 800001037df:	08 00 00 
 800001037e2:	ff d0                	call   *%rax
 800001037e4:	eb c1                	jmp    800001037a7 <begin_op+0x35>
      log.outstanding += 1;
 800001037e6:	48 bf 00 9f 11 00 00 	movabs $0x80000119f00,%rdi
 800001037ed:	08 00 00 
 800001037f0:	89 47 70             	mov    %eax,0x70(%rdi)
      release(&log.lock);
 800001037f3:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001037fa:	08 00 00 
 800001037fd:	ff d0                	call   *%rax
}
 800001037ff:	5d                   	pop    %rbp
 80000103800:	c3                   	ret

0000080000103801 <end_op>:
{
 80000103801:	55                   	push   %rbp
 80000103802:	48 89 e5             	mov    %rsp,%rbp
 80000103805:	53                   	push   %rbx
 80000103806:	48 83 ec 08          	sub    $0x8,%rsp
  acquire(&log.lock);
 8000010380a:	48 bb 00 9f 11 00 00 	movabs $0x80000119f00,%rbx
 80000103811:	08 00 00 
 80000103814:	48 89 df             	mov    %rbx,%rdi
 80000103817:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 8000010381e:	08 00 00 
 80000103821:	ff d0                	call   *%rax
  log.outstanding -= 1;
 80000103823:	8b 43 70             	mov    0x70(%rbx),%eax
 80000103826:	83 e8 01             	sub    $0x1,%eax
 80000103829:	89 43 70             	mov    %eax,0x70(%rbx)
  if(log.committing)
 8000010382c:	8b 5b 74             	mov    0x74(%rbx),%ebx
 8000010382f:	85 db                	test   %ebx,%ebx
 80000103831:	75 3a                	jne    8000010386d <end_op+0x6c>
  if(log.outstanding == 0){
 80000103833:	85 c0                	test   %eax,%eax
 80000103835:	75 4c                	jne    80000103883 <end_op+0x82>
    log.committing = 1;
 80000103837:	48 b8 74 9f 11 00 00 	movabs $0x80000119f74,%rax
 8000010383e:	08 00 00 
 80000103841:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
    do_commit = 1;
 80000103847:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
 8000010384c:	48 bf 00 9f 11 00 00 	movabs $0x80000119f00,%rdi
 80000103853:	08 00 00 
 80000103856:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 8000010385d:	08 00 00 
 80000103860:	ff d0                	call   *%rax
  if(do_commit){
 80000103862:	85 db                	test   %ebx,%ebx
 80000103864:	75 35                	jne    8000010389b <end_op+0x9a>
}
 80000103866:	48 83 c4 08          	add    $0x8,%rsp
 8000010386a:	5b                   	pop    %rbx
 8000010386b:	5d                   	pop    %rbp
 8000010386c:	c3                   	ret
    panic("log.committing");
 8000010386d:	48 bf 7b ab 10 00 00 	movabs $0x8000010ab7b,%rdi
 80000103874:	08 00 00 
 80000103877:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 8000010387e:	08 00 00 
 80000103881:	ff d0                	call   *%rax
    wakeup(&log);
 80000103883:	48 bf 00 9f 11 00 00 	movabs $0x80000119f00,%rdi
 8000010388a:	08 00 00 
 8000010388d:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 80000103894:	08 00 00 
 80000103897:	ff d0                	call   *%rax
 80000103899:	eb b1                	jmp    8000010384c <end_op+0x4b>
    commit();
 8000010389b:	b0 00                	mov    $0x0,%al
 8000010389d:	48 ba b5 36 10 00 00 	movabs $0x800001036b5,%rdx
 800001038a4:	08 00 00 
 800001038a7:	ff d2                	call   *%rdx
    acquire(&log.lock);
 800001038a9:	48 bb 00 9f 11 00 00 	movabs $0x80000119f00,%rbx
 800001038b0:	08 00 00 
 800001038b3:	48 89 df             	mov    %rbx,%rdi
 800001038b6:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 800001038bd:	08 00 00 
 800001038c0:	ff d0                	call   *%rax
    log.committing = 0;
 800001038c2:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%rbx)
    wakeup(&log);
 800001038c9:	48 89 df             	mov    %rbx,%rdi
 800001038cc:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 800001038d3:	08 00 00 
 800001038d6:	ff d0                	call   *%rax
    release(&log.lock);
 800001038d8:	48 89 df             	mov    %rbx,%rdi
 800001038db:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001038e2:	08 00 00 
 800001038e5:	ff d0                	call   *%rax
}
 800001038e7:	e9 7a ff ff ff       	jmp    80000103866 <end_op+0x65>

00000800001038ec <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
 800001038ec:	55                   	push   %rbp
 800001038ed:	48 89 e5             	mov    %rsp,%rbp
 800001038f0:	53                   	push   %rbx
 800001038f1:	48 83 ec 08          	sub    $0x8,%rsp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
 800001038f5:	48 b8 7c 9f 11 00 00 	movabs $0x80000119f7c,%rax
 800001038fc:	08 00 00 
 800001038ff:	8b 10                	mov    (%rax),%edx
 80000103901:	83 fa 1d             	cmp    $0x1d,%edx
 80000103904:	7f 3d                	jg     80000103943 <log_write+0x57>
 80000103906:	48 89 fb             	mov    %rdi,%rbx
 80000103909:	a1 6c 9f 11 00 00 08 	movabs 0x80000119f6c,%eax
 80000103910:	00 00 
 80000103912:	83 e8 01             	sub    $0x1,%eax
 80000103915:	39 c2                	cmp    %eax,%edx
 80000103917:	7d 2a                	jge    80000103943 <log_write+0x57>
    panic("too big a transaction");
  if (log.outstanding < 1)
 80000103919:	a1 70 9f 11 00 00 08 	movabs 0x80000119f70,%eax
 80000103920:	00 00 
 80000103922:	85 c0                	test   %eax,%eax
 80000103924:	7e 33                	jle    80000103959 <log_write+0x6d>
    panic("log_write outside of trans");

  acquire(&log.lock);
 80000103926:	48 bf 00 9f 11 00 00 	movabs $0x80000119f00,%rdi
 8000010392d:	08 00 00 
 80000103930:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000103937:	08 00 00 
 8000010393a:	ff d0                	call   *%rax
  for (i = 0; i < log.lh.n; i++) {
 8000010393c:	ba 00 00 00 00       	mov    $0x0,%edx
 80000103941:	eb 40                	jmp    80000103983 <log_write+0x97>
    panic("too big a transaction");
 80000103943:	48 bf 8a ab 10 00 00 	movabs $0x8000010ab8a,%rdi
 8000010394a:	08 00 00 
 8000010394d:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000103954:	08 00 00 
 80000103957:	ff d0                	call   *%rax
    panic("log_write outside of trans");
 80000103959:	48 bf a0 ab 10 00 00 	movabs $0x8000010aba0,%rdi
 80000103960:	08 00 00 
 80000103963:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 8000010396a:	08 00 00 
 8000010396d:	ff d0                	call   *%rax
 8000010396f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000103976:	00 00 00 00 
 8000010397a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  for (i = 0; i < log.lh.n; i++) {
 80000103980:	83 c2 01             	add    $0x1,%edx
 80000103983:	a1 7c 9f 11 00 00 08 	movabs 0x80000119f7c,%eax
 8000010398a:	00 00 
 8000010398c:	39 d0                	cmp    %edx,%eax
 8000010398e:	7e 19                	jle    800001039a9 <log_write+0xbd>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
 80000103990:	48 63 ca             	movslq %edx,%rcx
 80000103993:	48 be 00 9f 11 00 00 	movabs $0x80000119f00,%rsi
 8000010399a:	08 00 00 
 8000010399d:	8b 7b 08             	mov    0x8(%rbx),%edi
 800001039a0:	39 bc 8e 80 00 00 00 	cmp    %edi,0x80(%rsi,%rcx,4)
 800001039a7:	75 d7                	jne    80000103980 <log_write+0x94>
      break;
  }
  log.lh.block[i] = b->blockno;
 800001039a9:	8b 7b 08             	mov    0x8(%rbx),%edi
 800001039ac:	48 63 f2             	movslq %edx,%rsi
 800001039af:	48 b9 00 9f 11 00 00 	movabs $0x80000119f00,%rcx
 800001039b6:	08 00 00 
 800001039b9:	89 bc b1 80 00 00 00 	mov    %edi,0x80(%rcx,%rsi,4)
  if (i == log.lh.n)
 800001039c0:	39 d0                	cmp    %edx,%eax
 800001039c2:	74 24                	je     800001039e8 <log_write+0xfc>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
 800001039c4:	8b 03                	mov    (%rbx),%eax
 800001039c6:	83 c8 04             	or     $0x4,%eax
 800001039c9:	89 03                	mov    %eax,(%rbx)
  release(&log.lock);
 800001039cb:	48 bf 00 9f 11 00 00 	movabs $0x80000119f00,%rdi
 800001039d2:	08 00 00 
 800001039d5:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001039dc:	08 00 00 
 800001039df:	ff d0                	call   *%rax
}
 800001039e1:	48 83 c4 08          	add    $0x8,%rsp
 800001039e5:	5b                   	pop    %rbx
 800001039e6:	5d                   	pop    %rbp
 800001039e7:	c3                   	ret
    log.lh.n++;
 800001039e8:	83 c0 01             	add    $0x1,%eax
 800001039eb:	a3 7c 9f 11 00 00 08 	movabs %eax,0x80000119f7c
 800001039f2:	00 00 
 800001039f4:	eb ce                	jmp    800001039c4 <log_write+0xd8>
 800001039f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001039fd:	00 00 00 

0000080000103a00 <startothers>:
extern pml4e_t entrypml4[NPML4ENTRIES];

// Start the non-boot (AP) processors.
static void
startothers(void)
{
 80000103a00:	55                   	push   %rbp
 80000103a01:	48 89 e5             	mov    %rsp,%rbp
 80000103a04:	53                   	push   %rbx
 80000103a05:	48 83 ec 08          	sub    $0x8,%rsp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint64)_binary_entryother_size);
 80000103a09:	48 ba d2 00 00 00 00 	movabs $0xd2,%rdx
 80000103a10:	00 00 00 
 80000103a13:	48 be 88 0c 11 00 00 	movabs $0x80000110c88,%rsi
 80000103a1a:	08 00 00 
 80000103a1d:	48 bf 00 70 00 00 00 	movabs $0x80000007000,%rdi
 80000103a24:	08 00 00 
 80000103a27:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 80000103a2e:	08 00 00 
 80000103a31:	ff d0                	call   *%rax

  for(c = cpus; c < cpus+ncpu; c++){
 80000103a33:	48 bb 20 a0 11 00 00 	movabs $0x8000011a020,%rbx
 80000103a3a:	08 00 00 
 80000103a3d:	eb 07                	jmp    80000103a46 <startothers+0x46>
 80000103a3f:	48 81 c3 c8 00 00 00 	add    $0xc8,%rbx
 80000103a46:	a1 04 a0 11 00 00 08 	movabs 0x8000011a004,%eax
 80000103a4d:	00 00 
 80000103a4f:	48 98                	cltq
 80000103a51:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 80000103a55:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
 80000103a59:	48 b8 20 a0 11 00 00 	movabs $0x8000011a020,%rax
 80000103a60:	08 00 00 
 80000103a63:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
 80000103a67:	48 39 c3             	cmp    %rax,%rbx
 80000103a6a:	0f 83 7f 00 00 00    	jae    80000103aef <startothers+0xef>
    if(c == mycpu())  // We've started already.
 80000103a70:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000103a77:	08 00 00 
 80000103a7a:	ff d0                	call   *%rax
 80000103a7c:	48 39 c3             	cmp    %rax,%rbx
 80000103a7f:	74 be                	je     80000103a3f <startothers+0x3f>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pml4 to use. We cannot use kpml4 yet, because the AP processor
    // is running in low  memory, so we use entrypml4 for the APs too.
    stack = kalloc();
 80000103a81:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000103a88:	08 00 00 
 80000103a8b:	ff d0                	call   *%rax
    *(void**)(code-8) = stack + KSTACKSIZE;
 80000103a8d:	48 05 00 10 00 00    	add    $0x1000,%rax
 80000103a93:	48 a3 f8 6f 00 00 00 	movabs %rax,0x80000006ff8
 80000103a9a:	08 00 00 
    *(void(**)(void))(code-16) = mpenter;
 80000103a9d:	48 b8 6a 3b 10 00 00 	movabs $0x80000103b6a,%rax
 80000103aa4:	08 00 00 
 80000103aa7:	48 a3 f0 6f 00 00 00 	movabs %rax,0x80000006ff0
 80000103aae:	08 00 00 
    *(uint*)(code-20) = V2P(entrypml4);
 80000103ab1:	48 b8 00 d0 10 00 00 	movabs $0x8000010d000,%rax
 80000103ab8:	08 00 00 
 80000103abb:	a3 ec 6f 00 00 00 08 	movabs %eax,0x80000006fec
 80000103ac2:	00 00 

    lapicstartap(c->apicid, V2P(code));
 80000103ac4:	0f b6 3b             	movzbl (%rbx),%edi
 80000103ac7:	be 00 70 00 00       	mov    $0x7000,%esi
 80000103acc:	48 b8 ed 31 10 00 00 	movabs $0x800001031ed,%rax
 80000103ad3:	08 00 00 
 80000103ad6:	ff d0                	call   *%rax

    // wait for cpu to finish mpmain()
    while(c->started == 0)
 80000103ad8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 80000103adf:	00 
 80000103ae0:	8b 83 b0 00 00 00    	mov    0xb0(%rbx),%eax
 80000103ae6:	85 c0                	test   %eax,%eax
 80000103ae8:	74 f6                	je     80000103ae0 <startothers+0xe0>
 80000103aea:	e9 50 ff ff ff       	jmp    80000103a3f <startothers+0x3f>
      ;
  }
}
 80000103aef:	48 83 c4 08          	add    $0x8,%rsp
 80000103af3:	5b                   	pop    %rbx
 80000103af4:	5d                   	pop    %rbp
 80000103af5:	c3                   	ret

0000080000103af6 <mpmain>:
{
 80000103af6:	55                   	push   %rbp
 80000103af7:	48 89 e5             	mov    %rsp,%rbp
 80000103afa:	41 54                	push   %r12
 80000103afc:	53                   	push   %rbx
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
 80000103afd:	49 bc 3b 46 10 00 00 	movabs $0x8000010463b,%r12
 80000103b04:	08 00 00 
 80000103b07:	41 ff d4             	call   *%r12
 80000103b0a:	89 c3                	mov    %eax,%ebx
 80000103b0c:	41 ff d4             	call   *%r12
 80000103b0f:	89 c6                	mov    %eax,%esi
 80000103b11:	89 da                	mov    %ebx,%edx
 80000103b13:	48 bf bb ab 10 00 00 	movabs $0x8000010abbb,%rdi
 80000103b1a:	08 00 00 
 80000103b1d:	b0 00                	mov    $0x0,%al
 80000103b1f:	48 b9 f9 08 10 00 00 	movabs $0x800001008f9,%rcx
 80000103b26:	08 00 00 
 80000103b29:	ff d1                	call   *%rcx
  idtinit();       // load idt register
 80000103b2b:	48 b8 7f 6e 10 00 00 	movabs $0x80000106e7f,%rax
 80000103b32:	08 00 00 
 80000103b35:	ff d0                	call   *%rax
  vmxinit();       // enter VMX operation
 80000103b37:	48 b8 65 9b 10 00 00 	movabs $0x80000109b65,%rax
 80000103b3e:	08 00 00 
 80000103b41:	ff d0                	call   *%rax
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
 80000103b43:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000103b4a:	08 00 00 
 80000103b4d:	ff d0                	call   *%rax
 80000103b4f:	48 89 c2             	mov    %rax,%rdx
    asm volatile("lock; xchgl %0, %1" :
 80000103b52:	b8 01 00 00 00       	mov    $0x1,%eax
 80000103b57:	f0 87 82 b0 00 00 00 	lock xchg %eax,0xb0(%rdx)
  scheduler();     // start running processes
 80000103b5e:	48 b8 73 4a 10 00 00 	movabs $0x80000104a73,%rax
 80000103b65:	08 00 00 
 80000103b68:	ff d0                	call   *%rax

0000080000103b6a <mpenter>:
{
 80000103b6a:	55                   	push   %rbp
 80000103b6b:	48 89 e5             	mov    %rsp,%rbp
  switchkvm();
 80000103b6e:	48 b8 31 84 10 00 00 	movabs $0x80000108431,%rax
 80000103b75:	08 00 00 
 80000103b78:	ff d0                	call   *%rax
  seginit();
 80000103b7a:	48 b8 17 81 10 00 00 	movabs $0x80000108117,%rax
 80000103b81:	08 00 00 
 80000103b84:	ff d0                	call   *%rax
  lapicinit();
 80000103b86:	48 b8 6a 30 10 00 00 	movabs $0x8000010306a,%rax
 80000103b8d:	08 00 00 
 80000103b90:	ff d0                	call   *%rax
  mpmain();
 80000103b92:	48 b8 f6 3a 10 00 00 	movabs $0x80000103af6,%rax
 80000103b99:	08 00 00 
 80000103b9c:	ff d0                	call   *%rax

0000080000103b9e <main>:
{
 80000103b9e:	55                   	push   %rbp
 80000103b9f:	48 89 e5             	mov    %rsp,%rbp
 80000103ba2:	53                   	push   %rbx
 80000103ba3:	48 83 ec 08          	sub    $0x8,%rsp
  kinit1(end, kinit1_end); // phys page allocator
 80000103ba7:	48 bb 00 00 00 0e 00 	movabs $0x8000e000000,%rbx
 80000103bae:	08 00 00 
 80000103bb1:	48 89 de             	mov    %rbx,%rsi
 80000103bb4:	48 bf a0 ff 11 00 00 	movabs $0x8000011ffa0,%rdi
 80000103bbb:	08 00 00 
 80000103bbe:	48 b8 c6 2d 10 00 00 	movabs $0x80000102dc6,%rax
 80000103bc5:	08 00 00 
 80000103bc8:	ff d0                	call   *%rax
  kvmalloc();      // kernel page table
 80000103bca:	48 b8 66 8b 10 00 00 	movabs $0x80000108b66,%rax
 80000103bd1:	08 00 00 
 80000103bd4:	ff d0                	call   *%rax
  mpinit();        // detect other processors
 80000103bd6:	48 b8 8c 3e 10 00 00 	movabs $0x80000103e8c,%rax
 80000103bdd:	08 00 00 
 80000103be0:	ff d0                	call   *%rax
  lapicinit();     // interrupt controller
 80000103be2:	48 b8 6a 30 10 00 00 	movabs $0x8000010306a,%rax
 80000103be9:	08 00 00 
 80000103bec:	ff d0                	call   *%rax
  seginit();       // segment descriptors
 80000103bee:	48 b8 17 81 10 00 00 	movabs $0x80000108117,%rax
 80000103bf5:	08 00 00 
 80000103bf8:	ff d0                	call   *%rax
  picinit();       // disable pic
 80000103bfa:	48 b8 c9 3f 10 00 00 	movabs $0x80000103fc9,%rax
 80000103c01:	08 00 00 
 80000103c04:	ff d0                	call   *%rax
  ioapicinit();    // another interrupt controller
 80000103c06:	48 b8 e5 2b 10 00 00 	movabs $0x80000102be5,%rax
 80000103c0d:	08 00 00 
 80000103c10:	ff d0                	call   *%rax
  consoleinit();   // console hardware
 80000103c12:	48 b8 2d 0d 10 00 00 	movabs $0x80000100d2d,%rax
 80000103c19:	08 00 00 
 80000103c1c:	ff d0                	call   *%rax
  uartinit();      // serial port
 80000103c1e:	48 b8 ca 72 10 00 00 	movabs $0x800001072ca,%rax
 80000103c25:	08 00 00 
 80000103c28:	ff d0                	call   *%rax
  pinit();         // process table
 80000103c2a:	48 b8 82 45 10 00 00 	movabs $0x80000104582,%rax
 80000103c31:	08 00 00 
 80000103c34:	ff d0                	call   *%rax
  tvinit();        // trap vectors
 80000103c36:	48 b8 4b 6d 10 00 00 	movabs $0x80000106d4b,%rax
 80000103c3d:	08 00 00 
 80000103c40:	ff d0                	call   *%rax
  binit();         // buffer cache
 80000103c42:	48 b8 c6 01 10 00 00 	movabs $0x800001001c6,%rax
 80000103c49:	08 00 00 
 80000103c4c:	ff d0                	call   *%rax
  fileinit();      // file table
 80000103c4e:	48 b8 f7 11 10 00 00 	movabs $0x800001011f7,%rax
 80000103c55:	08 00 00 
 80000103c58:	ff d0                	call   *%rax
  ideinit();       // disk 
 80000103c5a:	48 b8 09 29 10 00 00 	movabs $0x80000102909,%rax
 80000103c61:	08 00 00 
 80000103c64:	ff d0                	call   *%rax
  startothers();   // start other processors
 80000103c66:	48 b8 00 3a 10 00 00 	movabs $0x80000103a00,%rax
 80000103c6d:	08 00 00 
 80000103c70:	ff d0                	call   *%rax
  kinit2(kinit1_end, P2V(PHYSTOP)); // must come after startothers()
 80000103c72:	48 89 de             	mov    %rbx,%rsi
 80000103c75:	48 89 df             	mov    %rbx,%rdi
 80000103c78:	48 b8 21 2e 10 00 00 	movabs $0x80000102e21,%rax
 80000103c7f:	08 00 00 
 80000103c82:	ff d0                	call   *%rax
  userinit();      // first user process
 80000103c84:	48 b8 a2 46 10 00 00 	movabs $0x800001046a2,%rax
 80000103c8b:	08 00 00 
 80000103c8e:	ff d0                	call   *%rax
  mpmain();
 80000103c90:	48 b8 f6 3a 10 00 00 	movabs $0x80000103af6,%rax
 80000103c97:	08 00 00 
 80000103c9a:	ff d0                	call   *%rax
 80000103c9c:	0f 1f 40 00          	nopl   0x0(%rax)

0000080000103ca0 <sum>:
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
 80000103ca0:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
 80000103ca5:	ba 00 00 00 00       	mov    $0x0,%edx
 80000103caa:	eb 10                	jmp    80000103cbc <sum+0x1c>
 80000103cac:	0f 1f 40 00          	nopl   0x0(%rax)
    sum += addr[i];
 80000103cb0:	48 63 ca             	movslq %edx,%rcx
 80000103cb3:	0f b6 0c 0f          	movzbl (%rdi,%rcx,1),%ecx
 80000103cb7:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
 80000103cb9:	83 c2 01             	add    $0x1,%edx
 80000103cbc:	39 f2                	cmp    %esi,%edx
 80000103cbe:	7c f0                	jl     80000103cb0 <sum+0x10>
  return sum;
}
 80000103cc0:	c3                   	ret

0000080000103cc1 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint64 a, int len)
{
 80000103cc1:	55                   	push   %rbp
 80000103cc2:	48 89 e5             	mov    %rsp,%rbp
 80000103cc5:	41 54                	push   %r12
 80000103cc7:	53                   	push   %rbx
  uchar *e, *p, *addr;

  addr = P2V(a);
 80000103cc8:	48 b8 00 00 00 00 00 	movabs $0x80000000000,%rax
 80000103ccf:	08 00 00 
 80000103cd2:	4c 8d 24 07          	lea    (%rdi,%rax,1),%r12
 80000103cd6:	4c 89 e3             	mov    %r12,%rbx
  e = addr+len;
 80000103cd9:	48 63 f6             	movslq %esi,%rsi
 80000103cdc:	49 01 f4             	add    %rsi,%r12
  for(p = addr; p < e; p += sizeof(struct mp))
 80000103cdf:	eb 04                	jmp    80000103ce5 <mpsearch1+0x24>
 80000103ce1:	48 83 c3 10          	add    $0x10,%rbx
 80000103ce5:	4c 39 e3             	cmp    %r12,%rbx
 80000103ce8:	73 3f                	jae    80000103d29 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
 80000103cea:	ba 04 00 00 00       	mov    $0x4,%edx
 80000103cef:	48 be cf ab 10 00 00 	movabs $0x8000010abcf,%rsi
 80000103cf6:	08 00 00 
 80000103cf9:	48 89 df             	mov    %rbx,%rdi
 80000103cfc:	48 b8 3b 56 10 00 00 	movabs $0x8000010563b,%rax
 80000103d03:	08 00 00 
 80000103d06:	ff d0                	call   *%rax
 80000103d08:	85 c0                	test   %eax,%eax
 80000103d0a:	75 d5                	jne    80000103ce1 <mpsearch1+0x20>
 80000103d0c:	be 10 00 00 00       	mov    $0x10,%esi
 80000103d11:	48 89 df             	mov    %rbx,%rdi
 80000103d14:	48 b8 a0 3c 10 00 00 	movabs $0x80000103ca0,%rax
 80000103d1b:	08 00 00 
 80000103d1e:	ff d0                	call   *%rax
 80000103d20:	0f b6 c0             	movzbl %al,%eax
 80000103d23:	85 c0                	test   %eax,%eax
 80000103d25:	75 ba                	jne    80000103ce1 <mpsearch1+0x20>
 80000103d27:	eb 05                	jmp    80000103d2e <mpsearch1+0x6d>
      return (struct mp*)p;
  return 0;
 80000103d29:	bb 00 00 00 00       	mov    $0x0,%ebx
}
 80000103d2e:	48 89 d8             	mov    %rbx,%rax
 80000103d31:	5b                   	pop    %rbx
 80000103d32:	41 5c                	pop    %r12
 80000103d34:	5d                   	pop    %rbp
 80000103d35:	c3                   	ret

0000080000103d36 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
 80000103d36:	55                   	push   %rbp
 80000103d37:	48 89 e5             	mov    %rsp,%rbp
  uchar *bda;
  uint64 p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
 80000103d3a:	48 b8 0f 04 00 00 00 	movabs $0x8000000040f,%rax
 80000103d41:	08 00 00 
 80000103d44:	0f b6 38             	movzbl (%rax),%edi
 80000103d47:	c1 e7 08             	shl    $0x8,%edi
 80000103d4a:	48 8d 40 ff          	lea    -0x1(%rax),%rax
 80000103d4e:	0f b6 00             	movzbl (%rax),%eax
 80000103d51:	09 c7                	or     %eax,%edi
 80000103d53:	c1 e7 04             	shl    $0x4,%edi
 80000103d56:	48 63 ff             	movslq %edi,%rdi
 80000103d59:	48 85 ff             	test   %rdi,%rdi
 80000103d5c:	74 2e                	je     80000103d8c <mpsearch+0x56>
    if((mp = mpsearch1(p, 1024)))
 80000103d5e:	be 00 04 00 00       	mov    $0x400,%esi
 80000103d63:	48 b8 c1 3c 10 00 00 	movabs $0x80000103cc1,%rax
 80000103d6a:	08 00 00 
 80000103d6d:	ff d0                	call   *%rax
 80000103d6f:	48 85 c0             	test   %rax,%rax
 80000103d72:	75 16                	jne    80000103d8a <mpsearch+0x54>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
 80000103d74:	be 00 00 01 00       	mov    $0x10000,%esi
 80000103d79:	bf 00 00 0f 00       	mov    $0xf0000,%edi
 80000103d7e:	48 b8 c1 3c 10 00 00 	movabs $0x80000103cc1,%rax
 80000103d85:	08 00 00 
 80000103d88:	ff d0                	call   *%rax
}
 80000103d8a:	5d                   	pop    %rbp
 80000103d8b:	c3                   	ret
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
 80000103d8c:	48 b8 14 04 00 00 00 	movabs $0x80000000414,%rax
 80000103d93:	08 00 00 
 80000103d96:	0f b6 38             	movzbl (%rax),%edi
 80000103d99:	c1 e7 08             	shl    $0x8,%edi
 80000103d9c:	48 8d 40 ff          	lea    -0x1(%rax),%rax
 80000103da0:	0f b6 00             	movzbl (%rax),%eax
 80000103da3:	09 c7                	or     %eax,%edi
 80000103da5:	c1 e7 0a             	shl    $0xa,%edi
 80000103da8:	48 63 ff             	movslq %edi,%rdi
    if((mp = mpsearch1(p-1024, 1024)))
 80000103dab:	48 81 ef 00 04 00 00 	sub    $0x400,%rdi
 80000103db2:	be 00 04 00 00       	mov    $0x400,%esi
 80000103db7:	48 b8 c1 3c 10 00 00 	movabs $0x80000103cc1,%rax
 80000103dbe:	08 00 00 
 80000103dc1:	ff d0                	call   *%rax
 80000103dc3:	48 85 c0             	test   %rax,%rax
 80000103dc6:	75 c2                	jne    80000103d8a <mpsearch+0x54>
 80000103dc8:	eb aa                	jmp    80000103d74 <mpsearch+0x3e>

0000080000103dca <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
 80000103dca:	55                   	push   %rbp
 80000103dcb:	48 89 e5             	mov    %rsp,%rbp
 80000103dce:	41 56                	push   %r14
 80000103dd0:	41 55                	push   %r13
 80000103dd2:	41 54                	push   %r12
 80000103dd4:	53                   	push   %rbx
 80000103dd5:	49 89 fd             	mov    %rdi,%r13
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
 80000103dd8:	48 b8 36 3d 10 00 00 	movabs $0x80000103d36,%rax
 80000103ddf:	08 00 00 
 80000103de2:	ff d0                	call   *%rax
 80000103de4:	49 89 c4             	mov    %rax,%r12
 80000103de7:	48 85 c0             	test   %rax,%rax
 80000103dea:	74 7b                	je     80000103e67 <mpconfig+0x9d>
 80000103dec:	8b 58 04             	mov    0x4(%rax),%ebx
 80000103def:	85 db                	test   %ebx,%ebx
 80000103df1:	74 79                	je     80000103e6c <mpconfig+0xa2>
    return 0;
  conf = (struct mpconf*) P2V((uint64) mp->physaddr);
 80000103df3:	89 db                	mov    %ebx,%ebx
 80000103df5:	48 b8 00 00 00 00 00 	movabs $0x80000000000,%rax
 80000103dfc:	08 00 00 
 80000103dff:	48 01 c3             	add    %rax,%rbx
 80000103e02:	49 89 de             	mov    %rbx,%r14
  if(memcmp(conf, "PCMP", 4) != 0)
 80000103e05:	ba 04 00 00 00       	mov    $0x4,%edx
 80000103e0a:	48 be d4 ab 10 00 00 	movabs $0x8000010abd4,%rsi
 80000103e11:	08 00 00 
 80000103e14:	48 89 df             	mov    %rbx,%rdi
 80000103e17:	48 b8 3b 56 10 00 00 	movabs $0x8000010563b,%rax
 80000103e1e:	08 00 00 
 80000103e21:	ff d0                	call   *%rax
 80000103e23:	85 c0                	test   %eax,%eax
 80000103e25:	75 4d                	jne    80000103e74 <mpconfig+0xaa>
    return 0;
  if(conf->version != 1 && conf->version != 4)
 80000103e27:	0f b6 53 06          	movzbl 0x6(%rbx),%edx
 80000103e2b:	83 fa 01             	cmp    $0x1,%edx
 80000103e2e:	0f 95 c0             	setne  %al
 80000103e31:	83 fa 04             	cmp    $0x4,%edx
 80000103e34:	0f 95 c2             	setne  %dl
 80000103e37:	21 d0                	and    %edx,%eax
 80000103e39:	a8 ff                	test   $0xff,%al
 80000103e3b:	75 3f                	jne    80000103e7c <mpconfig+0xb2>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
 80000103e3d:	0f b7 73 04          	movzwl 0x4(%rbx),%esi
 80000103e41:	48 89 df             	mov    %rbx,%rdi
 80000103e44:	48 b8 a0 3c 10 00 00 	movabs $0x80000103ca0,%rax
 80000103e4b:	08 00 00 
 80000103e4e:	ff d0                	call   *%rax
 80000103e50:	0f b6 c0             	movzbl %al,%eax
 80000103e53:	85 c0                	test   %eax,%eax
 80000103e55:	75 2d                	jne    80000103e84 <mpconfig+0xba>
    return 0;
  *pmp = mp;
 80000103e57:	4d 89 65 00          	mov    %r12,0x0(%r13)
  return conf;
}
 80000103e5b:	4c 89 f0             	mov    %r14,%rax
 80000103e5e:	5b                   	pop    %rbx
 80000103e5f:	41 5c                	pop    %r12
 80000103e61:	41 5d                	pop    %r13
 80000103e63:	41 5e                	pop    %r14
 80000103e65:	5d                   	pop    %rbp
 80000103e66:	c3                   	ret
    return 0;
 80000103e67:	49 89 c6             	mov    %rax,%r14
 80000103e6a:	eb ef                	jmp    80000103e5b <mpconfig+0x91>
 80000103e6c:	41 be 00 00 00 00    	mov    $0x0,%r14d
 80000103e72:	eb e7                	jmp    80000103e5b <mpconfig+0x91>
    return 0;
 80000103e74:	41 be 00 00 00 00    	mov    $0x0,%r14d
 80000103e7a:	eb df                	jmp    80000103e5b <mpconfig+0x91>
    return 0;
 80000103e7c:	41 be 00 00 00 00    	mov    $0x0,%r14d
 80000103e82:	eb d7                	jmp    80000103e5b <mpconfig+0x91>
    return 0;
 80000103e84:	41 be 00 00 00 00    	mov    $0x0,%r14d
 80000103e8a:	eb cf                	jmp    80000103e5b <mpconfig+0x91>

0000080000103e8c <mpinit>:

void
mpinit(void)
{
 80000103e8c:	55                   	push   %rbp
 80000103e8d:	48 89 e5             	mov    %rsp,%rbp
 80000103e90:	53                   	push   %rbx
 80000103e91:	48 83 ec 18          	sub    $0x18,%rsp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if (acpiinit()) 
 80000103e95:	48 b8 17 90 10 00 00 	movabs $0x80000109017,%rax
 80000103e9c:	08 00 00 
 80000103e9f:	ff d0                	call   *%rax
 80000103ea1:	85 c0                	test   %eax,%eax
 80000103ea3:	74 07                	je     80000103eac <mpinit+0x20>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
 80000103ea5:	48 83 c4 18          	add    $0x18,%rsp
 80000103ea9:	5b                   	pop    %rbx
 80000103eaa:	5d                   	pop    %rbp
 80000103eab:	c3                   	ret
 80000103eac:	89 c3                	mov    %eax,%ebx
  if((conf = mpconfig(&mp)) == 0)
 80000103eae:	48 8d 7d e8          	lea    -0x18(%rbp),%rdi
 80000103eb2:	48 b8 ca 3d 10 00 00 	movabs $0x80000103dca,%rax
 80000103eb9:	08 00 00 
 80000103ebc:	ff d0                	call   *%rax
 80000103ebe:	48 89 c6             	mov    %rax,%rsi
 80000103ec1:	48 85 c0             	test   %rax,%rax
 80000103ec4:	74 2c                	je     80000103ef2 <mpinit+0x66>
  lapic = (uint*)DEV_P2V((uint64)conf->lapicaddr);
 80000103ec6:	8b 40 24             	mov    0x24(%rax),%eax
 80000103ec9:	48 ba 00 00 00 00 ff 	movabs $0xffffffff00000000,%rdx
 80000103ed0:	ff ff ff 
 80000103ed3:	48 01 d0             	add    %rdx,%rax
 80000103ed6:	48 a3 e0 9e 11 00 00 	movabs %rax,0x80000119ee0
 80000103edd:	08 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
 80000103ee0:	48 8d 56 2c          	lea    0x2c(%rsi),%rdx
 80000103ee4:	0f b7 46 04          	movzwl 0x4(%rsi),%eax
 80000103ee8:	48 01 c6             	add    %rax,%rsi
  ismp = 1;
 80000103eeb:	bf 01 00 00 00       	mov    $0x1,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
 80000103ef0:	eb 62                	jmp    80000103f54 <mpinit+0xc8>
    panic("Expect to run on an SMP");
 80000103ef2:	48 bf d9 ab 10 00 00 	movabs $0x8000010abd9,%rdi
 80000103ef9:	08 00 00 
 80000103efc:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000103f03:	08 00 00 
 80000103f06:	ff d0                	call   *%rax
    switch(*p){
 80000103f08:	83 e8 03             	sub    $0x3,%eax
 80000103f0b:	0f b6 c0             	movzbl %al,%eax
 80000103f0e:	83 f8 01             	cmp    $0x1,%eax
 80000103f11:	77 71                	ja     80000103f84 <mpinit+0xf8>
      p += 8;
 80000103f13:	48 83 c2 08          	add    $0x8,%rdx
      continue;
 80000103f17:	eb 3b                	jmp    80000103f54 <mpinit+0xc8>
      if(ncpu < NCPU) {
 80000103f19:	a1 04 a0 11 00 00 08 	movabs 0x8000011a004,%eax
 80000103f20:	00 00 
 80000103f22:	83 f8 07             	cmp    $0x7,%eax
 80000103f25:	7f 29                	jg     80000103f50 <mpinit+0xc4>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
 80000103f27:	44 8a 4a 01          	mov    0x1(%rdx),%r9b
 80000103f2b:	48 63 c8             	movslq %eax,%rcx
 80000103f2e:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
 80000103f32:	4c 8d 04 89          	lea    (%rcx,%rcx,4),%r8
 80000103f36:	48 b9 20 a0 11 00 00 	movabs $0x8000011a020,%rcx
 80000103f3d:	08 00 00 
 80000103f40:	46 88 0c c1          	mov    %r9b,(%rcx,%r8,8)
        ncpu++;
 80000103f44:	83 c0 01             	add    $0x1,%eax
 80000103f47:	a3 04 a0 11 00 00 08 	movabs %eax,0x8000011a004
 80000103f4e:	00 00 
      p += sizeof(struct mpproc);
 80000103f50:	48 83 c2 14          	add    $0x14,%rdx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
 80000103f54:	48 39 f2             	cmp    %rsi,%rdx
 80000103f57:	73 2f                	jae    80000103f88 <mpinit+0xfc>
    switch(*p){
 80000103f59:	8a 02                	mov    (%rdx),%al
 80000103f5b:	0f b6 c8             	movzbl %al,%ecx
 80000103f5e:	83 f9 02             	cmp    $0x2,%ecx
 80000103f61:	74 0f                	je     80000103f72 <mpinit+0xe6>
 80000103f63:	77 a3                	ja     80000103f08 <mpinit+0x7c>
 80000103f65:	85 c9                	test   %ecx,%ecx
 80000103f67:	74 b0                	je     80000103f19 <mpinit+0x8d>
 80000103f69:	83 f9 01             	cmp    $0x1,%ecx
 80000103f6c:	74 a5                	je     80000103f13 <mpinit+0x87>
 80000103f6e:	89 df                	mov    %ebx,%edi
 80000103f70:	eb e2                	jmp    80000103f54 <mpinit+0xc8>
      ioapicid = ioapic->apicno;
 80000103f72:	8a 42 01             	mov    0x1(%rdx),%al
 80000103f75:	a2 00 a0 11 00 00 08 	movabs %al,0x8000011a000
 80000103f7c:	00 00 
      p += sizeof(struct mpioapic);
 80000103f7e:	48 83 c2 08          	add    $0x8,%rdx
      continue;
 80000103f82:	eb d0                	jmp    80000103f54 <mpinit+0xc8>
    switch(*p){
 80000103f84:	89 df                	mov    %ebx,%edi
 80000103f86:	eb cc                	jmp    80000103f54 <mpinit+0xc8>
  if(!ismp)
 80000103f88:	85 ff                	test   %edi,%edi
 80000103f8a:	74 27                	je     80000103fb3 <mpinit+0x127>
  if(mp->imcrp){
 80000103f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
 80000103f90:	0f b6 40 0c          	movzbl 0xc(%rax),%eax
 80000103f94:	85 c0                	test   %eax,%eax
 80000103f96:	0f 84 09 ff ff ff    	je     80000103ea5 <mpinit+0x19>
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 80000103f9c:	b0 70                	mov    $0x70,%al
 80000103f9e:	ba 22 00 00 00       	mov    $0x22,%edx
 80000103fa3:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0" : "=a" (data) : "d" (port));
 80000103fa4:	ba 23 00 00 00       	mov    $0x23,%edx
 80000103fa9:	ec                   	in     (%dx),%al
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
 80000103faa:	83 c8 01             	or     $0x1,%eax
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 80000103fad:	ee                   	out    %al,(%dx)
}
 80000103fae:	e9 f2 fe ff ff       	jmp    80000103ea5 <mpinit+0x19>
    panic("Didn't find a suitable machine");
 80000103fb3:	48 bf b8 af 10 00 00 	movabs $0x8000010afb8,%rdi
 80000103fba:	08 00 00 
 80000103fbd:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000103fc4:	08 00 00 
 80000103fc7:	ff d0                	call   *%rax

0000080000103fc9 <picinit>:
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 80000103fc9:	b0 ff                	mov    $0xff,%al
 80000103fcb:	ba 21 00 00 00       	mov    $0x21,%edx
 80000103fd0:	ee                   	out    %al,(%dx)
 80000103fd1:	ba a1 00 00 00       	mov    $0xa1,%edx
 80000103fd6:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
 80000103fd7:	c3                   	ret
 80000103fd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 80000103fdf:	00 00 00 
 80000103fe2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 80000103fe9:	00 00 00 
 80000103fec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 80000103ff3:	00 00 00 
 80000103ff6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 80000103ffd:	00 00 00 

0000080000104000 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
 80000104000:	55                   	push   %rbp
 80000104001:	48 89 e5             	mov    %rsp,%rbp
 80000104004:	41 55                	push   %r13
 80000104006:	41 54                	push   %r12
 80000104008:	53                   	push   %rbx
 80000104009:	48 83 ec 08          	sub    $0x8,%rsp
 8000010400d:	48 89 fb             	mov    %rdi,%rbx
 80000104010:	49 89 f4             	mov    %rsi,%r12
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
 80000104013:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
 8000010401a:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
 80000104021:	48 b8 1d 12 10 00 00 	movabs $0x8000010121d,%rax
 80000104028:	08 00 00 
 8000010402b:	ff d0                	call   *%rax
 8000010402d:	48 89 03             	mov    %rax,(%rbx)
 80000104030:	48 85 c0             	test   %rax,%rax
 80000104033:	0f 84 b9 00 00 00    	je     800001040f2 <pipealloc+0xf2>
 80000104039:	48 b8 1d 12 10 00 00 	movabs $0x8000010121d,%rax
 80000104040:	08 00 00 
 80000104043:	ff d0                	call   *%rax
 80000104045:	49 89 04 24          	mov    %rax,(%r12)
 80000104049:	48 85 c0             	test   %rax,%rax
 8000010404c:	0f 84 a0 00 00 00    	je     800001040f2 <pipealloc+0xf2>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
 80000104052:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000104059:	08 00 00 
 8000010405c:	ff d0                	call   *%rax
 8000010405e:	49 89 c5             	mov    %rax,%r13
 80000104061:	48 85 c0             	test   %rax,%rax
 80000104064:	0f 84 88 00 00 00    	je     800001040f2 <pipealloc+0xf2>
    goto bad;
  p->readopen = 1;
 8000010406a:	c7 80 70 02 00 00 01 	movl   $0x1,0x270(%rax)
 80000104071:	00 00 00 
  p->writeopen = 1;
 80000104074:	c7 80 74 02 00 00 01 	movl   $0x1,0x274(%rax)
 8000010407b:	00 00 00 
  p->nwrite = 0;
 8000010407e:	c7 80 6c 02 00 00 00 	movl   $0x0,0x26c(%rax)
 80000104085:	00 00 00 
  p->nread = 0;
 80000104088:	c7 80 68 02 00 00 00 	movl   $0x0,0x268(%rax)
 8000010408f:	00 00 00 
  initlock(&p->lock, "pipe");
 80000104092:	48 be f1 ab 10 00 00 	movabs $0x8000010abf1,%rsi
 80000104099:	08 00 00 
 8000010409c:	48 89 c7             	mov    %rax,%rdi
 8000010409f:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 800001040a6:	08 00 00 
 800001040a9:	ff d0                	call   *%rax
  (*f0)->type = FD_PIPE;
 800001040ab:	48 8b 03             	mov    (%rbx),%rax
 800001040ae:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f0)->readable = 1;
 800001040b4:	48 8b 03             	mov    (%rbx),%rax
 800001040b7:	c6 40 08 01          	movb   $0x1,0x8(%rax)
  (*f0)->writable = 0;
 800001040bb:	48 8b 03             	mov    (%rbx),%rax
 800001040be:	c6 40 09 00          	movb   $0x0,0x9(%rax)
  (*f0)->pipe = p;
 800001040c2:	48 8b 03             	mov    (%rbx),%rax
 800001040c5:	4c 89 68 10          	mov    %r13,0x10(%rax)
  (*f1)->type = FD_PIPE;
 800001040c9:	49 8b 04 24          	mov    (%r12),%rax
 800001040cd:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f1)->readable = 0;
 800001040d3:	49 8b 04 24          	mov    (%r12),%rax
 800001040d7:	c6 40 08 00          	movb   $0x0,0x8(%rax)
  (*f1)->writable = 1;
 800001040db:	49 8b 04 24          	mov    (%r12),%rax
 800001040df:	c6 40 09 01          	movb   $0x1,0x9(%rax)
  (*f1)->pipe = p;
 800001040e3:	49 8b 04 24          	mov    (%r12),%rax
 800001040e7:	4c 89 68 10          	mov    %r13,0x10(%rax)
  return 0;
 800001040eb:	b8 00 00 00 00       	mov    $0x0,%eax
 800001040f0:	eb 2e                	jmp    80000104120 <pipealloc+0x120>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
 800001040f2:	48 8b 3b             	mov    (%rbx),%rdi
 800001040f5:	48 85 ff             	test   %rdi,%rdi
 800001040f8:	74 0c                	je     80000104106 <pipealloc+0x106>
    fileclose(*f0);
 800001040fa:	48 b8 07 13 10 00 00 	movabs $0x80000101307,%rax
 80000104101:	08 00 00 
 80000104104:	ff d0                	call   *%rax
  if(*f1)
 80000104106:	49 8b 3c 24          	mov    (%r12),%rdi
 8000010410a:	48 85 ff             	test   %rdi,%rdi
 8000010410d:	74 1c                	je     8000010412b <pipealloc+0x12b>
    fileclose(*f1);
 8000010410f:	48 b8 07 13 10 00 00 	movabs $0x80000101307,%rax
 80000104116:	08 00 00 
 80000104119:	ff d0                	call   *%rax
  return -1;
 8000010411b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 80000104120:	48 83 c4 08          	add    $0x8,%rsp
 80000104124:	5b                   	pop    %rbx
 80000104125:	41 5c                	pop    %r12
 80000104127:	41 5d                	pop    %r13
 80000104129:	5d                   	pop    %rbp
 8000010412a:	c3                   	ret
  return -1;
 8000010412b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000104130:	eb ee                	jmp    80000104120 <pipealloc+0x120>

0000080000104132 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
 80000104132:	55                   	push   %rbp
 80000104133:	48 89 e5             	mov    %rsp,%rbp
 80000104136:	41 54                	push   %r12
 80000104138:	53                   	push   %rbx
 80000104139:	48 89 fb             	mov    %rdi,%rbx
 8000010413c:	41 89 f4             	mov    %esi,%r12d
  acquire(&p->lock);
 8000010413f:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000104146:	08 00 00 
 80000104149:	ff d0                	call   *%rax
  if(writable){
 8000010414b:	45 85 e4             	test   %r12d,%r12d
 8000010414e:	74 4a                	je     8000010419a <pipeclose+0x68>
    p->writeopen = 0;
 80000104150:	c7 83 74 02 00 00 00 	movl   $0x0,0x274(%rbx)
 80000104157:	00 00 00 
    wakeup(&p->nread);
 8000010415a:	48 8d bb 68 02 00 00 	lea    0x268(%rbx),%rdi
 80000104161:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 80000104168:	08 00 00 
 8000010416b:	ff d0                	call   *%rax
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
 8000010416d:	48 83 bb 70 02 00 00 	cmpq   $0x0,0x270(%rbx)
 80000104174:	00 
 80000104175:	75 42                	jne    800001041b9 <pipeclose+0x87>
    release(&p->lock);
 80000104177:	48 89 df             	mov    %rbx,%rdi
 8000010417a:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000104181:	08 00 00 
 80000104184:	ff d0                	call   *%rax
    kfree((char*)p);
 80000104186:	48 89 df             	mov    %rbx,%rdi
 80000104189:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 80000104190:	08 00 00 
 80000104193:	ff d0                	call   *%rax
  } else
    release(&p->lock);
}
 80000104195:	5b                   	pop    %rbx
 80000104196:	41 5c                	pop    %r12
 80000104198:	5d                   	pop    %rbp
 80000104199:	c3                   	ret
    p->readopen = 0;
 8000010419a:	c7 83 70 02 00 00 00 	movl   $0x0,0x270(%rbx)
 800001041a1:	00 00 00 
    wakeup(&p->nwrite);
 800001041a4:	48 8d bb 6c 02 00 00 	lea    0x26c(%rbx),%rdi
 800001041ab:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 800001041b2:	08 00 00 
 800001041b5:	ff d0                	call   *%rax
 800001041b7:	eb b4                	jmp    8000010416d <pipeclose+0x3b>
    release(&p->lock);
 800001041b9:	48 89 df             	mov    %rbx,%rdi
 800001041bc:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001041c3:	08 00 00 
 800001041c6:	ff d0                	call   *%rax
}
 800001041c8:	eb cb                	jmp    80000104195 <pipeclose+0x63>

00000800001041ca <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
 800001041ca:	55                   	push   %rbp
 800001041cb:	48 89 e5             	mov    %rsp,%rbp
 800001041ce:	41 56                	push   %r14
 800001041d0:	41 55                	push   %r13
 800001041d2:	41 54                	push   %r12
 800001041d4:	53                   	push   %rbx
 800001041d5:	48 89 fb             	mov    %rdi,%rbx
 800001041d8:	49 89 f6             	mov    %rsi,%r14
 800001041db:	41 89 d4             	mov    %edx,%r12d
  int i;

  acquire(&p->lock);
 800001041de:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 800001041e5:	08 00 00 
 800001041e8:	ff d0                	call   *%rax
  for(i = 0; i < n; i++){
 800001041ea:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 800001041f0:	45 39 e5             	cmp    %r12d,%r13d
 800001041f3:	7c 50                	jl     80000104245 <pipewrite+0x7b>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
 800001041f5:	48 8d bb 68 02 00 00 	lea    0x268(%rbx),%rdi
 800001041fc:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 80000104203:	08 00 00 
 80000104206:	ff d0                	call   *%rax
  release(&p->lock);
 80000104208:	48 89 df             	mov    %rbx,%rdi
 8000010420b:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000104212:	08 00 00 
 80000104215:	ff d0                	call   *%rax
  return n;
 80000104217:	44 89 e0             	mov    %r12d,%eax
 8000010421a:	eb 6f                	jmp    8000010428b <pipewrite+0xc1>
      wakeup(&p->nread);
 8000010421c:	48 8d bb 68 02 00 00 	lea    0x268(%rbx),%rdi
 80000104223:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 8000010422a:	08 00 00 
 8000010422d:	ff d0                	call   *%rax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
 8000010422f:	48 8d bb 6c 02 00 00 	lea    0x26c(%rbx),%rdi
 80000104236:	48 89 de             	mov    %rbx,%rsi
 80000104239:	48 b8 03 4e 10 00 00 	movabs $0x80000104e03,%rax
 80000104240:	08 00 00 
 80000104243:	ff d0                	call   *%rax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
 80000104245:	8b 93 6c 02 00 00    	mov    0x26c(%rbx),%edx
 8000010424b:	8b 83 68 02 00 00    	mov    0x268(%rbx),%eax
 80000104251:	05 00 02 00 00       	add    $0x200,%eax
 80000104256:	39 c2                	cmp    %eax,%edx
 80000104258:	75 3a                	jne    80000104294 <pipewrite+0xca>
      if(p->readopen == 0 || myproc()->killed){
 8000010425a:	83 bb 70 02 00 00 00 	cmpl   $0x0,0x270(%rbx)
 80000104261:	74 14                	je     80000104277 <pipewrite+0xad>
 80000104263:	b0 00                	mov    $0x0,%al
 80000104265:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 8000010426c:	08 00 00 
 8000010426f:	ff d2                	call   *%rdx
 80000104271:	83 78 40 00          	cmpl   $0x0,0x40(%rax)
 80000104275:	74 a5                	je     8000010421c <pipewrite+0x52>
        release(&p->lock);
 80000104277:	48 89 df             	mov    %rbx,%rdi
 8000010427a:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000104281:	08 00 00 
 80000104284:	ff d0                	call   *%rax
        return -1;
 80000104286:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 8000010428b:	5b                   	pop    %rbx
 8000010428c:	41 5c                	pop    %r12
 8000010428e:	41 5d                	pop    %r13
 80000104290:	41 5e                	pop    %r14
 80000104292:	5d                   	pop    %rbp
 80000104293:	c3                   	ret
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
 80000104294:	8d 42 01             	lea    0x1(%rdx),%eax
 80000104297:	89 83 6c 02 00 00    	mov    %eax,0x26c(%rbx)
 8000010429d:	49 63 c5             	movslq %r13d,%rax
 800001042a0:	41 8a 04 06          	mov    (%r14,%rax,1),%al
 800001042a4:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
 800001042aa:	88 44 13 68          	mov    %al,0x68(%rbx,%rdx,1)
  for(i = 0; i < n; i++){
 800001042ae:	41 83 c5 01          	add    $0x1,%r13d
 800001042b2:	e9 39 ff ff ff       	jmp    800001041f0 <pipewrite+0x26>

00000800001042b7 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
 800001042b7:	55                   	push   %rbp
 800001042b8:	48 89 e5             	mov    %rsp,%rbp
 800001042bb:	41 56                	push   %r14
 800001042bd:	41 55                	push   %r13
 800001042bf:	41 54                	push   %r12
 800001042c1:	53                   	push   %rbx
 800001042c2:	48 89 fb             	mov    %rdi,%rbx
 800001042c5:	49 89 f6             	mov    %rsi,%r14
 800001042c8:	41 89 d5             	mov    %edx,%r13d
  int i;

  acquire(&p->lock);
 800001042cb:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 800001042d2:	08 00 00 
 800001042d5:	ff d0                	call   *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
 800001042d7:	eb 16                	jmp    800001042ef <piperead+0x38>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
 800001042d9:	48 8d bb 68 02 00 00 	lea    0x268(%rbx),%rdi
 800001042e0:	48 89 de             	mov    %rbx,%rsi
 800001042e3:	48 b8 03 4e 10 00 00 	movabs $0x80000104e03,%rax
 800001042ea:	08 00 00 
 800001042ed:	ff d0                	call   *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
 800001042ef:	8b 83 6c 02 00 00    	mov    0x26c(%rbx),%eax
 800001042f5:	39 83 68 02 00 00    	cmp    %eax,0x268(%rbx)
 800001042fb:	0f 85 9d 00 00 00    	jne    8000010439e <piperead+0xe7>
 80000104301:	44 8b a3 74 02 00 00 	mov    0x274(%rbx),%r12d
 80000104308:	45 85 e4             	test   %r12d,%r12d
 8000010430b:	74 50                	je     8000010435d <piperead+0xa6>
    if(myproc()->killed){
 8000010430d:	b0 00                	mov    $0x0,%al
 8000010430f:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000104316:	08 00 00 
 80000104319:	ff d2                	call   *%rdx
 8000010431b:	83 78 40 00          	cmpl   $0x0,0x40(%rax)
 8000010431f:	74 b8                	je     800001042d9 <piperead+0x22>
      release(&p->lock);
 80000104321:	48 89 df             	mov    %rbx,%rdi
 80000104324:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 8000010432b:	08 00 00 
 8000010432e:	ff d0                	call   *%rax
      return -1;
 80000104330:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 80000104336:	eb 5a                	jmp    80000104392 <piperead+0xdb>
 80000104338:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 8000010433f:	00 
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
 80000104340:	8d 50 01             	lea    0x1(%rax),%edx
 80000104343:	89 93 68 02 00 00    	mov    %edx,0x268(%rbx)
 80000104349:	49 63 d4             	movslq %r12d,%rdx
 8000010434c:	25 ff 01 00 00       	and    $0x1ff,%eax
 80000104351:	8a 44 03 68          	mov    0x68(%rbx,%rax,1),%al
 80000104355:	41 88 04 16          	mov    %al,(%r14,%rdx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
 80000104359:	41 83 c4 01          	add    $0x1,%r12d
 8000010435d:	45 39 ec             	cmp    %r13d,%r12d
 80000104360:	7d 0e                	jge    80000104370 <piperead+0xb9>
    if(p->nread == p->nwrite)
 80000104362:	8b 83 68 02 00 00    	mov    0x268(%rbx),%eax
 80000104368:	3b 83 6c 02 00 00    	cmp    0x26c(%rbx),%eax
 8000010436e:	75 d0                	jne    80000104340 <piperead+0x89>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
 80000104370:	48 8d bb 6c 02 00 00 	lea    0x26c(%rbx),%rdi
 80000104377:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 8000010437e:	08 00 00 
 80000104381:	ff d0                	call   *%rax
  release(&p->lock);
 80000104383:	48 89 df             	mov    %rbx,%rdi
 80000104386:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 8000010438d:	08 00 00 
 80000104390:	ff d0                	call   *%rax
  return i;
}
 80000104392:	44 89 e0             	mov    %r12d,%eax
 80000104395:	5b                   	pop    %rbx
 80000104396:	41 5c                	pop    %r12
 80000104398:	41 5d                	pop    %r13
 8000010439a:	41 5e                	pop    %r14
 8000010439c:	5d                   	pop    %rbp
 8000010439d:	c3                   	ret
 8000010439e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 800001043a4:	eb b7                	jmp    8000010435d <piperead+0xa6>
 800001043a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001043ad:	00 00 00 
 800001043b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001043b7:	00 00 00 
 800001043ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000800001043c0 <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
 800001043c0:	48 b8 c8 a6 11 00 00 	movabs $0x8000011a6c8,%rax
 800001043c7:	08 00 00 
 800001043ca:	eb 1a                	jmp    800001043e6 <wakeup1+0x26>
 800001043cc:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 800001043d3:	00 00 00 00 
 800001043d7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 800001043de:	00 00 
 800001043e0:	48 05 e0 00 00 00    	add    $0xe0,%rax
 800001043e6:	48 ba c8 de 11 00 00 	movabs $0x8000011dec8,%rdx
 800001043ed:	08 00 00 
 800001043f0:	48 39 d0             	cmp    %rdx,%rax
 800001043f3:	73 15                	jae    8000010440a <wakeup1+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
 800001043f5:	83 78 18 02          	cmpl   $0x2,0x18(%rax)
 800001043f9:	75 e5                	jne    800001043e0 <wakeup1+0x20>
 800001043fb:	48 39 78 38          	cmp    %rdi,0x38(%rax)
 800001043ff:	75 df                	jne    800001043e0 <wakeup1+0x20>
      p->state = RUNNABLE;
 80000104401:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
 80000104408:	eb d6                	jmp    800001043e0 <wakeup1+0x20>
}
 8000010440a:	c3                   	ret

000008000010440b <allocproc>:
{
 8000010440b:	55                   	push   %rbp
 8000010440c:	48 89 e5             	mov    %rsp,%rbp
 8000010440f:	53                   	push   %rbx
 80000104410:	48 83 ec 08          	sub    $0x8,%rsp
  acquire(&ptable.lock);
 80000104414:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 8000010441b:	08 00 00 
 8000010441e:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000104425:	08 00 00 
 80000104428:	ff d0                	call   *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
 8000010442a:	48 bb c8 a6 11 00 00 	movabs $0x8000011a6c8,%rbx
 80000104431:	08 00 00 
 80000104434:	eb 11                	jmp    80000104447 <allocproc+0x3c>
 80000104436:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 8000010443d:	00 00 00 
 80000104440:	48 81 c3 e0 00 00 00 	add    $0xe0,%rbx
 80000104447:	48 b8 c8 de 11 00 00 	movabs $0x8000011dec8,%rax
 8000010444e:	08 00 00 
 80000104451:	48 39 c3             	cmp    %rax,%rbx
 80000104454:	0f 83 a5 00 00 00    	jae    800001044ff <allocproc+0xf4>
    if(p->state == UNUSED)
 8000010445a:	83 7b 18 00          	cmpl   $0x0,0x18(%rbx)
 8000010445e:	75 e0                	jne    80000104440 <allocproc+0x35>
  p->state = EMBRYO;
 80000104460:	c7 43 18 01 00 00 00 	movl   $0x1,0x18(%rbx)
  p->pid = nextpid++;
 80000104467:	48 ba 04 00 11 00 00 	movabs $0x80000110004,%rdx
 8000010446e:	08 00 00 
 80000104471:	8b 02                	mov    (%rdx),%eax
 80000104473:	8d 48 01             	lea    0x1(%rax),%ecx
 80000104476:	89 0a                	mov    %ecx,(%rdx)
 80000104478:	89 43 1c             	mov    %eax,0x1c(%rbx)
  release(&ptable.lock);
 8000010447b:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 80000104482:	08 00 00 
 80000104485:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 8000010448c:	08 00 00 
 8000010448f:	ff d0                	call   *%rax
  if((p->kstack = kalloc()) == 0){
 80000104491:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000104498:	08 00 00 
 8000010449b:	ff d0                	call   *%rax
 8000010449d:	48 89 43 10          	mov    %rax,0x10(%rbx)
 800001044a1:	48 85 c0             	test   %rax,%rax
 800001044a4:	74 73                	je     80000104519 <allocproc+0x10e>
  sp -= sizeof *p->tf;
 800001044a6:	48 8d 90 50 0f 00 00 	lea    0xf50(%rax),%rdx
  p->tf = (struct trapframe*)sp;
 800001044ad:	48 89 53 28          	mov    %rdx,0x28(%rbx)
  *(uint64*)sp = (uint64)trapret;
 800001044b1:	48 be 2e 6d 10 00 00 	movabs $0x80000106d2e,%rsi
 800001044b8:	08 00 00 
 800001044bb:	48 89 b0 48 0f 00 00 	mov    %rsi,0xf48(%rax)
  sp -= sizeof *p->context;
 800001044c2:	48 8d b8 10 0f 00 00 	lea    0xf10(%rax),%rdi
  p->context = (struct context*)sp;
 800001044c9:	48 89 7b 30          	mov    %rdi,0x30(%rbx)
  memset(p->context, 0, sizeof *p->context);
 800001044cd:	ba 38 00 00 00       	mov    $0x38,%edx
 800001044d2:	be 00 00 00 00       	mov    $0x0,%esi
 800001044d7:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 800001044de:	08 00 00 
 800001044e1:	ff d0                	call   *%rax
  p->context->rip = (uint64)forkret;
 800001044e3:	48 8b 43 30          	mov    0x30(%rbx),%rax
 800001044e7:	48 b9 25 45 10 00 00 	movabs $0x80000104525,%rcx
 800001044ee:	08 00 00 
 800001044f1:	48 89 48 30          	mov    %rcx,0x30(%rax)
}
 800001044f5:	48 89 d8             	mov    %rbx,%rax
 800001044f8:	48 83 c4 08          	add    $0x8,%rsp
 800001044fc:	5b                   	pop    %rbx
 800001044fd:	5d                   	pop    %rbp
 800001044fe:	c3                   	ret
  release(&ptable.lock);
 800001044ff:	48 8d b8 98 c7 ff ff 	lea    -0x3868(%rax),%rdi
 80000104506:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 8000010450d:	08 00 00 
 80000104510:	ff d0                	call   *%rax
  return 0;
 80000104512:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000104517:	eb dc                	jmp    800001044f5 <allocproc+0xea>
    p->state = UNUSED;
 80000104519:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%rbx)
    return 0;
 80000104520:	48 89 c3             	mov    %rax,%rbx
 80000104523:	eb d0                	jmp    800001044f5 <allocproc+0xea>

0000080000104525 <forkret>:
{
 80000104525:	55                   	push   %rbp
 80000104526:	48 89 e5             	mov    %rsp,%rbp
  release(&ptable.lock);
 80000104529:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 80000104530:	08 00 00 
 80000104533:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 8000010453a:	08 00 00 
 8000010453d:	ff d0                	call   *%rax
  if (first) {
 8000010453f:	a1 00 00 11 00 00 08 	movabs 0x80000110000,%eax
 80000104546:	00 00 
 80000104548:	85 c0                	test   %eax,%eax
 8000010454a:	75 02                	jne    8000010454e <forkret+0x29>
}
 8000010454c:	5d                   	pop    %rbp
 8000010454d:	c3                   	ret
    first = 0;
 8000010454e:	48 b8 00 00 11 00 00 	movabs $0x80000110000,%rax
 80000104555:	08 00 00 
 80000104558:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    iinit(ROOTDEV);
 8000010455e:	bf 01 00 00 00       	mov    $0x1,%edi
 80000104563:	48 b8 52 1b 10 00 00 	movabs $0x80000101b52,%rax
 8000010456a:	08 00 00 
 8000010456d:	ff d0                	call   *%rax
    initlog(ROOTDEV);
 8000010456f:	bf 01 00 00 00       	mov    $0x1,%edi
 80000104574:	48 b8 09 37 10 00 00 	movabs $0x80000103709,%rax
 8000010457b:	08 00 00 
 8000010457e:	ff d0                	call   *%rax
}
 80000104580:	eb ca                	jmp    8000010454c <forkret+0x27>

0000080000104582 <pinit>:
{
 80000104582:	55                   	push   %rbp
 80000104583:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ptable.lock, "ptable");
 80000104586:	48 be f6 ab 10 00 00 	movabs $0x8000010abf6,%rsi
 8000010458d:	08 00 00 
 80000104590:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 80000104597:	08 00 00 
 8000010459a:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 800001045a1:	08 00 00 
 800001045a4:	ff d0                	call   *%rax
}
 800001045a6:	5d                   	pop    %rbp
 800001045a7:	c3                   	ret

00000800001045a8 <mycpu>:
{
 800001045a8:	55                   	push   %rbp
 800001045a9:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("pushfq; popq %0" : "=r" (rflags));
 800001045ac:	9c                   	pushf
 800001045ad:	58                   	pop    %rax
  if(readrflags()&FL_IF)
 800001045ae:	f6 c4 02             	test   $0x2,%ah
 800001045b1:	75 41                	jne    800001045f4 <mycpu+0x4c>
  apicid = lapicid();
 800001045b3:	48 b8 a4 31 10 00 00 	movabs $0x800001031a4,%rax
 800001045ba:	08 00 00 
 800001045bd:	ff d0                	call   *%rax
  for (i = 0; i < ncpu; ++i) {
 800001045bf:	ba 00 00 00 00       	mov    $0x0,%edx
 800001045c4:	48 b9 04 a0 11 00 00 	movabs $0x8000011a004,%rcx
 800001045cb:	08 00 00 
 800001045ce:	39 11                	cmp    %edx,(%rcx)
 800001045d0:	7e 38                	jle    8000010460a <mycpu+0x62>
    if (cpus[i].apicid == apicid)
 800001045d2:	48 63 ca             	movslq %edx,%rcx
 800001045d5:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
 800001045d9:	48 8d 34 89          	lea    (%rcx,%rcx,4),%rsi
 800001045dd:	48 b9 20 a0 11 00 00 	movabs $0x8000011a020,%rcx
 800001045e4:	08 00 00 
 800001045e7:	0f b6 0c f1          	movzbl (%rcx,%rsi,8),%ecx
 800001045eb:	39 c1                	cmp    %eax,%ecx
 800001045ed:	74 31                	je     80000104620 <mycpu+0x78>
  for (i = 0; i < ncpu; ++i) {
 800001045ef:	83 c2 01             	add    $0x1,%edx
 800001045f2:	eb d0                	jmp    800001045c4 <mycpu+0x1c>
    panic("mycpu called with interrupts enabled\n");
 800001045f4:	48 bf d8 af 10 00 00 	movabs $0x8000010afd8,%rdi
 800001045fb:	08 00 00 
 800001045fe:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000104605:	08 00 00 
 80000104608:	ff d0                	call   *%rax
  panic("unknown apicid\n");
 8000010460a:	48 bf fd ab 10 00 00 	movabs $0x8000010abfd,%rdi
 80000104611:	08 00 00 
 80000104614:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 8000010461b:	08 00 00 
 8000010461e:	ff d0                	call   *%rax
      return &cpus[i];
 80000104620:	48 63 d2             	movslq %edx,%rdx
 80000104623:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
 80000104627:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
 8000010462b:	48 b8 20 a0 11 00 00 	movabs $0x8000011a020,%rax
 80000104632:	08 00 00 
 80000104635:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
}
 80000104639:	5d                   	pop    %rbp
 8000010463a:	c3                   	ret

000008000010463b <cpuid>:
cpuid() {
 8000010463b:	55                   	push   %rbp
 8000010463c:	48 89 e5             	mov    %rsp,%rbp
  return mycpu()-cpus;
 8000010463f:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000104646:	08 00 00 
 80000104649:	ff d0                	call   *%rax
 8000010464b:	48 ba 20 a0 11 00 00 	movabs $0x8000011a020,%rdx
 80000104652:	08 00 00 
 80000104655:	48 29 d0             	sub    %rdx,%rax
 80000104658:	48 c1 f8 03          	sar    $0x3,%rax
 8000010465c:	69 c0 29 5c 8f c2    	imul   $0xc28f5c29,%eax,%eax
}
 80000104662:	5d                   	pop    %rbp
 80000104663:	c3                   	ret

0000080000104664 <myproc>:
myproc(void) {
 80000104664:	55                   	push   %rbp
 80000104665:	48 89 e5             	mov    %rsp,%rbp
 80000104668:	53                   	push   %rbx
 80000104669:	48 83 ec 08          	sub    $0x8,%rsp
  pushcli();
 8000010466d:	48 b8 d4 53 10 00 00 	movabs $0x800001053d4,%rax
 80000104674:	08 00 00 
 80000104677:	ff d0                	call   *%rax
  c = mycpu();
 80000104679:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000104680:	08 00 00 
 80000104683:	ff d0                	call   *%rax
  p = c->proc;
 80000104685:	48 8b 98 c0 00 00 00 	mov    0xc0(%rax),%rbx
  popcli();
 8000010468c:	48 b8 31 54 10 00 00 	movabs $0x80000105431,%rax
 80000104693:	08 00 00 
 80000104696:	ff d0                	call   *%rax
}
 80000104698:	48 89 d8             	mov    %rbx,%rax
 8000010469b:	48 83 c4 08          	add    $0x8,%rsp
 8000010469f:	5b                   	pop    %rbx
 800001046a0:	5d                   	pop    %rbp
 800001046a1:	c3                   	ret

00000800001046a2 <userinit>:
{
 800001046a2:	55                   	push   %rbp
 800001046a3:	48 89 e5             	mov    %rsp,%rbp
 800001046a6:	41 54                	push   %r12
 800001046a8:	53                   	push   %rbx
  p = allocproc();
 800001046a9:	48 b8 0b 44 10 00 00 	movabs $0x8000010440b,%rax
 800001046b0:	08 00 00 
 800001046b3:	ff d0                	call   *%rax
 800001046b5:	48 89 c3             	mov    %rax,%rbx
  initproc = p;
 800001046b8:	48 a3 c8 de 11 00 00 	movabs %rax,0x8000011dec8
 800001046bf:	08 00 00 
  if((p->pml4 = setupkvm()) == 0)
 800001046c2:	48 b8 d3 8a 10 00 00 	movabs $0x80000108ad3,%rax
 800001046c9:	08 00 00 
 800001046cc:	ff d0                	call   *%rax
 800001046ce:	48 89 43 08          	mov    %rax,0x8(%rbx)
 800001046d2:	48 85 c0             	test   %rax,%rax
 800001046d5:	0f 84 fe 00 00 00    	je     800001047d9 <userinit+0x137>
 800001046db:	48 89 c7             	mov    %rax,%rdi
  inituvm(p->pml4, _binary_initcode_start, (uint64)_binary_initcode_size);
 800001046de:	48 ba 40 00 00 00 00 	movabs $0x40,%rdx
 800001046e5:	00 00 00 
 800001046e8:	48 be 48 0c 11 00 00 	movabs $0x80000110c48,%rsi
 800001046ef:	08 00 00 
 800001046f2:	48 b8 2d 86 10 00 00 	movabs $0x8000010862d,%rax
 800001046f9:	08 00 00 
 800001046fc:	ff d0                	call   *%rax
  p->sz = PGSIZE;
 800001046fe:	48 c7 03 00 10 00 00 	movq   $0x1000,(%rbx)
  memset(p->tf, 0, sizeof(*p->tf));
 80000104705:	48 8b 7b 28          	mov    0x28(%rbx),%rdi
 80000104709:	ba b0 00 00 00       	mov    $0xb0,%edx
 8000010470e:	be 00 00 00 00       	mov    $0x0,%esi
 80000104713:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 8000010471a:	08 00 00 
 8000010471d:	ff d0                	call   *%rax
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
 8000010471f:	48 8b 43 28          	mov    0x28(%rbx),%rax
 80000104723:	66 c7 80 90 00 00 00 	movw   $0x1b,0x90(%rax)
 8000010472a:	1b 00 
  p->tf->ss = (SEG_UDATA << 3) | DPL_USER;
 8000010472c:	48 8b 43 28          	mov    0x28(%rbx),%rax
 80000104730:	66 c7 80 a8 00 00 00 	movw   $0x23,0xa8(%rax)
 80000104737:	23 00 
  p->tf->rflags = FL_IF;
 80000104739:	48 8b 43 28          	mov    0x28(%rbx),%rax
 8000010473d:	48 c7 80 98 00 00 00 	movq   $0x200,0x98(%rax)
 80000104744:	00 02 00 00 
  p->tf->rsp = PGSIZE;
 80000104748:	48 8b 43 28          	mov    0x28(%rbx),%rax
 8000010474c:	48 c7 80 a0 00 00 00 	movq   $0x1000,0xa0(%rax)
 80000104753:	00 10 00 00 
  p->tf->rip = 0;  // beginning of initcode.S
 80000104757:	48 8b 43 28          	mov    0x28(%rbx),%rax
 8000010475b:	48 c7 80 88 00 00 00 	movq   $0x0,0x88(%rax)
 80000104762:	00 00 00 00 
  safestrcpy(p->name, "initcode", sizeof(p->name));
 80000104766:	48 8d bb d0 00 00 00 	lea    0xd0(%rbx),%rdi
 8000010476d:	ba 10 00 00 00       	mov    $0x10,%edx
 80000104772:	48 be 26 ac 10 00 00 	movabs $0x8000010ac26,%rsi
 80000104779:	08 00 00 
 8000010477c:	48 b8 93 57 10 00 00 	movabs $0x80000105793,%rax
 80000104783:	08 00 00 
 80000104786:	ff d0                	call   *%rax
  p->cwd = namei("/");
 80000104788:	48 bf 2f ac 10 00 00 	movabs $0x8000010ac2f,%rdi
 8000010478f:	08 00 00 
 80000104792:	48 b8 c3 27 10 00 00 	movabs $0x800001027c3,%rax
 80000104799:	08 00 00 
 8000010479c:	ff d0                	call   *%rax
 8000010479e:	48 89 83 c8 00 00 00 	mov    %rax,0xc8(%rbx)
  acquire(&ptable.lock);
 800001047a5:	49 bc 60 a6 11 00 00 	movabs $0x8000011a660,%r12
 800001047ac:	08 00 00 
 800001047af:	4c 89 e7             	mov    %r12,%rdi
 800001047b2:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 800001047b9:	08 00 00 
 800001047bc:	ff d0                	call   *%rax
  p->state = RUNNABLE;
 800001047be:	c7 43 18 03 00 00 00 	movl   $0x3,0x18(%rbx)
  release(&ptable.lock);
 800001047c5:	4c 89 e7             	mov    %r12,%rdi
 800001047c8:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001047cf:	08 00 00 
 800001047d2:	ff d0                	call   *%rax
}
 800001047d4:	5b                   	pop    %rbx
 800001047d5:	41 5c                	pop    %r12
 800001047d7:	5d                   	pop    %rbp
 800001047d8:	c3                   	ret
    panic("userinit: out of memory?");
 800001047d9:	48 bf 0d ac 10 00 00 	movabs $0x8000010ac0d,%rdi
 800001047e0:	08 00 00 
 800001047e3:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001047ea:	08 00 00 
 800001047ed:	ff d0                	call   *%rax

00000800001047ef <growproc>:
{
 800001047ef:	55                   	push   %rbp
 800001047f0:	48 89 e5             	mov    %rsp,%rbp
 800001047f3:	41 54                	push   %r12
 800001047f5:	53                   	push   %rbx
 800001047f6:	41 89 fc             	mov    %edi,%r12d
  struct proc *curproc = myproc();
 800001047f9:	48 b8 64 46 10 00 00 	movabs $0x80000104664,%rax
 80000104800:	08 00 00 
 80000104803:	ff d0                	call   *%rax
 80000104805:	48 89 c3             	mov    %rax,%rbx
  sz = curproc->sz;
 80000104808:	48 8b 30             	mov    (%rax),%rsi
  if(n > 0){
 8000010480b:	45 85 e4             	test   %r12d,%r12d
 8000010480e:	7f 22                	jg     80000104832 <growproc+0x43>
 80000104810:	89 f0                	mov    %esi,%eax
  } else if(n < 0){
 80000104812:	78 3f                	js     80000104853 <growproc+0x64>
  curproc->sz = sz;
 80000104814:	89 c0                	mov    %eax,%eax
 80000104816:	48 89 03             	mov    %rax,(%rbx)
  switchuvm(curproc);
 80000104819:	48 89 df             	mov    %rbx,%rdi
 8000010481c:	48 b8 4c 84 10 00 00 	movabs $0x8000010844c,%rax
 80000104823:	08 00 00 
 80000104826:	ff d0                	call   *%rax
  return 0;
 80000104828:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8000010482d:	5b                   	pop    %rbx
 8000010482e:	41 5c                	pop    %r12
 80000104830:	5d                   	pop    %rbp
 80000104831:	c3                   	ret
    if((sz = allocuvm(curproc->pml4, sz, sz + n)) == 0)
 80000104832:	41 8d 14 34          	lea    (%r12,%rsi,1),%edx
 80000104836:	89 f6                	mov    %esi,%esi
 80000104838:	48 8b 78 08          	mov    0x8(%rax),%rdi
 8000010483c:	48 b8 a3 88 10 00 00 	movabs $0x800001088a3,%rax
 80000104843:	08 00 00 
 80000104846:	ff d0                	call   *%rax
 80000104848:	85 c0                	test   %eax,%eax
 8000010484a:	75 c8                	jne    80000104814 <growproc+0x25>
      return -1;
 8000010484c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000104851:	eb da                	jmp    8000010482d <growproc+0x3e>
    if((sz = deallocuvm(curproc->pml4, sz, sz + n)) == 0)
 80000104853:	41 8d 14 34          	lea    (%r12,%rsi,1),%edx
 80000104857:	89 f6                	mov    %esi,%esi
 80000104859:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
 8000010485d:	48 b8 c9 87 10 00 00 	movabs $0x800001087c9,%rax
 80000104864:	08 00 00 
 80000104867:	ff d0                	call   *%rax
 80000104869:	85 c0                	test   %eax,%eax
 8000010486b:	75 a7                	jne    80000104814 <growproc+0x25>
      return -1;
 8000010486d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000104872:	eb b9                	jmp    8000010482d <growproc+0x3e>

0000080000104874 <fork>:
{
 80000104874:	55                   	push   %rbp
 80000104875:	48 89 e5             	mov    %rsp,%rbp
 80000104878:	41 55                	push   %r13
 8000010487a:	41 54                	push   %r12
 8000010487c:	53                   	push   %rbx
 8000010487d:	48 83 ec 08          	sub    $0x8,%rsp
  struct proc *curproc = myproc();
 80000104881:	48 b8 64 46 10 00 00 	movabs $0x80000104664,%rax
 80000104888:	08 00 00 
 8000010488b:	ff d0                	call   *%rax
 8000010488d:	49 89 c4             	mov    %rax,%r12
  if((np = allocproc()) == 0){
 80000104890:	48 b8 0b 44 10 00 00 	movabs $0x8000010440b,%rax
 80000104897:	08 00 00 
 8000010489a:	ff d0                	call   *%rax
 8000010489c:	48 85 c0             	test   %rax,%rax
 8000010489f:	0f 84 c6 01 00 00    	je     80000104a6b <fork+0x1f7>
 800001048a5:	49 89 c5             	mov    %rax,%r13
  if((np->pml4 = copyuvm(curproc->pml4, curproc->sz)) == 0){
 800001048a8:	49 8b 34 24          	mov    (%r12),%rsi
 800001048ac:	49 8b 7c 24 08       	mov    0x8(%r12),%rdi
 800001048b1:	48 b8 cf 8b 10 00 00 	movabs $0x80000108bcf,%rax
 800001048b8:	08 00 00 
 800001048bb:	ff d0                	call   *%rax
 800001048bd:	49 89 45 08          	mov    %rax,0x8(%r13)
 800001048c1:	48 85 c0             	test   %rax,%rax
 800001048c4:	0f 84 83 00 00 00    	je     8000010494d <fork+0xd9>
  np->sz = curproc->sz;
 800001048ca:	49 8b 04 24          	mov    (%r12),%rax
 800001048ce:	49 89 45 00          	mov    %rax,0x0(%r13)
  np->parent = curproc;
 800001048d2:	4d 89 65 20          	mov    %r12,0x20(%r13)
  *np->tf = *curproc->tf;
 800001048d6:	49 8b 54 24 28       	mov    0x28(%r12),%rdx
 800001048db:	49 8b 7d 28          	mov    0x28(%r13),%rdi
 800001048df:	48 89 d6             	mov    %rdx,%rsi
 800001048e2:	b8 b0 00 00 00       	mov    $0xb0,%eax
 800001048e7:	40 f6 c7 01          	test   $0x1,%dil
 800001048eb:	0f 85 87 00 00 00    	jne    80000104978 <fork+0x104>
 800001048f1:	40 f6 c7 02          	test   $0x2,%dil
 800001048f5:	0f 85 93 00 00 00    	jne    8000010498e <fork+0x11a>
 800001048fb:	40 f6 c7 04          	test   $0x4,%dil
 800001048ff:	0f 85 9f 00 00 00    	jne    800001049a4 <fork+0x130>
 80000104905:	89 c1                	mov    %eax,%ecx
 80000104907:	c1 e9 03             	shr    $0x3,%ecx
 8000010490a:	89 c9                	mov    %ecx,%ecx
 8000010490c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
 8000010490f:	ba 00 00 00 00       	mov    $0x0,%edx
 80000104914:	a8 04                	test   $0x4,%al
 80000104916:	74 09                	je     80000104921 <fork+0xad>
 80000104918:	8b 16                	mov    (%rsi),%edx
 8000010491a:	89 17                	mov    %edx,(%rdi)
 8000010491c:	ba 04 00 00 00       	mov    $0x4,%edx
 80000104921:	a8 02                	test   $0x2,%al
 80000104923:	74 0c                	je     80000104931 <fork+0xbd>
 80000104925:	66 8b 0c 16          	mov    (%rsi,%rdx,1),%cx
 80000104929:	66 89 0c 17          	mov    %cx,(%rdi,%rdx,1)
 8000010492d:	48 83 c2 02          	add    $0x2,%rdx
 80000104931:	a8 01                	test   $0x1,%al
 80000104933:	74 06                	je     8000010493b <fork+0xc7>
 80000104935:	8a 04 16             	mov    (%rsi,%rdx,1),%al
 80000104938:	88 04 17             	mov    %al,(%rdi,%rdx,1)
  np->tf->rax = 0;
 8000010493b:	49 8b 45 28          	mov    0x28(%r13),%rax
 8000010493f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(i = 0; i < NOFILE; i++)
 80000104946:	bb 00 00 00 00       	mov    $0x0,%ebx
 8000010494b:	eb 76                	jmp    800001049c3 <fork+0x14f>
    kfree(np->kstack);
 8000010494d:	49 8b 7d 10          	mov    0x10(%r13),%rdi
 80000104951:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 80000104958:	08 00 00 
 8000010495b:	ff d0                	call   *%rax
    np->kstack = 0;
 8000010495d:	49 c7 45 10 00 00 00 	movq   $0x0,0x10(%r13)
 80000104964:	00 
    np->state = UNUSED;
 80000104965:	41 c7 45 18 00 00 00 	movl   $0x0,0x18(%r13)
 8000010496c:	00 
    return -1;
 8000010496d:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 80000104973:	e9 e5 00 00 00       	jmp    80000104a5d <fork+0x1e9>
  *np->tf = *curproc->tf;
 80000104978:	8a 02                	mov    (%rdx),%al
 8000010497a:	88 07                	mov    %al,(%rdi)
 8000010497c:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
 80000104980:	48 8d 72 01          	lea    0x1(%rdx),%rsi
 80000104984:	b8 af 00 00 00       	mov    $0xaf,%eax
 80000104989:	e9 63 ff ff ff       	jmp    800001048f1 <fork+0x7d>
 8000010498e:	66 8b 16             	mov    (%rsi),%dx
 80000104991:	66 89 17             	mov    %dx,(%rdi)
 80000104994:	48 8d 7f 02          	lea    0x2(%rdi),%rdi
 80000104998:	48 8d 76 02          	lea    0x2(%rsi),%rsi
 8000010499c:	83 e8 02             	sub    $0x2,%eax
 8000010499f:	e9 57 ff ff ff       	jmp    800001048fb <fork+0x87>
 800001049a4:	8b 16                	mov    (%rsi),%edx
 800001049a6:	89 17                	mov    %edx,(%rdi)
 800001049a8:	48 8d 7f 04          	lea    0x4(%rdi),%rdi
 800001049ac:	48 8d 76 04          	lea    0x4(%rsi),%rsi
 800001049b0:	83 e8 04             	sub    $0x4,%eax
 800001049b3:	e9 4d ff ff ff       	jmp    80000104905 <fork+0x91>
 800001049b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 800001049bf:	00 
  for(i = 0; i < NOFILE; i++)
 800001049c0:	83 c3 01             	add    $0x1,%ebx
 800001049c3:	83 fb 0f             	cmp    $0xf,%ebx
 800001049c6:	7f 26                	jg     800001049ee <fork+0x17a>
    if(curproc->ofile[i])
 800001049c8:	48 63 c3             	movslq %ebx,%rax
 800001049cb:	49 8b 7c c4 48       	mov    0x48(%r12,%rax,8),%rdi
 800001049d0:	48 85 ff             	test   %rdi,%rdi
 800001049d3:	74 eb                	je     800001049c0 <fork+0x14c>
      np->ofile[i] = filedup(curproc->ofile[i]);
 800001049d5:	48 b8 a2 12 10 00 00 	movabs $0x800001012a2,%rax
 800001049dc:	08 00 00 
 800001049df:	ff d0                	call   *%rax
 800001049e1:	48 89 c2             	mov    %rax,%rdx
 800001049e4:	48 63 c3             	movslq %ebx,%rax
 800001049e7:	49 89 54 c5 48       	mov    %rdx,0x48(%r13,%rax,8)
 800001049ec:	eb d2                	jmp    800001049c0 <fork+0x14c>
  np->cwd = idup(curproc->cwd);
 800001049ee:	49 8b bc 24 c8 00 00 	mov    0xc8(%r12),%rdi
 800001049f5:	00 
 800001049f6:	48 b8 de 1e 10 00 00 	movabs $0x80000101ede,%rax
 800001049fd:	08 00 00 
 80000104a00:	ff d0                	call   *%rax
 80000104a02:	49 89 85 c8 00 00 00 	mov    %rax,0xc8(%r13)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
 80000104a09:	49 8d b4 24 d0 00 00 	lea    0xd0(%r12),%rsi
 80000104a10:	00 
 80000104a11:	49 8d bd d0 00 00 00 	lea    0xd0(%r13),%rdi
 80000104a18:	ba 10 00 00 00       	mov    $0x10,%edx
 80000104a1d:	48 b8 93 57 10 00 00 	movabs $0x80000105793,%rax
 80000104a24:	08 00 00 
 80000104a27:	ff d0                	call   *%rax
  pid = np->pid;
 80000104a29:	45 8b 65 1c          	mov    0x1c(%r13),%r12d
  acquire(&ptable.lock);
 80000104a2d:	48 bb 60 a6 11 00 00 	movabs $0x8000011a660,%rbx
 80000104a34:	08 00 00 
 80000104a37:	48 89 df             	mov    %rbx,%rdi
 80000104a3a:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000104a41:	08 00 00 
 80000104a44:	ff d0                	call   *%rax
  np->state = RUNNABLE;
 80000104a46:	41 c7 45 18 03 00 00 	movl   $0x3,0x18(%r13)
 80000104a4d:	00 
  release(&ptable.lock);
 80000104a4e:	48 89 df             	mov    %rbx,%rdi
 80000104a51:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000104a58:	08 00 00 
 80000104a5b:	ff d0                	call   *%rax
}
 80000104a5d:	44 89 e0             	mov    %r12d,%eax
 80000104a60:	48 83 c4 08          	add    $0x8,%rsp
 80000104a64:	5b                   	pop    %rbx
 80000104a65:	41 5c                	pop    %r12
 80000104a67:	41 5d                	pop    %r13
 80000104a69:	5d                   	pop    %rbp
 80000104a6a:	c3                   	ret
    return -1;
 80000104a6b:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 80000104a71:	eb ea                	jmp    80000104a5d <fork+0x1e9>

0000080000104a73 <scheduler>:
{
 80000104a73:	55                   	push   %rbp
 80000104a74:	48 89 e5             	mov    %rsp,%rbp
 80000104a77:	41 54                	push   %r12
 80000104a79:	53                   	push   %rbx
  struct cpu *c = mycpu();
 80000104a7a:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000104a81:	08 00 00 
 80000104a84:	ff d0                	call   *%rax
 80000104a86:	49 89 c4             	mov    %rax,%r12
  c->proc = 0;
 80000104a89:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
 80000104a90:	00 00 00 00 
 80000104a94:	e9 83 00 00 00       	jmp    80000104b1c <scheduler+0xa9>
 80000104a99:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
 80000104aa0:	48 81 c3 e0 00 00 00 	add    $0xe0,%rbx
 80000104aa7:	48 b8 c8 de 11 00 00 	movabs $0x8000011dec8,%rax
 80000104aae:	08 00 00 
 80000104ab1:	48 39 c3             	cmp    %rax,%rbx
 80000104ab4:	73 53                	jae    80000104b09 <scheduler+0x96>
      if(p->state != RUNNABLE)
 80000104ab6:	83 7b 18 03          	cmpl   $0x3,0x18(%rbx)
 80000104aba:	75 e4                	jne    80000104aa0 <scheduler+0x2d>
      c->proc = p;
 80000104abc:	49 89 9c 24 c0 00 00 	mov    %rbx,0xc0(%r12)
 80000104ac3:	00 
      switchuvm(p);
 80000104ac4:	48 89 df             	mov    %rbx,%rdi
 80000104ac7:	48 b8 4c 84 10 00 00 	movabs $0x8000010844c,%rax
 80000104ace:	08 00 00 
 80000104ad1:	ff d0                	call   *%rax
      p->state = RUNNING;
 80000104ad3:	c7 43 18 04 00 00 00 	movl   $0x4,0x18(%rbx)
      swtch(&(c->scheduler), p->context);
 80000104ada:	48 8b 73 30          	mov    0x30(%rbx),%rsi
 80000104ade:	49 8d 7c 24 08       	lea    0x8(%r12),%rdi
 80000104ae3:	48 b8 ff 57 10 00 00 	movabs $0x800001057ff,%rax
 80000104aea:	08 00 00 
 80000104aed:	ff d0                	call   *%rax
      switchkvm();
 80000104aef:	48 b8 31 84 10 00 00 	movabs $0x80000108431,%rax
 80000104af6:	08 00 00 
 80000104af9:	ff d0                	call   *%rax
      c->proc = 0;
 80000104afb:	49 c7 84 24 c0 00 00 	movq   $0x0,0xc0(%r12)
 80000104b02:	00 00 00 00 00 
 80000104b07:	eb 97                	jmp    80000104aa0 <scheduler+0x2d>
    release(&ptable.lock);
 80000104b09:	48 8d b8 98 c7 ff ff 	lea    -0x3868(%rax),%rdi
 80000104b10:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000104b17:	08 00 00 
 80000104b1a:	ff d0                	call   *%rax
    asm volatile("sti");
 80000104b1c:	fb                   	sti
    acquire(&ptable.lock);
 80000104b1d:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 80000104b24:	08 00 00 
 80000104b27:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000104b2e:	08 00 00 
 80000104b31:	ff d0                	call   *%rax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
 80000104b33:	48 bb c8 a6 11 00 00 	movabs $0x8000011a6c8,%rbx
 80000104b3a:	08 00 00 
 80000104b3d:	e9 65 ff ff ff       	jmp    80000104aa7 <scheduler+0x34>

0000080000104b42 <sched>:
{
 80000104b42:	55                   	push   %rbp
 80000104b43:	48 89 e5             	mov    %rsp,%rbp
 80000104b46:	41 55                	push   %r13
 80000104b48:	41 54                	push   %r12
 80000104b4a:	53                   	push   %rbx
 80000104b4b:	48 83 ec 08          	sub    $0x8,%rsp
  struct proc *p = myproc();
 80000104b4f:	48 b8 64 46 10 00 00 	movabs $0x80000104664,%rax
 80000104b56:	08 00 00 
 80000104b59:	ff d0                	call   *%rax
 80000104b5b:	48 89 c3             	mov    %rax,%rbx
  if(!holding(&ptable.lock))
 80000104b5e:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 80000104b65:	08 00 00 
 80000104b68:	48 b8 b6 54 10 00 00 	movabs $0x800001054b6,%rax
 80000104b6f:	08 00 00 
 80000104b72:	ff d0                	call   *%rax
 80000104b74:	85 c0                	test   %eax,%eax
 80000104b76:	74 66                	je     80000104bde <sched+0x9c>
  if(mycpu()->ncli != 1)
 80000104b78:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000104b7f:	08 00 00 
 80000104b82:	ff d0                	call   *%rax
 80000104b84:	83 b8 b8 00 00 00 01 	cmpl   $0x1,0xb8(%rax)
 80000104b8b:	75 67                	jne    80000104bf4 <sched+0xb2>
  if(p->state == RUNNING)
 80000104b8d:	83 7b 18 04          	cmpl   $0x4,0x18(%rbx)
 80000104b91:	74 77                	je     80000104c0a <sched+0xc8>
  asm volatile("pushfq; popq %0" : "=r" (rflags));
 80000104b93:	9c                   	pushf
 80000104b94:	58                   	pop    %rax
  if(readrflags()&FL_IF)
 80000104b95:	f6 c4 02             	test   $0x2,%ah
 80000104b98:	0f 85 82 00 00 00    	jne    80000104c20 <sched+0xde>
  intena = mycpu()->intena;
 80000104b9e:	49 bc a8 45 10 00 00 	movabs $0x800001045a8,%r12
 80000104ba5:	08 00 00 
 80000104ba8:	41 ff d4             	call   *%r12
 80000104bab:	44 8b a8 bc 00 00 00 	mov    0xbc(%rax),%r13d
  swtch(&p->context, mycpu()->scheduler);
 80000104bb2:	41 ff d4             	call   *%r12
 80000104bb5:	48 8b 70 08          	mov    0x8(%rax),%rsi
 80000104bb9:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
 80000104bbd:	48 b8 ff 57 10 00 00 	movabs $0x800001057ff,%rax
 80000104bc4:	08 00 00 
 80000104bc7:	ff d0                	call   *%rax
  mycpu()->intena = intena;
 80000104bc9:	41 ff d4             	call   *%r12
 80000104bcc:	44 89 a8 bc 00 00 00 	mov    %r13d,0xbc(%rax)
}
 80000104bd3:	48 83 c4 08          	add    $0x8,%rsp
 80000104bd7:	5b                   	pop    %rbx
 80000104bd8:	41 5c                	pop    %r12
 80000104bda:	41 5d                	pop    %r13
 80000104bdc:	5d                   	pop    %rbp
 80000104bdd:	c3                   	ret
    panic("sched ptable.lock");
 80000104bde:	48 bf 31 ac 10 00 00 	movabs $0x8000010ac31,%rdi
 80000104be5:	08 00 00 
 80000104be8:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000104bef:	08 00 00 
 80000104bf2:	ff d0                	call   *%rax
    panic("sched locks");
 80000104bf4:	48 bf 43 ac 10 00 00 	movabs $0x8000010ac43,%rdi
 80000104bfb:	08 00 00 
 80000104bfe:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000104c05:	08 00 00 
 80000104c08:	ff d0                	call   *%rax
    panic("sched running");
 80000104c0a:	48 bf 4f ac 10 00 00 	movabs $0x8000010ac4f,%rdi
 80000104c11:	08 00 00 
 80000104c14:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000104c1b:	08 00 00 
 80000104c1e:	ff d0                	call   *%rax
    panic("sched interruptible");
 80000104c20:	48 bf 5d ac 10 00 00 	movabs $0x8000010ac5d,%rdi
 80000104c27:	08 00 00 
 80000104c2a:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000104c31:	08 00 00 
 80000104c34:	ff d0                	call   *%rax

0000080000104c36 <exit>:
{
 80000104c36:	55                   	push   %rbp
 80000104c37:	48 89 e5             	mov    %rsp,%rbp
 80000104c3a:	41 54                	push   %r12
 80000104c3c:	53                   	push   %rbx
  struct proc *curproc = myproc();
 80000104c3d:	48 b8 64 46 10 00 00 	movabs $0x80000104664,%rax
 80000104c44:	08 00 00 
 80000104c47:	ff d0                	call   *%rax
 80000104c49:	49 89 c4             	mov    %rax,%r12
  if(curproc == initproc)
 80000104c4c:	48 a1 c8 de 11 00 00 	movabs 0x8000011dec8,%rax
 80000104c53:	08 00 00 
 80000104c56:	4c 39 e0             	cmp    %r12,%rax
 80000104c59:	74 07                	je     80000104c62 <exit+0x2c>
  for(fd = 0; fd < NOFILE; fd++){
 80000104c5b:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000104c60:	eb 31                	jmp    80000104c93 <exit+0x5d>
    panic("init exiting");
 80000104c62:	48 bf 71 ac 10 00 00 	movabs $0x8000010ac71,%rdi
 80000104c69:	08 00 00 
 80000104c6c:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000104c73:	08 00 00 
 80000104c76:	ff d0                	call   *%rax
      fileclose(curproc->ofile[fd]);
 80000104c78:	48 b8 07 13 10 00 00 	movabs $0x80000101307,%rax
 80000104c7f:	08 00 00 
 80000104c82:	ff d0                	call   *%rax
      curproc->ofile[fd] = 0;
 80000104c84:	48 63 c3             	movslq %ebx,%rax
 80000104c87:	49 c7 44 c4 48 00 00 	movq   $0x0,0x48(%r12,%rax,8)
 80000104c8e:	00 00 
  for(fd = 0; fd < NOFILE; fd++){
 80000104c90:	83 c3 01             	add    $0x1,%ebx
 80000104c93:	83 fb 0f             	cmp    $0xf,%ebx
 80000104c96:	7f 0f                	jg     80000104ca7 <exit+0x71>
    if(curproc->ofile[fd]){
 80000104c98:	48 63 c3             	movslq %ebx,%rax
 80000104c9b:	49 8b 7c c4 48       	mov    0x48(%r12,%rax,8),%rdi
 80000104ca0:	48 85 ff             	test   %rdi,%rdi
 80000104ca3:	75 d3                	jne    80000104c78 <exit+0x42>
 80000104ca5:	eb e9                	jmp    80000104c90 <exit+0x5a>
  vmxfreeproc(curproc);
 80000104ca7:	4c 89 e7             	mov    %r12,%rdi
 80000104caa:	48 b8 6c a6 10 00 00 	movabs $0x8000010a66c,%rax
 80000104cb1:	08 00 00 
 80000104cb4:	ff d0                	call   *%rax
  begin_op();
 80000104cb6:	b0 00                	mov    $0x0,%al
 80000104cb8:	48 ba 72 37 10 00 00 	movabs $0x80000103772,%rdx
 80000104cbf:	08 00 00 
 80000104cc2:	ff d2                	call   *%rdx
  iput(curproc->cwd);
 80000104cc4:	49 8b bc 24 c8 00 00 	mov    0xc8(%r12),%rdi
 80000104ccb:	00 
 80000104ccc:	48 b8 80 20 10 00 00 	movabs $0x80000102080,%rax
 80000104cd3:	08 00 00 
 80000104cd6:	ff d0                	call   *%rax
  end_op();
 80000104cd8:	b0 00                	mov    $0x0,%al
 80000104cda:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000104ce1:	08 00 00 
 80000104ce4:	ff d2                	call   *%rdx
  curproc->cwd = 0;
 80000104ce6:	49 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%r12)
 80000104ced:	00 00 00 00 00 
  acquire(&ptable.lock);
 80000104cf2:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 80000104cf9:	08 00 00 
 80000104cfc:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000104d03:	08 00 00 
 80000104d06:	ff d0                	call   *%rax
  wakeup1(curproc->parent);
 80000104d08:	49 8b 7c 24 20       	mov    0x20(%r12),%rdi
 80000104d0d:	48 b8 c0 43 10 00 00 	movabs $0x800001043c0,%rax
 80000104d14:	08 00 00 
 80000104d17:	ff d0                	call   *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
 80000104d19:	48 bb c8 a6 11 00 00 	movabs $0x8000011a6c8,%rbx
 80000104d20:	08 00 00 
 80000104d23:	eb 22                	jmp    80000104d47 <exit+0x111>
 80000104d25:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000104d2c:	00 00 00 00 
 80000104d30:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000104d37:	00 00 00 00 
 80000104d3b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 80000104d40:	48 81 c3 e0 00 00 00 	add    $0xe0,%rbx
 80000104d47:	48 b8 c8 de 11 00 00 	movabs $0x8000011dec8,%rax
 80000104d4e:	08 00 00 
 80000104d51:	48 39 c3             	cmp    %rax,%rbx
 80000104d54:	73 2b                	jae    80000104d81 <exit+0x14b>
    if(p->parent == curproc){
 80000104d56:	4c 39 63 20          	cmp    %r12,0x20(%rbx)
 80000104d5a:	75 e4                	jne    80000104d40 <exit+0x10a>
      p->parent = initproc;
 80000104d5c:	48 a1 c8 de 11 00 00 	movabs 0x8000011dec8,%rax
 80000104d63:	08 00 00 
 80000104d66:	48 89 43 20          	mov    %rax,0x20(%rbx)
      if(p->state == ZOMBIE)
 80000104d6a:	83 7b 18 05          	cmpl   $0x5,0x18(%rbx)
 80000104d6e:	75 d0                	jne    80000104d40 <exit+0x10a>
        wakeup1(initproc);
 80000104d70:	48 89 c7             	mov    %rax,%rdi
 80000104d73:	48 b8 c0 43 10 00 00 	movabs $0x800001043c0,%rax
 80000104d7a:	08 00 00 
 80000104d7d:	ff d0                	call   *%rax
 80000104d7f:	eb bf                	jmp    80000104d40 <exit+0x10a>
  curproc->state = ZOMBIE;
 80000104d81:	41 c7 44 24 18 05 00 	movl   $0x5,0x18(%r12)
 80000104d88:	00 00 
  sched();
 80000104d8a:	48 b8 42 4b 10 00 00 	movabs $0x80000104b42,%rax
 80000104d91:	08 00 00 
 80000104d94:	ff d0                	call   *%rax
  panic("zombie exit");
 80000104d96:	48 bf 7e ac 10 00 00 	movabs $0x8000010ac7e,%rdi
 80000104d9d:	08 00 00 
 80000104da0:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000104da7:	08 00 00 
 80000104daa:	ff d0                	call   *%rax

0000080000104dac <yield>:
{
 80000104dac:	55                   	push   %rbp
 80000104dad:	48 89 e5             	mov    %rsp,%rbp
 80000104db0:	53                   	push   %rbx
 80000104db1:	48 83 ec 08          	sub    $0x8,%rsp
  acquire(&ptable.lock);  //DOC: yieldlock
 80000104db5:	48 bb 60 a6 11 00 00 	movabs $0x8000011a660,%rbx
 80000104dbc:	08 00 00 
 80000104dbf:	48 89 df             	mov    %rbx,%rdi
 80000104dc2:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000104dc9:	08 00 00 
 80000104dcc:	ff d0                	call   *%rax
  myproc()->state = RUNNABLE;
 80000104dce:	48 b8 64 46 10 00 00 	movabs $0x80000104664,%rax
 80000104dd5:	08 00 00 
 80000104dd8:	ff d0                	call   *%rax
 80000104dda:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  sched();
 80000104de1:	48 b8 42 4b 10 00 00 	movabs $0x80000104b42,%rax
 80000104de8:	08 00 00 
 80000104deb:	ff d0                	call   *%rax
  release(&ptable.lock);
 80000104ded:	48 89 df             	mov    %rbx,%rdi
 80000104df0:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000104df7:	08 00 00 
 80000104dfa:	ff d0                	call   *%rax
}
 80000104dfc:	48 83 c4 08          	add    $0x8,%rsp
 80000104e00:	5b                   	pop    %rbx
 80000104e01:	5d                   	pop    %rbp
 80000104e02:	c3                   	ret

0000080000104e03 <sleep>:
{
 80000104e03:	55                   	push   %rbp
 80000104e04:	48 89 e5             	mov    %rsp,%rbp
 80000104e07:	41 55                	push   %r13
 80000104e09:	41 54                	push   %r12
 80000104e0b:	53                   	push   %rbx
 80000104e0c:	48 83 ec 08          	sub    $0x8,%rsp
 80000104e10:	49 89 fd             	mov    %rdi,%r13
 80000104e13:	48 89 f3             	mov    %rsi,%rbx
  struct proc *p = myproc();
 80000104e16:	48 b8 64 46 10 00 00 	movabs $0x80000104664,%rax
 80000104e1d:	08 00 00 
 80000104e20:	ff d0                	call   *%rax
  if(p == 0)
 80000104e22:	48 85 c0             	test   %rax,%rax
 80000104e25:	0f 84 94 00 00 00    	je     80000104ebf <sleep+0xbc>
 80000104e2b:	49 89 c4             	mov    %rax,%r12
  if(lk == 0)
 80000104e2e:	48 85 db             	test   %rbx,%rbx
 80000104e31:	0f 84 9e 00 00 00    	je     80000104ed5 <sleep+0xd2>
  if(lk != &ptable.lock){  //DOC: sleeplock0
 80000104e37:	48 b8 60 a6 11 00 00 	movabs $0x8000011a660,%rax
 80000104e3e:	08 00 00 
 80000104e41:	48 39 c3             	cmp    %rax,%rbx
 80000104e44:	74 1e                	je     80000104e64 <sleep+0x61>
    acquire(&ptable.lock);  //DOC: sleeplock1
 80000104e46:	48 89 c7             	mov    %rax,%rdi
 80000104e49:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000104e50:	08 00 00 
 80000104e53:	ff d0                	call   *%rax
    release(lk);
 80000104e55:	48 89 df             	mov    %rbx,%rdi
 80000104e58:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000104e5f:	08 00 00 
 80000104e62:	ff d0                	call   *%rax
  p->chan = chan;
 80000104e64:	4d 89 6c 24 38       	mov    %r13,0x38(%r12)
  p->state = SLEEPING;
 80000104e69:	41 c7 44 24 18 02 00 	movl   $0x2,0x18(%r12)
 80000104e70:	00 00 
  sched();
 80000104e72:	48 b8 42 4b 10 00 00 	movabs $0x80000104b42,%rax
 80000104e79:	08 00 00 
 80000104e7c:	ff d0                	call   *%rax
  p->chan = 0;
 80000104e7e:	49 c7 44 24 38 00 00 	movq   $0x0,0x38(%r12)
 80000104e85:	00 00 
  if(lk != &ptable.lock){  //DOC: sleeplock2
 80000104e87:	48 b8 60 a6 11 00 00 	movabs $0x8000011a660,%rax
 80000104e8e:	08 00 00 
 80000104e91:	48 39 c3             	cmp    %rax,%rbx
 80000104e94:	74 1e                	je     80000104eb4 <sleep+0xb1>
    release(&ptable.lock);
 80000104e96:	48 89 c7             	mov    %rax,%rdi
 80000104e99:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000104ea0:	08 00 00 
 80000104ea3:	ff d0                	call   *%rax
    acquire(lk);
 80000104ea5:	48 89 df             	mov    %rbx,%rdi
 80000104ea8:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000104eaf:	08 00 00 
 80000104eb2:	ff d0                	call   *%rax
}
 80000104eb4:	48 83 c4 08          	add    $0x8,%rsp
 80000104eb8:	5b                   	pop    %rbx
 80000104eb9:	41 5c                	pop    %r12
 80000104ebb:	41 5d                	pop    %r13
 80000104ebd:	5d                   	pop    %rbp
 80000104ebe:	c3                   	ret
    panic("sleep");
 80000104ebf:	48 bf 8a ac 10 00 00 	movabs $0x8000010ac8a,%rdi
 80000104ec6:	08 00 00 
 80000104ec9:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000104ed0:	08 00 00 
 80000104ed3:	ff d0                	call   *%rax
    panic("sleep without lk");
 80000104ed5:	48 bf 90 ac 10 00 00 	movabs $0x8000010ac90,%rdi
 80000104edc:	08 00 00 
 80000104edf:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000104ee6:	08 00 00 
 80000104ee9:	ff d0                	call   *%rax

0000080000104eeb <wait>:
{
 80000104eeb:	55                   	push   %rbp
 80000104eec:	48 89 e5             	mov    %rsp,%rbp
 80000104eef:	41 54                	push   %r12
 80000104ef1:	53                   	push   %rbx
  struct proc *curproc = myproc();
 80000104ef2:	48 b8 64 46 10 00 00 	movabs $0x80000104664,%rax
 80000104ef9:	08 00 00 
 80000104efc:	ff d0                	call   *%rax
 80000104efe:	49 89 c4             	mov    %rax,%r12
  acquire(&ptable.lock);
 80000104f01:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 80000104f08:	08 00 00 
 80000104f0b:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000104f12:	08 00 00 
 80000104f15:	ff d0                	call   *%rax
    havekids = 0;
 80000104f17:	ba 00 00 00 00       	mov    $0x0,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
 80000104f1c:	48 bb c8 a6 11 00 00 	movabs $0x8000011a6c8,%rbx
 80000104f23:	08 00 00 
 80000104f26:	eb 7f                	jmp    80000104fa7 <wait+0xbc>
        pid = p->pid;
 80000104f28:	44 8b 63 1c          	mov    0x1c(%rbx),%r12d
        kfree(p->kstack);
 80000104f2c:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
 80000104f30:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 80000104f37:	08 00 00 
 80000104f3a:	ff d0                	call   *%rax
        p->kstack = 0;
 80000104f3c:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
 80000104f43:	00 
        freevm(p->pml4);
 80000104f44:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
 80000104f48:	48 b8 76 8a 10 00 00 	movabs $0x80000108a76,%rax
 80000104f4f:	08 00 00 
 80000104f52:	ff d0                	call   *%rax
        p->pid = 0;
 80000104f54:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%rbx)
        p->parent = 0;
 80000104f5b:	48 c7 43 20 00 00 00 	movq   $0x0,0x20(%rbx)
 80000104f62:	00 
        p->name[0] = 0;
 80000104f63:	c6 83 d0 00 00 00 00 	movb   $0x0,0xd0(%rbx)
        p->killed = 0;
 80000104f6a:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%rbx)
        p->state = UNUSED;
 80000104f71:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%rbx)
        release(&ptable.lock);
 80000104f78:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 80000104f7f:	08 00 00 
 80000104f82:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000104f89:	08 00 00 
 80000104f8c:	ff d0                	call   *%rax
}
 80000104f8e:	44 89 e0             	mov    %r12d,%eax
 80000104f91:	5b                   	pop    %rbx
 80000104f92:	41 5c                	pop    %r12
 80000104f94:	5d                   	pop    %rbp
 80000104f95:	c3                   	ret
 80000104f96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 80000104f9d:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
 80000104fa0:	48 81 c3 e0 00 00 00 	add    $0xe0,%rbx
 80000104fa7:	48 b8 c8 de 11 00 00 	movabs $0x8000011dec8,%rax
 80000104fae:	08 00 00 
 80000104fb1:	48 39 c3             	cmp    %rax,%rbx
 80000104fb4:	73 17                	jae    80000104fcd <wait+0xe2>
      if(p->parent != curproc)
 80000104fb6:	4c 39 63 20          	cmp    %r12,0x20(%rbx)
 80000104fba:	75 e4                	jne    80000104fa0 <wait+0xb5>
      if(p->state == ZOMBIE){
 80000104fbc:	83 7b 18 05          	cmpl   $0x5,0x18(%rbx)
 80000104fc0:	0f 84 62 ff ff ff    	je     80000104f28 <wait+0x3d>
      havekids = 1;
 80000104fc6:	ba 01 00 00 00       	mov    $0x1,%edx
 80000104fcb:	eb d3                	jmp    80000104fa0 <wait+0xb5>
    if(!havekids || curproc->killed){
 80000104fcd:	85 d2                	test   %edx,%edx
 80000104fcf:	74 26                	je     80000104ff7 <wait+0x10c>
 80000104fd1:	41 83 7c 24 40 00    	cmpl   $0x0,0x40(%r12)
 80000104fd7:	75 1e                	jne    80000104ff7 <wait+0x10c>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
 80000104fd9:	48 be 60 a6 11 00 00 	movabs $0x8000011a660,%rsi
 80000104fe0:	08 00 00 
 80000104fe3:	4c 89 e7             	mov    %r12,%rdi
 80000104fe6:	48 b8 03 4e 10 00 00 	movabs $0x80000104e03,%rax
 80000104fed:	08 00 00 
 80000104ff0:	ff d0                	call   *%rax
    havekids = 0;
 80000104ff2:	e9 20 ff ff ff       	jmp    80000104f17 <wait+0x2c>
      release(&ptable.lock);
 80000104ff7:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 80000104ffe:	08 00 00 
 80000105001:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000105008:	08 00 00 
 8000010500b:	ff d0                	call   *%rax
      return -1;
 8000010500d:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 80000105013:	e9 76 ff ff ff       	jmp    80000104f8e <wait+0xa3>

0000080000105018 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
 80000105018:	55                   	push   %rbp
 80000105019:	48 89 e5             	mov    %rsp,%rbp
 8000010501c:	41 54                	push   %r12
 8000010501e:	53                   	push   %rbx
 8000010501f:	48 89 fb             	mov    %rdi,%rbx
  acquire(&ptable.lock);
 80000105022:	49 bc 60 a6 11 00 00 	movabs $0x8000011a660,%r12
 80000105029:	08 00 00 
 8000010502c:	4c 89 e7             	mov    %r12,%rdi
 8000010502f:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000105036:	08 00 00 
 80000105039:	ff d0                	call   *%rax
  wakeup1(chan);
 8000010503b:	48 89 df             	mov    %rbx,%rdi
 8000010503e:	48 b8 c0 43 10 00 00 	movabs $0x800001043c0,%rax
 80000105045:	08 00 00 
 80000105048:	ff d0                	call   *%rax
  release(&ptable.lock);
 8000010504a:	4c 89 e7             	mov    %r12,%rdi
 8000010504d:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000105054:	08 00 00 
 80000105057:	ff d0                	call   *%rax
}
 80000105059:	5b                   	pop    %rbx
 8000010505a:	41 5c                	pop    %r12
 8000010505c:	5d                   	pop    %rbp
 8000010505d:	c3                   	ret

000008000010505e <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
 8000010505e:	55                   	push   %rbp
 8000010505f:	48 89 e5             	mov    %rsp,%rbp
 80000105062:	53                   	push   %rbx
 80000105063:	48 83 ec 08          	sub    $0x8,%rsp
 80000105067:	89 fb                	mov    %edi,%ebx
  struct proc *p;

  acquire(&ptable.lock);
 80000105069:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 80000105070:	08 00 00 
 80000105073:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 8000010507a:	08 00 00 
 8000010507d:	ff d0                	call   *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
 8000010507f:	48 b8 c8 a6 11 00 00 	movabs $0x8000011a6c8,%rax
 80000105086:	08 00 00 
 80000105089:	eb 1b                	jmp    800001050a6 <kill+0x48>
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
 8000010508b:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
 80000105092:	eb 33                	jmp    800001050c7 <kill+0x69>
 80000105094:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 8000010509b:	00 00 00 00 
 8000010509f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
 800001050a0:	48 05 e0 00 00 00    	add    $0xe0,%rax
 800001050a6:	48 ba c8 de 11 00 00 	movabs $0x8000011dec8,%rdx
 800001050ad:	08 00 00 
 800001050b0:	48 39 d0             	cmp    %rdx,%rax
 800001050b3:	73 34                	jae    800001050e9 <kill+0x8b>
    if(p->pid == pid){
 800001050b5:	39 58 1c             	cmp    %ebx,0x1c(%rax)
 800001050b8:	75 e6                	jne    800001050a0 <kill+0x42>
      p->killed = 1;
 800001050ba:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
      if(p->state == SLEEPING)
 800001050c1:	83 78 18 02          	cmpl   $0x2,0x18(%rax)
 800001050c5:	74 c4                	je     8000010508b <kill+0x2d>
      release(&ptable.lock);
 800001050c7:	48 bf 60 a6 11 00 00 	movabs $0x8000011a660,%rdi
 800001050ce:	08 00 00 
 800001050d1:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001050d8:	08 00 00 
 800001050db:	ff d0                	call   *%rax
      return 0;
 800001050dd:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
 800001050e2:	48 83 c4 08          	add    $0x8,%rsp
 800001050e6:	5b                   	pop    %rbx
 800001050e7:	5d                   	pop    %rbp
 800001050e8:	c3                   	ret
  release(&ptable.lock);
 800001050e9:	48 8d ba 98 c7 ff ff 	lea    -0x3868(%rdx),%rdi
 800001050f0:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001050f7:	08 00 00 
 800001050fa:	ff d0                	call   *%rax
  return -1;
 800001050fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000105101:	eb df                	jmp    800001050e2 <kill+0x84>

0000080000105103 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
 80000105103:	55                   	push   %rbp
 80000105104:	48 89 e5             	mov    %rsp,%rbp
 80000105107:	41 54                	push   %r12
 80000105109:	53                   	push   %rbx
 8000010510a:	48 83 ec 50          	sub    $0x50,%rsp
  int i;
  struct proc *p;
  char *state;
  uint64 pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
 8000010510e:	48 bb c8 a6 11 00 00 	movabs $0x8000011a6c8,%rbx
 80000105115:	08 00 00 
 80000105118:	eb 52                	jmp    8000010516c <procdump+0x69>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
 8000010511a:	48 ba a1 ac 10 00 00 	movabs $0x8000010aca1,%rdx
 80000105121:	08 00 00 
    cprintf("%d %s %s", p->pid, state, p->name);
 80000105124:	48 8d 8b d0 00 00 00 	lea    0xd0(%rbx),%rcx
 8000010512b:	8b 73 1c             	mov    0x1c(%rbx),%esi
 8000010512e:	48 bf a5 ac 10 00 00 	movabs $0x8000010aca5,%rdi
 80000105135:	08 00 00 
 80000105138:	b0 00                	mov    $0x0,%al
 8000010513a:	49 b8 f9 08 10 00 00 	movabs $0x800001008f9,%r8
 80000105141:	08 00 00 
 80000105144:	41 ff d0             	call   *%r8
    if(p->state == SLEEPING){
 80000105147:	83 7b 18 02          	cmpl   $0x2,0x18(%rbx)
 8000010514b:	74 62                	je     800001051af <procdump+0xac>
      getcallerpcs((uint64*)p->context->rbp, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
 8000010514d:	48 bf 5a ae 10 00 00 	movabs $0x8000010ae5a,%rdi
 80000105154:	08 00 00 
 80000105157:	b0 00                	mov    $0x0,%al
 80000105159:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000105160:	08 00 00 
 80000105163:	ff d2                	call   *%rdx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
 80000105165:	48 81 c3 e0 00 00 00 	add    $0xe0,%rbx
 8000010516c:	48 b8 c8 de 11 00 00 	movabs $0x8000011dec8,%rax
 80000105173:	08 00 00 
 80000105176:	48 39 c3             	cmp    %rax,%rbx
 80000105179:	0f 83 88 00 00 00    	jae    80000105207 <procdump+0x104>
    if(p->state == UNUSED)
 8000010517f:	8b 43 18             	mov    0x18(%rbx),%eax
 80000105182:	85 c0                	test   %eax,%eax
 80000105184:	74 df                	je     80000105165 <procdump+0x62>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
 80000105186:	83 f8 05             	cmp    $0x5,%eax
 80000105189:	77 8f                	ja     8000010511a <procdump+0x17>
 8000010518b:	89 c0                	mov    %eax,%eax
 8000010518d:	48 ba 20 b4 10 00 00 	movabs $0x8000010b420,%rdx
 80000105194:	08 00 00 
 80000105197:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
 8000010519b:	48 85 d2             	test   %rdx,%rdx
 8000010519e:	75 84                	jne    80000105124 <procdump+0x21>
      state = "???";
 800001051a0:	48 ba a1 ac 10 00 00 	movabs $0x8000010aca1,%rdx
 800001051a7:	08 00 00 
 800001051aa:	e9 75 ff ff ff       	jmp    80000105124 <procdump+0x21>
      getcallerpcs((uint64*)p->context->rbp, pc);
 800001051af:	48 8b 43 30          	mov    0x30(%rbx),%rax
 800001051b3:	48 8b 78 28          	mov    0x28(%rax),%rdi
 800001051b7:	48 8d 75 a0          	lea    -0x60(%rbp),%rsi
 800001051bb:	48 b8 73 53 10 00 00 	movabs $0x80000105373,%rax
 800001051c2:	08 00 00 
 800001051c5:	ff d0                	call   *%rax
      for(i=0; i<10 && pc[i] != 0; i++)
 800001051c7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 800001051cd:	eb 1c                	jmp    800001051eb <procdump+0xe8>
        cprintf(" %p", pc[i]);
 800001051cf:	48 bf e1 a9 10 00 00 	movabs $0x8000010a9e1,%rdi
 800001051d6:	08 00 00 
 800001051d9:	b0 00                	mov    $0x0,%al
 800001051db:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 800001051e2:	08 00 00 
 800001051e5:	ff d2                	call   *%rdx
      for(i=0; i<10 && pc[i] != 0; i++)
 800001051e7:	41 83 c4 01          	add    $0x1,%r12d
 800001051eb:	41 83 fc 09          	cmp    $0x9,%r12d
 800001051ef:	0f 8f 58 ff ff ff    	jg     8000010514d <procdump+0x4a>
 800001051f5:	49 63 c4             	movslq %r12d,%rax
 800001051f8:	48 8b 74 c5 a0       	mov    -0x60(%rbp,%rax,8),%rsi
 800001051fd:	48 85 f6             	test   %rsi,%rsi
 80000105200:	75 cd                	jne    800001051cf <procdump+0xcc>
 80000105202:	e9 46 ff ff ff       	jmp    8000010514d <procdump+0x4a>
  }
}
 80000105207:	48 83 c4 50          	add    $0x50,%rsp
 8000010520b:	5b                   	pop    %rbx
 8000010520c:	41 5c                	pop    %r12
 8000010520e:	5d                   	pop    %rbp
 8000010520f:	c3                   	ret

0000080000105210 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
 80000105210:	55                   	push   %rbp
 80000105211:	48 89 e5             	mov    %rsp,%rbp
 80000105214:	41 54                	push   %r12
 80000105216:	53                   	push   %rbx
 80000105217:	48 89 fb             	mov    %rdi,%rbx
 8000010521a:	49 89 f4             	mov    %rsi,%r12
  initlock(&lk->lk, "sleep lock");
 8000010521d:	48 8d 7f 08          	lea    0x8(%rdi),%rdi
 80000105221:	48 be d8 ac 10 00 00 	movabs $0x8000010acd8,%rsi
 80000105228:	08 00 00 
 8000010522b:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 80000105232:	08 00 00 
 80000105235:	ff d0                	call   *%rax
  lk->name = name;
 80000105237:	4c 89 63 70          	mov    %r12,0x70(%rbx)
  lk->locked = 0;
 8000010523b:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  lk->pid = 0;
 80000105241:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%rbx)
}
 80000105248:	5b                   	pop    %rbx
 80000105249:	41 5c                	pop    %r12
 8000010524b:	5d                   	pop    %rbp
 8000010524c:	c3                   	ret

000008000010524d <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
 8000010524d:	55                   	push   %rbp
 8000010524e:	48 89 e5             	mov    %rsp,%rbp
 80000105251:	41 54                	push   %r12
 80000105253:	53                   	push   %rbx
 80000105254:	48 89 fb             	mov    %rdi,%rbx
  acquire(&lk->lk);
 80000105257:	4c 8d 67 08          	lea    0x8(%rdi),%r12
 8000010525b:	4c 89 e7             	mov    %r12,%rdi
 8000010525e:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000105265:	08 00 00 
 80000105268:	ff d0                	call   *%rax
  while (lk->locked) {
 8000010526a:	eb 12                	jmp    8000010527e <acquiresleep+0x31>
    sleep(lk, &lk->lk);
 8000010526c:	4c 89 e6             	mov    %r12,%rsi
 8000010526f:	48 89 df             	mov    %rbx,%rdi
 80000105272:	48 b8 03 4e 10 00 00 	movabs $0x80000104e03,%rax
 80000105279:	08 00 00 
 8000010527c:	ff d0                	call   *%rax
  while (lk->locked) {
 8000010527e:	83 3b 00             	cmpl   $0x0,(%rbx)
 80000105281:	75 e9                	jne    8000010526c <acquiresleep+0x1f>
  }
  lk->locked = 1;
 80000105283:	c7 03 01 00 00 00    	movl   $0x1,(%rbx)
  lk->pid = myproc()->pid;
 80000105289:	b0 00                	mov    $0x0,%al
 8000010528b:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000105292:	08 00 00 
 80000105295:	ff d2                	call   *%rdx
 80000105297:	8b 40 1c             	mov    0x1c(%rax),%eax
 8000010529a:	89 43 78             	mov    %eax,0x78(%rbx)
  release(&lk->lk);
 8000010529d:	4c 89 e7             	mov    %r12,%rdi
 800001052a0:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001052a7:	08 00 00 
 800001052aa:	ff d0                	call   *%rax
}
 800001052ac:	5b                   	pop    %rbx
 800001052ad:	41 5c                	pop    %r12
 800001052af:	5d                   	pop    %rbp
 800001052b0:	c3                   	ret

00000800001052b1 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
 800001052b1:	55                   	push   %rbp
 800001052b2:	48 89 e5             	mov    %rsp,%rbp
 800001052b5:	41 54                	push   %r12
 800001052b7:	53                   	push   %rbx
 800001052b8:	48 89 fb             	mov    %rdi,%rbx
  acquire(&lk->lk);
 800001052bb:	4c 8d 67 08          	lea    0x8(%rdi),%r12
 800001052bf:	4c 89 e7             	mov    %r12,%rdi
 800001052c2:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 800001052c9:	08 00 00 
 800001052cc:	ff d0                	call   *%rax
  lk->locked = 0;
 800001052ce:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  lk->pid = 0;
 800001052d4:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%rbx)
  wakeup(lk);
 800001052db:	48 89 df             	mov    %rbx,%rdi
 800001052de:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 800001052e5:	08 00 00 
 800001052e8:	ff d0                	call   *%rax
  release(&lk->lk);
 800001052ea:	4c 89 e7             	mov    %r12,%rdi
 800001052ed:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 800001052f4:	08 00 00 
 800001052f7:	ff d0                	call   *%rax
}
 800001052f9:	5b                   	pop    %rbx
 800001052fa:	41 5c                	pop    %r12
 800001052fc:	5d                   	pop    %rbp
 800001052fd:	c3                   	ret

00000800001052fe <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
 800001052fe:	55                   	push   %rbp
 800001052ff:	48 89 e5             	mov    %rsp,%rbp
 80000105302:	41 54                	push   %r12
 80000105304:	53                   	push   %rbx
 80000105305:	48 89 fb             	mov    %rdi,%rbx
  int r;
  
  acquire(&lk->lk);
 80000105308:	4c 8d 67 08          	lea    0x8(%rdi),%r12
 8000010530c:	4c 89 e7             	mov    %r12,%rdi
 8000010530f:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000105316:	08 00 00 
 80000105319:	ff d0                	call   *%rax
  r = lk->locked && (lk->pid == myproc()->pid);
 8000010531b:	83 3b 00             	cmpl   $0x0,(%rbx)
 8000010531e:	75 1b                	jne    8000010533b <holdingsleep+0x3d>
 80000105320:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
 80000105325:	4c 89 e7             	mov    %r12,%rdi
 80000105328:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 8000010532f:	08 00 00 
 80000105332:	ff d0                	call   *%rax
  return r;
}
 80000105334:	89 d8                	mov    %ebx,%eax
 80000105336:	5b                   	pop    %rbx
 80000105337:	41 5c                	pop    %r12
 80000105339:	5d                   	pop    %rbp
 8000010533a:	c3                   	ret
  r = lk->locked && (lk->pid == myproc()->pid);
 8000010533b:	8b 5b 78             	mov    0x78(%rbx),%ebx
 8000010533e:	b0 00                	mov    $0x0,%al
 80000105340:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000105347:	08 00 00 
 8000010534a:	ff d2                	call   *%rdx
 8000010534c:	3b 58 1c             	cmp    0x1c(%rax),%ebx
 8000010534f:	74 07                	je     80000105358 <holdingsleep+0x5a>
 80000105351:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000105356:	eb cd                	jmp    80000105325 <holdingsleep+0x27>
 80000105358:	bb 01 00 00 00       	mov    $0x1,%ebx
 8000010535d:	eb c6                	jmp    80000105325 <holdingsleep+0x27>
 8000010535f:	90                   	nop

0000080000105360 <initlock>:
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
 80000105360:	48 89 77 08          	mov    %rsi,0x8(%rdi)
  lk->locked = 0;
 80000105364:	c7 07 00 00 00 00    	movl   $0x0,(%rdi)
  lk->cpu = 0;
 8000010536a:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
 80000105371:	00 
}
 80000105372:	c3                   	ret

0000080000105373 <getcallerpcs>:
void
getcallerpcs(uint64 *rbp, uint64 pcs[])
{
  int i;

  for(i = 0; i < 10; i++){
 80000105373:	b8 00 00 00 00       	mov    $0x0,%eax
 80000105378:	83 f8 09             	cmp    $0x9,%eax
 8000010537b:	7f 51                	jg     800001053ce <getcallerpcs+0x5b>
    if(rbp == 0 || rbp < (uint64*)KERNBASE 
                || rbp == (uint64*)0xffffffffffffffff)
 8000010537d:	48 ba 00 00 00 00 00 	movabs $0xfffff80000000000,%rdx
 80000105384:	f8 ff ff 
 80000105387:	48 01 fa             	add    %rdi,%rdx
    if(rbp == 0 || rbp < (uint64*)KERNBASE 
 8000010538a:	48 b9 fe ff ff ff ff 	movabs $0xfffff7fffffffffe,%rcx
 80000105391:	f7 ff ff 
 80000105394:	48 39 d1             	cmp    %rdx,%rcx
 80000105397:	72 35                	jb     800001053ce <getcallerpcs+0x5b>
      break;
    pcs[i] = rbp[1];       // saved %rip
 80000105399:	48 63 d0             	movslq %eax,%rdx
 8000010539c:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
 800001053a0:	48 89 0c d6          	mov    %rcx,(%rsi,%rdx,8)
    rbp = (uint64*)rbp[0]; // saved %rbp
 800001053a4:	48 8b 3f             	mov    (%rdi),%rdi
  for(i = 0; i < 10; i++){
 800001053a7:	83 c0 01             	add    $0x1,%eax
 800001053aa:	eb cc                	jmp    80000105378 <getcallerpcs+0x5>
 800001053ac:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 800001053b3:	00 00 00 00 
 800001053b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 800001053be:	00 00 
  }
  for(; i < 10; i++)
    pcs[i] = 0;
 800001053c0:	48 63 d0             	movslq %eax,%rdx
 800001053c3:	48 c7 04 d6 00 00 00 	movq   $0x0,(%rsi,%rdx,8)
 800001053ca:	00 
  for(; i < 10; i++)
 800001053cb:	83 c0 01             	add    $0x1,%eax
 800001053ce:	83 f8 09             	cmp    $0x9,%eax
 800001053d1:	7e ed                	jle    800001053c0 <getcallerpcs+0x4d>
}
 800001053d3:	c3                   	ret

00000800001053d4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
 800001053d4:	55                   	push   %rbp
 800001053d5:	48 89 e5             	mov    %rsp,%rbp
 800001053d8:	53                   	push   %rbx
 800001053d9:	48 83 ec 08          	sub    $0x8,%rsp
 800001053dd:	9c                   	pushf
 800001053de:	5b                   	pop    %rbx
    asm volatile("cli");
 800001053df:	fa                   	cli
  int64 rflags;

  rflags = readrflags();
  cli();
  if(mycpu()->ncli == 0)
 800001053e0:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 800001053e7:	08 00 00 
 800001053ea:	ff d0                	call   *%rax
 800001053ec:	83 b8 b8 00 00 00 00 	cmpl   $0x0,0xb8(%rax)
 800001053f3:	74 22                	je     80000105417 <pushcli+0x43>
    mycpu()->intena = rflags & FL_IF;
  mycpu()->ncli += 1;
 800001053f5:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 800001053fc:	08 00 00 
 800001053ff:	ff d0                	call   *%rax
 80000105401:	8b 88 b8 00 00 00    	mov    0xb8(%rax),%ecx
 80000105407:	8d 51 01             	lea    0x1(%rcx),%edx
 8000010540a:	89 90 b8 00 00 00    	mov    %edx,0xb8(%rax)
}
 80000105410:	48 83 c4 08          	add    $0x8,%rsp
 80000105414:	5b                   	pop    %rbx
 80000105415:	5d                   	pop    %rbp
 80000105416:	c3                   	ret
    mycpu()->intena = rflags & FL_IF;
 80000105417:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 8000010541e:	08 00 00 
 80000105421:	ff d0                	call   *%rax
 80000105423:	81 e3 00 02 00 00    	and    $0x200,%ebx
 80000105429:	89 98 bc 00 00 00    	mov    %ebx,0xbc(%rax)
 8000010542f:	eb c4                	jmp    800001053f5 <pushcli+0x21>

0000080000105431 <popcli>:

void
popcli(void)
{
 80000105431:	55                   	push   %rbp
 80000105432:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("pushfq; popq %0" : "=r" (rflags));
 80000105435:	9c                   	pushf
 80000105436:	58                   	pop    %rax
  if(readrflags()&FL_IF)
 80000105437:	f6 c4 02             	test   $0x2,%ah
 8000010543a:	75 36                	jne    80000105472 <popcli+0x41>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
 8000010543c:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000105443:	08 00 00 
 80000105446:	ff d0                	call   *%rax
 80000105448:	8b 88 b8 00 00 00    	mov    0xb8(%rax),%ecx
 8000010544e:	8d 51 ff             	lea    -0x1(%rcx),%edx
 80000105451:	89 90 b8 00 00 00    	mov    %edx,0xb8(%rax)
 80000105457:	85 d2                	test   %edx,%edx
 80000105459:	78 2d                	js     80000105488 <popcli+0x57>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
 8000010545b:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000105462:	08 00 00 
 80000105465:	ff d0                	call   *%rax
 80000105467:	83 b8 b8 00 00 00 00 	cmpl   $0x0,0xb8(%rax)
 8000010546e:	74 2e                	je     8000010549e <popcli+0x6d>
    sti();
}
 80000105470:	5d                   	pop    %rbp
 80000105471:	c3                   	ret
    panic("popcli - interruptible");
 80000105472:	48 bf e3 ac 10 00 00 	movabs $0x8000010ace3,%rdi
 80000105479:	08 00 00 
 8000010547c:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000105483:	08 00 00 
 80000105486:	ff d0                	call   *%rax
    panic("popcli");
 80000105488:	48 bf fa ac 10 00 00 	movabs $0x8000010acfa,%rdi
 8000010548f:	08 00 00 
 80000105492:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000105499:	08 00 00 
 8000010549c:	ff d0                	call   *%rax
  if(mycpu()->ncli == 0 && mycpu()->intena)
 8000010549e:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 800001054a5:	08 00 00 
 800001054a8:	ff d0                	call   *%rax
 800001054aa:	83 b8 bc 00 00 00 00 	cmpl   $0x0,0xbc(%rax)
 800001054b1:	74 bd                	je     80000105470 <popcli+0x3f>
    asm volatile("sti");
 800001054b3:	fb                   	sti
}
 800001054b4:	eb ba                	jmp    80000105470 <popcli+0x3f>

00000800001054b6 <holding>:
{
 800001054b6:	55                   	push   %rbp
 800001054b7:	48 89 e5             	mov    %rsp,%rbp
 800001054ba:	53                   	push   %rbx
 800001054bb:	48 83 ec 08          	sub    $0x8,%rsp
 800001054bf:	48 89 fb             	mov    %rdi,%rbx
  pushcli();
 800001054c2:	48 b8 d4 53 10 00 00 	movabs $0x800001053d4,%rax
 800001054c9:	08 00 00 
 800001054cc:	ff d0                	call   *%rax
  r = lock->locked && lock->cpu == mycpu();
 800001054ce:	83 3b 00             	cmpl   $0x0,(%rbx)
 800001054d1:	75 1a                	jne    800001054ed <holding+0x37>
 800001054d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
 800001054d8:	48 b8 31 54 10 00 00 	movabs $0x80000105431,%rax
 800001054df:	08 00 00 
 800001054e2:	ff d0                	call   *%rax
}
 800001054e4:	89 d8                	mov    %ebx,%eax
 800001054e6:	48 83 c4 08          	add    $0x8,%rsp
 800001054ea:	5b                   	pop    %rbx
 800001054eb:	5d                   	pop    %rbp
 800001054ec:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
 800001054ed:	48 8b 5b 10          	mov    0x10(%rbx),%rbx
 800001054f1:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 800001054f8:	08 00 00 
 800001054fb:	ff d0                	call   *%rax
 800001054fd:	48 39 c3             	cmp    %rax,%rbx
 80000105500:	74 07                	je     80000105509 <holding+0x53>
 80000105502:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000105507:	eb cf                	jmp    800001054d8 <holding+0x22>
 80000105509:	bb 01 00 00 00       	mov    $0x1,%ebx
 8000010550e:	eb c8                	jmp    800001054d8 <holding+0x22>

0000080000105510 <acquire>:
{
 80000105510:	55                   	push   %rbp
 80000105511:	48 89 e5             	mov    %rsp,%rbp
 80000105514:	53                   	push   %rbx
 80000105515:	48 83 ec 08          	sub    $0x8,%rsp
 80000105519:	48 89 fb             	mov    %rdi,%rbx
  pushcli(); // disable interrupts to avoid deadlock.
 8000010551c:	48 b8 d4 53 10 00 00 	movabs $0x800001053d4,%rax
 80000105523:	08 00 00 
 80000105526:	ff d0                	call   *%rax
  if(holding(lk))
 80000105528:	48 89 df             	mov    %rbx,%rdi
 8000010552b:	48 b8 b6 54 10 00 00 	movabs $0x800001054b6,%rax
 80000105532:	08 00 00 
 80000105535:	ff d0                	call   *%rax
 80000105537:	85 c0                	test   %eax,%eax
 80000105539:	75 39                	jne    80000105574 <acquire+0x64>
    asm volatile("lock; xchgl %0, %1" :
 8000010553b:	b8 01 00 00 00       	mov    $0x1,%eax
 80000105540:	f0 87 03             	lock xchg %eax,(%rbx)
  while(xchg(&lk->locked, 1) != 0)
 80000105543:	85 c0                	test   %eax,%eax
 80000105545:	75 f4                	jne    8000010553b <acquire+0x2b>
  __sync_synchronize();
 80000105547:	0f ae f0             	mfence
  lk->cpu = mycpu();
 8000010554a:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000105551:	08 00 00 
 80000105554:	ff d0                	call   *%rax
 80000105556:	48 89 43 10          	mov    %rax,0x10(%rbx)
  getcallerpcs((uint64*) rrbp(), lk->pcs);
 8000010555a:	48 8d 73 18          	lea    0x18(%rbx),%rsi
  asm volatile("movq %%rbp,%0" : "=r" (val));
 8000010555e:	48 89 ef             	mov    %rbp,%rdi
 80000105561:	48 b8 73 53 10 00 00 	movabs $0x80000105373,%rax
 80000105568:	08 00 00 
 8000010556b:	ff d0                	call   *%rax
}
 8000010556d:	48 83 c4 08          	add    $0x8,%rsp
 80000105571:	5b                   	pop    %rbx
 80000105572:	5d                   	pop    %rbp
 80000105573:	c3                   	ret
    panic("acquire");
 80000105574:	48 bf 01 ad 10 00 00 	movabs $0x8000010ad01,%rdi
 8000010557b:	08 00 00 
 8000010557e:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000105585:	08 00 00 
 80000105588:	ff d0                	call   *%rax

000008000010558a <release>:
{
 8000010558a:	55                   	push   %rbp
 8000010558b:	48 89 e5             	mov    %rsp,%rbp
 8000010558e:	53                   	push   %rbx
 8000010558f:	48 83 ec 08          	sub    $0x8,%rsp
 80000105593:	48 89 fb             	mov    %rdi,%rbx
  if(!holding(lk))
 80000105596:	48 b8 b6 54 10 00 00 	movabs $0x800001054b6,%rax
 8000010559d:	08 00 00 
 800001055a0:	ff d0                	call   *%rax
 800001055a2:	85 c0                	test   %eax,%eax
 800001055a4:	74 2c                	je     800001055d2 <release+0x48>
  lk->pcs[0] = 0;
 800001055a6:	48 c7 43 18 00 00 00 	movq   $0x0,0x18(%rbx)
 800001055ad:	00 
  lk->cpu = 0;
 800001055ae:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
 800001055b5:	00 
  __sync_synchronize();
 800001055b6:	0f ae f0             	mfence
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
 800001055b9:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  popcli();
 800001055bf:	48 b8 31 54 10 00 00 	movabs $0x80000105431,%rax
 800001055c6:	08 00 00 
 800001055c9:	ff d0                	call   *%rax
}
 800001055cb:	48 83 c4 08          	add    $0x8,%rsp
 800001055cf:	5b                   	pop    %rbx
 800001055d0:	5d                   	pop    %rbp
 800001055d1:	c3                   	ret
    panic("release");
 800001055d2:	48 bf 09 ad 10 00 00 	movabs $0x8000010ad09,%rdi
 800001055d9:	08 00 00 
 800001055dc:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001055e3:	08 00 00 
 800001055e6:	ff d0                	call   *%rax
 800001055e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001055ef:	00 00 00 
 800001055f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001055f9:	00 00 00 
 800001055fc:	0f 1f 40 00          	nopl   0x0(%rax)

0000080000105600 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
 80000105600:	49 89 f8             	mov    %rdi,%r8
 80000105603:	89 f0                	mov    %esi,%eax
 80000105605:	89 d1                	mov    %edx,%ecx
  if ((int64)dst%4 == 0 && n%4 == 0){
 80000105607:	40 f6 c7 03          	test   $0x3,%dil
 8000010560b:	75 24                	jne    80000105631 <memset+0x31>
 8000010560d:	f6 c2 03             	test   $0x3,%dl
 80000105610:	75 1f                	jne    80000105631 <memset+0x31>
    c &= 0xFF;
 80000105612:	40 0f b6 d6          	movzbl %sil,%edx
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
 80000105616:	c1 e9 02             	shr    $0x2,%ecx
 80000105619:	c1 e0 18             	shl    $0x18,%eax
 8000010561c:	89 d6                	mov    %edx,%esi
 8000010561e:	c1 e6 10             	shl    $0x10,%esi
 80000105621:	09 f0                	or     %esi,%eax
 80000105623:	89 d6                	mov    %edx,%esi
 80000105625:	c1 e6 08             	shl    $0x8,%esi
 80000105628:	09 f0                	or     %esi,%eax
 8000010562a:	09 d0                	or     %edx,%eax
    asm volatile("cld; rep stosl" :
 8000010562c:	fc                   	cld
 8000010562d:	f3 ab                	rep stos %eax,%es:(%rdi)
}
 8000010562f:	eb 06                	jmp    80000105637 <memset+0x37>
    asm volatile("cld; rep stosb" :
 80000105631:	4c 89 c7             	mov    %r8,%rdi
 80000105634:	fc                   	cld
 80000105635:	f3 aa                	rep stos %al,%es:(%rdi)
  } else
    stosb(dst, c, n);
  return dst;
}
 80000105637:	4c 89 c0             	mov    %r8,%rax
 8000010563a:	c3                   	ret

000008000010563b <memcmp>:
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
 8000010563b:	eb 0d                	jmp    8000010564a <memcmp+0xf>
 8000010563d:	0f 1f 00             	nopl   (%rax)
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
 80000105640:	48 83 c7 01          	add    $0x1,%rdi
 80000105644:	48 83 c6 01          	add    $0x1,%rsi
  while(n-- > 0){
 80000105648:	89 ca                	mov    %ecx,%edx
 8000010564a:	8d 4a ff             	lea    -0x1(%rdx),%ecx
 8000010564d:	85 d2                	test   %edx,%edx
 8000010564f:	74 18                	je     80000105669 <memcmp+0x2e>
    if(*s1 != *s2)
 80000105651:	8a 07                	mov    (%rdi),%al
 80000105653:	8a 16                	mov    (%rsi),%dl
 80000105655:	44 0f b6 c8          	movzbl %al,%r9d
 80000105659:	44 0f b6 c2          	movzbl %dl,%r8d
 8000010565d:	45 39 c1             	cmp    %r8d,%r9d
 80000105660:	74 de                	je     80000105640 <memcmp+0x5>
      return *s1 - *s2;
 80000105662:	44 89 c8             	mov    %r9d,%eax
 80000105665:	44 29 c0             	sub    %r8d,%eax
 80000105668:	c3                   	ret
  }

  return 0;
 80000105669:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8000010566e:	c3                   	ret

000008000010566f <memmove>:
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
 8000010566f:	48 39 fe             	cmp    %rdi,%rsi
 80000105672:	73 65                	jae    800001056d9 <memmove+0x6a>
 80000105674:	89 d0                	mov    %edx,%eax
 80000105676:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
 8000010567a:	48 39 cf             	cmp    %rcx,%rdi
 8000010567d:	73 5f                	jae    800001056de <memmove+0x6f>
    s += n;
    d += n;
 8000010567f:	48 01 f8             	add    %rdi,%rax
    while(n-- > 0)
 80000105682:	eb 2a                	jmp    800001056ae <memmove+0x3f>
 80000105684:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 8000010568b:	00 00 00 00 
 8000010568f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000105696:	00 00 00 00 
 8000010569a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
      *--d = *--s;
 800001056a0:	48 83 e9 01          	sub    $0x1,%rcx
 800001056a4:	48 83 e8 01          	sub    $0x1,%rax
 800001056a8:	8a 11                	mov    (%rcx),%dl
 800001056aa:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
 800001056ac:	89 f2                	mov    %esi,%edx
 800001056ae:	8d 72 ff             	lea    -0x1(%rdx),%esi
 800001056b1:	85 d2                	test   %edx,%edx
 800001056b3:	75 eb                	jne    800001056a0 <memmove+0x31>
 800001056b5:	eb 1e                	jmp    800001056d5 <memmove+0x66>
 800001056b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 800001056be:	00 00 
  } else
    while(n-- > 0)
      *d++ = *s++;
 800001056c0:	8a 16                	mov    (%rsi),%dl
 800001056c2:	88 10                	mov    %dl,(%rax)
 800001056c4:	48 8d 40 01          	lea    0x1(%rax),%rax
 800001056c8:	48 8d 76 01          	lea    0x1(%rsi),%rsi
    while(n-- > 0)
 800001056cc:	89 ca                	mov    %ecx,%edx
 800001056ce:	8d 4a ff             	lea    -0x1(%rdx),%ecx
 800001056d1:	85 d2                	test   %edx,%edx
 800001056d3:	75 eb                	jne    800001056c0 <memmove+0x51>

  return dst;
}
 800001056d5:	48 89 f8             	mov    %rdi,%rax
 800001056d8:	c3                   	ret
 800001056d9:	48 89 f8             	mov    %rdi,%rax
 800001056dc:	eb f0                	jmp    800001056ce <memmove+0x5f>
 800001056de:	48 89 f8             	mov    %rdi,%rax
 800001056e1:	eb eb                	jmp    800001056ce <memmove+0x5f>

00000800001056e3 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
 800001056e3:	55                   	push   %rbp
 800001056e4:	48 89 e5             	mov    %rsp,%rbp
  return memmove(dst, src, n);
 800001056e7:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 800001056ee:	08 00 00 
 800001056f1:	ff d0                	call   *%rax
}
 800001056f3:	5d                   	pop    %rbp
 800001056f4:	c3                   	ret

00000800001056f5 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 800001056f5:	eb 0b                	jmp    80000105702 <strncmp+0xd>
    n--, p++, q++;
 800001056f7:	83 ea 01             	sub    $0x1,%edx
 800001056fa:	48 83 c7 01          	add    $0x1,%rdi
 800001056fe:	48 83 c6 01          	add    $0x1,%rsi
  while(n > 0 && *p && *p == *q)
 80000105702:	85 d2                	test   %edx,%edx
 80000105704:	74 12                	je     80000105718 <strncmp+0x23>
 80000105706:	8a 07                	mov    (%rdi),%al
 80000105708:	0f be c8             	movsbl %al,%ecx
 8000010570b:	85 c9                	test   %ecx,%ecx
 8000010570d:	74 09                	je     80000105718 <strncmp+0x23>
 8000010570f:	89 c8                	mov    %ecx,%eax
 80000105711:	0f be 0e             	movsbl (%rsi),%ecx
 80000105714:	39 c8                	cmp    %ecx,%eax
 80000105716:	74 df                	je     800001056f7 <strncmp+0x2>
  if(n == 0)
 80000105718:	85 d2                	test   %edx,%edx
 8000010571a:	74 09                	je     80000105725 <strncmp+0x30>
    return 0;
  return (uchar)*p - (uchar)*q;
 8000010571c:	0f b6 07             	movzbl (%rdi),%eax
 8000010571f:	0f b6 16             	movzbl (%rsi),%edx
 80000105722:	29 d0                	sub    %edx,%eax
 80000105724:	c3                   	ret
    return 0;
 80000105725:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8000010572a:	c3                   	ret

000008000010572b <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
 8000010572b:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
 8000010572e:	48 89 f9             	mov    %rdi,%rcx
 80000105731:	eb 13                	jmp    80000105746 <strncpy+0x1b>
 80000105733:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 8000010573a:	00 00 00 00 
 8000010573e:	66 90                	xchg   %ax,%ax
 80000105740:	4c 89 ce             	mov    %r9,%rsi
 80000105743:	4c 89 c1             	mov    %r8,%rcx
 80000105746:	41 89 d0             	mov    %edx,%r8d
 80000105749:	83 ea 01             	sub    $0x1,%edx
 8000010574c:	45 85 c0             	test   %r8d,%r8d
 8000010574f:	7e 2f                	jle    80000105780 <strncpy+0x55>
 80000105751:	4c 8d 4e 01          	lea    0x1(%rsi),%r9
 80000105755:	4c 8d 41 01          	lea    0x1(%rcx),%r8
 80000105759:	40 8a 36             	mov    (%rsi),%sil
 8000010575c:	40 88 31             	mov    %sil,(%rcx)
 8000010575f:	40 0f be f6          	movsbl %sil,%esi
 80000105763:	85 f6                	test   %esi,%esi
 80000105765:	75 d9                	jne    80000105740 <strncpy+0x15>
 80000105767:	4c 89 c1             	mov    %r8,%rcx
 8000010576a:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000105771:	00 00 00 00 
 80000105775:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 8000010577c:	00 00 00 00 
    ;
  while(n-- > 0)
 80000105780:	8d 72 ff             	lea    -0x1(%rdx),%esi
 80000105783:	85 d2                	test   %edx,%edx
 80000105785:	7e 0b                	jle    80000105792 <strncpy+0x67>
    *s++ = 0;
 80000105787:	c6 01 00             	movb   $0x0,(%rcx)
  while(n-- > 0)
 8000010578a:	89 f2                	mov    %esi,%edx
    *s++ = 0;
 8000010578c:	48 8d 49 01          	lea    0x1(%rcx),%rcx
 80000105790:	eb ee                	jmp    80000105780 <strncpy+0x55>
  return os;
}
 80000105792:	c3                   	ret

0000080000105793 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
 80000105793:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  if(n <= 0)
 80000105796:	85 d2                	test   %edx,%edx
 80000105798:	7e 4e                	jle    800001057e8 <safestrcpy+0x55>
 8000010579a:	49 89 f8             	mov    %rdi,%r8
 8000010579d:	eb 27                	jmp    800001057c6 <safestrcpy+0x33>
 8000010579f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 800001057a6:	00 00 00 00 
 800001057aa:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 800001057b1:	00 00 00 00 
 800001057b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 800001057bc:	00 00 00 00 
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
 800001057c0:	4c 89 d6             	mov    %r10,%rsi
 800001057c3:	4d 89 c8             	mov    %r9,%r8
 800001057c6:	83 ea 01             	sub    $0x1,%edx
 800001057c9:	85 d2                	test   %edx,%edx
 800001057cb:	7e 17                	jle    800001057e4 <safestrcpy+0x51>
 800001057cd:	4c 8d 56 01          	lea    0x1(%rsi),%r10
 800001057d1:	4d 8d 48 01          	lea    0x1(%r8),%r9
 800001057d5:	8a 0e                	mov    (%rsi),%cl
 800001057d7:	41 88 08             	mov    %cl,(%r8)
 800001057da:	0f be c9             	movsbl %cl,%ecx
 800001057dd:	85 c9                	test   %ecx,%ecx
 800001057df:	75 df                	jne    800001057c0 <safestrcpy+0x2d>
 800001057e1:	4d 89 c8             	mov    %r9,%r8
    ;
  *s = 0;
 800001057e4:	41 c6 00 00          	movb   $0x0,(%r8)
  return os;
}
 800001057e8:	c3                   	ret

00000800001057e9 <strlen>:
int
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 800001057e9:	b8 00 00 00 00       	mov    $0x0,%eax
 800001057ee:	eb 03                	jmp    800001057f3 <strlen+0xa>
 800001057f0:	83 c0 01             	add    $0x1,%eax
 800001057f3:	48 63 d0             	movslq %eax,%rdx
 800001057f6:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
 800001057fa:	85 d2                	test   %edx,%edx
 800001057fc:	75 f2                	jne    800001057f0 <strlen+0x7>
    ;
  return n;
}
 800001057fe:	c3                   	ret

00000800001057ff <swtch>:
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  # Save old callee-saved registers
  pushq %rbp
 800001057ff:	55                   	push   %rbp
  pushq %rbx
 80000105800:	53                   	push   %rbx
  pushq %r12
 80000105801:	41 54                	push   %r12
  pushq %r13
 80000105803:	41 55                	push   %r13
  pushq %r14
 80000105805:	41 56                	push   %r14
  pushq %r15
 80000105807:	41 57                	push   %r15

  # Switch stacks
  movq %rsp, (%rdi)
 80000105809:	48 89 27             	mov    %rsp,(%rdi)
  movq %rsi, %rsp
 8000010580c:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-saved registers
  popq %r15
 8000010580f:	41 5f                	pop    %r15
  popq %r14
 80000105811:	41 5e                	pop    %r14
  popq %r13
 80000105813:	41 5d                	pop    %r13
  popq %r12
 80000105815:	41 5c                	pop    %r12
  popq %rbx
 80000105817:	5b                   	pop    %rbx
  popq %rbp
 80000105818:	5d                   	pop    %rbp
  ret
 80000105819:	c3                   	ret
 8000010581a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000080000105820 <fetchint>:
// to a saved program counter, and then the seventh argument.

// Fetch the int at addr from the current process.
int
fetchint(uint64 addr, int64 *ip)
{
 80000105820:	55                   	push   %rbp
 80000105821:	48 89 e5             	mov    %rsp,%rbp
 80000105824:	41 54                	push   %r12
 80000105826:	53                   	push   %rbx
 80000105827:	48 89 fb             	mov    %rdi,%rbx
 8000010582a:	49 89 f4             	mov    %rsi,%r12
  struct proc *curproc = myproc();
 8000010582d:	b0 00                	mov    $0x0,%al
 8000010582f:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000105836:	08 00 00 
 80000105839:	ff d2                	call   *%rdx

  if(addr >= curproc->sz || addr+8 > curproc->sz)
 8000010583b:	48 8b 00             	mov    (%rax),%rax
 8000010583e:	48 39 c3             	cmp    %rax,%rbx
 80000105841:	73 1a                	jae    8000010585d <fetchint+0x3d>
 80000105843:	48 8d 53 08          	lea    0x8(%rbx),%rdx
 80000105847:	48 39 d0             	cmp    %rdx,%rax
 8000010584a:	72 18                	jb     80000105864 <fetchint+0x44>
    return -1;
  *ip = *(int64*)(addr);
 8000010584c:	48 8b 03             	mov    (%rbx),%rax
 8000010584f:	49 89 04 24          	mov    %rax,(%r12)
  return 0;
 80000105853:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000105858:	5b                   	pop    %rbx
 80000105859:	41 5c                	pop    %r12
 8000010585b:	5d                   	pop    %rbp
 8000010585c:	c3                   	ret
    return -1;
 8000010585d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000105862:	eb f4                	jmp    80000105858 <fetchint+0x38>
 80000105864:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000105869:	eb ed                	jmp    80000105858 <fetchint+0x38>

000008000010586b <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint64 addr, char **pp)
{
 8000010586b:	55                   	push   %rbp
 8000010586c:	48 89 e5             	mov    %rsp,%rbp
 8000010586f:	41 54                	push   %r12
 80000105871:	53                   	push   %rbx
 80000105872:	48 89 fb             	mov    %rdi,%rbx
 80000105875:	49 89 f4             	mov    %rsi,%r12
  char *s, *ep;
  struct proc *curproc = myproc();
 80000105878:	b0 00                	mov    $0x0,%al
 8000010587a:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000105881:	08 00 00 
 80000105884:	ff d2                	call   *%rdx

  if(addr >= curproc->sz)
 80000105886:	48 3b 18             	cmp    (%rax),%rbx
 80000105889:	73 33                	jae    800001058be <fetchstr+0x53>
    return -1;
  *pp = (char*)addr;
 8000010588b:	49 89 1c 24          	mov    %rbx,(%r12)
  ep = (char*)curproc->sz;
 8000010588f:	48 8b 08             	mov    (%rax),%rcx
  for(s = *pp; s < ep; s++){
 80000105892:	48 89 d8             	mov    %rbx,%rax
 80000105895:	eb 0d                	jmp    800001058a4 <fetchstr+0x39>
 80000105897:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 8000010589e:	00 00 
 800001058a0:	48 83 c0 01          	add    $0x1,%rax
 800001058a4:	48 39 c8             	cmp    %rcx,%rax
 800001058a7:	73 0b                	jae    800001058b4 <fetchstr+0x49>
    if(*s == 0)
 800001058a9:	0f be 10             	movsbl (%rax),%edx
 800001058ac:	85 d2                	test   %edx,%edx
 800001058ae:	75 f0                	jne    800001058a0 <fetchstr+0x35>
      return s - *pp;
 800001058b0:	29 d8                	sub    %ebx,%eax
 800001058b2:	eb 05                	jmp    800001058b9 <fetchstr+0x4e>
  }
  return -1;
 800001058b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 800001058b9:	5b                   	pop    %rbx
 800001058ba:	41 5c                	pop    %r12
 800001058bc:	5d                   	pop    %rbp
 800001058bd:	c3                   	ret
    return -1;
 800001058be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 800001058c3:	eb f4                	jmp    800001058b9 <fetchstr+0x4e>

00000800001058c5 <argint64>:

// Fetch the nth 64-bit system call argument.
int
argint64(int n, int64 *ip)
{
 800001058c5:	55                   	push   %rbp
 800001058c6:	48 89 e5             	mov    %rsp,%rbp
 800001058c9:	41 54                	push   %r12
 800001058cb:	53                   	push   %rbx
 800001058cc:	89 fb                	mov    %edi,%ebx
 800001058ce:	49 89 f4             	mov    %rsi,%r12
  struct proc *curproc = myproc();
 800001058d1:	b0 00                	mov    $0x0,%al
 800001058d3:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 800001058da:	08 00 00 
 800001058dd:	ff d2                	call   *%rdx

  switch(n){
 800001058df:	83 fb 05             	cmp    $0x5,%ebx
 800001058e2:	0f 87 81 00 00 00    	ja     80000105969 <argint64+0xa4>
 800001058e8:	89 da                	mov    %ebx,%edx
 800001058ea:	48 b9 60 b4 10 00 00 	movabs $0x8000010b460,%rcx
 800001058f1:	08 00 00 
 800001058f4:	ff 24 d1             	jmp    *(%rcx,%rdx,8)
    case 0:
      *ip = curproc->tf->rdi;
 800001058f7:	48 8b 40 28          	mov    0x28(%rax),%rax
 800001058fb:	48 8b 40 30          	mov    0x30(%rax),%rax
 800001058ff:	49 89 04 24          	mov    %rax,(%r12)
      *ip = curproc->tf->r9;
      break;
    default:
      return fetchint((curproc->tf->rsp) + 8 + 8*(n-6), ip);
  }
  return 0;
 80000105903:	89 d8                	mov    %ebx,%eax
}
 80000105905:	5b                   	pop    %rbx
 80000105906:	41 5c                	pop    %r12
 80000105908:	5d                   	pop    %rbp
 80000105909:	c3                   	ret
      *ip = curproc->tf->rsi;
 8000010590a:	48 8b 40 28          	mov    0x28(%rax),%rax
 8000010590e:	48 8b 40 28          	mov    0x28(%rax),%rax
 80000105912:	49 89 04 24          	mov    %rax,(%r12)
  return 0;
 80000105916:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
 8000010591b:	eb e8                	jmp    80000105905 <argint64+0x40>
      *ip = curproc->tf->rdx;
 8000010591d:	48 8b 40 28          	mov    0x28(%rax),%rax
 80000105921:	48 8b 40 18          	mov    0x18(%rax),%rax
 80000105925:	49 89 04 24          	mov    %rax,(%r12)
  return 0;
 80000105929:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
 8000010592e:	eb d5                	jmp    80000105905 <argint64+0x40>
      *ip = curproc->tf->rcx;
 80000105930:	48 8b 40 28          	mov    0x28(%rax),%rax
 80000105934:	48 8b 40 10          	mov    0x10(%rax),%rax
 80000105938:	49 89 04 24          	mov    %rax,(%r12)
  return 0;
 8000010593c:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
 80000105941:	eb c2                	jmp    80000105905 <argint64+0x40>
      *ip = curproc->tf->r8;
 80000105943:	48 8b 40 28          	mov    0x28(%rax),%rax
 80000105947:	48 8b 40 38          	mov    0x38(%rax),%rax
 8000010594b:	49 89 04 24          	mov    %rax,(%r12)
  return 0;
 8000010594f:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
 80000105954:	eb af                	jmp    80000105905 <argint64+0x40>
      *ip = curproc->tf->r9;
 80000105956:	48 8b 40 28          	mov    0x28(%rax),%rax
 8000010595a:	48 8b 40 40          	mov    0x40(%rax),%rax
 8000010595e:	49 89 04 24          	mov    %rax,(%r12)
  return 0;
 80000105962:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
 80000105967:	eb 9c                	jmp    80000105905 <argint64+0x40>
      return fetchint((curproc->tf->rsp) + 8 + 8*(n-6), ip);
 80000105969:	48 8b 40 28          	mov    0x28(%rax),%rax
 8000010596d:	8d 3c dd d0 ff ff ff 	lea    -0x30(,%rbx,8),%edi
 80000105974:	48 63 ff             	movslq %edi,%rdi
 80000105977:	48 03 b8 a0 00 00 00 	add    0xa0(%rax),%rdi
 8000010597e:	48 83 c7 08          	add    $0x8,%rdi
 80000105982:	4c 89 e6             	mov    %r12,%rsi
 80000105985:	48 b8 20 58 10 00 00 	movabs $0x80000105820,%rax
 8000010598c:	08 00 00 
 8000010598f:	ff d0                	call   *%rax
 80000105991:	e9 6f ff ff ff       	jmp    80000105905 <argint64+0x40>

0000080000105996 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
 80000105996:	55                   	push   %rbp
 80000105997:	48 89 e5             	mov    %rsp,%rbp
 8000010599a:	53                   	push   %rbx
 8000010599b:	48 83 ec 18          	sub    $0x18,%rsp
 8000010599f:	48 89 f3             	mov    %rsi,%rbx
  int64 ip64;
  int status = argint64(n, &ip64);
 800001059a2:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
 800001059a6:	48 b8 c5 58 10 00 00 	movabs $0x800001058c5,%rax
 800001059ad:	08 00 00 
 800001059b0:	ff d0                	call   *%rax
  *ip = (int)ip64;
 800001059b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
 800001059b6:	89 13                	mov    %edx,(%rbx)
  return status;
}
 800001059b8:	48 83 c4 18          	add    $0x18,%rsp
 800001059bc:	5b                   	pop    %rbx
 800001059bd:	5d                   	pop    %rbp
 800001059be:	c3                   	ret

00000800001059bf <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
 800001059bf:	55                   	push   %rbp
 800001059c0:	48 89 e5             	mov    %rsp,%rbp
 800001059c3:	41 56                	push   %r14
 800001059c5:	41 55                	push   %r13
 800001059c7:	41 54                	push   %r12
 800001059c9:	53                   	push   %rbx
 800001059ca:	48 83 ec 10          	sub    $0x10,%rsp
 800001059ce:	41 89 fc             	mov    %edi,%r12d
 800001059d1:	49 89 f5             	mov    %rsi,%r13
 800001059d4:	89 d3                	mov    %edx,%ebx
  int64 i;
  struct proc *curproc = myproc();
 800001059d6:	b0 00                	mov    $0x0,%al
 800001059d8:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 800001059df:	08 00 00 
 800001059e2:	ff d2                	call   *%rdx
 800001059e4:	49 89 c6             	mov    %rax,%r14
 
  if(argint64(n, &i) < 0)
 800001059e7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
 800001059eb:	44 89 e7             	mov    %r12d,%edi
 800001059ee:	48 b8 c5 58 10 00 00 	movabs $0x800001058c5,%rax
 800001059f5:	08 00 00 
 800001059f8:	ff d0                	call   *%rax
 800001059fa:	85 c0                	test   %eax,%eax
 800001059fc:	78 31                	js     80000105a2f <argptr+0x70>
    return -1;
  if(size < 0 || (uint64)i >= curproc->sz || (uint64)i+size > curproc->sz)
 800001059fe:	85 db                	test   %ebx,%ebx
 80000105a00:	78 34                	js     80000105a36 <argptr+0x77>
 80000105a02:	49 8b 16             	mov    (%r14),%rdx
 80000105a05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
 80000105a09:	48 39 d0             	cmp    %rdx,%rax
 80000105a0c:	73 2f                	jae    80000105a3d <argptr+0x7e>
 80000105a0e:	48 63 db             	movslq %ebx,%rbx
 80000105a11:	48 01 c3             	add    %rax,%rbx
 80000105a14:	48 39 da             	cmp    %rbx,%rdx
 80000105a17:	72 2b                	jb     80000105a44 <argptr+0x85>
    return -1;
  *pp = (char*)i;
 80000105a19:	49 89 45 00          	mov    %rax,0x0(%r13)
  return 0;
 80000105a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000105a22:	48 83 c4 10          	add    $0x10,%rsp
 80000105a26:	5b                   	pop    %rbx
 80000105a27:	41 5c                	pop    %r12
 80000105a29:	41 5d                	pop    %r13
 80000105a2b:	41 5e                	pop    %r14
 80000105a2d:	5d                   	pop    %rbp
 80000105a2e:	c3                   	ret
    return -1;
 80000105a2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000105a34:	eb ec                	jmp    80000105a22 <argptr+0x63>
    return -1;
 80000105a36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000105a3b:	eb e5                	jmp    80000105a22 <argptr+0x63>
 80000105a3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000105a42:	eb de                	jmp    80000105a22 <argptr+0x63>
 80000105a44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000105a49:	eb d7                	jmp    80000105a22 <argptr+0x63>

0000080000105a4b <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
 80000105a4b:	55                   	push   %rbp
 80000105a4c:	48 89 e5             	mov    %rsp,%rbp
 80000105a4f:	53                   	push   %rbx
 80000105a50:	48 83 ec 18          	sub    $0x18,%rsp
 80000105a54:	48 89 f3             	mov    %rsi,%rbx
  int64 addr;
  if(argint64(n, &addr) < 0)
 80000105a57:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
 80000105a5b:	48 b8 c5 58 10 00 00 	movabs $0x800001058c5,%rax
 80000105a62:	08 00 00 
 80000105a65:	ff d0                	call   *%rax
 80000105a67:	85 c0                	test   %eax,%eax
 80000105a69:	78 1a                	js     80000105a85 <argstr+0x3a>
    return -1;
  return fetchstr(addr, pp);
 80000105a6b:	48 89 de             	mov    %rbx,%rsi
 80000105a6e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
 80000105a72:	48 b8 6b 58 10 00 00 	movabs $0x8000010586b,%rax
 80000105a79:	08 00 00 
 80000105a7c:	ff d0                	call   *%rax
}
 80000105a7e:	48 83 c4 18          	add    $0x18,%rsp
 80000105a82:	5b                   	pop    %rbx
 80000105a83:	5d                   	pop    %rbp
 80000105a84:	c3                   	ret
    return -1;
 80000105a85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000105a8a:	eb f2                	jmp    80000105a7e <argstr+0x33>

0000080000105a8c <syscall>:
[SYS_vmgetreg] sys_vmgetreg,
};

void
syscall(void)
{
 80000105a8c:	55                   	push   %rbp
 80000105a8d:	48 89 e5             	mov    %rsp,%rbp
 80000105a90:	41 54                	push   %r12
 80000105a92:	53                   	push   %rbx
  int num;
  struct proc *curproc = myproc();
 80000105a93:	b0 00                	mov    $0x0,%al
 80000105a95:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000105a9c:	08 00 00 
 80000105a9f:	ff d2                	call   *%rdx
 80000105aa1:	48 89 c3             	mov    %rax,%rbx

  num = curproc->tf->rax;
 80000105aa4:	4c 8b 60 28          	mov    0x28(%rax),%r12
 80000105aa8:	49 8b 04 24          	mov    (%r12),%rax
 80000105aac:	89 c1                	mov    %eax,%ecx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
 80000105aae:	8d 50 ff             	lea    -0x1(%rax),%edx
 80000105ab1:	83 fa 18             	cmp    $0x18,%edx
 80000105ab4:	77 1d                	ja     80000105ad3 <syscall+0x47>
 80000105ab6:	48 98                	cltq
 80000105ab8:	48 ba a0 b4 10 00 00 	movabs $0x8000010b4a0,%rdx
 80000105abf:	08 00 00 
 80000105ac2:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
 80000105ac6:	48 85 c0             	test   %rax,%rax
 80000105ac9:	74 08                	je     80000105ad3 <syscall+0x47>
    curproc->tf->rax = syscalls[num]();
 80000105acb:	ff d0                	call   *%rax
 80000105acd:	49 89 04 24          	mov    %rax,(%r12)
 80000105ad1:	eb 2e                	jmp    80000105b01 <syscall+0x75>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
 80000105ad3:	48 8d 93 d0 00 00 00 	lea    0xd0(%rbx),%rdx
    cprintf("%d %s: unknown sys call %d\n",
 80000105ada:	8b 73 1c             	mov    0x1c(%rbx),%esi
 80000105add:	48 bf 11 ad 10 00 00 	movabs $0x8000010ad11,%rdi
 80000105ae4:	08 00 00 
 80000105ae7:	b0 00                	mov    $0x0,%al
 80000105ae9:	49 b8 f9 08 10 00 00 	movabs $0x800001008f9,%r8
 80000105af0:	08 00 00 
 80000105af3:	41 ff d0             	call   *%r8
    curproc->tf->rax = -1;
 80000105af6:	48 8b 43 28          	mov    0x28(%rbx),%rax
 80000105afa:	48 c7 00 ff ff ff ff 	movq   $0xffffffffffffffff,(%rax)
  }
}
 80000105b01:	5b                   	pop    %rbx
 80000105b02:	41 5c                	pop    %r12
 80000105b04:	5d                   	pop    %rbp
 80000105b05:	c3                   	ret

0000080000105b06 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
 80000105b06:	55                   	push   %rbp
 80000105b07:	48 89 e5             	mov    %rsp,%rbp
 80000105b0a:	41 54                	push   %r12
 80000105b0c:	53                   	push   %rbx
 80000105b0d:	48 83 ec 10          	sub    $0x10,%rsp
 80000105b11:	49 89 f4             	mov    %rsi,%r12
 80000105b14:	48 89 d3             	mov    %rdx,%rbx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
 80000105b17:	48 8d 75 ec          	lea    -0x14(%rbp),%rsi
 80000105b1b:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 80000105b22:	08 00 00 
 80000105b25:	ff d0                	call   *%rax
 80000105b27:	85 c0                	test   %eax,%eax
 80000105b29:	78 4a                	js     80000105b75 <argfd+0x6f>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
 80000105b2b:	83 7d ec 0f          	cmpl   $0xf,-0x14(%rbp)
 80000105b2f:	77 3d                	ja     80000105b6e <argfd+0x68>
 80000105b31:	b0 00                	mov    $0x0,%al
 80000105b33:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000105b3a:	08 00 00 
 80000105b3d:	ff d2                	call   *%rdx
 80000105b3f:	8b 55 ec             	mov    -0x14(%rbp),%edx
 80000105b42:	48 63 ca             	movslq %edx,%rcx
 80000105b45:	48 8b 44 c8 48       	mov    0x48(%rax,%rcx,8),%rax
 80000105b4a:	48 85 c0             	test   %rax,%rax
 80000105b4d:	74 1f                	je     80000105b6e <argfd+0x68>
    return -1;
  if(pfd)
 80000105b4f:	4d 85 e4             	test   %r12,%r12
 80000105b52:	74 04                	je     80000105b58 <argfd+0x52>
    *pfd = fd;
 80000105b54:	41 89 14 24          	mov    %edx,(%r12)
  if(pf)
 80000105b58:	48 85 db             	test   %rbx,%rbx
 80000105b5b:	74 1f                	je     80000105b7c <argfd+0x76>
    *pf = f;
 80000105b5d:	48 89 03             	mov    %rax,(%rbx)
  return 0;
 80000105b60:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000105b65:	48 83 c4 10          	add    $0x10,%rsp
 80000105b69:	5b                   	pop    %rbx
 80000105b6a:	41 5c                	pop    %r12
 80000105b6c:	5d                   	pop    %rbp
 80000105b6d:	c3                   	ret
    return -1;
 80000105b6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000105b73:	eb f0                	jmp    80000105b65 <argfd+0x5f>
    return -1;
 80000105b75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000105b7a:	eb e9                	jmp    80000105b65 <argfd+0x5f>
  return 0;
 80000105b7c:	b8 00 00 00 00       	mov    $0x0,%eax
 80000105b81:	eb e2                	jmp    80000105b65 <argfd+0x5f>

0000080000105b83 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
 80000105b83:	55                   	push   %rbp
 80000105b84:	48 89 e5             	mov    %rsp,%rbp
 80000105b87:	53                   	push   %rbx
 80000105b88:	48 83 ec 08          	sub    $0x8,%rsp
 80000105b8c:	48 89 fb             	mov    %rdi,%rbx
  int fd;
  struct proc *curproc = myproc();
 80000105b8f:	b0 00                	mov    $0x0,%al
 80000105b91:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000105b98:	08 00 00 
 80000105b9b:	ff d2                	call   *%rdx
 80000105b9d:	48 89 c1             	mov    %rax,%rcx

  for(fd = 0; fd < NOFILE; fd++){
 80000105ba0:	b8 00 00 00 00       	mov    $0x0,%eax
 80000105ba5:	83 f8 0f             	cmp    $0xf,%eax
 80000105ba8:	7f 17                	jg     80000105bc1 <fdalloc+0x3e>
    if(curproc->ofile[fd] == 0){
 80000105baa:	48 63 d0             	movslq %eax,%rdx
 80000105bad:	48 83 7c d1 48 00    	cmpq   $0x0,0x48(%rcx,%rdx,8)
 80000105bb3:	74 05                	je     80000105bba <fdalloc+0x37>
  for(fd = 0; fd < NOFILE; fd++){
 80000105bb5:	83 c0 01             	add    $0x1,%eax
 80000105bb8:	eb eb                	jmp    80000105ba5 <fdalloc+0x22>
      curproc->ofile[fd] = f;
 80000105bba:	48 89 5c d1 48       	mov    %rbx,0x48(%rcx,%rdx,8)
      return fd;
 80000105bbf:	eb 05                	jmp    80000105bc6 <fdalloc+0x43>
    }
  }
  return -1;
 80000105bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 80000105bc6:	48 83 c4 08          	add    $0x8,%rsp
 80000105bca:	5b                   	pop    %rbx
 80000105bcb:	5d                   	pop    %rbp
 80000105bcc:	c3                   	ret

0000080000105bcd <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
 80000105bcd:	55                   	push   %rbp
 80000105bce:	48 89 e5             	mov    %rsp,%rbp
 80000105bd1:	41 54                	push   %r12
 80000105bd3:	53                   	push   %rbx
 80000105bd4:	48 83 ec 10          	sub    $0x10,%rsp
 80000105bd8:	49 89 fc             	mov    %rdi,%r12
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
 80000105bdb:	bb 20 00 00 00       	mov    $0x20,%ebx
 80000105be0:	41 3b 9c 24 9c 00 00 	cmp    0x9c(%r12),%ebx
 80000105be7:	00 
 80000105be8:	73 42                	jae    80000105c2c <isdirempty+0x5f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
 80000105bea:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
 80000105bee:	b9 10 00 00 00       	mov    $0x10,%ecx
 80000105bf3:	89 da                	mov    %ebx,%edx
 80000105bf5:	4c 89 e7             	mov    %r12,%rdi
 80000105bf8:	48 b8 bd 21 10 00 00 	movabs $0x800001021bd,%rax
 80000105bff:	08 00 00 
 80000105c02:	ff d0                	call   *%rax
 80000105c04:	83 f8 10             	cmp    $0x10,%eax
 80000105c07:	75 0d                	jne    80000105c16 <isdirempty+0x49>
      panic("isdirempty: readi");
    if(de.inum != 0)
 80000105c09:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
 80000105c0d:	85 c0                	test   %eax,%eax
 80000105c0f:	75 29                	jne    80000105c3a <isdirempty+0x6d>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
 80000105c11:	83 c3 10             	add    $0x10,%ebx
 80000105c14:	eb ca                	jmp    80000105be0 <isdirempty+0x13>
      panic("isdirempty: readi");
 80000105c16:	48 bf 2d ad 10 00 00 	movabs $0x8000010ad2d,%rdi
 80000105c1d:	08 00 00 
 80000105c20:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000105c27:	08 00 00 
 80000105c2a:	ff d0                	call   *%rax
      return 0;
  }
  return 1;
 80000105c2c:	b8 01 00 00 00       	mov    $0x1,%eax
}
 80000105c31:	48 83 c4 10          	add    $0x10,%rsp
 80000105c35:	5b                   	pop    %rbx
 80000105c36:	41 5c                	pop    %r12
 80000105c38:	5d                   	pop    %rbp
 80000105c39:	c3                   	ret
      return 0;
 80000105c3a:	b8 00 00 00 00       	mov    $0x0,%eax
 80000105c3f:	eb f0                	jmp    80000105c31 <isdirempty+0x64>

0000080000105c41 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
 80000105c41:	55                   	push   %rbp
 80000105c42:	48 89 e5             	mov    %rsp,%rbp
 80000105c45:	41 57                	push   %r15
 80000105c47:	41 56                	push   %r14
 80000105c49:	41 55                	push   %r13
 80000105c4b:	41 54                	push   %r12
 80000105c4d:	53                   	push   %rbx
 80000105c4e:	48 83 ec 18          	sub    $0x18,%rsp
 80000105c52:	41 89 f5             	mov    %esi,%r13d
 80000105c55:	41 89 d7             	mov    %edx,%r15d
 80000105c58:	41 89 ce             	mov    %ecx,%r14d
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
 80000105c5b:	48 8d 75 c2          	lea    -0x3e(%rbp),%rsi
 80000105c5f:	48 b8 e5 27 10 00 00 	movabs $0x800001027e5,%rax
 80000105c66:	08 00 00 
 80000105c69:	ff d0                	call   *%rax
 80000105c6b:	49 89 c4             	mov    %rax,%r12
 80000105c6e:	48 85 c0             	test   %rax,%rax
 80000105c71:	0f 84 c4 01 00 00    	je     80000105e3b <create+0x1fa>
    return 0;
  ilock(dp);
 80000105c77:	48 89 c7             	mov    %rax,%rdi
 80000105c7a:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 80000105c81:	08 00 00 
 80000105c84:	ff d0                	call   *%rax

  if((ip = dirlookup(dp, name, 0)) != 0){
 80000105c86:	48 8d 75 c2          	lea    -0x3e(%rbp),%rsi
 80000105c8a:	ba 00 00 00 00       	mov    $0x0,%edx
 80000105c8f:	4c 89 e7             	mov    %r12,%rdi
 80000105c92:	48 b8 a0 24 10 00 00 	movabs $0x800001024a0,%rax
 80000105c99:	08 00 00 
 80000105c9c:	ff d0                	call   *%rax
 80000105c9e:	48 89 c3             	mov    %rax,%rbx
 80000105ca1:	48 85 c0             	test   %rax,%rax
 80000105ca4:	74 5a                	je     80000105d00 <create+0xbf>
    iunlockput(dp);
 80000105ca6:	4c 89 e7             	mov    %r12,%rdi
 80000105ca9:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000105cb0:	08 00 00 
 80000105cb3:	ff d0                	call   *%rax
    ilock(ip);
 80000105cb5:	48 89 df             	mov    %rbx,%rdi
 80000105cb8:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 80000105cbf:	08 00 00 
 80000105cc2:	ff d0                	call   *%rax
    if(type == T_FILE && ip->type == T_FILE)
 80000105cc4:	45 0f bf ed          	movswl %r13w,%r13d
 80000105cc8:	41 83 fd 02          	cmp    $0x2,%r13d
 80000105ccc:	75 0c                	jne    80000105cda <create+0x99>
 80000105cce:	0f bf 83 94 00 00 00 	movswl 0x94(%rbx),%eax
 80000105cd5:	83 f8 02             	cmp    $0x2,%eax
 80000105cd8:	74 14                	je     80000105cee <create+0xad>
      return ip;
    iunlockput(ip);
 80000105cda:	48 89 df             	mov    %rbx,%rdi
 80000105cdd:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000105ce4:	08 00 00 
 80000105ce7:	ff d0                	call   *%rax
    return 0;
 80000105ce9:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
 80000105cee:	48 89 d8             	mov    %rbx,%rax
 80000105cf1:	48 83 c4 18          	add    $0x18,%rsp
 80000105cf5:	5b                   	pop    %rbx
 80000105cf6:	41 5c                	pop    %r12
 80000105cf8:	41 5d                	pop    %r13
 80000105cfa:	41 5e                	pop    %r14
 80000105cfc:	41 5f                	pop    %r15
 80000105cfe:	5d                   	pop    %rbp
 80000105cff:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
 80000105d00:	41 0f bf f5          	movswl %r13w,%esi
 80000105d04:	41 8b 3c 24          	mov    (%r12),%edi
 80000105d08:	48 b8 15 1c 10 00 00 	movabs $0x80000101c15,%rax
 80000105d0f:	08 00 00 
 80000105d12:	ff d0                	call   *%rax
 80000105d14:	48 89 c3             	mov    %rax,%rbx
 80000105d17:	48 85 c0             	test   %rax,%rax
 80000105d1a:	74 73                	je     80000105d8f <create+0x14e>
  ilock(ip);
 80000105d1c:	48 89 c7             	mov    %rax,%rdi
 80000105d1f:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 80000105d26:	08 00 00 
 80000105d29:	ff d0                	call   *%rax
  ip->major = major;
 80000105d2b:	66 44 89 bb 96 00 00 	mov    %r15w,0x96(%rbx)
 80000105d32:	00 
  ip->minor = minor;
 80000105d33:	66 44 89 b3 98 00 00 	mov    %r14w,0x98(%rbx)
 80000105d3a:	00 
  ip->nlink = 1;
 80000105d3b:	66 c7 83 9a 00 00 00 	movw   $0x1,0x9a(%rbx)
 80000105d42:	01 00 
  iupdate(ip);
 80000105d44:	48 89 df             	mov    %rbx,%rdi
 80000105d47:	48 b8 0a 1d 10 00 00 	movabs $0x80000101d0a,%rax
 80000105d4e:	08 00 00 
 80000105d51:	ff d0                	call   *%rax
  if(type == T_DIR){  // Create . and .. entries.
 80000105d53:	45 0f bf ed          	movswl %r13w,%r13d
 80000105d57:	41 83 fd 01          	cmp    $0x1,%r13d
 80000105d5b:	74 48                	je     80000105da5 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
 80000105d5d:	8b 53 04             	mov    0x4(%rbx),%edx
 80000105d60:	48 8d 75 c2          	lea    -0x3e(%rbp),%rsi
 80000105d64:	4c 89 e7             	mov    %r12,%rdi
 80000105d67:	48 b8 bf 26 10 00 00 	movabs $0x800001026bf,%rax
 80000105d6e:	08 00 00 
 80000105d71:	ff d0                	call   *%rax
 80000105d73:	85 c0                	test   %eax,%eax
 80000105d75:	0f 88 aa 00 00 00    	js     80000105e25 <create+0x1e4>
  iunlockput(dp);
 80000105d7b:	4c 89 e7             	mov    %r12,%rdi
 80000105d7e:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000105d85:	08 00 00 
 80000105d88:	ff d0                	call   *%rax
  return ip;
 80000105d8a:	e9 5f ff ff ff       	jmp    80000105cee <create+0xad>
    panic("create: ialloc");
 80000105d8f:	48 bf 3f ad 10 00 00 	movabs $0x8000010ad3f,%rdi
 80000105d96:	08 00 00 
 80000105d99:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000105da0:	08 00 00 
 80000105da3:	ff d0                	call   *%rax
    dp->nlink++;  // for ".."
 80000105da5:	66 41 8b 84 24 9a 00 	mov    0x9a(%r12),%ax
 80000105dac:	00 00 
 80000105dae:	83 c0 01             	add    $0x1,%eax
 80000105db1:	66 41 89 84 24 9a 00 	mov    %ax,0x9a(%r12)
 80000105db8:	00 00 
    iupdate(dp);
 80000105dba:	4c 89 e7             	mov    %r12,%rdi
 80000105dbd:	48 b8 0a 1d 10 00 00 	movabs $0x80000101d0a,%rax
 80000105dc4:	08 00 00 
 80000105dc7:	ff d0                	call   *%rax
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
 80000105dc9:	8b 53 04             	mov    0x4(%rbx),%edx
 80000105dcc:	48 be 4f ad 10 00 00 	movabs $0x8000010ad4f,%rsi
 80000105dd3:	08 00 00 
 80000105dd6:	48 89 df             	mov    %rbx,%rdi
 80000105dd9:	48 b8 bf 26 10 00 00 	movabs $0x800001026bf,%rax
 80000105de0:	08 00 00 
 80000105de3:	ff d0                	call   *%rax
 80000105de5:	85 c0                	test   %eax,%eax
 80000105de7:	78 26                	js     80000105e0f <create+0x1ce>
 80000105de9:	41 8b 54 24 04       	mov    0x4(%r12),%edx
 80000105dee:	48 be 4e ad 10 00 00 	movabs $0x8000010ad4e,%rsi
 80000105df5:	08 00 00 
 80000105df8:	48 89 df             	mov    %rbx,%rdi
 80000105dfb:	48 b8 bf 26 10 00 00 	movabs $0x800001026bf,%rax
 80000105e02:	08 00 00 
 80000105e05:	ff d0                	call   *%rax
 80000105e07:	85 c0                	test   %eax,%eax
 80000105e09:	0f 89 4e ff ff ff    	jns    80000105d5d <create+0x11c>
      panic("create dots");
 80000105e0f:	48 bf 51 ad 10 00 00 	movabs $0x8000010ad51,%rdi
 80000105e16:	08 00 00 
 80000105e19:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000105e20:	08 00 00 
 80000105e23:	ff d0                	call   *%rax
    panic("create: dirlink");
 80000105e25:	48 bf 5d ad 10 00 00 	movabs $0x8000010ad5d,%rdi
 80000105e2c:	08 00 00 
 80000105e2f:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000105e36:	08 00 00 
 80000105e39:	ff d0                	call   *%rax
    return 0;
 80000105e3b:	48 89 c3             	mov    %rax,%rbx
 80000105e3e:	e9 ab fe ff ff       	jmp    80000105cee <create+0xad>

0000080000105e43 <sys_dup>:
{
 80000105e43:	55                   	push   %rbp
 80000105e44:	48 89 e5             	mov    %rsp,%rbp
 80000105e47:	53                   	push   %rbx
 80000105e48:	48 83 ec 18          	sub    $0x18,%rsp
  if(argfd(0, 0, &f) < 0)
 80000105e4c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
 80000105e50:	be 00 00 00 00       	mov    $0x0,%esi
 80000105e55:	bf 00 00 00 00       	mov    $0x0,%edi
 80000105e5a:	48 b8 06 5b 10 00 00 	movabs $0x80000105b06,%rax
 80000105e61:	08 00 00 
 80000105e64:	ff d0                	call   *%rax
 80000105e66:	85 c0                	test   %eax,%eax
 80000105e68:	78 30                	js     80000105e9a <sys_dup+0x57>
  if((fd=fdalloc(f)) < 0)
 80000105e6a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
 80000105e6e:	48 b8 83 5b 10 00 00 	movabs $0x80000105b83,%rax
 80000105e75:	08 00 00 
 80000105e78:	ff d0                	call   *%rax
 80000105e7a:	89 c3                	mov    %eax,%ebx
 80000105e7c:	85 c0                	test   %eax,%eax
 80000105e7e:	78 23                	js     80000105ea3 <sys_dup+0x60>
  filedup(f);
 80000105e80:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
 80000105e84:	48 b8 a2 12 10 00 00 	movabs $0x800001012a2,%rax
 80000105e8b:	08 00 00 
 80000105e8e:	ff d0                	call   *%rax
  return fd;
 80000105e90:	48 63 c3             	movslq %ebx,%rax
}
 80000105e93:	48 83 c4 18          	add    $0x18,%rsp
 80000105e97:	5b                   	pop    %rbx
 80000105e98:	5d                   	pop    %rbp
 80000105e99:	c3                   	ret
    return -1;
 80000105e9a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000105ea1:	eb f0                	jmp    80000105e93 <sys_dup+0x50>
    return -1;
 80000105ea3:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000105eaa:	eb e7                	jmp    80000105e93 <sys_dup+0x50>

0000080000105eac <sys_read>:
{
 80000105eac:	55                   	push   %rbp
 80000105ead:	48 89 e5             	mov    %rsp,%rbp
 80000105eb0:	48 83 ec 20          	sub    $0x20,%rsp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
 80000105eb4:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
 80000105eb8:	be 00 00 00 00       	mov    $0x0,%esi
 80000105ebd:	bf 00 00 00 00       	mov    $0x0,%edi
 80000105ec2:	48 b8 06 5b 10 00 00 	movabs $0x80000105b06,%rax
 80000105ec9:	08 00 00 
 80000105ecc:	ff d0                	call   *%rax
 80000105ece:	85 c0                	test   %eax,%eax
 80000105ed0:	78 50                	js     80000105f22 <sys_read+0x76>
 80000105ed2:	48 8d 75 f4          	lea    -0xc(%rbp),%rsi
 80000105ed6:	bf 02 00 00 00       	mov    $0x2,%edi
 80000105edb:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 80000105ee2:	08 00 00 
 80000105ee5:	ff d0                	call   *%rax
 80000105ee7:	85 c0                	test   %eax,%eax
 80000105ee9:	78 37                	js     80000105f22 <sys_read+0x76>
 80000105eeb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
 80000105eef:	8b 55 f4             	mov    -0xc(%rbp),%edx
 80000105ef2:	bf 01 00 00 00       	mov    $0x1,%edi
 80000105ef7:	48 b8 bf 59 10 00 00 	movabs $0x800001059bf,%rax
 80000105efe:	08 00 00 
 80000105f01:	ff d0                	call   *%rax
 80000105f03:	85 c0                	test   %eax,%eax
 80000105f05:	78 1b                	js     80000105f22 <sys_read+0x76>
  return fileread(f, p, n);
 80000105f07:	8b 55 f4             	mov    -0xc(%rbp),%edx
 80000105f0a:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
 80000105f0e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
 80000105f12:	48 b8 65 14 10 00 00 	movabs $0x80000101465,%rax
 80000105f19:	08 00 00 
 80000105f1c:	ff d0                	call   *%rax
 80000105f1e:	48 98                	cltq
 80000105f20:	eb 07                	jmp    80000105f29 <sys_read+0x7d>
    return -1;
 80000105f22:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
 80000105f29:	48 89 ec             	mov    %rbp,%rsp
 80000105f2c:	5d                   	pop    %rbp
 80000105f2d:	c3                   	ret

0000080000105f2e <sys_write>:
{
 80000105f2e:	55                   	push   %rbp
 80000105f2f:	48 89 e5             	mov    %rsp,%rbp
 80000105f32:	48 83 ec 20          	sub    $0x20,%rsp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
 80000105f36:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
 80000105f3a:	be 00 00 00 00       	mov    $0x0,%esi
 80000105f3f:	bf 00 00 00 00       	mov    $0x0,%edi
 80000105f44:	48 b8 06 5b 10 00 00 	movabs $0x80000105b06,%rax
 80000105f4b:	08 00 00 
 80000105f4e:	ff d0                	call   *%rax
 80000105f50:	85 c0                	test   %eax,%eax
 80000105f52:	78 50                	js     80000105fa4 <sys_write+0x76>
 80000105f54:	48 8d 75 f4          	lea    -0xc(%rbp),%rsi
 80000105f58:	bf 02 00 00 00       	mov    $0x2,%edi
 80000105f5d:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 80000105f64:	08 00 00 
 80000105f67:	ff d0                	call   *%rax
 80000105f69:	85 c0                	test   %eax,%eax
 80000105f6b:	78 37                	js     80000105fa4 <sys_write+0x76>
 80000105f6d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
 80000105f71:	8b 55 f4             	mov    -0xc(%rbp),%edx
 80000105f74:	bf 01 00 00 00       	mov    $0x1,%edi
 80000105f79:	48 b8 bf 59 10 00 00 	movabs $0x800001059bf,%rax
 80000105f80:	08 00 00 
 80000105f83:	ff d0                	call   *%rax
 80000105f85:	85 c0                	test   %eax,%eax
 80000105f87:	78 1b                	js     80000105fa4 <sys_write+0x76>
  return filewrite(f, p, n);
 80000105f89:	8b 55 f4             	mov    -0xc(%rbp),%edx
 80000105f8c:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
 80000105f90:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
 80000105f94:	48 b8 17 15 10 00 00 	movabs $0x80000101517,%rax
 80000105f9b:	08 00 00 
 80000105f9e:	ff d0                	call   *%rax
 80000105fa0:	48 98                	cltq
 80000105fa2:	eb 07                	jmp    80000105fab <sys_write+0x7d>
    return -1;
 80000105fa4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
 80000105fab:	48 89 ec             	mov    %rbp,%rsp
 80000105fae:	5d                   	pop    %rbp
 80000105faf:	c3                   	ret

0000080000105fb0 <sys_close>:
{
 80000105fb0:	55                   	push   %rbp
 80000105fb1:	48 89 e5             	mov    %rsp,%rbp
 80000105fb4:	48 83 ec 10          	sub    $0x10,%rsp
  if(argfd(0, &fd, &f) < 0)
 80000105fb8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
 80000105fbc:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 80000105fc0:	bf 00 00 00 00       	mov    $0x0,%edi
 80000105fc5:	48 b8 06 5b 10 00 00 	movabs $0x80000105b06,%rax
 80000105fcc:	08 00 00 
 80000105fcf:	ff d0                	call   *%rax
 80000105fd1:	85 c0                	test   %eax,%eax
 80000105fd3:	78 35                	js     8000010600a <sys_close+0x5a>
  myproc()->ofile[fd] = 0;
 80000105fd5:	b0 00                	mov    $0x0,%al
 80000105fd7:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000105fde:	08 00 00 
 80000105fe1:	ff d2                	call   *%rdx
 80000105fe3:	48 63 55 fc          	movslq -0x4(%rbp),%rdx
 80000105fe7:	48 c7 44 d0 48 00 00 	movq   $0x0,0x48(%rax,%rdx,8)
 80000105fee:	00 00 
  fileclose(f);
 80000105ff0:	48 8b 7d f0          	mov    -0x10(%rbp),%rdi
 80000105ff4:	48 b8 07 13 10 00 00 	movabs $0x80000101307,%rax
 80000105ffb:	08 00 00 
 80000105ffe:	ff d0                	call   *%rax
  return 0;
 80000106000:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000106005:	48 89 ec             	mov    %rbp,%rsp
 80000106008:	5d                   	pop    %rbp
 80000106009:	c3                   	ret
    return -1;
 8000010600a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106011:	eb f2                	jmp    80000106005 <sys_close+0x55>

0000080000106013 <sys_fstat>:
{
 80000106013:	55                   	push   %rbp
 80000106014:	48 89 e5             	mov    %rsp,%rbp
 80000106017:	48 83 ec 10          	sub    $0x10,%rsp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
 8000010601b:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
 8000010601f:	be 00 00 00 00       	mov    $0x0,%esi
 80000106024:	bf 00 00 00 00       	mov    $0x0,%edi
 80000106029:	48 b8 06 5b 10 00 00 	movabs $0x80000105b06,%rax
 80000106030:	08 00 00 
 80000106033:	ff d0                	call   *%rax
 80000106035:	85 c0                	test   %eax,%eax
 80000106037:	78 39                	js     80000106072 <sys_fstat+0x5f>
 80000106039:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
 8000010603d:	ba 14 00 00 00       	mov    $0x14,%edx
 80000106042:	bf 01 00 00 00       	mov    $0x1,%edi
 80000106047:	48 b8 bf 59 10 00 00 	movabs $0x800001059bf,%rax
 8000010604e:	08 00 00 
 80000106051:	ff d0                	call   *%rax
 80000106053:	85 c0                	test   %eax,%eax
 80000106055:	78 1b                	js     80000106072 <sys_fstat+0x5f>
  return filestat(f, st);
 80000106057:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
 8000010605b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
 8000010605f:	48 b8 10 14 10 00 00 	movabs $0x80000101410,%rax
 80000106066:	08 00 00 
 80000106069:	ff d0                	call   *%rax
 8000010606b:	48 98                	cltq
}
 8000010606d:	48 89 ec             	mov    %rbp,%rsp
 80000106070:	5d                   	pop    %rbp
 80000106071:	c3                   	ret
    return -1;
 80000106072:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106079:	eb f2                	jmp    8000010606d <sys_fstat+0x5a>

000008000010607b <sys_link>:
{
 8000010607b:	55                   	push   %rbp
 8000010607c:	48 89 e5             	mov    %rsp,%rbp
 8000010607f:	41 54                	push   %r12
 80000106081:	53                   	push   %rbx
 80000106082:	48 83 ec 20          	sub    $0x20,%rsp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
 80000106086:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
 8000010608a:	bf 00 00 00 00       	mov    $0x0,%edi
 8000010608f:	48 b8 4b 5a 10 00 00 	movabs $0x80000105a4b,%rax
 80000106096:	08 00 00 
 80000106099:	ff d0                	call   *%rax
 8000010609b:	85 c0                	test   %eax,%eax
 8000010609d:	0f 88 21 01 00 00    	js     800001061c4 <sys_link+0x149>
 800001060a3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
 800001060a7:	bf 01 00 00 00       	mov    $0x1,%edi
 800001060ac:	48 b8 4b 5a 10 00 00 	movabs $0x80000105a4b,%rax
 800001060b3:	08 00 00 
 800001060b6:	ff d0                	call   *%rax
 800001060b8:	85 c0                	test   %eax,%eax
 800001060ba:	0f 88 04 01 00 00    	js     800001061c4 <sys_link+0x149>
  begin_op();
 800001060c0:	b0 00                	mov    $0x0,%al
 800001060c2:	48 ba 72 37 10 00 00 	movabs $0x80000103772,%rdx
 800001060c9:	08 00 00 
 800001060cc:	ff d2                	call   *%rdx
  if((ip = namei(old)) == 0){
 800001060ce:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
 800001060d2:	48 b8 c3 27 10 00 00 	movabs $0x800001027c3,%rax
 800001060d9:	08 00 00 
 800001060dc:	ff d0                	call   *%rax
 800001060de:	48 89 c3             	mov    %rax,%rbx
 800001060e1:	48 85 c0             	test   %rax,%rax
 800001060e4:	0f 84 ea 00 00 00    	je     800001061d4 <sys_link+0x159>
  ilock(ip);
 800001060ea:	48 89 c7             	mov    %rax,%rdi
 800001060ed:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 800001060f4:	08 00 00 
 800001060f7:	ff d0                	call   *%rax
  if(ip->type == T_DIR){
 800001060f9:	0f bf 83 94 00 00 00 	movswl 0x94(%rbx),%eax
 80000106100:	83 f8 01             	cmp    $0x1,%eax
 80000106103:	0f 84 e2 00 00 00    	je     800001061eb <sys_link+0x170>
  ip->nlink++;
 80000106109:	66 8b 83 9a 00 00 00 	mov    0x9a(%rbx),%ax
 80000106110:	83 c0 01             	add    $0x1,%eax
 80000106113:	66 89 83 9a 00 00 00 	mov    %ax,0x9a(%rbx)
  iupdate(ip);
 8000010611a:	48 89 df             	mov    %rbx,%rdi
 8000010611d:	48 b8 0a 1d 10 00 00 	movabs $0x80000101d0a,%rax
 80000106124:	08 00 00 
 80000106127:	ff d0                	call   *%rax
  iunlock(ip);
 80000106129:	48 89 df             	mov    %rbx,%rdi
 8000010612c:	48 b8 2a 20 10 00 00 	movabs $0x8000010202a,%rax
 80000106133:	08 00 00 
 80000106136:	ff d0                	call   *%rax
  if((dp = nameiparent(new, name)) == 0)
 80000106138:	48 8d 75 e2          	lea    -0x1e(%rbp),%rsi
 8000010613c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
 80000106140:	48 b8 e5 27 10 00 00 	movabs $0x800001027e5,%rax
 80000106147:	08 00 00 
 8000010614a:	ff d0                	call   *%rax
 8000010614c:	49 89 c4             	mov    %rax,%r12
 8000010614f:	48 85 c0             	test   %rax,%rax
 80000106152:	0f 84 c8 00 00 00    	je     80000106220 <sys_link+0x1a5>
  ilock(dp);
 80000106158:	48 89 c7             	mov    %rax,%rdi
 8000010615b:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 80000106162:	08 00 00 
 80000106165:	ff d0                	call   *%rax
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
 80000106167:	8b 03                	mov    (%rbx),%eax
 80000106169:	41 39 04 24          	cmp    %eax,(%r12)
 8000010616d:	0f 85 9e 00 00 00    	jne    80000106211 <sys_link+0x196>
 80000106173:	8b 53 04             	mov    0x4(%rbx),%edx
 80000106176:	48 8d 75 e2          	lea    -0x1e(%rbp),%rsi
 8000010617a:	4c 89 e7             	mov    %r12,%rdi
 8000010617d:	48 b8 bf 26 10 00 00 	movabs $0x800001026bf,%rax
 80000106184:	08 00 00 
 80000106187:	ff d0                	call   *%rax
 80000106189:	85 c0                	test   %eax,%eax
 8000010618b:	0f 88 80 00 00 00    	js     80000106211 <sys_link+0x196>
  iunlockput(dp);
 80000106191:	4c 89 e7             	mov    %r12,%rdi
 80000106194:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 8000010619b:	08 00 00 
 8000010619e:	ff d0                	call   *%rax
  iput(ip);
 800001061a0:	48 89 df             	mov    %rbx,%rdi
 800001061a3:	48 b8 80 20 10 00 00 	movabs $0x80000102080,%rax
 800001061aa:	08 00 00 
 800001061ad:	ff d0                	call   *%rax
  end_op();
 800001061af:	b0 00                	mov    $0x0,%al
 800001061b1:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001061b8:	08 00 00 
 800001061bb:	ff d2                	call   *%rdx
  return 0;
 800001061bd:	b8 00 00 00 00       	mov    $0x0,%eax
 800001061c2:	eb 07                	jmp    800001061cb <sys_link+0x150>
    return -1;
 800001061c4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
 800001061cb:	48 83 c4 20          	add    $0x20,%rsp
 800001061cf:	5b                   	pop    %rbx
 800001061d0:	41 5c                	pop    %r12
 800001061d2:	5d                   	pop    %rbp
 800001061d3:	c3                   	ret
    end_op();
 800001061d4:	b0 00                	mov    $0x0,%al
 800001061d6:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001061dd:	08 00 00 
 800001061e0:	ff d2                	call   *%rdx
    return -1;
 800001061e2:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 800001061e9:	eb e0                	jmp    800001061cb <sys_link+0x150>
    iunlockput(ip);
 800001061eb:	48 89 df             	mov    %rbx,%rdi
 800001061ee:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 800001061f5:	08 00 00 
 800001061f8:	ff d0                	call   *%rax
    end_op();
 800001061fa:	b0 00                	mov    $0x0,%al
 800001061fc:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000106203:	08 00 00 
 80000106206:	ff d2                	call   *%rdx
    return -1;
 80000106208:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 8000010620f:	eb ba                	jmp    800001061cb <sys_link+0x150>
    iunlockput(dp);
 80000106211:	4c 89 e7             	mov    %r12,%rdi
 80000106214:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 8000010621b:	08 00 00 
 8000010621e:	ff d0                	call   *%rax
  ilock(ip);
 80000106220:	48 89 df             	mov    %rbx,%rdi
 80000106223:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 8000010622a:	08 00 00 
 8000010622d:	ff d0                	call   *%rax
  ip->nlink--;
 8000010622f:	66 8b 83 9a 00 00 00 	mov    0x9a(%rbx),%ax
 80000106236:	83 e8 01             	sub    $0x1,%eax
 80000106239:	66 89 83 9a 00 00 00 	mov    %ax,0x9a(%rbx)
  iupdate(ip);
 80000106240:	48 89 df             	mov    %rbx,%rdi
 80000106243:	48 b8 0a 1d 10 00 00 	movabs $0x80000101d0a,%rax
 8000010624a:	08 00 00 
 8000010624d:	ff d0                	call   *%rax
  iunlockput(ip);
 8000010624f:	48 89 df             	mov    %rbx,%rdi
 80000106252:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000106259:	08 00 00 
 8000010625c:	ff d0                	call   *%rax
  end_op();
 8000010625e:	b0 00                	mov    $0x0,%al
 80000106260:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000106267:	08 00 00 
 8000010626a:	ff d2                	call   *%rdx
  return -1;
 8000010626c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106273:	e9 53 ff ff ff       	jmp    800001061cb <sys_link+0x150>

0000080000106278 <sys_unlink>:
{
 80000106278:	55                   	push   %rbp
 80000106279:	48 89 e5             	mov    %rsp,%rbp
 8000010627c:	41 55                	push   %r13
 8000010627e:	41 54                	push   %r12
 80000106280:	53                   	push   %rbx
 80000106281:	48 83 ec 38          	sub    $0x38,%rsp
  if(argstr(0, &path) < 0)
 80000106285:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
 80000106289:	bf 00 00 00 00       	mov    $0x0,%edi
 8000010628e:	48 b8 4b 5a 10 00 00 	movabs $0x80000105a4b,%rax
 80000106295:	08 00 00 
 80000106298:	ff d0                	call   *%rax
 8000010629a:	85 c0                	test   %eax,%eax
 8000010629c:	0f 88 32 02 00 00    	js     800001064d4 <sys_unlink+0x25c>
  begin_op();
 800001062a2:	b0 00                	mov    $0x0,%al
 800001062a4:	48 ba 72 37 10 00 00 	movabs $0x80000103772,%rdx
 800001062ab:	08 00 00 
 800001062ae:	ff d2                	call   *%rdx
  if((dp = nameiparent(path, name)) == 0){
 800001062b0:	48 8d 75 c2          	lea    -0x3e(%rbp),%rsi
 800001062b4:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
 800001062b8:	48 b8 e5 27 10 00 00 	movabs $0x800001027e5,%rax
 800001062bf:	08 00 00 
 800001062c2:	ff d0                	call   *%rax
 800001062c4:	48 89 c3             	mov    %rax,%rbx
 800001062c7:	48 85 c0             	test   %rax,%rax
 800001062ca:	0f 84 47 01 00 00    	je     80000106417 <sys_unlink+0x19f>
  ilock(dp);
 800001062d0:	48 89 c7             	mov    %rax,%rdi
 800001062d3:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 800001062da:	08 00 00 
 800001062dd:	ff d0                	call   *%rax
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
 800001062df:	48 8d 7d c2          	lea    -0x3e(%rbp),%rdi
 800001062e3:	48 be 4f ad 10 00 00 	movabs $0x8000010ad4f,%rsi
 800001062ea:	08 00 00 
 800001062ed:	48 b8 89 24 10 00 00 	movabs $0x80000102489,%rax
 800001062f4:	08 00 00 
 800001062f7:	ff d0                	call   *%rax
 800001062f9:	85 c0                	test   %eax,%eax
 800001062fb:	0f 84 69 01 00 00    	je     8000010646a <sys_unlink+0x1f2>
 80000106301:	48 8d 7d c2          	lea    -0x3e(%rbp),%rdi
 80000106305:	48 be 4e ad 10 00 00 	movabs $0x8000010ad4e,%rsi
 8000010630c:	08 00 00 
 8000010630f:	48 b8 89 24 10 00 00 	movabs $0x80000102489,%rax
 80000106316:	08 00 00 
 80000106319:	ff d0                	call   *%rax
 8000010631b:	85 c0                	test   %eax,%eax
 8000010631d:	0f 84 47 01 00 00    	je     8000010646a <sys_unlink+0x1f2>
  if((ip = dirlookup(dp, name, &off)) == 0)
 80000106323:	48 8d 55 b4          	lea    -0x4c(%rbp),%rdx
 80000106327:	48 8d 75 c2          	lea    -0x3e(%rbp),%rsi
 8000010632b:	48 89 df             	mov    %rbx,%rdi
 8000010632e:	48 b8 a0 24 10 00 00 	movabs $0x800001024a0,%rax
 80000106335:	08 00 00 
 80000106338:	ff d0                	call   *%rax
 8000010633a:	49 89 c4             	mov    %rax,%r12
 8000010633d:	48 85 c0             	test   %rax,%rax
 80000106340:	0f 84 24 01 00 00    	je     8000010646a <sys_unlink+0x1f2>
  ilock(ip);
 80000106346:	48 89 c7             	mov    %rax,%rdi
 80000106349:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 80000106350:	08 00 00 
 80000106353:	ff d0                	call   *%rax
  if(ip->nlink < 1)
 80000106355:	41 0f bf 84 24 9a 00 	movswl 0x9a(%r12),%eax
 8000010635c:	00 00 
 8000010635e:	85 c0                	test   %eax,%eax
 80000106360:	0f 8e c8 00 00 00    	jle    8000010642e <sys_unlink+0x1b6>
  if(ip->type == T_DIR && !isdirempty(ip)){
 80000106366:	41 0f bf 84 24 94 00 	movswl 0x94(%r12),%eax
 8000010636d:	00 00 
 8000010636f:	83 f8 01             	cmp    $0x1,%eax
 80000106372:	0f 84 cc 00 00 00    	je     80000106444 <sys_unlink+0x1cc>
  memset(&de, 0, sizeof(de));
 80000106378:	4c 8d 6d d0          	lea    -0x30(%rbp),%r13
 8000010637c:	ba 10 00 00 00       	mov    $0x10,%edx
 80000106381:	be 00 00 00 00       	mov    $0x0,%esi
 80000106386:	4c 89 ef             	mov    %r13,%rdi
 80000106389:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000106390:	08 00 00 
 80000106393:	ff d0                	call   *%rax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
 80000106395:	b9 10 00 00 00       	mov    $0x10,%ecx
 8000010639a:	8b 55 b4             	mov    -0x4c(%rbp),%edx
 8000010639d:	4c 89 ee             	mov    %r13,%rsi
 800001063a0:	48 89 df             	mov    %rbx,%rdi
 800001063a3:	48 b8 04 23 10 00 00 	movabs $0x80000102304,%rax
 800001063aa:	08 00 00 
 800001063ad:	ff d0                	call   *%rax
 800001063af:	83 f8 10             	cmp    $0x10,%eax
 800001063b2:	0f 85 e1 00 00 00    	jne    80000106499 <sys_unlink+0x221>
  if(ip->type == T_DIR){
 800001063b8:	41 0f bf 84 24 94 00 	movswl 0x94(%r12),%eax
 800001063bf:	00 00 
 800001063c1:	83 f8 01             	cmp    $0x1,%eax
 800001063c4:	0f 84 e5 00 00 00    	je     800001064af <sys_unlink+0x237>
  iunlockput(dp);
 800001063ca:	48 89 df             	mov    %rbx,%rdi
 800001063cd:	48 bb 66 21 10 00 00 	movabs $0x80000102166,%rbx
 800001063d4:	08 00 00 
 800001063d7:	ff d3                	call   *%rbx
  ip->nlink--;
 800001063d9:	66 41 8b 84 24 9a 00 	mov    0x9a(%r12),%ax
 800001063e0:	00 00 
 800001063e2:	83 e8 01             	sub    $0x1,%eax
 800001063e5:	66 41 89 84 24 9a 00 	mov    %ax,0x9a(%r12)
 800001063ec:	00 00 
  iupdate(ip);
 800001063ee:	4c 89 e7             	mov    %r12,%rdi
 800001063f1:	48 b8 0a 1d 10 00 00 	movabs $0x80000101d0a,%rax
 800001063f8:	08 00 00 
 800001063fb:	ff d0                	call   *%rax
  iunlockput(ip);
 800001063fd:	4c 89 e7             	mov    %r12,%rdi
 80000106400:	ff d3                	call   *%rbx
  end_op();
 80000106402:	b0 00                	mov    $0x0,%al
 80000106404:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 8000010640b:	08 00 00 
 8000010640e:	ff d2                	call   *%rdx
  return 0;
 80000106410:	b8 00 00 00 00       	mov    $0x0,%eax
 80000106415:	eb 77                	jmp    8000010648e <sys_unlink+0x216>
    end_op();
 80000106417:	b0 00                	mov    $0x0,%al
 80000106419:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000106420:	08 00 00 
 80000106423:	ff d2                	call   *%rdx
    return -1;
 80000106425:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 8000010642c:	eb 60                	jmp    8000010648e <sys_unlink+0x216>
    panic("unlink: nlink < 1");
 8000010642e:	48 bf 6d ad 10 00 00 	movabs $0x8000010ad6d,%rdi
 80000106435:	08 00 00 
 80000106438:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 8000010643f:	08 00 00 
 80000106442:	ff d0                	call   *%rax
  if(ip->type == T_DIR && !isdirempty(ip)){
 80000106444:	4c 89 e7             	mov    %r12,%rdi
 80000106447:	48 b8 cd 5b 10 00 00 	movabs $0x80000105bcd,%rax
 8000010644e:	08 00 00 
 80000106451:	ff d0                	call   *%rax
 80000106453:	85 c0                	test   %eax,%eax
 80000106455:	0f 85 1d ff ff ff    	jne    80000106378 <sys_unlink+0x100>
    iunlockput(ip);
 8000010645b:	4c 89 e7             	mov    %r12,%rdi
 8000010645e:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000106465:	08 00 00 
 80000106468:	ff d0                	call   *%rax
  iunlockput(dp);
 8000010646a:	48 89 df             	mov    %rbx,%rdi
 8000010646d:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000106474:	08 00 00 
 80000106477:	ff d0                	call   *%rax
  end_op();
 80000106479:	b0 00                	mov    $0x0,%al
 8000010647b:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000106482:	08 00 00 
 80000106485:	ff d2                	call   *%rdx
  return -1;
 80000106487:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
 8000010648e:	48 83 c4 38          	add    $0x38,%rsp
 80000106492:	5b                   	pop    %rbx
 80000106493:	41 5c                	pop    %r12
 80000106495:	41 5d                	pop    %r13
 80000106497:	5d                   	pop    %rbp
 80000106498:	c3                   	ret
    panic("unlink: writei");
 80000106499:	48 bf 7f ad 10 00 00 	movabs $0x8000010ad7f,%rdi
 800001064a0:	08 00 00 
 800001064a3:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001064aa:	08 00 00 
 800001064ad:	ff d0                	call   *%rax
    dp->nlink--;
 800001064af:	66 8b 83 9a 00 00 00 	mov    0x9a(%rbx),%ax
 800001064b6:	83 e8 01             	sub    $0x1,%eax
 800001064b9:	66 89 83 9a 00 00 00 	mov    %ax,0x9a(%rbx)
    iupdate(dp);
 800001064c0:	48 89 df             	mov    %rbx,%rdi
 800001064c3:	48 b8 0a 1d 10 00 00 	movabs $0x80000101d0a,%rax
 800001064ca:	08 00 00 
 800001064cd:	ff d0                	call   *%rax
 800001064cf:	e9 f6 fe ff ff       	jmp    800001063ca <sys_unlink+0x152>
    return -1;
 800001064d4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 800001064db:	eb b1                	jmp    8000010648e <sys_unlink+0x216>

00000800001064dd <sys_open>:

uint64
sys_open(void)
{
 800001064dd:	55                   	push   %rbp
 800001064de:	48 89 e5             	mov    %rsp,%rbp
 800001064e1:	41 55                	push   %r13
 800001064e3:	41 54                	push   %r12
 800001064e5:	53                   	push   %rbx
 800001064e6:	48 83 ec 18          	sub    $0x18,%rsp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
 800001064ea:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
 800001064ee:	bf 00 00 00 00       	mov    $0x0,%edi
 800001064f3:	48 b8 4b 5a 10 00 00 	movabs $0x80000105a4b,%rax
 800001064fa:	08 00 00 
 800001064fd:	ff d0                	call   *%rax
 800001064ff:	85 c0                	test   %eax,%eax
 80000106501:	0f 88 d4 00 00 00    	js     800001065db <sys_open+0xfe>
 80000106507:	48 8d 75 d4          	lea    -0x2c(%rbp),%rsi
 8000010650b:	bf 01 00 00 00       	mov    $0x1,%edi
 80000106510:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 80000106517:	08 00 00 
 8000010651a:	ff d0                	call   *%rax
 8000010651c:	85 c0                	test   %eax,%eax
 8000010651e:	0f 88 b7 00 00 00    	js     800001065db <sys_open+0xfe>
    return -1;

  begin_op();
 80000106524:	b0 00                	mov    $0x0,%al
 80000106526:	48 ba 72 37 10 00 00 	movabs $0x80000103772,%rdx
 8000010652d:	08 00 00 
 80000106530:	ff d2                	call   *%rdx

  if(omode & O_CREATE){
 80000106532:	f6 45 d5 02          	testb  $0x2,-0x2b(%rbp)
 80000106536:	0f 84 c8 00 00 00    	je     80000106604 <sys_open+0x127>
    ip = create(path, T_FILE, 0, 0);
 8000010653c:	b9 00 00 00 00       	mov    $0x0,%ecx
 80000106541:	ba 00 00 00 00       	mov    $0x0,%edx
 80000106546:	be 02 00 00 00       	mov    $0x2,%esi
 8000010654b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
 8000010654f:	48 b8 41 5c 10 00 00 	movabs $0x80000105c41,%rax
 80000106556:	08 00 00 
 80000106559:	ff d0                	call   *%rax
 8000010655b:	49 89 c5             	mov    %rax,%r13
    if(ip == 0){
 8000010655e:	48 85 c0             	test   %rax,%rax
 80000106561:	0f 84 86 00 00 00    	je     800001065ed <sys_open+0x110>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
 80000106567:	48 b8 1d 12 10 00 00 	movabs $0x8000010121d,%rax
 8000010656e:	08 00 00 
 80000106571:	ff d0                	call   *%rax
 80000106573:	48 89 c3             	mov    %rax,%rbx
 80000106576:	48 85 c0             	test   %rax,%rax
 80000106579:	0f 84 19 01 00 00    	je     80000106698 <sys_open+0x1bb>
 8000010657f:	48 89 c7             	mov    %rax,%rdi
 80000106582:	48 b8 83 5b 10 00 00 	movabs $0x80000105b83,%rax
 80000106589:	08 00 00 
 8000010658c:	ff d0                	call   *%rax
 8000010658e:	41 89 c4             	mov    %eax,%r12d
 80000106591:	85 c0                	test   %eax,%eax
 80000106593:	0f 88 f0 00 00 00    	js     80000106689 <sys_open+0x1ac>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
 80000106599:	4c 89 ef             	mov    %r13,%rdi
 8000010659c:	48 b8 2a 20 10 00 00 	movabs $0x8000010202a,%rax
 800001065a3:	08 00 00 
 800001065a6:	ff d0                	call   *%rax
  end_op();
 800001065a8:	b0 00                	mov    $0x0,%al
 800001065aa:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001065b1:	08 00 00 
 800001065b4:	ff d2                	call   *%rdx

  f->type = FD_INODE;
 800001065b6:	c7 03 02 00 00 00    	movl   $0x2,(%rbx)
  f->ip = ip;
 800001065bc:	4c 89 6b 18          	mov    %r13,0x18(%rbx)
  f->off = 0;
 800001065c0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%rbx)
  f->readable = !(omode & O_WRONLY);
 800001065c7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
 800001065ca:	a8 01                	test   $0x1,%al
 800001065cc:	0f 94 43 08          	sete   0x8(%rbx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
 800001065d0:	a8 03                	test   $0x3,%al
 800001065d2:	0f 95 43 09          	setne  0x9(%rbx)
  return fd;
 800001065d6:	49 63 c4             	movslq %r12d,%rax
 800001065d9:	eb 07                	jmp    800001065e2 <sys_open+0x105>
    return -1;
 800001065db:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
 800001065e2:	48 83 c4 18          	add    $0x18,%rsp
 800001065e6:	5b                   	pop    %rbx
 800001065e7:	41 5c                	pop    %r12
 800001065e9:	41 5d                	pop    %r13
 800001065eb:	5d                   	pop    %rbp
 800001065ec:	c3                   	ret
      end_op();
 800001065ed:	b0 00                	mov    $0x0,%al
 800001065ef:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001065f6:	08 00 00 
 800001065f9:	ff d2                	call   *%rdx
      return -1;
 800001065fb:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106602:	eb de                	jmp    800001065e2 <sys_open+0x105>
    if((ip = namei(path)) == 0){
 80000106604:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
 80000106608:	48 b8 c3 27 10 00 00 	movabs $0x800001027c3,%rax
 8000010660f:	08 00 00 
 80000106612:	ff d0                	call   *%rax
 80000106614:	49 89 c5             	mov    %rax,%r13
 80000106617:	48 85 c0             	test   %rax,%rax
 8000010661a:	74 53                	je     8000010666f <sys_open+0x192>
    ilock(ip);
 8000010661c:	48 89 c7             	mov    %rax,%rdi
 8000010661f:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 80000106626:	08 00 00 
 80000106629:	ff d0                	call   *%rax
    if(ip->type == T_DIR && omode != O_RDONLY){
 8000010662b:	41 0f bf 85 94 00 00 	movswl 0x94(%r13),%eax
 80000106632:	00 
 80000106633:	83 f8 01             	cmp    $0x1,%eax
 80000106636:	0f 85 2b ff ff ff    	jne    80000106567 <sys_open+0x8a>
 8000010663c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
 80000106640:	0f 84 21 ff ff ff    	je     80000106567 <sys_open+0x8a>
      iunlockput(ip);
 80000106646:	4c 89 ef             	mov    %r13,%rdi
 80000106649:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 80000106650:	08 00 00 
 80000106653:	ff d0                	call   *%rax
      end_op();
 80000106655:	b0 00                	mov    $0x0,%al
 80000106657:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 8000010665e:	08 00 00 
 80000106661:	ff d2                	call   *%rdx
      return -1;
 80000106663:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 8000010666a:	e9 73 ff ff ff       	jmp    800001065e2 <sys_open+0x105>
      end_op();
 8000010666f:	b0 00                	mov    $0x0,%al
 80000106671:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000106678:	08 00 00 
 8000010667b:	ff d2                	call   *%rdx
      return -1;
 8000010667d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106684:	e9 59 ff ff ff       	jmp    800001065e2 <sys_open+0x105>
      fileclose(f);
 80000106689:	48 89 df             	mov    %rbx,%rdi
 8000010668c:	48 b8 07 13 10 00 00 	movabs $0x80000101307,%rax
 80000106693:	08 00 00 
 80000106696:	ff d0                	call   *%rax
    iunlockput(ip);
 80000106698:	4c 89 ef             	mov    %r13,%rdi
 8000010669b:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 800001066a2:	08 00 00 
 800001066a5:	ff d0                	call   *%rax
    end_op();
 800001066a7:	b0 00                	mov    $0x0,%al
 800001066a9:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001066b0:	08 00 00 
 800001066b3:	ff d2                	call   *%rdx
    return -1;
 800001066b5:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 800001066bc:	e9 21 ff ff ff       	jmp    800001065e2 <sys_open+0x105>

00000800001066c1 <sys_mkdir>:

uint64
sys_mkdir(void)
{
 800001066c1:	55                   	push   %rbp
 800001066c2:	48 89 e5             	mov    %rsp,%rbp
 800001066c5:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
 800001066c9:	b0 00                	mov    $0x0,%al
 800001066cb:	48 ba 72 37 10 00 00 	movabs $0x80000103772,%rdx
 800001066d2:	08 00 00 
 800001066d5:	ff d2                	call   *%rdx
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
 800001066d7:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
 800001066db:	bf 00 00 00 00       	mov    $0x0,%edi
 800001066e0:	48 b8 4b 5a 10 00 00 	movabs $0x80000105a4b,%rax
 800001066e7:	08 00 00 
 800001066ea:	ff d0                	call   *%rax
 800001066ec:	85 c0                	test   %eax,%eax
 800001066ee:	78 4b                	js     8000010673b <sys_mkdir+0x7a>
 800001066f0:	b9 00 00 00 00       	mov    $0x0,%ecx
 800001066f5:	ba 00 00 00 00       	mov    $0x0,%edx
 800001066fa:	be 01 00 00 00       	mov    $0x1,%esi
 800001066ff:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
 80000106703:	48 b8 41 5c 10 00 00 	movabs $0x80000105c41,%rax
 8000010670a:	08 00 00 
 8000010670d:	ff d0                	call   *%rax
 8000010670f:	48 89 c7             	mov    %rax,%rdi
 80000106712:	48 85 c0             	test   %rax,%rax
 80000106715:	74 24                	je     8000010673b <sys_mkdir+0x7a>
    end_op();
    return -1;
  }
  iunlockput(ip);
 80000106717:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 8000010671e:	08 00 00 
 80000106721:	ff d0                	call   *%rax
  end_op();
 80000106723:	b0 00                	mov    $0x0,%al
 80000106725:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 8000010672c:	08 00 00 
 8000010672f:	ff d2                	call   *%rdx
  return 0;
 80000106731:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000106736:	48 89 ec             	mov    %rbp,%rsp
 80000106739:	5d                   	pop    %rbp
 8000010673a:	c3                   	ret
    end_op();
 8000010673b:	b0 00                	mov    $0x0,%al
 8000010673d:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000106744:	08 00 00 
 80000106747:	ff d2                	call   *%rdx
    return -1;
 80000106749:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106750:	eb e4                	jmp    80000106736 <sys_mkdir+0x75>

0000080000106752 <sys_mknod>:

uint64
sys_mknod(void)
{
 80000106752:	55                   	push   %rbp
 80000106753:	48 89 e5             	mov    %rsp,%rbp
 80000106756:	48 83 ec 10          	sub    $0x10,%rsp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
 8000010675a:	b0 00                	mov    $0x0,%al
 8000010675c:	48 ba 72 37 10 00 00 	movabs $0x80000103772,%rdx
 80000106763:	08 00 00 
 80000106766:	ff d2                	call   *%rdx
  if((argstr(0, &path)) < 0 ||
 80000106768:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
 8000010676c:	bf 00 00 00 00       	mov    $0x0,%edi
 80000106771:	48 b8 4b 5a 10 00 00 	movabs $0x80000105a4b,%rax
 80000106778:	08 00 00 
 8000010677b:	ff d0                	call   *%rax
 8000010677d:	85 c0                	test   %eax,%eax
 8000010677f:	78 78                	js     800001067f9 <sys_mknod+0xa7>
     argint(1, &major) < 0 ||
 80000106781:	48 8d 75 f4          	lea    -0xc(%rbp),%rsi
 80000106785:	bf 01 00 00 00       	mov    $0x1,%edi
 8000010678a:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 80000106791:	08 00 00 
 80000106794:	ff d0                	call   *%rax
  if((argstr(0, &path)) < 0 ||
 80000106796:	85 c0                	test   %eax,%eax
 80000106798:	78 5f                	js     800001067f9 <sys_mknod+0xa7>
     argint(2, &minor) < 0 ||
 8000010679a:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
 8000010679e:	bf 02 00 00 00       	mov    $0x2,%edi
 800001067a3:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 800001067aa:	08 00 00 
 800001067ad:	ff d0                	call   *%rax
     argint(1, &major) < 0 ||
 800001067af:	85 c0                	test   %eax,%eax
 800001067b1:	78 46                	js     800001067f9 <sys_mknod+0xa7>
     (ip = create(path, T_DEV, major, minor)) == 0){
 800001067b3:	0f bf 4d f0          	movswl -0x10(%rbp),%ecx
 800001067b7:	0f bf 55 f4          	movswl -0xc(%rbp),%edx
 800001067bb:	be 03 00 00 00       	mov    $0x3,%esi
 800001067c0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
 800001067c4:	48 b8 41 5c 10 00 00 	movabs $0x80000105c41,%rax
 800001067cb:	08 00 00 
 800001067ce:	ff d0                	call   *%rax
 800001067d0:	48 89 c7             	mov    %rax,%rdi
     argint(2, &minor) < 0 ||
 800001067d3:	48 85 c0             	test   %rax,%rax
 800001067d6:	74 21                	je     800001067f9 <sys_mknod+0xa7>
    end_op();
    return -1;
  }
  iunlockput(ip);
 800001067d8:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 800001067df:	08 00 00 
 800001067e2:	ff d0                	call   *%rax
  end_op();
 800001067e4:	b0 00                	mov    $0x0,%al
 800001067e6:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001067ed:	08 00 00 
 800001067f0:	ff d2                	call   *%rdx
  return 0;
 800001067f2:	b8 00 00 00 00       	mov    $0x0,%eax
 800001067f7:	eb 15                	jmp    8000010680e <sys_mknod+0xbc>
    end_op();
 800001067f9:	b0 00                	mov    $0x0,%al
 800001067fb:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 80000106802:	08 00 00 
 80000106805:	ff d2                	call   *%rdx
    return -1;
 80000106807:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
 8000010680e:	48 89 ec             	mov    %rbp,%rsp
 80000106811:	5d                   	pop    %rbp
 80000106812:	c3                   	ret

0000080000106813 <sys_chdir>:

uint64
sys_chdir(void)
{
 80000106813:	55                   	push   %rbp
 80000106814:	48 89 e5             	mov    %rsp,%rbp
 80000106817:	41 54                	push   %r12
 80000106819:	53                   	push   %rbx
 8000010681a:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
 8000010681e:	b0 00                	mov    $0x0,%al
 80000106820:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000106827:	08 00 00 
 8000010682a:	ff d2                	call   *%rdx
 8000010682c:	49 89 c4             	mov    %rax,%r12
  
  begin_op();
 8000010682f:	b0 00                	mov    $0x0,%al
 80000106831:	48 ba 72 37 10 00 00 	movabs $0x80000103772,%rdx
 80000106838:	08 00 00 
 8000010683b:	ff d2                	call   *%rdx
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
 8000010683d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
 80000106841:	bf 00 00 00 00       	mov    $0x0,%edi
 80000106846:	48 b8 4b 5a 10 00 00 	movabs $0x80000105a4b,%rax
 8000010684d:	08 00 00 
 80000106850:	ff d0                	call   *%rax
 80000106852:	85 c0                	test   %eax,%eax
 80000106854:	78 7a                	js     800001068d0 <sys_chdir+0xbd>
 80000106856:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
 8000010685a:	48 b8 c3 27 10 00 00 	movabs $0x800001027c3,%rax
 80000106861:	08 00 00 
 80000106864:	ff d0                	call   *%rax
 80000106866:	48 89 c3             	mov    %rax,%rbx
 80000106869:	48 85 c0             	test   %rax,%rax
 8000010686c:	74 62                	je     800001068d0 <sys_chdir+0xbd>
    end_op();
    return -1;
  }
  ilock(ip);
 8000010686e:	48 89 c7             	mov    %rax,%rdi
 80000106871:	48 b8 21 1f 10 00 00 	movabs $0x80000101f21,%rax
 80000106878:	08 00 00 
 8000010687b:	ff d0                	call   *%rax
  if(ip->type != T_DIR){
 8000010687d:	0f bf 83 94 00 00 00 	movswl 0x94(%rbx),%eax
 80000106884:	83 f8 01             	cmp    $0x1,%eax
 80000106887:	75 5e                	jne    800001068e7 <sys_chdir+0xd4>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
 80000106889:	48 89 df             	mov    %rbx,%rdi
 8000010688c:	48 b8 2a 20 10 00 00 	movabs $0x8000010202a,%rax
 80000106893:	08 00 00 
 80000106896:	ff d0                	call   *%rax
  iput(curproc->cwd);
 80000106898:	49 8b bc 24 c8 00 00 	mov    0xc8(%r12),%rdi
 8000010689f:	00 
 800001068a0:	48 b8 80 20 10 00 00 	movabs $0x80000102080,%rax
 800001068a7:	08 00 00 
 800001068aa:	ff d0                	call   *%rax
  end_op();
 800001068ac:	b0 00                	mov    $0x0,%al
 800001068ae:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001068b5:	08 00 00 
 800001068b8:	ff d2                	call   *%rdx
  curproc->cwd = ip;
 800001068ba:	49 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%r12)
 800001068c1:	00 
  return 0;
 800001068c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 800001068c7:	48 83 c4 10          	add    $0x10,%rsp
 800001068cb:	5b                   	pop    %rbx
 800001068cc:	41 5c                	pop    %r12
 800001068ce:	5d                   	pop    %rbp
 800001068cf:	c3                   	ret
    end_op();
 800001068d0:	b0 00                	mov    $0x0,%al
 800001068d2:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001068d9:	08 00 00 
 800001068dc:	ff d2                	call   *%rdx
    return -1;
 800001068de:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 800001068e5:	eb e0                	jmp    800001068c7 <sys_chdir+0xb4>
    iunlockput(ip);
 800001068e7:	48 89 df             	mov    %rbx,%rdi
 800001068ea:	48 b8 66 21 10 00 00 	movabs $0x80000102166,%rax
 800001068f1:	08 00 00 
 800001068f4:	ff d0                	call   *%rax
    end_op();
 800001068f6:	b0 00                	mov    $0x0,%al
 800001068f8:	48 ba 01 38 10 00 00 	movabs $0x80000103801,%rdx
 800001068ff:	08 00 00 
 80000106902:	ff d2                	call   *%rdx
    return -1;
 80000106904:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 8000010690b:	eb ba                	jmp    800001068c7 <sys_chdir+0xb4>

000008000010690d <sys_exec>:

uint64
sys_exec(void)
{
 8000010690d:	55                   	push   %rbp
 8000010690e:	48 89 e5             	mov    %rsp,%rbp
 80000106911:	53                   	push   %rbx
 80000106912:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  char *path, *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, &path) < 0 || argint64(1, (int64*)&uargv) < 0){
 80000106919:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
 8000010691d:	bf 00 00 00 00       	mov    $0x0,%edi
 80000106922:	48 b8 4b 5a 10 00 00 	movabs $0x80000105a4b,%rax
 80000106929:	08 00 00 
 8000010692c:	ff d0                	call   *%rax
 8000010692e:	85 c0                	test   %eax,%eax
 80000106930:	0f 88 9b 00 00 00    	js     800001069d1 <sys_exec+0xc4>
 80000106936:	48 8d b5 d8 fe ff ff 	lea    -0x128(%rbp),%rsi
 8000010693d:	bf 01 00 00 00       	mov    $0x1,%edi
 80000106942:	48 b8 c5 58 10 00 00 	movabs $0x800001058c5,%rax
 80000106949:	08 00 00 
 8000010694c:	ff d0                	call   *%rax
 8000010694e:	85 c0                	test   %eax,%eax
 80000106950:	78 7f                	js     800001069d1 <sys_exec+0xc4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
 80000106952:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 80000106959:	ba 00 01 00 00       	mov    $0x100,%edx
 8000010695e:	be 00 00 00 00       	mov    $0x0,%esi
 80000106963:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 8000010696a:	08 00 00 
 8000010696d:	ff d0                	call   *%rax
  for(i=0;; i++){
 8000010696f:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(i >= NELEM(argv))
 80000106974:	83 fb 1f             	cmp    $0x1f,%ebx
 80000106977:	0f 87 8f 00 00 00    	ja     80000106a0c <sys_exec+0xff>
      return -1;
    if(fetchint(uargv+8*i, (int64*)&uarg) < 0)
 8000010697d:	8d 3c dd 00 00 00 00 	lea    0x0(,%rbx,8),%edi
 80000106984:	48 63 ff             	movslq %edi,%rdi
 80000106987:	48 8d b5 d0 fe ff ff 	lea    -0x130(%rbp),%rsi
 8000010698e:	48 03 bd d8 fe ff ff 	add    -0x128(%rbp),%rdi
 80000106995:	48 b8 20 58 10 00 00 	movabs $0x80000105820,%rax
 8000010699c:	08 00 00 
 8000010699f:	ff d0                	call   *%rax
 800001069a1:	85 c0                	test   %eax,%eax
 800001069a3:	78 70                	js     80000106a15 <sys_exec+0x108>
      return -1;
    if(uarg == 0){
 800001069a5:	48 8b bd d0 fe ff ff 	mov    -0x130(%rbp),%rdi
 800001069ac:	48 85 ff             	test   %rdi,%rdi
 800001069af:	74 31                	je     800001069e2 <sys_exec+0xd5>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
 800001069b1:	48 63 c3             	movslq %ebx,%rax
 800001069b4:	48 8d b4 c5 e0 fe ff 	lea    -0x120(%rbp,%rax,8),%rsi
 800001069bb:	ff 
 800001069bc:	48 b8 6b 58 10 00 00 	movabs $0x8000010586b,%rax
 800001069c3:	08 00 00 
 800001069c6:	ff d0                	call   *%rax
 800001069c8:	85 c0                	test   %eax,%eax
 800001069ca:	78 52                	js     80000106a1e <sys_exec+0x111>
  for(i=0;; i++){
 800001069cc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
 800001069cf:	eb a3                	jmp    80000106974 <sys_exec+0x67>
    return -1;
 800001069d1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
      return -1;
  }
  return exec(path, argv);
}
 800001069d8:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
 800001069df:	5b                   	pop    %rbx
 800001069e0:	5d                   	pop    %rbp
 800001069e1:	c3                   	ret
      argv[i] = 0;
 800001069e2:	48 63 db             	movslq %ebx,%rbx
 800001069e5:	48 c7 84 dd e0 fe ff 	movq   $0x0,-0x120(%rbp,%rbx,8)
 800001069ec:	ff 00 00 00 00 
  return exec(path, argv);
 800001069f1:	48 8d b5 e0 fe ff ff 	lea    -0x120(%rbp),%rsi
 800001069f8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
 800001069fc:	48 b8 c0 0d 10 00 00 	movabs $0x80000100dc0,%rax
 80000106a03:	08 00 00 
 80000106a06:	ff d0                	call   *%rax
 80000106a08:	48 98                	cltq
 80000106a0a:	eb cc                	jmp    800001069d8 <sys_exec+0xcb>
      return -1;
 80000106a0c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106a13:	eb c3                	jmp    800001069d8 <sys_exec+0xcb>
      return -1;
 80000106a15:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106a1c:	eb ba                	jmp    800001069d8 <sys_exec+0xcb>
      return -1;
 80000106a1e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106a25:	eb b1                	jmp    800001069d8 <sys_exec+0xcb>

0000080000106a27 <sys_pipe>:

uint64
sys_pipe(void)
{
 80000106a27:	55                   	push   %rbp
 80000106a28:	48 89 e5             	mov    %rsp,%rbp
 80000106a2b:	53                   	push   %rbx
 80000106a2c:	48 83 ec 28          	sub    $0x28,%rsp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
 80000106a30:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
 80000106a34:	ba 08 00 00 00       	mov    $0x8,%edx
 80000106a39:	bf 00 00 00 00       	mov    $0x0,%edi
 80000106a3e:	48 b8 bf 59 10 00 00 	movabs $0x800001059bf,%rax
 80000106a45:	08 00 00 
 80000106a48:	ff d0                	call   *%rax
 80000106a4a:	85 c0                	test   %eax,%eax
 80000106a4c:	0f 88 98 00 00 00    	js     80000106aea <sys_pipe+0xc3>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
 80000106a52:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
 80000106a56:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
 80000106a5a:	48 b8 00 40 10 00 00 	movabs $0x80000104000,%rax
 80000106a61:	08 00 00 
 80000106a64:	ff d0                	call   *%rax
 80000106a66:	85 c0                	test   %eax,%eax
 80000106a68:	0f 88 85 00 00 00    	js     80000106af3 <sys_pipe+0xcc>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
 80000106a6e:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
 80000106a72:	48 b8 83 5b 10 00 00 	movabs $0x80000105b83,%rax
 80000106a79:	08 00 00 
 80000106a7c:	ff d0                	call   *%rax
 80000106a7e:	89 c3                	mov    %eax,%ebx
 80000106a80:	85 c0                	test   %eax,%eax
 80000106a82:	78 47                	js     80000106acb <sys_pipe+0xa4>
 80000106a84:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
 80000106a88:	48 b8 83 5b 10 00 00 	movabs $0x80000105b83,%rax
 80000106a8f:	08 00 00 
 80000106a92:	ff d0                	call   *%rax
 80000106a94:	85 c0                	test   %eax,%eax
 80000106a96:	78 19                	js     80000106ab1 <sys_pipe+0x8a>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
 80000106a98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
 80000106a9c:	89 1a                	mov    %ebx,(%rdx)
  fd[1] = fd1;
 80000106a9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
 80000106aa2:	89 42 04             	mov    %eax,0x4(%rdx)
  return 0;
 80000106aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000106aaa:	48 83 c4 28          	add    $0x28,%rsp
 80000106aae:	5b                   	pop    %rbx
 80000106aaf:	5d                   	pop    %rbp
 80000106ab0:	c3                   	ret
      myproc()->ofile[fd0] = 0;
 80000106ab1:	b0 00                	mov    $0x0,%al
 80000106ab3:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000106aba:	08 00 00 
 80000106abd:	ff d2                	call   *%rdx
 80000106abf:	48 63 db             	movslq %ebx,%rbx
 80000106ac2:	48 c7 44 d8 48 00 00 	movq   $0x0,0x48(%rax,%rbx,8)
 80000106ac9:	00 00 
    fileclose(rf);
 80000106acb:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
 80000106acf:	48 bb 07 13 10 00 00 	movabs $0x80000101307,%rbx
 80000106ad6:	08 00 00 
 80000106ad9:	ff d3                	call   *%rbx
    fileclose(wf);
 80000106adb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
 80000106adf:	ff d3                	call   *%rbx
    return -1;
 80000106ae1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106ae8:	eb c0                	jmp    80000106aaa <sys_pipe+0x83>
    return -1;
 80000106aea:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106af1:	eb b7                	jmp    80000106aaa <sys_pipe+0x83>
    return -1;
 80000106af3:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106afa:	eb ae                	jmp    80000106aaa <sys_pipe+0x83>

0000080000106afc <sys_fork>:
#include "mmu.h"
#include "proc.h"

uint64
sys_fork(void)
{
 80000106afc:	55                   	push   %rbp
 80000106afd:	48 89 e5             	mov    %rsp,%rbp
  return fork();
 80000106b00:	48 b8 74 48 10 00 00 	movabs $0x80000104874,%rax
 80000106b07:	08 00 00 
 80000106b0a:	ff d0                	call   *%rax
 80000106b0c:	48 98                	cltq
}
 80000106b0e:	5d                   	pop    %rbp
 80000106b0f:	c3                   	ret

0000080000106b10 <sys_exit>:

uint64
sys_exit(void)
{
 80000106b10:	55                   	push   %rbp
 80000106b11:	48 89 e5             	mov    %rsp,%rbp
  exit();
 80000106b14:	48 b8 36 4c 10 00 00 	movabs $0x80000104c36,%rax
 80000106b1b:	08 00 00 
 80000106b1e:	ff d0                	call   *%rax
  return 0;  // not reached
}
 80000106b20:	b8 00 00 00 00       	mov    $0x0,%eax
 80000106b25:	5d                   	pop    %rbp
 80000106b26:	c3                   	ret

0000080000106b27 <sys_wait>:

uint64
sys_wait(void)
{
 80000106b27:	55                   	push   %rbp
 80000106b28:	48 89 e5             	mov    %rsp,%rbp
  return wait();
 80000106b2b:	48 b8 eb 4e 10 00 00 	movabs $0x80000104eeb,%rax
 80000106b32:	08 00 00 
 80000106b35:	ff d0                	call   *%rax
 80000106b37:	48 98                	cltq
}
 80000106b39:	5d                   	pop    %rbp
 80000106b3a:	c3                   	ret

0000080000106b3b <sys_kill>:

uint64
sys_kill(void)
{
 80000106b3b:	55                   	push   %rbp
 80000106b3c:	48 89 e5             	mov    %rsp,%rbp
 80000106b3f:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  if(argint(0, &pid) < 0)
 80000106b43:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 80000106b47:	bf 00 00 00 00       	mov    $0x0,%edi
 80000106b4c:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 80000106b53:	08 00 00 
 80000106b56:	ff d0                	call   *%rax
 80000106b58:	85 c0                	test   %eax,%eax
 80000106b5a:	78 16                	js     80000106b72 <sys_kill+0x37>
    return -1;
  return kill(pid);
 80000106b5c:	8b 7d fc             	mov    -0x4(%rbp),%edi
 80000106b5f:	48 b8 5e 50 10 00 00 	movabs $0x8000010505e,%rax
 80000106b66:	08 00 00 
 80000106b69:	ff d0                	call   *%rax
 80000106b6b:	48 98                	cltq
}
 80000106b6d:	48 89 ec             	mov    %rbp,%rsp
 80000106b70:	5d                   	pop    %rbp
 80000106b71:	c3                   	ret
    return -1;
 80000106b72:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106b79:	eb f2                	jmp    80000106b6d <sys_kill+0x32>

0000080000106b7b <sys_getpid>:

uint64
sys_getpid(void)
{
 80000106b7b:	55                   	push   %rbp
 80000106b7c:	48 89 e5             	mov    %rsp,%rbp
  return myproc()->pid;
 80000106b7f:	b0 00                	mov    $0x0,%al
 80000106b81:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000106b88:	08 00 00 
 80000106b8b:	ff d2                	call   *%rdx
 80000106b8d:	48 63 40 1c          	movslq 0x1c(%rax),%rax
}
 80000106b91:	5d                   	pop    %rbp
 80000106b92:	c3                   	ret

0000080000106b93 <sys_sbrk>:

uint64
sys_sbrk(void)
{
 80000106b93:	55                   	push   %rbp
 80000106b94:	48 89 e5             	mov    %rsp,%rbp
 80000106b97:	53                   	push   %rbx
 80000106b98:	48 83 ec 18          	sub    $0x18,%rsp
  int64 addr;
  int n;

  if(argint(0, &n) < 0)
 80000106b9c:	48 8d 75 ec          	lea    -0x14(%rbp),%rsi
 80000106ba0:	bf 00 00 00 00       	mov    $0x0,%edi
 80000106ba5:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 80000106bac:	08 00 00 
 80000106baf:	ff d0                	call   *%rax
 80000106bb1:	85 c0                	test   %eax,%eax
 80000106bb3:	78 2e                	js     80000106be3 <sys_sbrk+0x50>
    return -1;
  addr = myproc()->sz;
 80000106bb5:	b0 00                	mov    $0x0,%al
 80000106bb7:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000106bbe:	08 00 00 
 80000106bc1:	ff d2                	call   *%rdx
 80000106bc3:	48 8b 18             	mov    (%rax),%rbx
  if(growproc(n) < 0)
 80000106bc6:	8b 7d ec             	mov    -0x14(%rbp),%edi
 80000106bc9:	48 b8 ef 47 10 00 00 	movabs $0x800001047ef,%rax
 80000106bd0:	08 00 00 
 80000106bd3:	ff d0                	call   *%rax
 80000106bd5:	85 c0                	test   %eax,%eax
 80000106bd7:	78 13                	js     80000106bec <sys_sbrk+0x59>
    return -1;
  return addr;
}
 80000106bd9:	48 89 d8             	mov    %rbx,%rax
 80000106bdc:	48 83 c4 18          	add    $0x18,%rsp
 80000106be0:	5b                   	pop    %rbx
 80000106be1:	5d                   	pop    %rbp
 80000106be2:	c3                   	ret
    return -1;
 80000106be3:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
 80000106bea:	eb ed                	jmp    80000106bd9 <sys_sbrk+0x46>
    return -1;
 80000106bec:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
 80000106bf3:	eb e4                	jmp    80000106bd9 <sys_sbrk+0x46>

0000080000106bf5 <sys_sleep>:

uint64
sys_sleep(void)
{
 80000106bf5:	55                   	push   %rbp
 80000106bf6:	48 89 e5             	mov    %rsp,%rbp
 80000106bf9:	53                   	push   %rbx
 80000106bfa:	48 83 ec 18          	sub    $0x18,%rsp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
 80000106bfe:	48 8d 75 ec          	lea    -0x14(%rbp),%rsi
 80000106c02:	bf 00 00 00 00       	mov    $0x0,%edi
 80000106c07:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 80000106c0e:	08 00 00 
 80000106c11:	ff d0                	call   *%rax
 80000106c13:	85 c0                	test   %eax,%eax
 80000106c15:	0f 88 a9 00 00 00    	js     80000106cc4 <sys_sleep+0xcf>
    return -1;
  acquire(&tickslock);
 80000106c1b:	48 bf 00 df 11 00 00 	movabs $0x8000011df00,%rdi
 80000106c22:	08 00 00 
 80000106c25:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000106c2c:	08 00 00 
 80000106c2f:	ff d0                	call   *%rax
  ticks0 = ticks;
 80000106c31:	48 b8 e0 de 11 00 00 	movabs $0x8000011dee0,%rax
 80000106c38:	08 00 00 
 80000106c3b:	8b 18                	mov    (%rax),%ebx
  while(ticks - ticks0 < n){
 80000106c3d:	eb 20                	jmp    80000106c5f <sys_sleep+0x6a>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
 80000106c3f:	48 be 00 df 11 00 00 	movabs $0x8000011df00,%rsi
 80000106c46:	08 00 00 
 80000106c49:	48 bf e0 de 11 00 00 	movabs $0x8000011dee0,%rdi
 80000106c50:	08 00 00 
 80000106c53:	48 b8 03 4e 10 00 00 	movabs $0x80000104e03,%rax
 80000106c5a:	08 00 00 
 80000106c5d:	ff d0                	call   *%rax
  while(ticks - ticks0 < n){
 80000106c5f:	a1 e0 de 11 00 00 08 	movabs 0x8000011dee0,%eax
 80000106c66:	00 00 
 80000106c68:	29 d8                	sub    %ebx,%eax
 80000106c6a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
 80000106c6d:	73 33                	jae    80000106ca2 <sys_sleep+0xad>
    if(myproc()->killed){
 80000106c6f:	b0 00                	mov    $0x0,%al
 80000106c71:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000106c78:	08 00 00 
 80000106c7b:	ff d2                	call   *%rdx
 80000106c7d:	83 78 40 00          	cmpl   $0x0,0x40(%rax)
 80000106c81:	74 bc                	je     80000106c3f <sys_sleep+0x4a>
      release(&tickslock);
 80000106c83:	48 bf 00 df 11 00 00 	movabs $0x8000011df00,%rdi
 80000106c8a:	08 00 00 
 80000106c8d:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000106c94:	08 00 00 
 80000106c97:	ff d0                	call   *%rax
      return -1;
 80000106c99:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106ca0:	eb 1b                	jmp    80000106cbd <sys_sleep+0xc8>
  }
  release(&tickslock);
 80000106ca2:	48 bf 00 df 11 00 00 	movabs $0x8000011df00,%rdi
 80000106ca9:	08 00 00 
 80000106cac:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000106cb3:	08 00 00 
 80000106cb6:	ff d0                	call   *%rax
  return 0;
 80000106cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000106cbd:	48 83 c4 18          	add    $0x18,%rsp
 80000106cc1:	5b                   	pop    %rbx
 80000106cc2:	5d                   	pop    %rbp
 80000106cc3:	c3                   	ret
    return -1;
 80000106cc4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 80000106ccb:	eb f0                	jmp    80000106cbd <sys_sleep+0xc8>

0000080000106ccd <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
 80000106ccd:	55                   	push   %rbp
 80000106cce:	48 89 e5             	mov    %rsp,%rbp
 80000106cd1:	41 54                	push   %r12
 80000106cd3:	53                   	push   %rbx
  uint xticks;

  acquire(&tickslock);
 80000106cd4:	49 bc 00 df 11 00 00 	movabs $0x8000011df00,%r12
 80000106cdb:	08 00 00 
 80000106cde:	4c 89 e7             	mov    %r12,%rdi
 80000106ce1:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000106ce8:	08 00 00 
 80000106ceb:	ff d0                	call   *%rax
  xticks = ticks;
 80000106ced:	48 b8 e0 de 11 00 00 	movabs $0x8000011dee0,%rax
 80000106cf4:	08 00 00 
 80000106cf7:	8b 18                	mov    (%rax),%ebx
  release(&tickslock);
 80000106cf9:	4c 89 e7             	mov    %r12,%rdi
 80000106cfc:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000106d03:	08 00 00 
 80000106d06:	ff d0                	call   *%rax
  return xticks;
 80000106d08:	89 d8                	mov    %ebx,%eax
}
 80000106d0a:	5b                   	pop    %rbx
 80000106d0b:	41 5c                	pop    %r12
 80000106d0d:	5d                   	pop    %rbp
 80000106d0e:	c3                   	ret

0000080000106d0f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushq %r15
 80000106d0f:	41 57                	push   %r15
  pushq %r14
 80000106d11:	41 56                	push   %r14
  pushq %r13
 80000106d13:	41 55                	push   %r13
  pushq %r12
 80000106d15:	41 54                	push   %r12
  pushq %r11
 80000106d17:	41 53                	push   %r11
  pushq %r10
 80000106d19:	41 52                	push   %r10
  pushq %r9
 80000106d1b:	41 51                	push   %r9
  pushq %r8
 80000106d1d:	41 50                	push   %r8
  pushq %rdi
 80000106d1f:	57                   	push   %rdi
  pushq %rsi
 80000106d20:	56                   	push   %rsi
  pushq %rbp
 80000106d21:	55                   	push   %rbp
  pushq %rdx
 80000106d22:	52                   	push   %rdx
  pushq %rcx
 80000106d23:	51                   	push   %rcx
  pushq %rbx
 80000106d24:	53                   	push   %rbx
  pushq %rax
 80000106d25:	50                   	push   %rax
  
  # Call trap(tf), where tf=%esp
  movq %rsp, %rdi
 80000106d26:	48 89 e7             	mov    %rsp,%rdi
  call trap
 80000106d29:	e8 90 01 00 00       	call   80000106ebe <trap>

0000080000106d2e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popq %rax
 80000106d2e:	58                   	pop    %rax
  popq %rbx
 80000106d2f:	5b                   	pop    %rbx
  popq %rcx
 80000106d30:	59                   	pop    %rcx
  popq %rdx
 80000106d31:	5a                   	pop    %rdx
  popq %rbp
 80000106d32:	5d                   	pop    %rbp
  popq %rsi
 80000106d33:	5e                   	pop    %rsi
  popq %rdi
 80000106d34:	5f                   	pop    %rdi
  popq %r8
 80000106d35:	41 58                	pop    %r8
  popq %r9
 80000106d37:	41 59                	pop    %r9
  popq %r10
 80000106d39:	41 5a                	pop    %r10
  popq %r11
 80000106d3b:	41 5b                	pop    %r11
  popq %r12
 80000106d3d:	41 5c                	pop    %r12
  popq %r13
 80000106d3f:	41 5d                	pop    %r13
  popq %r14
 80000106d41:	41 5e                	pop    %r14
  popq %r15
 80000106d43:	41 5f                	pop    %r15
  addq $16, %rsp  # trapno and errcode
 80000106d45:	48 83 c4 10          	add    $0x10,%rsp
  iretq
 80000106d49:	48 cf                	iretq

0000080000106d4b <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
 80000106d4b:	55                   	push   %rbp
 80000106d4c:	48 89 e5             	mov    %rsp,%rbp
  int i;

  for(i = 0; i < 256; i++)
 80000106d4f:	be 00 00 00 00       	mov    $0x0,%esi
 80000106d54:	eb 77                	jmp    80000106dcd <tvinit+0x82>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
 80000106d56:	48 63 c6             	movslq %esi,%rax
 80000106d59:	48 ba 08 00 11 00 00 	movabs $0x80000110008,%rdx
 80000106d60:	08 00 00 
 80000106d63:	48 8b 0c c2          	mov    (%rdx,%rax,8),%rcx
 80000106d67:	48 c1 e0 04          	shl    $0x4,%rax
 80000106d6b:	48 89 c2             	mov    %rax,%rdx
 80000106d6e:	48 b8 80 df 11 00 00 	movabs $0x8000011df80,%rax
 80000106d75:	08 00 00 
 80000106d78:	48 01 d0             	add    %rdx,%rax
 80000106d7b:	66 89 08             	mov    %cx,(%rax)
 80000106d7e:	66 c7 40 02 08 00    	movw   $0x8,0x2(%rax)
 80000106d84:	8a 50 04             	mov    0x4(%rax),%dl
 80000106d87:	83 e2 e7             	and    $0xffffffe7,%edx
 80000106d8a:	88 50 04             	mov    %dl,0x4(%rax)
 80000106d8d:	83 e2 1f             	and    $0x1f,%edx
 80000106d90:	88 50 04             	mov    %dl,0x4(%rax)
 80000106d93:	8a 50 05             	mov    0x5(%rax),%dl
 80000106d96:	83 e2 f0             	and    $0xfffffff0,%edx
 80000106d99:	83 ca 0e             	or     $0xe,%edx
 80000106d9c:	88 50 05             	mov    %dl,0x5(%rax)
 80000106d9f:	83 e2 ef             	and    $0xffffffef,%edx
 80000106da2:	88 50 05             	mov    %dl,0x5(%rax)
 80000106da5:	83 e2 9f             	and    $0xffffff9f,%edx
 80000106da8:	88 50 05             	mov    %dl,0x5(%rax)
 80000106dab:	83 ca 80             	or     $0xffffff80,%edx
 80000106dae:	88 50 05             	mov    %dl,0x5(%rax)
 80000106db1:	48 89 ca             	mov    %rcx,%rdx
 80000106db4:	48 c1 ea 10          	shr    $0x10,%rdx
 80000106db8:	66 89 50 06          	mov    %dx,0x6(%rax)
 80000106dbc:	48 c1 e9 20          	shr    $0x20,%rcx
 80000106dc0:	89 48 08             	mov    %ecx,0x8(%rax)
 80000106dc3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%rax)
  for(i = 0; i < 256; i++)
 80000106dca:	83 c6 01             	add    $0x1,%esi
 80000106dcd:	81 fe ff 00 00 00    	cmp    $0xff,%esi
 80000106dd3:	7e 81                	jle    80000106d56 <tvinit+0xb>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
 80000106dd5:	48 a1 08 02 11 00 00 	movabs 0x80000110208,%rax
 80000106ddc:	08 00 00 
 80000106ddf:	48 ba 80 df 11 00 00 	movabs $0x8000011df80,%rdx
 80000106de6:	08 00 00 
 80000106de9:	66 89 82 00 04 00 00 	mov    %ax,0x400(%rdx)
 80000106df0:	66 c7 82 02 04 00 00 	movw   $0x8,0x402(%rdx)
 80000106df7:	08 00 
 80000106df9:	8a 8a 04 04 00 00    	mov    0x404(%rdx),%cl
 80000106dff:	83 e1 e7             	and    $0xffffffe7,%ecx
 80000106e02:	88 8a 04 04 00 00    	mov    %cl,0x404(%rdx)
 80000106e08:	83 e1 1f             	and    $0x1f,%ecx
 80000106e0b:	88 8a 04 04 00 00    	mov    %cl,0x404(%rdx)
 80000106e11:	8a 8a 05 04 00 00    	mov    0x405(%rdx),%cl
 80000106e17:	83 c9 0f             	or     $0xf,%ecx
 80000106e1a:	88 8a 05 04 00 00    	mov    %cl,0x405(%rdx)
 80000106e20:	83 e1 ef             	and    $0xffffffef,%ecx
 80000106e23:	88 8a 05 04 00 00    	mov    %cl,0x405(%rdx)
 80000106e29:	83 c9 60             	or     $0x60,%ecx
 80000106e2c:	88 8a 05 04 00 00    	mov    %cl,0x405(%rdx)
 80000106e32:	83 c9 80             	or     $0xffffff80,%ecx
 80000106e35:	88 8a 05 04 00 00    	mov    %cl,0x405(%rdx)
 80000106e3b:	48 89 c1             	mov    %rax,%rcx
 80000106e3e:	48 c1 e9 10          	shr    $0x10,%rcx
 80000106e42:	66 89 8a 06 04 00 00 	mov    %cx,0x406(%rdx)
 80000106e49:	48 c1 e8 20          	shr    $0x20,%rax
 80000106e4d:	89 82 08 04 00 00    	mov    %eax,0x408(%rdx)
 80000106e53:	c7 82 0c 04 00 00 00 	movl   $0x0,0x40c(%rdx)
 80000106e5a:	00 00 00 

  initlock(&tickslock, "time");
 80000106e5d:	48 be 8e ad 10 00 00 	movabs $0x8000010ad8e,%rsi
 80000106e64:	08 00 00 
 80000106e67:	48 bf 00 df 11 00 00 	movabs $0x8000011df00,%rdi
 80000106e6e:	08 00 00 
 80000106e71:	48 b8 60 53 10 00 00 	movabs $0x80000105360,%rax
 80000106e78:	08 00 00 
 80000106e7b:	ff d0                	call   *%rax
}
 80000106e7d:	5d                   	pop    %rbp
 80000106e7e:	c3                   	ret

0000080000106e7f <idtinit>:

void
idtinit(void)
{
 80000106e7f:	55                   	push   %rbp
 80000106e80:	48 89 e5             	mov    %rsp,%rbp
  pd[0] = size-1;
 80000106e83:	66 c7 45 f6 ff 0f    	movw   $0xfff,-0xa(%rbp)
  pd[1] = (uint64)p;
 80000106e89:	48 b8 80 df 11 00 00 	movabs $0x8000011df80,%rax
 80000106e90:	08 00 00 
 80000106e93:	66 89 45 f8          	mov    %ax,-0x8(%rbp)
  pd[2] = (uint64)p >> 16;
 80000106e97:	48 89 c2             	mov    %rax,%rdx
 80000106e9a:	48 c1 ea 10          	shr    $0x10,%rdx
 80000106e9e:	66 89 55 fa          	mov    %dx,-0x6(%rbp)
  pd[3] = (uint64)p >> 32;
 80000106ea2:	48 89 c2             	mov    %rax,%rdx
 80000106ea5:	48 c1 ea 20          	shr    $0x20,%rdx
 80000106ea9:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
  pd[4] = (uint64)p >> 48;
 80000106ead:	48 c1 e8 30          	shr    $0x30,%rax
 80000106eb1:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
  asm volatile("lidt (%0)" : : "r" (pd));
 80000106eb5:	48 8d 45 f6          	lea    -0xa(%rbp),%rax
 80000106eb9:	0f 01 18             	lidt   (%rax)
  lidt(idt, sizeof(idt));
}
 80000106ebc:	5d                   	pop    %rbp
 80000106ebd:	c3                   	ret

0000080000106ebe <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
 80000106ebe:	55                   	push   %rbp
 80000106ebf:	48 89 e5             	mov    %rsp,%rbp
 80000106ec2:	41 57                	push   %r15
 80000106ec4:	41 56                	push   %r14
 80000106ec6:	41 55                	push   %r13
 80000106ec8:	41 54                	push   %r12
 80000106eca:	53                   	push   %rbx
 80000106ecb:	48 83 ec 28          	sub    $0x28,%rsp
 80000106ecf:	48 89 fb             	mov    %rdi,%rbx
  if(tf->trapno == T_SYSCALL){
 80000106ed2:	48 8b 47 78          	mov    0x78(%rdi),%rax
 80000106ed6:	48 83 f8 40          	cmp    $0x40,%rax
 80000106eda:	74 1b                	je     80000106ef7 <trap+0x39>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
 80000106edc:	48 83 e8 20          	sub    $0x20,%rax
 80000106ee0:	48 83 f8 1f          	cmp    $0x1f,%rax
 80000106ee4:	0f 87 7b 01 00 00    	ja     80000107065 <trap+0x1a7>
 80000106eea:	48 ba 70 b5 10 00 00 	movabs $0x8000010b570,%rdx
 80000106ef1:	08 00 00 
 80000106ef4:	ff 24 c2             	jmp    *(%rdx,%rax,8)
    if(myproc()->killed)
 80000106ef7:	b0 00                	mov    $0x0,%al
 80000106ef9:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000106f00:	08 00 00 
 80000106f03:	ff d2                	call   *%rdx
 80000106f05:	83 78 40 00          	cmpl   $0x0,0x40(%rax)
 80000106f09:	75 3f                	jne    80000106f4a <trap+0x8c>
    myproc()->tf = tf;
 80000106f0b:	b0 00                	mov    $0x0,%al
 80000106f0d:	49 bc 64 46 10 00 00 	movabs $0x80000104664,%r12
 80000106f14:	08 00 00 
 80000106f17:	41 ff d4             	call   *%r12
 80000106f1a:	48 89 58 28          	mov    %rbx,0x28(%rax)
    syscall();
 80000106f1e:	48 b8 8c 5a 10 00 00 	movabs $0x80000105a8c,%rax
 80000106f25:	08 00 00 
 80000106f28:	ff d0                	call   *%rax
    if(myproc()->killed)
 80000106f2a:	b0 00                	mov    $0x0,%al
 80000106f2c:	41 ff d4             	call   *%r12
 80000106f2f:	83 78 40 00          	cmpl   $0x0,0x40(%rax)
 80000106f33:	0f 84 72 02 00 00    	je     800001071ab <trap+0x2ed>
      exit();
 80000106f39:	48 b8 36 4c 10 00 00 	movabs $0x80000104c36,%rax
 80000106f40:	08 00 00 
 80000106f43:	ff d0                	call   *%rax
    return;
 80000106f45:	e9 61 02 00 00       	jmp    800001071ab <trap+0x2ed>
      exit();
 80000106f4a:	48 b8 36 4c 10 00 00 	movabs $0x80000104c36,%rax
 80000106f51:	08 00 00 
 80000106f54:	ff d0                	call   *%rax
 80000106f56:	eb b3                	jmp    80000106f0b <trap+0x4d>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
 80000106f58:	48 b8 3b 46 10 00 00 	movabs $0x8000010463b,%rax
 80000106f5f:	08 00 00 
 80000106f62:	ff d0                	call   *%rax
 80000106f64:	85 c0                	test   %eax,%eax
 80000106f66:	74 11                	je     80000106f79 <trap+0xbb>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
 80000106f68:	48 b8 c0 31 10 00 00 	movabs $0x800001031c0,%rax
 80000106f6f:	08 00 00 
 80000106f72:	ff d0                	call   *%rax
    break;
 80000106f74:	e9 97 01 00 00       	jmp    80000107110 <trap+0x252>
      acquire(&tickslock);
 80000106f79:	49 bc 00 df 11 00 00 	movabs $0x8000011df00,%r12
 80000106f80:	08 00 00 
 80000106f83:	4c 89 e7             	mov    %r12,%rdi
 80000106f86:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000106f8d:	08 00 00 
 80000106f90:	ff d0                	call   *%rax
      ticks++;
 80000106f92:	48 bf e0 de 11 00 00 	movabs $0x8000011dee0,%rdi
 80000106f99:	08 00 00 
 80000106f9c:	8b 07                	mov    (%rdi),%eax
 80000106f9e:	83 c0 01             	add    $0x1,%eax
 80000106fa1:	89 07                	mov    %eax,(%rdi)
      wakeup(&ticks);
 80000106fa3:	48 b8 18 50 10 00 00 	movabs $0x80000105018,%rax
 80000106faa:	08 00 00 
 80000106fad:	ff d0                	call   *%rax
      release(&tickslock);
 80000106faf:	4c 89 e7             	mov    %r12,%rdi
 80000106fb2:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000106fb9:	08 00 00 
 80000106fbc:	ff d0                	call   *%rax
 80000106fbe:	eb a8                	jmp    80000106f68 <trap+0xaa>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
 80000106fc0:	48 b8 9c 29 10 00 00 	movabs $0x8000010299c,%rax
 80000106fc7:	08 00 00 
 80000106fca:	ff d0                	call   *%rax
    lapiceoi();
 80000106fcc:	48 b8 c0 31 10 00 00 	movabs $0x800001031c0,%rax
 80000106fd3:	08 00 00 
 80000106fd6:	ff d0                	call   *%rax
    break;
 80000106fd8:	e9 33 01 00 00       	jmp    80000107110 <trap+0x252>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
 80000106fdd:	48 b8 c2 2f 10 00 00 	movabs $0x80000102fc2,%rax
 80000106fe4:	08 00 00 
 80000106fe7:	ff d0                	call   *%rax
    lapiceoi();
 80000106fe9:	48 b8 c0 31 10 00 00 	movabs $0x800001031c0,%rax
 80000106ff0:	08 00 00 
 80000106ff3:	ff d0                	call   *%rax
    break;
 80000106ff5:	e9 16 01 00 00       	jmp    80000107110 <trap+0x252>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
 80000106ffa:	48 b8 83 73 10 00 00 	movabs $0x80000107383,%rax
 80000107001:	08 00 00 
 80000107004:	ff d0                	call   *%rax
    lapiceoi();
 80000107006:	48 b8 c0 31 10 00 00 	movabs $0x800001031c0,%rax
 8000010700d:	08 00 00 
 80000107010:	ff d0                	call   *%rax
    break;
 80000107012:	e9 f9 00 00 00       	jmp    80000107110 <trap+0x252>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
 80000107017:	4c 8b af 88 00 00 00 	mov    0x88(%rdi),%r13
            cpuid(), tf->cs, tf->rip);
 8000010701e:	66 44 8b a7 90 00 00 	mov    0x90(%rdi),%r12w
 80000107025:	00 
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
 80000107026:	48 b8 3b 46 10 00 00 	movabs $0x8000010463b,%rax
 8000010702d:	08 00 00 
 80000107030:	ff d0                	call   *%rax
 80000107032:	89 c6                	mov    %eax,%esi
 80000107034:	41 0f b7 d4          	movzwl %r12w,%edx
 80000107038:	4c 89 e9             	mov    %r13,%rcx
 8000010703b:	48 bf 00 b0 10 00 00 	movabs $0x8000010b000,%rdi
 80000107042:	08 00 00 
 80000107045:	b0 00                	mov    $0x0,%al
 80000107047:	49 b8 f9 08 10 00 00 	movabs $0x800001008f9,%r8
 8000010704e:	08 00 00 
 80000107051:	41 ff d0             	call   *%r8
    lapiceoi();
 80000107054:	48 b8 c0 31 10 00 00 	movabs $0x800001031c0,%rax
 8000010705b:	08 00 00 
 8000010705e:	ff d0                	call   *%rax
    break;
 80000107060:	e9 ab 00 00 00       	jmp    80000107110 <trap+0x252>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
 80000107065:	b0 00                	mov    $0x0,%al
 80000107067:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 8000010706e:	08 00 00 
 80000107071:	ff d2                	call   *%rdx
 80000107073:	48 85 c0             	test   %rax,%rax
 80000107076:	0f 84 3e 01 00 00    	je     800001071ba <trap+0x2fc>
 8000010707c:	f6 83 90 00 00 00 03 	testb  $0x3,0x90(%rbx)
 80000107083:	0f 84 31 01 00 00    	je     800001071ba <trap+0x2fc>
  asm volatile("movq %%cr2,%0" : "=r" (val));
 80000107089:	41 0f 20 d7          	mov    %cr2,%r15
      cprintf("unexpected trap %d from cpu %d rip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->rip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
 8000010708d:	4c 8b b3 88 00 00 00 	mov    0x88(%rbx),%r14
 80000107094:	48 b8 3b 46 10 00 00 	movabs $0x8000010463b,%rax
 8000010709b:	08 00 00 
 8000010709e:	ff d0                	call   *%rax
 800001070a0:	89 45 cc             	mov    %eax,-0x34(%rbp)
 800001070a3:	4c 8b ab 80 00 00 00 	mov    0x80(%rbx),%r13
 800001070aa:	48 8b 4b 78          	mov    0x78(%rbx),%rcx
 800001070ae:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
            "rip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
 800001070b2:	b0 00                	mov    $0x0,%al
 800001070b4:	49 bc 64 46 10 00 00 	movabs $0x80000104664,%r12
 800001070bb:	08 00 00 
 800001070be:	41 ff d4             	call   *%r12
 800001070c1:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
 800001070c8:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
 800001070cc:	b0 00                	mov    $0x0,%al
 800001070ce:	41 ff d4             	call   *%r12
    cprintf("pid %d %s: trap %d err %d on cpu %d "
 800001070d1:	8b 70 1c             	mov    0x1c(%rax),%esi
 800001070d4:	41 57                	push   %r15
 800001070d6:	41 56                	push   %r14
 800001070d8:	44 8b 4d cc          	mov    -0x34(%rbp),%r9d
 800001070dc:	4d 89 e8             	mov    %r13,%r8
 800001070df:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
 800001070e3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
 800001070e7:	48 bf 60 b0 10 00 00 	movabs $0x8000010b060,%rdi
 800001070ee:	08 00 00 
 800001070f1:	b0 00                	mov    $0x0,%al
 800001070f3:	49 ba f9 08 10 00 00 	movabs $0x800001008f9,%r10
 800001070fa:	08 00 00 
 800001070fd:	41 ff d2             	call   *%r10
            tf->err, cpuid(), tf->rip, rcr2());
    myproc()->killed = 1;
 80000107100:	b0 00                	mov    $0x0,%al
 80000107102:	41 ff d4             	call   *%r12
 80000107105:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
 8000010710c:	48 83 c4 10          	add    $0x10,%rsp
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
 80000107110:	b0 00                	mov    $0x0,%al
 80000107112:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000107119:	08 00 00 
 8000010711c:	ff d2                	call   *%rdx
 8000010711e:	48 85 c0             	test   %rax,%rax
 80000107121:	74 25                	je     80000107148 <trap+0x28a>
 80000107123:	b0 00                	mov    $0x0,%al
 80000107125:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 8000010712c:	08 00 00 
 8000010712f:	ff d2                	call   *%rdx
 80000107131:	83 78 40 00          	cmpl   $0x0,0x40(%rax)
 80000107135:	74 11                	je     80000107148 <trap+0x28a>
 80000107137:	66 8b 83 90 00 00 00 	mov    0x90(%rbx),%ax
 8000010713e:	f7 d0                	not    %eax
 80000107140:	a8 03                	test   $0x3,%al
 80000107142:	0f 84 c4 00 00 00    	je     8000010720c <trap+0x34e>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
 80000107148:	b0 00                	mov    $0x0,%al
 8000010714a:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000107151:	08 00 00 
 80000107154:	ff d2                	call   *%rdx
 80000107156:	48 85 c0             	test   %rax,%rax
 80000107159:	74 18                	je     80000107173 <trap+0x2b5>
 8000010715b:	b0 00                	mov    $0x0,%al
 8000010715d:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000107164:	08 00 00 
 80000107167:	ff d2                	call   *%rdx
 80000107169:	83 78 18 04          	cmpl   $0x4,0x18(%rax)
 8000010716d:	0f 84 aa 00 00 00    	je     8000010721d <trap+0x35f>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
 80000107173:	b0 00                	mov    $0x0,%al
 80000107175:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 8000010717c:	08 00 00 
 8000010717f:	ff d2                	call   *%rdx
 80000107181:	48 85 c0             	test   %rax,%rax
 80000107184:	74 25                	je     800001071ab <trap+0x2ed>
 80000107186:	b0 00                	mov    $0x0,%al
 80000107188:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 8000010718f:	08 00 00 
 80000107192:	ff d2                	call   *%rdx
 80000107194:	83 78 40 00          	cmpl   $0x0,0x40(%rax)
 80000107198:	74 11                	je     800001071ab <trap+0x2ed>
 8000010719a:	66 8b 83 90 00 00 00 	mov    0x90(%rbx),%ax
 800001071a1:	f7 d0                	not    %eax
 800001071a3:	a8 03                	test   $0x3,%al
 800001071a5:	0f 84 8e 00 00 00    	je     80000107239 <trap+0x37b>
    exit();
}
 800001071ab:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
 800001071af:	5b                   	pop    %rbx
 800001071b0:	41 5c                	pop    %r12
 800001071b2:	41 5d                	pop    %r13
 800001071b4:	41 5e                	pop    %r14
 800001071b6:	41 5f                	pop    %r15
 800001071b8:	5d                   	pop    %rbp
 800001071b9:	c3                   	ret
 800001071ba:	41 0f 20 d5          	mov    %cr2,%r13
      cprintf("unexpected trap %d from cpu %d rip %x (cr2=0x%x)\n",
 800001071be:	4c 8b a3 88 00 00 00 	mov    0x88(%rbx),%r12
 800001071c5:	48 b8 3b 46 10 00 00 	movabs $0x8000010463b,%rax
 800001071cc:	08 00 00 
 800001071cf:	ff d0                	call   *%rax
 800001071d1:	89 c2                	mov    %eax,%edx
 800001071d3:	48 8b 73 78          	mov    0x78(%rbx),%rsi
 800001071d7:	4d 89 e8             	mov    %r13,%r8
 800001071da:	4c 89 e1             	mov    %r12,%rcx
 800001071dd:	48 bf 28 b0 10 00 00 	movabs $0x8000010b028,%rdi
 800001071e4:	08 00 00 
 800001071e7:	b0 00                	mov    $0x0,%al
 800001071e9:	49 b9 f9 08 10 00 00 	movabs $0x800001008f9,%r9
 800001071f0:	08 00 00 
 800001071f3:	41 ff d1             	call   *%r9
      panic("trap");
 800001071f6:	48 bf 93 ad 10 00 00 	movabs $0x8000010ad93,%rdi
 800001071fd:	08 00 00 
 80000107200:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000107207:	08 00 00 
 8000010720a:	ff d0                	call   *%rax
    exit();
 8000010720c:	48 b8 36 4c 10 00 00 	movabs $0x80000104c36,%rax
 80000107213:	08 00 00 
 80000107216:	ff d0                	call   *%rax
 80000107218:	e9 2b ff ff ff       	jmp    80000107148 <trap+0x28a>
  if(myproc() && myproc()->state == RUNNING &&
 8000010721d:	48 83 7b 78 20       	cmpq   $0x20,0x78(%rbx)
 80000107222:	0f 85 4b ff ff ff    	jne    80000107173 <trap+0x2b5>
    yield();
 80000107228:	48 b8 ac 4d 10 00 00 	movabs $0x80000104dac,%rax
 8000010722f:	08 00 00 
 80000107232:	ff d0                	call   *%rax
 80000107234:	e9 3a ff ff ff       	jmp    80000107173 <trap+0x2b5>
    exit();
 80000107239:	48 b8 36 4c 10 00 00 	movabs $0x80000104c36,%rax
 80000107240:	08 00 00 
 80000107243:	ff d0                	call   *%rax
 80000107245:	e9 61 ff ff ff       	jmp    800001071ab <trap+0x2ed>

000008000010724a <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
 8000010724a:	a1 80 ef 11 00 00 08 	movabs 0x8000011ef80,%eax
 80000107251:	00 00 
 80000107253:	85 c0                	test   %eax,%eax
 80000107255:	74 14                	je     8000010726b <uartgetc+0x21>
    asm volatile("in %1,%0" : "=a" (data) : "d" (port));
 80000107257:	ba fd 03 00 00       	mov    $0x3fd,%edx
 8000010725c:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
 8000010725d:	a8 01                	test   $0x1,%al
 8000010725f:	74 10                	je     80000107271 <uartgetc+0x27>
 80000107261:	ba f8 03 00 00       	mov    $0x3f8,%edx
 80000107266:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
 80000107267:	0f b6 c0             	movzbl %al,%eax
 8000010726a:	c3                   	ret
    return -1;
 8000010726b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000107270:	c3                   	ret
    return -1;
 80000107271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 80000107276:	c3                   	ret

0000080000107277 <uartputc>:
  if(!uart)
 80000107277:	a1 80 ef 11 00 00 08 	movabs 0x8000011ef80,%eax
 8000010727e:	00 00 
 80000107280:	85 c0                	test   %eax,%eax
 80000107282:	74 45                	je     800001072c9 <uartputc+0x52>
{
 80000107284:	55                   	push   %rbp
 80000107285:	48 89 e5             	mov    %rsp,%rbp
 80000107288:	41 54                	push   %r12
 8000010728a:	53                   	push   %rbx
 8000010728b:	41 89 fc             	mov    %edi,%r12d
  for(i = 0; i < 100000 && !(inb(COM1+5) & 0x20); i++)
 8000010728e:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000107293:	eb 14                	jmp    800001072a9 <uartputc+0x32>
    microdelay(10);
 80000107295:	bf 0a 00 00 00       	mov    $0xa,%edi
 8000010729a:	48 ba ec 31 10 00 00 	movabs $0x800001031ec,%rdx
 800001072a1:	08 00 00 
 800001072a4:	ff d2                	call   *%rdx
  for(i = 0; i < 100000 && !(inb(COM1+5) & 0x20); i++)
 800001072a6:	83 c3 01             	add    $0x1,%ebx
 800001072a9:	81 fb 9f 86 01 00    	cmp    $0x1869f,%ebx
 800001072af:	7f 0a                	jg     800001072bb <uartputc+0x44>
 800001072b1:	ba fd 03 00 00       	mov    $0x3fd,%edx
 800001072b6:	ec                   	in     (%dx),%al
 800001072b7:	a8 20                	test   $0x20,%al
 800001072b9:	74 da                	je     80000107295 <uartputc+0x1e>
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
 800001072bb:	ba f8 03 00 00       	mov    $0x3f8,%edx
 800001072c0:	44 88 e0             	mov    %r12b,%al
 800001072c3:	ee                   	out    %al,(%dx)
}
 800001072c4:	5b                   	pop    %rbx
 800001072c5:	41 5c                	pop    %r12
 800001072c7:	5d                   	pop    %rbp
 800001072c8:	c3                   	ret
 800001072c9:	c3                   	ret

00000800001072ca <uartinit>:
 800001072ca:	40 b7 00             	mov    $0x0,%dil
 800001072cd:	ba fa 03 00 00       	mov    $0x3fa,%edx
 800001072d2:	40 88 f8             	mov    %dil,%al
 800001072d5:	ee                   	out    %al,(%dx)
 800001072d6:	be fb 03 00 00       	mov    $0x3fb,%esi
 800001072db:	b0 80                	mov    $0x80,%al
 800001072dd:	89 f2                	mov    %esi,%edx
 800001072df:	ee                   	out    %al,(%dx)
 800001072e0:	b0 0c                	mov    $0xc,%al
 800001072e2:	ba f8 03 00 00       	mov    $0x3f8,%edx
 800001072e7:	ee                   	out    %al,(%dx)
 800001072e8:	b9 f9 03 00 00       	mov    $0x3f9,%ecx
 800001072ed:	40 88 f8             	mov    %dil,%al
 800001072f0:	89 ca                	mov    %ecx,%edx
 800001072f2:	ee                   	out    %al,(%dx)
 800001072f3:	b0 03                	mov    $0x3,%al
 800001072f5:	89 f2                	mov    %esi,%edx
 800001072f7:	ee                   	out    %al,(%dx)
 800001072f8:	b0 08                	mov    $0x8,%al
 800001072fa:	ba fc 03 00 00       	mov    $0x3fc,%edx
 800001072ff:	ee                   	out    %al,(%dx)
 80000107300:	b0 01                	mov    $0x1,%al
 80000107302:	89 ca                	mov    %ecx,%edx
 80000107304:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0" : "=a" (data) : "d" (port));
 80000107305:	ba fd 03 00 00       	mov    $0x3fd,%edx
 8000010730a:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
 8000010730b:	0f b6 c0             	movzbl %al,%eax
 8000010730e:	3d ff 00 00 00       	cmp    $0xff,%eax
 80000107313:	74 6d                	je     80000107382 <uartinit+0xb8>
{
 80000107315:	55                   	push   %rbp
 80000107316:	48 89 e5             	mov    %rsp,%rbp
 80000107319:	53                   	push   %rbx
 8000010731a:	48 83 ec 08          	sub    $0x8,%rsp
  uart = 1;
 8000010731e:	48 b8 80 ef 11 00 00 	movabs $0x8000011ef80,%rax
 80000107325:	08 00 00 
 80000107328:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
 8000010732e:	ba fa 03 00 00       	mov    $0x3fa,%edx
 80000107333:	ec                   	in     (%dx),%al
 80000107334:	ba f8 03 00 00       	mov    $0x3f8,%edx
 80000107339:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
 8000010733a:	be 00 00 00 00       	mov    $0x0,%esi
 8000010733f:	bf 04 00 00 00       	mov    $0x4,%edi
 80000107344:	48 b8 91 2c 10 00 00 	movabs $0x80000102c91,%rax
 8000010734b:	08 00 00 
 8000010734e:	ff d0                	call   *%rax
  for(p="xv6...\n"; *p; p++)
 80000107350:	48 bb 98 ad 10 00 00 	movabs $0x8000010ad98,%rbx
 80000107357:	08 00 00 
 8000010735a:	eb 14                	jmp    80000107370 <uartinit+0xa6>
    uartputc(*p);
 8000010735c:	40 0f be ff          	movsbl %dil,%edi
 80000107360:	48 b8 77 72 10 00 00 	movabs $0x80000107277,%rax
 80000107367:	08 00 00 
 8000010736a:	ff d0                	call   *%rax
  for(p="xv6...\n"; *p; p++)
 8000010736c:	48 83 c3 01          	add    $0x1,%rbx
 80000107370:	40 8a 3b             	mov    (%rbx),%dil
 80000107373:	40 0f be c7          	movsbl %dil,%eax
 80000107377:	85 c0                	test   %eax,%eax
 80000107379:	75 e1                	jne    8000010735c <uartinit+0x92>
}
 8000010737b:	48 83 c4 08          	add    $0x8,%rsp
 8000010737f:	5b                   	pop    %rbx
 80000107380:	5d                   	pop    %rbp
 80000107381:	c3                   	ret
 80000107382:	c3                   	ret

0000080000107383 <uartintr>:

void
uartintr(void)
{
 80000107383:	55                   	push   %rbp
 80000107384:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(uartgetc);
 80000107387:	48 bf 4a 72 10 00 00 	movabs $0x8000010724a,%rdi
 8000010738e:	08 00 00 
 80000107391:	48 b8 50 0b 10 00 00 	movabs $0x80000100b50,%rax
 80000107398:	08 00 00 
 8000010739b:	ff d0                	call   *%rax
}
 8000010739d:	5d                   	pop    %rbp
 8000010739e:	c3                   	ret

000008000010739f <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushq $0
 8000010739f:	6a 00                	push   $0x0
  pushq $0
 800001073a1:	6a 00                	push   $0x0
  jmp alltraps
 800001073a3:	e9 67 f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073a8 <vector1>:
.globl vector1
vector1:
  pushq $0
 800001073a8:	6a 00                	push   $0x0
  pushq $1
 800001073aa:	6a 01                	push   $0x1
  jmp alltraps
 800001073ac:	e9 5e f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073b1 <vector2>:
.globl vector2
vector2:
  pushq $0
 800001073b1:	6a 00                	push   $0x0
  pushq $2
 800001073b3:	6a 02                	push   $0x2
  jmp alltraps
 800001073b5:	e9 55 f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073ba <vector3>:
.globl vector3
vector3:
  pushq $0
 800001073ba:	6a 00                	push   $0x0
  pushq $3
 800001073bc:	6a 03                	push   $0x3
  jmp alltraps
 800001073be:	e9 4c f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073c3 <vector4>:
.globl vector4
vector4:
  pushq $0
 800001073c3:	6a 00                	push   $0x0
  pushq $4
 800001073c5:	6a 04                	push   $0x4
  jmp alltraps
 800001073c7:	e9 43 f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073cc <vector5>:
.globl vector5
vector5:
  pushq $0
 800001073cc:	6a 00                	push   $0x0
  pushq $5
 800001073ce:	6a 05                	push   $0x5
  jmp alltraps
 800001073d0:	e9 3a f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073d5 <vector6>:
.globl vector6
vector6:
  pushq $0
 800001073d5:	6a 00                	push   $0x0
  pushq $6
 800001073d7:	6a 06                	push   $0x6
  jmp alltraps
 800001073d9:	e9 31 f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073de <vector7>:
.globl vector7
vector7:
  pushq $0
 800001073de:	6a 00                	push   $0x0
  pushq $7
 800001073e0:	6a 07                	push   $0x7
  jmp alltraps
 800001073e2:	e9 28 f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073e7 <vector8>:
.globl vector8
vector8:
  pushq $8
 800001073e7:	6a 08                	push   $0x8
  jmp alltraps
 800001073e9:	e9 21 f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073ee <vector9>:
.globl vector9
vector9:
  pushq $0
 800001073ee:	6a 00                	push   $0x0
  pushq $9
 800001073f0:	6a 09                	push   $0x9
  jmp alltraps
 800001073f2:	e9 18 f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073f7 <vector10>:
.globl vector10
vector10:
  pushq $10
 800001073f7:	6a 0a                	push   $0xa
  jmp alltraps
 800001073f9:	e9 11 f9 ff ff       	jmp    80000106d0f <alltraps>

00000800001073fe <vector11>:
.globl vector11
vector11:
  pushq $11
 800001073fe:	6a 0b                	push   $0xb
  jmp alltraps
 80000107400:	e9 0a f9 ff ff       	jmp    80000106d0f <alltraps>

0000080000107405 <vector12>:
.globl vector12
vector12:
  pushq $12
 80000107405:	6a 0c                	push   $0xc
  jmp alltraps
 80000107407:	e9 03 f9 ff ff       	jmp    80000106d0f <alltraps>

000008000010740c <vector13>:
.globl vector13
vector13:
  pushq $13
 8000010740c:	6a 0d                	push   $0xd
  jmp alltraps
 8000010740e:	e9 fc f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107413 <vector14>:
.globl vector14
vector14:
  pushq $14
 80000107413:	6a 0e                	push   $0xe
  jmp alltraps
 80000107415:	e9 f5 f8 ff ff       	jmp    80000106d0f <alltraps>

000008000010741a <vector15>:
.globl vector15
vector15:
  pushq $0
 8000010741a:	6a 00                	push   $0x0
  pushq $15
 8000010741c:	6a 0f                	push   $0xf
  jmp alltraps
 8000010741e:	e9 ec f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107423 <vector16>:
.globl vector16
vector16:
  pushq $0
 80000107423:	6a 00                	push   $0x0
  pushq $16
 80000107425:	6a 10                	push   $0x10
  jmp alltraps
 80000107427:	e9 e3 f8 ff ff       	jmp    80000106d0f <alltraps>

000008000010742c <vector17>:
.globl vector17
vector17:
  pushq $17
 8000010742c:	6a 11                	push   $0x11
  jmp alltraps
 8000010742e:	e9 dc f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107433 <vector18>:
.globl vector18
vector18:
  pushq $0
 80000107433:	6a 00                	push   $0x0
  pushq $18
 80000107435:	6a 12                	push   $0x12
  jmp alltraps
 80000107437:	e9 d3 f8 ff ff       	jmp    80000106d0f <alltraps>

000008000010743c <vector19>:
.globl vector19
vector19:
  pushq $0
 8000010743c:	6a 00                	push   $0x0
  pushq $19
 8000010743e:	6a 13                	push   $0x13
  jmp alltraps
 80000107440:	e9 ca f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107445 <vector20>:
.globl vector20
vector20:
  pushq $0
 80000107445:	6a 00                	push   $0x0
  pushq $20
 80000107447:	6a 14                	push   $0x14
  jmp alltraps
 80000107449:	e9 c1 f8 ff ff       	jmp    80000106d0f <alltraps>

000008000010744e <vector21>:
.globl vector21
vector21:
  pushq $0
 8000010744e:	6a 00                	push   $0x0
  pushq $21
 80000107450:	6a 15                	push   $0x15
  jmp alltraps
 80000107452:	e9 b8 f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107457 <vector22>:
.globl vector22
vector22:
  pushq $0
 80000107457:	6a 00                	push   $0x0
  pushq $22
 80000107459:	6a 16                	push   $0x16
  jmp alltraps
 8000010745b:	e9 af f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107460 <vector23>:
.globl vector23
vector23:
  pushq $0
 80000107460:	6a 00                	push   $0x0
  pushq $23
 80000107462:	6a 17                	push   $0x17
  jmp alltraps
 80000107464:	e9 a6 f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107469 <vector24>:
.globl vector24
vector24:
  pushq $0
 80000107469:	6a 00                	push   $0x0
  pushq $24
 8000010746b:	6a 18                	push   $0x18
  jmp alltraps
 8000010746d:	e9 9d f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107472 <vector25>:
.globl vector25
vector25:
  pushq $0
 80000107472:	6a 00                	push   $0x0
  pushq $25
 80000107474:	6a 19                	push   $0x19
  jmp alltraps
 80000107476:	e9 94 f8 ff ff       	jmp    80000106d0f <alltraps>

000008000010747b <vector26>:
.globl vector26
vector26:
  pushq $0
 8000010747b:	6a 00                	push   $0x0
  pushq $26
 8000010747d:	6a 1a                	push   $0x1a
  jmp alltraps
 8000010747f:	e9 8b f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107484 <vector27>:
.globl vector27
vector27:
  pushq $0
 80000107484:	6a 00                	push   $0x0
  pushq $27
 80000107486:	6a 1b                	push   $0x1b
  jmp alltraps
 80000107488:	e9 82 f8 ff ff       	jmp    80000106d0f <alltraps>

000008000010748d <vector28>:
.globl vector28
vector28:
  pushq $0
 8000010748d:	6a 00                	push   $0x0
  pushq $28
 8000010748f:	6a 1c                	push   $0x1c
  jmp alltraps
 80000107491:	e9 79 f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107496 <vector29>:
.globl vector29
vector29:
  pushq $0
 80000107496:	6a 00                	push   $0x0
  pushq $29
 80000107498:	6a 1d                	push   $0x1d
  jmp alltraps
 8000010749a:	e9 70 f8 ff ff       	jmp    80000106d0f <alltraps>

000008000010749f <vector30>:
.globl vector30
vector30:
  pushq $0
 8000010749f:	6a 00                	push   $0x0
  pushq $30
 800001074a1:	6a 1e                	push   $0x1e
  jmp alltraps
 800001074a3:	e9 67 f8 ff ff       	jmp    80000106d0f <alltraps>

00000800001074a8 <vector31>:
.globl vector31
vector31:
  pushq $0
 800001074a8:	6a 00                	push   $0x0
  pushq $31
 800001074aa:	6a 1f                	push   $0x1f
  jmp alltraps
 800001074ac:	e9 5e f8 ff ff       	jmp    80000106d0f <alltraps>

00000800001074b1 <vector32>:
.globl vector32
vector32:
  pushq $0
 800001074b1:	6a 00                	push   $0x0
  pushq $32
 800001074b3:	6a 20                	push   $0x20
  jmp alltraps
 800001074b5:	e9 55 f8 ff ff       	jmp    80000106d0f <alltraps>

00000800001074ba <vector33>:
.globl vector33
vector33:
  pushq $0
 800001074ba:	6a 00                	push   $0x0
  pushq $33
 800001074bc:	6a 21                	push   $0x21
  jmp alltraps
 800001074be:	e9 4c f8 ff ff       	jmp    80000106d0f <alltraps>

00000800001074c3 <vector34>:
.globl vector34
vector34:
  pushq $0
 800001074c3:	6a 00                	push   $0x0
  pushq $34
 800001074c5:	6a 22                	push   $0x22
  jmp alltraps
 800001074c7:	e9 43 f8 ff ff       	jmp    80000106d0f <alltraps>

00000800001074cc <vector35>:
.globl vector35
vector35:
  pushq $0
 800001074cc:	6a 00                	push   $0x0
  pushq $35
 800001074ce:	6a 23                	push   $0x23
  jmp alltraps
 800001074d0:	e9 3a f8 ff ff       	jmp    80000106d0f <alltraps>

00000800001074d5 <vector36>:
.globl vector36
vector36:
  pushq $0
 800001074d5:	6a 00                	push   $0x0
  pushq $36
 800001074d7:	6a 24                	push   $0x24
  jmp alltraps
 800001074d9:	e9 31 f8 ff ff       	jmp    80000106d0f <alltraps>

00000800001074de <vector37>:
.globl vector37
vector37:
  pushq $0
 800001074de:	6a 00                	push   $0x0
  pushq $37
 800001074e0:	6a 25                	push   $0x25
  jmp alltraps
 800001074e2:	e9 28 f8 ff ff       	jmp    80000106d0f <alltraps>

00000800001074e7 <vector38>:
.globl vector38
vector38:
  pushq $0
 800001074e7:	6a 00                	push   $0x0
  pushq $38
 800001074e9:	6a 26                	push   $0x26
  jmp alltraps
 800001074eb:	e9 1f f8 ff ff       	jmp    80000106d0f <alltraps>

00000800001074f0 <vector39>:
.globl vector39
vector39:
  pushq $0
 800001074f0:	6a 00                	push   $0x0
  pushq $39
 800001074f2:	6a 27                	push   $0x27
  jmp alltraps
 800001074f4:	e9 16 f8 ff ff       	jmp    80000106d0f <alltraps>

00000800001074f9 <vector40>:
.globl vector40
vector40:
  pushq $0
 800001074f9:	6a 00                	push   $0x0
  pushq $40
 800001074fb:	6a 28                	push   $0x28
  jmp alltraps
 800001074fd:	e9 0d f8 ff ff       	jmp    80000106d0f <alltraps>

0000080000107502 <vector41>:
.globl vector41
vector41:
  pushq $0
 80000107502:	6a 00                	push   $0x0
  pushq $41
 80000107504:	6a 29                	push   $0x29
  jmp alltraps
 80000107506:	e9 04 f8 ff ff       	jmp    80000106d0f <alltraps>

000008000010750b <vector42>:
.globl vector42
vector42:
  pushq $0
 8000010750b:	6a 00                	push   $0x0
  pushq $42
 8000010750d:	6a 2a                	push   $0x2a
  jmp alltraps
 8000010750f:	e9 fb f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107514 <vector43>:
.globl vector43
vector43:
  pushq $0
 80000107514:	6a 00                	push   $0x0
  pushq $43
 80000107516:	6a 2b                	push   $0x2b
  jmp alltraps
 80000107518:	e9 f2 f7 ff ff       	jmp    80000106d0f <alltraps>

000008000010751d <vector44>:
.globl vector44
vector44:
  pushq $0
 8000010751d:	6a 00                	push   $0x0
  pushq $44
 8000010751f:	6a 2c                	push   $0x2c
  jmp alltraps
 80000107521:	e9 e9 f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107526 <vector45>:
.globl vector45
vector45:
  pushq $0
 80000107526:	6a 00                	push   $0x0
  pushq $45
 80000107528:	6a 2d                	push   $0x2d
  jmp alltraps
 8000010752a:	e9 e0 f7 ff ff       	jmp    80000106d0f <alltraps>

000008000010752f <vector46>:
.globl vector46
vector46:
  pushq $0
 8000010752f:	6a 00                	push   $0x0
  pushq $46
 80000107531:	6a 2e                	push   $0x2e
  jmp alltraps
 80000107533:	e9 d7 f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107538 <vector47>:
.globl vector47
vector47:
  pushq $0
 80000107538:	6a 00                	push   $0x0
  pushq $47
 8000010753a:	6a 2f                	push   $0x2f
  jmp alltraps
 8000010753c:	e9 ce f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107541 <vector48>:
.globl vector48
vector48:
  pushq $0
 80000107541:	6a 00                	push   $0x0
  pushq $48
 80000107543:	6a 30                	push   $0x30
  jmp alltraps
 80000107545:	e9 c5 f7 ff ff       	jmp    80000106d0f <alltraps>

000008000010754a <vector49>:
.globl vector49
vector49:
  pushq $0
 8000010754a:	6a 00                	push   $0x0
  pushq $49
 8000010754c:	6a 31                	push   $0x31
  jmp alltraps
 8000010754e:	e9 bc f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107553 <vector50>:
.globl vector50
vector50:
  pushq $0
 80000107553:	6a 00                	push   $0x0
  pushq $50
 80000107555:	6a 32                	push   $0x32
  jmp alltraps
 80000107557:	e9 b3 f7 ff ff       	jmp    80000106d0f <alltraps>

000008000010755c <vector51>:
.globl vector51
vector51:
  pushq $0
 8000010755c:	6a 00                	push   $0x0
  pushq $51
 8000010755e:	6a 33                	push   $0x33
  jmp alltraps
 80000107560:	e9 aa f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107565 <vector52>:
.globl vector52
vector52:
  pushq $0
 80000107565:	6a 00                	push   $0x0
  pushq $52
 80000107567:	6a 34                	push   $0x34
  jmp alltraps
 80000107569:	e9 a1 f7 ff ff       	jmp    80000106d0f <alltraps>

000008000010756e <vector53>:
.globl vector53
vector53:
  pushq $0
 8000010756e:	6a 00                	push   $0x0
  pushq $53
 80000107570:	6a 35                	push   $0x35
  jmp alltraps
 80000107572:	e9 98 f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107577 <vector54>:
.globl vector54
vector54:
  pushq $0
 80000107577:	6a 00                	push   $0x0
  pushq $54
 80000107579:	6a 36                	push   $0x36
  jmp alltraps
 8000010757b:	e9 8f f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107580 <vector55>:
.globl vector55
vector55:
  pushq $0
 80000107580:	6a 00                	push   $0x0
  pushq $55
 80000107582:	6a 37                	push   $0x37
  jmp alltraps
 80000107584:	e9 86 f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107589 <vector56>:
.globl vector56
vector56:
  pushq $0
 80000107589:	6a 00                	push   $0x0
  pushq $56
 8000010758b:	6a 38                	push   $0x38
  jmp alltraps
 8000010758d:	e9 7d f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107592 <vector57>:
.globl vector57
vector57:
  pushq $0
 80000107592:	6a 00                	push   $0x0
  pushq $57
 80000107594:	6a 39                	push   $0x39
  jmp alltraps
 80000107596:	e9 74 f7 ff ff       	jmp    80000106d0f <alltraps>

000008000010759b <vector58>:
.globl vector58
vector58:
  pushq $0
 8000010759b:	6a 00                	push   $0x0
  pushq $58
 8000010759d:	6a 3a                	push   $0x3a
  jmp alltraps
 8000010759f:	e9 6b f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075a4 <vector59>:
.globl vector59
vector59:
  pushq $0
 800001075a4:	6a 00                	push   $0x0
  pushq $59
 800001075a6:	6a 3b                	push   $0x3b
  jmp alltraps
 800001075a8:	e9 62 f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075ad <vector60>:
.globl vector60
vector60:
  pushq $0
 800001075ad:	6a 00                	push   $0x0
  pushq $60
 800001075af:	6a 3c                	push   $0x3c
  jmp alltraps
 800001075b1:	e9 59 f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075b6 <vector61>:
.globl vector61
vector61:
  pushq $0
 800001075b6:	6a 00                	push   $0x0
  pushq $61
 800001075b8:	6a 3d                	push   $0x3d
  jmp alltraps
 800001075ba:	e9 50 f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075bf <vector62>:
.globl vector62
vector62:
  pushq $0
 800001075bf:	6a 00                	push   $0x0
  pushq $62
 800001075c1:	6a 3e                	push   $0x3e
  jmp alltraps
 800001075c3:	e9 47 f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075c8 <vector63>:
.globl vector63
vector63:
  pushq $0
 800001075c8:	6a 00                	push   $0x0
  pushq $63
 800001075ca:	6a 3f                	push   $0x3f
  jmp alltraps
 800001075cc:	e9 3e f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075d1 <vector64>:
.globl vector64
vector64:
  pushq $0
 800001075d1:	6a 00                	push   $0x0
  pushq $64
 800001075d3:	6a 40                	push   $0x40
  jmp alltraps
 800001075d5:	e9 35 f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075da <vector65>:
.globl vector65
vector65:
  pushq $0
 800001075da:	6a 00                	push   $0x0
  pushq $65
 800001075dc:	6a 41                	push   $0x41
  jmp alltraps
 800001075de:	e9 2c f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075e3 <vector66>:
.globl vector66
vector66:
  pushq $0
 800001075e3:	6a 00                	push   $0x0
  pushq $66
 800001075e5:	6a 42                	push   $0x42
  jmp alltraps
 800001075e7:	e9 23 f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075ec <vector67>:
.globl vector67
vector67:
  pushq $0
 800001075ec:	6a 00                	push   $0x0
  pushq $67
 800001075ee:	6a 43                	push   $0x43
  jmp alltraps
 800001075f0:	e9 1a f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075f5 <vector68>:
.globl vector68
vector68:
  pushq $0
 800001075f5:	6a 00                	push   $0x0
  pushq $68
 800001075f7:	6a 44                	push   $0x44
  jmp alltraps
 800001075f9:	e9 11 f7 ff ff       	jmp    80000106d0f <alltraps>

00000800001075fe <vector69>:
.globl vector69
vector69:
  pushq $0
 800001075fe:	6a 00                	push   $0x0
  pushq $69
 80000107600:	6a 45                	push   $0x45
  jmp alltraps
 80000107602:	e9 08 f7 ff ff       	jmp    80000106d0f <alltraps>

0000080000107607 <vector70>:
.globl vector70
vector70:
  pushq $0
 80000107607:	6a 00                	push   $0x0
  pushq $70
 80000107609:	6a 46                	push   $0x46
  jmp alltraps
 8000010760b:	e9 ff f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107610 <vector71>:
.globl vector71
vector71:
  pushq $0
 80000107610:	6a 00                	push   $0x0
  pushq $71
 80000107612:	6a 47                	push   $0x47
  jmp alltraps
 80000107614:	e9 f6 f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107619 <vector72>:
.globl vector72
vector72:
  pushq $0
 80000107619:	6a 00                	push   $0x0
  pushq $72
 8000010761b:	6a 48                	push   $0x48
  jmp alltraps
 8000010761d:	e9 ed f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107622 <vector73>:
.globl vector73
vector73:
  pushq $0
 80000107622:	6a 00                	push   $0x0
  pushq $73
 80000107624:	6a 49                	push   $0x49
  jmp alltraps
 80000107626:	e9 e4 f6 ff ff       	jmp    80000106d0f <alltraps>

000008000010762b <vector74>:
.globl vector74
vector74:
  pushq $0
 8000010762b:	6a 00                	push   $0x0
  pushq $74
 8000010762d:	6a 4a                	push   $0x4a
  jmp alltraps
 8000010762f:	e9 db f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107634 <vector75>:
.globl vector75
vector75:
  pushq $0
 80000107634:	6a 00                	push   $0x0
  pushq $75
 80000107636:	6a 4b                	push   $0x4b
  jmp alltraps
 80000107638:	e9 d2 f6 ff ff       	jmp    80000106d0f <alltraps>

000008000010763d <vector76>:
.globl vector76
vector76:
  pushq $0
 8000010763d:	6a 00                	push   $0x0
  pushq $76
 8000010763f:	6a 4c                	push   $0x4c
  jmp alltraps
 80000107641:	e9 c9 f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107646 <vector77>:
.globl vector77
vector77:
  pushq $0
 80000107646:	6a 00                	push   $0x0
  pushq $77
 80000107648:	6a 4d                	push   $0x4d
  jmp alltraps
 8000010764a:	e9 c0 f6 ff ff       	jmp    80000106d0f <alltraps>

000008000010764f <vector78>:
.globl vector78
vector78:
  pushq $0
 8000010764f:	6a 00                	push   $0x0
  pushq $78
 80000107651:	6a 4e                	push   $0x4e
  jmp alltraps
 80000107653:	e9 b7 f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107658 <vector79>:
.globl vector79
vector79:
  pushq $0
 80000107658:	6a 00                	push   $0x0
  pushq $79
 8000010765a:	6a 4f                	push   $0x4f
  jmp alltraps
 8000010765c:	e9 ae f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107661 <vector80>:
.globl vector80
vector80:
  pushq $0
 80000107661:	6a 00                	push   $0x0
  pushq $80
 80000107663:	6a 50                	push   $0x50
  jmp alltraps
 80000107665:	e9 a5 f6 ff ff       	jmp    80000106d0f <alltraps>

000008000010766a <vector81>:
.globl vector81
vector81:
  pushq $0
 8000010766a:	6a 00                	push   $0x0
  pushq $81
 8000010766c:	6a 51                	push   $0x51
  jmp alltraps
 8000010766e:	e9 9c f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107673 <vector82>:
.globl vector82
vector82:
  pushq $0
 80000107673:	6a 00                	push   $0x0
  pushq $82
 80000107675:	6a 52                	push   $0x52
  jmp alltraps
 80000107677:	e9 93 f6 ff ff       	jmp    80000106d0f <alltraps>

000008000010767c <vector83>:
.globl vector83
vector83:
  pushq $0
 8000010767c:	6a 00                	push   $0x0
  pushq $83
 8000010767e:	6a 53                	push   $0x53
  jmp alltraps
 80000107680:	e9 8a f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107685 <vector84>:
.globl vector84
vector84:
  pushq $0
 80000107685:	6a 00                	push   $0x0
  pushq $84
 80000107687:	6a 54                	push   $0x54
  jmp alltraps
 80000107689:	e9 81 f6 ff ff       	jmp    80000106d0f <alltraps>

000008000010768e <vector85>:
.globl vector85
vector85:
  pushq $0
 8000010768e:	6a 00                	push   $0x0
  pushq $85
 80000107690:	6a 55                	push   $0x55
  jmp alltraps
 80000107692:	e9 78 f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107697 <vector86>:
.globl vector86
vector86:
  pushq $0
 80000107697:	6a 00                	push   $0x0
  pushq $86
 80000107699:	6a 56                	push   $0x56
  jmp alltraps
 8000010769b:	e9 6f f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076a0 <vector87>:
.globl vector87
vector87:
  pushq $0
 800001076a0:	6a 00                	push   $0x0
  pushq $87
 800001076a2:	6a 57                	push   $0x57
  jmp alltraps
 800001076a4:	e9 66 f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076a9 <vector88>:
.globl vector88
vector88:
  pushq $0
 800001076a9:	6a 00                	push   $0x0
  pushq $88
 800001076ab:	6a 58                	push   $0x58
  jmp alltraps
 800001076ad:	e9 5d f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076b2 <vector89>:
.globl vector89
vector89:
  pushq $0
 800001076b2:	6a 00                	push   $0x0
  pushq $89
 800001076b4:	6a 59                	push   $0x59
  jmp alltraps
 800001076b6:	e9 54 f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076bb <vector90>:
.globl vector90
vector90:
  pushq $0
 800001076bb:	6a 00                	push   $0x0
  pushq $90
 800001076bd:	6a 5a                	push   $0x5a
  jmp alltraps
 800001076bf:	e9 4b f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076c4 <vector91>:
.globl vector91
vector91:
  pushq $0
 800001076c4:	6a 00                	push   $0x0
  pushq $91
 800001076c6:	6a 5b                	push   $0x5b
  jmp alltraps
 800001076c8:	e9 42 f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076cd <vector92>:
.globl vector92
vector92:
  pushq $0
 800001076cd:	6a 00                	push   $0x0
  pushq $92
 800001076cf:	6a 5c                	push   $0x5c
  jmp alltraps
 800001076d1:	e9 39 f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076d6 <vector93>:
.globl vector93
vector93:
  pushq $0
 800001076d6:	6a 00                	push   $0x0
  pushq $93
 800001076d8:	6a 5d                	push   $0x5d
  jmp alltraps
 800001076da:	e9 30 f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076df <vector94>:
.globl vector94
vector94:
  pushq $0
 800001076df:	6a 00                	push   $0x0
  pushq $94
 800001076e1:	6a 5e                	push   $0x5e
  jmp alltraps
 800001076e3:	e9 27 f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076e8 <vector95>:
.globl vector95
vector95:
  pushq $0
 800001076e8:	6a 00                	push   $0x0
  pushq $95
 800001076ea:	6a 5f                	push   $0x5f
  jmp alltraps
 800001076ec:	e9 1e f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076f1 <vector96>:
.globl vector96
vector96:
  pushq $0
 800001076f1:	6a 00                	push   $0x0
  pushq $96
 800001076f3:	6a 60                	push   $0x60
  jmp alltraps
 800001076f5:	e9 15 f6 ff ff       	jmp    80000106d0f <alltraps>

00000800001076fa <vector97>:
.globl vector97
vector97:
  pushq $0
 800001076fa:	6a 00                	push   $0x0
  pushq $97
 800001076fc:	6a 61                	push   $0x61
  jmp alltraps
 800001076fe:	e9 0c f6 ff ff       	jmp    80000106d0f <alltraps>

0000080000107703 <vector98>:
.globl vector98
vector98:
  pushq $0
 80000107703:	6a 00                	push   $0x0
  pushq $98
 80000107705:	6a 62                	push   $0x62
  jmp alltraps
 80000107707:	e9 03 f6 ff ff       	jmp    80000106d0f <alltraps>

000008000010770c <vector99>:
.globl vector99
vector99:
  pushq $0
 8000010770c:	6a 00                	push   $0x0
  pushq $99
 8000010770e:	6a 63                	push   $0x63
  jmp alltraps
 80000107710:	e9 fa f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107715 <vector100>:
.globl vector100
vector100:
  pushq $0
 80000107715:	6a 00                	push   $0x0
  pushq $100
 80000107717:	6a 64                	push   $0x64
  jmp alltraps
 80000107719:	e9 f1 f5 ff ff       	jmp    80000106d0f <alltraps>

000008000010771e <vector101>:
.globl vector101
vector101:
  pushq $0
 8000010771e:	6a 00                	push   $0x0
  pushq $101
 80000107720:	6a 65                	push   $0x65
  jmp alltraps
 80000107722:	e9 e8 f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107727 <vector102>:
.globl vector102
vector102:
  pushq $0
 80000107727:	6a 00                	push   $0x0
  pushq $102
 80000107729:	6a 66                	push   $0x66
  jmp alltraps
 8000010772b:	e9 df f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107730 <vector103>:
.globl vector103
vector103:
  pushq $0
 80000107730:	6a 00                	push   $0x0
  pushq $103
 80000107732:	6a 67                	push   $0x67
  jmp alltraps
 80000107734:	e9 d6 f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107739 <vector104>:
.globl vector104
vector104:
  pushq $0
 80000107739:	6a 00                	push   $0x0
  pushq $104
 8000010773b:	6a 68                	push   $0x68
  jmp alltraps
 8000010773d:	e9 cd f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107742 <vector105>:
.globl vector105
vector105:
  pushq $0
 80000107742:	6a 00                	push   $0x0
  pushq $105
 80000107744:	6a 69                	push   $0x69
  jmp alltraps
 80000107746:	e9 c4 f5 ff ff       	jmp    80000106d0f <alltraps>

000008000010774b <vector106>:
.globl vector106
vector106:
  pushq $0
 8000010774b:	6a 00                	push   $0x0
  pushq $106
 8000010774d:	6a 6a                	push   $0x6a
  jmp alltraps
 8000010774f:	e9 bb f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107754 <vector107>:
.globl vector107
vector107:
  pushq $0
 80000107754:	6a 00                	push   $0x0
  pushq $107
 80000107756:	6a 6b                	push   $0x6b
  jmp alltraps
 80000107758:	e9 b2 f5 ff ff       	jmp    80000106d0f <alltraps>

000008000010775d <vector108>:
.globl vector108
vector108:
  pushq $0
 8000010775d:	6a 00                	push   $0x0
  pushq $108
 8000010775f:	6a 6c                	push   $0x6c
  jmp alltraps
 80000107761:	e9 a9 f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107766 <vector109>:
.globl vector109
vector109:
  pushq $0
 80000107766:	6a 00                	push   $0x0
  pushq $109
 80000107768:	6a 6d                	push   $0x6d
  jmp alltraps
 8000010776a:	e9 a0 f5 ff ff       	jmp    80000106d0f <alltraps>

000008000010776f <vector110>:
.globl vector110
vector110:
  pushq $0
 8000010776f:	6a 00                	push   $0x0
  pushq $110
 80000107771:	6a 6e                	push   $0x6e
  jmp alltraps
 80000107773:	e9 97 f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107778 <vector111>:
.globl vector111
vector111:
  pushq $0
 80000107778:	6a 00                	push   $0x0
  pushq $111
 8000010777a:	6a 6f                	push   $0x6f
  jmp alltraps
 8000010777c:	e9 8e f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107781 <vector112>:
.globl vector112
vector112:
  pushq $0
 80000107781:	6a 00                	push   $0x0
  pushq $112
 80000107783:	6a 70                	push   $0x70
  jmp alltraps
 80000107785:	e9 85 f5 ff ff       	jmp    80000106d0f <alltraps>

000008000010778a <vector113>:
.globl vector113
vector113:
  pushq $0
 8000010778a:	6a 00                	push   $0x0
  pushq $113
 8000010778c:	6a 71                	push   $0x71
  jmp alltraps
 8000010778e:	e9 7c f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107793 <vector114>:
.globl vector114
vector114:
  pushq $0
 80000107793:	6a 00                	push   $0x0
  pushq $114
 80000107795:	6a 72                	push   $0x72
  jmp alltraps
 80000107797:	e9 73 f5 ff ff       	jmp    80000106d0f <alltraps>

000008000010779c <vector115>:
.globl vector115
vector115:
  pushq $0
 8000010779c:	6a 00                	push   $0x0
  pushq $115
 8000010779e:	6a 73                	push   $0x73
  jmp alltraps
 800001077a0:	e9 6a f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077a5 <vector116>:
.globl vector116
vector116:
  pushq $0
 800001077a5:	6a 00                	push   $0x0
  pushq $116
 800001077a7:	6a 74                	push   $0x74
  jmp alltraps
 800001077a9:	e9 61 f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077ae <vector117>:
.globl vector117
vector117:
  pushq $0
 800001077ae:	6a 00                	push   $0x0
  pushq $117
 800001077b0:	6a 75                	push   $0x75
  jmp alltraps
 800001077b2:	e9 58 f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077b7 <vector118>:
.globl vector118
vector118:
  pushq $0
 800001077b7:	6a 00                	push   $0x0
  pushq $118
 800001077b9:	6a 76                	push   $0x76
  jmp alltraps
 800001077bb:	e9 4f f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077c0 <vector119>:
.globl vector119
vector119:
  pushq $0
 800001077c0:	6a 00                	push   $0x0
  pushq $119
 800001077c2:	6a 77                	push   $0x77
  jmp alltraps
 800001077c4:	e9 46 f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077c9 <vector120>:
.globl vector120
vector120:
  pushq $0
 800001077c9:	6a 00                	push   $0x0
  pushq $120
 800001077cb:	6a 78                	push   $0x78
  jmp alltraps
 800001077cd:	e9 3d f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077d2 <vector121>:
.globl vector121
vector121:
  pushq $0
 800001077d2:	6a 00                	push   $0x0
  pushq $121
 800001077d4:	6a 79                	push   $0x79
  jmp alltraps
 800001077d6:	e9 34 f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077db <vector122>:
.globl vector122
vector122:
  pushq $0
 800001077db:	6a 00                	push   $0x0
  pushq $122
 800001077dd:	6a 7a                	push   $0x7a
  jmp alltraps
 800001077df:	e9 2b f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077e4 <vector123>:
.globl vector123
vector123:
  pushq $0
 800001077e4:	6a 00                	push   $0x0
  pushq $123
 800001077e6:	6a 7b                	push   $0x7b
  jmp alltraps
 800001077e8:	e9 22 f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077ed <vector124>:
.globl vector124
vector124:
  pushq $0
 800001077ed:	6a 00                	push   $0x0
  pushq $124
 800001077ef:	6a 7c                	push   $0x7c
  jmp alltraps
 800001077f1:	e9 19 f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077f6 <vector125>:
.globl vector125
vector125:
  pushq $0
 800001077f6:	6a 00                	push   $0x0
  pushq $125
 800001077f8:	6a 7d                	push   $0x7d
  jmp alltraps
 800001077fa:	e9 10 f5 ff ff       	jmp    80000106d0f <alltraps>

00000800001077ff <vector126>:
.globl vector126
vector126:
  pushq $0
 800001077ff:	6a 00                	push   $0x0
  pushq $126
 80000107801:	6a 7e                	push   $0x7e
  jmp alltraps
 80000107803:	e9 07 f5 ff ff       	jmp    80000106d0f <alltraps>

0000080000107808 <vector127>:
.globl vector127
vector127:
  pushq $0
 80000107808:	6a 00                	push   $0x0
  pushq $127
 8000010780a:	6a 7f                	push   $0x7f
  jmp alltraps
 8000010780c:	e9 fe f4 ff ff       	jmp    80000106d0f <alltraps>

0000080000107811 <vector128>:
.globl vector128
vector128:
  pushq $0
 80000107811:	6a 00                	push   $0x0
  pushq $128
 80000107813:	68 80 00 00 00       	push   $0x80
  jmp alltraps
 80000107818:	e9 f2 f4 ff ff       	jmp    80000106d0f <alltraps>

000008000010781d <vector129>:
.globl vector129
vector129:
  pushq $0
 8000010781d:	6a 00                	push   $0x0
  pushq $129
 8000010781f:	68 81 00 00 00       	push   $0x81
  jmp alltraps
 80000107824:	e9 e6 f4 ff ff       	jmp    80000106d0f <alltraps>

0000080000107829 <vector130>:
.globl vector130
vector130:
  pushq $0
 80000107829:	6a 00                	push   $0x0
  pushq $130
 8000010782b:	68 82 00 00 00       	push   $0x82
  jmp alltraps
 80000107830:	e9 da f4 ff ff       	jmp    80000106d0f <alltraps>

0000080000107835 <vector131>:
.globl vector131
vector131:
  pushq $0
 80000107835:	6a 00                	push   $0x0
  pushq $131
 80000107837:	68 83 00 00 00       	push   $0x83
  jmp alltraps
 8000010783c:	e9 ce f4 ff ff       	jmp    80000106d0f <alltraps>

0000080000107841 <vector132>:
.globl vector132
vector132:
  pushq $0
 80000107841:	6a 00                	push   $0x0
  pushq $132
 80000107843:	68 84 00 00 00       	push   $0x84
  jmp alltraps
 80000107848:	e9 c2 f4 ff ff       	jmp    80000106d0f <alltraps>

000008000010784d <vector133>:
.globl vector133
vector133:
  pushq $0
 8000010784d:	6a 00                	push   $0x0
  pushq $133
 8000010784f:	68 85 00 00 00       	push   $0x85
  jmp alltraps
 80000107854:	e9 b6 f4 ff ff       	jmp    80000106d0f <alltraps>

0000080000107859 <vector134>:
.globl vector134
vector134:
  pushq $0
 80000107859:	6a 00                	push   $0x0
  pushq $134
 8000010785b:	68 86 00 00 00       	push   $0x86
  jmp alltraps
 80000107860:	e9 aa f4 ff ff       	jmp    80000106d0f <alltraps>

0000080000107865 <vector135>:
.globl vector135
vector135:
  pushq $0
 80000107865:	6a 00                	push   $0x0
  pushq $135
 80000107867:	68 87 00 00 00       	push   $0x87
  jmp alltraps
 8000010786c:	e9 9e f4 ff ff       	jmp    80000106d0f <alltraps>

0000080000107871 <vector136>:
.globl vector136
vector136:
  pushq $0
 80000107871:	6a 00                	push   $0x0
  pushq $136
 80000107873:	68 88 00 00 00       	push   $0x88
  jmp alltraps
 80000107878:	e9 92 f4 ff ff       	jmp    80000106d0f <alltraps>

000008000010787d <vector137>:
.globl vector137
vector137:
  pushq $0
 8000010787d:	6a 00                	push   $0x0
  pushq $137
 8000010787f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
 80000107884:	e9 86 f4 ff ff       	jmp    80000106d0f <alltraps>

0000080000107889 <vector138>:
.globl vector138
vector138:
  pushq $0
 80000107889:	6a 00                	push   $0x0
  pushq $138
 8000010788b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
 80000107890:	e9 7a f4 ff ff       	jmp    80000106d0f <alltraps>

0000080000107895 <vector139>:
.globl vector139
vector139:
  pushq $0
 80000107895:	6a 00                	push   $0x0
  pushq $139
 80000107897:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
 8000010789c:	e9 6e f4 ff ff       	jmp    80000106d0f <alltraps>

00000800001078a1 <vector140>:
.globl vector140
vector140:
  pushq $0
 800001078a1:	6a 00                	push   $0x0
  pushq $140
 800001078a3:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
 800001078a8:	e9 62 f4 ff ff       	jmp    80000106d0f <alltraps>

00000800001078ad <vector141>:
.globl vector141
vector141:
  pushq $0
 800001078ad:	6a 00                	push   $0x0
  pushq $141
 800001078af:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
 800001078b4:	e9 56 f4 ff ff       	jmp    80000106d0f <alltraps>

00000800001078b9 <vector142>:
.globl vector142
vector142:
  pushq $0
 800001078b9:	6a 00                	push   $0x0
  pushq $142
 800001078bb:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
 800001078c0:	e9 4a f4 ff ff       	jmp    80000106d0f <alltraps>

00000800001078c5 <vector143>:
.globl vector143
vector143:
  pushq $0
 800001078c5:	6a 00                	push   $0x0
  pushq $143
 800001078c7:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
 800001078cc:	e9 3e f4 ff ff       	jmp    80000106d0f <alltraps>

00000800001078d1 <vector144>:
.globl vector144
vector144:
  pushq $0
 800001078d1:	6a 00                	push   $0x0
  pushq $144
 800001078d3:	68 90 00 00 00       	push   $0x90
  jmp alltraps
 800001078d8:	e9 32 f4 ff ff       	jmp    80000106d0f <alltraps>

00000800001078dd <vector145>:
.globl vector145
vector145:
  pushq $0
 800001078dd:	6a 00                	push   $0x0
  pushq $145
 800001078df:	68 91 00 00 00       	push   $0x91
  jmp alltraps
 800001078e4:	e9 26 f4 ff ff       	jmp    80000106d0f <alltraps>

00000800001078e9 <vector146>:
.globl vector146
vector146:
  pushq $0
 800001078e9:	6a 00                	push   $0x0
  pushq $146
 800001078eb:	68 92 00 00 00       	push   $0x92
  jmp alltraps
 800001078f0:	e9 1a f4 ff ff       	jmp    80000106d0f <alltraps>

00000800001078f5 <vector147>:
.globl vector147
vector147:
  pushq $0
 800001078f5:	6a 00                	push   $0x0
  pushq $147
 800001078f7:	68 93 00 00 00       	push   $0x93
  jmp alltraps
 800001078fc:	e9 0e f4 ff ff       	jmp    80000106d0f <alltraps>

0000080000107901 <vector148>:
.globl vector148
vector148:
  pushq $0
 80000107901:	6a 00                	push   $0x0
  pushq $148
 80000107903:	68 94 00 00 00       	push   $0x94
  jmp alltraps
 80000107908:	e9 02 f4 ff ff       	jmp    80000106d0f <alltraps>

000008000010790d <vector149>:
.globl vector149
vector149:
  pushq $0
 8000010790d:	6a 00                	push   $0x0
  pushq $149
 8000010790f:	68 95 00 00 00       	push   $0x95
  jmp alltraps
 80000107914:	e9 f6 f3 ff ff       	jmp    80000106d0f <alltraps>

0000080000107919 <vector150>:
.globl vector150
vector150:
  pushq $0
 80000107919:	6a 00                	push   $0x0
  pushq $150
 8000010791b:	68 96 00 00 00       	push   $0x96
  jmp alltraps
 80000107920:	e9 ea f3 ff ff       	jmp    80000106d0f <alltraps>

0000080000107925 <vector151>:
.globl vector151
vector151:
  pushq $0
 80000107925:	6a 00                	push   $0x0
  pushq $151
 80000107927:	68 97 00 00 00       	push   $0x97
  jmp alltraps
 8000010792c:	e9 de f3 ff ff       	jmp    80000106d0f <alltraps>

0000080000107931 <vector152>:
.globl vector152
vector152:
  pushq $0
 80000107931:	6a 00                	push   $0x0
  pushq $152
 80000107933:	68 98 00 00 00       	push   $0x98
  jmp alltraps
 80000107938:	e9 d2 f3 ff ff       	jmp    80000106d0f <alltraps>

000008000010793d <vector153>:
.globl vector153
vector153:
  pushq $0
 8000010793d:	6a 00                	push   $0x0
  pushq $153
 8000010793f:	68 99 00 00 00       	push   $0x99
  jmp alltraps
 80000107944:	e9 c6 f3 ff ff       	jmp    80000106d0f <alltraps>

0000080000107949 <vector154>:
.globl vector154
vector154:
  pushq $0
 80000107949:	6a 00                	push   $0x0
  pushq $154
 8000010794b:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
 80000107950:	e9 ba f3 ff ff       	jmp    80000106d0f <alltraps>

0000080000107955 <vector155>:
.globl vector155
vector155:
  pushq $0
 80000107955:	6a 00                	push   $0x0
  pushq $155
 80000107957:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
 8000010795c:	e9 ae f3 ff ff       	jmp    80000106d0f <alltraps>

0000080000107961 <vector156>:
.globl vector156
vector156:
  pushq $0
 80000107961:	6a 00                	push   $0x0
  pushq $156
 80000107963:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
 80000107968:	e9 a2 f3 ff ff       	jmp    80000106d0f <alltraps>

000008000010796d <vector157>:
.globl vector157
vector157:
  pushq $0
 8000010796d:	6a 00                	push   $0x0
  pushq $157
 8000010796f:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
 80000107974:	e9 96 f3 ff ff       	jmp    80000106d0f <alltraps>

0000080000107979 <vector158>:
.globl vector158
vector158:
  pushq $0
 80000107979:	6a 00                	push   $0x0
  pushq $158
 8000010797b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
 80000107980:	e9 8a f3 ff ff       	jmp    80000106d0f <alltraps>

0000080000107985 <vector159>:
.globl vector159
vector159:
  pushq $0
 80000107985:	6a 00                	push   $0x0
  pushq $159
 80000107987:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
 8000010798c:	e9 7e f3 ff ff       	jmp    80000106d0f <alltraps>

0000080000107991 <vector160>:
.globl vector160
vector160:
  pushq $0
 80000107991:	6a 00                	push   $0x0
  pushq $160
 80000107993:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
 80000107998:	e9 72 f3 ff ff       	jmp    80000106d0f <alltraps>

000008000010799d <vector161>:
.globl vector161
vector161:
  pushq $0
 8000010799d:	6a 00                	push   $0x0
  pushq $161
 8000010799f:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
 800001079a4:	e9 66 f3 ff ff       	jmp    80000106d0f <alltraps>

00000800001079a9 <vector162>:
.globl vector162
vector162:
  pushq $0
 800001079a9:	6a 00                	push   $0x0
  pushq $162
 800001079ab:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
 800001079b0:	e9 5a f3 ff ff       	jmp    80000106d0f <alltraps>

00000800001079b5 <vector163>:
.globl vector163
vector163:
  pushq $0
 800001079b5:	6a 00                	push   $0x0
  pushq $163
 800001079b7:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
 800001079bc:	e9 4e f3 ff ff       	jmp    80000106d0f <alltraps>

00000800001079c1 <vector164>:
.globl vector164
vector164:
  pushq $0
 800001079c1:	6a 00                	push   $0x0
  pushq $164
 800001079c3:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
 800001079c8:	e9 42 f3 ff ff       	jmp    80000106d0f <alltraps>

00000800001079cd <vector165>:
.globl vector165
vector165:
  pushq $0
 800001079cd:	6a 00                	push   $0x0
  pushq $165
 800001079cf:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
 800001079d4:	e9 36 f3 ff ff       	jmp    80000106d0f <alltraps>

00000800001079d9 <vector166>:
.globl vector166
vector166:
  pushq $0
 800001079d9:	6a 00                	push   $0x0
  pushq $166
 800001079db:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
 800001079e0:	e9 2a f3 ff ff       	jmp    80000106d0f <alltraps>

00000800001079e5 <vector167>:
.globl vector167
vector167:
  pushq $0
 800001079e5:	6a 00                	push   $0x0
  pushq $167
 800001079e7:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
 800001079ec:	e9 1e f3 ff ff       	jmp    80000106d0f <alltraps>

00000800001079f1 <vector168>:
.globl vector168
vector168:
  pushq $0
 800001079f1:	6a 00                	push   $0x0
  pushq $168
 800001079f3:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
 800001079f8:	e9 12 f3 ff ff       	jmp    80000106d0f <alltraps>

00000800001079fd <vector169>:
.globl vector169
vector169:
  pushq $0
 800001079fd:	6a 00                	push   $0x0
  pushq $169
 800001079ff:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
 80000107a04:	e9 06 f3 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a09 <vector170>:
.globl vector170
vector170:
  pushq $0
 80000107a09:	6a 00                	push   $0x0
  pushq $170
 80000107a0b:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
 80000107a10:	e9 fa f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a15 <vector171>:
.globl vector171
vector171:
  pushq $0
 80000107a15:	6a 00                	push   $0x0
  pushq $171
 80000107a17:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
 80000107a1c:	e9 ee f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a21 <vector172>:
.globl vector172
vector172:
  pushq $0
 80000107a21:	6a 00                	push   $0x0
  pushq $172
 80000107a23:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
 80000107a28:	e9 e2 f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a2d <vector173>:
.globl vector173
vector173:
  pushq $0
 80000107a2d:	6a 00                	push   $0x0
  pushq $173
 80000107a2f:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
 80000107a34:	e9 d6 f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a39 <vector174>:
.globl vector174
vector174:
  pushq $0
 80000107a39:	6a 00                	push   $0x0
  pushq $174
 80000107a3b:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
 80000107a40:	e9 ca f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a45 <vector175>:
.globl vector175
vector175:
  pushq $0
 80000107a45:	6a 00                	push   $0x0
  pushq $175
 80000107a47:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
 80000107a4c:	e9 be f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a51 <vector176>:
.globl vector176
vector176:
  pushq $0
 80000107a51:	6a 00                	push   $0x0
  pushq $176
 80000107a53:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
 80000107a58:	e9 b2 f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a5d <vector177>:
.globl vector177
vector177:
  pushq $0
 80000107a5d:	6a 00                	push   $0x0
  pushq $177
 80000107a5f:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
 80000107a64:	e9 a6 f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a69 <vector178>:
.globl vector178
vector178:
  pushq $0
 80000107a69:	6a 00                	push   $0x0
  pushq $178
 80000107a6b:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
 80000107a70:	e9 9a f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a75 <vector179>:
.globl vector179
vector179:
  pushq $0
 80000107a75:	6a 00                	push   $0x0
  pushq $179
 80000107a77:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
 80000107a7c:	e9 8e f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a81 <vector180>:
.globl vector180
vector180:
  pushq $0
 80000107a81:	6a 00                	push   $0x0
  pushq $180
 80000107a83:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
 80000107a88:	e9 82 f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a8d <vector181>:
.globl vector181
vector181:
  pushq $0
 80000107a8d:	6a 00                	push   $0x0
  pushq $181
 80000107a8f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
 80000107a94:	e9 76 f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107a99 <vector182>:
.globl vector182
vector182:
  pushq $0
 80000107a99:	6a 00                	push   $0x0
  pushq $182
 80000107a9b:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
 80000107aa0:	e9 6a f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107aa5 <vector183>:
.globl vector183
vector183:
  pushq $0
 80000107aa5:	6a 00                	push   $0x0
  pushq $183
 80000107aa7:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
 80000107aac:	e9 5e f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107ab1 <vector184>:
.globl vector184
vector184:
  pushq $0
 80000107ab1:	6a 00                	push   $0x0
  pushq $184
 80000107ab3:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
 80000107ab8:	e9 52 f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107abd <vector185>:
.globl vector185
vector185:
  pushq $0
 80000107abd:	6a 00                	push   $0x0
  pushq $185
 80000107abf:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
 80000107ac4:	e9 46 f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107ac9 <vector186>:
.globl vector186
vector186:
  pushq $0
 80000107ac9:	6a 00                	push   $0x0
  pushq $186
 80000107acb:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
 80000107ad0:	e9 3a f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107ad5 <vector187>:
.globl vector187
vector187:
  pushq $0
 80000107ad5:	6a 00                	push   $0x0
  pushq $187
 80000107ad7:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
 80000107adc:	e9 2e f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107ae1 <vector188>:
.globl vector188
vector188:
  pushq $0
 80000107ae1:	6a 00                	push   $0x0
  pushq $188
 80000107ae3:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
 80000107ae8:	e9 22 f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107aed <vector189>:
.globl vector189
vector189:
  pushq $0
 80000107aed:	6a 00                	push   $0x0
  pushq $189
 80000107aef:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
 80000107af4:	e9 16 f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107af9 <vector190>:
.globl vector190
vector190:
  pushq $0
 80000107af9:	6a 00                	push   $0x0
  pushq $190
 80000107afb:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
 80000107b00:	e9 0a f2 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b05 <vector191>:
.globl vector191
vector191:
  pushq $0
 80000107b05:	6a 00                	push   $0x0
  pushq $191
 80000107b07:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
 80000107b0c:	e9 fe f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b11 <vector192>:
.globl vector192
vector192:
  pushq $0
 80000107b11:	6a 00                	push   $0x0
  pushq $192
 80000107b13:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
 80000107b18:	e9 f2 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b1d <vector193>:
.globl vector193
vector193:
  pushq $0
 80000107b1d:	6a 00                	push   $0x0
  pushq $193
 80000107b1f:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
 80000107b24:	e9 e6 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b29 <vector194>:
.globl vector194
vector194:
  pushq $0
 80000107b29:	6a 00                	push   $0x0
  pushq $194
 80000107b2b:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
 80000107b30:	e9 da f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b35 <vector195>:
.globl vector195
vector195:
  pushq $0
 80000107b35:	6a 00                	push   $0x0
  pushq $195
 80000107b37:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
 80000107b3c:	e9 ce f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b41 <vector196>:
.globl vector196
vector196:
  pushq $0
 80000107b41:	6a 00                	push   $0x0
  pushq $196
 80000107b43:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
 80000107b48:	e9 c2 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b4d <vector197>:
.globl vector197
vector197:
  pushq $0
 80000107b4d:	6a 00                	push   $0x0
  pushq $197
 80000107b4f:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
 80000107b54:	e9 b6 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b59 <vector198>:
.globl vector198
vector198:
  pushq $0
 80000107b59:	6a 00                	push   $0x0
  pushq $198
 80000107b5b:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
 80000107b60:	e9 aa f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b65 <vector199>:
.globl vector199
vector199:
  pushq $0
 80000107b65:	6a 00                	push   $0x0
  pushq $199
 80000107b67:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
 80000107b6c:	e9 9e f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b71 <vector200>:
.globl vector200
vector200:
  pushq $0
 80000107b71:	6a 00                	push   $0x0
  pushq $200
 80000107b73:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
 80000107b78:	e9 92 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b7d <vector201>:
.globl vector201
vector201:
  pushq $0
 80000107b7d:	6a 00                	push   $0x0
  pushq $201
 80000107b7f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
 80000107b84:	e9 86 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b89 <vector202>:
.globl vector202
vector202:
  pushq $0
 80000107b89:	6a 00                	push   $0x0
  pushq $202
 80000107b8b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
 80000107b90:	e9 7a f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107b95 <vector203>:
.globl vector203
vector203:
  pushq $0
 80000107b95:	6a 00                	push   $0x0
  pushq $203
 80000107b97:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
 80000107b9c:	e9 6e f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107ba1 <vector204>:
.globl vector204
vector204:
  pushq $0
 80000107ba1:	6a 00                	push   $0x0
  pushq $204
 80000107ba3:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
 80000107ba8:	e9 62 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107bad <vector205>:
.globl vector205
vector205:
  pushq $0
 80000107bad:	6a 00                	push   $0x0
  pushq $205
 80000107baf:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
 80000107bb4:	e9 56 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107bb9 <vector206>:
.globl vector206
vector206:
  pushq $0
 80000107bb9:	6a 00                	push   $0x0
  pushq $206
 80000107bbb:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
 80000107bc0:	e9 4a f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107bc5 <vector207>:
.globl vector207
vector207:
  pushq $0
 80000107bc5:	6a 00                	push   $0x0
  pushq $207
 80000107bc7:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
 80000107bcc:	e9 3e f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107bd1 <vector208>:
.globl vector208
vector208:
  pushq $0
 80000107bd1:	6a 00                	push   $0x0
  pushq $208
 80000107bd3:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
 80000107bd8:	e9 32 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107bdd <vector209>:
.globl vector209
vector209:
  pushq $0
 80000107bdd:	6a 00                	push   $0x0
  pushq $209
 80000107bdf:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
 80000107be4:	e9 26 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107be9 <vector210>:
.globl vector210
vector210:
  pushq $0
 80000107be9:	6a 00                	push   $0x0
  pushq $210
 80000107beb:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
 80000107bf0:	e9 1a f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107bf5 <vector211>:
.globl vector211
vector211:
  pushq $0
 80000107bf5:	6a 00                	push   $0x0
  pushq $211
 80000107bf7:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
 80000107bfc:	e9 0e f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c01 <vector212>:
.globl vector212
vector212:
  pushq $0
 80000107c01:	6a 00                	push   $0x0
  pushq $212
 80000107c03:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
 80000107c08:	e9 02 f1 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c0d <vector213>:
.globl vector213
vector213:
  pushq $0
 80000107c0d:	6a 00                	push   $0x0
  pushq $213
 80000107c0f:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
 80000107c14:	e9 f6 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c19 <vector214>:
.globl vector214
vector214:
  pushq $0
 80000107c19:	6a 00                	push   $0x0
  pushq $214
 80000107c1b:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
 80000107c20:	e9 ea f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c25 <vector215>:
.globl vector215
vector215:
  pushq $0
 80000107c25:	6a 00                	push   $0x0
  pushq $215
 80000107c27:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
 80000107c2c:	e9 de f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c31 <vector216>:
.globl vector216
vector216:
  pushq $0
 80000107c31:	6a 00                	push   $0x0
  pushq $216
 80000107c33:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
 80000107c38:	e9 d2 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c3d <vector217>:
.globl vector217
vector217:
  pushq $0
 80000107c3d:	6a 00                	push   $0x0
  pushq $217
 80000107c3f:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
 80000107c44:	e9 c6 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c49 <vector218>:
.globl vector218
vector218:
  pushq $0
 80000107c49:	6a 00                	push   $0x0
  pushq $218
 80000107c4b:	68 da 00 00 00       	push   $0xda
  jmp alltraps
 80000107c50:	e9 ba f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c55 <vector219>:
.globl vector219
vector219:
  pushq $0
 80000107c55:	6a 00                	push   $0x0
  pushq $219
 80000107c57:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
 80000107c5c:	e9 ae f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c61 <vector220>:
.globl vector220
vector220:
  pushq $0
 80000107c61:	6a 00                	push   $0x0
  pushq $220
 80000107c63:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
 80000107c68:	e9 a2 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c6d <vector221>:
.globl vector221
vector221:
  pushq $0
 80000107c6d:	6a 00                	push   $0x0
  pushq $221
 80000107c6f:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
 80000107c74:	e9 96 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c79 <vector222>:
.globl vector222
vector222:
  pushq $0
 80000107c79:	6a 00                	push   $0x0
  pushq $222
 80000107c7b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
 80000107c80:	e9 8a f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c85 <vector223>:
.globl vector223
vector223:
  pushq $0
 80000107c85:	6a 00                	push   $0x0
  pushq $223
 80000107c87:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
 80000107c8c:	e9 7e f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c91 <vector224>:
.globl vector224
vector224:
  pushq $0
 80000107c91:	6a 00                	push   $0x0
  pushq $224
 80000107c93:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
 80000107c98:	e9 72 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107c9d <vector225>:
.globl vector225
vector225:
  pushq $0
 80000107c9d:	6a 00                	push   $0x0
  pushq $225
 80000107c9f:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
 80000107ca4:	e9 66 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107ca9 <vector226>:
.globl vector226
vector226:
  pushq $0
 80000107ca9:	6a 00                	push   $0x0
  pushq $226
 80000107cab:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
 80000107cb0:	e9 5a f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107cb5 <vector227>:
.globl vector227
vector227:
  pushq $0
 80000107cb5:	6a 00                	push   $0x0
  pushq $227
 80000107cb7:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
 80000107cbc:	e9 4e f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107cc1 <vector228>:
.globl vector228
vector228:
  pushq $0
 80000107cc1:	6a 00                	push   $0x0
  pushq $228
 80000107cc3:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
 80000107cc8:	e9 42 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107ccd <vector229>:
.globl vector229
vector229:
  pushq $0
 80000107ccd:	6a 00                	push   $0x0
  pushq $229
 80000107ccf:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
 80000107cd4:	e9 36 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107cd9 <vector230>:
.globl vector230
vector230:
  pushq $0
 80000107cd9:	6a 00                	push   $0x0
  pushq $230
 80000107cdb:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
 80000107ce0:	e9 2a f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107ce5 <vector231>:
.globl vector231
vector231:
  pushq $0
 80000107ce5:	6a 00                	push   $0x0
  pushq $231
 80000107ce7:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
 80000107cec:	e9 1e f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107cf1 <vector232>:
.globl vector232
vector232:
  pushq $0
 80000107cf1:	6a 00                	push   $0x0
  pushq $232
 80000107cf3:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
 80000107cf8:	e9 12 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107cfd <vector233>:
.globl vector233
vector233:
  pushq $0
 80000107cfd:	6a 00                	push   $0x0
  pushq $233
 80000107cff:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
 80000107d04:	e9 06 f0 ff ff       	jmp    80000106d0f <alltraps>

0000080000107d09 <vector234>:
.globl vector234
vector234:
  pushq $0
 80000107d09:	6a 00                	push   $0x0
  pushq $234
 80000107d0b:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
 80000107d10:	e9 fa ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d15 <vector235>:
.globl vector235
vector235:
  pushq $0
 80000107d15:	6a 00                	push   $0x0
  pushq $235
 80000107d17:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
 80000107d1c:	e9 ee ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d21 <vector236>:
.globl vector236
vector236:
  pushq $0
 80000107d21:	6a 00                	push   $0x0
  pushq $236
 80000107d23:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
 80000107d28:	e9 e2 ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d2d <vector237>:
.globl vector237
vector237:
  pushq $0
 80000107d2d:	6a 00                	push   $0x0
  pushq $237
 80000107d2f:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
 80000107d34:	e9 d6 ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d39 <vector238>:
.globl vector238
vector238:
  pushq $0
 80000107d39:	6a 00                	push   $0x0
  pushq $238
 80000107d3b:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
 80000107d40:	e9 ca ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d45 <vector239>:
.globl vector239
vector239:
  pushq $0
 80000107d45:	6a 00                	push   $0x0
  pushq $239
 80000107d47:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
 80000107d4c:	e9 be ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d51 <vector240>:
.globl vector240
vector240:
  pushq $0
 80000107d51:	6a 00                	push   $0x0
  pushq $240
 80000107d53:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
 80000107d58:	e9 b2 ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d5d <vector241>:
.globl vector241
vector241:
  pushq $0
 80000107d5d:	6a 00                	push   $0x0
  pushq $241
 80000107d5f:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
 80000107d64:	e9 a6 ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d69 <vector242>:
.globl vector242
vector242:
  pushq $0
 80000107d69:	6a 00                	push   $0x0
  pushq $242
 80000107d6b:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
 80000107d70:	e9 9a ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d75 <vector243>:
.globl vector243
vector243:
  pushq $0
 80000107d75:	6a 00                	push   $0x0
  pushq $243
 80000107d77:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
 80000107d7c:	e9 8e ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d81 <vector244>:
.globl vector244
vector244:
  pushq $0
 80000107d81:	6a 00                	push   $0x0
  pushq $244
 80000107d83:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
 80000107d88:	e9 82 ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d8d <vector245>:
.globl vector245
vector245:
  pushq $0
 80000107d8d:	6a 00                	push   $0x0
  pushq $245
 80000107d8f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
 80000107d94:	e9 76 ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107d99 <vector246>:
.globl vector246
vector246:
  pushq $0
 80000107d99:	6a 00                	push   $0x0
  pushq $246
 80000107d9b:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
 80000107da0:	e9 6a ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107da5 <vector247>:
.globl vector247
vector247:
  pushq $0
 80000107da5:	6a 00                	push   $0x0
  pushq $247
 80000107da7:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
 80000107dac:	e9 5e ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107db1 <vector248>:
.globl vector248
vector248:
  pushq $0
 80000107db1:	6a 00                	push   $0x0
  pushq $248
 80000107db3:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
 80000107db8:	e9 52 ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107dbd <vector249>:
.globl vector249
vector249:
  pushq $0
 80000107dbd:	6a 00                	push   $0x0
  pushq $249
 80000107dbf:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
 80000107dc4:	e9 46 ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107dc9 <vector250>:
.globl vector250
vector250:
  pushq $0
 80000107dc9:	6a 00                	push   $0x0
  pushq $250
 80000107dcb:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
 80000107dd0:	e9 3a ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107dd5 <vector251>:
.globl vector251
vector251:
  pushq $0
 80000107dd5:	6a 00                	push   $0x0
  pushq $251
 80000107dd7:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
 80000107ddc:	e9 2e ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107de1 <vector252>:
.globl vector252
vector252:
  pushq $0
 80000107de1:	6a 00                	push   $0x0
  pushq $252
 80000107de3:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
 80000107de8:	e9 22 ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107ded <vector253>:
.globl vector253
vector253:
  pushq $0
 80000107ded:	6a 00                	push   $0x0
  pushq $253
 80000107def:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
 80000107df4:	e9 16 ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107df9 <vector254>:
.globl vector254
vector254:
  pushq $0
 80000107df9:	6a 00                	push   $0x0
  pushq $254
 80000107dfb:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
 80000107e00:	e9 0a ef ff ff       	jmp    80000106d0f <alltraps>

0000080000107e05 <vector255>:
.globl vector255
vector255:
  pushq $0
 80000107e05:	6a 00                	push   $0x0
  pushq $255
 80000107e07:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
 80000107e0c:	e9 fe ee ff ff       	jmp    80000106d0f <alltraps>
 80000107e11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 80000107e18:	00 00 00 
 80000107e1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000080000107e20 <skiptables>:
  return newsz;
}

static inline uint64
skiptables(uint64 va, int walkpml4_missing_level)
{
 80000107e20:	55                   	push   %rbp
 80000107e21:	48 89 e5             	mov    %rsp,%rbp
 80000107e24:	48 89 f8             	mov    %rdi,%rax
  switch (walkpml4_missing_level)
 80000107e27:	83 fe 03             	cmp    $0x3,%esi
 80000107e2a:	74 48                	je     80000107e74 <skiptables+0x54>
 80000107e2c:	83 fe 04             	cmp    $0x4,%esi
 80000107e2f:	74 0b                	je     80000107e3c <skiptables+0x1c>
 80000107e31:	83 fe 02             	cmp    $0x2,%esi
 80000107e34:	0f 84 8e 00 00 00    	je     80000107ec8 <skiptables+0xa8>
        return skiptables(va, walkpml4_missing_level + 1);
      va = PGADDR(PML4X(va), PDPTX(va), PDX(va) + 1, 0, 0);
      break;
  }
  return va;
}
 80000107e3a:	5d                   	pop    %rbp
 80000107e3b:	c3                   	ret
      if (PML4X(va) == 0x1FF)
 80000107e3c:	48 b9 00 00 00 00 80 	movabs $0xff8000000000,%rcx
 80000107e43:	ff 00 00 
 80000107e46:	48 89 fa             	mov    %rdi,%rdx
 80000107e49:	48 f7 d2             	not    %rdx
 80000107e4c:	48 85 ca             	test   %rcx,%rdx
 80000107e4f:	74 1b                	je     80000107e6c <skiptables+0x4c>
      va = PGADDR(PML4X(va) + 1, 0, 0, 0, 0);
 80000107e51:	48 c1 e8 27          	shr    $0x27,%rax
 80000107e55:	48 83 c0 01          	add    $0x1,%rax
 80000107e59:	48 c1 e0 27          	shl    $0x27,%rax
 80000107e5d:	48 ba 00 00 00 00 80 	movabs $0xff8000000000,%rdx
 80000107e64:	ff 00 00 
 80000107e67:	48 21 d0             	and    %rdx,%rax
      break;
 80000107e6a:	eb ce                	jmp    80000107e3a <skiptables+0x1a>
        return va + PGSIZE;
 80000107e6c:	48 05 00 10 00 00    	add    $0x1000,%rax
 80000107e72:	eb c6                	jmp    80000107e3a <skiptables+0x1a>
      if (PDPTX(va) == 0x1FF)
 80000107e74:	48 b9 00 00 00 c0 7f 	movabs $0x7fc0000000,%rcx
 80000107e7b:	00 00 00 
 80000107e7e:	48 89 fa             	mov    %rdi,%rdx
 80000107e81:	48 f7 d2             	not    %rdx
 80000107e84:	48 85 ca             	test   %rcx,%rdx
 80000107e87:	74 2b                	je     80000107eb4 <skiptables+0x94>
      va = PGADDR(PML4X(va), PDPTX(va) + 1, 0, 0, 0);
 80000107e89:	48 ba 00 00 00 00 80 	movabs $0xff8000000000,%rdx
 80000107e90:	ff 00 00 
 80000107e93:	48 21 fa             	and    %rdi,%rdx
 80000107e96:	48 c1 e8 1e          	shr    $0x1e,%rax
 80000107e9a:	48 83 c0 01          	add    $0x1,%rax
 80000107e9e:	48 c1 e0 1e          	shl    $0x1e,%rax
 80000107ea2:	48 b9 00 00 00 c0 7f 	movabs $0x7fc0000000,%rcx
 80000107ea9:	00 00 00 
 80000107eac:	48 21 c8             	and    %rcx,%rax
 80000107eaf:	48 09 d0             	or     %rdx,%rax
      break;
 80000107eb2:	eb 86                	jmp    80000107e3a <skiptables+0x1a>
        return skiptables(va, walkpml4_missing_level + 1);
 80000107eb4:	83 c6 01             	add    $0x1,%esi
 80000107eb7:	48 b8 20 7e 10 00 00 	movabs $0x80000107e20,%rax
 80000107ebe:	08 00 00 
 80000107ec1:	ff d0                	call   *%rax
 80000107ec3:	e9 72 ff ff ff       	jmp    80000107e3a <skiptables+0x1a>
      if (PDX(va) == 0x1FF)
 80000107ec8:	48 89 fa             	mov    %rdi,%rdx
 80000107ecb:	48 f7 d2             	not    %rdx
 80000107ece:	f7 c2 00 00 e0 3f    	test   $0x3fe00000,%edx
 80000107ed4:	74 26                	je     80000107efc <skiptables+0xdc>
      va = PGADDR(PML4X(va), PDPTX(va), PDX(va) + 1, 0, 0);
 80000107ed6:	48 ba 00 00 00 c0 ff 	movabs $0xffffc0000000,%rdx
 80000107edd:	ff 00 00 
 80000107ee0:	48 21 fa             	and    %rdi,%rdx
 80000107ee3:	48 c1 e8 15          	shr    $0x15,%rax
 80000107ee7:	48 83 c0 01          	add    $0x1,%rax
 80000107eeb:	48 c1 e0 15          	shl    $0x15,%rax
 80000107eef:	25 00 00 e0 3f       	and    $0x3fe00000,%eax
 80000107ef4:	48 09 d0             	or     %rdx,%rax
      break;
 80000107ef7:	e9 3e ff ff ff       	jmp    80000107e3a <skiptables+0x1a>
        return skiptables(va, walkpml4_missing_level + 1);
 80000107efc:	83 c6 01             	add    $0x1,%esi
 80000107eff:	48 b8 20 7e 10 00 00 	movabs $0x80000107e20,%rax
 80000107f06:	08 00 00 
 80000107f09:	ff d0                	call   *%rax
 80000107f0b:	e9 2a ff ff ff       	jmp    80000107e3a <skiptables+0x1a>

0000080000107f10 <walkpglevel>:
{
 80000107f10:	55                   	push   %rbp
 80000107f11:	48 89 e5             	mov    %rsp,%rbp
 80000107f14:	41 57                	push   %r15
 80000107f16:	41 56                	push   %r14
 80000107f18:	41 55                	push   %r13
 80000107f1a:	41 54                	push   %r12
 80000107f1c:	53                   	push   %rbx
 80000107f1d:	48 83 ec 18          	sub    $0x18,%rsp
 80000107f21:	49 89 f4             	mov    %rsi,%r12
 80000107f24:	41 89 d6             	mov    %edx,%r14d
 80000107f27:	89 cb                	mov    %ecx,%ebx
 80000107f29:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
  switch (level){
 80000107f2d:	83 f9 03             	cmp    $0x3,%ecx
 80000107f30:	0f 84 83 00 00 00    	je     80000107fb9 <walkpglevel+0xa9>
 80000107f36:	7f 24                	jg     80000107f5c <walkpglevel+0x4c>
 80000107f38:	83 f9 01             	cmp    $0x1,%ecx
 80000107f3b:	0f 84 8a 00 00 00    	je     80000107fcb <walkpglevel+0xbb>
 80000107f41:	83 f9 02             	cmp    $0x2,%ecx
 80000107f44:	0f 85 92 00 00 00    	jne    80000107fdc <walkpglevel+0xcc>
      entry = &pgdir[PDX(va)];
 80000107f4a:	48 89 f0             	mov    %rsi,%rax
 80000107f4d:	48 c1 e8 15          	shr    $0x15,%rax
 80000107f51:	25 ff 01 00 00       	and    $0x1ff,%eax
 80000107f56:	4c 8d 3c c7          	lea    (%rdi,%rax,8),%r15
      break;
 80000107f5a:	eb 15                	jmp    80000107f71 <walkpglevel+0x61>
  switch (level){
 80000107f5c:	83 f9 04             	cmp    $0x4,%ecx
 80000107f5f:	75 7b                	jne    80000107fdc <walkpglevel+0xcc>
      entry = &pgdir[PML4X(va)];
 80000107f61:	48 89 f0             	mov    %rsi,%rax
 80000107f64:	48 c1 e8 27          	shr    $0x27,%rax
 80000107f68:	25 ff 01 00 00       	and    $0x1ff,%eax
 80000107f6d:	4c 8d 3c c7          	lea    (%rdi,%rax,8),%r15
  if(*entry & PTE_P){
 80000107f71:	4d 8b 2f             	mov    (%r15),%r13
 80000107f74:	41 f6 c5 01          	test   $0x1,%r13b
 80000107f78:	74 78                	je     80000107ff2 <walkpglevel+0xe2>
    next_pgdir = (uint64*)P2V(PTE_ADDR(*entry));
 80000107f7a:	49 81 e5 00 f0 ff ff 	and    $0xfffffffffffff000,%r13
 80000107f81:	48 b8 00 00 00 00 00 	movabs $0x80000000000,%rax
 80000107f88:	08 00 00 
 80000107f8b:	49 01 c5             	add    %rax,%r13
  return walkpglevel(next_pgdir, va, alloc, level - 1, missing);
 80000107f8e:	8d 4b ff             	lea    -0x1(%rbx),%ecx
 80000107f91:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
 80000107f95:	44 89 f2             	mov    %r14d,%edx
 80000107f98:	4c 89 e6             	mov    %r12,%rsi
 80000107f9b:	4c 89 ef             	mov    %r13,%rdi
 80000107f9e:	48 b8 10 7f 10 00 00 	movabs $0x80000107f10,%rax
 80000107fa5:	08 00 00 
 80000107fa8:	ff d0                	call   *%rax
}
 80000107faa:	48 83 c4 18          	add    $0x18,%rsp
 80000107fae:	5b                   	pop    %rbx
 80000107faf:	41 5c                	pop    %r12
 80000107fb1:	41 5d                	pop    %r13
 80000107fb3:	41 5e                	pop    %r14
 80000107fb5:	41 5f                	pop    %r15
 80000107fb7:	5d                   	pop    %rbp
 80000107fb8:	c3                   	ret
      entry = &pgdir[PDPTX(va)];
 80000107fb9:	48 89 f0             	mov    %rsi,%rax
 80000107fbc:	48 c1 e8 1e          	shr    $0x1e,%rax
 80000107fc0:	25 ff 01 00 00       	and    $0x1ff,%eax
 80000107fc5:	4c 8d 3c c7          	lea    (%rdi,%rax,8),%r15
      break;
 80000107fc9:	eb a6                	jmp    80000107f71 <walkpglevel+0x61>
      return &pgdir[PTX(va)];
 80000107fcb:	49 c1 ec 0c          	shr    $0xc,%r12
 80000107fcf:	41 81 e4 ff 01 00 00 	and    $0x1ff,%r12d
 80000107fd6:	4a 8d 04 e7          	lea    (%rdi,%r12,8),%rax
 80000107fda:	eb ce                	jmp    80000107faa <walkpglevel+0x9a>
      panic("walkpglevel");
 80000107fdc:	48 bf a0 ad 10 00 00 	movabs $0x8000010ada0,%rdi
 80000107fe3:	08 00 00 
 80000107fe6:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000107fed:	08 00 00 
 80000107ff0:	ff d0                	call   *%rax
    if(!alloc || (next_pgdir = (uint64*)kalloc()) == 0){
 80000107ff2:	45 85 f6             	test   %r14d,%r14d
 80000107ff5:	74 46                	je     8000010803d <walkpglevel+0x12d>
 80000107ff7:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000107ffe:	08 00 00 
 80000108001:	ff d0                	call   *%rax
 80000108003:	49 89 c5             	mov    %rax,%r13
 80000108006:	48 85 c0             	test   %rax,%rax
 80000108009:	74 32                	je     8000010803d <walkpglevel+0x12d>
    memset(next_pgdir, 0, PGSIZE);
 8000010800b:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000108010:	be 00 00 00 00       	mov    $0x0,%esi
 80000108015:	48 89 c7             	mov    %rax,%rdi
 80000108018:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 8000010801f:	08 00 00 
 80000108022:	ff d0                	call   *%rax
    *entry = V2P(next_pgdir) | PTE_P | PTE_W | PTE_U;
 80000108024:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 8000010802b:	f8 ff ff 
 8000010802e:	4c 01 e8             	add    %r13,%rax
 80000108031:	48 83 c8 07          	or     $0x7,%rax
 80000108035:	49 89 07             	mov    %rax,(%r15)
 80000108038:	e9 51 ff ff ff       	jmp    80000107f8e <walkpglevel+0x7e>
      if (missing)
 8000010803d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
 80000108041:	48 85 c0             	test   %rax,%rax
 80000108044:	74 02                	je     80000108048 <walkpglevel+0x138>
        *missing = level;
 80000108046:	89 18                	mov    %ebx,(%rax)
      return 0;
 80000108048:	b8 00 00 00 00       	mov    $0x0,%eax
 8000010804d:	e9 58 ff ff ff       	jmp    80000107faa <walkpglevel+0x9a>

0000080000108052 <walkpml4>:
{
 80000108052:	55                   	push   %rbp
 80000108053:	48 89 e5             	mov    %rsp,%rbp
 80000108056:	49 89 c8             	mov    %rcx,%r8
  return walkpglevel(pml4, va, alloc, 4, missing);
 80000108059:	b9 04 00 00 00       	mov    $0x4,%ecx
 8000010805e:	48 b8 10 7f 10 00 00 	movabs $0x80000107f10,%rax
 80000108065:	08 00 00 
 80000108068:	ff d0                	call   *%rax
}
 8000010806a:	5d                   	pop    %rbp
 8000010806b:	c3                   	ret

000008000010806c <mappages>:
{
 8000010806c:	55                   	push   %rbp
 8000010806d:	48 89 e5             	mov    %rsp,%rbp
 80000108070:	41 57                	push   %r15
 80000108072:	41 56                	push   %r14
 80000108074:	41 55                	push   %r13
 80000108076:	41 54                	push   %r12
 80000108078:	53                   	push   %rbx
 80000108079:	48 83 ec 08          	sub    $0x8,%rsp
 8000010807d:	49 89 fd             	mov    %rdi,%r13
 80000108080:	49 89 cc             	mov    %rcx,%r12
 80000108083:	45 89 c7             	mov    %r8d,%r15d
  a = (char*)PGROUNDDOWN((uint64)va);
 80000108086:	48 89 f3             	mov    %rsi,%rbx
 80000108089:	48 81 e3 00 f0 ff ff 	and    $0xfffffffffffff000,%rbx
  last = (char*)PGROUNDDOWN(((uint64)va) + size - 1);
 80000108090:	89 d2                	mov    %edx,%edx
 80000108092:	4c 8d 74 16 ff       	lea    -0x1(%rsi,%rdx,1),%r14
 80000108097:	49 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%r14
    if((pte = walkpml4(pml4, a, 1, 0)) == 0)
 8000010809e:	b9 00 00 00 00       	mov    $0x0,%ecx
 800001080a3:	ba 01 00 00 00       	mov    $0x1,%edx
 800001080a8:	48 89 de             	mov    %rbx,%rsi
 800001080ab:	4c 89 ef             	mov    %r13,%rdi
 800001080ae:	48 b8 52 80 10 00 00 	movabs $0x80000108052,%rax
 800001080b5:	08 00 00 
 800001080b8:	ff d0                	call   *%rax
 800001080ba:	48 85 c0             	test   %rax,%rax
 800001080bd:	74 3d                	je     800001080fc <mappages+0x90>
    if(*pte & PTE_P)
 800001080bf:	f6 00 01             	testb  $0x1,(%rax)
 800001080c2:	75 22                	jne    800001080e6 <mappages+0x7a>
    *pte = pa | perm | PTE_P;
 800001080c4:	49 63 d7             	movslq %r15d,%rdx
 800001080c7:	4c 09 e2             	or     %r12,%rdx
 800001080ca:	48 83 ca 01          	or     $0x1,%rdx
 800001080ce:	48 89 10             	mov    %rdx,(%rax)
    if(a == last)
 800001080d1:	4c 39 f3             	cmp    %r14,%rbx
 800001080d4:	74 3a                	je     80000108110 <mappages+0xa4>
    a += PGSIZE;
 800001080d6:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
    pa += PGSIZE;
 800001080dd:	49 81 c4 00 10 00 00 	add    $0x1000,%r12
    if((pte = walkpml4(pml4, a, 1, 0)) == 0)
 800001080e4:	eb b8                	jmp    8000010809e <mappages+0x32>
      panic("remap");
 800001080e6:	48 bf ac ad 10 00 00 	movabs $0x8000010adac,%rdi
 800001080ed:	08 00 00 
 800001080f0:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001080f7:	08 00 00 
 800001080fa:	ff d0                	call   *%rax
      return -1;
 800001080fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 80000108101:	48 83 c4 08          	add    $0x8,%rsp
 80000108105:	5b                   	pop    %rbx
 80000108106:	41 5c                	pop    %r12
 80000108108:	41 5d                	pop    %r13
 8000010810a:	41 5e                	pop    %r14
 8000010810c:	41 5f                	pop    %r15
 8000010810e:	5d                   	pop    %rbp
 8000010810f:	c3                   	ret
  return 0;
 80000108110:	b8 00 00 00 00       	mov    $0x0,%eax
 80000108115:	eb ea                	jmp    80000108101 <mappages+0x95>

0000080000108117 <seginit>:
{
 80000108117:	55                   	push   %rbp
 80000108118:	48 89 e5             	mov    %rsp,%rbp
 8000010811b:	48 83 ec 10          	sub    $0x10,%rsp
  c = &cpus[cpuid()];
 8000010811f:	48 b8 3b 46 10 00 00 	movabs $0x8000010463b,%rax
 80000108126:	08 00 00 
 80000108129:	ff d0                	call   *%rax
  c->gdt[SEG_KCODE] = SEG64(STA_X|STA_R, 0, 0xffffffff, 0, 1);
 8000010812b:	48 ba 20 a0 11 00 00 	movabs $0x8000011a020,%rdx
 80000108132:	08 00 00 
 80000108135:	48 98                	cltq
 80000108137:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 8000010813b:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
 80000108142:	00 
 80000108143:	48 8d 34 08          	lea    (%rax,%rcx,1),%rsi
 80000108147:	66 c7 84 f2 80 00 00 	movw   $0xffff,0x80(%rdx,%rsi,8)
 8000010814e:	00 ff ff 
 80000108151:	66 c7 84 f2 82 00 00 	movw   $0x0,0x82(%rdx,%rsi,8)
 80000108158:	00 00 00 
 8000010815b:	c6 84 f2 84 00 00 00 	movb   $0x0,0x84(%rdx,%rsi,8)
 80000108162:	00 
 80000108163:	48 8d 7c f2 78       	lea    0x78(%rdx,%rsi,8),%rdi
 80000108168:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 8000010816c:	83 e6 f0             	and    $0xfffffff0,%esi
 8000010816f:	83 ce 0a             	or     $0xa,%esi
 80000108172:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 80000108176:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 8000010817a:	83 ce 10             	or     $0x10,%esi
 8000010817d:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 80000108181:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 80000108185:	83 e6 9f             	and    $0xffffff9f,%esi
 80000108188:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 8000010818c:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 80000108190:	83 ce 80             	or     $0xffffff80,%esi
 80000108193:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 80000108197:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 8000010819b:	83 ce 0f             	or     $0xf,%esi
 8000010819e:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 800001081a2:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 800001081a6:	83 e6 ef             	and    $0xffffffef,%esi
 800001081a9:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 800001081ad:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 800001081b1:	83 ce 20             	or     $0x20,%esi
 800001081b4:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 800001081b8:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 800001081bc:	83 e6 bf             	and    $0xffffffbf,%esi
 800001081bf:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 800001081c3:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 800001081c7:	83 ce 80             	or     $0xffffff80,%esi
 800001081ca:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 800001081ce:	48 8d 34 08          	lea    (%rax,%rcx,1),%rsi
 800001081d2:	c6 84 f2 87 00 00 00 	movb   $0x0,0x87(%rdx,%rsi,8)
 800001081d9:	00 
  c->gdt[SEG_KDATA] = SEG64(STA_W, 0, 0xffffffff, 0, 0);
 800001081da:	66 c7 84 f2 88 00 00 	movw   $0xffff,0x88(%rdx,%rsi,8)
 800001081e1:	00 ff ff 
 800001081e4:	66 c7 84 f2 8a 00 00 	movw   $0x0,0x8a(%rdx,%rsi,8)
 800001081eb:	00 00 00 
 800001081ee:	c6 84 f2 8c 00 00 00 	movb   $0x0,0x8c(%rdx,%rsi,8)
 800001081f5:	00 
 800001081f6:	48 8d bc f2 80 00 00 	lea    0x80(%rdx,%rsi,8),%rdi
 800001081fd:	00 
 800001081fe:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 80000108202:	83 e6 f0             	and    $0xfffffff0,%esi
 80000108205:	83 ce 02             	or     $0x2,%esi
 80000108208:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 8000010820c:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 80000108210:	83 ce 10             	or     $0x10,%esi
 80000108213:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 80000108217:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 8000010821b:	83 e6 9f             	and    $0xffffff9f,%esi
 8000010821e:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 80000108222:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 80000108226:	83 ce 80             	or     $0xffffff80,%esi
 80000108229:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 8000010822d:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 80000108231:	83 ce 0f             	or     $0xf,%esi
 80000108234:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 80000108238:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 8000010823c:	83 e6 ef             	and    $0xffffffef,%esi
 8000010823f:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 80000108243:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 80000108247:	83 e6 df             	and    $0xffffffdf,%esi
 8000010824a:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 8000010824e:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 80000108252:	83 e6 bf             	and    $0xffffffbf,%esi
 80000108255:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 80000108259:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 8000010825d:	83 ce 80             	or     $0xffffff80,%esi
 80000108260:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 80000108264:	48 8d 34 08          	lea    (%rax,%rcx,1),%rsi
 80000108268:	c6 84 f2 8f 00 00 00 	movb   $0x0,0x8f(%rdx,%rsi,8)
 8000010826f:	00 
  c->gdt[SEG_UCODE] = SEG64(STA_X|STA_R, 0, 0xffffffff, DPL_USER, 1);
 80000108270:	66 c7 84 f2 90 00 00 	movw   $0xffff,0x90(%rdx,%rsi,8)
 80000108277:	00 ff ff 
 8000010827a:	66 c7 84 f2 92 00 00 	movw   $0x0,0x92(%rdx,%rsi,8)
 80000108281:	00 00 00 
 80000108284:	c6 84 f2 94 00 00 00 	movb   $0x0,0x94(%rdx,%rsi,8)
 8000010828b:	00 
 8000010828c:	48 8d bc f2 88 00 00 	lea    0x88(%rdx,%rsi,8),%rdi
 80000108293:	00 
 80000108294:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 80000108298:	83 e6 f0             	and    $0xfffffff0,%esi
 8000010829b:	83 ce 0a             	or     $0xa,%esi
 8000010829e:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 800001082a2:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 800001082a6:	83 ce 10             	or     $0x10,%esi
 800001082a9:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 800001082ad:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 800001082b1:	83 ce 60             	or     $0x60,%esi
 800001082b4:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 800001082b8:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 800001082bc:	83 ce 80             	or     $0xffffff80,%esi
 800001082bf:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 800001082c3:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 800001082c7:	83 ce 0f             	or     $0xf,%esi
 800001082ca:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 800001082ce:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 800001082d2:	83 e6 ef             	and    $0xffffffef,%esi
 800001082d5:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 800001082d9:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 800001082dd:	83 ce 20             	or     $0x20,%esi
 800001082e0:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 800001082e4:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 800001082e8:	83 e6 bf             	and    $0xffffffbf,%esi
 800001082eb:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 800001082ef:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 800001082f3:	83 ce 80             	or     $0xffffff80,%esi
 800001082f6:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 800001082fa:	48 8d 34 08          	lea    (%rax,%rcx,1),%rsi
 800001082fe:	c6 84 f2 97 00 00 00 	movb   $0x0,0x97(%rdx,%rsi,8)
 80000108305:	00 
  c->gdt[SEG_UDATA] = SEG64(STA_W, 0, 0xffffffff, DPL_USER, 0);
 80000108306:	66 c7 84 f2 98 00 00 	movw   $0xffff,0x98(%rdx,%rsi,8)
 8000010830d:	00 ff ff 
 80000108310:	66 c7 84 f2 9a 00 00 	movw   $0x0,0x9a(%rdx,%rsi,8)
 80000108317:	00 00 00 
 8000010831a:	c6 84 f2 9c 00 00 00 	movb   $0x0,0x9c(%rdx,%rsi,8)
 80000108321:	00 
 80000108322:	48 8d bc f2 90 00 00 	lea    0x90(%rdx,%rsi,8),%rdi
 80000108329:	00 
 8000010832a:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 8000010832e:	83 e6 f0             	and    $0xfffffff0,%esi
 80000108331:	83 ce 02             	or     $0x2,%esi
 80000108334:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 80000108338:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 8000010833c:	83 ce 10             	or     $0x10,%esi
 8000010833f:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 80000108343:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 80000108347:	83 ce 60             	or     $0x60,%esi
 8000010834a:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 8000010834e:	40 8a 77 0d          	mov    0xd(%rdi),%sil
 80000108352:	83 ce 80             	or     $0xffffff80,%esi
 80000108355:	40 88 77 0d          	mov    %sil,0xd(%rdi)
 80000108359:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 8000010835d:	83 ce 0f             	or     $0xf,%esi
 80000108360:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 80000108364:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 80000108368:	83 e6 ef             	and    $0xffffffef,%esi
 8000010836b:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 8000010836f:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 80000108373:	83 e6 df             	and    $0xffffffdf,%esi
 80000108376:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 8000010837a:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 8000010837e:	83 e6 bf             	and    $0xffffffbf,%esi
 80000108381:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 80000108385:	40 8a 77 0e          	mov    0xe(%rdi),%sil
 80000108389:	83 ce 80             	or     $0xffffff80,%esi
 8000010838c:	40 88 77 0e          	mov    %sil,0xe(%rdi)
 80000108390:	48 8d 34 08          	lea    (%rax,%rcx,1),%rsi
 80000108394:	c6 84 f2 9f 00 00 00 	movb   $0x0,0x9f(%rdx,%rsi,8)
 8000010839b:	00 
  lgdt(c->gdt, sizeof(c->gdt));
 8000010839c:	48 8d 44 f2 78       	lea    0x78(%rdx,%rsi,8),%rax
  pd[0] = size-1;
 800001083a1:	66 c7 45 f6 37 00    	movw   $0x37,-0xa(%rbp)
  pd[1] = (uint64)p;
 800001083a7:	66 89 45 f8          	mov    %ax,-0x8(%rbp)
  pd[2] = (uint64)p >> 16;
 800001083ab:	48 89 c2             	mov    %rax,%rdx
 800001083ae:	48 c1 ea 10          	shr    $0x10,%rdx
 800001083b2:	66 89 55 fa          	mov    %dx,-0x6(%rbp)
  pd[3] = (uint64)p >> 32;
 800001083b6:	48 89 c2             	mov    %rax,%rdx
 800001083b9:	48 c1 ea 20          	shr    $0x20,%rdx
 800001083bd:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
  pd[4] = (uint64)p >> 48;
 800001083c1:	48 c1 e8 30          	shr    $0x30,%rax
 800001083c5:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
  asm volatile("lgdt (%0)" : : "r" (pd));
 800001083c9:	48 8d 45 f6          	lea    -0xa(%rbp),%rax
 800001083cd:	0f 01 10             	lgdt   (%rax)
}
 800001083d0:	48 89 ec             	mov    %rbp,%rsp
 800001083d3:	5d                   	pop    %rbp
 800001083d4:	c3                   	ret

00000800001083d5 <acpitable>:
{
 800001083d5:	55                   	push   %rbp
 800001083d6:	48 89 e5             	mov    %rsp,%rbp
 800001083d9:	41 54                	push   %r12
 800001083db:	53                   	push   %rbx
 800001083dc:	48 89 fb             	mov    %rdi,%rbx
  va = P2V(pa);
 800001083df:	48 be 00 00 00 00 00 	movabs $0x80000000000,%rsi
 800001083e6:	08 00 00 
 800001083e9:	48 01 fe             	add    %rdi,%rsi
 800001083ec:	49 89 f4             	mov    %rsi,%r12
  if ((pte = walkpml4(kpml4, va, 1, 0)) == 0)
 800001083ef:	b9 00 00 00 00       	mov    $0x0,%ecx
 800001083f4:	ba 01 00 00 00       	mov    $0x1,%edx
 800001083f9:	48 b8 88 ef 11 00 00 	movabs $0x8000011ef88,%rax
 80000108400:	08 00 00 
 80000108403:	48 8b 38             	mov    (%rax),%rdi
 80000108406:	48 b8 52 80 10 00 00 	movabs $0x80000108052,%rax
 8000010840d:	08 00 00 
 80000108410:	ff d0                	call   *%rax
 80000108412:	48 85 c0             	test   %rax,%rax
 80000108415:	74 15                	je     8000010842c <acpitable+0x57>
  if (! *pte & PTE_P)
 80000108417:	48 83 38 00          	cmpq   $0x0,(%rax)
 8000010841b:	75 07                	jne    80000108424 <acpitable+0x4f>
    *pte = pa | PTE_P;
 8000010841d:	48 83 cb 01          	or     $0x1,%rbx
 80000108421:	48 89 18             	mov    %rbx,(%rax)
}
 80000108424:	4c 89 e0             	mov    %r12,%rax
 80000108427:	5b                   	pop    %rbx
 80000108428:	41 5c                	pop    %r12
 8000010842a:	5d                   	pop    %rbp
 8000010842b:	c3                   	ret
    return 0;
 8000010842c:	49 89 c4             	mov    %rax,%r12
 8000010842f:	eb f3                	jmp    80000108424 <acpitable+0x4f>

0000080000108431 <switchkvm>:
  lcr3(V2P(kpml4));   // switch to the kernel page table
 80000108431:	48 a1 88 ef 11 00 00 	movabs 0x8000011ef88,%rax
 80000108438:	08 00 00 
 8000010843b:	48 ba 00 00 00 00 00 	movabs $0xfffff80000000000,%rdx
 80000108442:	f8 ff ff 
 80000108445:	48 01 d0             	add    %rdx,%rax
  asm volatile("movq %0,%%cr3" : : "r" (val));
 80000108448:	0f 22 d8             	mov    %rax,%cr3
}
 8000010844b:	c3                   	ret

000008000010844c <switchuvm>:
{
 8000010844c:	55                   	push   %rbp
 8000010844d:	48 89 e5             	mov    %rsp,%rbp
 80000108450:	41 57                	push   %r15
 80000108452:	41 56                	push   %r14
 80000108454:	41 55                	push   %r13
 80000108456:	41 54                	push   %r12
 80000108458:	53                   	push   %rbx
 80000108459:	48 83 ec 18          	sub    $0x18,%rsp
  if(p == 0)
 8000010845d:	48 85 ff             	test   %rdi,%rdi
 80000108460:	0f 84 85 01 00 00    	je     800001085eb <switchuvm+0x19f>
 80000108466:	49 89 fc             	mov    %rdi,%r12
  if(p->kstack == 0)
 80000108469:	48 83 7f 10 00       	cmpq   $0x0,0x10(%rdi)
 8000010846e:	0f 84 8d 01 00 00    	je     80000108601 <switchuvm+0x1b5>
  if(p->pml4 == 0)
 80000108474:	48 83 7f 08 00       	cmpq   $0x0,0x8(%rdi)
 80000108479:	0f 84 98 01 00 00    	je     80000108617 <switchuvm+0x1cb>
  pushcli();
 8000010847f:	48 b8 d4 53 10 00 00 	movabs $0x800001053d4,%rax
 80000108486:	08 00 00 
 80000108489:	ff d0                	call   *%rax
  struct tssdesc *tss = (struct tssdesc *)&mycpu()->gdt[SEG_TSS];
 8000010848b:	49 bd a8 45 10 00 00 	movabs $0x800001045a8,%r13
 80000108492:	08 00 00 
 80000108495:	41 ff d5             	call   *%r13
 80000108498:	48 89 c3             	mov    %rax,%rbx
  *tss = TSS64(STS_T64A, &mycpu()->ts, sizeof(mycpu()->ts)-1, 0);
 8000010849b:	41 ff d5             	call   *%r13
 8000010849e:	4c 8d 78 10          	lea    0x10(%rax),%r15
 800001084a2:	41 ff d5             	call   *%r13
 800001084a5:	4c 8d 70 10          	lea    0x10(%rax),%r14
 800001084a9:	49 c1 ee 10          	shr    $0x10,%r14
 800001084ad:	41 ff d5             	call   *%r13
 800001084b0:	48 83 c0 10          	add    $0x10,%rax
 800001084b4:	48 c1 e8 18          	shr    $0x18,%rax
 800001084b8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
 800001084bc:	41 ff d5             	call   *%r13
 800001084bf:	48 83 c0 10          	add    $0x10,%rax
 800001084c3:	48 c1 e8 20          	shr    $0x20,%rax
 800001084c7:	c6 83 a0 00 00 00 67 	movb   $0x67,0xa0(%rbx)
 800001084ce:	c6 83 a1 00 00 00 00 	movb   $0x0,0xa1(%rbx)
 800001084d5:	44 88 bb a2 00 00 00 	mov    %r15b,0xa2(%rbx)
 800001084dc:	4c 89 f9             	mov    %r15,%rcx
 800001084df:	88 ab a3 00 00 00    	mov    %ch,0xa3(%rbx)
 800001084e5:	44 88 b3 a4 00 00 00 	mov    %r14b,0xa4(%rbx)
 800001084ec:	8a 93 a5 00 00 00    	mov    0xa5(%rbx),%dl
 800001084f2:	83 e2 f0             	and    $0xfffffff0,%edx
 800001084f5:	83 ca 09             	or     $0x9,%edx
 800001084f8:	88 93 a5 00 00 00    	mov    %dl,0xa5(%rbx)
 800001084fe:	83 e2 ef             	and    $0xffffffef,%edx
 80000108501:	88 93 a5 00 00 00    	mov    %dl,0xa5(%rbx)
 80000108507:	83 e2 9f             	and    $0xffffff9f,%edx
 8000010850a:	88 93 a5 00 00 00    	mov    %dl,0xa5(%rbx)
 80000108510:	83 ca 80             	or     $0xffffff80,%edx
 80000108513:	88 93 a5 00 00 00    	mov    %dl,0xa5(%rbx)
 80000108519:	8a 93 a6 00 00 00    	mov    0xa6(%rbx),%dl
 8000010851f:	83 e2 f0             	and    $0xfffffff0,%edx
 80000108522:	88 93 a6 00 00 00    	mov    %dl,0xa6(%rbx)
 80000108528:	83 e2 ef             	and    $0xffffffef,%edx
 8000010852b:	88 93 a6 00 00 00    	mov    %dl,0xa6(%rbx)
 80000108531:	83 e2 df             	and    $0xffffffdf,%edx
 80000108534:	88 93 a6 00 00 00    	mov    %dl,0xa6(%rbx)
 8000010853a:	83 e2 bf             	and    $0xffffffbf,%edx
 8000010853d:	88 93 a6 00 00 00    	mov    %dl,0xa6(%rbx)
 80000108543:	c6 83 a6 00 00 00 00 	movb   $0x0,0xa6(%rbx)
 8000010854a:	40 8a 75 c8          	mov    -0x38(%rbp),%sil
 8000010854e:	40 88 b3 a7 00 00 00 	mov    %sil,0xa7(%rbx)
 80000108555:	89 83 a8 00 00 00    	mov    %eax,0xa8(%rbx)
 8000010855b:	c6 83 ac 00 00 00 00 	movb   $0x0,0xac(%rbx)
 80000108562:	8a 83 ad 00 00 00    	mov    0xad(%rbx),%al
 80000108568:	83 e0 e0             	and    $0xffffffe0,%eax
 8000010856b:	88 83 ad 00 00 00    	mov    %al,0xad(%rbx)
 80000108571:	c6 83 ad 00 00 00 00 	movb   $0x0,0xad(%rbx)
 80000108578:	c6 83 ae 00 00 00 00 	movb   $0x0,0xae(%rbx)
 8000010857f:	c6 83 af 00 00 00 00 	movb   $0x0,0xaf(%rbx)
  mycpu()->ts.rsp0_31_0 = (uint)((uint64)p->kstack + KSTACKSIZE);
 80000108586:	49 8b 5c 24 10       	mov    0x10(%r12),%rbx
 8000010858b:	41 ff d5             	call   *%r13
 8000010858e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
 80000108594:	89 58 14             	mov    %ebx,0x14(%rax)
  mycpu()->ts.rsp0_63_32 = (uint)(((uint64)p->kstack + KSTACKSIZE) >> 32);
 80000108597:	49 8b 44 24 10       	mov    0x10(%r12),%rax
 8000010859c:	48 8d 98 00 10 00 00 	lea    0x1000(%rax),%rbx
 800001085a3:	48 c1 eb 20          	shr    $0x20,%rbx
 800001085a7:	41 ff d5             	call   *%r13
 800001085aa:	89 58 18             	mov    %ebx,0x18(%rax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
 800001085ad:	41 ff d5             	call   *%r13
 800001085b0:	66 c7 40 76 ff ff    	movw   $0xffff,0x76(%rax)
    asm volatile("ltr %0" : : "r" (sel));
 800001085b6:	b8 28 00 00 00       	mov    $0x28,%eax
 800001085bb:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pml4));  // switch to process's address space
 800001085be:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 800001085c5:	f8 ff ff 
 800001085c8:	49 03 44 24 08       	add    0x8(%r12),%rax
  asm volatile("movq %0,%%cr3" : : "r" (val));
 800001085cd:	0f 22 d8             	mov    %rax,%cr3
  popcli();
 800001085d0:	48 b8 31 54 10 00 00 	movabs $0x80000105431,%rax
 800001085d7:	08 00 00 
 800001085da:	ff d0                	call   *%rax
}
 800001085dc:	48 83 c4 18          	add    $0x18,%rsp
 800001085e0:	5b                   	pop    %rbx
 800001085e1:	41 5c                	pop    %r12
 800001085e3:	41 5d                	pop    %r13
 800001085e5:	41 5e                	pop    %r14
 800001085e7:	41 5f                	pop    %r15
 800001085e9:	5d                   	pop    %rbp
 800001085ea:	c3                   	ret
    panic("switchuvm: no process");
 800001085eb:	48 bf b2 ad 10 00 00 	movabs $0x8000010adb2,%rdi
 800001085f2:	08 00 00 
 800001085f5:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001085fc:	08 00 00 
 800001085ff:	ff d0                	call   *%rax
    panic("switchuvm: no kstack");
 80000108601:	48 bf c8 ad 10 00 00 	movabs $0x8000010adc8,%rdi
 80000108608:	08 00 00 
 8000010860b:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000108612:	08 00 00 
 80000108615:	ff d0                	call   *%rax
    panic("switchuvm: no pml4");
 80000108617:	48 bf dd ad 10 00 00 	movabs $0x8000010addd,%rdi
 8000010861e:	08 00 00 
 80000108621:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000108628:	08 00 00 
 8000010862b:	ff d0                	call   *%rax

000008000010862d <inituvm>:
{
 8000010862d:	55                   	push   %rbp
 8000010862e:	48 89 e5             	mov    %rsp,%rbp
 80000108631:	41 56                	push   %r14
 80000108633:	41 55                	push   %r13
 80000108635:	41 54                	push   %r12
 80000108637:	53                   	push   %rbx
  if(sz >= PGSIZE)
 80000108638:	48 81 fa ff 0f 00 00 	cmp    $0xfff,%rdx
 8000010863f:	77 7a                	ja     800001086bb <inituvm+0x8e>
 80000108641:	49 89 fe             	mov    %rdi,%r14
 80000108644:	49 89 f5             	mov    %rsi,%r13
 80000108647:	48 89 d3             	mov    %rdx,%rbx
  mem = kalloc();
 8000010864a:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000108651:	08 00 00 
 80000108654:	ff d0                	call   *%rax
 80000108656:	49 89 c4             	mov    %rax,%r12
  memset(mem, 0, PGSIZE);
 80000108659:	ba 00 10 00 00       	mov    $0x1000,%edx
 8000010865e:	be 00 00 00 00       	mov    $0x0,%esi
 80000108663:	48 89 c7             	mov    %rax,%rdi
 80000108666:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 8000010866d:	08 00 00 
 80000108670:	ff d0                	call   *%rax
  mappages(pml4, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
 80000108672:	48 b9 00 00 00 00 00 	movabs $0xfffff80000000000,%rcx
 80000108679:	f8 ff ff 
 8000010867c:	4c 01 e1             	add    %r12,%rcx
 8000010867f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
 80000108685:	ba 00 10 00 00       	mov    $0x1000,%edx
 8000010868a:	be 00 00 00 00       	mov    $0x0,%esi
 8000010868f:	4c 89 f7             	mov    %r14,%rdi
 80000108692:	48 b8 6c 80 10 00 00 	movabs $0x8000010806c,%rax
 80000108699:	08 00 00 
 8000010869c:	ff d0                	call   *%rax
  memmove(mem, init, sz);
 8000010869e:	89 da                	mov    %ebx,%edx
 800001086a0:	4c 89 ee             	mov    %r13,%rsi
 800001086a3:	4c 89 e7             	mov    %r12,%rdi
 800001086a6:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 800001086ad:	08 00 00 
 800001086b0:	ff d0                	call   *%rax
}
 800001086b2:	5b                   	pop    %rbx
 800001086b3:	41 5c                	pop    %r12
 800001086b5:	41 5d                	pop    %r13
 800001086b7:	41 5e                	pop    %r14
 800001086b9:	5d                   	pop    %rbp
 800001086ba:	c3                   	ret
    panic("inituvm: more than a page");
 800001086bb:	48 bf f0 ad 10 00 00 	movabs $0x8000010adf0,%rdi
 800001086c2:	08 00 00 
 800001086c5:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 800001086cc:	08 00 00 
 800001086cf:	ff d0                	call   *%rax

00000800001086d1 <loaduvm>:
{
 800001086d1:	55                   	push   %rbp
 800001086d2:	48 89 e5             	mov    %rsp,%rbp
 800001086d5:	41 57                	push   %r15
 800001086d7:	41 56                	push   %r14
 800001086d9:	41 55                	push   %r13
 800001086db:	41 54                	push   %r12
 800001086dd:	53                   	push   %rbx
 800001086de:	48 83 ec 18          	sub    $0x18,%rsp
 800001086e2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
 800001086e6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  if((uint64) addr % PGSIZE != 0)
 800001086ea:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
 800001086f0:	75 10                	jne    80000108702 <loaduvm+0x31>
 800001086f2:	49 89 f6             	mov    %rsi,%r14
 800001086f5:	41 89 cf             	mov    %ecx,%r15d
 800001086f8:	4d 89 c5             	mov    %r8,%r13
  for(i = 0; i < sz; i += PGSIZE){
 800001086fb:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000108700:	eb 61                	jmp    80000108763 <loaduvm+0x92>
    panic("loaduvm: addr must be page aligned");
 80000108702:	48 bf a8 b0 10 00 00 	movabs $0x8000010b0a8,%rdi
 80000108709:	08 00 00 
 8000010870c:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000108713:	08 00 00 
 80000108716:	ff d0                	call   *%rax
      panic("loaduvm: address should exist");
 80000108718:	48 bf 0a ae 10 00 00 	movabs $0x8000010ae0a,%rdi
 8000010871f:	08 00 00 
 80000108722:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000108729:	08 00 00 
 8000010872c:	ff d0                	call   *%rax
      n = PGSIZE;
 8000010872e:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
    if(readi(ip, P2V(pa), offset+i, n) != n)
 80000108734:	48 b8 00 00 00 00 00 	movabs $0x80000000000,%rax
 8000010873b:	08 00 00 
 8000010873e:	48 01 c6             	add    %rax,%rsi
 80000108741:	42 8d 14 3b          	lea    (%rbx,%r15,1),%edx
 80000108745:	44 89 e1             	mov    %r12d,%ecx
 80000108748:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
 8000010874c:	48 b8 bd 21 10 00 00 	movabs $0x800001021bd,%rax
 80000108753:	08 00 00 
 80000108756:	ff d0                	call   *%rax
 80000108758:	44 39 e0             	cmp    %r12d,%eax
 8000010875b:	75 65                	jne    800001087c2 <loaduvm+0xf1>
  for(i = 0; i < sz; i += PGSIZE){
 8000010875d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
 80000108763:	41 89 dc             	mov    %ebx,%r12d
 80000108766:	4d 39 ec             	cmp    %r13,%r12
 80000108769:	73 43                	jae    800001087ae <loaduvm+0xdd>
    if((pte = walkpml4(pml4, addr+i, 0, 0)) == 0)
 8000010876b:	4b 8d 34 26          	lea    (%r14,%r12,1),%rsi
 8000010876f:	b9 00 00 00 00       	mov    $0x0,%ecx
 80000108774:	ba 00 00 00 00       	mov    $0x0,%edx
 80000108779:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
 8000010877d:	48 b8 52 80 10 00 00 	movabs $0x80000108052,%rax
 80000108784:	08 00 00 
 80000108787:	ff d0                	call   *%rax
 80000108789:	48 85 c0             	test   %rax,%rax
 8000010878c:	74 8a                	je     80000108718 <loaduvm+0x47>
    pa = PTE_ADDR(*pte);
 8000010878e:	48 8b 30             	mov    (%rax),%rsi
 80000108791:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
    if(sz - i < PGSIZE)
 80000108798:	4c 89 e8             	mov    %r13,%rax
 8000010879b:	4c 29 e0             	sub    %r12,%rax
 8000010879e:	48 3d ff 0f 00 00    	cmp    $0xfff,%rax
 800001087a4:	77 88                	ja     8000010872e <loaduvm+0x5d>
      n = sz - i;
 800001087a6:	45 89 ec             	mov    %r13d,%r12d
 800001087a9:	41 29 dc             	sub    %ebx,%r12d
 800001087ac:	eb 86                	jmp    80000108734 <loaduvm+0x63>
  return 0;
 800001087ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
 800001087b3:	48 83 c4 18          	add    $0x18,%rsp
 800001087b7:	5b                   	pop    %rbx
 800001087b8:	41 5c                	pop    %r12
 800001087ba:	41 5d                	pop    %r13
 800001087bc:	41 5e                	pop    %r14
 800001087be:	41 5f                	pop    %r15
 800001087c0:	5d                   	pop    %rbp
 800001087c1:	c3                   	ret
      return -1;
 800001087c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 800001087c7:	eb ea                	jmp    800001087b3 <loaduvm+0xe2>

00000800001087c9 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pml4e_t *pml4, uint64 oldsz, uint64 newsz)
{
 800001087c9:	55                   	push   %rbp
 800001087ca:	48 89 e5             	mov    %rsp,%rbp
 800001087cd:	41 57                	push   %r15
 800001087cf:	41 56                	push   %r14
 800001087d1:	41 55                	push   %r13
 800001087d3:	41 54                	push   %r12
 800001087d5:	53                   	push   %rbx
 800001087d6:	48 83 ec 18          	sub    $0x18,%rsp
 800001087da:	49 89 f5             	mov    %rsi,%r13
  pte_t *pte;
  uint64 a, pa;
  int walkpml4_missing_level;

  if(newsz >= oldsz)
 800001087dd:	48 39 f2             	cmp    %rsi,%rdx
 800001087e0:	73 16                	jae    800001087f8 <deallocuvm+0x2f>
 800001087e2:	49 89 fe             	mov    %rdi,%r14
 800001087e5:	49 89 d7             	mov    %rdx,%r15
    return oldsz;

  a = PGROUNDUP(newsz);
 800001087e8:	4c 8d a2 ff 0f 00 00 	lea    0xfff(%rdx),%r12
 800001087ef:	49 81 e4 00 f0 ff ff 	and    $0xfffffffffffff000,%r12
  for(; a  < oldsz; a += PGSIZE){
 800001087f6:	eb 27                	jmp    8000010881f <deallocuvm+0x56>
    return oldsz;
 800001087f8:	89 f0                	mov    %esi,%eax
 800001087fa:	e9 95 00 00 00       	jmp    80000108894 <deallocuvm+0xcb>
    pte = walkpml4(pml4, (char*)a, 0, &walkpml4_missing_level);
    if(!pte){ // Skip the page table
      a = skiptables(a, walkpml4_missing_level) - PGSIZE;
 800001087ff:	8b 75 cc             	mov    -0x34(%rbp),%esi
 80000108802:	4c 89 e7             	mov    %r12,%rdi
 80000108805:	48 b8 20 7e 10 00 00 	movabs $0x80000107e20,%rax
 8000010880c:	08 00 00 
 8000010880f:	ff d0                	call   *%rax
 80000108811:	4c 8d a0 00 f0 ff ff 	lea    -0x1000(%rax),%r12
  for(; a  < oldsz; a += PGSIZE){
 80000108818:	49 81 c4 00 10 00 00 	add    $0x1000,%r12
 8000010881f:	4d 39 ec             	cmp    %r13,%r12
 80000108822:	73 6d                	jae    80000108891 <deallocuvm+0xc8>
    pte = walkpml4(pml4, (char*)a, 0, &walkpml4_missing_level);
 80000108824:	48 8d 4d cc          	lea    -0x34(%rbp),%rcx
 80000108828:	ba 00 00 00 00       	mov    $0x0,%edx
 8000010882d:	4c 89 e6             	mov    %r12,%rsi
 80000108830:	4c 89 f7             	mov    %r14,%rdi
 80000108833:	48 b8 52 80 10 00 00 	movabs $0x80000108052,%rax
 8000010883a:	08 00 00 
 8000010883d:	ff d0                	call   *%rax
 8000010883f:	48 89 c3             	mov    %rax,%rbx
    if(!pte){ // Skip the page table
 80000108842:	48 85 c0             	test   %rax,%rax
 80000108845:	74 b8                	je     800001087ff <deallocuvm+0x36>
    } else if((*pte & PTE_P) != 0){
 80000108847:	48 8b 38             	mov    (%rax),%rdi
 8000010884a:	40 f6 c7 01          	test   $0x1,%dil
 8000010884e:	74 c8                	je     80000108818 <deallocuvm+0x4f>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
 80000108850:	48 81 e7 00 f0 ff ff 	and    $0xfffffffffffff000,%rdi
 80000108857:	74 22                	je     8000010887b <deallocuvm+0xb2>
        panic("kfree");
      char *v = P2V(pa);
 80000108859:	48 b8 00 00 00 00 00 	movabs $0x80000000000,%rax
 80000108860:	08 00 00 
 80000108863:	48 01 c7             	add    %rax,%rdi
      kfree(v);
 80000108866:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 8000010886d:	08 00 00 
 80000108870:	ff d0                	call   *%rax
      *pte = 0;
 80000108872:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
 80000108879:	eb 9d                	jmp    80000108818 <deallocuvm+0x4f>
        panic("kfree");
 8000010887b:	48 bf 6c ab 10 00 00 	movabs $0x8000010ab6c,%rdi
 80000108882:	08 00 00 
 80000108885:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 8000010888c:	08 00 00 
 8000010888f:	ff d0                	call   *%rax
    }
  }
  return newsz;
 80000108891:	44 89 f8             	mov    %r15d,%eax
}
 80000108894:	48 83 c4 18          	add    $0x18,%rsp
 80000108898:	5b                   	pop    %rbx
 80000108899:	41 5c                	pop    %r12
 8000010889b:	41 5d                	pop    %r13
 8000010889d:	41 5e                	pop    %r14
 8000010889f:	41 5f                	pop    %r15
 800001088a1:	5d                   	pop    %rbp
 800001088a2:	c3                   	ret

00000800001088a3 <allocuvm>:
  if(newsz >= KERNBASE)
 800001088a3:	48 b8 ff ff ff ff ff 	movabs $0x7ffffffffff,%rax
 800001088aa:	07 00 00 
 800001088ad:	48 39 d0             	cmp    %rdx,%rax
 800001088b0:	0f 82 2d 01 00 00    	jb     800001089e3 <allocuvm+0x140>
{
 800001088b6:	55                   	push   %rbp
 800001088b7:	48 89 e5             	mov    %rsp,%rbp
 800001088ba:	41 57                	push   %r15
 800001088bc:	41 56                	push   %r14
 800001088be:	41 55                	push   %r13
 800001088c0:	41 54                	push   %r12
 800001088c2:	53                   	push   %rbx
 800001088c3:	48 83 ec 08          	sub    $0x8,%rsp
 800001088c7:	49 89 fe             	mov    %rdi,%r14
 800001088ca:	49 89 f7             	mov    %rsi,%r15
 800001088cd:	49 89 d5             	mov    %rdx,%r13
  if(newsz < oldsz)
 800001088d0:	48 39 f2             	cmp    %rsi,%rdx
 800001088d3:	72 7b                	jb     80000108950 <allocuvm+0xad>
  a = PGROUNDUP(oldsz);
 800001088d5:	4c 8d a6 ff 0f 00 00 	lea    0xfff(%rsi),%r12
 800001088dc:	49 81 e4 00 f0 ff ff 	and    $0xfffffffffffff000,%r12
  for(; a < newsz; a += PGSIZE){
 800001088e3:	4d 39 ec             	cmp    %r13,%r12
 800001088e6:	0f 83 ef 00 00 00    	jae    800001089db <allocuvm+0x138>
    mem = kalloc();
 800001088ec:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 800001088f3:	08 00 00 
 800001088f6:	ff d0                	call   *%rax
 800001088f8:	48 89 c3             	mov    %rax,%rbx
    if(mem == 0){
 800001088fb:	48 85 c0             	test   %rax,%rax
 800001088fe:	74 61                	je     80000108961 <allocuvm+0xbe>
    memset(mem, 0, PGSIZE);
 80000108900:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000108905:	be 00 00 00 00       	mov    $0x0,%esi
 8000010890a:	48 89 c7             	mov    %rax,%rdi
 8000010890d:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000108914:	08 00 00 
 80000108917:	ff d0                	call   *%rax
    if(mappages(pml4, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
 80000108919:	48 b9 00 00 00 00 00 	movabs $0xfffff80000000000,%rcx
 80000108920:	f8 ff ff 
 80000108923:	48 01 d9             	add    %rbx,%rcx
 80000108926:	41 b8 06 00 00 00    	mov    $0x6,%r8d
 8000010892c:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000108931:	4c 89 e6             	mov    %r12,%rsi
 80000108934:	4c 89 f7             	mov    %r14,%rdi
 80000108937:	48 b8 6c 80 10 00 00 	movabs $0x8000010806c,%rax
 8000010893e:	08 00 00 
 80000108941:	ff d0                	call   *%rax
 80000108943:	85 c0                	test   %eax,%eax
 80000108945:	78 4e                	js     80000108995 <allocuvm+0xf2>
  for(; a < newsz; a += PGSIZE){
 80000108947:	49 81 c4 00 10 00 00 	add    $0x1000,%r12
 8000010894e:	eb 93                	jmp    800001088e3 <allocuvm+0x40>
    return oldsz;
 80000108950:	89 f0                	mov    %esi,%eax
}
 80000108952:	48 83 c4 08          	add    $0x8,%rsp
 80000108956:	5b                   	pop    %rbx
 80000108957:	41 5c                	pop    %r12
 80000108959:	41 5d                	pop    %r13
 8000010895b:	41 5e                	pop    %r14
 8000010895d:	41 5f                	pop    %r15
 8000010895f:	5d                   	pop    %rbp
 80000108960:	c3                   	ret
      cprintf("allocuvm out of memory\n");
 80000108961:	48 bf 28 ae 10 00 00 	movabs $0x8000010ae28,%rdi
 80000108968:	08 00 00 
 8000010896b:	b0 00                	mov    $0x0,%al
 8000010896d:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000108974:	08 00 00 
 80000108977:	ff d2                	call   *%rdx
      deallocuvm(pml4, newsz, oldsz);
 80000108979:	4c 89 fa             	mov    %r15,%rdx
 8000010897c:	4c 89 ee             	mov    %r13,%rsi
 8000010897f:	4c 89 f7             	mov    %r14,%rdi
 80000108982:	48 b8 c9 87 10 00 00 	movabs $0x800001087c9,%rax
 80000108989:	08 00 00 
 8000010898c:	ff d0                	call   *%rax
      return 0;
 8000010898e:	b8 00 00 00 00       	mov    $0x0,%eax
 80000108993:	eb bd                	jmp    80000108952 <allocuvm+0xaf>
      cprintf("allocuvm out of memory (2)\n");
 80000108995:	48 bf 40 ae 10 00 00 	movabs $0x8000010ae40,%rdi
 8000010899c:	08 00 00 
 8000010899f:	b0 00                	mov    $0x0,%al
 800001089a1:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 800001089a8:	08 00 00 
 800001089ab:	ff d2                	call   *%rdx
      deallocuvm(pml4, newsz, oldsz);
 800001089ad:	4c 89 fa             	mov    %r15,%rdx
 800001089b0:	4c 89 ee             	mov    %r13,%rsi
 800001089b3:	4c 89 f7             	mov    %r14,%rdi
 800001089b6:	48 b8 c9 87 10 00 00 	movabs $0x800001087c9,%rax
 800001089bd:	08 00 00 
 800001089c0:	ff d0                	call   *%rax
      kfree(mem);
 800001089c2:	48 89 df             	mov    %rbx,%rdi
 800001089c5:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 800001089cc:	08 00 00 
 800001089cf:	ff d0                	call   *%rax
      return 0;
 800001089d1:	b8 00 00 00 00       	mov    $0x0,%eax
 800001089d6:	e9 77 ff ff ff       	jmp    80000108952 <allocuvm+0xaf>
  return newsz;
 800001089db:	44 89 e8             	mov    %r13d,%eax
 800001089de:	e9 6f ff ff ff       	jmp    80000108952 <allocuvm+0xaf>
    return 0;
 800001089e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 800001089e8:	c3                   	ret

00000800001089e9 <freepgdir>:

// Free page tables
void
freepgdir(uint64 *pgdir, int level) {
 800001089e9:	55                   	push   %rbp
 800001089ea:	48 89 e5             	mov    %rsp,%rbp
 800001089ed:	41 55                	push   %r13
 800001089ef:	41 54                	push   %r12
 800001089f1:	53                   	push   %rbx
 800001089f2:	48 83 ec 08          	sub    $0x8,%rsp
 800001089f6:	49 89 fc             	mov    %rdi,%r12
  if (level <= 1)
 800001089f9:	83 fe 01             	cmp    $0x1,%esi
 800001089fc:	7e 5e                	jle    80000108a5c <freepgdir+0x73>
 800001089fe:	41 89 f5             	mov    %esi,%r13d
    goto finish;

  for (int i = 0; i < NPTENTRIES; i++) {
 80000108a01:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000108a06:	eb 1b                	jmp    80000108a23 <freepgdir+0x3a>
 80000108a08:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000108a0f:	00 00 00 00 
 80000108a13:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 80000108a1a:	00 00 00 00 
 80000108a1e:	66 90                	xchg   %ax,%ax
 80000108a20:	83 c3 01             	add    $0x1,%ebx
 80000108a23:	81 fb ff 01 00 00    	cmp    $0x1ff,%ebx
 80000108a29:	7f 31                	jg     80000108a5c <freepgdir+0x73>
    if ((pgdir[i] & PTE_P)) {
 80000108a2b:	48 63 c3             	movslq %ebx,%rax
 80000108a2e:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
 80000108a32:	a8 01                	test   $0x1,%al
 80000108a34:	74 ea                	je     80000108a20 <freepgdir+0x37>
      uint64 *next_table = (uint64*)P2V(PTE_ADDR(pgdir[i]));
 80000108a36:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
 80000108a3c:	48 ba 00 00 00 00 00 	movabs $0x80000000000,%rdx
 80000108a43:	08 00 00 
 80000108a46:	48 8d 3c 10          	lea    (%rax,%rdx,1),%rdi
      freepgdir(next_table, level - 1);
 80000108a4a:	41 8d 75 ff          	lea    -0x1(%r13),%esi
 80000108a4e:	48 b8 e9 89 10 00 00 	movabs $0x800001089e9,%rax
 80000108a55:	08 00 00 
 80000108a58:	ff d0                	call   *%rax
 80000108a5a:	eb c4                	jmp    80000108a20 <freepgdir+0x37>
    }
  }

finish:
  kfree((char *)pgdir);
 80000108a5c:	4c 89 e7             	mov    %r12,%rdi
 80000108a5f:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 80000108a66:	08 00 00 
 80000108a69:	ff d0                	call   *%rax
}
 80000108a6b:	48 83 c4 08          	add    $0x8,%rsp
 80000108a6f:	5b                   	pop    %rbx
 80000108a70:	41 5c                	pop    %r12
 80000108a72:	41 5d                	pop    %r13
 80000108a74:	5d                   	pop    %rbp
 80000108a75:	c3                   	ret

0000080000108a76 <freevm>:

// Free page tables and all the physical memory pages
// in the user part.
void
freevm(pml4e_t *pml4)
{
 80000108a76:	55                   	push   %rbp
 80000108a77:	48 89 e5             	mov    %rsp,%rbp
 80000108a7a:	53                   	push   %rbx
 80000108a7b:	48 83 ec 08          	sub    $0x8,%rsp
  if(pml4 == 0)
 80000108a7f:	48 85 ff             	test   %rdi,%rdi
 80000108a82:	74 39                	je     80000108abd <freevm+0x47>
 80000108a84:	48 89 fb             	mov    %rdi,%rbx
    panic("freevm: no pml4");
  deallocuvm(pml4, KERNBASE, 0);
 80000108a87:	ba 00 00 00 00       	mov    $0x0,%edx
 80000108a8c:	48 be 00 00 00 00 00 	movabs $0x80000000000,%rsi
 80000108a93:	08 00 00 
 80000108a96:	48 b8 c9 87 10 00 00 	movabs $0x800001087c9,%rax
 80000108a9d:	08 00 00 
 80000108aa0:	ff d0                	call   *%rax
  freepgdir(pml4, 4);
 80000108aa2:	be 04 00 00 00       	mov    $0x4,%esi
 80000108aa7:	48 89 df             	mov    %rbx,%rdi
 80000108aaa:	48 b8 e9 89 10 00 00 	movabs $0x800001089e9,%rax
 80000108ab1:	08 00 00 
 80000108ab4:	ff d0                	call   *%rax
}
 80000108ab6:	48 83 c4 08          	add    $0x8,%rsp
 80000108aba:	5b                   	pop    %rbx
 80000108abb:	5d                   	pop    %rbp
 80000108abc:	c3                   	ret
    panic("freevm: no pml4");
 80000108abd:	48 bf 5c ae 10 00 00 	movabs $0x8000010ae5c,%rdi
 80000108ac4:	08 00 00 
 80000108ac7:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000108ace:	08 00 00 
 80000108ad1:	ff d0                	call   *%rax

0000080000108ad3 <setupkvm>:
{
 80000108ad3:	55                   	push   %rbp
 80000108ad4:	48 89 e5             	mov    %rsp,%rbp
 80000108ad7:	41 54                	push   %r12
 80000108ad9:	53                   	push   %rbx
  if((pml4 = (pml4e_t*)kalloc()) == 0)
 80000108ada:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000108ae1:	08 00 00 
 80000108ae4:	ff d0                	call   *%rax
 80000108ae6:	49 89 c4             	mov    %rax,%r12
 80000108ae9:	48 85 c0             	test   %rax,%rax
 80000108aec:	74 70                	je     80000108b5e <setupkvm+0x8b>
  memset(pml4, 0, PGSIZE);
 80000108aee:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000108af3:	be 00 00 00 00       	mov    $0x0,%esi
 80000108af8:	48 89 c7             	mov    %rax,%rdi
 80000108afb:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000108b02:	08 00 00 
 80000108b05:	ff d0                	call   *%rax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
 80000108b07:	48 bb 20 08 11 00 00 	movabs $0x80000110820,%rbx
 80000108b0e:	08 00 00 
 80000108b11:	48 b8 a0 08 11 00 00 	movabs $0x800001108a0,%rax
 80000108b18:	08 00 00 
 80000108b1b:	48 39 c3             	cmp    %rax,%rbx
 80000108b1e:	73 3e                	jae    80000108b5e <setupkvm+0x8b>
                (uint64)k->phys_start, k->perm) < 0) {
 80000108b20:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
    if(mappages(pml4, k->virt, k->phys_end - k->phys_start,
 80000108b24:	8b 53 10             	mov    0x10(%rbx),%edx
 80000108b27:	29 ca                	sub    %ecx,%edx
 80000108b29:	48 8b 33             	mov    (%rbx),%rsi
 80000108b2c:	44 8b 43 18          	mov    0x18(%rbx),%r8d
 80000108b30:	4c 89 e7             	mov    %r12,%rdi
 80000108b33:	48 b8 6c 80 10 00 00 	movabs $0x8000010806c,%rax
 80000108b3a:	08 00 00 
 80000108b3d:	ff d0                	call   *%rax
 80000108b3f:	85 c0                	test   %eax,%eax
 80000108b41:	78 06                	js     80000108b49 <setupkvm+0x76>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
 80000108b43:	48 83 c3 20          	add    $0x20,%rbx
 80000108b47:	eb c8                	jmp    80000108b11 <setupkvm+0x3e>
      freevm(pml4);
 80000108b49:	4c 89 e7             	mov    %r12,%rdi
 80000108b4c:	48 b8 76 8a 10 00 00 	movabs $0x80000108a76,%rax
 80000108b53:	08 00 00 
 80000108b56:	ff d0                	call   *%rax
      return 0;
 80000108b58:	41 bc 00 00 00 00    	mov    $0x0,%r12d
}
 80000108b5e:	4c 89 e0             	mov    %r12,%rax
 80000108b61:	5b                   	pop    %rbx
 80000108b62:	41 5c                	pop    %r12
 80000108b64:	5d                   	pop    %rbp
 80000108b65:	c3                   	ret

0000080000108b66 <kvmalloc>:
{
 80000108b66:	55                   	push   %rbp
 80000108b67:	48 89 e5             	mov    %rsp,%rbp
  kpml4 = setupkvm();
 80000108b6a:	48 b8 d3 8a 10 00 00 	movabs $0x80000108ad3,%rax
 80000108b71:	08 00 00 
 80000108b74:	ff d0                	call   *%rax
 80000108b76:	48 a3 88 ef 11 00 00 	movabs %rax,0x8000011ef88
 80000108b7d:	08 00 00 
  switchkvm();
 80000108b80:	48 b8 31 84 10 00 00 	movabs $0x80000108431,%rax
 80000108b87:	08 00 00 
 80000108b8a:	ff d0                	call   *%rax
}
 80000108b8c:	5d                   	pop    %rbp
 80000108b8d:	c3                   	ret

0000080000108b8e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pml4e_t *pml4, char *uva)
{
 80000108b8e:	55                   	push   %rbp
 80000108b8f:	48 89 e5             	mov    %rsp,%rbp
  pte_t *pte;

  pte = walkpml4(pml4, uva, 0, 0);
 80000108b92:	b9 00 00 00 00       	mov    $0x0,%ecx
 80000108b97:	ba 00 00 00 00       	mov    $0x0,%edx
 80000108b9c:	48 b8 52 80 10 00 00 	movabs $0x80000108052,%rax
 80000108ba3:	08 00 00 
 80000108ba6:	ff d0                	call   *%rax
  if(pte == 0)
 80000108ba8:	48 85 c0             	test   %rax,%rax
 80000108bab:	74 0c                	je     80000108bb9 <clearpteu+0x2b>
    panic("clearpteu");
  *pte &= ~PTE_U;
 80000108bad:	48 8b 10             	mov    (%rax),%rdx
 80000108bb0:	48 83 e2 fb          	and    $0xfffffffffffffffb,%rdx
 80000108bb4:	48 89 10             	mov    %rdx,(%rax)
}
 80000108bb7:	5d                   	pop    %rbp
 80000108bb8:	c3                   	ret
    panic("clearpteu");
 80000108bb9:	48 bf 6c ae 10 00 00 	movabs $0x8000010ae6c,%rdi
 80000108bc0:	08 00 00 
 80000108bc3:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000108bca:	08 00 00 
 80000108bcd:	ff d0                	call   *%rax

0000080000108bcf <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pml4e_t*
copyuvm(pml4e_t *pml4, uint64 sz)
{
 80000108bcf:	55                   	push   %rbp
 80000108bd0:	48 89 e5             	mov    %rsp,%rbp
 80000108bd3:	41 57                	push   %r15
 80000108bd5:	41 56                	push   %r14
 80000108bd7:	41 55                	push   %r13
 80000108bd9:	41 54                	push   %r12
 80000108bdb:	53                   	push   %rbx
 80000108bdc:	48 83 ec 28          	sub    $0x28,%rsp
 80000108be0:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
 80000108be4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  pde_t *d;
  pte_t *pte;
  uint64 pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
 80000108be8:	48 b8 d3 8a 10 00 00 	movabs $0x80000108ad3,%rax
 80000108bef:	08 00 00 
 80000108bf2:	ff d0                	call   *%rax
 80000108bf4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
 80000108bf8:	48 85 c0             	test   %rax,%rax
 80000108bfb:	0f 84 13 01 00 00    	je     80000108d14 <copyuvm+0x145>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
 80000108c01:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 80000108c07:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
 80000108c0b:	49 39 c5             	cmp    %rax,%r13
 80000108c0e:	0f 83 00 01 00 00    	jae    80000108d14 <copyuvm+0x145>
    if((pte = walkpml4(pml4, (void *) i, 0, 0)) == 0)
 80000108c14:	b9 00 00 00 00       	mov    $0x0,%ecx
 80000108c19:	ba 00 00 00 00       	mov    $0x0,%edx
 80000108c1e:	4c 89 ee             	mov    %r13,%rsi
 80000108c21:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
 80000108c25:	48 b8 52 80 10 00 00 	movabs $0x80000108052,%rax
 80000108c2c:	08 00 00 
 80000108c2f:	ff d0                	call   *%rax
 80000108c31:	48 85 c0             	test   %rax,%rax
 80000108c34:	0f 84 87 00 00 00    	je     80000108cc1 <copyuvm+0xf2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
 80000108c3a:	48 8b 18             	mov    (%rax),%rbx
 80000108c3d:	f6 c3 01             	test   $0x1,%bl
 80000108c40:	0f 84 91 00 00 00    	je     80000108cd7 <copyuvm+0x108>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
 80000108c46:	49 89 de             	mov    %rbx,%r14
 80000108c49:	49 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%r14
    flags = PTE_FLAGS(*pte);
 80000108c50:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    if((mem = kalloc()) == 0)
 80000108c56:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000108c5d:	08 00 00 
 80000108c60:	ff d0                	call   *%rax
 80000108c62:	49 89 c4             	mov    %rax,%r12
 80000108c65:	48 85 c0             	test   %rax,%rax
 80000108c68:	0f 84 8e 00 00 00    	je     80000108cfc <copyuvm+0x12d>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
 80000108c6e:	49 bf 00 00 00 00 00 	movabs $0x80000000000,%r15
 80000108c75:	08 00 00 
 80000108c78:	4b 8d 34 3e          	lea    (%r14,%r15,1),%rsi
 80000108c7c:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000108c81:	48 89 c7             	mov    %rax,%rdi
 80000108c84:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 80000108c8b:	08 00 00 
 80000108c8e:	ff d0                	call   *%rax
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
 80000108c90:	4c 89 e1             	mov    %r12,%rcx
 80000108c93:	4c 29 f9             	sub    %r15,%rcx
 80000108c96:	41 89 d8             	mov    %ebx,%r8d
 80000108c99:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000108c9e:	4c 89 ee             	mov    %r13,%rsi
 80000108ca1:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
 80000108ca5:	48 b8 6c 80 10 00 00 	movabs $0x8000010806c,%rax
 80000108cac:	08 00 00 
 80000108caf:	ff d0                	call   *%rax
 80000108cb1:	85 c0                	test   %eax,%eax
 80000108cb3:	78 38                	js     80000108ced <copyuvm+0x11e>
  for(i = 0; i < sz; i += PGSIZE){
 80000108cb5:	49 81 c5 00 10 00 00 	add    $0x1000,%r13
 80000108cbc:	e9 46 ff ff ff       	jmp    80000108c07 <copyuvm+0x38>
      panic("copyuvm: pte should exist");
 80000108cc1:	48 bf 76 ae 10 00 00 	movabs $0x8000010ae76,%rdi
 80000108cc8:	08 00 00 
 80000108ccb:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000108cd2:	08 00 00 
 80000108cd5:	ff d0                	call   *%rax
      panic("copyuvm: page not present");
 80000108cd7:	48 bf 90 ae 10 00 00 	movabs $0x8000010ae90,%rdi
 80000108cde:	08 00 00 
 80000108ce1:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000108ce8:	08 00 00 
 80000108ceb:	ff d0                	call   *%rax
      kfree(mem);
 80000108ced:	4c 89 e7             	mov    %r12,%rdi
 80000108cf0:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 80000108cf7:	08 00 00 
 80000108cfa:	ff d0                	call   *%rax
    }
  }
  return d;

bad:
  freevm(d);
 80000108cfc:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
 80000108d00:	48 b8 76 8a 10 00 00 	movabs $0x80000108a76,%rax
 80000108d07:	08 00 00 
 80000108d0a:	ff d0                	call   *%rax
  return 0;
 80000108d0c:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
 80000108d13:	00 
}
 80000108d14:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
 80000108d18:	48 83 c4 28          	add    $0x28,%rsp
 80000108d1c:	5b                   	pop    %rbx
 80000108d1d:	41 5c                	pop    %r12
 80000108d1f:	41 5d                	pop    %r13
 80000108d21:	41 5e                	pop    %r14
 80000108d23:	41 5f                	pop    %r15
 80000108d25:	5d                   	pop    %rbp
 80000108d26:	c3                   	ret

0000080000108d27 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pml4e_t *pml4, char *uva)
{
 80000108d27:	55                   	push   %rbp
 80000108d28:	48 89 e5             	mov    %rsp,%rbp
  pte_t *pte;

  pte = walkpml4(pml4, uva, 0, 0);
 80000108d2b:	b9 00 00 00 00       	mov    $0x0,%ecx
 80000108d30:	ba 00 00 00 00       	mov    $0x0,%edx
 80000108d35:	48 b8 52 80 10 00 00 	movabs $0x80000108052,%rax
 80000108d3c:	08 00 00 
 80000108d3f:	ff d0                	call   *%rax
  if((*pte & PTE_P) == 0)
 80000108d41:	48 8b 00             	mov    (%rax),%rax
 80000108d44:	a8 01                	test   $0x1,%al
 80000108d46:	74 19                	je     80000108d61 <uva2ka+0x3a>
    return 0;
  if((*pte & PTE_U) == 0)
 80000108d48:	a8 04                	test   $0x4,%al
 80000108d4a:	74 1c                	je     80000108d68 <uva2ka+0x41>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
 80000108d4c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
 80000108d52:	48 ba 00 00 00 00 00 	movabs $0x80000000000,%rdx
 80000108d59:	08 00 00 
 80000108d5c:	48 01 d0             	add    %rdx,%rax
}
 80000108d5f:	5d                   	pop    %rbp
 80000108d60:	c3                   	ret
    return 0;
 80000108d61:	b8 00 00 00 00       	mov    $0x0,%eax
 80000108d66:	eb f7                	jmp    80000108d5f <uva2ka+0x38>
    return 0;
 80000108d68:	b8 00 00 00 00       	mov    $0x0,%eax
 80000108d6d:	eb f0                	jmp    80000108d5f <uva2ka+0x38>

0000080000108d6f <copyout>:
// Copy len bytes from p to user address va in page table pml4.
// Most useful when pml4 is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pml4e_t *pml4, uint va, void *p, uint len)
{
 80000108d6f:	55                   	push   %rbp
 80000108d70:	48 89 e5             	mov    %rsp,%rbp
 80000108d73:	41 57                	push   %r15
 80000108d75:	41 56                	push   %r14
 80000108d77:	41 55                	push   %r13
 80000108d79:	41 54                	push   %r12
 80000108d7b:	53                   	push   %rbx
 80000108d7c:	48 83 ec 18          	sub    $0x18,%rsp
 80000108d80:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
 80000108d84:	89 f3                	mov    %esi,%ebx
 80000108d86:	49 89 d6             	mov    %rdx,%r14
 80000108d89:	41 89 cc             	mov    %ecx,%r12d
  char *buf, *pa0;
  uint64 n, va0;

  buf = (char*)p;
  while(len > 0){
 80000108d8c:	eb 25                	jmp    80000108db3 <copyout+0x44>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
 80000108d8e:	4c 29 ea             	sub    %r13,%rdx
 80000108d91:	48 8d 3c 10          	lea    (%rax,%rdx,1),%rdi
 80000108d95:	89 da                	mov    %ebx,%edx
 80000108d97:	4c 89 f6             	mov    %r14,%rsi
 80000108d9a:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 80000108da1:	08 00 00 
 80000108da4:	ff d0                	call   *%rax
    len -= n;
 80000108da6:	41 29 dc             	sub    %ebx,%r12d
    buf += n;
 80000108da9:	49 01 de             	add    %rbx,%r14
    va = va0 + PGSIZE;
 80000108dac:	41 8d 9f 00 10 00 00 	lea    0x1000(%r15),%ebx
  while(len > 0){
 80000108db3:	45 85 e4             	test   %r12d,%r12d
 80000108db6:	74 41                	je     80000108df9 <copyout+0x8a>
    va0 = (uint64)PGROUNDDOWN(va);
 80000108db8:	41 89 df             	mov    %ebx,%r15d
 80000108dbb:	41 81 e7 00 f0 ff ff 	and    $0xfffff000,%r15d
 80000108dc2:	45 89 fd             	mov    %r15d,%r13d
    pa0 = uva2ka(pml4, (char*)va0);
 80000108dc5:	4c 89 ee             	mov    %r13,%rsi
 80000108dc8:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
 80000108dcc:	48 b8 27 8d 10 00 00 	movabs $0x80000108d27,%rax
 80000108dd3:	08 00 00 
 80000108dd6:	ff d0                	call   *%rax
    if(pa0 == 0)
 80000108dd8:	48 85 c0             	test   %rax,%rax
 80000108ddb:	74 30                	je     80000108e0d <copyout+0x9e>
    n = PGSIZE - (va - va0);
 80000108ddd:	89 da                	mov    %ebx,%edx
 80000108ddf:	4c 89 e9             	mov    %r13,%rcx
 80000108de2:	48 29 d1             	sub    %rdx,%rcx
 80000108de5:	48 81 c1 00 10 00 00 	add    $0x1000,%rcx
    if(n > len)
 80000108dec:	44 89 e3             	mov    %r12d,%ebx
 80000108def:	48 39 cb             	cmp    %rcx,%rbx
 80000108df2:	72 9a                	jb     80000108d8e <copyout+0x1f>
    n = PGSIZE - (va - va0);
 80000108df4:	48 89 cb             	mov    %rcx,%rbx
 80000108df7:	eb 95                	jmp    80000108d8e <copyout+0x1f>
  }
  return 0;
 80000108df9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000108dfe:	48 83 c4 18          	add    $0x18,%rsp
 80000108e02:	5b                   	pop    %rbx
 80000108e03:	41 5c                	pop    %r12
 80000108e05:	41 5d                	pop    %r13
 80000108e07:	41 5e                	pop    %r14
 80000108e09:	41 5f                	pop    %r15
 80000108e0b:	5d                   	pop    %rbp
 80000108e0c:	c3                   	ret
      return -1;
 80000108e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80000108e12:	eb ea                	jmp    80000108dfe <copyout+0x8f>
 80000108e14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 80000108e1b:	00 00 00 
 80000108e1e:	66 90                	xchg   %ax,%ax

0000080000108e20 <scan_rdsp>:
extern int ncpu;
extern uchar ioapicid;

static struct acpi_rdsp *
scan_rdsp(uint64 base, uint len)
{
 80000108e20:	55                   	push   %rbp
 80000108e21:	48 89 e5             	mov    %rsp,%rbp
 80000108e24:	41 54                	push   %r12
 80000108e26:	53                   	push   %rbx
 80000108e27:	41 89 f4             	mov    %esi,%r12d
  uchar *p;
  for (p = P2V(base); len >= sizeof(struct acpi_rdsp); len -= 4, p += 4) {
 80000108e2a:	48 b8 00 00 00 00 00 	movabs $0x80000000000,%rax
 80000108e31:	08 00 00 
 80000108e34:	48 8d 1c 07          	lea    (%rdi,%rax,1),%rbx
 80000108e38:	eb 23                	jmp    80000108e5d <scan_rdsp+0x3d>
 80000108e3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    if (memcmp(p, SIG_RDSP, 8) == 0) {
      uint sum, n;
      for (sum = 0, n = 0; n < 20; n++)
        sum += p[n];
 80000108e40:	89 c1                	mov    %eax,%ecx
 80000108e42:	0f b6 0c 0b          	movzbl (%rbx,%rcx,1),%ecx
 80000108e46:	01 ca                	add    %ecx,%edx
      for (sum = 0, n = 0; n < 20; n++)
 80000108e48:	83 c0 01             	add    $0x1,%eax
 80000108e4b:	83 f8 13             	cmp    $0x13,%eax
 80000108e4e:	76 f0                	jbe    80000108e40 <scan_rdsp+0x20>
      if ((sum & 0xff) == 0)
 80000108e50:	f6 c2 ff             	test   $0xff,%dl
 80000108e53:	74 41                	je     80000108e96 <scan_rdsp+0x76>
  for (p = P2V(base); len >= sizeof(struct acpi_rdsp); len -= 4, p += 4) {
 80000108e55:	41 83 ec 04          	sub    $0x4,%r12d
 80000108e59:	48 83 c3 04          	add    $0x4,%rbx
 80000108e5d:	41 83 fc 23          	cmp    $0x23,%r12d
 80000108e61:	76 2e                	jbe    80000108e91 <scan_rdsp+0x71>
    if (memcmp(p, SIG_RDSP, 8) == 0) {
 80000108e63:	ba 08 00 00 00       	mov    $0x8,%edx
 80000108e68:	48 be aa ae 10 00 00 	movabs $0x8000010aeaa,%rsi
 80000108e6f:	08 00 00 
 80000108e72:	48 89 df             	mov    %rbx,%rdi
 80000108e75:	48 b8 3b 56 10 00 00 	movabs $0x8000010563b,%rax
 80000108e7c:	08 00 00 
 80000108e7f:	ff d0                	call   *%rax
 80000108e81:	85 c0                	test   %eax,%eax
 80000108e83:	75 d0                	jne    80000108e55 <scan_rdsp+0x35>
      for (sum = 0, n = 0; n < 20; n++)
 80000108e85:	b8 00 00 00 00       	mov    $0x0,%eax
 80000108e8a:	ba 00 00 00 00       	mov    $0x0,%edx
 80000108e8f:	eb ba                	jmp    80000108e4b <scan_rdsp+0x2b>
        return (struct acpi_rdsp *) p;
    }
  }
  return (struct acpi_rdsp *) 0;  
 80000108e91:	bb 00 00 00 00       	mov    $0x0,%ebx
}
 80000108e96:	48 89 d8             	mov    %rbx,%rax
 80000108e99:	5b                   	pop    %rbx
 80000108e9a:	41 5c                	pop    %r12
 80000108e9c:	5d                   	pop    %rbp
 80000108e9d:	c3                   	ret

0000080000108e9e <find_rdsp>:

static struct acpi_rdsp *
find_rdsp(void)
{
 80000108e9e:	55                   	push   %rbp
 80000108e9f:	48 89 e5             	mov    %rsp,%rbp
  struct acpi_rdsp *rdsp;
  uint64 pa;
  pa = *((ushort*) P2V(0x40E)) << 4; // EBDA
 80000108ea2:	48 b8 0e 04 00 00 00 	movabs $0x8000000040e,%rax
 80000108ea9:	08 00 00 
 80000108eac:	0f b7 38             	movzwl (%rax),%edi
 80000108eaf:	c1 e7 04             	shl    $0x4,%edi
 80000108eb2:	48 63 ff             	movslq %edi,%rdi
  if (pa && (rdsp = scan_rdsp(pa, 1024)))
 80000108eb5:	48 85 ff             	test   %rdi,%rdi
 80000108eb8:	74 16                	je     80000108ed0 <find_rdsp+0x32>
 80000108eba:	be 00 04 00 00       	mov    $0x400,%esi
 80000108ebf:	48 b8 20 8e 10 00 00 	movabs $0x80000108e20,%rax
 80000108ec6:	08 00 00 
 80000108ec9:	ff d0                	call   *%rax
 80000108ecb:	48 85 c0             	test   %rax,%rax
 80000108ece:	75 16                	jne    80000108ee6 <find_rdsp+0x48>
    return rdsp;
  return scan_rdsp(0xE0000, 0x20000);
 80000108ed0:	be 00 00 02 00       	mov    $0x20000,%esi
 80000108ed5:	bf 00 00 0e 00       	mov    $0xe0000,%edi
 80000108eda:	48 b8 20 8e 10 00 00 	movabs $0x80000108e20,%rax
 80000108ee1:	08 00 00 
 80000108ee4:	ff d0                	call   *%rax
} 
 80000108ee6:	5d                   	pop    %rbp
 80000108ee7:	c3                   	ret

0000080000108ee8 <acpi_config_smp>:
acpi_config_smp(struct acpi_madt *madt) {
  uint32 lapic_addr;
  uint nioapic = 0;
  uchar *p, *e;

  if (!madt)
 80000108ee8:	48 85 ff             	test   %rdi,%rdi
 80000108eeb:	0f 84 1a 01 00 00    	je     8000010900b <acpi_config_smp+0x123>
    return 0;
  if (madt->header.length < sizeof(struct acpi_madt))
 80000108ef1:	8b 47 04             	mov    0x4(%rdi),%eax
 80000108ef4:	83 f8 2b             	cmp    $0x2b,%eax
 80000108ef7:	0f 86 14 01 00 00    	jbe    80000109011 <acpi_config_smp+0x129>
acpi_config_smp(struct acpi_madt *madt) {
 80000108efd:	55                   	push   %rbp
 80000108efe:	48 89 e5             	mov    %rsp,%rbp
 80000108f01:	41 57                	push   %r15
 80000108f03:	41 56                	push   %r14
 80000108f05:	41 55                	push   %r13
 80000108f07:	41 54                	push   %r12
 80000108f09:	53                   	push   %rbx
 80000108f0a:	48 83 ec 08          	sub    $0x8,%rsp
    return 0;

  lapic_addr = madt->lapic_addr_phys;
 80000108f0e:	44 8b 7f 24          	mov    0x24(%rdi),%r15d

  p = madt->table;
 80000108f12:	48 8d 5f 2c          	lea    0x2c(%rdi),%rbx
  e = p + madt->header.length - sizeof(struct acpi_madt);
 80000108f16:	89 c0                	mov    %eax,%eax
 80000108f18:	4c 8d 2c 07          	lea    (%rdi,%rax,1),%r13
  uint nioapic = 0;
 80000108f1c:	41 be 00 00 00 00    	mov    $0x0,%r14d

  while (p < e) {
 80000108f22:	eb 5e                	jmp    80000108f82 <acpi_config_smp+0x9a>
    if ((e - p) < len)
      break;
    switch (p[0]) {
    case TYPE_LAPIC: {
      struct madt_lapic *lapic = (void*) p;
      if (len < sizeof(*lapic))
 80000108f24:	83 f9 07             	cmp    $0x7,%ecx
 80000108f27:	76 52                	jbe    80000108f7b <acpi_config_smp+0x93>
        break;
      if (!(lapic->flags & APIC_LAPIC_ENABLED))
 80000108f29:	f6 43 04 01          	testb  $0x1,0x4(%rbx)
 80000108f2d:	74 4c                	je     80000108f7b <acpi_config_smp+0x93>
        break;
      cpus[ncpu].apicid = lapic->apic_id;
 80000108f2f:	48 ba 04 a0 11 00 00 	movabs $0x8000011a004,%rdx
 80000108f36:	08 00 00 
 80000108f39:	8b 02                	mov    (%rdx),%eax
 80000108f3b:	40 8a 7b 03          	mov    0x3(%rbx),%dil
 80000108f3f:	48 63 c8             	movslq %eax,%rcx
 80000108f42:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
 80000108f46:	48 8d 34 89          	lea    (%rcx,%rcx,4),%rsi
 80000108f4a:	48 b9 20 a0 11 00 00 	movabs $0x8000011a020,%rcx
 80000108f51:	08 00 00 
 80000108f54:	40 88 3c f1          	mov    %dil,(%rcx,%rsi,8)
      ncpu++;
 80000108f58:	83 c0 01             	add    $0x1,%eax
 80000108f5b:	89 02                	mov    %eax,(%rdx)
      break;
 80000108f5d:	eb 1c                	jmp    80000108f7b <acpi_config_smp+0x93>
    case TYPE_IOAPIC: {
      struct madt_ioapic *ioapic = (void*) p;
      if (len < sizeof(*ioapic))
        break;
      if (nioapic) {
        cprintf("warning: multiple ioapics are not supported");
 80000108f5f:	48 bf d0 b0 10 00 00 	movabs $0x8000010b0d0,%rdi
 80000108f66:	08 00 00 
 80000108f69:	b0 00                	mov    $0x0,%al
 80000108f6b:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000108f72:	08 00 00 
 80000108f75:	ff d2                	call   *%rdx
      } else {
        ioapicid = ioapic->id;
      }
      nioapic++;
 80000108f77:	41 83 c6 01          	add    $0x1,%r14d
      break;
    }
    }
    p += len;
 80000108f7b:	45 0f b6 e4          	movzbl %r12b,%r12d
 80000108f7f:	4c 01 e3             	add    %r12,%rbx
  while (p < e) {
 80000108f82:	4c 39 eb             	cmp    %r13,%rbx
 80000108f85:	73 47                	jae    80000108fce <acpi_config_smp+0xe6>
    if ((e - p) < 2)
 80000108f87:	4c 89 e8             	mov    %r13,%rax
 80000108f8a:	48 29 d8             	sub    %rbx,%rax
 80000108f8d:	48 83 f8 01          	cmp    $0x1,%rax
 80000108f91:	7e 3b                	jle    80000108fce <acpi_config_smp+0xe6>
    len = p[1];
 80000108f93:	44 8a 63 01          	mov    0x1(%rbx),%r12b
 80000108f97:	41 0f b6 cc          	movzbl %r12b,%ecx
    if ((e - p) < len)
 80000108f9b:	41 0f b6 d4          	movzbl %r12b,%edx
 80000108f9f:	48 39 d0             	cmp    %rdx,%rax
 80000108fa2:	7c 2a                	jl     80000108fce <acpi_config_smp+0xe6>
    switch (p[0]) {
 80000108fa4:	8a 03                	mov    (%rbx),%al
 80000108fa6:	0f b6 d0             	movzbl %al,%edx
 80000108fa9:	85 d2                	test   %edx,%edx
 80000108fab:	0f 84 73 ff ff ff    	je     80000108f24 <acpi_config_smp+0x3c>
 80000108fb1:	83 fa 01             	cmp    $0x1,%edx
 80000108fb4:	75 c5                	jne    80000108f7b <acpi_config_smp+0x93>
      if (len < sizeof(*ioapic))
 80000108fb6:	83 f9 0b             	cmp    $0xb,%ecx
 80000108fb9:	76 c0                	jbe    80000108f7b <acpi_config_smp+0x93>
      if (nioapic) {
 80000108fbb:	45 85 f6             	test   %r14d,%r14d
 80000108fbe:	75 9f                	jne    80000108f5f <acpi_config_smp+0x77>
        ioapicid = ioapic->id;
 80000108fc0:	8a 43 02             	mov    0x2(%rbx),%al
 80000108fc3:	a2 00 a0 11 00 00 08 	movabs %al,0x8000011a000
 80000108fca:	00 00 
 80000108fcc:	eb a9                	jmp    80000108f77 <acpi_config_smp+0x8f>
  }

  if (ncpu) {
 80000108fce:	a1 04 a0 11 00 00 08 	movabs 0x8000011a004,%eax
 80000108fd5:	00 00 
 80000108fd7:	85 c0                	test   %eax,%eax
 80000108fd9:	75 0f                	jne    80000108fea <acpi_config_smp+0x102>
    lapic = DEV_P2V(((uint64)lapic_addr));
    return 1;
  }

  return 0;
}
 80000108fdb:	48 83 c4 08          	add    $0x8,%rsp
 80000108fdf:	5b                   	pop    %rbx
 80000108fe0:	41 5c                	pop    %r12
 80000108fe2:	41 5d                	pop    %r13
 80000108fe4:	41 5e                	pop    %r14
 80000108fe6:	41 5f                	pop    %r15
 80000108fe8:	5d                   	pop    %rbp
 80000108fe9:	c3                   	ret
    lapic = DEV_P2V(((uint64)lapic_addr));
 80000108fea:	44 89 f8             	mov    %r15d,%eax
 80000108fed:	48 ba 00 00 00 00 ff 	movabs $0xffffffff00000000,%rdx
 80000108ff4:	ff ff ff 
 80000108ff7:	48 01 d0             	add    %rdx,%rax
 80000108ffa:	48 a3 e0 9e 11 00 00 	movabs %rax,0x80000119ee0
 80000109001:	08 00 00 
    return 1;
 80000109004:	b8 01 00 00 00       	mov    $0x1,%eax
 80000109009:	eb d0                	jmp    80000108fdb <acpi_config_smp+0xf3>
    return 0;
 8000010900b:	b8 00 00 00 00       	mov    $0x0,%eax
 80000109010:	c3                   	ret
    return 0;
 80000109011:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000109016:	c3                   	ret

0000080000109017 <acpiinit>:

// Return a boolean indicating the success of MP initialization 
// using ACPI tables
int
acpiinit(void)
{
 80000109017:	55                   	push   %rbp
 80000109018:	48 89 e5             	mov    %rsp,%rbp
 8000010901b:	41 57                	push   %r15
 8000010901d:	41 56                	push   %r14
 8000010901f:	41 55                	push   %r13
 80000109021:	41 54                	push   %r12
 80000109023:	53                   	push   %rbx
 80000109024:	48 83 ec 08          	sub    $0x8,%rsp
  unsigned n, count;
  struct acpi_rdsp *rdsp;
  struct acpi_rsdt *rsdt;
  struct acpi_madt *madt = 0;

  rdsp = find_rdsp();
 80000109028:	48 b8 9e 8e 10 00 00 	movabs $0x80000108e9e,%rax
 8000010902f:	08 00 00 
 80000109032:	ff d0                	call   *%rax
  if (!rdsp)
 80000109034:	48 85 c0             	test   %rax,%rax
 80000109037:	0f 84 92 00 00 00    	je     800001090cf <acpiinit+0xb8>
    return 0;
  rsdt = acpitable((uint64)rdsp->rsdt_addr_phys);
 8000010903d:	8b 78 10             	mov    0x10(%rax),%edi
 80000109040:	48 b8 d5 83 10 00 00 	movabs $0x800001083d5,%rax
 80000109047:	08 00 00 
 8000010904a:	ff d0                	call   *%rax
 8000010904c:	49 89 c6             	mov    %rax,%r14
  if (!rsdt)
 8000010904f:	48 85 c0             	test   %rax,%rax
 80000109052:	0f 84 8b 00 00 00    	je     800001090e3 <acpiinit+0xcc>
    return 0;
  count = (rsdt->header.length - sizeof(*rsdt)) / 4;
 80000109058:	44 8b 68 04          	mov    0x4(%rax),%r13d
 8000010905c:	49 83 ed 24          	sub    $0x24,%r13
 80000109060:	49 c1 ed 02          	shr    $0x2,%r13
  struct acpi_madt *madt = 0;
 80000109064:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  for (n = 0; n < count; n++) {
 8000010906a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 80000109070:	eb 04                	jmp    80000109076 <acpiinit+0x5f>
 80000109072:	41 83 c4 01          	add    $0x1,%r12d
 80000109076:	45 39 ec             	cmp    %r13d,%r12d
 80000109079:	73 43                	jae    800001090be <acpiinit+0xa7>
    struct acpi_desc_header *hdr = acpitable((uint64)rsdt->entry[n]);
 8000010907b:	44 89 e0             	mov    %r12d,%eax
 8000010907e:	41 8b 7c 86 24       	mov    0x24(%r14,%rax,4),%edi
 80000109083:	48 b8 d5 83 10 00 00 	movabs $0x800001083d5,%rax
 8000010908a:	08 00 00 
 8000010908d:	ff d0                	call   *%rax
 8000010908f:	48 89 c3             	mov    %rax,%rbx
    if (!hdr)
 80000109092:	48 85 c0             	test   %rax,%rax
 80000109095:	74 53                	je     800001090ea <acpiinit+0xd3>
      return 0;
    if (!memcmp(hdr->signature, SIG_MADT, 4))
 80000109097:	ba 04 00 00 00       	mov    $0x4,%edx
 8000010909c:	48 be b3 ae 10 00 00 	movabs $0x8000010aeb3,%rsi
 800001090a3:	08 00 00 
 800001090a6:	48 89 c7             	mov    %rax,%rdi
 800001090a9:	48 b8 3b 56 10 00 00 	movabs $0x8000010563b,%rax
 800001090b0:	08 00 00 
 800001090b3:	ff d0                	call   *%rax
 800001090b5:	85 c0                	test   %eax,%eax
 800001090b7:	75 b9                	jne    80000109072 <acpiinit+0x5b>
      madt = (void*) hdr;
 800001090b9:	49 89 df             	mov    %rbx,%r15
 800001090bc:	eb b4                	jmp    80000109072 <acpiinit+0x5b>
  }

  return acpi_config_smp(madt);
 800001090be:	4c 89 ff             	mov    %r15,%rdi
 800001090c1:	48 b8 e8 8e 10 00 00 	movabs $0x80000108ee8,%rax
 800001090c8:	08 00 00 
 800001090cb:	ff d0                	call   *%rax
 800001090cd:	eb 05                	jmp    800001090d4 <acpiinit+0xbd>
    return 0;
 800001090cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 800001090d4:	48 83 c4 08          	add    $0x8,%rsp
 800001090d8:	5b                   	pop    %rbx
 800001090d9:	41 5c                	pop    %r12
 800001090db:	41 5d                	pop    %r13
 800001090dd:	41 5e                	pop    %r14
 800001090df:	41 5f                	pop    %r15
 800001090e1:	5d                   	pop    %rbp
 800001090e2:	c3                   	ret
    return 0;
 800001090e3:	b8 00 00 00 00       	mov    $0x0,%eax
 800001090e8:	eb ea                	jmp    800001090d4 <acpiinit+0xbd>
      return 0;
 800001090ea:	b8 00 00 00 00       	mov    $0x0,%eax
 800001090ef:	eb e3                	jmp    800001090d4 <acpiinit+0xbd>
 800001090f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 800001090f8:	00 00 00 
 800001090fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000080000109100 <iomask>:

/* Mask for the low `size` bytes (1, 2 or 4) of an I/O access. */
static uint64
iomask(int size)
{
  return size == 1 ? 0xFF : size == 2 ? 0xFFFF : 0xFFFFFFFF;
 80000109100:	83 ff 01             	cmp    $0x1,%edi
 80000109103:	74 11                	je     80000109116 <iomask+0x16>
 80000109105:	83 ff 02             	cmp    $0x2,%edi
 80000109108:	74 06                	je     80000109110 <iomask+0x10>
 8000010910a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 8000010910f:	c3                   	ret
  return size == 1 ? 0xFF : size == 2 ? 0xFFFF : 0xFFFFFFFF;
 80000109110:	b8 ff ff 00 00       	mov    $0xffff,%eax
 80000109115:	c3                   	ret
 80000109116:	b8 ff 00 00 00       	mov    $0xff,%eax
 8000010911b:	c3                   	ret

000008000010911c <vmxmsr>:
vmxmsr(struct vm *vm, int write)
{
  /* HW1 part 5: write this function; see HW1.md. */
  uint64 val;

  if ((uint)vm->regs.rcx != EFER_MSR)
 8000010911c:	81 7f 40 80 00 00 c0 	cmpl   $0xc0000080,0x40(%rdi)
 80000109123:	75 4a                	jne    8000010916f <vmxmsr+0x53>
    return -1;
  
  if (write) {
 80000109125:	85 f6                	test   %esi,%esi
 80000109127:	74 2e                	je     80000109157 <vmxmsr+0x3b>
    val = (vm->regs.rdx << 32) | (uint)vm->regs.rax;
 80000109129:	48 8b 57 48          	mov    0x48(%rdi),%rdx
 8000010912d:	48 c1 e2 20          	shl    $0x20,%rdx
 80000109131:	8b 47 30             	mov    0x30(%rdi),%eax
 80000109134:	48 09 d0             	or     %rdx,%rax
    vm->efer = (val & ~(uint64)EFER_LMA) | (vm->efer & EFER_LMA);
 80000109137:	80 e4 fb             	and    $0xfb,%ah
 8000010913a:	48 8b 97 c0 00 00 00 	mov    0xc0(%rdi),%rdx
 80000109141:	81 e2 00 04 00 00    	and    $0x400,%edx
 80000109147:	48 09 d0             	or     %rdx,%rax
 8000010914a:	48 89 87 c0 00 00 00 	mov    %rax,0xc0(%rdi)
  } else {
    vm->regs.rax = (uint)vm->efer;
    vm->regs.rdx = vm->efer >> 32;
  }
  return 0;
 80000109151:	b8 00 00 00 00       	mov    $0x0,%eax
 80000109156:	c3                   	ret
    vm->regs.rax = (uint)vm->efer;
 80000109157:	48 8b 87 c0 00 00 00 	mov    0xc0(%rdi),%rax
 8000010915e:	89 c2                	mov    %eax,%edx
 80000109160:	48 89 57 30          	mov    %rdx,0x30(%rdi)
    vm->regs.rdx = vm->efer >> 32;
 80000109164:	48 c1 e8 20          	shr    $0x20,%rax
 80000109168:	48 89 47 48          	mov    %rax,0x48(%rdi)
  return 0;
 8000010916c:	89 f0                	mov    %esi,%eax
 8000010916e:	c3                   	ret
    return -1;
 8000010916f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 80000109174:	c3                   	ret

0000080000109175 <vmxhandle>:
 * used to skip the instruction.  Basic exit reasons are in SDM
 * Appendix C.
 */
static int
vmxhandle(struct vm *vm, struct vmexit *e, uint inslen)
{
 80000109175:	55                   	push   %rbp
 80000109176:	48 89 e5             	mov    %rsp,%rbp
 80000109179:	41 55                	push   %r13
 8000010917b:	41 54                	push   %r12
 8000010917d:	53                   	push   %rbx
 8000010917e:	48 83 ec 08          	sub    $0x8,%rsp
  /* HW1 part 5: write this function; see HW1.md. */
  // cprintf("exit %d rip %x\n", (uint64)e->reason, e->rip);
  switch (e->reason){
 80000109182:	8b 06                	mov    (%rsi),%eax
 80000109184:	83 f8 20             	cmp    $0x20,%eax
 80000109187:	0f 87 d9 00 00 00    	ja     80000109266 <vmxhandle+0xf1>
 8000010918d:	49 89 fd             	mov    %rdi,%r13
 80000109190:	48 89 f3             	mov    %rsi,%rbx
 80000109193:	41 89 d4             	mov    %edx,%r12d
 80000109196:	89 c2                	mov    %eax,%edx
 80000109198:	48 b9 70 b6 10 00 00 	movabs $0x8000010b670,%rcx
 8000010919f:	08 00 00 
 800001091a2:	ff 24 d1             	jmp    *(%rcx,%rdx,8)
 800001091a5:	b8 01 00 00 00       	mov    $0x1,%eax
 800001091aa:	e9 bc 00 00 00       	jmp    8000010926b <vmxhandle+0xf6>
    case EXIT_EXTERNAL_INTR:
      return 1;
    case EXIT_EXCEPTION_NMI:
      if (INTR_INFO_TYPE(e->intrinfo) == INTR_TYPE_NMI)
 800001091af:	8b 46 1c             	mov    0x1c(%rsi),%eax
 800001091b2:	25 00 07 00 00       	and    $0x700,%eax
 800001091b7:	3d 00 02 00 00       	cmp    $0x200,%eax
 800001091bc:	0f 84 b4 00 00 00    	je     80000109276 <vmxhandle+0x101>
        return 1;
      return 0;
 800001091c2:	b8 00 00 00 00       	mov    $0x0,%eax
 800001091c7:	e9 9f 00 00 00       	jmp    8000010926b <vmxhandle+0xf6>
    case EXIT_RDMSR:
    case EXIT_WRMSR:
      if (vmxmsr(vm, e->reason == EXIT_WRMSR) < 0)
 800001091cc:	40 0f 94 c6          	sete   %sil
 800001091d0:	40 0f b6 f6          	movzbl %sil,%esi
 800001091d4:	48 b8 1c 91 10 00 00 	movabs $0x8000010911c,%rax
 800001091db:	08 00 00 
 800001091de:	ff d0                	call   *%rax
 800001091e0:	85 c0                	test   %eax,%eax
 800001091e2:	0f 88 95 00 00 00    	js     8000010927d <vmxhandle+0x108>
        return 0;
      vm->rip += inslen;
 800001091e8:	45 89 e4             	mov    %r12d,%r12d
 800001091eb:	4d 01 a5 a8 00 00 00 	add    %r12,0xa8(%r13)
      return 1;
 800001091f2:	b8 01 00 00 00       	mov    $0x1,%eax
 800001091f7:	eb 72                	jmp    8000010926b <vmxhandle+0xf6>
    case EXIT_HLT:
      vm->rip += inslen;
 800001091f9:	45 89 e4             	mov    %r12d,%r12d
 800001091fc:	4c 01 a7 a8 00 00 00 	add    %r12,0xa8(%rdi)
      return 0;
 80000109203:	b8 00 00 00 00       	mov    $0x0,%eax
 80000109208:	eb 61                	jmp    8000010926b <vmxhandle+0xf6>
    case EXIT_IO:
      if(e->qual & (1 << 4))
 8000010920a:	48 8b 46 08          	mov    0x8(%rsi),%rax
 8000010920e:	a8 10                	test   $0x10,%al
 80000109210:	75 72                	jne    80000109284 <vmxhandle+0x10f>
        return 0;
      e->io.port = e->qual >> 16;
 80000109212:	48 89 c2             	mov    %rax,%rdx
 80000109215:	48 c1 ea 10          	shr    $0x10,%rdx
 80000109219:	66 89 56 30          	mov    %dx,0x30(%rsi)
      e->io.size = (e->qual & 7) + 1;
 8000010921d:	89 c2                	mov    %eax,%edx
 8000010921f:	83 e2 07             	and    $0x7,%edx
 80000109222:	83 c2 01             	add    $0x1,%edx
 80000109225:	88 56 32             	mov    %dl,0x32(%rsi)
      e->io.in = (e->qual >> 3) & 1;
 80000109228:	48 c1 e8 03          	shr    $0x3,%rax
 8000010922c:	83 e0 01             	and    $0x1,%eax
 8000010922f:	88 46 33             	mov    %al,0x33(%rsi)
      vm->rip += inslen;
 80000109232:	45 89 e4             	mov    %r12d,%r12d
 80000109235:	4c 01 a7 a8 00 00 00 	add    %r12,0xa8(%rdi)
      if(!e->io.in)
 8000010923c:	0f b6 46 33          	movzbl 0x33(%rsi),%eax
 80000109240:	85 c0                	test   %eax,%eax
 80000109242:	75 47                	jne    8000010928b <vmxhandle+0x116>
        e->io.data = vm->regs.rax & iomask(e->io.size);
 80000109244:	4c 8b 67 30          	mov    0x30(%rdi),%r12
 80000109248:	0f b6 7e 32          	movzbl 0x32(%rsi),%edi
 8000010924c:	48 b8 00 91 10 00 00 	movabs $0x80000109100,%rax
 80000109253:	08 00 00 
 80000109256:	ff d0                	call   *%rax
 80000109258:	41 21 c4             	and    %eax,%r12d
 8000010925b:	44 89 63 34          	mov    %r12d,0x34(%rbx)
      return 0;
 8000010925f:	b8 00 00 00 00       	mov    $0x0,%eax
 80000109264:	eb 05                	jmp    8000010926b <vmxhandle+0xf6>
  }
  return 0;
 80000109266:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8000010926b:	48 83 c4 08          	add    $0x8,%rsp
 8000010926f:	5b                   	pop    %rbx
 80000109270:	41 5c                	pop    %r12
 80000109272:	41 5d                	pop    %r13
 80000109274:	5d                   	pop    %rbp
 80000109275:	c3                   	ret
        return 1;
 80000109276:	b8 01 00 00 00       	mov    $0x1,%eax
 8000010927b:	eb ee                	jmp    8000010926b <vmxhandle+0xf6>
        return 0;
 8000010927d:	b8 00 00 00 00       	mov    $0x0,%eax
 80000109282:	eb e7                	jmp    8000010926b <vmxhandle+0xf6>
        return 0;
 80000109284:	b8 00 00 00 00       	mov    $0x0,%eax
 80000109289:	eb e0                	jmp    8000010926b <vmxhandle+0xf6>
      return 0;
 8000010928b:	b8 00 00 00 00       	mov    $0x0,%eax
 80000109290:	eb d9                	jmp    8000010926b <vmxhandle+0xf6>

0000080000109292 <adjustctl>:
{
 80000109292:	89 f9                	mov    %edi,%ecx
 80000109294:	48 89 d7             	mov    %rdx,%rdi
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 80000109297:	0f 32                	rdmsr
  uint v = (want | (uint) cap) & (uint) (cap >> 32);
 80000109299:	09 f0                	or     %esi,%eax
 8000010929b:	21 c2                	and    %eax,%edx
  if ((v & want) != want) {
 8000010929d:	89 d0                	mov    %edx,%eax
 8000010929f:	f7 d0                	not    %eax
 800001092a1:	85 f0                	test   %esi,%eax
 800001092a3:	75 08                	jne    800001092ad <adjustctl+0x1b>
  *ctl = v;
 800001092a5:	89 17                	mov    %edx,(%rdi)
  return 0;
 800001092a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 800001092ac:	c3                   	ret
{
 800001092ad:	55                   	push   %rbp
 800001092ae:	48 89 e5             	mov    %rsp,%rbp
    cprintf("vmx: controls 0x%x unsupported (MSR 0x%x)\n",
 800001092b1:	89 c9                	mov    %ecx,%ecx
 800001092b3:	21 c6                	and    %eax,%esi
 800001092b5:	48 89 ca             	mov    %rcx,%rdx
 800001092b8:	48 bf 00 b1 10 00 00 	movabs $0x8000010b100,%rdi
 800001092bf:	08 00 00 
 800001092c2:	b0 00                	mov    $0x0,%al
 800001092c4:	48 b9 f9 08 10 00 00 	movabs $0x800001008f9,%rcx
 800001092cb:	08 00 00 
 800001092ce:	ff d1                	call   *%rcx
    return -1;
 800001092d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 800001092d5:	5d                   	pop    %rbp
 800001092d6:	c3                   	ret

00000800001092d7 <eptwalk>:
{
 800001092d7:	55                   	push   %rbp
 800001092d8:	48 89 e5             	mov    %rsp,%rbp
 800001092db:	41 57                	push   %r15
 800001092dd:	41 56                	push   %r14
 800001092df:	41 55                	push   %r13
 800001092e1:	41 54                	push   %r12
 800001092e3:	53                   	push   %rbx
 800001092e4:	48 83 ec 08          	sub    $0x8,%rsp
 800001092e8:	48 89 fb             	mov    %rdi,%rbx
 800001092eb:	49 89 f5             	mov    %rsi,%r13
 800001092ee:	41 89 d6             	mov    %edx,%r14d
  for (level = 3; level > 0; level--) {
 800001092f1:	41 bc 03 00 00 00    	mov    $0x3,%r12d
 800001092f7:	eb 4e                	jmp    80000109347 <eptwalk+0x70>
      if (!alloc || (next = kalloc()) == 0)
 800001092f9:	45 85 f6             	test   %r14d,%r14d
 800001092fc:	0f 84 82 00 00 00    	je     80000109384 <eptwalk+0xad>
 80000109302:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000109309:	08 00 00 
 8000010930c:	ff d0                	call   *%rax
 8000010930e:	48 89 c3             	mov    %rax,%rbx
 80000109311:	48 85 c0             	test   %rax,%rax
 80000109314:	74 6e                	je     80000109384 <eptwalk+0xad>
      memset(next, 0, PGSIZE);
 80000109316:	ba 00 10 00 00       	mov    $0x1000,%edx
 8000010931b:	be 00 00 00 00       	mov    $0x0,%esi
 80000109320:	48 89 c7             	mov    %rax,%rdi
 80000109323:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 8000010932a:	08 00 00 
 8000010932d:	ff d0                	call   *%rax
      *e = V2P(next) | EPT_RWX;
 8000010932f:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 80000109336:	f8 ff ff 
 80000109339:	48 01 d8             	add    %rbx,%rax
 8000010933c:	48 83 c8 07          	or     $0x7,%rax
 80000109340:	49 89 07             	mov    %rax,(%r15)
  for (level = 3; level > 0; level--) {
 80000109343:	41 83 ec 01          	sub    $0x1,%r12d
 80000109347:	45 85 e4             	test   %r12d,%r12d
 8000010934a:	7e 3f                	jle    8000010938b <eptwalk+0xb4>
    e = &table[(gpa >> (12 + 9 * level)) & 0x1FF];
 8000010934c:	43 8d 4c e4 0c       	lea    0xc(%r12,%r12,8),%ecx
 80000109351:	4c 89 e8             	mov    %r13,%rax
 80000109354:	48 d3 e8             	shr    %cl,%rax
 80000109357:	25 ff 01 00 00       	and    $0x1ff,%eax
 8000010935c:	4c 8d 3c c3          	lea    (%rbx,%rax,8),%r15
    if (*e & EPT_RWX) {
 80000109360:	49 8b 1f             	mov    (%r15),%rbx
 80000109363:	f6 c3 07             	test   $0x7,%bl
 80000109366:	74 91                	je     800001092f9 <eptwalk+0x22>
      table = (uint64 *) P2V(EPT_ADDR(*e));
 80000109368:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
 8000010936f:	ff 0f 00 
 80000109372:	48 21 c3             	and    %rax,%rbx
 80000109375:	48 b8 00 00 00 00 00 	movabs $0x80000000000,%rax
 8000010937c:	08 00 00 
 8000010937f:	48 01 c3             	add    %rax,%rbx
 80000109382:	eb bf                	jmp    80000109343 <eptwalk+0x6c>
        return 0;
 80000109384:	b8 00 00 00 00       	mov    $0x0,%eax
 80000109389:	eb 0f                	jmp    8000010939a <eptwalk+0xc3>
  return &table[(gpa >> 12) & 0x1FF];
 8000010938b:	49 c1 ed 0c          	shr    $0xc,%r13
 8000010938f:	41 81 e5 ff 01 00 00 	and    $0x1ff,%r13d
 80000109396:	4a 8d 04 eb          	lea    (%rbx,%r13,8),%rax
}
 8000010939a:	48 83 c4 08          	add    $0x8,%rsp
 8000010939e:	5b                   	pop    %rbx
 8000010939f:	41 5c                	pop    %r12
 800001093a1:	41 5d                	pop    %r13
 800001093a3:	41 5e                	pop    %r14
 800001093a5:	41 5f                	pop    %r15
 800001093a7:	5d                   	pop    %rbp
 800001093a8:	c3                   	ret

00000800001093a9 <getvm>:
  if(id < 0 || id >= NVM || !vms.vm[id].used || vms.vm[id].owner != myproc())
 800001093a9:	83 ff 03             	cmp    $0x3,%edi
 800001093ac:	0f 87 84 00 00 00    	ja     80000109436 <getvm+0x8d>
{
 800001093b2:	55                   	push   %rbp
 800001093b3:	48 89 e5             	mov    %rsp,%rbp
 800001093b6:	41 54                	push   %r12
 800001093b8:	53                   	push   %rbx
 800001093b9:	89 fb                	mov    %edi,%ebx
  if(id < 0 || id >= NVM || !vms.vm[id].used || vms.vm[id].owner != myproc())
 800001093bb:	48 63 c7             	movslq %edi,%rax
 800001093be:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 800001093c2:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 800001093c6:	48 c1 e0 04          	shl    $0x4,%rax
 800001093ca:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 800001093d1:	08 00 00 
 800001093d4:	83 7c 02 68 00       	cmpl   $0x0,0x68(%rdx,%rax,1)
 800001093d9:	74 51                	je     8000010942c <getvm+0x83>
 800001093db:	48 63 c7             	movslq %edi,%rax
 800001093de:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 800001093e2:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 800001093e6:	48 c1 e0 04          	shl    $0x4,%rax
 800001093ea:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 800001093f1:	08 00 00 
 800001093f4:	4c 8b 64 02 70       	mov    0x70(%rdx,%rax,1),%r12
 800001093f9:	b0 00                	mov    $0x0,%al
 800001093fb:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000109402:	08 00 00 
 80000109405:	ff d2                	call   *%rdx
 80000109407:	49 39 c4             	cmp    %rax,%r12
 8000010940a:	75 20                	jne    8000010942c <getvm+0x83>
  return &vms.vm[id];
 8000010940c:	48 63 db             	movslq %ebx,%rbx
 8000010940f:	48 8d 04 5b          	lea    (%rbx,%rbx,2),%rax
 80000109413:	48 8d 04 83          	lea    (%rbx,%rax,4),%rax
 80000109417:	48 c1 e0 04          	shl    $0x4,%rax
 8000010941b:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 80000109422:	08 00 00 
 80000109425:	48 8d 44 02 68       	lea    0x68(%rdx,%rax,1),%rax
 8000010942a:	eb 05                	jmp    80000109431 <getvm+0x88>
    return 0;
 8000010942c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80000109431:	5b                   	pop    %rbx
 80000109432:	41 5c                	pop    %r12
 80000109434:	5d                   	pop    %rbp
 80000109435:	c3                   	ret
    return 0;
 80000109436:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8000010943b:	c3                   	ret

000008000010943c <vmwrite>:
  asm volatile("vmwrite %2, %1; setna %0" : "=q" (fail) : "r" (field), "r" (val) : "cc");
 8000010943c:	0f 79 fe             	vmwrite %rsi,%rdi
 8000010943f:	0f 96 c0             	setbe  %al
  if(fail){
 80000109442:	0f b6 c0             	movzbl %al,%eax
 80000109445:	85 c0                	test   %eax,%eax
 80000109447:	75 01                	jne    8000010944a <vmwrite+0xe>
 80000109449:	c3                   	ret
{
 8000010944a:	55                   	push   %rbp
 8000010944b:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010944e:	b9 00 44 00 00       	mov    $0x4400,%ecx
 80000109453:	0f 78 c9             	vmread %rcx,%rcx
    cprintf("vmwrite 0x%x = 0x%x: error %d\n", field, val,
 80000109456:	48 89 f2             	mov    %rsi,%rdx
 80000109459:	48 89 fe             	mov    %rdi,%rsi
 8000010945c:	48 bf 30 b1 10 00 00 	movabs $0x8000010b130,%rdi
 80000109463:	08 00 00 
 80000109466:	b0 00                	mov    $0x0,%al
 80000109468:	49 b8 f9 08 10 00 00 	movabs $0x800001008f9,%r8
 8000010946f:	08 00 00 
 80000109472:	41 ff d0             	call   *%r8
    panic("vmwrite");
 80000109475:	48 bf b8 ae 10 00 00 	movabs $0x8000010aeb8,%rdi
 8000010947c:	08 00 00 
 8000010947f:	48 b8 57 05 10 00 00 	movabs $0x80000100557,%rax
 80000109486:	08 00 00 
 80000109489:	ff d0                	call   *%rax

000008000010948b <guestseg>:
{
 8000010948b:	55                   	push   %rbp
 8000010948c:	48 89 e5             	mov    %rsp,%rbp
 8000010948f:	41 57                	push   %r15
 80000109491:	41 56                	push   %r14
 80000109493:	41 55                	push   %r13
 80000109495:	41 54                	push   %r12
 80000109497:	53                   	push   %rbx
 80000109498:	48 83 ec 08          	sub    $0x8,%rsp
 8000010949c:	89 fb                	mov    %edi,%ebx
 8000010949e:	49 89 d7             	mov    %rdx,%r15
 800001094a1:	41 89 cd             	mov    %ecx,%r13d
 800001094a4:	45 89 c4             	mov    %r8d,%r12d
  vmwrite(GUEST_ES_SELECTOR + 2*seg, sel);
 800001094a7:	8d bc 3f 00 08 00 00 	lea    0x800(%rdi,%rdi,1),%edi
 800001094ae:	89 f6                	mov    %esi,%esi
 800001094b0:	48 63 ff             	movslq %edi,%rdi
 800001094b3:	49 be 3c 94 10 00 00 	movabs $0x8000010943c,%r14
 800001094ba:	08 00 00 
 800001094bd:	41 ff d6             	call   *%r14
  vmwrite(GUEST_ES_BASE + 2*seg, base);
 800001094c0:	8d bc 1b 06 68 00 00 	lea    0x6806(%rbx,%rbx,1),%edi
 800001094c7:	48 63 ff             	movslq %edi,%rdi
 800001094ca:	4c 89 fe             	mov    %r15,%rsi
 800001094cd:	41 ff d6             	call   *%r14
  vmwrite(GUEST_ES_LIMIT + 2*seg, limit);
 800001094d0:	8d bc 1b 00 48 00 00 	lea    0x4800(%rbx,%rbx,1),%edi
 800001094d7:	44 89 ee             	mov    %r13d,%esi
 800001094da:	48 63 ff             	movslq %edi,%rdi
 800001094dd:	41 ff d6             	call   *%r14
  vmwrite(GUEST_ES_AR_BYTES + 2*seg, ar);
 800001094e0:	8d bc 1b 14 48 00 00 	lea    0x4814(%rbx,%rbx,1),%edi
 800001094e7:	44 89 e6             	mov    %r12d,%esi
 800001094ea:	48 63 ff             	movslq %edi,%rdi
 800001094ed:	41 ff d6             	call   *%r14
}
 800001094f0:	48 83 c4 08          	add    $0x8,%rsp
 800001094f4:	5b                   	pop    %rbx
 800001094f5:	41 5c                	pop    %r12
 800001094f7:	41 5d                	pop    %r13
 800001094f9:	41 5e                	pop    %r14
 800001094fb:	41 5f                	pop    %r15
 800001094fd:	5d                   	pop    %rbp
 800001094fe:	c3                   	ret

00000800001094ff <vmcsinit>:
{
 800001094ff:	55                   	push   %rbp
 80000109500:	48 89 e5             	mov    %rsp,%rbp
 80000109503:	41 54                	push   %r12
 80000109505:	53                   	push   %rbx
 80000109506:	48 83 ec 20          	sub    $0x20,%rsp
 8000010950a:	49 89 fc             	mov    %rdi,%r12
 8000010950d:	b9 80 04 00 00       	mov    $0x480,%ecx
 80000109512:	0f 32                	rdmsr
  return ((uint64)hi << 32) | lo;
 80000109514:	48 c1 e2 20          	shl    $0x20,%rdx
 80000109518:	89 c3                	mov    %eax,%ebx
 8000010951a:	48 09 d3             	or     %rdx,%rbx
  int t = (rdmsr(MSR_IA32_VMX_BASIC) & VMX_BASIC_TRUE_CTLS) != 0;
 8000010951d:	48 b8 00 00 00 00 00 	movabs $0x80000000000000,%rax
 80000109524:	00 80 00 
  if (adjustctl(t ? MSR_IA32_VMX_TRUE_PINBASED_CTLS : MSR_IA32_VMX_PINBASED_CTLS,
 80000109527:	48 21 c3             	and    %rax,%rbx
 8000010952a:	0f 84 71 02 00 00    	je     800001097a1 <vmcsinit+0x2a2>
 80000109530:	bf 8d 04 00 00       	mov    $0x48d,%edi
 80000109535:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
 80000109539:	be 09 00 00 00       	mov    $0x9,%esi
 8000010953e:	48 b8 92 92 10 00 00 	movabs $0x80000109292,%rax
 80000109545:	08 00 00 
 80000109548:	ff d0                	call   *%rax
 8000010954a:	85 c0                	test   %eax,%eax
 8000010954c:	0f 88 77 02 00 00    	js     800001097c9 <vmcsinit+0x2ca>
      adjustctl(t ? MSR_IA32_VMX_TRUE_PROCBASED_CTLS : MSR_IA32_VMX_PROCBASED_CTLS,
 80000109552:	48 85 db             	test   %rbx,%rbx
 80000109555:	0f 84 50 02 00 00    	je     800001097ab <vmcsinit+0x2ac>
 8000010955b:	bf 8e 04 00 00       	mov    $0x48e,%edi
 80000109560:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
 80000109564:	be 80 00 00 81       	mov    $0x81000080,%esi
 80000109569:	48 b8 92 92 10 00 00 	movabs $0x80000109292,%rax
 80000109570:	08 00 00 
 80000109573:	ff d0                	call   *%rax
                PIN_EXTINT_EXITING | PIN_NMI_EXITING, &pin) < 0 ||
 80000109575:	85 c0                	test   %eax,%eax
 80000109577:	0f 88 4c 02 00 00    	js     800001097c9 <vmcsinit+0x2ca>
      adjustctl(MSR_IA32_VMX_PROCBASED_CTLS2,
 8000010957d:	48 8d 55 e4          	lea    -0x1c(%rbp),%rdx
 80000109581:	be 82 00 00 00       	mov    $0x82,%esi
 80000109586:	bf 8b 04 00 00       	mov    $0x48b,%edi
 8000010958b:	48 b8 92 92 10 00 00 	movabs $0x80000109292,%rax
 80000109592:	08 00 00 
 80000109595:	ff d0                	call   *%rax
                &cpu) < 0 ||
 80000109597:	85 c0                	test   %eax,%eax
 80000109599:	0f 88 2a 02 00 00    	js     800001097c9 <vmcsinit+0x2ca>
      adjustctl(t ? MSR_IA32_VMX_TRUE_EXIT_CTLS : MSR_IA32_VMX_EXIT_CTLS,
 8000010959f:	48 85 db             	test   %rbx,%rbx
 800001095a2:	0f 84 0d 02 00 00    	je     800001097b5 <vmcsinit+0x2b6>
 800001095a8:	bf 8f 04 00 00       	mov    $0x48f,%edi
 800001095ad:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
 800001095b1:	be 00 02 30 00       	mov    $0x300200,%esi
 800001095b6:	48 b8 92 92 10 00 00 	movabs $0x80000109292,%rax
 800001095bd:	08 00 00 
 800001095c0:	ff d0                	call   *%rax
                CPU2_ENABLE_EPT | CPU2_UNRESTRICTED_GUEST, &cpu2) < 0 ||
 800001095c2:	85 c0                	test   %eax,%eax
 800001095c4:	0f 88 ff 01 00 00    	js     800001097c9 <vmcsinit+0x2ca>
      adjustctl(t ? MSR_IA32_VMX_TRUE_ENTRY_CTLS : MSR_IA32_VMX_ENTRY_CTLS,
 800001095ca:	48 85 db             	test   %rbx,%rbx
 800001095cd:	0f 84 ec 01 00 00    	je     800001097bf <vmcsinit+0x2c0>
 800001095d3:	bf 90 04 00 00       	mov    $0x490,%edi
 800001095d8:	48 8d 55 dc          	lea    -0x24(%rbp),%rdx
 800001095dc:	be 00 80 00 00       	mov    $0x8000,%esi
 800001095e1:	48 b8 92 92 10 00 00 	movabs $0x80000109292,%rax
 800001095e8:	08 00 00 
 800001095eb:	ff d0                	call   *%rax
                EXIT_LOAD_IA32_EFER, &exitctl) < 0 ||
 800001095ed:	85 c0                	test   %eax,%eax
 800001095ef:	0f 88 d4 01 00 00    	js     800001097c9 <vmcsinit+0x2ca>
  if (cpu & (CPU_CR3_LOAD_EXITING | CPU_CR3_STORE_EXITING |
 800001095f5:	8b 45 e8             	mov    -0x18(%rbp),%eax
 800001095f8:	a9 00 80 01 12       	test   $0x12018000,%eax
 800001095fd:	0f 85 d0 01 00 00    	jne    800001097d3 <vmcsinit+0x2d4>
  vmwrite(PIN_BASED_VM_EXEC_CONTROL, pin);
 80000109603:	8b 75 ec             	mov    -0x14(%rbp),%esi
 80000109606:	bf 00 40 00 00       	mov    $0x4000,%edi
 8000010960b:	48 bb 3c 94 10 00 00 	movabs $0x8000010943c,%rbx
 80000109612:	08 00 00 
 80000109615:	ff d3                	call   *%rbx
  vmwrite(CPU_BASED_VM_EXEC_CONTROL, cpu);
 80000109617:	8b 75 e8             	mov    -0x18(%rbp),%esi
 8000010961a:	bf 02 40 00 00       	mov    $0x4002,%edi
 8000010961f:	ff d3                	call   *%rbx
  vmwrite(SECONDARY_VM_EXEC_CONTROL, cpu2);
 80000109621:	8b 75 e4             	mov    -0x1c(%rbp),%esi
 80000109624:	bf 1e 40 00 00       	mov    $0x401e,%edi
 80000109629:	ff d3                	call   *%rbx
  vmwrite(VM_EXIT_CONTROLS, exitctl);
 8000010962b:	8b 75 e0             	mov    -0x20(%rbp),%esi
 8000010962e:	bf 0c 40 00 00       	mov    $0x400c,%edi
 80000109633:	ff d3                	call   *%rbx
  vmwrite(VM_ENTRY_CONTROLS, entryctl);
 80000109635:	8b 75 dc             	mov    -0x24(%rbp),%esi
 80000109638:	bf 12 40 00 00       	mov    $0x4012,%edi
 8000010963d:	ff d3                	call   *%rbx
  vmwrite(EXCEPTION_BITMAP, 0xFFFFFFFF);
 8000010963f:	be ff ff ff ff       	mov    $0xffffffff,%esi
 80000109644:	bf 04 40 00 00       	mov    $0x4004,%edi
 80000109649:	ff d3                	call   *%rbx
  vmwrite(PAGE_FAULT_ERROR_CODE_MASK, 0);
 8000010964b:	be 00 00 00 00       	mov    $0x0,%esi
 80000109650:	bf 06 40 00 00       	mov    $0x4006,%edi
 80000109655:	ff d3                	call   *%rbx
  vmwrite(PAGE_FAULT_ERROR_CODE_MATCH, 0);
 80000109657:	be 00 00 00 00       	mov    $0x0,%esi
 8000010965c:	bf 08 40 00 00       	mov    $0x4008,%edi
 80000109661:	ff d3                	call   *%rbx
  vmwrite(CR3_TARGET_COUNT, 0);
 80000109663:	be 00 00 00 00       	mov    $0x0,%esi
 80000109668:	bf 0a 40 00 00       	mov    $0x400a,%edi
 8000010966d:	ff d3                	call   *%rbx
  vmwrite(VM_EXIT_MSR_STORE_COUNT, 0);
 8000010966f:	be 00 00 00 00       	mov    $0x0,%esi
 80000109674:	bf 0e 40 00 00       	mov    $0x400e,%edi
 80000109679:	ff d3                	call   *%rbx
  vmwrite(VM_EXIT_MSR_LOAD_COUNT, 0);
 8000010967b:	be 00 00 00 00       	mov    $0x0,%esi
 80000109680:	bf 10 40 00 00       	mov    $0x4010,%edi
 80000109685:	ff d3                	call   *%rbx
  vmwrite(VM_ENTRY_MSR_LOAD_COUNT, 0);
 80000109687:	be 00 00 00 00       	mov    $0x0,%esi
 8000010968c:	bf 14 40 00 00       	mov    $0x4014,%edi
 80000109691:	ff d3                	call   *%rbx
  vmwrite(VM_ENTRY_INTR_INFO_FIELD, 0);
 80000109693:	be 00 00 00 00       	mov    $0x0,%esi
 80000109698:	bf 16 40 00 00       	mov    $0x4016,%edi
 8000010969d:	ff d3                	call   *%rbx
  vmwrite(EPT_POINTER, vm->eptp);
 8000010969f:	49 8b 74 24 20       	mov    0x20(%r12),%rsi
 800001096a4:	bf 1a 20 00 00       	mov    $0x201a,%edi
 800001096a9:	ff d3                	call   *%rbx
  vmwrite(CR0_GUEST_HOST_MASK, 0);
 800001096ab:	be 00 00 00 00       	mov    $0x0,%esi
 800001096b0:	bf 00 60 00 00       	mov    $0x6000,%edi
 800001096b5:	ff d3                	call   *%rbx
  vmwrite(CR0_READ_SHADOW, 0);
 800001096b7:	be 00 00 00 00       	mov    $0x0,%esi
 800001096bc:	bf 04 60 00 00       	mov    $0x6004,%edi
 800001096c1:	ff d3                	call   *%rbx
  vmwrite(CR4_GUEST_HOST_MASK, 0);
 800001096c3:	be 00 00 00 00       	mov    $0x0,%esi
 800001096c8:	bf 02 60 00 00       	mov    $0x6002,%edi
 800001096cd:	ff d3                	call   *%rbx
  vmwrite(CR4_READ_SHADOW, 0);
 800001096cf:	be 00 00 00 00       	mov    $0x0,%esi
 800001096d4:	bf 06 60 00 00       	mov    $0x6006,%edi
 800001096d9:	ff d3                	call   *%rbx
  vmwrite(HOST_RIP, (uint64)vmx_exit);
 800001096db:	48 be 69 a7 10 00 00 	movabs $0x8000010a769,%rsi
 800001096e2:	08 00 00 
 800001096e5:	bf 16 6c 00 00       	mov    $0x6c16,%edi
 800001096ea:	ff d3                	call   *%rbx
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 800001096ec:	b9 86 04 00 00       	mov    $0x486,%ecx
 800001096f1:	0f 32                	rdmsr
  return ((uint64)hi << 32) | lo;
 800001096f3:	48 c1 e2 20          	shl    $0x20,%rdx
 800001096f7:	89 c6                	mov    %eax,%esi
 800001096f9:	48 09 d6             	or     %rdx,%rsi
  cr0 |= rdmsr(MSR_IA32_VMX_CR0_FIXED0) & ~(uint64)(CR0_PE | CR0_PG);
 800001096fc:	48 b8 fe ff ff 7f ff 	movabs $0xffffffff7ffffffe,%rax
 80000109703:	ff ff ff 
 80000109706:	48 21 c6             	and    %rax,%rsi
 80000109709:	48 83 ce 31          	or     $0x31,%rsi
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 8000010970d:	b9 87 04 00 00       	mov    $0x487,%ecx
 80000109712:	0f 32                	rdmsr
  return ((uint64)hi << 32) | lo;
 80000109714:	48 c1 e2 20          	shl    $0x20,%rdx
 80000109718:	89 c0                	mov    %eax,%eax
 8000010971a:	48 09 d0             	or     %rdx,%rax
  cr0 &= rdmsr(MSR_IA32_VMX_CR0_FIXED1);
 8000010971d:	48 21 c6             	and    %rax,%rsi
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 80000109720:	b9 88 04 00 00       	mov    $0x488,%ecx
 80000109725:	0f 32                	rdmsr
  return ((uint64)hi << 32) | lo;
 80000109727:	48 c1 e2 20          	shl    $0x20,%rdx
 8000010972b:	41 89 c4             	mov    %eax,%r12d
 8000010972e:	49 09 d4             	or     %rdx,%r12
  cr4 = CR4_VMXE | rdmsr(MSR_IA32_VMX_CR4_FIXED0);
 80000109731:	49 81 cc 00 20 00 00 	or     $0x2000,%r12
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 80000109738:	b9 89 04 00 00       	mov    $0x489,%ecx
 8000010973d:	0f 32                	rdmsr
  return ((uint64)hi << 32) | lo;
 8000010973f:	48 c1 e2 20          	shl    $0x20,%rdx
 80000109743:	89 c0                	mov    %eax,%eax
 80000109745:	48 09 d0             	or     %rdx,%rax
  cr4 &= rdmsr(MSR_IA32_VMX_CR4_FIXED1);
 80000109748:	49 21 c4             	and    %rax,%r12
  vmwrite(GUEST_CR0, cr0);
 8000010974b:	bf 00 68 00 00       	mov    $0x6800,%edi
 80000109750:	ff d3                	call   *%rbx
  vmwrite(GUEST_CR3, 0);
 80000109752:	be 00 00 00 00       	mov    $0x0,%esi
 80000109757:	bf 02 68 00 00       	mov    $0x6802,%edi
 8000010975c:	ff d3                	call   *%rbx
  vmwrite(GUEST_CR4, cr4);
 8000010975e:	4c 89 e6             	mov    %r12,%rsi
 80000109761:	bf 04 68 00 00       	mov    $0x6804,%edi
 80000109766:	ff d3                	call   *%rbx
  vmwrite(GUEST_DR7, 0x400);
 80000109768:	be 00 04 00 00       	mov    $0x400,%esi
 8000010976d:	bf 1a 68 00 00       	mov    $0x681a,%edi
 80000109772:	ff d3                	call   *%rbx
  guestseg(SEG_CS, 0x08, 0, 0xFFFFFFFF, AR_CODE32);
 80000109774:	41 b8 9b c0 00 00    	mov    $0xc09b,%r8d
 8000010977a:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8000010977f:	ba 00 00 00 00       	mov    $0x0,%edx
 80000109784:	be 08 00 00 00       	mov    $0x8,%esi
 80000109789:	bf 01 00 00 00       	mov    $0x1,%edi
 8000010978e:	48 b8 8b 94 10 00 00 	movabs $0x8000010948b,%rax
 80000109795:	08 00 00 
 80000109798:	ff d0                	call   *%rax
  for (seg = SEG_ES; seg <= SEG_GS; seg++)
 8000010979a:	bb 00 00 00 00       	mov    $0x0,%ebx
 8000010979f:	eb 7c                	jmp    8000010981d <vmcsinit+0x31e>
  if (adjustctl(t ? MSR_IA32_VMX_TRUE_PINBASED_CTLS : MSR_IA32_VMX_PINBASED_CTLS,
 800001097a1:	bf 81 04 00 00       	mov    $0x481,%edi
 800001097a6:	e9 8a fd ff ff       	jmp    80000109535 <vmcsinit+0x36>
      adjustctl(t ? MSR_IA32_VMX_TRUE_PROCBASED_CTLS : MSR_IA32_VMX_PROCBASED_CTLS,
 800001097ab:	bf 82 04 00 00       	mov    $0x482,%edi
 800001097b0:	e9 ab fd ff ff       	jmp    80000109560 <vmcsinit+0x61>
      adjustctl(t ? MSR_IA32_VMX_TRUE_EXIT_CTLS : MSR_IA32_VMX_EXIT_CTLS,
 800001097b5:	bf 83 04 00 00       	mov    $0x483,%edi
 800001097ba:	e9 ee fd ff ff       	jmp    800001095ad <vmcsinit+0xae>
      adjustctl(t ? MSR_IA32_VMX_TRUE_ENTRY_CTLS : MSR_IA32_VMX_ENTRY_CTLS,
 800001097bf:	bf 84 04 00 00       	mov    $0x484,%edi
 800001097c4:	e9 0f fe ff ff       	jmp    800001095d8 <vmcsinit+0xd9>
    return -1;
 800001097c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 800001097ce:	e9 39 01 00 00       	jmp    8000010990c <vmcsinit+0x40d>
        cprintf("vmx: CPU forces unwanted exiting controls 0x%x\n", (uint64)cpu);
 800001097d3:	89 c6                	mov    %eax,%esi
 800001097d5:	48 bf 50 b1 10 00 00 	movabs $0x8000010b150,%rdi
 800001097dc:	08 00 00 
 800001097df:	b0 00                	mov    $0x0,%al
 800001097e1:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 800001097e8:	08 00 00 
 800001097eb:	ff d2                	call   *%rdx
        return -1;
 800001097ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 800001097f2:	e9 15 01 00 00       	jmp    8000010990c <vmcsinit+0x40d>
      guestseg(seg, 0x10, 0, 0xFFFFFFFF, AR_DATA32);
 800001097f7:	41 b8 93 c0 00 00    	mov    $0xc093,%r8d
 800001097fd:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 80000109802:	ba 00 00 00 00       	mov    $0x0,%edx
 80000109807:	be 10 00 00 00       	mov    $0x10,%esi
 8000010980c:	89 df                	mov    %ebx,%edi
 8000010980e:	48 b8 8b 94 10 00 00 	movabs $0x8000010948b,%rax
 80000109815:	08 00 00 
 80000109818:	ff d0                	call   *%rax
  for (seg = SEG_ES; seg <= SEG_GS; seg++)
 8000010981a:	83 c3 01             	add    $0x1,%ebx
 8000010981d:	83 fb 05             	cmp    $0x5,%ebx
 80000109820:	7f 07                	jg     80000109829 <vmcsinit+0x32a>
    if (seg != SEG_CS)
 80000109822:	83 fb 01             	cmp    $0x1,%ebx
 80000109825:	75 d0                	jne    800001097f7 <vmcsinit+0x2f8>
 80000109827:	eb f1                	jmp    8000010981a <vmcsinit+0x31b>
  guestseg(SEG_LDTR, 0, 0, 0, AR_UNUSABLE);
 80000109829:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
 8000010982f:	b9 00 00 00 00       	mov    $0x0,%ecx
 80000109834:	ba 00 00 00 00       	mov    $0x0,%edx
 80000109839:	be 00 00 00 00       	mov    $0x0,%esi
 8000010983e:	bf 06 00 00 00       	mov    $0x6,%edi
 80000109843:	48 bb 8b 94 10 00 00 	movabs $0x8000010948b,%rbx
 8000010984a:	08 00 00 
 8000010984d:	ff d3                	call   *%rbx
  guestseg(SEG_TR, 0, 0, 0, AR_TSS32_BUSY);
 8000010984f:	41 b8 8b 00 00 00    	mov    $0x8b,%r8d
 80000109855:	b9 00 00 00 00       	mov    $0x0,%ecx
 8000010985a:	ba 00 00 00 00       	mov    $0x0,%edx
 8000010985f:	be 00 00 00 00       	mov    $0x0,%esi
 80000109864:	bf 07 00 00 00       	mov    $0x7,%edi
 80000109869:	ff d3                	call   *%rbx
  vmwrite(GUEST_GDTR_BASE, 0);
 8000010986b:	be 00 00 00 00       	mov    $0x0,%esi
 80000109870:	bf 16 68 00 00       	mov    $0x6816,%edi
 80000109875:	48 bb 3c 94 10 00 00 	movabs $0x8000010943c,%rbx
 8000010987c:	08 00 00 
 8000010987f:	ff d3                	call   *%rbx
  vmwrite(GUEST_GDTR_LIMIT, 0);
 80000109881:	be 00 00 00 00       	mov    $0x0,%esi
 80000109886:	bf 10 48 00 00       	mov    $0x4810,%edi
 8000010988b:	ff d3                	call   *%rbx
  vmwrite(GUEST_IDTR_BASE, 0);
 8000010988d:	be 00 00 00 00       	mov    $0x0,%esi
 80000109892:	bf 18 68 00 00       	mov    $0x6818,%edi
 80000109897:	ff d3                	call   *%rbx
  vmwrite(GUEST_IDTR_LIMIT, 0);
 80000109899:	be 00 00 00 00       	mov    $0x0,%esi
 8000010989e:	bf 12 48 00 00       	mov    $0x4812,%edi
 800001098a3:	ff d3                	call   *%rbx
  vmwrite(GUEST_INTERRUPTIBILITY_INFO, 0);
 800001098a5:	be 00 00 00 00       	mov    $0x0,%esi
 800001098aa:	bf 24 48 00 00       	mov    $0x4824,%edi
 800001098af:	ff d3                	call   *%rbx
  vmwrite(GUEST_ACTIVITY_STATE, 0);
 800001098b1:	be 00 00 00 00       	mov    $0x0,%esi
 800001098b6:	bf 26 48 00 00       	mov    $0x4826,%edi
 800001098bb:	ff d3                	call   *%rbx
  vmwrite(GUEST_PENDING_DBG_EXCEPTIONS, 0);
 800001098bd:	be 00 00 00 00       	mov    $0x0,%esi
 800001098c2:	bf 22 68 00 00       	mov    $0x6822,%edi
 800001098c7:	ff d3                	call   *%rbx
  vmwrite(VMCS_LINK_POINTER, ~0ULL);
 800001098c9:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
 800001098d0:	bf 00 28 00 00       	mov    $0x2800,%edi
 800001098d5:	ff d3                	call   *%rbx
  vmwrite(GUEST_IA32_DEBUGCTL, 0);
 800001098d7:	be 00 00 00 00       	mov    $0x0,%esi
 800001098dc:	bf 02 28 00 00       	mov    $0x2802,%edi
 800001098e1:	ff d3                	call   *%rbx
  vmwrite(GUEST_SYSENTER_CS, 0);
 800001098e3:	be 00 00 00 00       	mov    $0x0,%esi
 800001098e8:	bf 2a 48 00 00       	mov    $0x482a,%edi
 800001098ed:	ff d3                	call   *%rbx
  vmwrite(GUEST_SYSENTER_ESP, 0);
 800001098ef:	be 00 00 00 00       	mov    $0x0,%esi
 800001098f4:	bf 24 68 00 00       	mov    $0x6824,%edi
 800001098f9:	ff d3                	call   *%rbx
  vmwrite(GUEST_SYSENTER_EIP, 0);
 800001098fb:	be 00 00 00 00       	mov    $0x0,%esi
 80000109900:	bf 26 68 00 00       	mov    $0x6826,%edi
 80000109905:	ff d3                	call   *%rbx
  return 0;
 80000109907:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8000010990c:	48 83 c4 20          	add    $0x20,%rsp
 80000109910:	5b                   	pop    %rbx
 80000109911:	41 5c                	pop    %r12
 80000109913:	5d                   	pop    %rbp
 80000109914:	c3                   	ret

0000080000109915 <vmxhoststate>:
{
 80000109915:	55                   	push   %rbp
 80000109916:	48 89 e5             	mov    %rsp,%rbp
 80000109919:	41 54                	push   %r12
 8000010991b:	53                   	push   %rbx
  struct cpu *c = mycpu();
 8000010991c:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000109923:	08 00 00 
 80000109926:	ff d0                	call   *%rax
 80000109928:	49 89 c4             	mov    %rax,%r12
  asm volatile("movq %%cr0,%0" : "=r" (val));
 8000010992b:	0f 20 c6             	mov    %cr0,%rsi
  vmwrite(HOST_CR0, rcr0());
 8000010992e:	bf 00 6c 00 00       	mov    $0x6c00,%edi
 80000109933:	48 bb 3c 94 10 00 00 	movabs $0x8000010943c,%rbx
 8000010993a:	08 00 00 
 8000010993d:	ff d3                	call   *%rbx
  asm volatile("movq %%cr3,%0" : "=r" (val));
 8000010993f:	0f 20 de             	mov    %cr3,%rsi
  vmwrite(HOST_CR3, rcr3());
 80000109942:	bf 02 6c 00 00       	mov    $0x6c02,%edi
 80000109947:	ff d3                	call   *%rbx
  asm volatile("movq %%cr4,%0" : "=r" (val));
 80000109949:	0f 20 e6             	mov    %cr4,%rsi
  vmwrite(HOST_CR4, rcr4());
 8000010994c:	bf 04 6c 00 00       	mov    $0x6c04,%edi
 80000109951:	ff d3                	call   *%rbx
  vmwrite(HOST_CS_SELECTOR, SEG_KCODE << 3);
 80000109953:	be 08 00 00 00       	mov    $0x8,%esi
 80000109958:	bf 02 0c 00 00       	mov    $0xc02,%edi
 8000010995d:	ff d3                	call   *%rbx
  vmwrite(HOST_SS_SELECTOR, 0);
 8000010995f:	be 00 00 00 00       	mov    $0x0,%esi
 80000109964:	bf 04 0c 00 00       	mov    $0xc04,%edi
 80000109969:	ff d3                	call   *%rbx
  vmwrite(HOST_DS_SELECTOR, 0);
 8000010996b:	be 00 00 00 00       	mov    $0x0,%esi
 80000109970:	bf 06 0c 00 00       	mov    $0xc06,%edi
 80000109975:	ff d3                	call   *%rbx
  vmwrite(HOST_ES_SELECTOR, 0);
 80000109977:	be 00 00 00 00       	mov    $0x0,%esi
 8000010997c:	bf 00 0c 00 00       	mov    $0xc00,%edi
 80000109981:	ff d3                	call   *%rbx
  vmwrite(HOST_FS_SELECTOR, 0);
 80000109983:	be 00 00 00 00       	mov    $0x0,%esi
 80000109988:	bf 08 0c 00 00       	mov    $0xc08,%edi
 8000010998d:	ff d3                	call   *%rbx
  vmwrite(HOST_GS_SELECTOR, 0);
 8000010998f:	be 00 00 00 00       	mov    $0x0,%esi
 80000109994:	bf 0a 0c 00 00       	mov    $0xc0a,%edi
 80000109999:	ff d3                	call   *%rbx
  vmwrite(HOST_TR_SELECTOR, SEG_TSS << 3);
 8000010999b:	be 28 00 00 00       	mov    $0x28,%esi
 800001099a0:	bf 0c 0c 00 00       	mov    $0xc0c,%edi
 800001099a5:	ff d3                	call   *%rbx
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 800001099a7:	b9 00 01 00 c0       	mov    $0xc0000100,%ecx
 800001099ac:	0f 32                	rdmsr
  return ((uint64)hi << 32) | lo;
 800001099ae:	48 c1 e2 20          	shl    $0x20,%rdx
 800001099b2:	89 c6                	mov    %eax,%esi
 800001099b4:	48 09 d6             	or     %rdx,%rsi
  vmwrite(HOST_FS_BASE, rdmsr(MSR_IA32_FS_BASE));
 800001099b7:	bf 06 6c 00 00       	mov    $0x6c06,%edi
 800001099bc:	ff d3                	call   *%rbx
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 800001099be:	b9 01 01 00 c0       	mov    $0xc0000101,%ecx
 800001099c3:	0f 32                	rdmsr
  return ((uint64)hi << 32) | lo;
 800001099c5:	48 c1 e2 20          	shl    $0x20,%rdx
 800001099c9:	89 c6                	mov    %eax,%esi
 800001099cb:	48 09 d6             	or     %rdx,%rsi
  vmwrite(HOST_GS_BASE, rdmsr(MSR_IA32_GS_BASE));
 800001099ce:	bf 08 6c 00 00       	mov    $0x6c08,%edi
 800001099d3:	ff d3                	call   *%rbx
  vmwrite(HOST_TR_BASE, (uint64)&c->ts);
 800001099d5:	49 8d 74 24 10       	lea    0x10(%r12),%rsi
 800001099da:	bf 0a 6c 00 00       	mov    $0x6c0a,%edi
 800001099df:	ff d3                	call   *%rbx
  vmwrite(HOST_GDTR_BASE, (uint64)&c->gdt);
 800001099e1:	49 8d 74 24 78       	lea    0x78(%r12),%rsi
 800001099e6:	bf 0c 6c 00 00       	mov    $0x6c0c,%edi
 800001099eb:	ff d3                	call   *%rbx
  vmwrite(HOST_IDTR_BASE, (uint64)idt);
 800001099ed:	48 be 80 df 11 00 00 	movabs $0x8000011df80,%rsi
 800001099f4:	08 00 00 
 800001099f7:	bf 0e 6c 00 00       	mov    $0x6c0e,%edi
 800001099fc:	ff d3                	call   *%rbx
  vmwrite(HOST_IA32_SYSENTER_CS, 0);
 800001099fe:	be 00 00 00 00       	mov    $0x0,%esi
 80000109a03:	bf 00 4c 00 00       	mov    $0x4c00,%edi
 80000109a08:	ff d3                	call   *%rbx
  vmwrite(HOST_IA32_SYSENTER_ESP, 0);
 80000109a0a:	be 00 00 00 00       	mov    $0x0,%esi
 80000109a0f:	bf 10 6c 00 00       	mov    $0x6c10,%edi
 80000109a14:	ff d3                	call   *%rbx
  vmwrite(HOST_IA32_SYSENTER_EIP, 0);
 80000109a16:	be 00 00 00 00       	mov    $0x0,%esi
 80000109a1b:	bf 12 6c 00 00       	mov    $0x6c12,%edi
 80000109a20:	ff d3                	call   *%rbx
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 80000109a22:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
 80000109a27:	0f 32                	rdmsr
  return ((uint64)hi << 32) | lo;
 80000109a29:	48 c1 e2 20          	shl    $0x20,%rdx
 80000109a2d:	89 c6                	mov    %eax,%esi
 80000109a2f:	48 09 d6             	or     %rdx,%rsi
  vmwrite(HOST_IA32_EFER, rdmsr(EFER_MSR));
 80000109a32:	bf 02 2c 00 00       	mov    $0x2c02,%edi
 80000109a37:	ff d3                	call   *%rbx
}
 80000109a39:	5b                   	pop    %rbx
 80000109a3a:	41 5c                	pop    %r12
 80000109a3c:	5d                   	pop    %rbp
 80000109a3d:	c3                   	ret

0000080000109a3e <eptfree>:
{
 80000109a3e:	55                   	push   %rbp
 80000109a3f:	48 89 e5             	mov    %rsp,%rbp
 80000109a42:	41 55                	push   %r13
 80000109a44:	41 54                	push   %r12
 80000109a46:	53                   	push   %rbx
 80000109a47:	48 83 ec 08          	sub    $0x8,%rsp
 80000109a4b:	49 89 fc             	mov    %rdi,%r12
 80000109a4e:	41 89 f5             	mov    %esi,%r13d
  for(i = 0; i < 512; i++){
 80000109a51:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000109a56:	eb 29                	jmp    80000109a81 <eptfree+0x43>
      kfree((char*)P2V(EPT_ADDR(table[i])));
 80000109a58:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
 80000109a5f:	ff 0f 00 
 80000109a62:	48 21 c7             	and    %rax,%rdi
 80000109a65:	48 b8 00 00 00 00 00 	movabs $0x80000000000,%rax
 80000109a6c:	08 00 00 
 80000109a6f:	48 01 c7             	add    %rax,%rdi
 80000109a72:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 80000109a79:	08 00 00 
 80000109a7c:	ff d0                	call   *%rax
  for(i = 0; i < 512; i++){
 80000109a7e:	83 c3 01             	add    $0x1,%ebx
 80000109a81:	81 fb ff 01 00 00    	cmp    $0x1ff,%ebx
 80000109a87:	7f 3e                	jg     80000109ac7 <eptfree+0x89>
    if(!(table[i] & EPT_RWX))
 80000109a89:	48 63 c3             	movslq %ebx,%rax
 80000109a8c:	49 8b 3c c4          	mov    (%r12,%rax,8),%rdi
 80000109a90:	40 f6 c7 07          	test   $0x7,%dil
 80000109a94:	74 e8                	je     80000109a7e <eptfree+0x40>
    if(level > 0)
 80000109a96:	45 85 ed             	test   %r13d,%r13d
 80000109a99:	7e bd                	jle    80000109a58 <eptfree+0x1a>
      eptfree((uint64*)P2V(EPT_ADDR(table[i])), level - 1);
 80000109a9b:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
 80000109aa2:	ff 0f 00 
 80000109aa5:	48 21 c7             	and    %rax,%rdi
 80000109aa8:	48 b8 00 00 00 00 00 	movabs $0x80000000000,%rax
 80000109aaf:	08 00 00 
 80000109ab2:	48 01 c7             	add    %rax,%rdi
 80000109ab5:	41 8d 75 ff          	lea    -0x1(%r13),%esi
 80000109ab9:	48 b8 3e 9a 10 00 00 	movabs $0x80000109a3e,%rax
 80000109ac0:	08 00 00 
 80000109ac3:	ff d0                	call   *%rax
 80000109ac5:	eb b7                	jmp    80000109a7e <eptfree+0x40>
  kfree((char*)table);
 80000109ac7:	4c 89 e7             	mov    %r12,%rdi
 80000109aca:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 80000109ad1:	08 00 00 
 80000109ad4:	ff d0                	call   *%rax
}
 80000109ad6:	48 83 c4 08          	add    $0x8,%rsp
 80000109ada:	5b                   	pop    %rbx
 80000109adb:	41 5c                	pop    %r12
 80000109add:	41 5d                	pop    %r13
 80000109adf:	5d                   	pop    %rbp
 80000109ae0:	c3                   	ret

0000080000109ae1 <vmfree>:
{
 80000109ae1:	55                   	push   %rbp
 80000109ae2:	48 89 e5             	mov    %rsp,%rbp
 80000109ae5:	41 54                	push   %r12
 80000109ae7:	53                   	push   %rbx
 80000109ae8:	48 89 fb             	mov    %rdi,%rbx
  if(vm->ept)
 80000109aeb:	48 8b 7f 18          	mov    0x18(%rdi),%rdi
 80000109aef:	48 85 ff             	test   %rdi,%rdi
 80000109af2:	74 11                	je     80000109b05 <vmfree+0x24>
    eptfree(vm->ept, 3);
 80000109af4:	be 03 00 00 00       	mov    $0x3,%esi
 80000109af9:	48 b8 3e 9a 10 00 00 	movabs $0x80000109a3e,%rax
 80000109b00:	08 00 00 
 80000109b03:	ff d0                	call   *%rax
  if(vm->vmcs)
 80000109b05:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
 80000109b09:	48 85 ff             	test   %rdi,%rdi
 80000109b0c:	74 0c                	je     80000109b1a <vmfree+0x39>
    kfree(vm->vmcs);
 80000109b0e:	48 b8 d0 2c 10 00 00 	movabs $0x80000102cd0,%rax
 80000109b15:	08 00 00 
 80000109b18:	ff d0                	call   *%rax
  acquire(&vms.lock);
 80000109b1a:	49 bc a0 08 11 00 00 	movabs $0x800001108a0,%r12
 80000109b21:	08 00 00 
 80000109b24:	4c 89 e7             	mov    %r12,%rdi
 80000109b27:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000109b2e:	08 00 00 
 80000109b31:	ff d0                	call   *%rax
  vm->ept = 0;
 80000109b33:	48 c7 43 18 00 00 00 	movq   $0x0,0x18(%rbx)
 80000109b3a:	00 
  vm->vmcs = 0;
 80000109b3b:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
 80000109b42:	00 
  vm->owner = 0;
 80000109b43:	48 c7 43 08 00 00 00 	movq   $0x0,0x8(%rbx)
 80000109b4a:	00 
  vm->used = 0;
 80000109b4b:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  release(&vms.lock);
 80000109b51:	4c 89 e7             	mov    %r12,%rdi
 80000109b54:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000109b5b:	08 00 00 
 80000109b5e:	ff d0                	call   *%rax
}
 80000109b60:	5b                   	pop    %rbx
 80000109b61:	41 5c                	pop    %r12
 80000109b63:	5d                   	pop    %rbp
 80000109b64:	c3                   	ret

0000080000109b65 <vmxinit>:
{
 80000109b65:	55                   	push   %rbp
 80000109b66:	48 89 e5             	mov    %rsp,%rbp
 80000109b69:	41 54                	push   %r12
 80000109b6b:	53                   	push   %rbx
 80000109b6c:	48 83 ec 10          	sub    $0x10,%rsp
  int id = cpuid();
 80000109b70:	48 b8 3b 46 10 00 00 	movabs $0x8000010463b,%rax
 80000109b77:	08 00 00 
 80000109b7a:	ff d0                	call   *%rax
 80000109b7c:	41 89 c4             	mov    %eax,%r12d
  asm volatile("cpuid" : "=a" (*a), "=b" (*b), "=c" (*c), "=d" (*d)
 80000109b7f:	b8 01 00 00 00       	mov    $0x1,%eax
 80000109b84:	b9 00 00 00 00       	mov    $0x0,%ecx
 80000109b89:	0f a2                	cpuid
  if(!(c & CPUID1_ECX_VMX)) {
 80000109b8b:	f6 c1 20             	test   $0x20,%cl
 80000109b8e:	0f 84 0d 01 00 00    	je     80000109ca1 <vmxinit+0x13c>
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 80000109b94:	b9 3a 00 00 00       	mov    $0x3a,%ecx
 80000109b99:	0f 32                	rdmsr
  return ((uint64)hi << 32) | lo;
 80000109b9b:	48 c1 e2 20          	shl    $0x20,%rdx
 80000109b9f:	89 c0                	mov    %eax,%eax
 80000109ba1:	48 09 c2             	or     %rax,%rdx
  if (!(fc & FEATURE_CONTROL_LOCKED)) {
 80000109ba4:	a8 01                	test   $0x1,%al
 80000109ba6:	0f 85 12 01 00 00    	jne    80000109cbe <vmxinit+0x159>
    fc |= FEATURE_CONTROL_LOCKED | FEATURE_CONTROL_VMXON_OUTSIDE_SMX;
 80000109bac:	89 d0                	mov    %edx,%eax
 80000109bae:	83 c8 05             	or     $0x5,%eax
  asm volatile("wrmsr" : : "c" (msr), "a" ((uint)val), "d" ((uint)(val >> 32)));
 80000109bb1:	ba 00 00 00 00       	mov    $0x0,%edx
 80000109bb6:	0f 30                	wrmsr
  asm volatile("movq %%cr0,%0" : "=r" (val));
 80000109bb8:	0f 20 c6             	mov    %cr0,%rsi
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 80000109bbb:	b9 86 04 00 00       	mov    $0x486,%ecx
 80000109bc0:	0f 32                	rdmsr
  cr0 |= rdmsr(MSR_IA32_VMX_CR0_FIXED0);
 80000109bc2:	09 c6                	or     %eax,%esi
 80000109bc4:	b9 87 04 00 00       	mov    $0x487,%ecx
 80000109bc9:	0f 32                	rdmsr
  lcr0(cr0);
 80000109bcb:	21 c6                	and    %eax,%esi
  asm volatile("movq %0,%%cr0" : : "r" (val));
 80000109bcd:	0f 22 c6             	mov    %rsi,%cr0
  asm volatile("movq %%cr4,%0" : "=r" (val));
 80000109bd0:	0f 20 e6             	mov    %cr4,%rsi
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 80000109bd3:	b9 88 04 00 00       	mov    $0x488,%ecx
 80000109bd8:	0f 32                	rdmsr
  cr4 |= rdmsr(MSR_IA32_VMX_CR4_FIXED0);
 80000109bda:	09 c6                	or     %eax,%esi
 80000109bdc:	b9 89 04 00 00       	mov    $0x489,%ecx
 80000109be1:	0f 32                	rdmsr
  lcr4(cr4);
 80000109be3:	21 c6                	and    %eax,%esi
  asm volatile("movq %0,%%cr4" : : "r" (val));
 80000109be5:	0f 22 e6             	mov    %rsi,%cr4
  asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (msr));
 80000109be8:	b9 80 04 00 00       	mov    $0x480,%ecx
 80000109bed:	0f 32                	rdmsr
  vmcs_revision = rdmsr(MSR_IA32_VMX_BASIC) & 0x7FFFFFFF;
 80000109bef:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
 80000109bf4:	a3 90 ef 11 00 00 08 	movabs %eax,0x8000011ef90
 80000109bfb:	00 00 
  if ((region = kalloc()) == 0) {
 80000109bfd:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000109c04:	08 00 00 
 80000109c07:	ff d0                	call   *%rax
 80000109c09:	48 89 c3             	mov    %rax,%rbx
 80000109c0c:	48 85 c0             	test   %rax,%rax
 80000109c0f:	0f 84 cf 00 00 00    	je     80000109ce4 <vmxinit+0x17f>
  memset(region, 0, PGSIZE);
 80000109c15:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000109c1a:	be 00 00 00 00       	mov    $0x0,%esi
 80000109c1f:	48 89 c7             	mov    %rax,%rdi
 80000109c22:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000109c29:	08 00 00 
 80000109c2c:	ff d0                	call   *%rax
  *(uint*)region = vmcs_revision;
 80000109c2e:	a1 90 ef 11 00 00 08 	movabs 0x8000011ef90,%eax
 80000109c35:	00 00 
 80000109c37:	89 03                	mov    %eax,(%rbx)
  if (vmxon(V2P(region)) < 0) {
 80000109c39:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 80000109c40:	f8 ff ff 
 80000109c43:	48 01 c3             	add    %rax,%rbx
 80000109c46:	48 89 5d e8          	mov    %rbx,-0x18(%rbp)
  asm volatile("vmxon %1; setna %0" : "=q" (fail) : "m" (pa) : "cc", "memory");
 80000109c4a:	f3 0f c7 75 e8       	vmxon  -0x18(%rbp)
 80000109c4f:	0f 96 c0             	setbe  %al
  return fail ? -1 : 0;
 80000109c52:	0f b6 c0             	movzbl %al,%eax
 80000109c55:	85 c0                	test   %eax,%eax
 80000109c57:	0f 85 a4 00 00 00    	jne    80000109d01 <vmxinit+0x19c>
  cpus[id].vmx_ok = 1;
 80000109c5d:	49 63 c4             	movslq %r12d,%rax
 80000109c60:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 80000109c64:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
 80000109c68:	48 b8 20 a0 11 00 00 	movabs $0x8000011a020,%rax
 80000109c6f:	08 00 00 
 80000109c72:	c7 84 d0 b4 00 00 00 	movl   $0x1,0xb4(%rax,%rdx,8)
 80000109c79:	01 00 00 00 
  cprintf("cpu%d: VMX enabled\n", id);
 80000109c7d:	44 89 e6             	mov    %r12d,%esi
 80000109c80:	48 bf d7 ae 10 00 00 	movabs $0x8000010aed7,%rdi
 80000109c87:	08 00 00 
 80000109c8a:	b0 00                	mov    $0x0,%al
 80000109c8c:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000109c93:	08 00 00 
 80000109c96:	ff d2                	call   *%rdx
}
 80000109c98:	48 83 c4 10          	add    $0x10,%rsp
 80000109c9c:	5b                   	pop    %rbx
 80000109c9d:	41 5c                	pop    %r12
 80000109c9f:	5d                   	pop    %rbp
 80000109ca0:	c3                   	ret
    cprintf("cpu%d: no VMX support\n", id);
 80000109ca1:	44 89 e6             	mov    %r12d,%esi
 80000109ca4:	48 bf c0 ae 10 00 00 	movabs $0x8000010aec0,%rdi
 80000109cab:	08 00 00 
 80000109cae:	b0 00                	mov    $0x0,%al
 80000109cb0:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000109cb7:	08 00 00 
 80000109cba:	ff d2                	call   *%rdx
    return;
 80000109cbc:	eb da                	jmp    80000109c98 <vmxinit+0x133>
  if (!(fc & FEATURE_CONTROL_VMXON_OUTSIDE_SMX)) {
 80000109cbe:	f6 c2 04             	test   $0x4,%dl
 80000109cc1:	0f 85 f1 fe ff ff    	jne    80000109bb8 <vmxinit+0x53>
    cprintf("cpu%d: VMX disabled by firware\n", id);
 80000109cc7:	44 89 e6             	mov    %r12d,%esi
 80000109cca:	48 bf 80 b1 10 00 00 	movabs $0x8000010b180,%rdi
 80000109cd1:	08 00 00 
 80000109cd4:	b0 00                	mov    $0x0,%al
 80000109cd6:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000109cdd:	08 00 00 
 80000109ce0:	ff d2                	call   *%rdx
    return;
 80000109ce2:	eb b4                	jmp    80000109c98 <vmxinit+0x133>
    cprintf("cpu%d: no memory for the VMXON region\n", id);
 80000109ce4:	44 89 e6             	mov    %r12d,%esi
 80000109ce7:	48 bf a0 b1 10 00 00 	movabs $0x8000010b1a0,%rdi
 80000109cee:	08 00 00 
 80000109cf1:	b0 00                	mov    $0x0,%al
 80000109cf3:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000109cfa:	08 00 00 
 80000109cfd:	ff d2                	call   *%rdx
    return;
 80000109cff:	eb 97                	jmp    80000109c98 <vmxinit+0x133>
    cprintf("cpu%d: vmxon failed\n", id);
 80000109d01:	44 89 e6             	mov    %r12d,%esi
 80000109d04:	48 bf eb ae 10 00 00 	movabs $0x8000010aeeb,%rdi
 80000109d0b:	08 00 00 
 80000109d0e:	b0 00                	mov    $0x0,%al
 80000109d10:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000109d17:	08 00 00 
 80000109d1a:	ff d2                	call   *%rdx
    return;
 80000109d1c:	e9 77 ff ff ff       	jmp    80000109c98 <vmxinit+0x133>

0000080000109d21 <vmcreate>:
{
 80000109d21:	55                   	push   %rbp
 80000109d22:	48 89 e5             	mov    %rsp,%rbp
 80000109d25:	41 57                	push   %r15
 80000109d27:	41 56                	push   %r14
 80000109d29:	41 55                	push   %r13
 80000109d2b:	41 54                	push   %r12
 80000109d2d:	53                   	push   %rbx
 80000109d2e:	48 83 ec 38          	sub    $0x38,%rsp
 80000109d32:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
 80000109d36:	89 55 b4             	mov    %edx,-0x4c(%rbp)
  if (memsz <= 0 || memsz > VM_MAXMEM || len < 0 || VM_LOAD_ADDR + len > memsz) 
 80000109d39:	8d 42 ff             	lea    -0x1(%rdx),%eax
 80000109d3c:	3d ff ff ff 03       	cmp    $0x3ffffff,%eax
 80000109d41:	0f 87 d9 04 00 00    	ja     8000010a220 <vmcreate+0x4ff>
 80000109d47:	41 89 f5             	mov    %esi,%r13d
 80000109d4a:	85 f6                	test   %esi,%esi
 80000109d4c:	0f 88 d5 04 00 00    	js     8000010a227 <vmcreate+0x506>
 80000109d52:	8d 86 ff ff 0f 00    	lea    0xfffff(%rsi),%eax
 80000109d58:	39 d0                	cmp    %edx,%eax
 80000109d5a:	0f 8d ce 04 00 00    	jge    8000010a22e <vmcreate+0x50d>
  pushcli();
 80000109d60:	48 b8 d4 53 10 00 00 	movabs $0x800001053d4,%rax
 80000109d67:	08 00 00 
 80000109d6a:	ff d0                	call   *%rax
  r = mycpu()->vmx_ok;
 80000109d6c:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 80000109d73:	08 00 00 
 80000109d76:	ff d0                	call   *%rax
 80000109d78:	8b 98 b4 00 00 00    	mov    0xb4(%rax),%ebx
  popcli();
 80000109d7e:	48 b8 31 54 10 00 00 	movabs $0x80000105431,%rax
 80000109d85:	08 00 00 
 80000109d88:	ff d0                	call   *%rax
  if (!r)
 80000109d8a:	85 db                	test   %ebx,%ebx
 80000109d8c:	0f 84 a3 04 00 00    	je     8000010a235 <vmcreate+0x514>
 80000109d92:	b9 8c 04 00 00       	mov    $0x48c,%ecx
 80000109d97:	0f 32                	rdmsr
  if ((rdmsr(MSR_IA32_VMX_EPT_VPID_CAP) & need) != need) {
 80000109d99:	48 f7 d0             	not    %rax
 80000109d9c:	a9 40 40 10 02       	test   $0x2104040,%eax
 80000109da1:	75 45                	jne    80000109de8 <vmcreate+0xc7>
  acquire(&vms.lock);
 80000109da3:	48 bf a0 08 11 00 00 	movabs $0x800001108a0,%rdi
 80000109daa:	08 00 00 
 80000109dad:	48 b8 10 55 10 00 00 	movabs $0x80000105510,%rax
 80000109db4:	08 00 00 
 80000109db7:	ff d0                	call   *%rax
  for (id = 0; id < NVM; id++) 
 80000109db9:	bb 00 00 00 00       	mov    $0x0,%ebx
 80000109dbe:	83 fb 03             	cmp    $0x3,%ebx
 80000109dc1:	7f 47                	jg     80000109e0a <vmcreate+0xe9>
    if (!vms.vm[id].used)
 80000109dc3:	48 63 c3             	movslq %ebx,%rax
 80000109dc6:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 80000109dca:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 80000109dce:	48 c1 e0 04          	shl    $0x4,%rax
 80000109dd2:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 80000109dd9:	08 00 00 
 80000109ddc:	83 7c 02 68 00       	cmpl   $0x0,0x68(%rdx,%rax,1)
 80000109de1:	74 27                	je     80000109e0a <vmcreate+0xe9>
  for (id = 0; id < NVM; id++) 
 80000109de3:	83 c3 01             	add    $0x1,%ebx
 80000109de6:	eb d6                	jmp    80000109dbe <vmcreate+0x9d>
    cprintf("vmx: CPU lacks required EPT features\n");
 80000109de8:	48 bf c8 b1 10 00 00 	movabs $0x8000010b1c8,%rdi
 80000109def:	08 00 00 
 80000109df2:	b0 00                	mov    $0x0,%al
 80000109df4:	48 ba f9 08 10 00 00 	movabs $0x800001008f9,%rdx
 80000109dfb:	08 00 00 
 80000109dfe:	ff d2                	call   *%rdx
    return -1;
 80000109e00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 80000109e05:	e9 05 04 00 00       	jmp    8000010a20f <vmcreate+0x4ee>
  if (id == NVM) {
 80000109e0a:	83 fb 04             	cmp    $0x4,%ebx
 80000109e0d:	0f 84 f5 01 00 00    	je     8000010a008 <vmcreate+0x2e7>
  vm = &vms.vm[id];
 80000109e13:	4c 63 f3             	movslq %ebx,%r14
 80000109e16:	4f 8d 24 76          	lea    (%r14,%r14,2),%r12
 80000109e1a:	49 c1 e4 02          	shl    $0x2,%r12
 80000109e1e:	4b 8d 04 34          	lea    (%r12,%r14,1),%rax
 80000109e22:	48 c1 e0 04          	shl    $0x4,%rax
 80000109e26:	49 bf a0 08 11 00 00 	movabs $0x800001108a0,%r15
 80000109e2d:	08 00 00 
 80000109e30:	49 8d 44 07 68       	lea    0x68(%r15,%rax,1),%rax
 80000109e35:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
  memset(vm, 0, sizeof(*vm));
 80000109e39:	ba d0 00 00 00       	mov    $0xd0,%edx
 80000109e3e:	be 00 00 00 00       	mov    $0x0,%esi
 80000109e43:	48 89 c7             	mov    %rax,%rdi
 80000109e46:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000109e4d:	08 00 00 
 80000109e50:	ff d0                	call   *%rax
  vm->used = 1;
 80000109e52:	4b 8d 04 34          	lea    (%r12,%r14,1),%rax
 80000109e56:	48 c1 e0 04          	shl    $0x4,%rax
 80000109e5a:	41 c7 44 07 68 01 00 	movl   $0x1,0x68(%r15,%rax,1)
 80000109e61:	00 00 
  vm->owner = myproc();
 80000109e63:	b0 00                	mov    $0x0,%al
 80000109e65:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 80000109e6c:	08 00 00 
 80000109e6f:	ff d2                	call   *%rdx
 80000109e71:	48 89 c2             	mov    %rax,%rdx
 80000109e74:	4b 8d 04 34          	lea    (%r12,%r14,1),%rax
 80000109e78:	48 c1 e0 04          	shl    $0x4,%rax
 80000109e7c:	49 89 54 07 70       	mov    %rdx,0x70(%r15,%rax,1)
  release(&vms.lock);
 80000109e81:	4c 89 ff             	mov    %r15,%rdi
 80000109e84:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 80000109e8b:	08 00 00 
 80000109e8e:	ff d0                	call   *%rax
  vm->memsz = PGROUNDUP(memsz);
 80000109e90:	8b 45 b4             	mov    -0x4c(%rbp),%eax
 80000109e93:	05 ff 0f 00 00       	add    $0xfff,%eax
 80000109e98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 80000109e9d:	48 98                	cltq
 80000109e9f:	4b 8d 14 34          	lea    (%r12,%r14,1),%rdx
 80000109ea3:	48 c1 e2 04          	shl    $0x4,%rdx
 80000109ea7:	49 89 84 17 90 00 00 	mov    %rax,0x90(%r15,%rdx,1)
 80000109eae:	00 
  vm->rflags = 0x2;
 80000109eaf:	49 c7 84 17 20 01 00 	movq   $0x2,0x120(%r15,%rdx,1)
 80000109eb6:	00 02 00 00 00 
  if ((vm->vmcs = kalloc()) == 0)
 80000109ebb:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000109ec2:	08 00 00 
 80000109ec5:	ff d0                	call   *%rax
 80000109ec7:	48 89 c7             	mov    %rax,%rdi
 80000109eca:	4d 01 f4             	add    %r14,%r12
 80000109ecd:	49 c1 e4 04          	shl    $0x4,%r12
 80000109ed1:	4b 89 44 27 78       	mov    %rax,0x78(%r15,%r12,1)
 80000109ed6:	48 85 c0             	test   %rax,%rax
 80000109ed9:	0f 84 1b 03 00 00    	je     8000010a1fa <vmcreate+0x4d9>
  memset(vm->vmcs, 0, PGSIZE);
 80000109edf:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000109ee4:	be 00 00 00 00       	mov    $0x0,%esi
 80000109ee9:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000109ef0:	08 00 00 
 80000109ef3:	ff d0                	call   *%rax
  if((vm->ept = (uint64*)kalloc()) == 0)
 80000109ef5:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000109efc:	08 00 00 
 80000109eff:	ff d0                	call   *%rax
 80000109f01:	48 89 c7             	mov    %rax,%rdi
 80000109f04:	4b 89 84 27 80 00 00 	mov    %rax,0x80(%r15,%r12,1)
 80000109f0b:	00 
 80000109f0c:	48 85 c0             	test   %rax,%rax
 80000109f0f:	0f 84 e5 02 00 00    	je     8000010a1fa <vmcreate+0x4d9>
  memset(vm->ept, 0, PGSIZE);
 80000109f15:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000109f1a:	be 00 00 00 00       	mov    $0x0,%esi
 80000109f1f:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000109f26:	08 00 00 
 80000109f29:	ff d0                	call   *%rax
  vm->eptp = V2P(vm->ept) | EPTP_WALK_4 | EPTP_MEMTYPE_WB;
 80000109f2b:	48 ba 00 00 00 00 00 	movabs $0xfffff80000000000,%rdx
 80000109f32:	f8 ff ff 
 80000109f35:	4b 03 94 27 80 00 00 	add    0x80(%r15,%r12,1),%rdx
 80000109f3c:	00 
 80000109f3d:	48 83 ca 1e          	or     $0x1e,%rdx
 80000109f41:	4b 89 94 27 88 00 00 	mov    %rdx,0x88(%r15,%r12,1)
 80000109f48:	00 
  for (gpa = 0; gpa < vm->memsz; gpa += PGSIZE) {
 80000109f49:	41 bf 00 00 00 00    	mov    $0x0,%r15d
 80000109f4f:	48 63 c3             	movslq %ebx,%rax
 80000109f52:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 80000109f56:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 80000109f5a:	48 c1 e0 04          	shl    $0x4,%rax
 80000109f5e:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 80000109f65:	08 00 00 
 80000109f68:	4c 3b bc 02 90 00 00 	cmp    0x90(%rdx,%rax,1),%r15
 80000109f6f:	00 
 80000109f70:	0f 83 b2 00 00 00    	jae    8000010a028 <vmcreate+0x307>
    if ((pte = eptwalk(vm->ept, gpa, 1)) == 0 || (mem = kalloc()) == 0)
 80000109f76:	48 63 c3             	movslq %ebx,%rax
 80000109f79:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 80000109f7d:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 80000109f81:	48 c1 e0 04          	shl    $0x4,%rax
 80000109f85:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 80000109f8c:	08 00 00 
 80000109f8f:	48 8b bc 02 80 00 00 	mov    0x80(%rdx,%rax,1),%rdi
 80000109f96:	00 
 80000109f97:	ba 01 00 00 00       	mov    $0x1,%edx
 80000109f9c:	4c 89 fe             	mov    %r15,%rsi
 80000109f9f:	48 b8 d7 92 10 00 00 	movabs $0x800001092d7,%rax
 80000109fa6:	08 00 00 
 80000109fa9:	ff d0                	call   *%rax
 80000109fab:	49 89 c6             	mov    %rax,%r14
 80000109fae:	48 85 c0             	test   %rax,%rax
 80000109fb1:	0f 84 43 02 00 00    	je     8000010a1fa <vmcreate+0x4d9>
 80000109fb7:	48 b8 43 2e 10 00 00 	movabs $0x80000102e43,%rax
 80000109fbe:	08 00 00 
 80000109fc1:	ff d0                	call   *%rax
 80000109fc3:	49 89 c4             	mov    %rax,%r12
 80000109fc6:	48 85 c0             	test   %rax,%rax
 80000109fc9:	0f 84 2b 02 00 00    	je     8000010a1fa <vmcreate+0x4d9>
    memset(mem, 0, PGSIZE);
 80000109fcf:	ba 00 10 00 00       	mov    $0x1000,%edx
 80000109fd4:	be 00 00 00 00       	mov    $0x0,%esi
 80000109fd9:	48 89 c7             	mov    %rax,%rdi
 80000109fdc:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 80000109fe3:	08 00 00 
 80000109fe6:	ff d0                	call   *%rax
    *pte = V2P(mem) | EPT_RWX | EPT_MEMTYPE_WB;
 80000109fe8:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 80000109fef:	f8 ff ff 
 80000109ff2:	49 01 c4             	add    %rax,%r12
 80000109ff5:	49 83 cc 37          	or     $0x37,%r12
 80000109ff9:	4d 89 26             	mov    %r12,(%r14)
  for (gpa = 0; gpa < vm->memsz; gpa += PGSIZE) {
 80000109ffc:	49 81 c7 00 10 00 00 	add    $0x1000,%r15
 8000010a003:	e9 47 ff ff ff       	jmp    80000109f4f <vmcreate+0x22e>
    release(&vms.lock);
 8000010a008:	48 bf a0 08 11 00 00 	movabs $0x800001108a0,%rdi
 8000010a00f:	08 00 00 
 8000010a012:	48 b8 8a 55 10 00 00 	movabs $0x8000010558a,%rax
 8000010a019:	08 00 00 
 8000010a01c:	ff d0                	call   *%rax
    return -1;
 8000010a01e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 8000010a023:	e9 e7 01 00 00       	jmp    8000010a20f <vmcreate+0x4ee>
  for (off = 0; off < len; off += n) {
 8000010a028:	41 be 00 00 00 00    	mov    $0x0,%r14d
 8000010a02e:	eb 72                	jmp    8000010a0a2 <vmcreate+0x381>
    pte = eptwalk(vm->ept, gpa, 0);
 8000010a030:	48 63 c3             	movslq %ebx,%rax
 8000010a033:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 8000010a037:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 8000010a03b:	48 c1 e0 04          	shl    $0x4,%rax
 8000010a03f:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 8000010a046:	08 00 00 
 8000010a049:	48 8b bc 02 80 00 00 	mov    0x80(%rdx,%rax,1),%rdi
 8000010a050:	00 
 8000010a051:	ba 00 00 00 00       	mov    $0x0,%edx
 8000010a056:	48 b8 d7 92 10 00 00 	movabs $0x800001092d7,%rax
 8000010a05d:	08 00 00 
 8000010a060:	ff d0                	call   *%rax
 8000010a062:	48 89 c2             	mov    %rax,%rdx
    memmove((char*)P2V(EPT_ADDR(*pte)) + gpa % PGSIZE, image + off, n);
 8000010a065:	49 63 f6             	movslq %r14d,%rsi
 8000010a068:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
 8000010a06c:	48 01 c6             	add    %rax,%rsi
 8000010a06f:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
 8000010a076:	ff 0f 00 
 8000010a079:	48 23 02             	and    (%rdx),%rax
 8000010a07c:	49 63 fc             	movslq %r12d,%rdi
 8000010a07f:	48 09 c7             	or     %rax,%rdi
 8000010a082:	48 b8 00 00 00 00 00 	movabs $0x80000000000,%rax
 8000010a089:	08 00 00 
 8000010a08c:	48 8d 3c 07          	lea    (%rdi,%rax,1),%rdi
 8000010a090:	44 89 fa             	mov    %r15d,%edx
 8000010a093:	48 b8 6f 56 10 00 00 	movabs $0x8000010566f,%rax
 8000010a09a:	08 00 00 
 8000010a09d:	ff d0                	call   *%rax
  for (off = 0; off < len; off += n) {
 8000010a09f:	45 01 fe             	add    %r15d,%r14d
 8000010a0a2:	45 39 ee             	cmp    %r13d,%r14d
 8000010a0a5:	7d 30                	jge    8000010a0d7 <vmcreate+0x3b6>
    gpa = VM_LOAD_ADDR + off;
 8000010a0a7:	45 8d a6 00 00 10 00 	lea    0x100000(%r14),%r12d
 8000010a0ae:	49 63 f4             	movslq %r12d,%rsi
    n = PGSIZE - gpa % PGSIZE;
 8000010a0b1:	41 81 e4 ff 0f 00 00 	and    $0xfff,%r12d
 8000010a0b8:	b8 00 10 00 00       	mov    $0x1000,%eax
 8000010a0bd:	44 29 e0             	sub    %r12d,%eax
    if (n > len - off)
 8000010a0c0:	45 89 ef             	mov    %r13d,%r15d
 8000010a0c3:	45 29 f7             	sub    %r14d,%r15d
 8000010a0c6:	41 39 c7             	cmp    %eax,%r15d
 8000010a0c9:	0f 8c 61 ff ff ff    	jl     8000010a030 <vmcreate+0x30f>
    n = PGSIZE - gpa % PGSIZE;
 8000010a0cf:	41 89 c7             	mov    %eax,%r15d
 8000010a0d2:	e9 59 ff ff ff       	jmp    8000010a030 <vmcreate+0x30f>
  *(uint*)vm->vmcs = vmcs_revision;
 8000010a0d7:	48 63 c3             	movslq %ebx,%rax
 8000010a0da:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 8000010a0de:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 8000010a0e2:	48 c1 e0 04          	shl    $0x4,%rax
 8000010a0e6:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 8000010a0ed:	08 00 00 
 8000010a0f0:	48 8b 54 02 78       	mov    0x78(%rdx,%rax,1),%rdx
 8000010a0f5:	a1 90 ef 11 00 00 08 	movabs 0x8000011ef90,%eax
 8000010a0fc:	00 00 
 8000010a0fe:	89 02                	mov    %eax,(%rdx)
  pushcli();
 8000010a100:	48 b8 d4 53 10 00 00 	movabs $0x800001053d4,%rax
 8000010a107:	08 00 00 
 8000010a10a:	ff d0                	call   *%rax
  if (!mycpu()->vmx_ok || vmclear(V2P(vm->vmcs)) < 0 || vmptrld(V2P(vm->vmcs)) < 0) {
 8000010a10c:	48 b8 a8 45 10 00 00 	movabs $0x800001045a8,%rax
 8000010a113:	08 00 00 
 8000010a116:	ff d0                	call   *%rax
 8000010a118:	83 b8 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rax)
 8000010a11f:	0f 84 c9 00 00 00    	je     8000010a1ee <vmcreate+0x4cd>
 8000010a125:	48 63 c3             	movslq %ebx,%rax
 8000010a128:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 8000010a12c:	48 8d 14 90          	lea    (%rax,%rdx,4),%rdx
 8000010a130:	48 c1 e2 04          	shl    $0x4,%rdx
 8000010a134:	48 b9 a0 08 11 00 00 	movabs $0x800001108a0,%rcx
 8000010a13b:	08 00 00 
 8000010a13e:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 8000010a145:	f8 ff ff 
 8000010a148:	48 03 44 11 78       	add    0x78(%rcx,%rdx,1),%rax
 8000010a14d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  asm volatile("vmclear %1; setna %0" : "=q" (fail) : "m" (pa) : "cc", "memory");
 8000010a151:	66 0f c7 75 c8       	vmclear -0x38(%rbp)
 8000010a156:	0f 96 c0             	setbe  %al
  return fail ? -1 : 0;
 8000010a159:	0f b6 c0             	movzbl %al,%eax
 8000010a15c:	85 c0                	test   %eax,%eax
 8000010a15e:	0f 85 8a 00 00 00    	jne    8000010a1ee <vmcreate+0x4cd>
  if (!mycpu()->vmx_ok || vmclear(V2P(vm->vmcs)) < 0 || vmptrld(V2P(vm->vmcs)) < 0) {
 8000010a164:	48 63 c3             	movslq %ebx,%rax
 8000010a167:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 8000010a16b:	48 8d 14 90          	lea    (%rax,%rdx,4),%rdx
 8000010a16f:	48 c1 e2 04          	shl    $0x4,%rdx
 8000010a173:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 8000010a17a:	f8 ff ff 
 8000010a17d:	48 03 44 11 78       	add    0x78(%rcx,%rdx,1),%rax
 8000010a182:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  asm volatile("vmptrld %1; setna %0" : "=q" (fail) : "m" (pa) : "cc", "memory");
 8000010a186:	0f c7 75 c8          	vmptrld -0x38(%rbp)
 8000010a18a:	0f 96 c0             	setbe  %al
  return fail ? -1 : 0;
 8000010a18d:	0f b6 c0             	movzbl %al,%eax
 8000010a190:	85 c0                	test   %eax,%eax
 8000010a192:	75 5a                	jne    8000010a1ee <vmcreate+0x4cd>
  r = vmcsinit(vm);
 8000010a194:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
 8000010a198:	48 b8 ff 94 10 00 00 	movabs $0x800001094ff,%rax
 8000010a19f:	08 00 00 
 8000010a1a2:	ff d0                	call   *%rax
 8000010a1a4:	41 89 c4             	mov    %eax,%r12d
  vmclear(V2P(vm->vmcs));
 8000010a1a7:	48 63 c3             	movslq %ebx,%rax
 8000010a1aa:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 8000010a1ae:	48 8d 14 90          	lea    (%rax,%rdx,4),%rdx
 8000010a1b2:	48 c1 e2 04          	shl    $0x4,%rdx
 8000010a1b6:	48 b9 a0 08 11 00 00 	movabs $0x800001108a0,%rcx
 8000010a1bd:	08 00 00 
 8000010a1c0:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 8000010a1c7:	f8 ff ff 
 8000010a1ca:	48 03 44 11 78       	add    0x78(%rcx,%rdx,1),%rax
 8000010a1cf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  asm volatile("vmclear %1; setna %0" : "=q" (fail) : "m" (pa) : "cc", "memory");
 8000010a1d3:	66 0f c7 75 c8       	vmclear -0x38(%rbp)
 8000010a1d8:	0f 96 c0             	setbe  %al
  popcli();
 8000010a1db:	48 b8 31 54 10 00 00 	movabs $0x80000105431,%rax
 8000010a1e2:	08 00 00 
 8000010a1e5:	ff d0                	call   *%rax
  if (r < 0)
 8000010a1e7:	45 85 e4             	test   %r12d,%r12d
 8000010a1ea:	79 23                	jns    8000010a20f <vmcreate+0x4ee>
 8000010a1ec:	eb 0c                	jmp    8000010a1fa <vmcreate+0x4d9>
    popcli();
 8000010a1ee:	48 b8 31 54 10 00 00 	movabs $0x80000105431,%rax
 8000010a1f5:	08 00 00 
 8000010a1f8:	ff d0                	call   *%rax
    vmfree(vm);
 8000010a1fa:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
 8000010a1fe:	48 b8 e1 9a 10 00 00 	movabs $0x80000109ae1,%rax
 8000010a205:	08 00 00 
 8000010a208:	ff d0                	call   *%rax
    return -1;
 8000010a20a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
 8000010a20f:	89 d8                	mov    %ebx,%eax
 8000010a211:	48 83 c4 38          	add    $0x38,%rsp
 8000010a215:	5b                   	pop    %rbx
 8000010a216:	41 5c                	pop    %r12
 8000010a218:	41 5d                	pop    %r13
 8000010a21a:	41 5e                	pop    %r14
 8000010a21c:	41 5f                	pop    %r15
 8000010a21e:	5d                   	pop    %rbp
 8000010a21f:	c3                   	ret
    return -1;
 8000010a220:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 8000010a225:	eb e8                	jmp    8000010a20f <vmcreate+0x4ee>
 8000010a227:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 8000010a22c:	eb e1                	jmp    8000010a20f <vmcreate+0x4ee>
 8000010a22e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 8000010a233:	eb da                	jmp    8000010a20f <vmcreate+0x4ee>
    return -1;
 8000010a235:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 8000010a23a:	eb d3                	jmp    8000010a20f <vmcreate+0x4ee>

000008000010a23c <vmsetreg>:
{
 8000010a23c:	55                   	push   %rbp
 8000010a23d:	48 89 e5             	mov    %rsp,%rbp
 8000010a240:	41 54                	push   %r12
 8000010a242:	53                   	push   %rbx
 8000010a243:	89 f3                	mov    %esi,%ebx
 8000010a245:	49 89 d4             	mov    %rdx,%r12
  if ((vm = getvm(id)) == 0 || reg < 0 || reg >= VMREG_NREGS)
 8000010a248:	48 b8 a9 93 10 00 00 	movabs $0x800001093a9,%rax
 8000010a24f:	08 00 00 
 8000010a252:	ff d0                	call   *%rax
 8000010a254:	48 85 c0             	test   %rax,%rax
 8000010a257:	74 54                	je     8000010a2ad <vmsetreg+0x71>
 8000010a259:	83 fb 11             	cmp    $0x11,%ebx
 8000010a25c:	77 56                	ja     8000010a2b4 <vmsetreg+0x78>
  switch (reg) {
 8000010a25e:	83 fb 10             	cmp    $0x10,%ebx
 8000010a261:	74 1b                	je     8000010a27e <vmsetreg+0x42>
 8000010a263:	83 fb 11             	cmp    $0x11,%ebx
 8000010a266:	74 24                	je     8000010a28c <vmsetreg+0x50>
 8000010a268:	83 fb 0f             	cmp    $0xf,%ebx
 8000010a26b:	75 31                	jne    8000010a29e <vmsetreg+0x62>
      vm->rsp = val;
 8000010a26d:	4c 89 a0 b0 00 00 00 	mov    %r12,0xb0(%rax)
  return 0;
 8000010a274:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8000010a279:	5b                   	pop    %rbx
 8000010a27a:	41 5c                	pop    %r12
 8000010a27c:	5d                   	pop    %rbp
 8000010a27d:	c3                   	ret
      vm->rip = val;
 8000010a27e:	4c 89 a0 a8 00 00 00 	mov    %r12,0xa8(%rax)
  return 0;
 8000010a285:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
 8000010a28a:	eb ed                	jmp    8000010a279 <vmsetreg+0x3d>
      vm->rflags = val | 0x2;
 8000010a28c:	49 83 cc 02          	or     $0x2,%r12
 8000010a290:	4c 89 a0 b8 00 00 00 	mov    %r12,0xb8(%rax)
  return 0;
 8000010a297:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
 8000010a29c:	eb db                	jmp    8000010a279 <vmsetreg+0x3d>
      ((uint64*)&vm->regs)[reg] = val;
 8000010a29e:	48 63 db             	movslq %ebx,%rbx
 8000010a2a1:	4c 89 64 d8 30       	mov    %r12,0x30(%rax,%rbx,8)
  return 0;
 8000010a2a6:	b8 00 00 00 00       	mov    $0x0,%eax
 8000010a2ab:	eb cc                	jmp    8000010a279 <vmsetreg+0x3d>
    return -1;
 8000010a2ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8000010a2b2:	eb c5                	jmp    8000010a279 <vmsetreg+0x3d>
 8000010a2b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8000010a2b9:	eb be                	jmp    8000010a279 <vmsetreg+0x3d>

000008000010a2bb <vmgetreg>:
{
 8000010a2bb:	55                   	push   %rbp
 8000010a2bc:	48 89 e5             	mov    %rsp,%rbp
 8000010a2bf:	41 54                	push   %r12
 8000010a2c1:	53                   	push   %rbx
 8000010a2c2:	89 f3                	mov    %esi,%ebx
 8000010a2c4:	49 89 d4             	mov    %rdx,%r12
  if ((vm = getvm(id)) == 0 || reg < 0 || reg >= VMREG_NREGS)
 8000010a2c7:	48 b8 a9 93 10 00 00 	movabs $0x800001093a9,%rax
 8000010a2ce:	08 00 00 
 8000010a2d1:	ff d0                	call   *%rax
 8000010a2d3:	48 85 c0             	test   %rax,%rax
 8000010a2d6:	74 60                	je     8000010a338 <vmgetreg+0x7d>
 8000010a2d8:	83 fb 11             	cmp    $0x11,%ebx
 8000010a2db:	77 62                	ja     8000010a33f <vmgetreg+0x84>
  switch (reg) {
 8000010a2dd:	83 fb 10             	cmp    $0x10,%ebx
 8000010a2e0:	74 1f                	je     8000010a301 <vmgetreg+0x46>
 8000010a2e2:	83 fb 11             	cmp    $0x11,%ebx
 8000010a2e5:	74 2c                	je     8000010a313 <vmgetreg+0x58>
 8000010a2e7:	83 fb 0f             	cmp    $0xf,%ebx
 8000010a2ea:	75 39                	jne    8000010a325 <vmgetreg+0x6a>
      *val = vm->rsp;
 8000010a2ec:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
 8000010a2f3:	49 89 04 24          	mov    %rax,(%r12)
  return 0;
 8000010a2f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8000010a2fc:	5b                   	pop    %rbx
 8000010a2fd:	41 5c                	pop    %r12
 8000010a2ff:	5d                   	pop    %rbp
 8000010a300:	c3                   	ret
      *val = vm->rip;
 8000010a301:	48 8b 80 a8 00 00 00 	mov    0xa8(%rax),%rax
 8000010a308:	49 89 04 24          	mov    %rax,(%r12)
  return 0;
 8000010a30c:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
 8000010a311:	eb e9                	jmp    8000010a2fc <vmgetreg+0x41>
      *val = vm->rflags;
 8000010a313:	48 8b 80 b8 00 00 00 	mov    0xb8(%rax),%rax
 8000010a31a:	49 89 04 24          	mov    %rax,(%r12)
  return 0;
 8000010a31e:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
 8000010a323:	eb d7                	jmp    8000010a2fc <vmgetreg+0x41>
      *val = ((uint64*)&vm->regs)[reg];
 8000010a325:	48 63 db             	movslq %ebx,%rbx
 8000010a328:	48 8b 44 d8 30       	mov    0x30(%rax,%rbx,8),%rax
 8000010a32d:	49 89 04 24          	mov    %rax,(%r12)
  return 0;
 8000010a331:	b8 00 00 00 00       	mov    $0x0,%eax
 8000010a336:	eb c4                	jmp    8000010a2fc <vmgetreg+0x41>
    return -1;
 8000010a338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8000010a33d:	eb bd                	jmp    8000010a2fc <vmgetreg+0x41>
 8000010a33f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8000010a344:	eb b6                	jmp    8000010a2fc <vmgetreg+0x41>

000008000010a346 <vmrun>:
 *    process stays on one CPU;
 *  - the host state is rewritten before every entry.
 */
int
vmrun(int id, struct vmexit *ue)
{
 8000010a346:	55                   	push   %rbp
 8000010a347:	48 89 e5             	mov    %rsp,%rbp
 8000010a34a:	41 56                	push   %r14
 8000010a34c:	41 55                	push   %r13
 8000010a34e:	41 54                	push   %r12
 8000010a350:	53                   	push   %rbx
 8000010a351:	48 83 ec 50          	sub    $0x50,%rsp
 8000010a355:	49 89 f5             	mov    %rsi,%r13
  struct vmexit e;
  uint64 reason, entryctl;
  uint inslen;
  int c, r;

  if((vm = getvm(id)) == 0)
 8000010a358:	48 b8 a9 93 10 00 00 	movabs $0x800001093a9,%rax
 8000010a35f:	08 00 00 
 8000010a362:	ff d0                	call   *%rax
 8000010a364:	48 89 c3             	mov    %rax,%rbx
 8000010a367:	48 85 c0             	test   %rax,%rax
 8000010a36a:	0f 85 60 01 00 00    	jne    8000010a4d0 <vmrun+0x18a>
    return -1;
 8000010a370:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 8000010a376:	e9 d9 02 00 00       	jmp    8000010a654 <vmrun+0x30e>
     * bound to this CPU, so we must not be rescheduled elsewhere.
     */
    pushcli();
    c = cpuid();
    if(!cpus[c].vmx_ok || vmptrld(V2P(vm->vmcs)) < 0){
      popcli();
 8000010a37b:	48 b8 31 54 10 00 00 	movabs $0x80000105431,%rax
 8000010a382:	08 00 00 
 8000010a385:	ff d0                	call   *%rax
      return -1;
 8000010a387:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 8000010a38d:	e9 c2 02 00 00       	jmp    8000010a654 <vmrun+0x30e>
     * page, the first time this VM runs on this CPU.
     * (SDM 31.4.3.4: software must INVEPT when it changes mappings or
     * reuses an EPT root.)  One bit per CPU records that we did so.
     */
    if(!(vm->flushed & (1 << c))){
      invept(INVEPT_SINGLE_CONTEXT, vm->eptp);
 8000010a392:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  struct { uint64 eptp, reserved; } desc = { eptp, 0 };
 8000010a396:	48 89 55 90          	mov    %rdx,-0x70(%rbp)
 8000010a39a:	48 c7 45 98 00 00 00 	movq   $0x0,-0x68(%rbp)
 8000010a3a1:	00 
  asm volatile("invept %1, %2; setna %0" : "=q" (fail) : "m" (desc), "r" (type)
 8000010a3a2:	ba 01 00 00 00       	mov    $0x1,%edx
 8000010a3a7:	66 0f 38 80 55 90    	invept -0x70(%rbp),%rdx
 8000010a3ad:	0f 96 c2             	setbe  %dl
      vm->flushed |= 1 << c;
 8000010a3b0:	09 83 c8 00 00 00    	or     %eax,0xc8(%rbx)
 8000010a3b6:	e9 bd 01 00 00       	jmp    8000010a578 <vmrun+0x232>
     * every entry: clear the bit, then set it if LMA is on.
     */
    entryctl = vmread(VM_ENTRY_CONTROLS) & ~(uint64)ENTRY_IA32E_MODE_GUEST;
    if(vm->efer & EFER_LMA)
      entryctl |= ENTRY_IA32E_MODE_GUEST;
    vmwrite(VM_ENTRY_CONTROLS, entryctl);
 8000010a3bb:	bf 12 40 00 00       	mov    $0x4012,%edi
 8000010a3c0:	48 b8 3c 94 10 00 00 	movabs $0x8000010943c,%rax
 8000010a3c7:	08 00 00 
 8000010a3ca:	ff d0                	call   *%rax
     * 0 means VMLAUNCH.  Because we VMCLEAR after every exit, the VMCS
     * is always in the clear state here, so we never use VMRESUME.
     * Returns 0 after a VM exit, or -1 if the entry instruction itself
     * failed (invalid controls or host/guest state).
     */
    r = vmx_enter(&vm->regs, 0);
 8000010a3cc:	48 8d 7b 30          	lea    0x30(%rbx),%rdi
 8000010a3d0:	be 00 00 00 00       	mov    $0x0,%esi
 8000010a3d5:	48 b8 f9 a6 10 00 00 	movabs $0x8000010a6f9,%rax
 8000010a3dc:	08 00 00 
 8000010a3df:	ff d0                	call   *%rax

    /*
     * Back in the host.  The VMCS is still current on this CPU, so
     * read everything we need now, before VMCLEAR.
     */
    if(r < 0){
 8000010a3e1:	85 c0                	test   %eax,%eax
 8000010a3e3:	0f 88 0b 02 00 00    	js     8000010a5f4 <vmrun+0x2ae>
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a3e9:	b8 02 44 00 00       	mov    $0x4402,%eax
 8000010a3ee:	0f 78 c0             	vmread %rax,%rax
       * Exit reason: bits 15:0 are the basic reason, and bit 31 is
       * set if this was a failed VM entry (SDM 30.2.1), for example
       * invalid guest state.
       */
      reason = vmread(VM_EXIT_REASON);
      e.reason = reason & 0xFFFF;
 8000010a3f1:	0f b7 d0             	movzwl %ax,%edx
 8000010a3f4:	89 55 a0             	mov    %edx,-0x60(%rbp)
      e.entryfail = (reason & EXIT_REASON_ENTRY_FAILURE) != 0;
 8000010a3f7:	c1 e8 1f             	shr    $0x1f,%eax
 8000010a3fa:	89 45 a4             	mov    %eax,-0x5c(%rbp)
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a3fd:	b8 00 64 00 00       	mov    $0x6400,%eax
 8000010a402:	0f 78 c0             	vmread %rax,%rax
      /* Extra detail whose meaning depends on the exit reason. */
      e.qual = vmread(EXIT_QUALIFICATION);
 8000010a405:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a409:	b8 04 44 00 00       	mov    $0x4404,%eax
 8000010a40e:	0f 78 c0             	vmread %rax,%rax
      e.intrinfo = vmread(VM_EXIT_INTR_INFO);
 8000010a411:	89 45 bc             	mov    %eax,-0x44(%rbp)
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a414:	b8 06 44 00 00       	mov    $0x4406,%eax
 8000010a419:	0f 78 c0             	vmread %rax,%rax
      e.intrerr = vmread(VM_EXIT_INTR_ERROR_CODE);
 8000010a41c:	89 45 c0             	mov    %eax,-0x40(%rbp)
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a41f:	b8 00 24 00 00       	mov    $0x2400,%eax
 8000010a424:	0f 78 c0             	vmread %rax,%rax
      /* Faulting guest-physical address, for EPT violations. */
      e.gpa = vmread(GUEST_PHYSICAL_ADDRESS);
 8000010a427:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a42b:	41 be 0c 44 00 00    	mov    $0x440c,%r14d
 8000010a431:	45 0f 78 f6          	vmread %r14,%r14
 8000010a435:	b8 1e 68 00 00       	mov    $0x681e,%eax
 8000010a43a:	0f 78 c0             	vmread %rax,%rax
      /* Length of the exiting instruction, to skip it. */
      inslen = vmread(VM_EXIT_INSTRUCTION_LEN);
      /* Save the guest state the processor stored in the VMCS. */
      vm->rip = vmread(GUEST_RIP);
 8000010a43d:	48 89 83 a8 00 00 00 	mov    %rax,0xa8(%rbx)
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a444:	ba 1c 68 00 00       	mov    $0x681c,%edx
 8000010a449:	0f 78 d2             	vmread %rdx,%rdx
      vm->rsp = vmread(GUEST_RSP);
 8000010a44c:	48 89 93 b0 00 00 00 	mov    %rdx,0xb0(%rbx)
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a453:	ba 20 68 00 00       	mov    $0x6820,%edx
 8000010a458:	0f 78 d2             	vmread %rdx,%rdx
      vm->rflags = vmread(GUEST_RFLAGS);
 8000010a45b:	48 89 93 b8 00 00 00 	mov    %rdx,0xb8(%rbx)
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a462:	ba 06 28 00 00       	mov    $0x2806,%edx
 8000010a467:	0f 78 d2             	vmread %rdx,%rdx
      /* Saved because of EXIT_SAVE_IA32_EFER; picks up a new LMA. */
      vm->efer = vmread(GUEST_IA32_EFER);
 8000010a46a:	48 89 93 c0 00 00 00 	mov    %rdx,0xc0(%rbx)
      e.rip = vm->rip;
 8000010a471:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    }
    /* Release the VMCS and turn interrupts back on (HW1 part 5, Step 8). */
    vmclear(V2P(vm->vmcs));
 8000010a475:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 8000010a47c:	f8 ff ff 
 8000010a47f:	48 03 43 10          	add    0x10(%rbx),%rax
 8000010a483:	48 89 45 90          	mov    %rax,-0x70(%rbp)
  asm volatile("vmclear %1; setna %0" : "=q" (fail) : "m" (pa) : "cc", "memory");
 8000010a487:	66 0f c7 75 90       	vmclear -0x70(%rbp)
 8000010a48c:	0f 96 c0             	setbe  %al
    popcli();  /* a pending host interrupt is delivered here */
 8000010a48f:	48 b8 31 54 10 00 00 	movabs $0x80000105431,%rax
 8000010a496:	08 00 00 
 8000010a499:	ff d0                	call   *%rax

    /*
     * Failed entries and VMLAUNCH failures always go to user space.
     * Otherwise vmxhandle() decides; returning 1 loops to re-enter.
     */
    if(e.reason == EXIT_VMFAIL || e.entryfail || !vmxhandle(vm, &e, inslen))
 8000010a49b:	81 7d a0 ff ff 00 00 	cmpl   $0xffff,-0x60(%rbp)
 8000010a4a2:	0f 84 74 01 00 00    	je     8000010a61c <vmrun+0x2d6>
 8000010a4a8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
 8000010a4ac:	0f 85 6a 01 00 00    	jne    8000010a61c <vmrun+0x2d6>
 8000010a4b2:	48 8d 75 a0          	lea    -0x60(%rbp),%rsi
 8000010a4b6:	44 89 f2             	mov    %r14d,%edx
 8000010a4b9:	48 89 df             	mov    %rbx,%rdi
 8000010a4bc:	48 b8 75 91 10 00 00 	movabs $0x80000109175,%rax
 8000010a4c3:	08 00 00 
 8000010a4c6:	ff d0                	call   *%rax
 8000010a4c8:	85 c0                	test   %eax,%eax
 8000010a4ca:	0f 84 4c 01 00 00    	je     8000010a61c <vmrun+0x2d6>
    if(myproc()->killed)
 8000010a4d0:	b0 00                	mov    $0x0,%al
 8000010a4d2:	48 ba 64 46 10 00 00 	movabs $0x80000104664,%rdx
 8000010a4d9:	08 00 00 
 8000010a4dc:	ff d2                	call   *%rdx
 8000010a4de:	44 8b 60 40          	mov    0x40(%rax),%r12d
 8000010a4e2:	45 85 e4             	test   %r12d,%r12d
 8000010a4e5:	0f 85 79 01 00 00    	jne    8000010a664 <vmrun+0x31e>
    memset(&e, 0, sizeof(e));
 8000010a4eb:	48 8d 7d a0          	lea    -0x60(%rbp),%rdi
 8000010a4ef:	ba 38 00 00 00       	mov    $0x38,%edx
 8000010a4f4:	be 00 00 00 00       	mov    $0x0,%esi
 8000010a4f9:	48 b8 00 56 10 00 00 	movabs $0x80000105600,%rax
 8000010a500:	08 00 00 
 8000010a503:	ff d0                	call   *%rax
    pushcli();
 8000010a505:	48 b8 d4 53 10 00 00 	movabs $0x800001053d4,%rax
 8000010a50c:	08 00 00 
 8000010a50f:	ff d0                	call   *%rax
    c = cpuid();
 8000010a511:	48 b8 3b 46 10 00 00 	movabs $0x8000010463b,%rax
 8000010a518:	08 00 00 
 8000010a51b:	ff d0                	call   *%rax
 8000010a51d:	89 c1                	mov    %eax,%ecx
    if(!cpus[c].vmx_ok || vmptrld(V2P(vm->vmcs)) < 0){
 8000010a51f:	48 98                	cltq
 8000010a521:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 8000010a525:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
 8000010a529:	48 b8 20 a0 11 00 00 	movabs $0x8000011a020,%rax
 8000010a530:	08 00 00 
 8000010a533:	83 bc d0 b4 00 00 00 	cmpl   $0x0,0xb4(%rax,%rdx,8)
 8000010a53a:	00 
 8000010a53b:	0f 84 3a fe ff ff    	je     8000010a37b <vmrun+0x35>
 8000010a541:	48 b8 00 00 00 00 00 	movabs $0xfffff80000000000,%rax
 8000010a548:	f8 ff ff 
 8000010a54b:	48 03 43 10          	add    0x10(%rbx),%rax
 8000010a54f:	48 89 45 90          	mov    %rax,-0x70(%rbp)
  asm volatile("vmptrld %1; setna %0" : "=q" (fail) : "m" (pa) : "cc", "memory");
 8000010a553:	0f c7 75 90          	vmptrld -0x70(%rbp)
 8000010a557:	0f 96 c0             	setbe  %al
  return fail ? -1 : 0;
 8000010a55a:	0f b6 c0             	movzbl %al,%eax
 8000010a55d:	85 c0                	test   %eax,%eax
 8000010a55f:	0f 85 16 fe ff ff    	jne    8000010a37b <vmrun+0x35>
    if(!(vm->flushed & (1 << c))){
 8000010a565:	b8 01 00 00 00       	mov    $0x1,%eax
 8000010a56a:	d3 e0                	shl    %cl,%eax
 8000010a56c:	85 83 c8 00 00 00    	test   %eax,0xc8(%rbx)
 8000010a572:	0f 84 1a fe ff ff    	je     8000010a392 <vmrun+0x4c>
    vmxhoststate();
 8000010a578:	48 b8 15 99 10 00 00 	movabs $0x80000109915,%rax
 8000010a57f:	08 00 00 
 8000010a582:	ff d0                	call   *%rax
    vmwrite(GUEST_RIP, vm->rip);
 8000010a584:	48 8b b3 a8 00 00 00 	mov    0xa8(%rbx),%rsi
 8000010a58b:	bf 1e 68 00 00       	mov    $0x681e,%edi
 8000010a590:	49 be 3c 94 10 00 00 	movabs $0x8000010943c,%r14
 8000010a597:	08 00 00 
 8000010a59a:	41 ff d6             	call   *%r14
    vmwrite(GUEST_RSP, vm->rsp);
 8000010a59d:	48 8b b3 b0 00 00 00 	mov    0xb0(%rbx),%rsi
 8000010a5a4:	bf 1c 68 00 00       	mov    $0x681c,%edi
 8000010a5a9:	41 ff d6             	call   *%r14
    vmwrite(GUEST_RFLAGS, vm->rflags);
 8000010a5ac:	48 8b b3 b8 00 00 00 	mov    0xb8(%rbx),%rsi
 8000010a5b3:	bf 20 68 00 00       	mov    $0x6820,%edi
 8000010a5b8:	41 ff d6             	call   *%r14
    vmwrite(GUEST_IA32_EFER, vm->efer);
 8000010a5bb:	48 8b b3 c0 00 00 00 	mov    0xc0(%rbx),%rsi
 8000010a5c2:	bf 06 28 00 00       	mov    $0x2806,%edi
 8000010a5c7:	41 ff d6             	call   *%r14
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a5ca:	b8 12 40 00 00       	mov    $0x4012,%eax
 8000010a5cf:	0f 78 c0             	vmread %rax,%rax
    entryctl = vmread(VM_ENTRY_CONTROLS) & ~(uint64)ENTRY_IA32E_MODE_GUEST;
 8000010a5d2:	48 89 c6             	mov    %rax,%rsi
 8000010a5d5:	48 81 e6 ff fd ff ff 	and    $0xfffffffffffffdff,%rsi
    if(vm->efer & EFER_LMA)
 8000010a5dc:	f6 83 c1 00 00 00 04 	testb  $0x4,0xc1(%rbx)
 8000010a5e3:	0f 84 d2 fd ff ff    	je     8000010a3bb <vmrun+0x75>
      entryctl |= ENTRY_IA32E_MODE_GUEST;
 8000010a5e9:	80 cc 02             	or     $0x2,%ah
 8000010a5ec:	48 89 c6             	mov    %rax,%rsi
 8000010a5ef:	e9 c7 fd ff ff       	jmp    8000010a3bb <vmrun+0x75>
      e.reason = EXIT_VMFAIL;
 8000010a5f4:	c7 45 a0 ff ff 00 00 	movl   $0xffff,-0x60(%rbp)
  asm volatile("vmread %1, %0" : "=r" (val) : "r" (field) : "cc");
 8000010a5fb:	b8 00 44 00 00       	mov    $0x4400,%eax
 8000010a600:	0f 78 c0             	vmread %rax,%rax
      e.error = vmread(VM_INSTRUCTION_ERROR);
 8000010a603:	89 45 b8             	mov    %eax,-0x48(%rbp)
      e.rip = vm->rip;
 8000010a606:	48 8b 83 a8 00 00 00 	mov    0xa8(%rbx),%rax
 8000010a60d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    inslen = 0;
 8000010a611:	41 be 00 00 00 00    	mov    $0x0,%r14d
 8000010a617:	e9 59 fe ff ff       	jmp    8000010a475 <vmrun+0x12f>
      break;
  }
  /* Report the exit that ended the loop to the user program. */
  *ue = e;
 8000010a61c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 8000010a620:	49 89 45 00          	mov    %rax,0x0(%r13)
 8000010a624:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
 8000010a628:	49 89 45 08          	mov    %rax,0x8(%r13)
 8000010a62c:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
 8000010a630:	49 89 45 10          	mov    %rax,0x10(%r13)
 8000010a634:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
 8000010a638:	49 89 45 18          	mov    %rax,0x18(%r13)
 8000010a63c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
 8000010a640:	49 89 45 20          	mov    %rax,0x20(%r13)
 8000010a644:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
 8000010a648:	49 89 45 28          	mov    %rax,0x28(%r13)
 8000010a64c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
 8000010a650:	49 89 45 30          	mov    %rax,0x30(%r13)
  return 0;
}
 8000010a654:	44 89 e0             	mov    %r12d,%eax
 8000010a657:	48 83 c4 50          	add    $0x50,%rsp
 8000010a65b:	5b                   	pop    %rbx
 8000010a65c:	41 5c                	pop    %r12
 8000010a65e:	41 5d                	pop    %r13
 8000010a660:	41 5e                	pop    %r14
 8000010a662:	5d                   	pop    %rbp
 8000010a663:	c3                   	ret
      return -1;
 8000010a664:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 8000010a66a:	eb e8                	jmp    8000010a654 <vmrun+0x30e>

000008000010a66c <vmxfreeproc>:
 * proc.c.  The process cannot be inside vmrun(), so no VMCS is
 * current, as vmfree() requires.
 */
void
vmxfreeproc(struct proc *p)
{
 8000010a66c:	55                   	push   %rbp
 8000010a66d:	48 89 e5             	mov    %rsp,%rbp
 8000010a670:	41 54                	push   %r12
 8000010a672:	53                   	push   %rbx
 8000010a673:	49 89 fc             	mov    %rdi,%r12
  int id;

  for(id = 0; id < NVM; id++)
 8000010a676:	bb 00 00 00 00       	mov    $0x0,%ebx
 8000010a67b:	eb 06                	jmp    8000010a683 <vmxfreeproc+0x17>
 8000010a67d:	0f 1f 00             	nopl   (%rax)
 8000010a680:	83 c3 01             	add    $0x1,%ebx
 8000010a683:	83 fb 03             	cmp    $0x3,%ebx
 8000010a686:	7f 6c                	jg     8000010a6f4 <vmxfreeproc+0x88>
    if(vms.vm[id].used && vms.vm[id].owner == p)
 8000010a688:	48 63 c3             	movslq %ebx,%rax
 8000010a68b:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 8000010a68f:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 8000010a693:	48 c1 e0 04          	shl    $0x4,%rax
 8000010a697:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 8000010a69e:	08 00 00 
 8000010a6a1:	83 7c 02 68 00       	cmpl   $0x0,0x68(%rdx,%rax,1)
 8000010a6a6:	74 d8                	je     8000010a680 <vmxfreeproc+0x14>
 8000010a6a8:	48 63 c3             	movslq %ebx,%rax
 8000010a6ab:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 8000010a6af:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 8000010a6b3:	48 c1 e0 04          	shl    $0x4,%rax
 8000010a6b7:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 8000010a6be:	08 00 00 
 8000010a6c1:	4c 39 64 02 70       	cmp    %r12,0x70(%rdx,%rax,1)
 8000010a6c6:	75 b8                	jne    8000010a680 <vmxfreeproc+0x14>
      vmfree(&vms.vm[id]);
 8000010a6c8:	48 63 c3             	movslq %ebx,%rax
 8000010a6cb:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
 8000010a6cf:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
 8000010a6d3:	48 c1 e0 04          	shl    $0x4,%rax
 8000010a6d7:	48 ba a0 08 11 00 00 	movabs $0x800001108a0,%rdx
 8000010a6de:	08 00 00 
 8000010a6e1:	48 8d 7c 02 68       	lea    0x68(%rdx,%rax,1),%rdi
 8000010a6e6:	48 b8 e1 9a 10 00 00 	movabs $0x80000109ae1,%rax
 8000010a6ed:	08 00 00 
 8000010a6f0:	ff d0                	call   *%rax
 8000010a6f2:	eb 8c                	jmp    8000010a680 <vmxfreeproc+0x14>
}
 8000010a6f4:	5b                   	pop    %rbx
 8000010a6f5:	41 5c                	pop    %r12
 8000010a6f7:	5d                   	pop    %rbp
 8000010a6f8:	c3                   	ret

000008000010a6f9 <vmx_enter>:
  # YOUR CODE, block A (HW1 part 4): save the host's callee-saved
  # registers and regs on the stack, and write %rsp into the VMCS field
  # HOST_RSP.
  #   example, one line of it:  pushq %rbp   (saves the host's %rbp)
  
  pushq %rbp
 8000010a6f9:	55                   	push   %rbp
  pushq %rbx
 8000010a6fa:	53                   	push   %rbx
  pushq %r12
 8000010a6fb:	41 54                	push   %r12
  pushq %r13
 8000010a6fd:	41 55                	push   %r13
  pushq %r14
 8000010a6ff:	41 56                	push   %r14
  pushq %r15
 8000010a701:	41 57                	push   %r15
  pushq %rdi
 8000010a703:	57                   	push   %rdi

  movq $HOST_RSP, %rax
 8000010a704:	48 c7 c0 14 6c 00 00 	mov    $0x6c14,%rax
  vmwrite %rsp, %rax
 8000010a70b:	0f 79 c4             	vmwrite %rsp,%rax
  # Test 'launched' now: the movs below don't change the flags.
  # %esi is about to be overwritten by the guest's RSI, so its zero /
  # non-zero state is captured in ZF here. ZF = 1 means launched == 0
  # (first entry, use VMLAUNCH); ZF = 0 means VMRESUME. No instruction
  # between here and the jnz modifies RFLAGS (mov does not).
  testl %esi, %esi
 8000010a70e:	85 f6                	test   %esi,%esi
  # registers from *regs (%rdi). Use only mov instructions here: the
  # flags set by the testl above must survive until the jnz below.
  #   example, one line of it:  movq 8(%rdi), %rbx
  #   (%rbx = the 8 bytes at address regs + 8: the guest's rbx)

  movq 0(%rdi), %rax
 8000010a710:	48 8b 07             	mov    (%rdi),%rax
  movq 8(%rdi), %rbx
 8000010a713:	48 8b 5f 08          	mov    0x8(%rdi),%rbx
  movq 16(%rdi), %rcx
 8000010a717:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
  movq 24(%rdi), %rdx
 8000010a71b:	48 8b 57 18          	mov    0x18(%rdi),%rdx
  movq 32(%rdi), %rsi
 8000010a71f:	48 8b 77 20          	mov    0x20(%rdi),%rsi
  movq 48(%rdi), %rbp
 8000010a723:	48 8b 6f 30          	mov    0x30(%rdi),%rbp
  movq 56(%rdi), %r8
 8000010a727:	4c 8b 47 38          	mov    0x38(%rdi),%r8
  movq 64(%rdi), %r9
 8000010a72b:	4c 8b 4f 40          	mov    0x40(%rdi),%r9
  movq 72(%rdi), %r10
 8000010a72f:	4c 8b 57 48          	mov    0x48(%rdi),%r10
  movq 80(%rdi), %r11
 8000010a733:	4c 8b 5f 50          	mov    0x50(%rdi),%r11
  movq 88(%rdi), %r12
 8000010a737:	4c 8b 67 58          	mov    0x58(%rdi),%r12
  movq 96(%rdi), %r13
 8000010a73b:	4c 8b 6f 60          	mov    0x60(%rdi),%r13
  movq 104(%rdi), %r14
 8000010a73f:	4c 8b 77 68          	mov    0x68(%rdi),%r14
  movq 112(%rdi), %r15
 8000010a743:	4c 8b 7f 70          	mov    0x70(%rdi),%r15
  movq 40(%rdi), %rdi
 8000010a747:	48 8b 7f 28          	mov    0x28(%rdi),%rdi

  # Enter the guest. ZF still holds the result of testl above.
  jnz   1f                    # launched != 0: already launched, resume
 8000010a74b:	75 05                	jne    8000010a752 <vmx_enter+0x59>
  # launch state is "clear"); VMRESUME is required afterwards. The
  # wrong one fails with a VM-instruction error. Because vmrun
  # VMCLEARs the VMCS after every exit, it always passes launched = 0.
  # On success neither instruction falls through: the guest starts
  # running and control returns only via a VM exit to vmx_exit.
  vmlaunch
 8000010a74d:	0f 01 c2             	vmlaunch
  jmp   2f                    # reached only if VMLAUNCH failed
 8000010a750:	eb 03                	jmp    8000010a755 <vmx_enter+0x5c>
1:
  vmresume                    # reached only if launched != 0
 8000010a752:	0f 01 c3             	vmresume
  # CF = 1 is "VMfailInvalid" (no current VMCS), ZF = 1 is
  # "VMfailValid" (error number in VM_INSTRUCTION_ERROR). We do not
  # look at the flags: reaching this line at all means failure, and
  # the C caller reads VM_INSTRUCTION_ERROR. The guest has not run, so
  # *regs was not modified. Unwind exactly what we pushed:
  addq  $8, %rsp              # drop the saved regs pointer
 8000010a755:	48 83 c4 08          	add    $0x8,%rsp
  popq  %r15                  # restore host callee-saved registers,
 8000010a759:	41 5f                	pop    %r15
  popq  %r14                  # in reverse order of the pushes
 8000010a75b:	41 5e                	pop    %r14
  popq  %r13
 8000010a75d:	41 5d                	pop    %r13
  popq  %r12
 8000010a75f:	41 5c                	pop    %r12
  popq  %rbx
 8000010a761:	5b                   	pop    %rbx
  popq  %rbp
 8000010a762:	5d                   	pop    %rbp
  movl  $-1, %eax             # return value: -1 means entry failed
 8000010a763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ret                         # back to the C caller, on its stack
 8000010a768:	c3                   	ret

000008000010a769 <vmx_exit>:
  # registers into *regs, restore the host's callee-saved registers,
  # return 0 from vmx_enter.
  #   example, one line of it:  movq %rbx, 8(%rdi)
  #   (the 8 bytes at address regs + 8 = the guest's rbx, if %rdi = regs)
  
  pushq %rdi
 8000010a769:	57                   	push   %rdi
  movq 8(%rsp), %rdi
 8000010a76a:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  movq %rax, 0(%rdi)
 8000010a76f:	48 89 07             	mov    %rax,(%rdi)
  movq %rbx, 8(%rdi)
 8000010a772:	48 89 5f 08          	mov    %rbx,0x8(%rdi)
  movq %rcx, 16(%rdi)
 8000010a776:	48 89 4f 10          	mov    %rcx,0x10(%rdi)
  movq %rdx, 24(%rdi)
 8000010a77a:	48 89 57 18          	mov    %rdx,0x18(%rdi)
  movq %rsi, 32(%rdi)
 8000010a77e:	48 89 77 20          	mov    %rsi,0x20(%rdi)
  movq %rbp, 48(%rdi)
 8000010a782:	48 89 6f 30          	mov    %rbp,0x30(%rdi)
  movq %r8, 56(%rdi)
 8000010a786:	4c 89 47 38          	mov    %r8,0x38(%rdi)
  movq %r9, 64(%rdi)
 8000010a78a:	4c 89 4f 40          	mov    %r9,0x40(%rdi)
  movq %r10, 72(%rdi)
 8000010a78e:	4c 89 57 48          	mov    %r10,0x48(%rdi)
  movq %r11, 80(%rdi)
 8000010a792:	4c 89 5f 50          	mov    %r11,0x50(%rdi)
  movq %r12, 88(%rdi)
 8000010a796:	4c 89 67 58          	mov    %r12,0x58(%rdi)
  movq %r13, 96(%rdi)
 8000010a79a:	4c 89 6f 60          	mov    %r13,0x60(%rdi)
  movq %r14, 104(%rdi)
 8000010a79e:	4c 89 77 68          	mov    %r14,0x68(%rdi)
  movq %r15, 112(%rdi)
 8000010a7a2:	4c 89 7f 70          	mov    %r15,0x70(%rdi)

  popq %rax
 8000010a7a6:	58                   	pop    %rax
  movq %rax, 40(%rdi)
 8000010a7a7:	48 89 47 28          	mov    %rax,0x28(%rdi)

  addq $8, %rsp
 8000010a7ab:	48 83 c4 08          	add    $0x8,%rsp
  popq %r15
 8000010a7af:	41 5f                	pop    %r15
  popq %r14
 8000010a7b1:	41 5e                	pop    %r14
  popq %r13
 8000010a7b3:	41 5d                	pop    %r13
  popq %r12
 8000010a7b5:	41 5c                	pop    %r12
  popq %rbx
 8000010a7b7:	5b                   	pop    %rbx
  popq %rbp
 8000010a7b8:	5d                   	pop    %rbp
  xorl %eax, %eax
 8000010a7b9:	31 c0                	xor    %eax,%eax
  ret
 8000010a7bb:	c3                   	ret

000008000010a7bc <sys_vmcreate>:
// is kernel memory, not a user buffer); vmcreate() in vmx.c checks
// that it is in range (0 < memsz <= VM_MAXMEM) and large enough
// to hold the image. The '||' chain stops at the first failure.
uint64
sys_vmcreate(void)
{
 8000010a7bc:	55                   	push   %rbp
 8000010a7bd:	48 89 e5             	mov    %rsp,%rbp
 8000010a7c0:	48 83 ec 10          	sub    $0x10,%rsp
  char *image;
  int len, memsz;

  if(argint(1, &len) < 0 || argptr(0, &image, len) < 0 || argint(2, &memsz) < 0)
 8000010a7c4:	48 8d 75 f4          	lea    -0xc(%rbp),%rsi
 8000010a7c8:	bf 01 00 00 00       	mov    $0x1,%edi
 8000010a7cd:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 8000010a7d4:	08 00 00 
 8000010a7d7:	ff d0                	call   *%rax
 8000010a7d9:	85 c0                	test   %eax,%eax
 8000010a7db:	78 4f                	js     8000010a82c <sys_vmcreate+0x70>
 8000010a7dd:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
 8000010a7e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
 8000010a7e4:	bf 00 00 00 00       	mov    $0x0,%edi
 8000010a7e9:	48 b8 bf 59 10 00 00 	movabs $0x800001059bf,%rax
 8000010a7f0:	08 00 00 
 8000010a7f3:	ff d0                	call   *%rax
 8000010a7f5:	85 c0                	test   %eax,%eax
 8000010a7f7:	78 33                	js     8000010a82c <sys_vmcreate+0x70>
 8000010a7f9:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
 8000010a7fd:	bf 02 00 00 00       	mov    $0x2,%edi
 8000010a802:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 8000010a809:	08 00 00 
 8000010a80c:	ff d0                	call   *%rax
 8000010a80e:	85 c0                	test   %eax,%eax
 8000010a810:	78 1a                	js     8000010a82c <sys_vmcreate+0x70>
    return -1;
  return vmcreate(image, len, memsz);
 8000010a812:	8b 55 f0             	mov    -0x10(%rbp),%edx
 8000010a815:	8b 75 f4             	mov    -0xc(%rbp),%esi
 8000010a818:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
 8000010a81c:	48 b8 21 9d 10 00 00 	movabs $0x80000109d21,%rax
 8000010a823:	08 00 00 
 8000010a826:	ff d0                	call   *%rax
 8000010a828:	48 98                	cltq
 8000010a82a:	eb 07                	jmp    8000010a833 <sys_vmcreate+0x77>
    return -1;
 8000010a82c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
 8000010a833:	48 89 ec             	mov    %rbp,%rsp
 8000010a836:	5d                   	pop    %rbp
 8000010a837:	c3                   	ret

000008000010a838 <sys_vmsetreg>:
// would truncate it to 32 bits. vm and reg are small and fit in an
// int. The value is declared signed (int64) only because argint64()
// takes an int64 pointer; vmsetreg() takes it as a uint64.
uint64
sys_vmsetreg(void)
{
 8000010a838:	55                   	push   %rbp
 8000010a839:	48 89 e5             	mov    %rsp,%rbp
 8000010a83c:	48 83 ec 10          	sub    $0x10,%rsp
  int vm, reg;
  int64 val;

  if(argint(0, &vm) < 0 || argint(1, &reg) < 0 || argint64(2, &val) < 0)
 8000010a840:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 8000010a844:	bf 00 00 00 00       	mov    $0x0,%edi
 8000010a849:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 8000010a850:	08 00 00 
 8000010a853:	ff d0                	call   *%rax
 8000010a855:	85 c0                	test   %eax,%eax
 8000010a857:	78 4c                	js     8000010a8a5 <sys_vmsetreg+0x6d>
 8000010a859:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
 8000010a85d:	bf 01 00 00 00       	mov    $0x1,%edi
 8000010a862:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 8000010a869:	08 00 00 
 8000010a86c:	ff d0                	call   *%rax
 8000010a86e:	85 c0                	test   %eax,%eax
 8000010a870:	78 33                	js     8000010a8a5 <sys_vmsetreg+0x6d>
 8000010a872:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
 8000010a876:	bf 02 00 00 00       	mov    $0x2,%edi
 8000010a87b:	48 b8 c5 58 10 00 00 	movabs $0x800001058c5,%rax
 8000010a882:	08 00 00 
 8000010a885:	ff d0                	call   *%rax
 8000010a887:	85 c0                	test   %eax,%eax
 8000010a889:	78 1a                	js     8000010a8a5 <sys_vmsetreg+0x6d>
    return -1;
  return vmsetreg(vm, reg, val);
 8000010a88b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
 8000010a88f:	8b 75 f8             	mov    -0x8(%rbp),%esi
 8000010a892:	8b 7d fc             	mov    -0x4(%rbp),%edi
 8000010a895:	48 b8 3c a2 10 00 00 	movabs $0x8000010a23c,%rax
 8000010a89c:	08 00 00 
 8000010a89f:	ff d0                	call   *%rax
 8000010a8a1:	48 98                	cltq
 8000010a8a3:	eb 07                	jmp    8000010a8ac <sys_vmsetreg+0x74>
    return -1;
 8000010a8a5:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
 8000010a8ac:	48 89 ec             	mov    %rbp,%rsp
 8000010a8af:	5d                   	pop    %rbp
 8000010a8b0:	c3                   	ret

000008000010a8b1 <sys_vmgetreg>:
//
// val is an output pointer, so argptr() checks that all 8 bytes lie
// inside the process's address space before vmgetreg() stores to it.
uint64
sys_vmgetreg(void)
{
 8000010a8b1:	55                   	push   %rbp
 8000010a8b2:	48 89 e5             	mov    %rsp,%rbp
 8000010a8b5:	48 83 ec 10          	sub    $0x10,%rsp
  int vm, reg;
  char *val;

  if(argint(0, &vm) < 0 || argint(1, &reg) < 0 ||
 8000010a8b9:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 8000010a8bd:	bf 00 00 00 00       	mov    $0x0,%edi
 8000010a8c2:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 8000010a8c9:	08 00 00 
 8000010a8cc:	ff d0                	call   *%rax
 8000010a8ce:	85 c0                	test   %eax,%eax
 8000010a8d0:	78 51                	js     8000010a923 <sys_vmgetreg+0x72>
 8000010a8d2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
 8000010a8d6:	bf 01 00 00 00       	mov    $0x1,%edi
 8000010a8db:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 8000010a8e2:	08 00 00 
 8000010a8e5:	ff d0                	call   *%rax
 8000010a8e7:	85 c0                	test   %eax,%eax
 8000010a8e9:	78 38                	js     8000010a923 <sys_vmgetreg+0x72>
     argptr(2, &val, sizeof(uint64)) < 0)
 8000010a8eb:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
 8000010a8ef:	ba 08 00 00 00       	mov    $0x8,%edx
 8000010a8f4:	bf 02 00 00 00       	mov    $0x2,%edi
 8000010a8f9:	48 b8 bf 59 10 00 00 	movabs $0x800001059bf,%rax
 8000010a900:	08 00 00 
 8000010a903:	ff d0                	call   *%rax
  if(argint(0, &vm) < 0 || argint(1, &reg) < 0 ||
 8000010a905:	85 c0                	test   %eax,%eax
 8000010a907:	78 1a                	js     8000010a923 <sys_vmgetreg+0x72>
    return -1;
  return vmgetreg(vm, reg, (uint64*)val);
 8000010a909:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
 8000010a90d:	8b 75 f8             	mov    -0x8(%rbp),%esi
 8000010a910:	8b 7d fc             	mov    -0x4(%rbp),%edi
 8000010a913:	48 b8 bb a2 10 00 00 	movabs $0x8000010a2bb,%rax
 8000010a91a:	08 00 00 
 8000010a91d:	ff d0                	call   *%rax
 8000010a91f:	48 98                	cltq
 8000010a921:	eb 07                	jmp    8000010a92a <sys_vmgetreg+0x79>
    return -1;
 8000010a923:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
 8000010a92a:	48 89 ec             	mov    %rbp,%rsp
 8000010a92d:	5d                   	pop    %rbp
 8000010a92e:	c3                   	ret

000008000010a92f <sys_vmrun>:
// pointer as a char*, which is how it reports a block of memory.
// The variable is named 'exit' to match the user-level prototype; it
// shadows nothing inside this function.
uint64
sys_vmrun(void)
{
 8000010a92f:	55                   	push   %rbp
 8000010a930:	48 89 e5             	mov    %rsp,%rbp
 8000010a933:	48 83 ec 10          	sub    $0x10,%rsp
  int vm;
  char *exit;

  if(argint(0, &vm) < 0 || argptr(1, &exit, sizeof(struct vmexit)) < 0)
 8000010a937:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 8000010a93b:	bf 00 00 00 00       	mov    $0x0,%edi
 8000010a940:	48 b8 96 59 10 00 00 	movabs $0x80000105996,%rax
 8000010a947:	08 00 00 
 8000010a94a:	ff d0                	call   *%rax
 8000010a94c:	85 c0                	test   %eax,%eax
 8000010a94e:	78 38                	js     8000010a988 <sys_vmrun+0x59>
 8000010a950:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
 8000010a954:	ba 38 00 00 00       	mov    $0x38,%edx
 8000010a959:	bf 01 00 00 00       	mov    $0x1,%edi
 8000010a95e:	48 b8 bf 59 10 00 00 	movabs $0x800001059bf,%rax
 8000010a965:	08 00 00 
 8000010a968:	ff d0                	call   *%rax
 8000010a96a:	85 c0                	test   %eax,%eax
 8000010a96c:	78 1a                	js     8000010a988 <sys_vmrun+0x59>
    return -1;
  return vmrun(vm, (struct vmexit*)exit);
 8000010a96e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
 8000010a972:	8b 7d fc             	mov    -0x4(%rbp),%edi
 8000010a975:	48 b8 46 a3 10 00 00 	movabs $0x8000010a346,%rax
 8000010a97c:	08 00 00 
 8000010a97f:	ff d0                	call   *%rax
 8000010a981:	48 98                	cltq
}
 8000010a983:	48 89 ec             	mov    %rbp,%rsp
 8000010a986:	5d                   	pop    %rbp
 8000010a987:	c3                   	ret
    return -1;
 8000010a988:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 8000010a98f:	eb f2                	jmp    8000010a983 <sys_vmrun+0x54>
