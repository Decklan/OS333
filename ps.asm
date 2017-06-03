
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
  1c:	e8 52 0a 00 00       	call   a73 <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if (!table) 
  27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  2b:	75 17                	jne    44 <main+0x44>
  {
    printf(2, "Error. Malloc call failed.");
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	68 58 0b 00 00       	push   $0xb58
  35:	6a 02                	push   $0x2
  37:	e8 64 07 00 00       	call   7a0 <printf>
  3c:	83 c4 10             	add    $0x10,%esp
    exit();
  3f:	e8 85 05 00 00       	call   5c9 <exit>
  }
 
  printf(1, "Max value: %d\n", MAX); 
  44:	83 ec 04             	sub    $0x4,%esp
  47:	6a 40                	push   $0x40
  49:	68 73 0b 00 00       	push   $0xb73
  4e:	6a 01                	push   $0x1
  50:	e8 4b 07 00 00       	call   7a0 <printf>
  55:	83 c4 10             	add    $0x10,%esp
  int status = getprocs(MAX, table);
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	ff 75 e0             	pushl  -0x20(%ebp)
  5e:	6a 40                	push   $0x40
  60:	e8 3c 06 00 00       	call   6a1 <getprocs>
  65:	83 c4 10             	add    $0x10,%esp
  68:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (status < 0)
  6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  6f:	79 17                	jns    88 <main+0x88>
    printf(2, "Error. Not enough memory for the table.\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 84 0b 00 00       	push   $0xb84
  79:	6a 02                	push   $0x2
  7b:	e8 20 07 00 00       	call   7a0 <printf>
  80:	83 c4 10             	add    $0x10,%esp
  83:	e9 12 02 00 00       	jmp    29a <main+0x29a>
  else
  {
    printf(1, "PID\t Name\t UID\t GID\t PPID\t Prio\t Elapsed  CPU\t State\t Size\n");
  88:	83 ec 08             	sub    $0x8,%esp
  8b:	68 b0 0b 00 00       	push   $0xbb0
  90:	6a 01                	push   $0x1
  92:	e8 09 07 00 00       	call   7a0 <printf>
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
 1da:	68 ec 0b 00 00       	push   $0xbec
 1df:	6a 01                	push   $0x1
 1e1:	e8 ba 05 00 00       	call   7a0 <printf>
 1e6:	83 c4 20             	add    $0x20,%esp
            table[i].gid, table[i].ppid, table[i].priority);
    
      if (partial_elapsed_secs < 10)
 1e9:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
 1ed:	7f 17                	jg     206 <main+0x206>
        printf(1, " %d.0%d", elapsed_secs, partial_elapsed_secs);
 1ef:	ff 75 d4             	pushl  -0x2c(%ebp)
 1f2:	ff 75 d8             	pushl  -0x28(%ebp)
 1f5:	68 04 0c 00 00       	push   $0xc04
 1fa:	6a 01                	push   $0x1
 1fc:	e8 9f 05 00 00       	call   7a0 <printf>
 201:	83 c4 10             	add    $0x10,%esp
 204:	eb 15                	jmp    21b <main+0x21b>
      else
        printf(1, " %d.%d", elapsed_secs, partial_elapsed_secs);
 206:	ff 75 d4             	pushl  -0x2c(%ebp)
 209:	ff 75 d8             	pushl  -0x28(%ebp)
 20c:	68 0c 0c 00 00       	push   $0xc0c
 211:	6a 01                	push   $0x1
 213:	e8 88 05 00 00       	call   7a0 <printf>
 218:	83 c4 10             	add    $0x10,%esp

      if (partial_cpu_secs < 10)
 21b:	83 7d cc 09          	cmpl   $0x9,-0x34(%ebp)
 21f:	7f 17                	jg     238 <main+0x238>
        printf(1, "     %d.0%d\t", total_cpu_secs, partial_cpu_secs);
 221:	ff 75 cc             	pushl  -0x34(%ebp)
 224:	ff 75 d0             	pushl  -0x30(%ebp)
 227:	68 13 0c 00 00       	push   $0xc13
 22c:	6a 01                	push   $0x1
 22e:	e8 6d 05 00 00       	call   7a0 <printf>
 233:	83 c4 10             	add    $0x10,%esp
 236:	eb 15                	jmp    24d <main+0x24d>
      else
        printf(1, "     %d.%d\t", total_cpu_secs, partial_cpu_secs);
 238:	ff 75 cc             	pushl  -0x34(%ebp)
 23b:	ff 75 d0             	pushl  -0x30(%ebp)
 23e:	68 20 0c 00 00       	push   $0xc20
 243:	6a 01                	push   $0x1
 245:	e8 56 05 00 00       	call   7a0 <printf>
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
 27b:	68 2c 0c 00 00       	push   $0xc2c
 280:	6a 01                	push   $0x1
 282:	e8 19 05 00 00       	call   7a0 <printf>
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
 29a:	e8 2a 03 00 00       	call   5c9 <exit>

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
 3c2:	e8 1a 02 00 00       	call   5e1 <read>
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
 425:	e8 df 01 00 00       	call   609 <open>
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
 446:	e8 d6 01 00 00       	call   621 <fstat>
 44b:	83 c4 10             	add    $0x10,%esp
 44e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 451:	83 ec 0c             	sub    $0xc,%esp
 454:	ff 75 f4             	pushl  -0xc(%ebp)
 457:	e8 95 01 00 00       	call   5f1 <close>
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

000004f6 <atoo>:

int
atoo(const char *s)
{
 4f6:	55                   	push   %ebp
 4f7:	89 e5                	mov    %esp,%ebp
 4f9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 4fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 503:	eb 04                	jmp    509 <atoo+0x13>
 505:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 509:	8b 45 08             	mov    0x8(%ebp),%eax
 50c:	0f b6 00             	movzbl (%eax),%eax
 50f:	3c 20                	cmp    $0x20,%al
 511:	74 f2                	je     505 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	3c 2d                	cmp    $0x2d,%al
 51b:	75 07                	jne    524 <atoo+0x2e>
 51d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 522:	eb 05                	jmp    529 <atoo+0x33>
 524:	b8 01 00 00 00       	mov    $0x1,%eax
 529:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
 52f:	0f b6 00             	movzbl (%eax),%eax
 532:	3c 2b                	cmp    $0x2b,%al
 534:	74 0a                	je     540 <atoo+0x4a>
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	0f b6 00             	movzbl (%eax),%eax
 53c:	3c 2d                	cmp    $0x2d,%al
 53e:	75 27                	jne    567 <atoo+0x71>
    s++;
 540:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 544:	eb 21                	jmp    567 <atoo+0x71>
    n = n*8 + *s++ - '0';
 546:	8b 45 fc             	mov    -0x4(%ebp),%eax
 549:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	8d 50 01             	lea    0x1(%eax),%edx
 556:	89 55 08             	mov    %edx,0x8(%ebp)
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	0f be c0             	movsbl %al,%eax
 55f:	01 c8                	add    %ecx,%eax
 561:	83 e8 30             	sub    $0x30,%eax
 564:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 567:	8b 45 08             	mov    0x8(%ebp),%eax
 56a:	0f b6 00             	movzbl (%eax),%eax
 56d:	3c 2f                	cmp    $0x2f,%al
 56f:	7e 0a                	jle    57b <atoo+0x85>
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	0f b6 00             	movzbl (%eax),%eax
 577:	3c 37                	cmp    $0x37,%al
 579:	7e cb                	jle    546 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 57b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 57e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 582:	c9                   	leave  
 583:	c3                   	ret    

00000584 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 590:	8b 45 0c             	mov    0xc(%ebp),%eax
 593:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 596:	eb 17                	jmp    5af <memmove+0x2b>
    *dst++ = *src++;
 598:	8b 45 fc             	mov    -0x4(%ebp),%eax
 59b:	8d 50 01             	lea    0x1(%eax),%edx
 59e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 5a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5aa:	0f b6 12             	movzbl (%edx),%edx
 5ad:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5af:	8b 45 10             	mov    0x10(%ebp),%eax
 5b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 5b5:	89 55 10             	mov    %edx,0x10(%ebp)
 5b8:	85 c0                	test   %eax,%eax
 5ba:	7f dc                	jg     598 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5bf:	c9                   	leave  
 5c0:	c3                   	ret    

000005c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5c1:	b8 01 00 00 00       	mov    $0x1,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <exit>:
SYSCALL(exit)
 5c9:	b8 02 00 00 00       	mov    $0x2,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <wait>:
SYSCALL(wait)
 5d1:	b8 03 00 00 00       	mov    $0x3,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <pipe>:
SYSCALL(pipe)
 5d9:	b8 04 00 00 00       	mov    $0x4,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <read>:
SYSCALL(read)
 5e1:	b8 05 00 00 00       	mov    $0x5,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <write>:
SYSCALL(write)
 5e9:	b8 10 00 00 00       	mov    $0x10,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <close>:
SYSCALL(close)
 5f1:	b8 15 00 00 00       	mov    $0x15,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <kill>:
SYSCALL(kill)
 5f9:	b8 06 00 00 00       	mov    $0x6,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <exec>:
SYSCALL(exec)
 601:	b8 07 00 00 00       	mov    $0x7,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <open>:
SYSCALL(open)
 609:	b8 0f 00 00 00       	mov    $0xf,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <mknod>:
SYSCALL(mknod)
 611:	b8 11 00 00 00       	mov    $0x11,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <unlink>:
SYSCALL(unlink)
 619:	b8 12 00 00 00       	mov    $0x12,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <fstat>:
SYSCALL(fstat)
 621:	b8 08 00 00 00       	mov    $0x8,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <link>:
SYSCALL(link)
 629:	b8 13 00 00 00       	mov    $0x13,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <mkdir>:
SYSCALL(mkdir)
 631:	b8 14 00 00 00       	mov    $0x14,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <chdir>:
SYSCALL(chdir)
 639:	b8 09 00 00 00       	mov    $0x9,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <dup>:
SYSCALL(dup)
 641:	b8 0a 00 00 00       	mov    $0xa,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <getpid>:
SYSCALL(getpid)
 649:	b8 0b 00 00 00       	mov    $0xb,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <sbrk>:
SYSCALL(sbrk)
 651:	b8 0c 00 00 00       	mov    $0xc,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <sleep>:
SYSCALL(sleep)
 659:	b8 0d 00 00 00       	mov    $0xd,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <uptime>:
SYSCALL(uptime)
 661:	b8 0e 00 00 00       	mov    $0xe,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <halt>:
SYSCALL(halt)
 669:	b8 16 00 00 00       	mov    $0x16,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <date>:
SYSCALL(date)        #p1
 671:	b8 17 00 00 00       	mov    $0x17,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <getuid>:
SYSCALL(getuid)      #p2
 679:	b8 18 00 00 00       	mov    $0x18,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <getgid>:
SYSCALL(getgid)      #p2
 681:	b8 19 00 00 00       	mov    $0x19,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <getppid>:
SYSCALL(getppid)     #p2
 689:	b8 1a 00 00 00       	mov    $0x1a,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <setuid>:
SYSCALL(setuid)      #p2
 691:	b8 1b 00 00 00       	mov    $0x1b,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <setgid>:
SYSCALL(setgid)      #p2
 699:	b8 1c 00 00 00       	mov    $0x1c,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <getprocs>:
SYSCALL(getprocs)    #p2
 6a1:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6a6:	cd 40                	int    $0x40
 6a8:	c3                   	ret    

000006a9 <setpriority>:
SYSCALL(setpriority) #p4
 6a9:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6ae:	cd 40                	int    $0x40
 6b0:	c3                   	ret    

000006b1 <chmod>:
SYSCALL(chmod)       #p5
 6b1:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6b6:	cd 40                	int    $0x40
 6b8:	c3                   	ret    

000006b9 <chown>:
SYSCALL(chown)       #p5
 6b9:	b8 20 00 00 00       	mov    $0x20,%eax
 6be:	cd 40                	int    $0x40
 6c0:	c3                   	ret    

000006c1 <chgrp>:
SYSCALL(chgrp)       #p5
 6c1:	b8 21 00 00 00       	mov    $0x21,%eax
 6c6:	cd 40                	int    $0x40
 6c8:	c3                   	ret    

000006c9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6c9:	55                   	push   %ebp
 6ca:	89 e5                	mov    %esp,%ebp
 6cc:	83 ec 18             	sub    $0x18,%esp
 6cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6d5:	83 ec 04             	sub    $0x4,%esp
 6d8:	6a 01                	push   $0x1
 6da:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 03 ff ff ff       	call   5e9 <write>
 6e6:	83 c4 10             	add    $0x10,%esp
}
 6e9:	90                   	nop
 6ea:	c9                   	leave  
 6eb:	c3                   	ret    

000006ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6ec:	55                   	push   %ebp
 6ed:	89 e5                	mov    %esp,%ebp
 6ef:	53                   	push   %ebx
 6f0:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6fa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6fe:	74 17                	je     717 <printint+0x2b>
 700:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 704:	79 11                	jns    717 <printint+0x2b>
    neg = 1;
 706:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 70d:	8b 45 0c             	mov    0xc(%ebp),%eax
 710:	f7 d8                	neg    %eax
 712:	89 45 ec             	mov    %eax,-0x14(%ebp)
 715:	eb 06                	jmp    71d <printint+0x31>
  } else {
    x = xx;
 717:	8b 45 0c             	mov    0xc(%ebp),%eax
 71a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 71d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 724:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 727:	8d 41 01             	lea    0x1(%ecx),%eax
 72a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 72d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 730:	8b 45 ec             	mov    -0x14(%ebp),%eax
 733:	ba 00 00 00 00       	mov    $0x0,%edx
 738:	f7 f3                	div    %ebx
 73a:	89 d0                	mov    %edx,%eax
 73c:	0f b6 80 b0 0e 00 00 	movzbl 0xeb0(%eax),%eax
 743:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 747:	8b 5d 10             	mov    0x10(%ebp),%ebx
 74a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 74d:	ba 00 00 00 00       	mov    $0x0,%edx
 752:	f7 f3                	div    %ebx
 754:	89 45 ec             	mov    %eax,-0x14(%ebp)
 757:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 75b:	75 c7                	jne    724 <printint+0x38>
  if(neg)
 75d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 761:	74 2d                	je     790 <printint+0xa4>
    buf[i++] = '-';
 763:	8b 45 f4             	mov    -0xc(%ebp),%eax
 766:	8d 50 01             	lea    0x1(%eax),%edx
 769:	89 55 f4             	mov    %edx,-0xc(%ebp)
 76c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 771:	eb 1d                	jmp    790 <printint+0xa4>
    putc(fd, buf[i]);
 773:	8d 55 dc             	lea    -0x24(%ebp),%edx
 776:	8b 45 f4             	mov    -0xc(%ebp),%eax
 779:	01 d0                	add    %edx,%eax
 77b:	0f b6 00             	movzbl (%eax),%eax
 77e:	0f be c0             	movsbl %al,%eax
 781:	83 ec 08             	sub    $0x8,%esp
 784:	50                   	push   %eax
 785:	ff 75 08             	pushl  0x8(%ebp)
 788:	e8 3c ff ff ff       	call   6c9 <putc>
 78d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 790:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 794:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 798:	79 d9                	jns    773 <printint+0x87>
    putc(fd, buf[i]);
}
 79a:	90                   	nop
 79b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 79e:	c9                   	leave  
 79f:	c3                   	ret    

000007a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7ad:	8d 45 0c             	lea    0xc(%ebp),%eax
 7b0:	83 c0 04             	add    $0x4,%eax
 7b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7bd:	e9 59 01 00 00       	jmp    91b <printf+0x17b>
    c = fmt[i] & 0xff;
 7c2:	8b 55 0c             	mov    0xc(%ebp),%edx
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	01 d0                	add    %edx,%eax
 7ca:	0f b6 00             	movzbl (%eax),%eax
 7cd:	0f be c0             	movsbl %al,%eax
 7d0:	25 ff 00 00 00       	and    $0xff,%eax
 7d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7dc:	75 2c                	jne    80a <printf+0x6a>
      if(c == '%'){
 7de:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7e2:	75 0c                	jne    7f0 <printf+0x50>
        state = '%';
 7e4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7eb:	e9 27 01 00 00       	jmp    917 <printf+0x177>
      } else {
        putc(fd, c);
 7f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f3:	0f be c0             	movsbl %al,%eax
 7f6:	83 ec 08             	sub    $0x8,%esp
 7f9:	50                   	push   %eax
 7fa:	ff 75 08             	pushl  0x8(%ebp)
 7fd:	e8 c7 fe ff ff       	call   6c9 <putc>
 802:	83 c4 10             	add    $0x10,%esp
 805:	e9 0d 01 00 00       	jmp    917 <printf+0x177>
      }
    } else if(state == '%'){
 80a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 80e:	0f 85 03 01 00 00    	jne    917 <printf+0x177>
      if(c == 'd'){
 814:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 818:	75 1e                	jne    838 <printf+0x98>
        printint(fd, *ap, 10, 1);
 81a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	6a 01                	push   $0x1
 821:	6a 0a                	push   $0xa
 823:	50                   	push   %eax
 824:	ff 75 08             	pushl  0x8(%ebp)
 827:	e8 c0 fe ff ff       	call   6ec <printint>
 82c:	83 c4 10             	add    $0x10,%esp
        ap++;
 82f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 833:	e9 d8 00 00 00       	jmp    910 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 838:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 83c:	74 06                	je     844 <printf+0xa4>
 83e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 842:	75 1e                	jne    862 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 844:	8b 45 e8             	mov    -0x18(%ebp),%eax
 847:	8b 00                	mov    (%eax),%eax
 849:	6a 00                	push   $0x0
 84b:	6a 10                	push   $0x10
 84d:	50                   	push   %eax
 84e:	ff 75 08             	pushl  0x8(%ebp)
 851:	e8 96 fe ff ff       	call   6ec <printint>
 856:	83 c4 10             	add    $0x10,%esp
        ap++;
 859:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 85d:	e9 ae 00 00 00       	jmp    910 <printf+0x170>
      } else if(c == 's'){
 862:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 866:	75 43                	jne    8ab <printf+0x10b>
        s = (char*)*ap;
 868:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86b:	8b 00                	mov    (%eax),%eax
 86d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 870:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 878:	75 25                	jne    89f <printf+0xff>
          s = "(null)";
 87a:	c7 45 f4 35 0c 00 00 	movl   $0xc35,-0xc(%ebp)
        while(*s != 0){
 881:	eb 1c                	jmp    89f <printf+0xff>
          putc(fd, *s);
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	0f b6 00             	movzbl (%eax),%eax
 889:	0f be c0             	movsbl %al,%eax
 88c:	83 ec 08             	sub    $0x8,%esp
 88f:	50                   	push   %eax
 890:	ff 75 08             	pushl  0x8(%ebp)
 893:	e8 31 fe ff ff       	call   6c9 <putc>
 898:	83 c4 10             	add    $0x10,%esp
          s++;
 89b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	0f b6 00             	movzbl (%eax),%eax
 8a5:	84 c0                	test   %al,%al
 8a7:	75 da                	jne    883 <printf+0xe3>
 8a9:	eb 65                	jmp    910 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8ab:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8af:	75 1d                	jne    8ce <printf+0x12e>
        putc(fd, *ap);
 8b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b4:	8b 00                	mov    (%eax),%eax
 8b6:	0f be c0             	movsbl %al,%eax
 8b9:	83 ec 08             	sub    $0x8,%esp
 8bc:	50                   	push   %eax
 8bd:	ff 75 08             	pushl  0x8(%ebp)
 8c0:	e8 04 fe ff ff       	call   6c9 <putc>
 8c5:	83 c4 10             	add    $0x10,%esp
        ap++;
 8c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8cc:	eb 42                	jmp    910 <printf+0x170>
      } else if(c == '%'){
 8ce:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8d2:	75 17                	jne    8eb <printf+0x14b>
        putc(fd, c);
 8d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8d7:	0f be c0             	movsbl %al,%eax
 8da:	83 ec 08             	sub    $0x8,%esp
 8dd:	50                   	push   %eax
 8de:	ff 75 08             	pushl  0x8(%ebp)
 8e1:	e8 e3 fd ff ff       	call   6c9 <putc>
 8e6:	83 c4 10             	add    $0x10,%esp
 8e9:	eb 25                	jmp    910 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8eb:	83 ec 08             	sub    $0x8,%esp
 8ee:	6a 25                	push   $0x25
 8f0:	ff 75 08             	pushl  0x8(%ebp)
 8f3:	e8 d1 fd ff ff       	call   6c9 <putc>
 8f8:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8fe:	0f be c0             	movsbl %al,%eax
 901:	83 ec 08             	sub    $0x8,%esp
 904:	50                   	push   %eax
 905:	ff 75 08             	pushl  0x8(%ebp)
 908:	e8 bc fd ff ff       	call   6c9 <putc>
 90d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 910:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 917:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 91b:	8b 55 0c             	mov    0xc(%ebp),%edx
 91e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 921:	01 d0                	add    %edx,%eax
 923:	0f b6 00             	movzbl (%eax),%eax
 926:	84 c0                	test   %al,%al
 928:	0f 85 94 fe ff ff    	jne    7c2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 92e:	90                   	nop
 92f:	c9                   	leave  
 930:	c3                   	ret    

00000931 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 931:	55                   	push   %ebp
 932:	89 e5                	mov    %esp,%ebp
 934:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 937:	8b 45 08             	mov    0x8(%ebp),%eax
 93a:	83 e8 08             	sub    $0x8,%eax
 93d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 940:	a1 cc 0e 00 00       	mov    0xecc,%eax
 945:	89 45 fc             	mov    %eax,-0x4(%ebp)
 948:	eb 24                	jmp    96e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94d:	8b 00                	mov    (%eax),%eax
 94f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 952:	77 12                	ja     966 <free+0x35>
 954:	8b 45 f8             	mov    -0x8(%ebp),%eax
 957:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95a:	77 24                	ja     980 <free+0x4f>
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	8b 00                	mov    (%eax),%eax
 961:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 964:	77 1a                	ja     980 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 966:	8b 45 fc             	mov    -0x4(%ebp),%eax
 969:	8b 00                	mov    (%eax),%eax
 96b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 96e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 971:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 974:	76 d4                	jbe    94a <free+0x19>
 976:	8b 45 fc             	mov    -0x4(%ebp),%eax
 979:	8b 00                	mov    (%eax),%eax
 97b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 97e:	76 ca                	jbe    94a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 980:	8b 45 f8             	mov    -0x8(%ebp),%eax
 983:	8b 40 04             	mov    0x4(%eax),%eax
 986:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 98d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 990:	01 c2                	add    %eax,%edx
 992:	8b 45 fc             	mov    -0x4(%ebp),%eax
 995:	8b 00                	mov    (%eax),%eax
 997:	39 c2                	cmp    %eax,%edx
 999:	75 24                	jne    9bf <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 99b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99e:	8b 50 04             	mov    0x4(%eax),%edx
 9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a4:	8b 00                	mov    (%eax),%eax
 9a6:	8b 40 04             	mov    0x4(%eax),%eax
 9a9:	01 c2                	add    %eax,%edx
 9ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ae:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b4:	8b 00                	mov    (%eax),%eax
 9b6:	8b 10                	mov    (%eax),%edx
 9b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9bb:	89 10                	mov    %edx,(%eax)
 9bd:	eb 0a                	jmp    9c9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c2:	8b 10                	mov    (%eax),%edx
 9c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cc:	8b 40 04             	mov    0x4(%eax),%eax
 9cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d9:	01 d0                	add    %edx,%eax
 9db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9de:	75 20                	jne    a00 <free+0xcf>
    p->s.size += bp->s.size;
 9e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e3:	8b 50 04             	mov    0x4(%eax),%edx
 9e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e9:	8b 40 04             	mov    0x4(%eax),%eax
 9ec:	01 c2                	add    %eax,%edx
 9ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f7:	8b 10                	mov    (%eax),%edx
 9f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fc:	89 10                	mov    %edx,(%eax)
 9fe:	eb 08                	jmp    a08 <free+0xd7>
  } else
    p->s.ptr = bp;
 a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a03:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a06:	89 10                	mov    %edx,(%eax)
  freep = p;
 a08:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0b:	a3 cc 0e 00 00       	mov    %eax,0xecc
}
 a10:	90                   	nop
 a11:	c9                   	leave  
 a12:	c3                   	ret    

00000a13 <morecore>:

static Header*
morecore(uint nu)
{
 a13:	55                   	push   %ebp
 a14:	89 e5                	mov    %esp,%ebp
 a16:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a19:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a20:	77 07                	ja     a29 <morecore+0x16>
    nu = 4096;
 a22:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a29:	8b 45 08             	mov    0x8(%ebp),%eax
 a2c:	c1 e0 03             	shl    $0x3,%eax
 a2f:	83 ec 0c             	sub    $0xc,%esp
 a32:	50                   	push   %eax
 a33:	e8 19 fc ff ff       	call   651 <sbrk>
 a38:	83 c4 10             	add    $0x10,%esp
 a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a3e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a42:	75 07                	jne    a4b <morecore+0x38>
    return 0;
 a44:	b8 00 00 00 00       	mov    $0x0,%eax
 a49:	eb 26                	jmp    a71 <morecore+0x5e>
  hp = (Header*)p;
 a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a54:	8b 55 08             	mov    0x8(%ebp),%edx
 a57:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5d:	83 c0 08             	add    $0x8,%eax
 a60:	83 ec 0c             	sub    $0xc,%esp
 a63:	50                   	push   %eax
 a64:	e8 c8 fe ff ff       	call   931 <free>
 a69:	83 c4 10             	add    $0x10,%esp
  return freep;
 a6c:	a1 cc 0e 00 00       	mov    0xecc,%eax
}
 a71:	c9                   	leave  
 a72:	c3                   	ret    

00000a73 <malloc>:

void*
malloc(uint nbytes)
{
 a73:	55                   	push   %ebp
 a74:	89 e5                	mov    %esp,%ebp
 a76:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a79:	8b 45 08             	mov    0x8(%ebp),%eax
 a7c:	83 c0 07             	add    $0x7,%eax
 a7f:	c1 e8 03             	shr    $0x3,%eax
 a82:	83 c0 01             	add    $0x1,%eax
 a85:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a88:	a1 cc 0e 00 00       	mov    0xecc,%eax
 a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a94:	75 23                	jne    ab9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a96:	c7 45 f0 c4 0e 00 00 	movl   $0xec4,-0x10(%ebp)
 a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa0:	a3 cc 0e 00 00       	mov    %eax,0xecc
 aa5:	a1 cc 0e 00 00       	mov    0xecc,%eax
 aaa:	a3 c4 0e 00 00       	mov    %eax,0xec4
    base.s.size = 0;
 aaf:	c7 05 c8 0e 00 00 00 	movl   $0x0,0xec8
 ab6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abc:	8b 00                	mov    (%eax),%eax
 abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac4:	8b 40 04             	mov    0x4(%eax),%eax
 ac7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aca:	72 4d                	jb     b19 <malloc+0xa6>
      if(p->s.size == nunits)
 acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acf:	8b 40 04             	mov    0x4(%eax),%eax
 ad2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ad5:	75 0c                	jne    ae3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ada:	8b 10                	mov    (%eax),%edx
 adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 adf:	89 10                	mov    %edx,(%eax)
 ae1:	eb 26                	jmp    b09 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae6:	8b 40 04             	mov    0x4(%eax),%eax
 ae9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aec:	89 c2                	mov    %eax,%edx
 aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af7:	8b 40 04             	mov    0x4(%eax),%eax
 afa:	c1 e0 03             	shl    $0x3,%eax
 afd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b03:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b06:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b0c:	a3 cc 0e 00 00       	mov    %eax,0xecc
      return (void*)(p + 1);
 b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b14:	83 c0 08             	add    $0x8,%eax
 b17:	eb 3b                	jmp    b54 <malloc+0xe1>
    }
    if(p == freep)
 b19:	a1 cc 0e 00 00       	mov    0xecc,%eax
 b1e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b21:	75 1e                	jne    b41 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b23:	83 ec 0c             	sub    $0xc,%esp
 b26:	ff 75 ec             	pushl  -0x14(%ebp)
 b29:	e8 e5 fe ff ff       	call   a13 <morecore>
 b2e:	83 c4 10             	add    $0x10,%esp
 b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b38:	75 07                	jne    b41 <malloc+0xce>
        return 0;
 b3a:	b8 00 00 00 00       	mov    $0x0,%eax
 b3f:	eb 13                	jmp    b54 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4a:	8b 00                	mov    (%eax),%eax
 b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b4f:	e9 6d ff ff ff       	jmp    ac1 <malloc+0x4e>
}
 b54:	c9                   	leave  
 b55:	c3                   	ret    
