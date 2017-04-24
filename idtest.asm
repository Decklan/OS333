
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
   6:	e8 b7 06 00 00       	call   6c2 <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 80 0b 00 00       	push   $0xb80
  19:	6a 01                	push   $0x1
  1b:	e8 a9 07 00 00       	call   7c9 <printf>
  20:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to %d\n", nval);
  23:	83 ec 04             	sub    $0x4,%esp
  26:	ff 75 08             	pushl  0x8(%ebp)
  29:	68 94 0b 00 00       	push   $0xb94
  2e:	6a 01                	push   $0x1
  30:	e8 94 07 00 00       	call   7c9 <printf>
  35:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	ff 75 08             	pushl  0x8(%ebp)
  3e:	e8 97 06 00 00       	call   6da <setuid>
  43:	83 c4 10             	add    $0x10,%esp
  46:	85 c0                	test   %eax,%eax
  48:	79 15                	jns    5f <uidTest+0x5f>
    printf(2, "Error. Invalid UID: %d\n", nval);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 08             	pushl  0x8(%ebp)
  50:	68 a7 0b 00 00       	push   $0xba7
  55:	6a 02                	push   $0x2
  57:	e8 6d 07 00 00       	call   7c9 <printf>
  5c:	83 c4 10             	add    $0x10,%esp
  setuid(nval);
  5f:	83 ec 0c             	sub    $0xc,%esp
  62:	ff 75 08             	pushl  0x8(%ebp)
  65:	e8 70 06 00 00       	call   6da <setuid>
  6a:	83 c4 10             	add    $0x10,%esp
  uid = getuid();
  6d:	e8 50 06 00 00       	call   6c2 <getuid>
  72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  75:	83 ec 04             	sub    $0x4,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	68 80 0b 00 00       	push   $0xb80
  80:	6a 01                	push   $0x1
  82:	e8 42 07 00 00       	call   7c9 <printf>
  87:	83 c4 10             	add    $0x10,%esp
  sleep(5 * TPS); // now type control-p
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	6a 32                	push   $0x32
  8f:	e8 0e 06 00 00       	call   6a2 <sleep>
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
  a0:	e8 25 06 00 00       	call   6ca <getgid>
  a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current GID is: %d\n", gid);
  a8:	83 ec 04             	sub    $0x4,%esp
  ab:	ff 75 f4             	pushl  -0xc(%ebp)
  ae:	68 bf 0b 00 00       	push   $0xbbf
  b3:	6a 01                	push   $0x1
  b5:	e8 0f 07 00 00       	call   7c9 <printf>
  ba:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to %d\n", nval);
  bd:	83 ec 04             	sub    $0x4,%esp
  c0:	ff 75 08             	pushl  0x8(%ebp)
  c3:	68 d3 0b 00 00       	push   $0xbd3
  c8:	6a 01                	push   $0x1
  ca:	e8 fa 06 00 00       	call   7c9 <printf>
  cf:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
  d2:	83 ec 0c             	sub    $0xc,%esp
  d5:	ff 75 08             	pushl  0x8(%ebp)
  d8:	e8 05 06 00 00       	call   6e2 <setgid>
  dd:	83 c4 10             	add    $0x10,%esp
  e0:	85 c0                	test   %eax,%eax
  e2:	79 15                	jns    f9 <gidTest+0x5f>
    printf(2, "Error. Invalid GID: %d\n", nval);
  e4:	83 ec 04             	sub    $0x4,%esp
  e7:	ff 75 08             	pushl  0x8(%ebp)
  ea:	68 e6 0b 00 00       	push   $0xbe6
  ef:	6a 02                	push   $0x2
  f1:	e8 d3 06 00 00       	call   7c9 <printf>
  f6:	83 c4 10             	add    $0x10,%esp
  setgid(nval);
  f9:	83 ec 0c             	sub    $0xc,%esp
  fc:	ff 75 08             	pushl  0x8(%ebp)
  ff:	e8 de 05 00 00       	call   6e2 <setgid>
 104:	83 c4 10             	add    $0x10,%esp
  gid = getgid();
 107:	e8 be 05 00 00       	call   6ca <getgid>
 10c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 10f:	83 ec 04             	sub    $0x4,%esp
 112:	ff 75 f4             	pushl  -0xc(%ebp)
 115:	68 bf 0b 00 00       	push   $0xbbf
 11a:	6a 01                	push   $0x1
 11c:	e8 a8 06 00 00       	call   7c9 <printf>
 121:	83 c4 10             	add    $0x10,%esp
  sleep(5 * TPS); // now type control-p
 124:	83 ec 0c             	sub    $0xc,%esp
 127:	6a 32                	push   $0x32
 129:	e8 74 05 00 00       	call   6a2 <sleep>
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
 141:	68 00 0c 00 00       	push   $0xc00
 146:	6a 01                	push   $0x1
 148:	e8 7c 06 00 00       	call   7c9 <printf>
 14d:	83 c4 10             	add    $0x10,%esp
       	                " should be inherited\n", nval, nval);

  if (setuid(nval) < 0)
 150:	83 ec 0c             	sub    $0xc,%esp
 153:	ff 75 08             	pushl  0x8(%ebp)
 156:	e8 7f 05 00 00       	call   6da <setuid>
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	85 c0                	test   %eax,%eax
 160:	79 15                	jns    177 <forkTest+0x43>
    printf(2, "Error.Invalid UID: %d\n", nval);
 162:	83 ec 04             	sub    $0x4,%esp
 165:	ff 75 08             	pushl  0x8(%ebp)
 168:	68 4a 0c 00 00       	push   $0xc4a
 16d:	6a 02                	push   $0x2
 16f:	e8 55 06 00 00       	call   7c9 <printf>
 174:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 177:	83 ec 0c             	sub    $0xc,%esp
 17a:	ff 75 08             	pushl  0x8(%ebp)
 17d:	e8 60 05 00 00       	call   6e2 <setgid>
 182:	83 c4 10             	add    $0x10,%esp
 185:	85 c0                	test   %eax,%eax
 187:	79 15                	jns    19e <forkTest+0x6a>
    printf(2, "Error.Invalid GID: %d\n", nval);
 189:	83 ec 04             	sub    $0x4,%esp
 18c:	ff 75 08             	pushl  0x8(%ebp)
 18f:	68 61 0c 00 00       	push   $0xc61
 194:	6a 02                	push   $0x2
 196:	e8 2e 06 00 00       	call   7c9 <printf>
 19b:	83 c4 10             	add    $0x10,%esp
  
  printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getgid());
 19e:	e8 27 05 00 00       	call   6ca <getgid>
 1a3:	89 c3                	mov    %eax,%ebx
 1a5:	e8 18 05 00 00       	call   6c2 <getuid>
 1aa:	53                   	push   %ebx
 1ab:	50                   	push   %eax
 1ac:	68 78 0c 00 00       	push   $0xc78
 1b1:	6a 01                	push   $0x1
 1b3:	e8 11 06 00 00       	call   7c9 <printf>
 1b8:	83 c4 10             	add    $0x10,%esp
  pid = fork();
 1bb:	e8 4a 04 00 00       	call   60a <fork>
 1c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (pid == 0) {  // child
 1c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c7:	75 37                	jne    200 <forkTest+0xcc>
    uid = getuid();
 1c9:	e8 f4 04 00 00       	call   6c2 <getuid>
 1ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    gid = getgid();
 1d1:	e8 f4 04 00 00       	call   6ca <getgid>
 1d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1, "Child: UID is: %d, GID is: %d\n", uid, gid);
 1d9:	ff 75 ec             	pushl  -0x14(%ebp)
 1dc:	ff 75 f0             	pushl  -0x10(%ebp)
 1df:	68 9c 0c 00 00       	push   $0xc9c
 1e4:	6a 01                	push   $0x1
 1e6:	e8 de 05 00 00       	call   7c9 <printf>
 1eb:	83 c4 10             	add    $0x10,%esp
    sleep(5 * TPS);  // now type control-p
 1ee:	83 ec 0c             	sub    $0xc,%esp
 1f1:	6a 32                	push   $0x32
 1f3:	e8 aa 04 00 00       	call   6a2 <sleep>
 1f8:	83 c4 10             	add    $0x10,%esp
    exit();
 1fb:	e8 12 04 00 00       	call   612 <exit>
  }
  else
    sleep(10 * TPS);
 200:	83 ec 0c             	sub    $0xc,%esp
 203:	6a 64                	push   $0x64
 205:	e8 98 04 00 00       	call   6a2 <sleep>
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
 21f:	68 bc 0c 00 00       	push   $0xcbc
 224:	6a 01                	push   $0x1
 226:	e8 9e 05 00 00       	call   7c9 <printf>
 22b:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
 22e:	83 ec 0c             	sub    $0xc,%esp
 231:	ff 75 08             	pushl  0x8(%ebp)
 234:	e8 a1 04 00 00       	call   6da <setuid>
 239:	83 c4 10             	add    $0x10,%esp
 23c:	85 c0                	test   %eax,%eax
 23e:	79 14                	jns    254 <invalidTest+0x41>
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
 240:	83 ec 08             	sub    $0x8,%esp
 243:	68 e8 0c 00 00       	push   $0xce8
 248:	6a 01                	push   $0x1
 24a:	e8 7a 05 00 00       	call   7c9 <printf>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	eb 12                	jmp    266 <invalidTest+0x53>
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");
 254:	83 ec 08             	sub    $0x8,%esp
 257:	68 1c 0d 00 00       	push   $0xd1c
 25c:	6a 02                	push   $0x2
 25e:	e8 66 05 00 00       	call   7c9 <printf>
 263:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", nval);
 266:	83 ec 04             	sub    $0x4,%esp
 269:	ff 75 08             	pushl  0x8(%ebp)
 26c:	68 50 0d 00 00       	push   $0xd50
 271:	6a 01                	push   $0x1
 273:	e8 51 05 00 00       	call   7c9 <printf>
 278:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 27b:	83 ec 0c             	sub    $0xc,%esp
 27e:	ff 75 08             	pushl  0x8(%ebp)
 281:	e8 5c 04 00 00       	call   6e2 <setgid>
 286:	83 c4 10             	add    $0x10,%esp
 289:	85 c0                	test   %eax,%eax
 28b:	79 14                	jns    2a1 <invalidTest+0x8e>
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	68 7c 0d 00 00       	push   $0xd7c
 295:	6a 01                	push   $0x1
 297:	e8 2d 05 00 00       	call   7c9 <printf>
 29c:	83 c4 10             	add    $0x10,%esp
  else
    printf(2, "FAILURE! The setgid system call indicates success\n");
}
 29f:	eb 12                	jmp    2b3 <invalidTest+0xa0>

  printf(1, "Setting GID to %d. This test should FAIL\n", nval);
  if (setgid(nval) < 0)
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
  else
    printf(2, "FAILURE! The setgid system call indicates success\n");
 2a1:	83 ec 08             	sub    $0x8,%esp
 2a4:	68 b0 0d 00 00       	push   $0xdb0
 2a9:	6a 02                	push   $0x2
 2ab:	e8 19 05 00 00       	call   7c9 <printf>
 2b0:	83 c4 10             	add    $0x10,%esp
}
 2b3:	90                   	nop
 2b4:	c9                   	leave  
 2b5:	c3                   	ret    

000002b6 <testuidgid>:


static int
testuidgid(void)
{
 2b6:	55                   	push   %ebp
 2b7:	89 e5                	mov    %esp,%ebp
 2b9:	83 ec 18             	sub    $0x18,%esp
  uint nval, ppid;

  // get/set uid test
  nval = 150;
 2bc:	c7 45 f4 96 00 00 00 	movl   $0x96,-0xc(%ebp)
  uidTest(nval);
 2c3:	83 ec 0c             	sub    $0xc,%esp
 2c6:	ff 75 f4             	pushl  -0xc(%ebp)
 2c9:	e8 32 fd ff ff       	call   0 <uidTest>
 2ce:	83 c4 10             	add    $0x10,%esp

  // get/set gid test
  nval = 150;
 2d1:	c7 45 f4 96 00 00 00 	movl   $0x96,-0xc(%ebp)
  gidTest(nval);
 2d8:	83 ec 0c             	sub    $0xc,%esp
 2db:	ff 75 f4             	pushl  -0xc(%ebp)
 2de:	e8 b7 fd ff ff       	call   9a <gidTest>
 2e3:	83 c4 10             	add    $0x10,%esp

  // getppid test
  ppid = getppid();
 2e6:	e8 e7 03 00 00       	call   6d2 <getppid>
 2eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "My parent process is: %d\n", ppid);
 2ee:	83 ec 04             	sub    $0x4,%esp
 2f1:	ff 75 f0             	pushl  -0x10(%ebp)
 2f4:	68 e3 0d 00 00       	push   $0xde3
 2f9:	6a 01                	push   $0x1
 2fb:	e8 c9 04 00 00       	call   7c9 <printf>
 300:	83 c4 10             	add    $0x10,%esp

  // fork tests to demonstrate UID/GID inheritance
  nval = 111;
 303:	c7 45 f4 6f 00 00 00 	movl   $0x6f,-0xc(%ebp)
  forkTest(nval);
 30a:	83 ec 0c             	sub    $0xc,%esp
 30d:	ff 75 f4             	pushl  -0xc(%ebp)
 310:	e8 1f fe ff ff       	call   134 <forkTest>
 315:	83 c4 10             	add    $0x10,%esp

  // tests for invalid values for uid and gid
  nval = 32800;
 318:	c7 45 f4 20 80 00 00 	movl   $0x8020,-0xc(%ebp)
  invalidTest(nval);
 31f:	83 ec 0c             	sub    $0xc,%esp
 322:	ff 75 f4             	pushl  -0xc(%ebp)
 325:	e8 e9 fe ff ff       	call   213 <invalidTest>
 32a:	83 c4 10             	add    $0x10,%esp

  nval = -1;
 32d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  invalidTest(nval);
 334:	83 ec 0c             	sub    $0xc,%esp
 337:	ff 75 f4             	pushl  -0xc(%ebp)
 33a:	e8 d4 fe ff ff       	call   213 <invalidTest>
 33f:	83 c4 10             	add    $0x10,%esp

  printf(1, "Done!\n");
 342:	83 ec 08             	sub    $0x8,%esp
 345:	68 fd 0d 00 00       	push   $0xdfd
 34a:	6a 01                	push   $0x1
 34c:	e8 78 04 00 00       	call   7c9 <printf>
 351:	83 c4 10             	add    $0x10,%esp
  return 0;
 354:	b8 00 00 00 00       	mov    $0x0,%eax
}
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <main>:

int
main()
{
 35b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 35f:	83 e4 f0             	and    $0xfffffff0,%esp
 362:	ff 71 fc             	pushl  -0x4(%ecx)
 365:	55                   	push   %ebp
 366:	89 e5                	mov    %esp,%ebp
 368:	51                   	push   %ecx
 369:	83 ec 04             	sub    $0x4,%esp
  testuidgid();
 36c:	e8 45 ff ff ff       	call   2b6 <testuidgid>
  exit();
 371:	e8 9c 02 00 00       	call   612 <exit>

00000376 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 376:	55                   	push   %ebp
 377:	89 e5                	mov    %esp,%ebp
 379:	57                   	push   %edi
 37a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 37b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 37e:	8b 55 10             	mov    0x10(%ebp),%edx
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	89 cb                	mov    %ecx,%ebx
 386:	89 df                	mov    %ebx,%edi
 388:	89 d1                	mov    %edx,%ecx
 38a:	fc                   	cld    
 38b:	f3 aa                	rep stos %al,%es:(%edi)
 38d:	89 ca                	mov    %ecx,%edx
 38f:	89 fb                	mov    %edi,%ebx
 391:	89 5d 08             	mov    %ebx,0x8(%ebp)
 394:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 397:	90                   	nop
 398:	5b                   	pop    %ebx
 399:	5f                   	pop    %edi
 39a:	5d                   	pop    %ebp
 39b:	c3                   	ret    

0000039c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3a2:	8b 45 08             	mov    0x8(%ebp),%eax
 3a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3a8:	90                   	nop
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ac:	8d 50 01             	lea    0x1(%eax),%edx
 3af:	89 55 08             	mov    %edx,0x8(%ebp)
 3b2:	8b 55 0c             	mov    0xc(%ebp),%edx
 3b5:	8d 4a 01             	lea    0x1(%edx),%ecx
 3b8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3bb:	0f b6 12             	movzbl (%edx),%edx
 3be:	88 10                	mov    %dl,(%eax)
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	84 c0                	test   %al,%al
 3c5:	75 e2                	jne    3a9 <strcpy+0xd>
    ;
  return os;
 3c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ca:	c9                   	leave  
 3cb:	c3                   	ret    

000003cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3cf:	eb 08                	jmp    3d9 <strcmp+0xd>
    p++, q++;
 3d1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3d5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	0f b6 00             	movzbl (%eax),%eax
 3df:	84 c0                	test   %al,%al
 3e1:	74 10                	je     3f3 <strcmp+0x27>
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	0f b6 10             	movzbl (%eax),%edx
 3e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ec:	0f b6 00             	movzbl (%eax),%eax
 3ef:	38 c2                	cmp    %al,%dl
 3f1:	74 de                	je     3d1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	0f b6 00             	movzbl (%eax),%eax
 3f9:	0f b6 d0             	movzbl %al,%edx
 3fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ff:	0f b6 00             	movzbl (%eax),%eax
 402:	0f b6 c0             	movzbl %al,%eax
 405:	29 c2                	sub    %eax,%edx
 407:	89 d0                	mov    %edx,%eax
}
 409:	5d                   	pop    %ebp
 40a:	c3                   	ret    

0000040b <strlen>:

uint
strlen(char *s)
{
 40b:	55                   	push   %ebp
 40c:	89 e5                	mov    %esp,%ebp
 40e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 411:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 418:	eb 04                	jmp    41e <strlen+0x13>
 41a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 41e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	01 d0                	add    %edx,%eax
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	84 c0                	test   %al,%al
 42b:	75 ed                	jne    41a <strlen+0xf>
    ;
  return n;
 42d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 430:	c9                   	leave  
 431:	c3                   	ret    

00000432 <memset>:

void*
memset(void *dst, int c, uint n)
{
 432:	55                   	push   %ebp
 433:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 435:	8b 45 10             	mov    0x10(%ebp),%eax
 438:	50                   	push   %eax
 439:	ff 75 0c             	pushl  0xc(%ebp)
 43c:	ff 75 08             	pushl  0x8(%ebp)
 43f:	e8 32 ff ff ff       	call   376 <stosb>
 444:	83 c4 0c             	add    $0xc,%esp
  return dst;
 447:	8b 45 08             	mov    0x8(%ebp),%eax
}
 44a:	c9                   	leave  
 44b:	c3                   	ret    

0000044c <strchr>:

char*
strchr(const char *s, char c)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 04             	sub    $0x4,%esp
 452:	8b 45 0c             	mov    0xc(%ebp),%eax
 455:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 458:	eb 14                	jmp    46e <strchr+0x22>
    if(*s == c)
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
 45d:	0f b6 00             	movzbl (%eax),%eax
 460:	3a 45 fc             	cmp    -0x4(%ebp),%al
 463:	75 05                	jne    46a <strchr+0x1e>
      return (char*)s;
 465:	8b 45 08             	mov    0x8(%ebp),%eax
 468:	eb 13                	jmp    47d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 46a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	0f b6 00             	movzbl (%eax),%eax
 474:	84 c0                	test   %al,%al
 476:	75 e2                	jne    45a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 478:	b8 00 00 00 00       	mov    $0x0,%eax
}
 47d:	c9                   	leave  
 47e:	c3                   	ret    

0000047f <gets>:

char*
gets(char *buf, int max)
{
 47f:	55                   	push   %ebp
 480:	89 e5                	mov    %esp,%ebp
 482:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 485:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 48c:	eb 42                	jmp    4d0 <gets+0x51>
    cc = read(0, &c, 1);
 48e:	83 ec 04             	sub    $0x4,%esp
 491:	6a 01                	push   $0x1
 493:	8d 45 ef             	lea    -0x11(%ebp),%eax
 496:	50                   	push   %eax
 497:	6a 00                	push   $0x0
 499:	e8 8c 01 00 00       	call   62a <read>
 49e:	83 c4 10             	add    $0x10,%esp
 4a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a8:	7e 33                	jle    4dd <gets+0x5e>
      break;
    buf[i++] = c;
 4aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ad:	8d 50 01             	lea    0x1(%eax),%edx
 4b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b3:	89 c2                	mov    %eax,%edx
 4b5:	8b 45 08             	mov    0x8(%ebp),%eax
 4b8:	01 c2                	add    %eax,%edx
 4ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4be:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c4:	3c 0a                	cmp    $0xa,%al
 4c6:	74 16                	je     4de <gets+0x5f>
 4c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4cc:	3c 0d                	cmp    $0xd,%al
 4ce:	74 0e                	je     4de <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d3:	83 c0 01             	add    $0x1,%eax
 4d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4d9:	7c b3                	jl     48e <gets+0xf>
 4db:	eb 01                	jmp    4de <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4dd:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4de:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
 4e4:	01 d0                	add    %edx,%eax
 4e6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ec:	c9                   	leave  
 4ed:	c3                   	ret    

000004ee <stat>:

int
stat(char *n, struct stat *st)
{
 4ee:	55                   	push   %ebp
 4ef:	89 e5                	mov    %esp,%ebp
 4f1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f4:	83 ec 08             	sub    $0x8,%esp
 4f7:	6a 00                	push   $0x0
 4f9:	ff 75 08             	pushl  0x8(%ebp)
 4fc:	e8 51 01 00 00       	call   652 <open>
 501:	83 c4 10             	add    $0x10,%esp
 504:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 507:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50b:	79 07                	jns    514 <stat+0x26>
    return -1;
 50d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 512:	eb 25                	jmp    539 <stat+0x4b>
  r = fstat(fd, st);
 514:	83 ec 08             	sub    $0x8,%esp
 517:	ff 75 0c             	pushl  0xc(%ebp)
 51a:	ff 75 f4             	pushl  -0xc(%ebp)
 51d:	e8 48 01 00 00       	call   66a <fstat>
 522:	83 c4 10             	add    $0x10,%esp
 525:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 528:	83 ec 0c             	sub    $0xc,%esp
 52b:	ff 75 f4             	pushl  -0xc(%ebp)
 52e:	e8 07 01 00 00       	call   63a <close>
 533:	83 c4 10             	add    $0x10,%esp
  return r;
 536:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 539:	c9                   	leave  
 53a:	c3                   	ret    

0000053b <atoi>:

int
atoi(const char *s)
{
 53b:	55                   	push   %ebp
 53c:	89 e5                	mov    %esp,%ebp
 53e:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 541:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 548:	eb 04                	jmp    54e <atoi+0x13>
 54a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	0f b6 00             	movzbl (%eax),%eax
 554:	3c 20                	cmp    $0x20,%al
 556:	74 f2                	je     54a <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	0f b6 00             	movzbl (%eax),%eax
 55e:	3c 2d                	cmp    $0x2d,%al
 560:	75 07                	jne    569 <atoi+0x2e>
 562:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 567:	eb 05                	jmp    56e <atoi+0x33>
 569:	b8 01 00 00 00       	mov    $0x1,%eax
 56e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	0f b6 00             	movzbl (%eax),%eax
 577:	3c 2b                	cmp    $0x2b,%al
 579:	74 0a                	je     585 <atoi+0x4a>
 57b:	8b 45 08             	mov    0x8(%ebp),%eax
 57e:	0f b6 00             	movzbl (%eax),%eax
 581:	3c 2d                	cmp    $0x2d,%al
 583:	75 2b                	jne    5b0 <atoi+0x75>
    s++;
 585:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 589:	eb 25                	jmp    5b0 <atoi+0x75>
    n = n*10 + *s++ - '0';
 58b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 58e:	89 d0                	mov    %edx,%eax
 590:	c1 e0 02             	shl    $0x2,%eax
 593:	01 d0                	add    %edx,%eax
 595:	01 c0                	add    %eax,%eax
 597:	89 c1                	mov    %eax,%ecx
 599:	8b 45 08             	mov    0x8(%ebp),%eax
 59c:	8d 50 01             	lea    0x1(%eax),%edx
 59f:	89 55 08             	mov    %edx,0x8(%ebp)
 5a2:	0f b6 00             	movzbl (%eax),%eax
 5a5:	0f be c0             	movsbl %al,%eax
 5a8:	01 c8                	add    %ecx,%eax
 5aa:	83 e8 30             	sub    $0x30,%eax
 5ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	0f b6 00             	movzbl (%eax),%eax
 5b6:	3c 2f                	cmp    $0x2f,%al
 5b8:	7e 0a                	jle    5c4 <atoi+0x89>
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	0f b6 00             	movzbl (%eax),%eax
 5c0:	3c 39                	cmp    $0x39,%al
 5c2:	7e c7                	jle    58b <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 5c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c7:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 5cb:	c9                   	leave  
 5cc:	c3                   	ret    

000005cd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5cd:	55                   	push   %ebp
 5ce:	89 e5                	mov    %esp,%ebp
 5d0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5df:	eb 17                	jmp    5f8 <memmove+0x2b>
    *dst++ = *src++;
 5e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e4:	8d 50 01             	lea    0x1(%eax),%edx
 5e7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5ed:	8d 4a 01             	lea    0x1(%edx),%ecx
 5f0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5f3:	0f b6 12             	movzbl (%edx),%edx
 5f6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5f8:	8b 45 10             	mov    0x10(%ebp),%eax
 5fb:	8d 50 ff             	lea    -0x1(%eax),%edx
 5fe:	89 55 10             	mov    %edx,0x10(%ebp)
 601:	85 c0                	test   %eax,%eax
 603:	7f dc                	jg     5e1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 605:	8b 45 08             	mov    0x8(%ebp),%eax
}
 608:	c9                   	leave  
 609:	c3                   	ret    

0000060a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 60a:	b8 01 00 00 00       	mov    $0x1,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <exit>:
SYSCALL(exit)
 612:	b8 02 00 00 00       	mov    $0x2,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <wait>:
SYSCALL(wait)
 61a:	b8 03 00 00 00       	mov    $0x3,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <pipe>:
SYSCALL(pipe)
 622:	b8 04 00 00 00       	mov    $0x4,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <read>:
SYSCALL(read)
 62a:	b8 05 00 00 00       	mov    $0x5,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <write>:
SYSCALL(write)
 632:	b8 10 00 00 00       	mov    $0x10,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <close>:
SYSCALL(close)
 63a:	b8 15 00 00 00       	mov    $0x15,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <kill>:
SYSCALL(kill)
 642:	b8 06 00 00 00       	mov    $0x6,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <exec>:
SYSCALL(exec)
 64a:	b8 07 00 00 00       	mov    $0x7,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <open>:
SYSCALL(open)
 652:	b8 0f 00 00 00       	mov    $0xf,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <mknod>:
SYSCALL(mknod)
 65a:	b8 11 00 00 00       	mov    $0x11,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <unlink>:
SYSCALL(unlink)
 662:	b8 12 00 00 00       	mov    $0x12,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <fstat>:
SYSCALL(fstat)
 66a:	b8 08 00 00 00       	mov    $0x8,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <link>:
SYSCALL(link)
 672:	b8 13 00 00 00       	mov    $0x13,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <mkdir>:
SYSCALL(mkdir)
 67a:	b8 14 00 00 00       	mov    $0x14,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <chdir>:
SYSCALL(chdir)
 682:	b8 09 00 00 00       	mov    $0x9,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <dup>:
SYSCALL(dup)
 68a:	b8 0a 00 00 00       	mov    $0xa,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <getpid>:
SYSCALL(getpid)
 692:	b8 0b 00 00 00       	mov    $0xb,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <sbrk>:
SYSCALL(sbrk)
 69a:	b8 0c 00 00 00       	mov    $0xc,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <sleep>:
SYSCALL(sleep)
 6a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <uptime>:
SYSCALL(uptime)
 6aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <halt>:
SYSCALL(halt)
 6b2:	b8 16 00 00 00       	mov    $0x16,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <date>:
SYSCALL(date)      #p1
 6ba:	b8 17 00 00 00       	mov    $0x17,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <getuid>:
SYSCALL(getuid)    #p2
 6c2:	b8 18 00 00 00       	mov    $0x18,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    

000006ca <getgid>:
SYSCALL(getgid)    #p2
 6ca:	b8 19 00 00 00       	mov    $0x19,%eax
 6cf:	cd 40                	int    $0x40
 6d1:	c3                   	ret    

000006d2 <getppid>:
SYSCALL(getppid)   #p2
 6d2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6d7:	cd 40                	int    $0x40
 6d9:	c3                   	ret    

000006da <setuid>:
SYSCALL(setuid)    #p2
 6da:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6df:	cd 40                	int    $0x40
 6e1:	c3                   	ret    

000006e2 <setgid>:
SYSCALL(setgid)    #p2
 6e2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6e7:	cd 40                	int    $0x40
 6e9:	c3                   	ret    

000006ea <getprocs>:
SYSCALL(getprocs)  #p2
 6ea:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6ef:	cd 40                	int    $0x40
 6f1:	c3                   	ret    

000006f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6f2:	55                   	push   %ebp
 6f3:	89 e5                	mov    %esp,%ebp
 6f5:	83 ec 18             	sub    $0x18,%esp
 6f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6fb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6fe:	83 ec 04             	sub    $0x4,%esp
 701:	6a 01                	push   $0x1
 703:	8d 45 f4             	lea    -0xc(%ebp),%eax
 706:	50                   	push   %eax
 707:	ff 75 08             	pushl  0x8(%ebp)
 70a:	e8 23 ff ff ff       	call   632 <write>
 70f:	83 c4 10             	add    $0x10,%esp
}
 712:	90                   	nop
 713:	c9                   	leave  
 714:	c3                   	ret    

00000715 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 715:	55                   	push   %ebp
 716:	89 e5                	mov    %esp,%ebp
 718:	53                   	push   %ebx
 719:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 71c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 723:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 727:	74 17                	je     740 <printint+0x2b>
 729:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 72d:	79 11                	jns    740 <printint+0x2b>
    neg = 1;
 72f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 736:	8b 45 0c             	mov    0xc(%ebp),%eax
 739:	f7 d8                	neg    %eax
 73b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 73e:	eb 06                	jmp    746 <printint+0x31>
  } else {
    x = xx;
 740:	8b 45 0c             	mov    0xc(%ebp),%eax
 743:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 746:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 74d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 750:	8d 41 01             	lea    0x1(%ecx),%eax
 753:	89 45 f4             	mov    %eax,-0xc(%ebp)
 756:	8b 5d 10             	mov    0x10(%ebp),%ebx
 759:	8b 45 ec             	mov    -0x14(%ebp),%eax
 75c:	ba 00 00 00 00       	mov    $0x0,%edx
 761:	f7 f3                	div    %ebx
 763:	89 d0                	mov    %edx,%eax
 765:	0f b6 80 f8 10 00 00 	movzbl 0x10f8(%eax),%eax
 76c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 770:	8b 5d 10             	mov    0x10(%ebp),%ebx
 773:	8b 45 ec             	mov    -0x14(%ebp),%eax
 776:	ba 00 00 00 00       	mov    $0x0,%edx
 77b:	f7 f3                	div    %ebx
 77d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 780:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 784:	75 c7                	jne    74d <printint+0x38>
  if(neg)
 786:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 78a:	74 2d                	je     7b9 <printint+0xa4>
    buf[i++] = '-';
 78c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78f:	8d 50 01             	lea    0x1(%eax),%edx
 792:	89 55 f4             	mov    %edx,-0xc(%ebp)
 795:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 79a:	eb 1d                	jmp    7b9 <printint+0xa4>
    putc(fd, buf[i]);
 79c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	01 d0                	add    %edx,%eax
 7a4:	0f b6 00             	movzbl (%eax),%eax
 7a7:	0f be c0             	movsbl %al,%eax
 7aa:	83 ec 08             	sub    $0x8,%esp
 7ad:	50                   	push   %eax
 7ae:	ff 75 08             	pushl  0x8(%ebp)
 7b1:	e8 3c ff ff ff       	call   6f2 <putc>
 7b6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7b9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 7bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c1:	79 d9                	jns    79c <printint+0x87>
    putc(fd, buf[i]);
}
 7c3:	90                   	nop
 7c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7c7:	c9                   	leave  
 7c8:	c3                   	ret    

000007c9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7c9:	55                   	push   %ebp
 7ca:	89 e5                	mov    %esp,%ebp
 7cc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7d6:	8d 45 0c             	lea    0xc(%ebp),%eax
 7d9:	83 c0 04             	add    $0x4,%eax
 7dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7e6:	e9 59 01 00 00       	jmp    944 <printf+0x17b>
    c = fmt[i] & 0xff;
 7eb:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	01 d0                	add    %edx,%eax
 7f3:	0f b6 00             	movzbl (%eax),%eax
 7f6:	0f be c0             	movsbl %al,%eax
 7f9:	25 ff 00 00 00       	and    $0xff,%eax
 7fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 801:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 805:	75 2c                	jne    833 <printf+0x6a>
      if(c == '%'){
 807:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 80b:	75 0c                	jne    819 <printf+0x50>
        state = '%';
 80d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 814:	e9 27 01 00 00       	jmp    940 <printf+0x177>
      } else {
        putc(fd, c);
 819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 81c:	0f be c0             	movsbl %al,%eax
 81f:	83 ec 08             	sub    $0x8,%esp
 822:	50                   	push   %eax
 823:	ff 75 08             	pushl  0x8(%ebp)
 826:	e8 c7 fe ff ff       	call   6f2 <putc>
 82b:	83 c4 10             	add    $0x10,%esp
 82e:	e9 0d 01 00 00       	jmp    940 <printf+0x177>
      }
    } else if(state == '%'){
 833:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 837:	0f 85 03 01 00 00    	jne    940 <printf+0x177>
      if(c == 'd'){
 83d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 841:	75 1e                	jne    861 <printf+0x98>
        printint(fd, *ap, 10, 1);
 843:	8b 45 e8             	mov    -0x18(%ebp),%eax
 846:	8b 00                	mov    (%eax),%eax
 848:	6a 01                	push   $0x1
 84a:	6a 0a                	push   $0xa
 84c:	50                   	push   %eax
 84d:	ff 75 08             	pushl  0x8(%ebp)
 850:	e8 c0 fe ff ff       	call   715 <printint>
 855:	83 c4 10             	add    $0x10,%esp
        ap++;
 858:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 85c:	e9 d8 00 00 00       	jmp    939 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 861:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 865:	74 06                	je     86d <printf+0xa4>
 867:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 86b:	75 1e                	jne    88b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 86d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 870:	8b 00                	mov    (%eax),%eax
 872:	6a 00                	push   $0x0
 874:	6a 10                	push   $0x10
 876:	50                   	push   %eax
 877:	ff 75 08             	pushl  0x8(%ebp)
 87a:	e8 96 fe ff ff       	call   715 <printint>
 87f:	83 c4 10             	add    $0x10,%esp
        ap++;
 882:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 886:	e9 ae 00 00 00       	jmp    939 <printf+0x170>
      } else if(c == 's'){
 88b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 88f:	75 43                	jne    8d4 <printf+0x10b>
        s = (char*)*ap;
 891:	8b 45 e8             	mov    -0x18(%ebp),%eax
 894:	8b 00                	mov    (%eax),%eax
 896:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 899:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 89d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a1:	75 25                	jne    8c8 <printf+0xff>
          s = "(null)";
 8a3:	c7 45 f4 04 0e 00 00 	movl   $0xe04,-0xc(%ebp)
        while(*s != 0){
 8aa:	eb 1c                	jmp    8c8 <printf+0xff>
          putc(fd, *s);
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	0f b6 00             	movzbl (%eax),%eax
 8b2:	0f be c0             	movsbl %al,%eax
 8b5:	83 ec 08             	sub    $0x8,%esp
 8b8:	50                   	push   %eax
 8b9:	ff 75 08             	pushl  0x8(%ebp)
 8bc:	e8 31 fe ff ff       	call   6f2 <putc>
 8c1:	83 c4 10             	add    $0x10,%esp
          s++;
 8c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	0f b6 00             	movzbl (%eax),%eax
 8ce:	84 c0                	test   %al,%al
 8d0:	75 da                	jne    8ac <printf+0xe3>
 8d2:	eb 65                	jmp    939 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8d4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8d8:	75 1d                	jne    8f7 <printf+0x12e>
        putc(fd, *ap);
 8da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8dd:	8b 00                	mov    (%eax),%eax
 8df:	0f be c0             	movsbl %al,%eax
 8e2:	83 ec 08             	sub    $0x8,%esp
 8e5:	50                   	push   %eax
 8e6:	ff 75 08             	pushl  0x8(%ebp)
 8e9:	e8 04 fe ff ff       	call   6f2 <putc>
 8ee:	83 c4 10             	add    $0x10,%esp
        ap++;
 8f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8f5:	eb 42                	jmp    939 <printf+0x170>
      } else if(c == '%'){
 8f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8fb:	75 17                	jne    914 <printf+0x14b>
        putc(fd, c);
 8fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 900:	0f be c0             	movsbl %al,%eax
 903:	83 ec 08             	sub    $0x8,%esp
 906:	50                   	push   %eax
 907:	ff 75 08             	pushl  0x8(%ebp)
 90a:	e8 e3 fd ff ff       	call   6f2 <putc>
 90f:	83 c4 10             	add    $0x10,%esp
 912:	eb 25                	jmp    939 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 914:	83 ec 08             	sub    $0x8,%esp
 917:	6a 25                	push   $0x25
 919:	ff 75 08             	pushl  0x8(%ebp)
 91c:	e8 d1 fd ff ff       	call   6f2 <putc>
 921:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 927:	0f be c0             	movsbl %al,%eax
 92a:	83 ec 08             	sub    $0x8,%esp
 92d:	50                   	push   %eax
 92e:	ff 75 08             	pushl  0x8(%ebp)
 931:	e8 bc fd ff ff       	call   6f2 <putc>
 936:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 939:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 940:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 944:	8b 55 0c             	mov    0xc(%ebp),%edx
 947:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94a:	01 d0                	add    %edx,%eax
 94c:	0f b6 00             	movzbl (%eax),%eax
 94f:	84 c0                	test   %al,%al
 951:	0f 85 94 fe ff ff    	jne    7eb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 957:	90                   	nop
 958:	c9                   	leave  
 959:	c3                   	ret    

0000095a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 95a:	55                   	push   %ebp
 95b:	89 e5                	mov    %esp,%ebp
 95d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 960:	8b 45 08             	mov    0x8(%ebp),%eax
 963:	83 e8 08             	sub    $0x8,%eax
 966:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 969:	a1 14 11 00 00       	mov    0x1114,%eax
 96e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 971:	eb 24                	jmp    997 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 973:	8b 45 fc             	mov    -0x4(%ebp),%eax
 976:	8b 00                	mov    (%eax),%eax
 978:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 97b:	77 12                	ja     98f <free+0x35>
 97d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 980:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 983:	77 24                	ja     9a9 <free+0x4f>
 985:	8b 45 fc             	mov    -0x4(%ebp),%eax
 988:	8b 00                	mov    (%eax),%eax
 98a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 98d:	77 1a                	ja     9a9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 992:	8b 00                	mov    (%eax),%eax
 994:	89 45 fc             	mov    %eax,-0x4(%ebp)
 997:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 99d:	76 d4                	jbe    973 <free+0x19>
 99f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a2:	8b 00                	mov    (%eax),%eax
 9a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9a7:	76 ca                	jbe    973 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ac:	8b 40 04             	mov    0x4(%eax),%eax
 9af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b9:	01 c2                	add    %eax,%edx
 9bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9be:	8b 00                	mov    (%eax),%eax
 9c0:	39 c2                	cmp    %eax,%edx
 9c2:	75 24                	jne    9e8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c7:	8b 50 04             	mov    0x4(%eax),%edx
 9ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cd:	8b 00                	mov    (%eax),%eax
 9cf:	8b 40 04             	mov    0x4(%eax),%eax
 9d2:	01 c2                	add    %eax,%edx
 9d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dd:	8b 00                	mov    (%eax),%eax
 9df:	8b 10                	mov    (%eax),%edx
 9e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e4:	89 10                	mov    %edx,(%eax)
 9e6:	eb 0a                	jmp    9f2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9eb:	8b 10                	mov    (%eax),%edx
 9ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f5:	8b 40 04             	mov    0x4(%eax),%eax
 9f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a02:	01 d0                	add    %edx,%eax
 a04:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a07:	75 20                	jne    a29 <free+0xcf>
    p->s.size += bp->s.size;
 a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0c:	8b 50 04             	mov    0x4(%eax),%edx
 a0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a12:	8b 40 04             	mov    0x4(%eax),%eax
 a15:	01 c2                	add    %eax,%edx
 a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a20:	8b 10                	mov    (%eax),%edx
 a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a25:	89 10                	mov    %edx,(%eax)
 a27:	eb 08                	jmp    a31 <free+0xd7>
  } else
    p->s.ptr = bp;
 a29:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a2f:	89 10                	mov    %edx,(%eax)
  freep = p;
 a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a34:	a3 14 11 00 00       	mov    %eax,0x1114
}
 a39:	90                   	nop
 a3a:	c9                   	leave  
 a3b:	c3                   	ret    

00000a3c <morecore>:

static Header*
morecore(uint nu)
{
 a3c:	55                   	push   %ebp
 a3d:	89 e5                	mov    %esp,%ebp
 a3f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a42:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a49:	77 07                	ja     a52 <morecore+0x16>
    nu = 4096;
 a4b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a52:	8b 45 08             	mov    0x8(%ebp),%eax
 a55:	c1 e0 03             	shl    $0x3,%eax
 a58:	83 ec 0c             	sub    $0xc,%esp
 a5b:	50                   	push   %eax
 a5c:	e8 39 fc ff ff       	call   69a <sbrk>
 a61:	83 c4 10             	add    $0x10,%esp
 a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a67:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a6b:	75 07                	jne    a74 <morecore+0x38>
    return 0;
 a6d:	b8 00 00 00 00       	mov    $0x0,%eax
 a72:	eb 26                	jmp    a9a <morecore+0x5e>
  hp = (Header*)p;
 a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7d:	8b 55 08             	mov    0x8(%ebp),%edx
 a80:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a86:	83 c0 08             	add    $0x8,%eax
 a89:	83 ec 0c             	sub    $0xc,%esp
 a8c:	50                   	push   %eax
 a8d:	e8 c8 fe ff ff       	call   95a <free>
 a92:	83 c4 10             	add    $0x10,%esp
  return freep;
 a95:	a1 14 11 00 00       	mov    0x1114,%eax
}
 a9a:	c9                   	leave  
 a9b:	c3                   	ret    

00000a9c <malloc>:

void*
malloc(uint nbytes)
{
 a9c:	55                   	push   %ebp
 a9d:	89 e5                	mov    %esp,%ebp
 a9f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aa2:	8b 45 08             	mov    0x8(%ebp),%eax
 aa5:	83 c0 07             	add    $0x7,%eax
 aa8:	c1 e8 03             	shr    $0x3,%eax
 aab:	83 c0 01             	add    $0x1,%eax
 aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ab1:	a1 14 11 00 00       	mov    0x1114,%eax
 ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ab9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 abd:	75 23                	jne    ae2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 abf:	c7 45 f0 0c 11 00 00 	movl   $0x110c,-0x10(%ebp)
 ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac9:	a3 14 11 00 00       	mov    %eax,0x1114
 ace:	a1 14 11 00 00       	mov    0x1114,%eax
 ad3:	a3 0c 11 00 00       	mov    %eax,0x110c
    base.s.size = 0;
 ad8:	c7 05 10 11 00 00 00 	movl   $0x0,0x1110
 adf:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae5:	8b 00                	mov    (%eax),%eax
 ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aed:	8b 40 04             	mov    0x4(%eax),%eax
 af0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 af3:	72 4d                	jb     b42 <malloc+0xa6>
      if(p->s.size == nunits)
 af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af8:	8b 40 04             	mov    0x4(%eax),%eax
 afb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 afe:	75 0c                	jne    b0c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b03:	8b 10                	mov    (%eax),%edx
 b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b08:	89 10                	mov    %edx,(%eax)
 b0a:	eb 26                	jmp    b32 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0f:	8b 40 04             	mov    0x4(%eax),%eax
 b12:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b15:	89 c2                	mov    %eax,%edx
 b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b20:	8b 40 04             	mov    0x4(%eax),%eax
 b23:	c1 e0 03             	shl    $0x3,%eax
 b26:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b2f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b35:	a3 14 11 00 00       	mov    %eax,0x1114
      return (void*)(p + 1);
 b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3d:	83 c0 08             	add    $0x8,%eax
 b40:	eb 3b                	jmp    b7d <malloc+0xe1>
    }
    if(p == freep)
 b42:	a1 14 11 00 00       	mov    0x1114,%eax
 b47:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b4a:	75 1e                	jne    b6a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b4c:	83 ec 0c             	sub    $0xc,%esp
 b4f:	ff 75 ec             	pushl  -0x14(%ebp)
 b52:	e8 e5 fe ff ff       	call   a3c <morecore>
 b57:	83 c4 10             	add    $0x10,%esp
 b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b61:	75 07                	jne    b6a <malloc+0xce>
        return 0;
 b63:	b8 00 00 00 00       	mov    $0x0,%eax
 b68:	eb 13                	jmp    b7d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b73:	8b 00                	mov    (%eax),%eax
 b75:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b78:	e9 6d ff ff ff       	jmp    aea <malloc+0x4e>
}
 b7d:	c9                   	leave  
 b7e:	c3                   	ret    
