
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 21 12 00 00       	call   1232 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 cc 17 00 00 	mov    0x17cc(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 a0 17 00 00       	push   $0x17a0
      2c:	e8 83 06 00 00       	call   6b4 <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 e9 11 00 00       	call   1232 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 0b 12 00 00       	call   126a <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 f4             	mov    -0xc(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 a7 17 00 00       	push   $0x17a7
      71:	6a 02                	push   $0x2
      73:	e8 71 13 00 00       	call   13e9 <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c6 01 00 00       	jmp    246 <runcmd+0x246>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 c5 11 00 00       	call   125a <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 c4 11 00 00       	call   1272 <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 b7 17 00 00       	push   $0x17b7
      c4:	6a 02                	push   $0x2
      c6:	e8 1e 13 00 00       	call   13e9 <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 5f 11 00 00       	call   1232 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5c 01 00 00       	jmp    246 <runcmd+0x246>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      f0:	e8 df 05 00 00       	call   6d4 <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 2a 11 00 00       	call   123a <wait>
    runcmd(lcmd->right);
     110:	8b 45 ec             	mov    -0x14(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 1f 01 00 00       	jmp    246 <runcmd+0x246>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 09 11 00 00       	call   1242 <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 c7 17 00 00       	push   $0x17c7
     148:	e8 67 05 00 00       	call   6b4 <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 7f 05 00 00       	call   6d4 <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 f7 10 00 00       	call   125a <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 38 11 00 00       	call   12aa <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 d9 10 00 00       	call   125a <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 ca 10 00 00       	call   125a <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 e8             	mov    -0x18(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 2a 05 00 00       	call   6d4 <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 a2 10 00 00       	call   125a <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 e3 10 00 00       	call   12aa <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 84 10 00 00       	call   125a <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 75 10 00 00       	call   125a <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 54 10 00 00       	call   125a <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 45 10 00 00       	call   125a <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 1d 10 00 00       	call   123a <wait>
    wait();
     21d:	e8 18 10 00 00       	call   123a <wait>
    break;
     222:	eb 22                	jmp    246 <runcmd+0x246>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     22a:	e8 a5 04 00 00       	call   6d4 <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 12                	jne    245 <runcmd+0x245>
      runcmd(bcmd->cmd);
     233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	90                   	nop
  }
  exit();
     246:	e8 e7 0f 00 00       	call   1232 <exit>

0000024b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24b:	55                   	push   %ebp
     24c:	89 e5                	mov    %esp,%ebp
     24e:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     251:	83 ec 08             	sub    $0x8,%esp
     254:	68 e4 17 00 00       	push   $0x17e4
     259:	6a 02                	push   $0x2
     25b:	e8 89 11 00 00       	call   13e9 <printf>
     260:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     263:	8b 45 0c             	mov    0xc(%ebp),%eax
     266:	83 ec 04             	sub    $0x4,%esp
     269:	50                   	push   %eax
     26a:	6a 00                	push   $0x0
     26c:	ff 75 08             	pushl  0x8(%ebp)
     26f:	e8 de 0d 00 00       	call   1052 <memset>
     274:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     277:	83 ec 08             	sub    $0x8,%esp
     27a:	ff 75 0c             	pushl  0xc(%ebp)
     27d:	ff 75 08             	pushl  0x8(%ebp)
     280:	e8 1a 0e 00 00       	call   109f <gets>
     285:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     288:	8b 45 08             	mov    0x8(%ebp),%eax
     28b:	0f b6 00             	movzbl (%eax),%eax
     28e:	84 c0                	test   %al,%al
     290:	75 07                	jne    299 <getcmd+0x4e>
    return -1;
     292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     297:	eb 05                	jmp    29e <getcmd+0x53>
  return 0;
     299:	b8 00 00 00 00       	mov    $0x0,%eax
}
     29e:	c9                   	leave  
     29f:	c3                   	ret    

000002a0 <strncmp>:
#ifdef USE_BUILTINS
// ***** processing for shell builtins begins here *****

int
strncmp(const char *p, const char *q, uint n)
{
     2a0:	55                   	push   %ebp
     2a1:	89 e5                	mov    %esp,%ebp
    while(n > 0 && *p && *p == *q)
     2a3:	eb 0c                	jmp    2b1 <strncmp+0x11>
      n--, p++, q++;
     2a5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     2a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     2ad:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
// ***** processing for shell builtins begins here *****

int
strncmp(const char *p, const char *q, uint n)
{
    while(n > 0 && *p && *p == *q)
     2b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     2b5:	74 1a                	je     2d1 <strncmp+0x31>
     2b7:	8b 45 08             	mov    0x8(%ebp),%eax
     2ba:	0f b6 00             	movzbl (%eax),%eax
     2bd:	84 c0                	test   %al,%al
     2bf:	74 10                	je     2d1 <strncmp+0x31>
     2c1:	8b 45 08             	mov    0x8(%ebp),%eax
     2c4:	0f b6 10             	movzbl (%eax),%edx
     2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
     2ca:	0f b6 00             	movzbl (%eax),%eax
     2cd:	38 c2                	cmp    %al,%dl
     2cf:	74 d4                	je     2a5 <strncmp+0x5>
      n--, p++, q++;
    if(n == 0)
     2d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     2d5:	75 07                	jne    2de <strncmp+0x3e>
      return 0;
     2d7:	b8 00 00 00 00       	mov    $0x0,%eax
     2dc:	eb 16                	jmp    2f4 <strncmp+0x54>
    return (uchar)*p - (uchar)*q;
     2de:	8b 45 08             	mov    0x8(%ebp),%eax
     2e1:	0f b6 00             	movzbl (%eax),%eax
     2e4:	0f b6 d0             	movzbl %al,%edx
     2e7:	8b 45 0c             	mov    0xc(%ebp),%eax
     2ea:	0f b6 00             	movzbl (%eax),%eax
     2ed:	0f b6 c0             	movzbl %al,%eax
     2f0:	29 c2                	sub    %eax,%edx
     2f2:	89 d0                	mov    %edx,%eax
}
     2f4:	5d                   	pop    %ebp
     2f5:	c3                   	ret    

000002f6 <makeint>:

int
makeint(char *p)
{
     2f6:	55                   	push   %ebp
     2f7:	89 e5                	mov    %esp,%ebp
     2f9:	83 ec 10             	sub    $0x10,%esp
  int val = 0;
     2fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  while ((*p >= '0') && (*p <= '9')) {
     303:	eb 23                	jmp    328 <makeint+0x32>
    val = 10*val + (*p-'0');
     305:	8b 55 fc             	mov    -0x4(%ebp),%edx
     308:	89 d0                	mov    %edx,%eax
     30a:	c1 e0 02             	shl    $0x2,%eax
     30d:	01 d0                	add    %edx,%eax
     30f:	01 c0                	add    %eax,%eax
     311:	89 c2                	mov    %eax,%edx
     313:	8b 45 08             	mov    0x8(%ebp),%eax
     316:	0f b6 00             	movzbl (%eax),%eax
     319:	0f be c0             	movsbl %al,%eax
     31c:	83 e8 30             	sub    $0x30,%eax
     31f:	01 d0                	add    %edx,%eax
     321:	89 45 fc             	mov    %eax,-0x4(%ebp)
    ++p;
     324:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
makeint(char *p)
{
  int val = 0;

  while ((*p >= '0') && (*p <= '9')) {
     328:	8b 45 08             	mov    0x8(%ebp),%eax
     32b:	0f b6 00             	movzbl (%eax),%eax
     32e:	3c 2f                	cmp    $0x2f,%al
     330:	7e 0a                	jle    33c <makeint+0x46>
     332:	8b 45 08             	mov    0x8(%ebp),%eax
     335:	0f b6 00             	movzbl (%eax),%eax
     338:	3c 39                	cmp    $0x39,%al
     33a:	7e c9                	jle    305 <makeint+0xf>
    val = 10*val + (*p-'0');
    ++p;
  }
  return val;
     33c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     33f:	c9                   	leave  
     340:	c3                   	ret    

00000341 <setbuiltin>:

int
setbuiltin(char *p)
{
     341:	55                   	push   %ebp
     342:	89 e5                	mov    %esp,%ebp
     344:	83 ec 18             	sub    $0x18,%esp
  int i;

  p += strlen("_set");
     347:	83 ec 0c             	sub    $0xc,%esp
     34a:	68 e7 17 00 00       	push   $0x17e7
     34f:	e8 d7 0c 00 00       	call   102b <strlen>
     354:	83 c4 10             	add    $0x10,%esp
     357:	01 45 08             	add    %eax,0x8(%ebp)
  while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     35a:	eb 04                	jmp    360 <setbuiltin+0x1f>
     35c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     360:	83 ec 04             	sub    $0x4,%esp
     363:	6a 01                	push   $0x1
     365:	68 ec 17 00 00       	push   $0x17ec
     36a:	ff 75 08             	pushl  0x8(%ebp)
     36d:	e8 2e ff ff ff       	call   2a0 <strncmp>
     372:	83 c4 10             	add    $0x10,%esp
     375:	85 c0                	test   %eax,%eax
     377:	74 e3                	je     35c <setbuiltin+0x1b>
  if (strncmp("uid", p, 3) == 0) {
     379:	83 ec 04             	sub    $0x4,%esp
     37c:	6a 03                	push   $0x3
     37e:	ff 75 08             	pushl  0x8(%ebp)
     381:	68 ee 17 00 00       	push   $0x17ee
     386:	e8 15 ff ff ff       	call   2a0 <strncmp>
     38b:	83 c4 10             	add    $0x10,%esp
     38e:	85 c0                	test   %eax,%eax
     390:	75 57                	jne    3e9 <setbuiltin+0xa8>
    p += strlen("uid");
     392:	83 ec 0c             	sub    $0xc,%esp
     395:	68 ee 17 00 00       	push   $0x17ee
     39a:	e8 8c 0c 00 00       	call   102b <strlen>
     39f:	83 c4 10             	add    $0x10,%esp
     3a2:	01 45 08             	add    %eax,0x8(%ebp)
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     3a5:	eb 04                	jmp    3ab <setbuiltin+0x6a>
     3a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3ab:	83 ec 04             	sub    $0x4,%esp
     3ae:	6a 01                	push   $0x1
     3b0:	68 ec 17 00 00       	push   $0x17ec
     3b5:	ff 75 08             	pushl  0x8(%ebp)
     3b8:	e8 e3 fe ff ff       	call   2a0 <strncmp>
     3bd:	83 c4 10             	add    $0x10,%esp
     3c0:	85 c0                	test   %eax,%eax
     3c2:	74 e3                	je     3a7 <setbuiltin+0x66>
    i = makeint(p); // ugly
     3c4:	83 ec 0c             	sub    $0xc,%esp
     3c7:	ff 75 08             	pushl  0x8(%ebp)
     3ca:	e8 27 ff ff ff       	call   2f6 <makeint>
     3cf:	83 c4 10             	add    $0x10,%esp
     3d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return (setuid(i));
     3d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d8:	83 ec 0c             	sub    $0xc,%esp
     3db:	50                   	push   %eax
     3dc:	e8 19 0f 00 00       	call   12fa <setuid>
     3e1:	83 c4 10             	add    $0x10,%esp
     3e4:	e9 84 00 00 00       	jmp    46d <setbuiltin+0x12c>
  } else 
  if (strncmp("gid", p, 3) == 0) {
     3e9:	83 ec 04             	sub    $0x4,%esp
     3ec:	6a 03                	push   $0x3
     3ee:	ff 75 08             	pushl  0x8(%ebp)
     3f1:	68 f2 17 00 00       	push   $0x17f2
     3f6:	e8 a5 fe ff ff       	call   2a0 <strncmp>
     3fb:	83 c4 10             	add    $0x10,%esp
     3fe:	85 c0                	test   %eax,%eax
     400:	75 54                	jne    456 <setbuiltin+0x115>
    p += strlen("gid");
     402:	83 ec 0c             	sub    $0xc,%esp
     405:	68 f2 17 00 00       	push   $0x17f2
     40a:	e8 1c 0c 00 00       	call   102b <strlen>
     40f:	83 c4 10             	add    $0x10,%esp
     412:	01 45 08             	add    %eax,0x8(%ebp)
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     415:	eb 04                	jmp    41b <setbuiltin+0xda>
     417:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     41b:	83 ec 04             	sub    $0x4,%esp
     41e:	6a 01                	push   $0x1
     420:	68 ec 17 00 00       	push   $0x17ec
     425:	ff 75 08             	pushl  0x8(%ebp)
     428:	e8 73 fe ff ff       	call   2a0 <strncmp>
     42d:	83 c4 10             	add    $0x10,%esp
     430:	85 c0                	test   %eax,%eax
     432:	74 e3                	je     417 <setbuiltin+0xd6>
    i = makeint(p); // ugly
     434:	83 ec 0c             	sub    $0xc,%esp
     437:	ff 75 08             	pushl  0x8(%ebp)
     43a:	e8 b7 fe ff ff       	call   2f6 <makeint>
     43f:	83 c4 10             	add    $0x10,%esp
     442:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return (setgid(i));
     445:	8b 45 f4             	mov    -0xc(%ebp),%eax
     448:	83 ec 0c             	sub    $0xc,%esp
     44b:	50                   	push   %eax
     44c:	e8 b1 0e 00 00       	call   1302 <setgid>
     451:	83 c4 10             	add    $0x10,%esp
     454:	eb 17                	jmp    46d <setbuiltin+0x12c>
  }
  printf(2, "Invalid _set parameter\n");
     456:	83 ec 08             	sub    $0x8,%esp
     459:	68 f6 17 00 00       	push   $0x17f6
     45e:	6a 02                	push   $0x2
     460:	e8 84 0f 00 00       	call   13e9 <printf>
     465:	83 c4 10             	add    $0x10,%esp
  return -1;
     468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     46d:	c9                   	leave  
     46e:	c3                   	ret    

0000046f <getbuiltin>:

int
getbuiltin(char *p)
{
     46f:	55                   	push   %ebp
     470:	89 e5                	mov    %esp,%ebp
     472:	83 ec 08             	sub    $0x8,%esp
  p += strlen("_get");
     475:	83 ec 0c             	sub    $0xc,%esp
     478:	68 0e 18 00 00       	push   $0x180e
     47d:	e8 a9 0b 00 00       	call   102b <strlen>
     482:	83 c4 10             	add    $0x10,%esp
     485:	01 45 08             	add    %eax,0x8(%ebp)
  while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     488:	eb 04                	jmp    48e <getbuiltin+0x1f>
     48a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     48e:	83 ec 04             	sub    $0x4,%esp
     491:	6a 01                	push   $0x1
     493:	68 ec 17 00 00       	push   $0x17ec
     498:	ff 75 08             	pushl  0x8(%ebp)
     49b:	e8 00 fe ff ff       	call   2a0 <strncmp>
     4a0:	83 c4 10             	add    $0x10,%esp
     4a3:	85 c0                	test   %eax,%eax
     4a5:	74 e3                	je     48a <getbuiltin+0x1b>
  if (strncmp("uid", p, 3) == 0) {
     4a7:	83 ec 04             	sub    $0x4,%esp
     4aa:	6a 03                	push   $0x3
     4ac:	ff 75 08             	pushl  0x8(%ebp)
     4af:	68 ee 17 00 00       	push   $0x17ee
     4b4:	e8 e7 fd ff ff       	call   2a0 <strncmp>
     4b9:	83 c4 10             	add    $0x10,%esp
     4bc:	85 c0                	test   %eax,%eax
     4be:	75 1f                	jne    4df <getbuiltin+0x70>
    printf(2, "%d\n", getuid());
     4c0:	e8 1d 0e 00 00       	call   12e2 <getuid>
     4c5:	83 ec 04             	sub    $0x4,%esp
     4c8:	50                   	push   %eax
     4c9:	68 13 18 00 00       	push   $0x1813
     4ce:	6a 02                	push   $0x2
     4d0:	e8 14 0f 00 00       	call   13e9 <printf>
     4d5:	83 c4 10             	add    $0x10,%esp
    return 0;
     4d8:	b8 00 00 00 00       	mov    $0x0,%eax
     4dd:	eb 4f                	jmp    52e <getbuiltin+0xbf>
  }
  if (strncmp("gid", p, 3) == 0) {
     4df:	83 ec 04             	sub    $0x4,%esp
     4e2:	6a 03                	push   $0x3
     4e4:	ff 75 08             	pushl  0x8(%ebp)
     4e7:	68 f2 17 00 00       	push   $0x17f2
     4ec:	e8 af fd ff ff       	call   2a0 <strncmp>
     4f1:	83 c4 10             	add    $0x10,%esp
     4f4:	85 c0                	test   %eax,%eax
     4f6:	75 1f                	jne    517 <getbuiltin+0xa8>
    printf(2, "%d\n", getgid());
     4f8:	e8 ed 0d 00 00       	call   12ea <getgid>
     4fd:	83 ec 04             	sub    $0x4,%esp
     500:	50                   	push   %eax
     501:	68 13 18 00 00       	push   $0x1813
     506:	6a 02                	push   $0x2
     508:	e8 dc 0e 00 00       	call   13e9 <printf>
     50d:	83 c4 10             	add    $0x10,%esp
    return 0;
     510:	b8 00 00 00 00       	mov    $0x0,%eax
     515:	eb 17                	jmp    52e <getbuiltin+0xbf>
  }
  printf(2, "Invalid _get parameter\n");
     517:	83 ec 08             	sub    $0x8,%esp
     51a:	68 17 18 00 00       	push   $0x1817
     51f:	6a 02                	push   $0x2
     521:	e8 c3 0e 00 00       	call   13e9 <printf>
     526:	83 c4 10             	add    $0x10,%esp
  return -1;
     529:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     52e:	c9                   	leave  
     52f:	c3                   	ret    

00000530 <dobuiltin>:
  {"_get", getbuiltin}
};
int FDTcount = sizeof(fdt) / sizeof(fdt[0]); // # entris in FDT

void
dobuiltin(char *cmd) {
     530:	55                   	push   %ebp
     531:	89 e5                	mov    %esp,%ebp
     533:	83 ec 18             	sub    $0x18,%esp
  int i;

  for (i=0; i<FDTcount; i++) 
     536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     53d:	eb 4f                	jmp    58e <dobuiltin+0x5e>
    if (strncmp(cmd, fdt[i].cmd, strlen(fdt[i].cmd)) == 0) 
     53f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     542:	8b 04 c5 04 1e 00 00 	mov    0x1e04(,%eax,8),%eax
     549:	83 ec 0c             	sub    $0xc,%esp
     54c:	50                   	push   %eax
     54d:	e8 d9 0a 00 00       	call   102b <strlen>
     552:	83 c4 10             	add    $0x10,%esp
     555:	89 c2                	mov    %eax,%edx
     557:	8b 45 f4             	mov    -0xc(%ebp),%eax
     55a:	8b 04 c5 04 1e 00 00 	mov    0x1e04(,%eax,8),%eax
     561:	83 ec 04             	sub    $0x4,%esp
     564:	52                   	push   %edx
     565:	50                   	push   %eax
     566:	ff 75 08             	pushl  0x8(%ebp)
     569:	e8 32 fd ff ff       	call   2a0 <strncmp>
     56e:	83 c4 10             	add    $0x10,%esp
     571:	85 c0                	test   %eax,%eax
     573:	75 15                	jne    58a <dobuiltin+0x5a>
     (*fdt[i].name)(cmd);
     575:	8b 45 f4             	mov    -0xc(%ebp),%eax
     578:	8b 04 c5 08 1e 00 00 	mov    0x1e08(,%eax,8),%eax
     57f:	83 ec 0c             	sub    $0xc,%esp
     582:	ff 75 08             	pushl  0x8(%ebp)
     585:	ff d0                	call   *%eax
     587:	83 c4 10             	add    $0x10,%esp

void
dobuiltin(char *cmd) {
  int i;

  for (i=0; i<FDTcount; i++) 
     58a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     58e:	a1 14 1e 00 00       	mov    0x1e14,%eax
     593:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     596:	7c a7                	jl     53f <dobuiltin+0xf>
    if (strncmp(cmd, fdt[i].cmd, strlen(fdt[i].cmd)) == 0) 
     (*fdt[i].name)(cmd);
}
     598:	90                   	nop
     599:	c9                   	leave  
     59a:	c3                   	ret    

0000059b <main>:
// ***** processing for shell builtins ends here *****
#endif

int
main(void)
{
     59b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     59f:	83 e4 f0             	and    $0xfffffff0,%esp
     5a2:	ff 71 fc             	pushl  -0x4(%ecx)
     5a5:	55                   	push   %ebp
     5a6:	89 e5                	mov    %esp,%ebp
     5a8:	51                   	push   %ecx
     5a9:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     5ac:	eb 16                	jmp    5c4 <main+0x29>
    if(fd >= 3){
     5ae:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     5b2:	7e 10                	jle    5c4 <main+0x29>
      close(fd);
     5b4:	83 ec 0c             	sub    $0xc,%esp
     5b7:	ff 75 f4             	pushl  -0xc(%ebp)
     5ba:	e8 9b 0c 00 00       	call   125a <close>
     5bf:	83 c4 10             	add    $0x10,%esp
      break;
     5c2:	eb 1b                	jmp    5df <main+0x44>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     5c4:	83 ec 08             	sub    $0x8,%esp
     5c7:	6a 02                	push   $0x2
     5c9:	68 2f 18 00 00       	push   $0x182f
     5ce:	e8 9f 0c 00 00       	call   1272 <open>
     5d3:	83 c4 10             	add    $0x10,%esp
     5d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     5d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     5dd:	79 cf                	jns    5ae <main+0x13>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     5df:	e9 b1 00 00 00       	jmp    695 <main+0xfa>
// add support for built-ins here. cd is a built-in
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     5e4:	0f b6 05 40 1e 00 00 	movzbl 0x1e40,%eax
     5eb:	3c 63                	cmp    $0x63,%al
     5ed:	75 5f                	jne    64e <main+0xb3>
     5ef:	0f b6 05 41 1e 00 00 	movzbl 0x1e41,%eax
     5f6:	3c 64                	cmp    $0x64,%al
     5f8:	75 54                	jne    64e <main+0xb3>
     5fa:	0f b6 05 42 1e 00 00 	movzbl 0x1e42,%eax
     601:	3c 20                	cmp    $0x20,%al
     603:	75 49                	jne    64e <main+0xb3>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     605:	83 ec 0c             	sub    $0xc,%esp
     608:	68 40 1e 00 00       	push   $0x1e40
     60d:	e8 19 0a 00 00       	call   102b <strlen>
     612:	83 c4 10             	add    $0x10,%esp
     615:	83 e8 01             	sub    $0x1,%eax
     618:	c6 80 40 1e 00 00 00 	movb   $0x0,0x1e40(%eax)
      if(chdir(buf+3) < 0)
     61f:	b8 43 1e 00 00       	mov    $0x1e43,%eax
     624:	83 ec 0c             	sub    $0xc,%esp
     627:	50                   	push   %eax
     628:	e8 75 0c 00 00       	call   12a2 <chdir>
     62d:	83 c4 10             	add    $0x10,%esp
     630:	85 c0                	test   %eax,%eax
     632:	79 61                	jns    695 <main+0xfa>
        printf(2, "cannot cd %s\n", buf+3);
     634:	b8 43 1e 00 00       	mov    $0x1e43,%eax
     639:	83 ec 04             	sub    $0x4,%esp
     63c:	50                   	push   %eax
     63d:	68 37 18 00 00       	push   $0x1837
     642:	6a 02                	push   $0x2
     644:	e8 a0 0d 00 00       	call   13e9 <printf>
     649:	83 c4 10             	add    $0x10,%esp
      continue;
     64c:	eb 47                	jmp    695 <main+0xfa>
    }
#ifdef USE_BUILTINS
    if (buf[0]=='_') {     // assume it is a builtin command
     64e:	0f b6 05 40 1e 00 00 	movzbl 0x1e40,%eax
     655:	3c 5f                	cmp    $0x5f,%al
     657:	75 12                	jne    66b <main+0xd0>
      dobuiltin(buf);
     659:	83 ec 0c             	sub    $0xc,%esp
     65c:	68 40 1e 00 00       	push   $0x1e40
     661:	e8 ca fe ff ff       	call   530 <dobuiltin>
     666:	83 c4 10             	add    $0x10,%esp
      continue;
     669:	eb 2a                	jmp    695 <main+0xfa>
    }
#endif
    if(fork1() == 0)
     66b:	e8 64 00 00 00       	call   6d4 <fork1>
     670:	85 c0                	test   %eax,%eax
     672:	75 1c                	jne    690 <main+0xf5>
      runcmd(parsecmd(buf));
     674:	83 ec 0c             	sub    $0xc,%esp
     677:	68 40 1e 00 00       	push   $0x1e40
     67c:	e8 ab 03 00 00       	call   a2c <parsecmd>
     681:	83 c4 10             	add    $0x10,%esp
     684:	83 ec 0c             	sub    $0xc,%esp
     687:	50                   	push   %eax
     688:	e8 73 f9 ff ff       	call   0 <runcmd>
     68d:	83 c4 10             	add    $0x10,%esp
    wait();
     690:	e8 a5 0b 00 00       	call   123a <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     695:	83 ec 08             	sub    $0x8,%esp
     698:	6a 64                	push   $0x64
     69a:	68 40 1e 00 00       	push   $0x1e40
     69f:	e8 a7 fb ff ff       	call   24b <getcmd>
     6a4:	83 c4 10             	add    $0x10,%esp
     6a7:	85 c0                	test   %eax,%eax
     6a9:	0f 89 35 ff ff ff    	jns    5e4 <main+0x49>
#endif
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     6af:	e8 7e 0b 00 00       	call   1232 <exit>

000006b4 <panic>:
}

void
panic(char *s)
{
     6b4:	55                   	push   %ebp
     6b5:	89 e5                	mov    %esp,%ebp
     6b7:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     6ba:	83 ec 04             	sub    $0x4,%esp
     6bd:	ff 75 08             	pushl  0x8(%ebp)
     6c0:	68 45 18 00 00       	push   $0x1845
     6c5:	6a 02                	push   $0x2
     6c7:	e8 1d 0d 00 00       	call   13e9 <printf>
     6cc:	83 c4 10             	add    $0x10,%esp
  exit();
     6cf:	e8 5e 0b 00 00       	call   1232 <exit>

000006d4 <fork1>:
}

int
fork1(void)
{
     6d4:	55                   	push   %ebp
     6d5:	89 e5                	mov    %esp,%ebp
     6d7:	83 ec 18             	sub    $0x18,%esp
  int pid;
  
  pid = fork();
     6da:	e8 4b 0b 00 00       	call   122a <fork>
     6df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     6e2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     6e6:	75 10                	jne    6f8 <fork1+0x24>
    panic("fork");
     6e8:	83 ec 0c             	sub    $0xc,%esp
     6eb:	68 49 18 00 00       	push   $0x1849
     6f0:	e8 bf ff ff ff       	call   6b4 <panic>
     6f5:	83 c4 10             	add    $0x10,%esp
  return pid;
     6f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     6fb:	c9                   	leave  
     6fc:	c3                   	ret    

000006fd <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     6fd:	55                   	push   %ebp
     6fe:	89 e5                	mov    %esp,%ebp
     700:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     703:	83 ec 0c             	sub    $0xc,%esp
     706:	6a 54                	push   $0x54
     708:	e8 af 0f 00 00       	call   16bc <malloc>
     70d:	83 c4 10             	add    $0x10,%esp
     710:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     713:	83 ec 04             	sub    $0x4,%esp
     716:	6a 54                	push   $0x54
     718:	6a 00                	push   $0x0
     71a:	ff 75 f4             	pushl  -0xc(%ebp)
     71d:	e8 30 09 00 00       	call   1052 <memset>
     722:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     725:	8b 45 f4             	mov    -0xc(%ebp),%eax
     728:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     72e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     731:	c9                   	leave  
     732:	c3                   	ret    

00000733 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     733:	55                   	push   %ebp
     734:	89 e5                	mov    %esp,%ebp
     736:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     739:	83 ec 0c             	sub    $0xc,%esp
     73c:	6a 18                	push   $0x18
     73e:	e8 79 0f 00 00       	call   16bc <malloc>
     743:	83 c4 10             	add    $0x10,%esp
     746:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     749:	83 ec 04             	sub    $0x4,%esp
     74c:	6a 18                	push   $0x18
     74e:	6a 00                	push   $0x0
     750:	ff 75 f4             	pushl  -0xc(%ebp)
     753:	e8 fa 08 00 00       	call   1052 <memset>
     758:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     75e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     764:	8b 45 f4             	mov    -0xc(%ebp),%eax
     767:	8b 55 08             	mov    0x8(%ebp),%edx
     76a:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     770:	8b 55 0c             	mov    0xc(%ebp),%edx
     773:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     776:	8b 45 f4             	mov    -0xc(%ebp),%eax
     779:	8b 55 10             	mov    0x10(%ebp),%edx
     77c:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     782:	8b 55 14             	mov    0x14(%ebp),%edx
     785:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     788:	8b 45 f4             	mov    -0xc(%ebp),%eax
     78b:	8b 55 18             	mov    0x18(%ebp),%edx
     78e:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     791:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     794:	c9                   	leave  
     795:	c3                   	ret    

00000796 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     796:	55                   	push   %ebp
     797:	89 e5                	mov    %esp,%ebp
     799:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     79c:	83 ec 0c             	sub    $0xc,%esp
     79f:	6a 0c                	push   $0xc
     7a1:	e8 16 0f 00 00       	call   16bc <malloc>
     7a6:	83 c4 10             	add    $0x10,%esp
     7a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     7ac:	83 ec 04             	sub    $0x4,%esp
     7af:	6a 0c                	push   $0xc
     7b1:	6a 00                	push   $0x0
     7b3:	ff 75 f4             	pushl  -0xc(%ebp)
     7b6:	e8 97 08 00 00       	call   1052 <memset>
     7bb:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c1:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ca:	8b 55 08             	mov    0x8(%ebp),%edx
     7cd:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7d3:	8b 55 0c             	mov    0xc(%ebp),%edx
     7d6:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7dc:	c9                   	leave  
     7dd:	c3                   	ret    

000007de <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     7de:	55                   	push   %ebp
     7df:	89 e5                	mov    %esp,%ebp
     7e1:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7e4:	83 ec 0c             	sub    $0xc,%esp
     7e7:	6a 0c                	push   $0xc
     7e9:	e8 ce 0e 00 00       	call   16bc <malloc>
     7ee:	83 c4 10             	add    $0x10,%esp
     7f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     7f4:	83 ec 04             	sub    $0x4,%esp
     7f7:	6a 0c                	push   $0xc
     7f9:	6a 00                	push   $0x0
     7fb:	ff 75 f4             	pushl  -0xc(%ebp)
     7fe:	e8 4f 08 00 00       	call   1052 <memset>
     803:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     806:	8b 45 f4             	mov    -0xc(%ebp),%eax
     809:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     812:	8b 55 08             	mov    0x8(%ebp),%edx
     815:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     818:	8b 45 f4             	mov    -0xc(%ebp),%eax
     81b:	8b 55 0c             	mov    0xc(%ebp),%edx
     81e:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     821:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     824:	c9                   	leave  
     825:	c3                   	ret    

00000826 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     826:	55                   	push   %ebp
     827:	89 e5                	mov    %esp,%ebp
     829:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     82c:	83 ec 0c             	sub    $0xc,%esp
     82f:	6a 08                	push   $0x8
     831:	e8 86 0e 00 00       	call   16bc <malloc>
     836:	83 c4 10             	add    $0x10,%esp
     839:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     83c:	83 ec 04             	sub    $0x4,%esp
     83f:	6a 08                	push   $0x8
     841:	6a 00                	push   $0x0
     843:	ff 75 f4             	pushl  -0xc(%ebp)
     846:	e8 07 08 00 00       	call   1052 <memset>
     84b:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     851:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     857:	8b 45 f4             	mov    -0xc(%ebp),%eax
     85a:	8b 55 08             	mov    0x8(%ebp),%edx
     85d:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     860:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     863:	c9                   	leave  
     864:	c3                   	ret    

00000865 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     865:	55                   	push   %ebp
     866:	89 e5                	mov    %esp,%ebp
     868:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;
  
  s = *ps;
     86b:	8b 45 08             	mov    0x8(%ebp),%eax
     86e:	8b 00                	mov    (%eax),%eax
     870:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     873:	eb 04                	jmp    879 <gettoken+0x14>
    s++;
     875:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     879:	8b 45 f4             	mov    -0xc(%ebp),%eax
     87c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     87f:	73 1e                	jae    89f <gettoken+0x3a>
     881:	8b 45 f4             	mov    -0xc(%ebp),%eax
     884:	0f b6 00             	movzbl (%eax),%eax
     887:	0f be c0             	movsbl %al,%eax
     88a:	83 ec 08             	sub    $0x8,%esp
     88d:	50                   	push   %eax
     88e:	68 18 1e 00 00       	push   $0x1e18
     893:	e8 d4 07 00 00       	call   106c <strchr>
     898:	83 c4 10             	add    $0x10,%esp
     89b:	85 c0                	test   %eax,%eax
     89d:	75 d6                	jne    875 <gettoken+0x10>
    s++;
  if(q)
     89f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     8a3:	74 08                	je     8ad <gettoken+0x48>
    *q = s;
     8a5:	8b 45 10             	mov    0x10(%ebp),%eax
     8a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8ab:	89 10                	mov    %edx,(%eax)
  ret = *s;
     8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8b0:	0f b6 00             	movzbl (%eax),%eax
     8b3:	0f be c0             	movsbl %al,%eax
     8b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8bc:	0f b6 00             	movzbl (%eax),%eax
     8bf:	0f be c0             	movsbl %al,%eax
     8c2:	83 f8 29             	cmp    $0x29,%eax
     8c5:	7f 14                	jg     8db <gettoken+0x76>
     8c7:	83 f8 28             	cmp    $0x28,%eax
     8ca:	7d 28                	jge    8f4 <gettoken+0x8f>
     8cc:	85 c0                	test   %eax,%eax
     8ce:	0f 84 94 00 00 00    	je     968 <gettoken+0x103>
     8d4:	83 f8 26             	cmp    $0x26,%eax
     8d7:	74 1b                	je     8f4 <gettoken+0x8f>
     8d9:	eb 3a                	jmp    915 <gettoken+0xb0>
     8db:	83 f8 3e             	cmp    $0x3e,%eax
     8de:	74 1a                	je     8fa <gettoken+0x95>
     8e0:	83 f8 3e             	cmp    $0x3e,%eax
     8e3:	7f 0a                	jg     8ef <gettoken+0x8a>
     8e5:	83 e8 3b             	sub    $0x3b,%eax
     8e8:	83 f8 01             	cmp    $0x1,%eax
     8eb:	77 28                	ja     915 <gettoken+0xb0>
     8ed:	eb 05                	jmp    8f4 <gettoken+0x8f>
     8ef:	83 f8 7c             	cmp    $0x7c,%eax
     8f2:	75 21                	jne    915 <gettoken+0xb0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     8f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     8f8:	eb 75                	jmp    96f <gettoken+0x10a>
  case '>':
    s++;
     8fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     901:	0f b6 00             	movzbl (%eax),%eax
     904:	3c 3e                	cmp    $0x3e,%al
     906:	75 63                	jne    96b <gettoken+0x106>
      ret = '+';
     908:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     90f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     913:	eb 56                	jmp    96b <gettoken+0x106>
  default:
    ret = 'a';
     915:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     91c:	eb 04                	jmp    922 <gettoken+0xbd>
      s++;
     91e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     922:	8b 45 f4             	mov    -0xc(%ebp),%eax
     925:	3b 45 0c             	cmp    0xc(%ebp),%eax
     928:	73 44                	jae    96e <gettoken+0x109>
     92a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     92d:	0f b6 00             	movzbl (%eax),%eax
     930:	0f be c0             	movsbl %al,%eax
     933:	83 ec 08             	sub    $0x8,%esp
     936:	50                   	push   %eax
     937:	68 18 1e 00 00       	push   $0x1e18
     93c:	e8 2b 07 00 00       	call   106c <strchr>
     941:	83 c4 10             	add    $0x10,%esp
     944:	85 c0                	test   %eax,%eax
     946:	75 26                	jne    96e <gettoken+0x109>
     948:	8b 45 f4             	mov    -0xc(%ebp),%eax
     94b:	0f b6 00             	movzbl (%eax),%eax
     94e:	0f be c0             	movsbl %al,%eax
     951:	83 ec 08             	sub    $0x8,%esp
     954:	50                   	push   %eax
     955:	68 20 1e 00 00       	push   $0x1e20
     95a:	e8 0d 07 00 00       	call   106c <strchr>
     95f:	83 c4 10             	add    $0x10,%esp
     962:	85 c0                	test   %eax,%eax
     964:	74 b8                	je     91e <gettoken+0xb9>
      s++;
    break;
     966:	eb 06                	jmp    96e <gettoken+0x109>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     968:	90                   	nop
     969:	eb 04                	jmp    96f <gettoken+0x10a>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     96b:	90                   	nop
     96c:	eb 01                	jmp    96f <gettoken+0x10a>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
     96e:	90                   	nop
  }
  if(eq)
     96f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     973:	74 0e                	je     983 <gettoken+0x11e>
    *eq = s;
     975:	8b 45 14             	mov    0x14(%ebp),%eax
     978:	8b 55 f4             	mov    -0xc(%ebp),%edx
     97b:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     97d:	eb 04                	jmp    983 <gettoken+0x11e>
    s++;
     97f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     983:	8b 45 f4             	mov    -0xc(%ebp),%eax
     986:	3b 45 0c             	cmp    0xc(%ebp),%eax
     989:	73 1e                	jae    9a9 <gettoken+0x144>
     98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     98e:	0f b6 00             	movzbl (%eax),%eax
     991:	0f be c0             	movsbl %al,%eax
     994:	83 ec 08             	sub    $0x8,%esp
     997:	50                   	push   %eax
     998:	68 18 1e 00 00       	push   $0x1e18
     99d:	e8 ca 06 00 00       	call   106c <strchr>
     9a2:	83 c4 10             	add    $0x10,%esp
     9a5:	85 c0                	test   %eax,%eax
     9a7:	75 d6                	jne    97f <gettoken+0x11a>
    s++;
  *ps = s;
     9a9:	8b 45 08             	mov    0x8(%ebp),%eax
     9ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9af:	89 10                	mov    %edx,(%eax)
  return ret;
     9b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     9b4:	c9                   	leave  
     9b5:	c3                   	ret    

000009b6 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     9b6:	55                   	push   %ebp
     9b7:	89 e5                	mov    %esp,%ebp
     9b9:	83 ec 18             	sub    $0x18,%esp
  char *s;
  
  s = *ps;
     9bc:	8b 45 08             	mov    0x8(%ebp),%eax
     9bf:	8b 00                	mov    (%eax),%eax
     9c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     9c4:	eb 04                	jmp    9ca <peek+0x14>
    s++;
     9c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     9ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
     9d0:	73 1e                	jae    9f0 <peek+0x3a>
     9d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9d5:	0f b6 00             	movzbl (%eax),%eax
     9d8:	0f be c0             	movsbl %al,%eax
     9db:	83 ec 08             	sub    $0x8,%esp
     9de:	50                   	push   %eax
     9df:	68 18 1e 00 00       	push   $0x1e18
     9e4:	e8 83 06 00 00       	call   106c <strchr>
     9e9:	83 c4 10             	add    $0x10,%esp
     9ec:	85 c0                	test   %eax,%eax
     9ee:	75 d6                	jne    9c6 <peek+0x10>
    s++;
  *ps = s;
     9f0:	8b 45 08             	mov    0x8(%ebp),%eax
     9f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9f6:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     9f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9fb:	0f b6 00             	movzbl (%eax),%eax
     9fe:	84 c0                	test   %al,%al
     a00:	74 23                	je     a25 <peek+0x6f>
     a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a05:	0f b6 00             	movzbl (%eax),%eax
     a08:	0f be c0             	movsbl %al,%eax
     a0b:	83 ec 08             	sub    $0x8,%esp
     a0e:	50                   	push   %eax
     a0f:	ff 75 10             	pushl  0x10(%ebp)
     a12:	e8 55 06 00 00       	call   106c <strchr>
     a17:	83 c4 10             	add    $0x10,%esp
     a1a:	85 c0                	test   %eax,%eax
     a1c:	74 07                	je     a25 <peek+0x6f>
     a1e:	b8 01 00 00 00       	mov    $0x1,%eax
     a23:	eb 05                	jmp    a2a <peek+0x74>
     a25:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a2a:	c9                   	leave  
     a2b:	c3                   	ret    

00000a2c <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     a2c:	55                   	push   %ebp
     a2d:	89 e5                	mov    %esp,%ebp
     a2f:	53                   	push   %ebx
     a30:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     a33:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a36:	8b 45 08             	mov    0x8(%ebp),%eax
     a39:	83 ec 0c             	sub    $0xc,%esp
     a3c:	50                   	push   %eax
     a3d:	e8 e9 05 00 00       	call   102b <strlen>
     a42:	83 c4 10             	add    $0x10,%esp
     a45:	01 d8                	add    %ebx,%eax
     a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     a4a:	83 ec 08             	sub    $0x8,%esp
     a4d:	ff 75 f4             	pushl  -0xc(%ebp)
     a50:	8d 45 08             	lea    0x8(%ebp),%eax
     a53:	50                   	push   %eax
     a54:	e8 61 00 00 00       	call   aba <parseline>
     a59:	83 c4 10             	add    $0x10,%esp
     a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     a5f:	83 ec 04             	sub    $0x4,%esp
     a62:	68 4e 18 00 00       	push   $0x184e
     a67:	ff 75 f4             	pushl  -0xc(%ebp)
     a6a:	8d 45 08             	lea    0x8(%ebp),%eax
     a6d:	50                   	push   %eax
     a6e:	e8 43 ff ff ff       	call   9b6 <peek>
     a73:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     a76:	8b 45 08             	mov    0x8(%ebp),%eax
     a79:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     a7c:	74 26                	je     aa4 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     a7e:	8b 45 08             	mov    0x8(%ebp),%eax
     a81:	83 ec 04             	sub    $0x4,%esp
     a84:	50                   	push   %eax
     a85:	68 4f 18 00 00       	push   $0x184f
     a8a:	6a 02                	push   $0x2
     a8c:	e8 58 09 00 00       	call   13e9 <printf>
     a91:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     a94:	83 ec 0c             	sub    $0xc,%esp
     a97:	68 5e 18 00 00       	push   $0x185e
     a9c:	e8 13 fc ff ff       	call   6b4 <panic>
     aa1:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     aa4:	83 ec 0c             	sub    $0xc,%esp
     aa7:	ff 75 f0             	pushl  -0x10(%ebp)
     aaa:	e8 eb 03 00 00       	call   e9a <nulterminate>
     aaf:	83 c4 10             	add    $0x10,%esp
  return cmd;
     ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ab8:	c9                   	leave  
     ab9:	c3                   	ret    

00000aba <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     aba:	55                   	push   %ebp
     abb:	89 e5                	mov    %esp,%ebp
     abd:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     ac0:	83 ec 08             	sub    $0x8,%esp
     ac3:	ff 75 0c             	pushl  0xc(%ebp)
     ac6:	ff 75 08             	pushl  0x8(%ebp)
     ac9:	e8 99 00 00 00       	call   b67 <parsepipe>
     ace:	83 c4 10             	add    $0x10,%esp
     ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     ad4:	eb 23                	jmp    af9 <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     ad6:	6a 00                	push   $0x0
     ad8:	6a 00                	push   $0x0
     ada:	ff 75 0c             	pushl  0xc(%ebp)
     add:	ff 75 08             	pushl  0x8(%ebp)
     ae0:	e8 80 fd ff ff       	call   865 <gettoken>
     ae5:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     ae8:	83 ec 0c             	sub    $0xc,%esp
     aeb:	ff 75 f4             	pushl  -0xc(%ebp)
     aee:	e8 33 fd ff ff       	call   826 <backcmd>
     af3:	83 c4 10             	add    $0x10,%esp
     af6:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     af9:	83 ec 04             	sub    $0x4,%esp
     afc:	68 65 18 00 00       	push   $0x1865
     b01:	ff 75 0c             	pushl  0xc(%ebp)
     b04:	ff 75 08             	pushl  0x8(%ebp)
     b07:	e8 aa fe ff ff       	call   9b6 <peek>
     b0c:	83 c4 10             	add    $0x10,%esp
     b0f:	85 c0                	test   %eax,%eax
     b11:	75 c3                	jne    ad6 <parseline+0x1c>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     b13:	83 ec 04             	sub    $0x4,%esp
     b16:	68 67 18 00 00       	push   $0x1867
     b1b:	ff 75 0c             	pushl  0xc(%ebp)
     b1e:	ff 75 08             	pushl  0x8(%ebp)
     b21:	e8 90 fe ff ff       	call   9b6 <peek>
     b26:	83 c4 10             	add    $0x10,%esp
     b29:	85 c0                	test   %eax,%eax
     b2b:	74 35                	je     b62 <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     b2d:	6a 00                	push   $0x0
     b2f:	6a 00                	push   $0x0
     b31:	ff 75 0c             	pushl  0xc(%ebp)
     b34:	ff 75 08             	pushl  0x8(%ebp)
     b37:	e8 29 fd ff ff       	call   865 <gettoken>
     b3c:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     b3f:	83 ec 08             	sub    $0x8,%esp
     b42:	ff 75 0c             	pushl  0xc(%ebp)
     b45:	ff 75 08             	pushl  0x8(%ebp)
     b48:	e8 6d ff ff ff       	call   aba <parseline>
     b4d:	83 c4 10             	add    $0x10,%esp
     b50:	83 ec 08             	sub    $0x8,%esp
     b53:	50                   	push   %eax
     b54:	ff 75 f4             	pushl  -0xc(%ebp)
     b57:	e8 82 fc ff ff       	call   7de <listcmd>
     b5c:	83 c4 10             	add    $0x10,%esp
     b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b65:	c9                   	leave  
     b66:	c3                   	ret    

00000b67 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     b67:	55                   	push   %ebp
     b68:	89 e5                	mov    %esp,%ebp
     b6a:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     b6d:	83 ec 08             	sub    $0x8,%esp
     b70:	ff 75 0c             	pushl  0xc(%ebp)
     b73:	ff 75 08             	pushl  0x8(%ebp)
     b76:	e8 ec 01 00 00       	call   d67 <parseexec>
     b7b:	83 c4 10             	add    $0x10,%esp
     b7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     b81:	83 ec 04             	sub    $0x4,%esp
     b84:	68 69 18 00 00       	push   $0x1869
     b89:	ff 75 0c             	pushl  0xc(%ebp)
     b8c:	ff 75 08             	pushl  0x8(%ebp)
     b8f:	e8 22 fe ff ff       	call   9b6 <peek>
     b94:	83 c4 10             	add    $0x10,%esp
     b97:	85 c0                	test   %eax,%eax
     b99:	74 35                	je     bd0 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     b9b:	6a 00                	push   $0x0
     b9d:	6a 00                	push   $0x0
     b9f:	ff 75 0c             	pushl  0xc(%ebp)
     ba2:	ff 75 08             	pushl  0x8(%ebp)
     ba5:	e8 bb fc ff ff       	call   865 <gettoken>
     baa:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     bad:	83 ec 08             	sub    $0x8,%esp
     bb0:	ff 75 0c             	pushl  0xc(%ebp)
     bb3:	ff 75 08             	pushl  0x8(%ebp)
     bb6:	e8 ac ff ff ff       	call   b67 <parsepipe>
     bbb:	83 c4 10             	add    $0x10,%esp
     bbe:	83 ec 08             	sub    $0x8,%esp
     bc1:	50                   	push   %eax
     bc2:	ff 75 f4             	pushl  -0xc(%ebp)
     bc5:	e8 cc fb ff ff       	call   796 <pipecmd>
     bca:	83 c4 10             	add    $0x10,%esp
     bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     bd3:	c9                   	leave  
     bd4:	c3                   	ret    

00000bd5 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     bd5:	55                   	push   %ebp
     bd6:	89 e5                	mov    %esp,%ebp
     bd8:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     bdb:	e9 b6 00 00 00       	jmp    c96 <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     be0:	6a 00                	push   $0x0
     be2:	6a 00                	push   $0x0
     be4:	ff 75 10             	pushl  0x10(%ebp)
     be7:	ff 75 0c             	pushl  0xc(%ebp)
     bea:	e8 76 fc ff ff       	call   865 <gettoken>
     bef:	83 c4 10             	add    $0x10,%esp
     bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     bf5:	8d 45 ec             	lea    -0x14(%ebp),%eax
     bf8:	50                   	push   %eax
     bf9:	8d 45 f0             	lea    -0x10(%ebp),%eax
     bfc:	50                   	push   %eax
     bfd:	ff 75 10             	pushl  0x10(%ebp)
     c00:	ff 75 0c             	pushl  0xc(%ebp)
     c03:	e8 5d fc ff ff       	call   865 <gettoken>
     c08:	83 c4 10             	add    $0x10,%esp
     c0b:	83 f8 61             	cmp    $0x61,%eax
     c0e:	74 10                	je     c20 <parseredirs+0x4b>
      panic("missing file for redirection");
     c10:	83 ec 0c             	sub    $0xc,%esp
     c13:	68 6b 18 00 00       	push   $0x186b
     c18:	e8 97 fa ff ff       	call   6b4 <panic>
     c1d:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c23:	83 f8 3c             	cmp    $0x3c,%eax
     c26:	74 0c                	je     c34 <parseredirs+0x5f>
     c28:	83 f8 3e             	cmp    $0x3e,%eax
     c2b:	74 26                	je     c53 <parseredirs+0x7e>
     c2d:	83 f8 2b             	cmp    $0x2b,%eax
     c30:	74 43                	je     c75 <parseredirs+0xa0>
     c32:	eb 62                	jmp    c96 <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     c34:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c3a:	83 ec 0c             	sub    $0xc,%esp
     c3d:	6a 00                	push   $0x0
     c3f:	6a 00                	push   $0x0
     c41:	52                   	push   %edx
     c42:	50                   	push   %eax
     c43:	ff 75 08             	pushl  0x8(%ebp)
     c46:	e8 e8 fa ff ff       	call   733 <redircmd>
     c4b:	83 c4 20             	add    $0x20,%esp
     c4e:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c51:	eb 43                	jmp    c96 <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     c53:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c59:	83 ec 0c             	sub    $0xc,%esp
     c5c:	6a 01                	push   $0x1
     c5e:	68 01 02 00 00       	push   $0x201
     c63:	52                   	push   %edx
     c64:	50                   	push   %eax
     c65:	ff 75 08             	pushl  0x8(%ebp)
     c68:	e8 c6 fa ff ff       	call   733 <redircmd>
     c6d:	83 c4 20             	add    $0x20,%esp
     c70:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c73:	eb 21                	jmp    c96 <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     c75:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c7b:	83 ec 0c             	sub    $0xc,%esp
     c7e:	6a 01                	push   $0x1
     c80:	68 01 02 00 00       	push   $0x201
     c85:	52                   	push   %edx
     c86:	50                   	push   %eax
     c87:	ff 75 08             	pushl  0x8(%ebp)
     c8a:	e8 a4 fa ff ff       	call   733 <redircmd>
     c8f:	83 c4 20             	add    $0x20,%esp
     c92:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c95:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     c96:	83 ec 04             	sub    $0x4,%esp
     c99:	68 88 18 00 00       	push   $0x1888
     c9e:	ff 75 10             	pushl  0x10(%ebp)
     ca1:	ff 75 0c             	pushl  0xc(%ebp)
     ca4:	e8 0d fd ff ff       	call   9b6 <peek>
     ca9:	83 c4 10             	add    $0x10,%esp
     cac:	85 c0                	test   %eax,%eax
     cae:	0f 85 2c ff ff ff    	jne    be0 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     cb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cb7:	c9                   	leave  
     cb8:	c3                   	ret    

00000cb9 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     cb9:	55                   	push   %ebp
     cba:	89 e5                	mov    %esp,%ebp
     cbc:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     cbf:	83 ec 04             	sub    $0x4,%esp
     cc2:	68 8b 18 00 00       	push   $0x188b
     cc7:	ff 75 0c             	pushl  0xc(%ebp)
     cca:	ff 75 08             	pushl  0x8(%ebp)
     ccd:	e8 e4 fc ff ff       	call   9b6 <peek>
     cd2:	83 c4 10             	add    $0x10,%esp
     cd5:	85 c0                	test   %eax,%eax
     cd7:	75 10                	jne    ce9 <parseblock+0x30>
    panic("parseblock");
     cd9:	83 ec 0c             	sub    $0xc,%esp
     cdc:	68 8d 18 00 00       	push   $0x188d
     ce1:	e8 ce f9 ff ff       	call   6b4 <panic>
     ce6:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     ce9:	6a 00                	push   $0x0
     ceb:	6a 00                	push   $0x0
     ced:	ff 75 0c             	pushl  0xc(%ebp)
     cf0:	ff 75 08             	pushl  0x8(%ebp)
     cf3:	e8 6d fb ff ff       	call   865 <gettoken>
     cf8:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     cfb:	83 ec 08             	sub    $0x8,%esp
     cfe:	ff 75 0c             	pushl  0xc(%ebp)
     d01:	ff 75 08             	pushl  0x8(%ebp)
     d04:	e8 b1 fd ff ff       	call   aba <parseline>
     d09:	83 c4 10             	add    $0x10,%esp
     d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     d0f:	83 ec 04             	sub    $0x4,%esp
     d12:	68 98 18 00 00       	push   $0x1898
     d17:	ff 75 0c             	pushl  0xc(%ebp)
     d1a:	ff 75 08             	pushl  0x8(%ebp)
     d1d:	e8 94 fc ff ff       	call   9b6 <peek>
     d22:	83 c4 10             	add    $0x10,%esp
     d25:	85 c0                	test   %eax,%eax
     d27:	75 10                	jne    d39 <parseblock+0x80>
    panic("syntax - missing )");
     d29:	83 ec 0c             	sub    $0xc,%esp
     d2c:	68 9a 18 00 00       	push   $0x189a
     d31:	e8 7e f9 ff ff       	call   6b4 <panic>
     d36:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     d39:	6a 00                	push   $0x0
     d3b:	6a 00                	push   $0x0
     d3d:	ff 75 0c             	pushl  0xc(%ebp)
     d40:	ff 75 08             	pushl  0x8(%ebp)
     d43:	e8 1d fb ff ff       	call   865 <gettoken>
     d48:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     d4b:	83 ec 04             	sub    $0x4,%esp
     d4e:	ff 75 0c             	pushl  0xc(%ebp)
     d51:	ff 75 08             	pushl  0x8(%ebp)
     d54:	ff 75 f4             	pushl  -0xc(%ebp)
     d57:	e8 79 fe ff ff       	call   bd5 <parseredirs>
     d5c:	83 c4 10             	add    $0x10,%esp
     d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     d65:	c9                   	leave  
     d66:	c3                   	ret    

00000d67 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     d67:	55                   	push   %ebp
     d68:	89 e5                	mov    %esp,%ebp
     d6a:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     d6d:	83 ec 04             	sub    $0x4,%esp
     d70:	68 8b 18 00 00       	push   $0x188b
     d75:	ff 75 0c             	pushl  0xc(%ebp)
     d78:	ff 75 08             	pushl  0x8(%ebp)
     d7b:	e8 36 fc ff ff       	call   9b6 <peek>
     d80:	83 c4 10             	add    $0x10,%esp
     d83:	85 c0                	test   %eax,%eax
     d85:	74 16                	je     d9d <parseexec+0x36>
    return parseblock(ps, es);
     d87:	83 ec 08             	sub    $0x8,%esp
     d8a:	ff 75 0c             	pushl  0xc(%ebp)
     d8d:	ff 75 08             	pushl  0x8(%ebp)
     d90:	e8 24 ff ff ff       	call   cb9 <parseblock>
     d95:	83 c4 10             	add    $0x10,%esp
     d98:	e9 fb 00 00 00       	jmp    e98 <parseexec+0x131>

  ret = execcmd();
     d9d:	e8 5b f9 ff ff       	call   6fd <execcmd>
     da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     da8:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     dab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     db2:	83 ec 04             	sub    $0x4,%esp
     db5:	ff 75 0c             	pushl  0xc(%ebp)
     db8:	ff 75 08             	pushl  0x8(%ebp)
     dbb:	ff 75 f0             	pushl  -0x10(%ebp)
     dbe:	e8 12 fe ff ff       	call   bd5 <parseredirs>
     dc3:	83 c4 10             	add    $0x10,%esp
     dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     dc9:	e9 87 00 00 00       	jmp    e55 <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     dce:	8d 45 e0             	lea    -0x20(%ebp),%eax
     dd1:	50                   	push   %eax
     dd2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     dd5:	50                   	push   %eax
     dd6:	ff 75 0c             	pushl  0xc(%ebp)
     dd9:	ff 75 08             	pushl  0x8(%ebp)
     ddc:	e8 84 fa ff ff       	call   865 <gettoken>
     de1:	83 c4 10             	add    $0x10,%esp
     de4:	89 45 e8             	mov    %eax,-0x18(%ebp)
     de7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     deb:	0f 84 84 00 00 00    	je     e75 <parseexec+0x10e>
      break;
    if(tok != 'a')
     df1:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     df5:	74 10                	je     e07 <parseexec+0xa0>
      panic("syntax");
     df7:	83 ec 0c             	sub    $0xc,%esp
     dfa:	68 5e 18 00 00       	push   $0x185e
     dff:	e8 b0 f8 ff ff       	call   6b4 <panic>
     e04:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     e07:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e10:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     e14:	8b 55 e0             	mov    -0x20(%ebp),%edx
     e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e1a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     e1d:	83 c1 08             	add    $0x8,%ecx
     e20:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     e24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     e28:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     e2c:	7e 10                	jle    e3e <parseexec+0xd7>
      panic("too many args");
     e2e:	83 ec 0c             	sub    $0xc,%esp
     e31:	68 ad 18 00 00       	push   $0x18ad
     e36:	e8 79 f8 ff ff       	call   6b4 <panic>
     e3b:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     e3e:	83 ec 04             	sub    $0x4,%esp
     e41:	ff 75 0c             	pushl  0xc(%ebp)
     e44:	ff 75 08             	pushl  0x8(%ebp)
     e47:	ff 75 f0             	pushl  -0x10(%ebp)
     e4a:	e8 86 fd ff ff       	call   bd5 <parseredirs>
     e4f:	83 c4 10             	add    $0x10,%esp
     e52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     e55:	83 ec 04             	sub    $0x4,%esp
     e58:	68 bb 18 00 00       	push   $0x18bb
     e5d:	ff 75 0c             	pushl  0xc(%ebp)
     e60:	ff 75 08             	pushl  0x8(%ebp)
     e63:	e8 4e fb ff ff       	call   9b6 <peek>
     e68:	83 c4 10             	add    $0x10,%esp
     e6b:	85 c0                	test   %eax,%eax
     e6d:	0f 84 5b ff ff ff    	je     dce <parseexec+0x67>
     e73:	eb 01                	jmp    e76 <parseexec+0x10f>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     e75:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e7c:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     e83:	00 
  cmd->eargv[argc] = 0;
     e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e8a:	83 c2 08             	add    $0x8,%edx
     e8d:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     e94:	00 
  return ret;
     e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e98:	c9                   	leave  
     e99:	c3                   	ret    

00000e9a <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     e9a:	55                   	push   %ebp
     e9b:	89 e5                	mov    %esp,%ebp
     e9d:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     ea0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ea4:	75 0a                	jne    eb0 <nulterminate+0x16>
    return 0;
     ea6:	b8 00 00 00 00       	mov    $0x0,%eax
     eab:	e9 e4 00 00 00       	jmp    f94 <nulterminate+0xfa>
  
  switch(cmd->type){
     eb0:	8b 45 08             	mov    0x8(%ebp),%eax
     eb3:	8b 00                	mov    (%eax),%eax
     eb5:	83 f8 05             	cmp    $0x5,%eax
     eb8:	0f 87 d3 00 00 00    	ja     f91 <nulterminate+0xf7>
     ebe:	8b 04 85 c0 18 00 00 	mov    0x18c0(,%eax,4),%eax
     ec5:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     ec7:	8b 45 08             	mov    0x8(%ebp),%eax
     eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     ecd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ed4:	eb 14                	jmp    eea <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     edc:	83 c2 08             	add    $0x8,%edx
     edf:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     ee3:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     ee6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ef0:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     ef4:	85 c0                	test   %eax,%eax
     ef6:	75 de                	jne    ed6 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     ef8:	e9 94 00 00 00       	jmp    f91 <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     efd:	8b 45 08             	mov    0x8(%ebp),%eax
     f00:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f06:	8b 40 04             	mov    0x4(%eax),%eax
     f09:	83 ec 0c             	sub    $0xc,%esp
     f0c:	50                   	push   %eax
     f0d:	e8 88 ff ff ff       	call   e9a <nulterminate>
     f12:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f18:	8b 40 0c             	mov    0xc(%eax),%eax
     f1b:	c6 00 00             	movb   $0x0,(%eax)
    break;
     f1e:	eb 71                	jmp    f91 <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     f20:	8b 45 08             	mov    0x8(%ebp),%eax
     f23:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     f26:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f29:	8b 40 04             	mov    0x4(%eax),%eax
     f2c:	83 ec 0c             	sub    $0xc,%esp
     f2f:	50                   	push   %eax
     f30:	e8 65 ff ff ff       	call   e9a <nulterminate>
     f35:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     f38:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f3b:	8b 40 08             	mov    0x8(%eax),%eax
     f3e:	83 ec 0c             	sub    $0xc,%esp
     f41:	50                   	push   %eax
     f42:	e8 53 ff ff ff       	call   e9a <nulterminate>
     f47:	83 c4 10             	add    $0x10,%esp
    break;
     f4a:	eb 45                	jmp    f91 <nulterminate+0xf7>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     f4c:	8b 45 08             	mov    0x8(%ebp),%eax
     f4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f55:	8b 40 04             	mov    0x4(%eax),%eax
     f58:	83 ec 0c             	sub    $0xc,%esp
     f5b:	50                   	push   %eax
     f5c:	e8 39 ff ff ff       	call   e9a <nulterminate>
     f61:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f67:	8b 40 08             	mov    0x8(%eax),%eax
     f6a:	83 ec 0c             	sub    $0xc,%esp
     f6d:	50                   	push   %eax
     f6e:	e8 27 ff ff ff       	call   e9a <nulterminate>
     f73:	83 c4 10             	add    $0x10,%esp
    break;
     f76:	eb 19                	jmp    f91 <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     f78:	8b 45 08             	mov    0x8(%ebp),%eax
     f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     f7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f81:	8b 40 04             	mov    0x4(%eax),%eax
     f84:	83 ec 0c             	sub    $0xc,%esp
     f87:	50                   	push   %eax
     f88:	e8 0d ff ff ff       	call   e9a <nulterminate>
     f8d:	83 c4 10             	add    $0x10,%esp
    break;
     f90:	90                   	nop
  }
  return cmd;
     f91:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f94:	c9                   	leave  
     f95:	c3                   	ret    

00000f96 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     f96:	55                   	push   %ebp
     f97:	89 e5                	mov    %esp,%ebp
     f99:	57                   	push   %edi
     f9a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     f9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f9e:	8b 55 10             	mov    0x10(%ebp),%edx
     fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
     fa4:	89 cb                	mov    %ecx,%ebx
     fa6:	89 df                	mov    %ebx,%edi
     fa8:	89 d1                	mov    %edx,%ecx
     faa:	fc                   	cld    
     fab:	f3 aa                	rep stos %al,%es:(%edi)
     fad:	89 ca                	mov    %ecx,%edx
     faf:	89 fb                	mov    %edi,%ebx
     fb1:	89 5d 08             	mov    %ebx,0x8(%ebp)
     fb4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     fb7:	90                   	nop
     fb8:	5b                   	pop    %ebx
     fb9:	5f                   	pop    %edi
     fba:	5d                   	pop    %ebp
     fbb:	c3                   	ret    

00000fbc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     fbc:	55                   	push   %ebp
     fbd:	89 e5                	mov    %esp,%ebp
     fbf:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     fc2:	8b 45 08             	mov    0x8(%ebp),%eax
     fc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     fc8:	90                   	nop
     fc9:	8b 45 08             	mov    0x8(%ebp),%eax
     fcc:	8d 50 01             	lea    0x1(%eax),%edx
     fcf:	89 55 08             	mov    %edx,0x8(%ebp)
     fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
     fd5:	8d 4a 01             	lea    0x1(%edx),%ecx
     fd8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     fdb:	0f b6 12             	movzbl (%edx),%edx
     fde:	88 10                	mov    %dl,(%eax)
     fe0:	0f b6 00             	movzbl (%eax),%eax
     fe3:	84 c0                	test   %al,%al
     fe5:	75 e2                	jne    fc9 <strcpy+0xd>
    ;
  return os;
     fe7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     fea:	c9                   	leave  
     feb:	c3                   	ret    

00000fec <strcmp>:

int
strcmp(const char *p, const char *q)
{
     fec:	55                   	push   %ebp
     fed:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     fef:	eb 08                	jmp    ff9 <strcmp+0xd>
    p++, q++;
     ff1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     ff5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     ff9:	8b 45 08             	mov    0x8(%ebp),%eax
     ffc:	0f b6 00             	movzbl (%eax),%eax
     fff:	84 c0                	test   %al,%al
    1001:	74 10                	je     1013 <strcmp+0x27>
    1003:	8b 45 08             	mov    0x8(%ebp),%eax
    1006:	0f b6 10             	movzbl (%eax),%edx
    1009:	8b 45 0c             	mov    0xc(%ebp),%eax
    100c:	0f b6 00             	movzbl (%eax),%eax
    100f:	38 c2                	cmp    %al,%dl
    1011:	74 de                	je     ff1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1013:	8b 45 08             	mov    0x8(%ebp),%eax
    1016:	0f b6 00             	movzbl (%eax),%eax
    1019:	0f b6 d0             	movzbl %al,%edx
    101c:	8b 45 0c             	mov    0xc(%ebp),%eax
    101f:	0f b6 00             	movzbl (%eax),%eax
    1022:	0f b6 c0             	movzbl %al,%eax
    1025:	29 c2                	sub    %eax,%edx
    1027:	89 d0                	mov    %edx,%eax
}
    1029:	5d                   	pop    %ebp
    102a:	c3                   	ret    

0000102b <strlen>:

uint
strlen(char *s)
{
    102b:	55                   	push   %ebp
    102c:	89 e5                	mov    %esp,%ebp
    102e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1031:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1038:	eb 04                	jmp    103e <strlen+0x13>
    103a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    103e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1041:	8b 45 08             	mov    0x8(%ebp),%eax
    1044:	01 d0                	add    %edx,%eax
    1046:	0f b6 00             	movzbl (%eax),%eax
    1049:	84 c0                	test   %al,%al
    104b:	75 ed                	jne    103a <strlen+0xf>
    ;
  return n;
    104d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1050:	c9                   	leave  
    1051:	c3                   	ret    

00001052 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1052:	55                   	push   %ebp
    1053:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    1055:	8b 45 10             	mov    0x10(%ebp),%eax
    1058:	50                   	push   %eax
    1059:	ff 75 0c             	pushl  0xc(%ebp)
    105c:	ff 75 08             	pushl  0x8(%ebp)
    105f:	e8 32 ff ff ff       	call   f96 <stosb>
    1064:	83 c4 0c             	add    $0xc,%esp
  return dst;
    1067:	8b 45 08             	mov    0x8(%ebp),%eax
}
    106a:	c9                   	leave  
    106b:	c3                   	ret    

0000106c <strchr>:

char*
strchr(const char *s, char c)
{
    106c:	55                   	push   %ebp
    106d:	89 e5                	mov    %esp,%ebp
    106f:	83 ec 04             	sub    $0x4,%esp
    1072:	8b 45 0c             	mov    0xc(%ebp),%eax
    1075:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1078:	eb 14                	jmp    108e <strchr+0x22>
    if(*s == c)
    107a:	8b 45 08             	mov    0x8(%ebp),%eax
    107d:	0f b6 00             	movzbl (%eax),%eax
    1080:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1083:	75 05                	jne    108a <strchr+0x1e>
      return (char*)s;
    1085:	8b 45 08             	mov    0x8(%ebp),%eax
    1088:	eb 13                	jmp    109d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    108a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    108e:	8b 45 08             	mov    0x8(%ebp),%eax
    1091:	0f b6 00             	movzbl (%eax),%eax
    1094:	84 c0                	test   %al,%al
    1096:	75 e2                	jne    107a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1098:	b8 00 00 00 00       	mov    $0x0,%eax
}
    109d:	c9                   	leave  
    109e:	c3                   	ret    

0000109f <gets>:

char*
gets(char *buf, int max)
{
    109f:	55                   	push   %ebp
    10a0:	89 e5                	mov    %esp,%ebp
    10a2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    10a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10ac:	eb 42                	jmp    10f0 <gets+0x51>
    cc = read(0, &c, 1);
    10ae:	83 ec 04             	sub    $0x4,%esp
    10b1:	6a 01                	push   $0x1
    10b3:	8d 45 ef             	lea    -0x11(%ebp),%eax
    10b6:	50                   	push   %eax
    10b7:	6a 00                	push   $0x0
    10b9:	e8 8c 01 00 00       	call   124a <read>
    10be:	83 c4 10             	add    $0x10,%esp
    10c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    10c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10c8:	7e 33                	jle    10fd <gets+0x5e>
      break;
    buf[i++] = c;
    10ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10cd:	8d 50 01             	lea    0x1(%eax),%edx
    10d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
    10d3:	89 c2                	mov    %eax,%edx
    10d5:	8b 45 08             	mov    0x8(%ebp),%eax
    10d8:	01 c2                	add    %eax,%edx
    10da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    10de:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    10e0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    10e4:	3c 0a                	cmp    $0xa,%al
    10e6:	74 16                	je     10fe <gets+0x5f>
    10e8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    10ec:	3c 0d                	cmp    $0xd,%al
    10ee:	74 0e                	je     10fe <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    10f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10f3:	83 c0 01             	add    $0x1,%eax
    10f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
    10f9:	7c b3                	jl     10ae <gets+0xf>
    10fb:	eb 01                	jmp    10fe <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    10fd:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    10fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1101:	8b 45 08             	mov    0x8(%ebp),%eax
    1104:	01 d0                	add    %edx,%eax
    1106:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1109:	8b 45 08             	mov    0x8(%ebp),%eax
}
    110c:	c9                   	leave  
    110d:	c3                   	ret    

0000110e <stat>:

int
stat(char *n, struct stat *st)
{
    110e:	55                   	push   %ebp
    110f:	89 e5                	mov    %esp,%ebp
    1111:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1114:	83 ec 08             	sub    $0x8,%esp
    1117:	6a 00                	push   $0x0
    1119:	ff 75 08             	pushl  0x8(%ebp)
    111c:	e8 51 01 00 00       	call   1272 <open>
    1121:	83 c4 10             	add    $0x10,%esp
    1124:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1127:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    112b:	79 07                	jns    1134 <stat+0x26>
    return -1;
    112d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1132:	eb 25                	jmp    1159 <stat+0x4b>
  r = fstat(fd, st);
    1134:	83 ec 08             	sub    $0x8,%esp
    1137:	ff 75 0c             	pushl  0xc(%ebp)
    113a:	ff 75 f4             	pushl  -0xc(%ebp)
    113d:	e8 48 01 00 00       	call   128a <fstat>
    1142:	83 c4 10             	add    $0x10,%esp
    1145:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1148:	83 ec 0c             	sub    $0xc,%esp
    114b:	ff 75 f4             	pushl  -0xc(%ebp)
    114e:	e8 07 01 00 00       	call   125a <close>
    1153:	83 c4 10             	add    $0x10,%esp
  return r;
    1156:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1159:	c9                   	leave  
    115a:	c3                   	ret    

0000115b <atoi>:

int
atoi(const char *s)
{
    115b:	55                   	push   %ebp
    115c:	89 e5                	mov    %esp,%ebp
    115e:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    1161:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
    1168:	eb 04                	jmp    116e <atoi+0x13>
    116a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116e:	8b 45 08             	mov    0x8(%ebp),%eax
    1171:	0f b6 00             	movzbl (%eax),%eax
    1174:	3c 20                	cmp    $0x20,%al
    1176:	74 f2                	je     116a <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
    1178:	8b 45 08             	mov    0x8(%ebp),%eax
    117b:	0f b6 00             	movzbl (%eax),%eax
    117e:	3c 2d                	cmp    $0x2d,%al
    1180:	75 07                	jne    1189 <atoi+0x2e>
    1182:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1187:	eb 05                	jmp    118e <atoi+0x33>
    1189:	b8 01 00 00 00       	mov    $0x1,%eax
    118e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    1191:	8b 45 08             	mov    0x8(%ebp),%eax
    1194:	0f b6 00             	movzbl (%eax),%eax
    1197:	3c 2b                	cmp    $0x2b,%al
    1199:	74 0a                	je     11a5 <atoi+0x4a>
    119b:	8b 45 08             	mov    0x8(%ebp),%eax
    119e:	0f b6 00             	movzbl (%eax),%eax
    11a1:	3c 2d                	cmp    $0x2d,%al
    11a3:	75 2b                	jne    11d0 <atoi+0x75>
    s++;
    11a5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
    11a9:	eb 25                	jmp    11d0 <atoi+0x75>
    n = n*10 + *s++ - '0';
    11ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11ae:	89 d0                	mov    %edx,%eax
    11b0:	c1 e0 02             	shl    $0x2,%eax
    11b3:	01 d0                	add    %edx,%eax
    11b5:	01 c0                	add    %eax,%eax
    11b7:	89 c1                	mov    %eax,%ecx
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	8d 50 01             	lea    0x1(%eax),%edx
    11bf:	89 55 08             	mov    %edx,0x8(%ebp)
    11c2:	0f b6 00             	movzbl (%eax),%eax
    11c5:	0f be c0             	movsbl %al,%eax
    11c8:	01 c8                	add    %ecx,%eax
    11ca:	83 e8 30             	sub    $0x30,%eax
    11cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
    11d0:	8b 45 08             	mov    0x8(%ebp),%eax
    11d3:	0f b6 00             	movzbl (%eax),%eax
    11d6:	3c 2f                	cmp    $0x2f,%al
    11d8:	7e 0a                	jle    11e4 <atoi+0x89>
    11da:	8b 45 08             	mov    0x8(%ebp),%eax
    11dd:	0f b6 00             	movzbl (%eax),%eax
    11e0:	3c 39                	cmp    $0x39,%al
    11e2:	7e c7                	jle    11ab <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
    11e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11e7:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    11eb:	c9                   	leave  
    11ec:	c3                   	ret    

000011ed <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    11ed:	55                   	push   %ebp
    11ee:	89 e5                	mov    %esp,%ebp
    11f0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    11f3:	8b 45 08             	mov    0x8(%ebp),%eax
    11f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    11f9:	8b 45 0c             	mov    0xc(%ebp),%eax
    11fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    11ff:	eb 17                	jmp    1218 <memmove+0x2b>
    *dst++ = *src++;
    1201:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1204:	8d 50 01             	lea    0x1(%eax),%edx
    1207:	89 55 fc             	mov    %edx,-0x4(%ebp)
    120a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    120d:	8d 4a 01             	lea    0x1(%edx),%ecx
    1210:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1213:	0f b6 12             	movzbl (%edx),%edx
    1216:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1218:	8b 45 10             	mov    0x10(%ebp),%eax
    121b:	8d 50 ff             	lea    -0x1(%eax),%edx
    121e:	89 55 10             	mov    %edx,0x10(%ebp)
    1221:	85 c0                	test   %eax,%eax
    1223:	7f dc                	jg     1201 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1225:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1228:	c9                   	leave  
    1229:	c3                   	ret    

0000122a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    122a:	b8 01 00 00 00       	mov    $0x1,%eax
    122f:	cd 40                	int    $0x40
    1231:	c3                   	ret    

00001232 <exit>:
SYSCALL(exit)
    1232:	b8 02 00 00 00       	mov    $0x2,%eax
    1237:	cd 40                	int    $0x40
    1239:	c3                   	ret    

0000123a <wait>:
SYSCALL(wait)
    123a:	b8 03 00 00 00       	mov    $0x3,%eax
    123f:	cd 40                	int    $0x40
    1241:	c3                   	ret    

00001242 <pipe>:
SYSCALL(pipe)
    1242:	b8 04 00 00 00       	mov    $0x4,%eax
    1247:	cd 40                	int    $0x40
    1249:	c3                   	ret    

0000124a <read>:
SYSCALL(read)
    124a:	b8 05 00 00 00       	mov    $0x5,%eax
    124f:	cd 40                	int    $0x40
    1251:	c3                   	ret    

00001252 <write>:
SYSCALL(write)
    1252:	b8 10 00 00 00       	mov    $0x10,%eax
    1257:	cd 40                	int    $0x40
    1259:	c3                   	ret    

0000125a <close>:
SYSCALL(close)
    125a:	b8 15 00 00 00       	mov    $0x15,%eax
    125f:	cd 40                	int    $0x40
    1261:	c3                   	ret    

00001262 <kill>:
SYSCALL(kill)
    1262:	b8 06 00 00 00       	mov    $0x6,%eax
    1267:	cd 40                	int    $0x40
    1269:	c3                   	ret    

0000126a <exec>:
SYSCALL(exec)
    126a:	b8 07 00 00 00       	mov    $0x7,%eax
    126f:	cd 40                	int    $0x40
    1271:	c3                   	ret    

00001272 <open>:
SYSCALL(open)
    1272:	b8 0f 00 00 00       	mov    $0xf,%eax
    1277:	cd 40                	int    $0x40
    1279:	c3                   	ret    

0000127a <mknod>:
SYSCALL(mknod)
    127a:	b8 11 00 00 00       	mov    $0x11,%eax
    127f:	cd 40                	int    $0x40
    1281:	c3                   	ret    

00001282 <unlink>:
SYSCALL(unlink)
    1282:	b8 12 00 00 00       	mov    $0x12,%eax
    1287:	cd 40                	int    $0x40
    1289:	c3                   	ret    

0000128a <fstat>:
SYSCALL(fstat)
    128a:	b8 08 00 00 00       	mov    $0x8,%eax
    128f:	cd 40                	int    $0x40
    1291:	c3                   	ret    

00001292 <link>:
SYSCALL(link)
    1292:	b8 13 00 00 00       	mov    $0x13,%eax
    1297:	cd 40                	int    $0x40
    1299:	c3                   	ret    

0000129a <mkdir>:
SYSCALL(mkdir)
    129a:	b8 14 00 00 00       	mov    $0x14,%eax
    129f:	cd 40                	int    $0x40
    12a1:	c3                   	ret    

000012a2 <chdir>:
SYSCALL(chdir)
    12a2:	b8 09 00 00 00       	mov    $0x9,%eax
    12a7:	cd 40                	int    $0x40
    12a9:	c3                   	ret    

000012aa <dup>:
SYSCALL(dup)
    12aa:	b8 0a 00 00 00       	mov    $0xa,%eax
    12af:	cd 40                	int    $0x40
    12b1:	c3                   	ret    

000012b2 <getpid>:
SYSCALL(getpid)
    12b2:	b8 0b 00 00 00       	mov    $0xb,%eax
    12b7:	cd 40                	int    $0x40
    12b9:	c3                   	ret    

000012ba <sbrk>:
SYSCALL(sbrk)
    12ba:	b8 0c 00 00 00       	mov    $0xc,%eax
    12bf:	cd 40                	int    $0x40
    12c1:	c3                   	ret    

000012c2 <sleep>:
SYSCALL(sleep)
    12c2:	b8 0d 00 00 00       	mov    $0xd,%eax
    12c7:	cd 40                	int    $0x40
    12c9:	c3                   	ret    

000012ca <uptime>:
SYSCALL(uptime)
    12ca:	b8 0e 00 00 00       	mov    $0xe,%eax
    12cf:	cd 40                	int    $0x40
    12d1:	c3                   	ret    

000012d2 <halt>:
SYSCALL(halt)
    12d2:	b8 16 00 00 00       	mov    $0x16,%eax
    12d7:	cd 40                	int    $0x40
    12d9:	c3                   	ret    

000012da <date>:
SYSCALL(date)      #p1
    12da:	b8 17 00 00 00       	mov    $0x17,%eax
    12df:	cd 40                	int    $0x40
    12e1:	c3                   	ret    

000012e2 <getuid>:
SYSCALL(getuid)    #p2
    12e2:	b8 18 00 00 00       	mov    $0x18,%eax
    12e7:	cd 40                	int    $0x40
    12e9:	c3                   	ret    

000012ea <getgid>:
SYSCALL(getgid)    #p2
    12ea:	b8 19 00 00 00       	mov    $0x19,%eax
    12ef:	cd 40                	int    $0x40
    12f1:	c3                   	ret    

000012f2 <getppid>:
SYSCALL(getppid)   #p2
    12f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
    12f7:	cd 40                	int    $0x40
    12f9:	c3                   	ret    

000012fa <setuid>:
SYSCALL(setuid)    #p2
    12fa:	b8 1b 00 00 00       	mov    $0x1b,%eax
    12ff:	cd 40                	int    $0x40
    1301:	c3                   	ret    

00001302 <setgid>:
SYSCALL(setgid)    #p2
    1302:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1307:	cd 40                	int    $0x40
    1309:	c3                   	ret    

0000130a <getprocs>:
SYSCALL(getprocs)  #p2
    130a:	b8 1d 00 00 00       	mov    $0x1d,%eax
    130f:	cd 40                	int    $0x40
    1311:	c3                   	ret    

00001312 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1312:	55                   	push   %ebp
    1313:	89 e5                	mov    %esp,%ebp
    1315:	83 ec 18             	sub    $0x18,%esp
    1318:	8b 45 0c             	mov    0xc(%ebp),%eax
    131b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    131e:	83 ec 04             	sub    $0x4,%esp
    1321:	6a 01                	push   $0x1
    1323:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1326:	50                   	push   %eax
    1327:	ff 75 08             	pushl  0x8(%ebp)
    132a:	e8 23 ff ff ff       	call   1252 <write>
    132f:	83 c4 10             	add    $0x10,%esp
}
    1332:	90                   	nop
    1333:	c9                   	leave  
    1334:	c3                   	ret    

00001335 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1335:	55                   	push   %ebp
    1336:	89 e5                	mov    %esp,%ebp
    1338:	53                   	push   %ebx
    1339:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    133c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1343:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1347:	74 17                	je     1360 <printint+0x2b>
    1349:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    134d:	79 11                	jns    1360 <printint+0x2b>
    neg = 1;
    134f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1356:	8b 45 0c             	mov    0xc(%ebp),%eax
    1359:	f7 d8                	neg    %eax
    135b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    135e:	eb 06                	jmp    1366 <printint+0x31>
  } else {
    x = xx;
    1360:	8b 45 0c             	mov    0xc(%ebp),%eax
    1363:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1366:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    136d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1370:	8d 41 01             	lea    0x1(%ecx),%eax
    1373:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1376:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1379:	8b 45 ec             	mov    -0x14(%ebp),%eax
    137c:	ba 00 00 00 00       	mov    $0x0,%edx
    1381:	f7 f3                	div    %ebx
    1383:	89 d0                	mov    %edx,%eax
    1385:	0f b6 80 28 1e 00 00 	movzbl 0x1e28(%eax),%eax
    138c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1390:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1393:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1396:	ba 00 00 00 00       	mov    $0x0,%edx
    139b:	f7 f3                	div    %ebx
    139d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13a4:	75 c7                	jne    136d <printint+0x38>
  if(neg)
    13a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13aa:	74 2d                	je     13d9 <printint+0xa4>
    buf[i++] = '-';
    13ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13af:	8d 50 01             	lea    0x1(%eax),%edx
    13b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
    13b5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    13ba:	eb 1d                	jmp    13d9 <printint+0xa4>
    putc(fd, buf[i]);
    13bc:	8d 55 dc             	lea    -0x24(%ebp),%edx
    13bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13c2:	01 d0                	add    %edx,%eax
    13c4:	0f b6 00             	movzbl (%eax),%eax
    13c7:	0f be c0             	movsbl %al,%eax
    13ca:	83 ec 08             	sub    $0x8,%esp
    13cd:	50                   	push   %eax
    13ce:	ff 75 08             	pushl  0x8(%ebp)
    13d1:	e8 3c ff ff ff       	call   1312 <putc>
    13d6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    13d9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    13dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13e1:	79 d9                	jns    13bc <printint+0x87>
    putc(fd, buf[i]);
}
    13e3:	90                   	nop
    13e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    13e7:	c9                   	leave  
    13e8:	c3                   	ret    

000013e9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    13e9:	55                   	push   %ebp
    13ea:	89 e5                	mov    %esp,%ebp
    13ec:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    13ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    13f6:	8d 45 0c             	lea    0xc(%ebp),%eax
    13f9:	83 c0 04             	add    $0x4,%eax
    13fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    13ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1406:	e9 59 01 00 00       	jmp    1564 <printf+0x17b>
    c = fmt[i] & 0xff;
    140b:	8b 55 0c             	mov    0xc(%ebp),%edx
    140e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1411:	01 d0                	add    %edx,%eax
    1413:	0f b6 00             	movzbl (%eax),%eax
    1416:	0f be c0             	movsbl %al,%eax
    1419:	25 ff 00 00 00       	and    $0xff,%eax
    141e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1421:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1425:	75 2c                	jne    1453 <printf+0x6a>
      if(c == '%'){
    1427:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    142b:	75 0c                	jne    1439 <printf+0x50>
        state = '%';
    142d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1434:	e9 27 01 00 00       	jmp    1560 <printf+0x177>
      } else {
        putc(fd, c);
    1439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    143c:	0f be c0             	movsbl %al,%eax
    143f:	83 ec 08             	sub    $0x8,%esp
    1442:	50                   	push   %eax
    1443:	ff 75 08             	pushl  0x8(%ebp)
    1446:	e8 c7 fe ff ff       	call   1312 <putc>
    144b:	83 c4 10             	add    $0x10,%esp
    144e:	e9 0d 01 00 00       	jmp    1560 <printf+0x177>
      }
    } else if(state == '%'){
    1453:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1457:	0f 85 03 01 00 00    	jne    1560 <printf+0x177>
      if(c == 'd'){
    145d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1461:	75 1e                	jne    1481 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1463:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1466:	8b 00                	mov    (%eax),%eax
    1468:	6a 01                	push   $0x1
    146a:	6a 0a                	push   $0xa
    146c:	50                   	push   %eax
    146d:	ff 75 08             	pushl  0x8(%ebp)
    1470:	e8 c0 fe ff ff       	call   1335 <printint>
    1475:	83 c4 10             	add    $0x10,%esp
        ap++;
    1478:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    147c:	e9 d8 00 00 00       	jmp    1559 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    1481:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1485:	74 06                	je     148d <printf+0xa4>
    1487:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    148b:	75 1e                	jne    14ab <printf+0xc2>
        printint(fd, *ap, 16, 0);
    148d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1490:	8b 00                	mov    (%eax),%eax
    1492:	6a 00                	push   $0x0
    1494:	6a 10                	push   $0x10
    1496:	50                   	push   %eax
    1497:	ff 75 08             	pushl  0x8(%ebp)
    149a:	e8 96 fe ff ff       	call   1335 <printint>
    149f:	83 c4 10             	add    $0x10,%esp
        ap++;
    14a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14a6:	e9 ae 00 00 00       	jmp    1559 <printf+0x170>
      } else if(c == 's'){
    14ab:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    14af:	75 43                	jne    14f4 <printf+0x10b>
        s = (char*)*ap;
    14b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14b4:	8b 00                	mov    (%eax),%eax
    14b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    14b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    14bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14c1:	75 25                	jne    14e8 <printf+0xff>
          s = "(null)";
    14c3:	c7 45 f4 d8 18 00 00 	movl   $0x18d8,-0xc(%ebp)
        while(*s != 0){
    14ca:	eb 1c                	jmp    14e8 <printf+0xff>
          putc(fd, *s);
    14cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14cf:	0f b6 00             	movzbl (%eax),%eax
    14d2:	0f be c0             	movsbl %al,%eax
    14d5:	83 ec 08             	sub    $0x8,%esp
    14d8:	50                   	push   %eax
    14d9:	ff 75 08             	pushl  0x8(%ebp)
    14dc:	e8 31 fe ff ff       	call   1312 <putc>
    14e1:	83 c4 10             	add    $0x10,%esp
          s++;
    14e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    14e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14eb:	0f b6 00             	movzbl (%eax),%eax
    14ee:	84 c0                	test   %al,%al
    14f0:	75 da                	jne    14cc <printf+0xe3>
    14f2:	eb 65                	jmp    1559 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14f4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    14f8:	75 1d                	jne    1517 <printf+0x12e>
        putc(fd, *ap);
    14fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14fd:	8b 00                	mov    (%eax),%eax
    14ff:	0f be c0             	movsbl %al,%eax
    1502:	83 ec 08             	sub    $0x8,%esp
    1505:	50                   	push   %eax
    1506:	ff 75 08             	pushl  0x8(%ebp)
    1509:	e8 04 fe ff ff       	call   1312 <putc>
    150e:	83 c4 10             	add    $0x10,%esp
        ap++;
    1511:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1515:	eb 42                	jmp    1559 <printf+0x170>
      } else if(c == '%'){
    1517:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    151b:	75 17                	jne    1534 <printf+0x14b>
        putc(fd, c);
    151d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1520:	0f be c0             	movsbl %al,%eax
    1523:	83 ec 08             	sub    $0x8,%esp
    1526:	50                   	push   %eax
    1527:	ff 75 08             	pushl  0x8(%ebp)
    152a:	e8 e3 fd ff ff       	call   1312 <putc>
    152f:	83 c4 10             	add    $0x10,%esp
    1532:	eb 25                	jmp    1559 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1534:	83 ec 08             	sub    $0x8,%esp
    1537:	6a 25                	push   $0x25
    1539:	ff 75 08             	pushl  0x8(%ebp)
    153c:	e8 d1 fd ff ff       	call   1312 <putc>
    1541:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1547:	0f be c0             	movsbl %al,%eax
    154a:	83 ec 08             	sub    $0x8,%esp
    154d:	50                   	push   %eax
    154e:	ff 75 08             	pushl  0x8(%ebp)
    1551:	e8 bc fd ff ff       	call   1312 <putc>
    1556:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1559:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1560:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1564:	8b 55 0c             	mov    0xc(%ebp),%edx
    1567:	8b 45 f0             	mov    -0x10(%ebp),%eax
    156a:	01 d0                	add    %edx,%eax
    156c:	0f b6 00             	movzbl (%eax),%eax
    156f:	84 c0                	test   %al,%al
    1571:	0f 85 94 fe ff ff    	jne    140b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1577:	90                   	nop
    1578:	c9                   	leave  
    1579:	c3                   	ret    

0000157a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    157a:	55                   	push   %ebp
    157b:	89 e5                	mov    %esp,%ebp
    157d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1580:	8b 45 08             	mov    0x8(%ebp),%eax
    1583:	83 e8 08             	sub    $0x8,%eax
    1586:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1589:	a1 ac 1e 00 00       	mov    0x1eac,%eax
    158e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1591:	eb 24                	jmp    15b7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1593:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1596:	8b 00                	mov    (%eax),%eax
    1598:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    159b:	77 12                	ja     15af <free+0x35>
    159d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15a3:	77 24                	ja     15c9 <free+0x4f>
    15a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15a8:	8b 00                	mov    (%eax),%eax
    15aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15ad:	77 1a                	ja     15c9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15b2:	8b 00                	mov    (%eax),%eax
    15b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15bd:	76 d4                	jbe    1593 <free+0x19>
    15bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15c2:	8b 00                	mov    (%eax),%eax
    15c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15c7:	76 ca                	jbe    1593 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    15c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15cc:	8b 40 04             	mov    0x4(%eax),%eax
    15cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    15d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15d9:	01 c2                	add    %eax,%edx
    15db:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15de:	8b 00                	mov    (%eax),%eax
    15e0:	39 c2                	cmp    %eax,%edx
    15e2:	75 24                	jne    1608 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    15e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15e7:	8b 50 04             	mov    0x4(%eax),%edx
    15ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15ed:	8b 00                	mov    (%eax),%eax
    15ef:	8b 40 04             	mov    0x4(%eax),%eax
    15f2:	01 c2                	add    %eax,%edx
    15f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15f7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    15fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15fd:	8b 00                	mov    (%eax),%eax
    15ff:	8b 10                	mov    (%eax),%edx
    1601:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1604:	89 10                	mov    %edx,(%eax)
    1606:	eb 0a                	jmp    1612 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1608:	8b 45 fc             	mov    -0x4(%ebp),%eax
    160b:	8b 10                	mov    (%eax),%edx
    160d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1610:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1612:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1615:	8b 40 04             	mov    0x4(%eax),%eax
    1618:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    161f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1622:	01 d0                	add    %edx,%eax
    1624:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1627:	75 20                	jne    1649 <free+0xcf>
    p->s.size += bp->s.size;
    1629:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162c:	8b 50 04             	mov    0x4(%eax),%edx
    162f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1632:	8b 40 04             	mov    0x4(%eax),%eax
    1635:	01 c2                	add    %eax,%edx
    1637:	8b 45 fc             	mov    -0x4(%ebp),%eax
    163a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    163d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1640:	8b 10                	mov    (%eax),%edx
    1642:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1645:	89 10                	mov    %edx,(%eax)
    1647:	eb 08                	jmp    1651 <free+0xd7>
  } else
    p->s.ptr = bp;
    1649:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    164f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1651:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1654:	a3 ac 1e 00 00       	mov    %eax,0x1eac
}
    1659:	90                   	nop
    165a:	c9                   	leave  
    165b:	c3                   	ret    

0000165c <morecore>:

static Header*
morecore(uint nu)
{
    165c:	55                   	push   %ebp
    165d:	89 e5                	mov    %esp,%ebp
    165f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1662:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1669:	77 07                	ja     1672 <morecore+0x16>
    nu = 4096;
    166b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1672:	8b 45 08             	mov    0x8(%ebp),%eax
    1675:	c1 e0 03             	shl    $0x3,%eax
    1678:	83 ec 0c             	sub    $0xc,%esp
    167b:	50                   	push   %eax
    167c:	e8 39 fc ff ff       	call   12ba <sbrk>
    1681:	83 c4 10             	add    $0x10,%esp
    1684:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1687:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    168b:	75 07                	jne    1694 <morecore+0x38>
    return 0;
    168d:	b8 00 00 00 00       	mov    $0x0,%eax
    1692:	eb 26                	jmp    16ba <morecore+0x5e>
  hp = (Header*)p;
    1694:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1697:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    169d:	8b 55 08             	mov    0x8(%ebp),%edx
    16a0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    16a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16a6:	83 c0 08             	add    $0x8,%eax
    16a9:	83 ec 0c             	sub    $0xc,%esp
    16ac:	50                   	push   %eax
    16ad:	e8 c8 fe ff ff       	call   157a <free>
    16b2:	83 c4 10             	add    $0x10,%esp
  return freep;
    16b5:	a1 ac 1e 00 00       	mov    0x1eac,%eax
}
    16ba:	c9                   	leave  
    16bb:	c3                   	ret    

000016bc <malloc>:

void*
malloc(uint nbytes)
{
    16bc:	55                   	push   %ebp
    16bd:	89 e5                	mov    %esp,%ebp
    16bf:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16c2:	8b 45 08             	mov    0x8(%ebp),%eax
    16c5:	83 c0 07             	add    $0x7,%eax
    16c8:	c1 e8 03             	shr    $0x3,%eax
    16cb:	83 c0 01             	add    $0x1,%eax
    16ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    16d1:	a1 ac 1e 00 00       	mov    0x1eac,%eax
    16d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    16d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    16dd:	75 23                	jne    1702 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    16df:	c7 45 f0 a4 1e 00 00 	movl   $0x1ea4,-0x10(%ebp)
    16e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16e9:	a3 ac 1e 00 00       	mov    %eax,0x1eac
    16ee:	a1 ac 1e 00 00       	mov    0x1eac,%eax
    16f3:	a3 a4 1e 00 00       	mov    %eax,0x1ea4
    base.s.size = 0;
    16f8:	c7 05 a8 1e 00 00 00 	movl   $0x0,0x1ea8
    16ff:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1702:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1705:	8b 00                	mov    (%eax),%eax
    1707:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    170a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    170d:	8b 40 04             	mov    0x4(%eax),%eax
    1710:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1713:	72 4d                	jb     1762 <malloc+0xa6>
      if(p->s.size == nunits)
    1715:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1718:	8b 40 04             	mov    0x4(%eax),%eax
    171b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    171e:	75 0c                	jne    172c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1720:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1723:	8b 10                	mov    (%eax),%edx
    1725:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1728:	89 10                	mov    %edx,(%eax)
    172a:	eb 26                	jmp    1752 <malloc+0x96>
      else {
        p->s.size -= nunits;
    172c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    172f:	8b 40 04             	mov    0x4(%eax),%eax
    1732:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1735:	89 c2                	mov    %eax,%edx
    1737:	8b 45 f4             	mov    -0xc(%ebp),%eax
    173a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    173d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1740:	8b 40 04             	mov    0x4(%eax),%eax
    1743:	c1 e0 03             	shl    $0x3,%eax
    1746:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1749:	8b 45 f4             	mov    -0xc(%ebp),%eax
    174c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    174f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1752:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1755:	a3 ac 1e 00 00       	mov    %eax,0x1eac
      return (void*)(p + 1);
    175a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    175d:	83 c0 08             	add    $0x8,%eax
    1760:	eb 3b                	jmp    179d <malloc+0xe1>
    }
    if(p == freep)
    1762:	a1 ac 1e 00 00       	mov    0x1eac,%eax
    1767:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    176a:	75 1e                	jne    178a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    176c:	83 ec 0c             	sub    $0xc,%esp
    176f:	ff 75 ec             	pushl  -0x14(%ebp)
    1772:	e8 e5 fe ff ff       	call   165c <morecore>
    1777:	83 c4 10             	add    $0x10,%esp
    177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    177d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1781:	75 07                	jne    178a <malloc+0xce>
        return 0;
    1783:	b8 00 00 00 00       	mov    $0x0,%eax
    1788:	eb 13                	jmp    179d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    178a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    178d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1790:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1793:	8b 00                	mov    (%eax),%eax
    1795:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1798:	e9 6d ff ff ff       	jmp    170a <malloc+0x4e>
}
    179d:	c9                   	leave  
    179e:	c3                   	ret    
