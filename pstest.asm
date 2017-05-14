
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
   9:	68 28 09 00 00       	push   $0x928
   e:	6a 01                	push   $0x1
  10:	e8 5a 05 00 00       	call   56f <printf>
  15:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1f:	eb 2d                	jmp    4e <forktest+0x4e>
    pid = fork();
  21:	e8 82 03 00 00       	call   3a8 <fork>
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
  3d:	e8 fe 03 00 00       	call   440 <sleep>
  42:	83 c4 10             	add    $0x10,%esp
      exit();
  45:	e8 66 03 00 00       	call   3b0 <exit>
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
  5b:	e8 58 03 00 00       	call   3b8 <wait>
  60:	85 c0                	test   %eax,%eax
  62:	79 17                	jns    7b <forktest+0x7b>
      printf(1, "wait stopped early\n");
  64:	83 ec 08             	sub    $0x8,%esp
  67:	68 33 09 00 00       	push   $0x933
  6c:	6a 01                	push   $0x1
  6e:	e8 fc 04 00 00       	call   56f <printf>
  73:	83 c4 10             	add    $0x10,%esp
      exit();
  76:	e8 35 03 00 00       	call   3b0 <exit>
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
  85:	e8 2e 03 00 00       	call   3b8 <wait>
  8a:	83 f8 ff             	cmp    $0xffffffff,%eax
  8d:	74 17                	je     a6 <forktest+0xa6>
    printf(1, "wait got too many\n");
  8f:	83 ec 08             	sub    $0x8,%esp
  92:	68 47 09 00 00       	push   $0x947
  97:	6a 01                	push   $0x1
  99:	e8 d1 04 00 00       	call   56f <printf>
  9e:	83 c4 10             	add    $0x10,%esp
    exit();
  a1:	e8 0a 03 00 00       	call   3b0 <exit>
  }
  
  printf(1, "fork test OK\n");
  a6:	83 ec 08             	sub    $0x8,%esp
  a9:	68 5a 09 00 00       	push   $0x95a
  ae:	6a 01                	push   $0x1
  b0:	e8 ba 04 00 00       	call   56f <printf>
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
  d6:	68 68 09 00 00       	push   $0x968
  db:	6a 02                	push   $0x2
  dd:	e8 8d 04 00 00       	call   56f <printf>
  e2:	83 c4 10             	add    $0x10,%esp
    exit();
  e5:	e8 c6 02 00 00       	call   3b0 <exit>
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

00000490 <setpriority>:
SYSCALL(setpriority)
 490:	b8 1e 00 00 00       	mov    $0x1e,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 498:	55                   	push   %ebp
 499:	89 e5                	mov    %esp,%ebp
 49b:	83 ec 18             	sub    $0x18,%esp
 49e:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4a4:	83 ec 04             	sub    $0x4,%esp
 4a7:	6a 01                	push   $0x1
 4a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4ac:	50                   	push   %eax
 4ad:	ff 75 08             	pushl  0x8(%ebp)
 4b0:	e8 1b ff ff ff       	call   3d0 <write>
 4b5:	83 c4 10             	add    $0x10,%esp
}
 4b8:	90                   	nop
 4b9:	c9                   	leave  
 4ba:	c3                   	ret    

000004bb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4bb:	55                   	push   %ebp
 4bc:	89 e5                	mov    %esp,%ebp
 4be:	53                   	push   %ebx
 4bf:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4c9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4cd:	74 17                	je     4e6 <printint+0x2b>
 4cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4d3:	79 11                	jns    4e6 <printint+0x2b>
    neg = 1;
 4d5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4df:	f7 d8                	neg    %eax
 4e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e4:	eb 06                	jmp    4ec <printint+0x31>
  } else {
    x = xx;
 4e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4f3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4f6:	8d 41 01             	lea    0x1(%ecx),%eax
 4f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 502:	ba 00 00 00 00       	mov    $0x0,%edx
 507:	f7 f3                	div    %ebx
 509:	89 d0                	mov    %edx,%eax
 50b:	0f b6 80 fc 0b 00 00 	movzbl 0xbfc(%eax),%eax
 512:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 516:	8b 5d 10             	mov    0x10(%ebp),%ebx
 519:	8b 45 ec             	mov    -0x14(%ebp),%eax
 51c:	ba 00 00 00 00       	mov    $0x0,%edx
 521:	f7 f3                	div    %ebx
 523:	89 45 ec             	mov    %eax,-0x14(%ebp)
 526:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 52a:	75 c7                	jne    4f3 <printint+0x38>
  if(neg)
 52c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 530:	74 2d                	je     55f <printint+0xa4>
    buf[i++] = '-';
 532:	8b 45 f4             	mov    -0xc(%ebp),%eax
 535:	8d 50 01             	lea    0x1(%eax),%edx
 538:	89 55 f4             	mov    %edx,-0xc(%ebp)
 53b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 540:	eb 1d                	jmp    55f <printint+0xa4>
    putc(fd, buf[i]);
 542:	8d 55 dc             	lea    -0x24(%ebp),%edx
 545:	8b 45 f4             	mov    -0xc(%ebp),%eax
 548:	01 d0                	add    %edx,%eax
 54a:	0f b6 00             	movzbl (%eax),%eax
 54d:	0f be c0             	movsbl %al,%eax
 550:	83 ec 08             	sub    $0x8,%esp
 553:	50                   	push   %eax
 554:	ff 75 08             	pushl  0x8(%ebp)
 557:	e8 3c ff ff ff       	call   498 <putc>
 55c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 55f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 567:	79 d9                	jns    542 <printint+0x87>
    putc(fd, buf[i]);
}
 569:	90                   	nop
 56a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 56d:	c9                   	leave  
 56e:	c3                   	ret    

0000056f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 56f:	55                   	push   %ebp
 570:	89 e5                	mov    %esp,%ebp
 572:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 575:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 57c:	8d 45 0c             	lea    0xc(%ebp),%eax
 57f:	83 c0 04             	add    $0x4,%eax
 582:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 585:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 58c:	e9 59 01 00 00       	jmp    6ea <printf+0x17b>
    c = fmt[i] & 0xff;
 591:	8b 55 0c             	mov    0xc(%ebp),%edx
 594:	8b 45 f0             	mov    -0x10(%ebp),%eax
 597:	01 d0                	add    %edx,%eax
 599:	0f b6 00             	movzbl (%eax),%eax
 59c:	0f be c0             	movsbl %al,%eax
 59f:	25 ff 00 00 00       	and    $0xff,%eax
 5a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ab:	75 2c                	jne    5d9 <printf+0x6a>
      if(c == '%'){
 5ad:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b1:	75 0c                	jne    5bf <printf+0x50>
        state = '%';
 5b3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ba:	e9 27 01 00 00       	jmp    6e6 <printf+0x177>
      } else {
        putc(fd, c);
 5bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c2:	0f be c0             	movsbl %al,%eax
 5c5:	83 ec 08             	sub    $0x8,%esp
 5c8:	50                   	push   %eax
 5c9:	ff 75 08             	pushl  0x8(%ebp)
 5cc:	e8 c7 fe ff ff       	call   498 <putc>
 5d1:	83 c4 10             	add    $0x10,%esp
 5d4:	e9 0d 01 00 00       	jmp    6e6 <printf+0x177>
      }
    } else if(state == '%'){
 5d9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5dd:	0f 85 03 01 00 00    	jne    6e6 <printf+0x177>
      if(c == 'd'){
 5e3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5e7:	75 1e                	jne    607 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	6a 01                	push   $0x1
 5f0:	6a 0a                	push   $0xa
 5f2:	50                   	push   %eax
 5f3:	ff 75 08             	pushl  0x8(%ebp)
 5f6:	e8 c0 fe ff ff       	call   4bb <printint>
 5fb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 602:	e9 d8 00 00 00       	jmp    6df <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 607:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 60b:	74 06                	je     613 <printf+0xa4>
 60d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 611:	75 1e                	jne    631 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 613:	8b 45 e8             	mov    -0x18(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	6a 00                	push   $0x0
 61a:	6a 10                	push   $0x10
 61c:	50                   	push   %eax
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 96 fe ff ff       	call   4bb <printint>
 625:	83 c4 10             	add    $0x10,%esp
        ap++;
 628:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62c:	e9 ae 00 00 00       	jmp    6df <printf+0x170>
      } else if(c == 's'){
 631:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 635:	75 43                	jne    67a <printf+0x10b>
        s = (char*)*ap;
 637:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 63f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 643:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 647:	75 25                	jne    66e <printf+0xff>
          s = "(null)";
 649:	c7 45 f4 8d 09 00 00 	movl   $0x98d,-0xc(%ebp)
        while(*s != 0){
 650:	eb 1c                	jmp    66e <printf+0xff>
          putc(fd, *s);
 652:	8b 45 f4             	mov    -0xc(%ebp),%eax
 655:	0f b6 00             	movzbl (%eax),%eax
 658:	0f be c0             	movsbl %al,%eax
 65b:	83 ec 08             	sub    $0x8,%esp
 65e:	50                   	push   %eax
 65f:	ff 75 08             	pushl  0x8(%ebp)
 662:	e8 31 fe ff ff       	call   498 <putc>
 667:	83 c4 10             	add    $0x10,%esp
          s++;
 66a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 66e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 671:	0f b6 00             	movzbl (%eax),%eax
 674:	84 c0                	test   %al,%al
 676:	75 da                	jne    652 <printf+0xe3>
 678:	eb 65                	jmp    6df <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 67a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 67e:	75 1d                	jne    69d <printf+0x12e>
        putc(fd, *ap);
 680:	8b 45 e8             	mov    -0x18(%ebp),%eax
 683:	8b 00                	mov    (%eax),%eax
 685:	0f be c0             	movsbl %al,%eax
 688:	83 ec 08             	sub    $0x8,%esp
 68b:	50                   	push   %eax
 68c:	ff 75 08             	pushl  0x8(%ebp)
 68f:	e8 04 fe ff ff       	call   498 <putc>
 694:	83 c4 10             	add    $0x10,%esp
        ap++;
 697:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69b:	eb 42                	jmp    6df <printf+0x170>
      } else if(c == '%'){
 69d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a1:	75 17                	jne    6ba <printf+0x14b>
        putc(fd, c);
 6a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a6:	0f be c0             	movsbl %al,%eax
 6a9:	83 ec 08             	sub    $0x8,%esp
 6ac:	50                   	push   %eax
 6ad:	ff 75 08             	pushl  0x8(%ebp)
 6b0:	e8 e3 fd ff ff       	call   498 <putc>
 6b5:	83 c4 10             	add    $0x10,%esp
 6b8:	eb 25                	jmp    6df <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ba:	83 ec 08             	sub    $0x8,%esp
 6bd:	6a 25                	push   $0x25
 6bf:	ff 75 08             	pushl  0x8(%ebp)
 6c2:	e8 d1 fd ff ff       	call   498 <putc>
 6c7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6cd:	0f be c0             	movsbl %al,%eax
 6d0:	83 ec 08             	sub    $0x8,%esp
 6d3:	50                   	push   %eax
 6d4:	ff 75 08             	pushl  0x8(%ebp)
 6d7:	e8 bc fd ff ff       	call   498 <putc>
 6dc:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ea:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f0:	01 d0                	add    %edx,%eax
 6f2:	0f b6 00             	movzbl (%eax),%eax
 6f5:	84 c0                	test   %al,%al
 6f7:	0f 85 94 fe ff ff    	jne    591 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6fd:	90                   	nop
 6fe:	c9                   	leave  
 6ff:	c3                   	ret    

00000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	83 e8 08             	sub    $0x8,%eax
 70c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70f:	a1 18 0c 00 00       	mov    0xc18,%eax
 714:	89 45 fc             	mov    %eax,-0x4(%ebp)
 717:	eb 24                	jmp    73d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 721:	77 12                	ja     735 <free+0x35>
 723:	8b 45 f8             	mov    -0x8(%ebp),%eax
 726:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 729:	77 24                	ja     74f <free+0x4f>
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 733:	77 1a                	ja     74f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 740:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 743:	76 d4                	jbe    719 <free+0x19>
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74d:	76 ca                	jbe    719 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	8b 40 04             	mov    0x4(%eax),%eax
 755:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 75c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75f:	01 c2                	add    %eax,%edx
 761:	8b 45 fc             	mov    -0x4(%ebp),%eax
 764:	8b 00                	mov    (%eax),%eax
 766:	39 c2                	cmp    %eax,%edx
 768:	75 24                	jne    78e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 76a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76d:	8b 50 04             	mov    0x4(%eax),%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	8b 40 04             	mov    0x4(%eax),%eax
 778:	01 c2                	add    %eax,%edx
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	8b 00                	mov    (%eax),%eax
 785:	8b 10                	mov    (%eax),%edx
 787:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78a:	89 10                	mov    %edx,(%eax)
 78c:	eb 0a                	jmp    798 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	8b 10                	mov    (%eax),%edx
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	01 d0                	add    %edx,%eax
 7aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ad:	75 20                	jne    7cf <free+0xcf>
    p->s.size += bp->s.size;
 7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b2:	8b 50 04             	mov    0x4(%eax),%edx
 7b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b8:	8b 40 04             	mov    0x4(%eax),%eax
 7bb:	01 c2                	add    %eax,%edx
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c6:	8b 10                	mov    (%eax),%edx
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	89 10                	mov    %edx,(%eax)
 7cd:	eb 08                	jmp    7d7 <free+0xd7>
  } else
    p->s.ptr = bp;
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7d5:	89 10                	mov    %edx,(%eax)
  freep = p;
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	a3 18 0c 00 00       	mov    %eax,0xc18
}
 7df:	90                   	nop
 7e0:	c9                   	leave  
 7e1:	c3                   	ret    

000007e2 <morecore>:

static Header*
morecore(uint nu)
{
 7e2:	55                   	push   %ebp
 7e3:	89 e5                	mov    %esp,%ebp
 7e5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7e8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ef:	77 07                	ja     7f8 <morecore+0x16>
    nu = 4096;
 7f1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7f8:	8b 45 08             	mov    0x8(%ebp),%eax
 7fb:	c1 e0 03             	shl    $0x3,%eax
 7fe:	83 ec 0c             	sub    $0xc,%esp
 801:	50                   	push   %eax
 802:	e8 31 fc ff ff       	call   438 <sbrk>
 807:	83 c4 10             	add    $0x10,%esp
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 80d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 811:	75 07                	jne    81a <morecore+0x38>
    return 0;
 813:	b8 00 00 00 00       	mov    $0x0,%eax
 818:	eb 26                	jmp    840 <morecore+0x5e>
  hp = (Header*)p;
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 820:	8b 45 f0             	mov    -0x10(%ebp),%eax
 823:	8b 55 08             	mov    0x8(%ebp),%edx
 826:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	83 c0 08             	add    $0x8,%eax
 82f:	83 ec 0c             	sub    $0xc,%esp
 832:	50                   	push   %eax
 833:	e8 c8 fe ff ff       	call   700 <free>
 838:	83 c4 10             	add    $0x10,%esp
  return freep;
 83b:	a1 18 0c 00 00       	mov    0xc18,%eax
}
 840:	c9                   	leave  
 841:	c3                   	ret    

00000842 <malloc>:

void*
malloc(uint nbytes)
{
 842:	55                   	push   %ebp
 843:	89 e5                	mov    %esp,%ebp
 845:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 848:	8b 45 08             	mov    0x8(%ebp),%eax
 84b:	83 c0 07             	add    $0x7,%eax
 84e:	c1 e8 03             	shr    $0x3,%eax
 851:	83 c0 01             	add    $0x1,%eax
 854:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 857:	a1 18 0c 00 00       	mov    0xc18,%eax
 85c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 863:	75 23                	jne    888 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 865:	c7 45 f0 10 0c 00 00 	movl   $0xc10,-0x10(%ebp)
 86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86f:	a3 18 0c 00 00       	mov    %eax,0xc18
 874:	a1 18 0c 00 00       	mov    0xc18,%eax
 879:	a3 10 0c 00 00       	mov    %eax,0xc10
    base.s.size = 0;
 87e:	c7 05 14 0c 00 00 00 	movl   $0x0,0xc14
 885:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 888:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88b:	8b 00                	mov    (%eax),%eax
 88d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	8b 40 04             	mov    0x4(%eax),%eax
 896:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 899:	72 4d                	jb     8e8 <malloc+0xa6>
      if(p->s.size == nunits)
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 40 04             	mov    0x4(%eax),%eax
 8a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a4:	75 0c                	jne    8b2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	8b 10                	mov    (%eax),%edx
 8ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ae:	89 10                	mov    %edx,(%eax)
 8b0:	eb 26                	jmp    8d8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b5:	8b 40 04             	mov    0x4(%eax),%eax
 8b8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8bb:	89 c2                	mov    %eax,%edx
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 40 04             	mov    0x4(%eax),%eax
 8c9:	c1 e0 03             	shl    $0x3,%eax
 8cc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8d5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8db:	a3 18 0c 00 00       	mov    %eax,0xc18
      return (void*)(p + 1);
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	83 c0 08             	add    $0x8,%eax
 8e6:	eb 3b                	jmp    923 <malloc+0xe1>
    }
    if(p == freep)
 8e8:	a1 18 0c 00 00       	mov    0xc18,%eax
 8ed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f0:	75 1e                	jne    910 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8f2:	83 ec 0c             	sub    $0xc,%esp
 8f5:	ff 75 ec             	pushl  -0x14(%ebp)
 8f8:	e8 e5 fe ff ff       	call   7e2 <morecore>
 8fd:	83 c4 10             	add    $0x10,%esp
 900:	89 45 f4             	mov    %eax,-0xc(%ebp)
 903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 907:	75 07                	jne    910 <malloc+0xce>
        return 0;
 909:	b8 00 00 00 00       	mov    $0x0,%eax
 90e:	eb 13                	jmp    923 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 910:	8b 45 f4             	mov    -0xc(%ebp),%eax
 913:	89 45 f0             	mov    %eax,-0x10(%ebp)
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	8b 00                	mov    (%eax),%eax
 91b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 91e:	e9 6d ff ff ff       	jmp    890 <malloc+0x4e>
}
 923:	c9                   	leave  
 924:	c3                   	ret    