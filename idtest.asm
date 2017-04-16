
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
  14:	68 bc 0b 00 00       	push   $0xbbc
  19:	6a 01                	push   $0x1
  1b:	e8 e5 07 00 00       	call   805 <printf>
  20:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to %d\n", nval);
  23:	83 ec 04             	sub    $0x4,%esp
  26:	ff 75 08             	pushl  0x8(%ebp)
  29:	68 d0 0b 00 00       	push   $0xbd0
  2e:	6a 01                	push   $0x1
  30:	e8 d0 07 00 00       	call   805 <printf>
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
  50:	68 e3 0b 00 00       	push   $0xbe3
  55:	6a 02                	push   $0x2
  57:	e8 a9 07 00 00       	call   805 <printf>
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
  7b:	68 bc 0b 00 00       	push   $0xbbc
  80:	6a 01                	push   $0x1
  82:	e8 7e 07 00 00       	call   805 <printf>
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
  ae:	68 fb 0b 00 00       	push   $0xbfb
  b3:	6a 01                	push   $0x1
  b5:	e8 4b 07 00 00       	call   805 <printf>
  ba:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to %d\n", nval);
  bd:	83 ec 04             	sub    $0x4,%esp
  c0:	ff 75 08             	pushl  0x8(%ebp)
  c3:	68 0f 0c 00 00       	push   $0xc0f
  c8:	6a 01                	push   $0x1
  ca:	e8 36 07 00 00       	call   805 <printf>
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
  ea:	68 22 0c 00 00       	push   $0xc22
  ef:	6a 02                	push   $0x2
  f1:	e8 0f 07 00 00       	call   805 <printf>
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
 115:	68 fb 0b 00 00       	push   $0xbfb
 11a:	6a 01                	push   $0x1
 11c:	e8 e4 06 00 00       	call   805 <printf>
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
 141:	68 3c 0c 00 00       	push   $0xc3c
 146:	6a 01                	push   $0x1
 148:	e8 b8 06 00 00       	call   805 <printf>
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
 168:	68 86 0c 00 00       	push   $0xc86
 16d:	6a 02                	push   $0x2
 16f:	e8 91 06 00 00       	call   805 <printf>
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
 18f:	68 9d 0c 00 00       	push   $0xc9d
 194:	6a 02                	push   $0x2
 196:	e8 6a 06 00 00       	call   805 <printf>
 19b:	83 c4 10             	add    $0x10,%esp
  
  printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getgid());
 19e:	e8 63 05 00 00       	call   706 <getgid>
 1a3:	89 c3                	mov    %eax,%ebx
 1a5:	e8 54 05 00 00       	call   6fe <getuid>
 1aa:	53                   	push   %ebx
 1ab:	50                   	push   %eax
 1ac:	68 b4 0c 00 00       	push   $0xcb4
 1b1:	6a 01                	push   $0x1
 1b3:	e8 4d 06 00 00       	call   805 <printf>
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
 1df:	68 d8 0c 00 00       	push   $0xcd8
 1e4:	6a 01                	push   $0x1
 1e6:	e8 1a 06 00 00       	call   805 <printf>
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
 21f:	68 f8 0c 00 00       	push   $0xcf8
 224:	6a 01                	push   $0x1
 226:	e8 da 05 00 00       	call   805 <printf>
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
 243:	68 24 0d 00 00       	push   $0xd24
 248:	6a 01                	push   $0x1
 24a:	e8 b6 05 00 00       	call   805 <printf>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	eb 12                	jmp    266 <invalidTest+0x53>
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");
 254:	83 ec 08             	sub    $0x8,%esp
 257:	68 58 0d 00 00       	push   $0xd58
 25c:	6a 02                	push   $0x2
 25e:	e8 a2 05 00 00       	call   805 <printf>
 263:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", nval);
 266:	83 ec 04             	sub    $0x4,%esp
 269:	ff 75 08             	pushl  0x8(%ebp)
 26c:	68 8c 0d 00 00       	push   $0xd8c
 271:	6a 01                	push   $0x1
 273:	e8 8d 05 00 00       	call   805 <printf>
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
 290:	68 b8 0d 00 00       	push   $0xdb8
 295:	6a 01                	push   $0x1
 297:	e8 69 05 00 00       	call   805 <printf>
 29c:	83 c4 10             	add    $0x10,%esp
 29f:	eb 12                	jmp    2b3 <invalidTest+0xa0>
  else
    printf(2, "FAILURE! The setgid system call indicates success\n");
 2a1:	83 ec 08             	sub    $0x8,%esp
 2a4:	68 ec 0d 00 00       	push   $0xdec
 2a9:	6a 02                	push   $0x2
 2ab:	e8 55 05 00 00       	call   805 <printf>
 2b0:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting UID to %d. This test should FAIL\n", -1);
 2b3:	83 ec 04             	sub    $0x4,%esp
 2b6:	6a ff                	push   $0xffffffff
 2b8:	68 f8 0c 00 00       	push   $0xcf8
 2bd:	6a 01                	push   $0x1
 2bf:	e8 41 05 00 00       	call   805 <printf>
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
 2db:	68 24 0d 00 00       	push   $0xd24
 2e0:	6a 01                	push   $0x1
 2e2:	e8 1e 05 00 00       	call   805 <printf>
 2e7:	83 c4 10             	add    $0x10,%esp
 2ea:	eb 12                	jmp    2fe <invalidTest+0xeb>
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");
 2ec:	83 ec 08             	sub    $0x8,%esp
 2ef:	68 58 0d 00 00       	push   $0xd58
 2f4:	6a 02                	push   $0x2
 2f6:	e8 0a 05 00 00       	call   805 <printf>
 2fb:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", -1);
 2fe:	83 ec 04             	sub    $0x4,%esp
 301:	6a ff                	push   $0xffffffff
 303:	68 8c 0d 00 00       	push   $0xd8c
 308:	6a 01                	push   $0x1
 30a:	e8 f6 04 00 00       	call   805 <printf>
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
 326:	68 b8 0d 00 00       	push   $0xdb8
 32b:	6a 01                	push   $0x1
 32d:	e8 d3 04 00 00       	call   805 <printf>
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
 33a:	68 ec 0d 00 00       	push   $0xdec
 33f:	6a 02                	push   $0x2
 341:	e8 bf 04 00 00       	call   805 <printf>
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
 38a:	68 1f 0e 00 00       	push   $0xe1f
 38f:	6a 01                	push   $0x1
 391:	e8 6f 04 00 00       	call   805 <printf>
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
 3c6:	68 39 0e 00 00       	push   $0xe39
 3cb:	6a 01                	push   $0x1
 3cd:	e8 33 04 00 00       	call   805 <printf>
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
SYSCALL(date)      #p1
 6f6:	b8 17 00 00 00       	mov    $0x17,%eax
 6fb:	cd 40                	int    $0x40
 6fd:	c3                   	ret    

000006fe <getuid>:
SYSCALL(getuid)    #p2
 6fe:	b8 18 00 00 00       	mov    $0x18,%eax
 703:	cd 40                	int    $0x40
 705:	c3                   	ret    

00000706 <getgid>:
SYSCALL(getgid)    #p2
 706:	b8 19 00 00 00       	mov    $0x19,%eax
 70b:	cd 40                	int    $0x40
 70d:	c3                   	ret    

0000070e <getppid>:
SYSCALL(getppid)   #p2
 70e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 713:	cd 40                	int    $0x40
 715:	c3                   	ret    

00000716 <setuid>:
SYSCALL(setuid)    #p2
 716:	b8 1b 00 00 00       	mov    $0x1b,%eax
 71b:	cd 40                	int    $0x40
 71d:	c3                   	ret    

0000071e <setgid>:
SYSCALL(setgid)    #p2
 71e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 723:	cd 40                	int    $0x40
 725:	c3                   	ret    

00000726 <getprocs>:
SYSCALL(getprocs)  #p2
 726:	b8 1d 00 00 00       	mov    $0x1d,%eax
 72b:	cd 40                	int    $0x40
 72d:	c3                   	ret    

0000072e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 72e:	55                   	push   %ebp
 72f:	89 e5                	mov    %esp,%ebp
 731:	83 ec 18             	sub    $0x18,%esp
 734:	8b 45 0c             	mov    0xc(%ebp),%eax
 737:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 73a:	83 ec 04             	sub    $0x4,%esp
 73d:	6a 01                	push   $0x1
 73f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 742:	50                   	push   %eax
 743:	ff 75 08             	pushl  0x8(%ebp)
 746:	e8 23 ff ff ff       	call   66e <write>
 74b:	83 c4 10             	add    $0x10,%esp
}
 74e:	90                   	nop
 74f:	c9                   	leave  
 750:	c3                   	ret    

00000751 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 751:	55                   	push   %ebp
 752:	89 e5                	mov    %esp,%ebp
 754:	53                   	push   %ebx
 755:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 758:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 75f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 763:	74 17                	je     77c <printint+0x2b>
 765:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 769:	79 11                	jns    77c <printint+0x2b>
    neg = 1;
 76b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 772:	8b 45 0c             	mov    0xc(%ebp),%eax
 775:	f7 d8                	neg    %eax
 777:	89 45 ec             	mov    %eax,-0x14(%ebp)
 77a:	eb 06                	jmp    782 <printint+0x31>
  } else {
    x = xx;
 77c:	8b 45 0c             	mov    0xc(%ebp),%eax
 77f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 782:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 789:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 78c:	8d 41 01             	lea    0x1(%ecx),%eax
 78f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 792:	8b 5d 10             	mov    0x10(%ebp),%ebx
 795:	8b 45 ec             	mov    -0x14(%ebp),%eax
 798:	ba 00 00 00 00       	mov    $0x0,%edx
 79d:	f7 f3                	div    %ebx
 79f:	89 d0                	mov    %edx,%eax
 7a1:	0f b6 80 34 11 00 00 	movzbl 0x1134(%eax),%eax
 7a8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7b2:	ba 00 00 00 00       	mov    $0x0,%edx
 7b7:	f7 f3                	div    %ebx
 7b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c0:	75 c7                	jne    789 <printint+0x38>
  if(neg)
 7c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c6:	74 2d                	je     7f5 <printint+0xa4>
    buf[i++] = '-';
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	8d 50 01             	lea    0x1(%eax),%edx
 7ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7d1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7d6:	eb 1d                	jmp    7f5 <printint+0xa4>
    putc(fd, buf[i]);
 7d8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	01 d0                	add    %edx,%eax
 7e0:	0f b6 00             	movzbl (%eax),%eax
 7e3:	0f be c0             	movsbl %al,%eax
 7e6:	83 ec 08             	sub    $0x8,%esp
 7e9:	50                   	push   %eax
 7ea:	ff 75 08             	pushl  0x8(%ebp)
 7ed:	e8 3c ff ff ff       	call   72e <putc>
 7f2:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7f5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 7f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7fd:	79 d9                	jns    7d8 <printint+0x87>
    putc(fd, buf[i]);
}
 7ff:	90                   	nop
 800:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 803:	c9                   	leave  
 804:	c3                   	ret    

00000805 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 805:	55                   	push   %ebp
 806:	89 e5                	mov    %esp,%ebp
 808:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 80b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 812:	8d 45 0c             	lea    0xc(%ebp),%eax
 815:	83 c0 04             	add    $0x4,%eax
 818:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 81b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 822:	e9 59 01 00 00       	jmp    980 <printf+0x17b>
    c = fmt[i] & 0xff;
 827:	8b 55 0c             	mov    0xc(%ebp),%edx
 82a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82d:	01 d0                	add    %edx,%eax
 82f:	0f b6 00             	movzbl (%eax),%eax
 832:	0f be c0             	movsbl %al,%eax
 835:	25 ff 00 00 00       	and    $0xff,%eax
 83a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 83d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 841:	75 2c                	jne    86f <printf+0x6a>
      if(c == '%'){
 843:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 847:	75 0c                	jne    855 <printf+0x50>
        state = '%';
 849:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 850:	e9 27 01 00 00       	jmp    97c <printf+0x177>
      } else {
        putc(fd, c);
 855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 858:	0f be c0             	movsbl %al,%eax
 85b:	83 ec 08             	sub    $0x8,%esp
 85e:	50                   	push   %eax
 85f:	ff 75 08             	pushl  0x8(%ebp)
 862:	e8 c7 fe ff ff       	call   72e <putc>
 867:	83 c4 10             	add    $0x10,%esp
 86a:	e9 0d 01 00 00       	jmp    97c <printf+0x177>
      }
    } else if(state == '%'){
 86f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 873:	0f 85 03 01 00 00    	jne    97c <printf+0x177>
      if(c == 'd'){
 879:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 87d:	75 1e                	jne    89d <printf+0x98>
        printint(fd, *ap, 10, 1);
 87f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 882:	8b 00                	mov    (%eax),%eax
 884:	6a 01                	push   $0x1
 886:	6a 0a                	push   $0xa
 888:	50                   	push   %eax
 889:	ff 75 08             	pushl  0x8(%ebp)
 88c:	e8 c0 fe ff ff       	call   751 <printint>
 891:	83 c4 10             	add    $0x10,%esp
        ap++;
 894:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 898:	e9 d8 00 00 00       	jmp    975 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 89d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8a1:	74 06                	je     8a9 <printf+0xa4>
 8a3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8a7:	75 1e                	jne    8c7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 8a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ac:	8b 00                	mov    (%eax),%eax
 8ae:	6a 00                	push   $0x0
 8b0:	6a 10                	push   $0x10
 8b2:	50                   	push   %eax
 8b3:	ff 75 08             	pushl  0x8(%ebp)
 8b6:	e8 96 fe ff ff       	call   751 <printint>
 8bb:	83 c4 10             	add    $0x10,%esp
        ap++;
 8be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c2:	e9 ae 00 00 00       	jmp    975 <printf+0x170>
      } else if(c == 's'){
 8c7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8cb:	75 43                	jne    910 <printf+0x10b>
        s = (char*)*ap;
 8cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8dd:	75 25                	jne    904 <printf+0xff>
          s = "(null)";
 8df:	c7 45 f4 40 0e 00 00 	movl   $0xe40,-0xc(%ebp)
        while(*s != 0){
 8e6:	eb 1c                	jmp    904 <printf+0xff>
          putc(fd, *s);
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	0f b6 00             	movzbl (%eax),%eax
 8ee:	0f be c0             	movsbl %al,%eax
 8f1:	83 ec 08             	sub    $0x8,%esp
 8f4:	50                   	push   %eax
 8f5:	ff 75 08             	pushl  0x8(%ebp)
 8f8:	e8 31 fe ff ff       	call   72e <putc>
 8fd:	83 c4 10             	add    $0x10,%esp
          s++;
 900:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 904:	8b 45 f4             	mov    -0xc(%ebp),%eax
 907:	0f b6 00             	movzbl (%eax),%eax
 90a:	84 c0                	test   %al,%al
 90c:	75 da                	jne    8e8 <printf+0xe3>
 90e:	eb 65                	jmp    975 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 910:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 914:	75 1d                	jne    933 <printf+0x12e>
        putc(fd, *ap);
 916:	8b 45 e8             	mov    -0x18(%ebp),%eax
 919:	8b 00                	mov    (%eax),%eax
 91b:	0f be c0             	movsbl %al,%eax
 91e:	83 ec 08             	sub    $0x8,%esp
 921:	50                   	push   %eax
 922:	ff 75 08             	pushl  0x8(%ebp)
 925:	e8 04 fe ff ff       	call   72e <putc>
 92a:	83 c4 10             	add    $0x10,%esp
        ap++;
 92d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 931:	eb 42                	jmp    975 <printf+0x170>
      } else if(c == '%'){
 933:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 937:	75 17                	jne    950 <printf+0x14b>
        putc(fd, c);
 939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 93c:	0f be c0             	movsbl %al,%eax
 93f:	83 ec 08             	sub    $0x8,%esp
 942:	50                   	push   %eax
 943:	ff 75 08             	pushl  0x8(%ebp)
 946:	e8 e3 fd ff ff       	call   72e <putc>
 94b:	83 c4 10             	add    $0x10,%esp
 94e:	eb 25                	jmp    975 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 950:	83 ec 08             	sub    $0x8,%esp
 953:	6a 25                	push   $0x25
 955:	ff 75 08             	pushl  0x8(%ebp)
 958:	e8 d1 fd ff ff       	call   72e <putc>
 95d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 963:	0f be c0             	movsbl %al,%eax
 966:	83 ec 08             	sub    $0x8,%esp
 969:	50                   	push   %eax
 96a:	ff 75 08             	pushl  0x8(%ebp)
 96d:	e8 bc fd ff ff       	call   72e <putc>
 972:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 975:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 97c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 980:	8b 55 0c             	mov    0xc(%ebp),%edx
 983:	8b 45 f0             	mov    -0x10(%ebp),%eax
 986:	01 d0                	add    %edx,%eax
 988:	0f b6 00             	movzbl (%eax),%eax
 98b:	84 c0                	test   %al,%al
 98d:	0f 85 94 fe ff ff    	jne    827 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 993:	90                   	nop
 994:	c9                   	leave  
 995:	c3                   	ret    

00000996 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 996:	55                   	push   %ebp
 997:	89 e5                	mov    %esp,%ebp
 999:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 99c:	8b 45 08             	mov    0x8(%ebp),%eax
 99f:	83 e8 08             	sub    $0x8,%eax
 9a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a5:	a1 50 11 00 00       	mov    0x1150,%eax
 9aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9ad:	eb 24                	jmp    9d3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b2:	8b 00                	mov    (%eax),%eax
 9b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9b7:	77 12                	ja     9cb <free+0x35>
 9b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9bf:	77 24                	ja     9e5 <free+0x4f>
 9c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c4:	8b 00                	mov    (%eax),%eax
 9c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9c9:	77 1a                	ja     9e5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ce:	8b 00                	mov    (%eax),%eax
 9d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9d9:	76 d4                	jbe    9af <free+0x19>
 9db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9de:	8b 00                	mov    (%eax),%eax
 9e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9e3:	76 ca                	jbe    9af <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e8:	8b 40 04             	mov    0x4(%eax),%eax
 9eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f5:	01 c2                	add    %eax,%edx
 9f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fa:	8b 00                	mov    (%eax),%eax
 9fc:	39 c2                	cmp    %eax,%edx
 9fe:	75 24                	jne    a24 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a00:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a03:	8b 50 04             	mov    0x4(%eax),%edx
 a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a09:	8b 00                	mov    (%eax),%eax
 a0b:	8b 40 04             	mov    0x4(%eax),%eax
 a0e:	01 c2                	add    %eax,%edx
 a10:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a13:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a19:	8b 00                	mov    (%eax),%eax
 a1b:	8b 10                	mov    (%eax),%edx
 a1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a20:	89 10                	mov    %edx,(%eax)
 a22:	eb 0a                	jmp    a2e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a27:	8b 10                	mov    (%eax),%edx
 a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a31:	8b 40 04             	mov    0x4(%eax),%eax
 a34:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3e:	01 d0                	add    %edx,%eax
 a40:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a43:	75 20                	jne    a65 <free+0xcf>
    p->s.size += bp->s.size;
 a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a48:	8b 50 04             	mov    0x4(%eax),%edx
 a4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4e:	8b 40 04             	mov    0x4(%eax),%eax
 a51:	01 c2                	add    %eax,%edx
 a53:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a56:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a59:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5c:	8b 10                	mov    (%eax),%edx
 a5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a61:	89 10                	mov    %edx,(%eax)
 a63:	eb 08                	jmp    a6d <free+0xd7>
  } else
    p->s.ptr = bp;
 a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a68:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a6b:	89 10                	mov    %edx,(%eax)
  freep = p;
 a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a70:	a3 50 11 00 00       	mov    %eax,0x1150
}
 a75:	90                   	nop
 a76:	c9                   	leave  
 a77:	c3                   	ret    

00000a78 <morecore>:

static Header*
morecore(uint nu)
{
 a78:	55                   	push   %ebp
 a79:	89 e5                	mov    %esp,%ebp
 a7b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a7e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a85:	77 07                	ja     a8e <morecore+0x16>
    nu = 4096;
 a87:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a8e:	8b 45 08             	mov    0x8(%ebp),%eax
 a91:	c1 e0 03             	shl    $0x3,%eax
 a94:	83 ec 0c             	sub    $0xc,%esp
 a97:	50                   	push   %eax
 a98:	e8 39 fc ff ff       	call   6d6 <sbrk>
 a9d:	83 c4 10             	add    $0x10,%esp
 aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 aa3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 aa7:	75 07                	jne    ab0 <morecore+0x38>
    return 0;
 aa9:	b8 00 00 00 00       	mov    $0x0,%eax
 aae:	eb 26                	jmp    ad6 <morecore+0x5e>
  hp = (Header*)p;
 ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab9:	8b 55 08             	mov    0x8(%ebp),%edx
 abc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac2:	83 c0 08             	add    $0x8,%eax
 ac5:	83 ec 0c             	sub    $0xc,%esp
 ac8:	50                   	push   %eax
 ac9:	e8 c8 fe ff ff       	call   996 <free>
 ace:	83 c4 10             	add    $0x10,%esp
  return freep;
 ad1:	a1 50 11 00 00       	mov    0x1150,%eax
}
 ad6:	c9                   	leave  
 ad7:	c3                   	ret    

00000ad8 <malloc>:

void*
malloc(uint nbytes)
{
 ad8:	55                   	push   %ebp
 ad9:	89 e5                	mov    %esp,%ebp
 adb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ade:	8b 45 08             	mov    0x8(%ebp),%eax
 ae1:	83 c0 07             	add    $0x7,%eax
 ae4:	c1 e8 03             	shr    $0x3,%eax
 ae7:	83 c0 01             	add    $0x1,%eax
 aea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 aed:	a1 50 11 00 00       	mov    0x1150,%eax
 af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 af5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 af9:	75 23                	jne    b1e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 afb:	c7 45 f0 48 11 00 00 	movl   $0x1148,-0x10(%ebp)
 b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b05:	a3 50 11 00 00       	mov    %eax,0x1150
 b0a:	a1 50 11 00 00       	mov    0x1150,%eax
 b0f:	a3 48 11 00 00       	mov    %eax,0x1148
    base.s.size = 0;
 b14:	c7 05 4c 11 00 00 00 	movl   $0x0,0x114c
 b1b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b21:	8b 00                	mov    (%eax),%eax
 b23:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b29:	8b 40 04             	mov    0x4(%eax),%eax
 b2c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b2f:	72 4d                	jb     b7e <malloc+0xa6>
      if(p->s.size == nunits)
 b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b34:	8b 40 04             	mov    0x4(%eax),%eax
 b37:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b3a:	75 0c                	jne    b48 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3f:	8b 10                	mov    (%eax),%edx
 b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b44:	89 10                	mov    %edx,(%eax)
 b46:	eb 26                	jmp    b6e <malloc+0x96>
      else {
        p->s.size -= nunits;
 b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4b:	8b 40 04             	mov    0x4(%eax),%eax
 b4e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b51:	89 c2                	mov    %eax,%edx
 b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b56:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5c:	8b 40 04             	mov    0x4(%eax),%eax
 b5f:	c1 e0 03             	shl    $0x3,%eax
 b62:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b68:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b6b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b71:	a3 50 11 00 00       	mov    %eax,0x1150
      return (void*)(p + 1);
 b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b79:	83 c0 08             	add    $0x8,%eax
 b7c:	eb 3b                	jmp    bb9 <malloc+0xe1>
    }
    if(p == freep)
 b7e:	a1 50 11 00 00       	mov    0x1150,%eax
 b83:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b86:	75 1e                	jne    ba6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b88:	83 ec 0c             	sub    $0xc,%esp
 b8b:	ff 75 ec             	pushl  -0x14(%ebp)
 b8e:	e8 e5 fe ff ff       	call   a78 <morecore>
 b93:	83 c4 10             	add    $0x10,%esp
 b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b9d:	75 07                	jne    ba6 <malloc+0xce>
        return 0;
 b9f:	b8 00 00 00 00       	mov    $0x0,%eax
 ba4:	eb 13                	jmp    bb9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 baf:	8b 00                	mov    (%eax),%eax
 bb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 bb4:	e9 6d ff ff ff       	jmp    b26 <malloc+0x4e>
}
 bb9:	c9                   	leave  
 bba:	c3                   	ret    
