
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
  19:	68 30 08 00 00       	push   $0x830
  1e:	6a 02                	push   $0x2
  20:	e8 55 04 00 00       	call   47a <printf>
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
  60:	68 43 08 00 00       	push   $0x843
  65:	6a 02                	push   $0x2
  67:	e8 0e 04 00 00       	call   47a <printf>
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
SYSCALL(date)    #p1
 373:	b8 17 00 00 00       	mov    $0x17,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <getuid>:
SYSCALL(getuid)  #p2
 37b:	b8 18 00 00 00       	mov    $0x18,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <getgid>:
SYSCALL(getgid)  #p2
 383:	b8 19 00 00 00       	mov    $0x19,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <getppid>:
SYSCALL(getppid) #p2
 38b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <setuid>:
SYSCALL(setuid)  #p2
 393:	b8 1b 00 00 00       	mov    $0x1b,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <setgid>:
SYSCALL(setgid)  #p2
 39b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a3:	55                   	push   %ebp
 3a4:	89 e5                	mov    %esp,%ebp
 3a6:	83 ec 18             	sub    $0x18,%esp
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3af:	83 ec 04             	sub    $0x4,%esp
 3b2:	6a 01                	push   $0x1
 3b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b7:	50                   	push   %eax
 3b8:	ff 75 08             	pushl  0x8(%ebp)
 3bb:	e8 2b ff ff ff       	call   2eb <write>
 3c0:	83 c4 10             	add    $0x10,%esp
}
 3c3:	90                   	nop
 3c4:	c9                   	leave  
 3c5:	c3                   	ret    

000003c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c6:	55                   	push   %ebp
 3c7:	89 e5                	mov    %esp,%ebp
 3c9:	53                   	push   %ebx
 3ca:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d8:	74 17                	je     3f1 <printint+0x2b>
 3da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3de:	79 11                	jns    3f1 <printint+0x2b>
    neg = 1;
 3e0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ea:	f7 d8                	neg    %eax
 3ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ef:	eb 06                	jmp    3f7 <printint+0x31>
  } else {
    x = xx;
 3f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3fe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 401:	8d 41 01             	lea    0x1(%ecx),%eax
 404:	89 45 f4             	mov    %eax,-0xc(%ebp)
 407:	8b 5d 10             	mov    0x10(%ebp),%ebx
 40a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40d:	ba 00 00 00 00       	mov    $0x0,%edx
 412:	f7 f3                	div    %ebx
 414:	89 d0                	mov    %edx,%eax
 416:	0f b6 80 ac 0a 00 00 	movzbl 0xaac(%eax),%eax
 41d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 421:	8b 5d 10             	mov    0x10(%ebp),%ebx
 424:	8b 45 ec             	mov    -0x14(%ebp),%eax
 427:	ba 00 00 00 00       	mov    $0x0,%edx
 42c:	f7 f3                	div    %ebx
 42e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 431:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 435:	75 c7                	jne    3fe <printint+0x38>
  if(neg)
 437:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43b:	74 2d                	je     46a <printint+0xa4>
    buf[i++] = '-';
 43d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 440:	8d 50 01             	lea    0x1(%eax),%edx
 443:	89 55 f4             	mov    %edx,-0xc(%ebp)
 446:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 44b:	eb 1d                	jmp    46a <printint+0xa4>
    putc(fd, buf[i]);
 44d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 450:	8b 45 f4             	mov    -0xc(%ebp),%eax
 453:	01 d0                	add    %edx,%eax
 455:	0f b6 00             	movzbl (%eax),%eax
 458:	0f be c0             	movsbl %al,%eax
 45b:	83 ec 08             	sub    $0x8,%esp
 45e:	50                   	push   %eax
 45f:	ff 75 08             	pushl  0x8(%ebp)
 462:	e8 3c ff ff ff       	call   3a3 <putc>
 467:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 46a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 46e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 472:	79 d9                	jns    44d <printint+0x87>
    putc(fd, buf[i]);
}
 474:	90                   	nop
 475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 478:	c9                   	leave  
 479:	c3                   	ret    

0000047a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 47a:	55                   	push   %ebp
 47b:	89 e5                	mov    %esp,%ebp
 47d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 480:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 487:	8d 45 0c             	lea    0xc(%ebp),%eax
 48a:	83 c0 04             	add    $0x4,%eax
 48d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 490:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 497:	e9 59 01 00 00       	jmp    5f5 <printf+0x17b>
    c = fmt[i] & 0xff;
 49c:	8b 55 0c             	mov    0xc(%ebp),%edx
 49f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a2:	01 d0                	add    %edx,%eax
 4a4:	0f b6 00             	movzbl (%eax),%eax
 4a7:	0f be c0             	movsbl %al,%eax
 4aa:	25 ff 00 00 00       	and    $0xff,%eax
 4af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b6:	75 2c                	jne    4e4 <printf+0x6a>
      if(c == '%'){
 4b8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4bc:	75 0c                	jne    4ca <printf+0x50>
        state = '%';
 4be:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c5:	e9 27 01 00 00       	jmp    5f1 <printf+0x177>
      } else {
        putc(fd, c);
 4ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4cd:	0f be c0             	movsbl %al,%eax
 4d0:	83 ec 08             	sub    $0x8,%esp
 4d3:	50                   	push   %eax
 4d4:	ff 75 08             	pushl  0x8(%ebp)
 4d7:	e8 c7 fe ff ff       	call   3a3 <putc>
 4dc:	83 c4 10             	add    $0x10,%esp
 4df:	e9 0d 01 00 00       	jmp    5f1 <printf+0x177>
      }
    } else if(state == '%'){
 4e4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e8:	0f 85 03 01 00 00    	jne    5f1 <printf+0x177>
      if(c == 'd'){
 4ee:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f2:	75 1e                	jne    512 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f7:	8b 00                	mov    (%eax),%eax
 4f9:	6a 01                	push   $0x1
 4fb:	6a 0a                	push   $0xa
 4fd:	50                   	push   %eax
 4fe:	ff 75 08             	pushl  0x8(%ebp)
 501:	e8 c0 fe ff ff       	call   3c6 <printint>
 506:	83 c4 10             	add    $0x10,%esp
        ap++;
 509:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50d:	e9 d8 00 00 00       	jmp    5ea <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 512:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 516:	74 06                	je     51e <printf+0xa4>
 518:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51c:	75 1e                	jne    53c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 51e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 521:	8b 00                	mov    (%eax),%eax
 523:	6a 00                	push   $0x0
 525:	6a 10                	push   $0x10
 527:	50                   	push   %eax
 528:	ff 75 08             	pushl  0x8(%ebp)
 52b:	e8 96 fe ff ff       	call   3c6 <printint>
 530:	83 c4 10             	add    $0x10,%esp
        ap++;
 533:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 537:	e9 ae 00 00 00       	jmp    5ea <printf+0x170>
      } else if(c == 's'){
 53c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 540:	75 43                	jne    585 <printf+0x10b>
        s = (char*)*ap;
 542:	8b 45 e8             	mov    -0x18(%ebp),%eax
 545:	8b 00                	mov    (%eax),%eax
 547:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 54a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 54e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 552:	75 25                	jne    579 <printf+0xff>
          s = "(null)";
 554:	c7 45 f4 57 08 00 00 	movl   $0x857,-0xc(%ebp)
        while(*s != 0){
 55b:	eb 1c                	jmp    579 <printf+0xff>
          putc(fd, *s);
 55d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 560:	0f b6 00             	movzbl (%eax),%eax
 563:	0f be c0             	movsbl %al,%eax
 566:	83 ec 08             	sub    $0x8,%esp
 569:	50                   	push   %eax
 56a:	ff 75 08             	pushl  0x8(%ebp)
 56d:	e8 31 fe ff ff       	call   3a3 <putc>
 572:	83 c4 10             	add    $0x10,%esp
          s++;
 575:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 579:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57c:	0f b6 00             	movzbl (%eax),%eax
 57f:	84 c0                	test   %al,%al
 581:	75 da                	jne    55d <printf+0xe3>
 583:	eb 65                	jmp    5ea <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 585:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 589:	75 1d                	jne    5a8 <printf+0x12e>
        putc(fd, *ap);
 58b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58e:	8b 00                	mov    (%eax),%eax
 590:	0f be c0             	movsbl %al,%eax
 593:	83 ec 08             	sub    $0x8,%esp
 596:	50                   	push   %eax
 597:	ff 75 08             	pushl  0x8(%ebp)
 59a:	e8 04 fe ff ff       	call   3a3 <putc>
 59f:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a6:	eb 42                	jmp    5ea <printf+0x170>
      } else if(c == '%'){
 5a8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ac:	75 17                	jne    5c5 <printf+0x14b>
        putc(fd, c);
 5ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b1:	0f be c0             	movsbl %al,%eax
 5b4:	83 ec 08             	sub    $0x8,%esp
 5b7:	50                   	push   %eax
 5b8:	ff 75 08             	pushl  0x8(%ebp)
 5bb:	e8 e3 fd ff ff       	call   3a3 <putc>
 5c0:	83 c4 10             	add    $0x10,%esp
 5c3:	eb 25                	jmp    5ea <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c5:	83 ec 08             	sub    $0x8,%esp
 5c8:	6a 25                	push   $0x25
 5ca:	ff 75 08             	pushl  0x8(%ebp)
 5cd:	e8 d1 fd ff ff       	call   3a3 <putc>
 5d2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d8:	0f be c0             	movsbl %al,%eax
 5db:	83 ec 08             	sub    $0x8,%esp
 5de:	50                   	push   %eax
 5df:	ff 75 08             	pushl  0x8(%ebp)
 5e2:	e8 bc fd ff ff       	call   3a3 <putc>
 5e7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5fb:	01 d0                	add    %edx,%eax
 5fd:	0f b6 00             	movzbl (%eax),%eax
 600:	84 c0                	test   %al,%al
 602:	0f 85 94 fe ff ff    	jne    49c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 608:	90                   	nop
 609:	c9                   	leave  
 60a:	c3                   	ret    

0000060b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60b:	55                   	push   %ebp
 60c:	89 e5                	mov    %esp,%ebp
 60e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 611:	8b 45 08             	mov    0x8(%ebp),%eax
 614:	83 e8 08             	sub    $0x8,%eax
 617:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61a:	a1 c8 0a 00 00       	mov    0xac8,%eax
 61f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 622:	eb 24                	jmp    648 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62c:	77 12                	ja     640 <free+0x35>
 62e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 631:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 634:	77 24                	ja     65a <free+0x4f>
 636:	8b 45 fc             	mov    -0x4(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63e:	77 1a                	ja     65a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	89 45 fc             	mov    %eax,-0x4(%ebp)
 648:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64e:	76 d4                	jbe    624 <free+0x19>
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 658:	76 ca                	jbe    624 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	8b 40 04             	mov    0x4(%eax),%eax
 660:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	01 c2                	add    %eax,%edx
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	39 c2                	cmp    %eax,%edx
 673:	75 24                	jne    699 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	8b 50 04             	mov    0x4(%eax),%edx
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	8b 40 04             	mov    0x4(%eax),%eax
 683:	01 c2                	add    %eax,%edx
 685:	8b 45 f8             	mov    -0x8(%ebp),%eax
 688:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	8b 00                	mov    (%eax),%eax
 690:	8b 10                	mov    (%eax),%edx
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	89 10                	mov    %edx,(%eax)
 697:	eb 0a                	jmp    6a3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 10                	mov    (%eax),%edx
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	8b 40 04             	mov    0x4(%eax),%eax
 6a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	01 d0                	add    %edx,%eax
 6b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b8:	75 20                	jne    6da <free+0xcf>
    p->s.size += bp->s.size;
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 50 04             	mov    0x4(%eax),%edx
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	8b 40 04             	mov    0x4(%eax),%eax
 6c6:	01 c2                	add    %eax,%edx
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	8b 10                	mov    (%eax),%edx
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	89 10                	mov    %edx,(%eax)
 6d8:	eb 08                	jmp    6e2 <free+0xd7>
  } else
    p->s.ptr = bp;
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e0:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	a3 c8 0a 00 00       	mov    %eax,0xac8
}
 6ea:	90                   	nop
 6eb:	c9                   	leave  
 6ec:	c3                   	ret    

000006ed <morecore>:

static Header*
morecore(uint nu)
{
 6ed:	55                   	push   %ebp
 6ee:	89 e5                	mov    %esp,%ebp
 6f0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6fa:	77 07                	ja     703 <morecore+0x16>
    nu = 4096;
 6fc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	c1 e0 03             	shl    $0x3,%eax
 709:	83 ec 0c             	sub    $0xc,%esp
 70c:	50                   	push   %eax
 70d:	e8 41 fc ff ff       	call   353 <sbrk>
 712:	83 c4 10             	add    $0x10,%esp
 715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 718:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 71c:	75 07                	jne    725 <morecore+0x38>
    return 0;
 71e:	b8 00 00 00 00       	mov    $0x0,%eax
 723:	eb 26                	jmp    74b <morecore+0x5e>
  hp = (Header*)p;
 725:	8b 45 f4             	mov    -0xc(%ebp),%eax
 728:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 72b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72e:	8b 55 08             	mov    0x8(%ebp),%edx
 731:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 734:	8b 45 f0             	mov    -0x10(%ebp),%eax
 737:	83 c0 08             	add    $0x8,%eax
 73a:	83 ec 0c             	sub    $0xc,%esp
 73d:	50                   	push   %eax
 73e:	e8 c8 fe ff ff       	call   60b <free>
 743:	83 c4 10             	add    $0x10,%esp
  return freep;
 746:	a1 c8 0a 00 00       	mov    0xac8,%eax
}
 74b:	c9                   	leave  
 74c:	c3                   	ret    

0000074d <malloc>:

void*
malloc(uint nbytes)
{
 74d:	55                   	push   %ebp
 74e:	89 e5                	mov    %esp,%ebp
 750:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 753:	8b 45 08             	mov    0x8(%ebp),%eax
 756:	83 c0 07             	add    $0x7,%eax
 759:	c1 e8 03             	shr    $0x3,%eax
 75c:	83 c0 01             	add    $0x1,%eax
 75f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 762:	a1 c8 0a 00 00       	mov    0xac8,%eax
 767:	89 45 f0             	mov    %eax,-0x10(%ebp)
 76a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76e:	75 23                	jne    793 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 770:	c7 45 f0 c0 0a 00 00 	movl   $0xac0,-0x10(%ebp)
 777:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77a:	a3 c8 0a 00 00       	mov    %eax,0xac8
 77f:	a1 c8 0a 00 00       	mov    0xac8,%eax
 784:	a3 c0 0a 00 00       	mov    %eax,0xac0
    base.s.size = 0;
 789:	c7 05 c4 0a 00 00 00 	movl   $0x0,0xac4
 790:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a4:	72 4d                	jb     7f3 <malloc+0xa6>
      if(p->s.size == nunits)
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7af:	75 0c                	jne    7bd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	8b 10                	mov    (%eax),%edx
 7b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b9:	89 10                	mov    %edx,(%eax)
 7bb:	eb 26                	jmp    7e3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 40 04             	mov    0x4(%eax),%eax
 7c3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7c6:	89 c2                	mov    %eax,%edx
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	c1 e0 03             	shl    $0x3,%eax
 7d7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e6:	a3 c8 0a 00 00       	mov    %eax,0xac8
      return (void*)(p + 1);
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	83 c0 08             	add    $0x8,%eax
 7f1:	eb 3b                	jmp    82e <malloc+0xe1>
    }
    if(p == freep)
 7f3:	a1 c8 0a 00 00       	mov    0xac8,%eax
 7f8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7fb:	75 1e                	jne    81b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7fd:	83 ec 0c             	sub    $0xc,%esp
 800:	ff 75 ec             	pushl  -0x14(%ebp)
 803:	e8 e5 fe ff ff       	call   6ed <morecore>
 808:	83 c4 10             	add    $0x10,%esp
 80b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 812:	75 07                	jne    81b <malloc+0xce>
        return 0;
 814:	b8 00 00 00 00       	mov    $0x0,%eax
 819:	eb 13                	jmp    82e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 829:	e9 6d ff ff ff       	jmp    79b <malloc+0x4e>
}
 82e:	c9                   	leave  
 82f:	c3                   	ret    
