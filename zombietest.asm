
_zombietest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#define TPS 100

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int i, pid;

  for (i=0; i<5; i++) {
  11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  18:	eb 76                	jmp    90 <main+0x90>
    pid = fork();
  1a:	e8 bf 03 00 00       	call   3de <fork>
  1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid == 0) {   // child)
  22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  26:	75 64                	jne    8c <main+0x8c>
      pid = getpid();
  28:	e8 39 04 00 00       	call   466 <getpid>
  2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      sleep(pid); // try to avoid messed up output from child processes
  30:	83 ec 0c             	sub    $0xc,%esp
  33:	ff 75 f0             	pushl  -0x10(%ebp)
  36:	e8 3b 04 00 00       	call   476 <sleep>
  3b:	83 c4 10             	add    $0x10,%esp
      int newval = pid;
  3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  41:	89 45 ec             	mov    %eax,-0x14(%ebp)
      printf(1, "Process %d: setting UID and GID to %d\n", pid, newval);
  44:	ff 75 ec             	pushl  -0x14(%ebp)
  47:	ff 75 f0             	pushl  -0x10(%ebp)
  4a:	68 74 09 00 00       	push   $0x974
  4f:	6a 01                	push   $0x1
  51:	e8 67 05 00 00       	call   5bd <printf>
  56:	83 c4 10             	add    $0x10,%esp
      setuid(newval);
  59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  5c:	83 ec 0c             	sub    $0xc,%esp
  5f:	50                   	push   %eax
  60:	e8 49 04 00 00       	call   4ae <setuid>
  65:	83 c4 10             	add    $0x10,%esp
      setgid(newval);
  68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  6b:	83 ec 0c             	sub    $0xc,%esp
  6e:	50                   	push   %eax
  6f:	e8 42 04 00 00       	call   4b6 <setgid>
  74:	83 c4 10             	add    $0x10,%esp
      sleep(10*TPS);  // pause before exit - just because
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	68 e8 03 00 00       	push   $0x3e8
  7f:	e8 f2 03 00 00       	call   476 <sleep>
  84:	83 c4 10             	add    $0x10,%esp
      exit();
  87:	e8 5a 03 00 00       	call   3e6 <exit>
int
main(int argc, char *argv[])
{
  int i, pid;

  for (i=0; i<5; i++) {
  8c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  90:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
  94:	7e 84                	jle    1a <main+0x1a>
      setgid(newval);
      sleep(10*TPS);  // pause before exit - just because
      exit();
    }
  }
  sleep(50 * TPS);  // sleep 10 seconds
  96:	83 ec 0c             	sub    $0xc,%esp
  99:	68 88 13 00 00       	push   $0x1388
  9e:	e8 d3 03 00 00       	call   476 <sleep>
  a3:	83 c4 10             	add    $0x10,%esp
  while (wait() != -1)
  a6:	eb 05                	jmp    ad <main+0xad>
    wait();
  a8:	e8 41 03 00 00       	call   3ee <wait>
      sleep(10*TPS);  // pause before exit - just because
      exit();
    }
  }
  sleep(50 * TPS);  // sleep 10 seconds
  while (wait() != -1)
  ad:	e8 3c 03 00 00       	call   3ee <wait>
  b2:	83 f8 ff             	cmp    $0xffffffff,%eax
  b5:	75 f1                	jne    a8 <main+0xa8>
    wait();

  exit();
  b7:	e8 2a 03 00 00       	call   3e6 <exit>

000000bc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	57                   	push   %edi
  c0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  c4:	8b 55 10             	mov    0x10(%ebp),%edx
  c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ca:	89 cb                	mov    %ecx,%ebx
  cc:	89 df                	mov    %ebx,%edi
  ce:	89 d1                	mov    %edx,%ecx
  d0:	fc                   	cld    
  d1:	f3 aa                	rep stos %al,%es:(%edi)
  d3:	89 ca                	mov    %ecx,%edx
  d5:	89 fb                	mov    %edi,%ebx
  d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
  da:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  dd:	90                   	nop
  de:	5b                   	pop    %ebx
  df:	5f                   	pop    %edi
  e0:	5d                   	pop    %ebp
  e1:	c3                   	ret    

000000e2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e2:	55                   	push   %ebp
  e3:	89 e5                	mov    %esp,%ebp
  e5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ee:	90                   	nop
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	8d 50 01             	lea    0x1(%eax),%edx
  f5:	89 55 08             	mov    %edx,0x8(%ebp)
  f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  fe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 101:	0f b6 12             	movzbl (%edx),%edx
 104:	88 10                	mov    %dl,(%eax)
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	84 c0                	test   %al,%al
 10b:	75 e2                	jne    ef <strcpy+0xd>
    ;
  return os;
 10d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 110:	c9                   	leave  
 111:	c3                   	ret    

00000112 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 112:	55                   	push   %ebp
 113:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 115:	eb 08                	jmp    11f <strcmp+0xd>
    p++, q++;
 117:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	74 10                	je     139 <strcmp+0x27>
 129:	8b 45 08             	mov    0x8(%ebp),%eax
 12c:	0f b6 10             	movzbl (%eax),%edx
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	38 c2                	cmp    %al,%dl
 137:	74 de                	je     117 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	0f b6 00             	movzbl (%eax),%eax
 13f:	0f b6 d0             	movzbl %al,%edx
 142:	8b 45 0c             	mov    0xc(%ebp),%eax
 145:	0f b6 00             	movzbl (%eax),%eax
 148:	0f b6 c0             	movzbl %al,%eax
 14b:	29 c2                	sub    %eax,%edx
 14d:	89 d0                	mov    %edx,%eax
}
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    

00000151 <strlen>:

uint
strlen(char *s)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 15e:	eb 04                	jmp    164 <strlen+0x13>
 160:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 164:	8b 55 fc             	mov    -0x4(%ebp),%edx
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	01 d0                	add    %edx,%eax
 16c:	0f b6 00             	movzbl (%eax),%eax
 16f:	84 c0                	test   %al,%al
 171:	75 ed                	jne    160 <strlen+0xf>
    ;
  return n;
 173:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 176:	c9                   	leave  
 177:	c3                   	ret    

00000178 <memset>:

void*
memset(void *dst, int c, uint n)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 17b:	8b 45 10             	mov    0x10(%ebp),%eax
 17e:	50                   	push   %eax
 17f:	ff 75 0c             	pushl  0xc(%ebp)
 182:	ff 75 08             	pushl  0x8(%ebp)
 185:	e8 32 ff ff ff       	call   bc <stosb>
 18a:	83 c4 0c             	add    $0xc,%esp
  return dst;
 18d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 190:	c9                   	leave  
 191:	c3                   	ret    

00000192 <strchr>:

char*
strchr(const char *s, char c)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
 195:	83 ec 04             	sub    $0x4,%esp
 198:	8b 45 0c             	mov    0xc(%ebp),%eax
 19b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 19e:	eb 14                	jmp    1b4 <strchr+0x22>
    if(*s == c)
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1a9:	75 05                	jne    1b0 <strchr+0x1e>
      return (char*)s;
 1ab:	8b 45 08             	mov    0x8(%ebp),%eax
 1ae:	eb 13                	jmp    1c3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	0f b6 00             	movzbl (%eax),%eax
 1ba:	84 c0                	test   %al,%al
 1bc:	75 e2                	jne    1a0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1be:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c3:	c9                   	leave  
 1c4:	c3                   	ret    

000001c5 <gets>:

char*
gets(char *buf, int max)
{
 1c5:	55                   	push   %ebp
 1c6:	89 e5                	mov    %esp,%ebp
 1c8:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1d2:	eb 42                	jmp    216 <gets+0x51>
    cc = read(0, &c, 1);
 1d4:	83 ec 04             	sub    $0x4,%esp
 1d7:	6a 01                	push   $0x1
 1d9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1dc:	50                   	push   %eax
 1dd:	6a 00                	push   $0x0
 1df:	e8 1a 02 00 00       	call   3fe <read>
 1e4:	83 c4 10             	add    $0x10,%esp
 1e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ee:	7e 33                	jle    223 <gets+0x5e>
      break;
    buf[i++] = c;
 1f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1f9:	89 c2                	mov    %eax,%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	01 c2                	add    %eax,%edx
 200:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 204:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 206:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20a:	3c 0a                	cmp    $0xa,%al
 20c:	74 16                	je     224 <gets+0x5f>
 20e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 212:	3c 0d                	cmp    $0xd,%al
 214:	74 0e                	je     224 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 216:	8b 45 f4             	mov    -0xc(%ebp),%eax
 219:	83 c0 01             	add    $0x1,%eax
 21c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 21f:	7c b3                	jl     1d4 <gets+0xf>
 221:	eb 01                	jmp    224 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 223:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 224:	8b 55 f4             	mov    -0xc(%ebp),%edx
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	01 d0                	add    %edx,%eax
 22c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <stat>:

int
stat(char *n, struct stat *st)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23a:	83 ec 08             	sub    $0x8,%esp
 23d:	6a 00                	push   $0x0
 23f:	ff 75 08             	pushl  0x8(%ebp)
 242:	e8 df 01 00 00       	call   426 <open>
 247:	83 c4 10             	add    $0x10,%esp
 24a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 24d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 251:	79 07                	jns    25a <stat+0x26>
    return -1;
 253:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 258:	eb 25                	jmp    27f <stat+0x4b>
  r = fstat(fd, st);
 25a:	83 ec 08             	sub    $0x8,%esp
 25d:	ff 75 0c             	pushl  0xc(%ebp)
 260:	ff 75 f4             	pushl  -0xc(%ebp)
 263:	e8 d6 01 00 00       	call   43e <fstat>
 268:	83 c4 10             	add    $0x10,%esp
 26b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 26e:	83 ec 0c             	sub    $0xc,%esp
 271:	ff 75 f4             	pushl  -0xc(%ebp)
 274:	e8 95 01 00 00       	call   40e <close>
 279:	83 c4 10             	add    $0x10,%esp
  return r;
 27c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 27f:	c9                   	leave  
 280:	c3                   	ret    

00000281 <atoi>:

int
atoi(const char *s)
{
 281:	55                   	push   %ebp
 282:	89 e5                	mov    %esp,%ebp
 284:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 287:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 28e:	eb 04                	jmp    294 <atoi+0x13>
 290:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	0f b6 00             	movzbl (%eax),%eax
 29a:	3c 20                	cmp    $0x20,%al
 29c:	74 f2                	je     290 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	0f b6 00             	movzbl (%eax),%eax
 2a4:	3c 2d                	cmp    $0x2d,%al
 2a6:	75 07                	jne    2af <atoi+0x2e>
 2a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ad:	eb 05                	jmp    2b4 <atoi+0x33>
 2af:	b8 01 00 00 00       	mov    $0x1,%eax
 2b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 00             	movzbl (%eax),%eax
 2bd:	3c 2b                	cmp    $0x2b,%al
 2bf:	74 0a                	je     2cb <atoi+0x4a>
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	0f b6 00             	movzbl (%eax),%eax
 2c7:	3c 2d                	cmp    $0x2d,%al
 2c9:	75 2b                	jne    2f6 <atoi+0x75>
    s++;
 2cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2cf:	eb 25                	jmp    2f6 <atoi+0x75>
    n = n*10 + *s++ - '0';
 2d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d4:	89 d0                	mov    %edx,%eax
 2d6:	c1 e0 02             	shl    $0x2,%eax
 2d9:	01 d0                	add    %edx,%eax
 2db:	01 c0                	add    %eax,%eax
 2dd:	89 c1                	mov    %eax,%ecx
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	8d 50 01             	lea    0x1(%eax),%edx
 2e5:	89 55 08             	mov    %edx,0x8(%ebp)
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	0f be c0             	movsbl %al,%eax
 2ee:	01 c8                	add    %ecx,%eax
 2f0:	83 e8 30             	sub    $0x30,%eax
 2f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	3c 2f                	cmp    $0x2f,%al
 2fe:	7e 0a                	jle    30a <atoi+0x89>
 300:	8b 45 08             	mov    0x8(%ebp),%eax
 303:	0f b6 00             	movzbl (%eax),%eax
 306:	3c 39                	cmp    $0x39,%al
 308:	7e c7                	jle    2d1 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 30a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 30d:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <atoo>:

int
atoo(const char *s)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 319:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 320:	eb 04                	jmp    326 <atoo+0x13>
 322:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	0f b6 00             	movzbl (%eax),%eax
 32c:	3c 20                	cmp    $0x20,%al
 32e:	74 f2                	je     322 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	0f b6 00             	movzbl (%eax),%eax
 336:	3c 2d                	cmp    $0x2d,%al
 338:	75 07                	jne    341 <atoo+0x2e>
 33a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 33f:	eb 05                	jmp    346 <atoo+0x33>
 341:	b8 01 00 00 00       	mov    $0x1,%eax
 346:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	0f b6 00             	movzbl (%eax),%eax
 34f:	3c 2b                	cmp    $0x2b,%al
 351:	74 0a                	je     35d <atoo+0x4a>
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	0f b6 00             	movzbl (%eax),%eax
 359:	3c 2d                	cmp    $0x2d,%al
 35b:	75 27                	jne    384 <atoo+0x71>
    s++;
 35d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 361:	eb 21                	jmp    384 <atoo+0x71>
    n = n*8 + *s++ - '0';
 363:	8b 45 fc             	mov    -0x4(%ebp),%eax
 366:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	8d 50 01             	lea    0x1(%eax),%edx
 373:	89 55 08             	mov    %edx,0x8(%ebp)
 376:	0f b6 00             	movzbl (%eax),%eax
 379:	0f be c0             	movsbl %al,%eax
 37c:	01 c8                	add    %ecx,%eax
 37e:	83 e8 30             	sub    $0x30,%eax
 381:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	0f b6 00             	movzbl (%eax),%eax
 38a:	3c 2f                	cmp    $0x2f,%al
 38c:	7e 0a                	jle    398 <atoo+0x85>
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	3c 37                	cmp    $0x37,%al
 396:	7e cb                	jle    363 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 398:	8b 45 f8             	mov    -0x8(%ebp),%eax
 39b:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    

000003a1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3a1:	55                   	push   %ebp
 3a2:	89 e5                	mov    %esp,%ebp
 3a4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3b3:	eb 17                	jmp    3cc <memmove+0x2b>
    *dst++ = *src++;
 3b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b8:	8d 50 01             	lea    0x1(%eax),%edx
 3bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3be:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3c1:	8d 4a 01             	lea    0x1(%edx),%ecx
 3c4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3c7:	0f b6 12             	movzbl (%edx),%edx
 3ca:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3cc:	8b 45 10             	mov    0x10(%ebp),%eax
 3cf:	8d 50 ff             	lea    -0x1(%eax),%edx
 3d2:	89 55 10             	mov    %edx,0x10(%ebp)
 3d5:	85 c0                	test   %eax,%eax
 3d7:	7f dc                	jg     3b5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3dc:	c9                   	leave  
 3dd:	c3                   	ret    

000003de <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3de:	b8 01 00 00 00       	mov    $0x1,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <exit>:
SYSCALL(exit)
 3e6:	b8 02 00 00 00       	mov    $0x2,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <wait>:
SYSCALL(wait)
 3ee:	b8 03 00 00 00       	mov    $0x3,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <pipe>:
SYSCALL(pipe)
 3f6:	b8 04 00 00 00       	mov    $0x4,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <read>:
SYSCALL(read)
 3fe:	b8 05 00 00 00       	mov    $0x5,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <write>:
SYSCALL(write)
 406:	b8 10 00 00 00       	mov    $0x10,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <close>:
SYSCALL(close)
 40e:	b8 15 00 00 00       	mov    $0x15,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <kill>:
SYSCALL(kill)
 416:	b8 06 00 00 00       	mov    $0x6,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <exec>:
SYSCALL(exec)
 41e:	b8 07 00 00 00       	mov    $0x7,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <open>:
SYSCALL(open)
 426:	b8 0f 00 00 00       	mov    $0xf,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <mknod>:
SYSCALL(mknod)
 42e:	b8 11 00 00 00       	mov    $0x11,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <unlink>:
SYSCALL(unlink)
 436:	b8 12 00 00 00       	mov    $0x12,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <fstat>:
SYSCALL(fstat)
 43e:	b8 08 00 00 00       	mov    $0x8,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <link>:
SYSCALL(link)
 446:	b8 13 00 00 00       	mov    $0x13,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <mkdir>:
SYSCALL(mkdir)
 44e:	b8 14 00 00 00       	mov    $0x14,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <chdir>:
SYSCALL(chdir)
 456:	b8 09 00 00 00       	mov    $0x9,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <dup>:
SYSCALL(dup)
 45e:	b8 0a 00 00 00       	mov    $0xa,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <getpid>:
SYSCALL(getpid)
 466:	b8 0b 00 00 00       	mov    $0xb,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <sbrk>:
SYSCALL(sbrk)
 46e:	b8 0c 00 00 00       	mov    $0xc,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <sleep>:
SYSCALL(sleep)
 476:	b8 0d 00 00 00       	mov    $0xd,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <uptime>:
SYSCALL(uptime)
 47e:	b8 0e 00 00 00       	mov    $0xe,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <halt>:
SYSCALL(halt)
 486:	b8 16 00 00 00       	mov    $0x16,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <date>:
SYSCALL(date)        #p1
 48e:	b8 17 00 00 00       	mov    $0x17,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <getuid>:
SYSCALL(getuid)      #p2
 496:	b8 18 00 00 00       	mov    $0x18,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <getgid>:
SYSCALL(getgid)      #p2
 49e:	b8 19 00 00 00       	mov    $0x19,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <getppid>:
SYSCALL(getppid)     #p2
 4a6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <setuid>:
SYSCALL(setuid)      #p2
 4ae:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <setgid>:
SYSCALL(setgid)      #p2
 4b6:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <getprocs>:
SYSCALL(getprocs)    #p2
 4be:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <setpriority>:
SYSCALL(setpriority) #p4
 4c6:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <chmod>:
SYSCALL(chmod)       #p5
 4ce:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <chown>:
SYSCALL(chown)       #p5
 4d6:	b8 20 00 00 00       	mov    $0x20,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <chgrp>:
SYSCALL(chgrp)       #p5
 4de:	b8 21 00 00 00       	mov    $0x21,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e6:	55                   	push   %ebp
 4e7:	89 e5                	mov    %esp,%ebp
 4e9:	83 ec 18             	sub    $0x18,%esp
 4ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ef:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f2:	83 ec 04             	sub    $0x4,%esp
 4f5:	6a 01                	push   $0x1
 4f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4fa:	50                   	push   %eax
 4fb:	ff 75 08             	pushl  0x8(%ebp)
 4fe:	e8 03 ff ff ff       	call   406 <write>
 503:	83 c4 10             	add    $0x10,%esp
}
 506:	90                   	nop
 507:	c9                   	leave  
 508:	c3                   	ret    

00000509 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	53                   	push   %ebx
 50d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 510:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 517:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 51b:	74 17                	je     534 <printint+0x2b>
 51d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 521:	79 11                	jns    534 <printint+0x2b>
    neg = 1;
 523:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 52a:	8b 45 0c             	mov    0xc(%ebp),%eax
 52d:	f7 d8                	neg    %eax
 52f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 532:	eb 06                	jmp    53a <printint+0x31>
  } else {
    x = xx;
 534:	8b 45 0c             	mov    0xc(%ebp),%eax
 537:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 53a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 541:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 544:	8d 41 01             	lea    0x1(%ecx),%eax
 547:	89 45 f4             	mov    %eax,-0xc(%ebp)
 54a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 54d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 550:	ba 00 00 00 00       	mov    $0x0,%edx
 555:	f7 f3                	div    %ebx
 557:	89 d0                	mov    %edx,%eax
 559:	0f b6 80 0c 0c 00 00 	movzbl 0xc0c(%eax),%eax
 560:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 564:	8b 5d 10             	mov    0x10(%ebp),%ebx
 567:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56a:	ba 00 00 00 00       	mov    $0x0,%edx
 56f:	f7 f3                	div    %ebx
 571:	89 45 ec             	mov    %eax,-0x14(%ebp)
 574:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 578:	75 c7                	jne    541 <printint+0x38>
  if(neg)
 57a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 57e:	74 2d                	je     5ad <printint+0xa4>
    buf[i++] = '-';
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	8d 50 01             	lea    0x1(%eax),%edx
 586:	89 55 f4             	mov    %edx,-0xc(%ebp)
 589:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 58e:	eb 1d                	jmp    5ad <printint+0xa4>
    putc(fd, buf[i]);
 590:	8d 55 dc             	lea    -0x24(%ebp),%edx
 593:	8b 45 f4             	mov    -0xc(%ebp),%eax
 596:	01 d0                	add    %edx,%eax
 598:	0f b6 00             	movzbl (%eax),%eax
 59b:	0f be c0             	movsbl %al,%eax
 59e:	83 ec 08             	sub    $0x8,%esp
 5a1:	50                   	push   %eax
 5a2:	ff 75 08             	pushl  0x8(%ebp)
 5a5:	e8 3c ff ff ff       	call   4e6 <putc>
 5aa:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b5:	79 d9                	jns    590 <printint+0x87>
    putc(fd, buf[i]);
}
 5b7:	90                   	nop
 5b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5bb:	c9                   	leave  
 5bc:	c3                   	ret    

000005bd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5bd:	55                   	push   %ebp
 5be:	89 e5                	mov    %esp,%ebp
 5c0:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ca:	8d 45 0c             	lea    0xc(%ebp),%eax
 5cd:	83 c0 04             	add    $0x4,%eax
 5d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5da:	e9 59 01 00 00       	jmp    738 <printf+0x17b>
    c = fmt[i] & 0xff;
 5df:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e5:	01 d0                	add    %edx,%eax
 5e7:	0f b6 00             	movzbl (%eax),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	25 ff 00 00 00       	and    $0xff,%eax
 5f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f9:	75 2c                	jne    627 <printf+0x6a>
      if(c == '%'){
 5fb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ff:	75 0c                	jne    60d <printf+0x50>
        state = '%';
 601:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 608:	e9 27 01 00 00       	jmp    734 <printf+0x177>
      } else {
        putc(fd, c);
 60d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	83 ec 08             	sub    $0x8,%esp
 616:	50                   	push   %eax
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 c7 fe ff ff       	call   4e6 <putc>
 61f:	83 c4 10             	add    $0x10,%esp
 622:	e9 0d 01 00 00       	jmp    734 <printf+0x177>
      }
    } else if(state == '%'){
 627:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 62b:	0f 85 03 01 00 00    	jne    734 <printf+0x177>
      if(c == 'd'){
 631:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 635:	75 1e                	jne    655 <printf+0x98>
        printint(fd, *ap, 10, 1);
 637:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	6a 01                	push   $0x1
 63e:	6a 0a                	push   $0xa
 640:	50                   	push   %eax
 641:	ff 75 08             	pushl  0x8(%ebp)
 644:	e8 c0 fe ff ff       	call   509 <printint>
 649:	83 c4 10             	add    $0x10,%esp
        ap++;
 64c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 650:	e9 d8 00 00 00       	jmp    72d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 655:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 659:	74 06                	je     661 <printf+0xa4>
 65b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 65f:	75 1e                	jne    67f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 661:	8b 45 e8             	mov    -0x18(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	6a 00                	push   $0x0
 668:	6a 10                	push   $0x10
 66a:	50                   	push   %eax
 66b:	ff 75 08             	pushl  0x8(%ebp)
 66e:	e8 96 fe ff ff       	call   509 <printint>
 673:	83 c4 10             	add    $0x10,%esp
        ap++;
 676:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67a:	e9 ae 00 00 00       	jmp    72d <printf+0x170>
      } else if(c == 's'){
 67f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 683:	75 43                	jne    6c8 <printf+0x10b>
        s = (char*)*ap;
 685:	8b 45 e8             	mov    -0x18(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 68d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 695:	75 25                	jne    6bc <printf+0xff>
          s = "(null)";
 697:	c7 45 f4 9b 09 00 00 	movl   $0x99b,-0xc(%ebp)
        while(*s != 0){
 69e:	eb 1c                	jmp    6bc <printf+0xff>
          putc(fd, *s);
 6a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a3:	0f b6 00             	movzbl (%eax),%eax
 6a6:	0f be c0             	movsbl %al,%eax
 6a9:	83 ec 08             	sub    $0x8,%esp
 6ac:	50                   	push   %eax
 6ad:	ff 75 08             	pushl  0x8(%ebp)
 6b0:	e8 31 fe ff ff       	call   4e6 <putc>
 6b5:	83 c4 10             	add    $0x10,%esp
          s++;
 6b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bf:	0f b6 00             	movzbl (%eax),%eax
 6c2:	84 c0                	test   %al,%al
 6c4:	75 da                	jne    6a0 <printf+0xe3>
 6c6:	eb 65                	jmp    72d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6cc:	75 1d                	jne    6eb <printf+0x12e>
        putc(fd, *ap);
 6ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	0f be c0             	movsbl %al,%eax
 6d6:	83 ec 08             	sub    $0x8,%esp
 6d9:	50                   	push   %eax
 6da:	ff 75 08             	pushl  0x8(%ebp)
 6dd:	e8 04 fe ff ff       	call   4e6 <putc>
 6e2:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e9:	eb 42                	jmp    72d <printf+0x170>
      } else if(c == '%'){
 6eb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ef:	75 17                	jne    708 <printf+0x14b>
        putc(fd, c);
 6f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f4:	0f be c0             	movsbl %al,%eax
 6f7:	83 ec 08             	sub    $0x8,%esp
 6fa:	50                   	push   %eax
 6fb:	ff 75 08             	pushl  0x8(%ebp)
 6fe:	e8 e3 fd ff ff       	call   4e6 <putc>
 703:	83 c4 10             	add    $0x10,%esp
 706:	eb 25                	jmp    72d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 708:	83 ec 08             	sub    $0x8,%esp
 70b:	6a 25                	push   $0x25
 70d:	ff 75 08             	pushl  0x8(%ebp)
 710:	e8 d1 fd ff ff       	call   4e6 <putc>
 715:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71b:	0f be c0             	movsbl %al,%eax
 71e:	83 ec 08             	sub    $0x8,%esp
 721:	50                   	push   %eax
 722:	ff 75 08             	pushl  0x8(%ebp)
 725:	e8 bc fd ff ff       	call   4e6 <putc>
 72a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 72d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 734:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 738:	8b 55 0c             	mov    0xc(%ebp),%edx
 73b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73e:	01 d0                	add    %edx,%eax
 740:	0f b6 00             	movzbl (%eax),%eax
 743:	84 c0                	test   %al,%al
 745:	0f 85 94 fe ff ff    	jne    5df <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 74b:	90                   	nop
 74c:	c9                   	leave  
 74d:	c3                   	ret    

0000074e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74e:	55                   	push   %ebp
 74f:	89 e5                	mov    %esp,%ebp
 751:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	83 e8 08             	sub    $0x8,%eax
 75a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75d:	a1 28 0c 00 00       	mov    0xc28,%eax
 762:	89 45 fc             	mov    %eax,-0x4(%ebp)
 765:	eb 24                	jmp    78b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76f:	77 12                	ja     783 <free+0x35>
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 777:	77 24                	ja     79d <free+0x4f>
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 781:	77 1a                	ja     79d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 791:	76 d4                	jbe    767 <free+0x19>
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79b:	76 ca                	jbe    767 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ad:	01 c2                	add    %eax,%edx
 7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b2:	8b 00                	mov    (%eax),%eax
 7b4:	39 c2                	cmp    %eax,%edx
 7b6:	75 24                	jne    7dc <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bb:	8b 50 04             	mov    0x4(%eax),%edx
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	8b 40 04             	mov    0x4(%eax),%eax
 7c6:	01 c2                	add    %eax,%edx
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	8b 00                	mov    (%eax),%eax
 7d3:	8b 10                	mov    (%eax),%edx
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	89 10                	mov    %edx,(%eax)
 7da:	eb 0a                	jmp    7e6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	8b 10                	mov    (%eax),%edx
 7e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	01 d0                	add    %edx,%eax
 7f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fb:	75 20                	jne    81d <free+0xcf>
    p->s.size += bp->s.size;
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 50 04             	mov    0x4(%eax),%edx
 803:	8b 45 f8             	mov    -0x8(%ebp),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	01 c2                	add    %eax,%edx
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
 81b:	eb 08                	jmp    825 <free+0xd7>
  } else
    p->s.ptr = bp;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 55 f8             	mov    -0x8(%ebp),%edx
 823:	89 10                	mov    %edx,(%eax)
  freep = p;
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	a3 28 0c 00 00       	mov    %eax,0xc28
}
 82d:	90                   	nop
 82e:	c9                   	leave  
 82f:	c3                   	ret    

00000830 <morecore>:

static Header*
morecore(uint nu)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 836:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83d:	77 07                	ja     846 <morecore+0x16>
    nu = 4096;
 83f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 846:	8b 45 08             	mov    0x8(%ebp),%eax
 849:	c1 e0 03             	shl    $0x3,%eax
 84c:	83 ec 0c             	sub    $0xc,%esp
 84f:	50                   	push   %eax
 850:	e8 19 fc ff ff       	call   46e <sbrk>
 855:	83 c4 10             	add    $0x10,%esp
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 85b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 85f:	75 07                	jne    868 <morecore+0x38>
    return 0;
 861:	b8 00 00 00 00       	mov    $0x0,%eax
 866:	eb 26                	jmp    88e <morecore+0x5e>
  hp = (Header*)p;
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	8b 55 08             	mov    0x8(%ebp),%edx
 874:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	83 c0 08             	add    $0x8,%eax
 87d:	83 ec 0c             	sub    $0xc,%esp
 880:	50                   	push   %eax
 881:	e8 c8 fe ff ff       	call   74e <free>
 886:	83 c4 10             	add    $0x10,%esp
  return freep;
 889:	a1 28 0c 00 00       	mov    0xc28,%eax
}
 88e:	c9                   	leave  
 88f:	c3                   	ret    

00000890 <malloc>:

void*
malloc(uint nbytes)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 896:	8b 45 08             	mov    0x8(%ebp),%eax
 899:	83 c0 07             	add    $0x7,%eax
 89c:	c1 e8 03             	shr    $0x3,%eax
 89f:	83 c0 01             	add    $0x1,%eax
 8a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a5:	a1 28 0c 00 00       	mov    0xc28,%eax
 8aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b1:	75 23                	jne    8d6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b3:	c7 45 f0 20 0c 00 00 	movl   $0xc20,-0x10(%ebp)
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	a3 28 0c 00 00       	mov    %eax,0xc28
 8c2:	a1 28 0c 00 00       	mov    0xc28,%eax
 8c7:	a3 20 0c 00 00       	mov    %eax,0xc20
    base.s.size = 0;
 8cc:	c7 05 24 0c 00 00 00 	movl   $0x0,0xc24
 8d3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e1:	8b 40 04             	mov    0x4(%eax),%eax
 8e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e7:	72 4d                	jb     936 <malloc+0xa6>
      if(p->s.size == nunits)
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	8b 40 04             	mov    0x4(%eax),%eax
 8ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f2:	75 0c                	jne    900 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	8b 10                	mov    (%eax),%edx
 8f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fc:	89 10                	mov    %edx,(%eax)
 8fe:	eb 26                	jmp    926 <malloc+0x96>
      else {
        p->s.size -= nunits;
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	8b 40 04             	mov    0x4(%eax),%eax
 906:	2b 45 ec             	sub    -0x14(%ebp),%eax
 909:	89 c2                	mov    %eax,%edx
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	8b 40 04             	mov    0x4(%eax),%eax
 917:	c1 e0 03             	shl    $0x3,%eax
 91a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	8b 55 ec             	mov    -0x14(%ebp),%edx
 923:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 926:	8b 45 f0             	mov    -0x10(%ebp),%eax
 929:	a3 28 0c 00 00       	mov    %eax,0xc28
      return (void*)(p + 1);
 92e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 931:	83 c0 08             	add    $0x8,%eax
 934:	eb 3b                	jmp    971 <malloc+0xe1>
    }
    if(p == freep)
 936:	a1 28 0c 00 00       	mov    0xc28,%eax
 93b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 93e:	75 1e                	jne    95e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 940:	83 ec 0c             	sub    $0xc,%esp
 943:	ff 75 ec             	pushl  -0x14(%ebp)
 946:	e8 e5 fe ff ff       	call   830 <morecore>
 94b:	83 c4 10             	add    $0x10,%esp
 94e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 955:	75 07                	jne    95e <malloc+0xce>
        return 0;
 957:	b8 00 00 00 00       	mov    $0x0,%eax
 95c:	eb 13                	jmp    971 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	89 45 f0             	mov    %eax,-0x10(%ebp)
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 96c:	e9 6d ff ff ff       	jmp    8de <malloc+0x4e>
}
 971:	c9                   	leave  
 972:	c3                   	ret    
