
_init:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	53                   	push   %rbx
   5:	48 83 ec 08          	sub    $0x8,%rsp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	be 02 00 00 00       	mov    $0x2,%esi
   e:	bf b0 08 00 00       	mov    $0x8b0,%edi
  13:	e8 1a 03 00 00       	call   332 <open>
  18:	85 c0                	test   %eax,%eax
  1a:	78 16                	js     32 <main+0x32>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1c:	bf 00 00 00 00       	mov    $0x0,%edi
  21:	e8 52 03 00 00       	call   378 <dup>
  dup(0);  // stderr
  26:	bf 00 00 00 00       	mov    $0x0,%edi
  2b:	e8 48 03 00 00       	call   378 <dup>
  30:	eb 59                	jmp    8b <main+0x8b>
    mknod("console", 1, 1);
  32:	ba 01 00 00 00       	mov    $0x1,%edx
  37:	be 01 00 00 00       	mov    $0x1,%esi
  3c:	bf b0 08 00 00       	mov    $0x8b0,%edi
  41:	e8 f6 02 00 00       	call   33c <mknod>
    open("console", O_RDWR);
  46:	be 02 00 00 00       	mov    $0x2,%esi
  4b:	bf b0 08 00 00       	mov    $0x8b0,%edi
  50:	e8 dd 02 00 00       	call   332 <open>
  55:	eb c5                	jmp    1c <main+0x1c>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  57:	be cb 08 00 00       	mov    $0x8cb,%esi
  5c:	bf 01 00 00 00       	mov    $0x1,%edi
  61:	b0 00                	mov    $0x0,%al
  63:	e8 7d 04 00 00       	call   4e5 <printf>
      exit();
  68:	e8 75 02 00 00       	call   2e2 <exit>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  6d:	be f7 08 00 00       	mov    $0x8f7,%esi
  72:	bf 01 00 00 00       	mov    $0x1,%edi
  77:	b0 00                	mov    $0x0,%al
  79:	e8 67 04 00 00       	call   4e5 <printf>
    while((wpid=wait()) >= 0 && wpid != pid)
  7e:	e8 69 02 00 00       	call   2ec <wait>
  83:	85 c0                	test   %eax,%eax
  85:	78 04                	js     8b <main+0x8b>
  87:	39 c3                	cmp    %eax,%ebx
  89:	75 e2                	jne    6d <main+0x6d>
    printf(1, "init: starting sh\n");
  8b:	be b8 08 00 00       	mov    $0x8b8,%esi
  90:	bf 01 00 00 00       	mov    $0x1,%edi
  95:	b0 00                	mov    $0x0,%al
  97:	e8 49 04 00 00       	call   4e5 <printf>
    pid = fork();
  9c:	e8 37 02 00 00       	call   2d8 <fork>
  a1:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  a3:	85 c0                	test   %eax,%eax
  a5:	78 b0                	js     57 <main+0x57>
    if(pid == 0){
  a7:	75 d5                	jne    7e <main+0x7e>
      exec("sh", argv);
  a9:	be e0 0b 00 00       	mov    $0xbe0,%esi
  ae:	bf de 08 00 00       	mov    $0x8de,%edi
  b3:	e8 70 02 00 00       	call   328 <exec>
      printf(1, "init: exec sh failed\n");
  b8:	be e1 08 00 00       	mov    $0x8e1,%esi
  bd:	bf 01 00 00 00       	mov    $0x1,%edi
  c2:	b0 00                	mov    $0x0,%al
  c4:	e8 1c 04 00 00       	call   4e5 <printf>
      exit();
  c9:	e8 14 02 00 00       	call   2e2 <exit>
  ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  d5:	00 00 00 
  d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  df:	00 

00000000000000e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  e0:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e3:	48 89 f9             	mov    %rdi,%rcx
  e6:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  ed:	00 00 00 00 
  f1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  f8:	00 00 00 00 
  fc:	0f 1f 40 00          	nopl   0x0(%rax)
 100:	48 89 f2             	mov    %rsi,%rdx
 103:	48 83 c6 01          	add    $0x1,%rsi
 107:	49 89 c8             	mov    %rcx,%r8
 10a:	48 83 c1 01          	add    $0x1,%rcx
 10e:	8a 12                	mov    (%rdx),%dl
 110:	41 88 10             	mov    %dl,(%r8)
 113:	0f be d2             	movsbl %dl,%edx
 116:	85 d2                	test   %edx,%edx
 118:	75 e6                	jne    100 <strcpy+0x20>
    ;
  return os;
}
 11a:	c3                   	ret

000000000000011b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 11b:	eb 0b                	jmp    128 <strcmp+0xd>
 11d:	0f 1f 00             	nopl   (%rax)
    p++, q++;
 120:	48 83 c7 01          	add    $0x1,%rdi
 124:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
 128:	8a 07                	mov    (%rdi),%al
 12a:	0f be d0             	movsbl %al,%edx
 12d:	85 d2                	test   %edx,%edx
 12f:	74 07                	je     138 <strcmp+0x1d>
 131:	0f be 0e             	movsbl (%rsi),%ecx
 134:	39 ca                	cmp    %ecx,%edx
 136:	74 e8                	je     120 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 138:	0f b6 c0             	movzbl %al,%eax
 13b:	0f b6 16             	movzbl (%rsi),%edx
 13e:	29 d0                	sub    %edx,%eax
}
 140:	c3                   	ret

0000000000000141 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 141:	b8 00 00 00 00       	mov    $0x0,%eax
 146:	eb 0b                	jmp    153 <strlen+0x12>
 148:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 14f:	00 
 150:	83 c0 01             	add    $0x1,%eax
 153:	48 63 d0             	movslq %eax,%rdx
 156:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
 15a:	85 d2                	test   %edx,%edx
 15c:	75 f2                	jne    150 <strlen+0xf>
    ;
  return n;
}
 15e:	c3                   	ret

000000000000015f <memset>:

void*
memset(void *dst, int c, uint n)
{
 15f:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
 162:	89 d1                	mov    %edx,%ecx
 164:	89 f0                	mov    %esi,%eax
 166:	fc                   	cld
 167:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 169:	4c 89 c0             	mov    %r8,%rax
 16c:	c3                   	ret

000000000000016d <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16d:	eb 15                	jmp    184 <strchr+0x17>
 16f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 176:	00 00 00 00 
 17a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 180:	48 83 c7 01          	add    $0x1,%rdi
 184:	8a 17                	mov    (%rdi),%dl
 186:	0f be c2             	movsbl %dl,%eax
 189:	85 c0                	test   %eax,%eax
 18b:	74 0f                	je     19c <strchr+0x2f>
    if(*s == c)
 18d:	0f be d2             	movsbl %dl,%edx
 190:	40 0f be c6          	movsbl %sil,%eax
 194:	39 c2                	cmp    %eax,%edx
 196:	75 e8                	jne    180 <strchr+0x13>
      return (char*)s;
 198:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
 19b:	c3                   	ret
  return 0;
 19c:	b8 00 00 00 00       	mov    $0x0,%eax
 1a1:	c3                   	ret

00000000000001a2 <gets>:

char*
gets(char *buf, int max)
{
 1a2:	55                   	push   %rbp
 1a3:	48 89 e5             	mov    %rsp,%rbp
 1a6:	41 56                	push   %r14
 1a8:	41 55                	push   %r13
 1aa:	41 54                	push   %r12
 1ac:	53                   	push   %rbx
 1ad:	48 83 ec 10          	sub    $0x10,%rsp
 1b1:	49 89 fc             	mov    %rdi,%r12
 1b4:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b7:	bb 00 00 00 00       	mov    $0x0,%ebx
 1bc:	41 89 de             	mov    %ebx,%r14d
 1bf:	83 c3 01             	add    $0x1,%ebx
 1c2:	44 39 eb             	cmp    %r13d,%ebx
 1c5:	7d 39                	jge    200 <gets+0x5e>
    cc = read(0, &c, 1);
 1c7:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 1cb:	ba 01 00 00 00       	mov    $0x1,%edx
 1d0:	bf 00 00 00 00       	mov    $0x0,%edi
 1d5:	e8 26 01 00 00       	call   300 <read>
    if(cc < 1)
 1da:	85 c0                	test   %eax,%eax
 1dc:	7e 22                	jle    200 <gets+0x5e>
      break;
    buf[i++] = c;
 1de:	4d 63 f6             	movslq %r14d,%r14
 1e1:	8a 45 df             	mov    -0x21(%rbp),%al
 1e4:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
 1e8:	0f be c0             	movsbl %al,%eax
 1eb:	83 f8 0a             	cmp    $0xa,%eax
 1ee:	0f 94 c2             	sete   %dl
 1f1:	83 f8 0d             	cmp    $0xd,%eax
 1f4:	0f 94 c0             	sete   %al
 1f7:	09 d0                	or     %edx,%eax
 1f9:	a8 ff                	test   $0xff,%al
 1fb:	74 bf                	je     1bc <gets+0x1a>
    buf[i++] = c;
 1fd:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
 200:	4d 63 f6             	movslq %r14d,%r14
 203:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
 208:	4c 89 e0             	mov    %r12,%rax
 20b:	48 83 c4 10          	add    $0x10,%rsp
 20f:	5b                   	pop    %rbx
 210:	41 5c                	pop    %r12
 212:	41 5d                	pop    %r13
 214:	41 5e                	pop    %r14
 216:	5d                   	pop    %rbp
 217:	c3                   	ret

0000000000000218 <stat>:

int
stat(const char *n, struct stat *st)
{
 218:	55                   	push   %rbp
 219:	48 89 e5             	mov    %rsp,%rbp
 21c:	41 54                	push   %r12
 21e:	53                   	push   %rbx
 21f:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 222:	be 00 00 00 00       	mov    $0x0,%esi
 227:	e8 06 01 00 00       	call   332 <open>
  if(fd < 0)
 22c:	85 c0                	test   %eax,%eax
 22e:	78 1e                	js     24e <stat+0x36>
 230:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 232:	4c 89 e6             	mov    %r12,%rsi
 235:	89 c7                	mov    %eax,%edi
 237:	e8 14 01 00 00       	call   350 <fstat>
 23c:	41 89 c4             	mov    %eax,%r12d
  close(fd);
 23f:	89 df                	mov    %ebx,%edi
 241:	e8 ce 00 00 00       	call   314 <close>
  return r;
}
 246:	44 89 e0             	mov    %r12d,%eax
 249:	5b                   	pop    %rbx
 24a:	41 5c                	pop    %r12
 24c:	5d                   	pop    %rbp
 24d:	c3                   	ret
    return -1;
 24e:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 254:	eb f0                	jmp    246 <stat+0x2e>

0000000000000256 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
 256:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
 25b:	eb 09                	jmp    266 <atoi+0x10>
 25d:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
 260:	f7 de                	neg    %esi
    s++;
 262:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
 266:	0f be 07             	movsbl (%rdi),%eax
 269:	83 f8 2d             	cmp    $0x2d,%eax
 26c:	74 f2                	je     260 <atoi+0xa>
  n = 0;
 26e:	b8 00 00 00 00       	mov    $0x0,%eax
 273:	eb 19                	jmp    28e <atoi+0x38>
 275:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 27c:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 280:	8d 04 80             	lea    (%rax,%rax,4),%eax
 283:	48 83 c7 01          	add    $0x1,%rdi
 287:	0f be d2             	movsbl %dl,%edx
 28a:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
 28e:	8a 17                	mov    (%rdi),%dl
 290:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 293:	0f b6 c9             	movzbl %cl,%ecx
 296:	83 f9 09             	cmp    $0x9,%ecx
 299:	76 e5                	jbe    280 <atoi+0x2a>
  return sign * n;
 29b:	0f af c6             	imul   %esi,%eax
}
 29e:	c3                   	ret

000000000000029f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29f:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
 2a2:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
 2a5:	eb 28                	jmp    2cf <memmove+0x30>
 2a7:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2ae:	00 00 00 00 
 2b2:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2b9:	00 00 00 00 
 2bd:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
 2c0:	8a 16                	mov    (%rsi),%dl
 2c2:	88 11                	mov    %dl,(%rcx)
 2c4:	48 8d 76 01          	lea    0x1(%rsi),%rsi
 2c8:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
 2cc:	44 89 c2             	mov    %r8d,%edx
 2cf:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
 2d3:	85 d2                	test   %edx,%edx
 2d5:	7f e9                	jg     2c0 <memmove+0x21>
  return vdst;
}
 2d7:	c3                   	ret

00000000000002d8 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d8:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret

00000000000002e2 <exit>:
SYSCALL(exit)
 2e2:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret

00000000000002ec <wait>:
SYSCALL(wait)
 2ec:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret

00000000000002f6 <pipe>:
SYSCALL(pipe)
 2f6:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret

0000000000000300 <read>:
SYSCALL(read)
 300:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret

000000000000030a <write>:
SYSCALL(write)
 30a:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret

0000000000000314 <close>:
SYSCALL(close)
 314:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret

000000000000031e <kill>:
SYSCALL(kill)
 31e:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret

0000000000000328 <exec>:
SYSCALL(exec)
 328:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret

0000000000000332 <open>:
SYSCALL(open)
 332:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret

000000000000033c <mknod>:
SYSCALL(mknod)
 33c:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret

0000000000000346 <unlink>:
SYSCALL(unlink)
 346:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret

0000000000000350 <fstat>:
SYSCALL(fstat)
 350:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret

000000000000035a <link>:
SYSCALL(link)
 35a:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret

0000000000000364 <mkdir>:
SYSCALL(mkdir)
 364:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret

000000000000036e <chdir>:
SYSCALL(chdir)
 36e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret

0000000000000378 <dup>:
SYSCALL(dup)
 378:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret

0000000000000382 <getpid>:
SYSCALL(getpid)
 382:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret

000000000000038c <sbrk>:
SYSCALL(sbrk)
 38c:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret

0000000000000396 <sleep>:
SYSCALL(sleep)
 396:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret

00000000000003a0 <uptime>:
SYSCALL(uptime)
 3a0:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret

00000000000003aa <vmcreate>:
SYSCALL(vmcreate)
 3aa:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret

00000000000003b4 <vmsetreg>:
SYSCALL(vmsetreg)
 3b4:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret

00000000000003be <vmrun>:
SYSCALL(vmrun)
 3be:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret

00000000000003c8 <vmgetreg>:
SYSCALL(vmgetreg)
 3c8:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret
 3d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 3d9:	00 00 00 
 3dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 3e3:	00 00 00 
 3e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 3ed:	00 00 00 
 3f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 3f7:	00 00 00 
 3fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000000400 <_va_arg>:
// Retrieve the next argument from the va_list.
static inline void *_va_arg(va_list *args)
{
    // Returns the next argument from registers if _index < 6, 
    // otherwise from the stack.
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 400:	8b 47 38             	mov    0x38(%rdi),%eax
 403:	83 f8 05             	cmp    $0x5,%eax
 406:	77 0d                	ja     415 <_va_arg+0x15>
 408:	8d 50 01             	lea    0x1(%rax),%edx
 40b:	89 57 38             	mov    %edx,0x38(%rdi)
 40e:	89 c0                	mov    %eax,%eax
 410:	48 8b 04 c7          	mov    (%rdi,%rax,8),%rax
 414:	c3                   	ret
                                  : args->more_argint[(args->_index++)-6]);
 415:	8d 50 01             	lea    0x1(%rax),%edx
 418:	89 57 38             	mov    %edx,0x38(%rdi)
 41b:	8d 40 fa             	lea    -0x6(%rax),%eax
 41e:	48 c1 e0 03          	shl    $0x3,%rax
 422:	48 03 47 30          	add    0x30(%rdi),%rax
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 426:	48 8b 00             	mov    (%rax),%rax
}
 429:	c3                   	ret

000000000000042a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 42a:	55                   	push   %rbp
 42b:	48 89 e5             	mov    %rsp,%rbp
 42e:	48 83 ec 10          	sub    $0x10,%rsp
 432:	40 88 75 fc          	mov    %sil,-0x4(%rbp)
  write(fd, &c, 1);
 436:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 43a:	ba 01 00 00 00       	mov    $0x1,%edx
 43f:	e8 c6 fe ff ff       	call   30a <write>
}
 444:	48 89 ec             	mov    %rbp,%rsp
 447:	5d                   	pop    %rbp
 448:	c3                   	ret

0000000000000449 <printint>:

static void
printint(int fd, int64 xx, int base, int sgn)
{
 449:	55                   	push   %rbp
 44a:	48 89 e5             	mov    %rsp,%rbp
 44d:	41 54                	push   %r12
 44f:	53                   	push   %rbx
 450:	48 83 ec 10          	sub    $0x10,%rsp
 454:	41 89 fc             	mov    %edi,%r12d
 457:	41 89 d1             	mov    %edx,%r9d
  char buf[16];
  int i, neg;
  uint64 x;

  neg = 0;
  if(sgn && xx < 0){
 45a:	85 c9                	test   %ecx,%ecx
 45c:	0f 95 c2             	setne  %dl
 45f:	48 89 f0             	mov    %rsi,%rax
 462:	48 c1 e8 3f          	shr    $0x3f,%rax
 466:	85 c2                	test   %eax,%edx
 468:	74 55                	je     4bf <printint+0x76>
    neg = 1;
    x = -xx;
 46a:	48 f7 de             	neg    %rsi
    neg = 1;
 46d:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  } else {
    x = xx;
  }

  i = 0;
 473:	bb 00 00 00 00       	mov    $0x0,%ebx
 478:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 47f:	00 
  do{
    buf[i++] = digits[x % base];
 480:	49 63 c9             	movslq %r9d,%rcx
 483:	48 89 f0             	mov    %rsi,%rax
 486:	ba 00 00 00 00       	mov    $0x0,%edx
 48b:	48 f7 f1             	div    %rcx
 48e:	89 df                	mov    %ebx,%edi
 490:	83 c3 01             	add    $0x1,%ebx
 493:	44 8a 82 c0 09 00 00 	mov    0x9c0(%rdx),%r8b
 49a:	48 63 d7             	movslq %edi,%rdx
 49d:	44 88 44 15 e0       	mov    %r8b,-0x20(%rbp,%rdx,1)
  }while((x /= base) != 0);
 4a2:	48 89 f2             	mov    %rsi,%rdx
 4a5:	48 89 c6             	mov    %rax,%rsi
 4a8:	48 39 ca             	cmp    %rcx,%rdx
 4ab:	73 d3                	jae    480 <printint+0x37>
  if(neg)
 4ad:	45 85 d2             	test   %r10d,%r10d
 4b0:	74 25                	je     4d7 <printint+0x8e>
    buf[i++] = '-';
 4b2:	48 63 db             	movslq %ebx,%rbx
 4b5:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 4ba:	8d 5f 02             	lea    0x2(%rdi),%ebx
 4bd:	eb 18                	jmp    4d7 <printint+0x8e>
  neg = 0;
 4bf:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 4c5:	eb ac                	jmp    473 <printint+0x2a>

  while(--i >= 0)
    putc(fd, buf[i]);
 4c7:	48 63 c3             	movslq %ebx,%rax
 4ca:	0f be 74 05 e0       	movsbl -0x20(%rbp,%rax,1),%esi
 4cf:	44 89 e7             	mov    %r12d,%edi
 4d2:	e8 53 ff ff ff       	call   42a <putc>
  while(--i >= 0)
 4d7:	83 eb 01             	sub    $0x1,%ebx
 4da:	79 eb                	jns    4c7 <printint+0x7e>
}
 4dc:	48 83 c4 10          	add    $0x10,%rsp
 4e0:	5b                   	pop    %rbx
 4e1:	41 5c                	pop    %r12
 4e3:	5d                   	pop    %rbp
 4e4:	c3                   	ret

00000000000004e5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4e5:	55                   	push   %rbp
 4e6:	48 89 e5             	mov    %rsp,%rbp
 4e9:	41 57                	push   %r15
 4eb:	41 56                	push   %r14
 4ed:	41 55                	push   %r13
 4ef:	41 54                	push   %r12
 4f1:	53                   	push   %rbx
 4f2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
 4f9:	41 89 ff             	mov    %edi,%r15d
 4fc:	49 89 f5             	mov    %rsi,%r13
 4ff:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
 506:	48 89 8d 38 ff ff ff 	mov    %rcx,-0xc8(%rbp)
 50d:	4c 89 85 40 ff ff ff 	mov    %r8,-0xc0(%rbp)
 514:	4c 89 8d 48 ff ff ff 	mov    %r9,-0xb8(%rbp)
 51b:	84 c0                	test   %al,%al
 51d:	74 29                	je     548 <printf+0x63>
 51f:	0f 29 85 50 ff ff ff 	movaps %xmm0,-0xb0(%rbp)
 526:	0f 29 8d 60 ff ff ff 	movaps %xmm1,-0xa0(%rbp)
 52d:	0f 29 95 70 ff ff ff 	movaps %xmm2,-0x90(%rbp)
 534:	0f 29 5d 80          	movaps %xmm3,-0x80(%rbp)
 538:	0f 29 65 90          	movaps %xmm4,-0x70(%rbp)
 53c:	0f 29 6d a0          	movaps %xmm5,-0x60(%rbp)
 540:	0f 29 75 b0          	movaps %xmm6,-0x50(%rbp)
 544:	0f 29 7d c0          	movaps %xmm7,-0x40(%rbp)
    asm volatile("movq %%rdi, %0;" 
 548:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
 54f:	48 89 b5 e8 fe ff ff 	mov    %rsi,-0x118(%rbp)
 556:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
 55d:	48 89 8d f8 fe ff ff 	mov    %rcx,-0x108(%rbp)
 564:	4c 89 85 00 ff ff ff 	mov    %r8,-0x100(%rbp)
 56b:	4c 89 8d 08 ff ff ff 	mov    %r9,-0xf8(%rbp)
    asm volatile("leaq 16(%%rbp), %0" : "=r" (args->more_argint));
 572:	48 8d 45 10          	lea    0x10(%rbp),%rax
 576:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
    args->_index = 1;
 57d:	c7 85 18 ff ff ff 01 	movl   $0x1,-0xe8(%rbp)
 584:	00 00 00 
  char *s;
  int c, i, state;
  va_list ap;

  va_start(ap, fd);
  (void) va_arg(ap, char*); // skip fmt
 587:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 58e:	e8 6d fe ff ff       	call   400 <_va_arg>

  state = 0;
 593:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(i = 0; fmt[i]; i++){
 599:	bb 00 00 00 00       	mov    $0x0,%ebx
 59e:	eb 16                	jmp    5b6 <printf+0xd1>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5a0:	44 89 f6             	mov    %r14d,%esi
 5a3:	44 89 ff             	mov    %r15d,%edi
 5a6:	e8 7f fe ff ff       	call   42a <putc>
 5ab:	eb 06                	jmp    5b3 <printf+0xce>
      }
    } else if(state == '%'){
 5ad:	41 83 fc 25          	cmp    $0x25,%r12d
 5b1:	74 2c                	je     5df <printf+0xfa>
  for(i = 0; fmt[i]; i++){
 5b3:	83 c3 01             	add    $0x1,%ebx
 5b6:	48 63 c3             	movslq %ebx,%rax
 5b9:	41 8a 44 05 00       	mov    0x0(%r13,%rax,1),%al
 5be:	0f be d0             	movsbl %al,%edx
 5c1:	85 d2                	test   %edx,%edx
 5c3:	0f 84 42 01 00 00    	je     70b <printf+0x226>
    c = fmt[i] & 0xff;
 5c9:	44 0f be f0          	movsbl %al,%r14d
 5cd:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5d0:	45 85 e4             	test   %r12d,%r12d
 5d3:	75 d8                	jne    5ad <printf+0xc8>
      if(c == '%'){
 5d5:	83 f8 25             	cmp    $0x25,%eax
 5d8:	75 c6                	jne    5a0 <printf+0xbb>
        state = '%';
 5da:	41 89 c4             	mov    %eax,%r12d
 5dd:	eb d4                	jmp    5b3 <printf+0xce>
      if(c == 'd'){
 5df:	83 f8 25             	cmp    $0x25,%eax
 5e2:	0f 84 ea 00 00 00    	je     6d2 <printf+0x1ed>
 5e8:	0f 8c fa 00 00 00    	jl     6e8 <printf+0x203>
 5ee:	83 f8 78             	cmp    $0x78,%eax
 5f1:	0f 8f f1 00 00 00    	jg     6e8 <printf+0x203>
 5f7:	83 f8 63             	cmp    $0x63,%eax
 5fa:	0f 8c e8 00 00 00    	jl     6e8 <printf+0x203>
 600:	83 e8 63             	sub    $0x63,%eax
 603:	83 f8 15             	cmp    $0x15,%eax
 606:	0f 87 dc 00 00 00    	ja     6e8 <printf+0x203>
 60c:	89 c0                	mov    %eax,%eax
 60e:	ff 24 c5 10 09 00 00 	jmp    *0x910(,%rax,8)
        printint(fd, va_arg(ap, int), 10, 1);
 615:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 61c:	e8 df fd ff ff       	call   400 <_va_arg>
 621:	48 63 f0             	movslq %eax,%rsi
 624:	b9 01 00 00 00       	mov    $0x1,%ecx
 629:	ba 0a 00 00 00       	mov    $0xa,%edx
 62e:	44 89 ff             	mov    %r15d,%edi
 631:	e8 13 fe ff ff       	call   449 <printint>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 636:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 63c:	e9 72 ff ff ff       	jmp    5b3 <printf+0xce>
        printint(fd, va_arg(ap, uint64), 16, 0);
 641:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 648:	e8 b3 fd ff ff       	call   400 <_va_arg>
 64d:	48 89 c6             	mov    %rax,%rsi
 650:	b9 00 00 00 00       	mov    $0x0,%ecx
 655:	ba 10 00 00 00       	mov    $0x10,%edx
 65a:	44 89 ff             	mov    %r15d,%edi
 65d:	e8 e7 fd ff ff       	call   449 <printint>
      state = 0;
 662:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 668:	e9 46 ff ff ff       	jmp    5b3 <printf+0xce>
        s = va_arg(ap, char*);
 66d:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 674:	e8 87 fd ff ff       	call   400 <_va_arg>
 679:	49 89 c4             	mov    %rax,%r12
        if(s == 0)
 67c:	48 85 c0             	test   %rax,%rax
 67f:	75 18                	jne    699 <printf+0x1b4>
          s = "(null)";
 681:	41 bc 00 09 00 00    	mov    $0x900,%r12d
 687:	eb 10                	jmp    699 <printf+0x1b4>
          putc(fd, *s);
 689:	40 0f be f6          	movsbl %sil,%esi
 68d:	44 89 ff             	mov    %r15d,%edi
 690:	e8 95 fd ff ff       	call   42a <putc>
          s++;
 695:	49 83 c4 01          	add    $0x1,%r12
        while(*s != 0){
 699:	41 8a 34 24          	mov    (%r12),%sil
 69d:	40 0f be c6          	movsbl %sil,%eax
 6a1:	85 c0                	test   %eax,%eax
 6a3:	75 e4                	jne    689 <printf+0x1a4>
      state = 0;
 6a5:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 6ab:	e9 03 ff ff ff       	jmp    5b3 <printf+0xce>
        putc(fd, va_arg(ap, char));
 6b0:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 6b7:	e8 44 fd ff ff       	call   400 <_va_arg>
 6bc:	0f be f0             	movsbl %al,%esi
 6bf:	44 89 ff             	mov    %r15d,%edi
 6c2:	e8 63 fd ff ff       	call   42a <putc>
      state = 0;
 6c7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 6cd:	e9 e1 fe ff ff       	jmp    5b3 <printf+0xce>
        putc(fd, c);
 6d2:	44 89 f6             	mov    %r14d,%esi
 6d5:	44 89 ff             	mov    %r15d,%edi
 6d8:	e8 4d fd ff ff       	call   42a <putc>
      state = 0;
 6dd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 6e3:	e9 cb fe ff ff       	jmp    5b3 <printf+0xce>
        putc(fd, '%');
 6e8:	be 25 00 00 00       	mov    $0x25,%esi
 6ed:	44 89 ff             	mov    %r15d,%edi
 6f0:	e8 35 fd ff ff       	call   42a <putc>
        putc(fd, c);
 6f5:	44 89 f6             	mov    %r14d,%esi
 6f8:	44 89 ff             	mov    %r15d,%edi
 6fb:	e8 2a fd ff ff       	call   42a <putc>
      state = 0;
 700:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 706:	e9 a8 fe ff ff       	jmp    5b3 <printf+0xce>
    }
  }
}
 70b:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
 712:	5b                   	pop    %rbx
 713:	41 5c                	pop    %r12
 715:	41 5d                	pop    %r13
 717:	41 5e                	pop    %r14
 719:	41 5f                	pop    %r15
 71b:	5d                   	pop    %rbp
 71c:	c3                   	ret
 71d:	0f 1f 00             	nopl   (%rax)

0000000000000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	48 89 fe             	mov    %rdi,%rsi
  Header *bp, *p;

  bp = (Header*)ap - 1;
 723:	48 8d 4f f0          	lea    -0x10(%rdi),%rcx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 727:	48 8b 05 c2 04 00 00 	mov    0x4c2(%rip),%rax        # bf0 <freep>
 72e:	eb 03                	jmp    733 <free+0x13>
 730:	48 89 d0             	mov    %rdx,%rax
 733:	48 39 c8             	cmp    %rcx,%rax
 736:	73 05                	jae    73d <free+0x1d>
 738:	48 3b 08             	cmp    (%rax),%rcx
 73b:	72 17                	jb     754 <free+0x34>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73d:	48 8b 10             	mov    (%rax),%rdx
 740:	48 39 d0             	cmp    %rdx,%rax
 743:	72 eb                	jb     730 <free+0x10>
 745:	48 39 c8             	cmp    %rcx,%rax
 748:	72 0a                	jb     754 <free+0x34>
 74a:	48 39 d1             	cmp    %rdx,%rcx
 74d:	72 05                	jb     754 <free+0x34>
 74f:	48 89 d0             	mov    %rdx,%rax
 752:	eb df                	jmp    733 <free+0x13>
      break;
  if(bp + bp->s.size == p->s.ptr){
 754:	44 8b 46 f8          	mov    -0x8(%rsi),%r8d
 758:	44 89 c2             	mov    %r8d,%edx
 75b:	48 c1 e2 04          	shl    $0x4,%rdx
 75f:	48 01 ca             	add    %rcx,%rdx
 762:	48 8b 38             	mov    (%rax),%rdi
 765:	48 39 fa             	cmp    %rdi,%rdx
 768:	74 20                	je     78a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 76a:	48 89 7e f0          	mov    %rdi,-0x10(%rsi)
  if(p + p->s.size == bp){
 76e:	8b 78 08             	mov    0x8(%rax),%edi
 771:	89 fa                	mov    %edi,%edx
 773:	48 c1 e2 04          	shl    $0x4,%rdx
 777:	48 01 c2             	add    %rax,%rdx
 77a:	48 39 ca             	cmp    %rcx,%rdx
 77d:	74 1f                	je     79e <free+0x7e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 77f:	48 89 08             	mov    %rcx,(%rax)
  freep = p;
 782:	48 89 05 67 04 00 00 	mov    %rax,0x467(%rip)        # bf0 <freep>
}
 789:	c3                   	ret
    bp->s.size += p->s.ptr->s.size;
 78a:	44 03 47 08          	add    0x8(%rdi),%r8d
 78e:	44 89 46 f8          	mov    %r8d,-0x8(%rsi)
    bp->s.ptr = p->s.ptr->s.ptr;
 792:	48 8b 10             	mov    (%rax),%rdx
 795:	48 8b 12             	mov    (%rdx),%rdx
 798:	48 89 56 f0          	mov    %rdx,-0x10(%rsi)
 79c:	eb d0                	jmp    76e <free+0x4e>
    p->s.size += bp->s.size;
 79e:	03 7e f8             	add    -0x8(%rsi),%edi
 7a1:	89 78 08             	mov    %edi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 7a4:	48 8b 56 f0          	mov    -0x10(%rsi),%rdx
 7a8:	48 89 10             	mov    %rdx,(%rax)
 7ab:	eb d5                	jmp    782 <free+0x62>

00000000000007ad <morecore>:

static Header*
morecore(uint nu)
{
 7ad:	55                   	push   %rbp
 7ae:	48 89 e5             	mov    %rsp,%rbp
 7b1:	53                   	push   %rbx
 7b2:	48 83 ec 08          	sub    $0x8,%rsp
 7b6:	89 fb                	mov    %edi,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 7b8:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 7be:	77 05                	ja     7c5 <morecore+0x18>
    nu = 4096;
 7c0:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 7c5:	89 df                	mov    %ebx,%edi
 7c7:	c1 e7 04             	shl    $0x4,%edi
 7ca:	e8 bd fb ff ff       	call   38c <sbrk>
  if(p == (char*)-1)
 7cf:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 7d3:	74 1a                	je     7ef <morecore+0x42>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7d5:	89 58 08             	mov    %ebx,0x8(%rax)
  free((void*)(hp + 1));
 7d8:	48 8d 78 10          	lea    0x10(%rax),%rdi
 7dc:	e8 3f ff ff ff       	call   720 <free>
  return freep;
 7e1:	48 8b 05 08 04 00 00 	mov    0x408(%rip),%rax        # bf0 <freep>
}
 7e8:	48 83 c4 08          	add    $0x8,%rsp
 7ec:	5b                   	pop    %rbx
 7ed:	5d                   	pop    %rbp
 7ee:	c3                   	ret
    return 0;
 7ef:	b8 00 00 00 00       	mov    $0x0,%eax
 7f4:	eb f2                	jmp    7e8 <morecore+0x3b>

00000000000007f6 <malloc>:

void*
malloc(uint nbytes)
{
 7f6:	55                   	push   %rbp
 7f7:	48 89 e5             	mov    %rsp,%rbp
 7fa:	53                   	push   %rbx
 7fb:	48 83 ec 08          	sub    $0x8,%rsp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ff:	89 fb                	mov    %edi,%ebx
 801:	48 83 c3 0f          	add    $0xf,%rbx
 805:	48 c1 eb 04          	shr    $0x4,%rbx
 809:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 80c:	48 8b 0d dd 03 00 00 	mov    0x3dd(%rip),%rcx        # bf0 <freep>
 813:	48 85 c9             	test   %rcx,%rcx
 816:	74 05                	je     81d <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	48 8b 01             	mov    (%rcx),%rax
 81b:	eb 69                	jmp    886 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
 81d:	48 c7 05 c8 03 00 00 	movq   $0xc00,0x3c8(%rip)        # bf0 <freep>
 824:	00 0c 00 00 
 828:	48 c7 05 cd 03 00 00 	movq   $0xc00,0x3cd(%rip)        # c00 <base>
 82f:	00 0c 00 00 
    base.s.size = 0;
 833:	c7 05 cb 03 00 00 00 	movl   $0x0,0x3cb(%rip)        # c08 <base+0x8>
 83a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 83d:	b9 00 0c 00 00       	mov    $0xc00,%ecx
 842:	eb d4                	jmp    818 <malloc+0x22>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 844:	74 23                	je     869 <malloc+0x73>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 846:	29 da                	sub    %ebx,%edx
 848:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 84b:	89 d2                	mov    %edx,%edx
 84d:	48 c1 e2 04          	shl    $0x4,%rdx
 851:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 854:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 857:	48 89 0d 92 03 00 00 	mov    %rcx,0x392(%rip)        # bf0 <freep>
      return (void*)(p + 1);
 85e:	48 83 c0 10          	add    $0x10,%rax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 862:	48 83 c4 08          	add    $0x8,%rsp
 866:	5b                   	pop    %rbx
 867:	5d                   	pop    %rbp
 868:	c3                   	ret
        prevp->s.ptr = p->s.ptr;
 869:	48 8b 10             	mov    (%rax),%rdx
 86c:	48 89 11             	mov    %rdx,(%rcx)
 86f:	eb e6                	jmp    857 <malloc+0x61>
 871:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 878:	00 00 00 00 
 87c:	0f 1f 40 00          	nopl   0x0(%rax)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 880:	48 89 c1             	mov    %rax,%rcx
 883:	48 8b 00             	mov    (%rax),%rax
    if(p->s.size >= nunits){
 886:	8b 50 08             	mov    0x8(%rax),%edx
 889:	39 da                	cmp    %ebx,%edx
 88b:	73 b7                	jae    844 <malloc+0x4e>
    if(p == freep)
 88d:	48 39 05 5c 03 00 00 	cmp    %rax,0x35c(%rip)        # bf0 <freep>
 894:	75 ea                	jne    880 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
 896:	89 df                	mov    %ebx,%edi
 898:	e8 10 ff ff ff       	call   7ad <morecore>
 89d:	48 85 c0             	test   %rax,%rax
 8a0:	75 de                	jne    880 <malloc+0x8a>
 8a2:	eb be                	jmp    862 <malloc+0x6c>
