
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
  11:	83 ec 38             	sub    $0x38,%esp
  struct uproc* table = malloc(MAX*sizeof(struct uproc));
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	68 80 0b 00 00       	push   $0xb80
  1c:	e8 de 08 00 00       	call   8ff <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if (!table) 
  27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  2b:	75 1c                	jne    49 <main+0x49>
  {
    printf(2, "Error. Malloc call failed.");
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	68 e4 09 00 00       	push   $0x9e4
  35:	6a 02                	push   $0x2
  37:	e8 f0 05 00 00       	call   62c <printf>
  3c:	83 c4 10             	add    $0x10,%esp
    return -1;
  3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  44:	e9 c9 01 00 00       	jmp    212 <main+0x212>
  }  
  int status = getprocs(MAX, table);
  49:	83 ec 08             	sub    $0x8,%esp
  4c:	ff 75 e0             	pushl  -0x20(%ebp)
  4f:	6a 20                	push   $0x20
  51:	e8 f7 04 00 00       	call   54d <getprocs>
  56:	83 c4 10             	add    $0x10,%esp
  59:	89 45 dc             	mov    %eax,-0x24(%ebp)
  printf(1, "Name       State         PID  UID  GID  PPID  Size       Elapsed       Total\n");
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 00 0a 00 00       	push   $0xa00
  64:	6a 01                	push   $0x1
  66:	e8 c1 05 00 00       	call   62c <printf>
  6b:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < status; ++i)
  6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  75:	e9 72 01 00 00       	jmp    1ec <main+0x1ec>
  {
    int elapsed_secs = table[i].elapsed_ticks/100;
  7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  7d:	6b d0 5c             	imul   $0x5c,%eax,%edx
  80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  83:	01 d0                	add    %edx,%eax
  85:	8b 40 10             	mov    0x10(%eax),%eax
  88:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  8d:	f7 e2                	mul    %edx
  8f:	89 d0                	mov    %edx,%eax
  91:	c1 e8 05             	shr    $0x5,%eax
  94:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int partial_elapsed_secs = table[i].elapsed_ticks%100;
  97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  9a:	6b d0 5c             	imul   $0x5c,%eax,%edx
  9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 48 10             	mov    0x10(%eax),%ecx
  a5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  aa:	89 c8                	mov    %ecx,%eax
  ac:	f7 e2                	mul    %edx
  ae:	89 d0                	mov    %edx,%eax
  b0:	c1 e8 05             	shr    $0x5,%eax
  b3:	6b c0 64             	imul   $0x64,%eax,%eax
  b6:	29 c1                	sub    %eax,%ecx
  b8:	89 c8                	mov    %ecx,%eax
  ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    int total_cpu_secs = table[i].CPU_total_ticks/100;
  bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  c0:	6b d0 5c             	imul   $0x5c,%eax,%edx
  c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  c6:	01 d0                	add    %edx,%eax
  c8:	8b 40 14             	mov    0x14(%eax),%eax
  cb:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  d0:	f7 e2                	mul    %edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	c1 e8 05             	shr    $0x5,%eax
  d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    int partial_cpu_secs = table[i].CPU_total_ticks%100;
  da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  dd:	6b d0 5c             	imul   $0x5c,%eax,%edx
  e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e3:	01 d0                	add    %edx,%eax
  e5:	8b 48 14             	mov    0x14(%eax),%ecx
  e8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  ed:	89 c8                	mov    %ecx,%eax
  ef:	f7 e2                	mul    %edx
  f1:	89 d0                	mov    %edx,%eax
  f3:	c1 e8 05             	shr    $0x5,%eax
  f6:	6b c0 64             	imul   $0x64,%eax,%eax
  f9:	29 c1                	sub    %eax,%ecx
  fb:	89 c8                	mov    %ecx,%eax
  fd:	89 45 cc             	mov    %eax,-0x34(%ebp)
    printf(1, "%s        %s        %d    %d   %d   %d     %d", table[i].name, table[i].state, table[i].pid, table[i].uid, 
          table[i].gid, table[i].ppid, table[i].size);
 100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 103:	6b d0 5c             	imul   $0x5c,%eax,%edx
 106:	8b 45 e0             	mov    -0x20(%ebp),%eax
 109:	01 d0                	add    %edx,%eax
  {
    int elapsed_secs = table[i].elapsed_ticks/100;
    int partial_elapsed_secs = table[i].elapsed_ticks%100;
    int total_cpu_secs = table[i].CPU_total_ticks/100;
    int partial_cpu_secs = table[i].CPU_total_ticks%100;
    printf(1, "%s        %s        %d    %d   %d   %d     %d", table[i].name, table[i].state, table[i].pid, table[i].uid, 
 10b:	8b 40 38             	mov    0x38(%eax),%eax
 10e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
          table[i].gid, table[i].ppid, table[i].size);
 111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 114:	6b d0 5c             	imul   $0x5c,%eax,%edx
 117:	8b 45 e0             	mov    -0x20(%ebp),%eax
 11a:	01 d0                	add    %edx,%eax
  {
    int elapsed_secs = table[i].elapsed_ticks/100;
    int partial_elapsed_secs = table[i].elapsed_ticks%100;
    int total_cpu_secs = table[i].CPU_total_ticks/100;
    int partial_cpu_secs = table[i].CPU_total_ticks%100;
    printf(1, "%s        %s        %d    %d   %d   %d     %d", table[i].name, table[i].state, table[i].pid, table[i].uid, 
 11c:	8b 58 0c             	mov    0xc(%eax),%ebx
 11f:	89 5d c0             	mov    %ebx,-0x40(%ebp)
          table[i].gid, table[i].ppid, table[i].size);
 122:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 125:	6b d0 5c             	imul   $0x5c,%eax,%edx
 128:	8b 45 e0             	mov    -0x20(%ebp),%eax
 12b:	01 d0                	add    %edx,%eax
  {
    int elapsed_secs = table[i].elapsed_ticks/100;
    int partial_elapsed_secs = table[i].elapsed_ticks%100;
    int total_cpu_secs = table[i].CPU_total_ticks/100;
    int partial_cpu_secs = table[i].CPU_total_ticks%100;
    printf(1, "%s        %s        %d    %d   %d   %d     %d", table[i].name, table[i].state, table[i].pid, table[i].uid, 
 12d:	8b 78 08             	mov    0x8(%eax),%edi
 130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 133:	6b d0 5c             	imul   $0x5c,%eax,%edx
 136:	8b 45 e0             	mov    -0x20(%ebp),%eax
 139:	01 d0                	add    %edx,%eax
 13b:	8b 70 04             	mov    0x4(%eax),%esi
 13e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 141:	6b d0 5c             	imul   $0x5c,%eax,%edx
 144:	8b 45 e0             	mov    -0x20(%ebp),%eax
 147:	01 d0                	add    %edx,%eax
 149:	8b 18                	mov    (%eax),%ebx
 14b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 14e:	6b d0 5c             	imul   $0x5c,%eax,%edx
 151:	8b 45 e0             	mov    -0x20(%ebp),%eax
 154:	01 d0                	add    %edx,%eax
 156:	8d 48 18             	lea    0x18(%eax),%ecx
 159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 15c:	6b d0 5c             	imul   $0x5c,%eax,%edx
 15f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 162:	01 d0                	add    %edx,%eax
 164:	83 c0 3c             	add    $0x3c,%eax
 167:	83 ec 0c             	sub    $0xc,%esp
 16a:	ff 75 c4             	pushl  -0x3c(%ebp)
 16d:	ff 75 c0             	pushl  -0x40(%ebp)
 170:	57                   	push   %edi
 171:	56                   	push   %esi
 172:	53                   	push   %ebx
 173:	51                   	push   %ecx
 174:	50                   	push   %eax
 175:	68 50 0a 00 00       	push   $0xa50
 17a:	6a 01                	push   $0x1
 17c:	e8 ab 04 00 00       	call   62c <printf>
 181:	83 c4 30             	add    $0x30,%esp
          table[i].gid, table[i].ppid, table[i].size);
    
    if (partial_elapsed_secs < 10)
 184:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
 188:	7f 17                	jg     1a1 <main+0x1a1>
      printf(1, "       %d.0%d", elapsed_secs, partial_elapsed_secs);
 18a:	ff 75 d4             	pushl  -0x2c(%ebp)
 18d:	ff 75 d8             	pushl  -0x28(%ebp)
 190:	68 7e 0a 00 00       	push   $0xa7e
 195:	6a 01                	push   $0x1
 197:	e8 90 04 00 00       	call   62c <printf>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	eb 15                	jmp    1b6 <main+0x1b6>
    else
      printf(1, "       %d.%d", elapsed_secs, partial_elapsed_secs);
 1a1:	ff 75 d4             	pushl  -0x2c(%ebp)
 1a4:	ff 75 d8             	pushl  -0x28(%ebp)
 1a7:	68 8c 0a 00 00       	push   $0xa8c
 1ac:	6a 01                	push   $0x1
 1ae:	e8 79 04 00 00       	call   62c <printf>
 1b3:	83 c4 10             	add    $0x10,%esp

    if (partial_cpu_secs < 10)
 1b6:	83 7d cc 09          	cmpl   $0x9,-0x34(%ebp)
 1ba:	7f 17                	jg     1d3 <main+0x1d3>
      printf(1, "       %d.0%d\n", total_cpu_secs, partial_cpu_secs);
 1bc:	ff 75 cc             	pushl  -0x34(%ebp)
 1bf:	ff 75 d0             	pushl  -0x30(%ebp)
 1c2:	68 99 0a 00 00       	push   $0xa99
 1c7:	6a 01                	push   $0x1
 1c9:	e8 5e 04 00 00       	call   62c <printf>
 1ce:	83 c4 10             	add    $0x10,%esp
 1d1:	eb 15                	jmp    1e8 <main+0x1e8>
    else
      printf(1, "       %d.%d\n", total_cpu_secs, partial_cpu_secs);
 1d3:	ff 75 cc             	pushl  -0x34(%ebp)
 1d6:	ff 75 d0             	pushl  -0x30(%ebp)
 1d9:	68 a8 0a 00 00       	push   $0xaa8
 1de:	6a 01                	push   $0x1
 1e0:	e8 47 04 00 00       	call   62c <printf>
 1e5:	83 c4 10             	add    $0x10,%esp
    printf(2, "Error. Malloc call failed.");
    return -1;
  }  
  int status = getprocs(MAX, table);
  printf(1, "Name       State         PID  UID  GID  PPID  Size       Elapsed       Total\n");
  for (int i = 0; i < status; ++i)
 1e8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1ef:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 1f2:	0f 8c 82 fe ff ff    	jl     7a <main+0x7a>
    if (partial_cpu_secs < 10)
      printf(1, "       %d.0%d\n", total_cpu_secs, partial_cpu_secs);
    else
      printf(1, "       %d.%d\n", total_cpu_secs, partial_cpu_secs);
  }
  printf(1, "%d system calls used.\n", status);
 1f8:	83 ec 04             	sub    $0x4,%esp
 1fb:	ff 75 dc             	pushl  -0x24(%ebp)
 1fe:	68 b6 0a 00 00       	push   $0xab6
 203:	6a 01                	push   $0x1
 205:	e8 22 04 00 00       	call   62c <printf>
 20a:	83 c4 10             	add    $0x10,%esp
  exit();
 20d:	e8 63 02 00 00       	call   475 <exit>
}
 212:	8d 65 f0             	lea    -0x10(%ebp),%esp
 215:	59                   	pop    %ecx
 216:	5b                   	pop    %ebx
 217:	5e                   	pop    %esi
 218:	5f                   	pop    %edi
 219:	5d                   	pop    %ebp
 21a:	8d 61 fc             	lea    -0x4(%ecx),%esp
 21d:	c3                   	ret    

0000021e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	57                   	push   %edi
 222:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 223:	8b 4d 08             	mov    0x8(%ebp),%ecx
 226:	8b 55 10             	mov    0x10(%ebp),%edx
 229:	8b 45 0c             	mov    0xc(%ebp),%eax
 22c:	89 cb                	mov    %ecx,%ebx
 22e:	89 df                	mov    %ebx,%edi
 230:	89 d1                	mov    %edx,%ecx
 232:	fc                   	cld    
 233:	f3 aa                	rep stos %al,%es:(%edi)
 235:	89 ca                	mov    %ecx,%edx
 237:	89 fb                	mov    %edi,%ebx
 239:	89 5d 08             	mov    %ebx,0x8(%ebp)
 23c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 23f:	90                   	nop
 240:	5b                   	pop    %ebx
 241:	5f                   	pop    %edi
 242:	5d                   	pop    %ebp
 243:	c3                   	ret    

00000244 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 250:	90                   	nop
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	8d 50 01             	lea    0x1(%eax),%edx
 257:	89 55 08             	mov    %edx,0x8(%ebp)
 25a:	8b 55 0c             	mov    0xc(%ebp),%edx
 25d:	8d 4a 01             	lea    0x1(%edx),%ecx
 260:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 263:	0f b6 12             	movzbl (%edx),%edx
 266:	88 10                	mov    %dl,(%eax)
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	84 c0                	test   %al,%al
 26d:	75 e2                	jne    251 <strcpy+0xd>
    ;
  return os;
 26f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 272:	c9                   	leave  
 273:	c3                   	ret    

00000274 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 277:	eb 08                	jmp    281 <strcmp+0xd>
    p++, q++;
 279:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 27d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	84 c0                	test   %al,%al
 289:	74 10                	je     29b <strcmp+0x27>
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	0f b6 10             	movzbl (%eax),%edx
 291:	8b 45 0c             	mov    0xc(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	38 c2                	cmp    %al,%dl
 299:	74 de                	je     279 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	0f b6 d0             	movzbl %al,%edx
 2a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a7:	0f b6 00             	movzbl (%eax),%eax
 2aa:	0f b6 c0             	movzbl %al,%eax
 2ad:	29 c2                	sub    %eax,%edx
 2af:	89 d0                	mov    %edx,%eax
}
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    

000002b3 <strlen>:

uint
strlen(char *s)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2c0:	eb 04                	jmp    2c6 <strlen+0x13>
 2c2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	01 d0                	add    %edx,%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	84 c0                	test   %al,%al
 2d3:	75 ed                	jne    2c2 <strlen+0xf>
    ;
  return n;
 2d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d8:	c9                   	leave  
 2d9:	c3                   	ret    

000002da <memset>:

void*
memset(void *dst, int c, uint n)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2dd:	8b 45 10             	mov    0x10(%ebp),%eax
 2e0:	50                   	push   %eax
 2e1:	ff 75 0c             	pushl  0xc(%ebp)
 2e4:	ff 75 08             	pushl  0x8(%ebp)
 2e7:	e8 32 ff ff ff       	call   21e <stosb>
 2ec:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f2:	c9                   	leave  
 2f3:	c3                   	ret    

000002f4 <strchr>:

char*
strchr(const char *s, char c)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	83 ec 04             	sub    $0x4,%esp
 2fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 300:	eb 14                	jmp    316 <strchr+0x22>
    if(*s == c)
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	0f b6 00             	movzbl (%eax),%eax
 308:	3a 45 fc             	cmp    -0x4(%ebp),%al
 30b:	75 05                	jne    312 <strchr+0x1e>
      return (char*)s;
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	eb 13                	jmp    325 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 312:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	84 c0                	test   %al,%al
 31e:	75 e2                	jne    302 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 320:	b8 00 00 00 00       	mov    $0x0,%eax
}
 325:	c9                   	leave  
 326:	c3                   	ret    

00000327 <gets>:

char*
gets(char *buf, int max)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 334:	eb 42                	jmp    378 <gets+0x51>
    cc = read(0, &c, 1);
 336:	83 ec 04             	sub    $0x4,%esp
 339:	6a 01                	push   $0x1
 33b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 33e:	50                   	push   %eax
 33f:	6a 00                	push   $0x0
 341:	e8 47 01 00 00       	call   48d <read>
 346:	83 c4 10             	add    $0x10,%esp
 349:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 34c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 350:	7e 33                	jle    385 <gets+0x5e>
      break;
    buf[i++] = c;
 352:	8b 45 f4             	mov    -0xc(%ebp),%eax
 355:	8d 50 01             	lea    0x1(%eax),%edx
 358:	89 55 f4             	mov    %edx,-0xc(%ebp)
 35b:	89 c2                	mov    %eax,%edx
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
 360:	01 c2                	add    %eax,%edx
 362:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 366:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 368:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 36c:	3c 0a                	cmp    $0xa,%al
 36e:	74 16                	je     386 <gets+0x5f>
 370:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 374:	3c 0d                	cmp    $0xd,%al
 376:	74 0e                	je     386 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 378:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37b:	83 c0 01             	add    $0x1,%eax
 37e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 381:	7c b3                	jl     336 <gets+0xf>
 383:	eb 01                	jmp    386 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 385:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 386:	8b 55 f4             	mov    -0xc(%ebp),%edx
 389:	8b 45 08             	mov    0x8(%ebp),%eax
 38c:	01 d0                	add    %edx,%eax
 38e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 391:	8b 45 08             	mov    0x8(%ebp),%eax
}
 394:	c9                   	leave  
 395:	c3                   	ret    

00000396 <stat>:

int
stat(char *n, struct stat *st)
{
 396:	55                   	push   %ebp
 397:	89 e5                	mov    %esp,%ebp
 399:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 39c:	83 ec 08             	sub    $0x8,%esp
 39f:	6a 00                	push   $0x0
 3a1:	ff 75 08             	pushl  0x8(%ebp)
 3a4:	e8 0c 01 00 00       	call   4b5 <open>
 3a9:	83 c4 10             	add    $0x10,%esp
 3ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3b3:	79 07                	jns    3bc <stat+0x26>
    return -1;
 3b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ba:	eb 25                	jmp    3e1 <stat+0x4b>
  r = fstat(fd, st);
 3bc:	83 ec 08             	sub    $0x8,%esp
 3bf:	ff 75 0c             	pushl  0xc(%ebp)
 3c2:	ff 75 f4             	pushl  -0xc(%ebp)
 3c5:	e8 03 01 00 00       	call   4cd <fstat>
 3ca:	83 c4 10             	add    $0x10,%esp
 3cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3d0:	83 ec 0c             	sub    $0xc,%esp
 3d3:	ff 75 f4             	pushl  -0xc(%ebp)
 3d6:	e8 c2 00 00 00       	call   49d <close>
 3db:	83 c4 10             	add    $0x10,%esp
  return r;
 3de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3e1:	c9                   	leave  
 3e2:	c3                   	ret    

000003e3 <atoi>:

int
atoi(const char *s)
{
 3e3:	55                   	push   %ebp
 3e4:	89 e5                	mov    %esp,%ebp
 3e6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3f0:	eb 25                	jmp    417 <atoi+0x34>
    n = n*10 + *s++ - '0';
 3f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f5:	89 d0                	mov    %edx,%eax
 3f7:	c1 e0 02             	shl    $0x2,%eax
 3fa:	01 d0                	add    %edx,%eax
 3fc:	01 c0                	add    %eax,%eax
 3fe:	89 c1                	mov    %eax,%ecx
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	8d 50 01             	lea    0x1(%eax),%edx
 406:	89 55 08             	mov    %edx,0x8(%ebp)
 409:	0f b6 00             	movzbl (%eax),%eax
 40c:	0f be c0             	movsbl %al,%eax
 40f:	01 c8                	add    %ecx,%eax
 411:	83 e8 30             	sub    $0x30,%eax
 414:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 417:	8b 45 08             	mov    0x8(%ebp),%eax
 41a:	0f b6 00             	movzbl (%eax),%eax
 41d:	3c 2f                	cmp    $0x2f,%al
 41f:	7e 0a                	jle    42b <atoi+0x48>
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	0f b6 00             	movzbl (%eax),%eax
 427:	3c 39                	cmp    $0x39,%al
 429:	7e c7                	jle    3f2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 42b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 42e:	c9                   	leave  
 42f:	c3                   	ret    

00000430 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 43c:	8b 45 0c             	mov    0xc(%ebp),%eax
 43f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 442:	eb 17                	jmp    45b <memmove+0x2b>
    *dst++ = *src++;
 444:	8b 45 fc             	mov    -0x4(%ebp),%eax
 447:	8d 50 01             	lea    0x1(%eax),%edx
 44a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 44d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 450:	8d 4a 01             	lea    0x1(%edx),%ecx
 453:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 456:	0f b6 12             	movzbl (%edx),%edx
 459:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 45b:	8b 45 10             	mov    0x10(%ebp),%eax
 45e:	8d 50 ff             	lea    -0x1(%eax),%edx
 461:	89 55 10             	mov    %edx,0x10(%ebp)
 464:	85 c0                	test   %eax,%eax
 466:	7f dc                	jg     444 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 468:	8b 45 08             	mov    0x8(%ebp),%eax
}
 46b:	c9                   	leave  
 46c:	c3                   	ret    

0000046d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 46d:	b8 01 00 00 00       	mov    $0x1,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <exit>:
SYSCALL(exit)
 475:	b8 02 00 00 00       	mov    $0x2,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <wait>:
SYSCALL(wait)
 47d:	b8 03 00 00 00       	mov    $0x3,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <pipe>:
SYSCALL(pipe)
 485:	b8 04 00 00 00       	mov    $0x4,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <read>:
SYSCALL(read)
 48d:	b8 05 00 00 00       	mov    $0x5,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <write>:
SYSCALL(write)
 495:	b8 10 00 00 00       	mov    $0x10,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <close>:
SYSCALL(close)
 49d:	b8 15 00 00 00       	mov    $0x15,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <kill>:
SYSCALL(kill)
 4a5:	b8 06 00 00 00       	mov    $0x6,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <exec>:
SYSCALL(exec)
 4ad:	b8 07 00 00 00       	mov    $0x7,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <open>:
SYSCALL(open)
 4b5:	b8 0f 00 00 00       	mov    $0xf,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <mknod>:
SYSCALL(mknod)
 4bd:	b8 11 00 00 00       	mov    $0x11,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <unlink>:
SYSCALL(unlink)
 4c5:	b8 12 00 00 00       	mov    $0x12,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <fstat>:
SYSCALL(fstat)
 4cd:	b8 08 00 00 00       	mov    $0x8,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <link>:
SYSCALL(link)
 4d5:	b8 13 00 00 00       	mov    $0x13,%eax
 4da:	cd 40                	int    $0x40
 4dc:	c3                   	ret    

000004dd <mkdir>:
SYSCALL(mkdir)
 4dd:	b8 14 00 00 00       	mov    $0x14,%eax
 4e2:	cd 40                	int    $0x40
 4e4:	c3                   	ret    

000004e5 <chdir>:
SYSCALL(chdir)
 4e5:	b8 09 00 00 00       	mov    $0x9,%eax
 4ea:	cd 40                	int    $0x40
 4ec:	c3                   	ret    

000004ed <dup>:
SYSCALL(dup)
 4ed:	b8 0a 00 00 00       	mov    $0xa,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <getpid>:
SYSCALL(getpid)
 4f5:	b8 0b 00 00 00       	mov    $0xb,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <sbrk>:
SYSCALL(sbrk)
 4fd:	b8 0c 00 00 00       	mov    $0xc,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <sleep>:
SYSCALL(sleep)
 505:	b8 0d 00 00 00       	mov    $0xd,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <uptime>:
SYSCALL(uptime)
 50d:	b8 0e 00 00 00       	mov    $0xe,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <halt>:
SYSCALL(halt)
 515:	b8 16 00 00 00       	mov    $0x16,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <date>:
SYSCALL(date)      #p1
 51d:	b8 17 00 00 00       	mov    $0x17,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <getuid>:
SYSCALL(getuid)    #p2
 525:	b8 18 00 00 00       	mov    $0x18,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <getgid>:
SYSCALL(getgid)    #p2
 52d:	b8 19 00 00 00       	mov    $0x19,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <getppid>:
SYSCALL(getppid)   #p2
 535:	b8 1a 00 00 00       	mov    $0x1a,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <setuid>:
SYSCALL(setuid)    #p2
 53d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <setgid>:
SYSCALL(setgid)    #p2
 545:	b8 1c 00 00 00       	mov    $0x1c,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <getprocs>:
SYSCALL(getprocs)  #p2
 54d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 555:	55                   	push   %ebp
 556:	89 e5                	mov    %esp,%ebp
 558:	83 ec 18             	sub    $0x18,%esp
 55b:	8b 45 0c             	mov    0xc(%ebp),%eax
 55e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 561:	83 ec 04             	sub    $0x4,%esp
 564:	6a 01                	push   $0x1
 566:	8d 45 f4             	lea    -0xc(%ebp),%eax
 569:	50                   	push   %eax
 56a:	ff 75 08             	pushl  0x8(%ebp)
 56d:	e8 23 ff ff ff       	call   495 <write>
 572:	83 c4 10             	add    $0x10,%esp
}
 575:	90                   	nop
 576:	c9                   	leave  
 577:	c3                   	ret    

00000578 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	53                   	push   %ebx
 57c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 57f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 586:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 58a:	74 17                	je     5a3 <printint+0x2b>
 58c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 590:	79 11                	jns    5a3 <printint+0x2b>
    neg = 1;
 592:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 599:	8b 45 0c             	mov    0xc(%ebp),%eax
 59c:	f7 d8                	neg    %eax
 59e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a1:	eb 06                	jmp    5a9 <printint+0x31>
  } else {
    x = xx;
 5a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5b0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5b3:	8d 41 01             	lea    0x1(%ecx),%eax
 5b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5bf:	ba 00 00 00 00       	mov    $0x0,%edx
 5c4:	f7 f3                	div    %ebx
 5c6:	89 d0                	mov    %edx,%eax
 5c8:	0f b6 80 3c 0d 00 00 	movzbl 0xd3c(%eax),%eax
 5cf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5d9:	ba 00 00 00 00       	mov    $0x0,%edx
 5de:	f7 f3                	div    %ebx
 5e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e7:	75 c7                	jne    5b0 <printint+0x38>
  if(neg)
 5e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ed:	74 2d                	je     61c <printint+0xa4>
    buf[i++] = '-';
 5ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f2:	8d 50 01             	lea    0x1(%eax),%edx
 5f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5f8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5fd:	eb 1d                	jmp    61c <printint+0xa4>
    putc(fd, buf[i]);
 5ff:	8d 55 dc             	lea    -0x24(%ebp),%edx
 602:	8b 45 f4             	mov    -0xc(%ebp),%eax
 605:	01 d0                	add    %edx,%eax
 607:	0f b6 00             	movzbl (%eax),%eax
 60a:	0f be c0             	movsbl %al,%eax
 60d:	83 ec 08             	sub    $0x8,%esp
 610:	50                   	push   %eax
 611:	ff 75 08             	pushl  0x8(%ebp)
 614:	e8 3c ff ff ff       	call   555 <putc>
 619:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 61c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 624:	79 d9                	jns    5ff <printint+0x87>
    putc(fd, buf[i]);
}
 626:	90                   	nop
 627:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 62a:	c9                   	leave  
 62b:	c3                   	ret    

0000062c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 62c:	55                   	push   %ebp
 62d:	89 e5                	mov    %esp,%ebp
 62f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 632:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 639:	8d 45 0c             	lea    0xc(%ebp),%eax
 63c:	83 c0 04             	add    $0x4,%eax
 63f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 642:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 649:	e9 59 01 00 00       	jmp    7a7 <printf+0x17b>
    c = fmt[i] & 0xff;
 64e:	8b 55 0c             	mov    0xc(%ebp),%edx
 651:	8b 45 f0             	mov    -0x10(%ebp),%eax
 654:	01 d0                	add    %edx,%eax
 656:	0f b6 00             	movzbl (%eax),%eax
 659:	0f be c0             	movsbl %al,%eax
 65c:	25 ff 00 00 00       	and    $0xff,%eax
 661:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 664:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 668:	75 2c                	jne    696 <printf+0x6a>
      if(c == '%'){
 66a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66e:	75 0c                	jne    67c <printf+0x50>
        state = '%';
 670:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 677:	e9 27 01 00 00       	jmp    7a3 <printf+0x177>
      } else {
        putc(fd, c);
 67c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67f:	0f be c0             	movsbl %al,%eax
 682:	83 ec 08             	sub    $0x8,%esp
 685:	50                   	push   %eax
 686:	ff 75 08             	pushl  0x8(%ebp)
 689:	e8 c7 fe ff ff       	call   555 <putc>
 68e:	83 c4 10             	add    $0x10,%esp
 691:	e9 0d 01 00 00       	jmp    7a3 <printf+0x177>
      }
    } else if(state == '%'){
 696:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 69a:	0f 85 03 01 00 00    	jne    7a3 <printf+0x177>
      if(c == 'd'){
 6a0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6a4:	75 1e                	jne    6c4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	6a 01                	push   $0x1
 6ad:	6a 0a                	push   $0xa
 6af:	50                   	push   %eax
 6b0:	ff 75 08             	pushl  0x8(%ebp)
 6b3:	e8 c0 fe ff ff       	call   578 <printint>
 6b8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6bf:	e9 d8 00 00 00       	jmp    79c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6c4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6c8:	74 06                	je     6d0 <printf+0xa4>
 6ca:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6ce:	75 1e                	jne    6ee <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	6a 00                	push   $0x0
 6d7:	6a 10                	push   $0x10
 6d9:	50                   	push   %eax
 6da:	ff 75 08             	pushl  0x8(%ebp)
 6dd:	e8 96 fe ff ff       	call   578 <printint>
 6e2:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e9:	e9 ae 00 00 00       	jmp    79c <printf+0x170>
      } else if(c == 's'){
 6ee:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6f2:	75 43                	jne    737 <printf+0x10b>
        s = (char*)*ap;
 6f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 700:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 704:	75 25                	jne    72b <printf+0xff>
          s = "(null)";
 706:	c7 45 f4 cd 0a 00 00 	movl   $0xacd,-0xc(%ebp)
        while(*s != 0){
 70d:	eb 1c                	jmp    72b <printf+0xff>
          putc(fd, *s);
 70f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 712:	0f b6 00             	movzbl (%eax),%eax
 715:	0f be c0             	movsbl %al,%eax
 718:	83 ec 08             	sub    $0x8,%esp
 71b:	50                   	push   %eax
 71c:	ff 75 08             	pushl  0x8(%ebp)
 71f:	e8 31 fe ff ff       	call   555 <putc>
 724:	83 c4 10             	add    $0x10,%esp
          s++;
 727:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 72b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72e:	0f b6 00             	movzbl (%eax),%eax
 731:	84 c0                	test   %al,%al
 733:	75 da                	jne    70f <printf+0xe3>
 735:	eb 65                	jmp    79c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 737:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 73b:	75 1d                	jne    75a <printf+0x12e>
        putc(fd, *ap);
 73d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	0f be c0             	movsbl %al,%eax
 745:	83 ec 08             	sub    $0x8,%esp
 748:	50                   	push   %eax
 749:	ff 75 08             	pushl  0x8(%ebp)
 74c:	e8 04 fe ff ff       	call   555 <putc>
 751:	83 c4 10             	add    $0x10,%esp
        ap++;
 754:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 758:	eb 42                	jmp    79c <printf+0x170>
      } else if(c == '%'){
 75a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75e:	75 17                	jne    777 <printf+0x14b>
        putc(fd, c);
 760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 763:	0f be c0             	movsbl %al,%eax
 766:	83 ec 08             	sub    $0x8,%esp
 769:	50                   	push   %eax
 76a:	ff 75 08             	pushl  0x8(%ebp)
 76d:	e8 e3 fd ff ff       	call   555 <putc>
 772:	83 c4 10             	add    $0x10,%esp
 775:	eb 25                	jmp    79c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 777:	83 ec 08             	sub    $0x8,%esp
 77a:	6a 25                	push   $0x25
 77c:	ff 75 08             	pushl  0x8(%ebp)
 77f:	e8 d1 fd ff ff       	call   555 <putc>
 784:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78a:	0f be c0             	movsbl %al,%eax
 78d:	83 ec 08             	sub    $0x8,%esp
 790:	50                   	push   %eax
 791:	ff 75 08             	pushl  0x8(%ebp)
 794:	e8 bc fd ff ff       	call   555 <putc>
 799:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 79c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7a3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7a7:	8b 55 0c             	mov    0xc(%ebp),%edx
 7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ad:	01 d0                	add    %edx,%eax
 7af:	0f b6 00             	movzbl (%eax),%eax
 7b2:	84 c0                	test   %al,%al
 7b4:	0f 85 94 fe ff ff    	jne    64e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7ba:	90                   	nop
 7bb:	c9                   	leave  
 7bc:	c3                   	ret    

000007bd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7bd:	55                   	push   %ebp
 7be:	89 e5                	mov    %esp,%ebp
 7c0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	83 e8 08             	sub    $0x8,%eax
 7c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cc:	a1 58 0d 00 00       	mov    0xd58,%eax
 7d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d4:	eb 24                	jmp    7fa <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	8b 00                	mov    (%eax),%eax
 7db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7de:	77 12                	ja     7f2 <free+0x35>
 7e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e6:	77 24                	ja     80c <free+0x4f>
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f0:	77 1a                	ja     80c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f5:	8b 00                	mov    (%eax),%eax
 7f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 800:	76 d4                	jbe    7d6 <free+0x19>
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	8b 00                	mov    (%eax),%eax
 807:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80a:	76 ca                	jbe    7d6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 80c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 819:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81c:	01 c2                	add    %eax,%edx
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	8b 00                	mov    (%eax),%eax
 823:	39 c2                	cmp    %eax,%edx
 825:	75 24                	jne    84b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 827:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82a:	8b 50 04             	mov    0x4(%eax),%edx
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	8b 40 04             	mov    0x4(%eax),%eax
 835:	01 c2                	add    %eax,%edx
 837:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 83d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 840:	8b 00                	mov    (%eax),%eax
 842:	8b 10                	mov    (%eax),%edx
 844:	8b 45 f8             	mov    -0x8(%ebp),%eax
 847:	89 10                	mov    %edx,(%eax)
 849:	eb 0a                	jmp    855 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 84b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84e:	8b 10                	mov    (%eax),%edx
 850:	8b 45 f8             	mov    -0x8(%ebp),%eax
 853:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 40 04             	mov    0x4(%eax),%eax
 85b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 862:	8b 45 fc             	mov    -0x4(%ebp),%eax
 865:	01 d0                	add    %edx,%eax
 867:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 86a:	75 20                	jne    88c <free+0xcf>
    p->s.size += bp->s.size;
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	8b 50 04             	mov    0x4(%eax),%edx
 872:	8b 45 f8             	mov    -0x8(%ebp),%eax
 875:	8b 40 04             	mov    0x4(%eax),%eax
 878:	01 c2                	add    %eax,%edx
 87a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 880:	8b 45 f8             	mov    -0x8(%ebp),%eax
 883:	8b 10                	mov    (%eax),%edx
 885:	8b 45 fc             	mov    -0x4(%ebp),%eax
 888:	89 10                	mov    %edx,(%eax)
 88a:	eb 08                	jmp    894 <free+0xd7>
  } else
    p->s.ptr = bp;
 88c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 892:	89 10                	mov    %edx,(%eax)
  freep = p;
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	a3 58 0d 00 00       	mov    %eax,0xd58
}
 89c:	90                   	nop
 89d:	c9                   	leave  
 89e:	c3                   	ret    

0000089f <morecore>:

static Header*
morecore(uint nu)
{
 89f:	55                   	push   %ebp
 8a0:	89 e5                	mov    %esp,%ebp
 8a2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8a5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8ac:	77 07                	ja     8b5 <morecore+0x16>
    nu = 4096;
 8ae:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8b5:	8b 45 08             	mov    0x8(%ebp),%eax
 8b8:	c1 e0 03             	shl    $0x3,%eax
 8bb:	83 ec 0c             	sub    $0xc,%esp
 8be:	50                   	push   %eax
 8bf:	e8 39 fc ff ff       	call   4fd <sbrk>
 8c4:	83 c4 10             	add    $0x10,%esp
 8c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8ca:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8ce:	75 07                	jne    8d7 <morecore+0x38>
    return 0;
 8d0:	b8 00 00 00 00       	mov    $0x0,%eax
 8d5:	eb 26                	jmp    8fd <morecore+0x5e>
  hp = (Header*)p;
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e0:	8b 55 08             	mov    0x8(%ebp),%edx
 8e3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e9:	83 c0 08             	add    $0x8,%eax
 8ec:	83 ec 0c             	sub    $0xc,%esp
 8ef:	50                   	push   %eax
 8f0:	e8 c8 fe ff ff       	call   7bd <free>
 8f5:	83 c4 10             	add    $0x10,%esp
  return freep;
 8f8:	a1 58 0d 00 00       	mov    0xd58,%eax
}
 8fd:	c9                   	leave  
 8fe:	c3                   	ret    

000008ff <malloc>:

void*
malloc(uint nbytes)
{
 8ff:	55                   	push   %ebp
 900:	89 e5                	mov    %esp,%ebp
 902:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 905:	8b 45 08             	mov    0x8(%ebp),%eax
 908:	83 c0 07             	add    $0x7,%eax
 90b:	c1 e8 03             	shr    $0x3,%eax
 90e:	83 c0 01             	add    $0x1,%eax
 911:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 914:	a1 58 0d 00 00       	mov    0xd58,%eax
 919:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 920:	75 23                	jne    945 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 922:	c7 45 f0 50 0d 00 00 	movl   $0xd50,-0x10(%ebp)
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	a3 58 0d 00 00       	mov    %eax,0xd58
 931:	a1 58 0d 00 00       	mov    0xd58,%eax
 936:	a3 50 0d 00 00       	mov    %eax,0xd50
    base.s.size = 0;
 93b:	c7 05 54 0d 00 00 00 	movl   $0x0,0xd54
 942:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 945:	8b 45 f0             	mov    -0x10(%ebp),%eax
 948:	8b 00                	mov    (%eax),%eax
 94a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 94d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 950:	8b 40 04             	mov    0x4(%eax),%eax
 953:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 956:	72 4d                	jb     9a5 <malloc+0xa6>
      if(p->s.size == nunits)
 958:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95b:	8b 40 04             	mov    0x4(%eax),%eax
 95e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 961:	75 0c                	jne    96f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	8b 10                	mov    (%eax),%edx
 968:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96b:	89 10                	mov    %edx,(%eax)
 96d:	eb 26                	jmp    995 <malloc+0x96>
      else {
        p->s.size -= nunits;
 96f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 972:	8b 40 04             	mov    0x4(%eax),%eax
 975:	2b 45 ec             	sub    -0x14(%ebp),%eax
 978:	89 c2                	mov    %eax,%edx
 97a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 980:	8b 45 f4             	mov    -0xc(%ebp),%eax
 983:	8b 40 04             	mov    0x4(%eax),%eax
 986:	c1 e0 03             	shl    $0x3,%eax
 989:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 98c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 992:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 995:	8b 45 f0             	mov    -0x10(%ebp),%eax
 998:	a3 58 0d 00 00       	mov    %eax,0xd58
      return (void*)(p + 1);
 99d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a0:	83 c0 08             	add    $0x8,%eax
 9a3:	eb 3b                	jmp    9e0 <malloc+0xe1>
    }
    if(p == freep)
 9a5:	a1 58 0d 00 00       	mov    0xd58,%eax
 9aa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9ad:	75 1e                	jne    9cd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9af:	83 ec 0c             	sub    $0xc,%esp
 9b2:	ff 75 ec             	pushl  -0x14(%ebp)
 9b5:	e8 e5 fe ff ff       	call   89f <morecore>
 9ba:	83 c4 10             	add    $0x10,%esp
 9bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9c4:	75 07                	jne    9cd <malloc+0xce>
        return 0;
 9c6:	b8 00 00 00 00       	mov    $0x0,%eax
 9cb:	eb 13                	jmp    9e0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d6:	8b 00                	mov    (%eax),%eax
 9d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9db:	e9 6d ff ff ff       	jmp    94d <malloc+0x4e>
}
 9e0:	c9                   	leave  
 9e1:	c3                   	ret    
