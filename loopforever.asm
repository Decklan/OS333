
_loopforever:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#define TPS 100

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, max = 7;
  11:	c7 45 ec 07 00 00 00 	movl   $0x7,-0x14(%ebp)
  unsigned long x = 0;
  18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  for (int i=0; i<max; i++) {
  1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  26:	eb 59                	jmp    81 <main+0x81>
    sleep(5*TPS);  // pause before each child starts
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	68 f4 01 00 00       	push   $0x1f4
  30:	e8 5b 04 00 00       	call   490 <sleep>
  35:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  38:	e8 bb 03 00 00       	call   3f8 <fork>
  3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (pid < 0) {
  40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  44:	79 17                	jns    5d <main+0x5d>
      printf(2, "fork failed!\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 8d 09 00 00       	push   $0x98d
  4e:	6a 02                	push   $0x2
  50:	e8 82 05 00 00       	call   5d7 <printf>
  55:	83 c4 10             	add    $0x10,%esp
      exit();
  58:	e8 a3 03 00 00       	call   400 <exit>
    }

    if (pid == 0) { // child
  5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  61:	75 1a                	jne    7d <main+0x7d>
      sleep(getpid()*100); // stagger start
  63:	e8 18 04 00 00       	call   480 <getpid>
  68:	6b c0 64             	imul   $0x64,%eax,%eax
  6b:	83 ec 0c             	sub    $0xc,%esp
  6e:	50                   	push   %eax
  6f:	e8 1c 04 00 00       	call   490 <sleep>
  74:	83 c4 10             	add    $0x10,%esp
      do {
	x += 1;
  77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } while (1);
  7b:	eb fa                	jmp    77 <main+0x77>
main(void)
{
  int pid, max = 7;
  unsigned long x = 0;

  for (int i=0; i<max; i++) {
  7d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  84:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  87:	7c 9f                	jl     28 <main+0x28>
      printf(1, "Child %d exiting\n", getpid());
      exit();
    }
  }

  pid = fork();
  89:	e8 6a 03 00 00       	call   3f8 <fork>
  8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (pid == 0) {
  91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  95:	75 13                	jne    aa <main+0xaa>
    sleep(20);
  97:	83 ec 0c             	sub    $0xc,%esp
  9a:	6a 14                	push   $0x14
  9c:	e8 ef 03 00 00       	call   490 <sleep>
  a1:	83 c4 10             	add    $0x10,%esp
    do {
      x = x+1;
  a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    } while (1);
  a8:	eb fa                	jmp    a4 <main+0xa4>
  }

  sleep(15*TPS);
  aa:	83 ec 0c             	sub    $0xc,%esp
  ad:	68 dc 05 00 00       	push   $0x5dc
  b2:	e8 d9 03 00 00       	call   490 <sleep>
  b7:	83 c4 10             	add    $0x10,%esp
  wait();
  ba:	e8 49 03 00 00       	call   408 <wait>
  printf(1, "Parent exiting\n");
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	68 9b 09 00 00       	push   $0x99b
  c7:	6a 01                	push   $0x1
  c9:	e8 09 05 00 00       	call   5d7 <printf>
  ce:	83 c4 10             	add    $0x10,%esp
  exit();
  d1:	e8 2a 03 00 00       	call   400 <exit>

000000d6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  d9:	57                   	push   %edi
  da:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  de:	8b 55 10             	mov    0x10(%ebp),%edx
  e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  e4:	89 cb                	mov    %ecx,%ebx
  e6:	89 df                	mov    %ebx,%edi
  e8:	89 d1                	mov    %edx,%ecx
  ea:	fc                   	cld    
  eb:	f3 aa                	rep stos %al,%es:(%edi)
  ed:	89 ca                	mov    %ecx,%edx
  ef:	89 fb                	mov    %edi,%ebx
  f1:	89 5d 08             	mov    %ebx,0x8(%ebp)
  f4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  f7:	90                   	nop
  f8:	5b                   	pop    %ebx
  f9:	5f                   	pop    %edi
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret    

000000fc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 108:	90                   	nop
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	8d 50 01             	lea    0x1(%eax),%edx
 10f:	89 55 08             	mov    %edx,0x8(%ebp)
 112:	8b 55 0c             	mov    0xc(%ebp),%edx
 115:	8d 4a 01             	lea    0x1(%edx),%ecx
 118:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 11b:	0f b6 12             	movzbl (%edx),%edx
 11e:	88 10                	mov    %dl,(%eax)
 120:	0f b6 00             	movzbl (%eax),%eax
 123:	84 c0                	test   %al,%al
 125:	75 e2                	jne    109 <strcpy+0xd>
    ;
  return os;
 127:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12a:	c9                   	leave  
 12b:	c3                   	ret    

0000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 12f:	eb 08                	jmp    139 <strcmp+0xd>
    p++, q++;
 131:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 135:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	0f b6 00             	movzbl (%eax),%eax
 13f:	84 c0                	test   %al,%al
 141:	74 10                	je     153 <strcmp+0x27>
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 10             	movzbl (%eax),%edx
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	38 c2                	cmp    %al,%dl
 151:	74 de                	je     131 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	0f b6 d0             	movzbl %al,%edx
 15c:	8b 45 0c             	mov    0xc(%ebp),%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	0f b6 c0             	movzbl %al,%eax
 165:	29 c2                	sub    %eax,%edx
 167:	89 d0                	mov    %edx,%eax
}
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <strlen>:

uint
strlen(char *s)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 178:	eb 04                	jmp    17e <strlen+0x13>
 17a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 17e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	01 d0                	add    %edx,%eax
 186:	0f b6 00             	movzbl (%eax),%eax
 189:	84 c0                	test   %al,%al
 18b:	75 ed                	jne    17a <strlen+0xf>
    ;
  return n;
 18d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 190:	c9                   	leave  
 191:	c3                   	ret    

00000192 <memset>:

void*
memset(void *dst, int c, uint n)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 195:	8b 45 10             	mov    0x10(%ebp),%eax
 198:	50                   	push   %eax
 199:	ff 75 0c             	pushl  0xc(%ebp)
 19c:	ff 75 08             	pushl  0x8(%ebp)
 19f:	e8 32 ff ff ff       	call   d6 <stosb>
 1a4:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1aa:	c9                   	leave  
 1ab:	c3                   	ret    

000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	83 ec 04             	sub    $0x4,%esp
 1b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b8:	eb 14                	jmp    1ce <strchr+0x22>
    if(*s == c)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c3:	75 05                	jne    1ca <strchr+0x1e>
      return (char*)s;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
 1c8:	eb 13                	jmp    1dd <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	0f b6 00             	movzbl (%eax),%eax
 1d4:	84 c0                	test   %al,%al
 1d6:	75 e2                	jne    1ba <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1dd:	c9                   	leave  
 1de:	c3                   	ret    

000001df <gets>:

char*
gets(char *buf, int max)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ec:	eb 42                	jmp    230 <gets+0x51>
    cc = read(0, &c, 1);
 1ee:	83 ec 04             	sub    $0x4,%esp
 1f1:	6a 01                	push   $0x1
 1f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f6:	50                   	push   %eax
 1f7:	6a 00                	push   $0x0
 1f9:	e8 1a 02 00 00       	call   418 <read>
 1fe:	83 c4 10             	add    $0x10,%esp
 201:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 204:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 208:	7e 33                	jle    23d <gets+0x5e>
      break;
    buf[i++] = c;
 20a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20d:	8d 50 01             	lea    0x1(%eax),%edx
 210:	89 55 f4             	mov    %edx,-0xc(%ebp)
 213:	89 c2                	mov    %eax,%edx
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	01 c2                	add    %eax,%edx
 21a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 220:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 224:	3c 0a                	cmp    $0xa,%al
 226:	74 16                	je     23e <gets+0x5f>
 228:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22c:	3c 0d                	cmp    $0xd,%al
 22e:	74 0e                	je     23e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	8b 45 f4             	mov    -0xc(%ebp),%eax
 233:	83 c0 01             	add    $0x1,%eax
 236:	3b 45 0c             	cmp    0xc(%ebp),%eax
 239:	7c b3                	jl     1ee <gets+0xf>
 23b:	eb 01                	jmp    23e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 23d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 23e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	01 d0                	add    %edx,%eax
 246:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 249:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <stat>:

int
stat(char *n, struct stat *st)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	83 ec 08             	sub    $0x8,%esp
 257:	6a 00                	push   $0x0
 259:	ff 75 08             	pushl  0x8(%ebp)
 25c:	e8 df 01 00 00       	call   440 <open>
 261:	83 c4 10             	add    $0x10,%esp
 264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 26b:	79 07                	jns    274 <stat+0x26>
    return -1;
 26d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 272:	eb 25                	jmp    299 <stat+0x4b>
  r = fstat(fd, st);
 274:	83 ec 08             	sub    $0x8,%esp
 277:	ff 75 0c             	pushl  0xc(%ebp)
 27a:	ff 75 f4             	pushl  -0xc(%ebp)
 27d:	e8 d6 01 00 00       	call   458 <fstat>
 282:	83 c4 10             	add    $0x10,%esp
 285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 288:	83 ec 0c             	sub    $0xc,%esp
 28b:	ff 75 f4             	pushl  -0xc(%ebp)
 28e:	e8 95 01 00 00       	call   428 <close>
 293:	83 c4 10             	add    $0x10,%esp
  return r;
 296:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 299:	c9                   	leave  
 29a:	c3                   	ret    

0000029b <atoi>:

int
atoi(const char *s)
{
 29b:	55                   	push   %ebp
 29c:	89 e5                	mov    %esp,%ebp
 29e:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 2a8:	eb 04                	jmp    2ae <atoi+0x13>
 2aa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	3c 20                	cmp    $0x20,%al
 2b6:	74 f2                	je     2aa <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	3c 2d                	cmp    $0x2d,%al
 2c0:	75 07                	jne    2c9 <atoi+0x2e>
 2c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c7:	eb 05                	jmp    2ce <atoi+0x33>
 2c9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 00             	movzbl (%eax),%eax
 2d7:	3c 2b                	cmp    $0x2b,%al
 2d9:	74 0a                	je     2e5 <atoi+0x4a>
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	3c 2d                	cmp    $0x2d,%al
 2e3:	75 2b                	jne    310 <atoi+0x75>
    s++;
 2e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2e9:	eb 25                	jmp    310 <atoi+0x75>
    n = n*10 + *s++ - '0';
 2eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ee:	89 d0                	mov    %edx,%eax
 2f0:	c1 e0 02             	shl    $0x2,%eax
 2f3:	01 d0                	add    %edx,%eax
 2f5:	01 c0                	add    %eax,%eax
 2f7:	89 c1                	mov    %eax,%ecx
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	8d 50 01             	lea    0x1(%eax),%edx
 2ff:	89 55 08             	mov    %edx,0x8(%ebp)
 302:	0f b6 00             	movzbl (%eax),%eax
 305:	0f be c0             	movsbl %al,%eax
 308:	01 c8                	add    %ecx,%eax
 30a:	83 e8 30             	sub    $0x30,%eax
 30d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	0f b6 00             	movzbl (%eax),%eax
 316:	3c 2f                	cmp    $0x2f,%al
 318:	7e 0a                	jle    324 <atoi+0x89>
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
 31d:	0f b6 00             	movzbl (%eax),%eax
 320:	3c 39                	cmp    $0x39,%al
 322:	7e c7                	jle    2eb <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 324:	8b 45 f8             	mov    -0x8(%ebp),%eax
 327:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 32b:	c9                   	leave  
 32c:	c3                   	ret    

0000032d <atoo>:

int
atoo(const char *s)
{
 32d:	55                   	push   %ebp
 32e:	89 e5                	mov    %esp,%ebp
 330:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 333:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 33a:	eb 04                	jmp    340 <atoo+0x13>
 33c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	0f b6 00             	movzbl (%eax),%eax
 346:	3c 20                	cmp    $0x20,%al
 348:	74 f2                	je     33c <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	0f b6 00             	movzbl (%eax),%eax
 350:	3c 2d                	cmp    $0x2d,%al
 352:	75 07                	jne    35b <atoo+0x2e>
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 05                	jmp    360 <atoo+0x33>
 35b:	b8 01 00 00 00       	mov    $0x1,%eax
 360:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	0f b6 00             	movzbl (%eax),%eax
 369:	3c 2b                	cmp    $0x2b,%al
 36b:	74 0a                	je     377 <atoo+0x4a>
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	0f b6 00             	movzbl (%eax),%eax
 373:	3c 2d                	cmp    $0x2d,%al
 375:	75 27                	jne    39e <atoo+0x71>
    s++;
 377:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 37b:	eb 21                	jmp    39e <atoo+0x71>
    n = n*8 + *s++ - '0';
 37d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 380:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	8d 50 01             	lea    0x1(%eax),%edx
 38d:	89 55 08             	mov    %edx,0x8(%ebp)
 390:	0f b6 00             	movzbl (%eax),%eax
 393:	0f be c0             	movsbl %al,%eax
 396:	01 c8                	add    %ecx,%eax
 398:	83 e8 30             	sub    $0x30,%eax
 39b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	3c 2f                	cmp    $0x2f,%al
 3a6:	7e 0a                	jle    3b2 <atoo+0x85>
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	3c 37                	cmp    $0x37,%al
 3b0:	7e cb                	jle    37d <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3b5:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3b9:	c9                   	leave  
 3ba:	c3                   	ret    

000003bb <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3bb:	55                   	push   %ebp
 3bc:	89 e5                	mov    %esp,%ebp
 3be:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3cd:	eb 17                	jmp    3e6 <memmove+0x2b>
    *dst++ = *src++;
 3cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d2:	8d 50 01             	lea    0x1(%eax),%edx
 3d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3d8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3db:	8d 4a 01             	lea    0x1(%edx),%ecx
 3de:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3e1:	0f b6 12             	movzbl (%edx),%edx
 3e4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3e6:	8b 45 10             	mov    0x10(%ebp),%eax
 3e9:	8d 50 ff             	lea    -0x1(%eax),%edx
 3ec:	89 55 10             	mov    %edx,0x10(%ebp)
 3ef:	85 c0                	test   %eax,%eax
 3f1:	7f dc                	jg     3cf <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f6:	c9                   	leave  
 3f7:	c3                   	ret    

000003f8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f8:	b8 01 00 00 00       	mov    $0x1,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <exit>:
SYSCALL(exit)
 400:	b8 02 00 00 00       	mov    $0x2,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <wait>:
SYSCALL(wait)
 408:	b8 03 00 00 00       	mov    $0x3,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <pipe>:
SYSCALL(pipe)
 410:	b8 04 00 00 00       	mov    $0x4,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <read>:
SYSCALL(read)
 418:	b8 05 00 00 00       	mov    $0x5,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <write>:
SYSCALL(write)
 420:	b8 10 00 00 00       	mov    $0x10,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <close>:
SYSCALL(close)
 428:	b8 15 00 00 00       	mov    $0x15,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <kill>:
SYSCALL(kill)
 430:	b8 06 00 00 00       	mov    $0x6,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <exec>:
SYSCALL(exec)
 438:	b8 07 00 00 00       	mov    $0x7,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <open>:
SYSCALL(open)
 440:	b8 0f 00 00 00       	mov    $0xf,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <mknod>:
SYSCALL(mknod)
 448:	b8 11 00 00 00       	mov    $0x11,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <unlink>:
SYSCALL(unlink)
 450:	b8 12 00 00 00       	mov    $0x12,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <fstat>:
SYSCALL(fstat)
 458:	b8 08 00 00 00       	mov    $0x8,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <link>:
SYSCALL(link)
 460:	b8 13 00 00 00       	mov    $0x13,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <mkdir>:
SYSCALL(mkdir)
 468:	b8 14 00 00 00       	mov    $0x14,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <chdir>:
SYSCALL(chdir)
 470:	b8 09 00 00 00       	mov    $0x9,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <dup>:
SYSCALL(dup)
 478:	b8 0a 00 00 00       	mov    $0xa,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <getpid>:
SYSCALL(getpid)
 480:	b8 0b 00 00 00       	mov    $0xb,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <sbrk>:
SYSCALL(sbrk)
 488:	b8 0c 00 00 00       	mov    $0xc,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <sleep>:
SYSCALL(sleep)
 490:	b8 0d 00 00 00       	mov    $0xd,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <uptime>:
SYSCALL(uptime)
 498:	b8 0e 00 00 00       	mov    $0xe,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <halt>:
SYSCALL(halt)
 4a0:	b8 16 00 00 00       	mov    $0x16,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <date>:
SYSCALL(date)        #p1
 4a8:	b8 17 00 00 00       	mov    $0x17,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <getuid>:
SYSCALL(getuid)      #p2
 4b0:	b8 18 00 00 00       	mov    $0x18,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <getgid>:
SYSCALL(getgid)      #p2
 4b8:	b8 19 00 00 00       	mov    $0x19,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <getppid>:
SYSCALL(getppid)     #p2
 4c0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <setuid>:
SYSCALL(setuid)      #p2
 4c8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <setgid>:
SYSCALL(setgid)      #p2
 4d0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <getprocs>:
SYSCALL(getprocs)    #p2
 4d8:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <setpriority>:
SYSCALL(setpriority) #p4
 4e0:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <chmod>:
SYSCALL(chmod)       #p5
 4e8:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <chown>:
SYSCALL(chown)       #p5
 4f0:	b8 20 00 00 00       	mov    $0x20,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <chgrp>:
SYSCALL(chgrp)       #p5
 4f8:	b8 21 00 00 00       	mov    $0x21,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	83 ec 18             	sub    $0x18,%esp
 506:	8b 45 0c             	mov    0xc(%ebp),%eax
 509:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 50c:	83 ec 04             	sub    $0x4,%esp
 50f:	6a 01                	push   $0x1
 511:	8d 45 f4             	lea    -0xc(%ebp),%eax
 514:	50                   	push   %eax
 515:	ff 75 08             	pushl  0x8(%ebp)
 518:	e8 03 ff ff ff       	call   420 <write>
 51d:	83 c4 10             	add    $0x10,%esp
}
 520:	90                   	nop
 521:	c9                   	leave  
 522:	c3                   	ret    

00000523 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 523:	55                   	push   %ebp
 524:	89 e5                	mov    %esp,%ebp
 526:	53                   	push   %ebx
 527:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 52a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 531:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 535:	74 17                	je     54e <printint+0x2b>
 537:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 53b:	79 11                	jns    54e <printint+0x2b>
    neg = 1;
 53d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 544:	8b 45 0c             	mov    0xc(%ebp),%eax
 547:	f7 d8                	neg    %eax
 549:	89 45 ec             	mov    %eax,-0x14(%ebp)
 54c:	eb 06                	jmp    554 <printint+0x31>
  } else {
    x = xx;
 54e:	8b 45 0c             	mov    0xc(%ebp),%eax
 551:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 554:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 55b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 55e:	8d 41 01             	lea    0x1(%ecx),%eax
 561:	89 45 f4             	mov    %eax,-0xc(%ebp)
 564:	8b 5d 10             	mov    0x10(%ebp),%ebx
 567:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56a:	ba 00 00 00 00       	mov    $0x0,%edx
 56f:	f7 f3                	div    %ebx
 571:	89 d0                	mov    %edx,%eax
 573:	0f b6 80 1c 0c 00 00 	movzbl 0xc1c(%eax),%eax
 57a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 57e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 581:	8b 45 ec             	mov    -0x14(%ebp),%eax
 584:	ba 00 00 00 00       	mov    $0x0,%edx
 589:	f7 f3                	div    %ebx
 58b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 58e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 592:	75 c7                	jne    55b <printint+0x38>
  if(neg)
 594:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 598:	74 2d                	je     5c7 <printint+0xa4>
    buf[i++] = '-';
 59a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59d:	8d 50 01             	lea    0x1(%eax),%edx
 5a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5a3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5a8:	eb 1d                	jmp    5c7 <printint+0xa4>
    putc(fd, buf[i]);
 5aa:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b0:	01 d0                	add    %edx,%eax
 5b2:	0f b6 00             	movzbl (%eax),%eax
 5b5:	0f be c0             	movsbl %al,%eax
 5b8:	83 ec 08             	sub    $0x8,%esp
 5bb:	50                   	push   %eax
 5bc:	ff 75 08             	pushl  0x8(%ebp)
 5bf:	e8 3c ff ff ff       	call   500 <putc>
 5c4:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5c7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5cf:	79 d9                	jns    5aa <printint+0x87>
    putc(fd, buf[i]);
}
 5d1:	90                   	nop
 5d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5d5:	c9                   	leave  
 5d6:	c3                   	ret    

000005d7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5d7:	55                   	push   %ebp
 5d8:	89 e5                	mov    %esp,%ebp
 5da:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5e4:	8d 45 0c             	lea    0xc(%ebp),%eax
 5e7:	83 c0 04             	add    $0x4,%eax
 5ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5f4:	e9 59 01 00 00       	jmp    752 <printf+0x17b>
    c = fmt[i] & 0xff;
 5f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ff:	01 d0                	add    %edx,%eax
 601:	0f b6 00             	movzbl (%eax),%eax
 604:	0f be c0             	movsbl %al,%eax
 607:	25 ff 00 00 00       	and    $0xff,%eax
 60c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 60f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 613:	75 2c                	jne    641 <printf+0x6a>
      if(c == '%'){
 615:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 619:	75 0c                	jne    627 <printf+0x50>
        state = '%';
 61b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 622:	e9 27 01 00 00       	jmp    74e <printf+0x177>
      } else {
        putc(fd, c);
 627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62a:	0f be c0             	movsbl %al,%eax
 62d:	83 ec 08             	sub    $0x8,%esp
 630:	50                   	push   %eax
 631:	ff 75 08             	pushl  0x8(%ebp)
 634:	e8 c7 fe ff ff       	call   500 <putc>
 639:	83 c4 10             	add    $0x10,%esp
 63c:	e9 0d 01 00 00       	jmp    74e <printf+0x177>
      }
    } else if(state == '%'){
 641:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 645:	0f 85 03 01 00 00    	jne    74e <printf+0x177>
      if(c == 'd'){
 64b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 64f:	75 1e                	jne    66f <printf+0x98>
        printint(fd, *ap, 10, 1);
 651:	8b 45 e8             	mov    -0x18(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	6a 01                	push   $0x1
 658:	6a 0a                	push   $0xa
 65a:	50                   	push   %eax
 65b:	ff 75 08             	pushl  0x8(%ebp)
 65e:	e8 c0 fe ff ff       	call   523 <printint>
 663:	83 c4 10             	add    $0x10,%esp
        ap++;
 666:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66a:	e9 d8 00 00 00       	jmp    747 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 66f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 673:	74 06                	je     67b <printf+0xa4>
 675:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 679:	75 1e                	jne    699 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 67b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	6a 00                	push   $0x0
 682:	6a 10                	push   $0x10
 684:	50                   	push   %eax
 685:	ff 75 08             	pushl  0x8(%ebp)
 688:	e8 96 fe ff ff       	call   523 <printint>
 68d:	83 c4 10             	add    $0x10,%esp
        ap++;
 690:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 694:	e9 ae 00 00 00       	jmp    747 <printf+0x170>
      } else if(c == 's'){
 699:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 69d:	75 43                	jne    6e2 <printf+0x10b>
        s = (char*)*ap;
 69f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6af:	75 25                	jne    6d6 <printf+0xff>
          s = "(null)";
 6b1:	c7 45 f4 ab 09 00 00 	movl   $0x9ab,-0xc(%ebp)
        while(*s != 0){
 6b8:	eb 1c                	jmp    6d6 <printf+0xff>
          putc(fd, *s);
 6ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bd:	0f b6 00             	movzbl (%eax),%eax
 6c0:	0f be c0             	movsbl %al,%eax
 6c3:	83 ec 08             	sub    $0x8,%esp
 6c6:	50                   	push   %eax
 6c7:	ff 75 08             	pushl  0x8(%ebp)
 6ca:	e8 31 fe ff ff       	call   500 <putc>
 6cf:	83 c4 10             	add    $0x10,%esp
          s++;
 6d2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d9:	0f b6 00             	movzbl (%eax),%eax
 6dc:	84 c0                	test   %al,%al
 6de:	75 da                	jne    6ba <printf+0xe3>
 6e0:	eb 65                	jmp    747 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6e2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6e6:	75 1d                	jne    705 <printf+0x12e>
        putc(fd, *ap);
 6e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	0f be c0             	movsbl %al,%eax
 6f0:	83 ec 08             	sub    $0x8,%esp
 6f3:	50                   	push   %eax
 6f4:	ff 75 08             	pushl  0x8(%ebp)
 6f7:	e8 04 fe ff ff       	call   500 <putc>
 6fc:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 703:	eb 42                	jmp    747 <printf+0x170>
      } else if(c == '%'){
 705:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 709:	75 17                	jne    722 <printf+0x14b>
        putc(fd, c);
 70b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70e:	0f be c0             	movsbl %al,%eax
 711:	83 ec 08             	sub    $0x8,%esp
 714:	50                   	push   %eax
 715:	ff 75 08             	pushl  0x8(%ebp)
 718:	e8 e3 fd ff ff       	call   500 <putc>
 71d:	83 c4 10             	add    $0x10,%esp
 720:	eb 25                	jmp    747 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 722:	83 ec 08             	sub    $0x8,%esp
 725:	6a 25                	push   $0x25
 727:	ff 75 08             	pushl  0x8(%ebp)
 72a:	e8 d1 fd ff ff       	call   500 <putc>
 72f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 735:	0f be c0             	movsbl %al,%eax
 738:	83 ec 08             	sub    $0x8,%esp
 73b:	50                   	push   %eax
 73c:	ff 75 08             	pushl  0x8(%ebp)
 73f:	e8 bc fd ff ff       	call   500 <putc>
 744:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 747:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 74e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 752:	8b 55 0c             	mov    0xc(%ebp),%edx
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	01 d0                	add    %edx,%eax
 75a:	0f b6 00             	movzbl (%eax),%eax
 75d:	84 c0                	test   %al,%al
 75f:	0f 85 94 fe ff ff    	jne    5f9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 765:	90                   	nop
 766:	c9                   	leave  
 767:	c3                   	ret    

00000768 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 768:	55                   	push   %ebp
 769:	89 e5                	mov    %esp,%ebp
 76b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76e:	8b 45 08             	mov    0x8(%ebp),%eax
 771:	83 e8 08             	sub    $0x8,%eax
 774:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 777:	a1 38 0c 00 00       	mov    0xc38,%eax
 77c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 77f:	eb 24                	jmp    7a5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 789:	77 12                	ja     79d <free+0x35>
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 791:	77 24                	ja     7b7 <free+0x4f>
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79b:	77 1a                	ja     7b7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ab:	76 d4                	jbe    781 <free+0x19>
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b5:	76 ca                	jbe    781 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	8b 40 04             	mov    0x4(%eax),%eax
 7bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c7:	01 c2                	add    %eax,%edx
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	39 c2                	cmp    %eax,%edx
 7d0:	75 24                	jne    7f6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	8b 50 04             	mov    0x4(%eax),%edx
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	8b 40 04             	mov    0x4(%eax),%eax
 7e0:	01 c2                	add    %eax,%edx
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	8b 10                	mov    (%eax),%edx
 7ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f2:	89 10                	mov    %edx,(%eax)
 7f4:	eb 0a                	jmp    800 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f9:	8b 10                	mov    (%eax),%edx
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	01 d0                	add    %edx,%eax
 812:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 815:	75 20                	jne    837 <free+0xcf>
    p->s.size += bp->s.size;
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	8b 50 04             	mov    0x4(%eax),%edx
 81d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	01 c2                	add    %eax,%edx
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 82b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82e:	8b 10                	mov    (%eax),%edx
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	89 10                	mov    %edx,(%eax)
 835:	eb 08                	jmp    83f <free+0xd7>
  } else
    p->s.ptr = bp;
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 83d:	89 10                	mov    %edx,(%eax)
  freep = p;
 83f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 842:	a3 38 0c 00 00       	mov    %eax,0xc38
}
 847:	90                   	nop
 848:	c9                   	leave  
 849:	c3                   	ret    

0000084a <morecore>:

static Header*
morecore(uint nu)
{
 84a:	55                   	push   %ebp
 84b:	89 e5                	mov    %esp,%ebp
 84d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 850:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 857:	77 07                	ja     860 <morecore+0x16>
    nu = 4096;
 859:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 860:	8b 45 08             	mov    0x8(%ebp),%eax
 863:	c1 e0 03             	shl    $0x3,%eax
 866:	83 ec 0c             	sub    $0xc,%esp
 869:	50                   	push   %eax
 86a:	e8 19 fc ff ff       	call   488 <sbrk>
 86f:	83 c4 10             	add    $0x10,%esp
 872:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 875:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 879:	75 07                	jne    882 <morecore+0x38>
    return 0;
 87b:	b8 00 00 00 00       	mov    $0x0,%eax
 880:	eb 26                	jmp    8a8 <morecore+0x5e>
  hp = (Header*)p;
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 888:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88b:	8b 55 08             	mov    0x8(%ebp),%edx
 88e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 891:	8b 45 f0             	mov    -0x10(%ebp),%eax
 894:	83 c0 08             	add    $0x8,%eax
 897:	83 ec 0c             	sub    $0xc,%esp
 89a:	50                   	push   %eax
 89b:	e8 c8 fe ff ff       	call   768 <free>
 8a0:	83 c4 10             	add    $0x10,%esp
  return freep;
 8a3:	a1 38 0c 00 00       	mov    0xc38,%eax
}
 8a8:	c9                   	leave  
 8a9:	c3                   	ret    

000008aa <malloc>:

void*
malloc(uint nbytes)
{
 8aa:	55                   	push   %ebp
 8ab:	89 e5                	mov    %esp,%ebp
 8ad:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b0:	8b 45 08             	mov    0x8(%ebp),%eax
 8b3:	83 c0 07             	add    $0x7,%eax
 8b6:	c1 e8 03             	shr    $0x3,%eax
 8b9:	83 c0 01             	add    $0x1,%eax
 8bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8bf:	a1 38 0c 00 00       	mov    0xc38,%eax
 8c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8cb:	75 23                	jne    8f0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8cd:	c7 45 f0 30 0c 00 00 	movl   $0xc30,-0x10(%ebp)
 8d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d7:	a3 38 0c 00 00       	mov    %eax,0xc38
 8dc:	a1 38 0c 00 00       	mov    0xc38,%eax
 8e1:	a3 30 0c 00 00       	mov    %eax,0xc30
    base.s.size = 0;
 8e6:	c7 05 34 0c 00 00 00 	movl   $0x0,0xc34
 8ed:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f3:	8b 00                	mov    (%eax),%eax
 8f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fb:	8b 40 04             	mov    0x4(%eax),%eax
 8fe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 901:	72 4d                	jb     950 <malloc+0xa6>
      if(p->s.size == nunits)
 903:	8b 45 f4             	mov    -0xc(%ebp),%eax
 906:	8b 40 04             	mov    0x4(%eax),%eax
 909:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 90c:	75 0c                	jne    91a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	8b 10                	mov    (%eax),%edx
 913:	8b 45 f0             	mov    -0x10(%ebp),%eax
 916:	89 10                	mov    %edx,(%eax)
 918:	eb 26                	jmp    940 <malloc+0x96>
      else {
        p->s.size -= nunits;
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	8b 40 04             	mov    0x4(%eax),%eax
 920:	2b 45 ec             	sub    -0x14(%ebp),%eax
 923:	89 c2                	mov    %eax,%edx
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	8b 40 04             	mov    0x4(%eax),%eax
 931:	c1 e0 03             	shl    $0x3,%eax
 934:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 937:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 93d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 940:	8b 45 f0             	mov    -0x10(%ebp),%eax
 943:	a3 38 0c 00 00       	mov    %eax,0xc38
      return (void*)(p + 1);
 948:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94b:	83 c0 08             	add    $0x8,%eax
 94e:	eb 3b                	jmp    98b <malloc+0xe1>
    }
    if(p == freep)
 950:	a1 38 0c 00 00       	mov    0xc38,%eax
 955:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 958:	75 1e                	jne    978 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 95a:	83 ec 0c             	sub    $0xc,%esp
 95d:	ff 75 ec             	pushl  -0x14(%ebp)
 960:	e8 e5 fe ff ff       	call   84a <morecore>
 965:	83 c4 10             	add    $0x10,%esp
 968:	89 45 f4             	mov    %eax,-0xc(%ebp)
 96b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 96f:	75 07                	jne    978 <malloc+0xce>
        return 0;
 971:	b8 00 00 00 00       	mov    $0x0,%eax
 976:	eb 13                	jmp    98b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 97e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 981:	8b 00                	mov    (%eax),%eax
 983:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 986:	e9 6d ff ff ff       	jmp    8f8 <malloc+0x4e>
}
 98b:	c9                   	leave  
 98c:	c3                   	ret    
