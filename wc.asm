
_wc:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	41 57                	push   %r15
   6:	41 56                	push   %r14
   8:	41 55                	push   %r13
   a:	41 54                	push   %r12
   c:	53                   	push   %rbx
   d:	48 83 ec 18          	sub    $0x18,%rsp
  11:	89 7d c8             	mov    %edi,-0x38(%rbp)
  14:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  18:	41 be 00 00 00 00    	mov    $0x0,%r14d
  l = w = c = 0;
  1e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  24:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  2b:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  while((n = read(fd, buf, sizeof(buf))) > 0){
  31:	ba 00 02 00 00       	mov    $0x200,%edx
  36:	be 80 0c 00 00       	mov    $0xc80,%esi
  3b:	8b 7d c8             	mov    -0x38(%rbp),%edi
  3e:	e8 5d 03 00 00       	call   3a0 <read>
  43:	41 89 c5             	mov    %eax,%r13d
  46:	85 c0                	test   %eax,%eax
  48:	7e 56                	jle    a0 <wc+0xa0>
    for(i=0; i<n; i++){
  4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  4f:	eb 1c                	jmp    6d <wc+0x6d>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  51:	40 0f be f6          	movsbl %sil,%esi
  55:	bf 30 09 00 00       	mov    $0x930,%edi
  5a:	e8 ae 01 00 00       	call   20d <strchr>
  5f:	48 85 c0             	test   %rax,%rax
  62:	74 2b                	je     8f <wc+0x8f>
        inword = 0;
  64:	41 be 00 00 00 00    	mov    $0x0,%r14d
    for(i=0; i<n; i++){
  6a:	83 c3 01             	add    $0x1,%ebx
  6d:	44 39 eb             	cmp    %r13d,%ebx
  70:	7d bf                	jge    31 <wc+0x31>
      c++;
  72:	41 83 c4 01          	add    $0x1,%r12d
      if(buf[i] == '\n')
  76:	48 63 c3             	movslq %ebx,%rax
  79:	40 8a b0 80 0c 00 00 	mov    0xc80(%rax),%sil
  80:	40 0f be c6          	movsbl %sil,%eax
  84:	83 f8 0a             	cmp    $0xa,%eax
  87:	75 c8                	jne    51 <wc+0x51>
        l++;
  89:	41 83 c7 01          	add    $0x1,%r15d
  8d:	eb c2                	jmp    51 <wc+0x51>
      else if(!inword){
  8f:	45 85 f6             	test   %r14d,%r14d
  92:	75 d6                	jne    6a <wc+0x6a>
        w++;
  94:	83 45 cc 01          	addl   $0x1,-0x34(%rbp)
        inword = 1;
  98:	41 be 01 00 00 00    	mov    $0x1,%r14d
  9e:	eb ca                	jmp    6a <wc+0x6a>
      }
    }
  }
  if(n < 0){
  a0:	78 2d                	js     cf <wc+0xcf>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  a2:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  a6:	45 89 e0             	mov    %r12d,%r8d
  a9:	8b 4d cc             	mov    -0x34(%rbp),%ecx
  ac:	44 89 fa             	mov    %r15d,%edx
  af:	be 46 09 00 00       	mov    $0x946,%esi
  b4:	bf 01 00 00 00       	mov    $0x1,%edi
  b9:	b0 00                	mov    $0x0,%al
  bb:	e8 a5 04 00 00       	call   565 <printf>
}
  c0:	48 83 c4 18          	add    $0x18,%rsp
  c4:	5b                   	pop    %rbx
  c5:	41 5c                	pop    %r12
  c7:	41 5d                	pop    %r13
  c9:	41 5e                	pop    %r14
  cb:	41 5f                	pop    %r15
  cd:	5d                   	pop    %rbp
  ce:	c3                   	ret
    printf(1, "wc: read error\n");
  cf:	be 36 09 00 00       	mov    $0x936,%esi
  d4:	bf 01 00 00 00       	mov    $0x1,%edi
  d9:	b0 00                	mov    $0x0,%al
  db:	e8 85 04 00 00       	call   565 <printf>
    exit();
  e0:	e8 9d 02 00 00       	call   382 <exit>

00000000000000e5 <main>:

int
main(int argc, char *argv[])
{
  e5:	55                   	push   %rbp
  e6:	48 89 e5             	mov    %rsp,%rbp
  e9:	41 57                	push   %r15
  eb:	41 56                	push   %r14
  ed:	41 55                	push   %r13
  ef:	41 54                	push   %r12
  f1:	53                   	push   %rbx
  f2:	48 83 ec 08          	sub    $0x8,%rsp
  int fd, i;

  if(argc <= 1){
  f6:	83 ff 01             	cmp    $0x1,%edi
  f9:	7e 0e                	jle    109 <main+0x24>
  fb:	41 89 fe             	mov    %edi,%r14d
  fe:	49 89 f7             	mov    %rsi,%r15
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 101:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 107:	eb 2a                	jmp    133 <main+0x4e>
    wc(0, "");
 109:	be 45 09 00 00       	mov    $0x945,%esi
 10e:	bf 00 00 00 00       	mov    $0x0,%edi
 113:	e8 e8 fe ff ff       	call   0 <wc>
    exit();
 118:	e8 65 02 00 00       	call   382 <exit>
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 11d:	49 8b 75 00          	mov    0x0(%r13),%rsi
 121:	89 c7                	mov    %eax,%edi
 123:	e8 d8 fe ff ff       	call   0 <wc>
    close(fd);
 128:	89 df                	mov    %ebx,%edi
 12a:	e8 85 02 00 00       	call   3b4 <close>
  for(i = 1; i < argc; i++){
 12f:	41 83 c4 01          	add    $0x1,%r12d
 133:	45 39 f4             	cmp    %r14d,%r12d
 136:	7d 35                	jge    16d <main+0x88>
    if((fd = open(argv[i], 0)) < 0){
 138:	49 63 c4             	movslq %r12d,%rax
 13b:	4d 8d 2c c7          	lea    (%r15,%rax,8),%r13
 13f:	49 8b 7d 00          	mov    0x0(%r13),%rdi
 143:	be 00 00 00 00       	mov    $0x0,%esi
 148:	e8 85 02 00 00       	call   3d2 <open>
 14d:	89 c3                	mov    %eax,%ebx
 14f:	85 c0                	test   %eax,%eax
 151:	79 ca                	jns    11d <main+0x38>
      printf(1, "wc: cannot open %s\n", argv[i]);
 153:	49 8b 55 00          	mov    0x0(%r13),%rdx
 157:	be 53 09 00 00       	mov    $0x953,%esi
 15c:	bf 01 00 00 00       	mov    $0x1,%edi
 161:	b0 00                	mov    $0x0,%al
 163:	e8 fd 03 00 00       	call   565 <printf>
      exit();
 168:	e8 15 02 00 00       	call   382 <exit>
  }
  exit();
 16d:	e8 10 02 00 00       	call   382 <exit>
 172:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 179:	00 00 00 
 17c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000180 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 180:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 183:	48 89 f9             	mov    %rdi,%rcx
 186:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18d:	00 00 00 00 
 191:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 198:	00 00 00 00 
 19c:	0f 1f 40 00          	nopl   0x0(%rax)
 1a0:	48 89 f2             	mov    %rsi,%rdx
 1a3:	48 83 c6 01          	add    $0x1,%rsi
 1a7:	49 89 c8             	mov    %rcx,%r8
 1aa:	48 83 c1 01          	add    $0x1,%rcx
 1ae:	8a 12                	mov    (%rdx),%dl
 1b0:	41 88 10             	mov    %dl,(%r8)
 1b3:	0f be d2             	movsbl %dl,%edx
 1b6:	85 d2                	test   %edx,%edx
 1b8:	75 e6                	jne    1a0 <strcpy+0x20>
    ;
  return os;
}
 1ba:	c3                   	ret

00000000000001bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1bb:	eb 0b                	jmp    1c8 <strcmp+0xd>
 1bd:	0f 1f 00             	nopl   (%rax)
    p++, q++;
 1c0:	48 83 c7 01          	add    $0x1,%rdi
 1c4:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
 1c8:	8a 07                	mov    (%rdi),%al
 1ca:	0f be d0             	movsbl %al,%edx
 1cd:	85 d2                	test   %edx,%edx
 1cf:	74 07                	je     1d8 <strcmp+0x1d>
 1d1:	0f be 0e             	movsbl (%rsi),%ecx
 1d4:	39 ca                	cmp    %ecx,%edx
 1d6:	74 e8                	je     1c0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1d8:	0f b6 c0             	movzbl %al,%eax
 1db:	0f b6 16             	movzbl (%rsi),%edx
 1de:	29 d0                	sub    %edx,%eax
}
 1e0:	c3                   	ret

00000000000001e1 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 1e1:	b8 00 00 00 00       	mov    $0x0,%eax
 1e6:	eb 0b                	jmp    1f3 <strlen+0x12>
 1e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1ef:	00 
 1f0:	83 c0 01             	add    $0x1,%eax
 1f3:	48 63 d0             	movslq %eax,%rdx
 1f6:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
 1fa:	85 d2                	test   %edx,%edx
 1fc:	75 f2                	jne    1f0 <strlen+0xf>
    ;
  return n;
}
 1fe:	c3                   	ret

00000000000001ff <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ff:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
 202:	89 d1                	mov    %edx,%ecx
 204:	89 f0                	mov    %esi,%eax
 206:	fc                   	cld
 207:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 209:	4c 89 c0             	mov    %r8,%rax
 20c:	c3                   	ret

000000000000020d <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20d:	eb 15                	jmp    224 <strchr+0x17>
 20f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 216:	00 00 00 00 
 21a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 220:	48 83 c7 01          	add    $0x1,%rdi
 224:	8a 17                	mov    (%rdi),%dl
 226:	0f be c2             	movsbl %dl,%eax
 229:	85 c0                	test   %eax,%eax
 22b:	74 0f                	je     23c <strchr+0x2f>
    if(*s == c)
 22d:	0f be d2             	movsbl %dl,%edx
 230:	40 0f be c6          	movsbl %sil,%eax
 234:	39 c2                	cmp    %eax,%edx
 236:	75 e8                	jne    220 <strchr+0x13>
      return (char*)s;
 238:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
 23b:	c3                   	ret
  return 0;
 23c:	b8 00 00 00 00       	mov    $0x0,%eax
 241:	c3                   	ret

0000000000000242 <gets>:

char*
gets(char *buf, int max)
{
 242:	55                   	push   %rbp
 243:	48 89 e5             	mov    %rsp,%rbp
 246:	41 56                	push   %r14
 248:	41 55                	push   %r13
 24a:	41 54                	push   %r12
 24c:	53                   	push   %rbx
 24d:	48 83 ec 10          	sub    $0x10,%rsp
 251:	49 89 fc             	mov    %rdi,%r12
 254:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 257:	bb 00 00 00 00       	mov    $0x0,%ebx
 25c:	41 89 de             	mov    %ebx,%r14d
 25f:	83 c3 01             	add    $0x1,%ebx
 262:	44 39 eb             	cmp    %r13d,%ebx
 265:	7d 39                	jge    2a0 <gets+0x5e>
    cc = read(0, &c, 1);
 267:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 26b:	ba 01 00 00 00       	mov    $0x1,%edx
 270:	bf 00 00 00 00       	mov    $0x0,%edi
 275:	e8 26 01 00 00       	call   3a0 <read>
    if(cc < 1)
 27a:	85 c0                	test   %eax,%eax
 27c:	7e 22                	jle    2a0 <gets+0x5e>
      break;
    buf[i++] = c;
 27e:	4d 63 f6             	movslq %r14d,%r14
 281:	8a 45 df             	mov    -0x21(%rbp),%al
 284:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
 288:	0f be c0             	movsbl %al,%eax
 28b:	83 f8 0a             	cmp    $0xa,%eax
 28e:	0f 94 c2             	sete   %dl
 291:	83 f8 0d             	cmp    $0xd,%eax
 294:	0f 94 c0             	sete   %al
 297:	09 d0                	or     %edx,%eax
 299:	a8 ff                	test   $0xff,%al
 29b:	74 bf                	je     25c <gets+0x1a>
    buf[i++] = c;
 29d:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
 2a0:	4d 63 f6             	movslq %r14d,%r14
 2a3:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
 2a8:	4c 89 e0             	mov    %r12,%rax
 2ab:	48 83 c4 10          	add    $0x10,%rsp
 2af:	5b                   	pop    %rbx
 2b0:	41 5c                	pop    %r12
 2b2:	41 5d                	pop    %r13
 2b4:	41 5e                	pop    %r14
 2b6:	5d                   	pop    %rbp
 2b7:	c3                   	ret

00000000000002b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b8:	55                   	push   %rbp
 2b9:	48 89 e5             	mov    %rsp,%rbp
 2bc:	41 54                	push   %r12
 2be:	53                   	push   %rbx
 2bf:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c2:	be 00 00 00 00       	mov    $0x0,%esi
 2c7:	e8 06 01 00 00       	call   3d2 <open>
  if(fd < 0)
 2cc:	85 c0                	test   %eax,%eax
 2ce:	78 1e                	js     2ee <stat+0x36>
 2d0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2d2:	4c 89 e6             	mov    %r12,%rsi
 2d5:	89 c7                	mov    %eax,%edi
 2d7:	e8 14 01 00 00       	call   3f0 <fstat>
 2dc:	41 89 c4             	mov    %eax,%r12d
  close(fd);
 2df:	89 df                	mov    %ebx,%edi
 2e1:	e8 ce 00 00 00       	call   3b4 <close>
  return r;
}
 2e6:	44 89 e0             	mov    %r12d,%eax
 2e9:	5b                   	pop    %rbx
 2ea:	41 5c                	pop    %r12
 2ec:	5d                   	pop    %rbp
 2ed:	c3                   	ret
    return -1;
 2ee:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 2f4:	eb f0                	jmp    2e6 <stat+0x2e>

00000000000002f6 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
 2f6:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
 2fb:	eb 09                	jmp    306 <atoi+0x10>
 2fd:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
 300:	f7 de                	neg    %esi
    s++;
 302:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
 306:	0f be 07             	movsbl (%rdi),%eax
 309:	83 f8 2d             	cmp    $0x2d,%eax
 30c:	74 f2                	je     300 <atoi+0xa>
  n = 0;
 30e:	b8 00 00 00 00       	mov    $0x0,%eax
 313:	eb 19                	jmp    32e <atoi+0x38>
 315:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 31c:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 320:	8d 04 80             	lea    (%rax,%rax,4),%eax
 323:	48 83 c7 01          	add    $0x1,%rdi
 327:	0f be d2             	movsbl %dl,%edx
 32a:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
 32e:	8a 17                	mov    (%rdi),%dl
 330:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 333:	0f b6 c9             	movzbl %cl,%ecx
 336:	83 f9 09             	cmp    $0x9,%ecx
 339:	76 e5                	jbe    320 <atoi+0x2a>
  return sign * n;
 33b:	0f af c6             	imul   %esi,%eax
}
 33e:	c3                   	ret

000000000000033f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 33f:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
 342:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
 345:	eb 28                	jmp    36f <memmove+0x30>
 347:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 34e:	00 00 00 00 
 352:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 359:	00 00 00 00 
 35d:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
 360:	8a 16                	mov    (%rsi),%dl
 362:	88 11                	mov    %dl,(%rcx)
 364:	48 8d 76 01          	lea    0x1(%rsi),%rsi
 368:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
 36c:	44 89 c2             	mov    %r8d,%edx
 36f:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
 373:	85 d2                	test   %edx,%edx
 375:	7f e9                	jg     360 <memmove+0x21>
  return vdst;
}
 377:	c3                   	ret

0000000000000378 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 378:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret

0000000000000382 <exit>:
SYSCALL(exit)
 382:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret

000000000000038c <wait>:
SYSCALL(wait)
 38c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret

0000000000000396 <pipe>:
SYSCALL(pipe)
 396:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret

00000000000003a0 <read>:
SYSCALL(read)
 3a0:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret

00000000000003aa <write>:
SYSCALL(write)
 3aa:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret

00000000000003b4 <close>:
SYSCALL(close)
 3b4:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret

00000000000003be <kill>:
SYSCALL(kill)
 3be:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret

00000000000003c8 <exec>:
SYSCALL(exec)
 3c8:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret

00000000000003d2 <open>:
SYSCALL(open)
 3d2:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret

00000000000003dc <mknod>:
SYSCALL(mknod)
 3dc:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret

00000000000003e6 <unlink>:
SYSCALL(unlink)
 3e6:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret

00000000000003f0 <fstat>:
SYSCALL(fstat)
 3f0:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret

00000000000003fa <link>:
SYSCALL(link)
 3fa:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret

0000000000000404 <mkdir>:
SYSCALL(mkdir)
 404:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret

000000000000040e <chdir>:
SYSCALL(chdir)
 40e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret

0000000000000418 <dup>:
SYSCALL(dup)
 418:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret

0000000000000422 <getpid>:
SYSCALL(getpid)
 422:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret

000000000000042c <sbrk>:
SYSCALL(sbrk)
 42c:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret

0000000000000436 <sleep>:
SYSCALL(sleep)
 436:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret

0000000000000440 <uptime>:
SYSCALL(uptime)
 440:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret

000000000000044a <vmcreate>:
SYSCALL(vmcreate)
 44a:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret

0000000000000454 <vmsetreg>:
SYSCALL(vmsetreg)
 454:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret

000000000000045e <vmrun>:
SYSCALL(vmrun)
 45e:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret

0000000000000468 <vmgetreg>:
SYSCALL(vmgetreg)
 468:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret
 472:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 479:	00 00 00 
 47c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000480 <_va_arg>:
// Retrieve the next argument from the va_list.
static inline void *_va_arg(va_list *args)
{
    // Returns the next argument from registers if _index < 6, 
    // otherwise from the stack.
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 480:	8b 47 38             	mov    0x38(%rdi),%eax
 483:	83 f8 05             	cmp    $0x5,%eax
 486:	77 0d                	ja     495 <_va_arg+0x15>
 488:	8d 50 01             	lea    0x1(%rax),%edx
 48b:	89 57 38             	mov    %edx,0x38(%rdi)
 48e:	89 c0                	mov    %eax,%eax
 490:	48 8b 04 c7          	mov    (%rdi,%rax,8),%rax
 494:	c3                   	ret
                                  : args->more_argint[(args->_index++)-6]);
 495:	8d 50 01             	lea    0x1(%rax),%edx
 498:	89 57 38             	mov    %edx,0x38(%rdi)
 49b:	8d 40 fa             	lea    -0x6(%rax),%eax
 49e:	48 c1 e0 03          	shl    $0x3,%rax
 4a2:	48 03 47 30          	add    0x30(%rdi),%rax
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
 4a6:	48 8b 00             	mov    (%rax),%rax
}
 4a9:	c3                   	ret

00000000000004aa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4aa:	55                   	push   %rbp
 4ab:	48 89 e5             	mov    %rsp,%rbp
 4ae:	48 83 ec 10          	sub    $0x10,%rsp
 4b2:	40 88 75 fc          	mov    %sil,-0x4(%rbp)
  write(fd, &c, 1);
 4b6:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
 4ba:	ba 01 00 00 00       	mov    $0x1,%edx
 4bf:	e8 e6 fe ff ff       	call   3aa <write>
}
 4c4:	48 89 ec             	mov    %rbp,%rsp
 4c7:	5d                   	pop    %rbp
 4c8:	c3                   	ret

00000000000004c9 <printint>:

static void
printint(int fd, int64 xx, int base, int sgn)
{
 4c9:	55                   	push   %rbp
 4ca:	48 89 e5             	mov    %rsp,%rbp
 4cd:	41 54                	push   %r12
 4cf:	53                   	push   %rbx
 4d0:	48 83 ec 10          	sub    $0x10,%rsp
 4d4:	41 89 fc             	mov    %edi,%r12d
 4d7:	41 89 d1             	mov    %edx,%r9d
  char buf[16];
  int i, neg;
  uint64 x;

  neg = 0;
  if(sgn && xx < 0){
 4da:	85 c9                	test   %ecx,%ecx
 4dc:	0f 95 c2             	setne  %dl
 4df:	48 89 f0             	mov    %rsi,%rax
 4e2:	48 c1 e8 3f          	shr    $0x3f,%rax
 4e6:	85 c2                	test   %eax,%edx
 4e8:	74 55                	je     53f <printint+0x76>
    neg = 1;
    x = -xx;
 4ea:	48 f7 de             	neg    %rsi
    neg = 1;
 4ed:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  } else {
    x = xx;
  }

  i = 0;
 4f3:	bb 00 00 00 00       	mov    $0x0,%ebx
 4f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 4ff:	00 
  do{
    buf[i++] = digits[x % base];
 500:	49 63 c9             	movslq %r9d,%rcx
 503:	48 89 f0             	mov    %rsi,%rax
 506:	ba 00 00 00 00       	mov    $0x0,%edx
 50b:	48 f7 f1             	div    %rcx
 50e:	89 df                	mov    %ebx,%edi
 510:	83 c3 01             	add    $0x1,%ebx
 513:	44 8a 82 20 0a 00 00 	mov    0xa20(%rdx),%r8b
 51a:	48 63 d7             	movslq %edi,%rdx
 51d:	44 88 44 15 e0       	mov    %r8b,-0x20(%rbp,%rdx,1)
  }while((x /= base) != 0);
 522:	48 89 f2             	mov    %rsi,%rdx
 525:	48 89 c6             	mov    %rax,%rsi
 528:	48 39 ca             	cmp    %rcx,%rdx
 52b:	73 d3                	jae    500 <printint+0x37>
  if(neg)
 52d:	45 85 d2             	test   %r10d,%r10d
 530:	74 25                	je     557 <printint+0x8e>
    buf[i++] = '-';
 532:	48 63 db             	movslq %ebx,%rbx
 535:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 53a:	8d 5f 02             	lea    0x2(%rdi),%ebx
 53d:	eb 18                	jmp    557 <printint+0x8e>
  neg = 0;
 53f:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 545:	eb ac                	jmp    4f3 <printint+0x2a>

  while(--i >= 0)
    putc(fd, buf[i]);
 547:	48 63 c3             	movslq %ebx,%rax
 54a:	0f be 74 05 e0       	movsbl -0x20(%rbp,%rax,1),%esi
 54f:	44 89 e7             	mov    %r12d,%edi
 552:	e8 53 ff ff ff       	call   4aa <putc>
  while(--i >= 0)
 557:	83 eb 01             	sub    $0x1,%ebx
 55a:	79 eb                	jns    547 <printint+0x7e>
}
 55c:	48 83 c4 10          	add    $0x10,%rsp
 560:	5b                   	pop    %rbx
 561:	41 5c                	pop    %r12
 563:	5d                   	pop    %rbp
 564:	c3                   	ret

0000000000000565 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 565:	55                   	push   %rbp
 566:	48 89 e5             	mov    %rsp,%rbp
 569:	41 57                	push   %r15
 56b:	41 56                	push   %r14
 56d:	41 55                	push   %r13
 56f:	41 54                	push   %r12
 571:	53                   	push   %rbx
 572:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
 579:	41 89 ff             	mov    %edi,%r15d
 57c:	49 89 f5             	mov    %rsi,%r13
 57f:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
 586:	48 89 8d 38 ff ff ff 	mov    %rcx,-0xc8(%rbp)
 58d:	4c 89 85 40 ff ff ff 	mov    %r8,-0xc0(%rbp)
 594:	4c 89 8d 48 ff ff ff 	mov    %r9,-0xb8(%rbp)
 59b:	84 c0                	test   %al,%al
 59d:	74 29                	je     5c8 <printf+0x63>
 59f:	0f 29 85 50 ff ff ff 	movaps %xmm0,-0xb0(%rbp)
 5a6:	0f 29 8d 60 ff ff ff 	movaps %xmm1,-0xa0(%rbp)
 5ad:	0f 29 95 70 ff ff ff 	movaps %xmm2,-0x90(%rbp)
 5b4:	0f 29 5d 80          	movaps %xmm3,-0x80(%rbp)
 5b8:	0f 29 65 90          	movaps %xmm4,-0x70(%rbp)
 5bc:	0f 29 6d a0          	movaps %xmm5,-0x60(%rbp)
 5c0:	0f 29 75 b0          	movaps %xmm6,-0x50(%rbp)
 5c4:	0f 29 7d c0          	movaps %xmm7,-0x40(%rbp)
    asm volatile("movq %%rdi, %0;" 
 5c8:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
 5cf:	48 89 b5 e8 fe ff ff 	mov    %rsi,-0x118(%rbp)
 5d6:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
 5dd:	48 89 8d f8 fe ff ff 	mov    %rcx,-0x108(%rbp)
 5e4:	4c 89 85 00 ff ff ff 	mov    %r8,-0x100(%rbp)
 5eb:	4c 89 8d 08 ff ff ff 	mov    %r9,-0xf8(%rbp)
    asm volatile("leaq 16(%%rbp), %0" : "=r" (args->more_argint));
 5f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
 5f6:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
    args->_index = 1;
 5fd:	c7 85 18 ff ff ff 01 	movl   $0x1,-0xe8(%rbp)
 604:	00 00 00 
  char *s;
  int c, i, state;
  va_list ap;

  va_start(ap, fd);
  (void) va_arg(ap, char*); // skip fmt
 607:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 60e:	e8 6d fe ff ff       	call   480 <_va_arg>

  state = 0;
 613:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(i = 0; fmt[i]; i++){
 619:	bb 00 00 00 00       	mov    $0x0,%ebx
 61e:	eb 16                	jmp    636 <printf+0xd1>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 620:	44 89 f6             	mov    %r14d,%esi
 623:	44 89 ff             	mov    %r15d,%edi
 626:	e8 7f fe ff ff       	call   4aa <putc>
 62b:	eb 06                	jmp    633 <printf+0xce>
      }
    } else if(state == '%'){
 62d:	41 83 fc 25          	cmp    $0x25,%r12d
 631:	74 2c                	je     65f <printf+0xfa>
  for(i = 0; fmt[i]; i++){
 633:	83 c3 01             	add    $0x1,%ebx
 636:	48 63 c3             	movslq %ebx,%rax
 639:	41 8a 44 05 00       	mov    0x0(%r13,%rax,1),%al
 63e:	0f be d0             	movsbl %al,%edx
 641:	85 d2                	test   %edx,%edx
 643:	0f 84 42 01 00 00    	je     78b <printf+0x226>
    c = fmt[i] & 0xff;
 649:	44 0f be f0          	movsbl %al,%r14d
 64d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 650:	45 85 e4             	test   %r12d,%r12d
 653:	75 d8                	jne    62d <printf+0xc8>
      if(c == '%'){
 655:	83 f8 25             	cmp    $0x25,%eax
 658:	75 c6                	jne    620 <printf+0xbb>
        state = '%';
 65a:	41 89 c4             	mov    %eax,%r12d
 65d:	eb d4                	jmp    633 <printf+0xce>
      if(c == 'd'){
 65f:	83 f8 25             	cmp    $0x25,%eax
 662:	0f 84 ea 00 00 00    	je     752 <printf+0x1ed>
 668:	0f 8c fa 00 00 00    	jl     768 <printf+0x203>
 66e:	83 f8 78             	cmp    $0x78,%eax
 671:	0f 8f f1 00 00 00    	jg     768 <printf+0x203>
 677:	83 f8 63             	cmp    $0x63,%eax
 67a:	0f 8c e8 00 00 00    	jl     768 <printf+0x203>
 680:	83 e8 63             	sub    $0x63,%eax
 683:	83 f8 15             	cmp    $0x15,%eax
 686:	0f 87 dc 00 00 00    	ja     768 <printf+0x203>
 68c:	89 c0                	mov    %eax,%eax
 68e:	ff 24 c5 70 09 00 00 	jmp    *0x970(,%rax,8)
        printint(fd, va_arg(ap, int), 10, 1);
 695:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 69c:	e8 df fd ff ff       	call   480 <_va_arg>
 6a1:	48 63 f0             	movslq %eax,%rsi
 6a4:	b9 01 00 00 00       	mov    $0x1,%ecx
 6a9:	ba 0a 00 00 00       	mov    $0xa,%edx
 6ae:	44 89 ff             	mov    %r15d,%edi
 6b1:	e8 13 fe ff ff       	call   4c9 <printint>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6b6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 6bc:	e9 72 ff ff ff       	jmp    633 <printf+0xce>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c1:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 6c8:	e8 b3 fd ff ff       	call   480 <_va_arg>
 6cd:	48 89 c6             	mov    %rax,%rsi
 6d0:	b9 00 00 00 00       	mov    $0x0,%ecx
 6d5:	ba 10 00 00 00       	mov    $0x10,%edx
 6da:	44 89 ff             	mov    %r15d,%edi
 6dd:	e8 e7 fd ff ff       	call   4c9 <printint>
      state = 0;
 6e2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 6e8:	e9 46 ff ff ff       	jmp    633 <printf+0xce>
        s = va_arg(ap, char*);
 6ed:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 6f4:	e8 87 fd ff ff       	call   480 <_va_arg>
 6f9:	49 89 c4             	mov    %rax,%r12
        if(s == 0)
 6fc:	48 85 c0             	test   %rax,%rax
 6ff:	75 18                	jne    719 <printf+0x1b4>
          s = "(null)";
 701:	41 bc 67 09 00 00    	mov    $0x967,%r12d
 707:	eb 10                	jmp    719 <printf+0x1b4>
          putc(fd, *s);
 709:	40 0f be f6          	movsbl %sil,%esi
 70d:	44 89 ff             	mov    %r15d,%edi
 710:	e8 95 fd ff ff       	call   4aa <putc>
          s++;
 715:	49 83 c4 01          	add    $0x1,%r12
        while(*s != 0){
 719:	41 8a 34 24          	mov    (%r12),%sil
 71d:	40 0f be c6          	movsbl %sil,%eax
 721:	85 c0                	test   %eax,%eax
 723:	75 e4                	jne    709 <printf+0x1a4>
      state = 0;
 725:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 72b:	e9 03 ff ff ff       	jmp    633 <printf+0xce>
        putc(fd, va_arg(ap, char));
 730:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
 737:	e8 44 fd ff ff       	call   480 <_va_arg>
 73c:	0f be f0             	movsbl %al,%esi
 73f:	44 89 ff             	mov    %r15d,%edi
 742:	e8 63 fd ff ff       	call   4aa <putc>
      state = 0;
 747:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 74d:	e9 e1 fe ff ff       	jmp    633 <printf+0xce>
        putc(fd, c);
 752:	44 89 f6             	mov    %r14d,%esi
 755:	44 89 ff             	mov    %r15d,%edi
 758:	e8 4d fd ff ff       	call   4aa <putc>
      state = 0;
 75d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 763:	e9 cb fe ff ff       	jmp    633 <printf+0xce>
        putc(fd, '%');
 768:	be 25 00 00 00       	mov    $0x25,%esi
 76d:	44 89 ff             	mov    %r15d,%edi
 770:	e8 35 fd ff ff       	call   4aa <putc>
        putc(fd, c);
 775:	44 89 f6             	mov    %r14d,%esi
 778:	44 89 ff             	mov    %r15d,%edi
 77b:	e8 2a fd ff ff       	call   4aa <putc>
      state = 0;
 780:	41 bc 00 00 00 00    	mov    $0x0,%r12d
 786:	e9 a8 fe ff ff       	jmp    633 <printf+0xce>
    }
  }
}
 78b:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
 792:	5b                   	pop    %rbx
 793:	41 5c                	pop    %r12
 795:	41 5d                	pop    %r13
 797:	41 5e                	pop    %r14
 799:	41 5f                	pop    %r15
 79b:	5d                   	pop    %rbp
 79c:	c3                   	ret
 79d:	0f 1f 00             	nopl   (%rax)

00000000000007a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a0:	48 89 fe             	mov    %rdi,%rsi
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a3:	48 8d 4f f0          	lea    -0x10(%rdi),%rcx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a7:	48 8b 05 d2 06 00 00 	mov    0x6d2(%rip),%rax        # e80 <freep>
 7ae:	eb 03                	jmp    7b3 <free+0x13>
 7b0:	48 89 d0             	mov    %rdx,%rax
 7b3:	48 39 c8             	cmp    %rcx,%rax
 7b6:	73 05                	jae    7bd <free+0x1d>
 7b8:	48 3b 08             	cmp    (%rax),%rcx
 7bb:	72 17                	jb     7d4 <free+0x34>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bd:	48 8b 10             	mov    (%rax),%rdx
 7c0:	48 39 d0             	cmp    %rdx,%rax
 7c3:	72 eb                	jb     7b0 <free+0x10>
 7c5:	48 39 c8             	cmp    %rcx,%rax
 7c8:	72 0a                	jb     7d4 <free+0x34>
 7ca:	48 39 d1             	cmp    %rdx,%rcx
 7cd:	72 05                	jb     7d4 <free+0x34>
 7cf:	48 89 d0             	mov    %rdx,%rax
 7d2:	eb df                	jmp    7b3 <free+0x13>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d4:	44 8b 46 f8          	mov    -0x8(%rsi),%r8d
 7d8:	44 89 c2             	mov    %r8d,%edx
 7db:	48 c1 e2 04          	shl    $0x4,%rdx
 7df:	48 01 ca             	add    %rcx,%rdx
 7e2:	48 8b 38             	mov    (%rax),%rdi
 7e5:	48 39 fa             	cmp    %rdi,%rdx
 7e8:	74 20                	je     80a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7ea:	48 89 7e f0          	mov    %rdi,-0x10(%rsi)
  if(p + p->s.size == bp){
 7ee:	8b 78 08             	mov    0x8(%rax),%edi
 7f1:	89 fa                	mov    %edi,%edx
 7f3:	48 c1 e2 04          	shl    $0x4,%rdx
 7f7:	48 01 c2             	add    %rax,%rdx
 7fa:	48 39 ca             	cmp    %rcx,%rdx
 7fd:	74 1f                	je     81e <free+0x7e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7ff:	48 89 08             	mov    %rcx,(%rax)
  freep = p;
 802:	48 89 05 77 06 00 00 	mov    %rax,0x677(%rip)        # e80 <freep>
}
 809:	c3                   	ret
    bp->s.size += p->s.ptr->s.size;
 80a:	44 03 47 08          	add    0x8(%rdi),%r8d
 80e:	44 89 46 f8          	mov    %r8d,-0x8(%rsi)
    bp->s.ptr = p->s.ptr->s.ptr;
 812:	48 8b 10             	mov    (%rax),%rdx
 815:	48 8b 12             	mov    (%rdx),%rdx
 818:	48 89 56 f0          	mov    %rdx,-0x10(%rsi)
 81c:	eb d0                	jmp    7ee <free+0x4e>
    p->s.size += bp->s.size;
 81e:	03 7e f8             	add    -0x8(%rsi),%edi
 821:	89 78 08             	mov    %edi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 824:	48 8b 56 f0          	mov    -0x10(%rsi),%rdx
 828:	48 89 10             	mov    %rdx,(%rax)
 82b:	eb d5                	jmp    802 <free+0x62>

000000000000082d <morecore>:

static Header*
morecore(uint nu)
{
 82d:	55                   	push   %rbp
 82e:	48 89 e5             	mov    %rsp,%rbp
 831:	53                   	push   %rbx
 832:	48 83 ec 08          	sub    $0x8,%rsp
 836:	89 fb                	mov    %edi,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 838:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 83e:	77 05                	ja     845 <morecore+0x18>
    nu = 4096;
 840:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 845:	89 df                	mov    %ebx,%edi
 847:	c1 e7 04             	shl    $0x4,%edi
 84a:	e8 dd fb ff ff       	call   42c <sbrk>
  if(p == (char*)-1)
 84f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 853:	74 1a                	je     86f <morecore+0x42>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 855:	89 58 08             	mov    %ebx,0x8(%rax)
  free((void*)(hp + 1));
 858:	48 8d 78 10          	lea    0x10(%rax),%rdi
 85c:	e8 3f ff ff ff       	call   7a0 <free>
  return freep;
 861:	48 8b 05 18 06 00 00 	mov    0x618(%rip),%rax        # e80 <freep>
}
 868:	48 83 c4 08          	add    $0x8,%rsp
 86c:	5b                   	pop    %rbx
 86d:	5d                   	pop    %rbp
 86e:	c3                   	ret
    return 0;
 86f:	b8 00 00 00 00       	mov    $0x0,%eax
 874:	eb f2                	jmp    868 <morecore+0x3b>

0000000000000876 <malloc>:

void*
malloc(uint nbytes)
{
 876:	55                   	push   %rbp
 877:	48 89 e5             	mov    %rsp,%rbp
 87a:	53                   	push   %rbx
 87b:	48 83 ec 08          	sub    $0x8,%rsp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87f:	89 fb                	mov    %edi,%ebx
 881:	48 83 c3 0f          	add    $0xf,%rbx
 885:	48 c1 eb 04          	shr    $0x4,%rbx
 889:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 88c:	48 8b 0d ed 05 00 00 	mov    0x5ed(%rip),%rcx        # e80 <freep>
 893:	48 85 c9             	test   %rcx,%rcx
 896:	74 05                	je     89d <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	48 8b 01             	mov    (%rcx),%rax
 89b:	eb 69                	jmp    906 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
 89d:	48 c7 05 d8 05 00 00 	movq   $0xe90,0x5d8(%rip)        # e80 <freep>
 8a4:	90 0e 00 00 
 8a8:	48 c7 05 dd 05 00 00 	movq   $0xe90,0x5dd(%rip)        # e90 <base>
 8af:	90 0e 00 00 
    base.s.size = 0;
 8b3:	c7 05 db 05 00 00 00 	movl   $0x0,0x5db(%rip)        # e98 <base+0x8>
 8ba:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 8bd:	b9 90 0e 00 00       	mov    $0xe90,%ecx
 8c2:	eb d4                	jmp    898 <malloc+0x22>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 8c4:	74 23                	je     8e9 <malloc+0x73>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 8c6:	29 da                	sub    %ebx,%edx
 8c8:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 8cb:	89 d2                	mov    %edx,%edx
 8cd:	48 c1 e2 04          	shl    $0x4,%rdx
 8d1:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 8d4:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 8d7:	48 89 0d a2 05 00 00 	mov    %rcx,0x5a2(%rip)        # e80 <freep>
      return (void*)(p + 1);
 8de:	48 83 c0 10          	add    $0x10,%rax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8e2:	48 83 c4 08          	add    $0x8,%rsp
 8e6:	5b                   	pop    %rbx
 8e7:	5d                   	pop    %rbp
 8e8:	c3                   	ret
        prevp->s.ptr = p->s.ptr;
 8e9:	48 8b 10             	mov    (%rax),%rdx
 8ec:	48 89 11             	mov    %rdx,(%rcx)
 8ef:	eb e6                	jmp    8d7 <malloc+0x61>
 8f1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 8f8:	00 00 00 00 
 8fc:	0f 1f 40 00          	nopl   0x0(%rax)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 900:	48 89 c1             	mov    %rax,%rcx
 903:	48 8b 00             	mov    (%rax),%rax
    if(p->s.size >= nunits){
 906:	8b 50 08             	mov    0x8(%rax),%edx
 909:	39 da                	cmp    %ebx,%edx
 90b:	73 b7                	jae    8c4 <malloc+0x4e>
    if(p == freep)
 90d:	48 39 05 6c 05 00 00 	cmp    %rax,0x56c(%rip)        # e80 <freep>
 914:	75 ea                	jne    900 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
 916:	89 df                	mov    %ebx,%edi
 918:	e8 10 ff ff ff       	call   82d <morecore>
 91d:	48 85 c0             	test   %rax,%rax
 920:	75 de                	jne    900 <malloc+0x8a>
 922:	eb be                	jmp    8e2 <malloc+0x6c>
