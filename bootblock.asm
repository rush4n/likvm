
bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable
    7c00:	fa                   	cli

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
    7c01:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c03:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c05:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c07:	8e d0                	mov    %eax,%ss

00007c09 <seta20.1>:

  # Physical address line A20 is tied to zero so that the first PCs 
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c09:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0b:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0d:	75 fa                	jne    7c09 <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c0f:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c11:	e6 64                	out    %al,$0x64

00007c13 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c13:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c15:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c17:	75 fa                	jne    7c13 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c19:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1b:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
    7c1d:	0f 01 16             	lgdtl  (%esi)
    7c20:	78 7c                	js     7c9e <readsect+0xf>
  movl    %cr0, %eax
    7c22:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE, %eax
    7c25:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c29:	0f 22 c0             	mov    %eax,%cr0

//PAGEBREAK!
  # Complete the transition to 32-bit protected mode by using a long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32
    7c2c:	ea                   	.byte 0xea
    7c2d:	31 7c 08 00          	xor    %edi,0x0(%eax,%ecx,1)

00007c31 <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
    7c31:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c35:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c37:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7c39:	8e d0                	mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
    7c3b:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
    7c3f:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c41:	8e e8                	mov    %eax,%gs

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c43:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call    bootmain
    7c48:	e8 ed 00 00 00       	call   7d3a <bootmain>

  # If bootmain returns (it shouldn't), trigger a Bochs
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
    7c4d:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
    7c51:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
    7c54:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
    7c56:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
    7c5a:	66 ef                	out    %ax,(%dx)

00007c5c <spin>:
spin:
  jmp     spin
    7c5c:	eb fe                	jmp    7c5c <spin>
    7c5e:	66 90                	xchg   %ax,%ax

00007c60 <gdt>:
	...
    7c68:	ff                   	(bad)
    7c69:	ff 00                	incl   (%eax)
    7c6b:	00 00                	add    %al,(%eax)
    7c6d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c74:	00                   	.byte 0
    7c75:	92                   	xchg   %eax,%edx
    7c76:	cf                   	iret
	...

00007c78 <gdtdesc>:
    7c78:	17                   	pop    %ss
    7c79:	00 60 7c             	add    %ah,0x7c(%eax)
	...

00007c7e <waitdisk>:
static inline uchar
inb(ushort port)
{
    uchar data;

    asm volatile("in %1,%0" : "=a" (data) : "d" (port));
    7c7e:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c83:	ec                   	in     (%dx),%al

void
waitdisk(void)
{
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7c84:	25 c0 00 00 00       	and    $0xc0,%eax
    7c89:	83 f8 40             	cmp    $0x40,%eax
    7c8c:	75 f5                	jne    7c83 <waitdisk+0x5>
    ;
}
    7c8e:	c3                   	ret

00007c8f <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
    7c8f:	55                   	push   %ebp
    7c90:	89 e5                	mov    %esp,%ebp
    7c92:	57                   	push   %edi
    7c93:	53                   	push   %ebx
    7c94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  // Issue command.
  waitdisk();
    7c97:	e8 e2 ff ff ff       	call   7c7e <waitdisk>
}

static inline void
outb(ushort port, uchar data)
{
    asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7c9c:	b0 01                	mov    $0x1,%al
    7c9e:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7ca3:	ee                   	out    %al,(%dx)
    7ca4:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7ca9:	88 d8                	mov    %bl,%al
    7cab:	ee                   	out    %al,(%dx)
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
    7cac:	89 d8                	mov    %ebx,%eax
    7cae:	c1 e8 08             	shr    $0x8,%eax
    7cb1:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cb6:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
    7cb7:	89 d8                	mov    %ebx,%eax
    7cb9:	c1 e8 10             	shr    $0x10,%eax
    7cbc:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7cc1:	ee                   	out    %al,(%dx)
  outb(0x1F6, (offset >> 24) | 0xE0);
    7cc2:	89 d8                	mov    %ebx,%eax
    7cc4:	c1 e8 18             	shr    $0x18,%eax
    7cc7:	83 c8 e0             	or     $0xffffffe0,%eax
    7cca:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7ccf:	ee                   	out    %al,(%dx)
    7cd0:	b0 20                	mov    $0x20,%al
    7cd2:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cd7:	ee                   	out    %al,(%dx)
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7cd8:	e8 a1 ff ff ff       	call   7c7e <waitdisk>
    asm volatile("cld; rep insl" :
    7cdd:	8b 7d 08             	mov    0x8(%ebp),%edi
    7ce0:	b9 80 00 00 00       	mov    $0x80,%ecx
    7ce5:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cea:	fc                   	cld
    7ceb:	f3 6d                	rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7ced:	5b                   	pop    %ebx
    7cee:	5f                   	pop    %edi
    7cef:	5d                   	pop    %ebp
    7cf0:	c3                   	ret

00007cf1 <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
    7cf1:	55                   	push   %ebp
    7cf2:	89 e5                	mov    %esp,%ebp
    7cf4:	57                   	push   %edi
    7cf5:	56                   	push   %esi
    7cf6:	53                   	push   %ebx
    7cf7:	83 ec 0c             	sub    $0xc,%esp
    7cfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7cfd:	8b 75 10             	mov    0x10(%ebp),%esi
  uchar* epa;

  epa = pa + count;
    7d00:	89 df                	mov    %ebx,%edi
    7d02:	03 7d 0c             	add    0xc(%ebp),%edi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7d05:	89 f0                	mov    %esi,%eax
    7d07:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d0c:	29 c3                	sub    %eax,%ebx

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d0e:	c1 ee 09             	shr    $0x9,%esi
    7d11:	83 c6 01             	add    $0x1,%esi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d14:	39 fb                	cmp    %edi,%ebx
    7d16:	73 1a                	jae    7d32 <readseg+0x41>
    readsect(pa, offset);
    7d18:	83 ec 08             	sub    $0x8,%esp
    7d1b:	56                   	push   %esi
    7d1c:	53                   	push   %ebx
    7d1d:	e8 6d ff ff ff       	call   7c8f <readsect>
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d22:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d28:	83 c6 01             	add    $0x1,%esi
    7d2b:	83 c4 10             	add    $0x10,%esp
    7d2e:	39 fb                	cmp    %edi,%ebx
    7d30:	72 e6                	jb     7d18 <readseg+0x27>
}
    7d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d35:	5b                   	pop    %ebx
    7d36:	5e                   	pop    %esi
    7d37:	5f                   	pop    %edi
    7d38:	5d                   	pop    %ebp
    7d39:	c3                   	ret

00007d3a <bootmain>:
{
    7d3a:	55                   	push   %ebp
    7d3b:	89 e5                	mov    %esp,%ebp
    7d3d:	57                   	push   %edi
    7d3e:	56                   	push   %esi
    7d3f:	53                   	push   %ebx
    7d40:	83 ec 10             	sub    $0x10,%esp
  readseg((uchar*)elf, 4096, 0);
    7d43:	6a 00                	push   $0x0
    7d45:	68 00 10 00 00       	push   $0x1000
    7d4a:	68 00 00 01 00       	push   $0x10000
    7d4f:	e8 9d ff ff ff       	call   7cf1 <readseg>
  if(elf->magic != ELF_MAGIC)
    7d54:	83 c4 10             	add    $0x10,%esp
    7d57:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d5e:	45 4c 46 
    7d61:	75 21                	jne    7d84 <bootmain+0x4a>
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d63:	a1 20 00 01 00       	mov    0x10020,%eax
    7d68:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
  eph = ph + elf->phnum;
    7d6e:	0f b7 35 38 00 01 00 	movzwl 0x10038,%esi
    7d75:	6b f6 38             	imul   $0x38,%esi,%esi
    7d78:	01 de                	add    %ebx,%esi
  for(; ph < eph; ph++){
    7d7a:	39 f3                	cmp    %esi,%ebx
    7d7c:	72 15                	jb     7d93 <bootmain+0x59>
  entry();
    7d7e:	ff 15 18 00 01 00    	call   *0x10018
}
    7d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d87:	5b                   	pop    %ebx
    7d88:	5e                   	pop    %esi
    7d89:	5f                   	pop    %edi
    7d8a:	5d                   	pop    %ebp
    7d8b:	c3                   	ret
  for(; ph < eph; ph++){
    7d8c:	83 c3 38             	add    $0x38,%ebx
    7d8f:	39 f3                	cmp    %esi,%ebx
    7d91:	73 eb                	jae    7d7e <bootmain+0x44>
    pa = (uchar*)((uint32) ph->paddr);
    7d93:	8b 7b 18             	mov    0x18(%ebx),%edi
    readseg(pa, ph->filesz, ph->off);
    7d96:	83 ec 04             	sub    $0x4,%esp
    7d99:	ff 73 08             	push   0x8(%ebx)
    7d9c:	ff 73 20             	push   0x20(%ebx)
    7d9f:	57                   	push   %edi
    7da0:	e8 4c ff ff ff       	call   7cf1 <readseg>
    if(ph->memsz > ph->filesz)
    7da5:	8b 4b 28             	mov    0x28(%ebx),%ecx
    7da8:	8b 43 20             	mov    0x20(%ebx),%eax
    7dab:	8b 53 24             	mov    0x24(%ebx),%edx
    7dae:	83 c4 10             	add    $0x10,%esp
    7db1:	39 c8                	cmp    %ecx,%eax
    7db3:	1b 53 2c             	sbb    0x2c(%ebx),%edx
    7db6:	73 d4                	jae    7d8c <bootmain+0x52>
      stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
    7db8:	01 c7                	add    %eax,%edi
    7dba:	29 c1                	sub    %eax,%ecx
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
    7dbc:	b8 00 00 00 00       	mov    $0x0,%eax
    7dc1:	fc                   	cld
    7dc2:	f3 aa                	rep stos %al,%es:(%edi)
            "=D" (addr), "=c" (cnt) :
            "0" (addr), "1" (cnt), "a" (data) :
            "memory", "cc");
}
    7dc4:	eb c6                	jmp    7d8c <bootmain+0x52>
