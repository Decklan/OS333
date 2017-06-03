
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
  c5:	e8 65 04 00 00       	call   52f <date>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	85 c0                	test   %eax,%eax
  cf:	74 1b                	je     ec <main+0x40>
    printf(2,"Error: date call failed. %s at line %d\n", __FILE__, __LINE__);
  d1:	6a 19                	push   $0x19
  d3:	68 65 0a 00 00       	push   $0xa65
  d8:	68 6c 0a 00 00       	push   $0xa6c
  dd:	6a 02                	push   $0x2
  df:	e8 7a 05 00 00       	call   65e <printf>
  e4:	83 c4 10             	add    $0x10,%esp
    exit();
  e7:	e8 9b 03 00 00       	call   487 <exit>
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
 110:	8b 14 85 60 0d 00 00 	mov    0xd60(,%eax,4),%edx
 117:	8b 45 f4             	mov    -0xc(%ebp),%eax
 11a:	8b 04 85 94 0d 00 00 	mov    0xd94(,%eax,4),%eax
 121:	83 ec 0c             	sub    $0xc,%esp
 124:	51                   	push   %ecx
 125:	52                   	push   %edx
 126:	50                   	push   %eax
 127:	68 94 0a 00 00       	push   $0xa94
 12c:	6a 01                	push   $0x1
 12e:	e8 2b 05 00 00       	call   65e <printf>
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
 149:	68 9d 0a 00 00       	push   $0xa9d
 14e:	6a 01                	push   $0x1
 150:	e8 09 05 00 00       	call   65e <printf>
 155:	83 c4 20             	add    $0x20,%esp

  exit();
 158:	e8 2a 03 00 00       	call   487 <exit>

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
 280:	e8 1a 02 00 00       	call   49f <read>
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
 2e3:	e8 df 01 00 00       	call   4c7 <open>
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
 304:	e8 d6 01 00 00       	call   4df <fstat>
 309:	83 c4 10             	add    $0x10,%esp
 30c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30f:	83 ec 0c             	sub    $0xc,%esp
 312:	ff 75 f4             	pushl  -0xc(%ebp)
 315:	e8 95 01 00 00       	call   4af <close>
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
  int n, sign;

  n = 0;
 328:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 32f:	eb 04                	jmp    335 <atoi+0x13>
 331:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	3c 20                	cmp    $0x20,%al
 33d:	74 f2                	je     331 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	0f b6 00             	movzbl (%eax),%eax
 345:	3c 2d                	cmp    $0x2d,%al
 347:	75 07                	jne    350 <atoi+0x2e>
 349:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 34e:	eb 05                	jmp    355 <atoi+0x33>
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	0f b6 00             	movzbl (%eax),%eax
 35e:	3c 2b                	cmp    $0x2b,%al
 360:	74 0a                	je     36c <atoi+0x4a>
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	0f b6 00             	movzbl (%eax),%eax
 368:	3c 2d                	cmp    $0x2d,%al
 36a:	75 2b                	jne    397 <atoi+0x75>
    s++;
 36c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 370:	eb 25                	jmp    397 <atoi+0x75>
    n = n*10 + *s++ - '0';
 372:	8b 55 fc             	mov    -0x4(%ebp),%edx
 375:	89 d0                	mov    %edx,%eax
 377:	c1 e0 02             	shl    $0x2,%eax
 37a:	01 d0                	add    %edx,%eax
 37c:	01 c0                	add    %eax,%eax
 37e:	89 c1                	mov    %eax,%ecx
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	8d 50 01             	lea    0x1(%eax),%edx
 386:	89 55 08             	mov    %edx,0x8(%ebp)
 389:	0f b6 00             	movzbl (%eax),%eax
 38c:	0f be c0             	movsbl %al,%eax
 38f:	01 c8                	add    %ecx,%eax
 391:	83 e8 30             	sub    $0x30,%eax
 394:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	0f b6 00             	movzbl (%eax),%eax
 39d:	3c 2f                	cmp    $0x2f,%al
 39f:	7e 0a                	jle    3ab <atoi+0x89>
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	0f b6 00             	movzbl (%eax),%eax
 3a7:	3c 39                	cmp    $0x39,%al
 3a9:	7e c7                	jle    372 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ae:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3b2:	c9                   	leave  
 3b3:	c3                   	ret    

000003b4 <atoo>:

int
atoo(const char *s)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3c1:	eb 04                	jmp    3c7 <atoo+0x13>
 3c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 20                	cmp    $0x20,%al
 3cf:	74 f2                	je     3c3 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	0f b6 00             	movzbl (%eax),%eax
 3d7:	3c 2d                	cmp    $0x2d,%al
 3d9:	75 07                	jne    3e2 <atoo+0x2e>
 3db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3e0:	eb 05                	jmp    3e7 <atoo+0x33>
 3e2:	b8 01 00 00 00       	mov    $0x1,%eax
 3e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	0f b6 00             	movzbl (%eax),%eax
 3f0:	3c 2b                	cmp    $0x2b,%al
 3f2:	74 0a                	je     3fe <atoo+0x4a>
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	0f b6 00             	movzbl (%eax),%eax
 3fa:	3c 2d                	cmp    $0x2d,%al
 3fc:	75 27                	jne    425 <atoo+0x71>
    s++;
 3fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 402:	eb 21                	jmp    425 <atoo+0x71>
    n = n*8 + *s++ - '0';
 404:	8b 45 fc             	mov    -0x4(%ebp),%eax
 407:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
 411:	8d 50 01             	lea    0x1(%eax),%edx
 414:	89 55 08             	mov    %edx,0x8(%ebp)
 417:	0f b6 00             	movzbl (%eax),%eax
 41a:	0f be c0             	movsbl %al,%eax
 41d:	01 c8                	add    %ecx,%eax
 41f:	83 e8 30             	sub    $0x30,%eax
 422:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	0f b6 00             	movzbl (%eax),%eax
 42b:	3c 2f                	cmp    $0x2f,%al
 42d:	7e 0a                	jle    439 <atoo+0x85>
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
 432:	0f b6 00             	movzbl (%eax),%eax
 435:	3c 37                	cmp    $0x37,%al
 437:	7e cb                	jle    404 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 439:	8b 45 f8             	mov    -0x8(%ebp),%eax
 43c:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 440:	c9                   	leave  
 441:	c3                   	ret    

00000442 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 442:	55                   	push   %ebp
 443:	89 e5                	mov    %esp,%ebp
 445:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 448:	8b 45 08             	mov    0x8(%ebp),%eax
 44b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 44e:	8b 45 0c             	mov    0xc(%ebp),%eax
 451:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 454:	eb 17                	jmp    46d <memmove+0x2b>
    *dst++ = *src++;
 456:	8b 45 fc             	mov    -0x4(%ebp),%eax
 459:	8d 50 01             	lea    0x1(%eax),%edx
 45c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 45f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 462:	8d 4a 01             	lea    0x1(%edx),%ecx
 465:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 468:	0f b6 12             	movzbl (%edx),%edx
 46b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 46d:	8b 45 10             	mov    0x10(%ebp),%eax
 470:	8d 50 ff             	lea    -0x1(%eax),%edx
 473:	89 55 10             	mov    %edx,0x10(%ebp)
 476:	85 c0                	test   %eax,%eax
 478:	7f dc                	jg     456 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 47a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 47d:	c9                   	leave  
 47e:	c3                   	ret    

0000047f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 47f:	b8 01 00 00 00       	mov    $0x1,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <exit>:
SYSCALL(exit)
 487:	b8 02 00 00 00       	mov    $0x2,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <wait>:
SYSCALL(wait)
 48f:	b8 03 00 00 00       	mov    $0x3,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <pipe>:
SYSCALL(pipe)
 497:	b8 04 00 00 00       	mov    $0x4,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <read>:
SYSCALL(read)
 49f:	b8 05 00 00 00       	mov    $0x5,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <write>:
SYSCALL(write)
 4a7:	b8 10 00 00 00       	mov    $0x10,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <close>:
SYSCALL(close)
 4af:	b8 15 00 00 00       	mov    $0x15,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <kill>:
SYSCALL(kill)
 4b7:	b8 06 00 00 00       	mov    $0x6,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <exec>:
SYSCALL(exec)
 4bf:	b8 07 00 00 00       	mov    $0x7,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <open>:
SYSCALL(open)
 4c7:	b8 0f 00 00 00       	mov    $0xf,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <mknod>:
SYSCALL(mknod)
 4cf:	b8 11 00 00 00       	mov    $0x11,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <unlink>:
SYSCALL(unlink)
 4d7:	b8 12 00 00 00       	mov    $0x12,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <fstat>:
SYSCALL(fstat)
 4df:	b8 08 00 00 00       	mov    $0x8,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <link>:
SYSCALL(link)
 4e7:	b8 13 00 00 00       	mov    $0x13,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <mkdir>:
SYSCALL(mkdir)
 4ef:	b8 14 00 00 00       	mov    $0x14,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <chdir>:
SYSCALL(chdir)
 4f7:	b8 09 00 00 00       	mov    $0x9,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <dup>:
SYSCALL(dup)
 4ff:	b8 0a 00 00 00       	mov    $0xa,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <getpid>:
SYSCALL(getpid)
 507:	b8 0b 00 00 00       	mov    $0xb,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <sbrk>:
SYSCALL(sbrk)
 50f:	b8 0c 00 00 00       	mov    $0xc,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <sleep>:
SYSCALL(sleep)
 517:	b8 0d 00 00 00       	mov    $0xd,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <uptime>:
SYSCALL(uptime)
 51f:	b8 0e 00 00 00       	mov    $0xe,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <halt>:
SYSCALL(halt)
 527:	b8 16 00 00 00       	mov    $0x16,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <date>:
SYSCALL(date)        #p1
 52f:	b8 17 00 00 00       	mov    $0x17,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <getuid>:
SYSCALL(getuid)      #p2
 537:	b8 18 00 00 00       	mov    $0x18,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <getgid>:
SYSCALL(getgid)      #p2
 53f:	b8 19 00 00 00       	mov    $0x19,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <getppid>:
SYSCALL(getppid)     #p2
 547:	b8 1a 00 00 00       	mov    $0x1a,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <setuid>:
SYSCALL(setuid)      #p2
 54f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <setgid>:
SYSCALL(setgid)      #p2
 557:	b8 1c 00 00 00       	mov    $0x1c,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <getprocs>:
SYSCALL(getprocs)    #p2
 55f:	b8 1d 00 00 00       	mov    $0x1d,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <setpriority>:
SYSCALL(setpriority) #p4
 567:	b8 1e 00 00 00       	mov    $0x1e,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <chmod>:
SYSCALL(chmod)       #p5
 56f:	b8 1f 00 00 00       	mov    $0x1f,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <chown>:
SYSCALL(chown)       #p5
 577:	b8 20 00 00 00       	mov    $0x20,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <chgrp>:
SYSCALL(chgrp)       #p5
 57f:	b8 21 00 00 00       	mov    $0x21,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 587:	55                   	push   %ebp
 588:	89 e5                	mov    %esp,%ebp
 58a:	83 ec 18             	sub    $0x18,%esp
 58d:	8b 45 0c             	mov    0xc(%ebp),%eax
 590:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 593:	83 ec 04             	sub    $0x4,%esp
 596:	6a 01                	push   $0x1
 598:	8d 45 f4             	lea    -0xc(%ebp),%eax
 59b:	50                   	push   %eax
 59c:	ff 75 08             	pushl  0x8(%ebp)
 59f:	e8 03 ff ff ff       	call   4a7 <write>
 5a4:	83 c4 10             	add    $0x10,%esp
}
 5a7:	90                   	nop
 5a8:	c9                   	leave  
 5a9:	c3                   	ret    

000005aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5aa:	55                   	push   %ebp
 5ab:	89 e5                	mov    %esp,%ebp
 5ad:	53                   	push   %ebx
 5ae:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5b8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5bc:	74 17                	je     5d5 <printint+0x2b>
 5be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5c2:	79 11                	jns    5d5 <printint+0x2b>
    neg = 1;
 5c4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ce:	f7 d8                	neg    %eax
 5d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5d3:	eb 06                	jmp    5db <printint+0x31>
  } else {
    x = xx;
 5d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5e2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5e5:	8d 41 01             	lea    0x1(%ecx),%eax
 5e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f1:	ba 00 00 00 00       	mov    $0x0,%edx
 5f6:	f7 f3                	div    %ebx
 5f8:	89 d0                	mov    %edx,%eax
 5fa:	0f b6 80 b0 0d 00 00 	movzbl 0xdb0(%eax),%eax
 601:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 605:	8b 5d 10             	mov    0x10(%ebp),%ebx
 608:	8b 45 ec             	mov    -0x14(%ebp),%eax
 60b:	ba 00 00 00 00       	mov    $0x0,%edx
 610:	f7 f3                	div    %ebx
 612:	89 45 ec             	mov    %eax,-0x14(%ebp)
 615:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 619:	75 c7                	jne    5e2 <printint+0x38>
  if(neg)
 61b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 61f:	74 2d                	je     64e <printint+0xa4>
    buf[i++] = '-';
 621:	8b 45 f4             	mov    -0xc(%ebp),%eax
 624:	8d 50 01             	lea    0x1(%eax),%edx
 627:	89 55 f4             	mov    %edx,-0xc(%ebp)
 62a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 62f:	eb 1d                	jmp    64e <printint+0xa4>
    putc(fd, buf[i]);
 631:	8d 55 dc             	lea    -0x24(%ebp),%edx
 634:	8b 45 f4             	mov    -0xc(%ebp),%eax
 637:	01 d0                	add    %edx,%eax
 639:	0f b6 00             	movzbl (%eax),%eax
 63c:	0f be c0             	movsbl %al,%eax
 63f:	83 ec 08             	sub    $0x8,%esp
 642:	50                   	push   %eax
 643:	ff 75 08             	pushl  0x8(%ebp)
 646:	e8 3c ff ff ff       	call   587 <putc>
 64b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 64e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 656:	79 d9                	jns    631 <printint+0x87>
    putc(fd, buf[i]);
}
 658:	90                   	nop
 659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 65c:	c9                   	leave  
 65d:	c3                   	ret    

0000065e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 65e:	55                   	push   %ebp
 65f:	89 e5                	mov    %esp,%ebp
 661:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 664:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 66b:	8d 45 0c             	lea    0xc(%ebp),%eax
 66e:	83 c0 04             	add    $0x4,%eax
 671:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 674:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 67b:	e9 59 01 00 00       	jmp    7d9 <printf+0x17b>
    c = fmt[i] & 0xff;
 680:	8b 55 0c             	mov    0xc(%ebp),%edx
 683:	8b 45 f0             	mov    -0x10(%ebp),%eax
 686:	01 d0                	add    %edx,%eax
 688:	0f b6 00             	movzbl (%eax),%eax
 68b:	0f be c0             	movsbl %al,%eax
 68e:	25 ff 00 00 00       	and    $0xff,%eax
 693:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 696:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 69a:	75 2c                	jne    6c8 <printf+0x6a>
      if(c == '%'){
 69c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a0:	75 0c                	jne    6ae <printf+0x50>
        state = '%';
 6a2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6a9:	e9 27 01 00 00       	jmp    7d5 <printf+0x177>
      } else {
        putc(fd, c);
 6ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b1:	0f be c0             	movsbl %al,%eax
 6b4:	83 ec 08             	sub    $0x8,%esp
 6b7:	50                   	push   %eax
 6b8:	ff 75 08             	pushl  0x8(%ebp)
 6bb:	e8 c7 fe ff ff       	call   587 <putc>
 6c0:	83 c4 10             	add    $0x10,%esp
 6c3:	e9 0d 01 00 00       	jmp    7d5 <printf+0x177>
      }
    } else if(state == '%'){
 6c8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6cc:	0f 85 03 01 00 00    	jne    7d5 <printf+0x177>
      if(c == 'd'){
 6d2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6d6:	75 1e                	jne    6f6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	6a 01                	push   $0x1
 6df:	6a 0a                	push   $0xa
 6e1:	50                   	push   %eax
 6e2:	ff 75 08             	pushl  0x8(%ebp)
 6e5:	e8 c0 fe ff ff       	call   5aa <printint>
 6ea:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f1:	e9 d8 00 00 00       	jmp    7ce <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6f6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6fa:	74 06                	je     702 <printf+0xa4>
 6fc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 700:	75 1e                	jne    720 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 702:	8b 45 e8             	mov    -0x18(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	6a 00                	push   $0x0
 709:	6a 10                	push   $0x10
 70b:	50                   	push   %eax
 70c:	ff 75 08             	pushl  0x8(%ebp)
 70f:	e8 96 fe ff ff       	call   5aa <printint>
 714:	83 c4 10             	add    $0x10,%esp
        ap++;
 717:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 71b:	e9 ae 00 00 00       	jmp    7ce <printf+0x170>
      } else if(c == 's'){
 720:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 724:	75 43                	jne    769 <printf+0x10b>
        s = (char*)*ap;
 726:	8b 45 e8             	mov    -0x18(%ebp),%eax
 729:	8b 00                	mov    (%eax),%eax
 72b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 72e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 736:	75 25                	jne    75d <printf+0xff>
          s = "(null)";
 738:	c7 45 f4 af 0a 00 00 	movl   $0xaaf,-0xc(%ebp)
        while(*s != 0){
 73f:	eb 1c                	jmp    75d <printf+0xff>
          putc(fd, *s);
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	0f b6 00             	movzbl (%eax),%eax
 747:	0f be c0             	movsbl %al,%eax
 74a:	83 ec 08             	sub    $0x8,%esp
 74d:	50                   	push   %eax
 74e:	ff 75 08             	pushl  0x8(%ebp)
 751:	e8 31 fe ff ff       	call   587 <putc>
 756:	83 c4 10             	add    $0x10,%esp
          s++;
 759:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	0f b6 00             	movzbl (%eax),%eax
 763:	84 c0                	test   %al,%al
 765:	75 da                	jne    741 <printf+0xe3>
 767:	eb 65                	jmp    7ce <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 769:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 76d:	75 1d                	jne    78c <printf+0x12e>
        putc(fd, *ap);
 76f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 772:	8b 00                	mov    (%eax),%eax
 774:	0f be c0             	movsbl %al,%eax
 777:	83 ec 08             	sub    $0x8,%esp
 77a:	50                   	push   %eax
 77b:	ff 75 08             	pushl  0x8(%ebp)
 77e:	e8 04 fe ff ff       	call   587 <putc>
 783:	83 c4 10             	add    $0x10,%esp
        ap++;
 786:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 78a:	eb 42                	jmp    7ce <printf+0x170>
      } else if(c == '%'){
 78c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 790:	75 17                	jne    7a9 <printf+0x14b>
        putc(fd, c);
 792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 795:	0f be c0             	movsbl %al,%eax
 798:	83 ec 08             	sub    $0x8,%esp
 79b:	50                   	push   %eax
 79c:	ff 75 08             	pushl  0x8(%ebp)
 79f:	e8 e3 fd ff ff       	call   587 <putc>
 7a4:	83 c4 10             	add    $0x10,%esp
 7a7:	eb 25                	jmp    7ce <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a9:	83 ec 08             	sub    $0x8,%esp
 7ac:	6a 25                	push   $0x25
 7ae:	ff 75 08             	pushl  0x8(%ebp)
 7b1:	e8 d1 fd ff ff       	call   587 <putc>
 7b6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7bc:	0f be c0             	movsbl %al,%eax
 7bf:	83 ec 08             	sub    $0x8,%esp
 7c2:	50                   	push   %eax
 7c3:	ff 75 08             	pushl  0x8(%ebp)
 7c6:	e8 bc fd ff ff       	call   587 <putc>
 7cb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7d5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7d9:	8b 55 0c             	mov    0xc(%ebp),%edx
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	01 d0                	add    %edx,%eax
 7e1:	0f b6 00             	movzbl (%eax),%eax
 7e4:	84 c0                	test   %al,%al
 7e6:	0f 85 94 fe ff ff    	jne    680 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7ec:	90                   	nop
 7ed:	c9                   	leave  
 7ee:	c3                   	ret    

000007ef <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ef:	55                   	push   %ebp
 7f0:	89 e5                	mov    %esp,%ebp
 7f2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f5:	8b 45 08             	mov    0x8(%ebp),%eax
 7f8:	83 e8 08             	sub    $0x8,%eax
 7fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fe:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 803:	89 45 fc             	mov    %eax,-0x4(%ebp)
 806:	eb 24                	jmp    82c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	8b 00                	mov    (%eax),%eax
 80d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 810:	77 12                	ja     824 <free+0x35>
 812:	8b 45 f8             	mov    -0x8(%ebp),%eax
 815:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 818:	77 24                	ja     83e <free+0x4f>
 81a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 822:	77 1a                	ja     83e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 824:	8b 45 fc             	mov    -0x4(%ebp),%eax
 827:	8b 00                	mov    (%eax),%eax
 829:	89 45 fc             	mov    %eax,-0x4(%ebp)
 82c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 832:	76 d4                	jbe    808 <free+0x19>
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	8b 00                	mov    (%eax),%eax
 839:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 83c:	76 ca                	jbe    808 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 83e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 841:	8b 40 04             	mov    0x4(%eax),%eax
 844:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84e:	01 c2                	add    %eax,%edx
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	8b 00                	mov    (%eax),%eax
 855:	39 c2                	cmp    %eax,%edx
 857:	75 24                	jne    87d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 859:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85c:	8b 50 04             	mov    0x4(%eax),%edx
 85f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 862:	8b 00                	mov    (%eax),%eax
 864:	8b 40 04             	mov    0x4(%eax),%eax
 867:	01 c2                	add    %eax,%edx
 869:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 86f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 872:	8b 00                	mov    (%eax),%eax
 874:	8b 10                	mov    (%eax),%edx
 876:	8b 45 f8             	mov    -0x8(%ebp),%eax
 879:	89 10                	mov    %edx,(%eax)
 87b:	eb 0a                	jmp    887 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	8b 10                	mov    (%eax),%edx
 882:	8b 45 f8             	mov    -0x8(%ebp),%eax
 885:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 887:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88a:	8b 40 04             	mov    0x4(%eax),%eax
 88d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	01 d0                	add    %edx,%eax
 899:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 89c:	75 20                	jne    8be <free+0xcf>
    p->s.size += bp->s.size;
 89e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a1:	8b 50 04             	mov    0x4(%eax),%edx
 8a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a7:	8b 40 04             	mov    0x4(%eax),%eax
 8aa:	01 c2                	add    %eax,%edx
 8ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b5:	8b 10                	mov    (%eax),%edx
 8b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ba:	89 10                	mov    %edx,(%eax)
 8bc:	eb 08                	jmp    8c6 <free+0xd7>
  } else
    p->s.ptr = bp;
 8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8c4:	89 10                	mov    %edx,(%eax)
  freep = p;
 8c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c9:	a3 cc 0d 00 00       	mov    %eax,0xdcc
}
 8ce:	90                   	nop
 8cf:	c9                   	leave  
 8d0:	c3                   	ret    

000008d1 <morecore>:

static Header*
morecore(uint nu)
{
 8d1:	55                   	push   %ebp
 8d2:	89 e5                	mov    %esp,%ebp
 8d4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8d7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8de:	77 07                	ja     8e7 <morecore+0x16>
    nu = 4096;
 8e0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8e7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ea:	c1 e0 03             	shl    $0x3,%eax
 8ed:	83 ec 0c             	sub    $0xc,%esp
 8f0:	50                   	push   %eax
 8f1:	e8 19 fc ff ff       	call   50f <sbrk>
 8f6:	83 c4 10             	add    $0x10,%esp
 8f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8fc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 900:	75 07                	jne    909 <morecore+0x38>
    return 0;
 902:	b8 00 00 00 00       	mov    $0x0,%eax
 907:	eb 26                	jmp    92f <morecore+0x5e>
  hp = (Header*)p;
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 90f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 912:	8b 55 08             	mov    0x8(%ebp),%edx
 915:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 918:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91b:	83 c0 08             	add    $0x8,%eax
 91e:	83 ec 0c             	sub    $0xc,%esp
 921:	50                   	push   %eax
 922:	e8 c8 fe ff ff       	call   7ef <free>
 927:	83 c4 10             	add    $0x10,%esp
  return freep;
 92a:	a1 cc 0d 00 00       	mov    0xdcc,%eax
}
 92f:	c9                   	leave  
 930:	c3                   	ret    

00000931 <malloc>:

void*
malloc(uint nbytes)
{
 931:	55                   	push   %ebp
 932:	89 e5                	mov    %esp,%ebp
 934:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 937:	8b 45 08             	mov    0x8(%ebp),%eax
 93a:	83 c0 07             	add    $0x7,%eax
 93d:	c1 e8 03             	shr    $0x3,%eax
 940:	83 c0 01             	add    $0x1,%eax
 943:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 946:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 94b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 94e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 952:	75 23                	jne    977 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 954:	c7 45 f0 c4 0d 00 00 	movl   $0xdc4,-0x10(%ebp)
 95b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95e:	a3 cc 0d 00 00       	mov    %eax,0xdcc
 963:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 968:	a3 c4 0d 00 00       	mov    %eax,0xdc4
    base.s.size = 0;
 96d:	c7 05 c8 0d 00 00 00 	movl   $0x0,0xdc8
 974:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 977:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97a:	8b 00                	mov    (%eax),%eax
 97c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 97f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 982:	8b 40 04             	mov    0x4(%eax),%eax
 985:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 988:	72 4d                	jb     9d7 <malloc+0xa6>
      if(p->s.size == nunits)
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	8b 40 04             	mov    0x4(%eax),%eax
 990:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 993:	75 0c                	jne    9a1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 995:	8b 45 f4             	mov    -0xc(%ebp),%eax
 998:	8b 10                	mov    (%eax),%edx
 99a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99d:	89 10                	mov    %edx,(%eax)
 99f:	eb 26                	jmp    9c7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a4:	8b 40 04             	mov    0x4(%eax),%eax
 9a7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9aa:	89 c2                	mov    %eax,%edx
 9ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9af:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b5:	8b 40 04             	mov    0x4(%eax),%eax
 9b8:	c1 e0 03             	shl    $0x3,%eax
 9bb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9c4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ca:	a3 cc 0d 00 00       	mov    %eax,0xdcc
      return (void*)(p + 1);
 9cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d2:	83 c0 08             	add    $0x8,%eax
 9d5:	eb 3b                	jmp    a12 <malloc+0xe1>
    }
    if(p == freep)
 9d7:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 9dc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9df:	75 1e                	jne    9ff <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9e1:	83 ec 0c             	sub    $0xc,%esp
 9e4:	ff 75 ec             	pushl  -0x14(%ebp)
 9e7:	e8 e5 fe ff ff       	call   8d1 <morecore>
 9ec:	83 c4 10             	add    $0x10,%esp
 9ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9f6:	75 07                	jne    9ff <malloc+0xce>
        return 0;
 9f8:	b8 00 00 00 00       	mov    $0x0,%eax
 9fd:	eb 13                	jmp    a12 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a08:	8b 00                	mov    (%eax),%eax
 a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a0d:	e9 6d ff ff ff       	jmp    97f <malloc+0x4e>
}
 a12:	c9                   	leave  
 a13:	c3                   	ret    
