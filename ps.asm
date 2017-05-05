
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "uproc.h"
#include "user.h"
#define MAX 64

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
  17:	68 00 17 00 00       	push   $0x1700
  1c:	e8 33 09 00 00       	call   954 <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if (!table) 
  27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  2b:	75 17                	jne    44 <main+0x44>
  {
    printf(2, "Error. Malloc call failed.");
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	68 38 0a 00 00       	push   $0xa38
  35:	6a 02                	push   $0x2
  37:	e8 45 06 00 00       	call   681 <printf>
  3c:	83 c4 10             	add    $0x10,%esp
    exit();
  3f:	e8 86 04 00 00       	call   4ca <exit>
  }
 
  printf(1, "Max value: %d\n", MAX); 
  44:	83 ec 04             	sub    $0x4,%esp
  47:	6a 40                	push   $0x40
  49:	68 53 0a 00 00       	push   $0xa53
  4e:	6a 01                	push   $0x1
  50:	e8 2c 06 00 00       	call   681 <printf>
  55:	83 c4 10             	add    $0x10,%esp
  int status = getprocs(MAX, table);
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	ff 75 e0             	pushl  -0x20(%ebp)
  5e:	6a 40                	push   $0x40
  60:	e8 3d 05 00 00       	call   5a2 <getprocs>
  65:	83 c4 10             	add    $0x10,%esp
  68:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (status < 0)
  6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  6f:	79 17                	jns    88 <main+0x88>
    printf(2, "Error. Not enough memory for the table.\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 64 0a 00 00       	push   $0xa64
  79:	6a 02                	push   $0x2
  7b:	e8 01 06 00 00       	call   681 <printf>
  80:	83 c4 10             	add    $0x10,%esp
  83:	e9 a1 01 00 00       	jmp    229 <main+0x229>
  else
  {
    printf(1, "PID\t Name\t UID\t GID\t PPID\t Elapsed  CPU\t State\t Size\n");
  88:	83 ec 08             	sub    $0x8,%esp
  8b:	68 90 0a 00 00       	push   $0xa90
  90:	6a 01                	push   $0x1
  92:	e8 ea 05 00 00       	call   681 <printf>
  97:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < status; ++i)
  9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  a1:	e9 77 01 00 00       	jmp    21d <main+0x21d>
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
  a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  a9:	6b d0 5c             	imul   $0x5c,%eax,%edx
  ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  af:	01 d0                	add    %edx,%eax
  b1:	8b 40 10             	mov    0x10(%eax),%eax
  b4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  b9:	f7 e2                	mul    %edx
  bb:	89 d0                	mov    %edx,%eax
  bd:	c1 e8 05             	shr    $0x5,%eax
  c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
  c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  c6:	6b d0 5c             	imul   $0x5c,%eax,%edx
  c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  cc:	01 d0                	add    %edx,%eax
  ce:	8b 48 10             	mov    0x10(%eax),%ecx
  d1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  d6:	89 c8                	mov    %ecx,%eax
  d8:	f7 e2                	mul    %edx
  da:	89 d0                	mov    %edx,%eax
  dc:	c1 e8 05             	shr    $0x5,%eax
  df:	6b c0 64             	imul   $0x64,%eax,%eax
  e2:	29 c1                	sub    %eax,%ecx
  e4:	89 c8                	mov    %ecx,%eax
  e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      int total_cpu_secs = table[i].CPU_total_ticks/100;
  e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ec:	6b d0 5c             	imul   $0x5c,%eax,%edx
  ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  f2:	01 d0                	add    %edx,%eax
  f4:	8b 40 14             	mov    0x14(%eax),%eax
  f7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  fc:	f7 e2                	mul    %edx
  fe:	89 d0                	mov    %edx,%eax
 100:	c1 e8 05             	shr    $0x5,%eax
 103:	89 45 d0             	mov    %eax,-0x30(%ebp)
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
 106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 109:	6b d0 5c             	imul   $0x5c,%eax,%edx
 10c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 10f:	01 d0                	add    %edx,%eax
 111:	8b 48 14             	mov    0x14(%eax),%ecx
 114:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 119:	89 c8                	mov    %ecx,%eax
 11b:	f7 e2                	mul    %edx
 11d:	89 d0                	mov    %edx,%eax
 11f:	c1 e8 05             	shr    $0x5,%eax
 122:	6b c0 64             	imul   $0x64,%eax,%eax
 125:	29 c1                	sub    %eax,%ecx
 127:	89 c8                	mov    %ecx,%eax
 129:	89 45 cc             	mov    %eax,-0x34(%ebp)
      printf(1, "%d\t %s\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
            table[i].gid, table[i].ppid);
 12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12f:	6b d0 5c             	imul   $0x5c,%eax,%edx
 132:	8b 45 e0             	mov    -0x20(%ebp),%eax
 135:	01 d0                	add    %edx,%eax
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%d\t %s\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
 137:	8b 58 0c             	mov    0xc(%eax),%ebx
            table[i].gid, table[i].ppid);
 13a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 13d:	6b d0 5c             	imul   $0x5c,%eax,%edx
 140:	8b 45 e0             	mov    -0x20(%ebp),%eax
 143:	01 d0                	add    %edx,%eax
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%d\t %s\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
 145:	8b 48 08             	mov    0x8(%eax),%ecx
 148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 14b:	6b d0 5c             	imul   $0x5c,%eax,%edx
 14e:	8b 45 e0             	mov    -0x20(%ebp),%eax
 151:	01 d0                	add    %edx,%eax
 153:	8b 50 04             	mov    0x4(%eax),%edx
 156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 159:	6b f0 5c             	imul   $0x5c,%eax,%esi
 15c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 15f:	01 f0                	add    %esi,%eax
 161:	8d 70 3c             	lea    0x3c(%eax),%esi
 164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 167:	6b f8 5c             	imul   $0x5c,%eax,%edi
 16a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 16d:	01 f8                	add    %edi,%eax
 16f:	8b 00                	mov    (%eax),%eax
 171:	83 ec 04             	sub    $0x4,%esp
 174:	53                   	push   %ebx
 175:	51                   	push   %ecx
 176:	52                   	push   %edx
 177:	56                   	push   %esi
 178:	50                   	push   %eax
 179:	68 c6 0a 00 00       	push   $0xac6
 17e:	6a 01                	push   $0x1
 180:	e8 fc 04 00 00       	call   681 <printf>
 185:	83 c4 20             	add    $0x20,%esp
            table[i].gid, table[i].ppid);
    
      if (partial_elapsed_secs < 10)
 188:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
 18c:	7f 17                	jg     1a5 <main+0x1a5>
        printf(1, " %d.0%d", elapsed_secs, partial_elapsed_secs);
 18e:	ff 75 d4             	pushl  -0x2c(%ebp)
 191:	ff 75 d8             	pushl  -0x28(%ebp)
 194:	68 da 0a 00 00       	push   $0xada
 199:	6a 01                	push   $0x1
 19b:	e8 e1 04 00 00       	call   681 <printf>
 1a0:	83 c4 10             	add    $0x10,%esp
 1a3:	eb 15                	jmp    1ba <main+0x1ba>
      else
        printf(1, " %d.%d", elapsed_secs, partial_elapsed_secs);
 1a5:	ff 75 d4             	pushl  -0x2c(%ebp)
 1a8:	ff 75 d8             	pushl  -0x28(%ebp)
 1ab:	68 e2 0a 00 00       	push   $0xae2
 1b0:	6a 01                	push   $0x1
 1b2:	e8 ca 04 00 00       	call   681 <printf>
 1b7:	83 c4 10             	add    $0x10,%esp

      if (partial_cpu_secs < 10)
 1ba:	83 7d cc 09          	cmpl   $0x9,-0x34(%ebp)
 1be:	7f 17                	jg     1d7 <main+0x1d7>
        printf(1, "     %d.0%d\t", total_cpu_secs, partial_cpu_secs);
 1c0:	ff 75 cc             	pushl  -0x34(%ebp)
 1c3:	ff 75 d0             	pushl  -0x30(%ebp)
 1c6:	68 e9 0a 00 00       	push   $0xae9
 1cb:	6a 01                	push   $0x1
 1cd:	e8 af 04 00 00       	call   681 <printf>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	eb 15                	jmp    1ec <main+0x1ec>
      else
        printf(1, "     %d.%d\t", total_cpu_secs, partial_cpu_secs);
 1d7:	ff 75 cc             	pushl  -0x34(%ebp)
 1da:	ff 75 d0             	pushl  -0x30(%ebp)
 1dd:	68 f6 0a 00 00       	push   $0xaf6
 1e2:	6a 01                	push   $0x1
 1e4:	e8 98 04 00 00       	call   681 <printf>
 1e9:	83 c4 10             	add    $0x10,%esp

      printf(1, " %s\t %d\n", table[i].state, table[i].size);
 1ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1ef:	6b d0 5c             	imul   $0x5c,%eax,%edx
 1f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f5:	01 d0                	add    %edx,%eax
 1f7:	8b 40 38             	mov    0x38(%eax),%eax
 1fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1fd:	6b ca 5c             	imul   $0x5c,%edx,%ecx
 200:	8b 55 e0             	mov    -0x20(%ebp),%edx
 203:	01 ca                	add    %ecx,%edx
 205:	83 c2 18             	add    $0x18,%edx
 208:	50                   	push   %eax
 209:	52                   	push   %edx
 20a:	68 02 0b 00 00       	push   $0xb02
 20f:	6a 01                	push   $0x1
 211:	e8 6b 04 00 00       	call   681 <printf>
 216:	83 c4 10             	add    $0x10,%esp
  if (status < 0)
    printf(2, "Error. Not enough memory for the table.\n");
  else
  {
    printf(1, "PID\t Name\t UID\t GID\t PPID\t Elapsed  CPU\t State\t Size\n");
    for (int i = 0; i < status; ++i)
 219:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 21d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 220:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 223:	0f 8c 7d fe ff ff    	jl     a6 <main+0xa6>
        printf(1, "     %d.%d\t", total_cpu_secs, partial_cpu_secs);

      printf(1, " %s\t %d\n", table[i].state, table[i].size);
    }
  }
  exit();
 229:	e8 9c 02 00 00       	call   4ca <exit>

0000022e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	57                   	push   %edi
 232:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 233:	8b 4d 08             	mov    0x8(%ebp),%ecx
 236:	8b 55 10             	mov    0x10(%ebp),%edx
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	89 cb                	mov    %ecx,%ebx
 23e:	89 df                	mov    %ebx,%edi
 240:	89 d1                	mov    %edx,%ecx
 242:	fc                   	cld    
 243:	f3 aa                	rep stos %al,%es:(%edi)
 245:	89 ca                	mov    %ecx,%edx
 247:	89 fb                	mov    %edi,%ebx
 249:	89 5d 08             	mov    %ebx,0x8(%ebp)
 24c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 24f:	90                   	nop
 250:	5b                   	pop    %ebx
 251:	5f                   	pop    %edi
 252:	5d                   	pop    %ebp
 253:	c3                   	ret    

00000254 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 260:	90                   	nop
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	8d 50 01             	lea    0x1(%eax),%edx
 267:	89 55 08             	mov    %edx,0x8(%ebp)
 26a:	8b 55 0c             	mov    0xc(%ebp),%edx
 26d:	8d 4a 01             	lea    0x1(%edx),%ecx
 270:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 273:	0f b6 12             	movzbl (%edx),%edx
 276:	88 10                	mov    %dl,(%eax)
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	84 c0                	test   %al,%al
 27d:	75 e2                	jne    261 <strcpy+0xd>
    ;
  return os;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 287:	eb 08                	jmp    291 <strcmp+0xd>
    p++, q++;
 289:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 28d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	84 c0                	test   %al,%al
 299:	74 10                	je     2ab <strcmp+0x27>
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	0f b6 10             	movzbl (%eax),%edx
 2a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	38 c2                	cmp    %al,%dl
 2a9:	74 de                	je     289 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	0f b6 00             	movzbl (%eax),%eax
 2b1:	0f b6 d0             	movzbl %al,%edx
 2b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	0f b6 c0             	movzbl %al,%eax
 2bd:	29 c2                	sub    %eax,%edx
 2bf:	89 d0                	mov    %edx,%eax
}
 2c1:	5d                   	pop    %ebp
 2c2:	c3                   	ret    

000002c3 <strlen>:

uint
strlen(char *s)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2d0:	eb 04                	jmp    2d6 <strlen+0x13>
 2d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	01 d0                	add    %edx,%eax
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	84 c0                	test   %al,%al
 2e3:	75 ed                	jne    2d2 <strlen+0xf>
    ;
  return n;
 2e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e8:	c9                   	leave  
 2e9:	c3                   	ret    

000002ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2ed:	8b 45 10             	mov    0x10(%ebp),%eax
 2f0:	50                   	push   %eax
 2f1:	ff 75 0c             	pushl  0xc(%ebp)
 2f4:	ff 75 08             	pushl  0x8(%ebp)
 2f7:	e8 32 ff ff ff       	call   22e <stosb>
 2fc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
 302:	c9                   	leave  
 303:	c3                   	ret    

00000304 <strchr>:

char*
strchr(const char *s, char c)
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 ec 04             	sub    $0x4,%esp
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 310:	eb 14                	jmp    326 <strchr+0x22>
    if(*s == c)
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	3a 45 fc             	cmp    -0x4(%ebp),%al
 31b:	75 05                	jne    322 <strchr+0x1e>
      return (char*)s;
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	eb 13                	jmp    335 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 322:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	0f b6 00             	movzbl (%eax),%eax
 32c:	84 c0                	test   %al,%al
 32e:	75 e2                	jne    312 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 330:	b8 00 00 00 00       	mov    $0x0,%eax
}
 335:	c9                   	leave  
 336:	c3                   	ret    

00000337 <gets>:

char*
gets(char *buf, int max)
{
 337:	55                   	push   %ebp
 338:	89 e5                	mov    %esp,%ebp
 33a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 344:	eb 42                	jmp    388 <gets+0x51>
    cc = read(0, &c, 1);
 346:	83 ec 04             	sub    $0x4,%esp
 349:	6a 01                	push   $0x1
 34b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 34e:	50                   	push   %eax
 34f:	6a 00                	push   $0x0
 351:	e8 8c 01 00 00       	call   4e2 <read>
 356:	83 c4 10             	add    $0x10,%esp
 359:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 35c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 360:	7e 33                	jle    395 <gets+0x5e>
      break;
    buf[i++] = c;
 362:	8b 45 f4             	mov    -0xc(%ebp),%eax
 365:	8d 50 01             	lea    0x1(%eax),%edx
 368:	89 55 f4             	mov    %edx,-0xc(%ebp)
 36b:	89 c2                	mov    %eax,%edx
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	01 c2                	add    %eax,%edx
 372:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 376:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 378:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 37c:	3c 0a                	cmp    $0xa,%al
 37e:	74 16                	je     396 <gets+0x5f>
 380:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 384:	3c 0d                	cmp    $0xd,%al
 386:	74 0e                	je     396 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 388:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38b:	83 c0 01             	add    $0x1,%eax
 38e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 391:	7c b3                	jl     346 <gets+0xf>
 393:	eb 01                	jmp    396 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 395:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 396:	8b 55 f4             	mov    -0xc(%ebp),%edx
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	01 d0                	add    %edx,%eax
 39e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a4:	c9                   	leave  
 3a5:	c3                   	ret    

000003a6 <stat>:

int
stat(char *n, struct stat *st)
{
 3a6:	55                   	push   %ebp
 3a7:	89 e5                	mov    %esp,%ebp
 3a9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ac:	83 ec 08             	sub    $0x8,%esp
 3af:	6a 00                	push   $0x0
 3b1:	ff 75 08             	pushl  0x8(%ebp)
 3b4:	e8 51 01 00 00       	call   50a <open>
 3b9:	83 c4 10             	add    $0x10,%esp
 3bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3c3:	79 07                	jns    3cc <stat+0x26>
    return -1;
 3c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ca:	eb 25                	jmp    3f1 <stat+0x4b>
  r = fstat(fd, st);
 3cc:	83 ec 08             	sub    $0x8,%esp
 3cf:	ff 75 0c             	pushl  0xc(%ebp)
 3d2:	ff 75 f4             	pushl  -0xc(%ebp)
 3d5:	e8 48 01 00 00       	call   522 <fstat>
 3da:	83 c4 10             	add    $0x10,%esp
 3dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3e0:	83 ec 0c             	sub    $0xc,%esp
 3e3:	ff 75 f4             	pushl  -0xc(%ebp)
 3e6:	e8 07 01 00 00       	call   4f2 <close>
 3eb:	83 c4 10             	add    $0x10,%esp
  return r;
 3ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3f1:	c9                   	leave  
 3f2:	c3                   	ret    

000003f3 <atoi>:

int
atoi(const char *s)
{
 3f3:	55                   	push   %ebp
 3f4:	89 e5                	mov    %esp,%ebp
 3f6:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 400:	eb 04                	jmp    406 <atoi+0x13>
 402:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	0f b6 00             	movzbl (%eax),%eax
 40c:	3c 20                	cmp    $0x20,%al
 40e:	74 f2                	je     402 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	0f b6 00             	movzbl (%eax),%eax
 416:	3c 2d                	cmp    $0x2d,%al
 418:	75 07                	jne    421 <atoi+0x2e>
 41a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 41f:	eb 05                	jmp    426 <atoi+0x33>
 421:	b8 01 00 00 00       	mov    $0x1,%eax
 426:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 429:	8b 45 08             	mov    0x8(%ebp),%eax
 42c:	0f b6 00             	movzbl (%eax),%eax
 42f:	3c 2b                	cmp    $0x2b,%al
 431:	74 0a                	je     43d <atoi+0x4a>
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	0f b6 00             	movzbl (%eax),%eax
 439:	3c 2d                	cmp    $0x2d,%al
 43b:	75 2b                	jne    468 <atoi+0x75>
    s++;
 43d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 441:	eb 25                	jmp    468 <atoi+0x75>
    n = n*10 + *s++ - '0';
 443:	8b 55 fc             	mov    -0x4(%ebp),%edx
 446:	89 d0                	mov    %edx,%eax
 448:	c1 e0 02             	shl    $0x2,%eax
 44b:	01 d0                	add    %edx,%eax
 44d:	01 c0                	add    %eax,%eax
 44f:	89 c1                	mov    %eax,%ecx
 451:	8b 45 08             	mov    0x8(%ebp),%eax
 454:	8d 50 01             	lea    0x1(%eax),%edx
 457:	89 55 08             	mov    %edx,0x8(%ebp)
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	0f be c0             	movsbl %al,%eax
 460:	01 c8                	add    %ecx,%eax
 462:	83 e8 30             	sub    $0x30,%eax
 465:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	0f b6 00             	movzbl (%eax),%eax
 46e:	3c 2f                	cmp    $0x2f,%al
 470:	7e 0a                	jle    47c <atoi+0x89>
 472:	8b 45 08             	mov    0x8(%ebp),%eax
 475:	0f b6 00             	movzbl (%eax),%eax
 478:	3c 39                	cmp    $0x39,%al
 47a:	7e c7                	jle    443 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 47c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 47f:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 483:	c9                   	leave  
 484:	c3                   	ret    

00000485 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 485:	55                   	push   %ebp
 486:	89 e5                	mov    %esp,%ebp
 488:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 491:	8b 45 0c             	mov    0xc(%ebp),%eax
 494:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 497:	eb 17                	jmp    4b0 <memmove+0x2b>
    *dst++ = *src++;
 499:	8b 45 fc             	mov    -0x4(%ebp),%eax
 49c:	8d 50 01             	lea    0x1(%eax),%edx
 49f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4a5:	8d 4a 01             	lea    0x1(%edx),%ecx
 4a8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4ab:	0f b6 12             	movzbl (%edx),%edx
 4ae:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4b0:	8b 45 10             	mov    0x10(%ebp),%eax
 4b3:	8d 50 ff             	lea    -0x1(%eax),%edx
 4b6:	89 55 10             	mov    %edx,0x10(%ebp)
 4b9:	85 c0                	test   %eax,%eax
 4bb:	7f dc                	jg     499 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4c0:	c9                   	leave  
 4c1:	c3                   	ret    

000004c2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4c2:	b8 01 00 00 00       	mov    $0x1,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <exit>:
SYSCALL(exit)
 4ca:	b8 02 00 00 00       	mov    $0x2,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <wait>:
SYSCALL(wait)
 4d2:	b8 03 00 00 00       	mov    $0x3,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <pipe>:
SYSCALL(pipe)
 4da:	b8 04 00 00 00       	mov    $0x4,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <read>:
SYSCALL(read)
 4e2:	b8 05 00 00 00       	mov    $0x5,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <write>:
SYSCALL(write)
 4ea:	b8 10 00 00 00       	mov    $0x10,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <close>:
SYSCALL(close)
 4f2:	b8 15 00 00 00       	mov    $0x15,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <kill>:
SYSCALL(kill)
 4fa:	b8 06 00 00 00       	mov    $0x6,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <exec>:
SYSCALL(exec)
 502:	b8 07 00 00 00       	mov    $0x7,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <open>:
SYSCALL(open)
 50a:	b8 0f 00 00 00       	mov    $0xf,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <mknod>:
SYSCALL(mknod)
 512:	b8 11 00 00 00       	mov    $0x11,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <unlink>:
SYSCALL(unlink)
 51a:	b8 12 00 00 00       	mov    $0x12,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <fstat>:
SYSCALL(fstat)
 522:	b8 08 00 00 00       	mov    $0x8,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <link>:
SYSCALL(link)
 52a:	b8 13 00 00 00       	mov    $0x13,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <mkdir>:
SYSCALL(mkdir)
 532:	b8 14 00 00 00       	mov    $0x14,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <chdir>:
SYSCALL(chdir)
 53a:	b8 09 00 00 00       	mov    $0x9,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <dup>:
SYSCALL(dup)
 542:	b8 0a 00 00 00       	mov    $0xa,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <getpid>:
SYSCALL(getpid)
 54a:	b8 0b 00 00 00       	mov    $0xb,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <sbrk>:
SYSCALL(sbrk)
 552:	b8 0c 00 00 00       	mov    $0xc,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <sleep>:
SYSCALL(sleep)
 55a:	b8 0d 00 00 00       	mov    $0xd,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <uptime>:
SYSCALL(uptime)
 562:	b8 0e 00 00 00       	mov    $0xe,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <halt>:
SYSCALL(halt)
 56a:	b8 16 00 00 00       	mov    $0x16,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <date>:
SYSCALL(date)      #p1
 572:	b8 17 00 00 00       	mov    $0x17,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <getuid>:
SYSCALL(getuid)    #p2
 57a:	b8 18 00 00 00       	mov    $0x18,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <getgid>:
SYSCALL(getgid)    #p2
 582:	b8 19 00 00 00       	mov    $0x19,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <getppid>:
SYSCALL(getppid)   #p2
 58a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <setuid>:
SYSCALL(setuid)    #p2
 592:	b8 1b 00 00 00       	mov    $0x1b,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <setgid>:
SYSCALL(setgid)    #p2
 59a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <getprocs>:
SYSCALL(getprocs)  #p2
 5a2:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5aa:	55                   	push   %ebp
 5ab:	89 e5                	mov    %esp,%ebp
 5ad:	83 ec 18             	sub    $0x18,%esp
 5b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5b6:	83 ec 04             	sub    $0x4,%esp
 5b9:	6a 01                	push   $0x1
 5bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 23 ff ff ff       	call   4ea <write>
 5c7:	83 c4 10             	add    $0x10,%esp
}
 5ca:	90                   	nop
 5cb:	c9                   	leave  
 5cc:	c3                   	ret    

000005cd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5cd:	55                   	push   %ebp
 5ce:	89 e5                	mov    %esp,%ebp
 5d0:	53                   	push   %ebx
 5d1:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5db:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5df:	74 17                	je     5f8 <printint+0x2b>
 5e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5e5:	79 11                	jns    5f8 <printint+0x2b>
    neg = 1;
 5e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f1:	f7 d8                	neg    %eax
 5f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5f6:	eb 06                	jmp    5fe <printint+0x31>
  } else {
    x = xx;
 5f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 605:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 608:	8d 41 01             	lea    0x1(%ecx),%eax
 60b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 60e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 611:	8b 45 ec             	mov    -0x14(%ebp),%eax
 614:	ba 00 00 00 00       	mov    $0x0,%edx
 619:	f7 f3                	div    %ebx
 61b:	89 d0                	mov    %edx,%eax
 61d:	0f b6 80 68 0d 00 00 	movzbl 0xd68(%eax),%eax
 624:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 628:	8b 5d 10             	mov    0x10(%ebp),%ebx
 62b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 62e:	ba 00 00 00 00       	mov    $0x0,%edx
 633:	f7 f3                	div    %ebx
 635:	89 45 ec             	mov    %eax,-0x14(%ebp)
 638:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 63c:	75 c7                	jne    605 <printint+0x38>
  if(neg)
 63e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 642:	74 2d                	je     671 <printint+0xa4>
    buf[i++] = '-';
 644:	8b 45 f4             	mov    -0xc(%ebp),%eax
 647:	8d 50 01             	lea    0x1(%eax),%edx
 64a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 64d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 652:	eb 1d                	jmp    671 <printint+0xa4>
    putc(fd, buf[i]);
 654:	8d 55 dc             	lea    -0x24(%ebp),%edx
 657:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65a:	01 d0                	add    %edx,%eax
 65c:	0f b6 00             	movzbl (%eax),%eax
 65f:	0f be c0             	movsbl %al,%eax
 662:	83 ec 08             	sub    $0x8,%esp
 665:	50                   	push   %eax
 666:	ff 75 08             	pushl  0x8(%ebp)
 669:	e8 3c ff ff ff       	call   5aa <putc>
 66e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 671:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 675:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 679:	79 d9                	jns    654 <printint+0x87>
    putc(fd, buf[i]);
}
 67b:	90                   	nop
 67c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 67f:	c9                   	leave  
 680:	c3                   	ret    

00000681 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 681:	55                   	push   %ebp
 682:	89 e5                	mov    %esp,%ebp
 684:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 687:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 68e:	8d 45 0c             	lea    0xc(%ebp),%eax
 691:	83 c0 04             	add    $0x4,%eax
 694:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 697:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 69e:	e9 59 01 00 00       	jmp    7fc <printf+0x17b>
    c = fmt[i] & 0xff;
 6a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a9:	01 d0                	add    %edx,%eax
 6ab:	0f b6 00             	movzbl (%eax),%eax
 6ae:	0f be c0             	movsbl %al,%eax
 6b1:	25 ff 00 00 00       	and    $0xff,%eax
 6b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6bd:	75 2c                	jne    6eb <printf+0x6a>
      if(c == '%'){
 6bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c3:	75 0c                	jne    6d1 <printf+0x50>
        state = '%';
 6c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6cc:	e9 27 01 00 00       	jmp    7f8 <printf+0x177>
      } else {
        putc(fd, c);
 6d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d4:	0f be c0             	movsbl %al,%eax
 6d7:	83 ec 08             	sub    $0x8,%esp
 6da:	50                   	push   %eax
 6db:	ff 75 08             	pushl  0x8(%ebp)
 6de:	e8 c7 fe ff ff       	call   5aa <putc>
 6e3:	83 c4 10             	add    $0x10,%esp
 6e6:	e9 0d 01 00 00       	jmp    7f8 <printf+0x177>
      }
    } else if(state == '%'){
 6eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6ef:	0f 85 03 01 00 00    	jne    7f8 <printf+0x177>
      if(c == 'd'){
 6f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6f9:	75 1e                	jne    719 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	6a 01                	push   $0x1
 702:	6a 0a                	push   $0xa
 704:	50                   	push   %eax
 705:	ff 75 08             	pushl  0x8(%ebp)
 708:	e8 c0 fe ff ff       	call   5cd <printint>
 70d:	83 c4 10             	add    $0x10,%esp
        ap++;
 710:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 714:	e9 d8 00 00 00       	jmp    7f1 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 719:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 71d:	74 06                	je     725 <printf+0xa4>
 71f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 723:	75 1e                	jne    743 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 725:	8b 45 e8             	mov    -0x18(%ebp),%eax
 728:	8b 00                	mov    (%eax),%eax
 72a:	6a 00                	push   $0x0
 72c:	6a 10                	push   $0x10
 72e:	50                   	push   %eax
 72f:	ff 75 08             	pushl  0x8(%ebp)
 732:	e8 96 fe ff ff       	call   5cd <printint>
 737:	83 c4 10             	add    $0x10,%esp
        ap++;
 73a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73e:	e9 ae 00 00 00       	jmp    7f1 <printf+0x170>
      } else if(c == 's'){
 743:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 747:	75 43                	jne    78c <printf+0x10b>
        s = (char*)*ap;
 749:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 751:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 759:	75 25                	jne    780 <printf+0xff>
          s = "(null)";
 75b:	c7 45 f4 0b 0b 00 00 	movl   $0xb0b,-0xc(%ebp)
        while(*s != 0){
 762:	eb 1c                	jmp    780 <printf+0xff>
          putc(fd, *s);
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	0f b6 00             	movzbl (%eax),%eax
 76a:	0f be c0             	movsbl %al,%eax
 76d:	83 ec 08             	sub    $0x8,%esp
 770:	50                   	push   %eax
 771:	ff 75 08             	pushl  0x8(%ebp)
 774:	e8 31 fe ff ff       	call   5aa <putc>
 779:	83 c4 10             	add    $0x10,%esp
          s++;
 77c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 780:	8b 45 f4             	mov    -0xc(%ebp),%eax
 783:	0f b6 00             	movzbl (%eax),%eax
 786:	84 c0                	test   %al,%al
 788:	75 da                	jne    764 <printf+0xe3>
 78a:	eb 65                	jmp    7f1 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 790:	75 1d                	jne    7af <printf+0x12e>
        putc(fd, *ap);
 792:	8b 45 e8             	mov    -0x18(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	0f be c0             	movsbl %al,%eax
 79a:	83 ec 08             	sub    $0x8,%esp
 79d:	50                   	push   %eax
 79e:	ff 75 08             	pushl  0x8(%ebp)
 7a1:	e8 04 fe ff ff       	call   5aa <putc>
 7a6:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ad:	eb 42                	jmp    7f1 <printf+0x170>
      } else if(c == '%'){
 7af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7b3:	75 17                	jne    7cc <printf+0x14b>
        putc(fd, c);
 7b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b8:	0f be c0             	movsbl %al,%eax
 7bb:	83 ec 08             	sub    $0x8,%esp
 7be:	50                   	push   %eax
 7bf:	ff 75 08             	pushl  0x8(%ebp)
 7c2:	e8 e3 fd ff ff       	call   5aa <putc>
 7c7:	83 c4 10             	add    $0x10,%esp
 7ca:	eb 25                	jmp    7f1 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7cc:	83 ec 08             	sub    $0x8,%esp
 7cf:	6a 25                	push   $0x25
 7d1:	ff 75 08             	pushl  0x8(%ebp)
 7d4:	e8 d1 fd ff ff       	call   5aa <putc>
 7d9:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7df:	0f be c0             	movsbl %al,%eax
 7e2:	83 ec 08             	sub    $0x8,%esp
 7e5:	50                   	push   %eax
 7e6:	ff 75 08             	pushl  0x8(%ebp)
 7e9:	e8 bc fd ff ff       	call   5aa <putc>
 7ee:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 802:	01 d0                	add    %edx,%eax
 804:	0f b6 00             	movzbl (%eax),%eax
 807:	84 c0                	test   %al,%al
 809:	0f 85 94 fe ff ff    	jne    6a3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 80f:	90                   	nop
 810:	c9                   	leave  
 811:	c3                   	ret    

00000812 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 812:	55                   	push   %ebp
 813:	89 e5                	mov    %esp,%ebp
 815:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 818:	8b 45 08             	mov    0x8(%ebp),%eax
 81b:	83 e8 08             	sub    $0x8,%eax
 81e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 821:	a1 84 0d 00 00       	mov    0xd84,%eax
 826:	89 45 fc             	mov    %eax,-0x4(%ebp)
 829:	eb 24                	jmp    84f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 833:	77 12                	ja     847 <free+0x35>
 835:	8b 45 f8             	mov    -0x8(%ebp),%eax
 838:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 83b:	77 24                	ja     861 <free+0x4f>
 83d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 840:	8b 00                	mov    (%eax),%eax
 842:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 845:	77 1a                	ja     861 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 00                	mov    (%eax),%eax
 84c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 852:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 855:	76 d4                	jbe    82b <free+0x19>
 857:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85a:	8b 00                	mov    (%eax),%eax
 85c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 85f:	76 ca                	jbe    82b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 861:	8b 45 f8             	mov    -0x8(%ebp),%eax
 864:	8b 40 04             	mov    0x4(%eax),%eax
 867:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 86e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 871:	01 c2                	add    %eax,%edx
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	8b 00                	mov    (%eax),%eax
 878:	39 c2                	cmp    %eax,%edx
 87a:	75 24                	jne    8a0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 87c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87f:	8b 50 04             	mov    0x4(%eax),%edx
 882:	8b 45 fc             	mov    -0x4(%ebp),%eax
 885:	8b 00                	mov    (%eax),%eax
 887:	8b 40 04             	mov    0x4(%eax),%eax
 88a:	01 c2                	add    %eax,%edx
 88c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 892:	8b 45 fc             	mov    -0x4(%ebp),%eax
 895:	8b 00                	mov    (%eax),%eax
 897:	8b 10                	mov    (%eax),%edx
 899:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89c:	89 10                	mov    %edx,(%eax)
 89e:	eb 0a                	jmp    8aa <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a3:	8b 10                	mov    (%eax),%edx
 8a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ad:	8b 40 04             	mov    0x4(%eax),%eax
 8b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ba:	01 d0                	add    %edx,%eax
 8bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8bf:	75 20                	jne    8e1 <free+0xcf>
    p->s.size += bp->s.size;
 8c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c4:	8b 50 04             	mov    0x4(%eax),%edx
 8c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ca:	8b 40 04             	mov    0x4(%eax),%eax
 8cd:	01 c2                	add    %eax,%edx
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d8:	8b 10                	mov    (%eax),%edx
 8da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dd:	89 10                	mov    %edx,(%eax)
 8df:	eb 08                	jmp    8e9 <free+0xd7>
  } else
    p->s.ptr = bp;
 8e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8e7:	89 10                	mov    %edx,(%eax)
  freep = p;
 8e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ec:	a3 84 0d 00 00       	mov    %eax,0xd84
}
 8f1:	90                   	nop
 8f2:	c9                   	leave  
 8f3:	c3                   	ret    

000008f4 <morecore>:

static Header*
morecore(uint nu)
{
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8fa:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 901:	77 07                	ja     90a <morecore+0x16>
    nu = 4096;
 903:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 90a:	8b 45 08             	mov    0x8(%ebp),%eax
 90d:	c1 e0 03             	shl    $0x3,%eax
 910:	83 ec 0c             	sub    $0xc,%esp
 913:	50                   	push   %eax
 914:	e8 39 fc ff ff       	call   552 <sbrk>
 919:	83 c4 10             	add    $0x10,%esp
 91c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 91f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 923:	75 07                	jne    92c <morecore+0x38>
    return 0;
 925:	b8 00 00 00 00       	mov    $0x0,%eax
 92a:	eb 26                	jmp    952 <morecore+0x5e>
  hp = (Header*)p;
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 932:	8b 45 f0             	mov    -0x10(%ebp),%eax
 935:	8b 55 08             	mov    0x8(%ebp),%edx
 938:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 93b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93e:	83 c0 08             	add    $0x8,%eax
 941:	83 ec 0c             	sub    $0xc,%esp
 944:	50                   	push   %eax
 945:	e8 c8 fe ff ff       	call   812 <free>
 94a:	83 c4 10             	add    $0x10,%esp
  return freep;
 94d:	a1 84 0d 00 00       	mov    0xd84,%eax
}
 952:	c9                   	leave  
 953:	c3                   	ret    

00000954 <malloc>:

void*
malloc(uint nbytes)
{
 954:	55                   	push   %ebp
 955:	89 e5                	mov    %esp,%ebp
 957:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 95a:	8b 45 08             	mov    0x8(%ebp),%eax
 95d:	83 c0 07             	add    $0x7,%eax
 960:	c1 e8 03             	shr    $0x3,%eax
 963:	83 c0 01             	add    $0x1,%eax
 966:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 969:	a1 84 0d 00 00       	mov    0xd84,%eax
 96e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 971:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 975:	75 23                	jne    99a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 977:	c7 45 f0 7c 0d 00 00 	movl   $0xd7c,-0x10(%ebp)
 97e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 981:	a3 84 0d 00 00       	mov    %eax,0xd84
 986:	a1 84 0d 00 00       	mov    0xd84,%eax
 98b:	a3 7c 0d 00 00       	mov    %eax,0xd7c
    base.s.size = 0;
 990:	c7 05 80 0d 00 00 00 	movl   $0x0,0xd80
 997:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99d:	8b 00                	mov    (%eax),%eax
 99f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a5:	8b 40 04             	mov    0x4(%eax),%eax
 9a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9ab:	72 4d                	jb     9fa <malloc+0xa6>
      if(p->s.size == nunits)
 9ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b0:	8b 40 04             	mov    0x4(%eax),%eax
 9b3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9b6:	75 0c                	jne    9c4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bb:	8b 10                	mov    (%eax),%edx
 9bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c0:	89 10                	mov    %edx,(%eax)
 9c2:	eb 26                	jmp    9ea <malloc+0x96>
      else {
        p->s.size -= nunits;
 9c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c7:	8b 40 04             	mov    0x4(%eax),%eax
 9ca:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9cd:	89 c2                	mov    %eax,%edx
 9cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d8:	8b 40 04             	mov    0x4(%eax),%eax
 9db:	c1 e0 03             	shl    $0x3,%eax
 9de:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9e7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ed:	a3 84 0d 00 00       	mov    %eax,0xd84
      return (void*)(p + 1);
 9f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f5:	83 c0 08             	add    $0x8,%eax
 9f8:	eb 3b                	jmp    a35 <malloc+0xe1>
    }
    if(p == freep)
 9fa:	a1 84 0d 00 00       	mov    0xd84,%eax
 9ff:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a02:	75 1e                	jne    a22 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a04:	83 ec 0c             	sub    $0xc,%esp
 a07:	ff 75 ec             	pushl  -0x14(%ebp)
 a0a:	e8 e5 fe ff ff       	call   8f4 <morecore>
 a0f:	83 c4 10             	add    $0x10,%esp
 a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a19:	75 07                	jne    a22 <malloc+0xce>
        return 0;
 a1b:	b8 00 00 00 00       	mov    $0x0,%eax
 a20:	eb 13                	jmp    a35 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2b:	8b 00                	mov    (%eax),%eax
 a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a30:	e9 6d ff ff ff       	jmp    9a2 <malloc+0x4e>
}
 a35:	c9                   	leave  
 a36:	c3                   	ret    
