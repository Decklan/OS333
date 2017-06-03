
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 f1 06 00 00       	call   703 <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 bd 06 00 00       	call   703 <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 a5 06 00 00       	call   703 <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 e4 12 00 00       	push   $0x12e4
  6d:	e8 e1 08 00 00       	call   953 <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 83 06 00 00       	call   703 <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 6c 06 00 00       	call   703 <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 e4 12 00 00       	add    $0x12e4,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 7f 06 00 00       	call   72a <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 e4 12 00 00       	mov    $0x12e4,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <print_mode>:

#ifdef CS333_P5
// this is an ugly series of if statements but it works
void
print_mode(struct stat *st)
{                                           
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  be:	8b 45 08             	mov    0x8(%ebp),%eax
  c1:	0f b7 00             	movzwl (%eax),%eax
  c4:	98                   	cwtl   
  c5:	83 f8 02             	cmp    $0x2,%eax
  c8:	74 1e                	je     e8 <print_mode+0x30>
  ca:	83 f8 03             	cmp    $0x3,%eax
  cd:	74 2d                	je     fc <print_mode+0x44>
  cf:	83 f8 01             	cmp    $0x1,%eax
  d2:	75 3c                	jne    110 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	68 25 0f 00 00       	push   $0xf25
  dc:	6a 01                	push   $0x1
  de:	e8 8c 0a 00 00       	call   b6f <printf>
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	eb 3a                	jmp    122 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  e8:	83 ec 08             	sub    $0x8,%esp
  eb:	68 27 0f 00 00       	push   $0xf27
  f0:	6a 01                	push   $0x1
  f2:	e8 78 0a 00 00       	call   b6f <printf>
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	eb 26                	jmp    122 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  fc:	83 ec 08             	sub    $0x8,%esp
  ff:	68 29 0f 00 00       	push   $0xf29
 104:	6a 01                	push   $0x1
 106:	e8 64 0a 00 00       	call   b6f <printf>
 10b:	83 c4 10             	add    $0x10,%esp
 10e:	eb 12                	jmp    122 <print_mode+0x6a>
    default: printf(1, "?");
 110:	83 ec 08             	sub    $0x8,%esp
 113:	68 2b 0f 00 00       	push   $0xf2b
 118:	6a 01                	push   $0x1
 11a:	e8 50 0a 00 00       	call   b6f <printf>
 11f:	83 c4 10             	add    $0x10,%esp
  }           
                                                                        
  if (st->mode.flags.u_r)
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	0f b6 40 15          	movzbl 0x15(%eax),%eax
 129:	83 e0 01             	and    $0x1,%eax
 12c:	84 c0                	test   %al,%al
 12e:	74 14                	je     144 <print_mode+0x8c>
    printf(1, "r");
 130:	83 ec 08             	sub    $0x8,%esp
 133:	68 2d 0f 00 00       	push   $0xf2d
 138:	6a 01                	push   $0x1
 13a:	e8 30 0a 00 00       	call   b6f <printf>
 13f:	83 c4 10             	add    $0x10,%esp
 142:	eb 12                	jmp    156 <print_mode+0x9e>
  else       
    printf(1, "-");                                
 144:	83 ec 08             	sub    $0x8,%esp
 147:	68 27 0f 00 00       	push   $0xf27
 14c:	6a 01                	push   $0x1
 14e:	e8 1c 0a 00 00       	call   b6f <printf>
 153:	83 c4 10             	add    $0x10,%esp
                                       
  if (st->mode.flags.u_w)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 15d:	83 e0 80             	and    $0xffffff80,%eax
 160:	84 c0                	test   %al,%al
 162:	74 14                	je     178 <print_mode+0xc0>
    printf(1, "w");
 164:	83 ec 08             	sub    $0x8,%esp
 167:	68 2f 0f 00 00       	push   $0xf2f
 16c:	6a 01                	push   $0x1
 16e:	e8 fc 09 00 00       	call   b6f <printf>
 173:	83 c4 10             	add    $0x10,%esp
 176:	eb 12                	jmp    18a <print_mode+0xd2>
  else                
    printf(1, "-");     
 178:	83 ec 08             	sub    $0x8,%esp
 17b:	68 27 0f 00 00       	push   $0xf27
 180:	6a 01                	push   $0x1
 182:	e8 e8 09 00 00       	call   b6f <printf>
 187:	83 c4 10             	add    $0x10,%esp
               
  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 191:	c0 e8 06             	shr    $0x6,%al
 194:	83 e0 01             	and    $0x1,%eax
 197:	0f b6 d0             	movzbl %al,%edx
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	0f b6 40 15          	movzbl 0x15(%eax),%eax
 1a1:	d0 e8                	shr    %al
 1a3:	83 e0 01             	and    $0x1,%eax
 1a6:	0f b6 c0             	movzbl %al,%eax
 1a9:	21 d0                	and    %edx,%eax
 1ab:	85 c0                	test   %eax,%eax
 1ad:	74 14                	je     1c3 <print_mode+0x10b>
    printf(1, "S");
 1af:	83 ec 08             	sub    $0x8,%esp
 1b2:	68 31 0f 00 00       	push   $0xf31
 1b7:	6a 01                	push   $0x1
 1b9:	e8 b1 09 00 00       	call   b6f <printf>
 1be:	83 c4 10             	add    $0x10,%esp
 1c1:	eb 34                	jmp    1f7 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 1ca:	83 e0 40             	and    $0x40,%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	74 14                	je     1e5 <print_mode+0x12d>
    printf(1, "x");
 1d1:	83 ec 08             	sub    $0x8,%esp
 1d4:	68 33 0f 00 00       	push   $0xf33
 1d9:	6a 01                	push   $0x1
 1db:	e8 8f 09 00 00       	call   b6f <printf>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	eb 12                	jmp    1f7 <print_mode+0x13f>
  else                                             
    printf(1, "-");   
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	68 27 0f 00 00       	push   $0xf27
 1ed:	6a 01                	push   $0x1
 1ef:	e8 7b 09 00 00       	call   b6f <printf>
 1f4:	83 c4 10             	add    $0x10,%esp
                 
  if (st->mode.flags.g_r)
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 1fe:	83 e0 20             	and    $0x20,%eax
 201:	84 c0                	test   %al,%al
 203:	74 14                	je     219 <print_mode+0x161>
    printf(1, "r"); 
 205:	83 ec 08             	sub    $0x8,%esp
 208:	68 2d 0f 00 00       	push   $0xf2d
 20d:	6a 01                	push   $0x1
 20f:	e8 5b 09 00 00       	call   b6f <printf>
 214:	83 c4 10             	add    $0x10,%esp
 217:	eb 12                	jmp    22b <print_mode+0x173>
  else                       
    printf(1, "-");                            
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	68 27 0f 00 00       	push   $0xf27
 221:	6a 01                	push   $0x1
 223:	e8 47 09 00 00       	call   b6f <printf>
 228:	83 c4 10             	add    $0x10,%esp
                 
  if (st->mode.flags.g_w)
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 232:	83 e0 10             	and    $0x10,%eax
 235:	84 c0                	test   %al,%al
 237:	74 14                	je     24d <print_mode+0x195>
    printf(1, "w");    
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	68 2f 0f 00 00       	push   $0xf2f
 241:	6a 01                	push   $0x1
 243:	e8 27 09 00 00       	call   b6f <printf>
 248:	83 c4 10             	add    $0x10,%esp
 24b:	eb 12                	jmp    25f <print_mode+0x1a7>
  else                                                                   
    printf(1, "-");
 24d:	83 ec 08             	sub    $0x8,%esp
 250:	68 27 0f 00 00       	push   $0xf27
 255:	6a 01                	push   $0x1
 257:	e8 13 09 00 00       	call   b6f <printf>
 25c:	83 c4 10             	add    $0x10,%esp
                                                                                           
  if (st->mode.flags.g_x)
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 266:	83 e0 08             	and    $0x8,%eax
 269:	84 c0                	test   %al,%al
 26b:	74 14                	je     281 <print_mode+0x1c9>
    printf(1, "x");
 26d:	83 ec 08             	sub    $0x8,%esp
 270:	68 33 0f 00 00       	push   $0xf33
 275:	6a 01                	push   $0x1
 277:	e8 f3 08 00 00       	call   b6f <printf>
 27c:	83 c4 10             	add    $0x10,%esp
 27f:	eb 12                	jmp    293 <print_mode+0x1db>
  else    
    printf(1, "-");
 281:	83 ec 08             	sub    $0x8,%esp
 284:	68 27 0f 00 00       	push   $0xf27
 289:	6a 01                	push   $0x1
 28b:	e8 df 08 00 00       	call   b6f <printf>
 290:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 29a:	83 e0 04             	and    $0x4,%eax
 29d:	84 c0                	test   %al,%al
 29f:	74 14                	je     2b5 <print_mode+0x1fd>
    printf(1, "r");
 2a1:	83 ec 08             	sub    $0x8,%esp
 2a4:	68 2d 0f 00 00       	push   $0xf2d
 2a9:	6a 01                	push   $0x1
 2ab:	e8 bf 08 00 00       	call   b6f <printf>
 2b0:	83 c4 10             	add    $0x10,%esp
 2b3:	eb 12                	jmp    2c7 <print_mode+0x20f>
  else
    printf(1, "-");
 2b5:	83 ec 08             	sub    $0x8,%esp
 2b8:	68 27 0f 00 00       	push   $0xf27
 2bd:	6a 01                	push   $0x1
 2bf:	e8 ab 08 00 00       	call   b6f <printf>
 2c4:	83 c4 10             	add    $0x10,%esp
                            
  if (st->mode.flags.o_w)
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 2ce:	83 e0 02             	and    $0x2,%eax
 2d1:	84 c0                	test   %al,%al
 2d3:	74 14                	je     2e9 <print_mode+0x231>
    printf(1, "w");
 2d5:	83 ec 08             	sub    $0x8,%esp
 2d8:	68 2f 0f 00 00       	push   $0xf2f
 2dd:	6a 01                	push   $0x1
 2df:	e8 8b 08 00 00       	call   b6f <printf>
 2e4:	83 c4 10             	add    $0x10,%esp
 2e7:	eb 12                	jmp    2fb <print_mode+0x243>
  else
    printf(1, "-");
 2e9:	83 ec 08             	sub    $0x8,%esp
 2ec:	68 27 0f 00 00       	push   $0xf27
 2f1:	6a 01                	push   $0x1
 2f3:	e8 77 08 00 00       	call   b6f <printf>
 2f8:	83 c4 10             	add    $0x10,%esp
            
  if (st->mode.flags.o_x)
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 302:	83 e0 01             	and    $0x1,%eax
 305:	84 c0                	test   %al,%al
 307:	74 14                	je     31d <print_mode+0x265>
    printf(1, "x");
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	68 33 0f 00 00       	push   $0xf33
 311:	6a 01                	push   $0x1
 313:	e8 57 08 00 00       	call   b6f <printf>
 318:	83 c4 10             	add    $0x10,%esp
  else                 
    printf(1, "-");
         
  return;
 31b:	eb 13                	jmp    330 <print_mode+0x278>
    printf(1, "-");
            
  if (st->mode.flags.o_x)
    printf(1, "x");
  else                 
    printf(1, "-");
 31d:	83 ec 08             	sub    $0x8,%esp
 320:	68 27 0f 00 00       	push   $0xf27
 325:	6a 01                	push   $0x1
 327:	e8 43 08 00 00       	call   b6f <printf>
 32c:	83 c4 10             	add    $0x10,%esp
         
  return;
 32f:	90                   	nop
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <ls>:
#endif

void
ls(char *path)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	57                   	push   %edi
 336:	56                   	push   %esi
 337:	53                   	push   %ebx
 338:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
 33e:	83 ec 08             	sub    $0x8,%esp
 341:	6a 00                	push   $0x0
 343:	ff 75 08             	pushl  0x8(%ebp)
 346:	e8 8d 06 00 00       	call   9d8 <open>
 34b:	83 c4 10             	add    $0x10,%esp
 34e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 351:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 355:	79 1a                	jns    371 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
 357:	83 ec 04             	sub    $0x4,%esp
 35a:	ff 75 08             	pushl  0x8(%ebp)
 35d:	68 35 0f 00 00       	push   $0xf35
 362:	6a 02                	push   $0x2
 364:	e8 06 08 00 00       	call   b6f <printf>
 369:	83 c4 10             	add    $0x10,%esp
    return;
 36c:	e9 91 02 00 00       	jmp    602 <ls+0x2d0>
  }
  
  if(fstat(fd, &st) < 0){
 371:	83 ec 08             	sub    $0x8,%esp
 374:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 37a:	50                   	push   %eax
 37b:	ff 75 e4             	pushl  -0x1c(%ebp)
 37e:	e8 6d 06 00 00       	call   9f0 <fstat>
 383:	83 c4 10             	add    $0x10,%esp
 386:	85 c0                	test   %eax,%eax
 388:	79 28                	jns    3b2 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 38a:	83 ec 04             	sub    $0x4,%esp
 38d:	ff 75 08             	pushl  0x8(%ebp)
 390:	68 49 0f 00 00       	push   $0xf49
 395:	6a 02                	push   $0x2
 397:	e8 d3 07 00 00       	call   b6f <printf>
 39c:	83 c4 10             	add    $0x10,%esp
    close(fd);
 39f:	83 ec 0c             	sub    $0xc,%esp
 3a2:	ff 75 e4             	pushl  -0x1c(%ebp)
 3a5:	e8 16 06 00 00       	call   9c0 <close>
 3aa:	83 c4 10             	add    $0x10,%esp
    return;
 3ad:	e9 50 02 00 00       	jmp    602 <ls+0x2d0>
  }
  
  switch(st.type){
 3b2:	0f b7 85 b4 fd ff ff 	movzwl -0x24c(%ebp),%eax
 3b9:	98                   	cwtl   
 3ba:	83 f8 01             	cmp    $0x1,%eax
 3bd:	0f 84 9d 00 00 00    	je     460 <ls+0x12e>
 3c3:	83 f8 02             	cmp    $0x2,%eax
 3c6:	0f 85 28 02 00 00    	jne    5f4 <ls+0x2c2>
  case T_FILE:
    #ifndef CS333_P5
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    #else
    printf(1, "%s\t %s\t %s\t %s\t %s\t %s\n", "Mode  ", "  Name       ", "        UID", "GID", "iNode", "Size");
 3cc:	68 5d 0f 00 00       	push   $0xf5d
 3d1:	68 62 0f 00 00       	push   $0xf62
 3d6:	68 68 0f 00 00       	push   $0xf68
 3db:	68 6c 0f 00 00       	push   $0xf6c
 3e0:	68 78 0f 00 00       	push   $0xf78
 3e5:	68 86 0f 00 00       	push   $0xf86
 3ea:	68 8d 0f 00 00       	push   $0xf8d
 3ef:	6a 01                	push   $0x1
 3f1:	e8 79 07 00 00       	call   b6f <printf>
 3f6:	83 c4 20             	add    $0x20,%esp
    print_mode(&st);
 3f9:	83 ec 0c             	sub    $0xc,%esp
 3fc:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 402:	50                   	push   %eax
 403:	e8 b0 fc ff ff       	call   b8 <print_mode>
 408:	83 c4 10             	add    $0x10,%esp
    printf(1, " %s\t %d\t %d\t %d\t %d\n", fmtname(path), st.uid, st.gid, st.ino, st.size);
 40b:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
 411:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 417:	8b bd bc fd ff ff    	mov    -0x244(%ebp),%edi
 41d:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
 424:	0f b7 f0             	movzwl %ax,%esi
 427:	0f b7 85 c2 fd ff ff 	movzwl -0x23e(%ebp),%eax
 42e:	0f b7 d8             	movzwl %ax,%ebx
 431:	83 ec 0c             	sub    $0xc,%esp
 434:	ff 75 08             	pushl  0x8(%ebp)
 437:	e8 c4 fb ff ff       	call   0 <fmtname>
 43c:	83 c4 10             	add    $0x10,%esp
 43f:	83 ec 04             	sub    $0x4,%esp
 442:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 448:	57                   	push   %edi
 449:	56                   	push   %esi
 44a:	53                   	push   %ebx
 44b:	50                   	push   %eax
 44c:	68 a5 0f 00 00       	push   $0xfa5
 451:	6a 01                	push   $0x1
 453:	e8 17 07 00 00       	call   b6f <printf>
 458:	83 c4 20             	add    $0x20,%esp
    #endif
    break;
 45b:	e9 94 01 00 00       	jmp    5f4 <ls+0x2c2>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 460:	83 ec 0c             	sub    $0xc,%esp
 463:	ff 75 08             	pushl  0x8(%ebp)
 466:	e8 98 02 00 00       	call   703 <strlen>
 46b:	83 c4 10             	add    $0x10,%esp
 46e:	83 c0 10             	add    $0x10,%eax
 471:	3d 00 02 00 00       	cmp    $0x200,%eax
 476:	76 17                	jbe    48f <ls+0x15d>
      printf(1, "ls: path too long\n");
 478:	83 ec 08             	sub    $0x8,%esp
 47b:	68 ba 0f 00 00       	push   $0xfba
 480:	6a 01                	push   $0x1
 482:	e8 e8 06 00 00       	call   b6f <printf>
 487:	83 c4 10             	add    $0x10,%esp
      break;
 48a:	e9 65 01 00 00       	jmp    5f4 <ls+0x2c2>
    }
    strcpy(buf, path);
 48f:	83 ec 08             	sub    $0x8,%esp
 492:	ff 75 08             	pushl  0x8(%ebp)
 495:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 49b:	50                   	push   %eax
 49c:	e8 f3 01 00 00       	call   694 <strcpy>
 4a1:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 4a4:	83 ec 0c             	sub    $0xc,%esp
 4a7:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 4ad:	50                   	push   %eax
 4ae:	e8 50 02 00 00       	call   703 <strlen>
 4b3:	83 c4 10             	add    $0x10,%esp
 4b6:	89 c2                	mov    %eax,%edx
 4b8:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 4be:	01 d0                	add    %edx,%eax
 4c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 4c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4c6:	8d 50 01             	lea    0x1(%eax),%edx
 4c9:	89 55 e0             	mov    %edx,-0x20(%ebp)
 4cc:	c6 00 2f             	movb   $0x2f,(%eax)
    
    #ifdef CS333_P5
    printf(1, "%s\t %s\t %s\t %s\t %s\t %s\n", "Mode    ", "Name       ", "UID", "GID", "iNode", "Size");
 4cf:	68 5d 0f 00 00       	push   $0xf5d
 4d4:	68 62 0f 00 00       	push   $0xf62
 4d9:	68 68 0f 00 00       	push   $0xf68
 4de:	68 cd 0f 00 00       	push   $0xfcd
 4e3:	68 d1 0f 00 00       	push   $0xfd1
 4e8:	68 dd 0f 00 00       	push   $0xfdd
 4ed:	68 8d 0f 00 00       	push   $0xf8d
 4f2:	6a 01                	push   $0x1
 4f4:	e8 76 06 00 00       	call   b6f <printf>
 4f9:	83 c4 20             	add    $0x20,%esp
    #endif
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 4fc:	e9 d2 00 00 00       	jmp    5d3 <ls+0x2a1>
      if(de.inum == 0)
 501:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 508:	66 85 c0             	test   %ax,%ax
 50b:	75 05                	jne    512 <ls+0x1e0>
        continue;
 50d:	e9 c1 00 00 00       	jmp    5d3 <ls+0x2a1>
      memmove(p, de.name, DIRSIZ);
 512:	83 ec 04             	sub    $0x4,%esp
 515:	6a 0e                	push   $0xe
 517:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 51d:	83 c0 02             	add    $0x2,%eax
 520:	50                   	push   %eax
 521:	ff 75 e0             	pushl  -0x20(%ebp)
 524:	e8 2a 04 00 00       	call   953 <memmove>
 529:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 52c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 52f:	83 c0 0e             	add    $0xe,%eax
 532:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 535:	83 ec 08             	sub    $0x8,%esp
 538:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 53e:	50                   	push   %eax
 53f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 545:	50                   	push   %eax
 546:	e8 9b 02 00 00       	call   7e6 <stat>
 54b:	83 c4 10             	add    $0x10,%esp
 54e:	85 c0                	test   %eax,%eax
 550:	79 1b                	jns    56d <ls+0x23b>
        printf(1, "ls: cannot stat %s\n", buf);
 552:	83 ec 04             	sub    $0x4,%esp
 555:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 55b:	50                   	push   %eax
 55c:	68 49 0f 00 00       	push   $0xf49
 561:	6a 01                	push   $0x1
 563:	e8 07 06 00 00       	call   b6f <printf>
 568:	83 c4 10             	add    $0x10,%esp
        continue;
 56b:	eb 66                	jmp    5d3 <ls+0x2a1>
      }
      #ifndef CS333_P5
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
      #else
      print_mode(&st);
 56d:	83 ec 0c             	sub    $0xc,%esp
 570:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 576:	50                   	push   %eax
 577:	e8 3c fb ff ff       	call   b8 <print_mode>
 57c:	83 c4 10             	add    $0x10,%esp
      printf(1, " %s\t %d\t %d\t %d\t %d\n", fmtname(buf), st.uid, st.gid, st.ino, st.size);
 57f:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
 585:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 58b:	8b bd bc fd ff ff    	mov    -0x244(%ebp),%edi
 591:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
 598:	0f b7 f0             	movzwl %ax,%esi
 59b:	0f b7 85 c2 fd ff ff 	movzwl -0x23e(%ebp),%eax
 5a2:	0f b7 d8             	movzwl %ax,%ebx
 5a5:	83 ec 0c             	sub    $0xc,%esp
 5a8:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 5ae:	50                   	push   %eax
 5af:	e8 4c fa ff ff       	call   0 <fmtname>
 5b4:	83 c4 10             	add    $0x10,%esp
 5b7:	83 ec 04             	sub    $0x4,%esp
 5ba:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 5c0:	57                   	push   %edi
 5c1:	56                   	push   %esi
 5c2:	53                   	push   %ebx
 5c3:	50                   	push   %eax
 5c4:	68 a5 0f 00 00       	push   $0xfa5
 5c9:	6a 01                	push   $0x1
 5cb:	e8 9f 05 00 00       	call   b6f <printf>
 5d0:	83 c4 20             	add    $0x20,%esp
    *p++ = '/';
    
    #ifdef CS333_P5
    printf(1, "%s\t %s\t %s\t %s\t %s\t %s\n", "Mode    ", "Name       ", "UID", "GID", "iNode", "Size");
    #endif
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 5d3:	83 ec 04             	sub    $0x4,%esp
 5d6:	6a 10                	push   $0x10
 5d8:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 5de:	50                   	push   %eax
 5df:	ff 75 e4             	pushl  -0x1c(%ebp)
 5e2:	e8 c9 03 00 00       	call   9b0 <read>
 5e7:	83 c4 10             	add    $0x10,%esp
 5ea:	83 f8 10             	cmp    $0x10,%eax
 5ed:	0f 84 0e ff ff ff    	je     501 <ls+0x1cf>
      #else
      print_mode(&st);
      printf(1, " %s\t %d\t %d\t %d\t %d\n", fmtname(buf), st.uid, st.gid, st.ino, st.size);
      #endif
    }
    break;
 5f3:	90                   	nop
  }

  close(fd);
 5f4:	83 ec 0c             	sub    $0xc,%esp
 5f7:	ff 75 e4             	pushl  -0x1c(%ebp)
 5fa:	e8 c1 03 00 00       	call   9c0 <close>
 5ff:	83 c4 10             	add    $0x10,%esp
}
 602:	8d 65 f4             	lea    -0xc(%ebp),%esp
 605:	5b                   	pop    %ebx
 606:	5e                   	pop    %esi
 607:	5f                   	pop    %edi
 608:	5d                   	pop    %ebp
 609:	c3                   	ret    

0000060a <main>:

int
main(int argc, char *argv[])
{
 60a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 60e:	83 e4 f0             	and    $0xfffffff0,%esp
 611:	ff 71 fc             	pushl  -0x4(%ecx)
 614:	55                   	push   %ebp
 615:	89 e5                	mov    %esp,%ebp
 617:	53                   	push   %ebx
 618:	51                   	push   %ecx
 619:	83 ec 10             	sub    $0x10,%esp
 61c:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 61e:	83 3b 01             	cmpl   $0x1,(%ebx)
 621:	7f 15                	jg     638 <main+0x2e>
    ls(".");
 623:	83 ec 0c             	sub    $0xc,%esp
 626:	68 e6 0f 00 00       	push   $0xfe6
 62b:	e8 02 fd ff ff       	call   332 <ls>
 630:	83 c4 10             	add    $0x10,%esp
    exit();
 633:	e8 60 03 00 00       	call   998 <exit>
  }
  for(i=1; i<argc; i++)
 638:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 63f:	eb 21                	jmp    662 <main+0x58>
    ls(argv[i]);
 641:	8b 45 f4             	mov    -0xc(%ebp),%eax
 644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 64b:	8b 43 04             	mov    0x4(%ebx),%eax
 64e:	01 d0                	add    %edx,%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	83 ec 0c             	sub    $0xc,%esp
 655:	50                   	push   %eax
 656:	e8 d7 fc ff ff       	call   332 <ls>
 65b:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 65e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 662:	8b 45 f4             	mov    -0xc(%ebp),%eax
 665:	3b 03                	cmp    (%ebx),%eax
 667:	7c d8                	jl     641 <main+0x37>
    ls(argv[i]);
  exit();
 669:	e8 2a 03 00 00       	call   998 <exit>

0000066e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 66e:	55                   	push   %ebp
 66f:	89 e5                	mov    %esp,%ebp
 671:	57                   	push   %edi
 672:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 673:	8b 4d 08             	mov    0x8(%ebp),%ecx
 676:	8b 55 10             	mov    0x10(%ebp),%edx
 679:	8b 45 0c             	mov    0xc(%ebp),%eax
 67c:	89 cb                	mov    %ecx,%ebx
 67e:	89 df                	mov    %ebx,%edi
 680:	89 d1                	mov    %edx,%ecx
 682:	fc                   	cld    
 683:	f3 aa                	rep stos %al,%es:(%edi)
 685:	89 ca                	mov    %ecx,%edx
 687:	89 fb                	mov    %edi,%ebx
 689:	89 5d 08             	mov    %ebx,0x8(%ebp)
 68c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 68f:	90                   	nop
 690:	5b                   	pop    %ebx
 691:	5f                   	pop    %edi
 692:	5d                   	pop    %ebp
 693:	c3                   	ret    

00000694 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 69a:	8b 45 08             	mov    0x8(%ebp),%eax
 69d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 6a0:	90                   	nop
 6a1:	8b 45 08             	mov    0x8(%ebp),%eax
 6a4:	8d 50 01             	lea    0x1(%eax),%edx
 6a7:	89 55 08             	mov    %edx,0x8(%ebp)
 6aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ad:	8d 4a 01             	lea    0x1(%edx),%ecx
 6b0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 6b3:	0f b6 12             	movzbl (%edx),%edx
 6b6:	88 10                	mov    %dl,(%eax)
 6b8:	0f b6 00             	movzbl (%eax),%eax
 6bb:	84 c0                	test   %al,%al
 6bd:	75 e2                	jne    6a1 <strcpy+0xd>
    ;
  return os;
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6c2:	c9                   	leave  
 6c3:	c3                   	ret    

000006c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6c4:	55                   	push   %ebp
 6c5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 6c7:	eb 08                	jmp    6d1 <strcmp+0xd>
    p++, q++;
 6c9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 6cd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 6d1:	8b 45 08             	mov    0x8(%ebp),%eax
 6d4:	0f b6 00             	movzbl (%eax),%eax
 6d7:	84 c0                	test   %al,%al
 6d9:	74 10                	je     6eb <strcmp+0x27>
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	0f b6 10             	movzbl (%eax),%edx
 6e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e4:	0f b6 00             	movzbl (%eax),%eax
 6e7:	38 c2                	cmp    %al,%dl
 6e9:	74 de                	je     6c9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 6eb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ee:	0f b6 00             	movzbl (%eax),%eax
 6f1:	0f b6 d0             	movzbl %al,%edx
 6f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f7:	0f b6 00             	movzbl (%eax),%eax
 6fa:	0f b6 c0             	movzbl %al,%eax
 6fd:	29 c2                	sub    %eax,%edx
 6ff:	89 d0                	mov    %edx,%eax
}
 701:	5d                   	pop    %ebp
 702:	c3                   	ret    

00000703 <strlen>:

uint
strlen(char *s)
{
 703:	55                   	push   %ebp
 704:	89 e5                	mov    %esp,%ebp
 706:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 709:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 710:	eb 04                	jmp    716 <strlen+0x13>
 712:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 716:	8b 55 fc             	mov    -0x4(%ebp),%edx
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	01 d0                	add    %edx,%eax
 71e:	0f b6 00             	movzbl (%eax),%eax
 721:	84 c0                	test   %al,%al
 723:	75 ed                	jne    712 <strlen+0xf>
    ;
  return n;
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 728:	c9                   	leave  
 729:	c3                   	ret    

0000072a <memset>:

void*
memset(void *dst, int c, uint n)
{
 72a:	55                   	push   %ebp
 72b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 72d:	8b 45 10             	mov    0x10(%ebp),%eax
 730:	50                   	push   %eax
 731:	ff 75 0c             	pushl  0xc(%ebp)
 734:	ff 75 08             	pushl  0x8(%ebp)
 737:	e8 32 ff ff ff       	call   66e <stosb>
 73c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 73f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 742:	c9                   	leave  
 743:	c3                   	ret    

00000744 <strchr>:

char*
strchr(const char *s, char c)
{
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	83 ec 04             	sub    $0x4,%esp
 74a:	8b 45 0c             	mov    0xc(%ebp),%eax
 74d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 750:	eb 14                	jmp    766 <strchr+0x22>
    if(*s == c)
 752:	8b 45 08             	mov    0x8(%ebp),%eax
 755:	0f b6 00             	movzbl (%eax),%eax
 758:	3a 45 fc             	cmp    -0x4(%ebp),%al
 75b:	75 05                	jne    762 <strchr+0x1e>
      return (char*)s;
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	eb 13                	jmp    775 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 762:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	0f b6 00             	movzbl (%eax),%eax
 76c:	84 c0                	test   %al,%al
 76e:	75 e2                	jne    752 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 770:	b8 00 00 00 00       	mov    $0x0,%eax
}
 775:	c9                   	leave  
 776:	c3                   	ret    

00000777 <gets>:

char*
gets(char *buf, int max)
{
 777:	55                   	push   %ebp
 778:	89 e5                	mov    %esp,%ebp
 77a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 77d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 784:	eb 42                	jmp    7c8 <gets+0x51>
    cc = read(0, &c, 1);
 786:	83 ec 04             	sub    $0x4,%esp
 789:	6a 01                	push   $0x1
 78b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 78e:	50                   	push   %eax
 78f:	6a 00                	push   $0x0
 791:	e8 1a 02 00 00       	call   9b0 <read>
 796:	83 c4 10             	add    $0x10,%esp
 799:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 79c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a0:	7e 33                	jle    7d5 <gets+0x5e>
      break;
    buf[i++] = c;
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	8d 50 01             	lea    0x1(%eax),%edx
 7a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7ab:	89 c2                	mov    %eax,%edx
 7ad:	8b 45 08             	mov    0x8(%ebp),%eax
 7b0:	01 c2                	add    %eax,%edx
 7b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 7b6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 7b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 7bc:	3c 0a                	cmp    $0xa,%al
 7be:	74 16                	je     7d6 <gets+0x5f>
 7c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 7c4:	3c 0d                	cmp    $0xd,%al
 7c6:	74 0e                	je     7d6 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	83 c0 01             	add    $0x1,%eax
 7ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
 7d1:	7c b3                	jl     786 <gets+0xf>
 7d3:	eb 01                	jmp    7d6 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 7d5:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
 7dc:	01 d0                	add    %edx,%eax
 7de:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 7e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7e4:	c9                   	leave  
 7e5:	c3                   	ret    

000007e6 <stat>:

int
stat(char *n, struct stat *st)
{
 7e6:	55                   	push   %ebp
 7e7:	89 e5                	mov    %esp,%ebp
 7e9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7ec:	83 ec 08             	sub    $0x8,%esp
 7ef:	6a 00                	push   $0x0
 7f1:	ff 75 08             	pushl  0x8(%ebp)
 7f4:	e8 df 01 00 00       	call   9d8 <open>
 7f9:	83 c4 10             	add    $0x10,%esp
 7fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 803:	79 07                	jns    80c <stat+0x26>
    return -1;
 805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80a:	eb 25                	jmp    831 <stat+0x4b>
  r = fstat(fd, st);
 80c:	83 ec 08             	sub    $0x8,%esp
 80f:	ff 75 0c             	pushl  0xc(%ebp)
 812:	ff 75 f4             	pushl  -0xc(%ebp)
 815:	e8 d6 01 00 00       	call   9f0 <fstat>
 81a:	83 c4 10             	add    $0x10,%esp
 81d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 820:	83 ec 0c             	sub    $0xc,%esp
 823:	ff 75 f4             	pushl  -0xc(%ebp)
 826:	e8 95 01 00 00       	call   9c0 <close>
 82b:	83 c4 10             	add    $0x10,%esp
  return r;
 82e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 831:	c9                   	leave  
 832:	c3                   	ret    

00000833 <atoi>:

int
atoi(const char *s)
{
 833:	55                   	push   %ebp
 834:	89 e5                	mov    %esp,%ebp
 836:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 839:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;  // remove leading spaces
 840:	eb 04                	jmp    846 <atoi+0x13>
 842:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 846:	8b 45 08             	mov    0x8(%ebp),%eax
 849:	0f b6 00             	movzbl (%eax),%eax
 84c:	3c 20                	cmp    $0x20,%al
 84e:	74 f2                	je     842 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	0f b6 00             	movzbl (%eax),%eax
 856:	3c 2d                	cmp    $0x2d,%al
 858:	75 07                	jne    861 <atoi+0x2e>
 85a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 85f:	eb 05                	jmp    866 <atoi+0x33>
 861:	b8 01 00 00 00       	mov    $0x1,%eax
 866:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 869:	8b 45 08             	mov    0x8(%ebp),%eax
 86c:	0f b6 00             	movzbl (%eax),%eax
 86f:	3c 2b                	cmp    $0x2b,%al
 871:	74 0a                	je     87d <atoi+0x4a>
 873:	8b 45 08             	mov    0x8(%ebp),%eax
 876:	0f b6 00             	movzbl (%eax),%eax
 879:	3c 2d                	cmp    $0x2d,%al
 87b:	75 2b                	jne    8a8 <atoi+0x75>
    s++;
 87d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 881:	eb 25                	jmp    8a8 <atoi+0x75>
    n = n*10 + *s++ - '0';
 883:	8b 55 fc             	mov    -0x4(%ebp),%edx
 886:	89 d0                	mov    %edx,%eax
 888:	c1 e0 02             	shl    $0x2,%eax
 88b:	01 d0                	add    %edx,%eax
 88d:	01 c0                	add    %eax,%eax
 88f:	89 c1                	mov    %eax,%ecx
 891:	8b 45 08             	mov    0x8(%ebp),%eax
 894:	8d 50 01             	lea    0x1(%eax),%edx
 897:	89 55 08             	mov    %edx,0x8(%ebp)
 89a:	0f b6 00             	movzbl (%eax),%eax
 89d:	0f be c0             	movsbl %al,%eax
 8a0:	01 c8                	add    %ecx,%eax
 8a2:	83 e8 30             	sub    $0x30,%eax
 8a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;  // remove leading spaces
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 8a8:	8b 45 08             	mov    0x8(%ebp),%eax
 8ab:	0f b6 00             	movzbl (%eax),%eax
 8ae:	3c 2f                	cmp    $0x2f,%al
 8b0:	7e 0a                	jle    8bc <atoi+0x89>
 8b2:	8b 45 08             	mov    0x8(%ebp),%eax
 8b5:	0f b6 00             	movzbl (%eax),%eax
 8b8:	3c 39                	cmp    $0x39,%al
 8ba:	7e c7                	jle    883 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 8bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bf:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 8c3:	c9                   	leave  
 8c4:	c3                   	ret    

000008c5 <atoo>:

int
atoo(const char *s)
{
 8c5:	55                   	push   %ebp
 8c6:	89 e5                	mov    %esp,%ebp
 8c8:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 8cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 8d2:	eb 04                	jmp    8d8 <atoo+0x13>
 8d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 8d8:	8b 45 08             	mov    0x8(%ebp),%eax
 8db:	0f b6 00             	movzbl (%eax),%eax
 8de:	3c 20                	cmp    $0x20,%al
 8e0:	74 f2                	je     8d4 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 8e2:	8b 45 08             	mov    0x8(%ebp),%eax
 8e5:	0f b6 00             	movzbl (%eax),%eax
 8e8:	3c 2d                	cmp    $0x2d,%al
 8ea:	75 07                	jne    8f3 <atoo+0x2e>
 8ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8f1:	eb 05                	jmp    8f8 <atoo+0x33>
 8f3:	b8 01 00 00 00       	mov    $0x1,%eax
 8f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 8fb:	8b 45 08             	mov    0x8(%ebp),%eax
 8fe:	0f b6 00             	movzbl (%eax),%eax
 901:	3c 2b                	cmp    $0x2b,%al
 903:	74 0a                	je     90f <atoo+0x4a>
 905:	8b 45 08             	mov    0x8(%ebp),%eax
 908:	0f b6 00             	movzbl (%eax),%eax
 90b:	3c 2d                	cmp    $0x2d,%al
 90d:	75 27                	jne    936 <atoo+0x71>
    s++;
 90f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 913:	eb 21                	jmp    936 <atoo+0x71>
    n = n*8 + *s++ - '0';
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 91f:	8b 45 08             	mov    0x8(%ebp),%eax
 922:	8d 50 01             	lea    0x1(%eax),%edx
 925:	89 55 08             	mov    %edx,0x8(%ebp)
 928:	0f b6 00             	movzbl (%eax),%eax
 92b:	0f be c0             	movsbl %al,%eax
 92e:	01 c8                	add    %ecx,%eax
 930:	83 e8 30             	sub    $0x30,%eax
 933:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 936:	8b 45 08             	mov    0x8(%ebp),%eax
 939:	0f b6 00             	movzbl (%eax),%eax
 93c:	3c 2f                	cmp    $0x2f,%al
 93e:	7e 0a                	jle    94a <atoo+0x85>
 940:	8b 45 08             	mov    0x8(%ebp),%eax
 943:	0f b6 00             	movzbl (%eax),%eax
 946:	3c 37                	cmp    $0x37,%al
 948:	7e cb                	jle    915 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 94a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94d:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 951:	c9                   	leave  
 952:	c3                   	ret    

00000953 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 953:	55                   	push   %ebp
 954:	89 e5                	mov    %esp,%ebp
 956:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 959:	8b 45 08             	mov    0x8(%ebp),%eax
 95c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 95f:	8b 45 0c             	mov    0xc(%ebp),%eax
 962:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 965:	eb 17                	jmp    97e <memmove+0x2b>
    *dst++ = *src++;
 967:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96a:	8d 50 01             	lea    0x1(%eax),%edx
 96d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 970:	8b 55 f8             	mov    -0x8(%ebp),%edx
 973:	8d 4a 01             	lea    0x1(%edx),%ecx
 976:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 979:	0f b6 12             	movzbl (%edx),%edx
 97c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 97e:	8b 45 10             	mov    0x10(%ebp),%eax
 981:	8d 50 ff             	lea    -0x1(%eax),%edx
 984:	89 55 10             	mov    %edx,0x10(%ebp)
 987:	85 c0                	test   %eax,%eax
 989:	7f dc                	jg     967 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 98b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 98e:	c9                   	leave  
 98f:	c3                   	ret    

00000990 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 990:	b8 01 00 00 00       	mov    $0x1,%eax
 995:	cd 40                	int    $0x40
 997:	c3                   	ret    

00000998 <exit>:
SYSCALL(exit)
 998:	b8 02 00 00 00       	mov    $0x2,%eax
 99d:	cd 40                	int    $0x40
 99f:	c3                   	ret    

000009a0 <wait>:
SYSCALL(wait)
 9a0:	b8 03 00 00 00       	mov    $0x3,%eax
 9a5:	cd 40                	int    $0x40
 9a7:	c3                   	ret    

000009a8 <pipe>:
SYSCALL(pipe)
 9a8:	b8 04 00 00 00       	mov    $0x4,%eax
 9ad:	cd 40                	int    $0x40
 9af:	c3                   	ret    

000009b0 <read>:
SYSCALL(read)
 9b0:	b8 05 00 00 00       	mov    $0x5,%eax
 9b5:	cd 40                	int    $0x40
 9b7:	c3                   	ret    

000009b8 <write>:
SYSCALL(write)
 9b8:	b8 10 00 00 00       	mov    $0x10,%eax
 9bd:	cd 40                	int    $0x40
 9bf:	c3                   	ret    

000009c0 <close>:
SYSCALL(close)
 9c0:	b8 15 00 00 00       	mov    $0x15,%eax
 9c5:	cd 40                	int    $0x40
 9c7:	c3                   	ret    

000009c8 <kill>:
SYSCALL(kill)
 9c8:	b8 06 00 00 00       	mov    $0x6,%eax
 9cd:	cd 40                	int    $0x40
 9cf:	c3                   	ret    

000009d0 <exec>:
SYSCALL(exec)
 9d0:	b8 07 00 00 00       	mov    $0x7,%eax
 9d5:	cd 40                	int    $0x40
 9d7:	c3                   	ret    

000009d8 <open>:
SYSCALL(open)
 9d8:	b8 0f 00 00 00       	mov    $0xf,%eax
 9dd:	cd 40                	int    $0x40
 9df:	c3                   	ret    

000009e0 <mknod>:
SYSCALL(mknod)
 9e0:	b8 11 00 00 00       	mov    $0x11,%eax
 9e5:	cd 40                	int    $0x40
 9e7:	c3                   	ret    

000009e8 <unlink>:
SYSCALL(unlink)
 9e8:	b8 12 00 00 00       	mov    $0x12,%eax
 9ed:	cd 40                	int    $0x40
 9ef:	c3                   	ret    

000009f0 <fstat>:
SYSCALL(fstat)
 9f0:	b8 08 00 00 00       	mov    $0x8,%eax
 9f5:	cd 40                	int    $0x40
 9f7:	c3                   	ret    

000009f8 <link>:
SYSCALL(link)
 9f8:	b8 13 00 00 00       	mov    $0x13,%eax
 9fd:	cd 40                	int    $0x40
 9ff:	c3                   	ret    

00000a00 <mkdir>:
SYSCALL(mkdir)
 a00:	b8 14 00 00 00       	mov    $0x14,%eax
 a05:	cd 40                	int    $0x40
 a07:	c3                   	ret    

00000a08 <chdir>:
SYSCALL(chdir)
 a08:	b8 09 00 00 00       	mov    $0x9,%eax
 a0d:	cd 40                	int    $0x40
 a0f:	c3                   	ret    

00000a10 <dup>:
SYSCALL(dup)
 a10:	b8 0a 00 00 00       	mov    $0xa,%eax
 a15:	cd 40                	int    $0x40
 a17:	c3                   	ret    

00000a18 <getpid>:
SYSCALL(getpid)
 a18:	b8 0b 00 00 00       	mov    $0xb,%eax
 a1d:	cd 40                	int    $0x40
 a1f:	c3                   	ret    

00000a20 <sbrk>:
SYSCALL(sbrk)
 a20:	b8 0c 00 00 00       	mov    $0xc,%eax
 a25:	cd 40                	int    $0x40
 a27:	c3                   	ret    

00000a28 <sleep>:
SYSCALL(sleep)
 a28:	b8 0d 00 00 00       	mov    $0xd,%eax
 a2d:	cd 40                	int    $0x40
 a2f:	c3                   	ret    

00000a30 <uptime>:
SYSCALL(uptime)
 a30:	b8 0e 00 00 00       	mov    $0xe,%eax
 a35:	cd 40                	int    $0x40
 a37:	c3                   	ret    

00000a38 <halt>:
SYSCALL(halt)
 a38:	b8 16 00 00 00       	mov    $0x16,%eax
 a3d:	cd 40                	int    $0x40
 a3f:	c3                   	ret    

00000a40 <date>:
SYSCALL(date)        #p1
 a40:	b8 17 00 00 00       	mov    $0x17,%eax
 a45:	cd 40                	int    $0x40
 a47:	c3                   	ret    

00000a48 <getuid>:
SYSCALL(getuid)      #p2
 a48:	b8 18 00 00 00       	mov    $0x18,%eax
 a4d:	cd 40                	int    $0x40
 a4f:	c3                   	ret    

00000a50 <getgid>:
SYSCALL(getgid)      #p2
 a50:	b8 19 00 00 00       	mov    $0x19,%eax
 a55:	cd 40                	int    $0x40
 a57:	c3                   	ret    

00000a58 <getppid>:
SYSCALL(getppid)     #p2
 a58:	b8 1a 00 00 00       	mov    $0x1a,%eax
 a5d:	cd 40                	int    $0x40
 a5f:	c3                   	ret    

00000a60 <setuid>:
SYSCALL(setuid)      #p2
 a60:	b8 1b 00 00 00       	mov    $0x1b,%eax
 a65:	cd 40                	int    $0x40
 a67:	c3                   	ret    

00000a68 <setgid>:
SYSCALL(setgid)      #p2
 a68:	b8 1c 00 00 00       	mov    $0x1c,%eax
 a6d:	cd 40                	int    $0x40
 a6f:	c3                   	ret    

00000a70 <getprocs>:
SYSCALL(getprocs)    #p2
 a70:	b8 1d 00 00 00       	mov    $0x1d,%eax
 a75:	cd 40                	int    $0x40
 a77:	c3                   	ret    

00000a78 <setpriority>:
SYSCALL(setpriority) #p4
 a78:	b8 1e 00 00 00       	mov    $0x1e,%eax
 a7d:	cd 40                	int    $0x40
 a7f:	c3                   	ret    

00000a80 <chmod>:
SYSCALL(chmod)       #p5
 a80:	b8 1f 00 00 00       	mov    $0x1f,%eax
 a85:	cd 40                	int    $0x40
 a87:	c3                   	ret    

00000a88 <chown>:
SYSCALL(chown)       #p5
 a88:	b8 20 00 00 00       	mov    $0x20,%eax
 a8d:	cd 40                	int    $0x40
 a8f:	c3                   	ret    

00000a90 <chgrp>:
SYSCALL(chgrp)       #p5
 a90:	b8 21 00 00 00       	mov    $0x21,%eax
 a95:	cd 40                	int    $0x40
 a97:	c3                   	ret    

00000a98 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a98:	55                   	push   %ebp
 a99:	89 e5                	mov    %esp,%ebp
 a9b:	83 ec 18             	sub    $0x18,%esp
 a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
 aa1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 aa4:	83 ec 04             	sub    $0x4,%esp
 aa7:	6a 01                	push   $0x1
 aa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 aac:	50                   	push   %eax
 aad:	ff 75 08             	pushl  0x8(%ebp)
 ab0:	e8 03 ff ff ff       	call   9b8 <write>
 ab5:	83 c4 10             	add    $0x10,%esp
}
 ab8:	90                   	nop
 ab9:	c9                   	leave  
 aba:	c3                   	ret    

00000abb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 abb:	55                   	push   %ebp
 abc:	89 e5                	mov    %esp,%ebp
 abe:	53                   	push   %ebx
 abf:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 ac2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 ac9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 acd:	74 17                	je     ae6 <printint+0x2b>
 acf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 ad3:	79 11                	jns    ae6 <printint+0x2b>
    neg = 1;
 ad5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 adc:	8b 45 0c             	mov    0xc(%ebp),%eax
 adf:	f7 d8                	neg    %eax
 ae1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 ae4:	eb 06                	jmp    aec <printint+0x31>
  } else {
    x = xx;
 ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
 ae9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 aec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 af3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 af6:	8d 41 01             	lea    0x1(%ecx),%eax
 af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 afc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b02:	ba 00 00 00 00       	mov    $0x0,%edx
 b07:	f7 f3                	div    %ebx
 b09:	89 d0                	mov    %edx,%eax
 b0b:	0f b6 80 d0 12 00 00 	movzbl 0x12d0(%eax),%eax
 b12:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 b16:	8b 5d 10             	mov    0x10(%ebp),%ebx
 b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b1c:	ba 00 00 00 00       	mov    $0x0,%edx
 b21:	f7 f3                	div    %ebx
 b23:	89 45 ec             	mov    %eax,-0x14(%ebp)
 b26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b2a:	75 c7                	jne    af3 <printint+0x38>
  if(neg)
 b2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b30:	74 2d                	je     b5f <printint+0xa4>
    buf[i++] = '-';
 b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b35:	8d 50 01             	lea    0x1(%eax),%edx
 b38:	89 55 f4             	mov    %edx,-0xc(%ebp)
 b3b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 b40:	eb 1d                	jmp    b5f <printint+0xa4>
    putc(fd, buf[i]);
 b42:	8d 55 dc             	lea    -0x24(%ebp),%edx
 b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b48:	01 d0                	add    %edx,%eax
 b4a:	0f b6 00             	movzbl (%eax),%eax
 b4d:	0f be c0             	movsbl %al,%eax
 b50:	83 ec 08             	sub    $0x8,%esp
 b53:	50                   	push   %eax
 b54:	ff 75 08             	pushl  0x8(%ebp)
 b57:	e8 3c ff ff ff       	call   a98 <putc>
 b5c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 b5f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 b63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b67:	79 d9                	jns    b42 <printint+0x87>
    putc(fd, buf[i]);
}
 b69:	90                   	nop
 b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 b6d:	c9                   	leave  
 b6e:	c3                   	ret    

00000b6f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b6f:	55                   	push   %ebp
 b70:	89 e5                	mov    %esp,%ebp
 b72:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b7c:	8d 45 0c             	lea    0xc(%ebp),%eax
 b7f:	83 c0 04             	add    $0x4,%eax
 b82:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b85:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b8c:	e9 59 01 00 00       	jmp    cea <printf+0x17b>
    c = fmt[i] & 0xff;
 b91:	8b 55 0c             	mov    0xc(%ebp),%edx
 b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b97:	01 d0                	add    %edx,%eax
 b99:	0f b6 00             	movzbl (%eax),%eax
 b9c:	0f be c0             	movsbl %al,%eax
 b9f:	25 ff 00 00 00       	and    $0xff,%eax
 ba4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 ba7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 bab:	75 2c                	jne    bd9 <printf+0x6a>
      if(c == '%'){
 bad:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bb1:	75 0c                	jne    bbf <printf+0x50>
        state = '%';
 bb3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 bba:	e9 27 01 00 00       	jmp    ce6 <printf+0x177>
      } else {
        putc(fd, c);
 bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bc2:	0f be c0             	movsbl %al,%eax
 bc5:	83 ec 08             	sub    $0x8,%esp
 bc8:	50                   	push   %eax
 bc9:	ff 75 08             	pushl  0x8(%ebp)
 bcc:	e8 c7 fe ff ff       	call   a98 <putc>
 bd1:	83 c4 10             	add    $0x10,%esp
 bd4:	e9 0d 01 00 00       	jmp    ce6 <printf+0x177>
      }
    } else if(state == '%'){
 bd9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 bdd:	0f 85 03 01 00 00    	jne    ce6 <printf+0x177>
      if(c == 'd'){
 be3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 be7:	75 1e                	jne    c07 <printf+0x98>
        printint(fd, *ap, 10, 1);
 be9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bec:	8b 00                	mov    (%eax),%eax
 bee:	6a 01                	push   $0x1
 bf0:	6a 0a                	push   $0xa
 bf2:	50                   	push   %eax
 bf3:	ff 75 08             	pushl  0x8(%ebp)
 bf6:	e8 c0 fe ff ff       	call   abb <printint>
 bfb:	83 c4 10             	add    $0x10,%esp
        ap++;
 bfe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c02:	e9 d8 00 00 00       	jmp    cdf <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 c07:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 c0b:	74 06                	je     c13 <printf+0xa4>
 c0d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 c11:	75 1e                	jne    c31 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 c13:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c16:	8b 00                	mov    (%eax),%eax
 c18:	6a 00                	push   $0x0
 c1a:	6a 10                	push   $0x10
 c1c:	50                   	push   %eax
 c1d:	ff 75 08             	pushl  0x8(%ebp)
 c20:	e8 96 fe ff ff       	call   abb <printint>
 c25:	83 c4 10             	add    $0x10,%esp
        ap++;
 c28:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c2c:	e9 ae 00 00 00       	jmp    cdf <printf+0x170>
      } else if(c == 's'){
 c31:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 c35:	75 43                	jne    c7a <printf+0x10b>
        s = (char*)*ap;
 c37:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c3a:	8b 00                	mov    (%eax),%eax
 c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 c3f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c47:	75 25                	jne    c6e <printf+0xff>
          s = "(null)";
 c49:	c7 45 f4 e8 0f 00 00 	movl   $0xfe8,-0xc(%ebp)
        while(*s != 0){
 c50:	eb 1c                	jmp    c6e <printf+0xff>
          putc(fd, *s);
 c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c55:	0f b6 00             	movzbl (%eax),%eax
 c58:	0f be c0             	movsbl %al,%eax
 c5b:	83 ec 08             	sub    $0x8,%esp
 c5e:	50                   	push   %eax
 c5f:	ff 75 08             	pushl  0x8(%ebp)
 c62:	e8 31 fe ff ff       	call   a98 <putc>
 c67:	83 c4 10             	add    $0x10,%esp
          s++;
 c6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c71:	0f b6 00             	movzbl (%eax),%eax
 c74:	84 c0                	test   %al,%al
 c76:	75 da                	jne    c52 <printf+0xe3>
 c78:	eb 65                	jmp    cdf <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 c7a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 c7e:	75 1d                	jne    c9d <printf+0x12e>
        putc(fd, *ap);
 c80:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c83:	8b 00                	mov    (%eax),%eax
 c85:	0f be c0             	movsbl %al,%eax
 c88:	83 ec 08             	sub    $0x8,%esp
 c8b:	50                   	push   %eax
 c8c:	ff 75 08             	pushl  0x8(%ebp)
 c8f:	e8 04 fe ff ff       	call   a98 <putc>
 c94:	83 c4 10             	add    $0x10,%esp
        ap++;
 c97:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c9b:	eb 42                	jmp    cdf <printf+0x170>
      } else if(c == '%'){
 c9d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ca1:	75 17                	jne    cba <printf+0x14b>
        putc(fd, c);
 ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ca6:	0f be c0             	movsbl %al,%eax
 ca9:	83 ec 08             	sub    $0x8,%esp
 cac:	50                   	push   %eax
 cad:	ff 75 08             	pushl  0x8(%ebp)
 cb0:	e8 e3 fd ff ff       	call   a98 <putc>
 cb5:	83 c4 10             	add    $0x10,%esp
 cb8:	eb 25                	jmp    cdf <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 cba:	83 ec 08             	sub    $0x8,%esp
 cbd:	6a 25                	push   $0x25
 cbf:	ff 75 08             	pushl  0x8(%ebp)
 cc2:	e8 d1 fd ff ff       	call   a98 <putc>
 cc7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 cca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ccd:	0f be c0             	movsbl %al,%eax
 cd0:	83 ec 08             	sub    $0x8,%esp
 cd3:	50                   	push   %eax
 cd4:	ff 75 08             	pushl  0x8(%ebp)
 cd7:	e8 bc fd ff ff       	call   a98 <putc>
 cdc:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 cdf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 ce6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 cea:	8b 55 0c             	mov    0xc(%ebp),%edx
 ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cf0:	01 d0                	add    %edx,%eax
 cf2:	0f b6 00             	movzbl (%eax),%eax
 cf5:	84 c0                	test   %al,%al
 cf7:	0f 85 94 fe ff ff    	jne    b91 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 cfd:	90                   	nop
 cfe:	c9                   	leave  
 cff:	c3                   	ret    

00000d00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d00:	55                   	push   %ebp
 d01:	89 e5                	mov    %esp,%ebp
 d03:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d06:	8b 45 08             	mov    0x8(%ebp),%eax
 d09:	83 e8 08             	sub    $0x8,%eax
 d0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d0f:	a1 fc 12 00 00       	mov    0x12fc,%eax
 d14:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d17:	eb 24                	jmp    d3d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d19:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d1c:	8b 00                	mov    (%eax),%eax
 d1e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d21:	77 12                	ja     d35 <free+0x35>
 d23:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d26:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d29:	77 24                	ja     d4f <free+0x4f>
 d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d2e:	8b 00                	mov    (%eax),%eax
 d30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d33:	77 1a                	ja     d4f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d38:	8b 00                	mov    (%eax),%eax
 d3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d40:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d43:	76 d4                	jbe    d19 <free+0x19>
 d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d48:	8b 00                	mov    (%eax),%eax
 d4a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d4d:	76 ca                	jbe    d19 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 d4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d52:	8b 40 04             	mov    0x4(%eax),%eax
 d55:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d5f:	01 c2                	add    %eax,%edx
 d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d64:	8b 00                	mov    (%eax),%eax
 d66:	39 c2                	cmp    %eax,%edx
 d68:	75 24                	jne    d8e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 d6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d6d:	8b 50 04             	mov    0x4(%eax),%edx
 d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d73:	8b 00                	mov    (%eax),%eax
 d75:	8b 40 04             	mov    0x4(%eax),%eax
 d78:	01 c2                	add    %eax,%edx
 d7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d7d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 d80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d83:	8b 00                	mov    (%eax),%eax
 d85:	8b 10                	mov    (%eax),%edx
 d87:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d8a:	89 10                	mov    %edx,(%eax)
 d8c:	eb 0a                	jmp    d98 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 d8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d91:	8b 10                	mov    (%eax),%edx
 d93:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d96:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d98:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d9b:	8b 40 04             	mov    0x4(%eax),%eax
 d9e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 da5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 da8:	01 d0                	add    %edx,%eax
 daa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 dad:	75 20                	jne    dcf <free+0xcf>
    p->s.size += bp->s.size;
 daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 db2:	8b 50 04             	mov    0x4(%eax),%edx
 db5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 db8:	8b 40 04             	mov    0x4(%eax),%eax
 dbb:	01 c2                	add    %eax,%edx
 dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dc0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dc6:	8b 10                	mov    (%eax),%edx
 dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dcb:	89 10                	mov    %edx,(%eax)
 dcd:	eb 08                	jmp    dd7 <free+0xd7>
  } else
    p->s.ptr = bp;
 dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dd2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 dd5:	89 10                	mov    %edx,(%eax)
  freep = p;
 dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dda:	a3 fc 12 00 00       	mov    %eax,0x12fc
}
 ddf:	90                   	nop
 de0:	c9                   	leave  
 de1:	c3                   	ret    

00000de2 <morecore>:

static Header*
morecore(uint nu)
{
 de2:	55                   	push   %ebp
 de3:	89 e5                	mov    %esp,%ebp
 de5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 de8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 def:	77 07                	ja     df8 <morecore+0x16>
    nu = 4096;
 df1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 df8:	8b 45 08             	mov    0x8(%ebp),%eax
 dfb:	c1 e0 03             	shl    $0x3,%eax
 dfe:	83 ec 0c             	sub    $0xc,%esp
 e01:	50                   	push   %eax
 e02:	e8 19 fc ff ff       	call   a20 <sbrk>
 e07:	83 c4 10             	add    $0x10,%esp
 e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 e0d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 e11:	75 07                	jne    e1a <morecore+0x38>
    return 0;
 e13:	b8 00 00 00 00       	mov    $0x0,%eax
 e18:	eb 26                	jmp    e40 <morecore+0x5e>
  hp = (Header*)p;
 e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e23:	8b 55 08             	mov    0x8(%ebp),%edx
 e26:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e2c:	83 c0 08             	add    $0x8,%eax
 e2f:	83 ec 0c             	sub    $0xc,%esp
 e32:	50                   	push   %eax
 e33:	e8 c8 fe ff ff       	call   d00 <free>
 e38:	83 c4 10             	add    $0x10,%esp
  return freep;
 e3b:	a1 fc 12 00 00       	mov    0x12fc,%eax
}
 e40:	c9                   	leave  
 e41:	c3                   	ret    

00000e42 <malloc>:

void*
malloc(uint nbytes)
{
 e42:	55                   	push   %ebp
 e43:	89 e5                	mov    %esp,%ebp
 e45:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e48:	8b 45 08             	mov    0x8(%ebp),%eax
 e4b:	83 c0 07             	add    $0x7,%eax
 e4e:	c1 e8 03             	shr    $0x3,%eax
 e51:	83 c0 01             	add    $0x1,%eax
 e54:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 e57:	a1 fc 12 00 00       	mov    0x12fc,%eax
 e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e63:	75 23                	jne    e88 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 e65:	c7 45 f0 f4 12 00 00 	movl   $0x12f4,-0x10(%ebp)
 e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e6f:	a3 fc 12 00 00       	mov    %eax,0x12fc
 e74:	a1 fc 12 00 00       	mov    0x12fc,%eax
 e79:	a3 f4 12 00 00       	mov    %eax,0x12f4
    base.s.size = 0;
 e7e:	c7 05 f8 12 00 00 00 	movl   $0x0,0x12f8
 e85:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e8b:	8b 00                	mov    (%eax),%eax
 e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e93:	8b 40 04             	mov    0x4(%eax),%eax
 e96:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e99:	72 4d                	jb     ee8 <malloc+0xa6>
      if(p->s.size == nunits)
 e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e9e:	8b 40 04             	mov    0x4(%eax),%eax
 ea1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ea4:	75 0c                	jne    eb2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ea9:	8b 10                	mov    (%eax),%edx
 eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 eae:	89 10                	mov    %edx,(%eax)
 eb0:	eb 26                	jmp    ed8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eb5:	8b 40 04             	mov    0x4(%eax),%eax
 eb8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ebb:	89 c2                	mov    %eax,%edx
 ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ec0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ec6:	8b 40 04             	mov    0x4(%eax),%eax
 ec9:	c1 e0 03             	shl    $0x3,%eax
 ecc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ed2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ed5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 edb:	a3 fc 12 00 00       	mov    %eax,0x12fc
      return (void*)(p + 1);
 ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ee3:	83 c0 08             	add    $0x8,%eax
 ee6:	eb 3b                	jmp    f23 <malloc+0xe1>
    }
    if(p == freep)
 ee8:	a1 fc 12 00 00       	mov    0x12fc,%eax
 eed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ef0:	75 1e                	jne    f10 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 ef2:	83 ec 0c             	sub    $0xc,%esp
 ef5:	ff 75 ec             	pushl  -0x14(%ebp)
 ef8:	e8 e5 fe ff ff       	call   de2 <morecore>
 efd:	83 c4 10             	add    $0x10,%esp
 f00:	89 45 f4             	mov    %eax,-0xc(%ebp)
 f03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 f07:	75 07                	jne    f10 <malloc+0xce>
        return 0;
 f09:	b8 00 00 00 00       	mov    $0x0,%eax
 f0e:	eb 13                	jmp    f23 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
 f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f19:	8b 00                	mov    (%eax),%eax
 f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 f1e:	e9 6d ff ff ff       	jmp    e90 <malloc+0x4e>
}
 f23:	c9                   	leave  
 f24:	c3                   	ret    
