
initcode.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <start>:


# exec(init, argv)
.globl start
start:
  movq $init, %rdi
   0:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
  movq $argv, %rsi
   7:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
  movq $SYS_exec, %rax
   e:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
  int $T_SYSCALL
  15:	cd 40                	int    $0x40

0000000000000017 <exit>:

# for(;;) exit();
exit:
  movq $SYS_exit, %rax
  17:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
  int $T_SYSCALL
  1e:	cd 40                	int    $0x40
  jmp exit
  20:	eb f5                	jmp    17 <exit>

0000000000000022 <init>:
  22:	2f                   	(bad)
  23:	69 6e 69 74 00 00 90 	imul   $0x90000074,0x69(%rsi),%ebp
  2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000000030 <argv>:
	...
