
_halt:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// halt the system.
#include "types.h"
#include "user.h"

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  halt();
  11:	e8 05 03 00 00       	call   31b <halt>
  return 0;
  16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1b:	83 c4 04             	add    $0x4,%esp
  1e:	59                   	pop    %ecx
  1f:	5d                   	pop    %ebp
  20:	8d 61 fc             	lea    -0x4(%ecx),%esp
  23:	c3                   	ret    

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	90                   	nop
  46:	5b                   	pop    %ebx
  47:	5f                   	pop    %edi
  48:	5d                   	pop    %ebp
  49:	c3                   	ret    

0000004a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4a:	55                   	push   %ebp
  4b:	89 e5                	mov    %esp,%ebp
  4d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  50:	8b 45 08             	mov    0x8(%ebp),%eax
  53:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  56:	90                   	nop
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	8d 50 01             	lea    0x1(%eax),%edx
  5d:	89 55 08             	mov    %edx,0x8(%ebp)
  60:	8b 55 0c             	mov    0xc(%ebp),%edx
  63:	8d 4a 01             	lea    0x1(%edx),%ecx
  66:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  69:	0f b6 12             	movzbl (%edx),%edx
  6c:	88 10                	mov    %dl,(%eax)
  6e:	0f b6 00             	movzbl (%eax),%eax
  71:	84 c0                	test   %al,%al
  73:	75 e2                	jne    57 <strcpy+0xd>
    ;
  return os;
  75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  78:	c9                   	leave  
  79:	c3                   	ret    

0000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7d:	eb 08                	jmp    87 <strcmp+0xd>
    p++, q++;
  7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  83:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  87:	8b 45 08             	mov    0x8(%ebp),%eax
  8a:	0f b6 00             	movzbl (%eax),%eax
  8d:	84 c0                	test   %al,%al
  8f:	74 10                	je     a1 <strcmp+0x27>
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	0f b6 10             	movzbl (%eax),%edx
  97:	8b 45 0c             	mov    0xc(%ebp),%eax
  9a:	0f b6 00             	movzbl (%eax),%eax
  9d:	38 c2                	cmp    %al,%dl
  9f:	74 de                	je     7f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	0f b6 00             	movzbl (%eax),%eax
  a7:	0f b6 d0             	movzbl %al,%edx
  aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  ad:	0f b6 00             	movzbl (%eax),%eax
  b0:	0f b6 c0             	movzbl %al,%eax
  b3:	29 c2                	sub    %eax,%edx
  b5:	89 d0                	mov    %edx,%eax
}
  b7:	5d                   	pop    %ebp
  b8:	c3                   	ret    

000000b9 <strlen>:

uint
strlen(char *s)
{
  b9:	55                   	push   %ebp
  ba:	89 e5                	mov    %esp,%ebp
  bc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c6:	eb 04                	jmp    cc <strlen+0x13>
  c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	01 d0                	add    %edx,%eax
  d4:	0f b6 00             	movzbl (%eax),%eax
  d7:	84 c0                	test   %al,%al
  d9:	75 ed                	jne    c8 <strlen+0xf>
    ;
  return n;
  db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  de:	c9                   	leave  
  df:	c3                   	ret    

000000e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e3:	8b 45 10             	mov    0x10(%ebp),%eax
  e6:	50                   	push   %eax
  e7:	ff 75 0c             	pushl  0xc(%ebp)
  ea:	ff 75 08             	pushl  0x8(%ebp)
  ed:	e8 32 ff ff ff       	call   24 <stosb>
  f2:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f8:	c9                   	leave  
  f9:	c3                   	ret    

000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 04             	sub    $0x4,%esp
 100:	8b 45 0c             	mov    0xc(%ebp),%eax
 103:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 106:	eb 14                	jmp    11c <strchr+0x22>
    if(*s == c)
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	0f b6 00             	movzbl (%eax),%eax
 10e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 111:	75 05                	jne    118 <strchr+0x1e>
      return (char*)s;
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	eb 13                	jmp    12b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 118:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	84 c0                	test   %al,%al
 124:	75 e2                	jne    108 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 126:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <gets>:

char*
gets(char *buf, int max)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 133:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13a:	eb 42                	jmp    17e <gets+0x51>
    cc = read(0, &c, 1);
 13c:	83 ec 04             	sub    $0x4,%esp
 13f:	6a 01                	push   $0x1
 141:	8d 45 ef             	lea    -0x11(%ebp),%eax
 144:	50                   	push   %eax
 145:	6a 00                	push   $0x0
 147:	e8 47 01 00 00       	call   293 <read>
 14c:	83 c4 10             	add    $0x10,%esp
 14f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 152:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 156:	7e 33                	jle    18b <gets+0x5e>
      break;
    buf[i++] = c;
 158:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15b:	8d 50 01             	lea    0x1(%eax),%edx
 15e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 161:	89 c2                	mov    %eax,%edx
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	01 c2                	add    %eax,%edx
 168:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 16e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 172:	3c 0a                	cmp    $0xa,%al
 174:	74 16                	je     18c <gets+0x5f>
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0d                	cmp    $0xd,%al
 17c:	74 0e                	je     18c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 181:	83 c0 01             	add    $0x1,%eax
 184:	3b 45 0c             	cmp    0xc(%ebp),%eax
 187:	7c b3                	jl     13c <gets+0xf>
 189:	eb 01                	jmp    18c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 18b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 18c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	01 d0                	add    %edx,%eax
 194:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19a:	c9                   	leave  
 19b:	c3                   	ret    

0000019c <stat>:

int
stat(char *n, struct stat *st)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a2:	83 ec 08             	sub    $0x8,%esp
 1a5:	6a 00                	push   $0x0
 1a7:	ff 75 08             	pushl  0x8(%ebp)
 1aa:	e8 0c 01 00 00       	call   2bb <open>
 1af:	83 c4 10             	add    $0x10,%esp
 1b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b9:	79 07                	jns    1c2 <stat+0x26>
    return -1;
 1bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c0:	eb 25                	jmp    1e7 <stat+0x4b>
  r = fstat(fd, st);
 1c2:	83 ec 08             	sub    $0x8,%esp
 1c5:	ff 75 0c             	pushl  0xc(%ebp)
 1c8:	ff 75 f4             	pushl  -0xc(%ebp)
 1cb:	e8 03 01 00 00       	call   2d3 <fstat>
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d6:	83 ec 0c             	sub    $0xc,%esp
 1d9:	ff 75 f4             	pushl  -0xc(%ebp)
 1dc:	e8 c2 00 00 00       	call   2a3 <close>
 1e1:	83 c4 10             	add    $0x10,%esp
  return r;
 1e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <atoi>:

int
atoi(const char *s)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f6:	eb 25                	jmp    21d <atoi+0x34>
    n = n*10 + *s++ - '0';
 1f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fb:	89 d0                	mov    %edx,%eax
 1fd:	c1 e0 02             	shl    $0x2,%eax
 200:	01 d0                	add    %edx,%eax
 202:	01 c0                	add    %eax,%eax
 204:	89 c1                	mov    %eax,%ecx
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	8d 50 01             	lea    0x1(%eax),%edx
 20c:	89 55 08             	mov    %edx,0x8(%ebp)
 20f:	0f b6 00             	movzbl (%eax),%eax
 212:	0f be c0             	movsbl %al,%eax
 215:	01 c8                	add    %ecx,%eax
 217:	83 e8 30             	sub    $0x30,%eax
 21a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	0f b6 00             	movzbl (%eax),%eax
 223:	3c 2f                	cmp    $0x2f,%al
 225:	7e 0a                	jle    231 <atoi+0x48>
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 00             	movzbl (%eax),%eax
 22d:	3c 39                	cmp    $0x39,%al
 22f:	7e c7                	jle    1f8 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 231:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 242:	8b 45 0c             	mov    0xc(%ebp),%eax
 245:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 248:	eb 17                	jmp    261 <memmove+0x2b>
    *dst++ = *src++;
 24a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 24d:	8d 50 01             	lea    0x1(%eax),%edx
 250:	89 55 fc             	mov    %edx,-0x4(%ebp)
 253:	8b 55 f8             	mov    -0x8(%ebp),%edx
 256:	8d 4a 01             	lea    0x1(%edx),%ecx
 259:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 25c:	0f b6 12             	movzbl (%edx),%edx
 25f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 261:	8b 45 10             	mov    0x10(%ebp),%eax
 264:	8d 50 ff             	lea    -0x1(%eax),%edx
 267:	89 55 10             	mov    %edx,0x10(%ebp)
 26a:	85 c0                	test   %eax,%eax
 26c:	7f dc                	jg     24a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 273:	b8 01 00 00 00       	mov    $0x1,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <exit>:
SYSCALL(exit)
 27b:	b8 02 00 00 00       	mov    $0x2,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <wait>:
SYSCALL(wait)
 283:	b8 03 00 00 00       	mov    $0x3,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <pipe>:
SYSCALL(pipe)
 28b:	b8 04 00 00 00       	mov    $0x4,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <read>:
SYSCALL(read)
 293:	b8 05 00 00 00       	mov    $0x5,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <write>:
SYSCALL(write)
 29b:	b8 10 00 00 00       	mov    $0x10,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <close>:
SYSCALL(close)
 2a3:	b8 15 00 00 00       	mov    $0x15,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <kill>:
SYSCALL(kill)
 2ab:	b8 06 00 00 00       	mov    $0x6,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <exec>:
SYSCALL(exec)
 2b3:	b8 07 00 00 00       	mov    $0x7,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <open>:
SYSCALL(open)
 2bb:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <mknod>:
SYSCALL(mknod)
 2c3:	b8 11 00 00 00       	mov    $0x11,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <unlink>:
SYSCALL(unlink)
 2cb:	b8 12 00 00 00       	mov    $0x12,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <fstat>:
SYSCALL(fstat)
 2d3:	b8 08 00 00 00       	mov    $0x8,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <link>:
SYSCALL(link)
 2db:	b8 13 00 00 00       	mov    $0x13,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <mkdir>:
SYSCALL(mkdir)
 2e3:	b8 14 00 00 00       	mov    $0x14,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <chdir>:
SYSCALL(chdir)
 2eb:	b8 09 00 00 00       	mov    $0x9,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <dup>:
SYSCALL(dup)
 2f3:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <getpid>:
SYSCALL(getpid)
 2fb:	b8 0b 00 00 00       	mov    $0xb,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <sbrk>:
SYSCALL(sbrk)
 303:	b8 0c 00 00 00       	mov    $0xc,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <sleep>:
SYSCALL(sleep)
 30b:	b8 0d 00 00 00       	mov    $0xd,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <uptime>:
SYSCALL(uptime)
 313:	b8 0e 00 00 00       	mov    $0xe,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <halt>:
SYSCALL(halt)
 31b:	b8 16 00 00 00       	mov    $0x16,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <date>:
SYSCALL(date)    #p1
 323:	b8 17 00 00 00       	mov    $0x17,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <getuid>:
SYSCALL(getuid)  #p2
 32b:	b8 18 00 00 00       	mov    $0x18,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getgid>:
SYSCALL(getgid)  #p2
 333:	b8 19 00 00 00       	mov    $0x19,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <getppid>:
SYSCALL(getppid) #p2
 33b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <setuid>:
SYSCALL(setuid)  #p2
 343:	b8 1b 00 00 00       	mov    $0x1b,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <setgid>:
SYSCALL(setgid)  #p2
 34b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 353:	55                   	push   %ebp
 354:	89 e5                	mov    %esp,%ebp
 356:	83 ec 18             	sub    $0x18,%esp
 359:	8b 45 0c             	mov    0xc(%ebp),%eax
 35c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 35f:	83 ec 04             	sub    $0x4,%esp
 362:	6a 01                	push   $0x1
 364:	8d 45 f4             	lea    -0xc(%ebp),%eax
 367:	50                   	push   %eax
 368:	ff 75 08             	pushl  0x8(%ebp)
 36b:	e8 2b ff ff ff       	call   29b <write>
 370:	83 c4 10             	add    $0x10,%esp
}
 373:	90                   	nop
 374:	c9                   	leave  
 375:	c3                   	ret    

00000376 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 376:	55                   	push   %ebp
 377:	89 e5                	mov    %esp,%ebp
 379:	53                   	push   %ebx
 37a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 37d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 384:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 388:	74 17                	je     3a1 <printint+0x2b>
 38a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 38e:	79 11                	jns    3a1 <printint+0x2b>
    neg = 1;
 390:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 397:	8b 45 0c             	mov    0xc(%ebp),%eax
 39a:	f7 d8                	neg    %eax
 39c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 39f:	eb 06                	jmp    3a7 <printint+0x31>
  } else {
    x = xx;
 3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ae:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3b1:	8d 41 01             	lea    0x1(%ecx),%eax
 3b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3bd:	ba 00 00 00 00       	mov    $0x0,%edx
 3c2:	f7 f3                	div    %ebx
 3c4:	89 d0                	mov    %edx,%eax
 3c6:	0f b6 80 38 0a 00 00 	movzbl 0xa38(%eax),%eax
 3cd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d7:	ba 00 00 00 00       	mov    $0x0,%edx
 3dc:	f7 f3                	div    %ebx
 3de:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3e5:	75 c7                	jne    3ae <printint+0x38>
  if(neg)
 3e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3eb:	74 2d                	je     41a <printint+0xa4>
    buf[i++] = '-';
 3ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f0:	8d 50 01             	lea    0x1(%eax),%edx
 3f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3fb:	eb 1d                	jmp    41a <printint+0xa4>
    putc(fd, buf[i]);
 3fd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 400:	8b 45 f4             	mov    -0xc(%ebp),%eax
 403:	01 d0                	add    %edx,%eax
 405:	0f b6 00             	movzbl (%eax),%eax
 408:	0f be c0             	movsbl %al,%eax
 40b:	83 ec 08             	sub    $0x8,%esp
 40e:	50                   	push   %eax
 40f:	ff 75 08             	pushl  0x8(%ebp)
 412:	e8 3c ff ff ff       	call   353 <putc>
 417:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 41a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 41e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 422:	79 d9                	jns    3fd <printint+0x87>
    putc(fd, buf[i]);
}
 424:	90                   	nop
 425:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 428:	c9                   	leave  
 429:	c3                   	ret    

0000042a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 42a:	55                   	push   %ebp
 42b:	89 e5                	mov    %esp,%ebp
 42d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 430:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 437:	8d 45 0c             	lea    0xc(%ebp),%eax
 43a:	83 c0 04             	add    $0x4,%eax
 43d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 447:	e9 59 01 00 00       	jmp    5a5 <printf+0x17b>
    c = fmt[i] & 0xff;
 44c:	8b 55 0c             	mov    0xc(%ebp),%edx
 44f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 452:	01 d0                	add    %edx,%eax
 454:	0f b6 00             	movzbl (%eax),%eax
 457:	0f be c0             	movsbl %al,%eax
 45a:	25 ff 00 00 00       	and    $0xff,%eax
 45f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 462:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 466:	75 2c                	jne    494 <printf+0x6a>
      if(c == '%'){
 468:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 46c:	75 0c                	jne    47a <printf+0x50>
        state = '%';
 46e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 475:	e9 27 01 00 00       	jmp    5a1 <printf+0x177>
      } else {
        putc(fd, c);
 47a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47d:	0f be c0             	movsbl %al,%eax
 480:	83 ec 08             	sub    $0x8,%esp
 483:	50                   	push   %eax
 484:	ff 75 08             	pushl  0x8(%ebp)
 487:	e8 c7 fe ff ff       	call   353 <putc>
 48c:	83 c4 10             	add    $0x10,%esp
 48f:	e9 0d 01 00 00       	jmp    5a1 <printf+0x177>
      }
    } else if(state == '%'){
 494:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 498:	0f 85 03 01 00 00    	jne    5a1 <printf+0x177>
      if(c == 'd'){
 49e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a2:	75 1e                	jne    4c2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a7:	8b 00                	mov    (%eax),%eax
 4a9:	6a 01                	push   $0x1
 4ab:	6a 0a                	push   $0xa
 4ad:	50                   	push   %eax
 4ae:	ff 75 08             	pushl  0x8(%ebp)
 4b1:	e8 c0 fe ff ff       	call   376 <printint>
 4b6:	83 c4 10             	add    $0x10,%esp
        ap++;
 4b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4bd:	e9 d8 00 00 00       	jmp    59a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4c2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c6:	74 06                	je     4ce <printf+0xa4>
 4c8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4cc:	75 1e                	jne    4ec <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d1:	8b 00                	mov    (%eax),%eax
 4d3:	6a 00                	push   $0x0
 4d5:	6a 10                	push   $0x10
 4d7:	50                   	push   %eax
 4d8:	ff 75 08             	pushl  0x8(%ebp)
 4db:	e8 96 fe ff ff       	call   376 <printint>
 4e0:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e7:	e9 ae 00 00 00       	jmp    59a <printf+0x170>
      } else if(c == 's'){
 4ec:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4f0:	75 43                	jne    535 <printf+0x10b>
        s = (char*)*ap;
 4f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f5:	8b 00                	mov    (%eax),%eax
 4f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 502:	75 25                	jne    529 <printf+0xff>
          s = "(null)";
 504:	c7 45 f4 e0 07 00 00 	movl   $0x7e0,-0xc(%ebp)
        while(*s != 0){
 50b:	eb 1c                	jmp    529 <printf+0xff>
          putc(fd, *s);
 50d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 510:	0f b6 00             	movzbl (%eax),%eax
 513:	0f be c0             	movsbl %al,%eax
 516:	83 ec 08             	sub    $0x8,%esp
 519:	50                   	push   %eax
 51a:	ff 75 08             	pushl  0x8(%ebp)
 51d:	e8 31 fe ff ff       	call   353 <putc>
 522:	83 c4 10             	add    $0x10,%esp
          s++;
 525:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 529:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52c:	0f b6 00             	movzbl (%eax),%eax
 52f:	84 c0                	test   %al,%al
 531:	75 da                	jne    50d <printf+0xe3>
 533:	eb 65                	jmp    59a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 535:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 539:	75 1d                	jne    558 <printf+0x12e>
        putc(fd, *ap);
 53b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53e:	8b 00                	mov    (%eax),%eax
 540:	0f be c0             	movsbl %al,%eax
 543:	83 ec 08             	sub    $0x8,%esp
 546:	50                   	push   %eax
 547:	ff 75 08             	pushl  0x8(%ebp)
 54a:	e8 04 fe ff ff       	call   353 <putc>
 54f:	83 c4 10             	add    $0x10,%esp
        ap++;
 552:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 556:	eb 42                	jmp    59a <printf+0x170>
      } else if(c == '%'){
 558:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55c:	75 17                	jne    575 <printf+0x14b>
        putc(fd, c);
 55e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 561:	0f be c0             	movsbl %al,%eax
 564:	83 ec 08             	sub    $0x8,%esp
 567:	50                   	push   %eax
 568:	ff 75 08             	pushl  0x8(%ebp)
 56b:	e8 e3 fd ff ff       	call   353 <putc>
 570:	83 c4 10             	add    $0x10,%esp
 573:	eb 25                	jmp    59a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 575:	83 ec 08             	sub    $0x8,%esp
 578:	6a 25                	push   $0x25
 57a:	ff 75 08             	pushl  0x8(%ebp)
 57d:	e8 d1 fd ff ff       	call   353 <putc>
 582:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 588:	0f be c0             	movsbl %al,%eax
 58b:	83 ec 08             	sub    $0x8,%esp
 58e:	50                   	push   %eax
 58f:	ff 75 08             	pushl  0x8(%ebp)
 592:	e8 bc fd ff ff       	call   353 <putc>
 597:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 59a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5a5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ab:	01 d0                	add    %edx,%eax
 5ad:	0f b6 00             	movzbl (%eax),%eax
 5b0:	84 c0                	test   %al,%al
 5b2:	0f 85 94 fe ff ff    	jne    44c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b8:	90                   	nop
 5b9:	c9                   	leave  
 5ba:	c3                   	ret    

000005bb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5bb:	55                   	push   %ebp
 5bc:	89 e5                	mov    %esp,%ebp
 5be:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	83 e8 08             	sub    $0x8,%eax
 5c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ca:	a1 54 0a 00 00       	mov    0xa54,%eax
 5cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d2:	eb 24                	jmp    5f8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d7:	8b 00                	mov    (%eax),%eax
 5d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5dc:	77 12                	ja     5f0 <free+0x35>
 5de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e4:	77 24                	ja     60a <free+0x4f>
 5e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ee:	77 1a                	ja     60a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f3:	8b 00                	mov    (%eax),%eax
 5f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fe:	76 d4                	jbe    5d4 <free+0x19>
 600:	8b 45 fc             	mov    -0x4(%ebp),%eax
 603:	8b 00                	mov    (%eax),%eax
 605:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 608:	76 ca                	jbe    5d4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 60a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60d:	8b 40 04             	mov    0x4(%eax),%eax
 610:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 617:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61a:	01 c2                	add    %eax,%edx
 61c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	39 c2                	cmp    %eax,%edx
 623:	75 24                	jne    649 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	8b 50 04             	mov    0x4(%eax),%edx
 62b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	8b 40 04             	mov    0x4(%eax),%eax
 633:	01 c2                	add    %eax,%edx
 635:	8b 45 f8             	mov    -0x8(%ebp),%eax
 638:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 63b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	8b 10                	mov    (%eax),%edx
 642:	8b 45 f8             	mov    -0x8(%ebp),%eax
 645:	89 10                	mov    %edx,(%eax)
 647:	eb 0a                	jmp    653 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 10                	mov    (%eax),%edx
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	8b 40 04             	mov    0x4(%eax),%eax
 659:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	01 d0                	add    %edx,%eax
 665:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 668:	75 20                	jne    68a <free+0xcf>
    p->s.size += bp->s.size;
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	8b 40 04             	mov    0x4(%eax),%eax
 676:	01 c2                	add    %eax,%edx
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	8b 10                	mov    (%eax),%edx
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	89 10                	mov    %edx,(%eax)
 688:	eb 08                	jmp    692 <free+0xd7>
  } else
    p->s.ptr = bp;
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 690:	89 10                	mov    %edx,(%eax)
  freep = p;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	a3 54 0a 00 00       	mov    %eax,0xa54
}
 69a:	90                   	nop
 69b:	c9                   	leave  
 69c:	c3                   	ret    

0000069d <morecore>:

static Header*
morecore(uint nu)
{
 69d:	55                   	push   %ebp
 69e:	89 e5                	mov    %esp,%ebp
 6a0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6a3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6aa:	77 07                	ja     6b3 <morecore+0x16>
    nu = 4096;
 6ac:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6b3:	8b 45 08             	mov    0x8(%ebp),%eax
 6b6:	c1 e0 03             	shl    $0x3,%eax
 6b9:	83 ec 0c             	sub    $0xc,%esp
 6bc:	50                   	push   %eax
 6bd:	e8 41 fc ff ff       	call   303 <sbrk>
 6c2:	83 c4 10             	add    $0x10,%esp
 6c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6c8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6cc:	75 07                	jne    6d5 <morecore+0x38>
    return 0;
 6ce:	b8 00 00 00 00       	mov    $0x0,%eax
 6d3:	eb 26                	jmp    6fb <morecore+0x5e>
  hp = (Header*)p;
 6d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6de:	8b 55 08             	mov    0x8(%ebp),%edx
 6e1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e7:	83 c0 08             	add    $0x8,%eax
 6ea:	83 ec 0c             	sub    $0xc,%esp
 6ed:	50                   	push   %eax
 6ee:	e8 c8 fe ff ff       	call   5bb <free>
 6f3:	83 c4 10             	add    $0x10,%esp
  return freep;
 6f6:	a1 54 0a 00 00       	mov    0xa54,%eax
}
 6fb:	c9                   	leave  
 6fc:	c3                   	ret    

000006fd <malloc>:

void*
malloc(uint nbytes)
{
 6fd:	55                   	push   %ebp
 6fe:	89 e5                	mov    %esp,%ebp
 700:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	83 c0 07             	add    $0x7,%eax
 709:	c1 e8 03             	shr    $0x3,%eax
 70c:	83 c0 01             	add    $0x1,%eax
 70f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 712:	a1 54 0a 00 00       	mov    0xa54,%eax
 717:	89 45 f0             	mov    %eax,-0x10(%ebp)
 71a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71e:	75 23                	jne    743 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 720:	c7 45 f0 4c 0a 00 00 	movl   $0xa4c,-0x10(%ebp)
 727:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72a:	a3 54 0a 00 00       	mov    %eax,0xa54
 72f:	a1 54 0a 00 00       	mov    0xa54,%eax
 734:	a3 4c 0a 00 00       	mov    %eax,0xa4c
    base.s.size = 0;
 739:	c7 05 50 0a 00 00 00 	movl   $0x0,0xa50
 740:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 743:	8b 45 f0             	mov    -0x10(%ebp),%eax
 746:	8b 00                	mov    (%eax),%eax
 748:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 74b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74e:	8b 40 04             	mov    0x4(%eax),%eax
 751:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 754:	72 4d                	jb     7a3 <malloc+0xa6>
      if(p->s.size == nunits)
 756:	8b 45 f4             	mov    -0xc(%ebp),%eax
 759:	8b 40 04             	mov    0x4(%eax),%eax
 75c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75f:	75 0c                	jne    76d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 761:	8b 45 f4             	mov    -0xc(%ebp),%eax
 764:	8b 10                	mov    (%eax),%edx
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	89 10                	mov    %edx,(%eax)
 76b:	eb 26                	jmp    793 <malloc+0x96>
      else {
        p->s.size -= nunits;
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	2b 45 ec             	sub    -0x14(%ebp),%eax
 776:	89 c2                	mov    %eax,%edx
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	8b 40 04             	mov    0x4(%eax),%eax
 784:	c1 e0 03             	shl    $0x3,%eax
 787:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 790:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	a3 54 0a 00 00       	mov    %eax,0xa54
      return (void*)(p + 1);
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	83 c0 08             	add    $0x8,%eax
 7a1:	eb 3b                	jmp    7de <malloc+0xe1>
    }
    if(p == freep)
 7a3:	a1 54 0a 00 00       	mov    0xa54,%eax
 7a8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ab:	75 1e                	jne    7cb <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7ad:	83 ec 0c             	sub    $0xc,%esp
 7b0:	ff 75 ec             	pushl  -0x14(%ebp)
 7b3:	e8 e5 fe ff ff       	call   69d <morecore>
 7b8:	83 c4 10             	add    $0x10,%esp
 7bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c2:	75 07                	jne    7cb <malloc+0xce>
        return 0;
 7c4:	b8 00 00 00 00       	mov    $0x0,%eax
 7c9:	eb 13                	jmp    7de <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7d9:	e9 6d ff ff ff       	jmp    74b <malloc+0x4e>
}
 7de:	c9                   	leave  
 7df:	c3                   	ret    
