
_runvm:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <doio>:
{
  char c;

  /* OUT to the UART's transmit register: print the byte on our console
   * (file descriptor 1). This is how the guest's text reaches the user. */
  if(e->io.port == COM1 && !e->io.in){
   0:	8b 46 30             	mov    0x30(%rsi),%eax
   3:	25 ff ff 00 ff       	and    $0xff00ffff,%eax
   8:	3d f8 03 00 00       	cmp    $0x3f8,%eax
   d:	74 01                	je     10 <doio+0x10>
   f:	c3                   	ret
{
  10:	55                   	push   %rbp
  11:	48 89 e5             	mov    %rsp,%rbp
  14:	48 83 ec 10          	sub    $0x10,%rsp
    c = e->io.data;
  18:	8b 46 34             	mov    0x34(%rsi),%eax
  1b:	88 45 ff             	mov    %al,-0x1(%rbp)
    write(1, &c, 1);
  1e:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  22:	ba 01 00 00 00       	mov    $0x1,%edx
  27:	bf 01 00 00 00       	mov    $0x1,%edi
  2c:	e8 99 04 00 00       	call   4ca <write>
  }
  /* Any other IN targets a port with no device behind it. Real buses
   * return all ones for such reads; OUTs to unknown ports are ignored. */
  if(e->io.in)
    completein(vm, e->io.size, 0xFFFFFFFF);  // no device: reads float high
}
  31:	48 89 ec             	mov    %rbp,%rsp
  34:	5d                   	pop    %rbp
  35:	c3                   	ret

0000000000000036 <main>:

int
main(int argc, char *argv[])
{
  36:	55                   	push   %rbp
  37:	48 89 e5             	mov    %rsp,%rbp
  3a:	41 56                	push   %r14
  3c:	41 55                	push   %r13
  3e:	41 54                	push   %r12
  40:	53                   	push   %rbx
  41:	48 83 ec 40          	sub    $0x40,%rsp
  struct vmexit e;   /* filled in by the kernel at every VM exit */
  int fd, n, len, vm, memmb;

  /* Command line: the image file, and optionally the size of guest
   * physical memory in megabytes. */
  if(argc < 2 || argc > 3){
  45:	8d 47 fe             	lea    -0x2(%rdi),%eax
  48:	83 f8 01             	cmp    $0x1,%eax
  4b:	77 51                	ja     9e <main+0x68>
  4d:	49 89 f5             	mov    %rsi,%r13
    printf(2, "usage: runvm image [memory-MB]\n");
    exit();
  }
  memmb = argc == 3 ? atoi(argv[2]) : 4;
  50:	83 ff 03             	cmp    $0x3,%edi
  53:	74 5f                	je     b4 <main+0x7e>
  55:	41 be 04 00 00 00    	mov    $0x4,%r14d

  /* Read the whole image into memory. The kernel never opens files on
   * behalf of the hypervisor, so the monitor does the file I/O. The loop
   * reads until end of file or until the buffer is full. */
  if((fd = open(argv[1], O_RDONLY)) < 0){
  5b:	49 8b 7d 08          	mov    0x8(%r13),%rdi
  5f:	be 00 00 00 00       	mov    $0x0,%esi
  64:	e8 89 04 00 00       	call   4f2 <open>
  69:	41 89 c4             	mov    %eax,%r12d
  6c:	85 c0                	test   %eax,%eax
  6e:	78 52                	js     c2 <main+0x8c>
    printf(2, "runvm: cannot open %s\n", argv[1]);
    exit();
  }
  for(len = 0; len < MAXIMAGE && (n = read(fd, image + len, MAXIMAGE - len)) > 0; len += n)
  70:	bb 00 00 00 00       	mov    $0x0,%ebx
  75:	81 fb ff ff 03 00    	cmp    $0x3ffff,%ebx
  7b:	7f 5f                	jg     dc <main+0xa6>
  7d:	ba 00 00 04 00       	mov    $0x40000,%edx
  82:	29 da                	sub    %ebx,%edx
  84:	48 63 f3             	movslq %ebx,%rsi
  87:	48 81 c6 60 0f 00 00 	add    $0xf60,%rsi
  8e:	44 89 e7             	mov    %r12d,%edi
  91:	e8 2a 04 00 00       	call   4c0 <read>
  96:	85 c0                	test   %eax,%eax
  98:	7e 42                	jle    dc <main+0xa6>
  9a:	01 c3                	add    %eax,%ebx
  9c:	eb d7                	jmp    75 <main+0x3f>
    printf(2, "usage: runvm image [memory-MB]\n");
  9e:	be 70 0a 00 00       	mov    $0xa70,%esi
  a3:	bf 02 00 00 00       	mov    $0x2,%edi
  a8:	b0 00                	mov    $0x0,%al
  aa:	e8 f6 05 00 00       	call   6a5 <printf>
    exit();
  af:	e8 ee 03 00 00       	call   4a2 <exit>
  memmb = argc == 3 ? atoi(argv[2]) : 4;
  b4:	48 8b 7e 10          	mov    0x10(%rsi),%rdi
  b8:	e8 59 03 00 00       	call   416 <atoi>
  bd:	41 89 c6             	mov    %eax,%r14d
  c0:	eb 99                	jmp    5b <main+0x25>
    printf(2, "runvm: cannot open %s\n", argv[1]);
  c2:	49 8b 55 08          	mov    0x8(%r13),%rdx
  c6:	be 20 0c 00 00       	mov    $0xc20,%esi
  cb:	bf 02 00 00 00       	mov    $0x2,%edi
  d0:	b0 00                	mov    $0x0,%al
  d2:	e8 ce 05 00 00       	call   6a5 <printf>
    exit();
  d7:	e8 c6 03 00 00       	call   4a2 <exit>
    ;
  close(fd);
  dc:	44 89 e7             	mov    %r12d,%edi
  df:	e8 f0 03 00 00       	call   4d4 <close>
  /* A full buffer means the file may have been truncated; refuse. */
  if(len == MAXIMAGE){
  e4:	81 fb 00 00 04 00    	cmp    $0x40000,%ebx
  ea:	0f 84 97 00 00 00    	je     187 <main+0x151>
  /* Step 1: create the VM. The kernel allocates the VMCS and the EPT
   * (guest-physical to host-physical page tables), allocates and zeroes
   * memmb megabytes of guest memory, and copies the image to
   * guest-physical address VM_LOAD_ADDR. Returns a VM id, like a file
   * descriptor, used by the other calls. */
  if((vm = vmcreate(image, len, memmb * 1024 * 1024)) < 0){
  f0:	44 89 f2             	mov    %r14d,%edx
  f3:	c1 e2 14             	shl    $0x14,%edx
  f6:	89 de                	mov    %ebx,%esi
  f8:	bf 60 0f 00 00       	mov    $0xf60,%edi
  fd:	e8 68 04 00 00       	call   56a <vmcreate>
 102:	89 c3                	mov    %eax,%ebx
 104:	85 c0                	test   %eax,%eax
 106:	0f 88 9a 00 00 00    	js     1a6 <main+0x170>
  }
  /* Step 2: set the guest's initial registers. All other registers
   * keep the defaults chosen by the kernel (flat 32-bit protected mode,
   * paging off; see vmcsinit() in vmx.c). Execution starts at the first
   * byte of the image, the "start" label of helloguestasm.S. */
  vmsetreg(vm, VMREG_RIP, VM_LOAD_ADDR);
 10c:	ba 00 00 10 00       	mov    $0x100000,%edx
 111:	be 10 00 00 00       	mov    $0x10,%esi
 116:	89 c7                	mov    %eax,%edi
 118:	e8 57 04 00 00       	call   574 <vmsetreg>

  /* Step 3: the run loop. Each vmrun() executes the guest until a VM
   * exit that the kernel cannot handle itself. */
  for(;;){
    if(vmrun(vm, &e) < 0){
 11d:	48 8d 75 a0          	lea    -0x60(%rbp),%rsi
 121:	89 df                	mov    %ebx,%edi
 123:	e8 56 04 00 00       	call   57e <vmrun>
 128:	85 c0                	test   %eax,%eax
 12a:	0f 88 8c 00 00 00    	js     1bc <main+0x186>
    }
    /* A failed VM *entry* (rather than an exit from the guest). The
     * reason field then is the failure code, e.g. 33 for invalid guest
     * state; qual says which check failed. Usually a bug in the
     * guest-state setup. */
    if(e.entryfail){
 130:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
 134:	0f 85 98 00 00 00    	jne    1d2 <main+0x19c>
      printf(2, "runvm: VM entry failed, reason %d, qualification 0x%x\n",
             e.reason, e.qual);
      exit();
    }
    /* Dispatch on the basic exit reason (EXIT_* in vmxapi.h). */
    switch(e.reason){
 13a:	8b 55 a0             	mov    -0x60(%rbp),%edx
 13d:	83 fa 1e             	cmp    $0x1e,%edx
 140:	0f 84 cf 00 00 00    	je     215 <main+0x1df>
 146:	0f 87 a3 00 00 00    	ja     1ef <main+0x1b9>
 14c:	83 fa 02             	cmp    $0x2,%edx
 14f:	0f 84 ea 00 00 00    	je     23f <main+0x209>
 155:	83 fa 0c             	cmp    $0xc,%edx
 158:	0f 84 c7 00 00 00    	je     225 <main+0x1ef>
 15e:	85 d2                	test   %edx,%edx
 160:	0f 85 11 01 00 00    	jne    277 <main+0x241>
      exit();
    case EXIT_EXCEPTION_NMI:
      /* The guest took a CPU exception. The hypervisor intercepts all
       * of them since the guest has no IDT. The low 8 bits of the
       * interruption information are the vector (14 = page fault...). */
      printf(2, "runvm: guest exception %d, error code 0x%x, rip 0x%x\n",
 166:	8b 4d c0             	mov    -0x40(%rbp),%ecx
 169:	0f b6 55 bc          	movzbl -0x44(%rbp),%edx
 16d:	4c 8b 45 b0          	mov    -0x50(%rbp),%r8
 171:	be 50 0b 00 00       	mov    $0xb50,%esi
 176:	bf 02 00 00 00       	mov    $0x2,%edi
 17b:	b0 00                	mov    $0x0,%al
 17d:	e8 23 05 00 00       	call   6a5 <printf>
             e.intrinfo & 0xff, (uint64)e.intrerr, e.rip);
      exit();
 182:	e8 1b 03 00 00       	call   4a2 <exit>
    printf(2, "runvm: %s is larger than %d bytes\n", argv[1], MAXIMAGE);
 187:	49 8b 55 08          	mov    0x8(%r13),%rdx
 18b:	b9 00 00 04 00       	mov    $0x40000,%ecx
 190:	be 90 0a 00 00       	mov    $0xa90,%esi
 195:	bf 02 00 00 00       	mov    $0x2,%edi
 19a:	b0 00                	mov    $0x0,%al
 19c:	e8 04 05 00 00       	call   6a5 <printf>
    exit();
 1a1:	e8 fc 02 00 00       	call   4a2 <exit>
    printf(2, "runvm: vmcreate failed\n");
 1a6:	be 37 0c 00 00       	mov    $0xc37,%esi
 1ab:	bf 02 00 00 00       	mov    $0x2,%edi
 1b0:	b0 00                	mov    $0x0,%al
 1b2:	e8 ee 04 00 00       	call   6a5 <printf>
    exit();
 1b7:	e8 e6 02 00 00       	call   4a2 <exit>
      printf(2, "runvm: vmrun failed\n");
 1bc:	be 4f 0c 00 00       	mov    $0xc4f,%esi
 1c1:	bf 02 00 00 00       	mov    $0x2,%edi
 1c6:	b0 00                	mov    $0x0,%al
 1c8:	e8 d8 04 00 00       	call   6a5 <printf>
      exit();
 1cd:	e8 d0 02 00 00       	call   4a2 <exit>
      printf(2, "runvm: VM entry failed, reason %d, qualification 0x%x\n",
 1d2:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
 1d6:	8b 55 a0             	mov    -0x60(%rbp),%edx
 1d9:	be b8 0a 00 00       	mov    $0xab8,%esi
 1de:	bf 02 00 00 00       	mov    $0x2,%edi
 1e3:	b0 00                	mov    $0x0,%al
 1e5:	e8 bb 04 00 00       	call   6a5 <printf>
      exit();
 1ea:	e8 b3 02 00 00       	call   4a2 <exit>
    switch(e.reason){
 1ef:	83 fa 30             	cmp    $0x30,%edx
 1f2:	74 65                	je     259 <main+0x223>
 1f4:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
 1fa:	75 7b                	jne    277 <main+0x241>
      printf(2, "runvm: VMLAUNCH failed, VM-instruction error %d\n", e.error);
 1fc:	8b 55 b8             	mov    -0x48(%rbp),%edx
 1ff:	be 18 0b 00 00       	mov    $0xb18,%esi
 204:	bf 02 00 00 00       	mov    $0x2,%edi
 209:	b0 00                	mov    $0x0,%al
 20b:	e8 95 04 00 00       	call   6a5 <printf>
      exit();
 210:	e8 8d 02 00 00       	call   4a2 <exit>
      doio(vm, &e);
 215:	48 8d 75 a0          	lea    -0x60(%rbp),%rsi
 219:	89 df                	mov    %ebx,%edi
 21b:	e8 e0 fd ff ff       	call   0 <doio>
    if(vmrun(vm, &e) < 0){
 220:	e9 f8 fe ff ff       	jmp    11d <main+0xe7>
      printf(1, "runvm: guest halted at rip 0x%x\n", e.rip);
 225:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
 229:	be f0 0a 00 00       	mov    $0xaf0,%esi
 22e:	bf 01 00 00 00       	mov    $0x1,%edi
 233:	b0 00                	mov    $0x0,%al
 235:	e8 6b 04 00 00       	call   6a5 <printf>
      exit();
 23a:	e8 63 02 00 00       	call   4a2 <exit>
    case EXIT_TRIPLE_FAULT:
      /* The guest faulted while delivering a fault; a real CPU would
       * reset. Common cause: running with a broken page table or GDT. */
      printf(2, "runvm: guest triple fault at rip 0x%x\n", e.rip);
 23f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
 243:	be 88 0b 00 00       	mov    $0xb88,%esi
 248:	bf 02 00 00 00       	mov    $0x2,%edi
 24d:	b0 00                	mov    $0x0,%al
 24f:	e8 51 04 00 00       	call   6a5 <printf>
      exit();
 254:	e8 49 02 00 00       	call   4a2 <exit>
    case EXIT_EPT_VIOLATION:
      /* The guest touched guest-physical memory that has no EPT
       * mapping, i.e. beyond the memory size given to vmcreate(). gpa
       * is the offending guest-physical address. */
      printf(2, "runvm: EPT violation at guest-physical 0x%x, rip 0x%x\n",
 259:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
 25d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
 261:	be b0 0b 00 00       	mov    $0xbb0,%esi
 266:	bf 02 00 00 00       	mov    $0x2,%edi
 26b:	b0 00                	mov    $0x0,%al
 26d:	e8 33 04 00 00       	call   6a5 <printf>
             e.gpa, e.rip);
      exit();
 272:	e8 2b 02 00 00       	call   4a2 <exit>
    }
    /* Any other reason (CPUID, a WRMSR the kernel does not emulate,
     * ...) is not supported by this monitor: report it and give up. */
    printf(2, "runvm: unhandled exit %d, qualification 0x%x, rip 0x%x\n",
 277:	4c 8b 45 b0          	mov    -0x50(%rbp),%r8
 27b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
 27f:	be e8 0b 00 00       	mov    $0xbe8,%esi
 284:	bf 02 00 00 00       	mov    $0x2,%edi
 289:	b0 00                	mov    $0x0,%al
 28b:	e8 15 04 00 00       	call   6a5 <printf>
           e.reason, e.qual, e.rip);
    exit();
 290:	e8 0d 02 00 00       	call   4a2 <exit>
 295:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 29c:	00 00 00 
 29f:	90                   	nop

00000000000002a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a3:	48 89 f9             	mov    %rdi,%rcx
 2a6:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2ad:	00 00 00 00 
 2b1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2b8:	00 00 00 00 
 2bc:	0f 1f 40 00          	nopl   0x0(%rax)
 2c0:	48 89 f2             	mov    %rsi,%rdx
 2c3:	48 83 c6 01          	add    $0x1,%rsi
 2c7:	49 89 c8             	mov    %rcx,%r8
 2ca:	48 83 c1 01          	add    $0x1,%rcx
 2ce:	8a 12                	mov    (%rdx),%dl
 2d0:	41 88 10             	mov    %dl,(%r8)
 2d3:	0f be d2             	movsbl %dl,%edx
 2d6:	85 d2                	test   %edx,%edx
 2d8:	75 e6                	jne    2c0 <strcpy+0x20>
    ;
  return os;
}
 2da:	c3                   	ret

00000000000002db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2db:	eb 0b                	jmp    2e8 <strcmp+0xd>
 2dd:	0f 1f 00             	nopl   (%rax)
    p++, q++;
 2e0:	48 83 c7 01          	add    $0x1,%rdi
 2e4:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
 2e8:	8a 07                	mov    (%rdi),%al
 2ea:	0f be d0             	movsbl %al,%edx
 2ed:	85 d2                	test   %edx,%edx
 2ef:	74 07                	je     2f8 <strcmp+0x1d>
 2f1:	0f be 0e             	movsbl (%rsi),%ecx
 2f4:	39 ca                	cmp    %ecx,%edx
 2f6:	74 e8                	je     2e0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 2f8:	0f b6 c0             	movzbl %al,%eax
 2fb:	0f b6 16             	movzbl (%rsi),%edx
 2fe:	29 d0                	sub    %edx,%eax
}
 300:	c3                   	ret

0000000000000301 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 301:	b8 00 00 00 00       	mov    $0x0,%eax
 306:	eb 0b                	jmp    313 <strlen+0x12>
 308:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 30f:	00 
 310:	83 c0 01             	add    $0x1,%eax
 313:	48 63 d0             	movslq %eax,%rdx
 316:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
 31a:	85 d2                	test   %edx,%edx
 31c:	75 f2                	jne    310 <strlen+0xf>
    ;
  return n;
}
 31e:	c3                   	ret

000000000000031f <memset>:

void*
memset(void *dst, int c, uint n)
{
 31f:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
 322:	89 d1                	mov    %edx,%ecx
 324:	89 f0                	mov    %esi,%eax
 326:	fc                   	cld
 327:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 329:	4c 89 c0             	mov    %r8,%rax
 32c:	c3                   	ret

000000000000032d <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 32d:	eb 15                	jmp    344 <strchr+0x17>
 32f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 336:	00 00 00 00 
 33a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 340:	48 83 c7 01          	add    $0x1,%rdi
 344:	8a 17                	mov    (%rdi),%dl
 346:	0f be c2             	movsbl %dl,%eax
 349:	85 c0                	test   %eax,%eax
 34b:	74 0f                	je     35c <strchr+0x2f>
    if(*s == c)
 34d:	0f be d2             	movsbl %dl,%edx
 350:	40 0f be c6          	movsbl %sil,%eax
 354:	39 c2                	cmp    %eax,%edx
 356:	75 e8                	jne    340 <strchr+0x13>
      return (char*)s;
 358:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
 35b:	c3                   	ret
  return 0;
 35c:	b8 00 00 00 00       	mov    $0x0,%eax
 361:	c3                   	ret

0000000000000362 <gets>:

char*
gets(char *buf, int max)
{
 362:	55                   	push   %rbp
 363:	48 89 e5             	mov    %rsp,%rbp
 366:	41 56                	push   %r14
 368:	41 55                	push   %r13
 36a:	41 54                	push   %r12
 36c:	53                   	push   %rbx
 36d:	48 83 ec 10          	sub    $0x10,%rsp
 371:	49 89 fc             	mov    %rdi,%r12
 374:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 377:	bb 00 00 00 00       	mov    $0x0,%ebx
 37c:	41 89 de             	mov    %ebx,%r14d
 37f:	83 c3 01             	add    $0x1,%ebx
 382:	44 39 eb             	cmp    %r13d,%ebx
 385:	7d 39                	jge    3c0 <gets+0x5e>
    cc = read(0, &c, 1);
 387:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 38b:	ba 01 00 00 00       	mov    $0x1,%edx
 390:	bf 00 00 00 00       	mov    $0x0,%edi
 395:	e8 26 01 00 00       	call   4c0 <read>
    if(cc < 1)
 39a:	85 c0                	test   %eax,%eax
 39c:	7e 22                	jle    3c0 <gets+0x5e>
      break;
    buf[i++] = c;
 39e:	4d 63 f6             	movslq %r14d,%r14
 3a1:	8a 45 df             	mov    -0x21(%rbp),%al
 3a4:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
 3a8:	0f be c0             	movsbl %al,%eax
 3ab:	83 f8 0a             	cmp    $0xa,%eax
 3ae:	0f 94 c2             	sete   %dl
 3b1:	83 f8 0d             	cmp    $0xd,%eax
 3b4:	0f 94 c0             	sete   %al
 3b7:	09 d0                	or     %edx,%eax
 3b9:	a8 ff                	test   $0xff,%al
 3bb:	74 bf                	je     37c <gets+0x1a>
    buf[i++] = c;
 3bd:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
 3c0:	4d 63 f6             	movslq %r14d,%r14
 3c3:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
 3c8:	4c 89 e0             	mov    %r12,%rax
 3cb:	48 83 c4 10          	add    $0x10,%rsp
 3cf:	5b                   	pop    %rbx
 3d0:	41 5c                	pop    %r12
 3d2:	41 5d                	pop    %r13
 3d4:	41 5e                	pop    %r14
 3d6:	5d                   	pop    %rbp
 3d7:	c3                   	ret

00000000000003d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d8:	55                   	push   %rbp
 3d9:	48 89 e5             	mov    %rsp,%rbp
 3dc:	41 54                	push   %r12
 3de:	53                   	push   %rbx
 3df:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e2:	be 00 00 00 00       	mov    $0x0,%esi
 3e7:	e8 06 01 00 00       	call   4f2 <open>
  if(fd < 0)
 3ec:	85 c0                	test   %eax,%eax
 3ee:	78 1e                	js     40e <stat+0x36>
 3f0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3f2:	4c 89 e6             	mov    %r12,%rsi
 3f5:	89 c7                	mov    %eax,%edi
 3f7:	e8 14 01 00 00       	call   510 <fstat>
 3fc:	41 89 c4             	mov    %eax,%r12d
  close(fd);
 3ff:	89 df                	mov    %ebx,%edi
 401:	e8 ce 00 00 00       	call   4d4 <close>
  return r;
}
 406:	44 89 e0             	mov    %r12d,%eax
 409:	5b                   	pop    %rbx
 40a:	41 5c                	pop    %r12
 40c:	5d                   	pop    %rbp
 40d:	c3                   	ret
    return -1;
 40e:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 414:	eb f0                	jmp    406 <stat+0x2e>

0000000000000416 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
 416:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
 41b:	eb 09                	jmp    426 <atoi+0x10>
 41d:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
 420:	f7 de                	neg    %esi
    s++;
 422:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
 426:	0f be 07             	movsbl (%rdi),%eax
 429:	83 f8 2d             	cmp    $0x2d,%eax
 42c:	74 f2                	je     420 <atoi+0xa>
  n = 0;
 42e:	b8 00 00 00 00       	mov    $0x0,%eax
 433:	eb 19                	jmp    44e <atoi+0x38>
 435:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 43c:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 440:	8d 04 80             	lea    (%rax,%rax,4),%eax
 443:	48 83 c7 01          	add    $0x1,%rdi
 447:	0f be d2             	movsbl %dl,%edx
 44a:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
 44e:	8a 17                	mov    (%rdi),%dl
 450:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 453:	0f b6 c9             	movzbl %cl,%ecx
 456:	83 f9 09             	cmp    $0x9,%ecx
 459:	76 e5                	jbe    440 <atoi+0x2a>
  return sign * n;
 45b:	0f af c6             	imul   %esi,%eax
}
 45e:	c3                   	ret

000000000000045f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 45f:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
 462:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
 465:	eb 28                	jmp    48f <memmove+0x30>
 467:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 46e:	00 00 00 00 
 472:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 479:	00 00 00 00 
 47d:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
 480:	8a 16                	mov    (%rsi),%dl
 482:	88 11                	mov    %dl,(%rcx)
 484:	48 8d 76 01          	lea    0x1(%rsi),%rsi
 488:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
 48c:	44 89 c2             	mov    %r8d,%edx
 48f:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
 493:	85 d2                	test   %edx,%edx
 495:	7f e9                	jg     480 <memmove+0x21>
  return vdst;
}
 497:	c3                   	ret

0000000000000498 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 498:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret

00000000000004a2 <exit>:
SYSCALL(exit)
 4a2:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret

00000000000004ac <wait>:
SYSCALL(wait)
 4ac:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret

00000000000004b6 <pipe>:
SYSCALL(pipe)
 4b6:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret

00000000000004c0 <read>:
SYSCALL(read)
 4c0:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret

00000000000004ca <write>:
SYSCALL(write)
 4ca:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret

00000000000004d4 <close>:
SYSCALL(close)
 4d4:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret

00000000000004de <kill>:
SYSCALL(kill)
 4de:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret

00000000000004e8 <exec>:
SYSCALL(exec)
 4e8:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret

00000000000004f2 <open>:
SYSCALL(open)
 4f2:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret

00000000000004fc <mknod>:
SYSCALL(mknod)
 4fc:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret

0000000000000506 <unlink>:
SYSCALL(unlink)
 506:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret

0000000000000510 <fstat>:
SYSCALL(fstat)
 510:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret

000000000000051a <link>:
SYSCALL(link)
 51a:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret

0000000000000524 <mkdir>:
SYSCALL(mkdir)
 524:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret

000000000000052e <chdir>:
SYSCALL(chdir)
 52e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret

0000000000000538 <dup>:
SYSCALL(dup)
 538:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret

0000000000000542 <getpid>:
SYSCALL(getpid)
 542:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret

000000000000054c <sbrk>:
SYSCALL(sbrk)
 54c:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret

0000000000000556 <sleep>:
SYSCALL(sleep)
 556:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret

0000000000000560 <uptime>:
SYSCALL(uptime)
 560:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret

000000000000056a <vmcreate>:
SYSCALL(vmcreate)
 56a:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret

0000000000000574 <vmsetreg>:
SYSCALL(vmsetreg)
 574:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret

000000000000057e <vmrun>:
SYSCALL(vmrun)
 57e:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret

0000000000000588 <vmgetreg>:
SYSCALL(vmgetreg)
 588:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret
 592:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 599:	00 00 00 
 59c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 5a3:	00 00 00 
 5a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 5ad:	00 00 00 
 5b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 5b7:	00 00 00 
 5ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000005c0 <_va_arg>:
// Retrieve the next argument from the va_list.
static inline void *_va_arg(va_list *args)
{
    // Returns the next argument from registers if _index < 6, 
    // otherwise from the stack.
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 5c0:	8b 47 38             	mov    0x38(%rdi),%eax
 5c3:	83 f8 05             	cmp    $0x5,%eax
 5c6:	77 0d                	ja     5d5 <_va_arg+0x15>
 5c8:	8d 50 01             	lea    0x1(%rax),%edx
 5cb:	89 57 38             	mov    %edx,0x38(%rdi)
 5ce:	89 c0                	mov    %eax,%eax
 5d0:	48 8b 04 c7          	mov    (%rdi,%rax,8),%rax
 5d4:	c3                   	ret
                                  : args->more_argint[(args->_index++)-6]);
 5d5:	8d 50 01             	lea    0x1(%rax),%edx
 5d8:	89 57 38             	mov    %edx,0x38(%rdi)
 5db:	8d 40 fa             	lea    -0x6(%rax),%eax
 5de:	48 c1 e0 03          	shl    $0x3,%rax
 5e2:	48 03 47 30          	add    0x30(%rdi),%rax
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 5e6:	48 8b 00             	mov    (%rax),%rax
}
 5e9:	c3                   	ret

00000000000005ea <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5ea:	55                   	push   %rbp
 5eb:	48 89 e5             	mov    %rsp,%rbp
 5ee:	48 83 ec 10          	sub    $0x10,%rsp
 5f2:	40 88 75 fc          	mov    %sil,-0x4(%rbp)
  write(fd, &c, 1);
 5f6:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 5fa:	ba 01 00 00 00       	mov    $0x1,%edx
 5ff:	e8 c6 fe ff ff       	call   4ca <write>
}
 604:	48 89 ec             	mov    %rbp,%rsp
 607:	5d                   	pop    %rbp
 608:	c3                   	ret

0000000000000609 <printint>:

static void
printint(int fd, int64 xx, int base, int sgn)
{
 609:	55                   	push   %rbp
 60a:	48 89 e5             	mov    %rsp,%rbp
 60d:	41 54                	push   %r12
 60f:	53                   	push   %rbx
 610:	48 83 ec 10          	sub    $0x10,%rsp
 614:	41 89 fc             	mov    %edi,%r12d
 617:	41 89 d1             	mov    %edx,%r9d
  char buf[16];
  int i, neg;
  uint64 x;

  neg = 0;
  if(sgn && xx < 0){
 61a:	85 c9                	test   %ecx,%ecx
 61c:	0f 95 c2             	setne  %dl
 61f:	48 89 f0             	mov    %rsi,%rax
 622:	48 c1 e8 3f          	shr    $0x3f,%rax
 626:	85 c2                	test   %eax,%edx
 628:	74 55                	je     67f <printint+0x76>
    neg = 1;
    x = -xx;
 62a:	48 f7 de             	neg    %rsi
    neg = 1;
 62d:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  } else {
    x = xx;
  }

  i = 0;
 633:	bb 00 00 00 00       	mov    $0x0,%ebx
 638:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 63f:	00 
  do{
    buf[i++] = digits[x % base];
 640:	49 63 c9             	movslq %r9d,%rcx
 643:	48 89 f0             	mov    %rsi,%rax
 646:	ba 00 00 00 00       	mov    $0x0,%edx
 64b:	48 f7 f1             	div    %rcx
 64e:	89 df                	mov    %ebx,%edi
 650:	83 c3 01             	add    $0x1,%ebx
 653:	44 8a 82 20 0d 00 00 	mov    0xd20(%rdx),%r8b
 65a:	48 63 d7             	movslq %edi,%rdx
 65d:	44 88 44 15 e0       	mov    %r8b,-0x20(%rbp,%rdx,1)
  }while((x /= base) != 0);
 662:	48 89 f2             	mov    %rsi,%rdx
 665:	48 89 c6             	mov    %rax,%rsi
 668:	48 39 ca             	cmp    %rcx,%rdx
 66b:	73 d3                	jae    640 <printint+0x37>
  if(neg)
 66d:	45 85 d2             	test   %r10d,%r10d
 670:	74 25                	je     697 <printint+0x8e>
    buf[i++] = '-';
 672:	48 63 db             	movslq %ebx,%rbx
 675:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 67a:	8d 5f 02             	lea    0x2(%rdi),%ebx
 67d:	eb 18                	jmp    697 <printint+0x8e>
  neg = 0;
 67f:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 685:	eb ac                	jmp    633 <printint+0x2a>

  while(--i >= 0)
    putc(fd, buf[i]);
 687:	48 63 c3             	movslq %ebx,%rax
 68a:	0f be 74 05 e0       	movsbl -0x20(%rbp,%rax,1),%esi
 68f:	44 89 e7             	mov    %r12d,%edi
 692:	e8 53 ff ff ff       	call   5ea <putc>
  while(--i >= 0)
 697:	83 eb 01             	sub    $0x1,%ebx
 69a:	79 eb                	jns    687 <printint+0x7e>
}
 69c:	48 83 c4 10          	add    $0x10,%rsp
 6a0:	5b                   	pop    %rbx
 6a1:	41 5c                	pop    %r12
 6a3:	5d                   	pop    %rbp
 6a4:	c3                   	ret

00000000000006a5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6a5:	55                   	push   %rbp
 6a6:	48 89 e5             	mov    %rsp,%rbp
 6a9:	41 57                	push   %r15
 6ab:	41 56                	push   %r14
 6ad:	41 55                	push   %r13
 6af:	41 54                	push   %r12
 6b1:	53                   	push   %rbx
 6b2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
 6b9:	41 89 ff             	mov    %edi,%r15d
 6bc:	49 89 f5             	mov    %rsi,%r13
 6bf:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
 6c6:	48 89 8d 38 ff ff ff 	mov    %rcx,-0xc8(%rbp)
 6cd:	4c 89 85 40 ff ff ff 	mov    %r8,-0xc0(%rbp)
 6d4:	4c 89 8d 48 ff ff ff 	mov    %r9,-0xb8(%rbp)
 6db:	84 c0                	test   %al,%al
 6dd:	74 29                	je     708 <printf+0x63>
 6df:	0f 29 85 50 ff ff ff 	movaps %xmm0,-0xb0(%rbp)
 6e6:	0f 29 8d 60 ff ff ff 	movaps %xmm1,-0xa0(%rbp)
 6ed:	0f 29 95 70 ff ff ff 	movaps %xmm2,-0x90(%rbp)
 6f4:	0f 29 5d 80          	movaps %xmm3,-0x80(%rbp)
 6f8:	0f 29 65 90          	movaps %xmm4,-0x70(%rbp)
 6fc:	0f 29 6d a0          	movaps %xmm5,-0x60(%rbp)
 700:	0f 29 75 b0          	movaps %xmm6,-0x50(%rbp)
 704:	0f 29 7d c0          	movaps %xmm7,-0x40(%rbp)
    asm volatile("movq %%rdi, %0;" 
 708:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
 70f:	48 89 b5 e8 fe ff ff 	mov    %rsi,-0x118(%rbp)
 716:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
 71d:	48 89 8d f8 fe ff ff 	mov    %rcx,-0x108(%rbp)
 724:	4c 89 85 00 ff ff ff 	mov    %r8,-0x100(%rbp)
 72b:	4c 89 8d 08 ff ff ff 	mov    %r9,-0xf8(%rbp)
    asm volatile("leaq 16(%%rbp), %0" : "=r" (args->more_argint));
 732:	48 8d 45 10          	lea    0x10(%rbp),%rax
 736:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
    args->_index = 1;
 73d:	c7 85 18 ff ff ff 01 	movl   $0x1,-0xe8(%rbp)
 744:	00 00 00 
  char *s;
  int c, i, state;
  va_list ap;

  va_start(ap, fd);
  (void) va_arg(ap, char*); // skip fmt
 747:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 74e:	e8 6d fe ff ff       	call   5c0 <_va_arg>

  state = 0;
 753:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(i = 0; fmt[i]; i++){
 759:	bb 00 00 00 00       	mov    $0x0,%ebx
 75e:	eb 16                	jmp    776 <printf+0xd1>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 760:	44 89 f6             	mov    %r14d,%esi
 763:	44 89 ff             	mov    %r15d,%edi
 766:	e8 7f fe ff ff       	call   5ea <putc>
 76b:	eb 06                	jmp    773 <printf+0xce>
      }
    } else if(state == '%'){
 76d:	41 83 fc 25          	cmp    $0x25,%r12d
 771:	74 2c                	je     79f <printf+0xfa>
  for(i = 0; fmt[i]; i++){
 773:	83 c3 01             	add    $0x1,%ebx
 776:	48 63 c3             	movslq %ebx,%rax
 779:	41 8a 44 05 00       	mov    0x0(%r13,%rax,1),%al
 77e:	0f be d0             	movsbl %al,%edx
 781:	85 d2                	test   %edx,%edx
 783:	0f 84 42 01 00 00    	je     8cb <printf+0x226>
    c = fmt[i] & 0xff;
 789:	44 0f be f0          	movsbl %al,%r14d
 78d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 790:	45 85 e4             	test   %r12d,%r12d
 793:	75 d8                	jne    76d <printf+0xc8>
      if(c == '%'){
 795:	83 f8 25             	cmp    $0x25,%eax
 798:	75 c6                	jne    760 <printf+0xbb>
        state = '%';
 79a:	41 89 c4             	mov    %eax,%r12d
 79d:	eb d4                	jmp    773 <printf+0xce>
      if(c == 'd'){
 79f:	83 f8 25             	cmp    $0x25,%eax
 7a2:	0f 84 ea 00 00 00    	je     892 <printf+0x1ed>
 7a8:	0f 8c fa 00 00 00    	jl     8a8 <printf+0x203>
 7ae:	83 f8 78             	cmp    $0x78,%eax
 7b1:	0f 8f f1 00 00 00    	jg     8a8 <printf+0x203>
 7b7:	83 f8 63             	cmp    $0x63,%eax
 7ba:	0f 8c e8 00 00 00    	jl     8a8 <printf+0x203>
 7c0:	83 e8 63             	sub    $0x63,%eax
 7c3:	83 f8 15             	cmp    $0x15,%eax
 7c6:	0f 87 dc 00 00 00    	ja     8a8 <printf+0x203>
 7cc:	89 c0                	mov    %eax,%eax
 7ce:	ff 24 c5 70 0c 00 00 	jmp    *0xc70(,%rax,8)
        printint(fd, va_arg(ap, int), 10, 1);
 7d5:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 7dc:	e8 df fd ff ff       	call   5c0 <_va_arg>
 7e1:	48 63 f0             	movslq %eax,%rsi
 7e4:	b9 01 00 00 00       	mov    $0x1,%ecx
 7e9:	ba 0a 00 00 00       	mov    $0xa,%edx
 7ee:	44 89 ff             	mov    %r15d,%edi
 7f1:	e8 13 fe ff ff       	call   609 <printint>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7f6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 7fc:	e9 72 ff ff ff       	jmp    773 <printf+0xce>
        printint(fd, va_arg(ap, uint64), 16, 0);
 801:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 808:	e8 b3 fd ff ff       	call   5c0 <_va_arg>
 80d:	48 89 c6             	mov    %rax,%rsi
 810:	b9 00 00 00 00       	mov    $0x0,%ecx
 815:	ba 10 00 00 00       	mov    $0x10,%edx
 81a:	44 89 ff             	mov    %r15d,%edi
 81d:	e8 e7 fd ff ff       	call   609 <printint>
      state = 0;
 822:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 828:	e9 46 ff ff ff       	jmp    773 <printf+0xce>
        s = va_arg(ap, char*);
 82d:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 834:	e8 87 fd ff ff       	call   5c0 <_va_arg>
 839:	49 89 c4             	mov    %rax,%r12
        if(s == 0)
 83c:	48 85 c0             	test   %rax,%rax
 83f:	75 18                	jne    859 <printf+0x1b4>
          s = "(null)";
 841:	41 bc 64 0c 00 00    	mov    $0xc64,%r12d
 847:	eb 10                	jmp    859 <printf+0x1b4>
          putc(fd, *s);
 849:	40 0f be f6          	movsbl %sil,%esi
 84d:	44 89 ff             	mov    %r15d,%edi
 850:	e8 95 fd ff ff       	call   5ea <putc>
          s++;
 855:	49 83 c4 01          	add    $0x1,%r12
        while(*s != 0){
 859:	41 8a 34 24          	mov    (%r12),%sil
 85d:	40 0f be c6          	movsbl %sil,%eax
 861:	85 c0                	test   %eax,%eax
 863:	75 e4                	jne    849 <printf+0x1a4>
      state = 0;
 865:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 86b:	e9 03 ff ff ff       	jmp    773 <printf+0xce>
        putc(fd, va_arg(ap, char));
 870:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 877:	e8 44 fd ff ff       	call   5c0 <_va_arg>
 87c:	0f be f0             	movsbl %al,%esi
 87f:	44 89 ff             	mov    %r15d,%edi
 882:	e8 63 fd ff ff       	call   5ea <putc>
      state = 0;
 887:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 88d:	e9 e1 fe ff ff       	jmp    773 <printf+0xce>
        putc(fd, c);
 892:	44 89 f6             	mov    %r14d,%esi
 895:	44 89 ff             	mov    %r15d,%edi
 898:	e8 4d fd ff ff       	call   5ea <putc>
      state = 0;
 89d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 8a3:	e9 cb fe ff ff       	jmp    773 <printf+0xce>
        putc(fd, '%');
 8a8:	be 25 00 00 00       	mov    $0x25,%esi
 8ad:	44 89 ff             	mov    %r15d,%edi
 8b0:	e8 35 fd ff ff       	call   5ea <putc>
        putc(fd, c);
 8b5:	44 89 f6             	mov    %r14d,%esi
 8b8:	44 89 ff             	mov    %r15d,%edi
 8bb:	e8 2a fd ff ff       	call   5ea <putc>
      state = 0;
 8c0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 8c6:	e9 a8 fe ff ff       	jmp    773 <printf+0xce>
    }
  }
}
 8cb:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
 8d2:	5b                   	pop    %rbx
 8d3:	41 5c                	pop    %r12
 8d5:	41 5d                	pop    %r13
 8d7:	41 5e                	pop    %r14
 8d9:	41 5f                	pop    %r15
 8db:	5d                   	pop    %rbp
 8dc:	c3                   	ret
 8dd:	0f 1f 00             	nopl   (%rax)

00000000000008e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e0:	48 89 fe             	mov    %rdi,%rsi
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e3:	48 8d 4f f0          	lea    -0x10(%rdi),%rcx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e7:	48 8b 05 72 06 04 00 	mov    0x40672(%rip),%rax        # 40f60 <freep>
 8ee:	eb 03                	jmp    8f3 <free+0x13>
 8f0:	48 89 d0             	mov    %rdx,%rax
 8f3:	48 39 c8             	cmp    %rcx,%rax
 8f6:	73 05                	jae    8fd <free+0x1d>
 8f8:	48 3b 08             	cmp    (%rax),%rcx
 8fb:	72 17                	jb     914 <free+0x34>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fd:	48 8b 10             	mov    (%rax),%rdx
 900:	48 39 d0             	cmp    %rdx,%rax
 903:	72 eb                	jb     8f0 <free+0x10>
 905:	48 39 c8             	cmp    %rcx,%rax
 908:	72 0a                	jb     914 <free+0x34>
 90a:	48 39 d1             	cmp    %rdx,%rcx
 90d:	72 05                	jb     914 <free+0x34>
 90f:	48 89 d0             	mov    %rdx,%rax
 912:	eb df                	jmp    8f3 <free+0x13>
      break;
  if(bp + bp->s.size == p->s.ptr){
 914:	44 8b 46 f8          	mov    -0x8(%rsi),%r8d
 918:	44 89 c2             	mov    %r8d,%edx
 91b:	48 c1 e2 04          	shl    $0x4,%rdx
 91f:	48 01 ca             	add    %rcx,%rdx
 922:	48 8b 38             	mov    (%rax),%rdi
 925:	48 39 fa             	cmp    %rdi,%rdx
 928:	74 20                	je     94a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 92a:	48 89 7e f0          	mov    %rdi,-0x10(%rsi)
  if(p + p->s.size == bp){
 92e:	8b 78 08             	mov    0x8(%rax),%edi
 931:	89 fa                	mov    %edi,%edx
 933:	48 c1 e2 04          	shl    $0x4,%rdx
 937:	48 01 c2             	add    %rax,%rdx
 93a:	48 39 ca             	cmp    %rcx,%rdx
 93d:	74 1f                	je     95e <free+0x7e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 93f:	48 89 08             	mov    %rcx,(%rax)
  freep = p;
 942:	48 89 05 17 06 04 00 	mov    %rax,0x40617(%rip)        # 40f60 <freep>
}
 949:	c3                   	ret
    bp->s.size += p->s.ptr->s.size;
 94a:	44 03 47 08          	add    0x8(%rdi),%r8d
 94e:	44 89 46 f8          	mov    %r8d,-0x8(%rsi)
    bp->s.ptr = p->s.ptr->s.ptr;
 952:	48 8b 10             	mov    (%rax),%rdx
 955:	48 8b 12             	mov    (%rdx),%rdx
 958:	48 89 56 f0          	mov    %rdx,-0x10(%rsi)
 95c:	eb d0                	jmp    92e <free+0x4e>
    p->s.size += bp->s.size;
 95e:	03 7e f8             	add    -0x8(%rsi),%edi
 961:	89 78 08             	mov    %edi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 964:	48 8b 56 f0          	mov    -0x10(%rsi),%rdx
 968:	48 89 10             	mov    %rdx,(%rax)
 96b:	eb d5                	jmp    942 <free+0x62>

000000000000096d <morecore>:

static Header*
morecore(uint nu)
{
 96d:	55                   	push   %rbp
 96e:	48 89 e5             	mov    %rsp,%rbp
 971:	53                   	push   %rbx
 972:	48 83 ec 08          	sub    $0x8,%rsp
 976:	89 fb                	mov    %edi,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 978:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 97e:	77 05                	ja     985 <morecore+0x18>
    nu = 4096;
 980:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 985:	89 df                	mov    %ebx,%edi
 987:	c1 e7 04             	shl    $0x4,%edi
 98a:	e8 bd fb ff ff       	call   54c <sbrk>
  if(p == (char*)-1)
 98f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 993:	74 1a                	je     9af <morecore+0x42>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 995:	89 58 08             	mov    %ebx,0x8(%rax)
  free((void*)(hp + 1));
 998:	48 8d 78 10          	lea    0x10(%rax),%rdi
 99c:	e8 3f ff ff ff       	call   8e0 <free>
  return freep;
 9a1:	48 8b 05 b8 05 04 00 	mov    0x405b8(%rip),%rax        # 40f60 <freep>
}
 9a8:	48 83 c4 08          	add    $0x8,%rsp
 9ac:	5b                   	pop    %rbx
 9ad:	5d                   	pop    %rbp
 9ae:	c3                   	ret
    return 0;
 9af:	b8 00 00 00 00       	mov    $0x0,%eax
 9b4:	eb f2                	jmp    9a8 <morecore+0x3b>

00000000000009b6 <malloc>:

void*
malloc(uint nbytes)
{
 9b6:	55                   	push   %rbp
 9b7:	48 89 e5             	mov    %rsp,%rbp
 9ba:	53                   	push   %rbx
 9bb:	48 83 ec 08          	sub    $0x8,%rsp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9bf:	89 fb                	mov    %edi,%ebx
 9c1:	48 83 c3 0f          	add    $0xf,%rbx
 9c5:	48 c1 eb 04          	shr    $0x4,%rbx
 9c9:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 9cc:	48 8b 0d 8d 05 04 00 	mov    0x4058d(%rip),%rcx        # 40f60 <freep>
 9d3:	48 85 c9             	test   %rcx,%rcx
 9d6:	74 05                	je     9dd <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d8:	48 8b 01             	mov    (%rcx),%rax
 9db:	eb 69                	jmp    a46 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
 9dd:	48 c7 05 78 05 04 00 	movq   $0x40f70,0x40578(%rip)        # 40f60 <freep>
 9e4:	70 0f 04 00 
 9e8:	48 c7 05 7d 05 04 00 	movq   $0x40f70,0x4057d(%rip)        # 40f70 <base>
 9ef:	70 0f 04 00 
    base.s.size = 0;
 9f3:	c7 05 7b 05 04 00 00 	movl   $0x0,0x4057b(%rip)        # 40f78 <base+0x8>
 9fa:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 9fd:	b9 70 0f 04 00       	mov    $0x40f70,%ecx
 a02:	eb d4                	jmp    9d8 <malloc+0x22>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 a04:	74 23                	je     a29 <malloc+0x73>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 a06:	29 da                	sub    %ebx,%edx
 a08:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 a0b:	89 d2                	mov    %edx,%edx
 a0d:	48 c1 e2 04          	shl    $0x4,%rdx
 a11:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 a14:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 a17:	48 89 0d 42 05 04 00 	mov    %rcx,0x40542(%rip)        # 40f60 <freep>
      return (void*)(p + 1);
 a1e:	48 83 c0 10          	add    $0x10,%rax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a22:	48 83 c4 08          	add    $0x8,%rsp
 a26:	5b                   	pop    %rbx
 a27:	5d                   	pop    %rbp
 a28:	c3                   	ret
        prevp->s.ptr = p->s.ptr;
 a29:	48 8b 10             	mov    (%rax),%rdx
 a2c:	48 89 11             	mov    %rdx,(%rcx)
 a2f:	eb e6                	jmp    a17 <malloc+0x61>
 a31:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 a38:	00 00 00 00 
 a3c:	0f 1f 40 00          	nopl   0x0(%rax)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a40:	48 89 c1             	mov    %rax,%rcx
 a43:	48 8b 00             	mov    (%rax),%rax
    if(p->s.size >= nunits){
 a46:	8b 50 08             	mov    0x8(%rax),%edx
 a49:	39 da                	cmp    %ebx,%edx
 a4b:	73 b7                	jae    a04 <malloc+0x4e>
    if(p == freep)
 a4d:	48 39 05 0c 05 04 00 	cmp    %rax,0x4050c(%rip)        # 40f60 <freep>
 a54:	75 ea                	jne    a40 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
 a56:	89 df                	mov    %ebx,%edi
 a58:	e8 10 ff ff ff       	call   96d <morecore>
 a5d:	48 85 c0             	test   %rax,%rax
 a60:	75 de                	jne    a40 <malloc+0x8a>
 a62:	eb be                	jmp    a22 <malloc+0x6c>
