
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <dayofweek>:
  "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
static char *days[] = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};

int
dayofweek(int y, int m, int d)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
   4:	83 7d 0c 02          	cmpl   $0x2,0xc(%ebp)
   8:	7f 0b                	jg     15 <dayofweek+0x15>
   a:	8b 45 08             	mov    0x8(%ebp),%eax
   d:	8d 50 ff             	lea    -0x1(%eax),%edx
  10:	89 55 08             	mov    %edx,0x8(%ebp)
  13:	eb 06                	jmp    1b <dayofweek+0x1b>
  15:	8b 45 08             	mov    0x8(%ebp),%eax
  18:	83 e8 02             	sub    $0x2,%eax
  1b:	01 45 10             	add    %eax,0x10(%ebp)
  1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  21:	6b c8 17             	imul   $0x17,%eax,%ecx
  24:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
  29:	89 c8                	mov    %ecx,%eax
  2b:	f7 ea                	imul   %edx
  2d:	d1 fa                	sar    %edx
  2f:	89 c8                	mov    %ecx,%eax
  31:	c1 f8 1f             	sar    $0x1f,%eax
  34:	29 c2                	sub    %eax,%edx
  36:	8b 45 10             	mov    0x10(%ebp),%eax
  39:	01 d0                	add    %edx,%eax
  3b:	8d 48 04             	lea    0x4(%eax),%ecx
  3e:	8b 45 08             	mov    0x8(%ebp),%eax
  41:	8d 50 03             	lea    0x3(%eax),%edx
  44:	85 c0                	test   %eax,%eax
  46:	0f 48 c2             	cmovs  %edx,%eax
  49:	c1 f8 02             	sar    $0x2,%eax
  4c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
  4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  52:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  57:	89 c8                	mov    %ecx,%eax
  59:	f7 ea                	imul   %edx
  5b:	c1 fa 05             	sar    $0x5,%edx
  5e:	89 c8                	mov    %ecx,%eax
  60:	c1 f8 1f             	sar    $0x1f,%eax
  63:	29 c2                	sub    %eax,%edx
  65:	89 d0                	mov    %edx,%eax
  67:	29 c3                	sub    %eax,%ebx
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  71:	89 c8                	mov    %ecx,%eax
  73:	f7 ea                	imul   %edx
  75:	c1 fa 07             	sar    $0x7,%edx
  78:	89 c8                	mov    %ecx,%eax
  7a:	c1 f8 1f             	sar    $0x1f,%eax
  7d:	29 c2                	sub    %eax,%edx
  7f:	89 d0                	mov    %edx,%eax
  81:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
  84:	ba 93 24 49 92       	mov    $0x92492493,%edx
  89:	89 c8                	mov    %ecx,%eax
  8b:	f7 ea                	imul   %edx
  8d:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  90:	c1 f8 02             	sar    $0x2,%eax
  93:	89 c2                	mov    %eax,%edx
  95:	89 c8                	mov    %ecx,%eax
  97:	c1 f8 1f             	sar    $0x1f,%eax
  9a:	29 c2                	sub    %eax,%edx
  9c:	89 d0                	mov    %edx,%eax
  9e:	89 c2                	mov    %eax,%edx
  a0:	c1 e2 03             	shl    $0x3,%edx
  a3:	29 c2                	sub    %eax,%edx
  a5:	89 c8                	mov    %ecx,%eax
  a7:	29 d0                	sub    %edx,%eax
}
  a9:	5b                   	pop    %ebx
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <main>:

int
main(int argc, char *argv[])
{
  ac:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  b0:	83 e4 f0             	and    $0xfffffff0,%esp
  b3:	ff 71 fc             	pushl  -0x4(%ecx)
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	53                   	push   %ebx
  ba:	51                   	push   %ecx
  bb:	83 ec 20             	sub    $0x20,%esp
  int day;
  struct rtcdate r;

  if (date(&r)) {
  be:	83 ec 0c             	sub    $0xc,%esp
  c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  c4:	50                   	push   %eax
  c5:	e8 92 03 00 00       	call   45c <date>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	85 c0                	test   %eax,%eax
  cf:	74 1b                	je     ec <main+0x40>
    printf(2,"Error: date call failed. %s at line %d\n", __FILE__, __LINE__);
  d1:	6a 19                	push   $0x19
  d3:	68 6d 09 00 00       	push   $0x96d
  d8:	68 74 09 00 00       	push   $0x974
  dd:	6a 02                	push   $0x2
  df:	e8 7f 04 00 00       	call   563 <printf>
  e4:	83 c4 10             	add    $0x10,%esp
    exit();
  e7:	e8 c8 02 00 00       	call   3b4 <exit>
  }

  day = dayofweek(r.year, r.month, r.day);
  ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  ef:	89 c1                	mov    %eax,%ecx
  f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  f4:	89 c2                	mov    %eax,%edx
  f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f9:	83 ec 04             	sub    $0x4,%esp
  fc:	51                   	push   %ecx
  fd:	52                   	push   %edx
  fe:	50                   	push   %eax
  ff:	e8 fc fe ff ff       	call   0 <dayofweek>
 104:	83 c4 10             	add    $0x10,%esp
 107:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "%s %s %d", days[day], months[r.month], r.day);
 10a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 10d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 110:	8b 14 85 40 0c 00 00 	mov    0xc40(,%eax,4),%edx
 117:	8b 45 f4             	mov    -0xc(%ebp),%eax
 11a:	8b 04 85 74 0c 00 00 	mov    0xc74(,%eax,4),%eax
 121:	83 ec 0c             	sub    $0xc,%esp
 124:	51                   	push   %ecx
 125:	52                   	push   %edx
 126:	50                   	push   %eax
 127:	68 9c 09 00 00       	push   $0x99c
 12c:	6a 01                	push   $0x1
 12e:	e8 30 04 00 00       	call   563 <printf>
 133:	83 c4 20             	add    $0x20,%esp
  printf(1, " %d:%d:%d UTC %d\n", r.hour, r.minute, r.second, r.year);
 136:	8b 5d f0             	mov    -0x10(%ebp),%ebx
 139:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 13c:	8b 55 e0             	mov    -0x20(%ebp),%edx
 13f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 142:	83 ec 08             	sub    $0x8,%esp
 145:	53                   	push   %ebx
 146:	51                   	push   %ecx
 147:	52                   	push   %edx
 148:	50                   	push   %eax
 149:	68 a5 09 00 00       	push   $0x9a5
 14e:	6a 01                	push   $0x1
 150:	e8 0e 04 00 00       	call   563 <printf>
 155:	83 c4 20             	add    $0x20,%esp

  exit();
 158:	e8 57 02 00 00       	call   3b4 <exit>

0000015d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	57                   	push   %edi
 161:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 162:	8b 4d 08             	mov    0x8(%ebp),%ecx
 165:	8b 55 10             	mov    0x10(%ebp),%edx
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	89 cb                	mov    %ecx,%ebx
 16d:	89 df                	mov    %ebx,%edi
 16f:	89 d1                	mov    %edx,%ecx
 171:	fc                   	cld    
 172:	f3 aa                	rep stos %al,%es:(%edi)
 174:	89 ca                	mov    %ecx,%edx
 176:	89 fb                	mov    %edi,%ebx
 178:	89 5d 08             	mov    %ebx,0x8(%ebp)
 17b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 17e:	90                   	nop
 17f:	5b                   	pop    %ebx
 180:	5f                   	pop    %edi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    

00000183 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 183:	55                   	push   %ebp
 184:	89 e5                	mov    %esp,%ebp
 186:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 18f:	90                   	nop
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	8d 50 01             	lea    0x1(%eax),%edx
 196:	89 55 08             	mov    %edx,0x8(%ebp)
 199:	8b 55 0c             	mov    0xc(%ebp),%edx
 19c:	8d 4a 01             	lea    0x1(%edx),%ecx
 19f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1a2:	0f b6 12             	movzbl (%edx),%edx
 1a5:	88 10                	mov    %dl,(%eax)
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	84 c0                	test   %al,%al
 1ac:	75 e2                	jne    190 <strcpy+0xd>
    ;
  return os;
 1ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b1:	c9                   	leave  
 1b2:	c3                   	ret    

000001b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1b6:	eb 08                	jmp    1c0 <strcmp+0xd>
    p++, q++;
 1b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1bc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	0f b6 00             	movzbl (%eax),%eax
 1c6:	84 c0                	test   %al,%al
 1c8:	74 10                	je     1da <strcmp+0x27>
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	0f b6 10             	movzbl (%eax),%edx
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	38 c2                	cmp    %al,%dl
 1d8:	74 de                	je     1b8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	0f b6 00             	movzbl (%eax),%eax
 1e0:	0f b6 d0             	movzbl %al,%edx
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	0f b6 00             	movzbl (%eax),%eax
 1e9:	0f b6 c0             	movzbl %al,%eax
 1ec:	29 c2                	sub    %eax,%edx
 1ee:	89 d0                	mov    %edx,%eax
}
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    

000001f2 <strlen>:

uint
strlen(char *s)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ff:	eb 04                	jmp    205 <strlen+0x13>
 201:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 205:	8b 55 fc             	mov    -0x4(%ebp),%edx
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	01 d0                	add    %edx,%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	84 c0                	test   %al,%al
 212:	75 ed                	jne    201 <strlen+0xf>
    ;
  return n;
 214:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <memset>:

void*
memset(void *dst, int c, uint n)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 21c:	8b 45 10             	mov    0x10(%ebp),%eax
 21f:	50                   	push   %eax
 220:	ff 75 0c             	pushl  0xc(%ebp)
 223:	ff 75 08             	pushl  0x8(%ebp)
 226:	e8 32 ff ff ff       	call   15d <stosb>
 22b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <strchr>:

char*
strchr(const char *s, char c)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	83 ec 04             	sub    $0x4,%esp
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 23f:	eb 14                	jmp    255 <strchr+0x22>
    if(*s == c)
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	3a 45 fc             	cmp    -0x4(%ebp),%al
 24a:	75 05                	jne    251 <strchr+0x1e>
      return (char*)s;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	eb 13                	jmp    264 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 251:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	84 c0                	test   %al,%al
 25d:	75 e2                	jne    241 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 25f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <gets>:

char*
gets(char *buf, int max)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 273:	eb 42                	jmp    2b7 <gets+0x51>
    cc = read(0, &c, 1);
 275:	83 ec 04             	sub    $0x4,%esp
 278:	6a 01                	push   $0x1
 27a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 27d:	50                   	push   %eax
 27e:	6a 00                	push   $0x0
 280:	e8 47 01 00 00       	call   3cc <read>
 285:	83 c4 10             	add    $0x10,%esp
 288:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 28b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 28f:	7e 33                	jle    2c4 <gets+0x5e>
      break;
    buf[i++] = c;
 291:	8b 45 f4             	mov    -0xc(%ebp),%eax
 294:	8d 50 01             	lea    0x1(%eax),%edx
 297:	89 55 f4             	mov    %edx,-0xc(%ebp)
 29a:	89 c2                	mov    %eax,%edx
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	01 c2                	add    %eax,%edx
 2a1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ab:	3c 0a                	cmp    $0xa,%al
 2ad:	74 16                	je     2c5 <gets+0x5f>
 2af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b3:	3c 0d                	cmp    $0xd,%al
 2b5:	74 0e                	je     2c5 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ba:	83 c0 01             	add    $0x1,%eax
 2bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c0:	7c b3                	jl     275 <gets+0xf>
 2c2:	eb 01                	jmp    2c5 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2c4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	01 d0                	add    %edx,%eax
 2cd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <stat>:

int
stat(char *n, struct stat *st)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2db:	83 ec 08             	sub    $0x8,%esp
 2de:	6a 00                	push   $0x0
 2e0:	ff 75 08             	pushl  0x8(%ebp)
 2e3:	e8 0c 01 00 00       	call   3f4 <open>
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f2:	79 07                	jns    2fb <stat+0x26>
    return -1;
 2f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f9:	eb 25                	jmp    320 <stat+0x4b>
  r = fstat(fd, st);
 2fb:	83 ec 08             	sub    $0x8,%esp
 2fe:	ff 75 0c             	pushl  0xc(%ebp)
 301:	ff 75 f4             	pushl  -0xc(%ebp)
 304:	e8 03 01 00 00       	call   40c <fstat>
 309:	83 c4 10             	add    $0x10,%esp
 30c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30f:	83 ec 0c             	sub    $0xc,%esp
 312:	ff 75 f4             	pushl  -0xc(%ebp)
 315:	e8 c2 00 00 00       	call   3dc <close>
 31a:	83 c4 10             	add    $0x10,%esp
  return r;
 31d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <atoi>:

int
atoi(const char *s)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 328:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32f:	eb 25                	jmp    356 <atoi+0x34>
    n = n*10 + *s++ - '0';
 331:	8b 55 fc             	mov    -0x4(%ebp),%edx
 334:	89 d0                	mov    %edx,%eax
 336:	c1 e0 02             	shl    $0x2,%eax
 339:	01 d0                	add    %edx,%eax
 33b:	01 c0                	add    %eax,%eax
 33d:	89 c1                	mov    %eax,%ecx
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	8d 50 01             	lea    0x1(%eax),%edx
 345:	89 55 08             	mov    %edx,0x8(%ebp)
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	0f be c0             	movsbl %al,%eax
 34e:	01 c8                	add    %ecx,%eax
 350:	83 e8 30             	sub    $0x30,%eax
 353:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	0f b6 00             	movzbl (%eax),%eax
 35c:	3c 2f                	cmp    $0x2f,%al
 35e:	7e 0a                	jle    36a <atoi+0x48>
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	0f b6 00             	movzbl (%eax),%eax
 366:	3c 39                	cmp    $0x39,%al
 368:	7e c7                	jle    331 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 36a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 37b:	8b 45 0c             	mov    0xc(%ebp),%eax
 37e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 381:	eb 17                	jmp    39a <memmove+0x2b>
    *dst++ = *src++;
 383:	8b 45 fc             	mov    -0x4(%ebp),%eax
 386:	8d 50 01             	lea    0x1(%eax),%edx
 389:	89 55 fc             	mov    %edx,-0x4(%ebp)
 38c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38f:	8d 4a 01             	lea    0x1(%edx),%ecx
 392:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 395:	0f b6 12             	movzbl (%edx),%edx
 398:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 39a:	8b 45 10             	mov    0x10(%ebp),%eax
 39d:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a0:	89 55 10             	mov    %edx,0x10(%ebp)
 3a3:	85 c0                	test   %eax,%eax
 3a5:	7f dc                	jg     383 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ac:	b8 01 00 00 00       	mov    $0x1,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exit>:
SYSCALL(exit)
 3b4:	b8 02 00 00 00       	mov    $0x2,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <wait>:
SYSCALL(wait)
 3bc:	b8 03 00 00 00       	mov    $0x3,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <pipe>:
SYSCALL(pipe)
 3c4:	b8 04 00 00 00       	mov    $0x4,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <read>:
SYSCALL(read)
 3cc:	b8 05 00 00 00       	mov    $0x5,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <write>:
SYSCALL(write)
 3d4:	b8 10 00 00 00       	mov    $0x10,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <close>:
SYSCALL(close)
 3dc:	b8 15 00 00 00       	mov    $0x15,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <kill>:
SYSCALL(kill)
 3e4:	b8 06 00 00 00       	mov    $0x6,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <exec>:
SYSCALL(exec)
 3ec:	b8 07 00 00 00       	mov    $0x7,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <open>:
SYSCALL(open)
 3f4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <mknod>:
SYSCALL(mknod)
 3fc:	b8 11 00 00 00       	mov    $0x11,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <unlink>:
SYSCALL(unlink)
 404:	b8 12 00 00 00       	mov    $0x12,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <fstat>:
SYSCALL(fstat)
 40c:	b8 08 00 00 00       	mov    $0x8,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <link>:
SYSCALL(link)
 414:	b8 13 00 00 00       	mov    $0x13,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <mkdir>:
SYSCALL(mkdir)
 41c:	b8 14 00 00 00       	mov    $0x14,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <chdir>:
SYSCALL(chdir)
 424:	b8 09 00 00 00       	mov    $0x9,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <dup>:
SYSCALL(dup)
 42c:	b8 0a 00 00 00       	mov    $0xa,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <getpid>:
SYSCALL(getpid)
 434:	b8 0b 00 00 00       	mov    $0xb,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <sbrk>:
SYSCALL(sbrk)
 43c:	b8 0c 00 00 00       	mov    $0xc,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <sleep>:
SYSCALL(sleep)
 444:	b8 0d 00 00 00       	mov    $0xd,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <uptime>:
SYSCALL(uptime)
 44c:	b8 0e 00 00 00       	mov    $0xe,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <halt>:
SYSCALL(halt)
 454:	b8 16 00 00 00       	mov    $0x16,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <date>:
SYSCALL(date)    #p1
 45c:	b8 17 00 00 00       	mov    $0x17,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <getuid>:
SYSCALL(getuid)  #p2
 464:	b8 18 00 00 00       	mov    $0x18,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <getgid>:
SYSCALL(getgid)  #p2
 46c:	b8 19 00 00 00       	mov    $0x19,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <getppid>:
SYSCALL(getppid) #p2
 474:	b8 1a 00 00 00       	mov    $0x1a,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <setuid>:
SYSCALL(setuid)  #p2
 47c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <setgid>:
SYSCALL(setgid)  #p2
 484:	b8 1c 00 00 00       	mov    $0x1c,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	83 ec 18             	sub    $0x18,%esp
 492:	8b 45 0c             	mov    0xc(%ebp),%eax
 495:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 498:	83 ec 04             	sub    $0x4,%esp
 49b:	6a 01                	push   $0x1
 49d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a0:	50                   	push   %eax
 4a1:	ff 75 08             	pushl  0x8(%ebp)
 4a4:	e8 2b ff ff ff       	call   3d4 <write>
 4a9:	83 c4 10             	add    $0x10,%esp
}
 4ac:	90                   	nop
 4ad:	c9                   	leave  
 4ae:	c3                   	ret    

000004af <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4af:	55                   	push   %ebp
 4b0:	89 e5                	mov    %esp,%ebp
 4b2:	53                   	push   %ebx
 4b3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4bd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4c1:	74 17                	je     4da <printint+0x2b>
 4c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4c7:	79 11                	jns    4da <printint+0x2b>
    neg = 1;
 4c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d3:	f7 d8                	neg    %eax
 4d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d8:	eb 06                	jmp    4e0 <printint+0x31>
  } else {
    x = xx;
 4da:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4ea:	8d 41 01             	lea    0x1(%ecx),%eax
 4ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f6:	ba 00 00 00 00       	mov    $0x0,%edx
 4fb:	f7 f3                	div    %ebx
 4fd:	89 d0                	mov    %edx,%eax
 4ff:	0f b6 80 90 0c 00 00 	movzbl 0xc90(%eax),%eax
 506:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 50a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 50d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 510:	ba 00 00 00 00       	mov    $0x0,%edx
 515:	f7 f3                	div    %ebx
 517:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51e:	75 c7                	jne    4e7 <printint+0x38>
  if(neg)
 520:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 524:	74 2d                	je     553 <printint+0xa4>
    buf[i++] = '-';
 526:	8b 45 f4             	mov    -0xc(%ebp),%eax
 529:	8d 50 01             	lea    0x1(%eax),%edx
 52c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 52f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 534:	eb 1d                	jmp    553 <printint+0xa4>
    putc(fd, buf[i]);
 536:	8d 55 dc             	lea    -0x24(%ebp),%edx
 539:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53c:	01 d0                	add    %edx,%eax
 53e:	0f b6 00             	movzbl (%eax),%eax
 541:	0f be c0             	movsbl %al,%eax
 544:	83 ec 08             	sub    $0x8,%esp
 547:	50                   	push   %eax
 548:	ff 75 08             	pushl  0x8(%ebp)
 54b:	e8 3c ff ff ff       	call   48c <putc>
 550:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 553:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55b:	79 d9                	jns    536 <printint+0x87>
    putc(fd, buf[i]);
}
 55d:	90                   	nop
 55e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 561:	c9                   	leave  
 562:	c3                   	ret    

00000563 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 563:	55                   	push   %ebp
 564:	89 e5                	mov    %esp,%ebp
 566:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 569:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 570:	8d 45 0c             	lea    0xc(%ebp),%eax
 573:	83 c0 04             	add    $0x4,%eax
 576:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 579:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 580:	e9 59 01 00 00       	jmp    6de <printf+0x17b>
    c = fmt[i] & 0xff;
 585:	8b 55 0c             	mov    0xc(%ebp),%edx
 588:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58b:	01 d0                	add    %edx,%eax
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	0f be c0             	movsbl %al,%eax
 593:	25 ff 00 00 00       	and    $0xff,%eax
 598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 59b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 59f:	75 2c                	jne    5cd <printf+0x6a>
      if(c == '%'){
 5a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a5:	75 0c                	jne    5b3 <printf+0x50>
        state = '%';
 5a7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ae:	e9 27 01 00 00       	jmp    6da <printf+0x177>
      } else {
        putc(fd, c);
 5b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b6:	0f be c0             	movsbl %al,%eax
 5b9:	83 ec 08             	sub    $0x8,%esp
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 c7 fe ff ff       	call   48c <putc>
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	e9 0d 01 00 00       	jmp    6da <printf+0x177>
      }
    } else if(state == '%'){
 5cd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d1:	0f 85 03 01 00 00    	jne    6da <printf+0x177>
      if(c == 'd'){
 5d7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5db:	75 1e                	jne    5fb <printf+0x98>
        printint(fd, *ap, 10, 1);
 5dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	6a 01                	push   $0x1
 5e4:	6a 0a                	push   $0xa
 5e6:	50                   	push   %eax
 5e7:	ff 75 08             	pushl  0x8(%ebp)
 5ea:	e8 c0 fe ff ff       	call   4af <printint>
 5ef:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f6:	e9 d8 00 00 00       	jmp    6d3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5fb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ff:	74 06                	je     607 <printf+0xa4>
 601:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 605:	75 1e                	jne    625 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 607:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	6a 00                	push   $0x0
 60e:	6a 10                	push   $0x10
 610:	50                   	push   %eax
 611:	ff 75 08             	pushl  0x8(%ebp)
 614:	e8 96 fe ff ff       	call   4af <printint>
 619:	83 c4 10             	add    $0x10,%esp
        ap++;
 61c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 620:	e9 ae 00 00 00       	jmp    6d3 <printf+0x170>
      } else if(c == 's'){
 625:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 629:	75 43                	jne    66e <printf+0x10b>
        s = (char*)*ap;
 62b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 633:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 63b:	75 25                	jne    662 <printf+0xff>
          s = "(null)";
 63d:	c7 45 f4 b7 09 00 00 	movl   $0x9b7,-0xc(%ebp)
        while(*s != 0){
 644:	eb 1c                	jmp    662 <printf+0xff>
          putc(fd, *s);
 646:	8b 45 f4             	mov    -0xc(%ebp),%eax
 649:	0f b6 00             	movzbl (%eax),%eax
 64c:	0f be c0             	movsbl %al,%eax
 64f:	83 ec 08             	sub    $0x8,%esp
 652:	50                   	push   %eax
 653:	ff 75 08             	pushl  0x8(%ebp)
 656:	e8 31 fe ff ff       	call   48c <putc>
 65b:	83 c4 10             	add    $0x10,%esp
          s++;
 65e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 662:	8b 45 f4             	mov    -0xc(%ebp),%eax
 665:	0f b6 00             	movzbl (%eax),%eax
 668:	84 c0                	test   %al,%al
 66a:	75 da                	jne    646 <printf+0xe3>
 66c:	eb 65                	jmp    6d3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 672:	75 1d                	jne    691 <printf+0x12e>
        putc(fd, *ap);
 674:	8b 45 e8             	mov    -0x18(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	0f be c0             	movsbl %al,%eax
 67c:	83 ec 08             	sub    $0x8,%esp
 67f:	50                   	push   %eax
 680:	ff 75 08             	pushl  0x8(%ebp)
 683:	e8 04 fe ff ff       	call   48c <putc>
 688:	83 c4 10             	add    $0x10,%esp
        ap++;
 68b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68f:	eb 42                	jmp    6d3 <printf+0x170>
      } else if(c == '%'){
 691:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 695:	75 17                	jne    6ae <printf+0x14b>
        putc(fd, c);
 697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69a:	0f be c0             	movsbl %al,%eax
 69d:	83 ec 08             	sub    $0x8,%esp
 6a0:	50                   	push   %eax
 6a1:	ff 75 08             	pushl  0x8(%ebp)
 6a4:	e8 e3 fd ff ff       	call   48c <putc>
 6a9:	83 c4 10             	add    $0x10,%esp
 6ac:	eb 25                	jmp    6d3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ae:	83 ec 08             	sub    $0x8,%esp
 6b1:	6a 25                	push   $0x25
 6b3:	ff 75 08             	pushl  0x8(%ebp)
 6b6:	e8 d1 fd ff ff       	call   48c <putc>
 6bb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c1:	0f be c0             	movsbl %al,%eax
 6c4:	83 ec 08             	sub    $0x8,%esp
 6c7:	50                   	push   %eax
 6c8:	ff 75 08             	pushl  0x8(%ebp)
 6cb:	e8 bc fd ff ff       	call   48c <putc>
 6d0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6de:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e4:	01 d0                	add    %edx,%eax
 6e6:	0f b6 00             	movzbl (%eax),%eax
 6e9:	84 c0                	test   %al,%al
 6eb:	0f 85 94 fe ff ff    	jne    585 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f1:	90                   	nop
 6f2:	c9                   	leave  
 6f3:	c3                   	ret    

000006f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f4:	55                   	push   %ebp
 6f5:	89 e5                	mov    %esp,%ebp
 6f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fa:	8b 45 08             	mov    0x8(%ebp),%eax
 6fd:	83 e8 08             	sub    $0x8,%eax
 700:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 703:	a1 ac 0c 00 00       	mov    0xcac,%eax
 708:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70b:	eb 24                	jmp    731 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 715:	77 12                	ja     729 <free+0x35>
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71d:	77 24                	ja     743 <free+0x4f>
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 727:	77 1a                	ja     743 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 00                	mov    (%eax),%eax
 72e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 737:	76 d4                	jbe    70d <free+0x19>
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 00                	mov    (%eax),%eax
 73e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 741:	76 ca                	jbe    70d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	8b 40 04             	mov    0x4(%eax),%eax
 749:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	01 c2                	add    %eax,%edx
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	39 c2                	cmp    %eax,%edx
 75c:	75 24                	jne    782 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	8b 50 04             	mov    0x4(%eax),%edx
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	8b 40 04             	mov    0x4(%eax),%eax
 76c:	01 c2                	add    %eax,%edx
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	8b 10                	mov    (%eax),%edx
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	89 10                	mov    %edx,(%eax)
 780:	eb 0a                	jmp    78c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	8b 10                	mov    (%eax),%edx
 787:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 40 04             	mov    0x4(%eax),%eax
 792:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	01 d0                	add    %edx,%eax
 79e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a1:	75 20                	jne    7c3 <free+0xcf>
    p->s.size += bp->s.size;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	8b 50 04             	mov    0x4(%eax),%edx
 7a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ac:	8b 40 04             	mov    0x4(%eax),%eax
 7af:	01 c2                	add    %eax,%edx
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bf:	89 10                	mov    %edx,(%eax)
 7c1:	eb 08                	jmp    7cb <free+0xd7>
  } else
    p->s.ptr = bp;
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c9:	89 10                	mov    %edx,(%eax)
  freep = p;
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	a3 ac 0c 00 00       	mov    %eax,0xcac
}
 7d3:	90                   	nop
 7d4:	c9                   	leave  
 7d5:	c3                   	ret    

000007d6 <morecore>:

static Header*
morecore(uint nu)
{
 7d6:	55                   	push   %ebp
 7d7:	89 e5                	mov    %esp,%ebp
 7d9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7dc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7e3:	77 07                	ja     7ec <morecore+0x16>
    nu = 4096;
 7e5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ec:	8b 45 08             	mov    0x8(%ebp),%eax
 7ef:	c1 e0 03             	shl    $0x3,%eax
 7f2:	83 ec 0c             	sub    $0xc,%esp
 7f5:	50                   	push   %eax
 7f6:	e8 41 fc ff ff       	call   43c <sbrk>
 7fb:	83 c4 10             	add    $0x10,%esp
 7fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 801:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 805:	75 07                	jne    80e <morecore+0x38>
    return 0;
 807:	b8 00 00 00 00       	mov    $0x0,%eax
 80c:	eb 26                	jmp    834 <morecore+0x5e>
  hp = (Header*)p;
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 814:	8b 45 f0             	mov    -0x10(%ebp),%eax
 817:	8b 55 08             	mov    0x8(%ebp),%edx
 81a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	83 c0 08             	add    $0x8,%eax
 823:	83 ec 0c             	sub    $0xc,%esp
 826:	50                   	push   %eax
 827:	e8 c8 fe ff ff       	call   6f4 <free>
 82c:	83 c4 10             	add    $0x10,%esp
  return freep;
 82f:	a1 ac 0c 00 00       	mov    0xcac,%eax
}
 834:	c9                   	leave  
 835:	c3                   	ret    

00000836 <malloc>:

void*
malloc(uint nbytes)
{
 836:	55                   	push   %ebp
 837:	89 e5                	mov    %esp,%ebp
 839:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83c:	8b 45 08             	mov    0x8(%ebp),%eax
 83f:	83 c0 07             	add    $0x7,%eax
 842:	c1 e8 03             	shr    $0x3,%eax
 845:	83 c0 01             	add    $0x1,%eax
 848:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 84b:	a1 ac 0c 00 00       	mov    0xcac,%eax
 850:	89 45 f0             	mov    %eax,-0x10(%ebp)
 853:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 857:	75 23                	jne    87c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 859:	c7 45 f0 a4 0c 00 00 	movl   $0xca4,-0x10(%ebp)
 860:	8b 45 f0             	mov    -0x10(%ebp),%eax
 863:	a3 ac 0c 00 00       	mov    %eax,0xcac
 868:	a1 ac 0c 00 00       	mov    0xcac,%eax
 86d:	a3 a4 0c 00 00       	mov    %eax,0xca4
    base.s.size = 0;
 872:	c7 05 a8 0c 00 00 00 	movl   $0x0,0xca8
 879:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	8b 40 04             	mov    0x4(%eax),%eax
 88a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 88d:	72 4d                	jb     8dc <malloc+0xa6>
      if(p->s.size == nunits)
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 898:	75 0c                	jne    8a6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	8b 10                	mov    (%eax),%edx
 89f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a2:	89 10                	mov    %edx,(%eax)
 8a4:	eb 26                	jmp    8cc <malloc+0x96>
      else {
        p->s.size -= nunits;
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	8b 40 04             	mov    0x4(%eax),%eax
 8ac:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8af:	89 c2                	mov    %eax,%edx
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	c1 e0 03             	shl    $0x3,%eax
 8c0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8c9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cf:	a3 ac 0c 00 00       	mov    %eax,0xcac
      return (void*)(p + 1);
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	83 c0 08             	add    $0x8,%eax
 8da:	eb 3b                	jmp    917 <malloc+0xe1>
    }
    if(p == freep)
 8dc:	a1 ac 0c 00 00       	mov    0xcac,%eax
 8e1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8e4:	75 1e                	jne    904 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8e6:	83 ec 0c             	sub    $0xc,%esp
 8e9:	ff 75 ec             	pushl  -0x14(%ebp)
 8ec:	e8 e5 fe ff ff       	call   7d6 <morecore>
 8f1:	83 c4 10             	add    $0x10,%esp
 8f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8fb:	75 07                	jne    904 <malloc+0xce>
        return 0;
 8fd:	b8 00 00 00 00       	mov    $0x0,%eax
 902:	eb 13                	jmp    917 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 904:	8b 45 f4             	mov    -0xc(%ebp),%eax
 907:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 912:	e9 6d ff ff ff       	jmp    884 <malloc+0x4e>
}
 917:	c9                   	leave  
 918:	c3                   	ret    
