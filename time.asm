
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

// Take in commandline args to process
int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 20             	sub    $0x20,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int f = fork(); 
  14:	e8 63 03 00 00       	call   37c <fork>
  19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int before = uptime();
  1c:	e8 fb 03 00 00       	call   41c <uptime>
  21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int after = 0;
  24:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  if (f < 0)
  2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  2f:	79 17                	jns    48 <main+0x48>
    printf(2, "Fork failed.");
  31:	83 ec 08             	sub    $0x8,%esp
  34:	68 f1 08 00 00       	push   $0x8f1
  39:	6a 02                	push   $0x2
  3b:	e8 fb 04 00 00       	call   53b <printf>
  40:	83 c4 10             	add    $0x10,%esp
  43:	e9 9b 00 00 00       	jmp    e3 <main+0xe3>
  else if (f == 0)
  48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4c:	75 1a                	jne    68 <main+0x68>
  {
    argv++;
  4e:	83 43 04 04          	addl   $0x4,0x4(%ebx)
    exec(argv[0], argv);
  52:	8b 43 04             	mov    0x4(%ebx),%eax
  55:	8b 00                	mov    (%eax),%eax
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	ff 73 04             	pushl  0x4(%ebx)
  5d:	50                   	push   %eax
  5e:	e8 59 03 00 00       	call   3bc <exec>
  63:	83 c4 10             	add    $0x10,%esp
  66:	eb 7b                	jmp    e3 <main+0xe3>
  } else {
    wait();
  68:	e8 1f 03 00 00       	call   38c <wait>
    after = uptime();
  6d:	e8 aa 03 00 00       	call   41c <uptime>
  72:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int secs = (after-before)/100;
  75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  78:	2b 45 f0             	sub    -0x10(%ebp),%eax
  7b:	89 c1                	mov    %eax,%ecx
  7d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  82:	89 c8                	mov    %ecx,%eax
  84:	f7 ea                	imul   %edx
  86:	c1 fa 05             	sar    $0x5,%edx
  89:	89 c8                	mov    %ecx,%eax
  8b:	c1 f8 1f             	sar    $0x1f,%eax
  8e:	29 c2                	sub    %eax,%edx
  90:	89 d0                	mov    %edx,%eax
  92:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int p_secs = (after-before)%100;
  95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  98:	2b 45 f0             	sub    -0x10(%ebp),%eax
  9b:	89 c1                	mov    %eax,%ecx
  9d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  a2:	89 c8                	mov    %ecx,%eax
  a4:	f7 ea                	imul   %edx
  a6:	c1 fa 05             	sar    $0x5,%edx
  a9:	89 c8                	mov    %ecx,%eax
  ab:	c1 f8 1f             	sar    $0x1f,%eax
  ae:	29 c2                	sub    %eax,%edx
  b0:	89 d0                	mov    %edx,%eax
  b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  b8:	6b c0 64             	imul   $0x64,%eax,%eax
  bb:	29 c1                	sub    %eax,%ecx
  bd:	89 c8                	mov    %ecx,%eax
  bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "%s ran in %d.%d seconds\n", argv[1], secs, p_secs); 
  c2:	8b 43 04             	mov    0x4(%ebx),%eax
  c5:	83 c0 04             	add    $0x4,%eax
  c8:	8b 00                	mov    (%eax),%eax
  ca:	83 ec 0c             	sub    $0xc,%esp
  cd:	ff 75 e4             	pushl  -0x1c(%ebp)
  d0:	ff 75 e8             	pushl  -0x18(%ebp)
  d3:	50                   	push   %eax
  d4:	68 fe 08 00 00       	push   $0x8fe
  d9:	6a 01                	push   $0x1
  db:	e8 5b 04 00 00       	call   53b <printf>
  e0:	83 c4 20             	add    $0x20,%esp
  } 
  exit();
  e3:	e8 9c 02 00 00       	call   384 <exit>

000000e8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	57                   	push   %edi
  ec:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f0:	8b 55 10             	mov    0x10(%ebp),%edx
  f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  f6:	89 cb                	mov    %ecx,%ebx
  f8:	89 df                	mov    %ebx,%edi
  fa:	89 d1                	mov    %edx,%ecx
  fc:	fc                   	cld    
  fd:	f3 aa                	rep stos %al,%es:(%edi)
  ff:	89 ca                	mov    %ecx,%edx
 101:	89 fb                	mov    %edi,%ebx
 103:	89 5d 08             	mov    %ebx,0x8(%ebp)
 106:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 109:	90                   	nop
 10a:	5b                   	pop    %ebx
 10b:	5f                   	pop    %edi
 10c:	5d                   	pop    %ebp
 10d:	c3                   	ret    

0000010e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 10e:	55                   	push   %ebp
 10f:	89 e5                	mov    %esp,%ebp
 111:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 11a:	90                   	nop
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	8d 50 01             	lea    0x1(%eax),%edx
 121:	89 55 08             	mov    %edx,0x8(%ebp)
 124:	8b 55 0c             	mov    0xc(%ebp),%edx
 127:	8d 4a 01             	lea    0x1(%edx),%ecx
 12a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 12d:	0f b6 12             	movzbl (%edx),%edx
 130:	88 10                	mov    %dl,(%eax)
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	84 c0                	test   %al,%al
 137:	75 e2                	jne    11b <strcpy+0xd>
    ;
  return os;
 139:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13c:	c9                   	leave  
 13d:	c3                   	ret    

0000013e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 141:	eb 08                	jmp    14b <strcmp+0xd>
    p++, q++;
 143:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 147:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	0f b6 00             	movzbl (%eax),%eax
 151:	84 c0                	test   %al,%al
 153:	74 10                	je     165 <strcmp+0x27>
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 10             	movzbl (%eax),%edx
 15b:	8b 45 0c             	mov    0xc(%ebp),%eax
 15e:	0f b6 00             	movzbl (%eax),%eax
 161:	38 c2                	cmp    %al,%dl
 163:	74 de                	je     143 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	0f b6 00             	movzbl (%eax),%eax
 16b:	0f b6 d0             	movzbl %al,%edx
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	0f b6 c0             	movzbl %al,%eax
 177:	29 c2                	sub    %eax,%edx
 179:	89 d0                	mov    %edx,%eax
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    

0000017d <strlen>:

uint
strlen(char *s)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 183:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 18a:	eb 04                	jmp    190 <strlen+0x13>
 18c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 190:	8b 55 fc             	mov    -0x4(%ebp),%edx
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	01 d0                	add    %edx,%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	84 c0                	test   %al,%al
 19d:	75 ed                	jne    18c <strlen+0xf>
    ;
  return n;
 19f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1a7:	8b 45 10             	mov    0x10(%ebp),%eax
 1aa:	50                   	push   %eax
 1ab:	ff 75 0c             	pushl  0xc(%ebp)
 1ae:	ff 75 08             	pushl  0x8(%ebp)
 1b1:	e8 32 ff ff ff       	call   e8 <stosb>
 1b6:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1bc:	c9                   	leave  
 1bd:	c3                   	ret    

000001be <strchr>:

char*
strchr(const char *s, char c)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	83 ec 04             	sub    $0x4,%esp
 1c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ca:	eb 14                	jmp    1e0 <strchr+0x22>
    if(*s == c)
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	0f b6 00             	movzbl (%eax),%eax
 1d2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1d5:	75 05                	jne    1dc <strchr+0x1e>
      return (char*)s;
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	eb 13                	jmp    1ef <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	84 c0                	test   %al,%al
 1e8:	75 e2                	jne    1cc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <gets>:

char*
gets(char *buf, int max)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1fe:	eb 42                	jmp    242 <gets+0x51>
    cc = read(0, &c, 1);
 200:	83 ec 04             	sub    $0x4,%esp
 203:	6a 01                	push   $0x1
 205:	8d 45 ef             	lea    -0x11(%ebp),%eax
 208:	50                   	push   %eax
 209:	6a 00                	push   $0x0
 20b:	e8 8c 01 00 00       	call   39c <read>
 210:	83 c4 10             	add    $0x10,%esp
 213:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 216:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 21a:	7e 33                	jle    24f <gets+0x5e>
      break;
    buf[i++] = c;
 21c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21f:	8d 50 01             	lea    0x1(%eax),%edx
 222:	89 55 f4             	mov    %edx,-0xc(%ebp)
 225:	89 c2                	mov    %eax,%edx
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	01 c2                	add    %eax,%edx
 22c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 230:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 232:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 236:	3c 0a                	cmp    $0xa,%al
 238:	74 16                	je     250 <gets+0x5f>
 23a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23e:	3c 0d                	cmp    $0xd,%al
 240:	74 0e                	je     250 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 242:	8b 45 f4             	mov    -0xc(%ebp),%eax
 245:	83 c0 01             	add    $0x1,%eax
 248:	3b 45 0c             	cmp    0xc(%ebp),%eax
 24b:	7c b3                	jl     200 <gets+0xf>
 24d:	eb 01                	jmp    250 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 24f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 250:	8b 55 f4             	mov    -0xc(%ebp),%edx
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	01 d0                	add    %edx,%eax
 258:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 25e:	c9                   	leave  
 25f:	c3                   	ret    

00000260 <stat>:

int
stat(char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 266:	83 ec 08             	sub    $0x8,%esp
 269:	6a 00                	push   $0x0
 26b:	ff 75 08             	pushl  0x8(%ebp)
 26e:	e8 51 01 00 00       	call   3c4 <open>
 273:	83 c4 10             	add    $0x10,%esp
 276:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 27d:	79 07                	jns    286 <stat+0x26>
    return -1;
 27f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 284:	eb 25                	jmp    2ab <stat+0x4b>
  r = fstat(fd, st);
 286:	83 ec 08             	sub    $0x8,%esp
 289:	ff 75 0c             	pushl  0xc(%ebp)
 28c:	ff 75 f4             	pushl  -0xc(%ebp)
 28f:	e8 48 01 00 00       	call   3dc <fstat>
 294:	83 c4 10             	add    $0x10,%esp
 297:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 29a:	83 ec 0c             	sub    $0xc,%esp
 29d:	ff 75 f4             	pushl  -0xc(%ebp)
 2a0:	e8 07 01 00 00       	call   3ac <close>
 2a5:	83 c4 10             	add    $0x10,%esp
  return r;
 2a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ab:	c9                   	leave  
 2ac:	c3                   	ret    

000002ad <atoi>:

int
atoi(const char *s)
{
 2ad:	55                   	push   %ebp
 2ae:	89 e5                	mov    %esp,%ebp
 2b0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 2ba:	eb 04                	jmp    2c0 <atoi+0x13>
 2bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	0f b6 00             	movzbl (%eax),%eax
 2c6:	3c 20                	cmp    $0x20,%al
 2c8:	74 f2                	je     2bc <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
 2cd:	0f b6 00             	movzbl (%eax),%eax
 2d0:	3c 2d                	cmp    $0x2d,%al
 2d2:	75 07                	jne    2db <atoi+0x2e>
 2d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2d9:	eb 05                	jmp    2e0 <atoi+0x33>
 2db:	b8 01 00 00 00       	mov    $0x1,%eax
 2e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	3c 2b                	cmp    $0x2b,%al
 2eb:	74 0a                	je     2f7 <atoi+0x4a>
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	0f b6 00             	movzbl (%eax),%eax
 2f3:	3c 2d                	cmp    $0x2d,%al
 2f5:	75 2b                	jne    322 <atoi+0x75>
    s++;
 2f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2fb:	eb 25                	jmp    322 <atoi+0x75>
    n = n*10 + *s++ - '0';
 2fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 300:	89 d0                	mov    %edx,%eax
 302:	c1 e0 02             	shl    $0x2,%eax
 305:	01 d0                	add    %edx,%eax
 307:	01 c0                	add    %eax,%eax
 309:	89 c1                	mov    %eax,%ecx
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	8d 50 01             	lea    0x1(%eax),%edx
 311:	89 55 08             	mov    %edx,0x8(%ebp)
 314:	0f b6 00             	movzbl (%eax),%eax
 317:	0f be c0             	movsbl %al,%eax
 31a:	01 c8                	add    %ecx,%eax
 31c:	83 e8 30             	sub    $0x30,%eax
 31f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 322:	8b 45 08             	mov    0x8(%ebp),%eax
 325:	0f b6 00             	movzbl (%eax),%eax
 328:	3c 2f                	cmp    $0x2f,%al
 32a:	7e 0a                	jle    336 <atoi+0x89>
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	0f b6 00             	movzbl (%eax),%eax
 332:	3c 39                	cmp    $0x39,%al
 334:	7e c7                	jle    2fd <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 336:	8b 45 f8             	mov    -0x8(%ebp),%eax
 339:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 33d:	c9                   	leave  
 33e:	c3                   	ret    

0000033f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 33f:	55                   	push   %ebp
 340:	89 e5                	mov    %esp,%ebp
 342:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 345:	8b 45 08             	mov    0x8(%ebp),%eax
 348:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 34b:	8b 45 0c             	mov    0xc(%ebp),%eax
 34e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 351:	eb 17                	jmp    36a <memmove+0x2b>
    *dst++ = *src++;
 353:	8b 45 fc             	mov    -0x4(%ebp),%eax
 356:	8d 50 01             	lea    0x1(%eax),%edx
 359:	89 55 fc             	mov    %edx,-0x4(%ebp)
 35c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 35f:	8d 4a 01             	lea    0x1(%edx),%ecx
 362:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 365:	0f b6 12             	movzbl (%edx),%edx
 368:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 36a:	8b 45 10             	mov    0x10(%ebp),%eax
 36d:	8d 50 ff             	lea    -0x1(%eax),%edx
 370:	89 55 10             	mov    %edx,0x10(%ebp)
 373:	85 c0                	test   %eax,%eax
 375:	7f dc                	jg     353 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 377:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37c:	b8 01 00 00 00       	mov    $0x1,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <exit>:
SYSCALL(exit)
 384:	b8 02 00 00 00       	mov    $0x2,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <wait>:
SYSCALL(wait)
 38c:	b8 03 00 00 00       	mov    $0x3,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <pipe>:
SYSCALL(pipe)
 394:	b8 04 00 00 00       	mov    $0x4,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <read>:
SYSCALL(read)
 39c:	b8 05 00 00 00       	mov    $0x5,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <write>:
SYSCALL(write)
 3a4:	b8 10 00 00 00       	mov    $0x10,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <close>:
SYSCALL(close)
 3ac:	b8 15 00 00 00       	mov    $0x15,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <kill>:
SYSCALL(kill)
 3b4:	b8 06 00 00 00       	mov    $0x6,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <exec>:
SYSCALL(exec)
 3bc:	b8 07 00 00 00       	mov    $0x7,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <open>:
SYSCALL(open)
 3c4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <mknod>:
SYSCALL(mknod)
 3cc:	b8 11 00 00 00       	mov    $0x11,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <unlink>:
SYSCALL(unlink)
 3d4:	b8 12 00 00 00       	mov    $0x12,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <fstat>:
SYSCALL(fstat)
 3dc:	b8 08 00 00 00       	mov    $0x8,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <link>:
SYSCALL(link)
 3e4:	b8 13 00 00 00       	mov    $0x13,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <mkdir>:
SYSCALL(mkdir)
 3ec:	b8 14 00 00 00       	mov    $0x14,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <chdir>:
SYSCALL(chdir)
 3f4:	b8 09 00 00 00       	mov    $0x9,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <dup>:
SYSCALL(dup)
 3fc:	b8 0a 00 00 00       	mov    $0xa,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <getpid>:
SYSCALL(getpid)
 404:	b8 0b 00 00 00       	mov    $0xb,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <sbrk>:
SYSCALL(sbrk)
 40c:	b8 0c 00 00 00       	mov    $0xc,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <sleep>:
SYSCALL(sleep)
 414:	b8 0d 00 00 00       	mov    $0xd,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <uptime>:
SYSCALL(uptime)
 41c:	b8 0e 00 00 00       	mov    $0xe,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <halt>:
SYSCALL(halt)
 424:	b8 16 00 00 00       	mov    $0x16,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <date>:
SYSCALL(date)      #p1
 42c:	b8 17 00 00 00       	mov    $0x17,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <getuid>:
SYSCALL(getuid)    #p2
 434:	b8 18 00 00 00       	mov    $0x18,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <getgid>:
SYSCALL(getgid)    #p2
 43c:	b8 19 00 00 00       	mov    $0x19,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <getppid>:
SYSCALL(getppid)   #p2
 444:	b8 1a 00 00 00       	mov    $0x1a,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <setuid>:
SYSCALL(setuid)    #p2
 44c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <setgid>:
SYSCALL(setgid)    #p2
 454:	b8 1c 00 00 00       	mov    $0x1c,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <getprocs>:
SYSCALL(getprocs)  #p2
 45c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 18             	sub    $0x18,%esp
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 470:	83 ec 04             	sub    $0x4,%esp
 473:	6a 01                	push   $0x1
 475:	8d 45 f4             	lea    -0xc(%ebp),%eax
 478:	50                   	push   %eax
 479:	ff 75 08             	pushl  0x8(%ebp)
 47c:	e8 23 ff ff ff       	call   3a4 <write>
 481:	83 c4 10             	add    $0x10,%esp
}
 484:	90                   	nop
 485:	c9                   	leave  
 486:	c3                   	ret    

00000487 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 487:	55                   	push   %ebp
 488:	89 e5                	mov    %esp,%ebp
 48a:	53                   	push   %ebx
 48b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 495:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 499:	74 17                	je     4b2 <printint+0x2b>
 49b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 49f:	79 11                	jns    4b2 <printint+0x2b>
    neg = 1;
 4a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ab:	f7 d8                	neg    %eax
 4ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b0:	eb 06                	jmp    4b8 <printint+0x31>
  } else {
    x = xx;
 4b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4bf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4c2:	8d 41 01             	lea    0x1(%ecx),%eax
 4c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ce:	ba 00 00 00 00       	mov    $0x0,%edx
 4d3:	f7 f3                	div    %ebx
 4d5:	89 d0                	mov    %edx,%eax
 4d7:	0f b6 80 6c 0b 00 00 	movzbl 0xb6c(%eax),%eax
 4de:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e8:	ba 00 00 00 00       	mov    $0x0,%edx
 4ed:	f7 f3                	div    %ebx
 4ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f6:	75 c7                	jne    4bf <printint+0x38>
  if(neg)
 4f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fc:	74 2d                	je     52b <printint+0xa4>
    buf[i++] = '-';
 4fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 501:	8d 50 01             	lea    0x1(%eax),%edx
 504:	89 55 f4             	mov    %edx,-0xc(%ebp)
 507:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 50c:	eb 1d                	jmp    52b <printint+0xa4>
    putc(fd, buf[i]);
 50e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 511:	8b 45 f4             	mov    -0xc(%ebp),%eax
 514:	01 d0                	add    %edx,%eax
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	83 ec 08             	sub    $0x8,%esp
 51f:	50                   	push   %eax
 520:	ff 75 08             	pushl  0x8(%ebp)
 523:	e8 3c ff ff ff       	call   464 <putc>
 528:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 52b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 52f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 533:	79 d9                	jns    50e <printint+0x87>
    putc(fd, buf[i]);
}
 535:	90                   	nop
 536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 539:	c9                   	leave  
 53a:	c3                   	ret    

0000053b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 53b:	55                   	push   %ebp
 53c:	89 e5                	mov    %esp,%ebp
 53e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 541:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 548:	8d 45 0c             	lea    0xc(%ebp),%eax
 54b:	83 c0 04             	add    $0x4,%eax
 54e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 558:	e9 59 01 00 00       	jmp    6b6 <printf+0x17b>
    c = fmt[i] & 0xff;
 55d:	8b 55 0c             	mov    0xc(%ebp),%edx
 560:	8b 45 f0             	mov    -0x10(%ebp),%eax
 563:	01 d0                	add    %edx,%eax
 565:	0f b6 00             	movzbl (%eax),%eax
 568:	0f be c0             	movsbl %al,%eax
 56b:	25 ff 00 00 00       	and    $0xff,%eax
 570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 573:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 577:	75 2c                	jne    5a5 <printf+0x6a>
      if(c == '%'){
 579:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57d:	75 0c                	jne    58b <printf+0x50>
        state = '%';
 57f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 586:	e9 27 01 00 00       	jmp    6b2 <printf+0x177>
      } else {
        putc(fd, c);
 58b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58e:	0f be c0             	movsbl %al,%eax
 591:	83 ec 08             	sub    $0x8,%esp
 594:	50                   	push   %eax
 595:	ff 75 08             	pushl  0x8(%ebp)
 598:	e8 c7 fe ff ff       	call   464 <putc>
 59d:	83 c4 10             	add    $0x10,%esp
 5a0:	e9 0d 01 00 00       	jmp    6b2 <printf+0x177>
      }
    } else if(state == '%'){
 5a5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a9:	0f 85 03 01 00 00    	jne    6b2 <printf+0x177>
      if(c == 'd'){
 5af:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b3:	75 1e                	jne    5d3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b8:	8b 00                	mov    (%eax),%eax
 5ba:	6a 01                	push   $0x1
 5bc:	6a 0a                	push   $0xa
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 c0 fe ff ff       	call   487 <printint>
 5c7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ce:	e9 d8 00 00 00       	jmp    6ab <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5d3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d7:	74 06                	je     5df <printf+0xa4>
 5d9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5dd:	75 1e                	jne    5fd <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e2:	8b 00                	mov    (%eax),%eax
 5e4:	6a 00                	push   $0x0
 5e6:	6a 10                	push   $0x10
 5e8:	50                   	push   %eax
 5e9:	ff 75 08             	pushl  0x8(%ebp)
 5ec:	e8 96 fe ff ff       	call   487 <printint>
 5f1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f8:	e9 ae 00 00 00       	jmp    6ab <printf+0x170>
      } else if(c == 's'){
 5fd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 601:	75 43                	jne    646 <printf+0x10b>
        s = (char*)*ap;
 603:	8b 45 e8             	mov    -0x18(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 60f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 613:	75 25                	jne    63a <printf+0xff>
          s = "(null)";
 615:	c7 45 f4 17 09 00 00 	movl   $0x917,-0xc(%ebp)
        while(*s != 0){
 61c:	eb 1c                	jmp    63a <printf+0xff>
          putc(fd, *s);
 61e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 621:	0f b6 00             	movzbl (%eax),%eax
 624:	0f be c0             	movsbl %al,%eax
 627:	83 ec 08             	sub    $0x8,%esp
 62a:	50                   	push   %eax
 62b:	ff 75 08             	pushl  0x8(%ebp)
 62e:	e8 31 fe ff ff       	call   464 <putc>
 633:	83 c4 10             	add    $0x10,%esp
          s++;
 636:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 63a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63d:	0f b6 00             	movzbl (%eax),%eax
 640:	84 c0                	test   %al,%al
 642:	75 da                	jne    61e <printf+0xe3>
 644:	eb 65                	jmp    6ab <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 646:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 64a:	75 1d                	jne    669 <printf+0x12e>
        putc(fd, *ap);
 64c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	0f be c0             	movsbl %al,%eax
 654:	83 ec 08             	sub    $0x8,%esp
 657:	50                   	push   %eax
 658:	ff 75 08             	pushl  0x8(%ebp)
 65b:	e8 04 fe ff ff       	call   464 <putc>
 660:	83 c4 10             	add    $0x10,%esp
        ap++;
 663:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 667:	eb 42                	jmp    6ab <printf+0x170>
      } else if(c == '%'){
 669:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66d:	75 17                	jne    686 <printf+0x14b>
        putc(fd, c);
 66f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 672:	0f be c0             	movsbl %al,%eax
 675:	83 ec 08             	sub    $0x8,%esp
 678:	50                   	push   %eax
 679:	ff 75 08             	pushl  0x8(%ebp)
 67c:	e8 e3 fd ff ff       	call   464 <putc>
 681:	83 c4 10             	add    $0x10,%esp
 684:	eb 25                	jmp    6ab <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 686:	83 ec 08             	sub    $0x8,%esp
 689:	6a 25                	push   $0x25
 68b:	ff 75 08             	pushl  0x8(%ebp)
 68e:	e8 d1 fd ff ff       	call   464 <putc>
 693:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 699:	0f be c0             	movsbl %al,%eax
 69c:	83 ec 08             	sub    $0x8,%esp
 69f:	50                   	push   %eax
 6a0:	ff 75 08             	pushl  0x8(%ebp)
 6a3:	e8 bc fd ff ff       	call   464 <putc>
 6a8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bc:	01 d0                	add    %edx,%eax
 6be:	0f b6 00             	movzbl (%eax),%eax
 6c1:	84 c0                	test   %al,%al
 6c3:	0f 85 94 fe ff ff    	jne    55d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c9:	90                   	nop
 6ca:	c9                   	leave  
 6cb:	c3                   	ret    

000006cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d2:	8b 45 08             	mov    0x8(%ebp),%eax
 6d5:	83 e8 08             	sub    $0x8,%eax
 6d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6db:	a1 88 0b 00 00       	mov    0xb88,%eax
 6e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e3:	eb 24                	jmp    709 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ed:	77 12                	ja     701 <free+0x35>
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f5:	77 24                	ja     71b <free+0x4f>
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ff:	77 1a                	ja     71b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	89 45 fc             	mov    %eax,-0x4(%ebp)
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70f:	76 d4                	jbe    6e5 <free+0x19>
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 719:	76 ca                	jbe    6e5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	39 c2                	cmp    %eax,%edx
 734:	75 24                	jne    75a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	8b 50 04             	mov    0x4(%eax),%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	8b 40 04             	mov    0x4(%eax),%eax
 744:	01 c2                	add    %eax,%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	89 10                	mov    %edx,(%eax)
 758:	eb 0a                	jmp    764 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 10                	mov    (%eax),%edx
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 40 04             	mov    0x4(%eax),%eax
 76a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	01 d0                	add    %edx,%eax
 776:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 779:	75 20                	jne    79b <free+0xcf>
    p->s.size += bp->s.size;
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 50 04             	mov    0x4(%eax),%edx
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	01 c2                	add    %eax,%edx
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 08                	jmp    7a3 <free+0xd7>
  } else
    p->s.ptr = bp;
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 7ab:	90                   	nop
 7ac:	c9                   	leave  
 7ad:	c3                   	ret    

000007ae <morecore>:

static Header*
morecore(uint nu)
{
 7ae:	55                   	push   %ebp
 7af:	89 e5                	mov    %esp,%ebp
 7b1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7bb:	77 07                	ja     7c4 <morecore+0x16>
    nu = 4096;
 7bd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c4:	8b 45 08             	mov    0x8(%ebp),%eax
 7c7:	c1 e0 03             	shl    $0x3,%eax
 7ca:	83 ec 0c             	sub    $0xc,%esp
 7cd:	50                   	push   %eax
 7ce:	e8 39 fc ff ff       	call   40c <sbrk>
 7d3:	83 c4 10             	add    $0x10,%esp
 7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7dd:	75 07                	jne    7e6 <morecore+0x38>
    return 0;
 7df:	b8 00 00 00 00       	mov    $0x0,%eax
 7e4:	eb 26                	jmp    80c <morecore+0x5e>
  hp = (Header*)p;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	8b 55 08             	mov    0x8(%ebp),%edx
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f8:	83 c0 08             	add    $0x8,%eax
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	50                   	push   %eax
 7ff:	e8 c8 fe ff ff       	call   6cc <free>
 804:	83 c4 10             	add    $0x10,%esp
  return freep;
 807:	a1 88 0b 00 00       	mov    0xb88,%eax
}
 80c:	c9                   	leave  
 80d:	c3                   	ret    

0000080e <malloc>:

void*
malloc(uint nbytes)
{
 80e:	55                   	push   %ebp
 80f:	89 e5                	mov    %esp,%ebp
 811:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	83 c0 07             	add    $0x7,%eax
 81a:	c1 e8 03             	shr    $0x3,%eax
 81d:	83 c0 01             	add    $0x1,%eax
 820:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 823:	a1 88 0b 00 00       	mov    0xb88,%eax
 828:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82f:	75 23                	jne    854 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 831:	c7 45 f0 80 0b 00 00 	movl   $0xb80,-0x10(%ebp)
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	a3 88 0b 00 00       	mov    %eax,0xb88
 840:	a1 88 0b 00 00       	mov    0xb88,%eax
 845:	a3 80 0b 00 00       	mov    %eax,0xb80
    base.s.size = 0;
 84a:	c7 05 84 0b 00 00 00 	movl   $0x0,0xb84
 851:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	8b 40 04             	mov    0x4(%eax),%eax
 862:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 865:	72 4d                	jb     8b4 <malloc+0xa6>
      if(p->s.size == nunits)
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 40 04             	mov    0x4(%eax),%eax
 86d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 870:	75 0c                	jne    87e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8b 10                	mov    (%eax),%edx
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	89 10                	mov    %edx,(%eax)
 87c:	eb 26                	jmp    8a4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 40 04             	mov    0x4(%eax),%eax
 884:	2b 45 ec             	sub    -0x14(%ebp),%eax
 887:	89 c2                	mov    %eax,%edx
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	c1 e0 03             	shl    $0x3,%eax
 898:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a7:	a3 88 0b 00 00       	mov    %eax,0xb88
      return (void*)(p + 1);
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	83 c0 08             	add    $0x8,%eax
 8b2:	eb 3b                	jmp    8ef <malloc+0xe1>
    }
    if(p == freep)
 8b4:	a1 88 0b 00 00       	mov    0xb88,%eax
 8b9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8bc:	75 1e                	jne    8dc <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8be:	83 ec 0c             	sub    $0xc,%esp
 8c1:	ff 75 ec             	pushl  -0x14(%ebp)
 8c4:	e8 e5 fe ff ff       	call   7ae <morecore>
 8c9:	83 c4 10             	add    $0x10,%esp
 8cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d3:	75 07                	jne    8dc <malloc+0xce>
        return 0;
 8d5:	b8 00 00 00 00       	mov    $0x0,%eax
 8da:	eb 13                	jmp    8ef <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e5:	8b 00                	mov    (%eax),%eax
 8e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8ea:	e9 6d ff ff ff       	jmp    85c <malloc+0x4e>
}
 8ef:	c9                   	leave  
 8f0:	c3                   	ret    
