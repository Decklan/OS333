
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
  14:	e8 8f 03 00 00       	call   3a8 <fork>
  19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int before = uptime();
  1c:	e8 27 04 00 00       	call   448 <uptime>
  21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int after = 0;
  24:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  if (f < 0)
  2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  2f:	79 17                	jns    48 <main+0x48>
    printf(2, "Fork failed.");
  31:	83 ec 08             	sub    $0x8,%esp
  34:	68 1d 09 00 00       	push   $0x91d
  39:	6a 02                	push   $0x2
  3b:	e8 27 05 00 00       	call   567 <printf>
  40:	83 c4 10             	add    $0x10,%esp
  43:	e9 c7 00 00 00       	jmp    10f <main+0x10f>
  else if (f == 0)
  48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4c:	75 1d                	jne    6b <main+0x6b>
  {
    argv++;
  4e:	83 43 04 04          	addl   $0x4,0x4(%ebx)
    exec(argv[0], argv);
  52:	8b 43 04             	mov    0x4(%ebx),%eax
  55:	8b 00                	mov    (%eax),%eax
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	ff 73 04             	pushl  0x4(%ebx)
  5d:	50                   	push   %eax
  5e:	e8 85 03 00 00       	call   3e8 <exec>
  63:	83 c4 10             	add    $0x10,%esp
  66:	e9 a4 00 00 00       	jmp    10f <main+0x10f>
  } else {
    wait();
  6b:	e8 48 03 00 00       	call   3b8 <wait>
    after = uptime();
  70:	e8 d3 03 00 00       	call   448 <uptime>
  75:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int secs = (after-before)/100;
  78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  7b:	2b 45 f0             	sub    -0x10(%ebp),%eax
  7e:	89 c1                	mov    %eax,%ecx
  80:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  85:	89 c8                	mov    %ecx,%eax
  87:	f7 ea                	imul   %edx
  89:	c1 fa 05             	sar    $0x5,%edx
  8c:	89 c8                	mov    %ecx,%eax
  8e:	c1 f8 1f             	sar    $0x1f,%eax
  91:	29 c2                	sub    %eax,%edx
  93:	89 d0                	mov    %edx,%eax
  95:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int p_secs = (after-before)%100;
  98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  9b:	2b 45 f0             	sub    -0x10(%ebp),%eax
  9e:	89 c1                	mov    %eax,%ecx
  a0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  a5:	89 c8                	mov    %ecx,%eax
  a7:	f7 ea                	imul   %edx
  a9:	c1 fa 05             	sar    $0x5,%edx
  ac:	89 c8                	mov    %ecx,%eax
  ae:	c1 f8 1f             	sar    $0x1f,%eax
  b1:	29 c2                	sub    %eax,%edx
  b3:	89 d0                	mov    %edx,%eax
  b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  bb:	6b c0 64             	imul   $0x64,%eax,%eax
  be:	29 c1                	sub    %eax,%ecx
  c0:	89 c8                	mov    %ecx,%eax
  c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (p_secs < 10)
  c5:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
  c9:	7f 23                	jg     ee <main+0xee>
      printf(1, "%s ran in %d.0%d seconds\n", argv[1], secs, p_secs);
  cb:	8b 43 04             	mov    0x4(%ebx),%eax
  ce:	83 c0 04             	add    $0x4,%eax
  d1:	8b 00                	mov    (%eax),%eax
  d3:	83 ec 0c             	sub    $0xc,%esp
  d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  d9:	ff 75 e8             	pushl  -0x18(%ebp)
  dc:	50                   	push   %eax
  dd:	68 2a 09 00 00       	push   $0x92a
  e2:	6a 01                	push   $0x1
  e4:	e8 7e 04 00 00       	call   567 <printf>
  e9:	83 c4 20             	add    $0x20,%esp
  ec:	eb 21                	jmp    10f <main+0x10f>
    else 
      printf(1, "%s ran in %d.%d seconds\n", argv[1], secs, p_secs); 
  ee:	8b 43 04             	mov    0x4(%ebx),%eax
  f1:	83 c0 04             	add    $0x4,%eax
  f4:	8b 00                	mov    (%eax),%eax
  f6:	83 ec 0c             	sub    $0xc,%esp
  f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  fc:	ff 75 e8             	pushl  -0x18(%ebp)
  ff:	50                   	push   %eax
 100:	68 44 09 00 00       	push   $0x944
 105:	6a 01                	push   $0x1
 107:	e8 5b 04 00 00       	call   567 <printf>
 10c:	83 c4 20             	add    $0x20,%esp
  } 
  exit();
 10f:	e8 9c 02 00 00       	call   3b0 <exit>

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	90                   	nop
 136:	5b                   	pop    %ebx
 137:	5f                   	pop    %edi
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 146:	90                   	nop
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	8d 50 01             	lea    0x1(%eax),%edx
 14d:	89 55 08             	mov    %edx,0x8(%ebp)
 150:	8b 55 0c             	mov    0xc(%ebp),%edx
 153:	8d 4a 01             	lea    0x1(%edx),%ecx
 156:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 159:	0f b6 12             	movzbl (%edx),%edx
 15c:	88 10                	mov    %dl,(%eax)
 15e:	0f b6 00             	movzbl (%eax),%eax
 161:	84 c0                	test   %al,%al
 163:	75 e2                	jne    147 <strcpy+0xd>
    ;
  return os;
 165:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 168:	c9                   	leave  
 169:	c3                   	ret    

0000016a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16d:	eb 08                	jmp    177 <strcmp+0xd>
    p++, q++;
 16f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 173:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	0f b6 00             	movzbl (%eax),%eax
 17d:	84 c0                	test   %al,%al
 17f:	74 10                	je     191 <strcmp+0x27>
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	0f b6 10             	movzbl (%eax),%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	38 c2                	cmp    %al,%dl
 18f:	74 de                	je     16f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	0f b6 00             	movzbl (%eax),%eax
 197:	0f b6 d0             	movzbl %al,%edx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	0f b6 00             	movzbl (%eax),%eax
 1a0:	0f b6 c0             	movzbl %al,%eax
 1a3:	29 c2                	sub    %eax,%edx
 1a5:	89 d0                	mov    %edx,%eax
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    

000001a9 <strlen>:

uint
strlen(char *s)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
 1ac:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b6:	eb 04                	jmp    1bc <strlen+0x13>
 1b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	01 d0                	add    %edx,%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	84 c0                	test   %al,%al
 1c9:	75 ed                	jne    1b8 <strlen+0xf>
    ;
  return n;
 1cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ce:	c9                   	leave  
 1cf:	c3                   	ret    

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1d3:	8b 45 10             	mov    0x10(%ebp),%eax
 1d6:	50                   	push   %eax
 1d7:	ff 75 0c             	pushl  0xc(%ebp)
 1da:	ff 75 08             	pushl  0x8(%ebp)
 1dd:	e8 32 ff ff ff       	call   114 <stosb>
 1e2:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <strchr>:

char*
strchr(const char *s, char c)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 04             	sub    $0x4,%esp
 1f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f6:	eb 14                	jmp    20c <strchr+0x22>
    if(*s == c)
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	0f b6 00             	movzbl (%eax),%eax
 1fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
 201:	75 05                	jne    208 <strchr+0x1e>
      return (char*)s;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	eb 13                	jmp    21b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 208:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	0f b6 00             	movzbl (%eax),%eax
 212:	84 c0                	test   %al,%al
 214:	75 e2                	jne    1f8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 216:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21b:	c9                   	leave  
 21c:	c3                   	ret    

0000021d <gets>:

char*
gets(char *buf, int max)
{
 21d:	55                   	push   %ebp
 21e:	89 e5                	mov    %esp,%ebp
 220:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 223:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22a:	eb 42                	jmp    26e <gets+0x51>
    cc = read(0, &c, 1);
 22c:	83 ec 04             	sub    $0x4,%esp
 22f:	6a 01                	push   $0x1
 231:	8d 45 ef             	lea    -0x11(%ebp),%eax
 234:	50                   	push   %eax
 235:	6a 00                	push   $0x0
 237:	e8 8c 01 00 00       	call   3c8 <read>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 242:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 246:	7e 33                	jle    27b <gets+0x5e>
      break;
    buf[i++] = c;
 248:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24b:	8d 50 01             	lea    0x1(%eax),%edx
 24e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 251:	89 c2                	mov    %eax,%edx
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	01 c2                	add    %eax,%edx
 258:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 25e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 262:	3c 0a                	cmp    $0xa,%al
 264:	74 16                	je     27c <gets+0x5f>
 266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26a:	3c 0d                	cmp    $0xd,%al
 26c:	74 0e                	je     27c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 271:	83 c0 01             	add    $0x1,%eax
 274:	3b 45 0c             	cmp    0xc(%ebp),%eax
 277:	7c b3                	jl     22c <gets+0xf>
 279:	eb 01                	jmp    27c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 27b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 27c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	01 d0                	add    %edx,%eax
 284:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 287:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28a:	c9                   	leave  
 28b:	c3                   	ret    

0000028c <stat>:

int
stat(char *n, struct stat *st)
{
 28c:	55                   	push   %ebp
 28d:	89 e5                	mov    %esp,%ebp
 28f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 292:	83 ec 08             	sub    $0x8,%esp
 295:	6a 00                	push   $0x0
 297:	ff 75 08             	pushl  0x8(%ebp)
 29a:	e8 51 01 00 00       	call   3f0 <open>
 29f:	83 c4 10             	add    $0x10,%esp
 2a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a9:	79 07                	jns    2b2 <stat+0x26>
    return -1;
 2ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b0:	eb 25                	jmp    2d7 <stat+0x4b>
  r = fstat(fd, st);
 2b2:	83 ec 08             	sub    $0x8,%esp
 2b5:	ff 75 0c             	pushl  0xc(%ebp)
 2b8:	ff 75 f4             	pushl  -0xc(%ebp)
 2bb:	e8 48 01 00 00       	call   408 <fstat>
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c6:	83 ec 0c             	sub    $0xc,%esp
 2c9:	ff 75 f4             	pushl  -0xc(%ebp)
 2cc:	e8 07 01 00 00       	call   3d8 <close>
 2d1:	83 c4 10             	add    $0x10,%esp
  return r;
 2d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d7:	c9                   	leave  
 2d8:	c3                   	ret    

000002d9 <atoi>:

int
atoi(const char *s)
{
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp
 2dc:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 2e6:	eb 04                	jmp    2ec <atoi+0x13>
 2e8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	0f b6 00             	movzbl (%eax),%eax
 2f2:	3c 20                	cmp    $0x20,%al
 2f4:	74 f2                	je     2e8 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	3c 2d                	cmp    $0x2d,%al
 2fe:	75 07                	jne    307 <atoi+0x2e>
 300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 305:	eb 05                	jmp    30c <atoi+0x33>
 307:	b8 01 00 00 00       	mov    $0x1,%eax
 30c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	0f b6 00             	movzbl (%eax),%eax
 315:	3c 2b                	cmp    $0x2b,%al
 317:	74 0a                	je     323 <atoi+0x4a>
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	3c 2d                	cmp    $0x2d,%al
 321:	75 2b                	jne    34e <atoi+0x75>
    s++;
 323:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 327:	eb 25                	jmp    34e <atoi+0x75>
    n = n*10 + *s++ - '0';
 329:	8b 55 fc             	mov    -0x4(%ebp),%edx
 32c:	89 d0                	mov    %edx,%eax
 32e:	c1 e0 02             	shl    $0x2,%eax
 331:	01 d0                	add    %edx,%eax
 333:	01 c0                	add    %eax,%eax
 335:	89 c1                	mov    %eax,%ecx
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	8d 50 01             	lea    0x1(%eax),%edx
 33d:	89 55 08             	mov    %edx,0x8(%ebp)
 340:	0f b6 00             	movzbl (%eax),%eax
 343:	0f be c0             	movsbl %al,%eax
 346:	01 c8                	add    %ecx,%eax
 348:	83 e8 30             	sub    $0x30,%eax
 34b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	0f b6 00             	movzbl (%eax),%eax
 354:	3c 2f                	cmp    $0x2f,%al
 356:	7e 0a                	jle    362 <atoi+0x89>
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	0f b6 00             	movzbl (%eax),%eax
 35e:	3c 39                	cmp    $0x39,%al
 360:	7e c7                	jle    329 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 362:	8b 45 f8             	mov    -0x8(%ebp),%eax
 365:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 369:	c9                   	leave  
 36a:	c3                   	ret    

0000036b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 377:	8b 45 0c             	mov    0xc(%ebp),%eax
 37a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 37d:	eb 17                	jmp    396 <memmove+0x2b>
    *dst++ = *src++;
 37f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 382:	8d 50 01             	lea    0x1(%eax),%edx
 385:	89 55 fc             	mov    %edx,-0x4(%ebp)
 388:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38b:	8d 4a 01             	lea    0x1(%edx),%ecx
 38e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 391:	0f b6 12             	movzbl (%edx),%edx
 394:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 396:	8b 45 10             	mov    0x10(%ebp),%eax
 399:	8d 50 ff             	lea    -0x1(%eax),%edx
 39c:	89 55 10             	mov    %edx,0x10(%ebp)
 39f:	85 c0                	test   %eax,%eax
 3a1:	7f dc                	jg     37f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a8:	b8 01 00 00 00       	mov    $0x1,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <exit>:
SYSCALL(exit)
 3b0:	b8 02 00 00 00       	mov    $0x2,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <wait>:
SYSCALL(wait)
 3b8:	b8 03 00 00 00       	mov    $0x3,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <pipe>:
SYSCALL(pipe)
 3c0:	b8 04 00 00 00       	mov    $0x4,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <read>:
SYSCALL(read)
 3c8:	b8 05 00 00 00       	mov    $0x5,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <write>:
SYSCALL(write)
 3d0:	b8 10 00 00 00       	mov    $0x10,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <close>:
SYSCALL(close)
 3d8:	b8 15 00 00 00       	mov    $0x15,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <kill>:
SYSCALL(kill)
 3e0:	b8 06 00 00 00       	mov    $0x6,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <exec>:
SYSCALL(exec)
 3e8:	b8 07 00 00 00       	mov    $0x7,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <open>:
SYSCALL(open)
 3f0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <mknod>:
SYSCALL(mknod)
 3f8:	b8 11 00 00 00       	mov    $0x11,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <unlink>:
SYSCALL(unlink)
 400:	b8 12 00 00 00       	mov    $0x12,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <fstat>:
SYSCALL(fstat)
 408:	b8 08 00 00 00       	mov    $0x8,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <link>:
SYSCALL(link)
 410:	b8 13 00 00 00       	mov    $0x13,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <mkdir>:
SYSCALL(mkdir)
 418:	b8 14 00 00 00       	mov    $0x14,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <chdir>:
SYSCALL(chdir)
 420:	b8 09 00 00 00       	mov    $0x9,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <dup>:
SYSCALL(dup)
 428:	b8 0a 00 00 00       	mov    $0xa,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <getpid>:
SYSCALL(getpid)
 430:	b8 0b 00 00 00       	mov    $0xb,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <sbrk>:
SYSCALL(sbrk)
 438:	b8 0c 00 00 00       	mov    $0xc,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <sleep>:
SYSCALL(sleep)
 440:	b8 0d 00 00 00       	mov    $0xd,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <uptime>:
SYSCALL(uptime)
 448:	b8 0e 00 00 00       	mov    $0xe,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <halt>:
SYSCALL(halt)
 450:	b8 16 00 00 00       	mov    $0x16,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <date>:
SYSCALL(date)      #p1
 458:	b8 17 00 00 00       	mov    $0x17,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <getuid>:
SYSCALL(getuid)    #p2
 460:	b8 18 00 00 00       	mov    $0x18,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <getgid>:
SYSCALL(getgid)    #p2
 468:	b8 19 00 00 00       	mov    $0x19,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <getppid>:
SYSCALL(getppid)   #p2
 470:	b8 1a 00 00 00       	mov    $0x1a,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <setuid>:
SYSCALL(setuid)    #p2
 478:	b8 1b 00 00 00       	mov    $0x1b,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <setgid>:
SYSCALL(setgid)    #p2
 480:	b8 1c 00 00 00       	mov    $0x1c,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <getprocs>:
SYSCALL(getprocs)  #p2
 488:	b8 1d 00 00 00       	mov    $0x1d,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	83 ec 18             	sub    $0x18,%esp
 496:	8b 45 0c             	mov    0xc(%ebp),%eax
 499:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 49c:	83 ec 04             	sub    $0x4,%esp
 49f:	6a 01                	push   $0x1
 4a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a4:	50                   	push   %eax
 4a5:	ff 75 08             	pushl  0x8(%ebp)
 4a8:	e8 23 ff ff ff       	call   3d0 <write>
 4ad:	83 c4 10             	add    $0x10,%esp
}
 4b0:	90                   	nop
 4b1:	c9                   	leave  
 4b2:	c3                   	ret    

000004b3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
 4b6:	53                   	push   %ebx
 4b7:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4c1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4c5:	74 17                	je     4de <printint+0x2b>
 4c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4cb:	79 11                	jns    4de <printint+0x2b>
    neg = 1;
 4cd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d7:	f7 d8                	neg    %eax
 4d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4dc:	eb 06                	jmp    4e4 <printint+0x31>
  } else {
    x = xx;
 4de:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4eb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4ee:	8d 41 01             	lea    0x1(%ecx),%eax
 4f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fa:	ba 00 00 00 00       	mov    $0x0,%edx
 4ff:	f7 f3                	div    %ebx
 501:	89 d0                	mov    %edx,%eax
 503:	0f b6 80 b0 0b 00 00 	movzbl 0xbb0(%eax),%eax
 50a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 50e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 511:	8b 45 ec             	mov    -0x14(%ebp),%eax
 514:	ba 00 00 00 00       	mov    $0x0,%edx
 519:	f7 f3                	div    %ebx
 51b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 522:	75 c7                	jne    4eb <printint+0x38>
  if(neg)
 524:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 528:	74 2d                	je     557 <printint+0xa4>
    buf[i++] = '-';
 52a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52d:	8d 50 01             	lea    0x1(%eax),%edx
 530:	89 55 f4             	mov    %edx,-0xc(%ebp)
 533:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 538:	eb 1d                	jmp    557 <printint+0xa4>
    putc(fd, buf[i]);
 53a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 53d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 540:	01 d0                	add    %edx,%eax
 542:	0f b6 00             	movzbl (%eax),%eax
 545:	0f be c0             	movsbl %al,%eax
 548:	83 ec 08             	sub    $0x8,%esp
 54b:	50                   	push   %eax
 54c:	ff 75 08             	pushl  0x8(%ebp)
 54f:	e8 3c ff ff ff       	call   490 <putc>
 554:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 557:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 55b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55f:	79 d9                	jns    53a <printint+0x87>
    putc(fd, buf[i]);
}
 561:	90                   	nop
 562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 565:	c9                   	leave  
 566:	c3                   	ret    

00000567 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 567:	55                   	push   %ebp
 568:	89 e5                	mov    %esp,%ebp
 56a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 56d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 574:	8d 45 0c             	lea    0xc(%ebp),%eax
 577:	83 c0 04             	add    $0x4,%eax
 57a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 57d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 584:	e9 59 01 00 00       	jmp    6e2 <printf+0x17b>
    c = fmt[i] & 0xff;
 589:	8b 55 0c             	mov    0xc(%ebp),%edx
 58c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58f:	01 d0                	add    %edx,%eax
 591:	0f b6 00             	movzbl (%eax),%eax
 594:	0f be c0             	movsbl %al,%eax
 597:	25 ff 00 00 00       	and    $0xff,%eax
 59c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 59f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a3:	75 2c                	jne    5d1 <printf+0x6a>
      if(c == '%'){
 5a5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a9:	75 0c                	jne    5b7 <printf+0x50>
        state = '%';
 5ab:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5b2:	e9 27 01 00 00       	jmp    6de <printf+0x177>
      } else {
        putc(fd, c);
 5b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	83 ec 08             	sub    $0x8,%esp
 5c0:	50                   	push   %eax
 5c1:	ff 75 08             	pushl  0x8(%ebp)
 5c4:	e8 c7 fe ff ff       	call   490 <putc>
 5c9:	83 c4 10             	add    $0x10,%esp
 5cc:	e9 0d 01 00 00       	jmp    6de <printf+0x177>
      }
    } else if(state == '%'){
 5d1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d5:	0f 85 03 01 00 00    	jne    6de <printf+0x177>
      if(c == 'd'){
 5db:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5df:	75 1e                	jne    5ff <printf+0x98>
        printint(fd, *ap, 10, 1);
 5e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e4:	8b 00                	mov    (%eax),%eax
 5e6:	6a 01                	push   $0x1
 5e8:	6a 0a                	push   $0xa
 5ea:	50                   	push   %eax
 5eb:	ff 75 08             	pushl  0x8(%ebp)
 5ee:	e8 c0 fe ff ff       	call   4b3 <printint>
 5f3:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fa:	e9 d8 00 00 00       	jmp    6d7 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5ff:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 603:	74 06                	je     60b <printf+0xa4>
 605:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 609:	75 1e                	jne    629 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 60b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	6a 00                	push   $0x0
 612:	6a 10                	push   $0x10
 614:	50                   	push   %eax
 615:	ff 75 08             	pushl  0x8(%ebp)
 618:	e8 96 fe ff ff       	call   4b3 <printint>
 61d:	83 c4 10             	add    $0x10,%esp
        ap++;
 620:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 624:	e9 ae 00 00 00       	jmp    6d7 <printf+0x170>
      } else if(c == 's'){
 629:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 62d:	75 43                	jne    672 <printf+0x10b>
        s = (char*)*ap;
 62f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 637:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 63b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 63f:	75 25                	jne    666 <printf+0xff>
          s = "(null)";
 641:	c7 45 f4 5d 09 00 00 	movl   $0x95d,-0xc(%ebp)
        while(*s != 0){
 648:	eb 1c                	jmp    666 <printf+0xff>
          putc(fd, *s);
 64a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64d:	0f b6 00             	movzbl (%eax),%eax
 650:	0f be c0             	movsbl %al,%eax
 653:	83 ec 08             	sub    $0x8,%esp
 656:	50                   	push   %eax
 657:	ff 75 08             	pushl  0x8(%ebp)
 65a:	e8 31 fe ff ff       	call   490 <putc>
 65f:	83 c4 10             	add    $0x10,%esp
          s++;
 662:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 666:	8b 45 f4             	mov    -0xc(%ebp),%eax
 669:	0f b6 00             	movzbl (%eax),%eax
 66c:	84 c0                	test   %al,%al
 66e:	75 da                	jne    64a <printf+0xe3>
 670:	eb 65                	jmp    6d7 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 672:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 676:	75 1d                	jne    695 <printf+0x12e>
        putc(fd, *ap);
 678:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	0f be c0             	movsbl %al,%eax
 680:	83 ec 08             	sub    $0x8,%esp
 683:	50                   	push   %eax
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 04 fe ff ff       	call   490 <putc>
 68c:	83 c4 10             	add    $0x10,%esp
        ap++;
 68f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 693:	eb 42                	jmp    6d7 <printf+0x170>
      } else if(c == '%'){
 695:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 699:	75 17                	jne    6b2 <printf+0x14b>
        putc(fd, c);
 69b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69e:	0f be c0             	movsbl %al,%eax
 6a1:	83 ec 08             	sub    $0x8,%esp
 6a4:	50                   	push   %eax
 6a5:	ff 75 08             	pushl  0x8(%ebp)
 6a8:	e8 e3 fd ff ff       	call   490 <putc>
 6ad:	83 c4 10             	add    $0x10,%esp
 6b0:	eb 25                	jmp    6d7 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6b2:	83 ec 08             	sub    $0x8,%esp
 6b5:	6a 25                	push   $0x25
 6b7:	ff 75 08             	pushl  0x8(%ebp)
 6ba:	e8 d1 fd ff ff       	call   490 <putc>
 6bf:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c5:	0f be c0             	movsbl %al,%eax
 6c8:	83 ec 08             	sub    $0x8,%esp
 6cb:	50                   	push   %eax
 6cc:	ff 75 08             	pushl  0x8(%ebp)
 6cf:	e8 bc fd ff ff       	call   490 <putc>
 6d4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6de:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6e2:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e8:	01 d0                	add    %edx,%eax
 6ea:	0f b6 00             	movzbl (%eax),%eax
 6ed:	84 c0                	test   %al,%al
 6ef:	0f 85 94 fe ff ff    	jne    589 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f5:	90                   	nop
 6f6:	c9                   	leave  
 6f7:	c3                   	ret    

000006f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f8:	55                   	push   %ebp
 6f9:	89 e5                	mov    %esp,%ebp
 6fb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fe:	8b 45 08             	mov    0x8(%ebp),%eax
 701:	83 e8 08             	sub    $0x8,%eax
 704:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 707:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 70c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70f:	eb 24                	jmp    735 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 719:	77 12                	ja     72d <free+0x35>
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 721:	77 24                	ja     747 <free+0x4f>
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72b:	77 1a                	ja     747 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	89 45 fc             	mov    %eax,-0x4(%ebp)
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73b:	76 d4                	jbe    711 <free+0x19>
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 745:	76 ca                	jbe    711 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 754:	8b 45 f8             	mov    -0x8(%ebp),%eax
 757:	01 c2                	add    %eax,%edx
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	39 c2                	cmp    %eax,%edx
 760:	75 24                	jne    786 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 762:	8b 45 f8             	mov    -0x8(%ebp),%eax
 765:	8b 50 04             	mov    0x4(%eax),%edx
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	8b 40 04             	mov    0x4(%eax),%eax
 770:	01 c2                	add    %eax,%edx
 772:	8b 45 f8             	mov    -0x8(%ebp),%eax
 775:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77b:	8b 00                	mov    (%eax),%eax
 77d:	8b 10                	mov    (%eax),%edx
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	89 10                	mov    %edx,(%eax)
 784:	eb 0a                	jmp    790 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 786:	8b 45 fc             	mov    -0x4(%ebp),%eax
 789:	8b 10                	mov    (%eax),%edx
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 790:	8b 45 fc             	mov    -0x4(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	01 d0                	add    %edx,%eax
 7a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a5:	75 20                	jne    7c7 <free+0xcf>
    p->s.size += bp->s.size;
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 50 04             	mov    0x4(%eax),%edx
 7ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	01 c2                	add    %eax,%edx
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	8b 10                	mov    (%eax),%edx
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	89 10                	mov    %edx,(%eax)
 7c5:	eb 08                	jmp    7cf <free+0xd7>
  } else
    p->s.ptr = bp;
 7c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7cd:	89 10                	mov    %edx,(%eax)
  freep = p;
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	a3 cc 0b 00 00       	mov    %eax,0xbcc
}
 7d7:	90                   	nop
 7d8:	c9                   	leave  
 7d9:	c3                   	ret    

000007da <morecore>:

static Header*
morecore(uint nu)
{
 7da:	55                   	push   %ebp
 7db:	89 e5                	mov    %esp,%ebp
 7dd:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7e0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7e7:	77 07                	ja     7f0 <morecore+0x16>
    nu = 4096;
 7e9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7f0:	8b 45 08             	mov    0x8(%ebp),%eax
 7f3:	c1 e0 03             	shl    $0x3,%eax
 7f6:	83 ec 0c             	sub    $0xc,%esp
 7f9:	50                   	push   %eax
 7fa:	e8 39 fc ff ff       	call   438 <sbrk>
 7ff:	83 c4 10             	add    $0x10,%esp
 802:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 805:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 809:	75 07                	jne    812 <morecore+0x38>
    return 0;
 80b:	b8 00 00 00 00       	mov    $0x0,%eax
 810:	eb 26                	jmp    838 <morecore+0x5e>
  hp = (Header*)p;
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 818:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81b:	8b 55 08             	mov    0x8(%ebp),%edx
 81e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 824:	83 c0 08             	add    $0x8,%eax
 827:	83 ec 0c             	sub    $0xc,%esp
 82a:	50                   	push   %eax
 82b:	e8 c8 fe ff ff       	call   6f8 <free>
 830:	83 c4 10             	add    $0x10,%esp
  return freep;
 833:	a1 cc 0b 00 00       	mov    0xbcc,%eax
}
 838:	c9                   	leave  
 839:	c3                   	ret    

0000083a <malloc>:

void*
malloc(uint nbytes)
{
 83a:	55                   	push   %ebp
 83b:	89 e5                	mov    %esp,%ebp
 83d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 840:	8b 45 08             	mov    0x8(%ebp),%eax
 843:	83 c0 07             	add    $0x7,%eax
 846:	c1 e8 03             	shr    $0x3,%eax
 849:	83 c0 01             	add    $0x1,%eax
 84c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 84f:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 854:	89 45 f0             	mov    %eax,-0x10(%ebp)
 857:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 85b:	75 23                	jne    880 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 85d:	c7 45 f0 c4 0b 00 00 	movl   $0xbc4,-0x10(%ebp)
 864:	8b 45 f0             	mov    -0x10(%ebp),%eax
 867:	a3 cc 0b 00 00       	mov    %eax,0xbcc
 86c:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 871:	a3 c4 0b 00 00       	mov    %eax,0xbc4
    base.s.size = 0;
 876:	c7 05 c8 0b 00 00 00 	movl   $0x0,0xbc8
 87d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 880:	8b 45 f0             	mov    -0x10(%ebp),%eax
 883:	8b 00                	mov    (%eax),%eax
 885:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8b 40 04             	mov    0x4(%eax),%eax
 88e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 891:	72 4d                	jb     8e0 <malloc+0xa6>
      if(p->s.size == nunits)
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	8b 40 04             	mov    0x4(%eax),%eax
 899:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89c:	75 0c                	jne    8aa <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 89e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a1:	8b 10                	mov    (%eax),%edx
 8a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a6:	89 10                	mov    %edx,(%eax)
 8a8:	eb 26                	jmp    8d0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	8b 40 04             	mov    0x4(%eax),%eax
 8b0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8b3:	89 c2                	mov    %eax,%edx
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	c1 e0 03             	shl    $0x3,%eax
 8c4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8cd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d3:	a3 cc 0b 00 00       	mov    %eax,0xbcc
      return (void*)(p + 1);
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	83 c0 08             	add    $0x8,%eax
 8de:	eb 3b                	jmp    91b <malloc+0xe1>
    }
    if(p == freep)
 8e0:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 8e5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8e8:	75 1e                	jne    908 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8ea:	83 ec 0c             	sub    $0xc,%esp
 8ed:	ff 75 ec             	pushl  -0x14(%ebp)
 8f0:	e8 e5 fe ff ff       	call   7da <morecore>
 8f5:	83 c4 10             	add    $0x10,%esp
 8f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ff:	75 07                	jne    908 <malloc+0xce>
        return 0;
 901:	b8 00 00 00 00       	mov    $0x0,%eax
 906:	eb 13                	jmp    91b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	8b 00                	mov    (%eax),%eax
 913:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 916:	e9 6d ff ff ff       	jmp    888 <malloc+0x4e>
}
 91b:	c9                   	leave  
 91c:	c3                   	ret    
