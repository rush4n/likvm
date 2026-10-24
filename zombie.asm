
_zombie:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
  if(fork() > 0)
   4:	e8 0f 02 00 00       	call   218 <fork>
   9:	85 c0                	test   %eax,%eax
   b:	7f 05                	jg     12 <main+0x12>
    sleep(5);  // Let child exit before parent.
  exit();
   d:	e8 10 02 00 00       	call   222 <exit>
    sleep(5);  // Let child exit before parent.
  12:	bf 05 00 00 00       	mov    $0x5,%edi
  17:	e8 ba 02 00 00       	call   2d6 <sleep>
  1c:	eb ef                	jmp    d <main+0xd>
  1e:	66 90                	xchg   %ax,%ax

0000000000000020 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  20:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  23:	48 89 f9             	mov    %rdi,%rcx
  26:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  2d:	00 00 00 00 
  31:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  38:	00 00 00 00 
  3c:	0f 1f 40 00          	nopl   0x0(%rax)
  40:	48 89 f2             	mov    %rsi,%rdx
  43:	48 83 c6 01          	add    $0x1,%rsi
  47:	49 89 c8             	mov    %rcx,%r8
  4a:	48 83 c1 01          	add    $0x1,%rcx
  4e:	8a 12                	mov    (%rdx),%dl
  50:	41 88 10             	mov    %dl,(%r8)
  53:	0f be d2             	movsbl %dl,%edx
  56:	85 d2                	test   %edx,%edx
  58:	75 e6                	jne    40 <strcpy+0x20>
    ;
  return os;
}
  5a:	c3                   	ret

000000000000005b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  5b:	eb 0b                	jmp    68 <strcmp+0xd>
  5d:	0f 1f 00             	nopl   (%rax)
    p++, q++;
  60:	48 83 c7 01          	add    $0x1,%rdi
  64:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
  68:	8a 07                	mov    (%rdi),%al
  6a:	0f be d0             	movsbl %al,%edx
  6d:	85 d2                	test   %edx,%edx
  6f:	74 07                	je     78 <strcmp+0x1d>
  71:	0f be 0e             	movsbl (%rsi),%ecx
  74:	39 ca                	cmp    %ecx,%edx
  76:	74 e8                	je     60 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  78:	0f b6 c0             	movzbl %al,%eax
  7b:	0f b6 16             	movzbl (%rsi),%edx
  7e:	29 d0                	sub    %edx,%eax
}
  80:	c3                   	ret

0000000000000081 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
  81:	b8 00 00 00 00       	mov    $0x0,%eax
  86:	eb 0b                	jmp    93 <strlen+0x12>
  88:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8f:	00 
  90:	83 c0 01             	add    $0x1,%eax
  93:	48 63 d0             	movslq %eax,%rdx
  96:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
  9a:	85 d2                	test   %edx,%edx
  9c:	75 f2                	jne    90 <strlen+0xf>
    ;
  return n;
}
  9e:	c3                   	ret

000000000000009f <memset>:

void*
memset(void *dst, int c, uint n)
{
  9f:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
  a2:	89 d1                	mov    %edx,%ecx
  a4:	89 f0                	mov    %esi,%eax
  a6:	fc                   	cld
  a7:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
  a9:	4c 89 c0             	mov    %r8,%rax
  ac:	c3                   	ret

00000000000000ad <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
  ad:	eb 15                	jmp    c4 <strchr+0x17>
  af:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  b6:	00 00 00 00 
  ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  c0:	48 83 c7 01          	add    $0x1,%rdi
  c4:	8a 17                	mov    (%rdi),%dl
  c6:	0f be c2             	movsbl %dl,%eax
  c9:	85 c0                	test   %eax,%eax
  cb:	74 0f                	je     dc <strchr+0x2f>
    if(*s == c)
  cd:	0f be d2             	movsbl %dl,%edx
  d0:	40 0f be c6          	movsbl %sil,%eax
  d4:	39 c2                	cmp    %eax,%edx
  d6:	75 e8                	jne    c0 <strchr+0x13>
      return (char*)s;
  d8:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
  db:	c3                   	ret
  return 0;
  dc:	b8 00 00 00 00       	mov    $0x0,%eax
  e1:	c3                   	ret

00000000000000e2 <gets>:

char*
gets(char *buf, int max)
{
  e2:	55                   	push   %rbp
  e3:	48 89 e5             	mov    %rsp,%rbp
  e6:	41 56                	push   %r14
  e8:	41 55                	push   %r13
  ea:	41 54                	push   %r12
  ec:	53                   	push   %rbx
  ed:	48 83 ec 10          	sub    $0x10,%rsp
  f1:	49 89 fc             	mov    %rdi,%r12
  f4:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  fc:	41 89 de             	mov    %ebx,%r14d
  ff:	83 c3 01             	add    $0x1,%ebx
 102:	44 39 eb             	cmp    %r13d,%ebx
 105:	7d 39                	jge    140 <gets+0x5e>
    cc = read(0, &c, 1);
 107:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 10b:	ba 01 00 00 00       	mov    $0x1,%edx
 110:	bf 00 00 00 00       	mov    $0x0,%edi
 115:	e8 26 01 00 00       	call   240 <read>
    if(cc < 1)
 11a:	85 c0                	test   %eax,%eax
 11c:	7e 22                	jle    140 <gets+0x5e>
      break;
    buf[i++] = c;
 11e:	4d 63 f6             	movslq %r14d,%r14
 121:	8a 45 df             	mov    -0x21(%rbp),%al
 124:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
 128:	0f be c0             	movsbl %al,%eax
 12b:	83 f8 0a             	cmp    $0xa,%eax
 12e:	0f 94 c2             	sete   %dl
 131:	83 f8 0d             	cmp    $0xd,%eax
 134:	0f 94 c0             	sete   %al
 137:	09 d0                	or     %edx,%eax
 139:	a8 ff                	test   $0xff,%al
 13b:	74 bf                	je     fc <gets+0x1a>
    buf[i++] = c;
 13d:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
 140:	4d 63 f6             	movslq %r14d,%r14
 143:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
 148:	4c 89 e0             	mov    %r12,%rax
 14b:	48 83 c4 10          	add    $0x10,%rsp
 14f:	5b                   	pop    %rbx
 150:	41 5c                	pop    %r12
 152:	41 5d                	pop    %r13
 154:	41 5e                	pop    %r14
 156:	5d                   	pop    %rbp
 157:	c3                   	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	55                   	push   %rbp
 159:	48 89 e5             	mov    %rsp,%rbp
 15c:	41 54                	push   %r12
 15e:	53                   	push   %rbx
 15f:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 162:	be 00 00 00 00       	mov    $0x0,%esi
 167:	e8 06 01 00 00       	call   272 <open>
  if(fd < 0)
 16c:	85 c0                	test   %eax,%eax
 16e:	78 1e                	js     18e <stat+0x36>
 170:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 172:	4c 89 e6             	mov    %r12,%rsi
 175:	89 c7                	mov    %eax,%edi
 177:	e8 14 01 00 00       	call   290 <fstat>
 17c:	41 89 c4             	mov    %eax,%r12d
  close(fd);
 17f:	89 df                	mov    %ebx,%edi
 181:	e8 ce 00 00 00       	call   254 <close>
  return r;
}
 186:	44 89 e0             	mov    %r12d,%eax
 189:	5b                   	pop    %rbx
 18a:	41 5c                	pop    %r12
 18c:	5d                   	pop    %rbp
 18d:	c3                   	ret
    return -1;
 18e:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 194:	eb f0                	jmp    186 <stat+0x2e>

0000000000000196 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
 196:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
 19b:	eb 09                	jmp    1a6 <atoi+0x10>
 19d:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
 1a0:	f7 de                	neg    %esi
    s++;
 1a2:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
 1a6:	0f be 07             	movsbl (%rdi),%eax
 1a9:	83 f8 2d             	cmp    $0x2d,%eax
 1ac:	74 f2                	je     1a0 <atoi+0xa>
  n = 0;
 1ae:	b8 00 00 00 00       	mov    $0x0,%eax
 1b3:	eb 19                	jmp    1ce <atoi+0x38>
 1b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1bc:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1c0:	8d 04 80             	lea    (%rax,%rax,4),%eax
 1c3:	48 83 c7 01          	add    $0x1,%rdi
 1c7:	0f be d2             	movsbl %dl,%edx
 1ca:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
 1ce:	8a 17                	mov    (%rdi),%dl
 1d0:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 1d3:	0f b6 c9             	movzbl %cl,%ecx
 1d6:	83 f9 09             	cmp    $0x9,%ecx
 1d9:	76 e5                	jbe    1c0 <atoi+0x2a>
  return sign * n;
 1db:	0f af c6             	imul   %esi,%eax
}
 1de:	c3                   	ret

00000000000001df <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1df:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
 1e2:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
 1e5:	eb 28                	jmp    20f <memmove+0x30>
 1e7:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1ee:	00 00 00 00 
 1f2:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1f9:	00 00 00 00 
 1fd:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
 200:	8a 16                	mov    (%rsi),%dl
 202:	88 11                	mov    %dl,(%rcx)
 204:	48 8d 76 01          	lea    0x1(%rsi),%rsi
 208:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
 20c:	44 89 c2             	mov    %r8d,%edx
 20f:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
 213:	85 d2                	test   %edx,%edx
 215:	7f e9                	jg     200 <memmove+0x21>
  return vdst;
}
 217:	c3                   	ret

0000000000000218 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 218:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret

0000000000000222 <exit>:
SYSCALL(exit)
 222:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
 229:	cd 40                	int    $0x40
 22b:	c3                   	ret

000000000000022c <wait>:
SYSCALL(wait)
 22c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
 233:	cd 40                	int    $0x40
 235:	c3                   	ret

0000000000000236 <pipe>:
SYSCALL(pipe)
 236:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
 23d:	cd 40                	int    $0x40
 23f:	c3                   	ret

0000000000000240 <read>:
SYSCALL(read)
 240:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret

000000000000024a <write>:
SYSCALL(write)
 24a:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
 251:	cd 40                	int    $0x40
 253:	c3                   	ret

0000000000000254 <close>:
SYSCALL(close)
 254:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret

000000000000025e <kill>:
SYSCALL(kill)
 25e:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret

0000000000000268 <exec>:
SYSCALL(exec)
 268:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret

0000000000000272 <open>:
SYSCALL(open)
 272:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret

000000000000027c <mknod>:
SYSCALL(mknod)
 27c:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret

0000000000000286 <unlink>:
SYSCALL(unlink)
 286:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret

0000000000000290 <fstat>:
SYSCALL(fstat)
 290:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret

000000000000029a <link>:
SYSCALL(link)
 29a:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret

00000000000002a4 <mkdir>:
SYSCALL(mkdir)
 2a4:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret

00000000000002ae <chdir>:
SYSCALL(chdir)
 2ae:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret

00000000000002b8 <dup>:
SYSCALL(dup)
 2b8:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret

00000000000002c2 <getpid>:
SYSCALL(getpid)
 2c2:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret

00000000000002cc <sbrk>:
SYSCALL(sbrk)
 2cc:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret

00000000000002d6 <sleep>:
SYSCALL(sleep)
 2d6:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret

00000000000002e0 <uptime>:
SYSCALL(uptime)
 2e0:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret

00000000000002ea <vmcreate>:
SYSCALL(vmcreate)
 2ea:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret

00000000000002f4 <vmsetreg>:
SYSCALL(vmsetreg)
 2f4:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret

00000000000002fe <vmrun>:
SYSCALL(vmrun)
 2fe:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret

0000000000000308 <vmgetreg>:
SYSCALL(vmgetreg)
 308:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret
 312:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 319:	00 00 00 
 31c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 323:	00 00 00 
 326:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 32d:	00 00 00 
 330:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 337:	00 00 00 
 33a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000000340 <_va_arg>:
// Retrieve the next argument from the va_list.
static inline void *_va_arg(va_list *args)
{
    // Returns the next argument from registers if _index < 6, 
    // otherwise from the stack.
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 340:	8b 47 38             	mov    0x38(%rdi),%eax
 343:	83 f8 05             	cmp    $0x5,%eax
 346:	77 0d                	ja     355 <_va_arg+0x15>
 348:	8d 50 01             	lea    0x1(%rax),%edx
 34b:	89 57 38             	mov    %edx,0x38(%rdi)
 34e:	89 c0                	mov    %eax,%eax
 350:	48 8b 04 c7          	mov    (%rdi,%rax,8),%rax
 354:	c3                   	ret
                                  : args->more_argint[(args->_index++)-6]);
 355:	8d 50 01             	lea    0x1(%rax),%edx
 358:	89 57 38             	mov    %edx,0x38(%rdi)
 35b:	8d 40 fa             	lea    -0x6(%rax),%eax
 35e:	48 c1 e0 03          	shl    $0x3,%rax
 362:	48 03 47 30          	add    0x30(%rdi),%rax
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 366:	48 8b 00             	mov    (%rax),%rax
}
 369:	c3                   	ret

000000000000036a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36a:	55                   	push   %rbp
 36b:	48 89 e5             	mov    %rsp,%rbp
 36e:	48 83 ec 10          	sub    $0x10,%rsp
 372:	40 88 75 fc          	mov    %sil,-0x4(%rbp)
  write(fd, &c, 1);
 376:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 37a:	ba 01 00 00 00       	mov    $0x1,%edx
 37f:	e8 c6 fe ff ff       	call   24a <write>
}
 384:	48 89 ec             	mov    %rbp,%rsp
 387:	5d                   	pop    %rbp
 388:	c3                   	ret

0000000000000389 <printint>:

static void
printint(int fd, int64 xx, int base, int sgn)
{
 389:	55                   	push   %rbp
 38a:	48 89 e5             	mov    %rsp,%rbp
 38d:	41 54                	push   %r12
 38f:	53                   	push   %rbx
 390:	48 83 ec 10          	sub    $0x10,%rsp
 394:	41 89 fc             	mov    %edi,%r12d
 397:	41 89 d1             	mov    %edx,%r9d
  char buf[16];
  int i, neg;
  uint64 x;

  neg = 0;
  if(sgn && xx < 0){
 39a:	85 c9                	test   %ecx,%ecx
 39c:	0f 95 c2             	setne  %dl
 39f:	48 89 f0             	mov    %rsi,%rax
 3a2:	48 c1 e8 3f          	shr    $0x3f,%rax
 3a6:	85 c2                	test   %eax,%edx
 3a8:	74 55                	je     3ff <printint+0x76>
    neg = 1;
    x = -xx;
 3aa:	48 f7 de             	neg    %rsi
    neg = 1;
 3ad:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  } else {
    x = xx;
  }

  i = 0;
 3b3:	bb 00 00 00 00       	mov    $0x0,%ebx
 3b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 3bf:	00 
  do{
    buf[i++] = digits[x % base];
 3c0:	49 63 c9             	movslq %r9d,%rcx
 3c3:	48 89 f0             	mov    %rsi,%rax
 3c6:	ba 00 00 00 00       	mov    $0x0,%edx
 3cb:	48 f7 f1             	div    %rcx
 3ce:	89 df                	mov    %ebx,%edi
 3d0:	83 c3 01             	add    $0x1,%ebx
 3d3:	44 8a 82 b0 08 00 00 	mov    0x8b0(%rdx),%r8b
 3da:	48 63 d7             	movslq %edi,%rdx
 3dd:	44 88 44 15 e0       	mov    %r8b,-0x20(%rbp,%rdx,1)
  }while((x /= base) != 0);
 3e2:	48 89 f2             	mov    %rsi,%rdx
 3e5:	48 89 c6             	mov    %rax,%rsi
 3e8:	48 39 ca             	cmp    %rcx,%rdx
 3eb:	73 d3                	jae    3c0 <printint+0x37>
  if(neg)
 3ed:	45 85 d2             	test   %r10d,%r10d
 3f0:	74 25                	je     417 <printint+0x8e>
    buf[i++] = '-';
 3f2:	48 63 db             	movslq %ebx,%rbx
 3f5:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 3fa:	8d 5f 02             	lea    0x2(%rdi),%ebx
 3fd:	eb 18                	jmp    417 <printint+0x8e>
  neg = 0;
 3ff:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 405:	eb ac                	jmp    3b3 <printint+0x2a>

  while(--i >= 0)
    putc(fd, buf[i]);
 407:	48 63 c3             	movslq %ebx,%rax
 40a:	0f be 74 05 e0       	movsbl -0x20(%rbp,%rax,1),%esi
 40f:	44 89 e7             	mov    %r12d,%edi
 412:	e8 53 ff ff ff       	call   36a <putc>
  while(--i >= 0)
 417:	83 eb 01             	sub    $0x1,%ebx
 41a:	79 eb                	jns    407 <printint+0x7e>
}
 41c:	48 83 c4 10          	add    $0x10,%rsp
 420:	5b                   	pop    %rbx
 421:	41 5c                	pop    %r12
 423:	5d                   	pop    %rbp
 424:	c3                   	ret

0000000000000425 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 425:	55                   	push   %rbp
 426:	48 89 e5             	mov    %rsp,%rbp
 429:	41 57                	push   %r15
 42b:	41 56                	push   %r14
 42d:	41 55                	push   %r13
 42f:	41 54                	push   %r12
 431:	53                   	push   %rbx
 432:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
 439:	41 89 ff             	mov    %edi,%r15d
 43c:	49 89 f5             	mov    %rsi,%r13
 43f:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
 446:	48 89 8d 38 ff ff ff 	mov    %rcx,-0xc8(%rbp)
 44d:	4c 89 85 40 ff ff ff 	mov    %r8,-0xc0(%rbp)
 454:	4c 89 8d 48 ff ff ff 	mov    %r9,-0xb8(%rbp)
 45b:	84 c0                	test   %al,%al
 45d:	74 29                	je     488 <printf+0x63>
 45f:	0f 29 85 50 ff ff ff 	movaps %xmm0,-0xb0(%rbp)
 466:	0f 29 8d 60 ff ff ff 	movaps %xmm1,-0xa0(%rbp)
 46d:	0f 29 95 70 ff ff ff 	movaps %xmm2,-0x90(%rbp)
 474:	0f 29 5d 80          	movaps %xmm3,-0x80(%rbp)
 478:	0f 29 65 90          	movaps %xmm4,-0x70(%rbp)
 47c:	0f 29 6d a0          	movaps %xmm5,-0x60(%rbp)
 480:	0f 29 75 b0          	movaps %xmm6,-0x50(%rbp)
 484:	0f 29 7d c0          	movaps %xmm7,-0x40(%rbp)
    asm volatile("movq %%rdi, %0;" 
 488:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
 48f:	48 89 b5 e8 fe ff ff 	mov    %rsi,-0x118(%rbp)
 496:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
 49d:	48 89 8d f8 fe ff ff 	mov    %rcx,-0x108(%rbp)
 4a4:	4c 89 85 00 ff ff ff 	mov    %r8,-0x100(%rbp)
 4ab:	4c 89 8d 08 ff ff ff 	mov    %r9,-0xf8(%rbp)
    asm volatile("leaq 16(%%rbp), %0" : "=r" (args->more_argint));
 4b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
 4b6:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
    args->_index = 1;
 4bd:	c7 85 18 ff ff ff 01 	movl   $0x1,-0xe8(%rbp)
 4c4:	00 00 00 
  char *s;
  int c, i, state;
  va_list ap;

  va_start(ap, fd);
  (void) va_arg(ap, char*); // skip fmt
 4c7:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 4ce:	e8 6d fe ff ff       	call   340 <_va_arg>

  state = 0;
 4d3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(i = 0; fmt[i]; i++){
 4d9:	bb 00 00 00 00       	mov    $0x0,%ebx
 4de:	eb 16                	jmp    4f6 <printf+0xd1>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4e0:	44 89 f6             	mov    %r14d,%esi
 4e3:	44 89 ff             	mov    %r15d,%edi
 4e6:	e8 7f fe ff ff       	call   36a <putc>
 4eb:	eb 06                	jmp    4f3 <printf+0xce>
      }
    } else if(state == '%'){
 4ed:	41 83 fc 25          	cmp    $0x25,%r12d
 4f1:	74 2c                	je     51f <printf+0xfa>
  for(i = 0; fmt[i]; i++){
 4f3:	83 c3 01             	add    $0x1,%ebx
 4f6:	48 63 c3             	movslq %ebx,%rax
 4f9:	41 8a 44 05 00       	mov    0x0(%r13,%rax,1),%al
 4fe:	0f be d0             	movsbl %al,%edx
 501:	85 d2                	test   %edx,%edx
 503:	0f 84 42 01 00 00    	je     64b <printf+0x226>
    c = fmt[i] & 0xff;
 509:	44 0f be f0          	movsbl %al,%r14d
 50d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 510:	45 85 e4             	test   %r12d,%r12d
 513:	75 d8                	jne    4ed <printf+0xc8>
      if(c == '%'){
 515:	83 f8 25             	cmp    $0x25,%eax
 518:	75 c6                	jne    4e0 <printf+0xbb>
        state = '%';
 51a:	41 89 c4             	mov    %eax,%r12d
 51d:	eb d4                	jmp    4f3 <printf+0xce>
      if(c == 'd'){
 51f:	83 f8 25             	cmp    $0x25,%eax
 522:	0f 84 ea 00 00 00    	je     612 <printf+0x1ed>
 528:	0f 8c fa 00 00 00    	jl     628 <printf+0x203>
 52e:	83 f8 78             	cmp    $0x78,%eax
 531:	0f 8f f1 00 00 00    	jg     628 <printf+0x203>
 537:	83 f8 63             	cmp    $0x63,%eax
 53a:	0f 8c e8 00 00 00    	jl     628 <printf+0x203>
 540:	83 e8 63             	sub    $0x63,%eax
 543:	83 f8 15             	cmp    $0x15,%eax
 546:	0f 87 dc 00 00 00    	ja     628 <printf+0x203>
 54c:	89 c0                	mov    %eax,%eax
 54e:	ff 24 c5 00 08 00 00 	jmp    *0x800(,%rax,8)
        printint(fd, va_arg(ap, int), 10, 1);
 555:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 55c:	e8 df fd ff ff       	call   340 <_va_arg>
 561:	48 63 f0             	movslq %eax,%rsi
 564:	b9 01 00 00 00       	mov    $0x1,%ecx
 569:	ba 0a 00 00 00       	mov    $0xa,%edx
 56e:	44 89 ff             	mov    %r15d,%edi
 571:	e8 13 fe ff ff       	call   389 <printint>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 576:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 57c:	e9 72 ff ff ff       	jmp    4f3 <printf+0xce>
        printint(fd, va_arg(ap, uint64), 16, 0);
 581:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 588:	e8 b3 fd ff ff       	call   340 <_va_arg>
 58d:	48 89 c6             	mov    %rax,%rsi
 590:	b9 00 00 00 00       	mov    $0x0,%ecx
 595:	ba 10 00 00 00       	mov    $0x10,%edx
 59a:	44 89 ff             	mov    %r15d,%edi
 59d:	e8 e7 fd ff ff       	call   389 <printint>
      state = 0;
 5a2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 5a8:	e9 46 ff ff ff       	jmp    4f3 <printf+0xce>
        s = va_arg(ap, char*);
 5ad:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 5b4:	e8 87 fd ff ff       	call   340 <_va_arg>
 5b9:	49 89 c4             	mov    %rax,%r12
        if(s == 0)
 5bc:	48 85 c0             	test   %rax,%rax
 5bf:	75 18                	jne    5d9 <printf+0x1b4>
          s = "(null)";
 5c1:	41 bc f0 07 00 00    	mov    $0x7f0,%r12d
 5c7:	eb 10                	jmp    5d9 <printf+0x1b4>
          putc(fd, *s);
 5c9:	40 0f be f6          	movsbl %sil,%esi
 5cd:	44 89 ff             	mov    %r15d,%edi
 5d0:	e8 95 fd ff ff       	call   36a <putc>
          s++;
 5d5:	49 83 c4 01          	add    $0x1,%r12
        while(*s != 0){
 5d9:	41 8a 34 24          	mov    (%r12),%sil
 5dd:	40 0f be c6          	movsbl %sil,%eax
 5e1:	85 c0                	test   %eax,%eax
 5e3:	75 e4                	jne    5c9 <printf+0x1a4>
      state = 0;
 5e5:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 5eb:	e9 03 ff ff ff       	jmp    4f3 <printf+0xce>
        putc(fd, va_arg(ap, char));
 5f0:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 5f7:	e8 44 fd ff ff       	call   340 <_va_arg>
 5fc:	0f be f0             	movsbl %al,%esi
 5ff:	44 89 ff             	mov    %r15d,%edi
 602:	e8 63 fd ff ff       	call   36a <putc>
      state = 0;
 607:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 60d:	e9 e1 fe ff ff       	jmp    4f3 <printf+0xce>
        putc(fd, c);
 612:	44 89 f6             	mov    %r14d,%esi
 615:	44 89 ff             	mov    %r15d,%edi
 618:	e8 4d fd ff ff       	call   36a <putc>
      state = 0;
 61d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 623:	e9 cb fe ff ff       	jmp    4f3 <printf+0xce>
        putc(fd, '%');
 628:	be 25 00 00 00       	mov    $0x25,%esi
 62d:	44 89 ff             	mov    %r15d,%edi
 630:	e8 35 fd ff ff       	call   36a <putc>
        putc(fd, c);
 635:	44 89 f6             	mov    %r14d,%esi
 638:	44 89 ff             	mov    %r15d,%edi
 63b:	e8 2a fd ff ff       	call   36a <putc>
      state = 0;
 640:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 646:	e9 a8 fe ff ff       	jmp    4f3 <printf+0xce>
    }
  }
}
 64b:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
 652:	5b                   	pop    %rbx
 653:	41 5c                	pop    %r12
 655:	41 5d                	pop    %r13
 657:	41 5e                	pop    %r14
 659:	41 5f                	pop    %r15
 65b:	5d                   	pop    %rbp
 65c:	c3                   	ret
 65d:	0f 1f 00             	nopl   (%rax)

0000000000000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	48 89 fe             	mov    %rdi,%rsi
  Header *bp, *p;

  bp = (Header*)ap - 1;
 663:	48 8d 4f f0          	lea    -0x10(%rdi),%rcx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 667:	48 8b 05 62 04 00 00 	mov    0x462(%rip),%rax        # ad0 <freep>
 66e:	eb 03                	jmp    673 <free+0x13>
 670:	48 89 d0             	mov    %rdx,%rax
 673:	48 39 c8             	cmp    %rcx,%rax
 676:	73 05                	jae    67d <free+0x1d>
 678:	48 3b 08             	cmp    (%rax),%rcx
 67b:	72 17                	jb     694 <free+0x34>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67d:	48 8b 10             	mov    (%rax),%rdx
 680:	48 39 d0             	cmp    %rdx,%rax
 683:	72 eb                	jb     670 <free+0x10>
 685:	48 39 c8             	cmp    %rcx,%rax
 688:	72 0a                	jb     694 <free+0x34>
 68a:	48 39 d1             	cmp    %rdx,%rcx
 68d:	72 05                	jb     694 <free+0x34>
 68f:	48 89 d0             	mov    %rdx,%rax
 692:	eb df                	jmp    673 <free+0x13>
      break;
  if(bp + bp->s.size == p->s.ptr){
 694:	44 8b 46 f8          	mov    -0x8(%rsi),%r8d
 698:	44 89 c2             	mov    %r8d,%edx
 69b:	48 c1 e2 04          	shl    $0x4,%rdx
 69f:	48 01 ca             	add    %rcx,%rdx
 6a2:	48 8b 38             	mov    (%rax),%rdi
 6a5:	48 39 fa             	cmp    %rdi,%rdx
 6a8:	74 20                	je     6ca <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6aa:	48 89 7e f0          	mov    %rdi,-0x10(%rsi)
  if(p + p->s.size == bp){
 6ae:	8b 78 08             	mov    0x8(%rax),%edi
 6b1:	89 fa                	mov    %edi,%edx
 6b3:	48 c1 e2 04          	shl    $0x4,%rdx
 6b7:	48 01 c2             	add    %rax,%rdx
 6ba:	48 39 ca             	cmp    %rcx,%rdx
 6bd:	74 1f                	je     6de <free+0x7e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6bf:	48 89 08             	mov    %rcx,(%rax)
  freep = p;
 6c2:	48 89 05 07 04 00 00 	mov    %rax,0x407(%rip)        # ad0 <freep>
}
 6c9:	c3                   	ret
    bp->s.size += p->s.ptr->s.size;
 6ca:	44 03 47 08          	add    0x8(%rdi),%r8d
 6ce:	44 89 46 f8          	mov    %r8d,-0x8(%rsi)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d2:	48 8b 10             	mov    (%rax),%rdx
 6d5:	48 8b 12             	mov    (%rdx),%rdx
 6d8:	48 89 56 f0          	mov    %rdx,-0x10(%rsi)
 6dc:	eb d0                	jmp    6ae <free+0x4e>
    p->s.size += bp->s.size;
 6de:	03 7e f8             	add    -0x8(%rsi),%edi
 6e1:	89 78 08             	mov    %edi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 6e4:	48 8b 56 f0          	mov    -0x10(%rsi),%rdx
 6e8:	48 89 10             	mov    %rdx,(%rax)
 6eb:	eb d5                	jmp    6c2 <free+0x62>

00000000000006ed <morecore>:

static Header*
morecore(uint nu)
{
 6ed:	55                   	push   %rbp
 6ee:	48 89 e5             	mov    %rsp,%rbp
 6f1:	53                   	push   %rbx
 6f2:	48 83 ec 08          	sub    $0x8,%rsp
 6f6:	89 fb                	mov    %edi,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6f8:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 6fe:	77 05                	ja     705 <morecore+0x18>
    nu = 4096;
 700:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 705:	89 df                	mov    %ebx,%edi
 707:	c1 e7 04             	shl    $0x4,%edi
 70a:	e8 bd fb ff ff       	call   2cc <sbrk>
  if(p == (char*)-1)
 70f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 713:	74 1a                	je     72f <morecore+0x42>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 715:	89 58 08             	mov    %ebx,0x8(%rax)
  free((void*)(hp + 1));
 718:	48 8d 78 10          	lea    0x10(%rax),%rdi
 71c:	e8 3f ff ff ff       	call   660 <free>
  return freep;
 721:	48 8b 05 a8 03 00 00 	mov    0x3a8(%rip),%rax        # ad0 <freep>
}
 728:	48 83 c4 08          	add    $0x8,%rsp
 72c:	5b                   	pop    %rbx
 72d:	5d                   	pop    %rbp
 72e:	c3                   	ret
    return 0;
 72f:	b8 00 00 00 00       	mov    $0x0,%eax
 734:	eb f2                	jmp    728 <morecore+0x3b>

0000000000000736 <malloc>:

void*
malloc(uint nbytes)
{
 736:	55                   	push   %rbp
 737:	48 89 e5             	mov    %rsp,%rbp
 73a:	53                   	push   %rbx
 73b:	48 83 ec 08          	sub    $0x8,%rsp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73f:	89 fb                	mov    %edi,%ebx
 741:	48 83 c3 0f          	add    $0xf,%rbx
 745:	48 c1 eb 04          	shr    $0x4,%rbx
 749:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 74c:	48 8b 0d 7d 03 00 00 	mov    0x37d(%rip),%rcx        # ad0 <freep>
 753:	48 85 c9             	test   %rcx,%rcx
 756:	74 05                	je     75d <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 758:	48 8b 01             	mov    (%rcx),%rax
 75b:	eb 69                	jmp    7c6 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
 75d:	48 c7 05 68 03 00 00 	movq   $0xae0,0x368(%rip)        # ad0 <freep>
 764:	e0 0a 00 00 
 768:	48 c7 05 6d 03 00 00 	movq   $0xae0,0x36d(%rip)        # ae0 <base>
 76f:	e0 0a 00 00 
    base.s.size = 0;
 773:	c7 05 6b 03 00 00 00 	movl   $0x0,0x36b(%rip)        # ae8 <base+0x8>
 77a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 77d:	b9 e0 0a 00 00       	mov    $0xae0,%ecx
 782:	eb d4                	jmp    758 <malloc+0x22>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 784:	74 23                	je     7a9 <malloc+0x73>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 786:	29 da                	sub    %ebx,%edx
 788:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 78b:	89 d2                	mov    %edx,%edx
 78d:	48 c1 e2 04          	shl    $0x4,%rdx
 791:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 794:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 797:	48 89 0d 32 03 00 00 	mov    %rcx,0x332(%rip)        # ad0 <freep>
      return (void*)(p + 1);
 79e:	48 83 c0 10          	add    $0x10,%rax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7a2:	48 83 c4 08          	add    $0x8,%rsp
 7a6:	5b                   	pop    %rbx
 7a7:	5d                   	pop    %rbp
 7a8:	c3                   	ret
        prevp->s.ptr = p->s.ptr;
 7a9:	48 8b 10             	mov    (%rax),%rdx
 7ac:	48 89 11             	mov    %rdx,(%rcx)
 7af:	eb e6                	jmp    797 <malloc+0x61>
 7b1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 7b8:	00 00 00 00 
 7bc:	0f 1f 40 00          	nopl   0x0(%rax)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c0:	48 89 c1             	mov    %rax,%rcx
 7c3:	48 8b 00             	mov    (%rax),%rax
    if(p->s.size >= nunits){
 7c6:	8b 50 08             	mov    0x8(%rax),%edx
 7c9:	39 da                	cmp    %ebx,%edx
 7cb:	73 b7                	jae    784 <malloc+0x4e>
    if(p == freep)
 7cd:	48 39 05 fc 02 00 00 	cmp    %rax,0x2fc(%rip)        # ad0 <freep>
 7d4:	75 ea                	jne    7c0 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
 7d6:	89 df                	mov    %ebx,%edi
 7d8:	e8 10 ff ff ff       	call   6ed <morecore>
 7dd:	48 85 c0             	test   %rax,%rax
 7e0:	75 de                	jne    7c0 <malloc+0x8a>
 7e2:	eb be                	jmp    7a2 <malloc+0x6c>
