
_cat:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	41 54                	push   %r12
   6:	53                   	push   %rbx
   7:	41 89 fc             	mov    %edi,%r12d
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   a:	ba 00 02 00 00       	mov    $0x200,%edx
   f:	be 00 0c 00 00       	mov    $0xc00,%esi
  14:	44 89 e7             	mov    %r12d,%edi
  17:	e8 04 03 00 00       	call   320 <read>
  1c:	89 c3                	mov    %eax,%ebx
  1e:	85 c0                	test   %eax,%eax
  20:	7e 2b                	jle    4d <cat+0x4d>
    if (write(1, buf, n) != n) {
  22:	89 da                	mov    %ebx,%edx
  24:	be 00 0c 00 00       	mov    $0xc00,%esi
  29:	bf 01 00 00 00       	mov    $0x1,%edi
  2e:	e8 f7 02 00 00       	call   32a <write>
  33:	39 d8                	cmp    %ebx,%eax
  35:	74 d3                	je     a <cat+0xa>
      printf(1, "cat: write error\n");
  37:	be b0 08 00 00       	mov    $0x8b0,%esi
  3c:	bf 01 00 00 00       	mov    $0x1,%edi
  41:	b0 00                	mov    $0x0,%al
  43:	e8 9d 04 00 00       	call   4e5 <printf>
      exit();
  48:	e8 b5 02 00 00       	call   302 <exit>
    }
  }
  if(n < 0){
  4d:	78 05                	js     54 <cat+0x54>
    printf(1, "cat: read error\n");
    exit();
  }
}
  4f:	5b                   	pop    %rbx
  50:	41 5c                	pop    %r12
  52:	5d                   	pop    %rbp
  53:	c3                   	ret
    printf(1, "cat: read error\n");
  54:	be c2 08 00 00       	mov    $0x8c2,%esi
  59:	bf 01 00 00 00       	mov    $0x1,%edi
  5e:	b0 00                	mov    $0x0,%al
  60:	e8 80 04 00 00       	call   4e5 <printf>
    exit();
  65:	e8 98 02 00 00       	call   302 <exit>

000000000000006a <main>:

int
main(int argc, char *argv[])
{
  6a:	55                   	push   %rbp
  6b:	48 89 e5             	mov    %rsp,%rbp
  6e:	41 57                	push   %r15
  70:	41 56                	push   %r14
  72:	41 55                	push   %r13
  74:	41 54                	push   %r12
  76:	53                   	push   %rbx
  77:	48 83 ec 08          	sub    $0x8,%rsp
  int fd, i;

  if(argc <= 1){
  7b:	83 ff 01             	cmp    $0x1,%edi
  7e:	7e 0e                	jle    8e <main+0x24>
  80:	41 89 fe             	mov    %edi,%r14d
  83:	49 89 f7             	mov    %rsi,%r15
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  86:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  8c:	eb 21                	jmp    af <main+0x45>
    cat(0);
  8e:	bf 00 00 00 00       	mov    $0x0,%edi
  93:	e8 68 ff ff ff       	call   0 <cat>
    exit();
  98:	e8 65 02 00 00       	call   302 <exit>
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  9d:	89 c7                	mov    %eax,%edi
  9f:	e8 5c ff ff ff       	call   0 <cat>
    close(fd);
  a4:	89 df                	mov    %ebx,%edi
  a6:	e8 89 02 00 00       	call   334 <close>
  for(i = 1; i < argc; i++){
  ab:	41 83 c4 01          	add    $0x1,%r12d
  af:	45 39 f4             	cmp    %r14d,%r12d
  b2:	7d 35                	jge    e9 <main+0x7f>
    if((fd = open(argv[i], 0)) < 0){
  b4:	49 63 c4             	movslq %r12d,%rax
  b7:	4d 8d 2c c7          	lea    (%r15,%rax,8),%r13
  bb:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  bf:	be 00 00 00 00       	mov    $0x0,%esi
  c4:	e8 89 02 00 00       	call   352 <open>
  c9:	89 c3                	mov    %eax,%ebx
  cb:	85 c0                	test   %eax,%eax
  cd:	79 ce                	jns    9d <main+0x33>
      printf(1, "cat: cannot open %s\n", argv[i]);
  cf:	49 8b 55 00          	mov    0x0(%r13),%rdx
  d3:	be d3 08 00 00       	mov    $0x8d3,%esi
  d8:	bf 01 00 00 00       	mov    $0x1,%edi
  dd:	b0 00                	mov    $0x0,%al
  df:	e8 01 04 00 00       	call   4e5 <printf>
      exit();
  e4:	e8 19 02 00 00       	call   302 <exit>
  }
  exit();
  e9:	e8 14 02 00 00       	call   302 <exit>
  ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  f5:	00 00 00 
  f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  ff:	00 

0000000000000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 100:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 103:	48 89 f9             	mov    %rdi,%rcx
 106:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 10d:	00 00 00 00 
 111:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 118:	00 00 00 00 
 11c:	0f 1f 40 00          	nopl   0x0(%rax)
 120:	48 89 f2             	mov    %rsi,%rdx
 123:	48 83 c6 01          	add    $0x1,%rsi
 127:	49 89 c8             	mov    %rcx,%r8
 12a:	48 83 c1 01          	add    $0x1,%rcx
 12e:	8a 12                	mov    (%rdx),%dl
 130:	41 88 10             	mov    %dl,(%r8)
 133:	0f be d2             	movsbl %dl,%edx
 136:	85 d2                	test   %edx,%edx
 138:	75 e6                	jne    120 <strcpy+0x20>
    ;
  return os;
}
 13a:	c3                   	ret

000000000000013b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 13b:	eb 0b                	jmp    148 <strcmp+0xd>
 13d:	0f 1f 00             	nopl   (%rax)
    p++, q++;
 140:	48 83 c7 01          	add    $0x1,%rdi
 144:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
 148:	8a 07                	mov    (%rdi),%al
 14a:	0f be d0             	movsbl %al,%edx
 14d:	85 d2                	test   %edx,%edx
 14f:	74 07                	je     158 <strcmp+0x1d>
 151:	0f be 0e             	movsbl (%rsi),%ecx
 154:	39 ca                	cmp    %ecx,%edx
 156:	74 e8                	je     140 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 158:	0f b6 c0             	movzbl %al,%eax
 15b:	0f b6 16             	movzbl (%rsi),%edx
 15e:	29 d0                	sub    %edx,%eax
}
 160:	c3                   	ret

0000000000000161 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 161:	b8 00 00 00 00       	mov    $0x0,%eax
 166:	eb 0b                	jmp    173 <strlen+0x12>
 168:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 16f:	00 
 170:	83 c0 01             	add    $0x1,%eax
 173:	48 63 d0             	movslq %eax,%rdx
 176:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
 17a:	85 d2                	test   %edx,%edx
 17c:	75 f2                	jne    170 <strlen+0xf>
    ;
  return n;
}
 17e:	c3                   	ret

000000000000017f <memset>:

void*
memset(void *dst, int c, uint n)
{
 17f:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
 182:	89 d1                	mov    %edx,%ecx
 184:	89 f0                	mov    %esi,%eax
 186:	fc                   	cld
 187:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 189:	4c 89 c0             	mov    %r8,%rax
 18c:	c3                   	ret

000000000000018d <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 18d:	eb 15                	jmp    1a4 <strchr+0x17>
 18f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 196:	00 00 00 00 
 19a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1a0:	48 83 c7 01          	add    $0x1,%rdi
 1a4:	8a 17                	mov    (%rdi),%dl
 1a6:	0f be c2             	movsbl %dl,%eax
 1a9:	85 c0                	test   %eax,%eax
 1ab:	74 0f                	je     1bc <strchr+0x2f>
    if(*s == c)
 1ad:	0f be d2             	movsbl %dl,%edx
 1b0:	40 0f be c6          	movsbl %sil,%eax
 1b4:	39 c2                	cmp    %eax,%edx
 1b6:	75 e8                	jne    1a0 <strchr+0x13>
      return (char*)s;
 1b8:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
 1bb:	c3                   	ret
  return 0;
 1bc:	b8 00 00 00 00       	mov    $0x0,%eax
 1c1:	c3                   	ret

00000000000001c2 <gets>:

char*
gets(char *buf, int max)
{
 1c2:	55                   	push   %rbp
 1c3:	48 89 e5             	mov    %rsp,%rbp
 1c6:	41 56                	push   %r14
 1c8:	41 55                	push   %r13
 1ca:	41 54                	push   %r12
 1cc:	53                   	push   %rbx
 1cd:	48 83 ec 10          	sub    $0x10,%rsp
 1d1:	49 89 fc             	mov    %rdi,%r12
 1d4:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d7:	bb 00 00 00 00       	mov    $0x0,%ebx
 1dc:	41 89 de             	mov    %ebx,%r14d
 1df:	83 c3 01             	add    $0x1,%ebx
 1e2:	44 39 eb             	cmp    %r13d,%ebx
 1e5:	7d 39                	jge    220 <gets+0x5e>
    cc = read(0, &c, 1);
 1e7:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 1eb:	ba 01 00 00 00       	mov    $0x1,%edx
 1f0:	bf 00 00 00 00       	mov    $0x0,%edi
 1f5:	e8 26 01 00 00       	call   320 <read>
    if(cc < 1)
 1fa:	85 c0                	test   %eax,%eax
 1fc:	7e 22                	jle    220 <gets+0x5e>
      break;
    buf[i++] = c;
 1fe:	4d 63 f6             	movslq %r14d,%r14
 201:	8a 45 df             	mov    -0x21(%rbp),%al
 204:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
 208:	0f be c0             	movsbl %al,%eax
 20b:	83 f8 0a             	cmp    $0xa,%eax
 20e:	0f 94 c2             	sete   %dl
 211:	83 f8 0d             	cmp    $0xd,%eax
 214:	0f 94 c0             	sete   %al
 217:	09 d0                	or     %edx,%eax
 219:	a8 ff                	test   $0xff,%al
 21b:	74 bf                	je     1dc <gets+0x1a>
    buf[i++] = c;
 21d:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
 220:	4d 63 f6             	movslq %r14d,%r14
 223:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
 228:	4c 89 e0             	mov    %r12,%rax
 22b:	48 83 c4 10          	add    $0x10,%rsp
 22f:	5b                   	pop    %rbx
 230:	41 5c                	pop    %r12
 232:	41 5d                	pop    %r13
 234:	41 5e                	pop    %r14
 236:	5d                   	pop    %rbp
 237:	c3                   	ret

0000000000000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	55                   	push   %rbp
 239:	48 89 e5             	mov    %rsp,%rbp
 23c:	41 54                	push   %r12
 23e:	53                   	push   %rbx
 23f:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 242:	be 00 00 00 00       	mov    $0x0,%esi
 247:	e8 06 01 00 00       	call   352 <open>
  if(fd < 0)
 24c:	85 c0                	test   %eax,%eax
 24e:	78 1e                	js     26e <stat+0x36>
 250:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 252:	4c 89 e6             	mov    %r12,%rsi
 255:	89 c7                	mov    %eax,%edi
 257:	e8 14 01 00 00       	call   370 <fstat>
 25c:	41 89 c4             	mov    %eax,%r12d
  close(fd);
 25f:	89 df                	mov    %ebx,%edi
 261:	e8 ce 00 00 00       	call   334 <close>
  return r;
}
 266:	44 89 e0             	mov    %r12d,%eax
 269:	5b                   	pop    %rbx
 26a:	41 5c                	pop    %r12
 26c:	5d                   	pop    %rbp
 26d:	c3                   	ret
    return -1;
 26e:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 274:	eb f0                	jmp    266 <stat+0x2e>

0000000000000276 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
 276:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
 27b:	eb 09                	jmp    286 <atoi+0x10>
 27d:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
 280:	f7 de                	neg    %esi
    s++;
 282:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
 286:	0f be 07             	movsbl (%rdi),%eax
 289:	83 f8 2d             	cmp    $0x2d,%eax
 28c:	74 f2                	je     280 <atoi+0xa>
  n = 0;
 28e:	b8 00 00 00 00       	mov    $0x0,%eax
 293:	eb 19                	jmp    2ae <atoi+0x38>
 295:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 29c:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 2a0:	8d 04 80             	lea    (%rax,%rax,4),%eax
 2a3:	48 83 c7 01          	add    $0x1,%rdi
 2a7:	0f be d2             	movsbl %dl,%edx
 2aa:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
 2ae:	8a 17                	mov    (%rdi),%dl
 2b0:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 2b3:	0f b6 c9             	movzbl %cl,%ecx
 2b6:	83 f9 09             	cmp    $0x9,%ecx
 2b9:	76 e5                	jbe    2a0 <atoi+0x2a>
  return sign * n;
 2bb:	0f af c6             	imul   %esi,%eax
}
 2be:	c3                   	ret

00000000000002bf <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2bf:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
 2c2:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
 2c5:	eb 28                	jmp    2ef <memmove+0x30>
 2c7:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2ce:	00 00 00 00 
 2d2:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2d9:	00 00 00 00 
 2dd:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
 2e0:	8a 16                	mov    (%rsi),%dl
 2e2:	88 11                	mov    %dl,(%rcx)
 2e4:	48 8d 76 01          	lea    0x1(%rsi),%rsi
 2e8:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
 2ec:	44 89 c2             	mov    %r8d,%edx
 2ef:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
 2f3:	85 d2                	test   %edx,%edx
 2f5:	7f e9                	jg     2e0 <memmove+0x21>
  return vdst;
}
 2f7:	c3                   	ret

00000000000002f8 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f8:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret

0000000000000302 <exit>:
SYSCALL(exit)
 302:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret

000000000000030c <wait>:
SYSCALL(wait)
 30c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret

0000000000000316 <pipe>:
SYSCALL(pipe)
 316:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret

0000000000000320 <read>:
SYSCALL(read)
 320:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret

000000000000032a <write>:
SYSCALL(write)
 32a:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret

0000000000000334 <close>:
SYSCALL(close)
 334:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret

000000000000033e <kill>:
SYSCALL(kill)
 33e:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret

0000000000000348 <exec>:
SYSCALL(exec)
 348:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret

0000000000000352 <open>:
SYSCALL(open)
 352:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret

000000000000035c <mknod>:
SYSCALL(mknod)
 35c:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret

0000000000000366 <unlink>:
SYSCALL(unlink)
 366:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret

0000000000000370 <fstat>:
SYSCALL(fstat)
 370:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret

000000000000037a <link>:
SYSCALL(link)
 37a:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret

0000000000000384 <mkdir>:
SYSCALL(mkdir)
 384:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret

000000000000038e <chdir>:
SYSCALL(chdir)
 38e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret

0000000000000398 <dup>:
SYSCALL(dup)
 398:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret

00000000000003a2 <getpid>:
SYSCALL(getpid)
 3a2:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret

00000000000003ac <sbrk>:
SYSCALL(sbrk)
 3ac:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret

00000000000003b6 <sleep>:
SYSCALL(sleep)
 3b6:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret

00000000000003c0 <uptime>:
SYSCALL(uptime)
 3c0:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret

00000000000003ca <vmcreate>:
SYSCALL(vmcreate)
 3ca:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret

00000000000003d4 <vmsetreg>:
SYSCALL(vmsetreg)
 3d4:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret

00000000000003de <vmrun>:
SYSCALL(vmrun)
 3de:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret

00000000000003e8 <vmgetreg>:
SYSCALL(vmgetreg)
 3e8:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret
 3f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 3f9:	00 00 00 
 3fc:	0f 1f 40 00          	nopl   0x0(%rax)

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
 43f:	e8 e6 fe ff ff       	call   32a <write>
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
 493:	44 8a 82 a0 09 00 00 	mov    0x9a0(%rdx),%r8b
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
 60e:	ff 24 c5 f0 08 00 00 	jmp    *0x8f0(,%rax,8)
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
 681:	41 bc e8 08 00 00    	mov    $0x8e8,%r12d
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
 727:	48 8b 05 d2 06 00 00 	mov    0x6d2(%rip),%rax        # e00 <freep>
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
 782:	48 89 05 77 06 00 00 	mov    %rax,0x677(%rip)        # e00 <freep>
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
 7ca:	e8 dd fb ff ff       	call   3ac <sbrk>
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
 7e1:	48 8b 05 18 06 00 00 	mov    0x618(%rip),%rax        # e00 <freep>
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
 80c:	48 8b 0d ed 05 00 00 	mov    0x5ed(%rip),%rcx        # e00 <freep>
 813:	48 85 c9             	test   %rcx,%rcx
 816:	74 05                	je     81d <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	48 8b 01             	mov    (%rcx),%rax
 81b:	eb 69                	jmp    886 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
 81d:	48 c7 05 d8 05 00 00 	movq   $0xe10,0x5d8(%rip)        # e00 <freep>
 824:	10 0e 00 00 
 828:	48 c7 05 dd 05 00 00 	movq   $0xe10,0x5dd(%rip)        # e10 <base>
 82f:	10 0e 00 00 
    base.s.size = 0;
 833:	c7 05 db 05 00 00 00 	movl   $0x0,0x5db(%rip)        # e18 <base+0x8>
 83a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 83d:	b9 10 0e 00 00       	mov    $0xe10,%ecx
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
 857:	48 89 0d a2 05 00 00 	mov    %rcx,0x5a2(%rip)        # e00 <freep>
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
 88d:	48 39 05 6c 05 00 00 	cmp    %rax,0x56c(%rip)        # e00 <freep>
 894:	75 ea                	jne    880 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
 896:	89 df                	mov    %ebx,%edi
 898:	e8 10 ff ff ff       	call   7ad <morecore>
 89d:	48 85 c0             	test   %rax,%rax
 8a0:	75 de                	jne    880 <malloc+0x8a>
 8a2:	eb be                	jmp    862 <malloc+0x6c>
