
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b6 38 10 80       	mov    $0x801038b6,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 a8 8d 10 80       	push   $0x80108da8
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 db 56 00 00       	call   80105727 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 15 11 80       	mov    $0x80111584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 d6 10 80       	push   $0x8010d680
801000c1:	e8 83 56 00 00       	call   80105749 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 15 11 80       	mov    0x80111594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 d6 10 80       	push   $0x8010d680
8010010c:	e8 9f 56 00 00       	call   801057b0 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 27 4f 00 00       	call   80105053 <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 15 11 80       	mov    0x80111590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 d6 10 80       	push   $0x8010d680
80100188:	e8 23 56 00 00       	call   801057b0 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 af 8d 10 80       	push   $0x80108daf
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 4d 27 00 00       	call   80102934 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 c0 8d 10 80       	push   $0x80108dc0
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 0c 27 00 00       	call   80102934 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 c7 8d 10 80       	push   $0x80108dc7
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 ef 54 00 00       	call   80105749 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 15 11 80       	mov    0x80111594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 7c 4e 00 00       	call   8010513a <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 e2 54 00 00       	call   801057b0 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 c5 10 80       	push   $0x8010c5e0
801003e2:	e8 62 53 00 00       	call   80105749 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 ce 8d 10 80       	push   $0x80108dce
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec d7 8d 10 80 	movl   $0x80108dd7,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 c5 10 80       	push   $0x8010c5e0
8010055b:	e8 50 52 00 00       	call   801057b0 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 de 8d 10 80       	push   $0x80108dde
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 ed 8d 10 80       	push   $0x80108ded
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 3b 52 00 00       	call   80105802 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 ef 8d 10 80       	push   $0x80108def
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 f3 8d 10 80       	push   $0x80108df3
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 6f 53 00 00       	call   80105a6b <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 86 52 00 00       	call   801059ac <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 73 6c 00 00       	call   8010742e <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 66 6c 00 00       	call   8010742e <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 59 6c 00 00       	call   8010742e <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 49 6c 00 00       	call   8010742e <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int f = 0;
80100806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//  int r = 0;
//  int s = 0;
//  int z = 0;

  acquire(&cons.lock);
8010080d:	83 ec 0c             	sub    $0xc,%esp
80100810:	68 e0 c5 10 80       	push   $0x8010c5e0
80100815:	e8 2f 4f 00 00       	call   80105749 <acquire>
8010081a:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
8010081d:	e9 59 01 00 00       	jmp    8010097b <consoleintr+0x182>
    switch(c){
80100822:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100825:	83 f8 10             	cmp    $0x10,%eax
80100828:	74 27                	je     80100851 <consoleintr+0x58>
8010082a:	83 f8 10             	cmp    $0x10,%eax
8010082d:	7f 13                	jg     80100842 <consoleintr+0x49>
8010082f:	83 f8 06             	cmp    $0x6,%eax
80100832:	0f 84 a5 00 00 00    	je     801008dd <consoleintr+0xe4>
80100838:	83 f8 08             	cmp    $0x8,%eax
8010083b:	74 6b                	je     801008a8 <consoleintr+0xaf>
8010083d:	e9 a7 00 00 00       	jmp    801008e9 <consoleintr+0xf0>
80100842:	83 f8 15             	cmp    $0x15,%eax
80100845:	74 33                	je     8010087a <consoleintr+0x81>
80100847:	83 f8 7f             	cmp    $0x7f,%eax
8010084a:	74 5c                	je     801008a8 <consoleintr+0xaf>
8010084c:	e9 98 00 00 00       	jmp    801008e9 <consoleintr+0xf0>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100851:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100858:	e9 1e 01 00 00       	jmp    8010097b <consoleintr+0x182>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010085d:	a1 28 18 11 80       	mov    0x80111828,%eax
80100862:	83 e8 01             	sub    $0x1,%eax
80100865:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
8010086a:	83 ec 0c             	sub    $0xc,%esp
8010086d:	68 00 01 00 00       	push   $0x100
80100872:	e8 1b ff ff ff       	call   80100792 <consputc>
80100877:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010087a:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100880:	a1 24 18 11 80       	mov    0x80111824,%eax
80100885:	39 c2                	cmp    %eax,%edx
80100887:	0f 84 ee 00 00 00    	je     8010097b <consoleintr+0x182>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010088d:	a1 28 18 11 80       	mov    0x80111828,%eax
80100892:	83 e8 01             	sub    $0x1,%eax
80100895:	83 e0 7f             	and    $0x7f,%eax
80100898:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010089f:	3c 0a                	cmp    $0xa,%al
801008a1:	75 ba                	jne    8010085d <consoleintr+0x64>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008a3:	e9 d3 00 00 00       	jmp    8010097b <consoleintr+0x182>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008a8:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008ae:	a1 24 18 11 80       	mov    0x80111824,%eax
801008b3:	39 c2                	cmp    %eax,%edx
801008b5:	0f 84 c0 00 00 00    	je     8010097b <consoleintr+0x182>
        input.e--;
801008bb:	a1 28 18 11 80       	mov    0x80111828,%eax
801008c0:	83 e8 01             	sub    $0x1,%eax
801008c3:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
801008c8:	83 ec 0c             	sub    $0xc,%esp
801008cb:	68 00 01 00 00       	push   $0x100
801008d0:	e8 bd fe ff ff       	call   80100792 <consputc>
801008d5:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008d8:	e9 9e 00 00 00       	jmp    8010097b <consoleintr+0x182>
    case C('F'):
      f = 1;
801008dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
801008e4:	e9 92 00 00 00       	jmp    8010097b <consoleintr+0x182>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801008ed:	0f 84 87 00 00 00    	je     8010097a <consoleintr+0x181>
801008f3:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008f9:	a1 20 18 11 80       	mov    0x80111820,%eax
801008fe:	29 c2                	sub    %eax,%edx
80100900:	89 d0                	mov    %edx,%eax
80100902:	83 f8 7f             	cmp    $0x7f,%eax
80100905:	77 73                	ja     8010097a <consoleintr+0x181>
        c = (c == '\r') ? '\n' : c;
80100907:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
8010090b:	74 05                	je     80100912 <consoleintr+0x119>
8010090d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100910:	eb 05                	jmp    80100917 <consoleintr+0x11e>
80100912:	b8 0a 00 00 00       	mov    $0xa,%eax
80100917:	89 45 ec             	mov    %eax,-0x14(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010091a:	a1 28 18 11 80       	mov    0x80111828,%eax
8010091f:	8d 50 01             	lea    0x1(%eax),%edx
80100922:	89 15 28 18 11 80    	mov    %edx,0x80111828
80100928:	83 e0 7f             	and    $0x7f,%eax
8010092b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010092e:	88 90 a0 17 11 80    	mov    %dl,-0x7feee860(%eax)
        consputc(c);
80100934:	83 ec 0c             	sub    $0xc,%esp
80100937:	ff 75 ec             	pushl  -0x14(%ebp)
8010093a:	e8 53 fe ff ff       	call   80100792 <consputc>
8010093f:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100942:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
80100946:	74 18                	je     80100960 <consoleintr+0x167>
80100948:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
8010094c:	74 12                	je     80100960 <consoleintr+0x167>
8010094e:	a1 28 18 11 80       	mov    0x80111828,%eax
80100953:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100959:	83 ea 80             	sub    $0xffffff80,%edx
8010095c:	39 d0                	cmp    %edx,%eax
8010095e:	75 1a                	jne    8010097a <consoleintr+0x181>
          input.w = input.e;
80100960:	a1 28 18 11 80       	mov    0x80111828,%eax
80100965:	a3 24 18 11 80       	mov    %eax,0x80111824
          wakeup(&input.r);
8010096a:	83 ec 0c             	sub    $0xc,%esp
8010096d:	68 20 18 11 80       	push   $0x80111820
80100972:	e8 c3 47 00 00       	call   8010513a <wakeup>
80100977:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010097a:	90                   	nop
//  int r = 0;
//  int s = 0;
//  int z = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
8010097b:	8b 45 08             	mov    0x8(%ebp),%eax
8010097e:	ff d0                	call   *%eax
80100980:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100983:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100987:	0f 89 95 fe ff ff    	jns    80100822 <consoleintr+0x29>
        }
      }
      break;
    }
  }
  release(&cons.lock);
8010098d:	83 ec 0c             	sub    $0xc,%esp
80100990:	68 e0 c5 10 80       	push   $0x8010c5e0
80100995:	e8 16 4e 00 00       	call   801057b0 <release>
8010099a:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010099d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009a1:	74 05                	je     801009a8 <consoleintr+0x1af>
    procdump();  // now call procdump() wo. cons.lock held
801009a3:	e8 52 48 00 00       	call   801051fa <procdump>
  }
  if(f == 1) {
801009a8:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
801009ac:	75 05                	jne    801009b3 <consoleintr+0x1ba>
    free_length();
801009ae:	e8 d4 4a 00 00       	call   80105487 <free_length>
  }
}
801009b3:	90                   	nop
801009b4:	c9                   	leave  
801009b5:	c3                   	ret    

801009b6 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009b6:	55                   	push   %ebp
801009b7:	89 e5                	mov    %esp,%ebp
801009b9:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009bc:	83 ec 0c             	sub    $0xc,%esp
801009bf:	ff 75 08             	pushl  0x8(%ebp)
801009c2:	e8 28 11 00 00       	call   80101aef <iunlock>
801009c7:	83 c4 10             	add    $0x10,%esp
  target = n;
801009ca:	8b 45 10             	mov    0x10(%ebp),%eax
801009cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009d0:	83 ec 0c             	sub    $0xc,%esp
801009d3:	68 e0 c5 10 80       	push   $0x8010c5e0
801009d8:	e8 6c 4d 00 00       	call   80105749 <acquire>
801009dd:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009e0:	e9 ac 00 00 00       	jmp    80100a91 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009eb:	8b 40 24             	mov    0x24(%eax),%eax
801009ee:	85 c0                	test   %eax,%eax
801009f0:	74 28                	je     80100a1a <consoleread+0x64>
        release(&cons.lock);
801009f2:	83 ec 0c             	sub    $0xc,%esp
801009f5:	68 e0 c5 10 80       	push   $0x8010c5e0
801009fa:	e8 b1 4d 00 00       	call   801057b0 <release>
801009ff:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a02:	83 ec 0c             	sub    $0xc,%esp
80100a05:	ff 75 08             	pushl  0x8(%ebp)
80100a08:	e8 84 0f 00 00       	call   80101991 <ilock>
80100a0d:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a15:	e9 ab 00 00 00       	jmp    80100ac5 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a1a:	83 ec 08             	sub    $0x8,%esp
80100a1d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a22:	68 20 18 11 80       	push   $0x80111820
80100a27:	e8 27 46 00 00       	call   80105053 <sleep>
80100a2c:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a2f:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100a35:	a1 24 18 11 80       	mov    0x80111824,%eax
80100a3a:	39 c2                	cmp    %eax,%edx
80100a3c:	74 a7                	je     801009e5 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a3e:	a1 20 18 11 80       	mov    0x80111820,%eax
80100a43:	8d 50 01             	lea    0x1(%eax),%edx
80100a46:	89 15 20 18 11 80    	mov    %edx,0x80111820
80100a4c:	83 e0 7f             	and    $0x7f,%eax
80100a4f:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
80100a56:	0f be c0             	movsbl %al,%eax
80100a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a5c:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a60:	75 17                	jne    80100a79 <consoleread+0xc3>
      if(n < target){
80100a62:	8b 45 10             	mov    0x10(%ebp),%eax
80100a65:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a68:	73 2f                	jae    80100a99 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a6a:	a1 20 18 11 80       	mov    0x80111820,%eax
80100a6f:	83 e8 01             	sub    $0x1,%eax
80100a72:	a3 20 18 11 80       	mov    %eax,0x80111820
      }
      break;
80100a77:	eb 20                	jmp    80100a99 <consoleread+0xe3>
    }
    *dst++ = c;
80100a79:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a7c:	8d 50 01             	lea    0x1(%eax),%edx
80100a7f:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a82:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a85:	88 10                	mov    %dl,(%eax)
    --n;
80100a87:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a8b:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a8f:	74 0b                	je     80100a9c <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a95:	7f 98                	jg     80100a2f <consoleread+0x79>
80100a97:	eb 04                	jmp    80100a9d <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a99:	90                   	nop
80100a9a:	eb 01                	jmp    80100a9d <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a9c:	90                   	nop
  }
  release(&cons.lock);
80100a9d:	83 ec 0c             	sub    $0xc,%esp
80100aa0:	68 e0 c5 10 80       	push   $0x8010c5e0
80100aa5:	e8 06 4d 00 00       	call   801057b0 <release>
80100aaa:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100aad:	83 ec 0c             	sub    $0xc,%esp
80100ab0:	ff 75 08             	pushl  0x8(%ebp)
80100ab3:	e8 d9 0e 00 00       	call   80101991 <ilock>
80100ab8:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100abb:	8b 45 10             	mov    0x10(%ebp),%eax
80100abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ac1:	29 c2                	sub    %eax,%edx
80100ac3:	89 d0                	mov    %edx,%eax
}
80100ac5:	c9                   	leave  
80100ac6:	c3                   	ret    

80100ac7 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100ac7:	55                   	push   %ebp
80100ac8:	89 e5                	mov    %esp,%ebp
80100aca:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100acd:	83 ec 0c             	sub    $0xc,%esp
80100ad0:	ff 75 08             	pushl  0x8(%ebp)
80100ad3:	e8 17 10 00 00       	call   80101aef <iunlock>
80100ad8:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100adb:	83 ec 0c             	sub    $0xc,%esp
80100ade:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ae3:	e8 61 4c 00 00       	call   80105749 <acquire>
80100ae8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100aeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100af2:	eb 21                	jmp    80100b15 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100af4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100af7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100afa:	01 d0                	add    %edx,%eax
80100afc:	0f b6 00             	movzbl (%eax),%eax
80100aff:	0f be c0             	movsbl %al,%eax
80100b02:	0f b6 c0             	movzbl %al,%eax
80100b05:	83 ec 0c             	sub    $0xc,%esp
80100b08:	50                   	push   %eax
80100b09:	e8 84 fc ff ff       	call   80100792 <consputc>
80100b0e:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b11:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b18:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b1b:	7c d7                	jl     80100af4 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b1d:	83 ec 0c             	sub    $0xc,%esp
80100b20:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b25:	e8 86 4c 00 00       	call   801057b0 <release>
80100b2a:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b2d:	83 ec 0c             	sub    $0xc,%esp
80100b30:	ff 75 08             	pushl  0x8(%ebp)
80100b33:	e8 59 0e 00 00       	call   80101991 <ilock>
80100b38:	83 c4 10             	add    $0x10,%esp

  return n;
80100b3b:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b3e:	c9                   	leave  
80100b3f:	c3                   	ret    

80100b40 <consoleinit>:

void
consoleinit(void)
{
80100b40:	55                   	push   %ebp
80100b41:	89 e5                	mov    %esp,%ebp
80100b43:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b46:	83 ec 08             	sub    $0x8,%esp
80100b49:	68 06 8e 10 80       	push   $0x80108e06
80100b4e:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b53:	e8 cf 4b 00 00       	call   80105727 <initlock>
80100b58:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b5b:	c7 05 ec 21 11 80 c7 	movl   $0x80100ac7,0x801121ec
80100b62:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b65:	c7 05 e8 21 11 80 b6 	movl   $0x801009b6,0x801121e8
80100b6c:	09 10 80 
  cons.locking = 1;
80100b6f:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b76:	00 00 00 

  picenable(IRQ_KBD);
80100b79:	83 ec 0c             	sub    $0xc,%esp
80100b7c:	6a 01                	push   $0x1
80100b7e:	e8 cf 33 00 00       	call   80103f52 <picenable>
80100b83:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b86:	83 ec 08             	sub    $0x8,%esp
80100b89:	6a 00                	push   $0x0
80100b8b:	6a 01                	push   $0x1
80100b8d:	e8 6f 1f 00 00       	call   80102b01 <ioapicenable>
80100b92:	83 c4 10             	add    $0x10,%esp
}
80100b95:	90                   	nop
80100b96:	c9                   	leave  
80100b97:	c3                   	ret    

80100b98 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b98:	55                   	push   %ebp
80100b99:	89 e5                	mov    %esp,%ebp
80100b9b:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100ba1:	e8 ce 29 00 00       	call   80103574 <begin_op>
  if((ip = namei(path)) == 0){
80100ba6:	83 ec 0c             	sub    $0xc,%esp
80100ba9:	ff 75 08             	pushl  0x8(%ebp)
80100bac:	e8 9e 19 00 00       	call   8010254f <namei>
80100bb1:	83 c4 10             	add    $0x10,%esp
80100bb4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bb7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bbb:	75 0f                	jne    80100bcc <exec+0x34>
    end_op();
80100bbd:	e8 3e 2a 00 00       	call   80103600 <end_op>
    return -1;
80100bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc7:	e9 ce 03 00 00       	jmp    80100f9a <exec+0x402>
  }
  ilock(ip);
80100bcc:	83 ec 0c             	sub    $0xc,%esp
80100bcf:	ff 75 d8             	pushl  -0x28(%ebp)
80100bd2:	e8 ba 0d 00 00       	call   80101991 <ilock>
80100bd7:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bda:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100be1:	6a 34                	push   $0x34
80100be3:	6a 00                	push   $0x0
80100be5:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100beb:	50                   	push   %eax
80100bec:	ff 75 d8             	pushl  -0x28(%ebp)
80100bef:	e8 0b 13 00 00       	call   80101eff <readi>
80100bf4:	83 c4 10             	add    $0x10,%esp
80100bf7:	83 f8 33             	cmp    $0x33,%eax
80100bfa:	0f 86 49 03 00 00    	jbe    80100f49 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c00:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c06:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c0b:	0f 85 3b 03 00 00    	jne    80100f4c <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c11:	e8 6d 79 00 00       	call   80108583 <setupkvm>
80100c16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c19:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c1d:	0f 84 2c 03 00 00    	je     80100f4f <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c23:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c31:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c37:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c3a:	e9 ab 00 00 00       	jmp    80100cea <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c42:	6a 20                	push   $0x20
80100c44:	50                   	push   %eax
80100c45:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c4b:	50                   	push   %eax
80100c4c:	ff 75 d8             	pushl  -0x28(%ebp)
80100c4f:	e8 ab 12 00 00       	call   80101eff <readi>
80100c54:	83 c4 10             	add    $0x10,%esp
80100c57:	83 f8 20             	cmp    $0x20,%eax
80100c5a:	0f 85 f2 02 00 00    	jne    80100f52 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c60:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c66:	83 f8 01             	cmp    $0x1,%eax
80100c69:	75 71                	jne    80100cdc <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c6b:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c71:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c77:	39 c2                	cmp    %eax,%edx
80100c79:	0f 82 d6 02 00 00    	jb     80100f55 <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c7f:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c85:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c8b:	01 d0                	add    %edx,%eax
80100c8d:	83 ec 04             	sub    $0x4,%esp
80100c90:	50                   	push   %eax
80100c91:	ff 75 e0             	pushl  -0x20(%ebp)
80100c94:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c97:	e8 8e 7c 00 00       	call   8010892a <allocuvm>
80100c9c:	83 c4 10             	add    $0x10,%esp
80100c9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ca2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ca6:	0f 84 ac 02 00 00    	je     80100f58 <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cac:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cb2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cb8:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100cbe:	83 ec 0c             	sub    $0xc,%esp
80100cc1:	52                   	push   %edx
80100cc2:	50                   	push   %eax
80100cc3:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc6:	51                   	push   %ecx
80100cc7:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cca:	e8 84 7b 00 00       	call   80108853 <loaduvm>
80100ccf:	83 c4 20             	add    $0x20,%esp
80100cd2:	85 c0                	test   %eax,%eax
80100cd4:	0f 88 81 02 00 00    	js     80100f5b <exec+0x3c3>
80100cda:	eb 01                	jmp    80100cdd <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100cdc:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cdd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100ce1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ce4:	83 c0 20             	add    $0x20,%eax
80100ce7:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cea:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cf1:	0f b7 c0             	movzwl %ax,%eax
80100cf4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cf7:	0f 8f 42 ff ff ff    	jg     80100c3f <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cfd:	83 ec 0c             	sub    $0xc,%esp
80100d00:	ff 75 d8             	pushl  -0x28(%ebp)
80100d03:	e8 49 0f 00 00       	call   80101c51 <iunlockput>
80100d08:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d0b:	e8 f0 28 00 00       	call   80103600 <end_op>
  ip = 0;
80100d10:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d17:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d1a:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d24:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2a:	05 00 20 00 00       	add    $0x2000,%eax
80100d2f:	83 ec 04             	sub    $0x4,%esp
80100d32:	50                   	push   %eax
80100d33:	ff 75 e0             	pushl  -0x20(%ebp)
80100d36:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d39:	e8 ec 7b 00 00       	call   8010892a <allocuvm>
80100d3e:	83 c4 10             	add    $0x10,%esp
80100d41:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d44:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d48:	0f 84 10 02 00 00    	je     80100f5e <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d51:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d56:	83 ec 08             	sub    $0x8,%esp
80100d59:	50                   	push   %eax
80100d5a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d5d:	e8 ee 7d 00 00       	call   80108b50 <clearpteu>
80100d62:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d65:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d68:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d6b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d72:	e9 96 00 00 00       	jmp    80100e0d <exec+0x275>
    if(argc >= MAXARG)
80100d77:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d7b:	0f 87 e0 01 00 00    	ja     80100f61 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d84:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d8e:	01 d0                	add    %edx,%eax
80100d90:	8b 00                	mov    (%eax),%eax
80100d92:	83 ec 0c             	sub    $0xc,%esp
80100d95:	50                   	push   %eax
80100d96:	e8 5e 4e 00 00       	call   80105bf9 <strlen>
80100d9b:	83 c4 10             	add    $0x10,%esp
80100d9e:	89 c2                	mov    %eax,%edx
80100da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100da3:	29 d0                	sub    %edx,%eax
80100da5:	83 e8 01             	sub    $0x1,%eax
80100da8:	83 e0 fc             	and    $0xfffffffc,%eax
80100dab:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100db8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dbb:	01 d0                	add    %edx,%eax
80100dbd:	8b 00                	mov    (%eax),%eax
80100dbf:	83 ec 0c             	sub    $0xc,%esp
80100dc2:	50                   	push   %eax
80100dc3:	e8 31 4e 00 00       	call   80105bf9 <strlen>
80100dc8:	83 c4 10             	add    $0x10,%esp
80100dcb:	83 c0 01             	add    $0x1,%eax
80100dce:	89 c1                	mov    %eax,%ecx
80100dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dda:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ddd:	01 d0                	add    %edx,%eax
80100ddf:	8b 00                	mov    (%eax),%eax
80100de1:	51                   	push   %ecx
80100de2:	50                   	push   %eax
80100de3:	ff 75 dc             	pushl  -0x24(%ebp)
80100de6:	ff 75 d4             	pushl  -0x2c(%ebp)
80100de9:	e8 19 7f 00 00       	call   80108d07 <copyout>
80100dee:	83 c4 10             	add    $0x10,%esp
80100df1:	85 c0                	test   %eax,%eax
80100df3:	0f 88 6b 01 00 00    	js     80100f64 <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100df9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfc:	8d 50 03             	lea    0x3(%eax),%edx
80100dff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e02:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e09:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e17:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e1a:	01 d0                	add    %edx,%eax
80100e1c:	8b 00                	mov    (%eax),%eax
80100e1e:	85 c0                	test   %eax,%eax
80100e20:	0f 85 51 ff ff ff    	jne    80100d77 <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e29:	83 c0 03             	add    $0x3,%eax
80100e2c:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e33:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e37:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e3e:	ff ff ff 
  ustack[1] = argc;
80100e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e44:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4d:	83 c0 01             	add    $0x1,%eax
80100e50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e5a:	29 d0                	sub    %edx,%eax
80100e5c:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e65:	83 c0 04             	add    $0x4,%eax
80100e68:	c1 e0 02             	shl    $0x2,%eax
80100e6b:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e71:	83 c0 04             	add    $0x4,%eax
80100e74:	c1 e0 02             	shl    $0x2,%eax
80100e77:	50                   	push   %eax
80100e78:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e7e:	50                   	push   %eax
80100e7f:	ff 75 dc             	pushl  -0x24(%ebp)
80100e82:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e85:	e8 7d 7e 00 00       	call   80108d07 <copyout>
80100e8a:	83 c4 10             	add    $0x10,%esp
80100e8d:	85 c0                	test   %eax,%eax
80100e8f:	0f 88 d2 00 00 00    	js     80100f67 <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e95:	8b 45 08             	mov    0x8(%ebp),%eax
80100e98:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ea1:	eb 17                	jmp    80100eba <exec+0x322>
    if(*s == '/')
80100ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea6:	0f b6 00             	movzbl (%eax),%eax
80100ea9:	3c 2f                	cmp    $0x2f,%al
80100eab:	75 09                	jne    80100eb6 <exec+0x31e>
      last = s+1;
80100ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb0:	83 c0 01             	add    $0x1,%eax
80100eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100eb6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ebd:	0f b6 00             	movzbl (%eax),%eax
80100ec0:	84 c0                	test   %al,%al
80100ec2:	75 df                	jne    80100ea3 <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100ec4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eca:	83 c0 6c             	add    $0x6c,%eax
80100ecd:	83 ec 04             	sub    $0x4,%esp
80100ed0:	6a 10                	push   $0x10
80100ed2:	ff 75 f0             	pushl  -0x10(%ebp)
80100ed5:	50                   	push   %eax
80100ed6:	e8 d4 4c 00 00       	call   80105baf <safestrcpy>
80100edb:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ede:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee4:	8b 40 04             	mov    0x4(%eax),%eax
80100ee7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100eea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ef3:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ef6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100efc:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100eff:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f07:	8b 40 18             	mov    0x18(%eax),%eax
80100f0a:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f10:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f19:	8b 40 18             	mov    0x18(%eax),%eax
80100f1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f1f:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	50                   	push   %eax
80100f2c:	e8 39 77 00 00       	call   8010866a <switchuvm>
80100f31:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f34:	83 ec 0c             	sub    $0xc,%esp
80100f37:	ff 75 d0             	pushl  -0x30(%ebp)
80100f3a:	e8 71 7b 00 00       	call   80108ab0 <freevm>
80100f3f:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f42:	b8 00 00 00 00       	mov    $0x0,%eax
80100f47:	eb 51                	jmp    80100f9a <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f49:	90                   	nop
80100f4a:	eb 1c                	jmp    80100f68 <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f4c:	90                   	nop
80100f4d:	eb 19                	jmp    80100f68 <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f4f:	90                   	nop
80100f50:	eb 16                	jmp    80100f68 <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f52:	90                   	nop
80100f53:	eb 13                	jmp    80100f68 <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f55:	90                   	nop
80100f56:	eb 10                	jmp    80100f68 <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f58:	90                   	nop
80100f59:	eb 0d                	jmp    80100f68 <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f5b:	90                   	nop
80100f5c:	eb 0a                	jmp    80100f68 <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100f5e:	90                   	nop
80100f5f:	eb 07                	jmp    80100f68 <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f61:	90                   	nop
80100f62:	eb 04                	jmp    80100f68 <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f64:	90                   	nop
80100f65:	eb 01                	jmp    80100f68 <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f67:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f68:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f6c:	74 0e                	je     80100f7c <exec+0x3e4>
    freevm(pgdir);
80100f6e:	83 ec 0c             	sub    $0xc,%esp
80100f71:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f74:	e8 37 7b 00 00       	call   80108ab0 <freevm>
80100f79:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f7c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f80:	74 13                	je     80100f95 <exec+0x3fd>
    iunlockput(ip);
80100f82:	83 ec 0c             	sub    $0xc,%esp
80100f85:	ff 75 d8             	pushl  -0x28(%ebp)
80100f88:	e8 c4 0c 00 00       	call   80101c51 <iunlockput>
80100f8d:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f90:	e8 6b 26 00 00       	call   80103600 <end_op>
  }
  return -1;
80100f95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f9a:	c9                   	leave  
80100f9b:	c3                   	ret    

80100f9c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f9c:	55                   	push   %ebp
80100f9d:	89 e5                	mov    %esp,%ebp
80100f9f:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fa2:	83 ec 08             	sub    $0x8,%esp
80100fa5:	68 0e 8e 10 80       	push   $0x80108e0e
80100faa:	68 40 18 11 80       	push   $0x80111840
80100faf:	e8 73 47 00 00       	call   80105727 <initlock>
80100fb4:	83 c4 10             	add    $0x10,%esp
}
80100fb7:	90                   	nop
80100fb8:	c9                   	leave  
80100fb9:	c3                   	ret    

80100fba <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fba:	55                   	push   %ebp
80100fbb:	89 e5                	mov    %esp,%ebp
80100fbd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fc0:	83 ec 0c             	sub    $0xc,%esp
80100fc3:	68 40 18 11 80       	push   $0x80111840
80100fc8:	e8 7c 47 00 00       	call   80105749 <acquire>
80100fcd:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fd0:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
80100fd7:	eb 2d                	jmp    80101006 <filealloc+0x4c>
    if(f->ref == 0){
80100fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fdc:	8b 40 04             	mov    0x4(%eax),%eax
80100fdf:	85 c0                	test   %eax,%eax
80100fe1:	75 1f                	jne    80101002 <filealloc+0x48>
      f->ref = 1;
80100fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fe6:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fed:	83 ec 0c             	sub    $0xc,%esp
80100ff0:	68 40 18 11 80       	push   $0x80111840
80100ff5:	e8 b6 47 00 00       	call   801057b0 <release>
80100ffa:	83 c4 10             	add    $0x10,%esp
      return f;
80100ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101000:	eb 23                	jmp    80101025 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101002:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101006:	b8 d4 21 11 80       	mov    $0x801121d4,%eax
8010100b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010100e:	72 c9                	jb     80100fd9 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101010:	83 ec 0c             	sub    $0xc,%esp
80101013:	68 40 18 11 80       	push   $0x80111840
80101018:	e8 93 47 00 00       	call   801057b0 <release>
8010101d:	83 c4 10             	add    $0x10,%esp
  return 0;
80101020:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101025:	c9                   	leave  
80101026:	c3                   	ret    

80101027 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101027:	55                   	push   %ebp
80101028:	89 e5                	mov    %esp,%ebp
8010102a:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
8010102d:	83 ec 0c             	sub    $0xc,%esp
80101030:	68 40 18 11 80       	push   $0x80111840
80101035:	e8 0f 47 00 00       	call   80105749 <acquire>
8010103a:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010103d:	8b 45 08             	mov    0x8(%ebp),%eax
80101040:	8b 40 04             	mov    0x4(%eax),%eax
80101043:	85 c0                	test   %eax,%eax
80101045:	7f 0d                	jg     80101054 <filedup+0x2d>
    panic("filedup");
80101047:	83 ec 0c             	sub    $0xc,%esp
8010104a:	68 15 8e 10 80       	push   $0x80108e15
8010104f:	e8 12 f5 ff ff       	call   80100566 <panic>
  f->ref++;
80101054:	8b 45 08             	mov    0x8(%ebp),%eax
80101057:	8b 40 04             	mov    0x4(%eax),%eax
8010105a:	8d 50 01             	lea    0x1(%eax),%edx
8010105d:	8b 45 08             	mov    0x8(%ebp),%eax
80101060:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101063:	83 ec 0c             	sub    $0xc,%esp
80101066:	68 40 18 11 80       	push   $0x80111840
8010106b:	e8 40 47 00 00       	call   801057b0 <release>
80101070:	83 c4 10             	add    $0x10,%esp
  return f;
80101073:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101076:	c9                   	leave  
80101077:	c3                   	ret    

80101078 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101078:	55                   	push   %ebp
80101079:	89 e5                	mov    %esp,%ebp
8010107b:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010107e:	83 ec 0c             	sub    $0xc,%esp
80101081:	68 40 18 11 80       	push   $0x80111840
80101086:	e8 be 46 00 00       	call   80105749 <acquire>
8010108b:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010108e:	8b 45 08             	mov    0x8(%ebp),%eax
80101091:	8b 40 04             	mov    0x4(%eax),%eax
80101094:	85 c0                	test   %eax,%eax
80101096:	7f 0d                	jg     801010a5 <fileclose+0x2d>
    panic("fileclose");
80101098:	83 ec 0c             	sub    $0xc,%esp
8010109b:	68 1d 8e 10 80       	push   $0x80108e1d
801010a0:	e8 c1 f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
801010a5:	8b 45 08             	mov    0x8(%ebp),%eax
801010a8:	8b 40 04             	mov    0x4(%eax),%eax
801010ab:	8d 50 ff             	lea    -0x1(%eax),%edx
801010ae:	8b 45 08             	mov    0x8(%ebp),%eax
801010b1:	89 50 04             	mov    %edx,0x4(%eax)
801010b4:	8b 45 08             	mov    0x8(%ebp),%eax
801010b7:	8b 40 04             	mov    0x4(%eax),%eax
801010ba:	85 c0                	test   %eax,%eax
801010bc:	7e 15                	jle    801010d3 <fileclose+0x5b>
    release(&ftable.lock);
801010be:	83 ec 0c             	sub    $0xc,%esp
801010c1:	68 40 18 11 80       	push   $0x80111840
801010c6:	e8 e5 46 00 00       	call   801057b0 <release>
801010cb:	83 c4 10             	add    $0x10,%esp
801010ce:	e9 8b 00 00 00       	jmp    8010115e <fileclose+0xe6>
    return;
  }
  ff = *f;
801010d3:	8b 45 08             	mov    0x8(%ebp),%eax
801010d6:	8b 10                	mov    (%eax),%edx
801010d8:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010db:	8b 50 04             	mov    0x4(%eax),%edx
801010de:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010e1:	8b 50 08             	mov    0x8(%eax),%edx
801010e4:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010e7:	8b 50 0c             	mov    0xc(%eax),%edx
801010ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010ed:	8b 50 10             	mov    0x10(%eax),%edx
801010f0:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010f3:	8b 40 14             	mov    0x14(%eax),%eax
801010f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010f9:	8b 45 08             	mov    0x8(%ebp),%eax
801010fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101103:	8b 45 08             	mov    0x8(%ebp),%eax
80101106:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010110c:	83 ec 0c             	sub    $0xc,%esp
8010110f:	68 40 18 11 80       	push   $0x80111840
80101114:	e8 97 46 00 00       	call   801057b0 <release>
80101119:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
8010111c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010111f:	83 f8 01             	cmp    $0x1,%eax
80101122:	75 19                	jne    8010113d <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101124:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101128:	0f be d0             	movsbl %al,%edx
8010112b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010112e:	83 ec 08             	sub    $0x8,%esp
80101131:	52                   	push   %edx
80101132:	50                   	push   %eax
80101133:	e8 83 30 00 00       	call   801041bb <pipeclose>
80101138:	83 c4 10             	add    $0x10,%esp
8010113b:	eb 21                	jmp    8010115e <fileclose+0xe6>
  else if(ff.type == FD_INODE){
8010113d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101140:	83 f8 02             	cmp    $0x2,%eax
80101143:	75 19                	jne    8010115e <fileclose+0xe6>
    begin_op();
80101145:	e8 2a 24 00 00       	call   80103574 <begin_op>
    iput(ff.ip);
8010114a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010114d:	83 ec 0c             	sub    $0xc,%esp
80101150:	50                   	push   %eax
80101151:	e8 0b 0a 00 00       	call   80101b61 <iput>
80101156:	83 c4 10             	add    $0x10,%esp
    end_op();
80101159:	e8 a2 24 00 00       	call   80103600 <end_op>
  }
}
8010115e:	c9                   	leave  
8010115f:	c3                   	ret    

80101160 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101166:	8b 45 08             	mov    0x8(%ebp),%eax
80101169:	8b 00                	mov    (%eax),%eax
8010116b:	83 f8 02             	cmp    $0x2,%eax
8010116e:	75 40                	jne    801011b0 <filestat+0x50>
    ilock(f->ip);
80101170:	8b 45 08             	mov    0x8(%ebp),%eax
80101173:	8b 40 10             	mov    0x10(%eax),%eax
80101176:	83 ec 0c             	sub    $0xc,%esp
80101179:	50                   	push   %eax
8010117a:	e8 12 08 00 00       	call   80101991 <ilock>
8010117f:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101182:	8b 45 08             	mov    0x8(%ebp),%eax
80101185:	8b 40 10             	mov    0x10(%eax),%eax
80101188:	83 ec 08             	sub    $0x8,%esp
8010118b:	ff 75 0c             	pushl  0xc(%ebp)
8010118e:	50                   	push   %eax
8010118f:	e8 25 0d 00 00       	call   80101eb9 <stati>
80101194:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101197:	8b 45 08             	mov    0x8(%ebp),%eax
8010119a:	8b 40 10             	mov    0x10(%eax),%eax
8010119d:	83 ec 0c             	sub    $0xc,%esp
801011a0:	50                   	push   %eax
801011a1:	e8 49 09 00 00       	call   80101aef <iunlock>
801011a6:	83 c4 10             	add    $0x10,%esp
    return 0;
801011a9:	b8 00 00 00 00       	mov    $0x0,%eax
801011ae:	eb 05                	jmp    801011b5 <filestat+0x55>
  }
  return -1;
801011b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011b5:	c9                   	leave  
801011b6:	c3                   	ret    

801011b7 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011b7:	55                   	push   %ebp
801011b8:	89 e5                	mov    %esp,%ebp
801011ba:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011bd:	8b 45 08             	mov    0x8(%ebp),%eax
801011c0:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011c4:	84 c0                	test   %al,%al
801011c6:	75 0a                	jne    801011d2 <fileread+0x1b>
    return -1;
801011c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011cd:	e9 9b 00 00 00       	jmp    8010126d <fileread+0xb6>
  if(f->type == FD_PIPE)
801011d2:	8b 45 08             	mov    0x8(%ebp),%eax
801011d5:	8b 00                	mov    (%eax),%eax
801011d7:	83 f8 01             	cmp    $0x1,%eax
801011da:	75 1a                	jne    801011f6 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011dc:	8b 45 08             	mov    0x8(%ebp),%eax
801011df:	8b 40 0c             	mov    0xc(%eax),%eax
801011e2:	83 ec 04             	sub    $0x4,%esp
801011e5:	ff 75 10             	pushl  0x10(%ebp)
801011e8:	ff 75 0c             	pushl  0xc(%ebp)
801011eb:	50                   	push   %eax
801011ec:	e8 72 31 00 00       	call   80104363 <piperead>
801011f1:	83 c4 10             	add    $0x10,%esp
801011f4:	eb 77                	jmp    8010126d <fileread+0xb6>
  if(f->type == FD_INODE){
801011f6:	8b 45 08             	mov    0x8(%ebp),%eax
801011f9:	8b 00                	mov    (%eax),%eax
801011fb:	83 f8 02             	cmp    $0x2,%eax
801011fe:	75 60                	jne    80101260 <fileread+0xa9>
    ilock(f->ip);
80101200:	8b 45 08             	mov    0x8(%ebp),%eax
80101203:	8b 40 10             	mov    0x10(%eax),%eax
80101206:	83 ec 0c             	sub    $0xc,%esp
80101209:	50                   	push   %eax
8010120a:	e8 82 07 00 00       	call   80101991 <ilock>
8010120f:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101212:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101215:	8b 45 08             	mov    0x8(%ebp),%eax
80101218:	8b 50 14             	mov    0x14(%eax),%edx
8010121b:	8b 45 08             	mov    0x8(%ebp),%eax
8010121e:	8b 40 10             	mov    0x10(%eax),%eax
80101221:	51                   	push   %ecx
80101222:	52                   	push   %edx
80101223:	ff 75 0c             	pushl  0xc(%ebp)
80101226:	50                   	push   %eax
80101227:	e8 d3 0c 00 00       	call   80101eff <readi>
8010122c:	83 c4 10             	add    $0x10,%esp
8010122f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101232:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101236:	7e 11                	jle    80101249 <fileread+0x92>
      f->off += r;
80101238:	8b 45 08             	mov    0x8(%ebp),%eax
8010123b:	8b 50 14             	mov    0x14(%eax),%edx
8010123e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101241:	01 c2                	add    %eax,%edx
80101243:	8b 45 08             	mov    0x8(%ebp),%eax
80101246:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 40 10             	mov    0x10(%eax),%eax
8010124f:	83 ec 0c             	sub    $0xc,%esp
80101252:	50                   	push   %eax
80101253:	e8 97 08 00 00       	call   80101aef <iunlock>
80101258:	83 c4 10             	add    $0x10,%esp
    return r;
8010125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010125e:	eb 0d                	jmp    8010126d <fileread+0xb6>
  }
  panic("fileread");
80101260:	83 ec 0c             	sub    $0xc,%esp
80101263:	68 27 8e 10 80       	push   $0x80108e27
80101268:	e8 f9 f2 ff ff       	call   80100566 <panic>
}
8010126d:	c9                   	leave  
8010126e:	c3                   	ret    

8010126f <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010126f:	55                   	push   %ebp
80101270:	89 e5                	mov    %esp,%ebp
80101272:	53                   	push   %ebx
80101273:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101276:	8b 45 08             	mov    0x8(%ebp),%eax
80101279:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010127d:	84 c0                	test   %al,%al
8010127f:	75 0a                	jne    8010128b <filewrite+0x1c>
    return -1;
80101281:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101286:	e9 1b 01 00 00       	jmp    801013a6 <filewrite+0x137>
  if(f->type == FD_PIPE)
8010128b:	8b 45 08             	mov    0x8(%ebp),%eax
8010128e:	8b 00                	mov    (%eax),%eax
80101290:	83 f8 01             	cmp    $0x1,%eax
80101293:	75 1d                	jne    801012b2 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101295:	8b 45 08             	mov    0x8(%ebp),%eax
80101298:	8b 40 0c             	mov    0xc(%eax),%eax
8010129b:	83 ec 04             	sub    $0x4,%esp
8010129e:	ff 75 10             	pushl  0x10(%ebp)
801012a1:	ff 75 0c             	pushl  0xc(%ebp)
801012a4:	50                   	push   %eax
801012a5:	e8 bb 2f 00 00       	call   80104265 <pipewrite>
801012aa:	83 c4 10             	add    $0x10,%esp
801012ad:	e9 f4 00 00 00       	jmp    801013a6 <filewrite+0x137>
  if(f->type == FD_INODE){
801012b2:	8b 45 08             	mov    0x8(%ebp),%eax
801012b5:	8b 00                	mov    (%eax),%eax
801012b7:	83 f8 02             	cmp    $0x2,%eax
801012ba:	0f 85 d9 00 00 00    	jne    80101399 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801012c0:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012ce:	e9 a3 00 00 00       	jmp    80101376 <filewrite+0x107>
      int n1 = n - i;
801012d3:	8b 45 10             	mov    0x10(%ebp),%eax
801012d6:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012e2:	7e 06                	jle    801012ea <filewrite+0x7b>
        n1 = max;
801012e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012e7:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012ea:	e8 85 22 00 00       	call   80103574 <begin_op>
      ilock(f->ip);
801012ef:	8b 45 08             	mov    0x8(%ebp),%eax
801012f2:	8b 40 10             	mov    0x10(%eax),%eax
801012f5:	83 ec 0c             	sub    $0xc,%esp
801012f8:	50                   	push   %eax
801012f9:	e8 93 06 00 00       	call   80101991 <ilock>
801012fe:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101301:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101304:	8b 45 08             	mov    0x8(%ebp),%eax
80101307:	8b 50 14             	mov    0x14(%eax),%edx
8010130a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010130d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101310:	01 c3                	add    %eax,%ebx
80101312:	8b 45 08             	mov    0x8(%ebp),%eax
80101315:	8b 40 10             	mov    0x10(%eax),%eax
80101318:	51                   	push   %ecx
80101319:	52                   	push   %edx
8010131a:	53                   	push   %ebx
8010131b:	50                   	push   %eax
8010131c:	e8 35 0d 00 00       	call   80102056 <writei>
80101321:	83 c4 10             	add    $0x10,%esp
80101324:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101327:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010132b:	7e 11                	jle    8010133e <filewrite+0xcf>
        f->off += r;
8010132d:	8b 45 08             	mov    0x8(%ebp),%eax
80101330:	8b 50 14             	mov    0x14(%eax),%edx
80101333:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101336:	01 c2                	add    %eax,%edx
80101338:	8b 45 08             	mov    0x8(%ebp),%eax
8010133b:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010133e:	8b 45 08             	mov    0x8(%ebp),%eax
80101341:	8b 40 10             	mov    0x10(%eax),%eax
80101344:	83 ec 0c             	sub    $0xc,%esp
80101347:	50                   	push   %eax
80101348:	e8 a2 07 00 00       	call   80101aef <iunlock>
8010134d:	83 c4 10             	add    $0x10,%esp
      end_op();
80101350:	e8 ab 22 00 00       	call   80103600 <end_op>

      if(r < 0)
80101355:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101359:	78 29                	js     80101384 <filewrite+0x115>
        break;
      if(r != n1)
8010135b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010135e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101361:	74 0d                	je     80101370 <filewrite+0x101>
        panic("short filewrite");
80101363:	83 ec 0c             	sub    $0xc,%esp
80101366:	68 30 8e 10 80       	push   $0x80108e30
8010136b:	e8 f6 f1 ff ff       	call   80100566 <panic>
      i += r;
80101370:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101373:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101379:	3b 45 10             	cmp    0x10(%ebp),%eax
8010137c:	0f 8c 51 ff ff ff    	jl     801012d3 <filewrite+0x64>
80101382:	eb 01                	jmp    80101385 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
80101384:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101388:	3b 45 10             	cmp    0x10(%ebp),%eax
8010138b:	75 05                	jne    80101392 <filewrite+0x123>
8010138d:	8b 45 10             	mov    0x10(%ebp),%eax
80101390:	eb 14                	jmp    801013a6 <filewrite+0x137>
80101392:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101397:	eb 0d                	jmp    801013a6 <filewrite+0x137>
  }
  panic("filewrite");
80101399:	83 ec 0c             	sub    $0xc,%esp
8010139c:	68 40 8e 10 80       	push   $0x80108e40
801013a1:	e8 c0 f1 ff ff       	call   80100566 <panic>
}
801013a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013a9:	c9                   	leave  
801013aa:	c3                   	ret    

801013ab <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013ab:	55                   	push   %ebp
801013ac:	89 e5                	mov    %esp,%ebp
801013ae:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801013b1:	8b 45 08             	mov    0x8(%ebp),%eax
801013b4:	83 ec 08             	sub    $0x8,%esp
801013b7:	6a 01                	push   $0x1
801013b9:	50                   	push   %eax
801013ba:	e8 f7 ed ff ff       	call   801001b6 <bread>
801013bf:	83 c4 10             	add    $0x10,%esp
801013c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c8:	83 c0 18             	add    $0x18,%eax
801013cb:	83 ec 04             	sub    $0x4,%esp
801013ce:	6a 1c                	push   $0x1c
801013d0:	50                   	push   %eax
801013d1:	ff 75 0c             	pushl  0xc(%ebp)
801013d4:	e8 92 46 00 00       	call   80105a6b <memmove>
801013d9:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013dc:	83 ec 0c             	sub    $0xc,%esp
801013df:	ff 75 f4             	pushl  -0xc(%ebp)
801013e2:	e8 47 ee ff ff       	call   8010022e <brelse>
801013e7:	83 c4 10             	add    $0x10,%esp
}
801013ea:	90                   	nop
801013eb:	c9                   	leave  
801013ec:	c3                   	ret    

801013ed <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013ed:	55                   	push   %ebp
801013ee:	89 e5                	mov    %esp,%ebp
801013f0:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801013f6:	8b 45 08             	mov    0x8(%ebp),%eax
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	52                   	push   %edx
801013fd:	50                   	push   %eax
801013fe:	e8 b3 ed ff ff       	call   801001b6 <bread>
80101403:	83 c4 10             	add    $0x10,%esp
80101406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010140c:	83 c0 18             	add    $0x18,%eax
8010140f:	83 ec 04             	sub    $0x4,%esp
80101412:	68 00 02 00 00       	push   $0x200
80101417:	6a 00                	push   $0x0
80101419:	50                   	push   %eax
8010141a:	e8 8d 45 00 00       	call   801059ac <memset>
8010141f:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101422:	83 ec 0c             	sub    $0xc,%esp
80101425:	ff 75 f4             	pushl  -0xc(%ebp)
80101428:	e8 7f 23 00 00       	call   801037ac <log_write>
8010142d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101430:	83 ec 0c             	sub    $0xc,%esp
80101433:	ff 75 f4             	pushl  -0xc(%ebp)
80101436:	e8 f3 ed ff ff       	call   8010022e <brelse>
8010143b:	83 c4 10             	add    $0x10,%esp
}
8010143e:	90                   	nop
8010143f:	c9                   	leave  
80101440:	c3                   	ret    

80101441 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101441:	55                   	push   %ebp
80101442:	89 e5                	mov    %esp,%ebp
80101444:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101447:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010144e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101455:	e9 13 01 00 00       	jmp    8010156d <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
8010145a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010145d:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101463:	85 c0                	test   %eax,%eax
80101465:	0f 48 c2             	cmovs  %edx,%eax
80101468:	c1 f8 0c             	sar    $0xc,%eax
8010146b:	89 c2                	mov    %eax,%edx
8010146d:	a1 58 22 11 80       	mov    0x80112258,%eax
80101472:	01 d0                	add    %edx,%eax
80101474:	83 ec 08             	sub    $0x8,%esp
80101477:	50                   	push   %eax
80101478:	ff 75 08             	pushl  0x8(%ebp)
8010147b:	e8 36 ed ff ff       	call   801001b6 <bread>
80101480:	83 c4 10             	add    $0x10,%esp
80101483:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101486:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010148d:	e9 a6 00 00 00       	jmp    80101538 <balloc+0xf7>
      m = 1 << (bi % 8);
80101492:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101495:	99                   	cltd   
80101496:	c1 ea 1d             	shr    $0x1d,%edx
80101499:	01 d0                	add    %edx,%eax
8010149b:	83 e0 07             	and    $0x7,%eax
8010149e:	29 d0                	sub    %edx,%eax
801014a0:	ba 01 00 00 00       	mov    $0x1,%edx
801014a5:	89 c1                	mov    %eax,%ecx
801014a7:	d3 e2                	shl    %cl,%edx
801014a9:	89 d0                	mov    %edx,%eax
801014ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b1:	8d 50 07             	lea    0x7(%eax),%edx
801014b4:	85 c0                	test   %eax,%eax
801014b6:	0f 48 c2             	cmovs  %edx,%eax
801014b9:	c1 f8 03             	sar    $0x3,%eax
801014bc:	89 c2                	mov    %eax,%edx
801014be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014c1:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801014c6:	0f b6 c0             	movzbl %al,%eax
801014c9:	23 45 e8             	and    -0x18(%ebp),%eax
801014cc:	85 c0                	test   %eax,%eax
801014ce:	75 64                	jne    80101534 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801014d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d3:	8d 50 07             	lea    0x7(%eax),%edx
801014d6:	85 c0                	test   %eax,%eax
801014d8:	0f 48 c2             	cmovs  %edx,%eax
801014db:	c1 f8 03             	sar    $0x3,%eax
801014de:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014e1:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014e6:	89 d1                	mov    %edx,%ecx
801014e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014eb:	09 ca                	or     %ecx,%edx
801014ed:	89 d1                	mov    %edx,%ecx
801014ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014f2:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014f6:	83 ec 0c             	sub    $0xc,%esp
801014f9:	ff 75 ec             	pushl  -0x14(%ebp)
801014fc:	e8 ab 22 00 00       	call   801037ac <log_write>
80101501:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	ff 75 ec             	pushl  -0x14(%ebp)
8010150a:	e8 1f ed ff ff       	call   8010022e <brelse>
8010150f:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101512:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101515:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101518:	01 c2                	add    %eax,%edx
8010151a:	8b 45 08             	mov    0x8(%ebp),%eax
8010151d:	83 ec 08             	sub    $0x8,%esp
80101520:	52                   	push   %edx
80101521:	50                   	push   %eax
80101522:	e8 c6 fe ff ff       	call   801013ed <bzero>
80101527:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010152a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101530:	01 d0                	add    %edx,%eax
80101532:	eb 57                	jmp    8010158b <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101534:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101538:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010153f:	7f 17                	jg     80101558 <balloc+0x117>
80101541:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101544:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101547:	01 d0                	add    %edx,%eax
80101549:	89 c2                	mov    %eax,%edx
8010154b:	a1 40 22 11 80       	mov    0x80112240,%eax
80101550:	39 c2                	cmp    %eax,%edx
80101552:	0f 82 3a ff ff ff    	jb     80101492 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101558:	83 ec 0c             	sub    $0xc,%esp
8010155b:	ff 75 ec             	pushl  -0x14(%ebp)
8010155e:	e8 cb ec ff ff       	call   8010022e <brelse>
80101563:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101566:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010156d:	8b 15 40 22 11 80    	mov    0x80112240,%edx
80101573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101576:	39 c2                	cmp    %eax,%edx
80101578:	0f 87 dc fe ff ff    	ja     8010145a <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010157e:	83 ec 0c             	sub    $0xc,%esp
80101581:	68 4c 8e 10 80       	push   $0x80108e4c
80101586:	e8 db ef ff ff       	call   80100566 <panic>
}
8010158b:	c9                   	leave  
8010158c:	c3                   	ret    

8010158d <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010158d:	55                   	push   %ebp
8010158e:	89 e5                	mov    %esp,%ebp
80101590:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101593:	83 ec 08             	sub    $0x8,%esp
80101596:	68 40 22 11 80       	push   $0x80112240
8010159b:	ff 75 08             	pushl  0x8(%ebp)
8010159e:	e8 08 fe ff ff       	call   801013ab <readsb>
801015a3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a9:	c1 e8 0c             	shr    $0xc,%eax
801015ac:	89 c2                	mov    %eax,%edx
801015ae:	a1 58 22 11 80       	mov    0x80112258,%eax
801015b3:	01 c2                	add    %eax,%edx
801015b5:	8b 45 08             	mov    0x8(%ebp),%eax
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	52                   	push   %edx
801015bc:	50                   	push   %eax
801015bd:	e8 f4 eb ff ff       	call   801001b6 <bread>
801015c2:	83 c4 10             	add    $0x10,%esp
801015c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801015cb:	25 ff 0f 00 00       	and    $0xfff,%eax
801015d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d6:	99                   	cltd   
801015d7:	c1 ea 1d             	shr    $0x1d,%edx
801015da:	01 d0                	add    %edx,%eax
801015dc:	83 e0 07             	and    $0x7,%eax
801015df:	29 d0                	sub    %edx,%eax
801015e1:	ba 01 00 00 00       	mov    $0x1,%edx
801015e6:	89 c1                	mov    %eax,%ecx
801015e8:	d3 e2                	shl    %cl,%edx
801015ea:	89 d0                	mov    %edx,%eax
801015ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f2:	8d 50 07             	lea    0x7(%eax),%edx
801015f5:	85 c0                	test   %eax,%eax
801015f7:	0f 48 c2             	cmovs  %edx,%eax
801015fa:	c1 f8 03             	sar    $0x3,%eax
801015fd:	89 c2                	mov    %eax,%edx
801015ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101602:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101607:	0f b6 c0             	movzbl %al,%eax
8010160a:	23 45 ec             	and    -0x14(%ebp),%eax
8010160d:	85 c0                	test   %eax,%eax
8010160f:	75 0d                	jne    8010161e <bfree+0x91>
    panic("freeing free block");
80101611:	83 ec 0c             	sub    $0xc,%esp
80101614:	68 62 8e 10 80       	push   $0x80108e62
80101619:	e8 48 ef ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
8010161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101621:	8d 50 07             	lea    0x7(%eax),%edx
80101624:	85 c0                	test   %eax,%eax
80101626:	0f 48 c2             	cmovs  %edx,%eax
80101629:	c1 f8 03             	sar    $0x3,%eax
8010162c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010162f:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101634:	89 d1                	mov    %edx,%ecx
80101636:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101639:	f7 d2                	not    %edx
8010163b:	21 ca                	and    %ecx,%edx
8010163d:	89 d1                	mov    %edx,%ecx
8010163f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101642:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101646:	83 ec 0c             	sub    $0xc,%esp
80101649:	ff 75 f4             	pushl  -0xc(%ebp)
8010164c:	e8 5b 21 00 00       	call   801037ac <log_write>
80101651:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101654:	83 ec 0c             	sub    $0xc,%esp
80101657:	ff 75 f4             	pushl  -0xc(%ebp)
8010165a:	e8 cf eb ff ff       	call   8010022e <brelse>
8010165f:	83 c4 10             	add    $0x10,%esp
}
80101662:	90                   	nop
80101663:	c9                   	leave  
80101664:	c3                   	ret    

80101665 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101665:	55                   	push   %ebp
80101666:	89 e5                	mov    %esp,%ebp
80101668:	57                   	push   %edi
80101669:	56                   	push   %esi
8010166a:	53                   	push   %ebx
8010166b:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
8010166e:	83 ec 08             	sub    $0x8,%esp
80101671:	68 75 8e 10 80       	push   $0x80108e75
80101676:	68 60 22 11 80       	push   $0x80112260
8010167b:	e8 a7 40 00 00       	call   80105727 <initlock>
80101680:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101683:	83 ec 08             	sub    $0x8,%esp
80101686:	68 40 22 11 80       	push   $0x80112240
8010168b:	ff 75 08             	pushl  0x8(%ebp)
8010168e:	e8 18 fd ff ff       	call   801013ab <readsb>
80101693:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101696:	a1 58 22 11 80       	mov    0x80112258,%eax
8010169b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010169e:	8b 3d 54 22 11 80    	mov    0x80112254,%edi
801016a4:	8b 35 50 22 11 80    	mov    0x80112250,%esi
801016aa:	8b 1d 4c 22 11 80    	mov    0x8011224c,%ebx
801016b0:	8b 0d 48 22 11 80    	mov    0x80112248,%ecx
801016b6:	8b 15 44 22 11 80    	mov    0x80112244,%edx
801016bc:	a1 40 22 11 80       	mov    0x80112240,%eax
801016c1:	ff 75 e4             	pushl  -0x1c(%ebp)
801016c4:	57                   	push   %edi
801016c5:	56                   	push   %esi
801016c6:	53                   	push   %ebx
801016c7:	51                   	push   %ecx
801016c8:	52                   	push   %edx
801016c9:	50                   	push   %eax
801016ca:	68 7c 8e 10 80       	push   $0x80108e7c
801016cf:	e8 f2 ec ff ff       	call   801003c6 <cprintf>
801016d4:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801016d7:	90                   	nop
801016d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016db:	5b                   	pop    %ebx
801016dc:	5e                   	pop    %esi
801016dd:	5f                   	pop    %edi
801016de:	5d                   	pop    %ebp
801016df:	c3                   	ret    

801016e0 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	83 ec 28             	sub    $0x28,%esp
801016e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801016e9:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016ed:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016f4:	e9 9e 00 00 00       	jmp    80101797 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016fc:	c1 e8 03             	shr    $0x3,%eax
801016ff:	89 c2                	mov    %eax,%edx
80101701:	a1 54 22 11 80       	mov    0x80112254,%eax
80101706:	01 d0                	add    %edx,%eax
80101708:	83 ec 08             	sub    $0x8,%esp
8010170b:	50                   	push   %eax
8010170c:	ff 75 08             	pushl  0x8(%ebp)
8010170f:	e8 a2 ea ff ff       	call   801001b6 <bread>
80101714:	83 c4 10             	add    $0x10,%esp
80101717:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171d:	8d 50 18             	lea    0x18(%eax),%edx
80101720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101723:	83 e0 07             	and    $0x7,%eax
80101726:	c1 e0 06             	shl    $0x6,%eax
80101729:	01 d0                	add    %edx,%eax
8010172b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010172e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101731:	0f b7 00             	movzwl (%eax),%eax
80101734:	66 85 c0             	test   %ax,%ax
80101737:	75 4c                	jne    80101785 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101739:	83 ec 04             	sub    $0x4,%esp
8010173c:	6a 40                	push   $0x40
8010173e:	6a 00                	push   $0x0
80101740:	ff 75 ec             	pushl  -0x14(%ebp)
80101743:	e8 64 42 00 00       	call   801059ac <memset>
80101748:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
8010174b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010174e:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101752:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101755:	83 ec 0c             	sub    $0xc,%esp
80101758:	ff 75 f0             	pushl  -0x10(%ebp)
8010175b:	e8 4c 20 00 00       	call   801037ac <log_write>
80101760:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101763:	83 ec 0c             	sub    $0xc,%esp
80101766:	ff 75 f0             	pushl  -0x10(%ebp)
80101769:	e8 c0 ea ff ff       	call   8010022e <brelse>
8010176e:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101774:	83 ec 08             	sub    $0x8,%esp
80101777:	50                   	push   %eax
80101778:	ff 75 08             	pushl  0x8(%ebp)
8010177b:	e8 f8 00 00 00       	call   80101878 <iget>
80101780:	83 c4 10             	add    $0x10,%esp
80101783:	eb 30                	jmp    801017b5 <ialloc+0xd5>
    }
    brelse(bp);
80101785:	83 ec 0c             	sub    $0xc,%esp
80101788:	ff 75 f0             	pushl  -0x10(%ebp)
8010178b:	e8 9e ea ff ff       	call   8010022e <brelse>
80101790:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101793:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101797:	8b 15 48 22 11 80    	mov    0x80112248,%edx
8010179d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a0:	39 c2                	cmp    %eax,%edx
801017a2:	0f 87 51 ff ff ff    	ja     801016f9 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801017a8:	83 ec 0c             	sub    $0xc,%esp
801017ab:	68 cf 8e 10 80       	push   $0x80108ecf
801017b0:	e8 b1 ed ff ff       	call   80100566 <panic>
}
801017b5:	c9                   	leave  
801017b6:	c3                   	ret    

801017b7 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801017b7:	55                   	push   %ebp
801017b8:	89 e5                	mov    %esp,%ebp
801017ba:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017bd:	8b 45 08             	mov    0x8(%ebp),%eax
801017c0:	8b 40 04             	mov    0x4(%eax),%eax
801017c3:	c1 e8 03             	shr    $0x3,%eax
801017c6:	89 c2                	mov    %eax,%edx
801017c8:	a1 54 22 11 80       	mov    0x80112254,%eax
801017cd:	01 c2                	add    %eax,%edx
801017cf:	8b 45 08             	mov    0x8(%ebp),%eax
801017d2:	8b 00                	mov    (%eax),%eax
801017d4:	83 ec 08             	sub    $0x8,%esp
801017d7:	52                   	push   %edx
801017d8:	50                   	push   %eax
801017d9:	e8 d8 e9 ff ff       	call   801001b6 <bread>
801017de:	83 c4 10             	add    $0x10,%esp
801017e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e7:	8d 50 18             	lea    0x18(%eax),%edx
801017ea:	8b 45 08             	mov    0x8(%ebp),%eax
801017ed:	8b 40 04             	mov    0x4(%eax),%eax
801017f0:	83 e0 07             	and    $0x7,%eax
801017f3:	c1 e0 06             	shl    $0x6,%eax
801017f6:	01 d0                	add    %edx,%eax
801017f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017fb:	8b 45 08             	mov    0x8(%ebp),%eax
801017fe:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101802:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101805:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101808:	8b 45 08             	mov    0x8(%ebp),%eax
8010180b:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010180f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101812:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101816:	8b 45 08             	mov    0x8(%ebp),%eax
80101819:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101820:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101824:	8b 45 08             	mov    0x8(%ebp),%eax
80101827:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010182e:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101832:	8b 45 08             	mov    0x8(%ebp),%eax
80101835:	8b 50 18             	mov    0x18(%eax),%edx
80101838:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010183b:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183e:	8b 45 08             	mov    0x8(%ebp),%eax
80101841:	8d 50 1c             	lea    0x1c(%eax),%edx
80101844:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101847:	83 c0 0c             	add    $0xc,%eax
8010184a:	83 ec 04             	sub    $0x4,%esp
8010184d:	6a 34                	push   $0x34
8010184f:	52                   	push   %edx
80101850:	50                   	push   %eax
80101851:	e8 15 42 00 00       	call   80105a6b <memmove>
80101856:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101859:	83 ec 0c             	sub    $0xc,%esp
8010185c:	ff 75 f4             	pushl  -0xc(%ebp)
8010185f:	e8 48 1f 00 00       	call   801037ac <log_write>
80101864:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	ff 75 f4             	pushl  -0xc(%ebp)
8010186d:	e8 bc e9 ff ff       	call   8010022e <brelse>
80101872:	83 c4 10             	add    $0x10,%esp
}
80101875:	90                   	nop
80101876:	c9                   	leave  
80101877:	c3                   	ret    

80101878 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101878:	55                   	push   %ebp
80101879:	89 e5                	mov    %esp,%ebp
8010187b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010187e:	83 ec 0c             	sub    $0xc,%esp
80101881:	68 60 22 11 80       	push   $0x80112260
80101886:	e8 be 3e 00 00       	call   80105749 <acquire>
8010188b:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010188e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101895:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
8010189c:	eb 5d                	jmp    801018fb <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a1:	8b 40 08             	mov    0x8(%eax),%eax
801018a4:	85 c0                	test   %eax,%eax
801018a6:	7e 39                	jle    801018e1 <iget+0x69>
801018a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ab:	8b 00                	mov    (%eax),%eax
801018ad:	3b 45 08             	cmp    0x8(%ebp),%eax
801018b0:	75 2f                	jne    801018e1 <iget+0x69>
801018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b5:	8b 40 04             	mov    0x4(%eax),%eax
801018b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801018bb:	75 24                	jne    801018e1 <iget+0x69>
      ip->ref++;
801018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c0:	8b 40 08             	mov    0x8(%eax),%eax
801018c3:	8d 50 01             	lea    0x1(%eax),%edx
801018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c9:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018cc:	83 ec 0c             	sub    $0xc,%esp
801018cf:	68 60 22 11 80       	push   $0x80112260
801018d4:	e8 d7 3e 00 00       	call   801057b0 <release>
801018d9:	83 c4 10             	add    $0x10,%esp
      return ip;
801018dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018df:	eb 74                	jmp    80101955 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018e5:	75 10                	jne    801018f7 <iget+0x7f>
801018e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ea:	8b 40 08             	mov    0x8(%eax),%eax
801018ed:	85 c0                	test   %eax,%eax
801018ef:	75 06                	jne    801018f7 <iget+0x7f>
      empty = ip;
801018f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f4:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018f7:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801018fb:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
80101902:	72 9a                	jb     8010189e <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101904:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101908:	75 0d                	jne    80101917 <iget+0x9f>
    panic("iget: no inodes");
8010190a:	83 ec 0c             	sub    $0xc,%esp
8010190d:	68 e1 8e 10 80       	push   $0x80108ee1
80101912:	e8 4f ec ff ff       	call   80100566 <panic>

  ip = empty;
80101917:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010191a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010191d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101920:	8b 55 08             	mov    0x8(%ebp),%edx
80101923:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101928:	8b 55 0c             	mov    0xc(%ebp),%edx
8010192b:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010192e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101931:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101938:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101942:	83 ec 0c             	sub    $0xc,%esp
80101945:	68 60 22 11 80       	push   $0x80112260
8010194a:	e8 61 3e 00 00       	call   801057b0 <release>
8010194f:	83 c4 10             	add    $0x10,%esp

  return ip;
80101952:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101955:	c9                   	leave  
80101956:	c3                   	ret    

80101957 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101957:	55                   	push   %ebp
80101958:	89 e5                	mov    %esp,%ebp
8010195a:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
8010195d:	83 ec 0c             	sub    $0xc,%esp
80101960:	68 60 22 11 80       	push   $0x80112260
80101965:	e8 df 3d 00 00       	call   80105749 <acquire>
8010196a:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
8010196d:	8b 45 08             	mov    0x8(%ebp),%eax
80101970:	8b 40 08             	mov    0x8(%eax),%eax
80101973:	8d 50 01             	lea    0x1(%eax),%edx
80101976:	8b 45 08             	mov    0x8(%ebp),%eax
80101979:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010197c:	83 ec 0c             	sub    $0xc,%esp
8010197f:	68 60 22 11 80       	push   $0x80112260
80101984:	e8 27 3e 00 00       	call   801057b0 <release>
80101989:	83 c4 10             	add    $0x10,%esp
  return ip;
8010198c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010198f:	c9                   	leave  
80101990:	c3                   	ret    

80101991 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101991:	55                   	push   %ebp
80101992:	89 e5                	mov    %esp,%ebp
80101994:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101997:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010199b:	74 0a                	je     801019a7 <ilock+0x16>
8010199d:	8b 45 08             	mov    0x8(%ebp),%eax
801019a0:	8b 40 08             	mov    0x8(%eax),%eax
801019a3:	85 c0                	test   %eax,%eax
801019a5:	7f 0d                	jg     801019b4 <ilock+0x23>
    panic("ilock");
801019a7:	83 ec 0c             	sub    $0xc,%esp
801019aa:	68 f1 8e 10 80       	push   $0x80108ef1
801019af:	e8 b2 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
801019b4:	83 ec 0c             	sub    $0xc,%esp
801019b7:	68 60 22 11 80       	push   $0x80112260
801019bc:	e8 88 3d 00 00       	call   80105749 <acquire>
801019c1:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801019c4:	eb 13                	jmp    801019d9 <ilock+0x48>
    sleep(ip, &icache.lock);
801019c6:	83 ec 08             	sub    $0x8,%esp
801019c9:	68 60 22 11 80       	push   $0x80112260
801019ce:	ff 75 08             	pushl  0x8(%ebp)
801019d1:	e8 7d 36 00 00       	call   80105053 <sleep>
801019d6:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801019d9:	8b 45 08             	mov    0x8(%ebp),%eax
801019dc:	8b 40 0c             	mov    0xc(%eax),%eax
801019df:	83 e0 01             	and    $0x1,%eax
801019e2:	85 c0                	test   %eax,%eax
801019e4:	75 e0                	jne    801019c6 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801019e6:	8b 45 08             	mov    0x8(%ebp),%eax
801019e9:	8b 40 0c             	mov    0xc(%eax),%eax
801019ec:	83 c8 01             	or     $0x1,%eax
801019ef:	89 c2                	mov    %eax,%edx
801019f1:	8b 45 08             	mov    0x8(%ebp),%eax
801019f4:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801019f7:	83 ec 0c             	sub    $0xc,%esp
801019fa:	68 60 22 11 80       	push   $0x80112260
801019ff:	e8 ac 3d 00 00       	call   801057b0 <release>
80101a04:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a07:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a0d:	83 e0 02             	and    $0x2,%eax
80101a10:	85 c0                	test   %eax,%eax
80101a12:	0f 85 d4 00 00 00    	jne    80101aec <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a18:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1b:	8b 40 04             	mov    0x4(%eax),%eax
80101a1e:	c1 e8 03             	shr    $0x3,%eax
80101a21:	89 c2                	mov    %eax,%edx
80101a23:	a1 54 22 11 80       	mov    0x80112254,%eax
80101a28:	01 c2                	add    %eax,%edx
80101a2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2d:	8b 00                	mov    (%eax),%eax
80101a2f:	83 ec 08             	sub    $0x8,%esp
80101a32:	52                   	push   %edx
80101a33:	50                   	push   %eax
80101a34:	e8 7d e7 ff ff       	call   801001b6 <bread>
80101a39:	83 c4 10             	add    $0x10,%esp
80101a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a42:	8d 50 18             	lea    0x18(%eax),%edx
80101a45:	8b 45 08             	mov    0x8(%ebp),%eax
80101a48:	8b 40 04             	mov    0x4(%eax),%eax
80101a4b:	83 e0 07             	and    $0x7,%eax
80101a4e:	c1 e0 06             	shl    $0x6,%eax
80101a51:	01 d0                	add    %edx,%eax
80101a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a59:	0f b7 10             	movzwl (%eax),%edx
80101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5f:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a66:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6d:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a74:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a78:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7b:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a82:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a86:	8b 45 08             	mov    0x8(%ebp),%eax
80101a89:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a90:	8b 50 08             	mov    0x8(%eax),%edx
80101a93:	8b 45 08             	mov    0x8(%ebp),%eax
80101a96:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a9c:	8d 50 0c             	lea    0xc(%eax),%edx
80101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa2:	83 c0 1c             	add    $0x1c,%eax
80101aa5:	83 ec 04             	sub    $0x4,%esp
80101aa8:	6a 34                	push   $0x34
80101aaa:	52                   	push   %edx
80101aab:	50                   	push   %eax
80101aac:	e8 ba 3f 00 00       	call   80105a6b <memmove>
80101ab1:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101ab4:	83 ec 0c             	sub    $0xc,%esp
80101ab7:	ff 75 f4             	pushl  -0xc(%ebp)
80101aba:	e8 6f e7 ff ff       	call   8010022e <brelse>
80101abf:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac5:	8b 40 0c             	mov    0xc(%eax),%eax
80101ac8:	83 c8 02             	or     $0x2,%eax
80101acb:	89 c2                	mov    %eax,%edx
80101acd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad0:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ada:	66 85 c0             	test   %ax,%ax
80101add:	75 0d                	jne    80101aec <ilock+0x15b>
      panic("ilock: no type");
80101adf:	83 ec 0c             	sub    $0xc,%esp
80101ae2:	68 f7 8e 10 80       	push   $0x80108ef7
80101ae7:	e8 7a ea ff ff       	call   80100566 <panic>
  }
}
80101aec:	90                   	nop
80101aed:	c9                   	leave  
80101aee:	c3                   	ret    

80101aef <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101aef:	55                   	push   %ebp
80101af0:	89 e5                	mov    %esp,%ebp
80101af2:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101af5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101af9:	74 17                	je     80101b12 <iunlock+0x23>
80101afb:	8b 45 08             	mov    0x8(%ebp),%eax
80101afe:	8b 40 0c             	mov    0xc(%eax),%eax
80101b01:	83 e0 01             	and    $0x1,%eax
80101b04:	85 c0                	test   %eax,%eax
80101b06:	74 0a                	je     80101b12 <iunlock+0x23>
80101b08:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0b:	8b 40 08             	mov    0x8(%eax),%eax
80101b0e:	85 c0                	test   %eax,%eax
80101b10:	7f 0d                	jg     80101b1f <iunlock+0x30>
    panic("iunlock");
80101b12:	83 ec 0c             	sub    $0xc,%esp
80101b15:	68 06 8f 10 80       	push   $0x80108f06
80101b1a:	e8 47 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b1f:	83 ec 0c             	sub    $0xc,%esp
80101b22:	68 60 22 11 80       	push   $0x80112260
80101b27:	e8 1d 3c 00 00       	call   80105749 <acquire>
80101b2c:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b32:	8b 40 0c             	mov    0xc(%eax),%eax
80101b35:	83 e0 fe             	and    $0xfffffffe,%eax
80101b38:	89 c2                	mov    %eax,%edx
80101b3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3d:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b40:	83 ec 0c             	sub    $0xc,%esp
80101b43:	ff 75 08             	pushl  0x8(%ebp)
80101b46:	e8 ef 35 00 00       	call   8010513a <wakeup>
80101b4b:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101b4e:	83 ec 0c             	sub    $0xc,%esp
80101b51:	68 60 22 11 80       	push   $0x80112260
80101b56:	e8 55 3c 00 00       	call   801057b0 <release>
80101b5b:	83 c4 10             	add    $0x10,%esp
}
80101b5e:	90                   	nop
80101b5f:	c9                   	leave  
80101b60:	c3                   	ret    

80101b61 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b61:	55                   	push   %ebp
80101b62:	89 e5                	mov    %esp,%ebp
80101b64:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b67:	83 ec 0c             	sub    $0xc,%esp
80101b6a:	68 60 22 11 80       	push   $0x80112260
80101b6f:	e8 d5 3b 00 00       	call   80105749 <acquire>
80101b74:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b77:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7a:	8b 40 08             	mov    0x8(%eax),%eax
80101b7d:	83 f8 01             	cmp    $0x1,%eax
80101b80:	0f 85 a9 00 00 00    	jne    80101c2f <iput+0xce>
80101b86:	8b 45 08             	mov    0x8(%ebp),%eax
80101b89:	8b 40 0c             	mov    0xc(%eax),%eax
80101b8c:	83 e0 02             	and    $0x2,%eax
80101b8f:	85 c0                	test   %eax,%eax
80101b91:	0f 84 98 00 00 00    	je     80101c2f <iput+0xce>
80101b97:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b9e:	66 85 c0             	test   %ax,%ax
80101ba1:	0f 85 88 00 00 00    	jne    80101c2f <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101ba7:	8b 45 08             	mov    0x8(%ebp),%eax
80101baa:	8b 40 0c             	mov    0xc(%eax),%eax
80101bad:	83 e0 01             	and    $0x1,%eax
80101bb0:	85 c0                	test   %eax,%eax
80101bb2:	74 0d                	je     80101bc1 <iput+0x60>
      panic("iput busy");
80101bb4:	83 ec 0c             	sub    $0xc,%esp
80101bb7:	68 0e 8f 10 80       	push   $0x80108f0e
80101bbc:	e8 a5 e9 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc4:	8b 40 0c             	mov    0xc(%eax),%eax
80101bc7:	83 c8 01             	or     $0x1,%eax
80101bca:	89 c2                	mov    %eax,%edx
80101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcf:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101bd2:	83 ec 0c             	sub    $0xc,%esp
80101bd5:	68 60 22 11 80       	push   $0x80112260
80101bda:	e8 d1 3b 00 00       	call   801057b0 <release>
80101bdf:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101be2:	83 ec 0c             	sub    $0xc,%esp
80101be5:	ff 75 08             	pushl  0x8(%ebp)
80101be8:	e8 a8 01 00 00       	call   80101d95 <itrunc>
80101bed:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf3:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101bf9:	83 ec 0c             	sub    $0xc,%esp
80101bfc:	ff 75 08             	pushl  0x8(%ebp)
80101bff:	e8 b3 fb ff ff       	call   801017b7 <iupdate>
80101c04:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c07:	83 ec 0c             	sub    $0xc,%esp
80101c0a:	68 60 22 11 80       	push   $0x80112260
80101c0f:	e8 35 3b 00 00       	call   80105749 <acquire>
80101c14:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c17:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c21:	83 ec 0c             	sub    $0xc,%esp
80101c24:	ff 75 08             	pushl  0x8(%ebp)
80101c27:	e8 0e 35 00 00       	call   8010513a <wakeup>
80101c2c:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101c2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c32:	8b 40 08             	mov    0x8(%eax),%eax
80101c35:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c38:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3b:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c3e:	83 ec 0c             	sub    $0xc,%esp
80101c41:	68 60 22 11 80       	push   $0x80112260
80101c46:	e8 65 3b 00 00       	call   801057b0 <release>
80101c4b:	83 c4 10             	add    $0x10,%esp
}
80101c4e:	90                   	nop
80101c4f:	c9                   	leave  
80101c50:	c3                   	ret    

80101c51 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c51:	55                   	push   %ebp
80101c52:	89 e5                	mov    %esp,%ebp
80101c54:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c57:	83 ec 0c             	sub    $0xc,%esp
80101c5a:	ff 75 08             	pushl  0x8(%ebp)
80101c5d:	e8 8d fe ff ff       	call   80101aef <iunlock>
80101c62:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c65:	83 ec 0c             	sub    $0xc,%esp
80101c68:	ff 75 08             	pushl  0x8(%ebp)
80101c6b:	e8 f1 fe ff ff       	call   80101b61 <iput>
80101c70:	83 c4 10             	add    $0x10,%esp
}
80101c73:	90                   	nop
80101c74:	c9                   	leave  
80101c75:	c3                   	ret    

80101c76 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c76:	55                   	push   %ebp
80101c77:	89 e5                	mov    %esp,%ebp
80101c79:	53                   	push   %ebx
80101c7a:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c7d:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c81:	77 42                	ja     80101cc5 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c83:	8b 45 08             	mov    0x8(%ebp),%eax
80101c86:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c89:	83 c2 04             	add    $0x4,%edx
80101c8c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c97:	75 24                	jne    80101cbd <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c99:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9c:	8b 00                	mov    (%eax),%eax
80101c9e:	83 ec 0c             	sub    $0xc,%esp
80101ca1:	50                   	push   %eax
80101ca2:	e8 9a f7 ff ff       	call   80101441 <balloc>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cad:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cb3:	8d 4a 04             	lea    0x4(%edx),%ecx
80101cb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cb9:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cc0:	e9 cb 00 00 00       	jmp    80101d90 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101cc5:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101cc9:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101ccd:	0f 87 b0 00 00 00    	ja     80101d83 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd6:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ce0:	75 1d                	jne    80101cff <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ce2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce5:	8b 00                	mov    (%eax),%eax
80101ce7:	83 ec 0c             	sub    $0xc,%esp
80101cea:	50                   	push   %eax
80101ceb:	e8 51 f7 ff ff       	call   80101441 <balloc>
80101cf0:	83 c4 10             	add    $0x10,%esp
80101cf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cfc:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101cff:	8b 45 08             	mov    0x8(%ebp),%eax
80101d02:	8b 00                	mov    (%eax),%eax
80101d04:	83 ec 08             	sub    $0x8,%esp
80101d07:	ff 75 f4             	pushl  -0xc(%ebp)
80101d0a:	50                   	push   %eax
80101d0b:	e8 a6 e4 ff ff       	call   801001b6 <bread>
80101d10:	83 c4 10             	add    $0x10,%esp
80101d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d19:	83 c0 18             	add    $0x18,%eax
80101d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d2c:	01 d0                	add    %edx,%eax
80101d2e:	8b 00                	mov    (%eax),%eax
80101d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d37:	75 37                	jne    80101d70 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101d39:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d43:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d46:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d49:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4c:	8b 00                	mov    (%eax),%eax
80101d4e:	83 ec 0c             	sub    $0xc,%esp
80101d51:	50                   	push   %eax
80101d52:	e8 ea f6 ff ff       	call   80101441 <balloc>
80101d57:	83 c4 10             	add    $0x10,%esp
80101d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d60:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	ff 75 f0             	pushl  -0x10(%ebp)
80101d68:	e8 3f 1a 00 00       	call   801037ac <log_write>
80101d6d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d70:	83 ec 0c             	sub    $0xc,%esp
80101d73:	ff 75 f0             	pushl  -0x10(%ebp)
80101d76:	e8 b3 e4 ff ff       	call   8010022e <brelse>
80101d7b:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d81:	eb 0d                	jmp    80101d90 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101d83:	83 ec 0c             	sub    $0xc,%esp
80101d86:	68 18 8f 10 80       	push   $0x80108f18
80101d8b:	e8 d6 e7 ff ff       	call   80100566 <panic>
}
80101d90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d93:	c9                   	leave  
80101d94:	c3                   	ret    

80101d95 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d95:	55                   	push   %ebp
80101d96:	89 e5                	mov    %esp,%ebp
80101d98:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101da2:	eb 45                	jmp    80101de9 <itrunc+0x54>
    if(ip->addrs[i]){
80101da4:	8b 45 08             	mov    0x8(%ebp),%eax
80101da7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101daa:	83 c2 04             	add    $0x4,%edx
80101dad:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101db1:	85 c0                	test   %eax,%eax
80101db3:	74 30                	je     80101de5 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101db5:	8b 45 08             	mov    0x8(%ebp),%eax
80101db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dbb:	83 c2 04             	add    $0x4,%edx
80101dbe:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101dc2:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc5:	8b 12                	mov    (%edx),%edx
80101dc7:	83 ec 08             	sub    $0x8,%esp
80101dca:	50                   	push   %eax
80101dcb:	52                   	push   %edx
80101dcc:	e8 bc f7 ff ff       	call   8010158d <bfree>
80101dd1:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dda:	83 c2 04             	add    $0x4,%edx
80101ddd:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101de4:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101de5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101de9:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ded:	7e b5                	jle    80101da4 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101def:	8b 45 08             	mov    0x8(%ebp),%eax
80101df2:	8b 40 4c             	mov    0x4c(%eax),%eax
80101df5:	85 c0                	test   %eax,%eax
80101df7:	0f 84 a1 00 00 00    	je     80101e9e <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101e00:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e03:	8b 45 08             	mov    0x8(%ebp),%eax
80101e06:	8b 00                	mov    (%eax),%eax
80101e08:	83 ec 08             	sub    $0x8,%esp
80101e0b:	52                   	push   %edx
80101e0c:	50                   	push   %eax
80101e0d:	e8 a4 e3 ff ff       	call   801001b6 <bread>
80101e12:	83 c4 10             	add    $0x10,%esp
80101e15:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e1b:	83 c0 18             	add    $0x18,%eax
80101e1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e21:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e28:	eb 3c                	jmp    80101e66 <itrunc+0xd1>
      if(a[j])
80101e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e34:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e37:	01 d0                	add    %edx,%eax
80101e39:	8b 00                	mov    (%eax),%eax
80101e3b:	85 c0                	test   %eax,%eax
80101e3d:	74 23                	je     80101e62 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e4c:	01 d0                	add    %edx,%eax
80101e4e:	8b 00                	mov    (%eax),%eax
80101e50:	8b 55 08             	mov    0x8(%ebp),%edx
80101e53:	8b 12                	mov    (%edx),%edx
80101e55:	83 ec 08             	sub    $0x8,%esp
80101e58:	50                   	push   %eax
80101e59:	52                   	push   %edx
80101e5a:	e8 2e f7 ff ff       	call   8010158d <bfree>
80101e5f:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e62:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e69:	83 f8 7f             	cmp    $0x7f,%eax
80101e6c:	76 bc                	jbe    80101e2a <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	ff 75 ec             	pushl  -0x14(%ebp)
80101e74:	e8 b5 e3 ff ff       	call   8010022e <brelse>
80101e79:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7f:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e82:	8b 55 08             	mov    0x8(%ebp),%edx
80101e85:	8b 12                	mov    (%edx),%edx
80101e87:	83 ec 08             	sub    $0x8,%esp
80101e8a:	50                   	push   %eax
80101e8b:	52                   	push   %edx
80101e8c:	e8 fc f6 ff ff       	call   8010158d <bfree>
80101e91:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e94:	8b 45 08             	mov    0x8(%ebp),%eax
80101e97:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea1:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101ea8:	83 ec 0c             	sub    $0xc,%esp
80101eab:	ff 75 08             	pushl  0x8(%ebp)
80101eae:	e8 04 f9 ff ff       	call   801017b7 <iupdate>
80101eb3:	83 c4 10             	add    $0x10,%esp
}
80101eb6:	90                   	nop
80101eb7:	c9                   	leave  
80101eb8:	c3                   	ret    

80101eb9 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101eb9:	55                   	push   %ebp
80101eba:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebf:	8b 00                	mov    (%eax),%eax
80101ec1:	89 c2                	mov    %eax,%edx
80101ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec6:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ec9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecc:	8b 50 04             	mov    0x4(%eax),%edx
80101ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed2:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed8:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101edc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101edf:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee5:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eec:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ef0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef3:	8b 50 18             	mov    0x18(%eax),%edx
80101ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ef9:	89 50 10             	mov    %edx,0x10(%eax)
}
80101efc:	90                   	nop
80101efd:	5d                   	pop    %ebp
80101efe:	c3                   	ret    

80101eff <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101eff:	55                   	push   %ebp
80101f00:	89 e5                	mov    %esp,%ebp
80101f02:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f05:	8b 45 08             	mov    0x8(%ebp),%eax
80101f08:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f0c:	66 83 f8 03          	cmp    $0x3,%ax
80101f10:	75 5c                	jne    80101f6e <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f12:	8b 45 08             	mov    0x8(%ebp),%eax
80101f15:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f19:	66 85 c0             	test   %ax,%ax
80101f1c:	78 20                	js     80101f3e <readi+0x3f>
80101f1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f21:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f25:	66 83 f8 09          	cmp    $0x9,%ax
80101f29:	7f 13                	jg     80101f3e <readi+0x3f>
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f32:	98                   	cwtl   
80101f33:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101f3a:	85 c0                	test   %eax,%eax
80101f3c:	75 0a                	jne    80101f48 <readi+0x49>
      return -1;
80101f3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f43:	e9 0c 01 00 00       	jmp    80102054 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f48:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f4f:	98                   	cwtl   
80101f50:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101f57:	8b 55 14             	mov    0x14(%ebp),%edx
80101f5a:	83 ec 04             	sub    $0x4,%esp
80101f5d:	52                   	push   %edx
80101f5e:	ff 75 0c             	pushl  0xc(%ebp)
80101f61:	ff 75 08             	pushl  0x8(%ebp)
80101f64:	ff d0                	call   *%eax
80101f66:	83 c4 10             	add    $0x10,%esp
80101f69:	e9 e6 00 00 00       	jmp    80102054 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f71:	8b 40 18             	mov    0x18(%eax),%eax
80101f74:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f77:	72 0d                	jb     80101f86 <readi+0x87>
80101f79:	8b 55 10             	mov    0x10(%ebp),%edx
80101f7c:	8b 45 14             	mov    0x14(%ebp),%eax
80101f7f:	01 d0                	add    %edx,%eax
80101f81:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f84:	73 0a                	jae    80101f90 <readi+0x91>
    return -1;
80101f86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f8b:	e9 c4 00 00 00       	jmp    80102054 <readi+0x155>
  if(off + n > ip->size)
80101f90:	8b 55 10             	mov    0x10(%ebp),%edx
80101f93:	8b 45 14             	mov    0x14(%ebp),%eax
80101f96:	01 c2                	add    %eax,%edx
80101f98:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9b:	8b 40 18             	mov    0x18(%eax),%eax
80101f9e:	39 c2                	cmp    %eax,%edx
80101fa0:	76 0c                	jbe    80101fae <readi+0xaf>
    n = ip->size - off;
80101fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa5:	8b 40 18             	mov    0x18(%eax),%eax
80101fa8:	2b 45 10             	sub    0x10(%ebp),%eax
80101fab:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fb5:	e9 8b 00 00 00       	jmp    80102045 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fba:	8b 45 10             	mov    0x10(%ebp),%eax
80101fbd:	c1 e8 09             	shr    $0x9,%eax
80101fc0:	83 ec 08             	sub    $0x8,%esp
80101fc3:	50                   	push   %eax
80101fc4:	ff 75 08             	pushl  0x8(%ebp)
80101fc7:	e8 aa fc ff ff       	call   80101c76 <bmap>
80101fcc:	83 c4 10             	add    $0x10,%esp
80101fcf:	89 c2                	mov    %eax,%edx
80101fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd4:	8b 00                	mov    (%eax),%eax
80101fd6:	83 ec 08             	sub    $0x8,%esp
80101fd9:	52                   	push   %edx
80101fda:	50                   	push   %eax
80101fdb:	e8 d6 e1 ff ff       	call   801001b6 <bread>
80101fe0:	83 c4 10             	add    $0x10,%esp
80101fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fe6:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fee:	ba 00 02 00 00       	mov    $0x200,%edx
80101ff3:	29 c2                	sub    %eax,%edx
80101ff5:	8b 45 14             	mov    0x14(%ebp),%eax
80101ff8:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101ffb:	39 c2                	cmp    %eax,%edx
80101ffd:	0f 46 c2             	cmovbe %edx,%eax
80102000:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102003:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102006:	8d 50 18             	lea    0x18(%eax),%edx
80102009:	8b 45 10             	mov    0x10(%ebp),%eax
8010200c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102011:	01 d0                	add    %edx,%eax
80102013:	83 ec 04             	sub    $0x4,%esp
80102016:	ff 75 ec             	pushl  -0x14(%ebp)
80102019:	50                   	push   %eax
8010201a:	ff 75 0c             	pushl  0xc(%ebp)
8010201d:	e8 49 3a 00 00       	call   80105a6b <memmove>
80102022:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	ff 75 f0             	pushl  -0x10(%ebp)
8010202b:	e8 fe e1 ff ff       	call   8010022e <brelse>
80102030:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102033:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102036:	01 45 f4             	add    %eax,-0xc(%ebp)
80102039:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010203c:	01 45 10             	add    %eax,0x10(%ebp)
8010203f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102042:	01 45 0c             	add    %eax,0xc(%ebp)
80102045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102048:	3b 45 14             	cmp    0x14(%ebp),%eax
8010204b:	0f 82 69 ff ff ff    	jb     80101fba <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102051:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102054:	c9                   	leave  
80102055:	c3                   	ret    

80102056 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102056:	55                   	push   %ebp
80102057:	89 e5                	mov    %esp,%ebp
80102059:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010205c:	8b 45 08             	mov    0x8(%ebp),%eax
8010205f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102063:	66 83 f8 03          	cmp    $0x3,%ax
80102067:	75 5c                	jne    801020c5 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102069:	8b 45 08             	mov    0x8(%ebp),%eax
8010206c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102070:	66 85 c0             	test   %ax,%ax
80102073:	78 20                	js     80102095 <writei+0x3f>
80102075:	8b 45 08             	mov    0x8(%ebp),%eax
80102078:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010207c:	66 83 f8 09          	cmp    $0x9,%ax
80102080:	7f 13                	jg     80102095 <writei+0x3f>
80102082:	8b 45 08             	mov    0x8(%ebp),%eax
80102085:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102089:	98                   	cwtl   
8010208a:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80102091:	85 c0                	test   %eax,%eax
80102093:	75 0a                	jne    8010209f <writei+0x49>
      return -1;
80102095:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010209a:	e9 3d 01 00 00       	jmp    801021dc <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010209f:	8b 45 08             	mov    0x8(%ebp),%eax
801020a2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020a6:	98                   	cwtl   
801020a7:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
801020ae:	8b 55 14             	mov    0x14(%ebp),%edx
801020b1:	83 ec 04             	sub    $0x4,%esp
801020b4:	52                   	push   %edx
801020b5:	ff 75 0c             	pushl  0xc(%ebp)
801020b8:	ff 75 08             	pushl  0x8(%ebp)
801020bb:	ff d0                	call   *%eax
801020bd:	83 c4 10             	add    $0x10,%esp
801020c0:	e9 17 01 00 00       	jmp    801021dc <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801020c5:	8b 45 08             	mov    0x8(%ebp),%eax
801020c8:	8b 40 18             	mov    0x18(%eax),%eax
801020cb:	3b 45 10             	cmp    0x10(%ebp),%eax
801020ce:	72 0d                	jb     801020dd <writei+0x87>
801020d0:	8b 55 10             	mov    0x10(%ebp),%edx
801020d3:	8b 45 14             	mov    0x14(%ebp),%eax
801020d6:	01 d0                	add    %edx,%eax
801020d8:	3b 45 10             	cmp    0x10(%ebp),%eax
801020db:	73 0a                	jae    801020e7 <writei+0x91>
    return -1;
801020dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e2:	e9 f5 00 00 00       	jmp    801021dc <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801020e7:	8b 55 10             	mov    0x10(%ebp),%edx
801020ea:	8b 45 14             	mov    0x14(%ebp),%eax
801020ed:	01 d0                	add    %edx,%eax
801020ef:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020f4:	76 0a                	jbe    80102100 <writei+0xaa>
    return -1;
801020f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020fb:	e9 dc 00 00 00       	jmp    801021dc <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102100:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102107:	e9 99 00 00 00       	jmp    801021a5 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010210c:	8b 45 10             	mov    0x10(%ebp),%eax
8010210f:	c1 e8 09             	shr    $0x9,%eax
80102112:	83 ec 08             	sub    $0x8,%esp
80102115:	50                   	push   %eax
80102116:	ff 75 08             	pushl  0x8(%ebp)
80102119:	e8 58 fb ff ff       	call   80101c76 <bmap>
8010211e:	83 c4 10             	add    $0x10,%esp
80102121:	89 c2                	mov    %eax,%edx
80102123:	8b 45 08             	mov    0x8(%ebp),%eax
80102126:	8b 00                	mov    (%eax),%eax
80102128:	83 ec 08             	sub    $0x8,%esp
8010212b:	52                   	push   %edx
8010212c:	50                   	push   %eax
8010212d:	e8 84 e0 ff ff       	call   801001b6 <bread>
80102132:	83 c4 10             	add    $0x10,%esp
80102135:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102138:	8b 45 10             	mov    0x10(%ebp),%eax
8010213b:	25 ff 01 00 00       	and    $0x1ff,%eax
80102140:	ba 00 02 00 00       	mov    $0x200,%edx
80102145:	29 c2                	sub    %eax,%edx
80102147:	8b 45 14             	mov    0x14(%ebp),%eax
8010214a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010214d:	39 c2                	cmp    %eax,%edx
8010214f:	0f 46 c2             	cmovbe %edx,%eax
80102152:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102155:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102158:	8d 50 18             	lea    0x18(%eax),%edx
8010215b:	8b 45 10             	mov    0x10(%ebp),%eax
8010215e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102163:	01 d0                	add    %edx,%eax
80102165:	83 ec 04             	sub    $0x4,%esp
80102168:	ff 75 ec             	pushl  -0x14(%ebp)
8010216b:	ff 75 0c             	pushl  0xc(%ebp)
8010216e:	50                   	push   %eax
8010216f:	e8 f7 38 00 00       	call   80105a6b <memmove>
80102174:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102177:	83 ec 0c             	sub    $0xc,%esp
8010217a:	ff 75 f0             	pushl  -0x10(%ebp)
8010217d:	e8 2a 16 00 00       	call   801037ac <log_write>
80102182:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	ff 75 f0             	pushl  -0x10(%ebp)
8010218b:	e8 9e e0 ff ff       	call   8010022e <brelse>
80102190:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102193:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102196:	01 45 f4             	add    %eax,-0xc(%ebp)
80102199:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010219c:	01 45 10             	add    %eax,0x10(%ebp)
8010219f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021a2:	01 45 0c             	add    %eax,0xc(%ebp)
801021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021a8:	3b 45 14             	cmp    0x14(%ebp),%eax
801021ab:	0f 82 5b ff ff ff    	jb     8010210c <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801021b1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021b5:	74 22                	je     801021d9 <writei+0x183>
801021b7:	8b 45 08             	mov    0x8(%ebp),%eax
801021ba:	8b 40 18             	mov    0x18(%eax),%eax
801021bd:	3b 45 10             	cmp    0x10(%ebp),%eax
801021c0:	73 17                	jae    801021d9 <writei+0x183>
    ip->size = off;
801021c2:	8b 45 08             	mov    0x8(%ebp),%eax
801021c5:	8b 55 10             	mov    0x10(%ebp),%edx
801021c8:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801021cb:	83 ec 0c             	sub    $0xc,%esp
801021ce:	ff 75 08             	pushl  0x8(%ebp)
801021d1:	e8 e1 f5 ff ff       	call   801017b7 <iupdate>
801021d6:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021d9:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021dc:	c9                   	leave  
801021dd:	c3                   	ret    

801021de <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021de:	55                   	push   %ebp
801021df:	89 e5                	mov    %esp,%ebp
801021e1:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021e4:	83 ec 04             	sub    $0x4,%esp
801021e7:	6a 0e                	push   $0xe
801021e9:	ff 75 0c             	pushl  0xc(%ebp)
801021ec:	ff 75 08             	pushl  0x8(%ebp)
801021ef:	e8 0d 39 00 00       	call   80105b01 <strncmp>
801021f4:	83 c4 10             	add    $0x10,%esp
}
801021f7:	c9                   	leave  
801021f8:	c3                   	ret    

801021f9 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021f9:	55                   	push   %ebp
801021fa:	89 e5                	mov    %esp,%ebp
801021fc:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021ff:	8b 45 08             	mov    0x8(%ebp),%eax
80102202:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102206:	66 83 f8 01          	cmp    $0x1,%ax
8010220a:	74 0d                	je     80102219 <dirlookup+0x20>
    panic("dirlookup not DIR");
8010220c:	83 ec 0c             	sub    $0xc,%esp
8010220f:	68 2b 8f 10 80       	push   $0x80108f2b
80102214:	e8 4d e3 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102219:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102220:	eb 7b                	jmp    8010229d <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102222:	6a 10                	push   $0x10
80102224:	ff 75 f4             	pushl  -0xc(%ebp)
80102227:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010222a:	50                   	push   %eax
8010222b:	ff 75 08             	pushl  0x8(%ebp)
8010222e:	e8 cc fc ff ff       	call   80101eff <readi>
80102233:	83 c4 10             	add    $0x10,%esp
80102236:	83 f8 10             	cmp    $0x10,%eax
80102239:	74 0d                	je     80102248 <dirlookup+0x4f>
      panic("dirlink read");
8010223b:	83 ec 0c             	sub    $0xc,%esp
8010223e:	68 3d 8f 10 80       	push   $0x80108f3d
80102243:	e8 1e e3 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102248:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010224c:	66 85 c0             	test   %ax,%ax
8010224f:	74 47                	je     80102298 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102251:	83 ec 08             	sub    $0x8,%esp
80102254:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102257:	83 c0 02             	add    $0x2,%eax
8010225a:	50                   	push   %eax
8010225b:	ff 75 0c             	pushl  0xc(%ebp)
8010225e:	e8 7b ff ff ff       	call   801021de <namecmp>
80102263:	83 c4 10             	add    $0x10,%esp
80102266:	85 c0                	test   %eax,%eax
80102268:	75 2f                	jne    80102299 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
8010226a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010226e:	74 08                	je     80102278 <dirlookup+0x7f>
        *poff = off;
80102270:	8b 45 10             	mov    0x10(%ebp),%eax
80102273:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102276:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102278:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010227c:	0f b7 c0             	movzwl %ax,%eax
8010227f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102282:	8b 45 08             	mov    0x8(%ebp),%eax
80102285:	8b 00                	mov    (%eax),%eax
80102287:	83 ec 08             	sub    $0x8,%esp
8010228a:	ff 75 f0             	pushl  -0x10(%ebp)
8010228d:	50                   	push   %eax
8010228e:	e8 e5 f5 ff ff       	call   80101878 <iget>
80102293:	83 c4 10             	add    $0x10,%esp
80102296:	eb 19                	jmp    801022b1 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102298:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102299:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010229d:	8b 45 08             	mov    0x8(%ebp),%eax
801022a0:	8b 40 18             	mov    0x18(%eax),%eax
801022a3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801022a6:	0f 87 76 ff ff ff    	ja     80102222 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801022ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022b1:	c9                   	leave  
801022b2:	c3                   	ret    

801022b3 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022b3:	55                   	push   %ebp
801022b4:	89 e5                	mov    %esp,%ebp
801022b6:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022b9:	83 ec 04             	sub    $0x4,%esp
801022bc:	6a 00                	push   $0x0
801022be:	ff 75 0c             	pushl  0xc(%ebp)
801022c1:	ff 75 08             	pushl  0x8(%ebp)
801022c4:	e8 30 ff ff ff       	call   801021f9 <dirlookup>
801022c9:	83 c4 10             	add    $0x10,%esp
801022cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022d3:	74 18                	je     801022ed <dirlink+0x3a>
    iput(ip);
801022d5:	83 ec 0c             	sub    $0xc,%esp
801022d8:	ff 75 f0             	pushl  -0x10(%ebp)
801022db:	e8 81 f8 ff ff       	call   80101b61 <iput>
801022e0:	83 c4 10             	add    $0x10,%esp
    return -1;
801022e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022e8:	e9 9c 00 00 00       	jmp    80102389 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022f4:	eb 39                	jmp    8010232f <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f9:	6a 10                	push   $0x10
801022fb:	50                   	push   %eax
801022fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022ff:	50                   	push   %eax
80102300:	ff 75 08             	pushl  0x8(%ebp)
80102303:	e8 f7 fb ff ff       	call   80101eff <readi>
80102308:	83 c4 10             	add    $0x10,%esp
8010230b:	83 f8 10             	cmp    $0x10,%eax
8010230e:	74 0d                	je     8010231d <dirlink+0x6a>
      panic("dirlink read");
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 3d 8f 10 80       	push   $0x80108f3d
80102318:	e8 49 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
8010231d:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102321:	66 85 c0             	test   %ax,%ax
80102324:	74 18                	je     8010233e <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102329:	83 c0 10             	add    $0x10,%eax
8010232c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010232f:	8b 45 08             	mov    0x8(%ebp),%eax
80102332:	8b 50 18             	mov    0x18(%eax),%edx
80102335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102338:	39 c2                	cmp    %eax,%edx
8010233a:	77 ba                	ja     801022f6 <dirlink+0x43>
8010233c:	eb 01                	jmp    8010233f <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
8010233e:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010233f:	83 ec 04             	sub    $0x4,%esp
80102342:	6a 0e                	push   $0xe
80102344:	ff 75 0c             	pushl  0xc(%ebp)
80102347:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010234a:	83 c0 02             	add    $0x2,%eax
8010234d:	50                   	push   %eax
8010234e:	e8 04 38 00 00       	call   80105b57 <strncpy>
80102353:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102356:	8b 45 10             	mov    0x10(%ebp),%eax
80102359:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102360:	6a 10                	push   $0x10
80102362:	50                   	push   %eax
80102363:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102366:	50                   	push   %eax
80102367:	ff 75 08             	pushl  0x8(%ebp)
8010236a:	e8 e7 fc ff ff       	call   80102056 <writei>
8010236f:	83 c4 10             	add    $0x10,%esp
80102372:	83 f8 10             	cmp    $0x10,%eax
80102375:	74 0d                	je     80102384 <dirlink+0xd1>
    panic("dirlink");
80102377:	83 ec 0c             	sub    $0xc,%esp
8010237a:	68 4a 8f 10 80       	push   $0x80108f4a
8010237f:	e8 e2 e1 ff ff       	call   80100566 <panic>
  
  return 0;
80102384:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102389:	c9                   	leave  
8010238a:	c3                   	ret    

8010238b <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010238b:	55                   	push   %ebp
8010238c:	89 e5                	mov    %esp,%ebp
8010238e:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102391:	eb 04                	jmp    80102397 <skipelem+0xc>
    path++;
80102393:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102397:	8b 45 08             	mov    0x8(%ebp),%eax
8010239a:	0f b6 00             	movzbl (%eax),%eax
8010239d:	3c 2f                	cmp    $0x2f,%al
8010239f:	74 f2                	je     80102393 <skipelem+0x8>
    path++;
  if(*path == 0)
801023a1:	8b 45 08             	mov    0x8(%ebp),%eax
801023a4:	0f b6 00             	movzbl (%eax),%eax
801023a7:	84 c0                	test   %al,%al
801023a9:	75 07                	jne    801023b2 <skipelem+0x27>
    return 0;
801023ab:	b8 00 00 00 00       	mov    $0x0,%eax
801023b0:	eb 7b                	jmp    8010242d <skipelem+0xa2>
  s = path;
801023b2:	8b 45 08             	mov    0x8(%ebp),%eax
801023b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023b8:	eb 04                	jmp    801023be <skipelem+0x33>
    path++;
801023ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801023be:	8b 45 08             	mov    0x8(%ebp),%eax
801023c1:	0f b6 00             	movzbl (%eax),%eax
801023c4:	3c 2f                	cmp    $0x2f,%al
801023c6:	74 0a                	je     801023d2 <skipelem+0x47>
801023c8:	8b 45 08             	mov    0x8(%ebp),%eax
801023cb:	0f b6 00             	movzbl (%eax),%eax
801023ce:	84 c0                	test   %al,%al
801023d0:	75 e8                	jne    801023ba <skipelem+0x2f>
    path++;
  len = path - s;
801023d2:	8b 55 08             	mov    0x8(%ebp),%edx
801023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d8:	29 c2                	sub    %eax,%edx
801023da:	89 d0                	mov    %edx,%eax
801023dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023df:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023e3:	7e 15                	jle    801023fa <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801023e5:	83 ec 04             	sub    $0x4,%esp
801023e8:	6a 0e                	push   $0xe
801023ea:	ff 75 f4             	pushl  -0xc(%ebp)
801023ed:	ff 75 0c             	pushl  0xc(%ebp)
801023f0:	e8 76 36 00 00       	call   80105a6b <memmove>
801023f5:	83 c4 10             	add    $0x10,%esp
801023f8:	eb 26                	jmp    80102420 <skipelem+0x95>
  else {
    memmove(name, s, len);
801023fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023fd:	83 ec 04             	sub    $0x4,%esp
80102400:	50                   	push   %eax
80102401:	ff 75 f4             	pushl  -0xc(%ebp)
80102404:	ff 75 0c             	pushl  0xc(%ebp)
80102407:	e8 5f 36 00 00       	call   80105a6b <memmove>
8010240c:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010240f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102412:	8b 45 0c             	mov    0xc(%ebp),%eax
80102415:	01 d0                	add    %edx,%eax
80102417:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010241a:	eb 04                	jmp    80102420 <skipelem+0x95>
    path++;
8010241c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102420:	8b 45 08             	mov    0x8(%ebp),%eax
80102423:	0f b6 00             	movzbl (%eax),%eax
80102426:	3c 2f                	cmp    $0x2f,%al
80102428:	74 f2                	je     8010241c <skipelem+0x91>
    path++;
  return path;
8010242a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010242d:	c9                   	leave  
8010242e:	c3                   	ret    

8010242f <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010242f:	55                   	push   %ebp
80102430:	89 e5                	mov    %esp,%ebp
80102432:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
80102438:	0f b6 00             	movzbl (%eax),%eax
8010243b:	3c 2f                	cmp    $0x2f,%al
8010243d:	75 17                	jne    80102456 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
8010243f:	83 ec 08             	sub    $0x8,%esp
80102442:	6a 01                	push   $0x1
80102444:	6a 01                	push   $0x1
80102446:	e8 2d f4 ff ff       	call   80101878 <iget>
8010244b:	83 c4 10             	add    $0x10,%esp
8010244e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102451:	e9 bb 00 00 00       	jmp    80102511 <namex+0xe2>
  else
    ip = idup(proc->cwd);
80102456:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010245c:	8b 40 68             	mov    0x68(%eax),%eax
8010245f:	83 ec 0c             	sub    $0xc,%esp
80102462:	50                   	push   %eax
80102463:	e8 ef f4 ff ff       	call   80101957 <idup>
80102468:	83 c4 10             	add    $0x10,%esp
8010246b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010246e:	e9 9e 00 00 00       	jmp    80102511 <namex+0xe2>
    ilock(ip);
80102473:	83 ec 0c             	sub    $0xc,%esp
80102476:	ff 75 f4             	pushl  -0xc(%ebp)
80102479:	e8 13 f5 ff ff       	call   80101991 <ilock>
8010247e:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102484:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102488:	66 83 f8 01          	cmp    $0x1,%ax
8010248c:	74 18                	je     801024a6 <namex+0x77>
      iunlockput(ip);
8010248e:	83 ec 0c             	sub    $0xc,%esp
80102491:	ff 75 f4             	pushl  -0xc(%ebp)
80102494:	e8 b8 f7 ff ff       	call   80101c51 <iunlockput>
80102499:	83 c4 10             	add    $0x10,%esp
      return 0;
8010249c:	b8 00 00 00 00       	mov    $0x0,%eax
801024a1:	e9 a7 00 00 00       	jmp    8010254d <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
801024a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024aa:	74 20                	je     801024cc <namex+0x9d>
801024ac:	8b 45 08             	mov    0x8(%ebp),%eax
801024af:	0f b6 00             	movzbl (%eax),%eax
801024b2:	84 c0                	test   %al,%al
801024b4:	75 16                	jne    801024cc <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	ff 75 f4             	pushl  -0xc(%ebp)
801024bc:	e8 2e f6 ff ff       	call   80101aef <iunlock>
801024c1:	83 c4 10             	add    $0x10,%esp
      return ip;
801024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c7:	e9 81 00 00 00       	jmp    8010254d <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024cc:	83 ec 04             	sub    $0x4,%esp
801024cf:	6a 00                	push   $0x0
801024d1:	ff 75 10             	pushl  0x10(%ebp)
801024d4:	ff 75 f4             	pushl  -0xc(%ebp)
801024d7:	e8 1d fd ff ff       	call   801021f9 <dirlookup>
801024dc:	83 c4 10             	add    $0x10,%esp
801024df:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024e6:	75 15                	jne    801024fd <namex+0xce>
      iunlockput(ip);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	ff 75 f4             	pushl  -0xc(%ebp)
801024ee:	e8 5e f7 ff ff       	call   80101c51 <iunlockput>
801024f3:	83 c4 10             	add    $0x10,%esp
      return 0;
801024f6:	b8 00 00 00 00       	mov    $0x0,%eax
801024fb:	eb 50                	jmp    8010254d <namex+0x11e>
    }
    iunlockput(ip);
801024fd:	83 ec 0c             	sub    $0xc,%esp
80102500:	ff 75 f4             	pushl  -0xc(%ebp)
80102503:	e8 49 f7 ff ff       	call   80101c51 <iunlockput>
80102508:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010250b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010250e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102511:	83 ec 08             	sub    $0x8,%esp
80102514:	ff 75 10             	pushl  0x10(%ebp)
80102517:	ff 75 08             	pushl  0x8(%ebp)
8010251a:	e8 6c fe ff ff       	call   8010238b <skipelem>
8010251f:	83 c4 10             	add    $0x10,%esp
80102522:	89 45 08             	mov    %eax,0x8(%ebp)
80102525:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102529:	0f 85 44 ff ff ff    	jne    80102473 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010252f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102533:	74 15                	je     8010254a <namex+0x11b>
    iput(ip);
80102535:	83 ec 0c             	sub    $0xc,%esp
80102538:	ff 75 f4             	pushl  -0xc(%ebp)
8010253b:	e8 21 f6 ff ff       	call   80101b61 <iput>
80102540:	83 c4 10             	add    $0x10,%esp
    return 0;
80102543:	b8 00 00 00 00       	mov    $0x0,%eax
80102548:	eb 03                	jmp    8010254d <namex+0x11e>
  }
  return ip;
8010254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010254d:	c9                   	leave  
8010254e:	c3                   	ret    

8010254f <namei>:

struct inode*
namei(char *path)
{
8010254f:	55                   	push   %ebp
80102550:	89 e5                	mov    %esp,%ebp
80102552:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102555:	83 ec 04             	sub    $0x4,%esp
80102558:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010255b:	50                   	push   %eax
8010255c:	6a 00                	push   $0x0
8010255e:	ff 75 08             	pushl  0x8(%ebp)
80102561:	e8 c9 fe ff ff       	call   8010242f <namex>
80102566:	83 c4 10             	add    $0x10,%esp
}
80102569:	c9                   	leave  
8010256a:	c3                   	ret    

8010256b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010256b:	55                   	push   %ebp
8010256c:	89 e5                	mov    %esp,%ebp
8010256e:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102571:	83 ec 04             	sub    $0x4,%esp
80102574:	ff 75 0c             	pushl  0xc(%ebp)
80102577:	6a 01                	push   $0x1
80102579:	ff 75 08             	pushl  0x8(%ebp)
8010257c:	e8 ae fe ff ff       	call   8010242f <namex>
80102581:	83 c4 10             	add    $0x10,%esp
}
80102584:	c9                   	leave  
80102585:	c3                   	ret    

80102586 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102586:	55                   	push   %ebp
80102587:	89 e5                	mov    %esp,%ebp
80102589:	83 ec 14             	sub    $0x14,%esp
8010258c:	8b 45 08             	mov    0x8(%ebp),%eax
8010258f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102593:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102597:	89 c2                	mov    %eax,%edx
80102599:	ec                   	in     (%dx),%al
8010259a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010259d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801025a1:	c9                   	leave  
801025a2:	c3                   	ret    

801025a3 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801025a3:	55                   	push   %ebp
801025a4:	89 e5                	mov    %esp,%ebp
801025a6:	57                   	push   %edi
801025a7:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025a8:	8b 55 08             	mov    0x8(%ebp),%edx
801025ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025ae:	8b 45 10             	mov    0x10(%ebp),%eax
801025b1:	89 cb                	mov    %ecx,%ebx
801025b3:	89 df                	mov    %ebx,%edi
801025b5:	89 c1                	mov    %eax,%ecx
801025b7:	fc                   	cld    
801025b8:	f3 6d                	rep insl (%dx),%es:(%edi)
801025ba:	89 c8                	mov    %ecx,%eax
801025bc:	89 fb                	mov    %edi,%ebx
801025be:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025c1:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801025c4:	90                   	nop
801025c5:	5b                   	pop    %ebx
801025c6:	5f                   	pop    %edi
801025c7:	5d                   	pop    %ebp
801025c8:	c3                   	ret    

801025c9 <outb>:

static inline void
outb(ushort port, uchar data)
{
801025c9:	55                   	push   %ebp
801025ca:	89 e5                	mov    %esp,%ebp
801025cc:	83 ec 08             	sub    $0x8,%esp
801025cf:	8b 55 08             	mov    0x8(%ebp),%edx
801025d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801025d5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801025d9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025dc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025e0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025e4:	ee                   	out    %al,(%dx)
}
801025e5:	90                   	nop
801025e6:	c9                   	leave  
801025e7:	c3                   	ret    

801025e8 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801025e8:	55                   	push   %ebp
801025e9:	89 e5                	mov    %esp,%ebp
801025eb:	56                   	push   %esi
801025ec:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025ed:	8b 55 08             	mov    0x8(%ebp),%edx
801025f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025f3:	8b 45 10             	mov    0x10(%ebp),%eax
801025f6:	89 cb                	mov    %ecx,%ebx
801025f8:	89 de                	mov    %ebx,%esi
801025fa:	89 c1                	mov    %eax,%ecx
801025fc:	fc                   	cld    
801025fd:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025ff:	89 c8                	mov    %ecx,%eax
80102601:	89 f3                	mov    %esi,%ebx
80102603:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102606:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102609:	90                   	nop
8010260a:	5b                   	pop    %ebx
8010260b:	5e                   	pop    %esi
8010260c:	5d                   	pop    %ebp
8010260d:	c3                   	ret    

8010260e <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010260e:	55                   	push   %ebp
8010260f:	89 e5                	mov    %esp,%ebp
80102611:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102614:	90                   	nop
80102615:	68 f7 01 00 00       	push   $0x1f7
8010261a:	e8 67 ff ff ff       	call   80102586 <inb>
8010261f:	83 c4 04             	add    $0x4,%esp
80102622:	0f b6 c0             	movzbl %al,%eax
80102625:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102628:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010262b:	25 c0 00 00 00       	and    $0xc0,%eax
80102630:	83 f8 40             	cmp    $0x40,%eax
80102633:	75 e0                	jne    80102615 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102635:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102639:	74 11                	je     8010264c <idewait+0x3e>
8010263b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010263e:	83 e0 21             	and    $0x21,%eax
80102641:	85 c0                	test   %eax,%eax
80102643:	74 07                	je     8010264c <idewait+0x3e>
    return -1;
80102645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010264a:	eb 05                	jmp    80102651 <idewait+0x43>
  return 0;
8010264c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102651:	c9                   	leave  
80102652:	c3                   	ret    

80102653 <ideinit>:

void
ideinit(void)
{
80102653:	55                   	push   %ebp
80102654:	89 e5                	mov    %esp,%ebp
80102656:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102659:	83 ec 08             	sub    $0x8,%esp
8010265c:	68 52 8f 10 80       	push   $0x80108f52
80102661:	68 20 c6 10 80       	push   $0x8010c620
80102666:	e8 bc 30 00 00       	call   80105727 <initlock>
8010266b:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
8010266e:	83 ec 0c             	sub    $0xc,%esp
80102671:	6a 0e                	push   $0xe
80102673:	e8 da 18 00 00       	call   80103f52 <picenable>
80102678:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010267b:	a1 60 39 11 80       	mov    0x80113960,%eax
80102680:	83 e8 01             	sub    $0x1,%eax
80102683:	83 ec 08             	sub    $0x8,%esp
80102686:	50                   	push   %eax
80102687:	6a 0e                	push   $0xe
80102689:	e8 73 04 00 00       	call   80102b01 <ioapicenable>
8010268e:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102691:	83 ec 0c             	sub    $0xc,%esp
80102694:	6a 00                	push   $0x0
80102696:	e8 73 ff ff ff       	call   8010260e <idewait>
8010269b:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010269e:	83 ec 08             	sub    $0x8,%esp
801026a1:	68 f0 00 00 00       	push   $0xf0
801026a6:	68 f6 01 00 00       	push   $0x1f6
801026ab:	e8 19 ff ff ff       	call   801025c9 <outb>
801026b0:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801026b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026ba:	eb 24                	jmp    801026e0 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801026bc:	83 ec 0c             	sub    $0xc,%esp
801026bf:	68 f7 01 00 00       	push   $0x1f7
801026c4:	e8 bd fe ff ff       	call   80102586 <inb>
801026c9:	83 c4 10             	add    $0x10,%esp
801026cc:	84 c0                	test   %al,%al
801026ce:	74 0c                	je     801026dc <ideinit+0x89>
      havedisk1 = 1;
801026d0:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801026d7:	00 00 00 
      break;
801026da:	eb 0d                	jmp    801026e9 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801026dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026e0:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026e7:	7e d3                	jle    801026bc <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026e9:	83 ec 08             	sub    $0x8,%esp
801026ec:	68 e0 00 00 00       	push   $0xe0
801026f1:	68 f6 01 00 00       	push   $0x1f6
801026f6:	e8 ce fe ff ff       	call   801025c9 <outb>
801026fb:	83 c4 10             	add    $0x10,%esp
}
801026fe:	90                   	nop
801026ff:	c9                   	leave  
80102700:	c3                   	ret    

80102701 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102701:	55                   	push   %ebp
80102702:	89 e5                	mov    %esp,%ebp
80102704:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102707:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010270b:	75 0d                	jne    8010271a <idestart+0x19>
    panic("idestart");
8010270d:	83 ec 0c             	sub    $0xc,%esp
80102710:	68 56 8f 10 80       	push   $0x80108f56
80102715:	e8 4c de ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
8010271a:	8b 45 08             	mov    0x8(%ebp),%eax
8010271d:	8b 40 08             	mov    0x8(%eax),%eax
80102720:	3d cf 07 00 00       	cmp    $0x7cf,%eax
80102725:	76 0d                	jbe    80102734 <idestart+0x33>
    panic("incorrect blockno");
80102727:	83 ec 0c             	sub    $0xc,%esp
8010272a:	68 5f 8f 10 80       	push   $0x80108f5f
8010272f:	e8 32 de ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102734:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010273b:	8b 45 08             	mov    0x8(%ebp),%eax
8010273e:	8b 50 08             	mov    0x8(%eax),%edx
80102741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102744:	0f af c2             	imul   %edx,%eax
80102747:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
8010274a:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010274e:	7e 0d                	jle    8010275d <idestart+0x5c>
80102750:	83 ec 0c             	sub    $0xc,%esp
80102753:	68 56 8f 10 80       	push   $0x80108f56
80102758:	e8 09 de ff ff       	call   80100566 <panic>
  
  idewait(0);
8010275d:	83 ec 0c             	sub    $0xc,%esp
80102760:	6a 00                	push   $0x0
80102762:	e8 a7 fe ff ff       	call   8010260e <idewait>
80102767:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
8010276a:	83 ec 08             	sub    $0x8,%esp
8010276d:	6a 00                	push   $0x0
8010276f:	68 f6 03 00 00       	push   $0x3f6
80102774:	e8 50 fe ff ff       	call   801025c9 <outb>
80102779:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
8010277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277f:	0f b6 c0             	movzbl %al,%eax
80102782:	83 ec 08             	sub    $0x8,%esp
80102785:	50                   	push   %eax
80102786:	68 f2 01 00 00       	push   $0x1f2
8010278b:	e8 39 fe ff ff       	call   801025c9 <outb>
80102790:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102793:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102796:	0f b6 c0             	movzbl %al,%eax
80102799:	83 ec 08             	sub    $0x8,%esp
8010279c:	50                   	push   %eax
8010279d:	68 f3 01 00 00       	push   $0x1f3
801027a2:	e8 22 fe ff ff       	call   801025c9 <outb>
801027a7:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801027aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027ad:	c1 f8 08             	sar    $0x8,%eax
801027b0:	0f b6 c0             	movzbl %al,%eax
801027b3:	83 ec 08             	sub    $0x8,%esp
801027b6:	50                   	push   %eax
801027b7:	68 f4 01 00 00       	push   $0x1f4
801027bc:	e8 08 fe ff ff       	call   801025c9 <outb>
801027c1:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027c7:	c1 f8 10             	sar    $0x10,%eax
801027ca:	0f b6 c0             	movzbl %al,%eax
801027cd:	83 ec 08             	sub    $0x8,%esp
801027d0:	50                   	push   %eax
801027d1:	68 f5 01 00 00       	push   $0x1f5
801027d6:	e8 ee fd ff ff       	call   801025c9 <outb>
801027db:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027de:	8b 45 08             	mov    0x8(%ebp),%eax
801027e1:	8b 40 04             	mov    0x4(%eax),%eax
801027e4:	83 e0 01             	and    $0x1,%eax
801027e7:	c1 e0 04             	shl    $0x4,%eax
801027ea:	89 c2                	mov    %eax,%edx
801027ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027ef:	c1 f8 18             	sar    $0x18,%eax
801027f2:	83 e0 0f             	and    $0xf,%eax
801027f5:	09 d0                	or     %edx,%eax
801027f7:	83 c8 e0             	or     $0xffffffe0,%eax
801027fa:	0f b6 c0             	movzbl %al,%eax
801027fd:	83 ec 08             	sub    $0x8,%esp
80102800:	50                   	push   %eax
80102801:	68 f6 01 00 00       	push   $0x1f6
80102806:	e8 be fd ff ff       	call   801025c9 <outb>
8010280b:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010280e:	8b 45 08             	mov    0x8(%ebp),%eax
80102811:	8b 00                	mov    (%eax),%eax
80102813:	83 e0 04             	and    $0x4,%eax
80102816:	85 c0                	test   %eax,%eax
80102818:	74 30                	je     8010284a <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
8010281a:	83 ec 08             	sub    $0x8,%esp
8010281d:	6a 30                	push   $0x30
8010281f:	68 f7 01 00 00       	push   $0x1f7
80102824:	e8 a0 fd ff ff       	call   801025c9 <outb>
80102829:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010282c:	8b 45 08             	mov    0x8(%ebp),%eax
8010282f:	83 c0 18             	add    $0x18,%eax
80102832:	83 ec 04             	sub    $0x4,%esp
80102835:	68 80 00 00 00       	push   $0x80
8010283a:	50                   	push   %eax
8010283b:	68 f0 01 00 00       	push   $0x1f0
80102840:	e8 a3 fd ff ff       	call   801025e8 <outsl>
80102845:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102848:	eb 12                	jmp    8010285c <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
8010284a:	83 ec 08             	sub    $0x8,%esp
8010284d:	6a 20                	push   $0x20
8010284f:	68 f7 01 00 00       	push   $0x1f7
80102854:	e8 70 fd ff ff       	call   801025c9 <outb>
80102859:	83 c4 10             	add    $0x10,%esp
  }
}
8010285c:	90                   	nop
8010285d:	c9                   	leave  
8010285e:	c3                   	ret    

8010285f <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010285f:	55                   	push   %ebp
80102860:	89 e5                	mov    %esp,%ebp
80102862:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102865:	83 ec 0c             	sub    $0xc,%esp
80102868:	68 20 c6 10 80       	push   $0x8010c620
8010286d:	e8 d7 2e 00 00       	call   80105749 <acquire>
80102872:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102875:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010287a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010287d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102881:	75 15                	jne    80102898 <ideintr+0x39>
    release(&idelock);
80102883:	83 ec 0c             	sub    $0xc,%esp
80102886:	68 20 c6 10 80       	push   $0x8010c620
8010288b:	e8 20 2f 00 00       	call   801057b0 <release>
80102890:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102893:	e9 9a 00 00 00       	jmp    80102932 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010289b:	8b 40 14             	mov    0x14(%eax),%eax
8010289e:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a6:	8b 00                	mov    (%eax),%eax
801028a8:	83 e0 04             	and    $0x4,%eax
801028ab:	85 c0                	test   %eax,%eax
801028ad:	75 2d                	jne    801028dc <ideintr+0x7d>
801028af:	83 ec 0c             	sub    $0xc,%esp
801028b2:	6a 01                	push   $0x1
801028b4:	e8 55 fd ff ff       	call   8010260e <idewait>
801028b9:	83 c4 10             	add    $0x10,%esp
801028bc:	85 c0                	test   %eax,%eax
801028be:	78 1c                	js     801028dc <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c3:	83 c0 18             	add    $0x18,%eax
801028c6:	83 ec 04             	sub    $0x4,%esp
801028c9:	68 80 00 00 00       	push   $0x80
801028ce:	50                   	push   %eax
801028cf:	68 f0 01 00 00       	push   $0x1f0
801028d4:	e8 ca fc ff ff       	call   801025a3 <insl>
801028d9:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028df:	8b 00                	mov    (%eax),%eax
801028e1:	83 c8 02             	or     $0x2,%eax
801028e4:	89 c2                	mov    %eax,%edx
801028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028e9:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ee:	8b 00                	mov    (%eax),%eax
801028f0:	83 e0 fb             	and    $0xfffffffb,%eax
801028f3:	89 c2                	mov    %eax,%edx
801028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f8:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801028fa:	83 ec 0c             	sub    $0xc,%esp
801028fd:	ff 75 f4             	pushl  -0xc(%ebp)
80102900:	e8 35 28 00 00       	call   8010513a <wakeup>
80102905:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102908:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010290d:	85 c0                	test   %eax,%eax
8010290f:	74 11                	je     80102922 <ideintr+0xc3>
    idestart(idequeue);
80102911:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102916:	83 ec 0c             	sub    $0xc,%esp
80102919:	50                   	push   %eax
8010291a:	e8 e2 fd ff ff       	call   80102701 <idestart>
8010291f:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102922:	83 ec 0c             	sub    $0xc,%esp
80102925:	68 20 c6 10 80       	push   $0x8010c620
8010292a:	e8 81 2e 00 00       	call   801057b0 <release>
8010292f:	83 c4 10             	add    $0x10,%esp
}
80102932:	c9                   	leave  
80102933:	c3                   	ret    

80102934 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102934:	55                   	push   %ebp
80102935:	89 e5                	mov    %esp,%ebp
80102937:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010293a:	8b 45 08             	mov    0x8(%ebp),%eax
8010293d:	8b 00                	mov    (%eax),%eax
8010293f:	83 e0 01             	and    $0x1,%eax
80102942:	85 c0                	test   %eax,%eax
80102944:	75 0d                	jne    80102953 <iderw+0x1f>
    panic("iderw: buf not busy");
80102946:	83 ec 0c             	sub    $0xc,%esp
80102949:	68 71 8f 10 80       	push   $0x80108f71
8010294e:	e8 13 dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102953:	8b 45 08             	mov    0x8(%ebp),%eax
80102956:	8b 00                	mov    (%eax),%eax
80102958:	83 e0 06             	and    $0x6,%eax
8010295b:	83 f8 02             	cmp    $0x2,%eax
8010295e:	75 0d                	jne    8010296d <iderw+0x39>
    panic("iderw: nothing to do");
80102960:	83 ec 0c             	sub    $0xc,%esp
80102963:	68 85 8f 10 80       	push   $0x80108f85
80102968:	e8 f9 db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
8010296d:	8b 45 08             	mov    0x8(%ebp),%eax
80102970:	8b 40 04             	mov    0x4(%eax),%eax
80102973:	85 c0                	test   %eax,%eax
80102975:	74 16                	je     8010298d <iderw+0x59>
80102977:	a1 58 c6 10 80       	mov    0x8010c658,%eax
8010297c:	85 c0                	test   %eax,%eax
8010297e:	75 0d                	jne    8010298d <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102980:	83 ec 0c             	sub    $0xc,%esp
80102983:	68 9a 8f 10 80       	push   $0x80108f9a
80102988:	e8 d9 db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010298d:	83 ec 0c             	sub    $0xc,%esp
80102990:	68 20 c6 10 80       	push   $0x8010c620
80102995:	e8 af 2d 00 00       	call   80105749 <acquire>
8010299a:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
8010299d:	8b 45 08             	mov    0x8(%ebp),%eax
801029a0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029a7:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801029ae:	eb 0b                	jmp    801029bb <iderw+0x87>
801029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029b3:	8b 00                	mov    (%eax),%eax
801029b5:	83 c0 14             	add    $0x14,%eax
801029b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029be:	8b 00                	mov    (%eax),%eax
801029c0:	85 c0                	test   %eax,%eax
801029c2:	75 ec                	jne    801029b0 <iderw+0x7c>
    ;
  *pp = b;
801029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029c7:	8b 55 08             	mov    0x8(%ebp),%edx
801029ca:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801029cc:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801029d1:	3b 45 08             	cmp    0x8(%ebp),%eax
801029d4:	75 23                	jne    801029f9 <iderw+0xc5>
    idestart(b);
801029d6:	83 ec 0c             	sub    $0xc,%esp
801029d9:	ff 75 08             	pushl  0x8(%ebp)
801029dc:	e8 20 fd ff ff       	call   80102701 <idestart>
801029e1:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029e4:	eb 13                	jmp    801029f9 <iderw+0xc5>
    sleep(b, &idelock);
801029e6:	83 ec 08             	sub    $0x8,%esp
801029e9:	68 20 c6 10 80       	push   $0x8010c620
801029ee:	ff 75 08             	pushl  0x8(%ebp)
801029f1:	e8 5d 26 00 00       	call   80105053 <sleep>
801029f6:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029f9:	8b 45 08             	mov    0x8(%ebp),%eax
801029fc:	8b 00                	mov    (%eax),%eax
801029fe:	83 e0 06             	and    $0x6,%eax
80102a01:	83 f8 02             	cmp    $0x2,%eax
80102a04:	75 e0                	jne    801029e6 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a06:	83 ec 0c             	sub    $0xc,%esp
80102a09:	68 20 c6 10 80       	push   $0x8010c620
80102a0e:	e8 9d 2d 00 00       	call   801057b0 <release>
80102a13:	83 c4 10             	add    $0x10,%esp
}
80102a16:	90                   	nop
80102a17:	c9                   	leave  
80102a18:	c3                   	ret    

80102a19 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a19:	55                   	push   %ebp
80102a1a:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a1c:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a21:	8b 55 08             	mov    0x8(%ebp),%edx
80102a24:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a26:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a2b:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a2e:	5d                   	pop    %ebp
80102a2f:	c3                   	ret    

80102a30 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a33:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a38:	8b 55 08             	mov    0x8(%ebp),%edx
80102a3b:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a3d:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a42:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a45:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a48:	90                   	nop
80102a49:	5d                   	pop    %ebp
80102a4a:	c3                   	ret    

80102a4b <ioapicinit>:

void
ioapicinit(void)
{
80102a4b:	55                   	push   %ebp
80102a4c:	89 e5                	mov    %esp,%ebp
80102a4e:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102a51:	a1 64 33 11 80       	mov    0x80113364,%eax
80102a56:	85 c0                	test   %eax,%eax
80102a58:	0f 84 a0 00 00 00    	je     80102afe <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a5e:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
80102a65:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a68:	6a 01                	push   $0x1
80102a6a:	e8 aa ff ff ff       	call   80102a19 <ioapicread>
80102a6f:	83 c4 04             	add    $0x4,%esp
80102a72:	c1 e8 10             	shr    $0x10,%eax
80102a75:	25 ff 00 00 00       	and    $0xff,%eax
80102a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a7d:	6a 00                	push   $0x0
80102a7f:	e8 95 ff ff ff       	call   80102a19 <ioapicread>
80102a84:	83 c4 04             	add    $0x4,%esp
80102a87:	c1 e8 18             	shr    $0x18,%eax
80102a8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a8d:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
80102a94:	0f b6 c0             	movzbl %al,%eax
80102a97:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a9a:	74 10                	je     80102aac <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a9c:	83 ec 0c             	sub    $0xc,%esp
80102a9f:	68 b8 8f 10 80       	push   $0x80108fb8
80102aa4:	e8 1d d9 ff ff       	call   801003c6 <cprintf>
80102aa9:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102aac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ab3:	eb 3f                	jmp    80102af4 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab8:	83 c0 20             	add    $0x20,%eax
80102abb:	0d 00 00 01 00       	or     $0x10000,%eax
80102ac0:	89 c2                	mov    %eax,%edx
80102ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac5:	83 c0 08             	add    $0x8,%eax
80102ac8:	01 c0                	add    %eax,%eax
80102aca:	83 ec 08             	sub    $0x8,%esp
80102acd:	52                   	push   %edx
80102ace:	50                   	push   %eax
80102acf:	e8 5c ff ff ff       	call   80102a30 <ioapicwrite>
80102ad4:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ada:	83 c0 08             	add    $0x8,%eax
80102add:	01 c0                	add    %eax,%eax
80102adf:	83 c0 01             	add    $0x1,%eax
80102ae2:	83 ec 08             	sub    $0x8,%esp
80102ae5:	6a 00                	push   $0x0
80102ae7:	50                   	push   %eax
80102ae8:	e8 43 ff ff ff       	call   80102a30 <ioapicwrite>
80102aed:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102af0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102af7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102afa:	7e b9                	jle    80102ab5 <ioapicinit+0x6a>
80102afc:	eb 01                	jmp    80102aff <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102afe:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102aff:	c9                   	leave  
80102b00:	c3                   	ret    

80102b01 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b01:	55                   	push   %ebp
80102b02:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b04:	a1 64 33 11 80       	mov    0x80113364,%eax
80102b09:	85 c0                	test   %eax,%eax
80102b0b:	74 39                	je     80102b46 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b0d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b10:	83 c0 20             	add    $0x20,%eax
80102b13:	89 c2                	mov    %eax,%edx
80102b15:	8b 45 08             	mov    0x8(%ebp),%eax
80102b18:	83 c0 08             	add    $0x8,%eax
80102b1b:	01 c0                	add    %eax,%eax
80102b1d:	52                   	push   %edx
80102b1e:	50                   	push   %eax
80102b1f:	e8 0c ff ff ff       	call   80102a30 <ioapicwrite>
80102b24:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b27:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b2a:	c1 e0 18             	shl    $0x18,%eax
80102b2d:	89 c2                	mov    %eax,%edx
80102b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b32:	83 c0 08             	add    $0x8,%eax
80102b35:	01 c0                	add    %eax,%eax
80102b37:	83 c0 01             	add    $0x1,%eax
80102b3a:	52                   	push   %edx
80102b3b:	50                   	push   %eax
80102b3c:	e8 ef fe ff ff       	call   80102a30 <ioapicwrite>
80102b41:	83 c4 08             	add    $0x8,%esp
80102b44:	eb 01                	jmp    80102b47 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102b46:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102b47:	c9                   	leave  
80102b48:	c3                   	ret    

80102b49 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102b49:	55                   	push   %ebp
80102b4a:	89 e5                	mov    %esp,%ebp
80102b4c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4f:	05 00 00 00 80       	add    $0x80000000,%eax
80102b54:	5d                   	pop    %ebp
80102b55:	c3                   	ret    

80102b56 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b56:	55                   	push   %ebp
80102b57:	89 e5                	mov    %esp,%ebp
80102b59:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b5c:	83 ec 08             	sub    $0x8,%esp
80102b5f:	68 ea 8f 10 80       	push   $0x80108fea
80102b64:	68 40 32 11 80       	push   $0x80113240
80102b69:	e8 b9 2b 00 00       	call   80105727 <initlock>
80102b6e:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b71:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102b78:	00 00 00 
  freerange(vstart, vend);
80102b7b:	83 ec 08             	sub    $0x8,%esp
80102b7e:	ff 75 0c             	pushl  0xc(%ebp)
80102b81:	ff 75 08             	pushl  0x8(%ebp)
80102b84:	e8 2a 00 00 00       	call   80102bb3 <freerange>
80102b89:	83 c4 10             	add    $0x10,%esp
}
80102b8c:	90                   	nop
80102b8d:	c9                   	leave  
80102b8e:	c3                   	ret    

80102b8f <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b8f:	55                   	push   %ebp
80102b90:	89 e5                	mov    %esp,%ebp
80102b92:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b95:	83 ec 08             	sub    $0x8,%esp
80102b98:	ff 75 0c             	pushl  0xc(%ebp)
80102b9b:	ff 75 08             	pushl  0x8(%ebp)
80102b9e:	e8 10 00 00 00       	call   80102bb3 <freerange>
80102ba3:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102ba6:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102bad:	00 00 00 
}
80102bb0:	90                   	nop
80102bb1:	c9                   	leave  
80102bb2:	c3                   	ret    

80102bb3 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102bb3:	55                   	push   %ebp
80102bb4:	89 e5                	mov    %esp,%ebp
80102bb6:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80102bbc:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bc9:	eb 15                	jmp    80102be0 <freerange+0x2d>
    kfree(p);
80102bcb:	83 ec 0c             	sub    $0xc,%esp
80102bce:	ff 75 f4             	pushl  -0xc(%ebp)
80102bd1:	e8 1a 00 00 00       	call   80102bf0 <kfree>
80102bd6:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102be3:	05 00 10 00 00       	add    $0x1000,%eax
80102be8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102beb:	76 de                	jbe    80102bcb <freerange+0x18>
    kfree(p);
}
80102bed:	90                   	nop
80102bee:	c9                   	leave  
80102bef:	c3                   	ret    

80102bf0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf9:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bfe:	85 c0                	test   %eax,%eax
80102c00:	75 1b                	jne    80102c1d <kfree+0x2d>
80102c02:	81 7d 08 3c 67 11 80 	cmpl   $0x8011673c,0x8(%ebp)
80102c09:	72 12                	jb     80102c1d <kfree+0x2d>
80102c0b:	ff 75 08             	pushl  0x8(%ebp)
80102c0e:	e8 36 ff ff ff       	call   80102b49 <v2p>
80102c13:	83 c4 04             	add    $0x4,%esp
80102c16:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c1b:	76 0d                	jbe    80102c2a <kfree+0x3a>
    panic("kfree");
80102c1d:	83 ec 0c             	sub    $0xc,%esp
80102c20:	68 ef 8f 10 80       	push   $0x80108fef
80102c25:	e8 3c d9 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c2a:	83 ec 04             	sub    $0x4,%esp
80102c2d:	68 00 10 00 00       	push   $0x1000
80102c32:	6a 01                	push   $0x1
80102c34:	ff 75 08             	pushl  0x8(%ebp)
80102c37:	e8 70 2d 00 00       	call   801059ac <memset>
80102c3c:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c3f:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c44:	85 c0                	test   %eax,%eax
80102c46:	74 10                	je     80102c58 <kfree+0x68>
    acquire(&kmem.lock);
80102c48:	83 ec 0c             	sub    $0xc,%esp
80102c4b:	68 40 32 11 80       	push   $0x80113240
80102c50:	e8 f4 2a 00 00       	call   80105749 <acquire>
80102c55:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c58:	8b 45 08             	mov    0x8(%ebp),%eax
80102c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c5e:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c67:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6c:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102c71:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c76:	85 c0                	test   %eax,%eax
80102c78:	74 10                	je     80102c8a <kfree+0x9a>
    release(&kmem.lock);
80102c7a:	83 ec 0c             	sub    $0xc,%esp
80102c7d:	68 40 32 11 80       	push   $0x80113240
80102c82:	e8 29 2b 00 00       	call   801057b0 <release>
80102c87:	83 c4 10             	add    $0x10,%esp
}
80102c8a:	90                   	nop
80102c8b:	c9                   	leave  
80102c8c:	c3                   	ret    

80102c8d <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c8d:	55                   	push   %ebp
80102c8e:	89 e5                	mov    %esp,%ebp
80102c90:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c93:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c98:	85 c0                	test   %eax,%eax
80102c9a:	74 10                	je     80102cac <kalloc+0x1f>
    acquire(&kmem.lock);
80102c9c:	83 ec 0c             	sub    $0xc,%esp
80102c9f:	68 40 32 11 80       	push   $0x80113240
80102ca4:	e8 a0 2a 00 00       	call   80105749 <acquire>
80102ca9:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102cac:	a1 78 32 11 80       	mov    0x80113278,%eax
80102cb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102cb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102cb8:	74 0a                	je     80102cc4 <kalloc+0x37>
    kmem.freelist = r->next;
80102cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cbd:	8b 00                	mov    (%eax),%eax
80102cbf:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102cc4:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cc9:	85 c0                	test   %eax,%eax
80102ccb:	74 10                	je     80102cdd <kalloc+0x50>
    release(&kmem.lock);
80102ccd:	83 ec 0c             	sub    $0xc,%esp
80102cd0:	68 40 32 11 80       	push   $0x80113240
80102cd5:	e8 d6 2a 00 00       	call   801057b0 <release>
80102cda:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102ce0:	c9                   	leave  
80102ce1:	c3                   	ret    

80102ce2 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102ce2:	55                   	push   %ebp
80102ce3:	89 e5                	mov    %esp,%ebp
80102ce5:	83 ec 14             	sub    $0x14,%esp
80102ce8:	8b 45 08             	mov    0x8(%ebp),%eax
80102ceb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cef:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cf3:	89 c2                	mov    %eax,%edx
80102cf5:	ec                   	in     (%dx),%al
80102cf6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cf9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102cfd:	c9                   	leave  
80102cfe:	c3                   	ret    

80102cff <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cff:	55                   	push   %ebp
80102d00:	89 e5                	mov    %esp,%ebp
80102d02:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d05:	6a 64                	push   $0x64
80102d07:	e8 d6 ff ff ff       	call   80102ce2 <inb>
80102d0c:	83 c4 04             	add    $0x4,%esp
80102d0f:	0f b6 c0             	movzbl %al,%eax
80102d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d18:	83 e0 01             	and    $0x1,%eax
80102d1b:	85 c0                	test   %eax,%eax
80102d1d:	75 0a                	jne    80102d29 <kbdgetc+0x2a>
    return -1;
80102d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d24:	e9 23 01 00 00       	jmp    80102e4c <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d29:	6a 60                	push   $0x60
80102d2b:	e8 b2 ff ff ff       	call   80102ce2 <inb>
80102d30:	83 c4 04             	add    $0x4,%esp
80102d33:	0f b6 c0             	movzbl %al,%eax
80102d36:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d39:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d40:	75 17                	jne    80102d59 <kbdgetc+0x5a>
    shift |= E0ESC;
80102d42:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d47:	83 c8 40             	or     $0x40,%eax
80102d4a:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102d4f:	b8 00 00 00 00       	mov    $0x0,%eax
80102d54:	e9 f3 00 00 00       	jmp    80102e4c <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d59:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d5c:	25 80 00 00 00       	and    $0x80,%eax
80102d61:	85 c0                	test   %eax,%eax
80102d63:	74 45                	je     80102daa <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d65:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d6a:	83 e0 40             	and    $0x40,%eax
80102d6d:	85 c0                	test   %eax,%eax
80102d6f:	75 08                	jne    80102d79 <kbdgetc+0x7a>
80102d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d74:	83 e0 7f             	and    $0x7f,%eax
80102d77:	eb 03                	jmp    80102d7c <kbdgetc+0x7d>
80102d79:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d82:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d87:	0f b6 00             	movzbl (%eax),%eax
80102d8a:	83 c8 40             	or     $0x40,%eax
80102d8d:	0f b6 c0             	movzbl %al,%eax
80102d90:	f7 d0                	not    %eax
80102d92:	89 c2                	mov    %eax,%edx
80102d94:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d99:	21 d0                	and    %edx,%eax
80102d9b:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102da0:	b8 00 00 00 00       	mov    $0x0,%eax
80102da5:	e9 a2 00 00 00       	jmp    80102e4c <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102daa:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102daf:	83 e0 40             	and    $0x40,%eax
80102db2:	85 c0                	test   %eax,%eax
80102db4:	74 14                	je     80102dca <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102db6:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102dbd:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dc2:	83 e0 bf             	and    $0xffffffbf,%eax
80102dc5:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dcd:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102dd2:	0f b6 00             	movzbl (%eax),%eax
80102dd5:	0f b6 d0             	movzbl %al,%edx
80102dd8:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ddd:	09 d0                	or     %edx,%eax
80102ddf:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102de7:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102dec:	0f b6 00             	movzbl (%eax),%eax
80102def:	0f b6 d0             	movzbl %al,%edx
80102df2:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102df7:	31 d0                	xor    %edx,%eax
80102df9:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102dfe:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e03:	83 e0 03             	and    $0x3,%eax
80102e06:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e10:	01 d0                	add    %edx,%eax
80102e12:	0f b6 00             	movzbl (%eax),%eax
80102e15:	0f b6 c0             	movzbl %al,%eax
80102e18:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e1b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e20:	83 e0 08             	and    $0x8,%eax
80102e23:	85 c0                	test   %eax,%eax
80102e25:	74 22                	je     80102e49 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e27:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e2b:	76 0c                	jbe    80102e39 <kbdgetc+0x13a>
80102e2d:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e31:	77 06                	ja     80102e39 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e33:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e37:	eb 10                	jmp    80102e49 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e39:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e3d:	76 0a                	jbe    80102e49 <kbdgetc+0x14a>
80102e3f:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e43:	77 04                	ja     80102e49 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e45:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e49:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e4c:	c9                   	leave  
80102e4d:	c3                   	ret    

80102e4e <kbdintr>:

void
kbdintr(void)
{
80102e4e:	55                   	push   %ebp
80102e4f:	89 e5                	mov    %esp,%ebp
80102e51:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e54:	83 ec 0c             	sub    $0xc,%esp
80102e57:	68 ff 2c 10 80       	push   $0x80102cff
80102e5c:	e8 98 d9 ff ff       	call   801007f9 <consoleintr>
80102e61:	83 c4 10             	add    $0x10,%esp
}
80102e64:	90                   	nop
80102e65:	c9                   	leave  
80102e66:	c3                   	ret    

80102e67 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102e67:	55                   	push   %ebp
80102e68:	89 e5                	mov    %esp,%ebp
80102e6a:	83 ec 14             	sub    $0x14,%esp
80102e6d:	8b 45 08             	mov    0x8(%ebp),%eax
80102e70:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e74:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e78:	89 c2                	mov    %eax,%edx
80102e7a:	ec                   	in     (%dx),%al
80102e7b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e7e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e82:	c9                   	leave  
80102e83:	c3                   	ret    

80102e84 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e84:	55                   	push   %ebp
80102e85:	89 e5                	mov    %esp,%ebp
80102e87:	83 ec 08             	sub    $0x8,%esp
80102e8a:	8b 55 08             	mov    0x8(%ebp),%edx
80102e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e90:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e94:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e97:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e9b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e9f:	ee                   	out    %al,(%dx)
}
80102ea0:	90                   	nop
80102ea1:	c9                   	leave  
80102ea2:	c3                   	ret    

80102ea3 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102ea3:	55                   	push   %ebp
80102ea4:	89 e5                	mov    %esp,%ebp
80102ea6:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102ea9:	9c                   	pushf  
80102eaa:	58                   	pop    %eax
80102eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102eb1:	c9                   	leave  
80102eb2:	c3                   	ret    

80102eb3 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102eb3:	55                   	push   %ebp
80102eb4:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102eb6:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ebb:	8b 55 08             	mov    0x8(%ebp),%edx
80102ebe:	c1 e2 02             	shl    $0x2,%edx
80102ec1:	01 c2                	add    %eax,%edx
80102ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ec6:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ec8:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ecd:	83 c0 20             	add    $0x20,%eax
80102ed0:	8b 00                	mov    (%eax),%eax
}
80102ed2:	90                   	nop
80102ed3:	5d                   	pop    %ebp
80102ed4:	c3                   	ret    

80102ed5 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102ed5:	55                   	push   %ebp
80102ed6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102ed8:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102edd:	85 c0                	test   %eax,%eax
80102edf:	0f 84 0b 01 00 00    	je     80102ff0 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102ee5:	68 3f 01 00 00       	push   $0x13f
80102eea:	6a 3c                	push   $0x3c
80102eec:	e8 c2 ff ff ff       	call   80102eb3 <lapicw>
80102ef1:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ef4:	6a 0b                	push   $0xb
80102ef6:	68 f8 00 00 00       	push   $0xf8
80102efb:	e8 b3 ff ff ff       	call   80102eb3 <lapicw>
80102f00:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f03:	68 20 00 02 00       	push   $0x20020
80102f08:	68 c8 00 00 00       	push   $0xc8
80102f0d:	e8 a1 ff ff ff       	call   80102eb3 <lapicw>
80102f12:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102f15:	68 80 96 98 00       	push   $0x989680
80102f1a:	68 e0 00 00 00       	push   $0xe0
80102f1f:	e8 8f ff ff ff       	call   80102eb3 <lapicw>
80102f24:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f27:	68 00 00 01 00       	push   $0x10000
80102f2c:	68 d4 00 00 00       	push   $0xd4
80102f31:	e8 7d ff ff ff       	call   80102eb3 <lapicw>
80102f36:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f39:	68 00 00 01 00       	push   $0x10000
80102f3e:	68 d8 00 00 00       	push   $0xd8
80102f43:	e8 6b ff ff ff       	call   80102eb3 <lapicw>
80102f48:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f4b:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f50:	83 c0 30             	add    $0x30,%eax
80102f53:	8b 00                	mov    (%eax),%eax
80102f55:	c1 e8 10             	shr    $0x10,%eax
80102f58:	0f b6 c0             	movzbl %al,%eax
80102f5b:	83 f8 03             	cmp    $0x3,%eax
80102f5e:	76 12                	jbe    80102f72 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102f60:	68 00 00 01 00       	push   $0x10000
80102f65:	68 d0 00 00 00       	push   $0xd0
80102f6a:	e8 44 ff ff ff       	call   80102eb3 <lapicw>
80102f6f:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f72:	6a 33                	push   $0x33
80102f74:	68 dc 00 00 00       	push   $0xdc
80102f79:	e8 35 ff ff ff       	call   80102eb3 <lapicw>
80102f7e:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f81:	6a 00                	push   $0x0
80102f83:	68 a0 00 00 00       	push   $0xa0
80102f88:	e8 26 ff ff ff       	call   80102eb3 <lapicw>
80102f8d:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f90:	6a 00                	push   $0x0
80102f92:	68 a0 00 00 00       	push   $0xa0
80102f97:	e8 17 ff ff ff       	call   80102eb3 <lapicw>
80102f9c:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f9f:	6a 00                	push   $0x0
80102fa1:	6a 2c                	push   $0x2c
80102fa3:	e8 0b ff ff ff       	call   80102eb3 <lapicw>
80102fa8:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102fab:	6a 00                	push   $0x0
80102fad:	68 c4 00 00 00       	push   $0xc4
80102fb2:	e8 fc fe ff ff       	call   80102eb3 <lapicw>
80102fb7:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102fba:	68 00 85 08 00       	push   $0x88500
80102fbf:	68 c0 00 00 00       	push   $0xc0
80102fc4:	e8 ea fe ff ff       	call   80102eb3 <lapicw>
80102fc9:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102fcc:	90                   	nop
80102fcd:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102fd2:	05 00 03 00 00       	add    $0x300,%eax
80102fd7:	8b 00                	mov    (%eax),%eax
80102fd9:	25 00 10 00 00       	and    $0x1000,%eax
80102fde:	85 c0                	test   %eax,%eax
80102fe0:	75 eb                	jne    80102fcd <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fe2:	6a 00                	push   $0x0
80102fe4:	6a 20                	push   $0x20
80102fe6:	e8 c8 fe ff ff       	call   80102eb3 <lapicw>
80102feb:	83 c4 08             	add    $0x8,%esp
80102fee:	eb 01                	jmp    80102ff1 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102ff0:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ff1:	c9                   	leave  
80102ff2:	c3                   	ret    

80102ff3 <cpunum>:

int
cpunum(void)
{
80102ff3:	55                   	push   %ebp
80102ff4:	89 e5                	mov    %esp,%ebp
80102ff6:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102ff9:	e8 a5 fe ff ff       	call   80102ea3 <readeflags>
80102ffe:	25 00 02 00 00       	and    $0x200,%eax
80103003:	85 c0                	test   %eax,%eax
80103005:	74 26                	je     8010302d <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80103007:	a1 60 c6 10 80       	mov    0x8010c660,%eax
8010300c:	8d 50 01             	lea    0x1(%eax),%edx
8010300f:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80103015:	85 c0                	test   %eax,%eax
80103017:	75 14                	jne    8010302d <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103019:	8b 45 04             	mov    0x4(%ebp),%eax
8010301c:	83 ec 08             	sub    $0x8,%esp
8010301f:	50                   	push   %eax
80103020:	68 f8 8f 10 80       	push   $0x80108ff8
80103025:	e8 9c d3 ff ff       	call   801003c6 <cprintf>
8010302a:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
8010302d:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80103032:	85 c0                	test   %eax,%eax
80103034:	74 0f                	je     80103045 <cpunum+0x52>
    return lapic[ID]>>24;
80103036:	a1 7c 32 11 80       	mov    0x8011327c,%eax
8010303b:	83 c0 20             	add    $0x20,%eax
8010303e:	8b 00                	mov    (%eax),%eax
80103040:	c1 e8 18             	shr    $0x18,%eax
80103043:	eb 05                	jmp    8010304a <cpunum+0x57>
  return 0;
80103045:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010304a:	c9                   	leave  
8010304b:	c3                   	ret    

8010304c <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010304c:	55                   	push   %ebp
8010304d:	89 e5                	mov    %esp,%ebp
  if(lapic)
8010304f:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80103054:	85 c0                	test   %eax,%eax
80103056:	74 0c                	je     80103064 <lapiceoi+0x18>
    lapicw(EOI, 0);
80103058:	6a 00                	push   $0x0
8010305a:	6a 2c                	push   $0x2c
8010305c:	e8 52 fe ff ff       	call   80102eb3 <lapicw>
80103061:	83 c4 08             	add    $0x8,%esp
}
80103064:	90                   	nop
80103065:	c9                   	leave  
80103066:	c3                   	ret    

80103067 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103067:	55                   	push   %ebp
80103068:	89 e5                	mov    %esp,%ebp
}
8010306a:	90                   	nop
8010306b:	5d                   	pop    %ebp
8010306c:	c3                   	ret    

8010306d <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010306d:	55                   	push   %ebp
8010306e:	89 e5                	mov    %esp,%ebp
80103070:	83 ec 14             	sub    $0x14,%esp
80103073:	8b 45 08             	mov    0x8(%ebp),%eax
80103076:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103079:	6a 0f                	push   $0xf
8010307b:	6a 70                	push   $0x70
8010307d:	e8 02 fe ff ff       	call   80102e84 <outb>
80103082:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103085:	6a 0a                	push   $0xa
80103087:	6a 71                	push   $0x71
80103089:	e8 f6 fd ff ff       	call   80102e84 <outb>
8010308e:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103091:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103098:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010309b:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801030a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030a3:	83 c0 02             	add    $0x2,%eax
801030a6:	8b 55 0c             	mov    0xc(%ebp),%edx
801030a9:	c1 ea 04             	shr    $0x4,%edx
801030ac:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801030af:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030b3:	c1 e0 18             	shl    $0x18,%eax
801030b6:	50                   	push   %eax
801030b7:	68 c4 00 00 00       	push   $0xc4
801030bc:	e8 f2 fd ff ff       	call   80102eb3 <lapicw>
801030c1:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801030c4:	68 00 c5 00 00       	push   $0xc500
801030c9:	68 c0 00 00 00       	push   $0xc0
801030ce:	e8 e0 fd ff ff       	call   80102eb3 <lapicw>
801030d3:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030d6:	68 c8 00 00 00       	push   $0xc8
801030db:	e8 87 ff ff ff       	call   80103067 <microdelay>
801030e0:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801030e3:	68 00 85 00 00       	push   $0x8500
801030e8:	68 c0 00 00 00       	push   $0xc0
801030ed:	e8 c1 fd ff ff       	call   80102eb3 <lapicw>
801030f2:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030f5:	6a 64                	push   $0x64
801030f7:	e8 6b ff ff ff       	call   80103067 <microdelay>
801030fc:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103106:	eb 3d                	jmp    80103145 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103108:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010310c:	c1 e0 18             	shl    $0x18,%eax
8010310f:	50                   	push   %eax
80103110:	68 c4 00 00 00       	push   $0xc4
80103115:	e8 99 fd ff ff       	call   80102eb3 <lapicw>
8010311a:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010311d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103120:	c1 e8 0c             	shr    $0xc,%eax
80103123:	80 cc 06             	or     $0x6,%ah
80103126:	50                   	push   %eax
80103127:	68 c0 00 00 00       	push   $0xc0
8010312c:	e8 82 fd ff ff       	call   80102eb3 <lapicw>
80103131:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103134:	68 c8 00 00 00       	push   $0xc8
80103139:	e8 29 ff ff ff       	call   80103067 <microdelay>
8010313e:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103141:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103145:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103149:	7e bd                	jle    80103108 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010314b:	90                   	nop
8010314c:	c9                   	leave  
8010314d:	c3                   	ret    

8010314e <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010314e:	55                   	push   %ebp
8010314f:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103151:	8b 45 08             	mov    0x8(%ebp),%eax
80103154:	0f b6 c0             	movzbl %al,%eax
80103157:	50                   	push   %eax
80103158:	6a 70                	push   $0x70
8010315a:	e8 25 fd ff ff       	call   80102e84 <outb>
8010315f:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103162:	68 c8 00 00 00       	push   $0xc8
80103167:	e8 fb fe ff ff       	call   80103067 <microdelay>
8010316c:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010316f:	6a 71                	push   $0x71
80103171:	e8 f1 fc ff ff       	call   80102e67 <inb>
80103176:	83 c4 04             	add    $0x4,%esp
80103179:	0f b6 c0             	movzbl %al,%eax
}
8010317c:	c9                   	leave  
8010317d:	c3                   	ret    

8010317e <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010317e:	55                   	push   %ebp
8010317f:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103181:	6a 00                	push   $0x0
80103183:	e8 c6 ff ff ff       	call   8010314e <cmos_read>
80103188:	83 c4 04             	add    $0x4,%esp
8010318b:	89 c2                	mov    %eax,%edx
8010318d:	8b 45 08             	mov    0x8(%ebp),%eax
80103190:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103192:	6a 02                	push   $0x2
80103194:	e8 b5 ff ff ff       	call   8010314e <cmos_read>
80103199:	83 c4 04             	add    $0x4,%esp
8010319c:	89 c2                	mov    %eax,%edx
8010319e:	8b 45 08             	mov    0x8(%ebp),%eax
801031a1:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801031a4:	6a 04                	push   $0x4
801031a6:	e8 a3 ff ff ff       	call   8010314e <cmos_read>
801031ab:	83 c4 04             	add    $0x4,%esp
801031ae:	89 c2                	mov    %eax,%edx
801031b0:	8b 45 08             	mov    0x8(%ebp),%eax
801031b3:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801031b6:	6a 07                	push   $0x7
801031b8:	e8 91 ff ff ff       	call   8010314e <cmos_read>
801031bd:	83 c4 04             	add    $0x4,%esp
801031c0:	89 c2                	mov    %eax,%edx
801031c2:	8b 45 08             	mov    0x8(%ebp),%eax
801031c5:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801031c8:	6a 08                	push   $0x8
801031ca:	e8 7f ff ff ff       	call   8010314e <cmos_read>
801031cf:	83 c4 04             	add    $0x4,%esp
801031d2:	89 c2                	mov    %eax,%edx
801031d4:	8b 45 08             	mov    0x8(%ebp),%eax
801031d7:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801031da:	6a 09                	push   $0x9
801031dc:	e8 6d ff ff ff       	call   8010314e <cmos_read>
801031e1:	83 c4 04             	add    $0x4,%esp
801031e4:	89 c2                	mov    %eax,%edx
801031e6:	8b 45 08             	mov    0x8(%ebp),%eax
801031e9:	89 50 14             	mov    %edx,0x14(%eax)
}
801031ec:	90                   	nop
801031ed:	c9                   	leave  
801031ee:	c3                   	ret    

801031ef <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801031ef:	55                   	push   %ebp
801031f0:	89 e5                	mov    %esp,%ebp
801031f2:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031f5:	6a 0b                	push   $0xb
801031f7:	e8 52 ff ff ff       	call   8010314e <cmos_read>
801031fc:	83 c4 04             	add    $0x4,%esp
801031ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103205:	83 e0 04             	and    $0x4,%eax
80103208:	85 c0                	test   %eax,%eax
8010320a:	0f 94 c0             	sete   %al
8010320d:	0f b6 c0             	movzbl %al,%eax
80103210:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103213:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103216:	50                   	push   %eax
80103217:	e8 62 ff ff ff       	call   8010317e <fill_rtcdate>
8010321c:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010321f:	6a 0a                	push   $0xa
80103221:	e8 28 ff ff ff       	call   8010314e <cmos_read>
80103226:	83 c4 04             	add    $0x4,%esp
80103229:	25 80 00 00 00       	and    $0x80,%eax
8010322e:	85 c0                	test   %eax,%eax
80103230:	75 27                	jne    80103259 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103232:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103235:	50                   	push   %eax
80103236:	e8 43 ff ff ff       	call   8010317e <fill_rtcdate>
8010323b:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010323e:	83 ec 04             	sub    $0x4,%esp
80103241:	6a 18                	push   $0x18
80103243:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103246:	50                   	push   %eax
80103247:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010324a:	50                   	push   %eax
8010324b:	e8 c3 27 00 00       	call   80105a13 <memcmp>
80103250:	83 c4 10             	add    $0x10,%esp
80103253:	85 c0                	test   %eax,%eax
80103255:	74 05                	je     8010325c <cmostime+0x6d>
80103257:	eb ba                	jmp    80103213 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103259:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010325a:	eb b7                	jmp    80103213 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010325c:	90                   	nop
  }

  // convert
  if (bcd) {
8010325d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103261:	0f 84 b4 00 00 00    	je     8010331b <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103267:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010326a:	c1 e8 04             	shr    $0x4,%eax
8010326d:	89 c2                	mov    %eax,%edx
8010326f:	89 d0                	mov    %edx,%eax
80103271:	c1 e0 02             	shl    $0x2,%eax
80103274:	01 d0                	add    %edx,%eax
80103276:	01 c0                	add    %eax,%eax
80103278:	89 c2                	mov    %eax,%edx
8010327a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010327d:	83 e0 0f             	and    $0xf,%eax
80103280:	01 d0                	add    %edx,%eax
80103282:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103285:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103288:	c1 e8 04             	shr    $0x4,%eax
8010328b:	89 c2                	mov    %eax,%edx
8010328d:	89 d0                	mov    %edx,%eax
8010328f:	c1 e0 02             	shl    $0x2,%eax
80103292:	01 d0                	add    %edx,%eax
80103294:	01 c0                	add    %eax,%eax
80103296:	89 c2                	mov    %eax,%edx
80103298:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010329b:	83 e0 0f             	and    $0xf,%eax
8010329e:	01 d0                	add    %edx,%eax
801032a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801032a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032a6:	c1 e8 04             	shr    $0x4,%eax
801032a9:	89 c2                	mov    %eax,%edx
801032ab:	89 d0                	mov    %edx,%eax
801032ad:	c1 e0 02             	shl    $0x2,%eax
801032b0:	01 d0                	add    %edx,%eax
801032b2:	01 c0                	add    %eax,%eax
801032b4:	89 c2                	mov    %eax,%edx
801032b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032b9:	83 e0 0f             	and    $0xf,%eax
801032bc:	01 d0                	add    %edx,%eax
801032be:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801032c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032c4:	c1 e8 04             	shr    $0x4,%eax
801032c7:	89 c2                	mov    %eax,%edx
801032c9:	89 d0                	mov    %edx,%eax
801032cb:	c1 e0 02             	shl    $0x2,%eax
801032ce:	01 d0                	add    %edx,%eax
801032d0:	01 c0                	add    %eax,%eax
801032d2:	89 c2                	mov    %eax,%edx
801032d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032d7:	83 e0 0f             	and    $0xf,%eax
801032da:	01 d0                	add    %edx,%eax
801032dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801032df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032e2:	c1 e8 04             	shr    $0x4,%eax
801032e5:	89 c2                	mov    %eax,%edx
801032e7:	89 d0                	mov    %edx,%eax
801032e9:	c1 e0 02             	shl    $0x2,%eax
801032ec:	01 d0                	add    %edx,%eax
801032ee:	01 c0                	add    %eax,%eax
801032f0:	89 c2                	mov    %eax,%edx
801032f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032f5:	83 e0 0f             	and    $0xf,%eax
801032f8:	01 d0                	add    %edx,%eax
801032fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801032fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103300:	c1 e8 04             	shr    $0x4,%eax
80103303:	89 c2                	mov    %eax,%edx
80103305:	89 d0                	mov    %edx,%eax
80103307:	c1 e0 02             	shl    $0x2,%eax
8010330a:	01 d0                	add    %edx,%eax
8010330c:	01 c0                	add    %eax,%eax
8010330e:	89 c2                	mov    %eax,%edx
80103310:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103313:	83 e0 0f             	and    $0xf,%eax
80103316:	01 d0                	add    %edx,%eax
80103318:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010331b:	8b 45 08             	mov    0x8(%ebp),%eax
8010331e:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103321:	89 10                	mov    %edx,(%eax)
80103323:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103326:	89 50 04             	mov    %edx,0x4(%eax)
80103329:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010332c:	89 50 08             	mov    %edx,0x8(%eax)
8010332f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103332:	89 50 0c             	mov    %edx,0xc(%eax)
80103335:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103338:	89 50 10             	mov    %edx,0x10(%eax)
8010333b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010333e:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103341:	8b 45 08             	mov    0x8(%ebp),%eax
80103344:	8b 40 14             	mov    0x14(%eax),%eax
80103347:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010334d:	8b 45 08             	mov    0x8(%ebp),%eax
80103350:	89 50 14             	mov    %edx,0x14(%eax)
}
80103353:	90                   	nop
80103354:	c9                   	leave  
80103355:	c3                   	ret    

80103356 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103356:	55                   	push   %ebp
80103357:	89 e5                	mov    %esp,%ebp
80103359:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010335c:	83 ec 08             	sub    $0x8,%esp
8010335f:	68 24 90 10 80       	push   $0x80109024
80103364:	68 80 32 11 80       	push   $0x80113280
80103369:	e8 b9 23 00 00       	call   80105727 <initlock>
8010336e:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103371:	83 ec 08             	sub    $0x8,%esp
80103374:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103377:	50                   	push   %eax
80103378:	ff 75 08             	pushl  0x8(%ebp)
8010337b:	e8 2b e0 ff ff       	call   801013ab <readsb>
80103380:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103383:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103386:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
8010338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010338e:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = dev;
80103393:	8b 45 08             	mov    0x8(%ebp),%eax
80103396:	a3 c4 32 11 80       	mov    %eax,0x801132c4
  recover_from_log();
8010339b:	e8 b2 01 00 00       	call   80103552 <recover_from_log>
}
801033a0:	90                   	nop
801033a1:	c9                   	leave  
801033a2:	c3                   	ret    

801033a3 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801033a3:	55                   	push   %ebp
801033a4:	89 e5                	mov    %esp,%ebp
801033a6:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033b0:	e9 95 00 00 00       	jmp    8010344a <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801033b5:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
801033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033be:	01 d0                	add    %edx,%eax
801033c0:	83 c0 01             	add    $0x1,%eax
801033c3:	89 c2                	mov    %eax,%edx
801033c5:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033ca:	83 ec 08             	sub    $0x8,%esp
801033cd:	52                   	push   %edx
801033ce:	50                   	push   %eax
801033cf:	e8 e2 cd ff ff       	call   801001b6 <bread>
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033dd:	83 c0 10             	add    $0x10,%eax
801033e0:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801033e7:	89 c2                	mov    %eax,%edx
801033e9:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033ee:	83 ec 08             	sub    $0x8,%esp
801033f1:	52                   	push   %edx
801033f2:	50                   	push   %eax
801033f3:	e8 be cd ff ff       	call   801001b6 <bread>
801033f8:	83 c4 10             	add    $0x10,%esp
801033fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103401:	8d 50 18             	lea    0x18(%eax),%edx
80103404:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103407:	83 c0 18             	add    $0x18,%eax
8010340a:	83 ec 04             	sub    $0x4,%esp
8010340d:	68 00 02 00 00       	push   $0x200
80103412:	52                   	push   %edx
80103413:	50                   	push   %eax
80103414:	e8 52 26 00 00       	call   80105a6b <memmove>
80103419:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010341c:	83 ec 0c             	sub    $0xc,%esp
8010341f:	ff 75 ec             	pushl  -0x14(%ebp)
80103422:	e8 c8 cd ff ff       	call   801001ef <bwrite>
80103427:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010342a:	83 ec 0c             	sub    $0xc,%esp
8010342d:	ff 75 f0             	pushl  -0x10(%ebp)
80103430:	e8 f9 cd ff ff       	call   8010022e <brelse>
80103435:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103438:	83 ec 0c             	sub    $0xc,%esp
8010343b:	ff 75 ec             	pushl  -0x14(%ebp)
8010343e:	e8 eb cd ff ff       	call   8010022e <brelse>
80103443:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103446:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010344a:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010344f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103452:	0f 8f 5d ff ff ff    	jg     801033b5 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103458:	90                   	nop
80103459:	c9                   	leave  
8010345a:	c3                   	ret    

8010345b <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010345b:	55                   	push   %ebp
8010345c:	89 e5                	mov    %esp,%ebp
8010345e:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103461:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103466:	89 c2                	mov    %eax,%edx
80103468:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010346d:	83 ec 08             	sub    $0x8,%esp
80103470:	52                   	push   %edx
80103471:	50                   	push   %eax
80103472:	e8 3f cd ff ff       	call   801001b6 <bread>
80103477:	83 c4 10             	add    $0x10,%esp
8010347a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010347d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103480:	83 c0 18             	add    $0x18,%eax
80103483:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103486:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103489:	8b 00                	mov    (%eax),%eax
8010348b:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
80103490:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103497:	eb 1b                	jmp    801034b4 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103499:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010349c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010349f:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801034a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034a6:	83 c2 10             	add    $0x10,%edx
801034a9:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801034b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034b4:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801034b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034bc:	7f db                	jg     80103499 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801034be:	83 ec 0c             	sub    $0xc,%esp
801034c1:	ff 75 f0             	pushl  -0x10(%ebp)
801034c4:	e8 65 cd ff ff       	call   8010022e <brelse>
801034c9:	83 c4 10             	add    $0x10,%esp
}
801034cc:	90                   	nop
801034cd:	c9                   	leave  
801034ce:	c3                   	ret    

801034cf <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034cf:	55                   	push   %ebp
801034d0:	89 e5                	mov    %esp,%ebp
801034d2:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034d5:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801034da:	89 c2                	mov    %eax,%edx
801034dc:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801034e1:	83 ec 08             	sub    $0x8,%esp
801034e4:	52                   	push   %edx
801034e5:	50                   	push   %eax
801034e6:	e8 cb cc ff ff       	call   801001b6 <bread>
801034eb:	83 c4 10             	add    $0x10,%esp
801034ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034f4:	83 c0 18             	add    $0x18,%eax
801034f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034fa:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
80103500:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103503:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103505:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010350c:	eb 1b                	jmp    80103529 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
8010350e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103511:	83 c0 10             	add    $0x10,%eax
80103514:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
8010351b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010351e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103521:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103525:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103529:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010352e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103531:	7f db                	jg     8010350e <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103533:	83 ec 0c             	sub    $0xc,%esp
80103536:	ff 75 f0             	pushl  -0x10(%ebp)
80103539:	e8 b1 cc ff ff       	call   801001ef <bwrite>
8010353e:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103541:	83 ec 0c             	sub    $0xc,%esp
80103544:	ff 75 f0             	pushl  -0x10(%ebp)
80103547:	e8 e2 cc ff ff       	call   8010022e <brelse>
8010354c:	83 c4 10             	add    $0x10,%esp
}
8010354f:	90                   	nop
80103550:	c9                   	leave  
80103551:	c3                   	ret    

80103552 <recover_from_log>:

static void
recover_from_log(void)
{
80103552:	55                   	push   %ebp
80103553:	89 e5                	mov    %esp,%ebp
80103555:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103558:	e8 fe fe ff ff       	call   8010345b <read_head>
  install_trans(); // if committed, copy from log to disk
8010355d:	e8 41 fe ff ff       	call   801033a3 <install_trans>
  log.lh.n = 0;
80103562:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
80103569:	00 00 00 
  write_head(); // clear the log
8010356c:	e8 5e ff ff ff       	call   801034cf <write_head>
}
80103571:	90                   	nop
80103572:	c9                   	leave  
80103573:	c3                   	ret    

80103574 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103574:	55                   	push   %ebp
80103575:	89 e5                	mov    %esp,%ebp
80103577:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010357a:	83 ec 0c             	sub    $0xc,%esp
8010357d:	68 80 32 11 80       	push   $0x80113280
80103582:	e8 c2 21 00 00       	call   80105749 <acquire>
80103587:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010358a:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010358f:	85 c0                	test   %eax,%eax
80103591:	74 17                	je     801035aa <begin_op+0x36>
      sleep(&log, &log.lock);
80103593:	83 ec 08             	sub    $0x8,%esp
80103596:	68 80 32 11 80       	push   $0x80113280
8010359b:	68 80 32 11 80       	push   $0x80113280
801035a0:	e8 ae 1a 00 00       	call   80105053 <sleep>
801035a5:	83 c4 10             	add    $0x10,%esp
801035a8:	eb e0                	jmp    8010358a <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035aa:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
801035b0:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801035b5:	8d 50 01             	lea    0x1(%eax),%edx
801035b8:	89 d0                	mov    %edx,%eax
801035ba:	c1 e0 02             	shl    $0x2,%eax
801035bd:	01 d0                	add    %edx,%eax
801035bf:	01 c0                	add    %eax,%eax
801035c1:	01 c8                	add    %ecx,%eax
801035c3:	83 f8 1e             	cmp    $0x1e,%eax
801035c6:	7e 17                	jle    801035df <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801035c8:	83 ec 08             	sub    $0x8,%esp
801035cb:	68 80 32 11 80       	push   $0x80113280
801035d0:	68 80 32 11 80       	push   $0x80113280
801035d5:	e8 79 1a 00 00       	call   80105053 <sleep>
801035da:	83 c4 10             	add    $0x10,%esp
801035dd:	eb ab                	jmp    8010358a <begin_op+0x16>
    } else {
      log.outstanding += 1;
801035df:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801035e4:	83 c0 01             	add    $0x1,%eax
801035e7:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
801035ec:	83 ec 0c             	sub    $0xc,%esp
801035ef:	68 80 32 11 80       	push   $0x80113280
801035f4:	e8 b7 21 00 00       	call   801057b0 <release>
801035f9:	83 c4 10             	add    $0x10,%esp
      break;
801035fc:	90                   	nop
    }
  }
}
801035fd:	90                   	nop
801035fe:	c9                   	leave  
801035ff:	c3                   	ret    

80103600 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010360d:	83 ec 0c             	sub    $0xc,%esp
80103610:	68 80 32 11 80       	push   $0x80113280
80103615:	e8 2f 21 00 00       	call   80105749 <acquire>
8010361a:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010361d:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103622:	83 e8 01             	sub    $0x1,%eax
80103625:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
8010362a:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010362f:	85 c0                	test   %eax,%eax
80103631:	74 0d                	je     80103640 <end_op+0x40>
    panic("log.committing");
80103633:	83 ec 0c             	sub    $0xc,%esp
80103636:	68 28 90 10 80       	push   $0x80109028
8010363b:	e8 26 cf ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103640:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103645:	85 c0                	test   %eax,%eax
80103647:	75 13                	jne    8010365c <end_op+0x5c>
    do_commit = 1;
80103649:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103650:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
80103657:	00 00 00 
8010365a:	eb 10                	jmp    8010366c <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010365c:	83 ec 0c             	sub    $0xc,%esp
8010365f:	68 80 32 11 80       	push   $0x80113280
80103664:	e8 d1 1a 00 00       	call   8010513a <wakeup>
80103669:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010366c:	83 ec 0c             	sub    $0xc,%esp
8010366f:	68 80 32 11 80       	push   $0x80113280
80103674:	e8 37 21 00 00       	call   801057b0 <release>
80103679:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010367c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103680:	74 3f                	je     801036c1 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103682:	e8 f5 00 00 00       	call   8010377c <commit>
    acquire(&log.lock);
80103687:	83 ec 0c             	sub    $0xc,%esp
8010368a:	68 80 32 11 80       	push   $0x80113280
8010368f:	e8 b5 20 00 00       	call   80105749 <acquire>
80103694:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103697:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
8010369e:	00 00 00 
    wakeup(&log);
801036a1:	83 ec 0c             	sub    $0xc,%esp
801036a4:	68 80 32 11 80       	push   $0x80113280
801036a9:	e8 8c 1a 00 00       	call   8010513a <wakeup>
801036ae:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801036b1:	83 ec 0c             	sub    $0xc,%esp
801036b4:	68 80 32 11 80       	push   $0x80113280
801036b9:	e8 f2 20 00 00       	call   801057b0 <release>
801036be:	83 c4 10             	add    $0x10,%esp
  }
}
801036c1:	90                   	nop
801036c2:	c9                   	leave  
801036c3:	c3                   	ret    

801036c4 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801036c4:	55                   	push   %ebp
801036c5:	89 e5                	mov    %esp,%ebp
801036c7:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036d1:	e9 95 00 00 00       	jmp    8010376b <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036d6:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
801036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036df:	01 d0                	add    %edx,%eax
801036e1:	83 c0 01             	add    $0x1,%eax
801036e4:	89 c2                	mov    %eax,%edx
801036e6:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801036eb:	83 ec 08             	sub    $0x8,%esp
801036ee:	52                   	push   %edx
801036ef:	50                   	push   %eax
801036f0:	e8 c1 ca ff ff       	call   801001b6 <bread>
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036fe:	83 c0 10             	add    $0x10,%eax
80103701:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103708:	89 c2                	mov    %eax,%edx
8010370a:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010370f:	83 ec 08             	sub    $0x8,%esp
80103712:	52                   	push   %edx
80103713:	50                   	push   %eax
80103714:	e8 9d ca ff ff       	call   801001b6 <bread>
80103719:	83 c4 10             	add    $0x10,%esp
8010371c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010371f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103722:	8d 50 18             	lea    0x18(%eax),%edx
80103725:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103728:	83 c0 18             	add    $0x18,%eax
8010372b:	83 ec 04             	sub    $0x4,%esp
8010372e:	68 00 02 00 00       	push   $0x200
80103733:	52                   	push   %edx
80103734:	50                   	push   %eax
80103735:	e8 31 23 00 00       	call   80105a6b <memmove>
8010373a:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010373d:	83 ec 0c             	sub    $0xc,%esp
80103740:	ff 75 f0             	pushl  -0x10(%ebp)
80103743:	e8 a7 ca ff ff       	call   801001ef <bwrite>
80103748:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
8010374b:	83 ec 0c             	sub    $0xc,%esp
8010374e:	ff 75 ec             	pushl  -0x14(%ebp)
80103751:	e8 d8 ca ff ff       	call   8010022e <brelse>
80103756:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103759:	83 ec 0c             	sub    $0xc,%esp
8010375c:	ff 75 f0             	pushl  -0x10(%ebp)
8010375f:	e8 ca ca ff ff       	call   8010022e <brelse>
80103764:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103767:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010376b:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103770:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103773:	0f 8f 5d ff ff ff    	jg     801036d6 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103779:	90                   	nop
8010377a:	c9                   	leave  
8010377b:	c3                   	ret    

8010377c <commit>:

static void
commit()
{
8010377c:	55                   	push   %ebp
8010377d:	89 e5                	mov    %esp,%ebp
8010377f:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103782:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103787:	85 c0                	test   %eax,%eax
80103789:	7e 1e                	jle    801037a9 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010378b:	e8 34 ff ff ff       	call   801036c4 <write_log>
    write_head();    // Write header to disk -- the real commit
80103790:	e8 3a fd ff ff       	call   801034cf <write_head>
    install_trans(); // Now install writes to home locations
80103795:	e8 09 fc ff ff       	call   801033a3 <install_trans>
    log.lh.n = 0; 
8010379a:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801037a1:	00 00 00 
    write_head();    // Erase the transaction from the log
801037a4:	e8 26 fd ff ff       	call   801034cf <write_head>
  }
}
801037a9:	90                   	nop
801037aa:	c9                   	leave  
801037ab:	c3                   	ret    

801037ac <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037ac:	55                   	push   %ebp
801037ad:	89 e5                	mov    %esp,%ebp
801037af:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037b2:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037b7:	83 f8 1d             	cmp    $0x1d,%eax
801037ba:	7f 12                	jg     801037ce <log_write+0x22>
801037bc:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037c1:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
801037c7:	83 ea 01             	sub    $0x1,%edx
801037ca:	39 d0                	cmp    %edx,%eax
801037cc:	7c 0d                	jl     801037db <log_write+0x2f>
    panic("too big a transaction");
801037ce:	83 ec 0c             	sub    $0xc,%esp
801037d1:	68 37 90 10 80       	push   $0x80109037
801037d6:	e8 8b cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
801037db:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801037e0:	85 c0                	test   %eax,%eax
801037e2:	7f 0d                	jg     801037f1 <log_write+0x45>
    panic("log_write outside of trans");
801037e4:	83 ec 0c             	sub    $0xc,%esp
801037e7:	68 4d 90 10 80       	push   $0x8010904d
801037ec:	e8 75 cd ff ff       	call   80100566 <panic>

  acquire(&log.lock);
801037f1:	83 ec 0c             	sub    $0xc,%esp
801037f4:	68 80 32 11 80       	push   $0x80113280
801037f9:	e8 4b 1f 00 00       	call   80105749 <acquire>
801037fe:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103801:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103808:	eb 1d                	jmp    80103827 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010380a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010380d:	83 c0 10             	add    $0x10,%eax
80103810:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103817:	89 c2                	mov    %eax,%edx
80103819:	8b 45 08             	mov    0x8(%ebp),%eax
8010381c:	8b 40 08             	mov    0x8(%eax),%eax
8010381f:	39 c2                	cmp    %eax,%edx
80103821:	74 10                	je     80103833 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103823:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103827:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010382c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010382f:	7f d9                	jg     8010380a <log_write+0x5e>
80103831:	eb 01                	jmp    80103834 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103833:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103834:	8b 45 08             	mov    0x8(%ebp),%eax
80103837:	8b 40 08             	mov    0x8(%eax),%eax
8010383a:	89 c2                	mov    %eax,%edx
8010383c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010383f:	83 c0 10             	add    $0x10,%eax
80103842:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
80103849:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010384e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103851:	75 0d                	jne    80103860 <log_write+0xb4>
    log.lh.n++;
80103853:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103858:	83 c0 01             	add    $0x1,%eax
8010385b:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
80103860:	8b 45 08             	mov    0x8(%ebp),%eax
80103863:	8b 00                	mov    (%eax),%eax
80103865:	83 c8 04             	or     $0x4,%eax
80103868:	89 c2                	mov    %eax,%edx
8010386a:	8b 45 08             	mov    0x8(%ebp),%eax
8010386d:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010386f:	83 ec 0c             	sub    $0xc,%esp
80103872:	68 80 32 11 80       	push   $0x80113280
80103877:	e8 34 1f 00 00       	call   801057b0 <release>
8010387c:	83 c4 10             	add    $0x10,%esp
}
8010387f:	90                   	nop
80103880:	c9                   	leave  
80103881:	c3                   	ret    

80103882 <v2p>:
80103882:	55                   	push   %ebp
80103883:	89 e5                	mov    %esp,%ebp
80103885:	8b 45 08             	mov    0x8(%ebp),%eax
80103888:	05 00 00 00 80       	add    $0x80000000,%eax
8010388d:	5d                   	pop    %ebp
8010388e:	c3                   	ret    

8010388f <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010388f:	55                   	push   %ebp
80103890:	89 e5                	mov    %esp,%ebp
80103892:	8b 45 08             	mov    0x8(%ebp),%eax
80103895:	05 00 00 00 80       	add    $0x80000000,%eax
8010389a:	5d                   	pop    %ebp
8010389b:	c3                   	ret    

8010389c <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010389c:	55                   	push   %ebp
8010389d:	89 e5                	mov    %esp,%ebp
8010389f:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038a2:	8b 55 08             	mov    0x8(%ebp),%edx
801038a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801038a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801038ab:	f0 87 02             	lock xchg %eax,(%edx)
801038ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801038b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801038b4:	c9                   	leave  
801038b5:	c3                   	ret    

801038b6 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801038b6:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038ba:	83 e4 f0             	and    $0xfffffff0,%esp
801038bd:	ff 71 fc             	pushl  -0x4(%ecx)
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	51                   	push   %ecx
801038c4:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038c7:	83 ec 08             	sub    $0x8,%esp
801038ca:	68 00 00 40 80       	push   $0x80400000
801038cf:	68 3c 67 11 80       	push   $0x8011673c
801038d4:	e8 7d f2 ff ff       	call   80102b56 <kinit1>
801038d9:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801038dc:	e8 54 4d 00 00       	call   80108635 <kvmalloc>
  mpinit();        // collect info about this machine
801038e1:	e8 43 04 00 00       	call   80103d29 <mpinit>
  lapicinit();
801038e6:	e8 ea f5 ff ff       	call   80102ed5 <lapicinit>
  seginit();       // set up segments
801038eb:	e8 ee 46 00 00       	call   80107fde <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801038f0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038f6:	0f b6 00             	movzbl (%eax),%eax
801038f9:	0f b6 c0             	movzbl %al,%eax
801038fc:	83 ec 08             	sub    $0x8,%esp
801038ff:	50                   	push   %eax
80103900:	68 68 90 10 80       	push   $0x80109068
80103905:	e8 bc ca ff ff       	call   801003c6 <cprintf>
8010390a:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010390d:	e8 6d 06 00 00       	call   80103f7f <picinit>
  ioapicinit();    // another interrupt controller
80103912:	e8 34 f1 ff ff       	call   80102a4b <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103917:	e8 24 d2 ff ff       	call   80100b40 <consoleinit>
  uartinit();      // serial port
8010391c:	e8 19 3a 00 00       	call   8010733a <uartinit>
  pinit();         // process table
80103921:	e8 5d 0b 00 00       	call   80104483 <pinit>
  tvinit();        // trap vectors
80103926:	e8 0b 36 00 00       	call   80106f36 <tvinit>
  binit();         // buffer cache
8010392b:	e8 04 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103930:	e8 67 d6 ff ff       	call   80100f9c <fileinit>
  ideinit();       // disk
80103935:	e8 19 ed ff ff       	call   80102653 <ideinit>
  if(!ismp)
8010393a:	a1 64 33 11 80       	mov    0x80113364,%eax
8010393f:	85 c0                	test   %eax,%eax
80103941:	75 05                	jne    80103948 <main+0x92>
    timerinit();   // uniprocessor timer
80103943:	e8 3f 35 00 00       	call   80106e87 <timerinit>
  startothers();   // start other processors
80103948:	e8 7f 00 00 00       	call   801039cc <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010394d:	83 ec 08             	sub    $0x8,%esp
80103950:	68 00 00 00 8e       	push   $0x8e000000
80103955:	68 00 00 40 80       	push   $0x80400000
8010395a:	e8 30 f2 ff ff       	call   80102b8f <kinit2>
8010395f:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103962:	e8 f9 0c 00 00       	call   80104660 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103967:	e8 1a 00 00 00       	call   80103986 <mpmain>

8010396c <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010396c:	55                   	push   %ebp
8010396d:	89 e5                	mov    %esp,%ebp
8010396f:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103972:	e8 d6 4c 00 00       	call   8010864d <switchkvm>
  seginit();
80103977:	e8 62 46 00 00       	call   80107fde <seginit>
  lapicinit();
8010397c:	e8 54 f5 ff ff       	call   80102ed5 <lapicinit>
  mpmain();
80103981:	e8 00 00 00 00       	call   80103986 <mpmain>

80103986 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103986:	55                   	push   %ebp
80103987:	89 e5                	mov    %esp,%ebp
80103989:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010398c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103992:	0f b6 00             	movzbl (%eax),%eax
80103995:	0f b6 c0             	movzbl %al,%eax
80103998:	83 ec 08             	sub    $0x8,%esp
8010399b:	50                   	push   %eax
8010399c:	68 7f 90 10 80       	push   $0x8010907f
801039a1:	e8 20 ca ff ff       	call   801003c6 <cprintf>
801039a6:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801039a9:	e8 e9 36 00 00       	call   80107097 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801039ae:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039b4:	05 a8 00 00 00       	add    $0xa8,%eax
801039b9:	83 ec 08             	sub    $0x8,%esp
801039bc:	6a 01                	push   $0x1
801039be:	50                   	push   %eax
801039bf:	e8 d8 fe ff ff       	call   8010389c <xchg>
801039c4:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801039c7:	e8 37 14 00 00       	call   80104e03 <scheduler>

801039cc <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801039cc:	55                   	push   %ebp
801039cd:	89 e5                	mov    %esp,%ebp
801039cf:	53                   	push   %ebx
801039d0:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801039d3:	68 00 70 00 00       	push   $0x7000
801039d8:	e8 b2 fe ff ff       	call   8010388f <p2v>
801039dd:	83 c4 04             	add    $0x4,%esp
801039e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801039e3:	b8 8a 00 00 00       	mov    $0x8a,%eax
801039e8:	83 ec 04             	sub    $0x4,%esp
801039eb:	50                   	push   %eax
801039ec:	68 2c c5 10 80       	push   $0x8010c52c
801039f1:	ff 75 f0             	pushl  -0x10(%ebp)
801039f4:	e8 72 20 00 00       	call   80105a6b <memmove>
801039f9:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
801039fc:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
80103a03:	e9 90 00 00 00       	jmp    80103a98 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a08:	e8 e6 f5 ff ff       	call   80102ff3 <cpunum>
80103a0d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a13:	05 80 33 11 80       	add    $0x80113380,%eax
80103a18:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a1b:	74 73                	je     80103a90 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a1d:	e8 6b f2 ff ff       	call   80102c8d <kalloc>
80103a22:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a28:	83 e8 04             	sub    $0x4,%eax
80103a2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103a2e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103a34:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a39:	83 e8 08             	sub    $0x8,%eax
80103a3c:	c7 00 6c 39 10 80    	movl   $0x8010396c,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a45:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103a48:	83 ec 0c             	sub    $0xc,%esp
80103a4b:	68 00 b0 10 80       	push   $0x8010b000
80103a50:	e8 2d fe ff ff       	call   80103882 <v2p>
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103a5a:	83 ec 0c             	sub    $0xc,%esp
80103a5d:	ff 75 f0             	pushl  -0x10(%ebp)
80103a60:	e8 1d fe ff ff       	call   80103882 <v2p>
80103a65:	83 c4 10             	add    $0x10,%esp
80103a68:	89 c2                	mov    %eax,%edx
80103a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a6d:	0f b6 00             	movzbl (%eax),%eax
80103a70:	0f b6 c0             	movzbl %al,%eax
80103a73:	83 ec 08             	sub    $0x8,%esp
80103a76:	52                   	push   %edx
80103a77:	50                   	push   %eax
80103a78:	e8 f0 f5 ff ff       	call   8010306d <lapicstartap>
80103a7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103a80:	90                   	nop
80103a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a84:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103a8a:	85 c0                	test   %eax,%eax
80103a8c:	74 f3                	je     80103a81 <startothers+0xb5>
80103a8e:	eb 01                	jmp    80103a91 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103a90:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103a91:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103a98:	a1 60 39 11 80       	mov    0x80113960,%eax
80103a9d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103aa3:	05 80 33 11 80       	add    $0x80113380,%eax
80103aa8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103aab:	0f 87 57 ff ff ff    	ja     80103a08 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103ab1:	90                   	nop
80103ab2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab5:	c9                   	leave  
80103ab6:	c3                   	ret    

80103ab7 <p2v>:
80103ab7:	55                   	push   %ebp
80103ab8:	89 e5                	mov    %esp,%ebp
80103aba:	8b 45 08             	mov    0x8(%ebp),%eax
80103abd:	05 00 00 00 80       	add    $0x80000000,%eax
80103ac2:	5d                   	pop    %ebp
80103ac3:	c3                   	ret    

80103ac4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103ac4:	55                   	push   %ebp
80103ac5:	89 e5                	mov    %esp,%ebp
80103ac7:	83 ec 14             	sub    $0x14,%esp
80103aca:	8b 45 08             	mov    0x8(%ebp),%eax
80103acd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ad1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103ad5:	89 c2                	mov    %eax,%edx
80103ad7:	ec                   	in     (%dx),%al
80103ad8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103adb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103adf:	c9                   	leave  
80103ae0:	c3                   	ret    

80103ae1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103ae1:	55                   	push   %ebp
80103ae2:	89 e5                	mov    %esp,%ebp
80103ae4:	83 ec 08             	sub    $0x8,%esp
80103ae7:	8b 55 08             	mov    0x8(%ebp),%edx
80103aea:	8b 45 0c             	mov    0xc(%ebp),%eax
80103aed:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103af1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103af4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103af8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103afc:	ee                   	out    %al,(%dx)
}
80103afd:	90                   	nop
80103afe:	c9                   	leave  
80103aff:	c3                   	ret    

80103b00 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b03:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103b08:	89 c2                	mov    %eax,%edx
80103b0a:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103b0f:	29 c2                	sub    %eax,%edx
80103b11:	89 d0                	mov    %edx,%eax
80103b13:	c1 f8 02             	sar    $0x2,%eax
80103b16:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103b1c:	5d                   	pop    %ebp
80103b1d:	c3                   	ret    

80103b1e <sum>:

static uchar
sum(uchar *addr, int len)
{
80103b1e:	55                   	push   %ebp
80103b1f:	89 e5                	mov    %esp,%ebp
80103b21:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103b24:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103b32:	eb 15                	jmp    80103b49 <sum+0x2b>
    sum += addr[i];
80103b34:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b37:	8b 45 08             	mov    0x8(%ebp),%eax
80103b3a:	01 d0                	add    %edx,%eax
80103b3c:	0f b6 00             	movzbl (%eax),%eax
80103b3f:	0f b6 c0             	movzbl %al,%eax
80103b42:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103b45:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103b49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b4c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103b4f:	7c e3                	jl     80103b34 <sum+0x16>
    sum += addr[i];
  return sum;
80103b51:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103b54:	c9                   	leave  
80103b55:	c3                   	ret    

80103b56 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b56:	55                   	push   %ebp
80103b57:	89 e5                	mov    %esp,%ebp
80103b59:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103b5c:	ff 75 08             	pushl  0x8(%ebp)
80103b5f:	e8 53 ff ff ff       	call   80103ab7 <p2v>
80103b64:	83 c4 04             	add    $0x4,%esp
80103b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b70:	01 d0                	add    %edx,%eax
80103b72:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b7b:	eb 36                	jmp    80103bb3 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b7d:	83 ec 04             	sub    $0x4,%esp
80103b80:	6a 04                	push   $0x4
80103b82:	68 90 90 10 80       	push   $0x80109090
80103b87:	ff 75 f4             	pushl  -0xc(%ebp)
80103b8a:	e8 84 1e 00 00       	call   80105a13 <memcmp>
80103b8f:	83 c4 10             	add    $0x10,%esp
80103b92:	85 c0                	test   %eax,%eax
80103b94:	75 19                	jne    80103baf <mpsearch1+0x59>
80103b96:	83 ec 08             	sub    $0x8,%esp
80103b99:	6a 10                	push   $0x10
80103b9b:	ff 75 f4             	pushl  -0xc(%ebp)
80103b9e:	e8 7b ff ff ff       	call   80103b1e <sum>
80103ba3:	83 c4 10             	add    $0x10,%esp
80103ba6:	84 c0                	test   %al,%al
80103ba8:	75 05                	jne    80103baf <mpsearch1+0x59>
      return (struct mp*)p;
80103baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bad:	eb 11                	jmp    80103bc0 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103baf:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103bb9:	72 c2                	jb     80103b7d <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103bc0:	c9                   	leave  
80103bc1:	c3                   	ret    

80103bc2 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103bc2:	55                   	push   %ebp
80103bc3:	89 e5                	mov    %esp,%ebp
80103bc5:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103bc8:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd2:	83 c0 0f             	add    $0xf,%eax
80103bd5:	0f b6 00             	movzbl (%eax),%eax
80103bd8:	0f b6 c0             	movzbl %al,%eax
80103bdb:	c1 e0 08             	shl    $0x8,%eax
80103bde:	89 c2                	mov    %eax,%edx
80103be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be3:	83 c0 0e             	add    $0xe,%eax
80103be6:	0f b6 00             	movzbl (%eax),%eax
80103be9:	0f b6 c0             	movzbl %al,%eax
80103bec:	09 d0                	or     %edx,%eax
80103bee:	c1 e0 04             	shl    $0x4,%eax
80103bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103bf4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bf8:	74 21                	je     80103c1b <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103bfa:	83 ec 08             	sub    $0x8,%esp
80103bfd:	68 00 04 00 00       	push   $0x400
80103c02:	ff 75 f0             	pushl  -0x10(%ebp)
80103c05:	e8 4c ff ff ff       	call   80103b56 <mpsearch1>
80103c0a:	83 c4 10             	add    $0x10,%esp
80103c0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c14:	74 51                	je     80103c67 <mpsearch+0xa5>
      return mp;
80103c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c19:	eb 61                	jmp    80103c7c <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1e:	83 c0 14             	add    $0x14,%eax
80103c21:	0f b6 00             	movzbl (%eax),%eax
80103c24:	0f b6 c0             	movzbl %al,%eax
80103c27:	c1 e0 08             	shl    $0x8,%eax
80103c2a:	89 c2                	mov    %eax,%edx
80103c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2f:	83 c0 13             	add    $0x13,%eax
80103c32:	0f b6 00             	movzbl (%eax),%eax
80103c35:	0f b6 c0             	movzbl %al,%eax
80103c38:	09 d0                	or     %edx,%eax
80103c3a:	c1 e0 0a             	shl    $0xa,%eax
80103c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c43:	2d 00 04 00 00       	sub    $0x400,%eax
80103c48:	83 ec 08             	sub    $0x8,%esp
80103c4b:	68 00 04 00 00       	push   $0x400
80103c50:	50                   	push   %eax
80103c51:	e8 00 ff ff ff       	call   80103b56 <mpsearch1>
80103c56:	83 c4 10             	add    $0x10,%esp
80103c59:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c60:	74 05                	je     80103c67 <mpsearch+0xa5>
      return mp;
80103c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c65:	eb 15                	jmp    80103c7c <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103c67:	83 ec 08             	sub    $0x8,%esp
80103c6a:	68 00 00 01 00       	push   $0x10000
80103c6f:	68 00 00 0f 00       	push   $0xf0000
80103c74:	e8 dd fe ff ff       	call   80103b56 <mpsearch1>
80103c79:	83 c4 10             	add    $0x10,%esp
}
80103c7c:	c9                   	leave  
80103c7d:	c3                   	ret    

80103c7e <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103c7e:	55                   	push   %ebp
80103c7f:	89 e5                	mov    %esp,%ebp
80103c81:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c84:	e8 39 ff ff ff       	call   80103bc2 <mpsearch>
80103c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c90:	74 0a                	je     80103c9c <mpconfig+0x1e>
80103c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c95:	8b 40 04             	mov    0x4(%eax),%eax
80103c98:	85 c0                	test   %eax,%eax
80103c9a:	75 0a                	jne    80103ca6 <mpconfig+0x28>
    return 0;
80103c9c:	b8 00 00 00 00       	mov    $0x0,%eax
80103ca1:	e9 81 00 00 00       	jmp    80103d27 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca9:	8b 40 04             	mov    0x4(%eax),%eax
80103cac:	83 ec 0c             	sub    $0xc,%esp
80103caf:	50                   	push   %eax
80103cb0:	e8 02 fe ff ff       	call   80103ab7 <p2v>
80103cb5:	83 c4 10             	add    $0x10,%esp
80103cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103cbb:	83 ec 04             	sub    $0x4,%esp
80103cbe:	6a 04                	push   $0x4
80103cc0:	68 95 90 10 80       	push   $0x80109095
80103cc5:	ff 75 f0             	pushl  -0x10(%ebp)
80103cc8:	e8 46 1d 00 00       	call   80105a13 <memcmp>
80103ccd:	83 c4 10             	add    $0x10,%esp
80103cd0:	85 c0                	test   %eax,%eax
80103cd2:	74 07                	je     80103cdb <mpconfig+0x5d>
    return 0;
80103cd4:	b8 00 00 00 00       	mov    $0x0,%eax
80103cd9:	eb 4c                	jmp    80103d27 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cde:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103ce2:	3c 01                	cmp    $0x1,%al
80103ce4:	74 12                	je     80103cf8 <mpconfig+0x7a>
80103ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce9:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103ced:	3c 04                	cmp    $0x4,%al
80103cef:	74 07                	je     80103cf8 <mpconfig+0x7a>
    return 0;
80103cf1:	b8 00 00 00 00       	mov    $0x0,%eax
80103cf6:	eb 2f                	jmp    80103d27 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cfb:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cff:	0f b7 c0             	movzwl %ax,%eax
80103d02:	83 ec 08             	sub    $0x8,%esp
80103d05:	50                   	push   %eax
80103d06:	ff 75 f0             	pushl  -0x10(%ebp)
80103d09:	e8 10 fe ff ff       	call   80103b1e <sum>
80103d0e:	83 c4 10             	add    $0x10,%esp
80103d11:	84 c0                	test   %al,%al
80103d13:	74 07                	je     80103d1c <mpconfig+0x9e>
    return 0;
80103d15:	b8 00 00 00 00       	mov    $0x0,%eax
80103d1a:	eb 0b                	jmp    80103d27 <mpconfig+0xa9>
  *pmp = mp;
80103d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80103d1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d22:	89 10                	mov    %edx,(%eax)
  return conf;
80103d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d27:	c9                   	leave  
80103d28:	c3                   	ret    

80103d29 <mpinit>:

void
mpinit(void)
{
80103d29:	55                   	push   %ebp
80103d2a:	89 e5                	mov    %esp,%ebp
80103d2c:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103d2f:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103d36:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103d39:	83 ec 0c             	sub    $0xc,%esp
80103d3c:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103d3f:	50                   	push   %eax
80103d40:	e8 39 ff ff ff       	call   80103c7e <mpconfig>
80103d45:	83 c4 10             	add    $0x10,%esp
80103d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d4f:	0f 84 96 01 00 00    	je     80103eeb <mpinit+0x1c2>
    return;
  ismp = 1;
80103d55:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103d5c:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d62:	8b 40 24             	mov    0x24(%eax),%eax
80103d65:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d6d:	83 c0 2c             	add    $0x2c,%eax
80103d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d76:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d7a:	0f b7 d0             	movzwl %ax,%edx
80103d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d80:	01 d0                	add    %edx,%eax
80103d82:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d85:	e9 f2 00 00 00       	jmp    80103e7c <mpinit+0x153>
    switch(*p){
80103d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d8d:	0f b6 00             	movzbl (%eax),%eax
80103d90:	0f b6 c0             	movzbl %al,%eax
80103d93:	83 f8 04             	cmp    $0x4,%eax
80103d96:	0f 87 bc 00 00 00    	ja     80103e58 <mpinit+0x12f>
80103d9c:	8b 04 85 d8 90 10 80 	mov    -0x7fef6f28(,%eax,4),%eax
80103da3:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103da8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103dae:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103db2:	0f b6 d0             	movzbl %al,%edx
80103db5:	a1 60 39 11 80       	mov    0x80113960,%eax
80103dba:	39 c2                	cmp    %eax,%edx
80103dbc:	74 2b                	je     80103de9 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103dbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103dc1:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103dc5:	0f b6 d0             	movzbl %al,%edx
80103dc8:	a1 60 39 11 80       	mov    0x80113960,%eax
80103dcd:	83 ec 04             	sub    $0x4,%esp
80103dd0:	52                   	push   %edx
80103dd1:	50                   	push   %eax
80103dd2:	68 9a 90 10 80       	push   $0x8010909a
80103dd7:	e8 ea c5 ff ff       	call   801003c6 <cprintf>
80103ddc:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103ddf:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103de6:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103dec:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103df0:	0f b6 c0             	movzbl %al,%eax
80103df3:	83 e0 02             	and    $0x2,%eax
80103df6:	85 c0                	test   %eax,%eax
80103df8:	74 15                	je     80103e0f <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103dfa:	a1 60 39 11 80       	mov    0x80113960,%eax
80103dff:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e05:	05 80 33 11 80       	add    $0x80113380,%eax
80103e0a:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103e0f:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e14:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103e1a:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e20:	05 80 33 11 80       	add    $0x80113380,%eax
80103e25:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103e27:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e2c:	83 c0 01             	add    $0x1,%eax
80103e2f:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103e34:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103e38:	eb 42                	jmp    80103e7c <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e43:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e47:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103e4c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e50:	eb 2a                	jmp    80103e7c <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103e52:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e56:	eb 24                	jmp    80103e7c <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e5b:	0f b6 00             	movzbl (%eax),%eax
80103e5e:	0f b6 c0             	movzbl %al,%eax
80103e61:	83 ec 08             	sub    $0x8,%esp
80103e64:	50                   	push   %eax
80103e65:	68 b8 90 10 80       	push   $0x801090b8
80103e6a:	e8 57 c5 ff ff       	call   801003c6 <cprintf>
80103e6f:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103e72:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103e79:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e7f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103e82:	0f 82 02 ff ff ff    	jb     80103d8a <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103e88:	a1 64 33 11 80       	mov    0x80113364,%eax
80103e8d:	85 c0                	test   %eax,%eax
80103e8f:	75 1d                	jne    80103eae <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103e91:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103e98:	00 00 00 
    lapic = 0;
80103e9b:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103ea2:	00 00 00 
    ioapicid = 0;
80103ea5:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103eac:	eb 3e                	jmp    80103eec <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103eae:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103eb1:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103eb5:	84 c0                	test   %al,%al
80103eb7:	74 33                	je     80103eec <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103eb9:	83 ec 08             	sub    $0x8,%esp
80103ebc:	6a 70                	push   $0x70
80103ebe:	6a 22                	push   $0x22
80103ec0:	e8 1c fc ff ff       	call   80103ae1 <outb>
80103ec5:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ec8:	83 ec 0c             	sub    $0xc,%esp
80103ecb:	6a 23                	push   $0x23
80103ecd:	e8 f2 fb ff ff       	call   80103ac4 <inb>
80103ed2:	83 c4 10             	add    $0x10,%esp
80103ed5:	83 c8 01             	or     $0x1,%eax
80103ed8:	0f b6 c0             	movzbl %al,%eax
80103edb:	83 ec 08             	sub    $0x8,%esp
80103ede:	50                   	push   %eax
80103edf:	6a 23                	push   $0x23
80103ee1:	e8 fb fb ff ff       	call   80103ae1 <outb>
80103ee6:	83 c4 10             	add    $0x10,%esp
80103ee9:	eb 01                	jmp    80103eec <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103eeb:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103eec:	c9                   	leave  
80103eed:	c3                   	ret    

80103eee <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103eee:	55                   	push   %ebp
80103eef:	89 e5                	mov    %esp,%ebp
80103ef1:	83 ec 08             	sub    $0x8,%esp
80103ef4:	8b 55 08             	mov    0x8(%ebp),%edx
80103ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103efa:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103efe:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f01:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f05:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f09:	ee                   	out    %al,(%dx)
}
80103f0a:	90                   	nop
80103f0b:	c9                   	leave  
80103f0c:	c3                   	ret    

80103f0d <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f0d:	55                   	push   %ebp
80103f0e:	89 e5                	mov    %esp,%ebp
80103f10:	83 ec 04             	sub    $0x4,%esp
80103f13:	8b 45 08             	mov    0x8(%ebp),%eax
80103f16:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f1a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f1e:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103f24:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f28:	0f b6 c0             	movzbl %al,%eax
80103f2b:	50                   	push   %eax
80103f2c:	6a 21                	push   $0x21
80103f2e:	e8 bb ff ff ff       	call   80103eee <outb>
80103f33:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103f36:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f3a:	66 c1 e8 08          	shr    $0x8,%ax
80103f3e:	0f b6 c0             	movzbl %al,%eax
80103f41:	50                   	push   %eax
80103f42:	68 a1 00 00 00       	push   $0xa1
80103f47:	e8 a2 ff ff ff       	call   80103eee <outb>
80103f4c:	83 c4 08             	add    $0x8,%esp
}
80103f4f:	90                   	nop
80103f50:	c9                   	leave  
80103f51:	c3                   	ret    

80103f52 <picenable>:

void
picenable(int irq)
{
80103f52:	55                   	push   %ebp
80103f53:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103f55:	8b 45 08             	mov    0x8(%ebp),%eax
80103f58:	ba 01 00 00 00       	mov    $0x1,%edx
80103f5d:	89 c1                	mov    %eax,%ecx
80103f5f:	d3 e2                	shl    %cl,%edx
80103f61:	89 d0                	mov    %edx,%eax
80103f63:	f7 d0                	not    %eax
80103f65:	89 c2                	mov    %eax,%edx
80103f67:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f6e:	21 d0                	and    %edx,%eax
80103f70:	0f b7 c0             	movzwl %ax,%eax
80103f73:	50                   	push   %eax
80103f74:	e8 94 ff ff ff       	call   80103f0d <picsetmask>
80103f79:	83 c4 04             	add    $0x4,%esp
}
80103f7c:	90                   	nop
80103f7d:	c9                   	leave  
80103f7e:	c3                   	ret    

80103f7f <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103f7f:	55                   	push   %ebp
80103f80:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103f82:	68 ff 00 00 00       	push   $0xff
80103f87:	6a 21                	push   $0x21
80103f89:	e8 60 ff ff ff       	call   80103eee <outb>
80103f8e:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103f91:	68 ff 00 00 00       	push   $0xff
80103f96:	68 a1 00 00 00       	push   $0xa1
80103f9b:	e8 4e ff ff ff       	call   80103eee <outb>
80103fa0:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103fa3:	6a 11                	push   $0x11
80103fa5:	6a 20                	push   $0x20
80103fa7:	e8 42 ff ff ff       	call   80103eee <outb>
80103fac:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103faf:	6a 20                	push   $0x20
80103fb1:	6a 21                	push   $0x21
80103fb3:	e8 36 ff ff ff       	call   80103eee <outb>
80103fb8:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103fbb:	6a 04                	push   $0x4
80103fbd:	6a 21                	push   $0x21
80103fbf:	e8 2a ff ff ff       	call   80103eee <outb>
80103fc4:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103fc7:	6a 03                	push   $0x3
80103fc9:	6a 21                	push   $0x21
80103fcb:	e8 1e ff ff ff       	call   80103eee <outb>
80103fd0:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103fd3:	6a 11                	push   $0x11
80103fd5:	68 a0 00 00 00       	push   $0xa0
80103fda:	e8 0f ff ff ff       	call   80103eee <outb>
80103fdf:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103fe2:	6a 28                	push   $0x28
80103fe4:	68 a1 00 00 00       	push   $0xa1
80103fe9:	e8 00 ff ff ff       	call   80103eee <outb>
80103fee:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103ff1:	6a 02                	push   $0x2
80103ff3:	68 a1 00 00 00       	push   $0xa1
80103ff8:	e8 f1 fe ff ff       	call   80103eee <outb>
80103ffd:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104000:	6a 03                	push   $0x3
80104002:	68 a1 00 00 00       	push   $0xa1
80104007:	e8 e2 fe ff ff       	call   80103eee <outb>
8010400c:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
8010400f:	6a 68                	push   $0x68
80104011:	6a 20                	push   $0x20
80104013:	e8 d6 fe ff ff       	call   80103eee <outb>
80104018:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
8010401b:	6a 0a                	push   $0xa
8010401d:	6a 20                	push   $0x20
8010401f:	e8 ca fe ff ff       	call   80103eee <outb>
80104024:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80104027:	6a 68                	push   $0x68
80104029:	68 a0 00 00 00       	push   $0xa0
8010402e:	e8 bb fe ff ff       	call   80103eee <outb>
80104033:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104036:	6a 0a                	push   $0xa
80104038:	68 a0 00 00 00       	push   $0xa0
8010403d:	e8 ac fe ff ff       	call   80103eee <outb>
80104042:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80104045:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
8010404c:	66 83 f8 ff          	cmp    $0xffff,%ax
80104050:	74 13                	je     80104065 <picinit+0xe6>
    picsetmask(irqmask);
80104052:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104059:	0f b7 c0             	movzwl %ax,%eax
8010405c:	50                   	push   %eax
8010405d:	e8 ab fe ff ff       	call   80103f0d <picsetmask>
80104062:	83 c4 04             	add    $0x4,%esp
}
80104065:	90                   	nop
80104066:	c9                   	leave  
80104067:	c3                   	ret    

80104068 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104068:	55                   	push   %ebp
80104069:	89 e5                	mov    %esp,%ebp
8010406b:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
8010406e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104075:	8b 45 0c             	mov    0xc(%ebp),%eax
80104078:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010407e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104081:	8b 10                	mov    (%eax),%edx
80104083:	8b 45 08             	mov    0x8(%ebp),%eax
80104086:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104088:	e8 2d cf ff ff       	call   80100fba <filealloc>
8010408d:	89 c2                	mov    %eax,%edx
8010408f:	8b 45 08             	mov    0x8(%ebp),%eax
80104092:	89 10                	mov    %edx,(%eax)
80104094:	8b 45 08             	mov    0x8(%ebp),%eax
80104097:	8b 00                	mov    (%eax),%eax
80104099:	85 c0                	test   %eax,%eax
8010409b:	0f 84 cb 00 00 00    	je     8010416c <pipealloc+0x104>
801040a1:	e8 14 cf ff ff       	call   80100fba <filealloc>
801040a6:	89 c2                	mov    %eax,%edx
801040a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ab:	89 10                	mov    %edx,(%eax)
801040ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b0:	8b 00                	mov    (%eax),%eax
801040b2:	85 c0                	test   %eax,%eax
801040b4:	0f 84 b2 00 00 00    	je     8010416c <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801040ba:	e8 ce eb ff ff       	call   80102c8d <kalloc>
801040bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801040c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040c6:	0f 84 9f 00 00 00    	je     8010416b <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801040cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040cf:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801040d6:	00 00 00 
  p->writeopen = 1;
801040d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040dc:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801040e3:	00 00 00 
  p->nwrite = 0;
801040e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e9:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801040f0:	00 00 00 
  p->nread = 0;
801040f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f6:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801040fd:	00 00 00 
  initlock(&p->lock, "pipe");
80104100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104103:	83 ec 08             	sub    $0x8,%esp
80104106:	68 ec 90 10 80       	push   $0x801090ec
8010410b:	50                   	push   %eax
8010410c:	e8 16 16 00 00       	call   80105727 <initlock>
80104111:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104114:	8b 45 08             	mov    0x8(%ebp),%eax
80104117:	8b 00                	mov    (%eax),%eax
80104119:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010411f:	8b 45 08             	mov    0x8(%ebp),%eax
80104122:	8b 00                	mov    (%eax),%eax
80104124:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104128:	8b 45 08             	mov    0x8(%ebp),%eax
8010412b:	8b 00                	mov    (%eax),%eax
8010412d:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104131:	8b 45 08             	mov    0x8(%ebp),%eax
80104134:	8b 00                	mov    (%eax),%eax
80104136:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104139:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010413c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010413f:	8b 00                	mov    (%eax),%eax
80104141:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104147:	8b 45 0c             	mov    0xc(%ebp),%eax
8010414a:	8b 00                	mov    (%eax),%eax
8010414c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104150:	8b 45 0c             	mov    0xc(%ebp),%eax
80104153:	8b 00                	mov    (%eax),%eax
80104155:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104159:	8b 45 0c             	mov    0xc(%ebp),%eax
8010415c:	8b 00                	mov    (%eax),%eax
8010415e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104161:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104164:	b8 00 00 00 00       	mov    $0x0,%eax
80104169:	eb 4e                	jmp    801041b9 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
8010416b:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
8010416c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104170:	74 0e                	je     80104180 <pipealloc+0x118>
    kfree((char*)p);
80104172:	83 ec 0c             	sub    $0xc,%esp
80104175:	ff 75 f4             	pushl  -0xc(%ebp)
80104178:	e8 73 ea ff ff       	call   80102bf0 <kfree>
8010417d:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104180:	8b 45 08             	mov    0x8(%ebp),%eax
80104183:	8b 00                	mov    (%eax),%eax
80104185:	85 c0                	test   %eax,%eax
80104187:	74 11                	je     8010419a <pipealloc+0x132>
    fileclose(*f0);
80104189:	8b 45 08             	mov    0x8(%ebp),%eax
8010418c:	8b 00                	mov    (%eax),%eax
8010418e:	83 ec 0c             	sub    $0xc,%esp
80104191:	50                   	push   %eax
80104192:	e8 e1 ce ff ff       	call   80101078 <fileclose>
80104197:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010419a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010419d:	8b 00                	mov    (%eax),%eax
8010419f:	85 c0                	test   %eax,%eax
801041a1:	74 11                	je     801041b4 <pipealloc+0x14c>
    fileclose(*f1);
801041a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801041a6:	8b 00                	mov    (%eax),%eax
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	50                   	push   %eax
801041ac:	e8 c7 ce ff ff       	call   80101078 <fileclose>
801041b1:	83 c4 10             	add    $0x10,%esp
  return -1;
801041b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041b9:	c9                   	leave  
801041ba:	c3                   	ret    

801041bb <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801041bb:	55                   	push   %ebp
801041bc:	89 e5                	mov    %esp,%ebp
801041be:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801041c1:	8b 45 08             	mov    0x8(%ebp),%eax
801041c4:	83 ec 0c             	sub    $0xc,%esp
801041c7:	50                   	push   %eax
801041c8:	e8 7c 15 00 00       	call   80105749 <acquire>
801041cd:	83 c4 10             	add    $0x10,%esp
  if(writable){
801041d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801041d4:	74 23                	je     801041f9 <pipeclose+0x3e>
    p->writeopen = 0;
801041d6:	8b 45 08             	mov    0x8(%ebp),%eax
801041d9:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801041e0:	00 00 00 
    wakeup(&p->nread);
801041e3:	8b 45 08             	mov    0x8(%ebp),%eax
801041e6:	05 34 02 00 00       	add    $0x234,%eax
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	50                   	push   %eax
801041ef:	e8 46 0f 00 00       	call   8010513a <wakeup>
801041f4:	83 c4 10             	add    $0x10,%esp
801041f7:	eb 21                	jmp    8010421a <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801041f9:	8b 45 08             	mov    0x8(%ebp),%eax
801041fc:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104203:	00 00 00 
    wakeup(&p->nwrite);
80104206:	8b 45 08             	mov    0x8(%ebp),%eax
80104209:	05 38 02 00 00       	add    $0x238,%eax
8010420e:	83 ec 0c             	sub    $0xc,%esp
80104211:	50                   	push   %eax
80104212:	e8 23 0f 00 00       	call   8010513a <wakeup>
80104217:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010421a:	8b 45 08             	mov    0x8(%ebp),%eax
8010421d:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104223:	85 c0                	test   %eax,%eax
80104225:	75 2c                	jne    80104253 <pipeclose+0x98>
80104227:	8b 45 08             	mov    0x8(%ebp),%eax
8010422a:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104230:	85 c0                	test   %eax,%eax
80104232:	75 1f                	jne    80104253 <pipeclose+0x98>
    release(&p->lock);
80104234:	8b 45 08             	mov    0x8(%ebp),%eax
80104237:	83 ec 0c             	sub    $0xc,%esp
8010423a:	50                   	push   %eax
8010423b:	e8 70 15 00 00       	call   801057b0 <release>
80104240:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104243:	83 ec 0c             	sub    $0xc,%esp
80104246:	ff 75 08             	pushl  0x8(%ebp)
80104249:	e8 a2 e9 ff ff       	call   80102bf0 <kfree>
8010424e:	83 c4 10             	add    $0x10,%esp
80104251:	eb 0f                	jmp    80104262 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104253:	8b 45 08             	mov    0x8(%ebp),%eax
80104256:	83 ec 0c             	sub    $0xc,%esp
80104259:	50                   	push   %eax
8010425a:	e8 51 15 00 00       	call   801057b0 <release>
8010425f:	83 c4 10             	add    $0x10,%esp
}
80104262:	90                   	nop
80104263:	c9                   	leave  
80104264:	c3                   	ret    

80104265 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104265:	55                   	push   %ebp
80104266:	89 e5                	mov    %esp,%ebp
80104268:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010426b:	8b 45 08             	mov    0x8(%ebp),%eax
8010426e:	83 ec 0c             	sub    $0xc,%esp
80104271:	50                   	push   %eax
80104272:	e8 d2 14 00 00       	call   80105749 <acquire>
80104277:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
8010427a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104281:	e9 ad 00 00 00       	jmp    80104333 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104286:	8b 45 08             	mov    0x8(%ebp),%eax
80104289:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010428f:	85 c0                	test   %eax,%eax
80104291:	74 0d                	je     801042a0 <pipewrite+0x3b>
80104293:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104299:	8b 40 24             	mov    0x24(%eax),%eax
8010429c:	85 c0                	test   %eax,%eax
8010429e:	74 19                	je     801042b9 <pipewrite+0x54>
        release(&p->lock);
801042a0:	8b 45 08             	mov    0x8(%ebp),%eax
801042a3:	83 ec 0c             	sub    $0xc,%esp
801042a6:	50                   	push   %eax
801042a7:	e8 04 15 00 00       	call   801057b0 <release>
801042ac:	83 c4 10             	add    $0x10,%esp
        return -1;
801042af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042b4:	e9 a8 00 00 00       	jmp    80104361 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801042b9:	8b 45 08             	mov    0x8(%ebp),%eax
801042bc:	05 34 02 00 00       	add    $0x234,%eax
801042c1:	83 ec 0c             	sub    $0xc,%esp
801042c4:	50                   	push   %eax
801042c5:	e8 70 0e 00 00       	call   8010513a <wakeup>
801042ca:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801042cd:	8b 45 08             	mov    0x8(%ebp),%eax
801042d0:	8b 55 08             	mov    0x8(%ebp),%edx
801042d3:	81 c2 38 02 00 00    	add    $0x238,%edx
801042d9:	83 ec 08             	sub    $0x8,%esp
801042dc:	50                   	push   %eax
801042dd:	52                   	push   %edx
801042de:	e8 70 0d 00 00       	call   80105053 <sleep>
801042e3:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801042e6:	8b 45 08             	mov    0x8(%ebp),%eax
801042e9:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801042ef:	8b 45 08             	mov    0x8(%ebp),%eax
801042f2:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801042f8:	05 00 02 00 00       	add    $0x200,%eax
801042fd:	39 c2                	cmp    %eax,%edx
801042ff:	74 85                	je     80104286 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104301:	8b 45 08             	mov    0x8(%ebp),%eax
80104304:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010430a:	8d 48 01             	lea    0x1(%eax),%ecx
8010430d:	8b 55 08             	mov    0x8(%ebp),%edx
80104310:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104316:	25 ff 01 00 00       	and    $0x1ff,%eax
8010431b:	89 c1                	mov    %eax,%ecx
8010431d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104320:	8b 45 0c             	mov    0xc(%ebp),%eax
80104323:	01 d0                	add    %edx,%eax
80104325:	0f b6 10             	movzbl (%eax),%edx
80104328:	8b 45 08             	mov    0x8(%ebp),%eax
8010432b:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010432f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104333:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104336:	3b 45 10             	cmp    0x10(%ebp),%eax
80104339:	7c ab                	jl     801042e6 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010433b:	8b 45 08             	mov    0x8(%ebp),%eax
8010433e:	05 34 02 00 00       	add    $0x234,%eax
80104343:	83 ec 0c             	sub    $0xc,%esp
80104346:	50                   	push   %eax
80104347:	e8 ee 0d 00 00       	call   8010513a <wakeup>
8010434c:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010434f:	8b 45 08             	mov    0x8(%ebp),%eax
80104352:	83 ec 0c             	sub    $0xc,%esp
80104355:	50                   	push   %eax
80104356:	e8 55 14 00 00       	call   801057b0 <release>
8010435b:	83 c4 10             	add    $0x10,%esp
  return n;
8010435e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104361:	c9                   	leave  
80104362:	c3                   	ret    

80104363 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104363:	55                   	push   %ebp
80104364:	89 e5                	mov    %esp,%ebp
80104366:	53                   	push   %ebx
80104367:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010436a:	8b 45 08             	mov    0x8(%ebp),%eax
8010436d:	83 ec 0c             	sub    $0xc,%esp
80104370:	50                   	push   %eax
80104371:	e8 d3 13 00 00       	call   80105749 <acquire>
80104376:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104379:	eb 3f                	jmp    801043ba <piperead+0x57>
    if(proc->killed){
8010437b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104381:	8b 40 24             	mov    0x24(%eax),%eax
80104384:	85 c0                	test   %eax,%eax
80104386:	74 19                	je     801043a1 <piperead+0x3e>
      release(&p->lock);
80104388:	8b 45 08             	mov    0x8(%ebp),%eax
8010438b:	83 ec 0c             	sub    $0xc,%esp
8010438e:	50                   	push   %eax
8010438f:	e8 1c 14 00 00       	call   801057b0 <release>
80104394:	83 c4 10             	add    $0x10,%esp
      return -1;
80104397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010439c:	e9 bf 00 00 00       	jmp    80104460 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801043a1:	8b 45 08             	mov    0x8(%ebp),%eax
801043a4:	8b 55 08             	mov    0x8(%ebp),%edx
801043a7:	81 c2 34 02 00 00    	add    $0x234,%edx
801043ad:	83 ec 08             	sub    $0x8,%esp
801043b0:	50                   	push   %eax
801043b1:	52                   	push   %edx
801043b2:	e8 9c 0c 00 00       	call   80105053 <sleep>
801043b7:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043ba:	8b 45 08             	mov    0x8(%ebp),%eax
801043bd:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801043c3:	8b 45 08             	mov    0x8(%ebp),%eax
801043c6:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043cc:	39 c2                	cmp    %eax,%edx
801043ce:	75 0d                	jne    801043dd <piperead+0x7a>
801043d0:	8b 45 08             	mov    0x8(%ebp),%eax
801043d3:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801043d9:	85 c0                	test   %eax,%eax
801043db:	75 9e                	jne    8010437b <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801043dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801043e4:	eb 49                	jmp    8010442f <piperead+0xcc>
    if(p->nread == p->nwrite)
801043e6:	8b 45 08             	mov    0x8(%ebp),%eax
801043e9:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801043ef:	8b 45 08             	mov    0x8(%ebp),%eax
801043f2:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043f8:	39 c2                	cmp    %eax,%edx
801043fa:	74 3d                	je     80104439 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801043fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104402:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104405:	8b 45 08             	mov    0x8(%ebp),%eax
80104408:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010440e:	8d 48 01             	lea    0x1(%eax),%ecx
80104411:	8b 55 08             	mov    0x8(%ebp),%edx
80104414:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010441a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010441f:	89 c2                	mov    %eax,%edx
80104421:	8b 45 08             	mov    0x8(%ebp),%eax
80104424:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104429:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010442b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010442f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104432:	3b 45 10             	cmp    0x10(%ebp),%eax
80104435:	7c af                	jl     801043e6 <piperead+0x83>
80104437:	eb 01                	jmp    8010443a <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
80104439:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010443a:	8b 45 08             	mov    0x8(%ebp),%eax
8010443d:	05 38 02 00 00       	add    $0x238,%eax
80104442:	83 ec 0c             	sub    $0xc,%esp
80104445:	50                   	push   %eax
80104446:	e8 ef 0c 00 00       	call   8010513a <wakeup>
8010444b:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010444e:	8b 45 08             	mov    0x8(%ebp),%eax
80104451:	83 ec 0c             	sub    $0xc,%esp
80104454:	50                   	push   %eax
80104455:	e8 56 13 00 00       	call   801057b0 <release>
8010445a:	83 c4 10             	add    $0x10,%esp
  return i;
8010445d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104463:	c9                   	leave  
80104464:	c3                   	ret    

80104465 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
80104465:	55                   	push   %ebp
80104466:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
80104468:	f4                   	hlt    
}
80104469:	90                   	nop
8010446a:	5d                   	pop    %ebp
8010446b:	c3                   	ret    

8010446c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010446c:	55                   	push   %ebp
8010446d:	89 e5                	mov    %esp,%ebp
8010446f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104472:	9c                   	pushf  
80104473:	58                   	pop    %eax
80104474:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104477:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010447a:	c9                   	leave  
8010447b:	c3                   	ret    

8010447c <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010447c:	55                   	push   %ebp
8010447d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010447f:	fb                   	sti    
}
80104480:	90                   	nop
80104481:	5d                   	pop    %ebp
80104482:	c3                   	ret    

80104483 <pinit>:
//static int add_to_ready(struct proc* p, enum procstate state);
//static int remove_from_embryo(struct proc* p);

void
pinit(void)
{
80104483:	55                   	push   %ebp
80104484:	89 e5                	mov    %esp,%ebp
80104486:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104489:	83 ec 08             	sub    $0x8,%esp
8010448c:	68 f4 90 10 80       	push   $0x801090f4
80104491:	68 80 39 11 80       	push   $0x80113980
80104496:	e8 8c 12 00 00       	call   80105727 <initlock>
8010449b:	83 c4 10             	add    $0x10,%esp
}
8010449e:	90                   	nop
8010449f:	c9                   	leave  
801044a0:	c3                   	ret    

801044a1 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801044a1:	55                   	push   %ebp
801044a2:	89 e5                	mov    %esp,%ebp
801044a4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801044a7:	83 ec 0c             	sub    $0xc,%esp
801044aa:	68 80 39 11 80       	push   $0x80113980
801044af:	e8 95 12 00 00       	call   80105749 <acquire>
801044b4:	83 c4 10             	add    $0x10,%esp
  //#ifndef CS333_P3P4
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044b7:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801044be:	eb 11                	jmp    801044d1 <allocproc+0x30>
    if(p->state == UNUSED)
801044c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c3:	8b 40 0c             	mov    0xc(%eax),%eax
801044c6:	85 c0                	test   %eax,%eax
801044c8:	74 3d                	je     80104507 <allocproc+0x66>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  //#ifndef CS333_P3P4
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044ca:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
801044d1:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
801044d8:	72 e6                	jb     801044c0 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  //#else
  p = ptable.pLists.free;
801044da:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
801044df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  remove_from_list(&ptable.pLists.free, p);
801044e2:	83 ec 08             	sub    $0x8,%esp
801044e5:	ff 75 f4             	pushl  -0xc(%ebp)
801044e8:	68 b4 5e 11 80       	push   $0x80115eb4
801044ed:	e8 82 11 00 00       	call   80105674 <remove_from_list>
801044f2:	83 c4 10             	add    $0x10,%esp
  assert_state(p, UNUSED);
801044f5:	83 ec 08             	sub    $0x8,%esp
801044f8:	6a 00                	push   $0x0
801044fa:	ff 75 f4             	pushl  -0xc(%ebp)
801044fd:	e8 51 11 00 00       	call   80105653 <assert_state>
80104502:	83 c4 10             	add    $0x10,%esp
  goto found;
80104505:	eb 01                	jmp    80104508 <allocproc+0x67>

  acquire(&ptable.lock);
  //#ifndef CS333_P3P4
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104507:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  // Remove the lower 3 lines once flag is working when enabled
  p = ptable.pLists.free;
80104508:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
8010450d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  remove_from_list(&ptable.pLists.free, p);
80104510:	83 ec 08             	sub    $0x8,%esp
80104513:	ff 75 f4             	pushl  -0xc(%ebp)
80104516:	68 b4 5e 11 80       	push   $0x80115eb4
8010451b:	e8 54 11 00 00       	call   80105674 <remove_from_list>
80104520:	83 c4 10             	add    $0x10,%esp
  assert_state(p, UNUSED);
80104523:	83 ec 08             	sub    $0x8,%esp
80104526:	6a 00                	push   $0x0
80104528:	ff 75 f4             	pushl  -0xc(%ebp)
8010452b:	e8 23 11 00 00       	call   80105653 <assert_state>
80104530:	83 c4 10             	add    $0x10,%esp
  p->state = EMBRYO;
80104533:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104536:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  //#ifdef CS333_P3P4
  add_to_list(&ptable.pLists.embryo, EMBRYO, p);
8010453d:	83 ec 04             	sub    $0x4,%esp
80104540:	ff 75 f4             	pushl  -0xc(%ebp)
80104543:	6a 01                	push   $0x1
80104545:	68 b8 5e 11 80       	push   $0x80115eb8
8010454a:	e8 5f 11 00 00       	call   801056ae <add_to_list>
8010454f:	83 c4 10             	add    $0x10,%esp
  //#endif
  p->pid = nextpid++;
80104552:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104557:	8d 50 01             	lea    0x1(%eax),%edx
8010455a:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104560:	89 c2                	mov    %eax,%edx
80104562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104565:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	68 80 39 11 80       	push   $0x80113980
80104570:	e8 3b 12 00 00       	call   801057b0 <release>
80104575:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104578:	e8 10 e7 ff ff       	call   80102c8d <kalloc>
8010457d:	89 c2                	mov    %eax,%edx
8010457f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104582:	89 50 08             	mov    %edx,0x8(%eax)
80104585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104588:	8b 40 08             	mov    0x8(%eax),%eax
8010458b:	85 c0                	test   %eax,%eax
8010458d:	75 4c                	jne    801045db <allocproc+0x13a>
    //#ifdef CS333_P3P4
    remove_from_list(&ptable.pLists.embryo, p);
8010458f:	83 ec 08             	sub    $0x8,%esp
80104592:	ff 75 f4             	pushl  -0xc(%ebp)
80104595:	68 b8 5e 11 80       	push   $0x80115eb8
8010459a:	e8 d5 10 00 00       	call   80105674 <remove_from_list>
8010459f:	83 c4 10             	add    $0x10,%esp
    assert_state(p, EMBRYO);
801045a2:	83 ec 08             	sub    $0x8,%esp
801045a5:	6a 01                	push   $0x1
801045a7:	ff 75 f4             	pushl  -0xc(%ebp)
801045aa:	e8 a4 10 00 00       	call   80105653 <assert_state>
801045af:	83 c4 10             	add    $0x10,%esp
    //#endif
    p->state = UNUSED;
801045b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    //#ifdef CS333_P3P4
    add_to_list(&ptable.pLists.free, UNUSED, p);
801045bc:	83 ec 04             	sub    $0x4,%esp
801045bf:	ff 75 f4             	pushl  -0xc(%ebp)
801045c2:	6a 00                	push   $0x0
801045c4:	68 b4 5e 11 80       	push   $0x80115eb4
801045c9:	e8 e0 10 00 00       	call   801056ae <add_to_list>
801045ce:	83 c4 10             	add    $0x10,%esp
    //#endif
    return 0;
801045d1:	b8 00 00 00 00       	mov    $0x0,%eax
801045d6:	e9 83 00 00 00       	jmp    8010465e <allocproc+0x1bd>
  }
  sp = p->kstack + KSTACKSIZE;
801045db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045de:	8b 40 08             	mov    0x8(%eax),%eax
801045e1:	05 00 10 00 00       	add    $0x1000,%eax
801045e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801045e9:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801045ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045f3:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801045f6:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801045fa:	ba e4 6e 10 80       	mov    $0x80106ee4,%edx
801045ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104602:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104604:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010460e:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104614:	8b 40 1c             	mov    0x1c(%eax),%eax
80104617:	83 ec 04             	sub    $0x4,%esp
8010461a:	6a 14                	push   $0x14
8010461c:	6a 00                	push   $0x0
8010461e:	50                   	push   %eax
8010461f:	e8 88 13 00 00       	call   801059ac <memset>
80104624:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010462d:	ba 0d 50 10 80       	mov    $0x8010500d,%edx
80104632:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // My code Allocate start ticks to global ticks variable
80104635:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
8010463b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463e:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total = 0; // My code p2
80104641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104644:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010464b:	00 00 00 
  p->cpu_ticks_in = 0;    // My code p2
8010464e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104651:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104658:	00 00 00 
  return p;
8010465b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010465e:	c9                   	leave  
8010465f:	c3                   	ret    

80104660 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  ptable.pLists.free = 0;
80104666:	c7 05 b4 5e 11 80 00 	movl   $0x0,0x80115eb4
8010466d:	00 00 00 
  ptable.pLists.embryo = 0;
80104670:	c7 05 b8 5e 11 80 00 	movl   $0x0,0x80115eb8
80104677:	00 00 00 
  ptable.pLists.ready = 0;
8010467a:	c7 05 bc 5e 11 80 00 	movl   $0x0,0x80115ebc
80104681:	00 00 00 
  ptable.pLists.running = 0;
80104684:	c7 05 c0 5e 11 80 00 	movl   $0x0,0x80115ec0
8010468b:	00 00 00 
  ptable.pLists.sleep = 0;
8010468e:	c7 05 c4 5e 11 80 00 	movl   $0x0,0x80115ec4
80104695:	00 00 00 
  ptable.pLists.zombie = 0;
80104698:	c7 05 c8 5e 11 80 00 	movl   $0x0,0x80115ec8
8010469f:	00 00 00 

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046a2:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801046a9:	eb 1c                	jmp    801046c7 <userinit+0x67>
    add_to_list(&ptable.pLists.free, UNUSED, p);  
801046ab:	83 ec 04             	sub    $0x4,%esp
801046ae:	ff 75 f4             	pushl  -0xc(%ebp)
801046b1:	6a 00                	push   $0x0
801046b3:	68 b4 5e 11 80       	push   $0x80115eb4
801046b8:	e8 f1 0f 00 00       	call   801056ae <add_to_list>
801046bd:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.running = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c0:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
801046c7:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
801046ce:	72 db                	jb     801046ab <userinit+0x4b>
    add_to_list(&ptable.pLists.free, UNUSED, p);  

  p = allocproc();
801046d0:	e8 cc fd ff ff       	call   801044a1 <allocproc>
801046d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801046d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046db:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
801046e0:	e8 9e 3e 00 00       	call   80108583 <setupkvm>
801046e5:	89 c2                	mov    %eax,%edx
801046e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ea:	89 50 04             	mov    %edx,0x4(%eax)
801046ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f0:	8b 40 04             	mov    0x4(%eax),%eax
801046f3:	85 c0                	test   %eax,%eax
801046f5:	75 0d                	jne    80104704 <userinit+0xa4>
    panic("userinit: out of memory?");
801046f7:	83 ec 0c             	sub    $0xc,%esp
801046fa:	68 fb 90 10 80       	push   $0x801090fb
801046ff:	e8 62 be ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104704:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470c:	8b 40 04             	mov    0x4(%eax),%eax
8010470f:	83 ec 04             	sub    $0x4,%esp
80104712:	52                   	push   %edx
80104713:	68 00 c5 10 80       	push   $0x8010c500
80104718:	50                   	push   %eax
80104719:	e8 bf 40 00 00       	call   801087dd <inituvm>
8010471e:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104724:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010472a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010472d:	8b 40 18             	mov    0x18(%eax),%eax
80104730:	83 ec 04             	sub    $0x4,%esp
80104733:	6a 4c                	push   $0x4c
80104735:	6a 00                	push   $0x0
80104737:	50                   	push   %eax
80104738:	e8 6f 12 00 00       	call   801059ac <memset>
8010473d:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104743:	8b 40 18             	mov    0x18(%eax),%eax
80104746:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010474c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474f:	8b 40 18             	mov    0x18(%eax),%eax
80104752:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475b:	8b 40 18             	mov    0x18(%eax),%eax
8010475e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104761:	8b 52 18             	mov    0x18(%edx),%edx
80104764:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104768:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010476c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476f:	8b 40 18             	mov    0x18(%eax),%eax
80104772:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104775:	8b 52 18             	mov    0x18(%edx),%edx
80104778:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010477c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104783:	8b 40 18             	mov    0x18(%eax),%eax
80104786:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010478d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104790:	8b 40 18             	mov    0x18(%eax),%eax
80104793:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010479a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479d:	8b 40 18             	mov    0x18(%eax),%eax
801047a0:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->uid = DEFAULTUID; // p2
801047a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047aa:	c7 80 80 00 00 00 0a 	movl   $0xa,0x80(%eax)
801047b1:	00 00 00 
  p->gid = DEFAULTGID; // p2
801047b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b7:	c7 80 84 00 00 00 0a 	movl   $0xa,0x84(%eax)
801047be:	00 00 00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
801047c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c4:	83 c0 6c             	add    $0x6c,%eax
801047c7:	83 ec 04             	sub    $0x4,%esp
801047ca:	6a 10                	push   $0x10
801047cc:	68 14 91 10 80       	push   $0x80109114
801047d1:	50                   	push   %eax
801047d2:	e8 d8 13 00 00       	call   80105baf <safestrcpy>
801047d7:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801047da:	83 ec 0c             	sub    $0xc,%esp
801047dd:	68 1d 91 10 80       	push   $0x8010911d
801047e2:	e8 68 dd ff ff       	call   8010254f <namei>
801047e7:	83 c4 10             	add    $0x10,%esp
801047ea:	89 c2                	mov    %eax,%edx
801047ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ef:	89 50 68             	mov    %edx,0x68(%eax)

  // Will use ifdefs when flag works
  // ifdef
  acquire(&ptable.lock);
801047f2:	83 ec 0c             	sub    $0xc,%esp
801047f5:	68 80 39 11 80       	push   $0x80113980
801047fa:	e8 4a 0f 00 00       	call   80105749 <acquire>
801047ff:	83 c4 10             	add    $0x10,%esp
  remove_from_list(&ptable.pLists.embryo, p);
80104802:	83 ec 08             	sub    $0x8,%esp
80104805:	ff 75 f4             	pushl  -0xc(%ebp)
80104808:	68 b8 5e 11 80       	push   $0x80115eb8
8010480d:	e8 62 0e 00 00       	call   80105674 <remove_from_list>
80104812:	83 c4 10             	add    $0x10,%esp
  assert_state(p, EMBRYO);
80104815:	83 ec 08             	sub    $0x8,%esp
80104818:	6a 01                	push   $0x1
8010481a:	ff 75 f4             	pushl  -0xc(%ebp)
8010481d:	e8 31 0e 00 00       	call   80105653 <assert_state>
80104822:	83 c4 10             	add    $0x10,%esp
  // endif
  p->state = RUNNABLE;
80104825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104828:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  // ifdef
  ptable.pLists.ready = p;
8010482f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104832:	a3 bc 5e 11 80       	mov    %eax,0x80115ebc
  p->next = 0;
80104837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483a:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104841:	00 00 00 
  release(&ptable.lock);
80104844:	83 ec 0c             	sub    $0xc,%esp
80104847:	68 80 39 11 80       	push   $0x80113980
8010484c:	e8 5f 0f 00 00       	call   801057b0 <release>
80104851:	83 c4 10             	add    $0x10,%esp
  // endif
  cprintf("Name: %s State: %d\n", p->name, p->state);
80104854:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104857:	8b 40 0c             	mov    0xc(%eax),%eax
8010485a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010485d:	83 c2 6c             	add    $0x6c,%edx
80104860:	83 ec 04             	sub    $0x4,%esp
80104863:	50                   	push   %eax
80104864:	52                   	push   %edx
80104865:	68 1f 91 10 80       	push   $0x8010911f
8010486a:	e8 57 bb ff ff       	call   801003c6 <cprintf>
8010486f:	83 c4 10             	add    $0x10,%esp
}
80104872:	90                   	nop
80104873:	c9                   	leave  
80104874:	c3                   	ret    

80104875 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104875:	55                   	push   %ebp
80104876:	89 e5                	mov    %esp,%ebp
80104878:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010487b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104881:	8b 00                	mov    (%eax),%eax
80104883:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104886:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010488a:	7e 31                	jle    801048bd <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010488c:	8b 55 08             	mov    0x8(%ebp),%edx
8010488f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104892:	01 c2                	add    %eax,%edx
80104894:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010489a:	8b 40 04             	mov    0x4(%eax),%eax
8010489d:	83 ec 04             	sub    $0x4,%esp
801048a0:	52                   	push   %edx
801048a1:	ff 75 f4             	pushl  -0xc(%ebp)
801048a4:	50                   	push   %eax
801048a5:	e8 80 40 00 00       	call   8010892a <allocuvm>
801048aa:	83 c4 10             	add    $0x10,%esp
801048ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048b4:	75 3e                	jne    801048f4 <growproc+0x7f>
      return -1;
801048b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048bb:	eb 59                	jmp    80104916 <growproc+0xa1>
  } else if(n < 0){
801048bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048c1:	79 31                	jns    801048f4 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801048c3:	8b 55 08             	mov    0x8(%ebp),%edx
801048c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c9:	01 c2                	add    %eax,%edx
801048cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d1:	8b 40 04             	mov    0x4(%eax),%eax
801048d4:	83 ec 04             	sub    $0x4,%esp
801048d7:	52                   	push   %edx
801048d8:	ff 75 f4             	pushl  -0xc(%ebp)
801048db:	50                   	push   %eax
801048dc:	e8 12 41 00 00       	call   801089f3 <deallocuvm>
801048e1:	83 c4 10             	add    $0x10,%esp
801048e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048eb:	75 07                	jne    801048f4 <growproc+0x7f>
      return -1;
801048ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048f2:	eb 22                	jmp    80104916 <growproc+0xa1>
  }
  proc->sz = sz;
801048f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048fd:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801048ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104905:	83 ec 0c             	sub    $0xc,%esp
80104908:	50                   	push   %eax
80104909:	e8 5c 3d 00 00       	call   8010866a <switchuvm>
8010490e:	83 c4 10             	add    $0x10,%esp
  return 0;
80104911:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104916:	c9                   	leave  
80104917:	c3                   	ret    

80104918 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104918:	55                   	push   %ebp
80104919:	89 e5                	mov    %esp,%ebp
8010491b:	57                   	push   %edi
8010491c:	56                   	push   %esi
8010491d:	53                   	push   %ebx
8010491e:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104921:	e8 7b fb ff ff       	call   801044a1 <allocproc>
80104926:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104929:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
8010492d:	75 0a                	jne    80104939 <fork+0x21>
    return -1;
8010492f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104934:	e9 60 02 00 00       	jmp    80104b99 <fork+0x281>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104939:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493f:	8b 10                	mov    (%eax),%edx
80104941:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104947:	8b 40 04             	mov    0x4(%eax),%eax
8010494a:	83 ec 08             	sub    $0x8,%esp
8010494d:	52                   	push   %edx
8010494e:	50                   	push   %eax
8010494f:	e8 3d 42 00 00       	call   80108b91 <copyuvm>
80104954:	83 c4 10             	add    $0x10,%esp
80104957:	89 c2                	mov    %eax,%edx
80104959:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010495c:	89 50 04             	mov    %edx,0x4(%eax)
8010495f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104962:	8b 40 04             	mov    0x4(%eax),%eax
80104965:	85 c0                	test   %eax,%eax
80104967:	0f 85 88 00 00 00    	jne    801049f5 <fork+0xdd>
    kfree(np->kstack);
8010496d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104970:	8b 40 08             	mov    0x8(%eax),%eax
80104973:	83 ec 0c             	sub    $0xc,%esp
80104976:	50                   	push   %eax
80104977:	e8 74 e2 ff ff       	call   80102bf0 <kfree>
8010497c:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010497f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104982:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    // ifdef
    acquire(&ptable.lock);
80104989:	83 ec 0c             	sub    $0xc,%esp
8010498c:	68 80 39 11 80       	push   $0x80113980
80104991:	e8 b3 0d 00 00       	call   80105749 <acquire>
80104996:	83 c4 10             	add    $0x10,%esp
    remove_from_list(&ptable.pLists.embryo, np);
80104999:	83 ec 08             	sub    $0x8,%esp
8010499c:	ff 75 dc             	pushl  -0x24(%ebp)
8010499f:	68 b8 5e 11 80       	push   $0x80115eb8
801049a4:	e8 cb 0c 00 00       	call   80105674 <remove_from_list>
801049a9:	83 c4 10             	add    $0x10,%esp
    assert_state(np, EMBRYO);
801049ac:	83 ec 08             	sub    $0x8,%esp
801049af:	6a 01                	push   $0x1
801049b1:	ff 75 dc             	pushl  -0x24(%ebp)
801049b4:	e8 9a 0c 00 00       	call   80105653 <assert_state>
801049b9:	83 c4 10             	add    $0x10,%esp
    // endif
    np->state = UNUSED;
801049bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801049bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    // ifdef
    add_to_list(&ptable.pLists.free, UNUSED, np);
801049c6:	83 ec 04             	sub    $0x4,%esp
801049c9:	ff 75 dc             	pushl  -0x24(%ebp)
801049cc:	6a 00                	push   $0x0
801049ce:	68 b4 5e 11 80       	push   $0x80115eb4
801049d3:	e8 d6 0c 00 00       	call   801056ae <add_to_list>
801049d8:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
801049db:	83 ec 0c             	sub    $0xc,%esp
801049de:	68 80 39 11 80       	push   $0x80113980
801049e3:	e8 c8 0d 00 00       	call   801057b0 <release>
801049e8:	83 c4 10             	add    $0x10,%esp
    // endif
    return -1;
801049eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049f0:	e9 a4 01 00 00       	jmp    80104b99 <fork+0x281>
  }
  np->sz = proc->sz;
801049f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049fb:	8b 10                	mov    (%eax),%edx
801049fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a00:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104a02:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a0c:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104a0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a12:	8b 50 18             	mov    0x18(%eax),%edx
80104a15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a1b:	8b 40 18             	mov    0x18(%eax),%eax
80104a1e:	89 c3                	mov    %eax,%ebx
80104a20:	b8 13 00 00 00       	mov    $0x13,%eax
80104a25:	89 d7                	mov    %edx,%edi
80104a27:	89 de                	mov    %ebx,%esi
80104a29:	89 c1                	mov    %eax,%ecx
80104a2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // I'm pretty sure that this is where we put the uid/gid copy
  np -> uid = proc -> uid; // p2
80104a2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a33:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104a39:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a3c:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np -> gid = proc -> gid; // p2
80104a42:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a48:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104a4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a51:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104a57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a5a:	8b 40 18             	mov    0x18(%eax),%eax
80104a5d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104a64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104a6b:	eb 43                	jmp    80104ab0 <fork+0x198>
    if(proc->ofile[i])
80104a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a76:	83 c2 08             	add    $0x8,%edx
80104a79:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a7d:	85 c0                	test   %eax,%eax
80104a7f:	74 2b                	je     80104aac <fork+0x194>
      np->ofile[i] = filedup(proc->ofile[i]);
80104a81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a8a:	83 c2 08             	add    $0x8,%edx
80104a8d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a91:	83 ec 0c             	sub    $0xc,%esp
80104a94:	50                   	push   %eax
80104a95:	e8 8d c5 ff ff       	call   80101027 <filedup>
80104a9a:	83 c4 10             	add    $0x10,%esp
80104a9d:	89 c1                	mov    %eax,%ecx
80104a9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104aa2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104aa5:	83 c2 08             	add    $0x8,%edx
80104aa8:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np -> gid = proc -> gid; // p2

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104aac:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104ab0:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104ab4:	7e b7                	jle    80104a6d <fork+0x155>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104ab6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104abc:	8b 40 68             	mov    0x68(%eax),%eax
80104abf:	83 ec 0c             	sub    $0xc,%esp
80104ac2:	50                   	push   %eax
80104ac3:	e8 8f ce ff ff       	call   80101957 <idup>
80104ac8:	83 c4 10             	add    $0x10,%esp
80104acb:	89 c2                	mov    %eax,%edx
80104acd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ad0:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104ad3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ad9:	8d 50 6c             	lea    0x6c(%eax),%edx
80104adc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104adf:	83 c0 6c             	add    $0x6c,%eax
80104ae2:	83 ec 04             	sub    $0x4,%esp
80104ae5:	6a 10                	push   $0x10
80104ae7:	52                   	push   %edx
80104ae8:	50                   	push   %eax
80104ae9:	e8 c1 10 00 00       	call   80105baf <safestrcpy>
80104aee:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104af1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104af4:	8b 40 10             	mov    0x10(%eax),%eax
80104af7:	89 45 d8             	mov    %eax,-0x28(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104afa:	83 ec 0c             	sub    $0xc,%esp
80104afd:	68 80 39 11 80       	push   $0x80113980
80104b02:	e8 42 0c 00 00       	call   80105749 <acquire>
80104b07:	83 c4 10             	add    $0x10,%esp
  // ifdef
  remove_from_list(&ptable.pLists.embryo, np);
80104b0a:	83 ec 08             	sub    $0x8,%esp
80104b0d:	ff 75 dc             	pushl  -0x24(%ebp)
80104b10:	68 b8 5e 11 80       	push   $0x80115eb8
80104b15:	e8 5a 0b 00 00       	call   80105674 <remove_from_list>
80104b1a:	83 c4 10             	add    $0x10,%esp
  assert_state(np, EMBRYO);
80104b1d:	83 ec 08             	sub    $0x8,%esp
80104b20:	6a 01                	push   $0x1
80104b22:	ff 75 dc             	pushl  -0x24(%ebp)
80104b25:	e8 29 0b 00 00       	call   80105653 <assert_state>
80104b2a:	83 c4 10             	add    $0x10,%esp
  // endif
  np->state = RUNNABLE;
80104b2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104b30:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  // ifdef
  add_to_list(&ptable.pLists.ready, RUNNABLE, np);
80104b37:	83 ec 04             	sub    $0x4,%esp
80104b3a:	ff 75 dc             	pushl  -0x24(%ebp)
80104b3d:	6a 03                	push   $0x3
80104b3f:	68 bc 5e 11 80       	push   $0x80115ebc
80104b44:	e8 65 0b 00 00       	call   801056ae <add_to_list>
80104b49:	83 c4 10             	add    $0x10,%esp
  // endif
  release(&ptable.lock);
80104b4c:	83 ec 0c             	sub    $0xc,%esp
80104b4f:	68 80 39 11 80       	push   $0x80113980
80104b54:	e8 57 0c 00 00       	call   801057b0 <release>
80104b59:	83 c4 10             	add    $0x10,%esp
  
  struct proc* t = ptable.pLists.ready;
80104b5c:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
80104b61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  while (t)
80104b64:	eb 2a                	jmp    80104b90 <fork+0x278>
  {
    cprintf("Name: %s State: %d\n", t->name, t->state);
80104b66:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b69:	8b 40 0c             	mov    0xc(%eax),%eax
80104b6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104b6f:	83 c2 6c             	add    $0x6c,%edx
80104b72:	83 ec 04             	sub    $0x4,%esp
80104b75:	50                   	push   %eax
80104b76:	52                   	push   %edx
80104b77:	68 1f 91 10 80       	push   $0x8010911f
80104b7c:	e8 45 b8 ff ff       	call   801003c6 <cprintf>
80104b81:	83 c4 10             	add    $0x10,%esp
    t = t->next;
80104b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b87:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104b8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  add_to_list(&ptable.pLists.ready, RUNNABLE, np);
  // endif
  release(&ptable.lock);
  
  struct proc* t = ptable.pLists.ready;
  while (t)
80104b90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104b94:	75 d0                	jne    80104b66 <fork+0x24e>
  {
    cprintf("Name: %s State: %d\n", t->name, t->state);
    t = t->next;
  }
  return pid;
80104b96:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b9c:	5b                   	pop    %ebx
80104b9d:	5e                   	pop    %esi
80104b9e:	5f                   	pop    %edi
80104b9f:	5d                   	pop    %ebp
80104ba0:	c3                   	ret    

80104ba1 <exit>:
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
80104ba1:	55                   	push   %ebp
80104ba2:	89 e5                	mov    %esp,%ebp
80104ba4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104ba7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bae:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104bb3:	39 c2                	cmp    %eax,%edx
80104bb5:	75 0d                	jne    80104bc4 <exit+0x23>
    panic("init exiting");
80104bb7:	83 ec 0c             	sub    $0xc,%esp
80104bba:	68 33 91 10 80       	push   $0x80109133
80104bbf:	e8 a2 b9 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104bc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104bcb:	eb 48                	jmp    80104c15 <exit+0x74>
    if(proc->ofile[fd]){
80104bcd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bd6:	83 c2 08             	add    $0x8,%edx
80104bd9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104bdd:	85 c0                	test   %eax,%eax
80104bdf:	74 30                	je     80104c11 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104be1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104be7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bea:	83 c2 08             	add    $0x8,%edx
80104bed:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104bf1:	83 ec 0c             	sub    $0xc,%esp
80104bf4:	50                   	push   %eax
80104bf5:	e8 7e c4 ff ff       	call   80101078 <fileclose>
80104bfa:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104bfd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c03:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c06:	83 c2 08             	add    $0x8,%edx
80104c09:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104c10:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c11:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c15:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c19:	7e b2                	jle    80104bcd <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104c1b:	e8 54 e9 ff ff       	call   80103574 <begin_op>
  iput(proc->cwd);
80104c20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c26:	8b 40 68             	mov    0x68(%eax),%eax
80104c29:	83 ec 0c             	sub    $0xc,%esp
80104c2c:	50                   	push   %eax
80104c2d:	e8 2f cf ff ff       	call   80101b61 <iput>
80104c32:	83 c4 10             	add    $0x10,%esp
  end_op();
80104c35:	e8 c6 e9 ff ff       	call   80103600 <end_op>
  proc->cwd = 0;
80104c3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c40:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104c47:	83 ec 0c             	sub    $0xc,%esp
80104c4a:	68 80 39 11 80       	push   $0x80113980
80104c4f:	e8 f5 0a 00 00       	call   80105749 <acquire>
80104c54:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104c57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c5d:	8b 40 14             	mov    0x14(%eax),%eax
80104c60:	83 ec 0c             	sub    $0xc,%esp
80104c63:	50                   	push   %eax
80104c64:	e8 8f 04 00 00       	call   801050f8 <wakeup1>
80104c69:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c6c:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104c73:	eb 3f                	jmp    80104cb4 <exit+0x113>
    if(p->parent == proc){
80104c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c78:	8b 50 14             	mov    0x14(%eax),%edx
80104c7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c81:	39 c2                	cmp    %eax,%edx
80104c83:	75 28                	jne    80104cad <exit+0x10c>
      p->parent = initproc;
80104c85:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8e:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c94:	8b 40 0c             	mov    0xc(%eax),%eax
80104c97:	83 f8 05             	cmp    $0x5,%eax
80104c9a:	75 11                	jne    80104cad <exit+0x10c>
        wakeup1(initproc);
80104c9c:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104ca1:	83 ec 0c             	sub    $0xc,%esp
80104ca4:	50                   	push   %eax
80104ca5:	e8 4e 04 00 00       	call   801050f8 <wakeup1>
80104caa:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cad:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104cb4:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104cbb:	72 b8                	jb     80104c75 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104cbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc3:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104cca:	e8 11 02 00 00       	call   80104ee0 <sched>
  panic("zombie exit");
80104ccf:	83 ec 0c             	sub    $0xc,%esp
80104cd2:	68 40 91 10 80       	push   $0x80109140
80104cd7:	e8 8a b8 ff ff       	call   80100566 <panic>

80104cdc <wait>:
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
80104cdc:	55                   	push   %ebp
80104cdd:	89 e5                	mov    %esp,%ebp
80104cdf:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104ce2:	83 ec 0c             	sub    $0xc,%esp
80104ce5:	68 80 39 11 80       	push   $0x80113980
80104cea:	e8 5a 0a 00 00       	call   80105749 <acquire>
80104cef:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104cf2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cf9:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104d00:	e9 a9 00 00 00       	jmp    80104dae <wait+0xd2>
      if(p->parent != proc)
80104d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d08:	8b 50 14             	mov    0x14(%eax),%edx
80104d0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d11:	39 c2                	cmp    %eax,%edx
80104d13:	0f 85 8d 00 00 00    	jne    80104da6 <wait+0xca>
        continue;
      havekids = 1;
80104d19:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d23:	8b 40 0c             	mov    0xc(%eax),%eax
80104d26:	83 f8 05             	cmp    $0x5,%eax
80104d29:	75 7c                	jne    80104da7 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d2e:	8b 40 10             	mov    0x10(%eax),%eax
80104d31:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d37:	8b 40 08             	mov    0x8(%eax),%eax
80104d3a:	83 ec 0c             	sub    $0xc,%esp
80104d3d:	50                   	push   %eax
80104d3e:	e8 ad de ff ff       	call   80102bf0 <kfree>
80104d43:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d53:	8b 40 04             	mov    0x4(%eax),%eax
80104d56:	83 ec 0c             	sub    $0xc,%esp
80104d59:	50                   	push   %eax
80104d5a:	e8 51 3d 00 00       	call   80108ab0 <freevm>
80104d5f:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d65:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d79:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d83:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d8a:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104d91:	83 ec 0c             	sub    $0xc,%esp
80104d94:	68 80 39 11 80       	push   $0x80113980
80104d99:	e8 12 0a 00 00       	call   801057b0 <release>
80104d9e:	83 c4 10             	add    $0x10,%esp
        return pid;
80104da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104da4:	eb 5b                	jmp    80104e01 <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104da6:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104da7:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104dae:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104db5:	0f 82 4a ff ff ff    	jb     80104d05 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104dbf:	74 0d                	je     80104dce <wait+0xf2>
80104dc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc7:	8b 40 24             	mov    0x24(%eax),%eax
80104dca:	85 c0                	test   %eax,%eax
80104dcc:	74 17                	je     80104de5 <wait+0x109>
      release(&ptable.lock);
80104dce:	83 ec 0c             	sub    $0xc,%esp
80104dd1:	68 80 39 11 80       	push   $0x80113980
80104dd6:	e8 d5 09 00 00       	call   801057b0 <release>
80104ddb:	83 c4 10             	add    $0x10,%esp
      return -1;
80104dde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de3:	eb 1c                	jmp    80104e01 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104de5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104deb:	83 ec 08             	sub    $0x8,%esp
80104dee:	68 80 39 11 80       	push   $0x80113980
80104df3:	50                   	push   %eax
80104df4:	e8 5a 02 00 00       	call   80105053 <sleep>
80104df9:	83 c4 10             	add    $0x10,%esp
  }
80104dfc:	e9 f1 fe ff ff       	jmp    80104cf2 <wait+0x16>
}
80104e01:	c9                   	leave  
80104e02:	c3                   	ret    

80104e03 <scheduler>:
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
80104e03:	55                   	push   %ebp
80104e04:	89 e5                	mov    %esp,%ebp
80104e06:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104e09:	e8 6e f6 ff ff       	call   8010447c <sti>

    idle = 1;  // assume idle unless we schedule a process
80104e0e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104e15:	83 ec 0c             	sub    $0xc,%esp
80104e18:	68 80 39 11 80       	push   $0x80113980
80104e1d:	e8 27 09 00 00       	call   80105749 <acquire>
80104e22:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e25:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104e2c:	eb 7c                	jmp    80104eaa <scheduler+0xa7>
      if(p->state != RUNNABLE)
80104e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e31:	8b 40 0c             	mov    0xc(%eax),%eax
80104e34:	83 f8 03             	cmp    $0x3,%eax
80104e37:	75 69                	jne    80104ea2 <scheduler+0x9f>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
80104e39:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      proc = p;
80104e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e43:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104e49:	83 ec 0c             	sub    $0xc,%esp
80104e4c:	ff 75 f4             	pushl  -0xc(%ebp)
80104e4f:	e8 16 38 00 00       	call   8010866a <switchuvm>
80104e54:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5a:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      p->cpu_ticks_in = ticks; // My code p2
80104e61:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
80104e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e6a:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
      swtch(&cpu->scheduler, proc->context);
80104e70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e76:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e79:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104e80:	83 c2 04             	add    $0x4,%edx
80104e83:	83 ec 08             	sub    $0x8,%esp
80104e86:	50                   	push   %eax
80104e87:	52                   	push   %edx
80104e88:	e8 93 0d 00 00       	call   80105c20 <swtch>
80104e8d:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104e90:	e8 b8 37 00 00       	call   8010864d <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104e95:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104e9c:	00 00 00 00 
80104ea0:	eb 01                	jmp    80104ea3 <scheduler+0xa0>
    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104ea2:	90                   	nop
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ea3:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104eaa:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104eb1:	0f 82 77 ff ff ff    	jb     80104e2e <scheduler+0x2b>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104eb7:	83 ec 0c             	sub    $0xc,%esp
80104eba:	68 80 39 11 80       	push   $0x80113980
80104ebf:	e8 ec 08 00 00       	call   801057b0 <release>
80104ec4:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
80104ec7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104ecb:	0f 84 38 ff ff ff    	je     80104e09 <scheduler+0x6>
      sti();
80104ed1:	e8 a6 f5 ff ff       	call   8010447c <sti>
      hlt();
80104ed6:	e8 8a f5 ff ff       	call   80104465 <hlt>
    }
  }
80104edb:	e9 29 ff ff ff       	jmp    80104e09 <scheduler+0x6>

80104ee0 <sched>:
// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	53                   	push   %ebx
80104ee4:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80104ee7:	83 ec 0c             	sub    $0xc,%esp
80104eea:	68 80 39 11 80       	push   $0x80113980
80104eef:	e8 88 09 00 00       	call   8010587c <holding>
80104ef4:	83 c4 10             	add    $0x10,%esp
80104ef7:	85 c0                	test   %eax,%eax
80104ef9:	75 0d                	jne    80104f08 <sched+0x28>
    panic("sched ptable.lock");
80104efb:	83 ec 0c             	sub    $0xc,%esp
80104efe:	68 4c 91 10 80       	push   $0x8010914c
80104f03:	e8 5e b6 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104f08:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f0e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104f14:	83 f8 01             	cmp    $0x1,%eax
80104f17:	74 0d                	je     80104f26 <sched+0x46>
    panic("sched locks");
80104f19:	83 ec 0c             	sub    $0xc,%esp
80104f1c:	68 5e 91 10 80       	push   $0x8010915e
80104f21:	e8 40 b6 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104f26:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f2c:	8b 40 0c             	mov    0xc(%eax),%eax
80104f2f:	83 f8 04             	cmp    $0x4,%eax
80104f32:	75 0d                	jne    80104f41 <sched+0x61>
    panic("sched running");
80104f34:	83 ec 0c             	sub    $0xc,%esp
80104f37:	68 6a 91 10 80       	push   $0x8010916a
80104f3c:	e8 25 b6 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104f41:	e8 26 f5 ff ff       	call   8010446c <readeflags>
80104f46:	25 00 02 00 00       	and    $0x200,%eax
80104f4b:	85 c0                	test   %eax,%eax
80104f4d:	74 0d                	je     80104f5c <sched+0x7c>
    panic("sched interruptible");
80104f4f:	83 ec 0c             	sub    $0xc,%esp
80104f52:	68 78 91 10 80       	push   $0x80109178
80104f57:	e8 0a b6 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104f5c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f62:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104f68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // My code p2
80104f6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f71:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f78:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80104f7e:	8b 1d e0 66 11 80    	mov    0x801166e0,%ebx
80104f84:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f8b:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80104f91:	29 d3                	sub    %edx,%ebx
80104f93:	89 da                	mov    %ebx,%edx
80104f95:	01 ca                	add    %ecx,%edx
80104f97:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
80104f9d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fa3:	8b 40 04             	mov    0x4(%eax),%eax
80104fa6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104fad:	83 c2 1c             	add    $0x1c,%edx
80104fb0:	83 ec 08             	sub    $0x8,%esp
80104fb3:	50                   	push   %eax
80104fb4:	52                   	push   %edx
80104fb5:	e8 66 0c 00 00       	call   80105c20 <swtch>
80104fba:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104fbd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc6:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104fcc:	90                   	nop
80104fcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fd0:	c9                   	leave  
80104fd1:	c3                   	ret    

80104fd2 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104fd2:	55                   	push   %ebp
80104fd3:	89 e5                	mov    %esp,%ebp
80104fd5:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104fd8:	83 ec 0c             	sub    $0xc,%esp
80104fdb:	68 80 39 11 80       	push   $0x80113980
80104fe0:	e8 64 07 00 00       	call   80105749 <acquire>
80104fe5:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104fe8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fee:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104ff5:	e8 e6 fe ff ff       	call   80104ee0 <sched>
  release(&ptable.lock);
80104ffa:	83 ec 0c             	sub    $0xc,%esp
80104ffd:	68 80 39 11 80       	push   $0x80113980
80105002:	e8 a9 07 00 00       	call   801057b0 <release>
80105007:	83 c4 10             	add    $0x10,%esp
}
8010500a:	90                   	nop
8010500b:	c9                   	leave  
8010500c:	c3                   	ret    

8010500d <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010500d:	55                   	push   %ebp
8010500e:	89 e5                	mov    %esp,%ebp
80105010:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105013:	83 ec 0c             	sub    $0xc,%esp
80105016:	68 80 39 11 80       	push   $0x80113980
8010501b:	e8 90 07 00 00       	call   801057b0 <release>
80105020:	83 c4 10             	add    $0x10,%esp

  if (first) {
80105023:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80105028:	85 c0                	test   %eax,%eax
8010502a:	74 24                	je     80105050 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
8010502c:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80105033:	00 00 00 
    iinit(ROOTDEV);
80105036:	83 ec 0c             	sub    $0xc,%esp
80105039:	6a 01                	push   $0x1
8010503b:	e8 25 c6 ff ff       	call   80101665 <iinit>
80105040:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80105043:	83 ec 0c             	sub    $0xc,%esp
80105046:	6a 01                	push   $0x1
80105048:	e8 09 e3 ff ff       	call   80103356 <initlog>
8010504d:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105050:	90                   	nop
80105051:	c9                   	leave  
80105052:	c3                   	ret    

80105053 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105053:	55                   	push   %ebp
80105054:	89 e5                	mov    %esp,%ebp
80105056:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80105059:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010505f:	85 c0                	test   %eax,%eax
80105061:	75 0d                	jne    80105070 <sleep+0x1d>
    panic("sleep");
80105063:	83 ec 0c             	sub    $0xc,%esp
80105066:	68 8c 91 10 80       	push   $0x8010918c
8010506b:	e8 f6 b4 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80105070:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80105077:	74 24                	je     8010509d <sleep+0x4a>
    acquire(&ptable.lock);
80105079:	83 ec 0c             	sub    $0xc,%esp
8010507c:	68 80 39 11 80       	push   $0x80113980
80105081:	e8 c3 06 00 00       	call   80105749 <acquire>
80105086:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105089:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010508d:	74 0e                	je     8010509d <sleep+0x4a>
8010508f:	83 ec 0c             	sub    $0xc,%esp
80105092:	ff 75 0c             	pushl  0xc(%ebp)
80105095:	e8 16 07 00 00       	call   801057b0 <release>
8010509a:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
8010509d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050a3:	8b 55 08             	mov    0x8(%ebp),%edx
801050a6:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801050a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050af:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801050b6:	e8 25 fe ff ff       	call   80104ee0 <sched>

  // Tidy up.
  proc->chan = 0;
801050bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050c1:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
801050c8:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
801050cf:	74 24                	je     801050f5 <sleep+0xa2>
    release(&ptable.lock);
801050d1:	83 ec 0c             	sub    $0xc,%esp
801050d4:	68 80 39 11 80       	push   $0x80113980
801050d9:	e8 d2 06 00 00       	call   801057b0 <release>
801050de:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
801050e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801050e5:	74 0e                	je     801050f5 <sleep+0xa2>
801050e7:	83 ec 0c             	sub    $0xc,%esp
801050ea:	ff 75 0c             	pushl  0xc(%ebp)
801050ed:	e8 57 06 00 00       	call   80105749 <acquire>
801050f2:	83 c4 10             	add    $0x10,%esp
  }
}
801050f5:	90                   	nop
801050f6:	c9                   	leave  
801050f7:	c3                   	ret    

801050f8 <wakeup1>:
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801050f8:	55                   	push   %ebp
801050f9:	89 e5                	mov    %esp,%ebp
801050fb:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050fe:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80105105:	eb 27                	jmp    8010512e <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80105107:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010510a:	8b 40 0c             	mov    0xc(%eax),%eax
8010510d:	83 f8 02             	cmp    $0x2,%eax
80105110:	75 15                	jne    80105127 <wakeup1+0x2f>
80105112:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105115:	8b 40 20             	mov    0x20(%eax),%eax
80105118:	3b 45 08             	cmp    0x8(%ebp),%eax
8010511b:	75 0a                	jne    80105127 <wakeup1+0x2f>
      p->state = RUNNABLE;
8010511d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105120:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105127:	81 45 fc 94 00 00 00 	addl   $0x94,-0x4(%ebp)
8010512e:	81 7d fc b4 5e 11 80 	cmpl   $0x80115eb4,-0x4(%ebp)
80105135:	72 d0                	jb     80105107 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80105137:	90                   	nop
80105138:	c9                   	leave  
80105139:	c3                   	ret    

8010513a <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010513a:	55                   	push   %ebp
8010513b:	89 e5                	mov    %esp,%ebp
8010513d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105140:	83 ec 0c             	sub    $0xc,%esp
80105143:	68 80 39 11 80       	push   $0x80113980
80105148:	e8 fc 05 00 00       	call   80105749 <acquire>
8010514d:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105150:	83 ec 0c             	sub    $0xc,%esp
80105153:	ff 75 08             	pushl  0x8(%ebp)
80105156:	e8 9d ff ff ff       	call   801050f8 <wakeup1>
8010515b:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010515e:	83 ec 0c             	sub    $0xc,%esp
80105161:	68 80 39 11 80       	push   $0x80113980
80105166:	e8 45 06 00 00       	call   801057b0 <release>
8010516b:	83 c4 10             	add    $0x10,%esp
}
8010516e:	90                   	nop
8010516f:	c9                   	leave  
80105170:	c3                   	ret    

80105171 <kill>:
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
80105171:	55                   	push   %ebp
80105172:	89 e5                	mov    %esp,%ebp
80105174:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80105177:	83 ec 0c             	sub    $0xc,%esp
8010517a:	68 80 39 11 80       	push   $0x80113980
8010517f:	e8 c5 05 00 00       	call   80105749 <acquire>
80105184:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105187:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010518e:	eb 4a                	jmp    801051da <kill+0x69>
    if(p->pid == pid){
80105190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105193:	8b 50 10             	mov    0x10(%eax),%edx
80105196:	8b 45 08             	mov    0x8(%ebp),%eax
80105199:	39 c2                	cmp    %eax,%edx
8010519b:	75 36                	jne    801051d3 <kill+0x62>
      p->killed = 1;
8010519d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a0:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801051a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051aa:	8b 40 0c             	mov    0xc(%eax),%eax
801051ad:	83 f8 02             	cmp    $0x2,%eax
801051b0:	75 0a                	jne    801051bc <kill+0x4b>
        p->state = RUNNABLE;
801051b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801051bc:	83 ec 0c             	sub    $0xc,%esp
801051bf:	68 80 39 11 80       	push   $0x80113980
801051c4:	e8 e7 05 00 00       	call   801057b0 <release>
801051c9:	83 c4 10             	add    $0x10,%esp
      return 0;
801051cc:	b8 00 00 00 00       	mov    $0x0,%eax
801051d1:	eb 25                	jmp    801051f8 <kill+0x87>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051d3:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
801051da:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
801051e1:	72 ad                	jb     80105190 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801051e3:	83 ec 0c             	sub    $0xc,%esp
801051e6:	68 80 39 11 80       	push   $0x80113980
801051eb:	e8 c0 05 00 00       	call   801057b0 <release>
801051f0:	83 c4 10             	add    $0x10,%esp
  return -1;
801051f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f8:	c9                   	leave  
801051f9:	c3                   	ret    

801051fa <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801051fa:	55                   	push   %ebp
801051fb:	89 e5                	mov    %esp,%ebp
801051fd:	53                   	push   %ebx
801051fe:	83 ec 54             	sub    $0x54,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
80105201:	83 ec 08             	sub    $0x8,%esp
80105204:	68 bc 91 10 80       	push   $0x801091bc
80105209:	68 c0 91 10 80       	push   $0x801091c0
8010520e:	68 c4 91 10 80       	push   $0x801091c4
80105213:	68 cc 91 10 80       	push   $0x801091cc
80105218:	68 d2 91 10 80       	push   $0x801091d2
8010521d:	68 d7 91 10 80       	push   $0x801091d7
80105222:	68 db 91 10 80       	push   $0x801091db
80105227:	68 df 91 10 80       	push   $0x801091df
8010522c:	68 e4 91 10 80       	push   $0x801091e4
80105231:	68 e8 91 10 80       	push   $0x801091e8
80105236:	e8 8b b1 ff ff       	call   801003c6 <cprintf>
8010523b:	83 c4 30             	add    $0x30,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010523e:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80105245:	e9 2a 02 00 00       	jmp    80105474 <procdump+0x27a>
    if(p->state == UNUSED)
8010524a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010524d:	8b 40 0c             	mov    0xc(%eax),%eax
80105250:	85 c0                	test   %eax,%eax
80105252:	0f 84 14 02 00 00    	je     8010546c <procdump+0x272>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105258:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010525b:	8b 40 0c             	mov    0xc(%eax),%eax
8010525e:	83 f8 05             	cmp    $0x5,%eax
80105261:	77 23                	ja     80105286 <procdump+0x8c>
80105263:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105266:	8b 40 0c             	mov    0xc(%eax),%eax
80105269:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80105270:	85 c0                	test   %eax,%eax
80105272:	74 12                	je     80105286 <procdump+0x8c>
      state = states[p->state];
80105274:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105277:	8b 40 0c             	mov    0xc(%eax),%eax
8010527a:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80105281:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105284:	eb 07                	jmp    8010528d <procdump+0x93>
    else
      state = "???";
80105286:	c7 45 ec 0c 92 10 80 	movl   $0x8010920c,-0x14(%ebp)
    uint seconds = (ticks - p->start_ticks)/100;
8010528d:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
80105293:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105296:	8b 40 7c             	mov    0x7c(%eax),%eax
80105299:	29 c2                	sub    %eax,%edx
8010529b:	89 d0                	mov    %edx,%eax
8010529d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801052a2:	f7 e2                	mul    %edx
801052a4:	89 d0                	mov    %edx,%eax
801052a6:	c1 e8 05             	shr    $0x5,%eax
801052a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint partial_seconds = (ticks - p->start_ticks)%100;
801052ac:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
801052b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052b5:	8b 40 7c             	mov    0x7c(%eax),%eax
801052b8:	89 d1                	mov    %edx,%ecx
801052ba:	29 c1                	sub    %eax,%ecx
801052bc:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801052c1:	89 c8                	mov    %ecx,%eax
801052c3:	f7 e2                	mul    %edx
801052c5:	89 d0                	mov    %edx,%eax
801052c7:	c1 e8 05             	shr    $0x5,%eax
801052ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801052cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801052d0:	6b c0 64             	imul   $0x64,%eax,%eax
801052d3:	29 c1                	sub    %eax,%ecx
801052d5:	89 c8                	mov    %ecx,%eax
801052d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("%d\t %s\t %d\t %d\t", p->pid, p->name, p->uid, p->gid);
801052da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052dd:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801052e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052e6:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801052ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052ef:	8d 58 6c             	lea    0x6c(%eax),%ebx
801052f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052f5:	8b 40 10             	mov    0x10(%eax),%eax
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	51                   	push   %ecx
801052fc:	52                   	push   %edx
801052fd:	53                   	push   %ebx
801052fe:	50                   	push   %eax
801052ff:	68 10 92 10 80       	push   $0x80109210
80105304:	e8 bd b0 ff ff       	call   801003c6 <cprintf>
80105309:	83 c4 20             	add    $0x20,%esp
    if (p->parent)
8010530c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010530f:	8b 40 14             	mov    0x14(%eax),%eax
80105312:	85 c0                	test   %eax,%eax
80105314:	74 1c                	je     80105332 <procdump+0x138>
      cprintf("%d\t", p->parent->pid);
80105316:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105319:	8b 40 14             	mov    0x14(%eax),%eax
8010531c:	8b 40 10             	mov    0x10(%eax),%eax
8010531f:	83 ec 08             	sub    $0x8,%esp
80105322:	50                   	push   %eax
80105323:	68 20 92 10 80       	push   $0x80109220
80105328:	e8 99 b0 ff ff       	call   801003c6 <cprintf>
8010532d:	83 c4 10             	add    $0x10,%esp
80105330:	eb 17                	jmp    80105349 <procdump+0x14f>
    else
      cprintf("%d\t", p->pid);
80105332:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105335:	8b 40 10             	mov    0x10(%eax),%eax
80105338:	83 ec 08             	sub    $0x8,%esp
8010533b:	50                   	push   %eax
8010533c:	68 20 92 10 80       	push   $0x80109220
80105341:	e8 80 b0 ff ff       	call   801003c6 <cprintf>
80105346:	83 c4 10             	add    $0x10,%esp
    cprintf(" %s\t %d.", state, seconds);
80105349:	83 ec 04             	sub    $0x4,%esp
8010534c:	ff 75 e8             	pushl  -0x18(%ebp)
8010534f:	ff 75 ec             	pushl  -0x14(%ebp)
80105352:	68 24 92 10 80       	push   $0x80109224
80105357:	e8 6a b0 ff ff       	call   801003c6 <cprintf>
8010535c:	83 c4 10             	add    $0x10,%esp
    if (partial_seconds < 10)
8010535f:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
80105363:	77 10                	ja     80105375 <procdump+0x17b>
	cprintf("0");
80105365:	83 ec 0c             	sub    $0xc,%esp
80105368:	68 2d 92 10 80       	push   $0x8010922d
8010536d:	e8 54 b0 ff ff       	call   801003c6 <cprintf>
80105372:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t", partial_seconds);
80105375:	83 ec 08             	sub    $0x8,%esp
80105378:	ff 75 e4             	pushl  -0x1c(%ebp)
8010537b:	68 20 92 10 80       	push   $0x80109220
80105380:	e8 41 b0 ff ff       	call   801003c6 <cprintf>
80105385:	83 c4 10             	add    $0x10,%esp
    uint cpu_seconds = p->cpu_ticks_total/100;
80105388:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010538b:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105391:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105396:	f7 e2                	mul    %edx
80105398:	89 d0                	mov    %edx,%eax
8010539a:	c1 e8 05             	shr    $0x5,%eax
8010539d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    uint cpu_partial_seconds = p->cpu_ticks_total%100;
801053a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053a3:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
801053a9:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801053ae:	89 c8                	mov    %ecx,%eax
801053b0:	f7 e2                	mul    %edx
801053b2:	89 d0                	mov    %edx,%eax
801053b4:	c1 e8 05             	shr    $0x5,%eax
801053b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801053ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
801053bd:	6b c0 64             	imul   $0x64,%eax,%eax
801053c0:	29 c1                	sub    %eax,%ecx
801053c2:	89 c8                	mov    %ecx,%eax
801053c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (cpu_partial_seconds < 10)
801053c7:	83 7d dc 09          	cmpl   $0x9,-0x24(%ebp)
801053cb:	77 18                	ja     801053e5 <procdump+0x1eb>
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
801053cd:	83 ec 04             	sub    $0x4,%esp
801053d0:	ff 75 dc             	pushl  -0x24(%ebp)
801053d3:	ff 75 e0             	pushl  -0x20(%ebp)
801053d6:	68 2f 92 10 80       	push   $0x8010922f
801053db:	e8 e6 af ff ff       	call   801003c6 <cprintf>
801053e0:	83 c4 10             	add    $0x10,%esp
801053e3:	eb 16                	jmp    801053fb <procdump+0x201>
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
801053e5:	83 ec 04             	sub    $0x4,%esp
801053e8:	ff 75 dc             	pushl  -0x24(%ebp)
801053eb:	ff 75 e0             	pushl  -0x20(%ebp)
801053ee:	68 39 92 10 80       	push   $0x80109239
801053f3:	e8 ce af ff ff       	call   801003c6 <cprintf>
801053f8:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801053fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053fe:	8b 40 0c             	mov    0xc(%eax),%eax
80105401:	83 f8 02             	cmp    $0x2,%eax
80105404:	75 54                	jne    8010545a <procdump+0x260>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105406:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105409:	8b 40 1c             	mov    0x1c(%eax),%eax
8010540c:	8b 40 0c             	mov    0xc(%eax),%eax
8010540f:	83 c0 08             	add    $0x8,%eax
80105412:	89 c2                	mov    %eax,%edx
80105414:	83 ec 08             	sub    $0x8,%esp
80105417:	8d 45 b4             	lea    -0x4c(%ebp),%eax
8010541a:	50                   	push   %eax
8010541b:	52                   	push   %edx
8010541c:	e8 e1 03 00 00       	call   80105802 <getcallerpcs>
80105421:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105424:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010542b:	eb 1c                	jmp    80105449 <procdump+0x24f>
        cprintf(" %p", pc[i]);
8010542d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105430:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
80105434:	83 ec 08             	sub    $0x8,%esp
80105437:	50                   	push   %eax
80105438:	68 42 92 10 80       	push   $0x80109242
8010543d:	e8 84 af ff ff       	call   801003c6 <cprintf>
80105442:	83 c4 10             	add    $0x10,%esp
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105445:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105449:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010544d:	7f 0b                	jg     8010545a <procdump+0x260>
8010544f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105452:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
80105456:	85 c0                	test   %eax,%eax
80105458:	75 d3                	jne    8010542d <procdump+0x233>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010545a:	83 ec 0c             	sub    $0xc,%esp
8010545d:	68 46 92 10 80       	push   $0x80109246
80105462:	e8 5f af ff ff       	call   801003c6 <cprintf>
80105467:	83 c4 10             	add    $0x10,%esp
8010546a:	eb 01                	jmp    8010546d <procdump+0x273>
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
8010546c:	90                   	nop
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010546d:	81 45 f0 94 00 00 00 	addl   $0x94,-0x10(%ebp)
80105474:	81 7d f0 b4 5e 11 80 	cmpl   $0x80115eb4,-0x10(%ebp)
8010547b:	0f 82 c9 fd ff ff    	jb     8010524a <procdump+0x50>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105481:	90                   	nop
80105482:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105485:	c9                   	leave  
80105486:	c3                   	ret    

80105487 <free_length>:

// Counts the number of procs in the free list when ctrl-f is pressed
void
free_length()
{
80105487:	55                   	push   %ebp
80105488:	89 e5                	mov    %esp,%ebp
8010548a:	83 ec 18             	sub    $0x18,%esp
  struct proc* f = ptable.pLists.free;
8010548d:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80105492:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
80105495:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (!f)
8010549c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054a0:	75 25                	jne    801054c7 <free_length+0x40>
    cprintf("Free List Size: %d\n", count);
801054a2:	83 ec 08             	sub    $0x8,%esp
801054a5:	ff 75 f0             	pushl  -0x10(%ebp)
801054a8:	68 48 92 10 80       	push   $0x80109248
801054ad:	e8 14 af ff ff       	call   801003c6 <cprintf>
801054b2:	83 c4 10             	add    $0x10,%esp
  while (f)
801054b5:	eb 10                	jmp    801054c7 <free_length+0x40>
  {
    ++count;
801054b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    f = f->next;
801054bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054be:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801054c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc* f = ptable.pLists.free;
  int count = 0;
  if (!f)
    cprintf("Free List Size: %d\n", count);
  while (f)
801054c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054cb:	75 ea                	jne    801054b7 <free_length+0x30>
  {
    ++count;
    f = f->next;
  }
  cprintf("Free List Size: %d\n", count);
801054cd:	83 ec 08             	sub    $0x8,%esp
801054d0:	ff 75 f0             	pushl  -0x10(%ebp)
801054d3:	68 48 92 10 80       	push   $0x80109248
801054d8:	e8 e9 ae ff ff       	call   801003c6 <cprintf>
801054dd:	83 c4 10             	add    $0x10,%esp
}
801054e0:	90                   	nop
801054e1:	c9                   	leave  
801054e2:	c3                   	ret    

801054e3 <getproc_helper>:

int
getproc_helper(int m, struct uproc* table)
{
801054e3:	55                   	push   %ebp
801054e4:	89 e5                	mov    %esp,%ebp
801054e6:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int i = 0;
801054e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
801054f0:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801054f7:	e9 3d 01 00 00       	jmp    80105639 <getproc_helper+0x156>
  {
    if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
801054fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ff:	8b 40 0c             	mov    0xc(%eax),%eax
80105502:	83 f8 04             	cmp    $0x4,%eax
80105505:	74 1a                	je     80105521 <getproc_helper+0x3e>
80105507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550a:	8b 40 0c             	mov    0xc(%eax),%eax
8010550d:	83 f8 03             	cmp    $0x3,%eax
80105510:	74 0f                	je     80105521 <getproc_helper+0x3e>
80105512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105515:	8b 40 0c             	mov    0xc(%eax),%eax
80105518:	83 f8 02             	cmp    $0x2,%eax
8010551b:	0f 85 11 01 00 00    	jne    80105632 <getproc_helper+0x14f>
    {
      table[i].pid = p->pid;
80105521:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105524:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105527:	8b 45 0c             	mov    0xc(%ebp),%eax
8010552a:	01 c2                	add    %eax,%edx
8010552c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010552f:	8b 40 10             	mov    0x10(%eax),%eax
80105532:	89 02                	mov    %eax,(%edx)
      table[i].uid = p->uid;
80105534:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105537:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010553a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010553d:	01 c2                	add    %eax,%edx
8010553f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105542:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105548:	89 42 04             	mov    %eax,0x4(%edx)
      table[i].gid = p->gid;
8010554b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010554e:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105551:	8b 45 0c             	mov    0xc(%ebp),%eax
80105554:	01 c2                	add    %eax,%edx
80105556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105559:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010555f:	89 42 08             	mov    %eax,0x8(%edx)
      if (p->parent)
80105562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105565:	8b 40 14             	mov    0x14(%eax),%eax
80105568:	85 c0                	test   %eax,%eax
8010556a:	74 19                	je     80105585 <getproc_helper+0xa2>
        table[i].ppid = p->parent->pid;
8010556c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010556f:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105572:	8b 45 0c             	mov    0xc(%ebp),%eax
80105575:	01 c2                	add    %eax,%edx
80105577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010557a:	8b 40 14             	mov    0x14(%eax),%eax
8010557d:	8b 40 10             	mov    0x10(%eax),%eax
80105580:	89 42 0c             	mov    %eax,0xc(%edx)
80105583:	eb 14                	jmp    80105599 <getproc_helper+0xb6>
      else
        table[i].ppid = p->pid;
80105585:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105588:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010558b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010558e:	01 c2                	add    %eax,%edx
80105590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105593:	8b 40 10             	mov    0x10(%eax),%eax
80105596:	89 42 0c             	mov    %eax,0xc(%edx)
      table[i].elapsed_ticks = (ticks - p->start_ticks);
80105599:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010559c:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010559f:	8b 45 0c             	mov    0xc(%ebp),%eax
801055a2:	01 c2                	add    %eax,%edx
801055a4:	8b 0d e0 66 11 80    	mov    0x801166e0,%ecx
801055aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ad:	8b 40 7c             	mov    0x7c(%eax),%eax
801055b0:	29 c1                	sub    %eax,%ecx
801055b2:	89 c8                	mov    %ecx,%eax
801055b4:	89 42 10             	mov    %eax,0x10(%edx)
      table[i].CPU_total_ticks = p->cpu_ticks_total;
801055b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ba:	6b d0 5c             	imul   $0x5c,%eax,%edx
801055bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801055c0:	01 c2                	add    %eax,%edx
801055c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c5:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801055cb:	89 42 14             	mov    %eax,0x14(%edx)
      table[i].size = p->sz;
801055ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055d1:	6b d0 5c             	imul   $0x5c,%eax,%edx
801055d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801055d7:	01 c2                	add    %eax,%edx
801055d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055dc:	8b 00                	mov    (%eax),%eax
801055de:	89 42 38             	mov    %eax,0x38(%edx)
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
801055e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e4:	8b 40 0c             	mov    0xc(%eax),%eax
801055e7:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801055ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055f1:	6b ca 5c             	imul   $0x5c,%edx,%ecx
801055f4:	8b 55 0c             	mov    0xc(%ebp),%edx
801055f7:	01 ca                	add    %ecx,%edx
801055f9:	83 c2 18             	add    $0x18,%edx
801055fc:	83 ec 04             	sub    $0x4,%esp
801055ff:	6a 05                	push   $0x5
80105601:	50                   	push   %eax
80105602:	52                   	push   %edx
80105603:	e8 4f 05 00 00       	call   80105b57 <strncpy>
80105608:	83 c4 10             	add    $0x10,%esp
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
8010560b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010560e:	8d 50 6c             	lea    0x6c(%eax),%edx
80105611:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105614:	6b c8 5c             	imul   $0x5c,%eax,%ecx
80105617:	8b 45 0c             	mov    0xc(%ebp),%eax
8010561a:	01 c8                	add    %ecx,%eax
8010561c:	83 c0 3c             	add    $0x3c,%eax
8010561f:	83 ec 04             	sub    $0x4,%esp
80105622:	6a 11                	push   $0x11
80105624:	52                   	push   %edx
80105625:	50                   	push   %eax
80105626:	e8 2c 05 00 00       	call   80105b57 <strncpy>
8010562b:	83 c4 10             	add    $0x10,%esp
      i++;
8010562e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
int
getproc_helper(int m, struct uproc* table)
{
  struct proc* p;
  int i = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
80105632:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80105639:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80105640:	73 0c                	jae    8010564e <getproc_helper+0x16b>
80105642:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105645:	3b 45 08             	cmp    0x8(%ebp),%eax
80105648:	0f 8c ae fe ff ff    	jl     801054fc <getproc_helper+0x19>
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
      i++;
    }
  }
  return i;  
8010564e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105651:	c9                   	leave  
80105652:	c3                   	ret    

80105653 <assert_state>:

// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
80105653:	55                   	push   %ebp
80105654:	89 e5                	mov    %esp,%ebp
80105656:	83 ec 08             	sub    $0x8,%esp
  if (p->state == state)
80105659:	8b 45 08             	mov    0x8(%ebp),%eax
8010565c:	8b 40 0c             	mov    0xc(%eax),%eax
8010565f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105662:	74 0d                	je     80105671 <assert_state+0x1e>
    return;
  panic("ERROR: States do not match.");
80105664:	83 ec 0c             	sub    $0xc,%esp
80105667:	68 5c 92 10 80       	push   $0x8010925c
8010566c:	e8 f5 ae ff ff       	call   80100566 <panic>
// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
  if (p->state == state)
    return;
80105671:	90                   	nop
  panic("ERROR: States do not match.");
}
80105672:	c9                   	leave  
80105673:	c3                   	ret    

80105674 <remove_from_list>:

// Implementation of remove_from_list
static int
remove_from_list(struct proc** sList, struct proc* p)
{
80105674:	55                   	push   %ebp
80105675:	89 e5                	mov    %esp,%ebp
  if (!sList)
80105677:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010567b:	75 07                	jne    80105684 <remove_from_list+0x10>
    return -1;
8010567d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105682:	eb 28                	jmp    801056ac <remove_from_list+0x38>
  p = *sList;
80105684:	8b 45 08             	mov    0x8(%ebp),%eax
80105687:	8b 00                	mov    (%eax),%eax
80105689:	89 45 0c             	mov    %eax,0xc(%ebp)
  *sList = p->next;
8010568c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010568f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105695:	8b 45 08             	mov    0x8(%ebp),%eax
80105698:	89 10                	mov    %edx,(%eax)
  p->next = 0;
8010569a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010569d:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801056a4:	00 00 00 
  return 0;
801056a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056ac:	5d                   	pop    %ebp
801056ad:	c3                   	ret    

801056ae <add_to_list>:

// Implementation of add_to_list
static int
add_to_list(struct proc** sList, enum procstate state, struct proc* p)
{
801056ae:	55                   	push   %ebp
801056af:	89 e5                	mov    %esp,%ebp
801056b1:	83 ec 08             	sub    $0x8,%esp
  if (!p)
801056b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056b8:	75 07                	jne    801056c1 <add_to_list+0x13>
    return -1;
801056ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bf:	eb 2c                	jmp    801056ed <add_to_list+0x3f>
  assert_state(p, state);
801056c1:	83 ec 08             	sub    $0x8,%esp
801056c4:	ff 75 0c             	pushl  0xc(%ebp)
801056c7:	ff 75 10             	pushl  0x10(%ebp)
801056ca:	e8 84 ff ff ff       	call   80105653 <assert_state>
801056cf:	83 c4 10             	add    $0x10,%esp
  p->next = *sList;
801056d2:	8b 45 08             	mov    0x8(%ebp),%eax
801056d5:	8b 10                	mov    (%eax),%edx
801056d7:	8b 45 10             	mov    0x10(%ebp),%eax
801056da:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  *sList = p;
801056e0:	8b 45 08             	mov    0x8(%ebp),%eax
801056e3:	8b 55 10             	mov    0x10(%ebp),%edx
801056e6:	89 10                	mov    %edx,(%eax)
  return 0;
801056e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056ed:	c9                   	leave  
801056ee:	c3                   	ret    

801056ef <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801056ef:	55                   	push   %ebp
801056f0:	89 e5                	mov    %esp,%ebp
801056f2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801056f5:	9c                   	pushf  
801056f6:	58                   	pop    %eax
801056f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801056fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801056fd:	c9                   	leave  
801056fe:	c3                   	ret    

801056ff <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801056ff:	55                   	push   %ebp
80105700:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105702:	fa                   	cli    
}
80105703:	90                   	nop
80105704:	5d                   	pop    %ebp
80105705:	c3                   	ret    

80105706 <sti>:

static inline void
sti(void)
{
80105706:	55                   	push   %ebp
80105707:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105709:	fb                   	sti    
}
8010570a:	90                   	nop
8010570b:	5d                   	pop    %ebp
8010570c:	c3                   	ret    

8010570d <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010570d:	55                   	push   %ebp
8010570e:	89 e5                	mov    %esp,%ebp
80105710:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105713:	8b 55 08             	mov    0x8(%ebp),%edx
80105716:	8b 45 0c             	mov    0xc(%ebp),%eax
80105719:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010571c:	f0 87 02             	lock xchg %eax,(%edx)
8010571f:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105722:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105725:	c9                   	leave  
80105726:	c3                   	ret    

80105727 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105727:	55                   	push   %ebp
80105728:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010572a:	8b 45 08             	mov    0x8(%ebp),%eax
8010572d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105730:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105733:	8b 45 08             	mov    0x8(%ebp),%eax
80105736:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010573c:	8b 45 08             	mov    0x8(%ebp),%eax
8010573f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105746:	90                   	nop
80105747:	5d                   	pop    %ebp
80105748:	c3                   	ret    

80105749 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105749:	55                   	push   %ebp
8010574a:	89 e5                	mov    %esp,%ebp
8010574c:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010574f:	e8 52 01 00 00       	call   801058a6 <pushcli>
  if(holding(lk))
80105754:	8b 45 08             	mov    0x8(%ebp),%eax
80105757:	83 ec 0c             	sub    $0xc,%esp
8010575a:	50                   	push   %eax
8010575b:	e8 1c 01 00 00       	call   8010587c <holding>
80105760:	83 c4 10             	add    $0x10,%esp
80105763:	85 c0                	test   %eax,%eax
80105765:	74 0d                	je     80105774 <acquire+0x2b>
    panic("acquire");
80105767:	83 ec 0c             	sub    $0xc,%esp
8010576a:	68 78 92 10 80       	push   $0x80109278
8010576f:	e8 f2 ad ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105774:	90                   	nop
80105775:	8b 45 08             	mov    0x8(%ebp),%eax
80105778:	83 ec 08             	sub    $0x8,%esp
8010577b:	6a 01                	push   $0x1
8010577d:	50                   	push   %eax
8010577e:	e8 8a ff ff ff       	call   8010570d <xchg>
80105783:	83 c4 10             	add    $0x10,%esp
80105786:	85 c0                	test   %eax,%eax
80105788:	75 eb                	jne    80105775 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010578a:	8b 45 08             	mov    0x8(%ebp),%eax
8010578d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105794:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105797:	8b 45 08             	mov    0x8(%ebp),%eax
8010579a:	83 c0 0c             	add    $0xc,%eax
8010579d:	83 ec 08             	sub    $0x8,%esp
801057a0:	50                   	push   %eax
801057a1:	8d 45 08             	lea    0x8(%ebp),%eax
801057a4:	50                   	push   %eax
801057a5:	e8 58 00 00 00       	call   80105802 <getcallerpcs>
801057aa:	83 c4 10             	add    $0x10,%esp
}
801057ad:	90                   	nop
801057ae:	c9                   	leave  
801057af:	c3                   	ret    

801057b0 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801057b6:	83 ec 0c             	sub    $0xc,%esp
801057b9:	ff 75 08             	pushl  0x8(%ebp)
801057bc:	e8 bb 00 00 00       	call   8010587c <holding>
801057c1:	83 c4 10             	add    $0x10,%esp
801057c4:	85 c0                	test   %eax,%eax
801057c6:	75 0d                	jne    801057d5 <release+0x25>
    panic("release");
801057c8:	83 ec 0c             	sub    $0xc,%esp
801057cb:	68 80 92 10 80       	push   $0x80109280
801057d0:	e8 91 ad ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801057d5:	8b 45 08             	mov    0x8(%ebp),%eax
801057d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801057df:	8b 45 08             	mov    0x8(%ebp),%eax
801057e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801057e9:	8b 45 08             	mov    0x8(%ebp),%eax
801057ec:	83 ec 08             	sub    $0x8,%esp
801057ef:	6a 00                	push   $0x0
801057f1:	50                   	push   %eax
801057f2:	e8 16 ff ff ff       	call   8010570d <xchg>
801057f7:	83 c4 10             	add    $0x10,%esp

  popcli();
801057fa:	e8 ec 00 00 00       	call   801058eb <popcli>
}
801057ff:	90                   	nop
80105800:	c9                   	leave  
80105801:	c3                   	ret    

80105802 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105802:	55                   	push   %ebp
80105803:	89 e5                	mov    %esp,%ebp
80105805:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105808:	8b 45 08             	mov    0x8(%ebp),%eax
8010580b:	83 e8 08             	sub    $0x8,%eax
8010580e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105811:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105818:	eb 38                	jmp    80105852 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010581a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010581e:	74 53                	je     80105873 <getcallerpcs+0x71>
80105820:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105827:	76 4a                	jbe    80105873 <getcallerpcs+0x71>
80105829:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010582d:	74 44                	je     80105873 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010582f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105832:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105839:	8b 45 0c             	mov    0xc(%ebp),%eax
8010583c:	01 c2                	add    %eax,%edx
8010583e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105841:	8b 40 04             	mov    0x4(%eax),%eax
80105844:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105846:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105849:	8b 00                	mov    (%eax),%eax
8010584b:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010584e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105852:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105856:	7e c2                	jle    8010581a <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105858:	eb 19                	jmp    80105873 <getcallerpcs+0x71>
    pcs[i] = 0;
8010585a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010585d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105864:	8b 45 0c             	mov    0xc(%ebp),%eax
80105867:	01 d0                	add    %edx,%eax
80105869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010586f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105873:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105877:	7e e1                	jle    8010585a <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105879:	90                   	nop
8010587a:	c9                   	leave  
8010587b:	c3                   	ret    

8010587c <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010587c:	55                   	push   %ebp
8010587d:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010587f:	8b 45 08             	mov    0x8(%ebp),%eax
80105882:	8b 00                	mov    (%eax),%eax
80105884:	85 c0                	test   %eax,%eax
80105886:	74 17                	je     8010589f <holding+0x23>
80105888:	8b 45 08             	mov    0x8(%ebp),%eax
8010588b:	8b 50 08             	mov    0x8(%eax),%edx
8010588e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105894:	39 c2                	cmp    %eax,%edx
80105896:	75 07                	jne    8010589f <holding+0x23>
80105898:	b8 01 00 00 00       	mov    $0x1,%eax
8010589d:	eb 05                	jmp    801058a4 <holding+0x28>
8010589f:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058a4:	5d                   	pop    %ebp
801058a5:	c3                   	ret    

801058a6 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801058a6:	55                   	push   %ebp
801058a7:	89 e5                	mov    %esp,%ebp
801058a9:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801058ac:	e8 3e fe ff ff       	call   801056ef <readeflags>
801058b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801058b4:	e8 46 fe ff ff       	call   801056ff <cli>
  if(cpu->ncli++ == 0)
801058b9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801058c0:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801058c6:	8d 48 01             	lea    0x1(%eax),%ecx
801058c9:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801058cf:	85 c0                	test   %eax,%eax
801058d1:	75 15                	jne    801058e8 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801058d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801058d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058dc:	81 e2 00 02 00 00    	and    $0x200,%edx
801058e2:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801058e8:	90                   	nop
801058e9:	c9                   	leave  
801058ea:	c3                   	ret    

801058eb <popcli>:

void
popcli(void)
{
801058eb:	55                   	push   %ebp
801058ec:	89 e5                	mov    %esp,%ebp
801058ee:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801058f1:	e8 f9 fd ff ff       	call   801056ef <readeflags>
801058f6:	25 00 02 00 00       	and    $0x200,%eax
801058fb:	85 c0                	test   %eax,%eax
801058fd:	74 0d                	je     8010590c <popcli+0x21>
    panic("popcli - interruptible");
801058ff:	83 ec 0c             	sub    $0xc,%esp
80105902:	68 88 92 10 80       	push   $0x80109288
80105907:	e8 5a ac ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
8010590c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105912:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105918:	83 ea 01             	sub    $0x1,%edx
8010591b:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105921:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105927:	85 c0                	test   %eax,%eax
80105929:	79 0d                	jns    80105938 <popcli+0x4d>
    panic("popcli");
8010592b:	83 ec 0c             	sub    $0xc,%esp
8010592e:	68 9f 92 10 80       	push   $0x8010929f
80105933:	e8 2e ac ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105938:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010593e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105944:	85 c0                	test   %eax,%eax
80105946:	75 15                	jne    8010595d <popcli+0x72>
80105948:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010594e:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105954:	85 c0                	test   %eax,%eax
80105956:	74 05                	je     8010595d <popcli+0x72>
    sti();
80105958:	e8 a9 fd ff ff       	call   80105706 <sti>
}
8010595d:	90                   	nop
8010595e:	c9                   	leave  
8010595f:	c3                   	ret    

80105960 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	57                   	push   %edi
80105964:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105965:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105968:	8b 55 10             	mov    0x10(%ebp),%edx
8010596b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010596e:	89 cb                	mov    %ecx,%ebx
80105970:	89 df                	mov    %ebx,%edi
80105972:	89 d1                	mov    %edx,%ecx
80105974:	fc                   	cld    
80105975:	f3 aa                	rep stos %al,%es:(%edi)
80105977:	89 ca                	mov    %ecx,%edx
80105979:	89 fb                	mov    %edi,%ebx
8010597b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010597e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105981:	90                   	nop
80105982:	5b                   	pop    %ebx
80105983:	5f                   	pop    %edi
80105984:	5d                   	pop    %ebp
80105985:	c3                   	ret    

80105986 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105986:	55                   	push   %ebp
80105987:	89 e5                	mov    %esp,%ebp
80105989:	57                   	push   %edi
8010598a:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010598b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010598e:	8b 55 10             	mov    0x10(%ebp),%edx
80105991:	8b 45 0c             	mov    0xc(%ebp),%eax
80105994:	89 cb                	mov    %ecx,%ebx
80105996:	89 df                	mov    %ebx,%edi
80105998:	89 d1                	mov    %edx,%ecx
8010599a:	fc                   	cld    
8010599b:	f3 ab                	rep stos %eax,%es:(%edi)
8010599d:	89 ca                	mov    %ecx,%edx
8010599f:	89 fb                	mov    %edi,%ebx
801059a1:	89 5d 08             	mov    %ebx,0x8(%ebp)
801059a4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801059a7:	90                   	nop
801059a8:	5b                   	pop    %ebx
801059a9:	5f                   	pop    %edi
801059aa:	5d                   	pop    %ebp
801059ab:	c3                   	ret    

801059ac <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801059ac:	55                   	push   %ebp
801059ad:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801059af:	8b 45 08             	mov    0x8(%ebp),%eax
801059b2:	83 e0 03             	and    $0x3,%eax
801059b5:	85 c0                	test   %eax,%eax
801059b7:	75 43                	jne    801059fc <memset+0x50>
801059b9:	8b 45 10             	mov    0x10(%ebp),%eax
801059bc:	83 e0 03             	and    $0x3,%eax
801059bf:	85 c0                	test   %eax,%eax
801059c1:	75 39                	jne    801059fc <memset+0x50>
    c &= 0xFF;
801059c3:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801059ca:	8b 45 10             	mov    0x10(%ebp),%eax
801059cd:	c1 e8 02             	shr    $0x2,%eax
801059d0:	89 c1                	mov    %eax,%ecx
801059d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801059d5:	c1 e0 18             	shl    $0x18,%eax
801059d8:	89 c2                	mov    %eax,%edx
801059da:	8b 45 0c             	mov    0xc(%ebp),%eax
801059dd:	c1 e0 10             	shl    $0x10,%eax
801059e0:	09 c2                	or     %eax,%edx
801059e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801059e5:	c1 e0 08             	shl    $0x8,%eax
801059e8:	09 d0                	or     %edx,%eax
801059ea:	0b 45 0c             	or     0xc(%ebp),%eax
801059ed:	51                   	push   %ecx
801059ee:	50                   	push   %eax
801059ef:	ff 75 08             	pushl  0x8(%ebp)
801059f2:	e8 8f ff ff ff       	call   80105986 <stosl>
801059f7:	83 c4 0c             	add    $0xc,%esp
801059fa:	eb 12                	jmp    80105a0e <memset+0x62>
  } else
    stosb(dst, c, n);
801059fc:	8b 45 10             	mov    0x10(%ebp),%eax
801059ff:	50                   	push   %eax
80105a00:	ff 75 0c             	pushl  0xc(%ebp)
80105a03:	ff 75 08             	pushl  0x8(%ebp)
80105a06:	e8 55 ff ff ff       	call   80105960 <stosb>
80105a0b:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105a0e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105a11:	c9                   	leave  
80105a12:	c3                   	ret    

80105a13 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105a13:	55                   	push   %ebp
80105a14:	89 e5                	mov    %esp,%ebp
80105a16:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105a19:	8b 45 08             	mov    0x8(%ebp),%eax
80105a1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a22:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105a25:	eb 30                	jmp    80105a57 <memcmp+0x44>
    if(*s1 != *s2)
80105a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a2a:	0f b6 10             	movzbl (%eax),%edx
80105a2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105a30:	0f b6 00             	movzbl (%eax),%eax
80105a33:	38 c2                	cmp    %al,%dl
80105a35:	74 18                	je     80105a4f <memcmp+0x3c>
      return *s1 - *s2;
80105a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a3a:	0f b6 00             	movzbl (%eax),%eax
80105a3d:	0f b6 d0             	movzbl %al,%edx
80105a40:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105a43:	0f b6 00             	movzbl (%eax),%eax
80105a46:	0f b6 c0             	movzbl %al,%eax
80105a49:	29 c2                	sub    %eax,%edx
80105a4b:	89 d0                	mov    %edx,%eax
80105a4d:	eb 1a                	jmp    80105a69 <memcmp+0x56>
    s1++, s2++;
80105a4f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a53:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105a57:	8b 45 10             	mov    0x10(%ebp),%eax
80105a5a:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a5d:	89 55 10             	mov    %edx,0x10(%ebp)
80105a60:	85 c0                	test   %eax,%eax
80105a62:	75 c3                	jne    80105a27 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a69:	c9                   	leave  
80105a6a:	c3                   	ret    

80105a6b <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105a6b:	55                   	push   %ebp
80105a6c:	89 e5                	mov    %esp,%ebp
80105a6e:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105a71:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a74:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105a77:	8b 45 08             	mov    0x8(%ebp),%eax
80105a7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105a7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105a83:	73 54                	jae    80105ad9 <memmove+0x6e>
80105a85:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a88:	8b 45 10             	mov    0x10(%ebp),%eax
80105a8b:	01 d0                	add    %edx,%eax
80105a8d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105a90:	76 47                	jbe    80105ad9 <memmove+0x6e>
    s += n;
80105a92:	8b 45 10             	mov    0x10(%ebp),%eax
80105a95:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105a98:	8b 45 10             	mov    0x10(%ebp),%eax
80105a9b:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105a9e:	eb 13                	jmp    80105ab3 <memmove+0x48>
      *--d = *--s;
80105aa0:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105aa4:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aab:	0f b6 10             	movzbl (%eax),%edx
80105aae:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105ab1:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105ab3:	8b 45 10             	mov    0x10(%ebp),%eax
80105ab6:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ab9:	89 55 10             	mov    %edx,0x10(%ebp)
80105abc:	85 c0                	test   %eax,%eax
80105abe:	75 e0                	jne    80105aa0 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105ac0:	eb 24                	jmp    80105ae6 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105ac2:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105ac5:	8d 50 01             	lea    0x1(%eax),%edx
80105ac8:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105acb:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ace:	8d 4a 01             	lea    0x1(%edx),%ecx
80105ad1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105ad4:	0f b6 12             	movzbl (%edx),%edx
80105ad7:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105ad9:	8b 45 10             	mov    0x10(%ebp),%eax
80105adc:	8d 50 ff             	lea    -0x1(%eax),%edx
80105adf:	89 55 10             	mov    %edx,0x10(%ebp)
80105ae2:	85 c0                	test   %eax,%eax
80105ae4:	75 dc                	jne    80105ac2 <memmove+0x57>
      *d++ = *s++;

  return dst;
80105ae6:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105ae9:	c9                   	leave  
80105aea:	c3                   	ret    

80105aeb <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105aeb:	55                   	push   %ebp
80105aec:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105aee:	ff 75 10             	pushl  0x10(%ebp)
80105af1:	ff 75 0c             	pushl  0xc(%ebp)
80105af4:	ff 75 08             	pushl  0x8(%ebp)
80105af7:	e8 6f ff ff ff       	call   80105a6b <memmove>
80105afc:	83 c4 0c             	add    $0xc,%esp
}
80105aff:	c9                   	leave  
80105b00:	c3                   	ret    

80105b01 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105b01:	55                   	push   %ebp
80105b02:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105b04:	eb 0c                	jmp    80105b12 <strncmp+0x11>
    n--, p++, q++;
80105b06:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105b0a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105b0e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105b12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b16:	74 1a                	je     80105b32 <strncmp+0x31>
80105b18:	8b 45 08             	mov    0x8(%ebp),%eax
80105b1b:	0f b6 00             	movzbl (%eax),%eax
80105b1e:	84 c0                	test   %al,%al
80105b20:	74 10                	je     80105b32 <strncmp+0x31>
80105b22:	8b 45 08             	mov    0x8(%ebp),%eax
80105b25:	0f b6 10             	movzbl (%eax),%edx
80105b28:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b2b:	0f b6 00             	movzbl (%eax),%eax
80105b2e:	38 c2                	cmp    %al,%dl
80105b30:	74 d4                	je     80105b06 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105b32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b36:	75 07                	jne    80105b3f <strncmp+0x3e>
    return 0;
80105b38:	b8 00 00 00 00       	mov    $0x0,%eax
80105b3d:	eb 16                	jmp    80105b55 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105b3f:	8b 45 08             	mov    0x8(%ebp),%eax
80105b42:	0f b6 00             	movzbl (%eax),%eax
80105b45:	0f b6 d0             	movzbl %al,%edx
80105b48:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b4b:	0f b6 00             	movzbl (%eax),%eax
80105b4e:	0f b6 c0             	movzbl %al,%eax
80105b51:	29 c2                	sub    %eax,%edx
80105b53:	89 d0                	mov    %edx,%eax
}
80105b55:	5d                   	pop    %ebp
80105b56:	c3                   	ret    

80105b57 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105b57:	55                   	push   %ebp
80105b58:	89 e5                	mov    %esp,%ebp
80105b5a:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80105b60:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105b63:	90                   	nop
80105b64:	8b 45 10             	mov    0x10(%ebp),%eax
80105b67:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b6a:	89 55 10             	mov    %edx,0x10(%ebp)
80105b6d:	85 c0                	test   %eax,%eax
80105b6f:	7e 2c                	jle    80105b9d <strncpy+0x46>
80105b71:	8b 45 08             	mov    0x8(%ebp),%eax
80105b74:	8d 50 01             	lea    0x1(%eax),%edx
80105b77:	89 55 08             	mov    %edx,0x8(%ebp)
80105b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b7d:	8d 4a 01             	lea    0x1(%edx),%ecx
80105b80:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105b83:	0f b6 12             	movzbl (%edx),%edx
80105b86:	88 10                	mov    %dl,(%eax)
80105b88:	0f b6 00             	movzbl (%eax),%eax
80105b8b:	84 c0                	test   %al,%al
80105b8d:	75 d5                	jne    80105b64 <strncpy+0xd>
    ;
  while(n-- > 0)
80105b8f:	eb 0c                	jmp    80105b9d <strncpy+0x46>
    *s++ = 0;
80105b91:	8b 45 08             	mov    0x8(%ebp),%eax
80105b94:	8d 50 01             	lea    0x1(%eax),%edx
80105b97:	89 55 08             	mov    %edx,0x8(%ebp)
80105b9a:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105b9d:	8b 45 10             	mov    0x10(%ebp),%eax
80105ba0:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ba3:	89 55 10             	mov    %edx,0x10(%ebp)
80105ba6:	85 c0                	test   %eax,%eax
80105ba8:	7f e7                	jg     80105b91 <strncpy+0x3a>
    *s++ = 0;
  return os;
80105baa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105bad:	c9                   	leave  
80105bae:	c3                   	ret    

80105baf <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105baf:	55                   	push   %ebp
80105bb0:	89 e5                	mov    %esp,%ebp
80105bb2:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80105bb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105bbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105bbf:	7f 05                	jg     80105bc6 <safestrcpy+0x17>
    return os;
80105bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bc4:	eb 31                	jmp    80105bf7 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105bc6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105bca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105bce:	7e 1e                	jle    80105bee <safestrcpy+0x3f>
80105bd0:	8b 45 08             	mov    0x8(%ebp),%eax
80105bd3:	8d 50 01             	lea    0x1(%eax),%edx
80105bd6:	89 55 08             	mov    %edx,0x8(%ebp)
80105bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
80105bdc:	8d 4a 01             	lea    0x1(%edx),%ecx
80105bdf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105be2:	0f b6 12             	movzbl (%edx),%edx
80105be5:	88 10                	mov    %dl,(%eax)
80105be7:	0f b6 00             	movzbl (%eax),%eax
80105bea:	84 c0                	test   %al,%al
80105bec:	75 d8                	jne    80105bc6 <safestrcpy+0x17>
    ;
  *s = 0;
80105bee:	8b 45 08             	mov    0x8(%ebp),%eax
80105bf1:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105bf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105bf7:	c9                   	leave  
80105bf8:	c3                   	ret    

80105bf9 <strlen>:

int
strlen(const char *s)
{
80105bf9:	55                   	push   %ebp
80105bfa:	89 e5                	mov    %esp,%ebp
80105bfc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105bff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105c06:	eb 04                	jmp    80105c0c <strlen+0x13>
80105c08:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105c0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c0f:	8b 45 08             	mov    0x8(%ebp),%eax
80105c12:	01 d0                	add    %edx,%eax
80105c14:	0f b6 00             	movzbl (%eax),%eax
80105c17:	84 c0                	test   %al,%al
80105c19:	75 ed                	jne    80105c08 <strlen+0xf>
    ;
  return n;
80105c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105c1e:	c9                   	leave  
80105c1f:	c3                   	ret    

80105c20 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105c20:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105c24:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105c28:	55                   	push   %ebp
  pushl %ebx
80105c29:	53                   	push   %ebx
  pushl %esi
80105c2a:	56                   	push   %esi
  pushl %edi
80105c2b:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105c2c:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105c2e:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105c30:	5f                   	pop    %edi
  popl %esi
80105c31:	5e                   	pop    %esi
  popl %ebx
80105c32:	5b                   	pop    %ebx
  popl %ebp
80105c33:	5d                   	pop    %ebp
  ret
80105c34:	c3                   	ret    

80105c35 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105c35:	55                   	push   %ebp
80105c36:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105c38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c3e:	8b 00                	mov    (%eax),%eax
80105c40:	3b 45 08             	cmp    0x8(%ebp),%eax
80105c43:	76 12                	jbe    80105c57 <fetchint+0x22>
80105c45:	8b 45 08             	mov    0x8(%ebp),%eax
80105c48:	8d 50 04             	lea    0x4(%eax),%edx
80105c4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c51:	8b 00                	mov    (%eax),%eax
80105c53:	39 c2                	cmp    %eax,%edx
80105c55:	76 07                	jbe    80105c5e <fetchint+0x29>
    return -1;
80105c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5c:	eb 0f                	jmp    80105c6d <fetchint+0x38>
  *ip = *(int*)(addr);
80105c5e:	8b 45 08             	mov    0x8(%ebp),%eax
80105c61:	8b 10                	mov    (%eax),%edx
80105c63:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c66:	89 10                	mov    %edx,(%eax)
  return 0;
80105c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c6d:	5d                   	pop    %ebp
80105c6e:	c3                   	ret    

80105c6f <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105c6f:	55                   	push   %ebp
80105c70:	89 e5                	mov    %esp,%ebp
80105c72:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105c75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c7b:	8b 00                	mov    (%eax),%eax
80105c7d:	3b 45 08             	cmp    0x8(%ebp),%eax
80105c80:	77 07                	ja     80105c89 <fetchstr+0x1a>
    return -1;
80105c82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c87:	eb 46                	jmp    80105ccf <fetchstr+0x60>
  *pp = (char*)addr;
80105c89:	8b 55 08             	mov    0x8(%ebp),%edx
80105c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c8f:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105c91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c97:	8b 00                	mov    (%eax),%eax
80105c99:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c9f:	8b 00                	mov    (%eax),%eax
80105ca1:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105ca4:	eb 1c                	jmp    80105cc2 <fetchstr+0x53>
    if(*s == 0)
80105ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ca9:	0f b6 00             	movzbl (%eax),%eax
80105cac:	84 c0                	test   %al,%al
80105cae:	75 0e                	jne    80105cbe <fetchstr+0x4f>
      return s - *pp;
80105cb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cb6:	8b 00                	mov    (%eax),%eax
80105cb8:	29 c2                	sub    %eax,%edx
80105cba:	89 d0                	mov    %edx,%eax
80105cbc:	eb 11                	jmp    80105ccf <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105cbe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cc5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105cc8:	72 dc                	jb     80105ca6 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105cca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ccf:	c9                   	leave  
80105cd0:	c3                   	ret    

80105cd1 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105cd1:	55                   	push   %ebp
80105cd2:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105cd4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cda:	8b 40 18             	mov    0x18(%eax),%eax
80105cdd:	8b 40 44             	mov    0x44(%eax),%eax
80105ce0:	8b 55 08             	mov    0x8(%ebp),%edx
80105ce3:	c1 e2 02             	shl    $0x2,%edx
80105ce6:	01 d0                	add    %edx,%eax
80105ce8:	83 c0 04             	add    $0x4,%eax
80105ceb:	ff 75 0c             	pushl  0xc(%ebp)
80105cee:	50                   	push   %eax
80105cef:	e8 41 ff ff ff       	call   80105c35 <fetchint>
80105cf4:	83 c4 08             	add    $0x8,%esp
}
80105cf7:	c9                   	leave  
80105cf8:	c3                   	ret    

80105cf9 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105cf9:	55                   	push   %ebp
80105cfa:	89 e5                	mov    %esp,%ebp
80105cfc:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105cff:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105d02:	50                   	push   %eax
80105d03:	ff 75 08             	pushl  0x8(%ebp)
80105d06:	e8 c6 ff ff ff       	call   80105cd1 <argint>
80105d0b:	83 c4 08             	add    $0x8,%esp
80105d0e:	85 c0                	test   %eax,%eax
80105d10:	79 07                	jns    80105d19 <argptr+0x20>
    return -1;
80105d12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d17:	eb 3b                	jmp    80105d54 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105d19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d1f:	8b 00                	mov    (%eax),%eax
80105d21:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d24:	39 d0                	cmp    %edx,%eax
80105d26:	76 16                	jbe    80105d3e <argptr+0x45>
80105d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d2b:	89 c2                	mov    %eax,%edx
80105d2d:	8b 45 10             	mov    0x10(%ebp),%eax
80105d30:	01 c2                	add    %eax,%edx
80105d32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d38:	8b 00                	mov    (%eax),%eax
80105d3a:	39 c2                	cmp    %eax,%edx
80105d3c:	76 07                	jbe    80105d45 <argptr+0x4c>
    return -1;
80105d3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d43:	eb 0f                	jmp    80105d54 <argptr+0x5b>
  *pp = (char*)i;
80105d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d48:	89 c2                	mov    %eax,%edx
80105d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d4d:	89 10                	mov    %edx,(%eax)
  return 0;
80105d4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d54:	c9                   	leave  
80105d55:	c3                   	ret    

80105d56 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105d56:	55                   	push   %ebp
80105d57:	89 e5                	mov    %esp,%ebp
80105d59:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105d5c:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105d5f:	50                   	push   %eax
80105d60:	ff 75 08             	pushl  0x8(%ebp)
80105d63:	e8 69 ff ff ff       	call   80105cd1 <argint>
80105d68:	83 c4 08             	add    $0x8,%esp
80105d6b:	85 c0                	test   %eax,%eax
80105d6d:	79 07                	jns    80105d76 <argstr+0x20>
    return -1;
80105d6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d74:	eb 0f                	jmp    80105d85 <argstr+0x2f>
  return fetchstr(addr, pp);
80105d76:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d79:	ff 75 0c             	pushl  0xc(%ebp)
80105d7c:	50                   	push   %eax
80105d7d:	e8 ed fe ff ff       	call   80105c6f <fetchstr>
80105d82:	83 c4 08             	add    $0x8,%esp
}
80105d85:	c9                   	leave  
80105d86:	c3                   	ret    

80105d87 <syscall>:
};
#endif 

void
syscall(void)
{
80105d87:	55                   	push   %ebp
80105d88:	89 e5                	mov    %esp,%ebp
80105d8a:	53                   	push   %ebx
80105d8b:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105d8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d94:	8b 40 18             	mov    0x18(%eax),%eax
80105d97:	8b 40 1c             	mov    0x1c(%eax),%eax
80105d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105d9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105da1:	7e 30                	jle    80105dd3 <syscall+0x4c>
80105da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da6:	83 f8 1d             	cmp    $0x1d,%eax
80105da9:	77 28                	ja     80105dd3 <syscall+0x4c>
80105dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dae:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105db5:	85 c0                	test   %eax,%eax
80105db7:	74 1a                	je     80105dd3 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105db9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dbf:	8b 58 18             	mov    0x18(%eax),%ebx
80105dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc5:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105dcc:	ff d0                	call   *%eax
80105dce:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105dd1:	eb 34                	jmp    80105e07 <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105dd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dd9:	8d 50 6c             	lea    0x6c(%eax),%edx
80105ddc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105de2:	8b 40 10             	mov    0x10(%eax),%eax
80105de5:	ff 75 f4             	pushl  -0xc(%ebp)
80105de8:	52                   	push   %edx
80105de9:	50                   	push   %eax
80105dea:	68 a6 92 10 80       	push   $0x801092a6
80105def:	e8 d2 a5 ff ff       	call   801003c6 <cprintf>
80105df4:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105df7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dfd:	8b 40 18             	mov    0x18(%eax),%eax
80105e00:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105e07:	90                   	nop
80105e08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e0b:	c9                   	leave  
80105e0c:	c3                   	ret    

80105e0d <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105e0d:	55                   	push   %ebp
80105e0e:	89 e5                	mov    %esp,%ebp
80105e10:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105e13:	83 ec 08             	sub    $0x8,%esp
80105e16:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e19:	50                   	push   %eax
80105e1a:	ff 75 08             	pushl  0x8(%ebp)
80105e1d:	e8 af fe ff ff       	call   80105cd1 <argint>
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	85 c0                	test   %eax,%eax
80105e27:	79 07                	jns    80105e30 <argfd+0x23>
    return -1;
80105e29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2e:	eb 50                	jmp    80105e80 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e33:	85 c0                	test   %eax,%eax
80105e35:	78 21                	js     80105e58 <argfd+0x4b>
80105e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e3a:	83 f8 0f             	cmp    $0xf,%eax
80105e3d:	7f 19                	jg     80105e58 <argfd+0x4b>
80105e3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e45:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e48:	83 c2 08             	add    $0x8,%edx
80105e4b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e56:	75 07                	jne    80105e5f <argfd+0x52>
    return -1;
80105e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5d:	eb 21                	jmp    80105e80 <argfd+0x73>
  if(pfd)
80105e5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105e63:	74 08                	je     80105e6d <argfd+0x60>
    *pfd = fd;
80105e65:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e68:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e6b:	89 10                	mov    %edx,(%eax)
  if(pf)
80105e6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105e71:	74 08                	je     80105e7b <argfd+0x6e>
    *pf = f;
80105e73:	8b 45 10             	mov    0x10(%ebp),%eax
80105e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e79:	89 10                	mov    %edx,(%eax)
  return 0;
80105e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e80:	c9                   	leave  
80105e81:	c3                   	ret    

80105e82 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105e82:	55                   	push   %ebp
80105e83:	89 e5                	mov    %esp,%ebp
80105e85:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105e88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105e8f:	eb 30                	jmp    80105ec1 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105e91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105e9a:	83 c2 08             	add    $0x8,%edx
80105e9d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105ea1:	85 c0                	test   %eax,%eax
80105ea3:	75 18                	jne    80105ebd <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105ea5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105eab:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105eae:	8d 4a 08             	lea    0x8(%edx),%ecx
80105eb1:	8b 55 08             	mov    0x8(%ebp),%edx
80105eb4:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ebb:	eb 0f                	jmp    80105ecc <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105ebd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105ec1:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105ec5:	7e ca                	jle    80105e91 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105ec7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ecc:	c9                   	leave  
80105ecd:	c3                   	ret    

80105ece <sys_dup>:

int
sys_dup(void)
{
80105ece:	55                   	push   %ebp
80105ecf:	89 e5                	mov    %esp,%ebp
80105ed1:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105ed4:	83 ec 04             	sub    $0x4,%esp
80105ed7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105eda:	50                   	push   %eax
80105edb:	6a 00                	push   $0x0
80105edd:	6a 00                	push   $0x0
80105edf:	e8 29 ff ff ff       	call   80105e0d <argfd>
80105ee4:	83 c4 10             	add    $0x10,%esp
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	79 07                	jns    80105ef2 <sys_dup+0x24>
    return -1;
80105eeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef0:	eb 31                	jmp    80105f23 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef5:	83 ec 0c             	sub    $0xc,%esp
80105ef8:	50                   	push   %eax
80105ef9:	e8 84 ff ff ff       	call   80105e82 <fdalloc>
80105efe:	83 c4 10             	add    $0x10,%esp
80105f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f08:	79 07                	jns    80105f11 <sys_dup+0x43>
    return -1;
80105f0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f0f:	eb 12                	jmp    80105f23 <sys_dup+0x55>
  filedup(f);
80105f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f14:	83 ec 0c             	sub    $0xc,%esp
80105f17:	50                   	push   %eax
80105f18:	e8 0a b1 ff ff       	call   80101027 <filedup>
80105f1d:	83 c4 10             	add    $0x10,%esp
  return fd;
80105f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f23:	c9                   	leave  
80105f24:	c3                   	ret    

80105f25 <sys_read>:

int
sys_read(void)
{
80105f25:	55                   	push   %ebp
80105f26:	89 e5                	mov    %esp,%ebp
80105f28:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f2b:	83 ec 04             	sub    $0x4,%esp
80105f2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f31:	50                   	push   %eax
80105f32:	6a 00                	push   $0x0
80105f34:	6a 00                	push   $0x0
80105f36:	e8 d2 fe ff ff       	call   80105e0d <argfd>
80105f3b:	83 c4 10             	add    $0x10,%esp
80105f3e:	85 c0                	test   %eax,%eax
80105f40:	78 2e                	js     80105f70 <sys_read+0x4b>
80105f42:	83 ec 08             	sub    $0x8,%esp
80105f45:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f48:	50                   	push   %eax
80105f49:	6a 02                	push   $0x2
80105f4b:	e8 81 fd ff ff       	call   80105cd1 <argint>
80105f50:	83 c4 10             	add    $0x10,%esp
80105f53:	85 c0                	test   %eax,%eax
80105f55:	78 19                	js     80105f70 <sys_read+0x4b>
80105f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f5a:	83 ec 04             	sub    $0x4,%esp
80105f5d:	50                   	push   %eax
80105f5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f61:	50                   	push   %eax
80105f62:	6a 01                	push   $0x1
80105f64:	e8 90 fd ff ff       	call   80105cf9 <argptr>
80105f69:	83 c4 10             	add    $0x10,%esp
80105f6c:	85 c0                	test   %eax,%eax
80105f6e:	79 07                	jns    80105f77 <sys_read+0x52>
    return -1;
80105f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f75:	eb 17                	jmp    80105f8e <sys_read+0x69>
  return fileread(f, p, n);
80105f77:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105f7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f80:	83 ec 04             	sub    $0x4,%esp
80105f83:	51                   	push   %ecx
80105f84:	52                   	push   %edx
80105f85:	50                   	push   %eax
80105f86:	e8 2c b2 ff ff       	call   801011b7 <fileread>
80105f8b:	83 c4 10             	add    $0x10,%esp
}
80105f8e:	c9                   	leave  
80105f8f:	c3                   	ret    

80105f90 <sys_write>:

int
sys_write(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f96:	83 ec 04             	sub    $0x4,%esp
80105f99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f9c:	50                   	push   %eax
80105f9d:	6a 00                	push   $0x0
80105f9f:	6a 00                	push   $0x0
80105fa1:	e8 67 fe ff ff       	call   80105e0d <argfd>
80105fa6:	83 c4 10             	add    $0x10,%esp
80105fa9:	85 c0                	test   %eax,%eax
80105fab:	78 2e                	js     80105fdb <sys_write+0x4b>
80105fad:	83 ec 08             	sub    $0x8,%esp
80105fb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fb3:	50                   	push   %eax
80105fb4:	6a 02                	push   $0x2
80105fb6:	e8 16 fd ff ff       	call   80105cd1 <argint>
80105fbb:	83 c4 10             	add    $0x10,%esp
80105fbe:	85 c0                	test   %eax,%eax
80105fc0:	78 19                	js     80105fdb <sys_write+0x4b>
80105fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc5:	83 ec 04             	sub    $0x4,%esp
80105fc8:	50                   	push   %eax
80105fc9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fcc:	50                   	push   %eax
80105fcd:	6a 01                	push   $0x1
80105fcf:	e8 25 fd ff ff       	call   80105cf9 <argptr>
80105fd4:	83 c4 10             	add    $0x10,%esp
80105fd7:	85 c0                	test   %eax,%eax
80105fd9:	79 07                	jns    80105fe2 <sys_write+0x52>
    return -1;
80105fdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe0:	eb 17                	jmp    80105ff9 <sys_write+0x69>
  return filewrite(f, p, n);
80105fe2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105fe5:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105feb:	83 ec 04             	sub    $0x4,%esp
80105fee:	51                   	push   %ecx
80105fef:	52                   	push   %edx
80105ff0:	50                   	push   %eax
80105ff1:	e8 79 b2 ff ff       	call   8010126f <filewrite>
80105ff6:	83 c4 10             	add    $0x10,%esp
}
80105ff9:	c9                   	leave  
80105ffa:	c3                   	ret    

80105ffb <sys_close>:

int
sys_close(void)
{
80105ffb:	55                   	push   %ebp
80105ffc:	89 e5                	mov    %esp,%ebp
80105ffe:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106001:	83 ec 04             	sub    $0x4,%esp
80106004:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106007:	50                   	push   %eax
80106008:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010600b:	50                   	push   %eax
8010600c:	6a 00                	push   $0x0
8010600e:	e8 fa fd ff ff       	call   80105e0d <argfd>
80106013:	83 c4 10             	add    $0x10,%esp
80106016:	85 c0                	test   %eax,%eax
80106018:	79 07                	jns    80106021 <sys_close+0x26>
    return -1;
8010601a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010601f:	eb 28                	jmp    80106049 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106021:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106027:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010602a:	83 c2 08             	add    $0x8,%edx
8010602d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106034:	00 
  fileclose(f);
80106035:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106038:	83 ec 0c             	sub    $0xc,%esp
8010603b:	50                   	push   %eax
8010603c:	e8 37 b0 ff ff       	call   80101078 <fileclose>
80106041:	83 c4 10             	add    $0x10,%esp
  return 0;
80106044:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106049:	c9                   	leave  
8010604a:	c3                   	ret    

8010604b <sys_fstat>:

int
sys_fstat(void)
{
8010604b:	55                   	push   %ebp
8010604c:	89 e5                	mov    %esp,%ebp
8010604e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106051:	83 ec 04             	sub    $0x4,%esp
80106054:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106057:	50                   	push   %eax
80106058:	6a 00                	push   $0x0
8010605a:	6a 00                	push   $0x0
8010605c:	e8 ac fd ff ff       	call   80105e0d <argfd>
80106061:	83 c4 10             	add    $0x10,%esp
80106064:	85 c0                	test   %eax,%eax
80106066:	78 17                	js     8010607f <sys_fstat+0x34>
80106068:	83 ec 04             	sub    $0x4,%esp
8010606b:	6a 14                	push   $0x14
8010606d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106070:	50                   	push   %eax
80106071:	6a 01                	push   $0x1
80106073:	e8 81 fc ff ff       	call   80105cf9 <argptr>
80106078:	83 c4 10             	add    $0x10,%esp
8010607b:	85 c0                	test   %eax,%eax
8010607d:	79 07                	jns    80106086 <sys_fstat+0x3b>
    return -1;
8010607f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106084:	eb 13                	jmp    80106099 <sys_fstat+0x4e>
  return filestat(f, st);
80106086:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010608c:	83 ec 08             	sub    $0x8,%esp
8010608f:	52                   	push   %edx
80106090:	50                   	push   %eax
80106091:	e8 ca b0 ff ff       	call   80101160 <filestat>
80106096:	83 c4 10             	add    $0x10,%esp
}
80106099:	c9                   	leave  
8010609a:	c3                   	ret    

8010609b <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010609b:	55                   	push   %ebp
8010609c:	89 e5                	mov    %esp,%ebp
8010609e:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801060a1:	83 ec 08             	sub    $0x8,%esp
801060a4:	8d 45 d8             	lea    -0x28(%ebp),%eax
801060a7:	50                   	push   %eax
801060a8:	6a 00                	push   $0x0
801060aa:	e8 a7 fc ff ff       	call   80105d56 <argstr>
801060af:	83 c4 10             	add    $0x10,%esp
801060b2:	85 c0                	test   %eax,%eax
801060b4:	78 15                	js     801060cb <sys_link+0x30>
801060b6:	83 ec 08             	sub    $0x8,%esp
801060b9:	8d 45 dc             	lea    -0x24(%ebp),%eax
801060bc:	50                   	push   %eax
801060bd:	6a 01                	push   $0x1
801060bf:	e8 92 fc ff ff       	call   80105d56 <argstr>
801060c4:	83 c4 10             	add    $0x10,%esp
801060c7:	85 c0                	test   %eax,%eax
801060c9:	79 0a                	jns    801060d5 <sys_link+0x3a>
    return -1;
801060cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d0:	e9 68 01 00 00       	jmp    8010623d <sys_link+0x1a2>

  begin_op();
801060d5:	e8 9a d4 ff ff       	call   80103574 <begin_op>
  if((ip = namei(old)) == 0){
801060da:	8b 45 d8             	mov    -0x28(%ebp),%eax
801060dd:	83 ec 0c             	sub    $0xc,%esp
801060e0:	50                   	push   %eax
801060e1:	e8 69 c4 ff ff       	call   8010254f <namei>
801060e6:	83 c4 10             	add    $0x10,%esp
801060e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060f0:	75 0f                	jne    80106101 <sys_link+0x66>
    end_op();
801060f2:	e8 09 d5 ff ff       	call   80103600 <end_op>
    return -1;
801060f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060fc:	e9 3c 01 00 00       	jmp    8010623d <sys_link+0x1a2>
  }

  ilock(ip);
80106101:	83 ec 0c             	sub    $0xc,%esp
80106104:	ff 75 f4             	pushl  -0xc(%ebp)
80106107:	e8 85 b8 ff ff       	call   80101991 <ilock>
8010610c:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010610f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106112:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106116:	66 83 f8 01          	cmp    $0x1,%ax
8010611a:	75 1d                	jne    80106139 <sys_link+0x9e>
    iunlockput(ip);
8010611c:	83 ec 0c             	sub    $0xc,%esp
8010611f:	ff 75 f4             	pushl  -0xc(%ebp)
80106122:	e8 2a bb ff ff       	call   80101c51 <iunlockput>
80106127:	83 c4 10             	add    $0x10,%esp
    end_op();
8010612a:	e8 d1 d4 ff ff       	call   80103600 <end_op>
    return -1;
8010612f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106134:	e9 04 01 00 00       	jmp    8010623d <sys_link+0x1a2>
  }

  ip->nlink++;
80106139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010613c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106140:	83 c0 01             	add    $0x1,%eax
80106143:	89 c2                	mov    %eax,%edx
80106145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106148:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010614c:	83 ec 0c             	sub    $0xc,%esp
8010614f:	ff 75 f4             	pushl  -0xc(%ebp)
80106152:	e8 60 b6 ff ff       	call   801017b7 <iupdate>
80106157:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
8010615a:	83 ec 0c             	sub    $0xc,%esp
8010615d:	ff 75 f4             	pushl  -0xc(%ebp)
80106160:	e8 8a b9 ff ff       	call   80101aef <iunlock>
80106165:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106168:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010616b:	83 ec 08             	sub    $0x8,%esp
8010616e:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106171:	52                   	push   %edx
80106172:	50                   	push   %eax
80106173:	e8 f3 c3 ff ff       	call   8010256b <nameiparent>
80106178:	83 c4 10             	add    $0x10,%esp
8010617b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010617e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106182:	74 71                	je     801061f5 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80106184:	83 ec 0c             	sub    $0xc,%esp
80106187:	ff 75 f0             	pushl  -0x10(%ebp)
8010618a:	e8 02 b8 ff ff       	call   80101991 <ilock>
8010618f:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106192:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106195:	8b 10                	mov    (%eax),%edx
80106197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010619a:	8b 00                	mov    (%eax),%eax
8010619c:	39 c2                	cmp    %eax,%edx
8010619e:	75 1d                	jne    801061bd <sys_link+0x122>
801061a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a3:	8b 40 04             	mov    0x4(%eax),%eax
801061a6:	83 ec 04             	sub    $0x4,%esp
801061a9:	50                   	push   %eax
801061aa:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801061ad:	50                   	push   %eax
801061ae:	ff 75 f0             	pushl  -0x10(%ebp)
801061b1:	e8 fd c0 ff ff       	call   801022b3 <dirlink>
801061b6:	83 c4 10             	add    $0x10,%esp
801061b9:	85 c0                	test   %eax,%eax
801061bb:	79 10                	jns    801061cd <sys_link+0x132>
    iunlockput(dp);
801061bd:	83 ec 0c             	sub    $0xc,%esp
801061c0:	ff 75 f0             	pushl  -0x10(%ebp)
801061c3:	e8 89 ba ff ff       	call   80101c51 <iunlockput>
801061c8:	83 c4 10             	add    $0x10,%esp
    goto bad;
801061cb:	eb 29                	jmp    801061f6 <sys_link+0x15b>
  }
  iunlockput(dp);
801061cd:	83 ec 0c             	sub    $0xc,%esp
801061d0:	ff 75 f0             	pushl  -0x10(%ebp)
801061d3:	e8 79 ba ff ff       	call   80101c51 <iunlockput>
801061d8:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801061db:	83 ec 0c             	sub    $0xc,%esp
801061de:	ff 75 f4             	pushl  -0xc(%ebp)
801061e1:	e8 7b b9 ff ff       	call   80101b61 <iput>
801061e6:	83 c4 10             	add    $0x10,%esp

  end_op();
801061e9:	e8 12 d4 ff ff       	call   80103600 <end_op>

  return 0;
801061ee:	b8 00 00 00 00       	mov    $0x0,%eax
801061f3:	eb 48                	jmp    8010623d <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801061f5:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
801061f6:	83 ec 0c             	sub    $0xc,%esp
801061f9:	ff 75 f4             	pushl  -0xc(%ebp)
801061fc:	e8 90 b7 ff ff       	call   80101991 <ilock>
80106201:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106207:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010620b:	83 e8 01             	sub    $0x1,%eax
8010620e:	89 c2                	mov    %eax,%edx
80106210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106213:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106217:	83 ec 0c             	sub    $0xc,%esp
8010621a:	ff 75 f4             	pushl  -0xc(%ebp)
8010621d:	e8 95 b5 ff ff       	call   801017b7 <iupdate>
80106222:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106225:	83 ec 0c             	sub    $0xc,%esp
80106228:	ff 75 f4             	pushl  -0xc(%ebp)
8010622b:	e8 21 ba ff ff       	call   80101c51 <iunlockput>
80106230:	83 c4 10             	add    $0x10,%esp
  end_op();
80106233:	e8 c8 d3 ff ff       	call   80103600 <end_op>
  return -1;
80106238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010623d:	c9                   	leave  
8010623e:	c3                   	ret    

8010623f <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010623f:	55                   	push   %ebp
80106240:	89 e5                	mov    %esp,%ebp
80106242:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106245:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010624c:	eb 40                	jmp    8010628e <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010624e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106251:	6a 10                	push   $0x10
80106253:	50                   	push   %eax
80106254:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106257:	50                   	push   %eax
80106258:	ff 75 08             	pushl  0x8(%ebp)
8010625b:	e8 9f bc ff ff       	call   80101eff <readi>
80106260:	83 c4 10             	add    $0x10,%esp
80106263:	83 f8 10             	cmp    $0x10,%eax
80106266:	74 0d                	je     80106275 <isdirempty+0x36>
      panic("isdirempty: readi");
80106268:	83 ec 0c             	sub    $0xc,%esp
8010626b:	68 c2 92 10 80       	push   $0x801092c2
80106270:	e8 f1 a2 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80106275:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106279:	66 85 c0             	test   %ax,%ax
8010627c:	74 07                	je     80106285 <isdirempty+0x46>
      return 0;
8010627e:	b8 00 00 00 00       	mov    $0x0,%eax
80106283:	eb 1b                	jmp    801062a0 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106288:	83 c0 10             	add    $0x10,%eax
8010628b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010628e:	8b 45 08             	mov    0x8(%ebp),%eax
80106291:	8b 50 18             	mov    0x18(%eax),%edx
80106294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106297:	39 c2                	cmp    %eax,%edx
80106299:	77 b3                	ja     8010624e <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010629b:	b8 01 00 00 00       	mov    $0x1,%eax
}
801062a0:	c9                   	leave  
801062a1:	c3                   	ret    

801062a2 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801062a2:	55                   	push   %ebp
801062a3:	89 e5                	mov    %esp,%ebp
801062a5:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801062a8:	83 ec 08             	sub    $0x8,%esp
801062ab:	8d 45 cc             	lea    -0x34(%ebp),%eax
801062ae:	50                   	push   %eax
801062af:	6a 00                	push   $0x0
801062b1:	e8 a0 fa ff ff       	call   80105d56 <argstr>
801062b6:	83 c4 10             	add    $0x10,%esp
801062b9:	85 c0                	test   %eax,%eax
801062bb:	79 0a                	jns    801062c7 <sys_unlink+0x25>
    return -1;
801062bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c2:	e9 bc 01 00 00       	jmp    80106483 <sys_unlink+0x1e1>

  begin_op();
801062c7:	e8 a8 d2 ff ff       	call   80103574 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801062cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
801062cf:	83 ec 08             	sub    $0x8,%esp
801062d2:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801062d5:	52                   	push   %edx
801062d6:	50                   	push   %eax
801062d7:	e8 8f c2 ff ff       	call   8010256b <nameiparent>
801062dc:	83 c4 10             	add    $0x10,%esp
801062df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062e6:	75 0f                	jne    801062f7 <sys_unlink+0x55>
    end_op();
801062e8:	e8 13 d3 ff ff       	call   80103600 <end_op>
    return -1;
801062ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f2:	e9 8c 01 00 00       	jmp    80106483 <sys_unlink+0x1e1>
  }

  ilock(dp);
801062f7:	83 ec 0c             	sub    $0xc,%esp
801062fa:	ff 75 f4             	pushl  -0xc(%ebp)
801062fd:	e8 8f b6 ff ff       	call   80101991 <ilock>
80106302:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106305:	83 ec 08             	sub    $0x8,%esp
80106308:	68 d4 92 10 80       	push   $0x801092d4
8010630d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106310:	50                   	push   %eax
80106311:	e8 c8 be ff ff       	call   801021de <namecmp>
80106316:	83 c4 10             	add    $0x10,%esp
80106319:	85 c0                	test   %eax,%eax
8010631b:	0f 84 4a 01 00 00    	je     8010646b <sys_unlink+0x1c9>
80106321:	83 ec 08             	sub    $0x8,%esp
80106324:	68 d6 92 10 80       	push   $0x801092d6
80106329:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010632c:	50                   	push   %eax
8010632d:	e8 ac be ff ff       	call   801021de <namecmp>
80106332:	83 c4 10             	add    $0x10,%esp
80106335:	85 c0                	test   %eax,%eax
80106337:	0f 84 2e 01 00 00    	je     8010646b <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010633d:	83 ec 04             	sub    $0x4,%esp
80106340:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106343:	50                   	push   %eax
80106344:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106347:	50                   	push   %eax
80106348:	ff 75 f4             	pushl  -0xc(%ebp)
8010634b:	e8 a9 be ff ff       	call   801021f9 <dirlookup>
80106350:	83 c4 10             	add    $0x10,%esp
80106353:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010635a:	0f 84 0a 01 00 00    	je     8010646a <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106360:	83 ec 0c             	sub    $0xc,%esp
80106363:	ff 75 f0             	pushl  -0x10(%ebp)
80106366:	e8 26 b6 ff ff       	call   80101991 <ilock>
8010636b:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010636e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106371:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106375:	66 85 c0             	test   %ax,%ax
80106378:	7f 0d                	jg     80106387 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
8010637a:	83 ec 0c             	sub    $0xc,%esp
8010637d:	68 d9 92 10 80       	push   $0x801092d9
80106382:	e8 df a1 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106387:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010638a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010638e:	66 83 f8 01          	cmp    $0x1,%ax
80106392:	75 25                	jne    801063b9 <sys_unlink+0x117>
80106394:	83 ec 0c             	sub    $0xc,%esp
80106397:	ff 75 f0             	pushl  -0x10(%ebp)
8010639a:	e8 a0 fe ff ff       	call   8010623f <isdirempty>
8010639f:	83 c4 10             	add    $0x10,%esp
801063a2:	85 c0                	test   %eax,%eax
801063a4:	75 13                	jne    801063b9 <sys_unlink+0x117>
    iunlockput(ip);
801063a6:	83 ec 0c             	sub    $0xc,%esp
801063a9:	ff 75 f0             	pushl  -0x10(%ebp)
801063ac:	e8 a0 b8 ff ff       	call   80101c51 <iunlockput>
801063b1:	83 c4 10             	add    $0x10,%esp
    goto bad;
801063b4:	e9 b2 00 00 00       	jmp    8010646b <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801063b9:	83 ec 04             	sub    $0x4,%esp
801063bc:	6a 10                	push   $0x10
801063be:	6a 00                	push   $0x0
801063c0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801063c3:	50                   	push   %eax
801063c4:	e8 e3 f5 ff ff       	call   801059ac <memset>
801063c9:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
801063cf:	6a 10                	push   $0x10
801063d1:	50                   	push   %eax
801063d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801063d5:	50                   	push   %eax
801063d6:	ff 75 f4             	pushl  -0xc(%ebp)
801063d9:	e8 78 bc ff ff       	call   80102056 <writei>
801063de:	83 c4 10             	add    $0x10,%esp
801063e1:	83 f8 10             	cmp    $0x10,%eax
801063e4:	74 0d                	je     801063f3 <sys_unlink+0x151>
    panic("unlink: writei");
801063e6:	83 ec 0c             	sub    $0xc,%esp
801063e9:	68 eb 92 10 80       	push   $0x801092eb
801063ee:	e8 73 a1 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801063f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063f6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063fa:	66 83 f8 01          	cmp    $0x1,%ax
801063fe:	75 21                	jne    80106421 <sys_unlink+0x17f>
    dp->nlink--;
80106400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106403:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106407:	83 e8 01             	sub    $0x1,%eax
8010640a:	89 c2                	mov    %eax,%edx
8010640c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010640f:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106413:	83 ec 0c             	sub    $0xc,%esp
80106416:	ff 75 f4             	pushl  -0xc(%ebp)
80106419:	e8 99 b3 ff ff       	call   801017b7 <iupdate>
8010641e:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106421:	83 ec 0c             	sub    $0xc,%esp
80106424:	ff 75 f4             	pushl  -0xc(%ebp)
80106427:	e8 25 b8 ff ff       	call   80101c51 <iunlockput>
8010642c:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010642f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106432:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106436:	83 e8 01             	sub    $0x1,%eax
80106439:	89 c2                	mov    %eax,%edx
8010643b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010643e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106442:	83 ec 0c             	sub    $0xc,%esp
80106445:	ff 75 f0             	pushl  -0x10(%ebp)
80106448:	e8 6a b3 ff ff       	call   801017b7 <iupdate>
8010644d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106450:	83 ec 0c             	sub    $0xc,%esp
80106453:	ff 75 f0             	pushl  -0x10(%ebp)
80106456:	e8 f6 b7 ff ff       	call   80101c51 <iunlockput>
8010645b:	83 c4 10             	add    $0x10,%esp

  end_op();
8010645e:	e8 9d d1 ff ff       	call   80103600 <end_op>

  return 0;
80106463:	b8 00 00 00 00       	mov    $0x0,%eax
80106468:	eb 19                	jmp    80106483 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
8010646a:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
8010646b:	83 ec 0c             	sub    $0xc,%esp
8010646e:	ff 75 f4             	pushl  -0xc(%ebp)
80106471:	e8 db b7 ff ff       	call   80101c51 <iunlockput>
80106476:	83 c4 10             	add    $0x10,%esp
  end_op();
80106479:	e8 82 d1 ff ff       	call   80103600 <end_op>
  return -1;
8010647e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106483:	c9                   	leave  
80106484:	c3                   	ret    

80106485 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106485:	55                   	push   %ebp
80106486:	89 e5                	mov    %esp,%ebp
80106488:	83 ec 38             	sub    $0x38,%esp
8010648b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010648e:	8b 55 10             	mov    0x10(%ebp),%edx
80106491:	8b 45 14             	mov    0x14(%ebp),%eax
80106494:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106498:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010649c:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801064a0:	83 ec 08             	sub    $0x8,%esp
801064a3:	8d 45 de             	lea    -0x22(%ebp),%eax
801064a6:	50                   	push   %eax
801064a7:	ff 75 08             	pushl  0x8(%ebp)
801064aa:	e8 bc c0 ff ff       	call   8010256b <nameiparent>
801064af:	83 c4 10             	add    $0x10,%esp
801064b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064b9:	75 0a                	jne    801064c5 <create+0x40>
    return 0;
801064bb:	b8 00 00 00 00       	mov    $0x0,%eax
801064c0:	e9 90 01 00 00       	jmp    80106655 <create+0x1d0>
  ilock(dp);
801064c5:	83 ec 0c             	sub    $0xc,%esp
801064c8:	ff 75 f4             	pushl  -0xc(%ebp)
801064cb:	e8 c1 b4 ff ff       	call   80101991 <ilock>
801064d0:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801064d3:	83 ec 04             	sub    $0x4,%esp
801064d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064d9:	50                   	push   %eax
801064da:	8d 45 de             	lea    -0x22(%ebp),%eax
801064dd:	50                   	push   %eax
801064de:	ff 75 f4             	pushl  -0xc(%ebp)
801064e1:	e8 13 bd ff ff       	call   801021f9 <dirlookup>
801064e6:	83 c4 10             	add    $0x10,%esp
801064e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064f0:	74 50                	je     80106542 <create+0xbd>
    iunlockput(dp);
801064f2:	83 ec 0c             	sub    $0xc,%esp
801064f5:	ff 75 f4             	pushl  -0xc(%ebp)
801064f8:	e8 54 b7 ff ff       	call   80101c51 <iunlockput>
801064fd:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106500:	83 ec 0c             	sub    $0xc,%esp
80106503:	ff 75 f0             	pushl  -0x10(%ebp)
80106506:	e8 86 b4 ff ff       	call   80101991 <ilock>
8010650b:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010650e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106513:	75 15                	jne    8010652a <create+0xa5>
80106515:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106518:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010651c:	66 83 f8 02          	cmp    $0x2,%ax
80106520:	75 08                	jne    8010652a <create+0xa5>
      return ip;
80106522:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106525:	e9 2b 01 00 00       	jmp    80106655 <create+0x1d0>
    iunlockput(ip);
8010652a:	83 ec 0c             	sub    $0xc,%esp
8010652d:	ff 75 f0             	pushl  -0x10(%ebp)
80106530:	e8 1c b7 ff ff       	call   80101c51 <iunlockput>
80106535:	83 c4 10             	add    $0x10,%esp
    return 0;
80106538:	b8 00 00 00 00       	mov    $0x0,%eax
8010653d:	e9 13 01 00 00       	jmp    80106655 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106542:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106546:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106549:	8b 00                	mov    (%eax),%eax
8010654b:	83 ec 08             	sub    $0x8,%esp
8010654e:	52                   	push   %edx
8010654f:	50                   	push   %eax
80106550:	e8 8b b1 ff ff       	call   801016e0 <ialloc>
80106555:	83 c4 10             	add    $0x10,%esp
80106558:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010655b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010655f:	75 0d                	jne    8010656e <create+0xe9>
    panic("create: ialloc");
80106561:	83 ec 0c             	sub    $0xc,%esp
80106564:	68 fa 92 10 80       	push   $0x801092fa
80106569:	e8 f8 9f ff ff       	call   80100566 <panic>

  ilock(ip);
8010656e:	83 ec 0c             	sub    $0xc,%esp
80106571:	ff 75 f0             	pushl  -0x10(%ebp)
80106574:	e8 18 b4 ff ff       	call   80101991 <ilock>
80106579:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
8010657c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010657f:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106583:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106587:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010658a:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010658e:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106592:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106595:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010659b:	83 ec 0c             	sub    $0xc,%esp
8010659e:	ff 75 f0             	pushl  -0x10(%ebp)
801065a1:	e8 11 b2 ff ff       	call   801017b7 <iupdate>
801065a6:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801065a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801065ae:	75 6a                	jne    8010661a <create+0x195>
    dp->nlink++;  // for ".."
801065b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801065b7:	83 c0 01             	add    $0x1,%eax
801065ba:	89 c2                	mov    %eax,%edx
801065bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065bf:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801065c3:	83 ec 0c             	sub    $0xc,%esp
801065c6:	ff 75 f4             	pushl  -0xc(%ebp)
801065c9:	e8 e9 b1 ff ff       	call   801017b7 <iupdate>
801065ce:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801065d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065d4:	8b 40 04             	mov    0x4(%eax),%eax
801065d7:	83 ec 04             	sub    $0x4,%esp
801065da:	50                   	push   %eax
801065db:	68 d4 92 10 80       	push   $0x801092d4
801065e0:	ff 75 f0             	pushl  -0x10(%ebp)
801065e3:	e8 cb bc ff ff       	call   801022b3 <dirlink>
801065e8:	83 c4 10             	add    $0x10,%esp
801065eb:	85 c0                	test   %eax,%eax
801065ed:	78 1e                	js     8010660d <create+0x188>
801065ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f2:	8b 40 04             	mov    0x4(%eax),%eax
801065f5:	83 ec 04             	sub    $0x4,%esp
801065f8:	50                   	push   %eax
801065f9:	68 d6 92 10 80       	push   $0x801092d6
801065fe:	ff 75 f0             	pushl  -0x10(%ebp)
80106601:	e8 ad bc ff ff       	call   801022b3 <dirlink>
80106606:	83 c4 10             	add    $0x10,%esp
80106609:	85 c0                	test   %eax,%eax
8010660b:	79 0d                	jns    8010661a <create+0x195>
      panic("create dots");
8010660d:	83 ec 0c             	sub    $0xc,%esp
80106610:	68 09 93 10 80       	push   $0x80109309
80106615:	e8 4c 9f ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010661a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010661d:	8b 40 04             	mov    0x4(%eax),%eax
80106620:	83 ec 04             	sub    $0x4,%esp
80106623:	50                   	push   %eax
80106624:	8d 45 de             	lea    -0x22(%ebp),%eax
80106627:	50                   	push   %eax
80106628:	ff 75 f4             	pushl  -0xc(%ebp)
8010662b:	e8 83 bc ff ff       	call   801022b3 <dirlink>
80106630:	83 c4 10             	add    $0x10,%esp
80106633:	85 c0                	test   %eax,%eax
80106635:	79 0d                	jns    80106644 <create+0x1bf>
    panic("create: dirlink");
80106637:	83 ec 0c             	sub    $0xc,%esp
8010663a:	68 15 93 10 80       	push   $0x80109315
8010663f:	e8 22 9f ff ff       	call   80100566 <panic>

  iunlockput(dp);
80106644:	83 ec 0c             	sub    $0xc,%esp
80106647:	ff 75 f4             	pushl  -0xc(%ebp)
8010664a:	e8 02 b6 ff ff       	call   80101c51 <iunlockput>
8010664f:	83 c4 10             	add    $0x10,%esp

  return ip;
80106652:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106655:	c9                   	leave  
80106656:	c3                   	ret    

80106657 <sys_open>:

int
sys_open(void)
{
80106657:	55                   	push   %ebp
80106658:	89 e5                	mov    %esp,%ebp
8010665a:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010665d:	83 ec 08             	sub    $0x8,%esp
80106660:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106663:	50                   	push   %eax
80106664:	6a 00                	push   $0x0
80106666:	e8 eb f6 ff ff       	call   80105d56 <argstr>
8010666b:	83 c4 10             	add    $0x10,%esp
8010666e:	85 c0                	test   %eax,%eax
80106670:	78 15                	js     80106687 <sys_open+0x30>
80106672:	83 ec 08             	sub    $0x8,%esp
80106675:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106678:	50                   	push   %eax
80106679:	6a 01                	push   $0x1
8010667b:	e8 51 f6 ff ff       	call   80105cd1 <argint>
80106680:	83 c4 10             	add    $0x10,%esp
80106683:	85 c0                	test   %eax,%eax
80106685:	79 0a                	jns    80106691 <sys_open+0x3a>
    return -1;
80106687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010668c:	e9 61 01 00 00       	jmp    801067f2 <sys_open+0x19b>

  begin_op();
80106691:	e8 de ce ff ff       	call   80103574 <begin_op>

  if(omode & O_CREATE){
80106696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106699:	25 00 02 00 00       	and    $0x200,%eax
8010669e:	85 c0                	test   %eax,%eax
801066a0:	74 2a                	je     801066cc <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801066a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066a5:	6a 00                	push   $0x0
801066a7:	6a 00                	push   $0x0
801066a9:	6a 02                	push   $0x2
801066ab:	50                   	push   %eax
801066ac:	e8 d4 fd ff ff       	call   80106485 <create>
801066b1:	83 c4 10             	add    $0x10,%esp
801066b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801066b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066bb:	75 75                	jne    80106732 <sys_open+0xdb>
      end_op();
801066bd:	e8 3e cf ff ff       	call   80103600 <end_op>
      return -1;
801066c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066c7:	e9 26 01 00 00       	jmp    801067f2 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801066cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066cf:	83 ec 0c             	sub    $0xc,%esp
801066d2:	50                   	push   %eax
801066d3:	e8 77 be ff ff       	call   8010254f <namei>
801066d8:	83 c4 10             	add    $0x10,%esp
801066db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066e2:	75 0f                	jne    801066f3 <sys_open+0x9c>
      end_op();
801066e4:	e8 17 cf ff ff       	call   80103600 <end_op>
      return -1;
801066e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ee:	e9 ff 00 00 00       	jmp    801067f2 <sys_open+0x19b>
    }
    ilock(ip);
801066f3:	83 ec 0c             	sub    $0xc,%esp
801066f6:	ff 75 f4             	pushl  -0xc(%ebp)
801066f9:	e8 93 b2 ff ff       	call   80101991 <ilock>
801066fe:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106704:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106708:	66 83 f8 01          	cmp    $0x1,%ax
8010670c:	75 24                	jne    80106732 <sys_open+0xdb>
8010670e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106711:	85 c0                	test   %eax,%eax
80106713:	74 1d                	je     80106732 <sys_open+0xdb>
      iunlockput(ip);
80106715:	83 ec 0c             	sub    $0xc,%esp
80106718:	ff 75 f4             	pushl  -0xc(%ebp)
8010671b:	e8 31 b5 ff ff       	call   80101c51 <iunlockput>
80106720:	83 c4 10             	add    $0x10,%esp
      end_op();
80106723:	e8 d8 ce ff ff       	call   80103600 <end_op>
      return -1;
80106728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010672d:	e9 c0 00 00 00       	jmp    801067f2 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106732:	e8 83 a8 ff ff       	call   80100fba <filealloc>
80106737:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010673a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010673e:	74 17                	je     80106757 <sys_open+0x100>
80106740:	83 ec 0c             	sub    $0xc,%esp
80106743:	ff 75 f0             	pushl  -0x10(%ebp)
80106746:	e8 37 f7 ff ff       	call   80105e82 <fdalloc>
8010674b:	83 c4 10             	add    $0x10,%esp
8010674e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106751:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106755:	79 2e                	jns    80106785 <sys_open+0x12e>
    if(f)
80106757:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010675b:	74 0e                	je     8010676b <sys_open+0x114>
      fileclose(f);
8010675d:	83 ec 0c             	sub    $0xc,%esp
80106760:	ff 75 f0             	pushl  -0x10(%ebp)
80106763:	e8 10 a9 ff ff       	call   80101078 <fileclose>
80106768:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010676b:	83 ec 0c             	sub    $0xc,%esp
8010676e:	ff 75 f4             	pushl  -0xc(%ebp)
80106771:	e8 db b4 ff ff       	call   80101c51 <iunlockput>
80106776:	83 c4 10             	add    $0x10,%esp
    end_op();
80106779:	e8 82 ce ff ff       	call   80103600 <end_op>
    return -1;
8010677e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106783:	eb 6d                	jmp    801067f2 <sys_open+0x19b>
  }
  iunlock(ip);
80106785:	83 ec 0c             	sub    $0xc,%esp
80106788:	ff 75 f4             	pushl  -0xc(%ebp)
8010678b:	e8 5f b3 ff ff       	call   80101aef <iunlock>
80106790:	83 c4 10             	add    $0x10,%esp
  end_op();
80106793:	e8 68 ce ff ff       	call   80103600 <end_op>

  f->type = FD_INODE;
80106798:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010679b:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801067a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067a7:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801067aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067ad:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801067b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067b7:	83 e0 01             	and    $0x1,%eax
801067ba:	85 c0                	test   %eax,%eax
801067bc:	0f 94 c0             	sete   %al
801067bf:	89 c2                	mov    %eax,%edx
801067c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067c4:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801067c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ca:	83 e0 01             	and    $0x1,%eax
801067cd:	85 c0                	test   %eax,%eax
801067cf:	75 0a                	jne    801067db <sys_open+0x184>
801067d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067d4:	83 e0 02             	and    $0x2,%eax
801067d7:	85 c0                	test   %eax,%eax
801067d9:	74 07                	je     801067e2 <sys_open+0x18b>
801067db:	b8 01 00 00 00       	mov    $0x1,%eax
801067e0:	eb 05                	jmp    801067e7 <sys_open+0x190>
801067e2:	b8 00 00 00 00       	mov    $0x0,%eax
801067e7:	89 c2                	mov    %eax,%edx
801067e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067ec:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801067ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801067f2:	c9                   	leave  
801067f3:	c3                   	ret    

801067f4 <sys_mkdir>:

int
sys_mkdir(void)
{
801067f4:	55                   	push   %ebp
801067f5:	89 e5                	mov    %esp,%ebp
801067f7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801067fa:	e8 75 cd ff ff       	call   80103574 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801067ff:	83 ec 08             	sub    $0x8,%esp
80106802:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106805:	50                   	push   %eax
80106806:	6a 00                	push   $0x0
80106808:	e8 49 f5 ff ff       	call   80105d56 <argstr>
8010680d:	83 c4 10             	add    $0x10,%esp
80106810:	85 c0                	test   %eax,%eax
80106812:	78 1b                	js     8010682f <sys_mkdir+0x3b>
80106814:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106817:	6a 00                	push   $0x0
80106819:	6a 00                	push   $0x0
8010681b:	6a 01                	push   $0x1
8010681d:	50                   	push   %eax
8010681e:	e8 62 fc ff ff       	call   80106485 <create>
80106823:	83 c4 10             	add    $0x10,%esp
80106826:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010682d:	75 0c                	jne    8010683b <sys_mkdir+0x47>
    end_op();
8010682f:	e8 cc cd ff ff       	call   80103600 <end_op>
    return -1;
80106834:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106839:	eb 18                	jmp    80106853 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010683b:	83 ec 0c             	sub    $0xc,%esp
8010683e:	ff 75 f4             	pushl  -0xc(%ebp)
80106841:	e8 0b b4 ff ff       	call   80101c51 <iunlockput>
80106846:	83 c4 10             	add    $0x10,%esp
  end_op();
80106849:	e8 b2 cd ff ff       	call   80103600 <end_op>
  return 0;
8010684e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106853:	c9                   	leave  
80106854:	c3                   	ret    

80106855 <sys_mknod>:

int
sys_mknod(void)
{
80106855:	55                   	push   %ebp
80106856:	89 e5                	mov    %esp,%ebp
80106858:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010685b:	e8 14 cd ff ff       	call   80103574 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106860:	83 ec 08             	sub    $0x8,%esp
80106863:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106866:	50                   	push   %eax
80106867:	6a 00                	push   $0x0
80106869:	e8 e8 f4 ff ff       	call   80105d56 <argstr>
8010686e:	83 c4 10             	add    $0x10,%esp
80106871:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106878:	78 4f                	js     801068c9 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
8010687a:	83 ec 08             	sub    $0x8,%esp
8010687d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106880:	50                   	push   %eax
80106881:	6a 01                	push   $0x1
80106883:	e8 49 f4 ff ff       	call   80105cd1 <argint>
80106888:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010688b:	85 c0                	test   %eax,%eax
8010688d:	78 3a                	js     801068c9 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010688f:	83 ec 08             	sub    $0x8,%esp
80106892:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106895:	50                   	push   %eax
80106896:	6a 02                	push   $0x2
80106898:	e8 34 f4 ff ff       	call   80105cd1 <argint>
8010689d:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801068a0:	85 c0                	test   %eax,%eax
801068a2:	78 25                	js     801068c9 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801068a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068a7:	0f bf c8             	movswl %ax,%ecx
801068aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801068ad:	0f bf d0             	movswl %ax,%edx
801068b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801068b3:	51                   	push   %ecx
801068b4:	52                   	push   %edx
801068b5:	6a 03                	push   $0x3
801068b7:	50                   	push   %eax
801068b8:	e8 c8 fb ff ff       	call   80106485 <create>
801068bd:	83 c4 10             	add    $0x10,%esp
801068c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801068c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801068c7:	75 0c                	jne    801068d5 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801068c9:	e8 32 cd ff ff       	call   80103600 <end_op>
    return -1;
801068ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d3:	eb 18                	jmp    801068ed <sys_mknod+0x98>
  }
  iunlockput(ip);
801068d5:	83 ec 0c             	sub    $0xc,%esp
801068d8:	ff 75 f0             	pushl  -0x10(%ebp)
801068db:	e8 71 b3 ff ff       	call   80101c51 <iunlockput>
801068e0:	83 c4 10             	add    $0x10,%esp
  end_op();
801068e3:	e8 18 cd ff ff       	call   80103600 <end_op>
  return 0;
801068e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068ed:	c9                   	leave  
801068ee:	c3                   	ret    

801068ef <sys_chdir>:

int
sys_chdir(void)
{
801068ef:	55                   	push   %ebp
801068f0:	89 e5                	mov    %esp,%ebp
801068f2:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801068f5:	e8 7a cc ff ff       	call   80103574 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801068fa:	83 ec 08             	sub    $0x8,%esp
801068fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106900:	50                   	push   %eax
80106901:	6a 00                	push   $0x0
80106903:	e8 4e f4 ff ff       	call   80105d56 <argstr>
80106908:	83 c4 10             	add    $0x10,%esp
8010690b:	85 c0                	test   %eax,%eax
8010690d:	78 18                	js     80106927 <sys_chdir+0x38>
8010690f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106912:	83 ec 0c             	sub    $0xc,%esp
80106915:	50                   	push   %eax
80106916:	e8 34 bc ff ff       	call   8010254f <namei>
8010691b:	83 c4 10             	add    $0x10,%esp
8010691e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106921:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106925:	75 0c                	jne    80106933 <sys_chdir+0x44>
    end_op();
80106927:	e8 d4 cc ff ff       	call   80103600 <end_op>
    return -1;
8010692c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106931:	eb 6e                	jmp    801069a1 <sys_chdir+0xb2>
  }
  ilock(ip);
80106933:	83 ec 0c             	sub    $0xc,%esp
80106936:	ff 75 f4             	pushl  -0xc(%ebp)
80106939:	e8 53 b0 ff ff       	call   80101991 <ilock>
8010693e:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106944:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106948:	66 83 f8 01          	cmp    $0x1,%ax
8010694c:	74 1a                	je     80106968 <sys_chdir+0x79>
    iunlockput(ip);
8010694e:	83 ec 0c             	sub    $0xc,%esp
80106951:	ff 75 f4             	pushl  -0xc(%ebp)
80106954:	e8 f8 b2 ff ff       	call   80101c51 <iunlockput>
80106959:	83 c4 10             	add    $0x10,%esp
    end_op();
8010695c:	e8 9f cc ff ff       	call   80103600 <end_op>
    return -1;
80106961:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106966:	eb 39                	jmp    801069a1 <sys_chdir+0xb2>
  }
  iunlock(ip);
80106968:	83 ec 0c             	sub    $0xc,%esp
8010696b:	ff 75 f4             	pushl  -0xc(%ebp)
8010696e:	e8 7c b1 ff ff       	call   80101aef <iunlock>
80106973:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106976:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010697c:	8b 40 68             	mov    0x68(%eax),%eax
8010697f:	83 ec 0c             	sub    $0xc,%esp
80106982:	50                   	push   %eax
80106983:	e8 d9 b1 ff ff       	call   80101b61 <iput>
80106988:	83 c4 10             	add    $0x10,%esp
  end_op();
8010698b:	e8 70 cc ff ff       	call   80103600 <end_op>
  proc->cwd = ip;
80106990:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106996:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106999:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010699c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069a1:	c9                   	leave  
801069a2:	c3                   	ret    

801069a3 <sys_exec>:

int
sys_exec(void)
{
801069a3:	55                   	push   %ebp
801069a4:	89 e5                	mov    %esp,%ebp
801069a6:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801069ac:	83 ec 08             	sub    $0x8,%esp
801069af:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069b2:	50                   	push   %eax
801069b3:	6a 00                	push   $0x0
801069b5:	e8 9c f3 ff ff       	call   80105d56 <argstr>
801069ba:	83 c4 10             	add    $0x10,%esp
801069bd:	85 c0                	test   %eax,%eax
801069bf:	78 18                	js     801069d9 <sys_exec+0x36>
801069c1:	83 ec 08             	sub    $0x8,%esp
801069c4:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801069ca:	50                   	push   %eax
801069cb:	6a 01                	push   $0x1
801069cd:	e8 ff f2 ff ff       	call   80105cd1 <argint>
801069d2:	83 c4 10             	add    $0x10,%esp
801069d5:	85 c0                	test   %eax,%eax
801069d7:	79 0a                	jns    801069e3 <sys_exec+0x40>
    return -1;
801069d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069de:	e9 c6 00 00 00       	jmp    80106aa9 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801069e3:	83 ec 04             	sub    $0x4,%esp
801069e6:	68 80 00 00 00       	push   $0x80
801069eb:	6a 00                	push   $0x0
801069ed:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801069f3:	50                   	push   %eax
801069f4:	e8 b3 ef ff ff       	call   801059ac <memset>
801069f9:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801069fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a06:	83 f8 1f             	cmp    $0x1f,%eax
80106a09:	76 0a                	jbe    80106a15 <sys_exec+0x72>
      return -1;
80106a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a10:	e9 94 00 00 00       	jmp    80106aa9 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a18:	c1 e0 02             	shl    $0x2,%eax
80106a1b:	89 c2                	mov    %eax,%edx
80106a1d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106a23:	01 c2                	add    %eax,%edx
80106a25:	83 ec 08             	sub    $0x8,%esp
80106a28:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106a2e:	50                   	push   %eax
80106a2f:	52                   	push   %edx
80106a30:	e8 00 f2 ff ff       	call   80105c35 <fetchint>
80106a35:	83 c4 10             	add    $0x10,%esp
80106a38:	85 c0                	test   %eax,%eax
80106a3a:	79 07                	jns    80106a43 <sys_exec+0xa0>
      return -1;
80106a3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a41:	eb 66                	jmp    80106aa9 <sys_exec+0x106>
    if(uarg == 0){
80106a43:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106a49:	85 c0                	test   %eax,%eax
80106a4b:	75 27                	jne    80106a74 <sys_exec+0xd1>
      argv[i] = 0;
80106a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a50:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106a57:	00 00 00 00 
      break;
80106a5b:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a5f:	83 ec 08             	sub    $0x8,%esp
80106a62:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106a68:	52                   	push   %edx
80106a69:	50                   	push   %eax
80106a6a:	e8 29 a1 ff ff       	call   80100b98 <exec>
80106a6f:	83 c4 10             	add    $0x10,%esp
80106a72:	eb 35                	jmp    80106aa9 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106a74:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a7d:	c1 e2 02             	shl    $0x2,%edx
80106a80:	01 c2                	add    %eax,%edx
80106a82:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106a88:	83 ec 08             	sub    $0x8,%esp
80106a8b:	52                   	push   %edx
80106a8c:	50                   	push   %eax
80106a8d:	e8 dd f1 ff ff       	call   80105c6f <fetchstr>
80106a92:	83 c4 10             	add    $0x10,%esp
80106a95:	85 c0                	test   %eax,%eax
80106a97:	79 07                	jns    80106aa0 <sys_exec+0xfd>
      return -1;
80106a99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a9e:	eb 09                	jmp    80106aa9 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106aa0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106aa4:	e9 5a ff ff ff       	jmp    80106a03 <sys_exec+0x60>
  return exec(path, argv);
}
80106aa9:	c9                   	leave  
80106aaa:	c3                   	ret    

80106aab <sys_pipe>:

int
sys_pipe(void)
{
80106aab:	55                   	push   %ebp
80106aac:	89 e5                	mov    %esp,%ebp
80106aae:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106ab1:	83 ec 04             	sub    $0x4,%esp
80106ab4:	6a 08                	push   $0x8
80106ab6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ab9:	50                   	push   %eax
80106aba:	6a 00                	push   $0x0
80106abc:	e8 38 f2 ff ff       	call   80105cf9 <argptr>
80106ac1:	83 c4 10             	add    $0x10,%esp
80106ac4:	85 c0                	test   %eax,%eax
80106ac6:	79 0a                	jns    80106ad2 <sys_pipe+0x27>
    return -1;
80106ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106acd:	e9 af 00 00 00       	jmp    80106b81 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106ad2:	83 ec 08             	sub    $0x8,%esp
80106ad5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106ad8:	50                   	push   %eax
80106ad9:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106adc:	50                   	push   %eax
80106add:	e8 86 d5 ff ff       	call   80104068 <pipealloc>
80106ae2:	83 c4 10             	add    $0x10,%esp
80106ae5:	85 c0                	test   %eax,%eax
80106ae7:	79 0a                	jns    80106af3 <sys_pipe+0x48>
    return -1;
80106ae9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aee:	e9 8e 00 00 00       	jmp    80106b81 <sys_pipe+0xd6>
  fd0 = -1;
80106af3:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106afa:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106afd:	83 ec 0c             	sub    $0xc,%esp
80106b00:	50                   	push   %eax
80106b01:	e8 7c f3 ff ff       	call   80105e82 <fdalloc>
80106b06:	83 c4 10             	add    $0x10,%esp
80106b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106b0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b10:	78 18                	js     80106b2a <sys_pipe+0x7f>
80106b12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b15:	83 ec 0c             	sub    $0xc,%esp
80106b18:	50                   	push   %eax
80106b19:	e8 64 f3 ff ff       	call   80105e82 <fdalloc>
80106b1e:	83 c4 10             	add    $0x10,%esp
80106b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106b24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106b28:	79 3f                	jns    80106b69 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b2e:	78 14                	js     80106b44 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106b30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b39:	83 c2 08             	add    $0x8,%edx
80106b3c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106b43:	00 
    fileclose(rf);
80106b44:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106b47:	83 ec 0c             	sub    $0xc,%esp
80106b4a:	50                   	push   %eax
80106b4b:	e8 28 a5 ff ff       	call   80101078 <fileclose>
80106b50:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106b53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b56:	83 ec 0c             	sub    $0xc,%esp
80106b59:	50                   	push   %eax
80106b5a:	e8 19 a5 ff ff       	call   80101078 <fileclose>
80106b5f:	83 c4 10             	add    $0x10,%esp
    return -1;
80106b62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b67:	eb 18                	jmp    80106b81 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b6f:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b74:	8d 50 04             	lea    0x4(%eax),%edx
80106b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b7a:	89 02                	mov    %eax,(%edx)
  return 0;
80106b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b81:	c9                   	leave  
80106b82:	c3                   	ret    

80106b83 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80106b83:	55                   	push   %ebp
80106b84:	89 e5                	mov    %esp,%ebp
80106b86:	83 ec 08             	sub    $0x8,%esp
80106b89:	8b 55 08             	mov    0x8(%ebp),%edx
80106b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b8f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106b93:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b97:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106b9b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106b9f:	66 ef                	out    %ax,(%dx)
}
80106ba1:	90                   	nop
80106ba2:	c9                   	leave  
80106ba3:	c3                   	ret    

80106ba4 <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
80106ba4:	55                   	push   %ebp
80106ba5:	89 e5                	mov    %esp,%ebp
80106ba7:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106baa:	e8 69 dd ff ff       	call   80104918 <fork>
}
80106baf:	c9                   	leave  
80106bb0:	c3                   	ret    

80106bb1 <sys_exit>:

int
sys_exit(void)
{
80106bb1:	55                   	push   %ebp
80106bb2:	89 e5                	mov    %esp,%ebp
80106bb4:	83 ec 08             	sub    $0x8,%esp
  exit();
80106bb7:	e8 e5 df ff ff       	call   80104ba1 <exit>
  return 0;  // not reached
80106bbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bc1:	c9                   	leave  
80106bc2:	c3                   	ret    

80106bc3 <sys_wait>:

int
sys_wait(void)
{
80106bc3:	55                   	push   %ebp
80106bc4:	89 e5                	mov    %esp,%ebp
80106bc6:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106bc9:	e8 0e e1 ff ff       	call   80104cdc <wait>
}
80106bce:	c9                   	leave  
80106bcf:	c3                   	ret    

80106bd0 <sys_kill>:

int
sys_kill(void)
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106bd6:	83 ec 08             	sub    $0x8,%esp
80106bd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bdc:	50                   	push   %eax
80106bdd:	6a 00                	push   $0x0
80106bdf:	e8 ed f0 ff ff       	call   80105cd1 <argint>
80106be4:	83 c4 10             	add    $0x10,%esp
80106be7:	85 c0                	test   %eax,%eax
80106be9:	79 07                	jns    80106bf2 <sys_kill+0x22>
    return -1;
80106beb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bf0:	eb 0f                	jmp    80106c01 <sys_kill+0x31>
  return kill(pid);
80106bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bf5:	83 ec 0c             	sub    $0xc,%esp
80106bf8:	50                   	push   %eax
80106bf9:	e8 73 e5 ff ff       	call   80105171 <kill>
80106bfe:	83 c4 10             	add    $0x10,%esp
}
80106c01:	c9                   	leave  
80106c02:	c3                   	ret    

80106c03 <sys_getpid>:

int
sys_getpid(void)
{
80106c03:	55                   	push   %ebp
80106c04:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106c06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c0c:	8b 40 10             	mov    0x10(%eax),%eax
}
80106c0f:	5d                   	pop    %ebp
80106c10:	c3                   	ret    

80106c11 <sys_sbrk>:

int
sys_sbrk(void)
{
80106c11:	55                   	push   %ebp
80106c12:	89 e5                	mov    %esp,%ebp
80106c14:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106c17:	83 ec 08             	sub    $0x8,%esp
80106c1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c1d:	50                   	push   %eax
80106c1e:	6a 00                	push   $0x0
80106c20:	e8 ac f0 ff ff       	call   80105cd1 <argint>
80106c25:	83 c4 10             	add    $0x10,%esp
80106c28:	85 c0                	test   %eax,%eax
80106c2a:	79 07                	jns    80106c33 <sys_sbrk+0x22>
    return -1;
80106c2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c31:	eb 28                	jmp    80106c5b <sys_sbrk+0x4a>
  addr = proc->sz;
80106c33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c39:	8b 00                	mov    (%eax),%eax
80106c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c41:	83 ec 0c             	sub    $0xc,%esp
80106c44:	50                   	push   %eax
80106c45:	e8 2b dc ff ff       	call   80104875 <growproc>
80106c4a:	83 c4 10             	add    $0x10,%esp
80106c4d:	85 c0                	test   %eax,%eax
80106c4f:	79 07                	jns    80106c58 <sys_sbrk+0x47>
    return -1;
80106c51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c56:	eb 03                	jmp    80106c5b <sys_sbrk+0x4a>
  return addr;
80106c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106c5b:	c9                   	leave  
80106c5c:	c3                   	ret    

80106c5d <sys_sleep>:

int
sys_sleep(void)
{
80106c5d:	55                   	push   %ebp
80106c5e:	89 e5                	mov    %esp,%ebp
80106c60:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106c63:	83 ec 08             	sub    $0x8,%esp
80106c66:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c69:	50                   	push   %eax
80106c6a:	6a 00                	push   $0x0
80106c6c:	e8 60 f0 ff ff       	call   80105cd1 <argint>
80106c71:	83 c4 10             	add    $0x10,%esp
80106c74:	85 c0                	test   %eax,%eax
80106c76:	79 07                	jns    80106c7f <sys_sleep+0x22>
    return -1;
80106c78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c7d:	eb 44                	jmp    80106cc3 <sys_sleep+0x66>
  ticks0 = ticks;
80106c7f:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80106c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106c87:	eb 26                	jmp    80106caf <sys_sleep+0x52>
    if(proc->killed){
80106c89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c8f:	8b 40 24             	mov    0x24(%eax),%eax
80106c92:	85 c0                	test   %eax,%eax
80106c94:	74 07                	je     80106c9d <sys_sleep+0x40>
      return -1;
80106c96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c9b:	eb 26                	jmp    80106cc3 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80106c9d:	83 ec 08             	sub    $0x8,%esp
80106ca0:	6a 00                	push   $0x0
80106ca2:	68 e0 66 11 80       	push   $0x801166e0
80106ca7:	e8 a7 e3 ff ff       	call   80105053 <sleep>
80106cac:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106caf:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80106cb4:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106cb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106cba:	39 d0                	cmp    %edx,%eax
80106cbc:	72 cb                	jb     80106c89 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80106cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106cc3:	c9                   	leave  
80106cc4:	c3                   	ret    

80106cc5 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80106cc5:	55                   	push   %ebp
80106cc6:	89 e5                	mov    %esp,%ebp
80106cc8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80106ccb:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80106cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80106cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106cd6:	c9                   	leave  
80106cd7:	c3                   	ret    

80106cd8 <sys_halt>:

//Turn of the computer
int sys_halt(void){
80106cd8:	55                   	push   %ebp
80106cd9:	89 e5                	mov    %esp,%ebp
80106cdb:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80106cde:	83 ec 0c             	sub    $0xc,%esp
80106ce1:	68 25 93 10 80       	push   $0x80109325
80106ce6:	e8 db 96 ff ff       	call   801003c6 <cprintf>
80106ceb:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
80106cee:	83 ec 08             	sub    $0x8,%esp
80106cf1:	68 00 20 00 00       	push   $0x2000
80106cf6:	68 04 06 00 00       	push   $0x604
80106cfb:	e8 83 fe ff ff       	call   80106b83 <outw>
80106d00:	83 c4 10             	add    $0x10,%esp
  return 0;
80106d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d08:	c9                   	leave  
80106d09:	c3                   	ret    

80106d0a <sys_date>:

// My implementation of sys_date()
int
sys_date(void)
{
80106d0a:	55                   	push   %ebp
80106d0b:	89 e5                	mov    %esp,%ebp
80106d0d:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if (argptr(0, (void*)&d, sizeof(*d)) < 0)
80106d10:	83 ec 04             	sub    $0x4,%esp
80106d13:	6a 18                	push   $0x18
80106d15:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d18:	50                   	push   %eax
80106d19:	6a 00                	push   $0x0
80106d1b:	e8 d9 ef ff ff       	call   80105cf9 <argptr>
80106d20:	83 c4 10             	add    $0x10,%esp
80106d23:	85 c0                	test   %eax,%eax
80106d25:	79 07                	jns    80106d2e <sys_date+0x24>
    return -1;
80106d27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d2c:	eb 14                	jmp    80106d42 <sys_date+0x38>
  // MY CODE HERE
  cmostime(d);       
80106d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d31:	83 ec 0c             	sub    $0xc,%esp
80106d34:	50                   	push   %eax
80106d35:	e8 b5 c4 ff ff       	call   801031ef <cmostime>
80106d3a:	83 c4 10             	add    $0x10,%esp
  return 0; 
80106d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d42:	c9                   	leave  
80106d43:	c3                   	ret    

80106d44 <sys_getuid>:

// My implementation of sys_getuid
uint
sys_getuid(void)
{
80106d44:	55                   	push   %ebp
80106d45:	89 e5                	mov    %esp,%ebp
  return proc->uid;
80106d47:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d4d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80106d53:	5d                   	pop    %ebp
80106d54:	c3                   	ret    

80106d55 <sys_getgid>:

// My implementation of sys_getgid
uint
sys_getgid(void)
{
80106d55:	55                   	push   %ebp
80106d56:	89 e5                	mov    %esp,%ebp
  return proc->gid;
80106d58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d5e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80106d64:	5d                   	pop    %ebp
80106d65:	c3                   	ret    

80106d66 <sys_getppid>:

// My implementation of sys_getppid
uint
sys_getppid(void)
{
80106d66:	55                   	push   %ebp
80106d67:	89 e5                	mov    %esp,%ebp
  return proc->parent ? proc->parent->pid : proc->pid;
80106d69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d6f:	8b 40 14             	mov    0x14(%eax),%eax
80106d72:	85 c0                	test   %eax,%eax
80106d74:	74 0e                	je     80106d84 <sys_getppid+0x1e>
80106d76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d7c:	8b 40 14             	mov    0x14(%eax),%eax
80106d7f:	8b 40 10             	mov    0x10(%eax),%eax
80106d82:	eb 09                	jmp    80106d8d <sys_getppid+0x27>
80106d84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d8a:	8b 40 10             	mov    0x10(%eax),%eax
}
80106d8d:	5d                   	pop    %ebp
80106d8e:	c3                   	ret    

80106d8f <sys_setuid>:


// Implementation of sys_setuid
int 
sys_setuid(void)
{
80106d8f:	55                   	push   %ebp
80106d90:	89 e5                	mov    %esp,%ebp
80106d92:	83 ec 18             	sub    $0x18,%esp
  int id; // uid argument
  // Grab argument off the stack and store in id
  argint(0, &id);
80106d95:	83 ec 08             	sub    $0x8,%esp
80106d98:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d9b:	50                   	push   %eax
80106d9c:	6a 00                	push   $0x0
80106d9e:	e8 2e ef ff ff       	call   80105cd1 <argint>
80106da3:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
80106da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106da9:	85 c0                	test   %eax,%eax
80106dab:	78 0a                	js     80106db7 <sys_setuid+0x28>
80106dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106db0:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106db5:	7e 07                	jle    80106dbe <sys_setuid+0x2f>
    return -1;
80106db7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dbc:	eb 14                	jmp    80106dd2 <sys_setuid+0x43>
  proc->uid = id; 
80106dbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106dc7:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80106dcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106dd2:	c9                   	leave  
80106dd3:	c3                   	ret    

80106dd4 <sys_setgid>:

// Implementation of sys_setgid
int
sys_setgid(void)
{
80106dd4:	55                   	push   %ebp
80106dd5:	89 e5                	mov    %esp,%ebp
80106dd7:	83 ec 18             	sub    $0x18,%esp
  int id; // gid argument 
  // Grab argument off the stack and store in id
  argint(0, &id);
80106dda:	83 ec 08             	sub    $0x8,%esp
80106ddd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106de0:	50                   	push   %eax
80106de1:	6a 00                	push   $0x0
80106de3:	e8 e9 ee ff ff       	call   80105cd1 <argint>
80106de8:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
80106deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dee:	85 c0                	test   %eax,%eax
80106df0:	78 0a                	js     80106dfc <sys_setgid+0x28>
80106df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df5:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106dfa:	7e 07                	jle    80106e03 <sys_setgid+0x2f>
    return -1;
80106dfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e01:	eb 14                	jmp    80106e17 <sys_setgid+0x43>
  proc->gid = id;
80106e03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106e0c:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  return 0;
80106e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e17:	c9                   	leave  
80106e18:	c3                   	ret    

80106e19 <sys_getprocs>:

// Implementation of sys_getprocs
int
sys_getprocs(void)
{
80106e19:	55                   	push   %ebp
80106e1a:	89 e5                	mov    %esp,%ebp
80106e1c:	83 ec 18             	sub    $0x18,%esp
  int m; // Max arg
  struct uproc* table;
  argint(0, &m);
80106e1f:	83 ec 08             	sub    $0x8,%esp
80106e22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e25:	50                   	push   %eax
80106e26:	6a 00                	push   $0x0
80106e28:	e8 a4 ee ff ff       	call   80105cd1 <argint>
80106e2d:	83 c4 10             	add    $0x10,%esp
  if (m < 0)
80106e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e33:	85 c0                	test   %eax,%eax
80106e35:	79 07                	jns    80106e3e <sys_getprocs+0x25>
    return -1;
80106e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e3c:	eb 28                	jmp    80106e66 <sys_getprocs+0x4d>
  argptr(1, (void*)&table, m);
80106e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e41:	83 ec 04             	sub    $0x4,%esp
80106e44:	50                   	push   %eax
80106e45:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e48:	50                   	push   %eax
80106e49:	6a 01                	push   $0x1
80106e4b:	e8 a9 ee ff ff       	call   80105cf9 <argptr>
80106e50:	83 c4 10             	add    $0x10,%esp
  return getproc_helper(m, table);
80106e53:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e59:	83 ec 08             	sub    $0x8,%esp
80106e5c:	52                   	push   %edx
80106e5d:	50                   	push   %eax
80106e5e:	e8 80 e6 ff ff       	call   801054e3 <getproc_helper>
80106e63:	83 c4 10             	add    $0x10,%esp
}
80106e66:	c9                   	leave  
80106e67:	c3                   	ret    

80106e68 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106e68:	55                   	push   %ebp
80106e69:	89 e5                	mov    %esp,%ebp
80106e6b:	83 ec 08             	sub    $0x8,%esp
80106e6e:	8b 55 08             	mov    0x8(%ebp),%edx
80106e71:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e74:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106e78:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e7b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106e7f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106e83:	ee                   	out    %al,(%dx)
}
80106e84:	90                   	nop
80106e85:	c9                   	leave  
80106e86:	c3                   	ret    

80106e87 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106e87:	55                   	push   %ebp
80106e88:	89 e5                	mov    %esp,%ebp
80106e8a:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106e8d:	6a 34                	push   $0x34
80106e8f:	6a 43                	push   $0x43
80106e91:	e8 d2 ff ff ff       	call   80106e68 <outb>
80106e96:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106e99:	68 9c 00 00 00       	push   $0x9c
80106e9e:	6a 40                	push   $0x40
80106ea0:	e8 c3 ff ff ff       	call   80106e68 <outb>
80106ea5:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106ea8:	6a 2e                	push   $0x2e
80106eaa:	6a 40                	push   $0x40
80106eac:	e8 b7 ff ff ff       	call   80106e68 <outb>
80106eb1:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106eb4:	83 ec 0c             	sub    $0xc,%esp
80106eb7:	6a 00                	push   $0x0
80106eb9:	e8 94 d0 ff ff       	call   80103f52 <picenable>
80106ebe:	83 c4 10             	add    $0x10,%esp
}
80106ec1:	90                   	nop
80106ec2:	c9                   	leave  
80106ec3:	c3                   	ret    

80106ec4 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106ec4:	1e                   	push   %ds
  pushl %es
80106ec5:	06                   	push   %es
  pushl %fs
80106ec6:	0f a0                	push   %fs
  pushl %gs
80106ec8:	0f a8                	push   %gs
  pushal
80106eca:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106ecb:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106ecf:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106ed1:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106ed3:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106ed7:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106ed9:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106edb:	54                   	push   %esp
  call trap
80106edc:	e8 ce 01 00 00       	call   801070af <trap>
  addl $4, %esp
80106ee1:	83 c4 04             	add    $0x4,%esp

80106ee4 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106ee4:	61                   	popa   
  popl %gs
80106ee5:	0f a9                	pop    %gs
  popl %fs
80106ee7:	0f a1                	pop    %fs
  popl %es
80106ee9:	07                   	pop    %es
  popl %ds
80106eea:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106eeb:	83 c4 08             	add    $0x8,%esp
  iret
80106eee:	cf                   	iret   

80106eef <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80106eef:	55                   	push   %ebp
80106ef0:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80106ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef5:	f0 ff 00             	lock incl (%eax)
}
80106ef8:	90                   	nop
80106ef9:	5d                   	pop    %ebp
80106efa:	c3                   	ret    

80106efb <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106efb:	55                   	push   %ebp
80106efc:	89 e5                	mov    %esp,%ebp
80106efe:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106f01:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f04:	83 e8 01             	sub    $0x1,%eax
80106f07:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f0e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106f12:	8b 45 08             	mov    0x8(%ebp),%eax
80106f15:	c1 e8 10             	shr    $0x10,%eax
80106f18:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106f1c:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106f1f:	0f 01 18             	lidtl  (%eax)
}
80106f22:	90                   	nop
80106f23:	c9                   	leave  
80106f24:	c3                   	ret    

80106f25 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106f25:	55                   	push   %ebp
80106f26:	89 e5                	mov    %esp,%ebp
80106f28:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106f2b:	0f 20 d0             	mov    %cr2,%eax
80106f2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106f34:	c9                   	leave  
80106f35:	c3                   	ret    

80106f36 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80106f36:	55                   	push   %ebp
80106f37:	89 e5                	mov    %esp,%ebp
80106f39:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80106f3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106f43:	e9 c3 00 00 00       	jmp    8010700b <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106f4b:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80106f52:	89 c2                	mov    %eax,%edx
80106f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106f57:	66 89 14 c5 e0 5e 11 	mov    %dx,-0x7feea120(,%eax,8)
80106f5e:	80 
80106f5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106f62:	66 c7 04 c5 e2 5e 11 	movw   $0x8,-0x7feea11e(,%eax,8)
80106f69:	80 08 00 
80106f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106f6f:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
80106f76:	80 
80106f77:	83 e2 e0             	and    $0xffffffe0,%edx
80106f7a:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
80106f81:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106f84:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
80106f8b:	80 
80106f8c:	83 e2 1f             	and    $0x1f,%edx
80106f8f:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
80106f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106f99:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80106fa0:	80 
80106fa1:	83 e2 f0             	and    $0xfffffff0,%edx
80106fa4:	83 ca 0e             	or     $0xe,%edx
80106fa7:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80106fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106fb1:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80106fb8:	80 
80106fb9:	83 e2 ef             	and    $0xffffffef,%edx
80106fbc:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80106fc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106fc6:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80106fcd:	80 
80106fce:	83 e2 9f             	and    $0xffffff9f,%edx
80106fd1:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80106fd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106fdb:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80106fe2:	80 
80106fe3:	83 ca 80             	or     $0xffffff80,%edx
80106fe6:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80106fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ff0:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80106ff7:	c1 e8 10             	shr    $0x10,%eax
80106ffa:	89 c2                	mov    %eax,%edx
80106ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106fff:	66 89 14 c5 e6 5e 11 	mov    %dx,-0x7feea11a(,%eax,8)
80107006:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107007:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010700b:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107012:	0f 8e 30 ff ff ff    	jle    80106f48 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107018:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
8010701d:	66 a3 e0 60 11 80    	mov    %ax,0x801160e0
80107023:	66 c7 05 e2 60 11 80 	movw   $0x8,0x801160e2
8010702a:	08 00 
8010702c:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
80107033:	83 e0 e0             	and    $0xffffffe0,%eax
80107036:	a2 e4 60 11 80       	mov    %al,0x801160e4
8010703b:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
80107042:	83 e0 1f             	and    $0x1f,%eax
80107045:	a2 e4 60 11 80       	mov    %al,0x801160e4
8010704a:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107051:	83 c8 0f             	or     $0xf,%eax
80107054:	a2 e5 60 11 80       	mov    %al,0x801160e5
80107059:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107060:	83 e0 ef             	and    $0xffffffef,%eax
80107063:	a2 e5 60 11 80       	mov    %al,0x801160e5
80107068:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
8010706f:	83 c8 60             	or     $0x60,%eax
80107072:	a2 e5 60 11 80       	mov    %al,0x801160e5
80107077:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
8010707e:	83 c8 80             	or     $0xffffff80,%eax
80107081:	a2 e5 60 11 80       	mov    %al,0x801160e5
80107086:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
8010708b:	c1 e8 10             	shr    $0x10,%eax
8010708e:	66 a3 e6 60 11 80    	mov    %ax,0x801160e6
  
}
80107094:	90                   	nop
80107095:	c9                   	leave  
80107096:	c3                   	ret    

80107097 <idtinit>:

void
idtinit(void)
{
80107097:	55                   	push   %ebp
80107098:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010709a:	68 00 08 00 00       	push   $0x800
8010709f:	68 e0 5e 11 80       	push   $0x80115ee0
801070a4:	e8 52 fe ff ff       	call   80106efb <lidt>
801070a9:	83 c4 08             	add    $0x8,%esp
}
801070ac:	90                   	nop
801070ad:	c9                   	leave  
801070ae:	c3                   	ret    

801070af <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801070af:	55                   	push   %ebp
801070b0:	89 e5                	mov    %esp,%ebp
801070b2:	57                   	push   %edi
801070b3:	56                   	push   %esi
801070b4:	53                   	push   %ebx
801070b5:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801070b8:	8b 45 08             	mov    0x8(%ebp),%eax
801070bb:	8b 40 30             	mov    0x30(%eax),%eax
801070be:	83 f8 40             	cmp    $0x40,%eax
801070c1:	75 3e                	jne    80107101 <trap+0x52>
    if(proc->killed)
801070c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070c9:	8b 40 24             	mov    0x24(%eax),%eax
801070cc:	85 c0                	test   %eax,%eax
801070ce:	74 05                	je     801070d5 <trap+0x26>
      exit();
801070d0:	e8 cc da ff ff       	call   80104ba1 <exit>
    proc->tf = tf;
801070d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070db:	8b 55 08             	mov    0x8(%ebp),%edx
801070de:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801070e1:	e8 a1 ec ff ff       	call   80105d87 <syscall>
    if(proc->killed)
801070e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070ec:	8b 40 24             	mov    0x24(%eax),%eax
801070ef:	85 c0                	test   %eax,%eax
801070f1:	0f 84 fe 01 00 00    	je     801072f5 <trap+0x246>
      exit();
801070f7:	e8 a5 da ff ff       	call   80104ba1 <exit>
    return;
801070fc:	e9 f4 01 00 00       	jmp    801072f5 <trap+0x246>
  }

  switch(tf->trapno){
80107101:	8b 45 08             	mov    0x8(%ebp),%eax
80107104:	8b 40 30             	mov    0x30(%eax),%eax
80107107:	83 e8 20             	sub    $0x20,%eax
8010710a:	83 f8 1f             	cmp    $0x1f,%eax
8010710d:	0f 87 a3 00 00 00    	ja     801071b6 <trap+0x107>
80107113:	8b 04 85 d8 93 10 80 	mov    -0x7fef6c28(,%eax,4),%eax
8010711a:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
8010711c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107122:	0f b6 00             	movzbl (%eax),%eax
80107125:	84 c0                	test   %al,%al
80107127:	75 20                	jne    80107149 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107129:	83 ec 0c             	sub    $0xc,%esp
8010712c:	68 e0 66 11 80       	push   $0x801166e0
80107131:	e8 b9 fd ff ff       	call   80106eef <atom_inc>
80107136:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107139:	83 ec 0c             	sub    $0xc,%esp
8010713c:	68 e0 66 11 80       	push   $0x801166e0
80107141:	e8 f4 df ff ff       	call   8010513a <wakeup>
80107146:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107149:	e8 fe be ff ff       	call   8010304c <lapiceoi>
    break;
8010714e:	e9 1c 01 00 00       	jmp    8010726f <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107153:	e8 07 b7 ff ff       	call   8010285f <ideintr>
    lapiceoi();
80107158:	e8 ef be ff ff       	call   8010304c <lapiceoi>
    break;
8010715d:	e9 0d 01 00 00       	jmp    8010726f <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107162:	e8 e7 bc ff ff       	call   80102e4e <kbdintr>
    lapiceoi();
80107167:	e8 e0 be ff ff       	call   8010304c <lapiceoi>
    break;
8010716c:	e9 fe 00 00 00       	jmp    8010726f <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107171:	e8 60 03 00 00       	call   801074d6 <uartintr>
    lapiceoi();
80107176:	e8 d1 be ff ff       	call   8010304c <lapiceoi>
    break;
8010717b:	e9 ef 00 00 00       	jmp    8010726f <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107180:	8b 45 08             	mov    0x8(%ebp),%eax
80107183:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107186:	8b 45 08             	mov    0x8(%ebp),%eax
80107189:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010718d:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107190:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107196:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107199:	0f b6 c0             	movzbl %al,%eax
8010719c:	51                   	push   %ecx
8010719d:	52                   	push   %edx
8010719e:	50                   	push   %eax
8010719f:	68 38 93 10 80       	push   $0x80109338
801071a4:	e8 1d 92 ff ff       	call   801003c6 <cprintf>
801071a9:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801071ac:	e8 9b be ff ff       	call   8010304c <lapiceoi>
    break;
801071b1:	e9 b9 00 00 00       	jmp    8010726f <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801071b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071bc:	85 c0                	test   %eax,%eax
801071be:	74 11                	je     801071d1 <trap+0x122>
801071c0:	8b 45 08             	mov    0x8(%ebp),%eax
801071c3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801071c7:	0f b7 c0             	movzwl %ax,%eax
801071ca:	83 e0 03             	and    $0x3,%eax
801071cd:	85 c0                	test   %eax,%eax
801071cf:	75 40                	jne    80107211 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801071d1:	e8 4f fd ff ff       	call   80106f25 <rcr2>
801071d6:	89 c3                	mov    %eax,%ebx
801071d8:	8b 45 08             	mov    0x8(%ebp),%eax
801071db:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801071de:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801071e4:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801071e7:	0f b6 d0             	movzbl %al,%edx
801071ea:	8b 45 08             	mov    0x8(%ebp),%eax
801071ed:	8b 40 30             	mov    0x30(%eax),%eax
801071f0:	83 ec 0c             	sub    $0xc,%esp
801071f3:	53                   	push   %ebx
801071f4:	51                   	push   %ecx
801071f5:	52                   	push   %edx
801071f6:	50                   	push   %eax
801071f7:	68 5c 93 10 80       	push   $0x8010935c
801071fc:	e8 c5 91 ff ff       	call   801003c6 <cprintf>
80107201:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107204:	83 ec 0c             	sub    $0xc,%esp
80107207:	68 8e 93 10 80       	push   $0x8010938e
8010720c:	e8 55 93 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107211:	e8 0f fd ff ff       	call   80106f25 <rcr2>
80107216:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107219:	8b 45 08             	mov    0x8(%ebp),%eax
8010721c:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010721f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107225:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107228:	0f b6 d8             	movzbl %al,%ebx
8010722b:	8b 45 08             	mov    0x8(%ebp),%eax
8010722e:	8b 48 34             	mov    0x34(%eax),%ecx
80107231:	8b 45 08             	mov    0x8(%ebp),%eax
80107234:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107237:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010723d:	8d 78 6c             	lea    0x6c(%eax),%edi
80107240:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107246:	8b 40 10             	mov    0x10(%eax),%eax
80107249:	ff 75 e4             	pushl  -0x1c(%ebp)
8010724c:	56                   	push   %esi
8010724d:	53                   	push   %ebx
8010724e:	51                   	push   %ecx
8010724f:	52                   	push   %edx
80107250:	57                   	push   %edi
80107251:	50                   	push   %eax
80107252:	68 94 93 10 80       	push   $0x80109394
80107257:	e8 6a 91 ff ff       	call   801003c6 <cprintf>
8010725c:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010725f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107265:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010726c:	eb 01                	jmp    8010726f <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010726e:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010726f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107275:	85 c0                	test   %eax,%eax
80107277:	74 24                	je     8010729d <trap+0x1ee>
80107279:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010727f:	8b 40 24             	mov    0x24(%eax),%eax
80107282:	85 c0                	test   %eax,%eax
80107284:	74 17                	je     8010729d <trap+0x1ee>
80107286:	8b 45 08             	mov    0x8(%ebp),%eax
80107289:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010728d:	0f b7 c0             	movzwl %ax,%eax
80107290:	83 e0 03             	and    $0x3,%eax
80107293:	83 f8 03             	cmp    $0x3,%eax
80107296:	75 05                	jne    8010729d <trap+0x1ee>
    exit();
80107298:	e8 04 d9 ff ff       	call   80104ba1 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010729d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072a3:	85 c0                	test   %eax,%eax
801072a5:	74 1e                	je     801072c5 <trap+0x216>
801072a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072ad:	8b 40 0c             	mov    0xc(%eax),%eax
801072b0:	83 f8 04             	cmp    $0x4,%eax
801072b3:	75 10                	jne    801072c5 <trap+0x216>
801072b5:	8b 45 08             	mov    0x8(%ebp),%eax
801072b8:	8b 40 30             	mov    0x30(%eax),%eax
801072bb:	83 f8 20             	cmp    $0x20,%eax
801072be:	75 05                	jne    801072c5 <trap+0x216>
    yield();
801072c0:	e8 0d dd ff ff       	call   80104fd2 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801072c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072cb:	85 c0                	test   %eax,%eax
801072cd:	74 27                	je     801072f6 <trap+0x247>
801072cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072d5:	8b 40 24             	mov    0x24(%eax),%eax
801072d8:	85 c0                	test   %eax,%eax
801072da:	74 1a                	je     801072f6 <trap+0x247>
801072dc:	8b 45 08             	mov    0x8(%ebp),%eax
801072df:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801072e3:	0f b7 c0             	movzwl %ax,%eax
801072e6:	83 e0 03             	and    $0x3,%eax
801072e9:	83 f8 03             	cmp    $0x3,%eax
801072ec:	75 08                	jne    801072f6 <trap+0x247>
    exit();
801072ee:	e8 ae d8 ff ff       	call   80104ba1 <exit>
801072f3:	eb 01                	jmp    801072f6 <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801072f5:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801072f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f9:	5b                   	pop    %ebx
801072fa:	5e                   	pop    %esi
801072fb:	5f                   	pop    %edi
801072fc:	5d                   	pop    %ebp
801072fd:	c3                   	ret    

801072fe <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801072fe:	55                   	push   %ebp
801072ff:	89 e5                	mov    %esp,%ebp
80107301:	83 ec 14             	sub    $0x14,%esp
80107304:	8b 45 08             	mov    0x8(%ebp),%eax
80107307:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010730b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010730f:	89 c2                	mov    %eax,%edx
80107311:	ec                   	in     (%dx),%al
80107312:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107315:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107319:	c9                   	leave  
8010731a:	c3                   	ret    

8010731b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010731b:	55                   	push   %ebp
8010731c:	89 e5                	mov    %esp,%ebp
8010731e:	83 ec 08             	sub    $0x8,%esp
80107321:	8b 55 08             	mov    0x8(%ebp),%edx
80107324:	8b 45 0c             	mov    0xc(%ebp),%eax
80107327:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010732b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010732e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107332:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107336:	ee                   	out    %al,(%dx)
}
80107337:	90                   	nop
80107338:	c9                   	leave  
80107339:	c3                   	ret    

8010733a <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010733a:	55                   	push   %ebp
8010733b:	89 e5                	mov    %esp,%ebp
8010733d:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107340:	6a 00                	push   $0x0
80107342:	68 fa 03 00 00       	push   $0x3fa
80107347:	e8 cf ff ff ff       	call   8010731b <outb>
8010734c:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010734f:	68 80 00 00 00       	push   $0x80
80107354:	68 fb 03 00 00       	push   $0x3fb
80107359:	e8 bd ff ff ff       	call   8010731b <outb>
8010735e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107361:	6a 0c                	push   $0xc
80107363:	68 f8 03 00 00       	push   $0x3f8
80107368:	e8 ae ff ff ff       	call   8010731b <outb>
8010736d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107370:	6a 00                	push   $0x0
80107372:	68 f9 03 00 00       	push   $0x3f9
80107377:	e8 9f ff ff ff       	call   8010731b <outb>
8010737c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010737f:	6a 03                	push   $0x3
80107381:	68 fb 03 00 00       	push   $0x3fb
80107386:	e8 90 ff ff ff       	call   8010731b <outb>
8010738b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010738e:	6a 00                	push   $0x0
80107390:	68 fc 03 00 00       	push   $0x3fc
80107395:	e8 81 ff ff ff       	call   8010731b <outb>
8010739a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010739d:	6a 01                	push   $0x1
8010739f:	68 f9 03 00 00       	push   $0x3f9
801073a4:	e8 72 ff ff ff       	call   8010731b <outb>
801073a9:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801073ac:	68 fd 03 00 00       	push   $0x3fd
801073b1:	e8 48 ff ff ff       	call   801072fe <inb>
801073b6:	83 c4 04             	add    $0x4,%esp
801073b9:	3c ff                	cmp    $0xff,%al
801073bb:	74 6e                	je     8010742b <uartinit+0xf1>
    return;
  uart = 1;
801073bd:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
801073c4:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801073c7:	68 fa 03 00 00       	push   $0x3fa
801073cc:	e8 2d ff ff ff       	call   801072fe <inb>
801073d1:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801073d4:	68 f8 03 00 00       	push   $0x3f8
801073d9:	e8 20 ff ff ff       	call   801072fe <inb>
801073de:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801073e1:	83 ec 0c             	sub    $0xc,%esp
801073e4:	6a 04                	push   $0x4
801073e6:	e8 67 cb ff ff       	call   80103f52 <picenable>
801073eb:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801073ee:	83 ec 08             	sub    $0x8,%esp
801073f1:	6a 00                	push   $0x0
801073f3:	6a 04                	push   $0x4
801073f5:	e8 07 b7 ff ff       	call   80102b01 <ioapicenable>
801073fa:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801073fd:	c7 45 f4 58 94 10 80 	movl   $0x80109458,-0xc(%ebp)
80107404:	eb 19                	jmp    8010741f <uartinit+0xe5>
    uartputc(*p);
80107406:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107409:	0f b6 00             	movzbl (%eax),%eax
8010740c:	0f be c0             	movsbl %al,%eax
8010740f:	83 ec 0c             	sub    $0xc,%esp
80107412:	50                   	push   %eax
80107413:	e8 16 00 00 00       	call   8010742e <uartputc>
80107418:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010741b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010741f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107422:	0f b6 00             	movzbl (%eax),%eax
80107425:	84 c0                	test   %al,%al
80107427:	75 dd                	jne    80107406 <uartinit+0xcc>
80107429:	eb 01                	jmp    8010742c <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010742b:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010742c:	c9                   	leave  
8010742d:	c3                   	ret    

8010742e <uartputc>:

void
uartputc(int c)
{
8010742e:	55                   	push   %ebp
8010742f:	89 e5                	mov    %esp,%ebp
80107431:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107434:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107439:	85 c0                	test   %eax,%eax
8010743b:	74 53                	je     80107490 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010743d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107444:	eb 11                	jmp    80107457 <uartputc+0x29>
    microdelay(10);
80107446:	83 ec 0c             	sub    $0xc,%esp
80107449:	6a 0a                	push   $0xa
8010744b:	e8 17 bc ff ff       	call   80103067 <microdelay>
80107450:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107453:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107457:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010745b:	7f 1a                	jg     80107477 <uartputc+0x49>
8010745d:	83 ec 0c             	sub    $0xc,%esp
80107460:	68 fd 03 00 00       	push   $0x3fd
80107465:	e8 94 fe ff ff       	call   801072fe <inb>
8010746a:	83 c4 10             	add    $0x10,%esp
8010746d:	0f b6 c0             	movzbl %al,%eax
80107470:	83 e0 20             	and    $0x20,%eax
80107473:	85 c0                	test   %eax,%eax
80107475:	74 cf                	je     80107446 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107477:	8b 45 08             	mov    0x8(%ebp),%eax
8010747a:	0f b6 c0             	movzbl %al,%eax
8010747d:	83 ec 08             	sub    $0x8,%esp
80107480:	50                   	push   %eax
80107481:	68 f8 03 00 00       	push   $0x3f8
80107486:	e8 90 fe ff ff       	call   8010731b <outb>
8010748b:	83 c4 10             	add    $0x10,%esp
8010748e:	eb 01                	jmp    80107491 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107490:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107491:	c9                   	leave  
80107492:	c3                   	ret    

80107493 <uartgetc>:

static int
uartgetc(void)
{
80107493:	55                   	push   %ebp
80107494:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107496:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
8010749b:	85 c0                	test   %eax,%eax
8010749d:	75 07                	jne    801074a6 <uartgetc+0x13>
    return -1;
8010749f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074a4:	eb 2e                	jmp    801074d4 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801074a6:	68 fd 03 00 00       	push   $0x3fd
801074ab:	e8 4e fe ff ff       	call   801072fe <inb>
801074b0:	83 c4 04             	add    $0x4,%esp
801074b3:	0f b6 c0             	movzbl %al,%eax
801074b6:	83 e0 01             	and    $0x1,%eax
801074b9:	85 c0                	test   %eax,%eax
801074bb:	75 07                	jne    801074c4 <uartgetc+0x31>
    return -1;
801074bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074c2:	eb 10                	jmp    801074d4 <uartgetc+0x41>
  return inb(COM1+0);
801074c4:	68 f8 03 00 00       	push   $0x3f8
801074c9:	e8 30 fe ff ff       	call   801072fe <inb>
801074ce:	83 c4 04             	add    $0x4,%esp
801074d1:	0f b6 c0             	movzbl %al,%eax
}
801074d4:	c9                   	leave  
801074d5:	c3                   	ret    

801074d6 <uartintr>:

void
uartintr(void)
{
801074d6:	55                   	push   %ebp
801074d7:	89 e5                	mov    %esp,%ebp
801074d9:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801074dc:	83 ec 0c             	sub    $0xc,%esp
801074df:	68 93 74 10 80       	push   $0x80107493
801074e4:	e8 10 93 ff ff       	call   801007f9 <consoleintr>
801074e9:	83 c4 10             	add    $0x10,%esp
}
801074ec:	90                   	nop
801074ed:	c9                   	leave  
801074ee:	c3                   	ret    

801074ef <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $0
801074f1:	6a 00                	push   $0x0
  jmp alltraps
801074f3:	e9 cc f9 ff ff       	jmp    80106ec4 <alltraps>

801074f8 <vector1>:
.globl vector1
vector1:
  pushl $0
801074f8:	6a 00                	push   $0x0
  pushl $1
801074fa:	6a 01                	push   $0x1
  jmp alltraps
801074fc:	e9 c3 f9 ff ff       	jmp    80106ec4 <alltraps>

80107501 <vector2>:
.globl vector2
vector2:
  pushl $0
80107501:	6a 00                	push   $0x0
  pushl $2
80107503:	6a 02                	push   $0x2
  jmp alltraps
80107505:	e9 ba f9 ff ff       	jmp    80106ec4 <alltraps>

8010750a <vector3>:
.globl vector3
vector3:
  pushl $0
8010750a:	6a 00                	push   $0x0
  pushl $3
8010750c:	6a 03                	push   $0x3
  jmp alltraps
8010750e:	e9 b1 f9 ff ff       	jmp    80106ec4 <alltraps>

80107513 <vector4>:
.globl vector4
vector4:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $4
80107515:	6a 04                	push   $0x4
  jmp alltraps
80107517:	e9 a8 f9 ff ff       	jmp    80106ec4 <alltraps>

8010751c <vector5>:
.globl vector5
vector5:
  pushl $0
8010751c:	6a 00                	push   $0x0
  pushl $5
8010751e:	6a 05                	push   $0x5
  jmp alltraps
80107520:	e9 9f f9 ff ff       	jmp    80106ec4 <alltraps>

80107525 <vector6>:
.globl vector6
vector6:
  pushl $0
80107525:	6a 00                	push   $0x0
  pushl $6
80107527:	6a 06                	push   $0x6
  jmp alltraps
80107529:	e9 96 f9 ff ff       	jmp    80106ec4 <alltraps>

8010752e <vector7>:
.globl vector7
vector7:
  pushl $0
8010752e:	6a 00                	push   $0x0
  pushl $7
80107530:	6a 07                	push   $0x7
  jmp alltraps
80107532:	e9 8d f9 ff ff       	jmp    80106ec4 <alltraps>

80107537 <vector8>:
.globl vector8
vector8:
  pushl $8
80107537:	6a 08                	push   $0x8
  jmp alltraps
80107539:	e9 86 f9 ff ff       	jmp    80106ec4 <alltraps>

8010753e <vector9>:
.globl vector9
vector9:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $9
80107540:	6a 09                	push   $0x9
  jmp alltraps
80107542:	e9 7d f9 ff ff       	jmp    80106ec4 <alltraps>

80107547 <vector10>:
.globl vector10
vector10:
  pushl $10
80107547:	6a 0a                	push   $0xa
  jmp alltraps
80107549:	e9 76 f9 ff ff       	jmp    80106ec4 <alltraps>

8010754e <vector11>:
.globl vector11
vector11:
  pushl $11
8010754e:	6a 0b                	push   $0xb
  jmp alltraps
80107550:	e9 6f f9 ff ff       	jmp    80106ec4 <alltraps>

80107555 <vector12>:
.globl vector12
vector12:
  pushl $12
80107555:	6a 0c                	push   $0xc
  jmp alltraps
80107557:	e9 68 f9 ff ff       	jmp    80106ec4 <alltraps>

8010755c <vector13>:
.globl vector13
vector13:
  pushl $13
8010755c:	6a 0d                	push   $0xd
  jmp alltraps
8010755e:	e9 61 f9 ff ff       	jmp    80106ec4 <alltraps>

80107563 <vector14>:
.globl vector14
vector14:
  pushl $14
80107563:	6a 0e                	push   $0xe
  jmp alltraps
80107565:	e9 5a f9 ff ff       	jmp    80106ec4 <alltraps>

8010756a <vector15>:
.globl vector15
vector15:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $15
8010756c:	6a 0f                	push   $0xf
  jmp alltraps
8010756e:	e9 51 f9 ff ff       	jmp    80106ec4 <alltraps>

80107573 <vector16>:
.globl vector16
vector16:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $16
80107575:	6a 10                	push   $0x10
  jmp alltraps
80107577:	e9 48 f9 ff ff       	jmp    80106ec4 <alltraps>

8010757c <vector17>:
.globl vector17
vector17:
  pushl $17
8010757c:	6a 11                	push   $0x11
  jmp alltraps
8010757e:	e9 41 f9 ff ff       	jmp    80106ec4 <alltraps>

80107583 <vector18>:
.globl vector18
vector18:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $18
80107585:	6a 12                	push   $0x12
  jmp alltraps
80107587:	e9 38 f9 ff ff       	jmp    80106ec4 <alltraps>

8010758c <vector19>:
.globl vector19
vector19:
  pushl $0
8010758c:	6a 00                	push   $0x0
  pushl $19
8010758e:	6a 13                	push   $0x13
  jmp alltraps
80107590:	e9 2f f9 ff ff       	jmp    80106ec4 <alltraps>

80107595 <vector20>:
.globl vector20
vector20:
  pushl $0
80107595:	6a 00                	push   $0x0
  pushl $20
80107597:	6a 14                	push   $0x14
  jmp alltraps
80107599:	e9 26 f9 ff ff       	jmp    80106ec4 <alltraps>

8010759e <vector21>:
.globl vector21
vector21:
  pushl $0
8010759e:	6a 00                	push   $0x0
  pushl $21
801075a0:	6a 15                	push   $0x15
  jmp alltraps
801075a2:	e9 1d f9 ff ff       	jmp    80106ec4 <alltraps>

801075a7 <vector22>:
.globl vector22
vector22:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $22
801075a9:	6a 16                	push   $0x16
  jmp alltraps
801075ab:	e9 14 f9 ff ff       	jmp    80106ec4 <alltraps>

801075b0 <vector23>:
.globl vector23
vector23:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $23
801075b2:	6a 17                	push   $0x17
  jmp alltraps
801075b4:	e9 0b f9 ff ff       	jmp    80106ec4 <alltraps>

801075b9 <vector24>:
.globl vector24
vector24:
  pushl $0
801075b9:	6a 00                	push   $0x0
  pushl $24
801075bb:	6a 18                	push   $0x18
  jmp alltraps
801075bd:	e9 02 f9 ff ff       	jmp    80106ec4 <alltraps>

801075c2 <vector25>:
.globl vector25
vector25:
  pushl $0
801075c2:	6a 00                	push   $0x0
  pushl $25
801075c4:	6a 19                	push   $0x19
  jmp alltraps
801075c6:	e9 f9 f8 ff ff       	jmp    80106ec4 <alltraps>

801075cb <vector26>:
.globl vector26
vector26:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $26
801075cd:	6a 1a                	push   $0x1a
  jmp alltraps
801075cf:	e9 f0 f8 ff ff       	jmp    80106ec4 <alltraps>

801075d4 <vector27>:
.globl vector27
vector27:
  pushl $0
801075d4:	6a 00                	push   $0x0
  pushl $27
801075d6:	6a 1b                	push   $0x1b
  jmp alltraps
801075d8:	e9 e7 f8 ff ff       	jmp    80106ec4 <alltraps>

801075dd <vector28>:
.globl vector28
vector28:
  pushl $0
801075dd:	6a 00                	push   $0x0
  pushl $28
801075df:	6a 1c                	push   $0x1c
  jmp alltraps
801075e1:	e9 de f8 ff ff       	jmp    80106ec4 <alltraps>

801075e6 <vector29>:
.globl vector29
vector29:
  pushl $0
801075e6:	6a 00                	push   $0x0
  pushl $29
801075e8:	6a 1d                	push   $0x1d
  jmp alltraps
801075ea:	e9 d5 f8 ff ff       	jmp    80106ec4 <alltraps>

801075ef <vector30>:
.globl vector30
vector30:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $30
801075f1:	6a 1e                	push   $0x1e
  jmp alltraps
801075f3:	e9 cc f8 ff ff       	jmp    80106ec4 <alltraps>

801075f8 <vector31>:
.globl vector31
vector31:
  pushl $0
801075f8:	6a 00                	push   $0x0
  pushl $31
801075fa:	6a 1f                	push   $0x1f
  jmp alltraps
801075fc:	e9 c3 f8 ff ff       	jmp    80106ec4 <alltraps>

80107601 <vector32>:
.globl vector32
vector32:
  pushl $0
80107601:	6a 00                	push   $0x0
  pushl $32
80107603:	6a 20                	push   $0x20
  jmp alltraps
80107605:	e9 ba f8 ff ff       	jmp    80106ec4 <alltraps>

8010760a <vector33>:
.globl vector33
vector33:
  pushl $0
8010760a:	6a 00                	push   $0x0
  pushl $33
8010760c:	6a 21                	push   $0x21
  jmp alltraps
8010760e:	e9 b1 f8 ff ff       	jmp    80106ec4 <alltraps>

80107613 <vector34>:
.globl vector34
vector34:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $34
80107615:	6a 22                	push   $0x22
  jmp alltraps
80107617:	e9 a8 f8 ff ff       	jmp    80106ec4 <alltraps>

8010761c <vector35>:
.globl vector35
vector35:
  pushl $0
8010761c:	6a 00                	push   $0x0
  pushl $35
8010761e:	6a 23                	push   $0x23
  jmp alltraps
80107620:	e9 9f f8 ff ff       	jmp    80106ec4 <alltraps>

80107625 <vector36>:
.globl vector36
vector36:
  pushl $0
80107625:	6a 00                	push   $0x0
  pushl $36
80107627:	6a 24                	push   $0x24
  jmp alltraps
80107629:	e9 96 f8 ff ff       	jmp    80106ec4 <alltraps>

8010762e <vector37>:
.globl vector37
vector37:
  pushl $0
8010762e:	6a 00                	push   $0x0
  pushl $37
80107630:	6a 25                	push   $0x25
  jmp alltraps
80107632:	e9 8d f8 ff ff       	jmp    80106ec4 <alltraps>

80107637 <vector38>:
.globl vector38
vector38:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $38
80107639:	6a 26                	push   $0x26
  jmp alltraps
8010763b:	e9 84 f8 ff ff       	jmp    80106ec4 <alltraps>

80107640 <vector39>:
.globl vector39
vector39:
  pushl $0
80107640:	6a 00                	push   $0x0
  pushl $39
80107642:	6a 27                	push   $0x27
  jmp alltraps
80107644:	e9 7b f8 ff ff       	jmp    80106ec4 <alltraps>

80107649 <vector40>:
.globl vector40
vector40:
  pushl $0
80107649:	6a 00                	push   $0x0
  pushl $40
8010764b:	6a 28                	push   $0x28
  jmp alltraps
8010764d:	e9 72 f8 ff ff       	jmp    80106ec4 <alltraps>

80107652 <vector41>:
.globl vector41
vector41:
  pushl $0
80107652:	6a 00                	push   $0x0
  pushl $41
80107654:	6a 29                	push   $0x29
  jmp alltraps
80107656:	e9 69 f8 ff ff       	jmp    80106ec4 <alltraps>

8010765b <vector42>:
.globl vector42
vector42:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $42
8010765d:	6a 2a                	push   $0x2a
  jmp alltraps
8010765f:	e9 60 f8 ff ff       	jmp    80106ec4 <alltraps>

80107664 <vector43>:
.globl vector43
vector43:
  pushl $0
80107664:	6a 00                	push   $0x0
  pushl $43
80107666:	6a 2b                	push   $0x2b
  jmp alltraps
80107668:	e9 57 f8 ff ff       	jmp    80106ec4 <alltraps>

8010766d <vector44>:
.globl vector44
vector44:
  pushl $0
8010766d:	6a 00                	push   $0x0
  pushl $44
8010766f:	6a 2c                	push   $0x2c
  jmp alltraps
80107671:	e9 4e f8 ff ff       	jmp    80106ec4 <alltraps>

80107676 <vector45>:
.globl vector45
vector45:
  pushl $0
80107676:	6a 00                	push   $0x0
  pushl $45
80107678:	6a 2d                	push   $0x2d
  jmp alltraps
8010767a:	e9 45 f8 ff ff       	jmp    80106ec4 <alltraps>

8010767f <vector46>:
.globl vector46
vector46:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $46
80107681:	6a 2e                	push   $0x2e
  jmp alltraps
80107683:	e9 3c f8 ff ff       	jmp    80106ec4 <alltraps>

80107688 <vector47>:
.globl vector47
vector47:
  pushl $0
80107688:	6a 00                	push   $0x0
  pushl $47
8010768a:	6a 2f                	push   $0x2f
  jmp alltraps
8010768c:	e9 33 f8 ff ff       	jmp    80106ec4 <alltraps>

80107691 <vector48>:
.globl vector48
vector48:
  pushl $0
80107691:	6a 00                	push   $0x0
  pushl $48
80107693:	6a 30                	push   $0x30
  jmp alltraps
80107695:	e9 2a f8 ff ff       	jmp    80106ec4 <alltraps>

8010769a <vector49>:
.globl vector49
vector49:
  pushl $0
8010769a:	6a 00                	push   $0x0
  pushl $49
8010769c:	6a 31                	push   $0x31
  jmp alltraps
8010769e:	e9 21 f8 ff ff       	jmp    80106ec4 <alltraps>

801076a3 <vector50>:
.globl vector50
vector50:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $50
801076a5:	6a 32                	push   $0x32
  jmp alltraps
801076a7:	e9 18 f8 ff ff       	jmp    80106ec4 <alltraps>

801076ac <vector51>:
.globl vector51
vector51:
  pushl $0
801076ac:	6a 00                	push   $0x0
  pushl $51
801076ae:	6a 33                	push   $0x33
  jmp alltraps
801076b0:	e9 0f f8 ff ff       	jmp    80106ec4 <alltraps>

801076b5 <vector52>:
.globl vector52
vector52:
  pushl $0
801076b5:	6a 00                	push   $0x0
  pushl $52
801076b7:	6a 34                	push   $0x34
  jmp alltraps
801076b9:	e9 06 f8 ff ff       	jmp    80106ec4 <alltraps>

801076be <vector53>:
.globl vector53
vector53:
  pushl $0
801076be:	6a 00                	push   $0x0
  pushl $53
801076c0:	6a 35                	push   $0x35
  jmp alltraps
801076c2:	e9 fd f7 ff ff       	jmp    80106ec4 <alltraps>

801076c7 <vector54>:
.globl vector54
vector54:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $54
801076c9:	6a 36                	push   $0x36
  jmp alltraps
801076cb:	e9 f4 f7 ff ff       	jmp    80106ec4 <alltraps>

801076d0 <vector55>:
.globl vector55
vector55:
  pushl $0
801076d0:	6a 00                	push   $0x0
  pushl $55
801076d2:	6a 37                	push   $0x37
  jmp alltraps
801076d4:	e9 eb f7 ff ff       	jmp    80106ec4 <alltraps>

801076d9 <vector56>:
.globl vector56
vector56:
  pushl $0
801076d9:	6a 00                	push   $0x0
  pushl $56
801076db:	6a 38                	push   $0x38
  jmp alltraps
801076dd:	e9 e2 f7 ff ff       	jmp    80106ec4 <alltraps>

801076e2 <vector57>:
.globl vector57
vector57:
  pushl $0
801076e2:	6a 00                	push   $0x0
  pushl $57
801076e4:	6a 39                	push   $0x39
  jmp alltraps
801076e6:	e9 d9 f7 ff ff       	jmp    80106ec4 <alltraps>

801076eb <vector58>:
.globl vector58
vector58:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $58
801076ed:	6a 3a                	push   $0x3a
  jmp alltraps
801076ef:	e9 d0 f7 ff ff       	jmp    80106ec4 <alltraps>

801076f4 <vector59>:
.globl vector59
vector59:
  pushl $0
801076f4:	6a 00                	push   $0x0
  pushl $59
801076f6:	6a 3b                	push   $0x3b
  jmp alltraps
801076f8:	e9 c7 f7 ff ff       	jmp    80106ec4 <alltraps>

801076fd <vector60>:
.globl vector60
vector60:
  pushl $0
801076fd:	6a 00                	push   $0x0
  pushl $60
801076ff:	6a 3c                	push   $0x3c
  jmp alltraps
80107701:	e9 be f7 ff ff       	jmp    80106ec4 <alltraps>

80107706 <vector61>:
.globl vector61
vector61:
  pushl $0
80107706:	6a 00                	push   $0x0
  pushl $61
80107708:	6a 3d                	push   $0x3d
  jmp alltraps
8010770a:	e9 b5 f7 ff ff       	jmp    80106ec4 <alltraps>

8010770f <vector62>:
.globl vector62
vector62:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $62
80107711:	6a 3e                	push   $0x3e
  jmp alltraps
80107713:	e9 ac f7 ff ff       	jmp    80106ec4 <alltraps>

80107718 <vector63>:
.globl vector63
vector63:
  pushl $0
80107718:	6a 00                	push   $0x0
  pushl $63
8010771a:	6a 3f                	push   $0x3f
  jmp alltraps
8010771c:	e9 a3 f7 ff ff       	jmp    80106ec4 <alltraps>

80107721 <vector64>:
.globl vector64
vector64:
  pushl $0
80107721:	6a 00                	push   $0x0
  pushl $64
80107723:	6a 40                	push   $0x40
  jmp alltraps
80107725:	e9 9a f7 ff ff       	jmp    80106ec4 <alltraps>

8010772a <vector65>:
.globl vector65
vector65:
  pushl $0
8010772a:	6a 00                	push   $0x0
  pushl $65
8010772c:	6a 41                	push   $0x41
  jmp alltraps
8010772e:	e9 91 f7 ff ff       	jmp    80106ec4 <alltraps>

80107733 <vector66>:
.globl vector66
vector66:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $66
80107735:	6a 42                	push   $0x42
  jmp alltraps
80107737:	e9 88 f7 ff ff       	jmp    80106ec4 <alltraps>

8010773c <vector67>:
.globl vector67
vector67:
  pushl $0
8010773c:	6a 00                	push   $0x0
  pushl $67
8010773e:	6a 43                	push   $0x43
  jmp alltraps
80107740:	e9 7f f7 ff ff       	jmp    80106ec4 <alltraps>

80107745 <vector68>:
.globl vector68
vector68:
  pushl $0
80107745:	6a 00                	push   $0x0
  pushl $68
80107747:	6a 44                	push   $0x44
  jmp alltraps
80107749:	e9 76 f7 ff ff       	jmp    80106ec4 <alltraps>

8010774e <vector69>:
.globl vector69
vector69:
  pushl $0
8010774e:	6a 00                	push   $0x0
  pushl $69
80107750:	6a 45                	push   $0x45
  jmp alltraps
80107752:	e9 6d f7 ff ff       	jmp    80106ec4 <alltraps>

80107757 <vector70>:
.globl vector70
vector70:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $70
80107759:	6a 46                	push   $0x46
  jmp alltraps
8010775b:	e9 64 f7 ff ff       	jmp    80106ec4 <alltraps>

80107760 <vector71>:
.globl vector71
vector71:
  pushl $0
80107760:	6a 00                	push   $0x0
  pushl $71
80107762:	6a 47                	push   $0x47
  jmp alltraps
80107764:	e9 5b f7 ff ff       	jmp    80106ec4 <alltraps>

80107769 <vector72>:
.globl vector72
vector72:
  pushl $0
80107769:	6a 00                	push   $0x0
  pushl $72
8010776b:	6a 48                	push   $0x48
  jmp alltraps
8010776d:	e9 52 f7 ff ff       	jmp    80106ec4 <alltraps>

80107772 <vector73>:
.globl vector73
vector73:
  pushl $0
80107772:	6a 00                	push   $0x0
  pushl $73
80107774:	6a 49                	push   $0x49
  jmp alltraps
80107776:	e9 49 f7 ff ff       	jmp    80106ec4 <alltraps>

8010777b <vector74>:
.globl vector74
vector74:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $74
8010777d:	6a 4a                	push   $0x4a
  jmp alltraps
8010777f:	e9 40 f7 ff ff       	jmp    80106ec4 <alltraps>

80107784 <vector75>:
.globl vector75
vector75:
  pushl $0
80107784:	6a 00                	push   $0x0
  pushl $75
80107786:	6a 4b                	push   $0x4b
  jmp alltraps
80107788:	e9 37 f7 ff ff       	jmp    80106ec4 <alltraps>

8010778d <vector76>:
.globl vector76
vector76:
  pushl $0
8010778d:	6a 00                	push   $0x0
  pushl $76
8010778f:	6a 4c                	push   $0x4c
  jmp alltraps
80107791:	e9 2e f7 ff ff       	jmp    80106ec4 <alltraps>

80107796 <vector77>:
.globl vector77
vector77:
  pushl $0
80107796:	6a 00                	push   $0x0
  pushl $77
80107798:	6a 4d                	push   $0x4d
  jmp alltraps
8010779a:	e9 25 f7 ff ff       	jmp    80106ec4 <alltraps>

8010779f <vector78>:
.globl vector78
vector78:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $78
801077a1:	6a 4e                	push   $0x4e
  jmp alltraps
801077a3:	e9 1c f7 ff ff       	jmp    80106ec4 <alltraps>

801077a8 <vector79>:
.globl vector79
vector79:
  pushl $0
801077a8:	6a 00                	push   $0x0
  pushl $79
801077aa:	6a 4f                	push   $0x4f
  jmp alltraps
801077ac:	e9 13 f7 ff ff       	jmp    80106ec4 <alltraps>

801077b1 <vector80>:
.globl vector80
vector80:
  pushl $0
801077b1:	6a 00                	push   $0x0
  pushl $80
801077b3:	6a 50                	push   $0x50
  jmp alltraps
801077b5:	e9 0a f7 ff ff       	jmp    80106ec4 <alltraps>

801077ba <vector81>:
.globl vector81
vector81:
  pushl $0
801077ba:	6a 00                	push   $0x0
  pushl $81
801077bc:	6a 51                	push   $0x51
  jmp alltraps
801077be:	e9 01 f7 ff ff       	jmp    80106ec4 <alltraps>

801077c3 <vector82>:
.globl vector82
vector82:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $82
801077c5:	6a 52                	push   $0x52
  jmp alltraps
801077c7:	e9 f8 f6 ff ff       	jmp    80106ec4 <alltraps>

801077cc <vector83>:
.globl vector83
vector83:
  pushl $0
801077cc:	6a 00                	push   $0x0
  pushl $83
801077ce:	6a 53                	push   $0x53
  jmp alltraps
801077d0:	e9 ef f6 ff ff       	jmp    80106ec4 <alltraps>

801077d5 <vector84>:
.globl vector84
vector84:
  pushl $0
801077d5:	6a 00                	push   $0x0
  pushl $84
801077d7:	6a 54                	push   $0x54
  jmp alltraps
801077d9:	e9 e6 f6 ff ff       	jmp    80106ec4 <alltraps>

801077de <vector85>:
.globl vector85
vector85:
  pushl $0
801077de:	6a 00                	push   $0x0
  pushl $85
801077e0:	6a 55                	push   $0x55
  jmp alltraps
801077e2:	e9 dd f6 ff ff       	jmp    80106ec4 <alltraps>

801077e7 <vector86>:
.globl vector86
vector86:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $86
801077e9:	6a 56                	push   $0x56
  jmp alltraps
801077eb:	e9 d4 f6 ff ff       	jmp    80106ec4 <alltraps>

801077f0 <vector87>:
.globl vector87
vector87:
  pushl $0
801077f0:	6a 00                	push   $0x0
  pushl $87
801077f2:	6a 57                	push   $0x57
  jmp alltraps
801077f4:	e9 cb f6 ff ff       	jmp    80106ec4 <alltraps>

801077f9 <vector88>:
.globl vector88
vector88:
  pushl $0
801077f9:	6a 00                	push   $0x0
  pushl $88
801077fb:	6a 58                	push   $0x58
  jmp alltraps
801077fd:	e9 c2 f6 ff ff       	jmp    80106ec4 <alltraps>

80107802 <vector89>:
.globl vector89
vector89:
  pushl $0
80107802:	6a 00                	push   $0x0
  pushl $89
80107804:	6a 59                	push   $0x59
  jmp alltraps
80107806:	e9 b9 f6 ff ff       	jmp    80106ec4 <alltraps>

8010780b <vector90>:
.globl vector90
vector90:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $90
8010780d:	6a 5a                	push   $0x5a
  jmp alltraps
8010780f:	e9 b0 f6 ff ff       	jmp    80106ec4 <alltraps>

80107814 <vector91>:
.globl vector91
vector91:
  pushl $0
80107814:	6a 00                	push   $0x0
  pushl $91
80107816:	6a 5b                	push   $0x5b
  jmp alltraps
80107818:	e9 a7 f6 ff ff       	jmp    80106ec4 <alltraps>

8010781d <vector92>:
.globl vector92
vector92:
  pushl $0
8010781d:	6a 00                	push   $0x0
  pushl $92
8010781f:	6a 5c                	push   $0x5c
  jmp alltraps
80107821:	e9 9e f6 ff ff       	jmp    80106ec4 <alltraps>

80107826 <vector93>:
.globl vector93
vector93:
  pushl $0
80107826:	6a 00                	push   $0x0
  pushl $93
80107828:	6a 5d                	push   $0x5d
  jmp alltraps
8010782a:	e9 95 f6 ff ff       	jmp    80106ec4 <alltraps>

8010782f <vector94>:
.globl vector94
vector94:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $94
80107831:	6a 5e                	push   $0x5e
  jmp alltraps
80107833:	e9 8c f6 ff ff       	jmp    80106ec4 <alltraps>

80107838 <vector95>:
.globl vector95
vector95:
  pushl $0
80107838:	6a 00                	push   $0x0
  pushl $95
8010783a:	6a 5f                	push   $0x5f
  jmp alltraps
8010783c:	e9 83 f6 ff ff       	jmp    80106ec4 <alltraps>

80107841 <vector96>:
.globl vector96
vector96:
  pushl $0
80107841:	6a 00                	push   $0x0
  pushl $96
80107843:	6a 60                	push   $0x60
  jmp alltraps
80107845:	e9 7a f6 ff ff       	jmp    80106ec4 <alltraps>

8010784a <vector97>:
.globl vector97
vector97:
  pushl $0
8010784a:	6a 00                	push   $0x0
  pushl $97
8010784c:	6a 61                	push   $0x61
  jmp alltraps
8010784e:	e9 71 f6 ff ff       	jmp    80106ec4 <alltraps>

80107853 <vector98>:
.globl vector98
vector98:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $98
80107855:	6a 62                	push   $0x62
  jmp alltraps
80107857:	e9 68 f6 ff ff       	jmp    80106ec4 <alltraps>

8010785c <vector99>:
.globl vector99
vector99:
  pushl $0
8010785c:	6a 00                	push   $0x0
  pushl $99
8010785e:	6a 63                	push   $0x63
  jmp alltraps
80107860:	e9 5f f6 ff ff       	jmp    80106ec4 <alltraps>

80107865 <vector100>:
.globl vector100
vector100:
  pushl $0
80107865:	6a 00                	push   $0x0
  pushl $100
80107867:	6a 64                	push   $0x64
  jmp alltraps
80107869:	e9 56 f6 ff ff       	jmp    80106ec4 <alltraps>

8010786e <vector101>:
.globl vector101
vector101:
  pushl $0
8010786e:	6a 00                	push   $0x0
  pushl $101
80107870:	6a 65                	push   $0x65
  jmp alltraps
80107872:	e9 4d f6 ff ff       	jmp    80106ec4 <alltraps>

80107877 <vector102>:
.globl vector102
vector102:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $102
80107879:	6a 66                	push   $0x66
  jmp alltraps
8010787b:	e9 44 f6 ff ff       	jmp    80106ec4 <alltraps>

80107880 <vector103>:
.globl vector103
vector103:
  pushl $0
80107880:	6a 00                	push   $0x0
  pushl $103
80107882:	6a 67                	push   $0x67
  jmp alltraps
80107884:	e9 3b f6 ff ff       	jmp    80106ec4 <alltraps>

80107889 <vector104>:
.globl vector104
vector104:
  pushl $0
80107889:	6a 00                	push   $0x0
  pushl $104
8010788b:	6a 68                	push   $0x68
  jmp alltraps
8010788d:	e9 32 f6 ff ff       	jmp    80106ec4 <alltraps>

80107892 <vector105>:
.globl vector105
vector105:
  pushl $0
80107892:	6a 00                	push   $0x0
  pushl $105
80107894:	6a 69                	push   $0x69
  jmp alltraps
80107896:	e9 29 f6 ff ff       	jmp    80106ec4 <alltraps>

8010789b <vector106>:
.globl vector106
vector106:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $106
8010789d:	6a 6a                	push   $0x6a
  jmp alltraps
8010789f:	e9 20 f6 ff ff       	jmp    80106ec4 <alltraps>

801078a4 <vector107>:
.globl vector107
vector107:
  pushl $0
801078a4:	6a 00                	push   $0x0
  pushl $107
801078a6:	6a 6b                	push   $0x6b
  jmp alltraps
801078a8:	e9 17 f6 ff ff       	jmp    80106ec4 <alltraps>

801078ad <vector108>:
.globl vector108
vector108:
  pushl $0
801078ad:	6a 00                	push   $0x0
  pushl $108
801078af:	6a 6c                	push   $0x6c
  jmp alltraps
801078b1:	e9 0e f6 ff ff       	jmp    80106ec4 <alltraps>

801078b6 <vector109>:
.globl vector109
vector109:
  pushl $0
801078b6:	6a 00                	push   $0x0
  pushl $109
801078b8:	6a 6d                	push   $0x6d
  jmp alltraps
801078ba:	e9 05 f6 ff ff       	jmp    80106ec4 <alltraps>

801078bf <vector110>:
.globl vector110
vector110:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $110
801078c1:	6a 6e                	push   $0x6e
  jmp alltraps
801078c3:	e9 fc f5 ff ff       	jmp    80106ec4 <alltraps>

801078c8 <vector111>:
.globl vector111
vector111:
  pushl $0
801078c8:	6a 00                	push   $0x0
  pushl $111
801078ca:	6a 6f                	push   $0x6f
  jmp alltraps
801078cc:	e9 f3 f5 ff ff       	jmp    80106ec4 <alltraps>

801078d1 <vector112>:
.globl vector112
vector112:
  pushl $0
801078d1:	6a 00                	push   $0x0
  pushl $112
801078d3:	6a 70                	push   $0x70
  jmp alltraps
801078d5:	e9 ea f5 ff ff       	jmp    80106ec4 <alltraps>

801078da <vector113>:
.globl vector113
vector113:
  pushl $0
801078da:	6a 00                	push   $0x0
  pushl $113
801078dc:	6a 71                	push   $0x71
  jmp alltraps
801078de:	e9 e1 f5 ff ff       	jmp    80106ec4 <alltraps>

801078e3 <vector114>:
.globl vector114
vector114:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $114
801078e5:	6a 72                	push   $0x72
  jmp alltraps
801078e7:	e9 d8 f5 ff ff       	jmp    80106ec4 <alltraps>

801078ec <vector115>:
.globl vector115
vector115:
  pushl $0
801078ec:	6a 00                	push   $0x0
  pushl $115
801078ee:	6a 73                	push   $0x73
  jmp alltraps
801078f0:	e9 cf f5 ff ff       	jmp    80106ec4 <alltraps>

801078f5 <vector116>:
.globl vector116
vector116:
  pushl $0
801078f5:	6a 00                	push   $0x0
  pushl $116
801078f7:	6a 74                	push   $0x74
  jmp alltraps
801078f9:	e9 c6 f5 ff ff       	jmp    80106ec4 <alltraps>

801078fe <vector117>:
.globl vector117
vector117:
  pushl $0
801078fe:	6a 00                	push   $0x0
  pushl $117
80107900:	6a 75                	push   $0x75
  jmp alltraps
80107902:	e9 bd f5 ff ff       	jmp    80106ec4 <alltraps>

80107907 <vector118>:
.globl vector118
vector118:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $118
80107909:	6a 76                	push   $0x76
  jmp alltraps
8010790b:	e9 b4 f5 ff ff       	jmp    80106ec4 <alltraps>

80107910 <vector119>:
.globl vector119
vector119:
  pushl $0
80107910:	6a 00                	push   $0x0
  pushl $119
80107912:	6a 77                	push   $0x77
  jmp alltraps
80107914:	e9 ab f5 ff ff       	jmp    80106ec4 <alltraps>

80107919 <vector120>:
.globl vector120
vector120:
  pushl $0
80107919:	6a 00                	push   $0x0
  pushl $120
8010791b:	6a 78                	push   $0x78
  jmp alltraps
8010791d:	e9 a2 f5 ff ff       	jmp    80106ec4 <alltraps>

80107922 <vector121>:
.globl vector121
vector121:
  pushl $0
80107922:	6a 00                	push   $0x0
  pushl $121
80107924:	6a 79                	push   $0x79
  jmp alltraps
80107926:	e9 99 f5 ff ff       	jmp    80106ec4 <alltraps>

8010792b <vector122>:
.globl vector122
vector122:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $122
8010792d:	6a 7a                	push   $0x7a
  jmp alltraps
8010792f:	e9 90 f5 ff ff       	jmp    80106ec4 <alltraps>

80107934 <vector123>:
.globl vector123
vector123:
  pushl $0
80107934:	6a 00                	push   $0x0
  pushl $123
80107936:	6a 7b                	push   $0x7b
  jmp alltraps
80107938:	e9 87 f5 ff ff       	jmp    80106ec4 <alltraps>

8010793d <vector124>:
.globl vector124
vector124:
  pushl $0
8010793d:	6a 00                	push   $0x0
  pushl $124
8010793f:	6a 7c                	push   $0x7c
  jmp alltraps
80107941:	e9 7e f5 ff ff       	jmp    80106ec4 <alltraps>

80107946 <vector125>:
.globl vector125
vector125:
  pushl $0
80107946:	6a 00                	push   $0x0
  pushl $125
80107948:	6a 7d                	push   $0x7d
  jmp alltraps
8010794a:	e9 75 f5 ff ff       	jmp    80106ec4 <alltraps>

8010794f <vector126>:
.globl vector126
vector126:
  pushl $0
8010794f:	6a 00                	push   $0x0
  pushl $126
80107951:	6a 7e                	push   $0x7e
  jmp alltraps
80107953:	e9 6c f5 ff ff       	jmp    80106ec4 <alltraps>

80107958 <vector127>:
.globl vector127
vector127:
  pushl $0
80107958:	6a 00                	push   $0x0
  pushl $127
8010795a:	6a 7f                	push   $0x7f
  jmp alltraps
8010795c:	e9 63 f5 ff ff       	jmp    80106ec4 <alltraps>

80107961 <vector128>:
.globl vector128
vector128:
  pushl $0
80107961:	6a 00                	push   $0x0
  pushl $128
80107963:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107968:	e9 57 f5 ff ff       	jmp    80106ec4 <alltraps>

8010796d <vector129>:
.globl vector129
vector129:
  pushl $0
8010796d:	6a 00                	push   $0x0
  pushl $129
8010796f:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107974:	e9 4b f5 ff ff       	jmp    80106ec4 <alltraps>

80107979 <vector130>:
.globl vector130
vector130:
  pushl $0
80107979:	6a 00                	push   $0x0
  pushl $130
8010797b:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107980:	e9 3f f5 ff ff       	jmp    80106ec4 <alltraps>

80107985 <vector131>:
.globl vector131
vector131:
  pushl $0
80107985:	6a 00                	push   $0x0
  pushl $131
80107987:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010798c:	e9 33 f5 ff ff       	jmp    80106ec4 <alltraps>

80107991 <vector132>:
.globl vector132
vector132:
  pushl $0
80107991:	6a 00                	push   $0x0
  pushl $132
80107993:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107998:	e9 27 f5 ff ff       	jmp    80106ec4 <alltraps>

8010799d <vector133>:
.globl vector133
vector133:
  pushl $0
8010799d:	6a 00                	push   $0x0
  pushl $133
8010799f:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801079a4:	e9 1b f5 ff ff       	jmp    80106ec4 <alltraps>

801079a9 <vector134>:
.globl vector134
vector134:
  pushl $0
801079a9:	6a 00                	push   $0x0
  pushl $134
801079ab:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801079b0:	e9 0f f5 ff ff       	jmp    80106ec4 <alltraps>

801079b5 <vector135>:
.globl vector135
vector135:
  pushl $0
801079b5:	6a 00                	push   $0x0
  pushl $135
801079b7:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801079bc:	e9 03 f5 ff ff       	jmp    80106ec4 <alltraps>

801079c1 <vector136>:
.globl vector136
vector136:
  pushl $0
801079c1:	6a 00                	push   $0x0
  pushl $136
801079c3:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801079c8:	e9 f7 f4 ff ff       	jmp    80106ec4 <alltraps>

801079cd <vector137>:
.globl vector137
vector137:
  pushl $0
801079cd:	6a 00                	push   $0x0
  pushl $137
801079cf:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801079d4:	e9 eb f4 ff ff       	jmp    80106ec4 <alltraps>

801079d9 <vector138>:
.globl vector138
vector138:
  pushl $0
801079d9:	6a 00                	push   $0x0
  pushl $138
801079db:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801079e0:	e9 df f4 ff ff       	jmp    80106ec4 <alltraps>

801079e5 <vector139>:
.globl vector139
vector139:
  pushl $0
801079e5:	6a 00                	push   $0x0
  pushl $139
801079e7:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801079ec:	e9 d3 f4 ff ff       	jmp    80106ec4 <alltraps>

801079f1 <vector140>:
.globl vector140
vector140:
  pushl $0
801079f1:	6a 00                	push   $0x0
  pushl $140
801079f3:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801079f8:	e9 c7 f4 ff ff       	jmp    80106ec4 <alltraps>

801079fd <vector141>:
.globl vector141
vector141:
  pushl $0
801079fd:	6a 00                	push   $0x0
  pushl $141
801079ff:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107a04:	e9 bb f4 ff ff       	jmp    80106ec4 <alltraps>

80107a09 <vector142>:
.globl vector142
vector142:
  pushl $0
80107a09:	6a 00                	push   $0x0
  pushl $142
80107a0b:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107a10:	e9 af f4 ff ff       	jmp    80106ec4 <alltraps>

80107a15 <vector143>:
.globl vector143
vector143:
  pushl $0
80107a15:	6a 00                	push   $0x0
  pushl $143
80107a17:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107a1c:	e9 a3 f4 ff ff       	jmp    80106ec4 <alltraps>

80107a21 <vector144>:
.globl vector144
vector144:
  pushl $0
80107a21:	6a 00                	push   $0x0
  pushl $144
80107a23:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107a28:	e9 97 f4 ff ff       	jmp    80106ec4 <alltraps>

80107a2d <vector145>:
.globl vector145
vector145:
  pushl $0
80107a2d:	6a 00                	push   $0x0
  pushl $145
80107a2f:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107a34:	e9 8b f4 ff ff       	jmp    80106ec4 <alltraps>

80107a39 <vector146>:
.globl vector146
vector146:
  pushl $0
80107a39:	6a 00                	push   $0x0
  pushl $146
80107a3b:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107a40:	e9 7f f4 ff ff       	jmp    80106ec4 <alltraps>

80107a45 <vector147>:
.globl vector147
vector147:
  pushl $0
80107a45:	6a 00                	push   $0x0
  pushl $147
80107a47:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107a4c:	e9 73 f4 ff ff       	jmp    80106ec4 <alltraps>

80107a51 <vector148>:
.globl vector148
vector148:
  pushl $0
80107a51:	6a 00                	push   $0x0
  pushl $148
80107a53:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107a58:	e9 67 f4 ff ff       	jmp    80106ec4 <alltraps>

80107a5d <vector149>:
.globl vector149
vector149:
  pushl $0
80107a5d:	6a 00                	push   $0x0
  pushl $149
80107a5f:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107a64:	e9 5b f4 ff ff       	jmp    80106ec4 <alltraps>

80107a69 <vector150>:
.globl vector150
vector150:
  pushl $0
80107a69:	6a 00                	push   $0x0
  pushl $150
80107a6b:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107a70:	e9 4f f4 ff ff       	jmp    80106ec4 <alltraps>

80107a75 <vector151>:
.globl vector151
vector151:
  pushl $0
80107a75:	6a 00                	push   $0x0
  pushl $151
80107a77:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107a7c:	e9 43 f4 ff ff       	jmp    80106ec4 <alltraps>

80107a81 <vector152>:
.globl vector152
vector152:
  pushl $0
80107a81:	6a 00                	push   $0x0
  pushl $152
80107a83:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107a88:	e9 37 f4 ff ff       	jmp    80106ec4 <alltraps>

80107a8d <vector153>:
.globl vector153
vector153:
  pushl $0
80107a8d:	6a 00                	push   $0x0
  pushl $153
80107a8f:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107a94:	e9 2b f4 ff ff       	jmp    80106ec4 <alltraps>

80107a99 <vector154>:
.globl vector154
vector154:
  pushl $0
80107a99:	6a 00                	push   $0x0
  pushl $154
80107a9b:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107aa0:	e9 1f f4 ff ff       	jmp    80106ec4 <alltraps>

80107aa5 <vector155>:
.globl vector155
vector155:
  pushl $0
80107aa5:	6a 00                	push   $0x0
  pushl $155
80107aa7:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107aac:	e9 13 f4 ff ff       	jmp    80106ec4 <alltraps>

80107ab1 <vector156>:
.globl vector156
vector156:
  pushl $0
80107ab1:	6a 00                	push   $0x0
  pushl $156
80107ab3:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107ab8:	e9 07 f4 ff ff       	jmp    80106ec4 <alltraps>

80107abd <vector157>:
.globl vector157
vector157:
  pushl $0
80107abd:	6a 00                	push   $0x0
  pushl $157
80107abf:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107ac4:	e9 fb f3 ff ff       	jmp    80106ec4 <alltraps>

80107ac9 <vector158>:
.globl vector158
vector158:
  pushl $0
80107ac9:	6a 00                	push   $0x0
  pushl $158
80107acb:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107ad0:	e9 ef f3 ff ff       	jmp    80106ec4 <alltraps>

80107ad5 <vector159>:
.globl vector159
vector159:
  pushl $0
80107ad5:	6a 00                	push   $0x0
  pushl $159
80107ad7:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107adc:	e9 e3 f3 ff ff       	jmp    80106ec4 <alltraps>

80107ae1 <vector160>:
.globl vector160
vector160:
  pushl $0
80107ae1:	6a 00                	push   $0x0
  pushl $160
80107ae3:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107ae8:	e9 d7 f3 ff ff       	jmp    80106ec4 <alltraps>

80107aed <vector161>:
.globl vector161
vector161:
  pushl $0
80107aed:	6a 00                	push   $0x0
  pushl $161
80107aef:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107af4:	e9 cb f3 ff ff       	jmp    80106ec4 <alltraps>

80107af9 <vector162>:
.globl vector162
vector162:
  pushl $0
80107af9:	6a 00                	push   $0x0
  pushl $162
80107afb:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107b00:	e9 bf f3 ff ff       	jmp    80106ec4 <alltraps>

80107b05 <vector163>:
.globl vector163
vector163:
  pushl $0
80107b05:	6a 00                	push   $0x0
  pushl $163
80107b07:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107b0c:	e9 b3 f3 ff ff       	jmp    80106ec4 <alltraps>

80107b11 <vector164>:
.globl vector164
vector164:
  pushl $0
80107b11:	6a 00                	push   $0x0
  pushl $164
80107b13:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107b18:	e9 a7 f3 ff ff       	jmp    80106ec4 <alltraps>

80107b1d <vector165>:
.globl vector165
vector165:
  pushl $0
80107b1d:	6a 00                	push   $0x0
  pushl $165
80107b1f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107b24:	e9 9b f3 ff ff       	jmp    80106ec4 <alltraps>

80107b29 <vector166>:
.globl vector166
vector166:
  pushl $0
80107b29:	6a 00                	push   $0x0
  pushl $166
80107b2b:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107b30:	e9 8f f3 ff ff       	jmp    80106ec4 <alltraps>

80107b35 <vector167>:
.globl vector167
vector167:
  pushl $0
80107b35:	6a 00                	push   $0x0
  pushl $167
80107b37:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107b3c:	e9 83 f3 ff ff       	jmp    80106ec4 <alltraps>

80107b41 <vector168>:
.globl vector168
vector168:
  pushl $0
80107b41:	6a 00                	push   $0x0
  pushl $168
80107b43:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107b48:	e9 77 f3 ff ff       	jmp    80106ec4 <alltraps>

80107b4d <vector169>:
.globl vector169
vector169:
  pushl $0
80107b4d:	6a 00                	push   $0x0
  pushl $169
80107b4f:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107b54:	e9 6b f3 ff ff       	jmp    80106ec4 <alltraps>

80107b59 <vector170>:
.globl vector170
vector170:
  pushl $0
80107b59:	6a 00                	push   $0x0
  pushl $170
80107b5b:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107b60:	e9 5f f3 ff ff       	jmp    80106ec4 <alltraps>

80107b65 <vector171>:
.globl vector171
vector171:
  pushl $0
80107b65:	6a 00                	push   $0x0
  pushl $171
80107b67:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107b6c:	e9 53 f3 ff ff       	jmp    80106ec4 <alltraps>

80107b71 <vector172>:
.globl vector172
vector172:
  pushl $0
80107b71:	6a 00                	push   $0x0
  pushl $172
80107b73:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107b78:	e9 47 f3 ff ff       	jmp    80106ec4 <alltraps>

80107b7d <vector173>:
.globl vector173
vector173:
  pushl $0
80107b7d:	6a 00                	push   $0x0
  pushl $173
80107b7f:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107b84:	e9 3b f3 ff ff       	jmp    80106ec4 <alltraps>

80107b89 <vector174>:
.globl vector174
vector174:
  pushl $0
80107b89:	6a 00                	push   $0x0
  pushl $174
80107b8b:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107b90:	e9 2f f3 ff ff       	jmp    80106ec4 <alltraps>

80107b95 <vector175>:
.globl vector175
vector175:
  pushl $0
80107b95:	6a 00                	push   $0x0
  pushl $175
80107b97:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107b9c:	e9 23 f3 ff ff       	jmp    80106ec4 <alltraps>

80107ba1 <vector176>:
.globl vector176
vector176:
  pushl $0
80107ba1:	6a 00                	push   $0x0
  pushl $176
80107ba3:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107ba8:	e9 17 f3 ff ff       	jmp    80106ec4 <alltraps>

80107bad <vector177>:
.globl vector177
vector177:
  pushl $0
80107bad:	6a 00                	push   $0x0
  pushl $177
80107baf:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107bb4:	e9 0b f3 ff ff       	jmp    80106ec4 <alltraps>

80107bb9 <vector178>:
.globl vector178
vector178:
  pushl $0
80107bb9:	6a 00                	push   $0x0
  pushl $178
80107bbb:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107bc0:	e9 ff f2 ff ff       	jmp    80106ec4 <alltraps>

80107bc5 <vector179>:
.globl vector179
vector179:
  pushl $0
80107bc5:	6a 00                	push   $0x0
  pushl $179
80107bc7:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107bcc:	e9 f3 f2 ff ff       	jmp    80106ec4 <alltraps>

80107bd1 <vector180>:
.globl vector180
vector180:
  pushl $0
80107bd1:	6a 00                	push   $0x0
  pushl $180
80107bd3:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107bd8:	e9 e7 f2 ff ff       	jmp    80106ec4 <alltraps>

80107bdd <vector181>:
.globl vector181
vector181:
  pushl $0
80107bdd:	6a 00                	push   $0x0
  pushl $181
80107bdf:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107be4:	e9 db f2 ff ff       	jmp    80106ec4 <alltraps>

80107be9 <vector182>:
.globl vector182
vector182:
  pushl $0
80107be9:	6a 00                	push   $0x0
  pushl $182
80107beb:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107bf0:	e9 cf f2 ff ff       	jmp    80106ec4 <alltraps>

80107bf5 <vector183>:
.globl vector183
vector183:
  pushl $0
80107bf5:	6a 00                	push   $0x0
  pushl $183
80107bf7:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107bfc:	e9 c3 f2 ff ff       	jmp    80106ec4 <alltraps>

80107c01 <vector184>:
.globl vector184
vector184:
  pushl $0
80107c01:	6a 00                	push   $0x0
  pushl $184
80107c03:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107c08:	e9 b7 f2 ff ff       	jmp    80106ec4 <alltraps>

80107c0d <vector185>:
.globl vector185
vector185:
  pushl $0
80107c0d:	6a 00                	push   $0x0
  pushl $185
80107c0f:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107c14:	e9 ab f2 ff ff       	jmp    80106ec4 <alltraps>

80107c19 <vector186>:
.globl vector186
vector186:
  pushl $0
80107c19:	6a 00                	push   $0x0
  pushl $186
80107c1b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107c20:	e9 9f f2 ff ff       	jmp    80106ec4 <alltraps>

80107c25 <vector187>:
.globl vector187
vector187:
  pushl $0
80107c25:	6a 00                	push   $0x0
  pushl $187
80107c27:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107c2c:	e9 93 f2 ff ff       	jmp    80106ec4 <alltraps>

80107c31 <vector188>:
.globl vector188
vector188:
  pushl $0
80107c31:	6a 00                	push   $0x0
  pushl $188
80107c33:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107c38:	e9 87 f2 ff ff       	jmp    80106ec4 <alltraps>

80107c3d <vector189>:
.globl vector189
vector189:
  pushl $0
80107c3d:	6a 00                	push   $0x0
  pushl $189
80107c3f:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107c44:	e9 7b f2 ff ff       	jmp    80106ec4 <alltraps>

80107c49 <vector190>:
.globl vector190
vector190:
  pushl $0
80107c49:	6a 00                	push   $0x0
  pushl $190
80107c4b:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107c50:	e9 6f f2 ff ff       	jmp    80106ec4 <alltraps>

80107c55 <vector191>:
.globl vector191
vector191:
  pushl $0
80107c55:	6a 00                	push   $0x0
  pushl $191
80107c57:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107c5c:	e9 63 f2 ff ff       	jmp    80106ec4 <alltraps>

80107c61 <vector192>:
.globl vector192
vector192:
  pushl $0
80107c61:	6a 00                	push   $0x0
  pushl $192
80107c63:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107c68:	e9 57 f2 ff ff       	jmp    80106ec4 <alltraps>

80107c6d <vector193>:
.globl vector193
vector193:
  pushl $0
80107c6d:	6a 00                	push   $0x0
  pushl $193
80107c6f:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107c74:	e9 4b f2 ff ff       	jmp    80106ec4 <alltraps>

80107c79 <vector194>:
.globl vector194
vector194:
  pushl $0
80107c79:	6a 00                	push   $0x0
  pushl $194
80107c7b:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107c80:	e9 3f f2 ff ff       	jmp    80106ec4 <alltraps>

80107c85 <vector195>:
.globl vector195
vector195:
  pushl $0
80107c85:	6a 00                	push   $0x0
  pushl $195
80107c87:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107c8c:	e9 33 f2 ff ff       	jmp    80106ec4 <alltraps>

80107c91 <vector196>:
.globl vector196
vector196:
  pushl $0
80107c91:	6a 00                	push   $0x0
  pushl $196
80107c93:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107c98:	e9 27 f2 ff ff       	jmp    80106ec4 <alltraps>

80107c9d <vector197>:
.globl vector197
vector197:
  pushl $0
80107c9d:	6a 00                	push   $0x0
  pushl $197
80107c9f:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107ca4:	e9 1b f2 ff ff       	jmp    80106ec4 <alltraps>

80107ca9 <vector198>:
.globl vector198
vector198:
  pushl $0
80107ca9:	6a 00                	push   $0x0
  pushl $198
80107cab:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107cb0:	e9 0f f2 ff ff       	jmp    80106ec4 <alltraps>

80107cb5 <vector199>:
.globl vector199
vector199:
  pushl $0
80107cb5:	6a 00                	push   $0x0
  pushl $199
80107cb7:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107cbc:	e9 03 f2 ff ff       	jmp    80106ec4 <alltraps>

80107cc1 <vector200>:
.globl vector200
vector200:
  pushl $0
80107cc1:	6a 00                	push   $0x0
  pushl $200
80107cc3:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107cc8:	e9 f7 f1 ff ff       	jmp    80106ec4 <alltraps>

80107ccd <vector201>:
.globl vector201
vector201:
  pushl $0
80107ccd:	6a 00                	push   $0x0
  pushl $201
80107ccf:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107cd4:	e9 eb f1 ff ff       	jmp    80106ec4 <alltraps>

80107cd9 <vector202>:
.globl vector202
vector202:
  pushl $0
80107cd9:	6a 00                	push   $0x0
  pushl $202
80107cdb:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107ce0:	e9 df f1 ff ff       	jmp    80106ec4 <alltraps>

80107ce5 <vector203>:
.globl vector203
vector203:
  pushl $0
80107ce5:	6a 00                	push   $0x0
  pushl $203
80107ce7:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107cec:	e9 d3 f1 ff ff       	jmp    80106ec4 <alltraps>

80107cf1 <vector204>:
.globl vector204
vector204:
  pushl $0
80107cf1:	6a 00                	push   $0x0
  pushl $204
80107cf3:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107cf8:	e9 c7 f1 ff ff       	jmp    80106ec4 <alltraps>

80107cfd <vector205>:
.globl vector205
vector205:
  pushl $0
80107cfd:	6a 00                	push   $0x0
  pushl $205
80107cff:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107d04:	e9 bb f1 ff ff       	jmp    80106ec4 <alltraps>

80107d09 <vector206>:
.globl vector206
vector206:
  pushl $0
80107d09:	6a 00                	push   $0x0
  pushl $206
80107d0b:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107d10:	e9 af f1 ff ff       	jmp    80106ec4 <alltraps>

80107d15 <vector207>:
.globl vector207
vector207:
  pushl $0
80107d15:	6a 00                	push   $0x0
  pushl $207
80107d17:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107d1c:	e9 a3 f1 ff ff       	jmp    80106ec4 <alltraps>

80107d21 <vector208>:
.globl vector208
vector208:
  pushl $0
80107d21:	6a 00                	push   $0x0
  pushl $208
80107d23:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107d28:	e9 97 f1 ff ff       	jmp    80106ec4 <alltraps>

80107d2d <vector209>:
.globl vector209
vector209:
  pushl $0
80107d2d:	6a 00                	push   $0x0
  pushl $209
80107d2f:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107d34:	e9 8b f1 ff ff       	jmp    80106ec4 <alltraps>

80107d39 <vector210>:
.globl vector210
vector210:
  pushl $0
80107d39:	6a 00                	push   $0x0
  pushl $210
80107d3b:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107d40:	e9 7f f1 ff ff       	jmp    80106ec4 <alltraps>

80107d45 <vector211>:
.globl vector211
vector211:
  pushl $0
80107d45:	6a 00                	push   $0x0
  pushl $211
80107d47:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107d4c:	e9 73 f1 ff ff       	jmp    80106ec4 <alltraps>

80107d51 <vector212>:
.globl vector212
vector212:
  pushl $0
80107d51:	6a 00                	push   $0x0
  pushl $212
80107d53:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107d58:	e9 67 f1 ff ff       	jmp    80106ec4 <alltraps>

80107d5d <vector213>:
.globl vector213
vector213:
  pushl $0
80107d5d:	6a 00                	push   $0x0
  pushl $213
80107d5f:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107d64:	e9 5b f1 ff ff       	jmp    80106ec4 <alltraps>

80107d69 <vector214>:
.globl vector214
vector214:
  pushl $0
80107d69:	6a 00                	push   $0x0
  pushl $214
80107d6b:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107d70:	e9 4f f1 ff ff       	jmp    80106ec4 <alltraps>

80107d75 <vector215>:
.globl vector215
vector215:
  pushl $0
80107d75:	6a 00                	push   $0x0
  pushl $215
80107d77:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107d7c:	e9 43 f1 ff ff       	jmp    80106ec4 <alltraps>

80107d81 <vector216>:
.globl vector216
vector216:
  pushl $0
80107d81:	6a 00                	push   $0x0
  pushl $216
80107d83:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107d88:	e9 37 f1 ff ff       	jmp    80106ec4 <alltraps>

80107d8d <vector217>:
.globl vector217
vector217:
  pushl $0
80107d8d:	6a 00                	push   $0x0
  pushl $217
80107d8f:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107d94:	e9 2b f1 ff ff       	jmp    80106ec4 <alltraps>

80107d99 <vector218>:
.globl vector218
vector218:
  pushl $0
80107d99:	6a 00                	push   $0x0
  pushl $218
80107d9b:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107da0:	e9 1f f1 ff ff       	jmp    80106ec4 <alltraps>

80107da5 <vector219>:
.globl vector219
vector219:
  pushl $0
80107da5:	6a 00                	push   $0x0
  pushl $219
80107da7:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107dac:	e9 13 f1 ff ff       	jmp    80106ec4 <alltraps>

80107db1 <vector220>:
.globl vector220
vector220:
  pushl $0
80107db1:	6a 00                	push   $0x0
  pushl $220
80107db3:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107db8:	e9 07 f1 ff ff       	jmp    80106ec4 <alltraps>

80107dbd <vector221>:
.globl vector221
vector221:
  pushl $0
80107dbd:	6a 00                	push   $0x0
  pushl $221
80107dbf:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107dc4:	e9 fb f0 ff ff       	jmp    80106ec4 <alltraps>

80107dc9 <vector222>:
.globl vector222
vector222:
  pushl $0
80107dc9:	6a 00                	push   $0x0
  pushl $222
80107dcb:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107dd0:	e9 ef f0 ff ff       	jmp    80106ec4 <alltraps>

80107dd5 <vector223>:
.globl vector223
vector223:
  pushl $0
80107dd5:	6a 00                	push   $0x0
  pushl $223
80107dd7:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107ddc:	e9 e3 f0 ff ff       	jmp    80106ec4 <alltraps>

80107de1 <vector224>:
.globl vector224
vector224:
  pushl $0
80107de1:	6a 00                	push   $0x0
  pushl $224
80107de3:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107de8:	e9 d7 f0 ff ff       	jmp    80106ec4 <alltraps>

80107ded <vector225>:
.globl vector225
vector225:
  pushl $0
80107ded:	6a 00                	push   $0x0
  pushl $225
80107def:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107df4:	e9 cb f0 ff ff       	jmp    80106ec4 <alltraps>

80107df9 <vector226>:
.globl vector226
vector226:
  pushl $0
80107df9:	6a 00                	push   $0x0
  pushl $226
80107dfb:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107e00:	e9 bf f0 ff ff       	jmp    80106ec4 <alltraps>

80107e05 <vector227>:
.globl vector227
vector227:
  pushl $0
80107e05:	6a 00                	push   $0x0
  pushl $227
80107e07:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107e0c:	e9 b3 f0 ff ff       	jmp    80106ec4 <alltraps>

80107e11 <vector228>:
.globl vector228
vector228:
  pushl $0
80107e11:	6a 00                	push   $0x0
  pushl $228
80107e13:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107e18:	e9 a7 f0 ff ff       	jmp    80106ec4 <alltraps>

80107e1d <vector229>:
.globl vector229
vector229:
  pushl $0
80107e1d:	6a 00                	push   $0x0
  pushl $229
80107e1f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107e24:	e9 9b f0 ff ff       	jmp    80106ec4 <alltraps>

80107e29 <vector230>:
.globl vector230
vector230:
  pushl $0
80107e29:	6a 00                	push   $0x0
  pushl $230
80107e2b:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107e30:	e9 8f f0 ff ff       	jmp    80106ec4 <alltraps>

80107e35 <vector231>:
.globl vector231
vector231:
  pushl $0
80107e35:	6a 00                	push   $0x0
  pushl $231
80107e37:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107e3c:	e9 83 f0 ff ff       	jmp    80106ec4 <alltraps>

80107e41 <vector232>:
.globl vector232
vector232:
  pushl $0
80107e41:	6a 00                	push   $0x0
  pushl $232
80107e43:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107e48:	e9 77 f0 ff ff       	jmp    80106ec4 <alltraps>

80107e4d <vector233>:
.globl vector233
vector233:
  pushl $0
80107e4d:	6a 00                	push   $0x0
  pushl $233
80107e4f:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107e54:	e9 6b f0 ff ff       	jmp    80106ec4 <alltraps>

80107e59 <vector234>:
.globl vector234
vector234:
  pushl $0
80107e59:	6a 00                	push   $0x0
  pushl $234
80107e5b:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107e60:	e9 5f f0 ff ff       	jmp    80106ec4 <alltraps>

80107e65 <vector235>:
.globl vector235
vector235:
  pushl $0
80107e65:	6a 00                	push   $0x0
  pushl $235
80107e67:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107e6c:	e9 53 f0 ff ff       	jmp    80106ec4 <alltraps>

80107e71 <vector236>:
.globl vector236
vector236:
  pushl $0
80107e71:	6a 00                	push   $0x0
  pushl $236
80107e73:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107e78:	e9 47 f0 ff ff       	jmp    80106ec4 <alltraps>

80107e7d <vector237>:
.globl vector237
vector237:
  pushl $0
80107e7d:	6a 00                	push   $0x0
  pushl $237
80107e7f:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107e84:	e9 3b f0 ff ff       	jmp    80106ec4 <alltraps>

80107e89 <vector238>:
.globl vector238
vector238:
  pushl $0
80107e89:	6a 00                	push   $0x0
  pushl $238
80107e8b:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107e90:	e9 2f f0 ff ff       	jmp    80106ec4 <alltraps>

80107e95 <vector239>:
.globl vector239
vector239:
  pushl $0
80107e95:	6a 00                	push   $0x0
  pushl $239
80107e97:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107e9c:	e9 23 f0 ff ff       	jmp    80106ec4 <alltraps>

80107ea1 <vector240>:
.globl vector240
vector240:
  pushl $0
80107ea1:	6a 00                	push   $0x0
  pushl $240
80107ea3:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107ea8:	e9 17 f0 ff ff       	jmp    80106ec4 <alltraps>

80107ead <vector241>:
.globl vector241
vector241:
  pushl $0
80107ead:	6a 00                	push   $0x0
  pushl $241
80107eaf:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107eb4:	e9 0b f0 ff ff       	jmp    80106ec4 <alltraps>

80107eb9 <vector242>:
.globl vector242
vector242:
  pushl $0
80107eb9:	6a 00                	push   $0x0
  pushl $242
80107ebb:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107ec0:	e9 ff ef ff ff       	jmp    80106ec4 <alltraps>

80107ec5 <vector243>:
.globl vector243
vector243:
  pushl $0
80107ec5:	6a 00                	push   $0x0
  pushl $243
80107ec7:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107ecc:	e9 f3 ef ff ff       	jmp    80106ec4 <alltraps>

80107ed1 <vector244>:
.globl vector244
vector244:
  pushl $0
80107ed1:	6a 00                	push   $0x0
  pushl $244
80107ed3:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107ed8:	e9 e7 ef ff ff       	jmp    80106ec4 <alltraps>

80107edd <vector245>:
.globl vector245
vector245:
  pushl $0
80107edd:	6a 00                	push   $0x0
  pushl $245
80107edf:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107ee4:	e9 db ef ff ff       	jmp    80106ec4 <alltraps>

80107ee9 <vector246>:
.globl vector246
vector246:
  pushl $0
80107ee9:	6a 00                	push   $0x0
  pushl $246
80107eeb:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107ef0:	e9 cf ef ff ff       	jmp    80106ec4 <alltraps>

80107ef5 <vector247>:
.globl vector247
vector247:
  pushl $0
80107ef5:	6a 00                	push   $0x0
  pushl $247
80107ef7:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107efc:	e9 c3 ef ff ff       	jmp    80106ec4 <alltraps>

80107f01 <vector248>:
.globl vector248
vector248:
  pushl $0
80107f01:	6a 00                	push   $0x0
  pushl $248
80107f03:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107f08:	e9 b7 ef ff ff       	jmp    80106ec4 <alltraps>

80107f0d <vector249>:
.globl vector249
vector249:
  pushl $0
80107f0d:	6a 00                	push   $0x0
  pushl $249
80107f0f:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107f14:	e9 ab ef ff ff       	jmp    80106ec4 <alltraps>

80107f19 <vector250>:
.globl vector250
vector250:
  pushl $0
80107f19:	6a 00                	push   $0x0
  pushl $250
80107f1b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107f20:	e9 9f ef ff ff       	jmp    80106ec4 <alltraps>

80107f25 <vector251>:
.globl vector251
vector251:
  pushl $0
80107f25:	6a 00                	push   $0x0
  pushl $251
80107f27:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107f2c:	e9 93 ef ff ff       	jmp    80106ec4 <alltraps>

80107f31 <vector252>:
.globl vector252
vector252:
  pushl $0
80107f31:	6a 00                	push   $0x0
  pushl $252
80107f33:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107f38:	e9 87 ef ff ff       	jmp    80106ec4 <alltraps>

80107f3d <vector253>:
.globl vector253
vector253:
  pushl $0
80107f3d:	6a 00                	push   $0x0
  pushl $253
80107f3f:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107f44:	e9 7b ef ff ff       	jmp    80106ec4 <alltraps>

80107f49 <vector254>:
.globl vector254
vector254:
  pushl $0
80107f49:	6a 00                	push   $0x0
  pushl $254
80107f4b:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107f50:	e9 6f ef ff ff       	jmp    80106ec4 <alltraps>

80107f55 <vector255>:
.globl vector255
vector255:
  pushl $0
80107f55:	6a 00                	push   $0x0
  pushl $255
80107f57:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107f5c:	e9 63 ef ff ff       	jmp    80106ec4 <alltraps>

80107f61 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107f61:	55                   	push   %ebp
80107f62:	89 e5                	mov    %esp,%ebp
80107f64:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107f67:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f6a:	83 e8 01             	sub    $0x1,%eax
80107f6d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107f71:	8b 45 08             	mov    0x8(%ebp),%eax
80107f74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107f78:	8b 45 08             	mov    0x8(%ebp),%eax
80107f7b:	c1 e8 10             	shr    $0x10,%eax
80107f7e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107f82:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107f85:	0f 01 10             	lgdtl  (%eax)
}
80107f88:	90                   	nop
80107f89:	c9                   	leave  
80107f8a:	c3                   	ret    

80107f8b <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107f8b:	55                   	push   %ebp
80107f8c:	89 e5                	mov    %esp,%ebp
80107f8e:	83 ec 04             	sub    $0x4,%esp
80107f91:	8b 45 08             	mov    0x8(%ebp),%eax
80107f94:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107f98:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107f9c:	0f 00 d8             	ltr    %ax
}
80107f9f:	90                   	nop
80107fa0:	c9                   	leave  
80107fa1:	c3                   	ret    

80107fa2 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107fa2:	55                   	push   %ebp
80107fa3:	89 e5                	mov    %esp,%ebp
80107fa5:	83 ec 04             	sub    $0x4,%esp
80107fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80107fab:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107faf:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107fb3:	8e e8                	mov    %eax,%gs
}
80107fb5:	90                   	nop
80107fb6:	c9                   	leave  
80107fb7:	c3                   	ret    

80107fb8 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107fb8:	55                   	push   %ebp
80107fb9:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80107fbe:	0f 22 d8             	mov    %eax,%cr3
}
80107fc1:	90                   	nop
80107fc2:	5d                   	pop    %ebp
80107fc3:	c3                   	ret    

80107fc4 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107fc4:	55                   	push   %ebp
80107fc5:	89 e5                	mov    %esp,%ebp
80107fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80107fca:	05 00 00 00 80       	add    $0x80000000,%eax
80107fcf:	5d                   	pop    %ebp
80107fd0:	c3                   	ret    

80107fd1 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107fd1:	55                   	push   %ebp
80107fd2:	89 e5                	mov    %esp,%ebp
80107fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80107fd7:	05 00 00 00 80       	add    $0x80000000,%eax
80107fdc:	5d                   	pop    %ebp
80107fdd:	c3                   	ret    

80107fde <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107fde:	55                   	push   %ebp
80107fdf:	89 e5                	mov    %esp,%ebp
80107fe1:	53                   	push   %ebx
80107fe2:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107fe5:	e8 09 b0 ff ff       	call   80102ff3 <cpunum>
80107fea:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107ff0:	05 80 33 11 80       	add    $0x80113380,%eax
80107ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffb:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108004:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010800a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800d:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108014:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108018:	83 e2 f0             	and    $0xfffffff0,%edx
8010801b:	83 ca 0a             	or     $0xa,%edx
8010801e:	88 50 7d             	mov    %dl,0x7d(%eax)
80108021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108024:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108028:	83 ca 10             	or     $0x10,%edx
8010802b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010802e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108031:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108035:	83 e2 9f             	and    $0xffffff9f,%edx
80108038:	88 50 7d             	mov    %dl,0x7d(%eax)
8010803b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108042:	83 ca 80             	or     $0xffffff80,%edx
80108045:	88 50 7d             	mov    %dl,0x7d(%eax)
80108048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010804f:	83 ca 0f             	or     $0xf,%edx
80108052:	88 50 7e             	mov    %dl,0x7e(%eax)
80108055:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108058:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010805c:	83 e2 ef             	and    $0xffffffef,%edx
8010805f:	88 50 7e             	mov    %dl,0x7e(%eax)
80108062:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108065:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108069:	83 e2 df             	and    $0xffffffdf,%edx
8010806c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010806f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108072:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108076:	83 ca 40             	or     $0x40,%edx
80108079:	88 50 7e             	mov    %dl,0x7e(%eax)
8010807c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108083:	83 ca 80             	or     $0xffffff80,%edx
80108086:	88 50 7e             	mov    %dl,0x7e(%eax)
80108089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108090:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108093:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010809a:	ff ff 
8010809c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809f:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801080a6:	00 00 
801080a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ab:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801080b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080bc:	83 e2 f0             	and    $0xfffffff0,%edx
801080bf:	83 ca 02             	or     $0x2,%edx
801080c2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cb:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080d2:	83 ca 10             	or     $0x10,%edx
801080d5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080de:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080e5:	83 e2 9f             	and    $0xffffff9f,%edx
801080e8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080f8:	83 ca 80             	or     $0xffffff80,%edx
801080fb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108104:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010810b:	83 ca 0f             	or     $0xf,%edx
8010810e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108117:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010811e:	83 e2 ef             	and    $0xffffffef,%edx
80108121:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108131:	83 e2 df             	and    $0xffffffdf,%edx
80108134:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010813a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108144:	83 ca 40             	or     $0x40,%edx
80108147:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010814d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108150:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108157:	83 ca 80             	or     $0xffffff80,%edx
8010815a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108160:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108163:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010816a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816d:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108174:	ff ff 
80108176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108179:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108180:	00 00 
80108182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108185:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010818c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108196:	83 e2 f0             	and    $0xfffffff0,%edx
80108199:	83 ca 0a             	or     $0xa,%edx
8010819c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081ac:	83 ca 10             	or     $0x10,%edx
801081af:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081bf:	83 ca 60             	or     $0x60,%edx
801081c2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cb:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081d2:	83 ca 80             	or     $0xffffff80,%edx
801081d5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081de:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081e5:	83 ca 0f             	or     $0xf,%edx
801081e8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081f8:	83 e2 ef             	and    $0xffffffef,%edx
801081fb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108201:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108204:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010820b:	83 e2 df             	and    $0xffffffdf,%edx
8010820e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108217:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010821e:	83 ca 40             	or     $0x40,%edx
80108221:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108231:	83 ca 80             	or     $0xffffff80,%edx
80108234:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010823a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823d:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108247:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010824e:	ff ff 
80108250:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108253:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010825a:	00 00 
8010825c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825f:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108266:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108269:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108270:	83 e2 f0             	and    $0xfffffff0,%edx
80108273:	83 ca 02             	or     $0x2,%edx
80108276:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010827c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108286:	83 ca 10             	or     $0x10,%edx
80108289:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010828f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108292:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108299:	83 ca 60             	or     $0x60,%edx
8010829c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801082ac:	83 ca 80             	or     $0xffffff80,%edx
801082af:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082bf:	83 ca 0f             	or     $0xf,%edx
801082c2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082cb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082d2:	83 e2 ef             	and    $0xffffffef,%edx
801082d5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082de:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082e5:	83 e2 df             	and    $0xffffffdf,%edx
801082e8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082f8:	83 ca 40             	or     $0x40,%edx
801082fb:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108304:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010830b:	83 ca 80             	or     $0xffffff80,%edx
8010830e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108317:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010831e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108321:	05 b4 00 00 00       	add    $0xb4,%eax
80108326:	89 c3                	mov    %eax,%ebx
80108328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832b:	05 b4 00 00 00       	add    $0xb4,%eax
80108330:	c1 e8 10             	shr    $0x10,%eax
80108333:	89 c2                	mov    %eax,%edx
80108335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108338:	05 b4 00 00 00       	add    $0xb4,%eax
8010833d:	c1 e8 18             	shr    $0x18,%eax
80108340:	89 c1                	mov    %eax,%ecx
80108342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108345:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010834c:	00 00 
8010834e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108351:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835b:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108364:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010836b:	83 e2 f0             	and    $0xfffffff0,%edx
8010836e:	83 ca 02             	or     $0x2,%edx
80108371:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108381:	83 ca 10             	or     $0x10,%edx
80108384:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010838a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010838d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108394:	83 e2 9f             	and    $0xffffff9f,%edx
80108397:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010839d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a0:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801083a7:	83 ca 80             	or     $0xffffff80,%edx
801083aa:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801083b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083ba:	83 e2 f0             	and    $0xfffffff0,%edx
801083bd:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083cd:	83 e2 ef             	and    $0xffffffef,%edx
801083d0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083e0:	83 e2 df             	and    $0xffffffdf,%edx
801083e3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ec:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083f3:	83 ca 40             	or     $0x40,%edx
801083f6:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ff:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108406:	83 ca 80             	or     $0xffffff80,%edx
80108409:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010840f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108412:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108418:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010841b:	83 c0 70             	add    $0x70,%eax
8010841e:	83 ec 08             	sub    $0x8,%esp
80108421:	6a 38                	push   $0x38
80108423:	50                   	push   %eax
80108424:	e8 38 fb ff ff       	call   80107f61 <lgdt>
80108429:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010842c:	83 ec 0c             	sub    $0xc,%esp
8010842f:	6a 18                	push   $0x18
80108431:	e8 6c fb ff ff       	call   80107fa2 <loadgs>
80108436:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843c:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108442:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108449:	00 00 00 00 
}
8010844d:	90                   	nop
8010844e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108451:	c9                   	leave  
80108452:	c3                   	ret    

80108453 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108453:	55                   	push   %ebp
80108454:	89 e5                	mov    %esp,%ebp
80108456:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108459:	8b 45 0c             	mov    0xc(%ebp),%eax
8010845c:	c1 e8 16             	shr    $0x16,%eax
8010845f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108466:	8b 45 08             	mov    0x8(%ebp),%eax
80108469:	01 d0                	add    %edx,%eax
8010846b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010846e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108471:	8b 00                	mov    (%eax),%eax
80108473:	83 e0 01             	and    $0x1,%eax
80108476:	85 c0                	test   %eax,%eax
80108478:	74 18                	je     80108492 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010847a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010847d:	8b 00                	mov    (%eax),%eax
8010847f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108484:	50                   	push   %eax
80108485:	e8 47 fb ff ff       	call   80107fd1 <p2v>
8010848a:	83 c4 04             	add    $0x4,%esp
8010848d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108490:	eb 48                	jmp    801084da <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108492:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108496:	74 0e                	je     801084a6 <walkpgdir+0x53>
80108498:	e8 f0 a7 ff ff       	call   80102c8d <kalloc>
8010849d:	89 45 f4             	mov    %eax,-0xc(%ebp)
801084a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801084a4:	75 07                	jne    801084ad <walkpgdir+0x5a>
      return 0;
801084a6:	b8 00 00 00 00       	mov    $0x0,%eax
801084ab:	eb 44                	jmp    801084f1 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801084ad:	83 ec 04             	sub    $0x4,%esp
801084b0:	68 00 10 00 00       	push   $0x1000
801084b5:	6a 00                	push   $0x0
801084b7:	ff 75 f4             	pushl  -0xc(%ebp)
801084ba:	e8 ed d4 ff ff       	call   801059ac <memset>
801084bf:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801084c2:	83 ec 0c             	sub    $0xc,%esp
801084c5:	ff 75 f4             	pushl  -0xc(%ebp)
801084c8:	e8 f7 fa ff ff       	call   80107fc4 <v2p>
801084cd:	83 c4 10             	add    $0x10,%esp
801084d0:	83 c8 07             	or     $0x7,%eax
801084d3:	89 c2                	mov    %eax,%edx
801084d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084d8:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801084da:	8b 45 0c             	mov    0xc(%ebp),%eax
801084dd:	c1 e8 0c             	shr    $0xc,%eax
801084e0:	25 ff 03 00 00       	and    $0x3ff,%eax
801084e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801084ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ef:	01 d0                	add    %edx,%eax
}
801084f1:	c9                   	leave  
801084f2:	c3                   	ret    

801084f3 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801084f3:	55                   	push   %ebp
801084f4:	89 e5                	mov    %esp,%ebp
801084f6:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801084f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801084fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108504:	8b 55 0c             	mov    0xc(%ebp),%edx
80108507:	8b 45 10             	mov    0x10(%ebp),%eax
8010850a:	01 d0                	add    %edx,%eax
8010850c:	83 e8 01             	sub    $0x1,%eax
8010850f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108514:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108517:	83 ec 04             	sub    $0x4,%esp
8010851a:	6a 01                	push   $0x1
8010851c:	ff 75 f4             	pushl  -0xc(%ebp)
8010851f:	ff 75 08             	pushl  0x8(%ebp)
80108522:	e8 2c ff ff ff       	call   80108453 <walkpgdir>
80108527:	83 c4 10             	add    $0x10,%esp
8010852a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010852d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108531:	75 07                	jne    8010853a <mappages+0x47>
      return -1;
80108533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108538:	eb 47                	jmp    80108581 <mappages+0x8e>
    if(*pte & PTE_P)
8010853a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010853d:	8b 00                	mov    (%eax),%eax
8010853f:	83 e0 01             	and    $0x1,%eax
80108542:	85 c0                	test   %eax,%eax
80108544:	74 0d                	je     80108553 <mappages+0x60>
      panic("remap");
80108546:	83 ec 0c             	sub    $0xc,%esp
80108549:	68 60 94 10 80       	push   $0x80109460
8010854e:	e8 13 80 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80108553:	8b 45 18             	mov    0x18(%ebp),%eax
80108556:	0b 45 14             	or     0x14(%ebp),%eax
80108559:	83 c8 01             	or     $0x1,%eax
8010855c:	89 c2                	mov    %eax,%edx
8010855e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108561:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108566:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108569:	74 10                	je     8010857b <mappages+0x88>
      break;
    a += PGSIZE;
8010856b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108572:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108579:	eb 9c                	jmp    80108517 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
8010857b:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010857c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108581:	c9                   	leave  
80108582:	c3                   	ret    

80108583 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108583:	55                   	push   %ebp
80108584:	89 e5                	mov    %esp,%ebp
80108586:	53                   	push   %ebx
80108587:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010858a:	e8 fe a6 ff ff       	call   80102c8d <kalloc>
8010858f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108592:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108596:	75 0a                	jne    801085a2 <setupkvm+0x1f>
    return 0;
80108598:	b8 00 00 00 00       	mov    $0x0,%eax
8010859d:	e9 8e 00 00 00       	jmp    80108630 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801085a2:	83 ec 04             	sub    $0x4,%esp
801085a5:	68 00 10 00 00       	push   $0x1000
801085aa:	6a 00                	push   $0x0
801085ac:	ff 75 f0             	pushl  -0x10(%ebp)
801085af:	e8 f8 d3 ff ff       	call   801059ac <memset>
801085b4:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801085b7:	83 ec 0c             	sub    $0xc,%esp
801085ba:	68 00 00 00 0e       	push   $0xe000000
801085bf:	e8 0d fa ff ff       	call   80107fd1 <p2v>
801085c4:	83 c4 10             	add    $0x10,%esp
801085c7:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801085cc:	76 0d                	jbe    801085db <setupkvm+0x58>
    panic("PHYSTOP too high");
801085ce:	83 ec 0c             	sub    $0xc,%esp
801085d1:	68 66 94 10 80       	push   $0x80109466
801085d6:	e8 8b 7f ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085db:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801085e2:	eb 40                	jmp    80108624 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801085e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e7:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801085ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ed:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801085f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f3:	8b 58 08             	mov    0x8(%eax),%ebx
801085f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f9:	8b 40 04             	mov    0x4(%eax),%eax
801085fc:	29 c3                	sub    %eax,%ebx
801085fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108601:	8b 00                	mov    (%eax),%eax
80108603:	83 ec 0c             	sub    $0xc,%esp
80108606:	51                   	push   %ecx
80108607:	52                   	push   %edx
80108608:	53                   	push   %ebx
80108609:	50                   	push   %eax
8010860a:	ff 75 f0             	pushl  -0x10(%ebp)
8010860d:	e8 e1 fe ff ff       	call   801084f3 <mappages>
80108612:	83 c4 20             	add    $0x20,%esp
80108615:	85 c0                	test   %eax,%eax
80108617:	79 07                	jns    80108620 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108619:	b8 00 00 00 00       	mov    $0x0,%eax
8010861e:	eb 10                	jmp    80108630 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108620:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108624:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
8010862b:	72 b7                	jb     801085e4 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010862d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108630:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108633:	c9                   	leave  
80108634:	c3                   	ret    

80108635 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108635:	55                   	push   %ebp
80108636:	89 e5                	mov    %esp,%ebp
80108638:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010863b:	e8 43 ff ff ff       	call   80108583 <setupkvm>
80108640:	a3 38 67 11 80       	mov    %eax,0x80116738
  switchkvm();
80108645:	e8 03 00 00 00       	call   8010864d <switchkvm>
}
8010864a:	90                   	nop
8010864b:	c9                   	leave  
8010864c:	c3                   	ret    

8010864d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010864d:	55                   	push   %ebp
8010864e:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108650:	a1 38 67 11 80       	mov    0x80116738,%eax
80108655:	50                   	push   %eax
80108656:	e8 69 f9 ff ff       	call   80107fc4 <v2p>
8010865b:	83 c4 04             	add    $0x4,%esp
8010865e:	50                   	push   %eax
8010865f:	e8 54 f9 ff ff       	call   80107fb8 <lcr3>
80108664:	83 c4 04             	add    $0x4,%esp
}
80108667:	90                   	nop
80108668:	c9                   	leave  
80108669:	c3                   	ret    

8010866a <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010866a:	55                   	push   %ebp
8010866b:	89 e5                	mov    %esp,%ebp
8010866d:	56                   	push   %esi
8010866e:	53                   	push   %ebx
  pushcli();
8010866f:	e8 32 d2 ff ff       	call   801058a6 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108674:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010867a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108681:	83 c2 08             	add    $0x8,%edx
80108684:	89 d6                	mov    %edx,%esi
80108686:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010868d:	83 c2 08             	add    $0x8,%edx
80108690:	c1 ea 10             	shr    $0x10,%edx
80108693:	89 d3                	mov    %edx,%ebx
80108695:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010869c:	83 c2 08             	add    $0x8,%edx
8010869f:	c1 ea 18             	shr    $0x18,%edx
801086a2:	89 d1                	mov    %edx,%ecx
801086a4:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801086ab:	67 00 
801086ad:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801086b4:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801086ba:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086c1:	83 e2 f0             	and    $0xfffffff0,%edx
801086c4:	83 ca 09             	or     $0x9,%edx
801086c7:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086cd:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086d4:	83 ca 10             	or     $0x10,%edx
801086d7:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086dd:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086e4:	83 e2 9f             	and    $0xffffff9f,%edx
801086e7:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086ed:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086f4:	83 ca 80             	or     $0xffffff80,%edx
801086f7:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086fd:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108704:	83 e2 f0             	and    $0xfffffff0,%edx
80108707:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010870d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108714:	83 e2 ef             	and    $0xffffffef,%edx
80108717:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010871d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108724:	83 e2 df             	and    $0xffffffdf,%edx
80108727:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010872d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108734:	83 ca 40             	or     $0x40,%edx
80108737:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010873d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108744:	83 e2 7f             	and    $0x7f,%edx
80108747:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010874d:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108753:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108759:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108760:	83 e2 ef             	and    $0xffffffef,%edx
80108763:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108769:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010876f:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108775:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010877b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108782:	8b 52 08             	mov    0x8(%edx),%edx
80108785:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010878b:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010878e:	83 ec 0c             	sub    $0xc,%esp
80108791:	6a 30                	push   $0x30
80108793:	e8 f3 f7 ff ff       	call   80107f8b <ltr>
80108798:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010879b:	8b 45 08             	mov    0x8(%ebp),%eax
8010879e:	8b 40 04             	mov    0x4(%eax),%eax
801087a1:	85 c0                	test   %eax,%eax
801087a3:	75 0d                	jne    801087b2 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801087a5:	83 ec 0c             	sub    $0xc,%esp
801087a8:	68 77 94 10 80       	push   $0x80109477
801087ad:	e8 b4 7d ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801087b2:	8b 45 08             	mov    0x8(%ebp),%eax
801087b5:	8b 40 04             	mov    0x4(%eax),%eax
801087b8:	83 ec 0c             	sub    $0xc,%esp
801087bb:	50                   	push   %eax
801087bc:	e8 03 f8 ff ff       	call   80107fc4 <v2p>
801087c1:	83 c4 10             	add    $0x10,%esp
801087c4:	83 ec 0c             	sub    $0xc,%esp
801087c7:	50                   	push   %eax
801087c8:	e8 eb f7 ff ff       	call   80107fb8 <lcr3>
801087cd:	83 c4 10             	add    $0x10,%esp
  popcli();
801087d0:	e8 16 d1 ff ff       	call   801058eb <popcli>
}
801087d5:	90                   	nop
801087d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801087d9:	5b                   	pop    %ebx
801087da:	5e                   	pop    %esi
801087db:	5d                   	pop    %ebp
801087dc:	c3                   	ret    

801087dd <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801087dd:	55                   	push   %ebp
801087de:	89 e5                	mov    %esp,%ebp
801087e0:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801087e3:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801087ea:	76 0d                	jbe    801087f9 <inituvm+0x1c>
    panic("inituvm: more than a page");
801087ec:	83 ec 0c             	sub    $0xc,%esp
801087ef:	68 8b 94 10 80       	push   $0x8010948b
801087f4:	e8 6d 7d ff ff       	call   80100566 <panic>
  mem = kalloc();
801087f9:	e8 8f a4 ff ff       	call   80102c8d <kalloc>
801087fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108801:	83 ec 04             	sub    $0x4,%esp
80108804:	68 00 10 00 00       	push   $0x1000
80108809:	6a 00                	push   $0x0
8010880b:	ff 75 f4             	pushl  -0xc(%ebp)
8010880e:	e8 99 d1 ff ff       	call   801059ac <memset>
80108813:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108816:	83 ec 0c             	sub    $0xc,%esp
80108819:	ff 75 f4             	pushl  -0xc(%ebp)
8010881c:	e8 a3 f7 ff ff       	call   80107fc4 <v2p>
80108821:	83 c4 10             	add    $0x10,%esp
80108824:	83 ec 0c             	sub    $0xc,%esp
80108827:	6a 06                	push   $0x6
80108829:	50                   	push   %eax
8010882a:	68 00 10 00 00       	push   $0x1000
8010882f:	6a 00                	push   $0x0
80108831:	ff 75 08             	pushl  0x8(%ebp)
80108834:	e8 ba fc ff ff       	call   801084f3 <mappages>
80108839:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010883c:	83 ec 04             	sub    $0x4,%esp
8010883f:	ff 75 10             	pushl  0x10(%ebp)
80108842:	ff 75 0c             	pushl  0xc(%ebp)
80108845:	ff 75 f4             	pushl  -0xc(%ebp)
80108848:	e8 1e d2 ff ff       	call   80105a6b <memmove>
8010884d:	83 c4 10             	add    $0x10,%esp
}
80108850:	90                   	nop
80108851:	c9                   	leave  
80108852:	c3                   	ret    

80108853 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108853:	55                   	push   %ebp
80108854:	89 e5                	mov    %esp,%ebp
80108856:	53                   	push   %ebx
80108857:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010885a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010885d:	25 ff 0f 00 00       	and    $0xfff,%eax
80108862:	85 c0                	test   %eax,%eax
80108864:	74 0d                	je     80108873 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108866:	83 ec 0c             	sub    $0xc,%esp
80108869:	68 a8 94 10 80       	push   $0x801094a8
8010886e:	e8 f3 7c ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108873:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010887a:	e9 95 00 00 00       	jmp    80108914 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010887f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108882:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108885:	01 d0                	add    %edx,%eax
80108887:	83 ec 04             	sub    $0x4,%esp
8010888a:	6a 00                	push   $0x0
8010888c:	50                   	push   %eax
8010888d:	ff 75 08             	pushl  0x8(%ebp)
80108890:	e8 be fb ff ff       	call   80108453 <walkpgdir>
80108895:	83 c4 10             	add    $0x10,%esp
80108898:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010889b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010889f:	75 0d                	jne    801088ae <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801088a1:	83 ec 0c             	sub    $0xc,%esp
801088a4:	68 cb 94 10 80       	push   $0x801094cb
801088a9:	e8 b8 7c ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801088ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088b1:	8b 00                	mov    (%eax),%eax
801088b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801088bb:	8b 45 18             	mov    0x18(%ebp),%eax
801088be:	2b 45 f4             	sub    -0xc(%ebp),%eax
801088c1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801088c6:	77 0b                	ja     801088d3 <loaduvm+0x80>
      n = sz - i;
801088c8:	8b 45 18             	mov    0x18(%ebp),%eax
801088cb:	2b 45 f4             	sub    -0xc(%ebp),%eax
801088ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
801088d1:	eb 07                	jmp    801088da <loaduvm+0x87>
    else
      n = PGSIZE;
801088d3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801088da:	8b 55 14             	mov    0x14(%ebp),%edx
801088dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801088e3:	83 ec 0c             	sub    $0xc,%esp
801088e6:	ff 75 e8             	pushl  -0x18(%ebp)
801088e9:	e8 e3 f6 ff ff       	call   80107fd1 <p2v>
801088ee:	83 c4 10             	add    $0x10,%esp
801088f1:	ff 75 f0             	pushl  -0x10(%ebp)
801088f4:	53                   	push   %ebx
801088f5:	50                   	push   %eax
801088f6:	ff 75 10             	pushl  0x10(%ebp)
801088f9:	e8 01 96 ff ff       	call   80101eff <readi>
801088fe:	83 c4 10             	add    $0x10,%esp
80108901:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108904:	74 07                	je     8010890d <loaduvm+0xba>
      return -1;
80108906:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010890b:	eb 18                	jmp    80108925 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010890d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108917:	3b 45 18             	cmp    0x18(%ebp),%eax
8010891a:	0f 82 5f ff ff ff    	jb     8010887f <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108920:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108928:	c9                   	leave  
80108929:	c3                   	ret    

8010892a <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010892a:	55                   	push   %ebp
8010892b:	89 e5                	mov    %esp,%ebp
8010892d:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108930:	8b 45 10             	mov    0x10(%ebp),%eax
80108933:	85 c0                	test   %eax,%eax
80108935:	79 0a                	jns    80108941 <allocuvm+0x17>
    return 0;
80108937:	b8 00 00 00 00       	mov    $0x0,%eax
8010893c:	e9 b0 00 00 00       	jmp    801089f1 <allocuvm+0xc7>
  if(newsz < oldsz)
80108941:	8b 45 10             	mov    0x10(%ebp),%eax
80108944:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108947:	73 08                	jae    80108951 <allocuvm+0x27>
    return oldsz;
80108949:	8b 45 0c             	mov    0xc(%ebp),%eax
8010894c:	e9 a0 00 00 00       	jmp    801089f1 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108951:	8b 45 0c             	mov    0xc(%ebp),%eax
80108954:	05 ff 0f 00 00       	add    $0xfff,%eax
80108959:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010895e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108961:	eb 7f                	jmp    801089e2 <allocuvm+0xb8>
    mem = kalloc();
80108963:	e8 25 a3 ff ff       	call   80102c8d <kalloc>
80108968:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010896b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010896f:	75 2b                	jne    8010899c <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108971:	83 ec 0c             	sub    $0xc,%esp
80108974:	68 e9 94 10 80       	push   $0x801094e9
80108979:	e8 48 7a ff ff       	call   801003c6 <cprintf>
8010897e:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108981:	83 ec 04             	sub    $0x4,%esp
80108984:	ff 75 0c             	pushl  0xc(%ebp)
80108987:	ff 75 10             	pushl  0x10(%ebp)
8010898a:	ff 75 08             	pushl  0x8(%ebp)
8010898d:	e8 61 00 00 00       	call   801089f3 <deallocuvm>
80108992:	83 c4 10             	add    $0x10,%esp
      return 0;
80108995:	b8 00 00 00 00       	mov    $0x0,%eax
8010899a:	eb 55                	jmp    801089f1 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
8010899c:	83 ec 04             	sub    $0x4,%esp
8010899f:	68 00 10 00 00       	push   $0x1000
801089a4:	6a 00                	push   $0x0
801089a6:	ff 75 f0             	pushl  -0x10(%ebp)
801089a9:	e8 fe cf ff ff       	call   801059ac <memset>
801089ae:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801089b1:	83 ec 0c             	sub    $0xc,%esp
801089b4:	ff 75 f0             	pushl  -0x10(%ebp)
801089b7:	e8 08 f6 ff ff       	call   80107fc4 <v2p>
801089bc:	83 c4 10             	add    $0x10,%esp
801089bf:	89 c2                	mov    %eax,%edx
801089c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089c4:	83 ec 0c             	sub    $0xc,%esp
801089c7:	6a 06                	push   $0x6
801089c9:	52                   	push   %edx
801089ca:	68 00 10 00 00       	push   $0x1000
801089cf:	50                   	push   %eax
801089d0:	ff 75 08             	pushl  0x8(%ebp)
801089d3:	e8 1b fb ff ff       	call   801084f3 <mappages>
801089d8:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801089db:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089e5:	3b 45 10             	cmp    0x10(%ebp),%eax
801089e8:	0f 82 75 ff ff ff    	jb     80108963 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801089ee:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089f1:	c9                   	leave  
801089f2:	c3                   	ret    

801089f3 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801089f3:	55                   	push   %ebp
801089f4:	89 e5                	mov    %esp,%ebp
801089f6:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801089f9:	8b 45 10             	mov    0x10(%ebp),%eax
801089fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089ff:	72 08                	jb     80108a09 <deallocuvm+0x16>
    return oldsz;
80108a01:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a04:	e9 a5 00 00 00       	jmp    80108aae <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108a09:	8b 45 10             	mov    0x10(%ebp),%eax
80108a0c:	05 ff 0f 00 00       	add    $0xfff,%eax
80108a11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108a19:	e9 81 00 00 00       	jmp    80108a9f <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a21:	83 ec 04             	sub    $0x4,%esp
80108a24:	6a 00                	push   $0x0
80108a26:	50                   	push   %eax
80108a27:	ff 75 08             	pushl  0x8(%ebp)
80108a2a:	e8 24 fa ff ff       	call   80108453 <walkpgdir>
80108a2f:	83 c4 10             	add    $0x10,%esp
80108a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108a35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a39:	75 09                	jne    80108a44 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108a3b:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108a42:	eb 54                	jmp    80108a98 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a47:	8b 00                	mov    (%eax),%eax
80108a49:	83 e0 01             	and    $0x1,%eax
80108a4c:	85 c0                	test   %eax,%eax
80108a4e:	74 48                	je     80108a98 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a53:	8b 00                	mov    (%eax),%eax
80108a55:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108a5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a61:	75 0d                	jne    80108a70 <deallocuvm+0x7d>
        panic("kfree");
80108a63:	83 ec 0c             	sub    $0xc,%esp
80108a66:	68 01 95 10 80       	push   $0x80109501
80108a6b:	e8 f6 7a ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80108a70:	83 ec 0c             	sub    $0xc,%esp
80108a73:	ff 75 ec             	pushl  -0x14(%ebp)
80108a76:	e8 56 f5 ff ff       	call   80107fd1 <p2v>
80108a7b:	83 c4 10             	add    $0x10,%esp
80108a7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108a81:	83 ec 0c             	sub    $0xc,%esp
80108a84:	ff 75 e8             	pushl  -0x18(%ebp)
80108a87:	e8 64 a1 ff ff       	call   80102bf0 <kfree>
80108a8c:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108a98:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aa2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108aa5:	0f 82 73 ff ff ff    	jb     80108a1e <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108aab:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108aae:	c9                   	leave  
80108aaf:	c3                   	ret    

80108ab0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108ab0:	55                   	push   %ebp
80108ab1:	89 e5                	mov    %esp,%ebp
80108ab3:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108ab6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108aba:	75 0d                	jne    80108ac9 <freevm+0x19>
    panic("freevm: no pgdir");
80108abc:	83 ec 0c             	sub    $0xc,%esp
80108abf:	68 07 95 10 80       	push   $0x80109507
80108ac4:	e8 9d 7a ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108ac9:	83 ec 04             	sub    $0x4,%esp
80108acc:	6a 00                	push   $0x0
80108ace:	68 00 00 00 80       	push   $0x80000000
80108ad3:	ff 75 08             	pushl  0x8(%ebp)
80108ad6:	e8 18 ff ff ff       	call   801089f3 <deallocuvm>
80108adb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108ade:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108ae5:	eb 4f                	jmp    80108b36 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108af1:	8b 45 08             	mov    0x8(%ebp),%eax
80108af4:	01 d0                	add    %edx,%eax
80108af6:	8b 00                	mov    (%eax),%eax
80108af8:	83 e0 01             	and    $0x1,%eax
80108afb:	85 c0                	test   %eax,%eax
80108afd:	74 33                	je     80108b32 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108b09:	8b 45 08             	mov    0x8(%ebp),%eax
80108b0c:	01 d0                	add    %edx,%eax
80108b0e:	8b 00                	mov    (%eax),%eax
80108b10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b15:	83 ec 0c             	sub    $0xc,%esp
80108b18:	50                   	push   %eax
80108b19:	e8 b3 f4 ff ff       	call   80107fd1 <p2v>
80108b1e:	83 c4 10             	add    $0x10,%esp
80108b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108b24:	83 ec 0c             	sub    $0xc,%esp
80108b27:	ff 75 f0             	pushl  -0x10(%ebp)
80108b2a:	e8 c1 a0 ff ff       	call   80102bf0 <kfree>
80108b2f:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108b32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108b36:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108b3d:	76 a8                	jbe    80108ae7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108b3f:	83 ec 0c             	sub    $0xc,%esp
80108b42:	ff 75 08             	pushl  0x8(%ebp)
80108b45:	e8 a6 a0 ff ff       	call   80102bf0 <kfree>
80108b4a:	83 c4 10             	add    $0x10,%esp
}
80108b4d:	90                   	nop
80108b4e:	c9                   	leave  
80108b4f:	c3                   	ret    

80108b50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108b50:	55                   	push   %ebp
80108b51:	89 e5                	mov    %esp,%ebp
80108b53:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b56:	83 ec 04             	sub    $0x4,%esp
80108b59:	6a 00                	push   $0x0
80108b5b:	ff 75 0c             	pushl  0xc(%ebp)
80108b5e:	ff 75 08             	pushl  0x8(%ebp)
80108b61:	e8 ed f8 ff ff       	call   80108453 <walkpgdir>
80108b66:	83 c4 10             	add    $0x10,%esp
80108b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108b6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108b70:	75 0d                	jne    80108b7f <clearpteu+0x2f>
    panic("clearpteu");
80108b72:	83 ec 0c             	sub    $0xc,%esp
80108b75:	68 18 95 10 80       	push   $0x80109518
80108b7a:	e8 e7 79 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b82:	8b 00                	mov    (%eax),%eax
80108b84:	83 e0 fb             	and    $0xfffffffb,%eax
80108b87:	89 c2                	mov    %eax,%edx
80108b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b8c:	89 10                	mov    %edx,(%eax)
}
80108b8e:	90                   	nop
80108b8f:	c9                   	leave  
80108b90:	c3                   	ret    

80108b91 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108b91:	55                   	push   %ebp
80108b92:	89 e5                	mov    %esp,%ebp
80108b94:	53                   	push   %ebx
80108b95:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108b98:	e8 e6 f9 ff ff       	call   80108583 <setupkvm>
80108b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108ba0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108ba4:	75 0a                	jne    80108bb0 <copyuvm+0x1f>
    return 0;
80108ba6:	b8 00 00 00 00       	mov    $0x0,%eax
80108bab:	e9 f8 00 00 00       	jmp    80108ca8 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108bb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108bb7:	e9 c4 00 00 00       	jmp    80108c80 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bbf:	83 ec 04             	sub    $0x4,%esp
80108bc2:	6a 00                	push   $0x0
80108bc4:	50                   	push   %eax
80108bc5:	ff 75 08             	pushl  0x8(%ebp)
80108bc8:	e8 86 f8 ff ff       	call   80108453 <walkpgdir>
80108bcd:	83 c4 10             	add    $0x10,%esp
80108bd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108bd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108bd7:	75 0d                	jne    80108be6 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108bd9:	83 ec 0c             	sub    $0xc,%esp
80108bdc:	68 22 95 10 80       	push   $0x80109522
80108be1:	e8 80 79 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108be9:	8b 00                	mov    (%eax),%eax
80108beb:	83 e0 01             	and    $0x1,%eax
80108bee:	85 c0                	test   %eax,%eax
80108bf0:	75 0d                	jne    80108bff <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108bf2:	83 ec 0c             	sub    $0xc,%esp
80108bf5:	68 3c 95 10 80       	push   $0x8010953c
80108bfa:	e8 67 79 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c02:	8b 00                	mov    (%eax),%eax
80108c04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c09:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c0f:	8b 00                	mov    (%eax),%eax
80108c11:	25 ff 0f 00 00       	and    $0xfff,%eax
80108c16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108c19:	e8 6f a0 ff ff       	call   80102c8d <kalloc>
80108c1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108c21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108c25:	74 6a                	je     80108c91 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108c27:	83 ec 0c             	sub    $0xc,%esp
80108c2a:	ff 75 e8             	pushl  -0x18(%ebp)
80108c2d:	e8 9f f3 ff ff       	call   80107fd1 <p2v>
80108c32:	83 c4 10             	add    $0x10,%esp
80108c35:	83 ec 04             	sub    $0x4,%esp
80108c38:	68 00 10 00 00       	push   $0x1000
80108c3d:	50                   	push   %eax
80108c3e:	ff 75 e0             	pushl  -0x20(%ebp)
80108c41:	e8 25 ce ff ff       	call   80105a6b <memmove>
80108c46:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108c49:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108c4c:	83 ec 0c             	sub    $0xc,%esp
80108c4f:	ff 75 e0             	pushl  -0x20(%ebp)
80108c52:	e8 6d f3 ff ff       	call   80107fc4 <v2p>
80108c57:	83 c4 10             	add    $0x10,%esp
80108c5a:	89 c2                	mov    %eax,%edx
80108c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c5f:	83 ec 0c             	sub    $0xc,%esp
80108c62:	53                   	push   %ebx
80108c63:	52                   	push   %edx
80108c64:	68 00 10 00 00       	push   $0x1000
80108c69:	50                   	push   %eax
80108c6a:	ff 75 f0             	pushl  -0x10(%ebp)
80108c6d:	e8 81 f8 ff ff       	call   801084f3 <mappages>
80108c72:	83 c4 20             	add    $0x20,%esp
80108c75:	85 c0                	test   %eax,%eax
80108c77:	78 1b                	js     80108c94 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108c79:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c83:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c86:	0f 82 30 ff ff ff    	jb     80108bbc <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c8f:	eb 17                	jmp    80108ca8 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108c91:	90                   	nop
80108c92:	eb 01                	jmp    80108c95 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108c94:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108c95:	83 ec 0c             	sub    $0xc,%esp
80108c98:	ff 75 f0             	pushl  -0x10(%ebp)
80108c9b:	e8 10 fe ff ff       	call   80108ab0 <freevm>
80108ca0:	83 c4 10             	add    $0x10,%esp
  return 0;
80108ca3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108cab:	c9                   	leave  
80108cac:	c3                   	ret    

80108cad <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108cad:	55                   	push   %ebp
80108cae:	89 e5                	mov    %esp,%ebp
80108cb0:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108cb3:	83 ec 04             	sub    $0x4,%esp
80108cb6:	6a 00                	push   $0x0
80108cb8:	ff 75 0c             	pushl  0xc(%ebp)
80108cbb:	ff 75 08             	pushl  0x8(%ebp)
80108cbe:	e8 90 f7 ff ff       	call   80108453 <walkpgdir>
80108cc3:	83 c4 10             	add    $0x10,%esp
80108cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ccc:	8b 00                	mov    (%eax),%eax
80108cce:	83 e0 01             	and    $0x1,%eax
80108cd1:	85 c0                	test   %eax,%eax
80108cd3:	75 07                	jne    80108cdc <uva2ka+0x2f>
    return 0;
80108cd5:	b8 00 00 00 00       	mov    $0x0,%eax
80108cda:	eb 29                	jmp    80108d05 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cdf:	8b 00                	mov    (%eax),%eax
80108ce1:	83 e0 04             	and    $0x4,%eax
80108ce4:	85 c0                	test   %eax,%eax
80108ce6:	75 07                	jne    80108cef <uva2ka+0x42>
    return 0;
80108ce8:	b8 00 00 00 00       	mov    $0x0,%eax
80108ced:	eb 16                	jmp    80108d05 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cf2:	8b 00                	mov    (%eax),%eax
80108cf4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cf9:	83 ec 0c             	sub    $0xc,%esp
80108cfc:	50                   	push   %eax
80108cfd:	e8 cf f2 ff ff       	call   80107fd1 <p2v>
80108d02:	83 c4 10             	add    $0x10,%esp
}
80108d05:	c9                   	leave  
80108d06:	c3                   	ret    

80108d07 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108d07:	55                   	push   %ebp
80108d08:	89 e5                	mov    %esp,%ebp
80108d0a:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108d0d:	8b 45 10             	mov    0x10(%ebp),%eax
80108d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108d13:	eb 7f                	jmp    80108d94 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108d15:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d23:	83 ec 08             	sub    $0x8,%esp
80108d26:	50                   	push   %eax
80108d27:	ff 75 08             	pushl  0x8(%ebp)
80108d2a:	e8 7e ff ff ff       	call   80108cad <uva2ka>
80108d2f:	83 c4 10             	add    $0x10,%esp
80108d32:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108d35:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108d39:	75 07                	jne    80108d42 <copyout+0x3b>
      return -1;
80108d3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d40:	eb 61                	jmp    80108da3 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d45:	2b 45 0c             	sub    0xc(%ebp),%eax
80108d48:	05 00 10 00 00       	add    $0x1000,%eax
80108d4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d53:	3b 45 14             	cmp    0x14(%ebp),%eax
80108d56:	76 06                	jbe    80108d5e <copyout+0x57>
      n = len;
80108d58:	8b 45 14             	mov    0x14(%ebp),%eax
80108d5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d61:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108d64:	89 c2                	mov    %eax,%edx
80108d66:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d69:	01 d0                	add    %edx,%eax
80108d6b:	83 ec 04             	sub    $0x4,%esp
80108d6e:	ff 75 f0             	pushl  -0x10(%ebp)
80108d71:	ff 75 f4             	pushl  -0xc(%ebp)
80108d74:	50                   	push   %eax
80108d75:	e8 f1 cc ff ff       	call   80105a6b <memmove>
80108d7a:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d80:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d86:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d8c:	05 00 10 00 00       	add    $0x1000,%eax
80108d91:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108d94:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108d98:	0f 85 77 ff ff ff    	jne    80108d15 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108da3:	c9                   	leave  
80108da4:	c3                   	ret    
