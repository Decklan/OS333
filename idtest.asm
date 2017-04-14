
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
   6:	e8 f3 06 00 00       	call   6fe <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 b4 0b 00 00       	push   $0xbb4
  19:	6a 01                	push   $0x1
  1b:	e8 dd 07 00 00       	call   7fd <printf>
  20:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to %d\n", nval);
  23:	83 ec 04             	sub    $0x4,%esp
  26:	ff 75 08             	pushl  0x8(%ebp)
  29:	68 c8 0b 00 00       	push   $0xbc8
  2e:	6a 01                	push   $0x1
  30:	e8 c8 07 00 00       	call   7fd <printf>
  35:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	ff 75 08             	pushl  0x8(%ebp)
  3e:	e8 d3 06 00 00       	call   716 <setuid>
  43:	83 c4 10             	add    $0x10,%esp
  46:	85 c0                	test   %eax,%eax
  48:	79 15                	jns    5f <uidTest+0x5f>
    printf(2, "Error. Invalid UID: %d\n", nval);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 08             	pushl  0x8(%ebp)
  50:	68 db 0b 00 00       	push   $0xbdb
  55:	6a 02                	push   $0x2
  57:	e8 a1 07 00 00       	call   7fd <printf>
  5c:	83 c4 10             	add    $0x10,%esp
  setuid(nval);
  5f:	83 ec 0c             	sub    $0xc,%esp
  62:	ff 75 08             	pushl  0x8(%ebp)
  65:	e8 ac 06 00 00       	call   716 <setuid>
  6a:	83 c4 10             	add    $0x10,%esp
  uid = getuid();
  6d:	e8 8c 06 00 00       	call   6fe <getuid>
  72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  75:	83 ec 04             	sub    $0x4,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	68 b4 0b 00 00       	push   $0xbb4
  80:	6a 01                	push   $0x1
  82:	e8 76 07 00 00       	call   7fd <printf>
  87:	83 c4 10             	add    $0x10,%esp
  sleep(5 * TPS); // now type control-p
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	6a 32                	push   $0x32
  8f:	e8 4a 06 00 00       	call   6de <sleep>
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
  a0:	e8 61 06 00 00       	call   706 <getgid>
  a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current GID is: %d\n", gid);
  a8:	83 ec 04             	sub    $0x4,%esp
  ab:	ff 75 f4             	pushl  -0xc(%ebp)
  ae:	68 f3 0b 00 00       	push   $0xbf3
  b3:	6a 01                	push   $0x1
  b5:	e8 43 07 00 00       	call   7fd <printf>
  ba:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to %d\n", nval);
  bd:	83 ec 04             	sub    $0x4,%esp
  c0:	ff 75 08             	pushl  0x8(%ebp)
  c3:	68 07 0c 00 00       	push   $0xc07
  c8:	6a 01                	push   $0x1
  ca:	e8 2e 07 00 00       	call   7fd <printf>
  cf:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
  d2:	83 ec 0c             	sub    $0xc,%esp
  d5:	ff 75 08             	pushl  0x8(%ebp)
  d8:	e8 41 06 00 00       	call   71e <setgid>
  dd:	83 c4 10             	add    $0x10,%esp
  e0:	85 c0                	test   %eax,%eax
  e2:	79 15                	jns    f9 <gidTest+0x5f>
    printf(2, "Error. Invalid GID: %d\n", nval);
  e4:	83 ec 04             	sub    $0x4,%esp
  e7:	ff 75 08             	pushl  0x8(%ebp)
  ea:	68 1a 0c 00 00       	push   $0xc1a
  ef:	6a 02                	push   $0x2
  f1:	e8 07 07 00 00       	call   7fd <printf>
  f6:	83 c4 10             	add    $0x10,%esp
  setgid(nval);
  f9:	83 ec 0c             	sub    $0xc,%esp
  fc:	ff 75 08             	pushl  0x8(%ebp)
  ff:	e8 1a 06 00 00       	call   71e <setgid>
 104:	83 c4 10             	add    $0x10,%esp
  gid = getgid();
 107:	e8 fa 05 00 00       	call   706 <getgid>
 10c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 10f:	83 ec 04             	sub    $0x4,%esp
 112:	ff 75 f4             	pushl  -0xc(%ebp)
 115:	68 f3 0b 00 00       	push   $0xbf3
 11a:	6a 01                	push   $0x1
 11c:	e8 dc 06 00 00       	call   7fd <printf>
 121:	83 c4 10             	add    $0x10,%esp
  sleep(5 * TPS); // now type control-p
 124:	83 ec 0c             	sub    $0xc,%esp
 127:	6a 32                	push   $0x32
 129:	e8 b0 05 00 00       	call   6de <sleep>
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
 141:	68 34 0c 00 00       	push   $0xc34
 146:	6a 01                	push   $0x1
 148:	e8 b0 06 00 00       	call   7fd <printf>
 14d:	83 c4 10             	add    $0x10,%esp
                  " should be inherited\n", nval, nval);

  if (setuid(nval) < 0)
 150:	83 ec 0c             	sub    $0xc,%esp
 153:	ff 75 08             	pushl  0x8(%ebp)
 156:	e8 bb 05 00 00       	call   716 <setuid>
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	85 c0                	test   %eax,%eax
 160:	79 15                	jns    177 <forkTest+0x43>
    printf(2, "Error.Invalid UID: %d\n", nval);
 162:	83 ec 04             	sub    $0x4,%esp
 165:	ff 75 08             	pushl  0x8(%ebp)
 168:	68 7e 0c 00 00       	push   $0xc7e
 16d:	6a 02                	push   $0x2
 16f:	e8 89 06 00 00       	call   7fd <printf>
 174:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 177:	83 ec 0c             	sub    $0xc,%esp
 17a:	ff 75 08             	pushl  0x8(%ebp)
 17d:	e8 9c 05 00 00       	call   71e <setgid>
 182:	83 c4 10             	add    $0x10,%esp
 185:	85 c0                	test   %eax,%eax
 187:	79 15                	jns    19e <forkTest+0x6a>
    printf(2, "Error.Invalid GID: %d\n", nval);
 189:	83 ec 04             	sub    $0x4,%esp
 18c:	ff 75 08             	pushl  0x8(%ebp)
 18f:	68 95 0c 00 00       	push   $0xc95
 194:	6a 02                	push   $0x2
 196:	e8 62 06 00 00       	call   7fd <printf>
 19b:	83 c4 10             	add    $0x10,%esp
  
  printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getgid());
 19e:	e8 63 05 00 00       	call   706 <getgid>
 1a3:	89 c3                	mov    %eax,%ebx
 1a5:	e8 54 05 00 00       	call   6fe <getuid>
 1aa:	53                   	push   %ebx
 1ab:	50                   	push   %eax
 1ac:	68 ac 0c 00 00       	push   $0xcac
 1b1:	6a 01                	push   $0x1
 1b3:	e8 45 06 00 00       	call   7fd <printf>
 1b8:	83 c4 10             	add    $0x10,%esp
  pid = fork();
 1bb:	e8 86 04 00 00       	call   646 <fork>
 1c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (pid == 0) {  // child
 1c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c7:	75 37                	jne    200 <forkTest+0xcc>
    uid = getuid();
 1c9:	e8 30 05 00 00       	call   6fe <getuid>
 1ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    gid = getgid();
 1d1:	e8 30 05 00 00       	call   706 <getgid>
 1d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1, "Child: UID is: %d, GID is: %d\n", uid, gid);
 1d9:	ff 75 ec             	pushl  -0x14(%ebp)
 1dc:	ff 75 f0             	pushl  -0x10(%ebp)
 1df:	68 d0 0c 00 00       	push   $0xcd0
 1e4:	6a 01                	push   $0x1
 1e6:	e8 12 06 00 00       	call   7fd <printf>
 1eb:	83 c4 10             	add    $0x10,%esp
    sleep(5 * TPS);  // now type control-p
 1ee:	83 ec 0c             	sub    $0xc,%esp
 1f1:	6a 32                	push   $0x32
 1f3:	e8 e6 04 00 00       	call   6de <sleep>
 1f8:	83 c4 10             	add    $0x10,%esp
    exit();
 1fb:	e8 4e 04 00 00       	call   64e <exit>
  }
  else
    sleep(10 * TPS);
 200:	83 ec 0c             	sub    $0xc,%esp
 203:	6a 64                	push   $0x64
 205:	e8 d4 04 00 00       	call   6de <sleep>
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
 21f:	68 f0 0c 00 00       	push   $0xcf0
 224:	6a 01                	push   $0x1
 226:	e8 d2 05 00 00       	call   7fd <printf>
 22b:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
 22e:	83 ec 0c             	sub    $0xc,%esp
 231:	ff 75 08             	pushl  0x8(%ebp)
 234:	e8 dd 04 00 00       	call   716 <setuid>
 239:	83 c4 10             	add    $0x10,%esp
 23c:	85 c0                	test   %eax,%eax
 23e:	79 14                	jns    254 <invalidTest+0x41>
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
 240:	83 ec 08             	sub    $0x8,%esp
 243:	68 1c 0d 00 00       	push   $0xd1c
 248:	6a 01                	push   $0x1
 24a:	e8 ae 05 00 00       	call   7fd <printf>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	eb 12                	jmp    266 <invalidTest+0x53>
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");
 254:	83 ec 08             	sub    $0x8,%esp
 257:	68 50 0d 00 00       	push   $0xd50
 25c:	6a 02                	push   $0x2
 25e:	e8 9a 05 00 00       	call   7fd <printf>
 263:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", nval);
 266:	83 ec 04             	sub    $0x4,%esp
 269:	ff 75 08             	pushl  0x8(%ebp)
 26c:	68 84 0d 00 00       	push   $0xd84
 271:	6a 01                	push   $0x1
 273:	e8 85 05 00 00       	call   7fd <printf>
 278:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 27b:	83 ec 0c             	sub    $0xc,%esp
 27e:	ff 75 08             	pushl  0x8(%ebp)
 281:	e8 98 04 00 00       	call   71e <setgid>
 286:	83 c4 10             	add    $0x10,%esp
 289:	85 c0                	test   %eax,%eax
 28b:	79 14                	jns    2a1 <invalidTest+0x8e>
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	68 b0 0d 00 00       	push   $0xdb0
 295:	6a 01                	push   $0x1
 297:	e8 61 05 00 00       	call   7fd <printf>
 29c:	83 c4 10             	add    $0x10,%esp
 29f:	eb 12                	jmp    2b3 <invalidTest+0xa0>
  else
    printf(2, "FAILURE! The setgid system call indicates success\n");
 2a1:	83 ec 08             	sub    $0x8,%esp
 2a4:	68 e4 0d 00 00       	push   $0xde4
 2a9:	6a 02                	push   $0x2
 2ab:	e8 4d 05 00 00       	call   7fd <printf>
 2b0:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting UID to %d. This test should FAIL\n", -1);
 2b3:	83 ec 04             	sub    $0x4,%esp
 2b6:	6a ff                	push   $0xffffffff
 2b8:	68 f0 0c 00 00       	push   $0xcf0
 2bd:	6a 01                	push   $0x1
 2bf:	e8 39 05 00 00       	call   7fd <printf>
 2c4:	83 c4 10             	add    $0x10,%esp
  if (setuid(-1) < 0)
 2c7:	83 ec 0c             	sub    $0xc,%esp
 2ca:	6a ff                	push   $0xffffffff
 2cc:	e8 45 04 00 00       	call   716 <setuid>
 2d1:	83 c4 10             	add    $0x10,%esp
 2d4:	85 c0                	test   %eax,%eax
 2d6:	79 14                	jns    2ec <invalidTest+0xd9>
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
 2d8:	83 ec 08             	sub    $0x8,%esp
 2db:	68 1c 0d 00 00       	push   $0xd1c
 2e0:	6a 01                	push   $0x1
 2e2:	e8 16 05 00 00       	call   7fd <printf>
 2e7:	83 c4 10             	add    $0x10,%esp
 2ea:	eb 12                	jmp    2fe <invalidTest+0xeb>
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");
 2ec:	83 ec 08             	sub    $0x8,%esp
 2ef:	68 50 0d 00 00       	push   $0xd50
 2f4:	6a 02                	push   $0x2
 2f6:	e8 02 05 00 00       	call   7fd <printf>
 2fb:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", -1);
 2fe:	83 ec 04             	sub    $0x4,%esp
 301:	6a ff                	push   $0xffffffff
 303:	68 84 0d 00 00       	push   $0xd84
 308:	6a 01                	push   $0x1
 30a:	e8 ee 04 00 00       	call   7fd <printf>
 30f:	83 c4 10             	add    $0x10,%esp
  if (setgid(-1) < 0)
 312:	83 ec 0c             	sub    $0xc,%esp
 315:	6a ff                	push   $0xffffffff
 317:	e8 02 04 00 00       	call   71e <setgid>
 31c:	83 c4 10             	add    $0x10,%esp
 31f:	85 c0                	test   %eax,%eax
 321:	79 14                	jns    337 <invalidTest+0x124>
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
 323:	83 ec 08             	sub    $0x8,%esp
 326:	68 b0 0d 00 00       	push   $0xdb0
 32b:	6a 01                	push   $0x1
 32d:	e8 cb 04 00 00       	call   7fd <printf>
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
 33a:	68 e4 0d 00 00       	push   $0xde4
 33f:	6a 02                	push   $0x2
 341:	e8 b7 04 00 00       	call   7fd <printf>
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
 37c:	e8 8d 03 00 00       	call   70e <getppid>
 381:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "My parent process is: %d\n", ppid);
 384:	83 ec 04             	sub    $0x4,%esp
 387:	ff 75 f0             	pushl  -0x10(%ebp)
 38a:	68 17 0e 00 00       	push   $0xe17
 38f:	6a 01                	push   $0x1
 391:	e8 67 04 00 00       	call   7fd <printf>
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
 3c6:	68 31 0e 00 00       	push   $0xe31
 3cb:	6a 01                	push   $0x1
 3cd:	e8 2b 04 00 00       	call   7fd <printf>
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
 3f2:	e8 57 02 00 00       	call   64e <exit>

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
 51a:	e8 47 01 00 00       	call   666 <read>
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
 57d:	e8 0c 01 00 00       	call   68e <open>
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
 59e:	e8 03 01 00 00       	call   6a6 <fstat>
 5a3:	83 c4 10             	add    $0x10,%esp
 5a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 5a9:	83 ec 0c             	sub    $0xc,%esp
 5ac:	ff 75 f4             	pushl  -0xc(%ebp)
 5af:	e8 c2 00 00 00       	call   676 <close>
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
  int n;

  n = 0;
 5c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 5c9:	eb 25                	jmp    5f0 <atoi+0x34>
    n = n*10 + *s++ - '0';
 5cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5ce:	89 d0                	mov    %edx,%eax
 5d0:	c1 e0 02             	shl    $0x2,%eax
 5d3:	01 d0                	add    %edx,%eax
 5d5:	01 c0                	add    %eax,%eax
 5d7:	89 c1                	mov    %eax,%ecx
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	8d 50 01             	lea    0x1(%eax),%edx
 5df:	89 55 08             	mov    %edx,0x8(%ebp)
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	01 c8                	add    %ecx,%eax
 5ea:	83 e8 30             	sub    $0x30,%eax
 5ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5f0:	8b 45 08             	mov    0x8(%ebp),%eax
 5f3:	0f b6 00             	movzbl (%eax),%eax
 5f6:	3c 2f                	cmp    $0x2f,%al
 5f8:	7e 0a                	jle    604 <atoi+0x48>
 5fa:	8b 45 08             	mov    0x8(%ebp),%eax
 5fd:	0f b6 00             	movzbl (%eax),%eax
 600:	3c 39                	cmp    $0x39,%al
 602:	7e c7                	jle    5cb <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 604:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 607:	c9                   	leave  
 608:	c3                   	ret    

00000609 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 609:	55                   	push   %ebp
 60a:	89 e5                	mov    %esp,%ebp
 60c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 615:	8b 45 0c             	mov    0xc(%ebp),%eax
 618:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 61b:	eb 17                	jmp    634 <memmove+0x2b>
    *dst++ = *src++;
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8d 50 01             	lea    0x1(%eax),%edx
 623:	89 55 fc             	mov    %edx,-0x4(%ebp)
 626:	8b 55 f8             	mov    -0x8(%ebp),%edx
 629:	8d 4a 01             	lea    0x1(%edx),%ecx
 62c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 62f:	0f b6 12             	movzbl (%edx),%edx
 632:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 634:	8b 45 10             	mov    0x10(%ebp),%eax
 637:	8d 50 ff             	lea    -0x1(%eax),%edx
 63a:	89 55 10             	mov    %edx,0x10(%ebp)
 63d:	85 c0                	test   %eax,%eax
 63f:	7f dc                	jg     61d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 641:	8b 45 08             	mov    0x8(%ebp),%eax
}
 644:	c9                   	leave  
 645:	c3                   	ret    

00000646 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 646:	b8 01 00 00 00       	mov    $0x1,%eax
 64b:	cd 40                	int    $0x40
 64d:	c3                   	ret    

0000064e <exit>:
SYSCALL(exit)
 64e:	b8 02 00 00 00       	mov    $0x2,%eax
 653:	cd 40                	int    $0x40
 655:	c3                   	ret    

00000656 <wait>:
SYSCALL(wait)
 656:	b8 03 00 00 00       	mov    $0x3,%eax
 65b:	cd 40                	int    $0x40
 65d:	c3                   	ret    

0000065e <pipe>:
SYSCALL(pipe)
 65e:	b8 04 00 00 00       	mov    $0x4,%eax
 663:	cd 40                	int    $0x40
 665:	c3                   	ret    

00000666 <read>:
SYSCALL(read)
 666:	b8 05 00 00 00       	mov    $0x5,%eax
 66b:	cd 40                	int    $0x40
 66d:	c3                   	ret    

0000066e <write>:
SYSCALL(write)
 66e:	b8 10 00 00 00       	mov    $0x10,%eax
 673:	cd 40                	int    $0x40
 675:	c3                   	ret    

00000676 <close>:
SYSCALL(close)
 676:	b8 15 00 00 00       	mov    $0x15,%eax
 67b:	cd 40                	int    $0x40
 67d:	c3                   	ret    

0000067e <kill>:
SYSCALL(kill)
 67e:	b8 06 00 00 00       	mov    $0x6,%eax
 683:	cd 40                	int    $0x40
 685:	c3                   	ret    

00000686 <exec>:
SYSCALL(exec)
 686:	b8 07 00 00 00       	mov    $0x7,%eax
 68b:	cd 40                	int    $0x40
 68d:	c3                   	ret    

0000068e <open>:
SYSCALL(open)
 68e:	b8 0f 00 00 00       	mov    $0xf,%eax
 693:	cd 40                	int    $0x40
 695:	c3                   	ret    

00000696 <mknod>:
SYSCALL(mknod)
 696:	b8 11 00 00 00       	mov    $0x11,%eax
 69b:	cd 40                	int    $0x40
 69d:	c3                   	ret    

0000069e <unlink>:
SYSCALL(unlink)
 69e:	b8 12 00 00 00       	mov    $0x12,%eax
 6a3:	cd 40                	int    $0x40
 6a5:	c3                   	ret    

000006a6 <fstat>:
SYSCALL(fstat)
 6a6:	b8 08 00 00 00       	mov    $0x8,%eax
 6ab:	cd 40                	int    $0x40
 6ad:	c3                   	ret    

000006ae <link>:
SYSCALL(link)
 6ae:	b8 13 00 00 00       	mov    $0x13,%eax
 6b3:	cd 40                	int    $0x40
 6b5:	c3                   	ret    

000006b6 <mkdir>:
SYSCALL(mkdir)
 6b6:	b8 14 00 00 00       	mov    $0x14,%eax
 6bb:	cd 40                	int    $0x40
 6bd:	c3                   	ret    

000006be <chdir>:
SYSCALL(chdir)
 6be:	b8 09 00 00 00       	mov    $0x9,%eax
 6c3:	cd 40                	int    $0x40
 6c5:	c3                   	ret    

000006c6 <dup>:
SYSCALL(dup)
 6c6:	b8 0a 00 00 00       	mov    $0xa,%eax
 6cb:	cd 40                	int    $0x40
 6cd:	c3                   	ret    

000006ce <getpid>:
SYSCALL(getpid)
 6ce:	b8 0b 00 00 00       	mov    $0xb,%eax
 6d3:	cd 40                	int    $0x40
 6d5:	c3                   	ret    

000006d6 <sbrk>:
SYSCALL(sbrk)
 6d6:	b8 0c 00 00 00       	mov    $0xc,%eax
 6db:	cd 40                	int    $0x40
 6dd:	c3                   	ret    

000006de <sleep>:
SYSCALL(sleep)
 6de:	b8 0d 00 00 00       	mov    $0xd,%eax
 6e3:	cd 40                	int    $0x40
 6e5:	c3                   	ret    

000006e6 <uptime>:
SYSCALL(uptime)
 6e6:	b8 0e 00 00 00       	mov    $0xe,%eax
 6eb:	cd 40                	int    $0x40
 6ed:	c3                   	ret    

000006ee <halt>:
SYSCALL(halt)
 6ee:	b8 16 00 00 00       	mov    $0x16,%eax
 6f3:	cd 40                	int    $0x40
 6f5:	c3                   	ret    

000006f6 <date>:
SYSCALL(date)    #p1
 6f6:	b8 17 00 00 00       	mov    $0x17,%eax
 6fb:	cd 40                	int    $0x40
 6fd:	c3                   	ret    

000006fe <getuid>:
SYSCALL(getuid)  #p2
 6fe:	b8 18 00 00 00       	mov    $0x18,%eax
 703:	cd 40                	int    $0x40
 705:	c3                   	ret    

00000706 <getgid>:
SYSCALL(getgid)  #p2
 706:	b8 19 00 00 00       	mov    $0x19,%eax
 70b:	cd 40                	int    $0x40
 70d:	c3                   	ret    

0000070e <getppid>:
SYSCALL(getppid) #p2
 70e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 713:	cd 40                	int    $0x40
 715:	c3                   	ret    

00000716 <setuid>:
SYSCALL(setuid)  #p2
 716:	b8 1b 00 00 00       	mov    $0x1b,%eax
 71b:	cd 40                	int    $0x40
 71d:	c3                   	ret    

0000071e <setgid>:
SYSCALL(setgid)  #p2
 71e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 723:	cd 40                	int    $0x40
 725:	c3                   	ret    

00000726 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 726:	55                   	push   %ebp
 727:	89 e5                	mov    %esp,%ebp
 729:	83 ec 18             	sub    $0x18,%esp
 72c:	8b 45 0c             	mov    0xc(%ebp),%eax
 72f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 732:	83 ec 04             	sub    $0x4,%esp
 735:	6a 01                	push   $0x1
 737:	8d 45 f4             	lea    -0xc(%ebp),%eax
 73a:	50                   	push   %eax
 73b:	ff 75 08             	pushl  0x8(%ebp)
 73e:	e8 2b ff ff ff       	call   66e <write>
 743:	83 c4 10             	add    $0x10,%esp
}
 746:	90                   	nop
 747:	c9                   	leave  
 748:	c3                   	ret    

00000749 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 749:	55                   	push   %ebp
 74a:	89 e5                	mov    %esp,%ebp
 74c:	53                   	push   %ebx
 74d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 750:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 757:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 75b:	74 17                	je     774 <printint+0x2b>
 75d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 761:	79 11                	jns    774 <printint+0x2b>
    neg = 1;
 763:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 76a:	8b 45 0c             	mov    0xc(%ebp),%eax
 76d:	f7 d8                	neg    %eax
 76f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 772:	eb 06                	jmp    77a <printint+0x31>
  } else {
    x = xx;
 774:	8b 45 0c             	mov    0xc(%ebp),%eax
 777:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 77a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 781:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 784:	8d 41 01             	lea    0x1(%ecx),%eax
 787:	89 45 f4             	mov    %eax,-0xc(%ebp)
 78a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 78d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 790:	ba 00 00 00 00       	mov    $0x0,%edx
 795:	f7 f3                	div    %ebx
 797:	89 d0                	mov    %edx,%eax
 799:	0f b6 80 2c 11 00 00 	movzbl 0x112c(%eax),%eax
 7a0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7aa:	ba 00 00 00 00       	mov    $0x0,%edx
 7af:	f7 f3                	div    %ebx
 7b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7b8:	75 c7                	jne    781 <printint+0x38>
  if(neg)
 7ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7be:	74 2d                	je     7ed <printint+0xa4>
    buf[i++] = '-';
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	8d 50 01             	lea    0x1(%eax),%edx
 7c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7c9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7ce:	eb 1d                	jmp    7ed <printint+0xa4>
    putc(fd, buf[i]);
 7d0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	01 d0                	add    %edx,%eax
 7d8:	0f b6 00             	movzbl (%eax),%eax
 7db:	0f be c0             	movsbl %al,%eax
 7de:	83 ec 08             	sub    $0x8,%esp
 7e1:	50                   	push   %eax
 7e2:	ff 75 08             	pushl  0x8(%ebp)
 7e5:	e8 3c ff ff ff       	call   726 <putc>
 7ea:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7ed:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 7f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f5:	79 d9                	jns    7d0 <printint+0x87>
    putc(fd, buf[i]);
}
 7f7:	90                   	nop
 7f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7fb:	c9                   	leave  
 7fc:	c3                   	ret    

000007fd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7fd:	55                   	push   %ebp
 7fe:	89 e5                	mov    %esp,%ebp
 800:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 803:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 80a:	8d 45 0c             	lea    0xc(%ebp),%eax
 80d:	83 c0 04             	add    $0x4,%eax
 810:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 813:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 81a:	e9 59 01 00 00       	jmp    978 <printf+0x17b>
    c = fmt[i] & 0xff;
 81f:	8b 55 0c             	mov    0xc(%ebp),%edx
 822:	8b 45 f0             	mov    -0x10(%ebp),%eax
 825:	01 d0                	add    %edx,%eax
 827:	0f b6 00             	movzbl (%eax),%eax
 82a:	0f be c0             	movsbl %al,%eax
 82d:	25 ff 00 00 00       	and    $0xff,%eax
 832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 835:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 839:	75 2c                	jne    867 <printf+0x6a>
      if(c == '%'){
 83b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 83f:	75 0c                	jne    84d <printf+0x50>
        state = '%';
 841:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 848:	e9 27 01 00 00       	jmp    974 <printf+0x177>
      } else {
        putc(fd, c);
 84d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 850:	0f be c0             	movsbl %al,%eax
 853:	83 ec 08             	sub    $0x8,%esp
 856:	50                   	push   %eax
 857:	ff 75 08             	pushl  0x8(%ebp)
 85a:	e8 c7 fe ff ff       	call   726 <putc>
 85f:	83 c4 10             	add    $0x10,%esp
 862:	e9 0d 01 00 00       	jmp    974 <printf+0x177>
      }
    } else if(state == '%'){
 867:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 86b:	0f 85 03 01 00 00    	jne    974 <printf+0x177>
      if(c == 'd'){
 871:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 875:	75 1e                	jne    895 <printf+0x98>
        printint(fd, *ap, 10, 1);
 877:	8b 45 e8             	mov    -0x18(%ebp),%eax
 87a:	8b 00                	mov    (%eax),%eax
 87c:	6a 01                	push   $0x1
 87e:	6a 0a                	push   $0xa
 880:	50                   	push   %eax
 881:	ff 75 08             	pushl  0x8(%ebp)
 884:	e8 c0 fe ff ff       	call   749 <printint>
 889:	83 c4 10             	add    $0x10,%esp
        ap++;
 88c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 890:	e9 d8 00 00 00       	jmp    96d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 895:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 899:	74 06                	je     8a1 <printf+0xa4>
 89b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 89f:	75 1e                	jne    8bf <printf+0xc2>
        printint(fd, *ap, 16, 0);
 8a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a4:	8b 00                	mov    (%eax),%eax
 8a6:	6a 00                	push   $0x0
 8a8:	6a 10                	push   $0x10
 8aa:	50                   	push   %eax
 8ab:	ff 75 08             	pushl  0x8(%ebp)
 8ae:	e8 96 fe ff ff       	call   749 <printint>
 8b3:	83 c4 10             	add    $0x10,%esp
        ap++;
 8b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8ba:	e9 ae 00 00 00       	jmp    96d <printf+0x170>
      } else if(c == 's'){
 8bf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8c3:	75 43                	jne    908 <printf+0x10b>
        s = (char*)*ap;
 8c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8c8:	8b 00                	mov    (%eax),%eax
 8ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d5:	75 25                	jne    8fc <printf+0xff>
          s = "(null)";
 8d7:	c7 45 f4 38 0e 00 00 	movl   $0xe38,-0xc(%ebp)
        while(*s != 0){
 8de:	eb 1c                	jmp    8fc <printf+0xff>
          putc(fd, *s);
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	0f b6 00             	movzbl (%eax),%eax
 8e6:	0f be c0             	movsbl %al,%eax
 8e9:	83 ec 08             	sub    $0x8,%esp
 8ec:	50                   	push   %eax
 8ed:	ff 75 08             	pushl  0x8(%ebp)
 8f0:	e8 31 fe ff ff       	call   726 <putc>
 8f5:	83 c4 10             	add    $0x10,%esp
          s++;
 8f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ff:	0f b6 00             	movzbl (%eax),%eax
 902:	84 c0                	test   %al,%al
 904:	75 da                	jne    8e0 <printf+0xe3>
 906:	eb 65                	jmp    96d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 908:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 90c:	75 1d                	jne    92b <printf+0x12e>
        putc(fd, *ap);
 90e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 911:	8b 00                	mov    (%eax),%eax
 913:	0f be c0             	movsbl %al,%eax
 916:	83 ec 08             	sub    $0x8,%esp
 919:	50                   	push   %eax
 91a:	ff 75 08             	pushl  0x8(%ebp)
 91d:	e8 04 fe ff ff       	call   726 <putc>
 922:	83 c4 10             	add    $0x10,%esp
        ap++;
 925:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 929:	eb 42                	jmp    96d <printf+0x170>
      } else if(c == '%'){
 92b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 92f:	75 17                	jne    948 <printf+0x14b>
        putc(fd, c);
 931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 934:	0f be c0             	movsbl %al,%eax
 937:	83 ec 08             	sub    $0x8,%esp
 93a:	50                   	push   %eax
 93b:	ff 75 08             	pushl  0x8(%ebp)
 93e:	e8 e3 fd ff ff       	call   726 <putc>
 943:	83 c4 10             	add    $0x10,%esp
 946:	eb 25                	jmp    96d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 948:	83 ec 08             	sub    $0x8,%esp
 94b:	6a 25                	push   $0x25
 94d:	ff 75 08             	pushl  0x8(%ebp)
 950:	e8 d1 fd ff ff       	call   726 <putc>
 955:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 95b:	0f be c0             	movsbl %al,%eax
 95e:	83 ec 08             	sub    $0x8,%esp
 961:	50                   	push   %eax
 962:	ff 75 08             	pushl  0x8(%ebp)
 965:	e8 bc fd ff ff       	call   726 <putc>
 96a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 96d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 974:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 978:	8b 55 0c             	mov    0xc(%ebp),%edx
 97b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97e:	01 d0                	add    %edx,%eax
 980:	0f b6 00             	movzbl (%eax),%eax
 983:	84 c0                	test   %al,%al
 985:	0f 85 94 fe ff ff    	jne    81f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 98b:	90                   	nop
 98c:	c9                   	leave  
 98d:	c3                   	ret    

0000098e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 98e:	55                   	push   %ebp
 98f:	89 e5                	mov    %esp,%ebp
 991:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 994:	8b 45 08             	mov    0x8(%ebp),%eax
 997:	83 e8 08             	sub    $0x8,%eax
 99a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99d:	a1 48 11 00 00       	mov    0x1148,%eax
 9a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9a5:	eb 24                	jmp    9cb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9aa:	8b 00                	mov    (%eax),%eax
 9ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9af:	77 12                	ja     9c3 <free+0x35>
 9b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9b7:	77 24                	ja     9dd <free+0x4f>
 9b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bc:	8b 00                	mov    (%eax),%eax
 9be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9c1:	77 1a                	ja     9dd <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c6:	8b 00                	mov    (%eax),%eax
 9c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9d1:	76 d4                	jbe    9a7 <free+0x19>
 9d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d6:	8b 00                	mov    (%eax),%eax
 9d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9db:	76 ca                	jbe    9a7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e0:	8b 40 04             	mov    0x4(%eax),%eax
 9e3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ed:	01 c2                	add    %eax,%edx
 9ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f2:	8b 00                	mov    (%eax),%eax
 9f4:	39 c2                	cmp    %eax,%edx
 9f6:	75 24                	jne    a1c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9fb:	8b 50 04             	mov    0x4(%eax),%edx
 9fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a01:	8b 00                	mov    (%eax),%eax
 a03:	8b 40 04             	mov    0x4(%eax),%eax
 a06:	01 c2                	add    %eax,%edx
 a08:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a11:	8b 00                	mov    (%eax),%eax
 a13:	8b 10                	mov    (%eax),%edx
 a15:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a18:	89 10                	mov    %edx,(%eax)
 a1a:	eb 0a                	jmp    a26 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1f:	8b 10                	mov    (%eax),%edx
 a21:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a24:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a26:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a29:	8b 40 04             	mov    0x4(%eax),%eax
 a2c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a36:	01 d0                	add    %edx,%eax
 a38:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a3b:	75 20                	jne    a5d <free+0xcf>
    p->s.size += bp->s.size;
 a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a40:	8b 50 04             	mov    0x4(%eax),%edx
 a43:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a46:	8b 40 04             	mov    0x4(%eax),%eax
 a49:	01 c2                	add    %eax,%edx
 a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a51:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a54:	8b 10                	mov    (%eax),%edx
 a56:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a59:	89 10                	mov    %edx,(%eax)
 a5b:	eb 08                	jmp    a65 <free+0xd7>
  } else
    p->s.ptr = bp;
 a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a60:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a63:	89 10                	mov    %edx,(%eax)
  freep = p;
 a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a68:	a3 48 11 00 00       	mov    %eax,0x1148
}
 a6d:	90                   	nop
 a6e:	c9                   	leave  
 a6f:	c3                   	ret    

00000a70 <morecore>:

static Header*
morecore(uint nu)
{
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
 a73:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a76:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a7d:	77 07                	ja     a86 <morecore+0x16>
    nu = 4096;
 a7f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a86:	8b 45 08             	mov    0x8(%ebp),%eax
 a89:	c1 e0 03             	shl    $0x3,%eax
 a8c:	83 ec 0c             	sub    $0xc,%esp
 a8f:	50                   	push   %eax
 a90:	e8 41 fc ff ff       	call   6d6 <sbrk>
 a95:	83 c4 10             	add    $0x10,%esp
 a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a9b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a9f:	75 07                	jne    aa8 <morecore+0x38>
    return 0;
 aa1:	b8 00 00 00 00       	mov    $0x0,%eax
 aa6:	eb 26                	jmp    ace <morecore+0x5e>
  hp = (Header*)p;
 aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab1:	8b 55 08             	mov    0x8(%ebp),%edx
 ab4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aba:	83 c0 08             	add    $0x8,%eax
 abd:	83 ec 0c             	sub    $0xc,%esp
 ac0:	50                   	push   %eax
 ac1:	e8 c8 fe ff ff       	call   98e <free>
 ac6:	83 c4 10             	add    $0x10,%esp
  return freep;
 ac9:	a1 48 11 00 00       	mov    0x1148,%eax
}
 ace:	c9                   	leave  
 acf:	c3                   	ret    

00000ad0 <malloc>:

void*
malloc(uint nbytes)
{
 ad0:	55                   	push   %ebp
 ad1:	89 e5                	mov    %esp,%ebp
 ad3:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ad6:	8b 45 08             	mov    0x8(%ebp),%eax
 ad9:	83 c0 07             	add    $0x7,%eax
 adc:	c1 e8 03             	shr    $0x3,%eax
 adf:	83 c0 01             	add    $0x1,%eax
 ae2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ae5:	a1 48 11 00 00       	mov    0x1148,%eax
 aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 af1:	75 23                	jne    b16 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 af3:	c7 45 f0 40 11 00 00 	movl   $0x1140,-0x10(%ebp)
 afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 afd:	a3 48 11 00 00       	mov    %eax,0x1148
 b02:	a1 48 11 00 00       	mov    0x1148,%eax
 b07:	a3 40 11 00 00       	mov    %eax,0x1140
    base.s.size = 0;
 b0c:	c7 05 44 11 00 00 00 	movl   $0x0,0x1144
 b13:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b19:	8b 00                	mov    (%eax),%eax
 b1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b21:	8b 40 04             	mov    0x4(%eax),%eax
 b24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b27:	72 4d                	jb     b76 <malloc+0xa6>
      if(p->s.size == nunits)
 b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2c:	8b 40 04             	mov    0x4(%eax),%eax
 b2f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b32:	75 0c                	jne    b40 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b37:	8b 10                	mov    (%eax),%edx
 b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b3c:	89 10                	mov    %edx,(%eax)
 b3e:	eb 26                	jmp    b66 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b43:	8b 40 04             	mov    0x4(%eax),%eax
 b46:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b49:	89 c2                	mov    %eax,%edx
 b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b54:	8b 40 04             	mov    0x4(%eax),%eax
 b57:	c1 e0 03             	shl    $0x3,%eax
 b5a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b60:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b63:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b69:	a3 48 11 00 00       	mov    %eax,0x1148
      return (void*)(p + 1);
 b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b71:	83 c0 08             	add    $0x8,%eax
 b74:	eb 3b                	jmp    bb1 <malloc+0xe1>
    }
    if(p == freep)
 b76:	a1 48 11 00 00       	mov    0x1148,%eax
 b7b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b7e:	75 1e                	jne    b9e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b80:	83 ec 0c             	sub    $0xc,%esp
 b83:	ff 75 ec             	pushl  -0x14(%ebp)
 b86:	e8 e5 fe ff ff       	call   a70 <morecore>
 b8b:	83 c4 10             	add    $0x10,%esp
 b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b95:	75 07                	jne    b9e <malloc+0xce>
        return 0;
 b97:	b8 00 00 00 00       	mov    $0x0,%eax
 b9c:	eb 13                	jmp    bb1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba7:	8b 00                	mov    (%eax),%eax
 ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 bac:	e9 6d ff ff ff       	jmp    b1e <malloc+0x4e>
}
 bb1:	c9                   	leave  
 bb2:	c3                   	ret    
