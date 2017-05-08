
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
  49:	68 df 08 00 00       	push   $0x8df
  4e:	6a 02                	push   $0x2
  50:	e8 d4 04 00 00       	call   529 <printf>
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
  c2:	68 ed 08 00 00       	push   $0x8ed
  c7:	6a 01                	push   $0x1
  c9:	e8 5b 04 00 00       	call   529 <printf>
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

00000452 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 452:	55                   	push   %ebp
 453:	89 e5                	mov    %esp,%ebp
 455:	83 ec 18             	sub    $0x18,%esp
 458:	8b 45 0c             	mov    0xc(%ebp),%eax
 45b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 45e:	83 ec 04             	sub    $0x4,%esp
 461:	6a 01                	push   $0x1
 463:	8d 45 f4             	lea    -0xc(%ebp),%eax
 466:	50                   	push   %eax
 467:	ff 75 08             	pushl  0x8(%ebp)
 46a:	e8 23 ff ff ff       	call   392 <write>
 46f:	83 c4 10             	add    $0x10,%esp
}
 472:	90                   	nop
 473:	c9                   	leave  
 474:	c3                   	ret    

00000475 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 475:	55                   	push   %ebp
 476:	89 e5                	mov    %esp,%ebp
 478:	53                   	push   %ebx
 479:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 47c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 483:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 487:	74 17                	je     4a0 <printint+0x2b>
 489:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 48d:	79 11                	jns    4a0 <printint+0x2b>
    neg = 1;
 48f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 496:	8b 45 0c             	mov    0xc(%ebp),%eax
 499:	f7 d8                	neg    %eax
 49b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49e:	eb 06                	jmp    4a6 <printint+0x31>
  } else {
    x = xx;
 4a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ad:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4b0:	8d 41 01             	lea    0x1(%ecx),%eax
 4b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4bc:	ba 00 00 00 00       	mov    $0x0,%edx
 4c1:	f7 f3                	div    %ebx
 4c3:	89 d0                	mov    %edx,%eax
 4c5:	0f b6 80 4c 0b 00 00 	movzbl 0xb4c(%eax),%eax
 4cc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d6:	ba 00 00 00 00       	mov    $0x0,%edx
 4db:	f7 f3                	div    %ebx
 4dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e4:	75 c7                	jne    4ad <printint+0x38>
  if(neg)
 4e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ea:	74 2d                	je     519 <printint+0xa4>
    buf[i++] = '-';
 4ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ef:	8d 50 01             	lea    0x1(%eax),%edx
 4f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4f5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4fa:	eb 1d                	jmp    519 <printint+0xa4>
    putc(fd, buf[i]);
 4fc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 502:	01 d0                	add    %edx,%eax
 504:	0f b6 00             	movzbl (%eax),%eax
 507:	0f be c0             	movsbl %al,%eax
 50a:	83 ec 08             	sub    $0x8,%esp
 50d:	50                   	push   %eax
 50e:	ff 75 08             	pushl  0x8(%ebp)
 511:	e8 3c ff ff ff       	call   452 <putc>
 516:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 519:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 51d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 521:	79 d9                	jns    4fc <printint+0x87>
    putc(fd, buf[i]);
}
 523:	90                   	nop
 524:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 527:	c9                   	leave  
 528:	c3                   	ret    

00000529 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 529:	55                   	push   %ebp
 52a:	89 e5                	mov    %esp,%ebp
 52c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 52f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 536:	8d 45 0c             	lea    0xc(%ebp),%eax
 539:	83 c0 04             	add    $0x4,%eax
 53c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 53f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 546:	e9 59 01 00 00       	jmp    6a4 <printf+0x17b>
    c = fmt[i] & 0xff;
 54b:	8b 55 0c             	mov    0xc(%ebp),%edx
 54e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 551:	01 d0                	add    %edx,%eax
 553:	0f b6 00             	movzbl (%eax),%eax
 556:	0f be c0             	movsbl %al,%eax
 559:	25 ff 00 00 00       	and    $0xff,%eax
 55e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 561:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 565:	75 2c                	jne    593 <printf+0x6a>
      if(c == '%'){
 567:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56b:	75 0c                	jne    579 <printf+0x50>
        state = '%';
 56d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 574:	e9 27 01 00 00       	jmp    6a0 <printf+0x177>
      } else {
        putc(fd, c);
 579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57c:	0f be c0             	movsbl %al,%eax
 57f:	83 ec 08             	sub    $0x8,%esp
 582:	50                   	push   %eax
 583:	ff 75 08             	pushl  0x8(%ebp)
 586:	e8 c7 fe ff ff       	call   452 <putc>
 58b:	83 c4 10             	add    $0x10,%esp
 58e:	e9 0d 01 00 00       	jmp    6a0 <printf+0x177>
      }
    } else if(state == '%'){
 593:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 597:	0f 85 03 01 00 00    	jne    6a0 <printf+0x177>
      if(c == 'd'){
 59d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5a1:	75 1e                	jne    5c1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a6:	8b 00                	mov    (%eax),%eax
 5a8:	6a 01                	push   $0x1
 5aa:	6a 0a                	push   $0xa
 5ac:	50                   	push   %eax
 5ad:	ff 75 08             	pushl  0x8(%ebp)
 5b0:	e8 c0 fe ff ff       	call   475 <printint>
 5b5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bc:	e9 d8 00 00 00       	jmp    699 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5c1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5c5:	74 06                	je     5cd <printf+0xa4>
 5c7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5cb:	75 1e                	jne    5eb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d0:	8b 00                	mov    (%eax),%eax
 5d2:	6a 00                	push   $0x0
 5d4:	6a 10                	push   $0x10
 5d6:	50                   	push   %eax
 5d7:	ff 75 08             	pushl  0x8(%ebp)
 5da:	e8 96 fe ff ff       	call   475 <printint>
 5df:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e6:	e9 ae 00 00 00       	jmp    699 <printf+0x170>
      } else if(c == 's'){
 5eb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ef:	75 43                	jne    634 <printf+0x10b>
        s = (char*)*ap;
 5f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f4:	8b 00                	mov    (%eax),%eax
 5f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 601:	75 25                	jne    628 <printf+0xff>
          s = "(null)";
 603:	c7 45 f4 fd 08 00 00 	movl   $0x8fd,-0xc(%ebp)
        while(*s != 0){
 60a:	eb 1c                	jmp    628 <printf+0xff>
          putc(fd, *s);
 60c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60f:	0f b6 00             	movzbl (%eax),%eax
 612:	0f be c0             	movsbl %al,%eax
 615:	83 ec 08             	sub    $0x8,%esp
 618:	50                   	push   %eax
 619:	ff 75 08             	pushl  0x8(%ebp)
 61c:	e8 31 fe ff ff       	call   452 <putc>
 621:	83 c4 10             	add    $0x10,%esp
          s++;
 624:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 628:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62b:	0f b6 00             	movzbl (%eax),%eax
 62e:	84 c0                	test   %al,%al
 630:	75 da                	jne    60c <printf+0xe3>
 632:	eb 65                	jmp    699 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 634:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 638:	75 1d                	jne    657 <printf+0x12e>
        putc(fd, *ap);
 63a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	0f be c0             	movsbl %al,%eax
 642:	83 ec 08             	sub    $0x8,%esp
 645:	50                   	push   %eax
 646:	ff 75 08             	pushl  0x8(%ebp)
 649:	e8 04 fe ff ff       	call   452 <putc>
 64e:	83 c4 10             	add    $0x10,%esp
        ap++;
 651:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 655:	eb 42                	jmp    699 <printf+0x170>
      } else if(c == '%'){
 657:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 65b:	75 17                	jne    674 <printf+0x14b>
        putc(fd, c);
 65d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 660:	0f be c0             	movsbl %al,%eax
 663:	83 ec 08             	sub    $0x8,%esp
 666:	50                   	push   %eax
 667:	ff 75 08             	pushl  0x8(%ebp)
 66a:	e8 e3 fd ff ff       	call   452 <putc>
 66f:	83 c4 10             	add    $0x10,%esp
 672:	eb 25                	jmp    699 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 674:	83 ec 08             	sub    $0x8,%esp
 677:	6a 25                	push   $0x25
 679:	ff 75 08             	pushl  0x8(%ebp)
 67c:	e8 d1 fd ff ff       	call   452 <putc>
 681:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 687:	0f be c0             	movsbl %al,%eax
 68a:	83 ec 08             	sub    $0x8,%esp
 68d:	50                   	push   %eax
 68e:	ff 75 08             	pushl  0x8(%ebp)
 691:	e8 bc fd ff ff       	call   452 <putc>
 696:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 699:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6aa:	01 d0                	add    %edx,%eax
 6ac:	0f b6 00             	movzbl (%eax),%eax
 6af:	84 c0                	test   %al,%al
 6b1:	0f 85 94 fe ff ff    	jne    54b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b7:	90                   	nop
 6b8:	c9                   	leave  
 6b9:	c3                   	ret    

000006ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ba:	55                   	push   %ebp
 6bb:	89 e5                	mov    %esp,%ebp
 6bd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c0:	8b 45 08             	mov    0x8(%ebp),%eax
 6c3:	83 e8 08             	sub    $0x8,%eax
 6c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c9:	a1 68 0b 00 00       	mov    0xb68,%eax
 6ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d1:	eb 24                	jmp    6f7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 00                	mov    (%eax),%eax
 6d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6db:	77 12                	ja     6ef <free+0x35>
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e3:	77 24                	ja     709 <free+0x4f>
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ed:	77 1a                	ja     709 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 00                	mov    (%eax),%eax
 6f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fd:	76 d4                	jbe    6d3 <free+0x19>
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 707:	76 ca                	jbe    6d3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	8b 40 04             	mov    0x4(%eax),%eax
 70f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	01 c2                	add    %eax,%edx
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	39 c2                	cmp    %eax,%edx
 722:	75 24                	jne    748 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 724:	8b 45 f8             	mov    -0x8(%ebp),%eax
 727:	8b 50 04             	mov    0x4(%eax),%edx
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	8b 00                	mov    (%eax),%eax
 72f:	8b 40 04             	mov    0x4(%eax),%eax
 732:	01 c2                	add    %eax,%edx
 734:	8b 45 f8             	mov    -0x8(%ebp),%eax
 737:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 00                	mov    (%eax),%eax
 73f:	8b 10                	mov    (%eax),%edx
 741:	8b 45 f8             	mov    -0x8(%ebp),%eax
 744:	89 10                	mov    %edx,(%eax)
 746:	eb 0a                	jmp    752 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 10                	mov    (%eax),%edx
 74d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 750:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	8b 40 04             	mov    0x4(%eax),%eax
 758:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	01 d0                	add    %edx,%eax
 764:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 767:	75 20                	jne    789 <free+0xcf>
    p->s.size += bp->s.size;
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 50 04             	mov    0x4(%eax),%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	8b 40 04             	mov    0x4(%eax),%eax
 775:	01 c2                	add    %eax,%edx
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 77d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 780:	8b 10                	mov    (%eax),%edx
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	89 10                	mov    %edx,(%eax)
 787:	eb 08                	jmp    791 <free+0xd7>
  } else
    p->s.ptr = bp;
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 78f:	89 10                	mov    %edx,(%eax)
  freep = p;
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	a3 68 0b 00 00       	mov    %eax,0xb68
}
 799:	90                   	nop
 79a:	c9                   	leave  
 79b:	c3                   	ret    

0000079c <morecore>:

static Header*
morecore(uint nu)
{
 79c:	55                   	push   %ebp
 79d:	89 e5                	mov    %esp,%ebp
 79f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7a2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a9:	77 07                	ja     7b2 <morecore+0x16>
    nu = 4096;
 7ab:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7b2:	8b 45 08             	mov    0x8(%ebp),%eax
 7b5:	c1 e0 03             	shl    $0x3,%eax
 7b8:	83 ec 0c             	sub    $0xc,%esp
 7bb:	50                   	push   %eax
 7bc:	e8 39 fc ff ff       	call   3fa <sbrk>
 7c1:	83 c4 10             	add    $0x10,%esp
 7c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7cb:	75 07                	jne    7d4 <morecore+0x38>
    return 0;
 7cd:	b8 00 00 00 00       	mov    $0x0,%eax
 7d2:	eb 26                	jmp    7fa <morecore+0x5e>
  hp = (Header*)p;
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dd:	8b 55 08             	mov    0x8(%ebp),%edx
 7e0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e6:	83 c0 08             	add    $0x8,%eax
 7e9:	83 ec 0c             	sub    $0xc,%esp
 7ec:	50                   	push   %eax
 7ed:	e8 c8 fe ff ff       	call   6ba <free>
 7f2:	83 c4 10             	add    $0x10,%esp
  return freep;
 7f5:	a1 68 0b 00 00       	mov    0xb68,%eax
}
 7fa:	c9                   	leave  
 7fb:	c3                   	ret    

000007fc <malloc>:

void*
malloc(uint nbytes)
{
 7fc:	55                   	push   %ebp
 7fd:	89 e5                	mov    %esp,%ebp
 7ff:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 802:	8b 45 08             	mov    0x8(%ebp),%eax
 805:	83 c0 07             	add    $0x7,%eax
 808:	c1 e8 03             	shr    $0x3,%eax
 80b:	83 c0 01             	add    $0x1,%eax
 80e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 811:	a1 68 0b 00 00       	mov    0xb68,%eax
 816:	89 45 f0             	mov    %eax,-0x10(%ebp)
 819:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 81d:	75 23                	jne    842 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 81f:	c7 45 f0 60 0b 00 00 	movl   $0xb60,-0x10(%ebp)
 826:	8b 45 f0             	mov    -0x10(%ebp),%eax
 829:	a3 68 0b 00 00       	mov    %eax,0xb68
 82e:	a1 68 0b 00 00       	mov    0xb68,%eax
 833:	a3 60 0b 00 00       	mov    %eax,0xb60
    base.s.size = 0;
 838:	c7 05 64 0b 00 00 00 	movl   $0x0,0xb64
 83f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	8b 00                	mov    (%eax),%eax
 847:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	8b 40 04             	mov    0x4(%eax),%eax
 850:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 853:	72 4d                	jb     8a2 <malloc+0xa6>
      if(p->s.size == nunits)
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	8b 40 04             	mov    0x4(%eax),%eax
 85b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85e:	75 0c                	jne    86c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	8b 10                	mov    (%eax),%edx
 865:	8b 45 f0             	mov    -0x10(%ebp),%eax
 868:	89 10                	mov    %edx,(%eax)
 86a:	eb 26                	jmp    892 <malloc+0x96>
      else {
        p->s.size -= nunits;
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	8b 40 04             	mov    0x4(%eax),%eax
 872:	2b 45 ec             	sub    -0x14(%ebp),%eax
 875:	89 c2                	mov    %eax,%edx
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8b 40 04             	mov    0x4(%eax),%eax
 883:	c1 e0 03             	shl    $0x3,%eax
 886:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 88f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 892:	8b 45 f0             	mov    -0x10(%ebp),%eax
 895:	a3 68 0b 00 00       	mov    %eax,0xb68
      return (void*)(p + 1);
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	83 c0 08             	add    $0x8,%eax
 8a0:	eb 3b                	jmp    8dd <malloc+0xe1>
    }
    if(p == freep)
 8a2:	a1 68 0b 00 00       	mov    0xb68,%eax
 8a7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8aa:	75 1e                	jne    8ca <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8ac:	83 ec 0c             	sub    $0xc,%esp
 8af:	ff 75 ec             	pushl  -0x14(%ebp)
 8b2:	e8 e5 fe ff ff       	call   79c <morecore>
 8b7:	83 c4 10             	add    $0x10,%esp
 8ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c1:	75 07                	jne    8ca <malloc+0xce>
        return 0;
 8c3:	b8 00 00 00 00       	mov    $0x0,%eax
 8c8:	eb 13                	jmp    8dd <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d3:	8b 00                	mov    (%eax),%eax
 8d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8d8:	e9 6d ff ff ff       	jmp    84a <malloc+0x4e>
}
 8dd:	c9                   	leave  
 8de:	c3                   	ret    
