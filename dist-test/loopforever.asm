
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
  30:	e8 cd 03 00 00       	call   402 <sleep>
  35:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  38:	e8 2d 03 00 00       	call   36a <fork>
  3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (pid < 0) {
  40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  44:	79 17                	jns    5d <main+0x5d>
      printf(2, "fork failed!\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 e7 08 00 00       	push   $0x8e7
  4e:	6a 02                	push   $0x2
  50:	e8 dc 04 00 00       	call   531 <printf>
  55:	83 c4 10             	add    $0x10,%esp
      exit();
  58:	e8 15 03 00 00       	call   372 <exit>
    }

    if (pid == 0) { // child
  5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  61:	75 1a                	jne    7d <main+0x7d>
      sleep(getpid()*100); // stagger start
  63:	e8 8a 03 00 00       	call   3f2 <getpid>
  68:	6b c0 64             	imul   $0x64,%eax,%eax
  6b:	83 ec 0c             	sub    $0xc,%esp
  6e:	50                   	push   %eax
  6f:	e8 8e 03 00 00       	call   402 <sleep>
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
  89:	e8 dc 02 00 00       	call   36a <fork>
  8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (pid == 0) {
  91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  95:	75 13                	jne    aa <main+0xaa>
    sleep(20);
  97:	83 ec 0c             	sub    $0xc,%esp
  9a:	6a 14                	push   $0x14
  9c:	e8 61 03 00 00       	call   402 <sleep>
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
  b2:	e8 4b 03 00 00       	call   402 <sleep>
  b7:	83 c4 10             	add    $0x10,%esp
  wait();
  ba:	e8 bb 02 00 00       	call   37a <wait>
  printf(1, "Parent exiting\n");
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	68 f5 08 00 00       	push   $0x8f5
  c7:	6a 01                	push   $0x1
  c9:	e8 63 04 00 00       	call   531 <printf>
  ce:	83 c4 10             	add    $0x10,%esp
  exit();
  d1:	e8 9c 02 00 00       	call   372 <exit>

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
 1f9:	e8 8c 01 00 00       	call   38a <read>
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
 25c:	e8 51 01 00 00       	call   3b2 <open>
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
 27d:	e8 48 01 00 00       	call   3ca <fstat>
 282:	83 c4 10             	add    $0x10,%esp
 285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 288:	83 ec 0c             	sub    $0xc,%esp
 28b:	ff 75 f4             	pushl  -0xc(%ebp)
 28e:	e8 07 01 00 00       	call   39a <close>
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

0000032d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 32d:	55                   	push   %ebp
 32e:	89 e5                	mov    %esp,%ebp
 330:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 33f:	eb 17                	jmp    358 <memmove+0x2b>
    *dst++ = *src++;
 341:	8b 45 fc             	mov    -0x4(%ebp),%eax
 344:	8d 50 01             	lea    0x1(%eax),%edx
 347:	89 55 fc             	mov    %edx,-0x4(%ebp)
 34a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 34d:	8d 4a 01             	lea    0x1(%edx),%ecx
 350:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 353:	0f b6 12             	movzbl (%edx),%edx
 356:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 358:	8b 45 10             	mov    0x10(%ebp),%eax
 35b:	8d 50 ff             	lea    -0x1(%eax),%edx
 35e:	89 55 10             	mov    %edx,0x10(%ebp)
 361:	85 c0                	test   %eax,%eax
 363:	7f dc                	jg     341 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 365:	8b 45 08             	mov    0x8(%ebp),%eax
}
 368:	c9                   	leave  
 369:	c3                   	ret    

0000036a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36a:	b8 01 00 00 00       	mov    $0x1,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <exit>:
SYSCALL(exit)
 372:	b8 02 00 00 00       	mov    $0x2,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <wait>:
SYSCALL(wait)
 37a:	b8 03 00 00 00       	mov    $0x3,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <pipe>:
SYSCALL(pipe)
 382:	b8 04 00 00 00       	mov    $0x4,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <read>:
SYSCALL(read)
 38a:	b8 05 00 00 00       	mov    $0x5,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <write>:
SYSCALL(write)
 392:	b8 10 00 00 00       	mov    $0x10,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <close>:
SYSCALL(close)
 39a:	b8 15 00 00 00       	mov    $0x15,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <kill>:
SYSCALL(kill)
 3a2:	b8 06 00 00 00       	mov    $0x6,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <exec>:
SYSCALL(exec)
 3aa:	b8 07 00 00 00       	mov    $0x7,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <open>:
SYSCALL(open)
 3b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <mknod>:
SYSCALL(mknod)
 3ba:	b8 11 00 00 00       	mov    $0x11,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <unlink>:
SYSCALL(unlink)
 3c2:	b8 12 00 00 00       	mov    $0x12,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <fstat>:
SYSCALL(fstat)
 3ca:	b8 08 00 00 00       	mov    $0x8,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <link>:
SYSCALL(link)
 3d2:	b8 13 00 00 00       	mov    $0x13,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <mkdir>:
SYSCALL(mkdir)
 3da:	b8 14 00 00 00       	mov    $0x14,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <chdir>:
SYSCALL(chdir)
 3e2:	b8 09 00 00 00       	mov    $0x9,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <dup>:
SYSCALL(dup)
 3ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <getpid>:
SYSCALL(getpid)
 3f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <sbrk>:
SYSCALL(sbrk)
 3fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <sleep>:
SYSCALL(sleep)
 402:	b8 0d 00 00 00       	mov    $0xd,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <uptime>:
SYSCALL(uptime)
 40a:	b8 0e 00 00 00       	mov    $0xe,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <halt>:
SYSCALL(halt)
 412:	b8 16 00 00 00       	mov    $0x16,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <date>:
SYSCALL(date)      #p1
 41a:	b8 17 00 00 00       	mov    $0x17,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <getuid>:
SYSCALL(getuid)    #p2
 422:	b8 18 00 00 00       	mov    $0x18,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <getgid>:
SYSCALL(getgid)    #p2
 42a:	b8 19 00 00 00       	mov    $0x19,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <getppid>:
SYSCALL(getppid)   #p2
 432:	b8 1a 00 00 00       	mov    $0x1a,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <setuid>:
SYSCALL(setuid)    #p2
 43a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <setgid>:
SYSCALL(setgid)    #p2
 442:	b8 1c 00 00 00       	mov    $0x1c,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <getprocs>:
SYSCALL(getprocs)  #p2
 44a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <setpriority>:
SYSCALL(setpriority)
 452:	b8 1e 00 00 00       	mov    $0x1e,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 45a:	55                   	push   %ebp
 45b:	89 e5                	mov    %esp,%ebp
 45d:	83 ec 18             	sub    $0x18,%esp
 460:	8b 45 0c             	mov    0xc(%ebp),%eax
 463:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 466:	83 ec 04             	sub    $0x4,%esp
 469:	6a 01                	push   $0x1
 46b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 46e:	50                   	push   %eax
 46f:	ff 75 08             	pushl  0x8(%ebp)
 472:	e8 1b ff ff ff       	call   392 <write>
 477:	83 c4 10             	add    $0x10,%esp
}
 47a:	90                   	nop
 47b:	c9                   	leave  
 47c:	c3                   	ret    

0000047d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47d:	55                   	push   %ebp
 47e:	89 e5                	mov    %esp,%ebp
 480:	53                   	push   %ebx
 481:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 484:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 48b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 48f:	74 17                	je     4a8 <printint+0x2b>
 491:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 495:	79 11                	jns    4a8 <printint+0x2b>
    neg = 1;
 497:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 49e:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a1:	f7 d8                	neg    %eax
 4a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a6:	eb 06                	jmp    4ae <printint+0x31>
  } else {
    x = xx;
 4a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4b8:	8d 41 01             	lea    0x1(%ecx),%eax
 4bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4be:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c4:	ba 00 00 00 00       	mov    $0x0,%edx
 4c9:	f7 f3                	div    %ebx
 4cb:	89 d0                	mov    %edx,%eax
 4cd:	0f b6 80 54 0b 00 00 	movzbl 0xb54(%eax),%eax
 4d4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4db:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4de:	ba 00 00 00 00       	mov    $0x0,%edx
 4e3:	f7 f3                	div    %ebx
 4e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ec:	75 c7                	jne    4b5 <printint+0x38>
  if(neg)
 4ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f2:	74 2d                	je     521 <printint+0xa4>
    buf[i++] = '-';
 4f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f7:	8d 50 01             	lea    0x1(%eax),%edx
 4fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4fd:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 502:	eb 1d                	jmp    521 <printint+0xa4>
    putc(fd, buf[i]);
 504:	8d 55 dc             	lea    -0x24(%ebp),%edx
 507:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50a:	01 d0                	add    %edx,%eax
 50c:	0f b6 00             	movzbl (%eax),%eax
 50f:	0f be c0             	movsbl %al,%eax
 512:	83 ec 08             	sub    $0x8,%esp
 515:	50                   	push   %eax
 516:	ff 75 08             	pushl  0x8(%ebp)
 519:	e8 3c ff ff ff       	call   45a <putc>
 51e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 521:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 529:	79 d9                	jns    504 <printint+0x87>
    putc(fd, buf[i]);
}
 52b:	90                   	nop
 52c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 52f:	c9                   	leave  
 530:	c3                   	ret    

00000531 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 531:	55                   	push   %ebp
 532:	89 e5                	mov    %esp,%ebp
 534:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 537:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 53e:	8d 45 0c             	lea    0xc(%ebp),%eax
 541:	83 c0 04             	add    $0x4,%eax
 544:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 547:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 54e:	e9 59 01 00 00       	jmp    6ac <printf+0x17b>
    c = fmt[i] & 0xff;
 553:	8b 55 0c             	mov    0xc(%ebp),%edx
 556:	8b 45 f0             	mov    -0x10(%ebp),%eax
 559:	01 d0                	add    %edx,%eax
 55b:	0f b6 00             	movzbl (%eax),%eax
 55e:	0f be c0             	movsbl %al,%eax
 561:	25 ff 00 00 00       	and    $0xff,%eax
 566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 569:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56d:	75 2c                	jne    59b <printf+0x6a>
      if(c == '%'){
 56f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 573:	75 0c                	jne    581 <printf+0x50>
        state = '%';
 575:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 57c:	e9 27 01 00 00       	jmp    6a8 <printf+0x177>
      } else {
        putc(fd, c);
 581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 584:	0f be c0             	movsbl %al,%eax
 587:	83 ec 08             	sub    $0x8,%esp
 58a:	50                   	push   %eax
 58b:	ff 75 08             	pushl  0x8(%ebp)
 58e:	e8 c7 fe ff ff       	call   45a <putc>
 593:	83 c4 10             	add    $0x10,%esp
 596:	e9 0d 01 00 00       	jmp    6a8 <printf+0x177>
      }
    } else if(state == '%'){
 59b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 59f:	0f 85 03 01 00 00    	jne    6a8 <printf+0x177>
      if(c == 'd'){
 5a5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5a9:	75 1e                	jne    5c9 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ae:	8b 00                	mov    (%eax),%eax
 5b0:	6a 01                	push   $0x1
 5b2:	6a 0a                	push   $0xa
 5b4:	50                   	push   %eax
 5b5:	ff 75 08             	pushl  0x8(%ebp)
 5b8:	e8 c0 fe ff ff       	call   47d <printint>
 5bd:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c4:	e9 d8 00 00 00       	jmp    6a1 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5c9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5cd:	74 06                	je     5d5 <printf+0xa4>
 5cf:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d3:	75 1e                	jne    5f3 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d8:	8b 00                	mov    (%eax),%eax
 5da:	6a 00                	push   $0x0
 5dc:	6a 10                	push   $0x10
 5de:	50                   	push   %eax
 5df:	ff 75 08             	pushl  0x8(%ebp)
 5e2:	e8 96 fe ff ff       	call   47d <printint>
 5e7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ee:	e9 ae 00 00 00       	jmp    6a1 <printf+0x170>
      } else if(c == 's'){
 5f3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5f7:	75 43                	jne    63c <printf+0x10b>
        s = (char*)*ap;
 5f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fc:	8b 00                	mov    (%eax),%eax
 5fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 601:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 609:	75 25                	jne    630 <printf+0xff>
          s = "(null)";
 60b:	c7 45 f4 05 09 00 00 	movl   $0x905,-0xc(%ebp)
        while(*s != 0){
 612:	eb 1c                	jmp    630 <printf+0xff>
          putc(fd, *s);
 614:	8b 45 f4             	mov    -0xc(%ebp),%eax
 617:	0f b6 00             	movzbl (%eax),%eax
 61a:	0f be c0             	movsbl %al,%eax
 61d:	83 ec 08             	sub    $0x8,%esp
 620:	50                   	push   %eax
 621:	ff 75 08             	pushl  0x8(%ebp)
 624:	e8 31 fe ff ff       	call   45a <putc>
 629:	83 c4 10             	add    $0x10,%esp
          s++;
 62c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 630:	8b 45 f4             	mov    -0xc(%ebp),%eax
 633:	0f b6 00             	movzbl (%eax),%eax
 636:	84 c0                	test   %al,%al
 638:	75 da                	jne    614 <printf+0xe3>
 63a:	eb 65                	jmp    6a1 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 640:	75 1d                	jne    65f <printf+0x12e>
        putc(fd, *ap);
 642:	8b 45 e8             	mov    -0x18(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	0f be c0             	movsbl %al,%eax
 64a:	83 ec 08             	sub    $0x8,%esp
 64d:	50                   	push   %eax
 64e:	ff 75 08             	pushl  0x8(%ebp)
 651:	e8 04 fe ff ff       	call   45a <putc>
 656:	83 c4 10             	add    $0x10,%esp
        ap++;
 659:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65d:	eb 42                	jmp    6a1 <printf+0x170>
      } else if(c == '%'){
 65f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 663:	75 17                	jne    67c <printf+0x14b>
        putc(fd, c);
 665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 668:	0f be c0             	movsbl %al,%eax
 66b:	83 ec 08             	sub    $0x8,%esp
 66e:	50                   	push   %eax
 66f:	ff 75 08             	pushl  0x8(%ebp)
 672:	e8 e3 fd ff ff       	call   45a <putc>
 677:	83 c4 10             	add    $0x10,%esp
 67a:	eb 25                	jmp    6a1 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 67c:	83 ec 08             	sub    $0x8,%esp
 67f:	6a 25                	push   $0x25
 681:	ff 75 08             	pushl  0x8(%ebp)
 684:	e8 d1 fd ff ff       	call   45a <putc>
 689:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 68c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68f:	0f be c0             	movsbl %al,%eax
 692:	83 ec 08             	sub    $0x8,%esp
 695:	50                   	push   %eax
 696:	ff 75 08             	pushl  0x8(%ebp)
 699:	e8 bc fd ff ff       	call   45a <putc>
 69e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ac:	8b 55 0c             	mov    0xc(%ebp),%edx
 6af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b2:	01 d0                	add    %edx,%eax
 6b4:	0f b6 00             	movzbl (%eax),%eax
 6b7:	84 c0                	test   %al,%al
 6b9:	0f 85 94 fe ff ff    	jne    553 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6bf:	90                   	nop
 6c0:	c9                   	leave  
 6c1:	c3                   	ret    

000006c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c2:	55                   	push   %ebp
 6c3:	89 e5                	mov    %esp,%ebp
 6c5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c8:	8b 45 08             	mov    0x8(%ebp),%eax
 6cb:	83 e8 08             	sub    $0x8,%eax
 6ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	a1 70 0b 00 00       	mov    0xb70,%eax
 6d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d9:	eb 24                	jmp    6ff <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e3:	77 12                	ja     6f7 <free+0x35>
 6e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6eb:	77 24                	ja     711 <free+0x4f>
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f5:	77 1a                	ja     711 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 705:	76 d4                	jbe    6db <free+0x19>
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70f:	76 ca                	jbe    6db <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 711:	8b 45 f8             	mov    -0x8(%ebp),%eax
 714:	8b 40 04             	mov    0x4(%eax),%eax
 717:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	01 c2                	add    %eax,%edx
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	39 c2                	cmp    %eax,%edx
 72a:	75 24                	jne    750 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	8b 50 04             	mov    0x4(%eax),%edx
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	8b 40 04             	mov    0x4(%eax),%eax
 73a:	01 c2                	add    %eax,%edx
 73c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	8b 10                	mov    (%eax),%edx
 749:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74c:	89 10                	mov    %edx,(%eax)
 74e:	eb 0a                	jmp    75a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 10                	mov    (%eax),%edx
 755:	8b 45 f8             	mov    -0x8(%ebp),%eax
 758:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 40 04             	mov    0x4(%eax),%eax
 760:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	01 d0                	add    %edx,%eax
 76c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76f:	75 20                	jne    791 <free+0xcf>
    p->s.size += bp->s.size;
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 50 04             	mov    0x4(%eax),%edx
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	01 c2                	add    %eax,%edx
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	8b 10                	mov    (%eax),%edx
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	89 10                	mov    %edx,(%eax)
 78f:	eb 08                	jmp    799 <free+0xd7>
  } else
    p->s.ptr = bp;
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 55 f8             	mov    -0x8(%ebp),%edx
 797:	89 10                	mov    %edx,(%eax)
  freep = p;
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	a3 70 0b 00 00       	mov    %eax,0xb70
}
 7a1:	90                   	nop
 7a2:	c9                   	leave  
 7a3:	c3                   	ret    

000007a4 <morecore>:

static Header*
morecore(uint nu)
{
 7a4:	55                   	push   %ebp
 7a5:	89 e5                	mov    %esp,%ebp
 7a7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7aa:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b1:	77 07                	ja     7ba <morecore+0x16>
    nu = 4096;
 7b3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ba:	8b 45 08             	mov    0x8(%ebp),%eax
 7bd:	c1 e0 03             	shl    $0x3,%eax
 7c0:	83 ec 0c             	sub    $0xc,%esp
 7c3:	50                   	push   %eax
 7c4:	e8 31 fc ff ff       	call   3fa <sbrk>
 7c9:	83 c4 10             	add    $0x10,%esp
 7cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7cf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d3:	75 07                	jne    7dc <morecore+0x38>
    return 0;
 7d5:	b8 00 00 00 00       	mov    $0x0,%eax
 7da:	eb 26                	jmp    802 <morecore+0x5e>
  hp = (Header*)p;
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e5:	8b 55 08             	mov    0x8(%ebp),%edx
 7e8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ee:	83 c0 08             	add    $0x8,%eax
 7f1:	83 ec 0c             	sub    $0xc,%esp
 7f4:	50                   	push   %eax
 7f5:	e8 c8 fe ff ff       	call   6c2 <free>
 7fa:	83 c4 10             	add    $0x10,%esp
  return freep;
 7fd:	a1 70 0b 00 00       	mov    0xb70,%eax
}
 802:	c9                   	leave  
 803:	c3                   	ret    

00000804 <malloc>:

void*
malloc(uint nbytes)
{
 804:	55                   	push   %ebp
 805:	89 e5                	mov    %esp,%ebp
 807:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80a:	8b 45 08             	mov    0x8(%ebp),%eax
 80d:	83 c0 07             	add    $0x7,%eax
 810:	c1 e8 03             	shr    $0x3,%eax
 813:	83 c0 01             	add    $0x1,%eax
 816:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 819:	a1 70 0b 00 00       	mov    0xb70,%eax
 81e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 821:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 825:	75 23                	jne    84a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 827:	c7 45 f0 68 0b 00 00 	movl   $0xb68,-0x10(%ebp)
 82e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 831:	a3 70 0b 00 00       	mov    %eax,0xb70
 836:	a1 70 0b 00 00       	mov    0xb70,%eax
 83b:	a3 68 0b 00 00       	mov    %eax,0xb68
    base.s.size = 0;
 840:	c7 05 6c 0b 00 00 00 	movl   $0x0,0xb6c
 847:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84d:	8b 00                	mov    (%eax),%eax
 84f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 40 04             	mov    0x4(%eax),%eax
 858:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85b:	72 4d                	jb     8aa <malloc+0xa6>
      if(p->s.size == nunits)
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	8b 40 04             	mov    0x4(%eax),%eax
 863:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 866:	75 0c                	jne    874 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	8b 10                	mov    (%eax),%edx
 86d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 870:	89 10                	mov    %edx,(%eax)
 872:	eb 26                	jmp    89a <malloc+0x96>
      else {
        p->s.size -= nunits;
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 87d:	89 c2                	mov    %eax,%edx
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 885:	8b 45 f4             	mov    -0xc(%ebp),%eax
 888:	8b 40 04             	mov    0x4(%eax),%eax
 88b:	c1 e0 03             	shl    $0x3,%eax
 88e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 891:	8b 45 f4             	mov    -0xc(%ebp),%eax
 894:	8b 55 ec             	mov    -0x14(%ebp),%edx
 897:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89d:	a3 70 0b 00 00       	mov    %eax,0xb70
      return (void*)(p + 1);
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	83 c0 08             	add    $0x8,%eax
 8a8:	eb 3b                	jmp    8e5 <malloc+0xe1>
    }
    if(p == freep)
 8aa:	a1 70 0b 00 00       	mov    0xb70,%eax
 8af:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b2:	75 1e                	jne    8d2 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8b4:	83 ec 0c             	sub    $0xc,%esp
 8b7:	ff 75 ec             	pushl  -0x14(%ebp)
 8ba:	e8 e5 fe ff ff       	call   7a4 <morecore>
 8bf:	83 c4 10             	add    $0x10,%esp
 8c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c9:	75 07                	jne    8d2 <malloc+0xce>
        return 0;
 8cb:	b8 00 00 00 00       	mov    $0x0,%eax
 8d0:	eb 13                	jmp    8e5 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 00                	mov    (%eax),%eax
 8dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e0:	e9 6d ff ff ff       	jmp    852 <malloc+0x4e>
}
 8e5:	c9                   	leave  
 8e6:	c3                   	ret    
