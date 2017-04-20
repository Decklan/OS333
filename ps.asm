
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
  1c:	e8 40 09 00 00       	call   961 <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if (!table) 
  27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  2b:	75 1c                	jne    49 <main+0x49>
  {
    printf(2, "Error. Malloc call failed.");
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	68 44 0a 00 00       	push   $0xa44
  35:	6a 02                	push   $0x2
  37:	e8 52 06 00 00       	call   68e <printf>
  3c:	83 c4 10             	add    $0x10,%esp
    return -1;
  3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  44:	e9 e6 01 00 00       	jmp    22f <main+0x22f>
  }
  
  int status = getprocs(MAX, table);
  49:	83 ec 08             	sub    $0x8,%esp
  4c:	ff 75 e0             	pushl  -0x20(%ebp)
  4f:	6a 20                	push   $0x20
  51:	e8 59 05 00 00       	call   5af <getprocs>
  56:	83 c4 10             	add    $0x10,%esp
  59:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (status < 0)
  5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  60:	79 17                	jns    79 <main+0x79>
    printf(2, "Error. Not enough memory for the table.\n");
  62:	83 ec 08             	sub    $0x8,%esp
  65:	68 60 0a 00 00       	push   $0xa60
  6a:	6a 02                	push   $0x2
  6c:	e8 1d 06 00 00       	call   68e <printf>
  71:	83 c4 10             	add    $0x10,%esp
  74:	e9 b1 01 00 00       	jmp    22a <main+0x22a>
  else
  {
    printf(1, "Name       State         PID  UID  GID  PPID  Size       Elapsed       Total\n");
  79:	83 ec 08             	sub    $0x8,%esp
  7c:	68 8c 0a 00 00       	push   $0xa8c
  81:	6a 01                	push   $0x1
  83:	e8 06 06 00 00       	call   68e <printf>
  88:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < status; ++i)
  8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  92:	e9 72 01 00 00       	jmp    209 <main+0x209>
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
  97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  9a:	6b d0 5c             	imul   $0x5c,%eax,%edx
  9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 40 10             	mov    0x10(%eax),%eax
  a5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  aa:	f7 e2                	mul    %edx
  ac:	89 d0                	mov    %edx,%eax
  ae:	c1 e8 05             	shr    $0x5,%eax
  b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
  b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  b7:	6b d0 5c             	imul   $0x5c,%eax,%edx
  ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  bd:	01 d0                	add    %edx,%eax
  bf:	8b 48 10             	mov    0x10(%eax),%ecx
  c2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  c7:	89 c8                	mov    %ecx,%eax
  c9:	f7 e2                	mul    %edx
  cb:	89 d0                	mov    %edx,%eax
  cd:	c1 e8 05             	shr    $0x5,%eax
  d0:	6b c0 64             	imul   $0x64,%eax,%eax
  d3:	29 c1                	sub    %eax,%ecx
  d5:	89 c8                	mov    %ecx,%eax
  d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      int total_cpu_secs = table[i].CPU_total_ticks/100;
  da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  dd:	6b d0 5c             	imul   $0x5c,%eax,%edx
  e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e3:	01 d0                	add    %edx,%eax
  e5:	8b 40 14             	mov    0x14(%eax),%eax
  e8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  ed:	f7 e2                	mul    %edx
  ef:	89 d0                	mov    %edx,%eax
  f1:	c1 e8 05             	shr    $0x5,%eax
  f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
  f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  fa:	6b d0 5c             	imul   $0x5c,%eax,%edx
  fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
 100:	01 d0                	add    %edx,%eax
 102:	8b 48 14             	mov    0x14(%eax),%ecx
 105:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 10a:	89 c8                	mov    %ecx,%eax
 10c:	f7 e2                	mul    %edx
 10e:	89 d0                	mov    %edx,%eax
 110:	c1 e8 05             	shr    $0x5,%eax
 113:	6b c0 64             	imul   $0x64,%eax,%eax
 116:	29 c1                	sub    %eax,%ecx
 118:	89 c8                	mov    %ecx,%eax
 11a:	89 45 cc             	mov    %eax,-0x34(%ebp)
      printf(1, "%s        %s        %d    %d   %d   %d     %d", table[i].name, table[i].state, table[i].pid, table[i].uid, 
            table[i].gid, table[i].ppid, table[i].size);
 11d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 120:	6b d0 5c             	imul   $0x5c,%eax,%edx
 123:	8b 45 e0             	mov    -0x20(%ebp),%eax
 126:	01 d0                	add    %edx,%eax
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%s        %s        %d    %d   %d   %d     %d", table[i].name, table[i].state, table[i].pid, table[i].uid, 
 128:	8b 40 38             	mov    0x38(%eax),%eax
 12b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            table[i].gid, table[i].ppid, table[i].size);
 12e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 131:	6b d0 5c             	imul   $0x5c,%eax,%edx
 134:	8b 45 e0             	mov    -0x20(%ebp),%eax
 137:	01 d0                	add    %edx,%eax
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%s        %s        %d    %d   %d   %d     %d", table[i].name, table[i].state, table[i].pid, table[i].uid, 
 139:	8b 58 0c             	mov    0xc(%eax),%ebx
 13c:	89 5d c0             	mov    %ebx,-0x40(%ebp)
            table[i].gid, table[i].ppid, table[i].size);
 13f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 142:	6b d0 5c             	imul   $0x5c,%eax,%edx
 145:	8b 45 e0             	mov    -0x20(%ebp),%eax
 148:	01 d0                	add    %edx,%eax
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%s        %s        %d    %d   %d   %d     %d", table[i].name, table[i].state, table[i].pid, table[i].uid, 
 14a:	8b 78 08             	mov    0x8(%eax),%edi
 14d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 150:	6b d0 5c             	imul   $0x5c,%eax,%edx
 153:	8b 45 e0             	mov    -0x20(%ebp),%eax
 156:	01 d0                	add    %edx,%eax
 158:	8b 70 04             	mov    0x4(%eax),%esi
 15b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 15e:	6b d0 5c             	imul   $0x5c,%eax,%edx
 161:	8b 45 e0             	mov    -0x20(%ebp),%eax
 164:	01 d0                	add    %edx,%eax
 166:	8b 18                	mov    (%eax),%ebx
 168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 16b:	6b d0 5c             	imul   $0x5c,%eax,%edx
 16e:	8b 45 e0             	mov    -0x20(%ebp),%eax
 171:	01 d0                	add    %edx,%eax
 173:	8d 48 18             	lea    0x18(%eax),%ecx
 176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 179:	6b d0 5c             	imul   $0x5c,%eax,%edx
 17c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 17f:	01 d0                	add    %edx,%eax
 181:	83 c0 3c             	add    $0x3c,%eax
 184:	83 ec 0c             	sub    $0xc,%esp
 187:	ff 75 c4             	pushl  -0x3c(%ebp)
 18a:	ff 75 c0             	pushl  -0x40(%ebp)
 18d:	57                   	push   %edi
 18e:	56                   	push   %esi
 18f:	53                   	push   %ebx
 190:	51                   	push   %ecx
 191:	50                   	push   %eax
 192:	68 dc 0a 00 00       	push   $0xadc
 197:	6a 01                	push   $0x1
 199:	e8 f0 04 00 00       	call   68e <printf>
 19e:	83 c4 30             	add    $0x30,%esp
            table[i].gid, table[i].ppid, table[i].size);
    
      if (partial_elapsed_secs < 10)
 1a1:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
 1a5:	7f 17                	jg     1be <main+0x1be>
        printf(1, "       %d.0%d", elapsed_secs, partial_elapsed_secs);
 1a7:	ff 75 d4             	pushl  -0x2c(%ebp)
 1aa:	ff 75 d8             	pushl  -0x28(%ebp)
 1ad:	68 0a 0b 00 00       	push   $0xb0a
 1b2:	6a 01                	push   $0x1
 1b4:	e8 d5 04 00 00       	call   68e <printf>
 1b9:	83 c4 10             	add    $0x10,%esp
 1bc:	eb 15                	jmp    1d3 <main+0x1d3>
      else
        printf(1, "       %d.%d", elapsed_secs, partial_elapsed_secs);
 1be:	ff 75 d4             	pushl  -0x2c(%ebp)
 1c1:	ff 75 d8             	pushl  -0x28(%ebp)
 1c4:	68 18 0b 00 00       	push   $0xb18
 1c9:	6a 01                	push   $0x1
 1cb:	e8 be 04 00 00       	call   68e <printf>
 1d0:	83 c4 10             	add    $0x10,%esp

      if (partial_cpu_secs < 10)
 1d3:	83 7d cc 09          	cmpl   $0x9,-0x34(%ebp)
 1d7:	7f 17                	jg     1f0 <main+0x1f0>
        printf(1, "       %d.0%d\n", total_cpu_secs, partial_cpu_secs);
 1d9:	ff 75 cc             	pushl  -0x34(%ebp)
 1dc:	ff 75 d0             	pushl  -0x30(%ebp)
 1df:	68 25 0b 00 00       	push   $0xb25
 1e4:	6a 01                	push   $0x1
 1e6:	e8 a3 04 00 00       	call   68e <printf>
 1eb:	83 c4 10             	add    $0x10,%esp
 1ee:	eb 15                	jmp    205 <main+0x205>
      else
        printf(1, "       %d.%d\n", total_cpu_secs, partial_cpu_secs);
 1f0:	ff 75 cc             	pushl  -0x34(%ebp)
 1f3:	ff 75 d0             	pushl  -0x30(%ebp)
 1f6:	68 34 0b 00 00       	push   $0xb34
 1fb:	6a 01                	push   $0x1
 1fd:	e8 8c 04 00 00       	call   68e <printf>
 202:	83 c4 10             	add    $0x10,%esp
  if (status < 0)
    printf(2, "Error. Not enough memory for the table.\n");
  else
  {
    printf(1, "Name       State         PID  UID  GID  PPID  Size       Elapsed       Total\n");
    for (int i = 0; i < status; ++i)
 205:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 20c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 20f:	0f 8c 82 fe ff ff    	jl     97 <main+0x97>
      if (partial_cpu_secs < 10)
        printf(1, "       %d.0%d\n", total_cpu_secs, partial_cpu_secs);
      else
        printf(1, "       %d.%d\n", total_cpu_secs, partial_cpu_secs);
    }
    printf(1, "%d system calls used.\n", status);
 215:	83 ec 04             	sub    $0x4,%esp
 218:	ff 75 dc             	pushl  -0x24(%ebp)
 21b:	68 42 0b 00 00       	push   $0xb42
 220:	6a 01                	push   $0x1
 222:	e8 67 04 00 00       	call   68e <printf>
 227:	83 c4 10             	add    $0x10,%esp
  }
  exit();
 22a:	e8 a8 02 00 00       	call   4d7 <exit>
}
 22f:	8d 65 f0             	lea    -0x10(%ebp),%esp
 232:	59                   	pop    %ecx
 233:	5b                   	pop    %ebx
 234:	5e                   	pop    %esi
 235:	5f                   	pop    %edi
 236:	5d                   	pop    %ebp
 237:	8d 61 fc             	lea    -0x4(%ecx),%esp
 23a:	c3                   	ret    

0000023b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 23b:	55                   	push   %ebp
 23c:	89 e5                	mov    %esp,%ebp
 23e:	57                   	push   %edi
 23f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 240:	8b 4d 08             	mov    0x8(%ebp),%ecx
 243:	8b 55 10             	mov    0x10(%ebp),%edx
 246:	8b 45 0c             	mov    0xc(%ebp),%eax
 249:	89 cb                	mov    %ecx,%ebx
 24b:	89 df                	mov    %ebx,%edi
 24d:	89 d1                	mov    %edx,%ecx
 24f:	fc                   	cld    
 250:	f3 aa                	rep stos %al,%es:(%edi)
 252:	89 ca                	mov    %ecx,%edx
 254:	89 fb                	mov    %edi,%ebx
 256:	89 5d 08             	mov    %ebx,0x8(%ebp)
 259:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 25c:	90                   	nop
 25d:	5b                   	pop    %ebx
 25e:	5f                   	pop    %edi
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret    

00000261 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 261:	55                   	push   %ebp
 262:	89 e5                	mov    %esp,%ebp
 264:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 26d:	90                   	nop
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	8d 50 01             	lea    0x1(%eax),%edx
 274:	89 55 08             	mov    %edx,0x8(%ebp)
 277:	8b 55 0c             	mov    0xc(%ebp),%edx
 27a:	8d 4a 01             	lea    0x1(%edx),%ecx
 27d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 280:	0f b6 12             	movzbl (%edx),%edx
 283:	88 10                	mov    %dl,(%eax)
 285:	0f b6 00             	movzbl (%eax),%eax
 288:	84 c0                	test   %al,%al
 28a:	75 e2                	jne    26e <strcpy+0xd>
    ;
  return os;
 28c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28f:	c9                   	leave  
 290:	c3                   	ret    

00000291 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 294:	eb 08                	jmp    29e <strcmp+0xd>
    p++, q++;
 296:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 29a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	0f b6 00             	movzbl (%eax),%eax
 2a4:	84 c0                	test   %al,%al
 2a6:	74 10                	je     2b8 <strcmp+0x27>
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 10             	movzbl (%eax),%edx
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	38 c2                	cmp    %al,%dl
 2b6:	74 de                	je     296 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	0f b6 d0             	movzbl %al,%edx
 2c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c4:	0f b6 00             	movzbl (%eax),%eax
 2c7:	0f b6 c0             	movzbl %al,%eax
 2ca:	29 c2                	sub    %eax,%edx
 2cc:	89 d0                	mov    %edx,%eax
}
 2ce:	5d                   	pop    %ebp
 2cf:	c3                   	ret    

000002d0 <strlen>:

uint
strlen(char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2dd:	eb 04                	jmp    2e3 <strlen+0x13>
 2df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	01 d0                	add    %edx,%eax
 2eb:	0f b6 00             	movzbl (%eax),%eax
 2ee:	84 c0                	test   %al,%al
 2f0:	75 ed                	jne    2df <strlen+0xf>
    ;
  return n;
 2f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f5:	c9                   	leave  
 2f6:	c3                   	ret    

000002f7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f7:	55                   	push   %ebp
 2f8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2fa:	8b 45 10             	mov    0x10(%ebp),%eax
 2fd:	50                   	push   %eax
 2fe:	ff 75 0c             	pushl  0xc(%ebp)
 301:	ff 75 08             	pushl  0x8(%ebp)
 304:	e8 32 ff ff ff       	call   23b <stosb>
 309:	83 c4 0c             	add    $0xc,%esp
  return dst;
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 30f:	c9                   	leave  
 310:	c3                   	ret    

00000311 <strchr>:

char*
strchr(const char *s, char c)
{
 311:	55                   	push   %ebp
 312:	89 e5                	mov    %esp,%ebp
 314:	83 ec 04             	sub    $0x4,%esp
 317:	8b 45 0c             	mov    0xc(%ebp),%eax
 31a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 31d:	eb 14                	jmp    333 <strchr+0x22>
    if(*s == c)
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	3a 45 fc             	cmp    -0x4(%ebp),%al
 328:	75 05                	jne    32f <strchr+0x1e>
      return (char*)s;
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	eb 13                	jmp    342 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 32f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	0f b6 00             	movzbl (%eax),%eax
 339:	84 c0                	test   %al,%al
 33b:	75 e2                	jne    31f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 33d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 342:	c9                   	leave  
 343:	c3                   	ret    

00000344 <gets>:

char*
gets(char *buf, int max)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 351:	eb 42                	jmp    395 <gets+0x51>
    cc = read(0, &c, 1);
 353:	83 ec 04             	sub    $0x4,%esp
 356:	6a 01                	push   $0x1
 358:	8d 45 ef             	lea    -0x11(%ebp),%eax
 35b:	50                   	push   %eax
 35c:	6a 00                	push   $0x0
 35e:	e8 8c 01 00 00       	call   4ef <read>
 363:	83 c4 10             	add    $0x10,%esp
 366:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 369:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 36d:	7e 33                	jle    3a2 <gets+0x5e>
      break;
    buf[i++] = c;
 36f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 372:	8d 50 01             	lea    0x1(%eax),%edx
 375:	89 55 f4             	mov    %edx,-0xc(%ebp)
 378:	89 c2                	mov    %eax,%edx
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	01 c2                	add    %eax,%edx
 37f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 383:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 385:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 389:	3c 0a                	cmp    $0xa,%al
 38b:	74 16                	je     3a3 <gets+0x5f>
 38d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 391:	3c 0d                	cmp    $0xd,%al
 393:	74 0e                	je     3a3 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 395:	8b 45 f4             	mov    -0xc(%ebp),%eax
 398:	83 c0 01             	add    $0x1,%eax
 39b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 39e:	7c b3                	jl     353 <gets+0xf>
 3a0:	eb 01                	jmp    3a3 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3a2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	01 d0                	add    %edx,%eax
 3ab:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3b1:	c9                   	leave  
 3b2:	c3                   	ret    

000003b3 <stat>:

int
stat(char *n, struct stat *st)
{
 3b3:	55                   	push   %ebp
 3b4:	89 e5                	mov    %esp,%ebp
 3b6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b9:	83 ec 08             	sub    $0x8,%esp
 3bc:	6a 00                	push   $0x0
 3be:	ff 75 08             	pushl  0x8(%ebp)
 3c1:	e8 51 01 00 00       	call   517 <open>
 3c6:	83 c4 10             	add    $0x10,%esp
 3c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3d0:	79 07                	jns    3d9 <stat+0x26>
    return -1;
 3d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3d7:	eb 25                	jmp    3fe <stat+0x4b>
  r = fstat(fd, st);
 3d9:	83 ec 08             	sub    $0x8,%esp
 3dc:	ff 75 0c             	pushl  0xc(%ebp)
 3df:	ff 75 f4             	pushl  -0xc(%ebp)
 3e2:	e8 48 01 00 00       	call   52f <fstat>
 3e7:	83 c4 10             	add    $0x10,%esp
 3ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3ed:	83 ec 0c             	sub    $0xc,%esp
 3f0:	ff 75 f4             	pushl  -0xc(%ebp)
 3f3:	e8 07 01 00 00       	call   4ff <close>
 3f8:	83 c4 10             	add    $0x10,%esp
  return r;
 3fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3fe:	c9                   	leave  
 3ff:	c3                   	ret    

00000400 <atoi>:

int
atoi(const char *s)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 406:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 40d:	eb 04                	jmp    413 <atoi+0x13>
 40f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	0f b6 00             	movzbl (%eax),%eax
 419:	3c 20                	cmp    $0x20,%al
 41b:	74 f2                	je     40f <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
 420:	0f b6 00             	movzbl (%eax),%eax
 423:	3c 2d                	cmp    $0x2d,%al
 425:	75 07                	jne    42e <atoi+0x2e>
 427:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 42c:	eb 05                	jmp    433 <atoi+0x33>
 42e:	b8 01 00 00 00       	mov    $0x1,%eax
 433:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	3c 2b                	cmp    $0x2b,%al
 43e:	74 0a                	je     44a <atoi+0x4a>
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	0f b6 00             	movzbl (%eax),%eax
 446:	3c 2d                	cmp    $0x2d,%al
 448:	75 2b                	jne    475 <atoi+0x75>
    s++;
 44a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 44e:	eb 25                	jmp    475 <atoi+0x75>
    n = n*10 + *s++ - '0';
 450:	8b 55 fc             	mov    -0x4(%ebp),%edx
 453:	89 d0                	mov    %edx,%eax
 455:	c1 e0 02             	shl    $0x2,%eax
 458:	01 d0                	add    %edx,%eax
 45a:	01 c0                	add    %eax,%eax
 45c:	89 c1                	mov    %eax,%ecx
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	8d 50 01             	lea    0x1(%eax),%edx
 464:	89 55 08             	mov    %edx,0x8(%ebp)
 467:	0f b6 00             	movzbl (%eax),%eax
 46a:	0f be c0             	movsbl %al,%eax
 46d:	01 c8                	add    %ecx,%eax
 46f:	83 e8 30             	sub    $0x30,%eax
 472:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	0f b6 00             	movzbl (%eax),%eax
 47b:	3c 2f                	cmp    $0x2f,%al
 47d:	7e 0a                	jle    489 <atoi+0x89>
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	0f b6 00             	movzbl (%eax),%eax
 485:	3c 39                	cmp    $0x39,%al
 487:	7e c7                	jle    450 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 489:	8b 45 f8             	mov    -0x8(%ebp),%eax
 48c:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 490:	c9                   	leave  
 491:	c3                   	ret    

00000492 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 492:	55                   	push   %ebp
 493:	89 e5                	mov    %esp,%ebp
 495:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 49e:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4a4:	eb 17                	jmp    4bd <memmove+0x2b>
    *dst++ = *src++;
 4a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4a9:	8d 50 01             	lea    0x1(%eax),%edx
 4ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4af:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4b2:	8d 4a 01             	lea    0x1(%edx),%ecx
 4b5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4b8:	0f b6 12             	movzbl (%edx),%edx
 4bb:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4bd:	8b 45 10             	mov    0x10(%ebp),%eax
 4c0:	8d 50 ff             	lea    -0x1(%eax),%edx
 4c3:	89 55 10             	mov    %edx,0x10(%ebp)
 4c6:	85 c0                	test   %eax,%eax
 4c8:	7f dc                	jg     4a6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4cd:	c9                   	leave  
 4ce:	c3                   	ret    

000004cf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4cf:	b8 01 00 00 00       	mov    $0x1,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <exit>:
SYSCALL(exit)
 4d7:	b8 02 00 00 00       	mov    $0x2,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <wait>:
SYSCALL(wait)
 4df:	b8 03 00 00 00       	mov    $0x3,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <pipe>:
SYSCALL(pipe)
 4e7:	b8 04 00 00 00       	mov    $0x4,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <read>:
SYSCALL(read)
 4ef:	b8 05 00 00 00       	mov    $0x5,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <write>:
SYSCALL(write)
 4f7:	b8 10 00 00 00       	mov    $0x10,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <close>:
SYSCALL(close)
 4ff:	b8 15 00 00 00       	mov    $0x15,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <kill>:
SYSCALL(kill)
 507:	b8 06 00 00 00       	mov    $0x6,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <exec>:
SYSCALL(exec)
 50f:	b8 07 00 00 00       	mov    $0x7,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <open>:
SYSCALL(open)
 517:	b8 0f 00 00 00       	mov    $0xf,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <mknod>:
SYSCALL(mknod)
 51f:	b8 11 00 00 00       	mov    $0x11,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <unlink>:
SYSCALL(unlink)
 527:	b8 12 00 00 00       	mov    $0x12,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <fstat>:
SYSCALL(fstat)
 52f:	b8 08 00 00 00       	mov    $0x8,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <link>:
SYSCALL(link)
 537:	b8 13 00 00 00       	mov    $0x13,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <mkdir>:
SYSCALL(mkdir)
 53f:	b8 14 00 00 00       	mov    $0x14,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <chdir>:
SYSCALL(chdir)
 547:	b8 09 00 00 00       	mov    $0x9,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <dup>:
SYSCALL(dup)
 54f:	b8 0a 00 00 00       	mov    $0xa,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <getpid>:
SYSCALL(getpid)
 557:	b8 0b 00 00 00       	mov    $0xb,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <sbrk>:
SYSCALL(sbrk)
 55f:	b8 0c 00 00 00       	mov    $0xc,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <sleep>:
SYSCALL(sleep)
 567:	b8 0d 00 00 00       	mov    $0xd,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <uptime>:
SYSCALL(uptime)
 56f:	b8 0e 00 00 00       	mov    $0xe,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <halt>:
SYSCALL(halt)
 577:	b8 16 00 00 00       	mov    $0x16,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <date>:
SYSCALL(date)      #p1
 57f:	b8 17 00 00 00       	mov    $0x17,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <getuid>:
SYSCALL(getuid)    #p2
 587:	b8 18 00 00 00       	mov    $0x18,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <getgid>:
SYSCALL(getgid)    #p2
 58f:	b8 19 00 00 00       	mov    $0x19,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <getppid>:
SYSCALL(getppid)   #p2
 597:	b8 1a 00 00 00       	mov    $0x1a,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <setuid>:
SYSCALL(setuid)    #p2
 59f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <setgid>:
SYSCALL(setgid)    #p2
 5a7:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <getprocs>:
SYSCALL(getprocs)  #p2
 5af:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5b7:	55                   	push   %ebp
 5b8:	89 e5                	mov    %esp,%ebp
 5ba:	83 ec 18             	sub    $0x18,%esp
 5bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5c3:	83 ec 04             	sub    $0x4,%esp
 5c6:	6a 01                	push   $0x1
 5c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5cb:	50                   	push   %eax
 5cc:	ff 75 08             	pushl  0x8(%ebp)
 5cf:	e8 23 ff ff ff       	call   4f7 <write>
 5d4:	83 c4 10             	add    $0x10,%esp
}
 5d7:	90                   	nop
 5d8:	c9                   	leave  
 5d9:	c3                   	ret    

000005da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5da:	55                   	push   %ebp
 5db:	89 e5                	mov    %esp,%ebp
 5dd:	53                   	push   %ebx
 5de:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5e8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5ec:	74 17                	je     605 <printint+0x2b>
 5ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5f2:	79 11                	jns    605 <printint+0x2b>
    neg = 1;
 5f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fe:	f7 d8                	neg    %eax
 600:	89 45 ec             	mov    %eax,-0x14(%ebp)
 603:	eb 06                	jmp    60b <printint+0x31>
  } else {
    x = xx;
 605:	8b 45 0c             	mov    0xc(%ebp),%eax
 608:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 60b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 612:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 615:	8d 41 01             	lea    0x1(%ecx),%eax
 618:	89 45 f4             	mov    %eax,-0xc(%ebp)
 61b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 61e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 621:	ba 00 00 00 00       	mov    $0x0,%edx
 626:	f7 f3                	div    %ebx
 628:	89 d0                	mov    %edx,%eax
 62a:	0f b6 80 c8 0d 00 00 	movzbl 0xdc8(%eax),%eax
 631:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 635:	8b 5d 10             	mov    0x10(%ebp),%ebx
 638:	8b 45 ec             	mov    -0x14(%ebp),%eax
 63b:	ba 00 00 00 00       	mov    $0x0,%edx
 640:	f7 f3                	div    %ebx
 642:	89 45 ec             	mov    %eax,-0x14(%ebp)
 645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 649:	75 c7                	jne    612 <printint+0x38>
  if(neg)
 64b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 64f:	74 2d                	je     67e <printint+0xa4>
    buf[i++] = '-';
 651:	8b 45 f4             	mov    -0xc(%ebp),%eax
 654:	8d 50 01             	lea    0x1(%eax),%edx
 657:	89 55 f4             	mov    %edx,-0xc(%ebp)
 65a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 65f:	eb 1d                	jmp    67e <printint+0xa4>
    putc(fd, buf[i]);
 661:	8d 55 dc             	lea    -0x24(%ebp),%edx
 664:	8b 45 f4             	mov    -0xc(%ebp),%eax
 667:	01 d0                	add    %edx,%eax
 669:	0f b6 00             	movzbl (%eax),%eax
 66c:	0f be c0             	movsbl %al,%eax
 66f:	83 ec 08             	sub    $0x8,%esp
 672:	50                   	push   %eax
 673:	ff 75 08             	pushl  0x8(%ebp)
 676:	e8 3c ff ff ff       	call   5b7 <putc>
 67b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 67e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 686:	79 d9                	jns    661 <printint+0x87>
    putc(fd, buf[i]);
}
 688:	90                   	nop
 689:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 68c:	c9                   	leave  
 68d:	c3                   	ret    

0000068e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 68e:	55                   	push   %ebp
 68f:	89 e5                	mov    %esp,%ebp
 691:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 694:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 69b:	8d 45 0c             	lea    0xc(%ebp),%eax
 69e:	83 c0 04             	add    $0x4,%eax
 6a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6ab:	e9 59 01 00 00       	jmp    809 <printf+0x17b>
    c = fmt[i] & 0xff;
 6b0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b6:	01 d0                	add    %edx,%eax
 6b8:	0f b6 00             	movzbl (%eax),%eax
 6bb:	0f be c0             	movsbl %al,%eax
 6be:	25 ff 00 00 00       	and    $0xff,%eax
 6c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6ca:	75 2c                	jne    6f8 <printf+0x6a>
      if(c == '%'){
 6cc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d0:	75 0c                	jne    6de <printf+0x50>
        state = '%';
 6d2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6d9:	e9 27 01 00 00       	jmp    805 <printf+0x177>
      } else {
        putc(fd, c);
 6de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e1:	0f be c0             	movsbl %al,%eax
 6e4:	83 ec 08             	sub    $0x8,%esp
 6e7:	50                   	push   %eax
 6e8:	ff 75 08             	pushl  0x8(%ebp)
 6eb:	e8 c7 fe ff ff       	call   5b7 <putc>
 6f0:	83 c4 10             	add    $0x10,%esp
 6f3:	e9 0d 01 00 00       	jmp    805 <printf+0x177>
      }
    } else if(state == '%'){
 6f8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6fc:	0f 85 03 01 00 00    	jne    805 <printf+0x177>
      if(c == 'd'){
 702:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 706:	75 1e                	jne    726 <printf+0x98>
        printint(fd, *ap, 10, 1);
 708:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	6a 01                	push   $0x1
 70f:	6a 0a                	push   $0xa
 711:	50                   	push   %eax
 712:	ff 75 08             	pushl  0x8(%ebp)
 715:	e8 c0 fe ff ff       	call   5da <printint>
 71a:	83 c4 10             	add    $0x10,%esp
        ap++;
 71d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 721:	e9 d8 00 00 00       	jmp    7fe <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 726:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 72a:	74 06                	je     732 <printf+0xa4>
 72c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 730:	75 1e                	jne    750 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 732:	8b 45 e8             	mov    -0x18(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	6a 00                	push   $0x0
 739:	6a 10                	push   $0x10
 73b:	50                   	push   %eax
 73c:	ff 75 08             	pushl  0x8(%ebp)
 73f:	e8 96 fe ff ff       	call   5da <printint>
 744:	83 c4 10             	add    $0x10,%esp
        ap++;
 747:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 74b:	e9 ae 00 00 00       	jmp    7fe <printf+0x170>
      } else if(c == 's'){
 750:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 754:	75 43                	jne    799 <printf+0x10b>
        s = (char*)*ap;
 756:	8b 45 e8             	mov    -0x18(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 75e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 762:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 766:	75 25                	jne    78d <printf+0xff>
          s = "(null)";
 768:	c7 45 f4 59 0b 00 00 	movl   $0xb59,-0xc(%ebp)
        while(*s != 0){
 76f:	eb 1c                	jmp    78d <printf+0xff>
          putc(fd, *s);
 771:	8b 45 f4             	mov    -0xc(%ebp),%eax
 774:	0f b6 00             	movzbl (%eax),%eax
 777:	0f be c0             	movsbl %al,%eax
 77a:	83 ec 08             	sub    $0x8,%esp
 77d:	50                   	push   %eax
 77e:	ff 75 08             	pushl  0x8(%ebp)
 781:	e8 31 fe ff ff       	call   5b7 <putc>
 786:	83 c4 10             	add    $0x10,%esp
          s++;
 789:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	0f b6 00             	movzbl (%eax),%eax
 793:	84 c0                	test   %al,%al
 795:	75 da                	jne    771 <printf+0xe3>
 797:	eb 65                	jmp    7fe <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 799:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 79d:	75 1d                	jne    7bc <printf+0x12e>
        putc(fd, *ap);
 79f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a2:	8b 00                	mov    (%eax),%eax
 7a4:	0f be c0             	movsbl %al,%eax
 7a7:	83 ec 08             	sub    $0x8,%esp
 7aa:	50                   	push   %eax
 7ab:	ff 75 08             	pushl  0x8(%ebp)
 7ae:	e8 04 fe ff ff       	call   5b7 <putc>
 7b3:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ba:	eb 42                	jmp    7fe <printf+0x170>
      } else if(c == '%'){
 7bc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7c0:	75 17                	jne    7d9 <printf+0x14b>
        putc(fd, c);
 7c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7c5:	0f be c0             	movsbl %al,%eax
 7c8:	83 ec 08             	sub    $0x8,%esp
 7cb:	50                   	push   %eax
 7cc:	ff 75 08             	pushl  0x8(%ebp)
 7cf:	e8 e3 fd ff ff       	call   5b7 <putc>
 7d4:	83 c4 10             	add    $0x10,%esp
 7d7:	eb 25                	jmp    7fe <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7d9:	83 ec 08             	sub    $0x8,%esp
 7dc:	6a 25                	push   $0x25
 7de:	ff 75 08             	pushl  0x8(%ebp)
 7e1:	e8 d1 fd ff ff       	call   5b7 <putc>
 7e6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ec:	0f be c0             	movsbl %al,%eax
 7ef:	83 ec 08             	sub    $0x8,%esp
 7f2:	50                   	push   %eax
 7f3:	ff 75 08             	pushl  0x8(%ebp)
 7f6:	e8 bc fd ff ff       	call   5b7 <putc>
 7fb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 805:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 809:	8b 55 0c             	mov    0xc(%ebp),%edx
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	01 d0                	add    %edx,%eax
 811:	0f b6 00             	movzbl (%eax),%eax
 814:	84 c0                	test   %al,%al
 816:	0f 85 94 fe ff ff    	jne    6b0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 81c:	90                   	nop
 81d:	c9                   	leave  
 81e:	c3                   	ret    

0000081f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81f:	55                   	push   %ebp
 820:	89 e5                	mov    %esp,%ebp
 822:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 825:	8b 45 08             	mov    0x8(%ebp),%eax
 828:	83 e8 08             	sub    $0x8,%eax
 82b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82e:	a1 e4 0d 00 00       	mov    0xde4,%eax
 833:	89 45 fc             	mov    %eax,-0x4(%ebp)
 836:	eb 24                	jmp    85c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 838:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 840:	77 12                	ja     854 <free+0x35>
 842:	8b 45 f8             	mov    -0x8(%ebp),%eax
 845:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 848:	77 24                	ja     86e <free+0x4f>
 84a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84d:	8b 00                	mov    (%eax),%eax
 84f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 852:	77 1a                	ja     86e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	89 45 fc             	mov    %eax,-0x4(%ebp)
 85c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 862:	76 d4                	jbe    838 <free+0x19>
 864:	8b 45 fc             	mov    -0x4(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 86c:	76 ca                	jbe    838 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 86e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 871:	8b 40 04             	mov    0x4(%eax),%eax
 874:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 87b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87e:	01 c2                	add    %eax,%edx
 880:	8b 45 fc             	mov    -0x4(%ebp),%eax
 883:	8b 00                	mov    (%eax),%eax
 885:	39 c2                	cmp    %eax,%edx
 887:	75 24                	jne    8ad <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 889:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88c:	8b 50 04             	mov    0x4(%eax),%edx
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	8b 00                	mov    (%eax),%eax
 894:	8b 40 04             	mov    0x4(%eax),%eax
 897:	01 c2                	add    %eax,%edx
 899:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 89f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a2:	8b 00                	mov    (%eax),%eax
 8a4:	8b 10                	mov    (%eax),%edx
 8a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a9:	89 10                	mov    %edx,(%eax)
 8ab:	eb 0a                	jmp    8b7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b0:	8b 10                	mov    (%eax),%edx
 8b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c7:	01 d0                	add    %edx,%eax
 8c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8cc:	75 20                	jne    8ee <free+0xcf>
    p->s.size += bp->s.size;
 8ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d1:	8b 50 04             	mov    0x4(%eax),%edx
 8d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	01 c2                	add    %eax,%edx
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e5:	8b 10                	mov    (%eax),%edx
 8e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ea:	89 10                	mov    %edx,(%eax)
 8ec:	eb 08                	jmp    8f6 <free+0xd7>
  } else
    p->s.ptr = bp;
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8f4:	89 10                	mov    %edx,(%eax)
  freep = p;
 8f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f9:	a3 e4 0d 00 00       	mov    %eax,0xde4
}
 8fe:	90                   	nop
 8ff:	c9                   	leave  
 900:	c3                   	ret    

00000901 <morecore>:

static Header*
morecore(uint nu)
{
 901:	55                   	push   %ebp
 902:	89 e5                	mov    %esp,%ebp
 904:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 907:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 90e:	77 07                	ja     917 <morecore+0x16>
    nu = 4096;
 910:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 917:	8b 45 08             	mov    0x8(%ebp),%eax
 91a:	c1 e0 03             	shl    $0x3,%eax
 91d:	83 ec 0c             	sub    $0xc,%esp
 920:	50                   	push   %eax
 921:	e8 39 fc ff ff       	call   55f <sbrk>
 926:	83 c4 10             	add    $0x10,%esp
 929:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 92c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 930:	75 07                	jne    939 <morecore+0x38>
    return 0;
 932:	b8 00 00 00 00       	mov    $0x0,%eax
 937:	eb 26                	jmp    95f <morecore+0x5e>
  hp = (Header*)p;
 939:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 93f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 942:	8b 55 08             	mov    0x8(%ebp),%edx
 945:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 948:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94b:	83 c0 08             	add    $0x8,%eax
 94e:	83 ec 0c             	sub    $0xc,%esp
 951:	50                   	push   %eax
 952:	e8 c8 fe ff ff       	call   81f <free>
 957:	83 c4 10             	add    $0x10,%esp
  return freep;
 95a:	a1 e4 0d 00 00       	mov    0xde4,%eax
}
 95f:	c9                   	leave  
 960:	c3                   	ret    

00000961 <malloc>:

void*
malloc(uint nbytes)
{
 961:	55                   	push   %ebp
 962:	89 e5                	mov    %esp,%ebp
 964:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 967:	8b 45 08             	mov    0x8(%ebp),%eax
 96a:	83 c0 07             	add    $0x7,%eax
 96d:	c1 e8 03             	shr    $0x3,%eax
 970:	83 c0 01             	add    $0x1,%eax
 973:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 976:	a1 e4 0d 00 00       	mov    0xde4,%eax
 97b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 97e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 982:	75 23                	jne    9a7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 984:	c7 45 f0 dc 0d 00 00 	movl   $0xddc,-0x10(%ebp)
 98b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98e:	a3 e4 0d 00 00       	mov    %eax,0xde4
 993:	a1 e4 0d 00 00       	mov    0xde4,%eax
 998:	a3 dc 0d 00 00       	mov    %eax,0xddc
    base.s.size = 0;
 99d:	c7 05 e0 0d 00 00 00 	movl   $0x0,0xde0
 9a4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9aa:	8b 00                	mov    (%eax),%eax
 9ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b2:	8b 40 04             	mov    0x4(%eax),%eax
 9b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9b8:	72 4d                	jb     a07 <malloc+0xa6>
      if(p->s.size == nunits)
 9ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bd:	8b 40 04             	mov    0x4(%eax),%eax
 9c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9c3:	75 0c                	jne    9d1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c8:	8b 10                	mov    (%eax),%edx
 9ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cd:	89 10                	mov    %edx,(%eax)
 9cf:	eb 26                	jmp    9f7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d4:	8b 40 04             	mov    0x4(%eax),%eax
 9d7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9da:	89 c2                	mov    %eax,%edx
 9dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9df:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e5:	8b 40 04             	mov    0x4(%eax),%eax
 9e8:	c1 e0 03             	shl    $0x3,%eax
 9eb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9f4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fa:	a3 e4 0d 00 00       	mov    %eax,0xde4
      return (void*)(p + 1);
 9ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a02:	83 c0 08             	add    $0x8,%eax
 a05:	eb 3b                	jmp    a42 <malloc+0xe1>
    }
    if(p == freep)
 a07:	a1 e4 0d 00 00       	mov    0xde4,%eax
 a0c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a0f:	75 1e                	jne    a2f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a11:	83 ec 0c             	sub    $0xc,%esp
 a14:	ff 75 ec             	pushl  -0x14(%ebp)
 a17:	e8 e5 fe ff ff       	call   901 <morecore>
 a1c:	83 c4 10             	add    $0x10,%esp
 a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a26:	75 07                	jne    a2f <malloc+0xce>
        return 0;
 a28:	b8 00 00 00 00       	mov    $0x0,%eax
 a2d:	eb 13                	jmp    a42 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a38:	8b 00                	mov    (%eax),%eax
 a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a3d:	e9 6d ff ff ff       	jmp    9af <malloc+0x4e>
}
 a42:	c9                   	leave  
 a43:	c3                   	ret    
