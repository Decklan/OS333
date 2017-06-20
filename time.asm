
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
  int before = uptime();
  14:	e8 cf 04 00 00       	call   4e8 <uptime>
  19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int f = fork(); 
  1c:	e8 27 04 00 00       	call   448 <fork>
  21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int after = 0;
  24:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  if (f < 0)
  2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  2f:	79 17                	jns    48 <main+0x48>
    printf(2, "Fork failed.");
  31:	83 ec 08             	sub    $0x8,%esp
  34:	68 dd 09 00 00       	push   $0x9dd
  39:	6a 02                	push   $0x2
  3b:	e8 e7 05 00 00       	call   627 <printf>
  40:	83 c4 10             	add    $0x10,%esp
  43:	e9 d9 00 00 00       	jmp    121 <main+0x121>
  else if (f == 0)
  48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  4c:	75 2f                	jne    7d <main+0x7d>
  {
    argv++;
  4e:	83 43 04 04          	addl   $0x4,0x4(%ebx)
    exec(argv[0], argv);
  52:	8b 43 04             	mov    0x4(%ebx),%eax
  55:	8b 00                	mov    (%eax),%eax
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	ff 73 04             	pushl  0x4(%ebx)
  5d:	50                   	push   %eax
  5e:	e8 25 04 00 00       	call   488 <exec>
  63:	83 c4 10             	add    $0x10,%esp
    printf(2, "ERROR: exec failed.\n");
  66:	83 ec 08             	sub    $0x8,%esp
  69:	68 ea 09 00 00       	push   $0x9ea
  6e:	6a 02                	push   $0x2
  70:	e8 b2 05 00 00       	call   627 <printf>
  75:	83 c4 10             	add    $0x10,%esp
  78:	e9 a4 00 00 00       	jmp    121 <main+0x121>
  } else {
    wait();
  7d:	e8 d6 03 00 00       	call   458 <wait>
    after = uptime();
  82:	e8 61 04 00 00       	call   4e8 <uptime>
  87:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int secs = (after-before)/100;
  8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  90:	89 c1                	mov    %eax,%ecx
  92:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  97:	89 c8                	mov    %ecx,%eax
  99:	f7 ea                	imul   %edx
  9b:	c1 fa 05             	sar    $0x5,%edx
  9e:	89 c8                	mov    %ecx,%eax
  a0:	c1 f8 1f             	sar    $0x1f,%eax
  a3:	29 c2                	sub    %eax,%edx
  a5:	89 d0                	mov    %edx,%eax
  a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int p_secs = (after-before)%100;
  aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  ad:	2b 45 f4             	sub    -0xc(%ebp),%eax
  b0:	89 c1                	mov    %eax,%ecx
  b2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  b7:	89 c8                	mov    %ecx,%eax
  b9:	f7 ea                	imul   %edx
  bb:	c1 fa 05             	sar    $0x5,%edx
  be:	89 c8                	mov    %ecx,%eax
  c0:	c1 f8 1f             	sar    $0x1f,%eax
  c3:	29 c2                	sub    %eax,%edx
  c5:	89 d0                	mov    %edx,%eax
  c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  cd:	6b c0 64             	imul   $0x64,%eax,%eax
  d0:	29 c1                	sub    %eax,%ecx
  d2:	89 c8                	mov    %ecx,%eax
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (p_secs < 10)
  d7:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
  db:	7f 23                	jg     100 <main+0x100>
      printf(1, "%s ran in %d.0%d seconds\n", argv[1], secs, p_secs);
  dd:	8b 43 04             	mov    0x4(%ebx),%eax
  e0:	83 c0 04             	add    $0x4,%eax
  e3:	8b 00                	mov    (%eax),%eax
  e5:	83 ec 0c             	sub    $0xc,%esp
  e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  eb:	ff 75 e8             	pushl  -0x18(%ebp)
  ee:	50                   	push   %eax
  ef:	68 ff 09 00 00       	push   $0x9ff
  f4:	6a 01                	push   $0x1
  f6:	e8 2c 05 00 00       	call   627 <printf>
  fb:	83 c4 20             	add    $0x20,%esp
  fe:	eb 21                	jmp    121 <main+0x121>
    else 
      printf(1, "%s ran in %d.%d seconds\n", argv[1], secs, p_secs); 
 100:	8b 43 04             	mov    0x4(%ebx),%eax
 103:	83 c0 04             	add    $0x4,%eax
 106:	8b 00                	mov    (%eax),%eax
 108:	83 ec 0c             	sub    $0xc,%esp
 10b:	ff 75 e4             	pushl  -0x1c(%ebp)
 10e:	ff 75 e8             	pushl  -0x18(%ebp)
 111:	50                   	push   %eax
 112:	68 19 0a 00 00       	push   $0xa19
 117:	6a 01                	push   $0x1
 119:	e8 09 05 00 00       	call   627 <printf>
 11e:	83 c4 20             	add    $0x20,%esp
  } 
  exit();
 121:	e8 2a 03 00 00       	call   450 <exit>

00000126 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
 129:	57                   	push   %edi
 12a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 12b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 12e:	8b 55 10             	mov    0x10(%ebp),%edx
 131:	8b 45 0c             	mov    0xc(%ebp),%eax
 134:	89 cb                	mov    %ecx,%ebx
 136:	89 df                	mov    %ebx,%edi
 138:	89 d1                	mov    %edx,%ecx
 13a:	fc                   	cld    
 13b:	f3 aa                	rep stos %al,%es:(%edi)
 13d:	89 ca                	mov    %ecx,%edx
 13f:	89 fb                	mov    %edi,%ebx
 141:	89 5d 08             	mov    %ebx,0x8(%ebp)
 144:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 147:	90                   	nop
 148:	5b                   	pop    %ebx
 149:	5f                   	pop    %edi
 14a:	5d                   	pop    %ebp
 14b:	c3                   	ret    

0000014c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 152:	8b 45 08             	mov    0x8(%ebp),%eax
 155:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 158:	90                   	nop
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	8d 50 01             	lea    0x1(%eax),%edx
 15f:	89 55 08             	mov    %edx,0x8(%ebp)
 162:	8b 55 0c             	mov    0xc(%ebp),%edx
 165:	8d 4a 01             	lea    0x1(%edx),%ecx
 168:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 16b:	0f b6 12             	movzbl (%edx),%edx
 16e:	88 10                	mov    %dl,(%eax)
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	84 c0                	test   %al,%al
 175:	75 e2                	jne    159 <strcpy+0xd>
    ;
  return os;
 177:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17a:	c9                   	leave  
 17b:	c3                   	ret    

0000017c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 17f:	eb 08                	jmp    189 <strcmp+0xd>
    p++, q++;
 181:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 185:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 00             	movzbl (%eax),%eax
 18f:	84 c0                	test   %al,%al
 191:	74 10                	je     1a3 <strcmp+0x27>
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 10             	movzbl (%eax),%edx
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	38 c2                	cmp    %al,%dl
 1a1:	74 de                	je     181 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	0f b6 00             	movzbl (%eax),%eax
 1a9:	0f b6 d0             	movzbl %al,%edx
 1ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 1af:	0f b6 00             	movzbl (%eax),%eax
 1b2:	0f b6 c0             	movzbl %al,%eax
 1b5:	29 c2                	sub    %eax,%edx
 1b7:	89 d0                	mov    %edx,%eax
}
 1b9:	5d                   	pop    %ebp
 1ba:	c3                   	ret    

000001bb <strlen>:

uint
strlen(char *s)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c8:	eb 04                	jmp    1ce <strlen+0x13>
 1ca:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	01 d0                	add    %edx,%eax
 1d6:	0f b6 00             	movzbl (%eax),%eax
 1d9:	84 c0                	test   %al,%al
 1db:	75 ed                	jne    1ca <strlen+0xf>
    ;
  return n;
 1dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1e5:	8b 45 10             	mov    0x10(%ebp),%eax
 1e8:	50                   	push   %eax
 1e9:	ff 75 0c             	pushl  0xc(%ebp)
 1ec:	ff 75 08             	pushl  0x8(%ebp)
 1ef:	e8 32 ff ff ff       	call   126 <stosb>
 1f4:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fa:	c9                   	leave  
 1fb:	c3                   	ret    

000001fc <strchr>:

char*
strchr(const char *s, char c)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	83 ec 04             	sub    $0x4,%esp
 202:	8b 45 0c             	mov    0xc(%ebp),%eax
 205:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 208:	eb 14                	jmp    21e <strchr+0x22>
    if(*s == c)
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	3a 45 fc             	cmp    -0x4(%ebp),%al
 213:	75 05                	jne    21a <strchr+0x1e>
      return (char*)s;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	eb 13                	jmp    22d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 21a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	84 c0                	test   %al,%al
 226:	75 e2                	jne    20a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 228:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <gets>:

char*
gets(char *buf, int max)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 23c:	eb 42                	jmp    280 <gets+0x51>
    cc = read(0, &c, 1);
 23e:	83 ec 04             	sub    $0x4,%esp
 241:	6a 01                	push   $0x1
 243:	8d 45 ef             	lea    -0x11(%ebp),%eax
 246:	50                   	push   %eax
 247:	6a 00                	push   $0x0
 249:	e8 1a 02 00 00       	call   468 <read>
 24e:	83 c4 10             	add    $0x10,%esp
 251:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 258:	7e 33                	jle    28d <gets+0x5e>
      break;
    buf[i++] = c;
 25a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 f4             	mov    %edx,-0xc(%ebp)
 263:	89 c2                	mov    %eax,%edx
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	01 c2                	add    %eax,%edx
 26a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	3c 0a                	cmp    $0xa,%al
 276:	74 16                	je     28e <gets+0x5f>
 278:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27c:	3c 0d                	cmp    $0xd,%al
 27e:	74 0e                	je     28e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 280:	8b 45 f4             	mov    -0xc(%ebp),%eax
 283:	83 c0 01             	add    $0x1,%eax
 286:	3b 45 0c             	cmp    0xc(%ebp),%eax
 289:	7c b3                	jl     23e <gets+0xf>
 28b:	eb 01                	jmp    28e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 28d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 d0                	add    %edx,%eax
 296:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 299:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29c:	c9                   	leave  
 29d:	c3                   	ret    

0000029e <stat>:

int
stat(char *n, struct stat *st)
{
 29e:	55                   	push   %ebp
 29f:	89 e5                	mov    %esp,%ebp
 2a1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a4:	83 ec 08             	sub    $0x8,%esp
 2a7:	6a 00                	push   $0x0
 2a9:	ff 75 08             	pushl  0x8(%ebp)
 2ac:	e8 df 01 00 00       	call   490 <open>
 2b1:	83 c4 10             	add    $0x10,%esp
 2b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2bb:	79 07                	jns    2c4 <stat+0x26>
    return -1;
 2bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c2:	eb 25                	jmp    2e9 <stat+0x4b>
  r = fstat(fd, st);
 2c4:	83 ec 08             	sub    $0x8,%esp
 2c7:	ff 75 0c             	pushl  0xc(%ebp)
 2ca:	ff 75 f4             	pushl  -0xc(%ebp)
 2cd:	e8 d6 01 00 00       	call   4a8 <fstat>
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d8:	83 ec 0c             	sub    $0xc,%esp
 2db:	ff 75 f4             	pushl  -0xc(%ebp)
 2de:	e8 95 01 00 00       	call   478 <close>
 2e3:	83 c4 10             	add    $0x10,%esp
  return r;
 2e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <atoi>:

int
atoi(const char *s)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 2f8:	eb 04                	jmp    2fe <atoi+0x13>
 2fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	0f b6 00             	movzbl (%eax),%eax
 304:	3c 20                	cmp    $0x20,%al
 306:	74 f2                	je     2fa <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 2d                	cmp    $0x2d,%al
 310:	75 07                	jne    319 <atoi+0x2e>
 312:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 317:	eb 05                	jmp    31e <atoi+0x33>
 319:	b8 01 00 00 00       	mov    $0x1,%eax
 31e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	0f b6 00             	movzbl (%eax),%eax
 327:	3c 2b                	cmp    $0x2b,%al
 329:	74 0a                	je     335 <atoi+0x4a>
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	0f b6 00             	movzbl (%eax),%eax
 331:	3c 2d                	cmp    $0x2d,%al
 333:	75 2b                	jne    360 <atoi+0x75>
    s++;
 335:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 339:	eb 25                	jmp    360 <atoi+0x75>
    n = n*10 + *s++ - '0';
 33b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33e:	89 d0                	mov    %edx,%eax
 340:	c1 e0 02             	shl    $0x2,%eax
 343:	01 d0                	add    %edx,%eax
 345:	01 c0                	add    %eax,%eax
 347:	89 c1                	mov    %eax,%ecx
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	8d 50 01             	lea    0x1(%eax),%edx
 34f:	89 55 08             	mov    %edx,0x8(%ebp)
 352:	0f b6 00             	movzbl (%eax),%eax
 355:	0f be c0             	movsbl %al,%eax
 358:	01 c8                	add    %ecx,%eax
 35a:	83 e8 30             	sub    $0x30,%eax
 35d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	0f b6 00             	movzbl (%eax),%eax
 366:	3c 2f                	cmp    $0x2f,%al
 368:	7e 0a                	jle    374 <atoi+0x89>
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	0f b6 00             	movzbl (%eax),%eax
 370:	3c 39                	cmp    $0x39,%al
 372:	7e c7                	jle    33b <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 374:	8b 45 f8             	mov    -0x8(%ebp),%eax
 377:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 37b:	c9                   	leave  
 37c:	c3                   	ret    

0000037d <atoo>:

int
atoo(const char *s)
{
 37d:	55                   	push   %ebp
 37e:	89 e5                	mov    %esp,%ebp
 380:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 383:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 38a:	eb 04                	jmp    390 <atoo+0x13>
 38c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	3c 20                	cmp    $0x20,%al
 398:	74 f2                	je     38c <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 39a:	8b 45 08             	mov    0x8(%ebp),%eax
 39d:	0f b6 00             	movzbl (%eax),%eax
 3a0:	3c 2d                	cmp    $0x2d,%al
 3a2:	75 07                	jne    3ab <atoo+0x2e>
 3a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3a9:	eb 05                	jmp    3b0 <atoo+0x33>
 3ab:	b8 01 00 00 00       	mov    $0x1,%eax
 3b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	3c 2b                	cmp    $0x2b,%al
 3bb:	74 0a                	je     3c7 <atoo+0x4a>
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 2d                	cmp    $0x2d,%al
 3c5:	75 27                	jne    3ee <atoo+0x71>
    s++;
 3c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3cb:	eb 21                	jmp    3ee <atoo+0x71>
    n = n*8 + *s++ - '0';
 3cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	8d 50 01             	lea    0x1(%eax),%edx
 3dd:	89 55 08             	mov    %edx,0x8(%ebp)
 3e0:	0f b6 00             	movzbl (%eax),%eax
 3e3:	0f be c0             	movsbl %al,%eax
 3e6:	01 c8                	add    %ecx,%eax
 3e8:	83 e8 30             	sub    $0x30,%eax
 3eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	0f b6 00             	movzbl (%eax),%eax
 3f4:	3c 2f                	cmp    $0x2f,%al
 3f6:	7e 0a                	jle    402 <atoo+0x85>
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	0f b6 00             	movzbl (%eax),%eax
 3fe:	3c 37                	cmp    $0x37,%al
 400:	7e cb                	jle    3cd <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 402:	8b 45 f8             	mov    -0x8(%ebp),%eax
 405:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 409:	c9                   	leave  
 40a:	c3                   	ret    

0000040b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 40b:	55                   	push   %ebp
 40c:	89 e5                	mov    %esp,%ebp
 40e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 417:	8b 45 0c             	mov    0xc(%ebp),%eax
 41a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 41d:	eb 17                	jmp    436 <memmove+0x2b>
    *dst++ = *src++;
 41f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 422:	8d 50 01             	lea    0x1(%eax),%edx
 425:	89 55 fc             	mov    %edx,-0x4(%ebp)
 428:	8b 55 f8             	mov    -0x8(%ebp),%edx
 42b:	8d 4a 01             	lea    0x1(%edx),%ecx
 42e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 431:	0f b6 12             	movzbl (%edx),%edx
 434:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 436:	8b 45 10             	mov    0x10(%ebp),%eax
 439:	8d 50 ff             	lea    -0x1(%eax),%edx
 43c:	89 55 10             	mov    %edx,0x10(%ebp)
 43f:	85 c0                	test   %eax,%eax
 441:	7f dc                	jg     41f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 443:	8b 45 08             	mov    0x8(%ebp),%eax
}
 446:	c9                   	leave  
 447:	c3                   	ret    

00000448 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 448:	b8 01 00 00 00       	mov    $0x1,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <exit>:
SYSCALL(exit)
 450:	b8 02 00 00 00       	mov    $0x2,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <wait>:
SYSCALL(wait)
 458:	b8 03 00 00 00       	mov    $0x3,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <pipe>:
SYSCALL(pipe)
 460:	b8 04 00 00 00       	mov    $0x4,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <read>:
SYSCALL(read)
 468:	b8 05 00 00 00       	mov    $0x5,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <write>:
SYSCALL(write)
 470:	b8 10 00 00 00       	mov    $0x10,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <close>:
SYSCALL(close)
 478:	b8 15 00 00 00       	mov    $0x15,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <kill>:
SYSCALL(kill)
 480:	b8 06 00 00 00       	mov    $0x6,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <exec>:
SYSCALL(exec)
 488:	b8 07 00 00 00       	mov    $0x7,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <open>:
SYSCALL(open)
 490:	b8 0f 00 00 00       	mov    $0xf,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <mknod>:
SYSCALL(mknod)
 498:	b8 11 00 00 00       	mov    $0x11,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <unlink>:
SYSCALL(unlink)
 4a0:	b8 12 00 00 00       	mov    $0x12,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <fstat>:
SYSCALL(fstat)
 4a8:	b8 08 00 00 00       	mov    $0x8,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <link>:
SYSCALL(link)
 4b0:	b8 13 00 00 00       	mov    $0x13,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <mkdir>:
SYSCALL(mkdir)
 4b8:	b8 14 00 00 00       	mov    $0x14,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <chdir>:
SYSCALL(chdir)
 4c0:	b8 09 00 00 00       	mov    $0x9,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <dup>:
SYSCALL(dup)
 4c8:	b8 0a 00 00 00       	mov    $0xa,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <getpid>:
SYSCALL(getpid)
 4d0:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <sbrk>:
SYSCALL(sbrk)
 4d8:	b8 0c 00 00 00       	mov    $0xc,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <sleep>:
SYSCALL(sleep)
 4e0:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <uptime>:
SYSCALL(uptime)
 4e8:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <halt>:
SYSCALL(halt)
 4f0:	b8 16 00 00 00       	mov    $0x16,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <date>:
SYSCALL(date)        #p1
 4f8:	b8 17 00 00 00       	mov    $0x17,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <getuid>:
SYSCALL(getuid)      #p2
 500:	b8 18 00 00 00       	mov    $0x18,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <getgid>:
SYSCALL(getgid)      #p2
 508:	b8 19 00 00 00       	mov    $0x19,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <getppid>:
SYSCALL(getppid)     #p2
 510:	b8 1a 00 00 00       	mov    $0x1a,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <setuid>:
SYSCALL(setuid)      #p2
 518:	b8 1b 00 00 00       	mov    $0x1b,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <setgid>:
SYSCALL(setgid)      #p2
 520:	b8 1c 00 00 00       	mov    $0x1c,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <getprocs>:
SYSCALL(getprocs)    #p2
 528:	b8 1d 00 00 00       	mov    $0x1d,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <setpriority>:
SYSCALL(setpriority) #p4
 530:	b8 1e 00 00 00       	mov    $0x1e,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <chmod>:
SYSCALL(chmod)       #p5
 538:	b8 1f 00 00 00       	mov    $0x1f,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <chown>:
SYSCALL(chown)       #p5
 540:	b8 20 00 00 00       	mov    $0x20,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <chgrp>:
SYSCALL(chgrp)       #p5
 548:	b8 21 00 00 00       	mov    $0x21,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	83 ec 18             	sub    $0x18,%esp
 556:	8b 45 0c             	mov    0xc(%ebp),%eax
 559:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 55c:	83 ec 04             	sub    $0x4,%esp
 55f:	6a 01                	push   $0x1
 561:	8d 45 f4             	lea    -0xc(%ebp),%eax
 564:	50                   	push   %eax
 565:	ff 75 08             	pushl  0x8(%ebp)
 568:	e8 03 ff ff ff       	call   470 <write>
 56d:	83 c4 10             	add    $0x10,%esp
}
 570:	90                   	nop
 571:	c9                   	leave  
 572:	c3                   	ret    

00000573 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 573:	55                   	push   %ebp
 574:	89 e5                	mov    %esp,%ebp
 576:	53                   	push   %ebx
 577:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 57a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 581:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 585:	74 17                	je     59e <printint+0x2b>
 587:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 58b:	79 11                	jns    59e <printint+0x2b>
    neg = 1;
 58d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 594:	8b 45 0c             	mov    0xc(%ebp),%eax
 597:	f7 d8                	neg    %eax
 599:	89 45 ec             	mov    %eax,-0x14(%ebp)
 59c:	eb 06                	jmp    5a4 <printint+0x31>
  } else {
    x = xx;
 59e:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5ab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5ae:	8d 41 01             	lea    0x1(%ecx),%eax
 5b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ba:	ba 00 00 00 00       	mov    $0x0,%edx
 5bf:	f7 f3                	div    %ebx
 5c1:	89 d0                	mov    %edx,%eax
 5c3:	0f b6 80 a8 0c 00 00 	movzbl 0xca8(%eax),%eax
 5ca:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5d4:	ba 00 00 00 00       	mov    $0x0,%edx
 5d9:	f7 f3                	div    %ebx
 5db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e2:	75 c7                	jne    5ab <printint+0x38>
  if(neg)
 5e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5e8:	74 2d                	je     617 <printint+0xa4>
    buf[i++] = '-';
 5ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ed:	8d 50 01             	lea    0x1(%eax),%edx
 5f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5f3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5f8:	eb 1d                	jmp    617 <printint+0xa4>
    putc(fd, buf[i]);
 5fa:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 600:	01 d0                	add    %edx,%eax
 602:	0f b6 00             	movzbl (%eax),%eax
 605:	0f be c0             	movsbl %al,%eax
 608:	83 ec 08             	sub    $0x8,%esp
 60b:	50                   	push   %eax
 60c:	ff 75 08             	pushl  0x8(%ebp)
 60f:	e8 3c ff ff ff       	call   550 <putc>
 614:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 617:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 61b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 61f:	79 d9                	jns    5fa <printint+0x87>
    putc(fd, buf[i]);
}
 621:	90                   	nop
 622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 625:	c9                   	leave  
 626:	c3                   	ret    

00000627 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 627:	55                   	push   %ebp
 628:	89 e5                	mov    %esp,%ebp
 62a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 62d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 634:	8d 45 0c             	lea    0xc(%ebp),%eax
 637:	83 c0 04             	add    $0x4,%eax
 63a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 63d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 644:	e9 59 01 00 00       	jmp    7a2 <printf+0x17b>
    c = fmt[i] & 0xff;
 649:	8b 55 0c             	mov    0xc(%ebp),%edx
 64c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64f:	01 d0                	add    %edx,%eax
 651:	0f b6 00             	movzbl (%eax),%eax
 654:	0f be c0             	movsbl %al,%eax
 657:	25 ff 00 00 00       	and    $0xff,%eax
 65c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 65f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 663:	75 2c                	jne    691 <printf+0x6a>
      if(c == '%'){
 665:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 669:	75 0c                	jne    677 <printf+0x50>
        state = '%';
 66b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 672:	e9 27 01 00 00       	jmp    79e <printf+0x177>
      } else {
        putc(fd, c);
 677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67a:	0f be c0             	movsbl %al,%eax
 67d:	83 ec 08             	sub    $0x8,%esp
 680:	50                   	push   %eax
 681:	ff 75 08             	pushl  0x8(%ebp)
 684:	e8 c7 fe ff ff       	call   550 <putc>
 689:	83 c4 10             	add    $0x10,%esp
 68c:	e9 0d 01 00 00       	jmp    79e <printf+0x177>
      }
    } else if(state == '%'){
 691:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 695:	0f 85 03 01 00 00    	jne    79e <printf+0x177>
      if(c == 'd'){
 69b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 69f:	75 1e                	jne    6bf <printf+0x98>
        printint(fd, *ap, 10, 1);
 6a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	6a 01                	push   $0x1
 6a8:	6a 0a                	push   $0xa
 6aa:	50                   	push   %eax
 6ab:	ff 75 08             	pushl  0x8(%ebp)
 6ae:	e8 c0 fe ff ff       	call   573 <printint>
 6b3:	83 c4 10             	add    $0x10,%esp
        ap++;
 6b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ba:	e9 d8 00 00 00       	jmp    797 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6bf:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6c3:	74 06                	je     6cb <printf+0xa4>
 6c5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6c9:	75 1e                	jne    6e9 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	6a 00                	push   $0x0
 6d2:	6a 10                	push   $0x10
 6d4:	50                   	push   %eax
 6d5:	ff 75 08             	pushl  0x8(%ebp)
 6d8:	e8 96 fe ff ff       	call   573 <printint>
 6dd:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e4:	e9 ae 00 00 00       	jmp    797 <printf+0x170>
      } else if(c == 's'){
 6e9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6ed:	75 43                	jne    732 <printf+0x10b>
        s = (char*)*ap;
 6ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f2:	8b 00                	mov    (%eax),%eax
 6f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ff:	75 25                	jne    726 <printf+0xff>
          s = "(null)";
 701:	c7 45 f4 32 0a 00 00 	movl   $0xa32,-0xc(%ebp)
        while(*s != 0){
 708:	eb 1c                	jmp    726 <printf+0xff>
          putc(fd, *s);
 70a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70d:	0f b6 00             	movzbl (%eax),%eax
 710:	0f be c0             	movsbl %al,%eax
 713:	83 ec 08             	sub    $0x8,%esp
 716:	50                   	push   %eax
 717:	ff 75 08             	pushl  0x8(%ebp)
 71a:	e8 31 fe ff ff       	call   550 <putc>
 71f:	83 c4 10             	add    $0x10,%esp
          s++;
 722:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 726:	8b 45 f4             	mov    -0xc(%ebp),%eax
 729:	0f b6 00             	movzbl (%eax),%eax
 72c:	84 c0                	test   %al,%al
 72e:	75 da                	jne    70a <printf+0xe3>
 730:	eb 65                	jmp    797 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 732:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 736:	75 1d                	jne    755 <printf+0x12e>
        putc(fd, *ap);
 738:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73b:	8b 00                	mov    (%eax),%eax
 73d:	0f be c0             	movsbl %al,%eax
 740:	83 ec 08             	sub    $0x8,%esp
 743:	50                   	push   %eax
 744:	ff 75 08             	pushl  0x8(%ebp)
 747:	e8 04 fe ff ff       	call   550 <putc>
 74c:	83 c4 10             	add    $0x10,%esp
        ap++;
 74f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 753:	eb 42                	jmp    797 <printf+0x170>
      } else if(c == '%'){
 755:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 759:	75 17                	jne    772 <printf+0x14b>
        putc(fd, c);
 75b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75e:	0f be c0             	movsbl %al,%eax
 761:	83 ec 08             	sub    $0x8,%esp
 764:	50                   	push   %eax
 765:	ff 75 08             	pushl  0x8(%ebp)
 768:	e8 e3 fd ff ff       	call   550 <putc>
 76d:	83 c4 10             	add    $0x10,%esp
 770:	eb 25                	jmp    797 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 772:	83 ec 08             	sub    $0x8,%esp
 775:	6a 25                	push   $0x25
 777:	ff 75 08             	pushl  0x8(%ebp)
 77a:	e8 d1 fd ff ff       	call   550 <putc>
 77f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 785:	0f be c0             	movsbl %al,%eax
 788:	83 ec 08             	sub    $0x8,%esp
 78b:	50                   	push   %eax
 78c:	ff 75 08             	pushl  0x8(%ebp)
 78f:	e8 bc fd ff ff       	call   550 <putc>
 794:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 797:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 79e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7a2:	8b 55 0c             	mov    0xc(%ebp),%edx
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	01 d0                	add    %edx,%eax
 7aa:	0f b6 00             	movzbl (%eax),%eax
 7ad:	84 c0                	test   %al,%al
 7af:	0f 85 94 fe ff ff    	jne    649 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7b5:	90                   	nop
 7b6:	c9                   	leave  
 7b7:	c3                   	ret    

000007b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b8:	55                   	push   %ebp
 7b9:	89 e5                	mov    %esp,%ebp
 7bb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7be:	8b 45 08             	mov    0x8(%ebp),%eax
 7c1:	83 e8 08             	sub    $0x8,%eax
 7c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c7:	a1 c4 0c 00 00       	mov    0xcc4,%eax
 7cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7cf:	eb 24                	jmp    7f5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d9:	77 12                	ja     7ed <free+0x35>
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e1:	77 24                	ja     807 <free+0x4f>
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7eb:	77 1a                	ja     807 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7fb:	76 d4                	jbe    7d1 <free+0x19>
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 805:	76 ca                	jbe    7d1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 807:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80a:	8b 40 04             	mov    0x4(%eax),%eax
 80d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 814:	8b 45 f8             	mov    -0x8(%ebp),%eax
 817:	01 c2                	add    %eax,%edx
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	39 c2                	cmp    %eax,%edx
 820:	75 24                	jne    846 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 822:	8b 45 f8             	mov    -0x8(%ebp),%eax
 825:	8b 50 04             	mov    0x4(%eax),%edx
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 00                	mov    (%eax),%eax
 82d:	8b 40 04             	mov    0x4(%eax),%eax
 830:	01 c2                	add    %eax,%edx
 832:	8b 45 f8             	mov    -0x8(%ebp),%eax
 835:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 838:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	8b 10                	mov    (%eax),%edx
 83f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 842:	89 10                	mov    %edx,(%eax)
 844:	eb 0a                	jmp    850 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	8b 10                	mov    (%eax),%edx
 84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	8b 40 04             	mov    0x4(%eax),%eax
 856:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 860:	01 d0                	add    %edx,%eax
 862:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 865:	75 20                	jne    887 <free+0xcf>
    p->s.size += bp->s.size;
 867:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86a:	8b 50 04             	mov    0x4(%eax),%edx
 86d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 870:	8b 40 04             	mov    0x4(%eax),%eax
 873:	01 c2                	add    %eax,%edx
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 87b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87e:	8b 10                	mov    (%eax),%edx
 880:	8b 45 fc             	mov    -0x4(%ebp),%eax
 883:	89 10                	mov    %edx,(%eax)
 885:	eb 08                	jmp    88f <free+0xd7>
  } else
    p->s.ptr = bp;
 887:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 88d:	89 10                	mov    %edx,(%eax)
  freep = p;
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	a3 c4 0c 00 00       	mov    %eax,0xcc4
}
 897:	90                   	nop
 898:	c9                   	leave  
 899:	c3                   	ret    

0000089a <morecore>:

static Header*
morecore(uint nu)
{
 89a:	55                   	push   %ebp
 89b:	89 e5                	mov    %esp,%ebp
 89d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8a0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8a7:	77 07                	ja     8b0 <morecore+0x16>
    nu = 4096;
 8a9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8b0:	8b 45 08             	mov    0x8(%ebp),%eax
 8b3:	c1 e0 03             	shl    $0x3,%eax
 8b6:	83 ec 0c             	sub    $0xc,%esp
 8b9:	50                   	push   %eax
 8ba:	e8 19 fc ff ff       	call   4d8 <sbrk>
 8bf:	83 c4 10             	add    $0x10,%esp
 8c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8c5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8c9:	75 07                	jne    8d2 <morecore+0x38>
    return 0;
 8cb:	b8 00 00 00 00       	mov    $0x0,%eax
 8d0:	eb 26                	jmp    8f8 <morecore+0x5e>
  hp = (Header*)p;
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8db:	8b 55 08             	mov    0x8(%ebp),%edx
 8de:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	83 c0 08             	add    $0x8,%eax
 8e7:	83 ec 0c             	sub    $0xc,%esp
 8ea:	50                   	push   %eax
 8eb:	e8 c8 fe ff ff       	call   7b8 <free>
 8f0:	83 c4 10             	add    $0x10,%esp
  return freep;
 8f3:	a1 c4 0c 00 00       	mov    0xcc4,%eax
}
 8f8:	c9                   	leave  
 8f9:	c3                   	ret    

000008fa <malloc>:

void*
malloc(uint nbytes)
{
 8fa:	55                   	push   %ebp
 8fb:	89 e5                	mov    %esp,%ebp
 8fd:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 900:	8b 45 08             	mov    0x8(%ebp),%eax
 903:	83 c0 07             	add    $0x7,%eax
 906:	c1 e8 03             	shr    $0x3,%eax
 909:	83 c0 01             	add    $0x1,%eax
 90c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 90f:	a1 c4 0c 00 00       	mov    0xcc4,%eax
 914:	89 45 f0             	mov    %eax,-0x10(%ebp)
 917:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 91b:	75 23                	jne    940 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 91d:	c7 45 f0 bc 0c 00 00 	movl   $0xcbc,-0x10(%ebp)
 924:	8b 45 f0             	mov    -0x10(%ebp),%eax
 927:	a3 c4 0c 00 00       	mov    %eax,0xcc4
 92c:	a1 c4 0c 00 00       	mov    0xcc4,%eax
 931:	a3 bc 0c 00 00       	mov    %eax,0xcbc
    base.s.size = 0;
 936:	c7 05 c0 0c 00 00 00 	movl   $0x0,0xcc0
 93d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 940:	8b 45 f0             	mov    -0x10(%ebp),%eax
 943:	8b 00                	mov    (%eax),%eax
 945:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 948:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94b:	8b 40 04             	mov    0x4(%eax),%eax
 94e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 951:	72 4d                	jb     9a0 <malloc+0xa6>
      if(p->s.size == nunits)
 953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 956:	8b 40 04             	mov    0x4(%eax),%eax
 959:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 95c:	75 0c                	jne    96a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	8b 10                	mov    (%eax),%edx
 963:	8b 45 f0             	mov    -0x10(%ebp),%eax
 966:	89 10                	mov    %edx,(%eax)
 968:	eb 26                	jmp    990 <malloc+0x96>
      else {
        p->s.size -= nunits;
 96a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96d:	8b 40 04             	mov    0x4(%eax),%eax
 970:	2b 45 ec             	sub    -0x14(%ebp),%eax
 973:	89 c2                	mov    %eax,%edx
 975:	8b 45 f4             	mov    -0xc(%ebp),%eax
 978:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 97b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97e:	8b 40 04             	mov    0x4(%eax),%eax
 981:	c1 e0 03             	shl    $0x3,%eax
 984:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 987:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 98d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 990:	8b 45 f0             	mov    -0x10(%ebp),%eax
 993:	a3 c4 0c 00 00       	mov    %eax,0xcc4
      return (void*)(p + 1);
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	83 c0 08             	add    $0x8,%eax
 99e:	eb 3b                	jmp    9db <malloc+0xe1>
    }
    if(p == freep)
 9a0:	a1 c4 0c 00 00       	mov    0xcc4,%eax
 9a5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9a8:	75 1e                	jne    9c8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9aa:	83 ec 0c             	sub    $0xc,%esp
 9ad:	ff 75 ec             	pushl  -0x14(%ebp)
 9b0:	e8 e5 fe ff ff       	call   89a <morecore>
 9b5:	83 c4 10             	add    $0x10,%esp
 9b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9bf:	75 07                	jne    9c8 <malloc+0xce>
        return 0;
 9c1:	b8 00 00 00 00       	mov    $0x0,%eax
 9c6:	eb 13                	jmp    9db <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d1:	8b 00                	mov    (%eax),%eax
 9d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9d6:	e9 6d ff ff ff       	jmp    948 <malloc+0x4e>
}
 9db:	c9                   	leave  
 9dc:	c3                   	ret    
