
_chmod:     file format elf32-i386


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
  uint imode = 0;
  14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char *mode = 0;
  1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  char *file = 0;
  22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  if (argc != 3) {
  29:	83 3b 03             	cmpl   $0x3,(%ebx)
  2c:	74 17                	je     45 <main+0x45>
    printf(2, "ERROR: chmod expects a MODE and a TARGET.\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 b0 0a 00 00       	push   $0xab0
  36:	6a 02                	push   $0x2
  38:	e8 bc 06 00 00       	call   6f9 <printf>
  3d:	83 c4 10             	add    $0x10,%esp
    exit();
  40:	e8 dd 04 00 00       	call   522 <exit>
  }

  mode = argv[1];
  45:	8b 43 04             	mov    0x4(%ebx),%eax
  48:	8b 40 04             	mov    0x4(%eax),%eax
  4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (strlen(mode) != 4) {
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	ff 75 f0             	pushl  -0x10(%ebp)
  54:	e8 34 02 00 00       	call   28d <strlen>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	83 f8 04             	cmp    $0x4,%eax
  5f:	74 17                	je     78 <main+0x78>
    printf(2, "ERROR: chmod expects a MODE of length 4.\n");
  61:	83 ec 08             	sub    $0x8,%esp
  64:	68 dc 0a 00 00       	push   $0xadc
  69:	6a 02                	push   $0x2
  6b:	e8 89 06 00 00       	call   6f9 <printf>
  70:	83 c4 10             	add    $0x10,%esp
    exit();
  73:	e8 aa 04 00 00       	call   522 <exit>
  }

  file = argv[2];
  78:	8b 43 04             	mov    0x4(%ebx),%eax
  7b:	8b 40 08             	mov    0x8(%eax),%eax
  7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (strlen(file) < 1 || !file) {
  81:	83 ec 0c             	sub    $0xc,%esp
  84:	ff 75 ec             	pushl  -0x14(%ebp)
  87:	e8 01 02 00 00       	call   28d <strlen>
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	85 c0                	test   %eax,%eax
  91:	74 06                	je     99 <main+0x99>
  93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  97:	75 17                	jne    b0 <main+0xb0>
    printf(2, "ERROR: chmod expects a file as its second arg.\n");
  99:	83 ec 08             	sub    $0x8,%esp
  9c:	68 08 0b 00 00       	push   $0xb08
  a1:	6a 02                	push   $0x2
  a3:	e8 51 06 00 00       	call   6f9 <printf>
  a8:	83 c4 10             	add    $0x10,%esp
    exit();
  ab:	e8 72 04 00 00       	call   522 <exit>
  }

  // Written by Mark Morrissey
  // verify mode in correct range: 0000 - 1777 octal.
  if (!(mode[0] == '0' || mode[0] == '1')) {
  b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b3:	0f b6 00             	movzbl (%eax),%eax
  b6:	3c 30                	cmp    $0x30,%al
  b8:	74 21                	je     db <main+0xdb>
  ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  bd:	0f b6 00             	movzbl (%eax),%eax
  c0:	3c 31                	cmp    $0x31,%al
  c2:	74 17                	je     db <main+0xdb>
    printf(2, "ERROR: Mode is out of acceptable range 0000-1777.\n");
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	68 38 0b 00 00       	push   $0xb38
  cc:	6a 02                	push   $0x2
  ce:	e8 26 06 00 00       	call   6f9 <printf>
  d3:	83 c4 10             	add    $0x10,%esp
    exit();
  d6:	e8 47 04 00 00       	call   522 <exit>
  }
  if (!(mode[1] >= '0' && mode[1] <= '7')) {
  db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  de:	83 c0 01             	add    $0x1,%eax
  e1:	0f b6 00             	movzbl (%eax),%eax
  e4:	3c 2f                	cmp    $0x2f,%al
  e6:	7e 0d                	jle    f5 <main+0xf5>
  e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  eb:	83 c0 01             	add    $0x1,%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	3c 37                	cmp    $0x37,%al
  f3:	7e 17                	jle    10c <main+0x10c>
    printf(2, "ERROR: Mode is out of acceptable range 0000-1777.\n");
  f5:	83 ec 08             	sub    $0x8,%esp
  f8:	68 38 0b 00 00       	push   $0xb38
  fd:	6a 02                	push   $0x2
  ff:	e8 f5 05 00 00       	call   6f9 <printf>
 104:	83 c4 10             	add    $0x10,%esp
    exit();
 107:	e8 16 04 00 00       	call   522 <exit>
  }
  if (!(mode[2] >= '0' && mode[2] <= '7')) {
 10c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 10f:	83 c0 02             	add    $0x2,%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	3c 2f                	cmp    $0x2f,%al
 117:	7e 0d                	jle    126 <main+0x126>
 119:	8b 45 f0             	mov    -0x10(%ebp),%eax
 11c:	83 c0 02             	add    $0x2,%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	3c 37                	cmp    $0x37,%al
 124:	7e 17                	jle    13d <main+0x13d>
    printf(2, "ERROR: Mode is out of acceptable range 0000-1777.\n");
 126:	83 ec 08             	sub    $0x8,%esp
 129:	68 38 0b 00 00       	push   $0xb38
 12e:	6a 02                	push   $0x2
 130:	e8 c4 05 00 00       	call   6f9 <printf>
 135:	83 c4 10             	add    $0x10,%esp
    exit();
 138:	e8 e5 03 00 00       	call   522 <exit>
  }
  if (!(mode[3] >= '0' && mode[3] <= '7')) {
 13d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 140:	83 c0 03             	add    $0x3,%eax
 143:	0f b6 00             	movzbl (%eax),%eax
 146:	3c 2f                	cmp    $0x2f,%al
 148:	7e 0d                	jle    157 <main+0x157>
 14a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 14d:	83 c0 03             	add    $0x3,%eax
 150:	0f b6 00             	movzbl (%eax),%eax
 153:	3c 37                	cmp    $0x37,%al
 155:	7e 17                	jle    16e <main+0x16e>
    printf(2, "ERROR: Mode is out of acceptable range 0000-1777.\n");
 157:	83 ec 08             	sub    $0x8,%esp
 15a:	68 38 0b 00 00       	push   $0xb38
 15f:	6a 02                	push   $0x2
 161:	e8 93 05 00 00       	call   6f9 <printf>
 166:	83 c4 10             	add    $0x10,%esp
    exit();
 169:	e8 b4 03 00 00       	call   522 <exit>
  }

  // convert octal to decimal.  we have no pow() function
  imode += ((int)(mode[0] - '0') * (8*8*8));
 16e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	0f be c0             	movsbl %al,%eax
 177:	83 e8 30             	sub    $0x30,%eax
 17a:	c1 e0 09             	shl    $0x9,%eax
 17d:	01 45 f4             	add    %eax,-0xc(%ebp)
  imode += ((int)(mode[1] - '0') * (8*8));
 180:	8b 45 f0             	mov    -0x10(%ebp),%eax
 183:	83 c0 01             	add    $0x1,%eax
 186:	0f b6 00             	movzbl (%eax),%eax
 189:	0f be c0             	movsbl %al,%eax
 18c:	83 e8 30             	sub    $0x30,%eax
 18f:	c1 e0 06             	shl    $0x6,%eax
 192:	01 45 f4             	add    %eax,-0xc(%ebp)
  imode += ((int)(mode[2] - '0') * (8));
 195:	8b 45 f0             	mov    -0x10(%ebp),%eax
 198:	83 c0 02             	add    $0x2,%eax
 19b:	0f b6 00             	movzbl (%eax),%eax
 19e:	0f be c0             	movsbl %al,%eax
 1a1:	83 e8 30             	sub    $0x30,%eax
 1a4:	c1 e0 03             	shl    $0x3,%eax
 1a7:	01 45 f4             	add    %eax,-0xc(%ebp)
  imode +=  (int)(mode[3] - '0');
 1aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1ad:	83 c0 03             	add    $0x3,%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	0f be d0             	movsbl %al,%edx
 1b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b9:	01 d0                	add    %edx,%eax
 1bb:	83 e8 30             	sub    $0x30,%eax
 1be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //End of code written by Mark Morrissey

  int rc = chmod(file, imode);
 1c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c4:	83 ec 08             	sub    $0x8,%esp
 1c7:	50                   	push   %eax
 1c8:	ff 75 ec             	pushl  -0x14(%ebp)
 1cb:	e8 3a 04 00 00       	call   60a <chmod>
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (rc < 0) {
 1d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 1da:	79 17                	jns    1f3 <main+0x1f3>
    printf(2, "ERROR: chmod failed.\n");
 1dc:	83 ec 08             	sub    $0x8,%esp
 1df:	68 6b 0b 00 00       	push   $0xb6b
 1e4:	6a 02                	push   $0x2
 1e6:	e8 0e 05 00 00       	call   6f9 <printf>
 1eb:	83 c4 10             	add    $0x10,%esp
    exit();
 1ee:	e8 2f 03 00 00       	call   522 <exit>
  }
  exit();
 1f3:	e8 2a 03 00 00       	call   522 <exit>

000001f8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	57                   	push   %edi
 1fc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 200:	8b 55 10             	mov    0x10(%ebp),%edx
 203:	8b 45 0c             	mov    0xc(%ebp),%eax
 206:	89 cb                	mov    %ecx,%ebx
 208:	89 df                	mov    %ebx,%edi
 20a:	89 d1                	mov    %edx,%ecx
 20c:	fc                   	cld    
 20d:	f3 aa                	rep stos %al,%es:(%edi)
 20f:	89 ca                	mov    %ecx,%edx
 211:	89 fb                	mov    %edi,%ebx
 213:	89 5d 08             	mov    %ebx,0x8(%ebp)
 216:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 219:	90                   	nop
 21a:	5b                   	pop    %ebx
 21b:	5f                   	pop    %edi
 21c:	5d                   	pop    %ebp
 21d:	c3                   	ret    

0000021e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 22a:	90                   	nop
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	8d 50 01             	lea    0x1(%eax),%edx
 231:	89 55 08             	mov    %edx,0x8(%ebp)
 234:	8b 55 0c             	mov    0xc(%ebp),%edx
 237:	8d 4a 01             	lea    0x1(%edx),%ecx
 23a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 23d:	0f b6 12             	movzbl (%edx),%edx
 240:	88 10                	mov    %dl,(%eax)
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	75 e2                	jne    22b <strcpy+0xd>
    ;
  return os;
 249:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 251:	eb 08                	jmp    25b <strcmp+0xd>
    p++, q++;
 253:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 257:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	0f b6 00             	movzbl (%eax),%eax
 261:	84 c0                	test   %al,%al
 263:	74 10                	je     275 <strcmp+0x27>
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	0f b6 10             	movzbl (%eax),%edx
 26b:	8b 45 0c             	mov    0xc(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	38 c2                	cmp    %al,%dl
 273:	74 de                	je     253 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	0f b6 d0             	movzbl %al,%edx
 27e:	8b 45 0c             	mov    0xc(%ebp),%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	0f b6 c0             	movzbl %al,%eax
 287:	29 c2                	sub    %eax,%edx
 289:	89 d0                	mov    %edx,%eax
}
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    

0000028d <strlen>:

uint
strlen(char *s)
{
 28d:	55                   	push   %ebp
 28e:	89 e5                	mov    %esp,%ebp
 290:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 29a:	eb 04                	jmp    2a0 <strlen+0x13>
 29c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	01 d0                	add    %edx,%eax
 2a8:	0f b6 00             	movzbl (%eax),%eax
 2ab:	84 c0                	test   %al,%al
 2ad:	75 ed                	jne    29c <strlen+0xf>
    ;
  return n;
 2af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2b7:	8b 45 10             	mov    0x10(%ebp),%eax
 2ba:	50                   	push   %eax
 2bb:	ff 75 0c             	pushl  0xc(%ebp)
 2be:	ff 75 08             	pushl  0x8(%ebp)
 2c1:	e8 32 ff ff ff       	call   1f8 <stosb>
 2c6:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2cc:	c9                   	leave  
 2cd:	c3                   	ret    

000002ce <strchr>:

char*
strchr(const char *s, char c)
{
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	83 ec 04             	sub    $0x4,%esp
 2d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2da:	eb 14                	jmp    2f0 <strchr+0x22>
    if(*s == c)
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2e5:	75 05                	jne    2ec <strchr+0x1e>
      return (char*)s;
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	eb 13                	jmp    2ff <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2ec:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	0f b6 00             	movzbl (%eax),%eax
 2f6:	84 c0                	test   %al,%al
 2f8:	75 e2                	jne    2dc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ff:	c9                   	leave  
 300:	c3                   	ret    

00000301 <gets>:

char*
gets(char *buf, int max)
{
 301:	55                   	push   %ebp
 302:	89 e5                	mov    %esp,%ebp
 304:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 30e:	eb 42                	jmp    352 <gets+0x51>
    cc = read(0, &c, 1);
 310:	83 ec 04             	sub    $0x4,%esp
 313:	6a 01                	push   $0x1
 315:	8d 45 ef             	lea    -0x11(%ebp),%eax
 318:	50                   	push   %eax
 319:	6a 00                	push   $0x0
 31b:	e8 1a 02 00 00       	call   53a <read>
 320:	83 c4 10             	add    $0x10,%esp
 323:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 326:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 32a:	7e 33                	jle    35f <gets+0x5e>
      break;
    buf[i++] = c;
 32c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 32f:	8d 50 01             	lea    0x1(%eax),%edx
 332:	89 55 f4             	mov    %edx,-0xc(%ebp)
 335:	89 c2                	mov    %eax,%edx
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	01 c2                	add    %eax,%edx
 33c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 340:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 342:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 346:	3c 0a                	cmp    $0xa,%al
 348:	74 16                	je     360 <gets+0x5f>
 34a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 34e:	3c 0d                	cmp    $0xd,%al
 350:	74 0e                	je     360 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 352:	8b 45 f4             	mov    -0xc(%ebp),%eax
 355:	83 c0 01             	add    $0x1,%eax
 358:	3b 45 0c             	cmp    0xc(%ebp),%eax
 35b:	7c b3                	jl     310 <gets+0xf>
 35d:	eb 01                	jmp    360 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 35f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 360:	8b 55 f4             	mov    -0xc(%ebp),%edx
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	01 d0                	add    %edx,%eax
 368:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36e:	c9                   	leave  
 36f:	c3                   	ret    

00000370 <stat>:

int
stat(char *n, struct stat *st)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 376:	83 ec 08             	sub    $0x8,%esp
 379:	6a 00                	push   $0x0
 37b:	ff 75 08             	pushl  0x8(%ebp)
 37e:	e8 df 01 00 00       	call   562 <open>
 383:	83 c4 10             	add    $0x10,%esp
 386:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 38d:	79 07                	jns    396 <stat+0x26>
    return -1;
 38f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 394:	eb 25                	jmp    3bb <stat+0x4b>
  r = fstat(fd, st);
 396:	83 ec 08             	sub    $0x8,%esp
 399:	ff 75 0c             	pushl  0xc(%ebp)
 39c:	ff 75 f4             	pushl  -0xc(%ebp)
 39f:	e8 d6 01 00 00       	call   57a <fstat>
 3a4:	83 c4 10             	add    $0x10,%esp
 3a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3aa:	83 ec 0c             	sub    $0xc,%esp
 3ad:	ff 75 f4             	pushl  -0xc(%ebp)
 3b0:	e8 95 01 00 00       	call   54a <close>
 3b5:	83 c4 10             	add    $0x10,%esp
  return r;
 3b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3bb:	c9                   	leave  
 3bc:	c3                   	ret    

000003bd <atoi>:

int
atoi(const char *s)
{
 3bd:	55                   	push   %ebp
 3be:	89 e5                	mov    %esp,%ebp
 3c0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 3ca:	eb 04                	jmp    3d0 <atoi+0x13>
 3cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	0f b6 00             	movzbl (%eax),%eax
 3d6:	3c 20                	cmp    $0x20,%al
 3d8:	74 f2                	je     3cc <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	0f b6 00             	movzbl (%eax),%eax
 3e0:	3c 2d                	cmp    $0x2d,%al
 3e2:	75 07                	jne    3eb <atoi+0x2e>
 3e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3e9:	eb 05                	jmp    3f0 <atoi+0x33>
 3eb:	b8 01 00 00 00       	mov    $0x1,%eax
 3f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	0f b6 00             	movzbl (%eax),%eax
 3f9:	3c 2b                	cmp    $0x2b,%al
 3fb:	74 0a                	je     407 <atoi+0x4a>
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
 400:	0f b6 00             	movzbl (%eax),%eax
 403:	3c 2d                	cmp    $0x2d,%al
 405:	75 2b                	jne    432 <atoi+0x75>
    s++;
 407:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 40b:	eb 25                	jmp    432 <atoi+0x75>
    n = n*10 + *s++ - '0';
 40d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 410:	89 d0                	mov    %edx,%eax
 412:	c1 e0 02             	shl    $0x2,%eax
 415:	01 d0                	add    %edx,%eax
 417:	01 c0                	add    %eax,%eax
 419:	89 c1                	mov    %eax,%ecx
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
 41e:	8d 50 01             	lea    0x1(%eax),%edx
 421:	89 55 08             	mov    %edx,0x8(%ebp)
 424:	0f b6 00             	movzbl (%eax),%eax
 427:	0f be c0             	movsbl %al,%eax
 42a:	01 c8                	add    %ecx,%eax
 42c:	83 e8 30             	sub    $0x30,%eax
 42f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 432:	8b 45 08             	mov    0x8(%ebp),%eax
 435:	0f b6 00             	movzbl (%eax),%eax
 438:	3c 2f                	cmp    $0x2f,%al
 43a:	7e 0a                	jle    446 <atoi+0x89>
 43c:	8b 45 08             	mov    0x8(%ebp),%eax
 43f:	0f b6 00             	movzbl (%eax),%eax
 442:	3c 39                	cmp    $0x39,%al
 444:	7e c7                	jle    40d <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 446:	8b 45 f8             	mov    -0x8(%ebp),%eax
 449:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <atoo>:

int
atoo(const char *s)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 455:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 45c:	eb 04                	jmp    462 <atoo+0x13>
 45e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	0f b6 00             	movzbl (%eax),%eax
 468:	3c 20                	cmp    $0x20,%al
 46a:	74 f2                	je     45e <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
 46f:	0f b6 00             	movzbl (%eax),%eax
 472:	3c 2d                	cmp    $0x2d,%al
 474:	75 07                	jne    47d <atoo+0x2e>
 476:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 47b:	eb 05                	jmp    482 <atoo+0x33>
 47d:	b8 01 00 00 00       	mov    $0x1,%eax
 482:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	0f b6 00             	movzbl (%eax),%eax
 48b:	3c 2b                	cmp    $0x2b,%al
 48d:	74 0a                	je     499 <atoo+0x4a>
 48f:	8b 45 08             	mov    0x8(%ebp),%eax
 492:	0f b6 00             	movzbl (%eax),%eax
 495:	3c 2d                	cmp    $0x2d,%al
 497:	75 27                	jne    4c0 <atoo+0x71>
    s++;
 499:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 49d:	eb 21                	jmp    4c0 <atoo+0x71>
    n = n*8 + *s++ - '0';
 49f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4a2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	8d 50 01             	lea    0x1(%eax),%edx
 4af:	89 55 08             	mov    %edx,0x8(%ebp)
 4b2:	0f b6 00             	movzbl (%eax),%eax
 4b5:	0f be c0             	movsbl %al,%eax
 4b8:	01 c8                	add    %ecx,%eax
 4ba:	83 e8 30             	sub    $0x30,%eax
 4bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	0f b6 00             	movzbl (%eax),%eax
 4c6:	3c 2f                	cmp    $0x2f,%al
 4c8:	7e 0a                	jle    4d4 <atoo+0x85>
 4ca:	8b 45 08             	mov    0x8(%ebp),%eax
 4cd:	0f b6 00             	movzbl (%eax),%eax
 4d0:	3c 37                	cmp    $0x37,%al
 4d2:	7e cb                	jle    49f <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 4d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4d7:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4db:	c9                   	leave  
 4dc:	c3                   	ret    

000004dd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4dd:	55                   	push   %ebp
 4de:	89 e5                	mov    %esp,%ebp
 4e0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4ef:	eb 17                	jmp    508 <memmove+0x2b>
    *dst++ = *src++;
 4f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4f4:	8d 50 01             	lea    0x1(%eax),%edx
 4f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4fd:	8d 4a 01             	lea    0x1(%edx),%ecx
 500:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 503:	0f b6 12             	movzbl (%edx),%edx
 506:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 508:	8b 45 10             	mov    0x10(%ebp),%eax
 50b:	8d 50 ff             	lea    -0x1(%eax),%edx
 50e:	89 55 10             	mov    %edx,0x10(%ebp)
 511:	85 c0                	test   %eax,%eax
 513:	7f dc                	jg     4f1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 515:	8b 45 08             	mov    0x8(%ebp),%eax
}
 518:	c9                   	leave  
 519:	c3                   	ret    

0000051a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 51a:	b8 01 00 00 00       	mov    $0x1,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <exit>:
SYSCALL(exit)
 522:	b8 02 00 00 00       	mov    $0x2,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <wait>:
SYSCALL(wait)
 52a:	b8 03 00 00 00       	mov    $0x3,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <pipe>:
SYSCALL(pipe)
 532:	b8 04 00 00 00       	mov    $0x4,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <read>:
SYSCALL(read)
 53a:	b8 05 00 00 00       	mov    $0x5,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <write>:
SYSCALL(write)
 542:	b8 10 00 00 00       	mov    $0x10,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <close>:
SYSCALL(close)
 54a:	b8 15 00 00 00       	mov    $0x15,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <kill>:
SYSCALL(kill)
 552:	b8 06 00 00 00       	mov    $0x6,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <exec>:
SYSCALL(exec)
 55a:	b8 07 00 00 00       	mov    $0x7,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <open>:
SYSCALL(open)
 562:	b8 0f 00 00 00       	mov    $0xf,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <mknod>:
SYSCALL(mknod)
 56a:	b8 11 00 00 00       	mov    $0x11,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <unlink>:
SYSCALL(unlink)
 572:	b8 12 00 00 00       	mov    $0x12,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <fstat>:
SYSCALL(fstat)
 57a:	b8 08 00 00 00       	mov    $0x8,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <link>:
SYSCALL(link)
 582:	b8 13 00 00 00       	mov    $0x13,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <mkdir>:
SYSCALL(mkdir)
 58a:	b8 14 00 00 00       	mov    $0x14,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <chdir>:
SYSCALL(chdir)
 592:	b8 09 00 00 00       	mov    $0x9,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <dup>:
SYSCALL(dup)
 59a:	b8 0a 00 00 00       	mov    $0xa,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <getpid>:
SYSCALL(getpid)
 5a2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <sbrk>:
SYSCALL(sbrk)
 5aa:	b8 0c 00 00 00       	mov    $0xc,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <sleep>:
SYSCALL(sleep)
 5b2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <uptime>:
SYSCALL(uptime)
 5ba:	b8 0e 00 00 00       	mov    $0xe,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <halt>:
SYSCALL(halt)
 5c2:	b8 16 00 00 00       	mov    $0x16,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <date>:
SYSCALL(date)        #p1
 5ca:	b8 17 00 00 00       	mov    $0x17,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <getuid>:
SYSCALL(getuid)      #p2
 5d2:	b8 18 00 00 00       	mov    $0x18,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <getgid>:
SYSCALL(getgid)      #p2
 5da:	b8 19 00 00 00       	mov    $0x19,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <getppid>:
SYSCALL(getppid)     #p2
 5e2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <setuid>:
SYSCALL(setuid)      #p2
 5ea:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <setgid>:
SYSCALL(setgid)      #p2
 5f2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <getprocs>:
SYSCALL(getprocs)    #p2
 5fa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <setpriority>:
SYSCALL(setpriority) #p4
 602:	b8 1e 00 00 00       	mov    $0x1e,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <chmod>:
SYSCALL(chmod)       #p5
 60a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <chown>:
SYSCALL(chown)       #p5
 612:	b8 20 00 00 00       	mov    $0x20,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <chgrp>:
SYSCALL(chgrp)       #p5
 61a:	b8 21 00 00 00       	mov    $0x21,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 622:	55                   	push   %ebp
 623:	89 e5                	mov    %esp,%ebp
 625:	83 ec 18             	sub    $0x18,%esp
 628:	8b 45 0c             	mov    0xc(%ebp),%eax
 62b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 62e:	83 ec 04             	sub    $0x4,%esp
 631:	6a 01                	push   $0x1
 633:	8d 45 f4             	lea    -0xc(%ebp),%eax
 636:	50                   	push   %eax
 637:	ff 75 08             	pushl  0x8(%ebp)
 63a:	e8 03 ff ff ff       	call   542 <write>
 63f:	83 c4 10             	add    $0x10,%esp
}
 642:	90                   	nop
 643:	c9                   	leave  
 644:	c3                   	ret    

00000645 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 645:	55                   	push   %ebp
 646:	89 e5                	mov    %esp,%ebp
 648:	53                   	push   %ebx
 649:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 64c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 653:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 657:	74 17                	je     670 <printint+0x2b>
 659:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 65d:	79 11                	jns    670 <printint+0x2b>
    neg = 1;
 65f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 666:	8b 45 0c             	mov    0xc(%ebp),%eax
 669:	f7 d8                	neg    %eax
 66b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 66e:	eb 06                	jmp    676 <printint+0x31>
  } else {
    x = xx;
 670:	8b 45 0c             	mov    0xc(%ebp),%eax
 673:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 676:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 67d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 680:	8d 41 01             	lea    0x1(%ecx),%eax
 683:	89 45 f4             	mov    %eax,-0xc(%ebp)
 686:	8b 5d 10             	mov    0x10(%ebp),%ebx
 689:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68c:	ba 00 00 00 00       	mov    $0x0,%edx
 691:	f7 f3                	div    %ebx
 693:	89 d0                	mov    %edx,%eax
 695:	0f b6 80 f4 0d 00 00 	movzbl 0xdf4(%eax),%eax
 69c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a6:	ba 00 00 00 00       	mov    $0x0,%edx
 6ab:	f7 f3                	div    %ebx
 6ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b4:	75 c7                	jne    67d <printint+0x38>
  if(neg)
 6b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ba:	74 2d                	je     6e9 <printint+0xa4>
    buf[i++] = '-';
 6bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bf:	8d 50 01             	lea    0x1(%eax),%edx
 6c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ca:	eb 1d                	jmp    6e9 <printint+0xa4>
    putc(fd, buf[i]);
 6cc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d2:	01 d0                	add    %edx,%eax
 6d4:	0f b6 00             	movzbl (%eax),%eax
 6d7:	0f be c0             	movsbl %al,%eax
 6da:	83 ec 08             	sub    $0x8,%esp
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 3c ff ff ff       	call   622 <putc>
 6e6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6e9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f1:	79 d9                	jns    6cc <printint+0x87>
    putc(fd, buf[i]);
}
 6f3:	90                   	nop
 6f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6f7:	c9                   	leave  
 6f8:	c3                   	ret    

000006f9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6f9:	55                   	push   %ebp
 6fa:	89 e5                	mov    %esp,%ebp
 6fc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 706:	8d 45 0c             	lea    0xc(%ebp),%eax
 709:	83 c0 04             	add    $0x4,%eax
 70c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 70f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 716:	e9 59 01 00 00       	jmp    874 <printf+0x17b>
    c = fmt[i] & 0xff;
 71b:	8b 55 0c             	mov    0xc(%ebp),%edx
 71e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 721:	01 d0                	add    %edx,%eax
 723:	0f b6 00             	movzbl (%eax),%eax
 726:	0f be c0             	movsbl %al,%eax
 729:	25 ff 00 00 00       	and    $0xff,%eax
 72e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 731:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 735:	75 2c                	jne    763 <printf+0x6a>
      if(c == '%'){
 737:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73b:	75 0c                	jne    749 <printf+0x50>
        state = '%';
 73d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 744:	e9 27 01 00 00       	jmp    870 <printf+0x177>
      } else {
        putc(fd, c);
 749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74c:	0f be c0             	movsbl %al,%eax
 74f:	83 ec 08             	sub    $0x8,%esp
 752:	50                   	push   %eax
 753:	ff 75 08             	pushl  0x8(%ebp)
 756:	e8 c7 fe ff ff       	call   622 <putc>
 75b:	83 c4 10             	add    $0x10,%esp
 75e:	e9 0d 01 00 00       	jmp    870 <printf+0x177>
      }
    } else if(state == '%'){
 763:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 767:	0f 85 03 01 00 00    	jne    870 <printf+0x177>
      if(c == 'd'){
 76d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 771:	75 1e                	jne    791 <printf+0x98>
        printint(fd, *ap, 10, 1);
 773:	8b 45 e8             	mov    -0x18(%ebp),%eax
 776:	8b 00                	mov    (%eax),%eax
 778:	6a 01                	push   $0x1
 77a:	6a 0a                	push   $0xa
 77c:	50                   	push   %eax
 77d:	ff 75 08             	pushl  0x8(%ebp)
 780:	e8 c0 fe ff ff       	call   645 <printint>
 785:	83 c4 10             	add    $0x10,%esp
        ap++;
 788:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 78c:	e9 d8 00 00 00       	jmp    869 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 791:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 795:	74 06                	je     79d <printf+0xa4>
 797:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 79b:	75 1e                	jne    7bb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 79d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	6a 00                	push   $0x0
 7a4:	6a 10                	push   $0x10
 7a6:	50                   	push   %eax
 7a7:	ff 75 08             	pushl  0x8(%ebp)
 7aa:	e8 96 fe ff ff       	call   645 <printint>
 7af:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7b6:	e9 ae 00 00 00       	jmp    869 <printf+0x170>
      } else if(c == 's'){
 7bb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7bf:	75 43                	jne    804 <printf+0x10b>
        s = (char*)*ap;
 7c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d1:	75 25                	jne    7f8 <printf+0xff>
          s = "(null)";
 7d3:	c7 45 f4 81 0b 00 00 	movl   $0xb81,-0xc(%ebp)
        while(*s != 0){
 7da:	eb 1c                	jmp    7f8 <printf+0xff>
          putc(fd, *s);
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	0f b6 00             	movzbl (%eax),%eax
 7e2:	0f be c0             	movsbl %al,%eax
 7e5:	83 ec 08             	sub    $0x8,%esp
 7e8:	50                   	push   %eax
 7e9:	ff 75 08             	pushl  0x8(%ebp)
 7ec:	e8 31 fe ff ff       	call   622 <putc>
 7f1:	83 c4 10             	add    $0x10,%esp
          s++;
 7f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	0f b6 00             	movzbl (%eax),%eax
 7fe:	84 c0                	test   %al,%al
 800:	75 da                	jne    7dc <printf+0xe3>
 802:	eb 65                	jmp    869 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 804:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 808:	75 1d                	jne    827 <printf+0x12e>
        putc(fd, *ap);
 80a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80d:	8b 00                	mov    (%eax),%eax
 80f:	0f be c0             	movsbl %al,%eax
 812:	83 ec 08             	sub    $0x8,%esp
 815:	50                   	push   %eax
 816:	ff 75 08             	pushl  0x8(%ebp)
 819:	e8 04 fe ff ff       	call   622 <putc>
 81e:	83 c4 10             	add    $0x10,%esp
        ap++;
 821:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 825:	eb 42                	jmp    869 <printf+0x170>
      } else if(c == '%'){
 827:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 82b:	75 17                	jne    844 <printf+0x14b>
        putc(fd, c);
 82d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 830:	0f be c0             	movsbl %al,%eax
 833:	83 ec 08             	sub    $0x8,%esp
 836:	50                   	push   %eax
 837:	ff 75 08             	pushl  0x8(%ebp)
 83a:	e8 e3 fd ff ff       	call   622 <putc>
 83f:	83 c4 10             	add    $0x10,%esp
 842:	eb 25                	jmp    869 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 844:	83 ec 08             	sub    $0x8,%esp
 847:	6a 25                	push   $0x25
 849:	ff 75 08             	pushl  0x8(%ebp)
 84c:	e8 d1 fd ff ff       	call   622 <putc>
 851:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 857:	0f be c0             	movsbl %al,%eax
 85a:	83 ec 08             	sub    $0x8,%esp
 85d:	50                   	push   %eax
 85e:	ff 75 08             	pushl  0x8(%ebp)
 861:	e8 bc fd ff ff       	call   622 <putc>
 866:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 869:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 870:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 874:	8b 55 0c             	mov    0xc(%ebp),%edx
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	01 d0                	add    %edx,%eax
 87c:	0f b6 00             	movzbl (%eax),%eax
 87f:	84 c0                	test   %al,%al
 881:	0f 85 94 fe ff ff    	jne    71b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 887:	90                   	nop
 888:	c9                   	leave  
 889:	c3                   	ret    

0000088a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88a:	55                   	push   %ebp
 88b:	89 e5                	mov    %esp,%ebp
 88d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 890:	8b 45 08             	mov    0x8(%ebp),%eax
 893:	83 e8 08             	sub    $0x8,%eax
 896:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 899:	a1 10 0e 00 00       	mov    0xe10,%eax
 89e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a1:	eb 24                	jmp    8c7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a6:	8b 00                	mov    (%eax),%eax
 8a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ab:	77 12                	ja     8bf <free+0x35>
 8ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b3:	77 24                	ja     8d9 <free+0x4f>
 8b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b8:	8b 00                	mov    (%eax),%eax
 8ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8bd:	77 1a                	ja     8d9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c2:	8b 00                	mov    (%eax),%eax
 8c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8cd:	76 d4                	jbe    8a3 <free+0x19>
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	8b 00                	mov    (%eax),%eax
 8d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d7:	76 ca                	jbe    8a3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dc:	8b 40 04             	mov    0x4(%eax),%eax
 8df:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e9:	01 c2                	add    %eax,%edx
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	39 c2                	cmp    %eax,%edx
 8f2:	75 24                	jne    918 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f7:	8b 50 04             	mov    0x4(%eax),%edx
 8fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fd:	8b 00                	mov    (%eax),%eax
 8ff:	8b 40 04             	mov    0x4(%eax),%eax
 902:	01 c2                	add    %eax,%edx
 904:	8b 45 f8             	mov    -0x8(%ebp),%eax
 907:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	8b 10                	mov    (%eax),%edx
 911:	8b 45 f8             	mov    -0x8(%ebp),%eax
 914:	89 10                	mov    %edx,(%eax)
 916:	eb 0a                	jmp    922 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 918:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91b:	8b 10                	mov    (%eax),%edx
 91d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 920:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 922:	8b 45 fc             	mov    -0x4(%ebp),%eax
 925:	8b 40 04             	mov    0x4(%eax),%eax
 928:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 932:	01 d0                	add    %edx,%eax
 934:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 937:	75 20                	jne    959 <free+0xcf>
    p->s.size += bp->s.size;
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 50 04             	mov    0x4(%eax),%edx
 93f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	01 c2                	add    %eax,%edx
 947:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 94d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 950:	8b 10                	mov    (%eax),%edx
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	89 10                	mov    %edx,(%eax)
 957:	eb 08                	jmp    961 <free+0xd7>
  } else
    p->s.ptr = bp;
 959:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 95f:	89 10                	mov    %edx,(%eax)
  freep = p;
 961:	8b 45 fc             	mov    -0x4(%ebp),%eax
 964:	a3 10 0e 00 00       	mov    %eax,0xe10
}
 969:	90                   	nop
 96a:	c9                   	leave  
 96b:	c3                   	ret    

0000096c <morecore>:

static Header*
morecore(uint nu)
{
 96c:	55                   	push   %ebp
 96d:	89 e5                	mov    %esp,%ebp
 96f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 972:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 979:	77 07                	ja     982 <morecore+0x16>
    nu = 4096;
 97b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 982:	8b 45 08             	mov    0x8(%ebp),%eax
 985:	c1 e0 03             	shl    $0x3,%eax
 988:	83 ec 0c             	sub    $0xc,%esp
 98b:	50                   	push   %eax
 98c:	e8 19 fc ff ff       	call   5aa <sbrk>
 991:	83 c4 10             	add    $0x10,%esp
 994:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 997:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 99b:	75 07                	jne    9a4 <morecore+0x38>
    return 0;
 99d:	b8 00 00 00 00       	mov    $0x0,%eax
 9a2:	eb 26                	jmp    9ca <morecore+0x5e>
  hp = (Header*)p;
 9a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ad:	8b 55 08             	mov    0x8(%ebp),%edx
 9b0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b6:	83 c0 08             	add    $0x8,%eax
 9b9:	83 ec 0c             	sub    $0xc,%esp
 9bc:	50                   	push   %eax
 9bd:	e8 c8 fe ff ff       	call   88a <free>
 9c2:	83 c4 10             	add    $0x10,%esp
  return freep;
 9c5:	a1 10 0e 00 00       	mov    0xe10,%eax
}
 9ca:	c9                   	leave  
 9cb:	c3                   	ret    

000009cc <malloc>:

void*
malloc(uint nbytes)
{
 9cc:	55                   	push   %ebp
 9cd:	89 e5                	mov    %esp,%ebp
 9cf:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d2:	8b 45 08             	mov    0x8(%ebp),%eax
 9d5:	83 c0 07             	add    $0x7,%eax
 9d8:	c1 e8 03             	shr    $0x3,%eax
 9db:	83 c0 01             	add    $0x1,%eax
 9de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9e1:	a1 10 0e 00 00       	mov    0xe10,%eax
 9e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9ed:	75 23                	jne    a12 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9ef:	c7 45 f0 08 0e 00 00 	movl   $0xe08,-0x10(%ebp)
 9f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f9:	a3 10 0e 00 00       	mov    %eax,0xe10
 9fe:	a1 10 0e 00 00       	mov    0xe10,%eax
 a03:	a3 08 0e 00 00       	mov    %eax,0xe08
    base.s.size = 0;
 a08:	c7 05 0c 0e 00 00 00 	movl   $0x0,0xe0c
 a0f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a15:	8b 00                	mov    (%eax),%eax
 a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1d:	8b 40 04             	mov    0x4(%eax),%eax
 a20:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a23:	72 4d                	jb     a72 <malloc+0xa6>
      if(p->s.size == nunits)
 a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a28:	8b 40 04             	mov    0x4(%eax),%eax
 a2b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a2e:	75 0c                	jne    a3c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a33:	8b 10                	mov    (%eax),%edx
 a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a38:	89 10                	mov    %edx,(%eax)
 a3a:	eb 26                	jmp    a62 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3f:	8b 40 04             	mov    0x4(%eax),%eax
 a42:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a45:	89 c2                	mov    %eax,%edx
 a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	8b 40 04             	mov    0x4(%eax),%eax
 a53:	c1 e0 03             	shl    $0x3,%eax
 a56:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a5f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a65:	a3 10 0e 00 00       	mov    %eax,0xe10
      return (void*)(p + 1);
 a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6d:	83 c0 08             	add    $0x8,%eax
 a70:	eb 3b                	jmp    aad <malloc+0xe1>
    }
    if(p == freep)
 a72:	a1 10 0e 00 00       	mov    0xe10,%eax
 a77:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a7a:	75 1e                	jne    a9a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a7c:	83 ec 0c             	sub    $0xc,%esp
 a7f:	ff 75 ec             	pushl  -0x14(%ebp)
 a82:	e8 e5 fe ff ff       	call   96c <morecore>
 a87:	83 c4 10             	add    $0x10,%esp
 a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a91:	75 07                	jne    a9a <malloc+0xce>
        return 0;
 a93:	b8 00 00 00 00       	mov    $0x0,%eax
 a98:	eb 13                	jmp    aad <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa3:	8b 00                	mov    (%eax),%eax
 aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 aa8:	e9 6d ff ff ff       	jmp    a1a <malloc+0x4e>
}
 aad:	c9                   	leave  
 aae:	c3                   	ret    
