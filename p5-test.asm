
_p5-test:     file format elf32-i386


Disassembly of section .text:

00000000 <canRun>:
#include "stat.h"
#include "p5-test.h"

static int
canRun(char *name)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  int rc, uid, gid;
  struct stat st;

  uid = getuid();
       6:	e8 dc 14 00 00       	call   14e7 <getuid>
       b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  gid = getgid();
       e:	e8 dc 14 00 00       	call   14ef <getgid>
      13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  check(stat(name, &st));
      16:	83 ec 08             	sub    $0x8,%esp
      19:	8d 45 d0             	lea    -0x30(%ebp),%eax
      1c:	50                   	push   %eax
      1d:	ff 75 08             	pushl  0x8(%ebp)
      20:	e8 60 12 00 00       	call   1285 <stat>
      25:	83 c4 10             	add    $0x10,%esp
      28:	89 45 ec             	mov    %eax,-0x14(%ebp)
      2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
      2f:	74 21                	je     52 <canRun+0x52>
      31:	83 ec 04             	sub    $0x4,%esp
      34:	68 c4 19 00 00       	push   $0x19c4
      39:	68 d4 19 00 00       	push   $0x19d4
      3e:	6a 02                	push   $0x2
      40:	e8 c9 15 00 00       	call   160e <printf>
      45:	83 c4 10             	add    $0x10,%esp
      48:	b8 00 00 00 00       	mov    $0x0,%eax
      4d:	e9 97 00 00 00       	jmp    e9 <canRun+0xe9>
  if (uid == st.uid) {
      52:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
      56:	0f b7 c0             	movzwl %ax,%eax
      59:	3b 45 f4             	cmp    -0xc(%ebp),%eax
      5c:	75 2b                	jne    89 <canRun+0x89>
    if (st.mode.flags.u_x)
      5e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
      62:	83 e0 40             	and    $0x40,%eax
      65:	84 c0                	test   %al,%al
      67:	74 07                	je     70 <canRun+0x70>
      return TRUE;
      69:	b8 01 00 00 00       	mov    $0x1,%eax
      6e:	eb 79                	jmp    e9 <canRun+0xe9>
    else {
      printf(2, "UID match. Execute permission for user not set.\n");
      70:	83 ec 08             	sub    $0x8,%esp
      73:	68 e8 19 00 00       	push   $0x19e8
      78:	6a 02                	push   $0x2
      7a:	e8 8f 15 00 00       	call   160e <printf>
      7f:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      82:	b8 00 00 00 00       	mov    $0x0,%eax
      87:	eb 60                	jmp    e9 <canRun+0xe9>
    }
  }
  if (gid == st.gid) {
      89:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
      8d:	0f b7 c0             	movzwl %ax,%eax
      90:	3b 45 f0             	cmp    -0x10(%ebp),%eax
      93:	75 2b                	jne    c0 <canRun+0xc0>
    if (st.mode.flags.g_x)
      95:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
      99:	83 e0 08             	and    $0x8,%eax
      9c:	84 c0                	test   %al,%al
      9e:	74 07                	je     a7 <canRun+0xa7>
      return TRUE;
      a0:	b8 01 00 00 00       	mov    $0x1,%eax
      a5:	eb 42                	jmp    e9 <canRun+0xe9>
    else {
      printf(2, "GID match. Execute permission for group not set.\n");
      a7:	83 ec 08             	sub    $0x8,%esp
      aa:	68 1c 1a 00 00       	push   $0x1a1c
      af:	6a 02                	push   $0x2
      b1:	e8 58 15 00 00       	call   160e <printf>
      b6:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      b9:	b8 00 00 00 00       	mov    $0x0,%eax
      be:	eb 29                	jmp    e9 <canRun+0xe9>
    }
  }
  if (st.mode.flags.o_x) {
      c0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
      c4:	83 e0 01             	and    $0x1,%eax
      c7:	84 c0                	test   %al,%al
      c9:	74 07                	je     d2 <canRun+0xd2>
    return TRUE;
      cb:	b8 01 00 00 00       	mov    $0x1,%eax
      d0:	eb 17                	jmp    e9 <canRun+0xe9>
  }

  printf(2, "Execute permission for other not set.\n");
      d2:	83 ec 08             	sub    $0x8,%esp
      d5:	68 50 1a 00 00       	push   $0x1a50
      da:	6a 02                	push   $0x2
      dc:	e8 2d 15 00 00       	call   160e <printf>
      e1:	83 c4 10             	add    $0x10,%esp
  return FALSE;  // failure. Can't run
      e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
      e9:	c9                   	leave  
      ea:	c3                   	ret    

000000eb <doSetuidTest>:

static int
doSetuidTest (char **cmd)
{
      eb:	55                   	push   %ebp
      ec:	89 e5                	mov    %esp,%ebp
      ee:	53                   	push   %ebx
      ef:	83 ec 24             	sub    $0x24,%esp
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};
      f2:	c7 45 e0 77 1a 00 00 	movl   $0x1a77,-0x20(%ebp)
      f9:	c7 45 e4 81 1a 00 00 	movl   $0x1a81,-0x1c(%ebp)
     100:	c7 45 e8 8b 1a 00 00 	movl   $0x1a8b,-0x18(%ebp)
     107:	c7 45 ec 91 1a 00 00 	movl   $0x1a91,-0x14(%ebp)

  printf(1, "\nTesting the set uid bit.\n\n");
     10e:	83 ec 08             	sub    $0x8,%esp
     111:	68 9d 1a 00 00       	push   $0x1a9d
     116:	6a 01                	push   $0x1
     118:	e8 f1 14 00 00       	call   160e <printf>
     11d:	83 c4 10             	add    $0x10,%esp

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     120:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     127:	e9 71 02 00 00       	jmp    39d <doSetuidTest+0x2b2>
    printf(1, "Starting test: %s.\n", test[i]);
     12c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     12f:	8b 44 85 e0          	mov    -0x20(%ebp,%eax,4),%eax
     133:	83 ec 04             	sub    $0x4,%esp
     136:	50                   	push   %eax
     137:	68 b9 1a 00 00       	push   $0x1ab9
     13c:	6a 01                	push   $0x1
     13e:	e8 cb 14 00 00       	call   160e <printf>
     143:	83 c4 10             	add    $0x10,%esp
    check(setuid(testperms[i][procuid]));
     146:	8b 45 f4             	mov    -0xc(%ebp),%eax
     149:	c1 e0 04             	shl    $0x4,%eax
     14c:	05 e0 26 00 00       	add    $0x26e0,%eax
     151:	8b 00                	mov    (%eax),%eax
     153:	83 ec 0c             	sub    $0xc,%esp
     156:	50                   	push   %eax
     157:	e8 a3 13 00 00       	call   14ff <setuid>
     15c:	83 c4 10             	add    $0x10,%esp
     15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     166:	74 21                	je     189 <doSetuidTest+0x9e>
     168:	83 ec 04             	sub    $0x4,%esp
     16b:	68 cd 1a 00 00       	push   $0x1acd
     170:	68 d4 19 00 00       	push   $0x19d4
     175:	6a 02                	push   $0x2
     177:	e8 92 14 00 00       	call   160e <printf>
     17c:	83 c4 10             	add    $0x10,%esp
     17f:	b8 00 00 00 00       	mov    $0x0,%eax
     184:	e9 4f 02 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    check(setgid(testperms[i][procgid]));
     189:	8b 45 f4             	mov    -0xc(%ebp),%eax
     18c:	c1 e0 04             	shl    $0x4,%eax
     18f:	05 e4 26 00 00       	add    $0x26e4,%eax
     194:	8b 00                	mov    (%eax),%eax
     196:	83 ec 0c             	sub    $0xc,%esp
     199:	50                   	push   %eax
     19a:	e8 68 13 00 00       	call   1507 <setgid>
     19f:	83 c4 10             	add    $0x10,%esp
     1a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     1a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1a9:	74 21                	je     1cc <doSetuidTest+0xe1>
     1ab:	83 ec 04             	sub    $0x4,%esp
     1ae:	68 eb 1a 00 00       	push   $0x1aeb
     1b3:	68 d4 19 00 00       	push   $0x19d4
     1b8:	6a 02                	push   $0x2
     1ba:	e8 4f 14 00 00       	call   160e <printf>
     1bf:	83 c4 10             	add    $0x10,%esp
     1c2:	b8 00 00 00 00       	mov    $0x0,%eax
     1c7:	e9 0c 02 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "Process uid: %d, gid: %d\n", getuid(), getgid());
     1cc:	e8 1e 13 00 00       	call   14ef <getgid>
     1d1:	89 c3                	mov    %eax,%ebx
     1d3:	e8 0f 13 00 00       	call   14e7 <getuid>
     1d8:	53                   	push   %ebx
     1d9:	50                   	push   %eax
     1da:	68 09 1b 00 00       	push   $0x1b09
     1df:	6a 01                	push   $0x1
     1e1:	e8 28 14 00 00       	call   160e <printf>
     1e6:	83 c4 10             	add    $0x10,%esp
    check(chown(cmd[0], testperms[i][fileuid]));
     1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1ec:	c1 e0 04             	shl    $0x4,%eax
     1ef:	05 e8 26 00 00       	add    $0x26e8,%eax
     1f4:	8b 10                	mov    (%eax),%edx
     1f6:	8b 45 08             	mov    0x8(%ebp),%eax
     1f9:	8b 00                	mov    (%eax),%eax
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	52                   	push   %edx
     1ff:	50                   	push   %eax
     200:	e8 22 13 00 00       	call   1527 <chown>
     205:	83 c4 10             	add    $0x10,%esp
     208:	89 45 f0             	mov    %eax,-0x10(%ebp)
     20b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     20f:	74 21                	je     232 <doSetuidTest+0x147>
     211:	83 ec 04             	sub    $0x4,%esp
     214:	68 24 1b 00 00       	push   $0x1b24
     219:	68 d4 19 00 00       	push   $0x19d4
     21e:	6a 02                	push   $0x2
     220:	e8 e9 13 00 00       	call   160e <printf>
     225:	83 c4 10             	add    $0x10,%esp
     228:	b8 00 00 00 00       	mov    $0x0,%eax
     22d:	e9 a6 01 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    check(chgrp(cmd[0], testperms[i][filegid]));
     232:	8b 45 f4             	mov    -0xc(%ebp),%eax
     235:	c1 e0 04             	shl    $0x4,%eax
     238:	05 ec 26 00 00       	add    $0x26ec,%eax
     23d:	8b 10                	mov    (%eax),%edx
     23f:	8b 45 08             	mov    0x8(%ebp),%eax
     242:	8b 00                	mov    (%eax),%eax
     244:	83 ec 08             	sub    $0x8,%esp
     247:	52                   	push   %edx
     248:	50                   	push   %eax
     249:	e8 e1 12 00 00       	call   152f <chgrp>
     24e:	83 c4 10             	add    $0x10,%esp
     251:	89 45 f0             	mov    %eax,-0x10(%ebp)
     254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     258:	74 21                	je     27b <doSetuidTest+0x190>
     25a:	83 ec 04             	sub    $0x4,%esp
     25d:	68 4c 1b 00 00       	push   $0x1b4c
     262:	68 d4 19 00 00       	push   $0x19d4
     267:	6a 02                	push   $0x2
     269:	e8 a0 13 00 00       	call   160e <printf>
     26e:	83 c4 10             	add    $0x10,%esp
     271:	b8 00 00 00 00       	mov    $0x0,%eax
     276:	e9 5d 01 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "File uid: %d, gid: %d\n",
     27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     27e:	c1 e0 04             	shl    $0x4,%eax
     281:	05 ec 26 00 00       	add    $0x26ec,%eax
     286:	8b 10                	mov    (%eax),%edx
     288:	8b 45 f4             	mov    -0xc(%ebp),%eax
     28b:	c1 e0 04             	shl    $0x4,%eax
     28e:	05 e8 26 00 00       	add    $0x26e8,%eax
     293:	8b 00                	mov    (%eax),%eax
     295:	52                   	push   %edx
     296:	50                   	push   %eax
     297:	68 71 1b 00 00       	push   $0x1b71
     29c:	6a 01                	push   $0x1
     29e:	e8 6b 13 00 00       	call   160e <printf>
     2a3:	83 c4 10             	add    $0x10,%esp
		    testperms[i][fileuid], testperms[i][filegid]);
    check(chmod(cmd[0], perms[i]));
     2a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2a9:	8b 14 85 c4 26 00 00 	mov    0x26c4(,%eax,4),%edx
     2b0:	8b 45 08             	mov    0x8(%ebp),%eax
     2b3:	8b 00                	mov    (%eax),%eax
     2b5:	83 ec 08             	sub    $0x8,%esp
     2b8:	52                   	push   %edx
     2b9:	50                   	push   %eax
     2ba:	e8 60 12 00 00       	call   151f <chmod>
     2bf:	83 c4 10             	add    $0x10,%esp
     2c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     2c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2c9:	74 21                	je     2ec <doSetuidTest+0x201>
     2cb:	83 ec 04             	sub    $0x4,%esp
     2ce:	68 88 1b 00 00       	push   $0x1b88
     2d3:	68 d4 19 00 00       	push   $0x19d4
     2d8:	6a 02                	push   $0x2
     2da:	e8 2f 13 00 00       	call   160e <printf>
     2df:	83 c4 10             	add    $0x10,%esp
     2e2:	b8 00 00 00 00       	mov    $0x0,%eax
     2e7:	e9 ec 00 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "perms set to %d for %s\n", perms[i], cmd[0]);
     2ec:	8b 45 08             	mov    0x8(%ebp),%eax
     2ef:	8b 10                	mov    (%eax),%edx
     2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2f4:	8b 04 85 c4 26 00 00 	mov    0x26c4(,%eax,4),%eax
     2fb:	52                   	push   %edx
     2fc:	50                   	push   %eax
     2fd:	68 a0 1b 00 00       	push   $0x1ba0
     302:	6a 01                	push   $0x1
     304:	e8 05 13 00 00       	call   160e <printf>
     309:	83 c4 10             	add    $0x10,%esp

    rc = fork();
     30c:	e8 1e 11 00 00       	call   142f <fork>
     311:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     314:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     318:	79 1c                	jns    336 <doSetuidTest+0x24b>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     31a:	83 ec 08             	sub    $0x8,%esp
     31d:	68 b8 1b 00 00       	push   $0x1bb8
     322:	6a 02                	push   $0x2
     324:	e8 e5 12 00 00       	call   160e <printf>
     329:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     32c:	b8 00 00 00 00       	mov    $0x0,%eax
     331:	e9 a2 00 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    }
    if (rc == 0) {   // child
     336:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     33a:	75 58                	jne    394 <doSetuidTest+0x2a9>
      exec(cmd[0], cmd);
     33c:	8b 45 08             	mov    0x8(%ebp),%eax
     33f:	8b 00                	mov    (%eax),%eax
     341:	83 ec 08             	sub    $0x8,%esp
     344:	ff 75 08             	pushl  0x8(%ebp)
     347:	50                   	push   %eax
     348:	e8 22 11 00 00       	call   146f <exec>
     34d:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     350:	a1 c0 26 00 00       	mov    0x26c0,%eax
     355:	83 e8 01             	sub    $0x1,%eax
     358:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     35b:	74 1a                	je     377 <doSetuidTest+0x28c>
     35d:	8b 45 08             	mov    0x8(%ebp),%eax
     360:	8b 00                	mov    (%eax),%eax
     362:	83 ec 04             	sub    $0x4,%esp
     365:	50                   	push   %eax
     366:	68 00 1c 00 00       	push   $0x1c00
     36b:	6a 02                	push   $0x2
     36d:	e8 9c 12 00 00       	call   160e <printf>
     372:	83 c4 10             	add    $0x10,%esp
     375:	eb 18                	jmp    38f <doSetuidTest+0x2a4>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     377:	8b 45 08             	mov    0x8(%ebp),%eax
     37a:	8b 00                	mov    (%eax),%eax
     37c:	83 ec 04             	sub    $0x4,%esp
     37f:	50                   	push   %eax
     380:	68 24 1c 00 00       	push   $0x1c24
     385:	6a 02                	push   $0x2
     387:	e8 82 12 00 00       	call   160e <printf>
     38c:	83 c4 10             	add    $0x10,%esp
      exit();
     38f:	e8 a3 10 00 00       	call   1437 <exit>
    }
    wait();
     394:	e8 a6 10 00 00       	call   143f <wait>
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};

  printf(1, "\nTesting the set uid bit.\n\n");

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     399:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     39d:	a1 c0 26 00 00       	mov    0x26c0,%eax
     3a2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     3a5:	0f 8c 81 fd ff ff    	jl     12c <doSetuidTest+0x41>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chmod(cmd[0], 00755);  // total hack but necessary. sigh
     3ab:	8b 45 08             	mov    0x8(%ebp),%eax
     3ae:	8b 00                	mov    (%eax),%eax
     3b0:	83 ec 08             	sub    $0x8,%esp
     3b3:	68 ed 01 00 00       	push   $0x1ed
     3b8:	50                   	push   %eax
     3b9:	e8 61 11 00 00       	call   151f <chmod>
     3be:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     3c1:	83 ec 08             	sub    $0x8,%esp
     3c4:	68 51 1c 00 00       	push   $0x1c51
     3c9:	6a 01                	push   $0x1
     3cb:	e8 3e 12 00 00       	call   160e <printf>
     3d0:	83 c4 10             	add    $0x10,%esp
  return PASS;
     3d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
     3d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3db:	c9                   	leave  
     3dc:	c3                   	ret    

000003dd <doUidTest>:

static int
doUidTest (char **cmd)
{
     3dd:	55                   	push   %ebp
     3de:	89 e5                	mov    %esp,%ebp
     3e0:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, startuid, testuid, baduidcount = 3;
     3e3:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int baduids[] = {32767+5, -41, ~0};  // 32767 is max value
     3ea:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     3f1:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     3f8:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setuid() test.\n\n");
     3ff:	83 ec 08             	sub    $0x8,%esp
     402:	68 5e 1c 00 00       	push   $0x1c5e
     407:	6a 01                	push   $0x1
     409:	e8 00 12 00 00       	call   160e <printf>
     40e:	83 c4 10             	add    $0x10,%esp

  startuid = uid = getuid();
     411:	e8 d1 10 00 00       	call   14e7 <getuid>
     416:	89 45 ec             	mov    %eax,-0x14(%ebp)
     419:	8b 45 ec             	mov    -0x14(%ebp),%eax
     41c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testuid = ++uid;
     41f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     423:	8b 45 ec             	mov    -0x14(%ebp),%eax
     426:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setuid(testuid);
     429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     42c:	83 ec 0c             	sub    $0xc,%esp
     42f:	50                   	push   %eax
     430:	e8 ca 10 00 00       	call   14ff <setuid>
     435:	83 c4 10             	add    $0x10,%esp
     438:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     43b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     43f:	74 1c                	je     45d <doUidTest+0x80>
    printf(2, "setuid system call reports an error.\n");
     441:	83 ec 08             	sub    $0x8,%esp
     444:	68 7c 1c 00 00       	push   $0x1c7c
     449:	6a 02                	push   $0x2
     44b:	e8 be 11 00 00       	call   160e <printf>
     450:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     453:	b8 00 00 00 00       	mov    $0x0,%eax
     458:	e9 07 01 00 00       	jmp    564 <doUidTest+0x187>
  }
  uid = getuid();
     45d:	e8 85 10 00 00       	call   14e7 <getuid>
     462:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (uid != testuid) {
     465:	8b 45 ec             	mov    -0x14(%ebp),%eax
     468:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     46b:	74 31                	je     49e <doUidTest+0xc1>
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
     46d:	83 ec 08             	sub    $0x8,%esp
     470:	68 a4 1c 00 00       	push   $0x1ca4
     475:	6a 02                	push   $0x2
     477:	e8 92 11 00 00       	call   160e <printf>
     47c:	83 c4 10             	add    $0x10,%esp
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
     47f:	ff 75 ec             	pushl  -0x14(%ebp)
     482:	ff 75 e4             	pushl  -0x1c(%ebp)
     485:	68 dc 1c 00 00       	push   $0x1cdc
     48a:	6a 02                	push   $0x2
     48c:	e8 7d 11 00 00       	call   160e <printf>
     491:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     494:	b8 00 00 00 00       	mov    $0x0,%eax
     499:	e9 c6 00 00 00       	jmp    564 <doUidTest+0x187>
  }
  for (i=0; i<baduidcount; i++) {
     49e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4a5:	e9 88 00 00 00       	jmp    532 <doUidTest+0x155>
    rc = setuid(baduids[i]);
     4aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ad:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4b1:	83 ec 0c             	sub    $0xc,%esp
     4b4:	50                   	push   %eax
     4b5:	e8 45 10 00 00       	call   14ff <setuid>
     4ba:	83 c4 10             	add    $0x10,%esp
     4bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     4c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     4c4:	75 21                	jne    4e7 <doUidTest+0x10a>
      printf(2, "Tried to set the uid to a bad value (%d) and setuid()failed to fail. rc == %d\n",
     4c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c9:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4cd:	ff 75 e0             	pushl  -0x20(%ebp)
     4d0:	50                   	push   %eax
     4d1:	68 00 1d 00 00       	push   $0x1d00
     4d6:	6a 02                	push   $0x2
     4d8:	e8 31 11 00 00       	call   160e <printf>
     4dd:	83 c4 10             	add    $0x10,%esp
                      baduids[i], rc);
      return NOPASS;
     4e0:	b8 00 00 00 00       	mov    $0x0,%eax
     4e5:	eb 7d                	jmp    564 <doUidTest+0x187>
    }
    rc = getuid();
     4e7:	e8 fb 0f 00 00       	call   14e7 <getuid>
     4ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (baduids[i] == rc) {
     4ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f2:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     4f9:	75 33                	jne    52e <doUidTest+0x151>
      printf(2, "ERROR! Gave setuid() a bad value (%d) and it failed to fail. gid: %d\n",
     4fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fe:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     502:	ff 75 e0             	pushl  -0x20(%ebp)
     505:	50                   	push   %eax
     506:	68 50 1d 00 00       	push   $0x1d50
     50b:	6a 02                	push   $0x2
     50d:	e8 fc 10 00 00       	call   160e <printf>
     512:	83 c4 10             	add    $0x10,%esp
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
     515:	83 ec 08             	sub    $0x8,%esp
     518:	68 98 1d 00 00       	push   $0x1d98
     51d:	6a 02                	push   $0x2
     51f:	e8 ea 10 00 00       	call   160e <printf>
     524:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     527:	b8 00 00 00 00       	mov    $0x0,%eax
     52c:	eb 36                	jmp    564 <doUidTest+0x187>
  if (uid != testuid) {
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
    return NOPASS;
  }
  for (i=0; i<baduidcount; i++) {
     52e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     532:	8b 45 f4             	mov    -0xc(%ebp),%eax
     535:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     538:	0f 8c 6c ff ff ff    	jl     4aa <doUidTest+0xcd>
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setuid(startuid);
     53e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     541:	83 ec 0c             	sub    $0xc,%esp
     544:	50                   	push   %eax
     545:	e8 b5 0f 00 00       	call   14ff <setuid>
     54a:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     54d:	83 ec 08             	sub    $0x8,%esp
     550:	68 51 1c 00 00       	push   $0x1c51
     555:	6a 01                	push   $0x1
     557:	e8 b2 10 00 00       	call   160e <printf>
     55c:	83 c4 10             	add    $0x10,%esp
  return PASS;
     55f:	b8 01 00 00 00       	mov    $0x1,%eax
}
     564:	c9                   	leave  
     565:	c3                   	ret    

00000566 <doGidTest>:

static int
doGidTest (char **cmd)
{
     566:	55                   	push   %ebp
     567:	89 e5                	mov    %esp,%ebp
     569:	83 ec 38             	sub    $0x38,%esp
  int i, rc, gid, startgid, testgid, badgidcount = 3;
     56c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int badgids[] = {32767+5, -41, ~0};  // 32767 is max value
     573:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     57a:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     581:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setgid() test.\n\n");
     588:	83 ec 08             	sub    $0x8,%esp
     58b:	68 c6 1d 00 00       	push   $0x1dc6
     590:	6a 01                	push   $0x1
     592:	e8 77 10 00 00       	call   160e <printf>
     597:	83 c4 10             	add    $0x10,%esp

  startgid = gid = getgid();
     59a:	e8 50 0f 00 00       	call   14ef <getgid>
     59f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     5a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testgid = ++gid;
     5a8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     5ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setgid(testgid);
     5b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5b5:	83 ec 0c             	sub    $0xc,%esp
     5b8:	50                   	push   %eax
     5b9:	e8 49 0f 00 00       	call   1507 <setgid>
     5be:	83 c4 10             	add    $0x10,%esp
     5c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     5c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     5c8:	74 1c                	je     5e6 <doGidTest+0x80>
    printf(2, "setgid system call reports an error.\n");
     5ca:	83 ec 08             	sub    $0x8,%esp
     5cd:	68 e4 1d 00 00       	push   $0x1de4
     5d2:	6a 02                	push   $0x2
     5d4:	e8 35 10 00 00       	call   160e <printf>
     5d9:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     5dc:	b8 00 00 00 00       	mov    $0x0,%eax
     5e1:	e9 07 01 00 00       	jmp    6ed <doGidTest+0x187>
  }
  gid = getgid();
     5e6:	e8 04 0f 00 00       	call   14ef <getgid>
     5eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (gid != testgid) {
     5ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     5f4:	74 31                	je     627 <doGidTest+0xc1>
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
     5f6:	83 ec 08             	sub    $0x8,%esp
     5f9:	68 0c 1e 00 00       	push   $0x1e0c
     5fe:	6a 02                	push   $0x2
     600:	e8 09 10 00 00       	call   160e <printf>
     605:	83 c4 10             	add    $0x10,%esp
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
     608:	ff 75 ec             	pushl  -0x14(%ebp)
     60b:	ff 75 e4             	pushl  -0x1c(%ebp)
     60e:	68 44 1e 00 00       	push   $0x1e44
     613:	6a 02                	push   $0x2
     615:	e8 f4 0f 00 00       	call   160e <printf>
     61a:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     61d:	b8 00 00 00 00       	mov    $0x0,%eax
     622:	e9 c6 00 00 00       	jmp    6ed <doGidTest+0x187>
  }
  for (i=0; i<badgidcount; i++) {
     627:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     62e:	e9 88 00 00 00       	jmp    6bb <doGidTest+0x155>
    rc = setgid(badgids[i]); 
     633:	8b 45 f4             	mov    -0xc(%ebp),%eax
     636:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     63a:	83 ec 0c             	sub    $0xc,%esp
     63d:	50                   	push   %eax
     63e:	e8 c4 0e 00 00       	call   1507 <setgid>
     643:	83 c4 10             	add    $0x10,%esp
     646:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     649:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     64d:	75 21                	jne    670 <doGidTest+0x10a>
      printf(2, "Tried to set the gid to a bad value (%d) and setgid()failed to fail. rc == %d\n",
     64f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     652:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     656:	ff 75 e0             	pushl  -0x20(%ebp)
     659:	50                   	push   %eax
     65a:	68 68 1e 00 00       	push   $0x1e68
     65f:	6a 02                	push   $0x2
     661:	e8 a8 0f 00 00       	call   160e <printf>
     666:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      return NOPASS;
     669:	b8 00 00 00 00       	mov    $0x0,%eax
     66e:	eb 7d                	jmp    6ed <doGidTest+0x187>
    }
    rc = getgid();
     670:	e8 7a 0e 00 00       	call   14ef <getgid>
     675:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (badgids[i] == rc) {
     678:	8b 45 f4             	mov    -0xc(%ebp),%eax
     67b:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     67f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     682:	75 33                	jne    6b7 <doGidTest+0x151>
      printf(2, "ERROR! Gave setgid() a bad value (%d) and it failed to fail. gid: %d\n",
     684:	8b 45 f4             	mov    -0xc(%ebp),%eax
     687:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     68b:	ff 75 e0             	pushl  -0x20(%ebp)
     68e:	50                   	push   %eax
     68f:	68 b8 1e 00 00       	push   $0x1eb8
     694:	6a 02                	push   $0x2
     696:	e8 73 0f 00 00       	call   160e <printf>
     69b:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
     69e:	83 ec 08             	sub    $0x8,%esp
     6a1:	68 00 1f 00 00       	push   $0x1f00
     6a6:	6a 02                	push   $0x2
     6a8:	e8 61 0f 00 00       	call   160e <printf>
     6ad:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     6b0:	b8 00 00 00 00       	mov    $0x0,%eax
     6b5:	eb 36                	jmp    6ed <doGidTest+0x187>
  if (gid != testgid) {
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
    return NOPASS;
  }
  for (i=0; i<badgidcount; i++) {
     6b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     6bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     6c1:	0f 8c 6c ff ff ff    	jl     633 <doGidTest+0xcd>
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setgid(startgid);
     6c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6ca:	83 ec 0c             	sub    $0xc,%esp
     6cd:	50                   	push   %eax
     6ce:	e8 34 0e 00 00       	call   1507 <setgid>
     6d3:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     6d6:	83 ec 08             	sub    $0x8,%esp
     6d9:	68 51 1c 00 00       	push   $0x1c51
     6de:	6a 01                	push   $0x1
     6e0:	e8 29 0f 00 00       	call   160e <printf>
     6e5:	83 c4 10             	add    $0x10,%esp
  return PASS;
     6e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
     6ed:	c9                   	leave  
     6ee:	c3                   	ret    

000006ef <doChmodTest>:

static int
doChmodTest(char **cmd) 
{
     6ef:	55                   	push   %ebp
     6f0:	89 e5                	mov    %esp,%ebp
     6f2:	83 ec 38             	sub    $0x38,%esp
  int i, rc, mode, testmode;
  struct stat st;

  printf(1, "\nExecuting chmod() test.\n\n");
     6f5:	83 ec 08             	sub    $0x8,%esp
     6f8:	68 2e 1f 00 00       	push   $0x1f2e
     6fd:	6a 01                	push   $0x1
     6ff:	e8 0a 0f 00 00       	call   160e <printf>
     704:	83 c4 10             	add    $0x10,%esp

  check(stat(cmd[0], &st));
     707:	8b 45 08             	mov    0x8(%ebp),%eax
     70a:	8b 00                	mov    (%eax),%eax
     70c:	83 ec 08             	sub    $0x8,%esp
     70f:	8d 55 cc             	lea    -0x34(%ebp),%edx
     712:	52                   	push   %edx
     713:	50                   	push   %eax
     714:	e8 6c 0b 00 00       	call   1285 <stat>
     719:	83 c4 10             	add    $0x10,%esp
     71c:	89 45 f0             	mov    %eax,-0x10(%ebp)
     71f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     723:	74 21                	je     746 <doChmodTest+0x57>
     725:	83 ec 04             	sub    $0x4,%esp
     728:	68 49 1f 00 00       	push   $0x1f49
     72d:	68 d4 19 00 00       	push   $0x19d4
     732:	6a 02                	push   $0x2
     734:	e8 d5 0e 00 00       	call   160e <printf>
     739:	83 c4 10             	add    $0x10,%esp
     73c:	b8 00 00 00 00       	mov    $0x0,%eax
     741:	e9 46 01 00 00       	jmp    88c <doChmodTest+0x19d>
  mode = st.mode.as_int;
     746:	8b 45 e0             	mov    -0x20(%ebp),%eax
     749:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     74c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     753:	e9 f9 00 00 00       	jmp    851 <doChmodTest+0x162>
    check(chmod(cmd[0], perms[i]));
     758:	8b 45 f4             	mov    -0xc(%ebp),%eax
     75b:	8b 14 85 c4 26 00 00 	mov    0x26c4(,%eax,4),%edx
     762:	8b 45 08             	mov    0x8(%ebp),%eax
     765:	8b 00                	mov    (%eax),%eax
     767:	83 ec 08             	sub    $0x8,%esp
     76a:	52                   	push   %edx
     76b:	50                   	push   %eax
     76c:	e8 ae 0d 00 00       	call   151f <chmod>
     771:	83 c4 10             	add    $0x10,%esp
     774:	89 45 f0             	mov    %eax,-0x10(%ebp)
     777:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     77b:	74 21                	je     79e <doChmodTest+0xaf>
     77d:	83 ec 04             	sub    $0x4,%esp
     780:	68 88 1b 00 00       	push   $0x1b88
     785:	68 d4 19 00 00       	push   $0x19d4
     78a:	6a 02                	push   $0x2
     78c:	e8 7d 0e 00 00       	call   160e <printf>
     791:	83 c4 10             	add    $0x10,%esp
     794:	b8 00 00 00 00       	mov    $0x0,%eax
     799:	e9 ee 00 00 00       	jmp    88c <doChmodTest+0x19d>
    check(stat(cmd[0], &st));
     79e:	8b 45 08             	mov    0x8(%ebp),%eax
     7a1:	8b 00                	mov    (%eax),%eax
     7a3:	83 ec 08             	sub    $0x8,%esp
     7a6:	8d 55 cc             	lea    -0x34(%ebp),%edx
     7a9:	52                   	push   %edx
     7aa:	50                   	push   %eax
     7ab:	e8 d5 0a 00 00       	call   1285 <stat>
     7b0:	83 c4 10             	add    $0x10,%esp
     7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7ba:	74 21                	je     7dd <doChmodTest+0xee>
     7bc:	83 ec 04             	sub    $0x4,%esp
     7bf:	68 49 1f 00 00       	push   $0x1f49
     7c4:	68 d4 19 00 00       	push   $0x19d4
     7c9:	6a 02                	push   $0x2
     7cb:	e8 3e 0e 00 00       	call   160e <printf>
     7d0:	83 c4 10             	add    $0x10,%esp
     7d3:	b8 00 00 00 00       	mov    $0x0,%eax
     7d8:	e9 af 00 00 00       	jmp    88c <doChmodTest+0x19d>
    testmode = st.mode.as_int;
     7dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (mode == testmode) {
     7e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     7e9:	75 3a                	jne    825 <doChmodTest+0x136>
      printf(2, "Error! Unable to test.\n");
     7eb:	83 ec 08             	sub    $0x8,%esp
     7ee:	68 5b 1f 00 00       	push   $0x1f5b
     7f3:	6a 02                	push   $0x2
     7f5:	e8 14 0e 00 00       	call   160e <printf>
     7fa:	83 c4 10             	add    $0x10,%esp
      printf(2, "\tfile mode (%d) == testmode (%d) for file (%s) in test %d\n",
     7fd:	8b 45 08             	mov    0x8(%ebp),%eax
     800:	8b 00                	mov    (%eax),%eax
     802:	83 ec 08             	sub    $0x8,%esp
     805:	ff 75 f4             	pushl  -0xc(%ebp)
     808:	50                   	push   %eax
     809:	ff 75 e8             	pushl  -0x18(%ebp)
     80c:	ff 75 ec             	pushl  -0x14(%ebp)
     80f:	68 74 1f 00 00       	push   $0x1f74
     814:	6a 02                	push   $0x2
     816:	e8 f3 0d 00 00       	call   160e <printf>
     81b:	83 c4 20             	add    $0x20,%esp
		     mode, testmode, cmd[0], i);
      return NOPASS;
     81e:	b8 00 00 00 00       	mov    $0x0,%eax
     823:	eb 67                	jmp    88c <doChmodTest+0x19d>
    }
    if (mode == testmode) { 
     825:	8b 45 ec             	mov    -0x14(%ebp),%eax
     828:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     82b:	75 20                	jne    84d <doChmodTest+0x15e>
      printf(2, "Error! chmod() failed to set permissions correctly. %s, %d\n",
     82d:	68 ba 00 00 00       	push   $0xba
     832:	68 af 1f 00 00       	push   $0x1faf
     837:	68 bc 1f 00 00       	push   $0x1fbc
     83c:	6a 02                	push   $0x2
     83e:	e8 cb 0d 00 00       	call   160e <printf>
     843:	83 c4 10             	add    $0x10,%esp
		      __FILE__, __LINE__);
      return NOPASS;
     846:	b8 00 00 00 00       	mov    $0x0,%eax
     84b:	eb 3f                	jmp    88c <doChmodTest+0x19d>
  printf(1, "\nExecuting chmod() test.\n\n");

  check(stat(cmd[0], &st));
  mode = st.mode.as_int;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     84d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     851:	a1 c0 26 00 00       	mov    0x26c0,%eax
     856:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     859:	0f 8c f9 fe ff ff    	jl     758 <doChmodTest+0x69>
      printf(2, "Error! chmod() failed to set permissions correctly. %s, %d\n",
		      __FILE__, __LINE__);
      return NOPASS;
    }
  }
  chmod(cmd[0], 00755); // hack
     85f:	8b 45 08             	mov    0x8(%ebp),%eax
     862:	8b 00                	mov    (%eax),%eax
     864:	83 ec 08             	sub    $0x8,%esp
     867:	68 ed 01 00 00       	push   $0x1ed
     86c:	50                   	push   %eax
     86d:	e8 ad 0c 00 00       	call   151f <chmod>
     872:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     875:	83 ec 08             	sub    $0x8,%esp
     878:	68 51 1c 00 00       	push   $0x1c51
     87d:	6a 01                	push   $0x1
     87f:	e8 8a 0d 00 00       	call   160e <printf>
     884:	83 c4 10             	add    $0x10,%esp
  return PASS;
     887:	b8 01 00 00 00       	mov    $0x1,%eax
}
     88c:	c9                   	leave  
     88d:	c3                   	ret    

0000088e <doChownTest>:

static int
doChownTest(char **cmd) 
{
     88e:	55                   	push   %ebp
     88f:	89 e5                	mov    %esp,%ebp
     891:	83 ec 38             	sub    $0x38,%esp
  int rc, uid1, uid2;
  struct stat st;

  printf(1, "\nExecuting chown test.\n\n");
     894:	83 ec 08             	sub    $0x8,%esp
     897:	68 f8 1f 00 00       	push   $0x1ff8
     89c:	6a 01                	push   $0x1
     89e:	e8 6b 0d 00 00       	call   160e <printf>
     8a3:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     8a6:	8b 45 08             	mov    0x8(%ebp),%eax
     8a9:	8b 00                	mov    (%eax),%eax
     8ab:	83 ec 08             	sub    $0x8,%esp
     8ae:	8d 55 d0             	lea    -0x30(%ebp),%edx
     8b1:	52                   	push   %edx
     8b2:	50                   	push   %eax
     8b3:	e8 cd 09 00 00       	call   1285 <stat>
     8b8:	83 c4 10             	add    $0x10,%esp
  uid1 = st.uid;
     8bb:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
     8bf:	0f b7 c0             	movzwl %ax,%eax
     8c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chown(cmd[0], uid1+1);
     8c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c8:	8d 50 01             	lea    0x1(%eax),%edx
     8cb:	8b 45 08             	mov    0x8(%ebp),%eax
     8ce:	8b 00                	mov    (%eax),%eax
     8d0:	83 ec 08             	sub    $0x8,%esp
     8d3:	52                   	push   %edx
     8d4:	50                   	push   %eax
     8d5:	e8 4d 0c 00 00       	call   1527 <chown>
     8da:	83 c4 10             	add    $0x10,%esp
     8dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     8e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8e4:	74 1c                	je     902 <doChownTest+0x74>
    printf(2, "Error! chown() failed on setting new owner. %d as rc.\n", rc);
     8e6:	83 ec 04             	sub    $0x4,%esp
     8e9:	ff 75 f0             	pushl  -0x10(%ebp)
     8ec:	68 14 20 00 00       	push   $0x2014
     8f1:	6a 02                	push   $0x2
     8f3:	e8 16 0d 00 00       	call   160e <printf>
     8f8:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     8fb:	b8 00 00 00 00       	mov    $0x0,%eax
     900:	eb 6e                	jmp    970 <doChownTest+0xe2>
  }

  stat(cmd[0], &st);
     902:	8b 45 08             	mov    0x8(%ebp),%eax
     905:	8b 00                	mov    (%eax),%eax
     907:	83 ec 08             	sub    $0x8,%esp
     90a:	8d 55 d0             	lea    -0x30(%ebp),%edx
     90d:	52                   	push   %edx
     90e:	50                   	push   %eax
     90f:	e8 71 09 00 00       	call   1285 <stat>
     914:	83 c4 10             	add    $0x10,%esp
  uid2 = st.uid;
     917:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
     91b:	0f b7 c0             	movzwl %ax,%eax
     91e:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (uid1 == uid2) {
     921:	8b 45 f4             	mov    -0xc(%ebp),%eax
     924:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     927:	75 1c                	jne    945 <doChownTest+0xb7>
    printf(2, "Error! test failed. Old uid: %d, new uid: uid2, should differ\n",
     929:	ff 75 ec             	pushl  -0x14(%ebp)
     92c:	ff 75 f4             	pushl  -0xc(%ebp)
     92f:	68 4c 20 00 00       	push   $0x204c
     934:	6a 02                	push   $0x2
     936:	e8 d3 0c 00 00       	call   160e <printf>
     93b:	83 c4 10             	add    $0x10,%esp
		    uid1, uid2);
    return NOPASS;
     93e:	b8 00 00 00 00       	mov    $0x0,%eax
     943:	eb 2b                	jmp    970 <doChownTest+0xe2>
  }
  chown(cmd[0], uid1);  // put back the original
     945:	8b 45 08             	mov    0x8(%ebp),%eax
     948:	8b 00                	mov    (%eax),%eax
     94a:	83 ec 08             	sub    $0x8,%esp
     94d:	ff 75 f4             	pushl  -0xc(%ebp)
     950:	50                   	push   %eax
     951:	e8 d1 0b 00 00       	call   1527 <chown>
     956:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     959:	83 ec 08             	sub    $0x8,%esp
     95c:	68 51 1c 00 00       	push   $0x1c51
     961:	6a 01                	push   $0x1
     963:	e8 a6 0c 00 00       	call   160e <printf>
     968:	83 c4 10             	add    $0x10,%esp
  return PASS;
     96b:	b8 01 00 00 00       	mov    $0x1,%eax
}
     970:	c9                   	leave  
     971:	c3                   	ret    

00000972 <doChgrpTest>:

static int
doChgrpTest(char **cmd) 
{
     972:	55                   	push   %ebp
     973:	89 e5                	mov    %esp,%ebp
     975:	83 ec 38             	sub    $0x38,%esp
  int rc, gid1, gid2;
  struct stat st;

  printf(1, "\nExecuting chgrp test.\n\n");
     978:	83 ec 08             	sub    $0x8,%esp
     97b:	68 8b 20 00 00       	push   $0x208b
     980:	6a 01                	push   $0x1
     982:	e8 87 0c 00 00       	call   160e <printf>
     987:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     98a:	8b 45 08             	mov    0x8(%ebp),%eax
     98d:	8b 00                	mov    (%eax),%eax
     98f:	83 ec 08             	sub    $0x8,%esp
     992:	8d 55 d0             	lea    -0x30(%ebp),%edx
     995:	52                   	push   %edx
     996:	50                   	push   %eax
     997:	e8 e9 08 00 00       	call   1285 <stat>
     99c:	83 c4 10             	add    $0x10,%esp
  gid1 = st.gid;
     99f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
     9a3:	0f b7 c0             	movzwl %ax,%eax
     9a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chgrp(cmd[0], gid1+1);
     9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9ac:	8d 50 01             	lea    0x1(%eax),%edx
     9af:	8b 45 08             	mov    0x8(%ebp),%eax
     9b2:	8b 00                	mov    (%eax),%eax
     9b4:	83 ec 08             	sub    $0x8,%esp
     9b7:	52                   	push   %edx
     9b8:	50                   	push   %eax
     9b9:	e8 71 0b 00 00       	call   152f <chgrp>
     9be:	83 c4 10             	add    $0x10,%esp
     9c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     9c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9c8:	74 19                	je     9e3 <doChgrpTest+0x71>
    printf(2, "Error! chgrp() failed on setting new group.\n");
     9ca:	83 ec 08             	sub    $0x8,%esp
     9cd:	68 a4 20 00 00       	push   $0x20a4
     9d2:	6a 02                	push   $0x2
     9d4:	e8 35 0c 00 00       	call   160e <printf>
     9d9:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     9dc:	b8 00 00 00 00       	mov    $0x0,%eax
     9e1:	eb 6e                	jmp    a51 <doChgrpTest+0xdf>
  }

  stat(cmd[0], &st);
     9e3:	8b 45 08             	mov    0x8(%ebp),%eax
     9e6:	8b 00                	mov    (%eax),%eax
     9e8:	83 ec 08             	sub    $0x8,%esp
     9eb:	8d 55 d0             	lea    -0x30(%ebp),%edx
     9ee:	52                   	push   %edx
     9ef:	50                   	push   %eax
     9f0:	e8 90 08 00 00       	call   1285 <stat>
     9f5:	83 c4 10             	add    $0x10,%esp
  gid2 = st.gid;
     9f8:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
     9fc:	0f b7 c0             	movzwl %ax,%eax
     9ff:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (gid1 == gid2) {
     a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a05:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a08:	75 1c                	jne    a26 <doChgrpTest+0xb4>
    printf(2, "Error! test failed. Old gid: %d, new gid: gid2, should differ\n",
     a0a:	ff 75 ec             	pushl  -0x14(%ebp)
     a0d:	ff 75 f4             	pushl  -0xc(%ebp)
     a10:	68 d4 20 00 00       	push   $0x20d4
     a15:	6a 02                	push   $0x2
     a17:	e8 f2 0b 00 00       	call   160e <printf>
     a1c:	83 c4 10             	add    $0x10,%esp
                    gid1, gid2);
    return NOPASS;
     a1f:	b8 00 00 00 00       	mov    $0x0,%eax
     a24:	eb 2b                	jmp    a51 <doChgrpTest+0xdf>
  }
  chgrp(cmd[0], gid1);  // put back the original
     a26:	8b 45 08             	mov    0x8(%ebp),%eax
     a29:	8b 00                	mov    (%eax),%eax
     a2b:	83 ec 08             	sub    $0x8,%esp
     a2e:	ff 75 f4             	pushl  -0xc(%ebp)
     a31:	50                   	push   %eax
     a32:	e8 f8 0a 00 00       	call   152f <chgrp>
     a37:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     a3a:	83 ec 08             	sub    $0x8,%esp
     a3d:	68 51 1c 00 00       	push   $0x1c51
     a42:	6a 01                	push   $0x1
     a44:	e8 c5 0b 00 00       	call   160e <printf>
     a49:	83 c4 10             	add    $0x10,%esp
  return PASS;
     a4c:	b8 01 00 00 00       	mov    $0x1,%eax
}
     a51:	c9                   	leave  
     a52:	c3                   	ret    

00000a53 <doExecTest>:

static int
doExecTest(char **cmd) 
{
     a53:	55                   	push   %ebp
     a54:	89 e5                	mov    %esp,%ebp
     a56:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, gid;
  struct stat st;

  printf(1, "\nExecuting exec test.\n\n");
     a59:	83 ec 08             	sub    $0x8,%esp
     a5c:	68 13 21 00 00       	push   $0x2113
     a61:	6a 01                	push   $0x1
     a63:	e8 a6 0b 00 00       	call   160e <printf>
     a68:	83 c4 10             	add    $0x10,%esp

  if (!canRun(cmd[0])) {
     a6b:	8b 45 08             	mov    0x8(%ebp),%eax
     a6e:	8b 00                	mov    (%eax),%eax
     a70:	83 ec 0c             	sub    $0xc,%esp
     a73:	50                   	push   %eax
     a74:	e8 87 f5 ff ff       	call   0 <canRun>
     a79:	83 c4 10             	add    $0x10,%esp
     a7c:	85 c0                	test   %eax,%eax
     a7e:	75 22                	jne    aa2 <doExecTest+0x4f>
    printf(2, "Unable to run %s. test aborted.\n", cmd[0]);
     a80:	8b 45 08             	mov    0x8(%ebp),%eax
     a83:	8b 00                	mov    (%eax),%eax
     a85:	83 ec 04             	sub    $0x4,%esp
     a88:	50                   	push   %eax
     a89:	68 2c 21 00 00       	push   $0x212c
     a8e:	6a 02                	push   $0x2
     a90:	e8 79 0b 00 00       	call   160e <printf>
     a95:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     a98:	b8 00 00 00 00       	mov    $0x0,%eax
     a9d:	e9 e4 02 00 00       	jmp    d86 <doExecTest+0x333>
  }

  check(stat(cmd[0], &st));
     aa2:	8b 45 08             	mov    0x8(%ebp),%eax
     aa5:	8b 00                	mov    (%eax),%eax
     aa7:	83 ec 08             	sub    $0x8,%esp
     aaa:	8d 55 cc             	lea    -0x34(%ebp),%edx
     aad:	52                   	push   %edx
     aae:	50                   	push   %eax
     aaf:	e8 d1 07 00 00       	call   1285 <stat>
     ab4:	83 c4 10             	add    $0x10,%esp
     ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
     aba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     abe:	74 21                	je     ae1 <doExecTest+0x8e>
     ac0:	83 ec 04             	sub    $0x4,%esp
     ac3:	68 49 1f 00 00       	push   $0x1f49
     ac8:	68 d4 19 00 00       	push   $0x19d4
     acd:	6a 02                	push   $0x2
     acf:	e8 3a 0b 00 00       	call   160e <printf>
     ad4:	83 c4 10             	add    $0x10,%esp
     ad7:	b8 00 00 00 00       	mov    $0x0,%eax
     adc:	e9 a5 02 00 00       	jmp    d86 <doExecTest+0x333>
  uid = st.uid;
     ae1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
     ae5:	0f b7 c0             	movzwl %ax,%eax
     ae8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  gid = st.gid;
     aeb:	0f b7 45 dc          	movzwl -0x24(%ebp),%eax
     aef:	0f b7 c0             	movzwl %ax,%eax
     af2:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     af5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     afc:	e9 22 02 00 00       	jmp    d23 <doExecTest+0x2d0>
    check(setuid(testperms[i][procuid]));
     b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b04:	c1 e0 04             	shl    $0x4,%eax
     b07:	05 e0 26 00 00       	add    $0x26e0,%eax
     b0c:	8b 00                	mov    (%eax),%eax
     b0e:	83 ec 0c             	sub    $0xc,%esp
     b11:	50                   	push   %eax
     b12:	e8 e8 09 00 00       	call   14ff <setuid>
     b17:	83 c4 10             	add    $0x10,%esp
     b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b21:	74 21                	je     b44 <doExecTest+0xf1>
     b23:	83 ec 04             	sub    $0x4,%esp
     b26:	68 cd 1a 00 00       	push   $0x1acd
     b2b:	68 d4 19 00 00       	push   $0x19d4
     b30:	6a 02                	push   $0x2
     b32:	e8 d7 0a 00 00       	call   160e <printf>
     b37:	83 c4 10             	add    $0x10,%esp
     b3a:	b8 00 00 00 00       	mov    $0x0,%eax
     b3f:	e9 42 02 00 00       	jmp    d86 <doExecTest+0x333>
    check(setgid(testperms[i][procgid]));
     b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b47:	c1 e0 04             	shl    $0x4,%eax
     b4a:	05 e4 26 00 00       	add    $0x26e4,%eax
     b4f:	8b 00                	mov    (%eax),%eax
     b51:	83 ec 0c             	sub    $0xc,%esp
     b54:	50                   	push   %eax
     b55:	e8 ad 09 00 00       	call   1507 <setgid>
     b5a:	83 c4 10             	add    $0x10,%esp
     b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b64:	74 21                	je     b87 <doExecTest+0x134>
     b66:	83 ec 04             	sub    $0x4,%esp
     b69:	68 eb 1a 00 00       	push   $0x1aeb
     b6e:	68 d4 19 00 00       	push   $0x19d4
     b73:	6a 02                	push   $0x2
     b75:	e8 94 0a 00 00       	call   160e <printf>
     b7a:	83 c4 10             	add    $0x10,%esp
     b7d:	b8 00 00 00 00       	mov    $0x0,%eax
     b82:	e9 ff 01 00 00       	jmp    d86 <doExecTest+0x333>
    check(chown(cmd[0], testperms[i][fileuid]));
     b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b8a:	c1 e0 04             	shl    $0x4,%eax
     b8d:	05 e8 26 00 00       	add    $0x26e8,%eax
     b92:	8b 10                	mov    (%eax),%edx
     b94:	8b 45 08             	mov    0x8(%ebp),%eax
     b97:	8b 00                	mov    (%eax),%eax
     b99:	83 ec 08             	sub    $0x8,%esp
     b9c:	52                   	push   %edx
     b9d:	50                   	push   %eax
     b9e:	e8 84 09 00 00       	call   1527 <chown>
     ba3:	83 c4 10             	add    $0x10,%esp
     ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bad:	74 21                	je     bd0 <doExecTest+0x17d>
     baf:	83 ec 04             	sub    $0x4,%esp
     bb2:	68 24 1b 00 00       	push   $0x1b24
     bb7:	68 d4 19 00 00       	push   $0x19d4
     bbc:	6a 02                	push   $0x2
     bbe:	e8 4b 0a 00 00       	call   160e <printf>
     bc3:	83 c4 10             	add    $0x10,%esp
     bc6:	b8 00 00 00 00       	mov    $0x0,%eax
     bcb:	e9 b6 01 00 00       	jmp    d86 <doExecTest+0x333>
    check(chgrp(cmd[0], testperms[i][filegid]));
     bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bd3:	c1 e0 04             	shl    $0x4,%eax
     bd6:	05 ec 26 00 00       	add    $0x26ec,%eax
     bdb:	8b 10                	mov    (%eax),%edx
     bdd:	8b 45 08             	mov    0x8(%ebp),%eax
     be0:	8b 00                	mov    (%eax),%eax
     be2:	83 ec 08             	sub    $0x8,%esp
     be5:	52                   	push   %edx
     be6:	50                   	push   %eax
     be7:	e8 43 09 00 00       	call   152f <chgrp>
     bec:	83 c4 10             	add    $0x10,%esp
     bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
     bf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bf6:	74 21                	je     c19 <doExecTest+0x1c6>
     bf8:	83 ec 04             	sub    $0x4,%esp
     bfb:	68 4c 1b 00 00       	push   $0x1b4c
     c00:	68 d4 19 00 00       	push   $0x19d4
     c05:	6a 02                	push   $0x2
     c07:	e8 02 0a 00 00       	call   160e <printf>
     c0c:	83 c4 10             	add    $0x10,%esp
     c0f:	b8 00 00 00 00       	mov    $0x0,%eax
     c14:	e9 6d 01 00 00       	jmp    d86 <doExecTest+0x333>
    check(chmod(cmd[0], perms[i]));
     c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c1c:	8b 14 85 c4 26 00 00 	mov    0x26c4(,%eax,4),%edx
     c23:	8b 45 08             	mov    0x8(%ebp),%eax
     c26:	8b 00                	mov    (%eax),%eax
     c28:	83 ec 08             	sub    $0x8,%esp
     c2b:	52                   	push   %edx
     c2c:	50                   	push   %eax
     c2d:	e8 ed 08 00 00       	call   151f <chmod>
     c32:	83 c4 10             	add    $0x10,%esp
     c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
     c38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c3c:	74 21                	je     c5f <doExecTest+0x20c>
     c3e:	83 ec 04             	sub    $0x4,%esp
     c41:	68 88 1b 00 00       	push   $0x1b88
     c46:	68 d4 19 00 00       	push   $0x19d4
     c4b:	6a 02                	push   $0x2
     c4d:	e8 bc 09 00 00       	call   160e <printf>
     c52:	83 c4 10             	add    $0x10,%esp
     c55:	b8 00 00 00 00       	mov    $0x0,%eax
     c5a:	e9 27 01 00 00       	jmp    d86 <doExecTest+0x333>
    if (i != NUMPERMSTOCHECK-1)
     c5f:	a1 c0 26 00 00       	mov    0x26c0,%eax
     c64:	83 e8 01             	sub    $0x1,%eax
     c67:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     c6a:	74 14                	je     c80 <doExecTest+0x22d>
      printf(2, "The following test should not produce an error.\n");
     c6c:	83 ec 08             	sub    $0x8,%esp
     c6f:	68 50 21 00 00       	push   $0x2150
     c74:	6a 02                	push   $0x2
     c76:	e8 93 09 00 00       	call   160e <printf>
     c7b:	83 c4 10             	add    $0x10,%esp
     c7e:	eb 12                	jmp    c92 <doExecTest+0x23f>
    else
      printf(2, "The following test should fail.\n");
     c80:	83 ec 08             	sub    $0x8,%esp
     c83:	68 84 21 00 00       	push   $0x2184
     c88:	6a 02                	push   $0x2
     c8a:	e8 7f 09 00 00       	call   160e <printf>
     c8f:	83 c4 10             	add    $0x10,%esp
    rc = fork();
     c92:	e8 98 07 00 00       	call   142f <fork>
     c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     c9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c9e:	79 1c                	jns    cbc <doExecTest+0x269>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     ca0:	83 ec 08             	sub    $0x8,%esp
     ca3:	68 b8 1b 00 00       	push   $0x1bb8
     ca8:	6a 02                	push   $0x2
     caa:	e8 5f 09 00 00       	call   160e <printf>
     caf:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     cb2:	b8 00 00 00 00       	mov    $0x0,%eax
     cb7:	e9 ca 00 00 00       	jmp    d86 <doExecTest+0x333>
    }
    if (rc == 0) {   // child
     cbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cc0:	75 58                	jne    d1a <doExecTest+0x2c7>
      exec(cmd[0], cmd);
     cc2:	8b 45 08             	mov    0x8(%ebp),%eax
     cc5:	8b 00                	mov    (%eax),%eax
     cc7:	83 ec 08             	sub    $0x8,%esp
     cca:	ff 75 08             	pushl  0x8(%ebp)
     ccd:	50                   	push   %eax
     cce:	e8 9c 07 00 00       	call   146f <exec>
     cd3:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     cd6:	a1 c0 26 00 00       	mov    0x26c0,%eax
     cdb:	83 e8 01             	sub    $0x1,%eax
     cde:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     ce1:	74 1a                	je     cfd <doExecTest+0x2aa>
     ce3:	8b 45 08             	mov    0x8(%ebp),%eax
     ce6:	8b 00                	mov    (%eax),%eax
     ce8:	83 ec 04             	sub    $0x4,%esp
     ceb:	50                   	push   %eax
     cec:	68 00 1c 00 00       	push   $0x1c00
     cf1:	6a 02                	push   $0x2
     cf3:	e8 16 09 00 00       	call   160e <printf>
     cf8:	83 c4 10             	add    $0x10,%esp
     cfb:	eb 18                	jmp    d15 <doExecTest+0x2c2>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     cfd:	8b 45 08             	mov    0x8(%ebp),%eax
     d00:	8b 00                	mov    (%eax),%eax
     d02:	83 ec 04             	sub    $0x4,%esp
     d05:	50                   	push   %eax
     d06:	68 24 1c 00 00       	push   $0x1c24
     d0b:	6a 02                	push   $0x2
     d0d:	e8 fc 08 00 00       	call   160e <printf>
     d12:	83 c4 10             	add    $0x10,%esp
      exit();
     d15:	e8 1d 07 00 00       	call   1437 <exit>
    }
    wait();
     d1a:	e8 20 07 00 00       	call   143f <wait>

  check(stat(cmd[0], &st));
  uid = st.uid;
  gid = st.gid;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     d1f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d23:	a1 c0 26 00 00       	mov    0x26c0,%eax
     d28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     d2b:	0f 8c d0 fd ff ff    	jl     b01 <doExecTest+0xae>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chown(cmd[0], uid);
     d31:	8b 45 08             	mov    0x8(%ebp),%eax
     d34:	8b 00                	mov    (%eax),%eax
     d36:	83 ec 08             	sub    $0x8,%esp
     d39:	ff 75 ec             	pushl  -0x14(%ebp)
     d3c:	50                   	push   %eax
     d3d:	e8 e5 07 00 00       	call   1527 <chown>
     d42:	83 c4 10             	add    $0x10,%esp
  chgrp(cmd[0], gid);
     d45:	8b 45 08             	mov    0x8(%ebp),%eax
     d48:	8b 00                	mov    (%eax),%eax
     d4a:	83 ec 08             	sub    $0x8,%esp
     d4d:	ff 75 e8             	pushl  -0x18(%ebp)
     d50:	50                   	push   %eax
     d51:	e8 d9 07 00 00       	call   152f <chgrp>
     d56:	83 c4 10             	add    $0x10,%esp
  chmod(cmd[0], 00755);
     d59:	8b 45 08             	mov    0x8(%ebp),%eax
     d5c:	8b 00                	mov    (%eax),%eax
     d5e:	83 ec 08             	sub    $0x8,%esp
     d61:	68 ed 01 00 00       	push   $0x1ed
     d66:	50                   	push   %eax
     d67:	e8 b3 07 00 00       	call   151f <chmod>
     d6c:	83 c4 10             	add    $0x10,%esp
  printf(1, "Requires user visually confirms PASS/FAIL\n");
     d6f:	83 ec 08             	sub    $0x8,%esp
     d72:	68 a8 21 00 00       	push   $0x21a8
     d77:	6a 01                	push   $0x1
     d79:	e8 90 08 00 00       	call   160e <printf>
     d7e:	83 c4 10             	add    $0x10,%esp
  return PASS;
     d81:	b8 01 00 00 00       	mov    $0x1,%eax
}
     d86:	c9                   	leave  
     d87:	c3                   	ret    

00000d88 <printMenu>:

void
printMenu(void)
{
     d88:	55                   	push   %ebp
     d89:	89 e5                	mov    %esp,%ebp
     d8b:	83 ec 18             	sub    $0x18,%esp
  int i = 0;
     d8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  printf(1, "\n");
     d95:	83 ec 08             	sub    $0x8,%esp
     d98:	68 d3 21 00 00       	push   $0x21d3
     d9d:	6a 01                	push   $0x1
     d9f:	e8 6a 08 00 00       	call   160e <printf>
     da4:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exit program\n", i++);
     da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     daa:	8d 50 01             	lea    0x1(%eax),%edx
     dad:	89 55 f4             	mov    %edx,-0xc(%ebp)
     db0:	83 ec 04             	sub    $0x4,%esp
     db3:	50                   	push   %eax
     db4:	68 d5 21 00 00       	push   $0x21d5
     db9:	6a 01                	push   $0x1
     dbb:	e8 4e 08 00 00       	call   160e <printf>
     dc0:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc UID\n", i++);
     dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dc6:	8d 50 01             	lea    0x1(%eax),%edx
     dc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dcc:	83 ec 04             	sub    $0x4,%esp
     dcf:	50                   	push   %eax
     dd0:	68 e7 21 00 00       	push   $0x21e7
     dd5:	6a 01                	push   $0x1
     dd7:	e8 32 08 00 00       	call   160e <printf>
     ddc:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc GID\n", i++);
     ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de2:	8d 50 01             	lea    0x1(%eax),%edx
     de5:	89 55 f4             	mov    %edx,-0xc(%ebp)
     de8:	83 ec 04             	sub    $0x4,%esp
     deb:	50                   	push   %eax
     dec:	68 f5 21 00 00       	push   $0x21f5
     df1:	6a 01                	push   $0x1
     df3:	e8 16 08 00 00       	call   160e <printf>
     df8:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chmod()\n", i++);
     dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dfe:	8d 50 01             	lea    0x1(%eax),%edx
     e01:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e04:	83 ec 04             	sub    $0x4,%esp
     e07:	50                   	push   %eax
     e08:	68 03 22 00 00       	push   $0x2203
     e0d:	6a 01                	push   $0x1
     e0f:	e8 fa 07 00 00       	call   160e <printf>
     e14:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chown()\n", i++);
     e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e1a:	8d 50 01             	lea    0x1(%eax),%edx
     e1d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e20:	83 ec 04             	sub    $0x4,%esp
     e23:	50                   	push   %eax
     e24:	68 10 22 00 00       	push   $0x2210
     e29:	6a 01                	push   $0x1
     e2b:	e8 de 07 00 00       	call   160e <printf>
     e30:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chgrp()\n", i++);
     e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e36:	8d 50 01             	lea    0x1(%eax),%edx
     e39:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e3c:	83 ec 04             	sub    $0x4,%esp
     e3f:	50                   	push   %eax
     e40:	68 1d 22 00 00       	push   $0x221d
     e45:	6a 01                	push   $0x1
     e47:	e8 c2 07 00 00       	call   160e <printf>
     e4c:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exec()\n", i++);
     e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e52:	8d 50 01             	lea    0x1(%eax),%edx
     e55:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e58:	83 ec 04             	sub    $0x4,%esp
     e5b:	50                   	push   %eax
     e5c:	68 2a 22 00 00       	push   $0x222a
     e61:	6a 01                	push   $0x1
     e63:	e8 a6 07 00 00       	call   160e <printf>
     e68:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. setuid\n", i++);
     e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e6e:	8d 50 01             	lea    0x1(%eax),%edx
     e71:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e74:	83 ec 04             	sub    $0x4,%esp
     e77:	50                   	push   %eax
     e78:	68 36 22 00 00       	push   $0x2236
     e7d:	6a 01                	push   $0x1
     e7f:	e8 8a 07 00 00       	call   160e <printf>
     e84:	83 c4 10             	add    $0x10,%esp
}
     e87:	90                   	nop
     e88:	c9                   	leave  
     e89:	c3                   	ret    

00000e8a <main>:

int
main(int argc, char *argv[])
{
     e8a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     e8e:	83 e4 f0             	and    $0xfffffff0,%esp
     e91:	ff 71 fc             	pushl  -0x4(%ecx)
     e94:	55                   	push   %ebp
     e95:	89 e5                	mov    %esp,%ebp
     e97:	51                   	push   %ecx
     e98:	83 ec 24             	sub    $0x24,%esp
  int rc, select, done;
  char buf[5];

  // test strings
  char *t0[] = {'\0'}; // dummy
     e9b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  char *t1[] = {"testsetuid", '\0'};
     ea2:	c7 45 d8 42 22 00 00 	movl   $0x2242,-0x28(%ebp)
     ea9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

  while (1) {
    done = FALSE;
     eb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    printMenu();
     eb7:	e8 cc fe ff ff       	call   d88 <printMenu>
    printf(1, "Enter test number: ");
     ebc:	83 ec 08             	sub    $0x8,%esp
     ebf:	68 4d 22 00 00       	push   $0x224d
     ec4:	6a 01                	push   $0x1
     ec6:	e8 43 07 00 00       	call   160e <printf>
     ecb:	83 c4 10             	add    $0x10,%esp
    gets(buf, 5);
     ece:	83 ec 08             	sub    $0x8,%esp
     ed1:	6a 05                	push   $0x5
     ed3:	8d 45 e7             	lea    -0x19(%ebp),%eax
     ed6:	50                   	push   %eax
     ed7:	e8 3a 03 00 00       	call   1216 <gets>
     edc:	83 c4 10             	add    $0x10,%esp
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
     edf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ee3:	3c 0a                	cmp    $0xa,%al
     ee5:	0f 84 f5 01 00 00    	je     10e0 <main+0x256>
     eeb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     eef:	84 c0                	test   %al,%al
     ef1:	0f 84 e9 01 00 00    	je     10e0 <main+0x256>
    select = atoi(buf);
     ef7:	83 ec 0c             	sub    $0xc,%esp
     efa:	8d 45 e7             	lea    -0x19(%ebp),%eax
     efd:	50                   	push   %eax
     efe:	e8 cf 03 00 00       	call   12d2 <atoi>
     f03:	83 c4 10             	add    $0x10,%esp
     f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch (select) {
     f09:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
     f0d:	0f 87 9b 01 00 00    	ja     10ae <main+0x224>
     f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f16:	c1 e0 02             	shl    $0x2,%eax
     f19:	05 f0 22 00 00       	add    $0x22f0,%eax
     f1e:	8b 00                	mov    (%eax),%eax
     f20:	ff e0                	jmp    *%eax
	    case 0: done = TRUE; break;
     f22:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     f29:	e9 a7 01 00 00       	jmp    10d5 <main+0x24b>
	    case 1: doTest(doUidTest,    t0); break;
     f2e:	83 ec 0c             	sub    $0xc,%esp
     f31:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f34:	50                   	push   %eax
     f35:	e8 a3 f4 ff ff       	call   3dd <doUidTest>
     f3a:	83 c4 10             	add    $0x10,%esp
     f3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f44:	0f 85 78 01 00 00    	jne    10c2 <main+0x238>
     f4a:	83 ec 04             	sub    $0x4,%esp
     f4d:	68 61 22 00 00       	push   $0x2261
     f52:	68 6b 22 00 00       	push   $0x226b
     f57:	6a 02                	push   $0x2
     f59:	e8 b0 06 00 00       	call   160e <printf>
     f5e:	83 c4 10             	add    $0x10,%esp
     f61:	e8 d1 04 00 00       	call   1437 <exit>
	    case 2: doTest(doGidTest,    t0); break;
     f66:	83 ec 0c             	sub    $0xc,%esp
     f69:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f6c:	50                   	push   %eax
     f6d:	e8 f4 f5 ff ff       	call   566 <doGidTest>
     f72:	83 c4 10             	add    $0x10,%esp
     f75:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f78:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f7c:	0f 85 43 01 00 00    	jne    10c5 <main+0x23b>
     f82:	83 ec 04             	sub    $0x4,%esp
     f85:	68 7d 22 00 00       	push   $0x227d
     f8a:	68 6b 22 00 00       	push   $0x226b
     f8f:	6a 02                	push   $0x2
     f91:	e8 78 06 00 00       	call   160e <printf>
     f96:	83 c4 10             	add    $0x10,%esp
     f99:	e8 99 04 00 00       	call   1437 <exit>
	    case 3: doTest(doChmodTest,  t1); break;
     f9e:	83 ec 0c             	sub    $0xc,%esp
     fa1:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fa4:	50                   	push   %eax
     fa5:	e8 45 f7 ff ff       	call   6ef <doChmodTest>
     faa:	83 c4 10             	add    $0x10,%esp
     fad:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fb4:	0f 85 0e 01 00 00    	jne    10c8 <main+0x23e>
     fba:	83 ec 04             	sub    $0x4,%esp
     fbd:	68 87 22 00 00       	push   $0x2287
     fc2:	68 6b 22 00 00       	push   $0x226b
     fc7:	6a 02                	push   $0x2
     fc9:	e8 40 06 00 00       	call   160e <printf>
     fce:	83 c4 10             	add    $0x10,%esp
     fd1:	e8 61 04 00 00       	call   1437 <exit>
	    case 4: doTest(doChownTest,  t1); break;
     fd6:	83 ec 0c             	sub    $0xc,%esp
     fd9:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fdc:	50                   	push   %eax
     fdd:	e8 ac f8 ff ff       	call   88e <doChownTest>
     fe2:	83 c4 10             	add    $0x10,%esp
     fe5:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fe8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fec:	0f 85 d9 00 00 00    	jne    10cb <main+0x241>
     ff2:	83 ec 04             	sub    $0x4,%esp
     ff5:	68 93 22 00 00       	push   $0x2293
     ffa:	68 6b 22 00 00       	push   $0x226b
     fff:	6a 02                	push   $0x2
    1001:	e8 08 06 00 00       	call   160e <printf>
    1006:	83 c4 10             	add    $0x10,%esp
    1009:	e8 29 04 00 00       	call   1437 <exit>
	    case 5: doTest(doChgrpTest,  t1); break;
    100e:	83 ec 0c             	sub    $0xc,%esp
    1011:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1014:	50                   	push   %eax
    1015:	e8 58 f9 ff ff       	call   972 <doChgrpTest>
    101a:	83 c4 10             	add    $0x10,%esp
    101d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1020:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1024:	0f 85 a4 00 00 00    	jne    10ce <main+0x244>
    102a:	83 ec 04             	sub    $0x4,%esp
    102d:	68 9f 22 00 00       	push   $0x229f
    1032:	68 6b 22 00 00       	push   $0x226b
    1037:	6a 02                	push   $0x2
    1039:	e8 d0 05 00 00       	call   160e <printf>
    103e:	83 c4 10             	add    $0x10,%esp
    1041:	e8 f1 03 00 00       	call   1437 <exit>
	    case 6: doTest(doExecTest,   t1); break;
    1046:	83 ec 0c             	sub    $0xc,%esp
    1049:	8d 45 d8             	lea    -0x28(%ebp),%eax
    104c:	50                   	push   %eax
    104d:	e8 01 fa ff ff       	call   a53 <doExecTest>
    1052:	83 c4 10             	add    $0x10,%esp
    1055:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1058:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    105c:	75 73                	jne    10d1 <main+0x247>
    105e:	83 ec 04             	sub    $0x4,%esp
    1061:	68 ab 22 00 00       	push   $0x22ab
    1066:	68 6b 22 00 00       	push   $0x226b
    106b:	6a 02                	push   $0x2
    106d:	e8 9c 05 00 00       	call   160e <printf>
    1072:	83 c4 10             	add    $0x10,%esp
    1075:	e8 bd 03 00 00       	call   1437 <exit>
	    case 7: doTest(doSetuidTest, t1); break;
    107a:	83 ec 0c             	sub    $0xc,%esp
    107d:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1080:	50                   	push   %eax
    1081:	e8 65 f0 ff ff       	call   eb <doSetuidTest>
    1086:	83 c4 10             	add    $0x10,%esp
    1089:	89 45 ec             	mov    %eax,-0x14(%ebp)
    108c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1090:	75 42                	jne    10d4 <main+0x24a>
    1092:	83 ec 04             	sub    $0x4,%esp
    1095:	68 b6 22 00 00       	push   $0x22b6
    109a:	68 6b 22 00 00       	push   $0x226b
    109f:	6a 02                	push   $0x2
    10a1:	e8 68 05 00 00       	call   160e <printf>
    10a6:	83 c4 10             	add    $0x10,%esp
    10a9:	e8 89 03 00 00       	call   1437 <exit>
	    default:
		   printf(1, "Error:invalid test number.\n");
    10ae:	83 ec 08             	sub    $0x8,%esp
    10b1:	68 c3 22 00 00       	push   $0x22c3
    10b6:	6a 01                	push   $0x1
    10b8:	e8 51 05 00 00       	call   160e <printf>
    10bd:	83 c4 10             	add    $0x10,%esp
    10c0:	eb 13                	jmp    10d5 <main+0x24b>
    gets(buf, 5);
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    select = atoi(buf);
    switch (select) {
	    case 0: done = TRUE; break;
	    case 1: doTest(doUidTest,    t0); break;
    10c2:	90                   	nop
    10c3:	eb 10                	jmp    10d5 <main+0x24b>
	    case 2: doTest(doGidTest,    t0); break;
    10c5:	90                   	nop
    10c6:	eb 0d                	jmp    10d5 <main+0x24b>
	    case 3: doTest(doChmodTest,  t1); break;
    10c8:	90                   	nop
    10c9:	eb 0a                	jmp    10d5 <main+0x24b>
	    case 4: doTest(doChownTest,  t1); break;
    10cb:	90                   	nop
    10cc:	eb 07                	jmp    10d5 <main+0x24b>
	    case 5: doTest(doChgrpTest,  t1); break;
    10ce:	90                   	nop
    10cf:	eb 04                	jmp    10d5 <main+0x24b>
	    case 6: doTest(doExecTest,   t1); break;
    10d1:	90                   	nop
    10d2:	eb 01                	jmp    10d5 <main+0x24b>
	    case 7: doTest(doSetuidTest, t1); break;
    10d4:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10d9:	75 0b                	jne    10e6 <main+0x25c>
    10db:	e9 d0 fd ff ff       	jmp    eb0 <main+0x26>
  while (1) {
    done = FALSE;
    printMenu();
    printf(1, "Enter test number: ");
    gets(buf, 5);
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    10e0:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
  }
    10e1:	e9 ca fd ff ff       	jmp    eb0 <main+0x26>
	    case 7: doTest(doSetuidTest, t1); break;
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10e6:	90                   	nop
  }

  printf(1, "\nDone for now\n");
    10e7:	83 ec 08             	sub    $0x8,%esp
    10ea:	68 df 22 00 00       	push   $0x22df
    10ef:	6a 01                	push   $0x1
    10f1:	e8 18 05 00 00       	call   160e <printf>
    10f6:	83 c4 10             	add    $0x10,%esp
  free(buf);
    10f9:	83 ec 0c             	sub    $0xc,%esp
    10fc:	8d 45 e7             	lea    -0x19(%ebp),%eax
    10ff:	50                   	push   %eax
    1100:	e8 9a 06 00 00       	call   179f <free>
    1105:	83 c4 10             	add    $0x10,%esp
  exit();
    1108:	e8 2a 03 00 00       	call   1437 <exit>

0000110d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    110d:	55                   	push   %ebp
    110e:	89 e5                	mov    %esp,%ebp
    1110:	57                   	push   %edi
    1111:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1112:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1115:	8b 55 10             	mov    0x10(%ebp),%edx
    1118:	8b 45 0c             	mov    0xc(%ebp),%eax
    111b:	89 cb                	mov    %ecx,%ebx
    111d:	89 df                	mov    %ebx,%edi
    111f:	89 d1                	mov    %edx,%ecx
    1121:	fc                   	cld    
    1122:	f3 aa                	rep stos %al,%es:(%edi)
    1124:	89 ca                	mov    %ecx,%edx
    1126:	89 fb                	mov    %edi,%ebx
    1128:	89 5d 08             	mov    %ebx,0x8(%ebp)
    112b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    112e:	90                   	nop
    112f:	5b                   	pop    %ebx
    1130:	5f                   	pop    %edi
    1131:	5d                   	pop    %ebp
    1132:	c3                   	ret    

00001133 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1133:	55                   	push   %ebp
    1134:	89 e5                	mov    %esp,%ebp
    1136:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1139:	8b 45 08             	mov    0x8(%ebp),%eax
    113c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    113f:	90                   	nop
    1140:	8b 45 08             	mov    0x8(%ebp),%eax
    1143:	8d 50 01             	lea    0x1(%eax),%edx
    1146:	89 55 08             	mov    %edx,0x8(%ebp)
    1149:	8b 55 0c             	mov    0xc(%ebp),%edx
    114c:	8d 4a 01             	lea    0x1(%edx),%ecx
    114f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1152:	0f b6 12             	movzbl (%edx),%edx
    1155:	88 10                	mov    %dl,(%eax)
    1157:	0f b6 00             	movzbl (%eax),%eax
    115a:	84 c0                	test   %al,%al
    115c:	75 e2                	jne    1140 <strcpy+0xd>
    ;
  return os;
    115e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1161:	c9                   	leave  
    1162:	c3                   	ret    

00001163 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1163:	55                   	push   %ebp
    1164:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1166:	eb 08                	jmp    1170 <strcmp+0xd>
    p++, q++;
    1168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1170:	8b 45 08             	mov    0x8(%ebp),%eax
    1173:	0f b6 00             	movzbl (%eax),%eax
    1176:	84 c0                	test   %al,%al
    1178:	74 10                	je     118a <strcmp+0x27>
    117a:	8b 45 08             	mov    0x8(%ebp),%eax
    117d:	0f b6 10             	movzbl (%eax),%edx
    1180:	8b 45 0c             	mov    0xc(%ebp),%eax
    1183:	0f b6 00             	movzbl (%eax),%eax
    1186:	38 c2                	cmp    %al,%dl
    1188:	74 de                	je     1168 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    118a:	8b 45 08             	mov    0x8(%ebp),%eax
    118d:	0f b6 00             	movzbl (%eax),%eax
    1190:	0f b6 d0             	movzbl %al,%edx
    1193:	8b 45 0c             	mov    0xc(%ebp),%eax
    1196:	0f b6 00             	movzbl (%eax),%eax
    1199:	0f b6 c0             	movzbl %al,%eax
    119c:	29 c2                	sub    %eax,%edx
    119e:	89 d0                	mov    %edx,%eax
}
    11a0:	5d                   	pop    %ebp
    11a1:	c3                   	ret    

000011a2 <strlen>:

uint
strlen(char *s)
{
    11a2:	55                   	push   %ebp
    11a3:	89 e5                	mov    %esp,%ebp
    11a5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11af:	eb 04                	jmp    11b5 <strlen+0x13>
    11b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11b8:	8b 45 08             	mov    0x8(%ebp),%eax
    11bb:	01 d0                	add    %edx,%eax
    11bd:	0f b6 00             	movzbl (%eax),%eax
    11c0:	84 c0                	test   %al,%al
    11c2:	75 ed                	jne    11b1 <strlen+0xf>
    ;
  return n;
    11c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11c7:	c9                   	leave  
    11c8:	c3                   	ret    

000011c9 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11c9:	55                   	push   %ebp
    11ca:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    11cc:	8b 45 10             	mov    0x10(%ebp),%eax
    11cf:	50                   	push   %eax
    11d0:	ff 75 0c             	pushl  0xc(%ebp)
    11d3:	ff 75 08             	pushl  0x8(%ebp)
    11d6:	e8 32 ff ff ff       	call   110d <stosb>
    11db:	83 c4 0c             	add    $0xc,%esp
  return dst;
    11de:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11e1:	c9                   	leave  
    11e2:	c3                   	ret    

000011e3 <strchr>:

char*
strchr(const char *s, char c)
{
    11e3:	55                   	push   %ebp
    11e4:	89 e5                	mov    %esp,%ebp
    11e6:	83 ec 04             	sub    $0x4,%esp
    11e9:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ec:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11ef:	eb 14                	jmp    1205 <strchr+0x22>
    if(*s == c)
    11f1:	8b 45 08             	mov    0x8(%ebp),%eax
    11f4:	0f b6 00             	movzbl (%eax),%eax
    11f7:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11fa:	75 05                	jne    1201 <strchr+0x1e>
      return (char*)s;
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
    11ff:	eb 13                	jmp    1214 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1201:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1205:	8b 45 08             	mov    0x8(%ebp),%eax
    1208:	0f b6 00             	movzbl (%eax),%eax
    120b:	84 c0                	test   %al,%al
    120d:	75 e2                	jne    11f1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1214:	c9                   	leave  
    1215:	c3                   	ret    

00001216 <gets>:

char*
gets(char *buf, int max)
{
    1216:	55                   	push   %ebp
    1217:	89 e5                	mov    %esp,%ebp
    1219:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    121c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1223:	eb 42                	jmp    1267 <gets+0x51>
    cc = read(0, &c, 1);
    1225:	83 ec 04             	sub    $0x4,%esp
    1228:	6a 01                	push   $0x1
    122a:	8d 45 ef             	lea    -0x11(%ebp),%eax
    122d:	50                   	push   %eax
    122e:	6a 00                	push   $0x0
    1230:	e8 1a 02 00 00       	call   144f <read>
    1235:	83 c4 10             	add    $0x10,%esp
    1238:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    123b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    123f:	7e 33                	jle    1274 <gets+0x5e>
      break;
    buf[i++] = c;
    1241:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1244:	8d 50 01             	lea    0x1(%eax),%edx
    1247:	89 55 f4             	mov    %edx,-0xc(%ebp)
    124a:	89 c2                	mov    %eax,%edx
    124c:	8b 45 08             	mov    0x8(%ebp),%eax
    124f:	01 c2                	add    %eax,%edx
    1251:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1255:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1257:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    125b:	3c 0a                	cmp    $0xa,%al
    125d:	74 16                	je     1275 <gets+0x5f>
    125f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1263:	3c 0d                	cmp    $0xd,%al
    1265:	74 0e                	je     1275 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1267:	8b 45 f4             	mov    -0xc(%ebp),%eax
    126a:	83 c0 01             	add    $0x1,%eax
    126d:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1270:	7c b3                	jl     1225 <gets+0xf>
    1272:	eb 01                	jmp    1275 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1274:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1275:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1278:	8b 45 08             	mov    0x8(%ebp),%eax
    127b:	01 d0                	add    %edx,%eax
    127d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1280:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1283:	c9                   	leave  
    1284:	c3                   	ret    

00001285 <stat>:

int
stat(char *n, struct stat *st)
{
    1285:	55                   	push   %ebp
    1286:	89 e5                	mov    %esp,%ebp
    1288:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    128b:	83 ec 08             	sub    $0x8,%esp
    128e:	6a 00                	push   $0x0
    1290:	ff 75 08             	pushl  0x8(%ebp)
    1293:	e8 df 01 00 00       	call   1477 <open>
    1298:	83 c4 10             	add    $0x10,%esp
    129b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    129e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12a2:	79 07                	jns    12ab <stat+0x26>
    return -1;
    12a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12a9:	eb 25                	jmp    12d0 <stat+0x4b>
  r = fstat(fd, st);
    12ab:	83 ec 08             	sub    $0x8,%esp
    12ae:	ff 75 0c             	pushl  0xc(%ebp)
    12b1:	ff 75 f4             	pushl  -0xc(%ebp)
    12b4:	e8 d6 01 00 00       	call   148f <fstat>
    12b9:	83 c4 10             	add    $0x10,%esp
    12bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12bf:	83 ec 0c             	sub    $0xc,%esp
    12c2:	ff 75 f4             	pushl  -0xc(%ebp)
    12c5:	e8 95 01 00 00       	call   145f <close>
    12ca:	83 c4 10             	add    $0x10,%esp
  return r;
    12cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12d0:	c9                   	leave  
    12d1:	c3                   	ret    

000012d2 <atoi>:

int
atoi(const char *s)
{
    12d2:	55                   	push   %ebp
    12d3:	89 e5                	mov    %esp,%ebp
    12d5:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    12d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
    12df:	eb 04                	jmp    12e5 <atoi+0x13>
    12e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12e5:	8b 45 08             	mov    0x8(%ebp),%eax
    12e8:	0f b6 00             	movzbl (%eax),%eax
    12eb:	3c 20                	cmp    $0x20,%al
    12ed:	74 f2                	je     12e1 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
    12ef:	8b 45 08             	mov    0x8(%ebp),%eax
    12f2:	0f b6 00             	movzbl (%eax),%eax
    12f5:	3c 2d                	cmp    $0x2d,%al
    12f7:	75 07                	jne    1300 <atoi+0x2e>
    12f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12fe:	eb 05                	jmp    1305 <atoi+0x33>
    1300:	b8 01 00 00 00       	mov    $0x1,%eax
    1305:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    1308:	8b 45 08             	mov    0x8(%ebp),%eax
    130b:	0f b6 00             	movzbl (%eax),%eax
    130e:	3c 2b                	cmp    $0x2b,%al
    1310:	74 0a                	je     131c <atoi+0x4a>
    1312:	8b 45 08             	mov    0x8(%ebp),%eax
    1315:	0f b6 00             	movzbl (%eax),%eax
    1318:	3c 2d                	cmp    $0x2d,%al
    131a:	75 2b                	jne    1347 <atoi+0x75>
    s++;
    131c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
    1320:	eb 25                	jmp    1347 <atoi+0x75>
    n = n*10 + *s++ - '0';
    1322:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1325:	89 d0                	mov    %edx,%eax
    1327:	c1 e0 02             	shl    $0x2,%eax
    132a:	01 d0                	add    %edx,%eax
    132c:	01 c0                	add    %eax,%eax
    132e:	89 c1                	mov    %eax,%ecx
    1330:	8b 45 08             	mov    0x8(%ebp),%eax
    1333:	8d 50 01             	lea    0x1(%eax),%edx
    1336:	89 55 08             	mov    %edx,0x8(%ebp)
    1339:	0f b6 00             	movzbl (%eax),%eax
    133c:	0f be c0             	movsbl %al,%eax
    133f:	01 c8                	add    %ecx,%eax
    1341:	83 e8 30             	sub    $0x30,%eax
    1344:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
    1347:	8b 45 08             	mov    0x8(%ebp),%eax
    134a:	0f b6 00             	movzbl (%eax),%eax
    134d:	3c 2f                	cmp    $0x2f,%al
    134f:	7e 0a                	jle    135b <atoi+0x89>
    1351:	8b 45 08             	mov    0x8(%ebp),%eax
    1354:	0f b6 00             	movzbl (%eax),%eax
    1357:	3c 39                	cmp    $0x39,%al
    1359:	7e c7                	jle    1322 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
    135b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    135e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    1362:	c9                   	leave  
    1363:	c3                   	ret    

00001364 <atoo>:

int
atoo(const char *s)
{
    1364:	55                   	push   %ebp
    1365:	89 e5                	mov    %esp,%ebp
    1367:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    136a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
    1371:	eb 04                	jmp    1377 <atoo+0x13>
    1373:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1377:	8b 45 08             	mov    0x8(%ebp),%eax
    137a:	0f b6 00             	movzbl (%eax),%eax
    137d:	3c 20                	cmp    $0x20,%al
    137f:	74 f2                	je     1373 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
    1381:	8b 45 08             	mov    0x8(%ebp),%eax
    1384:	0f b6 00             	movzbl (%eax),%eax
    1387:	3c 2d                	cmp    $0x2d,%al
    1389:	75 07                	jne    1392 <atoo+0x2e>
    138b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1390:	eb 05                	jmp    1397 <atoo+0x33>
    1392:	b8 01 00 00 00       	mov    $0x1,%eax
    1397:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    139a:	8b 45 08             	mov    0x8(%ebp),%eax
    139d:	0f b6 00             	movzbl (%eax),%eax
    13a0:	3c 2b                	cmp    $0x2b,%al
    13a2:	74 0a                	je     13ae <atoo+0x4a>
    13a4:	8b 45 08             	mov    0x8(%ebp),%eax
    13a7:	0f b6 00             	movzbl (%eax),%eax
    13aa:	3c 2d                	cmp    $0x2d,%al
    13ac:	75 27                	jne    13d5 <atoo+0x71>
    s++;
    13ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
    13b2:	eb 21                	jmp    13d5 <atoo+0x71>
    n = n*8 + *s++ - '0';
    13b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13b7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
    13be:	8b 45 08             	mov    0x8(%ebp),%eax
    13c1:	8d 50 01             	lea    0x1(%eax),%edx
    13c4:	89 55 08             	mov    %edx,0x8(%ebp)
    13c7:	0f b6 00             	movzbl (%eax),%eax
    13ca:	0f be c0             	movsbl %al,%eax
    13cd:	01 c8                	add    %ecx,%eax
    13cf:	83 e8 30             	sub    $0x30,%eax
    13d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
    13d5:	8b 45 08             	mov    0x8(%ebp),%eax
    13d8:	0f b6 00             	movzbl (%eax),%eax
    13db:	3c 2f                	cmp    $0x2f,%al
    13dd:	7e 0a                	jle    13e9 <atoo+0x85>
    13df:	8b 45 08             	mov    0x8(%ebp),%eax
    13e2:	0f b6 00             	movzbl (%eax),%eax
    13e5:	3c 37                	cmp    $0x37,%al
    13e7:	7e cb                	jle    13b4 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
    13e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13ec:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    13f0:	c9                   	leave  
    13f1:	c3                   	ret    

000013f2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13f2:	55                   	push   %ebp
    13f3:	89 e5                	mov    %esp,%ebp
    13f5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    13f8:	8b 45 08             	mov    0x8(%ebp),%eax
    13fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    13fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    1401:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1404:	eb 17                	jmp    141d <memmove+0x2b>
    *dst++ = *src++;
    1406:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1409:	8d 50 01             	lea    0x1(%eax),%edx
    140c:	89 55 fc             	mov    %edx,-0x4(%ebp)
    140f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1412:	8d 4a 01             	lea    0x1(%edx),%ecx
    1415:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1418:	0f b6 12             	movzbl (%edx),%edx
    141b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    141d:	8b 45 10             	mov    0x10(%ebp),%eax
    1420:	8d 50 ff             	lea    -0x1(%eax),%edx
    1423:	89 55 10             	mov    %edx,0x10(%ebp)
    1426:	85 c0                	test   %eax,%eax
    1428:	7f dc                	jg     1406 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    142a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    142d:	c9                   	leave  
    142e:	c3                   	ret    

0000142f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    142f:	b8 01 00 00 00       	mov    $0x1,%eax
    1434:	cd 40                	int    $0x40
    1436:	c3                   	ret    

00001437 <exit>:
SYSCALL(exit)
    1437:	b8 02 00 00 00       	mov    $0x2,%eax
    143c:	cd 40                	int    $0x40
    143e:	c3                   	ret    

0000143f <wait>:
SYSCALL(wait)
    143f:	b8 03 00 00 00       	mov    $0x3,%eax
    1444:	cd 40                	int    $0x40
    1446:	c3                   	ret    

00001447 <pipe>:
SYSCALL(pipe)
    1447:	b8 04 00 00 00       	mov    $0x4,%eax
    144c:	cd 40                	int    $0x40
    144e:	c3                   	ret    

0000144f <read>:
SYSCALL(read)
    144f:	b8 05 00 00 00       	mov    $0x5,%eax
    1454:	cd 40                	int    $0x40
    1456:	c3                   	ret    

00001457 <write>:
SYSCALL(write)
    1457:	b8 10 00 00 00       	mov    $0x10,%eax
    145c:	cd 40                	int    $0x40
    145e:	c3                   	ret    

0000145f <close>:
SYSCALL(close)
    145f:	b8 15 00 00 00       	mov    $0x15,%eax
    1464:	cd 40                	int    $0x40
    1466:	c3                   	ret    

00001467 <kill>:
SYSCALL(kill)
    1467:	b8 06 00 00 00       	mov    $0x6,%eax
    146c:	cd 40                	int    $0x40
    146e:	c3                   	ret    

0000146f <exec>:
SYSCALL(exec)
    146f:	b8 07 00 00 00       	mov    $0x7,%eax
    1474:	cd 40                	int    $0x40
    1476:	c3                   	ret    

00001477 <open>:
SYSCALL(open)
    1477:	b8 0f 00 00 00       	mov    $0xf,%eax
    147c:	cd 40                	int    $0x40
    147e:	c3                   	ret    

0000147f <mknod>:
SYSCALL(mknod)
    147f:	b8 11 00 00 00       	mov    $0x11,%eax
    1484:	cd 40                	int    $0x40
    1486:	c3                   	ret    

00001487 <unlink>:
SYSCALL(unlink)
    1487:	b8 12 00 00 00       	mov    $0x12,%eax
    148c:	cd 40                	int    $0x40
    148e:	c3                   	ret    

0000148f <fstat>:
SYSCALL(fstat)
    148f:	b8 08 00 00 00       	mov    $0x8,%eax
    1494:	cd 40                	int    $0x40
    1496:	c3                   	ret    

00001497 <link>:
SYSCALL(link)
    1497:	b8 13 00 00 00       	mov    $0x13,%eax
    149c:	cd 40                	int    $0x40
    149e:	c3                   	ret    

0000149f <mkdir>:
SYSCALL(mkdir)
    149f:	b8 14 00 00 00       	mov    $0x14,%eax
    14a4:	cd 40                	int    $0x40
    14a6:	c3                   	ret    

000014a7 <chdir>:
SYSCALL(chdir)
    14a7:	b8 09 00 00 00       	mov    $0x9,%eax
    14ac:	cd 40                	int    $0x40
    14ae:	c3                   	ret    

000014af <dup>:
SYSCALL(dup)
    14af:	b8 0a 00 00 00       	mov    $0xa,%eax
    14b4:	cd 40                	int    $0x40
    14b6:	c3                   	ret    

000014b7 <getpid>:
SYSCALL(getpid)
    14b7:	b8 0b 00 00 00       	mov    $0xb,%eax
    14bc:	cd 40                	int    $0x40
    14be:	c3                   	ret    

000014bf <sbrk>:
SYSCALL(sbrk)
    14bf:	b8 0c 00 00 00       	mov    $0xc,%eax
    14c4:	cd 40                	int    $0x40
    14c6:	c3                   	ret    

000014c7 <sleep>:
SYSCALL(sleep)
    14c7:	b8 0d 00 00 00       	mov    $0xd,%eax
    14cc:	cd 40                	int    $0x40
    14ce:	c3                   	ret    

000014cf <uptime>:
SYSCALL(uptime)
    14cf:	b8 0e 00 00 00       	mov    $0xe,%eax
    14d4:	cd 40                	int    $0x40
    14d6:	c3                   	ret    

000014d7 <halt>:
SYSCALL(halt)
    14d7:	b8 16 00 00 00       	mov    $0x16,%eax
    14dc:	cd 40                	int    $0x40
    14de:	c3                   	ret    

000014df <date>:
SYSCALL(date)        #p1
    14df:	b8 17 00 00 00       	mov    $0x17,%eax
    14e4:	cd 40                	int    $0x40
    14e6:	c3                   	ret    

000014e7 <getuid>:
SYSCALL(getuid)      #p2
    14e7:	b8 18 00 00 00       	mov    $0x18,%eax
    14ec:	cd 40                	int    $0x40
    14ee:	c3                   	ret    

000014ef <getgid>:
SYSCALL(getgid)      #p2
    14ef:	b8 19 00 00 00       	mov    $0x19,%eax
    14f4:	cd 40                	int    $0x40
    14f6:	c3                   	ret    

000014f7 <getppid>:
SYSCALL(getppid)     #p2
    14f7:	b8 1a 00 00 00       	mov    $0x1a,%eax
    14fc:	cd 40                	int    $0x40
    14fe:	c3                   	ret    

000014ff <setuid>:
SYSCALL(setuid)      #p2
    14ff:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1504:	cd 40                	int    $0x40
    1506:	c3                   	ret    

00001507 <setgid>:
SYSCALL(setgid)      #p2
    1507:	b8 1c 00 00 00       	mov    $0x1c,%eax
    150c:	cd 40                	int    $0x40
    150e:	c3                   	ret    

0000150f <getprocs>:
SYSCALL(getprocs)    #p2
    150f:	b8 1d 00 00 00       	mov    $0x1d,%eax
    1514:	cd 40                	int    $0x40
    1516:	c3                   	ret    

00001517 <setpriority>:
SYSCALL(setpriority) #p4
    1517:	b8 1e 00 00 00       	mov    $0x1e,%eax
    151c:	cd 40                	int    $0x40
    151e:	c3                   	ret    

0000151f <chmod>:
SYSCALL(chmod)       #p5
    151f:	b8 1f 00 00 00       	mov    $0x1f,%eax
    1524:	cd 40                	int    $0x40
    1526:	c3                   	ret    

00001527 <chown>:
SYSCALL(chown)       #p5
    1527:	b8 20 00 00 00       	mov    $0x20,%eax
    152c:	cd 40                	int    $0x40
    152e:	c3                   	ret    

0000152f <chgrp>:
SYSCALL(chgrp)       #p5
    152f:	b8 21 00 00 00       	mov    $0x21,%eax
    1534:	cd 40                	int    $0x40
    1536:	c3                   	ret    

00001537 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1537:	55                   	push   %ebp
    1538:	89 e5                	mov    %esp,%ebp
    153a:	83 ec 18             	sub    $0x18,%esp
    153d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1540:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1543:	83 ec 04             	sub    $0x4,%esp
    1546:	6a 01                	push   $0x1
    1548:	8d 45 f4             	lea    -0xc(%ebp),%eax
    154b:	50                   	push   %eax
    154c:	ff 75 08             	pushl  0x8(%ebp)
    154f:	e8 03 ff ff ff       	call   1457 <write>
    1554:	83 c4 10             	add    $0x10,%esp
}
    1557:	90                   	nop
    1558:	c9                   	leave  
    1559:	c3                   	ret    

0000155a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    155a:	55                   	push   %ebp
    155b:	89 e5                	mov    %esp,%ebp
    155d:	53                   	push   %ebx
    155e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1561:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1568:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    156c:	74 17                	je     1585 <printint+0x2b>
    156e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1572:	79 11                	jns    1585 <printint+0x2b>
    neg = 1;
    1574:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    157b:	8b 45 0c             	mov    0xc(%ebp),%eax
    157e:	f7 d8                	neg    %eax
    1580:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1583:	eb 06                	jmp    158b <printint+0x31>
  } else {
    x = xx;
    1585:	8b 45 0c             	mov    0xc(%ebp),%eax
    1588:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    158b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1592:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1595:	8d 41 01             	lea    0x1(%ecx),%eax
    1598:	89 45 f4             	mov    %eax,-0xc(%ebp)
    159b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    159e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    15a1:	ba 00 00 00 00       	mov    $0x0,%edx
    15a6:	f7 f3                	div    %ebx
    15a8:	89 d0                	mov    %edx,%eax
    15aa:	0f b6 80 20 27 00 00 	movzbl 0x2720(%eax),%eax
    15b1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    15b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    15b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    15bb:	ba 00 00 00 00       	mov    $0x0,%edx
    15c0:	f7 f3                	div    %ebx
    15c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    15c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15c9:	75 c7                	jne    1592 <printint+0x38>
  if(neg)
    15cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    15cf:	74 2d                	je     15fe <printint+0xa4>
    buf[i++] = '-';
    15d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15d4:	8d 50 01             	lea    0x1(%eax),%edx
    15d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
    15da:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    15df:	eb 1d                	jmp    15fe <printint+0xa4>
    putc(fd, buf[i]);
    15e1:	8d 55 dc             	lea    -0x24(%ebp),%edx
    15e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15e7:	01 d0                	add    %edx,%eax
    15e9:	0f b6 00             	movzbl (%eax),%eax
    15ec:	0f be c0             	movsbl %al,%eax
    15ef:	83 ec 08             	sub    $0x8,%esp
    15f2:	50                   	push   %eax
    15f3:	ff 75 08             	pushl  0x8(%ebp)
    15f6:	e8 3c ff ff ff       	call   1537 <putc>
    15fb:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    15fe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1606:	79 d9                	jns    15e1 <printint+0x87>
    putc(fd, buf[i]);
}
    1608:	90                   	nop
    1609:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    160c:	c9                   	leave  
    160d:	c3                   	ret    

0000160e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    160e:	55                   	push   %ebp
    160f:	89 e5                	mov    %esp,%ebp
    1611:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1614:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    161b:	8d 45 0c             	lea    0xc(%ebp),%eax
    161e:	83 c0 04             	add    $0x4,%eax
    1621:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1624:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    162b:	e9 59 01 00 00       	jmp    1789 <printf+0x17b>
    c = fmt[i] & 0xff;
    1630:	8b 55 0c             	mov    0xc(%ebp),%edx
    1633:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1636:	01 d0                	add    %edx,%eax
    1638:	0f b6 00             	movzbl (%eax),%eax
    163b:	0f be c0             	movsbl %al,%eax
    163e:	25 ff 00 00 00       	and    $0xff,%eax
    1643:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1646:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    164a:	75 2c                	jne    1678 <printf+0x6a>
      if(c == '%'){
    164c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1650:	75 0c                	jne    165e <printf+0x50>
        state = '%';
    1652:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1659:	e9 27 01 00 00       	jmp    1785 <printf+0x177>
      } else {
        putc(fd, c);
    165e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1661:	0f be c0             	movsbl %al,%eax
    1664:	83 ec 08             	sub    $0x8,%esp
    1667:	50                   	push   %eax
    1668:	ff 75 08             	pushl  0x8(%ebp)
    166b:	e8 c7 fe ff ff       	call   1537 <putc>
    1670:	83 c4 10             	add    $0x10,%esp
    1673:	e9 0d 01 00 00       	jmp    1785 <printf+0x177>
      }
    } else if(state == '%'){
    1678:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    167c:	0f 85 03 01 00 00    	jne    1785 <printf+0x177>
      if(c == 'd'){
    1682:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1686:	75 1e                	jne    16a6 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1688:	8b 45 e8             	mov    -0x18(%ebp),%eax
    168b:	8b 00                	mov    (%eax),%eax
    168d:	6a 01                	push   $0x1
    168f:	6a 0a                	push   $0xa
    1691:	50                   	push   %eax
    1692:	ff 75 08             	pushl  0x8(%ebp)
    1695:	e8 c0 fe ff ff       	call   155a <printint>
    169a:	83 c4 10             	add    $0x10,%esp
        ap++;
    169d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16a1:	e9 d8 00 00 00       	jmp    177e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    16a6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    16aa:	74 06                	je     16b2 <printf+0xa4>
    16ac:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    16b0:	75 1e                	jne    16d0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    16b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16b5:	8b 00                	mov    (%eax),%eax
    16b7:	6a 00                	push   $0x0
    16b9:	6a 10                	push   $0x10
    16bb:	50                   	push   %eax
    16bc:	ff 75 08             	pushl  0x8(%ebp)
    16bf:	e8 96 fe ff ff       	call   155a <printint>
    16c4:	83 c4 10             	add    $0x10,%esp
        ap++;
    16c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16cb:	e9 ae 00 00 00       	jmp    177e <printf+0x170>
      } else if(c == 's'){
    16d0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    16d4:	75 43                	jne    1719 <printf+0x10b>
        s = (char*)*ap;
    16d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16d9:	8b 00                	mov    (%eax),%eax
    16db:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    16de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    16e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16e6:	75 25                	jne    170d <printf+0xff>
          s = "(null)";
    16e8:	c7 45 f4 10 23 00 00 	movl   $0x2310,-0xc(%ebp)
        while(*s != 0){
    16ef:	eb 1c                	jmp    170d <printf+0xff>
          putc(fd, *s);
    16f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f4:	0f b6 00             	movzbl (%eax),%eax
    16f7:	0f be c0             	movsbl %al,%eax
    16fa:	83 ec 08             	sub    $0x8,%esp
    16fd:	50                   	push   %eax
    16fe:	ff 75 08             	pushl  0x8(%ebp)
    1701:	e8 31 fe ff ff       	call   1537 <putc>
    1706:	83 c4 10             	add    $0x10,%esp
          s++;
    1709:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    170d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1710:	0f b6 00             	movzbl (%eax),%eax
    1713:	84 c0                	test   %al,%al
    1715:	75 da                	jne    16f1 <printf+0xe3>
    1717:	eb 65                	jmp    177e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1719:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    171d:	75 1d                	jne    173c <printf+0x12e>
        putc(fd, *ap);
    171f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1722:	8b 00                	mov    (%eax),%eax
    1724:	0f be c0             	movsbl %al,%eax
    1727:	83 ec 08             	sub    $0x8,%esp
    172a:	50                   	push   %eax
    172b:	ff 75 08             	pushl  0x8(%ebp)
    172e:	e8 04 fe ff ff       	call   1537 <putc>
    1733:	83 c4 10             	add    $0x10,%esp
        ap++;
    1736:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    173a:	eb 42                	jmp    177e <printf+0x170>
      } else if(c == '%'){
    173c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1740:	75 17                	jne    1759 <printf+0x14b>
        putc(fd, c);
    1742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1745:	0f be c0             	movsbl %al,%eax
    1748:	83 ec 08             	sub    $0x8,%esp
    174b:	50                   	push   %eax
    174c:	ff 75 08             	pushl  0x8(%ebp)
    174f:	e8 e3 fd ff ff       	call   1537 <putc>
    1754:	83 c4 10             	add    $0x10,%esp
    1757:	eb 25                	jmp    177e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1759:	83 ec 08             	sub    $0x8,%esp
    175c:	6a 25                	push   $0x25
    175e:	ff 75 08             	pushl  0x8(%ebp)
    1761:	e8 d1 fd ff ff       	call   1537 <putc>
    1766:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    176c:	0f be c0             	movsbl %al,%eax
    176f:	83 ec 08             	sub    $0x8,%esp
    1772:	50                   	push   %eax
    1773:	ff 75 08             	pushl  0x8(%ebp)
    1776:	e8 bc fd ff ff       	call   1537 <putc>
    177b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    177e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1785:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1789:	8b 55 0c             	mov    0xc(%ebp),%edx
    178c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    178f:	01 d0                	add    %edx,%eax
    1791:	0f b6 00             	movzbl (%eax),%eax
    1794:	84 c0                	test   %al,%al
    1796:	0f 85 94 fe ff ff    	jne    1630 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    179c:	90                   	nop
    179d:	c9                   	leave  
    179e:	c3                   	ret    

0000179f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    179f:	55                   	push   %ebp
    17a0:	89 e5                	mov    %esp,%ebp
    17a2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    17a5:	8b 45 08             	mov    0x8(%ebp),%eax
    17a8:	83 e8 08             	sub    $0x8,%eax
    17ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17ae:	a1 3c 27 00 00       	mov    0x273c,%eax
    17b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17b6:	eb 24                	jmp    17dc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17bb:	8b 00                	mov    (%eax),%eax
    17bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17c0:	77 12                	ja     17d4 <free+0x35>
    17c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17c8:	77 24                	ja     17ee <free+0x4f>
    17ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17cd:	8b 00                	mov    (%eax),%eax
    17cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17d2:	77 1a                	ja     17ee <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17d7:	8b 00                	mov    (%eax),%eax
    17d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17e2:	76 d4                	jbe    17b8 <free+0x19>
    17e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e7:	8b 00                	mov    (%eax),%eax
    17e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17ec:	76 ca                	jbe    17b8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17f1:	8b 40 04             	mov    0x4(%eax),%eax
    17f4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17fe:	01 c2                	add    %eax,%edx
    1800:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1803:	8b 00                	mov    (%eax),%eax
    1805:	39 c2                	cmp    %eax,%edx
    1807:	75 24                	jne    182d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1809:	8b 45 f8             	mov    -0x8(%ebp),%eax
    180c:	8b 50 04             	mov    0x4(%eax),%edx
    180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1812:	8b 00                	mov    (%eax),%eax
    1814:	8b 40 04             	mov    0x4(%eax),%eax
    1817:	01 c2                	add    %eax,%edx
    1819:	8b 45 f8             	mov    -0x8(%ebp),%eax
    181c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    181f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1822:	8b 00                	mov    (%eax),%eax
    1824:	8b 10                	mov    (%eax),%edx
    1826:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1829:	89 10                	mov    %edx,(%eax)
    182b:	eb 0a                	jmp    1837 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    182d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1830:	8b 10                	mov    (%eax),%edx
    1832:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1835:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1837:	8b 45 fc             	mov    -0x4(%ebp),%eax
    183a:	8b 40 04             	mov    0x4(%eax),%eax
    183d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1844:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1847:	01 d0                	add    %edx,%eax
    1849:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    184c:	75 20                	jne    186e <free+0xcf>
    p->s.size += bp->s.size;
    184e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1851:	8b 50 04             	mov    0x4(%eax),%edx
    1854:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1857:	8b 40 04             	mov    0x4(%eax),%eax
    185a:	01 c2                	add    %eax,%edx
    185c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    185f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1862:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1865:	8b 10                	mov    (%eax),%edx
    1867:	8b 45 fc             	mov    -0x4(%ebp),%eax
    186a:	89 10                	mov    %edx,(%eax)
    186c:	eb 08                	jmp    1876 <free+0xd7>
  } else
    p->s.ptr = bp;
    186e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1871:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1874:	89 10                	mov    %edx,(%eax)
  freep = p;
    1876:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1879:	a3 3c 27 00 00       	mov    %eax,0x273c
}
    187e:	90                   	nop
    187f:	c9                   	leave  
    1880:	c3                   	ret    

00001881 <morecore>:

static Header*
morecore(uint nu)
{
    1881:	55                   	push   %ebp
    1882:	89 e5                	mov    %esp,%ebp
    1884:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1887:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    188e:	77 07                	ja     1897 <morecore+0x16>
    nu = 4096;
    1890:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1897:	8b 45 08             	mov    0x8(%ebp),%eax
    189a:	c1 e0 03             	shl    $0x3,%eax
    189d:	83 ec 0c             	sub    $0xc,%esp
    18a0:	50                   	push   %eax
    18a1:	e8 19 fc ff ff       	call   14bf <sbrk>
    18a6:	83 c4 10             	add    $0x10,%esp
    18a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    18ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    18b0:	75 07                	jne    18b9 <morecore+0x38>
    return 0;
    18b2:	b8 00 00 00 00       	mov    $0x0,%eax
    18b7:	eb 26                	jmp    18df <morecore+0x5e>
  hp = (Header*)p;
    18b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    18bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18c2:	8b 55 08             	mov    0x8(%ebp),%edx
    18c5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    18c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18cb:	83 c0 08             	add    $0x8,%eax
    18ce:	83 ec 0c             	sub    $0xc,%esp
    18d1:	50                   	push   %eax
    18d2:	e8 c8 fe ff ff       	call   179f <free>
    18d7:	83 c4 10             	add    $0x10,%esp
  return freep;
    18da:	a1 3c 27 00 00       	mov    0x273c,%eax
}
    18df:	c9                   	leave  
    18e0:	c3                   	ret    

000018e1 <malloc>:

void*
malloc(uint nbytes)
{
    18e1:	55                   	push   %ebp
    18e2:	89 e5                	mov    %esp,%ebp
    18e4:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18e7:	8b 45 08             	mov    0x8(%ebp),%eax
    18ea:	83 c0 07             	add    $0x7,%eax
    18ed:	c1 e8 03             	shr    $0x3,%eax
    18f0:	83 c0 01             	add    $0x1,%eax
    18f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18f6:	a1 3c 27 00 00       	mov    0x273c,%eax
    18fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1902:	75 23                	jne    1927 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1904:	c7 45 f0 34 27 00 00 	movl   $0x2734,-0x10(%ebp)
    190b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    190e:	a3 3c 27 00 00       	mov    %eax,0x273c
    1913:	a1 3c 27 00 00       	mov    0x273c,%eax
    1918:	a3 34 27 00 00       	mov    %eax,0x2734
    base.s.size = 0;
    191d:	c7 05 38 27 00 00 00 	movl   $0x0,0x2738
    1924:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1927:	8b 45 f0             	mov    -0x10(%ebp),%eax
    192a:	8b 00                	mov    (%eax),%eax
    192c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    192f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1932:	8b 40 04             	mov    0x4(%eax),%eax
    1935:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1938:	72 4d                	jb     1987 <malloc+0xa6>
      if(p->s.size == nunits)
    193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    193d:	8b 40 04             	mov    0x4(%eax),%eax
    1940:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1943:	75 0c                	jne    1951 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1945:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1948:	8b 10                	mov    (%eax),%edx
    194a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    194d:	89 10                	mov    %edx,(%eax)
    194f:	eb 26                	jmp    1977 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1951:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1954:	8b 40 04             	mov    0x4(%eax),%eax
    1957:	2b 45 ec             	sub    -0x14(%ebp),%eax
    195a:	89 c2                	mov    %eax,%edx
    195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    195f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1962:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1965:	8b 40 04             	mov    0x4(%eax),%eax
    1968:	c1 e0 03             	shl    $0x3,%eax
    196b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    196e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1971:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1974:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1977:	8b 45 f0             	mov    -0x10(%ebp),%eax
    197a:	a3 3c 27 00 00       	mov    %eax,0x273c
      return (void*)(p + 1);
    197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1982:	83 c0 08             	add    $0x8,%eax
    1985:	eb 3b                	jmp    19c2 <malloc+0xe1>
    }
    if(p == freep)
    1987:	a1 3c 27 00 00       	mov    0x273c,%eax
    198c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    198f:	75 1e                	jne    19af <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1991:	83 ec 0c             	sub    $0xc,%esp
    1994:	ff 75 ec             	pushl  -0x14(%ebp)
    1997:	e8 e5 fe ff ff       	call   1881 <morecore>
    199c:	83 c4 10             	add    $0x10,%esp
    199f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    19a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19a6:	75 07                	jne    19af <malloc+0xce>
        return 0;
    19a8:	b8 00 00 00 00       	mov    $0x0,%eax
    19ad:	eb 13                	jmp    19c2 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    19b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19b8:	8b 00                	mov    (%eax),%eax
    19ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    19bd:	e9 6d ff ff ff       	jmp    192f <malloc+0x4e>
}
    19c2:	c9                   	leave  
    19c3:	c3                   	ret    
