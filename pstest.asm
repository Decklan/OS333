
_pstest:     file format elf32-i386


Disassembly of section .text:

00000000 <forktest>:
#include "user.h"
#define TPS 100

void
forktest(int N)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
   6:	83 ec 08             	sub    $0x8,%esp
   9:	68 cc 09 00 00       	push   $0x9cc
   e:	6a 01                	push   $0x1
  10:	e8 00 06 00 00       	call   615 <printf>
  15:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1f:	eb 2d                	jmp    4e <forktest+0x4e>
    pid = fork();
  21:	e8 10 04 00 00       	call   436 <fork>
  26:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  2d:	78 29                	js     58 <forktest+0x58>
      break;
    if(pid == 0) {
  2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  33:	75 15                	jne    4a <forktest+0x4a>
      sleep(50*TPS);
  35:	83 ec 0c             	sub    $0xc,%esp
  38:	68 88 13 00 00       	push   $0x1388
  3d:	e8 8c 04 00 00       	call   4ce <sleep>
  42:	83 c4 10             	add    $0x10,%esp
      exit();
  45:	e8 f4 03 00 00       	call   43e <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	3b 45 08             	cmp    0x8(%ebp),%eax
  54:	7c cb                	jl     21 <forktest+0x21>
  56:	eb 27                	jmp    7f <forktest+0x7f>
    pid = fork();
    if(pid < 0)
      break;
  58:	90                   	nop
      sleep(50*TPS);
      exit();
    }
  }
  
  for(; n > 0; n--){
  59:	eb 24                	jmp    7f <forktest+0x7f>
    if(wait() < 0){
  5b:	e8 e6 03 00 00       	call   446 <wait>
  60:	85 c0                	test   %eax,%eax
  62:	79 17                	jns    7b <forktest+0x7b>
      printf(1, "wait stopped early\n");
  64:	83 ec 08             	sub    $0x8,%esp
  67:	68 d7 09 00 00       	push   $0x9d7
  6c:	6a 01                	push   $0x1
  6e:	e8 a2 05 00 00       	call   615 <printf>
  73:	83 c4 10             	add    $0x10,%esp
      exit();
  76:	e8 c3 03 00 00       	call   43e <exit>
      sleep(50*TPS);
      exit();
    }
  }
  
  for(; n > 0; n--){
  7b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  83:	7f d6                	jg     5b <forktest+0x5b>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  85:	e8 bc 03 00 00       	call   446 <wait>
  8a:	83 f8 ff             	cmp    $0xffffffff,%eax
  8d:	74 17                	je     a6 <forktest+0xa6>
    printf(1, "wait got too many\n");
  8f:	83 ec 08             	sub    $0x8,%esp
  92:	68 eb 09 00 00       	push   $0x9eb
  97:	6a 01                	push   $0x1
  99:	e8 77 05 00 00       	call   615 <printf>
  9e:	83 c4 10             	add    $0x10,%esp
    exit();
  a1:	e8 98 03 00 00       	call   43e <exit>
  }
  
  printf(1, "fork test OK\n");
  a6:	83 ec 08             	sub    $0x8,%esp
  a9:	68 fe 09 00 00       	push   $0x9fe
  ae:	6a 01                	push   $0x1
  b0:	e8 60 05 00 00       	call   615 <printf>
  b5:	83 c4 10             	add    $0x10,%esp
}
  b8:	90                   	nop
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <main>:

int
main(int argc, char **argv)
{
  bb:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  bf:	83 e4 f0             	and    $0xfffffff0,%esp
  c2:	ff 71 fc             	pushl  -0x4(%ecx)
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	51                   	push   %ecx
  c9:	83 ec 14             	sub    $0x14,%esp
  cc:	89 c8                	mov    %ecx,%eax
  int N;

  if (argc == 1) {
  ce:	83 38 01             	cmpl   $0x1,(%eax)
  d1:	75 17                	jne    ea <main+0x2f>
    printf(2, "Enter number of processes to create\n");
  d3:	83 ec 08             	sub    $0x8,%esp
  d6:	68 0c 0a 00 00       	push   $0xa0c
  db:	6a 02                	push   $0x2
  dd:	e8 33 05 00 00       	call   615 <printf>
  e2:	83 c4 10             	add    $0x10,%esp
    exit();
  e5:	e8 54 03 00 00       	call   43e <exit>
  }

  N = atoi(argv[1]);
  ea:	8b 40 04             	mov    0x4(%eax),%eax
  ed:	83 c0 04             	add    $0x4,%eax
  f0:	8b 00                	mov    (%eax),%eax
  f2:	83 ec 0c             	sub    $0xc,%esp
  f5:	50                   	push   %eax
  f6:	e8 de 01 00 00       	call   2d9 <atoi>
  fb:	83 c4 10             	add    $0x10,%esp
  fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  forktest(N);
 101:	83 ec 0c             	sub    $0xc,%esp
 104:	ff 75 f4             	pushl  -0xc(%ebp)
 107:	e8 f4 fe ff ff       	call   0 <forktest>
 10c:	83 c4 10             	add    $0x10,%esp
  exit();
 10f:	e8 2a 03 00 00       	call   43e <exit>

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
 237:	e8 1a 02 00 00       	call   456 <read>
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
 29a:	e8 df 01 00 00       	call   47e <open>
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
 2bb:	e8 d6 01 00 00       	call   496 <fstat>
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c6:	83 ec 0c             	sub    $0xc,%esp
 2c9:	ff 75 f4             	pushl  -0xc(%ebp)
 2cc:	e8 95 01 00 00       	call   466 <close>
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

0000036b <atoo>:

int
atoo(const char *s)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 378:	eb 04                	jmp    37e <atoo+0x13>
 37a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	0f b6 00             	movzbl (%eax),%eax
 384:	3c 20                	cmp    $0x20,%al
 386:	74 f2                	je     37a <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	0f b6 00             	movzbl (%eax),%eax
 38e:	3c 2d                	cmp    $0x2d,%al
 390:	75 07                	jne    399 <atoo+0x2e>
 392:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 397:	eb 05                	jmp    39e <atoo+0x33>
 399:	b8 01 00 00 00       	mov    $0x1,%eax
 39e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	0f b6 00             	movzbl (%eax),%eax
 3a7:	3c 2b                	cmp    $0x2b,%al
 3a9:	74 0a                	je     3b5 <atoo+0x4a>
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	0f b6 00             	movzbl (%eax),%eax
 3b1:	3c 2d                	cmp    $0x2d,%al
 3b3:	75 27                	jne    3dc <atoo+0x71>
    s++;
 3b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3b9:	eb 21                	jmp    3dc <atoo+0x71>
    n = n*8 + *s++ - '0';
 3bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3be:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3c5:	8b 45 08             	mov    0x8(%ebp),%eax
 3c8:	8d 50 01             	lea    0x1(%eax),%edx
 3cb:	89 55 08             	mov    %edx,0x8(%ebp)
 3ce:	0f b6 00             	movzbl (%eax),%eax
 3d1:	0f be c0             	movsbl %al,%eax
 3d4:	01 c8                	add    %ecx,%eax
 3d6:	83 e8 30             	sub    $0x30,%eax
 3d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	0f b6 00             	movzbl (%eax),%eax
 3e2:	3c 2f                	cmp    $0x2f,%al
 3e4:	7e 0a                	jle    3f0 <atoo+0x85>
 3e6:	8b 45 08             	mov    0x8(%ebp),%eax
 3e9:	0f b6 00             	movzbl (%eax),%eax
 3ec:	3c 37                	cmp    $0x37,%al
 3ee:	7e cb                	jle    3bb <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f3:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3f7:	c9                   	leave  
 3f8:	c3                   	ret    

000003f9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3f9:	55                   	push   %ebp
 3fa:	89 e5                	mov    %esp,%ebp
 3fc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
 402:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 405:	8b 45 0c             	mov    0xc(%ebp),%eax
 408:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 40b:	eb 17                	jmp    424 <memmove+0x2b>
    *dst++ = *src++;
 40d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 410:	8d 50 01             	lea    0x1(%eax),%edx
 413:	89 55 fc             	mov    %edx,-0x4(%ebp)
 416:	8b 55 f8             	mov    -0x8(%ebp),%edx
 419:	8d 4a 01             	lea    0x1(%edx),%ecx
 41c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 41f:	0f b6 12             	movzbl (%edx),%edx
 422:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 424:	8b 45 10             	mov    0x10(%ebp),%eax
 427:	8d 50 ff             	lea    -0x1(%eax),%edx
 42a:	89 55 10             	mov    %edx,0x10(%ebp)
 42d:	85 c0                	test   %eax,%eax
 42f:	7f dc                	jg     40d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 431:	8b 45 08             	mov    0x8(%ebp),%eax
}
 434:	c9                   	leave  
 435:	c3                   	ret    

00000436 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 436:	b8 01 00 00 00       	mov    $0x1,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <exit>:
SYSCALL(exit)
 43e:	b8 02 00 00 00       	mov    $0x2,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <wait>:
SYSCALL(wait)
 446:	b8 03 00 00 00       	mov    $0x3,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <pipe>:
SYSCALL(pipe)
 44e:	b8 04 00 00 00       	mov    $0x4,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <read>:
SYSCALL(read)
 456:	b8 05 00 00 00       	mov    $0x5,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <write>:
SYSCALL(write)
 45e:	b8 10 00 00 00       	mov    $0x10,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <close>:
SYSCALL(close)
 466:	b8 15 00 00 00       	mov    $0x15,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <kill>:
SYSCALL(kill)
 46e:	b8 06 00 00 00       	mov    $0x6,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <exec>:
SYSCALL(exec)
 476:	b8 07 00 00 00       	mov    $0x7,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <open>:
SYSCALL(open)
 47e:	b8 0f 00 00 00       	mov    $0xf,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <mknod>:
SYSCALL(mknod)
 486:	b8 11 00 00 00       	mov    $0x11,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <unlink>:
SYSCALL(unlink)
 48e:	b8 12 00 00 00       	mov    $0x12,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <fstat>:
SYSCALL(fstat)
 496:	b8 08 00 00 00       	mov    $0x8,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <link>:
SYSCALL(link)
 49e:	b8 13 00 00 00       	mov    $0x13,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <mkdir>:
SYSCALL(mkdir)
 4a6:	b8 14 00 00 00       	mov    $0x14,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <chdir>:
SYSCALL(chdir)
 4ae:	b8 09 00 00 00       	mov    $0x9,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <dup>:
SYSCALL(dup)
 4b6:	b8 0a 00 00 00       	mov    $0xa,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <getpid>:
SYSCALL(getpid)
 4be:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <sbrk>:
SYSCALL(sbrk)
 4c6:	b8 0c 00 00 00       	mov    $0xc,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <sleep>:
SYSCALL(sleep)
 4ce:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <uptime>:
SYSCALL(uptime)
 4d6:	b8 0e 00 00 00       	mov    $0xe,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <halt>:
SYSCALL(halt)
 4de:	b8 16 00 00 00       	mov    $0x16,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <date>:
SYSCALL(date)        #p1
 4e6:	b8 17 00 00 00       	mov    $0x17,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <getuid>:
SYSCALL(getuid)      #p2
 4ee:	b8 18 00 00 00       	mov    $0x18,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <getgid>:
SYSCALL(getgid)      #p2
 4f6:	b8 19 00 00 00       	mov    $0x19,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <getppid>:
SYSCALL(getppid)     #p2
 4fe:	b8 1a 00 00 00       	mov    $0x1a,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <setuid>:
SYSCALL(setuid)      #p2
 506:	b8 1b 00 00 00       	mov    $0x1b,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <setgid>:
SYSCALL(setgid)      #p2
 50e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <getprocs>:
SYSCALL(getprocs)    #p2
 516:	b8 1d 00 00 00       	mov    $0x1d,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <setpriority>:
SYSCALL(setpriority) #p4
 51e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret    

00000526 <chmod>:
SYSCALL(chmod)       #p5
 526:	b8 1f 00 00 00       	mov    $0x1f,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret    

0000052e <chown>:
SYSCALL(chown)       #p5
 52e:	b8 20 00 00 00       	mov    $0x20,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <chgrp>:
SYSCALL(chgrp)       #p5
 536:	b8 21 00 00 00       	mov    $0x21,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 53e:	55                   	push   %ebp
 53f:	89 e5                	mov    %esp,%ebp
 541:	83 ec 18             	sub    $0x18,%esp
 544:	8b 45 0c             	mov    0xc(%ebp),%eax
 547:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 54a:	83 ec 04             	sub    $0x4,%esp
 54d:	6a 01                	push   $0x1
 54f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 552:	50                   	push   %eax
 553:	ff 75 08             	pushl  0x8(%ebp)
 556:	e8 03 ff ff ff       	call   45e <write>
 55b:	83 c4 10             	add    $0x10,%esp
}
 55e:	90                   	nop
 55f:	c9                   	leave  
 560:	c3                   	ret    

00000561 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 561:	55                   	push   %ebp
 562:	89 e5                	mov    %esp,%ebp
 564:	53                   	push   %ebx
 565:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 568:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 56f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 573:	74 17                	je     58c <printint+0x2b>
 575:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 579:	79 11                	jns    58c <printint+0x2b>
    neg = 1;
 57b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 582:	8b 45 0c             	mov    0xc(%ebp),%eax
 585:	f7 d8                	neg    %eax
 587:	89 45 ec             	mov    %eax,-0x14(%ebp)
 58a:	eb 06                	jmp    592 <printint+0x31>
  } else {
    x = xx;
 58c:	8b 45 0c             	mov    0xc(%ebp),%eax
 58f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 592:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 599:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 59c:	8d 41 01             	lea    0x1(%ecx),%eax
 59f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a8:	ba 00 00 00 00       	mov    $0x0,%edx
 5ad:	f7 f3                	div    %ebx
 5af:	89 d0                	mov    %edx,%eax
 5b1:	0f b6 80 c0 0c 00 00 	movzbl 0xcc0(%eax),%eax
 5b8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c2:	ba 00 00 00 00       	mov    $0x0,%edx
 5c7:	f7 f3                	div    %ebx
 5c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d0:	75 c7                	jne    599 <printint+0x38>
  if(neg)
 5d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d6:	74 2d                	je     605 <printint+0xa4>
    buf[i++] = '-';
 5d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5db:	8d 50 01             	lea    0x1(%eax),%edx
 5de:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5e1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5e6:	eb 1d                	jmp    605 <printint+0xa4>
    putc(fd, buf[i]);
 5e8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ee:	01 d0                	add    %edx,%eax
 5f0:	0f b6 00             	movzbl (%eax),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	83 ec 08             	sub    $0x8,%esp
 5f9:	50                   	push   %eax
 5fa:	ff 75 08             	pushl  0x8(%ebp)
 5fd:	e8 3c ff ff ff       	call   53e <putc>
 602:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 605:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60d:	79 d9                	jns    5e8 <printint+0x87>
    putc(fd, buf[i]);
}
 60f:	90                   	nop
 610:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 613:	c9                   	leave  
 614:	c3                   	ret    

00000615 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 615:	55                   	push   %ebp
 616:	89 e5                	mov    %esp,%ebp
 618:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 61b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 622:	8d 45 0c             	lea    0xc(%ebp),%eax
 625:	83 c0 04             	add    $0x4,%eax
 628:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 62b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 632:	e9 59 01 00 00       	jmp    790 <printf+0x17b>
    c = fmt[i] & 0xff;
 637:	8b 55 0c             	mov    0xc(%ebp),%edx
 63a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63d:	01 d0                	add    %edx,%eax
 63f:	0f b6 00             	movzbl (%eax),%eax
 642:	0f be c0             	movsbl %al,%eax
 645:	25 ff 00 00 00       	and    $0xff,%eax
 64a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 64d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 651:	75 2c                	jne    67f <printf+0x6a>
      if(c == '%'){
 653:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 657:	75 0c                	jne    665 <printf+0x50>
        state = '%';
 659:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 660:	e9 27 01 00 00       	jmp    78c <printf+0x177>
      } else {
        putc(fd, c);
 665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 668:	0f be c0             	movsbl %al,%eax
 66b:	83 ec 08             	sub    $0x8,%esp
 66e:	50                   	push   %eax
 66f:	ff 75 08             	pushl  0x8(%ebp)
 672:	e8 c7 fe ff ff       	call   53e <putc>
 677:	83 c4 10             	add    $0x10,%esp
 67a:	e9 0d 01 00 00       	jmp    78c <printf+0x177>
      }
    } else if(state == '%'){
 67f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 683:	0f 85 03 01 00 00    	jne    78c <printf+0x177>
      if(c == 'd'){
 689:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 68d:	75 1e                	jne    6ad <printf+0x98>
        printint(fd, *ap, 10, 1);
 68f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	6a 01                	push   $0x1
 696:	6a 0a                	push   $0xa
 698:	50                   	push   %eax
 699:	ff 75 08             	pushl  0x8(%ebp)
 69c:	e8 c0 fe ff ff       	call   561 <printint>
 6a1:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a8:	e9 d8 00 00 00       	jmp    785 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6ad:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6b1:	74 06                	je     6b9 <printf+0xa4>
 6b3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b7:	75 1e                	jne    6d7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	6a 00                	push   $0x0
 6c0:	6a 10                	push   $0x10
 6c2:	50                   	push   %eax
 6c3:	ff 75 08             	pushl  0x8(%ebp)
 6c6:	e8 96 fe ff ff       	call   561 <printint>
 6cb:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d2:	e9 ae 00 00 00       	jmp    785 <printf+0x170>
      } else if(c == 's'){
 6d7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6db:	75 43                	jne    720 <printf+0x10b>
        s = (char*)*ap;
 6dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ed:	75 25                	jne    714 <printf+0xff>
          s = "(null)";
 6ef:	c7 45 f4 31 0a 00 00 	movl   $0xa31,-0xc(%ebp)
        while(*s != 0){
 6f6:	eb 1c                	jmp    714 <printf+0xff>
          putc(fd, *s);
 6f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fb:	0f b6 00             	movzbl (%eax),%eax
 6fe:	0f be c0             	movsbl %al,%eax
 701:	83 ec 08             	sub    $0x8,%esp
 704:	50                   	push   %eax
 705:	ff 75 08             	pushl  0x8(%ebp)
 708:	e8 31 fe ff ff       	call   53e <putc>
 70d:	83 c4 10             	add    $0x10,%esp
          s++;
 710:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 714:	8b 45 f4             	mov    -0xc(%ebp),%eax
 717:	0f b6 00             	movzbl (%eax),%eax
 71a:	84 c0                	test   %al,%al
 71c:	75 da                	jne    6f8 <printf+0xe3>
 71e:	eb 65                	jmp    785 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 720:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 724:	75 1d                	jne    743 <printf+0x12e>
        putc(fd, *ap);
 726:	8b 45 e8             	mov    -0x18(%ebp),%eax
 729:	8b 00                	mov    (%eax),%eax
 72b:	0f be c0             	movsbl %al,%eax
 72e:	83 ec 08             	sub    $0x8,%esp
 731:	50                   	push   %eax
 732:	ff 75 08             	pushl  0x8(%ebp)
 735:	e8 04 fe ff ff       	call   53e <putc>
 73a:	83 c4 10             	add    $0x10,%esp
        ap++;
 73d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 741:	eb 42                	jmp    785 <printf+0x170>
      } else if(c == '%'){
 743:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 747:	75 17                	jne    760 <printf+0x14b>
        putc(fd, c);
 749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74c:	0f be c0             	movsbl %al,%eax
 74f:	83 ec 08             	sub    $0x8,%esp
 752:	50                   	push   %eax
 753:	ff 75 08             	pushl  0x8(%ebp)
 756:	e8 e3 fd ff ff       	call   53e <putc>
 75b:	83 c4 10             	add    $0x10,%esp
 75e:	eb 25                	jmp    785 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 760:	83 ec 08             	sub    $0x8,%esp
 763:	6a 25                	push   $0x25
 765:	ff 75 08             	pushl  0x8(%ebp)
 768:	e8 d1 fd ff ff       	call   53e <putc>
 76d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 773:	0f be c0             	movsbl %al,%eax
 776:	83 ec 08             	sub    $0x8,%esp
 779:	50                   	push   %eax
 77a:	ff 75 08             	pushl  0x8(%ebp)
 77d:	e8 bc fd ff ff       	call   53e <putc>
 782:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 785:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 78c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 790:	8b 55 0c             	mov    0xc(%ebp),%edx
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	01 d0                	add    %edx,%eax
 798:	0f b6 00             	movzbl (%eax),%eax
 79b:	84 c0                	test   %al,%al
 79d:	0f 85 94 fe ff ff    	jne    637 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7a3:	90                   	nop
 7a4:	c9                   	leave  
 7a5:	c3                   	ret    

000007a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a6:	55                   	push   %ebp
 7a7:	89 e5                	mov    %esp,%ebp
 7a9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	83 e8 08             	sub    $0x8,%eax
 7b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b5:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 7ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7bd:	eb 24                	jmp    7e3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	8b 00                	mov    (%eax),%eax
 7c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c7:	77 12                	ja     7db <free+0x35>
 7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cf:	77 24                	ja     7f5 <free+0x4f>
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d9:	77 1a                	ja     7f5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	8b 00                	mov    (%eax),%eax
 7e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e9:	76 d4                	jbe    7bf <free+0x19>
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f3:	76 ca                	jbe    7bf <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	8b 40 04             	mov    0x4(%eax),%eax
 7fb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 802:	8b 45 f8             	mov    -0x8(%ebp),%eax
 805:	01 c2                	add    %eax,%edx
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 00                	mov    (%eax),%eax
 80c:	39 c2                	cmp    %eax,%edx
 80e:	75 24                	jne    834 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 810:	8b 45 f8             	mov    -0x8(%ebp),%eax
 813:	8b 50 04             	mov    0x4(%eax),%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	8b 00                	mov    (%eax),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	01 c2                	add    %eax,%edx
 820:	8b 45 f8             	mov    -0x8(%ebp),%eax
 823:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	8b 00                	mov    (%eax),%eax
 82b:	8b 10                	mov    (%eax),%edx
 82d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 830:	89 10                	mov    %edx,(%eax)
 832:	eb 0a                	jmp    83e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	8b 10                	mov    (%eax),%edx
 839:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	8b 40 04             	mov    0x4(%eax),%eax
 844:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 84b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84e:	01 d0                	add    %edx,%eax
 850:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 853:	75 20                	jne    875 <free+0xcf>
    p->s.size += bp->s.size;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 50 04             	mov    0x4(%eax),%edx
 85b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85e:	8b 40 04             	mov    0x4(%eax),%eax
 861:	01 c2                	add    %eax,%edx
 863:	8b 45 fc             	mov    -0x4(%ebp),%eax
 866:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 869:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86c:	8b 10                	mov    (%eax),%edx
 86e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 871:	89 10                	mov    %edx,(%eax)
 873:	eb 08                	jmp    87d <free+0xd7>
  } else
    p->s.ptr = bp;
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	8b 55 f8             	mov    -0x8(%ebp),%edx
 87b:	89 10                	mov    %edx,(%eax)
  freep = p;
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	a3 dc 0c 00 00       	mov    %eax,0xcdc
}
 885:	90                   	nop
 886:	c9                   	leave  
 887:	c3                   	ret    

00000888 <morecore>:

static Header*
morecore(uint nu)
{
 888:	55                   	push   %ebp
 889:	89 e5                	mov    %esp,%ebp
 88b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 88e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 895:	77 07                	ja     89e <morecore+0x16>
    nu = 4096;
 897:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 89e:	8b 45 08             	mov    0x8(%ebp),%eax
 8a1:	c1 e0 03             	shl    $0x3,%eax
 8a4:	83 ec 0c             	sub    $0xc,%esp
 8a7:	50                   	push   %eax
 8a8:	e8 19 fc ff ff       	call   4c6 <sbrk>
 8ad:	83 c4 10             	add    $0x10,%esp
 8b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b7:	75 07                	jne    8c0 <morecore+0x38>
    return 0;
 8b9:	b8 00 00 00 00       	mov    $0x0,%eax
 8be:	eb 26                	jmp    8e6 <morecore+0x5e>
  hp = (Header*)p;
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c9:	8b 55 08             	mov    0x8(%ebp),%edx
 8cc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d2:	83 c0 08             	add    $0x8,%eax
 8d5:	83 ec 0c             	sub    $0xc,%esp
 8d8:	50                   	push   %eax
 8d9:	e8 c8 fe ff ff       	call   7a6 <free>
 8de:	83 c4 10             	add    $0x10,%esp
  return freep;
 8e1:	a1 dc 0c 00 00       	mov    0xcdc,%eax
}
 8e6:	c9                   	leave  
 8e7:	c3                   	ret    

000008e8 <malloc>:

void*
malloc(uint nbytes)
{
 8e8:	55                   	push   %ebp
 8e9:	89 e5                	mov    %esp,%ebp
 8eb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ee:	8b 45 08             	mov    0x8(%ebp),%eax
 8f1:	83 c0 07             	add    $0x7,%eax
 8f4:	c1 e8 03             	shr    $0x3,%eax
 8f7:	83 c0 01             	add    $0x1,%eax
 8fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8fd:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 902:	89 45 f0             	mov    %eax,-0x10(%ebp)
 905:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 909:	75 23                	jne    92e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 90b:	c7 45 f0 d4 0c 00 00 	movl   $0xcd4,-0x10(%ebp)
 912:	8b 45 f0             	mov    -0x10(%ebp),%eax
 915:	a3 dc 0c 00 00       	mov    %eax,0xcdc
 91a:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 91f:	a3 d4 0c 00 00       	mov    %eax,0xcd4
    base.s.size = 0;
 924:	c7 05 d8 0c 00 00 00 	movl   $0x0,0xcd8
 92b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 931:	8b 00                	mov    (%eax),%eax
 933:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 936:	8b 45 f4             	mov    -0xc(%ebp),%eax
 939:	8b 40 04             	mov    0x4(%eax),%eax
 93c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93f:	72 4d                	jb     98e <malloc+0xa6>
      if(p->s.size == nunits)
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	8b 40 04             	mov    0x4(%eax),%eax
 947:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 94a:	75 0c                	jne    958 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	8b 10                	mov    (%eax),%edx
 951:	8b 45 f0             	mov    -0x10(%ebp),%eax
 954:	89 10                	mov    %edx,(%eax)
 956:	eb 26                	jmp    97e <malloc+0x96>
      else {
        p->s.size -= nunits;
 958:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95b:	8b 40 04             	mov    0x4(%eax),%eax
 95e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 961:	89 c2                	mov    %eax,%edx
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 969:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96c:	8b 40 04             	mov    0x4(%eax),%eax
 96f:	c1 e0 03             	shl    $0x3,%eax
 972:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 975:	8b 45 f4             	mov    -0xc(%ebp),%eax
 978:	8b 55 ec             	mov    -0x14(%ebp),%edx
 97b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 97e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 981:	a3 dc 0c 00 00       	mov    %eax,0xcdc
      return (void*)(p + 1);
 986:	8b 45 f4             	mov    -0xc(%ebp),%eax
 989:	83 c0 08             	add    $0x8,%eax
 98c:	eb 3b                	jmp    9c9 <malloc+0xe1>
    }
    if(p == freep)
 98e:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 993:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 996:	75 1e                	jne    9b6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 998:	83 ec 0c             	sub    $0xc,%esp
 99b:	ff 75 ec             	pushl  -0x14(%ebp)
 99e:	e8 e5 fe ff ff       	call   888 <morecore>
 9a3:	83 c4 10             	add    $0x10,%esp
 9a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ad:	75 07                	jne    9b6 <malloc+0xce>
        return 0;
 9af:	b8 00 00 00 00       	mov    $0x0,%eax
 9b4:	eb 13                	jmp    9c9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bf:	8b 00                	mov    (%eax),%eax
 9c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9c4:	e9 6d ff ff ff       	jmp    936 <malloc+0x4e>
}
 9c9:	c9                   	leave  
 9ca:	c3                   	ret    
