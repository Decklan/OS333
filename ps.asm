
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "uproc.h"
#include "user.h"
#define MAX 1

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
  17:	6a 5c                	push   $0x5c
  19:	e8 33 09 00 00       	call   951 <malloc>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if (!table) 
  24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  28:	75 17                	jne    41 <main+0x41>
  {
    printf(2, "Error. Malloc call failed.");
  2a:	83 ec 08             	sub    $0x8,%esp
  2d:	68 34 0a 00 00       	push   $0xa34
  32:	6a 02                	push   $0x2
  34:	e8 45 06 00 00       	call   67e <printf>
  39:	83 c4 10             	add    $0x10,%esp
    exit();
  3c:	e8 86 04 00 00       	call   4c7 <exit>
  }
 
  printf(1, "Max value: %d\n", MAX); 
  41:	83 ec 04             	sub    $0x4,%esp
  44:	6a 01                	push   $0x1
  46:	68 4f 0a 00 00       	push   $0xa4f
  4b:	6a 01                	push   $0x1
  4d:	e8 2c 06 00 00       	call   67e <printf>
  52:	83 c4 10             	add    $0x10,%esp
  int status = getprocs(MAX, table);
  55:	83 ec 08             	sub    $0x8,%esp
  58:	ff 75 e0             	pushl  -0x20(%ebp)
  5b:	6a 01                	push   $0x1
  5d:	e8 3d 05 00 00       	call   59f <getprocs>
  62:	83 c4 10             	add    $0x10,%esp
  65:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (status < 0)
  68:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  6c:	79 17                	jns    85 <main+0x85>
    printf(2, "Error. Not enough memory for the table.\n");
  6e:	83 ec 08             	sub    $0x8,%esp
  71:	68 60 0a 00 00       	push   $0xa60
  76:	6a 02                	push   $0x2
  78:	e8 01 06 00 00       	call   67e <printf>
  7d:	83 c4 10             	add    $0x10,%esp
  80:	e9 a1 01 00 00       	jmp    226 <main+0x226>
  else
  {
    printf(1, "PID\t Name\t UID\t GID\t PPID\t Elapsed  CPU\t State\t Size\n");
  85:	83 ec 08             	sub    $0x8,%esp
  88:	68 8c 0a 00 00       	push   $0xa8c
  8d:	6a 01                	push   $0x1
  8f:	e8 ea 05 00 00       	call   67e <printf>
  94:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < status; ++i)
  97:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  9e:	e9 77 01 00 00       	jmp    21a <main+0x21a>
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
  a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  a6:	6b d0 5c             	imul   $0x5c,%eax,%edx
  a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  ac:	01 d0                	add    %edx,%eax
  ae:	8b 40 10             	mov    0x10(%eax),%eax
  b1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  b6:	f7 e2                	mul    %edx
  b8:	89 d0                	mov    %edx,%eax
  ba:	c1 e8 05             	shr    $0x5,%eax
  bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
  c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  c3:	6b d0 5c             	imul   $0x5c,%eax,%edx
  c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  c9:	01 d0                	add    %edx,%eax
  cb:	8b 48 10             	mov    0x10(%eax),%ecx
  ce:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  d3:	89 c8                	mov    %ecx,%eax
  d5:	f7 e2                	mul    %edx
  d7:	89 d0                	mov    %edx,%eax
  d9:	c1 e8 05             	shr    $0x5,%eax
  dc:	6b c0 64             	imul   $0x64,%eax,%eax
  df:	29 c1                	sub    %eax,%ecx
  e1:	89 c8                	mov    %ecx,%eax
  e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      int total_cpu_secs = table[i].CPU_total_ticks/100;
  e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  e9:	6b d0 5c             	imul   $0x5c,%eax,%edx
  ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  ef:	01 d0                	add    %edx,%eax
  f1:	8b 40 14             	mov    0x14(%eax),%eax
  f4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  f9:	f7 e2                	mul    %edx
  fb:	89 d0                	mov    %edx,%eax
  fd:	c1 e8 05             	shr    $0x5,%eax
 100:	89 45 d0             	mov    %eax,-0x30(%ebp)
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
 103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 106:	6b d0 5c             	imul   $0x5c,%eax,%edx
 109:	8b 45 e0             	mov    -0x20(%ebp),%eax
 10c:	01 d0                	add    %edx,%eax
 10e:	8b 48 14             	mov    0x14(%eax),%ecx
 111:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 116:	89 c8                	mov    %ecx,%eax
 118:	f7 e2                	mul    %edx
 11a:	89 d0                	mov    %edx,%eax
 11c:	c1 e8 05             	shr    $0x5,%eax
 11f:	6b c0 64             	imul   $0x64,%eax,%eax
 122:	29 c1                	sub    %eax,%ecx
 124:	89 c8                	mov    %ecx,%eax
 126:	89 45 cc             	mov    %eax,-0x34(%ebp)
      printf(1, "%d\t %s\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
            table[i].gid, table[i].ppid);
 129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12c:	6b d0 5c             	imul   $0x5c,%eax,%edx
 12f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 132:	01 d0                	add    %edx,%eax
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%d\t %s\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
 134:	8b 58 0c             	mov    0xc(%eax),%ebx
            table[i].gid, table[i].ppid);
 137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 13a:	6b d0 5c             	imul   $0x5c,%eax,%edx
 13d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 140:	01 d0                	add    %edx,%eax
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%d\t %s\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
 142:	8b 48 08             	mov    0x8(%eax),%ecx
 145:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 148:	6b d0 5c             	imul   $0x5c,%eax,%edx
 14b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 14e:	01 d0                	add    %edx,%eax
 150:	8b 50 04             	mov    0x4(%eax),%edx
 153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 156:	6b f0 5c             	imul   $0x5c,%eax,%esi
 159:	8b 45 e0             	mov    -0x20(%ebp),%eax
 15c:	01 f0                	add    %esi,%eax
 15e:	8d 70 3c             	lea    0x3c(%eax),%esi
 161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 164:	6b f8 5c             	imul   $0x5c,%eax,%edi
 167:	8b 45 e0             	mov    -0x20(%ebp),%eax
 16a:	01 f8                	add    %edi,%eax
 16c:	8b 00                	mov    (%eax),%eax
 16e:	83 ec 04             	sub    $0x4,%esp
 171:	53                   	push   %ebx
 172:	51                   	push   %ecx
 173:	52                   	push   %edx
 174:	56                   	push   %esi
 175:	50                   	push   %eax
 176:	68 c2 0a 00 00       	push   $0xac2
 17b:	6a 01                	push   $0x1
 17d:	e8 fc 04 00 00       	call   67e <printf>
 182:	83 c4 20             	add    $0x20,%esp
            table[i].gid, table[i].ppid);
    
      if (partial_elapsed_secs < 10)
 185:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
 189:	7f 17                	jg     1a2 <main+0x1a2>
        printf(1, " %d.0%d", elapsed_secs, partial_elapsed_secs);
 18b:	ff 75 d4             	pushl  -0x2c(%ebp)
 18e:	ff 75 d8             	pushl  -0x28(%ebp)
 191:	68 d6 0a 00 00       	push   $0xad6
 196:	6a 01                	push   $0x1
 198:	e8 e1 04 00 00       	call   67e <printf>
 19d:	83 c4 10             	add    $0x10,%esp
 1a0:	eb 15                	jmp    1b7 <main+0x1b7>
      else
        printf(1, " %d.%d", elapsed_secs, partial_elapsed_secs);
 1a2:	ff 75 d4             	pushl  -0x2c(%ebp)
 1a5:	ff 75 d8             	pushl  -0x28(%ebp)
 1a8:	68 de 0a 00 00       	push   $0xade
 1ad:	6a 01                	push   $0x1
 1af:	e8 ca 04 00 00       	call   67e <printf>
 1b4:	83 c4 10             	add    $0x10,%esp

      if (partial_cpu_secs < 10)
 1b7:	83 7d cc 09          	cmpl   $0x9,-0x34(%ebp)
 1bb:	7f 17                	jg     1d4 <main+0x1d4>
        printf(1, "     %d.0%d\t", total_cpu_secs, partial_cpu_secs);
 1bd:	ff 75 cc             	pushl  -0x34(%ebp)
 1c0:	ff 75 d0             	pushl  -0x30(%ebp)
 1c3:	68 e5 0a 00 00       	push   $0xae5
 1c8:	6a 01                	push   $0x1
 1ca:	e8 af 04 00 00       	call   67e <printf>
 1cf:	83 c4 10             	add    $0x10,%esp
 1d2:	eb 15                	jmp    1e9 <main+0x1e9>
      else
        printf(1, "     %d.%d\t", total_cpu_secs, partial_cpu_secs);
 1d4:	ff 75 cc             	pushl  -0x34(%ebp)
 1d7:	ff 75 d0             	pushl  -0x30(%ebp)
 1da:	68 f2 0a 00 00       	push   $0xaf2
 1df:	6a 01                	push   $0x1
 1e1:	e8 98 04 00 00       	call   67e <printf>
 1e6:	83 c4 10             	add    $0x10,%esp

      printf(1, " %s\t %d\n", table[i].state, table[i].size);
 1e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1ec:	6b d0 5c             	imul   $0x5c,%eax,%edx
 1ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f2:	01 d0                	add    %edx,%eax
 1f4:	8b 40 38             	mov    0x38(%eax),%eax
 1f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1fa:	6b ca 5c             	imul   $0x5c,%edx,%ecx
 1fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
 200:	01 ca                	add    %ecx,%edx
 202:	83 c2 18             	add    $0x18,%edx
 205:	50                   	push   %eax
 206:	52                   	push   %edx
 207:	68 fe 0a 00 00       	push   $0xafe
 20c:	6a 01                	push   $0x1
 20e:	e8 6b 04 00 00       	call   67e <printf>
 213:	83 c4 10             	add    $0x10,%esp
  if (status < 0)
    printf(2, "Error. Not enough memory for the table.\n");
  else
  {
    printf(1, "PID\t Name\t UID\t GID\t PPID\t Elapsed  CPU\t State\t Size\n");
    for (int i = 0; i < status; ++i)
 216:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 21a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 21d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 220:	0f 8c 7d fe ff ff    	jl     a3 <main+0xa3>
        printf(1, "     %d.%d\t", total_cpu_secs, partial_cpu_secs);

      printf(1, " %s\t %d\n", table[i].state, table[i].size);
    }
  }
  exit();
 226:	e8 9c 02 00 00       	call   4c7 <exit>

0000022b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	57                   	push   %edi
 22f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 230:	8b 4d 08             	mov    0x8(%ebp),%ecx
 233:	8b 55 10             	mov    0x10(%ebp),%edx
 236:	8b 45 0c             	mov    0xc(%ebp),%eax
 239:	89 cb                	mov    %ecx,%ebx
 23b:	89 df                	mov    %ebx,%edi
 23d:	89 d1                	mov    %edx,%ecx
 23f:	fc                   	cld    
 240:	f3 aa                	rep stos %al,%es:(%edi)
 242:	89 ca                	mov    %ecx,%edx
 244:	89 fb                	mov    %edi,%ebx
 246:	89 5d 08             	mov    %ebx,0x8(%ebp)
 249:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 24c:	90                   	nop
 24d:	5b                   	pop    %ebx
 24e:	5f                   	pop    %edi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    

00000251 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 25d:	90                   	nop
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	8d 50 01             	lea    0x1(%eax),%edx
 264:	89 55 08             	mov    %edx,0x8(%ebp)
 267:	8b 55 0c             	mov    0xc(%ebp),%edx
 26a:	8d 4a 01             	lea    0x1(%edx),%ecx
 26d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 270:	0f b6 12             	movzbl (%edx),%edx
 273:	88 10                	mov    %dl,(%eax)
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	84 c0                	test   %al,%al
 27a:	75 e2                	jne    25e <strcpy+0xd>
    ;
  return os;
 27c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27f:	c9                   	leave  
 280:	c3                   	ret    

00000281 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 281:	55                   	push   %ebp
 282:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 284:	eb 08                	jmp    28e <strcmp+0xd>
    p++, q++;
 286:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 28a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	84 c0                	test   %al,%al
 296:	74 10                	je     2a8 <strcmp+0x27>
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	0f b6 10             	movzbl (%eax),%edx
 29e:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a1:	0f b6 00             	movzbl (%eax),%eax
 2a4:	38 c2                	cmp    %al,%dl
 2a6:	74 de                	je     286 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	0f b6 d0             	movzbl %al,%edx
 2b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	0f b6 c0             	movzbl %al,%eax
 2ba:	29 c2                	sub    %eax,%edx
 2bc:	89 d0                	mov    %edx,%eax
}
 2be:	5d                   	pop    %ebp
 2bf:	c3                   	ret    

000002c0 <strlen>:

uint
strlen(char *s)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2cd:	eb 04                	jmp    2d3 <strlen+0x13>
 2cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	01 d0                	add    %edx,%eax
 2db:	0f b6 00             	movzbl (%eax),%eax
 2de:	84 c0                	test   %al,%al
 2e0:	75 ed                	jne    2cf <strlen+0xf>
    ;
  return n;
 2e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e5:	c9                   	leave  
 2e6:	c3                   	ret    

000002e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e7:	55                   	push   %ebp
 2e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2ea:	8b 45 10             	mov    0x10(%ebp),%eax
 2ed:	50                   	push   %eax
 2ee:	ff 75 0c             	pushl  0xc(%ebp)
 2f1:	ff 75 08             	pushl  0x8(%ebp)
 2f4:	e8 32 ff ff ff       	call   22b <stosb>
 2f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ff:	c9                   	leave  
 300:	c3                   	ret    

00000301 <strchr>:

char*
strchr(const char *s, char c)
{
 301:	55                   	push   %ebp
 302:	89 e5                	mov    %esp,%ebp
 304:	83 ec 04             	sub    $0x4,%esp
 307:	8b 45 0c             	mov    0xc(%ebp),%eax
 30a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 30d:	eb 14                	jmp    323 <strchr+0x22>
    if(*s == c)
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	0f b6 00             	movzbl (%eax),%eax
 315:	3a 45 fc             	cmp    -0x4(%ebp),%al
 318:	75 05                	jne    31f <strchr+0x1e>
      return (char*)s;
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
 31d:	eb 13                	jmp    332 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 31f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	0f b6 00             	movzbl (%eax),%eax
 329:	84 c0                	test   %al,%al
 32b:	75 e2                	jne    30f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 32d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 332:	c9                   	leave  
 333:	c3                   	ret    

00000334 <gets>:

char*
gets(char *buf, int max)
{
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 341:	eb 42                	jmp    385 <gets+0x51>
    cc = read(0, &c, 1);
 343:	83 ec 04             	sub    $0x4,%esp
 346:	6a 01                	push   $0x1
 348:	8d 45 ef             	lea    -0x11(%ebp),%eax
 34b:	50                   	push   %eax
 34c:	6a 00                	push   $0x0
 34e:	e8 8c 01 00 00       	call   4df <read>
 353:	83 c4 10             	add    $0x10,%esp
 356:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 359:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 35d:	7e 33                	jle    392 <gets+0x5e>
      break;
    buf[i++] = c;
 35f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 362:	8d 50 01             	lea    0x1(%eax),%edx
 365:	89 55 f4             	mov    %edx,-0xc(%ebp)
 368:	89 c2                	mov    %eax,%edx
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	01 c2                	add    %eax,%edx
 36f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 373:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 375:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 379:	3c 0a                	cmp    $0xa,%al
 37b:	74 16                	je     393 <gets+0x5f>
 37d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 381:	3c 0d                	cmp    $0xd,%al
 383:	74 0e                	je     393 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 385:	8b 45 f4             	mov    -0xc(%ebp),%eax
 388:	83 c0 01             	add    $0x1,%eax
 38b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 38e:	7c b3                	jl     343 <gets+0xf>
 390:	eb 01                	jmp    393 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 392:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 393:	8b 55 f4             	mov    -0xc(%ebp),%edx
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	01 d0                	add    %edx,%eax
 39b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a1:	c9                   	leave  
 3a2:	c3                   	ret    

000003a3 <stat>:

int
stat(char *n, struct stat *st)
{
 3a3:	55                   	push   %ebp
 3a4:	89 e5                	mov    %esp,%ebp
 3a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a9:	83 ec 08             	sub    $0x8,%esp
 3ac:	6a 00                	push   $0x0
 3ae:	ff 75 08             	pushl  0x8(%ebp)
 3b1:	e8 51 01 00 00       	call   507 <open>
 3b6:	83 c4 10             	add    $0x10,%esp
 3b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3c0:	79 07                	jns    3c9 <stat+0x26>
    return -1;
 3c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3c7:	eb 25                	jmp    3ee <stat+0x4b>
  r = fstat(fd, st);
 3c9:	83 ec 08             	sub    $0x8,%esp
 3cc:	ff 75 0c             	pushl  0xc(%ebp)
 3cf:	ff 75 f4             	pushl  -0xc(%ebp)
 3d2:	e8 48 01 00 00       	call   51f <fstat>
 3d7:	83 c4 10             	add    $0x10,%esp
 3da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3dd:	83 ec 0c             	sub    $0xc,%esp
 3e0:	ff 75 f4             	pushl  -0xc(%ebp)
 3e3:	e8 07 01 00 00       	call   4ef <close>
 3e8:	83 c4 10             	add    $0x10,%esp
  return r;
 3eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3ee:	c9                   	leave  
 3ef:	c3                   	ret    

000003f0 <atoi>:

int
atoi(const char *s)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 3fd:	eb 04                	jmp    403 <atoi+0x13>
 3ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	0f b6 00             	movzbl (%eax),%eax
 409:	3c 20                	cmp    $0x20,%al
 40b:	74 f2                	je     3ff <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	0f b6 00             	movzbl (%eax),%eax
 413:	3c 2d                	cmp    $0x2d,%al
 415:	75 07                	jne    41e <atoi+0x2e>
 417:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 41c:	eb 05                	jmp    423 <atoi+0x33>
 41e:	b8 01 00 00 00       	mov    $0x1,%eax
 423:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	0f b6 00             	movzbl (%eax),%eax
 42c:	3c 2b                	cmp    $0x2b,%al
 42e:	74 0a                	je     43a <atoi+0x4a>
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	0f b6 00             	movzbl (%eax),%eax
 436:	3c 2d                	cmp    $0x2d,%al
 438:	75 2b                	jne    465 <atoi+0x75>
    s++;
 43a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 43e:	eb 25                	jmp    465 <atoi+0x75>
    n = n*10 + *s++ - '0';
 440:	8b 55 fc             	mov    -0x4(%ebp),%edx
 443:	89 d0                	mov    %edx,%eax
 445:	c1 e0 02             	shl    $0x2,%eax
 448:	01 d0                	add    %edx,%eax
 44a:	01 c0                	add    %eax,%eax
 44c:	89 c1                	mov    %eax,%ecx
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	8d 50 01             	lea    0x1(%eax),%edx
 454:	89 55 08             	mov    %edx,0x8(%ebp)
 457:	0f b6 00             	movzbl (%eax),%eax
 45a:	0f be c0             	movsbl %al,%eax
 45d:	01 c8                	add    %ecx,%eax
 45f:	83 e8 30             	sub    $0x30,%eax
 462:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 465:	8b 45 08             	mov    0x8(%ebp),%eax
 468:	0f b6 00             	movzbl (%eax),%eax
 46b:	3c 2f                	cmp    $0x2f,%al
 46d:	7e 0a                	jle    479 <atoi+0x89>
 46f:	8b 45 08             	mov    0x8(%ebp),%eax
 472:	0f b6 00             	movzbl (%eax),%eax
 475:	3c 39                	cmp    $0x39,%al
 477:	7e c7                	jle    440 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 479:	8b 45 f8             	mov    -0x8(%ebp),%eax
 47c:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 480:	c9                   	leave  
 481:	c3                   	ret    

00000482 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 482:	55                   	push   %ebp
 483:	89 e5                	mov    %esp,%ebp
 485:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 48e:	8b 45 0c             	mov    0xc(%ebp),%eax
 491:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 494:	eb 17                	jmp    4ad <memmove+0x2b>
    *dst++ = *src++;
 496:	8b 45 fc             	mov    -0x4(%ebp),%eax
 499:	8d 50 01             	lea    0x1(%eax),%edx
 49c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 49f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4a2:	8d 4a 01             	lea    0x1(%edx),%ecx
 4a5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4a8:	0f b6 12             	movzbl (%edx),%edx
 4ab:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ad:	8b 45 10             	mov    0x10(%ebp),%eax
 4b0:	8d 50 ff             	lea    -0x1(%eax),%edx
 4b3:	89 55 10             	mov    %edx,0x10(%ebp)
 4b6:	85 c0                	test   %eax,%eax
 4b8:	7f dc                	jg     496 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4bd:	c9                   	leave  
 4be:	c3                   	ret    

000004bf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4bf:	b8 01 00 00 00       	mov    $0x1,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <exit>:
SYSCALL(exit)
 4c7:	b8 02 00 00 00       	mov    $0x2,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <wait>:
SYSCALL(wait)
 4cf:	b8 03 00 00 00       	mov    $0x3,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <pipe>:
SYSCALL(pipe)
 4d7:	b8 04 00 00 00       	mov    $0x4,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <read>:
SYSCALL(read)
 4df:	b8 05 00 00 00       	mov    $0x5,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <write>:
SYSCALL(write)
 4e7:	b8 10 00 00 00       	mov    $0x10,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <close>:
SYSCALL(close)
 4ef:	b8 15 00 00 00       	mov    $0x15,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <kill>:
SYSCALL(kill)
 4f7:	b8 06 00 00 00       	mov    $0x6,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <exec>:
SYSCALL(exec)
 4ff:	b8 07 00 00 00       	mov    $0x7,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <open>:
SYSCALL(open)
 507:	b8 0f 00 00 00       	mov    $0xf,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <mknod>:
SYSCALL(mknod)
 50f:	b8 11 00 00 00       	mov    $0x11,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <unlink>:
SYSCALL(unlink)
 517:	b8 12 00 00 00       	mov    $0x12,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <fstat>:
SYSCALL(fstat)
 51f:	b8 08 00 00 00       	mov    $0x8,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <link>:
SYSCALL(link)
 527:	b8 13 00 00 00       	mov    $0x13,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <mkdir>:
SYSCALL(mkdir)
 52f:	b8 14 00 00 00       	mov    $0x14,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <chdir>:
SYSCALL(chdir)
 537:	b8 09 00 00 00       	mov    $0x9,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <dup>:
SYSCALL(dup)
 53f:	b8 0a 00 00 00       	mov    $0xa,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <getpid>:
SYSCALL(getpid)
 547:	b8 0b 00 00 00       	mov    $0xb,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <sbrk>:
SYSCALL(sbrk)
 54f:	b8 0c 00 00 00       	mov    $0xc,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <sleep>:
SYSCALL(sleep)
 557:	b8 0d 00 00 00       	mov    $0xd,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <uptime>:
SYSCALL(uptime)
 55f:	b8 0e 00 00 00       	mov    $0xe,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <halt>:
SYSCALL(halt)
 567:	b8 16 00 00 00       	mov    $0x16,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <date>:
SYSCALL(date)      #p1
 56f:	b8 17 00 00 00       	mov    $0x17,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <getuid>:
SYSCALL(getuid)    #p2
 577:	b8 18 00 00 00       	mov    $0x18,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <getgid>:
SYSCALL(getgid)    #p2
 57f:	b8 19 00 00 00       	mov    $0x19,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <getppid>:
SYSCALL(getppid)   #p2
 587:	b8 1a 00 00 00       	mov    $0x1a,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <setuid>:
SYSCALL(setuid)    #p2
 58f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <setgid>:
SYSCALL(setgid)    #p2
 597:	b8 1c 00 00 00       	mov    $0x1c,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <getprocs>:
SYSCALL(getprocs)  #p2
 59f:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5a7:	55                   	push   %ebp
 5a8:	89 e5                	mov    %esp,%ebp
 5aa:	83 ec 18             	sub    $0x18,%esp
 5ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5b3:	83 ec 04             	sub    $0x4,%esp
 5b6:	6a 01                	push   $0x1
 5b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5bb:	50                   	push   %eax
 5bc:	ff 75 08             	pushl  0x8(%ebp)
 5bf:	e8 23 ff ff ff       	call   4e7 <write>
 5c4:	83 c4 10             	add    $0x10,%esp
}
 5c7:	90                   	nop
 5c8:	c9                   	leave  
 5c9:	c3                   	ret    

000005ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ca:	55                   	push   %ebp
 5cb:	89 e5                	mov    %esp,%ebp
 5cd:	53                   	push   %ebx
 5ce:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5d8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5dc:	74 17                	je     5f5 <printint+0x2b>
 5de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5e2:	79 11                	jns    5f5 <printint+0x2b>
    neg = 1;
 5e4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ee:	f7 d8                	neg    %eax
 5f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5f3:	eb 06                	jmp    5fb <printint+0x31>
  } else {
    x = xx;
 5f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 602:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 605:	8d 41 01             	lea    0x1(%ecx),%eax
 608:	89 45 f4             	mov    %eax,-0xc(%ebp)
 60b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 60e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 611:	ba 00 00 00 00       	mov    $0x0,%edx
 616:	f7 f3                	div    %ebx
 618:	89 d0                	mov    %edx,%eax
 61a:	0f b6 80 64 0d 00 00 	movzbl 0xd64(%eax),%eax
 621:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 625:	8b 5d 10             	mov    0x10(%ebp),%ebx
 628:	8b 45 ec             	mov    -0x14(%ebp),%eax
 62b:	ba 00 00 00 00       	mov    $0x0,%edx
 630:	f7 f3                	div    %ebx
 632:	89 45 ec             	mov    %eax,-0x14(%ebp)
 635:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 639:	75 c7                	jne    602 <printint+0x38>
  if(neg)
 63b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 63f:	74 2d                	je     66e <printint+0xa4>
    buf[i++] = '-';
 641:	8b 45 f4             	mov    -0xc(%ebp),%eax
 644:	8d 50 01             	lea    0x1(%eax),%edx
 647:	89 55 f4             	mov    %edx,-0xc(%ebp)
 64a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 64f:	eb 1d                	jmp    66e <printint+0xa4>
    putc(fd, buf[i]);
 651:	8d 55 dc             	lea    -0x24(%ebp),%edx
 654:	8b 45 f4             	mov    -0xc(%ebp),%eax
 657:	01 d0                	add    %edx,%eax
 659:	0f b6 00             	movzbl (%eax),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	83 ec 08             	sub    $0x8,%esp
 662:	50                   	push   %eax
 663:	ff 75 08             	pushl  0x8(%ebp)
 666:	e8 3c ff ff ff       	call   5a7 <putc>
 66b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 66e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 672:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 676:	79 d9                	jns    651 <printint+0x87>
    putc(fd, buf[i]);
}
 678:	90                   	nop
 679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 67c:	c9                   	leave  
 67d:	c3                   	ret    

0000067e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 67e:	55                   	push   %ebp
 67f:	89 e5                	mov    %esp,%ebp
 681:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 684:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 68b:	8d 45 0c             	lea    0xc(%ebp),%eax
 68e:	83 c0 04             	add    $0x4,%eax
 691:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 694:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 69b:	e9 59 01 00 00       	jmp    7f9 <printf+0x17b>
    c = fmt[i] & 0xff;
 6a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a6:	01 d0                	add    %edx,%eax
 6a8:	0f b6 00             	movzbl (%eax),%eax
 6ab:	0f be c0             	movsbl %al,%eax
 6ae:	25 ff 00 00 00       	and    $0xff,%eax
 6b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6ba:	75 2c                	jne    6e8 <printf+0x6a>
      if(c == '%'){
 6bc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c0:	75 0c                	jne    6ce <printf+0x50>
        state = '%';
 6c2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6c9:	e9 27 01 00 00       	jmp    7f5 <printf+0x177>
      } else {
        putc(fd, c);
 6ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d1:	0f be c0             	movsbl %al,%eax
 6d4:	83 ec 08             	sub    $0x8,%esp
 6d7:	50                   	push   %eax
 6d8:	ff 75 08             	pushl  0x8(%ebp)
 6db:	e8 c7 fe ff ff       	call   5a7 <putc>
 6e0:	83 c4 10             	add    $0x10,%esp
 6e3:	e9 0d 01 00 00       	jmp    7f5 <printf+0x177>
      }
    } else if(state == '%'){
 6e8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6ec:	0f 85 03 01 00 00    	jne    7f5 <printf+0x177>
      if(c == 'd'){
 6f2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6f6:	75 1e                	jne    716 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	6a 01                	push   $0x1
 6ff:	6a 0a                	push   $0xa
 701:	50                   	push   %eax
 702:	ff 75 08             	pushl  0x8(%ebp)
 705:	e8 c0 fe ff ff       	call   5ca <printint>
 70a:	83 c4 10             	add    $0x10,%esp
        ap++;
 70d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 711:	e9 d8 00 00 00       	jmp    7ee <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 716:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 71a:	74 06                	je     722 <printf+0xa4>
 71c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 720:	75 1e                	jne    740 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 722:	8b 45 e8             	mov    -0x18(%ebp),%eax
 725:	8b 00                	mov    (%eax),%eax
 727:	6a 00                	push   $0x0
 729:	6a 10                	push   $0x10
 72b:	50                   	push   %eax
 72c:	ff 75 08             	pushl  0x8(%ebp)
 72f:	e8 96 fe ff ff       	call   5ca <printint>
 734:	83 c4 10             	add    $0x10,%esp
        ap++;
 737:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73b:	e9 ae 00 00 00       	jmp    7ee <printf+0x170>
      } else if(c == 's'){
 740:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 744:	75 43                	jne    789 <printf+0x10b>
        s = (char*)*ap;
 746:	8b 45 e8             	mov    -0x18(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 74e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 756:	75 25                	jne    77d <printf+0xff>
          s = "(null)";
 758:	c7 45 f4 07 0b 00 00 	movl   $0xb07,-0xc(%ebp)
        while(*s != 0){
 75f:	eb 1c                	jmp    77d <printf+0xff>
          putc(fd, *s);
 761:	8b 45 f4             	mov    -0xc(%ebp),%eax
 764:	0f b6 00             	movzbl (%eax),%eax
 767:	0f be c0             	movsbl %al,%eax
 76a:	83 ec 08             	sub    $0x8,%esp
 76d:	50                   	push   %eax
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 31 fe ff ff       	call   5a7 <putc>
 776:	83 c4 10             	add    $0x10,%esp
          s++;
 779:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	0f b6 00             	movzbl (%eax),%eax
 783:	84 c0                	test   %al,%al
 785:	75 da                	jne    761 <printf+0xe3>
 787:	eb 65                	jmp    7ee <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 789:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 78d:	75 1d                	jne    7ac <printf+0x12e>
        putc(fd, *ap);
 78f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 792:	8b 00                	mov    (%eax),%eax
 794:	0f be c0             	movsbl %al,%eax
 797:	83 ec 08             	sub    $0x8,%esp
 79a:	50                   	push   %eax
 79b:	ff 75 08             	pushl  0x8(%ebp)
 79e:	e8 04 fe ff ff       	call   5a7 <putc>
 7a3:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7aa:	eb 42                	jmp    7ee <printf+0x170>
      } else if(c == '%'){
 7ac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7b0:	75 17                	jne    7c9 <printf+0x14b>
        putc(fd, c);
 7b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b5:	0f be c0             	movsbl %al,%eax
 7b8:	83 ec 08             	sub    $0x8,%esp
 7bb:	50                   	push   %eax
 7bc:	ff 75 08             	pushl  0x8(%ebp)
 7bf:	e8 e3 fd ff ff       	call   5a7 <putc>
 7c4:	83 c4 10             	add    $0x10,%esp
 7c7:	eb 25                	jmp    7ee <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7c9:	83 ec 08             	sub    $0x8,%esp
 7cc:	6a 25                	push   $0x25
 7ce:	ff 75 08             	pushl  0x8(%ebp)
 7d1:	e8 d1 fd ff ff       	call   5a7 <putc>
 7d6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7dc:	0f be c0             	movsbl %al,%eax
 7df:	83 ec 08             	sub    $0x8,%esp
 7e2:	50                   	push   %eax
 7e3:	ff 75 08             	pushl  0x8(%ebp)
 7e6:	e8 bc fd ff ff       	call   5a7 <putc>
 7eb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7f5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 7fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ff:	01 d0                	add    %edx,%eax
 801:	0f b6 00             	movzbl (%eax),%eax
 804:	84 c0                	test   %al,%al
 806:	0f 85 94 fe ff ff    	jne    6a0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 80c:	90                   	nop
 80d:	c9                   	leave  
 80e:	c3                   	ret    

0000080f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80f:	55                   	push   %ebp
 810:	89 e5                	mov    %esp,%ebp
 812:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 815:	8b 45 08             	mov    0x8(%ebp),%eax
 818:	83 e8 08             	sub    $0x8,%eax
 81b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	a1 80 0d 00 00       	mov    0xd80,%eax
 823:	89 45 fc             	mov    %eax,-0x4(%ebp)
 826:	eb 24                	jmp    84c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 00                	mov    (%eax),%eax
 82d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 830:	77 12                	ja     844 <free+0x35>
 832:	8b 45 f8             	mov    -0x8(%ebp),%eax
 835:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 838:	77 24                	ja     85e <free+0x4f>
 83a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83d:	8b 00                	mov    (%eax),%eax
 83f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 842:	77 1a                	ja     85e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	8b 45 fc             	mov    -0x4(%ebp),%eax
 847:	8b 00                	mov    (%eax),%eax
 849:	89 45 fc             	mov    %eax,-0x4(%ebp)
 84c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 852:	76 d4                	jbe    828 <free+0x19>
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 85c:	76 ca                	jbe    828 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	8b 40 04             	mov    0x4(%eax),%eax
 864:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 86b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86e:	01 c2                	add    %eax,%edx
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	8b 00                	mov    (%eax),%eax
 875:	39 c2                	cmp    %eax,%edx
 877:	75 24                	jne    89d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 879:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87c:	8b 50 04             	mov    0x4(%eax),%edx
 87f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 882:	8b 00                	mov    (%eax),%eax
 884:	8b 40 04             	mov    0x4(%eax),%eax
 887:	01 c2                	add    %eax,%edx
 889:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	8b 00                	mov    (%eax),%eax
 894:	8b 10                	mov    (%eax),%edx
 896:	8b 45 f8             	mov    -0x8(%ebp),%eax
 899:	89 10                	mov    %edx,(%eax)
 89b:	eb 0a                	jmp    8a7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 89d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a0:	8b 10                	mov    (%eax),%edx
 8a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8aa:	8b 40 04             	mov    0x4(%eax),%eax
 8ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b7:	01 d0                	add    %edx,%eax
 8b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8bc:	75 20                	jne    8de <free+0xcf>
    p->s.size += bp->s.size;
 8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c1:	8b 50 04             	mov    0x4(%eax),%edx
 8c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	01 c2                	add    %eax,%edx
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d5:	8b 10                	mov    (%eax),%edx
 8d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8da:	89 10                	mov    %edx,(%eax)
 8dc:	eb 08                	jmp    8e6 <free+0xd7>
  } else
    p->s.ptr = bp;
 8de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8e4:	89 10                	mov    %edx,(%eax)
  freep = p;
 8e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e9:	a3 80 0d 00 00       	mov    %eax,0xd80
}
 8ee:	90                   	nop
 8ef:	c9                   	leave  
 8f0:	c3                   	ret    

000008f1 <morecore>:

static Header*
morecore(uint nu)
{
 8f1:	55                   	push   %ebp
 8f2:	89 e5                	mov    %esp,%ebp
 8f4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8f7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8fe:	77 07                	ja     907 <morecore+0x16>
    nu = 4096;
 900:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 907:	8b 45 08             	mov    0x8(%ebp),%eax
 90a:	c1 e0 03             	shl    $0x3,%eax
 90d:	83 ec 0c             	sub    $0xc,%esp
 910:	50                   	push   %eax
 911:	e8 39 fc ff ff       	call   54f <sbrk>
 916:	83 c4 10             	add    $0x10,%esp
 919:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 91c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 920:	75 07                	jne    929 <morecore+0x38>
    return 0;
 922:	b8 00 00 00 00       	mov    $0x0,%eax
 927:	eb 26                	jmp    94f <morecore+0x5e>
  hp = (Header*)p;
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 92f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 932:	8b 55 08             	mov    0x8(%ebp),%edx
 935:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 938:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93b:	83 c0 08             	add    $0x8,%eax
 93e:	83 ec 0c             	sub    $0xc,%esp
 941:	50                   	push   %eax
 942:	e8 c8 fe ff ff       	call   80f <free>
 947:	83 c4 10             	add    $0x10,%esp
  return freep;
 94a:	a1 80 0d 00 00       	mov    0xd80,%eax
}
 94f:	c9                   	leave  
 950:	c3                   	ret    

00000951 <malloc>:

void*
malloc(uint nbytes)
{
 951:	55                   	push   %ebp
 952:	89 e5                	mov    %esp,%ebp
 954:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 957:	8b 45 08             	mov    0x8(%ebp),%eax
 95a:	83 c0 07             	add    $0x7,%eax
 95d:	c1 e8 03             	shr    $0x3,%eax
 960:	83 c0 01             	add    $0x1,%eax
 963:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 966:	a1 80 0d 00 00       	mov    0xd80,%eax
 96b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 96e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 972:	75 23                	jne    997 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 974:	c7 45 f0 78 0d 00 00 	movl   $0xd78,-0x10(%ebp)
 97b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97e:	a3 80 0d 00 00       	mov    %eax,0xd80
 983:	a1 80 0d 00 00       	mov    0xd80,%eax
 988:	a3 78 0d 00 00       	mov    %eax,0xd78
    base.s.size = 0;
 98d:	c7 05 7c 0d 00 00 00 	movl   $0x0,0xd7c
 994:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 997:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99a:	8b 00                	mov    (%eax),%eax
 99c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 99f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a2:	8b 40 04             	mov    0x4(%eax),%eax
 9a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9a8:	72 4d                	jb     9f7 <malloc+0xa6>
      if(p->s.size == nunits)
 9aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ad:	8b 40 04             	mov    0x4(%eax),%eax
 9b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9b3:	75 0c                	jne    9c1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b8:	8b 10                	mov    (%eax),%edx
 9ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bd:	89 10                	mov    %edx,(%eax)
 9bf:	eb 26                	jmp    9e7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c4:	8b 40 04             	mov    0x4(%eax),%eax
 9c7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9ca:	89 c2                	mov    %eax,%edx
 9cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d5:	8b 40 04             	mov    0x4(%eax),%eax
 9d8:	c1 e0 03             	shl    $0x3,%eax
 9db:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9e4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ea:	a3 80 0d 00 00       	mov    %eax,0xd80
      return (void*)(p + 1);
 9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f2:	83 c0 08             	add    $0x8,%eax
 9f5:	eb 3b                	jmp    a32 <malloc+0xe1>
    }
    if(p == freep)
 9f7:	a1 80 0d 00 00       	mov    0xd80,%eax
 9fc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9ff:	75 1e                	jne    a1f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a01:	83 ec 0c             	sub    $0xc,%esp
 a04:	ff 75 ec             	pushl  -0x14(%ebp)
 a07:	e8 e5 fe ff ff       	call   8f1 <morecore>
 a0c:	83 c4 10             	add    $0x10,%esp
 a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a16:	75 07                	jne    a1f <malloc+0xce>
        return 0;
 a18:	b8 00 00 00 00       	mov    $0x0,%eax
 a1d:	eb 13                	jmp    a32 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a28:	8b 00                	mov    (%eax),%eax
 a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a2d:	e9 6d ff ff ff       	jmp    99f <malloc+0x4e>
}
 a32:	c9                   	leave  
 a33:	c3                   	ret    
