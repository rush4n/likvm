
_sh:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
       0:	55                   	push   %rbp
       1:	48 89 e5             	mov    %rsp,%rbp
       4:	41 54                	push   %r12
       6:	53                   	push   %rbx
       7:	48 89 fb             	mov    %rdi,%rbx
       a:	41 89 f4             	mov    %esi,%r12d
  printf(2, "$ ");
       d:	be 30 12 00 00       	mov    $0x1230,%esi
      12:	bf 02 00 00 00       	mov    $0x2,%edi
      17:	b0 00                	mov    $0x0,%al
      19:	e8 47 0e 00 00       	call   e65 <printf>
  memset(buf, 0, nbuf);
      1e:	44 89 e2             	mov    %r12d,%edx
      21:	be 00 00 00 00       	mov    $0x0,%esi
      26:	48 89 df             	mov    %rbx,%rdi
      29:	e8 d1 0a 00 00       	call   aff <memset>
  gets(buf, nbuf);
      2e:	44 89 e6             	mov    %r12d,%esi
      31:	48 89 df             	mov    %rbx,%rdi
      34:	e8 09 0b 00 00       	call   b42 <gets>
  if(buf[0] == 0) // EOF
      39:	0f be 03             	movsbl (%rbx),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	74 0a                	je     4a <getcmd+0x4a>
    return -1;
  return 0;
      40:	b8 00 00 00 00       	mov    $0x0,%eax
}
      45:	5b                   	pop    %rbx
      46:	41 5c                	pop    %r12
      48:	5d                   	pop    %rbp
      49:	c3                   	ret
    return -1;
      4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      4f:	eb f4                	jmp    45 <getcmd+0x45>

0000000000000051 <panic>:
  exit();
}

void
panic(char *s)
{
      51:	55                   	push   %rbp
      52:	48 89 e5             	mov    %rsp,%rbp
      55:	48 89 fa             	mov    %rdi,%rdx
  printf(2, "%s\n", s);
      58:	be cd 12 00 00       	mov    $0x12cd,%esi
      5d:	bf 02 00 00 00       	mov    $0x2,%edi
      62:	b0 00                	mov    $0x0,%al
      64:	e8 fc 0d 00 00       	call   e65 <printf>
  exit();
      69:	e8 14 0c 00 00       	call   c82 <exit>

000000000000006e <fork1>:
}

int
fork1(void)
{
      6e:	55                   	push   %rbp
      6f:	48 89 e5             	mov    %rsp,%rbp
  int pid;

  pid = fork();
      72:	e8 01 0c 00 00       	call   c78 <fork>
  if(pid == -1)
      77:	83 f8 ff             	cmp    $0xffffffff,%eax
      7a:	74 02                	je     7e <fork1+0x10>
    panic("fork");
  return pid;
}
      7c:	5d                   	pop    %rbp
      7d:	c3                   	ret
    panic("fork");
      7e:	bf 33 12 00 00       	mov    $0x1233,%edi
      83:	e8 c9 ff ff ff       	call   51 <panic>

0000000000000088 <runcmd>:
{
      88:	55                   	push   %rbp
      89:	48 89 e5             	mov    %rsp,%rbp
      8c:	53                   	push   %rbx
      8d:	48 83 ec 18          	sub    $0x18,%rsp
  if(cmd == 0)
      91:	48 85 ff             	test   %rdi,%rdi
      94:	74 13                	je     a9 <runcmd+0x21>
      96:	48 89 fb             	mov    %rdi,%rbx
  switch(cmd->type){
      99:	8b 07                	mov    (%rdi),%eax
      9b:	83 f8 05             	cmp    $0x5,%eax
      9e:	77 0e                	ja     ae <runcmd+0x26>
      a0:	89 c0                	mov    %eax,%eax
      a2:	ff 24 c5 f0 12 00 00 	jmp    *0x12f0(,%rax,8)
    exit();
      a9:	e8 d4 0b 00 00       	call   c82 <exit>
    panic("runcmd");
      ae:	bf 38 12 00 00       	mov    $0x1238,%edi
      b3:	e8 99 ff ff ff       	call   51 <panic>
    if(ecmd->argv[0] == 0)
      b8:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
      bc:	48 85 ff             	test   %rdi,%rdi
      bf:	74 23                	je     e4 <runcmd+0x5c>
    exec(ecmd->argv[0], ecmd->argv);
      c1:	48 8d 73 08          	lea    0x8(%rbx),%rsi
      c5:	e8 fe 0b 00 00       	call   cc8 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      ca:	48 8b 53 08          	mov    0x8(%rbx),%rdx
      ce:	be 3f 12 00 00       	mov    $0x123f,%esi
      d3:	bf 02 00 00 00       	mov    $0x2,%edi
      d8:	b0 00                	mov    $0x0,%al
      da:	e8 86 0d 00 00       	call   e65 <printf>
  exit();
      df:	e8 9e 0b 00 00       	call   c82 <exit>
      exit();
      e4:	e8 99 0b 00 00       	call   c82 <exit>
    close(rcmd->fd);
      e9:	8b 7f 24             	mov    0x24(%rdi),%edi
      ec:	e8 c3 0b 00 00       	call   cb4 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      f1:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
      f5:	8b 73 20             	mov    0x20(%rbx),%esi
      f8:	e8 d5 0b 00 00       	call   cd2 <open>
      fd:	85 c0                	test   %eax,%eax
      ff:	78 09                	js     10a <runcmd+0x82>
    runcmd(rcmd->cmd);
     101:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
     105:	e8 7e ff ff ff       	call   88 <runcmd>
      printf(2, "open %s failed\n", rcmd->file);
     10a:	48 8b 53 10          	mov    0x10(%rbx),%rdx
     10e:	be 4f 12 00 00       	mov    $0x124f,%esi
     113:	bf 02 00 00 00       	mov    $0x2,%edi
     118:	b0 00                	mov    $0x0,%al
     11a:	e8 46 0d 00 00       	call   e65 <printf>
      exit();
     11f:	e8 5e 0b 00 00       	call   c82 <exit>
    if(fork1() == 0)
     124:	e8 45 ff ff ff       	call   6e <fork1>
     129:	85 c0                	test   %eax,%eax
     12b:	74 0e                	je     13b <runcmd+0xb3>
    wait();
     12d:	e8 5a 0b 00 00       	call   c8c <wait>
    runcmd(lcmd->right);
     132:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
     136:	e8 4d ff ff ff       	call   88 <runcmd>
      runcmd(lcmd->left);
     13b:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
     13f:	e8 44 ff ff ff       	call   88 <runcmd>
    if(pipe(p) < 0)
     144:	48 8d 7d e8          	lea    -0x18(%rbp),%rdi
     148:	e8 49 0b 00 00       	call   c96 <pipe>
     14d:	85 c0                	test   %eax,%eax
     14f:	78 31                	js     182 <runcmd+0xfa>
    if(fork1() == 0){
     151:	e8 18 ff ff ff       	call   6e <fork1>
     156:	85 c0                	test   %eax,%eax
     158:	74 32                	je     18c <runcmd+0x104>
    if(fork1() == 0){
     15a:	e8 0f ff ff ff       	call   6e <fork1>
     15f:	85 c0                	test   %eax,%eax
     161:	74 54                	je     1b7 <runcmd+0x12f>
    close(p[0]);
     163:	8b 7d e8             	mov    -0x18(%rbp),%edi
     166:	e8 49 0b 00 00       	call   cb4 <close>
    close(p[1]);
     16b:	8b 7d ec             	mov    -0x14(%rbp),%edi
     16e:	e8 41 0b 00 00       	call   cb4 <close>
    wait();
     173:	e8 14 0b 00 00       	call   c8c <wait>
    wait();
     178:	e8 0f 0b 00 00       	call   c8c <wait>
    break;
     17d:	e9 5d ff ff ff       	jmp    df <runcmd+0x57>
      panic("pipe");
     182:	bf 5f 12 00 00       	mov    $0x125f,%edi
     187:	e8 c5 fe ff ff       	call   51 <panic>
      close(1);
     18c:	bf 01 00 00 00       	mov    $0x1,%edi
     191:	e8 1e 0b 00 00       	call   cb4 <close>
      dup(p[1]);
     196:	8b 7d ec             	mov    -0x14(%rbp),%edi
     199:	e8 7a 0b 00 00       	call   d18 <dup>
      close(p[0]);
     19e:	8b 7d e8             	mov    -0x18(%rbp),%edi
     1a1:	e8 0e 0b 00 00       	call   cb4 <close>
      close(p[1]);
     1a6:	8b 7d ec             	mov    -0x14(%rbp),%edi
     1a9:	e8 06 0b 00 00       	call   cb4 <close>
      runcmd(pcmd->left);
     1ae:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
     1b2:	e8 d1 fe ff ff       	call   88 <runcmd>
      close(0);
     1b7:	bf 00 00 00 00       	mov    $0x0,%edi
     1bc:	e8 f3 0a 00 00       	call   cb4 <close>
      dup(p[0]);
     1c1:	8b 7d e8             	mov    -0x18(%rbp),%edi
     1c4:	e8 4f 0b 00 00       	call   d18 <dup>
      close(p[0]);
     1c9:	8b 7d e8             	mov    -0x18(%rbp),%edi
     1cc:	e8 e3 0a 00 00       	call   cb4 <close>
      close(p[1]);
     1d1:	8b 7d ec             	mov    -0x14(%rbp),%edi
     1d4:	e8 db 0a 00 00       	call   cb4 <close>
      runcmd(pcmd->right);
     1d9:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
     1dd:	e8 a6 fe ff ff       	call   88 <runcmd>
    if(fork1() == 0)
     1e2:	e8 87 fe ff ff       	call   6e <fork1>
     1e7:	85 c0                	test   %eax,%eax
     1e9:	0f 85 f0 fe ff ff    	jne    df <runcmd+0x57>
      runcmd(bcmd->cmd);
     1ef:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
     1f3:	e8 90 fe ff ff       	call   88 <runcmd>

00000000000001f8 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1f8:	55                   	push   %rbp
     1f9:	48 89 e5             	mov    %rsp,%rbp
     1fc:	53                   	push   %rbx
     1fd:	48 83 ec 08          	sub    $0x8,%rsp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     201:	bf a8 00 00 00       	mov    $0xa8,%edi
     206:	e8 6b 0f 00 00       	call   1176 <malloc>
     20b:	48 89 c3             	mov    %rax,%rbx
  memset(cmd, 0, sizeof(*cmd));
     20e:	ba a8 00 00 00       	mov    $0xa8,%edx
     213:	be 00 00 00 00       	mov    $0x0,%esi
     218:	48 89 c7             	mov    %rax,%rdi
     21b:	e8 df 08 00 00       	call   aff <memset>
  cmd->type = EXEC;
     220:	c7 03 01 00 00 00    	movl   $0x1,(%rbx)
  return (struct cmd*)cmd;
}
     226:	48 89 d8             	mov    %rbx,%rax
     229:	48 83 c4 08          	add    $0x8,%rsp
     22d:	5b                   	pop    %rbx
     22e:	5d                   	pop    %rbp
     22f:	c3                   	ret

0000000000000230 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     230:	55                   	push   %rbp
     231:	48 89 e5             	mov    %rsp,%rbp
     234:	41 57                	push   %r15
     236:	41 56                	push   %r14
     238:	41 55                	push   %r13
     23a:	41 54                	push   %r12
     23c:	53                   	push   %rbx
     23d:	48 83 ec 18          	sub    $0x18,%rsp
     241:	49 89 ff             	mov    %rdi,%r15
     244:	49 89 f6             	mov    %rsi,%r14
     247:	49 89 d5             	mov    %rdx,%r13
     24a:	41 89 cc             	mov    %ecx,%r12d
     24d:	44 89 45 cc          	mov    %r8d,-0x34(%rbp)
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     251:	bf 28 00 00 00       	mov    $0x28,%edi
     256:	e8 1b 0f 00 00       	call   1176 <malloc>
     25b:	48 89 c3             	mov    %rax,%rbx
  memset(cmd, 0, sizeof(*cmd));
     25e:	ba 28 00 00 00       	mov    $0x28,%edx
     263:	be 00 00 00 00       	mov    $0x0,%esi
     268:	48 89 c7             	mov    %rax,%rdi
     26b:	e8 8f 08 00 00       	call   aff <memset>
  cmd->type = REDIR;
     270:	c7 03 02 00 00 00    	movl   $0x2,(%rbx)
  cmd->cmd = subcmd;
     276:	4c 89 7b 08          	mov    %r15,0x8(%rbx)
  cmd->file = file;
     27a:	4c 89 73 10          	mov    %r14,0x10(%rbx)
  cmd->efile = efile;
     27e:	4c 89 6b 18          	mov    %r13,0x18(%rbx)
  cmd->mode = mode;
     282:	44 89 63 20          	mov    %r12d,0x20(%rbx)
  cmd->fd = fd;
     286:	8b 45 cc             	mov    -0x34(%rbp),%eax
     289:	89 43 24             	mov    %eax,0x24(%rbx)
  return (struct cmd*)cmd;
}
     28c:	48 89 d8             	mov    %rbx,%rax
     28f:	48 83 c4 18          	add    $0x18,%rsp
     293:	5b                   	pop    %rbx
     294:	41 5c                	pop    %r12
     296:	41 5d                	pop    %r13
     298:	41 5e                	pop    %r14
     29a:	41 5f                	pop    %r15
     29c:	5d                   	pop    %rbp
     29d:	c3                   	ret

000000000000029e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     29e:	55                   	push   %rbp
     29f:	48 89 e5             	mov    %rsp,%rbp
     2a2:	41 55                	push   %r13
     2a4:	41 54                	push   %r12
     2a6:	53                   	push   %rbx
     2a7:	48 83 ec 08          	sub    $0x8,%rsp
     2ab:	49 89 fd             	mov    %rdi,%r13
     2ae:	49 89 f4             	mov    %rsi,%r12
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b1:	bf 18 00 00 00       	mov    $0x18,%edi
     2b6:	e8 bb 0e 00 00       	call   1176 <malloc>
     2bb:	48 89 c3             	mov    %rax,%rbx
  memset(cmd, 0, sizeof(*cmd));
     2be:	ba 18 00 00 00       	mov    $0x18,%edx
     2c3:	be 00 00 00 00       	mov    $0x0,%esi
     2c8:	48 89 c7             	mov    %rax,%rdi
     2cb:	e8 2f 08 00 00       	call   aff <memset>
  cmd->type = PIPE;
     2d0:	c7 03 03 00 00 00    	movl   $0x3,(%rbx)
  cmd->left = left;
     2d6:	4c 89 6b 08          	mov    %r13,0x8(%rbx)
  cmd->right = right;
     2da:	4c 89 63 10          	mov    %r12,0x10(%rbx)
  return (struct cmd*)cmd;
}
     2de:	48 89 d8             	mov    %rbx,%rax
     2e1:	48 83 c4 08          	add    $0x8,%rsp
     2e5:	5b                   	pop    %rbx
     2e6:	41 5c                	pop    %r12
     2e8:	41 5d                	pop    %r13
     2ea:	5d                   	pop    %rbp
     2eb:	c3                   	ret

00000000000002ec <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     2ec:	55                   	push   %rbp
     2ed:	48 89 e5             	mov    %rsp,%rbp
     2f0:	41 55                	push   %r13
     2f2:	41 54                	push   %r12
     2f4:	53                   	push   %rbx
     2f5:	48 83 ec 08          	sub    $0x8,%rsp
     2f9:	49 89 fd             	mov    %rdi,%r13
     2fc:	49 89 f4             	mov    %rsi,%r12
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ff:	bf 18 00 00 00       	mov    $0x18,%edi
     304:	e8 6d 0e 00 00       	call   1176 <malloc>
     309:	48 89 c3             	mov    %rax,%rbx
  memset(cmd, 0, sizeof(*cmd));
     30c:	ba 18 00 00 00       	mov    $0x18,%edx
     311:	be 00 00 00 00       	mov    $0x0,%esi
     316:	48 89 c7             	mov    %rax,%rdi
     319:	e8 e1 07 00 00       	call   aff <memset>
  cmd->type = LIST;
     31e:	c7 03 04 00 00 00    	movl   $0x4,(%rbx)
  cmd->left = left;
     324:	4c 89 6b 08          	mov    %r13,0x8(%rbx)
  cmd->right = right;
     328:	4c 89 63 10          	mov    %r12,0x10(%rbx)
  return (struct cmd*)cmd;
}
     32c:	48 89 d8             	mov    %rbx,%rax
     32f:	48 83 c4 08          	add    $0x8,%rsp
     333:	5b                   	pop    %rbx
     334:	41 5c                	pop    %r12
     336:	41 5d                	pop    %r13
     338:	5d                   	pop    %rbp
     339:	c3                   	ret

000000000000033a <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     33a:	55                   	push   %rbp
     33b:	48 89 e5             	mov    %rsp,%rbp
     33e:	41 54                	push   %r12
     340:	53                   	push   %rbx
     341:	49 89 fc             	mov    %rdi,%r12
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     344:	bf 10 00 00 00       	mov    $0x10,%edi
     349:	e8 28 0e 00 00       	call   1176 <malloc>
     34e:	48 89 c3             	mov    %rax,%rbx
  memset(cmd, 0, sizeof(*cmd));
     351:	ba 10 00 00 00       	mov    $0x10,%edx
     356:	be 00 00 00 00       	mov    $0x0,%esi
     35b:	48 89 c7             	mov    %rax,%rdi
     35e:	e8 9c 07 00 00       	call   aff <memset>
  cmd->type = BACK;
     363:	c7 03 05 00 00 00    	movl   $0x5,(%rbx)
  cmd->cmd = subcmd;
     369:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  return (struct cmd*)cmd;
}
     36d:	48 89 d8             	mov    %rbx,%rax
     370:	5b                   	pop    %rbx
     371:	41 5c                	pop    %r12
     373:	5d                   	pop    %rbp
     374:	c3                   	ret

0000000000000375 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     375:	55                   	push   %rbp
     376:	48 89 e5             	mov    %rsp,%rbp
     379:	41 57                	push   %r15
     37b:	41 56                	push   %r14
     37d:	41 55                	push   %r13
     37f:	41 54                	push   %r12
     381:	53                   	push   %rbx
     382:	48 83 ec 08          	sub    $0x8,%rsp
     386:	49 89 fd             	mov    %rdi,%r13
     389:	49 89 f4             	mov    %rsi,%r12
     38c:	49 89 d6             	mov    %rdx,%r14
     38f:	49 89 cf             	mov    %rcx,%r15
  char *s;
  int ret;

  s = *ps;
     392:	48 8b 1f             	mov    (%rdi),%rbx
  while(s < es && strchr(whitespace, *s))
     395:	eb 04                	jmp    39b <gettoken+0x26>
    s++;
     397:	48 83 c3 01          	add    $0x1,%rbx
  while(s < es && strchr(whitespace, *s))
     39b:	4c 39 e3             	cmp    %r12,%rbx
     39e:	73 12                	jae    3b2 <gettoken+0x3d>
     3a0:	0f be 33             	movsbl (%rbx),%esi
     3a3:	bf d0 18 00 00       	mov    $0x18d0,%edi
     3a8:	e8 60 07 00 00       	call   b0d <strchr>
     3ad:	48 85 c0             	test   %rax,%rax
     3b0:	75 e5                	jne    397 <gettoken+0x22>
  if(q)
     3b2:	4d 85 f6             	test   %r14,%r14
     3b5:	74 03                	je     3ba <gettoken+0x45>
    *q = s;
     3b7:	49 89 1e             	mov    %rbx,(%r14)
  ret = *s;
     3ba:	8a 03                	mov    (%rbx),%al
     3bc:	44 0f be f0          	movsbl %al,%r14d
  switch(*s){
     3c0:	41 83 fe 3c          	cmp    $0x3c,%r14d
     3c4:	7f 30                	jg     3f6 <gettoken+0x81>
     3c6:	41 83 fe 3b          	cmp    $0x3b,%r14d
     3ca:	7d 1c                	jge    3e8 <gettoken+0x73>
     3cc:	45 85 f6             	test   %r14d,%r14d
     3cf:	74 1b                	je     3ec <gettoken+0x77>
     3d1:	a8 80                	test   $0x80,%al
     3d3:	75 52                	jne    427 <gettoken+0xb2>
     3d5:	41 83 fe 26          	cmp    $0x26,%r14d
     3d9:	74 0d                	je     3e8 <gettoken+0x73>
     3db:	7c 4a                	jl     427 <gettoken+0xb2>
     3dd:	83 e8 28             	sub    $0x28,%eax
     3e0:	0f b6 c0             	movzbl %al,%eax
     3e3:	83 f8 01             	cmp    $0x1,%eax
     3e6:	77 3f                	ja     427 <gettoken+0xb2>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     3e8:	48 83 c3 01          	add    $0x1,%rbx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     3ec:	4d 85 ff             	test   %r15,%r15
     3ef:	74 7b                	je     46c <gettoken+0xf7>
    *eq = s;
     3f1:	49 89 1f             	mov    %rbx,(%r15)
     3f4:	eb 76                	jmp    46c <gettoken+0xf7>
  switch(*s){
     3f6:	0f be d0             	movsbl %al,%edx
     3f9:	83 fa 3e             	cmp    $0x3e,%edx
     3fc:	75 12                	jne    410 <gettoken+0x9b>
    s++;
     3fe:	48 8d 53 01          	lea    0x1(%rbx),%rdx
    if(*s == '>'){
     402:	0f be 43 01          	movsbl 0x1(%rbx),%eax
     406:	83 f8 3e             	cmp    $0x3e,%eax
     409:	74 0c                	je     417 <gettoken+0xa2>
    s++;
     40b:	48 89 d3             	mov    %rdx,%rbx
     40e:	eb dc                	jmp    3ec <gettoken+0x77>
  switch(*s){
     410:	83 fa 7c             	cmp    $0x7c,%edx
     413:	75 12                	jne    427 <gettoken+0xb2>
     415:	eb d1                	jmp    3e8 <gettoken+0x73>
      s++;
     417:	48 83 c3 02          	add    $0x2,%rbx
      ret = '+';
     41b:	41 be 2b 00 00 00    	mov    $0x2b,%r14d
     421:	eb c9                	jmp    3ec <gettoken+0x77>
      s++;
     423:	48 83 c3 01          	add    $0x1,%rbx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     427:	4c 39 e3             	cmp    %r12,%rbx
     42a:	73 2c                	jae    458 <gettoken+0xe3>
     42c:	0f be 33             	movsbl (%rbx),%esi
     42f:	bf d0 18 00 00       	mov    $0x18d0,%edi
     434:	e8 d4 06 00 00       	call   b0d <strchr>
     439:	48 85 c0             	test   %rax,%rax
     43c:	75 22                	jne    460 <gettoken+0xeb>
     43e:	0f be 33             	movsbl (%rbx),%esi
     441:	bf c8 18 00 00       	mov    $0x18c8,%edi
     446:	e8 c2 06 00 00       	call   b0d <strchr>
     44b:	48 85 c0             	test   %rax,%rax
     44e:	74 d3                	je     423 <gettoken+0xae>
    ret = 'a';
     450:	41 be 61 00 00 00    	mov    $0x61,%r14d
     456:	eb 94                	jmp    3ec <gettoken+0x77>
     458:	41 be 61 00 00 00    	mov    $0x61,%r14d
     45e:	eb 8c                	jmp    3ec <gettoken+0x77>
     460:	41 be 61 00 00 00    	mov    $0x61,%r14d
     466:	eb 84                	jmp    3ec <gettoken+0x77>

  while(s < es && strchr(whitespace, *s))
    s++;
     468:	48 83 c3 01          	add    $0x1,%rbx
  while(s < es && strchr(whitespace, *s))
     46c:	4c 39 e3             	cmp    %r12,%rbx
     46f:	73 12                	jae    483 <gettoken+0x10e>
     471:	0f be 33             	movsbl (%rbx),%esi
     474:	bf d0 18 00 00       	mov    $0x18d0,%edi
     479:	e8 8f 06 00 00       	call   b0d <strchr>
     47e:	48 85 c0             	test   %rax,%rax
     481:	75 e5                	jne    468 <gettoken+0xf3>
  *ps = s;
     483:	49 89 5d 00          	mov    %rbx,0x0(%r13)
  return ret;
}
     487:	44 89 f0             	mov    %r14d,%eax
     48a:	48 83 c4 08          	add    $0x8,%rsp
     48e:	5b                   	pop    %rbx
     48f:	41 5c                	pop    %r12
     491:	41 5d                	pop    %r13
     493:	41 5e                	pop    %r14
     495:	41 5f                	pop    %r15
     497:	5d                   	pop    %rbp
     498:	c3                   	ret

0000000000000499 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     499:	55                   	push   %rbp
     49a:	48 89 e5             	mov    %rsp,%rbp
     49d:	41 56                	push   %r14
     49f:	41 55                	push   %r13
     4a1:	41 54                	push   %r12
     4a3:	53                   	push   %rbx
     4a4:	49 89 fd             	mov    %rdi,%r13
     4a7:	49 89 f4             	mov    %rsi,%r12
     4aa:	49 89 d6             	mov    %rdx,%r14
  char *s;

  s = *ps;
     4ad:	48 8b 1f             	mov    (%rdi),%rbx
  while(s < es && strchr(whitespace, *s))
     4b0:	eb 04                	jmp    4b6 <peek+0x1d>
    s++;
     4b2:	48 83 c3 01          	add    $0x1,%rbx
  while(s < es && strchr(whitespace, *s))
     4b6:	4c 39 e3             	cmp    %r12,%rbx
     4b9:	73 12                	jae    4cd <peek+0x34>
     4bb:	0f be 33             	movsbl (%rbx),%esi
     4be:	bf d0 18 00 00       	mov    $0x18d0,%edi
     4c3:	e8 45 06 00 00       	call   b0d <strchr>
     4c8:	48 85 c0             	test   %rax,%rax
     4cb:	75 e5                	jne    4b2 <peek+0x19>
  *ps = s;
     4cd:	49 89 5d 00          	mov    %rbx,0x0(%r13)
  return *s && strchr(toks, *s);
     4d1:	40 8a 33             	mov    (%rbx),%sil
     4d4:	40 0f be c6          	movsbl %sil,%eax
     4d8:	85 c0                	test   %eax,%eax
     4da:	75 0e                	jne    4ea <peek+0x51>
     4dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
     4e1:	5b                   	pop    %rbx
     4e2:	41 5c                	pop    %r12
     4e4:	41 5d                	pop    %r13
     4e6:	41 5e                	pop    %r14
     4e8:	5d                   	pop    %rbp
     4e9:	c3                   	ret
  return *s && strchr(toks, *s);
     4ea:	89 c6                	mov    %eax,%esi
     4ec:	4c 89 f7             	mov    %r14,%rdi
     4ef:	e8 19 06 00 00       	call   b0d <strchr>
     4f4:	48 85 c0             	test   %rax,%rax
     4f7:	74 07                	je     500 <peek+0x67>
     4f9:	b8 01 00 00 00       	mov    $0x1,%eax
     4fe:	eb e1                	jmp    4e1 <peek+0x48>
     500:	b8 00 00 00 00       	mov    $0x0,%eax
     505:	eb da                	jmp    4e1 <peek+0x48>

0000000000000507 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     507:	55                   	push   %rbp
     508:	48 89 e5             	mov    %rsp,%rbp
     50b:	41 56                	push   %r14
     50d:	41 55                	push   %r13
     50f:	41 54                	push   %r12
     511:	53                   	push   %rbx
     512:	48 83 ec 10          	sub    $0x10,%rsp
     516:	49 89 fe             	mov    %rdi,%r14
     519:	49 89 f5             	mov    %rsi,%r13
     51c:	49 89 d4             	mov    %rdx,%r12
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     51f:	eb 28                	jmp    549 <parseredirs+0x42>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
     521:	bf 64 12 00 00       	mov    $0x1264,%edi
     526:	e8 26 fb ff ff       	call   51 <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     52b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
     531:	b9 00 00 00 00       	mov    $0x0,%ecx
     536:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
     53a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
     53e:	4c 89 f7             	mov    %r14,%rdi
     541:	e8 ea fc ff ff       	call   230 <redircmd>
     546:	49 89 c6             	mov    %rax,%r14
  while(peek(ps, es, "<>")){
     549:	ba 81 12 00 00       	mov    $0x1281,%edx
     54e:	4c 89 e6             	mov    %r12,%rsi
     551:	4c 89 ef             	mov    %r13,%rdi
     554:	e8 40 ff ff ff       	call   499 <peek>
     559:	85 c0                	test   %eax,%eax
     55b:	0f 84 81 00 00 00    	je     5e2 <parseredirs+0xdb>
    tok = gettoken(ps, es, 0, 0);
     561:	b9 00 00 00 00       	mov    $0x0,%ecx
     566:	ba 00 00 00 00       	mov    $0x0,%edx
     56b:	4c 89 e6             	mov    %r12,%rsi
     56e:	4c 89 ef             	mov    %r13,%rdi
     571:	e8 ff fd ff ff       	call   375 <gettoken>
     576:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     578:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
     57c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
     580:	4c 89 e6             	mov    %r12,%rsi
     583:	4c 89 ef             	mov    %r13,%rdi
     586:	e8 ea fd ff ff       	call   375 <gettoken>
     58b:	83 f8 61             	cmp    $0x61,%eax
     58e:	75 91                	jne    521 <parseredirs+0x1a>
    switch(tok){
     590:	83 fb 3c             	cmp    $0x3c,%ebx
     593:	74 96                	je     52b <parseredirs+0x24>
     595:	83 fb 3e             	cmp    $0x3e,%ebx
     598:	74 25                	je     5bf <parseredirs+0xb8>
     59a:	83 fb 2b             	cmp    $0x2b,%ebx
     59d:	75 aa                	jne    549 <parseredirs+0x42>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     59f:	41 b8 01 00 00 00    	mov    $0x1,%r8d
     5a5:	b9 01 02 00 00       	mov    $0x201,%ecx
     5aa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
     5ae:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
     5b2:	4c 89 f7             	mov    %r14,%rdi
     5b5:	e8 76 fc ff ff       	call   230 <redircmd>
     5ba:	49 89 c6             	mov    %rax,%r14
      break;
     5bd:	eb 8a                	jmp    549 <parseredirs+0x42>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     5bf:	41 b8 01 00 00 00    	mov    $0x1,%r8d
     5c5:	b9 01 02 00 00       	mov    $0x201,%ecx
     5ca:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
     5ce:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
     5d2:	4c 89 f7             	mov    %r14,%rdi
     5d5:	e8 56 fc ff ff       	call   230 <redircmd>
     5da:	49 89 c6             	mov    %rax,%r14
      break;
     5dd:	e9 67 ff ff ff       	jmp    549 <parseredirs+0x42>
    }
  }
  return cmd;
}
     5e2:	4c 89 f0             	mov    %r14,%rax
     5e5:	48 83 c4 10          	add    $0x10,%rsp
     5e9:	5b                   	pop    %rbx
     5ea:	41 5c                	pop    %r12
     5ec:	41 5d                	pop    %r13
     5ee:	41 5e                	pop    %r14
     5f0:	5d                   	pop    %rbp
     5f1:	c3                   	ret

00000000000005f2 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     5f2:	55                   	push   %rbp
     5f3:	48 89 e5             	mov    %rsp,%rbp
     5f6:	41 57                	push   %r15
     5f8:	41 56                	push   %r14
     5fa:	41 55                	push   %r13
     5fc:	41 54                	push   %r12
     5fe:	53                   	push   %rbx
     5ff:	48 83 ec 18          	sub    $0x18,%rsp
     603:	49 89 fd             	mov    %rdi,%r13
     606:	49 89 f6             	mov    %rsi,%r14
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     609:	ba 84 12 00 00       	mov    $0x1284,%edx
     60e:	e8 86 fe ff ff       	call   499 <peek>
     613:	85 c0                	test   %eax,%eax
     615:	75 1d                	jne    634 <parseexec+0x42>
     617:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     619:	e8 da fb ff ff       	call   1f8 <execcmd>
     61e:	49 89 c7             	mov    %rax,%r15
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     621:	4c 89 f2             	mov    %r14,%rdx
     624:	4c 89 ee             	mov    %r13,%rsi
     627:	48 89 c7             	mov    %rax,%rdi
     62a:	e8 d8 fe ff ff       	call   507 <parseredirs>
     62f:	49 89 c4             	mov    %rax,%r12
  while(!peek(ps, es, "|)&;")){
     632:	eb 3b                	jmp    66f <parseexec+0x7d>
    return parseblock(ps, es);
     634:	4c 89 f6             	mov    %r14,%rsi
     637:	4c 89 ef             	mov    %r13,%rdi
     63a:	e8 b1 01 00 00       	call   7f0 <parseblock>
     63f:	49 89 c4             	mov    %rax,%r12
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     642:	4c 89 e0             	mov    %r12,%rax
     645:	48 83 c4 18          	add    $0x18,%rsp
     649:	5b                   	pop    %rbx
     64a:	41 5c                	pop    %r12
     64c:	41 5d                	pop    %r13
     64e:	41 5e                	pop    %r14
     650:	41 5f                	pop    %r15
     652:	5d                   	pop    %rbp
     653:	c3                   	ret
      panic("syntax");
     654:	bf 86 12 00 00       	mov    $0x1286,%edi
     659:	e8 f3 f9 ff ff       	call   51 <panic>
    ret = parseredirs(ret, ps, es);
     65e:	4c 89 f2             	mov    %r14,%rdx
     661:	4c 89 ee             	mov    %r13,%rsi
     664:	4c 89 e7             	mov    %r12,%rdi
     667:	e8 9b fe ff ff       	call   507 <parseredirs>
     66c:	49 89 c4             	mov    %rax,%r12
  while(!peek(ps, es, "|)&;")){
     66f:	ba 9b 12 00 00       	mov    $0x129b,%edx
     674:	4c 89 f6             	mov    %r14,%rsi
     677:	4c 89 ef             	mov    %r13,%rdi
     67a:	e8 1a fe ff ff       	call   499 <peek>
     67f:	85 c0                	test   %eax,%eax
     681:	75 43                	jne    6c6 <parseexec+0xd4>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     683:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
     687:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
     68b:	4c 89 f6             	mov    %r14,%rsi
     68e:	4c 89 ef             	mov    %r13,%rdi
     691:	e8 df fc ff ff       	call   375 <gettoken>
     696:	85 c0                	test   %eax,%eax
     698:	74 2c                	je     6c6 <parseexec+0xd4>
    if(tok != 'a')
     69a:	83 f8 61             	cmp    $0x61,%eax
     69d:	75 b5                	jne    654 <parseexec+0x62>
    cmd->argv[argc] = q;
     69f:	48 63 c3             	movslq %ebx,%rax
     6a2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
     6a6:	49 89 54 c7 08       	mov    %rdx,0x8(%r15,%rax,8)
    cmd->eargv[argc] = eq;
     6ab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
     6af:	49 89 54 c7 58       	mov    %rdx,0x58(%r15,%rax,8)
    argc++;
     6b4:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     6b7:	83 fb 09             	cmp    $0x9,%ebx
     6ba:	7e a2                	jle    65e <parseexec+0x6c>
      panic("too many args");
     6bc:	bf 8d 12 00 00       	mov    $0x128d,%edi
     6c1:	e8 8b f9 ff ff       	call   51 <panic>
  cmd->argv[argc] = 0;
     6c6:	48 63 db             	movslq %ebx,%rbx
     6c9:	49 c7 44 df 08 00 00 	movq   $0x0,0x8(%r15,%rbx,8)
     6d0:	00 00 
  cmd->eargv[argc] = 0;
     6d2:	49 c7 44 df 58 00 00 	movq   $0x0,0x58(%r15,%rbx,8)
     6d9:	00 00 
  return ret;
     6db:	e9 62 ff ff ff       	jmp    642 <parseexec+0x50>

00000000000006e0 <parsepipe>:
{
     6e0:	55                   	push   %rbp
     6e1:	48 89 e5             	mov    %rsp,%rbp
     6e4:	41 55                	push   %r13
     6e6:	41 54                	push   %r12
     6e8:	53                   	push   %rbx
     6e9:	48 83 ec 08          	sub    $0x8,%rsp
     6ed:	48 89 fb             	mov    %rdi,%rbx
     6f0:	49 89 f4             	mov    %rsi,%r12
  cmd = parseexec(ps, es);
     6f3:	e8 fa fe ff ff       	call   5f2 <parseexec>
     6f8:	49 89 c5             	mov    %rax,%r13
  if(peek(ps, es, "|")){
     6fb:	ba a0 12 00 00       	mov    $0x12a0,%edx
     700:	4c 89 e6             	mov    %r12,%rsi
     703:	48 89 df             	mov    %rbx,%rdi
     706:	e8 8e fd ff ff       	call   499 <peek>
     70b:	85 c0                	test   %eax,%eax
     70d:	75 0e                	jne    71d <parsepipe+0x3d>
}
     70f:	4c 89 e8             	mov    %r13,%rax
     712:	48 83 c4 08          	add    $0x8,%rsp
     716:	5b                   	pop    %rbx
     717:	41 5c                	pop    %r12
     719:	41 5d                	pop    %r13
     71b:	5d                   	pop    %rbp
     71c:	c3                   	ret
    gettoken(ps, es, 0, 0);
     71d:	b9 00 00 00 00       	mov    $0x0,%ecx
     722:	ba 00 00 00 00       	mov    $0x0,%edx
     727:	4c 89 e6             	mov    %r12,%rsi
     72a:	48 89 df             	mov    %rbx,%rdi
     72d:	e8 43 fc ff ff       	call   375 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     732:	4c 89 e6             	mov    %r12,%rsi
     735:	48 89 df             	mov    %rbx,%rdi
     738:	e8 a3 ff ff ff       	call   6e0 <parsepipe>
     73d:	48 89 c6             	mov    %rax,%rsi
     740:	4c 89 ef             	mov    %r13,%rdi
     743:	e8 56 fb ff ff       	call   29e <pipecmd>
     748:	49 89 c5             	mov    %rax,%r13
  return cmd;
     74b:	eb c2                	jmp    70f <parsepipe+0x2f>

000000000000074d <parseline>:
{
     74d:	55                   	push   %rbp
     74e:	48 89 e5             	mov    %rsp,%rbp
     751:	41 55                	push   %r13
     753:	41 54                	push   %r12
     755:	53                   	push   %rbx
     756:	48 83 ec 08          	sub    $0x8,%rsp
     75a:	49 89 fc             	mov    %rdi,%r12
     75d:	49 89 f5             	mov    %rsi,%r13
  cmd = parsepipe(ps, es);
     760:	e8 7b ff ff ff       	call   6e0 <parsepipe>
     765:	48 89 c3             	mov    %rax,%rbx
  while(peek(ps, es, "&")){
     768:	eb 20                	jmp    78a <parseline+0x3d>
    gettoken(ps, es, 0, 0);
     76a:	b9 00 00 00 00       	mov    $0x0,%ecx
     76f:	ba 00 00 00 00       	mov    $0x0,%edx
     774:	4c 89 ee             	mov    %r13,%rsi
     777:	4c 89 e7             	mov    %r12,%rdi
     77a:	e8 f6 fb ff ff       	call   375 <gettoken>
    cmd = backcmd(cmd);
     77f:	48 89 df             	mov    %rbx,%rdi
     782:	e8 b3 fb ff ff       	call   33a <backcmd>
     787:	48 89 c3             	mov    %rax,%rbx
  while(peek(ps, es, "&")){
     78a:	ba a2 12 00 00       	mov    $0x12a2,%edx
     78f:	4c 89 ee             	mov    %r13,%rsi
     792:	4c 89 e7             	mov    %r12,%rdi
     795:	e8 ff fc ff ff       	call   499 <peek>
     79a:	85 c0                	test   %eax,%eax
     79c:	75 cc                	jne    76a <parseline+0x1d>
  if(peek(ps, es, ";")){
     79e:	ba 9e 12 00 00       	mov    $0x129e,%edx
     7a3:	4c 89 ee             	mov    %r13,%rsi
     7a6:	4c 89 e7             	mov    %r12,%rdi
     7a9:	e8 eb fc ff ff       	call   499 <peek>
     7ae:	85 c0                	test   %eax,%eax
     7b0:	75 0e                	jne    7c0 <parseline+0x73>
}
     7b2:	48 89 d8             	mov    %rbx,%rax
     7b5:	48 83 c4 08          	add    $0x8,%rsp
     7b9:	5b                   	pop    %rbx
     7ba:	41 5c                	pop    %r12
     7bc:	41 5d                	pop    %r13
     7be:	5d                   	pop    %rbp
     7bf:	c3                   	ret
    gettoken(ps, es, 0, 0);
     7c0:	b9 00 00 00 00       	mov    $0x0,%ecx
     7c5:	ba 00 00 00 00       	mov    $0x0,%edx
     7ca:	4c 89 ee             	mov    %r13,%rsi
     7cd:	4c 89 e7             	mov    %r12,%rdi
     7d0:	e8 a0 fb ff ff       	call   375 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     7d5:	4c 89 ee             	mov    %r13,%rsi
     7d8:	4c 89 e7             	mov    %r12,%rdi
     7db:	e8 6d ff ff ff       	call   74d <parseline>
     7e0:	48 89 c6             	mov    %rax,%rsi
     7e3:	48 89 df             	mov    %rbx,%rdi
     7e6:	e8 01 fb ff ff       	call   2ec <listcmd>
     7eb:	48 89 c3             	mov    %rax,%rbx
  return cmd;
     7ee:	eb c2                	jmp    7b2 <parseline+0x65>

00000000000007f0 <parseblock>:
{
     7f0:	55                   	push   %rbp
     7f1:	48 89 e5             	mov    %rsp,%rbp
     7f4:	41 55                	push   %r13
     7f6:	41 54                	push   %r12
     7f8:	53                   	push   %rbx
     7f9:	48 83 ec 08          	sub    $0x8,%rsp
     7fd:	48 89 fb             	mov    %rdi,%rbx
     800:	49 89 f4             	mov    %rsi,%r12
  if(!peek(ps, es, "("))
     803:	ba 84 12 00 00       	mov    $0x1284,%edx
     808:	e8 8c fc ff ff       	call   499 <peek>
     80d:	85 c0                	test   %eax,%eax
     80f:	74 65                	je     876 <parseblock+0x86>
  gettoken(ps, es, 0, 0);
     811:	b9 00 00 00 00       	mov    $0x0,%ecx
     816:	ba 00 00 00 00       	mov    $0x0,%edx
     81b:	4c 89 e6             	mov    %r12,%rsi
     81e:	48 89 df             	mov    %rbx,%rdi
     821:	e8 4f fb ff ff       	call   375 <gettoken>
  cmd = parseline(ps, es);
     826:	4c 89 e6             	mov    %r12,%rsi
     829:	48 89 df             	mov    %rbx,%rdi
     82c:	e8 1c ff ff ff       	call   74d <parseline>
     831:	49 89 c5             	mov    %rax,%r13
  if(!peek(ps, es, ")"))
     834:	ba c0 12 00 00       	mov    $0x12c0,%edx
     839:	4c 89 e6             	mov    %r12,%rsi
     83c:	48 89 df             	mov    %rbx,%rdi
     83f:	e8 55 fc ff ff       	call   499 <peek>
     844:	85 c0                	test   %eax,%eax
     846:	74 38                	je     880 <parseblock+0x90>
  gettoken(ps, es, 0, 0);
     848:	b9 00 00 00 00       	mov    $0x0,%ecx
     84d:	ba 00 00 00 00       	mov    $0x0,%edx
     852:	4c 89 e6             	mov    %r12,%rsi
     855:	48 89 df             	mov    %rbx,%rdi
     858:	e8 18 fb ff ff       	call   375 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     85d:	4c 89 e2             	mov    %r12,%rdx
     860:	48 89 de             	mov    %rbx,%rsi
     863:	4c 89 ef             	mov    %r13,%rdi
     866:	e8 9c fc ff ff       	call   507 <parseredirs>
}
     86b:	48 83 c4 08          	add    $0x8,%rsp
     86f:	5b                   	pop    %rbx
     870:	41 5c                	pop    %r12
     872:	41 5d                	pop    %r13
     874:	5d                   	pop    %rbp
     875:	c3                   	ret
    panic("parseblock");
     876:	bf a4 12 00 00       	mov    $0x12a4,%edi
     87b:	e8 d1 f7 ff ff       	call   51 <panic>
    panic("syntax - missing )");
     880:	bf af 12 00 00       	mov    $0x12af,%edi
     885:	e8 c7 f7 ff ff       	call   51 <panic>

000000000000088a <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     88a:	55                   	push   %rbp
     88b:	48 89 e5             	mov    %rsp,%rbp
     88e:	53                   	push   %rbx
     88f:	48 83 ec 08          	sub    $0x8,%rsp
     893:	48 89 fb             	mov    %rdi,%rbx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     896:	48 85 ff             	test   %rdi,%rdi
     899:	74 3e                	je     8d9 <nulterminate+0x4f>
    return 0;

  switch(cmd->type){
     89b:	8b 07                	mov    (%rdi),%eax
     89d:	83 f8 05             	cmp    $0x5,%eax
     8a0:	77 37                	ja     8d9 <nulterminate+0x4f>
     8a2:	89 c0                	mov    %eax,%eax
     8a4:	ff 24 c5 20 13 00 00 	jmp    *0x1320(,%rax,8)
     8ab:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     8b2:	00 00 00 00 
     8b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
     8bd:	00 00 00 
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      *ecmd->eargv[i] = 0;
     8c0:	48 63 d0             	movslq %eax,%rdx
     8c3:	48 8b 54 d3 58       	mov    0x58(%rbx,%rdx,8),%rdx
     8c8:	c6 02 00             	movb   $0x0,(%rdx)
    for(i=0; ecmd->argv[i]; i++)
     8cb:	83 c0 01             	add    $0x1,%eax
     8ce:	48 63 d0             	movslq %eax,%rdx
     8d1:	48 83 7c d3 08 00    	cmpq   $0x0,0x8(%rbx,%rdx,8)
     8d7:	75 e7                	jne    8c0 <nulterminate+0x36>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     8d9:	48 89 d8             	mov    %rbx,%rax
     8dc:	48 83 c4 08          	add    $0x8,%rsp
     8e0:	5b                   	pop    %rbx
     8e1:	5d                   	pop    %rbp
     8e2:	c3                   	ret
  switch(cmd->type){
     8e3:	b8 00 00 00 00       	mov    $0x0,%eax
     8e8:	eb e4                	jmp    8ce <nulterminate+0x44>
    nulterminate(rcmd->cmd);
     8ea:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
     8ee:	e8 97 ff ff ff       	call   88a <nulterminate>
    *rcmd->efile = 0;
     8f3:	48 8b 43 18          	mov    0x18(%rbx),%rax
     8f7:	c6 00 00             	movb   $0x0,(%rax)
    break;
     8fa:	eb dd                	jmp    8d9 <nulterminate+0x4f>
    nulterminate(pcmd->left);
     8fc:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
     900:	e8 85 ff ff ff       	call   88a <nulterminate>
    nulterminate(pcmd->right);
     905:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
     909:	e8 7c ff ff ff       	call   88a <nulterminate>
    break;
     90e:	eb c9                	jmp    8d9 <nulterminate+0x4f>
    nulterminate(lcmd->left);
     910:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
     914:	e8 71 ff ff ff       	call   88a <nulterminate>
    nulterminate(lcmd->right);
     919:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
     91d:	e8 68 ff ff ff       	call   88a <nulterminate>
    break;
     922:	eb b5                	jmp    8d9 <nulterminate+0x4f>
    nulterminate(bcmd->cmd);
     924:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
     928:	e8 5d ff ff ff       	call   88a <nulterminate>
    break;
     92d:	eb aa                	jmp    8d9 <nulterminate+0x4f>

000000000000092f <parsecmd>:
{
     92f:	55                   	push   %rbp
     930:	48 89 e5             	mov    %rsp,%rbp
     933:	41 55                	push   %r13
     935:	41 54                	push   %r12
     937:	53                   	push   %rbx
     938:	48 83 ec 18          	sub    $0x18,%rsp
     93c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  es = s + strlen(s);
     940:	48 89 fb             	mov    %rdi,%rbx
     943:	e8 99 01 00 00       	call   ae1 <strlen>
     948:	89 c0                	mov    %eax,%eax
     94a:	48 01 c3             	add    %rax,%rbx
  cmd = parseline(&s, es);
     94d:	4c 8d 6d d8          	lea    -0x28(%rbp),%r13
     951:	48 89 de             	mov    %rbx,%rsi
     954:	4c 89 ef             	mov    %r13,%rdi
     957:	e8 f1 fd ff ff       	call   74d <parseline>
     95c:	49 89 c4             	mov    %rax,%r12
  peek(&s, es, "");
     95f:	ba 4e 12 00 00       	mov    $0x124e,%edx
     964:	48 89 de             	mov    %rbx,%rsi
     967:	4c 89 ef             	mov    %r13,%rdi
     96a:	e8 2a fb ff ff       	call   499 <peek>
  if(s != es){
     96f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
     973:	48 39 da             	cmp    %rbx,%rdx
     976:	75 16                	jne    98e <parsecmd+0x5f>
  nulterminate(cmd);
     978:	4c 89 e7             	mov    %r12,%rdi
     97b:	e8 0a ff ff ff       	call   88a <nulterminate>
}
     980:	4c 89 e0             	mov    %r12,%rax
     983:	48 83 c4 18          	add    $0x18,%rsp
     987:	5b                   	pop    %rbx
     988:	41 5c                	pop    %r12
     98a:	41 5d                	pop    %r13
     98c:	5d                   	pop    %rbp
     98d:	c3                   	ret
    printf(2, "leftovers: %s\n", s);
     98e:	be c2 12 00 00       	mov    $0x12c2,%esi
     993:	bf 02 00 00 00       	mov    $0x2,%edi
     998:	b0 00                	mov    $0x0,%al
     99a:	e8 c6 04 00 00       	call   e65 <printf>
    panic("syntax");
     99f:	bf 86 12 00 00       	mov    $0x1286,%edi
     9a4:	e8 a8 f6 ff ff       	call   51 <panic>

00000000000009a9 <main>:
{
     9a9:	55                   	push   %rbp
     9aa:	48 89 e5             	mov    %rsp,%rbp
  while((fd = open("console", O_RDWR)) >= 0){
     9ad:	be 02 00 00 00       	mov    $0x2,%esi
     9b2:	bf d1 12 00 00       	mov    $0x12d1,%edi
     9b7:	e8 16 03 00 00       	call   cd2 <open>
     9bc:	85 c0                	test   %eax,%eax
     9be:	78 1c                	js     9dc <main+0x33>
    if(fd >= 3){
     9c0:	83 f8 02             	cmp    $0x2,%eax
     9c3:	7e e8                	jle    9ad <main+0x4>
      close(fd);
     9c5:	89 c7                	mov    %eax,%edi
     9c7:	e8 e8 02 00 00       	call   cb4 <close>
      break;
     9cc:	eb 0e                	jmp    9dc <main+0x33>
    if(fork1() == 0)
     9ce:	e8 9b f6 ff ff       	call   6e <fork1>
     9d3:	85 c0                	test   %eax,%eax
     9d5:	74 76                	je     a4d <main+0xa4>
    wait();
     9d7:	e8 b0 02 00 00       	call   c8c <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     9dc:	be 64 00 00 00       	mov    $0x64,%esi
     9e1:	bf e0 18 00 00       	mov    $0x18e0,%edi
     9e6:	e8 15 f6 ff ff       	call   0 <getcmd>
     9eb:	85 c0                	test   %eax,%eax
     9ed:	78 70                	js     a5f <main+0xb6>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     9ef:	0f be 05 ea 0e 00 00 	movsbl 0xeea(%rip),%eax        # 18e0 <buf.0>
     9f6:	83 f8 63             	cmp    $0x63,%eax
     9f9:	75 d3                	jne    9ce <main+0x25>
     9fb:	0f be 05 df 0e 00 00 	movsbl 0xedf(%rip),%eax        # 18e1 <buf.0+0x1>
     a02:	83 f8 64             	cmp    $0x64,%eax
     a05:	75 c7                	jne    9ce <main+0x25>
     a07:	0f be 05 d4 0e 00 00 	movsbl 0xed4(%rip),%eax        # 18e2 <buf.0+0x2>
     a0e:	83 f8 20             	cmp    $0x20,%eax
     a11:	75 bb                	jne    9ce <main+0x25>
      buf[strlen(buf)-1] = 0;  // chop \n
     a13:	bf e0 18 00 00       	mov    $0x18e0,%edi
     a18:	e8 c4 00 00 00       	call   ae1 <strlen>
     a1d:	8d 40 ff             	lea    -0x1(%rax),%eax
     a20:	c6 80 e0 18 00 00 00 	movb   $0x0,0x18e0(%rax)
      if(chdir(buf+3) < 0)
     a27:	bf e3 18 00 00       	mov    $0x18e3,%edi
     a2c:	e8 dd 02 00 00       	call   d0e <chdir>
     a31:	85 c0                	test   %eax,%eax
     a33:	79 a7                	jns    9dc <main+0x33>
        printf(2, "cannot cd %s\n", buf+3);
     a35:	ba e3 18 00 00       	mov    $0x18e3,%edx
     a3a:	be d9 12 00 00       	mov    $0x12d9,%esi
     a3f:	bf 02 00 00 00       	mov    $0x2,%edi
     a44:	b0 00                	mov    $0x0,%al
     a46:	e8 1a 04 00 00       	call   e65 <printf>
      continue;
     a4b:	eb 8f                	jmp    9dc <main+0x33>
      runcmd(parsecmd(buf));
     a4d:	bf e0 18 00 00       	mov    $0x18e0,%edi
     a52:	e8 d8 fe ff ff       	call   92f <parsecmd>
     a57:	48 89 c7             	mov    %rax,%rdi
     a5a:	e8 29 f6 ff ff       	call   88 <runcmd>
  exit();
     a5f:	e8 1e 02 00 00       	call   c82 <exit>
     a64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
     a6b:	00 00 00 
     a6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
     a75:	00 00 00 
     a78:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
     a7f:	00 

0000000000000a80 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     a80:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     a83:	48 89 f9             	mov    %rdi,%rcx
     a86:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     a8d:	00 00 00 00 
     a91:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     a98:	00 00 00 00 
     a9c:	0f 1f 40 00          	nopl   0x0(%rax)
     aa0:	48 89 f2             	mov    %rsi,%rdx
     aa3:	48 83 c6 01          	add    $0x1,%rsi
     aa7:	49 89 c8             	mov    %rcx,%r8
     aaa:	48 83 c1 01          	add    $0x1,%rcx
     aae:	8a 12                	mov    (%rdx),%dl
     ab0:	41 88 10             	mov    %dl,(%r8)
     ab3:	0f be d2             	movsbl %dl,%edx
     ab6:	85 d2                	test   %edx,%edx
     ab8:	75 e6                	jne    aa0 <strcpy+0x20>
    ;
  return os;
}
     aba:	c3                   	ret

0000000000000abb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     abb:	eb 0b                	jmp    ac8 <strcmp+0xd>
     abd:	0f 1f 00             	nopl   (%rax)
    p++, q++;
     ac0:	48 83 c7 01          	add    $0x1,%rdi
     ac4:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
     ac8:	8a 07                	mov    (%rdi),%al
     aca:	0f be d0             	movsbl %al,%edx
     acd:	85 d2                	test   %edx,%edx
     acf:	74 07                	je     ad8 <strcmp+0x1d>
     ad1:	0f be 0e             	movsbl (%rsi),%ecx
     ad4:	39 ca                	cmp    %ecx,%edx
     ad6:	74 e8                	je     ac0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
     ad8:	0f b6 c0             	movzbl %al,%eax
     adb:	0f b6 16             	movzbl (%rsi),%edx
     ade:	29 d0                	sub    %edx,%eax
}
     ae0:	c3                   	ret

0000000000000ae1 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
     ae1:	b8 00 00 00 00       	mov    $0x0,%eax
     ae6:	eb 0b                	jmp    af3 <strlen+0x12>
     ae8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
     aef:	00 
     af0:	83 c0 01             	add    $0x1,%eax
     af3:	48 63 d0             	movslq %eax,%rdx
     af6:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
     afa:	85 d2                	test   %edx,%edx
     afc:	75 f2                	jne    af0 <strlen+0xf>
    ;
  return n;
}
     afe:	c3                   	ret

0000000000000aff <memset>:

void*
memset(void *dst, int c, uint n)
{
     aff:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
     b02:	89 d1                	mov    %edx,%ecx
     b04:	89 f0                	mov    %esi,%eax
     b06:	fc                   	cld
     b07:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
     b09:	4c 89 c0             	mov    %r8,%rax
     b0c:	c3                   	ret

0000000000000b0d <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     b0d:	eb 15                	jmp    b24 <strchr+0x17>
     b0f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     b16:	00 00 00 00 
     b1a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
     b20:	48 83 c7 01          	add    $0x1,%rdi
     b24:	8a 17                	mov    (%rdi),%dl
     b26:	0f be c2             	movsbl %dl,%eax
     b29:	85 c0                	test   %eax,%eax
     b2b:	74 0f                	je     b3c <strchr+0x2f>
    if(*s == c)
     b2d:	0f be d2             	movsbl %dl,%edx
     b30:	40 0f be c6          	movsbl %sil,%eax
     b34:	39 c2                	cmp    %eax,%edx
     b36:	75 e8                	jne    b20 <strchr+0x13>
      return (char*)s;
     b38:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
     b3b:	c3                   	ret
  return 0;
     b3c:	b8 00 00 00 00       	mov    $0x0,%eax
     b41:	c3                   	ret

0000000000000b42 <gets>:

char*
gets(char *buf, int max)
{
     b42:	55                   	push   %rbp
     b43:	48 89 e5             	mov    %rsp,%rbp
     b46:	41 56                	push   %r14
     b48:	41 55                	push   %r13
     b4a:	41 54                	push   %r12
     b4c:	53                   	push   %rbx
     b4d:	48 83 ec 10          	sub    $0x10,%rsp
     b51:	49 89 fc             	mov    %rdi,%r12
     b54:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b57:	bb 00 00 00 00       	mov    $0x0,%ebx
     b5c:	41 89 de             	mov    %ebx,%r14d
     b5f:	83 c3 01             	add    $0x1,%ebx
     b62:	44 39 eb             	cmp    %r13d,%ebx
     b65:	7d 39                	jge    ba0 <gets+0x5e>
    cc = read(0, &c, 1);
     b67:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
     b6b:	ba 01 00 00 00       	mov    $0x1,%edx
     b70:	bf 00 00 00 00       	mov    $0x0,%edi
     b75:	e8 26 01 00 00       	call   ca0 <read>
    if(cc < 1)
     b7a:	85 c0                	test   %eax,%eax
     b7c:	7e 22                	jle    ba0 <gets+0x5e>
      break;
    buf[i++] = c;
     b7e:	4d 63 f6             	movslq %r14d,%r14
     b81:	8a 45 df             	mov    -0x21(%rbp),%al
     b84:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
     b88:	0f be c0             	movsbl %al,%eax
     b8b:	83 f8 0a             	cmp    $0xa,%eax
     b8e:	0f 94 c2             	sete   %dl
     b91:	83 f8 0d             	cmp    $0xd,%eax
     b94:	0f 94 c0             	sete   %al
     b97:	09 d0                	or     %edx,%eax
     b99:	a8 ff                	test   $0xff,%al
     b9b:	74 bf                	je     b5c <gets+0x1a>
    buf[i++] = c;
     b9d:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
     ba0:	4d 63 f6             	movslq %r14d,%r14
     ba3:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
     ba8:	4c 89 e0             	mov    %r12,%rax
     bab:	48 83 c4 10          	add    $0x10,%rsp
     baf:	5b                   	pop    %rbx
     bb0:	41 5c                	pop    %r12
     bb2:	41 5d                	pop    %r13
     bb4:	41 5e                	pop    %r14
     bb6:	5d                   	pop    %rbp
     bb7:	c3                   	ret

0000000000000bb8 <stat>:

int
stat(const char *n, struct stat *st)
{
     bb8:	55                   	push   %rbp
     bb9:	48 89 e5             	mov    %rsp,%rbp
     bbc:	41 54                	push   %r12
     bbe:	53                   	push   %rbx
     bbf:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     bc2:	be 00 00 00 00       	mov    $0x0,%esi
     bc7:	e8 06 01 00 00       	call   cd2 <open>
  if(fd < 0)
     bcc:	85 c0                	test   %eax,%eax
     bce:	78 1e                	js     bee <stat+0x36>
     bd0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
     bd2:	4c 89 e6             	mov    %r12,%rsi
     bd5:	89 c7                	mov    %eax,%edi
     bd7:	e8 14 01 00 00       	call   cf0 <fstat>
     bdc:	41 89 c4             	mov    %eax,%r12d
  close(fd);
     bdf:	89 df                	mov    %ebx,%edi
     be1:	e8 ce 00 00 00       	call   cb4 <close>
  return r;
}
     be6:	44 89 e0             	mov    %r12d,%eax
     be9:	5b                   	pop    %rbx
     bea:	41 5c                	pop    %r12
     bec:	5d                   	pop    %rbp
     bed:	c3                   	ret
    return -1;
     bee:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
     bf4:	eb f0                	jmp    be6 <stat+0x2e>

0000000000000bf6 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
     bf6:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
     bfb:	eb 09                	jmp    c06 <atoi+0x10>
     bfd:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
     c00:	f7 de                	neg    %esi
    s++;
     c02:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
     c06:	0f be 07             	movsbl (%rdi),%eax
     c09:	83 f8 2d             	cmp    $0x2d,%eax
     c0c:	74 f2                	je     c00 <atoi+0xa>
  n = 0;
     c0e:	b8 00 00 00 00       	mov    $0x0,%eax
     c13:	eb 19                	jmp    c2e <atoi+0x38>
     c15:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     c1c:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
     c20:	8d 04 80             	lea    (%rax,%rax,4),%eax
     c23:	48 83 c7 01          	add    $0x1,%rdi
     c27:	0f be d2             	movsbl %dl,%edx
     c2a:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
     c2e:	8a 17                	mov    (%rdi),%dl
     c30:	8d 4a d0             	lea    -0x30(%rdx),%ecx
     c33:	0f b6 c9             	movzbl %cl,%ecx
     c36:	83 f9 09             	cmp    $0x9,%ecx
     c39:	76 e5                	jbe    c20 <atoi+0x2a>
  return sign * n;
     c3b:	0f af c6             	imul   %esi,%eax
}
     c3e:	c3                   	ret

0000000000000c3f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     c3f:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
     c42:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
     c45:	eb 28                	jmp    c6f <memmove+0x30>
     c47:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     c4e:	00 00 00 00 
     c52:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
     c59:	00 00 00 00 
     c5d:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
     c60:	8a 16                	mov    (%rsi),%dl
     c62:	88 11                	mov    %dl,(%rcx)
     c64:	48 8d 76 01          	lea    0x1(%rsi),%rsi
     c68:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
     c6c:	44 89 c2             	mov    %r8d,%edx
     c6f:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
     c73:	85 d2                	test   %edx,%edx
     c75:	7f e9                	jg     c60 <memmove+0x21>
  return vdst;
}
     c77:	c3                   	ret

0000000000000c78 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     c78:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
     c7f:	cd 40                	int    $0x40
     c81:	c3                   	ret

0000000000000c82 <exit>:
SYSCALL(exit)
     c82:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
     c89:	cd 40                	int    $0x40
     c8b:	c3                   	ret

0000000000000c8c <wait>:
SYSCALL(wait)
     c8c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
     c93:	cd 40                	int    $0x40
     c95:	c3                   	ret

0000000000000c96 <pipe>:
SYSCALL(pipe)
     c96:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
     c9d:	cd 40                	int    $0x40
     c9f:	c3                   	ret

0000000000000ca0 <read>:
SYSCALL(read)
     ca0:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
     ca7:	cd 40                	int    $0x40
     ca9:	c3                   	ret

0000000000000caa <write>:
SYSCALL(write)
     caa:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
     cb1:	cd 40                	int    $0x40
     cb3:	c3                   	ret

0000000000000cb4 <close>:
SYSCALL(close)
     cb4:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
     cbb:	cd 40                	int    $0x40
     cbd:	c3                   	ret

0000000000000cbe <kill>:
SYSCALL(kill)
     cbe:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
     cc5:	cd 40                	int    $0x40
     cc7:	c3                   	ret

0000000000000cc8 <exec>:
SYSCALL(exec)
     cc8:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
     ccf:	cd 40                	int    $0x40
     cd1:	c3                   	ret

0000000000000cd2 <open>:
SYSCALL(open)
     cd2:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
     cd9:	cd 40                	int    $0x40
     cdb:	c3                   	ret

0000000000000cdc <mknod>:
SYSCALL(mknod)
     cdc:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
     ce3:	cd 40                	int    $0x40
     ce5:	c3                   	ret

0000000000000ce6 <unlink>:
SYSCALL(unlink)
     ce6:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
     ced:	cd 40                	int    $0x40
     cef:	c3                   	ret

0000000000000cf0 <fstat>:
SYSCALL(fstat)
     cf0:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
     cf7:	cd 40                	int    $0x40
     cf9:	c3                   	ret

0000000000000cfa <link>:
SYSCALL(link)
     cfa:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
     d01:	cd 40                	int    $0x40
     d03:	c3                   	ret

0000000000000d04 <mkdir>:
SYSCALL(mkdir)
     d04:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
     d0b:	cd 40                	int    $0x40
     d0d:	c3                   	ret

0000000000000d0e <chdir>:
SYSCALL(chdir)
     d0e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
     d15:	cd 40                	int    $0x40
     d17:	c3                   	ret

0000000000000d18 <dup>:
SYSCALL(dup)
     d18:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
     d1f:	cd 40                	int    $0x40
     d21:	c3                   	ret

0000000000000d22 <getpid>:
SYSCALL(getpid)
     d22:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
     d29:	cd 40                	int    $0x40
     d2b:	c3                   	ret

0000000000000d2c <sbrk>:
SYSCALL(sbrk)
     d2c:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
     d33:	cd 40                	int    $0x40
     d35:	c3                   	ret

0000000000000d36 <sleep>:
SYSCALL(sleep)
     d36:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
     d3d:	cd 40                	int    $0x40
     d3f:	c3                   	ret

0000000000000d40 <uptime>:
SYSCALL(uptime)
     d40:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
     d47:	cd 40                	int    $0x40
     d49:	c3                   	ret

0000000000000d4a <vmcreate>:
SYSCALL(vmcreate)
     d4a:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
     d51:	cd 40                	int    $0x40
     d53:	c3                   	ret

0000000000000d54 <vmsetreg>:
SYSCALL(vmsetreg)
     d54:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
     d5b:	cd 40                	int    $0x40
     d5d:	c3                   	ret

0000000000000d5e <vmrun>:
SYSCALL(vmrun)
     d5e:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
     d65:	cd 40                	int    $0x40
     d67:	c3                   	ret

0000000000000d68 <vmgetreg>:
SYSCALL(vmgetreg)
     d68:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
     d6f:	cd 40                	int    $0x40
     d71:	c3                   	ret
     d72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
     d79:	00 00 00 
     d7c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000d80 <_va_arg>:
// Retrieve the next argument from the va_list.
static inline void *_va_arg(va_list *args)
{
    // Returns the next argument from registers if _index < 6, 
    // otherwise from the stack.
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
     d80:	8b 47 38             	mov    0x38(%rdi),%eax
     d83:	83 f8 05             	cmp    $0x5,%eax
     d86:	77 0d                	ja     d95 <_va_arg+0x15>
     d88:	8d 50 01             	lea    0x1(%rax),%edx
     d8b:	89 57 38             	mov    %edx,0x38(%rdi)
     d8e:	89 c0                	mov    %eax,%eax
     d90:	48 8b 04 c7          	mov    (%rdi,%rax,8),%rax
     d94:	c3                   	ret
                                  : args->more_argint[(args->_index++)-6]);
     d95:	8d 50 01             	lea    0x1(%rax),%edx
     d98:	89 57 38             	mov    %edx,0x38(%rdi)
     d9b:	8d 40 fa             	lea    -0x6(%rax),%eax
     d9e:	48 c1 e0 03          	shl    $0x3,%rax
     da2:	48 03 47 30          	add    0x30(%rdi),%rax
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
     da6:	48 8b 00             	mov    (%rax),%rax
}
     da9:	c3                   	ret

0000000000000daa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     daa:	55                   	push   %rbp
     dab:	48 89 e5             	mov    %rsp,%rbp
     dae:	48 83 ec 10          	sub    $0x10,%rsp
     db2:	40 88 75 fc          	mov    %sil,-0x4(%rbp)
  write(fd, &c, 1);
     db6:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
     dba:	ba 01 00 00 00       	mov    $0x1,%edx
     dbf:	e8 e6 fe ff ff       	call   caa <write>
}
     dc4:	48 89 ec             	mov    %rbp,%rsp
     dc7:	5d                   	pop    %rbp
     dc8:	c3                   	ret

0000000000000dc9 <printint>:

static void
printint(int fd, int64 xx, int base, int sgn)
{
     dc9:	55                   	push   %rbp
     dca:	48 89 e5             	mov    %rsp,%rbp
     dcd:	41 54                	push   %r12
     dcf:	53                   	push   %rbx
     dd0:	48 83 ec 10          	sub    $0x10,%rsp
     dd4:	41 89 fc             	mov    %edi,%r12d
     dd7:	41 89 d1             	mov    %edx,%r9d
  char buf[16];
  int i, neg;
  uint64 x;

  neg = 0;
  if(sgn && xx < 0){
     dda:	85 c9                	test   %ecx,%ecx
     ddc:	0f 95 c2             	setne  %dl
     ddf:	48 89 f0             	mov    %rsi,%rax
     de2:	48 c1 e8 3f          	shr    $0x3f,%rax
     de6:	85 c2                	test   %eax,%edx
     de8:	74 55                	je     e3f <printint+0x76>
    neg = 1;
    x = -xx;
     dea:	48 f7 de             	neg    %rsi
    neg = 1;
     ded:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  } else {
    x = xx;
  }

  i = 0;
     df3:	bb 00 00 00 00       	mov    $0x0,%ebx
     df8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
     dff:	00 
  do{
    buf[i++] = digits[x % base];
     e00:	49 63 c9             	movslq %r9d,%rcx
     e03:	48 89 f0             	mov    %rsi,%rax
     e06:	ba 00 00 00 00       	mov    $0x0,%edx
     e0b:	48 f7 f1             	div    %rcx
     e0e:	89 df                	mov    %ebx,%edi
     e10:	83 c3 01             	add    $0x1,%ebx
     e13:	44 8a 82 00 14 00 00 	mov    0x1400(%rdx),%r8b
     e1a:	48 63 d7             	movslq %edi,%rdx
     e1d:	44 88 44 15 e0       	mov    %r8b,-0x20(%rbp,%rdx,1)
  }while((x /= base) != 0);
     e22:	48 89 f2             	mov    %rsi,%rdx
     e25:	48 89 c6             	mov    %rax,%rsi
     e28:	48 39 ca             	cmp    %rcx,%rdx
     e2b:	73 d3                	jae    e00 <printint+0x37>
  if(neg)
     e2d:	45 85 d2             	test   %r10d,%r10d
     e30:	74 25                	je     e57 <printint+0x8e>
    buf[i++] = '-';
     e32:	48 63 db             	movslq %ebx,%rbx
     e35:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
     e3a:	8d 5f 02             	lea    0x2(%rdi),%ebx
     e3d:	eb 18                	jmp    e57 <printint+0x8e>
  neg = 0;
     e3f:	41 ba 00 00 00 00    	mov    $0x0,%r10d
     e45:	eb ac                	jmp    df3 <printint+0x2a>

  while(--i >= 0)
    putc(fd, buf[i]);
     e47:	48 63 c3             	movslq %ebx,%rax
     e4a:	0f be 74 05 e0       	movsbl -0x20(%rbp,%rax,1),%esi
     e4f:	44 89 e7             	mov    %r12d,%edi
     e52:	e8 53 ff ff ff       	call   daa <putc>
  while(--i >= 0)
     e57:	83 eb 01             	sub    $0x1,%ebx
     e5a:	79 eb                	jns    e47 <printint+0x7e>
}
     e5c:	48 83 c4 10          	add    $0x10,%rsp
     e60:	5b                   	pop    %rbx
     e61:	41 5c                	pop    %r12
     e63:	5d                   	pop    %rbp
     e64:	c3                   	ret

0000000000000e65 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     e65:	55                   	push   %rbp
     e66:	48 89 e5             	mov    %rsp,%rbp
     e69:	41 57                	push   %r15
     e6b:	41 56                	push   %r14
     e6d:	41 55                	push   %r13
     e6f:	41 54                	push   %r12
     e71:	53                   	push   %rbx
     e72:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
     e79:	41 89 ff             	mov    %edi,%r15d
     e7c:	49 89 f5             	mov    %rsi,%r13
     e7f:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
     e86:	48 89 8d 38 ff ff ff 	mov    %rcx,-0xc8(%rbp)
     e8d:	4c 89 85 40 ff ff ff 	mov    %r8,-0xc0(%rbp)
     e94:	4c 89 8d 48 ff ff ff 	mov    %r9,-0xb8(%rbp)
     e9b:	84 c0                	test   %al,%al
     e9d:	74 29                	je     ec8 <printf+0x63>
     e9f:	0f 29 85 50 ff ff ff 	movaps %xmm0,-0xb0(%rbp)
     ea6:	0f 29 8d 60 ff ff ff 	movaps %xmm1,-0xa0(%rbp)
     ead:	0f 29 95 70 ff ff ff 	movaps %xmm2,-0x90(%rbp)
     eb4:	0f 29 5d 80          	movaps %xmm3,-0x80(%rbp)
     eb8:	0f 29 65 90          	movaps %xmm4,-0x70(%rbp)
     ebc:	0f 29 6d a0          	movaps %xmm5,-0x60(%rbp)
     ec0:	0f 29 75 b0          	movaps %xmm6,-0x50(%rbp)
     ec4:	0f 29 7d c0          	movaps %xmm7,-0x40(%rbp)
    asm volatile("movq %%rdi, %0;" 
     ec8:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
     ecf:	48 89 b5 e8 fe ff ff 	mov    %rsi,-0x118(%rbp)
     ed6:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
     edd:	48 89 8d f8 fe ff ff 	mov    %rcx,-0x108(%rbp)
     ee4:	4c 89 85 00 ff ff ff 	mov    %r8,-0x100(%rbp)
     eeb:	4c 89 8d 08 ff ff ff 	mov    %r9,-0xf8(%rbp)
    asm volatile("leaq 16(%%rbp), %0" : "=r" (args->more_argint));
     ef2:	48 8d 45 10          	lea    0x10(%rbp),%rax
     ef6:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
    args->_index = 1;
     efd:	c7 85 18 ff ff ff 01 	movl   $0x1,-0xe8(%rbp)
     f04:	00 00 00 
  char *s;
  int c, i, state;
  va_list ap;

  va_start(ap, fd);
  (void) va_arg(ap, char*); // skip fmt
     f07:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
     f0e:	e8 6d fe ff ff       	call   d80 <_va_arg>

  state = 0;
     f13:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(i = 0; fmt[i]; i++){
     f19:	bb 00 00 00 00       	mov    $0x0,%ebx
     f1e:	eb 16                	jmp    f36 <printf+0xd1>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
     f20:	44 89 f6             	mov    %r14d,%esi
     f23:	44 89 ff             	mov    %r15d,%edi
     f26:	e8 7f fe ff ff       	call   daa <putc>
     f2b:	eb 06                	jmp    f33 <printf+0xce>
      }
    } else if(state == '%'){
     f2d:	41 83 fc 25          	cmp    $0x25,%r12d
     f31:	74 2c                	je     f5f <printf+0xfa>
  for(i = 0; fmt[i]; i++){
     f33:	83 c3 01             	add    $0x1,%ebx
     f36:	48 63 c3             	movslq %ebx,%rax
     f39:	41 8a 44 05 00       	mov    0x0(%r13,%rax,1),%al
     f3e:	0f be d0             	movsbl %al,%edx
     f41:	85 d2                	test   %edx,%edx
     f43:	0f 84 42 01 00 00    	je     108b <printf+0x226>
    c = fmt[i] & 0xff;
     f49:	44 0f be f0          	movsbl %al,%r14d
     f4d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
     f50:	45 85 e4             	test   %r12d,%r12d
     f53:	75 d8                	jne    f2d <printf+0xc8>
      if(c == '%'){
     f55:	83 f8 25             	cmp    $0x25,%eax
     f58:	75 c6                	jne    f20 <printf+0xbb>
        state = '%';
     f5a:	41 89 c4             	mov    %eax,%r12d
     f5d:	eb d4                	jmp    f33 <printf+0xce>
      if(c == 'd'){
     f5f:	83 f8 25             	cmp    $0x25,%eax
     f62:	0f 84 ea 00 00 00    	je     1052 <printf+0x1ed>
     f68:	0f 8c fa 00 00 00    	jl     1068 <printf+0x203>
     f6e:	83 f8 78             	cmp    $0x78,%eax
     f71:	0f 8f f1 00 00 00    	jg     1068 <printf+0x203>
     f77:	83 f8 63             	cmp    $0x63,%eax
     f7a:	0f 8c e8 00 00 00    	jl     1068 <printf+0x203>
     f80:	83 e8 63             	sub    $0x63,%eax
     f83:	83 f8 15             	cmp    $0x15,%eax
     f86:	0f 87 dc 00 00 00    	ja     1068 <printf+0x203>
     f8c:	89 c0                	mov    %eax,%eax
     f8e:	ff 24 c5 50 13 00 00 	jmp    *0x1350(,%rax,8)
        printint(fd, va_arg(ap, int), 10, 1);
     f95:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
     f9c:	e8 df fd ff ff       	call   d80 <_va_arg>
     fa1:	48 63 f0             	movslq %eax,%rsi
     fa4:	b9 01 00 00 00       	mov    $0x1,%ecx
     fa9:	ba 0a 00 00 00       	mov    $0xa,%edx
     fae:	44 89 ff             	mov    %r15d,%edi
     fb1:	e8 13 fe ff ff       	call   dc9 <printint>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     fb6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
     fbc:	e9 72 ff ff ff       	jmp    f33 <printf+0xce>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fc1:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
     fc8:	e8 b3 fd ff ff       	call   d80 <_va_arg>
     fcd:	48 89 c6             	mov    %rax,%rsi
     fd0:	b9 00 00 00 00       	mov    $0x0,%ecx
     fd5:	ba 10 00 00 00       	mov    $0x10,%edx
     fda:	44 89 ff             	mov    %r15d,%edi
     fdd:	e8 e7 fd ff ff       	call   dc9 <printint>
      state = 0;
     fe2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
     fe8:	e9 46 ff ff ff       	jmp    f33 <printf+0xce>
        s = va_arg(ap, char*);
     fed:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
     ff4:	e8 87 fd ff ff       	call   d80 <_va_arg>
     ff9:	49 89 c4             	mov    %rax,%r12
        if(s == 0)
     ffc:	48 85 c0             	test   %rax,%rax
     fff:	75 18                	jne    1019 <printf+0x1b4>
          s = "(null)";
    1001:	41 bc e7 12 00 00    	mov    $0x12e7,%r12d
    1007:	eb 10                	jmp    1019 <printf+0x1b4>
          putc(fd, *s);
    1009:	40 0f be f6          	movsbl %sil,%esi
    100d:	44 89 ff             	mov    %r15d,%edi
    1010:	e8 95 fd ff ff       	call   daa <putc>
          s++;
    1015:	49 83 c4 01          	add    $0x1,%r12
        while(*s != 0){
    1019:	41 8a 34 24          	mov    (%r12),%sil
    101d:	40 0f be c6          	movsbl %sil,%eax
    1021:	85 c0                	test   %eax,%eax
    1023:	75 e4                	jne    1009 <printf+0x1a4>
      state = 0;
    1025:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    102b:	e9 03 ff ff ff       	jmp    f33 <printf+0xce>
        putc(fd, va_arg(ap, char));
    1030:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    1037:	e8 44 fd ff ff       	call   d80 <_va_arg>
    103c:	0f be f0             	movsbl %al,%esi
    103f:	44 89 ff             	mov    %r15d,%edi
    1042:	e8 63 fd ff ff       	call   daa <putc>
      state = 0;
    1047:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    104d:	e9 e1 fe ff ff       	jmp    f33 <printf+0xce>
        putc(fd, c);
    1052:	44 89 f6             	mov    %r14d,%esi
    1055:	44 89 ff             	mov    %r15d,%edi
    1058:	e8 4d fd ff ff       	call   daa <putc>
      state = 0;
    105d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    1063:	e9 cb fe ff ff       	jmp    f33 <printf+0xce>
        putc(fd, '%');
    1068:	be 25 00 00 00       	mov    $0x25,%esi
    106d:	44 89 ff             	mov    %r15d,%edi
    1070:	e8 35 fd ff ff       	call   daa <putc>
        putc(fd, c);
    1075:	44 89 f6             	mov    %r14d,%esi
    1078:	44 89 ff             	mov    %r15d,%edi
    107b:	e8 2a fd ff ff       	call   daa <putc>
      state = 0;
    1080:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    1086:	e9 a8 fe ff ff       	jmp    f33 <printf+0xce>
    }
  }
}
    108b:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
    1092:	5b                   	pop    %rbx
    1093:	41 5c                	pop    %r12
    1095:	41 5d                	pop    %r13
    1097:	41 5e                	pop    %r14
    1099:	41 5f                	pop    %r15
    109b:	5d                   	pop    %rbp
    109c:	c3                   	ret
    109d:	0f 1f 00             	nopl   (%rax)

00000000000010a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10a0:	48 89 fe             	mov    %rdi,%rsi
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10a3:	48 8d 4f f0          	lea    -0x10(%rdi),%rcx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10a7:	48 8b 05 a2 08 00 00 	mov    0x8a2(%rip),%rax        # 1950 <freep>
    10ae:	eb 03                	jmp    10b3 <free+0x13>
    10b0:	48 89 d0             	mov    %rdx,%rax
    10b3:	48 39 c8             	cmp    %rcx,%rax
    10b6:	73 05                	jae    10bd <free+0x1d>
    10b8:	48 3b 08             	cmp    (%rax),%rcx
    10bb:	72 17                	jb     10d4 <free+0x34>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10bd:	48 8b 10             	mov    (%rax),%rdx
    10c0:	48 39 d0             	cmp    %rdx,%rax
    10c3:	72 eb                	jb     10b0 <free+0x10>
    10c5:	48 39 c8             	cmp    %rcx,%rax
    10c8:	72 0a                	jb     10d4 <free+0x34>
    10ca:	48 39 d1             	cmp    %rdx,%rcx
    10cd:	72 05                	jb     10d4 <free+0x34>
    10cf:	48 89 d0             	mov    %rdx,%rax
    10d2:	eb df                	jmp    10b3 <free+0x13>
      break;
  if(bp + bp->s.size == p->s.ptr){
    10d4:	44 8b 46 f8          	mov    -0x8(%rsi),%r8d
    10d8:	44 89 c2             	mov    %r8d,%edx
    10db:	48 c1 e2 04          	shl    $0x4,%rdx
    10df:	48 01 ca             	add    %rcx,%rdx
    10e2:	48 8b 38             	mov    (%rax),%rdi
    10e5:	48 39 fa             	cmp    %rdi,%rdx
    10e8:	74 20                	je     110a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    10ea:	48 89 7e f0          	mov    %rdi,-0x10(%rsi)
  if(p + p->s.size == bp){
    10ee:	8b 78 08             	mov    0x8(%rax),%edi
    10f1:	89 fa                	mov    %edi,%edx
    10f3:	48 c1 e2 04          	shl    $0x4,%rdx
    10f7:	48 01 c2             	add    %rax,%rdx
    10fa:	48 39 ca             	cmp    %rcx,%rdx
    10fd:	74 1f                	je     111e <free+0x7e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    10ff:	48 89 08             	mov    %rcx,(%rax)
  freep = p;
    1102:	48 89 05 47 08 00 00 	mov    %rax,0x847(%rip)        # 1950 <freep>
}
    1109:	c3                   	ret
    bp->s.size += p->s.ptr->s.size;
    110a:	44 03 47 08          	add    0x8(%rdi),%r8d
    110e:	44 89 46 f8          	mov    %r8d,-0x8(%rsi)
    bp->s.ptr = p->s.ptr->s.ptr;
    1112:	48 8b 10             	mov    (%rax),%rdx
    1115:	48 8b 12             	mov    (%rdx),%rdx
    1118:	48 89 56 f0          	mov    %rdx,-0x10(%rsi)
    111c:	eb d0                	jmp    10ee <free+0x4e>
    p->s.size += bp->s.size;
    111e:	03 7e f8             	add    -0x8(%rsi),%edi
    1121:	89 78 08             	mov    %edi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1124:	48 8b 56 f0          	mov    -0x10(%rsi),%rdx
    1128:	48 89 10             	mov    %rdx,(%rax)
    112b:	eb d5                	jmp    1102 <free+0x62>

000000000000112d <morecore>:

static Header*
morecore(uint nu)
{
    112d:	55                   	push   %rbp
    112e:	48 89 e5             	mov    %rsp,%rbp
    1131:	53                   	push   %rbx
    1132:	48 83 ec 08          	sub    $0x8,%rsp
    1136:	89 fb                	mov    %edi,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    1138:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
    113e:	77 05                	ja     1145 <morecore+0x18>
    nu = 4096;
    1140:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    1145:	89 df                	mov    %ebx,%edi
    1147:	c1 e7 04             	shl    $0x4,%edi
    114a:	e8 dd fb ff ff       	call   d2c <sbrk>
  if(p == (char*)-1)
    114f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
    1153:	74 1a                	je     116f <morecore+0x42>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    1155:	89 58 08             	mov    %ebx,0x8(%rax)
  free((void*)(hp + 1));
    1158:	48 8d 78 10          	lea    0x10(%rax),%rdi
    115c:	e8 3f ff ff ff       	call   10a0 <free>
  return freep;
    1161:	48 8b 05 e8 07 00 00 	mov    0x7e8(%rip),%rax        # 1950 <freep>
}
    1168:	48 83 c4 08          	add    $0x8,%rsp
    116c:	5b                   	pop    %rbx
    116d:	5d                   	pop    %rbp
    116e:	c3                   	ret
    return 0;
    116f:	b8 00 00 00 00       	mov    $0x0,%eax
    1174:	eb f2                	jmp    1168 <morecore+0x3b>

0000000000001176 <malloc>:

void*
malloc(uint nbytes)
{
    1176:	55                   	push   %rbp
    1177:	48 89 e5             	mov    %rsp,%rbp
    117a:	53                   	push   %rbx
    117b:	48 83 ec 08          	sub    $0x8,%rsp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    117f:	89 fb                	mov    %edi,%ebx
    1181:	48 83 c3 0f          	add    $0xf,%rbx
    1185:	48 c1 eb 04          	shr    $0x4,%rbx
    1189:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    118c:	48 8b 0d bd 07 00 00 	mov    0x7bd(%rip),%rcx        # 1950 <freep>
    1193:	48 85 c9             	test   %rcx,%rcx
    1196:	74 05                	je     119d <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1198:	48 8b 01             	mov    (%rcx),%rax
    119b:	eb 69                	jmp    1206 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
    119d:	48 c7 05 a8 07 00 00 	movq   $0x1960,0x7a8(%rip)        # 1950 <freep>
    11a4:	60 19 00 00 
    11a8:	48 c7 05 ad 07 00 00 	movq   $0x1960,0x7ad(%rip)        # 1960 <base>
    11af:	60 19 00 00 
    base.s.size = 0;
    11b3:	c7 05 ab 07 00 00 00 	movl   $0x0,0x7ab(%rip)        # 1968 <base+0x8>
    11ba:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    11bd:	b9 60 19 00 00       	mov    $0x1960,%ecx
    11c2:	eb d4                	jmp    1198 <malloc+0x22>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    11c4:	74 23                	je     11e9 <malloc+0x73>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    11c6:	29 da                	sub    %ebx,%edx
    11c8:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    11cb:	89 d2                	mov    %edx,%edx
    11cd:	48 c1 e2 04          	shl    $0x4,%rdx
    11d1:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
    11d4:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
    11d7:	48 89 0d 72 07 00 00 	mov    %rcx,0x772(%rip)        # 1950 <freep>
      return (void*)(p + 1);
    11de:	48 83 c0 10          	add    $0x10,%rax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    11e2:	48 83 c4 08          	add    $0x8,%rsp
    11e6:	5b                   	pop    %rbx
    11e7:	5d                   	pop    %rbp
    11e8:	c3                   	ret
        prevp->s.ptr = p->s.ptr;
    11e9:	48 8b 10             	mov    (%rax),%rdx
    11ec:	48 89 11             	mov    %rdx,(%rcx)
    11ef:	eb e6                	jmp    11d7 <malloc+0x61>
    11f1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    11f8:	00 00 00 00 
    11fc:	0f 1f 40 00          	nopl   0x0(%rax)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1200:	48 89 c1             	mov    %rax,%rcx
    1203:	48 8b 00             	mov    (%rax),%rax
    if(p->s.size >= nunits){
    1206:	8b 50 08             	mov    0x8(%rax),%edx
    1209:	39 da                	cmp    %ebx,%edx
    120b:	73 b7                	jae    11c4 <malloc+0x4e>
    if(p == freep)
    120d:	48 39 05 3c 07 00 00 	cmp    %rax,0x73c(%rip)        # 1950 <freep>
    1214:	75 ea                	jne    1200 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
    1216:	89 df                	mov    %ebx,%edi
    1218:	e8 10 ff ff ff       	call   112d <morecore>
    121d:	48 85 c0             	test   %rax,%rax
    1220:	75 de                	jne    1200 <malloc+0x8a>
    1222:	eb be                	jmp    11e2 <malloc+0x6c>
