
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "uproc.h"
#include "user.h"
#define MAX 32

int main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 28             	sub    $0x28,%esp
  struct uproc* table = malloc(MAX*sizeof(struct uproc));
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	68 80 0b 00 00       	push   $0xb80
  1c:	e8 1c 08 00 00       	call   83d <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if (!table) 
  27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  2b:	75 1c                	jne    49 <main+0x49>
  {
    printf(2, "Error. Malloc call failed.");
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	68 20 09 00 00       	push   $0x920
  35:	6a 02                	push   $0x2
  37:	e8 2e 05 00 00       	call   56a <printf>
  3c:	83 c4 10             	add    $0x10,%esp
    return -1;
  3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  44:	e9 07 01 00 00       	jmp    150 <main+0x150>
  }  
  int status = getprocs(MAX, table);
  49:	83 ec 08             	sub    $0x8,%esp
  4c:	ff 75 e0             	pushl  -0x20(%ebp)
  4f:	6a 20                	push   $0x20
  51:	e8 35 04 00 00       	call   48b <getprocs>
  56:	83 c4 10             	add    $0x10,%esp
  59:	89 45 dc             	mov    %eax,-0x24(%ebp)
  printf(1, "PID  UID  GID  PPID  Elapsed  Total Ticks  Size     State       Name\n");
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 3c 09 00 00       	push   $0x93c
  64:	6a 01                	push   $0x1
  66:	e8 ff 04 00 00       	call   56a <printf>
  6b:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < status; ++i)
  6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  75:	e9 b0 00 00 00       	jmp    12a <main+0x12a>
  {
    printf(1, "%d    %d   %d   %d     %d        %d            %d    %s       %s\n", table[i].pid, table[i].uid, 
          table[i].gid, table[i].ppid, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].size, table[i].state, table[i].name);
  7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  7d:	6b d0 5c             	imul   $0x5c,%eax,%edx
  80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  83:	01 d0                	add    %edx,%eax
  85:	83 c0 3c             	add    $0x3c,%eax
  88:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8e:	6b d0 5c             	imul   $0x5c,%eax,%edx
  91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  94:	01 d0                	add    %edx,%eax
  96:	8d 48 18             	lea    0x18(%eax),%ecx
  99:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  9f:	6b d0 5c             	imul   $0x5c,%eax,%edx
  a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a5:	01 d0                	add    %edx,%eax
  }  
  int status = getprocs(MAX, table);
  printf(1, "PID  UID  GID  PPID  Elapsed  Total Ticks  Size     State       Name\n");
  for (int i = 0; i < status; ++i)
  {
    printf(1, "%d    %d   %d   %d     %d        %d            %d    %s       %s\n", table[i].pid, table[i].uid, 
  a7:	8b 58 38             	mov    0x38(%eax),%ebx
  aa:	89 5d cc             	mov    %ebx,-0x34(%ebp)
          table[i].gid, table[i].ppid, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].size, table[i].state, table[i].name);
  ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  b0:	6b d0 5c             	imul   $0x5c,%eax,%edx
  b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b6:	01 d0                	add    %edx,%eax
  }  
  int status = getprocs(MAX, table);
  printf(1, "PID  UID  GID  PPID  Elapsed  Total Ticks  Size     State       Name\n");
  for (int i = 0; i < status; ++i)
  {
    printf(1, "%d    %d   %d   %d     %d        %d            %d    %s       %s\n", table[i].pid, table[i].uid, 
  b8:	8b 70 14             	mov    0x14(%eax),%esi
  bb:	89 75 c8             	mov    %esi,-0x38(%ebp)
          table[i].gid, table[i].ppid, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].size, table[i].state, table[i].name);
  be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  c1:	6b d0 5c             	imul   $0x5c,%eax,%edx
  c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  c7:	01 d0                	add    %edx,%eax
  }  
  int status = getprocs(MAX, table);
  printf(1, "PID  UID  GID  PPID  Elapsed  Total Ticks  Size     State       Name\n");
  for (int i = 0; i < status; ++i)
  {
    printf(1, "%d    %d   %d   %d     %d        %d            %d    %s       %s\n", table[i].pid, table[i].uid, 
  c9:	8b 78 10             	mov    0x10(%eax),%edi
          table[i].gid, table[i].ppid, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].size, table[i].state, table[i].name);
  cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  cf:	6b d0 5c             	imul   $0x5c,%eax,%edx
  d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  d5:	01 d0                	add    %edx,%eax
  }  
  int status = getprocs(MAX, table);
  printf(1, "PID  UID  GID  PPID  Elapsed  Total Ticks  Size     State       Name\n");
  for (int i = 0; i < status; ++i)
  {
    printf(1, "%d    %d   %d   %d     %d        %d            %d    %s       %s\n", table[i].pid, table[i].uid, 
  d7:	8b 70 0c             	mov    0xc(%eax),%esi
          table[i].gid, table[i].ppid, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].size, table[i].state, table[i].name);
  da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  dd:	6b d0 5c             	imul   $0x5c,%eax,%edx
  e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e3:	01 d0                	add    %edx,%eax
  }  
  int status = getprocs(MAX, table);
  printf(1, "PID  UID  GID  PPID  Elapsed  Total Ticks  Size     State       Name\n");
  for (int i = 0; i < status; ++i)
  {
    printf(1, "%d    %d   %d   %d     %d        %d            %d    %s       %s\n", table[i].pid, table[i].uid, 
  e5:	8b 58 08             	mov    0x8(%eax),%ebx
  e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  eb:	6b d0 5c             	imul   $0x5c,%eax,%edx
  ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  f1:	01 d0                	add    %edx,%eax
  f3:	8b 48 04             	mov    0x4(%eax),%ecx
  f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f9:	6b d0 5c             	imul   $0x5c,%eax,%edx
  fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  ff:	01 d0                	add    %edx,%eax
 101:	8b 00                	mov    (%eax),%eax
 103:	83 ec 04             	sub    $0x4,%esp
 106:	ff 75 d4             	pushl  -0x2c(%ebp)
 109:	ff 75 d0             	pushl  -0x30(%ebp)
 10c:	ff 75 cc             	pushl  -0x34(%ebp)
 10f:	ff 75 c8             	pushl  -0x38(%ebp)
 112:	57                   	push   %edi
 113:	56                   	push   %esi
 114:	53                   	push   %ebx
 115:	51                   	push   %ecx
 116:	50                   	push   %eax
 117:	68 84 09 00 00       	push   $0x984
 11c:	6a 01                	push   $0x1
 11e:	e8 47 04 00 00       	call   56a <printf>
 123:	83 c4 30             	add    $0x30,%esp
    printf(2, "Error. Malloc call failed.");
    return -1;
  }  
  int status = getprocs(MAX, table);
  printf(1, "PID  UID  GID  PPID  Elapsed  Total Ticks  Size     State       Name\n");
  for (int i = 0; i < status; ++i)
 126:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 12a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 130:	0f 8c 44 ff ff ff    	jl     7a <main+0x7a>
  {
    printf(1, "%d    %d   %d   %d     %d        %d            %d    %s       %s\n", table[i].pid, table[i].uid, 
          table[i].gid, table[i].ppid, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].size, table[i].state, table[i].name);
  }
  printf(1, "%d system calls used.\n", status);
 136:	83 ec 04             	sub    $0x4,%esp
 139:	ff 75 dc             	pushl  -0x24(%ebp)
 13c:	68 c6 09 00 00       	push   $0x9c6
 141:	6a 01                	push   $0x1
 143:	e8 22 04 00 00       	call   56a <printf>
 148:	83 c4 10             	add    $0x10,%esp
  exit();
 14b:	e8 63 02 00 00       	call   3b3 <exit>
}
 150:	8d 65 f0             	lea    -0x10(%ebp),%esp
 153:	59                   	pop    %ecx
 154:	5b                   	pop    %ebx
 155:	5e                   	pop    %esi
 156:	5f                   	pop    %edi
 157:	5d                   	pop    %ebp
 158:	8d 61 fc             	lea    -0x4(%ecx),%esp
 15b:	c3                   	ret    

0000015c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	57                   	push   %edi
 160:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 161:	8b 4d 08             	mov    0x8(%ebp),%ecx
 164:	8b 55 10             	mov    0x10(%ebp),%edx
 167:	8b 45 0c             	mov    0xc(%ebp),%eax
 16a:	89 cb                	mov    %ecx,%ebx
 16c:	89 df                	mov    %ebx,%edi
 16e:	89 d1                	mov    %edx,%ecx
 170:	fc                   	cld    
 171:	f3 aa                	rep stos %al,%es:(%edi)
 173:	89 ca                	mov    %ecx,%edx
 175:	89 fb                	mov    %edi,%ebx
 177:	89 5d 08             	mov    %ebx,0x8(%ebp)
 17a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 17d:	90                   	nop
 17e:	5b                   	pop    %ebx
 17f:	5f                   	pop    %edi
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    

00000182 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
 185:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 18e:	90                   	nop
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	8d 50 01             	lea    0x1(%eax),%edx
 195:	89 55 08             	mov    %edx,0x8(%ebp)
 198:	8b 55 0c             	mov    0xc(%ebp),%edx
 19b:	8d 4a 01             	lea    0x1(%edx),%ecx
 19e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1a1:	0f b6 12             	movzbl (%edx),%edx
 1a4:	88 10                	mov    %dl,(%eax)
 1a6:	0f b6 00             	movzbl (%eax),%eax
 1a9:	84 c0                	test   %al,%al
 1ab:	75 e2                	jne    18f <strcpy+0xd>
    ;
  return os;
 1ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b0:	c9                   	leave  
 1b1:	c3                   	ret    

000001b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1b5:	eb 08                	jmp    1bf <strcmp+0xd>
    p++, q++;
 1b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1bb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 00             	movzbl (%eax),%eax
 1c5:	84 c0                	test   %al,%al
 1c7:	74 10                	je     1d9 <strcmp+0x27>
 1c9:	8b 45 08             	mov    0x8(%ebp),%eax
 1cc:	0f b6 10             	movzbl (%eax),%edx
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	38 c2                	cmp    %al,%dl
 1d7:	74 de                	je     1b7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	0f b6 00             	movzbl (%eax),%eax
 1df:	0f b6 d0             	movzbl %al,%edx
 1e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e5:	0f b6 00             	movzbl (%eax),%eax
 1e8:	0f b6 c0             	movzbl %al,%eax
 1eb:	29 c2                	sub    %eax,%edx
 1ed:	89 d0                	mov    %edx,%eax
}
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    

000001f1 <strlen>:

uint
strlen(char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1fe:	eb 04                	jmp    204 <strlen+0x13>
 200:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 204:	8b 55 fc             	mov    -0x4(%ebp),%edx
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	01 d0                	add    %edx,%eax
 20c:	0f b6 00             	movzbl (%eax),%eax
 20f:	84 c0                	test   %al,%al
 211:	75 ed                	jne    200 <strlen+0xf>
    ;
  return n;
 213:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <memset>:

void*
memset(void *dst, int c, uint n)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 21b:	8b 45 10             	mov    0x10(%ebp),%eax
 21e:	50                   	push   %eax
 21f:	ff 75 0c             	pushl  0xc(%ebp)
 222:	ff 75 08             	pushl  0x8(%ebp)
 225:	e8 32 ff ff ff       	call   15c <stosb>
 22a:	83 c4 0c             	add    $0xc,%esp
  return dst;
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 230:	c9                   	leave  
 231:	c3                   	ret    

00000232 <strchr>:

char*
strchr(const char *s, char c)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	83 ec 04             	sub    $0x4,%esp
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 23e:	eb 14                	jmp    254 <strchr+0x22>
    if(*s == c)
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	3a 45 fc             	cmp    -0x4(%ebp),%al
 249:	75 05                	jne    250 <strchr+0x1e>
      return (char*)s;
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	eb 13                	jmp    263 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 250:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	0f b6 00             	movzbl (%eax),%eax
 25a:	84 c0                	test   %al,%al
 25c:	75 e2                	jne    240 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 25e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <gets>:

char*
gets(char *buf, int max)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 272:	eb 42                	jmp    2b6 <gets+0x51>
    cc = read(0, &c, 1);
 274:	83 ec 04             	sub    $0x4,%esp
 277:	6a 01                	push   $0x1
 279:	8d 45 ef             	lea    -0x11(%ebp),%eax
 27c:	50                   	push   %eax
 27d:	6a 00                	push   $0x0
 27f:	e8 47 01 00 00       	call   3cb <read>
 284:	83 c4 10             	add    $0x10,%esp
 287:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 28a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 28e:	7e 33                	jle    2c3 <gets+0x5e>
      break;
    buf[i++] = c;
 290:	8b 45 f4             	mov    -0xc(%ebp),%eax
 293:	8d 50 01             	lea    0x1(%eax),%edx
 296:	89 55 f4             	mov    %edx,-0xc(%ebp)
 299:	89 c2                	mov    %eax,%edx
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	01 c2                	add    %eax,%edx
 2a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2aa:	3c 0a                	cmp    $0xa,%al
 2ac:	74 16                	je     2c4 <gets+0x5f>
 2ae:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b2:	3c 0d                	cmp    $0xd,%al
 2b4:	74 0e                	je     2c4 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b9:	83 c0 01             	add    $0x1,%eax
 2bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2bf:	7c b3                	jl     274 <gets+0xf>
 2c1:	eb 01                	jmp    2c4 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2c3:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	01 d0                	add    %edx,%eax
 2cc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <stat>:

int
stat(char *n, struct stat *st)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2da:	83 ec 08             	sub    $0x8,%esp
 2dd:	6a 00                	push   $0x0
 2df:	ff 75 08             	pushl  0x8(%ebp)
 2e2:	e8 0c 01 00 00       	call   3f3 <open>
 2e7:	83 c4 10             	add    $0x10,%esp
 2ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f1:	79 07                	jns    2fa <stat+0x26>
    return -1;
 2f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f8:	eb 25                	jmp    31f <stat+0x4b>
  r = fstat(fd, st);
 2fa:	83 ec 08             	sub    $0x8,%esp
 2fd:	ff 75 0c             	pushl  0xc(%ebp)
 300:	ff 75 f4             	pushl  -0xc(%ebp)
 303:	e8 03 01 00 00       	call   40b <fstat>
 308:	83 c4 10             	add    $0x10,%esp
 30b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30e:	83 ec 0c             	sub    $0xc,%esp
 311:	ff 75 f4             	pushl  -0xc(%ebp)
 314:	e8 c2 00 00 00       	call   3db <close>
 319:	83 c4 10             	add    $0x10,%esp
  return r;
 31c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <atoi>:

int
atoi(const char *s)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 327:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32e:	eb 25                	jmp    355 <atoi+0x34>
    n = n*10 + *s++ - '0';
 330:	8b 55 fc             	mov    -0x4(%ebp),%edx
 333:	89 d0                	mov    %edx,%eax
 335:	c1 e0 02             	shl    $0x2,%eax
 338:	01 d0                	add    %edx,%eax
 33a:	01 c0                	add    %eax,%eax
 33c:	89 c1                	mov    %eax,%ecx
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	8d 50 01             	lea    0x1(%eax),%edx
 344:	89 55 08             	mov    %edx,0x8(%ebp)
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	0f be c0             	movsbl %al,%eax
 34d:	01 c8                	add    %ecx,%eax
 34f:	83 e8 30             	sub    $0x30,%eax
 352:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 2f                	cmp    $0x2f,%al
 35d:	7e 0a                	jle    369 <atoi+0x48>
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	0f b6 00             	movzbl (%eax),%eax
 365:	3c 39                	cmp    $0x39,%al
 367:	7e c7                	jle    330 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 369:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 36c:	c9                   	leave  
 36d:	c3                   	ret    

0000036e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp
 371:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 380:	eb 17                	jmp    399 <memmove+0x2b>
    *dst++ = *src++;
 382:	8b 45 fc             	mov    -0x4(%ebp),%eax
 385:	8d 50 01             	lea    0x1(%eax),%edx
 388:	89 55 fc             	mov    %edx,-0x4(%ebp)
 38b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38e:	8d 4a 01             	lea    0x1(%edx),%ecx
 391:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 394:	0f b6 12             	movzbl (%edx),%edx
 397:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 399:	8b 45 10             	mov    0x10(%ebp),%eax
 39c:	8d 50 ff             	lea    -0x1(%eax),%edx
 39f:	89 55 10             	mov    %edx,0x10(%ebp)
 3a2:	85 c0                	test   %eax,%eax
 3a4:	7f dc                	jg     382 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a9:	c9                   	leave  
 3aa:	c3                   	ret    

000003ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ab:	b8 01 00 00 00       	mov    $0x1,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <exit>:
SYSCALL(exit)
 3b3:	b8 02 00 00 00       	mov    $0x2,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <wait>:
SYSCALL(wait)
 3bb:	b8 03 00 00 00       	mov    $0x3,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <pipe>:
SYSCALL(pipe)
 3c3:	b8 04 00 00 00       	mov    $0x4,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <read>:
SYSCALL(read)
 3cb:	b8 05 00 00 00       	mov    $0x5,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <write>:
SYSCALL(write)
 3d3:	b8 10 00 00 00       	mov    $0x10,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <close>:
SYSCALL(close)
 3db:	b8 15 00 00 00       	mov    $0x15,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <kill>:
SYSCALL(kill)
 3e3:	b8 06 00 00 00       	mov    $0x6,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <exec>:
SYSCALL(exec)
 3eb:	b8 07 00 00 00       	mov    $0x7,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <open>:
SYSCALL(open)
 3f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <mknod>:
SYSCALL(mknod)
 3fb:	b8 11 00 00 00       	mov    $0x11,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <unlink>:
SYSCALL(unlink)
 403:	b8 12 00 00 00       	mov    $0x12,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <fstat>:
SYSCALL(fstat)
 40b:	b8 08 00 00 00       	mov    $0x8,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <link>:
SYSCALL(link)
 413:	b8 13 00 00 00       	mov    $0x13,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <mkdir>:
SYSCALL(mkdir)
 41b:	b8 14 00 00 00       	mov    $0x14,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <chdir>:
SYSCALL(chdir)
 423:	b8 09 00 00 00       	mov    $0x9,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <dup>:
SYSCALL(dup)
 42b:	b8 0a 00 00 00       	mov    $0xa,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <getpid>:
SYSCALL(getpid)
 433:	b8 0b 00 00 00       	mov    $0xb,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <sbrk>:
SYSCALL(sbrk)
 43b:	b8 0c 00 00 00       	mov    $0xc,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <sleep>:
SYSCALL(sleep)
 443:	b8 0d 00 00 00       	mov    $0xd,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <uptime>:
SYSCALL(uptime)
 44b:	b8 0e 00 00 00       	mov    $0xe,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <halt>:
SYSCALL(halt)
 453:	b8 16 00 00 00       	mov    $0x16,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <date>:
SYSCALL(date)      #p1
 45b:	b8 17 00 00 00       	mov    $0x17,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <getuid>:
SYSCALL(getuid)    #p2
 463:	b8 18 00 00 00       	mov    $0x18,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <getgid>:
SYSCALL(getgid)    #p2
 46b:	b8 19 00 00 00       	mov    $0x19,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <getppid>:
SYSCALL(getppid)   #p2
 473:	b8 1a 00 00 00       	mov    $0x1a,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <setuid>:
SYSCALL(setuid)    #p2
 47b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <setgid>:
SYSCALL(setgid)    #p2
 483:	b8 1c 00 00 00       	mov    $0x1c,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <getprocs>:
SYSCALL(getprocs)  #p2
 48b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 493:	55                   	push   %ebp
 494:	89 e5                	mov    %esp,%ebp
 496:	83 ec 18             	sub    $0x18,%esp
 499:	8b 45 0c             	mov    0xc(%ebp),%eax
 49c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 49f:	83 ec 04             	sub    $0x4,%esp
 4a2:	6a 01                	push   $0x1
 4a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a7:	50                   	push   %eax
 4a8:	ff 75 08             	pushl  0x8(%ebp)
 4ab:	e8 23 ff ff ff       	call   3d3 <write>
 4b0:	83 c4 10             	add    $0x10,%esp
}
 4b3:	90                   	nop
 4b4:	c9                   	leave  
 4b5:	c3                   	ret    

000004b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b6:	55                   	push   %ebp
 4b7:	89 e5                	mov    %esp,%ebp
 4b9:	53                   	push   %ebx
 4ba:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4c4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4c8:	74 17                	je     4e1 <printint+0x2b>
 4ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4ce:	79 11                	jns    4e1 <printint+0x2b>
    neg = 1;
 4d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4da:	f7 d8                	neg    %eax
 4dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4df:	eb 06                	jmp    4e7 <printint+0x31>
  } else {
    x = xx;
 4e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ee:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4f1:	8d 41 01             	lea    0x1(%ecx),%eax
 4f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fd:	ba 00 00 00 00       	mov    $0x0,%edx
 502:	f7 f3                	div    %ebx
 504:	89 d0                	mov    %edx,%eax
 506:	0f b6 80 4c 0c 00 00 	movzbl 0xc4c(%eax),%eax
 50d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 511:	8b 5d 10             	mov    0x10(%ebp),%ebx
 514:	8b 45 ec             	mov    -0x14(%ebp),%eax
 517:	ba 00 00 00 00       	mov    $0x0,%edx
 51c:	f7 f3                	div    %ebx
 51e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 521:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 525:	75 c7                	jne    4ee <printint+0x38>
  if(neg)
 527:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 52b:	74 2d                	je     55a <printint+0xa4>
    buf[i++] = '-';
 52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 530:	8d 50 01             	lea    0x1(%eax),%edx
 533:	89 55 f4             	mov    %edx,-0xc(%ebp)
 536:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 53b:	eb 1d                	jmp    55a <printint+0xa4>
    putc(fd, buf[i]);
 53d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 540:	8b 45 f4             	mov    -0xc(%ebp),%eax
 543:	01 d0                	add    %edx,%eax
 545:	0f b6 00             	movzbl (%eax),%eax
 548:	0f be c0             	movsbl %al,%eax
 54b:	83 ec 08             	sub    $0x8,%esp
 54e:	50                   	push   %eax
 54f:	ff 75 08             	pushl  0x8(%ebp)
 552:	e8 3c ff ff ff       	call   493 <putc>
 557:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 55a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 55e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 562:	79 d9                	jns    53d <printint+0x87>
    putc(fd, buf[i]);
}
 564:	90                   	nop
 565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 568:	c9                   	leave  
 569:	c3                   	ret    

0000056a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 56a:	55                   	push   %ebp
 56b:	89 e5                	mov    %esp,%ebp
 56d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 570:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 577:	8d 45 0c             	lea    0xc(%ebp),%eax
 57a:	83 c0 04             	add    $0x4,%eax
 57d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 580:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 587:	e9 59 01 00 00       	jmp    6e5 <printf+0x17b>
    c = fmt[i] & 0xff;
 58c:	8b 55 0c             	mov    0xc(%ebp),%edx
 58f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 592:	01 d0                	add    %edx,%eax
 594:	0f b6 00             	movzbl (%eax),%eax
 597:	0f be c0             	movsbl %al,%eax
 59a:	25 ff 00 00 00       	and    $0xff,%eax
 59f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a6:	75 2c                	jne    5d4 <printf+0x6a>
      if(c == '%'){
 5a8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ac:	75 0c                	jne    5ba <printf+0x50>
        state = '%';
 5ae:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5b5:	e9 27 01 00 00       	jmp    6e1 <printf+0x177>
      } else {
        putc(fd, c);
 5ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	pushl  0x8(%ebp)
 5c7:	e8 c7 fe ff ff       	call   493 <putc>
 5cc:	83 c4 10             	add    $0x10,%esp
 5cf:	e9 0d 01 00 00       	jmp    6e1 <printf+0x177>
      }
    } else if(state == '%'){
 5d4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d8:	0f 85 03 01 00 00    	jne    6e1 <printf+0x177>
      if(c == 'd'){
 5de:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5e2:	75 1e                	jne    602 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e7:	8b 00                	mov    (%eax),%eax
 5e9:	6a 01                	push   $0x1
 5eb:	6a 0a                	push   $0xa
 5ed:	50                   	push   %eax
 5ee:	ff 75 08             	pushl  0x8(%ebp)
 5f1:	e8 c0 fe ff ff       	call   4b6 <printint>
 5f6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fd:	e9 d8 00 00 00       	jmp    6da <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 602:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 606:	74 06                	je     60e <printf+0xa4>
 608:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 60c:	75 1e                	jne    62c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 60e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	6a 00                	push   $0x0
 615:	6a 10                	push   $0x10
 617:	50                   	push   %eax
 618:	ff 75 08             	pushl  0x8(%ebp)
 61b:	e8 96 fe ff ff       	call   4b6 <printint>
 620:	83 c4 10             	add    $0x10,%esp
        ap++;
 623:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 627:	e9 ae 00 00 00       	jmp    6da <printf+0x170>
      } else if(c == 's'){
 62c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 630:	75 43                	jne    675 <printf+0x10b>
        s = (char*)*ap;
 632:	8b 45 e8             	mov    -0x18(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 63a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 63e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 642:	75 25                	jne    669 <printf+0xff>
          s = "(null)";
 644:	c7 45 f4 dd 09 00 00 	movl   $0x9dd,-0xc(%ebp)
        while(*s != 0){
 64b:	eb 1c                	jmp    669 <printf+0xff>
          putc(fd, *s);
 64d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 650:	0f b6 00             	movzbl (%eax),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	83 ec 08             	sub    $0x8,%esp
 659:	50                   	push   %eax
 65a:	ff 75 08             	pushl  0x8(%ebp)
 65d:	e8 31 fe ff ff       	call   493 <putc>
 662:	83 c4 10             	add    $0x10,%esp
          s++;
 665:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 669:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66c:	0f b6 00             	movzbl (%eax),%eax
 66f:	84 c0                	test   %al,%al
 671:	75 da                	jne    64d <printf+0xe3>
 673:	eb 65                	jmp    6da <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 675:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 679:	75 1d                	jne    698 <printf+0x12e>
        putc(fd, *ap);
 67b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	0f be c0             	movsbl %al,%eax
 683:	83 ec 08             	sub    $0x8,%esp
 686:	50                   	push   %eax
 687:	ff 75 08             	pushl  0x8(%ebp)
 68a:	e8 04 fe ff ff       	call   493 <putc>
 68f:	83 c4 10             	add    $0x10,%esp
        ap++;
 692:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 696:	eb 42                	jmp    6da <printf+0x170>
      } else if(c == '%'){
 698:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 69c:	75 17                	jne    6b5 <printf+0x14b>
        putc(fd, c);
 69e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a1:	0f be c0             	movsbl %al,%eax
 6a4:	83 ec 08             	sub    $0x8,%esp
 6a7:	50                   	push   %eax
 6a8:	ff 75 08             	pushl  0x8(%ebp)
 6ab:	e8 e3 fd ff ff       	call   493 <putc>
 6b0:	83 c4 10             	add    $0x10,%esp
 6b3:	eb 25                	jmp    6da <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6b5:	83 ec 08             	sub    $0x8,%esp
 6b8:	6a 25                	push   $0x25
 6ba:	ff 75 08             	pushl  0x8(%ebp)
 6bd:	e8 d1 fd ff ff       	call   493 <putc>
 6c2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c8:	0f be c0             	movsbl %al,%eax
 6cb:	83 ec 08             	sub    $0x8,%esp
 6ce:	50                   	push   %eax
 6cf:	ff 75 08             	pushl  0x8(%ebp)
 6d2:	e8 bc fd ff ff       	call   493 <putc>
 6d7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6e5:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6eb:	01 d0                	add    %edx,%eax
 6ed:	0f b6 00             	movzbl (%eax),%eax
 6f0:	84 c0                	test   %al,%al
 6f2:	0f 85 94 fe ff ff    	jne    58c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f8:	90                   	nop
 6f9:	c9                   	leave  
 6fa:	c3                   	ret    

000006fb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fb:	55                   	push   %ebp
 6fc:	89 e5                	mov    %esp,%ebp
 6fe:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 701:	8b 45 08             	mov    0x8(%ebp),%eax
 704:	83 e8 08             	sub    $0x8,%eax
 707:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70a:	a1 68 0c 00 00       	mov    0xc68,%eax
 70f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 712:	eb 24                	jmp    738 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 00                	mov    (%eax),%eax
 719:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71c:	77 12                	ja     730 <free+0x35>
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 724:	77 24                	ja     74a <free+0x4f>
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	8b 00                	mov    (%eax),%eax
 72b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72e:	77 1a                	ja     74a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	89 45 fc             	mov    %eax,-0x4(%ebp)
 738:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73e:	76 d4                	jbe    714 <free+0x19>
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 00                	mov    (%eax),%eax
 745:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 748:	76 ca                	jbe    714 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	8b 40 04             	mov    0x4(%eax),%eax
 750:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	01 c2                	add    %eax,%edx
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	39 c2                	cmp    %eax,%edx
 763:	75 24                	jne    789 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	8b 50 04             	mov    0x4(%eax),%edx
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	8b 00                	mov    (%eax),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	01 c2                	add    %eax,%edx
 775:	8b 45 f8             	mov    -0x8(%ebp),%eax
 778:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	8b 10                	mov    (%eax),%edx
 782:	8b 45 f8             	mov    -0x8(%ebp),%eax
 785:	89 10                	mov    %edx,(%eax)
 787:	eb 0a                	jmp    793 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 10                	mov    (%eax),%edx
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 40 04             	mov    0x4(%eax),%eax
 799:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a3:	01 d0                	add    %edx,%eax
 7a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a8:	75 20                	jne    7ca <free+0xcf>
    p->s.size += bp->s.size;
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 50 04             	mov    0x4(%eax),%edx
 7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b3:	8b 40 04             	mov    0x4(%eax),%eax
 7b6:	01 c2                	add    %eax,%edx
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	8b 10                	mov    (%eax),%edx
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	89 10                	mov    %edx,(%eax)
 7c8:	eb 08                	jmp    7d2 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7d0:	89 10                	mov    %edx,(%eax)
  freep = p;
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 7da:	90                   	nop
 7db:	c9                   	leave  
 7dc:	c3                   	ret    

000007dd <morecore>:

static Header*
morecore(uint nu)
{
 7dd:	55                   	push   %ebp
 7de:	89 e5                	mov    %esp,%ebp
 7e0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7e3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ea:	77 07                	ja     7f3 <morecore+0x16>
    nu = 4096;
 7ec:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7f3:	8b 45 08             	mov    0x8(%ebp),%eax
 7f6:	c1 e0 03             	shl    $0x3,%eax
 7f9:	83 ec 0c             	sub    $0xc,%esp
 7fc:	50                   	push   %eax
 7fd:	e8 39 fc ff ff       	call   43b <sbrk>
 802:	83 c4 10             	add    $0x10,%esp
 805:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 808:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 80c:	75 07                	jne    815 <morecore+0x38>
    return 0;
 80e:	b8 00 00 00 00       	mov    $0x0,%eax
 813:	eb 26                	jmp    83b <morecore+0x5e>
  hp = (Header*)p;
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 81b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81e:	8b 55 08             	mov    0x8(%ebp),%edx
 821:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	83 c0 08             	add    $0x8,%eax
 82a:	83 ec 0c             	sub    $0xc,%esp
 82d:	50                   	push   %eax
 82e:	e8 c8 fe ff ff       	call   6fb <free>
 833:	83 c4 10             	add    $0x10,%esp
  return freep;
 836:	a1 68 0c 00 00       	mov    0xc68,%eax
}
 83b:	c9                   	leave  
 83c:	c3                   	ret    

0000083d <malloc>:

void*
malloc(uint nbytes)
{
 83d:	55                   	push   %ebp
 83e:	89 e5                	mov    %esp,%ebp
 840:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 843:	8b 45 08             	mov    0x8(%ebp),%eax
 846:	83 c0 07             	add    $0x7,%eax
 849:	c1 e8 03             	shr    $0x3,%eax
 84c:	83 c0 01             	add    $0x1,%eax
 84f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 852:	a1 68 0c 00 00       	mov    0xc68,%eax
 857:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 85e:	75 23                	jne    883 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 860:	c7 45 f0 60 0c 00 00 	movl   $0xc60,-0x10(%ebp)
 867:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86a:	a3 68 0c 00 00       	mov    %eax,0xc68
 86f:	a1 68 0c 00 00       	mov    0xc68,%eax
 874:	a3 60 0c 00 00       	mov    %eax,0xc60
    base.s.size = 0;
 879:	c7 05 64 0c 00 00 00 	movl   $0x0,0xc64
 880:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 883:	8b 45 f0             	mov    -0x10(%ebp),%eax
 886:	8b 00                	mov    (%eax),%eax
 888:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	8b 40 04             	mov    0x4(%eax),%eax
 891:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 894:	72 4d                	jb     8e3 <malloc+0xa6>
      if(p->s.size == nunits)
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	8b 40 04             	mov    0x4(%eax),%eax
 89c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89f:	75 0c                	jne    8ad <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	8b 10                	mov    (%eax),%edx
 8a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a9:	89 10                	mov    %edx,(%eax)
 8ab:	eb 26                	jmp    8d3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	8b 40 04             	mov    0x4(%eax),%eax
 8b3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8b6:	89 c2                	mov    %eax,%edx
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	8b 40 04             	mov    0x4(%eax),%eax
 8c4:	c1 e0 03             	shl    $0x3,%eax
 8c7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8d0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d6:	a3 68 0c 00 00       	mov    %eax,0xc68
      return (void*)(p + 1);
 8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8de:	83 c0 08             	add    $0x8,%eax
 8e1:	eb 3b                	jmp    91e <malloc+0xe1>
    }
    if(p == freep)
 8e3:	a1 68 0c 00 00       	mov    0xc68,%eax
 8e8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8eb:	75 1e                	jne    90b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8ed:	83 ec 0c             	sub    $0xc,%esp
 8f0:	ff 75 ec             	pushl  -0x14(%ebp)
 8f3:	e8 e5 fe ff ff       	call   7dd <morecore>
 8f8:	83 c4 10             	add    $0x10,%esp
 8fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 902:	75 07                	jne    90b <malloc+0xce>
        return 0;
 904:	b8 00 00 00 00       	mov    $0x0,%eax
 909:	eb 13                	jmp    91e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	8b 00                	mov    (%eax),%eax
 916:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 919:	e9 6d ff ff ff       	jmp    88b <malloc+0x4e>
}
 91e:	c9                   	leave  
 91f:	c3                   	ret    
