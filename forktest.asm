
_forktest:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	41 54                	push   %r12
   6:	53                   	push   %rbx
   7:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
   e:	41 89 fc             	mov    %edi,%r12d
  11:	48 89 f3             	mov    %rsi,%rbx
  14:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  1b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  22:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  29:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  30:	84 c0                	test   %al,%al
  32:	74 23                	je     57 <printf+0x57>
  34:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  3b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  3f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  43:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  47:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  4b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  4f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  53:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  write(fd, s, strlen(s));
  57:	48 89 df             	mov    %rbx,%rdi
  5a:	e8 62 01 00 00       	call   1c1 <strlen>
  5f:	89 c2                	mov    %eax,%edx
  61:	48 89 de             	mov    %rbx,%rsi
  64:	44 89 e7             	mov    %r12d,%edi
  67:	e8 1e 03 00 00       	call   38a <write>
}
  6c:	48 81 c4 b0 00 00 00 	add    $0xb0,%rsp
  73:	5b                   	pop    %rbx
  74:	41 5c                	pop    %r12
  76:	5d                   	pop    %rbp
  77:	c3                   	ret

0000000000000078 <forktest>:

void
forktest(void)
{
  78:	55                   	push   %rbp
  79:	48 89 e5             	mov    %rsp,%rbp
  7c:	53                   	push   %rbx
  7d:	48 83 ec 08          	sub    $0x8,%rsp
  int n, pid;

  printf(1, "fork test\n");
  81:	be 58 04 00 00       	mov    $0x458,%esi
  86:	bf 01 00 00 00       	mov    $0x1,%edi
  8b:	b0 00                	mov    $0x0,%al
  8d:	e8 6e ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  92:	bb 00 00 00 00       	mov    $0x0,%ebx
  97:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  9d:	7f 15                	jg     b4 <forktest+0x3c>
    pid = fork();
  9f:	e8 b4 02 00 00       	call   358 <fork>
    if(pid < 0)
  a4:	85 c0                	test   %eax,%eax
  a6:	78 0c                	js     b4 <forktest+0x3c>
      break;
    if(pid == 0)
  a8:	74 05                	je     af <forktest+0x37>
  for(n=0; n<N; n++){
  aa:	83 c3 01             	add    $0x1,%ebx
  ad:	eb e8                	jmp    97 <forktest+0x1f>
      exit();
  af:	e8 ae 02 00 00       	call   362 <exit>
  }

  if(n == N){
  b4:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  ba:	74 12                	je     ce <forktest+0x56>
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }

  for(; n > 0; n--){
  bc:	85 db                	test   %ebx,%ebx
  be:	7e 3f                	jle    ff <forktest+0x87>
    if(wait() < 0){
  c0:	e8 a7 02 00 00       	call   36c <wait>
  c5:	85 c0                	test   %eax,%eax
  c7:	78 20                	js     e9 <forktest+0x71>
  for(; n > 0; n--){
  c9:	83 eb 01             	sub    $0x1,%ebx
  cc:	eb ee                	jmp    bc <forktest+0x44>
    printf(1, "fork claimed to work N times!\n", N);
  ce:	ba e8 03 00 00       	mov    $0x3e8,%edx
  d3:	be 98 04 00 00       	mov    $0x498,%esi
  d8:	bf 01 00 00 00       	mov    $0x1,%edi
  dd:	b0 00                	mov    $0x0,%al
  df:	e8 1c ff ff ff       	call   0 <printf>
    exit();
  e4:	e8 79 02 00 00       	call   362 <exit>
      printf(1, "wait stopped early\n");
  e9:	be 63 04 00 00       	mov    $0x463,%esi
  ee:	bf 01 00 00 00       	mov    $0x1,%edi
  f3:	b0 00                	mov    $0x0,%al
  f5:	e8 06 ff ff ff       	call   0 <printf>
      exit();
  fa:	e8 63 02 00 00       	call   362 <exit>
    }
  }

  if(wait() != -1){
  ff:	e8 68 02 00 00       	call   36c <wait>
 104:	83 f8 ff             	cmp    $0xffffffff,%eax
 107:	75 18                	jne    121 <forktest+0xa9>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
 109:	be 8a 04 00 00       	mov    $0x48a,%esi
 10e:	bf 01 00 00 00       	mov    $0x1,%edi
 113:	b0 00                	mov    $0x0,%al
 115:	e8 e6 fe ff ff       	call   0 <printf>
}
 11a:	48 83 c4 08          	add    $0x8,%rsp
 11e:	5b                   	pop    %rbx
 11f:	5d                   	pop    %rbp
 120:	c3                   	ret
    printf(1, "wait got too many\n");
 121:	be 77 04 00 00       	mov    $0x477,%esi
 126:	bf 01 00 00 00       	mov    $0x1,%edi
 12b:	b0 00                	mov    $0x0,%al
 12d:	e8 ce fe ff ff       	call   0 <printf>
    exit();
 132:	e8 2b 02 00 00       	call   362 <exit>

0000000000000137 <main>:

int
main(void)
{
 137:	55                   	push   %rbp
 138:	48 89 e5             	mov    %rsp,%rbp
  forktest();
 13b:	e8 38 ff ff ff       	call   78 <forktest>
  exit();
 140:	e8 1d 02 00 00       	call   362 <exit>
 145:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 14c:	00 00 00 
 14f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 156:	00 00 00 
 159:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 160:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 163:	48 89 f9             	mov    %rdi,%rcx
 166:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 16d:	00 00 00 00 
 171:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 178:	00 00 00 00 
 17c:	0f 1f 40 00          	nopl   0x0(%rax)
 180:	48 89 f2             	mov    %rsi,%rdx
 183:	48 83 c6 01          	add    $0x1,%rsi
 187:	49 89 c8             	mov    %rcx,%r8
 18a:	48 83 c1 01          	add    $0x1,%rcx
 18e:	8a 12                	mov    (%rdx),%dl
 190:	41 88 10             	mov    %dl,(%r8)
 193:	0f be d2             	movsbl %dl,%edx
 196:	85 d2                	test   %edx,%edx
 198:	75 e6                	jne    180 <strcpy+0x20>
    ;
  return os;
}
 19a:	c3                   	ret

000000000000019b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 19b:	eb 0b                	jmp    1a8 <strcmp+0xd>
 19d:	0f 1f 00             	nopl   (%rax)
    p++, q++;
 1a0:	48 83 c7 01          	add    $0x1,%rdi
 1a4:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
 1a8:	8a 07                	mov    (%rdi),%al
 1aa:	0f be d0             	movsbl %al,%edx
 1ad:	85 d2                	test   %edx,%edx
 1af:	74 07                	je     1b8 <strcmp+0x1d>
 1b1:	0f be 0e             	movsbl (%rsi),%ecx
 1b4:	39 ca                	cmp    %ecx,%edx
 1b6:	74 e8                	je     1a0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1b8:	0f b6 c0             	movzbl %al,%eax
 1bb:	0f b6 16             	movzbl (%rsi),%edx
 1be:	29 d0                	sub    %edx,%eax
}
 1c0:	c3                   	ret

00000000000001c1 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 1c1:	b8 00 00 00 00       	mov    $0x0,%eax
 1c6:	eb 0b                	jmp    1d3 <strlen+0x12>
 1c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1cf:	00 
 1d0:	83 c0 01             	add    $0x1,%eax
 1d3:	48 63 d0             	movslq %eax,%rdx
 1d6:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
 1da:	85 d2                	test   %edx,%edx
 1dc:	75 f2                	jne    1d0 <strlen+0xf>
    ;
  return n;
}
 1de:	c3                   	ret

00000000000001df <memset>:

void*
memset(void *dst, int c, uint n)
{
 1df:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
 1e2:	89 d1                	mov    %edx,%ecx
 1e4:	89 f0                	mov    %esi,%eax
 1e6:	fc                   	cld
 1e7:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 1e9:	4c 89 c0             	mov    %r8,%rax
 1ec:	c3                   	ret

00000000000001ed <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ed:	eb 15                	jmp    204 <strchr+0x17>
 1ef:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1f6:	00 00 00 00 
 1fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 200:	48 83 c7 01          	add    $0x1,%rdi
 204:	8a 17                	mov    (%rdi),%dl
 206:	0f be c2             	movsbl %dl,%eax
 209:	85 c0                	test   %eax,%eax
 20b:	74 0f                	je     21c <strchr+0x2f>
    if(*s == c)
 20d:	0f be d2             	movsbl %dl,%edx
 210:	40 0f be c6          	movsbl %sil,%eax
 214:	39 c2                	cmp    %eax,%edx
 216:	75 e8                	jne    200 <strchr+0x13>
      return (char*)s;
 218:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
 21b:	c3                   	ret
  return 0;
 21c:	b8 00 00 00 00       	mov    $0x0,%eax
 221:	c3                   	ret

0000000000000222 <gets>:

char*
gets(char *buf, int max)
{
 222:	55                   	push   %rbp
 223:	48 89 e5             	mov    %rsp,%rbp
 226:	41 56                	push   %r14
 228:	41 55                	push   %r13
 22a:	41 54                	push   %r12
 22c:	53                   	push   %rbx
 22d:	48 83 ec 10          	sub    $0x10,%rsp
 231:	49 89 fc             	mov    %rdi,%r12
 234:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 237:	bb 00 00 00 00       	mov    $0x0,%ebx
 23c:	41 89 de             	mov    %ebx,%r14d
 23f:	83 c3 01             	add    $0x1,%ebx
 242:	44 39 eb             	cmp    %r13d,%ebx
 245:	7d 39                	jge    280 <gets+0x5e>
    cc = read(0, &c, 1);
 247:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 24b:	ba 01 00 00 00       	mov    $0x1,%edx
 250:	bf 00 00 00 00       	mov    $0x0,%edi
 255:	e8 26 01 00 00       	call   380 <read>
    if(cc < 1)
 25a:	85 c0                	test   %eax,%eax
 25c:	7e 22                	jle    280 <gets+0x5e>
      break;
    buf[i++] = c;
 25e:	4d 63 f6             	movslq %r14d,%r14
 261:	8a 45 df             	mov    -0x21(%rbp),%al
 264:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
 268:	0f be c0             	movsbl %al,%eax
 26b:	83 f8 0a             	cmp    $0xa,%eax
 26e:	0f 94 c2             	sete   %dl
 271:	83 f8 0d             	cmp    $0xd,%eax
 274:	0f 94 c0             	sete   %al
 277:	09 d0                	or     %edx,%eax
 279:	a8 ff                	test   $0xff,%al
 27b:	74 bf                	je     23c <gets+0x1a>
    buf[i++] = c;
 27d:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
 280:	4d 63 f6             	movslq %r14d,%r14
 283:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
 288:	4c 89 e0             	mov    %r12,%rax
 28b:	48 83 c4 10          	add    $0x10,%rsp
 28f:	5b                   	pop    %rbx
 290:	41 5c                	pop    %r12
 292:	41 5d                	pop    %r13
 294:	41 5e                	pop    %r14
 296:	5d                   	pop    %rbp
 297:	c3                   	ret

0000000000000298 <stat>:

int
stat(const char *n, struct stat *st)
{
 298:	55                   	push   %rbp
 299:	48 89 e5             	mov    %rsp,%rbp
 29c:	41 54                	push   %r12
 29e:	53                   	push   %rbx
 29f:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	be 00 00 00 00       	mov    $0x0,%esi
 2a7:	e8 06 01 00 00       	call   3b2 <open>
  if(fd < 0)
 2ac:	85 c0                	test   %eax,%eax
 2ae:	78 1e                	js     2ce <stat+0x36>
 2b0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2b2:	4c 89 e6             	mov    %r12,%rsi
 2b5:	89 c7                	mov    %eax,%edi
 2b7:	e8 14 01 00 00       	call   3d0 <fstat>
 2bc:	41 89 c4             	mov    %eax,%r12d
  close(fd);
 2bf:	89 df                	mov    %ebx,%edi
 2c1:	e8 ce 00 00 00       	call   394 <close>
  return r;
}
 2c6:	44 89 e0             	mov    %r12d,%eax
 2c9:	5b                   	pop    %rbx
 2ca:	41 5c                	pop    %r12
 2cc:	5d                   	pop    %rbp
 2cd:	c3                   	ret
    return -1;
 2ce:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 2d4:	eb f0                	jmp    2c6 <stat+0x2e>

00000000000002d6 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
 2d6:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
 2db:	eb 09                	jmp    2e6 <atoi+0x10>
 2dd:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
 2e0:	f7 de                	neg    %esi
    s++;
 2e2:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
 2e6:	0f be 07             	movsbl (%rdi),%eax
 2e9:	83 f8 2d             	cmp    $0x2d,%eax
 2ec:	74 f2                	je     2e0 <atoi+0xa>
  n = 0;
 2ee:	b8 00 00 00 00       	mov    $0x0,%eax
 2f3:	eb 19                	jmp    30e <atoi+0x38>
 2f5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2fc:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 300:	8d 04 80             	lea    (%rax,%rax,4),%eax
 303:	48 83 c7 01          	add    $0x1,%rdi
 307:	0f be d2             	movsbl %dl,%edx
 30a:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
 30e:	8a 17                	mov    (%rdi),%dl
 310:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 313:	0f b6 c9             	movzbl %cl,%ecx
 316:	83 f9 09             	cmp    $0x9,%ecx
 319:	76 e5                	jbe    300 <atoi+0x2a>
  return sign * n;
 31b:	0f af c6             	imul   %esi,%eax
}
 31e:	c3                   	ret

000000000000031f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31f:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
 322:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
 325:	eb 28                	jmp    34f <memmove+0x30>
 327:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 32e:	00 00 00 00 
 332:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 339:	00 00 00 00 
 33d:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
 340:	8a 16                	mov    (%rsi),%dl
 342:	88 11                	mov    %dl,(%rcx)
 344:	48 8d 76 01          	lea    0x1(%rsi),%rsi
 348:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
 34c:	44 89 c2             	mov    %r8d,%edx
 34f:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
 353:	85 d2                	test   %edx,%edx
 355:	7f e9                	jg     340 <memmove+0x21>
  return vdst;
}
 357:	c3                   	ret

0000000000000358 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 358:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret

0000000000000362 <exit>:
SYSCALL(exit)
 362:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret

000000000000036c <wait>:
SYSCALL(wait)
 36c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret

0000000000000376 <pipe>:
SYSCALL(pipe)
 376:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret

0000000000000380 <read>:
SYSCALL(read)
 380:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret

000000000000038a <write>:
SYSCALL(write)
 38a:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret

0000000000000394 <close>:
SYSCALL(close)
 394:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret

000000000000039e <kill>:
SYSCALL(kill)
 39e:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret

00000000000003a8 <exec>:
SYSCALL(exec)
 3a8:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret

00000000000003b2 <open>:
SYSCALL(open)
 3b2:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret

00000000000003bc <mknod>:
SYSCALL(mknod)
 3bc:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret

00000000000003c6 <unlink>:
SYSCALL(unlink)
 3c6:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret

00000000000003d0 <fstat>:
SYSCALL(fstat)
 3d0:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret

00000000000003da <link>:
SYSCALL(link)
 3da:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret

00000000000003e4 <mkdir>:
SYSCALL(mkdir)
 3e4:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret

00000000000003ee <chdir>:
SYSCALL(chdir)
 3ee:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret

00000000000003f8 <dup>:
SYSCALL(dup)
 3f8:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret

0000000000000402 <getpid>:
SYSCALL(getpid)
 402:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret

000000000000040c <sbrk>:
SYSCALL(sbrk)
 40c:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret

0000000000000416 <sleep>:
SYSCALL(sleep)
 416:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret

0000000000000420 <uptime>:
SYSCALL(uptime)
 420:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret

000000000000042a <vmcreate>:
SYSCALL(vmcreate)
 42a:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret

0000000000000434 <vmsetreg>:
SYSCALL(vmsetreg)
 434:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret

000000000000043e <vmrun>:
SYSCALL(vmrun)
 43e:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret

0000000000000448 <vmgetreg>:
SYSCALL(vmgetreg)
 448:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret
