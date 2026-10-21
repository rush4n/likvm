
_grep:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	41 55                	push   %r13
   6:	41 54                	push   %r12
   8:	53                   	push   %rbx
   9:	48 83 ec 08          	sub    $0x8,%rsp
   d:	41 89 fc             	mov    %edi,%r12d
  10:	49 89 f5             	mov    %rsi,%r13
  13:	48 89 d3             	mov    %rdx,%rbx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  16:	48 89 de             	mov    %rbx,%rsi
  19:	4c 89 ef             	mov    %r13,%rdi
  1c:	e8 2e 00 00 00       	call   4f <matchhere>
  21:	85 c0                	test   %eax,%eax
  23:	75 1a                	jne    3f <matchstar+0x3f>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  25:	8a 13                	mov    (%rbx),%dl
  27:	0f be ca             	movsbl %dl,%ecx
  2a:	85 c9                	test   %ecx,%ecx
  2c:	74 16                	je     44 <matchstar+0x44>
  2e:	48 83 c3 01          	add    $0x1,%rbx
  32:	44 39 e1             	cmp    %r12d,%ecx
  35:	74 df                	je     16 <matchstar+0x16>
  37:	41 83 fc 2e          	cmp    $0x2e,%r12d
  3b:	74 d9                	je     16 <matchstar+0x16>
  3d:	eb 05                	jmp    44 <matchstar+0x44>
      return 1;
  3f:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
  44:	48 83 c4 08          	add    $0x8,%rsp
  48:	5b                   	pop    %rbx
  49:	41 5c                	pop    %r12
  4b:	41 5d                	pop    %r13
  4d:	5d                   	pop    %rbp
  4e:	c3                   	ret

000000000000004f <matchhere>:
  if(re[0] == '\0')
  4f:	8a 17                	mov    (%rdi),%dl
  51:	0f be ca             	movsbl %dl,%ecx
  54:	85 c9                	test   %ecx,%ecx
  56:	74 70                	je     c8 <matchhere+0x79>
{
  58:	55                   	push   %rbp
  59:	48 89 e5             	mov    %rsp,%rbp
  5c:	48 89 f8             	mov    %rdi,%rax
  if(re[1] == '*')
  5f:	8a 4f 01             	mov    0x1(%rdi),%cl
  62:	0f be f9             	movsbl %cl,%edi
  65:	83 ff 2a             	cmp    $0x2a,%edi
  68:	74 27                	je     91 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	0f be fa             	movsbl %dl,%edi
  6d:	83 ff 24             	cmp    $0x24,%edi
  70:	74 33                	je     a5 <matchhere+0x56>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	8a 0e                	mov    (%rsi),%cl
  74:	0f be f9             	movsbl %cl,%edi
  77:	85 ff                	test   %edi,%edi
  79:	74 53                	je     ce <matchhere+0x7f>
  7b:	0f be fa             	movsbl %dl,%edi
  7e:	83 ff 2e             	cmp    $0x2e,%edi
  81:	74 36                	je     b9 <matchhere+0x6a>
  83:	0f be c9             	movsbl %cl,%ecx
  86:	39 cf                	cmp    %ecx,%edi
  88:	74 2f                	je     b9 <matchhere+0x6a>
  return 0;
  8a:	b8 00 00 00 00       	mov    $0x0,%eax
  8f:	eb 42                	jmp    d3 <matchhere+0x84>
    return matchstar(re[0], re+2, text);
  91:	48 83 c0 02          	add    $0x2,%rax
  95:	0f be fa             	movsbl %dl,%edi
  98:	48 89 f2             	mov    %rsi,%rdx
  9b:	48 89 c6             	mov    %rax,%rsi
  9e:	e8 5d ff ff ff       	call   0 <matchstar>
  a3:	eb 2e                	jmp    d3 <matchhere+0x84>
  if(re[0] == '$' && re[1] == '\0')
  a5:	0f be c9             	movsbl %cl,%ecx
  a8:	85 c9                	test   %ecx,%ecx
  aa:	75 c6                	jne    72 <matchhere+0x23>
    return *text == '\0';
  ac:	0f be 06             	movsbl (%rsi),%eax
  af:	85 c0                	test   %eax,%eax
  b1:	0f 94 c0             	sete   %al
  b4:	0f b6 c0             	movzbl %al,%eax
  b7:	eb 1a                	jmp    d3 <matchhere+0x84>
    return matchhere(re+1, text+1);
  b9:	48 83 c6 01          	add    $0x1,%rsi
  bd:	48 8d 78 01          	lea    0x1(%rax),%rdi
  c1:	e8 89 ff ff ff       	call   4f <matchhere>
  c6:	eb 0b                	jmp    d3 <matchhere+0x84>
    return 1;
  c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  cd:	c3                   	ret
  return 0;
  ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  d3:	5d                   	pop    %rbp
  d4:	c3                   	ret

00000000000000d5 <match>:
{
  d5:	55                   	push   %rbp
  d6:	48 89 e5             	mov    %rsp,%rbp
  d9:	41 54                	push   %r12
  db:	53                   	push   %rbx
  dc:	49 89 fc             	mov    %rdi,%r12
  df:	48 89 f3             	mov    %rsi,%rbx
  if(re[0] == '^')
  e2:	0f be 07             	movsbl (%rdi),%eax
  e5:	83 f8 5e             	cmp    $0x5e,%eax
  e8:	75 0e                	jne    f8 <match+0x23>
    return matchhere(re+1, text);
  ea:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
  ee:	e8 5c ff ff ff       	call   4f <matchhere>
  f3:	eb 24                	jmp    119 <match+0x44>
  }while(*text++ != '\0');
  f5:	48 89 cb             	mov    %rcx,%rbx
    if(matchhere(re, text))
  f8:	48 89 de             	mov    %rbx,%rsi
  fb:	4c 89 e7             	mov    %r12,%rdi
  fe:	e8 4c ff ff ff       	call   4f <matchhere>
 103:	85 c0                	test   %eax,%eax
 105:	75 0d                	jne    114 <match+0x3f>
  }while(*text++ != '\0');
 107:	48 8d 4b 01          	lea    0x1(%rbx),%rcx
 10b:	0f be 13             	movsbl (%rbx),%edx
 10e:	85 d2                	test   %edx,%edx
 110:	75 e3                	jne    f5 <match+0x20>
 112:	eb 05                	jmp    119 <match+0x44>
      return 1;
 114:	b8 01 00 00 00       	mov    $0x1,%eax
}
 119:	5b                   	pop    %rbx
 11a:	41 5c                	pop    %r12
 11c:	5d                   	pop    %rbp
 11d:	c3                   	ret

000000000000011e <grep>:
{
 11e:	55                   	push   %rbp
 11f:	48 89 e5             	mov    %rsp,%rbp
 122:	41 57                	push   %r15
 124:	41 56                	push   %r14
 126:	41 55                	push   %r13
 128:	41 54                	push   %r12
 12a:	53                   	push   %rbx
 12b:	48 83 ec 08          	sub    $0x8,%rsp
 12f:	49 89 fd             	mov    %rdi,%r13
 132:	41 89 f7             	mov    %esi,%r15d
  m = 0;
 135:	41 be 00 00 00 00    	mov    $0x0,%r14d
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13b:	eb 52                	jmp    18f <grep+0x71>
      p = q+1;
 13d:	4c 8d 63 01          	lea    0x1(%rbx),%r12
    while((q = strchr(p, '\n')) != 0){
 141:	be 0a 00 00 00       	mov    $0xa,%esi
 146:	4c 89 e7             	mov    %r12,%rdi
 149:	e8 ff 01 00 00       	call   34d <strchr>
 14e:	48 89 c3             	mov    %rax,%rbx
 151:	48 85 c0             	test   %rax,%rax
 154:	74 2b                	je     181 <grep+0x63>
      *q = 0;
 156:	c6 03 00             	movb   $0x0,(%rbx)
      if(match(pattern, p)){
 159:	4c 89 e6             	mov    %r12,%rsi
 15c:	4c 89 ef             	mov    %r13,%rdi
 15f:	e8 71 ff ff ff       	call   d5 <match>
 164:	85 c0                	test   %eax,%eax
 166:	74 d5                	je     13d <grep+0x1f>
        *q = '\n';
 168:	c6 03 0a             	movb   $0xa,(%rbx)
        write(1, p, q+1 - p);
 16b:	48 8d 53 01          	lea    0x1(%rbx),%rdx
 16f:	44 29 e2             	sub    %r12d,%edx
 172:	4c 89 e6             	mov    %r12,%rsi
 175:	bf 01 00 00 00       	mov    $0x1,%edi
 17a:	e8 6b 03 00 00       	call   4ea <write>
 17f:	eb bc                	jmp    13d <grep+0x1f>
    if(p == buf)
 181:	49 81 fc 20 0e 00 00 	cmp    $0xe20,%r12
 188:	74 3b                	je     1c5 <grep+0xa7>
    if(m > 0){
 18a:	45 85 f6             	test   %r14d,%r14d
 18d:	7f 3e                	jg     1cd <grep+0xaf>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18f:	ba ff 03 00 00       	mov    $0x3ff,%edx
 194:	44 29 f2             	sub    %r14d,%edx
 197:	49 63 f6             	movslq %r14d,%rsi
 19a:	48 81 c6 20 0e 00 00 	add    $0xe20,%rsi
 1a1:	44 89 ff             	mov    %r15d,%edi
 1a4:	e8 37 03 00 00       	call   4e0 <read>
 1a9:	85 c0                	test   %eax,%eax
 1ab:	7e 40                	jle    1ed <grep+0xcf>
    m += n;
 1ad:	41 01 c6             	add    %eax,%r14d
    buf[m] = '\0';
 1b0:	49 63 c6             	movslq %r14d,%rax
 1b3:	c6 80 20 0e 00 00 00 	movb   $0x0,0xe20(%rax)
    p = buf;
 1ba:	41 bc 20 0e 00 00    	mov    $0xe20,%r12d
    while((q = strchr(p, '\n')) != 0){
 1c0:	e9 7c ff ff ff       	jmp    141 <grep+0x23>
      m = 0;
 1c5:	41 be 00 00 00 00    	mov    $0x0,%r14d
 1cb:	eb bd                	jmp    18a <grep+0x6c>
      m -= p - buf;
 1cd:	4c 89 e0             	mov    %r12,%rax
 1d0:	48 2d 20 0e 00 00    	sub    $0xe20,%rax
 1d6:	44 89 f2             	mov    %r14d,%edx
 1d9:	29 c2                	sub    %eax,%edx
 1db:	41 89 d6             	mov    %edx,%r14d
      memmove(buf, p, m);
 1de:	4c 89 e6             	mov    %r12,%rsi
 1e1:	bf 20 0e 00 00       	mov    $0xe20,%edi
 1e6:	e8 94 02 00 00       	call   47f <memmove>
 1eb:	eb a2                	jmp    18f <grep+0x71>
}
 1ed:	48 83 c4 08          	add    $0x8,%rsp
 1f1:	5b                   	pop    %rbx
 1f2:	41 5c                	pop    %r12
 1f4:	41 5d                	pop    %r13
 1f6:	41 5e                	pop    %r14
 1f8:	41 5f                	pop    %r15
 1fa:	5d                   	pop    %rbp
 1fb:	c3                   	ret

00000000000001fc <main>:
{
 1fc:	55                   	push   %rbp
 1fd:	48 89 e5             	mov    %rsp,%rbp
 200:	41 57                	push   %r15
 202:	41 56                	push   %r14
 204:	41 55                	push   %r13
 206:	41 54                	push   %r12
 208:	53                   	push   %rbx
 209:	48 83 ec 18          	sub    $0x18,%rsp
  if(argc <= 1){
 20d:	83 ff 01             	cmp    $0x1,%edi
 210:	7e 50                	jle    262 <main+0x66>
 212:	41 89 fd             	mov    %edi,%r13d
 215:	49 89 f7             	mov    %rsi,%r15
  pattern = argv[1];
 218:	48 8b 46 08          	mov    0x8(%rsi),%rax
 21c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  if(argc <= 2){
 220:	83 ff 02             	cmp    $0x2,%edi
 223:	7e 53                	jle    278 <main+0x7c>
  for(i = 2; i < argc; i++){
 225:	41 bc 02 00 00 00    	mov    $0x2,%r12d
 22b:	45 39 ec             	cmp    %r13d,%r12d
 22e:	7d 73                	jge    2a3 <main+0xa7>
    if((fd = open(argv[i], 0)) < 0){
 230:	49 63 c4             	movslq %r12d,%rax
 233:	4d 8d 34 c7          	lea    (%r15,%rax,8),%r14
 237:	49 8b 3e             	mov    (%r14),%rdi
 23a:	be 00 00 00 00       	mov    $0x0,%esi
 23f:	e8 ce 02 00 00       	call   512 <open>
 244:	89 c3                	mov    %eax,%ebx
 246:	85 c0                	test   %eax,%eax
 248:	78 40                	js     28a <main+0x8e>
    grep(pattern, fd);
 24a:	89 c6                	mov    %eax,%esi
 24c:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
 250:	e8 c9 fe ff ff       	call   11e <grep>
    close(fd);
 255:	89 df                	mov    %ebx,%edi
 257:	e8 98 02 00 00       	call   4f4 <close>
  for(i = 2; i < argc; i++){
 25c:	41 83 c4 01          	add    $0x1,%r12d
 260:	eb c9                	jmp    22b <main+0x2f>
    printf(2, "usage: grep pattern [file ...]\n");
 262:	be 70 0a 00 00       	mov    $0xa70,%esi
 267:	bf 02 00 00 00       	mov    $0x2,%edi
 26c:	b0 00                	mov    $0x0,%al
 26e:	e8 32 04 00 00       	call   6a5 <printf>
    exit();
 273:	e8 4a 02 00 00       	call   4c2 <exit>
    grep(pattern, 0);
 278:	be 00 00 00 00       	mov    $0x0,%esi
 27d:	48 89 c7             	mov    %rax,%rdi
 280:	e8 99 fe ff ff       	call   11e <grep>
    exit();
 285:	e8 38 02 00 00       	call   4c2 <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
 28a:	49 8b 16             	mov    (%r14),%rdx
 28d:	be 90 0a 00 00       	mov    $0xa90,%esi
 292:	bf 01 00 00 00       	mov    $0x1,%edi
 297:	b0 00                	mov    $0x0,%al
 299:	e8 07 04 00 00       	call   6a5 <printf>
      exit();
 29e:	e8 1f 02 00 00       	call   4c2 <exit>
  exit();
 2a3:	e8 1a 02 00 00       	call   4c2 <exit>
 2a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 2af:	00 00 00 
 2b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 2b9:	00 00 00 
 2bc:	0f 1f 40 00          	nopl   0x0(%rax)

00000000000002c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2c0:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2c3:	48 89 f9             	mov    %rdi,%rcx
 2c6:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2cd:	00 00 00 00 
 2d1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 2d8:	00 00 00 00 
 2dc:	0f 1f 40 00          	nopl   0x0(%rax)
 2e0:	48 89 f2             	mov    %rsi,%rdx
 2e3:	48 83 c6 01          	add    $0x1,%rsi
 2e7:	49 89 c8             	mov    %rcx,%r8
 2ea:	48 83 c1 01          	add    $0x1,%rcx
 2ee:	8a 12                	mov    (%rdx),%dl
 2f0:	41 88 10             	mov    %dl,(%r8)
 2f3:	0f be d2             	movsbl %dl,%edx
 2f6:	85 d2                	test   %edx,%edx
 2f8:	75 e6                	jne    2e0 <strcpy+0x20>
    ;
  return os;
}
 2fa:	c3                   	ret

00000000000002fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2fb:	eb 0b                	jmp    308 <strcmp+0xd>
 2fd:	0f 1f 00             	nopl   (%rax)
    p++, q++;
 300:	48 83 c7 01          	add    $0x1,%rdi
 304:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
 308:	8a 07                	mov    (%rdi),%al
 30a:	0f be d0             	movsbl %al,%edx
 30d:	85 d2                	test   %edx,%edx
 30f:	74 07                	je     318 <strcmp+0x1d>
 311:	0f be 0e             	movsbl (%rsi),%ecx
 314:	39 ca                	cmp    %ecx,%edx
 316:	74 e8                	je     300 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 318:	0f b6 c0             	movzbl %al,%eax
 31b:	0f b6 16             	movzbl (%rsi),%edx
 31e:	29 d0                	sub    %edx,%eax
}
 320:	c3                   	ret

0000000000000321 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 321:	b8 00 00 00 00       	mov    $0x0,%eax
 326:	eb 0b                	jmp    333 <strlen+0x12>
 328:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 32f:	00 
 330:	83 c0 01             	add    $0x1,%eax
 333:	48 63 d0             	movslq %eax,%rdx
 336:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
 33a:	85 d2                	test   %edx,%edx
 33c:	75 f2                	jne    330 <strlen+0xf>
    ;
  return n;
}
 33e:	c3                   	ret

000000000000033f <memset>:

void*
memset(void *dst, int c, uint n)
{
 33f:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
 342:	89 d1                	mov    %edx,%ecx
 344:	89 f0                	mov    %esi,%eax
 346:	fc                   	cld
 347:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 349:	4c 89 c0             	mov    %r8,%rax
 34c:	c3                   	ret

000000000000034d <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 34d:	eb 15                	jmp    364 <strchr+0x17>
 34f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 356:	00 00 00 00 
 35a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 360:	48 83 c7 01          	add    $0x1,%rdi
 364:	8a 17                	mov    (%rdi),%dl
 366:	0f be c2             	movsbl %dl,%eax
 369:	85 c0                	test   %eax,%eax
 36b:	74 0f                	je     37c <strchr+0x2f>
    if(*s == c)
 36d:	0f be d2             	movsbl %dl,%edx
 370:	40 0f be c6          	movsbl %sil,%eax
 374:	39 c2                	cmp    %eax,%edx
 376:	75 e8                	jne    360 <strchr+0x13>
      return (char*)s;
 378:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
 37b:	c3                   	ret
  return 0;
 37c:	b8 00 00 00 00       	mov    $0x0,%eax
 381:	c3                   	ret

0000000000000382 <gets>:

char*
gets(char *buf, int max)
{
 382:	55                   	push   %rbp
 383:	48 89 e5             	mov    %rsp,%rbp
 386:	41 56                	push   %r14
 388:	41 55                	push   %r13
 38a:	41 54                	push   %r12
 38c:	53                   	push   %rbx
 38d:	48 83 ec 10          	sub    $0x10,%rsp
 391:	49 89 fc             	mov    %rdi,%r12
 394:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 397:	bb 00 00 00 00       	mov    $0x0,%ebx
 39c:	41 89 de             	mov    %ebx,%r14d
 39f:	83 c3 01             	add    $0x1,%ebx
 3a2:	44 39 eb             	cmp    %r13d,%ebx
 3a5:	7d 39                	jge    3e0 <gets+0x5e>
    cc = read(0, &c, 1);
 3a7:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 3ab:	ba 01 00 00 00       	mov    $0x1,%edx
 3b0:	bf 00 00 00 00       	mov    $0x0,%edi
 3b5:	e8 26 01 00 00       	call   4e0 <read>
    if(cc < 1)
 3ba:	85 c0                	test   %eax,%eax
 3bc:	7e 22                	jle    3e0 <gets+0x5e>
      break;
    buf[i++] = c;
 3be:	4d 63 f6             	movslq %r14d,%r14
 3c1:	8a 45 df             	mov    -0x21(%rbp),%al
 3c4:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
 3c8:	0f be c0             	movsbl %al,%eax
 3cb:	83 f8 0a             	cmp    $0xa,%eax
 3ce:	0f 94 c2             	sete   %dl
 3d1:	83 f8 0d             	cmp    $0xd,%eax
 3d4:	0f 94 c0             	sete   %al
 3d7:	09 d0                	or     %edx,%eax
 3d9:	a8 ff                	test   $0xff,%al
 3db:	74 bf                	je     39c <gets+0x1a>
    buf[i++] = c;
 3dd:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
 3e0:	4d 63 f6             	movslq %r14d,%r14
 3e3:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
 3e8:	4c 89 e0             	mov    %r12,%rax
 3eb:	48 83 c4 10          	add    $0x10,%rsp
 3ef:	5b                   	pop    %rbx
 3f0:	41 5c                	pop    %r12
 3f2:	41 5d                	pop    %r13
 3f4:	41 5e                	pop    %r14
 3f6:	5d                   	pop    %rbp
 3f7:	c3                   	ret

00000000000003f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f8:	55                   	push   %rbp
 3f9:	48 89 e5             	mov    %rsp,%rbp
 3fc:	41 54                	push   %r12
 3fe:	53                   	push   %rbx
 3ff:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 402:	be 00 00 00 00       	mov    $0x0,%esi
 407:	e8 06 01 00 00       	call   512 <open>
  if(fd < 0)
 40c:	85 c0                	test   %eax,%eax
 40e:	78 1e                	js     42e <stat+0x36>
 410:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 412:	4c 89 e6             	mov    %r12,%rsi
 415:	89 c7                	mov    %eax,%edi
 417:	e8 14 01 00 00       	call   530 <fstat>
 41c:	41 89 c4             	mov    %eax,%r12d
  close(fd);
 41f:	89 df                	mov    %ebx,%edi
 421:	e8 ce 00 00 00       	call   4f4 <close>
  return r;
}
 426:	44 89 e0             	mov    %r12d,%eax
 429:	5b                   	pop    %rbx
 42a:	41 5c                	pop    %r12
 42c:	5d                   	pop    %rbp
 42d:	c3                   	ret
    return -1;
 42e:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 434:	eb f0                	jmp    426 <stat+0x2e>

0000000000000436 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
 436:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
 43b:	eb 09                	jmp    446 <atoi+0x10>
 43d:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
 440:	f7 de                	neg    %esi
    s++;
 442:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
 446:	0f be 07             	movsbl (%rdi),%eax
 449:	83 f8 2d             	cmp    $0x2d,%eax
 44c:	74 f2                	je     440 <atoi+0xa>
  n = 0;
 44e:	b8 00 00 00 00       	mov    $0x0,%eax
 453:	eb 19                	jmp    46e <atoi+0x38>
 455:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 45c:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 460:	8d 04 80             	lea    (%rax,%rax,4),%eax
 463:	48 83 c7 01          	add    $0x1,%rdi
 467:	0f be d2             	movsbl %dl,%edx
 46a:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
 46e:	8a 17                	mov    (%rdi),%dl
 470:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 473:	0f b6 c9             	movzbl %cl,%ecx
 476:	83 f9 09             	cmp    $0x9,%ecx
 479:	76 e5                	jbe    460 <atoi+0x2a>
  return sign * n;
 47b:	0f af c6             	imul   %esi,%eax
}
 47e:	c3                   	ret

000000000000047f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47f:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
 482:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
 485:	eb 28                	jmp    4af <memmove+0x30>
 487:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 48e:	00 00 00 00 
 492:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 499:	00 00 00 00 
 49d:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
 4a0:	8a 16                	mov    (%rsi),%dl
 4a2:	88 11                	mov    %dl,(%rcx)
 4a4:	48 8d 76 01          	lea    0x1(%rsi),%rsi
 4a8:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
 4ac:	44 89 c2             	mov    %r8d,%edx
 4af:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
 4b3:	85 d2                	test   %edx,%edx
 4b5:	7f e9                	jg     4a0 <memmove+0x21>
  return vdst;
}
 4b7:	c3                   	ret

00000000000004b8 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4b8:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret

00000000000004c2 <exit>:
SYSCALL(exit)
 4c2:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret

00000000000004cc <wait>:
SYSCALL(wait)
 4cc:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret

00000000000004d6 <pipe>:
SYSCALL(pipe)
 4d6:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret

00000000000004e0 <read>:
SYSCALL(read)
 4e0:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret

00000000000004ea <write>:
SYSCALL(write)
 4ea:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret

00000000000004f4 <close>:
SYSCALL(close)
 4f4:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret

00000000000004fe <kill>:
SYSCALL(kill)
 4fe:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret

0000000000000508 <exec>:
SYSCALL(exec)
 508:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret

0000000000000512 <open>:
SYSCALL(open)
 512:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret

000000000000051c <mknod>:
SYSCALL(mknod)
 51c:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret

0000000000000526 <unlink>:
SYSCALL(unlink)
 526:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret

0000000000000530 <fstat>:
SYSCALL(fstat)
 530:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret

000000000000053a <link>:
SYSCALL(link)
 53a:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret

0000000000000544 <mkdir>:
SYSCALL(mkdir)
 544:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret

000000000000054e <chdir>:
SYSCALL(chdir)
 54e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret

0000000000000558 <dup>:
SYSCALL(dup)
 558:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret

0000000000000562 <getpid>:
SYSCALL(getpid)
 562:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret

000000000000056c <sbrk>:
SYSCALL(sbrk)
 56c:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret

0000000000000576 <sleep>:
SYSCALL(sleep)
 576:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret

0000000000000580 <uptime>:
SYSCALL(uptime)
 580:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret

000000000000058a <vmcreate>:
SYSCALL(vmcreate)
 58a:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret

0000000000000594 <vmsetreg>:
SYSCALL(vmsetreg)
 594:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret

000000000000059e <vmrun>:
SYSCALL(vmrun)
 59e:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret

00000000000005a8 <vmgetreg>:
SYSCALL(vmgetreg)
 5a8:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret
 5b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 5b9:	00 00 00 
 5bc:	0f 1f 40 00          	nopl   0x0(%rax)

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
 5ff:	e8 e6 fe ff ff       	call   4ea <write>
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
 653:	44 8a 82 60 0b 00 00 	mov    0xb60(%rdx),%r8b
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
 7ce:	ff 24 c5 b0 0a 00 00 	jmp    *0xab0(,%rax,8)
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
 841:	41 bc a6 0a 00 00    	mov    $0xaa6,%r12d
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
 8e7:	48 8b 05 32 09 00 00 	mov    0x932(%rip),%rax        # 1220 <freep>
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
 942:	48 89 05 d7 08 00 00 	mov    %rax,0x8d7(%rip)        # 1220 <freep>
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
 98a:	e8 dd fb ff ff       	call   56c <sbrk>
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
 9a1:	48 8b 05 78 08 00 00 	mov    0x878(%rip),%rax        # 1220 <freep>
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
 9cc:	48 8b 0d 4d 08 00 00 	mov    0x84d(%rip),%rcx        # 1220 <freep>
 9d3:	48 85 c9             	test   %rcx,%rcx
 9d6:	74 05                	je     9dd <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d8:	48 8b 01             	mov    (%rcx),%rax
 9db:	eb 69                	jmp    a46 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
 9dd:	48 c7 05 38 08 00 00 	movq   $0x1230,0x838(%rip)        # 1220 <freep>
 9e4:	30 12 00 00 
 9e8:	48 c7 05 3d 08 00 00 	movq   $0x1230,0x83d(%rip)        # 1230 <base>
 9ef:	30 12 00 00 
    base.s.size = 0;
 9f3:	c7 05 3b 08 00 00 00 	movl   $0x0,0x83b(%rip)        # 1238 <base+0x8>
 9fa:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 9fd:	b9 30 12 00 00       	mov    $0x1230,%ecx
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
 a17:	48 89 0d 02 08 00 00 	mov    %rcx,0x802(%rip)        # 1220 <freep>
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
 a4d:	48 39 05 cc 07 00 00 	cmp    %rax,0x7cc(%rip)        # 1220 <freep>
 a54:	75 ea                	jne    a40 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
 a56:	89 df                	mov    %ebx,%edi
 a58:	e8 10 ff ff ff       	call   96d <morecore>
 a5d:	48 85 c0             	test   %rax,%rax
 a60:	75 de                	jne    a40 <malloc+0x8a>
 a62:	eb be                	jmp    a22 <malloc+0x6c>
