
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 38 08 00 00       	push   $0x838
  1e:	6a 02                	push   $0x2
  20:	e8 5d 04 00 00       	call   482 <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 9e 02 00 00       	call   2cb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 e4 02 00 00       	call   32b <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 4b 08 00 00       	push   $0x84b
  65:	6a 02                	push   $0x2
  67:	e8 16 04 00 00       	call   482 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 57 02 00 00       	call   2cb <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	8d 50 01             	lea    0x1(%eax),%edx
  ad:	89 55 08             	mov    %edx,0x8(%ebp)
  b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	pushl  0xc(%ebp)
 13a:	ff 75 08             	pushl  0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 47 01 00 00       	call   2e3 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d7:	7c b3                	jl     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1db:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	pushl  0x8(%ebp)
 1fa:	e8 0c 01 00 00       	call   30b <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 03 01 00 00       	call   323 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	pushl  -0xc(%ebp)
 22c:	e8 c2 00 00 00       	call   2f3 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x34>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x48>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 17                	jmp    2b1 <memmove+0x2b>
    *dst++ = *src++;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29d:	8d 50 01             	lea    0x1(%eax),%edx
 2a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a6:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2ac:	0f b6 12             	movzbl (%edx),%edx
 2af:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b1:	8b 45 10             	mov    0x10(%ebp),%eax
 2b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7f dc                	jg     29a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c3:	b8 01 00 00 00       	mov    $0x1,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <exit>:
SYSCALL(exit)
 2cb:	b8 02 00 00 00       	mov    $0x2,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <wait>:
SYSCALL(wait)
 2d3:	b8 03 00 00 00       	mov    $0x3,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <pipe>:
SYSCALL(pipe)
 2db:	b8 04 00 00 00       	mov    $0x4,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <read>:
SYSCALL(read)
 2e3:	b8 05 00 00 00       	mov    $0x5,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <write>:
SYSCALL(write)
 2eb:	b8 10 00 00 00       	mov    $0x10,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <close>:
SYSCALL(close)
 2f3:	b8 15 00 00 00       	mov    $0x15,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <kill>:
SYSCALL(kill)
 2fb:	b8 06 00 00 00       	mov    $0x6,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <exec>:
SYSCALL(exec)
 303:	b8 07 00 00 00       	mov    $0x7,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <open>:
SYSCALL(open)
 30b:	b8 0f 00 00 00       	mov    $0xf,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <mknod>:
SYSCALL(mknod)
 313:	b8 11 00 00 00       	mov    $0x11,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <unlink>:
SYSCALL(unlink)
 31b:	b8 12 00 00 00       	mov    $0x12,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <fstat>:
SYSCALL(fstat)
 323:	b8 08 00 00 00       	mov    $0x8,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <link>:
SYSCALL(link)
 32b:	b8 13 00 00 00       	mov    $0x13,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <mkdir>:
SYSCALL(mkdir)
 333:	b8 14 00 00 00       	mov    $0x14,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <chdir>:
SYSCALL(chdir)
 33b:	b8 09 00 00 00       	mov    $0x9,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <dup>:
SYSCALL(dup)
 343:	b8 0a 00 00 00       	mov    $0xa,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <getpid>:
SYSCALL(getpid)
 34b:	b8 0b 00 00 00       	mov    $0xb,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <sbrk>:
SYSCALL(sbrk)
 353:	b8 0c 00 00 00       	mov    $0xc,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sleep>:
SYSCALL(sleep)
 35b:	b8 0d 00 00 00       	mov    $0xd,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <uptime>:
SYSCALL(uptime)
 363:	b8 0e 00 00 00       	mov    $0xe,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <halt>:
SYSCALL(halt)
 36b:	b8 16 00 00 00       	mov    $0x16,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <date>:
SYSCALL(date)      #p1
 373:	b8 17 00 00 00       	mov    $0x17,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <getuid>:
SYSCALL(getuid)    #p2
 37b:	b8 18 00 00 00       	mov    $0x18,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <getgid>:
SYSCALL(getgid)    #p2
 383:	b8 19 00 00 00       	mov    $0x19,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <getppid>:
SYSCALL(getppid)   #p2
 38b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <setuid>:
SYSCALL(setuid)    #p2
 393:	b8 1b 00 00 00       	mov    $0x1b,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <setgid>:
SYSCALL(setgid)    #p2
 39b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <getprocs>:
SYSCALL(getprocs)  #p2
 3a3:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ab:	55                   	push   %ebp
 3ac:	89 e5                	mov    %esp,%ebp
 3ae:	83 ec 18             	sub    $0x18,%esp
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b7:	83 ec 04             	sub    $0x4,%esp
 3ba:	6a 01                	push   $0x1
 3bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3bf:	50                   	push   %eax
 3c0:	ff 75 08             	pushl  0x8(%ebp)
 3c3:	e8 23 ff ff ff       	call   2eb <write>
 3c8:	83 c4 10             	add    $0x10,%esp
}
 3cb:	90                   	nop
 3cc:	c9                   	leave  
 3cd:	c3                   	ret    

000003ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ce:	55                   	push   %ebp
 3cf:	89 e5                	mov    %esp,%ebp
 3d1:	53                   	push   %ebx
 3d2:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3dc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e0:	74 17                	je     3f9 <printint+0x2b>
 3e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e6:	79 11                	jns    3f9 <printint+0x2b>
    neg = 1;
 3e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f2:	f7 d8                	neg    %eax
 3f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f7:	eb 06                	jmp    3ff <printint+0x31>
  } else {
    x = xx;
 3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 406:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 409:	8d 41 01             	lea    0x1(%ecx),%eax
 40c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 40f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 412:	8b 45 ec             	mov    -0x14(%ebp),%eax
 415:	ba 00 00 00 00       	mov    $0x0,%edx
 41a:	f7 f3                	div    %ebx
 41c:	89 d0                	mov    %edx,%eax
 41e:	0f b6 80 b4 0a 00 00 	movzbl 0xab4(%eax),%eax
 425:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 429:	8b 5d 10             	mov    0x10(%ebp),%ebx
 42c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42f:	ba 00 00 00 00       	mov    $0x0,%edx
 434:	f7 f3                	div    %ebx
 436:	89 45 ec             	mov    %eax,-0x14(%ebp)
 439:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43d:	75 c7                	jne    406 <printint+0x38>
  if(neg)
 43f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 443:	74 2d                	je     472 <printint+0xa4>
    buf[i++] = '-';
 445:	8b 45 f4             	mov    -0xc(%ebp),%eax
 448:	8d 50 01             	lea    0x1(%eax),%edx
 44b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 44e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 453:	eb 1d                	jmp    472 <printint+0xa4>
    putc(fd, buf[i]);
 455:	8d 55 dc             	lea    -0x24(%ebp),%edx
 458:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45b:	01 d0                	add    %edx,%eax
 45d:	0f b6 00             	movzbl (%eax),%eax
 460:	0f be c0             	movsbl %al,%eax
 463:	83 ec 08             	sub    $0x8,%esp
 466:	50                   	push   %eax
 467:	ff 75 08             	pushl  0x8(%ebp)
 46a:	e8 3c ff ff ff       	call   3ab <putc>
 46f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 472:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47a:	79 d9                	jns    455 <printint+0x87>
    putc(fd, buf[i]);
}
 47c:	90                   	nop
 47d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 480:	c9                   	leave  
 481:	c3                   	ret    

00000482 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 482:	55                   	push   %ebp
 483:	89 e5                	mov    %esp,%ebp
 485:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 488:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 48f:	8d 45 0c             	lea    0xc(%ebp),%eax
 492:	83 c0 04             	add    $0x4,%eax
 495:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 498:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 49f:	e9 59 01 00 00       	jmp    5fd <printf+0x17b>
    c = fmt[i] & 0xff;
 4a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4aa:	01 d0                	add    %edx,%eax
 4ac:	0f b6 00             	movzbl (%eax),%eax
 4af:	0f be c0             	movsbl %al,%eax
 4b2:	25 ff 00 00 00       	and    $0xff,%eax
 4b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4be:	75 2c                	jne    4ec <printf+0x6a>
      if(c == '%'){
 4c0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c4:	75 0c                	jne    4d2 <printf+0x50>
        state = '%';
 4c6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4cd:	e9 27 01 00 00       	jmp    5f9 <printf+0x177>
      } else {
        putc(fd, c);
 4d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d5:	0f be c0             	movsbl %al,%eax
 4d8:	83 ec 08             	sub    $0x8,%esp
 4db:	50                   	push   %eax
 4dc:	ff 75 08             	pushl  0x8(%ebp)
 4df:	e8 c7 fe ff ff       	call   3ab <putc>
 4e4:	83 c4 10             	add    $0x10,%esp
 4e7:	e9 0d 01 00 00       	jmp    5f9 <printf+0x177>
      }
    } else if(state == '%'){
 4ec:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f0:	0f 85 03 01 00 00    	jne    5f9 <printf+0x177>
      if(c == 'd'){
 4f6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4fa:	75 1e                	jne    51a <printf+0x98>
        printint(fd, *ap, 10, 1);
 4fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ff:	8b 00                	mov    (%eax),%eax
 501:	6a 01                	push   $0x1
 503:	6a 0a                	push   $0xa
 505:	50                   	push   %eax
 506:	ff 75 08             	pushl  0x8(%ebp)
 509:	e8 c0 fe ff ff       	call   3ce <printint>
 50e:	83 c4 10             	add    $0x10,%esp
        ap++;
 511:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 515:	e9 d8 00 00 00       	jmp    5f2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 51a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51e:	74 06                	je     526 <printf+0xa4>
 520:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 524:	75 1e                	jne    544 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 526:	8b 45 e8             	mov    -0x18(%ebp),%eax
 529:	8b 00                	mov    (%eax),%eax
 52b:	6a 00                	push   $0x0
 52d:	6a 10                	push   $0x10
 52f:	50                   	push   %eax
 530:	ff 75 08             	pushl  0x8(%ebp)
 533:	e8 96 fe ff ff       	call   3ce <printint>
 538:	83 c4 10             	add    $0x10,%esp
        ap++;
 53b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53f:	e9 ae 00 00 00       	jmp    5f2 <printf+0x170>
      } else if(c == 's'){
 544:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 548:	75 43                	jne    58d <printf+0x10b>
        s = (char*)*ap;
 54a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54d:	8b 00                	mov    (%eax),%eax
 54f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 552:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55a:	75 25                	jne    581 <printf+0xff>
          s = "(null)";
 55c:	c7 45 f4 5f 08 00 00 	movl   $0x85f,-0xc(%ebp)
        while(*s != 0){
 563:	eb 1c                	jmp    581 <printf+0xff>
          putc(fd, *s);
 565:	8b 45 f4             	mov    -0xc(%ebp),%eax
 568:	0f b6 00             	movzbl (%eax),%eax
 56b:	0f be c0             	movsbl %al,%eax
 56e:	83 ec 08             	sub    $0x8,%esp
 571:	50                   	push   %eax
 572:	ff 75 08             	pushl  0x8(%ebp)
 575:	e8 31 fe ff ff       	call   3ab <putc>
 57a:	83 c4 10             	add    $0x10,%esp
          s++;
 57d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 581:	8b 45 f4             	mov    -0xc(%ebp),%eax
 584:	0f b6 00             	movzbl (%eax),%eax
 587:	84 c0                	test   %al,%al
 589:	75 da                	jne    565 <printf+0xe3>
 58b:	eb 65                	jmp    5f2 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 591:	75 1d                	jne    5b0 <printf+0x12e>
        putc(fd, *ap);
 593:	8b 45 e8             	mov    -0x18(%ebp),%eax
 596:	8b 00                	mov    (%eax),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	83 ec 08             	sub    $0x8,%esp
 59e:	50                   	push   %eax
 59f:	ff 75 08             	pushl  0x8(%ebp)
 5a2:	e8 04 fe ff ff       	call   3ab <putc>
 5a7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ae:	eb 42                	jmp    5f2 <printf+0x170>
      } else if(c == '%'){
 5b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b4:	75 17                	jne    5cd <printf+0x14b>
        putc(fd, c);
 5b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b9:	0f be c0             	movsbl %al,%eax
 5bc:	83 ec 08             	sub    $0x8,%esp
 5bf:	50                   	push   %eax
 5c0:	ff 75 08             	pushl  0x8(%ebp)
 5c3:	e8 e3 fd ff ff       	call   3ab <putc>
 5c8:	83 c4 10             	add    $0x10,%esp
 5cb:	eb 25                	jmp    5f2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cd:	83 ec 08             	sub    $0x8,%esp
 5d0:	6a 25                	push   $0x25
 5d2:	ff 75 08             	pushl  0x8(%ebp)
 5d5:	e8 d1 fd ff ff       	call   3ab <putc>
 5da:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e0:	0f be c0             	movsbl %al,%eax
 5e3:	83 ec 08             	sub    $0x8,%esp
 5e6:	50                   	push   %eax
 5e7:	ff 75 08             	pushl  0x8(%ebp)
 5ea:	e8 bc fd ff ff       	call   3ab <putc>
 5ef:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5fd:	8b 55 0c             	mov    0xc(%ebp),%edx
 600:	8b 45 f0             	mov    -0x10(%ebp),%eax
 603:	01 d0                	add    %edx,%eax
 605:	0f b6 00             	movzbl (%eax),%eax
 608:	84 c0                	test   %al,%al
 60a:	0f 85 94 fe ff ff    	jne    4a4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 610:	90                   	nop
 611:	c9                   	leave  
 612:	c3                   	ret    

00000613 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 613:	55                   	push   %ebp
 614:	89 e5                	mov    %esp,%ebp
 616:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 619:	8b 45 08             	mov    0x8(%ebp),%eax
 61c:	83 e8 08             	sub    $0x8,%eax
 61f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 622:	a1 d0 0a 00 00       	mov    0xad0,%eax
 627:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62a:	eb 24                	jmp    650 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 634:	77 12                	ja     648 <free+0x35>
 636:	8b 45 f8             	mov    -0x8(%ebp),%eax
 639:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63c:	77 24                	ja     662 <free+0x4f>
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 646:	77 1a                	ja     662 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 650:	8b 45 f8             	mov    -0x8(%ebp),%eax
 653:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 656:	76 d4                	jbe    62c <free+0x19>
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 660:	76 ca                	jbe    62c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	8b 40 04             	mov    0x4(%eax),%eax
 668:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	01 c2                	add    %eax,%edx
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	39 c2                	cmp    %eax,%edx
 67b:	75 24                	jne    6a1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	8b 50 04             	mov    0x4(%eax),%edx
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	8b 40 04             	mov    0x4(%eax),%eax
 68b:	01 c2                	add    %eax,%edx
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	8b 10                	mov    (%eax),%edx
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	89 10                	mov    %edx,(%eax)
 69f:	eb 0a                	jmp    6ab <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 10                	mov    (%eax),%edx
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 40 04             	mov    0x4(%eax),%eax
 6b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	01 d0                	add    %edx,%eax
 6bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c0:	75 20                	jne    6e2 <free+0xcf>
    p->s.size += bp->s.size;
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 50 04             	mov    0x4(%eax),%edx
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	8b 40 04             	mov    0x4(%eax),%eax
 6ce:	01 c2                	add    %eax,%edx
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	8b 10                	mov    (%eax),%edx
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	89 10                	mov    %edx,(%eax)
 6e0:	eb 08                	jmp    6ea <free+0xd7>
  } else
    p->s.ptr = bp;
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e8:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	a3 d0 0a 00 00       	mov    %eax,0xad0
}
 6f2:	90                   	nop
 6f3:	c9                   	leave  
 6f4:	c3                   	ret    

000006f5 <morecore>:

static Header*
morecore(uint nu)
{
 6f5:	55                   	push   %ebp
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6fb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 702:	77 07                	ja     70b <morecore+0x16>
    nu = 4096;
 704:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	c1 e0 03             	shl    $0x3,%eax
 711:	83 ec 0c             	sub    $0xc,%esp
 714:	50                   	push   %eax
 715:	e8 39 fc ff ff       	call   353 <sbrk>
 71a:	83 c4 10             	add    $0x10,%esp
 71d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 720:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 724:	75 07                	jne    72d <morecore+0x38>
    return 0;
 726:	b8 00 00 00 00       	mov    $0x0,%eax
 72b:	eb 26                	jmp    753 <morecore+0x5e>
  hp = (Header*)p;
 72d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	8b 55 08             	mov    0x8(%ebp),%edx
 739:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73f:	83 c0 08             	add    $0x8,%eax
 742:	83 ec 0c             	sub    $0xc,%esp
 745:	50                   	push   %eax
 746:	e8 c8 fe ff ff       	call   613 <free>
 74b:	83 c4 10             	add    $0x10,%esp
  return freep;
 74e:	a1 d0 0a 00 00       	mov    0xad0,%eax
}
 753:	c9                   	leave  
 754:	c3                   	ret    

00000755 <malloc>:

void*
malloc(uint nbytes)
{
 755:	55                   	push   %ebp
 756:	89 e5                	mov    %esp,%ebp
 758:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	83 c0 07             	add    $0x7,%eax
 761:	c1 e8 03             	shr    $0x3,%eax
 764:	83 c0 01             	add    $0x1,%eax
 767:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 76a:	a1 d0 0a 00 00       	mov    0xad0,%eax
 76f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 772:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 776:	75 23                	jne    79b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 778:	c7 45 f0 c8 0a 00 00 	movl   $0xac8,-0x10(%ebp)
 77f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 782:	a3 d0 0a 00 00       	mov    %eax,0xad0
 787:	a1 d0 0a 00 00       	mov    0xad0,%eax
 78c:	a3 c8 0a 00 00       	mov    %eax,0xac8
    base.s.size = 0;
 791:	c7 05 cc 0a 00 00 00 	movl   $0x0,0xacc
 798:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79e:	8b 00                	mov    (%eax),%eax
 7a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ac:	72 4d                	jb     7fb <malloc+0xa6>
      if(p->s.size == nunits)
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	8b 40 04             	mov    0x4(%eax),%eax
 7b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b7:	75 0c                	jne    7c5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 10                	mov    (%eax),%edx
 7be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c1:	89 10                	mov    %edx,(%eax)
 7c3:	eb 26                	jmp    7eb <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	8b 40 04             	mov    0x4(%eax),%eax
 7cb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ce:	89 c2                	mov    %eax,%edx
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d9:	8b 40 04             	mov    0x4(%eax),%eax
 7dc:	c1 e0 03             	shl    $0x3,%eax
 7df:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ee:	a3 d0 0a 00 00       	mov    %eax,0xad0
      return (void*)(p + 1);
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	83 c0 08             	add    $0x8,%eax
 7f9:	eb 3b                	jmp    836 <malloc+0xe1>
    }
    if(p == freep)
 7fb:	a1 d0 0a 00 00       	mov    0xad0,%eax
 800:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 803:	75 1e                	jne    823 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 805:	83 ec 0c             	sub    $0xc,%esp
 808:	ff 75 ec             	pushl  -0x14(%ebp)
 80b:	e8 e5 fe ff ff       	call   6f5 <morecore>
 810:	83 c4 10             	add    $0x10,%esp
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
 816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81a:	75 07                	jne    823 <malloc+0xce>
        return 0;
 81c:	b8 00 00 00 00       	mov    $0x0,%eax
 821:	eb 13                	jmp    836 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 45 f0             	mov    %eax,-0x10(%ebp)
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 831:	e9 6d ff ff ff       	jmp    7a3 <malloc+0x4e>
}
 836:	c9                   	leave  
 837:	c3                   	ret    
