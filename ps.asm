
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "uproc.h"
#include "user.h"
#define MAX 32

int main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  struct uproc* uproc_table = malloc(MAX*sizeof(struct uproc));
  11:	83 ec 0c             	sub    $0xc,%esp
  14:	68 80 0b 00 00       	push   $0xb80
  19:	e8 3b 07 00 00       	call   759 <malloc>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!uproc_table) 
  24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  28:	75 19                	jne    43 <main+0x43>
  {
    printf(2, "Error. Malloc call failed.");
  2a:	83 ec 08             	sub    $0x8,%esp
  2d:	68 3c 08 00 00       	push   $0x83c
  32:	6a 02                	push   $0x2
  34:	e8 4d 04 00 00       	call   486 <printf>
  39:	83 c4 10             	add    $0x10,%esp
    return -1;
  3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  41:	eb 2d                	jmp    70 <main+0x70>
  }  
  int status = getprocs(MAX, uproc_table);
  43:	83 ec 08             	sub    $0x8,%esp
  46:	ff 75 f4             	pushl  -0xc(%ebp)
  49:	6a 20                	push   $0x20
  4b:	e8 57 03 00 00       	call   3a7 <getprocs>
  50:	83 c4 10             	add    $0x10,%esp
  53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "%d system calls used.\n", status);
  56:	83 ec 04             	sub    $0x4,%esp
  59:	ff 75 f0             	pushl  -0x10(%ebp)
  5c:	68 57 08 00 00       	push   $0x857
  61:	6a 01                	push   $0x1
  63:	e8 1e 04 00 00       	call   486 <printf>
  68:	83 c4 10             	add    $0x10,%esp
  exit();
  6b:	e8 5f 02 00 00       	call   2cf <exit>
}
  70:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  73:	c9                   	leave  
  74:	8d 61 fc             	lea    -0x4(%ecx),%esp
  77:	c3                   	ret    

00000078 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	57                   	push   %edi
  7c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80:	8b 55 10             	mov    0x10(%ebp),%edx
  83:	8b 45 0c             	mov    0xc(%ebp),%eax
  86:	89 cb                	mov    %ecx,%ebx
  88:	89 df                	mov    %ebx,%edi
  8a:	89 d1                	mov    %edx,%ecx
  8c:	fc                   	cld    
  8d:	f3 aa                	rep stos %al,%es:(%edi)
  8f:	89 ca                	mov    %ecx,%edx
  91:	89 fb                	mov    %edi,%ebx
  93:	89 5d 08             	mov    %ebx,0x8(%ebp)
  96:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  99:	90                   	nop
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  aa:	90                   	nop
  ab:	8b 45 08             	mov    0x8(%ebp),%eax
  ae:	8d 50 01             	lea    0x1(%eax),%edx
  b1:	89 55 08             	mov    %edx,0x8(%ebp)
  b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  bd:	0f b6 12             	movzbl (%edx),%edx
  c0:	88 10                	mov    %dl,(%eax)
  c2:	0f b6 00             	movzbl (%eax),%eax
  c5:	84 c0                	test   %al,%al
  c7:	75 e2                	jne    ab <strcpy+0xd>
    ;
  return os;
  c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d1:	eb 08                	jmp    db <strcmp+0xd>
    p++, q++;
  d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	0f b6 00             	movzbl (%eax),%eax
  e1:	84 c0                	test   %al,%al
  e3:	74 10                	je     f5 <strcmp+0x27>
  e5:	8b 45 08             	mov    0x8(%ebp),%eax
  e8:	0f b6 10             	movzbl (%eax),%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	38 c2                	cmp    %al,%dl
  f3:	74 de                	je     d3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	0f b6 d0             	movzbl %al,%edx
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	0f b6 00             	movzbl (%eax),%eax
 104:	0f b6 c0             	movzbl %al,%eax
 107:	29 c2                	sub    %eax,%edx
 109:	89 d0                	mov    %edx,%eax
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    

0000010d <strlen>:

uint
strlen(char *s)
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 113:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 11a:	eb 04                	jmp    120 <strlen+0x13>
 11c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 120:	8b 55 fc             	mov    -0x4(%ebp),%edx
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	01 d0                	add    %edx,%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	84 c0                	test   %al,%al
 12d:	75 ed                	jne    11c <strlen+0xf>
    ;
  return n;
 12f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <memset>:

void*
memset(void *dst, int c, uint n)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 137:	8b 45 10             	mov    0x10(%ebp),%eax
 13a:	50                   	push   %eax
 13b:	ff 75 0c             	pushl  0xc(%ebp)
 13e:	ff 75 08             	pushl  0x8(%ebp)
 141:	e8 32 ff ff ff       	call   78 <stosb>
 146:	83 c4 0c             	add    $0xc,%esp
  return dst;
 149:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14c:	c9                   	leave  
 14d:	c3                   	ret    

0000014e <strchr>:

char*
strchr(const char *s, char c)
{
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
 151:	83 ec 04             	sub    $0x4,%esp
 154:	8b 45 0c             	mov    0xc(%ebp),%eax
 157:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15a:	eb 14                	jmp    170 <strchr+0x22>
    if(*s == c)
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	3a 45 fc             	cmp    -0x4(%ebp),%al
 165:	75 05                	jne    16c <strchr+0x1e>
      return (char*)s;
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	eb 13                	jmp    17f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	0f b6 00             	movzbl (%eax),%eax
 176:	84 c0                	test   %al,%al
 178:	75 e2                	jne    15c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 17a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17f:	c9                   	leave  
 180:	c3                   	ret    

00000181 <gets>:

char*
gets(char *buf, int max)
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
 184:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 187:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18e:	eb 42                	jmp    1d2 <gets+0x51>
    cc = read(0, &c, 1);
 190:	83 ec 04             	sub    $0x4,%esp
 193:	6a 01                	push   $0x1
 195:	8d 45 ef             	lea    -0x11(%ebp),%eax
 198:	50                   	push   %eax
 199:	6a 00                	push   $0x0
 19b:	e8 47 01 00 00       	call   2e7 <read>
 1a0:	83 c4 10             	add    $0x10,%esp
 1a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1aa:	7e 33                	jle    1df <gets+0x5e>
      break;
    buf[i++] = c;
 1ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1af:	8d 50 01             	lea    0x1(%eax),%edx
 1b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b5:	89 c2                	mov    %eax,%edx
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	01 c2                	add    %eax,%edx
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c6:	3c 0a                	cmp    $0xa,%al
 1c8:	74 16                	je     1e0 <gets+0x5f>
 1ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ce:	3c 0d                	cmp    $0xd,%al
 1d0:	74 0e                	je     1e0 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d5:	83 c0 01             	add    $0x1,%eax
 1d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1db:	7c b3                	jl     190 <gets+0xf>
 1dd:	eb 01                	jmp    1e0 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1df:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	01 d0                	add    %edx,%eax
 1e8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ee:	c9                   	leave  
 1ef:	c3                   	ret    

000001f0 <stat>:

int
stat(char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f6:	83 ec 08             	sub    $0x8,%esp
 1f9:	6a 00                	push   $0x0
 1fb:	ff 75 08             	pushl  0x8(%ebp)
 1fe:	e8 0c 01 00 00       	call   30f <open>
 203:	83 c4 10             	add    $0x10,%esp
 206:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20d:	79 07                	jns    216 <stat+0x26>
    return -1;
 20f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 214:	eb 25                	jmp    23b <stat+0x4b>
  r = fstat(fd, st);
 216:	83 ec 08             	sub    $0x8,%esp
 219:	ff 75 0c             	pushl  0xc(%ebp)
 21c:	ff 75 f4             	pushl  -0xc(%ebp)
 21f:	e8 03 01 00 00       	call   327 <fstat>
 224:	83 c4 10             	add    $0x10,%esp
 227:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22a:	83 ec 0c             	sub    $0xc,%esp
 22d:	ff 75 f4             	pushl  -0xc(%ebp)
 230:	e8 c2 00 00 00       	call   2f7 <close>
 235:	83 c4 10             	add    $0x10,%esp
  return r;
 238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <atoi>:

int
atoi(const char *s)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24a:	eb 25                	jmp    271 <atoi+0x34>
    n = n*10 + *s++ - '0';
 24c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24f:	89 d0                	mov    %edx,%eax
 251:	c1 e0 02             	shl    $0x2,%eax
 254:	01 d0                	add    %edx,%eax
 256:	01 c0                	add    %eax,%eax
 258:	89 c1                	mov    %eax,%ecx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 08             	mov    %edx,0x8(%ebp)
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	0f be c0             	movsbl %al,%eax
 269:	01 c8                	add    %ecx,%eax
 26b:	83 e8 30             	sub    $0x30,%eax
 26e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	3c 2f                	cmp    $0x2f,%al
 279:	7e 0a                	jle    285 <atoi+0x48>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	0f b6 00             	movzbl (%eax),%eax
 281:	3c 39                	cmp    $0x39,%al
 283:	7e c7                	jle    24c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 296:	8b 45 0c             	mov    0xc(%ebp),%eax
 299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29c:	eb 17                	jmp    2b5 <memmove+0x2b>
    *dst++ = *src++;
 29e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a1:	8d 50 01             	lea    0x1(%eax),%edx
 2a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2aa:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b0:	0f b6 12             	movzbl (%edx),%edx
 2b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b5:	8b 45 10             	mov    0x10(%ebp),%eax
 2b8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2bb:	89 55 10             	mov    %edx,0x10(%ebp)
 2be:	85 c0                	test   %eax,%eax
 2c0:	7f dc                	jg     29e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c7:	b8 01 00 00 00       	mov    $0x1,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <exit>:
SYSCALL(exit)
 2cf:	b8 02 00 00 00       	mov    $0x2,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <wait>:
SYSCALL(wait)
 2d7:	b8 03 00 00 00       	mov    $0x3,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <pipe>:
SYSCALL(pipe)
 2df:	b8 04 00 00 00       	mov    $0x4,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <read>:
SYSCALL(read)
 2e7:	b8 05 00 00 00       	mov    $0x5,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <write>:
SYSCALL(write)
 2ef:	b8 10 00 00 00       	mov    $0x10,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <close>:
SYSCALL(close)
 2f7:	b8 15 00 00 00       	mov    $0x15,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <kill>:
SYSCALL(kill)
 2ff:	b8 06 00 00 00       	mov    $0x6,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <exec>:
SYSCALL(exec)
 307:	b8 07 00 00 00       	mov    $0x7,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <open>:
SYSCALL(open)
 30f:	b8 0f 00 00 00       	mov    $0xf,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <mknod>:
SYSCALL(mknod)
 317:	b8 11 00 00 00       	mov    $0x11,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <unlink>:
SYSCALL(unlink)
 31f:	b8 12 00 00 00       	mov    $0x12,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <fstat>:
SYSCALL(fstat)
 327:	b8 08 00 00 00       	mov    $0x8,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <link>:
SYSCALL(link)
 32f:	b8 13 00 00 00       	mov    $0x13,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <mkdir>:
SYSCALL(mkdir)
 337:	b8 14 00 00 00       	mov    $0x14,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <chdir>:
SYSCALL(chdir)
 33f:	b8 09 00 00 00       	mov    $0x9,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <dup>:
SYSCALL(dup)
 347:	b8 0a 00 00 00       	mov    $0xa,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <getpid>:
SYSCALL(getpid)
 34f:	b8 0b 00 00 00       	mov    $0xb,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <sbrk>:
SYSCALL(sbrk)
 357:	b8 0c 00 00 00       	mov    $0xc,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <sleep>:
SYSCALL(sleep)
 35f:	b8 0d 00 00 00       	mov    $0xd,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <uptime>:
SYSCALL(uptime)
 367:	b8 0e 00 00 00       	mov    $0xe,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <halt>:
SYSCALL(halt)
 36f:	b8 16 00 00 00       	mov    $0x16,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <date>:
SYSCALL(date)      #p1
 377:	b8 17 00 00 00       	mov    $0x17,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <getuid>:
SYSCALL(getuid)    #p2
 37f:	b8 18 00 00 00       	mov    $0x18,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <getgid>:
SYSCALL(getgid)    #p2
 387:	b8 19 00 00 00       	mov    $0x19,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <getppid>:
SYSCALL(getppid)   #p2
 38f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <setuid>:
SYSCALL(setuid)    #p2
 397:	b8 1b 00 00 00       	mov    $0x1b,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <setgid>:
SYSCALL(setgid)    #p2
 39f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <getprocs>:
SYSCALL(getprocs)  #p2
 3a7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 18             	sub    $0x18,%esp
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3bb:	83 ec 04             	sub    $0x4,%esp
 3be:	6a 01                	push   $0x1
 3c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c3:	50                   	push   %eax
 3c4:	ff 75 08             	pushl  0x8(%ebp)
 3c7:	e8 23 ff ff ff       	call   2ef <write>
 3cc:	83 c4 10             	add    $0x10,%esp
}
 3cf:	90                   	nop
 3d0:	c9                   	leave  
 3d1:	c3                   	ret    

000003d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d2:	55                   	push   %ebp
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	53                   	push   %ebx
 3d6:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e4:	74 17                	je     3fd <printint+0x2b>
 3e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ea:	79 11                	jns    3fd <printint+0x2b>
    neg = 1;
 3ec:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f6:	f7 d8                	neg    %eax
 3f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3fb:	eb 06                	jmp    403 <printint+0x31>
  } else {
    x = xx;
 3fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 400:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 403:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 40a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 40d:	8d 41 01             	lea    0x1(%ecx),%eax
 410:	89 45 f4             	mov    %eax,-0xc(%ebp)
 413:	8b 5d 10             	mov    0x10(%ebp),%ebx
 416:	8b 45 ec             	mov    -0x14(%ebp),%eax
 419:	ba 00 00 00 00       	mov    $0x0,%edx
 41e:	f7 f3                	div    %ebx
 420:	89 d0                	mov    %edx,%eax
 422:	0f b6 80 c8 0a 00 00 	movzbl 0xac8(%eax),%eax
 429:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 42d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 430:	8b 45 ec             	mov    -0x14(%ebp),%eax
 433:	ba 00 00 00 00       	mov    $0x0,%edx
 438:	f7 f3                	div    %ebx
 43a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 441:	75 c7                	jne    40a <printint+0x38>
  if(neg)
 443:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 447:	74 2d                	je     476 <printint+0xa4>
    buf[i++] = '-';
 449:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44c:	8d 50 01             	lea    0x1(%eax),%edx
 44f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 452:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 457:	eb 1d                	jmp    476 <printint+0xa4>
    putc(fd, buf[i]);
 459:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45f:	01 d0                	add    %edx,%eax
 461:	0f b6 00             	movzbl (%eax),%eax
 464:	0f be c0             	movsbl %al,%eax
 467:	83 ec 08             	sub    $0x8,%esp
 46a:	50                   	push   %eax
 46b:	ff 75 08             	pushl  0x8(%ebp)
 46e:	e8 3c ff ff ff       	call   3af <putc>
 473:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 476:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 47a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47e:	79 d9                	jns    459 <printint+0x87>
    putc(fd, buf[i]);
}
 480:	90                   	nop
 481:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 484:	c9                   	leave  
 485:	c3                   	ret    

00000486 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 486:	55                   	push   %ebp
 487:	89 e5                	mov    %esp,%ebp
 489:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 493:	8d 45 0c             	lea    0xc(%ebp),%eax
 496:	83 c0 04             	add    $0x4,%eax
 499:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a3:	e9 59 01 00 00       	jmp    601 <printf+0x17b>
    c = fmt[i] & 0xff;
 4a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ae:	01 d0                	add    %edx,%eax
 4b0:	0f b6 00             	movzbl (%eax),%eax
 4b3:	0f be c0             	movsbl %al,%eax
 4b6:	25 ff 00 00 00       	and    $0xff,%eax
 4bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c2:	75 2c                	jne    4f0 <printf+0x6a>
      if(c == '%'){
 4c4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c8:	75 0c                	jne    4d6 <printf+0x50>
        state = '%';
 4ca:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d1:	e9 27 01 00 00       	jmp    5fd <printf+0x177>
      } else {
        putc(fd, c);
 4d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d9:	0f be c0             	movsbl %al,%eax
 4dc:	83 ec 08             	sub    $0x8,%esp
 4df:	50                   	push   %eax
 4e0:	ff 75 08             	pushl  0x8(%ebp)
 4e3:	e8 c7 fe ff ff       	call   3af <putc>
 4e8:	83 c4 10             	add    $0x10,%esp
 4eb:	e9 0d 01 00 00       	jmp    5fd <printf+0x177>
      }
    } else if(state == '%'){
 4f0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f4:	0f 85 03 01 00 00    	jne    5fd <printf+0x177>
      if(c == 'd'){
 4fa:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4fe:	75 1e                	jne    51e <printf+0x98>
        printint(fd, *ap, 10, 1);
 500:	8b 45 e8             	mov    -0x18(%ebp),%eax
 503:	8b 00                	mov    (%eax),%eax
 505:	6a 01                	push   $0x1
 507:	6a 0a                	push   $0xa
 509:	50                   	push   %eax
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 c0 fe ff ff       	call   3d2 <printint>
 512:	83 c4 10             	add    $0x10,%esp
        ap++;
 515:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 519:	e9 d8 00 00 00       	jmp    5f6 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 51e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 522:	74 06                	je     52a <printf+0xa4>
 524:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 528:	75 1e                	jne    548 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 52a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52d:	8b 00                	mov    (%eax),%eax
 52f:	6a 00                	push   $0x0
 531:	6a 10                	push   $0x10
 533:	50                   	push   %eax
 534:	ff 75 08             	pushl  0x8(%ebp)
 537:	e8 96 fe ff ff       	call   3d2 <printint>
 53c:	83 c4 10             	add    $0x10,%esp
        ap++;
 53f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 543:	e9 ae 00 00 00       	jmp    5f6 <printf+0x170>
      } else if(c == 's'){
 548:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 54c:	75 43                	jne    591 <printf+0x10b>
        s = (char*)*ap;
 54e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 551:	8b 00                	mov    (%eax),%eax
 553:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 556:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 55a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55e:	75 25                	jne    585 <printf+0xff>
          s = "(null)";
 560:	c7 45 f4 6e 08 00 00 	movl   $0x86e,-0xc(%ebp)
        while(*s != 0){
 567:	eb 1c                	jmp    585 <printf+0xff>
          putc(fd, *s);
 569:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56c:	0f b6 00             	movzbl (%eax),%eax
 56f:	0f be c0             	movsbl %al,%eax
 572:	83 ec 08             	sub    $0x8,%esp
 575:	50                   	push   %eax
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 31 fe ff ff       	call   3af <putc>
 57e:	83 c4 10             	add    $0x10,%esp
          s++;
 581:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 585:	8b 45 f4             	mov    -0xc(%ebp),%eax
 588:	0f b6 00             	movzbl (%eax),%eax
 58b:	84 c0                	test   %al,%al
 58d:	75 da                	jne    569 <printf+0xe3>
 58f:	eb 65                	jmp    5f6 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 591:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 595:	75 1d                	jne    5b4 <printf+0x12e>
        putc(fd, *ap);
 597:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59a:	8b 00                	mov    (%eax),%eax
 59c:	0f be c0             	movsbl %al,%eax
 59f:	83 ec 08             	sub    $0x8,%esp
 5a2:	50                   	push   %eax
 5a3:	ff 75 08             	pushl  0x8(%ebp)
 5a6:	e8 04 fe ff ff       	call   3af <putc>
 5ab:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b2:	eb 42                	jmp    5f6 <printf+0x170>
      } else if(c == '%'){
 5b4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b8:	75 17                	jne    5d1 <printf+0x14b>
        putc(fd, c);
 5ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	pushl  0x8(%ebp)
 5c7:	e8 e3 fd ff ff       	call   3af <putc>
 5cc:	83 c4 10             	add    $0x10,%esp
 5cf:	eb 25                	jmp    5f6 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d1:	83 ec 08             	sub    $0x8,%esp
 5d4:	6a 25                	push   $0x25
 5d6:	ff 75 08             	pushl  0x8(%ebp)
 5d9:	e8 d1 fd ff ff       	call   3af <putc>
 5de:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e4:	0f be c0             	movsbl %al,%eax
 5e7:	83 ec 08             	sub    $0x8,%esp
 5ea:	50                   	push   %eax
 5eb:	ff 75 08             	pushl  0x8(%ebp)
 5ee:	e8 bc fd ff ff       	call   3af <putc>
 5f3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5fd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 601:	8b 55 0c             	mov    0xc(%ebp),%edx
 604:	8b 45 f0             	mov    -0x10(%ebp),%eax
 607:	01 d0                	add    %edx,%eax
 609:	0f b6 00             	movzbl (%eax),%eax
 60c:	84 c0                	test   %al,%al
 60e:	0f 85 94 fe ff ff    	jne    4a8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 614:	90                   	nop
 615:	c9                   	leave  
 616:	c3                   	ret    

00000617 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 617:	55                   	push   %ebp
 618:	89 e5                	mov    %esp,%ebp
 61a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61d:	8b 45 08             	mov    0x8(%ebp),%eax
 620:	83 e8 08             	sub    $0x8,%eax
 623:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 626:	a1 e4 0a 00 00       	mov    0xae4,%eax
 62b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62e:	eb 24                	jmp    654 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 638:	77 12                	ja     64c <free+0x35>
 63a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 640:	77 24                	ja     666 <free+0x4f>
 642:	8b 45 fc             	mov    -0x4(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64a:	77 1a                	ja     666 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	89 45 fc             	mov    %eax,-0x4(%ebp)
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65a:	76 d4                	jbe    630 <free+0x19>
 65c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 664:	76 ca                	jbe    630 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	8b 40 04             	mov    0x4(%eax),%eax
 66c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	01 c2                	add    %eax,%edx
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	39 c2                	cmp    %eax,%edx
 67f:	75 24                	jne    6a5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	8b 50 04             	mov    0x4(%eax),%edx
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	8b 00                	mov    (%eax),%eax
 68c:	8b 40 04             	mov    0x4(%eax),%eax
 68f:	01 c2                	add    %eax,%edx
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	8b 10                	mov    (%eax),%edx
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	89 10                	mov    %edx,(%eax)
 6a3:	eb 0a                	jmp    6af <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 10                	mov    (%eax),%edx
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 40 04             	mov    0x4(%eax),%eax
 6b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	01 d0                	add    %edx,%eax
 6c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c4:	75 20                	jne    6e6 <free+0xcf>
    p->s.size += bp->s.size;
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 50 04             	mov    0x4(%eax),%edx
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	8b 40 04             	mov    0x4(%eax),%eax
 6d2:	01 c2                	add    %eax,%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dd:	8b 10                	mov    (%eax),%edx
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	89 10                	mov    %edx,(%eax)
 6e4:	eb 08                	jmp    6ee <free+0xd7>
  } else
    p->s.ptr = bp;
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ec:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	a3 e4 0a 00 00       	mov    %eax,0xae4
}
 6f6:	90                   	nop
 6f7:	c9                   	leave  
 6f8:	c3                   	ret    

000006f9 <morecore>:

static Header*
morecore(uint nu)
{
 6f9:	55                   	push   %ebp
 6fa:	89 e5                	mov    %esp,%ebp
 6fc:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ff:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 706:	77 07                	ja     70f <morecore+0x16>
    nu = 4096;
 708:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	c1 e0 03             	shl    $0x3,%eax
 715:	83 ec 0c             	sub    $0xc,%esp
 718:	50                   	push   %eax
 719:	e8 39 fc ff ff       	call   357 <sbrk>
 71e:	83 c4 10             	add    $0x10,%esp
 721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 724:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 728:	75 07                	jne    731 <morecore+0x38>
    return 0;
 72a:	b8 00 00 00 00       	mov    $0x0,%eax
 72f:	eb 26                	jmp    757 <morecore+0x5e>
  hp = (Header*)p;
 731:	8b 45 f4             	mov    -0xc(%ebp),%eax
 734:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 737:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73a:	8b 55 08             	mov    0x8(%ebp),%edx
 73d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 740:	8b 45 f0             	mov    -0x10(%ebp),%eax
 743:	83 c0 08             	add    $0x8,%eax
 746:	83 ec 0c             	sub    $0xc,%esp
 749:	50                   	push   %eax
 74a:	e8 c8 fe ff ff       	call   617 <free>
 74f:	83 c4 10             	add    $0x10,%esp
  return freep;
 752:	a1 e4 0a 00 00       	mov    0xae4,%eax
}
 757:	c9                   	leave  
 758:	c3                   	ret    

00000759 <malloc>:

void*
malloc(uint nbytes)
{
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
 75c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	83 c0 07             	add    $0x7,%eax
 765:	c1 e8 03             	shr    $0x3,%eax
 768:	83 c0 01             	add    $0x1,%eax
 76b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 76e:	a1 e4 0a 00 00       	mov    0xae4,%eax
 773:	89 45 f0             	mov    %eax,-0x10(%ebp)
 776:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77a:	75 23                	jne    79f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 77c:	c7 45 f0 dc 0a 00 00 	movl   $0xadc,-0x10(%ebp)
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	a3 e4 0a 00 00       	mov    %eax,0xae4
 78b:	a1 e4 0a 00 00       	mov    0xae4,%eax
 790:	a3 dc 0a 00 00       	mov    %eax,0xadc
    base.s.size = 0;
 795:	c7 05 e0 0a 00 00 00 	movl   $0x0,0xae0
 79c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	8b 00                	mov    (%eax),%eax
 7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b0:	72 4d                	jb     7ff <malloc+0xa6>
      if(p->s.size == nunits)
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bb:	75 0c                	jne    7c9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 10                	mov    (%eax),%edx
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c5:	89 10                	mov    %edx,(%eax)
 7c7:	eb 26                	jmp    7ef <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d2:	89 c2                	mov    %eax,%edx
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8b 40 04             	mov    0x4(%eax),%eax
 7e0:	c1 e0 03             	shl    $0x3,%eax
 7e3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ec:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	a3 e4 0a 00 00       	mov    %eax,0xae4
      return (void*)(p + 1);
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	83 c0 08             	add    $0x8,%eax
 7fd:	eb 3b                	jmp    83a <malloc+0xe1>
    }
    if(p == freep)
 7ff:	a1 e4 0a 00 00       	mov    0xae4,%eax
 804:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 807:	75 1e                	jne    827 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 809:	83 ec 0c             	sub    $0xc,%esp
 80c:	ff 75 ec             	pushl  -0x14(%ebp)
 80f:	e8 e5 fe ff ff       	call   6f9 <morecore>
 814:	83 c4 10             	add    $0x10,%esp
 817:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81e:	75 07                	jne    827 <malloc+0xce>
        return 0;
 820:	b8 00 00 00 00       	mov    $0x0,%eax
 825:	eb 13                	jmp    83a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 835:	e9 6d ff ff ff       	jmp    7a7 <malloc+0x4e>
}
 83a:	c9                   	leave  
 83b:	c3                   	ret    
