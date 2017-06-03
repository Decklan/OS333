
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
  21:	68 c0 09 00 00       	push   $0x9c0
  26:	6a 02                	push   $0x2
  28:	e8 dc 05 00 00       	call   609 <printf>
  2d:	83 c4 10             	add    $0x10,%esp
    exit();
  30:	e8 fd 03 00 00       	call   432 <exit>
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
  6c:	e8 a1 04 00 00       	call   512 <setpriority>
  71:	83 c4 10             	add    $0x10,%esp
  74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (rc == -1) {
  77:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  7b:	75 17                	jne    94 <main+0x94>
    printf(2, "INVALID PID.\n");
  7d:	83 ec 08             	sub    $0x8,%esp
  80:	68 e9 09 00 00       	push   $0x9e9
  85:	6a 02                	push   $0x2
  87:	e8 7d 05 00 00       	call   609 <printf>
  8c:	83 c4 10             	add    $0x10,%esp
    exit();
  8f:	e8 9e 03 00 00       	call   432 <exit>
  } else if (rc == 0) {
  94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  98:	75 17                	jne    b1 <main+0xb1>
    printf(1, "Success!\n");
  9a:	83 ec 08             	sub    $0x8,%esp
  9d:	68 f7 09 00 00       	push   $0x9f7
  a2:	6a 01                	push   $0x1
  a4:	e8 60 05 00 00       	call   609 <printf>
  a9:	83 c4 10             	add    $0x10,%esp
    exit();
  ac:	e8 81 03 00 00       	call   432 <exit>
  } else if (rc == 1){
  b1:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  b5:	75 1a                	jne    d1 <main+0xd1>
    printf(1, "Process already has priority %d.\n", prio);
  b7:	83 ec 04             	sub    $0x4,%esp
  ba:	ff 75 f0             	pushl  -0x10(%ebp)
  bd:	68 04 0a 00 00       	push   $0xa04
  c2:	6a 01                	push   $0x1
  c4:	e8 40 05 00 00       	call   609 <printf>
  c9:	83 c4 10             	add    $0x10,%esp
    exit();
  cc:	e8 61 03 00 00       	call   432 <exit>
  } else if (rc == -2) {
  d1:	83 7d ec fe          	cmpl   $0xfffffffe,-0x14(%ebp)
  d5:	75 17                	jne    ee <main+0xee>
    printf(2, "INVALID PRIORITY VALUE.\n");
  d7:	83 ec 08             	sub    $0x8,%esp
  da:	68 26 0a 00 00       	push   $0xa26
  df:	6a 02                	push   $0x2
  e1:	e8 23 05 00 00       	call   609 <printf>
  e6:	83 c4 10             	add    $0x10,%esp
    exit();
  e9:	e8 44 03 00 00       	call   432 <exit>
  } else {
    printf(2, "PID: %d not found.\n", pid);
  ee:	83 ec 04             	sub    $0x4,%esp
  f1:	ff 75 f4             	pushl  -0xc(%ebp)
  f4:	68 3f 0a 00 00       	push   $0xa3f
  f9:	6a 02                	push   $0x2
  fb:	e8 09 05 00 00       	call   609 <printf>
 100:	83 c4 10             	add    $0x10,%esp
    exit();
 103:	e8 2a 03 00 00       	call   432 <exit>

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
 22b:	e8 1a 02 00 00       	call   44a <read>
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
 28e:	e8 df 01 00 00       	call   472 <open>
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
 2af:	e8 d6 01 00 00       	call   48a <fstat>
 2b4:	83 c4 10             	add    $0x10,%esp
 2b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ba:	83 ec 0c             	sub    $0xc,%esp
 2bd:	ff 75 f4             	pushl  -0xc(%ebp)
 2c0:	e8 95 01 00 00       	call   45a <close>
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

0000035f <atoo>:

int
atoo(const char *s)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 365:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 36c:	eb 04                	jmp    372 <atoo+0x13>
 36e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	0f b6 00             	movzbl (%eax),%eax
 378:	3c 20                	cmp    $0x20,%al
 37a:	74 f2                	je     36e <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	0f b6 00             	movzbl (%eax),%eax
 382:	3c 2d                	cmp    $0x2d,%al
 384:	75 07                	jne    38d <atoo+0x2e>
 386:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38b:	eb 05                	jmp    392 <atoo+0x33>
 38d:	b8 01 00 00 00       	mov    $0x1,%eax
 392:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	0f b6 00             	movzbl (%eax),%eax
 39b:	3c 2b                	cmp    $0x2b,%al
 39d:	74 0a                	je     3a9 <atoo+0x4a>
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	0f b6 00             	movzbl (%eax),%eax
 3a5:	3c 2d                	cmp    $0x2d,%al
 3a7:	75 27                	jne    3d0 <atoo+0x71>
    s++;
 3a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3ad:	eb 21                	jmp    3d0 <atoo+0x71>
    n = n*8 + *s++ - '0';
 3af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	8d 50 01             	lea    0x1(%eax),%edx
 3bf:	89 55 08             	mov    %edx,0x8(%ebp)
 3c2:	0f b6 00             	movzbl (%eax),%eax
 3c5:	0f be c0             	movsbl %al,%eax
 3c8:	01 c8                	add    %ecx,%eax
 3ca:	83 e8 30             	sub    $0x30,%eax
 3cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	0f b6 00             	movzbl (%eax),%eax
 3d6:	3c 2f                	cmp    $0x2f,%al
 3d8:	7e 0a                	jle    3e4 <atoo+0x85>
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	0f b6 00             	movzbl (%eax),%eax
 3e0:	3c 37                	cmp    $0x37,%al
 3e2:	7e cb                	jle    3af <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3e7:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3eb:	c9                   	leave  
 3ec:	c3                   	ret    

000003ed <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3ff:	eb 17                	jmp    418 <memmove+0x2b>
    *dst++ = *src++;
 401:	8b 45 fc             	mov    -0x4(%ebp),%eax
 404:	8d 50 01             	lea    0x1(%eax),%edx
 407:	89 55 fc             	mov    %edx,-0x4(%ebp)
 40a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 40d:	8d 4a 01             	lea    0x1(%edx),%ecx
 410:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 413:	0f b6 12             	movzbl (%edx),%edx
 416:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 418:	8b 45 10             	mov    0x10(%ebp),%eax
 41b:	8d 50 ff             	lea    -0x1(%eax),%edx
 41e:	89 55 10             	mov    %edx,0x10(%ebp)
 421:	85 c0                	test   %eax,%eax
 423:	7f dc                	jg     401 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 425:	8b 45 08             	mov    0x8(%ebp),%eax
}
 428:	c9                   	leave  
 429:	c3                   	ret    

0000042a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42a:	b8 01 00 00 00       	mov    $0x1,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <exit>:
SYSCALL(exit)
 432:	b8 02 00 00 00       	mov    $0x2,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <wait>:
SYSCALL(wait)
 43a:	b8 03 00 00 00       	mov    $0x3,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <pipe>:
SYSCALL(pipe)
 442:	b8 04 00 00 00       	mov    $0x4,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <read>:
SYSCALL(read)
 44a:	b8 05 00 00 00       	mov    $0x5,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <write>:
SYSCALL(write)
 452:	b8 10 00 00 00       	mov    $0x10,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <close>:
SYSCALL(close)
 45a:	b8 15 00 00 00       	mov    $0x15,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <kill>:
SYSCALL(kill)
 462:	b8 06 00 00 00       	mov    $0x6,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <exec>:
SYSCALL(exec)
 46a:	b8 07 00 00 00       	mov    $0x7,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <open>:
SYSCALL(open)
 472:	b8 0f 00 00 00       	mov    $0xf,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <mknod>:
SYSCALL(mknod)
 47a:	b8 11 00 00 00       	mov    $0x11,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <unlink>:
SYSCALL(unlink)
 482:	b8 12 00 00 00       	mov    $0x12,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <fstat>:
SYSCALL(fstat)
 48a:	b8 08 00 00 00       	mov    $0x8,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <link>:
SYSCALL(link)
 492:	b8 13 00 00 00       	mov    $0x13,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <mkdir>:
SYSCALL(mkdir)
 49a:	b8 14 00 00 00       	mov    $0x14,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <chdir>:
SYSCALL(chdir)
 4a2:	b8 09 00 00 00       	mov    $0x9,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <dup>:
SYSCALL(dup)
 4aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <getpid>:
SYSCALL(getpid)
 4b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <sbrk>:
SYSCALL(sbrk)
 4ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <sleep>:
SYSCALL(sleep)
 4c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <uptime>:
SYSCALL(uptime)
 4ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <halt>:
SYSCALL(halt)
 4d2:	b8 16 00 00 00       	mov    $0x16,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <date>:
SYSCALL(date)        #p1
 4da:	b8 17 00 00 00       	mov    $0x17,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <getuid>:
SYSCALL(getuid)      #p2
 4e2:	b8 18 00 00 00       	mov    $0x18,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <getgid>:
SYSCALL(getgid)      #p2
 4ea:	b8 19 00 00 00       	mov    $0x19,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <getppid>:
SYSCALL(getppid)     #p2
 4f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <setuid>:
SYSCALL(setuid)      #p2
 4fa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <setgid>:
SYSCALL(setgid)      #p2
 502:	b8 1c 00 00 00       	mov    $0x1c,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <getprocs>:
SYSCALL(getprocs)    #p2
 50a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <setpriority>:
SYSCALL(setpriority) #p4
 512:	b8 1e 00 00 00       	mov    $0x1e,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <chmod>:
SYSCALL(chmod)       #p5
 51a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <chown>:
SYSCALL(chown)       #p5
 522:	b8 20 00 00 00       	mov    $0x20,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <chgrp>:
SYSCALL(chgrp)       #p5
 52a:	b8 21 00 00 00       	mov    $0x21,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 532:	55                   	push   %ebp
 533:	89 e5                	mov    %esp,%ebp
 535:	83 ec 18             	sub    $0x18,%esp
 538:	8b 45 0c             	mov    0xc(%ebp),%eax
 53b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 53e:	83 ec 04             	sub    $0x4,%esp
 541:	6a 01                	push   $0x1
 543:	8d 45 f4             	lea    -0xc(%ebp),%eax
 546:	50                   	push   %eax
 547:	ff 75 08             	pushl  0x8(%ebp)
 54a:	e8 03 ff ff ff       	call   452 <write>
 54f:	83 c4 10             	add    $0x10,%esp
}
 552:	90                   	nop
 553:	c9                   	leave  
 554:	c3                   	ret    

00000555 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 555:	55                   	push   %ebp
 556:	89 e5                	mov    %esp,%ebp
 558:	53                   	push   %ebx
 559:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 55c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 563:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 567:	74 17                	je     580 <printint+0x2b>
 569:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 56d:	79 11                	jns    580 <printint+0x2b>
    neg = 1;
 56f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 576:	8b 45 0c             	mov    0xc(%ebp),%eax
 579:	f7 d8                	neg    %eax
 57b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57e:	eb 06                	jmp    586 <printint+0x31>
  } else {
    x = xx;
 580:	8b 45 0c             	mov    0xc(%ebp),%eax
 583:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 586:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 58d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 590:	8d 41 01             	lea    0x1(%ecx),%eax
 593:	89 45 f4             	mov    %eax,-0xc(%ebp)
 596:	8b 5d 10             	mov    0x10(%ebp),%ebx
 599:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59c:	ba 00 00 00 00       	mov    $0x0,%edx
 5a1:	f7 f3                	div    %ebx
 5a3:	89 d0                	mov    %edx,%eax
 5a5:	0f b6 80 c8 0c 00 00 	movzbl 0xcc8(%eax),%eax
 5ac:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b6:	ba 00 00 00 00       	mov    $0x0,%edx
 5bb:	f7 f3                	div    %ebx
 5bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c4:	75 c7                	jne    58d <printint+0x38>
  if(neg)
 5c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ca:	74 2d                	je     5f9 <printint+0xa4>
    buf[i++] = '-';
 5cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cf:	8d 50 01             	lea    0x1(%eax),%edx
 5d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5d5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5da:	eb 1d                	jmp    5f9 <printint+0xa4>
    putc(fd, buf[i]);
 5dc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e2:	01 d0                	add    %edx,%eax
 5e4:	0f b6 00             	movzbl (%eax),%eax
 5e7:	0f be c0             	movsbl %al,%eax
 5ea:	83 ec 08             	sub    $0x8,%esp
 5ed:	50                   	push   %eax
 5ee:	ff 75 08             	pushl  0x8(%ebp)
 5f1:	e8 3c ff ff ff       	call   532 <putc>
 5f6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5f9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 601:	79 d9                	jns    5dc <printint+0x87>
    putc(fd, buf[i]);
}
 603:	90                   	nop
 604:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 607:	c9                   	leave  
 608:	c3                   	ret    

00000609 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 609:	55                   	push   %ebp
 60a:	89 e5                	mov    %esp,%ebp
 60c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 60f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 616:	8d 45 0c             	lea    0xc(%ebp),%eax
 619:	83 c0 04             	add    $0x4,%eax
 61c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 61f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 626:	e9 59 01 00 00       	jmp    784 <printf+0x17b>
    c = fmt[i] & 0xff;
 62b:	8b 55 0c             	mov    0xc(%ebp),%edx
 62e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 631:	01 d0                	add    %edx,%eax
 633:	0f b6 00             	movzbl (%eax),%eax
 636:	0f be c0             	movsbl %al,%eax
 639:	25 ff 00 00 00       	and    $0xff,%eax
 63e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 641:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 645:	75 2c                	jne    673 <printf+0x6a>
      if(c == '%'){
 647:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64b:	75 0c                	jne    659 <printf+0x50>
        state = '%';
 64d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 654:	e9 27 01 00 00       	jmp    780 <printf+0x177>
      } else {
        putc(fd, c);
 659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	83 ec 08             	sub    $0x8,%esp
 662:	50                   	push   %eax
 663:	ff 75 08             	pushl  0x8(%ebp)
 666:	e8 c7 fe ff ff       	call   532 <putc>
 66b:	83 c4 10             	add    $0x10,%esp
 66e:	e9 0d 01 00 00       	jmp    780 <printf+0x177>
      }
    } else if(state == '%'){
 673:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 677:	0f 85 03 01 00 00    	jne    780 <printf+0x177>
      if(c == 'd'){
 67d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 681:	75 1e                	jne    6a1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 683:	8b 45 e8             	mov    -0x18(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	6a 01                	push   $0x1
 68a:	6a 0a                	push   $0xa
 68c:	50                   	push   %eax
 68d:	ff 75 08             	pushl  0x8(%ebp)
 690:	e8 c0 fe ff ff       	call   555 <printint>
 695:	83 c4 10             	add    $0x10,%esp
        ap++;
 698:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69c:	e9 d8 00 00 00       	jmp    779 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6a1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6a5:	74 06                	je     6ad <printf+0xa4>
 6a7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6ab:	75 1e                	jne    6cb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	6a 00                	push   $0x0
 6b4:	6a 10                	push   $0x10
 6b6:	50                   	push   %eax
 6b7:	ff 75 08             	pushl  0x8(%ebp)
 6ba:	e8 96 fe ff ff       	call   555 <printint>
 6bf:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c6:	e9 ae 00 00 00       	jmp    779 <printf+0x170>
      } else if(c == 's'){
 6cb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6cf:	75 43                	jne    714 <printf+0x10b>
        s = (char*)*ap;
 6d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e1:	75 25                	jne    708 <printf+0xff>
          s = "(null)";
 6e3:	c7 45 f4 53 0a 00 00 	movl   $0xa53,-0xc(%ebp)
        while(*s != 0){
 6ea:	eb 1c                	jmp    708 <printf+0xff>
          putc(fd, *s);
 6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ef:	0f b6 00             	movzbl (%eax),%eax
 6f2:	0f be c0             	movsbl %al,%eax
 6f5:	83 ec 08             	sub    $0x8,%esp
 6f8:	50                   	push   %eax
 6f9:	ff 75 08             	pushl  0x8(%ebp)
 6fc:	e8 31 fe ff ff       	call   532 <putc>
 701:	83 c4 10             	add    $0x10,%esp
          s++;
 704:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 708:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70b:	0f b6 00             	movzbl (%eax),%eax
 70e:	84 c0                	test   %al,%al
 710:	75 da                	jne    6ec <printf+0xe3>
 712:	eb 65                	jmp    779 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 714:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 718:	75 1d                	jne    737 <printf+0x12e>
        putc(fd, *ap);
 71a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	0f be c0             	movsbl %al,%eax
 722:	83 ec 08             	sub    $0x8,%esp
 725:	50                   	push   %eax
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 04 fe ff ff       	call   532 <putc>
 72e:	83 c4 10             	add    $0x10,%esp
        ap++;
 731:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 735:	eb 42                	jmp    779 <printf+0x170>
      } else if(c == '%'){
 737:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73b:	75 17                	jne    754 <printf+0x14b>
        putc(fd, c);
 73d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 740:	0f be c0             	movsbl %al,%eax
 743:	83 ec 08             	sub    $0x8,%esp
 746:	50                   	push   %eax
 747:	ff 75 08             	pushl  0x8(%ebp)
 74a:	e8 e3 fd ff ff       	call   532 <putc>
 74f:	83 c4 10             	add    $0x10,%esp
 752:	eb 25                	jmp    779 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 754:	83 ec 08             	sub    $0x8,%esp
 757:	6a 25                	push   $0x25
 759:	ff 75 08             	pushl  0x8(%ebp)
 75c:	e8 d1 fd ff ff       	call   532 <putc>
 761:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 767:	0f be c0             	movsbl %al,%eax
 76a:	83 ec 08             	sub    $0x8,%esp
 76d:	50                   	push   %eax
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 bc fd ff ff       	call   532 <putc>
 776:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 779:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 780:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 784:	8b 55 0c             	mov    0xc(%ebp),%edx
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	01 d0                	add    %edx,%eax
 78c:	0f b6 00             	movzbl (%eax),%eax
 78f:	84 c0                	test   %al,%al
 791:	0f 85 94 fe ff ff    	jne    62b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 797:	90                   	nop
 798:	c9                   	leave  
 799:	c3                   	ret    

0000079a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79a:	55                   	push   %ebp
 79b:	89 e5                	mov    %esp,%ebp
 79d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a0:	8b 45 08             	mov    0x8(%ebp),%eax
 7a3:	83 e8 08             	sub    $0x8,%eax
 7a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a9:	a1 e4 0c 00 00       	mov    0xce4,%eax
 7ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b1:	eb 24                	jmp    7d7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bb:	77 12                	ja     7cf <free+0x35>
 7bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c3:	77 24                	ja     7e9 <free+0x4f>
 7c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c8:	8b 00                	mov    (%eax),%eax
 7ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cd:	77 1a                	ja     7e9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	8b 00                	mov    (%eax),%eax
 7d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7dd:	76 d4                	jbe    7b3 <free+0x19>
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	8b 00                	mov    (%eax),%eax
 7e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e7:	76 ca                	jbe    7b3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f9:	01 c2                	add    %eax,%edx
 7fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fe:	8b 00                	mov    (%eax),%eax
 800:	39 c2                	cmp    %eax,%edx
 802:	75 24                	jne    828 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 804:	8b 45 f8             	mov    -0x8(%ebp),%eax
 807:	8b 50 04             	mov    0x4(%eax),%edx
 80a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80d:	8b 00                	mov    (%eax),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	01 c2                	add    %eax,%edx
 814:	8b 45 f8             	mov    -0x8(%ebp),%eax
 817:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 81a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	8b 10                	mov    (%eax),%edx
 821:	8b 45 f8             	mov    -0x8(%ebp),%eax
 824:	89 10                	mov    %edx,(%eax)
 826:	eb 0a                	jmp    832 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 10                	mov    (%eax),%edx
 82d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 830:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 832:	8b 45 fc             	mov    -0x4(%ebp),%eax
 835:	8b 40 04             	mov    0x4(%eax),%eax
 838:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 83f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 842:	01 d0                	add    %edx,%eax
 844:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 847:	75 20                	jne    869 <free+0xcf>
    p->s.size += bp->s.size;
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	8b 50 04             	mov    0x4(%eax),%edx
 84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 852:	8b 40 04             	mov    0x4(%eax),%eax
 855:	01 c2                	add    %eax,%edx
 857:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 85d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 860:	8b 10                	mov    (%eax),%edx
 862:	8b 45 fc             	mov    -0x4(%ebp),%eax
 865:	89 10                	mov    %edx,(%eax)
 867:	eb 08                	jmp    871 <free+0xd7>
  } else
    p->s.ptr = bp;
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 86f:	89 10                	mov    %edx,(%eax)
  freep = p;
 871:	8b 45 fc             	mov    -0x4(%ebp),%eax
 874:	a3 e4 0c 00 00       	mov    %eax,0xce4
}
 879:	90                   	nop
 87a:	c9                   	leave  
 87b:	c3                   	ret    

0000087c <morecore>:

static Header*
morecore(uint nu)
{
 87c:	55                   	push   %ebp
 87d:	89 e5                	mov    %esp,%ebp
 87f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 882:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 889:	77 07                	ja     892 <morecore+0x16>
    nu = 4096;
 88b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 892:	8b 45 08             	mov    0x8(%ebp),%eax
 895:	c1 e0 03             	shl    $0x3,%eax
 898:	83 ec 0c             	sub    $0xc,%esp
 89b:	50                   	push   %eax
 89c:	e8 19 fc ff ff       	call   4ba <sbrk>
 8a1:	83 c4 10             	add    $0x10,%esp
 8a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8a7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8ab:	75 07                	jne    8b4 <morecore+0x38>
    return 0;
 8ad:	b8 00 00 00 00       	mov    $0x0,%eax
 8b2:	eb 26                	jmp    8da <morecore+0x5e>
  hp = (Header*)p;
 8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	8b 55 08             	mov    0x8(%ebp),%edx
 8c0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c6:	83 c0 08             	add    $0x8,%eax
 8c9:	83 ec 0c             	sub    $0xc,%esp
 8cc:	50                   	push   %eax
 8cd:	e8 c8 fe ff ff       	call   79a <free>
 8d2:	83 c4 10             	add    $0x10,%esp
  return freep;
 8d5:	a1 e4 0c 00 00       	mov    0xce4,%eax
}
 8da:	c9                   	leave  
 8db:	c3                   	ret    

000008dc <malloc>:

void*
malloc(uint nbytes)
{
 8dc:	55                   	push   %ebp
 8dd:	89 e5                	mov    %esp,%ebp
 8df:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e2:	8b 45 08             	mov    0x8(%ebp),%eax
 8e5:	83 c0 07             	add    $0x7,%eax
 8e8:	c1 e8 03             	shr    $0x3,%eax
 8eb:	83 c0 01             	add    $0x1,%eax
 8ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8f1:	a1 e4 0c 00 00       	mov    0xce4,%eax
 8f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8fd:	75 23                	jne    922 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8ff:	c7 45 f0 dc 0c 00 00 	movl   $0xcdc,-0x10(%ebp)
 906:	8b 45 f0             	mov    -0x10(%ebp),%eax
 909:	a3 e4 0c 00 00       	mov    %eax,0xce4
 90e:	a1 e4 0c 00 00       	mov    0xce4,%eax
 913:	a3 dc 0c 00 00       	mov    %eax,0xcdc
    base.s.size = 0;
 918:	c7 05 e0 0c 00 00 00 	movl   $0x0,0xce0
 91f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 922:	8b 45 f0             	mov    -0x10(%ebp),%eax
 925:	8b 00                	mov    (%eax),%eax
 927:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 92a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92d:	8b 40 04             	mov    0x4(%eax),%eax
 930:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 933:	72 4d                	jb     982 <malloc+0xa6>
      if(p->s.size == nunits)
 935:	8b 45 f4             	mov    -0xc(%ebp),%eax
 938:	8b 40 04             	mov    0x4(%eax),%eax
 93b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93e:	75 0c                	jne    94c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	8b 10                	mov    (%eax),%edx
 945:	8b 45 f0             	mov    -0x10(%ebp),%eax
 948:	89 10                	mov    %edx,(%eax)
 94a:	eb 26                	jmp    972 <malloc+0x96>
      else {
        p->s.size -= nunits;
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	8b 40 04             	mov    0x4(%eax),%eax
 952:	2b 45 ec             	sub    -0x14(%ebp),%eax
 955:	89 c2                	mov    %eax,%edx
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 960:	8b 40 04             	mov    0x4(%eax),%eax
 963:	c1 e0 03             	shl    $0x3,%eax
 966:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 969:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 96f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 972:	8b 45 f0             	mov    -0x10(%ebp),%eax
 975:	a3 e4 0c 00 00       	mov    %eax,0xce4
      return (void*)(p + 1);
 97a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97d:	83 c0 08             	add    $0x8,%eax
 980:	eb 3b                	jmp    9bd <malloc+0xe1>
    }
    if(p == freep)
 982:	a1 e4 0c 00 00       	mov    0xce4,%eax
 987:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 98a:	75 1e                	jne    9aa <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 98c:	83 ec 0c             	sub    $0xc,%esp
 98f:	ff 75 ec             	pushl  -0x14(%ebp)
 992:	e8 e5 fe ff ff       	call   87c <morecore>
 997:	83 c4 10             	add    $0x10,%esp
 99a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 99d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a1:	75 07                	jne    9aa <malloc+0xce>
        return 0;
 9a3:	b8 00 00 00 00       	mov    $0x0,%eax
 9a8:	eb 13                	jmp    9bd <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b3:	8b 00                	mov    (%eax),%eax
 9b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9b8:	e9 6d ff ff ff       	jmp    92a <malloc+0x4e>
}
 9bd:	c9                   	leave  
 9be:	c3                   	ret    
