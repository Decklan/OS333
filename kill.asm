
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 83 08 00 00       	push   $0x883
  21:	6a 02                	push   $0x2
  23:	e8 a5 04 00 00       	call   4cd <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 de 02 00 00       	call   30e <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 df 02 00 00       	call   33e <kill>
  5f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  6d:	e8 9c 02 00 00       	call   30e <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	8d 50 01             	lea    0x1(%eax),%edx
  ab:	89 55 08             	mov    %edx,0x8(%ebp)
  ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	pushl  0xc(%ebp)
 138:	ff 75 08             	pushl  0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 8c 01 00 00       	call   326 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d5:	7c b3                	jl     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 51 01 00 00       	call   34e <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 48 01 00 00       	call   366 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 07 01 00 00       	call   336 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 244:	eb 04                	jmp    24a <atoi+0x13>
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	3c 20                	cmp    $0x20,%al
 252:	74 f2                	je     246 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	0f b6 00             	movzbl (%eax),%eax
 25a:	3c 2d                	cmp    $0x2d,%al
 25c:	75 07                	jne    265 <atoi+0x2e>
 25e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 263:	eb 05                	jmp    26a <atoi+0x33>
 265:	b8 01 00 00 00       	mov    $0x1,%eax
 26a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2b                	cmp    $0x2b,%al
 275:	74 0a                	je     281 <atoi+0x4a>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 2d                	cmp    $0x2d,%al
 27f:	75 2b                	jne    2ac <atoi+0x75>
    s++;
 281:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 285:	eb 25                	jmp    2ac <atoi+0x75>
    n = n*10 + *s++ - '0';
 287:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28a:	89 d0                	mov    %edx,%eax
 28c:	c1 e0 02             	shl    $0x2,%eax
 28f:	01 d0                	add    %edx,%eax
 291:	01 c0                	add    %eax,%eax
 293:	89 c1                	mov    %eax,%ecx
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	8d 50 01             	lea    0x1(%eax),%edx
 29b:	89 55 08             	mov    %edx,0x8(%ebp)
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	0f be c0             	movsbl %al,%eax
 2a4:	01 c8                	add    %ecx,%eax
 2a6:	83 e8 30             	sub    $0x30,%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	0f b6 00             	movzbl (%eax),%eax
 2b2:	3c 2f                	cmp    $0x2f,%al
 2b4:	7e 0a                	jle    2c0 <atoi+0x89>
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 00             	movzbl (%eax),%eax
 2bc:	3c 39                	cmp    $0x39,%al
 2be:	7e c7                	jle    287 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2c3:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2db:	eb 17                	jmp    2f4 <memmove+0x2b>
    *dst++ = *src++;
 2dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e0:	8d 50 01             	lea    0x1(%eax),%edx
 2e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e9:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ec:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2ef:	0f b6 12             	movzbl (%edx),%edx
 2f2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f4:	8b 45 10             	mov    0x10(%ebp),%eax
 2f7:	8d 50 ff             	lea    -0x1(%eax),%edx
 2fa:	89 55 10             	mov    %edx,0x10(%ebp)
 2fd:	85 c0                	test   %eax,%eax
 2ff:	7f dc                	jg     2dd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 301:	8b 45 08             	mov    0x8(%ebp),%eax
}
 304:	c9                   	leave  
 305:	c3                   	ret    

00000306 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 306:	b8 01 00 00 00       	mov    $0x1,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <exit>:
SYSCALL(exit)
 30e:	b8 02 00 00 00       	mov    $0x2,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <wait>:
SYSCALL(wait)
 316:	b8 03 00 00 00       	mov    $0x3,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <pipe>:
SYSCALL(pipe)
 31e:	b8 04 00 00 00       	mov    $0x4,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <read>:
SYSCALL(read)
 326:	b8 05 00 00 00       	mov    $0x5,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <write>:
SYSCALL(write)
 32e:	b8 10 00 00 00       	mov    $0x10,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <close>:
SYSCALL(close)
 336:	b8 15 00 00 00       	mov    $0x15,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <kill>:
SYSCALL(kill)
 33e:	b8 06 00 00 00       	mov    $0x6,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <exec>:
SYSCALL(exec)
 346:	b8 07 00 00 00       	mov    $0x7,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <open>:
SYSCALL(open)
 34e:	b8 0f 00 00 00       	mov    $0xf,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <mknod>:
SYSCALL(mknod)
 356:	b8 11 00 00 00       	mov    $0x11,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <unlink>:
SYSCALL(unlink)
 35e:	b8 12 00 00 00       	mov    $0x12,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <fstat>:
SYSCALL(fstat)
 366:	b8 08 00 00 00       	mov    $0x8,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <link>:
SYSCALL(link)
 36e:	b8 13 00 00 00       	mov    $0x13,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <mkdir>:
SYSCALL(mkdir)
 376:	b8 14 00 00 00       	mov    $0x14,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <chdir>:
SYSCALL(chdir)
 37e:	b8 09 00 00 00       	mov    $0x9,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <dup>:
SYSCALL(dup)
 386:	b8 0a 00 00 00       	mov    $0xa,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <getpid>:
SYSCALL(getpid)
 38e:	b8 0b 00 00 00       	mov    $0xb,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <sbrk>:
SYSCALL(sbrk)
 396:	b8 0c 00 00 00       	mov    $0xc,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <sleep>:
SYSCALL(sleep)
 39e:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <uptime>:
SYSCALL(uptime)
 3a6:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <halt>:
SYSCALL(halt)
 3ae:	b8 16 00 00 00       	mov    $0x16,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <date>:
SYSCALL(date)      #p1
 3b6:	b8 17 00 00 00       	mov    $0x17,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <getuid>:
SYSCALL(getuid)    #p2
 3be:	b8 18 00 00 00       	mov    $0x18,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <getgid>:
SYSCALL(getgid)    #p2
 3c6:	b8 19 00 00 00       	mov    $0x19,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <getppid>:
SYSCALL(getppid)   #p2
 3ce:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <setuid>:
SYSCALL(setuid)    #p2
 3d6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <setgid>:
SYSCALL(setgid)    #p2
 3de:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <getprocs>:
SYSCALL(getprocs)  #p2
 3e6:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <setpriority>:
SYSCALL(setpriority)
 3ee:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f6:	55                   	push   %ebp
 3f7:	89 e5                	mov    %esp,%ebp
 3f9:	83 ec 18             	sub    $0x18,%esp
 3fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ff:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 402:	83 ec 04             	sub    $0x4,%esp
 405:	6a 01                	push   $0x1
 407:	8d 45 f4             	lea    -0xc(%ebp),%eax
 40a:	50                   	push   %eax
 40b:	ff 75 08             	pushl  0x8(%ebp)
 40e:	e8 1b ff ff ff       	call   32e <write>
 413:	83 c4 10             	add    $0x10,%esp
}
 416:	90                   	nop
 417:	c9                   	leave  
 418:	c3                   	ret    

00000419 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 419:	55                   	push   %ebp
 41a:	89 e5                	mov    %esp,%ebp
 41c:	53                   	push   %ebx
 41d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 420:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 427:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 42b:	74 17                	je     444 <printint+0x2b>
 42d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 431:	79 11                	jns    444 <printint+0x2b>
    neg = 1;
 433:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	f7 d8                	neg    %eax
 43f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 442:	eb 06                	jmp    44a <printint+0x31>
  } else {
    x = xx;
 444:	8b 45 0c             	mov    0xc(%ebp),%eax
 447:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 44a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 451:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 454:	8d 41 01             	lea    0x1(%ecx),%eax
 457:	89 45 f4             	mov    %eax,-0xc(%ebp)
 45a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 45d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 460:	ba 00 00 00 00       	mov    $0x0,%edx
 465:	f7 f3                	div    %ebx
 467:	89 d0                	mov    %edx,%eax
 469:	0f b6 80 ec 0a 00 00 	movzbl 0xaec(%eax),%eax
 470:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 474:	8b 5d 10             	mov    0x10(%ebp),%ebx
 477:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47a:	ba 00 00 00 00       	mov    $0x0,%edx
 47f:	f7 f3                	div    %ebx
 481:	89 45 ec             	mov    %eax,-0x14(%ebp)
 484:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 488:	75 c7                	jne    451 <printint+0x38>
  if(neg)
 48a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48e:	74 2d                	je     4bd <printint+0xa4>
    buf[i++] = '-';
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	8d 50 01             	lea    0x1(%eax),%edx
 496:	89 55 f4             	mov    %edx,-0xc(%ebp)
 499:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 49e:	eb 1d                	jmp    4bd <printint+0xa4>
    putc(fd, buf[i]);
 4a0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a6:	01 d0                	add    %edx,%eax
 4a8:	0f b6 00             	movzbl (%eax),%eax
 4ab:	0f be c0             	movsbl %al,%eax
 4ae:	83 ec 08             	sub    $0x8,%esp
 4b1:	50                   	push   %eax
 4b2:	ff 75 08             	pushl  0x8(%ebp)
 4b5:	e8 3c ff ff ff       	call   3f6 <putc>
 4ba:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4bd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c5:	79 d9                	jns    4a0 <printint+0x87>
    putc(fd, buf[i]);
}
 4c7:	90                   	nop
 4c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4cb:	c9                   	leave  
 4cc:	c3                   	ret    

000004cd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4cd:	55                   	push   %ebp
 4ce:	89 e5                	mov    %esp,%ebp
 4d0:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4da:	8d 45 0c             	lea    0xc(%ebp),%eax
 4dd:	83 c0 04             	add    $0x4,%eax
 4e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ea:	e9 59 01 00 00       	jmp    648 <printf+0x17b>
    c = fmt[i] & 0xff;
 4ef:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4f5:	01 d0                	add    %edx,%eax
 4f7:	0f b6 00             	movzbl (%eax),%eax
 4fa:	0f be c0             	movsbl %al,%eax
 4fd:	25 ff 00 00 00       	and    $0xff,%eax
 502:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 505:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 509:	75 2c                	jne    537 <printf+0x6a>
      if(c == '%'){
 50b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 50f:	75 0c                	jne    51d <printf+0x50>
        state = '%';
 511:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 518:	e9 27 01 00 00       	jmp    644 <printf+0x177>
      } else {
        putc(fd, c);
 51d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 520:	0f be c0             	movsbl %al,%eax
 523:	83 ec 08             	sub    $0x8,%esp
 526:	50                   	push   %eax
 527:	ff 75 08             	pushl  0x8(%ebp)
 52a:	e8 c7 fe ff ff       	call   3f6 <putc>
 52f:	83 c4 10             	add    $0x10,%esp
 532:	e9 0d 01 00 00       	jmp    644 <printf+0x177>
      }
    } else if(state == '%'){
 537:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 53b:	0f 85 03 01 00 00    	jne    644 <printf+0x177>
      if(c == 'd'){
 541:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 545:	75 1e                	jne    565 <printf+0x98>
        printint(fd, *ap, 10, 1);
 547:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54a:	8b 00                	mov    (%eax),%eax
 54c:	6a 01                	push   $0x1
 54e:	6a 0a                	push   $0xa
 550:	50                   	push   %eax
 551:	ff 75 08             	pushl  0x8(%ebp)
 554:	e8 c0 fe ff ff       	call   419 <printint>
 559:	83 c4 10             	add    $0x10,%esp
        ap++;
 55c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 560:	e9 d8 00 00 00       	jmp    63d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 565:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 569:	74 06                	je     571 <printf+0xa4>
 56b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 56f:	75 1e                	jne    58f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 571:	8b 45 e8             	mov    -0x18(%ebp),%eax
 574:	8b 00                	mov    (%eax),%eax
 576:	6a 00                	push   $0x0
 578:	6a 10                	push   $0x10
 57a:	50                   	push   %eax
 57b:	ff 75 08             	pushl  0x8(%ebp)
 57e:	e8 96 fe ff ff       	call   419 <printint>
 583:	83 c4 10             	add    $0x10,%esp
        ap++;
 586:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58a:	e9 ae 00 00 00       	jmp    63d <printf+0x170>
      } else if(c == 's'){
 58f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 593:	75 43                	jne    5d8 <printf+0x10b>
        s = (char*)*ap;
 595:	8b 45 e8             	mov    -0x18(%ebp),%eax
 598:	8b 00                	mov    (%eax),%eax
 59a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 59d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a5:	75 25                	jne    5cc <printf+0xff>
          s = "(null)";
 5a7:	c7 45 f4 97 08 00 00 	movl   $0x897,-0xc(%ebp)
        while(*s != 0){
 5ae:	eb 1c                	jmp    5cc <printf+0xff>
          putc(fd, *s);
 5b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b3:	0f b6 00             	movzbl (%eax),%eax
 5b6:	0f be c0             	movsbl %al,%eax
 5b9:	83 ec 08             	sub    $0x8,%esp
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 31 fe ff ff       	call   3f6 <putc>
 5c5:	83 c4 10             	add    $0x10,%esp
          s++;
 5c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cf:	0f b6 00             	movzbl (%eax),%eax
 5d2:	84 c0                	test   %al,%al
 5d4:	75 da                	jne    5b0 <printf+0xe3>
 5d6:	eb 65                	jmp    63d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5dc:	75 1d                	jne    5fb <printf+0x12e>
        putc(fd, *ap);
 5de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e1:	8b 00                	mov    (%eax),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	83 ec 08             	sub    $0x8,%esp
 5e9:	50                   	push   %eax
 5ea:	ff 75 08             	pushl  0x8(%ebp)
 5ed:	e8 04 fe ff ff       	call   3f6 <putc>
 5f2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f9:	eb 42                	jmp    63d <printf+0x170>
      } else if(c == '%'){
 5fb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ff:	75 17                	jne    618 <printf+0x14b>
        putc(fd, c);
 601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 604:	0f be c0             	movsbl %al,%eax
 607:	83 ec 08             	sub    $0x8,%esp
 60a:	50                   	push   %eax
 60b:	ff 75 08             	pushl  0x8(%ebp)
 60e:	e8 e3 fd ff ff       	call   3f6 <putc>
 613:	83 c4 10             	add    $0x10,%esp
 616:	eb 25                	jmp    63d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 618:	83 ec 08             	sub    $0x8,%esp
 61b:	6a 25                	push   $0x25
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 d1 fd ff ff       	call   3f6 <putc>
 625:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62b:	0f be c0             	movsbl %al,%eax
 62e:	83 ec 08             	sub    $0x8,%esp
 631:	50                   	push   %eax
 632:	ff 75 08             	pushl  0x8(%ebp)
 635:	e8 bc fd ff ff       	call   3f6 <putc>
 63a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 63d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 644:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 648:	8b 55 0c             	mov    0xc(%ebp),%edx
 64b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64e:	01 d0                	add    %edx,%eax
 650:	0f b6 00             	movzbl (%eax),%eax
 653:	84 c0                	test   %al,%al
 655:	0f 85 94 fe ff ff    	jne    4ef <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 65b:	90                   	nop
 65c:	c9                   	leave  
 65d:	c3                   	ret    

0000065e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65e:	55                   	push   %ebp
 65f:	89 e5                	mov    %esp,%ebp
 661:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 664:	8b 45 08             	mov    0x8(%ebp),%eax
 667:	83 e8 08             	sub    $0x8,%eax
 66a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66d:	a1 08 0b 00 00       	mov    0xb08,%eax
 672:	89 45 fc             	mov    %eax,-0x4(%ebp)
 675:	eb 24                	jmp    69b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67f:	77 12                	ja     693 <free+0x35>
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 687:	77 24                	ja     6ad <free+0x4f>
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 691:	77 1a                	ja     6ad <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a1:	76 d4                	jbe    677 <free+0x19>
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	8b 00                	mov    (%eax),%eax
 6a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ab:	76 ca                	jbe    677 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	8b 40 04             	mov    0x4(%eax),%eax
 6b3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	01 c2                	add    %eax,%edx
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	39 c2                	cmp    %eax,%edx
 6c6:	75 24                	jne    6ec <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	8b 50 04             	mov    0x4(%eax),%edx
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	8b 40 04             	mov    0x4(%eax),%eax
 6d6:	01 c2                	add    %eax,%edx
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 00                	mov    (%eax),%eax
 6e3:	8b 10                	mov    (%eax),%edx
 6e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e8:	89 10                	mov    %edx,(%eax)
 6ea:	eb 0a                	jmp    6f6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 10                	mov    (%eax),%edx
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 40 04             	mov    0x4(%eax),%eax
 6fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	01 d0                	add    %edx,%eax
 708:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70b:	75 20                	jne    72d <free+0xcf>
    p->s.size += bp->s.size;
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 50 04             	mov    0x4(%eax),%edx
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	8b 40 04             	mov    0x4(%eax),%eax
 719:	01 c2                	add    %eax,%edx
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 721:	8b 45 f8             	mov    -0x8(%ebp),%eax
 724:	8b 10                	mov    (%eax),%edx
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	89 10                	mov    %edx,(%eax)
 72b:	eb 08                	jmp    735 <free+0xd7>
  } else
    p->s.ptr = bp;
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 55 f8             	mov    -0x8(%ebp),%edx
 733:	89 10                	mov    %edx,(%eax)
  freep = p;
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	a3 08 0b 00 00       	mov    %eax,0xb08
}
 73d:	90                   	nop
 73e:	c9                   	leave  
 73f:	c3                   	ret    

00000740 <morecore>:

static Header*
morecore(uint nu)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 746:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 74d:	77 07                	ja     756 <morecore+0x16>
    nu = 4096;
 74f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 756:	8b 45 08             	mov    0x8(%ebp),%eax
 759:	c1 e0 03             	shl    $0x3,%eax
 75c:	83 ec 0c             	sub    $0xc,%esp
 75f:	50                   	push   %eax
 760:	e8 31 fc ff ff       	call   396 <sbrk>
 765:	83 c4 10             	add    $0x10,%esp
 768:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 76b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 76f:	75 07                	jne    778 <morecore+0x38>
    return 0;
 771:	b8 00 00 00 00       	mov    $0x0,%eax
 776:	eb 26                	jmp    79e <morecore+0x5e>
  hp = (Header*)p;
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	8b 55 08             	mov    0x8(%ebp),%edx
 784:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	83 c0 08             	add    $0x8,%eax
 78d:	83 ec 0c             	sub    $0xc,%esp
 790:	50                   	push   %eax
 791:	e8 c8 fe ff ff       	call   65e <free>
 796:	83 c4 10             	add    $0x10,%esp
  return freep;
 799:	a1 08 0b 00 00       	mov    0xb08,%eax
}
 79e:	c9                   	leave  
 79f:	c3                   	ret    

000007a0 <malloc>:

void*
malloc(uint nbytes)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a6:	8b 45 08             	mov    0x8(%ebp),%eax
 7a9:	83 c0 07             	add    $0x7,%eax
 7ac:	c1 e8 03             	shr    $0x3,%eax
 7af:	83 c0 01             	add    $0x1,%eax
 7b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b5:	a1 08 0b 00 00       	mov    0xb08,%eax
 7ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c1:	75 23                	jne    7e6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7c3:	c7 45 f0 00 0b 00 00 	movl   $0xb00,-0x10(%ebp)
 7ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cd:	a3 08 0b 00 00       	mov    %eax,0xb08
 7d2:	a1 08 0b 00 00       	mov    0xb08,%eax
 7d7:	a3 00 0b 00 00       	mov    %eax,0xb00
    base.s.size = 0;
 7dc:	c7 05 04 0b 00 00 00 	movl   $0x0,0xb04
 7e3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e9:	8b 00                	mov    (%eax),%eax
 7eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f7:	72 4d                	jb     846 <malloc+0xa6>
      if(p->s.size == nunits)
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	8b 40 04             	mov    0x4(%eax),%eax
 7ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 802:	75 0c                	jne    810 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 10                	mov    (%eax),%edx
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	89 10                	mov    %edx,(%eax)
 80e:	eb 26                	jmp    836 <malloc+0x96>
      else {
        p->s.size -= nunits;
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	2b 45 ec             	sub    -0x14(%ebp),%eax
 819:	89 c2                	mov    %eax,%edx
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	c1 e0 03             	shl    $0x3,%eax
 82a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 55 ec             	mov    -0x14(%ebp),%edx
 833:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 836:	8b 45 f0             	mov    -0x10(%ebp),%eax
 839:	a3 08 0b 00 00       	mov    %eax,0xb08
      return (void*)(p + 1);
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	83 c0 08             	add    $0x8,%eax
 844:	eb 3b                	jmp    881 <malloc+0xe1>
    }
    if(p == freep)
 846:	a1 08 0b 00 00       	mov    0xb08,%eax
 84b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 84e:	75 1e                	jne    86e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 850:	83 ec 0c             	sub    $0xc,%esp
 853:	ff 75 ec             	pushl  -0x14(%ebp)
 856:	e8 e5 fe ff ff       	call   740 <morecore>
 85b:	83 c4 10             	add    $0x10,%esp
 85e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 865:	75 07                	jne    86e <malloc+0xce>
        return 0;
 867:	b8 00 00 00 00       	mov    $0x0,%eax
 86c:	eb 13                	jmp    881 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	89 45 f0             	mov    %eax,-0x10(%ebp)
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 87c:	e9 6d ff ff ff       	jmp    7ee <malloc+0x4e>
}
 881:	c9                   	leave  
 882:	c3                   	ret    
