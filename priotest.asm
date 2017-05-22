
_priotest:     file format elf32-i386


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
  if (argc < 3 || argc > 3) {
  14:	83 3b 02             	cmpl   $0x2,(%ebx)
  17:	7e 05                	jle    1e <main+0x1e>
  19:	83 3b 03             	cmpl   $0x3,(%ebx)
  1c:	7e 17                	jle    35 <main+0x35>
    printf(2, "ERROR: priotest expects exactly 2 args.\n");
  1e:	83 ec 08             	sub    $0x8,%esp
  21:	68 1c 09 00 00       	push   $0x91c
  26:	6a 02                	push   $0x2
  28:	e8 36 05 00 00       	call   563 <printf>
  2d:	83 c4 10             	add    $0x10,%esp
    exit();
  30:	e8 6f 03 00 00       	call   3a4 <exit>
  }

  int pid = atoi(argv[1]);
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	50                   	push   %eax
  41:	e8 87 02 00 00       	call   2cd <atoi>
  46:	83 c4 10             	add    $0x10,%esp
  49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int prio = atoi(argv[2]);
  4c:	8b 43 04             	mov    0x4(%ebx),%eax
  4f:	83 c0 08             	add    $0x8,%eax
  52:	8b 00                	mov    (%eax),%eax
  54:	83 ec 0c             	sub    $0xc,%esp
  57:	50                   	push   %eax
  58:	e8 70 02 00 00       	call   2cd <atoi>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int rc = setpriority(pid, prio);
  63:	83 ec 08             	sub    $0x8,%esp
  66:	ff 75 f0             	pushl  -0x10(%ebp)
  69:	ff 75 f4             	pushl  -0xc(%ebp)
  6c:	e8 13 04 00 00       	call   484 <setpriority>
  71:	83 c4 10             	add    $0x10,%esp
  74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (rc == -1) {
  77:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  7b:	75 17                	jne    94 <main+0x94>
    printf(2, "INVALID PID.\n");
  7d:	83 ec 08             	sub    $0x8,%esp
  80:	68 45 09 00 00       	push   $0x945
  85:	6a 02                	push   $0x2
  87:	e8 d7 04 00 00       	call   563 <printf>
  8c:	83 c4 10             	add    $0x10,%esp
    exit();
  8f:	e8 10 03 00 00       	call   3a4 <exit>
  } else if (rc == 0) {
  94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  98:	75 17                	jne    b1 <main+0xb1>
    printf(1, "Success!\n");
  9a:	83 ec 08             	sub    $0x8,%esp
  9d:	68 53 09 00 00       	push   $0x953
  a2:	6a 01                	push   $0x1
  a4:	e8 ba 04 00 00       	call   563 <printf>
  a9:	83 c4 10             	add    $0x10,%esp
    exit();
  ac:	e8 f3 02 00 00       	call   3a4 <exit>
  } else if (rc == 1){
  b1:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  b5:	75 1a                	jne    d1 <main+0xd1>
    printf(1, "Process already has priority %d.\n", prio);
  b7:	83 ec 04             	sub    $0x4,%esp
  ba:	ff 75 f0             	pushl  -0x10(%ebp)
  bd:	68 60 09 00 00       	push   $0x960
  c2:	6a 01                	push   $0x1
  c4:	e8 9a 04 00 00       	call   563 <printf>
  c9:	83 c4 10             	add    $0x10,%esp
    exit();
  cc:	e8 d3 02 00 00       	call   3a4 <exit>
  } else if (rc == -2) {
  d1:	83 7d ec fe          	cmpl   $0xfffffffe,-0x14(%ebp)
  d5:	75 17                	jne    ee <main+0xee>
    printf(2, "INVALID PRIORITY VALUE.\n");
  d7:	83 ec 08             	sub    $0x8,%esp
  da:	68 82 09 00 00       	push   $0x982
  df:	6a 02                	push   $0x2
  e1:	e8 7d 04 00 00       	call   563 <printf>
  e6:	83 c4 10             	add    $0x10,%esp
    exit();
  e9:	e8 b6 02 00 00       	call   3a4 <exit>
  } else {
    printf(2, "PID: %d not found.\n", pid);
  ee:	83 ec 04             	sub    $0x4,%esp
  f1:	ff 75 f4             	pushl  -0xc(%ebp)
  f4:	68 9b 09 00 00       	push   $0x99b
  f9:	6a 02                	push   $0x2
  fb:	e8 63 04 00 00       	call   563 <printf>
 100:	83 c4 10             	add    $0x10,%esp
    exit();
 103:	e8 9c 02 00 00       	call   3a4 <exit>

00000108 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	57                   	push   %edi
 10c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 10d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 110:	8b 55 10             	mov    0x10(%ebp),%edx
 113:	8b 45 0c             	mov    0xc(%ebp),%eax
 116:	89 cb                	mov    %ecx,%ebx
 118:	89 df                	mov    %ebx,%edi
 11a:	89 d1                	mov    %edx,%ecx
 11c:	fc                   	cld    
 11d:	f3 aa                	rep stos %al,%es:(%edi)
 11f:	89 ca                	mov    %ecx,%edx
 121:	89 fb                	mov    %edi,%ebx
 123:	89 5d 08             	mov    %ebx,0x8(%ebp)
 126:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 129:	90                   	nop
 12a:	5b                   	pop    %ebx
 12b:	5f                   	pop    %edi
 12c:	5d                   	pop    %ebp
 12d:	c3                   	ret    

0000012e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
 131:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 13a:	90                   	nop
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	8d 50 01             	lea    0x1(%eax),%edx
 141:	89 55 08             	mov    %edx,0x8(%ebp)
 144:	8b 55 0c             	mov    0xc(%ebp),%edx
 147:	8d 4a 01             	lea    0x1(%edx),%ecx
 14a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 14d:	0f b6 12             	movzbl (%edx),%edx
 150:	88 10                	mov    %dl,(%eax)
 152:	0f b6 00             	movzbl (%eax),%eax
 155:	84 c0                	test   %al,%al
 157:	75 e2                	jne    13b <strcpy+0xd>
    ;
  return os;
 159:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 161:	eb 08                	jmp    16b <strcmp+0xd>
    p++, q++;
 163:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 167:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 00             	movzbl (%eax),%eax
 171:	84 c0                	test   %al,%al
 173:	74 10                	je     185 <strcmp+0x27>
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	0f b6 10             	movzbl (%eax),%edx
 17b:	8b 45 0c             	mov    0xc(%ebp),%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	38 c2                	cmp    %al,%dl
 183:	74 de                	je     163 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	0f b6 00             	movzbl (%eax),%eax
 18b:	0f b6 d0             	movzbl %al,%edx
 18e:	8b 45 0c             	mov    0xc(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	0f b6 c0             	movzbl %al,%eax
 197:	29 c2                	sub    %eax,%edx
 199:	89 d0                	mov    %edx,%eax
}
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret    

0000019d <strlen>:

uint
strlen(char *s)
{
 19d:	55                   	push   %ebp
 19e:	89 e5                	mov    %esp,%ebp
 1a0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1aa:	eb 04                	jmp    1b0 <strlen+0x13>
 1ac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 d0                	add    %edx,%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	75 ed                	jne    1ac <strlen+0xf>
    ;
  return n;
 1bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c2:	c9                   	leave  
 1c3:	c3                   	ret    

000001c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c7:	8b 45 10             	mov    0x10(%ebp),%eax
 1ca:	50                   	push   %eax
 1cb:	ff 75 0c             	pushl  0xc(%ebp)
 1ce:	ff 75 08             	pushl  0x8(%ebp)
 1d1:	e8 32 ff ff ff       	call   108 <stosb>
 1d6:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1dc:	c9                   	leave  
 1dd:	c3                   	ret    

000001de <strchr>:

char*
strchr(const char *s, char c)
{
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	83 ec 04             	sub    $0x4,%esp
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ea:	eb 14                	jmp    200 <strchr+0x22>
    if(*s == c)
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	0f b6 00             	movzbl (%eax),%eax
 1f2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1f5:	75 05                	jne    1fc <strchr+0x1e>
      return (char*)s;
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	eb 13                	jmp    20f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	84 c0                	test   %al,%al
 208:	75 e2                	jne    1ec <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 20a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 20f:	c9                   	leave  
 210:	c3                   	ret    

00000211 <gets>:

char*
gets(char *buf, int max)
{
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
 214:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 217:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 21e:	eb 42                	jmp    262 <gets+0x51>
    cc = read(0, &c, 1);
 220:	83 ec 04             	sub    $0x4,%esp
 223:	6a 01                	push   $0x1
 225:	8d 45 ef             	lea    -0x11(%ebp),%eax
 228:	50                   	push   %eax
 229:	6a 00                	push   $0x0
 22b:	e8 8c 01 00 00       	call   3bc <read>
 230:	83 c4 10             	add    $0x10,%esp
 233:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 236:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 23a:	7e 33                	jle    26f <gets+0x5e>
      break;
    buf[i++] = c;
 23c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23f:	8d 50 01             	lea    0x1(%eax),%edx
 242:	89 55 f4             	mov    %edx,-0xc(%ebp)
 245:	89 c2                	mov    %eax,%edx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	01 c2                	add    %eax,%edx
 24c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 250:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 252:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 256:	3c 0a                	cmp    $0xa,%al
 258:	74 16                	je     270 <gets+0x5f>
 25a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25e:	3c 0d                	cmp    $0xd,%al
 260:	74 0e                	je     270 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 262:	8b 45 f4             	mov    -0xc(%ebp),%eax
 265:	83 c0 01             	add    $0x1,%eax
 268:	3b 45 0c             	cmp    0xc(%ebp),%eax
 26b:	7c b3                	jl     220 <gets+0xf>
 26d:	eb 01                	jmp    270 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 26f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 270:	8b 55 f4             	mov    -0xc(%ebp),%edx
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	01 d0                	add    %edx,%eax
 278:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27e:	c9                   	leave  
 27f:	c3                   	ret    

00000280 <stat>:

int
stat(char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 286:	83 ec 08             	sub    $0x8,%esp
 289:	6a 00                	push   $0x0
 28b:	ff 75 08             	pushl  0x8(%ebp)
 28e:	e8 51 01 00 00       	call   3e4 <open>
 293:	83 c4 10             	add    $0x10,%esp
 296:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 299:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 29d:	79 07                	jns    2a6 <stat+0x26>
    return -1;
 29f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a4:	eb 25                	jmp    2cb <stat+0x4b>
  r = fstat(fd, st);
 2a6:	83 ec 08             	sub    $0x8,%esp
 2a9:	ff 75 0c             	pushl  0xc(%ebp)
 2ac:	ff 75 f4             	pushl  -0xc(%ebp)
 2af:	e8 48 01 00 00       	call   3fc <fstat>
 2b4:	83 c4 10             	add    $0x10,%esp
 2b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ba:	83 ec 0c             	sub    $0xc,%esp
 2bd:	ff 75 f4             	pushl  -0xc(%ebp)
 2c0:	e8 07 01 00 00       	call   3cc <close>
 2c5:	83 c4 10             	add    $0x10,%esp
  return r;
 2c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2cb:	c9                   	leave  
 2cc:	c3                   	ret    

000002cd <atoi>:

int
atoi(const char *s)
{
 2cd:	55                   	push   %ebp
 2ce:	89 e5                	mov    %esp,%ebp
 2d0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 2da:	eb 04                	jmp    2e0 <atoi+0x13>
 2dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	0f b6 00             	movzbl (%eax),%eax
 2e6:	3c 20                	cmp    $0x20,%al
 2e8:	74 f2                	je     2dc <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	0f b6 00             	movzbl (%eax),%eax
 2f0:	3c 2d                	cmp    $0x2d,%al
 2f2:	75 07                	jne    2fb <atoi+0x2e>
 2f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f9:	eb 05                	jmp    300 <atoi+0x33>
 2fb:	b8 01 00 00 00       	mov    $0x1,%eax
 300:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	3c 2b                	cmp    $0x2b,%al
 30b:	74 0a                	je     317 <atoi+0x4a>
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	0f b6 00             	movzbl (%eax),%eax
 313:	3c 2d                	cmp    $0x2d,%al
 315:	75 2b                	jne    342 <atoi+0x75>
    s++;
 317:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 31b:	eb 25                	jmp    342 <atoi+0x75>
    n = n*10 + *s++ - '0';
 31d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 320:	89 d0                	mov    %edx,%eax
 322:	c1 e0 02             	shl    $0x2,%eax
 325:	01 d0                	add    %edx,%eax
 327:	01 c0                	add    %eax,%eax
 329:	89 c1                	mov    %eax,%ecx
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	8d 50 01             	lea    0x1(%eax),%edx
 331:	89 55 08             	mov    %edx,0x8(%ebp)
 334:	0f b6 00             	movzbl (%eax),%eax
 337:	0f be c0             	movsbl %al,%eax
 33a:	01 c8                	add    %ecx,%eax
 33c:	83 e8 30             	sub    $0x30,%eax
 33f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	0f b6 00             	movzbl (%eax),%eax
 348:	3c 2f                	cmp    $0x2f,%al
 34a:	7e 0a                	jle    356 <atoi+0x89>
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	0f b6 00             	movzbl (%eax),%eax
 352:	3c 39                	cmp    $0x39,%al
 354:	7e c7                	jle    31d <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 356:	8b 45 f8             	mov    -0x8(%ebp),%eax
 359:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 35d:	c9                   	leave  
 35e:	c3                   	ret    

0000035f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 36b:	8b 45 0c             	mov    0xc(%ebp),%eax
 36e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 371:	eb 17                	jmp    38a <memmove+0x2b>
    *dst++ = *src++;
 373:	8b 45 fc             	mov    -0x4(%ebp),%eax
 376:	8d 50 01             	lea    0x1(%eax),%edx
 379:	89 55 fc             	mov    %edx,-0x4(%ebp)
 37c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37f:	8d 4a 01             	lea    0x1(%edx),%ecx
 382:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 385:	0f b6 12             	movzbl (%edx),%edx
 388:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38a:	8b 45 10             	mov    0x10(%ebp),%eax
 38d:	8d 50 ff             	lea    -0x1(%eax),%edx
 390:	89 55 10             	mov    %edx,0x10(%ebp)
 393:	85 c0                	test   %eax,%eax
 395:	7f dc                	jg     373 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 397:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39c:	b8 01 00 00 00       	mov    $0x1,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <exit>:
SYSCALL(exit)
 3a4:	b8 02 00 00 00       	mov    $0x2,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <wait>:
SYSCALL(wait)
 3ac:	b8 03 00 00 00       	mov    $0x3,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <pipe>:
SYSCALL(pipe)
 3b4:	b8 04 00 00 00       	mov    $0x4,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <read>:
SYSCALL(read)
 3bc:	b8 05 00 00 00       	mov    $0x5,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <write>:
SYSCALL(write)
 3c4:	b8 10 00 00 00       	mov    $0x10,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <close>:
SYSCALL(close)
 3cc:	b8 15 00 00 00       	mov    $0x15,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <kill>:
SYSCALL(kill)
 3d4:	b8 06 00 00 00       	mov    $0x6,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <exec>:
SYSCALL(exec)
 3dc:	b8 07 00 00 00       	mov    $0x7,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <open>:
SYSCALL(open)
 3e4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <mknod>:
SYSCALL(mknod)
 3ec:	b8 11 00 00 00       	mov    $0x11,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <unlink>:
SYSCALL(unlink)
 3f4:	b8 12 00 00 00       	mov    $0x12,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <fstat>:
SYSCALL(fstat)
 3fc:	b8 08 00 00 00       	mov    $0x8,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <link>:
SYSCALL(link)
 404:	b8 13 00 00 00       	mov    $0x13,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <mkdir>:
SYSCALL(mkdir)
 40c:	b8 14 00 00 00       	mov    $0x14,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <chdir>:
SYSCALL(chdir)
 414:	b8 09 00 00 00       	mov    $0x9,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <dup>:
SYSCALL(dup)
 41c:	b8 0a 00 00 00       	mov    $0xa,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <getpid>:
SYSCALL(getpid)
 424:	b8 0b 00 00 00       	mov    $0xb,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <sbrk>:
SYSCALL(sbrk)
 42c:	b8 0c 00 00 00       	mov    $0xc,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <sleep>:
SYSCALL(sleep)
 434:	b8 0d 00 00 00       	mov    $0xd,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <uptime>:
SYSCALL(uptime)
 43c:	b8 0e 00 00 00       	mov    $0xe,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <halt>:
SYSCALL(halt)
 444:	b8 16 00 00 00       	mov    $0x16,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <date>:
SYSCALL(date)      #p1
 44c:	b8 17 00 00 00       	mov    $0x17,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <getuid>:
SYSCALL(getuid)    #p2
 454:	b8 18 00 00 00       	mov    $0x18,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <getgid>:
SYSCALL(getgid)    #p2
 45c:	b8 19 00 00 00       	mov    $0x19,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <getppid>:
SYSCALL(getppid)   #p2
 464:	b8 1a 00 00 00       	mov    $0x1a,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <setuid>:
SYSCALL(setuid)    #p2
 46c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <setgid>:
SYSCALL(setgid)    #p2
 474:	b8 1c 00 00 00       	mov    $0x1c,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <getprocs>:
SYSCALL(getprocs)  #p2
 47c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <setpriority>:
SYSCALL(setpriority)
 484:	b8 1e 00 00 00       	mov    $0x1e,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	83 ec 18             	sub    $0x18,%esp
 492:	8b 45 0c             	mov    0xc(%ebp),%eax
 495:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 498:	83 ec 04             	sub    $0x4,%esp
 49b:	6a 01                	push   $0x1
 49d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a0:	50                   	push   %eax
 4a1:	ff 75 08             	pushl  0x8(%ebp)
 4a4:	e8 1b ff ff ff       	call   3c4 <write>
 4a9:	83 c4 10             	add    $0x10,%esp
}
 4ac:	90                   	nop
 4ad:	c9                   	leave  
 4ae:	c3                   	ret    

000004af <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4af:	55                   	push   %ebp
 4b0:	89 e5                	mov    %esp,%ebp
 4b2:	53                   	push   %ebx
 4b3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4bd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4c1:	74 17                	je     4da <printint+0x2b>
 4c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4c7:	79 11                	jns    4da <printint+0x2b>
    neg = 1;
 4c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d3:	f7 d8                	neg    %eax
 4d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d8:	eb 06                	jmp    4e0 <printint+0x31>
  } else {
    x = xx;
 4da:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4ea:	8d 41 01             	lea    0x1(%ecx),%eax
 4ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f6:	ba 00 00 00 00       	mov    $0x0,%edx
 4fb:	f7 f3                	div    %ebx
 4fd:	89 d0                	mov    %edx,%eax
 4ff:	0f b6 80 04 0c 00 00 	movzbl 0xc04(%eax),%eax
 506:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 50a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 50d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 510:	ba 00 00 00 00       	mov    $0x0,%edx
 515:	f7 f3                	div    %ebx
 517:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51e:	75 c7                	jne    4e7 <printint+0x38>
  if(neg)
 520:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 524:	74 2d                	je     553 <printint+0xa4>
    buf[i++] = '-';
 526:	8b 45 f4             	mov    -0xc(%ebp),%eax
 529:	8d 50 01             	lea    0x1(%eax),%edx
 52c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 52f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 534:	eb 1d                	jmp    553 <printint+0xa4>
    putc(fd, buf[i]);
 536:	8d 55 dc             	lea    -0x24(%ebp),%edx
 539:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53c:	01 d0                	add    %edx,%eax
 53e:	0f b6 00             	movzbl (%eax),%eax
 541:	0f be c0             	movsbl %al,%eax
 544:	83 ec 08             	sub    $0x8,%esp
 547:	50                   	push   %eax
 548:	ff 75 08             	pushl  0x8(%ebp)
 54b:	e8 3c ff ff ff       	call   48c <putc>
 550:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 553:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55b:	79 d9                	jns    536 <printint+0x87>
    putc(fd, buf[i]);
}
 55d:	90                   	nop
 55e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 561:	c9                   	leave  
 562:	c3                   	ret    

00000563 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 563:	55                   	push   %ebp
 564:	89 e5                	mov    %esp,%ebp
 566:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 569:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 570:	8d 45 0c             	lea    0xc(%ebp),%eax
 573:	83 c0 04             	add    $0x4,%eax
 576:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 579:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 580:	e9 59 01 00 00       	jmp    6de <printf+0x17b>
    c = fmt[i] & 0xff;
 585:	8b 55 0c             	mov    0xc(%ebp),%edx
 588:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58b:	01 d0                	add    %edx,%eax
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	0f be c0             	movsbl %al,%eax
 593:	25 ff 00 00 00       	and    $0xff,%eax
 598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 59b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 59f:	75 2c                	jne    5cd <printf+0x6a>
      if(c == '%'){
 5a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a5:	75 0c                	jne    5b3 <printf+0x50>
        state = '%';
 5a7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ae:	e9 27 01 00 00       	jmp    6da <printf+0x177>
      } else {
        putc(fd, c);
 5b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b6:	0f be c0             	movsbl %al,%eax
 5b9:	83 ec 08             	sub    $0x8,%esp
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 c7 fe ff ff       	call   48c <putc>
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	e9 0d 01 00 00       	jmp    6da <printf+0x177>
      }
    } else if(state == '%'){
 5cd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d1:	0f 85 03 01 00 00    	jne    6da <printf+0x177>
      if(c == 'd'){
 5d7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5db:	75 1e                	jne    5fb <printf+0x98>
        printint(fd, *ap, 10, 1);
 5dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	6a 01                	push   $0x1
 5e4:	6a 0a                	push   $0xa
 5e6:	50                   	push   %eax
 5e7:	ff 75 08             	pushl  0x8(%ebp)
 5ea:	e8 c0 fe ff ff       	call   4af <printint>
 5ef:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f6:	e9 d8 00 00 00       	jmp    6d3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5fb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ff:	74 06                	je     607 <printf+0xa4>
 601:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 605:	75 1e                	jne    625 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 607:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	6a 00                	push   $0x0
 60e:	6a 10                	push   $0x10
 610:	50                   	push   %eax
 611:	ff 75 08             	pushl  0x8(%ebp)
 614:	e8 96 fe ff ff       	call   4af <printint>
 619:	83 c4 10             	add    $0x10,%esp
        ap++;
 61c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 620:	e9 ae 00 00 00       	jmp    6d3 <printf+0x170>
      } else if(c == 's'){
 625:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 629:	75 43                	jne    66e <printf+0x10b>
        s = (char*)*ap;
 62b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 633:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 63b:	75 25                	jne    662 <printf+0xff>
          s = "(null)";
 63d:	c7 45 f4 af 09 00 00 	movl   $0x9af,-0xc(%ebp)
        while(*s != 0){
 644:	eb 1c                	jmp    662 <printf+0xff>
          putc(fd, *s);
 646:	8b 45 f4             	mov    -0xc(%ebp),%eax
 649:	0f b6 00             	movzbl (%eax),%eax
 64c:	0f be c0             	movsbl %al,%eax
 64f:	83 ec 08             	sub    $0x8,%esp
 652:	50                   	push   %eax
 653:	ff 75 08             	pushl  0x8(%ebp)
 656:	e8 31 fe ff ff       	call   48c <putc>
 65b:	83 c4 10             	add    $0x10,%esp
          s++;
 65e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 662:	8b 45 f4             	mov    -0xc(%ebp),%eax
 665:	0f b6 00             	movzbl (%eax),%eax
 668:	84 c0                	test   %al,%al
 66a:	75 da                	jne    646 <printf+0xe3>
 66c:	eb 65                	jmp    6d3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 672:	75 1d                	jne    691 <printf+0x12e>
        putc(fd, *ap);
 674:	8b 45 e8             	mov    -0x18(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	0f be c0             	movsbl %al,%eax
 67c:	83 ec 08             	sub    $0x8,%esp
 67f:	50                   	push   %eax
 680:	ff 75 08             	pushl  0x8(%ebp)
 683:	e8 04 fe ff ff       	call   48c <putc>
 688:	83 c4 10             	add    $0x10,%esp
        ap++;
 68b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68f:	eb 42                	jmp    6d3 <printf+0x170>
      } else if(c == '%'){
 691:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 695:	75 17                	jne    6ae <printf+0x14b>
        putc(fd, c);
 697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69a:	0f be c0             	movsbl %al,%eax
 69d:	83 ec 08             	sub    $0x8,%esp
 6a0:	50                   	push   %eax
 6a1:	ff 75 08             	pushl  0x8(%ebp)
 6a4:	e8 e3 fd ff ff       	call   48c <putc>
 6a9:	83 c4 10             	add    $0x10,%esp
 6ac:	eb 25                	jmp    6d3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ae:	83 ec 08             	sub    $0x8,%esp
 6b1:	6a 25                	push   $0x25
 6b3:	ff 75 08             	pushl  0x8(%ebp)
 6b6:	e8 d1 fd ff ff       	call   48c <putc>
 6bb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c1:	0f be c0             	movsbl %al,%eax
 6c4:	83 ec 08             	sub    $0x8,%esp
 6c7:	50                   	push   %eax
 6c8:	ff 75 08             	pushl  0x8(%ebp)
 6cb:	e8 bc fd ff ff       	call   48c <putc>
 6d0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6de:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e4:	01 d0                	add    %edx,%eax
 6e6:	0f b6 00             	movzbl (%eax),%eax
 6e9:	84 c0                	test   %al,%al
 6eb:	0f 85 94 fe ff ff    	jne    585 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f1:	90                   	nop
 6f2:	c9                   	leave  
 6f3:	c3                   	ret    

000006f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f4:	55                   	push   %ebp
 6f5:	89 e5                	mov    %esp,%ebp
 6f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fa:	8b 45 08             	mov    0x8(%ebp),%eax
 6fd:	83 e8 08             	sub    $0x8,%eax
 700:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 703:	a1 20 0c 00 00       	mov    0xc20,%eax
 708:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70b:	eb 24                	jmp    731 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 715:	77 12                	ja     729 <free+0x35>
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71d:	77 24                	ja     743 <free+0x4f>
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 727:	77 1a                	ja     743 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 00                	mov    (%eax),%eax
 72e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 737:	76 d4                	jbe    70d <free+0x19>
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 00                	mov    (%eax),%eax
 73e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 741:	76 ca                	jbe    70d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	8b 40 04             	mov    0x4(%eax),%eax
 749:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	01 c2                	add    %eax,%edx
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	39 c2                	cmp    %eax,%edx
 75c:	75 24                	jne    782 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	8b 50 04             	mov    0x4(%eax),%edx
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	8b 40 04             	mov    0x4(%eax),%eax
 76c:	01 c2                	add    %eax,%edx
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	8b 10                	mov    (%eax),%edx
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	89 10                	mov    %edx,(%eax)
 780:	eb 0a                	jmp    78c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	8b 10                	mov    (%eax),%edx
 787:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 40 04             	mov    0x4(%eax),%eax
 792:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	01 d0                	add    %edx,%eax
 79e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a1:	75 20                	jne    7c3 <free+0xcf>
    p->s.size += bp->s.size;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	8b 50 04             	mov    0x4(%eax),%edx
 7a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ac:	8b 40 04             	mov    0x4(%eax),%eax
 7af:	01 c2                	add    %eax,%edx
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bf:	89 10                	mov    %edx,(%eax)
 7c1:	eb 08                	jmp    7cb <free+0xd7>
  } else
    p->s.ptr = bp;
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c9:	89 10                	mov    %edx,(%eax)
  freep = p;
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	a3 20 0c 00 00       	mov    %eax,0xc20
}
 7d3:	90                   	nop
 7d4:	c9                   	leave  
 7d5:	c3                   	ret    

000007d6 <morecore>:

static Header*
morecore(uint nu)
{
 7d6:	55                   	push   %ebp
 7d7:	89 e5                	mov    %esp,%ebp
 7d9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7dc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7e3:	77 07                	ja     7ec <morecore+0x16>
    nu = 4096;
 7e5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ec:	8b 45 08             	mov    0x8(%ebp),%eax
 7ef:	c1 e0 03             	shl    $0x3,%eax
 7f2:	83 ec 0c             	sub    $0xc,%esp
 7f5:	50                   	push   %eax
 7f6:	e8 31 fc ff ff       	call   42c <sbrk>
 7fb:	83 c4 10             	add    $0x10,%esp
 7fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 801:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 805:	75 07                	jne    80e <morecore+0x38>
    return 0;
 807:	b8 00 00 00 00       	mov    $0x0,%eax
 80c:	eb 26                	jmp    834 <morecore+0x5e>
  hp = (Header*)p;
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 814:	8b 45 f0             	mov    -0x10(%ebp),%eax
 817:	8b 55 08             	mov    0x8(%ebp),%edx
 81a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	83 c0 08             	add    $0x8,%eax
 823:	83 ec 0c             	sub    $0xc,%esp
 826:	50                   	push   %eax
 827:	e8 c8 fe ff ff       	call   6f4 <free>
 82c:	83 c4 10             	add    $0x10,%esp
  return freep;
 82f:	a1 20 0c 00 00       	mov    0xc20,%eax
}
 834:	c9                   	leave  
 835:	c3                   	ret    

00000836 <malloc>:

void*
malloc(uint nbytes)
{
 836:	55                   	push   %ebp
 837:	89 e5                	mov    %esp,%ebp
 839:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83c:	8b 45 08             	mov    0x8(%ebp),%eax
 83f:	83 c0 07             	add    $0x7,%eax
 842:	c1 e8 03             	shr    $0x3,%eax
 845:	83 c0 01             	add    $0x1,%eax
 848:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 84b:	a1 20 0c 00 00       	mov    0xc20,%eax
 850:	89 45 f0             	mov    %eax,-0x10(%ebp)
 853:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 857:	75 23                	jne    87c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 859:	c7 45 f0 18 0c 00 00 	movl   $0xc18,-0x10(%ebp)
 860:	8b 45 f0             	mov    -0x10(%ebp),%eax
 863:	a3 20 0c 00 00       	mov    %eax,0xc20
 868:	a1 20 0c 00 00       	mov    0xc20,%eax
 86d:	a3 18 0c 00 00       	mov    %eax,0xc18
    base.s.size = 0;
 872:	c7 05 1c 0c 00 00 00 	movl   $0x0,0xc1c
 879:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	8b 40 04             	mov    0x4(%eax),%eax
 88a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 88d:	72 4d                	jb     8dc <malloc+0xa6>
      if(p->s.size == nunits)
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 898:	75 0c                	jne    8a6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	8b 10                	mov    (%eax),%edx
 89f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a2:	89 10                	mov    %edx,(%eax)
 8a4:	eb 26                	jmp    8cc <malloc+0x96>
      else {
        p->s.size -= nunits;
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	8b 40 04             	mov    0x4(%eax),%eax
 8ac:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8af:	89 c2                	mov    %eax,%edx
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	c1 e0 03             	shl    $0x3,%eax
 8c0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8c9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cf:	a3 20 0c 00 00       	mov    %eax,0xc20
      return (void*)(p + 1);
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	83 c0 08             	add    $0x8,%eax
 8da:	eb 3b                	jmp    917 <malloc+0xe1>
    }
    if(p == freep)
 8dc:	a1 20 0c 00 00       	mov    0xc20,%eax
 8e1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8e4:	75 1e                	jne    904 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8e6:	83 ec 0c             	sub    $0xc,%esp
 8e9:	ff 75 ec             	pushl  -0x14(%ebp)
 8ec:	e8 e5 fe ff ff       	call   7d6 <morecore>
 8f1:	83 c4 10             	add    $0x10,%esp
 8f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8fb:	75 07                	jne    904 <malloc+0xce>
        return 0;
 8fd:	b8 00 00 00 00       	mov    $0x0,%eax
 902:	eb 13                	jmp    917 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 904:	8b 45 f4             	mov    -0xc(%ebp),%eax
 907:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 912:	e9 6d ff ff ff       	jmp    884 <malloc+0x4e>
}
 917:	c9                   	leave  
 918:	c3                   	ret    
