
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
  31:	68 9c 0a 00 00       	push   $0xa9c
  36:	6a 02                	push   $0x2
  38:	e8 a7 06 00 00       	call   6e4 <printf>
  3d:	83 c4 10             	add    $0x10,%esp
    exit();
  40:	e8 c8 04 00 00       	call   50d <exit>
  }

  mode = argv[1];
  45:	8b 43 04             	mov    0x4(%ebx),%eax
  48:	8b 40 04             	mov    0x4(%eax),%eax
  4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (strlen(mode) != 4) {
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	ff 75 f0             	pushl  -0x10(%ebp)
  54:	e8 1f 02 00 00       	call   278 <strlen>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	83 f8 04             	cmp    $0x4,%eax
  5f:	74 17                	je     78 <main+0x78>
    printf(2, "ERROR: chmod expects a MODE of length 4.\n");
  61:	83 ec 08             	sub    $0x8,%esp
  64:	68 c8 0a 00 00       	push   $0xac8
  69:	6a 02                	push   $0x2
  6b:	e8 74 06 00 00       	call   6e4 <printf>
  70:	83 c4 10             	add    $0x10,%esp
    exit();
  73:	e8 95 04 00 00       	call   50d <exit>
  }

  file = argv[2];
  78:	8b 43 04             	mov    0x4(%ebx),%eax
  7b:	8b 40 08             	mov    0x8(%eax),%eax
  7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (strlen(file) < 1 || !file) {
  81:	83 ec 0c             	sub    $0xc,%esp
  84:	ff 75 ec             	pushl  -0x14(%ebp)
  87:	e8 ec 01 00 00       	call   278 <strlen>
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	85 c0                	test   %eax,%eax
  91:	74 06                	je     99 <main+0x99>
  93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  97:	75 17                	jne    b0 <main+0xb0>
    printf(2, "ERROR: chmod expects a file as its second arg.\n");
  99:	83 ec 08             	sub    $0x8,%esp
  9c:	68 f4 0a 00 00       	push   $0xaf4
  a1:	6a 02                	push   $0x2
  a3:	e8 3c 06 00 00       	call   6e4 <printf>
  a8:	83 c4 10             	add    $0x10,%esp
    exit();
  ab:	e8 5d 04 00 00       	call   50d <exit>
  }

  // XV6 code START
  // verify mode in correct range: 0000 - 1777 octal.
  if (!(mode[0] == '0' || mode[0] == '1'))
  b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b3:	0f b6 00             	movzbl (%eax),%eax
  b6:	3c 30                	cmp    $0x30,%al
  b8:	74 14                	je     ce <main+0xce>
  ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  bd:	0f b6 00             	movzbl (%eax),%eax
  c0:	3c 31                	cmp    $0x31,%al
  c2:	74 0a                	je     ce <main+0xce>
    return -1;
  c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  c9:	e9 0b 01 00 00       	jmp    1d9 <main+0x1d9>
  if (!(mode[1] >= '0' && mode[1] <= '7'))
  ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  d1:	83 c0 01             	add    $0x1,%eax
  d4:	0f b6 00             	movzbl (%eax),%eax
  d7:	3c 2f                	cmp    $0x2f,%al
  d9:	7e 0d                	jle    e8 <main+0xe8>
  db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  de:	83 c0 01             	add    $0x1,%eax
  e1:	0f b6 00             	movzbl (%eax),%eax
  e4:	3c 37                	cmp    $0x37,%al
  e6:	7e 0a                	jle    f2 <main+0xf2>
    return -1;
  e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ed:	e9 e7 00 00 00       	jmp    1d9 <main+0x1d9>
  if (!(mode[2] >= '0' && mode[2] <= '7'))
  f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f5:	83 c0 02             	add    $0x2,%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	3c 2f                	cmp    $0x2f,%al
  fd:	7e 0d                	jle    10c <main+0x10c>
  ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 102:	83 c0 02             	add    $0x2,%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	3c 37                	cmp    $0x37,%al
 10a:	7e 0a                	jle    116 <main+0x116>
    return -1;
 10c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 111:	e9 c3 00 00 00       	jmp    1d9 <main+0x1d9>
  if (!(mode[3] >= '0' && mode[3] <= '7'))
 116:	8b 45 f0             	mov    -0x10(%ebp),%eax
 119:	83 c0 03             	add    $0x3,%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	3c 2f                	cmp    $0x2f,%al
 121:	7e 0d                	jle    130 <main+0x130>
 123:	8b 45 f0             	mov    -0x10(%ebp),%eax
 126:	83 c0 03             	add    $0x3,%eax
 129:	0f b6 00             	movzbl (%eax),%eax
 12c:	3c 37                	cmp    $0x37,%al
 12e:	7e 0a                	jle    13a <main+0x13a>
    return -1;
 130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 135:	e9 9f 00 00 00       	jmp    1d9 <main+0x1d9>

  // convert octal to decimal.  we have no pow() function
  imode += ((int)(mode[0] - '0') * (8*8*8));
 13a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 13d:	0f b6 00             	movzbl (%eax),%eax
 140:	0f be c0             	movsbl %al,%eax
 143:	83 e8 30             	sub    $0x30,%eax
 146:	c1 e0 09             	shl    $0x9,%eax
 149:	01 45 f4             	add    %eax,-0xc(%ebp)
  imode += ((int)(mode[1] - '0') * (8*8));
 14c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 14f:	83 c0 01             	add    $0x1,%eax
 152:	0f b6 00             	movzbl (%eax),%eax
 155:	0f be c0             	movsbl %al,%eax
 158:	83 e8 30             	sub    $0x30,%eax
 15b:	c1 e0 06             	shl    $0x6,%eax
 15e:	01 45 f4             	add    %eax,-0xc(%ebp)
  imode += ((int)(mode[2] - '0') * (8));
 161:	8b 45 f0             	mov    -0x10(%ebp),%eax
 164:	83 c0 02             	add    $0x2,%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	0f be c0             	movsbl %al,%eax
 16d:	83 e8 30             	sub    $0x30,%eax
 170:	c1 e0 03             	shl    $0x3,%eax
 173:	01 45 f4             	add    %eax,-0xc(%ebp)
  imode +=  (int)(mode[3] - '0');
 176:	8b 45 f0             	mov    -0x10(%ebp),%eax
 179:	83 c0 03             	add    $0x3,%eax
 17c:	0f b6 00             	movzbl (%eax),%eax
 17f:	0f be d0             	movsbl %al,%edx
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	01 d0                	add    %edx,%eax
 187:	83 e8 30             	sub    $0x30,%eax
 18a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //XV6 code END

  printf(1, "String in octal is %s and decimal is %d\n", mode, imode);
 18d:	ff 75 f4             	pushl  -0xc(%ebp)
 190:	ff 75 f0             	pushl  -0x10(%ebp)
 193:	68 24 0b 00 00       	push   $0xb24
 198:	6a 01                	push   $0x1
 19a:	e8 45 05 00 00       	call   6e4 <printf>
 19f:	83 c4 10             	add    $0x10,%esp

  int rc = chmod(file, imode);
 1a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	50                   	push   %eax
 1a9:	ff 75 ec             	pushl  -0x14(%ebp)
 1ac:	e8 44 04 00 00       	call   5f5 <chmod>
 1b1:	83 c4 10             	add    $0x10,%esp
 1b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (rc < 0) {
 1b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 1bb:	79 17                	jns    1d4 <main+0x1d4>
    printf(2, "ERROR: chmod failed.\n");
 1bd:	83 ec 08             	sub    $0x8,%esp
 1c0:	68 4d 0b 00 00       	push   $0xb4d
 1c5:	6a 02                	push   $0x2
 1c7:	e8 18 05 00 00       	call   6e4 <printf>
 1cc:	83 c4 10             	add    $0x10,%esp
    exit();
 1cf:	e8 39 03 00 00       	call   50d <exit>
  }
  exit();
 1d4:	e8 34 03 00 00       	call   50d <exit>
}
 1d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1dc:	59                   	pop    %ecx
 1dd:	5b                   	pop    %ebx
 1de:	5d                   	pop    %ebp
 1df:	8d 61 fc             	lea    -0x4(%ecx),%esp
 1e2:	c3                   	ret    

000001e3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	57                   	push   %edi
 1e7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1eb:	8b 55 10             	mov    0x10(%ebp),%edx
 1ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f1:	89 cb                	mov    %ecx,%ebx
 1f3:	89 df                	mov    %ebx,%edi
 1f5:	89 d1                	mov    %edx,%ecx
 1f7:	fc                   	cld    
 1f8:	f3 aa                	rep stos %al,%es:(%edi)
 1fa:	89 ca                	mov    %ecx,%edx
 1fc:	89 fb                	mov    %edi,%ebx
 1fe:	89 5d 08             	mov    %ebx,0x8(%ebp)
 201:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 204:	90                   	nop
 205:	5b                   	pop    %ebx
 206:	5f                   	pop    %edi
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    

00000209 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 215:	90                   	nop
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 08             	mov    %edx,0x8(%ebp)
 21f:	8b 55 0c             	mov    0xc(%ebp),%edx
 222:	8d 4a 01             	lea    0x1(%edx),%ecx
 225:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 228:	0f b6 12             	movzbl (%edx),%edx
 22b:	88 10                	mov    %dl,(%eax)
 22d:	0f b6 00             	movzbl (%eax),%eax
 230:	84 c0                	test   %al,%al
 232:	75 e2                	jne    216 <strcpy+0xd>
    ;
  return os;
 234:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 23c:	eb 08                	jmp    246 <strcmp+0xd>
    p++, q++;
 23e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 242:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	84 c0                	test   %al,%al
 24e:	74 10                	je     260 <strcmp+0x27>
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	0f b6 10             	movzbl (%eax),%edx
 256:	8b 45 0c             	mov    0xc(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	38 c2                	cmp    %al,%dl
 25e:	74 de                	je     23e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	0f b6 d0             	movzbl %al,%edx
 269:	8b 45 0c             	mov    0xc(%ebp),%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	0f b6 c0             	movzbl %al,%eax
 272:	29 c2                	sub    %eax,%edx
 274:	89 d0                	mov    %edx,%eax
}
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    

00000278 <strlen>:

uint
strlen(char *s)
{
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
 27b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 27e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 285:	eb 04                	jmp    28b <strlen+0x13>
 287:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 28b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	01 d0                	add    %edx,%eax
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	84 c0                	test   %al,%al
 298:	75 ed                	jne    287 <strlen+0xf>
    ;
  return n;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <memset>:

void*
memset(void *dst, int c, uint n)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	50                   	push   %eax
 2a6:	ff 75 0c             	pushl  0xc(%ebp)
 2a9:	ff 75 08             	pushl  0x8(%ebp)
 2ac:	e8 32 ff ff ff       	call   1e3 <stosb>
 2b1:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b7:	c9                   	leave  
 2b8:	c3                   	ret    

000002b9 <strchr>:

char*
strchr(const char *s, char c)
{
 2b9:	55                   	push   %ebp
 2ba:	89 e5                	mov    %esp,%ebp
 2bc:	83 ec 04             	sub    $0x4,%esp
 2bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2c5:	eb 14                	jmp    2db <strchr+0x22>
    if(*s == c)
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	0f b6 00             	movzbl (%eax),%eax
 2cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2d0:	75 05                	jne    2d7 <strchr+0x1e>
      return (char*)s;
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	eb 13                	jmp    2ea <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	84 c0                	test   %al,%al
 2e3:	75 e2                	jne    2c7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ea:	c9                   	leave  
 2eb:	c3                   	ret    

000002ec <gets>:

char*
gets(char *buf, int max)
{
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2f9:	eb 42                	jmp    33d <gets+0x51>
    cc = read(0, &c, 1);
 2fb:	83 ec 04             	sub    $0x4,%esp
 2fe:	6a 01                	push   $0x1
 300:	8d 45 ef             	lea    -0x11(%ebp),%eax
 303:	50                   	push   %eax
 304:	6a 00                	push   $0x0
 306:	e8 1a 02 00 00       	call   525 <read>
 30b:	83 c4 10             	add    $0x10,%esp
 30e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 311:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 315:	7e 33                	jle    34a <gets+0x5e>
      break;
    buf[i++] = c;
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	8d 50 01             	lea    0x1(%eax),%edx
 31d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 320:	89 c2                	mov    %eax,%edx
 322:	8b 45 08             	mov    0x8(%ebp),%eax
 325:	01 c2                	add    %eax,%edx
 327:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 32d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 331:	3c 0a                	cmp    $0xa,%al
 333:	74 16                	je     34b <gets+0x5f>
 335:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 339:	3c 0d                	cmp    $0xd,%al
 33b:	74 0e                	je     34b <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 340:	83 c0 01             	add    $0x1,%eax
 343:	3b 45 0c             	cmp    0xc(%ebp),%eax
 346:	7c b3                	jl     2fb <gets+0xf>
 348:	eb 01                	jmp    34b <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 34a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 34b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	01 d0                	add    %edx,%eax
 353:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 356:	8b 45 08             	mov    0x8(%ebp),%eax
}
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <stat>:

int
stat(char *n, struct stat *st)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 361:	83 ec 08             	sub    $0x8,%esp
 364:	6a 00                	push   $0x0
 366:	ff 75 08             	pushl  0x8(%ebp)
 369:	e8 df 01 00 00       	call   54d <open>
 36e:	83 c4 10             	add    $0x10,%esp
 371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 378:	79 07                	jns    381 <stat+0x26>
    return -1;
 37a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 37f:	eb 25                	jmp    3a6 <stat+0x4b>
  r = fstat(fd, st);
 381:	83 ec 08             	sub    $0x8,%esp
 384:	ff 75 0c             	pushl  0xc(%ebp)
 387:	ff 75 f4             	pushl  -0xc(%ebp)
 38a:	e8 d6 01 00 00       	call   565 <fstat>
 38f:	83 c4 10             	add    $0x10,%esp
 392:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 395:	83 ec 0c             	sub    $0xc,%esp
 398:	ff 75 f4             	pushl  -0xc(%ebp)
 39b:	e8 95 01 00 00       	call   535 <close>
 3a0:	83 c4 10             	add    $0x10,%esp
  return r;
 3a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <atoi>:

int
atoi(const char *s)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 3b5:	eb 04                	jmp    3bb <atoi+0x13>
 3b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	0f b6 00             	movzbl (%eax),%eax
 3c1:	3c 20                	cmp    $0x20,%al
 3c3:	74 f2                	je     3b7 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3c5:	8b 45 08             	mov    0x8(%ebp),%eax
 3c8:	0f b6 00             	movzbl (%eax),%eax
 3cb:	3c 2d                	cmp    $0x2d,%al
 3cd:	75 07                	jne    3d6 <atoi+0x2e>
 3cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3d4:	eb 05                	jmp    3db <atoi+0x33>
 3d6:	b8 01 00 00 00       	mov    $0x1,%eax
 3db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	0f b6 00             	movzbl (%eax),%eax
 3e4:	3c 2b                	cmp    $0x2b,%al
 3e6:	74 0a                	je     3f2 <atoi+0x4a>
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	0f b6 00             	movzbl (%eax),%eax
 3ee:	3c 2d                	cmp    $0x2d,%al
 3f0:	75 2b                	jne    41d <atoi+0x75>
    s++;
 3f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3f6:	eb 25                	jmp    41d <atoi+0x75>
    n = n*10 + *s++ - '0';
 3f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3fb:	89 d0                	mov    %edx,%eax
 3fd:	c1 e0 02             	shl    $0x2,%eax
 400:	01 d0                	add    %edx,%eax
 402:	01 c0                	add    %eax,%eax
 404:	89 c1                	mov    %eax,%ecx
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	8d 50 01             	lea    0x1(%eax),%edx
 40c:	89 55 08             	mov    %edx,0x8(%ebp)
 40f:	0f b6 00             	movzbl (%eax),%eax
 412:	0f be c0             	movsbl %al,%eax
 415:	01 c8                	add    %ecx,%eax
 417:	83 e8 30             	sub    $0x30,%eax
 41a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
 420:	0f b6 00             	movzbl (%eax),%eax
 423:	3c 2f                	cmp    $0x2f,%al
 425:	7e 0a                	jle    431 <atoi+0x89>
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	0f b6 00             	movzbl (%eax),%eax
 42d:	3c 39                	cmp    $0x39,%al
 42f:	7e c7                	jle    3f8 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 431:	8b 45 f8             	mov    -0x8(%ebp),%eax
 434:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 438:	c9                   	leave  
 439:	c3                   	ret    

0000043a <atoo>:

int
atoo(const char *s)
{
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 447:	eb 04                	jmp    44d <atoo+0x13>
 449:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	0f b6 00             	movzbl (%eax),%eax
 453:	3c 20                	cmp    $0x20,%al
 455:	74 f2                	je     449 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	3c 2d                	cmp    $0x2d,%al
 45f:	75 07                	jne    468 <atoo+0x2e>
 461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 466:	eb 05                	jmp    46d <atoo+0x33>
 468:	b8 01 00 00 00       	mov    $0x1,%eax
 46d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 470:	8b 45 08             	mov    0x8(%ebp),%eax
 473:	0f b6 00             	movzbl (%eax),%eax
 476:	3c 2b                	cmp    $0x2b,%al
 478:	74 0a                	je     484 <atoo+0x4a>
 47a:	8b 45 08             	mov    0x8(%ebp),%eax
 47d:	0f b6 00             	movzbl (%eax),%eax
 480:	3c 2d                	cmp    $0x2d,%al
 482:	75 27                	jne    4ab <atoo+0x71>
    s++;
 484:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 488:	eb 21                	jmp    4ab <atoo+0x71>
    n = n*8 + *s++ - '0';
 48a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 48d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	8d 50 01             	lea    0x1(%eax),%edx
 49a:	89 55 08             	mov    %edx,0x8(%ebp)
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	0f be c0             	movsbl %al,%eax
 4a3:	01 c8                	add    %ecx,%eax
 4a5:	83 e8 30             	sub    $0x30,%eax
 4a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	0f b6 00             	movzbl (%eax),%eax
 4b1:	3c 2f                	cmp    $0x2f,%al
 4b3:	7e 0a                	jle    4bf <atoo+0x85>
 4b5:	8b 45 08             	mov    0x8(%ebp),%eax
 4b8:	0f b6 00             	movzbl (%eax),%eax
 4bb:	3c 37                	cmp    $0x37,%al
 4bd:	7e cb                	jle    48a <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 4bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4c2:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4c6:	c9                   	leave  
 4c7:	c3                   	ret    

000004c8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4c8:	55                   	push   %ebp
 4c9:	89 e5                	mov    %esp,%ebp
 4cb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4da:	eb 17                	jmp    4f3 <memmove+0x2b>
    *dst++ = *src++;
 4dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4df:	8d 50 01             	lea    0x1(%eax),%edx
 4e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4e8:	8d 4a 01             	lea    0x1(%edx),%ecx
 4eb:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4ee:	0f b6 12             	movzbl (%edx),%edx
 4f1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4f3:	8b 45 10             	mov    0x10(%ebp),%eax
 4f6:	8d 50 ff             	lea    -0x1(%eax),%edx
 4f9:	89 55 10             	mov    %edx,0x10(%ebp)
 4fc:	85 c0                	test   %eax,%eax
 4fe:	7f dc                	jg     4dc <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 500:	8b 45 08             	mov    0x8(%ebp),%eax
}
 503:	c9                   	leave  
 504:	c3                   	ret    

00000505 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 505:	b8 01 00 00 00       	mov    $0x1,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <exit>:
SYSCALL(exit)
 50d:	b8 02 00 00 00       	mov    $0x2,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <wait>:
SYSCALL(wait)
 515:	b8 03 00 00 00       	mov    $0x3,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <pipe>:
SYSCALL(pipe)
 51d:	b8 04 00 00 00       	mov    $0x4,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <read>:
SYSCALL(read)
 525:	b8 05 00 00 00       	mov    $0x5,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <write>:
SYSCALL(write)
 52d:	b8 10 00 00 00       	mov    $0x10,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <close>:
SYSCALL(close)
 535:	b8 15 00 00 00       	mov    $0x15,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <kill>:
SYSCALL(kill)
 53d:	b8 06 00 00 00       	mov    $0x6,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <exec>:
SYSCALL(exec)
 545:	b8 07 00 00 00       	mov    $0x7,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <open>:
SYSCALL(open)
 54d:	b8 0f 00 00 00       	mov    $0xf,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <mknod>:
SYSCALL(mknod)
 555:	b8 11 00 00 00       	mov    $0x11,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <unlink>:
SYSCALL(unlink)
 55d:	b8 12 00 00 00       	mov    $0x12,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <fstat>:
SYSCALL(fstat)
 565:	b8 08 00 00 00       	mov    $0x8,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <link>:
SYSCALL(link)
 56d:	b8 13 00 00 00       	mov    $0x13,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <mkdir>:
SYSCALL(mkdir)
 575:	b8 14 00 00 00       	mov    $0x14,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <chdir>:
SYSCALL(chdir)
 57d:	b8 09 00 00 00       	mov    $0x9,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <dup>:
SYSCALL(dup)
 585:	b8 0a 00 00 00       	mov    $0xa,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <getpid>:
SYSCALL(getpid)
 58d:	b8 0b 00 00 00       	mov    $0xb,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <sbrk>:
SYSCALL(sbrk)
 595:	b8 0c 00 00 00       	mov    $0xc,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <sleep>:
SYSCALL(sleep)
 59d:	b8 0d 00 00 00       	mov    $0xd,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <uptime>:
SYSCALL(uptime)
 5a5:	b8 0e 00 00 00       	mov    $0xe,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <halt>:
SYSCALL(halt)
 5ad:	b8 16 00 00 00       	mov    $0x16,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <date>:
SYSCALL(date)        #p1
 5b5:	b8 17 00 00 00       	mov    $0x17,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <getuid>:
SYSCALL(getuid)      #p2
 5bd:	b8 18 00 00 00       	mov    $0x18,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <getgid>:
SYSCALL(getgid)      #p2
 5c5:	b8 19 00 00 00       	mov    $0x19,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <getppid>:
SYSCALL(getppid)     #p2
 5cd:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <setuid>:
SYSCALL(setuid)      #p2
 5d5:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <setgid>:
SYSCALL(setgid)      #p2
 5dd:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <getprocs>:
SYSCALL(getprocs)    #p2
 5e5:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <setpriority>:
SYSCALL(setpriority) #p4
 5ed:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <chmod>:
SYSCALL(chmod)       #p5
 5f5:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <chown>:
SYSCALL(chown)       #p5
 5fd:	b8 20 00 00 00       	mov    $0x20,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <chgrp>:
SYSCALL(chgrp)       #p5
 605:	b8 21 00 00 00       	mov    $0x21,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 60d:	55                   	push   %ebp
 60e:	89 e5                	mov    %esp,%ebp
 610:	83 ec 18             	sub    $0x18,%esp
 613:	8b 45 0c             	mov    0xc(%ebp),%eax
 616:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 619:	83 ec 04             	sub    $0x4,%esp
 61c:	6a 01                	push   $0x1
 61e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 621:	50                   	push   %eax
 622:	ff 75 08             	pushl  0x8(%ebp)
 625:	e8 03 ff ff ff       	call   52d <write>
 62a:	83 c4 10             	add    $0x10,%esp
}
 62d:	90                   	nop
 62e:	c9                   	leave  
 62f:	c3                   	ret    

00000630 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	53                   	push   %ebx
 634:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 637:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 63e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 642:	74 17                	je     65b <printint+0x2b>
 644:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 648:	79 11                	jns    65b <printint+0x2b>
    neg = 1;
 64a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 651:	8b 45 0c             	mov    0xc(%ebp),%eax
 654:	f7 d8                	neg    %eax
 656:	89 45 ec             	mov    %eax,-0x14(%ebp)
 659:	eb 06                	jmp    661 <printint+0x31>
  } else {
    x = xx;
 65b:	8b 45 0c             	mov    0xc(%ebp),%eax
 65e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 661:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 668:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 66b:	8d 41 01             	lea    0x1(%ecx),%eax
 66e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 671:	8b 5d 10             	mov    0x10(%ebp),%ebx
 674:	8b 45 ec             	mov    -0x14(%ebp),%eax
 677:	ba 00 00 00 00       	mov    $0x0,%edx
 67c:	f7 f3                	div    %ebx
 67e:	89 d0                	mov    %edx,%eax
 680:	0f b6 80 e8 0d 00 00 	movzbl 0xde8(%eax),%eax
 687:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 68b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 68e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 691:	ba 00 00 00 00       	mov    $0x0,%edx
 696:	f7 f3                	div    %ebx
 698:	89 45 ec             	mov    %eax,-0x14(%ebp)
 69b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 69f:	75 c7                	jne    668 <printint+0x38>
  if(neg)
 6a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6a5:	74 2d                	je     6d4 <printint+0xa4>
    buf[i++] = '-';
 6a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6aa:	8d 50 01             	lea    0x1(%eax),%edx
 6ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6b0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6b5:	eb 1d                	jmp    6d4 <printint+0xa4>
    putc(fd, buf[i]);
 6b7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bd:	01 d0                	add    %edx,%eax
 6bf:	0f b6 00             	movzbl (%eax),%eax
 6c2:	0f be c0             	movsbl %al,%eax
 6c5:	83 ec 08             	sub    $0x8,%esp
 6c8:	50                   	push   %eax
 6c9:	ff 75 08             	pushl  0x8(%ebp)
 6cc:	e8 3c ff ff ff       	call   60d <putc>
 6d1:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6d4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6dc:	79 d9                	jns    6b7 <printint+0x87>
    putc(fd, buf[i]);
}
 6de:	90                   	nop
 6df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6e2:	c9                   	leave  
 6e3:	c3                   	ret    

000006e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6f1:	8d 45 0c             	lea    0xc(%ebp),%eax
 6f4:	83 c0 04             	add    $0x4,%eax
 6f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 701:	e9 59 01 00 00       	jmp    85f <printf+0x17b>
    c = fmt[i] & 0xff;
 706:	8b 55 0c             	mov    0xc(%ebp),%edx
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	01 d0                	add    %edx,%eax
 70e:	0f b6 00             	movzbl (%eax),%eax
 711:	0f be c0             	movsbl %al,%eax
 714:	25 ff 00 00 00       	and    $0xff,%eax
 719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 71c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 720:	75 2c                	jne    74e <printf+0x6a>
      if(c == '%'){
 722:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 726:	75 0c                	jne    734 <printf+0x50>
        state = '%';
 728:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 72f:	e9 27 01 00 00       	jmp    85b <printf+0x177>
      } else {
        putc(fd, c);
 734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 737:	0f be c0             	movsbl %al,%eax
 73a:	83 ec 08             	sub    $0x8,%esp
 73d:	50                   	push   %eax
 73e:	ff 75 08             	pushl  0x8(%ebp)
 741:	e8 c7 fe ff ff       	call   60d <putc>
 746:	83 c4 10             	add    $0x10,%esp
 749:	e9 0d 01 00 00       	jmp    85b <printf+0x177>
      }
    } else if(state == '%'){
 74e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 752:	0f 85 03 01 00 00    	jne    85b <printf+0x177>
      if(c == 'd'){
 758:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 75c:	75 1e                	jne    77c <printf+0x98>
        printint(fd, *ap, 10, 1);
 75e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 761:	8b 00                	mov    (%eax),%eax
 763:	6a 01                	push   $0x1
 765:	6a 0a                	push   $0xa
 767:	50                   	push   %eax
 768:	ff 75 08             	pushl  0x8(%ebp)
 76b:	e8 c0 fe ff ff       	call   630 <printint>
 770:	83 c4 10             	add    $0x10,%esp
        ap++;
 773:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 777:	e9 d8 00 00 00       	jmp    854 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 77c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 780:	74 06                	je     788 <printf+0xa4>
 782:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 786:	75 1e                	jne    7a6 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 788:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78b:	8b 00                	mov    (%eax),%eax
 78d:	6a 00                	push   $0x0
 78f:	6a 10                	push   $0x10
 791:	50                   	push   %eax
 792:	ff 75 08             	pushl  0x8(%ebp)
 795:	e8 96 fe ff ff       	call   630 <printint>
 79a:	83 c4 10             	add    $0x10,%esp
        ap++;
 79d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a1:	e9 ae 00 00 00       	jmp    854 <printf+0x170>
      } else if(c == 's'){
 7a6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7aa:	75 43                	jne    7ef <printf+0x10b>
        s = (char*)*ap;
 7ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7af:	8b 00                	mov    (%eax),%eax
 7b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7bc:	75 25                	jne    7e3 <printf+0xff>
          s = "(null)";
 7be:	c7 45 f4 63 0b 00 00 	movl   $0xb63,-0xc(%ebp)
        while(*s != 0){
 7c5:	eb 1c                	jmp    7e3 <printf+0xff>
          putc(fd, *s);
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	0f b6 00             	movzbl (%eax),%eax
 7cd:	0f be c0             	movsbl %al,%eax
 7d0:	83 ec 08             	sub    $0x8,%esp
 7d3:	50                   	push   %eax
 7d4:	ff 75 08             	pushl  0x8(%ebp)
 7d7:	e8 31 fe ff ff       	call   60d <putc>
 7dc:	83 c4 10             	add    $0x10,%esp
          s++;
 7df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	0f b6 00             	movzbl (%eax),%eax
 7e9:	84 c0                	test   %al,%al
 7eb:	75 da                	jne    7c7 <printf+0xe3>
 7ed:	eb 65                	jmp    854 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ef:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7f3:	75 1d                	jne    812 <printf+0x12e>
        putc(fd, *ap);
 7f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f8:	8b 00                	mov    (%eax),%eax
 7fa:	0f be c0             	movsbl %al,%eax
 7fd:	83 ec 08             	sub    $0x8,%esp
 800:	50                   	push   %eax
 801:	ff 75 08             	pushl  0x8(%ebp)
 804:	e8 04 fe ff ff       	call   60d <putc>
 809:	83 c4 10             	add    $0x10,%esp
        ap++;
 80c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 810:	eb 42                	jmp    854 <printf+0x170>
      } else if(c == '%'){
 812:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 816:	75 17                	jne    82f <printf+0x14b>
        putc(fd, c);
 818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 81b:	0f be c0             	movsbl %al,%eax
 81e:	83 ec 08             	sub    $0x8,%esp
 821:	50                   	push   %eax
 822:	ff 75 08             	pushl  0x8(%ebp)
 825:	e8 e3 fd ff ff       	call   60d <putc>
 82a:	83 c4 10             	add    $0x10,%esp
 82d:	eb 25                	jmp    854 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 82f:	83 ec 08             	sub    $0x8,%esp
 832:	6a 25                	push   $0x25
 834:	ff 75 08             	pushl  0x8(%ebp)
 837:	e8 d1 fd ff ff       	call   60d <putc>
 83c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 83f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 842:	0f be c0             	movsbl %al,%eax
 845:	83 ec 08             	sub    $0x8,%esp
 848:	50                   	push   %eax
 849:	ff 75 08             	pushl  0x8(%ebp)
 84c:	e8 bc fd ff ff       	call   60d <putc>
 851:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 854:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 85b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 85f:	8b 55 0c             	mov    0xc(%ebp),%edx
 862:	8b 45 f0             	mov    -0x10(%ebp),%eax
 865:	01 d0                	add    %edx,%eax
 867:	0f b6 00             	movzbl (%eax),%eax
 86a:	84 c0                	test   %al,%al
 86c:	0f 85 94 fe ff ff    	jne    706 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 872:	90                   	nop
 873:	c9                   	leave  
 874:	c3                   	ret    

00000875 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 875:	55                   	push   %ebp
 876:	89 e5                	mov    %esp,%ebp
 878:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 87b:	8b 45 08             	mov    0x8(%ebp),%eax
 87e:	83 e8 08             	sub    $0x8,%eax
 881:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 884:	a1 04 0e 00 00       	mov    0xe04,%eax
 889:	89 45 fc             	mov    %eax,-0x4(%ebp)
 88c:	eb 24                	jmp    8b2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 891:	8b 00                	mov    (%eax),%eax
 893:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 896:	77 12                	ja     8aa <free+0x35>
 898:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 89e:	77 24                	ja     8c4 <free+0x4f>
 8a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a3:	8b 00                	mov    (%eax),%eax
 8a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8a8:	77 1a                	ja     8c4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ad:	8b 00                	mov    (%eax),%eax
 8af:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b8:	76 d4                	jbe    88e <free+0x19>
 8ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bd:	8b 00                	mov    (%eax),%eax
 8bf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8c2:	76 ca                	jbe    88e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d4:	01 c2                	add    %eax,%edx
 8d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	39 c2                	cmp    %eax,%edx
 8dd:	75 24                	jne    903 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e2:	8b 50 04             	mov    0x4(%eax),%edx
 8e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e8:	8b 00                	mov    (%eax),%eax
 8ea:	8b 40 04             	mov    0x4(%eax),%eax
 8ed:	01 c2                	add    %eax,%edx
 8ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f8:	8b 00                	mov    (%eax),%eax
 8fa:	8b 10                	mov    (%eax),%edx
 8fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ff:	89 10                	mov    %edx,(%eax)
 901:	eb 0a                	jmp    90d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 903:	8b 45 fc             	mov    -0x4(%ebp),%eax
 906:	8b 10                	mov    (%eax),%edx
 908:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	8b 40 04             	mov    0x4(%eax),%eax
 913:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 91a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91d:	01 d0                	add    %edx,%eax
 91f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 922:	75 20                	jne    944 <free+0xcf>
    p->s.size += bp->s.size;
 924:	8b 45 fc             	mov    -0x4(%ebp),%eax
 927:	8b 50 04             	mov    0x4(%eax),%edx
 92a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92d:	8b 40 04             	mov    0x4(%eax),%eax
 930:	01 c2                	add    %eax,%edx
 932:	8b 45 fc             	mov    -0x4(%ebp),%eax
 935:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 938:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93b:	8b 10                	mov    (%eax),%edx
 93d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 940:	89 10                	mov    %edx,(%eax)
 942:	eb 08                	jmp    94c <free+0xd7>
  } else
    p->s.ptr = bp;
 944:	8b 45 fc             	mov    -0x4(%ebp),%eax
 947:	8b 55 f8             	mov    -0x8(%ebp),%edx
 94a:	89 10                	mov    %edx,(%eax)
  freep = p;
 94c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94f:	a3 04 0e 00 00       	mov    %eax,0xe04
}
 954:	90                   	nop
 955:	c9                   	leave  
 956:	c3                   	ret    

00000957 <morecore>:

static Header*
morecore(uint nu)
{
 957:	55                   	push   %ebp
 958:	89 e5                	mov    %esp,%ebp
 95a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 95d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 964:	77 07                	ja     96d <morecore+0x16>
    nu = 4096;
 966:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 96d:	8b 45 08             	mov    0x8(%ebp),%eax
 970:	c1 e0 03             	shl    $0x3,%eax
 973:	83 ec 0c             	sub    $0xc,%esp
 976:	50                   	push   %eax
 977:	e8 19 fc ff ff       	call   595 <sbrk>
 97c:	83 c4 10             	add    $0x10,%esp
 97f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 982:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 986:	75 07                	jne    98f <morecore+0x38>
    return 0;
 988:	b8 00 00 00 00       	mov    $0x0,%eax
 98d:	eb 26                	jmp    9b5 <morecore+0x5e>
  hp = (Header*)p;
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 995:	8b 45 f0             	mov    -0x10(%ebp),%eax
 998:	8b 55 08             	mov    0x8(%ebp),%edx
 99b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 99e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a1:	83 c0 08             	add    $0x8,%eax
 9a4:	83 ec 0c             	sub    $0xc,%esp
 9a7:	50                   	push   %eax
 9a8:	e8 c8 fe ff ff       	call   875 <free>
 9ad:	83 c4 10             	add    $0x10,%esp
  return freep;
 9b0:	a1 04 0e 00 00       	mov    0xe04,%eax
}
 9b5:	c9                   	leave  
 9b6:	c3                   	ret    

000009b7 <malloc>:

void*
malloc(uint nbytes)
{
 9b7:	55                   	push   %ebp
 9b8:	89 e5                	mov    %esp,%ebp
 9ba:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9bd:	8b 45 08             	mov    0x8(%ebp),%eax
 9c0:	83 c0 07             	add    $0x7,%eax
 9c3:	c1 e8 03             	shr    $0x3,%eax
 9c6:	83 c0 01             	add    $0x1,%eax
 9c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9cc:	a1 04 0e 00 00       	mov    0xe04,%eax
 9d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9d8:	75 23                	jne    9fd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9da:	c7 45 f0 fc 0d 00 00 	movl   $0xdfc,-0x10(%ebp)
 9e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e4:	a3 04 0e 00 00       	mov    %eax,0xe04
 9e9:	a1 04 0e 00 00       	mov    0xe04,%eax
 9ee:	a3 fc 0d 00 00       	mov    %eax,0xdfc
    base.s.size = 0;
 9f3:	c7 05 00 0e 00 00 00 	movl   $0x0,0xe00
 9fa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a00:	8b 00                	mov    (%eax),%eax
 a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a08:	8b 40 04             	mov    0x4(%eax),%eax
 a0b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a0e:	72 4d                	jb     a5d <malloc+0xa6>
      if(p->s.size == nunits)
 a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a13:	8b 40 04             	mov    0x4(%eax),%eax
 a16:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a19:	75 0c                	jne    a27 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1e:	8b 10                	mov    (%eax),%edx
 a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a23:	89 10                	mov    %edx,(%eax)
 a25:	eb 26                	jmp    a4d <malloc+0x96>
      else {
        p->s.size -= nunits;
 a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2a:	8b 40 04             	mov    0x4(%eax),%eax
 a2d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a30:	89 c2                	mov    %eax,%edx
 a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a35:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3b:	8b 40 04             	mov    0x4(%eax),%eax
 a3e:	c1 e0 03             	shl    $0x3,%eax
 a41:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a47:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a4a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a50:	a3 04 0e 00 00       	mov    %eax,0xe04
      return (void*)(p + 1);
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	83 c0 08             	add    $0x8,%eax
 a5b:	eb 3b                	jmp    a98 <malloc+0xe1>
    }
    if(p == freep)
 a5d:	a1 04 0e 00 00       	mov    0xe04,%eax
 a62:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a65:	75 1e                	jne    a85 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a67:	83 ec 0c             	sub    $0xc,%esp
 a6a:	ff 75 ec             	pushl  -0x14(%ebp)
 a6d:	e8 e5 fe ff ff       	call   957 <morecore>
 a72:	83 c4 10             	add    $0x10,%esp
 a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a7c:	75 07                	jne    a85 <malloc+0xce>
        return 0;
 a7e:	b8 00 00 00 00       	mov    $0x0,%eax
 a83:	eb 13                	jmp    a98 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8e:	8b 00                	mov    (%eax),%eax
 a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a93:	e9 6d ff ff ff       	jmp    a05 <malloc+0x4e>
}
 a98:	c9                   	leave  
 a99:	c3                   	ret    
