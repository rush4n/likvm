
_usertests1:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <exectest>:
char *echoargv[] = { "echo", "ALL", "TESTS", "PASSED", 0 };
int stdout = 1;

void
exectest(void)
{
       0:	55                   	push   %rbp
       1:	48 89 e5             	mov    %rsp,%rbp
  printf(stdout, "exec test\n");
       4:	be 30 27 00 00       	mov    $0x2730,%esi
       9:	8b 3d d9 39 00 00    	mov    0x39d9(%rip),%edi        # 39e8 <stdout>
       f:	b0 00                	mov    $0x0,%al
      11:	e8 4f 23 00 00       	call   2365 <printf>
  if(exec("echo", echoargv) < 0){
      16:	be 00 3a 00 00       	mov    $0x3a00,%esi
      1b:	bf 3b 27 00 00       	mov    $0x273b,%edi
      20:	e8 a3 21 00 00       	call   21c8 <exec>
      25:	85 c0                	test   %eax,%eax
      27:	78 02                	js     2b <exectest+0x2b>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
      29:	5d                   	pop    %rbp
      2a:	c3                   	ret
    printf(stdout, "exec echo failed\n");
      2b:	be 40 27 00 00       	mov    $0x2740,%esi
      30:	8b 3d b2 39 00 00    	mov    0x39b2(%rip),%edi        # 39e8 <stdout>
      36:	b0 00                	mov    $0x0,%al
      38:	e8 28 23 00 00       	call   2365 <printf>
    exit();
      3d:	e8 40 21 00 00       	call   2182 <exit>

0000000000000042 <iputtest>:

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
      42:	55                   	push   %rbp
      43:	48 89 e5             	mov    %rsp,%rbp
  printf(stdout, "iput test\n");
      46:	be e6 27 00 00       	mov    $0x27e6,%esi
      4b:	8b 3d 97 39 00 00    	mov    0x3997(%rip),%edi        # 39e8 <stdout>
      51:	b0 00                	mov    $0x0,%al
      53:	e8 0d 23 00 00       	call   2365 <printf>

  if(mkdir("iputdir") < 0){
      58:	bf 79 27 00 00       	mov    $0x2779,%edi
      5d:	e8 a2 21 00 00       	call   2204 <mkdir>
      62:	85 c0                	test   %eax,%eax
      64:	78 3e                	js     a4 <iputtest+0x62>
    printf(stdout, "mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
      66:	bf 79 27 00 00       	mov    $0x2779,%edi
      6b:	e8 9e 21 00 00       	call   220e <chdir>
      70:	85 c0                	test   %eax,%eax
      72:	78 47                	js     bb <iputtest+0x79>
    printf(stdout, "chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
      74:	bf 76 27 00 00       	mov    $0x2776,%edi
      79:	e8 68 21 00 00       	call   21e6 <unlink>
      7e:	85 c0                	test   %eax,%eax
      80:	78 50                	js     d2 <iputtest+0x90>
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
      82:	bf 9b 27 00 00       	mov    $0x279b,%edi
      87:	e8 82 21 00 00       	call   220e <chdir>
      8c:	85 c0                	test   %eax,%eax
      8e:	78 59                	js     e9 <iputtest+0xa7>
    printf(stdout, "chdir / failed\n");
    exit();
  }
  printf(stdout, "iput test ok\n");
      90:	be 1e 28 00 00       	mov    $0x281e,%esi
      95:	8b 3d 4d 39 00 00    	mov    0x394d(%rip),%edi        # 39e8 <stdout>
      9b:	b0 00                	mov    $0x0,%al
      9d:	e8 c3 22 00 00       	call   2365 <printf>
}
      a2:	5d                   	pop    %rbp
      a3:	c3                   	ret
    printf(stdout, "mkdir failed\n");
      a4:	be 52 27 00 00       	mov    $0x2752,%esi
      a9:	8b 3d 39 39 00 00    	mov    0x3939(%rip),%edi        # 39e8 <stdout>
      af:	b0 00                	mov    $0x0,%al
      b1:	e8 af 22 00 00       	call   2365 <printf>
    exit();
      b6:	e8 c7 20 00 00       	call   2182 <exit>
    printf(stdout, "chdir iputdir failed\n");
      bb:	be 60 27 00 00       	mov    $0x2760,%esi
      c0:	8b 3d 22 39 00 00    	mov    0x3922(%rip),%edi        # 39e8 <stdout>
      c6:	b0 00                	mov    $0x0,%al
      c8:	e8 98 22 00 00       	call   2365 <printf>
    exit();
      cd:	e8 b0 20 00 00       	call   2182 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
      d2:	be 81 27 00 00       	mov    $0x2781,%esi
      d7:	8b 3d 0b 39 00 00    	mov    0x390b(%rip),%edi        # 39e8 <stdout>
      dd:	b0 00                	mov    $0x0,%al
      df:	e8 81 22 00 00       	call   2365 <printf>
    exit();
      e4:	e8 99 20 00 00       	call   2182 <exit>
    printf(stdout, "chdir / failed\n");
      e9:	be 9d 27 00 00       	mov    $0x279d,%esi
      ee:	8b 3d f4 38 00 00    	mov    0x38f4(%rip),%edi        # 39e8 <stdout>
      f4:	b0 00                	mov    $0x0,%al
      f6:	e8 6a 22 00 00       	call   2365 <printf>
    exit();
      fb:	e8 82 20 00 00       	call   2182 <exit>

0000000000000100 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
     100:	55                   	push   %rbp
     101:	48 89 e5             	mov    %rsp,%rbp
  int pid;

  printf(stdout, "exitiput test\n");
     104:	be ad 27 00 00       	mov    $0x27ad,%esi
     109:	8b 3d d9 38 00 00    	mov    0x38d9(%rip),%edi        # 39e8 <stdout>
     10f:	b0 00                	mov    $0x0,%al
     111:	e8 4f 22 00 00       	call   2365 <printf>

  pid = fork();
     116:	e8 5d 20 00 00       	call   2178 <fork>
  if(pid < 0){
     11b:	85 c0                	test   %eax,%eax
     11d:	78 35                	js     154 <exitiputtest+0x54>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
     11f:	0f 85 8b 00 00 00    	jne    1b0 <exitiputtest+0xb0>
    if(mkdir("iputdir") < 0){
     125:	bf 79 27 00 00       	mov    $0x2779,%edi
     12a:	e8 d5 20 00 00       	call   2204 <mkdir>
     12f:	85 c0                	test   %eax,%eax
     131:	78 38                	js     16b <exitiputtest+0x6b>
      printf(stdout, "mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
     133:	bf 79 27 00 00       	mov    $0x2779,%edi
     138:	e8 d1 20 00 00       	call   220e <chdir>
     13d:	85 c0                	test   %eax,%eax
     13f:	78 41                	js     182 <exitiputtest+0x82>
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
     141:	bf 76 27 00 00       	mov    $0x2776,%edi
     146:	e8 9b 20 00 00       	call   21e6 <unlink>
     14b:	85 c0                	test   %eax,%eax
     14d:	78 4a                	js     199 <exitiputtest+0x99>
      printf(stdout, "unlink ../iputdir failed\n");
      exit();
    }
    exit();
     14f:	e8 2e 20 00 00       	call   2182 <exit>
    printf(stdout, "fork failed\n");
     154:	be 6a 2e 00 00       	mov    $0x2e6a,%esi
     159:	8b 3d 89 38 00 00    	mov    0x3889(%rip),%edi        # 39e8 <stdout>
     15f:	b0 00                	mov    $0x0,%al
     161:	e8 ff 21 00 00       	call   2365 <printf>
    exit();
     166:	e8 17 20 00 00       	call   2182 <exit>
      printf(stdout, "mkdir failed\n");
     16b:	be 52 27 00 00       	mov    $0x2752,%esi
     170:	8b 3d 72 38 00 00    	mov    0x3872(%rip),%edi        # 39e8 <stdout>
     176:	b0 00                	mov    $0x0,%al
     178:	e8 e8 21 00 00       	call   2365 <printf>
      exit();
     17d:	e8 00 20 00 00       	call   2182 <exit>
      printf(stdout, "child chdir failed\n");
     182:	be bc 27 00 00       	mov    $0x27bc,%esi
     187:	8b 3d 5b 38 00 00    	mov    0x385b(%rip),%edi        # 39e8 <stdout>
     18d:	b0 00                	mov    $0x0,%al
     18f:	e8 d1 21 00 00       	call   2365 <printf>
      exit();
     194:	e8 e9 1f 00 00       	call   2182 <exit>
      printf(stdout, "unlink ../iputdir failed\n");
     199:	be 81 27 00 00       	mov    $0x2781,%esi
     19e:	8b 3d 44 38 00 00    	mov    0x3844(%rip),%edi        # 39e8 <stdout>
     1a4:	b0 00                	mov    $0x0,%al
     1a6:	e8 ba 21 00 00       	call   2365 <printf>
      exit();
     1ab:	e8 d2 1f 00 00       	call   2182 <exit>
  }
  wait();
     1b0:	e8 d7 1f 00 00       	call   218c <wait>
  printf(stdout, "exitiput test ok\n");
     1b5:	be d0 27 00 00       	mov    $0x27d0,%esi
     1ba:	8b 3d 28 38 00 00    	mov    0x3828(%rip),%edi        # 39e8 <stdout>
     1c0:	b0 00                	mov    $0x0,%al
     1c2:	e8 9e 21 00 00       	call   2365 <printf>
}
     1c7:	5d                   	pop    %rbp
     1c8:	c3                   	ret

00000000000001c9 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c9:	55                   	push   %rbp
     1ca:	48 89 e5             	mov    %rsp,%rbp
  int pid;

  printf(stdout, "openiput test\n");
     1cd:	be e2 27 00 00       	mov    $0x27e2,%esi
     1d2:	8b 3d 10 38 00 00    	mov    0x3810(%rip),%edi        # 39e8 <stdout>
     1d8:	b0 00                	mov    $0x0,%al
     1da:	e8 86 21 00 00       	call   2365 <printf>
  if(mkdir("oidir") < 0){
     1df:	bf f1 27 00 00       	mov    $0x27f1,%edi
     1e4:	e8 1b 20 00 00       	call   2204 <mkdir>
     1e9:	85 c0                	test   %eax,%eax
     1eb:	78 35                	js     222 <openiputtest+0x59>
    printf(stdout, "mkdir oidir failed\n");
    exit();
  }
  pid = fork();
     1ed:	e8 86 1f 00 00       	call   2178 <fork>
  if(pid < 0){
     1f2:	85 c0                	test   %eax,%eax
     1f4:	78 43                	js     239 <openiputtest+0x70>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
     1f6:	75 5d                	jne    255 <openiputtest+0x8c>
    int fd = open("oidir", O_RDWR);
     1f8:	be 02 00 00 00       	mov    $0x2,%esi
     1fd:	bf f1 27 00 00       	mov    $0x27f1,%edi
     202:	e8 cb 1f 00 00       	call   21d2 <open>
    if(fd >= 0){
     207:	85 c0                	test   %eax,%eax
     209:	78 45                	js     250 <openiputtest+0x87>
      printf(stdout, "open directory for write succeeded\n");
     20b:	be 40 2f 00 00       	mov    $0x2f40,%esi
     210:	8b 3d d2 37 00 00    	mov    0x37d2(%rip),%edi        # 39e8 <stdout>
     216:	b0 00                	mov    $0x0,%al
     218:	e8 48 21 00 00       	call   2365 <printf>
      exit();
     21d:	e8 60 1f 00 00       	call   2182 <exit>
    printf(stdout, "mkdir oidir failed\n");
     222:	be f7 27 00 00       	mov    $0x27f7,%esi
     227:	8b 3d bb 37 00 00    	mov    0x37bb(%rip),%edi        # 39e8 <stdout>
     22d:	b0 00                	mov    $0x0,%al
     22f:	e8 31 21 00 00       	call   2365 <printf>
    exit();
     234:	e8 49 1f 00 00       	call   2182 <exit>
    printf(stdout, "fork failed\n");
     239:	be 6a 2e 00 00       	mov    $0x2e6a,%esi
     23e:	8b 3d a4 37 00 00    	mov    0x37a4(%rip),%edi        # 39e8 <stdout>
     244:	b0 00                	mov    $0x0,%al
     246:	e8 1a 21 00 00       	call   2365 <printf>
    exit();
     24b:	e8 32 1f 00 00       	call   2182 <exit>
    }
    exit();
     250:	e8 2d 1f 00 00       	call   2182 <exit>
  }
  sleep(1);
     255:	bf 01 00 00 00       	mov    $0x1,%edi
     25a:	e8 d7 1f 00 00       	call   2236 <sleep>
  if(unlink("oidir") != 0){
     25f:	bf f1 27 00 00       	mov    $0x27f1,%edi
     264:	e8 7d 1f 00 00       	call   21e6 <unlink>
     269:	85 c0                	test   %eax,%eax
     26b:	75 19                	jne    286 <openiputtest+0xbd>
    printf(stdout, "unlink failed\n");
    exit();
  }
  wait();
     26d:	e8 1a 1f 00 00       	call   218c <wait>
  printf(stdout, "openiput test ok\n");
     272:	be 1a 28 00 00       	mov    $0x281a,%esi
     277:	8b 3d 6b 37 00 00    	mov    0x376b(%rip),%edi        # 39e8 <stdout>
     27d:	b0 00                	mov    $0x0,%al
     27f:	e8 e1 20 00 00       	call   2365 <printf>
}
     284:	5d                   	pop    %rbp
     285:	c3                   	ret
    printf(stdout, "unlink failed\n");
     286:	be 0b 28 00 00       	mov    $0x280b,%esi
     28b:	8b 3d 57 37 00 00    	mov    0x3757(%rip),%edi        # 39e8 <stdout>
     291:	b0 00                	mov    $0x0,%al
     293:	e8 cd 20 00 00       	call   2365 <printf>
    exit();
     298:	e8 e5 1e 00 00       	call   2182 <exit>

000000000000029d <opentest>:

// simple file system tests

void
opentest(void)
{
     29d:	55                   	push   %rbp
     29e:	48 89 e5             	mov    %rsp,%rbp
  int fd;

  printf(stdout, "open test\n");
     2a1:	be 2c 28 00 00       	mov    $0x282c,%esi
     2a6:	8b 3d 3c 37 00 00    	mov    0x373c(%rip),%edi        # 39e8 <stdout>
     2ac:	b0 00                	mov    $0x0,%al
     2ae:	e8 b2 20 00 00       	call   2365 <printf>
  fd = open("echo", 0);
     2b3:	be 00 00 00 00       	mov    $0x0,%esi
     2b8:	bf 3b 27 00 00       	mov    $0x273b,%edi
     2bd:	e8 10 1f 00 00       	call   21d2 <open>
  if(fd < 0){
     2c2:	85 c0                	test   %eax,%eax
     2c4:	78 2e                	js     2f4 <opentest+0x57>
     2c6:	89 c7                	mov    %eax,%edi
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
     2c8:	e8 e7 1e 00 00       	call   21b4 <close>
  fd = open("doesnotexist", 0);
     2cd:	be 00 00 00 00       	mov    $0x0,%esi
     2d2:	bf 4a 28 00 00       	mov    $0x284a,%edi
     2d7:	e8 f6 1e 00 00       	call   21d2 <open>
  if(fd >= 0){
     2dc:	85 c0                	test   %eax,%eax
     2de:	79 2b                	jns    30b <opentest+0x6e>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
     2e0:	be 75 28 00 00       	mov    $0x2875,%esi
     2e5:	8b 3d fd 36 00 00    	mov    0x36fd(%rip),%edi        # 39e8 <stdout>
     2eb:	b0 00                	mov    $0x0,%al
     2ed:	e8 73 20 00 00       	call   2365 <printf>
}
     2f2:	5d                   	pop    %rbp
     2f3:	c3                   	ret
    printf(stdout, "open echo failed!\n");
     2f4:	be 37 28 00 00       	mov    $0x2837,%esi
     2f9:	8b 3d e9 36 00 00    	mov    0x36e9(%rip),%edi        # 39e8 <stdout>
     2ff:	b0 00                	mov    $0x0,%al
     301:	e8 5f 20 00 00       	call   2365 <printf>
    exit();
     306:	e8 77 1e 00 00       	call   2182 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     30b:	be 57 28 00 00       	mov    $0x2857,%esi
     310:	8b 3d d2 36 00 00    	mov    0x36d2(%rip),%edi        # 39e8 <stdout>
     316:	b0 00                	mov    $0x0,%al
     318:	e8 48 20 00 00       	call   2365 <printf>
    exit();
     31d:	e8 60 1e 00 00       	call   2182 <exit>

0000000000000322 <writetest>:

void
writetest(void)
{
     322:	55                   	push   %rbp
     323:	48 89 e5             	mov    %rsp,%rbp
     326:	41 54                	push   %r12
     328:	53                   	push   %rbx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     329:	be 83 28 00 00       	mov    $0x2883,%esi
     32e:	8b 3d b4 36 00 00    	mov    0x36b4(%rip),%edi        # 39e8 <stdout>
     334:	b0 00                	mov    $0x0,%al
     336:	e8 2a 20 00 00       	call   2365 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     33b:	be 02 02 00 00       	mov    $0x202,%esi
     340:	bf 94 28 00 00       	mov    $0x2894,%edi
     345:	e8 88 1e 00 00       	call   21d2 <open>
  if(fd >= 0){
     34a:	85 c0                	test   %eax,%eax
     34c:	78 52                	js     3a0 <writetest+0x7e>
     34e:	41 89 c4             	mov    %eax,%r12d
    printf(stdout, "creat small succeeded; ok\n");
     351:	be 9a 28 00 00       	mov    $0x289a,%esi
     356:	8b 3d 8c 36 00 00    	mov    0x368c(%rip),%edi        # 39e8 <stdout>
     35c:	b0 00                	mov    $0x0,%al
     35e:	e8 02 20 00 00       	call   2365 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     363:	bb 00 00 00 00       	mov    $0x0,%ebx
     368:	83 fb 63             	cmp    $0x63,%ebx
     36b:	7f 7c                	jg     3e9 <writetest+0xc7>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     36d:	ba 0a 00 00 00       	mov    $0xa,%edx
     372:	be d1 28 00 00       	mov    $0x28d1,%esi
     377:	44 89 e7             	mov    %r12d,%edi
     37a:	e8 2b 1e 00 00       	call   21aa <write>
     37f:	83 f8 0a             	cmp    $0xa,%eax
     382:	75 33                	jne    3b7 <writetest+0x95>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     384:	ba 0a 00 00 00       	mov    $0xa,%edx
     389:	be dc 28 00 00       	mov    $0x28dc,%esi
     38e:	44 89 e7             	mov    %r12d,%edi
     391:	e8 14 1e 00 00       	call   21aa <write>
     396:	83 f8 0a             	cmp    $0xa,%eax
     399:	75 35                	jne    3d0 <writetest+0xae>
  for(i = 0; i < 100; i++){
     39b:	83 c3 01             	add    $0x1,%ebx
     39e:	eb c8                	jmp    368 <writetest+0x46>
    printf(stdout, "error: creat small failed!\n");
     3a0:	be b5 28 00 00       	mov    $0x28b5,%esi
     3a5:	8b 3d 3d 36 00 00    	mov    0x363d(%rip),%edi        # 39e8 <stdout>
     3ab:	b0 00                	mov    $0x0,%al
     3ad:	e8 b3 1f 00 00       	call   2365 <printf>
    exit();
     3b2:	e8 cb 1d 00 00       	call   2182 <exit>
      printf(stdout, "error: write aa %d new file failed\n", i);
     3b7:	89 da                	mov    %ebx,%edx
     3b9:	be 68 2f 00 00       	mov    $0x2f68,%esi
     3be:	8b 3d 24 36 00 00    	mov    0x3624(%rip),%edi        # 39e8 <stdout>
     3c4:	b0 00                	mov    $0x0,%al
     3c6:	e8 9a 1f 00 00       	call   2365 <printf>
      exit();
     3cb:	e8 b2 1d 00 00       	call   2182 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     3d0:	89 da                	mov    %ebx,%edx
     3d2:	be 90 2f 00 00       	mov    $0x2f90,%esi
     3d7:	8b 3d 0b 36 00 00    	mov    0x360b(%rip),%edi        # 39e8 <stdout>
     3dd:	b0 00                	mov    $0x0,%al
     3df:	e8 81 1f 00 00       	call   2365 <printf>
      exit();
     3e4:	e8 99 1d 00 00       	call   2182 <exit>
    }
  }
  printf(stdout, "writes ok\n");
     3e9:	be e7 28 00 00       	mov    $0x28e7,%esi
     3ee:	8b 3d f4 35 00 00    	mov    0x35f4(%rip),%edi        # 39e8 <stdout>
     3f4:	b0 00                	mov    $0x0,%al
     3f6:	e8 6a 1f 00 00       	call   2365 <printf>
  close(fd);
     3fb:	44 89 e7             	mov    %r12d,%edi
     3fe:	e8 b1 1d 00 00       	call   21b4 <close>
  fd = open("small", O_RDONLY);
     403:	be 00 00 00 00       	mov    $0x0,%esi
     408:	bf 94 28 00 00       	mov    $0x2894,%edi
     40d:	e8 c0 1d 00 00       	call   21d2 <open>
     412:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     414:	85 c0                	test   %eax,%eax
     416:	78 68                	js     480 <writetest+0x15e>
    printf(stdout, "open small succeeded ok\n");
     418:	be f2 28 00 00       	mov    $0x28f2,%esi
     41d:	8b 3d c5 35 00 00    	mov    0x35c5(%rip),%edi        # 39e8 <stdout>
     423:	b0 00                	mov    $0x0,%al
     425:	e8 3b 1f 00 00       	call   2365 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     42a:	ba d0 07 00 00       	mov    $0x7d0,%edx
     42f:	be 60 61 00 00       	mov    $0x6160,%esi
     434:	89 df                	mov    %ebx,%edi
     436:	e8 65 1d 00 00       	call   21a0 <read>
  if(i == 2000){
     43b:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     440:	75 55                	jne    497 <writetest+0x175>
    printf(stdout, "read succeeded ok\n");
     442:	be 26 29 00 00       	mov    $0x2926,%esi
     447:	8b 3d 9b 35 00 00    	mov    0x359b(%rip),%edi        # 39e8 <stdout>
     44d:	b0 00                	mov    $0x0,%al
     44f:	e8 11 1f 00 00       	call   2365 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     454:	89 df                	mov    %ebx,%edi
     456:	e8 59 1d 00 00       	call   21b4 <close>

  if(unlink("small") < 0){
     45b:	bf 94 28 00 00       	mov    $0x2894,%edi
     460:	e8 81 1d 00 00       	call   21e6 <unlink>
     465:	85 c0                	test   %eax,%eax
     467:	78 45                	js     4ae <writetest+0x18c>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
     469:	be 5b 29 00 00       	mov    $0x295b,%esi
     46e:	8b 3d 74 35 00 00    	mov    0x3574(%rip),%edi        # 39e8 <stdout>
     474:	b0 00                	mov    $0x0,%al
     476:	e8 ea 1e 00 00       	call   2365 <printf>
}
     47b:	5b                   	pop    %rbx
     47c:	41 5c                	pop    %r12
     47e:	5d                   	pop    %rbp
     47f:	c3                   	ret
    printf(stdout, "error: open small failed!\n");
     480:	be 0b 29 00 00       	mov    $0x290b,%esi
     485:	8b 3d 5d 35 00 00    	mov    0x355d(%rip),%edi        # 39e8 <stdout>
     48b:	b0 00                	mov    $0x0,%al
     48d:	e8 d3 1e 00 00       	call   2365 <printf>
    exit();
     492:	e8 eb 1c 00 00       	call   2182 <exit>
    printf(stdout, "read failed\n");
     497:	be 39 29 00 00       	mov    $0x2939,%esi
     49c:	8b 3d 46 35 00 00    	mov    0x3546(%rip),%edi        # 39e8 <stdout>
     4a2:	b0 00                	mov    $0x0,%al
     4a4:	e8 bc 1e 00 00       	call   2365 <printf>
    exit();
     4a9:	e8 d4 1c 00 00       	call   2182 <exit>
    printf(stdout, "unlink small failed\n");
     4ae:	be 46 29 00 00       	mov    $0x2946,%esi
     4b3:	8b 3d 2f 35 00 00    	mov    0x352f(%rip),%edi        # 39e8 <stdout>
     4b9:	b0 00                	mov    $0x0,%al
     4bb:	e8 a5 1e 00 00       	call   2365 <printf>
    exit();
     4c0:	e8 bd 1c 00 00       	call   2182 <exit>

00000000000004c5 <writetest1>:

void
writetest1(void)
{
     4c5:	55                   	push   %rbp
     4c6:	48 89 e5             	mov    %rsp,%rbp
     4c9:	41 54                	push   %r12
     4cb:	53                   	push   %rbx
  int i, fd, n;

  printf(stdout, "big files test\n");
     4cc:	be 6f 29 00 00       	mov    $0x296f,%esi
     4d1:	8b 3d 11 35 00 00    	mov    0x3511(%rip),%edi        # 39e8 <stdout>
     4d7:	b0 00                	mov    $0x0,%al
     4d9:	e8 87 1e 00 00       	call   2365 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     4de:	be 02 02 00 00       	mov    $0x202,%esi
     4e3:	bf e9 29 00 00       	mov    $0x29e9,%edi
     4e8:	e8 e5 1c 00 00       	call   21d2 <open>
  if(fd < 0){
     4ed:	85 c0                	test   %eax,%eax
     4ef:	78 34                	js     525 <writetest1+0x60>
     4f1:	41 89 c4             	mov    %eax,%r12d
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     4f4:	bb 00 00 00 00       	mov    $0x0,%ebx
     4f9:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     4ff:	77 54                	ja     555 <writetest1+0x90>
    ((int*)buf)[0] = i;
     501:	89 1d 59 5c 00 00    	mov    %ebx,0x5c59(%rip)        # 6160 <buf>
    if(write(fd, buf, 512) != 512){
     507:	ba 00 02 00 00       	mov    $0x200,%edx
     50c:	be 60 61 00 00       	mov    $0x6160,%esi
     511:	44 89 e7             	mov    %r12d,%edi
     514:	e8 91 1c 00 00       	call   21aa <write>
     519:	3d 00 02 00 00       	cmp    $0x200,%eax
     51e:	75 1c                	jne    53c <writetest1+0x77>
  for(i = 0; i < MAXFILE; i++){
     520:	83 c3 01             	add    $0x1,%ebx
     523:	eb d4                	jmp    4f9 <writetest1+0x34>
    printf(stdout, "error: creat big failed!\n");
     525:	be 7f 29 00 00       	mov    $0x297f,%esi
     52a:	8b 3d b8 34 00 00    	mov    0x34b8(%rip),%edi        # 39e8 <stdout>
     530:	b0 00                	mov    $0x0,%al
     532:	e8 2e 1e 00 00       	call   2365 <printf>
    exit();
     537:	e8 46 1c 00 00       	call   2182 <exit>
      printf(stdout, "error: write big file failed\n", i);
     53c:	89 da                	mov    %ebx,%edx
     53e:	be 99 29 00 00       	mov    $0x2999,%esi
     543:	8b 3d 9f 34 00 00    	mov    0x349f(%rip),%edi        # 39e8 <stdout>
     549:	b0 00                	mov    $0x0,%al
     54b:	e8 15 1e 00 00       	call   2365 <printf>
      exit();
     550:	e8 2d 1c 00 00       	call   2182 <exit>
    }
  }

  close(fd);
     555:	44 89 e7             	mov    %r12d,%edi
     558:	e8 57 1c 00 00       	call   21b4 <close>

  fd = open("big", O_RDONLY);
     55d:	be 00 00 00 00       	mov    $0x0,%esi
     562:	bf e9 29 00 00       	mov    $0x29e9,%edi
     567:	e8 66 1c 00 00       	call   21d2 <open>
     56c:	41 89 c4             	mov    %eax,%r12d
  if(fd < 0){
     56f:	85 c0                	test   %eax,%eax
     571:	78 35                	js     5a8 <writetest1+0xe3>
    printf(stdout, "error: open big failed!\n");
    exit();
  }

  n = 0;
     573:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(;;){
    i = read(fd, buf, 512);
     578:	ba 00 02 00 00       	mov    $0x200,%edx
     57d:	be 60 61 00 00       	mov    $0x6160,%esi
     582:	44 89 e7             	mov    %r12d,%edi
     585:	e8 16 1c 00 00       	call   21a0 <read>
    if(i == 0){
     58a:	85 c0                	test   %eax,%eax
     58c:	74 31                	je     5bf <writetest1+0xfa>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     58e:	3d 00 02 00 00       	cmp    $0x200,%eax
     593:	75 76                	jne    60b <writetest1+0x146>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
     595:	8b 0d c5 5b 00 00    	mov    0x5bc5(%rip),%ecx        # 6160 <buf>
     59b:	39 d9                	cmp    %ebx,%ecx
     59d:	0f 85 81 00 00 00    	jne    624 <writetest1+0x15f>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
     5a3:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
     5a6:	eb d0                	jmp    578 <writetest1+0xb3>
    printf(stdout, "error: open big failed!\n");
     5a8:	be b7 29 00 00       	mov    $0x29b7,%esi
     5ad:	8b 3d 35 34 00 00    	mov    0x3435(%rip),%edi        # 39e8 <stdout>
     5b3:	b0 00                	mov    $0x0,%al
     5b5:	e8 ab 1d 00 00       	call   2365 <printf>
    exit();
     5ba:	e8 c3 1b 00 00       	call   2182 <exit>
      if(n == MAXFILE - 1){
     5bf:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     5c5:	74 2d                	je     5f4 <writetest1+0x12f>
  }
  close(fd);
     5c7:	44 89 e7             	mov    %r12d,%edi
     5ca:	e8 e5 1b 00 00       	call   21b4 <close>
  if(unlink("big") < 0){
     5cf:	bf e9 29 00 00       	mov    $0x29e9,%edi
     5d4:	e8 0d 1c 00 00       	call   21e6 <unlink>
     5d9:	85 c0                	test   %eax,%eax
     5db:	78 60                	js     63d <writetest1+0x178>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
     5dd:	be 10 2a 00 00       	mov    $0x2a10,%esi
     5e2:	8b 3d 00 34 00 00    	mov    0x3400(%rip),%edi        # 39e8 <stdout>
     5e8:	b0 00                	mov    $0x0,%al
     5ea:	e8 76 1d 00 00       	call   2365 <printf>
}
     5ef:	5b                   	pop    %rbx
     5f0:	41 5c                	pop    %r12
     5f2:	5d                   	pop    %rbp
     5f3:	c3                   	ret
        printf(stdout, "read only %d blocks from big", n);
     5f4:	89 da                	mov    %ebx,%edx
     5f6:	be d0 29 00 00       	mov    $0x29d0,%esi
     5fb:	8b 3d e7 33 00 00    	mov    0x33e7(%rip),%edi        # 39e8 <stdout>
     601:	e8 5f 1d 00 00       	call   2365 <printf>
        exit();
     606:	e8 77 1b 00 00       	call   2182 <exit>
      printf(stdout, "read failed %d\n", i);
     60b:	89 c2                	mov    %eax,%edx
     60d:	be ed 29 00 00       	mov    $0x29ed,%esi
     612:	8b 3d d0 33 00 00    	mov    0x33d0(%rip),%edi        # 39e8 <stdout>
     618:	b0 00                	mov    $0x0,%al
     61a:	e8 46 1d 00 00       	call   2365 <printf>
      exit();
     61f:	e8 5e 1b 00 00       	call   2182 <exit>
      printf(stdout, "read content of block %d is %d\n",
     624:	89 da                	mov    %ebx,%edx
     626:	be b8 2f 00 00       	mov    $0x2fb8,%esi
     62b:	8b 3d b7 33 00 00    	mov    0x33b7(%rip),%edi        # 39e8 <stdout>
     631:	b0 00                	mov    $0x0,%al
     633:	e8 2d 1d 00 00       	call   2365 <printf>
      exit();
     638:	e8 45 1b 00 00       	call   2182 <exit>
    printf(stdout, "unlink big failed\n");
     63d:	be fd 29 00 00       	mov    $0x29fd,%esi
     642:	8b 3d a0 33 00 00    	mov    0x33a0(%rip),%edi        # 39e8 <stdout>
     648:	b0 00                	mov    $0x0,%al
     64a:	e8 16 1d 00 00       	call   2365 <printf>
    exit();
     64f:	e8 2e 1b 00 00       	call   2182 <exit>

0000000000000654 <createtest>:

void
createtest(void)
{
     654:	55                   	push   %rbp
     655:	48 89 e5             	mov    %rsp,%rbp
     658:	53                   	push   %rbx
     659:	48 83 ec 08          	sub    $0x8,%rsp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     65d:	be d8 2f 00 00       	mov    $0x2fd8,%esi
     662:	8b 3d 80 33 00 00    	mov    0x3380(%rip),%edi        # 39e8 <stdout>
     668:	b0 00                	mov    $0x0,%al
     66a:	e8 f6 1c 00 00       	call   2365 <printf>

  name[0] = 'a';
     66f:	c6 05 da 5a 00 00 61 	movb   $0x61,0x5ada(%rip)        # 6150 <name>
  name[2] = '\0';
     676:	c6 05 d5 5a 00 00 00 	movb   $0x0,0x5ad5(%rip)        # 6152 <name+0x2>
  for(i = 0; i < 52; i++){
     67d:	bb 00 00 00 00       	mov    $0x0,%ebx
     682:	eb 22                	jmp    6a6 <createtest+0x52>
    name[1] = '0' + i;
     684:	8d 43 30             	lea    0x30(%rbx),%eax
     687:	88 05 c4 5a 00 00    	mov    %al,0x5ac4(%rip)        # 6151 <name+0x1>
    fd = open(name, O_CREATE|O_RDWR);
     68d:	be 02 02 00 00       	mov    $0x202,%esi
     692:	bf 50 61 00 00       	mov    $0x6150,%edi
     697:	e8 36 1b 00 00       	call   21d2 <open>
     69c:	89 c7                	mov    %eax,%edi
    close(fd);
     69e:	e8 11 1b 00 00       	call   21b4 <close>
  for(i = 0; i < 52; i++){
     6a3:	83 c3 01             	add    $0x1,%ebx
     6a6:	83 fb 33             	cmp    $0x33,%ebx
     6a9:	7e d9                	jle    684 <createtest+0x30>
  }
  name[0] = 'a';
     6ab:	c6 05 9e 5a 00 00 61 	movb   $0x61,0x5a9e(%rip)        # 6150 <name>
  name[2] = '\0';
     6b2:	c6 05 99 5a 00 00 00 	movb   $0x0,0x5a99(%rip)        # 6152 <name+0x2>
  for(i = 0; i < 52; i++){
     6b9:	bb 00 00 00 00       	mov    $0x0,%ebx
     6be:	eb 16                	jmp    6d6 <createtest+0x82>
    name[1] = '0' + i;
     6c0:	8d 43 30             	lea    0x30(%rbx),%eax
     6c3:	88 05 88 5a 00 00    	mov    %al,0x5a88(%rip)        # 6151 <name+0x1>
    unlink(name);
     6c9:	bf 50 61 00 00       	mov    $0x6150,%edi
     6ce:	e8 13 1b 00 00       	call   21e6 <unlink>
  for(i = 0; i < 52; i++){
     6d3:	83 c3 01             	add    $0x1,%ebx
     6d6:	83 fb 33             	cmp    $0x33,%ebx
     6d9:	7e e5                	jle    6c0 <createtest+0x6c>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     6db:	be 00 30 00 00       	mov    $0x3000,%esi
     6e0:	8b 3d 02 33 00 00    	mov    0x3302(%rip),%edi        # 39e8 <stdout>
     6e6:	b0 00                	mov    $0x0,%al
     6e8:	e8 78 1c 00 00       	call   2365 <printf>
}
     6ed:	48 83 c4 08          	add    $0x8,%rsp
     6f1:	5b                   	pop    %rbx
     6f2:	5d                   	pop    %rbp
     6f3:	c3                   	ret

00000000000006f4 <dirtest>:

void dirtest(void)
{
     6f4:	55                   	push   %rbp
     6f5:	48 89 e5             	mov    %rsp,%rbp
  printf(stdout, "mkdir test\n");
     6f8:	be 1e 2a 00 00       	mov    $0x2a1e,%esi
     6fd:	8b 3d e5 32 00 00    	mov    0x32e5(%rip),%edi        # 39e8 <stdout>
     703:	b0 00                	mov    $0x0,%al
     705:	e8 5b 1c 00 00       	call   2365 <printf>

  if(mkdir("dir0") < 0){
     70a:	bf 2a 2a 00 00       	mov    $0x2a2a,%edi
     70f:	e8 f0 1a 00 00       	call   2204 <mkdir>
     714:	85 c0                	test   %eax,%eax
     716:	78 3e                	js     756 <dirtest+0x62>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
     718:	bf 2a 2a 00 00       	mov    $0x2a2a,%edi
     71d:	e8 ec 1a 00 00       	call   220e <chdir>
     722:	85 c0                	test   %eax,%eax
     724:	78 47                	js     76d <dirtest+0x79>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
     726:	bf 42 2a 00 00       	mov    $0x2a42,%edi
     72b:	e8 de 1a 00 00       	call   220e <chdir>
     730:	85 c0                	test   %eax,%eax
     732:	78 50                	js     784 <dirtest+0x90>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
     734:	bf 2a 2a 00 00       	mov    $0x2a2a,%edi
     739:	e8 a8 1a 00 00       	call   21e6 <unlink>
     73e:	85 c0                	test   %eax,%eax
     740:	78 59                	js     79b <dirtest+0xa7>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
     742:	be 6a 2a 00 00       	mov    $0x2a6a,%esi
     747:	8b 3d 9b 32 00 00    	mov    0x329b(%rip),%edi        # 39e8 <stdout>
     74d:	b0 00                	mov    $0x0,%al
     74f:	e8 11 1c 00 00       	call   2365 <printf>
}
     754:	5d                   	pop    %rbp
     755:	c3                   	ret
    printf(stdout, "mkdir failed\n");
     756:	be 52 27 00 00       	mov    $0x2752,%esi
     75b:	8b 3d 87 32 00 00    	mov    0x3287(%rip),%edi        # 39e8 <stdout>
     761:	b0 00                	mov    $0x0,%al
     763:	e8 fd 1b 00 00       	call   2365 <printf>
    exit();
     768:	e8 15 1a 00 00       	call   2182 <exit>
    printf(stdout, "chdir dir0 failed\n");
     76d:	be 2f 2a 00 00       	mov    $0x2a2f,%esi
     772:	8b 3d 70 32 00 00    	mov    0x3270(%rip),%edi        # 39e8 <stdout>
     778:	b0 00                	mov    $0x0,%al
     77a:	e8 e6 1b 00 00       	call   2365 <printf>
    exit();
     77f:	e8 fe 19 00 00       	call   2182 <exit>
    printf(stdout, "chdir .. failed\n");
     784:	be 45 2a 00 00       	mov    $0x2a45,%esi
     789:	8b 3d 59 32 00 00    	mov    0x3259(%rip),%edi        # 39e8 <stdout>
     78f:	b0 00                	mov    $0x0,%al
     791:	e8 cf 1b 00 00       	call   2365 <printf>
    exit();
     796:	e8 e7 19 00 00       	call   2182 <exit>
    printf(stdout, "unlink dir0 failed\n");
     79b:	be 56 2a 00 00       	mov    $0x2a56,%esi
     7a0:	8b 3d 42 32 00 00    	mov    0x3242(%rip),%edi        # 39e8 <stdout>
     7a6:	b0 00                	mov    $0x0,%al
     7a8:	e8 b8 1b 00 00       	call   2365 <printf>
    exit();
     7ad:	e8 d0 19 00 00       	call   2182 <exit>

00000000000007b2 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     7b2:	55                   	push   %rbp
     7b3:	48 89 e5             	mov    %rsp,%rbp
     7b6:	41 56                	push   %r14
     7b8:	41 55                	push   %r13
     7ba:	41 54                	push   %r12
     7bc:	53                   	push   %rbx
     7bd:	48 83 ec 10          	sub    $0x10,%rsp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     7c1:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
     7c5:	e8 cc 19 00 00       	call   2196 <pipe>
     7ca:	85 c0                	test   %eax,%eax
     7cc:	75 6c                	jne    83a <pipe1+0x88>
     7ce:	89 c3                	mov    %eax,%ebx
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
     7d0:	e8 a3 19 00 00       	call   2178 <fork>
     7d5:	41 89 c4             	mov    %eax,%r12d
  seq = 0;
  if(pid == 0){
     7d8:	85 c0                	test   %eax,%eax
     7da:	74 74                	je     850 <pipe1+0x9e>
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
     7dc:	0f 8e 55 01 00 00    	jle    937 <pipe1+0x185>
    close(fds[1]);
     7e2:	8b 7d dc             	mov    -0x24(%rbp),%edi
     7e5:	e8 ca 19 00 00       	call   21b4 <close>
    total = 0;
     7ea:	41 89 dd             	mov    %ebx,%r13d
  seq = 0;
     7ed:	41 89 de             	mov    %ebx,%r14d
    cc = 1;
     7f0:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    while((n = read(fds[0], buf, cc)) > 0){
     7f6:	44 89 e2             	mov    %r12d,%edx
     7f9:	be 60 61 00 00       	mov    $0x6160,%esi
     7fe:	8b 7d d8             	mov    -0x28(%rbp),%edi
     801:	e8 9a 19 00 00       	call   21a0 <read>
     806:	85 c0                	test   %eax,%eax
     808:	0f 8e e7 00 00 00    	jle    8f5 <pipe1+0x143>
      for(i = 0; i < n; i++){
     80e:	89 da                	mov    %ebx,%edx
     810:	39 c2                	cmp    %eax,%edx
     812:	0f 8d bf 00 00 00    	jge    8d7 <pipe1+0x125>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     818:	48 63 ca             	movslq %edx,%rcx
     81b:	0f be 89 60 61 00 00 	movsbl 0x6160(%rcx),%ecx
     822:	41 8d 76 01          	lea    0x1(%r14),%esi
     826:	44 31 f1             	xor    %r14d,%ecx
     829:	f6 c1 ff             	test   $0xff,%cl
     82c:	0f 85 87 00 00 00    	jne    8b9 <pipe1+0x107>
      for(i = 0; i < n; i++){
     832:	83 c2 01             	add    $0x1,%edx
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     835:	41 89 f6             	mov    %esi,%r14d
     838:	eb d6                	jmp    810 <pipe1+0x5e>
    printf(1, "pipe() failed\n");
     83a:	be 79 2a 00 00       	mov    $0x2a79,%esi
     83f:	bf 01 00 00 00       	mov    $0x1,%edi
     844:	b0 00                	mov    $0x0,%al
     846:	e8 1a 1b 00 00       	call   2365 <printf>
    exit();
     84b:	e8 32 19 00 00       	call   2182 <exit>
    close(fds[0]);
     850:	8b 7d d8             	mov    -0x28(%rbp),%edi
     853:	e8 5c 19 00 00       	call   21b4 <close>
    for(n = 0; n < 5; n++){
     858:	45 89 e5             	mov    %r12d,%r13d
  seq = 0;
     85b:	44 89 e3             	mov    %r12d,%ebx
    for(n = 0; n < 5; n++){
     85e:	eb 33                	jmp    893 <pipe1+0xe1>
        buf[i] = seq++;
     860:	48 63 d0             	movslq %eax,%rdx
     863:	88 9a 60 61 00 00    	mov    %bl,0x6160(%rdx)
      for(i = 0; i < 1033; i++)
     869:	83 c0 01             	add    $0x1,%eax
        buf[i] = seq++;
     86c:	8d 5b 01             	lea    0x1(%rbx),%ebx
      for(i = 0; i < 1033; i++)
     86f:	3d 08 04 00 00       	cmp    $0x408,%eax
     874:	7e ea                	jle    860 <pipe1+0xae>
      if(write(fds[1], buf, 1033) != 1033){
     876:	ba 09 04 00 00       	mov    $0x409,%edx
     87b:	be 60 61 00 00       	mov    $0x6160,%esi
     880:	8b 7d dc             	mov    -0x24(%rbp),%edi
     883:	e8 22 19 00 00       	call   21aa <write>
     888:	3d 09 04 00 00       	cmp    $0x409,%eax
     88d:	75 0f                	jne    89e <pipe1+0xec>
    for(n = 0; n < 5; n++){
     88f:	41 83 c5 01          	add    $0x1,%r13d
     893:	41 83 fd 04          	cmp    $0x4,%r13d
     897:	7f 1b                	jg     8b4 <pipe1+0x102>
      for(i = 0; i < 1033; i++)
     899:	44 89 e0             	mov    %r12d,%eax
     89c:	eb d1                	jmp    86f <pipe1+0xbd>
        printf(1, "pipe1 oops 1\n");
     89e:	be 88 2a 00 00       	mov    $0x2a88,%esi
     8a3:	bf 01 00 00 00       	mov    $0x1,%edi
     8a8:	b0 00                	mov    $0x0,%al
     8aa:	e8 b6 1a 00 00       	call   2365 <printf>
        exit();
     8af:	e8 ce 18 00 00       	call   2182 <exit>
    exit();
     8b4:	e8 c9 18 00 00       	call   2182 <exit>
          printf(1, "pipe1 oops 2\n");
     8b9:	be 96 2a 00 00       	mov    $0x2a96,%esi
     8be:	bf 01 00 00 00       	mov    $0x1,%edi
     8c3:	b0 00                	mov    $0x0,%al
     8c5:	e8 9b 1a 00 00       	call   2365 <printf>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
     8ca:	48 83 c4 10          	add    $0x10,%rsp
     8ce:	5b                   	pop    %rbx
     8cf:	41 5c                	pop    %r12
     8d1:	41 5d                	pop    %r13
     8d3:	41 5e                	pop    %r14
     8d5:	5d                   	pop    %rbp
     8d6:	c3                   	ret
      total += n;
     8d7:	41 01 c5             	add    %eax,%r13d
      cc = cc * 2;
     8da:	41 d1 e4             	shl    $1,%r12d
      if(cc > sizeof(buf))
     8dd:	41 81 fc 00 20 00 00 	cmp    $0x2000,%r12d
     8e4:	0f 86 0c ff ff ff    	jbe    7f6 <pipe1+0x44>
        cc = sizeof(buf);
     8ea:	41 bc 00 20 00 00    	mov    $0x2000,%r12d
     8f0:	e9 01 ff ff ff       	jmp    7f6 <pipe1+0x44>
    if(total != 5 * 1033){
     8f5:	41 81 fd 2d 14 00 00 	cmp    $0x142d,%r13d
     8fc:	75 20                	jne    91e <pipe1+0x16c>
    close(fds[0]);
     8fe:	8b 7d d8             	mov    -0x28(%rbp),%edi
     901:	e8 ae 18 00 00       	call   21b4 <close>
    wait();
     906:	e8 81 18 00 00       	call   218c <wait>
  printf(1, "pipe1 ok\n");
     90b:	be bb 2a 00 00       	mov    $0x2abb,%esi
     910:	bf 01 00 00 00       	mov    $0x1,%edi
     915:	b0 00                	mov    $0x0,%al
     917:	e8 49 1a 00 00       	call   2365 <printf>
     91c:	eb ac                	jmp    8ca <pipe1+0x118>
      printf(1, "pipe1 oops 3 total %d\n", total);
     91e:	44 89 ea             	mov    %r13d,%edx
     921:	be a4 2a 00 00       	mov    $0x2aa4,%esi
     926:	bf 01 00 00 00       	mov    $0x1,%edi
     92b:	b0 00                	mov    $0x0,%al
     92d:	e8 33 1a 00 00       	call   2365 <printf>
      exit();
     932:	e8 4b 18 00 00       	call   2182 <exit>
    printf(1, "fork() failed\n");
     937:	be c5 2a 00 00       	mov    $0x2ac5,%esi
     93c:	bf 01 00 00 00       	mov    $0x1,%edi
     941:	b0 00                	mov    $0x0,%al
     943:	e8 1d 1a 00 00       	call   2365 <printf>
    exit();
     948:	e8 35 18 00 00       	call   2182 <exit>

000000000000094d <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     94d:	55                   	push   %rbp
     94e:	48 89 e5             	mov    %rsp,%rbp
     951:	41 55                	push   %r13
     953:	41 54                	push   %r12
     955:	53                   	push   %rbx
     956:	48 83 ec 18          	sub    $0x18,%rsp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     95a:	be d4 2a 00 00       	mov    $0x2ad4,%esi
     95f:	bf 01 00 00 00       	mov    $0x1,%edi
     964:	b0 00                	mov    $0x0,%al
     966:	e8 fa 19 00 00       	call   2365 <printf>
  pid1 = fork();
     96b:	e8 08 18 00 00       	call   2178 <fork>
  if(pid1 == 0)
     970:	85 c0                	test   %eax,%eax
     972:	75 02                	jne    976 <preempt+0x29>
    for(;;)
     974:	eb fe                	jmp    974 <preempt+0x27>
     976:	89 c3                	mov    %eax,%ebx
      ;

  pid2 = fork();
     978:	e8 fb 17 00 00       	call   2178 <fork>
     97d:	41 89 c4             	mov    %eax,%r12d
  if(pid2 == 0)
     980:	85 c0                	test   %eax,%eax
     982:	75 02                	jne    986 <preempt+0x39>
    for(;;)
     984:	eb fe                	jmp    984 <preempt+0x37>
      ;

  pipe(pfds);
     986:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
     98a:	e8 07 18 00 00       	call   2196 <pipe>
  pid3 = fork();
     98f:	e8 e4 17 00 00       	call   2178 <fork>
     994:	41 89 c5             	mov    %eax,%r13d
  if(pid3 == 0){
     997:	85 c0                	test   %eax,%eax
     999:	75 3c                	jne    9d7 <preempt+0x8a>
    close(pfds[0]);
     99b:	8b 7d d8             	mov    -0x28(%rbp),%edi
     99e:	e8 11 18 00 00       	call   21b4 <close>
    if(write(pfds[1], "x", 1) != 1)
     9a3:	ba 01 00 00 00       	mov    $0x1,%edx
     9a8:	be de 2a 00 00       	mov    $0x2ade,%esi
     9ad:	8b 7d dc             	mov    -0x24(%rbp),%edi
     9b0:	e8 f5 17 00 00       	call   21aa <write>
     9b5:	83 f8 01             	cmp    $0x1,%eax
     9b8:	75 0a                	jne    9c4 <preempt+0x77>
      printf(1, "preempt write error");
    close(pfds[1]);
     9ba:	8b 7d dc             	mov    -0x24(%rbp),%edi
     9bd:	e8 f2 17 00 00       	call   21b4 <close>
    for(;;)
     9c2:	eb fe                	jmp    9c2 <preempt+0x75>
      printf(1, "preempt write error");
     9c4:	be e0 2a 00 00       	mov    $0x2ae0,%esi
     9c9:	bf 01 00 00 00       	mov    $0x1,%edi
     9ce:	b0 00                	mov    $0x0,%al
     9d0:	e8 90 19 00 00       	call   2365 <printf>
     9d5:	eb e3                	jmp    9ba <preempt+0x6d>
      ;
  }

  close(pfds[1]);
     9d7:	8b 7d dc             	mov    -0x24(%rbp),%edi
     9da:	e8 d5 17 00 00       	call   21b4 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     9df:	ba 00 20 00 00       	mov    $0x2000,%edx
     9e4:	be 60 61 00 00       	mov    $0x6160,%esi
     9e9:	8b 7d d8             	mov    -0x28(%rbp),%edi
     9ec:	e8 af 17 00 00       	call   21a0 <read>
     9f1:	83 f8 01             	cmp    $0x1,%eax
     9f4:	74 1c                	je     a12 <preempt+0xc5>
    printf(1, "preempt read error");
     9f6:	be f4 2a 00 00       	mov    $0x2af4,%esi
     9fb:	bf 01 00 00 00       	mov    $0x1,%edi
     a00:	b0 00                	mov    $0x0,%al
     a02:	e8 5e 19 00 00       	call   2365 <printf>
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
     a07:	48 83 c4 18          	add    $0x18,%rsp
     a0b:	5b                   	pop    %rbx
     a0c:	41 5c                	pop    %r12
     a0e:	41 5d                	pop    %r13
     a10:	5d                   	pop    %rbp
     a11:	c3                   	ret
  close(pfds[0]);
     a12:	8b 7d d8             	mov    -0x28(%rbp),%edi
     a15:	e8 9a 17 00 00       	call   21b4 <close>
  printf(1, "kill... ");
     a1a:	be 07 2b 00 00       	mov    $0x2b07,%esi
     a1f:	bf 01 00 00 00       	mov    $0x1,%edi
     a24:	b0 00                	mov    $0x0,%al
     a26:	e8 3a 19 00 00       	call   2365 <printf>
  kill(pid1);
     a2b:	89 df                	mov    %ebx,%edi
     a2d:	e8 8c 17 00 00       	call   21be <kill>
  kill(pid2);
     a32:	44 89 e7             	mov    %r12d,%edi
     a35:	e8 84 17 00 00       	call   21be <kill>
  kill(pid3);
     a3a:	44 89 ef             	mov    %r13d,%edi
     a3d:	e8 7c 17 00 00       	call   21be <kill>
  printf(1, "wait... ");
     a42:	be 10 2b 00 00       	mov    $0x2b10,%esi
     a47:	bf 01 00 00 00       	mov    $0x1,%edi
     a4c:	b0 00                	mov    $0x0,%al
     a4e:	e8 12 19 00 00       	call   2365 <printf>
  wait();
     a53:	e8 34 17 00 00       	call   218c <wait>
  wait();
     a58:	e8 2f 17 00 00       	call   218c <wait>
  wait();
     a5d:	e8 2a 17 00 00       	call   218c <wait>
  printf(1, "preempt ok\n");
     a62:	be 19 2b 00 00       	mov    $0x2b19,%esi
     a67:	bf 01 00 00 00       	mov    $0x1,%edi
     a6c:	b0 00                	mov    $0x0,%al
     a6e:	e8 f2 18 00 00       	call   2365 <printf>
     a73:	eb 92                	jmp    a07 <preempt+0xba>

0000000000000a75 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     a75:	55                   	push   %rbp
     a76:	48 89 e5             	mov    %rsp,%rbp
     a79:	41 54                	push   %r12
     a7b:	53                   	push   %rbx
  int i, pid;

  for(i = 0; i < 100; i++){
     a7c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
     a82:	41 83 fc 63          	cmp    $0x63,%r12d
     a86:	7f 4a                	jg     ad2 <exitwait+0x5d>
    pid = fork();
     a88:	e8 eb 16 00 00       	call   2178 <fork>
     a8d:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     a8f:	85 c0                	test   %eax,%eax
     a91:	78 11                	js     aa4 <exitwait+0x2f>
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     a93:	74 38                	je     acd <exitwait+0x58>
      if(wait() != pid){
     a95:	e8 f2 16 00 00       	call   218c <wait>
     a9a:	39 d8                	cmp    %ebx,%eax
     a9c:	75 1c                	jne    aba <exitwait+0x45>
  for(i = 0; i < 100; i++){
     a9e:	41 83 c4 01          	add    $0x1,%r12d
     aa2:	eb de                	jmp    a82 <exitwait+0xd>
      printf(1, "fork failed\n");
     aa4:	be 6a 2e 00 00       	mov    $0x2e6a,%esi
     aa9:	bf 01 00 00 00       	mov    $0x1,%edi
     aae:	b0 00                	mov    $0x0,%al
     ab0:	e8 b0 18 00 00       	call   2365 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     ab5:	5b                   	pop    %rbx
     ab6:	41 5c                	pop    %r12
     ab8:	5d                   	pop    %rbp
     ab9:	c3                   	ret
        printf(1, "wait wrong pid\n");
     aba:	be 25 2b 00 00       	mov    $0x2b25,%esi
     abf:	bf 01 00 00 00       	mov    $0x1,%edi
     ac4:	b0 00                	mov    $0x0,%al
     ac6:	e8 9a 18 00 00       	call   2365 <printf>
        return;
     acb:	eb e8                	jmp    ab5 <exitwait+0x40>
      exit();
     acd:	e8 b0 16 00 00       	call   2182 <exit>
  printf(1, "exitwait ok\n");
     ad2:	be 35 2b 00 00       	mov    $0x2b35,%esi
     ad7:	bf 01 00 00 00       	mov    $0x1,%edi
     adc:	b0 00                	mov    $0x0,%al
     ade:	e8 82 18 00 00       	call   2365 <printf>
     ae3:	eb d0                	jmp    ab5 <exitwait+0x40>

0000000000000ae5 <mem>:

void
mem(void)
{
     ae5:	55                   	push   %rbp
     ae6:	48 89 e5             	mov    %rsp,%rbp
     ae9:	41 55                	push   %r13
     aeb:	41 54                	push   %r12
     aed:	53                   	push   %rbx
     aee:	48 83 ec 08          	sub    $0x8,%rsp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     af2:	be 42 2b 00 00       	mov    $0x2b42,%esi
     af7:	bf 01 00 00 00       	mov    $0x1,%edi
     afc:	b0 00                	mov    $0x0,%al
     afe:	e8 62 18 00 00       	call   2365 <printf>
  ppid = getpid();
     b03:	e8 1a 17 00 00       	call   2222 <getpid>
     b08:	41 89 c5             	mov    %eax,%r13d
  if((pid = fork()) == 0){
     b0b:	e8 68 16 00 00       	call   2178 <fork>
     b10:	85 c0                	test   %eax,%eax
     b12:	75 7c                	jne    b90 <mem+0xab>
    m1 = 0;
     b14:	bb 00 00 00 00       	mov    $0x0,%ebx
     b19:	eb 06                	jmp    b21 <mem+0x3c>
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
     b1b:	48 89 18             	mov    %rbx,(%rax)
      m1 = m2;
     b1e:	48 89 c3             	mov    %rax,%rbx
    while((m2 = malloc(10001)) != 0){
     b21:	bf 11 27 00 00       	mov    $0x2711,%edi
     b26:	e8 4b 1b 00 00       	call   2676 <malloc>
     b2b:	48 85 c0             	test   %rax,%rax
     b2e:	75 eb                	jne    b1b <mem+0x36>
     b30:	eb 0e                	jmp    b40 <mem+0x5b>
    }
    while(m1){
      m2 = *(char**)m1;
     b32:	4c 8b 23             	mov    (%rbx),%r12
      free(m1);
     b35:	48 89 df             	mov    %rbx,%rdi
     b38:	e8 63 1a 00 00       	call   25a0 <free>
      m1 = m2;
     b3d:	4c 89 e3             	mov    %r12,%rbx
    while(m1){
     b40:	48 85 db             	test   %rbx,%rbx
     b43:	75 ed                	jne    b32 <mem+0x4d>
    }
    m1 = malloc(1024*20);
     b45:	bf 00 50 00 00       	mov    $0x5000,%edi
     b4a:	e8 27 1b 00 00       	call   2676 <malloc>
     b4f:	48 89 c7             	mov    %rax,%rdi
    if(m1 == 0){
     b52:	48 85 c0             	test   %rax,%rax
     b55:	74 1b                	je     b72 <mem+0x8d>
      printf(1, "couldn't allocate mem?!!\n");
      kill(ppid);
      exit();
    }
    free(m1);
     b57:	e8 44 1a 00 00       	call   25a0 <free>
    printf(1, "mem ok\n");
     b5c:	be 66 2b 00 00       	mov    $0x2b66,%esi
     b61:	bf 01 00 00 00       	mov    $0x1,%edi
     b66:	b0 00                	mov    $0x0,%al
     b68:	e8 f8 17 00 00       	call   2365 <printf>
    exit();
     b6d:	e8 10 16 00 00       	call   2182 <exit>
      printf(1, "couldn't allocate mem?!!\n");
     b72:	be 4c 2b 00 00       	mov    $0x2b4c,%esi
     b77:	bf 01 00 00 00       	mov    $0x1,%edi
     b7c:	b0 00                	mov    $0x0,%al
     b7e:	e8 e2 17 00 00       	call   2365 <printf>
      kill(ppid);
     b83:	44 89 ef             	mov    %r13d,%edi
     b86:	e8 33 16 00 00       	call   21be <kill>
      exit();
     b8b:	e8 f2 15 00 00       	call   2182 <exit>
  } else {
    wait();
     b90:	e8 f7 15 00 00       	call   218c <wait>
  }
}
     b95:	48 83 c4 08          	add    $0x8,%rsp
     b99:	5b                   	pop    %rbx
     b9a:	41 5c                	pop    %r12
     b9c:	41 5d                	pop    %r13
     b9e:	5d                   	pop    %rbp
     b9f:	c3                   	ret

0000000000000ba0 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     ba0:	55                   	push   %rbp
     ba1:	48 89 e5             	mov    %rsp,%rbp
     ba4:	41 55                	push   %r13
     ba6:	41 54                	push   %r12
     ba8:	53                   	push   %rbx
     ba9:	48 83 ec 18          	sub    $0x18,%rsp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     bad:	be 6e 2b 00 00       	mov    $0x2b6e,%esi
     bb2:	bf 01 00 00 00       	mov    $0x1,%edi
     bb7:	b0 00                	mov    $0x0,%al
     bb9:	e8 a7 17 00 00       	call   2365 <printf>

  unlink("sharedfd");
     bbe:	bf 7d 2b 00 00       	mov    $0x2b7d,%edi
     bc3:	e8 1e 16 00 00       	call   21e6 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     bc8:	be 02 02 00 00       	mov    $0x202,%esi
     bcd:	bf 7d 2b 00 00       	mov    $0x2b7d,%edi
     bd2:	e8 fb 15 00 00       	call   21d2 <open>
  if(fd < 0){
     bd7:	85 c0                	test   %eax,%eax
     bd9:	78 4a                	js     c25 <sharedfd+0x85>
     bdb:	41 89 c4             	mov    %eax,%r12d
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     bde:	e8 95 15 00 00       	call   2178 <fork>
     be3:	41 89 c5             	mov    %eax,%r13d
  memset(buf, pid==0?'c':'p', sizeof(buf));
     be6:	85 c0                	test   %eax,%eax
     be8:	75 51                	jne    c3b <sharedfd+0x9b>
     bea:	be 63 00 00 00       	mov    $0x63,%esi
     bef:	48 8d 7d d6          	lea    -0x2a(%rbp),%rdi
     bf3:	ba 0a 00 00 00       	mov    $0xa,%edx
     bf8:	e8 02 14 00 00       	call   1fff <memset>
  for(i = 0; i < 1000; i++){
     bfd:	bb 00 00 00 00       	mov    $0x0,%ebx
     c02:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
     c08:	7f 49                	jg     c53 <sharedfd+0xb3>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     c0a:	48 8d 75 d6          	lea    -0x2a(%rbp),%rsi
     c0e:	ba 0a 00 00 00       	mov    $0xa,%edx
     c13:	44 89 e7             	mov    %r12d,%edi
     c16:	e8 8f 15 00 00       	call   21aa <write>
     c1b:	83 f8 0a             	cmp    $0xa,%eax
     c1e:	75 22                	jne    c42 <sharedfd+0xa2>
  for(i = 0; i < 1000; i++){
     c20:	83 c3 01             	add    $0x1,%ebx
     c23:	eb dd                	jmp    c02 <sharedfd+0x62>
    printf(1, "fstests: cannot open sharedfd for writing");
     c25:	be 28 30 00 00       	mov    $0x3028,%esi
     c2a:	bf 01 00 00 00       	mov    $0x1,%edi
     c2f:	b0 00                	mov    $0x0,%al
     c31:	e8 2f 17 00 00       	call   2365 <printf>
    return;
     c36:	e9 e5 00 00 00       	jmp    d20 <sharedfd+0x180>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     c3b:	be 70 00 00 00       	mov    $0x70,%esi
     c40:	eb ad                	jmp    bef <sharedfd+0x4f>
      printf(1, "fstests: write sharedfd failed\n");
     c42:	be 58 30 00 00       	mov    $0x3058,%esi
     c47:	bf 01 00 00 00       	mov    $0x1,%edi
     c4c:	b0 00                	mov    $0x0,%al
     c4e:	e8 12 17 00 00       	call   2365 <printf>
      break;
    }
  }
  if(pid == 0)
     c53:	45 85 ed             	test   %r13d,%r13d
     c56:	74 4a                	je     ca2 <sharedfd+0x102>
    exit();
  else
    wait();
     c58:	e8 2f 15 00 00       	call   218c <wait>
  close(fd);
     c5d:	44 89 e7             	mov    %r12d,%edi
     c60:	e8 4f 15 00 00       	call   21b4 <close>
  fd = open("sharedfd", 0);
     c65:	be 00 00 00 00       	mov    $0x0,%esi
     c6a:	bf 7d 2b 00 00       	mov    $0x2b7d,%edi
     c6f:	e8 5e 15 00 00       	call   21d2 <open>
     c74:	41 89 c5             	mov    %eax,%r13d
  if(fd < 0){
     c77:	85 c0                	test   %eax,%eax
     c79:	78 2c                	js     ca7 <sharedfd+0x107>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
     c7b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
     c81:	bb 00 00 00 00       	mov    $0x0,%ebx
  while((n = read(fd, buf, sizeof(buf))) > 0){
     c86:	48 8d 75 d6          	lea    -0x2a(%rbp),%rsi
     c8a:	ba 0a 00 00 00       	mov    $0xa,%edx
     c8f:	44 89 ef             	mov    %r13d,%edi
     c92:	e8 09 15 00 00       	call   21a0 <read>
     c97:	85 c0                	test   %eax,%eax
     c99:	7e 49                	jle    ce4 <sharedfd+0x144>
    for(i = 0; i < sizeof(buf); i++){
     c9b:	ba 00 00 00 00       	mov    $0x0,%edx
     ca0:	eb 23                	jmp    cc5 <sharedfd+0x125>
    exit();
     ca2:	e8 db 14 00 00       	call   2182 <exit>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     ca7:	be 78 30 00 00       	mov    $0x3078,%esi
     cac:	bf 01 00 00 00       	mov    $0x1,%edi
     cb1:	b0 00                	mov    $0x0,%al
     cb3:	e8 ad 16 00 00       	call   2365 <printf>
    return;
     cb8:	eb 66                	jmp    d20 <sharedfd+0x180>
      if(buf[i] == 'c')
        nc++;
      if(buf[i] == 'p')
     cba:	0f be c0             	movsbl %al,%eax
     cbd:	83 f8 70             	cmp    $0x70,%eax
     cc0:	74 1c                	je     cde <sharedfd+0x13e>
    for(i = 0; i < sizeof(buf); i++){
     cc2:	83 c2 01             	add    $0x1,%edx
     cc5:	83 fa 09             	cmp    $0x9,%edx
     cc8:	77 bc                	ja     c86 <sharedfd+0xe6>
      if(buf[i] == 'c')
     cca:	48 63 c2             	movslq %edx,%rax
     ccd:	8a 44 05 d6          	mov    -0x2a(%rbp,%rax,1),%al
     cd1:	0f be c8             	movsbl %al,%ecx
     cd4:	83 f9 63             	cmp    $0x63,%ecx
     cd7:	75 e1                	jne    cba <sharedfd+0x11a>
        nc++;
     cd9:	83 c3 01             	add    $0x1,%ebx
     cdc:	eb dc                	jmp    cba <sharedfd+0x11a>
        np++;
     cde:	41 83 c4 01          	add    $0x1,%r12d
     ce2:	eb de                	jmp    cc2 <sharedfd+0x122>
    }
  }
  close(fd);
     ce4:	44 89 ef             	mov    %r13d,%edi
     ce7:	e8 c8 14 00 00       	call   21b4 <close>
  unlink("sharedfd");
     cec:	bf 7d 2b 00 00       	mov    $0x2b7d,%edi
     cf1:	e8 f0 14 00 00       	call   21e6 <unlink>
  if(nc == 10000 && np == 10000){
     cf6:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     cfc:	0f 94 c0             	sete   %al
     cff:	41 81 fc 10 27 00 00 	cmp    $0x2710,%r12d
     d06:	0f 94 c2             	sete   %dl
     d09:	21 d0                	and    %edx,%eax
     d0b:	a8 ff                	test   $0xff,%al
     d0d:	74 1c                	je     d2b <sharedfd+0x18b>
    printf(1, "sharedfd ok\n");
     d0f:	be 86 2b 00 00       	mov    $0x2b86,%esi
     d14:	bf 01 00 00 00       	mov    $0x1,%edi
     d19:	b0 00                	mov    $0x0,%al
     d1b:	e8 45 16 00 00       	call   2365 <printf>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
     d20:	48 83 c4 18          	add    $0x18,%rsp
     d24:	5b                   	pop    %rbx
     d25:	41 5c                	pop    %r12
     d27:	41 5d                	pop    %r13
     d29:	5d                   	pop    %rbp
     d2a:	c3                   	ret
    printf(1, "sharedfd oops %d %d\n", nc, np);
     d2b:	44 89 e1             	mov    %r12d,%ecx
     d2e:	89 da                	mov    %ebx,%edx
     d30:	be 93 2b 00 00       	mov    $0x2b93,%esi
     d35:	bf 01 00 00 00       	mov    $0x1,%edi
     d3a:	b0 00                	mov    $0x0,%al
     d3c:	e8 24 16 00 00       	call   2365 <printf>
    exit();
     d41:	e8 3c 14 00 00       	call   2182 <exit>

0000000000000d46 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     d46:	55                   	push   %rbp
     d47:	48 89 e5             	mov    %rsp,%rbp
     d4a:	41 56                	push   %r14
     d4c:	41 55                	push   %r13
     d4e:	41 54                	push   %r12
     d50:	53                   	push   %rbx
     d51:	48 83 ec 20          	sub    $0x20,%rsp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     d55:	48 c7 45 c0 a8 2b 00 	movq   $0x2ba8,-0x40(%rbp)
     d5c:	00 
     d5d:	48 c7 45 c8 ab 2b 00 	movq   $0x2bab,-0x38(%rbp)
     d64:	00 
     d65:	48 c7 45 d0 ae 2b 00 	movq   $0x2bae,-0x30(%rbp)
     d6c:	00 
     d6d:	48 c7 45 d8 b1 2b 00 	movq   $0x2bb1,-0x28(%rbp)
     d74:	00 
  char *fname;

  printf(1, "fourfiles test\n");
     d75:	be b4 2b 00 00       	mov    $0x2bb4,%esi
     d7a:	bf 01 00 00 00       	mov    $0x1,%edi
     d7f:	b0 00                	mov    $0x0,%al
     d81:	e8 df 15 00 00       	call   2365 <printf>

  for(pi = 0; pi < 4; pi++){
     d86:	41 bd 00 00 00 00    	mov    $0x0,%r13d
     d8c:	eb 4d                	jmp    ddb <fourfiles+0x95>
    fname = names[pi];
    unlink(fname);

    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
     d8e:	be 6a 2e 00 00       	mov    $0x2e6a,%esi
     d93:	bf 01 00 00 00       	mov    $0x1,%edi
     d98:	b0 00                	mov    $0x0,%al
     d9a:	e8 c6 15 00 00       	call   2365 <printf>
      exit();
     d9f:	e8 de 13 00 00       	call   2182 <exit>
    }

    if(pid == 0){
      fd = open(fname, O_CREATE | O_RDWR);
      if(fd < 0){
        printf(1, "create failed\n");
     da4:	be c4 2b 00 00       	mov    $0x2bc4,%esi
     da9:	bf 01 00 00 00       	mov    $0x1,%edi
     dae:	b0 00                	mov    $0x0,%al
     db0:	e8 b0 15 00 00       	call   2365 <printf>
        exit();
     db5:	e8 c8 13 00 00       	call   2182 <exit>
      }

      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
     dba:	89 c2                	mov    %eax,%edx
     dbc:	be d3 2b 00 00       	mov    $0x2bd3,%esi
     dc1:	bf 01 00 00 00       	mov    $0x1,%edi
     dc6:	b0 00                	mov    $0x0,%al
     dc8:	e8 98 15 00 00       	call   2365 <printf>
          exit();
     dcd:	e8 b0 13 00 00       	call   2182 <exit>
        }
      }
      exit();
     dd2:	e8 ab 13 00 00       	call   2182 <exit>
  for(pi = 0; pi < 4; pi++){
     dd7:	41 83 c5 01          	add    $0x1,%r13d
     ddb:	41 83 fd 03          	cmp    $0x3,%r13d
     ddf:	7f 6b                	jg     e4c <fourfiles+0x106>
    fname = names[pi];
     de1:	49 63 c5             	movslq %r13d,%rax
     de4:	4c 8b 64 c5 c0       	mov    -0x40(%rbp,%rax,8),%r12
    unlink(fname);
     de9:	4c 89 e7             	mov    %r12,%rdi
     dec:	e8 f5 13 00 00       	call   21e6 <unlink>
    pid = fork();
     df1:	e8 82 13 00 00       	call   2178 <fork>
     df6:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     df8:	85 c0                	test   %eax,%eax
     dfa:	78 92                	js     d8e <fourfiles+0x48>
    if(pid == 0){
     dfc:	75 d9                	jne    dd7 <fourfiles+0x91>
      fd = open(fname, O_CREATE | O_RDWR);
     dfe:	be 02 02 00 00       	mov    $0x202,%esi
     e03:	4c 89 e7             	mov    %r12,%rdi
     e06:	e8 c7 13 00 00       	call   21d2 <open>
     e0b:	41 89 c4             	mov    %eax,%r12d
      if(fd < 0){
     e0e:	85 c0                	test   %eax,%eax
     e10:	78 92                	js     da4 <fourfiles+0x5e>
      memset(buf, '0'+pi, 512);
     e12:	41 8d 75 30          	lea    0x30(%r13),%esi
     e16:	ba 00 02 00 00       	mov    $0x200,%edx
     e1b:	bf 60 61 00 00       	mov    $0x6160,%edi
     e20:	e8 da 11 00 00       	call   1fff <memset>
      for(i = 0; i < 12; i++){
     e25:	83 fb 0b             	cmp    $0xb,%ebx
     e28:	7f a8                	jg     dd2 <fourfiles+0x8c>
        if((n = write(fd, buf, 500)) != 500){
     e2a:	ba f4 01 00 00       	mov    $0x1f4,%edx
     e2f:	be 60 61 00 00       	mov    $0x6160,%esi
     e34:	44 89 e7             	mov    %r12d,%edi
     e37:	e8 6e 13 00 00       	call   21aa <write>
     e3c:	3d f4 01 00 00       	cmp    $0x1f4,%eax
     e41:	0f 85 73 ff ff ff    	jne    dba <fourfiles+0x74>
      for(i = 0; i < 12; i++){
     e47:	83 c3 01             	add    $0x1,%ebx
     e4a:	eb d9                	jmp    e25 <fourfiles+0xdf>
    }
  }

  for(pi = 0; pi < 4; pi++){
     e4c:	bb 00 00 00 00       	mov    $0x0,%ebx
     e51:	eb 08                	jmp    e5b <fourfiles+0x115>
    wait();
     e53:	e8 34 13 00 00       	call   218c <wait>
  for(pi = 0; pi < 4; pi++){
     e58:	83 c3 01             	add    $0x1,%ebx
     e5b:	83 fb 03             	cmp    $0x3,%ebx
     e5e:	7e f3                	jle    e53 <fourfiles+0x10d>
  }

  for(i = 0; i < 2; i++){
     e60:	bb 00 00 00 00       	mov    $0x0,%ebx
     e65:	eb 6a                	jmp    ed1 <fourfiles+0x18b>
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
     e67:	be e4 2b 00 00       	mov    $0x2be4,%esi
     e6c:	bf 01 00 00 00       	mov    $0x1,%edi
     e71:	b0 00                	mov    $0x0,%al
     e73:	e8 ed 14 00 00       	call   2365 <printf>
          exit();
     e78:	e8 05 13 00 00       	call   2182 <exit>
        }
      }
      total += n;
     e7d:	41 01 c4             	add    %eax,%r12d
    while((n = read(fd, buf, sizeof(buf))) > 0){
     e80:	ba 00 20 00 00       	mov    $0x2000,%edx
     e85:	be 60 61 00 00       	mov    $0x6160,%esi
     e8a:	44 89 ef             	mov    %r13d,%edi
     e8d:	e8 0e 13 00 00       	call   21a0 <read>
     e92:	85 c0                	test   %eax,%eax
     e94:	7e 1f                	jle    eb5 <fourfiles+0x16f>
      for(j = 0; j < n; j++){
     e96:	ba 00 00 00 00       	mov    $0x0,%edx
     e9b:	39 c2                	cmp    %eax,%edx
     e9d:	7d de                	jge    e7d <fourfiles+0x137>
        if(buf[j] != '0'+i){
     e9f:	48 63 ca             	movslq %edx,%rcx
     ea2:	0f be b1 60 61 00 00 	movsbl 0x6160(%rcx),%esi
     ea9:	8d 4b 30             	lea    0x30(%rbx),%ecx
     eac:	39 ce                	cmp    %ecx,%esi
     eae:	75 b7                	jne    e67 <fourfiles+0x121>
      for(j = 0; j < n; j++){
     eb0:	83 c2 01             	add    $0x1,%edx
     eb3:	eb e6                	jmp    e9b <fourfiles+0x155>
    }
    close(fd);
     eb5:	44 89 ef             	mov    %r13d,%edi
     eb8:	e8 f7 12 00 00       	call   21b4 <close>
    if(total != 12*500){
     ebd:	41 81 fc 70 17 00 00 	cmp    $0x1770,%r12d
     ec4:	75 30                	jne    ef6 <fourfiles+0x1b0>
      printf(1, "wrong length %d\n", total);
      exit();
    }
    unlink(fname);
     ec6:	4c 89 f7             	mov    %r14,%rdi
     ec9:	e8 18 13 00 00       	call   21e6 <unlink>
  for(i = 0; i < 2; i++){
     ece:	83 c3 01             	add    $0x1,%ebx
     ed1:	83 fb 01             	cmp    $0x1,%ebx
     ed4:	7f 39                	jg     f0f <fourfiles+0x1c9>
    fname = names[i];
     ed6:	48 63 c3             	movslq %ebx,%rax
     ed9:	4c 8b 74 c5 c0       	mov    -0x40(%rbp,%rax,8),%r14
    fd = open(fname, 0);
     ede:	be 00 00 00 00       	mov    $0x0,%esi
     ee3:	4c 89 f7             	mov    %r14,%rdi
     ee6:	e8 e7 12 00 00       	call   21d2 <open>
     eeb:	41 89 c5             	mov    %eax,%r13d
    total = 0;
     eee:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    while((n = read(fd, buf, sizeof(buf))) > 0){
     ef4:	eb 8a                	jmp    e80 <fourfiles+0x13a>
      printf(1, "wrong length %d\n", total);
     ef6:	44 89 e2             	mov    %r12d,%edx
     ef9:	be f0 2b 00 00       	mov    $0x2bf0,%esi
     efe:	bf 01 00 00 00       	mov    $0x1,%edi
     f03:	b0 00                	mov    $0x0,%al
     f05:	e8 5b 14 00 00       	call   2365 <printf>
      exit();
     f0a:	e8 73 12 00 00       	call   2182 <exit>
  }

  printf(1, "fourfiles ok\n");
     f0f:	be 01 2c 00 00       	mov    $0x2c01,%esi
     f14:	bf 01 00 00 00       	mov    $0x1,%edi
     f19:	b0 00                	mov    $0x0,%al
     f1b:	e8 45 14 00 00       	call   2365 <printf>
}
     f20:	48 83 c4 20          	add    $0x20,%rsp
     f24:	5b                   	pop    %rbx
     f25:	41 5c                	pop    %r12
     f27:	41 5d                	pop    %r13
     f29:	41 5e                	pop    %r14
     f2b:	5d                   	pop    %rbp
     f2c:	c3                   	ret

0000000000000f2d <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
     f2d:	55                   	push   %rbp
     f2e:	48 89 e5             	mov    %rsp,%rbp
     f31:	41 54                	push   %r12
     f33:	53                   	push   %rbx
     f34:	48 83 ec 20          	sub    $0x20,%rsp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
     f38:	be 0f 2c 00 00       	mov    $0x2c0f,%esi
     f3d:	bf 01 00 00 00       	mov    $0x1,%edi
     f42:	b0 00                	mov    $0x0,%al
     f44:	e8 1c 14 00 00       	call   2365 <printf>

  for(pi = 0; pi < 4; pi++){
     f49:	41 bc 00 00 00 00    	mov    $0x0,%r12d
     f4f:	41 83 fc 03          	cmp    $0x3,%r12d
     f53:	0f 8f b4 00 00 00    	jg     100d <createdelete+0xe0>
    pid = fork();
     f59:	e8 1a 12 00 00       	call   2178 <fork>
     f5e:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     f60:	85 c0                	test   %eax,%eax
     f62:	78 08                	js     f6c <createdelete+0x3f>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
     f64:	74 1c                	je     f82 <createdelete+0x55>
  for(pi = 0; pi < 4; pi++){
     f66:	41 83 c4 01          	add    $0x1,%r12d
     f6a:	eb e3                	jmp    f4f <createdelete+0x22>
      printf(1, "fork failed\n");
     f6c:	be 6a 2e 00 00       	mov    $0x2e6a,%esi
     f71:	bf 01 00 00 00       	mov    $0x1,%edi
     f76:	b0 00                	mov    $0x0,%al
     f78:	e8 e8 13 00 00       	call   2365 <printf>
      exit();
     f7d:	e8 00 12 00 00       	call   2182 <exit>
      name[0] = 'p' + pi;
     f82:	41 83 c4 70          	add    $0x70,%r12d
     f86:	44 88 65 d0          	mov    %r12b,-0x30(%rbp)
      name[2] = '\0';
     f8a:	c6 45 d2 00          	movb   $0x0,-0x2e(%rbp)
      for(i = 0; i < N; i++){
     f8e:	eb 19                	jmp    fa9 <createdelete+0x7c>
        name[1] = '0' + i;
        fd = open(name, O_CREATE | O_RDWR);
        if(fd < 0){
          printf(1, "create failed\n");
     f90:	be c4 2b 00 00       	mov    $0x2bc4,%esi
     f95:	bf 01 00 00 00       	mov    $0x1,%edi
     f9a:	b0 00                	mov    $0x0,%al
     f9c:	e8 c4 13 00 00       	call   2365 <printf>
          exit();
     fa1:	e8 dc 11 00 00       	call   2182 <exit>
      for(i = 0; i < N; i++){
     fa6:	83 c3 01             	add    $0x1,%ebx
     fa9:	83 fb 13             	cmp    $0x13,%ebx
     fac:	7f 5a                	jg     1008 <createdelete+0xdb>
        name[1] = '0' + i;
     fae:	8d 43 30             	lea    0x30(%rbx),%eax
     fb1:	88 45 d1             	mov    %al,-0x2f(%rbp)
        fd = open(name, O_CREATE | O_RDWR);
     fb4:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
     fb8:	be 02 02 00 00       	mov    $0x202,%esi
     fbd:	e8 10 12 00 00       	call   21d2 <open>
     fc2:	89 c7                	mov    %eax,%edi
        if(fd < 0){
     fc4:	85 c0                	test   %eax,%eax
     fc6:	78 c8                	js     f90 <createdelete+0x63>
        }
        close(fd);
     fc8:	e8 e7 11 00 00       	call   21b4 <close>
        if(i > 0 && (i % 2 ) == 0){
     fcd:	85 db                	test   %ebx,%ebx
     fcf:	7e d5                	jle    fa6 <createdelete+0x79>
     fd1:	f6 c3 01             	test   $0x1,%bl
     fd4:	75 d0                	jne    fa6 <createdelete+0x79>
          name[1] = '0' + (i / 2);
     fd6:	89 d8                	mov    %ebx,%eax
     fd8:	c1 e8 1f             	shr    $0x1f,%eax
     fdb:	01 d8                	add    %ebx,%eax
     fdd:	d1 f8                	sar    $1,%eax
     fdf:	83 c0 30             	add    $0x30,%eax
     fe2:	88 45 d1             	mov    %al,-0x2f(%rbp)
          if(unlink(name) < 0){
     fe5:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
     fe9:	e8 f8 11 00 00       	call   21e6 <unlink>
     fee:	85 c0                	test   %eax,%eax
     ff0:	79 b4                	jns    fa6 <createdelete+0x79>
            printf(1, "unlink failed\n");
     ff2:	be 0b 28 00 00       	mov    $0x280b,%esi
     ff7:	bf 01 00 00 00       	mov    $0x1,%edi
     ffc:	b0 00                	mov    $0x0,%al
     ffe:	e8 62 13 00 00       	call   2365 <printf>
            exit();
    1003:	e8 7a 11 00 00       	call   2182 <exit>
          }
        }
      }
      exit();
    1008:	e8 75 11 00 00       	call   2182 <exit>
    }
  }

  for(pi = 0; pi < 4; pi++){
    100d:	bb 00 00 00 00       	mov    $0x0,%ebx
    1012:	eb 08                	jmp    101c <createdelete+0xef>
    wait();
    1014:	e8 73 11 00 00       	call   218c <wait>
  for(pi = 0; pi < 4; pi++){
    1019:	83 c3 01             	add    $0x1,%ebx
    101c:	83 fb 03             	cmp    $0x3,%ebx
    101f:	7e f3                	jle    1014 <createdelete+0xe7>
  }

  name[0] = name[1] = name[2] = 0;
    1021:	c6 45 d2 00          	movb   $0x0,-0x2e(%rbp)
    1025:	c6 45 d1 00          	movb   $0x0,-0x2f(%rbp)
    1029:	c6 45 d0 00          	movb   $0x0,-0x30(%rbp)
  for(i = 0; i < N; i++){
    102d:	bb 00 00 00 00       	mov    $0x0,%ebx
    1032:	e9 8b 00 00 00       	jmp    10c2 <createdelete+0x195>
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1037:	8d 43 ff             	lea    -0x1(%rbx),%eax
    103a:	83 f8 08             	cmp    $0x8,%eax
    103d:	76 5b                	jbe    109a <createdelete+0x16d>
        printf(1, "oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
    103f:	85 ff                	test   %edi,%edi
    1041:	79 75                	jns    10b8 <createdelete+0x18b>
    for(pi = 0; pi < 4; pi++){
    1043:	41 83 c4 01          	add    $0x1,%r12d
    1047:	41 83 fc 03          	cmp    $0x3,%r12d
    104b:	7f 72                	jg     10bf <createdelete+0x192>
      name[0] = 'p' + pi;
    104d:	41 8d 44 24 70       	lea    0x70(%r12),%eax
    1052:	88 45 d0             	mov    %al,-0x30(%rbp)
      name[1] = '0' + i;
    1055:	8d 43 30             	lea    0x30(%rbx),%eax
    1058:	88 45 d1             	mov    %al,-0x2f(%rbp)
      fd = open(name, 0);
    105b:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
    105f:	be 00 00 00 00       	mov    $0x0,%esi
    1064:	e8 69 11 00 00       	call   21d2 <open>
    1069:	89 c7                	mov    %eax,%edi
      if((i == 0 || i >= N/2) && fd < 0){
    106b:	85 db                	test   %ebx,%ebx
    106d:	0f 94 c0             	sete   %al
    1070:	83 fb 09             	cmp    $0x9,%ebx
    1073:	0f 9f c2             	setg   %dl
    1076:	09 d0                	or     %edx,%eax
    1078:	a8 ff                	test   $0xff,%al
    107a:	74 bb                	je     1037 <createdelete+0x10a>
    107c:	85 ff                	test   %edi,%edi
    107e:	79 b7                	jns    1037 <createdelete+0x10a>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1080:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
    1084:	be a8 30 00 00       	mov    $0x30a8,%esi
    1089:	bf 01 00 00 00       	mov    $0x1,%edi
    108e:	b0 00                	mov    $0x0,%al
    1090:	e8 d0 12 00 00       	call   2365 <printf>
        exit();
    1095:	e8 e8 10 00 00       	call   2182 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    109a:	85 ff                	test   %edi,%edi
    109c:	78 a5                	js     1043 <createdelete+0x116>
        printf(1, "oops createdelete %s did exist\n", name);
    109e:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
    10a2:	be d0 30 00 00       	mov    $0x30d0,%esi
    10a7:	bf 01 00 00 00       	mov    $0x1,%edi
    10ac:	b0 00                	mov    $0x0,%al
    10ae:	e8 b2 12 00 00       	call   2365 <printf>
        exit();
    10b3:	e8 ca 10 00 00       	call   2182 <exit>
        close(fd);
    10b8:	e8 f7 10 00 00       	call   21b4 <close>
    10bd:	eb 84                	jmp    1043 <createdelete+0x116>
  for(i = 0; i < N; i++){
    10bf:	83 c3 01             	add    $0x1,%ebx
    10c2:	83 fb 13             	cmp    $0x13,%ebx
    10c5:	7f 0b                	jg     10d2 <createdelete+0x1a5>
    for(pi = 0; pi < 4; pi++){
    10c7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    10cd:	e9 75 ff ff ff       	jmp    1047 <createdelete+0x11a>
    }
  }

  for(i = 0; i < N; i++){
    10d2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    10d8:	eb 25                	jmp    10ff <createdelete+0x1d2>
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    10da:	41 8d 44 24 70       	lea    0x70(%r12),%eax
    10df:	88 45 d0             	mov    %al,-0x30(%rbp)
      name[1] = '0' + i;
    10e2:	41 8d 44 24 30       	lea    0x30(%r12),%eax
    10e7:	88 45 d1             	mov    %al,-0x2f(%rbp)
      unlink(name);
    10ea:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
    10ee:	e8 f3 10 00 00       	call   21e6 <unlink>
    for(pi = 0; pi < 4; pi++){
    10f3:	83 c3 01             	add    $0x1,%ebx
    10f6:	83 fb 03             	cmp    $0x3,%ebx
    10f9:	7e df                	jle    10da <createdelete+0x1ad>
  for(i = 0; i < N; i++){
    10fb:	41 83 c4 01          	add    $0x1,%r12d
    10ff:	41 83 fc 13          	cmp    $0x13,%r12d
    1103:	7f 07                	jg     110c <createdelete+0x1df>
    for(pi = 0; pi < 4; pi++){
    1105:	bb 00 00 00 00       	mov    $0x0,%ebx
    110a:	eb ea                	jmp    10f6 <createdelete+0x1c9>
    }
  }

  printf(1, "createdelete ok\n");
    110c:	be 22 2c 00 00       	mov    $0x2c22,%esi
    1111:	bf 01 00 00 00       	mov    $0x1,%edi
    1116:	b0 00                	mov    $0x0,%al
    1118:	e8 48 12 00 00       	call   2365 <printf>
}
    111d:	48 83 c4 20          	add    $0x20,%rsp
    1121:	5b                   	pop    %rbx
    1122:	41 5c                	pop    %r12
    1124:	5d                   	pop    %rbp
    1125:	c3                   	ret

0000000000001126 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1126:	55                   	push   %rbp
    1127:	48 89 e5             	mov    %rsp,%rbp
    112a:	41 55                	push   %r13
    112c:	41 54                	push   %r12
    112e:	53                   	push   %rbx
    112f:	48 83 ec 48          	sub    $0x48,%rsp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1133:	be 33 2c 00 00       	mov    $0x2c33,%esi
    1138:	bf 01 00 00 00       	mov    $0x1,%edi
    113d:	b0 00                	mov    $0x0,%al
    113f:	e8 21 12 00 00       	call   2365 <printf>
  file[0] = 'C';
    1144:	c6 45 dd 43          	movb   $0x43,-0x23(%rbp)
  file[2] = '\0';
    1148:	c6 45 df 00          	movb   $0x0,-0x21(%rbp)
  for(i = 0; i < 40; i++){
    114c:	bb 00 00 00 00       	mov    $0x0,%ebx
    1151:	eb 4b                	jmp    119e <concreate+0x78>
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    1153:	48 63 c3             	movslq %ebx,%rax
    1156:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    115d:	48 c1 f8 21          	sar    $0x21,%rax
    1161:	89 da                	mov    %ebx,%edx
    1163:	c1 fa 1f             	sar    $0x1f,%edx
    1166:	29 d0                	sub    %edx,%eax
    1168:	8d 14 80             	lea    (%rax,%rax,4),%edx
    116b:	89 d8                	mov    %ebx,%eax
    116d:	29 d0                	sub    %edx,%eax
    116f:	83 f8 01             	cmp    $0x1,%eax
    1172:	74 7b                	je     11ef <concreate+0xc9>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1174:	48 8d 7d dd          	lea    -0x23(%rbp),%rdi
    1178:	be 02 02 00 00       	mov    $0x202,%esi
    117d:	e8 50 10 00 00       	call   21d2 <open>
    1182:	89 c7                	mov    %eax,%edi
      if(fd < 0){
    1184:	85 c0                	test   %eax,%eax
    1186:	78 77                	js     11ff <concreate+0xd9>
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    1188:	e8 27 10 00 00       	call   21b4 <close>
    }
    if(pid == 0)
    118d:	45 85 e4             	test   %r12d,%r12d
    1190:	0f 84 83 00 00 00    	je     1219 <concreate+0xf3>
      exit();
    else
      wait();
    1196:	e8 f1 0f 00 00       	call   218c <wait>
  for(i = 0; i < 40; i++){
    119b:	83 c3 01             	add    $0x1,%ebx
    119e:	83 fb 27             	cmp    $0x27,%ebx
    11a1:	7f 7b                	jg     121e <concreate+0xf8>
    file[1] = '0' + i;
    11a3:	8d 43 30             	lea    0x30(%rbx),%eax
    11a6:	88 45 de             	mov    %al,-0x22(%rbp)
    unlink(file);
    11a9:	48 8d 7d dd          	lea    -0x23(%rbp),%rdi
    11ad:	e8 34 10 00 00       	call   21e6 <unlink>
    pid = fork();
    11b2:	e8 c1 0f 00 00       	call   2178 <fork>
    11b7:	41 89 c4             	mov    %eax,%r12d
    if(pid && (i % 3) == 1){
    11ba:	85 c0                	test   %eax,%eax
    11bc:	74 95                	je     1153 <concreate+0x2d>
    11be:	48 63 c3             	movslq %ebx,%rax
    11c1:	48 69 c0 56 55 55 55 	imul   $0x55555556,%rax,%rax
    11c8:	48 c1 e8 20          	shr    $0x20,%rax
    11cc:	89 da                	mov    %ebx,%edx
    11ce:	c1 fa 1f             	sar    $0x1f,%edx
    11d1:	29 d0                	sub    %edx,%eax
    11d3:	8d 14 40             	lea    (%rax,%rax,2),%edx
    11d6:	89 d8                	mov    %ebx,%eax
    11d8:	29 d0                	sub    %edx,%eax
    11da:	83 f8 01             	cmp    $0x1,%eax
    11dd:	75 95                	jne    1174 <concreate+0x4e>
      link("C0", file);
    11df:	48 8d 75 dd          	lea    -0x23(%rbp),%rsi
    11e3:	bf 43 2c 00 00       	mov    $0x2c43,%edi
    11e8:	e8 0d 10 00 00       	call   21fa <link>
    11ed:	eb 9e                	jmp    118d <concreate+0x67>
      link("C0", file);
    11ef:	48 8d 75 dd          	lea    -0x23(%rbp),%rsi
    11f3:	bf 43 2c 00 00       	mov    $0x2c43,%edi
    11f8:	e8 fd 0f 00 00       	call   21fa <link>
    11fd:	eb 8e                	jmp    118d <concreate+0x67>
        printf(1, "concreate create %s failed\n", file);
    11ff:	48 8d 55 dd          	lea    -0x23(%rbp),%rdx
    1203:	be 46 2c 00 00       	mov    $0x2c46,%esi
    1208:	bf 01 00 00 00       	mov    $0x1,%edi
    120d:	b0 00                	mov    $0x0,%al
    120f:	e8 51 11 00 00       	call   2365 <printf>
        exit();
    1214:	e8 69 0f 00 00       	call   2182 <exit>
      exit();
    1219:	e8 64 0f 00 00       	call   2182 <exit>
  }

  memset(fa, 0, sizeof(fa));
    121e:	48 8d 7d b0          	lea    -0x50(%rbp),%rdi
    1222:	ba 28 00 00 00       	mov    $0x28,%edx
    1227:	be 00 00 00 00       	mov    $0x0,%esi
    122c:	e8 ce 0d 00 00       	call   1fff <memset>
  fd = open(".", 0);
    1231:	be 00 00 00 00       	mov    $0x0,%esi
    1236:	bf 43 2a 00 00       	mov    $0x2a43,%edi
    123b:	e8 92 0f 00 00       	call   21d2 <open>
    1240:	89 c3                	mov    %eax,%ebx
  n = 0;
    1242:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  while(read(fd, &de, sizeof(de)) > 0){
    1248:	48 8d 75 a0          	lea    -0x60(%rbp),%rsi
    124c:	ba 10 00 00 00       	mov    $0x10,%edx
    1251:	89 df                	mov    %ebx,%edi
    1253:	e8 48 0f 00 00       	call   21a0 <read>
    1258:	85 c0                	test   %eax,%eax
    125a:	7e 72                	jle    12ce <concreate+0x1a8>
    if(de.inum == 0)
    125c:	0f b7 45 a0          	movzwl -0x60(%rbp),%eax
    1260:	85 c0                	test   %eax,%eax
    1262:	74 e4                	je     1248 <concreate+0x122>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1264:	0f be 45 a2          	movsbl -0x5e(%rbp),%eax
    1268:	83 f8 43             	cmp    $0x43,%eax
    126b:	75 db                	jne    1248 <concreate+0x122>
    126d:	0f be 45 a4          	movsbl -0x5c(%rbp),%eax
    1271:	85 c0                	test   %eax,%eax
    1273:	75 d3                	jne    1248 <concreate+0x122>
      i = de.name[1] - '0';
    1275:	0f be 45 a3          	movsbl -0x5d(%rbp),%eax
    1279:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    127c:	83 f8 27             	cmp    $0x27,%eax
    127f:	77 19                	ja     129a <concreate+0x174>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    1281:	48 63 d0             	movslq %eax,%rdx
    1284:	0f be 54 15 b0       	movsbl -0x50(%rbp,%rdx,1),%edx
    1289:	85 d2                	test   %edx,%edx
    128b:	75 27                	jne    12b4 <concreate+0x18e>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    128d:	48 98                	cltq
    128f:	c6 44 05 b0 01       	movb   $0x1,-0x50(%rbp,%rax,1)
      n++;
    1294:	41 83 c4 01          	add    $0x1,%r12d
    1298:	eb ae                	jmp    1248 <concreate+0x122>
        printf(1, "concreate weird file %s\n", de.name);
    129a:	48 8d 55 a2          	lea    -0x5e(%rbp),%rdx
    129e:	be 62 2c 00 00       	mov    $0x2c62,%esi
    12a3:	bf 01 00 00 00       	mov    $0x1,%edi
    12a8:	b0 00                	mov    $0x0,%al
    12aa:	e8 b6 10 00 00       	call   2365 <printf>
        exit();
    12af:	e8 ce 0e 00 00       	call   2182 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    12b4:	48 8d 55 a2          	lea    -0x5e(%rbp),%rdx
    12b8:	be 7b 2c 00 00       	mov    $0x2c7b,%esi
    12bd:	bf 01 00 00 00       	mov    $0x1,%edi
    12c2:	b0 00                	mov    $0x0,%al
    12c4:	e8 9c 10 00 00       	call   2365 <printf>
        exit();
    12c9:	e8 b4 0e 00 00       	call   2182 <exit>
    }
  }
  close(fd);
    12ce:	89 df                	mov    %ebx,%edi
    12d0:	e8 df 0e 00 00       	call   21b4 <close>

  if(n != 40){
    12d5:	41 83 fc 28          	cmp    $0x28,%r12d
    12d9:	75 0a                	jne    12e5 <concreate+0x1bf>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    12db:	bb 00 00 00 00       	mov    $0x0,%ebx
    12e0:	e9 91 00 00 00       	jmp    1376 <concreate+0x250>
    printf(1, "concreate not enough files in directory listing\n");
    12e5:	be f0 30 00 00       	mov    $0x30f0,%esi
    12ea:	bf 01 00 00 00       	mov    $0x1,%edi
    12ef:	b0 00                	mov    $0x0,%al
    12f1:	e8 6f 10 00 00       	call   2365 <printf>
    exit();
    12f6:	e8 87 0e 00 00       	call   2182 <exit>
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    12fb:	be 6a 2e 00 00       	mov    $0x2e6a,%esi
    1300:	bf 01 00 00 00       	mov    $0x1,%edi
    1305:	b0 00                	mov    $0x0,%al
    1307:	e8 59 10 00 00       	call   2365 <printf>
      exit();
    130c:	e8 71 0e 00 00       	call   2182 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    1311:	4c 8d 6d dd          	lea    -0x23(%rbp),%r13
    1315:	be 00 00 00 00       	mov    $0x0,%esi
    131a:	4c 89 ef             	mov    %r13,%rdi
    131d:	e8 b0 0e 00 00       	call   21d2 <open>
    1322:	89 c7                	mov    %eax,%edi
    1324:	e8 8b 0e 00 00       	call   21b4 <close>
      close(open(file, 0));
    1329:	be 00 00 00 00       	mov    $0x0,%esi
    132e:	4c 89 ef             	mov    %r13,%rdi
    1331:	e8 9c 0e 00 00       	call   21d2 <open>
    1336:	89 c7                	mov    %eax,%edi
    1338:	e8 77 0e 00 00       	call   21b4 <close>
      close(open(file, 0));
    133d:	be 00 00 00 00       	mov    $0x0,%esi
    1342:	4c 89 ef             	mov    %r13,%rdi
    1345:	e8 88 0e 00 00       	call   21d2 <open>
    134a:	89 c7                	mov    %eax,%edi
    134c:	e8 63 0e 00 00       	call   21b4 <close>
      close(open(file, 0));
    1351:	be 00 00 00 00       	mov    $0x0,%esi
    1356:	4c 89 ef             	mov    %r13,%rdi
    1359:	e8 74 0e 00 00       	call   21d2 <open>
    135e:	89 c7                	mov    %eax,%edi
    1360:	e8 4f 0e 00 00       	call   21b4 <close>
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    1365:	45 85 e4             	test   %r12d,%r12d
    1368:	0f 84 81 00 00 00    	je     13ef <concreate+0x2c9>
      exit();
    else
      wait();
    136e:	e8 19 0e 00 00       	call   218c <wait>
  for(i = 0; i < 40; i++){
    1373:	83 c3 01             	add    $0x1,%ebx
    1376:	83 fb 27             	cmp    $0x27,%ebx
    1379:	7f 79                	jg     13f4 <concreate+0x2ce>
    file[1] = '0' + i;
    137b:	8d 43 30             	lea    0x30(%rbx),%eax
    137e:	88 45 de             	mov    %al,-0x22(%rbp)
    pid = fork();
    1381:	e8 f2 0d 00 00       	call   2178 <fork>
    1386:	41 89 c4             	mov    %eax,%r12d
    if(pid < 0){
    1389:	85 c0                	test   %eax,%eax
    138b:	0f 88 6a ff ff ff    	js     12fb <concreate+0x1d5>
    if(((i % 3) == 0 && pid == 0) ||
    1391:	48 63 c3             	movslq %ebx,%rax
    1394:	48 69 c0 56 55 55 55 	imul   $0x55555556,%rax,%rax
    139b:	48 c1 e8 20          	shr    $0x20,%rax
    139f:	89 da                	mov    %ebx,%edx
    13a1:	c1 fa 1f             	sar    $0x1f,%edx
    13a4:	29 d0                	sub    %edx,%eax
    13a6:	8d 14 40             	lea    (%rax,%rax,2),%edx
    13a9:	89 d8                	mov    %ebx,%eax
    13ab:	29 d0                	sub    %edx,%eax
    13ad:	89 c1                	mov    %eax,%ecx
    13af:	44 09 e1             	or     %r12d,%ecx
    13b2:	0f 84 59 ff ff ff    	je     1311 <concreate+0x1eb>
    13b8:	83 f8 01             	cmp    $0x1,%eax
    13bb:	75 09                	jne    13c6 <concreate+0x2a0>
       ((i % 3) == 1 && pid != 0)){
    13bd:	45 85 e4             	test   %r12d,%r12d
    13c0:	0f 85 4b ff ff ff    	jne    1311 <concreate+0x1eb>
      unlink(file);
    13c6:	4c 8d 6d dd          	lea    -0x23(%rbp),%r13
    13ca:	4c 89 ef             	mov    %r13,%rdi
    13cd:	e8 14 0e 00 00       	call   21e6 <unlink>
      unlink(file);
    13d2:	4c 89 ef             	mov    %r13,%rdi
    13d5:	e8 0c 0e 00 00       	call   21e6 <unlink>
      unlink(file);
    13da:	4c 89 ef             	mov    %r13,%rdi
    13dd:	e8 04 0e 00 00       	call   21e6 <unlink>
      unlink(file);
    13e2:	4c 89 ef             	mov    %r13,%rdi
    13e5:	e8 fc 0d 00 00       	call   21e6 <unlink>
    13ea:	e9 76 ff ff ff       	jmp    1365 <concreate+0x23f>
      exit();
    13ef:	e8 8e 0d 00 00       	call   2182 <exit>
  }

  printf(1, "concreate ok\n");
    13f4:	be 98 2c 00 00       	mov    $0x2c98,%esi
    13f9:	bf 01 00 00 00       	mov    $0x1,%edi
    13fe:	b0 00                	mov    $0x0,%al
    1400:	e8 60 0f 00 00       	call   2365 <printf>
}
    1405:	48 83 c4 48          	add    $0x48,%rsp
    1409:	5b                   	pop    %rbx
    140a:	41 5c                	pop    %r12
    140c:	41 5d                	pop    %r13
    140e:	5d                   	pop    %rbp
    140f:	c3                   	ret

0000000000001410 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1410:	55                   	push   %rbp
    1411:	48 89 e5             	mov    %rsp,%rbp
    1414:	41 55                	push   %r13
    1416:	41 54                	push   %r12
    1418:	53                   	push   %rbx
    1419:	48 83 ec 08          	sub    $0x8,%rsp
  int pid, i;

  printf(1, "linkunlink test\n");
    141d:	be a6 2c 00 00       	mov    $0x2ca6,%esi
    1422:	bf 01 00 00 00       	mov    $0x1,%edi
    1427:	b0 00                	mov    $0x0,%al
    1429:	e8 37 0f 00 00       	call   2365 <printf>

  unlink("x");
    142e:	bf de 2a 00 00       	mov    $0x2ade,%edi
    1433:	e8 ae 0d 00 00       	call   21e6 <unlink>
  pid = fork();
    1438:	e8 3b 0d 00 00       	call   2178 <fork>
  if(pid < 0){
    143d:	85 c0                	test   %eax,%eax
    143f:	78 16                	js     1457 <linkunlink+0x47>
    1441:	41 89 c5             	mov    %eax,%r13d
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    1444:	0f 85 89 00 00 00    	jne    14d3 <linkunlink+0xc3>
    144a:	bb 61 00 00 00       	mov    $0x61,%ebx
    144f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    1455:	eb 3c                	jmp    1493 <linkunlink+0x83>
    printf(1, "fork failed\n");
    1457:	be 6a 2e 00 00       	mov    $0x2e6a,%esi
    145c:	bf 01 00 00 00       	mov    $0x1,%edi
    1461:	b0 00                	mov    $0x0,%al
    1463:	e8 fd 0e 00 00       	call   2365 <printf>
    exit();
    1468:	e8 15 0d 00 00       	call   2182 <exit>
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    146d:	be 02 02 00 00       	mov    $0x202,%esi
    1472:	bf de 2a 00 00       	mov    $0x2ade,%edi
    1477:	e8 56 0d 00 00       	call   21d2 <open>
    147c:	89 c7                	mov    %eax,%edi
    147e:	e8 31 0d 00 00       	call   21b4 <close>
    1483:	eb 0a                	jmp    148f <linkunlink+0x7f>
    } else if((x % 3) == 1){
      link("cat", "x");
    } else {
      unlink("x");
    1485:	bf de 2a 00 00       	mov    $0x2ade,%edi
    148a:	e8 57 0d 00 00       	call   21e6 <unlink>
  for(i = 0; i < 100; i++){
    148f:	41 83 c4 01          	add    $0x1,%r12d
    1493:	41 83 fc 63          	cmp    $0x63,%r12d
    1497:	7f 44                	jg     14dd <linkunlink+0xcd>
    x = x * 1103515245 + 12345;
    1499:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
    149f:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
    14a5:	89 d8                	mov    %ebx,%eax
    14a7:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    14ac:	48 0f af c2          	imul   %rdx,%rax
    14b0:	48 c1 e8 21          	shr    $0x21,%rax
    14b4:	8d 14 40             	lea    (%rax,%rax,2),%edx
    14b7:	89 d8                	mov    %ebx,%eax
    14b9:	29 d0                	sub    %edx,%eax
    14bb:	74 b0                	je     146d <linkunlink+0x5d>
    } else if((x % 3) == 1){
    14bd:	83 f8 01             	cmp    $0x1,%eax
    14c0:	75 c3                	jne    1485 <linkunlink+0x75>
      link("cat", "x");
    14c2:	be de 2a 00 00       	mov    $0x2ade,%esi
    14c7:	bf b7 2c 00 00       	mov    $0x2cb7,%edi
    14cc:	e8 29 0d 00 00       	call   21fa <link>
    14d1:	eb bc                	jmp    148f <linkunlink+0x7f>
  unsigned int x = (pid ? 1 : 97);
    14d3:	bb 01 00 00 00       	mov    $0x1,%ebx
    14d8:	e9 72 ff ff ff       	jmp    144f <linkunlink+0x3f>
    }
  }

  if(pid)
    14dd:	45 85 ed             	test   %r13d,%r13d
    14e0:	74 21                	je     1503 <linkunlink+0xf3>
    wait();
    14e2:	e8 a5 0c 00 00       	call   218c <wait>
  else
    exit();

  printf(1, "linkunlink ok\n");
    14e7:	be bb 2c 00 00       	mov    $0x2cbb,%esi
    14ec:	bf 01 00 00 00       	mov    $0x1,%edi
    14f1:	b0 00                	mov    $0x0,%al
    14f3:	e8 6d 0e 00 00       	call   2365 <printf>
}
    14f8:	48 83 c4 08          	add    $0x8,%rsp
    14fc:	5b                   	pop    %rbx
    14fd:	41 5c                	pop    %r12
    14ff:	41 5d                	pop    %r13
    1501:	5d                   	pop    %rbp
    1502:	c3                   	ret
    exit();
    1503:	e8 7a 0c 00 00       	call   2182 <exit>

0000000000001508 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    1508:	55                   	push   %rbp
    1509:	48 89 e5             	mov    %rsp,%rbp
    150c:	41 55                	push   %r13
    150e:	41 54                	push   %r12
    1510:	53                   	push   %rbx
    1511:	48 83 ec 08          	sub    $0x8,%rsp
  int fd, sz;

  printf(1, "bigwrite test\n");
    1515:	be ca 2c 00 00       	mov    $0x2cca,%esi
    151a:	bf 01 00 00 00       	mov    $0x1,%edi
    151f:	b0 00                	mov    $0x0,%al
    1521:	e8 3f 0e 00 00       	call   2365 <printf>

  unlink("bigwrite");
    1526:	bf d9 2c 00 00       	mov    $0x2cd9,%edi
    152b:	e8 b6 0c 00 00       	call   21e6 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    1530:	41 bc f3 01 00 00    	mov    $0x1f3,%r12d
    1536:	eb 4a                	jmp    1582 <bigwrite+0x7a>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
    1538:	be e2 2c 00 00       	mov    $0x2ce2,%esi
    153d:	bf 01 00 00 00       	mov    $0x1,%edi
    1542:	b0 00                	mov    $0x0,%al
    1544:	e8 1c 0e 00 00       	call   2365 <printf>
      exit();
    1549:	e8 34 0c 00 00       	call   2182 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
    154e:	89 c1                	mov    %eax,%ecx
    1550:	44 89 e2             	mov    %r12d,%edx
    1553:	be fa 2c 00 00       	mov    $0x2cfa,%esi
    1558:	bf 01 00 00 00       	mov    $0x1,%edi
    155d:	b0 00                	mov    $0x0,%al
    155f:	e8 01 0e 00 00       	call   2365 <printf>
        exit();
    1564:	e8 19 0c 00 00       	call   2182 <exit>
      }
    }
    close(fd);
    1569:	44 89 ef             	mov    %r13d,%edi
    156c:	e8 43 0c 00 00       	call   21b4 <close>
    unlink("bigwrite");
    1571:	bf d9 2c 00 00       	mov    $0x2cd9,%edi
    1576:	e8 6b 0c 00 00       	call   21e6 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    157b:	41 81 c4 d7 01 00 00 	add    $0x1d7,%r12d
    1582:	41 81 fc ff 17 00 00 	cmp    $0x17ff,%r12d
    1589:	7f 3a                	jg     15c5 <bigwrite+0xbd>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    158b:	be 02 02 00 00       	mov    $0x202,%esi
    1590:	bf d9 2c 00 00       	mov    $0x2cd9,%edi
    1595:	e8 38 0c 00 00       	call   21d2 <open>
    159a:	41 89 c5             	mov    %eax,%r13d
    if(fd < 0){
    159d:	85 c0                	test   %eax,%eax
    159f:	78 97                	js     1538 <bigwrite+0x30>
    for(i = 0; i < 2; i++){
    15a1:	bb 00 00 00 00       	mov    $0x0,%ebx
    15a6:	83 fb 01             	cmp    $0x1,%ebx
    15a9:	7f be                	jg     1569 <bigwrite+0x61>
      int cc = write(fd, buf, sz);
    15ab:	44 89 e2             	mov    %r12d,%edx
    15ae:	be 60 61 00 00       	mov    $0x6160,%esi
    15b3:	44 89 ef             	mov    %r13d,%edi
    15b6:	e8 ef 0b 00 00       	call   21aa <write>
      if(cc != sz){
    15bb:	41 39 c4             	cmp    %eax,%r12d
    15be:	75 8e                	jne    154e <bigwrite+0x46>
    for(i = 0; i < 2; i++){
    15c0:	83 c3 01             	add    $0x1,%ebx
    15c3:	eb e1                	jmp    15a6 <bigwrite+0x9e>
  }

  printf(1, "bigwrite ok\n");
    15c5:	be 0c 2d 00 00       	mov    $0x2d0c,%esi
    15ca:	bf 01 00 00 00       	mov    $0x1,%edi
    15cf:	b0 00                	mov    $0x0,%al
    15d1:	e8 8f 0d 00 00       	call   2365 <printf>
}
    15d6:	48 83 c4 08          	add    $0x8,%rsp
    15da:	5b                   	pop    %rbx
    15db:	41 5c                	pop    %r12
    15dd:	41 5d                	pop    %r13
    15df:	5d                   	pop    %rbp
    15e0:	c3                   	ret

00000000000015e1 <sbrktest>:

void
sbrktest(void)
{
    15e1:	55                   	push   %rbp
    15e2:	48 89 e5             	mov    %rsp,%rbp
    15e5:	41 55                	push   %r13
    15e7:	41 54                	push   %r12
    15e9:	53                   	push   %rbx
    15ea:	48 83 ec 48          	sub    $0x48,%rsp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    15ee:	be 19 2d 00 00       	mov    $0x2d19,%esi
    15f3:	8b 3d ef 23 00 00    	mov    0x23ef(%rip),%edi        # 39e8 <stdout>
    15f9:	b0 00                	mov    $0x0,%al
    15fb:	e8 65 0d 00 00       	call   2365 <printf>
  oldbrk = sbrk(0);
    1600:	bf 00 00 00 00       	mov    $0x0,%edi
    1605:	e8 22 0c 00 00       	call   222c <sbrk>
    160a:	49 89 c5             	mov    %rax,%r13

  // can one sbrk() less than a page?
  a = sbrk(0);
    160d:	bf 00 00 00 00       	mov    $0x0,%edi
    1612:	e8 15 0c 00 00       	call   222c <sbrk>
    1617:	49 89 c4             	mov    %rax,%r12
  int i;
  for(i = 0; i < 5000; i++){
    161a:	bb 00 00 00 00       	mov    $0x0,%ebx
    161f:	81 fb 87 13 00 00    	cmp    $0x1387,%ebx
    1625:	7f 3a                	jg     1661 <sbrktest+0x80>
    b = sbrk(1);
    1627:	bf 01 00 00 00       	mov    $0x1,%edi
    162c:	e8 fb 0b 00 00       	call   222c <sbrk>
    if(b != a){
    1631:	49 39 c4             	cmp    %rax,%r12
    1634:	75 0c                	jne    1642 <sbrktest+0x61>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    1636:	c6 00 01             	movb   $0x1,(%rax)
    a = b + 1;
    1639:	4c 8d 60 01          	lea    0x1(%rax),%r12
  for(i = 0; i < 5000; i++){
    163d:	83 c3 01             	add    $0x1,%ebx
    1640:	eb dd                	jmp    161f <sbrktest+0x3e>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    1642:	49 89 c0             	mov    %rax,%r8
    1645:	4c 89 e1             	mov    %r12,%rcx
    1648:	89 da                	mov    %ebx,%edx
    164a:	be 24 2d 00 00       	mov    $0x2d24,%esi
    164f:	8b 3d 93 23 00 00    	mov    0x2393(%rip),%edi        # 39e8 <stdout>
    1655:	b0 00                	mov    $0x0,%al
    1657:	e8 09 0d 00 00       	call   2365 <printf>
      exit();
    165c:	e8 21 0b 00 00       	call   2182 <exit>
  }
  pid = fork();
    1661:	e8 12 0b 00 00       	call   2178 <fork>
    1666:	89 c3                	mov    %eax,%ebx
  if(pid < 0){
    1668:	85 c0                	test   %eax,%eax
    166a:	0f 88 58 01 00 00    	js     17c8 <sbrktest+0x1e7>
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    1670:	bf 01 00 00 00       	mov    $0x1,%edi
    1675:	e8 b2 0b 00 00       	call   222c <sbrk>
  c = sbrk(1);
    167a:	bf 01 00 00 00       	mov    $0x1,%edi
    167f:	e8 a8 0b 00 00       	call   222c <sbrk>
  if(c != a + 1){
    1684:	49 83 c4 01          	add    $0x1,%r12
    1688:	49 39 c4             	cmp    %rax,%r12
    168b:	0f 85 4e 01 00 00    	jne    17df <sbrktest+0x1fe>
    printf(stdout, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    1691:	85 db                	test   %ebx,%ebx
    1693:	0f 84 5d 01 00 00    	je     17f6 <sbrktest+0x215>
    exit();
  wait();
    1699:	e8 ee 0a 00 00       	call   218c <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    169e:	bf 00 00 00 00       	mov    $0x0,%edi
    16a3:	e8 84 0b 00 00       	call   222c <sbrk>
    16a8:	48 89 c3             	mov    %rax,%rbx
  amt = (BIG) - (uint64)a;
    16ab:	bf 00 00 40 06       	mov    $0x6400000,%edi
    16b0:	29 c7                	sub    %eax,%edi
  p = sbrk(amt);
    16b2:	e8 75 0b 00 00       	call   222c <sbrk>
  if (p != a) {
    16b7:	48 39 c3             	cmp    %rax,%rbx
    16ba:	0f 85 3b 01 00 00    	jne    17fb <sbrktest+0x21a>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    16c0:	c6 04 25 ff ff 3f 06 	movb   $0x63,0x63fffff
    16c7:	63 

  // can one de-allocate?
  a = sbrk(0);
    16c8:	bf 00 00 00 00       	mov    $0x0,%edi
    16cd:	e8 5a 0b 00 00       	call   222c <sbrk>
    16d2:	48 89 c3             	mov    %rax,%rbx
  c = sbrk(-4096);
    16d5:	bf 00 f0 ff ff       	mov    $0xfffff000,%edi
    16da:	e8 4d 0b 00 00       	call   222c <sbrk>
    16df:	48 89 c2             	mov    %rax,%rdx
  if(c == (char*)0xffffffff){
    16e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    16e7:	48 39 c2             	cmp    %rax,%rdx
    16ea:	0f 84 22 01 00 00    	je     1812 <sbrktest+0x231>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    16f0:	bf 00 00 00 00       	mov    $0x0,%edi
    16f5:	e8 32 0b 00 00       	call   222c <sbrk>
  if(c != a - 4096){
    16fa:	48 8d 93 00 f0 ff ff 	lea    -0x1000(%rbx),%rdx
    1701:	48 39 c2             	cmp    %rax,%rdx
    1704:	0f 85 1f 01 00 00    	jne    1829 <sbrktest+0x248>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    170a:	bf 00 00 00 00       	mov    $0x0,%edi
    170f:	e8 18 0b 00 00       	call   222c <sbrk>
    1714:	48 89 c3             	mov    %rax,%rbx
  c = sbrk(4096);
    1717:	bf 00 10 00 00       	mov    $0x1000,%edi
    171c:	e8 0b 0b 00 00       	call   222c <sbrk>
    1721:	49 89 c4             	mov    %rax,%r12
  if(c != a || sbrk(0) != a + 4096){
    1724:	48 39 c3             	cmp    %rax,%rbx
    1727:	0f 85 19 01 00 00    	jne    1846 <sbrktest+0x265>
    172d:	bf 00 00 00 00       	mov    $0x0,%edi
    1732:	e8 f5 0a 00 00       	call   222c <sbrk>
    1737:	48 8d 93 00 10 00 00 	lea    0x1000(%rbx),%rdx
    173e:	48 39 c2             	cmp    %rax,%rdx
    1741:	0f 85 ff 00 00 00    	jne    1846 <sbrktest+0x265>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    1747:	0f be 04 25 ff ff 3f 	movsbl 0x63fffff,%eax
    174e:	06 
    174f:	83 f8 63             	cmp    $0x63,%eax
    1752:	0f 84 0b 01 00 00    	je     1863 <sbrktest+0x282>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    1758:	bf 00 00 00 00       	mov    $0x0,%edi
    175d:	e8 ca 0a 00 00       	call   222c <sbrk>
    1762:	48 89 c3             	mov    %rax,%rbx
  c = sbrk(-(sbrk(0) - oldbrk));
    1765:	bf 00 00 00 00       	mov    $0x0,%edi
    176a:	e8 bd 0a 00 00       	call   222c <sbrk>
    176f:	44 89 ef             	mov    %r13d,%edi
    1772:	29 c7                	sub    %eax,%edi
    1774:	e8 b3 0a 00 00       	call   222c <sbrk>
  if(c != a){
    1779:	48 39 c3             	cmp    %rax,%rbx
    177c:	0f 85 f8 00 00 00    	jne    187a <sbrktest+0x299>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1782:	48 bb 00 00 00 00 00 	movabs $0x80000000000,%rbx
    1789:	08 00 00 
    178c:	48 b8 7f 84 1e 00 00 	movabs $0x800001e847f,%rax
    1793:	08 00 00 
    1796:	48 39 d8             	cmp    %rbx,%rax
    1799:	0f 82 32 01 00 00    	jb     18d1 <sbrktest+0x2f0>
    ppid = getpid();
    179f:	e8 7e 0a 00 00       	call   2222 <getpid>
    17a4:	41 89 c4             	mov    %eax,%r12d
    pid = fork();
    17a7:	e8 cc 09 00 00       	call   2178 <fork>
    if(pid < 0){
    17ac:	85 c0                	test   %eax,%eax
    17ae:	0f 88 e3 00 00 00    	js     1897 <sbrktest+0x2b6>
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
    17b4:	0f 84 f4 00 00 00    	je     18ae <sbrktest+0x2cd>
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
    17ba:	e8 cd 09 00 00       	call   218c <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    17bf:	48 81 c3 50 c3 00 00 	add    $0xc350,%rbx
    17c6:	eb c4                	jmp    178c <sbrktest+0x1ab>
    printf(stdout, "sbrk test fork failed\n");
    17c8:	be 3f 2d 00 00       	mov    $0x2d3f,%esi
    17cd:	8b 3d 15 22 00 00    	mov    0x2215(%rip),%edi        # 39e8 <stdout>
    17d3:	b0 00                	mov    $0x0,%al
    17d5:	e8 8b 0b 00 00       	call   2365 <printf>
    exit();
    17da:	e8 a3 09 00 00       	call   2182 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    17df:	be 56 2d 00 00       	mov    $0x2d56,%esi
    17e4:	8b 3d fe 21 00 00    	mov    0x21fe(%rip),%edi        # 39e8 <stdout>
    17ea:	b0 00                	mov    $0x0,%al
    17ec:	e8 74 0b 00 00       	call   2365 <printf>
    exit();
    17f1:	e8 8c 09 00 00       	call   2182 <exit>
    exit();
    17f6:	e8 87 09 00 00       	call   2182 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    17fb:	be 28 31 00 00       	mov    $0x3128,%esi
    1800:	8b 3d e2 21 00 00    	mov    0x21e2(%rip),%edi        # 39e8 <stdout>
    1806:	b0 00                	mov    $0x0,%al
    1808:	e8 58 0b 00 00       	call   2365 <printf>
    exit();
    180d:	e8 70 09 00 00       	call   2182 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    1812:	be 72 2d 00 00       	mov    $0x2d72,%esi
    1817:	8b 3d cb 21 00 00    	mov    0x21cb(%rip),%edi        # 39e8 <stdout>
    181d:	b0 00                	mov    $0x0,%al
    181f:	e8 41 0b 00 00       	call   2365 <printf>
    exit();
    1824:	e8 59 09 00 00       	call   2182 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    1829:	48 89 c1             	mov    %rax,%rcx
    182c:	48 89 da             	mov    %rbx,%rdx
    182f:	be 68 31 00 00       	mov    $0x3168,%esi
    1834:	8b 3d ae 21 00 00    	mov    0x21ae(%rip),%edi        # 39e8 <stdout>
    183a:	b0 00                	mov    $0x0,%al
    183c:	e8 24 0b 00 00       	call   2365 <printf>
    exit();
    1841:	e8 3c 09 00 00       	call   2182 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    1846:	4c 89 e1             	mov    %r12,%rcx
    1849:	48 89 da             	mov    %rbx,%rdx
    184c:	be a0 31 00 00       	mov    $0x31a0,%esi
    1851:	8b 3d 91 21 00 00    	mov    0x2191(%rip),%edi        # 39e8 <stdout>
    1857:	b0 00                	mov    $0x0,%al
    1859:	e8 07 0b 00 00       	call   2365 <printf>
    exit();
    185e:	e8 1f 09 00 00       	call   2182 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    1863:	be c8 31 00 00       	mov    $0x31c8,%esi
    1868:	8b 3d 7a 21 00 00    	mov    0x217a(%rip),%edi        # 39e8 <stdout>
    186e:	b0 00                	mov    $0x0,%al
    1870:	e8 f0 0a 00 00       	call   2365 <printf>
    exit();
    1875:	e8 08 09 00 00       	call   2182 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    187a:	48 89 c1             	mov    %rax,%rcx
    187d:	48 89 da             	mov    %rbx,%rdx
    1880:	be f8 31 00 00       	mov    $0x31f8,%esi
    1885:	8b 3d 5d 21 00 00    	mov    0x215d(%rip),%edi        # 39e8 <stdout>
    188b:	b0 00                	mov    $0x0,%al
    188d:	e8 d3 0a 00 00       	call   2365 <printf>
    exit();
    1892:	e8 eb 08 00 00       	call   2182 <exit>
      printf(stdout, "fork failed\n");
    1897:	be 6a 2e 00 00       	mov    $0x2e6a,%esi
    189c:	8b 3d 46 21 00 00    	mov    0x2146(%rip),%edi        # 39e8 <stdout>
    18a2:	b0 00                	mov    $0x0,%al
    18a4:	e8 bc 0a 00 00       	call   2365 <printf>
      exit();
    18a9:	e8 d4 08 00 00       	call   2182 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    18ae:	0f be 0b             	movsbl (%rbx),%ecx
    18b1:	48 89 da             	mov    %rbx,%rdx
    18b4:	be 8d 2d 00 00       	mov    $0x2d8d,%esi
    18b9:	8b 3d 29 21 00 00    	mov    0x2129(%rip),%edi        # 39e8 <stdout>
    18bf:	e8 a1 0a 00 00       	call   2365 <printf>
      kill(ppid);
    18c4:	44 89 e7             	mov    %r12d,%edi
    18c7:	e8 f2 08 00 00       	call   21be <kill>
      exit();
    18cc:	e8 b1 08 00 00       	call   2182 <exit>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    18d1:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
    18d5:	e8 bc 08 00 00       	call   2196 <pipe>
    18da:	89 c3                	mov    %eax,%ebx
    18dc:	85 c0                	test   %eax,%eax
    18de:	75 05                	jne    18e5 <sbrktest+0x304>
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    18e0:	41 89 c4             	mov    %eax,%r12d
    18e3:	eb 4e                	jmp    1933 <sbrktest+0x352>
    printf(1, "pipe() failed\n");
    18e5:	be 79 2a 00 00       	mov    $0x2a79,%esi
    18ea:	bf 01 00 00 00       	mov    $0x1,%edi
    18ef:	b0 00                	mov    $0x0,%al
    18f1:	e8 6f 0a 00 00       	call   2365 <printf>
    exit();
    18f6:	e8 87 08 00 00       	call   2182 <exit>
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint64)sbrk(0));
    18fb:	bf 00 00 00 00       	mov    $0x0,%edi
    1900:	e8 27 09 00 00       	call   222c <sbrk>
    1905:	bf 00 00 40 06       	mov    $0x6400000,%edi
    190a:	29 c7                	sub    %eax,%edi
    190c:	e8 1b 09 00 00       	call   222c <sbrk>
      write(fds[1], "x", 1);
    1911:	ba 01 00 00 00       	mov    $0x1,%edx
    1916:	be de 2a 00 00       	mov    $0x2ade,%esi
    191b:	8b 7d dc             	mov    -0x24(%rbp),%edi
    191e:	e8 87 08 00 00       	call   21aa <write>
      // sit around until killed
      for(;;) sleep(1000);
    1923:	bf e8 03 00 00       	mov    $0x3e8,%edi
    1928:	e8 09 09 00 00       	call   2236 <sleep>
    192d:	eb f4                	jmp    1923 <sbrktest+0x342>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    192f:	41 83 c4 01          	add    $0x1,%r12d
    1933:	41 83 fc 09          	cmp    $0x9,%r12d
    1937:	77 28                	ja     1961 <sbrktest+0x380>
    if((pids[i] = fork()) == 0){
    1939:	e8 3a 08 00 00       	call   2178 <fork>
    193e:	49 63 d4             	movslq %r12d,%rdx
    1941:	89 44 95 b0          	mov    %eax,-0x50(%rbp,%rdx,4)
    1945:	85 c0                	test   %eax,%eax
    1947:	74 b2                	je     18fb <sbrktest+0x31a>
    }
    if(pids[i] != -1)
    1949:	83 f8 ff             	cmp    $0xffffffff,%eax
    194c:	74 e1                	je     192f <sbrktest+0x34e>
      read(fds[0], &scratch, 1);
    194e:	48 8d 75 af          	lea    -0x51(%rbp),%rsi
    1952:	ba 01 00 00 00       	mov    $0x1,%edx
    1957:	8b 7d d8             	mov    -0x28(%rbp),%edi
    195a:	e8 41 08 00 00       	call   21a0 <read>
    195f:	eb ce                	jmp    192f <sbrktest+0x34e>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    1961:	bf 00 10 00 00       	mov    $0x1000,%edi
    1966:	e8 c1 08 00 00       	call   222c <sbrk>
    196b:	49 89 c4             	mov    %rax,%r12
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    196e:	eb 13                	jmp    1983 <sbrktest+0x3a2>
    1970:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1977:	00 00 00 00 
    197b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1980:	83 c3 01             	add    $0x1,%ebx
    1983:	83 fb 09             	cmp    $0x9,%ebx
    1986:	77 18                	ja     19a0 <sbrktest+0x3bf>
    if(pids[i] == -1)
    1988:	48 63 c3             	movslq %ebx,%rax
    198b:	8b 7c 85 b0          	mov    -0x50(%rbp,%rax,4),%edi
    198f:	83 ff ff             	cmp    $0xffffffff,%edi
    1992:	74 ec                	je     1980 <sbrktest+0x39f>
      continue;
    kill(pids[i]);
    1994:	e8 25 08 00 00       	call   21be <kill>
    wait();
    1999:	e8 ee 07 00 00       	call   218c <wait>
    199e:	eb e0                	jmp    1980 <sbrktest+0x39f>
  }
  if(c == (char*)0xffffffff){
    19a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    19a5:	49 39 c4             	cmp    %rax,%r12
    19a8:	74 2c                	je     19d6 <sbrktest+0x3f5>
    printf(stdout, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
    19aa:	bf 00 00 00 00       	mov    $0x0,%edi
    19af:	e8 78 08 00 00       	call   222c <sbrk>
    19b4:	49 39 c5             	cmp    %rax,%r13
    19b7:	72 34                	jb     19ed <sbrktest+0x40c>
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
    19b9:	be c1 2d 00 00       	mov    $0x2dc1,%esi
    19be:	8b 3d 24 20 00 00    	mov    0x2024(%rip),%edi        # 39e8 <stdout>
    19c4:	b0 00                	mov    $0x0,%al
    19c6:	e8 9a 09 00 00       	call   2365 <printf>
}
    19cb:	48 83 c4 48          	add    $0x48,%rsp
    19cf:	5b                   	pop    %rbx
    19d0:	41 5c                	pop    %r12
    19d2:	41 5d                	pop    %r13
    19d4:	5d                   	pop    %rbp
    19d5:	c3                   	ret
    printf(stdout, "failed sbrk leaked memory\n");
    19d6:	be a6 2d 00 00       	mov    $0x2da6,%esi
    19db:	8b 3d 07 20 00 00    	mov    0x2007(%rip),%edi        # 39e8 <stdout>
    19e1:	b0 00                	mov    $0x0,%al
    19e3:	e8 7d 09 00 00       	call   2365 <printf>
    exit();
    19e8:	e8 95 07 00 00       	call   2182 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    19ed:	bf 00 00 00 00       	mov    $0x0,%edi
    19f2:	e8 35 08 00 00       	call   222c <sbrk>
    19f7:	44 89 ef             	mov    %r13d,%edi
    19fa:	29 c7                	sub    %eax,%edi
    19fc:	e8 2b 08 00 00       	call   222c <sbrk>
    1a01:	eb b6                	jmp    19b9 <sbrktest+0x3d8>

0000000000001a03 <validateint>:
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    1a03:	c3                   	ret

0000000000001a04 <validatetest>:

void
validatetest(void)
{
    1a04:	55                   	push   %rbp
    1a05:	48 89 e5             	mov    %rsp,%rbp
    1a08:	41 54                	push   %r12
    1a0a:	53                   	push   %rbx
  int64 hi;
  int pid;
  uint64 p;

  printf(stdout, "validate test\n");
    1a0b:	be cf 2d 00 00       	mov    $0x2dcf,%esi
    1a10:	8b 3d d2 1f 00 00    	mov    0x1fd2(%rip),%edi        # 39e8 <stdout>
    1a16:	b0 00                	mov    $0x0,%al
    1a18:	e8 48 09 00 00       	call   2365 <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint64)hi; p += 4096){
    1a1d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    1a23:	49 81 fc 00 30 11 00 	cmp    $0x113000,%r12
    1a2a:	77 62                	ja     1a8e <validatetest+0x8a>
    if((pid = fork()) == 0){
    1a2c:	e8 47 07 00 00       	call   2178 <fork>
    1a31:	89 c3                	mov    %eax,%ebx
    1a33:	85 c0                	test   %eax,%eax
    1a35:	74 3b                	je     1a72 <validatetest+0x6e>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int64*)p);
      exit();
    }
    sleep(0);
    1a37:	bf 00 00 00 00       	mov    $0x0,%edi
    1a3c:	e8 f5 07 00 00       	call   2236 <sleep>
    sleep(0);
    1a41:	bf 00 00 00 00       	mov    $0x0,%edi
    1a46:	e8 eb 07 00 00       	call   2236 <sleep>
    kill(pid);
    1a4b:	89 df                	mov    %ebx,%edi
    1a4d:	e8 6c 07 00 00       	call   21be <kill>
    wait();
    1a52:	e8 35 07 00 00       	call   218c <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    1a57:	4c 89 e6             	mov    %r12,%rsi
    1a5a:	bf de 2d 00 00       	mov    $0x2dde,%edi
    1a5f:	e8 96 07 00 00       	call   21fa <link>
    1a64:	83 f8 ff             	cmp    $0xffffffff,%eax
    1a67:	75 0e                	jne    1a77 <validatetest+0x73>
  for(p = 0; p <= (uint64)hi; p += 4096){
    1a69:	49 81 c4 00 10 00 00 	add    $0x1000,%r12
    1a70:	eb b1                	jmp    1a23 <validatetest+0x1f>
      exit();
    1a72:	e8 0b 07 00 00       	call   2182 <exit>
      printf(stdout, "link should not succeed\n");
    1a77:	be e9 2d 00 00       	mov    $0x2de9,%esi
    1a7c:	8b 3d 66 1f 00 00    	mov    0x1f66(%rip),%edi        # 39e8 <stdout>
    1a82:	b0 00                	mov    $0x0,%al
    1a84:	e8 dc 08 00 00       	call   2365 <printf>
      exit();
    1a89:	e8 f4 06 00 00       	call   2182 <exit>
    }
  }

  printf(stdout, "validate ok\n");
    1a8e:	be 02 2e 00 00       	mov    $0x2e02,%esi
    1a93:	8b 3d 4f 1f 00 00    	mov    0x1f4f(%rip),%edi        # 39e8 <stdout>
    1a99:	b0 00                	mov    $0x0,%al
    1a9b:	e8 c5 08 00 00       	call   2365 <printf>
}
    1aa0:	5b                   	pop    %rbx
    1aa1:	41 5c                	pop    %r12
    1aa3:	5d                   	pop    %rbp
    1aa4:	c3                   	ret

0000000000001aa5 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    1aa5:	55                   	push   %rbp
    1aa6:	48 89 e5             	mov    %rsp,%rbp
  int i;

  printf(stdout, "bss test\n");
    1aa9:	be 0f 2e 00 00       	mov    $0x2e0f,%esi
    1aae:	8b 3d 34 1f 00 00    	mov    0x1f34(%rip),%edi        # 39e8 <stdout>
    1ab4:	b0 00                	mov    $0x0,%al
    1ab6:	e8 aa 08 00 00       	call   2365 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    1abb:	b8 00 00 00 00       	mov    $0x0,%eax
    1ac0:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    1ac5:	77 2a                	ja     1af1 <bsstest+0x4c>
    if(uninit[i] != '\0'){
    1ac7:	48 63 d0             	movslq %eax,%rdx
    1aca:	0f be 92 40 3a 00 00 	movsbl 0x3a40(%rdx),%edx
    1ad1:	85 d2                	test   %edx,%edx
    1ad3:	75 05                	jne    1ada <bsstest+0x35>
  for(i = 0; i < sizeof(uninit); i++){
    1ad5:	83 c0 01             	add    $0x1,%eax
    1ad8:	eb e6                	jmp    1ac0 <bsstest+0x1b>
      printf(stdout, "bss test failed\n");
    1ada:	be 19 2e 00 00       	mov    $0x2e19,%esi
    1adf:	8b 3d 03 1f 00 00    	mov    0x1f03(%rip),%edi        # 39e8 <stdout>
    1ae5:	b0 00                	mov    $0x0,%al
    1ae7:	e8 79 08 00 00       	call   2365 <printf>
      exit();
    1aec:	e8 91 06 00 00       	call   2182 <exit>
    }
  }
  printf(stdout, "bss test ok\n");
    1af1:	be 2a 2e 00 00       	mov    $0x2e2a,%esi
    1af6:	8b 3d ec 1e 00 00    	mov    0x1eec(%rip),%edi        # 39e8 <stdout>
    1afc:	b0 00                	mov    $0x0,%al
    1afe:	e8 62 08 00 00       	call   2365 <printf>
}
    1b03:	5d                   	pop    %rbp
    1b04:	c3                   	ret

0000000000001b05 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    1b05:	55                   	push   %rbp
    1b06:	48 89 e5             	mov    %rsp,%rbp
  int pid, fd;

  unlink("bigarg-ok");
    1b09:	bf 37 2e 00 00       	mov    $0x2e37,%edi
    1b0e:	e8 d3 06 00 00       	call   21e6 <unlink>
  pid = fork();
    1b13:	e8 60 06 00 00       	call   2178 <fork>
  if(pid == 0){
    1b18:	85 c0                	test   %eax,%eax
    1b1a:	74 56                	je     1b72 <bigargtest+0x6d>
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    1b1c:	0f 88 ae 00 00 00    	js     1bd0 <bigargtest+0xcb>
    printf(stdout, "bigargtest: fork failed\n");
    exit();
  }
  wait();
    1b22:	e8 65 06 00 00       	call   218c <wait>
  fd = open("bigarg-ok", 0);
    1b27:	be 00 00 00 00       	mov    $0x0,%esi
    1b2c:	bf 37 2e 00 00       	mov    $0x2e37,%edi
    1b31:	e8 9c 06 00 00       	call   21d2 <open>
    1b36:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    1b38:	85 c0                	test   %eax,%eax
    1b3a:	0f 88 a7 00 00 00    	js     1be7 <bigargtest+0xe2>
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
    1b40:	e8 6f 06 00 00       	call   21b4 <close>
  unlink("bigarg-ok");
    1b45:	bf 37 2e 00 00       	mov    $0x2e37,%edi
    1b4a:	e8 97 06 00 00       	call   21e6 <unlink>
}
    1b4f:	5d                   	pop    %rbp
    1b50:	c3                   	ret
    1b51:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1b58:	00 00 00 00 
    1b5c:	0f 1f 40 00          	nopl   0x0(%rax)
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    1b60:	48 63 d0             	movslq %eax,%rdx
    1b63:	48 c7 04 d5 60 81 00 	movq   $0x3220,0x8160(,%rdx,8)
    1b6a:	00 20 32 00 00 
    for(i = 0; i < MAXARG-1; i++)
    1b6f:	83 c0 01             	add    $0x1,%eax
    1b72:	83 f8 1e             	cmp    $0x1e,%eax
    1b75:	7e e9                	jle    1b60 <bigargtest+0x5b>
    args[MAXARG-1] = 0;
    1b77:	48 c7 05 d6 66 00 00 	movq   $0x0,0x66d6(%rip)        # 8258 <args.0+0xf8>
    1b7e:	00 00 00 00 
    printf(stdout, "bigarg test\n");
    1b82:	be 41 2e 00 00       	mov    $0x2e41,%esi
    1b87:	8b 3d 5b 1e 00 00    	mov    0x1e5b(%rip),%edi        # 39e8 <stdout>
    1b8d:	b0 00                	mov    $0x0,%al
    1b8f:	e8 d1 07 00 00       	call   2365 <printf>
    exec("echo", args);
    1b94:	be 60 81 00 00       	mov    $0x8160,%esi
    1b99:	bf 3b 27 00 00       	mov    $0x273b,%edi
    1b9e:	e8 25 06 00 00       	call   21c8 <exec>
    printf(stdout, "bigarg test ok\n");
    1ba3:	be 4e 2e 00 00       	mov    $0x2e4e,%esi
    1ba8:	8b 3d 3a 1e 00 00    	mov    0x1e3a(%rip),%edi        # 39e8 <stdout>
    1bae:	b0 00                	mov    $0x0,%al
    1bb0:	e8 b0 07 00 00       	call   2365 <printf>
    fd = open("bigarg-ok", O_CREATE);
    1bb5:	be 00 02 00 00       	mov    $0x200,%esi
    1bba:	bf 37 2e 00 00       	mov    $0x2e37,%edi
    1bbf:	e8 0e 06 00 00       	call   21d2 <open>
    1bc4:	89 c7                	mov    %eax,%edi
    close(fd);
    1bc6:	e8 e9 05 00 00       	call   21b4 <close>
    exit();
    1bcb:	e8 b2 05 00 00       	call   2182 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    1bd0:	be 5e 2e 00 00       	mov    $0x2e5e,%esi
    1bd5:	8b 3d 0d 1e 00 00    	mov    0x1e0d(%rip),%edi        # 39e8 <stdout>
    1bdb:	b0 00                	mov    $0x0,%al
    1bdd:	e8 83 07 00 00       	call   2365 <printf>
    exit();
    1be2:	e8 9b 05 00 00       	call   2182 <exit>
    printf(stdout, "bigarg test failed!\n");
    1be7:	be 77 2e 00 00       	mov    $0x2e77,%esi
    1bec:	8b 3d f6 1d 00 00    	mov    0x1df6(%rip),%edi        # 39e8 <stdout>
    1bf2:	b0 00                	mov    $0x0,%al
    1bf4:	e8 6c 07 00 00       	call   2365 <printf>
    exit();
    1bf9:	e8 84 05 00 00       	call   2182 <exit>

0000000000001bfe <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    1bfe:	55                   	push   %rbp
    1bff:	48 89 e5             	mov    %rsp,%rbp
    1c02:	41 55                	push   %r13
    1c04:	41 54                	push   %r12
    1c06:	53                   	push   %rbx
    1c07:	48 83 ec 48          	sub    $0x48,%rsp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    1c0b:	be 8c 2e 00 00       	mov    $0x2e8c,%esi
    1c10:	bf 01 00 00 00       	mov    $0x1,%edi
    1c15:	b0 00                	mov    $0x0,%al
    1c17:	e8 49 07 00 00       	call   2365 <printf>

  for(nfiles = 0; ; nfiles++){
    1c1c:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    1c21:	c6 45 a0 66          	movb   $0x66,-0x60(%rbp)
    name[1] = '0' + nfiles / 1000;
    1c25:	48 63 c3             	movslq %ebx,%rax
    1c28:	48 69 d0 d3 4d 62 10 	imul   $0x10624dd3,%rax,%rdx
    1c2f:	48 c1 fa 26          	sar    $0x26,%rdx
    1c33:	89 de                	mov    %ebx,%esi
    1c35:	c1 fe 1f             	sar    $0x1f,%esi
    1c38:	29 f2                	sub    %esi,%edx
    1c3a:	8d 4a 30             	lea    0x30(%rdx),%ecx
    1c3d:	88 4d a1             	mov    %cl,-0x5f(%rbp)
    name[2] = '0' + (nfiles % 1000) / 100;
    1c40:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    1c46:	89 d9                	mov    %ebx,%ecx
    1c48:	29 d1                	sub    %edx,%ecx
    1c4a:	48 63 d1             	movslq %ecx,%rdx
    1c4d:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    1c54:	48 c1 fa 25          	sar    $0x25,%rdx
    1c58:	c1 f9 1f             	sar    $0x1f,%ecx
    1c5b:	29 ca                	sub    %ecx,%edx
    1c5d:	83 c2 30             	add    $0x30,%edx
    1c60:	88 55 a2             	mov    %dl,-0x5e(%rbp)
    name[3] = '0' + (nfiles % 100) / 10;
    1c63:	48 69 d0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rdx
    1c6a:	48 c1 fa 25          	sar    $0x25,%rdx
    1c6e:	29 f2                	sub    %esi,%edx
    1c70:	6b ca 64             	imul   $0x64,%edx,%ecx
    1c73:	89 da                	mov    %ebx,%edx
    1c75:	29 ca                	sub    %ecx,%edx
    1c77:	48 63 ca             	movslq %edx,%rcx
    1c7a:	48 69 c9 67 66 66 66 	imul   $0x66666667,%rcx,%rcx
    1c81:	48 c1 f9 22          	sar    $0x22,%rcx
    1c85:	c1 fa 1f             	sar    $0x1f,%edx
    1c88:	29 d1                	sub    %edx,%ecx
    1c8a:	8d 51 30             	lea    0x30(%rcx),%edx
    1c8d:	88 55 a3             	mov    %dl,-0x5d(%rbp)
    name[4] = '0' + (nfiles % 10);
    1c90:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    1c97:	48 c1 f8 22          	sar    $0x22,%rax
    1c9b:	29 f0                	sub    %esi,%eax
    1c9d:	8d 14 80             	lea    (%rax,%rax,4),%edx
    1ca0:	d1 e2                	shl    $1,%edx
    1ca2:	89 d8                	mov    %ebx,%eax
    1ca4:	29 d0                	sub    %edx,%eax
    1ca6:	83 c0 30             	add    $0x30,%eax
    1ca9:	88 45 a4             	mov    %al,-0x5c(%rbp)
    name[5] = '\0';
    1cac:	c6 45 a5 00          	movb   $0x0,-0x5b(%rbp)
    printf(1, "writing %s\n", name);
    1cb0:	4c 8d 65 a0          	lea    -0x60(%rbp),%r12
    1cb4:	4c 89 e2             	mov    %r12,%rdx
    1cb7:	be 99 2e 00 00       	mov    $0x2e99,%esi
    1cbc:	bf 01 00 00 00       	mov    $0x1,%edi
    1cc1:	b0 00                	mov    $0x0,%al
    1cc3:	e8 9d 06 00 00       	call   2365 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    1cc8:	be 02 02 00 00       	mov    $0x202,%esi
    1ccd:	4c 89 e7             	mov    %r12,%rdi
    1cd0:	e8 fd 04 00 00       	call   21d2 <open>
    1cd5:	41 89 c4             	mov    %eax,%r12d
    if(fd < 0){
    1cd8:	85 c0                	test   %eax,%eax
    1cda:	79 1a                	jns    1cf6 <fsfull+0xf8>
      printf(1, "open %s failed\n", name);
    1cdc:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
    1ce0:	be a5 2e 00 00       	mov    $0x2ea5,%esi
    1ce5:	bf 01 00 00 00       	mov    $0x1,%edi
    1cea:	b0 00                	mov    $0x0,%al
    1cec:	e8 74 06 00 00       	call   2365 <printf>
      break;
    1cf1:	e9 ec 00 00 00       	jmp    1de2 <fsfull+0x1e4>
    }
    int total = 0;
    1cf6:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    while(1){
      int cc = write(fd, buf, 512);
    1cfc:	ba 00 02 00 00       	mov    $0x200,%edx
    1d01:	be 60 61 00 00       	mov    $0x6160,%esi
    1d06:	44 89 e7             	mov    %r12d,%edi
    1d09:	e8 9c 04 00 00       	call   21aa <write>
      if(cc < 512)
    1d0e:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    1d13:	7e 05                	jle    1d1a <fsfull+0x11c>
        break;
      total += cc;
    1d15:	41 01 c5             	add    %eax,%r13d
    while(1){
    1d18:	eb e2                	jmp    1cfc <fsfull+0xfe>
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    1d1a:	44 89 ea             	mov    %r13d,%edx
    1d1d:	be b5 2e 00 00       	mov    $0x2eb5,%esi
    1d22:	bf 01 00 00 00       	mov    $0x1,%edi
    1d27:	b0 00                	mov    $0x0,%al
    1d29:	e8 37 06 00 00       	call   2365 <printf>
    close(fd);
    1d2e:	44 89 e7             	mov    %r12d,%edi
    1d31:	e8 7e 04 00 00       	call   21b4 <close>
    if(total == 0)
    1d36:	45 85 ed             	test   %r13d,%r13d
    1d39:	0f 84 a3 00 00 00    	je     1de2 <fsfull+0x1e4>
  for(nfiles = 0; ; nfiles++){
    1d3f:	83 c3 01             	add    $0x1,%ebx
    1d42:	e9 da fe ff ff       	jmp    1c21 <fsfull+0x23>
      break;
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    1d47:	c6 45 a0 66          	movb   $0x66,-0x60(%rbp)
    name[1] = '0' + nfiles / 1000;
    1d4b:	48 63 c3             	movslq %ebx,%rax
    1d4e:	48 69 d0 d3 4d 62 10 	imul   $0x10624dd3,%rax,%rdx
    1d55:	48 c1 fa 26          	sar    $0x26,%rdx
    1d59:	89 de                	mov    %ebx,%esi
    1d5b:	c1 fe 1f             	sar    $0x1f,%esi
    1d5e:	29 f2                	sub    %esi,%edx
    1d60:	8d 4a 30             	lea    0x30(%rdx),%ecx
    1d63:	88 4d a1             	mov    %cl,-0x5f(%rbp)
    name[2] = '0' + (nfiles % 1000) / 100;
    1d66:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    1d6c:	89 d9                	mov    %ebx,%ecx
    1d6e:	29 d1                	sub    %edx,%ecx
    1d70:	48 63 d1             	movslq %ecx,%rdx
    1d73:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    1d7a:	48 c1 fa 25          	sar    $0x25,%rdx
    1d7e:	c1 f9 1f             	sar    $0x1f,%ecx
    1d81:	29 ca                	sub    %ecx,%edx
    1d83:	83 c2 30             	add    $0x30,%edx
    1d86:	88 55 a2             	mov    %dl,-0x5e(%rbp)
    name[3] = '0' + (nfiles % 100) / 10;
    1d89:	48 69 d0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rdx
    1d90:	48 c1 fa 25          	sar    $0x25,%rdx
    1d94:	29 f2                	sub    %esi,%edx
    1d96:	6b ca 64             	imul   $0x64,%edx,%ecx
    1d99:	89 da                	mov    %ebx,%edx
    1d9b:	29 ca                	sub    %ecx,%edx
    1d9d:	48 63 ca             	movslq %edx,%rcx
    1da0:	48 69 c9 67 66 66 66 	imul   $0x66666667,%rcx,%rcx
    1da7:	48 c1 f9 22          	sar    $0x22,%rcx
    1dab:	c1 fa 1f             	sar    $0x1f,%edx
    1dae:	29 d1                	sub    %edx,%ecx
    1db0:	8d 51 30             	lea    0x30(%rcx),%edx
    1db3:	88 55 a3             	mov    %dl,-0x5d(%rbp)
    name[4] = '0' + (nfiles % 10);
    1db6:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    1dbd:	48 c1 f8 22          	sar    $0x22,%rax
    1dc1:	29 f0                	sub    %esi,%eax
    1dc3:	8d 14 80             	lea    (%rax,%rax,4),%edx
    1dc6:	d1 e2                	shl    $1,%edx
    1dc8:	89 d8                	mov    %ebx,%eax
    1dca:	29 d0                	sub    %edx,%eax
    1dcc:	83 c0 30             	add    $0x30,%eax
    1dcf:	88 45 a4             	mov    %al,-0x5c(%rbp)
    name[5] = '\0';
    1dd2:	c6 45 a5 00          	movb   $0x0,-0x5b(%rbp)
    unlink(name);
    1dd6:	48 8d 7d a0          	lea    -0x60(%rbp),%rdi
    1dda:	e8 07 04 00 00       	call   21e6 <unlink>
    nfiles--;
    1ddf:	83 eb 01             	sub    $0x1,%ebx
  while(nfiles >= 0){
    1de2:	85 db                	test   %ebx,%ebx
    1de4:	0f 89 5d ff ff ff    	jns    1d47 <fsfull+0x149>
  }

  printf(1, "fsfull test finished\n");
    1dea:	be c5 2e 00 00       	mov    $0x2ec5,%esi
    1def:	bf 01 00 00 00       	mov    $0x1,%edi
    1df4:	b0 00                	mov    $0x0,%al
    1df6:	e8 6a 05 00 00       	call   2365 <printf>
}
    1dfb:	48 83 c4 48          	add    $0x48,%rsp
    1dff:	5b                   	pop    %rbx
    1e00:	41 5c                	pop    %r12
    1e02:	41 5d                	pop    %r13
    1e04:	5d                   	pop    %rbp
    1e05:	c3                   	ret

0000000000001e06 <argptest>:

void argptest()
{
    1e06:	55                   	push   %rbp
    1e07:	48 89 e5             	mov    %rsp,%rbp
    1e0a:	53                   	push   %rbx
    1e0b:	48 83 ec 08          	sub    $0x8,%rsp
  int fd;
  fd = open("init", O_RDONLY);
    1e0f:	be 00 00 00 00       	mov    $0x0,%esi
    1e14:	bf db 2e 00 00       	mov    $0x2edb,%edi
    1e19:	e8 b4 03 00 00       	call   21d2 <open>
  if (fd < 0) {
    1e1e:	85 c0                	test   %eax,%eax
    1e20:	78 3b                	js     1e5d <argptest+0x57>
    1e22:	89 c3                	mov    %eax,%ebx
    printf(2, "open failed\n");
    exit();
  }
  read(fd, sbrk(0) - 1, -1);
    1e24:	bf 00 00 00 00       	mov    $0x0,%edi
    1e29:	e8 fe 03 00 00       	call   222c <sbrk>
    1e2e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
    1e32:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    1e37:	89 df                	mov    %ebx,%edi
    1e39:	e8 62 03 00 00       	call   21a0 <read>
  close(fd);
    1e3e:	89 df                	mov    %ebx,%edi
    1e40:	e8 6f 03 00 00       	call   21b4 <close>
  printf(1, "arg test passed\n");
    1e45:	be ed 2e 00 00       	mov    $0x2eed,%esi
    1e4a:	bf 01 00 00 00       	mov    $0x1,%edi
    1e4f:	b0 00                	mov    $0x0,%al
    1e51:	e8 0f 05 00 00       	call   2365 <printf>
}
    1e56:	48 83 c4 08          	add    $0x8,%rsp
    1e5a:	5b                   	pop    %rbx
    1e5b:	5d                   	pop    %rbp
    1e5c:	c3                   	ret
    printf(2, "open failed\n");
    1e5d:	be e0 2e 00 00       	mov    $0x2ee0,%esi
    1e62:	bf 02 00 00 00       	mov    $0x2,%edi
    1e67:	b0 00                	mov    $0x0,%al
    1e69:	e8 f7 04 00 00       	call   2365 <printf>
    exit();
    1e6e:	e8 0f 03 00 00       	call   2182 <exit>

0000000000001e73 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
    1e73:	48 69 05 62 1b 00 00 	imul   $0x19660d,0x1b62(%rip),%rax        # 39e0 <randstate>
    1e7a:	0d 66 19 00 
    1e7e:	48 05 5f f3 6e 3c    	add    $0x3c6ef35f,%rax
    1e84:	48 89 05 55 1b 00 00 	mov    %rax,0x1b55(%rip)        # 39e0 <randstate>
  return randstate;
}
    1e8b:	c3                   	ret

0000000000001e8c <main>:

int
main(int argc, char *argv[])
{
    1e8c:	55                   	push   %rbp
    1e8d:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "usertests 1 starting\n");
    1e90:	be fe 2e 00 00       	mov    $0x2efe,%esi
    1e95:	bf 01 00 00 00       	mov    $0x1,%edi
    1e9a:	b0 00                	mov    $0x0,%al
    1e9c:	e8 c4 04 00 00       	call   2365 <printf>

  if(open("usertests1.ran", 0) >= 0){
    1ea1:	be 00 00 00 00       	mov    $0x0,%esi
    1ea6:	bf 14 2f 00 00       	mov    $0x2f14,%edi
    1eab:	e8 22 03 00 00       	call   21d2 <open>
    1eb0:	85 c0                	test   %eax,%eax
    1eb2:	78 16                	js     1eca <main+0x3e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    1eb4:	be 00 33 00 00       	mov    $0x3300,%esi
    1eb9:	bf 01 00 00 00       	mov    $0x1,%edi
    1ebe:	b0 00                	mov    $0x0,%al
    1ec0:	e8 a0 04 00 00       	call   2365 <printf>
    exit();
    1ec5:	e8 b8 02 00 00       	call   2182 <exit>
  }
  close(open("usertests1.ran", O_CREATE));
    1eca:	be 00 02 00 00       	mov    $0x200,%esi
    1ecf:	bf 14 2f 00 00       	mov    $0x2f14,%edi
    1ed4:	e8 f9 02 00 00       	call   21d2 <open>
    1ed9:	89 c7                	mov    %eax,%edi
    1edb:	e8 d4 02 00 00       	call   21b4 <close>

  argptest();
    1ee0:	b0 00                	mov    $0x0,%al
    1ee2:	e8 1f ff ff ff       	call   1e06 <argptest>
  createdelete();
    1ee7:	e8 41 f0 ff ff       	call   f2d <createdelete>
  linkunlink();
    1eec:	b0 00                	mov    $0x0,%al
    1eee:	e8 1d f5 ff ff       	call   1410 <linkunlink>
  concreate();
    1ef3:	e8 2e f2 ff ff       	call   1126 <concreate>
  fourfiles();
    1ef8:	e8 49 ee ff ff       	call   d46 <fourfiles>
  sharedfd();
    1efd:	e8 9e ec ff ff       	call   ba0 <sharedfd>

  bigargtest();
    1f02:	e8 fe fb ff ff       	call   1b05 <bigargtest>
  bigwrite();
    1f07:	e8 fc f5 ff ff       	call   1508 <bigwrite>
  bigargtest();
    1f0c:	e8 f4 fb ff ff       	call   1b05 <bigargtest>
  bsstest();
    1f11:	e8 8f fb ff ff       	call   1aa5 <bsstest>
  sbrktest();
    1f16:	e8 c6 f6 ff ff       	call   15e1 <sbrktest>
  validatetest();
    1f1b:	e8 e4 fa ff ff       	call   1a04 <validatetest>

  opentest();
    1f20:	e8 78 e3 ff ff       	call   29d <opentest>
  writetest();
    1f25:	e8 f8 e3 ff ff       	call   322 <writetest>
  writetest1();
    1f2a:	e8 96 e5 ff ff       	call   4c5 <writetest1>
  createtest();
    1f2f:	e8 20 e7 ff ff       	call   654 <createtest>

  openiputtest();
    1f34:	e8 90 e2 ff ff       	call   1c9 <openiputtest>
  exitiputtest();
    1f39:	e8 c2 e1 ff ff       	call   100 <exitiputtest>
  iputtest();
    1f3e:	e8 ff e0 ff ff       	call   42 <iputtest>

  mem();
    1f43:	e8 9d eb ff ff       	call   ae5 <mem>
  pipe1();
    1f48:	e8 65 e8 ff ff       	call   7b2 <pipe1>
  preempt();
    1f4d:	e8 fb e9 ff ff       	call   94d <preempt>
  exitwait();
    1f52:	e8 1e eb ff ff       	call   a75 <exitwait>

  exectest();
    1f57:	e8 a4 e0 ff ff       	call   0 <exectest>

  exit();
    1f5c:	e8 21 02 00 00       	call   2182 <exit>
    1f61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    1f68:	00 00 00 
    1f6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    1f72:	00 00 00 
    1f75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    1f7c:	00 00 00 
    1f7f:	90                   	nop

0000000000001f80 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1f80:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1f83:	48 89 f9             	mov    %rdi,%rcx
    1f86:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1f8d:	00 00 00 00 
    1f91:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1f98:	00 00 00 00 
    1f9c:	0f 1f 40 00          	nopl   0x0(%rax)
    1fa0:	48 89 f2             	mov    %rsi,%rdx
    1fa3:	48 83 c6 01          	add    $0x1,%rsi
    1fa7:	49 89 c8             	mov    %rcx,%r8
    1faa:	48 83 c1 01          	add    $0x1,%rcx
    1fae:	8a 12                	mov    (%rdx),%dl
    1fb0:	41 88 10             	mov    %dl,(%r8)
    1fb3:	0f be d2             	movsbl %dl,%edx
    1fb6:	85 d2                	test   %edx,%edx
    1fb8:	75 e6                	jne    1fa0 <strcpy+0x20>
    ;
  return os;
}
    1fba:	c3                   	ret

0000000000001fbb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1fbb:	eb 0b                	jmp    1fc8 <strcmp+0xd>
    1fbd:	0f 1f 00             	nopl   (%rax)
    p++, q++;
    1fc0:	48 83 c7 01          	add    $0x1,%rdi
    1fc4:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
    1fc8:	8a 07                	mov    (%rdi),%al
    1fca:	0f be d0             	movsbl %al,%edx
    1fcd:	85 d2                	test   %edx,%edx
    1fcf:	74 07                	je     1fd8 <strcmp+0x1d>
    1fd1:	0f be 0e             	movsbl (%rsi),%ecx
    1fd4:	39 ca                	cmp    %ecx,%edx
    1fd6:	74 e8                	je     1fc0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    1fd8:	0f b6 c0             	movzbl %al,%eax
    1fdb:	0f b6 16             	movzbl (%rsi),%edx
    1fde:	29 d0                	sub    %edx,%eax
}
    1fe0:	c3                   	ret

0000000000001fe1 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    1fe1:	b8 00 00 00 00       	mov    $0x0,%eax
    1fe6:	eb 0b                	jmp    1ff3 <strlen+0x12>
    1fe8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    1fef:	00 
    1ff0:	83 c0 01             	add    $0x1,%eax
    1ff3:	48 63 d0             	movslq %eax,%rdx
    1ff6:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
    1ffa:	85 d2                	test   %edx,%edx
    1ffc:	75 f2                	jne    1ff0 <strlen+0xf>
    ;
  return n;
}
    1ffe:	c3                   	ret

0000000000001fff <memset>:

void*
memset(void *dst, int c, uint n)
{
    1fff:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
    2002:	89 d1                	mov    %edx,%ecx
    2004:	89 f0                	mov    %esi,%eax
    2006:	fc                   	cld
    2007:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
    2009:	4c 89 c0             	mov    %r8,%rax
    200c:	c3                   	ret

000000000000200d <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    200d:	eb 15                	jmp    2024 <strchr+0x17>
    200f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    2016:	00 00 00 00 
    201a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    2020:	48 83 c7 01          	add    $0x1,%rdi
    2024:	8a 17                	mov    (%rdi),%dl
    2026:	0f be c2             	movsbl %dl,%eax
    2029:	85 c0                	test   %eax,%eax
    202b:	74 0f                	je     203c <strchr+0x2f>
    if(*s == c)
    202d:	0f be d2             	movsbl %dl,%edx
    2030:	40 0f be c6          	movsbl %sil,%eax
    2034:	39 c2                	cmp    %eax,%edx
    2036:	75 e8                	jne    2020 <strchr+0x13>
      return (char*)s;
    2038:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
    203b:	c3                   	ret
  return 0;
    203c:	b8 00 00 00 00       	mov    $0x0,%eax
    2041:	c3                   	ret

0000000000002042 <gets>:

char*
gets(char *buf, int max)
{
    2042:	55                   	push   %rbp
    2043:	48 89 e5             	mov    %rsp,%rbp
    2046:	41 56                	push   %r14
    2048:	41 55                	push   %r13
    204a:	41 54                	push   %r12
    204c:	53                   	push   %rbx
    204d:	48 83 ec 10          	sub    $0x10,%rsp
    2051:	49 89 fc             	mov    %rdi,%r12
    2054:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    2057:	bb 00 00 00 00       	mov    $0x0,%ebx
    205c:	41 89 de             	mov    %ebx,%r14d
    205f:	83 c3 01             	add    $0x1,%ebx
    2062:	44 39 eb             	cmp    %r13d,%ebx
    2065:	7d 39                	jge    20a0 <gets+0x5e>
    cc = read(0, &c, 1);
    2067:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
    206b:	ba 01 00 00 00       	mov    $0x1,%edx
    2070:	bf 00 00 00 00       	mov    $0x0,%edi
    2075:	e8 26 01 00 00       	call   21a0 <read>
    if(cc < 1)
    207a:	85 c0                	test   %eax,%eax
    207c:	7e 22                	jle    20a0 <gets+0x5e>
      break;
    buf[i++] = c;
    207e:	4d 63 f6             	movslq %r14d,%r14
    2081:	8a 45 df             	mov    -0x21(%rbp),%al
    2084:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
    2088:	0f be c0             	movsbl %al,%eax
    208b:	83 f8 0a             	cmp    $0xa,%eax
    208e:	0f 94 c2             	sete   %dl
    2091:	83 f8 0d             	cmp    $0xd,%eax
    2094:	0f 94 c0             	sete   %al
    2097:	09 d0                	or     %edx,%eax
    2099:	a8 ff                	test   $0xff,%al
    209b:	74 bf                	je     205c <gets+0x1a>
    buf[i++] = c;
    209d:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
    20a0:	4d 63 f6             	movslq %r14d,%r14
    20a3:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
    20a8:	4c 89 e0             	mov    %r12,%rax
    20ab:	48 83 c4 10          	add    $0x10,%rsp
    20af:	5b                   	pop    %rbx
    20b0:	41 5c                	pop    %r12
    20b2:	41 5d                	pop    %r13
    20b4:	41 5e                	pop    %r14
    20b6:	5d                   	pop    %rbp
    20b7:	c3                   	ret

00000000000020b8 <stat>:

int
stat(const char *n, struct stat *st)
{
    20b8:	55                   	push   %rbp
    20b9:	48 89 e5             	mov    %rsp,%rbp
    20bc:	41 54                	push   %r12
    20be:	53                   	push   %rbx
    20bf:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    20c2:	be 00 00 00 00       	mov    $0x0,%esi
    20c7:	e8 06 01 00 00       	call   21d2 <open>
  if(fd < 0)
    20cc:	85 c0                	test   %eax,%eax
    20ce:	78 1e                	js     20ee <stat+0x36>
    20d0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    20d2:	4c 89 e6             	mov    %r12,%rsi
    20d5:	89 c7                	mov    %eax,%edi
    20d7:	e8 14 01 00 00       	call   21f0 <fstat>
    20dc:	41 89 c4             	mov    %eax,%r12d
  close(fd);
    20df:	89 df                	mov    %ebx,%edi
    20e1:	e8 ce 00 00 00       	call   21b4 <close>
  return r;
}
    20e6:	44 89 e0             	mov    %r12d,%eax
    20e9:	5b                   	pop    %rbx
    20ea:	41 5c                	pop    %r12
    20ec:	5d                   	pop    %rbp
    20ed:	c3                   	ret
    return -1;
    20ee:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
    20f4:	eb f0                	jmp    20e6 <stat+0x2e>

00000000000020f6 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
    20f6:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
    20fb:	eb 09                	jmp    2106 <atoi+0x10>
    20fd:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
    2100:	f7 de                	neg    %esi
    s++;
    2102:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
    2106:	0f be 07             	movsbl (%rdi),%eax
    2109:	83 f8 2d             	cmp    $0x2d,%eax
    210c:	74 f2                	je     2100 <atoi+0xa>
  n = 0;
    210e:	b8 00 00 00 00       	mov    $0x0,%eax
    2113:	eb 19                	jmp    212e <atoi+0x38>
    2115:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    211c:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
    2120:	8d 04 80             	lea    (%rax,%rax,4),%eax
    2123:	48 83 c7 01          	add    $0x1,%rdi
    2127:	0f be d2             	movsbl %dl,%edx
    212a:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
    212e:	8a 17                	mov    (%rdi),%dl
    2130:	8d 4a d0             	lea    -0x30(%rdx),%ecx
    2133:	0f b6 c9             	movzbl %cl,%ecx
    2136:	83 f9 09             	cmp    $0x9,%ecx
    2139:	76 e5                	jbe    2120 <atoi+0x2a>
  return sign * n;
    213b:	0f af c6             	imul   %esi,%eax
}
    213e:	c3                   	ret

000000000000213f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    213f:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
    2142:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
    2145:	eb 28                	jmp    216f <memmove+0x30>
    2147:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    214e:	00 00 00 00 
    2152:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    2159:	00 00 00 00 
    215d:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
    2160:	8a 16                	mov    (%rsi),%dl
    2162:	88 11                	mov    %dl,(%rcx)
    2164:	48 8d 76 01          	lea    0x1(%rsi),%rsi
    2168:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
    216c:	44 89 c2             	mov    %r8d,%edx
    216f:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
    2173:	85 d2                	test   %edx,%edx
    2175:	7f e9                	jg     2160 <memmove+0x21>
  return vdst;
}
    2177:	c3                   	ret

0000000000002178 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    2178:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    217f:	cd 40                	int    $0x40
    2181:	c3                   	ret

0000000000002182 <exit>:
SYSCALL(exit)
    2182:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    2189:	cd 40                	int    $0x40
    218b:	c3                   	ret

000000000000218c <wait>:
SYSCALL(wait)
    218c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    2193:	cd 40                	int    $0x40
    2195:	c3                   	ret

0000000000002196 <pipe>:
SYSCALL(pipe)
    2196:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    219d:	cd 40                	int    $0x40
    219f:	c3                   	ret

00000000000021a0 <read>:
SYSCALL(read)
    21a0:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    21a7:	cd 40                	int    $0x40
    21a9:	c3                   	ret

00000000000021aa <write>:
SYSCALL(write)
    21aa:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    21b1:	cd 40                	int    $0x40
    21b3:	c3                   	ret

00000000000021b4 <close>:
SYSCALL(close)
    21b4:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    21bb:	cd 40                	int    $0x40
    21bd:	c3                   	ret

00000000000021be <kill>:
SYSCALL(kill)
    21be:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    21c5:	cd 40                	int    $0x40
    21c7:	c3                   	ret

00000000000021c8 <exec>:
SYSCALL(exec)
    21c8:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    21cf:	cd 40                	int    $0x40
    21d1:	c3                   	ret

00000000000021d2 <open>:
SYSCALL(open)
    21d2:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    21d9:	cd 40                	int    $0x40
    21db:	c3                   	ret

00000000000021dc <mknod>:
SYSCALL(mknod)
    21dc:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    21e3:	cd 40                	int    $0x40
    21e5:	c3                   	ret

00000000000021e6 <unlink>:
SYSCALL(unlink)
    21e6:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    21ed:	cd 40                	int    $0x40
    21ef:	c3                   	ret

00000000000021f0 <fstat>:
SYSCALL(fstat)
    21f0:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    21f7:	cd 40                	int    $0x40
    21f9:	c3                   	ret

00000000000021fa <link>:
SYSCALL(link)
    21fa:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    2201:	cd 40                	int    $0x40
    2203:	c3                   	ret

0000000000002204 <mkdir>:
SYSCALL(mkdir)
    2204:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    220b:	cd 40                	int    $0x40
    220d:	c3                   	ret

000000000000220e <chdir>:
SYSCALL(chdir)
    220e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    2215:	cd 40                	int    $0x40
    2217:	c3                   	ret

0000000000002218 <dup>:
SYSCALL(dup)
    2218:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    221f:	cd 40                	int    $0x40
    2221:	c3                   	ret

0000000000002222 <getpid>:
SYSCALL(getpid)
    2222:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    2229:	cd 40                	int    $0x40
    222b:	c3                   	ret

000000000000222c <sbrk>:
SYSCALL(sbrk)
    222c:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    2233:	cd 40                	int    $0x40
    2235:	c3                   	ret

0000000000002236 <sleep>:
SYSCALL(sleep)
    2236:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    223d:	cd 40                	int    $0x40
    223f:	c3                   	ret

0000000000002240 <uptime>:
SYSCALL(uptime)
    2240:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    2247:	cd 40                	int    $0x40
    2249:	c3                   	ret

000000000000224a <vmcreate>:
SYSCALL(vmcreate)
    224a:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    2251:	cd 40                	int    $0x40
    2253:	c3                   	ret

0000000000002254 <vmsetreg>:
SYSCALL(vmsetreg)
    2254:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    225b:	cd 40                	int    $0x40
    225d:	c3                   	ret

000000000000225e <vmrun>:
SYSCALL(vmrun)
    225e:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    2265:	cd 40                	int    $0x40
    2267:	c3                   	ret

0000000000002268 <vmgetreg>:
SYSCALL(vmgetreg)
    2268:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    226f:	cd 40                	int    $0x40
    2271:	c3                   	ret
    2272:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    2279:	00 00 00 
    227c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000002280 <_va_arg>:
// Retrieve the next argument from the va_list.
static inline void *_va_arg(va_list *args)
{
    // Returns the next argument from registers if _index < 6, 
    // otherwise from the stack.
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
    2280:	8b 47 38             	mov    0x38(%rdi),%eax
    2283:	83 f8 05             	cmp    $0x5,%eax
    2286:	77 0d                	ja     2295 <_va_arg+0x15>
    2288:	8d 50 01             	lea    0x1(%rax),%edx
    228b:	89 57 38             	mov    %edx,0x38(%rdi)
    228e:	89 c0                	mov    %eax,%eax
    2290:	48 8b 04 c7          	mov    (%rdi,%rax,8),%rax
    2294:	c3                   	ret
                                  : args->more_argint[(args->_index++)-6]);
    2295:	8d 50 01             	lea    0x1(%rax),%edx
    2298:	89 57 38             	mov    %edx,0x38(%rdi)
    229b:	8d 40 fa             	lea    -0x6(%rax),%eax
    229e:	48 c1 e0 03          	shl    $0x3,%rax
    22a2:	48 03 47 30          	add    0x30(%rdi),%rax
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
    22a6:	48 8b 00             	mov    (%rax),%rax
}
    22a9:	c3                   	ret

00000000000022aa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    22aa:	55                   	push   %rbp
    22ab:	48 89 e5             	mov    %rsp,%rbp
    22ae:	48 83 ec 10          	sub    $0x10,%rsp
    22b2:	40 88 75 fc          	mov    %sil,-0x4(%rbp)
  write(fd, &c, 1);
    22b6:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
    22ba:	ba 01 00 00 00       	mov    $0x1,%edx
    22bf:	e8 e6 fe ff ff       	call   21aa <write>
}
    22c4:	48 89 ec             	mov    %rbp,%rsp
    22c7:	5d                   	pop    %rbp
    22c8:	c3                   	ret

00000000000022c9 <printint>:

static void
printint(int fd, int64 xx, int base, int sgn)
{
    22c9:	55                   	push   %rbp
    22ca:	48 89 e5             	mov    %rsp,%rbp
    22cd:	41 54                	push   %r12
    22cf:	53                   	push   %rbx
    22d0:	48 83 ec 10          	sub    $0x10,%rsp
    22d4:	41 89 fc             	mov    %edi,%r12d
    22d7:	41 89 d1             	mov    %edx,%r9d
  char buf[16];
  int i, neg;
  uint64 x;

  neg = 0;
  if(sgn && xx < 0){
    22da:	85 c9                	test   %ecx,%ecx
    22dc:	0f 95 c2             	setne  %dl
    22df:	48 89 f0             	mov    %rsi,%rax
    22e2:	48 c1 e8 3f          	shr    $0x3f,%rax
    22e6:	85 c2                	test   %eax,%edx
    22e8:	74 55                	je     233f <printint+0x76>
    neg = 1;
    x = -xx;
    22ea:	48 f7 de             	neg    %rsi
    neg = 1;
    22ed:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  } else {
    x = xx;
  }

  i = 0;
    22f3:	bb 00 00 00 00       	mov    $0x0,%ebx
    22f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    22ff:	00 
  do{
    buf[i++] = digits[x % base];
    2300:	49 63 c9             	movslq %r9d,%rcx
    2303:	48 89 f0             	mov    %rsi,%rax
    2306:	ba 00 00 00 00       	mov    $0x0,%edx
    230b:	48 f7 f1             	div    %rcx
    230e:	89 df                	mov    %ebx,%edi
    2310:	83 c3 01             	add    $0x1,%ebx
    2313:	44 8a 82 e0 33 00 00 	mov    0x33e0(%rdx),%r8b
    231a:	48 63 d7             	movslq %edi,%rdx
    231d:	44 88 44 15 e0       	mov    %r8b,-0x20(%rbp,%rdx,1)
  }while((x /= base) != 0);
    2322:	48 89 f2             	mov    %rsi,%rdx
    2325:	48 89 c6             	mov    %rax,%rsi
    2328:	48 39 ca             	cmp    %rcx,%rdx
    232b:	73 d3                	jae    2300 <printint+0x37>
  if(neg)
    232d:	45 85 d2             	test   %r10d,%r10d
    2330:	74 25                	je     2357 <printint+0x8e>
    buf[i++] = '-';
    2332:	48 63 db             	movslq %ebx,%rbx
    2335:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
    233a:	8d 5f 02             	lea    0x2(%rdi),%ebx
    233d:	eb 18                	jmp    2357 <printint+0x8e>
  neg = 0;
    233f:	41 ba 00 00 00 00    	mov    $0x0,%r10d
    2345:	eb ac                	jmp    22f3 <printint+0x2a>

  while(--i >= 0)
    putc(fd, buf[i]);
    2347:	48 63 c3             	movslq %ebx,%rax
    234a:	0f be 74 05 e0       	movsbl -0x20(%rbp,%rax,1),%esi
    234f:	44 89 e7             	mov    %r12d,%edi
    2352:	e8 53 ff ff ff       	call   22aa <putc>
  while(--i >= 0)
    2357:	83 eb 01             	sub    $0x1,%ebx
    235a:	79 eb                	jns    2347 <printint+0x7e>
}
    235c:	48 83 c4 10          	add    $0x10,%rsp
    2360:	5b                   	pop    %rbx
    2361:	41 5c                	pop    %r12
    2363:	5d                   	pop    %rbp
    2364:	c3                   	ret

0000000000002365 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    2365:	55                   	push   %rbp
    2366:	48 89 e5             	mov    %rsp,%rbp
    2369:	41 57                	push   %r15
    236b:	41 56                	push   %r14
    236d:	41 55                	push   %r13
    236f:	41 54                	push   %r12
    2371:	53                   	push   %rbx
    2372:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
    2379:	41 89 ff             	mov    %edi,%r15d
    237c:	49 89 f5             	mov    %rsi,%r13
    237f:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
    2386:	48 89 8d 38 ff ff ff 	mov    %rcx,-0xc8(%rbp)
    238d:	4c 89 85 40 ff ff ff 	mov    %r8,-0xc0(%rbp)
    2394:	4c 89 8d 48 ff ff ff 	mov    %r9,-0xb8(%rbp)
    239b:	84 c0                	test   %al,%al
    239d:	74 29                	je     23c8 <printf+0x63>
    239f:	0f 29 85 50 ff ff ff 	movaps %xmm0,-0xb0(%rbp)
    23a6:	0f 29 8d 60 ff ff ff 	movaps %xmm1,-0xa0(%rbp)
    23ad:	0f 29 95 70 ff ff ff 	movaps %xmm2,-0x90(%rbp)
    23b4:	0f 29 5d 80          	movaps %xmm3,-0x80(%rbp)
    23b8:	0f 29 65 90          	movaps %xmm4,-0x70(%rbp)
    23bc:	0f 29 6d a0          	movaps %xmm5,-0x60(%rbp)
    23c0:	0f 29 75 b0          	movaps %xmm6,-0x50(%rbp)
    23c4:	0f 29 7d c0          	movaps %xmm7,-0x40(%rbp)
    asm volatile("movq %%rdi, %0;" 
    23c8:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
    23cf:	48 89 b5 e8 fe ff ff 	mov    %rsi,-0x118(%rbp)
    23d6:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
    23dd:	48 89 8d f8 fe ff ff 	mov    %rcx,-0x108(%rbp)
    23e4:	4c 89 85 00 ff ff ff 	mov    %r8,-0x100(%rbp)
    23eb:	4c 89 8d 08 ff ff ff 	mov    %r9,-0xf8(%rbp)
    asm volatile("leaq 16(%%rbp), %0" : "=r" (args->more_argint));
    23f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
    23f6:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
    args->_index = 1;
    23fd:	c7 85 18 ff ff ff 01 	movl   $0x1,-0xe8(%rbp)
    2404:	00 00 00 
  char *s;
  int c, i, state;
  va_list ap;

  va_start(ap, fd);
  (void) va_arg(ap, char*); // skip fmt
    2407:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    240e:	e8 6d fe ff ff       	call   2280 <_va_arg>

  state = 0;
    2413:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(i = 0; fmt[i]; i++){
    2419:	bb 00 00 00 00       	mov    $0x0,%ebx
    241e:	eb 16                	jmp    2436 <printf+0xd1>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    2420:	44 89 f6             	mov    %r14d,%esi
    2423:	44 89 ff             	mov    %r15d,%edi
    2426:	e8 7f fe ff ff       	call   22aa <putc>
    242b:	eb 06                	jmp    2433 <printf+0xce>
      }
    } else if(state == '%'){
    242d:	41 83 fc 25          	cmp    $0x25,%r12d
    2431:	74 2c                	je     245f <printf+0xfa>
  for(i = 0; fmt[i]; i++){
    2433:	83 c3 01             	add    $0x1,%ebx
    2436:	48 63 c3             	movslq %ebx,%rax
    2439:	41 8a 44 05 00       	mov    0x0(%r13,%rax,1),%al
    243e:	0f be d0             	movsbl %al,%edx
    2441:	85 d2                	test   %edx,%edx
    2443:	0f 84 42 01 00 00    	je     258b <printf+0x226>
    c = fmt[i] & 0xff;
    2449:	44 0f be f0          	movsbl %al,%r14d
    244d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
    2450:	45 85 e4             	test   %r12d,%r12d
    2453:	75 d8                	jne    242d <printf+0xc8>
      if(c == '%'){
    2455:	83 f8 25             	cmp    $0x25,%eax
    2458:	75 c6                	jne    2420 <printf+0xbb>
        state = '%';
    245a:	41 89 c4             	mov    %eax,%r12d
    245d:	eb d4                	jmp    2433 <printf+0xce>
      if(c == 'd'){
    245f:	83 f8 25             	cmp    $0x25,%eax
    2462:	0f 84 ea 00 00 00    	je     2552 <printf+0x1ed>
    2468:	0f 8c fa 00 00 00    	jl     2568 <printf+0x203>
    246e:	83 f8 78             	cmp    $0x78,%eax
    2471:	0f 8f f1 00 00 00    	jg     2568 <printf+0x203>
    2477:	83 f8 63             	cmp    $0x63,%eax
    247a:	0f 8c e8 00 00 00    	jl     2568 <printf+0x203>
    2480:	83 e8 63             	sub    $0x63,%eax
    2483:	83 f8 15             	cmp    $0x15,%eax
    2486:	0f 87 dc 00 00 00    	ja     2568 <printf+0x203>
    248c:	89 c0                	mov    %eax,%eax
    248e:	ff 24 c5 30 33 00 00 	jmp    *0x3330(,%rax,8)
        printint(fd, va_arg(ap, int), 10, 1);
    2495:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    249c:	e8 df fd ff ff       	call   2280 <_va_arg>
    24a1:	48 63 f0             	movslq %eax,%rsi
    24a4:	b9 01 00 00 00       	mov    $0x1,%ecx
    24a9:	ba 0a 00 00 00       	mov    $0xa,%edx
    24ae:	44 89 ff             	mov    %r15d,%edi
    24b1:	e8 13 fe ff ff       	call   22c9 <printint>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    24b6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    24bc:	e9 72 ff ff ff       	jmp    2433 <printf+0xce>
        printint(fd, va_arg(ap, uint64), 16, 0);
    24c1:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    24c8:	e8 b3 fd ff ff       	call   2280 <_va_arg>
    24cd:	48 89 c6             	mov    %rax,%rsi
    24d0:	b9 00 00 00 00       	mov    $0x0,%ecx
    24d5:	ba 10 00 00 00       	mov    $0x10,%edx
    24da:	44 89 ff             	mov    %r15d,%edi
    24dd:	e8 e7 fd ff ff       	call   22c9 <printint>
      state = 0;
    24e2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    24e8:	e9 46 ff ff ff       	jmp    2433 <printf+0xce>
        s = va_arg(ap, char*);
    24ed:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    24f4:	e8 87 fd ff ff       	call   2280 <_va_arg>
    24f9:	49 89 c4             	mov    %rax,%r12
        if(s == 0)
    24fc:	48 85 c0             	test   %rax,%rax
    24ff:	75 18                	jne    2519 <printf+0x1b4>
          s = "(null)";
    2501:	41 bc 34 2f 00 00    	mov    $0x2f34,%r12d
    2507:	eb 10                	jmp    2519 <printf+0x1b4>
          putc(fd, *s);
    2509:	40 0f be f6          	movsbl %sil,%esi
    250d:	44 89 ff             	mov    %r15d,%edi
    2510:	e8 95 fd ff ff       	call   22aa <putc>
          s++;
    2515:	49 83 c4 01          	add    $0x1,%r12
        while(*s != 0){
    2519:	41 8a 34 24          	mov    (%r12),%sil
    251d:	40 0f be c6          	movsbl %sil,%eax
    2521:	85 c0                	test   %eax,%eax
    2523:	75 e4                	jne    2509 <printf+0x1a4>
      state = 0;
    2525:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    252b:	e9 03 ff ff ff       	jmp    2433 <printf+0xce>
        putc(fd, va_arg(ap, char));
    2530:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    2537:	e8 44 fd ff ff       	call   2280 <_va_arg>
    253c:	0f be f0             	movsbl %al,%esi
    253f:	44 89 ff             	mov    %r15d,%edi
    2542:	e8 63 fd ff ff       	call   22aa <putc>
      state = 0;
    2547:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    254d:	e9 e1 fe ff ff       	jmp    2433 <printf+0xce>
        putc(fd, c);
    2552:	44 89 f6             	mov    %r14d,%esi
    2555:	44 89 ff             	mov    %r15d,%edi
    2558:	e8 4d fd ff ff       	call   22aa <putc>
      state = 0;
    255d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    2563:	e9 cb fe ff ff       	jmp    2433 <printf+0xce>
        putc(fd, '%');
    2568:	be 25 00 00 00       	mov    $0x25,%esi
    256d:	44 89 ff             	mov    %r15d,%edi
    2570:	e8 35 fd ff ff       	call   22aa <putc>
        putc(fd, c);
    2575:	44 89 f6             	mov    %r14d,%esi
    2578:	44 89 ff             	mov    %r15d,%edi
    257b:	e8 2a fd ff ff       	call   22aa <putc>
      state = 0;
    2580:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    2586:	e9 a8 fe ff ff       	jmp    2433 <printf+0xce>
    }
  }
}
    258b:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
    2592:	5b                   	pop    %rbx
    2593:	41 5c                	pop    %r12
    2595:	41 5d                	pop    %r13
    2597:	41 5e                	pop    %r14
    2599:	41 5f                	pop    %r15
    259b:	5d                   	pop    %rbp
    259c:	c3                   	ret
    259d:	0f 1f 00             	nopl   (%rax)

00000000000025a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    25a0:	48 89 fe             	mov    %rdi,%rsi
  Header *bp, *p;

  bp = (Header*)ap - 1;
    25a3:	48 8d 4f f0          	lea    -0x10(%rdi),%rcx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    25a7:	48 8b 05 b2 5c 00 00 	mov    0x5cb2(%rip),%rax        # 8260 <freep>
    25ae:	eb 03                	jmp    25b3 <free+0x13>
    25b0:	48 89 d0             	mov    %rdx,%rax
    25b3:	48 39 c8             	cmp    %rcx,%rax
    25b6:	73 05                	jae    25bd <free+0x1d>
    25b8:	48 3b 08             	cmp    (%rax),%rcx
    25bb:	72 17                	jb     25d4 <free+0x34>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    25bd:	48 8b 10             	mov    (%rax),%rdx
    25c0:	48 39 d0             	cmp    %rdx,%rax
    25c3:	72 eb                	jb     25b0 <free+0x10>
    25c5:	48 39 c8             	cmp    %rcx,%rax
    25c8:	72 0a                	jb     25d4 <free+0x34>
    25ca:	48 39 d1             	cmp    %rdx,%rcx
    25cd:	72 05                	jb     25d4 <free+0x34>
    25cf:	48 89 d0             	mov    %rdx,%rax
    25d2:	eb df                	jmp    25b3 <free+0x13>
      break;
  if(bp + bp->s.size == p->s.ptr){
    25d4:	44 8b 46 f8          	mov    -0x8(%rsi),%r8d
    25d8:	44 89 c2             	mov    %r8d,%edx
    25db:	48 c1 e2 04          	shl    $0x4,%rdx
    25df:	48 01 ca             	add    %rcx,%rdx
    25e2:	48 8b 38             	mov    (%rax),%rdi
    25e5:	48 39 fa             	cmp    %rdi,%rdx
    25e8:	74 20                	je     260a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    25ea:	48 89 7e f0          	mov    %rdi,-0x10(%rsi)
  if(p + p->s.size == bp){
    25ee:	8b 78 08             	mov    0x8(%rax),%edi
    25f1:	89 fa                	mov    %edi,%edx
    25f3:	48 c1 e2 04          	shl    $0x4,%rdx
    25f7:	48 01 c2             	add    %rax,%rdx
    25fa:	48 39 ca             	cmp    %rcx,%rdx
    25fd:	74 1f                	je     261e <free+0x7e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    25ff:	48 89 08             	mov    %rcx,(%rax)
  freep = p;
    2602:	48 89 05 57 5c 00 00 	mov    %rax,0x5c57(%rip)        # 8260 <freep>
}
    2609:	c3                   	ret
    bp->s.size += p->s.ptr->s.size;
    260a:	44 03 47 08          	add    0x8(%rdi),%r8d
    260e:	44 89 46 f8          	mov    %r8d,-0x8(%rsi)
    bp->s.ptr = p->s.ptr->s.ptr;
    2612:	48 8b 10             	mov    (%rax),%rdx
    2615:	48 8b 12             	mov    (%rdx),%rdx
    2618:	48 89 56 f0          	mov    %rdx,-0x10(%rsi)
    261c:	eb d0                	jmp    25ee <free+0x4e>
    p->s.size += bp->s.size;
    261e:	03 7e f8             	add    -0x8(%rsi),%edi
    2621:	89 78 08             	mov    %edi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    2624:	48 8b 56 f0          	mov    -0x10(%rsi),%rdx
    2628:	48 89 10             	mov    %rdx,(%rax)
    262b:	eb d5                	jmp    2602 <free+0x62>

000000000000262d <morecore>:

static Header*
morecore(uint nu)
{
    262d:	55                   	push   %rbp
    262e:	48 89 e5             	mov    %rsp,%rbp
    2631:	53                   	push   %rbx
    2632:	48 83 ec 08          	sub    $0x8,%rsp
    2636:	89 fb                	mov    %edi,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    2638:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
    263e:	77 05                	ja     2645 <morecore+0x18>
    nu = 4096;
    2640:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    2645:	89 df                	mov    %ebx,%edi
    2647:	c1 e7 04             	shl    $0x4,%edi
    264a:	e8 dd fb ff ff       	call   222c <sbrk>
  if(p == (char*)-1)
    264f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
    2653:	74 1a                	je     266f <morecore+0x42>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    2655:	89 58 08             	mov    %ebx,0x8(%rax)
  free((void*)(hp + 1));
    2658:	48 8d 78 10          	lea    0x10(%rax),%rdi
    265c:	e8 3f ff ff ff       	call   25a0 <free>
  return freep;
    2661:	48 8b 05 f8 5b 00 00 	mov    0x5bf8(%rip),%rax        # 8260 <freep>
}
    2668:	48 83 c4 08          	add    $0x8,%rsp
    266c:	5b                   	pop    %rbx
    266d:	5d                   	pop    %rbp
    266e:	c3                   	ret
    return 0;
    266f:	b8 00 00 00 00       	mov    $0x0,%eax
    2674:	eb f2                	jmp    2668 <morecore+0x3b>

0000000000002676 <malloc>:

void*
malloc(uint nbytes)
{
    2676:	55                   	push   %rbp
    2677:	48 89 e5             	mov    %rsp,%rbp
    267a:	53                   	push   %rbx
    267b:	48 83 ec 08          	sub    $0x8,%rsp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    267f:	89 fb                	mov    %edi,%ebx
    2681:	48 83 c3 0f          	add    $0xf,%rbx
    2685:	48 c1 eb 04          	shr    $0x4,%rbx
    2689:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    268c:	48 8b 0d cd 5b 00 00 	mov    0x5bcd(%rip),%rcx        # 8260 <freep>
    2693:	48 85 c9             	test   %rcx,%rcx
    2696:	74 05                	je     269d <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2698:	48 8b 01             	mov    (%rcx),%rax
    269b:	eb 69                	jmp    2706 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
    269d:	48 c7 05 b8 5b 00 00 	movq   $0x8270,0x5bb8(%rip)        # 8260 <freep>
    26a4:	70 82 00 00 
    26a8:	48 c7 05 bd 5b 00 00 	movq   $0x8270,0x5bbd(%rip)        # 8270 <base>
    26af:	70 82 00 00 
    base.s.size = 0;
    26b3:	c7 05 bb 5b 00 00 00 	movl   $0x0,0x5bbb(%rip)        # 8278 <base+0x8>
    26ba:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    26bd:	b9 70 82 00 00       	mov    $0x8270,%ecx
    26c2:	eb d4                	jmp    2698 <malloc+0x22>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    26c4:	74 23                	je     26e9 <malloc+0x73>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    26c6:	29 da                	sub    %ebx,%edx
    26c8:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    26cb:	89 d2                	mov    %edx,%edx
    26cd:	48 c1 e2 04          	shl    $0x4,%rdx
    26d1:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
    26d4:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
    26d7:	48 89 0d 82 5b 00 00 	mov    %rcx,0x5b82(%rip)        # 8260 <freep>
      return (void*)(p + 1);
    26de:	48 83 c0 10          	add    $0x10,%rax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    26e2:	48 83 c4 08          	add    $0x8,%rsp
    26e6:	5b                   	pop    %rbx
    26e7:	5d                   	pop    %rbp
    26e8:	c3                   	ret
        prevp->s.ptr = p->s.ptr;
    26e9:	48 8b 10             	mov    (%rax),%rdx
    26ec:	48 89 11             	mov    %rdx,(%rcx)
    26ef:	eb e6                	jmp    26d7 <malloc+0x61>
    26f1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    26f8:	00 00 00 00 
    26fc:	0f 1f 40 00          	nopl   0x0(%rax)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2700:	48 89 c1             	mov    %rax,%rcx
    2703:	48 8b 00             	mov    (%rax),%rax
    if(p->s.size >= nunits){
    2706:	8b 50 08             	mov    0x8(%rax),%edx
    2709:	39 da                	cmp    %ebx,%edx
    270b:	73 b7                	jae    26c4 <malloc+0x4e>
    if(p == freep)
    270d:	48 39 05 4c 5b 00 00 	cmp    %rax,0x5b4c(%rip)        # 8260 <freep>
    2714:	75 ea                	jne    2700 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
    2716:	89 df                	mov    %ebx,%edi
    2718:	e8 10 ff ff ff       	call   262d <morecore>
    271d:	48 85 c0             	test   %rax,%rax
    2720:	75 de                	jne    2700 <malloc+0x8a>
    2722:	eb be                	jmp    26e2 <malloc+0x6c>
