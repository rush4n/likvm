
helloguest.elf:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <start>:
  100000:	0f 20 e0             	mov    %cr4,%rax
  100003:	83 c8 20             	or     $0x20,%eax
  100006:	0f 22 e0             	mov    %rax,%cr4
  100009:	b8 00 10 10 00       	mov    $0x101000,%eax
  10000e:	0f 22 d8             	mov    %rax,%cr3
  100011:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  100016:	0f 32                	rdmsr
  100018:	0d 00 01 00 00       	or     $0x100,%eax
  10001d:	0f 30                	wrmsr
  10001f:	0f 01 15 18 40 10 00 	lgdt   0x104018(%rip)        # 20403e <stacktop+0xff01e>
  100026:	0f 20 c0             	mov    %cr0,%rax
  100029:	0d 00 00 00 80       	or     $0x80000000,%eax
  10002e:	0f 22 c0             	mov    %rax,%cr0
  100031:	ea                   	(bad)
  100032:	38 00                	cmp    %al,(%rax)
  100034:	10 00                	adc    %al,(%rax)
  100036:	08 00                	or     %al,(%rax)

0000000000100038 <start64>:
  100038:	66 b8 10 00          	mov    $0x10,%ax
  10003c:	8e d8                	mov    %eax,%ds
  10003e:	8e c0                	mov    %eax,%es
  100040:	8e d0                	mov    %eax,%ss
  100042:	48 c7 c4 20 50 10 00 	mov    $0x105020,%rsp
  100049:	e8 12 00 00 00       	call   100060 <guestmain>
  10004e:	f4                   	hlt
  10004f:	eb fd                	jmp    10004e <start64+0x16>
  100051:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  100058:	00 00 00 
  10005b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000100060 <guestmain>:
  100060:	b9 7e 00 10 00       	mov    $0x10007e,%ecx
  100065:	b8 48 00 00 00       	mov    $0x48,%eax
  10006a:	ba f8 03 00 00       	mov    $0x3f8,%edx
  10006f:	90                   	nop
  100070:	ee                   	out    %al,(%dx)
  100071:	0f b6 41 01          	movzbl 0x1(%rcx),%eax
  100075:	48 83 c1 01          	add    $0x1,%rcx
  100079:	84 c0                	test   %al,%al
  10007b:	75 f3                	jne    100070 <guestmain+0x10>
  10007d:	c3                   	ret
