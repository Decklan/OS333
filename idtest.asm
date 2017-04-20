
_idtest:     file format elf32-i386


Disassembly of section .text:

00000000 <uidTest>:
#include "user.h"
#define TPS 10

static void
uidTest(uint nval)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  uint uid = getuid();
   6:	e8 38 07 00 00       	call   743 <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 00 0c 00 00       	push   $0xc00
  19:	6a 01                	push   $0x1
  1b:	e8 2a 08 00 00       	call   84a <printf>
  20:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to %d\n", nval);
  23:	83 ec 04             	sub    $0x4,%esp
  26:	ff 75 08             	pushl  0x8(%ebp)
  29:	68 14 0c 00 00       	push   $0xc14
  2e:	6a 01                	push   $0x1
  30:	e8 15 08 00 00       	call   84a <printf>
  35:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	ff 75 08             	pushl  0x8(%ebp)
  3e:	e8 18 07 00 00       	call   75b <setuid>
  43:	83 c4 10             	add    $0x10,%esp
  46:	85 c0                	test   %eax,%eax
  48:	79 15                	jns    5f <uidTest+0x5f>
    printf(2, "Error. Invalid UID: %d\n", nval);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 08             	pushl  0x8(%ebp)
  50:	68 27 0c 00 00       	push   $0xc27
  55:	6a 02                	push   $0x2
  57:	e8 ee 07 00 00       	call   84a <printf>
  5c:	83 c4 10             	add    $0x10,%esp
  setuid(nval);
  5f:	83 ec 0c             	sub    $0xc,%esp
  62:	ff 75 08             	pushl  0x8(%ebp)
  65:	e8 f1 06 00 00       	call   75b <setuid>
  6a:	83 c4 10             	add    $0x10,%esp
  uid = getuid();
  6d:	e8 d1 06 00 00       	call   743 <getuid>
  72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  75:	83 ec 04             	sub    $0x4,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	68 00 0c 00 00       	push   $0xc00
  80:	6a 01                	push   $0x1
  82:	e8 c3 07 00 00       	call   84a <printf>
  87:	83 c4 10             	add    $0x10,%esp
  sleep(5 * TPS); // now type control-p
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	6a 32                	push   $0x32
  8f:	e8 8f 06 00 00       	call   723 <sleep>
  94:	83 c4 10             	add    $0x10,%esp
}
  97:	90                   	nop
  98:	c9                   	leave  
  99:	c3                   	ret    

0000009a <gidTest>:

static void
gidTest(uint nval)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 18             	sub    $0x18,%esp
  uint gid = getgid();
  a0:	e8 a6 06 00 00       	call   74b <getgid>
  a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current GID is: %d\n", gid);
  a8:	83 ec 04             	sub    $0x4,%esp
  ab:	ff 75 f4             	pushl  -0xc(%ebp)
  ae:	68 3f 0c 00 00       	push   $0xc3f
  b3:	6a 01                	push   $0x1
  b5:	e8 90 07 00 00       	call   84a <printf>
  ba:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to %d\n", nval);
  bd:	83 ec 04             	sub    $0x4,%esp
  c0:	ff 75 08             	pushl  0x8(%ebp)
  c3:	68 53 0c 00 00       	push   $0xc53
  c8:	6a 01                	push   $0x1
  ca:	e8 7b 07 00 00       	call   84a <printf>
  cf:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
  d2:	83 ec 0c             	sub    $0xc,%esp
  d5:	ff 75 08             	pushl  0x8(%ebp)
  d8:	e8 86 06 00 00       	call   763 <setgid>
  dd:	83 c4 10             	add    $0x10,%esp
  e0:	85 c0                	test   %eax,%eax
  e2:	79 15                	jns    f9 <gidTest+0x5f>
    printf(2, "Error. Invalid GID: %d\n", nval);
  e4:	83 ec 04             	sub    $0x4,%esp
  e7:	ff 75 08             	pushl  0x8(%ebp)
  ea:	68 66 0c 00 00       	push   $0xc66
  ef:	6a 02                	push   $0x2
  f1:	e8 54 07 00 00       	call   84a <printf>
  f6:	83 c4 10             	add    $0x10,%esp
  setgid(nval);
  f9:	83 ec 0c             	sub    $0xc,%esp
  fc:	ff 75 08             	pushl  0x8(%ebp)
  ff:	e8 5f 06 00 00       	call   763 <setgid>
 104:	83 c4 10             	add    $0x10,%esp
  gid = getgid();
 107:	e8 3f 06 00 00       	call   74b <getgid>
 10c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 10f:	83 ec 04             	sub    $0x4,%esp
 112:	ff 75 f4             	pushl  -0xc(%ebp)
 115:	68 3f 0c 00 00       	push   $0xc3f
 11a:	6a 01                	push   $0x1
 11c:	e8 29 07 00 00       	call   84a <printf>
 121:	83 c4 10             	add    $0x10,%esp
  sleep(5 * TPS); // now type control-p
 124:	83 ec 0c             	sub    $0xc,%esp
 127:	6a 32                	push   $0x32
 129:	e8 f5 05 00 00       	call   723 <sleep>
 12e:	83 c4 10             	add    $0x10,%esp
}
 131:	90                   	nop
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <forkTest>:

static void 
forkTest(uint nval)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	53                   	push   %ebx
 138:	83 ec 14             	sub    $0x14,%esp
  uint uid, gid;
  int pid;

  printf(1, "Setting UID to %d and GID to %d before fork(). Value"
 13b:	ff 75 08             	pushl  0x8(%ebp)
 13e:	ff 75 08             	pushl  0x8(%ebp)
 141:	68 80 0c 00 00       	push   $0xc80
 146:	6a 01                	push   $0x1
 148:	e8 fd 06 00 00       	call   84a <printf>
 14d:	83 c4 10             	add    $0x10,%esp
                  " should be inherited\n", nval, nval);

  if (setuid(nval) < 0)
 150:	83 ec 0c             	sub    $0xc,%esp
 153:	ff 75 08             	pushl  0x8(%ebp)
 156:	e8 00 06 00 00       	call   75b <setuid>
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	85 c0                	test   %eax,%eax
 160:	79 15                	jns    177 <forkTest+0x43>
    printf(2, "Error.Invalid UID: %d\n", nval);
 162:	83 ec 04             	sub    $0x4,%esp
 165:	ff 75 08             	pushl  0x8(%ebp)
 168:	68 ca 0c 00 00       	push   $0xcca
 16d:	6a 02                	push   $0x2
 16f:	e8 d6 06 00 00       	call   84a <printf>
 174:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 177:	83 ec 0c             	sub    $0xc,%esp
 17a:	ff 75 08             	pushl  0x8(%ebp)
 17d:	e8 e1 05 00 00       	call   763 <setgid>
 182:	83 c4 10             	add    $0x10,%esp
 185:	85 c0                	test   %eax,%eax
 187:	79 15                	jns    19e <forkTest+0x6a>
    printf(2, "Error.Invalid GID: %d\n", nval);
 189:	83 ec 04             	sub    $0x4,%esp
 18c:	ff 75 08             	pushl  0x8(%ebp)
 18f:	68 e1 0c 00 00       	push   $0xce1
 194:	6a 02                	push   $0x2
 196:	e8 af 06 00 00       	call   84a <printf>
 19b:	83 c4 10             	add    $0x10,%esp
  
  printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getgid());
 19e:	e8 a8 05 00 00       	call   74b <getgid>
 1a3:	89 c3                	mov    %eax,%ebx
 1a5:	e8 99 05 00 00       	call   743 <getuid>
 1aa:	53                   	push   %ebx
 1ab:	50                   	push   %eax
 1ac:	68 f8 0c 00 00       	push   $0xcf8
 1b1:	6a 01                	push   $0x1
 1b3:	e8 92 06 00 00       	call   84a <printf>
 1b8:	83 c4 10             	add    $0x10,%esp
  pid = fork();
 1bb:	e8 cb 04 00 00       	call   68b <fork>
 1c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (pid == 0) {  // child
 1c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c7:	75 37                	jne    200 <forkTest+0xcc>
    uid = getuid();
 1c9:	e8 75 05 00 00       	call   743 <getuid>
 1ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    gid = getgid();
 1d1:	e8 75 05 00 00       	call   74b <getgid>
 1d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1, "Child: UID is: %d, GID is: %d\n", uid, gid);
 1d9:	ff 75 ec             	pushl  -0x14(%ebp)
 1dc:	ff 75 f0             	pushl  -0x10(%ebp)
 1df:	68 1c 0d 00 00       	push   $0xd1c
 1e4:	6a 01                	push   $0x1
 1e6:	e8 5f 06 00 00       	call   84a <printf>
 1eb:	83 c4 10             	add    $0x10,%esp
    sleep(5 * TPS);  // now type control-p
 1ee:	83 ec 0c             	sub    $0xc,%esp
 1f1:	6a 32                	push   $0x32
 1f3:	e8 2b 05 00 00       	call   723 <sleep>
 1f8:	83 c4 10             	add    $0x10,%esp
    exit();
 1fb:	e8 93 04 00 00       	call   693 <exit>
  }
  else
    sleep(10 * TPS);
 200:	83 ec 0c             	sub    $0xc,%esp
 203:	6a 64                	push   $0x64
 205:	e8 19 05 00 00       	call   723 <sleep>
 20a:	83 c4 10             	add    $0x10,%esp
}
 20d:	90                   	nop
 20e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <invalidTest>:

static void
invalidTest(uint nval)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
 216:	83 ec 08             	sub    $0x8,%esp
  printf(1, "Setting UID to %d. This test should FAIL\n", nval);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	ff 75 08             	pushl  0x8(%ebp)
 21f:	68 3c 0d 00 00       	push   $0xd3c
 224:	6a 01                	push   $0x1
 226:	e8 1f 06 00 00       	call   84a <printf>
 22b:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
 22e:	83 ec 0c             	sub    $0xc,%esp
 231:	ff 75 08             	pushl  0x8(%ebp)
 234:	e8 22 05 00 00       	call   75b <setuid>
 239:	83 c4 10             	add    $0x10,%esp
 23c:	85 c0                	test   %eax,%eax
 23e:	79 14                	jns    254 <invalidTest+0x41>
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
 240:	83 ec 08             	sub    $0x8,%esp
 243:	68 68 0d 00 00       	push   $0xd68
 248:	6a 01                	push   $0x1
 24a:	e8 fb 05 00 00       	call   84a <printf>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	eb 12                	jmp    266 <invalidTest+0x53>
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");
 254:	83 ec 08             	sub    $0x8,%esp
 257:	68 9c 0d 00 00       	push   $0xd9c
 25c:	6a 02                	push   $0x2
 25e:	e8 e7 05 00 00       	call   84a <printf>
 263:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", nval);
 266:	83 ec 04             	sub    $0x4,%esp
 269:	ff 75 08             	pushl  0x8(%ebp)
 26c:	68 d0 0d 00 00       	push   $0xdd0
 271:	6a 01                	push   $0x1
 273:	e8 d2 05 00 00       	call   84a <printf>
 278:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 27b:	83 ec 0c             	sub    $0xc,%esp
 27e:	ff 75 08             	pushl  0x8(%ebp)
 281:	e8 dd 04 00 00       	call   763 <setgid>
 286:	83 c4 10             	add    $0x10,%esp
 289:	85 c0                	test   %eax,%eax
 28b:	79 14                	jns    2a1 <invalidTest+0x8e>
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	68 fc 0d 00 00       	push   $0xdfc
 295:	6a 01                	push   $0x1
 297:	e8 ae 05 00 00       	call   84a <printf>
 29c:	83 c4 10             	add    $0x10,%esp
 29f:	eb 12                	jmp    2b3 <invalidTest+0xa0>
  else
    printf(2, "FAILURE! The setgid system call indicates success\n");
 2a1:	83 ec 08             	sub    $0x8,%esp
 2a4:	68 30 0e 00 00       	push   $0xe30
 2a9:	6a 02                	push   $0x2
 2ab:	e8 9a 05 00 00       	call   84a <printf>
 2b0:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting UID to %d. This test should FAIL\n", -1);
 2b3:	83 ec 04             	sub    $0x4,%esp
 2b6:	6a ff                	push   $0xffffffff
 2b8:	68 3c 0d 00 00       	push   $0xd3c
 2bd:	6a 01                	push   $0x1
 2bf:	e8 86 05 00 00       	call   84a <printf>
 2c4:	83 c4 10             	add    $0x10,%esp
  if (setuid(-1) < 0)
 2c7:	83 ec 0c             	sub    $0xc,%esp
 2ca:	6a ff                	push   $0xffffffff
 2cc:	e8 8a 04 00 00       	call   75b <setuid>
 2d1:	83 c4 10             	add    $0x10,%esp
 2d4:	85 c0                	test   %eax,%eax
 2d6:	79 14                	jns    2ec <invalidTest+0xd9>
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
 2d8:	83 ec 08             	sub    $0x8,%esp
 2db:	68 68 0d 00 00       	push   $0xd68
 2e0:	6a 01                	push   $0x1
 2e2:	e8 63 05 00 00       	call   84a <printf>
 2e7:	83 c4 10             	add    $0x10,%esp
 2ea:	eb 12                	jmp    2fe <invalidTest+0xeb>
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");
 2ec:	83 ec 08             	sub    $0x8,%esp
 2ef:	68 9c 0d 00 00       	push   $0xd9c
 2f4:	6a 02                	push   $0x2
 2f6:	e8 4f 05 00 00       	call   84a <printf>
 2fb:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", -1);
 2fe:	83 ec 04             	sub    $0x4,%esp
 301:	6a ff                	push   $0xffffffff
 303:	68 d0 0d 00 00       	push   $0xdd0
 308:	6a 01                	push   $0x1
 30a:	e8 3b 05 00 00       	call   84a <printf>
 30f:	83 c4 10             	add    $0x10,%esp
  if (setgid(-1) < 0)
 312:	83 ec 0c             	sub    $0xc,%esp
 315:	6a ff                	push   $0xffffffff
 317:	e8 47 04 00 00       	call   763 <setgid>
 31c:	83 c4 10             	add    $0x10,%esp
 31f:	85 c0                	test   %eax,%eax
 321:	79 14                	jns    337 <invalidTest+0x124>
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
 323:	83 ec 08             	sub    $0x8,%esp
 326:	68 fc 0d 00 00       	push   $0xdfc
 32b:	6a 01                	push   $0x1
 32d:	e8 18 05 00 00       	call   84a <printf>
 332:	83 c4 10             	add    $0x10,%esp
  else
    printf(2, "FAILURE! The setgid system call indicates success\n");
}
 335:	eb 12                	jmp    349 <invalidTest+0x136>

  printf(1, "Setting GID to %d. This test should FAIL\n", -1);
  if (setgid(-1) < 0)
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
  else
    printf(2, "FAILURE! The setgid system call indicates success\n");
 337:	83 ec 08             	sub    $0x8,%esp
 33a:	68 30 0e 00 00       	push   $0xe30
 33f:	6a 02                	push   $0x2
 341:	e8 04 05 00 00       	call   84a <printf>
 346:	83 c4 10             	add    $0x10,%esp
}
 349:	90                   	nop
 34a:	c9                   	leave  
 34b:	c3                   	ret    

0000034c <testuidgid>:

static int
testuidgid(void)
{
 34c:	55                   	push   %ebp
 34d:	89 e5                	mov    %esp,%ebp
 34f:	83 ec 18             	sub    $0x18,%esp
  uint nval, ppid;

  // get/set uid test
  nval = 100;
 352:	c7 45 f4 64 00 00 00 	movl   $0x64,-0xc(%ebp)
  uidTest(nval);
 359:	83 ec 0c             	sub    $0xc,%esp
 35c:	ff 75 f4             	pushl  -0xc(%ebp)
 35f:	e8 9c fc ff ff       	call   0 <uidTest>
 364:	83 c4 10             	add    $0x10,%esp

  // get/set gid test
  nval = 200;
 367:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%ebp)
  gidTest(nval);
 36e:	83 ec 0c             	sub    $0xc,%esp
 371:	ff 75 f4             	pushl  -0xc(%ebp)
 374:	e8 21 fd ff ff       	call   9a <gidTest>
 379:	83 c4 10             	add    $0x10,%esp

  // getppid test
  ppid = getppid();
 37c:	e8 d2 03 00 00       	call   753 <getppid>
 381:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "My parent process is: %d\n", ppid);
 384:	83 ec 04             	sub    $0x4,%esp
 387:	ff 75 f0             	pushl  -0x10(%ebp)
 38a:	68 63 0e 00 00       	push   $0xe63
 38f:	6a 01                	push   $0x1
 391:	e8 b4 04 00 00       	call   84a <printf>
 396:	83 c4 10             	add    $0x10,%esp

  // fork tests to demonstrate UID/GID inheritance
  nval = 111;
 399:	c7 45 f4 6f 00 00 00 	movl   $0x6f,-0xc(%ebp)
  forkTest(nval);
 3a0:	83 ec 0c             	sub    $0xc,%esp
 3a3:	ff 75 f4             	pushl  -0xc(%ebp)
 3a6:	e8 89 fd ff ff       	call   134 <forkTest>
 3ab:	83 c4 10             	add    $0x10,%esp

  // tests for invalid values for uid and gid
  nval = 32800;
 3ae:	c7 45 f4 20 80 00 00 	movl   $0x8020,-0xc(%ebp)
  invalidTest(nval);
 3b5:	83 ec 0c             	sub    $0xc,%esp
 3b8:	ff 75 f4             	pushl  -0xc(%ebp)
 3bb:	e8 53 fe ff ff       	call   213 <invalidTest>
 3c0:	83 c4 10             	add    $0x10,%esp

  printf(1, "Done!\n");
 3c3:	83 ec 08             	sub    $0x8,%esp
 3c6:	68 7d 0e 00 00       	push   $0xe7d
 3cb:	6a 01                	push   $0x1
 3cd:	e8 78 04 00 00       	call   84a <printf>
 3d2:	83 c4 10             	add    $0x10,%esp
  return 0;
 3d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3da:	c9                   	leave  
 3db:	c3                   	ret    

000003dc <main>:

int
main()
{
 3dc:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 3e0:	83 e4 f0             	and    $0xfffffff0,%esp
 3e3:	ff 71 fc             	pushl  -0x4(%ecx)
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	51                   	push   %ecx
 3ea:	83 ec 04             	sub    $0x4,%esp
  testuidgid();
 3ed:	e8 5a ff ff ff       	call   34c <testuidgid>
  exit();
 3f2:	e8 9c 02 00 00       	call   693 <exit>

000003f7 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	57                   	push   %edi
 3fb:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 3fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3ff:	8b 55 10             	mov    0x10(%ebp),%edx
 402:	8b 45 0c             	mov    0xc(%ebp),%eax
 405:	89 cb                	mov    %ecx,%ebx
 407:	89 df                	mov    %ebx,%edi
 409:	89 d1                	mov    %edx,%ecx
 40b:	fc                   	cld    
 40c:	f3 aa                	rep stos %al,%es:(%edi)
 40e:	89 ca                	mov    %ecx,%edx
 410:	89 fb                	mov    %edi,%ebx
 412:	89 5d 08             	mov    %ebx,0x8(%ebp)
 415:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 418:	90                   	nop
 419:	5b                   	pop    %ebx
 41a:	5f                   	pop    %edi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    

0000041d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 41d:	55                   	push   %ebp
 41e:	89 e5                	mov    %esp,%ebp
 420:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 429:	90                   	nop
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	8d 50 01             	lea    0x1(%eax),%edx
 430:	89 55 08             	mov    %edx,0x8(%ebp)
 433:	8b 55 0c             	mov    0xc(%ebp),%edx
 436:	8d 4a 01             	lea    0x1(%edx),%ecx
 439:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 43c:	0f b6 12             	movzbl (%edx),%edx
 43f:	88 10                	mov    %dl,(%eax)
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	84 c0                	test   %al,%al
 446:	75 e2                	jne    42a <strcpy+0xd>
    ;
  return os;
 448:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 44b:	c9                   	leave  
 44c:	c3                   	ret    

0000044d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 450:	eb 08                	jmp    45a <strcmp+0xd>
    p++, q++;
 452:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 456:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
 45d:	0f b6 00             	movzbl (%eax),%eax
 460:	84 c0                	test   %al,%al
 462:	74 10                	je     474 <strcmp+0x27>
 464:	8b 45 08             	mov    0x8(%ebp),%eax
 467:	0f b6 10             	movzbl (%eax),%edx
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	0f b6 00             	movzbl (%eax),%eax
 470:	38 c2                	cmp    %al,%dl
 472:	74 de                	je     452 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	0f b6 00             	movzbl (%eax),%eax
 47a:	0f b6 d0             	movzbl %al,%edx
 47d:	8b 45 0c             	mov    0xc(%ebp),%eax
 480:	0f b6 00             	movzbl (%eax),%eax
 483:	0f b6 c0             	movzbl %al,%eax
 486:	29 c2                	sub    %eax,%edx
 488:	89 d0                	mov    %edx,%eax
}
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    

0000048c <strlen>:

uint
strlen(char *s)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 499:	eb 04                	jmp    49f <strlen+0x13>
 49b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 49f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	01 d0                	add    %edx,%eax
 4a7:	0f b6 00             	movzbl (%eax),%eax
 4aa:	84 c0                	test   %al,%al
 4ac:	75 ed                	jne    49b <strlen+0xf>
    ;
  return n;
 4ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4b1:	c9                   	leave  
 4b2:	c3                   	ret    

000004b3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 4b6:	8b 45 10             	mov    0x10(%ebp),%eax
 4b9:	50                   	push   %eax
 4ba:	ff 75 0c             	pushl  0xc(%ebp)
 4bd:	ff 75 08             	pushl  0x8(%ebp)
 4c0:	e8 32 ff ff ff       	call   3f7 <stosb>
 4c5:	83 c4 0c             	add    $0xc,%esp
  return dst;
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4cb:	c9                   	leave  
 4cc:	c3                   	ret    

000004cd <strchr>:

char*
strchr(const char *s, char c)
{
 4cd:	55                   	push   %ebp
 4ce:	89 e5                	mov    %esp,%ebp
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d6:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 4d9:	eb 14                	jmp    4ef <strchr+0x22>
    if(*s == c)
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	0f b6 00             	movzbl (%eax),%eax
 4e1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 4e4:	75 05                	jne    4eb <strchr+0x1e>
      return (char*)s;
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	eb 13                	jmp    4fe <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 4eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4ef:	8b 45 08             	mov    0x8(%ebp),%eax
 4f2:	0f b6 00             	movzbl (%eax),%eax
 4f5:	84 c0                	test   %al,%al
 4f7:	75 e2                	jne    4db <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 4f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4fe:	c9                   	leave  
 4ff:	c3                   	ret    

00000500 <gets>:

char*
gets(char *buf, int max)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 506:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 50d:	eb 42                	jmp    551 <gets+0x51>
    cc = read(0, &c, 1);
 50f:	83 ec 04             	sub    $0x4,%esp
 512:	6a 01                	push   $0x1
 514:	8d 45 ef             	lea    -0x11(%ebp),%eax
 517:	50                   	push   %eax
 518:	6a 00                	push   $0x0
 51a:	e8 8c 01 00 00       	call   6ab <read>
 51f:	83 c4 10             	add    $0x10,%esp
 522:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 525:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 529:	7e 33                	jle    55e <gets+0x5e>
      break;
    buf[i++] = c;
 52b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52e:	8d 50 01             	lea    0x1(%eax),%edx
 531:	89 55 f4             	mov    %edx,-0xc(%ebp)
 534:	89 c2                	mov    %eax,%edx
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	01 c2                	add    %eax,%edx
 53b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 53f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 541:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 545:	3c 0a                	cmp    $0xa,%al
 547:	74 16                	je     55f <gets+0x5f>
 549:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 54d:	3c 0d                	cmp    $0xd,%al
 54f:	74 0e                	je     55f <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 551:	8b 45 f4             	mov    -0xc(%ebp),%eax
 554:	83 c0 01             	add    $0x1,%eax
 557:	3b 45 0c             	cmp    0xc(%ebp),%eax
 55a:	7c b3                	jl     50f <gets+0xf>
 55c:	eb 01                	jmp    55f <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 55e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 55f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	01 d0                	add    %edx,%eax
 567:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 56d:	c9                   	leave  
 56e:	c3                   	ret    

0000056f <stat>:

int
stat(char *n, struct stat *st)
{
 56f:	55                   	push   %ebp
 570:	89 e5                	mov    %esp,%ebp
 572:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 575:	83 ec 08             	sub    $0x8,%esp
 578:	6a 00                	push   $0x0
 57a:	ff 75 08             	pushl  0x8(%ebp)
 57d:	e8 51 01 00 00       	call   6d3 <open>
 582:	83 c4 10             	add    $0x10,%esp
 585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58c:	79 07                	jns    595 <stat+0x26>
    return -1;
 58e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 593:	eb 25                	jmp    5ba <stat+0x4b>
  r = fstat(fd, st);
 595:	83 ec 08             	sub    $0x8,%esp
 598:	ff 75 0c             	pushl  0xc(%ebp)
 59b:	ff 75 f4             	pushl  -0xc(%ebp)
 59e:	e8 48 01 00 00       	call   6eb <fstat>
 5a3:	83 c4 10             	add    $0x10,%esp
 5a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 5a9:	83 ec 0c             	sub    $0xc,%esp
 5ac:	ff 75 f4             	pushl  -0xc(%ebp)
 5af:	e8 07 01 00 00       	call   6bb <close>
 5b4:	83 c4 10             	add    $0x10,%esp
  return r;
 5b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 5ba:	c9                   	leave  
 5bb:	c3                   	ret    

000005bc <atoi>:

int
atoi(const char *s)
{
 5bc:	55                   	push   %ebp
 5bd:	89 e5                	mov    %esp,%ebp
 5bf:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 5c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 5c9:	eb 04                	jmp    5cf <atoi+0x13>
 5cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	0f b6 00             	movzbl (%eax),%eax
 5d5:	3c 20                	cmp    $0x20,%al
 5d7:	74 f2                	je     5cb <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	0f b6 00             	movzbl (%eax),%eax
 5df:	3c 2d                	cmp    $0x2d,%al
 5e1:	75 07                	jne    5ea <atoi+0x2e>
 5e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5e8:	eb 05                	jmp    5ef <atoi+0x33>
 5ea:	b8 01 00 00 00       	mov    $0x1,%eax
 5ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
 5f5:	0f b6 00             	movzbl (%eax),%eax
 5f8:	3c 2b                	cmp    $0x2b,%al
 5fa:	74 0a                	je     606 <atoi+0x4a>
 5fc:	8b 45 08             	mov    0x8(%ebp),%eax
 5ff:	0f b6 00             	movzbl (%eax),%eax
 602:	3c 2d                	cmp    $0x2d,%al
 604:	75 2b                	jne    631 <atoi+0x75>
    s++;
 606:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 60a:	eb 25                	jmp    631 <atoi+0x75>
    n = n*10 + *s++ - '0';
 60c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 60f:	89 d0                	mov    %edx,%eax
 611:	c1 e0 02             	shl    $0x2,%eax
 614:	01 d0                	add    %edx,%eax
 616:	01 c0                	add    %eax,%eax
 618:	89 c1                	mov    %eax,%ecx
 61a:	8b 45 08             	mov    0x8(%ebp),%eax
 61d:	8d 50 01             	lea    0x1(%eax),%edx
 620:	89 55 08             	mov    %edx,0x8(%ebp)
 623:	0f b6 00             	movzbl (%eax),%eax
 626:	0f be c0             	movsbl %al,%eax
 629:	01 c8                	add    %ecx,%eax
 62b:	83 e8 30             	sub    $0x30,%eax
 62e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	0f b6 00             	movzbl (%eax),%eax
 637:	3c 2f                	cmp    $0x2f,%al
 639:	7e 0a                	jle    645 <atoi+0x89>
 63b:	8b 45 08             	mov    0x8(%ebp),%eax
 63e:	0f b6 00             	movzbl (%eax),%eax
 641:	3c 39                	cmp    $0x39,%al
 643:	7e c7                	jle    60c <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 64c:	c9                   	leave  
 64d:	c3                   	ret    

0000064e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 64e:	55                   	push   %ebp
 64f:	89 e5                	mov    %esp,%ebp
 651:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 654:	8b 45 08             	mov    0x8(%ebp),%eax
 657:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 65a:	8b 45 0c             	mov    0xc(%ebp),%eax
 65d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 660:	eb 17                	jmp    679 <memmove+0x2b>
    *dst++ = *src++;
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8d 50 01             	lea    0x1(%eax),%edx
 668:	89 55 fc             	mov    %edx,-0x4(%ebp)
 66b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 66e:	8d 4a 01             	lea    0x1(%edx),%ecx
 671:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 674:	0f b6 12             	movzbl (%edx),%edx
 677:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 679:	8b 45 10             	mov    0x10(%ebp),%eax
 67c:	8d 50 ff             	lea    -0x1(%eax),%edx
 67f:	89 55 10             	mov    %edx,0x10(%ebp)
 682:	85 c0                	test   %eax,%eax
 684:	7f dc                	jg     662 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 686:	8b 45 08             	mov    0x8(%ebp),%eax
}
 689:	c9                   	leave  
 68a:	c3                   	ret    

0000068b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 68b:	b8 01 00 00 00       	mov    $0x1,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <exit>:
SYSCALL(exit)
 693:	b8 02 00 00 00       	mov    $0x2,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <wait>:
SYSCALL(wait)
 69b:	b8 03 00 00 00       	mov    $0x3,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <pipe>:
SYSCALL(pipe)
 6a3:	b8 04 00 00 00       	mov    $0x4,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    

000006ab <read>:
SYSCALL(read)
 6ab:	b8 05 00 00 00       	mov    $0x5,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret    

000006b3 <write>:
SYSCALL(write)
 6b3:	b8 10 00 00 00       	mov    $0x10,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret    

000006bb <close>:
SYSCALL(close)
 6bb:	b8 15 00 00 00       	mov    $0x15,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret    

000006c3 <kill>:
SYSCALL(kill)
 6c3:	b8 06 00 00 00       	mov    $0x6,%eax
 6c8:	cd 40                	int    $0x40
 6ca:	c3                   	ret    

000006cb <exec>:
SYSCALL(exec)
 6cb:	b8 07 00 00 00       	mov    $0x7,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret    

000006d3 <open>:
SYSCALL(open)
 6d3:	b8 0f 00 00 00       	mov    $0xf,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret    

000006db <mknod>:
SYSCALL(mknod)
 6db:	b8 11 00 00 00       	mov    $0x11,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret    

000006e3 <unlink>:
SYSCALL(unlink)
 6e3:	b8 12 00 00 00       	mov    $0x12,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret    

000006eb <fstat>:
SYSCALL(fstat)
 6eb:	b8 08 00 00 00       	mov    $0x8,%eax
 6f0:	cd 40                	int    $0x40
 6f2:	c3                   	ret    

000006f3 <link>:
SYSCALL(link)
 6f3:	b8 13 00 00 00       	mov    $0x13,%eax
 6f8:	cd 40                	int    $0x40
 6fa:	c3                   	ret    

000006fb <mkdir>:
SYSCALL(mkdir)
 6fb:	b8 14 00 00 00       	mov    $0x14,%eax
 700:	cd 40                	int    $0x40
 702:	c3                   	ret    

00000703 <chdir>:
SYSCALL(chdir)
 703:	b8 09 00 00 00       	mov    $0x9,%eax
 708:	cd 40                	int    $0x40
 70a:	c3                   	ret    

0000070b <dup>:
SYSCALL(dup)
 70b:	b8 0a 00 00 00       	mov    $0xa,%eax
 710:	cd 40                	int    $0x40
 712:	c3                   	ret    

00000713 <getpid>:
SYSCALL(getpid)
 713:	b8 0b 00 00 00       	mov    $0xb,%eax
 718:	cd 40                	int    $0x40
 71a:	c3                   	ret    

0000071b <sbrk>:
SYSCALL(sbrk)
 71b:	b8 0c 00 00 00       	mov    $0xc,%eax
 720:	cd 40                	int    $0x40
 722:	c3                   	ret    

00000723 <sleep>:
SYSCALL(sleep)
 723:	b8 0d 00 00 00       	mov    $0xd,%eax
 728:	cd 40                	int    $0x40
 72a:	c3                   	ret    

0000072b <uptime>:
SYSCALL(uptime)
 72b:	b8 0e 00 00 00       	mov    $0xe,%eax
 730:	cd 40                	int    $0x40
 732:	c3                   	ret    

00000733 <halt>:
SYSCALL(halt)
 733:	b8 16 00 00 00       	mov    $0x16,%eax
 738:	cd 40                	int    $0x40
 73a:	c3                   	ret    

0000073b <date>:
SYSCALL(date)      #p1
 73b:	b8 17 00 00 00       	mov    $0x17,%eax
 740:	cd 40                	int    $0x40
 742:	c3                   	ret    

00000743 <getuid>:
SYSCALL(getuid)    #p2
 743:	b8 18 00 00 00       	mov    $0x18,%eax
 748:	cd 40                	int    $0x40
 74a:	c3                   	ret    

0000074b <getgid>:
SYSCALL(getgid)    #p2
 74b:	b8 19 00 00 00       	mov    $0x19,%eax
 750:	cd 40                	int    $0x40
 752:	c3                   	ret    

00000753 <getppid>:
SYSCALL(getppid)   #p2
 753:	b8 1a 00 00 00       	mov    $0x1a,%eax
 758:	cd 40                	int    $0x40
 75a:	c3                   	ret    

0000075b <setuid>:
SYSCALL(setuid)    #p2
 75b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 760:	cd 40                	int    $0x40
 762:	c3                   	ret    

00000763 <setgid>:
SYSCALL(setgid)    #p2
 763:	b8 1c 00 00 00       	mov    $0x1c,%eax
 768:	cd 40                	int    $0x40
 76a:	c3                   	ret    

0000076b <getprocs>:
SYSCALL(getprocs)  #p2
 76b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret    

00000773 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 773:	55                   	push   %ebp
 774:	89 e5                	mov    %esp,%ebp
 776:	83 ec 18             	sub    $0x18,%esp
 779:	8b 45 0c             	mov    0xc(%ebp),%eax
 77c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 77f:	83 ec 04             	sub    $0x4,%esp
 782:	6a 01                	push   $0x1
 784:	8d 45 f4             	lea    -0xc(%ebp),%eax
 787:	50                   	push   %eax
 788:	ff 75 08             	pushl  0x8(%ebp)
 78b:	e8 23 ff ff ff       	call   6b3 <write>
 790:	83 c4 10             	add    $0x10,%esp
}
 793:	90                   	nop
 794:	c9                   	leave  
 795:	c3                   	ret    

00000796 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 796:	55                   	push   %ebp
 797:	89 e5                	mov    %esp,%ebp
 799:	53                   	push   %ebx
 79a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 79d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7a4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7a8:	74 17                	je     7c1 <printint+0x2b>
 7aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7ae:	79 11                	jns    7c1 <printint+0x2b>
    neg = 1;
 7b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ba:	f7 d8                	neg    %eax
 7bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7bf:	eb 06                	jmp    7c7 <printint+0x31>
  } else {
    x = xx;
 7c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 7c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7ce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7d1:	8d 41 01             	lea    0x1(%ecx),%eax
 7d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7dd:	ba 00 00 00 00       	mov    $0x0,%edx
 7e2:	f7 f3                	div    %ebx
 7e4:	89 d0                	mov    %edx,%eax
 7e6:	0f b6 80 78 11 00 00 	movzbl 0x1178(%eax),%eax
 7ed:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f7:	ba 00 00 00 00       	mov    $0x0,%edx
 7fc:	f7 f3                	div    %ebx
 7fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
 801:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 805:	75 c7                	jne    7ce <printint+0x38>
  if(neg)
 807:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 80b:	74 2d                	je     83a <printint+0xa4>
    buf[i++] = '-';
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	8d 50 01             	lea    0x1(%eax),%edx
 813:	89 55 f4             	mov    %edx,-0xc(%ebp)
 816:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 81b:	eb 1d                	jmp    83a <printint+0xa4>
    putc(fd, buf[i]);
 81d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	01 d0                	add    %edx,%eax
 825:	0f b6 00             	movzbl (%eax),%eax
 828:	0f be c0             	movsbl %al,%eax
 82b:	83 ec 08             	sub    $0x8,%esp
 82e:	50                   	push   %eax
 82f:	ff 75 08             	pushl  0x8(%ebp)
 832:	e8 3c ff ff ff       	call   773 <putc>
 837:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 83a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 83e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 842:	79 d9                	jns    81d <printint+0x87>
    putc(fd, buf[i]);
}
 844:	90                   	nop
 845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 848:	c9                   	leave  
 849:	c3                   	ret    

0000084a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 84a:	55                   	push   %ebp
 84b:	89 e5                	mov    %esp,%ebp
 84d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 850:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 857:	8d 45 0c             	lea    0xc(%ebp),%eax
 85a:	83 c0 04             	add    $0x4,%eax
 85d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 860:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 867:	e9 59 01 00 00       	jmp    9c5 <printf+0x17b>
    c = fmt[i] & 0xff;
 86c:	8b 55 0c             	mov    0xc(%ebp),%edx
 86f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 872:	01 d0                	add    %edx,%eax
 874:	0f b6 00             	movzbl (%eax),%eax
 877:	0f be c0             	movsbl %al,%eax
 87a:	25 ff 00 00 00       	and    $0xff,%eax
 87f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 882:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 886:	75 2c                	jne    8b4 <printf+0x6a>
      if(c == '%'){
 888:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 88c:	75 0c                	jne    89a <printf+0x50>
        state = '%';
 88e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 895:	e9 27 01 00 00       	jmp    9c1 <printf+0x177>
      } else {
        putc(fd, c);
 89a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 89d:	0f be c0             	movsbl %al,%eax
 8a0:	83 ec 08             	sub    $0x8,%esp
 8a3:	50                   	push   %eax
 8a4:	ff 75 08             	pushl  0x8(%ebp)
 8a7:	e8 c7 fe ff ff       	call   773 <putc>
 8ac:	83 c4 10             	add    $0x10,%esp
 8af:	e9 0d 01 00 00       	jmp    9c1 <printf+0x177>
      }
    } else if(state == '%'){
 8b4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8b8:	0f 85 03 01 00 00    	jne    9c1 <printf+0x177>
      if(c == 'd'){
 8be:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8c2:	75 1e                	jne    8e2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 8c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8c7:	8b 00                	mov    (%eax),%eax
 8c9:	6a 01                	push   $0x1
 8cb:	6a 0a                	push   $0xa
 8cd:	50                   	push   %eax
 8ce:	ff 75 08             	pushl  0x8(%ebp)
 8d1:	e8 c0 fe ff ff       	call   796 <printint>
 8d6:	83 c4 10             	add    $0x10,%esp
        ap++;
 8d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8dd:	e9 d8 00 00 00       	jmp    9ba <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 8e2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8e6:	74 06                	je     8ee <printf+0xa4>
 8e8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8ec:	75 1e                	jne    90c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 8ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	6a 00                	push   $0x0
 8f5:	6a 10                	push   $0x10
 8f7:	50                   	push   %eax
 8f8:	ff 75 08             	pushl  0x8(%ebp)
 8fb:	e8 96 fe ff ff       	call   796 <printint>
 900:	83 c4 10             	add    $0x10,%esp
        ap++;
 903:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 907:	e9 ae 00 00 00       	jmp    9ba <printf+0x170>
      } else if(c == 's'){
 90c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 910:	75 43                	jne    955 <printf+0x10b>
        s = (char*)*ap;
 912:	8b 45 e8             	mov    -0x18(%ebp),%eax
 915:	8b 00                	mov    (%eax),%eax
 917:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 91a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 91e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 922:	75 25                	jne    949 <printf+0xff>
          s = "(null)";
 924:	c7 45 f4 84 0e 00 00 	movl   $0xe84,-0xc(%ebp)
        while(*s != 0){
 92b:	eb 1c                	jmp    949 <printf+0xff>
          putc(fd, *s);
 92d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 930:	0f b6 00             	movzbl (%eax),%eax
 933:	0f be c0             	movsbl %al,%eax
 936:	83 ec 08             	sub    $0x8,%esp
 939:	50                   	push   %eax
 93a:	ff 75 08             	pushl  0x8(%ebp)
 93d:	e8 31 fe ff ff       	call   773 <putc>
 942:	83 c4 10             	add    $0x10,%esp
          s++;
 945:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	0f b6 00             	movzbl (%eax),%eax
 94f:	84 c0                	test   %al,%al
 951:	75 da                	jne    92d <printf+0xe3>
 953:	eb 65                	jmp    9ba <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 955:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 959:	75 1d                	jne    978 <printf+0x12e>
        putc(fd, *ap);
 95b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 95e:	8b 00                	mov    (%eax),%eax
 960:	0f be c0             	movsbl %al,%eax
 963:	83 ec 08             	sub    $0x8,%esp
 966:	50                   	push   %eax
 967:	ff 75 08             	pushl  0x8(%ebp)
 96a:	e8 04 fe ff ff       	call   773 <putc>
 96f:	83 c4 10             	add    $0x10,%esp
        ap++;
 972:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 976:	eb 42                	jmp    9ba <printf+0x170>
      } else if(c == '%'){
 978:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 97c:	75 17                	jne    995 <printf+0x14b>
        putc(fd, c);
 97e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 981:	0f be c0             	movsbl %al,%eax
 984:	83 ec 08             	sub    $0x8,%esp
 987:	50                   	push   %eax
 988:	ff 75 08             	pushl  0x8(%ebp)
 98b:	e8 e3 fd ff ff       	call   773 <putc>
 990:	83 c4 10             	add    $0x10,%esp
 993:	eb 25                	jmp    9ba <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 995:	83 ec 08             	sub    $0x8,%esp
 998:	6a 25                	push   $0x25
 99a:	ff 75 08             	pushl  0x8(%ebp)
 99d:	e8 d1 fd ff ff       	call   773 <putc>
 9a2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 9a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9a8:	0f be c0             	movsbl %al,%eax
 9ab:	83 ec 08             	sub    $0x8,%esp
 9ae:	50                   	push   %eax
 9af:	ff 75 08             	pushl  0x8(%ebp)
 9b2:	e8 bc fd ff ff       	call   773 <putc>
 9b7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9c1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 9c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cb:	01 d0                	add    %edx,%eax
 9cd:	0f b6 00             	movzbl (%eax),%eax
 9d0:	84 c0                	test   %al,%al
 9d2:	0f 85 94 fe ff ff    	jne    86c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9d8:	90                   	nop
 9d9:	c9                   	leave  
 9da:	c3                   	ret    

000009db <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9db:	55                   	push   %ebp
 9dc:	89 e5                	mov    %esp,%ebp
 9de:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9e1:	8b 45 08             	mov    0x8(%ebp),%eax
 9e4:	83 e8 08             	sub    $0x8,%eax
 9e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ea:	a1 94 11 00 00       	mov    0x1194,%eax
 9ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9f2:	eb 24                	jmp    a18 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f7:	8b 00                	mov    (%eax),%eax
 9f9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9fc:	77 12                	ja     a10 <free+0x35>
 9fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a01:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a04:	77 24                	ja     a2a <free+0x4f>
 a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a09:	8b 00                	mov    (%eax),%eax
 a0b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a0e:	77 1a                	ja     a2a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a10:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a13:	8b 00                	mov    (%eax),%eax
 a15:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a1e:	76 d4                	jbe    9f4 <free+0x19>
 a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a23:	8b 00                	mov    (%eax),%eax
 a25:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a28:	76 ca                	jbe    9f4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2d:	8b 40 04             	mov    0x4(%eax),%eax
 a30:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a37:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3a:	01 c2                	add    %eax,%edx
 a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3f:	8b 00                	mov    (%eax),%eax
 a41:	39 c2                	cmp    %eax,%edx
 a43:	75 24                	jne    a69 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a45:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a48:	8b 50 04             	mov    0x4(%eax),%edx
 a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4e:	8b 00                	mov    (%eax),%eax
 a50:	8b 40 04             	mov    0x4(%eax),%eax
 a53:	01 c2                	add    %eax,%edx
 a55:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a58:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5e:	8b 00                	mov    (%eax),%eax
 a60:	8b 10                	mov    (%eax),%edx
 a62:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a65:	89 10                	mov    %edx,(%eax)
 a67:	eb 0a                	jmp    a73 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6c:	8b 10                	mov    (%eax),%edx
 a6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a71:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a76:	8b 40 04             	mov    0x4(%eax),%eax
 a79:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a83:	01 d0                	add    %edx,%eax
 a85:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a88:	75 20                	jne    aaa <free+0xcf>
    p->s.size += bp->s.size;
 a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8d:	8b 50 04             	mov    0x4(%eax),%edx
 a90:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a93:	8b 40 04             	mov    0x4(%eax),%eax
 a96:	01 c2                	add    %eax,%edx
 a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa1:	8b 10                	mov    (%eax),%edx
 aa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa6:	89 10                	mov    %edx,(%eax)
 aa8:	eb 08                	jmp    ab2 <free+0xd7>
  } else
    p->s.ptr = bp;
 aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aad:	8b 55 f8             	mov    -0x8(%ebp),%edx
 ab0:	89 10                	mov    %edx,(%eax)
  freep = p;
 ab2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab5:	a3 94 11 00 00       	mov    %eax,0x1194
}
 aba:	90                   	nop
 abb:	c9                   	leave  
 abc:	c3                   	ret    

00000abd <morecore>:

static Header*
morecore(uint nu)
{
 abd:	55                   	push   %ebp
 abe:	89 e5                	mov    %esp,%ebp
 ac0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ac3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 aca:	77 07                	ja     ad3 <morecore+0x16>
    nu = 4096;
 acc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ad3:	8b 45 08             	mov    0x8(%ebp),%eax
 ad6:	c1 e0 03             	shl    $0x3,%eax
 ad9:	83 ec 0c             	sub    $0xc,%esp
 adc:	50                   	push   %eax
 add:	e8 39 fc ff ff       	call   71b <sbrk>
 ae2:	83 c4 10             	add    $0x10,%esp
 ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 ae8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 aec:	75 07                	jne    af5 <morecore+0x38>
    return 0;
 aee:	b8 00 00 00 00       	mov    $0x0,%eax
 af3:	eb 26                	jmp    b1b <morecore+0x5e>
  hp = (Header*)p;
 af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 afe:	8b 55 08             	mov    0x8(%ebp),%edx
 b01:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b07:	83 c0 08             	add    $0x8,%eax
 b0a:	83 ec 0c             	sub    $0xc,%esp
 b0d:	50                   	push   %eax
 b0e:	e8 c8 fe ff ff       	call   9db <free>
 b13:	83 c4 10             	add    $0x10,%esp
  return freep;
 b16:	a1 94 11 00 00       	mov    0x1194,%eax
}
 b1b:	c9                   	leave  
 b1c:	c3                   	ret    

00000b1d <malloc>:

void*
malloc(uint nbytes)
{
 b1d:	55                   	push   %ebp
 b1e:	89 e5                	mov    %esp,%ebp
 b20:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b23:	8b 45 08             	mov    0x8(%ebp),%eax
 b26:	83 c0 07             	add    $0x7,%eax
 b29:	c1 e8 03             	shr    $0x3,%eax
 b2c:	83 c0 01             	add    $0x1,%eax
 b2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b32:	a1 94 11 00 00       	mov    0x1194,%eax
 b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b3e:	75 23                	jne    b63 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b40:	c7 45 f0 8c 11 00 00 	movl   $0x118c,-0x10(%ebp)
 b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4a:	a3 94 11 00 00       	mov    %eax,0x1194
 b4f:	a1 94 11 00 00       	mov    0x1194,%eax
 b54:	a3 8c 11 00 00       	mov    %eax,0x118c
    base.s.size = 0;
 b59:	c7 05 90 11 00 00 00 	movl   $0x0,0x1190
 b60:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b66:	8b 00                	mov    (%eax),%eax
 b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b6e:	8b 40 04             	mov    0x4(%eax),%eax
 b71:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b74:	72 4d                	jb     bc3 <malloc+0xa6>
      if(p->s.size == nunits)
 b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b79:	8b 40 04             	mov    0x4(%eax),%eax
 b7c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b7f:	75 0c                	jne    b8d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b84:	8b 10                	mov    (%eax),%edx
 b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b89:	89 10                	mov    %edx,(%eax)
 b8b:	eb 26                	jmp    bb3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b90:	8b 40 04             	mov    0x4(%eax),%eax
 b93:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b96:	89 c2                	mov    %eax,%edx
 b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba1:	8b 40 04             	mov    0x4(%eax),%eax
 ba4:	c1 e0 03             	shl    $0x3,%eax
 ba7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bad:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bb0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb6:	a3 94 11 00 00       	mov    %eax,0x1194
      return (void*)(p + 1);
 bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bbe:	83 c0 08             	add    $0x8,%eax
 bc1:	eb 3b                	jmp    bfe <malloc+0xe1>
    }
    if(p == freep)
 bc3:	a1 94 11 00 00       	mov    0x1194,%eax
 bc8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bcb:	75 1e                	jne    beb <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 bcd:	83 ec 0c             	sub    $0xc,%esp
 bd0:	ff 75 ec             	pushl  -0x14(%ebp)
 bd3:	e8 e5 fe ff ff       	call   abd <morecore>
 bd8:	83 c4 10             	add    $0x10,%esp
 bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 be2:	75 07                	jne    beb <malloc+0xce>
        return 0;
 be4:	b8 00 00 00 00       	mov    $0x0,%eax
 be9:	eb 13                	jmp    bfe <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf4:	8b 00                	mov    (%eax),%eax
 bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 bf9:	e9 6d ff ff ff       	jmp    b6b <malloc+0x4e>
}
 bfe:	c9                   	leave  
 bff:	c3                   	ret    
