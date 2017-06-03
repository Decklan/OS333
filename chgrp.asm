
_chgrp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
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
  uint gid;
  char *pn;

  if (argc != 3) {
  14:	83 3b 03             	cmpl   $0x3,(%ebx)
  17:	74 17                	je     30 <main+0x30>
    printf(2, "ERROR: chgrp expects two args: a GID and a TARGET.\n"); 
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 88 09 00 00       	push   $0x988
  21:	6a 02                	push   $0x2
  23:	e8 a9 05 00 00       	call   5d1 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit(); 
  2b:	e8 ca 03 00 00       	call   3fa <exit>
  }

  gid = atoi(argv[1]);
  30:	8b 43 04             	mov    0x4(%ebx),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	50                   	push   %eax
  3c:	e8 54 02 00 00       	call   295 <atoi>
  41:	83 c4 10             	add    $0x10,%esp
  44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (gid < 0 || gid > 32767) {
  47:	81 7d f4 ff 7f 00 00 	cmpl   $0x7fff,-0xc(%ebp)
  4e:	76 17                	jbe    67 <main+0x67>
    printf(2, "A valid GID is expected.\n");
  50:	83 ec 08             	sub    $0x8,%esp
  53:	68 bc 09 00 00       	push   $0x9bc
  58:	6a 02                	push   $0x2
  5a:	e8 72 05 00 00       	call   5d1 <printf>
  5f:	83 c4 10             	add    $0x10,%esp
    exit();
  62:	e8 93 03 00 00       	call   3fa <exit>
  }

  pn = argv[2];
  67:	8b 43 04             	mov    0x4(%ebx),%eax
  6a:	8b 40 08             	mov    0x8(%eax),%eax
  6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (strlen(pn) < 1) {
  70:	83 ec 0c             	sub    $0xc,%esp
  73:	ff 75 f0             	pushl  -0x10(%ebp)
  76:	e8 ea 00 00 00       	call   165 <strlen>
  7b:	83 c4 10             	add    $0x10,%esp
  7e:	85 c0                	test   %eax,%eax
  80:	75 17                	jne    99 <main+0x99>
    printf(2, "A valid length file name is expected.\n");
  82:	83 ec 08             	sub    $0x8,%esp
  85:	68 d8 09 00 00       	push   $0x9d8
  8a:	6a 02                	push   $0x2
  8c:	e8 40 05 00 00       	call   5d1 <printf>
  91:	83 c4 10             	add    $0x10,%esp
    exit();
  94:	e8 61 03 00 00       	call   3fa <exit>
  }

  int rc = chgrp(pn, gid);
  99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9c:	83 ec 08             	sub    $0x8,%esp
  9f:	50                   	push   %eax
  a0:	ff 75 f0             	pushl  -0x10(%ebp)
  a3:	e8 4a 04 00 00       	call   4f2 <chgrp>
  a8:	83 c4 10             	add    $0x10,%esp
  ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (rc < 0) {
  ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  b2:	79 17                	jns    cb <main+0xcb>
    printf(2, "ERROR: chgrp failed.\n");
  b4:	83 ec 08             	sub    $0x8,%esp
  b7:	68 ff 09 00 00       	push   $0x9ff
  bc:	6a 02                	push   $0x2
  be:	e8 0e 05 00 00       	call   5d1 <printf>
  c3:	83 c4 10             	add    $0x10,%esp
    exit();
  c6:	e8 2f 03 00 00       	call   3fa <exit>
  }  
  exit();
  cb:	e8 2a 03 00 00       	call   3fa <exit>

000000d0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	57                   	push   %edi
  d4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d8:	8b 55 10             	mov    0x10(%ebp),%edx
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	89 cb                	mov    %ecx,%ebx
  e0:	89 df                	mov    %ebx,%edi
  e2:	89 d1                	mov    %edx,%ecx
  e4:	fc                   	cld    
  e5:	f3 aa                	rep stos %al,%es:(%edi)
  e7:	89 ca                	mov    %ecx,%edx
  e9:	89 fb                	mov    %edi,%ebx
  eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ee:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  f1:	90                   	nop
  f2:	5b                   	pop    %ebx
  f3:	5f                   	pop    %edi
  f4:	5d                   	pop    %ebp
  f5:	c3                   	ret    

000000f6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  f6:	55                   	push   %ebp
  f7:	89 e5                	mov    %esp,%ebp
  f9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 102:	90                   	nop
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	8d 50 01             	lea    0x1(%eax),%edx
 109:	89 55 08             	mov    %edx,0x8(%ebp)
 10c:	8b 55 0c             	mov    0xc(%ebp),%edx
 10f:	8d 4a 01             	lea    0x1(%edx),%ecx
 112:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 115:	0f b6 12             	movzbl (%edx),%edx
 118:	88 10                	mov    %dl,(%eax)
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	84 c0                	test   %al,%al
 11f:	75 e2                	jne    103 <strcpy+0xd>
    ;
  return os;
 121:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 124:	c9                   	leave  
 125:	c3                   	ret    

00000126 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 129:	eb 08                	jmp    133 <strcmp+0xd>
    p++, q++;
 12b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	0f b6 00             	movzbl (%eax),%eax
 139:	84 c0                	test   %al,%al
 13b:	74 10                	je     14d <strcmp+0x27>
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	0f b6 10             	movzbl (%eax),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	0f b6 00             	movzbl (%eax),%eax
 149:	38 c2                	cmp    %al,%dl
 14b:	74 de                	je     12b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 14d:	8b 45 08             	mov    0x8(%ebp),%eax
 150:	0f b6 00             	movzbl (%eax),%eax
 153:	0f b6 d0             	movzbl %al,%edx
 156:	8b 45 0c             	mov    0xc(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	0f b6 c0             	movzbl %al,%eax
 15f:	29 c2                	sub    %eax,%edx
 161:	89 d0                	mov    %edx,%eax
}
 163:	5d                   	pop    %ebp
 164:	c3                   	ret    

00000165 <strlen>:

uint
strlen(char *s)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 16b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 172:	eb 04                	jmp    178 <strlen+0x13>
 174:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 178:	8b 55 fc             	mov    -0x4(%ebp),%edx
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	01 d0                	add    %edx,%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	84 c0                	test   %al,%al
 185:	75 ed                	jne    174 <strlen+0xf>
    ;
  return n;
 187:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18a:	c9                   	leave  
 18b:	c3                   	ret    

0000018c <memset>:

void*
memset(void *dst, int c, uint n)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 18f:	8b 45 10             	mov    0x10(%ebp),%eax
 192:	50                   	push   %eax
 193:	ff 75 0c             	pushl  0xc(%ebp)
 196:	ff 75 08             	pushl  0x8(%ebp)
 199:	e8 32 ff ff ff       	call   d0 <stosb>
 19e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a4:	c9                   	leave  
 1a5:	c3                   	ret    

000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 04             	sub    $0x4,%esp
 1ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 1af:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b2:	eb 14                	jmp    1c8 <strchr+0x22>
    if(*s == c)
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	0f b6 00             	movzbl (%eax),%eax
 1ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1bd:	75 05                	jne    1c4 <strchr+0x1e>
      return (char*)s;
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	eb 13                	jmp    1d7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	0f b6 00             	movzbl (%eax),%eax
 1ce:	84 c0                	test   %al,%al
 1d0:	75 e2                	jne    1b4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d7:	c9                   	leave  
 1d8:	c3                   	ret    

000001d9 <gets>:

char*
gets(char *buf, int max)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e6:	eb 42                	jmp    22a <gets+0x51>
    cc = read(0, &c, 1);
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	6a 01                	push   $0x1
 1ed:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f0:	50                   	push   %eax
 1f1:	6a 00                	push   $0x0
 1f3:	e8 1a 02 00 00       	call   412 <read>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 202:	7e 33                	jle    237 <gets+0x5e>
      break;
    buf[i++] = c;
 204:	8b 45 f4             	mov    -0xc(%ebp),%eax
 207:	8d 50 01             	lea    0x1(%eax),%edx
 20a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 20d:	89 c2                	mov    %eax,%edx
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	01 c2                	add    %eax,%edx
 214:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 218:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 21a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21e:	3c 0a                	cmp    $0xa,%al
 220:	74 16                	je     238 <gets+0x5f>
 222:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 226:	3c 0d                	cmp    $0xd,%al
 228:	74 0e                	je     238 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22d:	83 c0 01             	add    $0x1,%eax
 230:	3b 45 0c             	cmp    0xc(%ebp),%eax
 233:	7c b3                	jl     1e8 <gets+0xf>
 235:	eb 01                	jmp    238 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 237:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 238:	8b 55 f4             	mov    -0xc(%ebp),%edx
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	01 d0                	add    %edx,%eax
 240:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 243:	8b 45 08             	mov    0x8(%ebp),%eax
}
 246:	c9                   	leave  
 247:	c3                   	ret    

00000248 <stat>:

int
stat(char *n, struct stat *st)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24e:	83 ec 08             	sub    $0x8,%esp
 251:	6a 00                	push   $0x0
 253:	ff 75 08             	pushl  0x8(%ebp)
 256:	e8 df 01 00 00       	call   43a <open>
 25b:	83 c4 10             	add    $0x10,%esp
 25e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 261:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 265:	79 07                	jns    26e <stat+0x26>
    return -1;
 267:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 26c:	eb 25                	jmp    293 <stat+0x4b>
  r = fstat(fd, st);
 26e:	83 ec 08             	sub    $0x8,%esp
 271:	ff 75 0c             	pushl  0xc(%ebp)
 274:	ff 75 f4             	pushl  -0xc(%ebp)
 277:	e8 d6 01 00 00       	call   452 <fstat>
 27c:	83 c4 10             	add    $0x10,%esp
 27f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 282:	83 ec 0c             	sub    $0xc,%esp
 285:	ff 75 f4             	pushl  -0xc(%ebp)
 288:	e8 95 01 00 00       	call   422 <close>
 28d:	83 c4 10             	add    $0x10,%esp
  return r;
 290:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 293:	c9                   	leave  
 294:	c3                   	ret    

00000295 <atoi>:

int
atoi(const char *s)
{
 295:	55                   	push   %ebp
 296:	89 e5                	mov    %esp,%ebp
 298:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 29b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 2a2:	eb 04                	jmp    2a8 <atoi+0x13>
 2a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	3c 20                	cmp    $0x20,%al
 2b0:	74 f2                	je     2a4 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	3c 2d                	cmp    $0x2d,%al
 2ba:	75 07                	jne    2c3 <atoi+0x2e>
 2bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c1:	eb 05                	jmp    2c8 <atoi+0x33>
 2c3:	b8 01 00 00 00       	mov    $0x1,%eax
 2c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	3c 2b                	cmp    $0x2b,%al
 2d3:	74 0a                	je     2df <atoi+0x4a>
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	3c 2d                	cmp    $0x2d,%al
 2dd:	75 2b                	jne    30a <atoi+0x75>
    s++;
 2df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2e3:	eb 25                	jmp    30a <atoi+0x75>
    n = n*10 + *s++ - '0';
 2e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e8:	89 d0                	mov    %edx,%eax
 2ea:	c1 e0 02             	shl    $0x2,%eax
 2ed:	01 d0                	add    %edx,%eax
 2ef:	01 c0                	add    %eax,%eax
 2f1:	89 c1                	mov    %eax,%ecx
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	8d 50 01             	lea    0x1(%eax),%edx
 2f9:	89 55 08             	mov    %edx,0x8(%ebp)
 2fc:	0f b6 00             	movzbl (%eax),%eax
 2ff:	0f be c0             	movsbl %al,%eax
 302:	01 c8                	add    %ecx,%eax
 304:	83 e8 30             	sub    $0x30,%eax
 307:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
 30d:	0f b6 00             	movzbl (%eax),%eax
 310:	3c 2f                	cmp    $0x2f,%al
 312:	7e 0a                	jle    31e <atoi+0x89>
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	0f b6 00             	movzbl (%eax),%eax
 31a:	3c 39                	cmp    $0x39,%al
 31c:	7e c7                	jle    2e5 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 31e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 321:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 325:	c9                   	leave  
 326:	c3                   	ret    

00000327 <atoo>:

int
atoo(const char *s)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 32d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 334:	eb 04                	jmp    33a <atoo+0x13>
 336:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	3c 20                	cmp    $0x20,%al
 342:	74 f2                	je     336 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	3c 2d                	cmp    $0x2d,%al
 34c:	75 07                	jne    355 <atoo+0x2e>
 34e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 353:	eb 05                	jmp    35a <atoo+0x33>
 355:	b8 01 00 00 00       	mov    $0x1,%eax
 35a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
 360:	0f b6 00             	movzbl (%eax),%eax
 363:	3c 2b                	cmp    $0x2b,%al
 365:	74 0a                	je     371 <atoo+0x4a>
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	0f b6 00             	movzbl (%eax),%eax
 36d:	3c 2d                	cmp    $0x2d,%al
 36f:	75 27                	jne    398 <atoo+0x71>
    s++;
 371:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 375:	eb 21                	jmp    398 <atoo+0x71>
    n = n*8 + *s++ - '0';
 377:	8b 45 fc             	mov    -0x4(%ebp),%eax
 37a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 381:	8b 45 08             	mov    0x8(%ebp),%eax
 384:	8d 50 01             	lea    0x1(%eax),%edx
 387:	89 55 08             	mov    %edx,0x8(%ebp)
 38a:	0f b6 00             	movzbl (%eax),%eax
 38d:	0f be c0             	movsbl %al,%eax
 390:	01 c8                	add    %ecx,%eax
 392:	83 e8 30             	sub    $0x30,%eax
 395:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 00             	movzbl (%eax),%eax
 39e:	3c 2f                	cmp    $0x2f,%al
 3a0:	7e 0a                	jle    3ac <atoo+0x85>
 3a2:	8b 45 08             	mov    0x8(%ebp),%eax
 3a5:	0f b6 00             	movzbl (%eax),%eax
 3a8:	3c 37                	cmp    $0x37,%al
 3aa:	7e cb                	jle    377 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3af:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3c7:	eb 17                	jmp    3e0 <memmove+0x2b>
    *dst++ = *src++;
 3c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3cc:	8d 50 01             	lea    0x1(%eax),%edx
 3cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3d5:	8d 4a 01             	lea    0x1(%edx),%ecx
 3d8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3db:	0f b6 12             	movzbl (%edx),%edx
 3de:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3e0:	8b 45 10             	mov    0x10(%ebp),%eax
 3e3:	8d 50 ff             	lea    -0x1(%eax),%edx
 3e6:	89 55 10             	mov    %edx,0x10(%ebp)
 3e9:	85 c0                	test   %eax,%eax
 3eb:	7f dc                	jg     3c9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f2:	b8 01 00 00 00       	mov    $0x1,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <exit>:
SYSCALL(exit)
 3fa:	b8 02 00 00 00       	mov    $0x2,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <wait>:
SYSCALL(wait)
 402:	b8 03 00 00 00       	mov    $0x3,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <pipe>:
SYSCALL(pipe)
 40a:	b8 04 00 00 00       	mov    $0x4,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <read>:
SYSCALL(read)
 412:	b8 05 00 00 00       	mov    $0x5,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <write>:
SYSCALL(write)
 41a:	b8 10 00 00 00       	mov    $0x10,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <close>:
SYSCALL(close)
 422:	b8 15 00 00 00       	mov    $0x15,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <kill>:
SYSCALL(kill)
 42a:	b8 06 00 00 00       	mov    $0x6,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <exec>:
SYSCALL(exec)
 432:	b8 07 00 00 00       	mov    $0x7,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <open>:
SYSCALL(open)
 43a:	b8 0f 00 00 00       	mov    $0xf,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <mknod>:
SYSCALL(mknod)
 442:	b8 11 00 00 00       	mov    $0x11,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <unlink>:
SYSCALL(unlink)
 44a:	b8 12 00 00 00       	mov    $0x12,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <fstat>:
SYSCALL(fstat)
 452:	b8 08 00 00 00       	mov    $0x8,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <link>:
SYSCALL(link)
 45a:	b8 13 00 00 00       	mov    $0x13,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <mkdir>:
SYSCALL(mkdir)
 462:	b8 14 00 00 00       	mov    $0x14,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <chdir>:
SYSCALL(chdir)
 46a:	b8 09 00 00 00       	mov    $0x9,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <dup>:
SYSCALL(dup)
 472:	b8 0a 00 00 00       	mov    $0xa,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <getpid>:
SYSCALL(getpid)
 47a:	b8 0b 00 00 00       	mov    $0xb,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <sbrk>:
SYSCALL(sbrk)
 482:	b8 0c 00 00 00       	mov    $0xc,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <sleep>:
SYSCALL(sleep)
 48a:	b8 0d 00 00 00       	mov    $0xd,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <uptime>:
SYSCALL(uptime)
 492:	b8 0e 00 00 00       	mov    $0xe,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <halt>:
SYSCALL(halt)
 49a:	b8 16 00 00 00       	mov    $0x16,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <date>:
SYSCALL(date)        #p1
 4a2:	b8 17 00 00 00       	mov    $0x17,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <getuid>:
SYSCALL(getuid)      #p2
 4aa:	b8 18 00 00 00       	mov    $0x18,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <getgid>:
SYSCALL(getgid)      #p2
 4b2:	b8 19 00 00 00       	mov    $0x19,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <getppid>:
SYSCALL(getppid)     #p2
 4ba:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <setuid>:
SYSCALL(setuid)      #p2
 4c2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <setgid>:
SYSCALL(setgid)      #p2
 4ca:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <getprocs>:
SYSCALL(getprocs)    #p2
 4d2:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <setpriority>:
SYSCALL(setpriority) #p4
 4da:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <chmod>:
SYSCALL(chmod)       #p5
 4e2:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <chown>:
SYSCALL(chown)       #p5
 4ea:	b8 20 00 00 00       	mov    $0x20,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <chgrp>:
SYSCALL(chgrp)       #p5
 4f2:	b8 21 00 00 00       	mov    $0x21,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4fa:	55                   	push   %ebp
 4fb:	89 e5                	mov    %esp,%ebp
 4fd:	83 ec 18             	sub    $0x18,%esp
 500:	8b 45 0c             	mov    0xc(%ebp),%eax
 503:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 506:	83 ec 04             	sub    $0x4,%esp
 509:	6a 01                	push   $0x1
 50b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 50e:	50                   	push   %eax
 50f:	ff 75 08             	pushl  0x8(%ebp)
 512:	e8 03 ff ff ff       	call   41a <write>
 517:	83 c4 10             	add    $0x10,%esp
}
 51a:	90                   	nop
 51b:	c9                   	leave  
 51c:	c3                   	ret    

0000051d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51d:	55                   	push   %ebp
 51e:	89 e5                	mov    %esp,%ebp
 520:	53                   	push   %ebx
 521:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 524:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 52b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 52f:	74 17                	je     548 <printint+0x2b>
 531:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 535:	79 11                	jns    548 <printint+0x2b>
    neg = 1;
 537:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 53e:	8b 45 0c             	mov    0xc(%ebp),%eax
 541:	f7 d8                	neg    %eax
 543:	89 45 ec             	mov    %eax,-0x14(%ebp)
 546:	eb 06                	jmp    54e <printint+0x31>
  } else {
    x = xx;
 548:	8b 45 0c             	mov    0xc(%ebp),%eax
 54b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 54e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 555:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 558:	8d 41 01             	lea    0x1(%ecx),%eax
 55b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 55e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 561:	8b 45 ec             	mov    -0x14(%ebp),%eax
 564:	ba 00 00 00 00       	mov    $0x0,%edx
 569:	f7 f3                	div    %ebx
 56b:	89 d0                	mov    %edx,%eax
 56d:	0f b6 80 88 0c 00 00 	movzbl 0xc88(%eax),%eax
 574:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 578:	8b 5d 10             	mov    0x10(%ebp),%ebx
 57b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 57e:	ba 00 00 00 00       	mov    $0x0,%edx
 583:	f7 f3                	div    %ebx
 585:	89 45 ec             	mov    %eax,-0x14(%ebp)
 588:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58c:	75 c7                	jne    555 <printint+0x38>
  if(neg)
 58e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 592:	74 2d                	je     5c1 <printint+0xa4>
    buf[i++] = '-';
 594:	8b 45 f4             	mov    -0xc(%ebp),%eax
 597:	8d 50 01             	lea    0x1(%eax),%edx
 59a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 59d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5a2:	eb 1d                	jmp    5c1 <printint+0xa4>
    putc(fd, buf[i]);
 5a4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5aa:	01 d0                	add    %edx,%eax
 5ac:	0f b6 00             	movzbl (%eax),%eax
 5af:	0f be c0             	movsbl %al,%eax
 5b2:	83 ec 08             	sub    $0x8,%esp
 5b5:	50                   	push   %eax
 5b6:	ff 75 08             	pushl  0x8(%ebp)
 5b9:	e8 3c ff ff ff       	call   4fa <putc>
 5be:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5c1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c9:	79 d9                	jns    5a4 <printint+0x87>
    putc(fd, buf[i]);
}
 5cb:	90                   	nop
 5cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5cf:	c9                   	leave  
 5d0:	c3                   	ret    

000005d1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5d1:	55                   	push   %ebp
 5d2:	89 e5                	mov    %esp,%ebp
 5d4:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5de:	8d 45 0c             	lea    0xc(%ebp),%eax
 5e1:	83 c0 04             	add    $0x4,%eax
 5e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5ee:	e9 59 01 00 00       	jmp    74c <printf+0x17b>
    c = fmt[i] & 0xff;
 5f3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f9:	01 d0                	add    %edx,%eax
 5fb:	0f b6 00             	movzbl (%eax),%eax
 5fe:	0f be c0             	movsbl %al,%eax
 601:	25 ff 00 00 00       	and    $0xff,%eax
 606:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 609:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 60d:	75 2c                	jne    63b <printf+0x6a>
      if(c == '%'){
 60f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 613:	75 0c                	jne    621 <printf+0x50>
        state = '%';
 615:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 61c:	e9 27 01 00 00       	jmp    748 <printf+0x177>
      } else {
        putc(fd, c);
 621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 624:	0f be c0             	movsbl %al,%eax
 627:	83 ec 08             	sub    $0x8,%esp
 62a:	50                   	push   %eax
 62b:	ff 75 08             	pushl  0x8(%ebp)
 62e:	e8 c7 fe ff ff       	call   4fa <putc>
 633:	83 c4 10             	add    $0x10,%esp
 636:	e9 0d 01 00 00       	jmp    748 <printf+0x177>
      }
    } else if(state == '%'){
 63b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 63f:	0f 85 03 01 00 00    	jne    748 <printf+0x177>
      if(c == 'd'){
 645:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 649:	75 1e                	jne    669 <printf+0x98>
        printint(fd, *ap, 10, 1);
 64b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	6a 01                	push   $0x1
 652:	6a 0a                	push   $0xa
 654:	50                   	push   %eax
 655:	ff 75 08             	pushl  0x8(%ebp)
 658:	e8 c0 fe ff ff       	call   51d <printint>
 65d:	83 c4 10             	add    $0x10,%esp
        ap++;
 660:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 664:	e9 d8 00 00 00       	jmp    741 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 669:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 66d:	74 06                	je     675 <printf+0xa4>
 66f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 673:	75 1e                	jne    693 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 675:	8b 45 e8             	mov    -0x18(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	6a 00                	push   $0x0
 67c:	6a 10                	push   $0x10
 67e:	50                   	push   %eax
 67f:	ff 75 08             	pushl  0x8(%ebp)
 682:	e8 96 fe ff ff       	call   51d <printint>
 687:	83 c4 10             	add    $0x10,%esp
        ap++;
 68a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68e:	e9 ae 00 00 00       	jmp    741 <printf+0x170>
      } else if(c == 's'){
 693:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 697:	75 43                	jne    6dc <printf+0x10b>
        s = (char*)*ap;
 699:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a9:	75 25                	jne    6d0 <printf+0xff>
          s = "(null)";
 6ab:	c7 45 f4 15 0a 00 00 	movl   $0xa15,-0xc(%ebp)
        while(*s != 0){
 6b2:	eb 1c                	jmp    6d0 <printf+0xff>
          putc(fd, *s);
 6b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b7:	0f b6 00             	movzbl (%eax),%eax
 6ba:	0f be c0             	movsbl %al,%eax
 6bd:	83 ec 08             	sub    $0x8,%esp
 6c0:	50                   	push   %eax
 6c1:	ff 75 08             	pushl  0x8(%ebp)
 6c4:	e8 31 fe ff ff       	call   4fa <putc>
 6c9:	83 c4 10             	add    $0x10,%esp
          s++;
 6cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d3:	0f b6 00             	movzbl (%eax),%eax
 6d6:	84 c0                	test   %al,%al
 6d8:	75 da                	jne    6b4 <printf+0xe3>
 6da:	eb 65                	jmp    741 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6dc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6e0:	75 1d                	jne    6ff <printf+0x12e>
        putc(fd, *ap);
 6e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e5:	8b 00                	mov    (%eax),%eax
 6e7:	0f be c0             	movsbl %al,%eax
 6ea:	83 ec 08             	sub    $0x8,%esp
 6ed:	50                   	push   %eax
 6ee:	ff 75 08             	pushl  0x8(%ebp)
 6f1:	e8 04 fe ff ff       	call   4fa <putc>
 6f6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6fd:	eb 42                	jmp    741 <printf+0x170>
      } else if(c == '%'){
 6ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 703:	75 17                	jne    71c <printf+0x14b>
        putc(fd, c);
 705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 708:	0f be c0             	movsbl %al,%eax
 70b:	83 ec 08             	sub    $0x8,%esp
 70e:	50                   	push   %eax
 70f:	ff 75 08             	pushl  0x8(%ebp)
 712:	e8 e3 fd ff ff       	call   4fa <putc>
 717:	83 c4 10             	add    $0x10,%esp
 71a:	eb 25                	jmp    741 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 71c:	83 ec 08             	sub    $0x8,%esp
 71f:	6a 25                	push   $0x25
 721:	ff 75 08             	pushl  0x8(%ebp)
 724:	e8 d1 fd ff ff       	call   4fa <putc>
 729:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 72c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72f:	0f be c0             	movsbl %al,%eax
 732:	83 ec 08             	sub    $0x8,%esp
 735:	50                   	push   %eax
 736:	ff 75 08             	pushl  0x8(%ebp)
 739:	e8 bc fd ff ff       	call   4fa <putc>
 73e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 741:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 748:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 74c:	8b 55 0c             	mov    0xc(%ebp),%edx
 74f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 752:	01 d0                	add    %edx,%eax
 754:	0f b6 00             	movzbl (%eax),%eax
 757:	84 c0                	test   %al,%al
 759:	0f 85 94 fe ff ff    	jne    5f3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 75f:	90                   	nop
 760:	c9                   	leave  
 761:	c3                   	ret    

00000762 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 762:	55                   	push   %ebp
 763:	89 e5                	mov    %esp,%ebp
 765:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 768:	8b 45 08             	mov    0x8(%ebp),%eax
 76b:	83 e8 08             	sub    $0x8,%eax
 76e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 771:	a1 a4 0c 00 00       	mov    0xca4,%eax
 776:	89 45 fc             	mov    %eax,-0x4(%ebp)
 779:	eb 24                	jmp    79f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 783:	77 12                	ja     797 <free+0x35>
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78b:	77 24                	ja     7b1 <free+0x4f>
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	8b 00                	mov    (%eax),%eax
 792:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 795:	77 1a                	ja     7b1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 79f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a5:	76 d4                	jbe    77b <free+0x19>
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7af:	76 ca                	jbe    77b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b4:	8b 40 04             	mov    0x4(%eax),%eax
 7b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	01 c2                	add    %eax,%edx
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	39 c2                	cmp    %eax,%edx
 7ca:	75 24                	jne    7f0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cf:	8b 50 04             	mov    0x4(%eax),%edx
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	8b 00                	mov    (%eax),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	01 c2                	add    %eax,%edx
 7dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7df:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 00                	mov    (%eax),%eax
 7e7:	8b 10                	mov    (%eax),%edx
 7e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ec:	89 10                	mov    %edx,(%eax)
 7ee:	eb 0a                	jmp    7fa <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	8b 10                	mov    (%eax),%edx
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	8b 40 04             	mov    0x4(%eax),%eax
 800:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	01 d0                	add    %edx,%eax
 80c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80f:	75 20                	jne    831 <free+0xcf>
    p->s.size += bp->s.size;
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 50 04             	mov    0x4(%eax),%edx
 817:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	01 c2                	add    %eax,%edx
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 825:	8b 45 f8             	mov    -0x8(%ebp),%eax
 828:	8b 10                	mov    (%eax),%edx
 82a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82d:	89 10                	mov    %edx,(%eax)
 82f:	eb 08                	jmp    839 <free+0xd7>
  } else
    p->s.ptr = bp;
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 55 f8             	mov    -0x8(%ebp),%edx
 837:	89 10                	mov    %edx,(%eax)
  freep = p;
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	a3 a4 0c 00 00       	mov    %eax,0xca4
}
 841:	90                   	nop
 842:	c9                   	leave  
 843:	c3                   	ret    

00000844 <morecore>:

static Header*
morecore(uint nu)
{
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 84a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 851:	77 07                	ja     85a <morecore+0x16>
    nu = 4096;
 853:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 85a:	8b 45 08             	mov    0x8(%ebp),%eax
 85d:	c1 e0 03             	shl    $0x3,%eax
 860:	83 ec 0c             	sub    $0xc,%esp
 863:	50                   	push   %eax
 864:	e8 19 fc ff ff       	call   482 <sbrk>
 869:	83 c4 10             	add    $0x10,%esp
 86c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 86f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 873:	75 07                	jne    87c <morecore+0x38>
    return 0;
 875:	b8 00 00 00 00       	mov    $0x0,%eax
 87a:	eb 26                	jmp    8a2 <morecore+0x5e>
  hp = (Header*)p;
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 882:	8b 45 f0             	mov    -0x10(%ebp),%eax
 885:	8b 55 08             	mov    0x8(%ebp),%edx
 888:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 88b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88e:	83 c0 08             	add    $0x8,%eax
 891:	83 ec 0c             	sub    $0xc,%esp
 894:	50                   	push   %eax
 895:	e8 c8 fe ff ff       	call   762 <free>
 89a:	83 c4 10             	add    $0x10,%esp
  return freep;
 89d:	a1 a4 0c 00 00       	mov    0xca4,%eax
}
 8a2:	c9                   	leave  
 8a3:	c3                   	ret    

000008a4 <malloc>:

void*
malloc(uint nbytes)
{
 8a4:	55                   	push   %ebp
 8a5:	89 e5                	mov    %esp,%ebp
 8a7:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8aa:	8b 45 08             	mov    0x8(%ebp),%eax
 8ad:	83 c0 07             	add    $0x7,%eax
 8b0:	c1 e8 03             	shr    $0x3,%eax
 8b3:	83 c0 01             	add    $0x1,%eax
 8b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8b9:	a1 a4 0c 00 00       	mov    0xca4,%eax
 8be:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8c5:	75 23                	jne    8ea <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8c7:	c7 45 f0 9c 0c 00 00 	movl   $0xc9c,-0x10(%ebp)
 8ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d1:	a3 a4 0c 00 00       	mov    %eax,0xca4
 8d6:	a1 a4 0c 00 00       	mov    0xca4,%eax
 8db:	a3 9c 0c 00 00       	mov    %eax,0xc9c
    base.s.size = 0;
 8e0:	c7 05 a0 0c 00 00 00 	movl   $0x0,0xca0
 8e7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ed:	8b 00                	mov    (%eax),%eax
 8ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	8b 40 04             	mov    0x4(%eax),%eax
 8f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8fb:	72 4d                	jb     94a <malloc+0xa6>
      if(p->s.size == nunits)
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	8b 40 04             	mov    0x4(%eax),%eax
 903:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 906:	75 0c                	jne    914 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	8b 10                	mov    (%eax),%edx
 90d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 910:	89 10                	mov    %edx,(%eax)
 912:	eb 26                	jmp    93a <malloc+0x96>
      else {
        p->s.size -= nunits;
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	8b 40 04             	mov    0x4(%eax),%eax
 91a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 91d:	89 c2                	mov    %eax,%edx
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	8b 40 04             	mov    0x4(%eax),%eax
 92b:	c1 e0 03             	shl    $0x3,%eax
 92e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	8b 55 ec             	mov    -0x14(%ebp),%edx
 937:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 93a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93d:	a3 a4 0c 00 00       	mov    %eax,0xca4
      return (void*)(p + 1);
 942:	8b 45 f4             	mov    -0xc(%ebp),%eax
 945:	83 c0 08             	add    $0x8,%eax
 948:	eb 3b                	jmp    985 <malloc+0xe1>
    }
    if(p == freep)
 94a:	a1 a4 0c 00 00       	mov    0xca4,%eax
 94f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 952:	75 1e                	jne    972 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 954:	83 ec 0c             	sub    $0xc,%esp
 957:	ff 75 ec             	pushl  -0x14(%ebp)
 95a:	e8 e5 fe ff ff       	call   844 <morecore>
 95f:	83 c4 10             	add    $0x10,%esp
 962:	89 45 f4             	mov    %eax,-0xc(%ebp)
 965:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 969:	75 07                	jne    972 <malloc+0xce>
        return 0;
 96b:	b8 00 00 00 00       	mov    $0x0,%eax
 970:	eb 13                	jmp    985 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 972:	8b 45 f4             	mov    -0xc(%ebp),%eax
 975:	89 45 f0             	mov    %eax,-0x10(%ebp)
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	8b 00                	mov    (%eax),%eax
 97d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 980:	e9 6d ff ff ff       	jmp    8f2 <malloc+0x4e>
}
 985:	c9                   	leave  
 986:	c3                   	ret    
