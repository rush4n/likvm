
bootblockother.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000007000 <start>:
# This code combines elements of bootasm.S and entry.S.

.code16           
.globl start
start:
  cli            
    7000:	fa                   	cli

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax
    7001:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds
    7003:	8e d8                	mov    %eax,%ds
  movw    %ax,%es
    7005:	8e c0                	mov    %eax,%es
  movw    %ax,%ss
    7007:	8e d0                	mov    %eax,%ss

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
    7009:	0f 01 16             	lgdt   (%rsi)
    700c:	a8 70                	test   $0x70,%al
  movl    %cr0, %eax
    700e:	0f 20 c0             	mov    %cr0,%rax
  orl     $CR0_PE, %eax
    7011:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7015:	0f 22 c0             	mov    %rax,%cr0

  # Complete the transition to 32-bit protected mode by using a long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmpl    $(SEG_KCODE<<3), $(start32)
    7018:	66 ea                	data16 (bad)
    701a:	20 70 00             	and    %dh,0x0(%rax)
    701d:	00 08                	add    %cl,(%rax)
	...

0000000000007020 <start32>:

//PAGEBREAK!
.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
    7020:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7024:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7026:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7028:	8e d0                	mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
    702a:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
    702e:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7030:	8e e8                	mov    %eax,%gs

  # Enable physical-address extensions (PAE).
  movl    %cr4, %eax
    7032:	0f 20 e0             	mov    %cr4,%rax
  orl     $(CR4_PAE), %eax
    7035:	83 c8 20             	or     $0x20,%eax
  movl    %eax, %cr4
    7038:	0f 22 e0             	mov    %rax,%cr4

  # Use entrypml4 as our initial page table
  movl    (start-20), %eax
    703b:	a1 ec 6f 00 00 0f 22 	movabs 0xb9d8220f00006fec,%eax
    7042:	d8 b9 
  movl    %eax, %cr3

  # Enable IA-32e mode by setting IA32_EFER.LME = 1.
  movl    $EFER_MSR, %ecx
    7044:	80 00 00             	addb   $0x0,(%rax)
    7047:	c0 0f 32             	rorb   $0x32,(%rdi)
  rdmsr
  orl     $EFER_MSR_LME, %eax
    704a:	0d 00 01 00 00       	or     $0x100,%eax
  wrmsr
    704f:	0f 30                	wrmsr

  # Enable paging. 
  # This causes the processor to set the IA32_EFER.LMA bit to 1.
  movl    %cr0, %eax
    7051:	0f 20 c0             	mov    %cr0,%rax
  orl     $CR0_PG, %eax
    7054:	0d 00 00 00 80       	or     $0x80000000,%eax
  movl    %eax, %cr0
    7059:	0f 22 c0             	mov    %rax,%cr0

  # We are now in the 32-bit compatibility submode of IA-32e mode.
  # To complete the transition to 64-bit submode, we have to load a gdt 
  # with the 64-bit flag set (in the code segment), and then use 
  # a far jump to reload %cs and %rip.
  lgdt    gdt64desc
    705c:	0f 01 15 c8 70 00 00 	lgdt   0x70c8(%rip)        # e12b <_end+0x7053>
  ljmp    $(SEG_KCODE<<3), $(start64)
    7063:	ea                   	(bad)
    7064:	70 70                	jo     70d6 <__bss_start+0x4>
    7066:	00 00                	add    %al,(%rax)
    7068:	08 00                	or     %al,(%rax)
    706a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000007070 <start64>:

  .p2align 4
  .code64 # Tell assembler to generate 64-bit code now.
  start64:
    # Switch to the stack allocated by startothers()
    movq    (start-8), %rsp
    7070:	48 8b 24 25 f8 6f 00 	mov    0x6ff8,%rsp
    7077:	00 
    # Call mpenter()
    call	 *(start-16)
    7078:	ff 14 25 f0 6f 00 00 	call   *0x6ff0

  movw    $0x8a00, %ax
    707f:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
    7083:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
    7086:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax
    7088:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
    708c:	66 ef                	out    %ax,(%dx)

000000000000708e <spin>:
spin:
  jmp     spin
    708e:	eb fe                	jmp    708e <spin>

0000000000007090 <gdt>:
	...
    7098:	ff                   	(bad)
    7099:	ff 00                	incl   (%rax)
    709b:	00 00                	add    %al,(%rax)
    709d:	9a                   	(bad)
    709e:	cf                   	iret
    709f:	00 ff                	add    %bh,%bh
    70a1:	ff 00                	incl   (%rax)
    70a3:	00 00                	add    %al,(%rax)
    70a5:	92                   	xchg   %eax,%edx
    70a6:	cf                   	iret
	...

00000000000070a8 <gdtdesc>:
    70a8:	17                   	(bad)
    70a9:	00 90 70 00 00 90    	add    %dl,-0x6fffff90(%rax)
    70af:	90                   	nop

00000000000070b0 <gdt64>:
	...
    70bc:	00 9a 20 00 00 00    	add    %bl,0x20(%rdx)
    70c2:	00 00                	add    %al,(%rax)
    70c4:	00                   	.byte 0
    70c5:	92                   	xchg   %eax,%edx
	...

00000000000070c8 <gdt64desc>:
    70c8:	17                   	(bad)
    70c9:	00 b0 70 00 00 00    	add    %dh,0x70(%rax)
    70cf:	00 00                	add    %al,(%rax)
	...
