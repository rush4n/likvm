
_stressfs:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	41 54                	push   %r12
   6:	53                   	push   %rbx
   7:	48 81 ec 10 02 00 00 	sub    $0x210,%rsp
  int fd, i;
  char path[] = "stressfs0";
   e:	48 b8 73 74 72 65 73 	movabs $0x7366737365727473,%rax
  15:	73 66 73 
  18:	48 89 45 e6          	mov    %rax,-0x1a(%rbp)
  1c:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%rbp)
  char data[512];

  printf(1, "stressfs starting\n");
  22:	be f0 08 00 00       	mov    $0x8f0,%esi
  27:	bf 01 00 00 00       	mov    $0x1,%edi
  2c:	b0 00                	mov    $0x0,%al
  2e:	e8 f2 04 00 00       	call   525 <printf>
  memset(data, 'a', sizeof(data));
  33:	48 8d bd e0 fd ff ff 	lea    -0x220(%rbp),%rdi
  3a:	ba 00 02 00 00       	mov    $0x200,%edx
  3f:	be 61 00 00 00       	mov    $0x61,%esi
  44:	e8 56 01 00 00       	call   19f <memset>

  for(i = 0; i < 4; i++)
  49:	bb 00 00 00 00       	mov    $0x0,%ebx
  4e:	83 fb 03             	cmp    $0x3,%ebx
  51:	7f 0e                	jg     61 <main+0x61>
    if(fork() > 0)
  53:	e8 c0 02 00 00       	call   318 <fork>
  58:	85 c0                	test   %eax,%eax
  5a:	7f 05                	jg     61 <main+0x61>
  for(i = 0; i < 4; i++)
  5c:	83 c3 01             	add    $0x1,%ebx
  5f:	eb ed                	jmp    4e <main+0x4e>
      break;

  printf(1, "write %d\n", i);
  61:	89 da                	mov    %ebx,%edx
  63:	be 03 09 00 00       	mov    $0x903,%esi
  68:	bf 01 00 00 00       	mov    $0x1,%edi
  6d:	b0 00                	mov    $0x0,%al
  6f:	e8 b1 04 00 00       	call   525 <printf>

  path[8] += i;
  74:	8a 45 ee             	mov    -0x12(%rbp),%al
  77:	01 c3                	add    %eax,%ebx
  79:	88 5d ee             	mov    %bl,-0x12(%rbp)
  fd = open(path, O_CREATE | O_RDWR);
  7c:	48 8d 7d e6          	lea    -0x1a(%rbp),%rdi
  80:	be 02 02 00 00       	mov    $0x202,%esi
  85:	e8 e8 02 00 00       	call   372 <open>
  8a:	41 89 c4             	mov    %eax,%r12d
  for(i = 0; i < 20; i++)
  8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  92:	eb 17                	jmp    ab <main+0xab>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  94:	48 8d b5 e0 fd ff ff 	lea    -0x220(%rbp),%rsi
  9b:	ba 00 02 00 00       	mov    $0x200,%edx
  a0:	44 89 e7             	mov    %r12d,%edi
  a3:	e8 a2 02 00 00       	call   34a <write>
  for(i = 0; i < 20; i++)
  a8:	83 c3 01             	add    $0x1,%ebx
  ab:	83 fb 13             	cmp    $0x13,%ebx
  ae:	7e e4                	jle    94 <main+0x94>
  close(fd);
  b0:	44 89 e7             	mov    %r12d,%edi
  b3:	e8 9c 02 00 00       	call   354 <close>

  printf(1, "read\n");
  b8:	be 0d 09 00 00       	mov    $0x90d,%esi
  bd:	bf 01 00 00 00       	mov    $0x1,%edi
  c2:	b0 00                	mov    $0x0,%al
  c4:	e8 5c 04 00 00       	call   525 <printf>

  fd = open(path, O_RDONLY);
  c9:	48 8d 7d e6          	lea    -0x1a(%rbp),%rdi
  cd:	be 00 00 00 00       	mov    $0x0,%esi
  d2:	e8 9b 02 00 00       	call   372 <open>
  d7:	41 89 c4             	mov    %eax,%r12d
  for (i = 0; i < 20; i++)
  da:	bb 00 00 00 00       	mov    $0x0,%ebx
  df:	eb 17                	jmp    f8 <main+0xf8>
    read(fd, data, sizeof(data));
  e1:	48 8d b5 e0 fd ff ff 	lea    -0x220(%rbp),%rsi
  e8:	ba 00 02 00 00       	mov    $0x200,%edx
  ed:	44 89 e7             	mov    %r12d,%edi
  f0:	e8 4b 02 00 00       	call   340 <read>
  for (i = 0; i < 20; i++)
  f5:	83 c3 01             	add    $0x1,%ebx
  f8:	83 fb 13             	cmp    $0x13,%ebx
  fb:	7e e4                	jle    e1 <main+0xe1>
  close(fd);
  fd:	44 89 e7             	mov    %r12d,%edi
 100:	e8 4f 02 00 00       	call   354 <close>

  wait();
 105:	e8 22 02 00 00       	call   32c <wait>

  exit();
 10a:	e8 13 02 00 00       	call   322 <exit>
 10f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 116:	00 00 00 
 119:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 120:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 123:	48 89 f9             	mov    %rdi,%rcx
 126:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 12d:	00 00 00 00 
 131:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 138:	00 00 00 00 
 13c:	0f 1f 40 00          	nopl   0x0(%rax)
 140:	48 89 f2             	mov    %rsi,%rdx
 143:	48 83 c6 01          	add    $0x1,%rsi
 147:	49 89 c8             	mov    %rcx,%r8
 14a:	48 83 c1 01          	add    $0x1,%rcx
 14e:	8a 12                	mov    (%rdx),%dl
 150:	41 88 10             	mov    %dl,(%r8)
 153:	0f be d2             	movsbl %dl,%edx
 156:	85 d2                	test   %edx,%edx
 158:	75 e6                	jne    140 <strcpy+0x20>
    ;
  return os;
}
 15a:	c3                   	ret

000000000000015b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15b:	eb 0b                	jmp    168 <strcmp+0xd>
 15d:	0f 1f 00             	nopl   (%rax)
    p++, q++;
 160:	48 83 c7 01          	add    $0x1,%rdi
 164:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
 168:	8a 07                	mov    (%rdi),%al
 16a:	0f be d0             	movsbl %al,%edx
 16d:	85 d2                	test   %edx,%edx
 16f:	74 07                	je     178 <strcmp+0x1d>
 171:	0f be 0e             	movsbl (%rsi),%ecx
 174:	39 ca                	cmp    %ecx,%edx
 176:	74 e8                	je     160 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 178:	0f b6 c0             	movzbl %al,%eax
 17b:	0f b6 16             	movzbl (%rsi),%edx
 17e:	29 d0                	sub    %edx,%eax
}
 180:	c3                   	ret

0000000000000181 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 181:	b8 00 00 00 00       	mov    $0x0,%eax
 186:	eb 0b                	jmp    193 <strlen+0x12>
 188:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18f:	00 
 190:	83 c0 01             	add    $0x1,%eax
 193:	48 63 d0             	movslq %eax,%rdx
 196:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
 19a:	85 d2                	test   %edx,%edx
 19c:	75 f2                	jne    190 <strlen+0xf>
    ;
  return n;
}
 19e:	c3                   	ret

000000000000019f <memset>:

void*
memset(void *dst, int c, uint n)
{
 19f:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
 1a2:	89 d1                	mov    %edx,%ecx
 1a4:	89 f0                	mov    %esi,%eax
 1a6:	fc                   	cld
 1a7:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 1a9:	4c 89 c0             	mov    %r8,%rax
 1ac:	c3                   	ret

00000000000001ad <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ad:	eb 15                	jmp    1c4 <strchr+0x17>
 1af:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1b6:	00 00 00 00 
 1ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1c0:	48 83 c7 01          	add    $0x1,%rdi
 1c4:	8a 17                	mov    (%rdi),%dl
 1c6:	0f be c2             	movsbl %dl,%eax
 1c9:	85 c0                	test   %eax,%eax
 1cb:	74 0f                	je     1dc <strchr+0x2f>
    if(*s == c)
 1cd:	0f be d2             	movsbl %dl,%edx
 1d0:	40 0f be c6          	movsbl %sil,%eax
 1d4:	39 c2                	cmp    %eax,%edx
 1d6:	75 e8                	jne    1c0 <strchr+0x13>
      return (char*)s;
 1d8:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
 1db:	c3                   	ret
  return 0;
 1dc:	b8 00 00 00 00       	mov    $0x0,%eax
 1e1:	c3                   	ret

00000000000001e2 <gets>:

char*
gets(char *buf, int max)
{
 1e2:	55                   	push   %rbp
 1e3:	48 89 e5             	mov    %rsp,%rbp
 1e6:	41 56                	push   %r14
 1e8:	41 55                	push   %r13
 1ea:	41 54                	push   %r12
 1ec:	53                   	push   %rbx
 1ed:	48 83 ec 10          	sub    $0x10,%rsp
 1f1:	49 89 fc             	mov    %rdi,%r12
 1f4:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f7:	bb 00 00 00 00       	mov    $0x0,%ebx
 1fc:	41 89 de             	mov    %ebx,%r14d
 1ff:	83 c3 01             	add    $0x1,%ebx
 202:	44 39 eb             	cmp    %r13d,%ebx
 205:	7d 39                	jge    240 <gets+0x5e>
    cc = read(0, &c, 1);
 207:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 20b:	ba 01 00 00 00       	mov    $0x1,%edx
 210:	bf 00 00 00 00       	mov    $0x0,%edi
 215:	e8 26 01 00 00       	call   340 <read>
    if(cc < 1)
 21a:	85 c0                	test   %eax,%eax
 21c:	7e 22                	jle    240 <gets+0x5e>
      break;
    buf[i++] = c;
 21e:	4d 63 f6             	movslq %r14d,%r14
 221:	8a 45 df             	mov    -0x21(%rbp),%al
 224:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
 228:	0f be c0             	movsbl %al,%eax
 22b:	83 f8 0a             	cmp    $0xa,%eax
 22e:	0f 94 c2             	sete   %dl
 231:	83 f8 0d             	cmp    $0xd,%eax
 234:	0f 94 c0             	sete   %al
 237:	09 d0                	or     %edx,%eax
 239:	a8 ff                	test   $0xff,%al
 23b:	74 bf                	je     1fc <gets+0x1a>
    buf[i++] = c;
 23d:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
 240:	4d 63 f6             	movslq %r14d,%r14
 243:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
 248:	4c 89 e0             	mov    %r12,%rax
 24b:	48 83 c4 10          	add    $0x10,%rsp
 24f:	5b                   	pop    %rbx
 250:	41 5c                	pop    %r12
 252:	41 5d                	pop    %r13
 254:	41 5e                	pop    %r14
 256:	5d                   	pop    %rbp
 257:	c3                   	ret

0000000000000258 <stat>:

int
stat(const char *n, struct stat *st)
{
 258:	55                   	push   %rbp
 259:	48 89 e5             	mov    %rsp,%rbp
 25c:	41 54                	push   %r12
 25e:	53                   	push   %rbx
 25f:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 262:	be 00 00 00 00       	mov    $0x0,%esi
 267:	e8 06 01 00 00       	call   372 <open>
  if(fd < 0)
 26c:	85 c0                	test   %eax,%eax
 26e:	78 1e                	js     28e <stat+0x36>
 270:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 272:	4c 89 e6             	mov    %r12,%rsi
 275:	89 c7                	mov    %eax,%edi
 277:	e8 14 01 00 00       	call   390 <fstat>
 27c:	41 89 c4             	mov    %eax,%r12d
  close(fd);
 27f:	89 df                	mov    %ebx,%edi
 281:	e8 ce 00 00 00       	call   354 <close>
  return r;
}
 286:	44 89 e0             	mov    %r12d,%eax
 289:	5b                   	pop    %rbx
 28a:	41 5c                	pop    %r12
 28c:	5d                   	pop    %rbp
 28d:	c3                   	ret
    return -1;
 28e:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 294:	eb f0                	jmp    286 <stat+0x2e>

0000000000000296 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
 296:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
 29b:	eb 09                	jmp    2a6 <atoi+0x10>
 29d:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
 2a0:	f7 de                	neg    %esi
    s++;
 2a2:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
 2a6:	0f be 07             	movsbl (%rdi),%eax
 2a9:	83 f8 2d             	cmp    $0x2d,%eax
 2ac:	74 f2                	je     2a0 <atoi+0xa>
  n = 0;
 2ae:	b8 00 00 00 00       	mov    $0x0,%eax
 2b3:	eb 19                	jmp    2ce <atoi+0x38>
 2b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2bc:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 2c0:	8d 04 80             	lea    (%rax,%rax,4),%eax
 2c3:	48 83 c7 01          	add    $0x1,%rdi
 2c7:	0f be d2             	movsbl %dl,%edx
 2ca:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
 2ce:	8a 17                	mov    (%rdi),%dl
 2d0:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 2d3:	0f b6 c9             	movzbl %cl,%ecx
 2d6:	83 f9 09             	cmp    $0x9,%ecx
 2d9:	76 e5                	jbe    2c0 <atoi+0x2a>
  return sign * n;
 2db:	0f af c6             	imul   %esi,%eax
}
 2de:	c3                   	ret

00000000000002df <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2df:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
 2e2:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
 2e5:	eb 28                	jmp    30f <memmove+0x30>
 2e7:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2ee:	00 00 00 00 
 2f2:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2f9:	00 00 00 00 
 2fd:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
 300:	8a 16                	mov    (%rsi),%dl
 302:	88 11                	mov    %dl,(%rcx)
 304:	48 8d 76 01          	lea    0x1(%rsi),%rsi
 308:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
 30c:	44 89 c2             	mov    %r8d,%edx
 30f:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
 313:	85 d2                	test   %edx,%edx
 315:	7f e9                	jg     300 <memmove+0x21>
  return vdst;
}
 317:	c3                   	ret

0000000000000318 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 318:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret

0000000000000322 <exit>:
SYSCALL(exit)
 322:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret

000000000000032c <wait>:
SYSCALL(wait)
 32c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret

0000000000000336 <pipe>:
SYSCALL(pipe)
 336:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret

0000000000000340 <read>:
SYSCALL(read)
 340:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret

000000000000034a <write>:
SYSCALL(write)
 34a:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret

0000000000000354 <close>:
SYSCALL(close)
 354:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret

000000000000035e <kill>:
SYSCALL(kill)
 35e:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret

0000000000000368 <exec>:
SYSCALL(exec)
 368:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret

0000000000000372 <open>:
SYSCALL(open)
 372:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret

000000000000037c <mknod>:
SYSCALL(mknod)
 37c:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret

0000000000000386 <unlink>:
SYSCALL(unlink)
 386:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret

0000000000000390 <fstat>:
SYSCALL(fstat)
 390:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret

000000000000039a <link>:
SYSCALL(link)
 39a:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret

00000000000003a4 <mkdir>:
SYSCALL(mkdir)
 3a4:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret

00000000000003ae <chdir>:
SYSCALL(chdir)
 3ae:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret

00000000000003b8 <dup>:
SYSCALL(dup)
 3b8:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret

00000000000003c2 <getpid>:
SYSCALL(getpid)
 3c2:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret

00000000000003cc <sbrk>:
SYSCALL(sbrk)
 3cc:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret

00000000000003d6 <sleep>:
SYSCALL(sleep)
 3d6:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret

00000000000003e0 <uptime>:
SYSCALL(uptime)
 3e0:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret

00000000000003ea <vmcreate>:
SYSCALL(vmcreate)
 3ea:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret

00000000000003f4 <vmsetreg>:
SYSCALL(vmsetreg)
 3f4:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret

00000000000003fe <vmrun>:
SYSCALL(vmrun)
 3fe:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret

0000000000000408 <vmgetreg>:
SYSCALL(vmgetreg)
 408:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret
 412:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 419:	00 00 00 
 41c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 423:	00 00 00 
 426:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 42d:	00 00 00 
 430:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 437:	00 00 00 
 43a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000000440 <_va_arg>:
// Retrieve the next argument from the va_list.
static inline void *_va_arg(va_list *args)
{
    // Returns the next argument from registers if _index < 6, 
    // otherwise from the stack.
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 440:	8b 47 38             	mov    0x38(%rdi),%eax
 443:	83 f8 05             	cmp    $0x5,%eax
 446:	77 0d                	ja     455 <_va_arg+0x15>
 448:	8d 50 01             	lea    0x1(%rax),%edx
 44b:	89 57 38             	mov    %edx,0x38(%rdi)
 44e:	89 c0                	mov    %eax,%eax
 450:	48 8b 04 c7          	mov    (%rdi,%rax,8),%rax
 454:	c3                   	ret
                                  : args->more_argint[(args->_index++)-6]);
 455:	8d 50 01             	lea    0x1(%rax),%edx
 458:	89 57 38             	mov    %edx,0x38(%rdi)
 45b:	8d 40 fa             	lea    -0x6(%rax),%eax
 45e:	48 c1 e0 03          	shl    $0x3,%rax
 462:	48 03 47 30          	add    0x30(%rdi),%rax
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 466:	48 8b 00             	mov    (%rax),%rax
}
 469:	c3                   	ret

000000000000046a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 46a:	55                   	push   %rbp
 46b:	48 89 e5             	mov    %rsp,%rbp
 46e:	48 83 ec 10          	sub    $0x10,%rsp
 472:	40 88 75 fc          	mov    %sil,-0x4(%rbp)
  write(fd, &c, 1);
 476:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 47a:	ba 01 00 00 00       	mov    $0x1,%edx
 47f:	e8 c6 fe ff ff       	call   34a <write>
}
 484:	48 89 ec             	mov    %rbp,%rsp
 487:	5d                   	pop    %rbp
 488:	c3                   	ret

0000000000000489 <printint>:

static void
printint(int fd, int64 xx, int base, int sgn)
{
 489:	55                   	push   %rbp
 48a:	48 89 e5             	mov    %rsp,%rbp
 48d:	41 54                	push   %r12
 48f:	53                   	push   %rbx
 490:	48 83 ec 10          	sub    $0x10,%rsp
 494:	41 89 fc             	mov    %edi,%r12d
 497:	41 89 d1             	mov    %edx,%r9d
  char buf[16];
  int i, neg;
  uint64 x;

  neg = 0;
  if(sgn && xx < 0){
 49a:	85 c9                	test   %ecx,%ecx
 49c:	0f 95 c2             	setne  %dl
 49f:	48 89 f0             	mov    %rsi,%rax
 4a2:	48 c1 e8 3f          	shr    $0x3f,%rax
 4a6:	85 c2                	test   %eax,%edx
 4a8:	74 55                	je     4ff <printint+0x76>
    neg = 1;
    x = -xx;
 4aa:	48 f7 de             	neg    %rsi
    neg = 1;
 4ad:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  } else {
    x = xx;
  }

  i = 0;
 4b3:	bb 00 00 00 00       	mov    $0x0,%ebx
 4b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 4bf:	00 
  do{
    buf[i++] = digits[x % base];
 4c0:	49 63 c9             	movslq %r9d,%rcx
 4c3:	48 89 f0             	mov    %rsi,%rax
 4c6:	ba 00 00 00 00       	mov    $0x0,%edx
 4cb:	48 f7 f1             	div    %rcx
 4ce:	89 df                	mov    %ebx,%edi
 4d0:	83 c3 01             	add    $0x1,%ebx
 4d3:	44 8a 82 d0 09 00 00 	mov    0x9d0(%rdx),%r8b
 4da:	48 63 d7             	movslq %edi,%rdx
 4dd:	44 88 44 15 e0       	mov    %r8b,-0x20(%rbp,%rdx,1)
  }while((x /= base) != 0);
 4e2:	48 89 f2             	mov    %rsi,%rdx
 4e5:	48 89 c6             	mov    %rax,%rsi
 4e8:	48 39 ca             	cmp    %rcx,%rdx
 4eb:	73 d3                	jae    4c0 <printint+0x37>
  if(neg)
 4ed:	45 85 d2             	test   %r10d,%r10d
 4f0:	74 25                	je     517 <printint+0x8e>
    buf[i++] = '-';
 4f2:	48 63 db             	movslq %ebx,%rbx
 4f5:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 4fa:	8d 5f 02             	lea    0x2(%rdi),%ebx
 4fd:	eb 18                	jmp    517 <printint+0x8e>
  neg = 0;
 4ff:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 505:	eb ac                	jmp    4b3 <printint+0x2a>

  while(--i >= 0)
    putc(fd, buf[i]);
 507:	48 63 c3             	movslq %ebx,%rax
 50a:	0f be 74 05 e0       	movsbl -0x20(%rbp,%rax,1),%esi
 50f:	44 89 e7             	mov    %r12d,%edi
 512:	e8 53 ff ff ff       	call   46a <putc>
  while(--i >= 0)
 517:	83 eb 01             	sub    $0x1,%ebx
 51a:	79 eb                	jns    507 <printint+0x7e>
}
 51c:	48 83 c4 10          	add    $0x10,%rsp
 520:	5b                   	pop    %rbx
 521:	41 5c                	pop    %r12
 523:	5d                   	pop    %rbp
 524:	c3                   	ret

0000000000000525 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 525:	55                   	push   %rbp
 526:	48 89 e5             	mov    %rsp,%rbp
 529:	41 57                	push   %r15
 52b:	41 56                	push   %r14
 52d:	41 55                	push   %r13
 52f:	41 54                	push   %r12
 531:	53                   	push   %rbx
 532:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
 539:	41 89 ff             	mov    %edi,%r15d
 53c:	49 89 f5             	mov    %rsi,%r13
 53f:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
 546:	48 89 8d 38 ff ff ff 	mov    %rcx,-0xc8(%rbp)
 54d:	4c 89 85 40 ff ff ff 	mov    %r8,-0xc0(%rbp)
 554:	4c 89 8d 48 ff ff ff 	mov    %r9,-0xb8(%rbp)
 55b:	84 c0                	test   %al,%al
 55d:	74 29                	je     588 <printf+0x63>
 55f:	0f 29 85 50 ff ff ff 	movaps %xmm0,-0xb0(%rbp)
 566:	0f 29 8d 60 ff ff ff 	movaps %xmm1,-0xa0(%rbp)
 56d:	0f 29 95 70 ff ff ff 	movaps %xmm2,-0x90(%rbp)
 574:	0f 29 5d 80          	movaps %xmm3,-0x80(%rbp)
 578:	0f 29 65 90          	movaps %xmm4,-0x70(%rbp)
 57c:	0f 29 6d a0          	movaps %xmm5,-0x60(%rbp)
 580:	0f 29 75 b0          	movaps %xmm6,-0x50(%rbp)
 584:	0f 29 7d c0          	movaps %xmm7,-0x40(%rbp)
    asm volatile("movq %%rdi, %0;" 
 588:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
 58f:	48 89 b5 e8 fe ff ff 	mov    %rsi,-0x118(%rbp)
 596:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
 59d:	48 89 8d f8 fe ff ff 	mov    %rcx,-0x108(%rbp)
 5a4:	4c 89 85 00 ff ff ff 	mov    %r8,-0x100(%rbp)
 5ab:	4c 89 8d 08 ff ff ff 	mov    %r9,-0xf8(%rbp)
    asm volatile("leaq 16(%%rbp), %0" : "=r" (args->more_argint));
 5b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
 5b6:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
    args->_index = 1;
 5bd:	c7 85 18 ff ff ff 01 	movl   $0x1,-0xe8(%rbp)
 5c4:	00 00 00 
  char *s;
  int c, i, state;
  va_list ap;

  va_start(ap, fd);
  (void) va_arg(ap, char*); // skip fmt
 5c7:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 5ce:	e8 6d fe ff ff       	call   440 <_va_arg>

  state = 0;
 5d3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(i = 0; fmt[i]; i++){
 5d9:	bb 00 00 00 00       	mov    $0x0,%ebx
 5de:	eb 16                	jmp    5f6 <printf+0xd1>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5e0:	44 89 f6             	mov    %r14d,%esi
 5e3:	44 89 ff             	mov    %r15d,%edi
 5e6:	e8 7f fe ff ff       	call   46a <putc>
 5eb:	eb 06                	jmp    5f3 <printf+0xce>
      }
    } else if(state == '%'){
 5ed:	41 83 fc 25          	cmp    $0x25,%r12d
 5f1:	74 2c                	je     61f <printf+0xfa>
  for(i = 0; fmt[i]; i++){
 5f3:	83 c3 01             	add    $0x1,%ebx
 5f6:	48 63 c3             	movslq %ebx,%rax
 5f9:	41 8a 44 05 00       	mov    0x0(%r13,%rax,1),%al
 5fe:	0f be d0             	movsbl %al,%edx
 601:	85 d2                	test   %edx,%edx
 603:	0f 84 42 01 00 00    	je     74b <printf+0x226>
    c = fmt[i] & 0xff;
 609:	44 0f be f0          	movsbl %al,%r14d
 60d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 610:	45 85 e4             	test   %r12d,%r12d
 613:	75 d8                	jne    5ed <printf+0xc8>
      if(c == '%'){
 615:	83 f8 25             	cmp    $0x25,%eax
 618:	75 c6                	jne    5e0 <printf+0xbb>
        state = '%';
 61a:	41 89 c4             	mov    %eax,%r12d
 61d:	eb d4                	jmp    5f3 <printf+0xce>
      if(c == 'd'){
 61f:	83 f8 25             	cmp    $0x25,%eax
 622:	0f 84 ea 00 00 00    	je     712 <printf+0x1ed>
 628:	0f 8c fa 00 00 00    	jl     728 <printf+0x203>
 62e:	83 f8 78             	cmp    $0x78,%eax
 631:	0f 8f f1 00 00 00    	jg     728 <printf+0x203>
 637:	83 f8 63             	cmp    $0x63,%eax
 63a:	0f 8c e8 00 00 00    	jl     728 <printf+0x203>
 640:	83 e8 63             	sub    $0x63,%eax
 643:	83 f8 15             	cmp    $0x15,%eax
 646:	0f 87 dc 00 00 00    	ja     728 <printf+0x203>
 64c:	89 c0                	mov    %eax,%eax
 64e:	ff 24 c5 20 09 00 00 	jmp    *0x920(,%rax,8)
        printint(fd, va_arg(ap, int), 10, 1);
 655:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 65c:	e8 df fd ff ff       	call   440 <_va_arg>
 661:	48 63 f0             	movslq %eax,%rsi
 664:	b9 01 00 00 00       	mov    $0x1,%ecx
 669:	ba 0a 00 00 00       	mov    $0xa,%edx
 66e:	44 89 ff             	mov    %r15d,%edi
 671:	e8 13 fe ff ff       	call   489 <printint>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 676:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 67c:	e9 72 ff ff ff       	jmp    5f3 <printf+0xce>
        printint(fd, va_arg(ap, uint64), 16, 0);
 681:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 688:	e8 b3 fd ff ff       	call   440 <_va_arg>
 68d:	48 89 c6             	mov    %rax,%rsi
 690:	b9 00 00 00 00       	mov    $0x0,%ecx
 695:	ba 10 00 00 00       	mov    $0x10,%edx
 69a:	44 89 ff             	mov    %r15d,%edi
 69d:	e8 e7 fd ff ff       	call   489 <printint>
      state = 0;
 6a2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 6a8:	e9 46 ff ff ff       	jmp    5f3 <printf+0xce>
        s = va_arg(ap, char*);
 6ad:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 6b4:	e8 87 fd ff ff       	call   440 <_va_arg>
 6b9:	49 89 c4             	mov    %rax,%r12
        if(s == 0)
 6bc:	48 85 c0             	test   %rax,%rax
 6bf:	75 18                	jne    6d9 <printf+0x1b4>
          s = "(null)";
 6c1:	41 bc 13 09 00 00    	mov    $0x913,%r12d
 6c7:	eb 10                	jmp    6d9 <printf+0x1b4>
          putc(fd, *s);
 6c9:	40 0f be f6          	movsbl %sil,%esi
 6cd:	44 89 ff             	mov    %r15d,%edi
 6d0:	e8 95 fd ff ff       	call   46a <putc>
          s++;
 6d5:	49 83 c4 01          	add    $0x1,%r12
        while(*s != 0){
 6d9:	41 8a 34 24          	mov    (%r12),%sil
 6dd:	40 0f be c6          	movsbl %sil,%eax
 6e1:	85 c0                	test   %eax,%eax
 6e3:	75 e4                	jne    6c9 <printf+0x1a4>
      state = 0;
 6e5:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 6eb:	e9 03 ff ff ff       	jmp    5f3 <printf+0xce>
        putc(fd, va_arg(ap, char));
 6f0:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 6f7:	e8 44 fd ff ff       	call   440 <_va_arg>
 6fc:	0f be f0             	movsbl %al,%esi
 6ff:	44 89 ff             	mov    %r15d,%edi
 702:	e8 63 fd ff ff       	call   46a <putc>
      state = 0;
 707:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 70d:	e9 e1 fe ff ff       	jmp    5f3 <printf+0xce>
        putc(fd, c);
 712:	44 89 f6             	mov    %r14d,%esi
 715:	44 89 ff             	mov    %r15d,%edi
 718:	e8 4d fd ff ff       	call   46a <putc>
      state = 0;
 71d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 723:	e9 cb fe ff ff       	jmp    5f3 <printf+0xce>
        putc(fd, '%');
 728:	be 25 00 00 00       	mov    $0x25,%esi
 72d:	44 89 ff             	mov    %r15d,%edi
 730:	e8 35 fd ff ff       	call   46a <putc>
        putc(fd, c);
 735:	44 89 f6             	mov    %r14d,%esi
 738:	44 89 ff             	mov    %r15d,%edi
 73b:	e8 2a fd ff ff       	call   46a <putc>
      state = 0;
 740:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 746:	e9 a8 fe ff ff       	jmp    5f3 <printf+0xce>
    }
  }
}
 74b:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
 752:	5b                   	pop    %rbx
 753:	41 5c                	pop    %r12
 755:	41 5d                	pop    %r13
 757:	41 5e                	pop    %r14
 759:	41 5f                	pop    %r15
 75b:	5d                   	pop    %rbp
 75c:	c3                   	ret
 75d:	0f 1f 00             	nopl   (%rax)

0000000000000760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 760:	48 89 fe             	mov    %rdi,%rsi
  Header *bp, *p;

  bp = (Header*)ap - 1;
 763:	48 8d 4f f0          	lea    -0x10(%rdi),%rcx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 767:	48 8b 05 82 04 00 00 	mov    0x482(%rip),%rax        # bf0 <freep>
 76e:	eb 03                	jmp    773 <free+0x13>
 770:	48 89 d0             	mov    %rdx,%rax
 773:	48 39 c8             	cmp    %rcx,%rax
 776:	73 05                	jae    77d <free+0x1d>
 778:	48 3b 08             	cmp    (%rax),%rcx
 77b:	72 17                	jb     794 <free+0x34>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77d:	48 8b 10             	mov    (%rax),%rdx
 780:	48 39 d0             	cmp    %rdx,%rax
 783:	72 eb                	jb     770 <free+0x10>
 785:	48 39 c8             	cmp    %rcx,%rax
 788:	72 0a                	jb     794 <free+0x34>
 78a:	48 39 d1             	cmp    %rdx,%rcx
 78d:	72 05                	jb     794 <free+0x34>
 78f:	48 89 d0             	mov    %rdx,%rax
 792:	eb df                	jmp    773 <free+0x13>
      break;
  if(bp + bp->s.size == p->s.ptr){
 794:	44 8b 46 f8          	mov    -0x8(%rsi),%r8d
 798:	44 89 c2             	mov    %r8d,%edx
 79b:	48 c1 e2 04          	shl    $0x4,%rdx
 79f:	48 01 ca             	add    %rcx,%rdx
 7a2:	48 8b 38             	mov    (%rax),%rdi
 7a5:	48 39 fa             	cmp    %rdi,%rdx
 7a8:	74 20                	je     7ca <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7aa:	48 89 7e f0          	mov    %rdi,-0x10(%rsi)
  if(p + p->s.size == bp){
 7ae:	8b 78 08             	mov    0x8(%rax),%edi
 7b1:	89 fa                	mov    %edi,%edx
 7b3:	48 c1 e2 04          	shl    $0x4,%rdx
 7b7:	48 01 c2             	add    %rax,%rdx
 7ba:	48 39 ca             	cmp    %rcx,%rdx
 7bd:	74 1f                	je     7de <free+0x7e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7bf:	48 89 08             	mov    %rcx,(%rax)
  freep = p;
 7c2:	48 89 05 27 04 00 00 	mov    %rax,0x427(%rip)        # bf0 <freep>
}
 7c9:	c3                   	ret
    bp->s.size += p->s.ptr->s.size;
 7ca:	44 03 47 08          	add    0x8(%rdi),%r8d
 7ce:	44 89 46 f8          	mov    %r8d,-0x8(%rsi)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d2:	48 8b 10             	mov    (%rax),%rdx
 7d5:	48 8b 12             	mov    (%rdx),%rdx
 7d8:	48 89 56 f0          	mov    %rdx,-0x10(%rsi)
 7dc:	eb d0                	jmp    7ae <free+0x4e>
    p->s.size += bp->s.size;
 7de:	03 7e f8             	add    -0x8(%rsi),%edi
 7e1:	89 78 08             	mov    %edi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 7e4:	48 8b 56 f0          	mov    -0x10(%rsi),%rdx
 7e8:	48 89 10             	mov    %rdx,(%rax)
 7eb:	eb d5                	jmp    7c2 <free+0x62>

00000000000007ed <morecore>:

static Header*
morecore(uint nu)
{
 7ed:	55                   	push   %rbp
 7ee:	48 89 e5             	mov    %rsp,%rbp
 7f1:	53                   	push   %rbx
 7f2:	48 83 ec 08          	sub    $0x8,%rsp
 7f6:	89 fb                	mov    %edi,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 7f8:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 7fe:	77 05                	ja     805 <morecore+0x18>
    nu = 4096;
 800:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 805:	89 df                	mov    %ebx,%edi
 807:	c1 e7 04             	shl    $0x4,%edi
 80a:	e8 bd fb ff ff       	call   3cc <sbrk>
  if(p == (char*)-1)
 80f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 813:	74 1a                	je     82f <morecore+0x42>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 815:	89 58 08             	mov    %ebx,0x8(%rax)
  free((void*)(hp + 1));
 818:	48 8d 78 10          	lea    0x10(%rax),%rdi
 81c:	e8 3f ff ff ff       	call   760 <free>
  return freep;
 821:	48 8b 05 c8 03 00 00 	mov    0x3c8(%rip),%rax        # bf0 <freep>
}
 828:	48 83 c4 08          	add    $0x8,%rsp
 82c:	5b                   	pop    %rbx
 82d:	5d                   	pop    %rbp
 82e:	c3                   	ret
    return 0;
 82f:	b8 00 00 00 00       	mov    $0x0,%eax
 834:	eb f2                	jmp    828 <morecore+0x3b>

0000000000000836 <malloc>:

void*
malloc(uint nbytes)
{
 836:	55                   	push   %rbp
 837:	48 89 e5             	mov    %rsp,%rbp
 83a:	53                   	push   %rbx
 83b:	48 83 ec 08          	sub    $0x8,%rsp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83f:	89 fb                	mov    %edi,%ebx
 841:	48 83 c3 0f          	add    $0xf,%rbx
 845:	48 c1 eb 04          	shr    $0x4,%rbx
 849:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 84c:	48 8b 0d 9d 03 00 00 	mov    0x39d(%rip),%rcx        # bf0 <freep>
 853:	48 85 c9             	test   %rcx,%rcx
 856:	74 05                	je     85d <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	48 8b 01             	mov    (%rcx),%rax
 85b:	eb 69                	jmp    8c6 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
 85d:	48 c7 05 88 03 00 00 	movq   $0xc00,0x388(%rip)        # bf0 <freep>
 864:	00 0c 00 00 
 868:	48 c7 05 8d 03 00 00 	movq   $0xc00,0x38d(%rip)        # c00 <base>
 86f:	00 0c 00 00 
    base.s.size = 0;
 873:	c7 05 8b 03 00 00 00 	movl   $0x0,0x38b(%rip)        # c08 <base+0x8>
 87a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 87d:	b9 00 0c 00 00       	mov    $0xc00,%ecx
 882:	eb d4                	jmp    858 <malloc+0x22>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 884:	74 23                	je     8a9 <malloc+0x73>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 886:	29 da                	sub    %ebx,%edx
 888:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 88b:	89 d2                	mov    %edx,%edx
 88d:	48 c1 e2 04          	shl    $0x4,%rdx
 891:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 894:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 897:	48 89 0d 52 03 00 00 	mov    %rcx,0x352(%rip)        # bf0 <freep>
      return (void*)(p + 1);
 89e:	48 83 c0 10          	add    $0x10,%rax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8a2:	48 83 c4 08          	add    $0x8,%rsp
 8a6:	5b                   	pop    %rbx
 8a7:	5d                   	pop    %rbp
 8a8:	c3                   	ret
        prevp->s.ptr = p->s.ptr;
 8a9:	48 8b 10             	mov    (%rax),%rdx
 8ac:	48 89 11             	mov    %rdx,(%rcx)
 8af:	eb e6                	jmp    897 <malloc+0x61>
 8b1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 8b8:	00 00 00 00 
 8bc:	0f 1f 40 00          	nopl   0x0(%rax)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	48 89 c1             	mov    %rax,%rcx
 8c3:	48 8b 00             	mov    (%rax),%rax
    if(p->s.size >= nunits){
 8c6:	8b 50 08             	mov    0x8(%rax),%edx
 8c9:	39 da                	cmp    %ebx,%edx
 8cb:	73 b7                	jae    884 <malloc+0x4e>
    if(p == freep)
 8cd:	48 39 05 1c 03 00 00 	cmp    %rax,0x31c(%rip)        # bf0 <freep>
 8d4:	75 ea                	jne    8c0 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
 8d6:	89 df                	mov    %ebx,%edi
 8d8:	e8 10 ff ff ff       	call   7ed <morecore>
 8dd:	48 85 c0             	test   %rax,%rax
 8e0:	75 de                	jne    8c0 <malloc+0x8a>
 8e2:	eb be                	jmp    8a2 <malloc+0x6c>
