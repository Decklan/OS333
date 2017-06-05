
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
       6:	e8 97 14 00 00       	call   14a2 <getuid>
       b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  gid = getgid();
       e:	e8 97 14 00 00       	call   14aa <getgid>
      13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  check(stat(name, &st));
      16:	83 ec 08             	sub    $0x8,%esp
      19:	8d 45 d0             	lea    -0x30(%ebp),%eax
      1c:	50                   	push   %eax
      1d:	ff 75 08             	pushl  0x8(%ebp)
      20:	e8 1b 12 00 00       	call   1240 <stat>
      25:	83 c4 10             	add    $0x10,%esp
      28:	89 45 ec             	mov    %eax,-0x14(%ebp)
      2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
      2f:	74 21                	je     52 <canRun+0x52>
      31:	83 ec 04             	sub    $0x4,%esp
      34:	68 80 19 00 00       	push   $0x1980
      39:	68 90 19 00 00       	push   $0x1990
      3e:	6a 02                	push   $0x2
      40:	e8 84 15 00 00       	call   15c9 <printf>
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
      73:	68 a4 19 00 00       	push   $0x19a4
      78:	6a 02                	push   $0x2
      7a:	e8 4a 15 00 00       	call   15c9 <printf>
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
      aa:	68 d8 19 00 00       	push   $0x19d8
      af:	6a 02                	push   $0x2
      b1:	e8 13 15 00 00       	call   15c9 <printf>
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
      d5:	68 0c 1a 00 00       	push   $0x1a0c
      da:	6a 02                	push   $0x2
      dc:	e8 e8 14 00 00       	call   15c9 <printf>
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
      f2:	c7 45 e0 33 1a 00 00 	movl   $0x1a33,-0x20(%ebp)
      f9:	c7 45 e4 3d 1a 00 00 	movl   $0x1a3d,-0x1c(%ebp)
     100:	c7 45 e8 47 1a 00 00 	movl   $0x1a47,-0x18(%ebp)
     107:	c7 45 ec 4d 1a 00 00 	movl   $0x1a4d,-0x14(%ebp)

  printf(1, "\nTesting the set uid bit.\n\n");
     10e:	83 ec 08             	sub    $0x8,%esp
     111:	68 59 1a 00 00       	push   $0x1a59
     116:	6a 01                	push   $0x1
     118:	e8 ac 14 00 00       	call   15c9 <printf>
     11d:	83 c4 10             	add    $0x10,%esp

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     120:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     127:	e9 71 02 00 00       	jmp    39d <doSetuidTest+0x2b2>
    printf(1, "Starting test: %s.\n", test[i]);
     12c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     12f:	8b 44 85 e0          	mov    -0x20(%ebp,%eax,4),%eax
     133:	83 ec 04             	sub    $0x4,%esp
     136:	50                   	push   %eax
     137:	68 75 1a 00 00       	push   $0x1a75
     13c:	6a 01                	push   $0x1
     13e:	e8 86 14 00 00       	call   15c9 <printf>
     143:	83 c4 10             	add    $0x10,%esp
    check(setuid(testperms[i][procuid]));
     146:	8b 45 f4             	mov    -0xc(%ebp),%eax
     149:	c1 e0 04             	shl    $0x4,%eax
     14c:	05 40 26 00 00       	add    $0x2640,%eax
     151:	8b 00                	mov    (%eax),%eax
     153:	83 ec 0c             	sub    $0xc,%esp
     156:	50                   	push   %eax
     157:	e8 5e 13 00 00       	call   14ba <setuid>
     15c:	83 c4 10             	add    $0x10,%esp
     15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     166:	74 21                	je     189 <doSetuidTest+0x9e>
     168:	83 ec 04             	sub    $0x4,%esp
     16b:	68 89 1a 00 00       	push   $0x1a89
     170:	68 90 19 00 00       	push   $0x1990
     175:	6a 02                	push   $0x2
     177:	e8 4d 14 00 00       	call   15c9 <printf>
     17c:	83 c4 10             	add    $0x10,%esp
     17f:	b8 00 00 00 00       	mov    $0x0,%eax
     184:	e9 4f 02 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    check(setgid(testperms[i][procgid]));
     189:	8b 45 f4             	mov    -0xc(%ebp),%eax
     18c:	c1 e0 04             	shl    $0x4,%eax
     18f:	05 44 26 00 00       	add    $0x2644,%eax
     194:	8b 00                	mov    (%eax),%eax
     196:	83 ec 0c             	sub    $0xc,%esp
     199:	50                   	push   %eax
     19a:	e8 23 13 00 00       	call   14c2 <setgid>
     19f:	83 c4 10             	add    $0x10,%esp
     1a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     1a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1a9:	74 21                	je     1cc <doSetuidTest+0xe1>
     1ab:	83 ec 04             	sub    $0x4,%esp
     1ae:	68 a7 1a 00 00       	push   $0x1aa7
     1b3:	68 90 19 00 00       	push   $0x1990
     1b8:	6a 02                	push   $0x2
     1ba:	e8 0a 14 00 00       	call   15c9 <printf>
     1bf:	83 c4 10             	add    $0x10,%esp
     1c2:	b8 00 00 00 00       	mov    $0x0,%eax
     1c7:	e9 0c 02 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "Process uid: %d, gid: %d\n", getuid(), getgid());
     1cc:	e8 d9 12 00 00       	call   14aa <getgid>
     1d1:	89 c3                	mov    %eax,%ebx
     1d3:	e8 ca 12 00 00       	call   14a2 <getuid>
     1d8:	53                   	push   %ebx
     1d9:	50                   	push   %eax
     1da:	68 c5 1a 00 00       	push   $0x1ac5
     1df:	6a 01                	push   $0x1
     1e1:	e8 e3 13 00 00       	call   15c9 <printf>
     1e6:	83 c4 10             	add    $0x10,%esp
    check(chown(cmd[0], testperms[i][fileuid]));
     1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1ec:	c1 e0 04             	shl    $0x4,%eax
     1ef:	05 48 26 00 00       	add    $0x2648,%eax
     1f4:	8b 10                	mov    (%eax),%edx
     1f6:	8b 45 08             	mov    0x8(%ebp),%eax
     1f9:	8b 00                	mov    (%eax),%eax
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	52                   	push   %edx
     1ff:	50                   	push   %eax
     200:	e8 dd 12 00 00       	call   14e2 <chown>
     205:	83 c4 10             	add    $0x10,%esp
     208:	89 45 f0             	mov    %eax,-0x10(%ebp)
     20b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     20f:	74 21                	je     232 <doSetuidTest+0x147>
     211:	83 ec 04             	sub    $0x4,%esp
     214:	68 e0 1a 00 00       	push   $0x1ae0
     219:	68 90 19 00 00       	push   $0x1990
     21e:	6a 02                	push   $0x2
     220:	e8 a4 13 00 00       	call   15c9 <printf>
     225:	83 c4 10             	add    $0x10,%esp
     228:	b8 00 00 00 00       	mov    $0x0,%eax
     22d:	e9 a6 01 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    check(chgrp(cmd[0], testperms[i][filegid]));
     232:	8b 45 f4             	mov    -0xc(%ebp),%eax
     235:	c1 e0 04             	shl    $0x4,%eax
     238:	05 4c 26 00 00       	add    $0x264c,%eax
     23d:	8b 10                	mov    (%eax),%edx
     23f:	8b 45 08             	mov    0x8(%ebp),%eax
     242:	8b 00                	mov    (%eax),%eax
     244:	83 ec 08             	sub    $0x8,%esp
     247:	52                   	push   %edx
     248:	50                   	push   %eax
     249:	e8 9c 12 00 00       	call   14ea <chgrp>
     24e:	83 c4 10             	add    $0x10,%esp
     251:	89 45 f0             	mov    %eax,-0x10(%ebp)
     254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     258:	74 21                	je     27b <doSetuidTest+0x190>
     25a:	83 ec 04             	sub    $0x4,%esp
     25d:	68 08 1b 00 00       	push   $0x1b08
     262:	68 90 19 00 00       	push   $0x1990
     267:	6a 02                	push   $0x2
     269:	e8 5b 13 00 00       	call   15c9 <printf>
     26e:	83 c4 10             	add    $0x10,%esp
     271:	b8 00 00 00 00       	mov    $0x0,%eax
     276:	e9 5d 01 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "File uid: %d, gid: %d\n",
     27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     27e:	c1 e0 04             	shl    $0x4,%eax
     281:	05 4c 26 00 00       	add    $0x264c,%eax
     286:	8b 10                	mov    (%eax),%edx
     288:	8b 45 f4             	mov    -0xc(%ebp),%eax
     28b:	c1 e0 04             	shl    $0x4,%eax
     28e:	05 48 26 00 00       	add    $0x2648,%eax
     293:	8b 00                	mov    (%eax),%eax
     295:	52                   	push   %edx
     296:	50                   	push   %eax
     297:	68 2d 1b 00 00       	push   $0x1b2d
     29c:	6a 01                	push   $0x1
     29e:	e8 26 13 00 00       	call   15c9 <printf>
     2a3:	83 c4 10             	add    $0x10,%esp
		    testperms[i][fileuid], testperms[i][filegid]);
    check(chmod(cmd[0], perms[i]));
     2a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2a9:	8b 14 85 24 26 00 00 	mov    0x2624(,%eax,4),%edx
     2b0:	8b 45 08             	mov    0x8(%ebp),%eax
     2b3:	8b 00                	mov    (%eax),%eax
     2b5:	83 ec 08             	sub    $0x8,%esp
     2b8:	52                   	push   %edx
     2b9:	50                   	push   %eax
     2ba:	e8 1b 12 00 00       	call   14da <chmod>
     2bf:	83 c4 10             	add    $0x10,%esp
     2c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     2c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2c9:	74 21                	je     2ec <doSetuidTest+0x201>
     2cb:	83 ec 04             	sub    $0x4,%esp
     2ce:	68 44 1b 00 00       	push   $0x1b44
     2d3:	68 90 19 00 00       	push   $0x1990
     2d8:	6a 02                	push   $0x2
     2da:	e8 ea 12 00 00       	call   15c9 <printf>
     2df:	83 c4 10             	add    $0x10,%esp
     2e2:	b8 00 00 00 00       	mov    $0x0,%eax
     2e7:	e9 ec 00 00 00       	jmp    3d8 <doSetuidTest+0x2ed>
    printf(1, "perms set to %d for %s\n", perms[i], cmd[0]);
     2ec:	8b 45 08             	mov    0x8(%ebp),%eax
     2ef:	8b 10                	mov    (%eax),%edx
     2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2f4:	8b 04 85 24 26 00 00 	mov    0x2624(,%eax,4),%eax
     2fb:	52                   	push   %edx
     2fc:	50                   	push   %eax
     2fd:	68 5c 1b 00 00       	push   $0x1b5c
     302:	6a 01                	push   $0x1
     304:	e8 c0 12 00 00       	call   15c9 <printf>
     309:	83 c4 10             	add    $0x10,%esp

    rc = fork();
     30c:	e8 d9 10 00 00       	call   13ea <fork>
     311:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     314:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     318:	79 1c                	jns    336 <doSetuidTest+0x24b>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     31a:	83 ec 08             	sub    $0x8,%esp
     31d:	68 74 1b 00 00       	push   $0x1b74
     322:	6a 02                	push   $0x2
     324:	e8 a0 12 00 00       	call   15c9 <printf>
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
     348:	e8 dd 10 00 00       	call   142a <exec>
     34d:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     350:	a1 20 26 00 00       	mov    0x2620,%eax
     355:	83 e8 01             	sub    $0x1,%eax
     358:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     35b:	74 1a                	je     377 <doSetuidTest+0x28c>
     35d:	8b 45 08             	mov    0x8(%ebp),%eax
     360:	8b 00                	mov    (%eax),%eax
     362:	83 ec 04             	sub    $0x4,%esp
     365:	50                   	push   %eax
     366:	68 bc 1b 00 00       	push   $0x1bbc
     36b:	6a 02                	push   $0x2
     36d:	e8 57 12 00 00       	call   15c9 <printf>
     372:	83 c4 10             	add    $0x10,%esp
     375:	eb 18                	jmp    38f <doSetuidTest+0x2a4>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     377:	8b 45 08             	mov    0x8(%ebp),%eax
     37a:	8b 00                	mov    (%eax),%eax
     37c:	83 ec 04             	sub    $0x4,%esp
     37f:	50                   	push   %eax
     380:	68 e0 1b 00 00       	push   $0x1be0
     385:	6a 02                	push   $0x2
     387:	e8 3d 12 00 00       	call   15c9 <printf>
     38c:	83 c4 10             	add    $0x10,%esp
      exit();
     38f:	e8 5e 10 00 00       	call   13f2 <exit>
    }
    wait();
     394:	e8 61 10 00 00       	call   13fa <wait>
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};

  printf(1, "\nTesting the set uid bit.\n\n");

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     399:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     39d:	a1 20 26 00 00       	mov    0x2620,%eax
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
     3b9:	e8 1c 11 00 00       	call   14da <chmod>
     3be:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     3c1:	83 ec 08             	sub    $0x8,%esp
     3c4:	68 0d 1c 00 00       	push   $0x1c0d
     3c9:	6a 01                	push   $0x1
     3cb:	e8 f9 11 00 00       	call   15c9 <printf>
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
     402:	68 1a 1c 00 00       	push   $0x1c1a
     407:	6a 01                	push   $0x1
     409:	e8 bb 11 00 00       	call   15c9 <printf>
     40e:	83 c4 10             	add    $0x10,%esp

  startuid = uid = getuid();
     411:	e8 8c 10 00 00       	call   14a2 <getuid>
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
     430:	e8 85 10 00 00       	call   14ba <setuid>
     435:	83 c4 10             	add    $0x10,%esp
     438:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     43b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     43f:	74 1c                	je     45d <doUidTest+0x80>
    printf(2, "setuid system call reports an error.\n");
     441:	83 ec 08             	sub    $0x8,%esp
     444:	68 38 1c 00 00       	push   $0x1c38
     449:	6a 02                	push   $0x2
     44b:	e8 79 11 00 00       	call   15c9 <printf>
     450:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     453:	b8 00 00 00 00       	mov    $0x0,%eax
     458:	e9 07 01 00 00       	jmp    564 <doUidTest+0x187>
  }
  uid = getuid();
     45d:	e8 40 10 00 00       	call   14a2 <getuid>
     462:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (uid != testuid) {
     465:	8b 45 ec             	mov    -0x14(%ebp),%eax
     468:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     46b:	74 31                	je     49e <doUidTest+0xc1>
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
     46d:	83 ec 08             	sub    $0x8,%esp
     470:	68 60 1c 00 00       	push   $0x1c60
     475:	6a 02                	push   $0x2
     477:	e8 4d 11 00 00       	call   15c9 <printf>
     47c:	83 c4 10             	add    $0x10,%esp
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
     47f:	ff 75 ec             	pushl  -0x14(%ebp)
     482:	ff 75 e4             	pushl  -0x1c(%ebp)
     485:	68 98 1c 00 00       	push   $0x1c98
     48a:	6a 02                	push   $0x2
     48c:	e8 38 11 00 00       	call   15c9 <printf>
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
     4b5:	e8 00 10 00 00       	call   14ba <setuid>
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
     4d1:	68 bc 1c 00 00       	push   $0x1cbc
     4d6:	6a 02                	push   $0x2
     4d8:	e8 ec 10 00 00       	call   15c9 <printf>
     4dd:	83 c4 10             	add    $0x10,%esp
                      baduids[i], rc);
      return NOPASS;
     4e0:	b8 00 00 00 00       	mov    $0x0,%eax
     4e5:	eb 7d                	jmp    564 <doUidTest+0x187>
    }
    rc = getuid();
     4e7:	e8 b6 0f 00 00       	call   14a2 <getuid>
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
     506:	68 0c 1d 00 00       	push   $0x1d0c
     50b:	6a 02                	push   $0x2
     50d:	e8 b7 10 00 00       	call   15c9 <printf>
     512:	83 c4 10             	add    $0x10,%esp
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
     515:	83 ec 08             	sub    $0x8,%esp
     518:	68 54 1d 00 00       	push   $0x1d54
     51d:	6a 02                	push   $0x2
     51f:	e8 a5 10 00 00       	call   15c9 <printf>
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
     545:	e8 70 0f 00 00       	call   14ba <setuid>
     54a:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     54d:	83 ec 08             	sub    $0x8,%esp
     550:	68 0d 1c 00 00       	push   $0x1c0d
     555:	6a 01                	push   $0x1
     557:	e8 6d 10 00 00       	call   15c9 <printf>
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
     58b:	68 82 1d 00 00       	push   $0x1d82
     590:	6a 01                	push   $0x1
     592:	e8 32 10 00 00       	call   15c9 <printf>
     597:	83 c4 10             	add    $0x10,%esp

  startgid = gid = getgid();
     59a:	e8 0b 0f 00 00       	call   14aa <getgid>
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
     5b9:	e8 04 0f 00 00       	call   14c2 <setgid>
     5be:	83 c4 10             	add    $0x10,%esp
     5c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     5c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     5c8:	74 1c                	je     5e6 <doGidTest+0x80>
    printf(2, "setgid system call reports an error.\n");
     5ca:	83 ec 08             	sub    $0x8,%esp
     5cd:	68 a0 1d 00 00       	push   $0x1da0
     5d2:	6a 02                	push   $0x2
     5d4:	e8 f0 0f 00 00       	call   15c9 <printf>
     5d9:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     5dc:	b8 00 00 00 00       	mov    $0x0,%eax
     5e1:	e9 07 01 00 00       	jmp    6ed <doGidTest+0x187>
  }
  gid = getgid();
     5e6:	e8 bf 0e 00 00       	call   14aa <getgid>
     5eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (gid != testgid) {
     5ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     5f4:	74 31                	je     627 <doGidTest+0xc1>
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
     5f6:	83 ec 08             	sub    $0x8,%esp
     5f9:	68 c8 1d 00 00       	push   $0x1dc8
     5fe:	6a 02                	push   $0x2
     600:	e8 c4 0f 00 00       	call   15c9 <printf>
     605:	83 c4 10             	add    $0x10,%esp
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
     608:	ff 75 ec             	pushl  -0x14(%ebp)
     60b:	ff 75 e4             	pushl  -0x1c(%ebp)
     60e:	68 00 1e 00 00       	push   $0x1e00
     613:	6a 02                	push   $0x2
     615:	e8 af 0f 00 00       	call   15c9 <printf>
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
     63e:	e8 7f 0e 00 00       	call   14c2 <setgid>
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
     65a:	68 24 1e 00 00       	push   $0x1e24
     65f:	6a 02                	push   $0x2
     661:	e8 63 0f 00 00       	call   15c9 <printf>
     666:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      return NOPASS;
     669:	b8 00 00 00 00       	mov    $0x0,%eax
     66e:	eb 7d                	jmp    6ed <doGidTest+0x187>
    }
    rc = getgid();
     670:	e8 35 0e 00 00       	call   14aa <getgid>
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
     68f:	68 74 1e 00 00       	push   $0x1e74
     694:	6a 02                	push   $0x2
     696:	e8 2e 0f 00 00       	call   15c9 <printf>
     69b:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
     69e:	83 ec 08             	sub    $0x8,%esp
     6a1:	68 bc 1e 00 00       	push   $0x1ebc
     6a6:	6a 02                	push   $0x2
     6a8:	e8 1c 0f 00 00       	call   15c9 <printf>
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
     6ce:	e8 ef 0d 00 00       	call   14c2 <setgid>
     6d3:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     6d6:	83 ec 08             	sub    $0x8,%esp
     6d9:	68 0d 1c 00 00       	push   $0x1c0d
     6de:	6a 01                	push   $0x1
     6e0:	e8 e4 0e 00 00       	call   15c9 <printf>
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
     6f8:	68 ea 1e 00 00       	push   $0x1eea
     6fd:	6a 01                	push   $0x1
     6ff:	e8 c5 0e 00 00       	call   15c9 <printf>
     704:	83 c4 10             	add    $0x10,%esp

  check(stat(cmd[0], &st));
     707:	8b 45 08             	mov    0x8(%ebp),%eax
     70a:	8b 00                	mov    (%eax),%eax
     70c:	83 ec 08             	sub    $0x8,%esp
     70f:	8d 55 cc             	lea    -0x34(%ebp),%edx
     712:	52                   	push   %edx
     713:	50                   	push   %eax
     714:	e8 27 0b 00 00       	call   1240 <stat>
     719:	83 c4 10             	add    $0x10,%esp
     71c:	89 45 f0             	mov    %eax,-0x10(%ebp)
     71f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     723:	74 21                	je     746 <doChmodTest+0x57>
     725:	83 ec 04             	sub    $0x4,%esp
     728:	68 05 1f 00 00       	push   $0x1f05
     72d:	68 90 19 00 00       	push   $0x1990
     732:	6a 02                	push   $0x2
     734:	e8 90 0e 00 00       	call   15c9 <printf>
     739:	83 c4 10             	add    $0x10,%esp
     73c:	b8 00 00 00 00       	mov    $0x0,%eax
     741:	e9 01 01 00 00       	jmp    847 <doChmodTest+0x158>
  mode = st.mode.as_int;
     746:	8b 45 e0             	mov    -0x20(%ebp),%eax
     749:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     74c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     753:	e9 b4 00 00 00       	jmp    80c <doChmodTest+0x11d>
    check(chmod(cmd[0], perms[i]));
     758:	8b 45 f4             	mov    -0xc(%ebp),%eax
     75b:	8b 14 85 24 26 00 00 	mov    0x2624(,%eax,4),%edx
     762:	8b 45 08             	mov    0x8(%ebp),%eax
     765:	8b 00                	mov    (%eax),%eax
     767:	83 ec 08             	sub    $0x8,%esp
     76a:	52                   	push   %edx
     76b:	50                   	push   %eax
     76c:	e8 69 0d 00 00       	call   14da <chmod>
     771:	83 c4 10             	add    $0x10,%esp
     774:	89 45 f0             	mov    %eax,-0x10(%ebp)
     777:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     77b:	74 21                	je     79e <doChmodTest+0xaf>
     77d:	83 ec 04             	sub    $0x4,%esp
     780:	68 44 1b 00 00       	push   $0x1b44
     785:	68 90 19 00 00       	push   $0x1990
     78a:	6a 02                	push   $0x2
     78c:	e8 38 0e 00 00       	call   15c9 <printf>
     791:	83 c4 10             	add    $0x10,%esp
     794:	b8 00 00 00 00       	mov    $0x0,%eax
     799:	e9 a9 00 00 00       	jmp    847 <doChmodTest+0x158>
    check(stat(cmd[0], &st));
     79e:	8b 45 08             	mov    0x8(%ebp),%eax
     7a1:	8b 00                	mov    (%eax),%eax
     7a3:	83 ec 08             	sub    $0x8,%esp
     7a6:	8d 55 cc             	lea    -0x34(%ebp),%edx
     7a9:	52                   	push   %edx
     7aa:	50                   	push   %eax
     7ab:	e8 90 0a 00 00       	call   1240 <stat>
     7b0:	83 c4 10             	add    $0x10,%esp
     7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7ba:	74 1e                	je     7da <doChmodTest+0xeb>
     7bc:	83 ec 04             	sub    $0x4,%esp
     7bf:	68 05 1f 00 00       	push   $0x1f05
     7c4:	68 90 19 00 00       	push   $0x1990
     7c9:	6a 02                	push   $0x2
     7cb:	e8 f9 0d 00 00       	call   15c9 <printf>
     7d0:	83 c4 10             	add    $0x10,%esp
     7d3:	b8 00 00 00 00       	mov    $0x0,%eax
     7d8:	eb 6d                	jmp    847 <doChmodTest+0x158>
    testmode = st.mode.as_int;
     7da:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (mode == testmode) { 
     7e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7e3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     7e6:	75 20                	jne    808 <doChmodTest+0x119>
      printf(2, "Error! chmod() failed to set permissions correctly. %s, %d\n",
     7e8:	68 b4 00 00 00       	push   $0xb4
     7ed:	68 17 1f 00 00       	push   $0x1f17
     7f2:	68 24 1f 00 00       	push   $0x1f24
     7f7:	6a 02                	push   $0x2
     7f9:	e8 cb 0d 00 00       	call   15c9 <printf>
     7fe:	83 c4 10             	add    $0x10,%esp
		      __FILE__, __LINE__);
      return NOPASS;
     801:	b8 00 00 00 00       	mov    $0x0,%eax
     806:	eb 3f                	jmp    847 <doChmodTest+0x158>
  printf(1, "\nExecuting chmod() test.\n\n");

  check(stat(cmd[0], &st));
  mode = st.mode.as_int;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     808:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     80c:	a1 20 26 00 00       	mov    0x2620,%eax
     811:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     814:	0f 8c 3e ff ff ff    	jl     758 <doChmodTest+0x69>
      printf(2, "Error! chmod() failed to set permissions correctly. %s, %d\n",
		      __FILE__, __LINE__);
      return NOPASS;
    }
  }
  chmod(cmd[0], 00755); // hack
     81a:	8b 45 08             	mov    0x8(%ebp),%eax
     81d:	8b 00                	mov    (%eax),%eax
     81f:	83 ec 08             	sub    $0x8,%esp
     822:	68 ed 01 00 00       	push   $0x1ed
     827:	50                   	push   %eax
     828:	e8 ad 0c 00 00       	call   14da <chmod>
     82d:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     830:	83 ec 08             	sub    $0x8,%esp
     833:	68 0d 1c 00 00       	push   $0x1c0d
     838:	6a 01                	push   $0x1
     83a:	e8 8a 0d 00 00       	call   15c9 <printf>
     83f:	83 c4 10             	add    $0x10,%esp
  return PASS;
     842:	b8 01 00 00 00       	mov    $0x1,%eax
}
     847:	c9                   	leave  
     848:	c3                   	ret    

00000849 <doChownTest>:

static int
doChownTest(char **cmd) 
{
     849:	55                   	push   %ebp
     84a:	89 e5                	mov    %esp,%ebp
     84c:	83 ec 38             	sub    $0x38,%esp
  int rc, uid1, uid2;
  struct stat st;

  printf(1, "\nExecuting chown test.\n\n");
     84f:	83 ec 08             	sub    $0x8,%esp
     852:	68 60 1f 00 00       	push   $0x1f60
     857:	6a 01                	push   $0x1
     859:	e8 6b 0d 00 00       	call   15c9 <printf>
     85e:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     861:	8b 45 08             	mov    0x8(%ebp),%eax
     864:	8b 00                	mov    (%eax),%eax
     866:	83 ec 08             	sub    $0x8,%esp
     869:	8d 55 d0             	lea    -0x30(%ebp),%edx
     86c:	52                   	push   %edx
     86d:	50                   	push   %eax
     86e:	e8 cd 09 00 00       	call   1240 <stat>
     873:	83 c4 10             	add    $0x10,%esp
  uid1 = st.uid;
     876:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
     87a:	0f b7 c0             	movzwl %ax,%eax
     87d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chown(cmd[0], uid1+1);
     880:	8b 45 f4             	mov    -0xc(%ebp),%eax
     883:	8d 50 01             	lea    0x1(%eax),%edx
     886:	8b 45 08             	mov    0x8(%ebp),%eax
     889:	8b 00                	mov    (%eax),%eax
     88b:	83 ec 08             	sub    $0x8,%esp
     88e:	52                   	push   %edx
     88f:	50                   	push   %eax
     890:	e8 4d 0c 00 00       	call   14e2 <chown>
     895:	83 c4 10             	add    $0x10,%esp
     898:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     89b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     89f:	74 1c                	je     8bd <doChownTest+0x74>
    printf(2, "Error! chown() failed on setting new owner. %d as rc.\n", rc);
     8a1:	83 ec 04             	sub    $0x4,%esp
     8a4:	ff 75 f0             	pushl  -0x10(%ebp)
     8a7:	68 7c 1f 00 00       	push   $0x1f7c
     8ac:	6a 02                	push   $0x2
     8ae:	e8 16 0d 00 00       	call   15c9 <printf>
     8b3:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     8b6:	b8 00 00 00 00       	mov    $0x0,%eax
     8bb:	eb 6e                	jmp    92b <doChownTest+0xe2>
  }

  stat(cmd[0], &st);
     8bd:	8b 45 08             	mov    0x8(%ebp),%eax
     8c0:	8b 00                	mov    (%eax),%eax
     8c2:	83 ec 08             	sub    $0x8,%esp
     8c5:	8d 55 d0             	lea    -0x30(%ebp),%edx
     8c8:	52                   	push   %edx
     8c9:	50                   	push   %eax
     8ca:	e8 71 09 00 00       	call   1240 <stat>
     8cf:	83 c4 10             	add    $0x10,%esp
  uid2 = st.uid;
     8d2:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
     8d6:	0f b7 c0             	movzwl %ax,%eax
     8d9:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (uid1 == uid2) {
     8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     8e2:	75 1c                	jne    900 <doChownTest+0xb7>
    printf(2, "Error! test failed. Old uid: %d, new uid: %d, should differ\n",
     8e4:	ff 75 ec             	pushl  -0x14(%ebp)
     8e7:	ff 75 f4             	pushl  -0xc(%ebp)
     8ea:	68 b4 1f 00 00       	push   $0x1fb4
     8ef:	6a 02                	push   $0x2
     8f1:	e8 d3 0c 00 00       	call   15c9 <printf>
     8f6:	83 c4 10             	add    $0x10,%esp
		    uid1, uid2);
    return NOPASS;
     8f9:	b8 00 00 00 00       	mov    $0x0,%eax
     8fe:	eb 2b                	jmp    92b <doChownTest+0xe2>
  }
  chown(cmd[0], uid1);  // put back the original
     900:	8b 45 08             	mov    0x8(%ebp),%eax
     903:	8b 00                	mov    (%eax),%eax
     905:	83 ec 08             	sub    $0x8,%esp
     908:	ff 75 f4             	pushl  -0xc(%ebp)
     90b:	50                   	push   %eax
     90c:	e8 d1 0b 00 00       	call   14e2 <chown>
     911:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     914:	83 ec 08             	sub    $0x8,%esp
     917:	68 0d 1c 00 00       	push   $0x1c0d
     91c:	6a 01                	push   $0x1
     91e:	e8 a6 0c 00 00       	call   15c9 <printf>
     923:	83 c4 10             	add    $0x10,%esp
  return PASS;
     926:	b8 01 00 00 00       	mov    $0x1,%eax
}
     92b:	c9                   	leave  
     92c:	c3                   	ret    

0000092d <doChgrpTest>:

static int
doChgrpTest(char **cmd) 
{
     92d:	55                   	push   %ebp
     92e:	89 e5                	mov    %esp,%ebp
     930:	83 ec 38             	sub    $0x38,%esp
  int rc, gid1, gid2;
  struct stat st;

  printf(1, "\nExecuting chgrp test.\n\n");
     933:	83 ec 08             	sub    $0x8,%esp
     936:	68 f1 1f 00 00       	push   $0x1ff1
     93b:	6a 01                	push   $0x1
     93d:	e8 87 0c 00 00       	call   15c9 <printf>
     942:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     945:	8b 45 08             	mov    0x8(%ebp),%eax
     948:	8b 00                	mov    (%eax),%eax
     94a:	83 ec 08             	sub    $0x8,%esp
     94d:	8d 55 d0             	lea    -0x30(%ebp),%edx
     950:	52                   	push   %edx
     951:	50                   	push   %eax
     952:	e8 e9 08 00 00       	call   1240 <stat>
     957:	83 c4 10             	add    $0x10,%esp
  gid1 = st.gid;
     95a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
     95e:	0f b7 c0             	movzwl %ax,%eax
     961:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chgrp(cmd[0], gid1+1);
     964:	8b 45 f4             	mov    -0xc(%ebp),%eax
     967:	8d 50 01             	lea    0x1(%eax),%edx
     96a:	8b 45 08             	mov    0x8(%ebp),%eax
     96d:	8b 00                	mov    (%eax),%eax
     96f:	83 ec 08             	sub    $0x8,%esp
     972:	52                   	push   %edx
     973:	50                   	push   %eax
     974:	e8 71 0b 00 00       	call   14ea <chgrp>
     979:	83 c4 10             	add    $0x10,%esp
     97c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     97f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     983:	74 19                	je     99e <doChgrpTest+0x71>
    printf(2, "Error! chgrp() failed on setting new group.\n");
     985:	83 ec 08             	sub    $0x8,%esp
     988:	68 0c 20 00 00       	push   $0x200c
     98d:	6a 02                	push   $0x2
     98f:	e8 35 0c 00 00       	call   15c9 <printf>
     994:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     997:	b8 00 00 00 00       	mov    $0x0,%eax
     99c:	eb 6e                	jmp    a0c <doChgrpTest+0xdf>
  }

  stat(cmd[0], &st);
     99e:	8b 45 08             	mov    0x8(%ebp),%eax
     9a1:	8b 00                	mov    (%eax),%eax
     9a3:	83 ec 08             	sub    $0x8,%esp
     9a6:	8d 55 d0             	lea    -0x30(%ebp),%edx
     9a9:	52                   	push   %edx
     9aa:	50                   	push   %eax
     9ab:	e8 90 08 00 00       	call   1240 <stat>
     9b0:	83 c4 10             	add    $0x10,%esp
  gid2 = st.gid;
     9b3:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
     9b7:	0f b7 c0             	movzwl %ax,%eax
     9ba:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (gid1 == gid2) {
     9bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     9c3:	75 1c                	jne    9e1 <doChgrpTest+0xb4>
    printf(2, "Error! test failed. Old gid: %d, new gid: gid2, should differ\n",
     9c5:	ff 75 ec             	pushl  -0x14(%ebp)
     9c8:	ff 75 f4             	pushl  -0xc(%ebp)
     9cb:	68 3c 20 00 00       	push   $0x203c
     9d0:	6a 02                	push   $0x2
     9d2:	e8 f2 0b 00 00       	call   15c9 <printf>
     9d7:	83 c4 10             	add    $0x10,%esp
                    gid1, gid2);
    return NOPASS;
     9da:	b8 00 00 00 00       	mov    $0x0,%eax
     9df:	eb 2b                	jmp    a0c <doChgrpTest+0xdf>
  }
  chgrp(cmd[0], gid1);  // put back the original
     9e1:	8b 45 08             	mov    0x8(%ebp),%eax
     9e4:	8b 00                	mov    (%eax),%eax
     9e6:	83 ec 08             	sub    $0x8,%esp
     9e9:	ff 75 f4             	pushl  -0xc(%ebp)
     9ec:	50                   	push   %eax
     9ed:	e8 f8 0a 00 00       	call   14ea <chgrp>
     9f2:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     9f5:	83 ec 08             	sub    $0x8,%esp
     9f8:	68 0d 1c 00 00       	push   $0x1c0d
     9fd:	6a 01                	push   $0x1
     9ff:	e8 c5 0b 00 00       	call   15c9 <printf>
     a04:	83 c4 10             	add    $0x10,%esp
  return PASS;
     a07:	b8 01 00 00 00       	mov    $0x1,%eax
}
     a0c:	c9                   	leave  
     a0d:	c3                   	ret    

00000a0e <doExecTest>:

static int
doExecTest(char **cmd) 
{
     a0e:	55                   	push   %ebp
     a0f:	89 e5                	mov    %esp,%ebp
     a11:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, gid;
  struct stat st;

  printf(1, "\nExecuting exec test.\n\n");
     a14:	83 ec 08             	sub    $0x8,%esp
     a17:	68 7b 20 00 00       	push   $0x207b
     a1c:	6a 01                	push   $0x1
     a1e:	e8 a6 0b 00 00       	call   15c9 <printf>
     a23:	83 c4 10             	add    $0x10,%esp

  if (!canRun(cmd[0])) {
     a26:	8b 45 08             	mov    0x8(%ebp),%eax
     a29:	8b 00                	mov    (%eax),%eax
     a2b:	83 ec 0c             	sub    $0xc,%esp
     a2e:	50                   	push   %eax
     a2f:	e8 cc f5 ff ff       	call   0 <canRun>
     a34:	83 c4 10             	add    $0x10,%esp
     a37:	85 c0                	test   %eax,%eax
     a39:	75 22                	jne    a5d <doExecTest+0x4f>
    printf(2, "Unable to run %s. test aborted.\n", cmd[0]);
     a3b:	8b 45 08             	mov    0x8(%ebp),%eax
     a3e:	8b 00                	mov    (%eax),%eax
     a40:	83 ec 04             	sub    $0x4,%esp
     a43:	50                   	push   %eax
     a44:	68 94 20 00 00       	push   $0x2094
     a49:	6a 02                	push   $0x2
     a4b:	e8 79 0b 00 00       	call   15c9 <printf>
     a50:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     a53:	b8 00 00 00 00       	mov    $0x0,%eax
     a58:	e9 e4 02 00 00       	jmp    d41 <doExecTest+0x333>
  }

  check(stat(cmd[0], &st));
     a5d:	8b 45 08             	mov    0x8(%ebp),%eax
     a60:	8b 00                	mov    (%eax),%eax
     a62:	83 ec 08             	sub    $0x8,%esp
     a65:	8d 55 cc             	lea    -0x34(%ebp),%edx
     a68:	52                   	push   %edx
     a69:	50                   	push   %eax
     a6a:	e8 d1 07 00 00       	call   1240 <stat>
     a6f:	83 c4 10             	add    $0x10,%esp
     a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a79:	74 21                	je     a9c <doExecTest+0x8e>
     a7b:	83 ec 04             	sub    $0x4,%esp
     a7e:	68 05 1f 00 00       	push   $0x1f05
     a83:	68 90 19 00 00       	push   $0x1990
     a88:	6a 02                	push   $0x2
     a8a:	e8 3a 0b 00 00       	call   15c9 <printf>
     a8f:	83 c4 10             	add    $0x10,%esp
     a92:	b8 00 00 00 00       	mov    $0x0,%eax
     a97:	e9 a5 02 00 00       	jmp    d41 <doExecTest+0x333>
  uid = st.uid;
     a9c:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
     aa0:	0f b7 c0             	movzwl %ax,%eax
     aa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  gid = st.gid;
     aa6:	0f b7 45 dc          	movzwl -0x24(%ebp),%eax
     aaa:	0f b7 c0             	movzwl %ax,%eax
     aad:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     ab0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ab7:	e9 22 02 00 00       	jmp    cde <doExecTest+0x2d0>
    check(setuid(testperms[i][procuid]));
     abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     abf:	c1 e0 04             	shl    $0x4,%eax
     ac2:	05 40 26 00 00       	add    $0x2640,%eax
     ac7:	8b 00                	mov    (%eax),%eax
     ac9:	83 ec 0c             	sub    $0xc,%esp
     acc:	50                   	push   %eax
     acd:	e8 e8 09 00 00       	call   14ba <setuid>
     ad2:	83 c4 10             	add    $0x10,%esp
     ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ad8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     adc:	74 21                	je     aff <doExecTest+0xf1>
     ade:	83 ec 04             	sub    $0x4,%esp
     ae1:	68 89 1a 00 00       	push   $0x1a89
     ae6:	68 90 19 00 00       	push   $0x1990
     aeb:	6a 02                	push   $0x2
     aed:	e8 d7 0a 00 00       	call   15c9 <printf>
     af2:	83 c4 10             	add    $0x10,%esp
     af5:	b8 00 00 00 00       	mov    $0x0,%eax
     afa:	e9 42 02 00 00       	jmp    d41 <doExecTest+0x333>
    check(setgid(testperms[i][procgid]));
     aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b02:	c1 e0 04             	shl    $0x4,%eax
     b05:	05 44 26 00 00       	add    $0x2644,%eax
     b0a:	8b 00                	mov    (%eax),%eax
     b0c:	83 ec 0c             	sub    $0xc,%esp
     b0f:	50                   	push   %eax
     b10:	e8 ad 09 00 00       	call   14c2 <setgid>
     b15:	83 c4 10             	add    $0x10,%esp
     b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b1f:	74 21                	je     b42 <doExecTest+0x134>
     b21:	83 ec 04             	sub    $0x4,%esp
     b24:	68 a7 1a 00 00       	push   $0x1aa7
     b29:	68 90 19 00 00       	push   $0x1990
     b2e:	6a 02                	push   $0x2
     b30:	e8 94 0a 00 00       	call   15c9 <printf>
     b35:	83 c4 10             	add    $0x10,%esp
     b38:	b8 00 00 00 00       	mov    $0x0,%eax
     b3d:	e9 ff 01 00 00       	jmp    d41 <doExecTest+0x333>
    check(chown(cmd[0], testperms[i][fileuid]));
     b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b45:	c1 e0 04             	shl    $0x4,%eax
     b48:	05 48 26 00 00       	add    $0x2648,%eax
     b4d:	8b 10                	mov    (%eax),%edx
     b4f:	8b 45 08             	mov    0x8(%ebp),%eax
     b52:	8b 00                	mov    (%eax),%eax
     b54:	83 ec 08             	sub    $0x8,%esp
     b57:	52                   	push   %edx
     b58:	50                   	push   %eax
     b59:	e8 84 09 00 00       	call   14e2 <chown>
     b5e:	83 c4 10             	add    $0x10,%esp
     b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b68:	74 21                	je     b8b <doExecTest+0x17d>
     b6a:	83 ec 04             	sub    $0x4,%esp
     b6d:	68 e0 1a 00 00       	push   $0x1ae0
     b72:	68 90 19 00 00       	push   $0x1990
     b77:	6a 02                	push   $0x2
     b79:	e8 4b 0a 00 00       	call   15c9 <printf>
     b7e:	83 c4 10             	add    $0x10,%esp
     b81:	b8 00 00 00 00       	mov    $0x0,%eax
     b86:	e9 b6 01 00 00       	jmp    d41 <doExecTest+0x333>
    check(chgrp(cmd[0], testperms[i][filegid]));
     b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b8e:	c1 e0 04             	shl    $0x4,%eax
     b91:	05 4c 26 00 00       	add    $0x264c,%eax
     b96:	8b 10                	mov    (%eax),%edx
     b98:	8b 45 08             	mov    0x8(%ebp),%eax
     b9b:	8b 00                	mov    (%eax),%eax
     b9d:	83 ec 08             	sub    $0x8,%esp
     ba0:	52                   	push   %edx
     ba1:	50                   	push   %eax
     ba2:	e8 43 09 00 00       	call   14ea <chgrp>
     ba7:	83 c4 10             	add    $0x10,%esp
     baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
     bad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bb1:	74 21                	je     bd4 <doExecTest+0x1c6>
     bb3:	83 ec 04             	sub    $0x4,%esp
     bb6:	68 08 1b 00 00       	push   $0x1b08
     bbb:	68 90 19 00 00       	push   $0x1990
     bc0:	6a 02                	push   $0x2
     bc2:	e8 02 0a 00 00       	call   15c9 <printf>
     bc7:	83 c4 10             	add    $0x10,%esp
     bca:	b8 00 00 00 00       	mov    $0x0,%eax
     bcf:	e9 6d 01 00 00       	jmp    d41 <doExecTest+0x333>
    check(chmod(cmd[0], perms[i]));
     bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bd7:	8b 14 85 24 26 00 00 	mov    0x2624(,%eax,4),%edx
     bde:	8b 45 08             	mov    0x8(%ebp),%eax
     be1:	8b 00                	mov    (%eax),%eax
     be3:	83 ec 08             	sub    $0x8,%esp
     be6:	52                   	push   %edx
     be7:	50                   	push   %eax
     be8:	e8 ed 08 00 00       	call   14da <chmod>
     bed:	83 c4 10             	add    $0x10,%esp
     bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
     bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bf7:	74 21                	je     c1a <doExecTest+0x20c>
     bf9:	83 ec 04             	sub    $0x4,%esp
     bfc:	68 44 1b 00 00       	push   $0x1b44
     c01:	68 90 19 00 00       	push   $0x1990
     c06:	6a 02                	push   $0x2
     c08:	e8 bc 09 00 00       	call   15c9 <printf>
     c0d:	83 c4 10             	add    $0x10,%esp
     c10:	b8 00 00 00 00       	mov    $0x0,%eax
     c15:	e9 27 01 00 00       	jmp    d41 <doExecTest+0x333>
    if (i != NUMPERMSTOCHECK-1)
     c1a:	a1 20 26 00 00       	mov    0x2620,%eax
     c1f:	83 e8 01             	sub    $0x1,%eax
     c22:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     c25:	74 14                	je     c3b <doExecTest+0x22d>
      printf(2, "The following test should not produce an error.\n");
     c27:	83 ec 08             	sub    $0x8,%esp
     c2a:	68 b8 20 00 00       	push   $0x20b8
     c2f:	6a 02                	push   $0x2
     c31:	e8 93 09 00 00       	call   15c9 <printf>
     c36:	83 c4 10             	add    $0x10,%esp
     c39:	eb 12                	jmp    c4d <doExecTest+0x23f>
    else
      printf(2, "The following test should fail.\n");
     c3b:	83 ec 08             	sub    $0x8,%esp
     c3e:	68 ec 20 00 00       	push   $0x20ec
     c43:	6a 02                	push   $0x2
     c45:	e8 7f 09 00 00       	call   15c9 <printf>
     c4a:	83 c4 10             	add    $0x10,%esp
    rc = fork();
     c4d:	e8 98 07 00 00       	call   13ea <fork>
     c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     c55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c59:	79 1c                	jns    c77 <doExecTest+0x269>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     c5b:	83 ec 08             	sub    $0x8,%esp
     c5e:	68 74 1b 00 00       	push   $0x1b74
     c63:	6a 02                	push   $0x2
     c65:	e8 5f 09 00 00       	call   15c9 <printf>
     c6a:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     c6d:	b8 00 00 00 00       	mov    $0x0,%eax
     c72:	e9 ca 00 00 00       	jmp    d41 <doExecTest+0x333>
    }
    if (rc == 0) {   // child
     c77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c7b:	75 58                	jne    cd5 <doExecTest+0x2c7>
      exec(cmd[0], cmd);
     c7d:	8b 45 08             	mov    0x8(%ebp),%eax
     c80:	8b 00                	mov    (%eax),%eax
     c82:	83 ec 08             	sub    $0x8,%esp
     c85:	ff 75 08             	pushl  0x8(%ebp)
     c88:	50                   	push   %eax
     c89:	e8 9c 07 00 00       	call   142a <exec>
     c8e:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     c91:	a1 20 26 00 00       	mov    0x2620,%eax
     c96:	83 e8 01             	sub    $0x1,%eax
     c99:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     c9c:	74 1a                	je     cb8 <doExecTest+0x2aa>
     c9e:	8b 45 08             	mov    0x8(%ebp),%eax
     ca1:	8b 00                	mov    (%eax),%eax
     ca3:	83 ec 04             	sub    $0x4,%esp
     ca6:	50                   	push   %eax
     ca7:	68 bc 1b 00 00       	push   $0x1bbc
     cac:	6a 02                	push   $0x2
     cae:	e8 16 09 00 00       	call   15c9 <printf>
     cb3:	83 c4 10             	add    $0x10,%esp
     cb6:	eb 18                	jmp    cd0 <doExecTest+0x2c2>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     cb8:	8b 45 08             	mov    0x8(%ebp),%eax
     cbb:	8b 00                	mov    (%eax),%eax
     cbd:	83 ec 04             	sub    $0x4,%esp
     cc0:	50                   	push   %eax
     cc1:	68 e0 1b 00 00       	push   $0x1be0
     cc6:	6a 02                	push   $0x2
     cc8:	e8 fc 08 00 00       	call   15c9 <printf>
     ccd:	83 c4 10             	add    $0x10,%esp
      exit();
     cd0:	e8 1d 07 00 00       	call   13f2 <exit>
    }
    wait();
     cd5:	e8 20 07 00 00       	call   13fa <wait>

  check(stat(cmd[0], &st));
  uid = st.uid;
  gid = st.gid;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     cda:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     cde:	a1 20 26 00 00       	mov    0x2620,%eax
     ce3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     ce6:	0f 8c d0 fd ff ff    	jl     abc <doExecTest+0xae>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chown(cmd[0], uid);
     cec:	8b 45 08             	mov    0x8(%ebp),%eax
     cef:	8b 00                	mov    (%eax),%eax
     cf1:	83 ec 08             	sub    $0x8,%esp
     cf4:	ff 75 ec             	pushl  -0x14(%ebp)
     cf7:	50                   	push   %eax
     cf8:	e8 e5 07 00 00       	call   14e2 <chown>
     cfd:	83 c4 10             	add    $0x10,%esp
  chgrp(cmd[0], gid);
     d00:	8b 45 08             	mov    0x8(%ebp),%eax
     d03:	8b 00                	mov    (%eax),%eax
     d05:	83 ec 08             	sub    $0x8,%esp
     d08:	ff 75 e8             	pushl  -0x18(%ebp)
     d0b:	50                   	push   %eax
     d0c:	e8 d9 07 00 00       	call   14ea <chgrp>
     d11:	83 c4 10             	add    $0x10,%esp
  chmod(cmd[0], 00755);
     d14:	8b 45 08             	mov    0x8(%ebp),%eax
     d17:	8b 00                	mov    (%eax),%eax
     d19:	83 ec 08             	sub    $0x8,%esp
     d1c:	68 ed 01 00 00       	push   $0x1ed
     d21:	50                   	push   %eax
     d22:	e8 b3 07 00 00       	call   14da <chmod>
     d27:	83 c4 10             	add    $0x10,%esp
  printf(1, "Requires user visually confirms PASS/FAIL\n");
     d2a:	83 ec 08             	sub    $0x8,%esp
     d2d:	68 10 21 00 00       	push   $0x2110
     d32:	6a 01                	push   $0x1
     d34:	e8 90 08 00 00       	call   15c9 <printf>
     d39:	83 c4 10             	add    $0x10,%esp
  return PASS;
     d3c:	b8 01 00 00 00       	mov    $0x1,%eax
}
     d41:	c9                   	leave  
     d42:	c3                   	ret    

00000d43 <printMenu>:

void
printMenu(void)
{
     d43:	55                   	push   %ebp
     d44:	89 e5                	mov    %esp,%ebp
     d46:	83 ec 18             	sub    $0x18,%esp
  int i = 0;
     d49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  printf(1, "\n");
     d50:	83 ec 08             	sub    $0x8,%esp
     d53:	68 3b 21 00 00       	push   $0x213b
     d58:	6a 01                	push   $0x1
     d5a:	e8 6a 08 00 00       	call   15c9 <printf>
     d5f:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exit program\n", i++);
     d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d65:	8d 50 01             	lea    0x1(%eax),%edx
     d68:	89 55 f4             	mov    %edx,-0xc(%ebp)
     d6b:	83 ec 04             	sub    $0x4,%esp
     d6e:	50                   	push   %eax
     d6f:	68 3d 21 00 00       	push   $0x213d
     d74:	6a 01                	push   $0x1
     d76:	e8 4e 08 00 00       	call   15c9 <printf>
     d7b:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc UID\n", i++);
     d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d81:	8d 50 01             	lea    0x1(%eax),%edx
     d84:	89 55 f4             	mov    %edx,-0xc(%ebp)
     d87:	83 ec 04             	sub    $0x4,%esp
     d8a:	50                   	push   %eax
     d8b:	68 4f 21 00 00       	push   $0x214f
     d90:	6a 01                	push   $0x1
     d92:	e8 32 08 00 00       	call   15c9 <printf>
     d97:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc GID\n", i++);
     d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d9d:	8d 50 01             	lea    0x1(%eax),%edx
     da0:	89 55 f4             	mov    %edx,-0xc(%ebp)
     da3:	83 ec 04             	sub    $0x4,%esp
     da6:	50                   	push   %eax
     da7:	68 5d 21 00 00       	push   $0x215d
     dac:	6a 01                	push   $0x1
     dae:	e8 16 08 00 00       	call   15c9 <printf>
     db3:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chmod()\n", i++);
     db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     db9:	8d 50 01             	lea    0x1(%eax),%edx
     dbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dbf:	83 ec 04             	sub    $0x4,%esp
     dc2:	50                   	push   %eax
     dc3:	68 6b 21 00 00       	push   $0x216b
     dc8:	6a 01                	push   $0x1
     dca:	e8 fa 07 00 00       	call   15c9 <printf>
     dcf:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chown()\n", i++);
     dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dd5:	8d 50 01             	lea    0x1(%eax),%edx
     dd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ddb:	83 ec 04             	sub    $0x4,%esp
     dde:	50                   	push   %eax
     ddf:	68 78 21 00 00       	push   $0x2178
     de4:	6a 01                	push   $0x1
     de6:	e8 de 07 00 00       	call   15c9 <printf>
     deb:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chgrp()\n", i++);
     dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df1:	8d 50 01             	lea    0x1(%eax),%edx
     df4:	89 55 f4             	mov    %edx,-0xc(%ebp)
     df7:	83 ec 04             	sub    $0x4,%esp
     dfa:	50                   	push   %eax
     dfb:	68 85 21 00 00       	push   $0x2185
     e00:	6a 01                	push   $0x1
     e02:	e8 c2 07 00 00       	call   15c9 <printf>
     e07:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exec()\n", i++);
     e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e0d:	8d 50 01             	lea    0x1(%eax),%edx
     e10:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e13:	83 ec 04             	sub    $0x4,%esp
     e16:	50                   	push   %eax
     e17:	68 92 21 00 00       	push   $0x2192
     e1c:	6a 01                	push   $0x1
     e1e:	e8 a6 07 00 00       	call   15c9 <printf>
     e23:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. setuid\n", i++);
     e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e29:	8d 50 01             	lea    0x1(%eax),%edx
     e2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e2f:	83 ec 04             	sub    $0x4,%esp
     e32:	50                   	push   %eax
     e33:	68 9e 21 00 00       	push   $0x219e
     e38:	6a 01                	push   $0x1
     e3a:	e8 8a 07 00 00       	call   15c9 <printf>
     e3f:	83 c4 10             	add    $0x10,%esp
}
     e42:	90                   	nop
     e43:	c9                   	leave  
     e44:	c3                   	ret    

00000e45 <main>:

int
main(int argc, char *argv[])
{
     e45:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     e49:	83 e4 f0             	and    $0xfffffff0,%esp
     e4c:	ff 71 fc             	pushl  -0x4(%ecx)
     e4f:	55                   	push   %ebp
     e50:	89 e5                	mov    %esp,%ebp
     e52:	51                   	push   %ecx
     e53:	83 ec 24             	sub    $0x24,%esp
  int rc, select, done;
  char buf[5];

  // test strings
  char *t0[] = {'\0'}; // dummy
     e56:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  char *t1[] = {"testsetuid", '\0'};
     e5d:	c7 45 d8 aa 21 00 00 	movl   $0x21aa,-0x28(%ebp)
     e64:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

  while (1) {
    done = FALSE;
     e6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    printMenu();
     e72:	e8 cc fe ff ff       	call   d43 <printMenu>
    printf(1, "Enter test number: ");
     e77:	83 ec 08             	sub    $0x8,%esp
     e7a:	68 b5 21 00 00       	push   $0x21b5
     e7f:	6a 01                	push   $0x1
     e81:	e8 43 07 00 00       	call   15c9 <printf>
     e86:	83 c4 10             	add    $0x10,%esp
    gets(buf, 5);
     e89:	83 ec 08             	sub    $0x8,%esp
     e8c:	6a 05                	push   $0x5
     e8e:	8d 45 e7             	lea    -0x19(%ebp),%eax
     e91:	50                   	push   %eax
     e92:	e8 3a 03 00 00       	call   11d1 <gets>
     e97:	83 c4 10             	add    $0x10,%esp
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
     e9a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     e9e:	3c 0a                	cmp    $0xa,%al
     ea0:	0f 84 f5 01 00 00    	je     109b <main+0x256>
     ea6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     eaa:	84 c0                	test   %al,%al
     eac:	0f 84 e9 01 00 00    	je     109b <main+0x256>
    select = atoi(buf);
     eb2:	83 ec 0c             	sub    $0xc,%esp
     eb5:	8d 45 e7             	lea    -0x19(%ebp),%eax
     eb8:	50                   	push   %eax
     eb9:	e8 cf 03 00 00       	call   128d <atoi>
     ebe:	83 c4 10             	add    $0x10,%esp
     ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch (select) {
     ec4:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
     ec8:	0f 87 9b 01 00 00    	ja     1069 <main+0x224>
     ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ed1:	c1 e0 02             	shl    $0x2,%eax
     ed4:	05 58 22 00 00       	add    $0x2258,%eax
     ed9:	8b 00                	mov    (%eax),%eax
     edb:	ff e0                	jmp    *%eax
	    case 0: done = TRUE; break;
     edd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     ee4:	e9 a7 01 00 00       	jmp    1090 <main+0x24b>
	    case 1: doTest(doUidTest,    t0); break;
     ee9:	83 ec 0c             	sub    $0xc,%esp
     eec:	8d 45 e0             	lea    -0x20(%ebp),%eax
     eef:	50                   	push   %eax
     ef0:	e8 e8 f4 ff ff       	call   3dd <doUidTest>
     ef5:	83 c4 10             	add    $0x10,%esp
     ef8:	89 45 ec             	mov    %eax,-0x14(%ebp)
     efb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     eff:	0f 85 78 01 00 00    	jne    107d <main+0x238>
     f05:	83 ec 04             	sub    $0x4,%esp
     f08:	68 c9 21 00 00       	push   $0x21c9
     f0d:	68 d3 21 00 00       	push   $0x21d3
     f12:	6a 02                	push   $0x2
     f14:	e8 b0 06 00 00       	call   15c9 <printf>
     f19:	83 c4 10             	add    $0x10,%esp
     f1c:	e8 d1 04 00 00       	call   13f2 <exit>
	    case 2: doTest(doGidTest,    t0); break;
     f21:	83 ec 0c             	sub    $0xc,%esp
     f24:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f27:	50                   	push   %eax
     f28:	e8 39 f6 ff ff       	call   566 <doGidTest>
     f2d:	83 c4 10             	add    $0x10,%esp
     f30:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f33:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f37:	0f 85 43 01 00 00    	jne    1080 <main+0x23b>
     f3d:	83 ec 04             	sub    $0x4,%esp
     f40:	68 e5 21 00 00       	push   $0x21e5
     f45:	68 d3 21 00 00       	push   $0x21d3
     f4a:	6a 02                	push   $0x2
     f4c:	e8 78 06 00 00       	call   15c9 <printf>
     f51:	83 c4 10             	add    $0x10,%esp
     f54:	e8 99 04 00 00       	call   13f2 <exit>
	    case 3: doTest(doChmodTest,  t1); break;
     f59:	83 ec 0c             	sub    $0xc,%esp
     f5c:	8d 45 d8             	lea    -0x28(%ebp),%eax
     f5f:	50                   	push   %eax
     f60:	e8 8a f7 ff ff       	call   6ef <doChmodTest>
     f65:	83 c4 10             	add    $0x10,%esp
     f68:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f6f:	0f 85 0e 01 00 00    	jne    1083 <main+0x23e>
     f75:	83 ec 04             	sub    $0x4,%esp
     f78:	68 ef 21 00 00       	push   $0x21ef
     f7d:	68 d3 21 00 00       	push   $0x21d3
     f82:	6a 02                	push   $0x2
     f84:	e8 40 06 00 00       	call   15c9 <printf>
     f89:	83 c4 10             	add    $0x10,%esp
     f8c:	e8 61 04 00 00       	call   13f2 <exit>
	    case 4: doTest(doChownTest,  t1); break;
     f91:	83 ec 0c             	sub    $0xc,%esp
     f94:	8d 45 d8             	lea    -0x28(%ebp),%eax
     f97:	50                   	push   %eax
     f98:	e8 ac f8 ff ff       	call   849 <doChownTest>
     f9d:	83 c4 10             	add    $0x10,%esp
     fa0:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fa3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fa7:	0f 85 d9 00 00 00    	jne    1086 <main+0x241>
     fad:	83 ec 04             	sub    $0x4,%esp
     fb0:	68 fb 21 00 00       	push   $0x21fb
     fb5:	68 d3 21 00 00       	push   $0x21d3
     fba:	6a 02                	push   $0x2
     fbc:	e8 08 06 00 00       	call   15c9 <printf>
     fc1:	83 c4 10             	add    $0x10,%esp
     fc4:	e8 29 04 00 00       	call   13f2 <exit>
	    case 5: doTest(doChgrpTest,  t1); break;
     fc9:	83 ec 0c             	sub    $0xc,%esp
     fcc:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fcf:	50                   	push   %eax
     fd0:	e8 58 f9 ff ff       	call   92d <doChgrpTest>
     fd5:	83 c4 10             	add    $0x10,%esp
     fd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fdf:	0f 85 a4 00 00 00    	jne    1089 <main+0x244>
     fe5:	83 ec 04             	sub    $0x4,%esp
     fe8:	68 07 22 00 00       	push   $0x2207
     fed:	68 d3 21 00 00       	push   $0x21d3
     ff2:	6a 02                	push   $0x2
     ff4:	e8 d0 05 00 00       	call   15c9 <printf>
     ff9:	83 c4 10             	add    $0x10,%esp
     ffc:	e8 f1 03 00 00       	call   13f2 <exit>
	    case 6: doTest(doExecTest,   t1); break;
    1001:	83 ec 0c             	sub    $0xc,%esp
    1004:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1007:	50                   	push   %eax
    1008:	e8 01 fa ff ff       	call   a0e <doExecTest>
    100d:	83 c4 10             	add    $0x10,%esp
    1010:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1013:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1017:	75 73                	jne    108c <main+0x247>
    1019:	83 ec 04             	sub    $0x4,%esp
    101c:	68 13 22 00 00       	push   $0x2213
    1021:	68 d3 21 00 00       	push   $0x21d3
    1026:	6a 02                	push   $0x2
    1028:	e8 9c 05 00 00       	call   15c9 <printf>
    102d:	83 c4 10             	add    $0x10,%esp
    1030:	e8 bd 03 00 00       	call   13f2 <exit>
	    case 7: doTest(doSetuidTest, t1); break;
    1035:	83 ec 0c             	sub    $0xc,%esp
    1038:	8d 45 d8             	lea    -0x28(%ebp),%eax
    103b:	50                   	push   %eax
    103c:	e8 aa f0 ff ff       	call   eb <doSetuidTest>
    1041:	83 c4 10             	add    $0x10,%esp
    1044:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1047:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    104b:	75 42                	jne    108f <main+0x24a>
    104d:	83 ec 04             	sub    $0x4,%esp
    1050:	68 1e 22 00 00       	push   $0x221e
    1055:	68 d3 21 00 00       	push   $0x21d3
    105a:	6a 02                	push   $0x2
    105c:	e8 68 05 00 00       	call   15c9 <printf>
    1061:	83 c4 10             	add    $0x10,%esp
    1064:	e8 89 03 00 00       	call   13f2 <exit>
	    default:
		   printf(1, "Error:invalid test number.\n");
    1069:	83 ec 08             	sub    $0x8,%esp
    106c:	68 2b 22 00 00       	push   $0x222b
    1071:	6a 01                	push   $0x1
    1073:	e8 51 05 00 00       	call   15c9 <printf>
    1078:	83 c4 10             	add    $0x10,%esp
    107b:	eb 13                	jmp    1090 <main+0x24b>
    gets(buf, 5);
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    select = atoi(buf);
    switch (select) {
	    case 0: done = TRUE; break;
	    case 1: doTest(doUidTest,    t0); break;
    107d:	90                   	nop
    107e:	eb 10                	jmp    1090 <main+0x24b>
	    case 2: doTest(doGidTest,    t0); break;
    1080:	90                   	nop
    1081:	eb 0d                	jmp    1090 <main+0x24b>
	    case 3: doTest(doChmodTest,  t1); break;
    1083:	90                   	nop
    1084:	eb 0a                	jmp    1090 <main+0x24b>
	    case 4: doTest(doChownTest,  t1); break;
    1086:	90                   	nop
    1087:	eb 07                	jmp    1090 <main+0x24b>
	    case 5: doTest(doChgrpTest,  t1); break;
    1089:	90                   	nop
    108a:	eb 04                	jmp    1090 <main+0x24b>
	    case 6: doTest(doExecTest,   t1); break;
    108c:	90                   	nop
    108d:	eb 01                	jmp    1090 <main+0x24b>
	    case 7: doTest(doSetuidTest, t1); break;
    108f:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    1090:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1094:	75 0b                	jne    10a1 <main+0x25c>
    1096:	e9 d0 fd ff ff       	jmp    e6b <main+0x26>
  while (1) {
    done = FALSE;
    printMenu();
    printf(1, "Enter test number: ");
    gets(buf, 5);
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    109b:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
  }
    109c:	e9 ca fd ff ff       	jmp    e6b <main+0x26>
	    case 7: doTest(doSetuidTest, t1); break;
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10a1:	90                   	nop
  }

  printf(1, "\nDone for now\n");
    10a2:	83 ec 08             	sub    $0x8,%esp
    10a5:	68 47 22 00 00       	push   $0x2247
    10aa:	6a 01                	push   $0x1
    10ac:	e8 18 05 00 00       	call   15c9 <printf>
    10b1:	83 c4 10             	add    $0x10,%esp
  free(buf);
    10b4:	83 ec 0c             	sub    $0xc,%esp
    10b7:	8d 45 e7             	lea    -0x19(%ebp),%eax
    10ba:	50                   	push   %eax
    10bb:	e8 9a 06 00 00       	call   175a <free>
    10c0:	83 c4 10             	add    $0x10,%esp
  exit();
    10c3:	e8 2a 03 00 00       	call   13f2 <exit>

000010c8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10c8:	55                   	push   %ebp
    10c9:	89 e5                	mov    %esp,%ebp
    10cb:	57                   	push   %edi
    10cc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    10cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10d0:	8b 55 10             	mov    0x10(%ebp),%edx
    10d3:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d6:	89 cb                	mov    %ecx,%ebx
    10d8:	89 df                	mov    %ebx,%edi
    10da:	89 d1                	mov    %edx,%ecx
    10dc:	fc                   	cld    
    10dd:	f3 aa                	rep stos %al,%es:(%edi)
    10df:	89 ca                	mov    %ecx,%edx
    10e1:	89 fb                	mov    %edi,%ebx
    10e3:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10e6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10e9:	90                   	nop
    10ea:	5b                   	pop    %ebx
    10eb:	5f                   	pop    %edi
    10ec:	5d                   	pop    %ebp
    10ed:	c3                   	ret    

000010ee <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10ee:	55                   	push   %ebp
    10ef:	89 e5                	mov    %esp,%ebp
    10f1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10f4:	8b 45 08             	mov    0x8(%ebp),%eax
    10f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10fa:	90                   	nop
    10fb:	8b 45 08             	mov    0x8(%ebp),%eax
    10fe:	8d 50 01             	lea    0x1(%eax),%edx
    1101:	89 55 08             	mov    %edx,0x8(%ebp)
    1104:	8b 55 0c             	mov    0xc(%ebp),%edx
    1107:	8d 4a 01             	lea    0x1(%edx),%ecx
    110a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    110d:	0f b6 12             	movzbl (%edx),%edx
    1110:	88 10                	mov    %dl,(%eax)
    1112:	0f b6 00             	movzbl (%eax),%eax
    1115:	84 c0                	test   %al,%al
    1117:	75 e2                	jne    10fb <strcpy+0xd>
    ;
  return os;
    1119:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    111c:	c9                   	leave  
    111d:	c3                   	ret    

0000111e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    111e:	55                   	push   %ebp
    111f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1121:	eb 08                	jmp    112b <strcmp+0xd>
    p++, q++;
    1123:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1127:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    112b:	8b 45 08             	mov    0x8(%ebp),%eax
    112e:	0f b6 00             	movzbl (%eax),%eax
    1131:	84 c0                	test   %al,%al
    1133:	74 10                	je     1145 <strcmp+0x27>
    1135:	8b 45 08             	mov    0x8(%ebp),%eax
    1138:	0f b6 10             	movzbl (%eax),%edx
    113b:	8b 45 0c             	mov    0xc(%ebp),%eax
    113e:	0f b6 00             	movzbl (%eax),%eax
    1141:	38 c2                	cmp    %al,%dl
    1143:	74 de                	je     1123 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1145:	8b 45 08             	mov    0x8(%ebp),%eax
    1148:	0f b6 00             	movzbl (%eax),%eax
    114b:	0f b6 d0             	movzbl %al,%edx
    114e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1151:	0f b6 00             	movzbl (%eax),%eax
    1154:	0f b6 c0             	movzbl %al,%eax
    1157:	29 c2                	sub    %eax,%edx
    1159:	89 d0                	mov    %edx,%eax
}
    115b:	5d                   	pop    %ebp
    115c:	c3                   	ret    

0000115d <strlen>:

uint
strlen(char *s)
{
    115d:	55                   	push   %ebp
    115e:	89 e5                	mov    %esp,%ebp
    1160:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    116a:	eb 04                	jmp    1170 <strlen+0x13>
    116c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1170:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1173:	8b 45 08             	mov    0x8(%ebp),%eax
    1176:	01 d0                	add    %edx,%eax
    1178:	0f b6 00             	movzbl (%eax),%eax
    117b:	84 c0                	test   %al,%al
    117d:	75 ed                	jne    116c <strlen+0xf>
    ;
  return n;
    117f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1182:	c9                   	leave  
    1183:	c3                   	ret    

00001184 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1184:	55                   	push   %ebp
    1185:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    1187:	8b 45 10             	mov    0x10(%ebp),%eax
    118a:	50                   	push   %eax
    118b:	ff 75 0c             	pushl  0xc(%ebp)
    118e:	ff 75 08             	pushl  0x8(%ebp)
    1191:	e8 32 ff ff ff       	call   10c8 <stosb>
    1196:	83 c4 0c             	add    $0xc,%esp
  return dst;
    1199:	8b 45 08             	mov    0x8(%ebp),%eax
}
    119c:	c9                   	leave  
    119d:	c3                   	ret    

0000119e <strchr>:

char*
strchr(const char *s, char c)
{
    119e:	55                   	push   %ebp
    119f:	89 e5                	mov    %esp,%ebp
    11a1:	83 ec 04             	sub    $0x4,%esp
    11a4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11aa:	eb 14                	jmp    11c0 <strchr+0x22>
    if(*s == c)
    11ac:	8b 45 08             	mov    0x8(%ebp),%eax
    11af:	0f b6 00             	movzbl (%eax),%eax
    11b2:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11b5:	75 05                	jne    11bc <strchr+0x1e>
      return (char*)s;
    11b7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ba:	eb 13                	jmp    11cf <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    11bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11c0:	8b 45 08             	mov    0x8(%ebp),%eax
    11c3:	0f b6 00             	movzbl (%eax),%eax
    11c6:	84 c0                	test   %al,%al
    11c8:	75 e2                	jne    11ac <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    11ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11cf:	c9                   	leave  
    11d0:	c3                   	ret    

000011d1 <gets>:

char*
gets(char *buf, int max)
{
    11d1:	55                   	push   %ebp
    11d2:	89 e5                	mov    %esp,%ebp
    11d4:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11de:	eb 42                	jmp    1222 <gets+0x51>
    cc = read(0, &c, 1);
    11e0:	83 ec 04             	sub    $0x4,%esp
    11e3:	6a 01                	push   $0x1
    11e5:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11e8:	50                   	push   %eax
    11e9:	6a 00                	push   $0x0
    11eb:	e8 1a 02 00 00       	call   140a <read>
    11f0:	83 c4 10             	add    $0x10,%esp
    11f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11fa:	7e 33                	jle    122f <gets+0x5e>
      break;
    buf[i++] = c;
    11fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ff:	8d 50 01             	lea    0x1(%eax),%edx
    1202:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1205:	89 c2                	mov    %eax,%edx
    1207:	8b 45 08             	mov    0x8(%ebp),%eax
    120a:	01 c2                	add    %eax,%edx
    120c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1210:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1212:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1216:	3c 0a                	cmp    $0xa,%al
    1218:	74 16                	je     1230 <gets+0x5f>
    121a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    121e:	3c 0d                	cmp    $0xd,%al
    1220:	74 0e                	je     1230 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1222:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1225:	83 c0 01             	add    $0x1,%eax
    1228:	3b 45 0c             	cmp    0xc(%ebp),%eax
    122b:	7c b3                	jl     11e0 <gets+0xf>
    122d:	eb 01                	jmp    1230 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    122f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1230:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1233:	8b 45 08             	mov    0x8(%ebp),%eax
    1236:	01 d0                	add    %edx,%eax
    1238:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    123b:	8b 45 08             	mov    0x8(%ebp),%eax
}
    123e:	c9                   	leave  
    123f:	c3                   	ret    

00001240 <stat>:

int
stat(char *n, struct stat *st)
{
    1240:	55                   	push   %ebp
    1241:	89 e5                	mov    %esp,%ebp
    1243:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1246:	83 ec 08             	sub    $0x8,%esp
    1249:	6a 00                	push   $0x0
    124b:	ff 75 08             	pushl  0x8(%ebp)
    124e:	e8 df 01 00 00       	call   1432 <open>
    1253:	83 c4 10             	add    $0x10,%esp
    1256:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    125d:	79 07                	jns    1266 <stat+0x26>
    return -1;
    125f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1264:	eb 25                	jmp    128b <stat+0x4b>
  r = fstat(fd, st);
    1266:	83 ec 08             	sub    $0x8,%esp
    1269:	ff 75 0c             	pushl  0xc(%ebp)
    126c:	ff 75 f4             	pushl  -0xc(%ebp)
    126f:	e8 d6 01 00 00       	call   144a <fstat>
    1274:	83 c4 10             	add    $0x10,%esp
    1277:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    127a:	83 ec 0c             	sub    $0xc,%esp
    127d:	ff 75 f4             	pushl  -0xc(%ebp)
    1280:	e8 95 01 00 00       	call   141a <close>
    1285:	83 c4 10             	add    $0x10,%esp
  return r;
    1288:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    128b:	c9                   	leave  
    128c:	c3                   	ret    

0000128d <atoi>:

int
atoi(const char *s)
{
    128d:	55                   	push   %ebp
    128e:	89 e5                	mov    %esp,%ebp
    1290:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    1293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
    129a:	eb 04                	jmp    12a0 <atoi+0x13>
    129c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12a0:	8b 45 08             	mov    0x8(%ebp),%eax
    12a3:	0f b6 00             	movzbl (%eax),%eax
    12a6:	3c 20                	cmp    $0x20,%al
    12a8:	74 f2                	je     129c <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
    12aa:	8b 45 08             	mov    0x8(%ebp),%eax
    12ad:	0f b6 00             	movzbl (%eax),%eax
    12b0:	3c 2d                	cmp    $0x2d,%al
    12b2:	75 07                	jne    12bb <atoi+0x2e>
    12b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12b9:	eb 05                	jmp    12c0 <atoi+0x33>
    12bb:	b8 01 00 00 00       	mov    $0x1,%eax
    12c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    12c3:	8b 45 08             	mov    0x8(%ebp),%eax
    12c6:	0f b6 00             	movzbl (%eax),%eax
    12c9:	3c 2b                	cmp    $0x2b,%al
    12cb:	74 0a                	je     12d7 <atoi+0x4a>
    12cd:	8b 45 08             	mov    0x8(%ebp),%eax
    12d0:	0f b6 00             	movzbl (%eax),%eax
    12d3:	3c 2d                	cmp    $0x2d,%al
    12d5:	75 2b                	jne    1302 <atoi+0x75>
    s++;
    12d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
    12db:	eb 25                	jmp    1302 <atoi+0x75>
    n = n*10 + *s++ - '0';
    12dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12e0:	89 d0                	mov    %edx,%eax
    12e2:	c1 e0 02             	shl    $0x2,%eax
    12e5:	01 d0                	add    %edx,%eax
    12e7:	01 c0                	add    %eax,%eax
    12e9:	89 c1                	mov    %eax,%ecx
    12eb:	8b 45 08             	mov    0x8(%ebp),%eax
    12ee:	8d 50 01             	lea    0x1(%eax),%edx
    12f1:	89 55 08             	mov    %edx,0x8(%ebp)
    12f4:	0f b6 00             	movzbl (%eax),%eax
    12f7:	0f be c0             	movsbl %al,%eax
    12fa:	01 c8                	add    %ecx,%eax
    12fc:	83 e8 30             	sub    $0x30,%eax
    12ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
    1302:	8b 45 08             	mov    0x8(%ebp),%eax
    1305:	0f b6 00             	movzbl (%eax),%eax
    1308:	3c 2f                	cmp    $0x2f,%al
    130a:	7e 0a                	jle    1316 <atoi+0x89>
    130c:	8b 45 08             	mov    0x8(%ebp),%eax
    130f:	0f b6 00             	movzbl (%eax),%eax
    1312:	3c 39                	cmp    $0x39,%al
    1314:	7e c7                	jle    12dd <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
    1316:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1319:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    131d:	c9                   	leave  
    131e:	c3                   	ret    

0000131f <atoo>:

int
atoo(const char *s)
{
    131f:	55                   	push   %ebp
    1320:	89 e5                	mov    %esp,%ebp
    1322:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    1325:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
    132c:	eb 04                	jmp    1332 <atoo+0x13>
    132e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1332:	8b 45 08             	mov    0x8(%ebp),%eax
    1335:	0f b6 00             	movzbl (%eax),%eax
    1338:	3c 20                	cmp    $0x20,%al
    133a:	74 f2                	je     132e <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
    133c:	8b 45 08             	mov    0x8(%ebp),%eax
    133f:	0f b6 00             	movzbl (%eax),%eax
    1342:	3c 2d                	cmp    $0x2d,%al
    1344:	75 07                	jne    134d <atoo+0x2e>
    1346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    134b:	eb 05                	jmp    1352 <atoo+0x33>
    134d:	b8 01 00 00 00       	mov    $0x1,%eax
    1352:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    1355:	8b 45 08             	mov    0x8(%ebp),%eax
    1358:	0f b6 00             	movzbl (%eax),%eax
    135b:	3c 2b                	cmp    $0x2b,%al
    135d:	74 0a                	je     1369 <atoo+0x4a>
    135f:	8b 45 08             	mov    0x8(%ebp),%eax
    1362:	0f b6 00             	movzbl (%eax),%eax
    1365:	3c 2d                	cmp    $0x2d,%al
    1367:	75 27                	jne    1390 <atoo+0x71>
    s++;
    1369:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
    136d:	eb 21                	jmp    1390 <atoo+0x71>
    n = n*8 + *s++ - '0';
    136f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1372:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
    1379:	8b 45 08             	mov    0x8(%ebp),%eax
    137c:	8d 50 01             	lea    0x1(%eax),%edx
    137f:	89 55 08             	mov    %edx,0x8(%ebp)
    1382:	0f b6 00             	movzbl (%eax),%eax
    1385:	0f be c0             	movsbl %al,%eax
    1388:	01 c8                	add    %ecx,%eax
    138a:	83 e8 30             	sub    $0x30,%eax
    138d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
    1390:	8b 45 08             	mov    0x8(%ebp),%eax
    1393:	0f b6 00             	movzbl (%eax),%eax
    1396:	3c 2f                	cmp    $0x2f,%al
    1398:	7e 0a                	jle    13a4 <atoo+0x85>
    139a:	8b 45 08             	mov    0x8(%ebp),%eax
    139d:	0f b6 00             	movzbl (%eax),%eax
    13a0:	3c 37                	cmp    $0x37,%al
    13a2:	7e cb                	jle    136f <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
    13a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13a7:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    13ab:	c9                   	leave  
    13ac:	c3                   	ret    

000013ad <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13ad:	55                   	push   %ebp
    13ae:	89 e5                	mov    %esp,%ebp
    13b0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    13b3:	8b 45 08             	mov    0x8(%ebp),%eax
    13b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    13b9:	8b 45 0c             	mov    0xc(%ebp),%eax
    13bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    13bf:	eb 17                	jmp    13d8 <memmove+0x2b>
    *dst++ = *src++;
    13c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13c4:	8d 50 01             	lea    0x1(%eax),%edx
    13c7:	89 55 fc             	mov    %edx,-0x4(%ebp)
    13ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
    13cd:	8d 4a 01             	lea    0x1(%edx),%ecx
    13d0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    13d3:	0f b6 12             	movzbl (%edx),%edx
    13d6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    13d8:	8b 45 10             	mov    0x10(%ebp),%eax
    13db:	8d 50 ff             	lea    -0x1(%eax),%edx
    13de:	89 55 10             	mov    %edx,0x10(%ebp)
    13e1:	85 c0                	test   %eax,%eax
    13e3:	7f dc                	jg     13c1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    13e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
    13e8:	c9                   	leave  
    13e9:	c3                   	ret    

000013ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13ea:	b8 01 00 00 00       	mov    $0x1,%eax
    13ef:	cd 40                	int    $0x40
    13f1:	c3                   	ret    

000013f2 <exit>:
SYSCALL(exit)
    13f2:	b8 02 00 00 00       	mov    $0x2,%eax
    13f7:	cd 40                	int    $0x40
    13f9:	c3                   	ret    

000013fa <wait>:
SYSCALL(wait)
    13fa:	b8 03 00 00 00       	mov    $0x3,%eax
    13ff:	cd 40                	int    $0x40
    1401:	c3                   	ret    

00001402 <pipe>:
SYSCALL(pipe)
    1402:	b8 04 00 00 00       	mov    $0x4,%eax
    1407:	cd 40                	int    $0x40
    1409:	c3                   	ret    

0000140a <read>:
SYSCALL(read)
    140a:	b8 05 00 00 00       	mov    $0x5,%eax
    140f:	cd 40                	int    $0x40
    1411:	c3                   	ret    

00001412 <write>:
SYSCALL(write)
    1412:	b8 10 00 00 00       	mov    $0x10,%eax
    1417:	cd 40                	int    $0x40
    1419:	c3                   	ret    

0000141a <close>:
SYSCALL(close)
    141a:	b8 15 00 00 00       	mov    $0x15,%eax
    141f:	cd 40                	int    $0x40
    1421:	c3                   	ret    

00001422 <kill>:
SYSCALL(kill)
    1422:	b8 06 00 00 00       	mov    $0x6,%eax
    1427:	cd 40                	int    $0x40
    1429:	c3                   	ret    

0000142a <exec>:
SYSCALL(exec)
    142a:	b8 07 00 00 00       	mov    $0x7,%eax
    142f:	cd 40                	int    $0x40
    1431:	c3                   	ret    

00001432 <open>:
SYSCALL(open)
    1432:	b8 0f 00 00 00       	mov    $0xf,%eax
    1437:	cd 40                	int    $0x40
    1439:	c3                   	ret    

0000143a <mknod>:
SYSCALL(mknod)
    143a:	b8 11 00 00 00       	mov    $0x11,%eax
    143f:	cd 40                	int    $0x40
    1441:	c3                   	ret    

00001442 <unlink>:
SYSCALL(unlink)
    1442:	b8 12 00 00 00       	mov    $0x12,%eax
    1447:	cd 40                	int    $0x40
    1449:	c3                   	ret    

0000144a <fstat>:
SYSCALL(fstat)
    144a:	b8 08 00 00 00       	mov    $0x8,%eax
    144f:	cd 40                	int    $0x40
    1451:	c3                   	ret    

00001452 <link>:
SYSCALL(link)
    1452:	b8 13 00 00 00       	mov    $0x13,%eax
    1457:	cd 40                	int    $0x40
    1459:	c3                   	ret    

0000145a <mkdir>:
SYSCALL(mkdir)
    145a:	b8 14 00 00 00       	mov    $0x14,%eax
    145f:	cd 40                	int    $0x40
    1461:	c3                   	ret    

00001462 <chdir>:
SYSCALL(chdir)
    1462:	b8 09 00 00 00       	mov    $0x9,%eax
    1467:	cd 40                	int    $0x40
    1469:	c3                   	ret    

0000146a <dup>:
SYSCALL(dup)
    146a:	b8 0a 00 00 00       	mov    $0xa,%eax
    146f:	cd 40                	int    $0x40
    1471:	c3                   	ret    

00001472 <getpid>:
SYSCALL(getpid)
    1472:	b8 0b 00 00 00       	mov    $0xb,%eax
    1477:	cd 40                	int    $0x40
    1479:	c3                   	ret    

0000147a <sbrk>:
SYSCALL(sbrk)
    147a:	b8 0c 00 00 00       	mov    $0xc,%eax
    147f:	cd 40                	int    $0x40
    1481:	c3                   	ret    

00001482 <sleep>:
SYSCALL(sleep)
    1482:	b8 0d 00 00 00       	mov    $0xd,%eax
    1487:	cd 40                	int    $0x40
    1489:	c3                   	ret    

0000148a <uptime>:
SYSCALL(uptime)
    148a:	b8 0e 00 00 00       	mov    $0xe,%eax
    148f:	cd 40                	int    $0x40
    1491:	c3                   	ret    

00001492 <halt>:
SYSCALL(halt)
    1492:	b8 16 00 00 00       	mov    $0x16,%eax
    1497:	cd 40                	int    $0x40
    1499:	c3                   	ret    

0000149a <date>:
SYSCALL(date)        #p1
    149a:	b8 17 00 00 00       	mov    $0x17,%eax
    149f:	cd 40                	int    $0x40
    14a1:	c3                   	ret    

000014a2 <getuid>:
SYSCALL(getuid)      #p2
    14a2:	b8 18 00 00 00       	mov    $0x18,%eax
    14a7:	cd 40                	int    $0x40
    14a9:	c3                   	ret    

000014aa <getgid>:
SYSCALL(getgid)      #p2
    14aa:	b8 19 00 00 00       	mov    $0x19,%eax
    14af:	cd 40                	int    $0x40
    14b1:	c3                   	ret    

000014b2 <getppid>:
SYSCALL(getppid)     #p2
    14b2:	b8 1a 00 00 00       	mov    $0x1a,%eax
    14b7:	cd 40                	int    $0x40
    14b9:	c3                   	ret    

000014ba <setuid>:
SYSCALL(setuid)      #p2
    14ba:	b8 1b 00 00 00       	mov    $0x1b,%eax
    14bf:	cd 40                	int    $0x40
    14c1:	c3                   	ret    

000014c2 <setgid>:
SYSCALL(setgid)      #p2
    14c2:	b8 1c 00 00 00       	mov    $0x1c,%eax
    14c7:	cd 40                	int    $0x40
    14c9:	c3                   	ret    

000014ca <getprocs>:
SYSCALL(getprocs)    #p2
    14ca:	b8 1d 00 00 00       	mov    $0x1d,%eax
    14cf:	cd 40                	int    $0x40
    14d1:	c3                   	ret    

000014d2 <setpriority>:
SYSCALL(setpriority) #p4
    14d2:	b8 1e 00 00 00       	mov    $0x1e,%eax
    14d7:	cd 40                	int    $0x40
    14d9:	c3                   	ret    

000014da <chmod>:
SYSCALL(chmod)       #p5
    14da:	b8 1f 00 00 00       	mov    $0x1f,%eax
    14df:	cd 40                	int    $0x40
    14e1:	c3                   	ret    

000014e2 <chown>:
SYSCALL(chown)       #p5
    14e2:	b8 20 00 00 00       	mov    $0x20,%eax
    14e7:	cd 40                	int    $0x40
    14e9:	c3                   	ret    

000014ea <chgrp>:
SYSCALL(chgrp)       #p5
    14ea:	b8 21 00 00 00       	mov    $0x21,%eax
    14ef:	cd 40                	int    $0x40
    14f1:	c3                   	ret    

000014f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14f2:	55                   	push   %ebp
    14f3:	89 e5                	mov    %esp,%ebp
    14f5:	83 ec 18             	sub    $0x18,%esp
    14f8:	8b 45 0c             	mov    0xc(%ebp),%eax
    14fb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14fe:	83 ec 04             	sub    $0x4,%esp
    1501:	6a 01                	push   $0x1
    1503:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1506:	50                   	push   %eax
    1507:	ff 75 08             	pushl  0x8(%ebp)
    150a:	e8 03 ff ff ff       	call   1412 <write>
    150f:	83 c4 10             	add    $0x10,%esp
}
    1512:	90                   	nop
    1513:	c9                   	leave  
    1514:	c3                   	ret    

00001515 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1515:	55                   	push   %ebp
    1516:	89 e5                	mov    %esp,%ebp
    1518:	53                   	push   %ebx
    1519:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    151c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1523:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1527:	74 17                	je     1540 <printint+0x2b>
    1529:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    152d:	79 11                	jns    1540 <printint+0x2b>
    neg = 1;
    152f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1536:	8b 45 0c             	mov    0xc(%ebp),%eax
    1539:	f7 d8                	neg    %eax
    153b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    153e:	eb 06                	jmp    1546 <printint+0x31>
  } else {
    x = xx;
    1540:	8b 45 0c             	mov    0xc(%ebp),%eax
    1543:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1546:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    154d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1550:	8d 41 01             	lea    0x1(%ecx),%eax
    1553:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1556:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1559:	8b 45 ec             	mov    -0x14(%ebp),%eax
    155c:	ba 00 00 00 00       	mov    $0x0,%edx
    1561:	f7 f3                	div    %ebx
    1563:	89 d0                	mov    %edx,%eax
    1565:	0f b6 80 80 26 00 00 	movzbl 0x2680(%eax),%eax
    156c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1570:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1573:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1576:	ba 00 00 00 00       	mov    $0x0,%edx
    157b:	f7 f3                	div    %ebx
    157d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1580:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1584:	75 c7                	jne    154d <printint+0x38>
  if(neg)
    1586:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    158a:	74 2d                	je     15b9 <printint+0xa4>
    buf[i++] = '-';
    158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158f:	8d 50 01             	lea    0x1(%eax),%edx
    1592:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1595:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    159a:	eb 1d                	jmp    15b9 <printint+0xa4>
    putc(fd, buf[i]);
    159c:	8d 55 dc             	lea    -0x24(%ebp),%edx
    159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a2:	01 d0                	add    %edx,%eax
    15a4:	0f b6 00             	movzbl (%eax),%eax
    15a7:	0f be c0             	movsbl %al,%eax
    15aa:	83 ec 08             	sub    $0x8,%esp
    15ad:	50                   	push   %eax
    15ae:	ff 75 08             	pushl  0x8(%ebp)
    15b1:	e8 3c ff ff ff       	call   14f2 <putc>
    15b6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    15b9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    15bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15c1:	79 d9                	jns    159c <printint+0x87>
    putc(fd, buf[i]);
}
    15c3:	90                   	nop
    15c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    15c7:	c9                   	leave  
    15c8:	c3                   	ret    

000015c9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15c9:	55                   	push   %ebp
    15ca:	89 e5                	mov    %esp,%ebp
    15cc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15d6:	8d 45 0c             	lea    0xc(%ebp),%eax
    15d9:	83 c0 04             	add    $0x4,%eax
    15dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    15df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15e6:	e9 59 01 00 00       	jmp    1744 <printf+0x17b>
    c = fmt[i] & 0xff;
    15eb:	8b 55 0c             	mov    0xc(%ebp),%edx
    15ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f1:	01 d0                	add    %edx,%eax
    15f3:	0f b6 00             	movzbl (%eax),%eax
    15f6:	0f be c0             	movsbl %al,%eax
    15f9:	25 ff 00 00 00       	and    $0xff,%eax
    15fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1605:	75 2c                	jne    1633 <printf+0x6a>
      if(c == '%'){
    1607:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    160b:	75 0c                	jne    1619 <printf+0x50>
        state = '%';
    160d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1614:	e9 27 01 00 00       	jmp    1740 <printf+0x177>
      } else {
        putc(fd, c);
    1619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    161c:	0f be c0             	movsbl %al,%eax
    161f:	83 ec 08             	sub    $0x8,%esp
    1622:	50                   	push   %eax
    1623:	ff 75 08             	pushl  0x8(%ebp)
    1626:	e8 c7 fe ff ff       	call   14f2 <putc>
    162b:	83 c4 10             	add    $0x10,%esp
    162e:	e9 0d 01 00 00       	jmp    1740 <printf+0x177>
      }
    } else if(state == '%'){
    1633:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1637:	0f 85 03 01 00 00    	jne    1740 <printf+0x177>
      if(c == 'd'){
    163d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1641:	75 1e                	jne    1661 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1643:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1646:	8b 00                	mov    (%eax),%eax
    1648:	6a 01                	push   $0x1
    164a:	6a 0a                	push   $0xa
    164c:	50                   	push   %eax
    164d:	ff 75 08             	pushl  0x8(%ebp)
    1650:	e8 c0 fe ff ff       	call   1515 <printint>
    1655:	83 c4 10             	add    $0x10,%esp
        ap++;
    1658:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    165c:	e9 d8 00 00 00       	jmp    1739 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    1661:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1665:	74 06                	je     166d <printf+0xa4>
    1667:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    166b:	75 1e                	jne    168b <printf+0xc2>
        printint(fd, *ap, 16, 0);
    166d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1670:	8b 00                	mov    (%eax),%eax
    1672:	6a 00                	push   $0x0
    1674:	6a 10                	push   $0x10
    1676:	50                   	push   %eax
    1677:	ff 75 08             	pushl  0x8(%ebp)
    167a:	e8 96 fe ff ff       	call   1515 <printint>
    167f:	83 c4 10             	add    $0x10,%esp
        ap++;
    1682:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1686:	e9 ae 00 00 00       	jmp    1739 <printf+0x170>
      } else if(c == 's'){
    168b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    168f:	75 43                	jne    16d4 <printf+0x10b>
        s = (char*)*ap;
    1691:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1694:	8b 00                	mov    (%eax),%eax
    1696:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1699:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    169d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16a1:	75 25                	jne    16c8 <printf+0xff>
          s = "(null)";
    16a3:	c7 45 f4 78 22 00 00 	movl   $0x2278,-0xc(%ebp)
        while(*s != 0){
    16aa:	eb 1c                	jmp    16c8 <printf+0xff>
          putc(fd, *s);
    16ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16af:	0f b6 00             	movzbl (%eax),%eax
    16b2:	0f be c0             	movsbl %al,%eax
    16b5:	83 ec 08             	sub    $0x8,%esp
    16b8:	50                   	push   %eax
    16b9:	ff 75 08             	pushl  0x8(%ebp)
    16bc:	e8 31 fe ff ff       	call   14f2 <putc>
    16c1:	83 c4 10             	add    $0x10,%esp
          s++;
    16c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    16c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16cb:	0f b6 00             	movzbl (%eax),%eax
    16ce:	84 c0                	test   %al,%al
    16d0:	75 da                	jne    16ac <printf+0xe3>
    16d2:	eb 65                	jmp    1739 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16d4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    16d8:	75 1d                	jne    16f7 <printf+0x12e>
        putc(fd, *ap);
    16da:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16dd:	8b 00                	mov    (%eax),%eax
    16df:	0f be c0             	movsbl %al,%eax
    16e2:	83 ec 08             	sub    $0x8,%esp
    16e5:	50                   	push   %eax
    16e6:	ff 75 08             	pushl  0x8(%ebp)
    16e9:	e8 04 fe ff ff       	call   14f2 <putc>
    16ee:	83 c4 10             	add    $0x10,%esp
        ap++;
    16f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16f5:	eb 42                	jmp    1739 <printf+0x170>
      } else if(c == '%'){
    16f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16fb:	75 17                	jne    1714 <printf+0x14b>
        putc(fd, c);
    16fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1700:	0f be c0             	movsbl %al,%eax
    1703:	83 ec 08             	sub    $0x8,%esp
    1706:	50                   	push   %eax
    1707:	ff 75 08             	pushl  0x8(%ebp)
    170a:	e8 e3 fd ff ff       	call   14f2 <putc>
    170f:	83 c4 10             	add    $0x10,%esp
    1712:	eb 25                	jmp    1739 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1714:	83 ec 08             	sub    $0x8,%esp
    1717:	6a 25                	push   $0x25
    1719:	ff 75 08             	pushl  0x8(%ebp)
    171c:	e8 d1 fd ff ff       	call   14f2 <putc>
    1721:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1727:	0f be c0             	movsbl %al,%eax
    172a:	83 ec 08             	sub    $0x8,%esp
    172d:	50                   	push   %eax
    172e:	ff 75 08             	pushl  0x8(%ebp)
    1731:	e8 bc fd ff ff       	call   14f2 <putc>
    1736:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1739:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1740:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1744:	8b 55 0c             	mov    0xc(%ebp),%edx
    1747:	8b 45 f0             	mov    -0x10(%ebp),%eax
    174a:	01 d0                	add    %edx,%eax
    174c:	0f b6 00             	movzbl (%eax),%eax
    174f:	84 c0                	test   %al,%al
    1751:	0f 85 94 fe ff ff    	jne    15eb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1757:	90                   	nop
    1758:	c9                   	leave  
    1759:	c3                   	ret    

0000175a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    175a:	55                   	push   %ebp
    175b:	89 e5                	mov    %esp,%ebp
    175d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1760:	8b 45 08             	mov    0x8(%ebp),%eax
    1763:	83 e8 08             	sub    $0x8,%eax
    1766:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1769:	a1 9c 26 00 00       	mov    0x269c,%eax
    176e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1771:	eb 24                	jmp    1797 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1773:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1776:	8b 00                	mov    (%eax),%eax
    1778:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    177b:	77 12                	ja     178f <free+0x35>
    177d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1780:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1783:	77 24                	ja     17a9 <free+0x4f>
    1785:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1788:	8b 00                	mov    (%eax),%eax
    178a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    178d:	77 1a                	ja     17a9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    178f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1792:	8b 00                	mov    (%eax),%eax
    1794:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1797:	8b 45 f8             	mov    -0x8(%ebp),%eax
    179a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    179d:	76 d4                	jbe    1773 <free+0x19>
    179f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a2:	8b 00                	mov    (%eax),%eax
    17a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17a7:	76 ca                	jbe    1773 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ac:	8b 40 04             	mov    0x4(%eax),%eax
    17af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17b9:	01 c2                	add    %eax,%edx
    17bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17be:	8b 00                	mov    (%eax),%eax
    17c0:	39 c2                	cmp    %eax,%edx
    17c2:	75 24                	jne    17e8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    17c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17c7:	8b 50 04             	mov    0x4(%eax),%edx
    17ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17cd:	8b 00                	mov    (%eax),%eax
    17cf:	8b 40 04             	mov    0x4(%eax),%eax
    17d2:	01 c2                	add    %eax,%edx
    17d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17d7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    17da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17dd:	8b 00                	mov    (%eax),%eax
    17df:	8b 10                	mov    (%eax),%edx
    17e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17e4:	89 10                	mov    %edx,(%eax)
    17e6:	eb 0a                	jmp    17f2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    17e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17eb:	8b 10                	mov    (%eax),%edx
    17ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17f0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    17f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17f5:	8b 40 04             	mov    0x4(%eax),%eax
    17f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1802:	01 d0                	add    %edx,%eax
    1804:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1807:	75 20                	jne    1829 <free+0xcf>
    p->s.size += bp->s.size;
    1809:	8b 45 fc             	mov    -0x4(%ebp),%eax
    180c:	8b 50 04             	mov    0x4(%eax),%edx
    180f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1812:	8b 40 04             	mov    0x4(%eax),%eax
    1815:	01 c2                	add    %eax,%edx
    1817:	8b 45 fc             	mov    -0x4(%ebp),%eax
    181a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    181d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1820:	8b 10                	mov    (%eax),%edx
    1822:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1825:	89 10                	mov    %edx,(%eax)
    1827:	eb 08                	jmp    1831 <free+0xd7>
  } else
    p->s.ptr = bp;
    1829:	8b 45 fc             	mov    -0x4(%ebp),%eax
    182c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    182f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1831:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1834:	a3 9c 26 00 00       	mov    %eax,0x269c
}
    1839:	90                   	nop
    183a:	c9                   	leave  
    183b:	c3                   	ret    

0000183c <morecore>:

static Header*
morecore(uint nu)
{
    183c:	55                   	push   %ebp
    183d:	89 e5                	mov    %esp,%ebp
    183f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1842:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1849:	77 07                	ja     1852 <morecore+0x16>
    nu = 4096;
    184b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1852:	8b 45 08             	mov    0x8(%ebp),%eax
    1855:	c1 e0 03             	shl    $0x3,%eax
    1858:	83 ec 0c             	sub    $0xc,%esp
    185b:	50                   	push   %eax
    185c:	e8 19 fc ff ff       	call   147a <sbrk>
    1861:	83 c4 10             	add    $0x10,%esp
    1864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1867:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    186b:	75 07                	jne    1874 <morecore+0x38>
    return 0;
    186d:	b8 00 00 00 00       	mov    $0x0,%eax
    1872:	eb 26                	jmp    189a <morecore+0x5e>
  hp = (Header*)p;
    1874:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1877:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    187a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    187d:	8b 55 08             	mov    0x8(%ebp),%edx
    1880:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1883:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1886:	83 c0 08             	add    $0x8,%eax
    1889:	83 ec 0c             	sub    $0xc,%esp
    188c:	50                   	push   %eax
    188d:	e8 c8 fe ff ff       	call   175a <free>
    1892:	83 c4 10             	add    $0x10,%esp
  return freep;
    1895:	a1 9c 26 00 00       	mov    0x269c,%eax
}
    189a:	c9                   	leave  
    189b:	c3                   	ret    

0000189c <malloc>:

void*
malloc(uint nbytes)
{
    189c:	55                   	push   %ebp
    189d:	89 e5                	mov    %esp,%ebp
    189f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18a2:	8b 45 08             	mov    0x8(%ebp),%eax
    18a5:	83 c0 07             	add    $0x7,%eax
    18a8:	c1 e8 03             	shr    $0x3,%eax
    18ab:	83 c0 01             	add    $0x1,%eax
    18ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18b1:	a1 9c 26 00 00       	mov    0x269c,%eax
    18b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18bd:	75 23                	jne    18e2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    18bf:	c7 45 f0 94 26 00 00 	movl   $0x2694,-0x10(%ebp)
    18c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18c9:	a3 9c 26 00 00       	mov    %eax,0x269c
    18ce:	a1 9c 26 00 00       	mov    0x269c,%eax
    18d3:	a3 94 26 00 00       	mov    %eax,0x2694
    base.s.size = 0;
    18d8:	c7 05 98 26 00 00 00 	movl   $0x0,0x2698
    18df:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e5:	8b 00                	mov    (%eax),%eax
    18e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    18ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ed:	8b 40 04             	mov    0x4(%eax),%eax
    18f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18f3:	72 4d                	jb     1942 <malloc+0xa6>
      if(p->s.size == nunits)
    18f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f8:	8b 40 04             	mov    0x4(%eax),%eax
    18fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18fe:	75 0c                	jne    190c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1900:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1903:	8b 10                	mov    (%eax),%edx
    1905:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1908:	89 10                	mov    %edx,(%eax)
    190a:	eb 26                	jmp    1932 <malloc+0x96>
      else {
        p->s.size -= nunits;
    190c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    190f:	8b 40 04             	mov    0x4(%eax),%eax
    1912:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1915:	89 c2                	mov    %eax,%edx
    1917:	8b 45 f4             	mov    -0xc(%ebp),%eax
    191a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    191d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1920:	8b 40 04             	mov    0x4(%eax),%eax
    1923:	c1 e0 03             	shl    $0x3,%eax
    1926:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1929:	8b 45 f4             	mov    -0xc(%ebp),%eax
    192c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    192f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1932:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1935:	a3 9c 26 00 00       	mov    %eax,0x269c
      return (void*)(p + 1);
    193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    193d:	83 c0 08             	add    $0x8,%eax
    1940:	eb 3b                	jmp    197d <malloc+0xe1>
    }
    if(p == freep)
    1942:	a1 9c 26 00 00       	mov    0x269c,%eax
    1947:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    194a:	75 1e                	jne    196a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    194c:	83 ec 0c             	sub    $0xc,%esp
    194f:	ff 75 ec             	pushl  -0x14(%ebp)
    1952:	e8 e5 fe ff ff       	call   183c <morecore>
    1957:	83 c4 10             	add    $0x10,%esp
    195a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    195d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1961:	75 07                	jne    196a <malloc+0xce>
        return 0;
    1963:	b8 00 00 00 00       	mov    $0x0,%eax
    1968:	eb 13                	jmp    197d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    196d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1970:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1973:	8b 00                	mov    (%eax),%eax
    1975:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1978:	e9 6d ff ff ff       	jmp    18ea <malloc+0x4e>
}
    197d:	c9                   	leave  
    197e:	c3                   	ret    
