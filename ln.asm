
_ln:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	53                   	push   %rbx
   5:	48 83 ec 08          	sub    $0x8,%rsp
  if(argc != 3){
   9:	83 ff 03             	cmp    $0x3,%edi
   c:	74 16                	je     24 <main+0x24>
    printf(2, "Usage: ln old new\n");
   e:	be 30 08 00 00       	mov    $0x830,%esi
  13:	bf 02 00 00 00       	mov    $0x2,%edi
  18:	b0 00                	mov    $0x0,%al
  1a:	e8 46 04 00 00       	call   465 <printf>
    exit();
  1f:	e8 3e 02 00 00       	call   262 <exit>
  24:	48 89 f3             	mov    %rsi,%rbx
  }
  if(link(argv[1], argv[2]) < 0)
  27:	48 8b 76 10          	mov    0x10(%rsi),%rsi
  2b:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  2f:	e8 a6 02 00 00       	call   2da <link>
  34:	85 c0                	test   %eax,%eax
  36:	78 05                	js     3d <main+0x3d>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  38:	e8 25 02 00 00       	call   262 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3d:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  41:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  45:	be 43 08 00 00       	mov    $0x843,%esi
  4a:	bf 02 00 00 00       	mov    $0x2,%edi
  4f:	b0 00                	mov    $0x0,%al
  51:	e8 0f 04 00 00       	call   465 <printf>
  56:	eb e0                	jmp    38 <main+0x38>
  58:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5f:	00 

0000000000000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  60:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  63:	48 89 f9             	mov    %rdi,%rcx
  66:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6d:	00 00 00 00 
  71:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  78:	00 00 00 00 
  7c:	0f 1f 40 00          	nopl   0x0(%rax)
  80:	48 89 f2             	mov    %rsi,%rdx
  83:	48 83 c6 01          	add    $0x1,%rsi
  87:	49 89 c8             	mov    %rcx,%r8
  8a:	48 83 c1 01          	add    $0x1,%rcx
  8e:	8a 12                	mov    (%rdx),%dl
  90:	41 88 10             	mov    %dl,(%r8)
  93:	0f be d2             	movsbl %dl,%edx
  96:	85 d2                	test   %edx,%edx
  98:	75 e6                	jne    80 <strcpy+0x20>
    ;
  return os;
}
  9a:	c3                   	ret

000000000000009b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  9b:	eb 0b                	jmp    a8 <strcmp+0xd>
  9d:	0f 1f 00             	nopl   (%rax)
    p++, q++;
  a0:	48 83 c7 01          	add    $0x1,%rdi
  a4:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
  a8:	8a 07                	mov    (%rdi),%al
  aa:	0f be d0             	movsbl %al,%edx
  ad:	85 d2                	test   %edx,%edx
  af:	74 07                	je     b8 <strcmp+0x1d>
  b1:	0f be 0e             	movsbl (%rsi),%ecx
  b4:	39 ca                	cmp    %ecx,%edx
  b6:	74 e8                	je     a0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	0f b6 16             	movzbl (%rsi),%edx
  be:	29 d0                	sub    %edx,%eax
}
  c0:	c3                   	ret

00000000000000c1 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
  c1:	b8 00 00 00 00       	mov    $0x0,%eax
  c6:	eb 0b                	jmp    d3 <strlen+0x12>
  c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  cf:	00 
  d0:	83 c0 01             	add    $0x1,%eax
  d3:	48 63 d0             	movslq %eax,%rdx
  d6:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
  da:	85 d2                	test   %edx,%edx
  dc:	75 f2                	jne    d0 <strlen+0xf>
    ;
  return n;
}
  de:	c3                   	ret

00000000000000df <memset>:

void*
memset(void *dst, int c, uint n)
{
  df:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
  e2:	89 d1                	mov    %edx,%ecx
  e4:	89 f0                	mov    %esi,%eax
  e6:	fc                   	cld
  e7:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
  e9:	4c 89 c0             	mov    %r8,%rax
  ec:	c3                   	ret

00000000000000ed <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
  ed:	eb 15                	jmp    104 <strchr+0x17>
  ef:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  f6:	00 00 00 00 
  fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 100:	48 83 c7 01          	add    $0x1,%rdi
 104:	8a 17                	mov    (%rdi),%dl
 106:	0f be c2             	movsbl %dl,%eax
 109:	85 c0                	test   %eax,%eax
 10b:	74 0f                	je     11c <strchr+0x2f>
    if(*s == c)
 10d:	0f be d2             	movsbl %dl,%edx
 110:	40 0f be c6          	movsbl %sil,%eax
 114:	39 c2                	cmp    %eax,%edx
 116:	75 e8                	jne    100 <strchr+0x13>
      return (char*)s;
 118:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
 11b:	c3                   	ret
  return 0;
 11c:	b8 00 00 00 00       	mov    $0x0,%eax
 121:	c3                   	ret

0000000000000122 <gets>:

char*
gets(char *buf, int max)
{
 122:	55                   	push   %rbp
 123:	48 89 e5             	mov    %rsp,%rbp
 126:	41 56                	push   %r14
 128:	41 55                	push   %r13
 12a:	41 54                	push   %r12
 12c:	53                   	push   %rbx
 12d:	48 83 ec 10          	sub    $0x10,%rsp
 131:	49 89 fc             	mov    %rdi,%r12
 134:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 137:	bb 00 00 00 00       	mov    $0x0,%ebx
 13c:	41 89 de             	mov    %ebx,%r14d
 13f:	83 c3 01             	add    $0x1,%ebx
 142:	44 39 eb             	cmp    %r13d,%ebx
 145:	7d 39                	jge    180 <gets+0x5e>
    cc = read(0, &c, 1);
 147:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 14b:	ba 01 00 00 00       	mov    $0x1,%edx
 150:	bf 00 00 00 00       	mov    $0x0,%edi
 155:	e8 26 01 00 00       	call   280 <read>
    if(cc < 1)
 15a:	85 c0                	test   %eax,%eax
 15c:	7e 22                	jle    180 <gets+0x5e>
      break;
    buf[i++] = c;
 15e:	4d 63 f6             	movslq %r14d,%r14
 161:	8a 45 df             	mov    -0x21(%rbp),%al
 164:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
 168:	0f be c0             	movsbl %al,%eax
 16b:	83 f8 0a             	cmp    $0xa,%eax
 16e:	0f 94 c2             	sete   %dl
 171:	83 f8 0d             	cmp    $0xd,%eax
 174:	0f 94 c0             	sete   %al
 177:	09 d0                	or     %edx,%eax
 179:	a8 ff                	test   $0xff,%al
 17b:	74 bf                	je     13c <gets+0x1a>
    buf[i++] = c;
 17d:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
 180:	4d 63 f6             	movslq %r14d,%r14
 183:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
 188:	4c 89 e0             	mov    %r12,%rax
 18b:	48 83 c4 10          	add    $0x10,%rsp
 18f:	5b                   	pop    %rbx
 190:	41 5c                	pop    %r12
 192:	41 5d                	pop    %r13
 194:	41 5e                	pop    %r14
 196:	5d                   	pop    %rbp
 197:	c3                   	ret

0000000000000198 <stat>:

int
stat(const char *n, struct stat *st)
{
 198:	55                   	push   %rbp
 199:	48 89 e5             	mov    %rsp,%rbp
 19c:	41 54                	push   %r12
 19e:	53                   	push   %rbx
 19f:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a2:	be 00 00 00 00       	mov    $0x0,%esi
 1a7:	e8 06 01 00 00       	call   2b2 <open>
  if(fd < 0)
 1ac:	85 c0                	test   %eax,%eax
 1ae:	78 1e                	js     1ce <stat+0x36>
 1b0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1b2:	4c 89 e6             	mov    %r12,%rsi
 1b5:	89 c7                	mov    %eax,%edi
 1b7:	e8 14 01 00 00       	call   2d0 <fstat>
 1bc:	41 89 c4             	mov    %eax,%r12d
  close(fd);
 1bf:	89 df                	mov    %ebx,%edi
 1c1:	e8 ce 00 00 00       	call   294 <close>
  return r;
}
 1c6:	44 89 e0             	mov    %r12d,%eax
 1c9:	5b                   	pop    %rbx
 1ca:	41 5c                	pop    %r12
 1cc:	5d                   	pop    %rbp
 1cd:	c3                   	ret
    return -1;
 1ce:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 1d4:	eb f0                	jmp    1c6 <stat+0x2e>

00000000000001d6 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
 1d6:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
 1db:	eb 09                	jmp    1e6 <atoi+0x10>
 1dd:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
 1e0:	f7 de                	neg    %esi
    s++;
 1e2:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
 1e6:	0f be 07             	movsbl (%rdi),%eax
 1e9:	83 f8 2d             	cmp    $0x2d,%eax
 1ec:	74 f2                	je     1e0 <atoi+0xa>
  n = 0;
 1ee:	b8 00 00 00 00       	mov    $0x0,%eax
 1f3:	eb 19                	jmp    20e <atoi+0x38>
 1f5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1fc:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 200:	8d 04 80             	lea    (%rax,%rax,4),%eax
 203:	48 83 c7 01          	add    $0x1,%rdi
 207:	0f be d2             	movsbl %dl,%edx
 20a:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
 20e:	8a 17                	mov    (%rdi),%dl
 210:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 213:	0f b6 c9             	movzbl %cl,%ecx
 216:	83 f9 09             	cmp    $0x9,%ecx
 219:	76 e5                	jbe    200 <atoi+0x2a>
  return sign * n;
 21b:	0f af c6             	imul   %esi,%eax
}
 21e:	c3                   	ret

000000000000021f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21f:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
 222:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
 225:	eb 28                	jmp    24f <memmove+0x30>
 227:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 22e:	00 00 00 00 
 232:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 239:	00 00 00 00 
 23d:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
 240:	8a 16                	mov    (%rsi),%dl
 242:	88 11                	mov    %dl,(%rcx)
 244:	48 8d 76 01          	lea    0x1(%rsi),%rsi
 248:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
 24c:	44 89 c2             	mov    %r8d,%edx
 24f:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
 253:	85 d2                	test   %edx,%edx
 255:	7f e9                	jg     240 <memmove+0x21>
  return vdst;
}
 257:	c3                   	ret

0000000000000258 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 258:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret

0000000000000262 <exit>:
SYSCALL(exit)
 262:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret

000000000000026c <wait>:
SYSCALL(wait)
 26c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret

0000000000000276 <pipe>:
SYSCALL(pipe)
 276:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret

0000000000000280 <read>:
SYSCALL(read)
 280:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret

000000000000028a <write>:
SYSCALL(write)
 28a:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret

0000000000000294 <close>:
SYSCALL(close)
 294:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret

000000000000029e <kill>:
SYSCALL(kill)
 29e:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret

00000000000002a8 <exec>:
SYSCALL(exec)
 2a8:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret

00000000000002b2 <open>:
SYSCALL(open)
 2b2:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret

00000000000002bc <mknod>:
SYSCALL(mknod)
 2bc:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret

00000000000002c6 <unlink>:
SYSCALL(unlink)
 2c6:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret

00000000000002d0 <fstat>:
SYSCALL(fstat)
 2d0:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret

00000000000002da <link>:
SYSCALL(link)
 2da:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret

00000000000002e4 <mkdir>:
SYSCALL(mkdir)
 2e4:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret

00000000000002ee <chdir>:
SYSCALL(chdir)
 2ee:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret

00000000000002f8 <dup>:
SYSCALL(dup)
 2f8:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret

0000000000000302 <getpid>:
SYSCALL(getpid)
 302:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret

000000000000030c <sbrk>:
SYSCALL(sbrk)
 30c:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret

0000000000000316 <sleep>:
SYSCALL(sleep)
 316:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret

0000000000000320 <uptime>:
SYSCALL(uptime)
 320:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret

000000000000032a <vmcreate>:
SYSCALL(vmcreate)
 32a:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret

0000000000000334 <vmsetreg>:
SYSCALL(vmsetreg)
 334:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret

000000000000033e <vmrun>:
SYSCALL(vmrun)
 33e:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret

0000000000000348 <vmgetreg>:
SYSCALL(vmgetreg)
 348:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret
 352:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 359:	00 00 00 
 35c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 363:	00 00 00 
 366:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 36d:	00 00 00 
 370:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 377:	00 00 00 
 37a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000000380 <_va_arg>:
// Retrieve the next argument from the va_list.
static inline void *_va_arg(va_list *args)
{
    // Returns the next argument from registers if _index < 6, 
    // otherwise from the stack.
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 380:	8b 47 38             	mov    0x38(%rdi),%eax
 383:	83 f8 05             	cmp    $0x5,%eax
 386:	77 0d                	ja     395 <_va_arg+0x15>
 388:	8d 50 01             	lea    0x1(%rax),%edx
 38b:	89 57 38             	mov    %edx,0x38(%rdi)
 38e:	89 c0                	mov    %eax,%eax
 390:	48 8b 04 c7          	mov    (%rdi,%rax,8),%rax
 394:	c3                   	ret
                                  : args->more_argint[(args->_index++)-6]);
 395:	8d 50 01             	lea    0x1(%rax),%edx
 398:	89 57 38             	mov    %edx,0x38(%rdi)
 39b:	8d 40 fa             	lea    -0x6(%rax),%eax
 39e:	48 c1 e0 03          	shl    $0x3,%rax
 3a2:	48 03 47 30          	add    0x30(%rdi),%rax
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 3a6:	48 8b 00             	mov    (%rax),%rax
}
 3a9:	c3                   	ret

00000000000003aa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3aa:	55                   	push   %rbp
 3ab:	48 89 e5             	mov    %rsp,%rbp
 3ae:	48 83 ec 10          	sub    $0x10,%rsp
 3b2:	40 88 75 fc          	mov    %sil,-0x4(%rbp)
  write(fd, &c, 1);
 3b6:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 3ba:	ba 01 00 00 00       	mov    $0x1,%edx
 3bf:	e8 c6 fe ff ff       	call   28a <write>
}
 3c4:	48 89 ec             	mov    %rbp,%rsp
 3c7:	5d                   	pop    %rbp
 3c8:	c3                   	ret

00000000000003c9 <printint>:

static void
printint(int fd, int64 xx, int base, int sgn)
{
 3c9:	55                   	push   %rbp
 3ca:	48 89 e5             	mov    %rsp,%rbp
 3cd:	41 54                	push   %r12
 3cf:	53                   	push   %rbx
 3d0:	48 83 ec 10          	sub    $0x10,%rsp
 3d4:	41 89 fc             	mov    %edi,%r12d
 3d7:	41 89 d1             	mov    %edx,%r9d
  char buf[16];
  int i, neg;
  uint64 x;

  neg = 0;
  if(sgn && xx < 0){
 3da:	85 c9                	test   %ecx,%ecx
 3dc:	0f 95 c2             	setne  %dl
 3df:	48 89 f0             	mov    %rsi,%rax
 3e2:	48 c1 e8 3f          	shr    $0x3f,%rax
 3e6:	85 c2                	test   %eax,%edx
 3e8:	74 55                	je     43f <printint+0x76>
    neg = 1;
    x = -xx;
 3ea:	48 f7 de             	neg    %rsi
    neg = 1;
 3ed:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  } else {
    x = xx;
  }

  i = 0;
 3f3:	bb 00 00 00 00       	mov    $0x0,%ebx
 3f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 3ff:	00 
  do{
    buf[i++] = digits[x % base];
 400:	49 63 c9             	movslq %r9d,%rcx
 403:	48 89 f0             	mov    %rsi,%rax
 406:	ba 00 00 00 00       	mov    $0x0,%edx
 40b:	48 f7 f1             	div    %rcx
 40e:	89 df                	mov    %ebx,%edi
 410:	83 c3 01             	add    $0x1,%ebx
 413:	44 8a 82 10 09 00 00 	mov    0x910(%rdx),%r8b
 41a:	48 63 d7             	movslq %edi,%rdx
 41d:	44 88 44 15 e0       	mov    %r8b,-0x20(%rbp,%rdx,1)
  }while((x /= base) != 0);
 422:	48 89 f2             	mov    %rsi,%rdx
 425:	48 89 c6             	mov    %rax,%rsi
 428:	48 39 ca             	cmp    %rcx,%rdx
 42b:	73 d3                	jae    400 <printint+0x37>
  if(neg)
 42d:	45 85 d2             	test   %r10d,%r10d
 430:	74 25                	je     457 <printint+0x8e>
    buf[i++] = '-';
 432:	48 63 db             	movslq %ebx,%rbx
 435:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 43a:	8d 5f 02             	lea    0x2(%rdi),%ebx
 43d:	eb 18                	jmp    457 <printint+0x8e>
  neg = 0;
 43f:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 445:	eb ac                	jmp    3f3 <printint+0x2a>

  while(--i >= 0)
    putc(fd, buf[i]);
 447:	48 63 c3             	movslq %ebx,%rax
 44a:	0f be 74 05 e0       	movsbl -0x20(%rbp,%rax,1),%esi
 44f:	44 89 e7             	mov    %r12d,%edi
 452:	e8 53 ff ff ff       	call   3aa <putc>
  while(--i >= 0)
 457:	83 eb 01             	sub    $0x1,%ebx
 45a:	79 eb                	jns    447 <printint+0x7e>
}
 45c:	48 83 c4 10          	add    $0x10,%rsp
 460:	5b                   	pop    %rbx
 461:	41 5c                	pop    %r12
 463:	5d                   	pop    %rbp
 464:	c3                   	ret

0000000000000465 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 465:	55                   	push   %rbp
 466:	48 89 e5             	mov    %rsp,%rbp
 469:	41 57                	push   %r15
 46b:	41 56                	push   %r14
 46d:	41 55                	push   %r13
 46f:	41 54                	push   %r12
 471:	53                   	push   %rbx
 472:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
 479:	41 89 ff             	mov    %edi,%r15d
 47c:	49 89 f5             	mov    %rsi,%r13
 47f:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
 486:	48 89 8d 38 ff ff ff 	mov    %rcx,-0xc8(%rbp)
 48d:	4c 89 85 40 ff ff ff 	mov    %r8,-0xc0(%rbp)
 494:	4c 89 8d 48 ff ff ff 	mov    %r9,-0xb8(%rbp)
 49b:	84 c0                	test   %al,%al
 49d:	74 29                	je     4c8 <printf+0x63>
 49f:	0f 29 85 50 ff ff ff 	movaps %xmm0,-0xb0(%rbp)
 4a6:	0f 29 8d 60 ff ff ff 	movaps %xmm1,-0xa0(%rbp)
 4ad:	0f 29 95 70 ff ff ff 	movaps %xmm2,-0x90(%rbp)
 4b4:	0f 29 5d 80          	movaps %xmm3,-0x80(%rbp)
 4b8:	0f 29 65 90          	movaps %xmm4,-0x70(%rbp)
 4bc:	0f 29 6d a0          	movaps %xmm5,-0x60(%rbp)
 4c0:	0f 29 75 b0          	movaps %xmm6,-0x50(%rbp)
 4c4:	0f 29 7d c0          	movaps %xmm7,-0x40(%rbp)
    asm volatile("movq %%rdi, %0;" 
 4c8:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
 4cf:	48 89 b5 e8 fe ff ff 	mov    %rsi,-0x118(%rbp)
 4d6:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
 4dd:	48 89 8d f8 fe ff ff 	mov    %rcx,-0x108(%rbp)
 4e4:	4c 89 85 00 ff ff ff 	mov    %r8,-0x100(%rbp)
 4eb:	4c 89 8d 08 ff ff ff 	mov    %r9,-0xf8(%rbp)
    asm volatile("leaq 16(%%rbp), %0" : "=r" (args->more_argint));
 4f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
 4f6:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
    args->_index = 1;
 4fd:	c7 85 18 ff ff ff 01 	movl   $0x1,-0xe8(%rbp)
 504:	00 00 00 
  char *s;
  int c, i, state;
  va_list ap;

  va_start(ap, fd);
  (void) va_arg(ap, char*); // skip fmt
 507:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 50e:	e8 6d fe ff ff       	call   380 <_va_arg>

  state = 0;
 513:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(i = 0; fmt[i]; i++){
 519:	bb 00 00 00 00       	mov    $0x0,%ebx
 51e:	eb 16                	jmp    536 <printf+0xd1>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 520:	44 89 f6             	mov    %r14d,%esi
 523:	44 89 ff             	mov    %r15d,%edi
 526:	e8 7f fe ff ff       	call   3aa <putc>
 52b:	eb 06                	jmp    533 <printf+0xce>
      }
    } else if(state == '%'){
 52d:	41 83 fc 25          	cmp    $0x25,%r12d
 531:	74 2c                	je     55f <printf+0xfa>
  for(i = 0; fmt[i]; i++){
 533:	83 c3 01             	add    $0x1,%ebx
 536:	48 63 c3             	movslq %ebx,%rax
 539:	41 8a 44 05 00       	mov    0x0(%r13,%rax,1),%al
 53e:	0f be d0             	movsbl %al,%edx
 541:	85 d2                	test   %edx,%edx
 543:	0f 84 42 01 00 00    	je     68b <printf+0x226>
    c = fmt[i] & 0xff;
 549:	44 0f be f0          	movsbl %al,%r14d
 54d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 550:	45 85 e4             	test   %r12d,%r12d
 553:	75 d8                	jne    52d <printf+0xc8>
      if(c == '%'){
 555:	83 f8 25             	cmp    $0x25,%eax
 558:	75 c6                	jne    520 <printf+0xbb>
        state = '%';
 55a:	41 89 c4             	mov    %eax,%r12d
 55d:	eb d4                	jmp    533 <printf+0xce>
      if(c == 'd'){
 55f:	83 f8 25             	cmp    $0x25,%eax
 562:	0f 84 ea 00 00 00    	je     652 <printf+0x1ed>
 568:	0f 8c fa 00 00 00    	jl     668 <printf+0x203>
 56e:	83 f8 78             	cmp    $0x78,%eax
 571:	0f 8f f1 00 00 00    	jg     668 <printf+0x203>
 577:	83 f8 63             	cmp    $0x63,%eax
 57a:	0f 8c e8 00 00 00    	jl     668 <printf+0x203>
 580:	83 e8 63             	sub    $0x63,%eax
 583:	83 f8 15             	cmp    $0x15,%eax
 586:	0f 87 dc 00 00 00    	ja     668 <printf+0x203>
 58c:	89 c0                	mov    %eax,%eax
 58e:	ff 24 c5 60 08 00 00 	jmp    *0x860(,%rax,8)
        printint(fd, va_arg(ap, int), 10, 1);
 595:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 59c:	e8 df fd ff ff       	call   380 <_va_arg>
 5a1:	48 63 f0             	movslq %eax,%rsi
 5a4:	b9 01 00 00 00       	mov    $0x1,%ecx
 5a9:	ba 0a 00 00 00       	mov    $0xa,%edx
 5ae:	44 89 ff             	mov    %r15d,%edi
 5b1:	e8 13 fe ff ff       	call   3c9 <printint>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 5bc:	e9 72 ff ff ff       	jmp    533 <printf+0xce>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c1:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 5c8:	e8 b3 fd ff ff       	call   380 <_va_arg>
 5cd:	48 89 c6             	mov    %rax,%rsi
 5d0:	b9 00 00 00 00       	mov    $0x0,%ecx
 5d5:	ba 10 00 00 00       	mov    $0x10,%edx
 5da:	44 89 ff             	mov    %r15d,%edi
 5dd:	e8 e7 fd ff ff       	call   3c9 <printint>
      state = 0;
 5e2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 5e8:	e9 46 ff ff ff       	jmp    533 <printf+0xce>
        s = va_arg(ap, char*);
 5ed:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 5f4:	e8 87 fd ff ff       	call   380 <_va_arg>
 5f9:	49 89 c4             	mov    %rax,%r12
        if(s == 0)
 5fc:	48 85 c0             	test   %rax,%rax
 5ff:	75 18                	jne    619 <printf+0x1b4>
          s = "(null)";
 601:	41 bc 57 08 00 00    	mov    $0x857,%r12d
 607:	eb 10                	jmp    619 <printf+0x1b4>
          putc(fd, *s);
 609:	40 0f be f6          	movsbl %sil,%esi
 60d:	44 89 ff             	mov    %r15d,%edi
 610:	e8 95 fd ff ff       	call   3aa <putc>
          s++;
 615:	49 83 c4 01          	add    $0x1,%r12
        while(*s != 0){
 619:	41 8a 34 24          	mov    (%r12),%sil
 61d:	40 0f be c6          	movsbl %sil,%eax
 621:	85 c0                	test   %eax,%eax
 623:	75 e4                	jne    609 <printf+0x1a4>
      state = 0;
 625:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 62b:	e9 03 ff ff ff       	jmp    533 <printf+0xce>
        putc(fd, va_arg(ap, char));
 630:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 637:	e8 44 fd ff ff       	call   380 <_va_arg>
 63c:	0f be f0             	movsbl %al,%esi
 63f:	44 89 ff             	mov    %r15d,%edi
 642:	e8 63 fd ff ff       	call   3aa <putc>
      state = 0;
 647:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 64d:	e9 e1 fe ff ff       	jmp    533 <printf+0xce>
        putc(fd, c);
 652:	44 89 f6             	mov    %r14d,%esi
 655:	44 89 ff             	mov    %r15d,%edi
 658:	e8 4d fd ff ff       	call   3aa <putc>
      state = 0;
 65d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 663:	e9 cb fe ff ff       	jmp    533 <printf+0xce>
        putc(fd, '%');
 668:	be 25 00 00 00       	mov    $0x25,%esi
 66d:	44 89 ff             	mov    %r15d,%edi
 670:	e8 35 fd ff ff       	call   3aa <putc>
        putc(fd, c);
 675:	44 89 f6             	mov    %r14d,%esi
 678:	44 89 ff             	mov    %r15d,%edi
 67b:	e8 2a fd ff ff       	call   3aa <putc>
      state = 0;
 680:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 686:	e9 a8 fe ff ff       	jmp    533 <printf+0xce>
    }
  }
}
 68b:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
 692:	5b                   	pop    %rbx
 693:	41 5c                	pop    %r12
 695:	41 5d                	pop    %r13
 697:	41 5e                	pop    %r14
 699:	41 5f                	pop    %r15
 69b:	5d                   	pop    %rbp
 69c:	c3                   	ret
 69d:	0f 1f 00             	nopl   (%rax)

00000000000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	48 89 fe             	mov    %rdi,%rsi
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a3:	48 8d 4f f0          	lea    -0x10(%rdi),%rcx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a7:	48 8b 05 82 04 00 00 	mov    0x482(%rip),%rax        # b30 <freep>
 6ae:	eb 03                	jmp    6b3 <free+0x13>
 6b0:	48 89 d0             	mov    %rdx,%rax
 6b3:	48 39 c8             	cmp    %rcx,%rax
 6b6:	73 05                	jae    6bd <free+0x1d>
 6b8:	48 3b 08             	cmp    (%rax),%rcx
 6bb:	72 17                	jb     6d4 <free+0x34>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6bd:	48 8b 10             	mov    (%rax),%rdx
 6c0:	48 39 d0             	cmp    %rdx,%rax
 6c3:	72 eb                	jb     6b0 <free+0x10>
 6c5:	48 39 c8             	cmp    %rcx,%rax
 6c8:	72 0a                	jb     6d4 <free+0x34>
 6ca:	48 39 d1             	cmp    %rdx,%rcx
 6cd:	72 05                	jb     6d4 <free+0x34>
 6cf:	48 89 d0             	mov    %rdx,%rax
 6d2:	eb df                	jmp    6b3 <free+0x13>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d4:	44 8b 46 f8          	mov    -0x8(%rsi),%r8d
 6d8:	44 89 c2             	mov    %r8d,%edx
 6db:	48 c1 e2 04          	shl    $0x4,%rdx
 6df:	48 01 ca             	add    %rcx,%rdx
 6e2:	48 8b 38             	mov    (%rax),%rdi
 6e5:	48 39 fa             	cmp    %rdi,%rdx
 6e8:	74 20                	je     70a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6ea:	48 89 7e f0          	mov    %rdi,-0x10(%rsi)
  if(p + p->s.size == bp){
 6ee:	8b 78 08             	mov    0x8(%rax),%edi
 6f1:	89 fa                	mov    %edi,%edx
 6f3:	48 c1 e2 04          	shl    $0x4,%rdx
 6f7:	48 01 c2             	add    %rax,%rdx
 6fa:	48 39 ca             	cmp    %rcx,%rdx
 6fd:	74 1f                	je     71e <free+0x7e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6ff:	48 89 08             	mov    %rcx,(%rax)
  freep = p;
 702:	48 89 05 27 04 00 00 	mov    %rax,0x427(%rip)        # b30 <freep>
}
 709:	c3                   	ret
    bp->s.size += p->s.ptr->s.size;
 70a:	44 03 47 08          	add    0x8(%rdi),%r8d
 70e:	44 89 46 f8          	mov    %r8d,-0x8(%rsi)
    bp->s.ptr = p->s.ptr->s.ptr;
 712:	48 8b 10             	mov    (%rax),%rdx
 715:	48 8b 12             	mov    (%rdx),%rdx
 718:	48 89 56 f0          	mov    %rdx,-0x10(%rsi)
 71c:	eb d0                	jmp    6ee <free+0x4e>
    p->s.size += bp->s.size;
 71e:	03 7e f8             	add    -0x8(%rsi),%edi
 721:	89 78 08             	mov    %edi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 724:	48 8b 56 f0          	mov    -0x10(%rsi),%rdx
 728:	48 89 10             	mov    %rdx,(%rax)
 72b:	eb d5                	jmp    702 <free+0x62>

000000000000072d <morecore>:

static Header*
morecore(uint nu)
{
 72d:	55                   	push   %rbp
 72e:	48 89 e5             	mov    %rsp,%rbp
 731:	53                   	push   %rbx
 732:	48 83 ec 08          	sub    $0x8,%rsp
 736:	89 fb                	mov    %edi,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 738:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 73e:	77 05                	ja     745 <morecore+0x18>
    nu = 4096;
 740:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 745:	89 df                	mov    %ebx,%edi
 747:	c1 e7 04             	shl    $0x4,%edi
 74a:	e8 bd fb ff ff       	call   30c <sbrk>
  if(p == (char*)-1)
 74f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 753:	74 1a                	je     76f <morecore+0x42>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 755:	89 58 08             	mov    %ebx,0x8(%rax)
  free((void*)(hp + 1));
 758:	48 8d 78 10          	lea    0x10(%rax),%rdi
 75c:	e8 3f ff ff ff       	call   6a0 <free>
  return freep;
 761:	48 8b 05 c8 03 00 00 	mov    0x3c8(%rip),%rax        # b30 <freep>
}
 768:	48 83 c4 08          	add    $0x8,%rsp
 76c:	5b                   	pop    %rbx
 76d:	5d                   	pop    %rbp
 76e:	c3                   	ret
    return 0;
 76f:	b8 00 00 00 00       	mov    $0x0,%eax
 774:	eb f2                	jmp    768 <morecore+0x3b>

0000000000000776 <malloc>:

void*
malloc(uint nbytes)
{
 776:	55                   	push   %rbp
 777:	48 89 e5             	mov    %rsp,%rbp
 77a:	53                   	push   %rbx
 77b:	48 83 ec 08          	sub    $0x8,%rsp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77f:	89 fb                	mov    %edi,%ebx
 781:	48 83 c3 0f          	add    $0xf,%rbx
 785:	48 c1 eb 04          	shr    $0x4,%rbx
 789:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 78c:	48 8b 0d 9d 03 00 00 	mov    0x39d(%rip),%rcx        # b30 <freep>
 793:	48 85 c9             	test   %rcx,%rcx
 796:	74 05                	je     79d <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 798:	48 8b 01             	mov    (%rcx),%rax
 79b:	eb 69                	jmp    806 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
 79d:	48 c7 05 88 03 00 00 	movq   $0xb40,0x388(%rip)        # b30 <freep>
 7a4:	40 0b 00 00 
 7a8:	48 c7 05 8d 03 00 00 	movq   $0xb40,0x38d(%rip)        # b40 <base>
 7af:	40 0b 00 00 
    base.s.size = 0;
 7b3:	c7 05 8b 03 00 00 00 	movl   $0x0,0x38b(%rip)        # b48 <base+0x8>
 7ba:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 7bd:	b9 40 0b 00 00       	mov    $0xb40,%ecx
 7c2:	eb d4                	jmp    798 <malloc+0x22>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 7c4:	74 23                	je     7e9 <malloc+0x73>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7c6:	29 da                	sub    %ebx,%edx
 7c8:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 7cb:	89 d2                	mov    %edx,%edx
 7cd:	48 c1 e2 04          	shl    $0x4,%rdx
 7d1:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 7d4:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 7d7:	48 89 0d 52 03 00 00 	mov    %rcx,0x352(%rip)        # b30 <freep>
      return (void*)(p + 1);
 7de:	48 83 c0 10          	add    $0x10,%rax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7e2:	48 83 c4 08          	add    $0x8,%rsp
 7e6:	5b                   	pop    %rbx
 7e7:	5d                   	pop    %rbp
 7e8:	c3                   	ret
        prevp->s.ptr = p->s.ptr;
 7e9:	48 8b 10             	mov    (%rax),%rdx
 7ec:	48 89 11             	mov    %rdx,(%rcx)
 7ef:	eb e6                	jmp    7d7 <malloc+0x61>
 7f1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 7f8:	00 00 00 00 
 7fc:	0f 1f 40 00          	nopl   0x0(%rax)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 800:	48 89 c1             	mov    %rax,%rcx
 803:	48 8b 00             	mov    (%rax),%rax
    if(p->s.size >= nunits){
 806:	8b 50 08             	mov    0x8(%rax),%edx
 809:	39 da                	cmp    %ebx,%edx
 80b:	73 b7                	jae    7c4 <malloc+0x4e>
    if(p == freep)
 80d:	48 39 05 1c 03 00 00 	cmp    %rax,0x31c(%rip)        # b30 <freep>
 814:	75 ea                	jne    800 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
 816:	89 df                	mov    %ebx,%edi
 818:	e8 10 ff ff ff       	call   72d <morecore>
 81d:	48 85 c0             	test   %rax,%rax
 820:	75 de                	jne    800 <malloc+0x8a>
 822:	eb be                	jmp    7e2 <malloc+0x6c>
