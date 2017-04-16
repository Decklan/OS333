
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 65 02 00 00       	call   27b <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ef 02 00 00       	call   313 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 57 02 00 00       	call   283 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8d 50 01             	lea    0x1(%eax),%edx
  65:	89 55 08             	mov    %edx,0x8(%ebp)
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	pushl  0xc(%ebp)
  f2:	ff 75 08             	pushl  0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 47 01 00 00       	call   29b <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18f:	7c b3                	jl     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 193:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	pushl  0x8(%ebp)
 1b2:	e8 0c 01 00 00       	call   2c3 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	pushl  0xc(%ebp)
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 03 01 00 00       	call   2db <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	pushl  -0xc(%ebp)
 1e4:	e8 c2 00 00 00       	call   2ab <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fe:	eb 25                	jmp    225 <atoi+0x34>
    n = n*10 + *s++ - '0';
 200:	8b 55 fc             	mov    -0x4(%ebp),%edx
 203:	89 d0                	mov    %edx,%eax
 205:	c1 e0 02             	shl    $0x2,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	01 c0                	add    %eax,%eax
 20c:	89 c1                	mov    %eax,%ecx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8d 50 01             	lea    0x1(%eax),%edx
 214:	89 55 08             	mov    %edx,0x8(%ebp)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	0f be c0             	movsbl %al,%eax
 21d:	01 c8                	add    %ecx,%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 0a                	jle    239 <atoi+0x48>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 39                	cmp    $0x39,%al
 237:	7e c7                	jle    200 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 250:	eb 17                	jmp    269 <memmove+0x2b>
    *dst++ = *src++;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
 255:	8d 50 01             	lea    0x1(%eax),%edx
 258:	89 55 fc             	mov    %edx,-0x4(%ebp)
 25b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25e:	8d 4a 01             	lea    0x1(%edx),%ecx
 261:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 264:	0f b6 12             	movzbl (%edx),%edx
 267:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 269:	8b 45 10             	mov    0x10(%ebp),%eax
 26c:	8d 50 ff             	lea    -0x1(%eax),%edx
 26f:	89 55 10             	mov    %edx,0x10(%ebp)
 272:	85 c0                	test   %eax,%eax
 274:	7f dc                	jg     252 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27b:	b8 01 00 00 00       	mov    $0x1,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <exit>:
SYSCALL(exit)
 283:	b8 02 00 00 00       	mov    $0x2,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <wait>:
SYSCALL(wait)
 28b:	b8 03 00 00 00       	mov    $0x3,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <pipe>:
SYSCALL(pipe)
 293:	b8 04 00 00 00       	mov    $0x4,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <read>:
SYSCALL(read)
 29b:	b8 05 00 00 00       	mov    $0x5,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <write>:
SYSCALL(write)
 2a3:	b8 10 00 00 00       	mov    $0x10,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <close>:
SYSCALL(close)
 2ab:	b8 15 00 00 00       	mov    $0x15,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <kill>:
SYSCALL(kill)
 2b3:	b8 06 00 00 00       	mov    $0x6,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <exec>:
SYSCALL(exec)
 2bb:	b8 07 00 00 00       	mov    $0x7,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <open>:
SYSCALL(open)
 2c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <mknod>:
SYSCALL(mknod)
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <unlink>:
SYSCALL(unlink)
 2d3:	b8 12 00 00 00       	mov    $0x12,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <fstat>:
SYSCALL(fstat)
 2db:	b8 08 00 00 00       	mov    $0x8,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <link>:
SYSCALL(link)
 2e3:	b8 13 00 00 00       	mov    $0x13,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <mkdir>:
SYSCALL(mkdir)
 2eb:	b8 14 00 00 00       	mov    $0x14,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <chdir>:
SYSCALL(chdir)
 2f3:	b8 09 00 00 00       	mov    $0x9,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <dup>:
SYSCALL(dup)
 2fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <getpid>:
SYSCALL(getpid)
 303:	b8 0b 00 00 00       	mov    $0xb,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <sbrk>:
SYSCALL(sbrk)
 30b:	b8 0c 00 00 00       	mov    $0xc,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <sleep>:
SYSCALL(sleep)
 313:	b8 0d 00 00 00       	mov    $0xd,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <uptime>:
SYSCALL(uptime)
 31b:	b8 0e 00 00 00       	mov    $0xe,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <halt>:
SYSCALL(halt)
 323:	b8 16 00 00 00       	mov    $0x16,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <date>:
SYSCALL(date)      #p1
 32b:	b8 17 00 00 00       	mov    $0x17,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getuid>:
SYSCALL(getuid)    #p2
 333:	b8 18 00 00 00       	mov    $0x18,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <getgid>:
SYSCALL(getgid)    #p2
 33b:	b8 19 00 00 00       	mov    $0x19,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <getppid>:
SYSCALL(getppid)   #p2
 343:	b8 1a 00 00 00       	mov    $0x1a,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <setuid>:
SYSCALL(setuid)    #p2
 34b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <setgid>:
SYSCALL(setgid)    #p2
 353:	b8 1c 00 00 00       	mov    $0x1c,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <getprocs>:
SYSCALL(getprocs)  #p2
 35b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 363:	55                   	push   %ebp
 364:	89 e5                	mov    %esp,%ebp
 366:	83 ec 18             	sub    $0x18,%esp
 369:	8b 45 0c             	mov    0xc(%ebp),%eax
 36c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36f:	83 ec 04             	sub    $0x4,%esp
 372:	6a 01                	push   $0x1
 374:	8d 45 f4             	lea    -0xc(%ebp),%eax
 377:	50                   	push   %eax
 378:	ff 75 08             	pushl  0x8(%ebp)
 37b:	e8 23 ff ff ff       	call   2a3 <write>
 380:	83 c4 10             	add    $0x10,%esp
}
 383:	90                   	nop
 384:	c9                   	leave  
 385:	c3                   	ret    

00000386 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp
 389:	53                   	push   %ebx
 38a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 394:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 398:	74 17                	je     3b1 <printint+0x2b>
 39a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39e:	79 11                	jns    3b1 <printint+0x2b>
    neg = 1;
 3a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	f7 d8                	neg    %eax
 3ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3af:	eb 06                	jmp    3b7 <printint+0x31>
  } else {
    x = xx;
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c1:	8d 41 01             	lea    0x1(%ecx),%eax
 3c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cd:	ba 00 00 00 00       	mov    $0x0,%edx
 3d2:	f7 f3                	div    %ebx
 3d4:	89 d0                	mov    %edx,%eax
 3d6:	0f b6 80 40 0a 00 00 	movzbl 0xa40(%eax),%eax
 3dd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e7:	ba 00 00 00 00       	mov    $0x0,%edx
 3ec:	f7 f3                	div    %ebx
 3ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f5:	75 c7                	jne    3be <printint+0x38>
  if(neg)
 3f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3fb:	74 2d                	je     42a <printint+0xa4>
    buf[i++] = '-';
 3fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 400:	8d 50 01             	lea    0x1(%eax),%edx
 403:	89 55 f4             	mov    %edx,-0xc(%ebp)
 406:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 40b:	eb 1d                	jmp    42a <printint+0xa4>
    putc(fd, buf[i]);
 40d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 410:	8b 45 f4             	mov    -0xc(%ebp),%eax
 413:	01 d0                	add    %edx,%eax
 415:	0f b6 00             	movzbl (%eax),%eax
 418:	0f be c0             	movsbl %al,%eax
 41b:	83 ec 08             	sub    $0x8,%esp
 41e:	50                   	push   %eax
 41f:	ff 75 08             	pushl  0x8(%ebp)
 422:	e8 3c ff ff ff       	call   363 <putc>
 427:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 42a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 42e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 432:	79 d9                	jns    40d <printint+0x87>
    putc(fd, buf[i]);
}
 434:	90                   	nop
 435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 438:	c9                   	leave  
 439:	c3                   	ret    

0000043a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 440:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 447:	8d 45 0c             	lea    0xc(%ebp),%eax
 44a:	83 c0 04             	add    $0x4,%eax
 44d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 450:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 457:	e9 59 01 00 00       	jmp    5b5 <printf+0x17b>
    c = fmt[i] & 0xff;
 45c:	8b 55 0c             	mov    0xc(%ebp),%edx
 45f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 462:	01 d0                	add    %edx,%eax
 464:	0f b6 00             	movzbl (%eax),%eax
 467:	0f be c0             	movsbl %al,%eax
 46a:	25 ff 00 00 00       	and    $0xff,%eax
 46f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 472:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 476:	75 2c                	jne    4a4 <printf+0x6a>
      if(c == '%'){
 478:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47c:	75 0c                	jne    48a <printf+0x50>
        state = '%';
 47e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 485:	e9 27 01 00 00       	jmp    5b1 <printf+0x177>
      } else {
        putc(fd, c);
 48a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48d:	0f be c0             	movsbl %al,%eax
 490:	83 ec 08             	sub    $0x8,%esp
 493:	50                   	push   %eax
 494:	ff 75 08             	pushl  0x8(%ebp)
 497:	e8 c7 fe ff ff       	call   363 <putc>
 49c:	83 c4 10             	add    $0x10,%esp
 49f:	e9 0d 01 00 00       	jmp    5b1 <printf+0x177>
      }
    } else if(state == '%'){
 4a4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a8:	0f 85 03 01 00 00    	jne    5b1 <printf+0x177>
      if(c == 'd'){
 4ae:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b2:	75 1e                	jne    4d2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b7:	8b 00                	mov    (%eax),%eax
 4b9:	6a 01                	push   $0x1
 4bb:	6a 0a                	push   $0xa
 4bd:	50                   	push   %eax
 4be:	ff 75 08             	pushl  0x8(%ebp)
 4c1:	e8 c0 fe ff ff       	call   386 <printint>
 4c6:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4cd:	e9 d8 00 00 00       	jmp    5aa <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4d2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d6:	74 06                	je     4de <printf+0xa4>
 4d8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4dc:	75 1e                	jne    4fc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e1:	8b 00                	mov    (%eax),%eax
 4e3:	6a 00                	push   $0x0
 4e5:	6a 10                	push   $0x10
 4e7:	50                   	push   %eax
 4e8:	ff 75 08             	pushl  0x8(%ebp)
 4eb:	e8 96 fe ff ff       	call   386 <printint>
 4f0:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f7:	e9 ae 00 00 00       	jmp    5aa <printf+0x170>
      } else if(c == 's'){
 4fc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 500:	75 43                	jne    545 <printf+0x10b>
        s = (char*)*ap;
 502:	8b 45 e8             	mov    -0x18(%ebp),%eax
 505:	8b 00                	mov    (%eax),%eax
 507:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 50a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 50e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 512:	75 25                	jne    539 <printf+0xff>
          s = "(null)";
 514:	c7 45 f4 f0 07 00 00 	movl   $0x7f0,-0xc(%ebp)
        while(*s != 0){
 51b:	eb 1c                	jmp    539 <printf+0xff>
          putc(fd, *s);
 51d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 520:	0f b6 00             	movzbl (%eax),%eax
 523:	0f be c0             	movsbl %al,%eax
 526:	83 ec 08             	sub    $0x8,%esp
 529:	50                   	push   %eax
 52a:	ff 75 08             	pushl  0x8(%ebp)
 52d:	e8 31 fe ff ff       	call   363 <putc>
 532:	83 c4 10             	add    $0x10,%esp
          s++;
 535:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 539:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53c:	0f b6 00             	movzbl (%eax),%eax
 53f:	84 c0                	test   %al,%al
 541:	75 da                	jne    51d <printf+0xe3>
 543:	eb 65                	jmp    5aa <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 545:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 549:	75 1d                	jne    568 <printf+0x12e>
        putc(fd, *ap);
 54b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54e:	8b 00                	mov    (%eax),%eax
 550:	0f be c0             	movsbl %al,%eax
 553:	83 ec 08             	sub    $0x8,%esp
 556:	50                   	push   %eax
 557:	ff 75 08             	pushl  0x8(%ebp)
 55a:	e8 04 fe ff ff       	call   363 <putc>
 55f:	83 c4 10             	add    $0x10,%esp
        ap++;
 562:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 566:	eb 42                	jmp    5aa <printf+0x170>
      } else if(c == '%'){
 568:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56c:	75 17                	jne    585 <printf+0x14b>
        putc(fd, c);
 56e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 571:	0f be c0             	movsbl %al,%eax
 574:	83 ec 08             	sub    $0x8,%esp
 577:	50                   	push   %eax
 578:	ff 75 08             	pushl  0x8(%ebp)
 57b:	e8 e3 fd ff ff       	call   363 <putc>
 580:	83 c4 10             	add    $0x10,%esp
 583:	eb 25                	jmp    5aa <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 585:	83 ec 08             	sub    $0x8,%esp
 588:	6a 25                	push   $0x25
 58a:	ff 75 08             	pushl  0x8(%ebp)
 58d:	e8 d1 fd ff ff       	call   363 <putc>
 592:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	83 ec 08             	sub    $0x8,%esp
 59e:	50                   	push   %eax
 59f:	ff 75 08             	pushl  0x8(%ebp)
 5a2:	e8 bc fd ff ff       	call   363 <putc>
 5a7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5bb:	01 d0                	add    %edx,%eax
 5bd:	0f b6 00             	movzbl (%eax),%eax
 5c0:	84 c0                	test   %al,%al
 5c2:	0f 85 94 fe ff ff    	jne    45c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c8:	90                   	nop
 5c9:	c9                   	leave  
 5ca:	c3                   	ret    

000005cb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5cb:	55                   	push   %ebp
 5cc:	89 e5                	mov    %esp,%ebp
 5ce:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	83 e8 08             	sub    $0x8,%eax
 5d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5da:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 5df:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e2:	eb 24                	jmp    608 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e7:	8b 00                	mov    (%eax),%eax
 5e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ec:	77 12                	ja     600 <free+0x35>
 5ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f4:	77 24                	ja     61a <free+0x4f>
 5f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5fe:	77 1a                	ja     61a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 600:	8b 45 fc             	mov    -0x4(%ebp),%eax
 603:	8b 00                	mov    (%eax),%eax
 605:	89 45 fc             	mov    %eax,-0x4(%ebp)
 608:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60e:	76 d4                	jbe    5e4 <free+0x19>
 610:	8b 45 fc             	mov    -0x4(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 618:	76 ca                	jbe    5e4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 61a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61d:	8b 40 04             	mov    0x4(%eax),%eax
 620:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	01 c2                	add    %eax,%edx
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	39 c2                	cmp    %eax,%edx
 633:	75 24                	jne    659 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 635:	8b 45 f8             	mov    -0x8(%ebp),%eax
 638:	8b 50 04             	mov    0x4(%eax),%edx
 63b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	8b 40 04             	mov    0x4(%eax),%eax
 643:	01 c2                	add    %eax,%edx
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 64b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	8b 10                	mov    (%eax),%edx
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	89 10                	mov    %edx,(%eax)
 657:	eb 0a                	jmp    663 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 10                	mov    (%eax),%edx
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 40 04             	mov    0x4(%eax),%eax
 669:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	01 d0                	add    %edx,%eax
 675:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 678:	75 20                	jne    69a <free+0xcf>
    p->s.size += bp->s.size;
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 50 04             	mov    0x4(%eax),%edx
 680:	8b 45 f8             	mov    -0x8(%ebp),%eax
 683:	8b 40 04             	mov    0x4(%eax),%eax
 686:	01 c2                	add    %eax,%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	8b 10                	mov    (%eax),%edx
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	89 10                	mov    %edx,(%eax)
 698:	eb 08                	jmp    6a2 <free+0xd7>
  } else
    p->s.ptr = bp;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a0:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	a3 5c 0a 00 00       	mov    %eax,0xa5c
}
 6aa:	90                   	nop
 6ab:	c9                   	leave  
 6ac:	c3                   	ret    

000006ad <morecore>:

static Header*
morecore(uint nu)
{
 6ad:	55                   	push   %ebp
 6ae:	89 e5                	mov    %esp,%ebp
 6b0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ba:	77 07                	ja     6c3 <morecore+0x16>
    nu = 4096;
 6bc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c3:	8b 45 08             	mov    0x8(%ebp),%eax
 6c6:	c1 e0 03             	shl    $0x3,%eax
 6c9:	83 ec 0c             	sub    $0xc,%esp
 6cc:	50                   	push   %eax
 6cd:	e8 39 fc ff ff       	call   30b <sbrk>
 6d2:	83 c4 10             	add    $0x10,%esp
 6d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6d8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6dc:	75 07                	jne    6e5 <morecore+0x38>
    return 0;
 6de:	b8 00 00 00 00       	mov    $0x0,%eax
 6e3:	eb 26                	jmp    70b <morecore+0x5e>
  hp = (Header*)p;
 6e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ee:	8b 55 08             	mov    0x8(%ebp),%edx
 6f1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f7:	83 c0 08             	add    $0x8,%eax
 6fa:	83 ec 0c             	sub    $0xc,%esp
 6fd:	50                   	push   %eax
 6fe:	e8 c8 fe ff ff       	call   5cb <free>
 703:	83 c4 10             	add    $0x10,%esp
  return freep;
 706:	a1 5c 0a 00 00       	mov    0xa5c,%eax
}
 70b:	c9                   	leave  
 70c:	c3                   	ret    

0000070d <malloc>:

void*
malloc(uint nbytes)
{
 70d:	55                   	push   %ebp
 70e:	89 e5                	mov    %esp,%ebp
 710:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 713:	8b 45 08             	mov    0x8(%ebp),%eax
 716:	83 c0 07             	add    $0x7,%eax
 719:	c1 e8 03             	shr    $0x3,%eax
 71c:	83 c0 01             	add    $0x1,%eax
 71f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 722:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 727:	89 45 f0             	mov    %eax,-0x10(%ebp)
 72a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 72e:	75 23                	jne    753 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 730:	c7 45 f0 54 0a 00 00 	movl   $0xa54,-0x10(%ebp)
 737:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73a:	a3 5c 0a 00 00       	mov    %eax,0xa5c
 73f:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 744:	a3 54 0a 00 00       	mov    %eax,0xa54
    base.s.size = 0;
 749:	c7 05 58 0a 00 00 00 	movl   $0x0,0xa58
 750:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
 756:	8b 00                	mov    (%eax),%eax
 758:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75e:	8b 40 04             	mov    0x4(%eax),%eax
 761:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 764:	72 4d                	jb     7b3 <malloc+0xa6>
      if(p->s.size == nunits)
 766:	8b 45 f4             	mov    -0xc(%ebp),%eax
 769:	8b 40 04             	mov    0x4(%eax),%eax
 76c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76f:	75 0c                	jne    77d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 771:	8b 45 f4             	mov    -0xc(%ebp),%eax
 774:	8b 10                	mov    (%eax),%edx
 776:	8b 45 f0             	mov    -0x10(%ebp),%eax
 779:	89 10                	mov    %edx,(%eax)
 77b:	eb 26                	jmp    7a3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	8b 40 04             	mov    0x4(%eax),%eax
 783:	2b 45 ec             	sub    -0x14(%ebp),%eax
 786:	89 c2                	mov    %eax,%edx
 788:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	8b 40 04             	mov    0x4(%eax),%eax
 794:	c1 e0 03             	shl    $0x3,%eax
 797:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a6:	a3 5c 0a 00 00       	mov    %eax,0xa5c
      return (void*)(p + 1);
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	83 c0 08             	add    $0x8,%eax
 7b1:	eb 3b                	jmp    7ee <malloc+0xe1>
    }
    if(p == freep)
 7b3:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 7b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7bb:	75 1e                	jne    7db <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7bd:	83 ec 0c             	sub    $0xc,%esp
 7c0:	ff 75 ec             	pushl  -0x14(%ebp)
 7c3:	e8 e5 fe ff ff       	call   6ad <morecore>
 7c8:	83 c4 10             	add    $0x10,%esp
 7cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d2:	75 07                	jne    7db <malloc+0xce>
        return 0;
 7d4:	b8 00 00 00 00       	mov    $0x0,%eax
 7d9:	eb 13                	jmp    7ee <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 00                	mov    (%eax),%eax
 7e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7e9:	e9 6d ff ff ff       	jmp    75b <malloc+0x4e>
}
 7ee:	c9                   	leave  
 7ef:	c3                   	ret    
