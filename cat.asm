
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 a0 0b 00 00       	push   $0xba0
  13:	6a 01                	push   $0x1
  15:	e8 6c 03 00 00       	call   386 <write>
  1a:	83 c4 10             	add    $0x10,%esp
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 a0 0b 00 00       	push   $0xba0
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 4c 03 00 00       	call   37e <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 d3 08 00 00       	push   $0x8d3
  4c:	6a 01                	push   $0x1
  4e:	e8 ca 04 00 00       	call   51d <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 0b 03 00 00       	call   366 <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	pushl  -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 dd 02 00 00       	call   366 <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 f8 02 00 00       	call   3a6 <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 e4 08 00 00       	push   $0x8e4
  d4:	6a 01                	push   $0x1
  d6:	e8 42 04 00 00       	call   51d <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 83 02 00 00       	call   366 <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	pushl  -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	pushl  -0x10(%ebp)
  f7:	e8 92 02 00 00       	call   38e <close>
  fc:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 10a:	e8 57 02 00 00       	call   366 <exit>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	90                   	nop
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	8d 50 01             	lea    0x1(%eax),%edx
 148:	89 55 08             	mov    %edx,0x8(%ebp)
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 4a 01             	lea    0x1(%edx),%ecx
 151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	29 c2                	sub    %eax,%edx
 1a0:	89 d0                	mov    %edx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 0c             	pushl  0xc(%ebp)
 1d5:	ff 75 08             	pushl  0x8(%ebp)
 1d8:	e8 32 ff ff ff       	call   10f <stosb>
 1dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strchr>:

char*
strchr(const char *s, char c)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f1:	eb 14                	jmp    207 <strchr+0x22>
    if(*s == c)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1fc:	75 05                	jne    203 <strchr+0x1e>
      return (char*)s;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	eb 13                	jmp    216 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 01                	push   $0x1
 22c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22f:	50                   	push   %eax
 230:	6a 00                	push   $0x0
 232:	e8 47 01 00 00       	call   37e <read>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 241:	7e 33                	jle    276 <gets+0x5e>
      break;
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 16                	je     277 <gets+0x5f>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0e                	je     277 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 272:	7c b3                	jl     227 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 276:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	pushl  0x8(%ebp)
 295:	e8 0c 01 00 00       	call   3a6 <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	pushl  0xc(%ebp)
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	e8 03 01 00 00       	call   3be <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	pushl  -0xc(%ebp)
 2c7:	e8 c2 00 00 00       	call   38e <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e1:	eb 25                	jmp    308 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	c1 e0 02             	shl    $0x2,%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	01 c0                	add    %eax,%eax
 2ef:	89 c1                	mov    %eax,%ecx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 08             	mov    %edx,0x8(%ebp)
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	0f be c0             	movsbl %al,%eax
 300:	01 c8                	add    %ecx,%eax
 302:	83 e8 30             	sub    $0x30,%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 2f                	cmp    $0x2f,%al
 310:	7e 0a                	jle    31c <atoi+0x48>
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	3c 39                	cmp    $0x39,%al
 31a:	7e c7                	jle    2e3 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 31c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 333:	eb 17                	jmp    34c <memmove+0x2b>
    *dst++ = *src++;
 335:	8b 45 fc             	mov    -0x4(%ebp),%eax
 338:	8d 50 01             	lea    0x1(%eax),%edx
 33b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 33e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 341:	8d 4a 01             	lea    0x1(%edx),%ecx
 344:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 347:	0f b6 12             	movzbl (%edx),%edx
 34a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34c:	8b 45 10             	mov    0x10(%ebp),%eax
 34f:	8d 50 ff             	lea    -0x1(%eax),%edx
 352:	89 55 10             	mov    %edx,0x10(%ebp)
 355:	85 c0                	test   %eax,%eax
 357:	7f dc                	jg     335 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35e:	b8 01 00 00 00       	mov    $0x1,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <exit>:
SYSCALL(exit)
 366:	b8 02 00 00 00       	mov    $0x2,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <wait>:
SYSCALL(wait)
 36e:	b8 03 00 00 00       	mov    $0x3,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <pipe>:
SYSCALL(pipe)
 376:	b8 04 00 00 00       	mov    $0x4,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <read>:
SYSCALL(read)
 37e:	b8 05 00 00 00       	mov    $0x5,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <write>:
SYSCALL(write)
 386:	b8 10 00 00 00       	mov    $0x10,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <close>:
SYSCALL(close)
 38e:	b8 15 00 00 00       	mov    $0x15,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <kill>:
SYSCALL(kill)
 396:	b8 06 00 00 00       	mov    $0x6,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <exec>:
SYSCALL(exec)
 39e:	b8 07 00 00 00       	mov    $0x7,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <open>:
SYSCALL(open)
 3a6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <mknod>:
SYSCALL(mknod)
 3ae:	b8 11 00 00 00       	mov    $0x11,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <unlink>:
SYSCALL(unlink)
 3b6:	b8 12 00 00 00       	mov    $0x12,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <fstat>:
SYSCALL(fstat)
 3be:	b8 08 00 00 00       	mov    $0x8,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <link>:
SYSCALL(link)
 3c6:	b8 13 00 00 00       	mov    $0x13,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <mkdir>:
SYSCALL(mkdir)
 3ce:	b8 14 00 00 00       	mov    $0x14,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <chdir>:
SYSCALL(chdir)
 3d6:	b8 09 00 00 00       	mov    $0x9,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <dup>:
SYSCALL(dup)
 3de:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <getpid>:
SYSCALL(getpid)
 3e6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <sbrk>:
SYSCALL(sbrk)
 3ee:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <sleep>:
SYSCALL(sleep)
 3f6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <uptime>:
SYSCALL(uptime)
 3fe:	b8 0e 00 00 00       	mov    $0xe,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <halt>:
SYSCALL(halt)
 406:	b8 16 00 00 00       	mov    $0x16,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <date>:
SYSCALL(date)      #p1
 40e:	b8 17 00 00 00       	mov    $0x17,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <getuid>:
SYSCALL(getuid)    #p2
 416:	b8 18 00 00 00       	mov    $0x18,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <getgid>:
SYSCALL(getgid)    #p2
 41e:	b8 19 00 00 00       	mov    $0x19,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <getppid>:
SYSCALL(getppid)   #p2
 426:	b8 1a 00 00 00       	mov    $0x1a,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <setuid>:
SYSCALL(setuid)    #p2
 42e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <setgid>:
SYSCALL(setgid)    #p2
 436:	b8 1c 00 00 00       	mov    $0x1c,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <getprocs>:
SYSCALL(getprocs)  #p2
 43e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 446:	55                   	push   %ebp
 447:	89 e5                	mov    %esp,%ebp
 449:	83 ec 18             	sub    $0x18,%esp
 44c:	8b 45 0c             	mov    0xc(%ebp),%eax
 44f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 452:	83 ec 04             	sub    $0x4,%esp
 455:	6a 01                	push   $0x1
 457:	8d 45 f4             	lea    -0xc(%ebp),%eax
 45a:	50                   	push   %eax
 45b:	ff 75 08             	pushl  0x8(%ebp)
 45e:	e8 23 ff ff ff       	call   386 <write>
 463:	83 c4 10             	add    $0x10,%esp
}
 466:	90                   	nop
 467:	c9                   	leave  
 468:	c3                   	ret    

00000469 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 469:	55                   	push   %ebp
 46a:	89 e5                	mov    %esp,%ebp
 46c:	53                   	push   %ebx
 46d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 470:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 477:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 47b:	74 17                	je     494 <printint+0x2b>
 47d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 481:	79 11                	jns    494 <printint+0x2b>
    neg = 1;
 483:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 48a:	8b 45 0c             	mov    0xc(%ebp),%eax
 48d:	f7 d8                	neg    %eax
 48f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 492:	eb 06                	jmp    49a <printint+0x31>
  } else {
    x = xx;
 494:	8b 45 0c             	mov    0xc(%ebp),%eax
 497:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 49a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a4:	8d 41 01             	lea    0x1(%ecx),%eax
 4a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b0:	ba 00 00 00 00       	mov    $0x0,%edx
 4b5:	f7 f3                	div    %ebx
 4b7:	89 d0                	mov    %edx,%eax
 4b9:	0f b6 80 6c 0b 00 00 	movzbl 0xb6c(%eax),%eax
 4c0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ca:	ba 00 00 00 00       	mov    $0x0,%edx
 4cf:	f7 f3                	div    %ebx
 4d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d8:	75 c7                	jne    4a1 <printint+0x38>
  if(neg)
 4da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4de:	74 2d                	je     50d <printint+0xa4>
    buf[i++] = '-';
 4e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e3:	8d 50 01             	lea    0x1(%eax),%edx
 4e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ee:	eb 1d                	jmp    50d <printint+0xa4>
    putc(fd, buf[i]);
 4f0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f6:	01 d0                	add    %edx,%eax
 4f8:	0f b6 00             	movzbl (%eax),%eax
 4fb:	0f be c0             	movsbl %al,%eax
 4fe:	83 ec 08             	sub    $0x8,%esp
 501:	50                   	push   %eax
 502:	ff 75 08             	pushl  0x8(%ebp)
 505:	e8 3c ff ff ff       	call   446 <putc>
 50a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 50d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 511:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 515:	79 d9                	jns    4f0 <printint+0x87>
    putc(fd, buf[i]);
}
 517:	90                   	nop
 518:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 51b:	c9                   	leave  
 51c:	c3                   	ret    

0000051d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51d:	55                   	push   %ebp
 51e:	89 e5                	mov    %esp,%ebp
 520:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 523:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52a:	8d 45 0c             	lea    0xc(%ebp),%eax
 52d:	83 c0 04             	add    $0x4,%eax
 530:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 533:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53a:	e9 59 01 00 00       	jmp    698 <printf+0x17b>
    c = fmt[i] & 0xff;
 53f:	8b 55 0c             	mov    0xc(%ebp),%edx
 542:	8b 45 f0             	mov    -0x10(%ebp),%eax
 545:	01 d0                	add    %edx,%eax
 547:	0f b6 00             	movzbl (%eax),%eax
 54a:	0f be c0             	movsbl %al,%eax
 54d:	25 ff 00 00 00       	and    $0xff,%eax
 552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 555:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 559:	75 2c                	jne    587 <printf+0x6a>
      if(c == '%'){
 55b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55f:	75 0c                	jne    56d <printf+0x50>
        state = '%';
 561:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 568:	e9 27 01 00 00       	jmp    694 <printf+0x177>
      } else {
        putc(fd, c);
 56d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 570:	0f be c0             	movsbl %al,%eax
 573:	83 ec 08             	sub    $0x8,%esp
 576:	50                   	push   %eax
 577:	ff 75 08             	pushl  0x8(%ebp)
 57a:	e8 c7 fe ff ff       	call   446 <putc>
 57f:	83 c4 10             	add    $0x10,%esp
 582:	e9 0d 01 00 00       	jmp    694 <printf+0x177>
      }
    } else if(state == '%'){
 587:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 58b:	0f 85 03 01 00 00    	jne    694 <printf+0x177>
      if(c == 'd'){
 591:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 595:	75 1e                	jne    5b5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 597:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59a:	8b 00                	mov    (%eax),%eax
 59c:	6a 01                	push   $0x1
 59e:	6a 0a                	push   $0xa
 5a0:	50                   	push   %eax
 5a1:	ff 75 08             	pushl  0x8(%ebp)
 5a4:	e8 c0 fe ff ff       	call   469 <printint>
 5a9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ac:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b0:	e9 d8 00 00 00       	jmp    68d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5b5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5b9:	74 06                	je     5c1 <printf+0xa4>
 5bb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5bf:	75 1e                	jne    5df <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c4:	8b 00                	mov    (%eax),%eax
 5c6:	6a 00                	push   $0x0
 5c8:	6a 10                	push   $0x10
 5ca:	50                   	push   %eax
 5cb:	ff 75 08             	pushl  0x8(%ebp)
 5ce:	e8 96 fe ff ff       	call   469 <printint>
 5d3:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5da:	e9 ae 00 00 00       	jmp    68d <printf+0x170>
      } else if(c == 's'){
 5df:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e3:	75 43                	jne    628 <printf+0x10b>
        s = (char*)*ap;
 5e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f5:	75 25                	jne    61c <printf+0xff>
          s = "(null)";
 5f7:	c7 45 f4 f9 08 00 00 	movl   $0x8f9,-0xc(%ebp)
        while(*s != 0){
 5fe:	eb 1c                	jmp    61c <printf+0xff>
          putc(fd, *s);
 600:	8b 45 f4             	mov    -0xc(%ebp),%eax
 603:	0f b6 00             	movzbl (%eax),%eax
 606:	0f be c0             	movsbl %al,%eax
 609:	83 ec 08             	sub    $0x8,%esp
 60c:	50                   	push   %eax
 60d:	ff 75 08             	pushl  0x8(%ebp)
 610:	e8 31 fe ff ff       	call   446 <putc>
 615:	83 c4 10             	add    $0x10,%esp
          s++;
 618:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61f:	0f b6 00             	movzbl (%eax),%eax
 622:	84 c0                	test   %al,%al
 624:	75 da                	jne    600 <printf+0xe3>
 626:	eb 65                	jmp    68d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 628:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 62c:	75 1d                	jne    64b <printf+0x12e>
        putc(fd, *ap);
 62e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	0f be c0             	movsbl %al,%eax
 636:	83 ec 08             	sub    $0x8,%esp
 639:	50                   	push   %eax
 63a:	ff 75 08             	pushl  0x8(%ebp)
 63d:	e8 04 fe ff ff       	call   446 <putc>
 642:	83 c4 10             	add    $0x10,%esp
        ap++;
 645:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 649:	eb 42                	jmp    68d <printf+0x170>
      } else if(c == '%'){
 64b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64f:	75 17                	jne    668 <printf+0x14b>
        putc(fd, c);
 651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 654:	0f be c0             	movsbl %al,%eax
 657:	83 ec 08             	sub    $0x8,%esp
 65a:	50                   	push   %eax
 65b:	ff 75 08             	pushl  0x8(%ebp)
 65e:	e8 e3 fd ff ff       	call   446 <putc>
 663:	83 c4 10             	add    $0x10,%esp
 666:	eb 25                	jmp    68d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 668:	83 ec 08             	sub    $0x8,%esp
 66b:	6a 25                	push   $0x25
 66d:	ff 75 08             	pushl  0x8(%ebp)
 670:	e8 d1 fd ff ff       	call   446 <putc>
 675:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67b:	0f be c0             	movsbl %al,%eax
 67e:	83 ec 08             	sub    $0x8,%esp
 681:	50                   	push   %eax
 682:	ff 75 08             	pushl  0x8(%ebp)
 685:	e8 bc fd ff ff       	call   446 <putc>
 68a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 68d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 694:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 698:	8b 55 0c             	mov    0xc(%ebp),%edx
 69b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69e:	01 d0                	add    %edx,%eax
 6a0:	0f b6 00             	movzbl (%eax),%eax
 6a3:	84 c0                	test   %al,%al
 6a5:	0f 85 94 fe ff ff    	jne    53f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6ab:	90                   	nop
 6ac:	c9                   	leave  
 6ad:	c3                   	ret    

000006ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ae:	55                   	push   %ebp
 6af:	89 e5                	mov    %esp,%ebp
 6b1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b4:	8b 45 08             	mov    0x8(%ebp),%eax
 6b7:	83 e8 08             	sub    $0x8,%eax
 6ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bd:	a1 88 0b 00 00       	mov    0xb88,%eax
 6c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c5:	eb 24                	jmp    6eb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cf:	77 12                	ja     6e3 <free+0x35>
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d7:	77 24                	ja     6fd <free+0x4f>
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 00                	mov    (%eax),%eax
 6de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e1:	77 1a                	ja     6fd <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f1:	76 d4                	jbe    6c7 <free+0x19>
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fb:	76 ca                	jbe    6c7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	8b 40 04             	mov    0x4(%eax),%eax
 703:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	01 c2                	add    %eax,%edx
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	39 c2                	cmp    %eax,%edx
 716:	75 24                	jne    73c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	8b 50 04             	mov    0x4(%eax),%edx
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	8b 40 04             	mov    0x4(%eax),%eax
 726:	01 c2                	add    %eax,%edx
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 00                	mov    (%eax),%eax
 733:	8b 10                	mov    (%eax),%edx
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	89 10                	mov    %edx,(%eax)
 73a:	eb 0a                	jmp    746 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 10                	mov    (%eax),%edx
 741:	8b 45 f8             	mov    -0x8(%ebp),%eax
 744:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	8b 40 04             	mov    0x4(%eax),%eax
 74c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	01 d0                	add    %edx,%eax
 758:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75b:	75 20                	jne    77d <free+0xcf>
    p->s.size += bp->s.size;
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 50 04             	mov    0x4(%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	01 c2                	add    %eax,%edx
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	8b 10                	mov    (%eax),%edx
 776:	8b 45 fc             	mov    -0x4(%ebp),%eax
 779:	89 10                	mov    %edx,(%eax)
 77b:	eb 08                	jmp    785 <free+0xd7>
  } else
    p->s.ptr = bp;
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	8b 55 f8             	mov    -0x8(%ebp),%edx
 783:	89 10                	mov    %edx,(%eax)
  freep = p;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 78d:	90                   	nop
 78e:	c9                   	leave  
 78f:	c3                   	ret    

00000790 <morecore>:

static Header*
morecore(uint nu)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 796:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79d:	77 07                	ja     7a6 <morecore+0x16>
    nu = 4096;
 79f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a6:	8b 45 08             	mov    0x8(%ebp),%eax
 7a9:	c1 e0 03             	shl    $0x3,%eax
 7ac:	83 ec 0c             	sub    $0xc,%esp
 7af:	50                   	push   %eax
 7b0:	e8 39 fc ff ff       	call   3ee <sbrk>
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7bb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7bf:	75 07                	jne    7c8 <morecore+0x38>
    return 0;
 7c1:	b8 00 00 00 00       	mov    $0x0,%eax
 7c6:	eb 26                	jmp    7ee <morecore+0x5e>
  hp = (Header*)p;
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d1:	8b 55 08             	mov    0x8(%ebp),%edx
 7d4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	83 c0 08             	add    $0x8,%eax
 7dd:	83 ec 0c             	sub    $0xc,%esp
 7e0:	50                   	push   %eax
 7e1:	e8 c8 fe ff ff       	call   6ae <free>
 7e6:	83 c4 10             	add    $0x10,%esp
  return freep;
 7e9:	a1 88 0b 00 00       	mov    0xb88,%eax
}
 7ee:	c9                   	leave  
 7ef:	c3                   	ret    

000007f0 <malloc>:

void*
malloc(uint nbytes)
{
 7f0:	55                   	push   %ebp
 7f1:	89 e5                	mov    %esp,%ebp
 7f3:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f6:	8b 45 08             	mov    0x8(%ebp),%eax
 7f9:	83 c0 07             	add    $0x7,%eax
 7fc:	c1 e8 03             	shr    $0x3,%eax
 7ff:	83 c0 01             	add    $0x1,%eax
 802:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 805:	a1 88 0b 00 00       	mov    0xb88,%eax
 80a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 811:	75 23                	jne    836 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 813:	c7 45 f0 80 0b 00 00 	movl   $0xb80,-0x10(%ebp)
 81a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81d:	a3 88 0b 00 00       	mov    %eax,0xb88
 822:	a1 88 0b 00 00       	mov    0xb88,%eax
 827:	a3 80 0b 00 00       	mov    %eax,0xb80
    base.s.size = 0;
 82c:	c7 05 84 0b 00 00 00 	movl   $0x0,0xb84
 833:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 836:	8b 45 f0             	mov    -0x10(%ebp),%eax
 839:	8b 00                	mov    (%eax),%eax
 83b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	8b 40 04             	mov    0x4(%eax),%eax
 844:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 847:	72 4d                	jb     896 <malloc+0xa6>
      if(p->s.size == nunits)
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	8b 40 04             	mov    0x4(%eax),%eax
 84f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 852:	75 0c                	jne    860 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 857:	8b 10                	mov    (%eax),%edx
 859:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85c:	89 10                	mov    %edx,(%eax)
 85e:	eb 26                	jmp    886 <malloc+0x96>
      else {
        p->s.size -= nunits;
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	8b 40 04             	mov    0x4(%eax),%eax
 866:	2b 45 ec             	sub    -0x14(%ebp),%eax
 869:	89 c2                	mov    %eax,%edx
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	8b 40 04             	mov    0x4(%eax),%eax
 877:	c1 e0 03             	shl    $0x3,%eax
 87a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8b 55 ec             	mov    -0x14(%ebp),%edx
 883:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 886:	8b 45 f0             	mov    -0x10(%ebp),%eax
 889:	a3 88 0b 00 00       	mov    %eax,0xb88
      return (void*)(p + 1);
 88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 891:	83 c0 08             	add    $0x8,%eax
 894:	eb 3b                	jmp    8d1 <malloc+0xe1>
    }
    if(p == freep)
 896:	a1 88 0b 00 00       	mov    0xb88,%eax
 89b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 89e:	75 1e                	jne    8be <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8a0:	83 ec 0c             	sub    $0xc,%esp
 8a3:	ff 75 ec             	pushl  -0x14(%ebp)
 8a6:	e8 e5 fe ff ff       	call   790 <morecore>
 8ab:	83 c4 10             	add    $0x10,%esp
 8ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b5:	75 07                	jne    8be <malloc+0xce>
        return 0;
 8b7:	b8 00 00 00 00       	mov    $0x0,%eax
 8bc:	eb 13                	jmp    8d1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	8b 00                	mov    (%eax),%eax
 8c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8cc:	e9 6d ff ff ff       	jmp    83e <malloc+0x4e>
}
 8d1:	c9                   	leave  
 8d2:	c3                   	ret    
