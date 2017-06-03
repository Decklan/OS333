
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
   6:	e8 45 07 00 00       	call   750 <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 30 0c 00 00       	push   $0xc30
  19:	6a 01                	push   $0x1
  1b:	e8 57 08 00 00       	call   877 <printf>
  20:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to %d\n", nval);
  23:	83 ec 04             	sub    $0x4,%esp
  26:	ff 75 08             	pushl  0x8(%ebp)
  29:	68 44 0c 00 00       	push   $0xc44
  2e:	6a 01                	push   $0x1
  30:	e8 42 08 00 00       	call   877 <printf>
  35:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	ff 75 08             	pushl  0x8(%ebp)
  3e:	e8 25 07 00 00       	call   768 <setuid>
  43:	83 c4 10             	add    $0x10,%esp
  46:	85 c0                	test   %eax,%eax
  48:	79 15                	jns    5f <uidTest+0x5f>
    printf(2, "Error. Invalid UID: %d\n", nval);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 08             	pushl  0x8(%ebp)
  50:	68 57 0c 00 00       	push   $0xc57
  55:	6a 02                	push   $0x2
  57:	e8 1b 08 00 00       	call   877 <printf>
  5c:	83 c4 10             	add    $0x10,%esp
  setuid(nval);
  5f:	83 ec 0c             	sub    $0xc,%esp
  62:	ff 75 08             	pushl  0x8(%ebp)
  65:	e8 fe 06 00 00       	call   768 <setuid>
  6a:	83 c4 10             	add    $0x10,%esp
  uid = getuid();
  6d:	e8 de 06 00 00       	call   750 <getuid>
  72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  75:	83 ec 04             	sub    $0x4,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	68 30 0c 00 00       	push   $0xc30
  80:	6a 01                	push   $0x1
  82:	e8 f0 07 00 00       	call   877 <printf>
  87:	83 c4 10             	add    $0x10,%esp
  sleep(5 * TPS); // now type control-p
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	6a 32                	push   $0x32
  8f:	e8 9c 06 00 00       	call   730 <sleep>
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
  a0:	e8 b3 06 00 00       	call   758 <getgid>
  a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current GID is: %d\n", gid);
  a8:	83 ec 04             	sub    $0x4,%esp
  ab:	ff 75 f4             	pushl  -0xc(%ebp)
  ae:	68 6f 0c 00 00       	push   $0xc6f
  b3:	6a 01                	push   $0x1
  b5:	e8 bd 07 00 00       	call   877 <printf>
  ba:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to %d\n", nval);
  bd:	83 ec 04             	sub    $0x4,%esp
  c0:	ff 75 08             	pushl  0x8(%ebp)
  c3:	68 83 0c 00 00       	push   $0xc83
  c8:	6a 01                	push   $0x1
  ca:	e8 a8 07 00 00       	call   877 <printf>
  cf:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
  d2:	83 ec 0c             	sub    $0xc,%esp
  d5:	ff 75 08             	pushl  0x8(%ebp)
  d8:	e8 93 06 00 00       	call   770 <setgid>
  dd:	83 c4 10             	add    $0x10,%esp
  e0:	85 c0                	test   %eax,%eax
  e2:	79 15                	jns    f9 <gidTest+0x5f>
    printf(2, "Error. Invalid GID: %d\n", nval);
  e4:	83 ec 04             	sub    $0x4,%esp
  e7:	ff 75 08             	pushl  0x8(%ebp)
  ea:	68 96 0c 00 00       	push   $0xc96
  ef:	6a 02                	push   $0x2
  f1:	e8 81 07 00 00       	call   877 <printf>
  f6:	83 c4 10             	add    $0x10,%esp
  setgid(nval);
  f9:	83 ec 0c             	sub    $0xc,%esp
  fc:	ff 75 08             	pushl  0x8(%ebp)
  ff:	e8 6c 06 00 00       	call   770 <setgid>
 104:	83 c4 10             	add    $0x10,%esp
  gid = getgid();
 107:	e8 4c 06 00 00       	call   758 <getgid>
 10c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 10f:	83 ec 04             	sub    $0x4,%esp
 112:	ff 75 f4             	pushl  -0xc(%ebp)
 115:	68 6f 0c 00 00       	push   $0xc6f
 11a:	6a 01                	push   $0x1
 11c:	e8 56 07 00 00       	call   877 <printf>
 121:	83 c4 10             	add    $0x10,%esp
  sleep(5 * TPS); // now type control-p
 124:	83 ec 0c             	sub    $0xc,%esp
 127:	6a 32                	push   $0x32
 129:	e8 02 06 00 00       	call   730 <sleep>
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
 141:	68 b0 0c 00 00       	push   $0xcb0
 146:	6a 01                	push   $0x1
 148:	e8 2a 07 00 00       	call   877 <printf>
 14d:	83 c4 10             	add    $0x10,%esp
       	                " should be inherited\n", nval, nval);

  if (setuid(nval) < 0)
 150:	83 ec 0c             	sub    $0xc,%esp
 153:	ff 75 08             	pushl  0x8(%ebp)
 156:	e8 0d 06 00 00       	call   768 <setuid>
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	85 c0                	test   %eax,%eax
 160:	79 15                	jns    177 <forkTest+0x43>
    printf(2, "Error.Invalid UID: %d\n", nval);
 162:	83 ec 04             	sub    $0x4,%esp
 165:	ff 75 08             	pushl  0x8(%ebp)
 168:	68 fa 0c 00 00       	push   $0xcfa
 16d:	6a 02                	push   $0x2
 16f:	e8 03 07 00 00       	call   877 <printf>
 174:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 177:	83 ec 0c             	sub    $0xc,%esp
 17a:	ff 75 08             	pushl  0x8(%ebp)
 17d:	e8 ee 05 00 00       	call   770 <setgid>
 182:	83 c4 10             	add    $0x10,%esp
 185:	85 c0                	test   %eax,%eax
 187:	79 15                	jns    19e <forkTest+0x6a>
    printf(2, "Error.Invalid GID: %d\n", nval);
 189:	83 ec 04             	sub    $0x4,%esp
 18c:	ff 75 08             	pushl  0x8(%ebp)
 18f:	68 11 0d 00 00       	push   $0xd11
 194:	6a 02                	push   $0x2
 196:	e8 dc 06 00 00       	call   877 <printf>
 19b:	83 c4 10             	add    $0x10,%esp
  
  printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getgid());
 19e:	e8 b5 05 00 00       	call   758 <getgid>
 1a3:	89 c3                	mov    %eax,%ebx
 1a5:	e8 a6 05 00 00       	call   750 <getuid>
 1aa:	53                   	push   %ebx
 1ab:	50                   	push   %eax
 1ac:	68 28 0d 00 00       	push   $0xd28
 1b1:	6a 01                	push   $0x1
 1b3:	e8 bf 06 00 00       	call   877 <printf>
 1b8:	83 c4 10             	add    $0x10,%esp
  pid = fork();
 1bb:	e8 d8 04 00 00       	call   698 <fork>
 1c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (pid == 0) {  // child
 1c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c7:	75 37                	jne    200 <forkTest+0xcc>
    uid = getuid();
 1c9:	e8 82 05 00 00       	call   750 <getuid>
 1ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    gid = getgid();
 1d1:	e8 82 05 00 00       	call   758 <getgid>
 1d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1, "Child: UID is: %d, GID is: %d\n", uid, gid);
 1d9:	ff 75 ec             	pushl  -0x14(%ebp)
 1dc:	ff 75 f0             	pushl  -0x10(%ebp)
 1df:	68 4c 0d 00 00       	push   $0xd4c
 1e4:	6a 01                	push   $0x1
 1e6:	e8 8c 06 00 00       	call   877 <printf>
 1eb:	83 c4 10             	add    $0x10,%esp
    sleep(5 * TPS);  // now type control-p
 1ee:	83 ec 0c             	sub    $0xc,%esp
 1f1:	6a 32                	push   $0x32
 1f3:	e8 38 05 00 00       	call   730 <sleep>
 1f8:	83 c4 10             	add    $0x10,%esp
    exit();
 1fb:	e8 a0 04 00 00       	call   6a0 <exit>
  }
  else
    sleep(10 * TPS);
 200:	83 ec 0c             	sub    $0xc,%esp
 203:	6a 64                	push   $0x64
 205:	e8 26 05 00 00       	call   730 <sleep>
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
 21f:	68 6c 0d 00 00       	push   $0xd6c
 224:	6a 01                	push   $0x1
 226:	e8 4c 06 00 00       	call   877 <printf>
 22b:	83 c4 10             	add    $0x10,%esp
  if (setuid(nval) < 0)
 22e:	83 ec 0c             	sub    $0xc,%esp
 231:	ff 75 08             	pushl  0x8(%ebp)
 234:	e8 2f 05 00 00       	call   768 <setuid>
 239:	83 c4 10             	add    $0x10,%esp
 23c:	85 c0                	test   %eax,%eax
 23e:	79 14                	jns    254 <invalidTest+0x41>
    printf(1, "SUCCESS! The setuid system call indicated failure\n");
 240:	83 ec 08             	sub    $0x8,%esp
 243:	68 98 0d 00 00       	push   $0xd98
 248:	6a 01                	push   $0x1
 24a:	e8 28 06 00 00       	call   877 <printf>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	eb 12                	jmp    266 <invalidTest+0x53>
  else
    printf(2, "FAILURE! The setuid system call indicates success\n");
 254:	83 ec 08             	sub    $0x8,%esp
 257:	68 cc 0d 00 00       	push   $0xdcc
 25c:	6a 02                	push   $0x2
 25e:	e8 14 06 00 00       	call   877 <printf>
 263:	83 c4 10             	add    $0x10,%esp

  printf(1, "Setting GID to %d. This test should FAIL\n", nval);
 266:	83 ec 04             	sub    $0x4,%esp
 269:	ff 75 08             	pushl  0x8(%ebp)
 26c:	68 00 0e 00 00       	push   $0xe00
 271:	6a 01                	push   $0x1
 273:	e8 ff 05 00 00       	call   877 <printf>
 278:	83 c4 10             	add    $0x10,%esp
  if (setgid(nval) < 0)
 27b:	83 ec 0c             	sub    $0xc,%esp
 27e:	ff 75 08             	pushl  0x8(%ebp)
 281:	e8 ea 04 00 00       	call   770 <setgid>
 286:	83 c4 10             	add    $0x10,%esp
 289:	85 c0                	test   %eax,%eax
 28b:	79 14                	jns    2a1 <invalidTest+0x8e>
    printf(1, "SUCCESS! The setgid system call indicated failure\n");
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	68 2c 0e 00 00       	push   $0xe2c
 295:	6a 01                	push   $0x1
 297:	e8 db 05 00 00       	call   877 <printf>
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
 2a4:	68 60 0e 00 00       	push   $0xe60
 2a9:	6a 02                	push   $0x2
 2ab:	e8 c7 05 00 00       	call   877 <printf>
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
 2e6:	e8 75 04 00 00       	call   760 <getppid>
 2eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "My parent process is: %d\n", ppid);
 2ee:	83 ec 04             	sub    $0x4,%esp
 2f1:	ff 75 f0             	pushl  -0x10(%ebp)
 2f4:	68 93 0e 00 00       	push   $0xe93
 2f9:	6a 01                	push   $0x1
 2fb:	e8 77 05 00 00       	call   877 <printf>
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
 345:	68 ad 0e 00 00       	push   $0xead
 34a:	6a 01                	push   $0x1
 34c:	e8 26 05 00 00       	call   877 <printf>
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
 371:	e8 2a 03 00 00       	call   6a0 <exit>

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
 499:	e8 1a 02 00 00       	call   6b8 <read>
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
 4fc:	e8 df 01 00 00       	call   6e0 <open>
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
 51d:	e8 d6 01 00 00       	call   6f8 <fstat>
 522:	83 c4 10             	add    $0x10,%esp
 525:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 528:	83 ec 0c             	sub    $0xc,%esp
 52b:	ff 75 f4             	pushl  -0xc(%ebp)
 52e:	e8 95 01 00 00       	call   6c8 <close>
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

000005cd <atoo>:

int
atoo(const char *s)
{
 5cd:	55                   	push   %ebp
 5ce:	89 e5                	mov    %esp,%ebp
 5d0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 5d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 5da:	eb 04                	jmp    5e0 <atoo+0x13>
 5dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5e0:	8b 45 08             	mov    0x8(%ebp),%eax
 5e3:	0f b6 00             	movzbl (%eax),%eax
 5e6:	3c 20                	cmp    $0x20,%al
 5e8:	74 f2                	je     5dc <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	0f b6 00             	movzbl (%eax),%eax
 5f0:	3c 2d                	cmp    $0x2d,%al
 5f2:	75 07                	jne    5fb <atoo+0x2e>
 5f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5f9:	eb 05                	jmp    600 <atoo+0x33>
 5fb:	b8 01 00 00 00       	mov    $0x1,%eax
 600:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 603:	8b 45 08             	mov    0x8(%ebp),%eax
 606:	0f b6 00             	movzbl (%eax),%eax
 609:	3c 2b                	cmp    $0x2b,%al
 60b:	74 0a                	je     617 <atoo+0x4a>
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	0f b6 00             	movzbl (%eax),%eax
 613:	3c 2d                	cmp    $0x2d,%al
 615:	75 27                	jne    63e <atoo+0x71>
    s++;
 617:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 61b:	eb 21                	jmp    63e <atoo+0x71>
    n = n*8 + *s++ - '0';
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 627:	8b 45 08             	mov    0x8(%ebp),%eax
 62a:	8d 50 01             	lea    0x1(%eax),%edx
 62d:	89 55 08             	mov    %edx,0x8(%ebp)
 630:	0f b6 00             	movzbl (%eax),%eax
 633:	0f be c0             	movsbl %al,%eax
 636:	01 c8                	add    %ecx,%eax
 638:	83 e8 30             	sub    $0x30,%eax
 63b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	0f b6 00             	movzbl (%eax),%eax
 644:	3c 2f                	cmp    $0x2f,%al
 646:	7e 0a                	jle    652 <atoo+0x85>
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	0f b6 00             	movzbl (%eax),%eax
 64e:	3c 37                	cmp    $0x37,%al
 650:	7e cb                	jle    61d <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 659:	c9                   	leave  
 65a:	c3                   	ret    

0000065b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 65b:	55                   	push   %ebp
 65c:	89 e5                	mov    %esp,%ebp
 65e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 661:	8b 45 08             	mov    0x8(%ebp),%eax
 664:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 667:	8b 45 0c             	mov    0xc(%ebp),%eax
 66a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 66d:	eb 17                	jmp    686 <memmove+0x2b>
    *dst++ = *src++;
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8d 50 01             	lea    0x1(%eax),%edx
 675:	89 55 fc             	mov    %edx,-0x4(%ebp)
 678:	8b 55 f8             	mov    -0x8(%ebp),%edx
 67b:	8d 4a 01             	lea    0x1(%edx),%ecx
 67e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 681:	0f b6 12             	movzbl (%edx),%edx
 684:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 686:	8b 45 10             	mov    0x10(%ebp),%eax
 689:	8d 50 ff             	lea    -0x1(%eax),%edx
 68c:	89 55 10             	mov    %edx,0x10(%ebp)
 68f:	85 c0                	test   %eax,%eax
 691:	7f dc                	jg     66f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 693:	8b 45 08             	mov    0x8(%ebp),%eax
}
 696:	c9                   	leave  
 697:	c3                   	ret    

00000698 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 698:	b8 01 00 00 00       	mov    $0x1,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <exit>:
SYSCALL(exit)
 6a0:	b8 02 00 00 00       	mov    $0x2,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <wait>:
SYSCALL(wait)
 6a8:	b8 03 00 00 00       	mov    $0x3,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <pipe>:
SYSCALL(pipe)
 6b0:	b8 04 00 00 00       	mov    $0x4,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <read>:
SYSCALL(read)
 6b8:	b8 05 00 00 00       	mov    $0x5,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <write>:
SYSCALL(write)
 6c0:	b8 10 00 00 00       	mov    $0x10,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <close>:
SYSCALL(close)
 6c8:	b8 15 00 00 00       	mov    $0x15,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <kill>:
SYSCALL(kill)
 6d0:	b8 06 00 00 00       	mov    $0x6,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <exec>:
SYSCALL(exec)
 6d8:	b8 07 00 00 00       	mov    $0x7,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <open>:
SYSCALL(open)
 6e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <mknod>:
SYSCALL(mknod)
 6e8:	b8 11 00 00 00       	mov    $0x11,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <unlink>:
SYSCALL(unlink)
 6f0:	b8 12 00 00 00       	mov    $0x12,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <fstat>:
SYSCALL(fstat)
 6f8:	b8 08 00 00 00       	mov    $0x8,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <link>:
SYSCALL(link)
 700:	b8 13 00 00 00       	mov    $0x13,%eax
 705:	cd 40                	int    $0x40
 707:	c3                   	ret    

00000708 <mkdir>:
SYSCALL(mkdir)
 708:	b8 14 00 00 00       	mov    $0x14,%eax
 70d:	cd 40                	int    $0x40
 70f:	c3                   	ret    

00000710 <chdir>:
SYSCALL(chdir)
 710:	b8 09 00 00 00       	mov    $0x9,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <dup>:
SYSCALL(dup)
 718:	b8 0a 00 00 00       	mov    $0xa,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <getpid>:
SYSCALL(getpid)
 720:	b8 0b 00 00 00       	mov    $0xb,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <sbrk>:
SYSCALL(sbrk)
 728:	b8 0c 00 00 00       	mov    $0xc,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <sleep>:
SYSCALL(sleep)
 730:	b8 0d 00 00 00       	mov    $0xd,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <uptime>:
SYSCALL(uptime)
 738:	b8 0e 00 00 00       	mov    $0xe,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <halt>:
SYSCALL(halt)
 740:	b8 16 00 00 00       	mov    $0x16,%eax
 745:	cd 40                	int    $0x40
 747:	c3                   	ret    

00000748 <date>:
SYSCALL(date)        #p1
 748:	b8 17 00 00 00       	mov    $0x17,%eax
 74d:	cd 40                	int    $0x40
 74f:	c3                   	ret    

00000750 <getuid>:
SYSCALL(getuid)      #p2
 750:	b8 18 00 00 00       	mov    $0x18,%eax
 755:	cd 40                	int    $0x40
 757:	c3                   	ret    

00000758 <getgid>:
SYSCALL(getgid)      #p2
 758:	b8 19 00 00 00       	mov    $0x19,%eax
 75d:	cd 40                	int    $0x40
 75f:	c3                   	ret    

00000760 <getppid>:
SYSCALL(getppid)     #p2
 760:	b8 1a 00 00 00       	mov    $0x1a,%eax
 765:	cd 40                	int    $0x40
 767:	c3                   	ret    

00000768 <setuid>:
SYSCALL(setuid)      #p2
 768:	b8 1b 00 00 00       	mov    $0x1b,%eax
 76d:	cd 40                	int    $0x40
 76f:	c3                   	ret    

00000770 <setgid>:
SYSCALL(setgid)      #p2
 770:	b8 1c 00 00 00       	mov    $0x1c,%eax
 775:	cd 40                	int    $0x40
 777:	c3                   	ret    

00000778 <getprocs>:
SYSCALL(getprocs)    #p2
 778:	b8 1d 00 00 00       	mov    $0x1d,%eax
 77d:	cd 40                	int    $0x40
 77f:	c3                   	ret    

00000780 <setpriority>:
SYSCALL(setpriority) #p4
 780:	b8 1e 00 00 00       	mov    $0x1e,%eax
 785:	cd 40                	int    $0x40
 787:	c3                   	ret    

00000788 <chmod>:
SYSCALL(chmod)       #p5
 788:	b8 1f 00 00 00       	mov    $0x1f,%eax
 78d:	cd 40                	int    $0x40
 78f:	c3                   	ret    

00000790 <chown>:
SYSCALL(chown)       #p5
 790:	b8 20 00 00 00       	mov    $0x20,%eax
 795:	cd 40                	int    $0x40
 797:	c3                   	ret    

00000798 <chgrp>:
SYSCALL(chgrp)       #p5
 798:	b8 21 00 00 00       	mov    $0x21,%eax
 79d:	cd 40                	int    $0x40
 79f:	c3                   	ret    

000007a0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	83 ec 18             	sub    $0x18,%esp
 7a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7ac:	83 ec 04             	sub    $0x4,%esp
 7af:	6a 01                	push   $0x1
 7b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7b4:	50                   	push   %eax
 7b5:	ff 75 08             	pushl  0x8(%ebp)
 7b8:	e8 03 ff ff ff       	call   6c0 <write>
 7bd:	83 c4 10             	add    $0x10,%esp
}
 7c0:	90                   	nop
 7c1:	c9                   	leave  
 7c2:	c3                   	ret    

000007c3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7c3:	55                   	push   %ebp
 7c4:	89 e5                	mov    %esp,%ebp
 7c6:	53                   	push   %ebx
 7c7:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7d5:	74 17                	je     7ee <printint+0x2b>
 7d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7db:	79 11                	jns    7ee <printint+0x2b>
    neg = 1;
 7dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 7e7:	f7 d8                	neg    %eax
 7e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7ec:	eb 06                	jmp    7f4 <printint+0x31>
  } else {
    x = xx;
 7ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 7f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7fb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7fe:	8d 41 01             	lea    0x1(%ecx),%eax
 801:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804:	8b 5d 10             	mov    0x10(%ebp),%ebx
 807:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80a:	ba 00 00 00 00       	mov    $0x0,%edx
 80f:	f7 f3                	div    %ebx
 811:	89 d0                	mov    %edx,%eax
 813:	0f b6 80 c8 11 00 00 	movzbl 0x11c8(%eax),%eax
 81a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 81e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 821:	8b 45 ec             	mov    -0x14(%ebp),%eax
 824:	ba 00 00 00 00       	mov    $0x0,%edx
 829:	f7 f3                	div    %ebx
 82b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 82e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 832:	75 c7                	jne    7fb <printint+0x38>
  if(neg)
 834:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 838:	74 2d                	je     867 <printint+0xa4>
    buf[i++] = '-';
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	8d 50 01             	lea    0x1(%eax),%edx
 840:	89 55 f4             	mov    %edx,-0xc(%ebp)
 843:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 848:	eb 1d                	jmp    867 <printint+0xa4>
    putc(fd, buf[i]);
 84a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 850:	01 d0                	add    %edx,%eax
 852:	0f b6 00             	movzbl (%eax),%eax
 855:	0f be c0             	movsbl %al,%eax
 858:	83 ec 08             	sub    $0x8,%esp
 85b:	50                   	push   %eax
 85c:	ff 75 08             	pushl  0x8(%ebp)
 85f:	e8 3c ff ff ff       	call   7a0 <putc>
 864:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 867:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 86b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86f:	79 d9                	jns    84a <printint+0x87>
    putc(fd, buf[i]);
}
 871:	90                   	nop
 872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 875:	c9                   	leave  
 876:	c3                   	ret    

00000877 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 877:	55                   	push   %ebp
 878:	89 e5                	mov    %esp,%ebp
 87a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 87d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 884:	8d 45 0c             	lea    0xc(%ebp),%eax
 887:	83 c0 04             	add    $0x4,%eax
 88a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 88d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 894:	e9 59 01 00 00       	jmp    9f2 <printf+0x17b>
    c = fmt[i] & 0xff;
 899:	8b 55 0c             	mov    0xc(%ebp),%edx
 89c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89f:	01 d0                	add    %edx,%eax
 8a1:	0f b6 00             	movzbl (%eax),%eax
 8a4:	0f be c0             	movsbl %al,%eax
 8a7:	25 ff 00 00 00       	and    $0xff,%eax
 8ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8b3:	75 2c                	jne    8e1 <printf+0x6a>
      if(c == '%'){
 8b5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8b9:	75 0c                	jne    8c7 <printf+0x50>
        state = '%';
 8bb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8c2:	e9 27 01 00 00       	jmp    9ee <printf+0x177>
      } else {
        putc(fd, c);
 8c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8ca:	0f be c0             	movsbl %al,%eax
 8cd:	83 ec 08             	sub    $0x8,%esp
 8d0:	50                   	push   %eax
 8d1:	ff 75 08             	pushl  0x8(%ebp)
 8d4:	e8 c7 fe ff ff       	call   7a0 <putc>
 8d9:	83 c4 10             	add    $0x10,%esp
 8dc:	e9 0d 01 00 00       	jmp    9ee <printf+0x177>
      }
    } else if(state == '%'){
 8e1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8e5:	0f 85 03 01 00 00    	jne    9ee <printf+0x177>
      if(c == 'd'){
 8eb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8ef:	75 1e                	jne    90f <printf+0x98>
        printint(fd, *ap, 10, 1);
 8f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8f4:	8b 00                	mov    (%eax),%eax
 8f6:	6a 01                	push   $0x1
 8f8:	6a 0a                	push   $0xa
 8fa:	50                   	push   %eax
 8fb:	ff 75 08             	pushl  0x8(%ebp)
 8fe:	e8 c0 fe ff ff       	call   7c3 <printint>
 903:	83 c4 10             	add    $0x10,%esp
        ap++;
 906:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 90a:	e9 d8 00 00 00       	jmp    9e7 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 90f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 913:	74 06                	je     91b <printf+0xa4>
 915:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 919:	75 1e                	jne    939 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 91b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 91e:	8b 00                	mov    (%eax),%eax
 920:	6a 00                	push   $0x0
 922:	6a 10                	push   $0x10
 924:	50                   	push   %eax
 925:	ff 75 08             	pushl  0x8(%ebp)
 928:	e8 96 fe ff ff       	call   7c3 <printint>
 92d:	83 c4 10             	add    $0x10,%esp
        ap++;
 930:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 934:	e9 ae 00 00 00       	jmp    9e7 <printf+0x170>
      } else if(c == 's'){
 939:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 93d:	75 43                	jne    982 <printf+0x10b>
        s = (char*)*ap;
 93f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 942:	8b 00                	mov    (%eax),%eax
 944:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 947:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 94b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94f:	75 25                	jne    976 <printf+0xff>
          s = "(null)";
 951:	c7 45 f4 b4 0e 00 00 	movl   $0xeb4,-0xc(%ebp)
        while(*s != 0){
 958:	eb 1c                	jmp    976 <printf+0xff>
          putc(fd, *s);
 95a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95d:	0f b6 00             	movzbl (%eax),%eax
 960:	0f be c0             	movsbl %al,%eax
 963:	83 ec 08             	sub    $0x8,%esp
 966:	50                   	push   %eax
 967:	ff 75 08             	pushl  0x8(%ebp)
 96a:	e8 31 fe ff ff       	call   7a0 <putc>
 96f:	83 c4 10             	add    $0x10,%esp
          s++;
 972:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 976:	8b 45 f4             	mov    -0xc(%ebp),%eax
 979:	0f b6 00             	movzbl (%eax),%eax
 97c:	84 c0                	test   %al,%al
 97e:	75 da                	jne    95a <printf+0xe3>
 980:	eb 65                	jmp    9e7 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 982:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 986:	75 1d                	jne    9a5 <printf+0x12e>
        putc(fd, *ap);
 988:	8b 45 e8             	mov    -0x18(%ebp),%eax
 98b:	8b 00                	mov    (%eax),%eax
 98d:	0f be c0             	movsbl %al,%eax
 990:	83 ec 08             	sub    $0x8,%esp
 993:	50                   	push   %eax
 994:	ff 75 08             	pushl  0x8(%ebp)
 997:	e8 04 fe ff ff       	call   7a0 <putc>
 99c:	83 c4 10             	add    $0x10,%esp
        ap++;
 99f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9a3:	eb 42                	jmp    9e7 <printf+0x170>
      } else if(c == '%'){
 9a5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9a9:	75 17                	jne    9c2 <printf+0x14b>
        putc(fd, c);
 9ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9ae:	0f be c0             	movsbl %al,%eax
 9b1:	83 ec 08             	sub    $0x8,%esp
 9b4:	50                   	push   %eax
 9b5:	ff 75 08             	pushl  0x8(%ebp)
 9b8:	e8 e3 fd ff ff       	call   7a0 <putc>
 9bd:	83 c4 10             	add    $0x10,%esp
 9c0:	eb 25                	jmp    9e7 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9c2:	83 ec 08             	sub    $0x8,%esp
 9c5:	6a 25                	push   $0x25
 9c7:	ff 75 08             	pushl  0x8(%ebp)
 9ca:	e8 d1 fd ff ff       	call   7a0 <putc>
 9cf:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 9d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9d5:	0f be c0             	movsbl %al,%eax
 9d8:	83 ec 08             	sub    $0x8,%esp
 9db:	50                   	push   %eax
 9dc:	ff 75 08             	pushl  0x8(%ebp)
 9df:	e8 bc fd ff ff       	call   7a0 <putc>
 9e4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9ee:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9f2:	8b 55 0c             	mov    0xc(%ebp),%edx
 9f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f8:	01 d0                	add    %edx,%eax
 9fa:	0f b6 00             	movzbl (%eax),%eax
 9fd:	84 c0                	test   %al,%al
 9ff:	0f 85 94 fe ff ff    	jne    899 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a05:	90                   	nop
 a06:	c9                   	leave  
 a07:	c3                   	ret    

00000a08 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a08:	55                   	push   %ebp
 a09:	89 e5                	mov    %esp,%ebp
 a0b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a0e:	8b 45 08             	mov    0x8(%ebp),%eax
 a11:	83 e8 08             	sub    $0x8,%eax
 a14:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a17:	a1 e4 11 00 00       	mov    0x11e4,%eax
 a1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a1f:	eb 24                	jmp    a45 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a24:	8b 00                	mov    (%eax),%eax
 a26:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a29:	77 12                	ja     a3d <free+0x35>
 a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a31:	77 24                	ja     a57 <free+0x4f>
 a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a36:	8b 00                	mov    (%eax),%eax
 a38:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a3b:	77 1a                	ja     a57 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a40:	8b 00                	mov    (%eax),%eax
 a42:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a45:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a48:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a4b:	76 d4                	jbe    a21 <free+0x19>
 a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a50:	8b 00                	mov    (%eax),%eax
 a52:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a55:	76 ca                	jbe    a21 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5a:	8b 40 04             	mov    0x4(%eax),%eax
 a5d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a64:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a67:	01 c2                	add    %eax,%edx
 a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6c:	8b 00                	mov    (%eax),%eax
 a6e:	39 c2                	cmp    %eax,%edx
 a70:	75 24                	jne    a96 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a72:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a75:	8b 50 04             	mov    0x4(%eax),%edx
 a78:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7b:	8b 00                	mov    (%eax),%eax
 a7d:	8b 40 04             	mov    0x4(%eax),%eax
 a80:	01 c2                	add    %eax,%edx
 a82:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a85:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a88:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8b:	8b 00                	mov    (%eax),%eax
 a8d:	8b 10                	mov    (%eax),%edx
 a8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a92:	89 10                	mov    %edx,(%eax)
 a94:	eb 0a                	jmp    aa0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a99:	8b 10                	mov    (%eax),%edx
 a9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a9e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa3:	8b 40 04             	mov    0x4(%eax),%eax
 aa6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 aad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab0:	01 d0                	add    %edx,%eax
 ab2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ab5:	75 20                	jne    ad7 <free+0xcf>
    p->s.size += bp->s.size;
 ab7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aba:	8b 50 04             	mov    0x4(%eax),%edx
 abd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac0:	8b 40 04             	mov    0x4(%eax),%eax
 ac3:	01 c2                	add    %eax,%edx
 ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 acb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ace:	8b 10                	mov    (%eax),%edx
 ad0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad3:	89 10                	mov    %edx,(%eax)
 ad5:	eb 08                	jmp    adf <free+0xd7>
  } else
    p->s.ptr = bp;
 ad7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ada:	8b 55 f8             	mov    -0x8(%ebp),%edx
 add:	89 10                	mov    %edx,(%eax)
  freep = p;
 adf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae2:	a3 e4 11 00 00       	mov    %eax,0x11e4
}
 ae7:	90                   	nop
 ae8:	c9                   	leave  
 ae9:	c3                   	ret    

00000aea <morecore>:

static Header*
morecore(uint nu)
{
 aea:	55                   	push   %ebp
 aeb:	89 e5                	mov    %esp,%ebp
 aed:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 af0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 af7:	77 07                	ja     b00 <morecore+0x16>
    nu = 4096;
 af9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b00:	8b 45 08             	mov    0x8(%ebp),%eax
 b03:	c1 e0 03             	shl    $0x3,%eax
 b06:	83 ec 0c             	sub    $0xc,%esp
 b09:	50                   	push   %eax
 b0a:	e8 19 fc ff ff       	call   728 <sbrk>
 b0f:	83 c4 10             	add    $0x10,%esp
 b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b15:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b19:	75 07                	jne    b22 <morecore+0x38>
    return 0;
 b1b:	b8 00 00 00 00       	mov    $0x0,%eax
 b20:	eb 26                	jmp    b48 <morecore+0x5e>
  hp = (Header*)p;
 b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b2b:	8b 55 08             	mov    0x8(%ebp),%edx
 b2e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b34:	83 c0 08             	add    $0x8,%eax
 b37:	83 ec 0c             	sub    $0xc,%esp
 b3a:	50                   	push   %eax
 b3b:	e8 c8 fe ff ff       	call   a08 <free>
 b40:	83 c4 10             	add    $0x10,%esp
  return freep;
 b43:	a1 e4 11 00 00       	mov    0x11e4,%eax
}
 b48:	c9                   	leave  
 b49:	c3                   	ret    

00000b4a <malloc>:

void*
malloc(uint nbytes)
{
 b4a:	55                   	push   %ebp
 b4b:	89 e5                	mov    %esp,%ebp
 b4d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b50:	8b 45 08             	mov    0x8(%ebp),%eax
 b53:	83 c0 07             	add    $0x7,%eax
 b56:	c1 e8 03             	shr    $0x3,%eax
 b59:	83 c0 01             	add    $0x1,%eax
 b5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b5f:	a1 e4 11 00 00       	mov    0x11e4,%eax
 b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b6b:	75 23                	jne    b90 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b6d:	c7 45 f0 dc 11 00 00 	movl   $0x11dc,-0x10(%ebp)
 b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b77:	a3 e4 11 00 00       	mov    %eax,0x11e4
 b7c:	a1 e4 11 00 00       	mov    0x11e4,%eax
 b81:	a3 dc 11 00 00       	mov    %eax,0x11dc
    base.s.size = 0;
 b86:	c7 05 e0 11 00 00 00 	movl   $0x0,0x11e0
 b8d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b93:	8b 00                	mov    (%eax),%eax
 b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9b:	8b 40 04             	mov    0x4(%eax),%eax
 b9e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ba1:	72 4d                	jb     bf0 <malloc+0xa6>
      if(p->s.size == nunits)
 ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba6:	8b 40 04             	mov    0x4(%eax),%eax
 ba9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bac:	75 0c                	jne    bba <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb1:	8b 10                	mov    (%eax),%edx
 bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb6:	89 10                	mov    %edx,(%eax)
 bb8:	eb 26                	jmp    be0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bbd:	8b 40 04             	mov    0x4(%eax),%eax
 bc0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bc3:	89 c2                	mov    %eax,%edx
 bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bce:	8b 40 04             	mov    0x4(%eax),%eax
 bd1:	c1 e0 03             	shl    $0x3,%eax
 bd4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bda:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bdd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be3:	a3 e4 11 00 00       	mov    %eax,0x11e4
      return (void*)(p + 1);
 be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 beb:	83 c0 08             	add    $0x8,%eax
 bee:	eb 3b                	jmp    c2b <malloc+0xe1>
    }
    if(p == freep)
 bf0:	a1 e4 11 00 00       	mov    0x11e4,%eax
 bf5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bf8:	75 1e                	jne    c18 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 bfa:	83 ec 0c             	sub    $0xc,%esp
 bfd:	ff 75 ec             	pushl  -0x14(%ebp)
 c00:	e8 e5 fe ff ff       	call   aea <morecore>
 c05:	83 c4 10             	add    $0x10,%esp
 c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c0f:	75 07                	jne    c18 <malloc+0xce>
        return 0;
 c11:	b8 00 00 00 00       	mov    $0x0,%eax
 c16:	eb 13                	jmp    c2b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c21:	8b 00                	mov    (%eax),%eax
 c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c26:	e9 6d ff ff ff       	jmp    b98 <malloc+0x4e>
}
 c2b:	c9                   	leave  
 c2c:	c3                   	ret    
