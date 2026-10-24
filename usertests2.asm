
_usertests2:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <dirtest>:


// simple file system tests

void dirtest(void)
{
       0:	55                   	push   %rbp
       1:	48 89 e5             	mov    %rsp,%rbp
  printf(stdout, "mkdir test\n");
       4:	be 30 1f 00 00       	mov    $0x1f30,%esi
       9:	8b 3d b9 31 00 00    	mov    0x31b9(%rip),%edi        # 31c8 <stdout>
       f:	b0 00                	mov    $0x0,%al
      11:	e8 4f 1b 00 00       	call   1b65 <printf>

  if(mkdir("dir0") < 0){
      16:	bf 3c 1f 00 00       	mov    $0x1f3c,%edi
      1b:	e8 e4 19 00 00       	call   1a04 <mkdir>
      20:	85 c0                	test   %eax,%eax
      22:	78 3e                	js     62 <dirtest+0x62>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
      24:	bf 3c 1f 00 00       	mov    $0x1f3c,%edi
      29:	e8 e0 19 00 00       	call   1a0e <chdir>
      2e:	85 c0                	test   %eax,%eax
      30:	78 47                	js     79 <dirtest+0x79>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
      32:	bf ba 22 00 00       	mov    $0x22ba,%edi
      37:	e8 d2 19 00 00       	call   1a0e <chdir>
      3c:	85 c0                	test   %eax,%eax
      3e:	78 50                	js     90 <dirtest+0x90>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
      40:	bf 3c 1f 00 00       	mov    $0x1f3c,%edi
      45:	e8 9c 19 00 00       	call   19e6 <unlink>
      4a:	85 c0                	test   %eax,%eax
      4c:	78 59                	js     a7 <dirtest+0xa7>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
      4e:	be 87 1f 00 00       	mov    $0x1f87,%esi
      53:	8b 3d 6f 31 00 00    	mov    0x316f(%rip),%edi        # 31c8 <stdout>
      59:	b0 00                	mov    $0x0,%al
      5b:	e8 05 1b 00 00       	call   1b65 <printf>
}
      60:	5d                   	pop    %rbp
      61:	c3                   	ret
    printf(stdout, "mkdir failed\n");
      62:	be 41 1f 00 00       	mov    $0x1f41,%esi
      67:	8b 3d 5b 31 00 00    	mov    0x315b(%rip),%edi        # 31c8 <stdout>
      6d:	b0 00                	mov    $0x0,%al
      6f:	e8 f1 1a 00 00       	call   1b65 <printf>
    exit();
      74:	e8 09 19 00 00       	call   1982 <exit>
    printf(stdout, "chdir dir0 failed\n");
      79:	be 4f 1f 00 00       	mov    $0x1f4f,%esi
      7e:	8b 3d 44 31 00 00    	mov    0x3144(%rip),%edi        # 31c8 <stdout>
      84:	b0 00                	mov    $0x0,%al
      86:	e8 da 1a 00 00       	call   1b65 <printf>
    exit();
      8b:	e8 f2 18 00 00       	call   1982 <exit>
    printf(stdout, "chdir .. failed\n");
      90:	be 62 1f 00 00       	mov    $0x1f62,%esi
      95:	8b 3d 2d 31 00 00    	mov    0x312d(%rip),%edi        # 31c8 <stdout>
      9b:	b0 00                	mov    $0x0,%al
      9d:	e8 c3 1a 00 00       	call   1b65 <printf>
    exit();
      a2:	e8 db 18 00 00       	call   1982 <exit>
    printf(stdout, "unlink dir0 failed\n");
      a7:	be 73 1f 00 00       	mov    $0x1f73,%esi
      ac:	8b 3d 16 31 00 00    	mov    0x3116(%rip),%edi        # 31c8 <stdout>
      b2:	b0 00                	mov    $0x0,%al
      b4:	e8 ac 1a 00 00       	call   1b65 <printf>
    exit();
      b9:	e8 c4 18 00 00       	call   1982 <exit>

00000000000000be <exectest>:

void
exectest(void)
{
      be:	55                   	push   %rbp
      bf:	48 89 e5             	mov    %rsp,%rbp
  printf(stdout, "exec test\n");
      c2:	be 96 1f 00 00       	mov    $0x1f96,%esi
      c7:	8b 3d fb 30 00 00    	mov    0x30fb(%rip),%edi        # 31c8 <stdout>
      cd:	b0 00                	mov    $0x0,%al
      cf:	e8 91 1a 00 00       	call   1b65 <printf>
  if(exec("echo", echoargv) < 0){
      d4:	be e0 31 00 00       	mov    $0x31e0,%esi
      d9:	bf a1 1f 00 00       	mov    $0x1fa1,%edi
      de:	e8 e5 18 00 00       	call   19c8 <exec>
      e3:	85 c0                	test   %eax,%eax
      e5:	78 02                	js     e9 <exectest+0x2b>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
      e7:	5d                   	pop    %rbp
      e8:	c3                   	ret
    printf(stdout, "exec echo failed\n");
      e9:	be a6 1f 00 00       	mov    $0x1fa6,%esi
      ee:	8b 3d d4 30 00 00    	mov    0x30d4(%rip),%edi        # 31c8 <stdout>
      f4:	b0 00                	mov    $0x0,%al
      f6:	e8 6a 1a 00 00       	call   1b65 <printf>
    exit();
      fb:	e8 82 18 00 00       	call   1982 <exit>

0000000000000100 <unlinkread>:
// More file system tests

// can I unlink a file and still read it?
void
unlinkread(void)
{
     100:	55                   	push   %rbp
     101:	48 89 e5             	mov    %rsp,%rbp
     104:	41 54                	push   %r12
     106:	53                   	push   %rbx
  int fd, fd1;

  printf(1, "unlinkread test\n");
     107:	be b8 1f 00 00       	mov    $0x1fb8,%esi
     10c:	bf 01 00 00 00       	mov    $0x1,%edi
     111:	b0 00                	mov    $0x0,%al
     113:	e8 4d 1a 00 00       	call   1b65 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
     118:	be 02 02 00 00       	mov    $0x202,%esi
     11d:	bf c9 1f 00 00       	mov    $0x1fc9,%edi
     122:	e8 ab 18 00 00       	call   19d2 <open>
  if(fd < 0){
     127:	85 c0                	test   %eax,%eax
     129:	0f 88 db 00 00 00    	js     20a <unlinkread+0x10a>
     12f:	89 c3                	mov    %eax,%ebx
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
     131:	ba 05 00 00 00       	mov    $0x5,%edx
     136:	be ee 1f 00 00       	mov    $0x1fee,%esi
     13b:	89 c7                	mov    %eax,%edi
     13d:	e8 68 18 00 00       	call   19aa <write>
  close(fd);
     142:	89 df                	mov    %ebx,%edi
     144:	e8 6b 18 00 00       	call   19b4 <close>

  fd = open("unlinkread", O_RDWR);
     149:	be 02 00 00 00       	mov    $0x2,%esi
     14e:	bf c9 1f 00 00       	mov    $0x1fc9,%edi
     153:	e8 7a 18 00 00       	call   19d2 <open>
     158:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     15a:	85 c0                	test   %eax,%eax
     15c:	0f 88 be 00 00 00    	js     220 <unlinkread+0x120>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
     162:	bf c9 1f 00 00       	mov    $0x1fc9,%edi
     167:	e8 7a 18 00 00       	call   19e6 <unlink>
     16c:	85 c0                	test   %eax,%eax
     16e:	0f 85 c2 00 00 00    	jne    236 <unlinkread+0x136>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     174:	be 02 02 00 00       	mov    $0x202,%esi
     179:	bf c9 1f 00 00       	mov    $0x1fc9,%edi
     17e:	e8 4f 18 00 00       	call   19d2 <open>
     183:	41 89 c4             	mov    %eax,%r12d
  write(fd1, "yyy", 3);
     186:	ba 03 00 00 00       	mov    $0x3,%edx
     18b:	be 26 20 00 00       	mov    $0x2026,%esi
     190:	89 c7                	mov    %eax,%edi
     192:	e8 13 18 00 00       	call   19aa <write>
  close(fd1);
     197:	44 89 e7             	mov    %r12d,%edi
     19a:	e8 15 18 00 00       	call   19b4 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
     19f:	ba 00 20 00 00       	mov    $0x2000,%edx
     1a4:	be 40 32 00 00       	mov    $0x3240,%esi
     1a9:	89 df                	mov    %ebx,%edi
     1ab:	e8 f0 17 00 00       	call   19a0 <read>
     1b0:	83 f8 05             	cmp    $0x5,%eax
     1b3:	0f 85 93 00 00 00    	jne    24c <unlinkread+0x14c>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
     1b9:	0f be 05 80 30 00 00 	movsbl 0x3080(%rip),%eax        # 3240 <buf>
     1c0:	83 f8 68             	cmp    $0x68,%eax
     1c3:	0f 85 99 00 00 00    	jne    262 <unlinkread+0x162>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
     1c9:	ba 0a 00 00 00       	mov    $0xa,%edx
     1ce:	be 40 32 00 00       	mov    $0x3240,%esi
     1d3:	89 df                	mov    %ebx,%edi
     1d5:	e8 d0 17 00 00       	call   19aa <write>
     1da:	83 f8 0a             	cmp    $0xa,%eax
     1dd:	0f 85 95 00 00 00    	jne    278 <unlinkread+0x178>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
     1e3:	89 df                	mov    %ebx,%edi
     1e5:	e8 ca 17 00 00       	call   19b4 <close>
  unlink("unlinkread");
     1ea:	bf c9 1f 00 00       	mov    $0x1fc9,%edi
     1ef:	e8 f2 17 00 00       	call   19e6 <unlink>
  printf(1, "unlinkread ok\n");
     1f4:	be 71 20 00 00       	mov    $0x2071,%esi
     1f9:	bf 01 00 00 00       	mov    $0x1,%edi
     1fe:	b0 00                	mov    $0x0,%al
     200:	e8 60 19 00 00       	call   1b65 <printf>
}
     205:	5b                   	pop    %rbx
     206:	41 5c                	pop    %r12
     208:	5d                   	pop    %rbp
     209:	c3                   	ret
    printf(1, "create unlinkread failed\n");
     20a:	be d4 1f 00 00       	mov    $0x1fd4,%esi
     20f:	bf 01 00 00 00       	mov    $0x1,%edi
     214:	b0 00                	mov    $0x0,%al
     216:	e8 4a 19 00 00       	call   1b65 <printf>
    exit();
     21b:	e8 62 17 00 00       	call   1982 <exit>
    printf(1, "open unlinkread failed\n");
     220:	be f4 1f 00 00       	mov    $0x1ff4,%esi
     225:	bf 01 00 00 00       	mov    $0x1,%edi
     22a:	b0 00                	mov    $0x0,%al
     22c:	e8 34 19 00 00       	call   1b65 <printf>
    exit();
     231:	e8 4c 17 00 00       	call   1982 <exit>
    printf(1, "unlink unlinkread failed\n");
     236:	be 0c 20 00 00       	mov    $0x200c,%esi
     23b:	bf 01 00 00 00       	mov    $0x1,%edi
     240:	b0 00                	mov    $0x0,%al
     242:	e8 1e 19 00 00       	call   1b65 <printf>
    exit();
     247:	e8 36 17 00 00       	call   1982 <exit>
    printf(1, "unlinkread read failed");
     24c:	be 2a 20 00 00       	mov    $0x202a,%esi
     251:	bf 01 00 00 00       	mov    $0x1,%edi
     256:	b0 00                	mov    $0x0,%al
     258:	e8 08 19 00 00       	call   1b65 <printf>
    exit();
     25d:	e8 20 17 00 00       	call   1982 <exit>
    printf(1, "unlinkread wrong data\n");
     262:	be 41 20 00 00       	mov    $0x2041,%esi
     267:	bf 01 00 00 00       	mov    $0x1,%edi
     26c:	b0 00                	mov    $0x0,%al
     26e:	e8 f2 18 00 00       	call   1b65 <printf>
    exit();
     273:	e8 0a 17 00 00       	call   1982 <exit>
    printf(1, "unlinkread write failed\n");
     278:	be 58 20 00 00       	mov    $0x2058,%esi
     27d:	bf 01 00 00 00       	mov    $0x1,%edi
     282:	b0 00                	mov    $0x0,%al
     284:	e8 dc 18 00 00       	call   1b65 <printf>
    exit();
     289:	e8 f4 16 00 00       	call   1982 <exit>

000000000000028e <linktest>:

void
linktest(void)
{
     28e:	55                   	push   %rbp
     28f:	48 89 e5             	mov    %rsp,%rbp
     292:	53                   	push   %rbx
     293:	48 83 ec 08          	sub    $0x8,%rsp
  int fd;

  printf(1, "linktest\n");
     297:	be 80 20 00 00       	mov    $0x2080,%esi
     29c:	bf 01 00 00 00       	mov    $0x1,%edi
     2a1:	b0 00                	mov    $0x0,%al
     2a3:	e8 bd 18 00 00       	call   1b65 <printf>

  unlink("lf1");
     2a8:	bf 8a 20 00 00       	mov    $0x208a,%edi
     2ad:	e8 34 17 00 00       	call   19e6 <unlink>
  unlink("lf2");
     2b2:	bf 8e 20 00 00       	mov    $0x208e,%edi
     2b7:	e8 2a 17 00 00       	call   19e6 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
     2bc:	be 02 02 00 00       	mov    $0x202,%esi
     2c1:	bf 8a 20 00 00       	mov    $0x208a,%edi
     2c6:	e8 07 17 00 00       	call   19d2 <open>
  if(fd < 0){
     2cb:	85 c0                	test   %eax,%eax
     2cd:	0f 88 fa 00 00 00    	js     3cd <linktest+0x13f>
     2d3:	89 c3                	mov    %eax,%ebx
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
     2d5:	ba 05 00 00 00       	mov    $0x5,%edx
     2da:	be ee 1f 00 00       	mov    $0x1fee,%esi
     2df:	89 c7                	mov    %eax,%edi
     2e1:	e8 c4 16 00 00       	call   19aa <write>
     2e6:	83 f8 05             	cmp    $0x5,%eax
     2e9:	0f 85 f4 00 00 00    	jne    3e3 <linktest+0x155>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
     2ef:	89 df                	mov    %ebx,%edi
     2f1:	e8 be 16 00 00       	call   19b4 <close>

  if(link("lf1", "lf2") < 0){
     2f6:	be 8e 20 00 00       	mov    $0x208e,%esi
     2fb:	bf 8a 20 00 00       	mov    $0x208a,%edi
     300:	e8 f5 16 00 00       	call   19fa <link>
     305:	85 c0                	test   %eax,%eax
     307:	0f 88 ec 00 00 00    	js     3f9 <linktest+0x16b>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
     30d:	bf 8a 20 00 00       	mov    $0x208a,%edi
     312:	e8 cf 16 00 00       	call   19e6 <unlink>

  if(open("lf1", 0) >= 0){
     317:	be 00 00 00 00       	mov    $0x0,%esi
     31c:	bf 8a 20 00 00       	mov    $0x208a,%edi
     321:	e8 ac 16 00 00       	call   19d2 <open>
     326:	85 c0                	test   %eax,%eax
     328:	0f 89 e1 00 00 00    	jns    40f <linktest+0x181>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
     32e:	be 00 00 00 00       	mov    $0x0,%esi
     333:	bf 8e 20 00 00       	mov    $0x208e,%edi
     338:	e8 95 16 00 00       	call   19d2 <open>
     33d:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     33f:	85 c0                	test   %eax,%eax
     341:	0f 88 de 00 00 00    	js     425 <linktest+0x197>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
     347:	ba 00 20 00 00       	mov    $0x2000,%edx
     34c:	be 40 32 00 00       	mov    $0x3240,%esi
     351:	89 c7                	mov    %eax,%edi
     353:	e8 48 16 00 00       	call   19a0 <read>
     358:	83 f8 05             	cmp    $0x5,%eax
     35b:	0f 85 da 00 00 00    	jne    43b <linktest+0x1ad>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
     361:	89 df                	mov    %ebx,%edi
     363:	e8 4c 16 00 00       	call   19b4 <close>

  if(link("lf2", "lf2") >= 0){
     368:	be 8e 20 00 00       	mov    $0x208e,%esi
     36d:	48 89 f7             	mov    %rsi,%rdi
     370:	e8 85 16 00 00       	call   19fa <link>
     375:	85 c0                	test   %eax,%eax
     377:	0f 89 d4 00 00 00    	jns    451 <linktest+0x1c3>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
     37d:	bf 8e 20 00 00       	mov    $0x208e,%edi
     382:	e8 5f 16 00 00       	call   19e6 <unlink>
  if(link("lf2", "lf1") >= 0){
     387:	be 8a 20 00 00       	mov    $0x208a,%esi
     38c:	bf 8e 20 00 00       	mov    $0x208e,%edi
     391:	e8 64 16 00 00       	call   19fa <link>
     396:	85 c0                	test   %eax,%eax
     398:	0f 89 c9 00 00 00    	jns    467 <linktest+0x1d9>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
     39e:	be 8a 20 00 00       	mov    $0x208a,%esi
     3a3:	bf bb 22 00 00       	mov    $0x22bb,%edi
     3a8:	e8 4d 16 00 00       	call   19fa <link>
     3ad:	85 c0                	test   %eax,%eax
     3af:	0f 89 c8 00 00 00    	jns    47d <linktest+0x1ef>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
     3b5:	be 28 21 00 00       	mov    $0x2128,%esi
     3ba:	bf 01 00 00 00       	mov    $0x1,%edi
     3bf:	b0 00                	mov    $0x0,%al
     3c1:	e8 9f 17 00 00       	call   1b65 <printf>
}
     3c6:	48 83 c4 08          	add    $0x8,%rsp
     3ca:	5b                   	pop    %rbx
     3cb:	5d                   	pop    %rbp
     3cc:	c3                   	ret
    printf(1, "create lf1 failed\n");
     3cd:	be 92 20 00 00       	mov    $0x2092,%esi
     3d2:	bf 01 00 00 00       	mov    $0x1,%edi
     3d7:	b0 00                	mov    $0x0,%al
     3d9:	e8 87 17 00 00       	call   1b65 <printf>
    exit();
     3de:	e8 9f 15 00 00       	call   1982 <exit>
    printf(1, "write lf1 failed\n");
     3e3:	be a5 20 00 00       	mov    $0x20a5,%esi
     3e8:	bf 01 00 00 00       	mov    $0x1,%edi
     3ed:	b0 00                	mov    $0x0,%al
     3ef:	e8 71 17 00 00       	call   1b65 <printf>
    exit();
     3f4:	e8 89 15 00 00       	call   1982 <exit>
    printf(1, "link lf1 lf2 failed\n");
     3f9:	be b7 20 00 00       	mov    $0x20b7,%esi
     3fe:	bf 01 00 00 00       	mov    $0x1,%edi
     403:	b0 00                	mov    $0x0,%al
     405:	e8 5b 17 00 00       	call   1b65 <printf>
    exit();
     40a:	e8 73 15 00 00       	call   1982 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
     40f:	be b0 28 00 00       	mov    $0x28b0,%esi
     414:	bf 01 00 00 00       	mov    $0x1,%edi
     419:	b0 00                	mov    $0x0,%al
     41b:	e8 45 17 00 00       	call   1b65 <printf>
    exit();
     420:	e8 5d 15 00 00       	call   1982 <exit>
    printf(1, "open lf2 failed\n");
     425:	be cc 20 00 00       	mov    $0x20cc,%esi
     42a:	bf 01 00 00 00       	mov    $0x1,%edi
     42f:	b0 00                	mov    $0x0,%al
     431:	e8 2f 17 00 00       	call   1b65 <printf>
    exit();
     436:	e8 47 15 00 00       	call   1982 <exit>
    printf(1, "read lf2 failed\n");
     43b:	be dd 20 00 00       	mov    $0x20dd,%esi
     440:	bf 01 00 00 00       	mov    $0x1,%edi
     445:	b0 00                	mov    $0x0,%al
     447:	e8 19 17 00 00       	call   1b65 <printf>
    exit();
     44c:	e8 31 15 00 00       	call   1982 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
     451:	be ee 20 00 00       	mov    $0x20ee,%esi
     456:	bf 01 00 00 00       	mov    $0x1,%edi
     45b:	b0 00                	mov    $0x0,%al
     45d:	e8 03 17 00 00       	call   1b65 <printf>
    exit();
     462:	e8 1b 15 00 00       	call   1982 <exit>
    printf(1, "link non-existant succeeded! oops\n");
     467:	be e0 28 00 00       	mov    $0x28e0,%esi
     46c:	bf 01 00 00 00       	mov    $0x1,%edi
     471:	b0 00                	mov    $0x0,%al
     473:	e8 ed 16 00 00       	call   1b65 <printf>
    exit();
     478:	e8 05 15 00 00       	call   1982 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
     47d:	be 0c 21 00 00       	mov    $0x210c,%esi
     482:	bf 01 00 00 00       	mov    $0x1,%edi
     487:	b0 00                	mov    $0x0,%al
     489:	e8 d7 16 00 00       	call   1b65 <printf>
    exit();
     48e:	e8 ef 14 00 00       	call   1982 <exit>

0000000000000493 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
     493:	55                   	push   %rbp
     494:	48 89 e5             	mov    %rsp,%rbp
     497:	53                   	push   %rbx
     498:	48 83 ec 18          	sub    $0x18,%rsp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
     49c:	be 35 21 00 00       	mov    $0x2135,%esi
     4a1:	bf 01 00 00 00       	mov    $0x1,%edi
     4a6:	b0 00                	mov    $0x0,%al
     4a8:	e8 b8 16 00 00       	call   1b65 <printf>
  unlink("bd");
     4ad:	bf 42 21 00 00       	mov    $0x2142,%edi
     4b2:	e8 2f 15 00 00       	call   19e6 <unlink>

  fd = open("bd", O_CREATE);
     4b7:	be 00 02 00 00       	mov    $0x200,%esi
     4bc:	bf 42 21 00 00       	mov    $0x2142,%edi
     4c1:	e8 0c 15 00 00       	call   19d2 <open>
  if(fd < 0){
     4c6:	85 c0                	test   %eax,%eax
     4c8:	78 5a                	js     524 <bigdir+0x91>
     4ca:	89 c7                	mov    %eax,%edi
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
     4cc:	e8 e3 14 00 00       	call   19b4 <close>

  for(i = 0; i < 500; i++){
     4d1:	bb 00 00 00 00       	mov    $0x0,%ebx
     4d6:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
     4dc:	7f 72                	jg     550 <bigdir+0xbd>
    name[0] = 'x';
     4de:	c6 45 e6 78          	movb   $0x78,-0x1a(%rbp)
    name[1] = '0' + (i / 64);
     4e2:	8d 43 3f             	lea    0x3f(%rbx),%eax
     4e5:	85 db                	test   %ebx,%ebx
     4e7:	0f 49 c3             	cmovns %ebx,%eax
     4ea:	c1 f8 06             	sar    $0x6,%eax
     4ed:	83 c0 30             	add    $0x30,%eax
     4f0:	88 45 e7             	mov    %al,-0x19(%rbp)
    name[2] = '0' + (i % 64);
     4f3:	89 da                	mov    %ebx,%edx
     4f5:	c1 fa 1f             	sar    $0x1f,%edx
     4f8:	c1 ea 1a             	shr    $0x1a,%edx
     4fb:	8d 04 13             	lea    (%rbx,%rdx,1),%eax
     4fe:	83 e0 3f             	and    $0x3f,%eax
     501:	29 d0                	sub    %edx,%eax
     503:	83 c0 30             	add    $0x30,%eax
     506:	88 45 e8             	mov    %al,-0x18(%rbp)
    name[3] = '\0';
     509:	c6 45 e9 00          	movb   $0x0,-0x17(%rbp)
    if(link("bd", name) != 0){
     50d:	48 8d 75 e6          	lea    -0x1a(%rbp),%rsi
     511:	bf 42 21 00 00       	mov    $0x2142,%edi
     516:	e8 df 14 00 00       	call   19fa <link>
     51b:	85 c0                	test   %eax,%eax
     51d:	75 1b                	jne    53a <bigdir+0xa7>
  for(i = 0; i < 500; i++){
     51f:	83 c3 01             	add    $0x1,%ebx
     522:	eb b2                	jmp    4d6 <bigdir+0x43>
    printf(1, "bigdir create failed\n");
     524:	be 45 21 00 00       	mov    $0x2145,%esi
     529:	bf 01 00 00 00       	mov    $0x1,%edi
     52e:	b0 00                	mov    $0x0,%al
     530:	e8 30 16 00 00       	call   1b65 <printf>
    exit();
     535:	e8 48 14 00 00       	call   1982 <exit>
      printf(1, "bigdir link failed\n");
     53a:	be 5b 21 00 00       	mov    $0x215b,%esi
     53f:	bf 01 00 00 00       	mov    $0x1,%edi
     544:	b0 00                	mov    $0x0,%al
     546:	e8 1a 16 00 00       	call   1b65 <printf>
      exit();
     54b:	e8 32 14 00 00       	call   1982 <exit>
    }
  }

  unlink("bd");
     550:	bf 42 21 00 00       	mov    $0x2142,%edi
     555:	e8 8c 14 00 00       	call   19e6 <unlink>
  for(i = 0; i < 500; i++){
     55a:	bb 00 00 00 00       	mov    $0x0,%ebx
     55f:	eb 03                	jmp    564 <bigdir+0xd1>
     561:	83 c3 01             	add    $0x1,%ebx
     564:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
     56a:	7f 52                	jg     5be <bigdir+0x12b>
    name[0] = 'x';
     56c:	c6 45 e6 78          	movb   $0x78,-0x1a(%rbp)
    name[1] = '0' + (i / 64);
     570:	8d 43 3f             	lea    0x3f(%rbx),%eax
     573:	85 db                	test   %ebx,%ebx
     575:	0f 49 c3             	cmovns %ebx,%eax
     578:	c1 f8 06             	sar    $0x6,%eax
     57b:	83 c0 30             	add    $0x30,%eax
     57e:	88 45 e7             	mov    %al,-0x19(%rbp)
    name[2] = '0' + (i % 64);
     581:	89 da                	mov    %ebx,%edx
     583:	c1 fa 1f             	sar    $0x1f,%edx
     586:	c1 ea 1a             	shr    $0x1a,%edx
     589:	8d 04 13             	lea    (%rbx,%rdx,1),%eax
     58c:	83 e0 3f             	and    $0x3f,%eax
     58f:	29 d0                	sub    %edx,%eax
     591:	83 c0 30             	add    $0x30,%eax
     594:	88 45 e8             	mov    %al,-0x18(%rbp)
    name[3] = '\0';
     597:	c6 45 e9 00          	movb   $0x0,-0x17(%rbp)
    if(unlink(name) != 0){
     59b:	48 8d 7d e6          	lea    -0x1a(%rbp),%rdi
     59f:	e8 42 14 00 00       	call   19e6 <unlink>
     5a4:	85 c0                	test   %eax,%eax
     5a6:	74 b9                	je     561 <bigdir+0xce>
      printf(1, "bigdir unlink failed");
     5a8:	be 6f 21 00 00       	mov    $0x216f,%esi
     5ad:	bf 01 00 00 00       	mov    $0x1,%edi
     5b2:	b0 00                	mov    $0x0,%al
     5b4:	e8 ac 15 00 00       	call   1b65 <printf>
      exit();
     5b9:	e8 c4 13 00 00       	call   1982 <exit>
    }
  }

  printf(1, "bigdir ok\n");
     5be:	be 84 21 00 00       	mov    $0x2184,%esi
     5c3:	bf 01 00 00 00       	mov    $0x1,%edi
     5c8:	b0 00                	mov    $0x0,%al
     5ca:	e8 96 15 00 00       	call   1b65 <printf>
}
     5cf:	48 83 c4 18          	add    $0x18,%rsp
     5d3:	5b                   	pop    %rbx
     5d4:	5d                   	pop    %rbp
     5d5:	c3                   	ret

00000000000005d6 <subdir>:

void
subdir(void)
{
     5d6:	55                   	push   %rbp
     5d7:	48 89 e5             	mov    %rsp,%rbp
     5da:	53                   	push   %rbx
     5db:	48 83 ec 08          	sub    $0x8,%rsp
  int fd, cc;

  printf(1, "subdir test\n");
     5df:	be 8f 21 00 00       	mov    $0x218f,%esi
     5e4:	bf 01 00 00 00       	mov    $0x1,%edi
     5e9:	b0 00                	mov    $0x0,%al
     5eb:	e8 75 15 00 00       	call   1b65 <printf>

  unlink("ff");
     5f0:	bf 18 22 00 00       	mov    $0x2218,%edi
     5f5:	e8 ec 13 00 00       	call   19e6 <unlink>
  if(mkdir("dd") != 0){
     5fa:	bf b5 22 00 00       	mov    $0x22b5,%edi
     5ff:	e8 00 14 00 00       	call   1a04 <mkdir>
     604:	85 c0                	test   %eax,%eax
     606:	0f 85 51 03 00 00    	jne    95d <subdir+0x387>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
     60c:	be 02 02 00 00       	mov    $0x202,%esi
     611:	bf ee 21 00 00       	mov    $0x21ee,%edi
     616:	e8 b7 13 00 00       	call   19d2 <open>
     61b:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     61d:	85 c0                	test   %eax,%eax
     61f:	0f 88 4e 03 00 00    	js     973 <subdir+0x39d>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
     625:	ba 02 00 00 00       	mov    $0x2,%edx
     62a:	be 18 22 00 00       	mov    $0x2218,%esi
     62f:	89 c7                	mov    %eax,%edi
     631:	e8 74 13 00 00       	call   19aa <write>
  close(fd);
     636:	89 df                	mov    %ebx,%edi
     638:	e8 77 13 00 00       	call   19b4 <close>

  if(unlink("dd") >= 0){
     63d:	bf b5 22 00 00       	mov    $0x22b5,%edi
     642:	e8 9f 13 00 00       	call   19e6 <unlink>
     647:	85 c0                	test   %eax,%eax
     649:	0f 89 3a 03 00 00    	jns    989 <subdir+0x3b3>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
     64f:	bf c9 21 00 00       	mov    $0x21c9,%edi
     654:	e8 ab 13 00 00       	call   1a04 <mkdir>
     659:	85 c0                	test   %eax,%eax
     65b:	0f 85 3e 03 00 00    	jne    99f <subdir+0x3c9>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
     661:	be 02 02 00 00       	mov    $0x202,%esi
     666:	bf eb 21 00 00       	mov    $0x21eb,%edi
     66b:	e8 62 13 00 00       	call   19d2 <open>
     670:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     672:	85 c0                	test   %eax,%eax
     674:	0f 88 3b 03 00 00    	js     9b5 <subdir+0x3df>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
     67a:	ba 02 00 00 00       	mov    $0x2,%edx
     67f:	be 0c 22 00 00       	mov    $0x220c,%esi
     684:	89 c7                	mov    %eax,%edi
     686:	e8 1f 13 00 00       	call   19aa <write>
  close(fd);
     68b:	89 df                	mov    %ebx,%edi
     68d:	e8 22 13 00 00       	call   19b4 <close>

  fd = open("dd/dd/../ff", 0);
     692:	be 00 00 00 00       	mov    $0x0,%esi
     697:	bf 0f 22 00 00       	mov    $0x220f,%edi
     69c:	e8 31 13 00 00       	call   19d2 <open>
     6a1:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     6a3:	85 c0                	test   %eax,%eax
     6a5:	0f 88 20 03 00 00    	js     9cb <subdir+0x3f5>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
     6ab:	ba 00 20 00 00       	mov    $0x2000,%edx
     6b0:	be 40 32 00 00       	mov    $0x3240,%esi
     6b5:	89 c7                	mov    %eax,%edi
     6b7:	e8 e4 12 00 00       	call   19a0 <read>
  if(cc != 2 || buf[0] != 'f'){
     6bc:	83 f8 02             	cmp    $0x2,%eax
     6bf:	0f 85 1c 03 00 00    	jne    9e1 <subdir+0x40b>
     6c5:	0f be 05 74 2b 00 00 	movsbl 0x2b74(%rip),%eax        # 3240 <buf>
     6cc:	83 f8 66             	cmp    $0x66,%eax
     6cf:	0f 85 0c 03 00 00    	jne    9e1 <subdir+0x40b>
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
     6d5:	89 df                	mov    %ebx,%edi
     6d7:	e8 d8 12 00 00       	call   19b4 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
     6dc:	be 4f 22 00 00       	mov    $0x224f,%esi
     6e1:	bf eb 21 00 00       	mov    $0x21eb,%edi
     6e6:	e8 0f 13 00 00       	call   19fa <link>
     6eb:	85 c0                	test   %eax,%eax
     6ed:	0f 85 04 03 00 00    	jne    9f7 <subdir+0x421>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
     6f3:	bf eb 21 00 00       	mov    $0x21eb,%edi
     6f8:	e8 e9 12 00 00       	call   19e6 <unlink>
     6fd:	85 c0                	test   %eax,%eax
     6ff:	0f 85 08 03 00 00    	jne    a0d <subdir+0x437>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
     705:	be 00 00 00 00       	mov    $0x0,%esi
     70a:	bf eb 21 00 00       	mov    $0x21eb,%edi
     70f:	e8 be 12 00 00       	call   19d2 <open>
     714:	85 c0                	test   %eax,%eax
     716:	0f 89 07 03 00 00    	jns    a23 <subdir+0x44d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
     71c:	bf b5 22 00 00       	mov    $0x22b5,%edi
     721:	e8 e8 12 00 00       	call   1a0e <chdir>
     726:	85 c0                	test   %eax,%eax
     728:	0f 85 0b 03 00 00    	jne    a39 <subdir+0x463>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
     72e:	bf 83 22 00 00       	mov    $0x2283,%edi
     733:	e8 d6 12 00 00       	call   1a0e <chdir>
     738:	85 c0                	test   %eax,%eax
     73a:	0f 85 0f 03 00 00    	jne    a4f <subdir+0x479>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
     740:	bf a9 22 00 00       	mov    $0x22a9,%edi
     745:	e8 c4 12 00 00       	call   1a0e <chdir>
     74a:	85 c0                	test   %eax,%eax
     74c:	0f 85 13 03 00 00    	jne    a65 <subdir+0x48f>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
     752:	bf b8 22 00 00       	mov    $0x22b8,%edi
     757:	e8 b2 12 00 00       	call   1a0e <chdir>
     75c:	85 c0                	test   %eax,%eax
     75e:	0f 85 17 03 00 00    	jne    a7b <subdir+0x4a5>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
     764:	be 00 00 00 00       	mov    $0x0,%esi
     769:	bf 4f 22 00 00       	mov    $0x224f,%edi
     76e:	e8 5f 12 00 00       	call   19d2 <open>
     773:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     775:	85 c0                	test   %eax,%eax
     777:	0f 88 14 03 00 00    	js     a91 <subdir+0x4bb>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
     77d:	ba 00 20 00 00       	mov    $0x2000,%edx
     782:	be 40 32 00 00       	mov    $0x3240,%esi
     787:	89 c7                	mov    %eax,%edi
     789:	e8 12 12 00 00       	call   19a0 <read>
     78e:	83 f8 02             	cmp    $0x2,%eax
     791:	0f 85 10 03 00 00    	jne    aa7 <subdir+0x4d1>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
     797:	89 df                	mov    %ebx,%edi
     799:	e8 16 12 00 00       	call   19b4 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
     79e:	be 00 00 00 00       	mov    $0x0,%esi
     7a3:	bf eb 21 00 00       	mov    $0x21eb,%edi
     7a8:	e8 25 12 00 00       	call   19d2 <open>
     7ad:	85 c0                	test   %eax,%eax
     7af:	0f 89 08 03 00 00    	jns    abd <subdir+0x4e7>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
     7b5:	be 02 02 00 00       	mov    $0x202,%esi
     7ba:	bf 03 23 00 00       	mov    $0x2303,%edi
     7bf:	e8 0e 12 00 00       	call   19d2 <open>
     7c4:	85 c0                	test   %eax,%eax
     7c6:	0f 89 07 03 00 00    	jns    ad3 <subdir+0x4fd>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
     7cc:	be 02 02 00 00       	mov    $0x202,%esi
     7d1:	bf 28 23 00 00       	mov    $0x2328,%edi
     7d6:	e8 f7 11 00 00       	call   19d2 <open>
     7db:	85 c0                	test   %eax,%eax
     7dd:	0f 89 06 03 00 00    	jns    ae9 <subdir+0x513>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
     7e3:	be 00 02 00 00       	mov    $0x200,%esi
     7e8:	bf b5 22 00 00       	mov    $0x22b5,%edi
     7ed:	e8 e0 11 00 00       	call   19d2 <open>
     7f2:	85 c0                	test   %eax,%eax
     7f4:	0f 89 05 03 00 00    	jns    aff <subdir+0x529>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
     7fa:	be 02 00 00 00       	mov    $0x2,%esi
     7ff:	bf b5 22 00 00       	mov    $0x22b5,%edi
     804:	e8 c9 11 00 00       	call   19d2 <open>
     809:	85 c0                	test   %eax,%eax
     80b:	0f 89 04 03 00 00    	jns    b15 <subdir+0x53f>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
     811:	be 01 00 00 00       	mov    $0x1,%esi
     816:	bf b5 22 00 00       	mov    $0x22b5,%edi
     81b:	e8 b2 11 00 00       	call   19d2 <open>
     820:	85 c0                	test   %eax,%eax
     822:	0f 89 03 03 00 00    	jns    b2b <subdir+0x555>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
     828:	be 97 23 00 00       	mov    $0x2397,%esi
     82d:	bf 03 23 00 00       	mov    $0x2303,%edi
     832:	e8 c3 11 00 00       	call   19fa <link>
     837:	85 c0                	test   %eax,%eax
     839:	0f 84 02 03 00 00    	je     b41 <subdir+0x56b>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
     83f:	be 97 23 00 00       	mov    $0x2397,%esi
     844:	bf 28 23 00 00       	mov    $0x2328,%edi
     849:	e8 ac 11 00 00       	call   19fa <link>
     84e:	85 c0                	test   %eax,%eax
     850:	0f 84 ff 02 00 00    	je     b55 <subdir+0x57f>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
     856:	be 4f 22 00 00       	mov    $0x224f,%esi
     85b:	bf ee 21 00 00       	mov    $0x21ee,%edi
     860:	e8 95 11 00 00       	call   19fa <link>
     865:	85 c0                	test   %eax,%eax
     867:	0f 84 fc 02 00 00    	je     b69 <subdir+0x593>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
     86d:	bf 03 23 00 00       	mov    $0x2303,%edi
     872:	e8 8d 11 00 00       	call   1a04 <mkdir>
     877:	85 c0                	test   %eax,%eax
     879:	0f 84 fe 02 00 00    	je     b7d <subdir+0x5a7>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
     87f:	bf 28 23 00 00       	mov    $0x2328,%edi
     884:	e8 7b 11 00 00       	call   1a04 <mkdir>
     889:	85 c0                	test   %eax,%eax
     88b:	0f 84 00 03 00 00    	je     b91 <subdir+0x5bb>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
     891:	bf 4f 22 00 00       	mov    $0x224f,%edi
     896:	e8 69 11 00 00       	call   1a04 <mkdir>
     89b:	85 c0                	test   %eax,%eax
     89d:	0f 84 02 03 00 00    	je     ba5 <subdir+0x5cf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
     8a3:	bf 28 23 00 00       	mov    $0x2328,%edi
     8a8:	e8 39 11 00 00       	call   19e6 <unlink>
     8ad:	85 c0                	test   %eax,%eax
     8af:	0f 84 04 03 00 00    	je     bb9 <subdir+0x5e3>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
     8b5:	bf 03 23 00 00       	mov    $0x2303,%edi
     8ba:	e8 27 11 00 00       	call   19e6 <unlink>
     8bf:	85 c0                	test   %eax,%eax
     8c1:	0f 84 06 03 00 00    	je     bcd <subdir+0x5f7>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
     8c7:	bf ee 21 00 00       	mov    $0x21ee,%edi
     8cc:	e8 3d 11 00 00       	call   1a0e <chdir>
     8d1:	85 c0                	test   %eax,%eax
     8d3:	0f 84 08 03 00 00    	je     be1 <subdir+0x60b>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
     8d9:	bf 9a 23 00 00       	mov    $0x239a,%edi
     8de:	e8 2b 11 00 00       	call   1a0e <chdir>
     8e3:	85 c0                	test   %eax,%eax
     8e5:	0f 84 0a 03 00 00    	je     bf5 <subdir+0x61f>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
     8eb:	bf 4f 22 00 00       	mov    $0x224f,%edi
     8f0:	e8 f1 10 00 00       	call   19e6 <unlink>
     8f5:	85 c0                	test   %eax,%eax
     8f7:	0f 85 0c 03 00 00    	jne    c09 <subdir+0x633>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
     8fd:	bf ee 21 00 00       	mov    $0x21ee,%edi
     902:	e8 df 10 00 00       	call   19e6 <unlink>
     907:	85 c0                	test   %eax,%eax
     909:	0f 85 10 03 00 00    	jne    c1f <subdir+0x649>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
     90f:	bf b5 22 00 00       	mov    $0x22b5,%edi
     914:	e8 cd 10 00 00       	call   19e6 <unlink>
     919:	85 c0                	test   %eax,%eax
     91b:	0f 84 14 03 00 00    	je     c35 <subdir+0x65f>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
     921:	bf ca 21 00 00       	mov    $0x21ca,%edi
     926:	e8 bb 10 00 00       	call   19e6 <unlink>
     92b:	85 c0                	test   %eax,%eax
     92d:	0f 88 16 03 00 00    	js     c49 <subdir+0x673>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
     933:	bf b5 22 00 00       	mov    $0x22b5,%edi
     938:	e8 a9 10 00 00       	call   19e6 <unlink>
     93d:	85 c0                	test   %eax,%eax
     93f:	0f 88 1a 03 00 00    	js     c5f <subdir+0x689>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
     945:	be 97 24 00 00       	mov    $0x2497,%esi
     94a:	bf 01 00 00 00       	mov    $0x1,%edi
     94f:	b0 00                	mov    $0x0,%al
     951:	e8 0f 12 00 00       	call   1b65 <printf>
}
     956:	48 83 c4 08          	add    $0x8,%rsp
     95a:	5b                   	pop    %rbx
     95b:	5d                   	pop    %rbp
     95c:	c3                   	ret
    printf(1, "subdir mkdir dd failed\n");
     95d:	be 9c 21 00 00       	mov    $0x219c,%esi
     962:	bf 01 00 00 00       	mov    $0x1,%edi
     967:	b0 00                	mov    $0x0,%al
     969:	e8 f7 11 00 00       	call   1b65 <printf>
    exit();
     96e:	e8 0f 10 00 00       	call   1982 <exit>
    printf(1, "create dd/ff failed\n");
     973:	be b4 21 00 00       	mov    $0x21b4,%esi
     978:	bf 01 00 00 00       	mov    $0x1,%edi
     97d:	b0 00                	mov    $0x0,%al
     97f:	e8 e1 11 00 00       	call   1b65 <printf>
    exit();
     984:	e8 f9 0f 00 00       	call   1982 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
     989:	be 08 29 00 00       	mov    $0x2908,%esi
     98e:	bf 01 00 00 00       	mov    $0x1,%edi
     993:	b0 00                	mov    $0x0,%al
     995:	e8 cb 11 00 00       	call   1b65 <printf>
    exit();
     99a:	e8 e3 0f 00 00       	call   1982 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
     99f:	be d0 21 00 00       	mov    $0x21d0,%esi
     9a4:	bf 01 00 00 00       	mov    $0x1,%edi
     9a9:	b0 00                	mov    $0x0,%al
     9ab:	e8 b5 11 00 00       	call   1b65 <printf>
    exit();
     9b0:	e8 cd 0f 00 00       	call   1982 <exit>
    printf(1, "create dd/dd/ff failed\n");
     9b5:	be f4 21 00 00       	mov    $0x21f4,%esi
     9ba:	bf 01 00 00 00       	mov    $0x1,%edi
     9bf:	b0 00                	mov    $0x0,%al
     9c1:	e8 9f 11 00 00       	call   1b65 <printf>
    exit();
     9c6:	e8 b7 0f 00 00       	call   1982 <exit>
    printf(1, "open dd/dd/../ff failed\n");
     9cb:	be 1b 22 00 00       	mov    $0x221b,%esi
     9d0:	bf 01 00 00 00       	mov    $0x1,%edi
     9d5:	b0 00                	mov    $0x0,%al
     9d7:	e8 89 11 00 00       	call   1b65 <printf>
    exit();
     9dc:	e8 a1 0f 00 00       	call   1982 <exit>
    printf(1, "dd/dd/../ff wrong content\n");
     9e1:	be 34 22 00 00       	mov    $0x2234,%esi
     9e6:	bf 01 00 00 00       	mov    $0x1,%edi
     9eb:	b0 00                	mov    $0x0,%al
     9ed:	e8 73 11 00 00       	call   1b65 <printf>
    exit();
     9f2:	e8 8b 0f 00 00       	call   1982 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
     9f7:	be 30 29 00 00       	mov    $0x2930,%esi
     9fc:	bf 01 00 00 00       	mov    $0x1,%edi
     a01:	b0 00                	mov    $0x0,%al
     a03:	e8 5d 11 00 00       	call   1b65 <printf>
    exit();
     a08:	e8 75 0f 00 00       	call   1982 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
     a0d:	be 5a 22 00 00       	mov    $0x225a,%esi
     a12:	bf 01 00 00 00       	mov    $0x1,%edi
     a17:	b0 00                	mov    $0x0,%al
     a19:	e8 47 11 00 00       	call   1b65 <printf>
    exit();
     a1e:	e8 5f 0f 00 00       	call   1982 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
     a23:	be 58 29 00 00       	mov    $0x2958,%esi
     a28:	bf 01 00 00 00       	mov    $0x1,%edi
     a2d:	b0 00                	mov    $0x0,%al
     a2f:	e8 31 11 00 00       	call   1b65 <printf>
    exit();
     a34:	e8 49 0f 00 00       	call   1982 <exit>
    printf(1, "chdir dd failed\n");
     a39:	be 72 22 00 00       	mov    $0x2272,%esi
     a3e:	bf 01 00 00 00       	mov    $0x1,%edi
     a43:	b0 00                	mov    $0x0,%al
     a45:	e8 1b 11 00 00       	call   1b65 <printf>
    exit();
     a4a:	e8 33 0f 00 00       	call   1982 <exit>
    printf(1, "chdir dd/../../dd failed\n");
     a4f:	be 8f 22 00 00       	mov    $0x228f,%esi
     a54:	bf 01 00 00 00       	mov    $0x1,%edi
     a59:	b0 00                	mov    $0x0,%al
     a5b:	e8 05 11 00 00       	call   1b65 <printf>
    exit();
     a60:	e8 1d 0f 00 00       	call   1982 <exit>
    printf(1, "chdir dd/../../dd failed\n");
     a65:	be 8f 22 00 00       	mov    $0x228f,%esi
     a6a:	bf 01 00 00 00       	mov    $0x1,%edi
     a6f:	b0 00                	mov    $0x0,%al
     a71:	e8 ef 10 00 00       	call   1b65 <printf>
    exit();
     a76:	e8 07 0f 00 00       	call   1982 <exit>
    printf(1, "chdir ./.. failed\n");
     a7b:	be bd 22 00 00       	mov    $0x22bd,%esi
     a80:	bf 01 00 00 00       	mov    $0x1,%edi
     a85:	b0 00                	mov    $0x0,%al
     a87:	e8 d9 10 00 00       	call   1b65 <printf>
    exit();
     a8c:	e8 f1 0e 00 00       	call   1982 <exit>
    printf(1, "open dd/dd/ffff failed\n");
     a91:	be d0 22 00 00       	mov    $0x22d0,%esi
     a96:	bf 01 00 00 00       	mov    $0x1,%edi
     a9b:	b0 00                	mov    $0x0,%al
     a9d:	e8 c3 10 00 00       	call   1b65 <printf>
    exit();
     aa2:	e8 db 0e 00 00       	call   1982 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
     aa7:	be e8 22 00 00       	mov    $0x22e8,%esi
     aac:	bf 01 00 00 00       	mov    $0x1,%edi
     ab1:	b0 00                	mov    $0x0,%al
     ab3:	e8 ad 10 00 00       	call   1b65 <printf>
    exit();
     ab8:	e8 c5 0e 00 00       	call   1982 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
     abd:	be 80 29 00 00       	mov    $0x2980,%esi
     ac2:	bf 01 00 00 00       	mov    $0x1,%edi
     ac7:	b0 00                	mov    $0x0,%al
     ac9:	e8 97 10 00 00       	call   1b65 <printf>
    exit();
     ace:	e8 af 0e 00 00       	call   1982 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
     ad3:	be 0c 23 00 00       	mov    $0x230c,%esi
     ad8:	bf 01 00 00 00       	mov    $0x1,%edi
     add:	b0 00                	mov    $0x0,%al
     adf:	e8 81 10 00 00       	call   1b65 <printf>
    exit();
     ae4:	e8 99 0e 00 00       	call   1982 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
     ae9:	be 31 23 00 00       	mov    $0x2331,%esi
     aee:	bf 01 00 00 00       	mov    $0x1,%edi
     af3:	b0 00                	mov    $0x0,%al
     af5:	e8 6b 10 00 00       	call   1b65 <printf>
    exit();
     afa:	e8 83 0e 00 00       	call   1982 <exit>
    printf(1, "create dd succeeded!\n");
     aff:	be 4d 23 00 00       	mov    $0x234d,%esi
     b04:	bf 01 00 00 00       	mov    $0x1,%edi
     b09:	b0 00                	mov    $0x0,%al
     b0b:	e8 55 10 00 00       	call   1b65 <printf>
    exit();
     b10:	e8 6d 0e 00 00       	call   1982 <exit>
    printf(1, "open dd rdwr succeeded!\n");
     b15:	be 63 23 00 00       	mov    $0x2363,%esi
     b1a:	bf 01 00 00 00       	mov    $0x1,%edi
     b1f:	b0 00                	mov    $0x0,%al
     b21:	e8 3f 10 00 00       	call   1b65 <printf>
    exit();
     b26:	e8 57 0e 00 00       	call   1982 <exit>
    printf(1, "open dd wronly succeeded!\n");
     b2b:	be 7c 23 00 00       	mov    $0x237c,%esi
     b30:	bf 01 00 00 00       	mov    $0x1,%edi
     b35:	b0 00                	mov    $0x0,%al
     b37:	e8 29 10 00 00       	call   1b65 <printf>
    exit();
     b3c:	e8 41 0e 00 00       	call   1982 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
     b41:	be a8 29 00 00       	mov    $0x29a8,%esi
     b46:	bf 01 00 00 00       	mov    $0x1,%edi
     b4b:	e8 15 10 00 00       	call   1b65 <printf>
    exit();
     b50:	e8 2d 0e 00 00       	call   1982 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
     b55:	be d0 29 00 00       	mov    $0x29d0,%esi
     b5a:	bf 01 00 00 00       	mov    $0x1,%edi
     b5f:	e8 01 10 00 00       	call   1b65 <printf>
    exit();
     b64:	e8 19 0e 00 00       	call   1982 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
     b69:	be f8 29 00 00       	mov    $0x29f8,%esi
     b6e:	bf 01 00 00 00       	mov    $0x1,%edi
     b73:	e8 ed 0f 00 00       	call   1b65 <printf>
    exit();
     b78:	e8 05 0e 00 00       	call   1982 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
     b7d:	be a0 23 00 00       	mov    $0x23a0,%esi
     b82:	bf 01 00 00 00       	mov    $0x1,%edi
     b87:	e8 d9 0f 00 00       	call   1b65 <printf>
    exit();
     b8c:	e8 f1 0d 00 00       	call   1982 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
     b91:	be bb 23 00 00       	mov    $0x23bb,%esi
     b96:	bf 01 00 00 00       	mov    $0x1,%edi
     b9b:	e8 c5 0f 00 00       	call   1b65 <printf>
    exit();
     ba0:	e8 dd 0d 00 00       	call   1982 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
     ba5:	be d6 23 00 00       	mov    $0x23d6,%esi
     baa:	bf 01 00 00 00       	mov    $0x1,%edi
     baf:	e8 b1 0f 00 00       	call   1b65 <printf>
    exit();
     bb4:	e8 c9 0d 00 00       	call   1982 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
     bb9:	be f3 23 00 00       	mov    $0x23f3,%esi
     bbe:	bf 01 00 00 00       	mov    $0x1,%edi
     bc3:	e8 9d 0f 00 00       	call   1b65 <printf>
    exit();
     bc8:	e8 b5 0d 00 00       	call   1982 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
     bcd:	be 0f 24 00 00       	mov    $0x240f,%esi
     bd2:	bf 01 00 00 00       	mov    $0x1,%edi
     bd7:	e8 89 0f 00 00       	call   1b65 <printf>
    exit();
     bdc:	e8 a1 0d 00 00       	call   1982 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
     be1:	be 2b 24 00 00       	mov    $0x242b,%esi
     be6:	bf 01 00 00 00       	mov    $0x1,%edi
     beb:	e8 75 0f 00 00       	call   1b65 <printf>
    exit();
     bf0:	e8 8d 0d 00 00       	call   1982 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
     bf5:	be 43 24 00 00       	mov    $0x2443,%esi
     bfa:	bf 01 00 00 00       	mov    $0x1,%edi
     bff:	e8 61 0f 00 00       	call   1b65 <printf>
    exit();
     c04:	e8 79 0d 00 00       	call   1982 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
     c09:	be 5a 22 00 00       	mov    $0x225a,%esi
     c0e:	bf 01 00 00 00       	mov    $0x1,%edi
     c13:	b0 00                	mov    $0x0,%al
     c15:	e8 4b 0f 00 00       	call   1b65 <printf>
    exit();
     c1a:	e8 63 0d 00 00       	call   1982 <exit>
    printf(1, "unlink dd/ff failed\n");
     c1f:	be 5b 24 00 00       	mov    $0x245b,%esi
     c24:	bf 01 00 00 00       	mov    $0x1,%edi
     c29:	b0 00                	mov    $0x0,%al
     c2b:	e8 35 0f 00 00       	call   1b65 <printf>
    exit();
     c30:	e8 4d 0d 00 00       	call   1982 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
     c35:	be 20 2a 00 00       	mov    $0x2a20,%esi
     c3a:	bf 01 00 00 00       	mov    $0x1,%edi
     c3f:	e8 21 0f 00 00       	call   1b65 <printf>
    exit();
     c44:	e8 39 0d 00 00       	call   1982 <exit>
    printf(1, "unlink dd/dd failed\n");
     c49:	be 70 24 00 00       	mov    $0x2470,%esi
     c4e:	bf 01 00 00 00       	mov    $0x1,%edi
     c53:	b0 00                	mov    $0x0,%al
     c55:	e8 0b 0f 00 00       	call   1b65 <printf>
    exit();
     c5a:	e8 23 0d 00 00       	call   1982 <exit>
    printf(1, "unlink dd failed\n");
     c5f:	be 85 24 00 00       	mov    $0x2485,%esi
     c64:	bf 01 00 00 00       	mov    $0x1,%edi
     c69:	b0 00                	mov    $0x0,%al
     c6b:	e8 f5 0e 00 00       	call   1b65 <printf>
    exit();
     c70:	e8 0d 0d 00 00       	call   1982 <exit>

0000000000000c75 <bigfile>:

void
bigfile(void)
{
     c75:	55                   	push   %rbp
     c76:	48 89 e5             	mov    %rsp,%rbp
     c79:	41 55                	push   %r13
     c7b:	41 54                	push   %r12
     c7d:	53                   	push   %rbx
     c7e:	48 83 ec 08          	sub    $0x8,%rsp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
     c82:	be a2 24 00 00       	mov    $0x24a2,%esi
     c87:	bf 01 00 00 00       	mov    $0x1,%edi
     c8c:	b0 00                	mov    $0x0,%al
     c8e:	e8 d2 0e 00 00       	call   1b65 <printf>

  unlink("bigfile");
     c93:	bf be 24 00 00       	mov    $0x24be,%edi
     c98:	e8 49 0d 00 00       	call   19e6 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
     c9d:	be 02 02 00 00       	mov    $0x202,%esi
     ca2:	bf be 24 00 00       	mov    $0x24be,%edi
     ca7:	e8 26 0d 00 00       	call   19d2 <open>
  if(fd < 0){
     cac:	85 c0                	test   %eax,%eax
     cae:	78 3c                	js     cec <bigfile+0x77>
     cb0:	41 89 c4             	mov    %eax,%r12d
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
     cb3:	bb 00 00 00 00       	mov    $0x0,%ebx
     cb8:	83 fb 13             	cmp    $0x13,%ebx
     cbb:	7f 5b                	jg     d18 <bigfile+0xa3>
    memset(buf, i, 600);
     cbd:	ba 58 02 00 00       	mov    $0x258,%edx
     cc2:	89 de                	mov    %ebx,%esi
     cc4:	bf 40 32 00 00       	mov    $0x3240,%edi
     cc9:	e8 31 0b 00 00       	call   17ff <memset>
    if(write(fd, buf, 600) != 600){
     cce:	ba 58 02 00 00       	mov    $0x258,%edx
     cd3:	be 40 32 00 00       	mov    $0x3240,%esi
     cd8:	44 89 e7             	mov    %r12d,%edi
     cdb:	e8 ca 0c 00 00       	call   19aa <write>
     ce0:	3d 58 02 00 00       	cmp    $0x258,%eax
     ce5:	75 1b                	jne    d02 <bigfile+0x8d>
  for(i = 0; i < 20; i++){
     ce7:	83 c3 01             	add    $0x1,%ebx
     cea:	eb cc                	jmp    cb8 <bigfile+0x43>
    printf(1, "cannot create bigfile");
     cec:	be b0 24 00 00       	mov    $0x24b0,%esi
     cf1:	bf 01 00 00 00       	mov    $0x1,%edi
     cf6:	b0 00                	mov    $0x0,%al
     cf8:	e8 68 0e 00 00       	call   1b65 <printf>
    exit();
     cfd:	e8 80 0c 00 00       	call   1982 <exit>
      printf(1, "write bigfile failed\n");
     d02:	be c6 24 00 00       	mov    $0x24c6,%esi
     d07:	bf 01 00 00 00       	mov    $0x1,%edi
     d0c:	b0 00                	mov    $0x0,%al
     d0e:	e8 52 0e 00 00       	call   1b65 <printf>
      exit();
     d13:	e8 6a 0c 00 00       	call   1982 <exit>
    }
  }
  close(fd);
     d18:	44 89 e7             	mov    %r12d,%edi
     d1b:	e8 94 0c 00 00       	call   19b4 <close>

  fd = open("bigfile", 0);
     d20:	be 00 00 00 00       	mov    $0x0,%esi
     d25:	bf be 24 00 00       	mov    $0x24be,%edi
     d2a:	e8 a3 0c 00 00       	call   19d2 <open>
     d2f:	41 89 c5             	mov    %eax,%r13d
  if(fd < 0){
     d32:	85 c0                	test   %eax,%eax
     d34:	78 55                	js     d8b <bigfile+0x116>
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
     d36:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(i = 0; ; i++){
     d3c:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(fd, buf, 300);
     d41:	ba 2c 01 00 00       	mov    $0x12c,%edx
     d46:	be 40 32 00 00       	mov    $0x3240,%esi
     d4b:	44 89 ef             	mov    %r13d,%edi
     d4e:	e8 4d 0c 00 00       	call   19a0 <read>
    if(cc < 0){
     d53:	85 c0                	test   %eax,%eax
     d55:	78 4a                	js     da1 <bigfile+0x12c>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
     d57:	0f 84 86 00 00 00    	je     de3 <bigfile+0x16e>
      break;
    if(cc != 300){
     d5d:	3d 2c 01 00 00       	cmp    $0x12c,%eax
     d62:	75 53                	jne    db7 <bigfile+0x142>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
     d64:	0f be 0d d5 24 00 00 	movsbl 0x24d5(%rip),%ecx        # 3240 <buf>
     d6b:	89 da                	mov    %ebx,%edx
     d6d:	c1 ea 1f             	shr    $0x1f,%edx
     d70:	01 da                	add    %ebx,%edx
     d72:	d1 fa                	sar    $1,%edx
     d74:	39 d1                	cmp    %edx,%ecx
     d76:	75 55                	jne    dcd <bigfile+0x158>
     d78:	0f be 0d ec 25 00 00 	movsbl 0x25ec(%rip),%ecx        # 336b <buf+0x12b>
     d7f:	39 ca                	cmp    %ecx,%edx
     d81:	75 4a                	jne    dcd <bigfile+0x158>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
     d83:	41 01 c4             	add    %eax,%r12d
  for(i = 0; ; i++){
     d86:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
     d89:	eb b6                	jmp    d41 <bigfile+0xcc>
    printf(1, "cannot open bigfile\n");
     d8b:	be dc 24 00 00       	mov    $0x24dc,%esi
     d90:	bf 01 00 00 00       	mov    $0x1,%edi
     d95:	b0 00                	mov    $0x0,%al
     d97:	e8 c9 0d 00 00       	call   1b65 <printf>
    exit();
     d9c:	e8 e1 0b 00 00       	call   1982 <exit>
      printf(1, "read bigfile failed\n");
     da1:	be f1 24 00 00       	mov    $0x24f1,%esi
     da6:	bf 01 00 00 00       	mov    $0x1,%edi
     dab:	b0 00                	mov    $0x0,%al
     dad:	e8 b3 0d 00 00       	call   1b65 <printf>
      exit();
     db2:	e8 cb 0b 00 00       	call   1982 <exit>
      printf(1, "short read bigfile\n");
     db7:	be 06 25 00 00       	mov    $0x2506,%esi
     dbc:	bf 01 00 00 00       	mov    $0x1,%edi
     dc1:	b0 00                	mov    $0x0,%al
     dc3:	e8 9d 0d 00 00       	call   1b65 <printf>
      exit();
     dc8:	e8 b5 0b 00 00       	call   1982 <exit>
      printf(1, "read bigfile wrong data\n");
     dcd:	be 1a 25 00 00       	mov    $0x251a,%esi
     dd2:	bf 01 00 00 00       	mov    $0x1,%edi
     dd7:	b0 00                	mov    $0x0,%al
     dd9:	e8 87 0d 00 00       	call   1b65 <printf>
      exit();
     dde:	e8 9f 0b 00 00       	call   1982 <exit>
  }
  close(fd);
     de3:	44 89 ef             	mov    %r13d,%edi
     de6:	e8 c9 0b 00 00       	call   19b4 <close>
  if(total != 20*600){
     deb:	41 81 fc e0 2e 00 00 	cmp    $0x2ee0,%r12d
     df2:	75 26                	jne    e1a <bigfile+0x1a5>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
     df4:	bf be 24 00 00       	mov    $0x24be,%edi
     df9:	e8 e8 0b 00 00       	call   19e6 <unlink>

  printf(1, "bigfile test ok\n");
     dfe:	be 4d 25 00 00       	mov    $0x254d,%esi
     e03:	bf 01 00 00 00       	mov    $0x1,%edi
     e08:	b0 00                	mov    $0x0,%al
     e0a:	e8 56 0d 00 00       	call   1b65 <printf>
}
     e0f:	48 83 c4 08          	add    $0x8,%rsp
     e13:	5b                   	pop    %rbx
     e14:	41 5c                	pop    %r12
     e16:	41 5d                	pop    %r13
     e18:	5d                   	pop    %rbp
     e19:	c3                   	ret
    printf(1, "read bigfile wrong total\n");
     e1a:	be 33 25 00 00       	mov    $0x2533,%esi
     e1f:	bf 01 00 00 00       	mov    $0x1,%edi
     e24:	b0 00                	mov    $0x0,%al
     e26:	e8 3a 0d 00 00       	call   1b65 <printf>
    exit();
     e2b:	e8 52 0b 00 00       	call   1982 <exit>

0000000000000e30 <fourteen>:

void
fourteen(void)
{
     e30:	55                   	push   %rbp
     e31:	48 89 e5             	mov    %rsp,%rbp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
     e34:	be 5e 25 00 00       	mov    $0x255e,%esi
     e39:	bf 01 00 00 00       	mov    $0x1,%edi
     e3e:	b0 00                	mov    $0x0,%al
     e40:	e8 20 0d 00 00       	call   1b65 <printf>

  if(mkdir("12345678901234") != 0){
     e45:	bf 99 25 00 00       	mov    $0x2599,%edi
     e4a:	e8 b5 0b 00 00       	call   1a04 <mkdir>
     e4f:	85 c0                	test   %eax,%eax
     e51:	75 71                	jne    ec4 <fourteen+0x94>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
     e53:	bf 40 2a 00 00       	mov    $0x2a40,%edi
     e58:	e8 a7 0b 00 00       	call   1a04 <mkdir>
     e5d:	85 c0                	test   %eax,%eax
     e5f:	75 79                	jne    eda <fourteen+0xaa>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
     e61:	be 00 02 00 00       	mov    $0x200,%esi
     e66:	bf 90 2a 00 00       	mov    $0x2a90,%edi
     e6b:	e8 62 0b 00 00       	call   19d2 <open>
     e70:	89 c7                	mov    %eax,%edi
  if(fd < 0){
     e72:	85 c0                	test   %eax,%eax
     e74:	78 7a                	js     ef0 <fourteen+0xc0>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
     e76:	e8 39 0b 00 00       	call   19b4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
     e7b:	be 00 00 00 00       	mov    $0x0,%esi
     e80:	bf 00 2b 00 00       	mov    $0x2b00,%edi
     e85:	e8 48 0b 00 00       	call   19d2 <open>
     e8a:	89 c7                	mov    %eax,%edi
  if(fd < 0){
     e8c:	85 c0                	test   %eax,%eax
     e8e:	78 76                	js     f06 <fourteen+0xd6>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
     e90:	e8 1f 0b 00 00       	call   19b4 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
     e95:	bf 8a 25 00 00       	mov    $0x258a,%edi
     e9a:	e8 65 0b 00 00       	call   1a04 <mkdir>
     e9f:	85 c0                	test   %eax,%eax
     ea1:	74 79                	je     f1c <fourteen+0xec>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
     ea3:	bf a0 2b 00 00       	mov    $0x2ba0,%edi
     ea8:	e8 57 0b 00 00       	call   1a04 <mkdir>
     ead:	85 c0                	test   %eax,%eax
     eaf:	74 7f                	je     f30 <fourteen+0x100>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
     eb1:	be a8 25 00 00       	mov    $0x25a8,%esi
     eb6:	bf 01 00 00 00       	mov    $0x1,%edi
     ebb:	b0 00                	mov    $0x0,%al
     ebd:	e8 a3 0c 00 00       	call   1b65 <printf>
}
     ec2:	5d                   	pop    %rbp
     ec3:	c3                   	ret
    printf(1, "mkdir 12345678901234 failed\n");
     ec4:	be 6d 25 00 00       	mov    $0x256d,%esi
     ec9:	bf 01 00 00 00       	mov    $0x1,%edi
     ece:	b0 00                	mov    $0x0,%al
     ed0:	e8 90 0c 00 00       	call   1b65 <printf>
    exit();
     ed5:	e8 a8 0a 00 00       	call   1982 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
     eda:	be 60 2a 00 00       	mov    $0x2a60,%esi
     edf:	bf 01 00 00 00       	mov    $0x1,%edi
     ee4:	b0 00                	mov    $0x0,%al
     ee6:	e8 7a 0c 00 00       	call   1b65 <printf>
    exit();
     eeb:	e8 92 0a 00 00       	call   1982 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
     ef0:	be c0 2a 00 00       	mov    $0x2ac0,%esi
     ef5:	bf 01 00 00 00       	mov    $0x1,%edi
     efa:	b0 00                	mov    $0x0,%al
     efc:	e8 64 0c 00 00       	call   1b65 <printf>
    exit();
     f01:	e8 7c 0a 00 00       	call   1982 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
     f06:	be 30 2b 00 00       	mov    $0x2b30,%esi
     f0b:	bf 01 00 00 00       	mov    $0x1,%edi
     f10:	b0 00                	mov    $0x0,%al
     f12:	e8 4e 0c 00 00       	call   1b65 <printf>
    exit();
     f17:	e8 66 0a 00 00       	call   1982 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
     f1c:	be 70 2b 00 00       	mov    $0x2b70,%esi
     f21:	bf 01 00 00 00       	mov    $0x1,%edi
     f26:	e8 3a 0c 00 00       	call   1b65 <printf>
    exit();
     f2b:	e8 52 0a 00 00       	call   1982 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
     f30:	be c0 2b 00 00       	mov    $0x2bc0,%esi
     f35:	bf 01 00 00 00       	mov    $0x1,%edi
     f3a:	e8 26 0c 00 00       	call   1b65 <printf>
    exit();
     f3f:	e8 3e 0a 00 00       	call   1982 <exit>

0000000000000f44 <rmdot>:

void
rmdot(void)
{
     f44:	55                   	push   %rbp
     f45:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "rmdot test\n");
     f48:	be b5 25 00 00       	mov    $0x25b5,%esi
     f4d:	bf 01 00 00 00       	mov    $0x1,%edi
     f52:	b0 00                	mov    $0x0,%al
     f54:	e8 0c 0c 00 00       	call   1b65 <printf>
  if(mkdir("dots") != 0){
     f59:	bf c1 25 00 00       	mov    $0x25c1,%edi
     f5e:	e8 a1 0a 00 00       	call   1a04 <mkdir>
     f63:	85 c0                	test   %eax,%eax
     f65:	0f 85 91 00 00 00    	jne    ffc <rmdot+0xb8>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
     f6b:	bf c1 25 00 00       	mov    $0x25c1,%edi
     f70:	e8 99 0a 00 00       	call   1a0e <chdir>
     f75:	85 c0                	test   %eax,%eax
     f77:	0f 85 95 00 00 00    	jne    1012 <rmdot+0xce>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
     f7d:	bf bb 22 00 00       	mov    $0x22bb,%edi
     f82:	e8 5f 0a 00 00       	call   19e6 <unlink>
     f87:	85 c0                	test   %eax,%eax
     f89:	0f 84 99 00 00 00    	je     1028 <rmdot+0xe4>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
     f8f:	bf ba 22 00 00       	mov    $0x22ba,%edi
     f94:	e8 4d 0a 00 00       	call   19e6 <unlink>
     f99:	85 c0                	test   %eax,%eax
     f9b:	0f 84 9b 00 00 00    	je     103c <rmdot+0xf8>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
     fa1:	bf 09 26 00 00       	mov    $0x2609,%edi
     fa6:	e8 63 0a 00 00       	call   1a0e <chdir>
     fab:	85 c0                	test   %eax,%eax
     fad:	0f 85 9d 00 00 00    	jne    1050 <rmdot+0x10c>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
     fb3:	bf 1b 26 00 00       	mov    $0x261b,%edi
     fb8:	e8 29 0a 00 00       	call   19e6 <unlink>
     fbd:	85 c0                	test   %eax,%eax
     fbf:	0f 84 a1 00 00 00    	je     1066 <rmdot+0x122>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
     fc5:	bf 39 26 00 00       	mov    $0x2639,%edi
     fca:	e8 17 0a 00 00       	call   19e6 <unlink>
     fcf:	85 c0                	test   %eax,%eax
     fd1:	0f 84 a3 00 00 00    	je     107a <rmdot+0x136>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
     fd7:	bf c1 25 00 00       	mov    $0x25c1,%edi
     fdc:	e8 05 0a 00 00       	call   19e6 <unlink>
     fe1:	85 c0                	test   %eax,%eax
     fe3:	0f 85 a5 00 00 00    	jne    108e <rmdot+0x14a>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
     fe9:	be 6e 26 00 00       	mov    $0x266e,%esi
     fee:	bf 01 00 00 00       	mov    $0x1,%edi
     ff3:	b0 00                	mov    $0x0,%al
     ff5:	e8 6b 0b 00 00       	call   1b65 <printf>
}
     ffa:	5d                   	pop    %rbp
     ffb:	c3                   	ret
    printf(1, "mkdir dots failed\n");
     ffc:	be c6 25 00 00       	mov    $0x25c6,%esi
    1001:	bf 01 00 00 00       	mov    $0x1,%edi
    1006:	b0 00                	mov    $0x0,%al
    1008:	e8 58 0b 00 00       	call   1b65 <printf>
    exit();
    100d:	e8 70 09 00 00       	call   1982 <exit>
    printf(1, "chdir dots failed\n");
    1012:	be d9 25 00 00       	mov    $0x25d9,%esi
    1017:	bf 01 00 00 00       	mov    $0x1,%edi
    101c:	b0 00                	mov    $0x0,%al
    101e:	e8 42 0b 00 00       	call   1b65 <printf>
    exit();
    1023:	e8 5a 09 00 00       	call   1982 <exit>
    printf(1, "rm . worked!\n");
    1028:	be ec 25 00 00       	mov    $0x25ec,%esi
    102d:	bf 01 00 00 00       	mov    $0x1,%edi
    1032:	e8 2e 0b 00 00       	call   1b65 <printf>
    exit();
    1037:	e8 46 09 00 00       	call   1982 <exit>
    printf(1, "rm .. worked!\n");
    103c:	be fa 25 00 00       	mov    $0x25fa,%esi
    1041:	bf 01 00 00 00       	mov    $0x1,%edi
    1046:	e8 1a 0b 00 00       	call   1b65 <printf>
    exit();
    104b:	e8 32 09 00 00       	call   1982 <exit>
    printf(1, "chdir / failed\n");
    1050:	be 0b 26 00 00       	mov    $0x260b,%esi
    1055:	bf 01 00 00 00       	mov    $0x1,%edi
    105a:	b0 00                	mov    $0x0,%al
    105c:	e8 04 0b 00 00       	call   1b65 <printf>
    exit();
    1061:	e8 1c 09 00 00       	call   1982 <exit>
    printf(1, "unlink dots/. worked!\n");
    1066:	be 22 26 00 00       	mov    $0x2622,%esi
    106b:	bf 01 00 00 00       	mov    $0x1,%edi
    1070:	e8 f0 0a 00 00       	call   1b65 <printf>
    exit();
    1075:	e8 08 09 00 00       	call   1982 <exit>
    printf(1, "unlink dots/.. worked!\n");
    107a:	be 41 26 00 00       	mov    $0x2641,%esi
    107f:	bf 01 00 00 00       	mov    $0x1,%edi
    1084:	e8 dc 0a 00 00       	call   1b65 <printf>
    exit();
    1089:	e8 f4 08 00 00       	call   1982 <exit>
    printf(1, "unlink dots failed!\n");
    108e:	be 59 26 00 00       	mov    $0x2659,%esi
    1093:	bf 01 00 00 00       	mov    $0x1,%edi
    1098:	b0 00                	mov    $0x0,%al
    109a:	e8 c6 0a 00 00       	call   1b65 <printf>
    exit();
    109f:	e8 de 08 00 00       	call   1982 <exit>

00000000000010a4 <dirfile>:

void
dirfile(void)
{
    10a4:	55                   	push   %rbp
    10a5:	48 89 e5             	mov    %rsp,%rbp
    10a8:	53                   	push   %rbx
    10a9:	48 83 ec 08          	sub    $0x8,%rsp
  int fd;

  printf(1, "dir vs file\n");
    10ad:	be 78 26 00 00       	mov    $0x2678,%esi
    10b2:	bf 01 00 00 00       	mov    $0x1,%edi
    10b7:	b0 00                	mov    $0x0,%al
    10b9:	e8 a7 0a 00 00       	call   1b65 <printf>

  fd = open("dirfile", O_CREATE);
    10be:	be 00 02 00 00       	mov    $0x200,%esi
    10c3:	bf 85 26 00 00       	mov    $0x2685,%edi
    10c8:	e8 05 09 00 00       	call   19d2 <open>
  if(fd < 0){
    10cd:	85 c0                	test   %eax,%eax
    10cf:	0f 88 f4 00 00 00    	js     11c9 <dirfile+0x125>
    10d5:	89 c7                	mov    %eax,%edi
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
    10d7:	e8 d8 08 00 00       	call   19b4 <close>
  if(chdir("dirfile") == 0){
    10dc:	bf 85 26 00 00       	mov    $0x2685,%edi
    10e1:	e8 28 09 00 00       	call   1a0e <chdir>
    10e6:	85 c0                	test   %eax,%eax
    10e8:	0f 84 f1 00 00 00    	je     11df <dirfile+0x13b>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    10ee:	be 00 00 00 00       	mov    $0x0,%esi
    10f3:	bf be 26 00 00       	mov    $0x26be,%edi
    10f8:	e8 d5 08 00 00       	call   19d2 <open>
  if(fd >= 0){
    10fd:	85 c0                	test   %eax,%eax
    10ff:	0f 89 ee 00 00 00    	jns    11f3 <dirfile+0x14f>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    1105:	be 00 02 00 00       	mov    $0x200,%esi
    110a:	bf be 26 00 00       	mov    $0x26be,%edi
    110f:	e8 be 08 00 00       	call   19d2 <open>
  if(fd >= 0){
    1114:	85 c0                	test   %eax,%eax
    1116:	0f 89 ed 00 00 00    	jns    1209 <dirfile+0x165>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    111c:	bf be 26 00 00       	mov    $0x26be,%edi
    1121:	e8 de 08 00 00       	call   1a04 <mkdir>
    1126:	85 c0                	test   %eax,%eax
    1128:	0f 84 f1 00 00 00    	je     121f <dirfile+0x17b>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    112e:	bf be 26 00 00       	mov    $0x26be,%edi
    1133:	e8 ae 08 00 00       	call   19e6 <unlink>
    1138:	85 c0                	test   %eax,%eax
    113a:	0f 84 f3 00 00 00    	je     1233 <dirfile+0x18f>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    1140:	be be 26 00 00       	mov    $0x26be,%esi
    1145:	bf 22 27 00 00       	mov    $0x2722,%edi
    114a:	e8 ab 08 00 00       	call   19fa <link>
    114f:	85 c0                	test   %eax,%eax
    1151:	0f 84 f0 00 00 00    	je     1247 <dirfile+0x1a3>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    1157:	bf 85 26 00 00       	mov    $0x2685,%edi
    115c:	e8 85 08 00 00       	call   19e6 <unlink>
    1161:	85 c0                	test   %eax,%eax
    1163:	0f 85 f2 00 00 00    	jne    125b <dirfile+0x1b7>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    1169:	be 02 00 00 00       	mov    $0x2,%esi
    116e:	bf bb 22 00 00       	mov    $0x22bb,%edi
    1173:	e8 5a 08 00 00       	call   19d2 <open>
  if(fd >= 0){
    1178:	85 c0                	test   %eax,%eax
    117a:	0f 89 f1 00 00 00    	jns    1271 <dirfile+0x1cd>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    1180:	be 00 00 00 00       	mov    $0x0,%esi
    1185:	bf bb 22 00 00       	mov    $0x22bb,%edi
    118a:	e8 43 08 00 00       	call   19d2 <open>
    118f:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    1191:	ba 01 00 00 00       	mov    $0x1,%edx
    1196:	be 9e 23 00 00       	mov    $0x239e,%esi
    119b:	89 c7                	mov    %eax,%edi
    119d:	e8 08 08 00 00       	call   19aa <write>
    11a2:	85 c0                	test   %eax,%eax
    11a4:	0f 8f dd 00 00 00    	jg     1287 <dirfile+0x1e3>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
    11aa:	89 df                	mov    %ebx,%edi
    11ac:	e8 03 08 00 00       	call   19b4 <close>

  printf(1, "dir vs file OK\n");
    11b1:	be 55 27 00 00       	mov    $0x2755,%esi
    11b6:	bf 01 00 00 00       	mov    $0x1,%edi
    11bb:	b0 00                	mov    $0x0,%al
    11bd:	e8 a3 09 00 00       	call   1b65 <printf>
}
    11c2:	48 83 c4 08          	add    $0x8,%rsp
    11c6:	5b                   	pop    %rbx
    11c7:	5d                   	pop    %rbp
    11c8:	c3                   	ret
    printf(1, "create dirfile failed\n");
    11c9:	be 8d 26 00 00       	mov    $0x268d,%esi
    11ce:	bf 01 00 00 00       	mov    $0x1,%edi
    11d3:	b0 00                	mov    $0x0,%al
    11d5:	e8 8b 09 00 00       	call   1b65 <printf>
    exit();
    11da:	e8 a3 07 00 00       	call   1982 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    11df:	be a4 26 00 00       	mov    $0x26a4,%esi
    11e4:	bf 01 00 00 00       	mov    $0x1,%edi
    11e9:	e8 77 09 00 00       	call   1b65 <printf>
    exit();
    11ee:	e8 8f 07 00 00       	call   1982 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    11f3:	be c9 26 00 00       	mov    $0x26c9,%esi
    11f8:	bf 01 00 00 00       	mov    $0x1,%edi
    11fd:	b0 00                	mov    $0x0,%al
    11ff:	e8 61 09 00 00       	call   1b65 <printf>
    exit();
    1204:	e8 79 07 00 00       	call   1982 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    1209:	be c9 26 00 00       	mov    $0x26c9,%esi
    120e:	bf 01 00 00 00       	mov    $0x1,%edi
    1213:	b0 00                	mov    $0x0,%al
    1215:	e8 4b 09 00 00       	call   1b65 <printf>
    exit();
    121a:	e8 63 07 00 00       	call   1982 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    121f:	be e7 26 00 00       	mov    $0x26e7,%esi
    1224:	bf 01 00 00 00       	mov    $0x1,%edi
    1229:	e8 37 09 00 00       	call   1b65 <printf>
    exit();
    122e:	e8 4f 07 00 00       	call   1982 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    1233:	be 04 27 00 00       	mov    $0x2704,%esi
    1238:	bf 01 00 00 00       	mov    $0x1,%edi
    123d:	e8 23 09 00 00       	call   1b65 <printf>
    exit();
    1242:	e8 3b 07 00 00       	call   1982 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    1247:	be f8 2b 00 00       	mov    $0x2bf8,%esi
    124c:	bf 01 00 00 00       	mov    $0x1,%edi
    1251:	e8 0f 09 00 00       	call   1b65 <printf>
    exit();
    1256:	e8 27 07 00 00       	call   1982 <exit>
    printf(1, "unlink dirfile failed!\n");
    125b:	be 29 27 00 00       	mov    $0x2729,%esi
    1260:	bf 01 00 00 00       	mov    $0x1,%edi
    1265:	b0 00                	mov    $0x0,%al
    1267:	e8 f9 08 00 00       	call   1b65 <printf>
    exit();
    126c:	e8 11 07 00 00       	call   1982 <exit>
    printf(1, "open . for writing succeeded!\n");
    1271:	be 18 2c 00 00       	mov    $0x2c18,%esi
    1276:	bf 01 00 00 00       	mov    $0x1,%edi
    127b:	b0 00                	mov    $0x0,%al
    127d:	e8 e3 08 00 00       	call   1b65 <printf>
    exit();
    1282:	e8 fb 06 00 00       	call   1982 <exit>
    printf(1, "write . succeeded!\n");
    1287:	be 41 27 00 00       	mov    $0x2741,%esi
    128c:	bf 01 00 00 00       	mov    $0x1,%edi
    1291:	b0 00                	mov    $0x0,%al
    1293:	e8 cd 08 00 00       	call   1b65 <printf>
    exit();
    1298:	e8 e5 06 00 00       	call   1982 <exit>

000000000000129d <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    129d:	55                   	push   %rbp
    129e:	48 89 e5             	mov    %rsp,%rbp
    12a1:	53                   	push   %rbx
    12a2:	48 83 ec 08          	sub    $0x8,%rsp
  int i, fd;

  printf(1, "empty file name\n");
    12a6:	be 65 27 00 00       	mov    $0x2765,%esi
    12ab:	bf 01 00 00 00       	mov    $0x1,%edi
    12b0:	b0 00                	mov    $0x0,%al
    12b2:	e8 ae 08 00 00       	call   1b65 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    12b7:	bb 00 00 00 00       	mov    $0x0,%ebx
    12bc:	eb 42                	jmp    1300 <iref+0x63>
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    12be:	be 7c 27 00 00       	mov    $0x277c,%esi
    12c3:	bf 01 00 00 00       	mov    $0x1,%edi
    12c8:	b0 00                	mov    $0x0,%al
    12ca:	e8 96 08 00 00       	call   1b65 <printf>
      exit();
    12cf:	e8 ae 06 00 00       	call   1982 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    12d4:	be 90 27 00 00       	mov    $0x2790,%esi
    12d9:	bf 01 00 00 00       	mov    $0x1,%edi
    12de:	b0 00                	mov    $0x0,%al
    12e0:	e8 80 08 00 00       	call   1b65 <printf>
      exit();
    12e5:	e8 98 06 00 00       	call   1982 <exit>

    mkdir("");
    link("README", "");
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    12ea:	89 c7                	mov    %eax,%edi
    12ec:	e8 c3 06 00 00       	call   19b4 <close>
    12f1:	eb 5a                	jmp    134d <iref+0xb0>
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    12f3:	bf 9d 23 00 00       	mov    $0x239d,%edi
    12f8:	e8 e9 06 00 00       	call   19e6 <unlink>
  for(i = 0; i < 50 + 1; i++){
    12fd:	83 c3 01             	add    $0x1,%ebx
    1300:	83 fb 32             	cmp    $0x32,%ebx
    1303:	7f 64                	jg     1369 <iref+0xcc>
    if(mkdir("irefd") != 0){
    1305:	bf 76 27 00 00       	mov    $0x2776,%edi
    130a:	e8 f5 06 00 00       	call   1a04 <mkdir>
    130f:	85 c0                	test   %eax,%eax
    1311:	75 ab                	jne    12be <iref+0x21>
    if(chdir("irefd") != 0){
    1313:	bf 76 27 00 00       	mov    $0x2776,%edi
    1318:	e8 f1 06 00 00       	call   1a0e <chdir>
    131d:	85 c0                	test   %eax,%eax
    131f:	75 b3                	jne    12d4 <iref+0x37>
    mkdir("");
    1321:	bf 54 27 00 00       	mov    $0x2754,%edi
    1326:	e8 d9 06 00 00       	call   1a04 <mkdir>
    link("README", "");
    132b:	be 54 27 00 00       	mov    $0x2754,%esi
    1330:	bf 22 27 00 00       	mov    $0x2722,%edi
    1335:	e8 c0 06 00 00       	call   19fa <link>
    fd = open("", O_CREATE);
    133a:	be 00 02 00 00       	mov    $0x200,%esi
    133f:	bf 54 27 00 00       	mov    $0x2754,%edi
    1344:	e8 89 06 00 00       	call   19d2 <open>
    if(fd >= 0)
    1349:	85 c0                	test   %eax,%eax
    134b:	79 9d                	jns    12ea <iref+0x4d>
    fd = open("xx", O_CREATE);
    134d:	be 00 02 00 00       	mov    $0x200,%esi
    1352:	bf 9d 23 00 00       	mov    $0x239d,%edi
    1357:	e8 76 06 00 00       	call   19d2 <open>
    if(fd >= 0)
    135c:	85 c0                	test   %eax,%eax
    135e:	78 93                	js     12f3 <iref+0x56>
      close(fd);
    1360:	89 c7                	mov    %eax,%edi
    1362:	e8 4d 06 00 00       	call   19b4 <close>
    1367:	eb 8a                	jmp    12f3 <iref+0x56>
  }

  chdir("/");
    1369:	bf 09 26 00 00       	mov    $0x2609,%edi
    136e:	e8 9b 06 00 00       	call   1a0e <chdir>
  printf(1, "empty file name OK\n");
    1373:	be a4 27 00 00       	mov    $0x27a4,%esi
    1378:	bf 01 00 00 00       	mov    $0x1,%edi
    137d:	b0 00                	mov    $0x0,%al
    137f:	e8 e1 07 00 00       	call   1b65 <printf>
}
    1384:	48 83 c4 08          	add    $0x8,%rsp
    1388:	5b                   	pop    %rbx
    1389:	5d                   	pop    %rbp
    138a:	c3                   	ret

000000000000138b <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    138b:	55                   	push   %rbp
    138c:	48 89 e5             	mov    %rsp,%rbp
    138f:	53                   	push   %rbx
    1390:	48 83 ec 08          	sub    $0x8,%rsp
  int n, pid;

  printf(1, "fork test\n");
    1394:	be b8 27 00 00       	mov    $0x27b8,%esi
    1399:	bf 01 00 00 00       	mov    $0x1,%edi
    139e:	b0 00                	mov    $0x0,%al
    13a0:	e8 c0 07 00 00       	call   1b65 <printf>

  for(n=0; n<1000; n++){
    13a5:	bb 00 00 00 00       	mov    $0x0,%ebx
    13aa:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
    13b0:	7f 15                	jg     13c7 <forktest+0x3c>
    pid = fork();
    13b2:	e8 c1 05 00 00       	call   1978 <fork>
    if(pid < 0)
    13b7:	85 c0                	test   %eax,%eax
    13b9:	78 0c                	js     13c7 <forktest+0x3c>
      break;
    if(pid == 0)
    13bb:	74 05                	je     13c2 <forktest+0x37>
  for(n=0; n<1000; n++){
    13bd:	83 c3 01             	add    $0x1,%ebx
    13c0:	eb e8                	jmp    13aa <forktest+0x1f>
      exit();
    13c2:	e8 bb 05 00 00       	call   1982 <exit>
  }

  if(n == 1000){
    13c7:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    13cd:	74 12                	je     13e1 <forktest+0x56>
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }

  for(; n > 0; n--){
    13cf:	85 db                	test   %ebx,%ebx
    13d1:	7e 3a                	jle    140d <forktest+0x82>
    if(wait() < 0){
    13d3:	e8 b4 05 00 00       	call   198c <wait>
    13d8:	85 c0                	test   %eax,%eax
    13da:	78 1b                	js     13f7 <forktest+0x6c>
  for(; n > 0; n--){
    13dc:	83 eb 01             	sub    $0x1,%ebx
    13df:	eb ee                	jmp    13cf <forktest+0x44>
    printf(1, "fork claimed to work 1000 times!\n");
    13e1:	be 38 2c 00 00       	mov    $0x2c38,%esi
    13e6:	bf 01 00 00 00       	mov    $0x1,%edi
    13eb:	b0 00                	mov    $0x0,%al
    13ed:	e8 73 07 00 00       	call   1b65 <printf>
    exit();
    13f2:	e8 8b 05 00 00       	call   1982 <exit>
      printf(1, "wait stopped early\n");
    13f7:	be c3 27 00 00       	mov    $0x27c3,%esi
    13fc:	bf 01 00 00 00       	mov    $0x1,%edi
    1401:	b0 00                	mov    $0x0,%al
    1403:	e8 5d 07 00 00       	call   1b65 <printf>
      exit();
    1408:	e8 75 05 00 00       	call   1982 <exit>
    }
  }

  if(wait() != -1){
    140d:	e8 7a 05 00 00       	call   198c <wait>
    1412:	83 f8 ff             	cmp    $0xffffffff,%eax
    1415:	75 18                	jne    142f <forktest+0xa4>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
    1417:	be ea 27 00 00       	mov    $0x27ea,%esi
    141c:	bf 01 00 00 00       	mov    $0x1,%edi
    1421:	b0 00                	mov    $0x0,%al
    1423:	e8 3d 07 00 00       	call   1b65 <printf>
}
    1428:	48 83 c4 08          	add    $0x8,%rsp
    142c:	5b                   	pop    %rbx
    142d:	5d                   	pop    %rbp
    142e:	c3                   	ret
    printf(1, "wait got too many\n");
    142f:	be d7 27 00 00       	mov    $0x27d7,%esi
    1434:	bf 01 00 00 00       	mov    $0x1,%edi
    1439:	b0 00                	mov    $0x0,%al
    143b:	e8 25 07 00 00       	call   1b65 <printf>
    exit();
    1440:	e8 3d 05 00 00       	call   1982 <exit>

0000000000001445 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    1445:	55                   	push   %rbp
    1446:	48 89 e5             	mov    %rsp,%rbp
    1449:	41 55                	push   %r13
    144b:	41 54                	push   %r12
    144d:	53                   	push   %rbx
    144e:	48 83 ec 48          	sub    $0x48,%rsp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    1452:	be f8 27 00 00       	mov    $0x27f8,%esi
    1457:	bf 01 00 00 00       	mov    $0x1,%edi
    145c:	b0 00                	mov    $0x0,%al
    145e:	e8 02 07 00 00       	call   1b65 <printf>

  for(nfiles = 0; ; nfiles++){
    1463:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    1468:	c6 45 a0 66          	movb   $0x66,-0x60(%rbp)
    name[1] = '0' + nfiles / 1000;
    146c:	48 63 c3             	movslq %ebx,%rax
    146f:	48 69 d0 d3 4d 62 10 	imul   $0x10624dd3,%rax,%rdx
    1476:	48 c1 fa 26          	sar    $0x26,%rdx
    147a:	89 de                	mov    %ebx,%esi
    147c:	c1 fe 1f             	sar    $0x1f,%esi
    147f:	29 f2                	sub    %esi,%edx
    1481:	8d 4a 30             	lea    0x30(%rdx),%ecx
    1484:	88 4d a1             	mov    %cl,-0x5f(%rbp)
    name[2] = '0' + (nfiles % 1000) / 100;
    1487:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    148d:	89 d9                	mov    %ebx,%ecx
    148f:	29 d1                	sub    %edx,%ecx
    1491:	48 63 d1             	movslq %ecx,%rdx
    1494:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    149b:	48 c1 fa 25          	sar    $0x25,%rdx
    149f:	c1 f9 1f             	sar    $0x1f,%ecx
    14a2:	29 ca                	sub    %ecx,%edx
    14a4:	83 c2 30             	add    $0x30,%edx
    14a7:	88 55 a2             	mov    %dl,-0x5e(%rbp)
    name[3] = '0' + (nfiles % 100) / 10;
    14aa:	48 69 d0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rdx
    14b1:	48 c1 fa 25          	sar    $0x25,%rdx
    14b5:	29 f2                	sub    %esi,%edx
    14b7:	6b ca 64             	imul   $0x64,%edx,%ecx
    14ba:	89 da                	mov    %ebx,%edx
    14bc:	29 ca                	sub    %ecx,%edx
    14be:	48 63 ca             	movslq %edx,%rcx
    14c1:	48 69 c9 67 66 66 66 	imul   $0x66666667,%rcx,%rcx
    14c8:	48 c1 f9 22          	sar    $0x22,%rcx
    14cc:	c1 fa 1f             	sar    $0x1f,%edx
    14cf:	29 d1                	sub    %edx,%ecx
    14d1:	8d 51 30             	lea    0x30(%rcx),%edx
    14d4:	88 55 a3             	mov    %dl,-0x5d(%rbp)
    name[4] = '0' + (nfiles % 10);
    14d7:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    14de:	48 c1 f8 22          	sar    $0x22,%rax
    14e2:	29 f0                	sub    %esi,%eax
    14e4:	8d 14 80             	lea    (%rax,%rax,4),%edx
    14e7:	d1 e2                	shl    $1,%edx
    14e9:	89 d8                	mov    %ebx,%eax
    14eb:	29 d0                	sub    %edx,%eax
    14ed:	83 c0 30             	add    $0x30,%eax
    14f0:	88 45 a4             	mov    %al,-0x5c(%rbp)
    name[5] = '\0';
    14f3:	c6 45 a5 00          	movb   $0x0,-0x5b(%rbp)
    printf(1, "writing %s\n", name);
    14f7:	4c 8d 65 a0          	lea    -0x60(%rbp),%r12
    14fb:	4c 89 e2             	mov    %r12,%rdx
    14fe:	be 05 28 00 00       	mov    $0x2805,%esi
    1503:	bf 01 00 00 00       	mov    $0x1,%edi
    1508:	b0 00                	mov    $0x0,%al
    150a:	e8 56 06 00 00       	call   1b65 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    150f:	be 02 02 00 00       	mov    $0x202,%esi
    1514:	4c 89 e7             	mov    %r12,%rdi
    1517:	e8 b6 04 00 00       	call   19d2 <open>
    151c:	41 89 c4             	mov    %eax,%r12d
    if(fd < 0){
    151f:	85 c0                	test   %eax,%eax
    1521:	79 1a                	jns    153d <fsfull+0xf8>
      printf(1, "open %s failed\n", name);
    1523:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
    1527:	be 11 28 00 00       	mov    $0x2811,%esi
    152c:	bf 01 00 00 00       	mov    $0x1,%edi
    1531:	b0 00                	mov    $0x0,%al
    1533:	e8 2d 06 00 00       	call   1b65 <printf>
      break;
    1538:	e9 ec 00 00 00       	jmp    1629 <fsfull+0x1e4>
    }
    int total = 0;
    153d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    while(1){
      int cc = write(fd, buf, 512);
    1543:	ba 00 02 00 00       	mov    $0x200,%edx
    1548:	be 40 32 00 00       	mov    $0x3240,%esi
    154d:	44 89 e7             	mov    %r12d,%edi
    1550:	e8 55 04 00 00       	call   19aa <write>
      if(cc < 512)
    1555:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    155a:	7e 05                	jle    1561 <fsfull+0x11c>
        break;
      total += cc;
    155c:	41 01 c5             	add    %eax,%r13d
    while(1){
    155f:	eb e2                	jmp    1543 <fsfull+0xfe>
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    1561:	44 89 ea             	mov    %r13d,%edx
    1564:	be 21 28 00 00       	mov    $0x2821,%esi
    1569:	bf 01 00 00 00       	mov    $0x1,%edi
    156e:	b0 00                	mov    $0x0,%al
    1570:	e8 f0 05 00 00       	call   1b65 <printf>
    close(fd);
    1575:	44 89 e7             	mov    %r12d,%edi
    1578:	e8 37 04 00 00       	call   19b4 <close>
    if(total == 0)
    157d:	45 85 ed             	test   %r13d,%r13d
    1580:	0f 84 a3 00 00 00    	je     1629 <fsfull+0x1e4>
  for(nfiles = 0; ; nfiles++){
    1586:	83 c3 01             	add    $0x1,%ebx
    1589:	e9 da fe ff ff       	jmp    1468 <fsfull+0x23>
      break;
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    158e:	c6 45 a0 66          	movb   $0x66,-0x60(%rbp)
    name[1] = '0' + nfiles / 1000;
    1592:	48 63 c3             	movslq %ebx,%rax
    1595:	48 69 d0 d3 4d 62 10 	imul   $0x10624dd3,%rax,%rdx
    159c:	48 c1 fa 26          	sar    $0x26,%rdx
    15a0:	89 de                	mov    %ebx,%esi
    15a2:	c1 fe 1f             	sar    $0x1f,%esi
    15a5:	29 f2                	sub    %esi,%edx
    15a7:	8d 4a 30             	lea    0x30(%rdx),%ecx
    15aa:	88 4d a1             	mov    %cl,-0x5f(%rbp)
    name[2] = '0' + (nfiles % 1000) / 100;
    15ad:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    15b3:	89 d9                	mov    %ebx,%ecx
    15b5:	29 d1                	sub    %edx,%ecx
    15b7:	48 63 d1             	movslq %ecx,%rdx
    15ba:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    15c1:	48 c1 fa 25          	sar    $0x25,%rdx
    15c5:	c1 f9 1f             	sar    $0x1f,%ecx
    15c8:	29 ca                	sub    %ecx,%edx
    15ca:	83 c2 30             	add    $0x30,%edx
    15cd:	88 55 a2             	mov    %dl,-0x5e(%rbp)
    name[3] = '0' + (nfiles % 100) / 10;
    15d0:	48 69 d0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rdx
    15d7:	48 c1 fa 25          	sar    $0x25,%rdx
    15db:	29 f2                	sub    %esi,%edx
    15dd:	6b ca 64             	imul   $0x64,%edx,%ecx
    15e0:	89 da                	mov    %ebx,%edx
    15e2:	29 ca                	sub    %ecx,%edx
    15e4:	48 63 ca             	movslq %edx,%rcx
    15e7:	48 69 c9 67 66 66 66 	imul   $0x66666667,%rcx,%rcx
    15ee:	48 c1 f9 22          	sar    $0x22,%rcx
    15f2:	c1 fa 1f             	sar    $0x1f,%edx
    15f5:	29 d1                	sub    %edx,%ecx
    15f7:	8d 51 30             	lea    0x30(%rcx),%edx
    15fa:	88 55 a3             	mov    %dl,-0x5d(%rbp)
    name[4] = '0' + (nfiles % 10);
    15fd:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    1604:	48 c1 f8 22          	sar    $0x22,%rax
    1608:	29 f0                	sub    %esi,%eax
    160a:	8d 14 80             	lea    (%rax,%rax,4),%edx
    160d:	d1 e2                	shl    $1,%edx
    160f:	89 d8                	mov    %ebx,%eax
    1611:	29 d0                	sub    %edx,%eax
    1613:	83 c0 30             	add    $0x30,%eax
    1616:	88 45 a4             	mov    %al,-0x5c(%rbp)
    name[5] = '\0';
    1619:	c6 45 a5 00          	movb   $0x0,-0x5b(%rbp)
    unlink(name);
    161d:	48 8d 7d a0          	lea    -0x60(%rbp),%rdi
    1621:	e8 c0 03 00 00       	call   19e6 <unlink>
    nfiles--;
    1626:	83 eb 01             	sub    $0x1,%ebx
  while(nfiles >= 0){
    1629:	85 db                	test   %ebx,%ebx
    162b:	0f 89 5d ff ff ff    	jns    158e <fsfull+0x149>
  }

  printf(1, "fsfull test finished\n");
    1631:	be 31 28 00 00       	mov    $0x2831,%esi
    1636:	bf 01 00 00 00       	mov    $0x1,%edi
    163b:	b0 00                	mov    $0x0,%al
    163d:	e8 23 05 00 00       	call   1b65 <printf>
}
    1642:	48 83 c4 48          	add    $0x48,%rsp
    1646:	5b                   	pop    %rbx
    1647:	41 5c                	pop    %r12
    1649:	41 5d                	pop    %r13
    164b:	5d                   	pop    %rbp
    164c:	c3                   	ret

000000000000164d <uio>:

void
uio()
{
    164d:	55                   	push   %rbp
    164e:	48 89 e5             	mov    %rsp,%rbp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    1651:	be 47 28 00 00       	mov    $0x2847,%esi
    1656:	bf 01 00 00 00       	mov    $0x1,%edi
    165b:	b0 00                	mov    $0x0,%al
    165d:	e8 03 05 00 00       	call   1b65 <printf>
  pid = fork();
    1662:	e8 11 03 00 00       	call   1978 <fork>
  if(pid == 0){
    1667:	85 c0                	test   %eax,%eax
    1669:	74 1a                	je     1685 <uio+0x38>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit();
  } else if(pid < 0){
    166b:	78 3c                	js     16a9 <uio+0x5c>
    printf (1, "fork failed\n");
    exit();
  }
  wait();
    166d:	e8 1a 03 00 00       	call   198c <wait>
  printf(1, "uio test done\n");
    1672:	be 5e 28 00 00       	mov    $0x285e,%esi
    1677:	bf 01 00 00 00       	mov    $0x1,%edi
    167c:	b0 00                	mov    $0x0,%al
    167e:	e8 e2 04 00 00       	call   1b65 <printf>
}
    1683:	5d                   	pop    %rbp
    1684:	c3                   	ret
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    1685:	b0 09                	mov    $0x9,%al
    1687:	ba 70 00 00 00       	mov    $0x70,%edx
    168c:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    168d:	ba 71 00 00 00       	mov    $0x71,%edx
    1692:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    1693:	be 60 2c 00 00       	mov    $0x2c60,%esi
    1698:	bf 01 00 00 00       	mov    $0x1,%edi
    169d:	b0 00                	mov    $0x0,%al
    169f:	e8 c1 04 00 00       	call   1b65 <printf>
    exit();
    16a4:	e8 d9 02 00 00       	call   1982 <exit>
    printf (1, "fork failed\n");
    16a9:	be 51 28 00 00       	mov    $0x2851,%esi
    16ae:	bf 01 00 00 00       	mov    $0x1,%edi
    16b3:	b0 00                	mov    $0x0,%al
    16b5:	e8 ab 04 00 00       	call   1b65 <printf>
    exit();
    16ba:	e8 c3 02 00 00       	call   1982 <exit>

00000000000016bf <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
    16bf:	48 69 05 f6 1a 00 00 	imul   $0x19660d,0x1af6(%rip),%rax        # 31c0 <randstate>
    16c6:	0d 66 19 00 
    16ca:	48 05 5f f3 6e 3c    	add    $0x3c6ef35f,%rax
    16d0:	48 89 05 e9 1a 00 00 	mov    %rax,0x1ae9(%rip)        # 31c0 <randstate>
  return randstate;
}
    16d7:	c3                   	ret

00000000000016d8 <main>:

int
main(int argc, char *argv[])
{
    16d8:	55                   	push   %rbp
    16d9:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "usertests 2 starting\n");
    16dc:	be 6d 28 00 00       	mov    $0x286d,%esi
    16e1:	bf 01 00 00 00       	mov    $0x1,%edi
    16e6:	b0 00                	mov    $0x0,%al
    16e8:	e8 78 04 00 00       	call   1b65 <printf>

  if(open("usertests2.ran", 0) >= 0){
    16ed:	be 00 00 00 00       	mov    $0x0,%esi
    16f2:	bf 83 28 00 00       	mov    $0x2883,%edi
    16f7:	e8 d6 02 00 00       	call   19d2 <open>
    16fc:	85 c0                	test   %eax,%eax
    16fe:	78 16                	js     1716 <main+0x3e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    1700:	be 88 2c 00 00       	mov    $0x2c88,%esi
    1705:	bf 01 00 00 00       	mov    $0x1,%edi
    170a:	b0 00                	mov    $0x0,%al
    170c:	e8 54 04 00 00       	call   1b65 <printf>
    exit();
    1711:	e8 6c 02 00 00       	call   1982 <exit>
  }
  close(open("usertests2.ran", O_CREATE));
    1716:	be 00 02 00 00       	mov    $0x200,%esi
    171b:	bf 83 28 00 00       	mov    $0x2883,%edi
    1720:	e8 ad 02 00 00       	call   19d2 <open>
    1725:	89 c7                	mov    %eax,%edi
    1727:	e8 88 02 00 00       	call   19b4 <close>

  rmdot();
    172c:	e8 13 f8 ff ff       	call   f44 <rmdot>
  fourteen();
    1731:	e8 fa f6 ff ff       	call   e30 <fourteen>
  bigfile();
    1736:	e8 3a f5 ff ff       	call   c75 <bigfile>
  subdir();
    173b:	e8 96 ee ff ff       	call   5d6 <subdir>
  linktest();
    1740:	e8 49 eb ff ff       	call   28e <linktest>
  unlinkread();
    1745:	e8 b6 e9 ff ff       	call   100 <unlinkread>
  dirfile();
    174a:	e8 55 f9 ff ff       	call   10a4 <dirfile>
  iref();
    174f:	e8 49 fb ff ff       	call   129d <iref>
  forktest();
    1754:	e8 32 fc ff ff       	call   138b <forktest>
  bigdir(); // slow
    1759:	e8 35 ed ff ff       	call   493 <bigdir>

  uio();
    175e:	b0 00                	mov    $0x0,%al
    1760:	e8 e8 fe ff ff       	call   164d <uio>

  exectest();
    1765:	e8 54 e9 ff ff       	call   be <exectest>

  exit();
    176a:	e8 13 02 00 00       	call   1982 <exit>
    176f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    1776:	00 00 00 
    1779:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001780 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1780:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1783:	48 89 f9             	mov    %rdi,%rcx
    1786:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    178d:	00 00 00 00 
    1791:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1798:	00 00 00 00 
    179c:	0f 1f 40 00          	nopl   0x0(%rax)
    17a0:	48 89 f2             	mov    %rsi,%rdx
    17a3:	48 83 c6 01          	add    $0x1,%rsi
    17a7:	49 89 c8             	mov    %rcx,%r8
    17aa:	48 83 c1 01          	add    $0x1,%rcx
    17ae:	8a 12                	mov    (%rdx),%dl
    17b0:	41 88 10             	mov    %dl,(%r8)
    17b3:	0f be d2             	movsbl %dl,%edx
    17b6:	85 d2                	test   %edx,%edx
    17b8:	75 e6                	jne    17a0 <strcpy+0x20>
    ;
  return os;
}
    17ba:	c3                   	ret

00000000000017bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    17bb:	eb 0b                	jmp    17c8 <strcmp+0xd>
    17bd:	0f 1f 00             	nopl   (%rax)
    p++, q++;
    17c0:	48 83 c7 01          	add    $0x1,%rdi
    17c4:	48 83 c6 01          	add    $0x1,%rsi
  while(*p && *p == *q)
    17c8:	8a 07                	mov    (%rdi),%al
    17ca:	0f be d0             	movsbl %al,%edx
    17cd:	85 d2                	test   %edx,%edx
    17cf:	74 07                	je     17d8 <strcmp+0x1d>
    17d1:	0f be 0e             	movsbl (%rsi),%ecx
    17d4:	39 ca                	cmp    %ecx,%edx
    17d6:	74 e8                	je     17c0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    17d8:	0f b6 c0             	movzbl %al,%eax
    17db:	0f b6 16             	movzbl (%rsi),%edx
    17de:	29 d0                	sub    %edx,%eax
}
    17e0:	c3                   	ret

00000000000017e1 <strlen>:
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    17e1:	b8 00 00 00 00       	mov    $0x0,%eax
    17e6:	eb 0b                	jmp    17f3 <strlen+0x12>
    17e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    17ef:	00 
    17f0:	83 c0 01             	add    $0x1,%eax
    17f3:	48 63 d0             	movslq %eax,%rdx
    17f6:	0f be 14 17          	movsbl (%rdi,%rdx,1),%edx
    17fa:	85 d2                	test   %edx,%edx
    17fc:	75 f2                	jne    17f0 <strlen+0xf>
    ;
  return n;
}
    17fe:	c3                   	ret

00000000000017ff <memset>:

void*
memset(void *dst, int c, uint n)
{
    17ff:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
    asm volatile("cld; rep stosb" :
    1802:	89 d1                	mov    %edx,%ecx
    1804:	89 f0                	mov    %esi,%eax
    1806:	fc                   	cld
    1807:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
    1809:	4c 89 c0             	mov    %r8,%rax
    180c:	c3                   	ret

000000000000180d <strchr>:

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    180d:	eb 15                	jmp    1824 <strchr+0x17>
    180f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1816:	00 00 00 00 
    181a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1820:	48 83 c7 01          	add    $0x1,%rdi
    1824:	8a 17                	mov    (%rdi),%dl
    1826:	0f be c2             	movsbl %dl,%eax
    1829:	85 c0                	test   %eax,%eax
    182b:	74 0f                	je     183c <strchr+0x2f>
    if(*s == c)
    182d:	0f be d2             	movsbl %dl,%edx
    1830:	40 0f be c6          	movsbl %sil,%eax
    1834:	39 c2                	cmp    %eax,%edx
    1836:	75 e8                	jne    1820 <strchr+0x13>
      return (char*)s;
    1838:	48 89 f8             	mov    %rdi,%rax
  return 0;
}
    183b:	c3                   	ret
  return 0;
    183c:	b8 00 00 00 00       	mov    $0x0,%eax
    1841:	c3                   	ret

0000000000001842 <gets>:

char*
gets(char *buf, int max)
{
    1842:	55                   	push   %rbp
    1843:	48 89 e5             	mov    %rsp,%rbp
    1846:	41 56                	push   %r14
    1848:	41 55                	push   %r13
    184a:	41 54                	push   %r12
    184c:	53                   	push   %rbx
    184d:	48 83 ec 10          	sub    $0x10,%rsp
    1851:	49 89 fc             	mov    %rdi,%r12
    1854:	41 89 f5             	mov    %esi,%r13d
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1857:	bb 00 00 00 00       	mov    $0x0,%ebx
    185c:	41 89 de             	mov    %ebx,%r14d
    185f:	83 c3 01             	add    $0x1,%ebx
    1862:	44 39 eb             	cmp    %r13d,%ebx
    1865:	7d 39                	jge    18a0 <gets+0x5e>
    cc = read(0, &c, 1);
    1867:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
    186b:	ba 01 00 00 00       	mov    $0x1,%edx
    1870:	bf 00 00 00 00       	mov    $0x0,%edi
    1875:	e8 26 01 00 00       	call   19a0 <read>
    if(cc < 1)
    187a:	85 c0                	test   %eax,%eax
    187c:	7e 22                	jle    18a0 <gets+0x5e>
      break;
    buf[i++] = c;
    187e:	4d 63 f6             	movslq %r14d,%r14
    1881:	8a 45 df             	mov    -0x21(%rbp),%al
    1884:	43 88 04 34          	mov    %al,(%r12,%r14,1)
    if(c == '\n' || c == '\r')
    1888:	0f be c0             	movsbl %al,%eax
    188b:	83 f8 0a             	cmp    $0xa,%eax
    188e:	0f 94 c2             	sete   %dl
    1891:	83 f8 0d             	cmp    $0xd,%eax
    1894:	0f 94 c0             	sete   %al
    1897:	09 d0                	or     %edx,%eax
    1899:	a8 ff                	test   $0xff,%al
    189b:	74 bf                	je     185c <gets+0x1a>
    buf[i++] = c;
    189d:	41 89 de             	mov    %ebx,%r14d
      break;
  }
  buf[i] = '\0';
    18a0:	4d 63 f6             	movslq %r14d,%r14
    18a3:	43 c6 04 34 00       	movb   $0x0,(%r12,%r14,1)
  return buf;
}
    18a8:	4c 89 e0             	mov    %r12,%rax
    18ab:	48 83 c4 10          	add    $0x10,%rsp
    18af:	5b                   	pop    %rbx
    18b0:	41 5c                	pop    %r12
    18b2:	41 5d                	pop    %r13
    18b4:	41 5e                	pop    %r14
    18b6:	5d                   	pop    %rbp
    18b7:	c3                   	ret

00000000000018b8 <stat>:

int
stat(const char *n, struct stat *st)
{
    18b8:	55                   	push   %rbp
    18b9:	48 89 e5             	mov    %rsp,%rbp
    18bc:	41 54                	push   %r12
    18be:	53                   	push   %rbx
    18bf:	49 89 f4             	mov    %rsi,%r12
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    18c2:	be 00 00 00 00       	mov    $0x0,%esi
    18c7:	e8 06 01 00 00       	call   19d2 <open>
  if(fd < 0)
    18cc:	85 c0                	test   %eax,%eax
    18ce:	78 1e                	js     18ee <stat+0x36>
    18d0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    18d2:	4c 89 e6             	mov    %r12,%rsi
    18d5:	89 c7                	mov    %eax,%edi
    18d7:	e8 14 01 00 00       	call   19f0 <fstat>
    18dc:	41 89 c4             	mov    %eax,%r12d
  close(fd);
    18df:	89 df                	mov    %ebx,%edi
    18e1:	e8 ce 00 00 00       	call   19b4 <close>
  return r;
}
    18e6:	44 89 e0             	mov    %r12d,%eax
    18e9:	5b                   	pop    %rbx
    18ea:	41 5c                	pop    %r12
    18ec:	5d                   	pop    %rbp
    18ed:	c3                   	ret
    return -1;
    18ee:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
    18f4:	eb f0                	jmp    18e6 <stat+0x2e>

00000000000018f6 <atoi>:
atoi(const char *s)
{
  int n, sign;

  n = 0;
  sign = 1;
    18f6:	be 01 00 00 00       	mov    $0x1,%esi
  while (*s == '-') {
    18fb:	eb 09                	jmp    1906 <atoi+0x10>
    18fd:	0f 1f 00             	nopl   (%rax)
    sign = -sign;
    1900:	f7 de                	neg    %esi
    s++;
    1902:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == '-') {
    1906:	0f be 07             	movsbl (%rdi),%eax
    1909:	83 f8 2d             	cmp    $0x2d,%eax
    190c:	74 f2                	je     1900 <atoi+0xa>
  n = 0;
    190e:	b8 00 00 00 00       	mov    $0x0,%eax
    1913:	eb 19                	jmp    192e <atoi+0x38>
    1915:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    191c:	00 00 00 00 
  }
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
    1920:	8d 04 80             	lea    (%rax,%rax,4),%eax
    1923:	48 83 c7 01          	add    $0x1,%rdi
    1927:	0f be d2             	movsbl %dl,%edx
    192a:	8d 44 42 d0          	lea    -0x30(%rdx,%rax,2),%eax
  while('0' <= *s && *s <= '9')
    192e:	8a 17                	mov    (%rdi),%dl
    1930:	8d 4a d0             	lea    -0x30(%rdx),%ecx
    1933:	0f b6 c9             	movzbl %cl,%ecx
    1936:	83 f9 09             	cmp    $0x9,%ecx
    1939:	76 e5                	jbe    1920 <atoi+0x2a>
  return sign * n;
    193b:	0f af c6             	imul   %esi,%eax
}
    193e:	c3                   	ret

000000000000193f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    193f:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;

  dst = vdst;
    1942:	48 89 f9             	mov    %rdi,%rcx
  src = vsrc;
  while(n-- > 0)
    1945:	eb 28                	jmp    196f <memmove+0x30>
    1947:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    194e:	00 00 00 00 
    1952:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1959:	00 00 00 00 
    195d:	0f 1f 00             	nopl   (%rax)
    *dst++ = *src++;
    1960:	8a 16                	mov    (%rsi),%dl
    1962:	88 11                	mov    %dl,(%rcx)
    1964:	48 8d 76 01          	lea    0x1(%rsi),%rsi
    1968:	48 8d 49 01          	lea    0x1(%rcx),%rcx
  while(n-- > 0)
    196c:	44 89 c2             	mov    %r8d,%edx
    196f:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
    1973:	85 d2                	test   %edx,%edx
    1975:	7f e9                	jg     1960 <memmove+0x21>
  return vdst;
}
    1977:	c3                   	ret

0000000000001978 <fork>:
  name: \
    movq $SYS_ ## name, %rax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1978:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    197f:	cd 40                	int    $0x40
    1981:	c3                   	ret

0000000000001982 <exit>:
SYSCALL(exit)
    1982:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1989:	cd 40                	int    $0x40
    198b:	c3                   	ret

000000000000198c <wait>:
SYSCALL(wait)
    198c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1993:	cd 40                	int    $0x40
    1995:	c3                   	ret

0000000000001996 <pipe>:
SYSCALL(pipe)
    1996:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    199d:	cd 40                	int    $0x40
    199f:	c3                   	ret

00000000000019a0 <read>:
SYSCALL(read)
    19a0:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    19a7:	cd 40                	int    $0x40
    19a9:	c3                   	ret

00000000000019aa <write>:
SYSCALL(write)
    19aa:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    19b1:	cd 40                	int    $0x40
    19b3:	c3                   	ret

00000000000019b4 <close>:
SYSCALL(close)
    19b4:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    19bb:	cd 40                	int    $0x40
    19bd:	c3                   	ret

00000000000019be <kill>:
SYSCALL(kill)
    19be:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    19c5:	cd 40                	int    $0x40
    19c7:	c3                   	ret

00000000000019c8 <exec>:
SYSCALL(exec)
    19c8:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    19cf:	cd 40                	int    $0x40
    19d1:	c3                   	ret

00000000000019d2 <open>:
SYSCALL(open)
    19d2:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    19d9:	cd 40                	int    $0x40
    19db:	c3                   	ret

00000000000019dc <mknod>:
SYSCALL(mknod)
    19dc:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    19e3:	cd 40                	int    $0x40
    19e5:	c3                   	ret

00000000000019e6 <unlink>:
SYSCALL(unlink)
    19e6:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    19ed:	cd 40                	int    $0x40
    19ef:	c3                   	ret

00000000000019f0 <fstat>:
SYSCALL(fstat)
    19f0:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    19f7:	cd 40                	int    $0x40
    19f9:	c3                   	ret

00000000000019fa <link>:
SYSCALL(link)
    19fa:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1a01:	cd 40                	int    $0x40
    1a03:	c3                   	ret

0000000000001a04 <mkdir>:
SYSCALL(mkdir)
    1a04:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1a0b:	cd 40                	int    $0x40
    1a0d:	c3                   	ret

0000000000001a0e <chdir>:
SYSCALL(chdir)
    1a0e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1a15:	cd 40                	int    $0x40
    1a17:	c3                   	ret

0000000000001a18 <dup>:
SYSCALL(dup)
    1a18:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1a1f:	cd 40                	int    $0x40
    1a21:	c3                   	ret

0000000000001a22 <getpid>:
SYSCALL(getpid)
    1a22:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1a29:	cd 40                	int    $0x40
    1a2b:	c3                   	ret

0000000000001a2c <sbrk>:
SYSCALL(sbrk)
    1a2c:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1a33:	cd 40                	int    $0x40
    1a35:	c3                   	ret

0000000000001a36 <sleep>:
SYSCALL(sleep)
    1a36:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1a3d:	cd 40                	int    $0x40
    1a3f:	c3                   	ret

0000000000001a40 <uptime>:
SYSCALL(uptime)
    1a40:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1a47:	cd 40                	int    $0x40
    1a49:	c3                   	ret

0000000000001a4a <vmcreate>:
SYSCALL(vmcreate)
    1a4a:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1a51:	cd 40                	int    $0x40
    1a53:	c3                   	ret

0000000000001a54 <vmsetreg>:
SYSCALL(vmsetreg)
    1a54:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    1a5b:	cd 40                	int    $0x40
    1a5d:	c3                   	ret

0000000000001a5e <vmrun>:
SYSCALL(vmrun)
    1a5e:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    1a65:	cd 40                	int    $0x40
    1a67:	c3                   	ret

0000000000001a68 <vmgetreg>:
SYSCALL(vmgetreg)
    1a68:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    1a6f:	cd 40                	int    $0x40
    1a71:	c3                   	ret
    1a72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    1a79:	00 00 00 
    1a7c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001a80 <_va_arg>:
// Retrieve the next argument from the va_list.
static inline void *_va_arg(va_list *args)
{
    // Returns the next argument from registers if _index < 6, 
    // otherwise from the stack.
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
    1a80:	8b 47 38             	mov    0x38(%rdi),%eax
    1a83:	83 f8 05             	cmp    $0x5,%eax
    1a86:	77 0d                	ja     1a95 <_va_arg+0x15>
    1a88:	8d 50 01             	lea    0x1(%rax),%edx
    1a8b:	89 57 38             	mov    %edx,0x38(%rdi)
    1a8e:	89 c0                	mov    %eax,%eax
    1a90:	48 8b 04 c7          	mov    (%rdi,%rax,8),%rax
    1a94:	c3                   	ret
                                  : args->more_argint[(args->_index++)-6]);
    1a95:	8d 50 01             	lea    0x1(%rax),%edx
    1a98:	89 57 38             	mov    %edx,0x38(%rdi)
    1a9b:	8d 40 fa             	lea    -0x6(%rax),%eax
    1a9e:	48 c1 e0 03          	shl    $0x3,%rax
    1aa2:	48 03 47 30          	add    0x30(%rdi),%rax
    return (void *)((args->_index < 6) ? args->argint[args->_index++]
    1aa6:	48 8b 00             	mov    (%rax),%rax
}
    1aa9:	c3                   	ret

0000000000001aaa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1aaa:	55                   	push   %rbp
    1aab:	48 89 e5             	mov    %rsp,%rbp
    1aae:	48 83 ec 10          	sub    $0x10,%rsp
    1ab2:	40 88 75 fc          	mov    %sil,-0x4(%rbp)
  write(fd, &c, 1);
    1ab6:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
    1aba:	ba 01 00 00 00       	mov    $0x1,%edx
    1abf:	e8 e6 fe ff ff       	call   19aa <write>
}
    1ac4:	48 89 ec             	mov    %rbp,%rsp
    1ac7:	5d                   	pop    %rbp
    1ac8:	c3                   	ret

0000000000001ac9 <printint>:

static void
printint(int fd, int64 xx, int base, int sgn)
{
    1ac9:	55                   	push   %rbp
    1aca:	48 89 e5             	mov    %rsp,%rbp
    1acd:	41 54                	push   %r12
    1acf:	53                   	push   %rbx
    1ad0:	48 83 ec 10          	sub    $0x10,%rsp
    1ad4:	41 89 fc             	mov    %edi,%r12d
    1ad7:	41 89 d1             	mov    %edx,%r9d
  char buf[16];
  int i, neg;
  uint64 x;

  neg = 0;
  if(sgn && xx < 0){
    1ada:	85 c9                	test   %ecx,%ecx
    1adc:	0f 95 c2             	setne  %dl
    1adf:	48 89 f0             	mov    %rsi,%rax
    1ae2:	48 c1 e8 3f          	shr    $0x3f,%rax
    1ae6:	85 c2                	test   %eax,%edx
    1ae8:	74 55                	je     1b3f <printint+0x76>
    neg = 1;
    x = -xx;
    1aea:	48 f7 de             	neg    %rsi
    neg = 1;
    1aed:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  } else {
    x = xx;
  }

  i = 0;
    1af3:	bb 00 00 00 00       	mov    $0x0,%ebx
    1af8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    1aff:	00 
  do{
    buf[i++] = digits[x % base];
    1b00:	49 63 c9             	movslq %r9d,%rcx
    1b03:	48 89 f0             	mov    %rsi,%rax
    1b06:	ba 00 00 00 00       	mov    $0x0,%edx
    1b0b:	48 f7 f1             	div    %rcx
    1b0e:	89 df                	mov    %ebx,%edi
    1b10:	83 c3 01             	add    $0x1,%ebx
    1b13:	44 8a 82 70 2d 00 00 	mov    0x2d70(%rdx),%r8b
    1b1a:	48 63 d7             	movslq %edi,%rdx
    1b1d:	44 88 44 15 e0       	mov    %r8b,-0x20(%rbp,%rdx,1)
  }while((x /= base) != 0);
    1b22:	48 89 f2             	mov    %rsi,%rdx
    1b25:	48 89 c6             	mov    %rax,%rsi
    1b28:	48 39 ca             	cmp    %rcx,%rdx
    1b2b:	73 d3                	jae    1b00 <printint+0x37>
  if(neg)
    1b2d:	45 85 d2             	test   %r10d,%r10d
    1b30:	74 25                	je     1b57 <printint+0x8e>
    buf[i++] = '-';
    1b32:	48 63 db             	movslq %ebx,%rbx
    1b35:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
    1b3a:	8d 5f 02             	lea    0x2(%rdi),%ebx
    1b3d:	eb 18                	jmp    1b57 <printint+0x8e>
  neg = 0;
    1b3f:	41 ba 00 00 00 00    	mov    $0x0,%r10d
    1b45:	eb ac                	jmp    1af3 <printint+0x2a>

  while(--i >= 0)
    putc(fd, buf[i]);
    1b47:	48 63 c3             	movslq %ebx,%rax
    1b4a:	0f be 74 05 e0       	movsbl -0x20(%rbp,%rax,1),%esi
    1b4f:	44 89 e7             	mov    %r12d,%edi
    1b52:	e8 53 ff ff ff       	call   1aaa <putc>
  while(--i >= 0)
    1b57:	83 eb 01             	sub    $0x1,%ebx
    1b5a:	79 eb                	jns    1b47 <printint+0x7e>
}
    1b5c:	48 83 c4 10          	add    $0x10,%rsp
    1b60:	5b                   	pop    %rbx
    1b61:	41 5c                	pop    %r12
    1b63:	5d                   	pop    %rbp
    1b64:	c3                   	ret

0000000000001b65 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1b65:	55                   	push   %rbp
    1b66:	48 89 e5             	mov    %rsp,%rbp
    1b69:	41 57                	push   %r15
    1b6b:	41 56                	push   %r14
    1b6d:	41 55                	push   %r13
    1b6f:	41 54                	push   %r12
    1b71:	53                   	push   %rbx
    1b72:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
    1b79:	41 89 ff             	mov    %edi,%r15d
    1b7c:	49 89 f5             	mov    %rsi,%r13
    1b7f:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
    1b86:	48 89 8d 38 ff ff ff 	mov    %rcx,-0xc8(%rbp)
    1b8d:	4c 89 85 40 ff ff ff 	mov    %r8,-0xc0(%rbp)
    1b94:	4c 89 8d 48 ff ff ff 	mov    %r9,-0xb8(%rbp)
    1b9b:	84 c0                	test   %al,%al
    1b9d:	74 29                	je     1bc8 <printf+0x63>
    1b9f:	0f 29 85 50 ff ff ff 	movaps %xmm0,-0xb0(%rbp)
    1ba6:	0f 29 8d 60 ff ff ff 	movaps %xmm1,-0xa0(%rbp)
    1bad:	0f 29 95 70 ff ff ff 	movaps %xmm2,-0x90(%rbp)
    1bb4:	0f 29 5d 80          	movaps %xmm3,-0x80(%rbp)
    1bb8:	0f 29 65 90          	movaps %xmm4,-0x70(%rbp)
    1bbc:	0f 29 6d a0          	movaps %xmm5,-0x60(%rbp)
    1bc0:	0f 29 75 b0          	movaps %xmm6,-0x50(%rbp)
    1bc4:	0f 29 7d c0          	movaps %xmm7,-0x40(%rbp)
    asm volatile("movq %%rdi, %0;" 
    1bc8:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
    1bcf:	48 89 b5 e8 fe ff ff 	mov    %rsi,-0x118(%rbp)
    1bd6:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
    1bdd:	48 89 8d f8 fe ff ff 	mov    %rcx,-0x108(%rbp)
    1be4:	4c 89 85 00 ff ff ff 	mov    %r8,-0x100(%rbp)
    1beb:	4c 89 8d 08 ff ff ff 	mov    %r9,-0xf8(%rbp)
    asm volatile("leaq 16(%%rbp), %0" : "=r" (args->more_argint));
    1bf2:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1bf6:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
    args->_index = 1;
    1bfd:	c7 85 18 ff ff ff 01 	movl   $0x1,-0xe8(%rbp)
    1c04:	00 00 00 
  char *s;
  int c, i, state;
  va_list ap;

  va_start(ap, fd);
  (void) va_arg(ap, char*); // skip fmt
    1c07:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    1c0e:	e8 6d fe ff ff       	call   1a80 <_va_arg>

  state = 0;
    1c13:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  for(i = 0; fmt[i]; i++){
    1c19:	bb 00 00 00 00       	mov    $0x0,%ebx
    1c1e:	eb 16                	jmp    1c36 <printf+0xd1>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    1c20:	44 89 f6             	mov    %r14d,%esi
    1c23:	44 89 ff             	mov    %r15d,%edi
    1c26:	e8 7f fe ff ff       	call   1aaa <putc>
    1c2b:	eb 06                	jmp    1c33 <printf+0xce>
      }
    } else if(state == '%'){
    1c2d:	41 83 fc 25          	cmp    $0x25,%r12d
    1c31:	74 2c                	je     1c5f <printf+0xfa>
  for(i = 0; fmt[i]; i++){
    1c33:	83 c3 01             	add    $0x1,%ebx
    1c36:	48 63 c3             	movslq %ebx,%rax
    1c39:	41 8a 44 05 00       	mov    0x0(%r13,%rax,1),%al
    1c3e:	0f be d0             	movsbl %al,%edx
    1c41:	85 d2                	test   %edx,%edx
    1c43:	0f 84 42 01 00 00    	je     1d8b <printf+0x226>
    c = fmt[i] & 0xff;
    1c49:	44 0f be f0          	movsbl %al,%r14d
    1c4d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
    1c50:	45 85 e4             	test   %r12d,%r12d
    1c53:	75 d8                	jne    1c2d <printf+0xc8>
      if(c == '%'){
    1c55:	83 f8 25             	cmp    $0x25,%eax
    1c58:	75 c6                	jne    1c20 <printf+0xbb>
        state = '%';
    1c5a:	41 89 c4             	mov    %eax,%r12d
    1c5d:	eb d4                	jmp    1c33 <printf+0xce>
      if(c == 'd'){
    1c5f:	83 f8 25             	cmp    $0x25,%eax
    1c62:	0f 84 ea 00 00 00    	je     1d52 <printf+0x1ed>
    1c68:	0f 8c fa 00 00 00    	jl     1d68 <printf+0x203>
    1c6e:	83 f8 78             	cmp    $0x78,%eax
    1c71:	0f 8f f1 00 00 00    	jg     1d68 <printf+0x203>
    1c77:	83 f8 63             	cmp    $0x63,%eax
    1c7a:	0f 8c e8 00 00 00    	jl     1d68 <printf+0x203>
    1c80:	83 e8 63             	sub    $0x63,%eax
    1c83:	83 f8 15             	cmp    $0x15,%eax
    1c86:	0f 87 dc 00 00 00    	ja     1d68 <printf+0x203>
    1c8c:	89 c0                	mov    %eax,%eax
    1c8e:	ff 24 c5 c0 2c 00 00 	jmp    *0x2cc0(,%rax,8)
        printint(fd, va_arg(ap, int), 10, 1);
    1c95:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    1c9c:	e8 df fd ff ff       	call   1a80 <_va_arg>
    1ca1:	48 63 f0             	movslq %eax,%rsi
    1ca4:	b9 01 00 00 00       	mov    $0x1,%ecx
    1ca9:	ba 0a 00 00 00       	mov    $0xa,%edx
    1cae:	44 89 ff             	mov    %r15d,%edi
    1cb1:	e8 13 fe ff ff       	call   1ac9 <printint>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1cb6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    1cbc:	e9 72 ff ff ff       	jmp    1c33 <printf+0xce>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1cc1:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    1cc8:	e8 b3 fd ff ff       	call   1a80 <_va_arg>
    1ccd:	48 89 c6             	mov    %rax,%rsi
    1cd0:	b9 00 00 00 00       	mov    $0x0,%ecx
    1cd5:	ba 10 00 00 00       	mov    $0x10,%edx
    1cda:	44 89 ff             	mov    %r15d,%edi
    1cdd:	e8 e7 fd ff ff       	call   1ac9 <printint>
      state = 0;
    1ce2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    1ce8:	e9 46 ff ff ff       	jmp    1c33 <printf+0xce>
        s = va_arg(ap, char*);
    1ced:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    1cf4:	e8 87 fd ff ff       	call   1a80 <_va_arg>
    1cf9:	49 89 c4             	mov    %rax,%r12
        if(s == 0)
    1cfc:	48 85 c0             	test   %rax,%rax
    1cff:	75 18                	jne    1d19 <printf+0x1b4>
          s = "(null)";
    1d01:	41 bc a3 28 00 00    	mov    $0x28a3,%r12d
    1d07:	eb 10                	jmp    1d19 <printf+0x1b4>
          putc(fd, *s);
    1d09:	40 0f be f6          	movsbl %sil,%esi
    1d0d:	44 89 ff             	mov    %r15d,%edi
    1d10:	e8 95 fd ff ff       	call   1aaa <putc>
          s++;
    1d15:	49 83 c4 01          	add    $0x1,%r12
        while(*s != 0){
    1d19:	41 8a 34 24          	mov    (%r12),%sil
    1d1d:	40 0f be c6          	movsbl %sil,%eax
    1d21:	85 c0                	test   %eax,%eax
    1d23:	75 e4                	jne    1d09 <printf+0x1a4>
      state = 0;
    1d25:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    1d2b:	e9 03 ff ff ff       	jmp    1c33 <printf+0xce>
        putc(fd, va_arg(ap, char));
    1d30:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
    1d37:	e8 44 fd ff ff       	call   1a80 <_va_arg>
    1d3c:	0f be f0             	movsbl %al,%esi
    1d3f:	44 89 ff             	mov    %r15d,%edi
    1d42:	e8 63 fd ff ff       	call   1aaa <putc>
      state = 0;
    1d47:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    1d4d:	e9 e1 fe ff ff       	jmp    1c33 <printf+0xce>
        putc(fd, c);
    1d52:	44 89 f6             	mov    %r14d,%esi
    1d55:	44 89 ff             	mov    %r15d,%edi
    1d58:	e8 4d fd ff ff       	call   1aaa <putc>
      state = 0;
    1d5d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    1d63:	e9 cb fe ff ff       	jmp    1c33 <printf+0xce>
        putc(fd, '%');
    1d68:	be 25 00 00 00       	mov    $0x25,%esi
    1d6d:	44 89 ff             	mov    %r15d,%edi
    1d70:	e8 35 fd ff ff       	call   1aaa <putc>
        putc(fd, c);
    1d75:	44 89 f6             	mov    %r14d,%esi
    1d78:	44 89 ff             	mov    %r15d,%edi
    1d7b:	e8 2a fd ff ff       	call   1aaa <putc>
      state = 0;
    1d80:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    1d86:	e9 a8 fe ff ff       	jmp    1c33 <printf+0xce>
    }
  }
}
    1d8b:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
    1d92:	5b                   	pop    %rbx
    1d93:	41 5c                	pop    %r12
    1d95:	41 5d                	pop    %r13
    1d97:	41 5e                	pop    %r14
    1d99:	41 5f                	pop    %r15
    1d9b:	5d                   	pop    %rbp
    1d9c:	c3                   	ret
    1d9d:	0f 1f 00             	nopl   (%rax)

0000000000001da0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1da0:	48 89 fe             	mov    %rdi,%rsi
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1da3:	48 8d 4f f0          	lea    -0x10(%rdi),%rcx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1da7:	48 8b 05 92 34 00 00 	mov    0x3492(%rip),%rax        # 5240 <freep>
    1dae:	eb 03                	jmp    1db3 <free+0x13>
    1db0:	48 89 d0             	mov    %rdx,%rax
    1db3:	48 39 c8             	cmp    %rcx,%rax
    1db6:	73 05                	jae    1dbd <free+0x1d>
    1db8:	48 3b 08             	cmp    (%rax),%rcx
    1dbb:	72 17                	jb     1dd4 <free+0x34>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1dbd:	48 8b 10             	mov    (%rax),%rdx
    1dc0:	48 39 d0             	cmp    %rdx,%rax
    1dc3:	72 eb                	jb     1db0 <free+0x10>
    1dc5:	48 39 c8             	cmp    %rcx,%rax
    1dc8:	72 0a                	jb     1dd4 <free+0x34>
    1dca:	48 39 d1             	cmp    %rdx,%rcx
    1dcd:	72 05                	jb     1dd4 <free+0x34>
    1dcf:	48 89 d0             	mov    %rdx,%rax
    1dd2:	eb df                	jmp    1db3 <free+0x13>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1dd4:	44 8b 46 f8          	mov    -0x8(%rsi),%r8d
    1dd8:	44 89 c2             	mov    %r8d,%edx
    1ddb:	48 c1 e2 04          	shl    $0x4,%rdx
    1ddf:	48 01 ca             	add    %rcx,%rdx
    1de2:	48 8b 38             	mov    (%rax),%rdi
    1de5:	48 39 fa             	cmp    %rdi,%rdx
    1de8:	74 20                	je     1e0a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1dea:	48 89 7e f0          	mov    %rdi,-0x10(%rsi)
  if(p + p->s.size == bp){
    1dee:	8b 78 08             	mov    0x8(%rax),%edi
    1df1:	89 fa                	mov    %edi,%edx
    1df3:	48 c1 e2 04          	shl    $0x4,%rdx
    1df7:	48 01 c2             	add    %rax,%rdx
    1dfa:	48 39 ca             	cmp    %rcx,%rdx
    1dfd:	74 1f                	je     1e1e <free+0x7e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1dff:	48 89 08             	mov    %rcx,(%rax)
  freep = p;
    1e02:	48 89 05 37 34 00 00 	mov    %rax,0x3437(%rip)        # 5240 <freep>
}
    1e09:	c3                   	ret
    bp->s.size += p->s.ptr->s.size;
    1e0a:	44 03 47 08          	add    0x8(%rdi),%r8d
    1e0e:	44 89 46 f8          	mov    %r8d,-0x8(%rsi)
    bp->s.ptr = p->s.ptr->s.ptr;
    1e12:	48 8b 10             	mov    (%rax),%rdx
    1e15:	48 8b 12             	mov    (%rdx),%rdx
    1e18:	48 89 56 f0          	mov    %rdx,-0x10(%rsi)
    1e1c:	eb d0                	jmp    1dee <free+0x4e>
    p->s.size += bp->s.size;
    1e1e:	03 7e f8             	add    -0x8(%rsi),%edi
    1e21:	89 78 08             	mov    %edi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1e24:	48 8b 56 f0          	mov    -0x10(%rsi),%rdx
    1e28:	48 89 10             	mov    %rdx,(%rax)
    1e2b:	eb d5                	jmp    1e02 <free+0x62>

0000000000001e2d <morecore>:

static Header*
morecore(uint nu)
{
    1e2d:	55                   	push   %rbp
    1e2e:	48 89 e5             	mov    %rsp,%rbp
    1e31:	53                   	push   %rbx
    1e32:	48 83 ec 08          	sub    $0x8,%rsp
    1e36:	89 fb                	mov    %edi,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    1e38:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
    1e3e:	77 05                	ja     1e45 <morecore+0x18>
    nu = 4096;
    1e40:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    1e45:	89 df                	mov    %ebx,%edi
    1e47:	c1 e7 04             	shl    $0x4,%edi
    1e4a:	e8 dd fb ff ff       	call   1a2c <sbrk>
  if(p == (char*)-1)
    1e4f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
    1e53:	74 1a                	je     1e6f <morecore+0x42>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    1e55:	89 58 08             	mov    %ebx,0x8(%rax)
  free((void*)(hp + 1));
    1e58:	48 8d 78 10          	lea    0x10(%rax),%rdi
    1e5c:	e8 3f ff ff ff       	call   1da0 <free>
  return freep;
    1e61:	48 8b 05 d8 33 00 00 	mov    0x33d8(%rip),%rax        # 5240 <freep>
}
    1e68:	48 83 c4 08          	add    $0x8,%rsp
    1e6c:	5b                   	pop    %rbx
    1e6d:	5d                   	pop    %rbp
    1e6e:	c3                   	ret
    return 0;
    1e6f:	b8 00 00 00 00       	mov    $0x0,%eax
    1e74:	eb f2                	jmp    1e68 <morecore+0x3b>

0000000000001e76 <malloc>:

void*
malloc(uint nbytes)
{
    1e76:	55                   	push   %rbp
    1e77:	48 89 e5             	mov    %rsp,%rbp
    1e7a:	53                   	push   %rbx
    1e7b:	48 83 ec 08          	sub    $0x8,%rsp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1e7f:	89 fb                	mov    %edi,%ebx
    1e81:	48 83 c3 0f          	add    $0xf,%rbx
    1e85:	48 c1 eb 04          	shr    $0x4,%rbx
    1e89:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    1e8c:	48 8b 0d ad 33 00 00 	mov    0x33ad(%rip),%rcx        # 5240 <freep>
    1e93:	48 85 c9             	test   %rcx,%rcx
    1e96:	74 05                	je     1e9d <malloc+0x27>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e98:	48 8b 01             	mov    (%rcx),%rax
    1e9b:	eb 69                	jmp    1f06 <malloc+0x90>
    base.s.ptr = freep = prevp = &base;
    1e9d:	48 c7 05 98 33 00 00 	movq   $0x5250,0x3398(%rip)        # 5240 <freep>
    1ea4:	50 52 00 00 
    1ea8:	48 c7 05 9d 33 00 00 	movq   $0x5250,0x339d(%rip)        # 5250 <base>
    1eaf:	50 52 00 00 
    base.s.size = 0;
    1eb3:	c7 05 9b 33 00 00 00 	movl   $0x0,0x339b(%rip)        # 5258 <base+0x8>
    1eba:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    1ebd:	b9 50 52 00 00       	mov    $0x5250,%ecx
    1ec2:	eb d4                	jmp    1e98 <malloc+0x22>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    1ec4:	74 23                	je     1ee9 <malloc+0x73>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1ec6:	29 da                	sub    %ebx,%edx
    1ec8:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1ecb:	89 d2                	mov    %edx,%edx
    1ecd:	48 c1 e2 04          	shl    $0x4,%rdx
    1ed1:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
    1ed4:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
    1ed7:	48 89 0d 62 33 00 00 	mov    %rcx,0x3362(%rip)        # 5240 <freep>
      return (void*)(p + 1);
    1ede:	48 83 c0 10          	add    $0x10,%rax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1ee2:	48 83 c4 08          	add    $0x8,%rsp
    1ee6:	5b                   	pop    %rbx
    1ee7:	5d                   	pop    %rbp
    1ee8:	c3                   	ret
        prevp->s.ptr = p->s.ptr;
    1ee9:	48 8b 10             	mov    (%rax),%rdx
    1eec:	48 89 11             	mov    %rdx,(%rcx)
    1eef:	eb e6                	jmp    1ed7 <malloc+0x61>
    1ef1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1ef8:	00 00 00 00 
    1efc:	0f 1f 40 00          	nopl   0x0(%rax)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1f00:	48 89 c1             	mov    %rax,%rcx
    1f03:	48 8b 00             	mov    (%rax),%rax
    if(p->s.size >= nunits){
    1f06:	8b 50 08             	mov    0x8(%rax),%edx
    1f09:	39 da                	cmp    %ebx,%edx
    1f0b:	73 b7                	jae    1ec4 <malloc+0x4e>
    if(p == freep)
    1f0d:	48 39 05 2c 33 00 00 	cmp    %rax,0x332c(%rip)        # 5240 <freep>
    1f14:	75 ea                	jne    1f00 <malloc+0x8a>
      if((p = morecore(nunits)) == 0)
    1f16:	89 df                	mov    %ebx,%edi
    1f18:	e8 10 ff ff ff       	call   1e2d <morecore>
    1f1d:	48 85 c0             	test   %rax,%rax
    1f20:	75 de                	jne    1f00 <malloc+0x8a>
    1f22:	eb be                	jmp    1ee2 <malloc+0x6c>
