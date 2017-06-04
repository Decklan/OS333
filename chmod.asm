
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
  31:	68 c4 0a 00 00       	push   $0xac4
  36:	6a 02                	push   $0x2
  38:	e8 d1 06 00 00       	call   70e <printf>
  3d:	83 c4 10             	add    $0x10,%esp
    exit();
  40:	e8 f2 04 00 00       	call   537 <exit>
  }

  mode = argv[1];
  45:	8b 43 04             	mov    0x4(%ebx),%eax
  48:	8b 40 04             	mov    0x4(%eax),%eax
  4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (strlen(mode) != 4) {
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	ff 75 f0             	pushl  -0x10(%ebp)
  54:	e8 49 02 00 00       	call   2a2 <strlen>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	83 f8 04             	cmp    $0x4,%eax
  5f:	74 17                	je     78 <main+0x78>
    printf(2, "ERROR: chmod expects a MODE of length 4.\n");
  61:	83 ec 08             	sub    $0x8,%esp
  64:	68 f0 0a 00 00       	push   $0xaf0
  69:	6a 02                	push   $0x2
  6b:	e8 9e 06 00 00       	call   70e <printf>
  70:	83 c4 10             	add    $0x10,%esp
    exit();
  73:	e8 bf 04 00 00       	call   537 <exit>
  }

  file = argv[2];
  78:	8b 43 04             	mov    0x4(%ebx),%eax
  7b:	8b 40 08             	mov    0x8(%eax),%eax
  7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (strlen(file) < 1 || !file) {
  81:	83 ec 0c             	sub    $0xc,%esp
  84:	ff 75 ec             	pushl  -0x14(%ebp)
  87:	e8 16 02 00 00       	call   2a2 <strlen>
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	85 c0                	test   %eax,%eax
  91:	74 06                	je     99 <main+0x99>
  93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  97:	75 17                	jne    b0 <main+0xb0>
    printf(2, "ERROR: chmod expects a file as its second arg.\n");
  99:	83 ec 08             	sub    $0x8,%esp
  9c:	68 1c 0b 00 00       	push   $0xb1c
  a1:	6a 02                	push   $0x2
  a3:	e8 66 06 00 00       	call   70e <printf>
  a8:	83 c4 10             	add    $0x10,%esp
    exit();
  ab:	e8 87 04 00 00       	call   537 <exit>
  }

  // XV6 code START
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
  c7:	68 4c 0b 00 00       	push   $0xb4c
  cc:	6a 02                	push   $0x2
  ce:	e8 3b 06 00 00       	call   70e <printf>
  d3:	83 c4 10             	add    $0x10,%esp
    exit();
  d6:	e8 5c 04 00 00       	call   537 <exit>
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
  f8:	68 4c 0b 00 00       	push   $0xb4c
  fd:	6a 02                	push   $0x2
  ff:	e8 0a 06 00 00       	call   70e <printf>
 104:	83 c4 10             	add    $0x10,%esp
    exit();
 107:	e8 2b 04 00 00       	call   537 <exit>
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
 129:	68 4c 0b 00 00       	push   $0xb4c
 12e:	6a 02                	push   $0x2
 130:	e8 d9 05 00 00       	call   70e <printf>
 135:	83 c4 10             	add    $0x10,%esp
    exit();
 138:	e8 fa 03 00 00       	call   537 <exit>
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
 15a:	68 4c 0b 00 00       	push   $0xb4c
 15f:	6a 02                	push   $0x2
 161:	e8 a8 05 00 00       	call   70e <printf>
 166:	83 c4 10             	add    $0x10,%esp
    exit();
 169:	e8 c9 03 00 00       	call   537 <exit>
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
  //XV6 code END

  printf(1, "String in octal is %s and decimal is %d\n", mode, imode);
 1c1:	ff 75 f4             	pushl  -0xc(%ebp)
 1c4:	ff 75 f0             	pushl  -0x10(%ebp)
 1c7:	68 80 0b 00 00       	push   $0xb80
 1cc:	6a 01                	push   $0x1
 1ce:	e8 3b 05 00 00       	call   70e <printf>
 1d3:	83 c4 10             	add    $0x10,%esp

  int rc = chmod(file, imode);
 1d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	50                   	push   %eax
 1dd:	ff 75 ec             	pushl  -0x14(%ebp)
 1e0:	e8 3a 04 00 00       	call   61f <chmod>
 1e5:	83 c4 10             	add    $0x10,%esp
 1e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (rc < 0) {
 1eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 1ef:	79 17                	jns    208 <main+0x208>
    printf(2, "ERROR: chmod failed.\n");
 1f1:	83 ec 08             	sub    $0x8,%esp
 1f4:	68 a9 0b 00 00       	push   $0xba9
 1f9:	6a 02                	push   $0x2
 1fb:	e8 0e 05 00 00       	call   70e <printf>
 200:	83 c4 10             	add    $0x10,%esp
    exit();
 203:	e8 2f 03 00 00       	call   537 <exit>
  }
  exit();
 208:	e8 2a 03 00 00       	call   537 <exit>

0000020d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 20d:	55                   	push   %ebp
 20e:	89 e5                	mov    %esp,%ebp
 210:	57                   	push   %edi
 211:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 212:	8b 4d 08             	mov    0x8(%ebp),%ecx
 215:	8b 55 10             	mov    0x10(%ebp),%edx
 218:	8b 45 0c             	mov    0xc(%ebp),%eax
 21b:	89 cb                	mov    %ecx,%ebx
 21d:	89 df                	mov    %ebx,%edi
 21f:	89 d1                	mov    %edx,%ecx
 221:	fc                   	cld    
 222:	f3 aa                	rep stos %al,%es:(%edi)
 224:	89 ca                	mov    %ecx,%edx
 226:	89 fb                	mov    %edi,%ebx
 228:	89 5d 08             	mov    %ebx,0x8(%ebp)
 22b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 22e:	90                   	nop
 22f:	5b                   	pop    %ebx
 230:	5f                   	pop    %edi
 231:	5d                   	pop    %ebp
 232:	c3                   	ret    

00000233 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 23f:	90                   	nop
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	8d 50 01             	lea    0x1(%eax),%edx
 246:	89 55 08             	mov    %edx,0x8(%ebp)
 249:	8b 55 0c             	mov    0xc(%ebp),%edx
 24c:	8d 4a 01             	lea    0x1(%edx),%ecx
 24f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 252:	0f b6 12             	movzbl (%edx),%edx
 255:	88 10                	mov    %dl,(%eax)
 257:	0f b6 00             	movzbl (%eax),%eax
 25a:	84 c0                	test   %al,%al
 25c:	75 e2                	jne    240 <strcpy+0xd>
    ;
  return os;
 25e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 261:	c9                   	leave  
 262:	c3                   	ret    

00000263 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 263:	55                   	push   %ebp
 264:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 266:	eb 08                	jmp    270 <strcmp+0xd>
    p++, q++;
 268:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 26c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	84 c0                	test   %al,%al
 278:	74 10                	je     28a <strcmp+0x27>
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	0f b6 10             	movzbl (%eax),%edx
 280:	8b 45 0c             	mov    0xc(%ebp),%eax
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	38 c2                	cmp    %al,%dl
 288:	74 de                	je     268 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	0f b6 00             	movzbl (%eax),%eax
 290:	0f b6 d0             	movzbl %al,%edx
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	0f b6 c0             	movzbl %al,%eax
 29c:	29 c2                	sub    %eax,%edx
 29e:	89 d0                	mov    %edx,%eax
}
 2a0:	5d                   	pop    %ebp
 2a1:	c3                   	ret    

000002a2 <strlen>:

uint
strlen(char *s)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2af:	eb 04                	jmp    2b5 <strlen+0x13>
 2b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	01 d0                	add    %edx,%eax
 2bd:	0f b6 00             	movzbl (%eax),%eax
 2c0:	84 c0                	test   %al,%al
 2c2:	75 ed                	jne    2b1 <strlen+0xf>
    ;
  return n;
 2c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2cc:	8b 45 10             	mov    0x10(%ebp),%eax
 2cf:	50                   	push   %eax
 2d0:	ff 75 0c             	pushl  0xc(%ebp)
 2d3:	ff 75 08             	pushl  0x8(%ebp)
 2d6:	e8 32 ff ff ff       	call   20d <stosb>
 2db:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e1:	c9                   	leave  
 2e2:	c3                   	ret    

000002e3 <strchr>:

char*
strchr(const char *s, char c)
{
 2e3:	55                   	push   %ebp
 2e4:	89 e5                	mov    %esp,%ebp
 2e6:	83 ec 04             	sub    $0x4,%esp
 2e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ec:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ef:	eb 14                	jmp    305 <strchr+0x22>
    if(*s == c)
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	0f b6 00             	movzbl (%eax),%eax
 2f7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2fa:	75 05                	jne    301 <strchr+0x1e>
      return (char*)s;
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	eb 13                	jmp    314 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 301:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	0f b6 00             	movzbl (%eax),%eax
 30b:	84 c0                	test   %al,%al
 30d:	75 e2                	jne    2f1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 30f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 314:	c9                   	leave  
 315:	c3                   	ret    

00000316 <gets>:

char*
gets(char *buf, int max)
{
 316:	55                   	push   %ebp
 317:	89 e5                	mov    %esp,%ebp
 319:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 31c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 323:	eb 42                	jmp    367 <gets+0x51>
    cc = read(0, &c, 1);
 325:	83 ec 04             	sub    $0x4,%esp
 328:	6a 01                	push   $0x1
 32a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 32d:	50                   	push   %eax
 32e:	6a 00                	push   $0x0
 330:	e8 1a 02 00 00       	call   54f <read>
 335:	83 c4 10             	add    $0x10,%esp
 338:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 33b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 33f:	7e 33                	jle    374 <gets+0x5e>
      break;
    buf[i++] = c;
 341:	8b 45 f4             	mov    -0xc(%ebp),%eax
 344:	8d 50 01             	lea    0x1(%eax),%edx
 347:	89 55 f4             	mov    %edx,-0xc(%ebp)
 34a:	89 c2                	mov    %eax,%edx
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	01 c2                	add    %eax,%edx
 351:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 355:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 357:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 35b:	3c 0a                	cmp    $0xa,%al
 35d:	74 16                	je     375 <gets+0x5f>
 35f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 363:	3c 0d                	cmp    $0xd,%al
 365:	74 0e                	je     375 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 367:	8b 45 f4             	mov    -0xc(%ebp),%eax
 36a:	83 c0 01             	add    $0x1,%eax
 36d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 370:	7c b3                	jl     325 <gets+0xf>
 372:	eb 01                	jmp    375 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 374:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 375:	8b 55 f4             	mov    -0xc(%ebp),%edx
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	01 d0                	add    %edx,%eax
 37d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 380:	8b 45 08             	mov    0x8(%ebp),%eax
}
 383:	c9                   	leave  
 384:	c3                   	ret    

00000385 <stat>:

int
stat(char *n, struct stat *st)
{
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
 388:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 38b:	83 ec 08             	sub    $0x8,%esp
 38e:	6a 00                	push   $0x0
 390:	ff 75 08             	pushl  0x8(%ebp)
 393:	e8 df 01 00 00       	call   577 <open>
 398:	83 c4 10             	add    $0x10,%esp
 39b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 39e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3a2:	79 07                	jns    3ab <stat+0x26>
    return -1;
 3a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3a9:	eb 25                	jmp    3d0 <stat+0x4b>
  r = fstat(fd, st);
 3ab:	83 ec 08             	sub    $0x8,%esp
 3ae:	ff 75 0c             	pushl  0xc(%ebp)
 3b1:	ff 75 f4             	pushl  -0xc(%ebp)
 3b4:	e8 d6 01 00 00       	call   58f <fstat>
 3b9:	83 c4 10             	add    $0x10,%esp
 3bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3bf:	83 ec 0c             	sub    $0xc,%esp
 3c2:	ff 75 f4             	pushl  -0xc(%ebp)
 3c5:	e8 95 01 00 00       	call   55f <close>
 3ca:	83 c4 10             	add    $0x10,%esp
  return r;
 3cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3d0:	c9                   	leave  
 3d1:	c3                   	ret    

000003d2 <atoi>:

int
atoi(const char *s)
{
 3d2:	55                   	push   %ebp
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 3df:	eb 04                	jmp    3e5 <atoi+0x13>
 3e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	0f b6 00             	movzbl (%eax),%eax
 3eb:	3c 20                	cmp    $0x20,%al
 3ed:	74 f2                	je     3e1 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
 3f2:	0f b6 00             	movzbl (%eax),%eax
 3f5:	3c 2d                	cmp    $0x2d,%al
 3f7:	75 07                	jne    400 <atoi+0x2e>
 3f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3fe:	eb 05                	jmp    405 <atoi+0x33>
 400:	b8 01 00 00 00       	mov    $0x1,%eax
 405:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	0f b6 00             	movzbl (%eax),%eax
 40e:	3c 2b                	cmp    $0x2b,%al
 410:	74 0a                	je     41c <atoi+0x4a>
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	0f b6 00             	movzbl (%eax),%eax
 418:	3c 2d                	cmp    $0x2d,%al
 41a:	75 2b                	jne    447 <atoi+0x75>
    s++;
 41c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 420:	eb 25                	jmp    447 <atoi+0x75>
    n = n*10 + *s++ - '0';
 422:	8b 55 fc             	mov    -0x4(%ebp),%edx
 425:	89 d0                	mov    %edx,%eax
 427:	c1 e0 02             	shl    $0x2,%eax
 42a:	01 d0                	add    %edx,%eax
 42c:	01 c0                	add    %eax,%eax
 42e:	89 c1                	mov    %eax,%ecx
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	8d 50 01             	lea    0x1(%eax),%edx
 436:	89 55 08             	mov    %edx,0x8(%ebp)
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	0f be c0             	movsbl %al,%eax
 43f:	01 c8                	add    %ecx,%eax
 441:	83 e8 30             	sub    $0x30,%eax
 444:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	0f b6 00             	movzbl (%eax),%eax
 44d:	3c 2f                	cmp    $0x2f,%al
 44f:	7e 0a                	jle    45b <atoi+0x89>
 451:	8b 45 08             	mov    0x8(%ebp),%eax
 454:	0f b6 00             	movzbl (%eax),%eax
 457:	3c 39                	cmp    $0x39,%al
 459:	7e c7                	jle    422 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 45b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 45e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 462:	c9                   	leave  
 463:	c3                   	ret    

00000464 <atoo>:

int
atoo(const char *s)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 46a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 471:	eb 04                	jmp    477 <atoo+0x13>
 473:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	0f b6 00             	movzbl (%eax),%eax
 47d:	3c 20                	cmp    $0x20,%al
 47f:	74 f2                	je     473 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	0f b6 00             	movzbl (%eax),%eax
 487:	3c 2d                	cmp    $0x2d,%al
 489:	75 07                	jne    492 <atoo+0x2e>
 48b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 490:	eb 05                	jmp    497 <atoo+0x33>
 492:	b8 01 00 00 00       	mov    $0x1,%eax
 497:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	3c 2b                	cmp    $0x2b,%al
 4a2:	74 0a                	je     4ae <atoo+0x4a>
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	0f b6 00             	movzbl (%eax),%eax
 4aa:	3c 2d                	cmp    $0x2d,%al
 4ac:	75 27                	jne    4d5 <atoo+0x71>
    s++;
 4ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 4b2:	eb 21                	jmp    4d5 <atoo+0x71>
    n = n*8 + *s++ - '0';
 4b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4b7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 4be:	8b 45 08             	mov    0x8(%ebp),%eax
 4c1:	8d 50 01             	lea    0x1(%eax),%edx
 4c4:	89 55 08             	mov    %edx,0x8(%ebp)
 4c7:	0f b6 00             	movzbl (%eax),%eax
 4ca:	0f be c0             	movsbl %al,%eax
 4cd:	01 c8                	add    %ecx,%eax
 4cf:	83 e8 30             	sub    $0x30,%eax
 4d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 4d5:	8b 45 08             	mov    0x8(%ebp),%eax
 4d8:	0f b6 00             	movzbl (%eax),%eax
 4db:	3c 2f                	cmp    $0x2f,%al
 4dd:	7e 0a                	jle    4e9 <atoo+0x85>
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	0f b6 00             	movzbl (%eax),%eax
 4e5:	3c 37                	cmp    $0x37,%al
 4e7:	7e cb                	jle    4b4 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 4e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4ec:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4f0:	c9                   	leave  
 4f1:	c3                   	ret    

000004f2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4f2:	55                   	push   %ebp
 4f3:	89 e5                	mov    %esp,%ebp
 4f5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
 4fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 501:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 504:	eb 17                	jmp    51d <memmove+0x2b>
    *dst++ = *src++;
 506:	8b 45 fc             	mov    -0x4(%ebp),%eax
 509:	8d 50 01             	lea    0x1(%eax),%edx
 50c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 50f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 512:	8d 4a 01             	lea    0x1(%edx),%ecx
 515:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 518:	0f b6 12             	movzbl (%edx),%edx
 51b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 51d:	8b 45 10             	mov    0x10(%ebp),%eax
 520:	8d 50 ff             	lea    -0x1(%eax),%edx
 523:	89 55 10             	mov    %edx,0x10(%ebp)
 526:	85 c0                	test   %eax,%eax
 528:	7f dc                	jg     506 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 52d:	c9                   	leave  
 52e:	c3                   	ret    

0000052f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 52f:	b8 01 00 00 00       	mov    $0x1,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <exit>:
SYSCALL(exit)
 537:	b8 02 00 00 00       	mov    $0x2,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <wait>:
SYSCALL(wait)
 53f:	b8 03 00 00 00       	mov    $0x3,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <pipe>:
SYSCALL(pipe)
 547:	b8 04 00 00 00       	mov    $0x4,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <read>:
SYSCALL(read)
 54f:	b8 05 00 00 00       	mov    $0x5,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <write>:
SYSCALL(write)
 557:	b8 10 00 00 00       	mov    $0x10,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <close>:
SYSCALL(close)
 55f:	b8 15 00 00 00       	mov    $0x15,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <kill>:
SYSCALL(kill)
 567:	b8 06 00 00 00       	mov    $0x6,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <exec>:
SYSCALL(exec)
 56f:	b8 07 00 00 00       	mov    $0x7,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <open>:
SYSCALL(open)
 577:	b8 0f 00 00 00       	mov    $0xf,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <mknod>:
SYSCALL(mknod)
 57f:	b8 11 00 00 00       	mov    $0x11,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <unlink>:
SYSCALL(unlink)
 587:	b8 12 00 00 00       	mov    $0x12,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <fstat>:
SYSCALL(fstat)
 58f:	b8 08 00 00 00       	mov    $0x8,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <link>:
SYSCALL(link)
 597:	b8 13 00 00 00       	mov    $0x13,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <mkdir>:
SYSCALL(mkdir)
 59f:	b8 14 00 00 00       	mov    $0x14,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <chdir>:
SYSCALL(chdir)
 5a7:	b8 09 00 00 00       	mov    $0x9,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <dup>:
SYSCALL(dup)
 5af:	b8 0a 00 00 00       	mov    $0xa,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <getpid>:
SYSCALL(getpid)
 5b7:	b8 0b 00 00 00       	mov    $0xb,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <sbrk>:
SYSCALL(sbrk)
 5bf:	b8 0c 00 00 00       	mov    $0xc,%eax
 5c4:	cd 40                	int    $0x40
 5c6:	c3                   	ret    

000005c7 <sleep>:
SYSCALL(sleep)
 5c7:	b8 0d 00 00 00       	mov    $0xd,%eax
 5cc:	cd 40                	int    $0x40
 5ce:	c3                   	ret    

000005cf <uptime>:
SYSCALL(uptime)
 5cf:	b8 0e 00 00 00       	mov    $0xe,%eax
 5d4:	cd 40                	int    $0x40
 5d6:	c3                   	ret    

000005d7 <halt>:
SYSCALL(halt)
 5d7:	b8 16 00 00 00       	mov    $0x16,%eax
 5dc:	cd 40                	int    $0x40
 5de:	c3                   	ret    

000005df <date>:
SYSCALL(date)        #p1
 5df:	b8 17 00 00 00       	mov    $0x17,%eax
 5e4:	cd 40                	int    $0x40
 5e6:	c3                   	ret    

000005e7 <getuid>:
SYSCALL(getuid)      #p2
 5e7:	b8 18 00 00 00       	mov    $0x18,%eax
 5ec:	cd 40                	int    $0x40
 5ee:	c3                   	ret    

000005ef <getgid>:
SYSCALL(getgid)      #p2
 5ef:	b8 19 00 00 00       	mov    $0x19,%eax
 5f4:	cd 40                	int    $0x40
 5f6:	c3                   	ret    

000005f7 <getppid>:
SYSCALL(getppid)     #p2
 5f7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5fc:	cd 40                	int    $0x40
 5fe:	c3                   	ret    

000005ff <setuid>:
SYSCALL(setuid)      #p2
 5ff:	b8 1b 00 00 00       	mov    $0x1b,%eax
 604:	cd 40                	int    $0x40
 606:	c3                   	ret    

00000607 <setgid>:
SYSCALL(setgid)      #p2
 607:	b8 1c 00 00 00       	mov    $0x1c,%eax
 60c:	cd 40                	int    $0x40
 60e:	c3                   	ret    

0000060f <getprocs>:
SYSCALL(getprocs)    #p2
 60f:	b8 1d 00 00 00       	mov    $0x1d,%eax
 614:	cd 40                	int    $0x40
 616:	c3                   	ret    

00000617 <setpriority>:
SYSCALL(setpriority) #p4
 617:	b8 1e 00 00 00       	mov    $0x1e,%eax
 61c:	cd 40                	int    $0x40
 61e:	c3                   	ret    

0000061f <chmod>:
SYSCALL(chmod)       #p5
 61f:	b8 1f 00 00 00       	mov    $0x1f,%eax
 624:	cd 40                	int    $0x40
 626:	c3                   	ret    

00000627 <chown>:
SYSCALL(chown)       #p5
 627:	b8 20 00 00 00       	mov    $0x20,%eax
 62c:	cd 40                	int    $0x40
 62e:	c3                   	ret    

0000062f <chgrp>:
SYSCALL(chgrp)       #p5
 62f:	b8 21 00 00 00       	mov    $0x21,%eax
 634:	cd 40                	int    $0x40
 636:	c3                   	ret    

00000637 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 637:	55                   	push   %ebp
 638:	89 e5                	mov    %esp,%ebp
 63a:	83 ec 18             	sub    $0x18,%esp
 63d:	8b 45 0c             	mov    0xc(%ebp),%eax
 640:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 643:	83 ec 04             	sub    $0x4,%esp
 646:	6a 01                	push   $0x1
 648:	8d 45 f4             	lea    -0xc(%ebp),%eax
 64b:	50                   	push   %eax
 64c:	ff 75 08             	pushl  0x8(%ebp)
 64f:	e8 03 ff ff ff       	call   557 <write>
 654:	83 c4 10             	add    $0x10,%esp
}
 657:	90                   	nop
 658:	c9                   	leave  
 659:	c3                   	ret    

0000065a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65a:	55                   	push   %ebp
 65b:	89 e5                	mov    %esp,%ebp
 65d:	53                   	push   %ebx
 65e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 661:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 668:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 66c:	74 17                	je     685 <printint+0x2b>
 66e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 672:	79 11                	jns    685 <printint+0x2b>
    neg = 1;
 674:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 67b:	8b 45 0c             	mov    0xc(%ebp),%eax
 67e:	f7 d8                	neg    %eax
 680:	89 45 ec             	mov    %eax,-0x14(%ebp)
 683:	eb 06                	jmp    68b <printint+0x31>
  } else {
    x = xx;
 685:	8b 45 0c             	mov    0xc(%ebp),%eax
 688:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 68b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 692:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 695:	8d 41 01             	lea    0x1(%ecx),%eax
 698:	89 45 f4             	mov    %eax,-0xc(%ebp)
 69b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 69e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a1:	ba 00 00 00 00       	mov    $0x0,%edx
 6a6:	f7 f3                	div    %ebx
 6a8:	89 d0                	mov    %edx,%eax
 6aa:	0f b6 80 34 0e 00 00 	movzbl 0xe34(%eax),%eax
 6b1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6bb:	ba 00 00 00 00       	mov    $0x0,%edx
 6c0:	f7 f3                	div    %ebx
 6c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6c9:	75 c7                	jne    692 <printint+0x38>
  if(neg)
 6cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6cf:	74 2d                	je     6fe <printint+0xa4>
    buf[i++] = '-';
 6d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d4:	8d 50 01             	lea    0x1(%eax),%edx
 6d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6da:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6df:	eb 1d                	jmp    6fe <printint+0xa4>
    putc(fd, buf[i]);
 6e1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e7:	01 d0                	add    %edx,%eax
 6e9:	0f b6 00             	movzbl (%eax),%eax
 6ec:	0f be c0             	movsbl %al,%eax
 6ef:	83 ec 08             	sub    $0x8,%esp
 6f2:	50                   	push   %eax
 6f3:	ff 75 08             	pushl  0x8(%ebp)
 6f6:	e8 3c ff ff ff       	call   637 <putc>
 6fb:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6fe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 702:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 706:	79 d9                	jns    6e1 <printint+0x87>
    putc(fd, buf[i]);
}
 708:	90                   	nop
 709:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 70c:	c9                   	leave  
 70d:	c3                   	ret    

0000070e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 70e:	55                   	push   %ebp
 70f:	89 e5                	mov    %esp,%ebp
 711:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 714:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 71b:	8d 45 0c             	lea    0xc(%ebp),%eax
 71e:	83 c0 04             	add    $0x4,%eax
 721:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 724:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 72b:	e9 59 01 00 00       	jmp    889 <printf+0x17b>
    c = fmt[i] & 0xff;
 730:	8b 55 0c             	mov    0xc(%ebp),%edx
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	01 d0                	add    %edx,%eax
 738:	0f b6 00             	movzbl (%eax),%eax
 73b:	0f be c0             	movsbl %al,%eax
 73e:	25 ff 00 00 00       	and    $0xff,%eax
 743:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 746:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 74a:	75 2c                	jne    778 <printf+0x6a>
      if(c == '%'){
 74c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 750:	75 0c                	jne    75e <printf+0x50>
        state = '%';
 752:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 759:	e9 27 01 00 00       	jmp    885 <printf+0x177>
      } else {
        putc(fd, c);
 75e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 761:	0f be c0             	movsbl %al,%eax
 764:	83 ec 08             	sub    $0x8,%esp
 767:	50                   	push   %eax
 768:	ff 75 08             	pushl  0x8(%ebp)
 76b:	e8 c7 fe ff ff       	call   637 <putc>
 770:	83 c4 10             	add    $0x10,%esp
 773:	e9 0d 01 00 00       	jmp    885 <printf+0x177>
      }
    } else if(state == '%'){
 778:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 77c:	0f 85 03 01 00 00    	jne    885 <printf+0x177>
      if(c == 'd'){
 782:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 786:	75 1e                	jne    7a6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 788:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78b:	8b 00                	mov    (%eax),%eax
 78d:	6a 01                	push   $0x1
 78f:	6a 0a                	push   $0xa
 791:	50                   	push   %eax
 792:	ff 75 08             	pushl  0x8(%ebp)
 795:	e8 c0 fe ff ff       	call   65a <printint>
 79a:	83 c4 10             	add    $0x10,%esp
        ap++;
 79d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a1:	e9 d8 00 00 00       	jmp    87e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7a6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7aa:	74 06                	je     7b2 <printf+0xa4>
 7ac:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7b0:	75 1e                	jne    7d0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b5:	8b 00                	mov    (%eax),%eax
 7b7:	6a 00                	push   $0x0
 7b9:	6a 10                	push   $0x10
 7bb:	50                   	push   %eax
 7bc:	ff 75 08             	pushl  0x8(%ebp)
 7bf:	e8 96 fe ff ff       	call   65a <printint>
 7c4:	83 c4 10             	add    $0x10,%esp
        ap++;
 7c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7cb:	e9 ae 00 00 00       	jmp    87e <printf+0x170>
      } else if(c == 's'){
 7d0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7d4:	75 43                	jne    819 <printf+0x10b>
        s = (char*)*ap;
 7d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d9:	8b 00                	mov    (%eax),%eax
 7db:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e6:	75 25                	jne    80d <printf+0xff>
          s = "(null)";
 7e8:	c7 45 f4 bf 0b 00 00 	movl   $0xbbf,-0xc(%ebp)
        while(*s != 0){
 7ef:	eb 1c                	jmp    80d <printf+0xff>
          putc(fd, *s);
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	0f b6 00             	movzbl (%eax),%eax
 7f7:	0f be c0             	movsbl %al,%eax
 7fa:	83 ec 08             	sub    $0x8,%esp
 7fd:	50                   	push   %eax
 7fe:	ff 75 08             	pushl  0x8(%ebp)
 801:	e8 31 fe ff ff       	call   637 <putc>
 806:	83 c4 10             	add    $0x10,%esp
          s++;
 809:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	0f b6 00             	movzbl (%eax),%eax
 813:	84 c0                	test   %al,%al
 815:	75 da                	jne    7f1 <printf+0xe3>
 817:	eb 65                	jmp    87e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 819:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 81d:	75 1d                	jne    83c <printf+0x12e>
        putc(fd, *ap);
 81f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	0f be c0             	movsbl %al,%eax
 827:	83 ec 08             	sub    $0x8,%esp
 82a:	50                   	push   %eax
 82b:	ff 75 08             	pushl  0x8(%ebp)
 82e:	e8 04 fe ff ff       	call   637 <putc>
 833:	83 c4 10             	add    $0x10,%esp
        ap++;
 836:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 83a:	eb 42                	jmp    87e <printf+0x170>
      } else if(c == '%'){
 83c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 840:	75 17                	jne    859 <printf+0x14b>
        putc(fd, c);
 842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 845:	0f be c0             	movsbl %al,%eax
 848:	83 ec 08             	sub    $0x8,%esp
 84b:	50                   	push   %eax
 84c:	ff 75 08             	pushl  0x8(%ebp)
 84f:	e8 e3 fd ff ff       	call   637 <putc>
 854:	83 c4 10             	add    $0x10,%esp
 857:	eb 25                	jmp    87e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 859:	83 ec 08             	sub    $0x8,%esp
 85c:	6a 25                	push   $0x25
 85e:	ff 75 08             	pushl  0x8(%ebp)
 861:	e8 d1 fd ff ff       	call   637 <putc>
 866:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 86c:	0f be c0             	movsbl %al,%eax
 86f:	83 ec 08             	sub    $0x8,%esp
 872:	50                   	push   %eax
 873:	ff 75 08             	pushl  0x8(%ebp)
 876:	e8 bc fd ff ff       	call   637 <putc>
 87b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 87e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 885:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 889:	8b 55 0c             	mov    0xc(%ebp),%edx
 88c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88f:	01 d0                	add    %edx,%eax
 891:	0f b6 00             	movzbl (%eax),%eax
 894:	84 c0                	test   %al,%al
 896:	0f 85 94 fe ff ff    	jne    730 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 89c:	90                   	nop
 89d:	c9                   	leave  
 89e:	c3                   	ret    

0000089f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 89f:	55                   	push   %ebp
 8a0:	89 e5                	mov    %esp,%ebp
 8a2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a5:	8b 45 08             	mov    0x8(%ebp),%eax
 8a8:	83 e8 08             	sub    $0x8,%eax
 8ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ae:	a1 50 0e 00 00       	mov    0xe50,%eax
 8b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8b6:	eb 24                	jmp    8dc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bb:	8b 00                	mov    (%eax),%eax
 8bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c0:	77 12                	ja     8d4 <free+0x35>
 8c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c8:	77 24                	ja     8ee <free+0x4f>
 8ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cd:	8b 00                	mov    (%eax),%eax
 8cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d2:	77 1a                	ja     8ee <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d7:	8b 00                	mov    (%eax),%eax
 8d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e2:	76 d4                	jbe    8b8 <free+0x19>
 8e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e7:	8b 00                	mov    (%eax),%eax
 8e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ec:	76 ca                	jbe    8b8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f1:	8b 40 04             	mov    0x4(%eax),%eax
 8f4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fe:	01 c2                	add    %eax,%edx
 900:	8b 45 fc             	mov    -0x4(%ebp),%eax
 903:	8b 00                	mov    (%eax),%eax
 905:	39 c2                	cmp    %eax,%edx
 907:	75 24                	jne    92d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 909:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90c:	8b 50 04             	mov    0x4(%eax),%edx
 90f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 912:	8b 00                	mov    (%eax),%eax
 914:	8b 40 04             	mov    0x4(%eax),%eax
 917:	01 c2                	add    %eax,%edx
 919:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	8b 10                	mov    (%eax),%edx
 926:	8b 45 f8             	mov    -0x8(%ebp),%eax
 929:	89 10                	mov    %edx,(%eax)
 92b:	eb 0a                	jmp    937 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 92d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 930:	8b 10                	mov    (%eax),%edx
 932:	8b 45 f8             	mov    -0x8(%ebp),%eax
 935:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 937:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93a:	8b 40 04             	mov    0x4(%eax),%eax
 93d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 944:	8b 45 fc             	mov    -0x4(%ebp),%eax
 947:	01 d0                	add    %edx,%eax
 949:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94c:	75 20                	jne    96e <free+0xcf>
    p->s.size += bp->s.size;
 94e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 951:	8b 50 04             	mov    0x4(%eax),%edx
 954:	8b 45 f8             	mov    -0x8(%ebp),%eax
 957:	8b 40 04             	mov    0x4(%eax),%eax
 95a:	01 c2                	add    %eax,%edx
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 962:	8b 45 f8             	mov    -0x8(%ebp),%eax
 965:	8b 10                	mov    (%eax),%edx
 967:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96a:	89 10                	mov    %edx,(%eax)
 96c:	eb 08                	jmp    976 <free+0xd7>
  } else
    p->s.ptr = bp;
 96e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 971:	8b 55 f8             	mov    -0x8(%ebp),%edx
 974:	89 10                	mov    %edx,(%eax)
  freep = p;
 976:	8b 45 fc             	mov    -0x4(%ebp),%eax
 979:	a3 50 0e 00 00       	mov    %eax,0xe50
}
 97e:	90                   	nop
 97f:	c9                   	leave  
 980:	c3                   	ret    

00000981 <morecore>:

static Header*
morecore(uint nu)
{
 981:	55                   	push   %ebp
 982:	89 e5                	mov    %esp,%ebp
 984:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 987:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 98e:	77 07                	ja     997 <morecore+0x16>
    nu = 4096;
 990:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 997:	8b 45 08             	mov    0x8(%ebp),%eax
 99a:	c1 e0 03             	shl    $0x3,%eax
 99d:	83 ec 0c             	sub    $0xc,%esp
 9a0:	50                   	push   %eax
 9a1:	e8 19 fc ff ff       	call   5bf <sbrk>
 9a6:	83 c4 10             	add    $0x10,%esp
 9a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9b0:	75 07                	jne    9b9 <morecore+0x38>
    return 0;
 9b2:	b8 00 00 00 00       	mov    $0x0,%eax
 9b7:	eb 26                	jmp    9df <morecore+0x5e>
  hp = (Header*)p;
 9b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c2:	8b 55 08             	mov    0x8(%ebp),%edx
 9c5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cb:	83 c0 08             	add    $0x8,%eax
 9ce:	83 ec 0c             	sub    $0xc,%esp
 9d1:	50                   	push   %eax
 9d2:	e8 c8 fe ff ff       	call   89f <free>
 9d7:	83 c4 10             	add    $0x10,%esp
  return freep;
 9da:	a1 50 0e 00 00       	mov    0xe50,%eax
}
 9df:	c9                   	leave  
 9e0:	c3                   	ret    

000009e1 <malloc>:

void*
malloc(uint nbytes)
{
 9e1:	55                   	push   %ebp
 9e2:	89 e5                	mov    %esp,%ebp
 9e4:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ea:	83 c0 07             	add    $0x7,%eax
 9ed:	c1 e8 03             	shr    $0x3,%eax
 9f0:	83 c0 01             	add    $0x1,%eax
 9f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9f6:	a1 50 0e 00 00       	mov    0xe50,%eax
 9fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a02:	75 23                	jne    a27 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a04:	c7 45 f0 48 0e 00 00 	movl   $0xe48,-0x10(%ebp)
 a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0e:	a3 50 0e 00 00       	mov    %eax,0xe50
 a13:	a1 50 0e 00 00       	mov    0xe50,%eax
 a18:	a3 48 0e 00 00       	mov    %eax,0xe48
    base.s.size = 0;
 a1d:	c7 05 4c 0e 00 00 00 	movl   $0x0,0xe4c
 a24:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2a:	8b 00                	mov    (%eax),%eax
 a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a32:	8b 40 04             	mov    0x4(%eax),%eax
 a35:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a38:	72 4d                	jb     a87 <malloc+0xa6>
      if(p->s.size == nunits)
 a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3d:	8b 40 04             	mov    0x4(%eax),%eax
 a40:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a43:	75 0c                	jne    a51 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a48:	8b 10                	mov    (%eax),%edx
 a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4d:	89 10                	mov    %edx,(%eax)
 a4f:	eb 26                	jmp    a77 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a54:	8b 40 04             	mov    0x4(%eax),%eax
 a57:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a5a:	89 c2                	mov    %eax,%edx
 a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a65:	8b 40 04             	mov    0x4(%eax),%eax
 a68:	c1 e0 03             	shl    $0x3,%eax
 a6b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a71:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a74:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7a:	a3 50 0e 00 00       	mov    %eax,0xe50
      return (void*)(p + 1);
 a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a82:	83 c0 08             	add    $0x8,%eax
 a85:	eb 3b                	jmp    ac2 <malloc+0xe1>
    }
    if(p == freep)
 a87:	a1 50 0e 00 00       	mov    0xe50,%eax
 a8c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a8f:	75 1e                	jne    aaf <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a91:	83 ec 0c             	sub    $0xc,%esp
 a94:	ff 75 ec             	pushl  -0x14(%ebp)
 a97:	e8 e5 fe ff ff       	call   981 <morecore>
 a9c:	83 c4 10             	add    $0x10,%esp
 a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aa6:	75 07                	jne    aaf <malloc+0xce>
        return 0;
 aa8:	b8 00 00 00 00       	mov    $0x0,%eax
 aad:	eb 13                	jmp    ac2 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab8:	8b 00                	mov    (%eax),%eax
 aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 abd:	e9 6d ff ff ff       	jmp    a2f <malloc+0x4e>
}
 ac2:	c9                   	leave  
 ac3:	c3                   	ret    
