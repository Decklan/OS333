
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 c8 08 00 00       	push   $0x8c8
  1b:	e8 78 03 00 00       	call   398 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 c8 08 00 00       	push   $0x8c8
  33:	e8 68 03 00 00       	call   3a0 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 c8 08 00 00       	push   $0x8c8
  45:	e8 4e 03 00 00       	call   398 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 79 03 00 00       	call   3d0 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 6c 03 00 00       	call   3d0 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 d0 08 00 00       	push   $0x8d0
  6f:	6a 01                	push   $0x1
  71:	e8 99 04 00 00       	call   50f <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 d2 02 00 00       	call   350 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 e3 08 00 00       	push   $0x8e3
  8f:	6a 01                	push   $0x1
  91:	e8 79 04 00 00       	call   50f <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 ba 02 00 00       	call   358 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 64 0b 00 00       	push   $0xb64
  ac:	68 c5 08 00 00       	push   $0x8c5
  b1:	e8 da 02 00 00       	call   390 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 f6 08 00 00       	push   $0x8f6
  c1:	6a 01                	push   $0x1
  c3:	e8 47 04 00 00       	call   50f <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 88 02 00 00       	call   358 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 0c 09 00 00       	push   $0x90c
  d8:	6a 01                	push   $0x1
  da:	e8 30 04 00 00       	call   50f <printf>
  df:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	e8 79 02 00 00       	call   360 <wait>
  e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ee:	0f 88 73 ff ff ff    	js     67 <main+0x67>
  f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fa:	75 d4                	jne    d0 <main+0xd0>
      printf(1, "zombie!\n");
  }
  fc:	e9 66 ff ff ff       	jmp    67 <main+0x67>

00000101 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 10             	mov    0x10(%ebp),%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 cb                	mov    %ecx,%ebx
 111:	89 df                	mov    %ebx,%edi
 113:	89 d1                	mov    %edx,%ecx
 115:	fc                   	cld    
 116:	f3 aa                	rep stos %al,%es:(%edi)
 118:	89 ca                	mov    %ecx,%edx
 11a:	89 fb                	mov    %edi,%ebx
 11c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 122:	90                   	nop
 123:	5b                   	pop    %ebx
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 133:	90                   	nop
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8d 50 01             	lea    0x1(%eax),%edx
 13a:	89 55 08             	mov    %edx,0x8(%ebp)
 13d:	8b 55 0c             	mov    0xc(%ebp),%edx
 140:	8d 4a 01             	lea    0x1(%edx),%ecx
 143:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 146:	0f b6 12             	movzbl (%edx),%edx
 149:	88 10                	mov    %dl,(%eax)
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strcpy+0xd>
    ;
  return os;
 152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 155:	c9                   	leave  
 156:	c3                   	ret    

00000157 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15a:	eb 08                	jmp    164 <strcmp+0xd>
    p++, q++;
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	74 10                	je     17e <strcmp+0x27>
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 c2                	cmp    %al,%dl
 17c:	74 de                	je     15c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	0f b6 d0             	movzbl %al,%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	0f b6 c0             	movzbl %al,%eax
 190:	29 c2                	sub    %eax,%edx
 192:	89 d0                	mov    %edx,%eax
}
 194:	5d                   	pop    %ebp
 195:	c3                   	ret    

00000196 <strlen>:

uint
strlen(char *s)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a3:	eb 04                	jmp    1a9 <strlen+0x13>
 1a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 d0                	add    %edx,%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	75 ed                	jne    1a5 <strlen+0xf>
    ;
  return n;
 1b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
 1c3:	50                   	push   %eax
 1c4:	ff 75 0c             	pushl  0xc(%ebp)
 1c7:	ff 75 08             	pushl  0x8(%ebp)
 1ca:	e8 32 ff ff ff       	call   101 <stosb>
 1cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <strchr>:

char*
strchr(const char *s, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 14                	jmp    1f9 <strchr+0x22>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ee:	75 05                	jne    1f5 <strchr+0x1e>
      return (char*)s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	eb 13                	jmp    208 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 42                	jmp    25b <gets+0x51>
    cc = read(0, &c, 1);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	6a 01                	push   $0x1
 21e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 221:	50                   	push   %eax
 222:	6a 00                	push   $0x0
 224:	e8 47 01 00 00       	call   370 <read>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 233:	7e 33                	jle    268 <gets+0x5e>
      break;
    buf[i++] = c;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23e:	89 c2                	mov    %eax,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	01 c2                	add    %eax,%edx
 245:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 249:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 16                	je     269 <gets+0x5f>
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	3c 0d                	cmp    $0xd,%al
 259:	74 0e                	je     269 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	83 c0 01             	add    $0x1,%eax
 261:	3b 45 0c             	cmp    0xc(%ebp),%eax
 264:	7c b3                	jl     219 <gets+0xf>
 266:	eb 01                	jmp    269 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 268:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 269:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	01 d0                	add    %edx,%eax
 271:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <stat>:

int
stat(char *n, struct stat *st)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 0c 01 00 00       	call   398 <open>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 296:	79 07                	jns    29f <stat+0x26>
    return -1;
 298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29d:	eb 25                	jmp    2c4 <stat+0x4b>
  r = fstat(fd, st);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	ff 75 0c             	pushl  0xc(%ebp)
 2a5:	ff 75 f4             	pushl  -0xc(%ebp)
 2a8:	e8 03 01 00 00       	call   3b0 <fstat>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 75 f4             	pushl  -0xc(%ebp)
 2b9:	e8 c2 00 00 00       	call   380 <close>
 2be:	83 c4 10             	add    $0x10,%esp
  return r;
 2c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <atoi>:

int
atoi(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d3:	eb 25                	jmp    2fa <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d8:	89 d0                	mov    %edx,%eax
 2da:	c1 e0 02             	shl    $0x2,%eax
 2dd:	01 d0                	add    %edx,%eax
 2df:	01 c0                	add    %eax,%eax
 2e1:	89 c1                	mov    %eax,%ecx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8d 50 01             	lea    0x1(%eax),%edx
 2e9:	89 55 08             	mov    %edx,0x8(%ebp)
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	0f be c0             	movsbl %al,%eax
 2f2:	01 c8                	add    %ecx,%eax
 2f4:	83 e8 30             	sub    $0x30,%eax
 2f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 2f                	cmp    $0x2f,%al
 302:	7e 0a                	jle    30e <atoi+0x48>
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	3c 39                	cmp    $0x39,%al
 30c:	7e c7                	jle    2d5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 30e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 325:	eb 17                	jmp    33e <memmove+0x2b>
    *dst++ = *src++;
 327:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32a:	8d 50 01             	lea    0x1(%eax),%edx
 32d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 330:	8b 55 f8             	mov    -0x8(%ebp),%edx
 333:	8d 4a 01             	lea    0x1(%edx),%ecx
 336:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 339:	0f b6 12             	movzbl (%edx),%edx
 33c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33e:	8b 45 10             	mov    0x10(%ebp),%eax
 341:	8d 50 ff             	lea    -0x1(%eax),%edx
 344:	89 55 10             	mov    %edx,0x10(%ebp)
 347:	85 c0                	test   %eax,%eax
 349:	7f dc                	jg     327 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34e:	c9                   	leave  
 34f:	c3                   	ret    

00000350 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <exit>:
SYSCALL(exit)
 358:	b8 02 00 00 00       	mov    $0x2,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <wait>:
SYSCALL(wait)
 360:	b8 03 00 00 00       	mov    $0x3,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <pipe>:
SYSCALL(pipe)
 368:	b8 04 00 00 00       	mov    $0x4,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <read>:
SYSCALL(read)
 370:	b8 05 00 00 00       	mov    $0x5,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <write>:
SYSCALL(write)
 378:	b8 10 00 00 00       	mov    $0x10,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <close>:
SYSCALL(close)
 380:	b8 15 00 00 00       	mov    $0x15,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <kill>:
SYSCALL(kill)
 388:	b8 06 00 00 00       	mov    $0x6,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <exec>:
SYSCALL(exec)
 390:	b8 07 00 00 00       	mov    $0x7,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <open>:
SYSCALL(open)
 398:	b8 0f 00 00 00       	mov    $0xf,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <mknod>:
SYSCALL(mknod)
 3a0:	b8 11 00 00 00       	mov    $0x11,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <unlink>:
SYSCALL(unlink)
 3a8:	b8 12 00 00 00       	mov    $0x12,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <fstat>:
SYSCALL(fstat)
 3b0:	b8 08 00 00 00       	mov    $0x8,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <link>:
SYSCALL(link)
 3b8:	b8 13 00 00 00       	mov    $0x13,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mkdir>:
SYSCALL(mkdir)
 3c0:	b8 14 00 00 00       	mov    $0x14,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <chdir>:
SYSCALL(chdir)
 3c8:	b8 09 00 00 00       	mov    $0x9,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <dup>:
SYSCALL(dup)
 3d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <getpid>:
SYSCALL(getpid)
 3d8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <sbrk>:
SYSCALL(sbrk)
 3e0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <sleep>:
SYSCALL(sleep)
 3e8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <uptime>:
SYSCALL(uptime)
 3f0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <halt>:
SYSCALL(halt)
 3f8:	b8 16 00 00 00       	mov    $0x16,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <date>:
SYSCALL(date)      #p1
 400:	b8 17 00 00 00       	mov    $0x17,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getuid>:
SYSCALL(getuid)    #p2
 408:	b8 18 00 00 00       	mov    $0x18,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <getgid>:
SYSCALL(getgid)    #p2
 410:	b8 19 00 00 00       	mov    $0x19,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <getppid>:
SYSCALL(getppid)   #p2
 418:	b8 1a 00 00 00       	mov    $0x1a,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <setuid>:
SYSCALL(setuid)    #p2
 420:	b8 1b 00 00 00       	mov    $0x1b,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <setgid>:
SYSCALL(setgid)    #p2
 428:	b8 1c 00 00 00       	mov    $0x1c,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <getprocs>:
SYSCALL(getprocs)  #p2
 430:	b8 1d 00 00 00       	mov    $0x1d,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	83 ec 18             	sub    $0x18,%esp
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 444:	83 ec 04             	sub    $0x4,%esp
 447:	6a 01                	push   $0x1
 449:	8d 45 f4             	lea    -0xc(%ebp),%eax
 44c:	50                   	push   %eax
 44d:	ff 75 08             	pushl  0x8(%ebp)
 450:	e8 23 ff ff ff       	call   378 <write>
 455:	83 c4 10             	add    $0x10,%esp
}
 458:	90                   	nop
 459:	c9                   	leave  
 45a:	c3                   	ret    

0000045b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45b:	55                   	push   %ebp
 45c:	89 e5                	mov    %esp,%ebp
 45e:	53                   	push   %ebx
 45f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 462:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 469:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 46d:	74 17                	je     486 <printint+0x2b>
 46f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 473:	79 11                	jns    486 <printint+0x2b>
    neg = 1;
 475:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 47c:	8b 45 0c             	mov    0xc(%ebp),%eax
 47f:	f7 d8                	neg    %eax
 481:	89 45 ec             	mov    %eax,-0x14(%ebp)
 484:	eb 06                	jmp    48c <printint+0x31>
  } else {
    x = xx;
 486:	8b 45 0c             	mov    0xc(%ebp),%eax
 489:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 48c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 493:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 496:	8d 41 01             	lea    0x1(%ecx),%eax
 499:	89 45 f4             	mov    %eax,-0xc(%ebp)
 49c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a2:	ba 00 00 00 00       	mov    $0x0,%edx
 4a7:	f7 f3                	div    %ebx
 4a9:	89 d0                	mov    %edx,%eax
 4ab:	0f b6 80 6c 0b 00 00 	movzbl 0xb6c(%eax),%eax
 4b2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4bc:	ba 00 00 00 00       	mov    $0x0,%edx
 4c1:	f7 f3                	div    %ebx
 4c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ca:	75 c7                	jne    493 <printint+0x38>
  if(neg)
 4cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d0:	74 2d                	je     4ff <printint+0xa4>
    buf[i++] = '-';
 4d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d5:	8d 50 01             	lea    0x1(%eax),%edx
 4d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4db:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4e0:	eb 1d                	jmp    4ff <printint+0xa4>
    putc(fd, buf[i]);
 4e2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e8:	01 d0                	add    %edx,%eax
 4ea:	0f b6 00             	movzbl (%eax),%eax
 4ed:	0f be c0             	movsbl %al,%eax
 4f0:	83 ec 08             	sub    $0x8,%esp
 4f3:	50                   	push   %eax
 4f4:	ff 75 08             	pushl  0x8(%ebp)
 4f7:	e8 3c ff ff ff       	call   438 <putc>
 4fc:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ff:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 507:	79 d9                	jns    4e2 <printint+0x87>
    putc(fd, buf[i]);
}
 509:	90                   	nop
 50a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 50d:	c9                   	leave  
 50e:	c3                   	ret    

0000050f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 50f:	55                   	push   %ebp
 510:	89 e5                	mov    %esp,%ebp
 512:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 515:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 51c:	8d 45 0c             	lea    0xc(%ebp),%eax
 51f:	83 c0 04             	add    $0x4,%eax
 522:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 525:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 52c:	e9 59 01 00 00       	jmp    68a <printf+0x17b>
    c = fmt[i] & 0xff;
 531:	8b 55 0c             	mov    0xc(%ebp),%edx
 534:	8b 45 f0             	mov    -0x10(%ebp),%eax
 537:	01 d0                	add    %edx,%eax
 539:	0f b6 00             	movzbl (%eax),%eax
 53c:	0f be c0             	movsbl %al,%eax
 53f:	25 ff 00 00 00       	and    $0xff,%eax
 544:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 54b:	75 2c                	jne    579 <printf+0x6a>
      if(c == '%'){
 54d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 551:	75 0c                	jne    55f <printf+0x50>
        state = '%';
 553:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 55a:	e9 27 01 00 00       	jmp    686 <printf+0x177>
      } else {
        putc(fd, c);
 55f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	83 ec 08             	sub    $0x8,%esp
 568:	50                   	push   %eax
 569:	ff 75 08             	pushl  0x8(%ebp)
 56c:	e8 c7 fe ff ff       	call   438 <putc>
 571:	83 c4 10             	add    $0x10,%esp
 574:	e9 0d 01 00 00       	jmp    686 <printf+0x177>
      }
    } else if(state == '%'){
 579:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 57d:	0f 85 03 01 00 00    	jne    686 <printf+0x177>
      if(c == 'd'){
 583:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 587:	75 1e                	jne    5a7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 589:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58c:	8b 00                	mov    (%eax),%eax
 58e:	6a 01                	push   $0x1
 590:	6a 0a                	push   $0xa
 592:	50                   	push   %eax
 593:	ff 75 08             	pushl  0x8(%ebp)
 596:	e8 c0 fe ff ff       	call   45b <printint>
 59b:	83 c4 10             	add    $0x10,%esp
        ap++;
 59e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a2:	e9 d8 00 00 00       	jmp    67f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5a7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ab:	74 06                	je     5b3 <printf+0xa4>
 5ad:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5b1:	75 1e                	jne    5d1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b6:	8b 00                	mov    (%eax),%eax
 5b8:	6a 00                	push   $0x0
 5ba:	6a 10                	push   $0x10
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 96 fe ff ff       	call   45b <printint>
 5c5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5cc:	e9 ae 00 00 00       	jmp    67f <printf+0x170>
      } else if(c == 's'){
 5d1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5d5:	75 43                	jne    61a <printf+0x10b>
        s = (char*)*ap;
 5d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5da:	8b 00                	mov    (%eax),%eax
 5dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e7:	75 25                	jne    60e <printf+0xff>
          s = "(null)";
 5e9:	c7 45 f4 15 09 00 00 	movl   $0x915,-0xc(%ebp)
        while(*s != 0){
 5f0:	eb 1c                	jmp    60e <printf+0xff>
          putc(fd, *s);
 5f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f5:	0f b6 00             	movzbl (%eax),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	83 ec 08             	sub    $0x8,%esp
 5fe:	50                   	push   %eax
 5ff:	ff 75 08             	pushl  0x8(%ebp)
 602:	e8 31 fe ff ff       	call   438 <putc>
 607:	83 c4 10             	add    $0x10,%esp
          s++;
 60a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 60e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 611:	0f b6 00             	movzbl (%eax),%eax
 614:	84 c0                	test   %al,%al
 616:	75 da                	jne    5f2 <printf+0xe3>
 618:	eb 65                	jmp    67f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 61a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 61e:	75 1d                	jne    63d <printf+0x12e>
        putc(fd, *ap);
 620:	8b 45 e8             	mov    -0x18(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	0f be c0             	movsbl %al,%eax
 628:	83 ec 08             	sub    $0x8,%esp
 62b:	50                   	push   %eax
 62c:	ff 75 08             	pushl  0x8(%ebp)
 62f:	e8 04 fe ff ff       	call   438 <putc>
 634:	83 c4 10             	add    $0x10,%esp
        ap++;
 637:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63b:	eb 42                	jmp    67f <printf+0x170>
      } else if(c == '%'){
 63d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 641:	75 17                	jne    65a <printf+0x14b>
        putc(fd, c);
 643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 646:	0f be c0             	movsbl %al,%eax
 649:	83 ec 08             	sub    $0x8,%esp
 64c:	50                   	push   %eax
 64d:	ff 75 08             	pushl  0x8(%ebp)
 650:	e8 e3 fd ff ff       	call   438 <putc>
 655:	83 c4 10             	add    $0x10,%esp
 658:	eb 25                	jmp    67f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 65a:	83 ec 08             	sub    $0x8,%esp
 65d:	6a 25                	push   $0x25
 65f:	ff 75 08             	pushl  0x8(%ebp)
 662:	e8 d1 fd ff ff       	call   438 <putc>
 667:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 66a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66d:	0f be c0             	movsbl %al,%eax
 670:	83 ec 08             	sub    $0x8,%esp
 673:	50                   	push   %eax
 674:	ff 75 08             	pushl  0x8(%ebp)
 677:	e8 bc fd ff ff       	call   438 <putc>
 67c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 67f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 686:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 68a:	8b 55 0c             	mov    0xc(%ebp),%edx
 68d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 690:	01 d0                	add    %edx,%eax
 692:	0f b6 00             	movzbl (%eax),%eax
 695:	84 c0                	test   %al,%al
 697:	0f 85 94 fe ff ff    	jne    531 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 69d:	90                   	nop
 69e:	c9                   	leave  
 69f:	c3                   	ret    

000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a6:	8b 45 08             	mov    0x8(%ebp),%eax
 6a9:	83 e8 08             	sub    $0x8,%eax
 6ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6af:	a1 88 0b 00 00       	mov    0xb88,%eax
 6b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b7:	eb 24                	jmp    6dd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c1:	77 12                	ja     6d5 <free+0x35>
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c9:	77 24                	ja     6ef <free+0x4f>
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d3:	77 1a                	ja     6ef <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e3:	76 d4                	jbe    6b9 <free+0x19>
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ed:	76 ca                	jbe    6b9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	8b 40 04             	mov    0x4(%eax),%eax
 6f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ff:	01 c2                	add    %eax,%edx
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	39 c2                	cmp    %eax,%edx
 708:	75 24                	jne    72e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	8b 50 04             	mov    0x4(%eax),%edx
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	8b 40 04             	mov    0x4(%eax),%eax
 718:	01 c2                	add    %eax,%edx
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	8b 10                	mov    (%eax),%edx
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	89 10                	mov    %edx,(%eax)
 72c:	eb 0a                	jmp    738 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 10                	mov    (%eax),%edx
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	8b 40 04             	mov    0x4(%eax),%eax
 73e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	01 d0                	add    %edx,%eax
 74a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74d:	75 20                	jne    76f <free+0xcf>
    p->s.size += bp->s.size;
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 50 04             	mov    0x4(%eax),%edx
 755:	8b 45 f8             	mov    -0x8(%ebp),%eax
 758:	8b 40 04             	mov    0x4(%eax),%eax
 75b:	01 c2                	add    %eax,%edx
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	8b 10                	mov    (%eax),%edx
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	89 10                	mov    %edx,(%eax)
 76d:	eb 08                	jmp    777 <free+0xd7>
  } else
    p->s.ptr = bp;
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 55 f8             	mov    -0x8(%ebp),%edx
 775:	89 10                	mov    %edx,(%eax)
  freep = p;
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 77f:	90                   	nop
 780:	c9                   	leave  
 781:	c3                   	ret    

00000782 <morecore>:

static Header*
morecore(uint nu)
{
 782:	55                   	push   %ebp
 783:	89 e5                	mov    %esp,%ebp
 785:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 788:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 78f:	77 07                	ja     798 <morecore+0x16>
    nu = 4096;
 791:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 798:	8b 45 08             	mov    0x8(%ebp),%eax
 79b:	c1 e0 03             	shl    $0x3,%eax
 79e:	83 ec 0c             	sub    $0xc,%esp
 7a1:	50                   	push   %eax
 7a2:	e8 39 fc ff ff       	call   3e0 <sbrk>
 7a7:	83 c4 10             	add    $0x10,%esp
 7aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ad:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7b1:	75 07                	jne    7ba <morecore+0x38>
    return 0;
 7b3:	b8 00 00 00 00       	mov    $0x0,%eax
 7b8:	eb 26                	jmp    7e0 <morecore+0x5e>
  hp = (Header*)p;
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c3:	8b 55 08             	mov    0x8(%ebp),%edx
 7c6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	83 c0 08             	add    $0x8,%eax
 7cf:	83 ec 0c             	sub    $0xc,%esp
 7d2:	50                   	push   %eax
 7d3:	e8 c8 fe ff ff       	call   6a0 <free>
 7d8:	83 c4 10             	add    $0x10,%esp
  return freep;
 7db:	a1 88 0b 00 00       	mov    0xb88,%eax
}
 7e0:	c9                   	leave  
 7e1:	c3                   	ret    

000007e2 <malloc>:

void*
malloc(uint nbytes)
{
 7e2:	55                   	push   %ebp
 7e3:	89 e5                	mov    %esp,%ebp
 7e5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e8:	8b 45 08             	mov    0x8(%ebp),%eax
 7eb:	83 c0 07             	add    $0x7,%eax
 7ee:	c1 e8 03             	shr    $0x3,%eax
 7f1:	83 c0 01             	add    $0x1,%eax
 7f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f7:	a1 88 0b 00 00       	mov    0xb88,%eax
 7fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 803:	75 23                	jne    828 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 805:	c7 45 f0 80 0b 00 00 	movl   $0xb80,-0x10(%ebp)
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	a3 88 0b 00 00       	mov    %eax,0xb88
 814:	a1 88 0b 00 00       	mov    0xb88,%eax
 819:	a3 80 0b 00 00       	mov    %eax,0xb80
    base.s.size = 0;
 81e:	c7 05 84 0b 00 00 00 	movl   $0x0,0xb84
 825:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82b:	8b 00                	mov    (%eax),%eax
 82d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8b 40 04             	mov    0x4(%eax),%eax
 836:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 839:	72 4d                	jb     888 <malloc+0xa6>
      if(p->s.size == nunits)
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	8b 40 04             	mov    0x4(%eax),%eax
 841:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 844:	75 0c                	jne    852 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 10                	mov    (%eax),%edx
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	89 10                	mov    %edx,(%eax)
 850:	eb 26                	jmp    878 <malloc+0x96>
      else {
        p->s.size -= nunits;
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 40 04             	mov    0x4(%eax),%eax
 858:	2b 45 ec             	sub    -0x14(%ebp),%eax
 85b:	89 c2                	mov    %eax,%edx
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	8b 40 04             	mov    0x4(%eax),%eax
 869:	c1 e0 03             	shl    $0x3,%eax
 86c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	8b 55 ec             	mov    -0x14(%ebp),%edx
 875:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	a3 88 0b 00 00       	mov    %eax,0xb88
      return (void*)(p + 1);
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	83 c0 08             	add    $0x8,%eax
 886:	eb 3b                	jmp    8c3 <malloc+0xe1>
    }
    if(p == freep)
 888:	a1 88 0b 00 00       	mov    0xb88,%eax
 88d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 890:	75 1e                	jne    8b0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 892:	83 ec 0c             	sub    $0xc,%esp
 895:	ff 75 ec             	pushl  -0x14(%ebp)
 898:	e8 e5 fe ff ff       	call   782 <morecore>
 89d:	83 c4 10             	add    $0x10,%esp
 8a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a7:	75 07                	jne    8b0 <malloc+0xce>
        return 0;
 8a9:	b8 00 00 00 00       	mov    $0x0,%eax
 8ae:	eb 13                	jmp    8c3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	8b 00                	mov    (%eax),%eax
 8bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8be:	e9 6d ff ff ff       	jmp    830 <malloc+0x4e>
}
 8c3:	c9                   	leave  
 8c4:	c3                   	ret    
