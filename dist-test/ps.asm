
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
  11:	83 ec 38             	sub    $0x38,%esp
  struct uproc* table = malloc(MAX*sizeof(struct uproc));
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	68 00 18 00 00       	push   $0x1800
  1c:	e8 ac 09 00 00       	call   9cd <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if (!table) 
  27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  2b:	75 17                	jne    44 <main+0x44>
  {
    printf(2, "Error. Malloc call failed.");
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	68 b0 0a 00 00       	push   $0xab0
  35:	6a 02                	push   $0x2
  37:	e8 be 06 00 00       	call   6fa <printf>
  3c:	83 c4 10             	add    $0x10,%esp
    exit();
  3f:	e8 f7 04 00 00       	call   53b <exit>
  }
 
  printf(1, "Max value: %d\n", MAX); 
  44:	83 ec 04             	sub    $0x4,%esp
  47:	6a 40                	push   $0x40
  49:	68 cb 0a 00 00       	push   $0xacb
  4e:	6a 01                	push   $0x1
  50:	e8 a5 06 00 00       	call   6fa <printf>
  55:	83 c4 10             	add    $0x10,%esp
  int status = getprocs(MAX, table);
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	ff 75 e0             	pushl  -0x20(%ebp)
  5e:	6a 40                	push   $0x40
  60:	e8 ae 05 00 00       	call   613 <getprocs>
  65:	83 c4 10             	add    $0x10,%esp
  68:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (status < 0)
  6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  6f:	79 17                	jns    88 <main+0x88>
    printf(2, "Error. Not enough memory for the table.\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 dc 0a 00 00       	push   $0xadc
  79:	6a 02                	push   $0x2
  7b:	e8 7a 06 00 00       	call   6fa <printf>
  80:	83 c4 10             	add    $0x10,%esp
  83:	e9 12 02 00 00       	jmp    29a <main+0x29a>
  else
  {
    printf(1, "PID\t Name\t UID\t GID\t PPID\t Prio\t Elapsed  CPU\t State\t Size\n");
  88:	83 ec 08             	sub    $0x8,%esp
  8b:	68 08 0b 00 00       	push   $0xb08
  90:	6a 01                	push   $0x1
  92:	e8 63 06 00 00       	call   6fa <printf>
  97:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < status; ++i)
  9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  a1:	e9 e8 01 00 00       	jmp    28e <main+0x28e>
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
  a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  a9:	89 d0                	mov    %edx,%eax
  ab:	01 c0                	add    %eax,%eax
  ad:	01 d0                	add    %edx,%eax
  af:	c1 e0 05             	shl    $0x5,%eax
  b2:	89 c2                	mov    %eax,%edx
  b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b7:	01 d0                	add    %edx,%eax
  b9:	8b 40 14             	mov    0x14(%eax),%eax
  bc:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  c1:	f7 e2                	mul    %edx
  c3:	89 d0                	mov    %edx,%eax
  c5:	c1 e8 05             	shr    $0x5,%eax
  c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
  cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  ce:	89 d0                	mov    %edx,%eax
  d0:	01 c0                	add    %eax,%eax
  d2:	01 d0                	add    %edx,%eax
  d4:	c1 e0 05             	shl    $0x5,%eax
  d7:	89 c2                	mov    %eax,%edx
  d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  dc:	01 d0                	add    %edx,%eax
  de:	8b 48 14             	mov    0x14(%eax),%ecx
  e1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  e6:	89 c8                	mov    %ecx,%eax
  e8:	f7 e2                	mul    %edx
  ea:	89 d0                	mov    %edx,%eax
  ec:	c1 e8 05             	shr    $0x5,%eax
  ef:	6b c0 64             	imul   $0x64,%eax,%eax
  f2:	29 c1                	sub    %eax,%ecx
  f4:	89 c8                	mov    %ecx,%eax
  f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      int total_cpu_secs = table[i].CPU_total_ticks/100;
  f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  fc:	89 d0                	mov    %edx,%eax
  fe:	01 c0                	add    %eax,%eax
 100:	01 d0                	add    %edx,%eax
 102:	c1 e0 05             	shl    $0x5,%eax
 105:	89 c2                	mov    %eax,%edx
 107:	8b 45 e0             	mov    -0x20(%ebp),%eax
 10a:	01 d0                	add    %edx,%eax
 10c:	8b 40 18             	mov    0x18(%eax),%eax
 10f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 114:	f7 e2                	mul    %edx
 116:	89 d0                	mov    %edx,%eax
 118:	c1 e8 05             	shr    $0x5,%eax
 11b:	89 45 d0             	mov    %eax,-0x30(%ebp)
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
 11e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 121:	89 d0                	mov    %edx,%eax
 123:	01 c0                	add    %eax,%eax
 125:	01 d0                	add    %edx,%eax
 127:	c1 e0 05             	shl    $0x5,%eax
 12a:	89 c2                	mov    %eax,%edx
 12c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 12f:	01 d0                	add    %edx,%eax
 131:	8b 48 18             	mov    0x18(%eax),%ecx
 134:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 139:	89 c8                	mov    %ecx,%eax
 13b:	f7 e2                	mul    %edx
 13d:	89 d0                	mov    %edx,%eax
 13f:	c1 e8 05             	shr    $0x5,%eax
 142:	6b c0 64             	imul   $0x64,%eax,%eax
 145:	29 c1                	sub    %eax,%ecx
 147:	89 c8                	mov    %ecx,%eax
 149:	89 45 cc             	mov    %eax,-0x34(%ebp)
      printf(1, "%d\t %s\t %d\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
            table[i].gid, table[i].ppid, table[i].priority);
 14c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 14f:	89 d0                	mov    %edx,%eax
 151:	01 c0                	add    %eax,%eax
 153:	01 d0                	add    %edx,%eax
 155:	c1 e0 05             	shl    $0x5,%eax
 158:	89 c2                	mov    %eax,%edx
 15a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 15d:	01 d0                	add    %edx,%eax
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%d\t %s\t %d\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
 15f:	8b 78 10             	mov    0x10(%eax),%edi
            table[i].gid, table[i].ppid, table[i].priority);
 162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 165:	89 d0                	mov    %edx,%eax
 167:	01 c0                	add    %eax,%eax
 169:	01 d0                	add    %edx,%eax
 16b:	c1 e0 05             	shl    $0x5,%eax
 16e:	89 c2                	mov    %eax,%edx
 170:	8b 45 e0             	mov    -0x20(%ebp),%eax
 173:	01 d0                	add    %edx,%eax
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%d\t %s\t %d\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
 175:	8b 70 0c             	mov    0xc(%eax),%esi
            table[i].gid, table[i].ppid, table[i].priority);
 178:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 17b:	89 d0                	mov    %edx,%eax
 17d:	01 c0                	add    %eax,%eax
 17f:	01 d0                	add    %edx,%eax
 181:	c1 e0 05             	shl    $0x5,%eax
 184:	89 c2                	mov    %eax,%edx
 186:	8b 45 e0             	mov    -0x20(%ebp),%eax
 189:	01 d0                	add    %edx,%eax
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%d\t %s\t %d\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
 18b:	8b 58 08             	mov    0x8(%eax),%ebx
 18e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 191:	89 d0                	mov    %edx,%eax
 193:	01 c0                	add    %eax,%eax
 195:	01 d0                	add    %edx,%eax
 197:	c1 e0 05             	shl    $0x5,%eax
 19a:	89 c2                	mov    %eax,%edx
 19c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 19f:	01 d0                	add    %edx,%eax
 1a1:	8b 48 04             	mov    0x4(%eax),%ecx
 1a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1a7:	89 d0                	mov    %edx,%eax
 1a9:	01 c0                	add    %eax,%eax
 1ab:	01 d0                	add    %edx,%eax
 1ad:	c1 e0 05             	shl    $0x5,%eax
 1b0:	89 c2                	mov    %eax,%edx
 1b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1b5:	01 d0                	add    %edx,%eax
 1b7:	83 c0 40             	add    $0x40,%eax
 1ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 1bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1c0:	89 d0                	mov    %edx,%eax
 1c2:	01 c0                	add    %eax,%eax
 1c4:	01 d0                	add    %edx,%eax
 1c6:	c1 e0 05             	shl    $0x5,%eax
 1c9:	89 c2                	mov    %eax,%edx
 1cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1ce:	01 d0                	add    %edx,%eax
 1d0:	8b 00                	mov    (%eax),%eax
 1d2:	57                   	push   %edi
 1d3:	56                   	push   %esi
 1d4:	53                   	push   %ebx
 1d5:	51                   	push   %ecx
 1d6:	ff 75 c4             	pushl  -0x3c(%ebp)
 1d9:	50                   	push   %eax
 1da:	68 44 0b 00 00       	push   $0xb44
 1df:	6a 01                	push   $0x1
 1e1:	e8 14 05 00 00       	call   6fa <printf>
 1e6:	83 c4 20             	add    $0x20,%esp
            table[i].gid, table[i].ppid, table[i].priority);
    
      if (partial_elapsed_secs < 10)
 1e9:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
 1ed:	7f 17                	jg     206 <main+0x206>
        printf(1, " %d.0%d", elapsed_secs, partial_elapsed_secs);
 1ef:	ff 75 d4             	pushl  -0x2c(%ebp)
 1f2:	ff 75 d8             	pushl  -0x28(%ebp)
 1f5:	68 5c 0b 00 00       	push   $0xb5c
 1fa:	6a 01                	push   $0x1
 1fc:	e8 f9 04 00 00       	call   6fa <printf>
 201:	83 c4 10             	add    $0x10,%esp
 204:	eb 15                	jmp    21b <main+0x21b>
      else
        printf(1, " %d.%d", elapsed_secs, partial_elapsed_secs);
 206:	ff 75 d4             	pushl  -0x2c(%ebp)
 209:	ff 75 d8             	pushl  -0x28(%ebp)
 20c:	68 64 0b 00 00       	push   $0xb64
 211:	6a 01                	push   $0x1
 213:	e8 e2 04 00 00       	call   6fa <printf>
 218:	83 c4 10             	add    $0x10,%esp

      if (partial_cpu_secs < 10)
 21b:	83 7d cc 09          	cmpl   $0x9,-0x34(%ebp)
 21f:	7f 17                	jg     238 <main+0x238>
        printf(1, "     %d.0%d\t", total_cpu_secs, partial_cpu_secs);
 221:	ff 75 cc             	pushl  -0x34(%ebp)
 224:	ff 75 d0             	pushl  -0x30(%ebp)
 227:	68 6b 0b 00 00       	push   $0xb6b
 22c:	6a 01                	push   $0x1
 22e:	e8 c7 04 00 00       	call   6fa <printf>
 233:	83 c4 10             	add    $0x10,%esp
 236:	eb 15                	jmp    24d <main+0x24d>
      else
        printf(1, "     %d.%d\t", total_cpu_secs, partial_cpu_secs);
 238:	ff 75 cc             	pushl  -0x34(%ebp)
 23b:	ff 75 d0             	pushl  -0x30(%ebp)
 23e:	68 78 0b 00 00       	push   $0xb78
 243:	6a 01                	push   $0x1
 245:	e8 b0 04 00 00       	call   6fa <printf>
 24a:	83 c4 10             	add    $0x10,%esp

      printf(1, " %s\t %d\n", table[i].state, table[i].size);
 24d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 250:	89 d0                	mov    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	01 d0                	add    %edx,%eax
 256:	c1 e0 05             	shl    $0x5,%eax
 259:	89 c2                	mov    %eax,%edx
 25b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 25e:	01 d0                	add    %edx,%eax
 260:	8b 48 3c             	mov    0x3c(%eax),%ecx
 263:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 266:	89 d0                	mov    %edx,%eax
 268:	01 c0                	add    %eax,%eax
 26a:	01 d0                	add    %edx,%eax
 26c:	c1 e0 05             	shl    $0x5,%eax
 26f:	89 c2                	mov    %eax,%edx
 271:	8b 45 e0             	mov    -0x20(%ebp),%eax
 274:	01 d0                	add    %edx,%eax
 276:	83 c0 1c             	add    $0x1c,%eax
 279:	51                   	push   %ecx
 27a:	50                   	push   %eax
 27b:	68 84 0b 00 00       	push   $0xb84
 280:	6a 01                	push   $0x1
 282:	e8 73 04 00 00       	call   6fa <printf>
 287:	83 c4 10             	add    $0x10,%esp
  if (status < 0)
    printf(2, "Error. Not enough memory for the table.\n");
  else
  {
    printf(1, "PID\t Name\t UID\t GID\t PPID\t Prio\t Elapsed  CPU\t State\t Size\n");
    for (int i = 0; i < status; ++i)
 28a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 28e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 291:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 294:	0f 8c 0c fe ff ff    	jl     a6 <main+0xa6>
        printf(1, "     %d.%d\t", total_cpu_secs, partial_cpu_secs);

      printf(1, " %s\t %d\n", table[i].state, table[i].size);
    }
  }
  exit();
 29a:	e8 9c 02 00 00       	call   53b <exit>

0000029f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	57                   	push   %edi
 2a3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a7:	8b 55 10             	mov    0x10(%ebp),%edx
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 cb                	mov    %ecx,%ebx
 2af:	89 df                	mov    %ebx,%edi
 2b1:	89 d1                	mov    %edx,%ecx
 2b3:	fc                   	cld    
 2b4:	f3 aa                	rep stos %al,%es:(%edi)
 2b6:	89 ca                	mov    %ecx,%edx
 2b8:	89 fb                	mov    %edi,%ebx
 2ba:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2bd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2c0:	90                   	nop
 2c1:	5b                   	pop    %ebx
 2c2:	5f                   	pop    %edi
 2c3:	5d                   	pop    %ebp
 2c4:	c3                   	ret    

000002c5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2c5:	55                   	push   %ebp
 2c6:	89 e5                	mov    %esp,%ebp
 2c8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2d1:	90                   	nop
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	8d 50 01             	lea    0x1(%eax),%edx
 2d8:	89 55 08             	mov    %edx,0x8(%ebp)
 2db:	8b 55 0c             	mov    0xc(%ebp),%edx
 2de:	8d 4a 01             	lea    0x1(%edx),%ecx
 2e1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2e4:	0f b6 12             	movzbl (%edx),%edx
 2e7:	88 10                	mov    %dl,(%eax)
 2e9:	0f b6 00             	movzbl (%eax),%eax
 2ec:	84 c0                	test   %al,%al
 2ee:	75 e2                	jne    2d2 <strcpy+0xd>
    ;
  return os;
 2f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f3:	c9                   	leave  
 2f4:	c3                   	ret    

000002f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2f8:	eb 08                	jmp    302 <strcmp+0xd>
    p++, q++;
 2fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2fe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	0f b6 00             	movzbl (%eax),%eax
 308:	84 c0                	test   %al,%al
 30a:	74 10                	je     31c <strcmp+0x27>
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	0f b6 10             	movzbl (%eax),%edx
 312:	8b 45 0c             	mov    0xc(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	38 c2                	cmp    %al,%dl
 31a:	74 de                	je     2fa <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	0f b6 00             	movzbl (%eax),%eax
 322:	0f b6 d0             	movzbl %al,%edx
 325:	8b 45 0c             	mov    0xc(%ebp),%eax
 328:	0f b6 00             	movzbl (%eax),%eax
 32b:	0f b6 c0             	movzbl %al,%eax
 32e:	29 c2                	sub    %eax,%edx
 330:	89 d0                	mov    %edx,%eax
}
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    

00000334 <strlen>:

uint
strlen(char *s)
{
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 33a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 341:	eb 04                	jmp    347 <strlen+0x13>
 343:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 347:	8b 55 fc             	mov    -0x4(%ebp),%edx
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	01 d0                	add    %edx,%eax
 34f:	0f b6 00             	movzbl (%eax),%eax
 352:	84 c0                	test   %al,%al
 354:	75 ed                	jne    343 <strlen+0xf>
    ;
  return n;
 356:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <memset>:

void*
memset(void *dst, int c, uint n)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 35e:	8b 45 10             	mov    0x10(%ebp),%eax
 361:	50                   	push   %eax
 362:	ff 75 0c             	pushl  0xc(%ebp)
 365:	ff 75 08             	pushl  0x8(%ebp)
 368:	e8 32 ff ff ff       	call   29f <stosb>
 36d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 370:	8b 45 08             	mov    0x8(%ebp),%eax
}
 373:	c9                   	leave  
 374:	c3                   	ret    

00000375 <strchr>:

char*
strchr(const char *s, char c)
{
 375:	55                   	push   %ebp
 376:	89 e5                	mov    %esp,%ebp
 378:	83 ec 04             	sub    $0x4,%esp
 37b:	8b 45 0c             	mov    0xc(%ebp),%eax
 37e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 381:	eb 14                	jmp    397 <strchr+0x22>
    if(*s == c)
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	0f b6 00             	movzbl (%eax),%eax
 389:	3a 45 fc             	cmp    -0x4(%ebp),%al
 38c:	75 05                	jne    393 <strchr+0x1e>
      return (char*)s;
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	eb 13                	jmp    3a6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 393:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	0f b6 00             	movzbl (%eax),%eax
 39d:	84 c0                	test   %al,%al
 39f:	75 e2                	jne    383 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <gets>:

char*
gets(char *buf, int max)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3b5:	eb 42                	jmp    3f9 <gets+0x51>
    cc = read(0, &c, 1);
 3b7:	83 ec 04             	sub    $0x4,%esp
 3ba:	6a 01                	push   $0x1
 3bc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3bf:	50                   	push   %eax
 3c0:	6a 00                	push   $0x0
 3c2:	e8 8c 01 00 00       	call   553 <read>
 3c7:	83 c4 10             	add    $0x10,%esp
 3ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d1:	7e 33                	jle    406 <gets+0x5e>
      break;
    buf[i++] = c;
 3d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d6:	8d 50 01             	lea    0x1(%eax),%edx
 3d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3dc:	89 c2                	mov    %eax,%edx
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	01 c2                	add    %eax,%edx
 3e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3e7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3e9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3ed:	3c 0a                	cmp    $0xa,%al
 3ef:	74 16                	je     407 <gets+0x5f>
 3f1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f5:	3c 0d                	cmp    $0xd,%al
 3f7:	74 0e                	je     407 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fc:	83 c0 01             	add    $0x1,%eax
 3ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
 402:	7c b3                	jl     3b7 <gets+0xf>
 404:	eb 01                	jmp    407 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 406:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 407:	8b 55 f4             	mov    -0xc(%ebp),%edx
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
 40d:	01 d0                	add    %edx,%eax
 40f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 412:	8b 45 08             	mov    0x8(%ebp),%eax
}
 415:	c9                   	leave  
 416:	c3                   	ret    

00000417 <stat>:

int
stat(char *n, struct stat *st)
{
 417:	55                   	push   %ebp
 418:	89 e5                	mov    %esp,%ebp
 41a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 41d:	83 ec 08             	sub    $0x8,%esp
 420:	6a 00                	push   $0x0
 422:	ff 75 08             	pushl  0x8(%ebp)
 425:	e8 51 01 00 00       	call   57b <open>
 42a:	83 c4 10             	add    $0x10,%esp
 42d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 434:	79 07                	jns    43d <stat+0x26>
    return -1;
 436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 43b:	eb 25                	jmp    462 <stat+0x4b>
  r = fstat(fd, st);
 43d:	83 ec 08             	sub    $0x8,%esp
 440:	ff 75 0c             	pushl  0xc(%ebp)
 443:	ff 75 f4             	pushl  -0xc(%ebp)
 446:	e8 48 01 00 00       	call   593 <fstat>
 44b:	83 c4 10             	add    $0x10,%esp
 44e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 451:	83 ec 0c             	sub    $0xc,%esp
 454:	ff 75 f4             	pushl  -0xc(%ebp)
 457:	e8 07 01 00 00       	call   563 <close>
 45c:	83 c4 10             	add    $0x10,%esp
  return r;
 45f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 462:	c9                   	leave  
 463:	c3                   	ret    

00000464 <atoi>:

int
atoi(const char *s)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 46a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 471:	eb 04                	jmp    477 <atoi+0x13>
 473:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	0f b6 00             	movzbl (%eax),%eax
 47d:	3c 20                	cmp    $0x20,%al
 47f:	74 f2                	je     473 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	0f b6 00             	movzbl (%eax),%eax
 487:	3c 2d                	cmp    $0x2d,%al
 489:	75 07                	jne    492 <atoi+0x2e>
 48b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 490:	eb 05                	jmp    497 <atoi+0x33>
 492:	b8 01 00 00 00       	mov    $0x1,%eax
 497:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	3c 2b                	cmp    $0x2b,%al
 4a2:	74 0a                	je     4ae <atoi+0x4a>
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	0f b6 00             	movzbl (%eax),%eax
 4aa:	3c 2d                	cmp    $0x2d,%al
 4ac:	75 2b                	jne    4d9 <atoi+0x75>
    s++;
 4ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 4b2:	eb 25                	jmp    4d9 <atoi+0x75>
    n = n*10 + *s++ - '0';
 4b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4b7:	89 d0                	mov    %edx,%eax
 4b9:	c1 e0 02             	shl    $0x2,%eax
 4bc:	01 d0                	add    %edx,%eax
 4be:	01 c0                	add    %eax,%eax
 4c0:	89 c1                	mov    %eax,%ecx
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
 4c5:	8d 50 01             	lea    0x1(%eax),%edx
 4c8:	89 55 08             	mov    %edx,0x8(%ebp)
 4cb:	0f b6 00             	movzbl (%eax),%eax
 4ce:	0f be c0             	movsbl %al,%eax
 4d1:	01 c8                	add    %ecx,%eax
 4d3:	83 e8 30             	sub    $0x30,%eax
 4d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	0f b6 00             	movzbl (%eax),%eax
 4df:	3c 2f                	cmp    $0x2f,%al
 4e1:	7e 0a                	jle    4ed <atoi+0x89>
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	0f b6 00             	movzbl (%eax),%eax
 4e9:	3c 39                	cmp    $0x39,%al
 4eb:	7e c7                	jle    4b4 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 4ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4f0:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4f4:	c9                   	leave  
 4f5:	c3                   	ret    

000004f6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4f6:	55                   	push   %ebp
 4f7:	89 e5                	mov    %esp,%ebp
 4f9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4fc:	8b 45 08             	mov    0x8(%ebp),%eax
 4ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 502:	8b 45 0c             	mov    0xc(%ebp),%eax
 505:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 508:	eb 17                	jmp    521 <memmove+0x2b>
    *dst++ = *src++;
 50a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 50d:	8d 50 01             	lea    0x1(%eax),%edx
 510:	89 55 fc             	mov    %edx,-0x4(%ebp)
 513:	8b 55 f8             	mov    -0x8(%ebp),%edx
 516:	8d 4a 01             	lea    0x1(%edx),%ecx
 519:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 51c:	0f b6 12             	movzbl (%edx),%edx
 51f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 521:	8b 45 10             	mov    0x10(%ebp),%eax
 524:	8d 50 ff             	lea    -0x1(%eax),%edx
 527:	89 55 10             	mov    %edx,0x10(%ebp)
 52a:	85 c0                	test   %eax,%eax
 52c:	7f dc                	jg     50a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 531:	c9                   	leave  
 532:	c3                   	ret    

00000533 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 533:	b8 01 00 00 00       	mov    $0x1,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <exit>:
SYSCALL(exit)
 53b:	b8 02 00 00 00       	mov    $0x2,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <wait>:
SYSCALL(wait)
 543:	b8 03 00 00 00       	mov    $0x3,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <pipe>:
SYSCALL(pipe)
 54b:	b8 04 00 00 00       	mov    $0x4,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <read>:
SYSCALL(read)
 553:	b8 05 00 00 00       	mov    $0x5,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <write>:
SYSCALL(write)
 55b:	b8 10 00 00 00       	mov    $0x10,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <close>:
SYSCALL(close)
 563:	b8 15 00 00 00       	mov    $0x15,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <kill>:
SYSCALL(kill)
 56b:	b8 06 00 00 00       	mov    $0x6,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <exec>:
SYSCALL(exec)
 573:	b8 07 00 00 00       	mov    $0x7,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <open>:
SYSCALL(open)
 57b:	b8 0f 00 00 00       	mov    $0xf,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <mknod>:
SYSCALL(mknod)
 583:	b8 11 00 00 00       	mov    $0x11,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <unlink>:
SYSCALL(unlink)
 58b:	b8 12 00 00 00       	mov    $0x12,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <fstat>:
SYSCALL(fstat)
 593:	b8 08 00 00 00       	mov    $0x8,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <link>:
SYSCALL(link)
 59b:	b8 13 00 00 00       	mov    $0x13,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <mkdir>:
SYSCALL(mkdir)
 5a3:	b8 14 00 00 00       	mov    $0x14,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <chdir>:
SYSCALL(chdir)
 5ab:	b8 09 00 00 00       	mov    $0x9,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <dup>:
SYSCALL(dup)
 5b3:	b8 0a 00 00 00       	mov    $0xa,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <getpid>:
SYSCALL(getpid)
 5bb:	b8 0b 00 00 00       	mov    $0xb,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <sbrk>:
SYSCALL(sbrk)
 5c3:	b8 0c 00 00 00       	mov    $0xc,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <sleep>:
SYSCALL(sleep)
 5cb:	b8 0d 00 00 00       	mov    $0xd,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <uptime>:
SYSCALL(uptime)
 5d3:	b8 0e 00 00 00       	mov    $0xe,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <halt>:
SYSCALL(halt)
 5db:	b8 16 00 00 00       	mov    $0x16,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <date>:
SYSCALL(date)      #p1
 5e3:	b8 17 00 00 00       	mov    $0x17,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <getuid>:
SYSCALL(getuid)    #p2
 5eb:	b8 18 00 00 00       	mov    $0x18,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <getgid>:
SYSCALL(getgid)    #p2
 5f3:	b8 19 00 00 00       	mov    $0x19,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <getppid>:
SYSCALL(getppid)   #p2
 5fb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <setuid>:
SYSCALL(setuid)    #p2
 603:	b8 1b 00 00 00       	mov    $0x1b,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <setgid>:
SYSCALL(setgid)    #p2
 60b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <getprocs>:
SYSCALL(getprocs)  #p2
 613:	b8 1d 00 00 00       	mov    $0x1d,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <setpriority>:
SYSCALL(setpriority)
 61b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 623:	55                   	push   %ebp
 624:	89 e5                	mov    %esp,%ebp
 626:	83 ec 18             	sub    $0x18,%esp
 629:	8b 45 0c             	mov    0xc(%ebp),%eax
 62c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 62f:	83 ec 04             	sub    $0x4,%esp
 632:	6a 01                	push   $0x1
 634:	8d 45 f4             	lea    -0xc(%ebp),%eax
 637:	50                   	push   %eax
 638:	ff 75 08             	pushl  0x8(%ebp)
 63b:	e8 1b ff ff ff       	call   55b <write>
 640:	83 c4 10             	add    $0x10,%esp
}
 643:	90                   	nop
 644:	c9                   	leave  
 645:	c3                   	ret    

00000646 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 646:	55                   	push   %ebp
 647:	89 e5                	mov    %esp,%ebp
 649:	53                   	push   %ebx
 64a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 64d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 654:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 658:	74 17                	je     671 <printint+0x2b>
 65a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 65e:	79 11                	jns    671 <printint+0x2b>
    neg = 1;
 660:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 667:	8b 45 0c             	mov    0xc(%ebp),%eax
 66a:	f7 d8                	neg    %eax
 66c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 66f:	eb 06                	jmp    677 <printint+0x31>
  } else {
    x = xx;
 671:	8b 45 0c             	mov    0xc(%ebp),%eax
 674:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 677:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 67e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 681:	8d 41 01             	lea    0x1(%ecx),%eax
 684:	89 45 f4             	mov    %eax,-0xc(%ebp)
 687:	8b 5d 10             	mov    0x10(%ebp),%ebx
 68a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68d:	ba 00 00 00 00       	mov    $0x0,%edx
 692:	f7 f3                	div    %ebx
 694:	89 d0                	mov    %edx,%eax
 696:	0f b6 80 e8 0d 00 00 	movzbl 0xde8(%eax),%eax
 69d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a7:	ba 00 00 00 00       	mov    $0x0,%edx
 6ac:	f7 f3                	div    %ebx
 6ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b5:	75 c7                	jne    67e <printint+0x38>
  if(neg)
 6b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6bb:	74 2d                	je     6ea <printint+0xa4>
    buf[i++] = '-';
 6bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c0:	8d 50 01             	lea    0x1(%eax),%edx
 6c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6cb:	eb 1d                	jmp    6ea <printint+0xa4>
    putc(fd, buf[i]);
 6cd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d3:	01 d0                	add    %edx,%eax
 6d5:	0f b6 00             	movzbl (%eax),%eax
 6d8:	0f be c0             	movsbl %al,%eax
 6db:	83 ec 08             	sub    $0x8,%esp
 6de:	50                   	push   %eax
 6df:	ff 75 08             	pushl  0x8(%ebp)
 6e2:	e8 3c ff ff ff       	call   623 <putc>
 6e7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ea:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f2:	79 d9                	jns    6cd <printint+0x87>
    putc(fd, buf[i]);
}
 6f4:	90                   	nop
 6f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6f8:	c9                   	leave  
 6f9:	c3                   	ret    

000006fa <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6fa:	55                   	push   %ebp
 6fb:	89 e5                	mov    %esp,%ebp
 6fd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 700:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 707:	8d 45 0c             	lea    0xc(%ebp),%eax
 70a:	83 c0 04             	add    $0x4,%eax
 70d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 710:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 717:	e9 59 01 00 00       	jmp    875 <printf+0x17b>
    c = fmt[i] & 0xff;
 71c:	8b 55 0c             	mov    0xc(%ebp),%edx
 71f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 722:	01 d0                	add    %edx,%eax
 724:	0f b6 00             	movzbl (%eax),%eax
 727:	0f be c0             	movsbl %al,%eax
 72a:	25 ff 00 00 00       	and    $0xff,%eax
 72f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 732:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 736:	75 2c                	jne    764 <printf+0x6a>
      if(c == '%'){
 738:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73c:	75 0c                	jne    74a <printf+0x50>
        state = '%';
 73e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 745:	e9 27 01 00 00       	jmp    871 <printf+0x177>
      } else {
        putc(fd, c);
 74a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74d:	0f be c0             	movsbl %al,%eax
 750:	83 ec 08             	sub    $0x8,%esp
 753:	50                   	push   %eax
 754:	ff 75 08             	pushl  0x8(%ebp)
 757:	e8 c7 fe ff ff       	call   623 <putc>
 75c:	83 c4 10             	add    $0x10,%esp
 75f:	e9 0d 01 00 00       	jmp    871 <printf+0x177>
      }
    } else if(state == '%'){
 764:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 768:	0f 85 03 01 00 00    	jne    871 <printf+0x177>
      if(c == 'd'){
 76e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 772:	75 1e                	jne    792 <printf+0x98>
        printint(fd, *ap, 10, 1);
 774:	8b 45 e8             	mov    -0x18(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	6a 01                	push   $0x1
 77b:	6a 0a                	push   $0xa
 77d:	50                   	push   %eax
 77e:	ff 75 08             	pushl  0x8(%ebp)
 781:	e8 c0 fe ff ff       	call   646 <printint>
 786:	83 c4 10             	add    $0x10,%esp
        ap++;
 789:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 78d:	e9 d8 00 00 00       	jmp    86a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 792:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 796:	74 06                	je     79e <printf+0xa4>
 798:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 79c:	75 1e                	jne    7bc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 79e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a1:	8b 00                	mov    (%eax),%eax
 7a3:	6a 00                	push   $0x0
 7a5:	6a 10                	push   $0x10
 7a7:	50                   	push   %eax
 7a8:	ff 75 08             	pushl  0x8(%ebp)
 7ab:	e8 96 fe ff ff       	call   646 <printint>
 7b0:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7b7:	e9 ae 00 00 00       	jmp    86a <printf+0x170>
      } else if(c == 's'){
 7bc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7c0:	75 43                	jne    805 <printf+0x10b>
        s = (char*)*ap;
 7c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c5:	8b 00                	mov    (%eax),%eax
 7c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d2:	75 25                	jne    7f9 <printf+0xff>
          s = "(null)";
 7d4:	c7 45 f4 8d 0b 00 00 	movl   $0xb8d,-0xc(%ebp)
        while(*s != 0){
 7db:	eb 1c                	jmp    7f9 <printf+0xff>
          putc(fd, *s);
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	0f b6 00             	movzbl (%eax),%eax
 7e3:	0f be c0             	movsbl %al,%eax
 7e6:	83 ec 08             	sub    $0x8,%esp
 7e9:	50                   	push   %eax
 7ea:	ff 75 08             	pushl  0x8(%ebp)
 7ed:	e8 31 fe ff ff       	call   623 <putc>
 7f2:	83 c4 10             	add    $0x10,%esp
          s++;
 7f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	0f b6 00             	movzbl (%eax),%eax
 7ff:	84 c0                	test   %al,%al
 801:	75 da                	jne    7dd <printf+0xe3>
 803:	eb 65                	jmp    86a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 805:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 809:	75 1d                	jne    828 <printf+0x12e>
        putc(fd, *ap);
 80b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80e:	8b 00                	mov    (%eax),%eax
 810:	0f be c0             	movsbl %al,%eax
 813:	83 ec 08             	sub    $0x8,%esp
 816:	50                   	push   %eax
 817:	ff 75 08             	pushl  0x8(%ebp)
 81a:	e8 04 fe ff ff       	call   623 <putc>
 81f:	83 c4 10             	add    $0x10,%esp
        ap++;
 822:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 826:	eb 42                	jmp    86a <printf+0x170>
      } else if(c == '%'){
 828:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 82c:	75 17                	jne    845 <printf+0x14b>
        putc(fd, c);
 82e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 831:	0f be c0             	movsbl %al,%eax
 834:	83 ec 08             	sub    $0x8,%esp
 837:	50                   	push   %eax
 838:	ff 75 08             	pushl  0x8(%ebp)
 83b:	e8 e3 fd ff ff       	call   623 <putc>
 840:	83 c4 10             	add    $0x10,%esp
 843:	eb 25                	jmp    86a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 845:	83 ec 08             	sub    $0x8,%esp
 848:	6a 25                	push   $0x25
 84a:	ff 75 08             	pushl  0x8(%ebp)
 84d:	e8 d1 fd ff ff       	call   623 <putc>
 852:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 858:	0f be c0             	movsbl %al,%eax
 85b:	83 ec 08             	sub    $0x8,%esp
 85e:	50                   	push   %eax
 85f:	ff 75 08             	pushl  0x8(%ebp)
 862:	e8 bc fd ff ff       	call   623 <putc>
 867:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 86a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 871:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 875:	8b 55 0c             	mov    0xc(%ebp),%edx
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	01 d0                	add    %edx,%eax
 87d:	0f b6 00             	movzbl (%eax),%eax
 880:	84 c0                	test   %al,%al
 882:	0f 85 94 fe ff ff    	jne    71c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 888:	90                   	nop
 889:	c9                   	leave  
 88a:	c3                   	ret    

0000088b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88b:	55                   	push   %ebp
 88c:	89 e5                	mov    %esp,%ebp
 88e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 891:	8b 45 08             	mov    0x8(%ebp),%eax
 894:	83 e8 08             	sub    $0x8,%eax
 897:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89a:	a1 04 0e 00 00       	mov    0xe04,%eax
 89f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a2:	eb 24                	jmp    8c8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a7:	8b 00                	mov    (%eax),%eax
 8a9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ac:	77 12                	ja     8c0 <free+0x35>
 8ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b4:	77 24                	ja     8da <free+0x4f>
 8b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b9:	8b 00                	mov    (%eax),%eax
 8bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8be:	77 1a                	ja     8da <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c3:	8b 00                	mov    (%eax),%eax
 8c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ce:	76 d4                	jbe    8a4 <free+0x19>
 8d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d3:	8b 00                	mov    (%eax),%eax
 8d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d8:	76 ca                	jbe    8a4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dd:	8b 40 04             	mov    0x4(%eax),%eax
 8e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ea:	01 c2                	add    %eax,%edx
 8ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ef:	8b 00                	mov    (%eax),%eax
 8f1:	39 c2                	cmp    %eax,%edx
 8f3:	75 24                	jne    919 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f8:	8b 50 04             	mov    0x4(%eax),%edx
 8fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fe:	8b 00                	mov    (%eax),%eax
 900:	8b 40 04             	mov    0x4(%eax),%eax
 903:	01 c2                	add    %eax,%edx
 905:	8b 45 f8             	mov    -0x8(%ebp),%eax
 908:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 90b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90e:	8b 00                	mov    (%eax),%eax
 910:	8b 10                	mov    (%eax),%edx
 912:	8b 45 f8             	mov    -0x8(%ebp),%eax
 915:	89 10                	mov    %edx,(%eax)
 917:	eb 0a                	jmp    923 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 919:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91c:	8b 10                	mov    (%eax),%edx
 91e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 921:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 923:	8b 45 fc             	mov    -0x4(%ebp),%eax
 926:	8b 40 04             	mov    0x4(%eax),%eax
 929:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 930:	8b 45 fc             	mov    -0x4(%ebp),%eax
 933:	01 d0                	add    %edx,%eax
 935:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 938:	75 20                	jne    95a <free+0xcf>
    p->s.size += bp->s.size;
 93a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93d:	8b 50 04             	mov    0x4(%eax),%edx
 940:	8b 45 f8             	mov    -0x8(%ebp),%eax
 943:	8b 40 04             	mov    0x4(%eax),%eax
 946:	01 c2                	add    %eax,%edx
 948:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 94e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 951:	8b 10                	mov    (%eax),%edx
 953:	8b 45 fc             	mov    -0x4(%ebp),%eax
 956:	89 10                	mov    %edx,(%eax)
 958:	eb 08                	jmp    962 <free+0xd7>
  } else
    p->s.ptr = bp;
 95a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 960:	89 10                	mov    %edx,(%eax)
  freep = p;
 962:	8b 45 fc             	mov    -0x4(%ebp),%eax
 965:	a3 04 0e 00 00       	mov    %eax,0xe04
}
 96a:	90                   	nop
 96b:	c9                   	leave  
 96c:	c3                   	ret    

0000096d <morecore>:

static Header*
morecore(uint nu)
{
 96d:	55                   	push   %ebp
 96e:	89 e5                	mov    %esp,%ebp
 970:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 973:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 97a:	77 07                	ja     983 <morecore+0x16>
    nu = 4096;
 97c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 983:	8b 45 08             	mov    0x8(%ebp),%eax
 986:	c1 e0 03             	shl    $0x3,%eax
 989:	83 ec 0c             	sub    $0xc,%esp
 98c:	50                   	push   %eax
 98d:	e8 31 fc ff ff       	call   5c3 <sbrk>
 992:	83 c4 10             	add    $0x10,%esp
 995:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 998:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 99c:	75 07                	jne    9a5 <morecore+0x38>
    return 0;
 99e:	b8 00 00 00 00       	mov    $0x0,%eax
 9a3:	eb 26                	jmp    9cb <morecore+0x5e>
  hp = (Header*)p;
 9a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ae:	8b 55 08             	mov    0x8(%ebp),%edx
 9b1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b7:	83 c0 08             	add    $0x8,%eax
 9ba:	83 ec 0c             	sub    $0xc,%esp
 9bd:	50                   	push   %eax
 9be:	e8 c8 fe ff ff       	call   88b <free>
 9c3:	83 c4 10             	add    $0x10,%esp
  return freep;
 9c6:	a1 04 0e 00 00       	mov    0xe04,%eax
}
 9cb:	c9                   	leave  
 9cc:	c3                   	ret    

000009cd <malloc>:

void*
malloc(uint nbytes)
{
 9cd:	55                   	push   %ebp
 9ce:	89 e5                	mov    %esp,%ebp
 9d0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d3:	8b 45 08             	mov    0x8(%ebp),%eax
 9d6:	83 c0 07             	add    $0x7,%eax
 9d9:	c1 e8 03             	shr    $0x3,%eax
 9dc:	83 c0 01             	add    $0x1,%eax
 9df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9e2:	a1 04 0e 00 00       	mov    0xe04,%eax
 9e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9ee:	75 23                	jne    a13 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9f0:	c7 45 f0 fc 0d 00 00 	movl   $0xdfc,-0x10(%ebp)
 9f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fa:	a3 04 0e 00 00       	mov    %eax,0xe04
 9ff:	a1 04 0e 00 00       	mov    0xe04,%eax
 a04:	a3 fc 0d 00 00       	mov    %eax,0xdfc
    base.s.size = 0;
 a09:	c7 05 00 0e 00 00 00 	movl   $0x0,0xe00
 a10:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a16:	8b 00                	mov    (%eax),%eax
 a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1e:	8b 40 04             	mov    0x4(%eax),%eax
 a21:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a24:	72 4d                	jb     a73 <malloc+0xa6>
      if(p->s.size == nunits)
 a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a29:	8b 40 04             	mov    0x4(%eax),%eax
 a2c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a2f:	75 0c                	jne    a3d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a34:	8b 10                	mov    (%eax),%edx
 a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a39:	89 10                	mov    %edx,(%eax)
 a3b:	eb 26                	jmp    a63 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a40:	8b 40 04             	mov    0x4(%eax),%eax
 a43:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a46:	89 c2                	mov    %eax,%edx
 a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a51:	8b 40 04             	mov    0x4(%eax),%eax
 a54:	c1 e0 03             	shl    $0x3,%eax
 a57:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a60:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a66:	a3 04 0e 00 00       	mov    %eax,0xe04
      return (void*)(p + 1);
 a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6e:	83 c0 08             	add    $0x8,%eax
 a71:	eb 3b                	jmp    aae <malloc+0xe1>
    }
    if(p == freep)
 a73:	a1 04 0e 00 00       	mov    0xe04,%eax
 a78:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a7b:	75 1e                	jne    a9b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a7d:	83 ec 0c             	sub    $0xc,%esp
 a80:	ff 75 ec             	pushl  -0x14(%ebp)
 a83:	e8 e5 fe ff ff       	call   96d <morecore>
 a88:	83 c4 10             	add    $0x10,%esp
 a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a92:	75 07                	jne    a9b <malloc+0xce>
        return 0;
 a94:	b8 00 00 00 00       	mov    $0x0,%eax
 a99:	eb 13                	jmp    aae <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa4:	8b 00                	mov    (%eax),%eax
 aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 aa9:	e9 6d ff ff ff       	jmp    a1b <malloc+0x4e>
}
 aae:	c9                   	leave  
 aaf:	c3                   	ret    
