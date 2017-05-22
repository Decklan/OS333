
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
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
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
80100028:	bc 70 e6 10 80       	mov    $0x8010e670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 39 39 10 80       	mov    $0x80103939,%eax
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
8010003d:	68 e0 9c 10 80       	push   $0x80109ce0
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 d8 65 00 00       	call   80106624 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 25 11 80 84 	movl   $0x80112584,0x80112590
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 25 11 80 84 	movl   $0x80112584,0x80112594
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 e6 10 80 	movl   $0x8010e6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 25 11 80       	mov    0x80112594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 25 11 80       	mov    %eax,0x80112594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 25 11 80       	mov    $0x80112584,%eax
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
801000bc:	68 80 e6 10 80       	push   $0x8010e680
801000c1:	e8 80 65 00 00       	call   80106646 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 25 11 80       	mov    0x80112594,%eax
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
80100107:	68 80 e6 10 80       	push   $0x8010e680
8010010c:	e8 9c 65 00 00       	call   801066ad <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 8c 52 00 00       	call   801053b8 <sleep>
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
8010013a:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 25 11 80       	mov    0x80112590,%eax
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
80100183:	68 80 e6 10 80       	push   $0x8010e680
80100188:	e8 20 65 00 00       	call   801066ad <release>
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
8010019e:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 e7 9c 10 80       	push   $0x80109ce7
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
801001e2:	e8 d0 27 00 00       	call   801029b7 <iderw>
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
80100204:	68 f8 9c 10 80       	push   $0x80109cf8
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
80100223:	e8 8f 27 00 00       	call   801029b7 <iderw>
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
80100243:	68 ff 9c 10 80       	push   $0x80109cff
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 ec 63 00 00       	call   80106646 <acquire>
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
8010027b:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 25 11 80       	mov    0x80112594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 25 11 80       	mov    %eax,0x80112594

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
801002b9:	e8 d3 52 00 00       	call   80105591 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 df 63 00 00       	call   801066ad <release>
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
80100365:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
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
801003cc:	a1 14 d6 10 80       	mov    0x8010d614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 d5 10 80       	push   $0x8010d5e0
801003e2:	e8 5f 62 00 00       	call   80106646 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 06 9d 10 80       	push   $0x80109d06
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
801004cd:	c7 45 ec 0f 9d 10 80 	movl   $0x80109d0f,-0x14(%ebp)
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
80100556:	68 e0 d5 10 80       	push   $0x8010d5e0
8010055b:	e8 4d 61 00 00       	call   801066ad <release>
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
80100571:	c7 05 14 d6 10 80 00 	movl   $0x0,0x8010d614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 16 9d 10 80       	push   $0x80109d16
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
801005aa:	68 25 9d 10 80       	push   $0x80109d25
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 38 61 00 00       	call   801066ff <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 27 9d 10 80       	push   $0x80109d27
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
801005f5:	c7 05 c0 d5 10 80 01 	movl   $0x1,0x8010d5c0
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
80100699:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
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
801006ca:	68 2b 9d 10 80       	push   $0x80109d2b
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 6c 62 00 00       	call   80106968 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 83 61 00 00       	call   801068a9 <memset>
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
8010077e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
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
80100798:	a1 c0 d5 10 80       	mov    0x8010d5c0,%eax
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
801007b6:	e8 ad 7b 00 00       	call   80108368 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 a0 7b 00 00       	call   80108368 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 93 7b 00 00       	call   80108368 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 83 7b 00 00       	call   80108368 <uartputc>
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
801007fc:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int f = 0;
80100806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int r = 0;
8010080d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int s = 0;
80100814:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  int z = 0;
8010081b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

  acquire(&cons.lock);
80100822:	83 ec 0c             	sub    $0xc,%esp
80100825:	68 e0 d5 10 80       	push   $0x8010d5e0
8010082a:	e8 17 5e 00 00       	call   80106646 <acquire>
8010082f:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100832:	e9 a6 01 00 00       	jmp    801009dd <consoleintr+0x1e4>
    switch(c){
80100837:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010083a:	83 f8 12             	cmp    $0x12,%eax
8010083d:	0f 84 e4 00 00 00    	je     80100927 <consoleintr+0x12e>
80100843:	83 f8 12             	cmp    $0x12,%eax
80100846:	7f 1c                	jg     80100864 <consoleintr+0x6b>
80100848:	83 f8 08             	cmp    $0x8,%eax
8010084b:	0f 84 95 00 00 00    	je     801008e6 <consoleintr+0xed>
80100851:	83 f8 10             	cmp    $0x10,%eax
80100854:	74 39                	je     8010088f <consoleintr+0x96>
80100856:	83 f8 06             	cmp    $0x6,%eax
80100859:	0f 84 bc 00 00 00    	je     8010091b <consoleintr+0x122>
8010085f:	e9 e7 00 00 00       	jmp    8010094b <consoleintr+0x152>
80100864:	83 f8 15             	cmp    $0x15,%eax
80100867:	74 4f                	je     801008b8 <consoleintr+0xbf>
80100869:	83 f8 15             	cmp    $0x15,%eax
8010086c:	7f 0e                	jg     8010087c <consoleintr+0x83>
8010086e:	83 f8 13             	cmp    $0x13,%eax
80100871:	0f 84 bc 00 00 00    	je     80100933 <consoleintr+0x13a>
80100877:	e9 cf 00 00 00       	jmp    8010094b <consoleintr+0x152>
8010087c:	83 f8 1a             	cmp    $0x1a,%eax
8010087f:	0f 84 ba 00 00 00    	je     8010093f <consoleintr+0x146>
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	74 5c                	je     801008e6 <consoleintr+0xed>
8010088a:	e9 bc 00 00 00       	jmp    8010094b <consoleintr+0x152>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
8010088f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100896:	e9 42 01 00 00       	jmp    801009dd <consoleintr+0x1e4>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010089b:	a1 28 28 11 80       	mov    0x80112828,%eax
801008a0:	83 e8 01             	sub    $0x1,%eax
801008a3:	a3 28 28 11 80       	mov    %eax,0x80112828
        consputc(BACKSPACE);
801008a8:	83 ec 0c             	sub    $0xc,%esp
801008ab:	68 00 01 00 00       	push   $0x100
801008b0:	e8 dd fe ff ff       	call   80100792 <consputc>
801008b5:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008b8:	8b 15 28 28 11 80    	mov    0x80112828,%edx
801008be:	a1 24 28 11 80       	mov    0x80112824,%eax
801008c3:	39 c2                	cmp    %eax,%edx
801008c5:	0f 84 12 01 00 00    	je     801009dd <consoleintr+0x1e4>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008cb:	a1 28 28 11 80       	mov    0x80112828,%eax
801008d0:	83 e8 01             	sub    $0x1,%eax
801008d3:	83 e0 7f             	and    $0x7f,%eax
801008d6:	0f b6 80 a0 27 11 80 	movzbl -0x7feed860(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008dd:	3c 0a                	cmp    $0xa,%al
801008df:	75 ba                	jne    8010089b <consoleintr+0xa2>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008e1:	e9 f7 00 00 00       	jmp    801009dd <consoleintr+0x1e4>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008e6:	8b 15 28 28 11 80    	mov    0x80112828,%edx
801008ec:	a1 24 28 11 80       	mov    0x80112824,%eax
801008f1:	39 c2                	cmp    %eax,%edx
801008f3:	0f 84 e4 00 00 00    	je     801009dd <consoleintr+0x1e4>
        input.e--;
801008f9:	a1 28 28 11 80       	mov    0x80112828,%eax
801008fe:	83 e8 01             	sub    $0x1,%eax
80100901:	a3 28 28 11 80       	mov    %eax,0x80112828
        consputc(BACKSPACE);
80100906:	83 ec 0c             	sub    $0xc,%esp
80100909:	68 00 01 00 00       	push   $0x100
8010090e:	e8 7f fe ff ff       	call   80100792 <consputc>
80100913:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100916:	e9 c2 00 00 00       	jmp    801009dd <consoleintr+0x1e4>
    case C('F'):
      f = 1;
8010091b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
80100922:	e9 b6 00 00 00       	jmp    801009dd <consoleintr+0x1e4>
    case C('R'):
      r = 1;
80100927:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
      break;
8010092e:	e9 aa 00 00 00       	jmp    801009dd <consoleintr+0x1e4>
    case C('S'):
      s = 1;
80100933:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
      break;
8010093a:	e9 9e 00 00 00       	jmp    801009dd <consoleintr+0x1e4>
    case C('Z'):
      z = 1;
8010093f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
80100946:	e9 92 00 00 00       	jmp    801009dd <consoleintr+0x1e4>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010094b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010094f:	0f 84 87 00 00 00    	je     801009dc <consoleintr+0x1e3>
80100955:	8b 15 28 28 11 80    	mov    0x80112828,%edx
8010095b:	a1 20 28 11 80       	mov    0x80112820,%eax
80100960:	29 c2                	sub    %eax,%edx
80100962:	89 d0                	mov    %edx,%eax
80100964:	83 f8 7f             	cmp    $0x7f,%eax
80100967:	77 73                	ja     801009dc <consoleintr+0x1e3>
        c = (c == '\r') ? '\n' : c;
80100969:	83 7d e0 0d          	cmpl   $0xd,-0x20(%ebp)
8010096d:	74 05                	je     80100974 <consoleintr+0x17b>
8010096f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100972:	eb 05                	jmp    80100979 <consoleintr+0x180>
80100974:	b8 0a 00 00 00       	mov    $0xa,%eax
80100979:	89 45 e0             	mov    %eax,-0x20(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	a1 28 28 11 80       	mov    0x80112828,%eax
80100981:	8d 50 01             	lea    0x1(%eax),%edx
80100984:	89 15 28 28 11 80    	mov    %edx,0x80112828
8010098a:	83 e0 7f             	and    $0x7f,%eax
8010098d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100990:	88 90 a0 27 11 80    	mov    %dl,-0x7feed860(%eax)
        consputc(c);
80100996:	83 ec 0c             	sub    $0xc,%esp
80100999:	ff 75 e0             	pushl  -0x20(%ebp)
8010099c:	e8 f1 fd ff ff       	call   80100792 <consputc>
801009a1:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009a4:	83 7d e0 0a          	cmpl   $0xa,-0x20(%ebp)
801009a8:	74 18                	je     801009c2 <consoleintr+0x1c9>
801009aa:	83 7d e0 04          	cmpl   $0x4,-0x20(%ebp)
801009ae:	74 12                	je     801009c2 <consoleintr+0x1c9>
801009b0:	a1 28 28 11 80       	mov    0x80112828,%eax
801009b5:	8b 15 20 28 11 80    	mov    0x80112820,%edx
801009bb:	83 ea 80             	sub    $0xffffff80,%edx
801009be:	39 d0                	cmp    %edx,%eax
801009c0:	75 1a                	jne    801009dc <consoleintr+0x1e3>
          input.w = input.e;
801009c2:	a1 28 28 11 80       	mov    0x80112828,%eax
801009c7:	a3 24 28 11 80       	mov    %eax,0x80112824
          wakeup(&input.r);
801009cc:	83 ec 0c             	sub    $0xc,%esp
801009cf:	68 20 28 11 80       	push   $0x80112820
801009d4:	e8 b8 4b 00 00       	call   80105591 <wakeup>
801009d9:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009dc:	90                   	nop
  int r = 0;
  int s = 0;
  int z = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009dd:	8b 45 08             	mov    0x8(%ebp),%eax
801009e0:	ff d0                	call   *%eax
801009e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801009e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801009e9:	0f 89 48 fe ff ff    	jns    80100837 <consoleintr+0x3e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009ef:	83 ec 0c             	sub    $0xc,%esp
801009f2:	68 e0 d5 10 80       	push   $0x8010d5e0
801009f7:	e8 b1 5c 00 00       	call   801066ad <release>
801009fc:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a03:	74 05                	je     80100a0a <consoleintr+0x211>
    procdump();  // now call procdump() wo. cons.lock held
80100a05:	e8 76 4d 00 00       	call   80105780 <procdump>
  }
  if (f) {
80100a0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a0e:	74 05                	je     80100a15 <consoleintr+0x21c>
    free_length();
80100a10:	e8 e3 51 00 00       	call   80105bf8 <free_length>
  }
  if (r) {
80100a15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a19:	74 05                	je     80100a20 <consoleintr+0x227>
    display_ready();
80100a1b:	e8 64 52 00 00       	call   80105c84 <display_ready>
  }
  if (s) {
80100a20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a24:	74 05                	je     80100a2b <consoleintr+0x232>
    display_sleep();
80100a26:	e8 4c 53 00 00       	call   80105d77 <display_sleep>
  }
  if (z) {
80100a2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a2f:	74 05                	je     80100a36 <consoleintr+0x23d>
    display_zombie();
80100a31:	e8 fb 53 00 00       	call   80105e31 <display_zombie>
  }
}
80100a36:	90                   	nop
80100a37:	c9                   	leave  
80100a38:	c3                   	ret    

80100a39 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a39:	55                   	push   %ebp
80100a3a:	89 e5                	mov    %esp,%ebp
80100a3c:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a3f:	83 ec 0c             	sub    $0xc,%esp
80100a42:	ff 75 08             	pushl  0x8(%ebp)
80100a45:	e8 28 11 00 00       	call   80101b72 <iunlock>
80100a4a:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a4d:	8b 45 10             	mov    0x10(%ebp),%eax
80100a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a53:	83 ec 0c             	sub    $0xc,%esp
80100a56:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a5b:	e8 e6 5b 00 00       	call   80106646 <acquire>
80100a60:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a63:	e9 ac 00 00 00       	jmp    80100b14 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a6e:	8b 40 24             	mov    0x24(%eax),%eax
80100a71:	85 c0                	test   %eax,%eax
80100a73:	74 28                	je     80100a9d <consoleread+0x64>
        release(&cons.lock);
80100a75:	83 ec 0c             	sub    $0xc,%esp
80100a78:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a7d:	e8 2b 5c 00 00       	call   801066ad <release>
80100a82:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a85:	83 ec 0c             	sub    $0xc,%esp
80100a88:	ff 75 08             	pushl  0x8(%ebp)
80100a8b:	e8 84 0f 00 00       	call   80101a14 <ilock>
80100a90:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a98:	e9 ab 00 00 00       	jmp    80100b48 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a9d:	83 ec 08             	sub    $0x8,%esp
80100aa0:	68 e0 d5 10 80       	push   $0x8010d5e0
80100aa5:	68 20 28 11 80       	push   $0x80112820
80100aaa:	e8 09 49 00 00       	call   801053b8 <sleep>
80100aaf:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100ab2:	8b 15 20 28 11 80    	mov    0x80112820,%edx
80100ab8:	a1 24 28 11 80       	mov    0x80112824,%eax
80100abd:	39 c2                	cmp    %eax,%edx
80100abf:	74 a7                	je     80100a68 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ac1:	a1 20 28 11 80       	mov    0x80112820,%eax
80100ac6:	8d 50 01             	lea    0x1(%eax),%edx
80100ac9:	89 15 20 28 11 80    	mov    %edx,0x80112820
80100acf:	83 e0 7f             	and    $0x7f,%eax
80100ad2:	0f b6 80 a0 27 11 80 	movzbl -0x7feed860(%eax),%eax
80100ad9:	0f be c0             	movsbl %al,%eax
80100adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100adf:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100ae3:	75 17                	jne    80100afc <consoleread+0xc3>
      if(n < target){
80100ae5:	8b 45 10             	mov    0x10(%ebp),%eax
80100ae8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100aeb:	73 2f                	jae    80100b1c <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100aed:	a1 20 28 11 80       	mov    0x80112820,%eax
80100af2:	83 e8 01             	sub    $0x1,%eax
80100af5:	a3 20 28 11 80       	mov    %eax,0x80112820
      }
      break;
80100afa:	eb 20                	jmp    80100b1c <consoleread+0xe3>
    }
    *dst++ = c;
80100afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100aff:	8d 50 01             	lea    0x1(%eax),%edx
80100b02:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b05:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b08:	88 10                	mov    %dl,(%eax)
    --n;
80100b0a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b0e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b12:	74 0b                	je     80100b1f <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b18:	7f 98                	jg     80100ab2 <consoleread+0x79>
80100b1a:	eb 04                	jmp    80100b20 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100b1c:	90                   	nop
80100b1d:	eb 01                	jmp    80100b20 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100b1f:	90                   	nop
  }
  release(&cons.lock);
80100b20:	83 ec 0c             	sub    $0xc,%esp
80100b23:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b28:	e8 80 5b 00 00       	call   801066ad <release>
80100b2d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b30:	83 ec 0c             	sub    $0xc,%esp
80100b33:	ff 75 08             	pushl  0x8(%ebp)
80100b36:	e8 d9 0e 00 00       	call   80101a14 <ilock>
80100b3b:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b3e:	8b 45 10             	mov    0x10(%ebp),%eax
80100b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b44:	29 c2                	sub    %eax,%edx
80100b46:	89 d0                	mov    %edx,%eax
}
80100b48:	c9                   	leave  
80100b49:	c3                   	ret    

80100b4a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b4a:	55                   	push   %ebp
80100b4b:	89 e5                	mov    %esp,%ebp
80100b4d:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff 75 08             	pushl  0x8(%ebp)
80100b56:	e8 17 10 00 00       	call   80101b72 <iunlock>
80100b5b:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b5e:	83 ec 0c             	sub    $0xc,%esp
80100b61:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b66:	e8 db 5a 00 00       	call   80106646 <acquire>
80100b6b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b75:	eb 21                	jmp    80100b98 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b7d:	01 d0                	add    %edx,%eax
80100b7f:	0f b6 00             	movzbl (%eax),%eax
80100b82:	0f be c0             	movsbl %al,%eax
80100b85:	0f b6 c0             	movzbl %al,%eax
80100b88:	83 ec 0c             	sub    $0xc,%esp
80100b8b:	50                   	push   %eax
80100b8c:	e8 01 fc ff ff       	call   80100792 <consputc>
80100b91:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b9b:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b9e:	7c d7                	jl     80100b77 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ba0:	83 ec 0c             	sub    $0xc,%esp
80100ba3:	68 e0 d5 10 80       	push   $0x8010d5e0
80100ba8:	e8 00 5b 00 00       	call   801066ad <release>
80100bad:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bb0:	83 ec 0c             	sub    $0xc,%esp
80100bb3:	ff 75 08             	pushl  0x8(%ebp)
80100bb6:	e8 59 0e 00 00       	call   80101a14 <ilock>
80100bbb:	83 c4 10             	add    $0x10,%esp

  return n;
80100bbe:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bc1:	c9                   	leave  
80100bc2:	c3                   	ret    

80100bc3 <consoleinit>:

void
consoleinit(void)
{
80100bc3:	55                   	push   %ebp
80100bc4:	89 e5                	mov    %esp,%ebp
80100bc6:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100bc9:	83 ec 08             	sub    $0x8,%esp
80100bcc:	68 3e 9d 10 80       	push   $0x80109d3e
80100bd1:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bd6:	e8 49 5a 00 00       	call   80106624 <initlock>
80100bdb:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bde:	c7 05 ec 31 11 80 4a 	movl   $0x80100b4a,0x801131ec
80100be5:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be8:	c7 05 e8 31 11 80 39 	movl   $0x80100a39,0x801131e8
80100bef:	0a 10 80 
  cons.locking = 1;
80100bf2:	c7 05 14 d6 10 80 01 	movl   $0x1,0x8010d614
80100bf9:	00 00 00 

  picenable(IRQ_KBD);
80100bfc:	83 ec 0c             	sub    $0xc,%esp
80100bff:	6a 01                	push   $0x1
80100c01:	e8 cf 33 00 00       	call   80103fd5 <picenable>
80100c06:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c09:	83 ec 08             	sub    $0x8,%esp
80100c0c:	6a 00                	push   $0x0
80100c0e:	6a 01                	push   $0x1
80100c10:	e8 6f 1f 00 00       	call   80102b84 <ioapicenable>
80100c15:	83 c4 10             	add    $0x10,%esp
}
80100c18:	90                   	nop
80100c19:	c9                   	leave  
80100c1a:	c3                   	ret    

80100c1b <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c1b:	55                   	push   %ebp
80100c1c:	89 e5                	mov    %esp,%ebp
80100c1e:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100c24:	e8 ce 29 00 00       	call   801035f7 <begin_op>
  if((ip = namei(path)) == 0){
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	ff 75 08             	pushl  0x8(%ebp)
80100c2f:	e8 9e 19 00 00       	call   801025d2 <namei>
80100c34:	83 c4 10             	add    $0x10,%esp
80100c37:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c3e:	75 0f                	jne    80100c4f <exec+0x34>
    end_op();
80100c40:	e8 3e 2a 00 00       	call   80103683 <end_op>
    return -1;
80100c45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c4a:	e9 ce 03 00 00       	jmp    8010101d <exec+0x402>
  }
  ilock(ip);
80100c4f:	83 ec 0c             	sub    $0xc,%esp
80100c52:	ff 75 d8             	pushl  -0x28(%ebp)
80100c55:	e8 ba 0d 00 00       	call   80101a14 <ilock>
80100c5a:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c5d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c64:	6a 34                	push   $0x34
80100c66:	6a 00                	push   $0x0
80100c68:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100c6e:	50                   	push   %eax
80100c6f:	ff 75 d8             	pushl  -0x28(%ebp)
80100c72:	e8 0b 13 00 00       	call   80101f82 <readi>
80100c77:	83 c4 10             	add    $0x10,%esp
80100c7a:	83 f8 33             	cmp    $0x33,%eax
80100c7d:	0f 86 49 03 00 00    	jbe    80100fcc <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c83:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c89:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c8e:	0f 85 3b 03 00 00    	jne    80100fcf <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c94:	e8 24 88 00 00       	call   801094bd <setupkvm>
80100c99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c9c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ca0:	0f 84 2c 03 00 00    	je     80100fd2 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100ca6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100cb4:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100cba:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cbd:	e9 ab 00 00 00       	jmp    80100d6d <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cc5:	6a 20                	push   $0x20
80100cc7:	50                   	push   %eax
80100cc8:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100cce:	50                   	push   %eax
80100ccf:	ff 75 d8             	pushl  -0x28(%ebp)
80100cd2:	e8 ab 12 00 00       	call   80101f82 <readi>
80100cd7:	83 c4 10             	add    $0x10,%esp
80100cda:	83 f8 20             	cmp    $0x20,%eax
80100cdd:	0f 85 f2 02 00 00    	jne    80100fd5 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ce3:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ce9:	83 f8 01             	cmp    $0x1,%eax
80100cec:	75 71                	jne    80100d5f <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100cee:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100cf4:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cfa:	39 c2                	cmp    %eax,%edx
80100cfc:	0f 82 d6 02 00 00    	jb     80100fd8 <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d02:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100d08:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100d0e:	01 d0                	add    %edx,%eax
80100d10:	83 ec 04             	sub    $0x4,%esp
80100d13:	50                   	push   %eax
80100d14:	ff 75 e0             	pushl  -0x20(%ebp)
80100d17:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1a:	e8 45 8b 00 00       	call   80109864 <allocuvm>
80100d1f:	83 c4 10             	add    $0x10,%esp
80100d22:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d29:	0f 84 ac 02 00 00    	je     80100fdb <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d2f:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d35:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d3b:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d41:	83 ec 0c             	sub    $0xc,%esp
80100d44:	52                   	push   %edx
80100d45:	50                   	push   %eax
80100d46:	ff 75 d8             	pushl  -0x28(%ebp)
80100d49:	51                   	push   %ecx
80100d4a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d4d:	e8 3b 8a 00 00       	call   8010978d <loaduvm>
80100d52:	83 c4 20             	add    $0x20,%esp
80100d55:	85 c0                	test   %eax,%eax
80100d57:	0f 88 81 02 00 00    	js     80100fde <exec+0x3c3>
80100d5d:	eb 01                	jmp    80100d60 <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d5f:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d60:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d64:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d67:	83 c0 20             	add    $0x20,%eax
80100d6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d6d:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d74:	0f b7 c0             	movzwl %ax,%eax
80100d77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d7a:	0f 8f 42 ff ff ff    	jg     80100cc2 <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d80:	83 ec 0c             	sub    $0xc,%esp
80100d83:	ff 75 d8             	pushl  -0x28(%ebp)
80100d86:	e8 49 0f 00 00       	call   80101cd4 <iunlockput>
80100d8b:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d8e:	e8 f0 28 00 00       	call   80103683 <end_op>
  ip = 0;
80100d93:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d9d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100da2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100da7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100daa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dad:	05 00 20 00 00       	add    $0x2000,%eax
80100db2:	83 ec 04             	sub    $0x4,%esp
80100db5:	50                   	push   %eax
80100db6:	ff 75 e0             	pushl  -0x20(%ebp)
80100db9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dbc:	e8 a3 8a 00 00       	call   80109864 <allocuvm>
80100dc1:	83 c4 10             	add    $0x10,%esp
80100dc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dc7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dcb:	0f 84 10 02 00 00    	je     80100fe1 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dd4:	2d 00 20 00 00       	sub    $0x2000,%eax
80100dd9:	83 ec 08             	sub    $0x8,%esp
80100ddc:	50                   	push   %eax
80100ddd:	ff 75 d4             	pushl  -0x2c(%ebp)
80100de0:	e8 a5 8c 00 00       	call   80109a8a <clearpteu>
80100de5:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100deb:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100df5:	e9 96 00 00 00       	jmp    80100e90 <exec+0x275>
    if(argc >= MAXARG)
80100dfa:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dfe:	0f 87 e0 01 00 00    	ja     80100fe4 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e07:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e11:	01 d0                	add    %edx,%eax
80100e13:	8b 00                	mov    (%eax),%eax
80100e15:	83 ec 0c             	sub    $0xc,%esp
80100e18:	50                   	push   %eax
80100e19:	e8 d8 5c 00 00       	call   80106af6 <strlen>
80100e1e:	83 c4 10             	add    $0x10,%esp
80100e21:	89 c2                	mov    %eax,%edx
80100e23:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e26:	29 d0                	sub    %edx,%eax
80100e28:	83 e8 01             	sub    $0x1,%eax
80100e2b:	83 e0 fc             	and    $0xfffffffc,%eax
80100e2e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e3e:	01 d0                	add    %edx,%eax
80100e40:	8b 00                	mov    (%eax),%eax
80100e42:	83 ec 0c             	sub    $0xc,%esp
80100e45:	50                   	push   %eax
80100e46:	e8 ab 5c 00 00       	call   80106af6 <strlen>
80100e4b:	83 c4 10             	add    $0x10,%esp
80100e4e:	83 c0 01             	add    $0x1,%eax
80100e51:	89 c1                	mov    %eax,%ecx
80100e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e60:	01 d0                	add    %edx,%eax
80100e62:	8b 00                	mov    (%eax),%eax
80100e64:	51                   	push   %ecx
80100e65:	50                   	push   %eax
80100e66:	ff 75 dc             	pushl  -0x24(%ebp)
80100e69:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e6c:	e8 d0 8d 00 00       	call   80109c41 <copyout>
80100e71:	83 c4 10             	add    $0x10,%esp
80100e74:	85 c0                	test   %eax,%eax
80100e76:	0f 88 6b 01 00 00    	js     80100fe7 <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100e7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e7f:	8d 50 03             	lea    0x3(%eax),%edx
80100e82:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e85:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e8c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e93:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e9d:	01 d0                	add    %edx,%eax
80100e9f:	8b 00                	mov    (%eax),%eax
80100ea1:	85 c0                	test   %eax,%eax
80100ea3:	0f 85 51 ff ff ff    	jne    80100dfa <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eac:	83 c0 03             	add    $0x3,%eax
80100eaf:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100eb6:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100eba:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100ec1:	ff ff ff 
  ustack[1] = argc;
80100ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec7:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ecd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ed0:	83 c0 01             	add    $0x1,%eax
80100ed3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100eda:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100edd:	29 d0                	sub    %edx,%eax
80100edf:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100ee5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee8:	83 c0 04             	add    $0x4,%eax
80100eeb:	c1 e0 02             	shl    $0x2,%eax
80100eee:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef4:	83 c0 04             	add    $0x4,%eax
80100ef7:	c1 e0 02             	shl    $0x2,%eax
80100efa:	50                   	push   %eax
80100efb:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100f01:	50                   	push   %eax
80100f02:	ff 75 dc             	pushl  -0x24(%ebp)
80100f05:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f08:	e8 34 8d 00 00       	call   80109c41 <copyout>
80100f0d:	83 c4 10             	add    $0x10,%esp
80100f10:	85 c0                	test   %eax,%eax
80100f12:	0f 88 d2 00 00 00    	js     80100fea <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f18:	8b 45 08             	mov    0x8(%ebp),%eax
80100f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f21:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f24:	eb 17                	jmp    80100f3d <exec+0x322>
    if(*s == '/')
80100f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f29:	0f b6 00             	movzbl (%eax),%eax
80100f2c:	3c 2f                	cmp    $0x2f,%al
80100f2e:	75 09                	jne    80100f39 <exec+0x31e>
      last = s+1;
80100f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f33:	83 c0 01             	add    $0x1,%eax
80100f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f40:	0f b6 00             	movzbl (%eax),%eax
80100f43:	84 c0                	test   %al,%al
80100f45:	75 df                	jne    80100f26 <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f47:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f4d:	83 c0 6c             	add    $0x6c,%eax
80100f50:	83 ec 04             	sub    $0x4,%esp
80100f53:	6a 10                	push   $0x10
80100f55:	ff 75 f0             	pushl  -0x10(%ebp)
80100f58:	50                   	push   %eax
80100f59:	e8 4e 5b 00 00       	call   80106aac <safestrcpy>
80100f5e:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f67:	8b 40 04             	mov    0x4(%eax),%eax
80100f6a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f73:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f76:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f82:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f8a:	8b 40 18             	mov    0x18(%eax),%eax
80100f8d:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f93:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f96:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f9c:	8b 40 18             	mov    0x18(%eax),%eax
80100f9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100fa2:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100fa5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fab:	83 ec 0c             	sub    $0xc,%esp
80100fae:	50                   	push   %eax
80100faf:	e8 f0 85 00 00       	call   801095a4 <switchuvm>
80100fb4:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fb7:	83 ec 0c             	sub    $0xc,%esp
80100fba:	ff 75 d0             	pushl  -0x30(%ebp)
80100fbd:	e8 28 8a 00 00       	call   801099ea <freevm>
80100fc2:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fc5:	b8 00 00 00 00       	mov    $0x0,%eax
80100fca:	eb 51                	jmp    8010101d <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100fcc:	90                   	nop
80100fcd:	eb 1c                	jmp    80100feb <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100fcf:	90                   	nop
80100fd0:	eb 19                	jmp    80100feb <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100fd2:	90                   	nop
80100fd3:	eb 16                	jmp    80100feb <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100fd5:	90                   	nop
80100fd6:	eb 13                	jmp    80100feb <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100fd8:	90                   	nop
80100fd9:	eb 10                	jmp    80100feb <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100fdb:	90                   	nop
80100fdc:	eb 0d                	jmp    80100feb <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100fde:	90                   	nop
80100fdf:	eb 0a                	jmp    80100feb <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100fe1:	90                   	nop
80100fe2:	eb 07                	jmp    80100feb <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100fe4:	90                   	nop
80100fe5:	eb 04                	jmp    80100feb <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100fe7:	90                   	nop
80100fe8:	eb 01                	jmp    80100feb <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100fea:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100feb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fef:	74 0e                	je     80100fff <exec+0x3e4>
    freevm(pgdir);
80100ff1:	83 ec 0c             	sub    $0xc,%esp
80100ff4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ff7:	e8 ee 89 00 00       	call   801099ea <freevm>
80100ffc:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101003:	74 13                	je     80101018 <exec+0x3fd>
    iunlockput(ip);
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	ff 75 d8             	pushl  -0x28(%ebp)
8010100b:	e8 c4 0c 00 00       	call   80101cd4 <iunlockput>
80101010:	83 c4 10             	add    $0x10,%esp
    end_op();
80101013:	e8 6b 26 00 00       	call   80103683 <end_op>
  }
  return -1;
80101018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010101d:	c9                   	leave  
8010101e:	c3                   	ret    

8010101f <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
8010101f:	55                   	push   %ebp
80101020:	89 e5                	mov    %esp,%ebp
80101022:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80101025:	83 ec 08             	sub    $0x8,%esp
80101028:	68 46 9d 10 80       	push   $0x80109d46
8010102d:	68 40 28 11 80       	push   $0x80112840
80101032:	e8 ed 55 00 00       	call   80106624 <initlock>
80101037:	83 c4 10             	add    $0x10,%esp
}
8010103a:	90                   	nop
8010103b:	c9                   	leave  
8010103c:	c3                   	ret    

8010103d <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
8010103d:	55                   	push   %ebp
8010103e:	89 e5                	mov    %esp,%ebp
80101040:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80101043:	83 ec 0c             	sub    $0xc,%esp
80101046:	68 40 28 11 80       	push   $0x80112840
8010104b:	e8 f6 55 00 00       	call   80106646 <acquire>
80101050:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101053:	c7 45 f4 74 28 11 80 	movl   $0x80112874,-0xc(%ebp)
8010105a:	eb 2d                	jmp    80101089 <filealloc+0x4c>
    if(f->ref == 0){
8010105c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010105f:	8b 40 04             	mov    0x4(%eax),%eax
80101062:	85 c0                	test   %eax,%eax
80101064:	75 1f                	jne    80101085 <filealloc+0x48>
      f->ref = 1;
80101066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101069:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101070:	83 ec 0c             	sub    $0xc,%esp
80101073:	68 40 28 11 80       	push   $0x80112840
80101078:	e8 30 56 00 00       	call   801066ad <release>
8010107d:	83 c4 10             	add    $0x10,%esp
      return f;
80101080:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101083:	eb 23                	jmp    801010a8 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101085:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101089:	b8 d4 31 11 80       	mov    $0x801131d4,%eax
8010108e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101091:	72 c9                	jb     8010105c <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101093:	83 ec 0c             	sub    $0xc,%esp
80101096:	68 40 28 11 80       	push   $0x80112840
8010109b:	e8 0d 56 00 00       	call   801066ad <release>
801010a0:	83 c4 10             	add    $0x10,%esp
  return 0;
801010a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801010a8:	c9                   	leave  
801010a9:	c3                   	ret    

801010aa <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010aa:	55                   	push   %ebp
801010ab:	89 e5                	mov    %esp,%ebp
801010ad:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801010b0:	83 ec 0c             	sub    $0xc,%esp
801010b3:	68 40 28 11 80       	push   $0x80112840
801010b8:	e8 89 55 00 00       	call   80106646 <acquire>
801010bd:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010c0:	8b 45 08             	mov    0x8(%ebp),%eax
801010c3:	8b 40 04             	mov    0x4(%eax),%eax
801010c6:	85 c0                	test   %eax,%eax
801010c8:	7f 0d                	jg     801010d7 <filedup+0x2d>
    panic("filedup");
801010ca:	83 ec 0c             	sub    $0xc,%esp
801010cd:	68 4d 9d 10 80       	push   $0x80109d4d
801010d2:	e8 8f f4 ff ff       	call   80100566 <panic>
  f->ref++;
801010d7:	8b 45 08             	mov    0x8(%ebp),%eax
801010da:	8b 40 04             	mov    0x4(%eax),%eax
801010dd:	8d 50 01             	lea    0x1(%eax),%edx
801010e0:	8b 45 08             	mov    0x8(%ebp),%eax
801010e3:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010e6:	83 ec 0c             	sub    $0xc,%esp
801010e9:	68 40 28 11 80       	push   $0x80112840
801010ee:	e8 ba 55 00 00       	call   801066ad <release>
801010f3:	83 c4 10             	add    $0x10,%esp
  return f;
801010f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010f9:	c9                   	leave  
801010fa:	c3                   	ret    

801010fb <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010fb:	55                   	push   %ebp
801010fc:	89 e5                	mov    %esp,%ebp
801010fe:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101101:	83 ec 0c             	sub    $0xc,%esp
80101104:	68 40 28 11 80       	push   $0x80112840
80101109:	e8 38 55 00 00       	call   80106646 <acquire>
8010110e:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101111:	8b 45 08             	mov    0x8(%ebp),%eax
80101114:	8b 40 04             	mov    0x4(%eax),%eax
80101117:	85 c0                	test   %eax,%eax
80101119:	7f 0d                	jg     80101128 <fileclose+0x2d>
    panic("fileclose");
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	68 55 9d 10 80       	push   $0x80109d55
80101123:	e8 3e f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
80101128:	8b 45 08             	mov    0x8(%ebp),%eax
8010112b:	8b 40 04             	mov    0x4(%eax),%eax
8010112e:	8d 50 ff             	lea    -0x1(%eax),%edx
80101131:	8b 45 08             	mov    0x8(%ebp),%eax
80101134:	89 50 04             	mov    %edx,0x4(%eax)
80101137:	8b 45 08             	mov    0x8(%ebp),%eax
8010113a:	8b 40 04             	mov    0x4(%eax),%eax
8010113d:	85 c0                	test   %eax,%eax
8010113f:	7e 15                	jle    80101156 <fileclose+0x5b>
    release(&ftable.lock);
80101141:	83 ec 0c             	sub    $0xc,%esp
80101144:	68 40 28 11 80       	push   $0x80112840
80101149:	e8 5f 55 00 00       	call   801066ad <release>
8010114e:	83 c4 10             	add    $0x10,%esp
80101151:	e9 8b 00 00 00       	jmp    801011e1 <fileclose+0xe6>
    return;
  }
  ff = *f;
80101156:	8b 45 08             	mov    0x8(%ebp),%eax
80101159:	8b 10                	mov    (%eax),%edx
8010115b:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010115e:	8b 50 04             	mov    0x4(%eax),%edx
80101161:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101164:	8b 50 08             	mov    0x8(%eax),%edx
80101167:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010116a:	8b 50 0c             	mov    0xc(%eax),%edx
8010116d:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101170:	8b 50 10             	mov    0x10(%eax),%edx
80101173:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101176:	8b 40 14             	mov    0x14(%eax),%eax
80101179:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010117c:	8b 45 08             	mov    0x8(%ebp),%eax
8010117f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101186:	8b 45 08             	mov    0x8(%ebp),%eax
80101189:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	68 40 28 11 80       	push   $0x80112840
80101197:	e8 11 55 00 00       	call   801066ad <release>
8010119c:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
8010119f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011a2:	83 f8 01             	cmp    $0x1,%eax
801011a5:	75 19                	jne    801011c0 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801011a7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801011ab:	0f be d0             	movsbl %al,%edx
801011ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011b1:	83 ec 08             	sub    $0x8,%esp
801011b4:	52                   	push   %edx
801011b5:	50                   	push   %eax
801011b6:	e8 83 30 00 00       	call   8010423e <pipeclose>
801011bb:	83 c4 10             	add    $0x10,%esp
801011be:	eb 21                	jmp    801011e1 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801011c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011c3:	83 f8 02             	cmp    $0x2,%eax
801011c6:	75 19                	jne    801011e1 <fileclose+0xe6>
    begin_op();
801011c8:	e8 2a 24 00 00       	call   801035f7 <begin_op>
    iput(ff.ip);
801011cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011d0:	83 ec 0c             	sub    $0xc,%esp
801011d3:	50                   	push   %eax
801011d4:	e8 0b 0a 00 00       	call   80101be4 <iput>
801011d9:	83 c4 10             	add    $0x10,%esp
    end_op();
801011dc:	e8 a2 24 00 00       	call   80103683 <end_op>
  }
}
801011e1:	c9                   	leave  
801011e2:	c3                   	ret    

801011e3 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011e3:	55                   	push   %ebp
801011e4:	89 e5                	mov    %esp,%ebp
801011e6:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011e9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ec:	8b 00                	mov    (%eax),%eax
801011ee:	83 f8 02             	cmp    $0x2,%eax
801011f1:	75 40                	jne    80101233 <filestat+0x50>
    ilock(f->ip);
801011f3:	8b 45 08             	mov    0x8(%ebp),%eax
801011f6:	8b 40 10             	mov    0x10(%eax),%eax
801011f9:	83 ec 0c             	sub    $0xc,%esp
801011fc:	50                   	push   %eax
801011fd:	e8 12 08 00 00       	call   80101a14 <ilock>
80101202:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101205:	8b 45 08             	mov    0x8(%ebp),%eax
80101208:	8b 40 10             	mov    0x10(%eax),%eax
8010120b:	83 ec 08             	sub    $0x8,%esp
8010120e:	ff 75 0c             	pushl  0xc(%ebp)
80101211:	50                   	push   %eax
80101212:	e8 25 0d 00 00       	call   80101f3c <stati>
80101217:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010121a:	8b 45 08             	mov    0x8(%ebp),%eax
8010121d:	8b 40 10             	mov    0x10(%eax),%eax
80101220:	83 ec 0c             	sub    $0xc,%esp
80101223:	50                   	push   %eax
80101224:	e8 49 09 00 00       	call   80101b72 <iunlock>
80101229:	83 c4 10             	add    $0x10,%esp
    return 0;
8010122c:	b8 00 00 00 00       	mov    $0x0,%eax
80101231:	eb 05                	jmp    80101238 <filestat+0x55>
  }
  return -1;
80101233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101238:	c9                   	leave  
80101239:	c3                   	ret    

8010123a <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010123a:	55                   	push   %ebp
8010123b:	89 e5                	mov    %esp,%ebp
8010123d:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101240:	8b 45 08             	mov    0x8(%ebp),%eax
80101243:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101247:	84 c0                	test   %al,%al
80101249:	75 0a                	jne    80101255 <fileread+0x1b>
    return -1;
8010124b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101250:	e9 9b 00 00 00       	jmp    801012f0 <fileread+0xb6>
  if(f->type == FD_PIPE)
80101255:	8b 45 08             	mov    0x8(%ebp),%eax
80101258:	8b 00                	mov    (%eax),%eax
8010125a:	83 f8 01             	cmp    $0x1,%eax
8010125d:	75 1a                	jne    80101279 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010125f:	8b 45 08             	mov    0x8(%ebp),%eax
80101262:	8b 40 0c             	mov    0xc(%eax),%eax
80101265:	83 ec 04             	sub    $0x4,%esp
80101268:	ff 75 10             	pushl  0x10(%ebp)
8010126b:	ff 75 0c             	pushl  0xc(%ebp)
8010126e:	50                   	push   %eax
8010126f:	e8 72 31 00 00       	call   801043e6 <piperead>
80101274:	83 c4 10             	add    $0x10,%esp
80101277:	eb 77                	jmp    801012f0 <fileread+0xb6>
  if(f->type == FD_INODE){
80101279:	8b 45 08             	mov    0x8(%ebp),%eax
8010127c:	8b 00                	mov    (%eax),%eax
8010127e:	83 f8 02             	cmp    $0x2,%eax
80101281:	75 60                	jne    801012e3 <fileread+0xa9>
    ilock(f->ip);
80101283:	8b 45 08             	mov    0x8(%ebp),%eax
80101286:	8b 40 10             	mov    0x10(%eax),%eax
80101289:	83 ec 0c             	sub    $0xc,%esp
8010128c:	50                   	push   %eax
8010128d:	e8 82 07 00 00       	call   80101a14 <ilock>
80101292:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101295:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101298:	8b 45 08             	mov    0x8(%ebp),%eax
8010129b:	8b 50 14             	mov    0x14(%eax),%edx
8010129e:	8b 45 08             	mov    0x8(%ebp),%eax
801012a1:	8b 40 10             	mov    0x10(%eax),%eax
801012a4:	51                   	push   %ecx
801012a5:	52                   	push   %edx
801012a6:	ff 75 0c             	pushl  0xc(%ebp)
801012a9:	50                   	push   %eax
801012aa:	e8 d3 0c 00 00       	call   80101f82 <readi>
801012af:	83 c4 10             	add    $0x10,%esp
801012b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012b9:	7e 11                	jle    801012cc <fileread+0x92>
      f->off += r;
801012bb:	8b 45 08             	mov    0x8(%ebp),%eax
801012be:	8b 50 14             	mov    0x14(%eax),%edx
801012c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c4:	01 c2                	add    %eax,%edx
801012c6:	8b 45 08             	mov    0x8(%ebp),%eax
801012c9:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012cc:	8b 45 08             	mov    0x8(%ebp),%eax
801012cf:	8b 40 10             	mov    0x10(%eax),%eax
801012d2:	83 ec 0c             	sub    $0xc,%esp
801012d5:	50                   	push   %eax
801012d6:	e8 97 08 00 00       	call   80101b72 <iunlock>
801012db:	83 c4 10             	add    $0x10,%esp
    return r;
801012de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012e1:	eb 0d                	jmp    801012f0 <fileread+0xb6>
  }
  panic("fileread");
801012e3:	83 ec 0c             	sub    $0xc,%esp
801012e6:	68 5f 9d 10 80       	push   $0x80109d5f
801012eb:	e8 76 f2 ff ff       	call   80100566 <panic>
}
801012f0:	c9                   	leave  
801012f1:	c3                   	ret    

801012f2 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012f2:	55                   	push   %ebp
801012f3:	89 e5                	mov    %esp,%ebp
801012f5:	53                   	push   %ebx
801012f6:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012f9:	8b 45 08             	mov    0x8(%ebp),%eax
801012fc:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101300:	84 c0                	test   %al,%al
80101302:	75 0a                	jne    8010130e <filewrite+0x1c>
    return -1;
80101304:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101309:	e9 1b 01 00 00       	jmp    80101429 <filewrite+0x137>
  if(f->type == FD_PIPE)
8010130e:	8b 45 08             	mov    0x8(%ebp),%eax
80101311:	8b 00                	mov    (%eax),%eax
80101313:	83 f8 01             	cmp    $0x1,%eax
80101316:	75 1d                	jne    80101335 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101318:	8b 45 08             	mov    0x8(%ebp),%eax
8010131b:	8b 40 0c             	mov    0xc(%eax),%eax
8010131e:	83 ec 04             	sub    $0x4,%esp
80101321:	ff 75 10             	pushl  0x10(%ebp)
80101324:	ff 75 0c             	pushl  0xc(%ebp)
80101327:	50                   	push   %eax
80101328:	e8 bb 2f 00 00       	call   801042e8 <pipewrite>
8010132d:	83 c4 10             	add    $0x10,%esp
80101330:	e9 f4 00 00 00       	jmp    80101429 <filewrite+0x137>
  if(f->type == FD_INODE){
80101335:	8b 45 08             	mov    0x8(%ebp),%eax
80101338:	8b 00                	mov    (%eax),%eax
8010133a:	83 f8 02             	cmp    $0x2,%eax
8010133d:	0f 85 d9 00 00 00    	jne    8010141c <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101343:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010134a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101351:	e9 a3 00 00 00       	jmp    801013f9 <filewrite+0x107>
      int n1 = n - i;
80101356:	8b 45 10             	mov    0x10(%ebp),%eax
80101359:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010135c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010135f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101362:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101365:	7e 06                	jle    8010136d <filewrite+0x7b>
        n1 = max;
80101367:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010136a:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010136d:	e8 85 22 00 00       	call   801035f7 <begin_op>
      ilock(f->ip);
80101372:	8b 45 08             	mov    0x8(%ebp),%eax
80101375:	8b 40 10             	mov    0x10(%eax),%eax
80101378:	83 ec 0c             	sub    $0xc,%esp
8010137b:	50                   	push   %eax
8010137c:	e8 93 06 00 00       	call   80101a14 <ilock>
80101381:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101384:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101387:	8b 45 08             	mov    0x8(%ebp),%eax
8010138a:	8b 50 14             	mov    0x14(%eax),%edx
8010138d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101390:	8b 45 0c             	mov    0xc(%ebp),%eax
80101393:	01 c3                	add    %eax,%ebx
80101395:	8b 45 08             	mov    0x8(%ebp),%eax
80101398:	8b 40 10             	mov    0x10(%eax),%eax
8010139b:	51                   	push   %ecx
8010139c:	52                   	push   %edx
8010139d:	53                   	push   %ebx
8010139e:	50                   	push   %eax
8010139f:	e8 35 0d 00 00       	call   801020d9 <writei>
801013a4:	83 c4 10             	add    $0x10,%esp
801013a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
801013aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013ae:	7e 11                	jle    801013c1 <filewrite+0xcf>
        f->off += r;
801013b0:	8b 45 08             	mov    0x8(%ebp),%eax
801013b3:	8b 50 14             	mov    0x14(%eax),%edx
801013b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013b9:	01 c2                	add    %eax,%edx
801013bb:	8b 45 08             	mov    0x8(%ebp),%eax
801013be:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013c1:	8b 45 08             	mov    0x8(%ebp),%eax
801013c4:	8b 40 10             	mov    0x10(%eax),%eax
801013c7:	83 ec 0c             	sub    $0xc,%esp
801013ca:	50                   	push   %eax
801013cb:	e8 a2 07 00 00       	call   80101b72 <iunlock>
801013d0:	83 c4 10             	add    $0x10,%esp
      end_op();
801013d3:	e8 ab 22 00 00       	call   80103683 <end_op>

      if(r < 0)
801013d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013dc:	78 29                	js     80101407 <filewrite+0x115>
        break;
      if(r != n1)
801013de:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013e4:	74 0d                	je     801013f3 <filewrite+0x101>
        panic("short filewrite");
801013e6:	83 ec 0c             	sub    $0xc,%esp
801013e9:	68 68 9d 10 80       	push   $0x80109d68
801013ee:	e8 73 f1 ff ff       	call   80100566 <panic>
      i += r;
801013f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013f6:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013fc:	3b 45 10             	cmp    0x10(%ebp),%eax
801013ff:	0f 8c 51 ff ff ff    	jl     80101356 <filewrite+0x64>
80101405:	eb 01                	jmp    80101408 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
80101407:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010140b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010140e:	75 05                	jne    80101415 <filewrite+0x123>
80101410:	8b 45 10             	mov    0x10(%ebp),%eax
80101413:	eb 14                	jmp    80101429 <filewrite+0x137>
80101415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010141a:	eb 0d                	jmp    80101429 <filewrite+0x137>
  }
  panic("filewrite");
8010141c:	83 ec 0c             	sub    $0xc,%esp
8010141f:	68 78 9d 10 80       	push   $0x80109d78
80101424:	e8 3d f1 ff ff       	call   80100566 <panic>
}
80101429:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010142c:	c9                   	leave  
8010142d:	c3                   	ret    

8010142e <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010142e:	55                   	push   %ebp
8010142f:	89 e5                	mov    %esp,%ebp
80101431:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101434:	8b 45 08             	mov    0x8(%ebp),%eax
80101437:	83 ec 08             	sub    $0x8,%esp
8010143a:	6a 01                	push   $0x1
8010143c:	50                   	push   %eax
8010143d:	e8 74 ed ff ff       	call   801001b6 <bread>
80101442:	83 c4 10             	add    $0x10,%esp
80101445:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101448:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010144b:	83 c0 18             	add    $0x18,%eax
8010144e:	83 ec 04             	sub    $0x4,%esp
80101451:	6a 1c                	push   $0x1c
80101453:	50                   	push   %eax
80101454:	ff 75 0c             	pushl  0xc(%ebp)
80101457:	e8 0c 55 00 00       	call   80106968 <memmove>
8010145c:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010145f:	83 ec 0c             	sub    $0xc,%esp
80101462:	ff 75 f4             	pushl  -0xc(%ebp)
80101465:	e8 c4 ed ff ff       	call   8010022e <brelse>
8010146a:	83 c4 10             	add    $0x10,%esp
}
8010146d:	90                   	nop
8010146e:	c9                   	leave  
8010146f:	c3                   	ret    

80101470 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101476:	8b 55 0c             	mov    0xc(%ebp),%edx
80101479:	8b 45 08             	mov    0x8(%ebp),%eax
8010147c:	83 ec 08             	sub    $0x8,%esp
8010147f:	52                   	push   %edx
80101480:	50                   	push   %eax
80101481:	e8 30 ed ff ff       	call   801001b6 <bread>
80101486:	83 c4 10             	add    $0x10,%esp
80101489:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010148c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010148f:	83 c0 18             	add    $0x18,%eax
80101492:	83 ec 04             	sub    $0x4,%esp
80101495:	68 00 02 00 00       	push   $0x200
8010149a:	6a 00                	push   $0x0
8010149c:	50                   	push   %eax
8010149d:	e8 07 54 00 00       	call   801068a9 <memset>
801014a2:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801014a5:	83 ec 0c             	sub    $0xc,%esp
801014a8:	ff 75 f4             	pushl  -0xc(%ebp)
801014ab:	e8 7f 23 00 00       	call   8010382f <log_write>
801014b0:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014b3:	83 ec 0c             	sub    $0xc,%esp
801014b6:	ff 75 f4             	pushl  -0xc(%ebp)
801014b9:	e8 70 ed ff ff       	call   8010022e <brelse>
801014be:	83 c4 10             	add    $0x10,%esp
}
801014c1:	90                   	nop
801014c2:	c9                   	leave  
801014c3:	c3                   	ret    

801014c4 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014c4:	55                   	push   %ebp
801014c5:	89 e5                	mov    %esp,%ebp
801014c7:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014ca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014d8:	e9 13 01 00 00       	jmp    801015f0 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801014dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014e0:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014e6:	85 c0                	test   %eax,%eax
801014e8:	0f 48 c2             	cmovs  %edx,%eax
801014eb:	c1 f8 0c             	sar    $0xc,%eax
801014ee:	89 c2                	mov    %eax,%edx
801014f0:	a1 58 32 11 80       	mov    0x80113258,%eax
801014f5:	01 d0                	add    %edx,%eax
801014f7:	83 ec 08             	sub    $0x8,%esp
801014fa:	50                   	push   %eax
801014fb:	ff 75 08             	pushl  0x8(%ebp)
801014fe:	e8 b3 ec ff ff       	call   801001b6 <bread>
80101503:	83 c4 10             	add    $0x10,%esp
80101506:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101509:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101510:	e9 a6 00 00 00       	jmp    801015bb <balloc+0xf7>
      m = 1 << (bi % 8);
80101515:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101518:	99                   	cltd   
80101519:	c1 ea 1d             	shr    $0x1d,%edx
8010151c:	01 d0                	add    %edx,%eax
8010151e:	83 e0 07             	and    $0x7,%eax
80101521:	29 d0                	sub    %edx,%eax
80101523:	ba 01 00 00 00       	mov    $0x1,%edx
80101528:	89 c1                	mov    %eax,%ecx
8010152a:	d3 e2                	shl    %cl,%edx
8010152c:	89 d0                	mov    %edx,%eax
8010152e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101531:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101534:	8d 50 07             	lea    0x7(%eax),%edx
80101537:	85 c0                	test   %eax,%eax
80101539:	0f 48 c2             	cmovs  %edx,%eax
8010153c:	c1 f8 03             	sar    $0x3,%eax
8010153f:	89 c2                	mov    %eax,%edx
80101541:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101544:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101549:	0f b6 c0             	movzbl %al,%eax
8010154c:	23 45 e8             	and    -0x18(%ebp),%eax
8010154f:	85 c0                	test   %eax,%eax
80101551:	75 64                	jne    801015b7 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
80101553:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101556:	8d 50 07             	lea    0x7(%eax),%edx
80101559:	85 c0                	test   %eax,%eax
8010155b:	0f 48 c2             	cmovs  %edx,%eax
8010155e:	c1 f8 03             	sar    $0x3,%eax
80101561:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101564:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101569:	89 d1                	mov    %edx,%ecx
8010156b:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010156e:	09 ca                	or     %ecx,%edx
80101570:	89 d1                	mov    %edx,%ecx
80101572:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101575:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101579:	83 ec 0c             	sub    $0xc,%esp
8010157c:	ff 75 ec             	pushl  -0x14(%ebp)
8010157f:	e8 ab 22 00 00       	call   8010382f <log_write>
80101584:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101587:	83 ec 0c             	sub    $0xc,%esp
8010158a:	ff 75 ec             	pushl  -0x14(%ebp)
8010158d:	e8 9c ec ff ff       	call   8010022e <brelse>
80101592:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101595:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159b:	01 c2                	add    %eax,%edx
8010159d:	8b 45 08             	mov    0x8(%ebp),%eax
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	52                   	push   %edx
801015a4:	50                   	push   %eax
801015a5:	e8 c6 fe ff ff       	call   80101470 <bzero>
801015aa:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b3:	01 d0                	add    %edx,%eax
801015b5:	eb 57                	jmp    8010160e <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015bb:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015c2:	7f 17                	jg     801015db <balloc+0x117>
801015c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ca:	01 d0                	add    %edx,%eax
801015cc:	89 c2                	mov    %eax,%edx
801015ce:	a1 40 32 11 80       	mov    0x80113240,%eax
801015d3:	39 c2                	cmp    %eax,%edx
801015d5:	0f 82 3a ff ff ff    	jb     80101515 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015db:	83 ec 0c             	sub    $0xc,%esp
801015de:	ff 75 ec             	pushl  -0x14(%ebp)
801015e1:	e8 48 ec ff ff       	call   8010022e <brelse>
801015e6:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015e9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015f0:	8b 15 40 32 11 80    	mov    0x80113240,%edx
801015f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f9:	39 c2                	cmp    %eax,%edx
801015fb:	0f 87 dc fe ff ff    	ja     801014dd <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101601:	83 ec 0c             	sub    $0xc,%esp
80101604:	68 84 9d 10 80       	push   $0x80109d84
80101609:	e8 58 ef ff ff       	call   80100566 <panic>
}
8010160e:	c9                   	leave  
8010160f:	c3                   	ret    

80101610 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101616:	83 ec 08             	sub    $0x8,%esp
80101619:	68 40 32 11 80       	push   $0x80113240
8010161e:	ff 75 08             	pushl  0x8(%ebp)
80101621:	e8 08 fe ff ff       	call   8010142e <readsb>
80101626:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101629:	8b 45 0c             	mov    0xc(%ebp),%eax
8010162c:	c1 e8 0c             	shr    $0xc,%eax
8010162f:	89 c2                	mov    %eax,%edx
80101631:	a1 58 32 11 80       	mov    0x80113258,%eax
80101636:	01 c2                	add    %eax,%edx
80101638:	8b 45 08             	mov    0x8(%ebp),%eax
8010163b:	83 ec 08             	sub    $0x8,%esp
8010163e:	52                   	push   %edx
8010163f:	50                   	push   %eax
80101640:	e8 71 eb ff ff       	call   801001b6 <bread>
80101645:	83 c4 10             	add    $0x10,%esp
80101648:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010164b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010164e:	25 ff 0f 00 00       	and    $0xfff,%eax
80101653:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101656:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101659:	99                   	cltd   
8010165a:	c1 ea 1d             	shr    $0x1d,%edx
8010165d:	01 d0                	add    %edx,%eax
8010165f:	83 e0 07             	and    $0x7,%eax
80101662:	29 d0                	sub    %edx,%eax
80101664:	ba 01 00 00 00       	mov    $0x1,%edx
80101669:	89 c1                	mov    %eax,%ecx
8010166b:	d3 e2                	shl    %cl,%edx
8010166d:	89 d0                	mov    %edx,%eax
8010166f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101672:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101675:	8d 50 07             	lea    0x7(%eax),%edx
80101678:	85 c0                	test   %eax,%eax
8010167a:	0f 48 c2             	cmovs  %edx,%eax
8010167d:	c1 f8 03             	sar    $0x3,%eax
80101680:	89 c2                	mov    %eax,%edx
80101682:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101685:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010168a:	0f b6 c0             	movzbl %al,%eax
8010168d:	23 45 ec             	and    -0x14(%ebp),%eax
80101690:	85 c0                	test   %eax,%eax
80101692:	75 0d                	jne    801016a1 <bfree+0x91>
    panic("freeing free block");
80101694:	83 ec 0c             	sub    $0xc,%esp
80101697:	68 9a 9d 10 80       	push   $0x80109d9a
8010169c:	e8 c5 ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801016a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a4:	8d 50 07             	lea    0x7(%eax),%edx
801016a7:	85 c0                	test   %eax,%eax
801016a9:	0f 48 c2             	cmovs  %edx,%eax
801016ac:	c1 f8 03             	sar    $0x3,%eax
801016af:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016b2:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801016b7:	89 d1                	mov    %edx,%ecx
801016b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016bc:	f7 d2                	not    %edx
801016be:	21 ca                	and    %ecx,%edx
801016c0:	89 d1                	mov    %edx,%ecx
801016c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016c5:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801016c9:	83 ec 0c             	sub    $0xc,%esp
801016cc:	ff 75 f4             	pushl  -0xc(%ebp)
801016cf:	e8 5b 21 00 00       	call   8010382f <log_write>
801016d4:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016d7:	83 ec 0c             	sub    $0xc,%esp
801016da:	ff 75 f4             	pushl  -0xc(%ebp)
801016dd:	e8 4c eb ff ff       	call   8010022e <brelse>
801016e2:	83 c4 10             	add    $0x10,%esp
}
801016e5:	90                   	nop
801016e6:	c9                   	leave  
801016e7:	c3                   	ret    

801016e8 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016e8:	55                   	push   %ebp
801016e9:	89 e5                	mov    %esp,%ebp
801016eb:	57                   	push   %edi
801016ec:	56                   	push   %esi
801016ed:	53                   	push   %ebx
801016ee:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801016f1:	83 ec 08             	sub    $0x8,%esp
801016f4:	68 ad 9d 10 80       	push   $0x80109dad
801016f9:	68 60 32 11 80       	push   $0x80113260
801016fe:	e8 21 4f 00 00       	call   80106624 <initlock>
80101703:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101706:	83 ec 08             	sub    $0x8,%esp
80101709:	68 40 32 11 80       	push   $0x80113240
8010170e:	ff 75 08             	pushl  0x8(%ebp)
80101711:	e8 18 fd ff ff       	call   8010142e <readsb>
80101716:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101719:	a1 58 32 11 80       	mov    0x80113258,%eax
8010171e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101721:	8b 3d 54 32 11 80    	mov    0x80113254,%edi
80101727:	8b 35 50 32 11 80    	mov    0x80113250,%esi
8010172d:	8b 1d 4c 32 11 80    	mov    0x8011324c,%ebx
80101733:	8b 0d 48 32 11 80    	mov    0x80113248,%ecx
80101739:	8b 15 44 32 11 80    	mov    0x80113244,%edx
8010173f:	a1 40 32 11 80       	mov    0x80113240,%eax
80101744:	ff 75 e4             	pushl  -0x1c(%ebp)
80101747:	57                   	push   %edi
80101748:	56                   	push   %esi
80101749:	53                   	push   %ebx
8010174a:	51                   	push   %ecx
8010174b:	52                   	push   %edx
8010174c:	50                   	push   %eax
8010174d:	68 b4 9d 10 80       	push   $0x80109db4
80101752:	e8 6f ec ff ff       	call   801003c6 <cprintf>
80101757:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
8010175a:	90                   	nop
8010175b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010175e:	5b                   	pop    %ebx
8010175f:	5e                   	pop    %esi
80101760:	5f                   	pop    %edi
80101761:	5d                   	pop    %ebp
80101762:	c3                   	ret    

80101763 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101763:	55                   	push   %ebp
80101764:	89 e5                	mov    %esp,%ebp
80101766:	83 ec 28             	sub    $0x28,%esp
80101769:	8b 45 0c             	mov    0xc(%ebp),%eax
8010176c:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101770:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101777:	e9 9e 00 00 00       	jmp    8010181a <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
8010177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177f:	c1 e8 03             	shr    $0x3,%eax
80101782:	89 c2                	mov    %eax,%edx
80101784:	a1 54 32 11 80       	mov    0x80113254,%eax
80101789:	01 d0                	add    %edx,%eax
8010178b:	83 ec 08             	sub    $0x8,%esp
8010178e:	50                   	push   %eax
8010178f:	ff 75 08             	pushl  0x8(%ebp)
80101792:	e8 1f ea ff ff       	call   801001b6 <bread>
80101797:	83 c4 10             	add    $0x10,%esp
8010179a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a0:	8d 50 18             	lea    0x18(%eax),%edx
801017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a6:	83 e0 07             	and    $0x7,%eax
801017a9:	c1 e0 06             	shl    $0x6,%eax
801017ac:	01 d0                	add    %edx,%eax
801017ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017b4:	0f b7 00             	movzwl (%eax),%eax
801017b7:	66 85 c0             	test   %ax,%ax
801017ba:	75 4c                	jne    80101808 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017bc:	83 ec 04             	sub    $0x4,%esp
801017bf:	6a 40                	push   $0x40
801017c1:	6a 00                	push   $0x0
801017c3:	ff 75 ec             	pushl  -0x14(%ebp)
801017c6:	e8 de 50 00 00       	call   801068a9 <memset>
801017cb:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017d1:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017d5:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017d8:	83 ec 0c             	sub    $0xc,%esp
801017db:	ff 75 f0             	pushl  -0x10(%ebp)
801017de:	e8 4c 20 00 00       	call   8010382f <log_write>
801017e3:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	ff 75 f0             	pushl  -0x10(%ebp)
801017ec:	e8 3d ea ff ff       	call   8010022e <brelse>
801017f1:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f7:	83 ec 08             	sub    $0x8,%esp
801017fa:	50                   	push   %eax
801017fb:	ff 75 08             	pushl  0x8(%ebp)
801017fe:	e8 f8 00 00 00       	call   801018fb <iget>
80101803:	83 c4 10             	add    $0x10,%esp
80101806:	eb 30                	jmp    80101838 <ialloc+0xd5>
    }
    brelse(bp);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	ff 75 f0             	pushl  -0x10(%ebp)
8010180e:	e8 1b ea ff ff       	call   8010022e <brelse>
80101813:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101816:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010181a:	8b 15 48 32 11 80    	mov    0x80113248,%edx
80101820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101823:	39 c2                	cmp    %eax,%edx
80101825:	0f 87 51 ff ff ff    	ja     8010177c <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010182b:	83 ec 0c             	sub    $0xc,%esp
8010182e:	68 07 9e 10 80       	push   $0x80109e07
80101833:	e8 2e ed ff ff       	call   80100566 <panic>
}
80101838:	c9                   	leave  
80101839:	c3                   	ret    

8010183a <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010183a:	55                   	push   %ebp
8010183b:	89 e5                	mov    %esp,%ebp
8010183d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101840:	8b 45 08             	mov    0x8(%ebp),%eax
80101843:	8b 40 04             	mov    0x4(%eax),%eax
80101846:	c1 e8 03             	shr    $0x3,%eax
80101849:	89 c2                	mov    %eax,%edx
8010184b:	a1 54 32 11 80       	mov    0x80113254,%eax
80101850:	01 c2                	add    %eax,%edx
80101852:	8b 45 08             	mov    0x8(%ebp),%eax
80101855:	8b 00                	mov    (%eax),%eax
80101857:	83 ec 08             	sub    $0x8,%esp
8010185a:	52                   	push   %edx
8010185b:	50                   	push   %eax
8010185c:	e8 55 e9 ff ff       	call   801001b6 <bread>
80101861:	83 c4 10             	add    $0x10,%esp
80101864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186a:	8d 50 18             	lea    0x18(%eax),%edx
8010186d:	8b 45 08             	mov    0x8(%ebp),%eax
80101870:	8b 40 04             	mov    0x4(%eax),%eax
80101873:	83 e0 07             	and    $0x7,%eax
80101876:	c1 e0 06             	shl    $0x6,%eax
80101879:	01 d0                	add    %edx,%eax
8010187b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010187e:	8b 45 08             	mov    0x8(%ebp),%eax
80101881:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101885:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101888:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010188b:	8b 45 08             	mov    0x8(%ebp),%eax
8010188e:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101892:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101895:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101899:	8b 45 08             	mov    0x8(%ebp),%eax
8010189c:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801018a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a3:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018a7:	8b 45 08             	mov    0x8(%ebp),%eax
801018aa:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801018ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b1:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018b5:	8b 45 08             	mov    0x8(%ebp),%eax
801018b8:	8b 50 18             	mov    0x18(%eax),%edx
801018bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018be:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018c1:	8b 45 08             	mov    0x8(%ebp),%eax
801018c4:	8d 50 1c             	lea    0x1c(%eax),%edx
801018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ca:	83 c0 0c             	add    $0xc,%eax
801018cd:	83 ec 04             	sub    $0x4,%esp
801018d0:	6a 34                	push   $0x34
801018d2:	52                   	push   %edx
801018d3:	50                   	push   %eax
801018d4:	e8 8f 50 00 00       	call   80106968 <memmove>
801018d9:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	ff 75 f4             	pushl  -0xc(%ebp)
801018e2:	e8 48 1f 00 00       	call   8010382f <log_write>
801018e7:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018ea:	83 ec 0c             	sub    $0xc,%esp
801018ed:	ff 75 f4             	pushl  -0xc(%ebp)
801018f0:	e8 39 e9 ff ff       	call   8010022e <brelse>
801018f5:	83 c4 10             	add    $0x10,%esp
}
801018f8:	90                   	nop
801018f9:	c9                   	leave  
801018fa:	c3                   	ret    

801018fb <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018fb:	55                   	push   %ebp
801018fc:	89 e5                	mov    %esp,%ebp
801018fe:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101901:	83 ec 0c             	sub    $0xc,%esp
80101904:	68 60 32 11 80       	push   $0x80113260
80101909:	e8 38 4d 00 00       	call   80106646 <acquire>
8010190e:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101911:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101918:	c7 45 f4 94 32 11 80 	movl   $0x80113294,-0xc(%ebp)
8010191f:	eb 5d                	jmp    8010197e <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101924:	8b 40 08             	mov    0x8(%eax),%eax
80101927:	85 c0                	test   %eax,%eax
80101929:	7e 39                	jle    80101964 <iget+0x69>
8010192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192e:	8b 00                	mov    (%eax),%eax
80101930:	3b 45 08             	cmp    0x8(%ebp),%eax
80101933:	75 2f                	jne    80101964 <iget+0x69>
80101935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101938:	8b 40 04             	mov    0x4(%eax),%eax
8010193b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010193e:	75 24                	jne    80101964 <iget+0x69>
      ip->ref++;
80101940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101943:	8b 40 08             	mov    0x8(%eax),%eax
80101946:	8d 50 01             	lea    0x1(%eax),%edx
80101949:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010194c:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010194f:	83 ec 0c             	sub    $0xc,%esp
80101952:	68 60 32 11 80       	push   $0x80113260
80101957:	e8 51 4d 00 00       	call   801066ad <release>
8010195c:	83 c4 10             	add    $0x10,%esp
      return ip;
8010195f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101962:	eb 74                	jmp    801019d8 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101964:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101968:	75 10                	jne    8010197a <iget+0x7f>
8010196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196d:	8b 40 08             	mov    0x8(%eax),%eax
80101970:	85 c0                	test   %eax,%eax
80101972:	75 06                	jne    8010197a <iget+0x7f>
      empty = ip;
80101974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101977:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010197a:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010197e:	81 7d f4 34 42 11 80 	cmpl   $0x80114234,-0xc(%ebp)
80101985:	72 9a                	jb     80101921 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101987:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010198b:	75 0d                	jne    8010199a <iget+0x9f>
    panic("iget: no inodes");
8010198d:	83 ec 0c             	sub    $0xc,%esp
80101990:	68 19 9e 10 80       	push   $0x80109e19
80101995:	e8 cc eb ff ff       	call   80100566 <panic>

  ip = empty;
8010199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801019a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a3:	8b 55 08             	mov    0x8(%ebp),%edx
801019a6:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801019ae:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801019bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801019c5:	83 ec 0c             	sub    $0xc,%esp
801019c8:	68 60 32 11 80       	push   $0x80113260
801019cd:	e8 db 4c 00 00       	call   801066ad <release>
801019d2:	83 c4 10             	add    $0x10,%esp

  return ip;
801019d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019d8:	c9                   	leave  
801019d9:	c3                   	ret    

801019da <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019da:	55                   	push   %ebp
801019db:	89 e5                	mov    %esp,%ebp
801019dd:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	68 60 32 11 80       	push   $0x80113260
801019e8:	e8 59 4c 00 00       	call   80106646 <acquire>
801019ed:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019f0:	8b 45 08             	mov    0x8(%ebp),%eax
801019f3:	8b 40 08             	mov    0x8(%eax),%eax
801019f6:	8d 50 01             	lea    0x1(%eax),%edx
801019f9:	8b 45 08             	mov    0x8(%ebp),%eax
801019fc:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019ff:	83 ec 0c             	sub    $0xc,%esp
80101a02:	68 60 32 11 80       	push   $0x80113260
80101a07:	e8 a1 4c 00 00       	call   801066ad <release>
80101a0c:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a12:	c9                   	leave  
80101a13:	c3                   	ret    

80101a14 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a1e:	74 0a                	je     80101a2a <ilock+0x16>
80101a20:	8b 45 08             	mov    0x8(%ebp),%eax
80101a23:	8b 40 08             	mov    0x8(%eax),%eax
80101a26:	85 c0                	test   %eax,%eax
80101a28:	7f 0d                	jg     80101a37 <ilock+0x23>
    panic("ilock");
80101a2a:	83 ec 0c             	sub    $0xc,%esp
80101a2d:	68 29 9e 10 80       	push   $0x80109e29
80101a32:	e8 2f eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a37:	83 ec 0c             	sub    $0xc,%esp
80101a3a:	68 60 32 11 80       	push   $0x80113260
80101a3f:	e8 02 4c 00 00       	call   80106646 <acquire>
80101a44:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a47:	eb 13                	jmp    80101a5c <ilock+0x48>
    sleep(ip, &icache.lock);
80101a49:	83 ec 08             	sub    $0x8,%esp
80101a4c:	68 60 32 11 80       	push   $0x80113260
80101a51:	ff 75 08             	pushl  0x8(%ebp)
80101a54:	e8 5f 39 00 00       	call   801053b8 <sleep>
80101a59:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a62:	83 e0 01             	and    $0x1,%eax
80101a65:	85 c0                	test   %eax,%eax
80101a67:	75 e0                	jne    80101a49 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 40 0c             	mov    0xc(%eax),%eax
80101a6f:	83 c8 01             	or     $0x1,%eax
80101a72:	89 c2                	mov    %eax,%edx
80101a74:	8b 45 08             	mov    0x8(%ebp),%eax
80101a77:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a7a:	83 ec 0c             	sub    $0xc,%esp
80101a7d:	68 60 32 11 80       	push   $0x80113260
80101a82:	e8 26 4c 00 00       	call   801066ad <release>
80101a87:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8d:	8b 40 0c             	mov    0xc(%eax),%eax
80101a90:	83 e0 02             	and    $0x2,%eax
80101a93:	85 c0                	test   %eax,%eax
80101a95:	0f 85 d4 00 00 00    	jne    80101b6f <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9e:	8b 40 04             	mov    0x4(%eax),%eax
80101aa1:	c1 e8 03             	shr    $0x3,%eax
80101aa4:	89 c2                	mov    %eax,%edx
80101aa6:	a1 54 32 11 80       	mov    0x80113254,%eax
80101aab:	01 c2                	add    %eax,%edx
80101aad:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab0:	8b 00                	mov    (%eax),%eax
80101ab2:	83 ec 08             	sub    $0x8,%esp
80101ab5:	52                   	push   %edx
80101ab6:	50                   	push   %eax
80101ab7:	e8 fa e6 ff ff       	call   801001b6 <bread>
80101abc:	83 c4 10             	add    $0x10,%esp
80101abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ac5:	8d 50 18             	lea    0x18(%eax),%edx
80101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80101acb:	8b 40 04             	mov    0x4(%eax),%eax
80101ace:	83 e0 07             	and    $0x7,%eax
80101ad1:	c1 e0 06             	shl    $0x6,%eax
80101ad4:	01 d0                	add    %edx,%eax
80101ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101adc:	0f b7 10             	movzwl (%eax),%edx
80101adf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae2:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae9:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101aed:	8b 45 08             	mov    0x8(%ebp),%eax
80101af0:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af7:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101afb:	8b 45 08             	mov    0x8(%ebp),%eax
80101afe:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b05:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b13:	8b 50 08             	mov    0x8(%eax),%edx
80101b16:	8b 45 08             	mov    0x8(%ebp),%eax
80101b19:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b1f:	8d 50 0c             	lea    0xc(%eax),%edx
80101b22:	8b 45 08             	mov    0x8(%ebp),%eax
80101b25:	83 c0 1c             	add    $0x1c,%eax
80101b28:	83 ec 04             	sub    $0x4,%esp
80101b2b:	6a 34                	push   $0x34
80101b2d:	52                   	push   %edx
80101b2e:	50                   	push   %eax
80101b2f:	e8 34 4e 00 00       	call   80106968 <memmove>
80101b34:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b37:	83 ec 0c             	sub    $0xc,%esp
80101b3a:	ff 75 f4             	pushl  -0xc(%ebp)
80101b3d:	e8 ec e6 ff ff       	call   8010022e <brelse>
80101b42:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101b45:	8b 45 08             	mov    0x8(%ebp),%eax
80101b48:	8b 40 0c             	mov    0xc(%eax),%eax
80101b4b:	83 c8 02             	or     $0x2,%eax
80101b4e:	89 c2                	mov    %eax,%edx
80101b50:	8b 45 08             	mov    0x8(%ebp),%eax
80101b53:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101b56:	8b 45 08             	mov    0x8(%ebp),%eax
80101b59:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b5d:	66 85 c0             	test   %ax,%ax
80101b60:	75 0d                	jne    80101b6f <ilock+0x15b>
      panic("ilock: no type");
80101b62:	83 ec 0c             	sub    $0xc,%esp
80101b65:	68 2f 9e 10 80       	push   $0x80109e2f
80101b6a:	e8 f7 e9 ff ff       	call   80100566 <panic>
  }
}
80101b6f:	90                   	nop
80101b70:	c9                   	leave  
80101b71:	c3                   	ret    

80101b72 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b72:	55                   	push   %ebp
80101b73:	89 e5                	mov    %esp,%ebp
80101b75:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b7c:	74 17                	je     80101b95 <iunlock+0x23>
80101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b81:	8b 40 0c             	mov    0xc(%eax),%eax
80101b84:	83 e0 01             	and    $0x1,%eax
80101b87:	85 c0                	test   %eax,%eax
80101b89:	74 0a                	je     80101b95 <iunlock+0x23>
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	8b 40 08             	mov    0x8(%eax),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	7f 0d                	jg     80101ba2 <iunlock+0x30>
    panic("iunlock");
80101b95:	83 ec 0c             	sub    $0xc,%esp
80101b98:	68 3e 9e 10 80       	push   $0x80109e3e
80101b9d:	e8 c4 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101ba2:	83 ec 0c             	sub    $0xc,%esp
80101ba5:	68 60 32 11 80       	push   $0x80113260
80101baa:	e8 97 4a 00 00       	call   80106646 <acquire>
80101baf:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb5:	8b 40 0c             	mov    0xc(%eax),%eax
80101bb8:	83 e0 fe             	and    $0xfffffffe,%eax
80101bbb:	89 c2                	mov    %eax,%edx
80101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc0:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101bc3:	83 ec 0c             	sub    $0xc,%esp
80101bc6:	ff 75 08             	pushl  0x8(%ebp)
80101bc9:	e8 c3 39 00 00       	call   80105591 <wakeup>
80101bce:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bd1:	83 ec 0c             	sub    $0xc,%esp
80101bd4:	68 60 32 11 80       	push   $0x80113260
80101bd9:	e8 cf 4a 00 00       	call   801066ad <release>
80101bde:	83 c4 10             	add    $0x10,%esp
}
80101be1:	90                   	nop
80101be2:	c9                   	leave  
80101be3:	c3                   	ret    

80101be4 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101be4:	55                   	push   %ebp
80101be5:	89 e5                	mov    %esp,%ebp
80101be7:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101bea:	83 ec 0c             	sub    $0xc,%esp
80101bed:	68 60 32 11 80       	push   $0x80113260
80101bf2:	e8 4f 4a 00 00       	call   80106646 <acquire>
80101bf7:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfd:	8b 40 08             	mov    0x8(%eax),%eax
80101c00:	83 f8 01             	cmp    $0x1,%eax
80101c03:	0f 85 a9 00 00 00    	jne    80101cb2 <iput+0xce>
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 40 0c             	mov    0xc(%eax),%eax
80101c0f:	83 e0 02             	and    $0x2,%eax
80101c12:	85 c0                	test   %eax,%eax
80101c14:	0f 84 98 00 00 00    	je     80101cb2 <iput+0xce>
80101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101c21:	66 85 c0             	test   %ax,%ax
80101c24:	0f 85 88 00 00 00    	jne    80101cb2 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2d:	8b 40 0c             	mov    0xc(%eax),%eax
80101c30:	83 e0 01             	and    $0x1,%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 0d                	je     80101c44 <iput+0x60>
      panic("iput busy");
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	68 46 9e 10 80       	push   $0x80109e46
80101c3f:	e8 22 e9 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101c44:	8b 45 08             	mov    0x8(%ebp),%eax
80101c47:	8b 40 0c             	mov    0xc(%eax),%eax
80101c4a:	83 c8 01             	or     $0x1,%eax
80101c4d:	89 c2                	mov    %eax,%edx
80101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c52:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101c55:	83 ec 0c             	sub    $0xc,%esp
80101c58:	68 60 32 11 80       	push   $0x80113260
80101c5d:	e8 4b 4a 00 00       	call   801066ad <release>
80101c62:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c65:	83 ec 0c             	sub    $0xc,%esp
80101c68:	ff 75 08             	pushl  0x8(%ebp)
80101c6b:	e8 a8 01 00 00       	call   80101e18 <itrunc>
80101c70:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c73:	8b 45 08             	mov    0x8(%ebp),%eax
80101c76:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	ff 75 08             	pushl  0x8(%ebp)
80101c82:	e8 b3 fb ff ff       	call   8010183a <iupdate>
80101c87:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c8a:	83 ec 0c             	sub    $0xc,%esp
80101c8d:	68 60 32 11 80       	push   $0x80113260
80101c92:	e8 af 49 00 00       	call   80106646 <acquire>
80101c97:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ca4:	83 ec 0c             	sub    $0xc,%esp
80101ca7:	ff 75 08             	pushl  0x8(%ebp)
80101caa:	e8 e2 38 00 00       	call   80105591 <wakeup>
80101caf:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb5:	8b 40 08             	mov    0x8(%eax),%eax
80101cb8:	8d 50 ff             	lea    -0x1(%eax),%edx
80101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbe:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101cc1:	83 ec 0c             	sub    $0xc,%esp
80101cc4:	68 60 32 11 80       	push   $0x80113260
80101cc9:	e8 df 49 00 00       	call   801066ad <release>
80101cce:	83 c4 10             	add    $0x10,%esp
}
80101cd1:	90                   	nop
80101cd2:	c9                   	leave  
80101cd3:	c3                   	ret    

80101cd4 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101cd4:	55                   	push   %ebp
80101cd5:	89 e5                	mov    %esp,%ebp
80101cd7:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101cda:	83 ec 0c             	sub    $0xc,%esp
80101cdd:	ff 75 08             	pushl  0x8(%ebp)
80101ce0:	e8 8d fe ff ff       	call   80101b72 <iunlock>
80101ce5:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101ce8:	83 ec 0c             	sub    $0xc,%esp
80101ceb:	ff 75 08             	pushl  0x8(%ebp)
80101cee:	e8 f1 fe ff ff       	call   80101be4 <iput>
80101cf3:	83 c4 10             	add    $0x10,%esp
}
80101cf6:	90                   	nop
80101cf7:	c9                   	leave  
80101cf8:	c3                   	ret    

80101cf9 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101cf9:	55                   	push   %ebp
80101cfa:	89 e5                	mov    %esp,%ebp
80101cfc:	53                   	push   %ebx
80101cfd:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d00:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101d04:	77 42                	ja     80101d48 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101d06:	8b 45 08             	mov    0x8(%ebp),%eax
80101d09:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d0c:	83 c2 04             	add    $0x4,%edx
80101d0f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d1a:	75 24                	jne    80101d40 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1f:	8b 00                	mov    (%eax),%eax
80101d21:	83 ec 0c             	sub    $0xc,%esp
80101d24:	50                   	push   %eax
80101d25:	e8 9a f7 ff ff       	call   801014c4 <balloc>
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d30:	8b 45 08             	mov    0x8(%ebp),%eax
80101d33:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d36:	8d 4a 04             	lea    0x4(%edx),%ecx
80101d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d3c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d43:	e9 cb 00 00 00       	jmp    80101e13 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101d48:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d4c:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d50:	0f 87 b0 00 00 00    	ja     80101e06 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d56:	8b 45 08             	mov    0x8(%ebp),%eax
80101d59:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d63:	75 1d                	jne    80101d82 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d65:	8b 45 08             	mov    0x8(%ebp),%eax
80101d68:	8b 00                	mov    (%eax),%eax
80101d6a:	83 ec 0c             	sub    $0xc,%esp
80101d6d:	50                   	push   %eax
80101d6e:	e8 51 f7 ff ff       	call   801014c4 <balloc>
80101d73:	83 c4 10             	add    $0x10,%esp
80101d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d79:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d7f:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d82:	8b 45 08             	mov    0x8(%ebp),%eax
80101d85:	8b 00                	mov    (%eax),%eax
80101d87:	83 ec 08             	sub    $0x8,%esp
80101d8a:	ff 75 f4             	pushl  -0xc(%ebp)
80101d8d:	50                   	push   %eax
80101d8e:	e8 23 e4 ff ff       	call   801001b6 <bread>
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d9c:	83 c0 18             	add    $0x18,%eax
80101d9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101da2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101da5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101daf:	01 d0                	add    %edx,%eax
80101db1:	8b 00                	mov    (%eax),%eax
80101db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101dba:	75 37                	jne    80101df3 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dc9:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcf:	8b 00                	mov    (%eax),%eax
80101dd1:	83 ec 0c             	sub    $0xc,%esp
80101dd4:	50                   	push   %eax
80101dd5:	e8 ea f6 ff ff       	call   801014c4 <balloc>
80101dda:	83 c4 10             	add    $0x10,%esp
80101ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101de3:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101de5:	83 ec 0c             	sub    $0xc,%esp
80101de8:	ff 75 f0             	pushl  -0x10(%ebp)
80101deb:	e8 3f 1a 00 00       	call   8010382f <log_write>
80101df0:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101df3:	83 ec 0c             	sub    $0xc,%esp
80101df6:	ff 75 f0             	pushl  -0x10(%ebp)
80101df9:	e8 30 e4 ff ff       	call   8010022e <brelse>
80101dfe:	83 c4 10             	add    $0x10,%esp
    return addr;
80101e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e04:	eb 0d                	jmp    80101e13 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	68 50 9e 10 80       	push   $0x80109e50
80101e0e:	e8 53 e7 ff ff       	call   80100566 <panic>
}
80101e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e16:	c9                   	leave  
80101e17:	c3                   	ret    

80101e18 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e18:	55                   	push   %ebp
80101e19:	89 e5                	mov    %esp,%ebp
80101e1b:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e25:	eb 45                	jmp    80101e6c <itrunc+0x54>
    if(ip->addrs[i]){
80101e27:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e2d:	83 c2 04             	add    $0x4,%edx
80101e30:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e34:	85 c0                	test   %eax,%eax
80101e36:	74 30                	je     80101e68 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101e38:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e3e:	83 c2 04             	add    $0x4,%edx
80101e41:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e45:	8b 55 08             	mov    0x8(%ebp),%edx
80101e48:	8b 12                	mov    (%edx),%edx
80101e4a:	83 ec 08             	sub    $0x8,%esp
80101e4d:	50                   	push   %eax
80101e4e:	52                   	push   %edx
80101e4f:	e8 bc f7 ff ff       	call   80101610 <bfree>
80101e54:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e57:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e5d:	83 c2 04             	add    $0x4,%edx
80101e60:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e67:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e6c:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e70:	7e b5                	jle    80101e27 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101e72:	8b 45 08             	mov    0x8(%ebp),%eax
80101e75:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e78:	85 c0                	test   %eax,%eax
80101e7a:	0f 84 a1 00 00 00    	je     80101f21 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e80:	8b 45 08             	mov    0x8(%ebp),%eax
80101e83:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e86:	8b 45 08             	mov    0x8(%ebp),%eax
80101e89:	8b 00                	mov    (%eax),%eax
80101e8b:	83 ec 08             	sub    $0x8,%esp
80101e8e:	52                   	push   %edx
80101e8f:	50                   	push   %eax
80101e90:	e8 21 e3 ff ff       	call   801001b6 <bread>
80101e95:	83 c4 10             	add    $0x10,%esp
80101e98:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e9e:	83 c0 18             	add    $0x18,%eax
80101ea1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ea4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101eab:	eb 3c                	jmp    80101ee9 <itrunc+0xd1>
      if(a[j])
80101ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eb0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101eb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101eba:	01 d0                	add    %edx,%eax
80101ebc:	8b 00                	mov    (%eax),%eax
80101ebe:	85 c0                	test   %eax,%eax
80101ec0:	74 23                	je     80101ee5 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ecc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ecf:	01 d0                	add    %edx,%eax
80101ed1:	8b 00                	mov    (%eax),%eax
80101ed3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed6:	8b 12                	mov    (%edx),%edx
80101ed8:	83 ec 08             	sub    $0x8,%esp
80101edb:	50                   	push   %eax
80101edc:	52                   	push   %edx
80101edd:	e8 2e f7 ff ff       	call   80101610 <bfree>
80101ee2:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ee5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eec:	83 f8 7f             	cmp    $0x7f,%eax
80101eef:	76 bc                	jbe    80101ead <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ef1:	83 ec 0c             	sub    $0xc,%esp
80101ef4:	ff 75 ec             	pushl  -0x14(%ebp)
80101ef7:	e8 32 e3 ff ff       	call   8010022e <brelse>
80101efc:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101eff:	8b 45 08             	mov    0x8(%ebp),%eax
80101f02:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f05:	8b 55 08             	mov    0x8(%ebp),%edx
80101f08:	8b 12                	mov    (%edx),%edx
80101f0a:	83 ec 08             	sub    $0x8,%esp
80101f0d:	50                   	push   %eax
80101f0e:	52                   	push   %edx
80101f0f:	e8 fc f6 ff ff       	call   80101610 <bfree>
80101f14:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101f17:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1a:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101f21:	8b 45 08             	mov    0x8(%ebp),%eax
80101f24:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101f2b:	83 ec 0c             	sub    $0xc,%esp
80101f2e:	ff 75 08             	pushl  0x8(%ebp)
80101f31:	e8 04 f9 ff ff       	call   8010183a <iupdate>
80101f36:	83 c4 10             	add    $0x10,%esp
}
80101f39:	90                   	nop
80101f3a:	c9                   	leave  
80101f3b:	c3                   	ret    

80101f3c <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101f3c:	55                   	push   %ebp
80101f3d:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f42:	8b 00                	mov    (%eax),%eax
80101f44:	89 c2                	mov    %eax,%edx
80101f46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f49:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4f:	8b 50 04             	mov    0x4(%eax),%edx
80101f52:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f55:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f58:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5b:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f62:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f65:	8b 45 08             	mov    0x8(%ebp),%eax
80101f68:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f6f:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f73:	8b 45 08             	mov    0x8(%ebp),%eax
80101f76:	8b 50 18             	mov    0x18(%eax),%edx
80101f79:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f7c:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f7f:	90                   	nop
80101f80:	5d                   	pop    %ebp
80101f81:	c3                   	ret    

80101f82 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f82:	55                   	push   %ebp
80101f83:	89 e5                	mov    %esp,%ebp
80101f85:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f88:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f8f:	66 83 f8 03          	cmp    $0x3,%ax
80101f93:	75 5c                	jne    80101ff1 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f95:	8b 45 08             	mov    0x8(%ebp),%eax
80101f98:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f9c:	66 85 c0             	test   %ax,%ax
80101f9f:	78 20                	js     80101fc1 <readi+0x3f>
80101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa8:	66 83 f8 09          	cmp    $0x9,%ax
80101fac:	7f 13                	jg     80101fc1 <readi+0x3f>
80101fae:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fb5:	98                   	cwtl   
80101fb6:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
80101fbd:	85 c0                	test   %eax,%eax
80101fbf:	75 0a                	jne    80101fcb <readi+0x49>
      return -1;
80101fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc6:	e9 0c 01 00 00       	jmp    801020d7 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fce:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fd2:	98                   	cwtl   
80101fd3:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
80101fda:	8b 55 14             	mov    0x14(%ebp),%edx
80101fdd:	83 ec 04             	sub    $0x4,%esp
80101fe0:	52                   	push   %edx
80101fe1:	ff 75 0c             	pushl  0xc(%ebp)
80101fe4:	ff 75 08             	pushl  0x8(%ebp)
80101fe7:	ff d0                	call   *%eax
80101fe9:	83 c4 10             	add    $0x10,%esp
80101fec:	e9 e6 00 00 00       	jmp    801020d7 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff4:	8b 40 18             	mov    0x18(%eax),%eax
80101ff7:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ffa:	72 0d                	jb     80102009 <readi+0x87>
80101ffc:	8b 55 10             	mov    0x10(%ebp),%edx
80101fff:	8b 45 14             	mov    0x14(%ebp),%eax
80102002:	01 d0                	add    %edx,%eax
80102004:	3b 45 10             	cmp    0x10(%ebp),%eax
80102007:	73 0a                	jae    80102013 <readi+0x91>
    return -1;
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	e9 c4 00 00 00       	jmp    801020d7 <readi+0x155>
  if(off + n > ip->size)
80102013:	8b 55 10             	mov    0x10(%ebp),%edx
80102016:	8b 45 14             	mov    0x14(%ebp),%eax
80102019:	01 c2                	add    %eax,%edx
8010201b:	8b 45 08             	mov    0x8(%ebp),%eax
8010201e:	8b 40 18             	mov    0x18(%eax),%eax
80102021:	39 c2                	cmp    %eax,%edx
80102023:	76 0c                	jbe    80102031 <readi+0xaf>
    n = ip->size - off;
80102025:	8b 45 08             	mov    0x8(%ebp),%eax
80102028:	8b 40 18             	mov    0x18(%eax),%eax
8010202b:	2b 45 10             	sub    0x10(%ebp),%eax
8010202e:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102031:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102038:	e9 8b 00 00 00       	jmp    801020c8 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010203d:	8b 45 10             	mov    0x10(%ebp),%eax
80102040:	c1 e8 09             	shr    $0x9,%eax
80102043:	83 ec 08             	sub    $0x8,%esp
80102046:	50                   	push   %eax
80102047:	ff 75 08             	pushl  0x8(%ebp)
8010204a:	e8 aa fc ff ff       	call   80101cf9 <bmap>
8010204f:	83 c4 10             	add    $0x10,%esp
80102052:	89 c2                	mov    %eax,%edx
80102054:	8b 45 08             	mov    0x8(%ebp),%eax
80102057:	8b 00                	mov    (%eax),%eax
80102059:	83 ec 08             	sub    $0x8,%esp
8010205c:	52                   	push   %edx
8010205d:	50                   	push   %eax
8010205e:	e8 53 e1 ff ff       	call   801001b6 <bread>
80102063:	83 c4 10             	add    $0x10,%esp
80102066:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102069:	8b 45 10             	mov    0x10(%ebp),%eax
8010206c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102071:	ba 00 02 00 00       	mov    $0x200,%edx
80102076:	29 c2                	sub    %eax,%edx
80102078:	8b 45 14             	mov    0x14(%ebp),%eax
8010207b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010207e:	39 c2                	cmp    %eax,%edx
80102080:	0f 46 c2             	cmovbe %edx,%eax
80102083:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102086:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102089:	8d 50 18             	lea    0x18(%eax),%edx
8010208c:	8b 45 10             	mov    0x10(%ebp),%eax
8010208f:	25 ff 01 00 00       	and    $0x1ff,%eax
80102094:	01 d0                	add    %edx,%eax
80102096:	83 ec 04             	sub    $0x4,%esp
80102099:	ff 75 ec             	pushl  -0x14(%ebp)
8010209c:	50                   	push   %eax
8010209d:	ff 75 0c             	pushl  0xc(%ebp)
801020a0:	e8 c3 48 00 00       	call   80106968 <memmove>
801020a5:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020a8:	83 ec 0c             	sub    $0xc,%esp
801020ab:	ff 75 f0             	pushl  -0x10(%ebp)
801020ae:	e8 7b e1 ff ff       	call   8010022e <brelse>
801020b3:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020b9:	01 45 f4             	add    %eax,-0xc(%ebp)
801020bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020bf:	01 45 10             	add    %eax,0x10(%ebp)
801020c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020c5:	01 45 0c             	add    %eax,0xc(%ebp)
801020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020cb:	3b 45 14             	cmp    0x14(%ebp),%eax
801020ce:	0f 82 69 ff ff ff    	jb     8010203d <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801020d4:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020d7:	c9                   	leave  
801020d8:	c3                   	ret    

801020d9 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020d9:	55                   	push   %ebp
801020da:	89 e5                	mov    %esp,%ebp
801020dc:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020df:	8b 45 08             	mov    0x8(%ebp),%eax
801020e2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020e6:	66 83 f8 03          	cmp    $0x3,%ax
801020ea:	75 5c                	jne    80102148 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020ec:	8b 45 08             	mov    0x8(%ebp),%eax
801020ef:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020f3:	66 85 c0             	test   %ax,%ax
801020f6:	78 20                	js     80102118 <writei+0x3f>
801020f8:	8b 45 08             	mov    0x8(%ebp),%eax
801020fb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020ff:	66 83 f8 09          	cmp    $0x9,%ax
80102103:	7f 13                	jg     80102118 <writei+0x3f>
80102105:	8b 45 08             	mov    0x8(%ebp),%eax
80102108:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010210c:	98                   	cwtl   
8010210d:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
80102114:	85 c0                	test   %eax,%eax
80102116:	75 0a                	jne    80102122 <writei+0x49>
      return -1;
80102118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010211d:	e9 3d 01 00 00       	jmp    8010225f <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102122:	8b 45 08             	mov    0x8(%ebp),%eax
80102125:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102129:	98                   	cwtl   
8010212a:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
80102131:	8b 55 14             	mov    0x14(%ebp),%edx
80102134:	83 ec 04             	sub    $0x4,%esp
80102137:	52                   	push   %edx
80102138:	ff 75 0c             	pushl  0xc(%ebp)
8010213b:	ff 75 08             	pushl  0x8(%ebp)
8010213e:	ff d0                	call   *%eax
80102140:	83 c4 10             	add    $0x10,%esp
80102143:	e9 17 01 00 00       	jmp    8010225f <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102148:	8b 45 08             	mov    0x8(%ebp),%eax
8010214b:	8b 40 18             	mov    0x18(%eax),%eax
8010214e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102151:	72 0d                	jb     80102160 <writei+0x87>
80102153:	8b 55 10             	mov    0x10(%ebp),%edx
80102156:	8b 45 14             	mov    0x14(%ebp),%eax
80102159:	01 d0                	add    %edx,%eax
8010215b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010215e:	73 0a                	jae    8010216a <writei+0x91>
    return -1;
80102160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102165:	e9 f5 00 00 00       	jmp    8010225f <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010216a:	8b 55 10             	mov    0x10(%ebp),%edx
8010216d:	8b 45 14             	mov    0x14(%ebp),%eax
80102170:	01 d0                	add    %edx,%eax
80102172:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102177:	76 0a                	jbe    80102183 <writei+0xaa>
    return -1;
80102179:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010217e:	e9 dc 00 00 00       	jmp    8010225f <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010218a:	e9 99 00 00 00       	jmp    80102228 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010218f:	8b 45 10             	mov    0x10(%ebp),%eax
80102192:	c1 e8 09             	shr    $0x9,%eax
80102195:	83 ec 08             	sub    $0x8,%esp
80102198:	50                   	push   %eax
80102199:	ff 75 08             	pushl  0x8(%ebp)
8010219c:	e8 58 fb ff ff       	call   80101cf9 <bmap>
801021a1:	83 c4 10             	add    $0x10,%esp
801021a4:	89 c2                	mov    %eax,%edx
801021a6:	8b 45 08             	mov    0x8(%ebp),%eax
801021a9:	8b 00                	mov    (%eax),%eax
801021ab:	83 ec 08             	sub    $0x8,%esp
801021ae:	52                   	push   %edx
801021af:	50                   	push   %eax
801021b0:	e8 01 e0 ff ff       	call   801001b6 <bread>
801021b5:	83 c4 10             	add    $0x10,%esp
801021b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021bb:	8b 45 10             	mov    0x10(%ebp),%eax
801021be:	25 ff 01 00 00       	and    $0x1ff,%eax
801021c3:	ba 00 02 00 00       	mov    $0x200,%edx
801021c8:	29 c2                	sub    %eax,%edx
801021ca:	8b 45 14             	mov    0x14(%ebp),%eax
801021cd:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021d0:	39 c2                	cmp    %eax,%edx
801021d2:	0f 46 c2             	cmovbe %edx,%eax
801021d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021db:	8d 50 18             	lea    0x18(%eax),%edx
801021de:	8b 45 10             	mov    0x10(%ebp),%eax
801021e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801021e6:	01 d0                	add    %edx,%eax
801021e8:	83 ec 04             	sub    $0x4,%esp
801021eb:	ff 75 ec             	pushl  -0x14(%ebp)
801021ee:	ff 75 0c             	pushl  0xc(%ebp)
801021f1:	50                   	push   %eax
801021f2:	e8 71 47 00 00       	call   80106968 <memmove>
801021f7:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801021fa:	83 ec 0c             	sub    $0xc,%esp
801021fd:	ff 75 f0             	pushl  -0x10(%ebp)
80102200:	e8 2a 16 00 00       	call   8010382f <log_write>
80102205:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102208:	83 ec 0c             	sub    $0xc,%esp
8010220b:	ff 75 f0             	pushl  -0x10(%ebp)
8010220e:	e8 1b e0 ff ff       	call   8010022e <brelse>
80102213:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102216:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102219:	01 45 f4             	add    %eax,-0xc(%ebp)
8010221c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010221f:	01 45 10             	add    %eax,0x10(%ebp)
80102222:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102225:	01 45 0c             	add    %eax,0xc(%ebp)
80102228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010222b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010222e:	0f 82 5b ff ff ff    	jb     8010218f <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102234:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102238:	74 22                	je     8010225c <writei+0x183>
8010223a:	8b 45 08             	mov    0x8(%ebp),%eax
8010223d:	8b 40 18             	mov    0x18(%eax),%eax
80102240:	3b 45 10             	cmp    0x10(%ebp),%eax
80102243:	73 17                	jae    8010225c <writei+0x183>
    ip->size = off;
80102245:	8b 45 08             	mov    0x8(%ebp),%eax
80102248:	8b 55 10             	mov    0x10(%ebp),%edx
8010224b:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010224e:	83 ec 0c             	sub    $0xc,%esp
80102251:	ff 75 08             	pushl  0x8(%ebp)
80102254:	e8 e1 f5 ff ff       	call   8010183a <iupdate>
80102259:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010225c:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010225f:	c9                   	leave  
80102260:	c3                   	ret    

80102261 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102261:	55                   	push   %ebp
80102262:	89 e5                	mov    %esp,%ebp
80102264:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102267:	83 ec 04             	sub    $0x4,%esp
8010226a:	6a 0e                	push   $0xe
8010226c:	ff 75 0c             	pushl  0xc(%ebp)
8010226f:	ff 75 08             	pushl  0x8(%ebp)
80102272:	e8 87 47 00 00       	call   801069fe <strncmp>
80102277:	83 c4 10             	add    $0x10,%esp
}
8010227a:	c9                   	leave  
8010227b:	c3                   	ret    

8010227c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010227c:	55                   	push   %ebp
8010227d:	89 e5                	mov    %esp,%ebp
8010227f:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102282:	8b 45 08             	mov    0x8(%ebp),%eax
80102285:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102289:	66 83 f8 01          	cmp    $0x1,%ax
8010228d:	74 0d                	je     8010229c <dirlookup+0x20>
    panic("dirlookup not DIR");
8010228f:	83 ec 0c             	sub    $0xc,%esp
80102292:	68 63 9e 10 80       	push   $0x80109e63
80102297:	e8 ca e2 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010229c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022a3:	eb 7b                	jmp    80102320 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022a5:	6a 10                	push   $0x10
801022a7:	ff 75 f4             	pushl  -0xc(%ebp)
801022aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022ad:	50                   	push   %eax
801022ae:	ff 75 08             	pushl  0x8(%ebp)
801022b1:	e8 cc fc ff ff       	call   80101f82 <readi>
801022b6:	83 c4 10             	add    $0x10,%esp
801022b9:	83 f8 10             	cmp    $0x10,%eax
801022bc:	74 0d                	je     801022cb <dirlookup+0x4f>
      panic("dirlink read");
801022be:	83 ec 0c             	sub    $0xc,%esp
801022c1:	68 75 9e 10 80       	push   $0x80109e75
801022c6:	e8 9b e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801022cb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022cf:	66 85 c0             	test   %ax,%ax
801022d2:	74 47                	je     8010231b <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801022d4:	83 ec 08             	sub    $0x8,%esp
801022d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022da:	83 c0 02             	add    $0x2,%eax
801022dd:	50                   	push   %eax
801022de:	ff 75 0c             	pushl  0xc(%ebp)
801022e1:	e8 7b ff ff ff       	call   80102261 <namecmp>
801022e6:	83 c4 10             	add    $0x10,%esp
801022e9:	85 c0                	test   %eax,%eax
801022eb:	75 2f                	jne    8010231c <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801022ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022f1:	74 08                	je     801022fb <dirlookup+0x7f>
        *poff = off;
801022f3:	8b 45 10             	mov    0x10(%ebp),%eax
801022f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022f9:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801022fb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022ff:	0f b7 c0             	movzwl %ax,%eax
80102302:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102305:	8b 45 08             	mov    0x8(%ebp),%eax
80102308:	8b 00                	mov    (%eax),%eax
8010230a:	83 ec 08             	sub    $0x8,%esp
8010230d:	ff 75 f0             	pushl  -0x10(%ebp)
80102310:	50                   	push   %eax
80102311:	e8 e5 f5 ff ff       	call   801018fb <iget>
80102316:	83 c4 10             	add    $0x10,%esp
80102319:	eb 19                	jmp    80102334 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010231b:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010231c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102320:	8b 45 08             	mov    0x8(%ebp),%eax
80102323:	8b 40 18             	mov    0x18(%eax),%eax
80102326:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102329:	0f 87 76 ff ff ff    	ja     801022a5 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010232f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102334:	c9                   	leave  
80102335:	c3                   	ret    

80102336 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102336:	55                   	push   %ebp
80102337:	89 e5                	mov    %esp,%ebp
80102339:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010233c:	83 ec 04             	sub    $0x4,%esp
8010233f:	6a 00                	push   $0x0
80102341:	ff 75 0c             	pushl  0xc(%ebp)
80102344:	ff 75 08             	pushl  0x8(%ebp)
80102347:	e8 30 ff ff ff       	call   8010227c <dirlookup>
8010234c:	83 c4 10             	add    $0x10,%esp
8010234f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102352:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102356:	74 18                	je     80102370 <dirlink+0x3a>
    iput(ip);
80102358:	83 ec 0c             	sub    $0xc,%esp
8010235b:	ff 75 f0             	pushl  -0x10(%ebp)
8010235e:	e8 81 f8 ff ff       	call   80101be4 <iput>
80102363:	83 c4 10             	add    $0x10,%esp
    return -1;
80102366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010236b:	e9 9c 00 00 00       	jmp    8010240c <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102377:	eb 39                	jmp    801023b2 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010237c:	6a 10                	push   $0x10
8010237e:	50                   	push   %eax
8010237f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102382:	50                   	push   %eax
80102383:	ff 75 08             	pushl  0x8(%ebp)
80102386:	e8 f7 fb ff ff       	call   80101f82 <readi>
8010238b:	83 c4 10             	add    $0x10,%esp
8010238e:	83 f8 10             	cmp    $0x10,%eax
80102391:	74 0d                	je     801023a0 <dirlink+0x6a>
      panic("dirlink read");
80102393:	83 ec 0c             	sub    $0xc,%esp
80102396:	68 75 9e 10 80       	push   $0x80109e75
8010239b:	e8 c6 e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801023a0:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801023a4:	66 85 c0             	test   %ax,%ax
801023a7:	74 18                	je     801023c1 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ac:	83 c0 10             	add    $0x10,%eax
801023af:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023b2:	8b 45 08             	mov    0x8(%ebp),%eax
801023b5:	8b 50 18             	mov    0x18(%eax),%edx
801023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023bb:	39 c2                	cmp    %eax,%edx
801023bd:	77 ba                	ja     80102379 <dirlink+0x43>
801023bf:	eb 01                	jmp    801023c2 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801023c1:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801023c2:	83 ec 04             	sub    $0x4,%esp
801023c5:	6a 0e                	push   $0xe
801023c7:	ff 75 0c             	pushl  0xc(%ebp)
801023ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023cd:	83 c0 02             	add    $0x2,%eax
801023d0:	50                   	push   %eax
801023d1:	e8 7e 46 00 00       	call   80106a54 <strncpy>
801023d6:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023d9:	8b 45 10             	mov    0x10(%ebp),%eax
801023dc:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e3:	6a 10                	push   $0x10
801023e5:	50                   	push   %eax
801023e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023e9:	50                   	push   %eax
801023ea:	ff 75 08             	pushl  0x8(%ebp)
801023ed:	e8 e7 fc ff ff       	call   801020d9 <writei>
801023f2:	83 c4 10             	add    $0x10,%esp
801023f5:	83 f8 10             	cmp    $0x10,%eax
801023f8:	74 0d                	je     80102407 <dirlink+0xd1>
    panic("dirlink");
801023fa:	83 ec 0c             	sub    $0xc,%esp
801023fd:	68 82 9e 10 80       	push   $0x80109e82
80102402:	e8 5f e1 ff ff       	call   80100566 <panic>
  
  return 0;
80102407:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010240c:	c9                   	leave  
8010240d:	c3                   	ret    

8010240e <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010240e:	55                   	push   %ebp
8010240f:	89 e5                	mov    %esp,%ebp
80102411:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102414:	eb 04                	jmp    8010241a <skipelem+0xc>
    path++;
80102416:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
8010241d:	0f b6 00             	movzbl (%eax),%eax
80102420:	3c 2f                	cmp    $0x2f,%al
80102422:	74 f2                	je     80102416 <skipelem+0x8>
    path++;
  if(*path == 0)
80102424:	8b 45 08             	mov    0x8(%ebp),%eax
80102427:	0f b6 00             	movzbl (%eax),%eax
8010242a:	84 c0                	test   %al,%al
8010242c:	75 07                	jne    80102435 <skipelem+0x27>
    return 0;
8010242e:	b8 00 00 00 00       	mov    $0x0,%eax
80102433:	eb 7b                	jmp    801024b0 <skipelem+0xa2>
  s = path;
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
80102438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010243b:	eb 04                	jmp    80102441 <skipelem+0x33>
    path++;
8010243d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102441:	8b 45 08             	mov    0x8(%ebp),%eax
80102444:	0f b6 00             	movzbl (%eax),%eax
80102447:	3c 2f                	cmp    $0x2f,%al
80102449:	74 0a                	je     80102455 <skipelem+0x47>
8010244b:	8b 45 08             	mov    0x8(%ebp),%eax
8010244e:	0f b6 00             	movzbl (%eax),%eax
80102451:	84 c0                	test   %al,%al
80102453:	75 e8                	jne    8010243d <skipelem+0x2f>
    path++;
  len = path - s;
80102455:	8b 55 08             	mov    0x8(%ebp),%edx
80102458:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245b:	29 c2                	sub    %eax,%edx
8010245d:	89 d0                	mov    %edx,%eax
8010245f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102462:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102466:	7e 15                	jle    8010247d <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102468:	83 ec 04             	sub    $0x4,%esp
8010246b:	6a 0e                	push   $0xe
8010246d:	ff 75 f4             	pushl  -0xc(%ebp)
80102470:	ff 75 0c             	pushl  0xc(%ebp)
80102473:	e8 f0 44 00 00       	call   80106968 <memmove>
80102478:	83 c4 10             	add    $0x10,%esp
8010247b:	eb 26                	jmp    801024a3 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102480:	83 ec 04             	sub    $0x4,%esp
80102483:	50                   	push   %eax
80102484:	ff 75 f4             	pushl  -0xc(%ebp)
80102487:	ff 75 0c             	pushl  0xc(%ebp)
8010248a:	e8 d9 44 00 00       	call   80106968 <memmove>
8010248f:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102492:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102495:	8b 45 0c             	mov    0xc(%ebp),%eax
80102498:	01 d0                	add    %edx,%eax
8010249a:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010249d:	eb 04                	jmp    801024a3 <skipelem+0x95>
    path++;
8010249f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801024a3:	8b 45 08             	mov    0x8(%ebp),%eax
801024a6:	0f b6 00             	movzbl (%eax),%eax
801024a9:	3c 2f                	cmp    $0x2f,%al
801024ab:	74 f2                	je     8010249f <skipelem+0x91>
    path++;
  return path;
801024ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024b0:	c9                   	leave  
801024b1:	c3                   	ret    

801024b2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801024b2:	55                   	push   %ebp
801024b3:	89 e5                	mov    %esp,%ebp
801024b5:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801024b8:	8b 45 08             	mov    0x8(%ebp),%eax
801024bb:	0f b6 00             	movzbl (%eax),%eax
801024be:	3c 2f                	cmp    $0x2f,%al
801024c0:	75 17                	jne    801024d9 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801024c2:	83 ec 08             	sub    $0x8,%esp
801024c5:	6a 01                	push   $0x1
801024c7:	6a 01                	push   $0x1
801024c9:	e8 2d f4 ff ff       	call   801018fb <iget>
801024ce:	83 c4 10             	add    $0x10,%esp
801024d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024d4:	e9 bb 00 00 00       	jmp    80102594 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801024d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801024df:	8b 40 68             	mov    0x68(%eax),%eax
801024e2:	83 ec 0c             	sub    $0xc,%esp
801024e5:	50                   	push   %eax
801024e6:	e8 ef f4 ff ff       	call   801019da <idup>
801024eb:	83 c4 10             	add    $0x10,%esp
801024ee:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801024f1:	e9 9e 00 00 00       	jmp    80102594 <namex+0xe2>
    ilock(ip);
801024f6:	83 ec 0c             	sub    $0xc,%esp
801024f9:	ff 75 f4             	pushl  -0xc(%ebp)
801024fc:	e8 13 f5 ff ff       	call   80101a14 <ilock>
80102501:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102507:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010250b:	66 83 f8 01          	cmp    $0x1,%ax
8010250f:	74 18                	je     80102529 <namex+0x77>
      iunlockput(ip);
80102511:	83 ec 0c             	sub    $0xc,%esp
80102514:	ff 75 f4             	pushl  -0xc(%ebp)
80102517:	e8 b8 f7 ff ff       	call   80101cd4 <iunlockput>
8010251c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010251f:	b8 00 00 00 00       	mov    $0x0,%eax
80102524:	e9 a7 00 00 00       	jmp    801025d0 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102529:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010252d:	74 20                	je     8010254f <namex+0x9d>
8010252f:	8b 45 08             	mov    0x8(%ebp),%eax
80102532:	0f b6 00             	movzbl (%eax),%eax
80102535:	84 c0                	test   %al,%al
80102537:	75 16                	jne    8010254f <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102539:	83 ec 0c             	sub    $0xc,%esp
8010253c:	ff 75 f4             	pushl  -0xc(%ebp)
8010253f:	e8 2e f6 ff ff       	call   80101b72 <iunlock>
80102544:	83 c4 10             	add    $0x10,%esp
      return ip;
80102547:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010254a:	e9 81 00 00 00       	jmp    801025d0 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010254f:	83 ec 04             	sub    $0x4,%esp
80102552:	6a 00                	push   $0x0
80102554:	ff 75 10             	pushl  0x10(%ebp)
80102557:	ff 75 f4             	pushl  -0xc(%ebp)
8010255a:	e8 1d fd ff ff       	call   8010227c <dirlookup>
8010255f:	83 c4 10             	add    $0x10,%esp
80102562:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102565:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102569:	75 15                	jne    80102580 <namex+0xce>
      iunlockput(ip);
8010256b:	83 ec 0c             	sub    $0xc,%esp
8010256e:	ff 75 f4             	pushl  -0xc(%ebp)
80102571:	e8 5e f7 ff ff       	call   80101cd4 <iunlockput>
80102576:	83 c4 10             	add    $0x10,%esp
      return 0;
80102579:	b8 00 00 00 00       	mov    $0x0,%eax
8010257e:	eb 50                	jmp    801025d0 <namex+0x11e>
    }
    iunlockput(ip);
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	ff 75 f4             	pushl  -0xc(%ebp)
80102586:	e8 49 f7 ff ff       	call   80101cd4 <iunlockput>
8010258b:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102591:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102594:	83 ec 08             	sub    $0x8,%esp
80102597:	ff 75 10             	pushl  0x10(%ebp)
8010259a:	ff 75 08             	pushl  0x8(%ebp)
8010259d:	e8 6c fe ff ff       	call   8010240e <skipelem>
801025a2:	83 c4 10             	add    $0x10,%esp
801025a5:	89 45 08             	mov    %eax,0x8(%ebp)
801025a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025ac:	0f 85 44 ff ff ff    	jne    801024f6 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801025b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025b6:	74 15                	je     801025cd <namex+0x11b>
    iput(ip);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	ff 75 f4             	pushl  -0xc(%ebp)
801025be:	e8 21 f6 ff ff       	call   80101be4 <iput>
801025c3:	83 c4 10             	add    $0x10,%esp
    return 0;
801025c6:	b8 00 00 00 00       	mov    $0x0,%eax
801025cb:	eb 03                	jmp    801025d0 <namex+0x11e>
  }
  return ip;
801025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025d0:	c9                   	leave  
801025d1:	c3                   	ret    

801025d2 <namei>:

struct inode*
namei(char *path)
{
801025d2:	55                   	push   %ebp
801025d3:	89 e5                	mov    %esp,%ebp
801025d5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025d8:	83 ec 04             	sub    $0x4,%esp
801025db:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025de:	50                   	push   %eax
801025df:	6a 00                	push   $0x0
801025e1:	ff 75 08             	pushl  0x8(%ebp)
801025e4:	e8 c9 fe ff ff       	call   801024b2 <namex>
801025e9:	83 c4 10             	add    $0x10,%esp
}
801025ec:	c9                   	leave  
801025ed:	c3                   	ret    

801025ee <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025ee:	55                   	push   %ebp
801025ef:	89 e5                	mov    %esp,%ebp
801025f1:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801025f4:	83 ec 04             	sub    $0x4,%esp
801025f7:	ff 75 0c             	pushl  0xc(%ebp)
801025fa:	6a 01                	push   $0x1
801025fc:	ff 75 08             	pushl  0x8(%ebp)
801025ff:	e8 ae fe ff ff       	call   801024b2 <namex>
80102604:	83 c4 10             	add    $0x10,%esp
}
80102607:	c9                   	leave  
80102608:	c3                   	ret    

80102609 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102609:	55                   	push   %ebp
8010260a:	89 e5                	mov    %esp,%ebp
8010260c:	83 ec 14             	sub    $0x14,%esp
8010260f:	8b 45 08             	mov    0x8(%ebp),%eax
80102612:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102616:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010261a:	89 c2                	mov    %eax,%edx
8010261c:	ec                   	in     (%dx),%al
8010261d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102620:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102624:	c9                   	leave  
80102625:	c3                   	ret    

80102626 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102626:	55                   	push   %ebp
80102627:	89 e5                	mov    %esp,%ebp
80102629:	57                   	push   %edi
8010262a:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010262b:	8b 55 08             	mov    0x8(%ebp),%edx
8010262e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102631:	8b 45 10             	mov    0x10(%ebp),%eax
80102634:	89 cb                	mov    %ecx,%ebx
80102636:	89 df                	mov    %ebx,%edi
80102638:	89 c1                	mov    %eax,%ecx
8010263a:	fc                   	cld    
8010263b:	f3 6d                	rep insl (%dx),%es:(%edi)
8010263d:	89 c8                	mov    %ecx,%eax
8010263f:	89 fb                	mov    %edi,%ebx
80102641:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102644:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102647:	90                   	nop
80102648:	5b                   	pop    %ebx
80102649:	5f                   	pop    %edi
8010264a:	5d                   	pop    %ebp
8010264b:	c3                   	ret    

8010264c <outb>:

static inline void
outb(ushort port, uchar data)
{
8010264c:	55                   	push   %ebp
8010264d:	89 e5                	mov    %esp,%ebp
8010264f:	83 ec 08             	sub    $0x8,%esp
80102652:	8b 55 08             	mov    0x8(%ebp),%edx
80102655:	8b 45 0c             	mov    0xc(%ebp),%eax
80102658:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010265c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102663:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102667:	ee                   	out    %al,(%dx)
}
80102668:	90                   	nop
80102669:	c9                   	leave  
8010266a:	c3                   	ret    

8010266b <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010266b:	55                   	push   %ebp
8010266c:	89 e5                	mov    %esp,%ebp
8010266e:	56                   	push   %esi
8010266f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102670:	8b 55 08             	mov    0x8(%ebp),%edx
80102673:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102676:	8b 45 10             	mov    0x10(%ebp),%eax
80102679:	89 cb                	mov    %ecx,%ebx
8010267b:	89 de                	mov    %ebx,%esi
8010267d:	89 c1                	mov    %eax,%ecx
8010267f:	fc                   	cld    
80102680:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102682:	89 c8                	mov    %ecx,%eax
80102684:	89 f3                	mov    %esi,%ebx
80102686:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102689:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010268c:	90                   	nop
8010268d:	5b                   	pop    %ebx
8010268e:	5e                   	pop    %esi
8010268f:	5d                   	pop    %ebp
80102690:	c3                   	ret    

80102691 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102691:	55                   	push   %ebp
80102692:	89 e5                	mov    %esp,%ebp
80102694:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102697:	90                   	nop
80102698:	68 f7 01 00 00       	push   $0x1f7
8010269d:	e8 67 ff ff ff       	call   80102609 <inb>
801026a2:	83 c4 04             	add    $0x4,%esp
801026a5:	0f b6 c0             	movzbl %al,%eax
801026a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801026ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026ae:	25 c0 00 00 00       	and    $0xc0,%eax
801026b3:	83 f8 40             	cmp    $0x40,%eax
801026b6:	75 e0                	jne    80102698 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026bc:	74 11                	je     801026cf <idewait+0x3e>
801026be:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026c1:	83 e0 21             	and    $0x21,%eax
801026c4:	85 c0                	test   %eax,%eax
801026c6:	74 07                	je     801026cf <idewait+0x3e>
    return -1;
801026c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026cd:	eb 05                	jmp    801026d4 <idewait+0x43>
  return 0;
801026cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026d4:	c9                   	leave  
801026d5:	c3                   	ret    

801026d6 <ideinit>:

void
ideinit(void)
{
801026d6:	55                   	push   %ebp
801026d7:	89 e5                	mov    %esp,%ebp
801026d9:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801026dc:	83 ec 08             	sub    $0x8,%esp
801026df:	68 8a 9e 10 80       	push   $0x80109e8a
801026e4:	68 20 d6 10 80       	push   $0x8010d620
801026e9:	e8 36 3f 00 00       	call   80106624 <initlock>
801026ee:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026f1:	83 ec 0c             	sub    $0xc,%esp
801026f4:	6a 0e                	push   $0xe
801026f6:	e8 da 18 00 00       	call   80103fd5 <picenable>
801026fb:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026fe:	a1 60 49 11 80       	mov    0x80114960,%eax
80102703:	83 e8 01             	sub    $0x1,%eax
80102706:	83 ec 08             	sub    $0x8,%esp
80102709:	50                   	push   %eax
8010270a:	6a 0e                	push   $0xe
8010270c:	e8 73 04 00 00       	call   80102b84 <ioapicenable>
80102711:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102714:	83 ec 0c             	sub    $0xc,%esp
80102717:	6a 00                	push   $0x0
80102719:	e8 73 ff ff ff       	call   80102691 <idewait>
8010271e:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102721:	83 ec 08             	sub    $0x8,%esp
80102724:	68 f0 00 00 00       	push   $0xf0
80102729:	68 f6 01 00 00       	push   $0x1f6
8010272e:	e8 19 ff ff ff       	call   8010264c <outb>
80102733:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010273d:	eb 24                	jmp    80102763 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010273f:	83 ec 0c             	sub    $0xc,%esp
80102742:	68 f7 01 00 00       	push   $0x1f7
80102747:	e8 bd fe ff ff       	call   80102609 <inb>
8010274c:	83 c4 10             	add    $0x10,%esp
8010274f:	84 c0                	test   %al,%al
80102751:	74 0c                	je     8010275f <ideinit+0x89>
      havedisk1 = 1;
80102753:	c7 05 58 d6 10 80 01 	movl   $0x1,0x8010d658
8010275a:	00 00 00 
      break;
8010275d:	eb 0d                	jmp    8010276c <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010275f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102763:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010276a:	7e d3                	jle    8010273f <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010276c:	83 ec 08             	sub    $0x8,%esp
8010276f:	68 e0 00 00 00       	push   $0xe0
80102774:	68 f6 01 00 00       	push   $0x1f6
80102779:	e8 ce fe ff ff       	call   8010264c <outb>
8010277e:	83 c4 10             	add    $0x10,%esp
}
80102781:	90                   	nop
80102782:	c9                   	leave  
80102783:	c3                   	ret    

80102784 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010278a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010278e:	75 0d                	jne    8010279d <idestart+0x19>
    panic("idestart");
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 8e 9e 10 80       	push   $0x80109e8e
80102798:	e8 c9 dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
8010279d:	8b 45 08             	mov    0x8(%ebp),%eax
801027a0:	8b 40 08             	mov    0x8(%eax),%eax
801027a3:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027a8:	76 0d                	jbe    801027b7 <idestart+0x33>
    panic("incorrect blockno");
801027aa:	83 ec 0c             	sub    $0xc,%esp
801027ad:	68 97 9e 10 80       	push   $0x80109e97
801027b2:	e8 af dd ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801027b7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801027be:	8b 45 08             	mov    0x8(%ebp),%eax
801027c1:	8b 50 08             	mov    0x8(%eax),%edx
801027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c7:	0f af c2             	imul   %edx,%eax
801027ca:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801027cd:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801027d1:	7e 0d                	jle    801027e0 <idestart+0x5c>
801027d3:	83 ec 0c             	sub    $0xc,%esp
801027d6:	68 8e 9e 10 80       	push   $0x80109e8e
801027db:	e8 86 dd ff ff       	call   80100566 <panic>
  
  idewait(0);
801027e0:	83 ec 0c             	sub    $0xc,%esp
801027e3:	6a 00                	push   $0x0
801027e5:	e8 a7 fe ff ff       	call   80102691 <idewait>
801027ea:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801027ed:	83 ec 08             	sub    $0x8,%esp
801027f0:	6a 00                	push   $0x0
801027f2:	68 f6 03 00 00       	push   $0x3f6
801027f7:	e8 50 fe ff ff       	call   8010264c <outb>
801027fc:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102802:	0f b6 c0             	movzbl %al,%eax
80102805:	83 ec 08             	sub    $0x8,%esp
80102808:	50                   	push   %eax
80102809:	68 f2 01 00 00       	push   $0x1f2
8010280e:	e8 39 fe ff ff       	call   8010264c <outb>
80102813:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102816:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102819:	0f b6 c0             	movzbl %al,%eax
8010281c:	83 ec 08             	sub    $0x8,%esp
8010281f:	50                   	push   %eax
80102820:	68 f3 01 00 00       	push   $0x1f3
80102825:	e8 22 fe ff ff       	call   8010264c <outb>
8010282a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
8010282d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102830:	c1 f8 08             	sar    $0x8,%eax
80102833:	0f b6 c0             	movzbl %al,%eax
80102836:	83 ec 08             	sub    $0x8,%esp
80102839:	50                   	push   %eax
8010283a:	68 f4 01 00 00       	push   $0x1f4
8010283f:	e8 08 fe ff ff       	call   8010264c <outb>
80102844:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102847:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010284a:	c1 f8 10             	sar    $0x10,%eax
8010284d:	0f b6 c0             	movzbl %al,%eax
80102850:	83 ec 08             	sub    $0x8,%esp
80102853:	50                   	push   %eax
80102854:	68 f5 01 00 00       	push   $0x1f5
80102859:	e8 ee fd ff ff       	call   8010264c <outb>
8010285e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102861:	8b 45 08             	mov    0x8(%ebp),%eax
80102864:	8b 40 04             	mov    0x4(%eax),%eax
80102867:	83 e0 01             	and    $0x1,%eax
8010286a:	c1 e0 04             	shl    $0x4,%eax
8010286d:	89 c2                	mov    %eax,%edx
8010286f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102872:	c1 f8 18             	sar    $0x18,%eax
80102875:	83 e0 0f             	and    $0xf,%eax
80102878:	09 d0                	or     %edx,%eax
8010287a:	83 c8 e0             	or     $0xffffffe0,%eax
8010287d:	0f b6 c0             	movzbl %al,%eax
80102880:	83 ec 08             	sub    $0x8,%esp
80102883:	50                   	push   %eax
80102884:	68 f6 01 00 00       	push   $0x1f6
80102889:	e8 be fd ff ff       	call   8010264c <outb>
8010288e:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102891:	8b 45 08             	mov    0x8(%ebp),%eax
80102894:	8b 00                	mov    (%eax),%eax
80102896:	83 e0 04             	and    $0x4,%eax
80102899:	85 c0                	test   %eax,%eax
8010289b:	74 30                	je     801028cd <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
8010289d:	83 ec 08             	sub    $0x8,%esp
801028a0:	6a 30                	push   $0x30
801028a2:	68 f7 01 00 00       	push   $0x1f7
801028a7:	e8 a0 fd ff ff       	call   8010264c <outb>
801028ac:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801028af:	8b 45 08             	mov    0x8(%ebp),%eax
801028b2:	83 c0 18             	add    $0x18,%eax
801028b5:	83 ec 04             	sub    $0x4,%esp
801028b8:	68 80 00 00 00       	push   $0x80
801028bd:	50                   	push   %eax
801028be:	68 f0 01 00 00       	push   $0x1f0
801028c3:	e8 a3 fd ff ff       	call   8010266b <outsl>
801028c8:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
801028cb:	eb 12                	jmp    801028df <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
801028cd:	83 ec 08             	sub    $0x8,%esp
801028d0:	6a 20                	push   $0x20
801028d2:	68 f7 01 00 00       	push   $0x1f7
801028d7:	e8 70 fd ff ff       	call   8010264c <outb>
801028dc:	83 c4 10             	add    $0x10,%esp
  }
}
801028df:	90                   	nop
801028e0:	c9                   	leave  
801028e1:	c3                   	ret    

801028e2 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028e2:	55                   	push   %ebp
801028e3:	89 e5                	mov    %esp,%ebp
801028e5:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028e8:	83 ec 0c             	sub    $0xc,%esp
801028eb:	68 20 d6 10 80       	push   $0x8010d620
801028f0:	e8 51 3d 00 00       	call   80106646 <acquire>
801028f5:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028f8:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801028fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102900:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102904:	75 15                	jne    8010291b <ideintr+0x39>
    release(&idelock);
80102906:	83 ec 0c             	sub    $0xc,%esp
80102909:	68 20 d6 10 80       	push   $0x8010d620
8010290e:	e8 9a 3d 00 00       	call   801066ad <release>
80102913:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102916:	e9 9a 00 00 00       	jmp    801029b5 <ideintr+0xd3>
  }
  idequeue = b->qnext;
8010291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291e:	8b 40 14             	mov    0x14(%eax),%eax
80102921:	a3 54 d6 10 80       	mov    %eax,0x8010d654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102929:	8b 00                	mov    (%eax),%eax
8010292b:	83 e0 04             	and    $0x4,%eax
8010292e:	85 c0                	test   %eax,%eax
80102930:	75 2d                	jne    8010295f <ideintr+0x7d>
80102932:	83 ec 0c             	sub    $0xc,%esp
80102935:	6a 01                	push   $0x1
80102937:	e8 55 fd ff ff       	call   80102691 <idewait>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	78 1c                	js     8010295f <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102946:	83 c0 18             	add    $0x18,%eax
80102949:	83 ec 04             	sub    $0x4,%esp
8010294c:	68 80 00 00 00       	push   $0x80
80102951:	50                   	push   %eax
80102952:	68 f0 01 00 00       	push   $0x1f0
80102957:	e8 ca fc ff ff       	call   80102626 <insl>
8010295c:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102962:	8b 00                	mov    (%eax),%eax
80102964:	83 c8 02             	or     $0x2,%eax
80102967:	89 c2                	mov    %eax,%edx
80102969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296c:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102971:	8b 00                	mov    (%eax),%eax
80102973:	83 e0 fb             	and    $0xfffffffb,%eax
80102976:	89 c2                	mov    %eax,%edx
80102978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010297b:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010297d:	83 ec 0c             	sub    $0xc,%esp
80102980:	ff 75 f4             	pushl  -0xc(%ebp)
80102983:	e8 09 2c 00 00       	call   80105591 <wakeup>
80102988:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010298b:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102990:	85 c0                	test   %eax,%eax
80102992:	74 11                	je     801029a5 <ideintr+0xc3>
    idestart(idequeue);
80102994:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102999:	83 ec 0c             	sub    $0xc,%esp
8010299c:	50                   	push   %eax
8010299d:	e8 e2 fd ff ff       	call   80102784 <idestart>
801029a2:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801029a5:	83 ec 0c             	sub    $0xc,%esp
801029a8:	68 20 d6 10 80       	push   $0x8010d620
801029ad:	e8 fb 3c 00 00       	call   801066ad <release>
801029b2:	83 c4 10             	add    $0x10,%esp
}
801029b5:	c9                   	leave  
801029b6:	c3                   	ret    

801029b7 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029b7:	55                   	push   %ebp
801029b8:	89 e5                	mov    %esp,%ebp
801029ba:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801029bd:	8b 45 08             	mov    0x8(%ebp),%eax
801029c0:	8b 00                	mov    (%eax),%eax
801029c2:	83 e0 01             	and    $0x1,%eax
801029c5:	85 c0                	test   %eax,%eax
801029c7:	75 0d                	jne    801029d6 <iderw+0x1f>
    panic("iderw: buf not busy");
801029c9:	83 ec 0c             	sub    $0xc,%esp
801029cc:	68 a9 9e 10 80       	push   $0x80109ea9
801029d1:	e8 90 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029d6:	8b 45 08             	mov    0x8(%ebp),%eax
801029d9:	8b 00                	mov    (%eax),%eax
801029db:	83 e0 06             	and    $0x6,%eax
801029de:	83 f8 02             	cmp    $0x2,%eax
801029e1:	75 0d                	jne    801029f0 <iderw+0x39>
    panic("iderw: nothing to do");
801029e3:	83 ec 0c             	sub    $0xc,%esp
801029e6:	68 bd 9e 10 80       	push   $0x80109ebd
801029eb:	e8 76 db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801029f0:	8b 45 08             	mov    0x8(%ebp),%eax
801029f3:	8b 40 04             	mov    0x4(%eax),%eax
801029f6:	85 c0                	test   %eax,%eax
801029f8:	74 16                	je     80102a10 <iderw+0x59>
801029fa:	a1 58 d6 10 80       	mov    0x8010d658,%eax
801029ff:	85 c0                	test   %eax,%eax
80102a01:	75 0d                	jne    80102a10 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102a03:	83 ec 0c             	sub    $0xc,%esp
80102a06:	68 d2 9e 10 80       	push   $0x80109ed2
80102a0b:	e8 56 db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a10:	83 ec 0c             	sub    $0xc,%esp
80102a13:	68 20 d6 10 80       	push   $0x8010d620
80102a18:	e8 29 3c 00 00       	call   80106646 <acquire>
80102a1d:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a20:	8b 45 08             	mov    0x8(%ebp),%eax
80102a23:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a2a:	c7 45 f4 54 d6 10 80 	movl   $0x8010d654,-0xc(%ebp)
80102a31:	eb 0b                	jmp    80102a3e <iderw+0x87>
80102a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a36:	8b 00                	mov    (%eax),%eax
80102a38:	83 c0 14             	add    $0x14,%eax
80102a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a41:	8b 00                	mov    (%eax),%eax
80102a43:	85 c0                	test   %eax,%eax
80102a45:	75 ec                	jne    80102a33 <iderw+0x7c>
    ;
  *pp = b;
80102a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4a:	8b 55 08             	mov    0x8(%ebp),%edx
80102a4d:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102a4f:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102a54:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a57:	75 23                	jne    80102a7c <iderw+0xc5>
    idestart(b);
80102a59:	83 ec 0c             	sub    $0xc,%esp
80102a5c:	ff 75 08             	pushl  0x8(%ebp)
80102a5f:	e8 20 fd ff ff       	call   80102784 <idestart>
80102a64:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a67:	eb 13                	jmp    80102a7c <iderw+0xc5>
    sleep(b, &idelock);
80102a69:	83 ec 08             	sub    $0x8,%esp
80102a6c:	68 20 d6 10 80       	push   $0x8010d620
80102a71:	ff 75 08             	pushl  0x8(%ebp)
80102a74:	e8 3f 29 00 00       	call   801053b8 <sleep>
80102a79:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7f:	8b 00                	mov    (%eax),%eax
80102a81:	83 e0 06             	and    $0x6,%eax
80102a84:	83 f8 02             	cmp    $0x2,%eax
80102a87:	75 e0                	jne    80102a69 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a89:	83 ec 0c             	sub    $0xc,%esp
80102a8c:	68 20 d6 10 80       	push   $0x8010d620
80102a91:	e8 17 3c 00 00       	call   801066ad <release>
80102a96:	83 c4 10             	add    $0x10,%esp
}
80102a99:	90                   	nop
80102a9a:	c9                   	leave  
80102a9b:	c3                   	ret    

80102a9c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a9c:	55                   	push   %ebp
80102a9d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a9f:	a1 34 42 11 80       	mov    0x80114234,%eax
80102aa4:	8b 55 08             	mov    0x8(%ebp),%edx
80102aa7:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102aa9:	a1 34 42 11 80       	mov    0x80114234,%eax
80102aae:	8b 40 10             	mov    0x10(%eax),%eax
}
80102ab1:	5d                   	pop    %ebp
80102ab2:	c3                   	ret    

80102ab3 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102ab3:	55                   	push   %ebp
80102ab4:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102ab6:	a1 34 42 11 80       	mov    0x80114234,%eax
80102abb:	8b 55 08             	mov    0x8(%ebp),%edx
80102abe:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102ac0:	a1 34 42 11 80       	mov    0x80114234,%eax
80102ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
80102ac8:	89 50 10             	mov    %edx,0x10(%eax)
}
80102acb:	90                   	nop
80102acc:	5d                   	pop    %ebp
80102acd:	c3                   	ret    

80102ace <ioapicinit>:

void
ioapicinit(void)
{
80102ace:	55                   	push   %ebp
80102acf:	89 e5                	mov    %esp,%ebp
80102ad1:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102ad4:	a1 64 43 11 80       	mov    0x80114364,%eax
80102ad9:	85 c0                	test   %eax,%eax
80102adb:	0f 84 a0 00 00 00    	je     80102b81 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ae1:	c7 05 34 42 11 80 00 	movl   $0xfec00000,0x80114234
80102ae8:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102aeb:	6a 01                	push   $0x1
80102aed:	e8 aa ff ff ff       	call   80102a9c <ioapicread>
80102af2:	83 c4 04             	add    $0x4,%esp
80102af5:	c1 e8 10             	shr    $0x10,%eax
80102af8:	25 ff 00 00 00       	and    $0xff,%eax
80102afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102b00:	6a 00                	push   $0x0
80102b02:	e8 95 ff ff ff       	call   80102a9c <ioapicread>
80102b07:	83 c4 04             	add    $0x4,%esp
80102b0a:	c1 e8 18             	shr    $0x18,%eax
80102b0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102b10:	0f b6 05 60 43 11 80 	movzbl 0x80114360,%eax
80102b17:	0f b6 c0             	movzbl %al,%eax
80102b1a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b1d:	74 10                	je     80102b2f <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b1f:	83 ec 0c             	sub    $0xc,%esp
80102b22:	68 f0 9e 10 80       	push   $0x80109ef0
80102b27:	e8 9a d8 ff ff       	call   801003c6 <cprintf>
80102b2c:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b36:	eb 3f                	jmp    80102b77 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b3b:	83 c0 20             	add    $0x20,%eax
80102b3e:	0d 00 00 01 00       	or     $0x10000,%eax
80102b43:	89 c2                	mov    %eax,%edx
80102b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b48:	83 c0 08             	add    $0x8,%eax
80102b4b:	01 c0                	add    %eax,%eax
80102b4d:	83 ec 08             	sub    $0x8,%esp
80102b50:	52                   	push   %edx
80102b51:	50                   	push   %eax
80102b52:	e8 5c ff ff ff       	call   80102ab3 <ioapicwrite>
80102b57:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5d:	83 c0 08             	add    $0x8,%eax
80102b60:	01 c0                	add    %eax,%eax
80102b62:	83 c0 01             	add    $0x1,%eax
80102b65:	83 ec 08             	sub    $0x8,%esp
80102b68:	6a 00                	push   $0x0
80102b6a:	50                   	push   %eax
80102b6b:	e8 43 ff ff ff       	call   80102ab3 <ioapicwrite>
80102b70:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b73:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b7d:	7e b9                	jle    80102b38 <ioapicinit+0x6a>
80102b7f:	eb 01                	jmp    80102b82 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102b81:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b82:	c9                   	leave  
80102b83:	c3                   	ret    

80102b84 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b84:	55                   	push   %ebp
80102b85:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b87:	a1 64 43 11 80       	mov    0x80114364,%eax
80102b8c:	85 c0                	test   %eax,%eax
80102b8e:	74 39                	je     80102bc9 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b90:	8b 45 08             	mov    0x8(%ebp),%eax
80102b93:	83 c0 20             	add    $0x20,%eax
80102b96:	89 c2                	mov    %eax,%edx
80102b98:	8b 45 08             	mov    0x8(%ebp),%eax
80102b9b:	83 c0 08             	add    $0x8,%eax
80102b9e:	01 c0                	add    %eax,%eax
80102ba0:	52                   	push   %edx
80102ba1:	50                   	push   %eax
80102ba2:	e8 0c ff ff ff       	call   80102ab3 <ioapicwrite>
80102ba7:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102baa:	8b 45 0c             	mov    0xc(%ebp),%eax
80102bad:	c1 e0 18             	shl    $0x18,%eax
80102bb0:	89 c2                	mov    %eax,%edx
80102bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80102bb5:	83 c0 08             	add    $0x8,%eax
80102bb8:	01 c0                	add    %eax,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	52                   	push   %edx
80102bbe:	50                   	push   %eax
80102bbf:	e8 ef fe ff ff       	call   80102ab3 <ioapicwrite>
80102bc4:	83 c4 08             	add    $0x8,%esp
80102bc7:	eb 01                	jmp    80102bca <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102bc9:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102bca:	c9                   	leave  
80102bcb:	c3                   	ret    

80102bcc <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102bcc:	55                   	push   %ebp
80102bcd:	89 e5                	mov    %esp,%ebp
80102bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd2:	05 00 00 00 80       	add    $0x80000000,%eax
80102bd7:	5d                   	pop    %ebp
80102bd8:	c3                   	ret    

80102bd9 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102bd9:	55                   	push   %ebp
80102bda:	89 e5                	mov    %esp,%ebp
80102bdc:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102bdf:	83 ec 08             	sub    $0x8,%esp
80102be2:	68 22 9f 10 80       	push   $0x80109f22
80102be7:	68 40 42 11 80       	push   $0x80114240
80102bec:	e8 33 3a 00 00       	call   80106624 <initlock>
80102bf1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102bf4:	c7 05 74 42 11 80 00 	movl   $0x0,0x80114274
80102bfb:	00 00 00 
  freerange(vstart, vend);
80102bfe:	83 ec 08             	sub    $0x8,%esp
80102c01:	ff 75 0c             	pushl  0xc(%ebp)
80102c04:	ff 75 08             	pushl  0x8(%ebp)
80102c07:	e8 2a 00 00 00       	call   80102c36 <freerange>
80102c0c:	83 c4 10             	add    $0x10,%esp
}
80102c0f:	90                   	nop
80102c10:	c9                   	leave  
80102c11:	c3                   	ret    

80102c12 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102c12:	55                   	push   %ebp
80102c13:	89 e5                	mov    %esp,%ebp
80102c15:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102c18:	83 ec 08             	sub    $0x8,%esp
80102c1b:	ff 75 0c             	pushl  0xc(%ebp)
80102c1e:	ff 75 08             	pushl  0x8(%ebp)
80102c21:	e8 10 00 00 00       	call   80102c36 <freerange>
80102c26:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102c29:	c7 05 74 42 11 80 01 	movl   $0x1,0x80114274
80102c30:	00 00 00 
}
80102c33:	90                   	nop
80102c34:	c9                   	leave  
80102c35:	c3                   	ret    

80102c36 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102c36:	55                   	push   %ebp
80102c37:	89 e5                	mov    %esp,%ebp
80102c39:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c3c:	8b 45 08             	mov    0x8(%ebp),%eax
80102c3f:	05 ff 0f 00 00       	add    $0xfff,%eax
80102c44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c4c:	eb 15                	jmp    80102c63 <freerange+0x2d>
    kfree(p);
80102c4e:	83 ec 0c             	sub    $0xc,%esp
80102c51:	ff 75 f4             	pushl  -0xc(%ebp)
80102c54:	e8 1a 00 00 00       	call   80102c73 <kfree>
80102c59:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c5c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c66:	05 00 10 00 00       	add    $0x1000,%eax
80102c6b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c6e:	76 de                	jbe    80102c4e <freerange+0x18>
    kfree(p);
}
80102c70:	90                   	nop
80102c71:	c9                   	leave  
80102c72:	c3                   	ret    

80102c73 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c73:	55                   	push   %ebp
80102c74:	89 e5                	mov    %esp,%ebp
80102c76:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102c79:	8b 45 08             	mov    0x8(%ebp),%eax
80102c7c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c81:	85 c0                	test   %eax,%eax
80102c83:	75 1b                	jne    80102ca0 <kfree+0x2d>
80102c85:	81 7d 08 5c 79 11 80 	cmpl   $0x8011795c,0x8(%ebp)
80102c8c:	72 12                	jb     80102ca0 <kfree+0x2d>
80102c8e:	ff 75 08             	pushl  0x8(%ebp)
80102c91:	e8 36 ff ff ff       	call   80102bcc <v2p>
80102c96:	83 c4 04             	add    $0x4,%esp
80102c99:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c9e:	76 0d                	jbe    80102cad <kfree+0x3a>
    panic("kfree");
80102ca0:	83 ec 0c             	sub    $0xc,%esp
80102ca3:	68 27 9f 10 80       	push   $0x80109f27
80102ca8:	e8 b9 d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102cad:	83 ec 04             	sub    $0x4,%esp
80102cb0:	68 00 10 00 00       	push   $0x1000
80102cb5:	6a 01                	push   $0x1
80102cb7:	ff 75 08             	pushl  0x8(%ebp)
80102cba:	e8 ea 3b 00 00       	call   801068a9 <memset>
80102cbf:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cc2:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cc7:	85 c0                	test   %eax,%eax
80102cc9:	74 10                	je     80102cdb <kfree+0x68>
    acquire(&kmem.lock);
80102ccb:	83 ec 0c             	sub    $0xc,%esp
80102cce:	68 40 42 11 80       	push   $0x80114240
80102cd3:	e8 6e 39 00 00       	call   80106646 <acquire>
80102cd8:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80102cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ce1:	8b 15 78 42 11 80    	mov    0x80114278,%edx
80102ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cea:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cef:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102cf4:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cf9:	85 c0                	test   %eax,%eax
80102cfb:	74 10                	je     80102d0d <kfree+0x9a>
    release(&kmem.lock);
80102cfd:	83 ec 0c             	sub    $0xc,%esp
80102d00:	68 40 42 11 80       	push   $0x80114240
80102d05:	e8 a3 39 00 00       	call   801066ad <release>
80102d0a:	83 c4 10             	add    $0x10,%esp
}
80102d0d:	90                   	nop
80102d0e:	c9                   	leave  
80102d0f:	c3                   	ret    

80102d10 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102d16:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d1b:	85 c0                	test   %eax,%eax
80102d1d:	74 10                	je     80102d2f <kalloc+0x1f>
    acquire(&kmem.lock);
80102d1f:	83 ec 0c             	sub    $0xc,%esp
80102d22:	68 40 42 11 80       	push   $0x80114240
80102d27:	e8 1a 39 00 00       	call   80106646 <acquire>
80102d2c:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d2f:	a1 78 42 11 80       	mov    0x80114278,%eax
80102d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d3b:	74 0a                	je     80102d47 <kalloc+0x37>
    kmem.freelist = r->next;
80102d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d40:	8b 00                	mov    (%eax),%eax
80102d42:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102d47:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d4c:	85 c0                	test   %eax,%eax
80102d4e:	74 10                	je     80102d60 <kalloc+0x50>
    release(&kmem.lock);
80102d50:	83 ec 0c             	sub    $0xc,%esp
80102d53:	68 40 42 11 80       	push   $0x80114240
80102d58:	e8 50 39 00 00       	call   801066ad <release>
80102d5d:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d63:	c9                   	leave  
80102d64:	c3                   	ret    

80102d65 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102d65:	55                   	push   %ebp
80102d66:	89 e5                	mov    %esp,%ebp
80102d68:	83 ec 14             	sub    $0x14,%esp
80102d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80102d6e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d72:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d76:	89 c2                	mov    %eax,%edx
80102d78:	ec                   	in     (%dx),%al
80102d79:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d7c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d80:	c9                   	leave  
80102d81:	c3                   	ret    

80102d82 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d82:	55                   	push   %ebp
80102d83:	89 e5                	mov    %esp,%ebp
80102d85:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d88:	6a 64                	push   $0x64
80102d8a:	e8 d6 ff ff ff       	call   80102d65 <inb>
80102d8f:	83 c4 04             	add    $0x4,%esp
80102d92:	0f b6 c0             	movzbl %al,%eax
80102d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d9b:	83 e0 01             	and    $0x1,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	75 0a                	jne    80102dac <kbdgetc+0x2a>
    return -1;
80102da2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102da7:	e9 23 01 00 00       	jmp    80102ecf <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102dac:	6a 60                	push   $0x60
80102dae:	e8 b2 ff ff ff       	call   80102d65 <inb>
80102db3:	83 c4 04             	add    $0x4,%esp
80102db6:	0f b6 c0             	movzbl %al,%eax
80102db9:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102dbc:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102dc3:	75 17                	jne    80102ddc <kbdgetc+0x5a>
    shift |= E0ESC;
80102dc5:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102dca:	83 c8 40             	or     $0x40,%eax
80102dcd:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102dd2:	b8 00 00 00 00       	mov    $0x0,%eax
80102dd7:	e9 f3 00 00 00       	jmp    80102ecf <kbdgetc+0x14d>
  } else if(data & 0x80){
80102ddc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ddf:	25 80 00 00 00       	and    $0x80,%eax
80102de4:	85 c0                	test   %eax,%eax
80102de6:	74 45                	je     80102e2d <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102de8:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102ded:	83 e0 40             	and    $0x40,%eax
80102df0:	85 c0                	test   %eax,%eax
80102df2:	75 08                	jne    80102dfc <kbdgetc+0x7a>
80102df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df7:	83 e0 7f             	and    $0x7f,%eax
80102dfa:	eb 03                	jmp    80102dff <kbdgetc+0x7d>
80102dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dff:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e05:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e0a:	0f b6 00             	movzbl (%eax),%eax
80102e0d:	83 c8 40             	or     $0x40,%eax
80102e10:	0f b6 c0             	movzbl %al,%eax
80102e13:	f7 d0                	not    %eax
80102e15:	89 c2                	mov    %eax,%edx
80102e17:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e1c:	21 d0                	and    %edx,%eax
80102e1e:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102e23:	b8 00 00 00 00       	mov    $0x0,%eax
80102e28:	e9 a2 00 00 00       	jmp    80102ecf <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e2d:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e32:	83 e0 40             	and    $0x40,%eax
80102e35:	85 c0                	test   %eax,%eax
80102e37:	74 14                	je     80102e4d <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e39:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e40:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e45:	83 e0 bf             	and    $0xffffffbf,%eax
80102e48:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  }

  shift |= shiftcode[data];
80102e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e50:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e55:	0f b6 00             	movzbl (%eax),%eax
80102e58:	0f b6 d0             	movzbl %al,%edx
80102e5b:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e60:	09 d0                	or     %edx,%eax
80102e62:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  shift ^= togglecode[data];
80102e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e6a:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102e6f:	0f b6 00             	movzbl (%eax),%eax
80102e72:	0f b6 d0             	movzbl %al,%edx
80102e75:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e7a:	31 d0                	xor    %edx,%eax
80102e7c:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e81:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e86:	83 e0 03             	and    $0x3,%eax
80102e89:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e93:	01 d0                	add    %edx,%eax
80102e95:	0f b6 00             	movzbl (%eax),%eax
80102e98:	0f b6 c0             	movzbl %al,%eax
80102e9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e9e:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102ea3:	83 e0 08             	and    $0x8,%eax
80102ea6:	85 c0                	test   %eax,%eax
80102ea8:	74 22                	je     80102ecc <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102eaa:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102eae:	76 0c                	jbe    80102ebc <kbdgetc+0x13a>
80102eb0:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102eb4:	77 06                	ja     80102ebc <kbdgetc+0x13a>
      c += 'A' - 'a';
80102eb6:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102eba:	eb 10                	jmp    80102ecc <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102ebc:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102ec0:	76 0a                	jbe    80102ecc <kbdgetc+0x14a>
80102ec2:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102ec6:	77 04                	ja     80102ecc <kbdgetc+0x14a>
      c += 'a' - 'A';
80102ec8:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ecc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ecf:	c9                   	leave  
80102ed0:	c3                   	ret    

80102ed1 <kbdintr>:

void
kbdintr(void)
{
80102ed1:	55                   	push   %ebp
80102ed2:	89 e5                	mov    %esp,%ebp
80102ed4:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ed7:	83 ec 0c             	sub    $0xc,%esp
80102eda:	68 82 2d 10 80       	push   $0x80102d82
80102edf:	e8 15 d9 ff ff       	call   801007f9 <consoleintr>
80102ee4:	83 c4 10             	add    $0x10,%esp
}
80102ee7:	90                   	nop
80102ee8:	c9                   	leave  
80102ee9:	c3                   	ret    

80102eea <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102eea:	55                   	push   %ebp
80102eeb:	89 e5                	mov    %esp,%ebp
80102eed:	83 ec 14             	sub    $0x14,%esp
80102ef0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ef3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102efb:	89 c2                	mov    %eax,%edx
80102efd:	ec                   	in     (%dx),%al
80102efe:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102f01:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102f05:	c9                   	leave  
80102f06:	c3                   	ret    

80102f07 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102f07:	55                   	push   %ebp
80102f08:	89 e5                	mov    %esp,%ebp
80102f0a:	83 ec 08             	sub    $0x8,%esp
80102f0d:	8b 55 08             	mov    0x8(%ebp),%edx
80102f10:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f13:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102f17:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f1a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102f1e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102f22:	ee                   	out    %al,(%dx)
}
80102f23:	90                   	nop
80102f24:	c9                   	leave  
80102f25:	c3                   	ret    

80102f26 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102f26:	55                   	push   %ebp
80102f27:	89 e5                	mov    %esp,%ebp
80102f29:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102f2c:	9c                   	pushf  
80102f2d:	58                   	pop    %eax
80102f2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102f34:	c9                   	leave  
80102f35:	c3                   	ret    

80102f36 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102f36:	55                   	push   %ebp
80102f37:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102f39:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f3e:	8b 55 08             	mov    0x8(%ebp),%edx
80102f41:	c1 e2 02             	shl    $0x2,%edx
80102f44:	01 c2                	add    %eax,%edx
80102f46:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f49:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f4b:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f50:	83 c0 20             	add    $0x20,%eax
80102f53:	8b 00                	mov    (%eax),%eax
}
80102f55:	90                   	nop
80102f56:	5d                   	pop    %ebp
80102f57:	c3                   	ret    

80102f58 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102f58:	55                   	push   %ebp
80102f59:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102f5b:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f60:	85 c0                	test   %eax,%eax
80102f62:	0f 84 0b 01 00 00    	je     80103073 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f68:	68 3f 01 00 00       	push   $0x13f
80102f6d:	6a 3c                	push   $0x3c
80102f6f:	e8 c2 ff ff ff       	call   80102f36 <lapicw>
80102f74:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f77:	6a 0b                	push   $0xb
80102f79:	68 f8 00 00 00       	push   $0xf8
80102f7e:	e8 b3 ff ff ff       	call   80102f36 <lapicw>
80102f83:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f86:	68 20 00 02 00       	push   $0x20020
80102f8b:	68 c8 00 00 00       	push   $0xc8
80102f90:	e8 a1 ff ff ff       	call   80102f36 <lapicw>
80102f95:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102f98:	68 80 96 98 00       	push   $0x989680
80102f9d:	68 e0 00 00 00       	push   $0xe0
80102fa2:	e8 8f ff ff ff       	call   80102f36 <lapicw>
80102fa7:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102faa:	68 00 00 01 00       	push   $0x10000
80102faf:	68 d4 00 00 00       	push   $0xd4
80102fb4:	e8 7d ff ff ff       	call   80102f36 <lapicw>
80102fb9:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102fbc:	68 00 00 01 00       	push   $0x10000
80102fc1:	68 d8 00 00 00       	push   $0xd8
80102fc6:	e8 6b ff ff ff       	call   80102f36 <lapicw>
80102fcb:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102fce:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102fd3:	83 c0 30             	add    $0x30,%eax
80102fd6:	8b 00                	mov    (%eax),%eax
80102fd8:	c1 e8 10             	shr    $0x10,%eax
80102fdb:	0f b6 c0             	movzbl %al,%eax
80102fde:	83 f8 03             	cmp    $0x3,%eax
80102fe1:	76 12                	jbe    80102ff5 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102fe3:	68 00 00 01 00       	push   $0x10000
80102fe8:	68 d0 00 00 00       	push   $0xd0
80102fed:	e8 44 ff ff ff       	call   80102f36 <lapicw>
80102ff2:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ff5:	6a 33                	push   $0x33
80102ff7:	68 dc 00 00 00       	push   $0xdc
80102ffc:	e8 35 ff ff ff       	call   80102f36 <lapicw>
80103001:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103004:	6a 00                	push   $0x0
80103006:	68 a0 00 00 00       	push   $0xa0
8010300b:	e8 26 ff ff ff       	call   80102f36 <lapicw>
80103010:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103013:	6a 00                	push   $0x0
80103015:	68 a0 00 00 00       	push   $0xa0
8010301a:	e8 17 ff ff ff       	call   80102f36 <lapicw>
8010301f:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103022:	6a 00                	push   $0x0
80103024:	6a 2c                	push   $0x2c
80103026:	e8 0b ff ff ff       	call   80102f36 <lapicw>
8010302b:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010302e:	6a 00                	push   $0x0
80103030:	68 c4 00 00 00       	push   $0xc4
80103035:	e8 fc fe ff ff       	call   80102f36 <lapicw>
8010303a:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010303d:	68 00 85 08 00       	push   $0x88500
80103042:	68 c0 00 00 00       	push   $0xc0
80103047:	e8 ea fe ff ff       	call   80102f36 <lapicw>
8010304c:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
8010304f:	90                   	nop
80103050:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80103055:	05 00 03 00 00       	add    $0x300,%eax
8010305a:	8b 00                	mov    (%eax),%eax
8010305c:	25 00 10 00 00       	and    $0x1000,%eax
80103061:	85 c0                	test   %eax,%eax
80103063:	75 eb                	jne    80103050 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103065:	6a 00                	push   $0x0
80103067:	6a 20                	push   $0x20
80103069:	e8 c8 fe ff ff       	call   80102f36 <lapicw>
8010306e:	83 c4 08             	add    $0x8,%esp
80103071:	eb 01                	jmp    80103074 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80103073:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103074:	c9                   	leave  
80103075:	c3                   	ret    

80103076 <cpunum>:

int
cpunum(void)
{
80103076:	55                   	push   %ebp
80103077:	89 e5                	mov    %esp,%ebp
80103079:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010307c:	e8 a5 fe ff ff       	call   80102f26 <readeflags>
80103081:	25 00 02 00 00       	and    $0x200,%eax
80103086:	85 c0                	test   %eax,%eax
80103088:	74 26                	je     801030b0 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010308a:	a1 60 d6 10 80       	mov    0x8010d660,%eax
8010308f:	8d 50 01             	lea    0x1(%eax),%edx
80103092:	89 15 60 d6 10 80    	mov    %edx,0x8010d660
80103098:	85 c0                	test   %eax,%eax
8010309a:	75 14                	jne    801030b0 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
8010309c:	8b 45 04             	mov    0x4(%ebp),%eax
8010309f:	83 ec 08             	sub    $0x8,%esp
801030a2:	50                   	push   %eax
801030a3:	68 30 9f 10 80       	push   $0x80109f30
801030a8:	e8 19 d3 ff ff       	call   801003c6 <cprintf>
801030ad:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801030b0:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030b5:	85 c0                	test   %eax,%eax
801030b7:	74 0f                	je     801030c8 <cpunum+0x52>
    return lapic[ID]>>24;
801030b9:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030be:	83 c0 20             	add    $0x20,%eax
801030c1:	8b 00                	mov    (%eax),%eax
801030c3:	c1 e8 18             	shr    $0x18,%eax
801030c6:	eb 05                	jmp    801030cd <cpunum+0x57>
  return 0;
801030c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801030cd:	c9                   	leave  
801030ce:	c3                   	ret    

801030cf <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801030cf:	55                   	push   %ebp
801030d0:	89 e5                	mov    %esp,%ebp
  if(lapic)
801030d2:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030d7:	85 c0                	test   %eax,%eax
801030d9:	74 0c                	je     801030e7 <lapiceoi+0x18>
    lapicw(EOI, 0);
801030db:	6a 00                	push   $0x0
801030dd:	6a 2c                	push   $0x2c
801030df:	e8 52 fe ff ff       	call   80102f36 <lapicw>
801030e4:	83 c4 08             	add    $0x8,%esp
}
801030e7:	90                   	nop
801030e8:	c9                   	leave  
801030e9:	c3                   	ret    

801030ea <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801030ea:	55                   	push   %ebp
801030eb:	89 e5                	mov    %esp,%ebp
}
801030ed:	90                   	nop
801030ee:	5d                   	pop    %ebp
801030ef:	c3                   	ret    

801030f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	83 ec 14             	sub    $0x14,%esp
801030f6:	8b 45 08             	mov    0x8(%ebp),%eax
801030f9:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801030fc:	6a 0f                	push   $0xf
801030fe:	6a 70                	push   $0x70
80103100:	e8 02 fe ff ff       	call   80102f07 <outb>
80103105:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103108:	6a 0a                	push   $0xa
8010310a:	6a 71                	push   $0x71
8010310c:	e8 f6 fd ff ff       	call   80102f07 <outb>
80103111:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103114:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010311b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010311e:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103123:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103126:	83 c0 02             	add    $0x2,%eax
80103129:	8b 55 0c             	mov    0xc(%ebp),%edx
8010312c:	c1 ea 04             	shr    $0x4,%edx
8010312f:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103132:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103136:	c1 e0 18             	shl    $0x18,%eax
80103139:	50                   	push   %eax
8010313a:	68 c4 00 00 00       	push   $0xc4
8010313f:	e8 f2 fd ff ff       	call   80102f36 <lapicw>
80103144:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103147:	68 00 c5 00 00       	push   $0xc500
8010314c:	68 c0 00 00 00       	push   $0xc0
80103151:	e8 e0 fd ff ff       	call   80102f36 <lapicw>
80103156:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103159:	68 c8 00 00 00       	push   $0xc8
8010315e:	e8 87 ff ff ff       	call   801030ea <microdelay>
80103163:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103166:	68 00 85 00 00       	push   $0x8500
8010316b:	68 c0 00 00 00       	push   $0xc0
80103170:	e8 c1 fd ff ff       	call   80102f36 <lapicw>
80103175:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103178:	6a 64                	push   $0x64
8010317a:	e8 6b ff ff ff       	call   801030ea <microdelay>
8010317f:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103182:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103189:	eb 3d                	jmp    801031c8 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010318b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010318f:	c1 e0 18             	shl    $0x18,%eax
80103192:	50                   	push   %eax
80103193:	68 c4 00 00 00       	push   $0xc4
80103198:	e8 99 fd ff ff       	call   80102f36 <lapicw>
8010319d:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801031a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801031a3:	c1 e8 0c             	shr    $0xc,%eax
801031a6:	80 cc 06             	or     $0x6,%ah
801031a9:	50                   	push   %eax
801031aa:	68 c0 00 00 00       	push   $0xc0
801031af:	e8 82 fd ff ff       	call   80102f36 <lapicw>
801031b4:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801031b7:	68 c8 00 00 00       	push   $0xc8
801031bc:	e8 29 ff ff ff       	call   801030ea <microdelay>
801031c1:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801031c4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801031c8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801031cc:	7e bd                	jle    8010318b <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801031ce:	90                   	nop
801031cf:	c9                   	leave  
801031d0:	c3                   	ret    

801031d1 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801031d1:	55                   	push   %ebp
801031d2:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801031d4:	8b 45 08             	mov    0x8(%ebp),%eax
801031d7:	0f b6 c0             	movzbl %al,%eax
801031da:	50                   	push   %eax
801031db:	6a 70                	push   $0x70
801031dd:	e8 25 fd ff ff       	call   80102f07 <outb>
801031e2:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031e5:	68 c8 00 00 00       	push   $0xc8
801031ea:	e8 fb fe ff ff       	call   801030ea <microdelay>
801031ef:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801031f2:	6a 71                	push   $0x71
801031f4:	e8 f1 fc ff ff       	call   80102eea <inb>
801031f9:	83 c4 04             	add    $0x4,%esp
801031fc:	0f b6 c0             	movzbl %al,%eax
}
801031ff:	c9                   	leave  
80103200:	c3                   	ret    

80103201 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103201:	55                   	push   %ebp
80103202:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103204:	6a 00                	push   $0x0
80103206:	e8 c6 ff ff ff       	call   801031d1 <cmos_read>
8010320b:	83 c4 04             	add    $0x4,%esp
8010320e:	89 c2                	mov    %eax,%edx
80103210:	8b 45 08             	mov    0x8(%ebp),%eax
80103213:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103215:	6a 02                	push   $0x2
80103217:	e8 b5 ff ff ff       	call   801031d1 <cmos_read>
8010321c:	83 c4 04             	add    $0x4,%esp
8010321f:	89 c2                	mov    %eax,%edx
80103221:	8b 45 08             	mov    0x8(%ebp),%eax
80103224:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103227:	6a 04                	push   $0x4
80103229:	e8 a3 ff ff ff       	call   801031d1 <cmos_read>
8010322e:	83 c4 04             	add    $0x4,%esp
80103231:	89 c2                	mov    %eax,%edx
80103233:	8b 45 08             	mov    0x8(%ebp),%eax
80103236:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103239:	6a 07                	push   $0x7
8010323b:	e8 91 ff ff ff       	call   801031d1 <cmos_read>
80103240:	83 c4 04             	add    $0x4,%esp
80103243:	89 c2                	mov    %eax,%edx
80103245:	8b 45 08             	mov    0x8(%ebp),%eax
80103248:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010324b:	6a 08                	push   $0x8
8010324d:	e8 7f ff ff ff       	call   801031d1 <cmos_read>
80103252:	83 c4 04             	add    $0x4,%esp
80103255:	89 c2                	mov    %eax,%edx
80103257:	8b 45 08             	mov    0x8(%ebp),%eax
8010325a:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010325d:	6a 09                	push   $0x9
8010325f:	e8 6d ff ff ff       	call   801031d1 <cmos_read>
80103264:	83 c4 04             	add    $0x4,%esp
80103267:	89 c2                	mov    %eax,%edx
80103269:	8b 45 08             	mov    0x8(%ebp),%eax
8010326c:	89 50 14             	mov    %edx,0x14(%eax)
}
8010326f:	90                   	nop
80103270:	c9                   	leave  
80103271:	c3                   	ret    

80103272 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103272:	55                   	push   %ebp
80103273:	89 e5                	mov    %esp,%ebp
80103275:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103278:	6a 0b                	push   $0xb
8010327a:	e8 52 ff ff ff       	call   801031d1 <cmos_read>
8010327f:	83 c4 04             	add    $0x4,%esp
80103282:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103288:	83 e0 04             	and    $0x4,%eax
8010328b:	85 c0                	test   %eax,%eax
8010328d:	0f 94 c0             	sete   %al
80103290:	0f b6 c0             	movzbl %al,%eax
80103293:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103296:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103299:	50                   	push   %eax
8010329a:	e8 62 ff ff ff       	call   80103201 <fill_rtcdate>
8010329f:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801032a2:	6a 0a                	push   $0xa
801032a4:	e8 28 ff ff ff       	call   801031d1 <cmos_read>
801032a9:	83 c4 04             	add    $0x4,%esp
801032ac:	25 80 00 00 00       	and    $0x80,%eax
801032b1:	85 c0                	test   %eax,%eax
801032b3:	75 27                	jne    801032dc <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801032b5:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032b8:	50                   	push   %eax
801032b9:	e8 43 ff ff ff       	call   80103201 <fill_rtcdate>
801032be:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801032c1:	83 ec 04             	sub    $0x4,%esp
801032c4:	6a 18                	push   $0x18
801032c6:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032c9:	50                   	push   %eax
801032ca:	8d 45 d8             	lea    -0x28(%ebp),%eax
801032cd:	50                   	push   %eax
801032ce:	e8 3d 36 00 00       	call   80106910 <memcmp>
801032d3:	83 c4 10             	add    $0x10,%esp
801032d6:	85 c0                	test   %eax,%eax
801032d8:	74 05                	je     801032df <cmostime+0x6d>
801032da:	eb ba                	jmp    80103296 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801032dc:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801032dd:	eb b7                	jmp    80103296 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801032df:	90                   	nop
  }

  // convert
  if (bcd) {
801032e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801032e4:	0f 84 b4 00 00 00    	je     8010339e <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032ed:	c1 e8 04             	shr    $0x4,%eax
801032f0:	89 c2                	mov    %eax,%edx
801032f2:	89 d0                	mov    %edx,%eax
801032f4:	c1 e0 02             	shl    $0x2,%eax
801032f7:	01 d0                	add    %edx,%eax
801032f9:	01 c0                	add    %eax,%eax
801032fb:	89 c2                	mov    %eax,%edx
801032fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103300:	83 e0 0f             	and    $0xf,%eax
80103303:	01 d0                	add    %edx,%eax
80103305:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103308:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010330b:	c1 e8 04             	shr    $0x4,%eax
8010330e:	89 c2                	mov    %eax,%edx
80103310:	89 d0                	mov    %edx,%eax
80103312:	c1 e0 02             	shl    $0x2,%eax
80103315:	01 d0                	add    %edx,%eax
80103317:	01 c0                	add    %eax,%eax
80103319:	89 c2                	mov    %eax,%edx
8010331b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010331e:	83 e0 0f             	and    $0xf,%eax
80103321:	01 d0                	add    %edx,%eax
80103323:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103326:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103329:	c1 e8 04             	shr    $0x4,%eax
8010332c:	89 c2                	mov    %eax,%edx
8010332e:	89 d0                	mov    %edx,%eax
80103330:	c1 e0 02             	shl    $0x2,%eax
80103333:	01 d0                	add    %edx,%eax
80103335:	01 c0                	add    %eax,%eax
80103337:	89 c2                	mov    %eax,%edx
80103339:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010333c:	83 e0 0f             	and    $0xf,%eax
8010333f:	01 d0                	add    %edx,%eax
80103341:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103344:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103347:	c1 e8 04             	shr    $0x4,%eax
8010334a:	89 c2                	mov    %eax,%edx
8010334c:	89 d0                	mov    %edx,%eax
8010334e:	c1 e0 02             	shl    $0x2,%eax
80103351:	01 d0                	add    %edx,%eax
80103353:	01 c0                	add    %eax,%eax
80103355:	89 c2                	mov    %eax,%edx
80103357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010335a:	83 e0 0f             	and    $0xf,%eax
8010335d:	01 d0                	add    %edx,%eax
8010335f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103362:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103365:	c1 e8 04             	shr    $0x4,%eax
80103368:	89 c2                	mov    %eax,%edx
8010336a:	89 d0                	mov    %edx,%eax
8010336c:	c1 e0 02             	shl    $0x2,%eax
8010336f:	01 d0                	add    %edx,%eax
80103371:	01 c0                	add    %eax,%eax
80103373:	89 c2                	mov    %eax,%edx
80103375:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103378:	83 e0 0f             	and    $0xf,%eax
8010337b:	01 d0                	add    %edx,%eax
8010337d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103380:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103383:	c1 e8 04             	shr    $0x4,%eax
80103386:	89 c2                	mov    %eax,%edx
80103388:	89 d0                	mov    %edx,%eax
8010338a:	c1 e0 02             	shl    $0x2,%eax
8010338d:	01 d0                	add    %edx,%eax
8010338f:	01 c0                	add    %eax,%eax
80103391:	89 c2                	mov    %eax,%edx
80103393:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103396:	83 e0 0f             	and    $0xf,%eax
80103399:	01 d0                	add    %edx,%eax
8010339b:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010339e:	8b 45 08             	mov    0x8(%ebp),%eax
801033a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
801033a4:	89 10                	mov    %edx,(%eax)
801033a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801033a9:	89 50 04             	mov    %edx,0x4(%eax)
801033ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
801033af:	89 50 08             	mov    %edx,0x8(%eax)
801033b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801033b5:	89 50 0c             	mov    %edx,0xc(%eax)
801033b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801033bb:	89 50 10             	mov    %edx,0x10(%eax)
801033be:	8b 55 ec             	mov    -0x14(%ebp),%edx
801033c1:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801033c4:	8b 45 08             	mov    0x8(%ebp),%eax
801033c7:	8b 40 14             	mov    0x14(%eax),%eax
801033ca:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801033d0:	8b 45 08             	mov    0x8(%ebp),%eax
801033d3:	89 50 14             	mov    %edx,0x14(%eax)
}
801033d6:	90                   	nop
801033d7:	c9                   	leave  
801033d8:	c3                   	ret    

801033d9 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801033d9:	55                   	push   %ebp
801033da:	89 e5                	mov    %esp,%ebp
801033dc:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801033df:	83 ec 08             	sub    $0x8,%esp
801033e2:	68 5c 9f 10 80       	push   $0x80109f5c
801033e7:	68 80 42 11 80       	push   $0x80114280
801033ec:	e8 33 32 00 00       	call   80106624 <initlock>
801033f1:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801033f4:	83 ec 08             	sub    $0x8,%esp
801033f7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033fa:	50                   	push   %eax
801033fb:	ff 75 08             	pushl  0x8(%ebp)
801033fe:	e8 2b e0 ff ff       	call   8010142e <readsb>
80103403:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103406:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103409:	a3 b4 42 11 80       	mov    %eax,0x801142b4
  log.size = sb.nlog;
8010340e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103411:	a3 b8 42 11 80       	mov    %eax,0x801142b8
  log.dev = dev;
80103416:	8b 45 08             	mov    0x8(%ebp),%eax
80103419:	a3 c4 42 11 80       	mov    %eax,0x801142c4
  recover_from_log();
8010341e:	e8 b2 01 00 00       	call   801035d5 <recover_from_log>
}
80103423:	90                   	nop
80103424:	c9                   	leave  
80103425:	c3                   	ret    

80103426 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103426:	55                   	push   %ebp
80103427:	89 e5                	mov    %esp,%ebp
80103429:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010342c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103433:	e9 95 00 00 00       	jmp    801034cd <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103438:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
8010343e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103441:	01 d0                	add    %edx,%eax
80103443:	83 c0 01             	add    $0x1,%eax
80103446:	89 c2                	mov    %eax,%edx
80103448:	a1 c4 42 11 80       	mov    0x801142c4,%eax
8010344d:	83 ec 08             	sub    $0x8,%esp
80103450:	52                   	push   %edx
80103451:	50                   	push   %eax
80103452:	e8 5f cd ff ff       	call   801001b6 <bread>
80103457:	83 c4 10             	add    $0x10,%esp
8010345a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010345d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103460:	83 c0 10             	add    $0x10,%eax
80103463:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
8010346a:	89 c2                	mov    %eax,%edx
8010346c:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103471:	83 ec 08             	sub    $0x8,%esp
80103474:	52                   	push   %edx
80103475:	50                   	push   %eax
80103476:	e8 3b cd ff ff       	call   801001b6 <bread>
8010347b:	83 c4 10             	add    $0x10,%esp
8010347e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103481:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103484:	8d 50 18             	lea    0x18(%eax),%edx
80103487:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010348a:	83 c0 18             	add    $0x18,%eax
8010348d:	83 ec 04             	sub    $0x4,%esp
80103490:	68 00 02 00 00       	push   $0x200
80103495:	52                   	push   %edx
80103496:	50                   	push   %eax
80103497:	e8 cc 34 00 00       	call   80106968 <memmove>
8010349c:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010349f:	83 ec 0c             	sub    $0xc,%esp
801034a2:	ff 75 ec             	pushl  -0x14(%ebp)
801034a5:	e8 45 cd ff ff       	call   801001ef <bwrite>
801034aa:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801034ad:	83 ec 0c             	sub    $0xc,%esp
801034b0:	ff 75 f0             	pushl  -0x10(%ebp)
801034b3:	e8 76 cd ff ff       	call   8010022e <brelse>
801034b8:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801034bb:	83 ec 0c             	sub    $0xc,%esp
801034be:	ff 75 ec             	pushl  -0x14(%ebp)
801034c1:	e8 68 cd ff ff       	call   8010022e <brelse>
801034c6:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034cd:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801034d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034d5:	0f 8f 5d ff ff ff    	jg     80103438 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801034db:	90                   	nop
801034dc:	c9                   	leave  
801034dd:	c3                   	ret    

801034de <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801034de:	55                   	push   %ebp
801034df:	89 e5                	mov    %esp,%ebp
801034e1:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034e4:	a1 b4 42 11 80       	mov    0x801142b4,%eax
801034e9:	89 c2                	mov    %eax,%edx
801034eb:	a1 c4 42 11 80       	mov    0x801142c4,%eax
801034f0:	83 ec 08             	sub    $0x8,%esp
801034f3:	52                   	push   %edx
801034f4:	50                   	push   %eax
801034f5:	e8 bc cc ff ff       	call   801001b6 <bread>
801034fa:	83 c4 10             	add    $0x10,%esp
801034fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103500:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103503:	83 c0 18             	add    $0x18,%eax
80103506:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103509:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010350c:	8b 00                	mov    (%eax),%eax
8010350e:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  for (i = 0; i < log.lh.n; i++) {
80103513:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010351a:	eb 1b                	jmp    80103537 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010351c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010351f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103522:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103526:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103529:	83 c2 10             	add    $0x10,%edx
8010352c:	89 04 95 8c 42 11 80 	mov    %eax,-0x7feebd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103533:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103537:	a1 c8 42 11 80       	mov    0x801142c8,%eax
8010353c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010353f:	7f db                	jg     8010351c <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103541:	83 ec 0c             	sub    $0xc,%esp
80103544:	ff 75 f0             	pushl  -0x10(%ebp)
80103547:	e8 e2 cc ff ff       	call   8010022e <brelse>
8010354c:	83 c4 10             	add    $0x10,%esp
}
8010354f:	90                   	nop
80103550:	c9                   	leave  
80103551:	c3                   	ret    

80103552 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103552:	55                   	push   %ebp
80103553:	89 e5                	mov    %esp,%ebp
80103555:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103558:	a1 b4 42 11 80       	mov    0x801142b4,%eax
8010355d:	89 c2                	mov    %eax,%edx
8010355f:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103564:	83 ec 08             	sub    $0x8,%esp
80103567:	52                   	push   %edx
80103568:	50                   	push   %eax
80103569:	e8 48 cc ff ff       	call   801001b6 <bread>
8010356e:	83 c4 10             	add    $0x10,%esp
80103571:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103574:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103577:	83 c0 18             	add    $0x18,%eax
8010357a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010357d:	8b 15 c8 42 11 80    	mov    0x801142c8,%edx
80103583:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103586:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103588:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010358f:	eb 1b                	jmp    801035ac <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103594:	83 c0 10             	add    $0x10,%eax
80103597:	8b 0c 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%ecx
8010359e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035a4:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801035a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035ac:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801035b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035b4:	7f db                	jg     80103591 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801035b6:	83 ec 0c             	sub    $0xc,%esp
801035b9:	ff 75 f0             	pushl  -0x10(%ebp)
801035bc:	e8 2e cc ff ff       	call   801001ef <bwrite>
801035c1:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801035c4:	83 ec 0c             	sub    $0xc,%esp
801035c7:	ff 75 f0             	pushl  -0x10(%ebp)
801035ca:	e8 5f cc ff ff       	call   8010022e <brelse>
801035cf:	83 c4 10             	add    $0x10,%esp
}
801035d2:	90                   	nop
801035d3:	c9                   	leave  
801035d4:	c3                   	ret    

801035d5 <recover_from_log>:

static void
recover_from_log(void)
{
801035d5:	55                   	push   %ebp
801035d6:	89 e5                	mov    %esp,%ebp
801035d8:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801035db:	e8 fe fe ff ff       	call   801034de <read_head>
  install_trans(); // if committed, copy from log to disk
801035e0:	e8 41 fe ff ff       	call   80103426 <install_trans>
  log.lh.n = 0;
801035e5:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
801035ec:	00 00 00 
  write_head(); // clear the log
801035ef:	e8 5e ff ff ff       	call   80103552 <write_head>
}
801035f4:	90                   	nop
801035f5:	c9                   	leave  
801035f6:	c3                   	ret    

801035f7 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801035f7:	55                   	push   %ebp
801035f8:	89 e5                	mov    %esp,%ebp
801035fa:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801035fd:	83 ec 0c             	sub    $0xc,%esp
80103600:	68 80 42 11 80       	push   $0x80114280
80103605:	e8 3c 30 00 00       	call   80106646 <acquire>
8010360a:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010360d:	a1 c0 42 11 80       	mov    0x801142c0,%eax
80103612:	85 c0                	test   %eax,%eax
80103614:	74 17                	je     8010362d <begin_op+0x36>
      sleep(&log, &log.lock);
80103616:	83 ec 08             	sub    $0x8,%esp
80103619:	68 80 42 11 80       	push   $0x80114280
8010361e:	68 80 42 11 80       	push   $0x80114280
80103623:	e8 90 1d 00 00       	call   801053b8 <sleep>
80103628:	83 c4 10             	add    $0x10,%esp
8010362b:	eb e0                	jmp    8010360d <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010362d:	8b 0d c8 42 11 80    	mov    0x801142c8,%ecx
80103633:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103638:	8d 50 01             	lea    0x1(%eax),%edx
8010363b:	89 d0                	mov    %edx,%eax
8010363d:	c1 e0 02             	shl    $0x2,%eax
80103640:	01 d0                	add    %edx,%eax
80103642:	01 c0                	add    %eax,%eax
80103644:	01 c8                	add    %ecx,%eax
80103646:	83 f8 1e             	cmp    $0x1e,%eax
80103649:	7e 17                	jle    80103662 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010364b:	83 ec 08             	sub    $0x8,%esp
8010364e:	68 80 42 11 80       	push   $0x80114280
80103653:	68 80 42 11 80       	push   $0x80114280
80103658:	e8 5b 1d 00 00       	call   801053b8 <sleep>
8010365d:	83 c4 10             	add    $0x10,%esp
80103660:	eb ab                	jmp    8010360d <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103662:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103667:	83 c0 01             	add    $0x1,%eax
8010366a:	a3 bc 42 11 80       	mov    %eax,0x801142bc
      release(&log.lock);
8010366f:	83 ec 0c             	sub    $0xc,%esp
80103672:	68 80 42 11 80       	push   $0x80114280
80103677:	e8 31 30 00 00       	call   801066ad <release>
8010367c:	83 c4 10             	add    $0x10,%esp
      break;
8010367f:	90                   	nop
    }
  }
}
80103680:	90                   	nop
80103681:	c9                   	leave  
80103682:	c3                   	ret    

80103683 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103683:	55                   	push   %ebp
80103684:	89 e5                	mov    %esp,%ebp
80103686:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103689:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	68 80 42 11 80       	push   $0x80114280
80103698:	e8 a9 2f 00 00       	call   80106646 <acquire>
8010369d:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801036a0:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801036a5:	83 e8 01             	sub    $0x1,%eax
801036a8:	a3 bc 42 11 80       	mov    %eax,0x801142bc
  if(log.committing)
801036ad:	a1 c0 42 11 80       	mov    0x801142c0,%eax
801036b2:	85 c0                	test   %eax,%eax
801036b4:	74 0d                	je     801036c3 <end_op+0x40>
    panic("log.committing");
801036b6:	83 ec 0c             	sub    $0xc,%esp
801036b9:	68 60 9f 10 80       	push   $0x80109f60
801036be:	e8 a3 ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801036c3:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801036c8:	85 c0                	test   %eax,%eax
801036ca:	75 13                	jne    801036df <end_op+0x5c>
    do_commit = 1;
801036cc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036d3:	c7 05 c0 42 11 80 01 	movl   $0x1,0x801142c0
801036da:	00 00 00 
801036dd:	eb 10                	jmp    801036ef <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801036df:	83 ec 0c             	sub    $0xc,%esp
801036e2:	68 80 42 11 80       	push   $0x80114280
801036e7:	e8 a5 1e 00 00       	call   80105591 <wakeup>
801036ec:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036ef:	83 ec 0c             	sub    $0xc,%esp
801036f2:	68 80 42 11 80       	push   $0x80114280
801036f7:	e8 b1 2f 00 00       	call   801066ad <release>
801036fc:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801036ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103703:	74 3f                	je     80103744 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103705:	e8 f5 00 00 00       	call   801037ff <commit>
    acquire(&log.lock);
8010370a:	83 ec 0c             	sub    $0xc,%esp
8010370d:	68 80 42 11 80       	push   $0x80114280
80103712:	e8 2f 2f 00 00       	call   80106646 <acquire>
80103717:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010371a:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
80103721:	00 00 00 
    wakeup(&log);
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 80 42 11 80       	push   $0x80114280
8010372c:	e8 60 1e 00 00       	call   80105591 <wakeup>
80103731:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103734:	83 ec 0c             	sub    $0xc,%esp
80103737:	68 80 42 11 80       	push   $0x80114280
8010373c:	e8 6c 2f 00 00       	call   801066ad <release>
80103741:	83 c4 10             	add    $0x10,%esp
  }
}
80103744:	90                   	nop
80103745:	c9                   	leave  
80103746:	c3                   	ret    

80103747 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103747:	55                   	push   %ebp
80103748:	89 e5                	mov    %esp,%ebp
8010374a:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010374d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103754:	e9 95 00 00 00       	jmp    801037ee <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103759:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
8010375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103762:	01 d0                	add    %edx,%eax
80103764:	83 c0 01             	add    $0x1,%eax
80103767:	89 c2                	mov    %eax,%edx
80103769:	a1 c4 42 11 80       	mov    0x801142c4,%eax
8010376e:	83 ec 08             	sub    $0x8,%esp
80103771:	52                   	push   %edx
80103772:	50                   	push   %eax
80103773:	e8 3e ca ff ff       	call   801001b6 <bread>
80103778:	83 c4 10             	add    $0x10,%esp
8010377b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010377e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103781:	83 c0 10             	add    $0x10,%eax
80103784:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
8010378b:	89 c2                	mov    %eax,%edx
8010378d:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103792:	83 ec 08             	sub    $0x8,%esp
80103795:	52                   	push   %edx
80103796:	50                   	push   %eax
80103797:	e8 1a ca ff ff       	call   801001b6 <bread>
8010379c:	83 c4 10             	add    $0x10,%esp
8010379f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801037a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037a5:	8d 50 18             	lea    0x18(%eax),%edx
801037a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ab:	83 c0 18             	add    $0x18,%eax
801037ae:	83 ec 04             	sub    $0x4,%esp
801037b1:	68 00 02 00 00       	push   $0x200
801037b6:	52                   	push   %edx
801037b7:	50                   	push   %eax
801037b8:	e8 ab 31 00 00       	call   80106968 <memmove>
801037bd:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	ff 75 f0             	pushl  -0x10(%ebp)
801037c6:	e8 24 ca ff ff       	call   801001ef <bwrite>
801037cb:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801037ce:	83 ec 0c             	sub    $0xc,%esp
801037d1:	ff 75 ec             	pushl  -0x14(%ebp)
801037d4:	e8 55 ca ff ff       	call   8010022e <brelse>
801037d9:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801037dc:	83 ec 0c             	sub    $0xc,%esp
801037df:	ff 75 f0             	pushl  -0x10(%ebp)
801037e2:	e8 47 ca ff ff       	call   8010022e <brelse>
801037e7:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037ee:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801037f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037f6:	0f 8f 5d ff ff ff    	jg     80103759 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801037fc:	90                   	nop
801037fd:	c9                   	leave  
801037fe:	c3                   	ret    

801037ff <commit>:

static void
commit()
{
801037ff:	55                   	push   %ebp
80103800:	89 e5                	mov    %esp,%ebp
80103802:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103805:	a1 c8 42 11 80       	mov    0x801142c8,%eax
8010380a:	85 c0                	test   %eax,%eax
8010380c:	7e 1e                	jle    8010382c <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010380e:	e8 34 ff ff ff       	call   80103747 <write_log>
    write_head();    // Write header to disk -- the real commit
80103813:	e8 3a fd ff ff       	call   80103552 <write_head>
    install_trans(); // Now install writes to home locations
80103818:	e8 09 fc ff ff       	call   80103426 <install_trans>
    log.lh.n = 0; 
8010381d:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
80103824:	00 00 00 
    write_head();    // Erase the transaction from the log
80103827:	e8 26 fd ff ff       	call   80103552 <write_head>
  }
}
8010382c:	90                   	nop
8010382d:	c9                   	leave  
8010382e:	c3                   	ret    

8010382f <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010382f:	55                   	push   %ebp
80103830:	89 e5                	mov    %esp,%ebp
80103832:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103835:	a1 c8 42 11 80       	mov    0x801142c8,%eax
8010383a:	83 f8 1d             	cmp    $0x1d,%eax
8010383d:	7f 12                	jg     80103851 <log_write+0x22>
8010383f:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103844:	8b 15 b8 42 11 80    	mov    0x801142b8,%edx
8010384a:	83 ea 01             	sub    $0x1,%edx
8010384d:	39 d0                	cmp    %edx,%eax
8010384f:	7c 0d                	jl     8010385e <log_write+0x2f>
    panic("too big a transaction");
80103851:	83 ec 0c             	sub    $0xc,%esp
80103854:	68 6f 9f 10 80       	push   $0x80109f6f
80103859:	e8 08 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010385e:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103863:	85 c0                	test   %eax,%eax
80103865:	7f 0d                	jg     80103874 <log_write+0x45>
    panic("log_write outside of trans");
80103867:	83 ec 0c             	sub    $0xc,%esp
8010386a:	68 85 9f 10 80       	push   $0x80109f85
8010386f:	e8 f2 cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103874:	83 ec 0c             	sub    $0xc,%esp
80103877:	68 80 42 11 80       	push   $0x80114280
8010387c:	e8 c5 2d 00 00       	call   80106646 <acquire>
80103881:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103884:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010388b:	eb 1d                	jmp    801038aa <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010388d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103890:	83 c0 10             	add    $0x10,%eax
80103893:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
8010389a:	89 c2                	mov    %eax,%edx
8010389c:	8b 45 08             	mov    0x8(%ebp),%eax
8010389f:	8b 40 08             	mov    0x8(%eax),%eax
801038a2:	39 c2                	cmp    %eax,%edx
801038a4:	74 10                	je     801038b6 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801038a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038aa:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038b2:	7f d9                	jg     8010388d <log_write+0x5e>
801038b4:	eb 01                	jmp    801038b7 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
801038b6:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801038b7:	8b 45 08             	mov    0x8(%ebp),%eax
801038ba:	8b 40 08             	mov    0x8(%eax),%eax
801038bd:	89 c2                	mov    %eax,%edx
801038bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038c2:	83 c0 10             	add    $0x10,%eax
801038c5:	89 14 85 8c 42 11 80 	mov    %edx,-0x7feebd74(,%eax,4)
  if (i == log.lh.n)
801038cc:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038d4:	75 0d                	jne    801038e3 <log_write+0xb4>
    log.lh.n++;
801038d6:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038db:	83 c0 01             	add    $0x1,%eax
801038de:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  b->flags |= B_DIRTY; // prevent eviction
801038e3:	8b 45 08             	mov    0x8(%ebp),%eax
801038e6:	8b 00                	mov    (%eax),%eax
801038e8:	83 c8 04             	or     $0x4,%eax
801038eb:	89 c2                	mov    %eax,%edx
801038ed:	8b 45 08             	mov    0x8(%ebp),%eax
801038f0:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038f2:	83 ec 0c             	sub    $0xc,%esp
801038f5:	68 80 42 11 80       	push   $0x80114280
801038fa:	e8 ae 2d 00 00       	call   801066ad <release>
801038ff:	83 c4 10             	add    $0x10,%esp
}
80103902:	90                   	nop
80103903:	c9                   	leave  
80103904:	c3                   	ret    

80103905 <v2p>:
80103905:	55                   	push   %ebp
80103906:	89 e5                	mov    %esp,%ebp
80103908:	8b 45 08             	mov    0x8(%ebp),%eax
8010390b:	05 00 00 00 80       	add    $0x80000000,%eax
80103910:	5d                   	pop    %ebp
80103911:	c3                   	ret    

80103912 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103912:	55                   	push   %ebp
80103913:	89 e5                	mov    %esp,%ebp
80103915:	8b 45 08             	mov    0x8(%ebp),%eax
80103918:	05 00 00 00 80       	add    $0x80000000,%eax
8010391d:	5d                   	pop    %ebp
8010391e:	c3                   	ret    

8010391f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010391f:	55                   	push   %ebp
80103920:	89 e5                	mov    %esp,%ebp
80103922:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103925:	8b 55 08             	mov    0x8(%ebp),%edx
80103928:	8b 45 0c             	mov    0xc(%ebp),%eax
8010392b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010392e:	f0 87 02             	lock xchg %eax,(%edx)
80103931:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103934:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103937:	c9                   	leave  
80103938:	c3                   	ret    

80103939 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103939:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010393d:	83 e4 f0             	and    $0xfffffff0,%esp
80103940:	ff 71 fc             	pushl  -0x4(%ecx)
80103943:	55                   	push   %ebp
80103944:	89 e5                	mov    %esp,%ebp
80103946:	51                   	push   %ecx
80103947:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010394a:	83 ec 08             	sub    $0x8,%esp
8010394d:	68 00 00 40 80       	push   $0x80400000
80103952:	68 5c 79 11 80       	push   $0x8011795c
80103957:	e8 7d f2 ff ff       	call   80102bd9 <kinit1>
8010395c:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
8010395f:	e8 0b 5c 00 00       	call   8010956f <kvmalloc>
  mpinit();        // collect info about this machine
80103964:	e8 43 04 00 00       	call   80103dac <mpinit>
  lapicinit();
80103969:	e8 ea f5 ff ff       	call   80102f58 <lapicinit>
  seginit();       // set up segments
8010396e:	e8 a5 55 00 00       	call   80108f18 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103973:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103979:	0f b6 00             	movzbl (%eax),%eax
8010397c:	0f b6 c0             	movzbl %al,%eax
8010397f:	83 ec 08             	sub    $0x8,%esp
80103982:	50                   	push   %eax
80103983:	68 a0 9f 10 80       	push   $0x80109fa0
80103988:	e8 39 ca ff ff       	call   801003c6 <cprintf>
8010398d:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103990:	e8 6d 06 00 00       	call   80104002 <picinit>
  ioapicinit();    // another interrupt controller
80103995:	e8 34 f1 ff ff       	call   80102ace <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010399a:	e8 24 d2 ff ff       	call   80100bc3 <consoleinit>
  uartinit();      // serial port
8010399f:	e8 d0 48 00 00       	call   80108274 <uartinit>
  pinit();         // process table
801039a4:	e8 5d 0b 00 00       	call   80104506 <pinit>
  tvinit();        // trap vectors
801039a9:	e8 c2 44 00 00       	call   80107e70 <tvinit>
  binit();         // buffer cache
801039ae:	e8 81 c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039b3:	e8 67 d6 ff ff       	call   8010101f <fileinit>
  ideinit();       // disk
801039b8:	e8 19 ed ff ff       	call   801026d6 <ideinit>
  if(!ismp)
801039bd:	a1 64 43 11 80       	mov    0x80114364,%eax
801039c2:	85 c0                	test   %eax,%eax
801039c4:	75 05                	jne    801039cb <main+0x92>
    timerinit();   // uniprocessor timer
801039c6:	e8 f6 43 00 00       	call   80107dc1 <timerinit>
  startothers();   // start other processors
801039cb:	e8 7f 00 00 00       	call   80103a4f <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039d0:	83 ec 08             	sub    $0x8,%esp
801039d3:	68 00 00 00 8e       	push   $0x8e000000
801039d8:	68 00 00 40 80       	push   $0x80400000
801039dd:	e8 30 f2 ff ff       	call   80102c12 <kinit2>
801039e2:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039e5:	e8 0d 0d 00 00       	call   801046f7 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801039ea:	e8 1a 00 00 00       	call   80103a09 <mpmain>

801039ef <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801039ef:	55                   	push   %ebp
801039f0:	89 e5                	mov    %esp,%ebp
801039f2:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801039f5:	e8 8d 5b 00 00       	call   80109587 <switchkvm>
  seginit();
801039fa:	e8 19 55 00 00       	call   80108f18 <seginit>
  lapicinit();
801039ff:	e8 54 f5 ff ff       	call   80102f58 <lapicinit>
  mpmain();
80103a04:	e8 00 00 00 00       	call   80103a09 <mpmain>

80103a09 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103a09:	55                   	push   %ebp
80103a0a:	89 e5                	mov    %esp,%ebp
80103a0c:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103a0f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a15:	0f b6 00             	movzbl (%eax),%eax
80103a18:	0f b6 c0             	movzbl %al,%eax
80103a1b:	83 ec 08             	sub    $0x8,%esp
80103a1e:	50                   	push   %eax
80103a1f:	68 b7 9f 10 80       	push   $0x80109fb7
80103a24:	e8 9d c9 ff ff       	call   801003c6 <cprintf>
80103a29:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a2c:	e8 a0 45 00 00       	call   80107fd1 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a31:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a37:	05 a8 00 00 00       	add    $0xa8,%eax
80103a3c:	83 ec 08             	sub    $0x8,%esp
80103a3f:	6a 01                	push   $0x1
80103a41:	50                   	push   %eax
80103a42:	e8 d8 fe ff ff       	call   8010391f <xchg>
80103a47:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a4a:	e8 ba 15 00 00       	call   80105009 <scheduler>

80103a4f <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103a4f:	55                   	push   %ebp
80103a50:	89 e5                	mov    %esp,%ebp
80103a52:	53                   	push   %ebx
80103a53:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103a56:	68 00 70 00 00       	push   $0x7000
80103a5b:	e8 b2 fe ff ff       	call   80103912 <p2v>
80103a60:	83 c4 04             	add    $0x4,%esp
80103a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a66:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a6b:	83 ec 04             	sub    $0x4,%esp
80103a6e:	50                   	push   %eax
80103a6f:	68 2c d5 10 80       	push   $0x8010d52c
80103a74:	ff 75 f0             	pushl  -0x10(%ebp)
80103a77:	e8 ec 2e 00 00       	call   80106968 <memmove>
80103a7c:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a7f:	c7 45 f4 80 43 11 80 	movl   $0x80114380,-0xc(%ebp)
80103a86:	e9 90 00 00 00       	jmp    80103b1b <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a8b:	e8 e6 f5 ff ff       	call   80103076 <cpunum>
80103a90:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a96:	05 80 43 11 80       	add    $0x80114380,%eax
80103a9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a9e:	74 73                	je     80103b13 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103aa0:	e8 6b f2 ff ff       	call   80102d10 <kalloc>
80103aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aab:	83 e8 04             	sub    $0x4,%eax
80103aae:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103ab1:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103ab7:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103abc:	83 e8 08             	sub    $0x8,%eax
80103abf:	c7 00 ef 39 10 80    	movl   $0x801039ef,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ac8:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103acb:	83 ec 0c             	sub    $0xc,%esp
80103ace:	68 00 c0 10 80       	push   $0x8010c000
80103ad3:	e8 2d fe ff ff       	call   80103905 <v2p>
80103ad8:	83 c4 10             	add    $0x10,%esp
80103adb:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103add:	83 ec 0c             	sub    $0xc,%esp
80103ae0:	ff 75 f0             	pushl  -0x10(%ebp)
80103ae3:	e8 1d fe ff ff       	call   80103905 <v2p>
80103ae8:	83 c4 10             	add    $0x10,%esp
80103aeb:	89 c2                	mov    %eax,%edx
80103aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af0:	0f b6 00             	movzbl (%eax),%eax
80103af3:	0f b6 c0             	movzbl %al,%eax
80103af6:	83 ec 08             	sub    $0x8,%esp
80103af9:	52                   	push   %edx
80103afa:	50                   	push   %eax
80103afb:	e8 f0 f5 ff ff       	call   801030f0 <lapicstartap>
80103b00:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103b03:	90                   	nop
80103b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b07:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103b0d:	85 c0                	test   %eax,%eax
80103b0f:	74 f3                	je     80103b04 <startothers+0xb5>
80103b11:	eb 01                	jmp    80103b14 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103b13:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103b14:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103b1b:	a1 60 49 11 80       	mov    0x80114960,%eax
80103b20:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b26:	05 80 43 11 80       	add    $0x80114380,%eax
80103b2b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b2e:	0f 87 57 ff ff ff    	ja     80103a8b <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103b34:	90                   	nop
80103b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b38:	c9                   	leave  
80103b39:	c3                   	ret    

80103b3a <p2v>:
80103b3a:	55                   	push   %ebp
80103b3b:	89 e5                	mov    %esp,%ebp
80103b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80103b40:	05 00 00 00 80       	add    $0x80000000,%eax
80103b45:	5d                   	pop    %ebp
80103b46:	c3                   	ret    

80103b47 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103b47:	55                   	push   %ebp
80103b48:	89 e5                	mov    %esp,%ebp
80103b4a:	83 ec 14             	sub    $0x14,%esp
80103b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80103b50:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b54:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103b58:	89 c2                	mov    %eax,%edx
80103b5a:	ec                   	in     (%dx),%al
80103b5b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b5e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103b62:	c9                   	leave  
80103b63:	c3                   	ret    

80103b64 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	83 ec 08             	sub    $0x8,%esp
80103b6a:	8b 55 08             	mov    0x8(%ebp),%edx
80103b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b70:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b74:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b77:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b7b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b7f:	ee                   	out    %al,(%dx)
}
80103b80:	90                   	nop
80103b81:	c9                   	leave  
80103b82:	c3                   	ret    

80103b83 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b83:	55                   	push   %ebp
80103b84:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b86:	a1 64 d6 10 80       	mov    0x8010d664,%eax
80103b8b:	89 c2                	mov    %eax,%edx
80103b8d:	b8 80 43 11 80       	mov    $0x80114380,%eax
80103b92:	29 c2                	sub    %eax,%edx
80103b94:	89 d0                	mov    %edx,%eax
80103b96:	c1 f8 02             	sar    $0x2,%eax
80103b99:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103b9f:	5d                   	pop    %ebp
80103ba0:	c3                   	ret    

80103ba1 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103ba1:	55                   	push   %ebp
80103ba2:	89 e5                	mov    %esp,%ebp
80103ba4:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103ba7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103bae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103bb5:	eb 15                	jmp    80103bcc <sum+0x2b>
    sum += addr[i];
80103bb7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103bba:	8b 45 08             	mov    0x8(%ebp),%eax
80103bbd:	01 d0                	add    %edx,%eax
80103bbf:	0f b6 00             	movzbl (%eax),%eax
80103bc2:	0f b6 c0             	movzbl %al,%eax
80103bc5:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103bc8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bcf:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103bd2:	7c e3                	jl     80103bb7 <sum+0x16>
    sum += addr[i];
  return sum;
80103bd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103bd7:	c9                   	leave  
80103bd8:	c3                   	ret    

80103bd9 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103bd9:	55                   	push   %ebp
80103bda:	89 e5                	mov    %esp,%ebp
80103bdc:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103bdf:	ff 75 08             	pushl  0x8(%ebp)
80103be2:	e8 53 ff ff ff       	call   80103b3a <p2v>
80103be7:	83 c4 04             	add    $0x4,%esp
80103bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103bed:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf3:	01 d0                	add    %edx,%eax
80103bf5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bfe:	eb 36                	jmp    80103c36 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c00:	83 ec 04             	sub    $0x4,%esp
80103c03:	6a 04                	push   $0x4
80103c05:	68 c8 9f 10 80       	push   $0x80109fc8
80103c0a:	ff 75 f4             	pushl  -0xc(%ebp)
80103c0d:	e8 fe 2c 00 00       	call   80106910 <memcmp>
80103c12:	83 c4 10             	add    $0x10,%esp
80103c15:	85 c0                	test   %eax,%eax
80103c17:	75 19                	jne    80103c32 <mpsearch1+0x59>
80103c19:	83 ec 08             	sub    $0x8,%esp
80103c1c:	6a 10                	push   $0x10
80103c1e:	ff 75 f4             	pushl  -0xc(%ebp)
80103c21:	e8 7b ff ff ff       	call   80103ba1 <sum>
80103c26:	83 c4 10             	add    $0x10,%esp
80103c29:	84 c0                	test   %al,%al
80103c2b:	75 05                	jne    80103c32 <mpsearch1+0x59>
      return (struct mp*)p;
80103c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c30:	eb 11                	jmp    80103c43 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103c32:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c39:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c3c:	72 c2                	jb     80103c00 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c43:	c9                   	leave  
80103c44:	c3                   	ret    

80103c45 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c45:	55                   	push   %ebp
80103c46:	89 e5                	mov    %esp,%ebp
80103c48:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c4b:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c55:	83 c0 0f             	add    $0xf,%eax
80103c58:	0f b6 00             	movzbl (%eax),%eax
80103c5b:	0f b6 c0             	movzbl %al,%eax
80103c5e:	c1 e0 08             	shl    $0x8,%eax
80103c61:	89 c2                	mov    %eax,%edx
80103c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c66:	83 c0 0e             	add    $0xe,%eax
80103c69:	0f b6 00             	movzbl (%eax),%eax
80103c6c:	0f b6 c0             	movzbl %al,%eax
80103c6f:	09 d0                	or     %edx,%eax
80103c71:	c1 e0 04             	shl    $0x4,%eax
80103c74:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c7b:	74 21                	je     80103c9e <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103c7d:	83 ec 08             	sub    $0x8,%esp
80103c80:	68 00 04 00 00       	push   $0x400
80103c85:	ff 75 f0             	pushl  -0x10(%ebp)
80103c88:	e8 4c ff ff ff       	call   80103bd9 <mpsearch1>
80103c8d:	83 c4 10             	add    $0x10,%esp
80103c90:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c97:	74 51                	je     80103cea <mpsearch+0xa5>
      return mp;
80103c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c9c:	eb 61                	jmp    80103cff <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca1:	83 c0 14             	add    $0x14,%eax
80103ca4:	0f b6 00             	movzbl (%eax),%eax
80103ca7:	0f b6 c0             	movzbl %al,%eax
80103caa:	c1 e0 08             	shl    $0x8,%eax
80103cad:	89 c2                	mov    %eax,%edx
80103caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb2:	83 c0 13             	add    $0x13,%eax
80103cb5:	0f b6 00             	movzbl (%eax),%eax
80103cb8:	0f b6 c0             	movzbl %al,%eax
80103cbb:	09 d0                	or     %edx,%eax
80103cbd:	c1 e0 0a             	shl    $0xa,%eax
80103cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cc6:	2d 00 04 00 00       	sub    $0x400,%eax
80103ccb:	83 ec 08             	sub    $0x8,%esp
80103cce:	68 00 04 00 00       	push   $0x400
80103cd3:	50                   	push   %eax
80103cd4:	e8 00 ff ff ff       	call   80103bd9 <mpsearch1>
80103cd9:	83 c4 10             	add    $0x10,%esp
80103cdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cdf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ce3:	74 05                	je     80103cea <mpsearch+0xa5>
      return mp;
80103ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ce8:	eb 15                	jmp    80103cff <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103cea:	83 ec 08             	sub    $0x8,%esp
80103ced:	68 00 00 01 00       	push   $0x10000
80103cf2:	68 00 00 0f 00       	push   $0xf0000
80103cf7:	e8 dd fe ff ff       	call   80103bd9 <mpsearch1>
80103cfc:	83 c4 10             	add    $0x10,%esp
}
80103cff:	c9                   	leave  
80103d00:	c3                   	ret    

80103d01 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103d01:	55                   	push   %ebp
80103d02:	89 e5                	mov    %esp,%ebp
80103d04:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d07:	e8 39 ff ff ff       	call   80103c45 <mpsearch>
80103d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d13:	74 0a                	je     80103d1f <mpconfig+0x1e>
80103d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d18:	8b 40 04             	mov    0x4(%eax),%eax
80103d1b:	85 c0                	test   %eax,%eax
80103d1d:	75 0a                	jne    80103d29 <mpconfig+0x28>
    return 0;
80103d1f:	b8 00 00 00 00       	mov    $0x0,%eax
80103d24:	e9 81 00 00 00       	jmp    80103daa <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d2c:	8b 40 04             	mov    0x4(%eax),%eax
80103d2f:	83 ec 0c             	sub    $0xc,%esp
80103d32:	50                   	push   %eax
80103d33:	e8 02 fe ff ff       	call   80103b3a <p2v>
80103d38:	83 c4 10             	add    $0x10,%esp
80103d3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d3e:	83 ec 04             	sub    $0x4,%esp
80103d41:	6a 04                	push   $0x4
80103d43:	68 cd 9f 10 80       	push   $0x80109fcd
80103d48:	ff 75 f0             	pushl  -0x10(%ebp)
80103d4b:	e8 c0 2b 00 00       	call   80106910 <memcmp>
80103d50:	83 c4 10             	add    $0x10,%esp
80103d53:	85 c0                	test   %eax,%eax
80103d55:	74 07                	je     80103d5e <mpconfig+0x5d>
    return 0;
80103d57:	b8 00 00 00 00       	mov    $0x0,%eax
80103d5c:	eb 4c                	jmp    80103daa <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d61:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d65:	3c 01                	cmp    $0x1,%al
80103d67:	74 12                	je     80103d7b <mpconfig+0x7a>
80103d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d6c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d70:	3c 04                	cmp    $0x4,%al
80103d72:	74 07                	je     80103d7b <mpconfig+0x7a>
    return 0;
80103d74:	b8 00 00 00 00       	mov    $0x0,%eax
80103d79:	eb 2f                	jmp    80103daa <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d7e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d82:	0f b7 c0             	movzwl %ax,%eax
80103d85:	83 ec 08             	sub    $0x8,%esp
80103d88:	50                   	push   %eax
80103d89:	ff 75 f0             	pushl  -0x10(%ebp)
80103d8c:	e8 10 fe ff ff       	call   80103ba1 <sum>
80103d91:	83 c4 10             	add    $0x10,%esp
80103d94:	84 c0                	test   %al,%al
80103d96:	74 07                	je     80103d9f <mpconfig+0x9e>
    return 0;
80103d98:	b8 00 00 00 00       	mov    $0x0,%eax
80103d9d:	eb 0b                	jmp    80103daa <mpconfig+0xa9>
  *pmp = mp;
80103d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103da2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103da5:	89 10                	mov    %edx,(%eax)
  return conf;
80103da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103daa:	c9                   	leave  
80103dab:	c3                   	ret    

80103dac <mpinit>:

void
mpinit(void)
{
80103dac:	55                   	push   %ebp
80103dad:	89 e5                	mov    %esp,%ebp
80103daf:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103db2:	c7 05 64 d6 10 80 80 	movl   $0x80114380,0x8010d664
80103db9:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103dbc:	83 ec 0c             	sub    $0xc,%esp
80103dbf:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103dc2:	50                   	push   %eax
80103dc3:	e8 39 ff ff ff       	call   80103d01 <mpconfig>
80103dc8:	83 c4 10             	add    $0x10,%esp
80103dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103dce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103dd2:	0f 84 96 01 00 00    	je     80103f6e <mpinit+0x1c2>
    return;
  ismp = 1;
80103dd8:	c7 05 64 43 11 80 01 	movl   $0x1,0x80114364
80103ddf:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de5:	8b 40 24             	mov    0x24(%eax),%eax
80103de8:	a3 7c 42 11 80       	mov    %eax,0x8011427c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df0:	83 c0 2c             	add    $0x2c,%eax
80103df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103dfd:	0f b7 d0             	movzwl %ax,%edx
80103e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e03:	01 d0                	add    %edx,%eax
80103e05:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e08:	e9 f2 00 00 00       	jmp    80103eff <mpinit+0x153>
    switch(*p){
80103e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e10:	0f b6 00             	movzbl (%eax),%eax
80103e13:	0f b6 c0             	movzbl %al,%eax
80103e16:	83 f8 04             	cmp    $0x4,%eax
80103e19:	0f 87 bc 00 00 00    	ja     80103edb <mpinit+0x12f>
80103e1f:	8b 04 85 10 a0 10 80 	mov    -0x7fef5ff0(,%eax,4),%eax
80103e26:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e31:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e35:	0f b6 d0             	movzbl %al,%edx
80103e38:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e3d:	39 c2                	cmp    %eax,%edx
80103e3f:	74 2b                	je     80103e6c <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e41:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e44:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e48:	0f b6 d0             	movzbl %al,%edx
80103e4b:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e50:	83 ec 04             	sub    $0x4,%esp
80103e53:	52                   	push   %edx
80103e54:	50                   	push   %eax
80103e55:	68 d2 9f 10 80       	push   $0x80109fd2
80103e5a:	e8 67 c5 ff ff       	call   801003c6 <cprintf>
80103e5f:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e62:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
80103e69:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e6f:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103e73:	0f b6 c0             	movzbl %al,%eax
80103e76:	83 e0 02             	and    $0x2,%eax
80103e79:	85 c0                	test   %eax,%eax
80103e7b:	74 15                	je     80103e92 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103e7d:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e82:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e88:	05 80 43 11 80       	add    $0x80114380,%eax
80103e8d:	a3 64 d6 10 80       	mov    %eax,0x8010d664
      cpus[ncpu].id = ncpu;
80103e92:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e97:	8b 15 60 49 11 80    	mov    0x80114960,%edx
80103e9d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ea3:	05 80 43 11 80       	add    $0x80114380,%eax
80103ea8:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103eaa:	a1 60 49 11 80       	mov    0x80114960,%eax
80103eaf:	83 c0 01             	add    $0x1,%eax
80103eb2:	a3 60 49 11 80       	mov    %eax,0x80114960
      p += sizeof(struct mpproc);
80103eb7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ebb:	eb 42                	jmp    80103eff <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ec6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103eca:	a2 60 43 11 80       	mov    %al,0x80114360
      p += sizeof(struct mpioapic);
80103ecf:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ed3:	eb 2a                	jmp    80103eff <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ed5:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ed9:	eb 24                	jmp    80103eff <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ede:	0f b6 00             	movzbl (%eax),%eax
80103ee1:	0f b6 c0             	movzbl %al,%eax
80103ee4:	83 ec 08             	sub    $0x8,%esp
80103ee7:	50                   	push   %eax
80103ee8:	68 f0 9f 10 80       	push   $0x80109ff0
80103eed:	e8 d4 c4 ff ff       	call   801003c6 <cprintf>
80103ef2:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103ef5:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
80103efc:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103f05:	0f 82 02 ff ff ff    	jb     80103e0d <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103f0b:	a1 64 43 11 80       	mov    0x80114364,%eax
80103f10:	85 c0                	test   %eax,%eax
80103f12:	75 1d                	jne    80103f31 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f14:	c7 05 60 49 11 80 01 	movl   $0x1,0x80114960
80103f1b:	00 00 00 
    lapic = 0;
80103f1e:	c7 05 7c 42 11 80 00 	movl   $0x0,0x8011427c
80103f25:	00 00 00 
    ioapicid = 0;
80103f28:	c6 05 60 43 11 80 00 	movb   $0x0,0x80114360
    return;
80103f2f:	eb 3e                	jmp    80103f6f <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103f31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f34:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f38:	84 c0                	test   %al,%al
80103f3a:	74 33                	je     80103f6f <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f3c:	83 ec 08             	sub    $0x8,%esp
80103f3f:	6a 70                	push   $0x70
80103f41:	6a 22                	push   $0x22
80103f43:	e8 1c fc ff ff       	call   80103b64 <outb>
80103f48:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f4b:	83 ec 0c             	sub    $0xc,%esp
80103f4e:	6a 23                	push   $0x23
80103f50:	e8 f2 fb ff ff       	call   80103b47 <inb>
80103f55:	83 c4 10             	add    $0x10,%esp
80103f58:	83 c8 01             	or     $0x1,%eax
80103f5b:	0f b6 c0             	movzbl %al,%eax
80103f5e:	83 ec 08             	sub    $0x8,%esp
80103f61:	50                   	push   %eax
80103f62:	6a 23                	push   $0x23
80103f64:	e8 fb fb ff ff       	call   80103b64 <outb>
80103f69:	83 c4 10             	add    $0x10,%esp
80103f6c:	eb 01                	jmp    80103f6f <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103f6e:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103f6f:	c9                   	leave  
80103f70:	c3                   	ret    

80103f71 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103f71:	55                   	push   %ebp
80103f72:	89 e5                	mov    %esp,%ebp
80103f74:	83 ec 08             	sub    $0x8,%esp
80103f77:	8b 55 08             	mov    0x8(%ebp),%edx
80103f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f7d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103f81:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f84:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f88:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f8c:	ee                   	out    %al,(%dx)
}
80103f8d:	90                   	nop
80103f8e:	c9                   	leave  
80103f8f:	c3                   	ret    

80103f90 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	83 ec 04             	sub    $0x4,%esp
80103f96:	8b 45 08             	mov    0x8(%ebp),%eax
80103f99:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f9d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fa1:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80103fa7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fab:	0f b6 c0             	movzbl %al,%eax
80103fae:	50                   	push   %eax
80103faf:	6a 21                	push   $0x21
80103fb1:	e8 bb ff ff ff       	call   80103f71 <outb>
80103fb6:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103fb9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fbd:	66 c1 e8 08          	shr    $0x8,%ax
80103fc1:	0f b6 c0             	movzbl %al,%eax
80103fc4:	50                   	push   %eax
80103fc5:	68 a1 00 00 00       	push   $0xa1
80103fca:	e8 a2 ff ff ff       	call   80103f71 <outb>
80103fcf:	83 c4 08             	add    $0x8,%esp
}
80103fd2:	90                   	nop
80103fd3:	c9                   	leave  
80103fd4:	c3                   	ret    

80103fd5 <picenable>:

void
picenable(int irq)
{
80103fd5:	55                   	push   %ebp
80103fd6:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdb:	ba 01 00 00 00       	mov    $0x1,%edx
80103fe0:	89 c1                	mov    %eax,%ecx
80103fe2:	d3 e2                	shl    %cl,%edx
80103fe4:	89 d0                	mov    %edx,%eax
80103fe6:	f7 d0                	not    %eax
80103fe8:	89 c2                	mov    %eax,%edx
80103fea:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80103ff1:	21 d0                	and    %edx,%eax
80103ff3:	0f b7 c0             	movzwl %ax,%eax
80103ff6:	50                   	push   %eax
80103ff7:	e8 94 ff ff ff       	call   80103f90 <picsetmask>
80103ffc:	83 c4 04             	add    $0x4,%esp
}
80103fff:	90                   	nop
80104000:	c9                   	leave  
80104001:	c3                   	ret    

80104002 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104002:	55                   	push   %ebp
80104003:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104005:	68 ff 00 00 00       	push   $0xff
8010400a:	6a 21                	push   $0x21
8010400c:	e8 60 ff ff ff       	call   80103f71 <outb>
80104011:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104014:	68 ff 00 00 00       	push   $0xff
80104019:	68 a1 00 00 00       	push   $0xa1
8010401e:	e8 4e ff ff ff       	call   80103f71 <outb>
80104023:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104026:	6a 11                	push   $0x11
80104028:	6a 20                	push   $0x20
8010402a:	e8 42 ff ff ff       	call   80103f71 <outb>
8010402f:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104032:	6a 20                	push   $0x20
80104034:	6a 21                	push   $0x21
80104036:	e8 36 ff ff ff       	call   80103f71 <outb>
8010403b:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010403e:	6a 04                	push   $0x4
80104040:	6a 21                	push   $0x21
80104042:	e8 2a ff ff ff       	call   80103f71 <outb>
80104047:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
8010404a:	6a 03                	push   $0x3
8010404c:	6a 21                	push   $0x21
8010404e:	e8 1e ff ff ff       	call   80103f71 <outb>
80104053:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104056:	6a 11                	push   $0x11
80104058:	68 a0 00 00 00       	push   $0xa0
8010405d:	e8 0f ff ff ff       	call   80103f71 <outb>
80104062:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104065:	6a 28                	push   $0x28
80104067:	68 a1 00 00 00       	push   $0xa1
8010406c:	e8 00 ff ff ff       	call   80103f71 <outb>
80104071:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104074:	6a 02                	push   $0x2
80104076:	68 a1 00 00 00       	push   $0xa1
8010407b:	e8 f1 fe ff ff       	call   80103f71 <outb>
80104080:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104083:	6a 03                	push   $0x3
80104085:	68 a1 00 00 00       	push   $0xa1
8010408a:	e8 e2 fe ff ff       	call   80103f71 <outb>
8010408f:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104092:	6a 68                	push   $0x68
80104094:	6a 20                	push   $0x20
80104096:	e8 d6 fe ff ff       	call   80103f71 <outb>
8010409b:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
8010409e:	6a 0a                	push   $0xa
801040a0:	6a 20                	push   $0x20
801040a2:	e8 ca fe ff ff       	call   80103f71 <outb>
801040a7:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
801040aa:	6a 68                	push   $0x68
801040ac:	68 a0 00 00 00       	push   $0xa0
801040b1:	e8 bb fe ff ff       	call   80103f71 <outb>
801040b6:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801040b9:	6a 0a                	push   $0xa
801040bb:	68 a0 00 00 00       	push   $0xa0
801040c0:	e8 ac fe ff ff       	call   80103f71 <outb>
801040c5:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801040c8:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801040cf:	66 83 f8 ff          	cmp    $0xffff,%ax
801040d3:	74 13                	je     801040e8 <picinit+0xe6>
    picsetmask(irqmask);
801040d5:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801040dc:	0f b7 c0             	movzwl %ax,%eax
801040df:	50                   	push   %eax
801040e0:	e8 ab fe ff ff       	call   80103f90 <picsetmask>
801040e5:	83 c4 04             	add    $0x4,%esp
}
801040e8:	90                   	nop
801040e9:	c9                   	leave  
801040ea:	c3                   	ret    

801040eb <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801040eb:	55                   	push   %ebp
801040ec:	89 e5                	mov    %esp,%ebp
801040ee:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801040f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801040f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801040fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104101:	8b 45 0c             	mov    0xc(%ebp),%eax
80104104:	8b 10                	mov    (%eax),%edx
80104106:	8b 45 08             	mov    0x8(%ebp),%eax
80104109:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010410b:	e8 2d cf ff ff       	call   8010103d <filealloc>
80104110:	89 c2                	mov    %eax,%edx
80104112:	8b 45 08             	mov    0x8(%ebp),%eax
80104115:	89 10                	mov    %edx,(%eax)
80104117:	8b 45 08             	mov    0x8(%ebp),%eax
8010411a:	8b 00                	mov    (%eax),%eax
8010411c:	85 c0                	test   %eax,%eax
8010411e:	0f 84 cb 00 00 00    	je     801041ef <pipealloc+0x104>
80104124:	e8 14 cf ff ff       	call   8010103d <filealloc>
80104129:	89 c2                	mov    %eax,%edx
8010412b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010412e:	89 10                	mov    %edx,(%eax)
80104130:	8b 45 0c             	mov    0xc(%ebp),%eax
80104133:	8b 00                	mov    (%eax),%eax
80104135:	85 c0                	test   %eax,%eax
80104137:	0f 84 b2 00 00 00    	je     801041ef <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010413d:	e8 ce eb ff ff       	call   80102d10 <kalloc>
80104142:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104145:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104149:	0f 84 9f 00 00 00    	je     801041ee <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
8010414f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104152:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104159:	00 00 00 
  p->writeopen = 1;
8010415c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010415f:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104166:	00 00 00 
  p->nwrite = 0;
80104169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416c:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104173:	00 00 00 
  p->nread = 0;
80104176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104179:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104180:	00 00 00 
  initlock(&p->lock, "pipe");
80104183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104186:	83 ec 08             	sub    $0x8,%esp
80104189:	68 24 a0 10 80       	push   $0x8010a024
8010418e:	50                   	push   %eax
8010418f:	e8 90 24 00 00       	call   80106624 <initlock>
80104194:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104197:	8b 45 08             	mov    0x8(%ebp),%eax
8010419a:	8b 00                	mov    (%eax),%eax
8010419c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801041a2:	8b 45 08             	mov    0x8(%ebp),%eax
801041a5:	8b 00                	mov    (%eax),%eax
801041a7:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801041ab:	8b 45 08             	mov    0x8(%ebp),%eax
801041ae:	8b 00                	mov    (%eax),%eax
801041b0:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801041b4:	8b 45 08             	mov    0x8(%ebp),%eax
801041b7:	8b 00                	mov    (%eax),%eax
801041b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041bc:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801041bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c2:	8b 00                	mov    (%eax),%eax
801041c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801041ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801041cd:	8b 00                	mov    (%eax),%eax
801041cf:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801041d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d6:	8b 00                	mov    (%eax),%eax
801041d8:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801041dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801041df:	8b 00                	mov    (%eax),%eax
801041e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e4:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801041e7:	b8 00 00 00 00       	mov    $0x0,%eax
801041ec:	eb 4e                	jmp    8010423c <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801041ee:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
801041ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041f3:	74 0e                	je     80104203 <pipealloc+0x118>
    kfree((char*)p);
801041f5:	83 ec 0c             	sub    $0xc,%esp
801041f8:	ff 75 f4             	pushl  -0xc(%ebp)
801041fb:	e8 73 ea ff ff       	call   80102c73 <kfree>
80104200:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104203:	8b 45 08             	mov    0x8(%ebp),%eax
80104206:	8b 00                	mov    (%eax),%eax
80104208:	85 c0                	test   %eax,%eax
8010420a:	74 11                	je     8010421d <pipealloc+0x132>
    fileclose(*f0);
8010420c:	8b 45 08             	mov    0x8(%ebp),%eax
8010420f:	8b 00                	mov    (%eax),%eax
80104211:	83 ec 0c             	sub    $0xc,%esp
80104214:	50                   	push   %eax
80104215:	e8 e1 ce ff ff       	call   801010fb <fileclose>
8010421a:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010421d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104220:	8b 00                	mov    (%eax),%eax
80104222:	85 c0                	test   %eax,%eax
80104224:	74 11                	je     80104237 <pipealloc+0x14c>
    fileclose(*f1);
80104226:	8b 45 0c             	mov    0xc(%ebp),%eax
80104229:	8b 00                	mov    (%eax),%eax
8010422b:	83 ec 0c             	sub    $0xc,%esp
8010422e:	50                   	push   %eax
8010422f:	e8 c7 ce ff ff       	call   801010fb <fileclose>
80104234:	83 c4 10             	add    $0x10,%esp
  return -1;
80104237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010423c:	c9                   	leave  
8010423d:	c3                   	ret    

8010423e <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010423e:	55                   	push   %ebp
8010423f:	89 e5                	mov    %esp,%ebp
80104241:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104244:	8b 45 08             	mov    0x8(%ebp),%eax
80104247:	83 ec 0c             	sub    $0xc,%esp
8010424a:	50                   	push   %eax
8010424b:	e8 f6 23 00 00       	call   80106646 <acquire>
80104250:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104253:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104257:	74 23                	je     8010427c <pipeclose+0x3e>
    p->writeopen = 0;
80104259:	8b 45 08             	mov    0x8(%ebp),%eax
8010425c:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104263:	00 00 00 
    wakeup(&p->nread);
80104266:	8b 45 08             	mov    0x8(%ebp),%eax
80104269:	05 34 02 00 00       	add    $0x234,%eax
8010426e:	83 ec 0c             	sub    $0xc,%esp
80104271:	50                   	push   %eax
80104272:	e8 1a 13 00 00       	call   80105591 <wakeup>
80104277:	83 c4 10             	add    $0x10,%esp
8010427a:	eb 21                	jmp    8010429d <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010427c:	8b 45 08             	mov    0x8(%ebp),%eax
8010427f:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104286:	00 00 00 
    wakeup(&p->nwrite);
80104289:	8b 45 08             	mov    0x8(%ebp),%eax
8010428c:	05 38 02 00 00       	add    $0x238,%eax
80104291:	83 ec 0c             	sub    $0xc,%esp
80104294:	50                   	push   %eax
80104295:	e8 f7 12 00 00       	call   80105591 <wakeup>
8010429a:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010429d:	8b 45 08             	mov    0x8(%ebp),%eax
801042a0:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042a6:	85 c0                	test   %eax,%eax
801042a8:	75 2c                	jne    801042d6 <pipeclose+0x98>
801042aa:	8b 45 08             	mov    0x8(%ebp),%eax
801042ad:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042b3:	85 c0                	test   %eax,%eax
801042b5:	75 1f                	jne    801042d6 <pipeclose+0x98>
    release(&p->lock);
801042b7:	8b 45 08             	mov    0x8(%ebp),%eax
801042ba:	83 ec 0c             	sub    $0xc,%esp
801042bd:	50                   	push   %eax
801042be:	e8 ea 23 00 00       	call   801066ad <release>
801042c3:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801042c6:	83 ec 0c             	sub    $0xc,%esp
801042c9:	ff 75 08             	pushl  0x8(%ebp)
801042cc:	e8 a2 e9 ff ff       	call   80102c73 <kfree>
801042d1:	83 c4 10             	add    $0x10,%esp
801042d4:	eb 0f                	jmp    801042e5 <pipeclose+0xa7>
  } else
    release(&p->lock);
801042d6:	8b 45 08             	mov    0x8(%ebp),%eax
801042d9:	83 ec 0c             	sub    $0xc,%esp
801042dc:	50                   	push   %eax
801042dd:	e8 cb 23 00 00       	call   801066ad <release>
801042e2:	83 c4 10             	add    $0x10,%esp
}
801042e5:	90                   	nop
801042e6:	c9                   	leave  
801042e7:	c3                   	ret    

801042e8 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801042e8:	55                   	push   %ebp
801042e9:	89 e5                	mov    %esp,%ebp
801042eb:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042ee:	8b 45 08             	mov    0x8(%ebp),%eax
801042f1:	83 ec 0c             	sub    $0xc,%esp
801042f4:	50                   	push   %eax
801042f5:	e8 4c 23 00 00       	call   80106646 <acquire>
801042fa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801042fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104304:	e9 ad 00 00 00       	jmp    801043b6 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104309:	8b 45 08             	mov    0x8(%ebp),%eax
8010430c:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104312:	85 c0                	test   %eax,%eax
80104314:	74 0d                	je     80104323 <pipewrite+0x3b>
80104316:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010431c:	8b 40 24             	mov    0x24(%eax),%eax
8010431f:	85 c0                	test   %eax,%eax
80104321:	74 19                	je     8010433c <pipewrite+0x54>
        release(&p->lock);
80104323:	8b 45 08             	mov    0x8(%ebp),%eax
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	50                   	push   %eax
8010432a:	e8 7e 23 00 00       	call   801066ad <release>
8010432f:	83 c4 10             	add    $0x10,%esp
        return -1;
80104332:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104337:	e9 a8 00 00 00       	jmp    801043e4 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
8010433c:	8b 45 08             	mov    0x8(%ebp),%eax
8010433f:	05 34 02 00 00       	add    $0x234,%eax
80104344:	83 ec 0c             	sub    $0xc,%esp
80104347:	50                   	push   %eax
80104348:	e8 44 12 00 00       	call   80105591 <wakeup>
8010434d:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104350:	8b 45 08             	mov    0x8(%ebp),%eax
80104353:	8b 55 08             	mov    0x8(%ebp),%edx
80104356:	81 c2 38 02 00 00    	add    $0x238,%edx
8010435c:	83 ec 08             	sub    $0x8,%esp
8010435f:	50                   	push   %eax
80104360:	52                   	push   %edx
80104361:	e8 52 10 00 00       	call   801053b8 <sleep>
80104366:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104369:	8b 45 08             	mov    0x8(%ebp),%eax
8010436c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104372:	8b 45 08             	mov    0x8(%ebp),%eax
80104375:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010437b:	05 00 02 00 00       	add    $0x200,%eax
80104380:	39 c2                	cmp    %eax,%edx
80104382:	74 85                	je     80104309 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104384:	8b 45 08             	mov    0x8(%ebp),%eax
80104387:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010438d:	8d 48 01             	lea    0x1(%eax),%ecx
80104390:	8b 55 08             	mov    0x8(%ebp),%edx
80104393:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104399:	25 ff 01 00 00       	and    $0x1ff,%eax
8010439e:	89 c1                	mov    %eax,%ecx
801043a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801043a6:	01 d0                	add    %edx,%eax
801043a8:	0f b6 10             	movzbl (%eax),%edx
801043ab:	8b 45 08             	mov    0x8(%ebp),%eax
801043ae:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801043b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b9:	3b 45 10             	cmp    0x10(%ebp),%eax
801043bc:	7c ab                	jl     80104369 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043be:	8b 45 08             	mov    0x8(%ebp),%eax
801043c1:	05 34 02 00 00       	add    $0x234,%eax
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	50                   	push   %eax
801043ca:	e8 c2 11 00 00       	call   80105591 <wakeup>
801043cf:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043d2:	8b 45 08             	mov    0x8(%ebp),%eax
801043d5:	83 ec 0c             	sub    $0xc,%esp
801043d8:	50                   	push   %eax
801043d9:	e8 cf 22 00 00       	call   801066ad <release>
801043de:	83 c4 10             	add    $0x10,%esp
  return n;
801043e1:	8b 45 10             	mov    0x10(%ebp),%eax
}
801043e4:	c9                   	leave  
801043e5:	c3                   	ret    

801043e6 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801043e6:	55                   	push   %ebp
801043e7:	89 e5                	mov    %esp,%ebp
801043e9:	53                   	push   %ebx
801043ea:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801043ed:	8b 45 08             	mov    0x8(%ebp),%eax
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	50                   	push   %eax
801043f4:	e8 4d 22 00 00       	call   80106646 <acquire>
801043f9:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043fc:	eb 3f                	jmp    8010443d <piperead+0x57>
    if(proc->killed){
801043fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104404:	8b 40 24             	mov    0x24(%eax),%eax
80104407:	85 c0                	test   %eax,%eax
80104409:	74 19                	je     80104424 <piperead+0x3e>
      release(&p->lock);
8010440b:	8b 45 08             	mov    0x8(%ebp),%eax
8010440e:	83 ec 0c             	sub    $0xc,%esp
80104411:	50                   	push   %eax
80104412:	e8 96 22 00 00       	call   801066ad <release>
80104417:	83 c4 10             	add    $0x10,%esp
      return -1;
8010441a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010441f:	e9 bf 00 00 00       	jmp    801044e3 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104424:	8b 45 08             	mov    0x8(%ebp),%eax
80104427:	8b 55 08             	mov    0x8(%ebp),%edx
8010442a:	81 c2 34 02 00 00    	add    $0x234,%edx
80104430:	83 ec 08             	sub    $0x8,%esp
80104433:	50                   	push   %eax
80104434:	52                   	push   %edx
80104435:	e8 7e 0f 00 00       	call   801053b8 <sleep>
8010443a:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010443d:	8b 45 08             	mov    0x8(%ebp),%eax
80104440:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104446:	8b 45 08             	mov    0x8(%ebp),%eax
80104449:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010444f:	39 c2                	cmp    %eax,%edx
80104451:	75 0d                	jne    80104460 <piperead+0x7a>
80104453:	8b 45 08             	mov    0x8(%ebp),%eax
80104456:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010445c:	85 c0                	test   %eax,%eax
8010445e:	75 9e                	jne    801043fe <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104460:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104467:	eb 49                	jmp    801044b2 <piperead+0xcc>
    if(p->nread == p->nwrite)
80104469:	8b 45 08             	mov    0x8(%ebp),%eax
8010446c:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104472:	8b 45 08             	mov    0x8(%ebp),%eax
80104475:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010447b:	39 c2                	cmp    %eax,%edx
8010447d:	74 3d                	je     801044bc <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010447f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104482:	8b 45 0c             	mov    0xc(%ebp),%eax
80104485:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104488:	8b 45 08             	mov    0x8(%ebp),%eax
8010448b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104491:	8d 48 01             	lea    0x1(%eax),%ecx
80104494:	8b 55 08             	mov    0x8(%ebp),%edx
80104497:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010449d:	25 ff 01 00 00       	and    $0x1ff,%eax
801044a2:	89 c2                	mov    %eax,%edx
801044a4:	8b 45 08             	mov    0x8(%ebp),%eax
801044a7:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801044ac:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b5:	3b 45 10             	cmp    0x10(%ebp),%eax
801044b8:	7c af                	jl     80104469 <piperead+0x83>
801044ba:	eb 01                	jmp    801044bd <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801044bc:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044bd:	8b 45 08             	mov    0x8(%ebp),%eax
801044c0:	05 38 02 00 00       	add    $0x238,%eax
801044c5:	83 ec 0c             	sub    $0xc,%esp
801044c8:	50                   	push   %eax
801044c9:	e8 c3 10 00 00       	call   80105591 <wakeup>
801044ce:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044d1:	8b 45 08             	mov    0x8(%ebp),%eax
801044d4:	83 ec 0c             	sub    $0xc,%esp
801044d7:	50                   	push   %eax
801044d8:	e8 d0 21 00 00       	call   801066ad <release>
801044dd:	83 c4 10             	add    $0x10,%esp
  return i;
801044e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e6:	c9                   	leave  
801044e7:	c3                   	ret    

801044e8 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
801044e8:	55                   	push   %ebp
801044e9:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
801044eb:	f4                   	hlt    
}
801044ec:	90                   	nop
801044ed:	5d                   	pop    %ebp
801044ee:	c3                   	ret    

801044ef <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801044ef:	55                   	push   %ebp
801044f0:	89 e5                	mov    %esp,%ebp
801044f2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044f5:	9c                   	pushf  
801044f6:	58                   	pop    %eax
801044f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801044fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801044fd:	c9                   	leave  
801044fe:	c3                   	ret    

801044ff <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801044ff:	55                   	push   %ebp
80104500:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104502:	fb                   	sti    
}
80104503:	90                   	nop
80104504:	5d                   	pop    %ebp
80104505:	c3                   	ret    

80104506 <pinit>:
static int promote_list(struct proc** list);
#endif

void
pinit(void)
{
80104506:	55                   	push   %ebp
80104507:	89 e5                	mov    %esp,%ebp
80104509:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010450c:	83 ec 08             	sub    $0x8,%esp
8010450f:	68 2c a0 10 80       	push   $0x8010a02c
80104514:	68 80 49 11 80       	push   $0x80114980
80104519:	e8 06 21 00 00       	call   80106624 <initlock>
8010451e:	83 c4 10             	add    $0x10,%esp
}
80104521:	90                   	nop
80104522:	c9                   	leave  
80104523:	c3                   	ret    

80104524 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104524:	55                   	push   %ebp
80104525:	89 e5                	mov    %esp,%ebp
80104527:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010452a:	83 ec 0c             	sub    $0xc,%esp
8010452d:	68 80 49 11 80       	push   $0x80114980
80104532:	e8 0f 21 00 00       	call   80106646 <acquire>
80104537:	83 c4 10             	add    $0x10,%esp
  #else
  // Check to make sure the ptable has free procs available
  // remove from list wont return a negative number in this
  // case because we check p and the list against null before
  // passing it in to the function. 
  p = ptable.pLists.free;
8010453a:	a1 b4 70 11 80       	mov    0x801170b4,%eax
8010453f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p) {
80104542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104546:	0f 84 86 00 00 00    	je     801045d2 <allocproc+0xae>
    remove_from_list(&ptable.pLists.free, p);
8010454c:	83 ec 08             	sub    $0x8,%esp
8010454f:	ff 75 f4             	pushl  -0xc(%ebp)
80104552:	68 b4 70 11 80       	push   $0x801170b4
80104557:	e8 34 1a 00 00       	call   80105f90 <remove_from_list>
8010455c:	83 c4 10             	add    $0x10,%esp
    assert_state(p, UNUSED);
8010455f:	83 ec 08             	sub    $0x8,%esp
80104562:	6a 00                	push   $0x0
80104564:	ff 75 f4             	pushl  -0xc(%ebp)
80104567:	e8 03 1a 00 00       	call   80105f6f <assert_state>
8010456c:	83 c4 10             	add    $0x10,%esp
    goto found;
8010456f:	90                   	nop
  #endif
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104573:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  #ifdef CS333_P3P4
  // Process is checked against null before it reaches this function
  // so this function won't fail at this point.
  add_to_list(&ptable.pLists.embryo, EMBRYO, p);
8010457a:	83 ec 04             	sub    $0x4,%esp
8010457d:	ff 75 f4             	pushl  -0xc(%ebp)
80104580:	6a 01                	push   $0x1
80104582:	68 b8 70 11 80       	push   $0x801170b8
80104587:	e8 b0 1a 00 00       	call   8010603c <add_to_list>
8010458c:	83 c4 10             	add    $0x10,%esp
  #endif
  p->pid = nextpid++;
8010458f:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104594:	8d 50 01             	lea    0x1(%eax),%edx
80104597:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
8010459d:	89 c2                	mov    %eax,%edx
8010459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a2:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
801045a5:	83 ec 0c             	sub    $0xc,%esp
801045a8:	68 80 49 11 80       	push   $0x80114980
801045ad:	e8 fb 20 00 00       	call   801066ad <release>
801045b2:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801045b5:	e8 56 e7 ff ff       	call   80102d10 <kalloc>
801045ba:	89 c2                	mov    %eax,%edx
801045bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bf:	89 50 08             	mov    %edx,0x8(%eax)
801045c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c5:	8b 40 08             	mov    0x8(%eax),%eax
801045c8:	85 c0                	test   %eax,%eax
801045ca:	0f 85 88 00 00 00    	jne    80104658 <allocproc+0x134>
801045d0:	eb 1a                	jmp    801045ec <allocproc+0xc8>
    remove_from_list(&ptable.pLists.free, p);
    assert_state(p, UNUSED);
    goto found;
  } 
  #endif
  release(&ptable.lock);
801045d2:	83 ec 0c             	sub    $0xc,%esp
801045d5:	68 80 49 11 80       	push   $0x80114980
801045da:	e8 ce 20 00 00       	call   801066ad <release>
801045df:	83 c4 10             	add    $0x10,%esp
  return 0;
801045e2:	b8 00 00 00 00       	mov    $0x0,%eax
801045e7:	e9 09 01 00 00       	jmp    801046f5 <allocproc+0x1d1>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    acquire(&ptable.lock);
801045ec:	83 ec 0c             	sub    $0xc,%esp
801045ef:	68 80 49 11 80       	push   $0x80114980
801045f4:	e8 4d 20 00 00       	call   80106646 <acquire>
801045f9:	83 c4 10             	add    $0x10,%esp
    #ifdef CS333_P3P4
    remove_from_list(&ptable.pLists.embryo, p);
801045fc:	83 ec 08             	sub    $0x8,%esp
801045ff:	ff 75 f4             	pushl  -0xc(%ebp)
80104602:	68 b8 70 11 80       	push   $0x801170b8
80104607:	e8 84 19 00 00       	call   80105f90 <remove_from_list>
8010460c:	83 c4 10             	add    $0x10,%esp
    assert_state(p, EMBRYO);
8010460f:	83 ec 08             	sub    $0x8,%esp
80104612:	6a 01                	push   $0x1
80104614:	ff 75 f4             	pushl  -0xc(%ebp)
80104617:	e8 53 19 00 00       	call   80105f6f <assert_state>
8010461c:	83 c4 10             	add    $0x10,%esp
    #endif
    p->state = UNUSED;
8010461f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104622:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #ifdef CS333_P3P4
    add_to_list(&ptable.pLists.free, UNUSED, p);
80104629:	83 ec 04             	sub    $0x4,%esp
8010462c:	ff 75 f4             	pushl  -0xc(%ebp)
8010462f:	6a 00                	push   $0x0
80104631:	68 b4 70 11 80       	push   $0x801170b4
80104636:	e8 01 1a 00 00       	call   8010603c <add_to_list>
8010463b:	83 c4 10             	add    $0x10,%esp
    #endif
    release(&ptable.lock);
8010463e:	83 ec 0c             	sub    $0xc,%esp
80104641:	68 80 49 11 80       	push   $0x80114980
80104646:	e8 62 20 00 00       	call   801066ad <release>
8010464b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010464e:	b8 00 00 00 00       	mov    $0x0,%eax
80104653:	e9 9d 00 00 00       	jmp    801046f5 <allocproc+0x1d1>
  }
  sp = p->kstack + KSTACKSIZE;
80104658:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465b:	8b 40 08             	mov    0x8(%eax),%eax
8010465e:	05 00 10 00 00       	add    $0x1000,%eax
80104663:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104666:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010466a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104670:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104673:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104677:	ba 1e 7e 10 80       	mov    $0x80107e1e,%edx
8010467c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010467f:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104681:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104688:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010468b:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010468e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104691:	8b 40 1c             	mov    0x1c(%eax),%eax
80104694:	83 ec 04             	sub    $0x4,%esp
80104697:	6a 14                	push   $0x14
80104699:	6a 00                	push   $0x0
8010469b:	50                   	push   %eax
8010469c:	e8 08 22 00 00       	call   801068a9 <memset>
801046a1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801046a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a7:	8b 40 1c             	mov    0x1c(%eax),%eax
801046aa:	ba 72 53 10 80       	mov    $0x80105372,%edx
801046af:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // My code Allocate start ticks to global ticks variable
801046b2:	8b 15 00 79 11 80    	mov    0x80117900,%edx
801046b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bb:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total = 0; // My code p2
801046be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c1:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
801046c8:	00 00 00 
  p->cpu_ticks_in = 0;    // My code p2
801046cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ce:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
801046d5:	00 00 00 
  #ifdef CS333_P3P4
  p->priority = 0;        // My code p4
801046d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046db:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801046e2:	00 00 00 
  p->budget = DEFBUDGET;  // My code p4 TEST VAL
801046e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e8:	c7 80 94 00 00 00 f4 	movl   $0x1f4,0x94(%eax)
801046ef:	01 00 00 
  #endif
  return p;
801046f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801046f5:	c9                   	leave  
801046f6:	c3                   	ret    

801046f7 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801046f7:	55                   	push   %ebp
801046f8:	89 e5                	mov    %esp,%ebp
801046fa:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  acquire(&ptable.lock);
801046fd:	83 ec 0c             	sub    $0xc,%esp
80104700:	68 80 49 11 80       	push   $0x80114980
80104705:	e8 3c 1f 00 00       	call   80106646 <acquire>
8010470a:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.free = 0;
8010470d:	c7 05 b4 70 11 80 00 	movl   $0x0,0x801170b4
80104714:	00 00 00 
  ptable.pLists.embryo = 0;
80104717:	c7 05 b8 70 11 80 00 	movl   $0x0,0x801170b8
8010471e:	00 00 00 
  ptable.pLists.running = 0;
80104721:	c7 05 d4 70 11 80 00 	movl   $0x0,0x801170d4
80104728:	00 00 00 
  ptable.pLists.sleep = 0;
8010472b:	c7 05 d8 70 11 80 00 	movl   $0x0,0x801170d8
80104732:	00 00 00 
  ptable.pLists.zombie = 0;
80104735:	c7 05 dc 70 11 80 00 	movl   $0x0,0x801170dc
8010473c:	00 00 00 
  for (int i = 0; i < MAX+1; i++)
8010473f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104746:	eb 17                	jmp    8010475f <userinit+0x68>
    ptable.pLists.ready[i] = 0;
80104748:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010474b:	05 cc 09 00 00       	add    $0x9cc,%eax
80104750:	c7 04 85 8c 49 11 80 	movl   $0x0,-0x7feeb674(,%eax,4)
80104757:	00 00 00 00 
  ptable.pLists.free = 0;
  ptable.pLists.embryo = 0;
  ptable.pLists.running = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  for (int i = 0; i < MAX+1; i++)
8010475b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010475f:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80104763:	7e e3                	jle    80104748 <userinit+0x51>
    ptable.pLists.ready[i] = 0;

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104765:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
8010476c:	eb 1c                	jmp    8010478a <userinit+0x93>
    add_to_list(&ptable.pLists.free, UNUSED, p);  
8010476e:	83 ec 04             	sub    $0x4,%esp
80104771:	ff 75 f4             	pushl  -0xc(%ebp)
80104774:	6a 00                	push   $0x0
80104776:	68 b4 70 11 80       	push   $0x801170b4
8010477b:	e8 bc 18 00 00       	call   8010603c <add_to_list>
80104780:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.zombie = 0;
  for (int i = 0; i < MAX+1; i++)
    ptable.pLists.ready[i] = 0;

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104783:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
8010478a:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80104791:	72 db                	jb     8010476e <userinit+0x77>
    add_to_list(&ptable.pLists.free, UNUSED, p);  

  ptable.promote_at_time = TICKS_TO_PROMOTE;                         // P4: Init promote time to 5 seconds..
80104793:	c7 05 e0 70 11 80 20 	movl   $0x320,0x801170e0
8010479a:	03 00 00 
  release(&ptable.lock);
8010479d:	83 ec 0c             	sub    $0xc,%esp
801047a0:	68 80 49 11 80       	push   $0x80114980
801047a5:	e8 03 1f 00 00       	call   801066ad <release>
801047aa:	83 c4 10             	add    $0x10,%esp
  
  p = allocproc();
801047ad:	e8 72 fd ff ff       	call   80104524 <allocproc>
801047b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801047b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b8:	a3 68 d6 10 80       	mov    %eax,0x8010d668
  if((p->pgdir = setupkvm()) == 0)
801047bd:	e8 fb 4c 00 00       	call   801094bd <setupkvm>
801047c2:	89 c2                	mov    %eax,%edx
801047c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c7:	89 50 04             	mov    %edx,0x4(%eax)
801047ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047cd:	8b 40 04             	mov    0x4(%eax),%eax
801047d0:	85 c0                	test   %eax,%eax
801047d2:	75 0d                	jne    801047e1 <userinit+0xea>
    panic("userinit: out of memory?");
801047d4:	83 ec 0c             	sub    $0xc,%esp
801047d7:	68 33 a0 10 80       	push   $0x8010a033
801047dc:	e8 85 bd ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047e1:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e9:	8b 40 04             	mov    0x4(%eax),%eax
801047ec:	83 ec 04             	sub    $0x4,%esp
801047ef:	52                   	push   %edx
801047f0:	68 00 d5 10 80       	push   $0x8010d500
801047f5:	50                   	push   %eax
801047f6:	e8 1c 4f 00 00       	call   80109717 <inituvm>
801047fb:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801047fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104801:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480a:	8b 40 18             	mov    0x18(%eax),%eax
8010480d:	83 ec 04             	sub    $0x4,%esp
80104810:	6a 4c                	push   $0x4c
80104812:	6a 00                	push   $0x0
80104814:	50                   	push   %eax
80104815:	e8 8f 20 00 00       	call   801068a9 <memset>
8010481a:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010481d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104820:	8b 40 18             	mov    0x18(%eax),%eax
80104823:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482c:	8b 40 18             	mov    0x18(%eax),%eax
8010482f:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104838:	8b 40 18             	mov    0x18(%eax),%eax
8010483b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010483e:	8b 52 18             	mov    0x18(%edx),%edx
80104841:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104845:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484c:	8b 40 18             	mov    0x18(%eax),%eax
8010484f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104852:	8b 52 18             	mov    0x18(%edx),%edx
80104855:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104859:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010485d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104860:	8b 40 18             	mov    0x18(%eax),%eax
80104863:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010486a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010486d:	8b 40 18             	mov    0x18(%eax),%eax
80104870:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487a:	8b 40 18             	mov    0x18(%eax),%eax
8010487d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->uid = DEFAULTUID; // p2
80104884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104887:	c7 80 80 00 00 00 0a 	movl   $0xa,0x80(%eax)
8010488e:	00 00 00 
  p->gid = DEFAULTGID; // p2
80104891:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104894:	c7 80 84 00 00 00 0a 	movl   $0xa,0x84(%eax)
8010489b:	00 00 00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010489e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a1:	83 c0 6c             	add    $0x6c,%eax
801048a4:	83 ec 04             	sub    $0x4,%esp
801048a7:	6a 10                	push   $0x10
801048a9:	68 4c a0 10 80       	push   $0x8010a04c
801048ae:	50                   	push   %eax
801048af:	e8 f8 21 00 00       	call   80106aac <safestrcpy>
801048b4:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801048b7:	83 ec 0c             	sub    $0xc,%esp
801048ba:	68 55 a0 10 80       	push   $0x8010a055
801048bf:	e8 0e dd ff ff       	call   801025d2 <namei>
801048c4:	83 c4 10             	add    $0x10,%esp
801048c7:	89 c2                	mov    %eax,%edx
801048c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048cc:	89 50 68             	mov    %edx,0x68(%eax)

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
801048cf:	83 ec 0c             	sub    $0xc,%esp
801048d2:	68 80 49 11 80       	push   $0x80114980
801048d7:	e8 6a 1d 00 00       	call   80106646 <acquire>
801048dc:	83 c4 10             	add    $0x10,%esp
  remove_from_list(&ptable.pLists.embryo, p);
801048df:	83 ec 08             	sub    $0x8,%esp
801048e2:	ff 75 f4             	pushl  -0xc(%ebp)
801048e5:	68 b8 70 11 80       	push   $0x801170b8
801048ea:	e8 a1 16 00 00       	call   80105f90 <remove_from_list>
801048ef:	83 c4 10             	add    $0x10,%esp
  assert_state(p, EMBRYO);
801048f2:	83 ec 08             	sub    $0x8,%esp
801048f5:	6a 01                	push   $0x1
801048f7:	ff 75 f4             	pushl  -0xc(%ebp)
801048fa:	e8 70 16 00 00       	call   80105f6f <assert_state>
801048ff:	83 c4 10             	add    $0x10,%esp
  #endif
  p->state = RUNNABLE;
80104902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104905:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  // Since it is the first process to be made I directly add to
  // the front of the ready list. Ocurrences after this use the
  // add to ready function.
  ptable.pLists.ready[0] = p;
8010490c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490f:	a3 bc 70 11 80       	mov    %eax,0x801170bc
  p->next = 0;
80104914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104917:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
8010491e:	00 00 00 
  release(&ptable.lock);
80104921:	83 ec 0c             	sub    $0xc,%esp
80104924:	68 80 49 11 80       	push   $0x80114980
80104929:	e8 7f 1d 00 00       	call   801066ad <release>
8010492e:	83 c4 10             	add    $0x10,%esp
  #endif
}
80104931:	90                   	nop
80104932:	c9                   	leave  
80104933:	c3                   	ret    

80104934 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010493a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104940:	8b 00                	mov    (%eax),%eax
80104942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104945:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104949:	7e 31                	jle    8010497c <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010494b:	8b 55 08             	mov    0x8(%ebp),%edx
8010494e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104951:	01 c2                	add    %eax,%edx
80104953:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104959:	8b 40 04             	mov    0x4(%eax),%eax
8010495c:	83 ec 04             	sub    $0x4,%esp
8010495f:	52                   	push   %edx
80104960:	ff 75 f4             	pushl  -0xc(%ebp)
80104963:	50                   	push   %eax
80104964:	e8 fb 4e 00 00       	call   80109864 <allocuvm>
80104969:	83 c4 10             	add    $0x10,%esp
8010496c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010496f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104973:	75 3e                	jne    801049b3 <growproc+0x7f>
      return -1;
80104975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010497a:	eb 59                	jmp    801049d5 <growproc+0xa1>
  } else if(n < 0){
8010497c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104980:	79 31                	jns    801049b3 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104982:	8b 55 08             	mov    0x8(%ebp),%edx
80104985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104988:	01 c2                	add    %eax,%edx
8010498a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104990:	8b 40 04             	mov    0x4(%eax),%eax
80104993:	83 ec 04             	sub    $0x4,%esp
80104996:	52                   	push   %edx
80104997:	ff 75 f4             	pushl  -0xc(%ebp)
8010499a:	50                   	push   %eax
8010499b:	e8 8d 4f 00 00       	call   8010992d <deallocuvm>
801049a0:	83 c4 10             	add    $0x10,%esp
801049a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801049a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801049aa:	75 07                	jne    801049b3 <growproc+0x7f>
      return -1;
801049ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b1:	eb 22                	jmp    801049d5 <growproc+0xa1>
  }
  proc->sz = sz;
801049b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049bc:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801049be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c4:	83 ec 0c             	sub    $0xc,%esp
801049c7:	50                   	push   %eax
801049c8:	e8 d7 4b 00 00       	call   801095a4 <switchuvm>
801049cd:	83 c4 10             	add    $0x10,%esp
  return 0;
801049d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049d5:	c9                   	leave  
801049d6:	c3                   	ret    

801049d7 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801049d7:	55                   	push   %ebp
801049d8:	89 e5                	mov    %esp,%ebp
801049da:	57                   	push   %edi
801049db:	56                   	push   %esi
801049dc:	53                   	push   %ebx
801049dd:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801049e0:	e8 3f fb ff ff       	call   80104524 <allocproc>
801049e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049ec:	75 0a                	jne    801049f8 <fork+0x21>
    return -1;
801049ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049f3:	e9 4d 02 00 00       	jmp    80104c45 <fork+0x26e>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801049f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049fe:	8b 10                	mov    (%eax),%edx
80104a00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a06:	8b 40 04             	mov    0x4(%eax),%eax
80104a09:	83 ec 08             	sub    $0x8,%esp
80104a0c:	52                   	push   %edx
80104a0d:	50                   	push   %eax
80104a0e:	e8 b8 50 00 00       	call   80109acb <copyuvm>
80104a13:	83 c4 10             	add    $0x10,%esp
80104a16:	89 c2                	mov    %eax,%edx
80104a18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a1b:	89 50 04             	mov    %edx,0x4(%eax)
80104a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a21:	8b 40 04             	mov    0x4(%eax),%eax
80104a24:	85 c0                	test   %eax,%eax
80104a26:	0f 85 b4 00 00 00    	jne    80104ae0 <fork+0x109>
    kfree(np->kstack);
80104a2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a2f:	8b 40 08             	mov    0x8(%eax),%eax
80104a32:	83 ec 0c             	sub    $0xc,%esp
80104a35:	50                   	push   %eax
80104a36:	e8 38 e2 ff ff       	call   80102c73 <kfree>
80104a3b:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104a3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104a48:	83 ec 0c             	sub    $0xc,%esp
80104a4b:	68 80 49 11 80       	push   $0x80114980
80104a50:	e8 f1 1b 00 00       	call   80106646 <acquire>
80104a55:	83 c4 10             	add    $0x10,%esp
    int code = remove_from_list(&ptable.pLists.embryo, np);
80104a58:	83 ec 08             	sub    $0x8,%esp
80104a5b:	ff 75 e0             	pushl  -0x20(%ebp)
80104a5e:	68 b8 70 11 80       	push   $0x801170b8
80104a63:	e8 28 15 00 00       	call   80105f90 <remove_from_list>
80104a68:	83 c4 10             	add    $0x10,%esp
80104a6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (code < 0)
80104a6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104a72:	79 0d                	jns    80104a81 <fork+0xaa>
      panic("ERROR: Couldn't remove from embryo.");
80104a74:	83 ec 0c             	sub    $0xc,%esp
80104a77:	68 58 a0 10 80       	push   $0x8010a058
80104a7c:	e8 e5 ba ff ff       	call   80100566 <panic>
    assert_state(np, EMBRYO);
80104a81:	83 ec 08             	sub    $0x8,%esp
80104a84:	6a 01                	push   $0x1
80104a86:	ff 75 e0             	pushl  -0x20(%ebp)
80104a89:	e8 e1 14 00 00       	call   80105f6f <assert_state>
80104a8e:	83 c4 10             	add    $0x10,%esp
    #endif
    np->state = UNUSED;
80104a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a94:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #ifdef CS333_P3P4
    int code2 = add_to_list(&ptable.pLists.free, UNUSED, np);
80104a9b:	83 ec 04             	sub    $0x4,%esp
80104a9e:	ff 75 e0             	pushl  -0x20(%ebp)
80104aa1:	6a 00                	push   $0x0
80104aa3:	68 b4 70 11 80       	push   $0x801170b4
80104aa8:	e8 8f 15 00 00       	call   8010603c <add_to_list>
80104aad:	83 c4 10             	add    $0x10,%esp
80104ab0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (code2 < 0)
80104ab3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80104ab7:	79 0d                	jns    80104ac6 <fork+0xef>
      panic("ERROR: Couldn't add process back to free.");
80104ab9:	83 ec 0c             	sub    $0xc,%esp
80104abc:	68 7c a0 10 80       	push   $0x8010a07c
80104ac1:	e8 a0 ba ff ff       	call   80100566 <panic>
    release(&ptable.lock);
80104ac6:	83 ec 0c             	sub    $0xc,%esp
80104ac9:	68 80 49 11 80       	push   $0x80114980
80104ace:	e8 da 1b 00 00       	call   801066ad <release>
80104ad3:	83 c4 10             	add    $0x10,%esp
    #endif
    return -1;
80104ad6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104adb:	e9 65 01 00 00       	jmp    80104c45 <fork+0x26e>
  }
  np->sz = proc->sz;
80104ae0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae6:	8b 10                	mov    (%eax),%edx
80104ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aeb:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104aed:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104af4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104af7:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104afa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104afd:	8b 50 18             	mov    0x18(%eax),%edx
80104b00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b06:	8b 40 18             	mov    0x18(%eax),%eax
80104b09:	89 c3                	mov    %eax,%ebx
80104b0b:	b8 13 00 00 00       	mov    $0x13,%eax
80104b10:	89 d7                	mov    %edx,%edi
80104b12:	89 de                	mov    %ebx,%esi
80104b14:	89 c1                	mov    %eax,%ecx
80104b16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // I'm pretty sure that this is where we put the uid/gid copy
  np -> uid = proc -> uid; // p2
80104b18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b1e:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104b24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b27:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np -> gid = proc -> gid; // p2
80104b2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b33:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104b39:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b3c:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b45:	8b 40 18             	mov    0x18(%eax),%eax
80104b48:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104b4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b56:	eb 43                	jmp    80104b9b <fork+0x1c4>
    if(proc->ofile[i])
80104b58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b61:	83 c2 08             	add    $0x8,%edx
80104b64:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b68:	85 c0                	test   %eax,%eax
80104b6a:	74 2b                	je     80104b97 <fork+0x1c0>
      np->ofile[i] = filedup(proc->ofile[i]);
80104b6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b75:	83 c2 08             	add    $0x8,%edx
80104b78:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b7c:	83 ec 0c             	sub    $0xc,%esp
80104b7f:	50                   	push   %eax
80104b80:	e8 25 c5 ff ff       	call   801010aa <filedup>
80104b85:	83 c4 10             	add    $0x10,%esp
80104b88:	89 c1                	mov    %eax,%ecx
80104b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b90:	83 c2 08             	add    $0x8,%edx
80104b93:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np -> gid = proc -> gid; // p2

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104b97:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b9b:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b9f:	7e b7                	jle    80104b58 <fork+0x181>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104ba1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ba7:	8b 40 68             	mov    0x68(%eax),%eax
80104baa:	83 ec 0c             	sub    $0xc,%esp
80104bad:	50                   	push   %eax
80104bae:	e8 27 ce ff ff       	call   801019da <idup>
80104bb3:	83 c4 10             	add    $0x10,%esp
80104bb6:	89 c2                	mov    %eax,%edx
80104bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bbb:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104bbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bc4:	8d 50 6c             	lea    0x6c(%eax),%edx
80104bc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bca:	83 c0 6c             	add    $0x6c,%eax
80104bcd:	83 ec 04             	sub    $0x4,%esp
80104bd0:	6a 10                	push   $0x10
80104bd2:	52                   	push   %edx
80104bd3:	50                   	push   %eax
80104bd4:	e8 d3 1e 00 00       	call   80106aac <safestrcpy>
80104bd9:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104bdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bdf:	8b 40 10             	mov    0x10(%eax),%eax
80104be2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104be5:	83 ec 0c             	sub    $0xc,%esp
80104be8:	68 80 49 11 80       	push   $0x80114980
80104bed:	e8 54 1a 00 00       	call   80106646 <acquire>
80104bf2:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.embryo, np);
80104bf5:	83 ec 08             	sub    $0x8,%esp
80104bf8:	ff 75 e0             	pushl  -0x20(%ebp)
80104bfb:	68 b8 70 11 80       	push   $0x801170b8
80104c00:	e8 8b 13 00 00       	call   80105f90 <remove_from_list>
80104c05:	83 c4 10             	add    $0x10,%esp
  assert_state(np, EMBRYO);
80104c08:	83 ec 08             	sub    $0x8,%esp
80104c0b:	6a 01                	push   $0x1
80104c0d:	ff 75 e0             	pushl  -0x20(%ebp)
80104c10:	e8 5a 13 00 00       	call   80105f6f <assert_state>
80104c15:	83 c4 10             	add    $0x10,%esp
  #endif
  np->state = RUNNABLE;
80104c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c1b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  add_to_ready(np, RUNNABLE);
80104c22:	83 ec 08             	sub    $0x8,%esp
80104c25:	6a 03                	push   $0x3
80104c27:	ff 75 e0             	pushl  -0x20(%ebp)
80104c2a:	e8 4e 14 00 00       	call   8010607d <add_to_ready>
80104c2f:	83 c4 10             	add    $0x10,%esp
  #endif
  release(&ptable.lock);
80104c32:	83 ec 0c             	sub    $0xc,%esp
80104c35:	68 80 49 11 80       	push   $0x80114980
80104c3a:	e8 6e 1a 00 00       	call   801066ad <release>
80104c3f:	83 c4 10             	add    $0x10,%esp
  return pid;
80104c42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80104c45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c48:	5b                   	pop    %ebx
80104c49:	5e                   	pop    %esi
80104c4a:	5f                   	pop    %edi
80104c4b:	5d                   	pop    %ebp
80104c4c:	c3                   	ret    

80104c4d <exit>:
}

#else
void
exit(void)
{
80104c4d:	55                   	push   %ebp
80104c4e:	89 e5                	mov    %esp,%ebp
80104c50:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int fd;

  if (proc == initproc)
80104c53:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c5a:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104c5f:	39 c2                	cmp    %eax,%edx
80104c61:	75 0d                	jne    80104c70 <exit+0x23>
    panic("init exiting");
80104c63:	83 ec 0c             	sub    $0xc,%esp
80104c66:	68 a6 a0 10 80       	push   $0x8010a0a6
80104c6b:	e8 f6 b8 ff ff       	call   80100566 <panic>

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104c70:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c77:	eb 48                	jmp    80104cc1 <exit+0x74>
    if(proc->ofile[fd]) {
80104c79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c82:	83 c2 08             	add    $0x8,%edx
80104c85:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c89:	85 c0                	test   %eax,%eax
80104c8b:	74 30                	je     80104cbd <exit+0x70>
      fileclose(proc->ofile[fd]);
80104c8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c93:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c96:	83 c2 08             	add    $0x8,%edx
80104c99:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c9d:	83 ec 0c             	sub    $0xc,%esp
80104ca0:	50                   	push   %eax
80104ca1:	e8 55 c4 ff ff       	call   801010fb <fileclose>
80104ca6:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104ca9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104caf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104cb2:	83 c2 08             	add    $0x8,%edx
80104cb5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104cbc:	00 

  if (proc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104cbd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104cc1:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104cc5:	7e b2                	jle    80104c79 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104cc7:	e8 2b e9 ff ff       	call   801035f7 <begin_op>
  iput(proc->cwd);
80104ccc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cd2:	8b 40 68             	mov    0x68(%eax),%eax
80104cd5:	83 ec 0c             	sub    $0xc,%esp
80104cd8:	50                   	push   %eax
80104cd9:	e8 06 cf ff ff       	call   80101be4 <iput>
80104cde:	83 c4 10             	add    $0x10,%esp
  end_op();
80104ce1:	e8 9d e9 ff ff       	call   80103683 <end_op>
  proc->cwd = 0;
80104ce6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cec:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104cf3:	83 ec 0c             	sub    $0xc,%esp
80104cf6:	68 80 49 11 80       	push   $0x80114980
80104cfb:	e8 46 19 00 00       	call   80106646 <acquire>
80104d00:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104d03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d09:	8b 40 14             	mov    0x14(%eax),%eax
80104d0c:	83 ec 0c             	sub    $0xc,%esp
80104d0f:	50                   	push   %eax
80104d10:	e8 0f 08 00 00       	call   80105524 <wakeup1>
80104d15:	83 c4 10             	add    $0x10,%esp

  // Run exit helper to check process parents against the
  // currently running process. 
  exit_helper(&ptable.pLists.embryo);
80104d18:	83 ec 0c             	sub    $0xc,%esp
80104d1b:	68 b8 70 11 80       	push   $0x801170b8
80104d20:	e8 29 14 00 00       	call   8010614e <exit_helper>
80104d25:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX+1; i++)
80104d28:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104d2f:	eb 23                	jmp    80104d54 <exit+0x107>
    exit_helper(&ptable.pLists.ready[i]);
80104d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d34:	05 cc 09 00 00       	add    $0x9cc,%eax
80104d39:	c1 e0 02             	shl    $0x2,%eax
80104d3c:	05 80 49 11 80       	add    $0x80114980,%eax
80104d41:	83 c0 0c             	add    $0xc,%eax
80104d44:	83 ec 0c             	sub    $0xc,%esp
80104d47:	50                   	push   %eax
80104d48:	e8 01 14 00 00       	call   8010614e <exit_helper>
80104d4d:	83 c4 10             	add    $0x10,%esp
  wakeup1(proc->parent);

  // Run exit helper to check process parents against the
  // currently running process. 
  exit_helper(&ptable.pLists.embryo);
  for (int i = 0; i < MAX+1; i++)
80104d50:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104d54:	83 7d ec 05          	cmpl   $0x5,-0x14(%ebp)
80104d58:	7e d7                	jle    80104d31 <exit+0xe4>
    exit_helper(&ptable.pLists.ready[i]);
  exit_helper(&ptable.pLists.running);
80104d5a:	83 ec 0c             	sub    $0xc,%esp
80104d5d:	68 d4 70 11 80       	push   $0x801170d4
80104d62:	e8 e7 13 00 00       	call   8010614e <exit_helper>
80104d67:	83 c4 10             	add    $0x10,%esp
  exit_helper(&ptable.pLists.sleep);
80104d6a:	83 ec 0c             	sub    $0xc,%esp
80104d6d:	68 d8 70 11 80       	push   $0x801170d8
80104d72:	e8 d7 13 00 00       	call   8010614e <exit_helper>
80104d77:	83 c4 10             	add    $0x10,%esp

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
80104d7a:	a1 dc 70 11 80       	mov    0x801170dc,%eax
80104d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80104d82:	eb 39                	jmp    80104dbd <exit+0x170>
    if (p->parent == proc) {
80104d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d87:	8b 50 14             	mov    0x14(%eax),%edx
80104d8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d90:	39 c2                	cmp    %eax,%edx
80104d92:	75 1d                	jne    80104db1 <exit+0x164>
      p->parent = initproc;
80104d94:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9d:	89 50 14             	mov    %edx,0x14(%eax)
      wakeup1(initproc);
80104da0:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104da5:	83 ec 0c             	sub    $0xc,%esp
80104da8:	50                   	push   %eax
80104da9:	e8 76 07 00 00       	call   80105524 <wakeup1>
80104dae:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
80104db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db4:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  exit_helper(&ptable.pLists.sleep);

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
  while (p) {
80104dbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104dc1:	75 c1                	jne    80104d84 <exit+0x137>
      wakeup1(initproc);
    }
    p = p->next;
  }

  remove_from_list(&ptable.pLists.running, proc);
80104dc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc9:	83 ec 08             	sub    $0x8,%esp
80104dcc:	50                   	push   %eax
80104dcd:	68 d4 70 11 80       	push   $0x801170d4
80104dd2:	e8 b9 11 00 00       	call   80105f90 <remove_from_list>
80104dd7:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
80104dda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de0:	83 ec 08             	sub    $0x8,%esp
80104de3:	6a 04                	push   $0x4
80104de5:	50                   	push   %eax
80104de6:	e8 84 11 00 00       	call   80105f6f <assert_state>
80104deb:	83 c4 10             	add    $0x10,%esp
  proc->state = ZOMBIE;
80104dee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104df4:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  add_to_list(&ptable.pLists.zombie, ZOMBIE, proc);
80104dfb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e01:	83 ec 04             	sub    $0x4,%esp
80104e04:	50                   	push   %eax
80104e05:	6a 05                	push   $0x5
80104e07:	68 dc 70 11 80       	push   $0x801170dc
80104e0c:	e8 2b 12 00 00       	call   8010603c <add_to_list>
80104e11:	83 c4 10             	add    $0x10,%esp
  sched();
80104e14:	e8 6a 03 00 00       	call   80105183 <sched>
  panic("zombie exit");
80104e19:	83 ec 0c             	sub    $0xc,%esp
80104e1c:	68 b3 a0 10 80       	push   $0x8010a0b3
80104e21:	e8 40 b7 ff ff       	call   80100566 <panic>

80104e26 <wait>:
}

#else
int
wait(void)
{
80104e26:	55                   	push   %ebp
80104e27:	89 e5                	mov    %esp,%ebp
80104e29:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int havekids, pid;

  acquire(&ptable.lock);
80104e2c:	83 ec 0c             	sub    $0xc,%esp
80104e2f:	68 80 49 11 80       	push   $0x80114980
80104e34:	e8 0d 18 00 00       	call   80106646 <acquire>
80104e39:	83 c4 10             	add    $0x10,%esp
  for(;;) {
    // Scan through table looking for zombie children
    havekids = 0;
80104e3c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    // Run wait helper function to search each list and check
    // if process parent is the currently running process and
    // set havekids to 1 if that is the case.
    wait_helper(&ptable.pLists.embryo, &havekids);
80104e43:	83 ec 08             	sub    $0x8,%esp
80104e46:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104e49:	50                   	push   %eax
80104e4a:	68 b8 70 11 80       	push   $0x801170b8
80104e4f:	e8 3b 13 00 00       	call   8010618f <wait_helper>
80104e54:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < MAX+1; i++)
80104e57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104e5e:	eb 27                	jmp    80104e87 <wait+0x61>
      wait_helper(&ptable.pLists.ready[i], &havekids);
80104e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e63:	05 cc 09 00 00       	add    $0x9cc,%eax
80104e68:	c1 e0 02             	shl    $0x2,%eax
80104e6b:	05 80 49 11 80       	add    $0x80114980,%eax
80104e70:	8d 50 0c             	lea    0xc(%eax),%edx
80104e73:	83 ec 08             	sub    $0x8,%esp
80104e76:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104e79:	50                   	push   %eax
80104e7a:	52                   	push   %edx
80104e7b:	e8 0f 13 00 00       	call   8010618f <wait_helper>
80104e80:	83 c4 10             	add    $0x10,%esp

    // Run wait helper function to search each list and check
    // if process parent is the currently running process and
    // set havekids to 1 if that is the case.
    wait_helper(&ptable.pLists.embryo, &havekids);
    for (int i = 0; i < MAX+1; i++)
80104e83:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104e87:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80104e8b:	7e d3                	jle    80104e60 <wait+0x3a>
      wait_helper(&ptable.pLists.ready[i], &havekids);
    wait_helper(&ptable.pLists.running, &havekids);
80104e8d:	83 ec 08             	sub    $0x8,%esp
80104e90:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104e93:	50                   	push   %eax
80104e94:	68 d4 70 11 80       	push   $0x801170d4
80104e99:	e8 f1 12 00 00       	call   8010618f <wait_helper>
80104e9e:	83 c4 10             	add    $0x10,%esp
    wait_helper(&ptable.pLists.sleep, &havekids);
80104ea1:	83 ec 08             	sub    $0x8,%esp
80104ea4:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104ea7:	50                   	push   %eax
80104ea8:	68 d8 70 11 80       	push   $0x801170d8
80104ead:	e8 dd 12 00 00       	call   8010618f <wait_helper>
80104eb2:	83 c4 10             	add    $0x10,%esp

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
80104eb5:	a1 dc 70 11 80       	mov    0x801170dc,%eax
80104eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104ebd:	e9 f4 00 00 00       	jmp    80104fb6 <wait+0x190>
      if (p->parent == proc) {
80104ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec5:	8b 50 14             	mov    0x14(%eax),%edx
80104ec8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ece:	39 c2                	cmp    %eax,%edx
80104ed0:	0f 85 d4 00 00 00    	jne    80104faa <wait+0x184>
        havekids = 1;
80104ed6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
        // Found one.
        pid = p->pid;
80104edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee0:	8b 40 10             	mov    0x10(%eax),%eax
80104ee3:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee9:	8b 40 08             	mov    0x8(%eax),%eax
80104eec:	83 ec 0c             	sub    $0xc,%esp
80104eef:	50                   	push   %eax
80104ef0:	e8 7e dd ff ff       	call   80102c73 <kfree>
80104ef5:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104efb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f05:	8b 40 04             	mov    0x4(%eax),%eax
80104f08:	83 ec 0c             	sub    $0xc,%esp
80104f0b:	50                   	push   %eax
80104f0c:	e8 d9 4a 00 00       	call   801099ea <freevm>
80104f11:	83 c4 10             	add    $0x10,%esp
        remove_from_list(&ptable.pLists.zombie, p);
80104f14:	83 ec 08             	sub    $0x8,%esp
80104f17:	ff 75 f4             	pushl  -0xc(%ebp)
80104f1a:	68 dc 70 11 80       	push   $0x801170dc
80104f1f:	e8 6c 10 00 00       	call   80105f90 <remove_from_list>
80104f24:	83 c4 10             	add    $0x10,%esp
        assert_state(p, ZOMBIE);
80104f27:	83 ec 08             	sub    $0x8,%esp
80104f2a:	6a 05                	push   $0x5
80104f2c:	ff 75 f4             	pushl  -0xc(%ebp)
80104f2f:	e8 3b 10 00 00       	call   80105f6f <assert_state>
80104f34:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f3a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f44:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f58:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f5f:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->priority = 0;
80104f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f69:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104f70:	00 00 00 
        p->budget = 0;
80104f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f76:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104f7d:	00 00 00 
        add_to_list(&ptable.pLists.free, UNUSED, p);
80104f80:	83 ec 04             	sub    $0x4,%esp
80104f83:	ff 75 f4             	pushl  -0xc(%ebp)
80104f86:	6a 00                	push   $0x0
80104f88:	68 b4 70 11 80       	push   $0x801170b4
80104f8d:	e8 aa 10 00 00       	call   8010603c <add_to_list>
80104f92:	83 c4 10             	add    $0x10,%esp
        release(&ptable.lock);
80104f95:	83 ec 0c             	sub    $0xc,%esp
80104f98:	68 80 49 11 80       	push   $0x80114980
80104f9d:	e8 0b 17 00 00       	call   801066ad <release>
80104fa2:	83 c4 10             	add    $0x10,%esp
        return pid;
80104fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fa8:	eb 5d                	jmp    80105007 <wait+0x1e1>
      }
      p = p->next;
80104faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fad:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    wait_helper(&ptable.pLists.sleep, &havekids);

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
    while (p) {
80104fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104fba:	0f 85 02 ff ff ff    	jne    80104ec2 <wait+0x9c>
      }
      p = p->next;
    }

    // No point waiting if we don't have any children
    if (!havekids || proc->killed) {
80104fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104fc3:	85 c0                	test   %eax,%eax
80104fc5:	74 0d                	je     80104fd4 <wait+0x1ae>
80104fc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fcd:	8b 40 24             	mov    0x24(%eax),%eax
80104fd0:	85 c0                	test   %eax,%eax
80104fd2:	74 17                	je     80104feb <wait+0x1c5>
      release(&ptable.lock);
80104fd4:	83 ec 0c             	sub    $0xc,%esp
80104fd7:	68 80 49 11 80       	push   $0x80114980
80104fdc:	e8 cc 16 00 00       	call   801066ad <release>
80104fe1:	83 c4 10             	add    $0x10,%esp
      return -1;
80104fe4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe9:	eb 1c                	jmp    80105007 <wait+0x1e1>
    }

    // Wait for children to exit. (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104feb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ff1:	83 ec 08             	sub    $0x8,%esp
80104ff4:	68 80 49 11 80       	push   $0x80114980
80104ff9:	50                   	push   %eax
80104ffa:	e8 b9 03 00 00       	call   801053b8 <sleep>
80104fff:	83 c4 10             	add    $0x10,%esp
  }
80105002:	e9 35 fe ff ff       	jmp    80104e3c <wait+0x16>
}
80105007:	c9                   	leave  
80105008:	c3                   	ret    

80105009 <scheduler>:
}

#else
void
scheduler(void)
{
80105009:	55                   	push   %ebp
8010500a:	89 e5                	mov    %esp,%ebp
8010500c:	83 ec 18             	sub    $0x18,%esp
  struct proc* p = 0;
8010500f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int idle;  // for checking if processor is idle

  for(;;) {

    // Enable interrupts on this processor.
    sti();
80105016:	e8 e4 f4 ff ff       	call   801044ff <sti>
    idle = 1;   // assume idle unless we schedule a process
8010501b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    
    acquire(&ptable.lock); 
80105022:	83 ec 0c             	sub    $0xc,%esp
80105025:	68 80 49 11 80       	push   $0x80114980
8010502a:	e8 17 16 00 00       	call   80106646 <acquire>
8010502f:	83 c4 10             	add    $0x10,%esp

    for (int i = 0; i < MAX+1; i++) {
80105032:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105039:	e9 12 01 00 00       	jmp    80105150 <scheduler+0x147>
      if (!ptable.pLists.ready[i])
8010503e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105041:	05 cc 09 00 00       	add    $0x9cc,%eax
80105046:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
8010504d:	85 c0                	test   %eax,%eax
8010504f:	0f 84 f6 00 00 00    	je     8010514b <scheduler+0x142>
        continue;
      if (ticks == ptable.promote_at_time) {
80105055:	8b 15 e0 70 11 80    	mov    0x801170e0,%edx
8010505b:	a1 00 79 11 80       	mov    0x80117900,%eax
80105060:	39 c2                	cmp    %eax,%edx
80105062:	75 14                	jne    80105078 <scheduler+0x6f>
        priority_promotion();
80105064:	e8 ca 13 00 00       	call   80106433 <priority_promotion>
        ptable.promote_at_time = ticks + TICKS_TO_PROMOTE;
80105069:	a1 00 79 11 80       	mov    0x80117900,%eax
8010506e:	05 20 03 00 00       	add    $0x320,%eax
80105073:	a3 e0 70 11 80       	mov    %eax,0x801170e0
      }

      p = ptable.pLists.ready[i];                                              // P4 changes
80105078:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010507b:	05 cc 09 00 00       	add    $0x9cc,%eax
80105080:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80105087:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p) {
8010508a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010508e:	0f 84 b8 00 00 00    	je     8010514c <scheduler+0x143>
        remove_from_list(&ptable.pLists.ready[i], p);
80105094:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105097:	05 cc 09 00 00       	add    $0x9cc,%eax
8010509c:	c1 e0 02             	shl    $0x2,%eax
8010509f:	05 80 49 11 80       	add    $0x80114980,%eax
801050a4:	83 c0 0c             	add    $0xc,%eax
801050a7:	83 ec 08             	sub    $0x8,%esp
801050aa:	ff 75 ec             	pushl  -0x14(%ebp)
801050ad:	50                   	push   %eax
801050ae:	e8 dd 0e 00 00       	call   80105f90 <remove_from_list>
801050b3:	83 c4 10             	add    $0x10,%esp
        assert_state(p, RUNNABLE);
801050b6:	83 ec 08             	sub    $0x8,%esp
801050b9:	6a 03                	push   $0x3
801050bb:	ff 75 ec             	pushl  -0x14(%ebp)
801050be:	e8 ac 0e 00 00       	call   80105f6f <assert_state>
801050c3:	83 c4 10             	add    $0x10,%esp
        idle = 0;  // not idle this timeslice
801050c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        proc = p;
801050cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050d0:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
        switchuvm(p);
801050d6:	83 ec 0c             	sub    $0xc,%esp
801050d9:	ff 75 ec             	pushl  -0x14(%ebp)
801050dc:	e8 c3 44 00 00       	call   801095a4 <switchuvm>
801050e1:	83 c4 10             	add    $0x10,%esp
        p->state = RUNNING;
801050e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050e7:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
        add_to_list(&ptable.pLists.running, RUNNING, p);
801050ee:	83 ec 04             	sub    $0x4,%esp
801050f1:	ff 75 ec             	pushl  -0x14(%ebp)
801050f4:	6a 04                	push   $0x4
801050f6:	68 d4 70 11 80       	push   $0x801170d4
801050fb:	e8 3c 0f 00 00       	call   8010603c <add_to_list>
80105100:	83 c4 10             	add    $0x10,%esp
        p->cpu_ticks_in = ticks;  // My code p3
80105103:	8b 15 00 79 11 80    	mov    0x80117900,%edx
80105109:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010510c:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
        swtch(&cpu->scheduler, proc->context);
80105112:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105118:	8b 40 1c             	mov    0x1c(%eax),%eax
8010511b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105122:	83 c2 04             	add    $0x4,%edx
80105125:	83 ec 08             	sub    $0x8,%esp
80105128:	50                   	push   %eax
80105129:	52                   	push   %edx
8010512a:	e8 ee 19 00 00       	call   80106b1d <swtch>
8010512f:	83 c4 10             	add    $0x10,%esp
        switchkvm();
80105132:	e8 50 44 00 00       	call   80109587 <switchkvm>
    
        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0; 
80105137:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010513e:	00 00 00 00 
        i = -1; // Set i to -1 so it increments to 0 and begins with the first queue again
80105142:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
80105149:	eb 01                	jmp    8010514c <scheduler+0x143>
    
    acquire(&ptable.lock); 

    for (int i = 0; i < MAX+1; i++) {
      if (!ptable.pLists.ready[i])
        continue;
8010514b:	90                   	nop
    sti();
    idle = 1;   // assume idle unless we schedule a process
    
    acquire(&ptable.lock); 

    for (int i = 0; i < MAX+1; i++) {
8010514c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105150:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80105154:	0f 8e e4 fe ff ff    	jle    8010503e <scheduler+0x35>
        proc = 0; 
        i = -1; // Set i to -1 so it increments to 0 and begins with the first queue again
      }
    }

    release(&ptable.lock);
8010515a:	83 ec 0c             	sub    $0xc,%esp
8010515d:	68 80 49 11 80       	push   $0x80114980
80105162:	e8 46 15 00 00       	call   801066ad <release>
80105167:	83 c4 10             	add    $0x10,%esp
    if (idle) {
8010516a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010516e:	0f 84 a2 fe ff ff    	je     80105016 <scheduler+0xd>
      sti();
80105174:	e8 86 f3 ff ff       	call   801044ff <sti>
      hlt();
80105179:	e8 6a f3 ff ff       	call   801044e8 <hlt>
    }
  }
8010517e:	e9 93 fe ff ff       	jmp    80105016 <scheduler+0xd>

80105183 <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
80105183:	55                   	push   %ebp
80105184:	89 e5                	mov    %esp,%ebp
80105186:	53                   	push   %ebx
80105187:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
8010518a:	83 ec 0c             	sub    $0xc,%esp
8010518d:	68 80 49 11 80       	push   $0x80114980
80105192:	e8 e2 15 00 00       	call   80106779 <holding>
80105197:	83 c4 10             	add    $0x10,%esp
8010519a:	85 c0                	test   %eax,%eax
8010519c:	75 0d                	jne    801051ab <sched+0x28>
    panic("sched ptable.lock");
8010519e:	83 ec 0c             	sub    $0xc,%esp
801051a1:	68 bf a0 10 80       	push   $0x8010a0bf
801051a6:	e8 bb b3 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
801051ab:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051b1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801051b7:	83 f8 01             	cmp    $0x1,%eax
801051ba:	74 0d                	je     801051c9 <sched+0x46>
    panic("sched locks");
801051bc:	83 ec 0c             	sub    $0xc,%esp
801051bf:	68 d1 a0 10 80       	push   $0x8010a0d1
801051c4:	e8 9d b3 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
801051c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051cf:	8b 40 0c             	mov    0xc(%eax),%eax
801051d2:	83 f8 04             	cmp    $0x4,%eax
801051d5:	75 0d                	jne    801051e4 <sched+0x61>
    panic("sched running");
801051d7:	83 ec 0c             	sub    $0xc,%esp
801051da:	68 dd a0 10 80       	push   $0x8010a0dd
801051df:	e8 82 b3 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
801051e4:	e8 06 f3 ff ff       	call   801044ef <readeflags>
801051e9:	25 00 02 00 00       	and    $0x200,%eax
801051ee:	85 c0                	test   %eax,%eax
801051f0:	74 0d                	je     801051ff <sched+0x7c>
    panic("sched interruptible");
801051f2:	83 ec 0c             	sub    $0xc,%esp
801051f5:	68 eb a0 10 80       	push   $0x8010a0eb
801051fa:	e8 67 b3 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
801051ff:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105205:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010520b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // My code p2
8010520e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105214:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010521b:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80105221:	8b 1d 00 79 11 80    	mov    0x80117900,%ebx
80105227:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010522e:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80105234:	29 d3                	sub    %edx,%ebx
80105236:	89 da                	mov    %ebx,%edx
80105238:	01 ca                	add    %ecx,%edx
8010523a:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
80105240:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105246:	8b 40 04             	mov    0x4(%eax),%eax
80105249:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105250:	83 c2 1c             	add    $0x1c,%edx
80105253:	83 ec 08             	sub    $0x8,%esp
80105256:	50                   	push   %eax
80105257:	52                   	push   %edx
80105258:	e8 c0 18 00 00       	call   80106b1d <swtch>
8010525d:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80105260:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105266:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105269:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010526f:	90                   	nop
80105270:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105273:	c9                   	leave  
80105274:	c3                   	ret    

80105275 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105275:	55                   	push   %ebp
80105276:	89 e5                	mov    %esp,%ebp
80105278:	53                   	push   %ebx
80105279:	83 ec 04             	sub    $0x4,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010527c:	83 ec 0c             	sub    $0xc,%esp
8010527f:	68 80 49 11 80       	push   $0x80114980
80105284:	e8 bd 13 00 00       	call   80106646 <acquire>
80105289:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
8010528c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105292:	83 ec 08             	sub    $0x8,%esp
80105295:	50                   	push   %eax
80105296:	68 d4 70 11 80       	push   $0x801170d4
8010529b:	e8 f0 0c 00 00       	call   80105f90 <remove_from_list>
801052a0:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
801052a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052a9:	83 ec 08             	sub    $0x8,%esp
801052ac:	6a 04                	push   $0x4
801052ae:	50                   	push   %eax
801052af:	e8 bb 0c 00 00       	call   80105f6f <assert_state>
801052b4:	83 c4 10             	add    $0x10,%esp
  #endif
  proc->state = RUNNABLE;
801052b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052bd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
801052c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052ca:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052d1:	8b 8a 94 00 00 00    	mov    0x94(%edx),%ecx
801052d7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052de:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
801052e4:	8b 15 00 79 11 80    	mov    0x80117900,%edx
801052ea:	29 d3                	sub    %edx,%ebx
801052ec:	89 da                	mov    %ebx,%edx
801052ee:	01 ca                	add    %ecx,%edx
801052f0:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  if (proc->budget <= 0 && proc->priority < MAX) {
801052f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052fc:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105302:	85 c0                	test   %eax,%eax
80105304:	75 3d                	jne    80105343 <yield+0xce>
80105306:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010530c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105312:	83 f8 04             	cmp    $0x4,%eax
80105315:	77 2c                	ja     80105343 <yield+0xce>
    proc->priority = proc->priority+1;
80105317:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010531d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105324:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
8010532a:	83 c2 01             	add    $0x1,%edx
8010532d:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    proc->budget = DEFBUDGET;
80105333:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105339:	c7 80 94 00 00 00 f4 	movl   $0x1f4,0x94(%eax)
80105340:	01 00 00 
  }
  add_to_ready(proc, RUNNABLE);
80105343:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105349:	83 ec 08             	sub    $0x8,%esp
8010534c:	6a 03                	push   $0x3
8010534e:	50                   	push   %eax
8010534f:	e8 29 0d 00 00       	call   8010607d <add_to_ready>
80105354:	83 c4 10             	add    $0x10,%esp
  #endif
  sched();
80105357:	e8 27 fe ff ff       	call   80105183 <sched>
  release(&ptable.lock);
8010535c:	83 ec 0c             	sub    $0xc,%esp
8010535f:	68 80 49 11 80       	push   $0x80114980
80105364:	e8 44 13 00 00       	call   801066ad <release>
80105369:	83 c4 10             	add    $0x10,%esp
}
8010536c:	90                   	nop
8010536d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105370:	c9                   	leave  
80105371:	c3                   	ret    

80105372 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105372:	55                   	push   %ebp
80105373:	89 e5                	mov    %esp,%ebp
80105375:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105378:	83 ec 0c             	sub    $0xc,%esp
8010537b:	68 80 49 11 80       	push   $0x80114980
80105380:	e8 28 13 00 00       	call   801066ad <release>
80105385:	83 c4 10             	add    $0x10,%esp

  if (first) {
80105388:	a1 20 d0 10 80       	mov    0x8010d020,%eax
8010538d:	85 c0                	test   %eax,%eax
8010538f:	74 24                	je     801053b5 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105391:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
80105398:	00 00 00 
    iinit(ROOTDEV);
8010539b:	83 ec 0c             	sub    $0xc,%esp
8010539e:	6a 01                	push   $0x1
801053a0:	e8 43 c3 ff ff       	call   801016e8 <iinit>
801053a5:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801053a8:	83 ec 0c             	sub    $0xc,%esp
801053ab:	6a 01                	push   $0x1
801053ad:	e8 27 e0 ff ff       	call   801033d9 <initlog>
801053b2:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801053b5:	90                   	nop
801053b6:	c9                   	leave  
801053b7:	c3                   	ret    

801053b8 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
801053b8:	55                   	push   %ebp
801053b9:	89 e5                	mov    %esp,%ebp
801053bb:	53                   	push   %ebx
801053bc:	83 ec 04             	sub    $0x4,%esp
  if(proc == 0)
801053bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053c5:	85 c0                	test   %eax,%eax
801053c7:	75 0d                	jne    801053d6 <sleep+0x1e>
    panic("sleep");
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	68 ff a0 10 80       	push   $0x8010a0ff
801053d1:	e8 90 b1 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
801053d6:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801053dd:	74 24                	je     80105403 <sleep+0x4b>
    acquire(&ptable.lock);
801053df:	83 ec 0c             	sub    $0xc,%esp
801053e2:	68 80 49 11 80       	push   $0x80114980
801053e7:	e8 5a 12 00 00       	call   80106646 <acquire>
801053ec:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
801053ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801053f3:	74 0e                	je     80105403 <sleep+0x4b>
801053f5:	83 ec 0c             	sub    $0xc,%esp
801053f8:	ff 75 0c             	pushl  0xc(%ebp)
801053fb:	e8 ad 12 00 00       	call   801066ad <release>
80105400:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80105403:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105409:	8b 55 08             	mov    0x8(%ebp),%edx
8010540c:	89 50 20             	mov    %edx,0x20(%eax)
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
8010540f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105415:	83 ec 08             	sub    $0x8,%esp
80105418:	50                   	push   %eax
80105419:	68 d4 70 11 80       	push   $0x801170d4
8010541e:	e8 6d 0b 00 00       	call   80105f90 <remove_from_list>
80105423:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
80105426:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010542c:	83 ec 08             	sub    $0x8,%esp
8010542f:	6a 04                	push   $0x4
80105431:	50                   	push   %eax
80105432:	e8 38 0b 00 00       	call   80105f6f <assert_state>
80105437:	83 c4 10             	add    $0x10,%esp
  #endif
  proc->state = SLEEPING;
8010543a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105440:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  #ifdef CS333_P3P4
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
80105447:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010544d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105454:	8b 8a 94 00 00 00    	mov    0x94(%edx),%ecx
8010545a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105461:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
80105467:	8b 15 00 79 11 80    	mov    0x80117900,%edx
8010546d:	29 d3                	sub    %edx,%ebx
8010546f:	89 da                	mov    %ebx,%edx
80105471:	01 ca                	add    %ecx,%edx
80105473:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  if (proc->budget <= 0 && proc->priority < MAX) {
80105479:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010547f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105485:	85 c0                	test   %eax,%eax
80105487:	75 3d                	jne    801054c6 <sleep+0x10e>
80105489:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010548f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105495:	83 f8 04             	cmp    $0x4,%eax
80105498:	77 2c                	ja     801054c6 <sleep+0x10e>
    proc->priority = proc->priority+1;
8010549a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054a0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054a7:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
801054ad:	83 c2 01             	add    $0x1,%edx
801054b0:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    proc->budget = DEFBUDGET;
801054b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054bc:	c7 80 94 00 00 00 f4 	movl   $0x1f4,0x94(%eax)
801054c3:	01 00 00 
  }
  add_to_list(&ptable.pLists.sleep, SLEEPING, proc);
801054c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054cc:	83 ec 04             	sub    $0x4,%esp
801054cf:	50                   	push   %eax
801054d0:	6a 02                	push   $0x2
801054d2:	68 d8 70 11 80       	push   $0x801170d8
801054d7:	e8 60 0b 00 00       	call   8010603c <add_to_list>
801054dc:	83 c4 10             	add    $0x10,%esp
  #endif
  sched();
801054df:	e8 9f fc ff ff       	call   80105183 <sched>

  // Tidy up.
  proc->chan = 0;
801054e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054ea:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
801054f1:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801054f8:	74 24                	je     8010551e <sleep+0x166>
    release(&ptable.lock);
801054fa:	83 ec 0c             	sub    $0xc,%esp
801054fd:	68 80 49 11 80       	push   $0x80114980
80105502:	e8 a6 11 00 00       	call   801066ad <release>
80105507:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
8010550a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010550e:	74 0e                	je     8010551e <sleep+0x166>
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	ff 75 0c             	pushl  0xc(%ebp)
80105516:	e8 2b 11 00 00       	call   80106646 <acquire>
8010551b:	83 c4 10             	add    $0x10,%esp
  }
}
8010551e:	90                   	nop
8010551f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105522:	c9                   	leave  
80105523:	c3                   	ret    

80105524 <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
80105524:	55                   	push   %ebp
80105525:	89 e5                	mov    %esp,%ebp
80105527:	83 ec 18             	sub    $0x18,%esp
  struct proc* p = ptable.pLists.sleep;
8010552a:	a1 d8 70 11 80       	mov    0x801170d8,%eax
8010552f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80105532:	eb 54                	jmp    80105588 <wakeup1+0x64>
    if (p->chan == chan) {
80105534:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105537:	8b 40 20             	mov    0x20(%eax),%eax
8010553a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010553d:	75 3d                	jne    8010557c <wakeup1+0x58>
      remove_from_list(&ptable.pLists.sleep, p);
8010553f:	83 ec 08             	sub    $0x8,%esp
80105542:	ff 75 f4             	pushl  -0xc(%ebp)
80105545:	68 d8 70 11 80       	push   $0x801170d8
8010554a:	e8 41 0a 00 00       	call   80105f90 <remove_from_list>
8010554f:	83 c4 10             	add    $0x10,%esp
      assert_state(p, SLEEPING);
80105552:	83 ec 08             	sub    $0x8,%esp
80105555:	6a 02                	push   $0x2
80105557:	ff 75 f4             	pushl  -0xc(%ebp)
8010555a:	e8 10 0a 00 00       	call   80105f6f <assert_state>
8010555f:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
80105562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105565:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      add_to_ready(p, RUNNABLE);
8010556c:	83 ec 08             	sub    $0x8,%esp
8010556f:	6a 03                	push   $0x3
80105571:	ff 75 f4             	pushl  -0xc(%ebp)
80105574:	e8 04 0b 00 00       	call   8010607d <add_to_ready>
80105579:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
8010557c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010557f:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105585:	89 45 f4             	mov    %eax,-0xc(%ebp)
#else
static void
wakeup1(void *chan)
{
  struct proc* p = ptable.pLists.sleep;
  while (p) {
80105588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010558c:	75 a6                	jne    80105534 <wakeup1+0x10>
      p->state = RUNNABLE;
      add_to_ready(p, RUNNABLE);
    }
    p = p->next;
  }
}
8010558e:	90                   	nop
8010558f:	c9                   	leave  
80105590:	c3                   	ret    

80105591 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105591:	55                   	push   %ebp
80105592:	89 e5                	mov    %esp,%ebp
80105594:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105597:	83 ec 0c             	sub    $0xc,%esp
8010559a:	68 80 49 11 80       	push   $0x80114980
8010559f:	e8 a2 10 00 00       	call   80106646 <acquire>
801055a4:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801055a7:	83 ec 0c             	sub    $0xc,%esp
801055aa:	ff 75 08             	pushl  0x8(%ebp)
801055ad:	e8 72 ff ff ff       	call   80105524 <wakeup1>
801055b2:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801055b5:	83 ec 0c             	sub    $0xc,%esp
801055b8:	68 80 49 11 80       	push   $0x80114980
801055bd:	e8 eb 10 00 00       	call   801066ad <release>
801055c2:	83 c4 10             	add    $0x10,%esp
}
801055c5:	90                   	nop
801055c6:	c9                   	leave  
801055c7:	c3                   	ret    

801055c8 <kill>:
}

#else
int
kill(int pid)
{
801055c8:	55                   	push   %ebp
801055c9:	89 e5                	mov    %esp,%ebp
801055cb:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;

  acquire(&ptable.lock);
801055ce:	83 ec 0c             	sub    $0xc,%esp
801055d1:	68 80 49 11 80       	push   $0x80114980
801055d6:	e8 6b 10 00 00       	call   80106646 <acquire>
801055db:	83 c4 10             	add    $0x10,%esp
  // Search through embryo
  p = ptable.pLists.embryo;
801055de:	a1 b8 70 11 80       	mov    0x801170b8,%eax
801055e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
801055e6:	eb 3d                	jmp    80105625 <kill+0x5d>
    if (p->pid == pid) {
801055e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055eb:	8b 50 10             	mov    0x10(%eax),%edx
801055ee:	8b 45 08             	mov    0x8(%ebp),%eax
801055f1:	39 c2                	cmp    %eax,%edx
801055f3:	75 24                	jne    80105619 <kill+0x51>
      p->killed = 1;
801055f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
801055ff:	83 ec 0c             	sub    $0xc,%esp
80105602:	68 80 49 11 80       	push   $0x80114980
80105607:	e8 a1 10 00 00       	call   801066ad <release>
8010560c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010560f:	b8 00 00 00 00       	mov    $0x0,%eax
80105614:	e9 65 01 00 00       	jmp    8010577e <kill+0x1b6>
    }
    p = p->next;
80105619:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010561c:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105622:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc* p;

  acquire(&ptable.lock);
  // Search through embryo
  p = ptable.pLists.embryo;
  while (p) {
80105625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105629:	75 bd                	jne    801055e8 <kill+0x20>
      return 0;
    }
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
8010562b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105632:	eb 5b                	jmp    8010568f <kill+0xc7>
    p = ptable.pLists.ready[i];
80105634:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105637:	05 cc 09 00 00       	add    $0x9cc,%eax
8010563c:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80105643:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105646:	eb 3d                	jmp    80105685 <kill+0xbd>
      if (p->pid == pid) {
80105648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010564b:	8b 50 10             	mov    0x10(%eax),%edx
8010564e:	8b 45 08             	mov    0x8(%ebp),%eax
80105651:	39 c2                	cmp    %eax,%edx
80105653:	75 24                	jne    80105679 <kill+0xb1>
        p->killed = 1;
80105655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105658:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        release(&ptable.lock);
8010565f:	83 ec 0c             	sub    $0xc,%esp
80105662:	68 80 49 11 80       	push   $0x80114980
80105667:	e8 41 10 00 00       	call   801066ad <release>
8010566c:	83 c4 10             	add    $0x10,%esp
        return 0;
8010566f:	b8 00 00 00 00       	mov    $0x0,%eax
80105674:	e9 05 01 00 00       	jmp    8010577e <kill+0x1b6>
      }
      p = p->next;
80105679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010567c:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105682:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
    p = ptable.pLists.ready[i];
    while (p) {
80105685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105689:	75 bd                	jne    80105648 <kill+0x80>
      return 0;
    }
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
8010568b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010568f:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80105693:	7e 9f                	jle    80105634 <kill+0x6c>
      }
      p = p->next;
    }
  }
  // Search through embryo
  p = ptable.pLists.running;
80105695:	a1 d4 70 11 80       	mov    0x801170d4,%eax
8010569a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
8010569d:	eb 3d                	jmp    801056dc <kill+0x114>
    if (p->pid == pid) {
8010569f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a2:	8b 50 10             	mov    0x10(%eax),%edx
801056a5:	8b 45 08             	mov    0x8(%ebp),%eax
801056a8:	39 c2                	cmp    %eax,%edx
801056aa:	75 24                	jne    801056d0 <kill+0x108>
      p->killed = 1;
801056ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056af:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
801056b6:	83 ec 0c             	sub    $0xc,%esp
801056b9:	68 80 49 11 80       	push   $0x80114980
801056be:	e8 ea 0f 00 00       	call   801066ad <release>
801056c3:	83 c4 10             	add    $0x10,%esp
      return 0;
801056c6:	b8 00 00 00 00       	mov    $0x0,%eax
801056cb:	e9 ae 00 00 00       	jmp    8010577e <kill+0x1b6>
    }
    p = p->next;
801056d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d3:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801056d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      p = p->next;
    }
  }
  // Search through embryo
  p = ptable.pLists.running;
  while (p) {
801056dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056e0:	75 bd                	jne    8010569f <kill+0xd7>
      return 0;
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
801056e2:	a1 d8 70 11 80       	mov    0x801170d8,%eax
801056e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
801056ea:	eb 77                	jmp    80105763 <kill+0x19b>
    if (p->pid == pid) {
801056ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ef:	8b 50 10             	mov    0x10(%eax),%edx
801056f2:	8b 45 08             	mov    0x8(%ebp),%eax
801056f5:	39 c2                	cmp    %eax,%edx
801056f7:	75 5e                	jne    80105757 <kill+0x18f>
      p->killed = 1;
801056f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056fc:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      remove_from_list(&ptable.pLists.sleep, p);
80105703:	83 ec 08             	sub    $0x8,%esp
80105706:	ff 75 f4             	pushl  -0xc(%ebp)
80105709:	68 d8 70 11 80       	push   $0x801170d8
8010570e:	e8 7d 08 00 00       	call   80105f90 <remove_from_list>
80105713:	83 c4 10             	add    $0x10,%esp
      assert_state(p, SLEEPING);
80105716:	83 ec 08             	sub    $0x8,%esp
80105719:	6a 02                	push   $0x2
8010571b:	ff 75 f4             	pushl  -0xc(%ebp)
8010571e:	e8 4c 08 00 00       	call   80105f6f <assert_state>
80105723:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
80105726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105729:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      add_to_ready(p, RUNNABLE);
80105730:	83 ec 08             	sub    $0x8,%esp
80105733:	6a 03                	push   $0x3
80105735:	ff 75 f4             	pushl  -0xc(%ebp)
80105738:	e8 40 09 00 00       	call   8010607d <add_to_ready>
8010573d:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	68 80 49 11 80       	push   $0x80114980
80105748:	e8 60 0f 00 00       	call   801066ad <release>
8010574d:	83 c4 10             	add    $0x10,%esp
      return 0;
80105750:	b8 00 00 00 00       	mov    $0x0,%eax
80105755:	eb 27                	jmp    8010577e <kill+0x1b6>
    }
    p = p->next;
80105757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575a:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105760:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
  while (p) {
80105763:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105767:	75 83                	jne    801056ec <kill+0x124>
      return 0;
    }
    p = p->next;
  }

  release(&ptable.lock);
80105769:	83 ec 0c             	sub    $0xc,%esp
8010576c:	68 80 49 11 80       	push   $0x80114980
80105771:	e8 37 0f 00 00       	call   801066ad <release>
80105776:	83 c4 10             	add    $0x10,%esp
  return -1;
80105779:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010577e:	c9                   	leave  
8010577f:	c3                   	ret    

80105780 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
80105784:	83 ec 54             	sub    $0x54,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
80105787:	83 ec 04             	sub    $0x4,%esp
8010578a:	68 2f a1 10 80       	push   $0x8010a12f
8010578f:	68 33 a1 10 80       	push   $0x8010a133
80105794:	68 37 a1 10 80       	push   $0x8010a137
80105799:	68 3f a1 10 80       	push   $0x8010a13f
8010579e:	68 45 a1 10 80       	push   $0x8010a145
801057a3:	68 4a a1 10 80       	push   $0x8010a14a
801057a8:	68 4f a1 10 80       	push   $0x8010a14f
801057ad:	68 53 a1 10 80       	push   $0x8010a153
801057b2:	68 57 a1 10 80       	push   $0x8010a157
801057b7:	68 5c a1 10 80       	push   $0x8010a15c
801057bc:	68 60 a1 10 80       	push   $0x8010a160
801057c1:	e8 00 ac ff ff       	call   801003c6 <cprintf>
801057c6:	83 c4 30             	add    $0x30,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801057c9:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
801057d0:	e9 31 02 00 00       	jmp    80105a06 <procdump+0x286>
    if(p->state == UNUSED)
801057d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d8:	8b 40 0c             	mov    0xc(%eax),%eax
801057db:	85 c0                	test   %eax,%eax
801057dd:	0f 84 1b 02 00 00    	je     801059fe <procdump+0x27e>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801057e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e6:	8b 40 0c             	mov    0xc(%eax),%eax
801057e9:	83 f8 05             	cmp    $0x5,%eax
801057ec:	77 23                	ja     80105811 <procdump+0x91>
801057ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057f1:	8b 40 0c             	mov    0xc(%eax),%eax
801057f4:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801057fb:	85 c0                	test   %eax,%eax
801057fd:	74 12                	je     80105811 <procdump+0x91>
      state = states[p->state];
801057ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105802:	8b 40 0c             	mov    0xc(%eax),%eax
80105805:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
8010580c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010580f:	eb 07                	jmp    80105818 <procdump+0x98>
    else
      state = "???";
80105811:	c7 45 ec 89 a1 10 80 	movl   $0x8010a189,-0x14(%ebp)
    uint seconds = (ticks - p->start_ticks)/100;
80105818:	8b 15 00 79 11 80    	mov    0x80117900,%edx
8010581e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105821:	8b 40 7c             	mov    0x7c(%eax),%eax
80105824:	29 c2                	sub    %eax,%edx
80105826:	89 d0                	mov    %edx,%eax
80105828:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010582d:	f7 e2                	mul    %edx
8010582f:	89 d0                	mov    %edx,%eax
80105831:	c1 e8 05             	shr    $0x5,%eax
80105834:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint partial_seconds = (ticks - p->start_ticks)%100;
80105837:	8b 15 00 79 11 80    	mov    0x80117900,%edx
8010583d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105840:	8b 40 7c             	mov    0x7c(%eax),%eax
80105843:	89 d1                	mov    %edx,%ecx
80105845:	29 c1                	sub    %eax,%ecx
80105847:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010584c:	89 c8                	mov    %ecx,%eax
8010584e:	f7 e2                	mul    %edx
80105850:	89 d0                	mov    %edx,%eax
80105852:	c1 e8 05             	shr    $0x5,%eax
80105855:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105858:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010585b:	6b c0 64             	imul   $0x64,%eax,%eax
8010585e:	29 c1                	sub    %eax,%ecx
80105860:	89 c8                	mov    %ecx,%eax
80105862:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("%d\t %s\t\t %d\t %d\t", p->pid, p->name, p->uid, p->gid);
80105865:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105868:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
8010586e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105871:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105877:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010587a:	8d 58 6c             	lea    0x6c(%eax),%ebx
8010587d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105880:	8b 40 10             	mov    0x10(%eax),%eax
80105883:	83 ec 0c             	sub    $0xc,%esp
80105886:	51                   	push   %ecx
80105887:	52                   	push   %edx
80105888:	53                   	push   %ebx
80105889:	50                   	push   %eax
8010588a:	68 8d a1 10 80       	push   $0x8010a18d
8010588f:	e8 32 ab ff ff       	call   801003c6 <cprintf>
80105894:	83 c4 20             	add    $0x20,%esp
    if (p->parent)
80105897:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010589a:	8b 40 14             	mov    0x14(%eax),%eax
8010589d:	85 c0                	test   %eax,%eax
8010589f:	74 1c                	je     801058bd <procdump+0x13d>
      cprintf(" %d\t", p->parent->pid);
801058a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a4:	8b 40 14             	mov    0x14(%eax),%eax
801058a7:	8b 40 10             	mov    0x10(%eax),%eax
801058aa:	83 ec 08             	sub    $0x8,%esp
801058ad:	50                   	push   %eax
801058ae:	68 9e a1 10 80       	push   $0x8010a19e
801058b3:	e8 0e ab ff ff       	call   801003c6 <cprintf>
801058b8:	83 c4 10             	add    $0x10,%esp
801058bb:	eb 17                	jmp    801058d4 <procdump+0x154>
    else
      cprintf(" %d\t", p->pid);
801058bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058c0:	8b 40 10             	mov    0x10(%eax),%eax
801058c3:	83 ec 08             	sub    $0x8,%esp
801058c6:	50                   	push   %eax
801058c7:	68 9e a1 10 80       	push   $0x8010a19e
801058cc:	e8 f5 aa ff ff       	call   801003c6 <cprintf>
801058d1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %d\t %s\t %d.", p->priority, state, seconds);
801058d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801058dd:	ff 75 e8             	pushl  -0x18(%ebp)
801058e0:	ff 75 ec             	pushl  -0x14(%ebp)
801058e3:	50                   	push   %eax
801058e4:	68 a3 a1 10 80       	push   $0x8010a1a3
801058e9:	e8 d8 aa ff ff       	call   801003c6 <cprintf>
801058ee:	83 c4 10             	add    $0x10,%esp
    if (partial_seconds < 10)
801058f1:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
801058f5:	77 10                	ja     80105907 <procdump+0x187>
	cprintf("0");
801058f7:	83 ec 0c             	sub    $0xc,%esp
801058fa:	68 b0 a1 10 80       	push   $0x8010a1b0
801058ff:	e8 c2 aa ff ff       	call   801003c6 <cprintf>
80105904:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t", partial_seconds);
80105907:	83 ec 08             	sub    $0x8,%esp
8010590a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010590d:	68 b2 a1 10 80       	push   $0x8010a1b2
80105912:	e8 af aa ff ff       	call   801003c6 <cprintf>
80105917:	83 c4 10             	add    $0x10,%esp
    uint cpu_seconds = p->cpu_ticks_total/100;
8010591a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010591d:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105923:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105928:	f7 e2                	mul    %edx
8010592a:	89 d0                	mov    %edx,%eax
8010592c:	c1 e8 05             	shr    $0x5,%eax
8010592f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    uint cpu_partial_seconds = p->cpu_ticks_total%100;
80105932:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105935:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
8010593b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105940:	89 c8                	mov    %ecx,%eax
80105942:	f7 e2                	mul    %edx
80105944:	89 d0                	mov    %edx,%eax
80105946:	c1 e8 05             	shr    $0x5,%eax
80105949:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010594c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010594f:	6b c0 64             	imul   $0x64,%eax,%eax
80105952:	29 c1                	sub    %eax,%ecx
80105954:	89 c8                	mov    %ecx,%eax
80105956:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (cpu_partial_seconds < 10)
80105959:	83 7d dc 09          	cmpl   $0x9,-0x24(%ebp)
8010595d:	77 18                	ja     80105977 <procdump+0x1f7>
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
8010595f:	83 ec 04             	sub    $0x4,%esp
80105962:	ff 75 dc             	pushl  -0x24(%ebp)
80105965:	ff 75 e0             	pushl  -0x20(%ebp)
80105968:	68 b6 a1 10 80       	push   $0x8010a1b6
8010596d:	e8 54 aa ff ff       	call   801003c6 <cprintf>
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	eb 16                	jmp    8010598d <procdump+0x20d>
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
80105977:	83 ec 04             	sub    $0x4,%esp
8010597a:	ff 75 dc             	pushl  -0x24(%ebp)
8010597d:	ff 75 e0             	pushl  -0x20(%ebp)
80105980:	68 c0 a1 10 80       	push   $0x8010a1c0
80105985:	e8 3c aa ff ff       	call   801003c6 <cprintf>
8010598a:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
8010598d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105990:	8b 40 0c             	mov    0xc(%eax),%eax
80105993:	83 f8 02             	cmp    $0x2,%eax
80105996:	75 54                	jne    801059ec <procdump+0x26c>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105998:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010599b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010599e:	8b 40 0c             	mov    0xc(%eax),%eax
801059a1:	83 c0 08             	add    $0x8,%eax
801059a4:	89 c2                	mov    %eax,%edx
801059a6:	83 ec 08             	sub    $0x8,%esp
801059a9:	8d 45 b4             	lea    -0x4c(%ebp),%eax
801059ac:	50                   	push   %eax
801059ad:	52                   	push   %edx
801059ae:	e8 4c 0d 00 00       	call   801066ff <getcallerpcs>
801059b3:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801059b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801059bd:	eb 1c                	jmp    801059db <procdump+0x25b>
        cprintf(" %p", pc[i]);
801059bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c2:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
801059c6:	83 ec 08             	sub    $0x8,%esp
801059c9:	50                   	push   %eax
801059ca:	68 c9 a1 10 80       	push   $0x8010a1c9
801059cf:	e8 f2 a9 ff ff       	call   801003c6 <cprintf>
801059d4:	83 c4 10             	add    $0x10,%esp
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801059d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801059db:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801059df:	7f 0b                	jg     801059ec <procdump+0x26c>
801059e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e4:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
801059e8:	85 c0                	test   %eax,%eax
801059ea:	75 d3                	jne    801059bf <procdump+0x23f>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801059ec:	83 ec 0c             	sub    $0xc,%esp
801059ef:	68 cd a1 10 80       	push   $0x8010a1cd
801059f4:	e8 cd a9 ff ff       	call   801003c6 <cprintf>
801059f9:	83 c4 10             	add    $0x10,%esp
801059fc:	eb 01                	jmp    801059ff <procdump+0x27f>
  uint pc[10];
  
  cprintf("%s\t %s\t\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801059fe:	90                   	nop
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801059ff:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105a06:	81 7d f0 b4 70 11 80 	cmpl   $0x801170b4,-0x10(%ebp)
80105a0d:	0f 82 c2 fd ff ff    	jb     801057d5 <procdump+0x55>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105a13:	90                   	nop
80105a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a17:	c9                   	leave  
80105a18:	c3                   	ret    

80105a19 <getproc_helper>:

int
getproc_helper(int m, struct uproc* table)
{
80105a19:	55                   	push   %ebp
80105a1a:	89 e5                	mov    %esp,%ebp
80105a1c:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int i = 0;
80105a1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
80105a26:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80105a2d:	e9 ac 01 00 00       	jmp    80105bde <getproc_helper+0x1c5>
  {
    if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
80105a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a35:	8b 40 0c             	mov    0xc(%eax),%eax
80105a38:	83 f8 04             	cmp    $0x4,%eax
80105a3b:	74 1a                	je     80105a57 <getproc_helper+0x3e>
80105a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a40:	8b 40 0c             	mov    0xc(%eax),%eax
80105a43:	83 f8 03             	cmp    $0x3,%eax
80105a46:	74 0f                	je     80105a57 <getproc_helper+0x3e>
80105a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4b:	8b 40 0c             	mov    0xc(%eax),%eax
80105a4e:	83 f8 02             	cmp    $0x2,%eax
80105a51:	0f 85 80 01 00 00    	jne    80105bd7 <getproc_helper+0x1be>
    {
      table[i].pid = p->pid;
80105a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a5a:	89 d0                	mov    %edx,%eax
80105a5c:	01 c0                	add    %eax,%eax
80105a5e:	01 d0                	add    %edx,%eax
80105a60:	c1 e0 05             	shl    $0x5,%eax
80105a63:	89 c2                	mov    %eax,%edx
80105a65:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a68:	01 c2                	add    %eax,%edx
80105a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a6d:	8b 40 10             	mov    0x10(%eax),%eax
80105a70:	89 02                	mov    %eax,(%edx)
      table[i].uid = p->uid;
80105a72:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a75:	89 d0                	mov    %edx,%eax
80105a77:	01 c0                	add    %eax,%eax
80105a79:	01 d0                	add    %edx,%eax
80105a7b:	c1 e0 05             	shl    $0x5,%eax
80105a7e:	89 c2                	mov    %eax,%edx
80105a80:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a83:	01 c2                	add    %eax,%edx
80105a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a88:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105a8e:	89 42 04             	mov    %eax,0x4(%edx)
      table[i].gid = p->gid;
80105a91:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a94:	89 d0                	mov    %edx,%eax
80105a96:	01 c0                	add    %eax,%eax
80105a98:	01 d0                	add    %edx,%eax
80105a9a:	c1 e0 05             	shl    $0x5,%eax
80105a9d:	89 c2                	mov    %eax,%edx
80105a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aa2:	01 c2                	add    %eax,%edx
80105aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105aad:	89 42 08             	mov    %eax,0x8(%edx)
      if (p->parent)
80105ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab3:	8b 40 14             	mov    0x14(%eax),%eax
80105ab6:	85 c0                	test   %eax,%eax
80105ab8:	74 21                	je     80105adb <getproc_helper+0xc2>
        table[i].ppid = p->parent->pid;
80105aba:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105abd:	89 d0                	mov    %edx,%eax
80105abf:	01 c0                	add    %eax,%eax
80105ac1:	01 d0                	add    %edx,%eax
80105ac3:	c1 e0 05             	shl    $0x5,%eax
80105ac6:	89 c2                	mov    %eax,%edx
80105ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105acb:	01 c2                	add    %eax,%edx
80105acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad0:	8b 40 14             	mov    0x14(%eax),%eax
80105ad3:	8b 40 10             	mov    0x10(%eax),%eax
80105ad6:	89 42 0c             	mov    %eax,0xc(%edx)
80105ad9:	eb 1c                	jmp    80105af7 <getproc_helper+0xde>
      else
        table[i].ppid = p->pid;
80105adb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ade:	89 d0                	mov    %edx,%eax
80105ae0:	01 c0                	add    %eax,%eax
80105ae2:	01 d0                	add    %edx,%eax
80105ae4:	c1 e0 05             	shl    $0x5,%eax
80105ae7:	89 c2                	mov    %eax,%edx
80105ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aec:	01 c2                	add    %eax,%edx
80105aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af1:	8b 40 10             	mov    0x10(%eax),%eax
80105af4:	89 42 0c             	mov    %eax,0xc(%edx)
      table[i].priority = p->priority;
80105af7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105afa:	89 d0                	mov    %edx,%eax
80105afc:	01 c0                	add    %eax,%eax
80105afe:	01 d0                	add    %edx,%eax
80105b00:	c1 e0 05             	shl    $0x5,%eax
80105b03:	89 c2                	mov    %eax,%edx
80105b05:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b08:	01 c2                	add    %eax,%edx
80105b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b13:	89 42 10             	mov    %eax,0x10(%edx)
      table[i].elapsed_ticks = (ticks - p->start_ticks);
80105b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b19:	89 d0                	mov    %edx,%eax
80105b1b:	01 c0                	add    %eax,%eax
80105b1d:	01 d0                	add    %edx,%eax
80105b1f:	c1 e0 05             	shl    $0x5,%eax
80105b22:	89 c2                	mov    %eax,%edx
80105b24:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b27:	01 c2                	add    %eax,%edx
80105b29:	8b 0d 00 79 11 80    	mov    0x80117900,%ecx
80105b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b32:	8b 40 7c             	mov    0x7c(%eax),%eax
80105b35:	29 c1                	sub    %eax,%ecx
80105b37:	89 c8                	mov    %ecx,%eax
80105b39:	89 42 14             	mov    %eax,0x14(%edx)
      table[i].CPU_total_ticks = p->cpu_ticks_total;
80105b3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b3f:	89 d0                	mov    %edx,%eax
80105b41:	01 c0                	add    %eax,%eax
80105b43:	01 d0                	add    %edx,%eax
80105b45:	c1 e0 05             	shl    $0x5,%eax
80105b48:	89 c2                	mov    %eax,%edx
80105b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b4d:	01 c2                	add    %eax,%edx
80105b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b52:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105b58:	89 42 18             	mov    %eax,0x18(%edx)
      table[i].size = p->sz;
80105b5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b5e:	89 d0                	mov    %edx,%eax
80105b60:	01 c0                	add    %eax,%eax
80105b62:	01 d0                	add    %edx,%eax
80105b64:	c1 e0 05             	shl    $0x5,%eax
80105b67:	89 c2                	mov    %eax,%edx
80105b69:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b6c:	01 c2                	add    %eax,%edx
80105b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b71:	8b 00                	mov    (%eax),%eax
80105b73:	89 42 3c             	mov    %eax,0x3c(%edx)
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
80105b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b79:	8b 40 0c             	mov    0xc(%eax),%eax
80105b7c:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
80105b83:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b86:	89 d0                	mov    %edx,%eax
80105b88:	01 c0                	add    %eax,%eax
80105b8a:	01 d0                	add    %edx,%eax
80105b8c:	c1 e0 05             	shl    $0x5,%eax
80105b8f:	89 c2                	mov    %eax,%edx
80105b91:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b94:	01 d0                	add    %edx,%eax
80105b96:	83 c0 1c             	add    $0x1c,%eax
80105b99:	83 ec 04             	sub    $0x4,%esp
80105b9c:	6a 05                	push   $0x5
80105b9e:	51                   	push   %ecx
80105b9f:	50                   	push   %eax
80105ba0:	e8 af 0e 00 00       	call   80106a54 <strncpy>
80105ba5:	83 c4 10             	add    $0x10,%esp
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
80105ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bab:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105bae:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bb1:	89 d0                	mov    %edx,%eax
80105bb3:	01 c0                	add    %eax,%eax
80105bb5:	01 d0                	add    %edx,%eax
80105bb7:	c1 e0 05             	shl    $0x5,%eax
80105bba:	89 c2                	mov    %eax,%edx
80105bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bbf:	01 d0                	add    %edx,%eax
80105bc1:	83 c0 40             	add    $0x40,%eax
80105bc4:	83 ec 04             	sub    $0x4,%esp
80105bc7:	6a 11                	push   $0x11
80105bc9:	51                   	push   %ecx
80105bca:	50                   	push   %eax
80105bcb:	e8 84 0e 00 00       	call   80106a54 <strncpy>
80105bd0:	83 c4 10             	add    $0x10,%esp
      i++;
80105bd3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
int
getproc_helper(int m, struct uproc* table)
{
  struct proc* p;
  int i = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
80105bd7:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80105bde:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80105be5:	73 0c                	jae    80105bf3 <getproc_helper+0x1da>
80105be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bea:	3b 45 08             	cmp    0x8(%ebp),%eax
80105bed:	0f 8c 3f fe ff ff    	jl     80105a32 <getproc_helper+0x19>
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
      i++;
    }
  }
  return i;  
80105bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105bf6:	c9                   	leave  
80105bf7:	c3                   	ret    

80105bf8 <free_length>:

// Counts the number of procs in the free list when ctrl-f is pressed
void
free_length(void)
{
80105bf8:	55                   	push   %ebp
80105bf9:	89 e5                	mov    %esp,%ebp
80105bfb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105bfe:	83 ec 0c             	sub    $0xc,%esp
80105c01:	68 80 49 11 80       	push   $0x80114980
80105c06:	e8 3b 0a 00 00       	call   80106646 <acquire>
80105c0b:	83 c4 10             	add    $0x10,%esp
  struct proc* f = ptable.pLists.free;
80105c0e:	a1 b4 70 11 80       	mov    0x801170b4,%eax
80105c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
80105c16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (!f) {
80105c1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c21:	75 35                	jne    80105c58 <free_length+0x60>
    cprintf("Free List Size: %d\n", count);
80105c23:	83 ec 08             	sub    $0x8,%esp
80105c26:	ff 75 f0             	pushl  -0x10(%ebp)
80105c29:	68 cf a1 10 80       	push   $0x8010a1cf
80105c2e:	e8 93 a7 ff ff       	call   801003c6 <cprintf>
80105c33:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105c36:	83 ec 0c             	sub    $0xc,%esp
80105c39:	68 80 49 11 80       	push   $0x80114980
80105c3e:	e8 6a 0a 00 00       	call   801066ad <release>
80105c43:	83 c4 10             	add    $0x10,%esp
  }
  while (f)
80105c46:	eb 10                	jmp    80105c58 <free_length+0x60>
  {
    ++count;
80105c48:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    f = f->next;
80105c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4f:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
  if (!f) {
    cprintf("Free List Size: %d\n", count);
    release(&ptable.lock);
  }
  while (f)
80105c58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c5c:	75 ea                	jne    80105c48 <free_length+0x50>
  {
    ++count;
    f = f->next;
  }
  cprintf("Free List Size: %d\n", count);
80105c5e:	83 ec 08             	sub    $0x8,%esp
80105c61:	ff 75 f0             	pushl  -0x10(%ebp)
80105c64:	68 cf a1 10 80       	push   $0x8010a1cf
80105c69:	e8 58 a7 ff ff       	call   801003c6 <cprintf>
80105c6e:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105c71:	83 ec 0c             	sub    $0xc,%esp
80105c74:	68 80 49 11 80       	push   $0x80114980
80105c79:	e8 2f 0a 00 00       	call   801066ad <release>
80105c7e:	83 c4 10             	add    $0x10,%esp
}
80105c81:	90                   	nop
80105c82:	c9                   	leave  
80105c83:	c3                   	ret    

80105c84 <display_ready>:

// Displays the PIDs of all processes in the ready list
void
display_ready(void)
{
80105c84:	55                   	push   %ebp
80105c85:	89 e5                	mov    %esp,%ebp
80105c87:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105c8a:	83 ec 0c             	sub    $0xc,%esp
80105c8d:	68 80 49 11 80       	push   $0x80114980
80105c92:	e8 af 09 00 00       	call   80106646 <acquire>
80105c97:	83 c4 10             	add    $0x10,%esp
  cprintf("Ready List Processes:\n");
80105c9a:	83 ec 0c             	sub    $0xc,%esp
80105c9d:	68 e3 a1 10 80       	push   $0x8010a1e3
80105ca2:	e8 1f a7 ff ff       	call   801003c6 <cprintf>
80105ca7:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX+1; i++) {
80105caa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105cb1:	e9 a4 00 00 00       	jmp    80105d5a <display_ready+0xd6>
    cprintf("Queue %d: ", i);
80105cb6:	83 ec 08             	sub    $0x8,%esp
80105cb9:	ff 75 f4             	pushl  -0xc(%ebp)
80105cbc:	68 fa a1 10 80       	push   $0x8010a1fa
80105cc1:	e8 00 a7 ff ff       	call   801003c6 <cprintf>
80105cc6:	83 c4 10             	add    $0x10,%esp
    struct proc* r = ptable.pLists.ready[i];
80105cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ccc:	05 cc 09 00 00       	add    $0x9cc,%eax
80105cd1:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80105cd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!r) {
80105cdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cdf:	75 6f                	jne    80105d50 <display_ready+0xcc>
      cprintf("\n");
80105ce1:	83 ec 0c             	sub    $0xc,%esp
80105ce4:	68 cd a1 10 80       	push   $0x8010a1cd
80105ce9:	e8 d8 a6 ff ff       	call   801003c6 <cprintf>
80105cee:	83 c4 10             	add    $0x10,%esp
      continue;
80105cf1:	eb 63                	jmp    80105d56 <display_ready+0xd2>
    }
    while (r) {
      if (!r->next)
80105cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf6:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105cfc:	85 c0                	test   %eax,%eax
80105cfe:	75 23                	jne    80105d23 <display_ready+0x9f>
        cprintf("(%d, %d)\n", r->pid, r->budget);
80105d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d03:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0c:	8b 40 10             	mov    0x10(%eax),%eax
80105d0f:	83 ec 04             	sub    $0x4,%esp
80105d12:	52                   	push   %edx
80105d13:	50                   	push   %eax
80105d14:	68 05 a2 10 80       	push   $0x8010a205
80105d19:	e8 a8 a6 ff ff       	call   801003c6 <cprintf>
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	eb 21                	jmp    80105d44 <display_ready+0xc0>
      else
        cprintf("(%d, %d) -> ", r->pid, r->budget);
80105d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d26:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2f:	8b 40 10             	mov    0x10(%eax),%eax
80105d32:	83 ec 04             	sub    $0x4,%esp
80105d35:	52                   	push   %edx
80105d36:	50                   	push   %eax
80105d37:	68 0f a2 10 80       	push   $0x8010a20f
80105d3c:	e8 85 a6 ff ff       	call   801003c6 <cprintf>
80105d41:	83 c4 10             	add    $0x10,%esp
      r = r->next;
80105d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d47:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105d4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct proc* r = ptable.pLists.ready[i];
    if (!r) {
      cprintf("\n");
      continue;
    }
    while (r) {
80105d50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d54:	75 9d                	jne    80105cf3 <display_ready+0x6f>
void
display_ready(void)
{
  acquire(&ptable.lock);
  cprintf("Ready List Processes:\n");
  for (int i = 0; i < MAX+1; i++) {
80105d56:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105d5a:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
80105d5e:	0f 8e 52 ff ff ff    	jle    80105cb6 <display_ready+0x32>
      else
        cprintf("(%d, %d) -> ", r->pid, r->budget);
      r = r->next;
    }
  }
  release(&ptable.lock);
80105d64:	83 ec 0c             	sub    $0xc,%esp
80105d67:	68 80 49 11 80       	push   $0x80114980
80105d6c:	e8 3c 09 00 00       	call   801066ad <release>
80105d71:	83 c4 10             	add    $0x10,%esp
  return;
80105d74:	90                   	nop
}
80105d75:	c9                   	leave  
80105d76:	c3                   	ret    

80105d77 <display_sleep>:

// Displays the PIDs of all processes in the sleep list
void
display_sleep(void)
{
80105d77:	55                   	push   %ebp
80105d78:	89 e5                	mov    %esp,%ebp
80105d7a:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105d7d:	83 ec 0c             	sub    $0xc,%esp
80105d80:	68 80 49 11 80       	push   $0x80114980
80105d85:	e8 bc 08 00 00       	call   80106646 <acquire>
80105d8a:	83 c4 10             	add    $0x10,%esp
  struct proc* s = ptable.pLists.sleep;
80105d8d:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80105d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!s) {
80105d95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d99:	75 22                	jne    80105dbd <display_sleep+0x46>
    cprintf("No processes currently in sleep.\n");
80105d9b:	83 ec 0c             	sub    $0xc,%esp
80105d9e:	68 1c a2 10 80       	push   $0x8010a21c
80105da3:	e8 1e a6 ff ff       	call   801003c6 <cprintf>
80105da8:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105dab:	83 ec 0c             	sub    $0xc,%esp
80105dae:	68 80 49 11 80       	push   $0x80114980
80105db3:	e8 f5 08 00 00       	call   801066ad <release>
80105db8:	83 c4 10             	add    $0x10,%esp
    return;
80105dbb:	eb 72                	jmp    80105e2f <display_sleep+0xb8>
  }
  cprintf("Sleep List Processes:\n");
80105dbd:	83 ec 0c             	sub    $0xc,%esp
80105dc0:	68 3e a2 10 80       	push   $0x8010a23e
80105dc5:	e8 fc a5 ff ff       	call   801003c6 <cprintf>
80105dca:	83 c4 10             	add    $0x10,%esp
  while (s) {
80105dcd:	eb 49                	jmp    80105e18 <display_sleep+0xa1>
    if (!s->next)
80105dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd2:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105dd8:	85 c0                	test   %eax,%eax
80105dda:	75 19                	jne    80105df5 <display_sleep+0x7e>
      cprintf("%d\n", s->pid);
80105ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ddf:	8b 40 10             	mov    0x10(%eax),%eax
80105de2:	83 ec 08             	sub    $0x8,%esp
80105de5:	50                   	push   %eax
80105de6:	68 55 a2 10 80       	push   $0x8010a255
80105deb:	e8 d6 a5 ff ff       	call   801003c6 <cprintf>
80105df0:	83 c4 10             	add    $0x10,%esp
80105df3:	eb 17                	jmp    80105e0c <display_sleep+0x95>
    else
      cprintf("%d -> ", s->pid);
80105df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df8:	8b 40 10             	mov    0x10(%eax),%eax
80105dfb:	83 ec 08             	sub    $0x8,%esp
80105dfe:	50                   	push   %eax
80105dff:	68 59 a2 10 80       	push   $0x8010a259
80105e04:	e8 bd a5 ff ff       	call   801003c6 <cprintf>
80105e09:	83 c4 10             	add    $0x10,%esp
    s = s->next;
80105e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0f:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in sleep.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Sleep List Processes:\n");
  while (s) {
80105e18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e1c:	75 b1                	jne    80105dcf <display_sleep+0x58>
      cprintf("%d\n", s->pid);
    else
      cprintf("%d -> ", s->pid);
    s = s->next;
  }
  release(&ptable.lock);
80105e1e:	83 ec 0c             	sub    $0xc,%esp
80105e21:	68 80 49 11 80       	push   $0x80114980
80105e26:	e8 82 08 00 00       	call   801066ad <release>
80105e2b:	83 c4 10             	add    $0x10,%esp
  return;
80105e2e:	90                   	nop
}
80105e2f:	c9                   	leave  
80105e30:	c3                   	ret    

80105e31 <display_zombie>:

// Displays the PID/PPID of processes in the zombie list
void display_zombie(void)
{
80105e31:	55                   	push   %ebp
80105e32:	89 e5                	mov    %esp,%ebp
80105e34:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105e37:	83 ec 0c             	sub    $0xc,%esp
80105e3a:	68 80 49 11 80       	push   $0x80114980
80105e3f:	e8 02 08 00 00       	call   80106646 <acquire>
80105e44:	83 c4 10             	add    $0x10,%esp
  struct proc* z = ptable.pLists.zombie;
80105e47:	a1 dc 70 11 80       	mov    0x801170dc,%eax
80105e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!z) {
80105e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e53:	75 25                	jne    80105e7a <display_zombie+0x49>
    cprintf("No processes currently in zombie.\n");
80105e55:	83 ec 0c             	sub    $0xc,%esp
80105e58:	68 60 a2 10 80       	push   $0x8010a260
80105e5d:	e8 64 a5 ff ff       	call   801003c6 <cprintf>
80105e62:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105e65:	83 ec 0c             	sub    $0xc,%esp
80105e68:	68 80 49 11 80       	push   $0x80114980
80105e6d:	e8 3b 08 00 00       	call   801066ad <release>
80105e72:	83 c4 10             	add    $0x10,%esp
    return;
80105e75:	e9 f3 00 00 00       	jmp    80105f6d <display_zombie+0x13c>
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
80105e7a:	83 ec 0c             	sub    $0xc,%esp
80105e7d:	68 84 a2 10 80       	push   $0x8010a284
80105e82:	e8 3f a5 ff ff       	call   801003c6 <cprintf>
80105e87:	83 c4 10             	add    $0x10,%esp
  while (z) {
80105e8a:	e9 c3 00 00 00       	jmp    80105f52 <display_zombie+0x121>
    if (!z->next) {
80105e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e92:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105e98:	85 c0                	test   %eax,%eax
80105e9a:	75 56                	jne    80105ef2 <display_zombie+0xc1>
      cprintf("(%d", z->pid);
80105e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e9f:	8b 40 10             	mov    0x10(%eax),%eax
80105ea2:	83 ec 08             	sub    $0x8,%esp
80105ea5:	50                   	push   %eax
80105ea6:	68 a3 a2 10 80       	push   $0x8010a2a3
80105eab:	e8 16 a5 ff ff       	call   801003c6 <cprintf>
80105eb0:	83 c4 10             	add    $0x10,%esp
      if (z->parent)
80105eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb6:	8b 40 14             	mov    0x14(%eax),%eax
80105eb9:	85 c0                	test   %eax,%eax
80105ebb:	74 1c                	je     80105ed9 <display_zombie+0xa8>
        cprintf(", %d)\n", z->parent->pid);
80105ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec0:	8b 40 14             	mov    0x14(%eax),%eax
80105ec3:	8b 40 10             	mov    0x10(%eax),%eax
80105ec6:	83 ec 08             	sub    $0x8,%esp
80105ec9:	50                   	push   %eax
80105eca:	68 a7 a2 10 80       	push   $0x8010a2a7
80105ecf:	e8 f2 a4 ff ff       	call   801003c6 <cprintf>
80105ed4:	83 c4 10             	add    $0x10,%esp
80105ed7:	eb 6d                	jmp    80105f46 <display_zombie+0x115>
      else
        cprintf(", %d)\n", z->pid);
80105ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105edc:	8b 40 10             	mov    0x10(%eax),%eax
80105edf:	83 ec 08             	sub    $0x8,%esp
80105ee2:	50                   	push   %eax
80105ee3:	68 a7 a2 10 80       	push   $0x8010a2a7
80105ee8:	e8 d9 a4 ff ff       	call   801003c6 <cprintf>
80105eed:	83 c4 10             	add    $0x10,%esp
80105ef0:	eb 54                	jmp    80105f46 <display_zombie+0x115>
    }
    else {
      cprintf("(%d", z->pid);
80105ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef5:	8b 40 10             	mov    0x10(%eax),%eax
80105ef8:	83 ec 08             	sub    $0x8,%esp
80105efb:	50                   	push   %eax
80105efc:	68 a3 a2 10 80       	push   $0x8010a2a3
80105f01:	e8 c0 a4 ff ff       	call   801003c6 <cprintf>
80105f06:	83 c4 10             	add    $0x10,%esp
      if (z->parent)
80105f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f0c:	8b 40 14             	mov    0x14(%eax),%eax
80105f0f:	85 c0                	test   %eax,%eax
80105f11:	74 1c                	je     80105f2f <display_zombie+0xfe>
        cprintf(", %d) -> ", z->parent->pid);
80105f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f16:	8b 40 14             	mov    0x14(%eax),%eax
80105f19:	8b 40 10             	mov    0x10(%eax),%eax
80105f1c:	83 ec 08             	sub    $0x8,%esp
80105f1f:	50                   	push   %eax
80105f20:	68 ae a2 10 80       	push   $0x8010a2ae
80105f25:	e8 9c a4 ff ff       	call   801003c6 <cprintf>
80105f2a:	83 c4 10             	add    $0x10,%esp
80105f2d:	eb 17                	jmp    80105f46 <display_zombie+0x115>
      else
        cprintf(", %d) -> ", z->pid);
80105f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f32:	8b 40 10             	mov    0x10(%eax),%eax
80105f35:	83 ec 08             	sub    $0x8,%esp
80105f38:	50                   	push   %eax
80105f39:	68 ae a2 10 80       	push   $0x8010a2ae
80105f3e:	e8 83 a4 ff ff       	call   801003c6 <cprintf>
80105f43:	83 c4 10             	add    $0x10,%esp
    }
    z = z->next;
80105f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f49:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in zombie.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
  while (z) {
80105f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f56:	0f 85 33 ff ff ff    	jne    80105e8f <display_zombie+0x5e>
      else
        cprintf(", %d) -> ", z->pid);
    }
    z = z->next;
  }
  release(&ptable.lock);
80105f5c:	83 ec 0c             	sub    $0xc,%esp
80105f5f:	68 80 49 11 80       	push   $0x80114980
80105f64:	e8 44 07 00 00       	call   801066ad <release>
80105f69:	83 c4 10             	add    $0x10,%esp
  return;
80105f6c:	90                   	nop
}
80105f6d:	c9                   	leave  
80105f6e:	c3                   	ret    

80105f6f <assert_state>:

// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
80105f6f:	55                   	push   %ebp
80105f70:	89 e5                	mov    %esp,%ebp
80105f72:	83 ec 08             	sub    $0x8,%esp
  if (p->state == state)
80105f75:	8b 45 08             	mov    0x8(%ebp),%eax
80105f78:	8b 40 0c             	mov    0xc(%eax),%eax
80105f7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105f7e:	74 0d                	je     80105f8d <assert_state+0x1e>
    return;
  panic("ERROR: States do not match.");
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	68 b8 a2 10 80       	push   $0x8010a2b8
80105f88:	e8 d9 a5 ff ff       	call   80100566 <panic>
// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
  if (p->state == state)
    return;
80105f8d:	90                   	nop
  panic("ERROR: States do not match.");
}
80105f8e:	c9                   	leave  
80105f8f:	c3                   	ret    

80105f90 <remove_from_list>:

// Implementation of remove_from_list
static int
remove_from_list(struct proc** sList, struct proc* p)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 10             	sub    $0x10,%esp
  if (!p)
80105f96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105f9a:	75 0a                	jne    80105fa6 <remove_from_list+0x16>
    return -1;
80105f9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa1:	e9 94 00 00 00       	jmp    8010603a <remove_from_list+0xaa>
  if (!sList)
80105fa6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105faa:	75 0a                	jne    80105fb6 <remove_from_list+0x26>
    return -1;
80105fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb1:	e9 84 00 00 00       	jmp    8010603a <remove_from_list+0xaa>
  struct proc* curr = *sList;
80105fb6:	8b 45 08             	mov    0x8(%ebp),%eax
80105fb9:	8b 00                	mov    (%eax),%eax
80105fbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc* prev;
  if (p == curr) {
80105fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fc1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105fc4:	75 62                	jne    80106028 <remove_from_list+0x98>
    *sList = p->next;
80105fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fc9:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80105fd2:	89 10                	mov    %edx,(%eax)
    p->next = 0;
80105fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fd7:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80105fde:	00 00 00 
    return 1;
80105fe1:	b8 01 00 00 00       	mov    $0x1,%eax
80105fe6:	eb 52                	jmp    8010603a <remove_from_list+0xaa>
  }
  while (curr->next) {
    prev = curr;
80105fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105feb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    curr = curr->next;
80105fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ff1:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105ff7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (p == curr) {
80105ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ffd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80106000:	75 26                	jne    80106028 <remove_from_list+0x98>
      prev->next = p->next;
80106002:	8b 45 0c             	mov    0xc(%ebp),%eax
80106005:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010600b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010600e:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
      p->next = 0;
80106014:	8b 45 0c             	mov    0xc(%ebp),%eax
80106017:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
8010601e:	00 00 00 
      return 1;
80106021:	b8 01 00 00 00       	mov    $0x1,%eax
80106026:	eb 12                	jmp    8010603a <remove_from_list+0xaa>
  if (p == curr) {
    *sList = p->next;
    p->next = 0;
    return 1;
  }
  while (curr->next) {
80106028:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010602b:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106031:	85 c0                	test   %eax,%eax
80106033:	75 b3                	jne    80105fe8 <remove_from_list+0x58>
      prev->next = p->next;
      p->next = 0;
      return 1;
    }
  }
  return -1;
80106035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010603a:	c9                   	leave  
8010603b:	c3                   	ret    

8010603c <add_to_list>:

// Implementation of add_to_list
static int
add_to_list(struct proc** sList, enum procstate state, struct proc* p)
{
8010603c:	55                   	push   %ebp
8010603d:	89 e5                	mov    %esp,%ebp
8010603f:	83 ec 08             	sub    $0x8,%esp
  if (!p)
80106042:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106046:	75 07                	jne    8010604f <add_to_list+0x13>
    return -1;
80106048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604d:	eb 2c                	jmp    8010607b <add_to_list+0x3f>
  assert_state(p, state);
8010604f:	83 ec 08             	sub    $0x8,%esp
80106052:	ff 75 0c             	pushl  0xc(%ebp)
80106055:	ff 75 10             	pushl  0x10(%ebp)
80106058:	e8 12 ff ff ff       	call   80105f6f <assert_state>
8010605d:	83 c4 10             	add    $0x10,%esp
  p->next = *sList;
80106060:	8b 45 08             	mov    0x8(%ebp),%eax
80106063:	8b 10                	mov    (%eax),%edx
80106065:	8b 45 10             	mov    0x10(%ebp),%eax
80106068:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  *sList = p;
8010606e:	8b 45 08             	mov    0x8(%ebp),%eax
80106071:	8b 55 10             	mov    0x10(%ebp),%edx
80106074:	89 10                	mov    %edx,(%eax)
  return 0;
80106076:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010607b:	c9                   	leave  
8010607c:	c3                   	ret    

8010607d <add_to_ready>:

// Implementation of add_to_ready
static int
add_to_ready(struct proc* p, enum procstate state)
{
8010607d:	55                   	push   %ebp
8010607e:	89 e5                	mov    %esp,%ebp
80106080:	83 ec 18             	sub    $0x18,%esp
  if (!p)
80106083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106087:	75 0a                	jne    80106093 <add_to_ready+0x16>
    return -1;
80106089:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010608e:	e9 b9 00 00 00       	jmp    8010614c <add_to_ready+0xcf>
  assert_state(p, state);
80106093:	83 ec 08             	sub    $0x8,%esp
80106096:	ff 75 0c             	pushl  0xc(%ebp)
80106099:	ff 75 08             	pushl  0x8(%ebp)
8010609c:	e8 ce fe ff ff       	call   80105f6f <assert_state>
801060a1:	83 c4 10             	add    $0x10,%esp
  if (!ptable.pLists.ready[p->priority]) {
801060a4:	8b 45 08             	mov    0x8(%ebp),%eax
801060a7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060ad:	05 cc 09 00 00       	add    $0x9cc,%eax
801060b2:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
801060b9:	85 c0                	test   %eax,%eax
801060bb:	75 3e                	jne    801060fb <add_to_ready+0x7e>
    p->next = ptable.pLists.ready[p->priority];
801060bd:	8b 45 08             	mov    0x8(%ebp),%eax
801060c0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060c6:	05 cc 09 00 00       	add    $0x9cc,%eax
801060cb:	8b 14 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%edx
801060d2:	8b 45 08             	mov    0x8(%ebp),%eax
801060d5:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    ptable.pLists.ready[p->priority] = p;
801060db:	8b 45 08             	mov    0x8(%ebp),%eax
801060de:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060e4:	8d 90 cc 09 00 00    	lea    0x9cc(%eax),%edx
801060ea:	8b 45 08             	mov    0x8(%ebp),%eax
801060ed:	89 04 95 8c 49 11 80 	mov    %eax,-0x7feeb674(,%edx,4)
    return 1;
801060f4:	b8 01 00 00 00       	mov    $0x1,%eax
801060f9:	eb 51                	jmp    8010614c <add_to_ready+0xcf>
  }
  struct proc* t = ptable.pLists.ready[p->priority];
801060fb:	8b 45 08             	mov    0x8(%ebp),%eax
801060fe:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106104:	05 cc 09 00 00       	add    $0x9cc,%eax
80106109:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80106110:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (t->next)
80106113:	eb 0c                	jmp    80106121 <add_to_ready+0xa4>
    t = t->next;
80106115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106118:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010611e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p->next = ptable.pLists.ready[p->priority];
    ptable.pLists.ready[p->priority] = p;
    return 1;
  }
  struct proc* t = ptable.pLists.ready[p->priority];
  while (t->next)
80106121:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106124:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010612a:	85 c0                	test   %eax,%eax
8010612c:	75 e7                	jne    80106115 <add_to_ready+0x98>
    t = t->next;
  t->next = p;
8010612e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106131:	8b 55 08             	mov    0x8(%ebp),%edx
80106134:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  p->next = 0;
8010613a:	8b 45 08             	mov    0x8(%ebp),%eax
8010613d:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80106144:	00 00 00 
  return 0;
80106147:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010614c:	c9                   	leave  
8010614d:	c3                   	ret    

8010614e <exit_helper>:

// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
8010614e:	55                   	push   %ebp
8010614f:	89 e5                	mov    %esp,%ebp
80106151:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = *sList;
80106154:	8b 45 08             	mov    0x8(%ebp),%eax
80106157:	8b 00                	mov    (%eax),%eax
80106159:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
8010615c:	eb 28                	jmp    80106186 <exit_helper+0x38>
    if (p->parent == proc)
8010615e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106161:	8b 50 14             	mov    0x14(%eax),%edx
80106164:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010616a:	39 c2                	cmp    %eax,%edx
8010616c:	75 0c                	jne    8010617a <exit_helper+0x2c>
      p->parent = initproc;
8010616e:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80106174:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106177:	89 50 14             	mov    %edx,0x14(%eax)
    p = p->next;
8010617a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010617d:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106183:	89 45 fc             	mov    %eax,-0x4(%ebp)
// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
  struct proc* p = *sList;
  while (p) {
80106186:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010618a:	75 d2                	jne    8010615e <exit_helper+0x10>
    if (p->parent == proc)
      p->parent = initproc;
    p = p->next;
  }
}
8010618c:	90                   	nop
8010618d:	c9                   	leave  
8010618e:	c3                   	ret    

8010618f <wait_helper>:

// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
8010618f:	55                   	push   %ebp
80106190:	89 e5                	mov    %esp,%ebp
80106192:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = *sList;
80106195:	8b 45 08             	mov    0x8(%ebp),%eax
80106198:	8b 00                	mov    (%eax),%eax
8010619a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
8010619d:	eb 25                	jmp    801061c4 <wait_helper+0x35>
    if (p->parent == proc)
8010619f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061a2:	8b 50 14             	mov    0x14(%eax),%edx
801061a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061ab:	39 c2                	cmp    %eax,%edx
801061ad:	75 09                	jne    801061b8 <wait_helper+0x29>
      *hk = 1;
801061af:	8b 45 0c             	mov    0xc(%ebp),%eax
801061b2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    p = p->next;
801061b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061bb:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801061c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
  struct proc* p = *sList;
  while (p) {
801061c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801061c8:	75 d5                	jne    8010619f <wait_helper+0x10>
    if (p->parent == proc)
      *hk = 1;
    p = p->next;
  }
}
801061ca:	90                   	nop
801061cb:	c9                   	leave  
801061cc:	c3                   	ret    

801061cd <set_priority>:

#ifdef CS333_P3P4
// Implementation of helper for set priority system call
int
set_priority(int pid, int priority)
{
801061cd:	55                   	push   %ebp
801061ce:	89 e5                	mov    %esp,%ebp
801061d0:	83 ec 18             	sub    $0x18,%esp
  if (pid < 0)
801061d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801061d7:	79 0a                	jns    801061e3 <set_priority+0x16>
    return -1;
801061d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061de:	e9 fd 00 00 00       	jmp    801062e0 <set_priority+0x113>
  if (priority < 0 || priority > MAX)
801061e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801061e7:	78 06                	js     801061ef <set_priority+0x22>
801061e9:	83 7d 0c 05          	cmpl   $0x5,0xc(%ebp)
801061ed:	7e 0a                	jle    801061f9 <set_priority+0x2c>
    return -2;
801061ef:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801061f4:	e9 e7 00 00 00       	jmp    801062e0 <set_priority+0x113>

  int hold = holding(&ptable.lock);
801061f9:	83 ec 0c             	sub    $0xc,%esp
801061fc:	68 80 49 11 80       	push   $0x80114980
80106201:	e8 73 05 00 00       	call   80106779 <holding>
80106206:	83 c4 10             	add    $0x10,%esp
80106209:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!hold) acquire(&ptable.lock);
8010620c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106210:	75 10                	jne    80106222 <set_priority+0x55>
80106212:	83 ec 0c             	sub    $0xc,%esp
80106215:	68 80 49 11 80       	push   $0x80114980
8010621a:	e8 27 04 00 00       	call   80106646 <acquire>
8010621f:	83 c4 10             	add    $0x10,%esp
  if (search_and_set(&ptable.pLists.running, pid, priority) == 0) {
80106222:	83 ec 04             	sub    $0x4,%esp
80106225:	ff 75 0c             	pushl  0xc(%ebp)
80106228:	ff 75 08             	pushl  0x8(%ebp)
8010622b:	68 d4 70 11 80       	push   $0x801170d4
80106230:	e8 ad 00 00 00       	call   801062e2 <search_and_set>
80106235:	83 c4 10             	add    $0x10,%esp
80106238:	85 c0                	test   %eax,%eax
8010623a:	75 20                	jne    8010625c <set_priority+0x8f>
    if (!hold) release(&ptable.lock);
8010623c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106240:	75 10                	jne    80106252 <set_priority+0x85>
80106242:	83 ec 0c             	sub    $0xc,%esp
80106245:	68 80 49 11 80       	push   $0x80114980
8010624a:	e8 5e 04 00 00       	call   801066ad <release>
8010624f:	83 c4 10             	add    $0x10,%esp
    return 0;
80106252:	b8 00 00 00 00       	mov    $0x0,%eax
80106257:	e9 84 00 00 00       	jmp    801062e0 <set_priority+0x113>
  }
  if (search_and_set(&ptable.pLists.sleep, pid, priority) == 0) {
8010625c:	83 ec 04             	sub    $0x4,%esp
8010625f:	ff 75 0c             	pushl  0xc(%ebp)
80106262:	ff 75 08             	pushl  0x8(%ebp)
80106265:	68 d8 70 11 80       	push   $0x801170d8
8010626a:	e8 73 00 00 00       	call   801062e2 <search_and_set>
8010626f:	83 c4 10             	add    $0x10,%esp
80106272:	85 c0                	test   %eax,%eax
80106274:	75 1d                	jne    80106293 <set_priority+0xc6>
    if (!hold) release(&ptable.lock);
80106276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010627a:	75 10                	jne    8010628c <set_priority+0xbf>
8010627c:	83 ec 0c             	sub    $0xc,%esp
8010627f:	68 80 49 11 80       	push   $0x80114980
80106284:	e8 24 04 00 00       	call   801066ad <release>
80106289:	83 c4 10             	add    $0x10,%esp
    return 0;
8010628c:	b8 00 00 00 00       	mov    $0x0,%eax
80106291:	eb 4d                	jmp    801062e0 <set_priority+0x113>
  }
  if (search_and_set_ready(pid, priority) == 0) {
80106293:	83 ec 08             	sub    $0x8,%esp
80106296:	ff 75 0c             	pushl  0xc(%ebp)
80106299:	ff 75 08             	pushl  0x8(%ebp)
8010629c:	e8 ae 00 00 00       	call   8010634f <search_and_set_ready>
801062a1:	83 c4 10             	add    $0x10,%esp
801062a4:	85 c0                	test   %eax,%eax
801062a6:	75 1d                	jne    801062c5 <set_priority+0xf8>
    if (!hold) release(&ptable.lock);
801062a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062ac:	75 10                	jne    801062be <set_priority+0xf1>
801062ae:	83 ec 0c             	sub    $0xc,%esp
801062b1:	68 80 49 11 80       	push   $0x80114980
801062b6:	e8 f2 03 00 00       	call   801066ad <release>
801062bb:	83 c4 10             	add    $0x10,%esp
    return 0;
801062be:	b8 00 00 00 00       	mov    $0x0,%eax
801062c3:	eb 1b                	jmp    801062e0 <set_priority+0x113>
  }
  if (!hold) release(&ptable.lock);
801062c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062c9:	75 10                	jne    801062db <set_priority+0x10e>
801062cb:	83 ec 0c             	sub    $0xc,%esp
801062ce:	68 80 49 11 80       	push   $0x80114980
801062d3:	e8 d5 03 00 00       	call   801066ad <release>
801062d8:	83 c4 10             	add    $0x10,%esp
  return -1; // Failed to find process with PID matching arg pid
801062db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062e0:	c9                   	leave  
801062e1:	c3                   	ret    

801062e2 <search_and_set>:
// Searches a list for a proc with PID pid and sets its priority
// to the value passed in via prio argument
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int 
search_and_set(struct proc** sList, int pid, int prio)
{
801062e2:	55                   	push   %ebp
801062e3:	89 e5                	mov    %esp,%ebp
801062e5:	83 ec 10             	sub    $0x10,%esp
  if (!sList)
801062e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801062ec:	75 07                	jne    801062f5 <search_and_set+0x13>
    return -1; // Null list
801062ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f3:	eb 58                	jmp    8010634d <search_and_set+0x6b>
  struct proc* p = *sList;
801062f5:	8b 45 08             	mov    0x8(%ebp),%eax
801062f8:	8b 00                	mov    (%eax),%eax
801062fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
801062fd:	eb 43                	jmp    80106342 <search_and_set+0x60>
    if (p->pid == pid) {
801062ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106302:	8b 50 10             	mov    0x10(%eax),%edx
80106305:	8b 45 0c             	mov    0xc(%ebp),%eax
80106308:	39 c2                	cmp    %eax,%edx
8010630a:	75 2a                	jne    80106336 <search_and_set+0x54>
      if (p->priority == prio)
8010630c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010630f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80106315:	8b 45 10             	mov    0x10(%ebp),%eax
80106318:	39 c2                	cmp    %eax,%edx
8010631a:	75 07                	jne    80106323 <search_and_set+0x41>
        return 1; // No change necessary 
8010631c:	b8 01 00 00 00       	mov    $0x1,%eax
80106321:	eb 2a                	jmp    8010634d <search_and_set+0x6b>
      else {
        p->priority = prio;
80106323:	8b 55 10             	mov    0x10(%ebp),%edx
80106326:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106329:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        return 0; // Success!
8010632f:	b8 00 00 00 00       	mov    $0x0,%eax
80106334:	eb 17                	jmp    8010634d <search_and_set+0x6b>
      }
    }
    p = p->next;
80106336:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106339:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010633f:	89 45 fc             	mov    %eax,-0x4(%ebp)
search_and_set(struct proc** sList, int pid, int prio)
{
  if (!sList)
    return -1; // Null list
  struct proc* p = *sList;
  while (p) {
80106342:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106346:	75 b7                	jne    801062ff <search_and_set+0x1d>
        return 0; // Success!
      }
    }
    p = p->next;
  }
  return -2; // Not found
80106348:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
8010634d:	c9                   	leave  
8010634e:	c3                   	ret    

8010634f <search_and_set_ready>:
// Specifically handles the ready list since the process also needs
// to be moved to a different ready queue.
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int
search_and_set_ready(int pid, int prio)
{
8010634f:	55                   	push   %ebp
80106350:	89 e5                	mov    %esp,%ebp
80106352:	83 ec 18             	sub    $0x18,%esp
  for (int i = 0; i < MAX+1; i++) {
80106355:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010635c:	e9 c1 00 00 00       	jmp    80106422 <search_and_set_ready+0xd3>
    if (!ptable.pLists.ready[i])
80106361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106364:	05 cc 09 00 00       	add    $0x9cc,%eax
80106369:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80106370:	85 c0                	test   %eax,%eax
80106372:	0f 84 a5 00 00 00    	je     8010641d <search_and_set_ready+0xce>
      continue;
    struct proc* p = ptable.pLists.ready[i];
80106378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010637b:	05 cc 09 00 00       	add    $0x9cc,%eax
80106380:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80106387:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (p) {
8010638a:	e9 82 00 00 00       	jmp    80106411 <search_and_set_ready+0xc2>
      if (p->pid == pid) {
8010638f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106392:	8b 50 10             	mov    0x10(%eax),%edx
80106395:	8b 45 08             	mov    0x8(%ebp),%eax
80106398:	39 c2                	cmp    %eax,%edx
8010639a:	75 69                	jne    80106405 <search_and_set_ready+0xb6>
        if (p->priority == prio)
8010639c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010639f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801063a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801063a8:	39 c2                	cmp    %eax,%edx
801063aa:	75 07                	jne    801063b3 <search_and_set_ready+0x64>
          return 1; // No changes need to be made since prio already matches
801063ac:	b8 01 00 00 00       	mov    $0x1,%eax
801063b1:	eb 7e                	jmp    80106431 <search_and_set_ready+0xe2>
        else {
          p->priority = prio;
801063b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801063b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b9:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
          remove_from_list(&ptable.pLists.ready[i], p);
801063bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c2:	05 cc 09 00 00       	add    $0x9cc,%eax
801063c7:	c1 e0 02             	shl    $0x2,%eax
801063ca:	05 80 49 11 80       	add    $0x80114980,%eax
801063cf:	83 c0 0c             	add    $0xc,%eax
801063d2:	ff 75 f0             	pushl  -0x10(%ebp)
801063d5:	50                   	push   %eax
801063d6:	e8 b5 fb ff ff       	call   80105f90 <remove_from_list>
801063db:	83 c4 08             	add    $0x8,%esp
          assert_state(p, RUNNABLE);
801063de:	83 ec 08             	sub    $0x8,%esp
801063e1:	6a 03                	push   $0x3
801063e3:	ff 75 f0             	pushl  -0x10(%ebp)
801063e6:	e8 84 fb ff ff       	call   80105f6f <assert_state>
801063eb:	83 c4 10             	add    $0x10,%esp
          add_to_ready(p, RUNNABLE);
801063ee:	83 ec 08             	sub    $0x8,%esp
801063f1:	6a 03                	push   $0x3
801063f3:	ff 75 f0             	pushl  -0x10(%ebp)
801063f6:	e8 82 fc ff ff       	call   8010607d <add_to_ready>
801063fb:	83 c4 10             	add    $0x10,%esp
          return 0;
801063fe:	b8 00 00 00 00       	mov    $0x0,%eax
80106403:	eb 2c                	jmp    80106431 <search_and_set_ready+0xe2>
        }
      }
      p = p->next;  
80106405:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106408:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010640e:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
  for (int i = 0; i < MAX+1; i++) {
    if (!ptable.pLists.ready[i])
      continue;
    struct proc* p = ptable.pLists.ready[i];
    while (p) {
80106411:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106415:	0f 85 74 ff ff ff    	jne    8010638f <search_and_set_ready+0x40>
8010641b:	eb 01                	jmp    8010641e <search_and_set_ready+0xcf>
static int
search_and_set_ready(int pid, int prio)
{
  for (int i = 0; i < MAX+1; i++) {
    if (!ptable.pLists.ready[i])
      continue;
8010641d:	90                   	nop
// to be moved to a different ready queue.
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int
search_and_set_ready(int pid, int prio)
{
  for (int i = 0; i < MAX+1; i++) {
8010641e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106422:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
80106426:	0f 8e 35 ff ff ff    	jle    80106361 <search_and_set_ready+0x12>
        }
      }
      p = p->next;  
    }
  }
  return -2;
8010642c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
80106431:	c9                   	leave  
80106432:	c3                   	ret    

80106433 <priority_promotion>:
#endif

#ifdef CS333_P3P4
static int 
priority_promotion()
{
80106433:	55                   	push   %ebp
80106434:	89 e5                	mov    %esp,%ebp
80106436:	83 ec 18             	sub    $0x18,%esp
  int hold = holding(&ptable.lock);
80106439:	83 ec 0c             	sub    $0xc,%esp
8010643c:	68 80 49 11 80       	push   $0x80114980
80106441:	e8 33 03 00 00       	call   80106779 <holding>
80106446:	83 c4 10             	add    $0x10,%esp
80106449:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (!hold) acquire(&ptable.lock);
8010644c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106450:	75 10                	jne    80106462 <priority_promotion+0x2f>
80106452:	83 ec 0c             	sub    $0xc,%esp
80106455:	68 80 49 11 80       	push   $0x80114980
8010645a:	e8 e7 01 00 00       	call   80106646 <acquire>
8010645f:	83 c4 10             	add    $0x10,%esp
  if (MAX == 0)     // Only one list so simple round robin scheduler
    return -1;
  promote_list(&ptable.pLists.running);
80106462:	83 ec 0c             	sub    $0xc,%esp
80106465:	68 d4 70 11 80       	push   $0x801170d4
8010646a:	e8 25 01 00 00       	call   80106594 <promote_list>
8010646f:	83 c4 10             	add    $0x10,%esp
  promote_list(&ptable.pLists.sleep);
80106472:	83 ec 0c             	sub    $0xc,%esp
80106475:	68 d8 70 11 80       	push   $0x801170d8
8010647a:	e8 15 01 00 00       	call   80106594 <promote_list>
8010647f:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX; i++) {
80106482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106489:	e9 df 00 00 00       	jmp    8010656d <priority_promotion+0x13a>
    if (!ptable.pLists.ready[i+1])
8010648e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106491:	83 c0 01             	add    $0x1,%eax
80106494:	05 cc 09 00 00       	add    $0x9cc,%eax
80106499:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
801064a0:	85 c0                	test   %eax,%eax
801064a2:	0f 84 c0 00 00 00    	je     80106568 <priority_promotion+0x135>
      continue;
    promote_list(&ptable.pLists.ready[i+1]);
801064a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ab:	83 c0 01             	add    $0x1,%eax
801064ae:	05 cc 09 00 00       	add    $0x9cc,%eax
801064b3:	c1 e0 02             	shl    $0x2,%eax
801064b6:	05 80 49 11 80       	add    $0x80114980,%eax
801064bb:	83 c0 0c             	add    $0xc,%eax
801064be:	83 ec 0c             	sub    $0xc,%esp
801064c1:	50                   	push   %eax
801064c2:	e8 cd 00 00 00       	call   80106594 <promote_list>
801064c7:	83 c4 10             	add    $0x10,%esp
    struct proc* p = ptable.pLists.ready[i];
801064ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064cd:	05 cc 09 00 00       	add    $0x9cc,%eax
801064d2:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
801064d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!p) {
801064dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064e0:	75 46                	jne    80106528 <priority_promotion+0xf5>
      ptable.pLists.ready[i] = ptable.pLists.ready[i+1];
801064e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e5:	83 c0 01             	add    $0x1,%eax
801064e8:	05 cc 09 00 00       	add    $0x9cc,%eax
801064ed:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
801064f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064f7:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
801064fd:	89 04 95 8c 49 11 80 	mov    %eax,-0x7feeb674(,%edx,4)
      ptable.pLists.ready[i+1] = 0;
80106504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106507:	83 c0 01             	add    $0x1,%eax
8010650a:	05 cc 09 00 00       	add    $0x9cc,%eax
8010650f:	c7 04 85 8c 49 11 80 	movl   $0x0,-0x7feeb674(,%eax,4)
80106516:	00 00 00 00 
8010651a:	eb 4d                	jmp    80106569 <priority_promotion+0x136>
    } else {
      while (p->next)
        p = p->next;
8010651c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010651f:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106525:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct proc* p = ptable.pLists.ready[i];
    if (!p) {
      ptable.pLists.ready[i] = ptable.pLists.ready[i+1];
      ptable.pLists.ready[i+1] = 0;
    } else {
      while (p->next)
80106528:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010652b:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106531:	85 c0                	test   %eax,%eax
80106533:	75 e7                	jne    8010651c <priority_promotion+0xe9>
        p = p->next;
      p->next = ptable.pLists.ready[i+1];
80106535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106538:	83 c0 01             	add    $0x1,%eax
8010653b:	05 cc 09 00 00       	add    $0x9cc,%eax
80106540:	8b 14 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%edx
80106547:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010654a:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
      ptable.pLists.ready[i+1] = 0;
80106550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106553:	83 c0 01             	add    $0x1,%eax
80106556:	05 cc 09 00 00       	add    $0x9cc,%eax
8010655b:	c7 04 85 8c 49 11 80 	movl   $0x0,-0x7feeb674(,%eax,4)
80106562:	00 00 00 00 
80106566:	eb 01                	jmp    80106569 <priority_promotion+0x136>
    return -1;
  promote_list(&ptable.pLists.running);
  promote_list(&ptable.pLists.sleep);
  for (int i = 0; i < MAX; i++) {
    if (!ptable.pLists.ready[i+1])
      continue;
80106568:	90                   	nop
  if (!hold) acquire(&ptable.lock);
  if (MAX == 0)     // Only one list so simple round robin scheduler
    return -1;
  promote_list(&ptable.pLists.running);
  promote_list(&ptable.pLists.sleep);
  for (int i = 0; i < MAX; i++) {
80106569:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010656d:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80106571:	0f 8e 17 ff ff ff    	jle    8010648e <priority_promotion+0x5b>
        p = p->next;
      p->next = ptable.pLists.ready[i+1];
      ptable.pLists.ready[i+1] = 0;
    }
  }
  if (!hold) release(&ptable.lock);
80106577:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010657b:	75 10                	jne    8010658d <priority_promotion+0x15a>
8010657d:	83 ec 0c             	sub    $0xc,%esp
80106580:	68 80 49 11 80       	push   $0x80114980
80106585:	e8 23 01 00 00       	call   801066ad <release>
8010658a:	83 c4 10             	add    $0x10,%esp
  return 1; 
8010658d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106592:	c9                   	leave  
80106593:	c3                   	ret    

80106594 <promote_list>:
#endif

#ifdef CS333_P3P4
static int 
promote_list(struct proc** list)
{
80106594:	55                   	push   %ebp
80106595:	89 e5                	mov    %esp,%ebp
80106597:	83 ec 10             	sub    $0x10,%esp
  if (!list)
8010659a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010659e:	75 07                	jne    801065a7 <promote_list+0x13>
    return -1;
801065a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a5:	eb 43                	jmp    801065ea <promote_list+0x56>

  struct proc* p = *list;
801065a7:	8b 45 08             	mov    0x8(%ebp),%eax
801065aa:	8b 00                	mov    (%eax),%eax
801065ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
801065af:	eb 2e                	jmp    801065df <promote_list+0x4b>
    if (p->priority > 0)
801065b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065b4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801065ba:	85 c0                	test   %eax,%eax
801065bc:	74 15                	je     801065d3 <promote_list+0x3f>
      p->priority = p->priority-1;
801065be:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065c1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801065c7:	8d 50 ff             	lea    -0x1(%eax),%edx
801065ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065cd:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    p = p->next;
801065d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065d6:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801065dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  if (!list)
    return -1;

  struct proc* p = *list;
  while (p) {
801065df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801065e3:	75 cc                	jne    801065b1 <promote_list+0x1d>
    if (p->priority > 0)
      p->priority = p->priority-1;
    p = p->next;
  }
  return 0;
801065e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065ea:	c9                   	leave  
801065eb:	c3                   	ret    

801065ec <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801065ec:	55                   	push   %ebp
801065ed:	89 e5                	mov    %esp,%ebp
801065ef:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801065f2:	9c                   	pushf  
801065f3:	58                   	pop    %eax
801065f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801065f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801065fa:	c9                   	leave  
801065fb:	c3                   	ret    

801065fc <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801065fc:	55                   	push   %ebp
801065fd:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801065ff:	fa                   	cli    
}
80106600:	90                   	nop
80106601:	5d                   	pop    %ebp
80106602:	c3                   	ret    

80106603 <sti>:

static inline void
sti(void)
{
80106603:	55                   	push   %ebp
80106604:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80106606:	fb                   	sti    
}
80106607:	90                   	nop
80106608:	5d                   	pop    %ebp
80106609:	c3                   	ret    

8010660a <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010660a:	55                   	push   %ebp
8010660b:	89 e5                	mov    %esp,%ebp
8010660d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80106610:	8b 55 08             	mov    0x8(%ebp),%edx
80106613:	8b 45 0c             	mov    0xc(%ebp),%eax
80106616:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106619:	f0 87 02             	lock xchg %eax,(%edx)
8010661c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010661f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106622:	c9                   	leave  
80106623:	c3                   	ret    

80106624 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106624:	55                   	push   %ebp
80106625:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80106627:	8b 45 08             	mov    0x8(%ebp),%eax
8010662a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010662d:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80106630:	8b 45 08             	mov    0x8(%ebp),%eax
80106633:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106639:	8b 45 08             	mov    0x8(%ebp),%eax
8010663c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106643:	90                   	nop
80106644:	5d                   	pop    %ebp
80106645:	c3                   	ret    

80106646 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80106646:	55                   	push   %ebp
80106647:	89 e5                	mov    %esp,%ebp
80106649:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010664c:	e8 52 01 00 00       	call   801067a3 <pushcli>
  if(holding(lk))
80106651:	8b 45 08             	mov    0x8(%ebp),%eax
80106654:	83 ec 0c             	sub    $0xc,%esp
80106657:	50                   	push   %eax
80106658:	e8 1c 01 00 00       	call   80106779 <holding>
8010665d:	83 c4 10             	add    $0x10,%esp
80106660:	85 c0                	test   %eax,%eax
80106662:	74 0d                	je     80106671 <acquire+0x2b>
    panic("acquire");
80106664:	83 ec 0c             	sub    $0xc,%esp
80106667:	68 d4 a2 10 80       	push   $0x8010a2d4
8010666c:	e8 f5 9e ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80106671:	90                   	nop
80106672:	8b 45 08             	mov    0x8(%ebp),%eax
80106675:	83 ec 08             	sub    $0x8,%esp
80106678:	6a 01                	push   $0x1
8010667a:	50                   	push   %eax
8010667b:	e8 8a ff ff ff       	call   8010660a <xchg>
80106680:	83 c4 10             	add    $0x10,%esp
80106683:	85 c0                	test   %eax,%eax
80106685:	75 eb                	jne    80106672 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80106687:	8b 45 08             	mov    0x8(%ebp),%eax
8010668a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106691:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80106694:	8b 45 08             	mov    0x8(%ebp),%eax
80106697:	83 c0 0c             	add    $0xc,%eax
8010669a:	83 ec 08             	sub    $0x8,%esp
8010669d:	50                   	push   %eax
8010669e:	8d 45 08             	lea    0x8(%ebp),%eax
801066a1:	50                   	push   %eax
801066a2:	e8 58 00 00 00       	call   801066ff <getcallerpcs>
801066a7:	83 c4 10             	add    $0x10,%esp
}
801066aa:	90                   	nop
801066ab:	c9                   	leave  
801066ac:	c3                   	ret    

801066ad <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801066ad:	55                   	push   %ebp
801066ae:	89 e5                	mov    %esp,%ebp
801066b0:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801066b3:	83 ec 0c             	sub    $0xc,%esp
801066b6:	ff 75 08             	pushl  0x8(%ebp)
801066b9:	e8 bb 00 00 00       	call   80106779 <holding>
801066be:	83 c4 10             	add    $0x10,%esp
801066c1:	85 c0                	test   %eax,%eax
801066c3:	75 0d                	jne    801066d2 <release+0x25>
    panic("release");
801066c5:	83 ec 0c             	sub    $0xc,%esp
801066c8:	68 dc a2 10 80       	push   $0x8010a2dc
801066cd:	e8 94 9e ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801066d2:	8b 45 08             	mov    0x8(%ebp),%eax
801066d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801066dc:	8b 45 08             	mov    0x8(%ebp),%eax
801066df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801066e6:	8b 45 08             	mov    0x8(%ebp),%eax
801066e9:	83 ec 08             	sub    $0x8,%esp
801066ec:	6a 00                	push   $0x0
801066ee:	50                   	push   %eax
801066ef:	e8 16 ff ff ff       	call   8010660a <xchg>
801066f4:	83 c4 10             	add    $0x10,%esp

  popcli();
801066f7:	e8 ec 00 00 00       	call   801067e8 <popcli>
}
801066fc:	90                   	nop
801066fd:	c9                   	leave  
801066fe:	c3                   	ret    

801066ff <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801066ff:	55                   	push   %ebp
80106700:	89 e5                	mov    %esp,%ebp
80106702:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80106705:	8b 45 08             	mov    0x8(%ebp),%eax
80106708:	83 e8 08             	sub    $0x8,%eax
8010670b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010670e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80106715:	eb 38                	jmp    8010674f <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106717:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010671b:	74 53                	je     80106770 <getcallerpcs+0x71>
8010671d:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80106724:	76 4a                	jbe    80106770 <getcallerpcs+0x71>
80106726:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010672a:	74 44                	je     80106770 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010672c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010672f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106736:	8b 45 0c             	mov    0xc(%ebp),%eax
80106739:	01 c2                	add    %eax,%edx
8010673b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010673e:	8b 40 04             	mov    0x4(%eax),%eax
80106741:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80106743:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106746:	8b 00                	mov    (%eax),%eax
80106748:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010674b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010674f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106753:	7e c2                	jle    80106717 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106755:	eb 19                	jmp    80106770 <getcallerpcs+0x71>
    pcs[i] = 0;
80106757:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010675a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106761:	8b 45 0c             	mov    0xc(%ebp),%eax
80106764:	01 d0                	add    %edx,%eax
80106766:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010676c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106770:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106774:	7e e1                	jle    80106757 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80106776:	90                   	nop
80106777:	c9                   	leave  
80106778:	c3                   	ret    

80106779 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106779:	55                   	push   %ebp
8010677a:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010677c:	8b 45 08             	mov    0x8(%ebp),%eax
8010677f:	8b 00                	mov    (%eax),%eax
80106781:	85 c0                	test   %eax,%eax
80106783:	74 17                	je     8010679c <holding+0x23>
80106785:	8b 45 08             	mov    0x8(%ebp),%eax
80106788:	8b 50 08             	mov    0x8(%eax),%edx
8010678b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106791:	39 c2                	cmp    %eax,%edx
80106793:	75 07                	jne    8010679c <holding+0x23>
80106795:	b8 01 00 00 00       	mov    $0x1,%eax
8010679a:	eb 05                	jmp    801067a1 <holding+0x28>
8010679c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067a1:	5d                   	pop    %ebp
801067a2:	c3                   	ret    

801067a3 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801067a3:	55                   	push   %ebp
801067a4:	89 e5                	mov    %esp,%ebp
801067a6:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801067a9:	e8 3e fe ff ff       	call   801065ec <readeflags>
801067ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801067b1:	e8 46 fe ff ff       	call   801065fc <cli>
  if(cpu->ncli++ == 0)
801067b6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801067bd:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801067c3:	8d 48 01             	lea    0x1(%eax),%ecx
801067c6:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801067cc:	85 c0                	test   %eax,%eax
801067ce:	75 15                	jne    801067e5 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801067d0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801067d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801067d9:	81 e2 00 02 00 00    	and    $0x200,%edx
801067df:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801067e5:	90                   	nop
801067e6:	c9                   	leave  
801067e7:	c3                   	ret    

801067e8 <popcli>:

void
popcli(void)
{
801067e8:	55                   	push   %ebp
801067e9:	89 e5                	mov    %esp,%ebp
801067eb:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801067ee:	e8 f9 fd ff ff       	call   801065ec <readeflags>
801067f3:	25 00 02 00 00       	and    $0x200,%eax
801067f8:	85 c0                	test   %eax,%eax
801067fa:	74 0d                	je     80106809 <popcli+0x21>
    panic("popcli - interruptible");
801067fc:	83 ec 0c             	sub    $0xc,%esp
801067ff:	68 e4 a2 10 80       	push   $0x8010a2e4
80106804:	e8 5d 9d ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106809:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010680f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106815:	83 ea 01             	sub    $0x1,%edx
80106818:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010681e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106824:	85 c0                	test   %eax,%eax
80106826:	79 0d                	jns    80106835 <popcli+0x4d>
    panic("popcli");
80106828:	83 ec 0c             	sub    $0xc,%esp
8010682b:	68 fb a2 10 80       	push   $0x8010a2fb
80106830:	e8 31 9d ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106835:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010683b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106841:	85 c0                	test   %eax,%eax
80106843:	75 15                	jne    8010685a <popcli+0x72>
80106845:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010684b:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106851:	85 c0                	test   %eax,%eax
80106853:	74 05                	je     8010685a <popcli+0x72>
    sti();
80106855:	e8 a9 fd ff ff       	call   80106603 <sti>
}
8010685a:	90                   	nop
8010685b:	c9                   	leave  
8010685c:	c3                   	ret    

8010685d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010685d:	55                   	push   %ebp
8010685e:	89 e5                	mov    %esp,%ebp
80106860:	57                   	push   %edi
80106861:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106862:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106865:	8b 55 10             	mov    0x10(%ebp),%edx
80106868:	8b 45 0c             	mov    0xc(%ebp),%eax
8010686b:	89 cb                	mov    %ecx,%ebx
8010686d:	89 df                	mov    %ebx,%edi
8010686f:	89 d1                	mov    %edx,%ecx
80106871:	fc                   	cld    
80106872:	f3 aa                	rep stos %al,%es:(%edi)
80106874:	89 ca                	mov    %ecx,%edx
80106876:	89 fb                	mov    %edi,%ebx
80106878:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010687b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010687e:	90                   	nop
8010687f:	5b                   	pop    %ebx
80106880:	5f                   	pop    %edi
80106881:	5d                   	pop    %ebp
80106882:	c3                   	ret    

80106883 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106883:	55                   	push   %ebp
80106884:	89 e5                	mov    %esp,%ebp
80106886:	57                   	push   %edi
80106887:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106888:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010688b:	8b 55 10             	mov    0x10(%ebp),%edx
8010688e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106891:	89 cb                	mov    %ecx,%ebx
80106893:	89 df                	mov    %ebx,%edi
80106895:	89 d1                	mov    %edx,%ecx
80106897:	fc                   	cld    
80106898:	f3 ab                	rep stos %eax,%es:(%edi)
8010689a:	89 ca                	mov    %ecx,%edx
8010689c:	89 fb                	mov    %edi,%ebx
8010689e:	89 5d 08             	mov    %ebx,0x8(%ebp)
801068a1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801068a4:	90                   	nop
801068a5:	5b                   	pop    %ebx
801068a6:	5f                   	pop    %edi
801068a7:	5d                   	pop    %ebp
801068a8:	c3                   	ret    

801068a9 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801068a9:	55                   	push   %ebp
801068aa:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801068ac:	8b 45 08             	mov    0x8(%ebp),%eax
801068af:	83 e0 03             	and    $0x3,%eax
801068b2:	85 c0                	test   %eax,%eax
801068b4:	75 43                	jne    801068f9 <memset+0x50>
801068b6:	8b 45 10             	mov    0x10(%ebp),%eax
801068b9:	83 e0 03             	and    $0x3,%eax
801068bc:	85 c0                	test   %eax,%eax
801068be:	75 39                	jne    801068f9 <memset+0x50>
    c &= 0xFF;
801068c0:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801068c7:	8b 45 10             	mov    0x10(%ebp),%eax
801068ca:	c1 e8 02             	shr    $0x2,%eax
801068cd:	89 c1                	mov    %eax,%ecx
801068cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801068d2:	c1 e0 18             	shl    $0x18,%eax
801068d5:	89 c2                	mov    %eax,%edx
801068d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801068da:	c1 e0 10             	shl    $0x10,%eax
801068dd:	09 c2                	or     %eax,%edx
801068df:	8b 45 0c             	mov    0xc(%ebp),%eax
801068e2:	c1 e0 08             	shl    $0x8,%eax
801068e5:	09 d0                	or     %edx,%eax
801068e7:	0b 45 0c             	or     0xc(%ebp),%eax
801068ea:	51                   	push   %ecx
801068eb:	50                   	push   %eax
801068ec:	ff 75 08             	pushl  0x8(%ebp)
801068ef:	e8 8f ff ff ff       	call   80106883 <stosl>
801068f4:	83 c4 0c             	add    $0xc,%esp
801068f7:	eb 12                	jmp    8010690b <memset+0x62>
  } else
    stosb(dst, c, n);
801068f9:	8b 45 10             	mov    0x10(%ebp),%eax
801068fc:	50                   	push   %eax
801068fd:	ff 75 0c             	pushl  0xc(%ebp)
80106900:	ff 75 08             	pushl  0x8(%ebp)
80106903:	e8 55 ff ff ff       	call   8010685d <stosb>
80106908:	83 c4 0c             	add    $0xc,%esp
  return dst;
8010690b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010690e:	c9                   	leave  
8010690f:	c3                   	ret    

80106910 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106916:	8b 45 08             	mov    0x8(%ebp),%eax
80106919:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010691c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010691f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106922:	eb 30                	jmp    80106954 <memcmp+0x44>
    if(*s1 != *s2)
80106924:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106927:	0f b6 10             	movzbl (%eax),%edx
8010692a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010692d:	0f b6 00             	movzbl (%eax),%eax
80106930:	38 c2                	cmp    %al,%dl
80106932:	74 18                	je     8010694c <memcmp+0x3c>
      return *s1 - *s2;
80106934:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106937:	0f b6 00             	movzbl (%eax),%eax
8010693a:	0f b6 d0             	movzbl %al,%edx
8010693d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106940:	0f b6 00             	movzbl (%eax),%eax
80106943:	0f b6 c0             	movzbl %al,%eax
80106946:	29 c2                	sub    %eax,%edx
80106948:	89 d0                	mov    %edx,%eax
8010694a:	eb 1a                	jmp    80106966 <memcmp+0x56>
    s1++, s2++;
8010694c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106950:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106954:	8b 45 10             	mov    0x10(%ebp),%eax
80106957:	8d 50 ff             	lea    -0x1(%eax),%edx
8010695a:	89 55 10             	mov    %edx,0x10(%ebp)
8010695d:	85 c0                	test   %eax,%eax
8010695f:	75 c3                	jne    80106924 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106961:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106966:	c9                   	leave  
80106967:	c3                   	ret    

80106968 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106968:	55                   	push   %ebp
80106969:	89 e5                	mov    %esp,%ebp
8010696b:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010696e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106971:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106974:	8b 45 08             	mov    0x8(%ebp),%eax
80106977:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010697a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010697d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106980:	73 54                	jae    801069d6 <memmove+0x6e>
80106982:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106985:	8b 45 10             	mov    0x10(%ebp),%eax
80106988:	01 d0                	add    %edx,%eax
8010698a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010698d:	76 47                	jbe    801069d6 <memmove+0x6e>
    s += n;
8010698f:	8b 45 10             	mov    0x10(%ebp),%eax
80106992:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106995:	8b 45 10             	mov    0x10(%ebp),%eax
80106998:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010699b:	eb 13                	jmp    801069b0 <memmove+0x48>
      *--d = *--s;
8010699d:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801069a1:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801069a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069a8:	0f b6 10             	movzbl (%eax),%edx
801069ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
801069ae:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801069b0:	8b 45 10             	mov    0x10(%ebp),%eax
801069b3:	8d 50 ff             	lea    -0x1(%eax),%edx
801069b6:	89 55 10             	mov    %edx,0x10(%ebp)
801069b9:	85 c0                	test   %eax,%eax
801069bb:	75 e0                	jne    8010699d <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801069bd:	eb 24                	jmp    801069e3 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801069bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801069c2:	8d 50 01             	lea    0x1(%eax),%edx
801069c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
801069c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069cb:	8d 4a 01             	lea    0x1(%edx),%ecx
801069ce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801069d1:	0f b6 12             	movzbl (%edx),%edx
801069d4:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801069d6:	8b 45 10             	mov    0x10(%ebp),%eax
801069d9:	8d 50 ff             	lea    -0x1(%eax),%edx
801069dc:	89 55 10             	mov    %edx,0x10(%ebp)
801069df:	85 c0                	test   %eax,%eax
801069e1:	75 dc                	jne    801069bf <memmove+0x57>
      *d++ = *s++;

  return dst;
801069e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801069e6:	c9                   	leave  
801069e7:	c3                   	ret    

801069e8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801069e8:	55                   	push   %ebp
801069e9:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801069eb:	ff 75 10             	pushl  0x10(%ebp)
801069ee:	ff 75 0c             	pushl  0xc(%ebp)
801069f1:	ff 75 08             	pushl  0x8(%ebp)
801069f4:	e8 6f ff ff ff       	call   80106968 <memmove>
801069f9:	83 c4 0c             	add    $0xc,%esp
}
801069fc:	c9                   	leave  
801069fd:	c3                   	ret    

801069fe <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801069fe:	55                   	push   %ebp
801069ff:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106a01:	eb 0c                	jmp    80106a0f <strncmp+0x11>
    n--, p++, q++;
80106a03:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106a07:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106a0b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106a0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106a13:	74 1a                	je     80106a2f <strncmp+0x31>
80106a15:	8b 45 08             	mov    0x8(%ebp),%eax
80106a18:	0f b6 00             	movzbl (%eax),%eax
80106a1b:	84 c0                	test   %al,%al
80106a1d:	74 10                	je     80106a2f <strncmp+0x31>
80106a1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a22:	0f b6 10             	movzbl (%eax),%edx
80106a25:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a28:	0f b6 00             	movzbl (%eax),%eax
80106a2b:	38 c2                	cmp    %al,%dl
80106a2d:	74 d4                	je     80106a03 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106a2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106a33:	75 07                	jne    80106a3c <strncmp+0x3e>
    return 0;
80106a35:	b8 00 00 00 00       	mov    $0x0,%eax
80106a3a:	eb 16                	jmp    80106a52 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a3f:	0f b6 00             	movzbl (%eax),%eax
80106a42:	0f b6 d0             	movzbl %al,%edx
80106a45:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a48:	0f b6 00             	movzbl (%eax),%eax
80106a4b:	0f b6 c0             	movzbl %al,%eax
80106a4e:	29 c2                	sub    %eax,%edx
80106a50:	89 d0                	mov    %edx,%eax
}
80106a52:	5d                   	pop    %ebp
80106a53:	c3                   	ret    

80106a54 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106a54:	55                   	push   %ebp
80106a55:	89 e5                	mov    %esp,%ebp
80106a57:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80106a5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106a60:	90                   	nop
80106a61:	8b 45 10             	mov    0x10(%ebp),%eax
80106a64:	8d 50 ff             	lea    -0x1(%eax),%edx
80106a67:	89 55 10             	mov    %edx,0x10(%ebp)
80106a6a:	85 c0                	test   %eax,%eax
80106a6c:	7e 2c                	jle    80106a9a <strncpy+0x46>
80106a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a71:	8d 50 01             	lea    0x1(%eax),%edx
80106a74:	89 55 08             	mov    %edx,0x8(%ebp)
80106a77:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a7a:	8d 4a 01             	lea    0x1(%edx),%ecx
80106a7d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106a80:	0f b6 12             	movzbl (%edx),%edx
80106a83:	88 10                	mov    %dl,(%eax)
80106a85:	0f b6 00             	movzbl (%eax),%eax
80106a88:	84 c0                	test   %al,%al
80106a8a:	75 d5                	jne    80106a61 <strncpy+0xd>
    ;
  while(n-- > 0)
80106a8c:	eb 0c                	jmp    80106a9a <strncpy+0x46>
    *s++ = 0;
80106a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a91:	8d 50 01             	lea    0x1(%eax),%edx
80106a94:	89 55 08             	mov    %edx,0x8(%ebp)
80106a97:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106a9a:	8b 45 10             	mov    0x10(%ebp),%eax
80106a9d:	8d 50 ff             	lea    -0x1(%eax),%edx
80106aa0:	89 55 10             	mov    %edx,0x10(%ebp)
80106aa3:	85 c0                	test   %eax,%eax
80106aa5:	7f e7                	jg     80106a8e <strncpy+0x3a>
    *s++ = 0;
  return os;
80106aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106aaa:	c9                   	leave  
80106aab:	c3                   	ret    

80106aac <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106aac:	55                   	push   %ebp
80106aad:	89 e5                	mov    %esp,%ebp
80106aaf:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106ab8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106abc:	7f 05                	jg     80106ac3 <safestrcpy+0x17>
    return os;
80106abe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ac1:	eb 31                	jmp    80106af4 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106ac3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106ac7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106acb:	7e 1e                	jle    80106aeb <safestrcpy+0x3f>
80106acd:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad0:	8d 50 01             	lea    0x1(%eax),%edx
80106ad3:	89 55 08             	mov    %edx,0x8(%ebp)
80106ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ad9:	8d 4a 01             	lea    0x1(%edx),%ecx
80106adc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106adf:	0f b6 12             	movzbl (%edx),%edx
80106ae2:	88 10                	mov    %dl,(%eax)
80106ae4:	0f b6 00             	movzbl (%eax),%eax
80106ae7:	84 c0                	test   %al,%al
80106ae9:	75 d8                	jne    80106ac3 <safestrcpy+0x17>
    ;
  *s = 0;
80106aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80106aee:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106af4:	c9                   	leave  
80106af5:	c3                   	ret    

80106af6 <strlen>:

int
strlen(const char *s)
{
80106af6:	55                   	push   %ebp
80106af7:	89 e5                	mov    %esp,%ebp
80106af9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106afc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106b03:	eb 04                	jmp    80106b09 <strlen+0x13>
80106b05:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106b09:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b0f:	01 d0                	add    %edx,%eax
80106b11:	0f b6 00             	movzbl (%eax),%eax
80106b14:	84 c0                	test   %al,%al
80106b16:	75 ed                	jne    80106b05 <strlen+0xf>
    ;
  return n;
80106b18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106b1b:	c9                   	leave  
80106b1c:	c3                   	ret    

80106b1d <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106b1d:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106b21:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106b25:	55                   	push   %ebp
  pushl %ebx
80106b26:	53                   	push   %ebx
  pushl %esi
80106b27:	56                   	push   %esi
  pushl %edi
80106b28:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106b29:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106b2b:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106b2d:	5f                   	pop    %edi
  popl %esi
80106b2e:	5e                   	pop    %esi
  popl %ebx
80106b2f:	5b                   	pop    %ebx
  popl %ebp
80106b30:	5d                   	pop    %ebp
  ret
80106b31:	c3                   	ret    

80106b32 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106b32:	55                   	push   %ebp
80106b33:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106b35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b3b:	8b 00                	mov    (%eax),%eax
80106b3d:	3b 45 08             	cmp    0x8(%ebp),%eax
80106b40:	76 12                	jbe    80106b54 <fetchint+0x22>
80106b42:	8b 45 08             	mov    0x8(%ebp),%eax
80106b45:	8d 50 04             	lea    0x4(%eax),%edx
80106b48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b4e:	8b 00                	mov    (%eax),%eax
80106b50:	39 c2                	cmp    %eax,%edx
80106b52:	76 07                	jbe    80106b5b <fetchint+0x29>
    return -1;
80106b54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b59:	eb 0f                	jmp    80106b6a <fetchint+0x38>
  *ip = *(int*)(addr);
80106b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5e:	8b 10                	mov    (%eax),%edx
80106b60:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b63:	89 10                	mov    %edx,(%eax)
  return 0;
80106b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b6a:	5d                   	pop    %ebp
80106b6b:	c3                   	ret    

80106b6c <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106b6c:	55                   	push   %ebp
80106b6d:	89 e5                	mov    %esp,%ebp
80106b6f:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106b72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b78:	8b 00                	mov    (%eax),%eax
80106b7a:	3b 45 08             	cmp    0x8(%ebp),%eax
80106b7d:	77 07                	ja     80106b86 <fetchstr+0x1a>
    return -1;
80106b7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b84:	eb 46                	jmp    80106bcc <fetchstr+0x60>
  *pp = (char*)addr;
80106b86:	8b 55 08             	mov    0x8(%ebp),%edx
80106b89:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b8c:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106b8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b94:	8b 00                	mov    (%eax),%eax
80106b96:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106b99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b9c:	8b 00                	mov    (%eax),%eax
80106b9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106ba1:	eb 1c                	jmp    80106bbf <fetchstr+0x53>
    if(*s == 0)
80106ba3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ba6:	0f b6 00             	movzbl (%eax),%eax
80106ba9:	84 c0                	test   %al,%al
80106bab:	75 0e                	jne    80106bbb <fetchstr+0x4f>
      return s - *pp;
80106bad:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bb3:	8b 00                	mov    (%eax),%eax
80106bb5:	29 c2                	sub    %eax,%edx
80106bb7:	89 d0                	mov    %edx,%eax
80106bb9:	eb 11                	jmp    80106bcc <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106bbb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106bbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bc2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106bc5:	72 dc                	jb     80106ba3 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106bc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bcc:	c9                   	leave  
80106bcd:	c3                   	ret    

80106bce <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106bce:	55                   	push   %ebp
80106bcf:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106bd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bd7:	8b 40 18             	mov    0x18(%eax),%eax
80106bda:	8b 40 44             	mov    0x44(%eax),%eax
80106bdd:	8b 55 08             	mov    0x8(%ebp),%edx
80106be0:	c1 e2 02             	shl    $0x2,%edx
80106be3:	01 d0                	add    %edx,%eax
80106be5:	83 c0 04             	add    $0x4,%eax
80106be8:	ff 75 0c             	pushl  0xc(%ebp)
80106beb:	50                   	push   %eax
80106bec:	e8 41 ff ff ff       	call   80106b32 <fetchint>
80106bf1:	83 c4 08             	add    $0x8,%esp
}
80106bf4:	c9                   	leave  
80106bf5:	c3                   	ret    

80106bf6 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106bf6:	55                   	push   %ebp
80106bf7:	89 e5                	mov    %esp,%ebp
80106bf9:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106bfc:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106bff:	50                   	push   %eax
80106c00:	ff 75 08             	pushl  0x8(%ebp)
80106c03:	e8 c6 ff ff ff       	call   80106bce <argint>
80106c08:	83 c4 08             	add    $0x8,%esp
80106c0b:	85 c0                	test   %eax,%eax
80106c0d:	79 07                	jns    80106c16 <argptr+0x20>
    return -1;
80106c0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c14:	eb 3b                	jmp    80106c51 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106c16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c1c:	8b 00                	mov    (%eax),%eax
80106c1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c21:	39 d0                	cmp    %edx,%eax
80106c23:	76 16                	jbe    80106c3b <argptr+0x45>
80106c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c28:	89 c2                	mov    %eax,%edx
80106c2a:	8b 45 10             	mov    0x10(%ebp),%eax
80106c2d:	01 c2                	add    %eax,%edx
80106c2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c35:	8b 00                	mov    (%eax),%eax
80106c37:	39 c2                	cmp    %eax,%edx
80106c39:	76 07                	jbe    80106c42 <argptr+0x4c>
    return -1;
80106c3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c40:	eb 0f                	jmp    80106c51 <argptr+0x5b>
  *pp = (char*)i;
80106c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c45:	89 c2                	mov    %eax,%edx
80106c47:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c4a:	89 10                	mov    %edx,(%eax)
  return 0;
80106c4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c51:	c9                   	leave  
80106c52:	c3                   	ret    

80106c53 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106c53:	55                   	push   %ebp
80106c54:	89 e5                	mov    %esp,%ebp
80106c56:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106c59:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106c5c:	50                   	push   %eax
80106c5d:	ff 75 08             	pushl  0x8(%ebp)
80106c60:	e8 69 ff ff ff       	call   80106bce <argint>
80106c65:	83 c4 08             	add    $0x8,%esp
80106c68:	85 c0                	test   %eax,%eax
80106c6a:	79 07                	jns    80106c73 <argstr+0x20>
    return -1;
80106c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c71:	eb 0f                	jmp    80106c82 <argstr+0x2f>
  return fetchstr(addr, pp);
80106c73:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c76:	ff 75 0c             	pushl  0xc(%ebp)
80106c79:	50                   	push   %eax
80106c7a:	e8 ed fe ff ff       	call   80106b6c <fetchstr>
80106c7f:	83 c4 08             	add    $0x8,%esp
}
80106c82:	c9                   	leave  
80106c83:	c3                   	ret    

80106c84 <syscall>:
};
#endif 

void
syscall(void)
{
80106c84:	55                   	push   %ebp
80106c85:	89 e5                	mov    %esp,%ebp
80106c87:	53                   	push   %ebx
80106c88:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106c8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c91:	8b 40 18             	mov    0x18(%eax),%eax
80106c94:	8b 40 1c             	mov    0x1c(%eax),%eax
80106c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106c9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c9e:	7e 30                	jle    80106cd0 <syscall+0x4c>
80106ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ca3:	83 f8 1e             	cmp    $0x1e,%eax
80106ca6:	77 28                	ja     80106cd0 <syscall+0x4c>
80106ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cab:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106cb2:	85 c0                	test   %eax,%eax
80106cb4:	74 1a                	je     80106cd0 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106cb6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cbc:	8b 58 18             	mov    0x18(%eax),%ebx
80106cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cc2:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106cc9:	ff d0                	call   *%eax
80106ccb:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106cce:	eb 34                	jmp    80106d04 <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80106cd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cd6:	8d 50 6c             	lea    0x6c(%eax),%edx
80106cd9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106cdf:	8b 40 10             	mov    0x10(%eax),%eax
80106ce2:	ff 75 f4             	pushl  -0xc(%ebp)
80106ce5:	52                   	push   %edx
80106ce6:	50                   	push   %eax
80106ce7:	68 02 a3 10 80       	push   $0x8010a302
80106cec:	e8 d5 96 ff ff       	call   801003c6 <cprintf>
80106cf1:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106cf4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cfa:	8b 40 18             	mov    0x18(%eax),%eax
80106cfd:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106d04:	90                   	nop
80106d05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106d08:	c9                   	leave  
80106d09:	c3                   	ret    

80106d0a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106d0a:	55                   	push   %ebp
80106d0b:	89 e5                	mov    %esp,%ebp
80106d0d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106d10:	83 ec 08             	sub    $0x8,%esp
80106d13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d16:	50                   	push   %eax
80106d17:	ff 75 08             	pushl  0x8(%ebp)
80106d1a:	e8 af fe ff ff       	call   80106bce <argint>
80106d1f:	83 c4 10             	add    $0x10,%esp
80106d22:	85 c0                	test   %eax,%eax
80106d24:	79 07                	jns    80106d2d <argfd+0x23>
    return -1;
80106d26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d2b:	eb 50                	jmp    80106d7d <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d30:	85 c0                	test   %eax,%eax
80106d32:	78 21                	js     80106d55 <argfd+0x4b>
80106d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d37:	83 f8 0f             	cmp    $0xf,%eax
80106d3a:	7f 19                	jg     80106d55 <argfd+0x4b>
80106d3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d42:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d45:	83 c2 08             	add    $0x8,%edx
80106d48:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106d4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106d53:	75 07                	jne    80106d5c <argfd+0x52>
    return -1;
80106d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d5a:	eb 21                	jmp    80106d7d <argfd+0x73>
  if(pfd)
80106d5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106d60:	74 08                	je     80106d6a <argfd+0x60>
    *pfd = fd;
80106d62:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d65:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d68:	89 10                	mov    %edx,(%eax)
  if(pf)
80106d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106d6e:	74 08                	je     80106d78 <argfd+0x6e>
    *pf = f;
80106d70:	8b 45 10             	mov    0x10(%ebp),%eax
80106d73:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106d76:	89 10                	mov    %edx,(%eax)
  return 0;
80106d78:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d7d:	c9                   	leave  
80106d7e:	c3                   	ret    

80106d7f <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106d7f:	55                   	push   %ebp
80106d80:	89 e5                	mov    %esp,%ebp
80106d82:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106d85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106d8c:	eb 30                	jmp    80106dbe <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106d8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d94:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106d97:	83 c2 08             	add    $0x8,%edx
80106d9a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106d9e:	85 c0                	test   %eax,%eax
80106da0:	75 18                	jne    80106dba <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106da2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106da8:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106dab:	8d 4a 08             	lea    0x8(%edx),%ecx
80106dae:	8b 55 08             	mov    0x8(%ebp),%edx
80106db1:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106db5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106db8:	eb 0f                	jmp    80106dc9 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106dba:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106dbe:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106dc2:	7e ca                	jle    80106d8e <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106dc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dc9:	c9                   	leave  
80106dca:	c3                   	ret    

80106dcb <sys_dup>:

int
sys_dup(void)
{
80106dcb:	55                   	push   %ebp
80106dcc:	89 e5                	mov    %esp,%ebp
80106dce:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106dd1:	83 ec 04             	sub    $0x4,%esp
80106dd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106dd7:	50                   	push   %eax
80106dd8:	6a 00                	push   $0x0
80106dda:	6a 00                	push   $0x0
80106ddc:	e8 29 ff ff ff       	call   80106d0a <argfd>
80106de1:	83 c4 10             	add    $0x10,%esp
80106de4:	85 c0                	test   %eax,%eax
80106de6:	79 07                	jns    80106def <sys_dup+0x24>
    return -1;
80106de8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ded:	eb 31                	jmp    80106e20 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106def:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106df2:	83 ec 0c             	sub    $0xc,%esp
80106df5:	50                   	push   %eax
80106df6:	e8 84 ff ff ff       	call   80106d7f <fdalloc>
80106dfb:	83 c4 10             	add    $0x10,%esp
80106dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e05:	79 07                	jns    80106e0e <sys_dup+0x43>
    return -1;
80106e07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e0c:	eb 12                	jmp    80106e20 <sys_dup+0x55>
  filedup(f);
80106e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e11:	83 ec 0c             	sub    $0xc,%esp
80106e14:	50                   	push   %eax
80106e15:	e8 90 a2 ff ff       	call   801010aa <filedup>
80106e1a:	83 c4 10             	add    $0x10,%esp
  return fd;
80106e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106e20:	c9                   	leave  
80106e21:	c3                   	ret    

80106e22 <sys_read>:

int
sys_read(void)
{
80106e22:	55                   	push   %ebp
80106e23:	89 e5                	mov    %esp,%ebp
80106e25:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106e28:	83 ec 04             	sub    $0x4,%esp
80106e2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e2e:	50                   	push   %eax
80106e2f:	6a 00                	push   $0x0
80106e31:	6a 00                	push   $0x0
80106e33:	e8 d2 fe ff ff       	call   80106d0a <argfd>
80106e38:	83 c4 10             	add    $0x10,%esp
80106e3b:	85 c0                	test   %eax,%eax
80106e3d:	78 2e                	js     80106e6d <sys_read+0x4b>
80106e3f:	83 ec 08             	sub    $0x8,%esp
80106e42:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e45:	50                   	push   %eax
80106e46:	6a 02                	push   $0x2
80106e48:	e8 81 fd ff ff       	call   80106bce <argint>
80106e4d:	83 c4 10             	add    $0x10,%esp
80106e50:	85 c0                	test   %eax,%eax
80106e52:	78 19                	js     80106e6d <sys_read+0x4b>
80106e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e57:	83 ec 04             	sub    $0x4,%esp
80106e5a:	50                   	push   %eax
80106e5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106e5e:	50                   	push   %eax
80106e5f:	6a 01                	push   $0x1
80106e61:	e8 90 fd ff ff       	call   80106bf6 <argptr>
80106e66:	83 c4 10             	add    $0x10,%esp
80106e69:	85 c0                	test   %eax,%eax
80106e6b:	79 07                	jns    80106e74 <sys_read+0x52>
    return -1;
80106e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e72:	eb 17                	jmp    80106e8b <sys_read+0x69>
  return fileread(f, p, n);
80106e74:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106e77:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e7d:	83 ec 04             	sub    $0x4,%esp
80106e80:	51                   	push   %ecx
80106e81:	52                   	push   %edx
80106e82:	50                   	push   %eax
80106e83:	e8 b2 a3 ff ff       	call   8010123a <fileread>
80106e88:	83 c4 10             	add    $0x10,%esp
}
80106e8b:	c9                   	leave  
80106e8c:	c3                   	ret    

80106e8d <sys_write>:

int
sys_write(void)
{
80106e8d:	55                   	push   %ebp
80106e8e:	89 e5                	mov    %esp,%ebp
80106e90:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106e93:	83 ec 04             	sub    $0x4,%esp
80106e96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e99:	50                   	push   %eax
80106e9a:	6a 00                	push   $0x0
80106e9c:	6a 00                	push   $0x0
80106e9e:	e8 67 fe ff ff       	call   80106d0a <argfd>
80106ea3:	83 c4 10             	add    $0x10,%esp
80106ea6:	85 c0                	test   %eax,%eax
80106ea8:	78 2e                	js     80106ed8 <sys_write+0x4b>
80106eaa:	83 ec 08             	sub    $0x8,%esp
80106ead:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106eb0:	50                   	push   %eax
80106eb1:	6a 02                	push   $0x2
80106eb3:	e8 16 fd ff ff       	call   80106bce <argint>
80106eb8:	83 c4 10             	add    $0x10,%esp
80106ebb:	85 c0                	test   %eax,%eax
80106ebd:	78 19                	js     80106ed8 <sys_write+0x4b>
80106ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ec2:	83 ec 04             	sub    $0x4,%esp
80106ec5:	50                   	push   %eax
80106ec6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ec9:	50                   	push   %eax
80106eca:	6a 01                	push   $0x1
80106ecc:	e8 25 fd ff ff       	call   80106bf6 <argptr>
80106ed1:	83 c4 10             	add    $0x10,%esp
80106ed4:	85 c0                	test   %eax,%eax
80106ed6:	79 07                	jns    80106edf <sys_write+0x52>
    return -1;
80106ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106edd:	eb 17                	jmp    80106ef6 <sys_write+0x69>
  return filewrite(f, p, n);
80106edf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106ee2:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ee8:	83 ec 04             	sub    $0x4,%esp
80106eeb:	51                   	push   %ecx
80106eec:	52                   	push   %edx
80106eed:	50                   	push   %eax
80106eee:	e8 ff a3 ff ff       	call   801012f2 <filewrite>
80106ef3:	83 c4 10             	add    $0x10,%esp
}
80106ef6:	c9                   	leave  
80106ef7:	c3                   	ret    

80106ef8 <sys_close>:

int
sys_close(void)
{
80106ef8:	55                   	push   %ebp
80106ef9:	89 e5                	mov    %esp,%ebp
80106efb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106efe:	83 ec 04             	sub    $0x4,%esp
80106f01:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f04:	50                   	push   %eax
80106f05:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f08:	50                   	push   %eax
80106f09:	6a 00                	push   $0x0
80106f0b:	e8 fa fd ff ff       	call   80106d0a <argfd>
80106f10:	83 c4 10             	add    $0x10,%esp
80106f13:	85 c0                	test   %eax,%eax
80106f15:	79 07                	jns    80106f1e <sys_close+0x26>
    return -1;
80106f17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f1c:	eb 28                	jmp    80106f46 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106f1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f24:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f27:	83 c2 08             	add    $0x8,%edx
80106f2a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106f31:	00 
  fileclose(f);
80106f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f35:	83 ec 0c             	sub    $0xc,%esp
80106f38:	50                   	push   %eax
80106f39:	e8 bd a1 ff ff       	call   801010fb <fileclose>
80106f3e:	83 c4 10             	add    $0x10,%esp
  return 0;
80106f41:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106f46:	c9                   	leave  
80106f47:	c3                   	ret    

80106f48 <sys_fstat>:

int
sys_fstat(void)
{
80106f48:	55                   	push   %ebp
80106f49:	89 e5                	mov    %esp,%ebp
80106f4b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106f4e:	83 ec 04             	sub    $0x4,%esp
80106f51:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f54:	50                   	push   %eax
80106f55:	6a 00                	push   $0x0
80106f57:	6a 00                	push   $0x0
80106f59:	e8 ac fd ff ff       	call   80106d0a <argfd>
80106f5e:	83 c4 10             	add    $0x10,%esp
80106f61:	85 c0                	test   %eax,%eax
80106f63:	78 17                	js     80106f7c <sys_fstat+0x34>
80106f65:	83 ec 04             	sub    $0x4,%esp
80106f68:	6a 14                	push   $0x14
80106f6a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f6d:	50                   	push   %eax
80106f6e:	6a 01                	push   $0x1
80106f70:	e8 81 fc ff ff       	call   80106bf6 <argptr>
80106f75:	83 c4 10             	add    $0x10,%esp
80106f78:	85 c0                	test   %eax,%eax
80106f7a:	79 07                	jns    80106f83 <sys_fstat+0x3b>
    return -1;
80106f7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f81:	eb 13                	jmp    80106f96 <sys_fstat+0x4e>
  return filestat(f, st);
80106f83:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f89:	83 ec 08             	sub    $0x8,%esp
80106f8c:	52                   	push   %edx
80106f8d:	50                   	push   %eax
80106f8e:	e8 50 a2 ff ff       	call   801011e3 <filestat>
80106f93:	83 c4 10             	add    $0x10,%esp
}
80106f96:	c9                   	leave  
80106f97:	c3                   	ret    

80106f98 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106f98:	55                   	push   %ebp
80106f99:	89 e5                	mov    %esp,%ebp
80106f9b:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106f9e:	83 ec 08             	sub    $0x8,%esp
80106fa1:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106fa4:	50                   	push   %eax
80106fa5:	6a 00                	push   $0x0
80106fa7:	e8 a7 fc ff ff       	call   80106c53 <argstr>
80106fac:	83 c4 10             	add    $0x10,%esp
80106faf:	85 c0                	test   %eax,%eax
80106fb1:	78 15                	js     80106fc8 <sys_link+0x30>
80106fb3:	83 ec 08             	sub    $0x8,%esp
80106fb6:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106fb9:	50                   	push   %eax
80106fba:	6a 01                	push   $0x1
80106fbc:	e8 92 fc ff ff       	call   80106c53 <argstr>
80106fc1:	83 c4 10             	add    $0x10,%esp
80106fc4:	85 c0                	test   %eax,%eax
80106fc6:	79 0a                	jns    80106fd2 <sys_link+0x3a>
    return -1;
80106fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fcd:	e9 68 01 00 00       	jmp    8010713a <sys_link+0x1a2>

  begin_op();
80106fd2:	e8 20 c6 ff ff       	call   801035f7 <begin_op>
  if((ip = namei(old)) == 0){
80106fd7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106fda:	83 ec 0c             	sub    $0xc,%esp
80106fdd:	50                   	push   %eax
80106fde:	e8 ef b5 ff ff       	call   801025d2 <namei>
80106fe3:	83 c4 10             	add    $0x10,%esp
80106fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fed:	75 0f                	jne    80106ffe <sys_link+0x66>
    end_op();
80106fef:	e8 8f c6 ff ff       	call   80103683 <end_op>
    return -1;
80106ff4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ff9:	e9 3c 01 00 00       	jmp    8010713a <sys_link+0x1a2>
  }

  ilock(ip);
80106ffe:	83 ec 0c             	sub    $0xc,%esp
80107001:	ff 75 f4             	pushl  -0xc(%ebp)
80107004:	e8 0b aa ff ff       	call   80101a14 <ilock>
80107009:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010700c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010700f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107013:	66 83 f8 01          	cmp    $0x1,%ax
80107017:	75 1d                	jne    80107036 <sys_link+0x9e>
    iunlockput(ip);
80107019:	83 ec 0c             	sub    $0xc,%esp
8010701c:	ff 75 f4             	pushl  -0xc(%ebp)
8010701f:	e8 b0 ac ff ff       	call   80101cd4 <iunlockput>
80107024:	83 c4 10             	add    $0x10,%esp
    end_op();
80107027:	e8 57 c6 ff ff       	call   80103683 <end_op>
    return -1;
8010702c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107031:	e9 04 01 00 00       	jmp    8010713a <sys_link+0x1a2>
  }

  ip->nlink++;
80107036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107039:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010703d:	83 c0 01             	add    $0x1,%eax
80107040:	89 c2                	mov    %eax,%edx
80107042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107045:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107049:	83 ec 0c             	sub    $0xc,%esp
8010704c:	ff 75 f4             	pushl  -0xc(%ebp)
8010704f:	e8 e6 a7 ff ff       	call   8010183a <iupdate>
80107054:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80107057:	83 ec 0c             	sub    $0xc,%esp
8010705a:	ff 75 f4             	pushl  -0xc(%ebp)
8010705d:	e8 10 ab ff ff       	call   80101b72 <iunlock>
80107062:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80107065:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107068:	83 ec 08             	sub    $0x8,%esp
8010706b:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010706e:	52                   	push   %edx
8010706f:	50                   	push   %eax
80107070:	e8 79 b5 ff ff       	call   801025ee <nameiparent>
80107075:	83 c4 10             	add    $0x10,%esp
80107078:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010707b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010707f:	74 71                	je     801070f2 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80107081:	83 ec 0c             	sub    $0xc,%esp
80107084:	ff 75 f0             	pushl  -0x10(%ebp)
80107087:	e8 88 a9 ff ff       	call   80101a14 <ilock>
8010708c:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010708f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107092:	8b 10                	mov    (%eax),%edx
80107094:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107097:	8b 00                	mov    (%eax),%eax
80107099:	39 c2                	cmp    %eax,%edx
8010709b:	75 1d                	jne    801070ba <sys_link+0x122>
8010709d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070a0:	8b 40 04             	mov    0x4(%eax),%eax
801070a3:	83 ec 04             	sub    $0x4,%esp
801070a6:	50                   	push   %eax
801070a7:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801070aa:	50                   	push   %eax
801070ab:	ff 75 f0             	pushl  -0x10(%ebp)
801070ae:	e8 83 b2 ff ff       	call   80102336 <dirlink>
801070b3:	83 c4 10             	add    $0x10,%esp
801070b6:	85 c0                	test   %eax,%eax
801070b8:	79 10                	jns    801070ca <sys_link+0x132>
    iunlockput(dp);
801070ba:	83 ec 0c             	sub    $0xc,%esp
801070bd:	ff 75 f0             	pushl  -0x10(%ebp)
801070c0:	e8 0f ac ff ff       	call   80101cd4 <iunlockput>
801070c5:	83 c4 10             	add    $0x10,%esp
    goto bad;
801070c8:	eb 29                	jmp    801070f3 <sys_link+0x15b>
  }
  iunlockput(dp);
801070ca:	83 ec 0c             	sub    $0xc,%esp
801070cd:	ff 75 f0             	pushl  -0x10(%ebp)
801070d0:	e8 ff ab ff ff       	call   80101cd4 <iunlockput>
801070d5:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801070d8:	83 ec 0c             	sub    $0xc,%esp
801070db:	ff 75 f4             	pushl  -0xc(%ebp)
801070de:	e8 01 ab ff ff       	call   80101be4 <iput>
801070e3:	83 c4 10             	add    $0x10,%esp

  end_op();
801070e6:	e8 98 c5 ff ff       	call   80103683 <end_op>

  return 0;
801070eb:	b8 00 00 00 00       	mov    $0x0,%eax
801070f0:	eb 48                	jmp    8010713a <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801070f2:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
801070f3:	83 ec 0c             	sub    $0xc,%esp
801070f6:	ff 75 f4             	pushl  -0xc(%ebp)
801070f9:	e8 16 a9 ff ff       	call   80101a14 <ilock>
801070fe:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80107101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107104:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107108:	83 e8 01             	sub    $0x1,%eax
8010710b:	89 c2                	mov    %eax,%edx
8010710d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107110:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107114:	83 ec 0c             	sub    $0xc,%esp
80107117:	ff 75 f4             	pushl  -0xc(%ebp)
8010711a:	e8 1b a7 ff ff       	call   8010183a <iupdate>
8010711f:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107122:	83 ec 0c             	sub    $0xc,%esp
80107125:	ff 75 f4             	pushl  -0xc(%ebp)
80107128:	e8 a7 ab ff ff       	call   80101cd4 <iunlockput>
8010712d:	83 c4 10             	add    $0x10,%esp
  end_op();
80107130:	e8 4e c5 ff ff       	call   80103683 <end_op>
  return -1;
80107135:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010713a:	c9                   	leave  
8010713b:	c3                   	ret    

8010713c <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010713c:	55                   	push   %ebp
8010713d:	89 e5                	mov    %esp,%ebp
8010713f:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107142:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80107149:	eb 40                	jmp    8010718b <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010714b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010714e:	6a 10                	push   $0x10
80107150:	50                   	push   %eax
80107151:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107154:	50                   	push   %eax
80107155:	ff 75 08             	pushl  0x8(%ebp)
80107158:	e8 25 ae ff ff       	call   80101f82 <readi>
8010715d:	83 c4 10             	add    $0x10,%esp
80107160:	83 f8 10             	cmp    $0x10,%eax
80107163:	74 0d                	je     80107172 <isdirempty+0x36>
      panic("isdirempty: readi");
80107165:	83 ec 0c             	sub    $0xc,%esp
80107168:	68 1e a3 10 80       	push   $0x8010a31e
8010716d:	e8 f4 93 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80107172:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80107176:	66 85 c0             	test   %ax,%ax
80107179:	74 07                	je     80107182 <isdirempty+0x46>
      return 0;
8010717b:	b8 00 00 00 00       	mov    $0x0,%eax
80107180:	eb 1b                	jmp    8010719d <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107185:	83 c0 10             	add    $0x10,%eax
80107188:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010718b:	8b 45 08             	mov    0x8(%ebp),%eax
8010718e:	8b 50 18             	mov    0x18(%eax),%edx
80107191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107194:	39 c2                	cmp    %eax,%edx
80107196:	77 b3                	ja     8010714b <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80107198:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010719d:	c9                   	leave  
8010719e:	c3                   	ret    

8010719f <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010719f:	55                   	push   %ebp
801071a0:	89 e5                	mov    %esp,%ebp
801071a2:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801071a5:	83 ec 08             	sub    $0x8,%esp
801071a8:	8d 45 cc             	lea    -0x34(%ebp),%eax
801071ab:	50                   	push   %eax
801071ac:	6a 00                	push   $0x0
801071ae:	e8 a0 fa ff ff       	call   80106c53 <argstr>
801071b3:	83 c4 10             	add    $0x10,%esp
801071b6:	85 c0                	test   %eax,%eax
801071b8:	79 0a                	jns    801071c4 <sys_unlink+0x25>
    return -1;
801071ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071bf:	e9 bc 01 00 00       	jmp    80107380 <sys_unlink+0x1e1>

  begin_op();
801071c4:	e8 2e c4 ff ff       	call   801035f7 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801071c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801071cc:	83 ec 08             	sub    $0x8,%esp
801071cf:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801071d2:	52                   	push   %edx
801071d3:	50                   	push   %eax
801071d4:	e8 15 b4 ff ff       	call   801025ee <nameiparent>
801071d9:	83 c4 10             	add    $0x10,%esp
801071dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801071df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071e3:	75 0f                	jne    801071f4 <sys_unlink+0x55>
    end_op();
801071e5:	e8 99 c4 ff ff       	call   80103683 <end_op>
    return -1;
801071ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071ef:	e9 8c 01 00 00       	jmp    80107380 <sys_unlink+0x1e1>
  }

  ilock(dp);
801071f4:	83 ec 0c             	sub    $0xc,%esp
801071f7:	ff 75 f4             	pushl  -0xc(%ebp)
801071fa:	e8 15 a8 ff ff       	call   80101a14 <ilock>
801071ff:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80107202:	83 ec 08             	sub    $0x8,%esp
80107205:	68 30 a3 10 80       	push   $0x8010a330
8010720a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010720d:	50                   	push   %eax
8010720e:	e8 4e b0 ff ff       	call   80102261 <namecmp>
80107213:	83 c4 10             	add    $0x10,%esp
80107216:	85 c0                	test   %eax,%eax
80107218:	0f 84 4a 01 00 00    	je     80107368 <sys_unlink+0x1c9>
8010721e:	83 ec 08             	sub    $0x8,%esp
80107221:	68 32 a3 10 80       	push   $0x8010a332
80107226:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107229:	50                   	push   %eax
8010722a:	e8 32 b0 ff ff       	call   80102261 <namecmp>
8010722f:	83 c4 10             	add    $0x10,%esp
80107232:	85 c0                	test   %eax,%eax
80107234:	0f 84 2e 01 00 00    	je     80107368 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010723a:	83 ec 04             	sub    $0x4,%esp
8010723d:	8d 45 c8             	lea    -0x38(%ebp),%eax
80107240:	50                   	push   %eax
80107241:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107244:	50                   	push   %eax
80107245:	ff 75 f4             	pushl  -0xc(%ebp)
80107248:	e8 2f b0 ff ff       	call   8010227c <dirlookup>
8010724d:	83 c4 10             	add    $0x10,%esp
80107250:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107253:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107257:	0f 84 0a 01 00 00    	je     80107367 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
8010725d:	83 ec 0c             	sub    $0xc,%esp
80107260:	ff 75 f0             	pushl  -0x10(%ebp)
80107263:	e8 ac a7 ff ff       	call   80101a14 <ilock>
80107268:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010726b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010726e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107272:	66 85 c0             	test   %ax,%ax
80107275:	7f 0d                	jg     80107284 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80107277:	83 ec 0c             	sub    $0xc,%esp
8010727a:	68 35 a3 10 80       	push   $0x8010a335
8010727f:	e8 e2 92 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80107284:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107287:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010728b:	66 83 f8 01          	cmp    $0x1,%ax
8010728f:	75 25                	jne    801072b6 <sys_unlink+0x117>
80107291:	83 ec 0c             	sub    $0xc,%esp
80107294:	ff 75 f0             	pushl  -0x10(%ebp)
80107297:	e8 a0 fe ff ff       	call   8010713c <isdirempty>
8010729c:	83 c4 10             	add    $0x10,%esp
8010729f:	85 c0                	test   %eax,%eax
801072a1:	75 13                	jne    801072b6 <sys_unlink+0x117>
    iunlockput(ip);
801072a3:	83 ec 0c             	sub    $0xc,%esp
801072a6:	ff 75 f0             	pushl  -0x10(%ebp)
801072a9:	e8 26 aa ff ff       	call   80101cd4 <iunlockput>
801072ae:	83 c4 10             	add    $0x10,%esp
    goto bad;
801072b1:	e9 b2 00 00 00       	jmp    80107368 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801072b6:	83 ec 04             	sub    $0x4,%esp
801072b9:	6a 10                	push   $0x10
801072bb:	6a 00                	push   $0x0
801072bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
801072c0:	50                   	push   %eax
801072c1:	e8 e3 f5 ff ff       	call   801068a9 <memset>
801072c6:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801072c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
801072cc:	6a 10                	push   $0x10
801072ce:	50                   	push   %eax
801072cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
801072d2:	50                   	push   %eax
801072d3:	ff 75 f4             	pushl  -0xc(%ebp)
801072d6:	e8 fe ad ff ff       	call   801020d9 <writei>
801072db:	83 c4 10             	add    $0x10,%esp
801072de:	83 f8 10             	cmp    $0x10,%eax
801072e1:	74 0d                	je     801072f0 <sys_unlink+0x151>
    panic("unlink: writei");
801072e3:	83 ec 0c             	sub    $0xc,%esp
801072e6:	68 47 a3 10 80       	push   $0x8010a347
801072eb:	e8 76 92 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801072f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072f3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801072f7:	66 83 f8 01          	cmp    $0x1,%ax
801072fb:	75 21                	jne    8010731e <sys_unlink+0x17f>
    dp->nlink--;
801072fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107300:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107304:	83 e8 01             	sub    $0x1,%eax
80107307:	89 c2                	mov    %eax,%edx
80107309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107310:	83 ec 0c             	sub    $0xc,%esp
80107313:	ff 75 f4             	pushl  -0xc(%ebp)
80107316:	e8 1f a5 ff ff       	call   8010183a <iupdate>
8010731b:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010731e:	83 ec 0c             	sub    $0xc,%esp
80107321:	ff 75 f4             	pushl  -0xc(%ebp)
80107324:	e8 ab a9 ff ff       	call   80101cd4 <iunlockput>
80107329:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010732c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010732f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107333:	83 e8 01             	sub    $0x1,%eax
80107336:	89 c2                	mov    %eax,%edx
80107338:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010733b:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010733f:	83 ec 0c             	sub    $0xc,%esp
80107342:	ff 75 f0             	pushl  -0x10(%ebp)
80107345:	e8 f0 a4 ff ff       	call   8010183a <iupdate>
8010734a:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010734d:	83 ec 0c             	sub    $0xc,%esp
80107350:	ff 75 f0             	pushl  -0x10(%ebp)
80107353:	e8 7c a9 ff ff       	call   80101cd4 <iunlockput>
80107358:	83 c4 10             	add    $0x10,%esp

  end_op();
8010735b:	e8 23 c3 ff ff       	call   80103683 <end_op>

  return 0;
80107360:	b8 00 00 00 00       	mov    $0x0,%eax
80107365:	eb 19                	jmp    80107380 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80107367:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80107368:	83 ec 0c             	sub    $0xc,%esp
8010736b:	ff 75 f4             	pushl  -0xc(%ebp)
8010736e:	e8 61 a9 ff ff       	call   80101cd4 <iunlockput>
80107373:	83 c4 10             	add    $0x10,%esp
  end_op();
80107376:	e8 08 c3 ff ff       	call   80103683 <end_op>
  return -1;
8010737b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107380:	c9                   	leave  
80107381:	c3                   	ret    

80107382 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80107382:	55                   	push   %ebp
80107383:	89 e5                	mov    %esp,%ebp
80107385:	83 ec 38             	sub    $0x38,%esp
80107388:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010738b:	8b 55 10             	mov    0x10(%ebp),%edx
8010738e:	8b 45 14             	mov    0x14(%ebp),%eax
80107391:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80107395:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80107399:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010739d:	83 ec 08             	sub    $0x8,%esp
801073a0:	8d 45 de             	lea    -0x22(%ebp),%eax
801073a3:	50                   	push   %eax
801073a4:	ff 75 08             	pushl  0x8(%ebp)
801073a7:	e8 42 b2 ff ff       	call   801025ee <nameiparent>
801073ac:	83 c4 10             	add    $0x10,%esp
801073af:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073b6:	75 0a                	jne    801073c2 <create+0x40>
    return 0;
801073b8:	b8 00 00 00 00       	mov    $0x0,%eax
801073bd:	e9 90 01 00 00       	jmp    80107552 <create+0x1d0>
  ilock(dp);
801073c2:	83 ec 0c             	sub    $0xc,%esp
801073c5:	ff 75 f4             	pushl  -0xc(%ebp)
801073c8:	e8 47 a6 ff ff       	call   80101a14 <ilock>
801073cd:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801073d0:	83 ec 04             	sub    $0x4,%esp
801073d3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801073d6:	50                   	push   %eax
801073d7:	8d 45 de             	lea    -0x22(%ebp),%eax
801073da:	50                   	push   %eax
801073db:	ff 75 f4             	pushl  -0xc(%ebp)
801073de:	e8 99 ae ff ff       	call   8010227c <dirlookup>
801073e3:	83 c4 10             	add    $0x10,%esp
801073e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801073e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801073ed:	74 50                	je     8010743f <create+0xbd>
    iunlockput(dp);
801073ef:	83 ec 0c             	sub    $0xc,%esp
801073f2:	ff 75 f4             	pushl  -0xc(%ebp)
801073f5:	e8 da a8 ff ff       	call   80101cd4 <iunlockput>
801073fa:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801073fd:	83 ec 0c             	sub    $0xc,%esp
80107400:	ff 75 f0             	pushl  -0x10(%ebp)
80107403:	e8 0c a6 ff ff       	call   80101a14 <ilock>
80107408:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010740b:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80107410:	75 15                	jne    80107427 <create+0xa5>
80107412:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107415:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107419:	66 83 f8 02          	cmp    $0x2,%ax
8010741d:	75 08                	jne    80107427 <create+0xa5>
      return ip;
8010741f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107422:	e9 2b 01 00 00       	jmp    80107552 <create+0x1d0>
    iunlockput(ip);
80107427:	83 ec 0c             	sub    $0xc,%esp
8010742a:	ff 75 f0             	pushl  -0x10(%ebp)
8010742d:	e8 a2 a8 ff ff       	call   80101cd4 <iunlockput>
80107432:	83 c4 10             	add    $0x10,%esp
    return 0;
80107435:	b8 00 00 00 00       	mov    $0x0,%eax
8010743a:	e9 13 01 00 00       	jmp    80107552 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010743f:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80107443:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107446:	8b 00                	mov    (%eax),%eax
80107448:	83 ec 08             	sub    $0x8,%esp
8010744b:	52                   	push   %edx
8010744c:	50                   	push   %eax
8010744d:	e8 11 a3 ff ff       	call   80101763 <ialloc>
80107452:	83 c4 10             	add    $0x10,%esp
80107455:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107458:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010745c:	75 0d                	jne    8010746b <create+0xe9>
    panic("create: ialloc");
8010745e:	83 ec 0c             	sub    $0xc,%esp
80107461:	68 56 a3 10 80       	push   $0x8010a356
80107466:	e8 fb 90 ff ff       	call   80100566 <panic>

  ilock(ip);
8010746b:	83 ec 0c             	sub    $0xc,%esp
8010746e:	ff 75 f0             	pushl  -0x10(%ebp)
80107471:	e8 9e a5 ff ff       	call   80101a14 <ilock>
80107476:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107479:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010747c:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80107480:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80107484:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107487:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010748b:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010748f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107492:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80107498:	83 ec 0c             	sub    $0xc,%esp
8010749b:	ff 75 f0             	pushl  -0x10(%ebp)
8010749e:	e8 97 a3 ff ff       	call   8010183a <iupdate>
801074a3:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801074a6:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801074ab:	75 6a                	jne    80107517 <create+0x195>
    dp->nlink++;  // for ".."
801074ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801074b4:	83 c0 01             	add    $0x1,%eax
801074b7:	89 c2                	mov    %eax,%edx
801074b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074bc:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801074c0:	83 ec 0c             	sub    $0xc,%esp
801074c3:	ff 75 f4             	pushl  -0xc(%ebp)
801074c6:	e8 6f a3 ff ff       	call   8010183a <iupdate>
801074cb:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801074ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074d1:	8b 40 04             	mov    0x4(%eax),%eax
801074d4:	83 ec 04             	sub    $0x4,%esp
801074d7:	50                   	push   %eax
801074d8:	68 30 a3 10 80       	push   $0x8010a330
801074dd:	ff 75 f0             	pushl  -0x10(%ebp)
801074e0:	e8 51 ae ff ff       	call   80102336 <dirlink>
801074e5:	83 c4 10             	add    $0x10,%esp
801074e8:	85 c0                	test   %eax,%eax
801074ea:	78 1e                	js     8010750a <create+0x188>
801074ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ef:	8b 40 04             	mov    0x4(%eax),%eax
801074f2:	83 ec 04             	sub    $0x4,%esp
801074f5:	50                   	push   %eax
801074f6:	68 32 a3 10 80       	push   $0x8010a332
801074fb:	ff 75 f0             	pushl  -0x10(%ebp)
801074fe:	e8 33 ae ff ff       	call   80102336 <dirlink>
80107503:	83 c4 10             	add    $0x10,%esp
80107506:	85 c0                	test   %eax,%eax
80107508:	79 0d                	jns    80107517 <create+0x195>
      panic("create dots");
8010750a:	83 ec 0c             	sub    $0xc,%esp
8010750d:	68 65 a3 10 80       	push   $0x8010a365
80107512:	e8 4f 90 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80107517:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010751a:	8b 40 04             	mov    0x4(%eax),%eax
8010751d:	83 ec 04             	sub    $0x4,%esp
80107520:	50                   	push   %eax
80107521:	8d 45 de             	lea    -0x22(%ebp),%eax
80107524:	50                   	push   %eax
80107525:	ff 75 f4             	pushl  -0xc(%ebp)
80107528:	e8 09 ae ff ff       	call   80102336 <dirlink>
8010752d:	83 c4 10             	add    $0x10,%esp
80107530:	85 c0                	test   %eax,%eax
80107532:	79 0d                	jns    80107541 <create+0x1bf>
    panic("create: dirlink");
80107534:	83 ec 0c             	sub    $0xc,%esp
80107537:	68 71 a3 10 80       	push   $0x8010a371
8010753c:	e8 25 90 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80107541:	83 ec 0c             	sub    $0xc,%esp
80107544:	ff 75 f4             	pushl  -0xc(%ebp)
80107547:	e8 88 a7 ff ff       	call   80101cd4 <iunlockput>
8010754c:	83 c4 10             	add    $0x10,%esp

  return ip;
8010754f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107552:	c9                   	leave  
80107553:	c3                   	ret    

80107554 <sys_open>:

int
sys_open(void)
{
80107554:	55                   	push   %ebp
80107555:	89 e5                	mov    %esp,%ebp
80107557:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010755a:	83 ec 08             	sub    $0x8,%esp
8010755d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107560:	50                   	push   %eax
80107561:	6a 00                	push   $0x0
80107563:	e8 eb f6 ff ff       	call   80106c53 <argstr>
80107568:	83 c4 10             	add    $0x10,%esp
8010756b:	85 c0                	test   %eax,%eax
8010756d:	78 15                	js     80107584 <sys_open+0x30>
8010756f:	83 ec 08             	sub    $0x8,%esp
80107572:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107575:	50                   	push   %eax
80107576:	6a 01                	push   $0x1
80107578:	e8 51 f6 ff ff       	call   80106bce <argint>
8010757d:	83 c4 10             	add    $0x10,%esp
80107580:	85 c0                	test   %eax,%eax
80107582:	79 0a                	jns    8010758e <sys_open+0x3a>
    return -1;
80107584:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107589:	e9 61 01 00 00       	jmp    801076ef <sys_open+0x19b>

  begin_op();
8010758e:	e8 64 c0 ff ff       	call   801035f7 <begin_op>

  if(omode & O_CREATE){
80107593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107596:	25 00 02 00 00       	and    $0x200,%eax
8010759b:	85 c0                	test   %eax,%eax
8010759d:	74 2a                	je     801075c9 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010759f:	8b 45 e8             	mov    -0x18(%ebp),%eax
801075a2:	6a 00                	push   $0x0
801075a4:	6a 00                	push   $0x0
801075a6:	6a 02                	push   $0x2
801075a8:	50                   	push   %eax
801075a9:	e8 d4 fd ff ff       	call   80107382 <create>
801075ae:	83 c4 10             	add    $0x10,%esp
801075b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801075b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801075b8:	75 75                	jne    8010762f <sys_open+0xdb>
      end_op();
801075ba:	e8 c4 c0 ff ff       	call   80103683 <end_op>
      return -1;
801075bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075c4:	e9 26 01 00 00       	jmp    801076ef <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801075c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801075cc:	83 ec 0c             	sub    $0xc,%esp
801075cf:	50                   	push   %eax
801075d0:	e8 fd af ff ff       	call   801025d2 <namei>
801075d5:	83 c4 10             	add    $0x10,%esp
801075d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801075db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801075df:	75 0f                	jne    801075f0 <sys_open+0x9c>
      end_op();
801075e1:	e8 9d c0 ff ff       	call   80103683 <end_op>
      return -1;
801075e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075eb:	e9 ff 00 00 00       	jmp    801076ef <sys_open+0x19b>
    }
    ilock(ip);
801075f0:	83 ec 0c             	sub    $0xc,%esp
801075f3:	ff 75 f4             	pushl  -0xc(%ebp)
801075f6:	e8 19 a4 ff ff       	call   80101a14 <ilock>
801075fb:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801075fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107601:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107605:	66 83 f8 01          	cmp    $0x1,%ax
80107609:	75 24                	jne    8010762f <sys_open+0xdb>
8010760b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010760e:	85 c0                	test   %eax,%eax
80107610:	74 1d                	je     8010762f <sys_open+0xdb>
      iunlockput(ip);
80107612:	83 ec 0c             	sub    $0xc,%esp
80107615:	ff 75 f4             	pushl  -0xc(%ebp)
80107618:	e8 b7 a6 ff ff       	call   80101cd4 <iunlockput>
8010761d:	83 c4 10             	add    $0x10,%esp
      end_op();
80107620:	e8 5e c0 ff ff       	call   80103683 <end_op>
      return -1;
80107625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010762a:	e9 c0 00 00 00       	jmp    801076ef <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010762f:	e8 09 9a ff ff       	call   8010103d <filealloc>
80107634:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107637:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010763b:	74 17                	je     80107654 <sys_open+0x100>
8010763d:	83 ec 0c             	sub    $0xc,%esp
80107640:	ff 75 f0             	pushl  -0x10(%ebp)
80107643:	e8 37 f7 ff ff       	call   80106d7f <fdalloc>
80107648:	83 c4 10             	add    $0x10,%esp
8010764b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010764e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107652:	79 2e                	jns    80107682 <sys_open+0x12e>
    if(f)
80107654:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107658:	74 0e                	je     80107668 <sys_open+0x114>
      fileclose(f);
8010765a:	83 ec 0c             	sub    $0xc,%esp
8010765d:	ff 75 f0             	pushl  -0x10(%ebp)
80107660:	e8 96 9a ff ff       	call   801010fb <fileclose>
80107665:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107668:	83 ec 0c             	sub    $0xc,%esp
8010766b:	ff 75 f4             	pushl  -0xc(%ebp)
8010766e:	e8 61 a6 ff ff       	call   80101cd4 <iunlockput>
80107673:	83 c4 10             	add    $0x10,%esp
    end_op();
80107676:	e8 08 c0 ff ff       	call   80103683 <end_op>
    return -1;
8010767b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107680:	eb 6d                	jmp    801076ef <sys_open+0x19b>
  }
  iunlock(ip);
80107682:	83 ec 0c             	sub    $0xc,%esp
80107685:	ff 75 f4             	pushl  -0xc(%ebp)
80107688:	e8 e5 a4 ff ff       	call   80101b72 <iunlock>
8010768d:	83 c4 10             	add    $0x10,%esp
  end_op();
80107690:	e8 ee bf ff ff       	call   80103683 <end_op>

  f->type = FD_INODE;
80107695:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107698:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010769e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801076a4:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801076a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076aa:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801076b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076b4:	83 e0 01             	and    $0x1,%eax
801076b7:	85 c0                	test   %eax,%eax
801076b9:	0f 94 c0             	sete   %al
801076bc:	89 c2                	mov    %eax,%edx
801076be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076c1:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801076c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076c7:	83 e0 01             	and    $0x1,%eax
801076ca:	85 c0                	test   %eax,%eax
801076cc:	75 0a                	jne    801076d8 <sys_open+0x184>
801076ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076d1:	83 e0 02             	and    $0x2,%eax
801076d4:	85 c0                	test   %eax,%eax
801076d6:	74 07                	je     801076df <sys_open+0x18b>
801076d8:	b8 01 00 00 00       	mov    $0x1,%eax
801076dd:	eb 05                	jmp    801076e4 <sys_open+0x190>
801076df:	b8 00 00 00 00       	mov    $0x0,%eax
801076e4:	89 c2                	mov    %eax,%edx
801076e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076e9:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801076ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801076ef:	c9                   	leave  
801076f0:	c3                   	ret    

801076f1 <sys_mkdir>:

int
sys_mkdir(void)
{
801076f1:	55                   	push   %ebp
801076f2:	89 e5                	mov    %esp,%ebp
801076f4:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801076f7:	e8 fb be ff ff       	call   801035f7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801076fc:	83 ec 08             	sub    $0x8,%esp
801076ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107702:	50                   	push   %eax
80107703:	6a 00                	push   $0x0
80107705:	e8 49 f5 ff ff       	call   80106c53 <argstr>
8010770a:	83 c4 10             	add    $0x10,%esp
8010770d:	85 c0                	test   %eax,%eax
8010770f:	78 1b                	js     8010772c <sys_mkdir+0x3b>
80107711:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107714:	6a 00                	push   $0x0
80107716:	6a 00                	push   $0x0
80107718:	6a 01                	push   $0x1
8010771a:	50                   	push   %eax
8010771b:	e8 62 fc ff ff       	call   80107382 <create>
80107720:	83 c4 10             	add    $0x10,%esp
80107723:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107726:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010772a:	75 0c                	jne    80107738 <sys_mkdir+0x47>
    end_op();
8010772c:	e8 52 bf ff ff       	call   80103683 <end_op>
    return -1;
80107731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107736:	eb 18                	jmp    80107750 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107738:	83 ec 0c             	sub    $0xc,%esp
8010773b:	ff 75 f4             	pushl  -0xc(%ebp)
8010773e:	e8 91 a5 ff ff       	call   80101cd4 <iunlockput>
80107743:	83 c4 10             	add    $0x10,%esp
  end_op();
80107746:	e8 38 bf ff ff       	call   80103683 <end_op>
  return 0;
8010774b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107750:	c9                   	leave  
80107751:	c3                   	ret    

80107752 <sys_mknod>:

int
sys_mknod(void)
{
80107752:	55                   	push   %ebp
80107753:	89 e5                	mov    %esp,%ebp
80107755:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107758:	e8 9a be ff ff       	call   801035f7 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010775d:	83 ec 08             	sub    $0x8,%esp
80107760:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107763:	50                   	push   %eax
80107764:	6a 00                	push   $0x0
80107766:	e8 e8 f4 ff ff       	call   80106c53 <argstr>
8010776b:	83 c4 10             	add    $0x10,%esp
8010776e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107771:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107775:	78 4f                	js     801077c6 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107777:	83 ec 08             	sub    $0x8,%esp
8010777a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010777d:	50                   	push   %eax
8010777e:	6a 01                	push   $0x1
80107780:	e8 49 f4 ff ff       	call   80106bce <argint>
80107785:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107788:	85 c0                	test   %eax,%eax
8010778a:	78 3a                	js     801077c6 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010778c:	83 ec 08             	sub    $0x8,%esp
8010778f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107792:	50                   	push   %eax
80107793:	6a 02                	push   $0x2
80107795:	e8 34 f4 ff ff       	call   80106bce <argint>
8010779a:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010779d:	85 c0                	test   %eax,%eax
8010779f:	78 25                	js     801077c6 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801077a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077a4:	0f bf c8             	movswl %ax,%ecx
801077a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801077aa:	0f bf d0             	movswl %ax,%edx
801077ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801077b0:	51                   	push   %ecx
801077b1:	52                   	push   %edx
801077b2:	6a 03                	push   $0x3
801077b4:	50                   	push   %eax
801077b5:	e8 c8 fb ff ff       	call   80107382 <create>
801077ba:	83 c4 10             	add    $0x10,%esp
801077bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801077c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801077c4:	75 0c                	jne    801077d2 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801077c6:	e8 b8 be ff ff       	call   80103683 <end_op>
    return -1;
801077cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077d0:	eb 18                	jmp    801077ea <sys_mknod+0x98>
  }
  iunlockput(ip);
801077d2:	83 ec 0c             	sub    $0xc,%esp
801077d5:	ff 75 f0             	pushl  -0x10(%ebp)
801077d8:	e8 f7 a4 ff ff       	call   80101cd4 <iunlockput>
801077dd:	83 c4 10             	add    $0x10,%esp
  end_op();
801077e0:	e8 9e be ff ff       	call   80103683 <end_op>
  return 0;
801077e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801077ea:	c9                   	leave  
801077eb:	c3                   	ret    

801077ec <sys_chdir>:

int
sys_chdir(void)
{
801077ec:	55                   	push   %ebp
801077ed:	89 e5                	mov    %esp,%ebp
801077ef:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801077f2:	e8 00 be ff ff       	call   801035f7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801077f7:	83 ec 08             	sub    $0x8,%esp
801077fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801077fd:	50                   	push   %eax
801077fe:	6a 00                	push   $0x0
80107800:	e8 4e f4 ff ff       	call   80106c53 <argstr>
80107805:	83 c4 10             	add    $0x10,%esp
80107808:	85 c0                	test   %eax,%eax
8010780a:	78 18                	js     80107824 <sys_chdir+0x38>
8010780c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010780f:	83 ec 0c             	sub    $0xc,%esp
80107812:	50                   	push   %eax
80107813:	e8 ba ad ff ff       	call   801025d2 <namei>
80107818:	83 c4 10             	add    $0x10,%esp
8010781b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010781e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107822:	75 0c                	jne    80107830 <sys_chdir+0x44>
    end_op();
80107824:	e8 5a be ff ff       	call   80103683 <end_op>
    return -1;
80107829:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010782e:	eb 6e                	jmp    8010789e <sys_chdir+0xb2>
  }
  ilock(ip);
80107830:	83 ec 0c             	sub    $0xc,%esp
80107833:	ff 75 f4             	pushl  -0xc(%ebp)
80107836:	e8 d9 a1 ff ff       	call   80101a14 <ilock>
8010783b:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010783e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107841:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107845:	66 83 f8 01          	cmp    $0x1,%ax
80107849:	74 1a                	je     80107865 <sys_chdir+0x79>
    iunlockput(ip);
8010784b:	83 ec 0c             	sub    $0xc,%esp
8010784e:	ff 75 f4             	pushl  -0xc(%ebp)
80107851:	e8 7e a4 ff ff       	call   80101cd4 <iunlockput>
80107856:	83 c4 10             	add    $0x10,%esp
    end_op();
80107859:	e8 25 be ff ff       	call   80103683 <end_op>
    return -1;
8010785e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107863:	eb 39                	jmp    8010789e <sys_chdir+0xb2>
  }
  iunlock(ip);
80107865:	83 ec 0c             	sub    $0xc,%esp
80107868:	ff 75 f4             	pushl  -0xc(%ebp)
8010786b:	e8 02 a3 ff ff       	call   80101b72 <iunlock>
80107870:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107873:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107879:	8b 40 68             	mov    0x68(%eax),%eax
8010787c:	83 ec 0c             	sub    $0xc,%esp
8010787f:	50                   	push   %eax
80107880:	e8 5f a3 ff ff       	call   80101be4 <iput>
80107885:	83 c4 10             	add    $0x10,%esp
  end_op();
80107888:	e8 f6 bd ff ff       	call   80103683 <end_op>
  proc->cwd = ip;
8010788d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107893:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107896:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107899:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010789e:	c9                   	leave  
8010789f:	c3                   	ret    

801078a0 <sys_exec>:

int
sys_exec(void)
{
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801078a9:	83 ec 08             	sub    $0x8,%esp
801078ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
801078af:	50                   	push   %eax
801078b0:	6a 00                	push   $0x0
801078b2:	e8 9c f3 ff ff       	call   80106c53 <argstr>
801078b7:	83 c4 10             	add    $0x10,%esp
801078ba:	85 c0                	test   %eax,%eax
801078bc:	78 18                	js     801078d6 <sys_exec+0x36>
801078be:	83 ec 08             	sub    $0x8,%esp
801078c1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801078c7:	50                   	push   %eax
801078c8:	6a 01                	push   $0x1
801078ca:	e8 ff f2 ff ff       	call   80106bce <argint>
801078cf:	83 c4 10             	add    $0x10,%esp
801078d2:	85 c0                	test   %eax,%eax
801078d4:	79 0a                	jns    801078e0 <sys_exec+0x40>
    return -1;
801078d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078db:	e9 c6 00 00 00       	jmp    801079a6 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801078e0:	83 ec 04             	sub    $0x4,%esp
801078e3:	68 80 00 00 00       	push   $0x80
801078e8:	6a 00                	push   $0x0
801078ea:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801078f0:	50                   	push   %eax
801078f1:	e8 b3 ef ff ff       	call   801068a9 <memset>
801078f6:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801078f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107903:	83 f8 1f             	cmp    $0x1f,%eax
80107906:	76 0a                	jbe    80107912 <sys_exec+0x72>
      return -1;
80107908:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010790d:	e9 94 00 00 00       	jmp    801079a6 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107915:	c1 e0 02             	shl    $0x2,%eax
80107918:	89 c2                	mov    %eax,%edx
8010791a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107920:	01 c2                	add    %eax,%edx
80107922:	83 ec 08             	sub    $0x8,%esp
80107925:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010792b:	50                   	push   %eax
8010792c:	52                   	push   %edx
8010792d:	e8 00 f2 ff ff       	call   80106b32 <fetchint>
80107932:	83 c4 10             	add    $0x10,%esp
80107935:	85 c0                	test   %eax,%eax
80107937:	79 07                	jns    80107940 <sys_exec+0xa0>
      return -1;
80107939:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010793e:	eb 66                	jmp    801079a6 <sys_exec+0x106>
    if(uarg == 0){
80107940:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107946:	85 c0                	test   %eax,%eax
80107948:	75 27                	jne    80107971 <sys_exec+0xd1>
      argv[i] = 0;
8010794a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794d:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107954:	00 00 00 00 
      break;
80107958:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107959:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010795c:	83 ec 08             	sub    $0x8,%esp
8010795f:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107965:	52                   	push   %edx
80107966:	50                   	push   %eax
80107967:	e8 af 92 ff ff       	call   80100c1b <exec>
8010796c:	83 c4 10             	add    $0x10,%esp
8010796f:	eb 35                	jmp    801079a6 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107971:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107977:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010797a:	c1 e2 02             	shl    $0x2,%edx
8010797d:	01 c2                	add    %eax,%edx
8010797f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107985:	83 ec 08             	sub    $0x8,%esp
80107988:	52                   	push   %edx
80107989:	50                   	push   %eax
8010798a:	e8 dd f1 ff ff       	call   80106b6c <fetchstr>
8010798f:	83 c4 10             	add    $0x10,%esp
80107992:	85 c0                	test   %eax,%eax
80107994:	79 07                	jns    8010799d <sys_exec+0xfd>
      return -1;
80107996:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010799b:	eb 09                	jmp    801079a6 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010799d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801079a1:	e9 5a ff ff ff       	jmp    80107900 <sys_exec+0x60>
  return exec(path, argv);
}
801079a6:	c9                   	leave  
801079a7:	c3                   	ret    

801079a8 <sys_pipe>:

int
sys_pipe(void)
{
801079a8:	55                   	push   %ebp
801079a9:	89 e5                	mov    %esp,%ebp
801079ab:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801079ae:	83 ec 04             	sub    $0x4,%esp
801079b1:	6a 08                	push   $0x8
801079b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801079b6:	50                   	push   %eax
801079b7:	6a 00                	push   $0x0
801079b9:	e8 38 f2 ff ff       	call   80106bf6 <argptr>
801079be:	83 c4 10             	add    $0x10,%esp
801079c1:	85 c0                	test   %eax,%eax
801079c3:	79 0a                	jns    801079cf <sys_pipe+0x27>
    return -1;
801079c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079ca:	e9 af 00 00 00       	jmp    80107a7e <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801079cf:	83 ec 08             	sub    $0x8,%esp
801079d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801079d5:	50                   	push   %eax
801079d6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801079d9:	50                   	push   %eax
801079da:	e8 0c c7 ff ff       	call   801040eb <pipealloc>
801079df:	83 c4 10             	add    $0x10,%esp
801079e2:	85 c0                	test   %eax,%eax
801079e4:	79 0a                	jns    801079f0 <sys_pipe+0x48>
    return -1;
801079e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079eb:	e9 8e 00 00 00       	jmp    80107a7e <sys_pipe+0xd6>
  fd0 = -1;
801079f0:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801079f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801079fa:	83 ec 0c             	sub    $0xc,%esp
801079fd:	50                   	push   %eax
801079fe:	e8 7c f3 ff ff       	call   80106d7f <fdalloc>
80107a03:	83 c4 10             	add    $0x10,%esp
80107a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a0d:	78 18                	js     80107a27 <sys_pipe+0x7f>
80107a0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a12:	83 ec 0c             	sub    $0xc,%esp
80107a15:	50                   	push   %eax
80107a16:	e8 64 f3 ff ff       	call   80106d7f <fdalloc>
80107a1b:	83 c4 10             	add    $0x10,%esp
80107a1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a25:	79 3f                	jns    80107a66 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107a27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a2b:	78 14                	js     80107a41 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107a2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a36:	83 c2 08             	add    $0x8,%edx
80107a39:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107a40:	00 
    fileclose(rf);
80107a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107a44:	83 ec 0c             	sub    $0xc,%esp
80107a47:	50                   	push   %eax
80107a48:	e8 ae 96 ff ff       	call   801010fb <fileclose>
80107a4d:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a53:	83 ec 0c             	sub    $0xc,%esp
80107a56:	50                   	push   %eax
80107a57:	e8 9f 96 ff ff       	call   801010fb <fileclose>
80107a5c:	83 c4 10             	add    $0x10,%esp
    return -1;
80107a5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a64:	eb 18                	jmp    80107a7e <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a6c:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a71:	8d 50 04             	lea    0x4(%eax),%edx
80107a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a77:	89 02                	mov    %eax,(%edx)
  return 0;
80107a79:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107a7e:	c9                   	leave  
80107a7f:	c3                   	ret    

80107a80 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	83 ec 08             	sub    $0x8,%esp
80107a86:	8b 55 08             	mov    0x8(%ebp),%edx
80107a89:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a8c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107a90:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107a94:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107a98:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107a9c:	66 ef                	out    %ax,(%dx)
}
80107a9e:	90                   	nop
80107a9f:	c9                   	leave  
80107aa0:	c3                   	ret    

80107aa1 <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
80107aa1:	55                   	push   %ebp
80107aa2:	89 e5                	mov    %esp,%ebp
80107aa4:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107aa7:	e8 2b cf ff ff       	call   801049d7 <fork>
}
80107aac:	c9                   	leave  
80107aad:	c3                   	ret    

80107aae <sys_exit>:

int
sys_exit(void)
{
80107aae:	55                   	push   %ebp
80107aaf:	89 e5                	mov    %esp,%ebp
80107ab1:	83 ec 08             	sub    $0x8,%esp
  exit();
80107ab4:	e8 94 d1 ff ff       	call   80104c4d <exit>
  return 0;  // not reached
80107ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107abe:	c9                   	leave  
80107abf:	c3                   	ret    

80107ac0 <sys_wait>:

int
sys_wait(void)
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107ac6:	e8 5b d3 ff ff       	call   80104e26 <wait>
}
80107acb:	c9                   	leave  
80107acc:	c3                   	ret    

80107acd <sys_kill>:

int
sys_kill(void)
{
80107acd:	55                   	push   %ebp
80107ace:	89 e5                	mov    %esp,%ebp
80107ad0:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107ad3:	83 ec 08             	sub    $0x8,%esp
80107ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107ad9:	50                   	push   %eax
80107ada:	6a 00                	push   $0x0
80107adc:	e8 ed f0 ff ff       	call   80106bce <argint>
80107ae1:	83 c4 10             	add    $0x10,%esp
80107ae4:	85 c0                	test   %eax,%eax
80107ae6:	79 07                	jns    80107aef <sys_kill+0x22>
    return -1;
80107ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107aed:	eb 0f                	jmp    80107afe <sys_kill+0x31>
  return kill(pid);
80107aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af2:	83 ec 0c             	sub    $0xc,%esp
80107af5:	50                   	push   %eax
80107af6:	e8 cd da ff ff       	call   801055c8 <kill>
80107afb:	83 c4 10             	add    $0x10,%esp
}
80107afe:	c9                   	leave  
80107aff:	c3                   	ret    

80107b00 <sys_getpid>:

int
sys_getpid(void)
{
80107b00:	55                   	push   %ebp
80107b01:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107b03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b09:	8b 40 10             	mov    0x10(%eax),%eax
}
80107b0c:	5d                   	pop    %ebp
80107b0d:	c3                   	ret    

80107b0e <sys_sbrk>:

int
sys_sbrk(void)
{
80107b0e:	55                   	push   %ebp
80107b0f:	89 e5                	mov    %esp,%ebp
80107b11:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107b14:	83 ec 08             	sub    $0x8,%esp
80107b17:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107b1a:	50                   	push   %eax
80107b1b:	6a 00                	push   $0x0
80107b1d:	e8 ac f0 ff ff       	call   80106bce <argint>
80107b22:	83 c4 10             	add    $0x10,%esp
80107b25:	85 c0                	test   %eax,%eax
80107b27:	79 07                	jns    80107b30 <sys_sbrk+0x22>
    return -1;
80107b29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b2e:	eb 28                	jmp    80107b58 <sys_sbrk+0x4a>
  addr = proc->sz;
80107b30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b36:	8b 00                	mov    (%eax),%eax
80107b38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b3e:	83 ec 0c             	sub    $0xc,%esp
80107b41:	50                   	push   %eax
80107b42:	e8 ed cd ff ff       	call   80104934 <growproc>
80107b47:	83 c4 10             	add    $0x10,%esp
80107b4a:	85 c0                	test   %eax,%eax
80107b4c:	79 07                	jns    80107b55 <sys_sbrk+0x47>
    return -1;
80107b4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b53:	eb 03                	jmp    80107b58 <sys_sbrk+0x4a>
  return addr;
80107b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107b58:	c9                   	leave  
80107b59:	c3                   	ret    

80107b5a <sys_sleep>:

int
sys_sleep(void)
{
80107b5a:	55                   	push   %ebp
80107b5b:	89 e5                	mov    %esp,%ebp
80107b5d:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107b60:	83 ec 08             	sub    $0x8,%esp
80107b63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107b66:	50                   	push   %eax
80107b67:	6a 00                	push   $0x0
80107b69:	e8 60 f0 ff ff       	call   80106bce <argint>
80107b6e:	83 c4 10             	add    $0x10,%esp
80107b71:	85 c0                	test   %eax,%eax
80107b73:	79 07                	jns    80107b7c <sys_sleep+0x22>
    return -1;
80107b75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b7a:	eb 44                	jmp    80107bc0 <sys_sleep+0x66>
  ticks0 = ticks;
80107b7c:	a1 00 79 11 80       	mov    0x80117900,%eax
80107b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107b84:	eb 26                	jmp    80107bac <sys_sleep+0x52>
    if(proc->killed){
80107b86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b8c:	8b 40 24             	mov    0x24(%eax),%eax
80107b8f:	85 c0                	test   %eax,%eax
80107b91:	74 07                	je     80107b9a <sys_sleep+0x40>
      return -1;
80107b93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b98:	eb 26                	jmp    80107bc0 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107b9a:	83 ec 08             	sub    $0x8,%esp
80107b9d:	6a 00                	push   $0x0
80107b9f:	68 00 79 11 80       	push   $0x80117900
80107ba4:	e8 0f d8 ff ff       	call   801053b8 <sleep>
80107ba9:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107bac:	a1 00 79 11 80       	mov    0x80117900,%eax
80107bb1:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107bb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107bb7:	39 d0                	cmp    %edx,%eax
80107bb9:	72 cb                	jb     80107b86 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107bc0:	c9                   	leave  
80107bc1:	c3                   	ret    

80107bc2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80107bc2:	55                   	push   %ebp
80107bc3:	89 e5                	mov    %esp,%ebp
80107bc5:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107bc8:	a1 00 79 11 80       	mov    0x80117900,%eax
80107bcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107bd3:	c9                   	leave  
80107bd4:	c3                   	ret    

80107bd5 <sys_halt>:

//Turn of the computer
int sys_halt(void){
80107bd5:	55                   	push   %ebp
80107bd6:	89 e5                	mov    %esp,%ebp
80107bd8:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107bdb:	83 ec 0c             	sub    $0xc,%esp
80107bde:	68 81 a3 10 80       	push   $0x8010a381
80107be3:	e8 de 87 ff ff       	call   801003c6 <cprintf>
80107be8:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
80107beb:	83 ec 08             	sub    $0x8,%esp
80107bee:	68 00 20 00 00       	push   $0x2000
80107bf3:	68 04 06 00 00       	push   $0x604
80107bf8:	e8 83 fe ff ff       	call   80107a80 <outw>
80107bfd:	83 c4 10             	add    $0x10,%esp
  return 0;
80107c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c05:	c9                   	leave  
80107c06:	c3                   	ret    

80107c07 <sys_date>:

// My implementation of sys_date()
int
sys_date(void)
{
80107c07:	55                   	push   %ebp
80107c08:	89 e5                	mov    %esp,%ebp
80107c0a:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if (argptr(0, (void*)&d, sizeof(*d)) < 0)
80107c0d:	83 ec 04             	sub    $0x4,%esp
80107c10:	6a 18                	push   $0x18
80107c12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107c15:	50                   	push   %eax
80107c16:	6a 00                	push   $0x0
80107c18:	e8 d9 ef ff ff       	call   80106bf6 <argptr>
80107c1d:	83 c4 10             	add    $0x10,%esp
80107c20:	85 c0                	test   %eax,%eax
80107c22:	79 07                	jns    80107c2b <sys_date+0x24>
    return -1;
80107c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c29:	eb 14                	jmp    80107c3f <sys_date+0x38>
  // MY CODE HERE
  cmostime(d);       
80107c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2e:	83 ec 0c             	sub    $0xc,%esp
80107c31:	50                   	push   %eax
80107c32:	e8 3b b6 ff ff       	call   80103272 <cmostime>
80107c37:	83 c4 10             	add    $0x10,%esp
  return 0; 
80107c3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c3f:	c9                   	leave  
80107c40:	c3                   	ret    

80107c41 <sys_getuid>:

// My implementation of sys_getuid
uint
sys_getuid(void)
{
80107c41:	55                   	push   %ebp
80107c42:	89 e5                	mov    %esp,%ebp
  return proc->uid;
80107c44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c4a:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107c50:	5d                   	pop    %ebp
80107c51:	c3                   	ret    

80107c52 <sys_getgid>:

// My implementation of sys_getgid
uint
sys_getgid(void)
{
80107c52:	55                   	push   %ebp
80107c53:	89 e5                	mov    %esp,%ebp
  return proc->gid;
80107c55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c5b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107c61:	5d                   	pop    %ebp
80107c62:	c3                   	ret    

80107c63 <sys_getppid>:

// My implementation of sys_getppid
uint
sys_getppid(void)
{
80107c63:	55                   	push   %ebp
80107c64:	89 e5                	mov    %esp,%ebp
  return proc->parent ? proc->parent->pid : proc->pid;
80107c66:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c6c:	8b 40 14             	mov    0x14(%eax),%eax
80107c6f:	85 c0                	test   %eax,%eax
80107c71:	74 0e                	je     80107c81 <sys_getppid+0x1e>
80107c73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c79:	8b 40 14             	mov    0x14(%eax),%eax
80107c7c:	8b 40 10             	mov    0x10(%eax),%eax
80107c7f:	eb 09                	jmp    80107c8a <sys_getppid+0x27>
80107c81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c87:	8b 40 10             	mov    0x10(%eax),%eax
}
80107c8a:	5d                   	pop    %ebp
80107c8b:	c3                   	ret    

80107c8c <sys_setuid>:


// Implementation of sys_setuid
int 
sys_setuid(void)
{
80107c8c:	55                   	push   %ebp
80107c8d:	89 e5                	mov    %esp,%ebp
80107c8f:	83 ec 18             	sub    $0x18,%esp
  int id; // uid argument
  // Grab argument off the stack and store in id
  argint(0, &id);
80107c92:	83 ec 08             	sub    $0x8,%esp
80107c95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107c98:	50                   	push   %eax
80107c99:	6a 00                	push   $0x0
80107c9b:	e8 2e ef ff ff       	call   80106bce <argint>
80107ca0:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
80107ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca6:	85 c0                	test   %eax,%eax
80107ca8:	78 0a                	js     80107cb4 <sys_setuid+0x28>
80107caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cad:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107cb2:	7e 07                	jle    80107cbb <sys_setuid+0x2f>
    return -1;
80107cb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cb9:	eb 14                	jmp    80107ccf <sys_setuid+0x43>
  proc->uid = id; 
80107cbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107cc4:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80107cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ccf:	c9                   	leave  
80107cd0:	c3                   	ret    

80107cd1 <sys_setgid>:

// Implementation of sys_setgid
int
sys_setgid(void)
{
80107cd1:	55                   	push   %ebp
80107cd2:	89 e5                	mov    %esp,%ebp
80107cd4:	83 ec 18             	sub    $0x18,%esp
  int id; // gid argument 
  // Grab argument off the stack and store in id
  argint(0, &id);
80107cd7:	83 ec 08             	sub    $0x8,%esp
80107cda:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107cdd:	50                   	push   %eax
80107cde:	6a 00                	push   $0x0
80107ce0:	e8 e9 ee ff ff       	call   80106bce <argint>
80107ce5:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
80107ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ceb:	85 c0                	test   %eax,%eax
80107ced:	78 0a                	js     80107cf9 <sys_setgid+0x28>
80107cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf2:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107cf7:	7e 07                	jle    80107d00 <sys_setgid+0x2f>
    return -1;
80107cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cfe:	eb 14                	jmp    80107d14 <sys_setgid+0x43>
  proc->gid = id;
80107d00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107d09:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  return 0;
80107d0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d14:	c9                   	leave  
80107d15:	c3                   	ret    

80107d16 <sys_getprocs>:

// Implementation of sys_getprocs
int
sys_getprocs(void)
{
80107d16:	55                   	push   %ebp
80107d17:	89 e5                	mov    %esp,%ebp
80107d19:	83 ec 18             	sub    $0x18,%esp
  int m; // Max arg
  struct uproc* table;
  argint(0, &m);
80107d1c:	83 ec 08             	sub    $0x8,%esp
80107d1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d22:	50                   	push   %eax
80107d23:	6a 00                	push   $0x0
80107d25:	e8 a4 ee ff ff       	call   80106bce <argint>
80107d2a:	83 c4 10             	add    $0x10,%esp
  if (m < 0)
80107d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d30:	85 c0                	test   %eax,%eax
80107d32:	79 07                	jns    80107d3b <sys_getprocs+0x25>
    return -1;
80107d34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d39:	eb 28                	jmp    80107d63 <sys_getprocs+0x4d>
  argptr(1, (void*)&table, m);
80107d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3e:	83 ec 04             	sub    $0x4,%esp
80107d41:	50                   	push   %eax
80107d42:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d45:	50                   	push   %eax
80107d46:	6a 01                	push   $0x1
80107d48:	e8 a9 ee ff ff       	call   80106bf6 <argptr>
80107d4d:	83 c4 10             	add    $0x10,%esp
  return getproc_helper(m, table);
80107d50:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d56:	83 ec 08             	sub    $0x8,%esp
80107d59:	52                   	push   %edx
80107d5a:	50                   	push   %eax
80107d5b:	e8 b9 dc ff ff       	call   80105a19 <getproc_helper>
80107d60:	83 c4 10             	add    $0x10,%esp
}
80107d63:	c9                   	leave  
80107d64:	c3                   	ret    

80107d65 <sys_setpriority>:

#ifdef CS333_P3P4
// Implementation of sys_setpriority
int
sys_setpriority(void)
{
80107d65:	55                   	push   %ebp
80107d66:	89 e5                	mov    %esp,%ebp
80107d68:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int prio;

  argint(0, &pid);
80107d6b:	83 ec 08             	sub    $0x8,%esp
80107d6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d71:	50                   	push   %eax
80107d72:	6a 00                	push   $0x0
80107d74:	e8 55 ee ff ff       	call   80106bce <argint>
80107d79:	83 c4 10             	add    $0x10,%esp
  argint(1, &prio);
80107d7c:	83 ec 08             	sub    $0x8,%esp
80107d7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d82:	50                   	push   %eax
80107d83:	6a 01                	push   $0x1
80107d85:	e8 44 ee ff ff       	call   80106bce <argint>
80107d8a:	83 c4 10             	add    $0x10,%esp
  return set_priority(pid, prio);
80107d8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d93:	83 ec 08             	sub    $0x8,%esp
80107d96:	52                   	push   %edx
80107d97:	50                   	push   %eax
80107d98:	e8 30 e4 ff ff       	call   801061cd <set_priority>
80107d9d:	83 c4 10             	add    $0x10,%esp
}
80107da0:	c9                   	leave  
80107da1:	c3                   	ret    

80107da2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107da2:	55                   	push   %ebp
80107da3:	89 e5                	mov    %esp,%ebp
80107da5:	83 ec 08             	sub    $0x8,%esp
80107da8:	8b 55 08             	mov    0x8(%ebp),%edx
80107dab:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dae:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107db2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107db5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107db9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107dbd:	ee                   	out    %al,(%dx)
}
80107dbe:	90                   	nop
80107dbf:	c9                   	leave  
80107dc0:	c3                   	ret    

80107dc1 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80107dc1:	55                   	push   %ebp
80107dc2:	89 e5                	mov    %esp,%ebp
80107dc4:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107dc7:	6a 34                	push   $0x34
80107dc9:	6a 43                	push   $0x43
80107dcb:	e8 d2 ff ff ff       	call   80107da2 <outb>
80107dd0:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107dd3:	68 9c 00 00 00       	push   $0x9c
80107dd8:	6a 40                	push   $0x40
80107dda:	e8 c3 ff ff ff       	call   80107da2 <outb>
80107ddf:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80107de2:	6a 2e                	push   $0x2e
80107de4:	6a 40                	push   $0x40
80107de6:	e8 b7 ff ff ff       	call   80107da2 <outb>
80107deb:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80107dee:	83 ec 0c             	sub    $0xc,%esp
80107df1:	6a 00                	push   $0x0
80107df3:	e8 dd c1 ff ff       	call   80103fd5 <picenable>
80107df8:	83 c4 10             	add    $0x10,%esp
}
80107dfb:	90                   	nop
80107dfc:	c9                   	leave  
80107dfd:	c3                   	ret    

80107dfe <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107dfe:	1e                   	push   %ds
  pushl %es
80107dff:	06                   	push   %es
  pushl %fs
80107e00:	0f a0                	push   %fs
  pushl %gs
80107e02:	0f a8                	push   %gs
  pushal
80107e04:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107e05:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107e09:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107e0b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107e0d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107e11:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107e13:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107e15:	54                   	push   %esp
  call trap
80107e16:	e8 ce 01 00 00       	call   80107fe9 <trap>
  addl $4, %esp
80107e1b:	83 c4 04             	add    $0x4,%esp

80107e1e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107e1e:	61                   	popa   
  popl %gs
80107e1f:	0f a9                	pop    %gs
  popl %fs
80107e21:	0f a1                	pop    %fs
  popl %es
80107e23:	07                   	pop    %es
  popl %ds
80107e24:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107e25:	83 c4 08             	add    $0x8,%esp
  iret
80107e28:	cf                   	iret   

80107e29 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80107e29:	55                   	push   %ebp
80107e2a:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80107e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80107e2f:	f0 ff 00             	lock incl (%eax)
}
80107e32:	90                   	nop
80107e33:	5d                   	pop    %ebp
80107e34:	c3                   	ret    

80107e35 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107e35:	55                   	push   %ebp
80107e36:	89 e5                	mov    %esp,%ebp
80107e38:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e3e:	83 e8 01             	sub    $0x1,%eax
80107e41:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107e45:	8b 45 08             	mov    0x8(%ebp),%eax
80107e48:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80107e4f:	c1 e8 10             	shr    $0x10,%eax
80107e52:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107e56:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107e59:	0f 01 18             	lidtl  (%eax)
}
80107e5c:	90                   	nop
80107e5d:	c9                   	leave  
80107e5e:	c3                   	ret    

80107e5f <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80107e5f:	55                   	push   %ebp
80107e60:	89 e5                	mov    %esp,%ebp
80107e62:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107e65:	0f 20 d0             	mov    %cr2,%eax
80107e68:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107e6e:	c9                   	leave  
80107e6f:	c3                   	ret    

80107e70 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107e7d:	e9 c3 00 00 00       	jmp    80107f45 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107e85:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
80107e8c:	89 c2                	mov    %eax,%edx
80107e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107e91:	66 89 14 c5 00 71 11 	mov    %dx,-0x7fee8f00(,%eax,8)
80107e98:	80 
80107e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107e9c:	66 c7 04 c5 02 71 11 	movw   $0x8,-0x7fee8efe(,%eax,8)
80107ea3:	80 08 00 
80107ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ea9:	0f b6 14 c5 04 71 11 	movzbl -0x7fee8efc(,%eax,8),%edx
80107eb0:	80 
80107eb1:	83 e2 e0             	and    $0xffffffe0,%edx
80107eb4:	88 14 c5 04 71 11 80 	mov    %dl,-0x7fee8efc(,%eax,8)
80107ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ebe:	0f b6 14 c5 04 71 11 	movzbl -0x7fee8efc(,%eax,8),%edx
80107ec5:	80 
80107ec6:	83 e2 1f             	and    $0x1f,%edx
80107ec9:	88 14 c5 04 71 11 80 	mov    %dl,-0x7fee8efc(,%eax,8)
80107ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ed3:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107eda:	80 
80107edb:	83 e2 f0             	and    $0xfffffff0,%edx
80107ede:	83 ca 0e             	or     $0xe,%edx
80107ee1:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107eeb:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107ef2:	80 
80107ef3:	83 e2 ef             	and    $0xffffffef,%edx
80107ef6:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107efd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f00:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107f07:	80 
80107f08:	83 e2 9f             	and    $0xffffff9f,%edx
80107f0b:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f15:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107f1c:	80 
80107f1d:	83 ca 80             	or     $0xffffff80,%edx
80107f20:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f2a:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
80107f31:	c1 e8 10             	shr    $0x10,%eax
80107f34:	89 c2                	mov    %eax,%edx
80107f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f39:	66 89 14 c5 06 71 11 	mov    %dx,-0x7fee8efa(,%eax,8)
80107f40:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107f41:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107f45:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107f4c:	0f 8e 30 ff ff ff    	jle    80107e82 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107f52:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107f57:	66 a3 00 73 11 80    	mov    %ax,0x80117300
80107f5d:	66 c7 05 02 73 11 80 	movw   $0x8,0x80117302
80107f64:	08 00 
80107f66:	0f b6 05 04 73 11 80 	movzbl 0x80117304,%eax
80107f6d:	83 e0 e0             	and    $0xffffffe0,%eax
80107f70:	a2 04 73 11 80       	mov    %al,0x80117304
80107f75:	0f b6 05 04 73 11 80 	movzbl 0x80117304,%eax
80107f7c:	83 e0 1f             	and    $0x1f,%eax
80107f7f:	a2 04 73 11 80       	mov    %al,0x80117304
80107f84:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107f8b:	83 c8 0f             	or     $0xf,%eax
80107f8e:	a2 05 73 11 80       	mov    %al,0x80117305
80107f93:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107f9a:	83 e0 ef             	and    $0xffffffef,%eax
80107f9d:	a2 05 73 11 80       	mov    %al,0x80117305
80107fa2:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107fa9:	83 c8 60             	or     $0x60,%eax
80107fac:	a2 05 73 11 80       	mov    %al,0x80117305
80107fb1:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107fb8:	83 c8 80             	or     $0xffffff80,%eax
80107fbb:	a2 05 73 11 80       	mov    %al,0x80117305
80107fc0:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107fc5:	c1 e8 10             	shr    $0x10,%eax
80107fc8:	66 a3 06 73 11 80    	mov    %ax,0x80117306
  
}
80107fce:	90                   	nop
80107fcf:	c9                   	leave  
80107fd0:	c3                   	ret    

80107fd1 <idtinit>:

void
idtinit(void)
{
80107fd1:	55                   	push   %ebp
80107fd2:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107fd4:	68 00 08 00 00       	push   $0x800
80107fd9:	68 00 71 11 80       	push   $0x80117100
80107fde:	e8 52 fe ff ff       	call   80107e35 <lidt>
80107fe3:	83 c4 08             	add    $0x8,%esp
}
80107fe6:	90                   	nop
80107fe7:	c9                   	leave  
80107fe8:	c3                   	ret    

80107fe9 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107fe9:	55                   	push   %ebp
80107fea:	89 e5                	mov    %esp,%ebp
80107fec:	57                   	push   %edi
80107fed:	56                   	push   %esi
80107fee:	53                   	push   %ebx
80107fef:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ff5:	8b 40 30             	mov    0x30(%eax),%eax
80107ff8:	83 f8 40             	cmp    $0x40,%eax
80107ffb:	75 3e                	jne    8010803b <trap+0x52>
    if(proc->killed)
80107ffd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108003:	8b 40 24             	mov    0x24(%eax),%eax
80108006:	85 c0                	test   %eax,%eax
80108008:	74 05                	je     8010800f <trap+0x26>
      exit();
8010800a:	e8 3e cc ff ff       	call   80104c4d <exit>
    proc->tf = tf;
8010800f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108015:	8b 55 08             	mov    0x8(%ebp),%edx
80108018:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010801b:	e8 64 ec ff ff       	call   80106c84 <syscall>
    if(proc->killed)
80108020:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108026:	8b 40 24             	mov    0x24(%eax),%eax
80108029:	85 c0                	test   %eax,%eax
8010802b:	0f 84 fe 01 00 00    	je     8010822f <trap+0x246>
      exit();
80108031:	e8 17 cc ff ff       	call   80104c4d <exit>
    return;
80108036:	e9 f4 01 00 00       	jmp    8010822f <trap+0x246>
  }

  switch(tf->trapno){
8010803b:	8b 45 08             	mov    0x8(%ebp),%eax
8010803e:	8b 40 30             	mov    0x30(%eax),%eax
80108041:	83 e8 20             	sub    $0x20,%eax
80108044:	83 f8 1f             	cmp    $0x1f,%eax
80108047:	0f 87 a3 00 00 00    	ja     801080f0 <trap+0x107>
8010804d:	8b 04 85 34 a4 10 80 	mov    -0x7fef5bcc(,%eax,4),%eax
80108054:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80108056:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010805c:	0f b6 00             	movzbl (%eax),%eax
8010805f:	84 c0                	test   %al,%al
80108061:	75 20                	jne    80108083 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80108063:	83 ec 0c             	sub    $0xc,%esp
80108066:	68 00 79 11 80       	push   $0x80117900
8010806b:	e8 b9 fd ff ff       	call   80107e29 <atom_inc>
80108070:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80108073:	83 ec 0c             	sub    $0xc,%esp
80108076:	68 00 79 11 80       	push   $0x80117900
8010807b:	e8 11 d5 ff ff       	call   80105591 <wakeup>
80108080:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80108083:	e8 47 b0 ff ff       	call   801030cf <lapiceoi>
    break;
80108088:	e9 1c 01 00 00       	jmp    801081a9 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010808d:	e8 50 a8 ff ff       	call   801028e2 <ideintr>
    lapiceoi();
80108092:	e8 38 b0 ff ff       	call   801030cf <lapiceoi>
    break;
80108097:	e9 0d 01 00 00       	jmp    801081a9 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010809c:	e8 30 ae ff ff       	call   80102ed1 <kbdintr>
    lapiceoi();
801080a1:	e8 29 b0 ff ff       	call   801030cf <lapiceoi>
    break;
801080a6:	e9 fe 00 00 00       	jmp    801081a9 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801080ab:	e8 60 03 00 00       	call   80108410 <uartintr>
    lapiceoi();
801080b0:	e8 1a b0 ff ff       	call   801030cf <lapiceoi>
    break;
801080b5:	e9 ef 00 00 00       	jmp    801081a9 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801080ba:	8b 45 08             	mov    0x8(%ebp),%eax
801080bd:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801080c0:	8b 45 08             	mov    0x8(%ebp),%eax
801080c3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801080c7:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801080ca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801080d0:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801080d3:	0f b6 c0             	movzbl %al,%eax
801080d6:	51                   	push   %ecx
801080d7:	52                   	push   %edx
801080d8:	50                   	push   %eax
801080d9:	68 94 a3 10 80       	push   $0x8010a394
801080de:	e8 e3 82 ff ff       	call   801003c6 <cprintf>
801080e3:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801080e6:	e8 e4 af ff ff       	call   801030cf <lapiceoi>
    break;
801080eb:	e9 b9 00 00 00       	jmp    801081a9 <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801080f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801080f6:	85 c0                	test   %eax,%eax
801080f8:	74 11                	je     8010810b <trap+0x122>
801080fa:	8b 45 08             	mov    0x8(%ebp),%eax
801080fd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108101:	0f b7 c0             	movzwl %ax,%eax
80108104:	83 e0 03             	and    $0x3,%eax
80108107:	85 c0                	test   %eax,%eax
80108109:	75 40                	jne    8010814b <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010810b:	e8 4f fd ff ff       	call   80107e5f <rcr2>
80108110:	89 c3                	mov    %eax,%ebx
80108112:	8b 45 08             	mov    0x8(%ebp),%eax
80108115:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80108118:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010811e:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80108121:	0f b6 d0             	movzbl %al,%edx
80108124:	8b 45 08             	mov    0x8(%ebp),%eax
80108127:	8b 40 30             	mov    0x30(%eax),%eax
8010812a:	83 ec 0c             	sub    $0xc,%esp
8010812d:	53                   	push   %ebx
8010812e:	51                   	push   %ecx
8010812f:	52                   	push   %edx
80108130:	50                   	push   %eax
80108131:	68 b8 a3 10 80       	push   $0x8010a3b8
80108136:	e8 8b 82 ff ff       	call   801003c6 <cprintf>
8010813b:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010813e:	83 ec 0c             	sub    $0xc,%esp
80108141:	68 ea a3 10 80       	push   $0x8010a3ea
80108146:	e8 1b 84 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010814b:	e8 0f fd ff ff       	call   80107e5f <rcr2>
80108150:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108153:	8b 45 08             	mov    0x8(%ebp),%eax
80108156:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80108159:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010815f:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108162:	0f b6 d8             	movzbl %al,%ebx
80108165:	8b 45 08             	mov    0x8(%ebp),%eax
80108168:	8b 48 34             	mov    0x34(%eax),%ecx
8010816b:	8b 45 08             	mov    0x8(%ebp),%eax
8010816e:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80108171:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108177:	8d 78 6c             	lea    0x6c(%eax),%edi
8010817a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108180:	8b 40 10             	mov    0x10(%eax),%eax
80108183:	ff 75 e4             	pushl  -0x1c(%ebp)
80108186:	56                   	push   %esi
80108187:	53                   	push   %ebx
80108188:	51                   	push   %ecx
80108189:	52                   	push   %edx
8010818a:	57                   	push   %edi
8010818b:	50                   	push   %eax
8010818c:	68 f0 a3 10 80       	push   $0x8010a3f0
80108191:	e8 30 82 ff ff       	call   801003c6 <cprintf>
80108196:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80108199:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010819f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801081a6:	eb 01                	jmp    801081a9 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801081a8:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801081a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801081af:	85 c0                	test   %eax,%eax
801081b1:	74 24                	je     801081d7 <trap+0x1ee>
801081b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801081b9:	8b 40 24             	mov    0x24(%eax),%eax
801081bc:	85 c0                	test   %eax,%eax
801081be:	74 17                	je     801081d7 <trap+0x1ee>
801081c0:	8b 45 08             	mov    0x8(%ebp),%eax
801081c3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801081c7:	0f b7 c0             	movzwl %ax,%eax
801081ca:	83 e0 03             	and    $0x3,%eax
801081cd:	83 f8 03             	cmp    $0x3,%eax
801081d0:	75 05                	jne    801081d7 <trap+0x1ee>
    exit();
801081d2:	e8 76 ca ff ff       	call   80104c4d <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801081d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801081dd:	85 c0                	test   %eax,%eax
801081df:	74 1e                	je     801081ff <trap+0x216>
801081e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801081e7:	8b 40 0c             	mov    0xc(%eax),%eax
801081ea:	83 f8 04             	cmp    $0x4,%eax
801081ed:	75 10                	jne    801081ff <trap+0x216>
801081ef:	8b 45 08             	mov    0x8(%ebp),%eax
801081f2:	8b 40 30             	mov    0x30(%eax),%eax
801081f5:	83 f8 20             	cmp    $0x20,%eax
801081f8:	75 05                	jne    801081ff <trap+0x216>
    yield();
801081fa:	e8 76 d0 ff ff       	call   80105275 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801081ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108205:	85 c0                	test   %eax,%eax
80108207:	74 27                	je     80108230 <trap+0x247>
80108209:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010820f:	8b 40 24             	mov    0x24(%eax),%eax
80108212:	85 c0                	test   %eax,%eax
80108214:	74 1a                	je     80108230 <trap+0x247>
80108216:	8b 45 08             	mov    0x8(%ebp),%eax
80108219:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010821d:	0f b7 c0             	movzwl %ax,%eax
80108220:	83 e0 03             	and    $0x3,%eax
80108223:	83 f8 03             	cmp    $0x3,%eax
80108226:	75 08                	jne    80108230 <trap+0x247>
    exit();
80108228:	e8 20 ca ff ff       	call   80104c4d <exit>
8010822d:	eb 01                	jmp    80108230 <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
8010822f:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80108230:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108233:	5b                   	pop    %ebx
80108234:	5e                   	pop    %esi
80108235:	5f                   	pop    %edi
80108236:	5d                   	pop    %ebp
80108237:	c3                   	ret    

80108238 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80108238:	55                   	push   %ebp
80108239:	89 e5                	mov    %esp,%ebp
8010823b:	83 ec 14             	sub    $0x14,%esp
8010823e:	8b 45 08             	mov    0x8(%ebp),%eax
80108241:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80108245:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80108249:	89 c2                	mov    %eax,%edx
8010824b:	ec                   	in     (%dx),%al
8010824c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010824f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80108253:	c9                   	leave  
80108254:	c3                   	ret    

80108255 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80108255:	55                   	push   %ebp
80108256:	89 e5                	mov    %esp,%ebp
80108258:	83 ec 08             	sub    $0x8,%esp
8010825b:	8b 55 08             	mov    0x8(%ebp),%edx
8010825e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108261:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80108265:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108268:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010826c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108270:	ee                   	out    %al,(%dx)
}
80108271:	90                   	nop
80108272:	c9                   	leave  
80108273:	c3                   	ret    

80108274 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80108274:	55                   	push   %ebp
80108275:	89 e5                	mov    %esp,%ebp
80108277:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010827a:	6a 00                	push   $0x0
8010827c:	68 fa 03 00 00       	push   $0x3fa
80108281:	e8 cf ff ff ff       	call   80108255 <outb>
80108286:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80108289:	68 80 00 00 00       	push   $0x80
8010828e:	68 fb 03 00 00       	push   $0x3fb
80108293:	e8 bd ff ff ff       	call   80108255 <outb>
80108298:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010829b:	6a 0c                	push   $0xc
8010829d:	68 f8 03 00 00       	push   $0x3f8
801082a2:	e8 ae ff ff ff       	call   80108255 <outb>
801082a7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801082aa:	6a 00                	push   $0x0
801082ac:	68 f9 03 00 00       	push   $0x3f9
801082b1:	e8 9f ff ff ff       	call   80108255 <outb>
801082b6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801082b9:	6a 03                	push   $0x3
801082bb:	68 fb 03 00 00       	push   $0x3fb
801082c0:	e8 90 ff ff ff       	call   80108255 <outb>
801082c5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801082c8:	6a 00                	push   $0x0
801082ca:	68 fc 03 00 00       	push   $0x3fc
801082cf:	e8 81 ff ff ff       	call   80108255 <outb>
801082d4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801082d7:	6a 01                	push   $0x1
801082d9:	68 f9 03 00 00       	push   $0x3f9
801082de:	e8 72 ff ff ff       	call   80108255 <outb>
801082e3:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801082e6:	68 fd 03 00 00       	push   $0x3fd
801082eb:	e8 48 ff ff ff       	call   80108238 <inb>
801082f0:	83 c4 04             	add    $0x4,%esp
801082f3:	3c ff                	cmp    $0xff,%al
801082f5:	74 6e                	je     80108365 <uartinit+0xf1>
    return;
  uart = 1;
801082f7:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
801082fe:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80108301:	68 fa 03 00 00       	push   $0x3fa
80108306:	e8 2d ff ff ff       	call   80108238 <inb>
8010830b:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010830e:	68 f8 03 00 00       	push   $0x3f8
80108313:	e8 20 ff ff ff       	call   80108238 <inb>
80108318:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010831b:	83 ec 0c             	sub    $0xc,%esp
8010831e:	6a 04                	push   $0x4
80108320:	e8 b0 bc ff ff       	call   80103fd5 <picenable>
80108325:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80108328:	83 ec 08             	sub    $0x8,%esp
8010832b:	6a 00                	push   $0x0
8010832d:	6a 04                	push   $0x4
8010832f:	e8 50 a8 ff ff       	call   80102b84 <ioapicenable>
80108334:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108337:	c7 45 f4 b4 a4 10 80 	movl   $0x8010a4b4,-0xc(%ebp)
8010833e:	eb 19                	jmp    80108359 <uartinit+0xe5>
    uartputc(*p);
80108340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108343:	0f b6 00             	movzbl (%eax),%eax
80108346:	0f be c0             	movsbl %al,%eax
80108349:	83 ec 0c             	sub    $0xc,%esp
8010834c:	50                   	push   %eax
8010834d:	e8 16 00 00 00       	call   80108368 <uartputc>
80108352:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108355:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835c:	0f b6 00             	movzbl (%eax),%eax
8010835f:	84 c0                	test   %al,%al
80108361:	75 dd                	jne    80108340 <uartinit+0xcc>
80108363:	eb 01                	jmp    80108366 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80108365:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80108366:	c9                   	leave  
80108367:	c3                   	ret    

80108368 <uartputc>:

void
uartputc(int c)
{
80108368:	55                   	push   %ebp
80108369:	89 e5                	mov    %esp,%ebp
8010836b:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010836e:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80108373:	85 c0                	test   %eax,%eax
80108375:	74 53                	je     801083ca <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010837e:	eb 11                	jmp    80108391 <uartputc+0x29>
    microdelay(10);
80108380:	83 ec 0c             	sub    $0xc,%esp
80108383:	6a 0a                	push   $0xa
80108385:	e8 60 ad ff ff       	call   801030ea <microdelay>
8010838a:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010838d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108391:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108395:	7f 1a                	jg     801083b1 <uartputc+0x49>
80108397:	83 ec 0c             	sub    $0xc,%esp
8010839a:	68 fd 03 00 00       	push   $0x3fd
8010839f:	e8 94 fe ff ff       	call   80108238 <inb>
801083a4:	83 c4 10             	add    $0x10,%esp
801083a7:	0f b6 c0             	movzbl %al,%eax
801083aa:	83 e0 20             	and    $0x20,%eax
801083ad:	85 c0                	test   %eax,%eax
801083af:	74 cf                	je     80108380 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801083b1:	8b 45 08             	mov    0x8(%ebp),%eax
801083b4:	0f b6 c0             	movzbl %al,%eax
801083b7:	83 ec 08             	sub    $0x8,%esp
801083ba:	50                   	push   %eax
801083bb:	68 f8 03 00 00       	push   $0x3f8
801083c0:	e8 90 fe ff ff       	call   80108255 <outb>
801083c5:	83 c4 10             	add    $0x10,%esp
801083c8:	eb 01                	jmp    801083cb <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801083ca:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801083cb:	c9                   	leave  
801083cc:	c3                   	ret    

801083cd <uartgetc>:

static int
uartgetc(void)
{
801083cd:	55                   	push   %ebp
801083ce:	89 e5                	mov    %esp,%ebp
  if(!uart)
801083d0:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
801083d5:	85 c0                	test   %eax,%eax
801083d7:	75 07                	jne    801083e0 <uartgetc+0x13>
    return -1;
801083d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083de:	eb 2e                	jmp    8010840e <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801083e0:	68 fd 03 00 00       	push   $0x3fd
801083e5:	e8 4e fe ff ff       	call   80108238 <inb>
801083ea:	83 c4 04             	add    $0x4,%esp
801083ed:	0f b6 c0             	movzbl %al,%eax
801083f0:	83 e0 01             	and    $0x1,%eax
801083f3:	85 c0                	test   %eax,%eax
801083f5:	75 07                	jne    801083fe <uartgetc+0x31>
    return -1;
801083f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083fc:	eb 10                	jmp    8010840e <uartgetc+0x41>
  return inb(COM1+0);
801083fe:	68 f8 03 00 00       	push   $0x3f8
80108403:	e8 30 fe ff ff       	call   80108238 <inb>
80108408:	83 c4 04             	add    $0x4,%esp
8010840b:	0f b6 c0             	movzbl %al,%eax
}
8010840e:	c9                   	leave  
8010840f:	c3                   	ret    

80108410 <uartintr>:

void
uartintr(void)
{
80108410:	55                   	push   %ebp
80108411:	89 e5                	mov    %esp,%ebp
80108413:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80108416:	83 ec 0c             	sub    $0xc,%esp
80108419:	68 cd 83 10 80       	push   $0x801083cd
8010841e:	e8 d6 83 ff ff       	call   801007f9 <consoleintr>
80108423:	83 c4 10             	add    $0x10,%esp
}
80108426:	90                   	nop
80108427:	c9                   	leave  
80108428:	c3                   	ret    

80108429 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80108429:	6a 00                	push   $0x0
  pushl $0
8010842b:	6a 00                	push   $0x0
  jmp alltraps
8010842d:	e9 cc f9 ff ff       	jmp    80107dfe <alltraps>

80108432 <vector1>:
.globl vector1
vector1:
  pushl $0
80108432:	6a 00                	push   $0x0
  pushl $1
80108434:	6a 01                	push   $0x1
  jmp alltraps
80108436:	e9 c3 f9 ff ff       	jmp    80107dfe <alltraps>

8010843b <vector2>:
.globl vector2
vector2:
  pushl $0
8010843b:	6a 00                	push   $0x0
  pushl $2
8010843d:	6a 02                	push   $0x2
  jmp alltraps
8010843f:	e9 ba f9 ff ff       	jmp    80107dfe <alltraps>

80108444 <vector3>:
.globl vector3
vector3:
  pushl $0
80108444:	6a 00                	push   $0x0
  pushl $3
80108446:	6a 03                	push   $0x3
  jmp alltraps
80108448:	e9 b1 f9 ff ff       	jmp    80107dfe <alltraps>

8010844d <vector4>:
.globl vector4
vector4:
  pushl $0
8010844d:	6a 00                	push   $0x0
  pushl $4
8010844f:	6a 04                	push   $0x4
  jmp alltraps
80108451:	e9 a8 f9 ff ff       	jmp    80107dfe <alltraps>

80108456 <vector5>:
.globl vector5
vector5:
  pushl $0
80108456:	6a 00                	push   $0x0
  pushl $5
80108458:	6a 05                	push   $0x5
  jmp alltraps
8010845a:	e9 9f f9 ff ff       	jmp    80107dfe <alltraps>

8010845f <vector6>:
.globl vector6
vector6:
  pushl $0
8010845f:	6a 00                	push   $0x0
  pushl $6
80108461:	6a 06                	push   $0x6
  jmp alltraps
80108463:	e9 96 f9 ff ff       	jmp    80107dfe <alltraps>

80108468 <vector7>:
.globl vector7
vector7:
  pushl $0
80108468:	6a 00                	push   $0x0
  pushl $7
8010846a:	6a 07                	push   $0x7
  jmp alltraps
8010846c:	e9 8d f9 ff ff       	jmp    80107dfe <alltraps>

80108471 <vector8>:
.globl vector8
vector8:
  pushl $8
80108471:	6a 08                	push   $0x8
  jmp alltraps
80108473:	e9 86 f9 ff ff       	jmp    80107dfe <alltraps>

80108478 <vector9>:
.globl vector9
vector9:
  pushl $0
80108478:	6a 00                	push   $0x0
  pushl $9
8010847a:	6a 09                	push   $0x9
  jmp alltraps
8010847c:	e9 7d f9 ff ff       	jmp    80107dfe <alltraps>

80108481 <vector10>:
.globl vector10
vector10:
  pushl $10
80108481:	6a 0a                	push   $0xa
  jmp alltraps
80108483:	e9 76 f9 ff ff       	jmp    80107dfe <alltraps>

80108488 <vector11>:
.globl vector11
vector11:
  pushl $11
80108488:	6a 0b                	push   $0xb
  jmp alltraps
8010848a:	e9 6f f9 ff ff       	jmp    80107dfe <alltraps>

8010848f <vector12>:
.globl vector12
vector12:
  pushl $12
8010848f:	6a 0c                	push   $0xc
  jmp alltraps
80108491:	e9 68 f9 ff ff       	jmp    80107dfe <alltraps>

80108496 <vector13>:
.globl vector13
vector13:
  pushl $13
80108496:	6a 0d                	push   $0xd
  jmp alltraps
80108498:	e9 61 f9 ff ff       	jmp    80107dfe <alltraps>

8010849d <vector14>:
.globl vector14
vector14:
  pushl $14
8010849d:	6a 0e                	push   $0xe
  jmp alltraps
8010849f:	e9 5a f9 ff ff       	jmp    80107dfe <alltraps>

801084a4 <vector15>:
.globl vector15
vector15:
  pushl $0
801084a4:	6a 00                	push   $0x0
  pushl $15
801084a6:	6a 0f                	push   $0xf
  jmp alltraps
801084a8:	e9 51 f9 ff ff       	jmp    80107dfe <alltraps>

801084ad <vector16>:
.globl vector16
vector16:
  pushl $0
801084ad:	6a 00                	push   $0x0
  pushl $16
801084af:	6a 10                	push   $0x10
  jmp alltraps
801084b1:	e9 48 f9 ff ff       	jmp    80107dfe <alltraps>

801084b6 <vector17>:
.globl vector17
vector17:
  pushl $17
801084b6:	6a 11                	push   $0x11
  jmp alltraps
801084b8:	e9 41 f9 ff ff       	jmp    80107dfe <alltraps>

801084bd <vector18>:
.globl vector18
vector18:
  pushl $0
801084bd:	6a 00                	push   $0x0
  pushl $18
801084bf:	6a 12                	push   $0x12
  jmp alltraps
801084c1:	e9 38 f9 ff ff       	jmp    80107dfe <alltraps>

801084c6 <vector19>:
.globl vector19
vector19:
  pushl $0
801084c6:	6a 00                	push   $0x0
  pushl $19
801084c8:	6a 13                	push   $0x13
  jmp alltraps
801084ca:	e9 2f f9 ff ff       	jmp    80107dfe <alltraps>

801084cf <vector20>:
.globl vector20
vector20:
  pushl $0
801084cf:	6a 00                	push   $0x0
  pushl $20
801084d1:	6a 14                	push   $0x14
  jmp alltraps
801084d3:	e9 26 f9 ff ff       	jmp    80107dfe <alltraps>

801084d8 <vector21>:
.globl vector21
vector21:
  pushl $0
801084d8:	6a 00                	push   $0x0
  pushl $21
801084da:	6a 15                	push   $0x15
  jmp alltraps
801084dc:	e9 1d f9 ff ff       	jmp    80107dfe <alltraps>

801084e1 <vector22>:
.globl vector22
vector22:
  pushl $0
801084e1:	6a 00                	push   $0x0
  pushl $22
801084e3:	6a 16                	push   $0x16
  jmp alltraps
801084e5:	e9 14 f9 ff ff       	jmp    80107dfe <alltraps>

801084ea <vector23>:
.globl vector23
vector23:
  pushl $0
801084ea:	6a 00                	push   $0x0
  pushl $23
801084ec:	6a 17                	push   $0x17
  jmp alltraps
801084ee:	e9 0b f9 ff ff       	jmp    80107dfe <alltraps>

801084f3 <vector24>:
.globl vector24
vector24:
  pushl $0
801084f3:	6a 00                	push   $0x0
  pushl $24
801084f5:	6a 18                	push   $0x18
  jmp alltraps
801084f7:	e9 02 f9 ff ff       	jmp    80107dfe <alltraps>

801084fc <vector25>:
.globl vector25
vector25:
  pushl $0
801084fc:	6a 00                	push   $0x0
  pushl $25
801084fe:	6a 19                	push   $0x19
  jmp alltraps
80108500:	e9 f9 f8 ff ff       	jmp    80107dfe <alltraps>

80108505 <vector26>:
.globl vector26
vector26:
  pushl $0
80108505:	6a 00                	push   $0x0
  pushl $26
80108507:	6a 1a                	push   $0x1a
  jmp alltraps
80108509:	e9 f0 f8 ff ff       	jmp    80107dfe <alltraps>

8010850e <vector27>:
.globl vector27
vector27:
  pushl $0
8010850e:	6a 00                	push   $0x0
  pushl $27
80108510:	6a 1b                	push   $0x1b
  jmp alltraps
80108512:	e9 e7 f8 ff ff       	jmp    80107dfe <alltraps>

80108517 <vector28>:
.globl vector28
vector28:
  pushl $0
80108517:	6a 00                	push   $0x0
  pushl $28
80108519:	6a 1c                	push   $0x1c
  jmp alltraps
8010851b:	e9 de f8 ff ff       	jmp    80107dfe <alltraps>

80108520 <vector29>:
.globl vector29
vector29:
  pushl $0
80108520:	6a 00                	push   $0x0
  pushl $29
80108522:	6a 1d                	push   $0x1d
  jmp alltraps
80108524:	e9 d5 f8 ff ff       	jmp    80107dfe <alltraps>

80108529 <vector30>:
.globl vector30
vector30:
  pushl $0
80108529:	6a 00                	push   $0x0
  pushl $30
8010852b:	6a 1e                	push   $0x1e
  jmp alltraps
8010852d:	e9 cc f8 ff ff       	jmp    80107dfe <alltraps>

80108532 <vector31>:
.globl vector31
vector31:
  pushl $0
80108532:	6a 00                	push   $0x0
  pushl $31
80108534:	6a 1f                	push   $0x1f
  jmp alltraps
80108536:	e9 c3 f8 ff ff       	jmp    80107dfe <alltraps>

8010853b <vector32>:
.globl vector32
vector32:
  pushl $0
8010853b:	6a 00                	push   $0x0
  pushl $32
8010853d:	6a 20                	push   $0x20
  jmp alltraps
8010853f:	e9 ba f8 ff ff       	jmp    80107dfe <alltraps>

80108544 <vector33>:
.globl vector33
vector33:
  pushl $0
80108544:	6a 00                	push   $0x0
  pushl $33
80108546:	6a 21                	push   $0x21
  jmp alltraps
80108548:	e9 b1 f8 ff ff       	jmp    80107dfe <alltraps>

8010854d <vector34>:
.globl vector34
vector34:
  pushl $0
8010854d:	6a 00                	push   $0x0
  pushl $34
8010854f:	6a 22                	push   $0x22
  jmp alltraps
80108551:	e9 a8 f8 ff ff       	jmp    80107dfe <alltraps>

80108556 <vector35>:
.globl vector35
vector35:
  pushl $0
80108556:	6a 00                	push   $0x0
  pushl $35
80108558:	6a 23                	push   $0x23
  jmp alltraps
8010855a:	e9 9f f8 ff ff       	jmp    80107dfe <alltraps>

8010855f <vector36>:
.globl vector36
vector36:
  pushl $0
8010855f:	6a 00                	push   $0x0
  pushl $36
80108561:	6a 24                	push   $0x24
  jmp alltraps
80108563:	e9 96 f8 ff ff       	jmp    80107dfe <alltraps>

80108568 <vector37>:
.globl vector37
vector37:
  pushl $0
80108568:	6a 00                	push   $0x0
  pushl $37
8010856a:	6a 25                	push   $0x25
  jmp alltraps
8010856c:	e9 8d f8 ff ff       	jmp    80107dfe <alltraps>

80108571 <vector38>:
.globl vector38
vector38:
  pushl $0
80108571:	6a 00                	push   $0x0
  pushl $38
80108573:	6a 26                	push   $0x26
  jmp alltraps
80108575:	e9 84 f8 ff ff       	jmp    80107dfe <alltraps>

8010857a <vector39>:
.globl vector39
vector39:
  pushl $0
8010857a:	6a 00                	push   $0x0
  pushl $39
8010857c:	6a 27                	push   $0x27
  jmp alltraps
8010857e:	e9 7b f8 ff ff       	jmp    80107dfe <alltraps>

80108583 <vector40>:
.globl vector40
vector40:
  pushl $0
80108583:	6a 00                	push   $0x0
  pushl $40
80108585:	6a 28                	push   $0x28
  jmp alltraps
80108587:	e9 72 f8 ff ff       	jmp    80107dfe <alltraps>

8010858c <vector41>:
.globl vector41
vector41:
  pushl $0
8010858c:	6a 00                	push   $0x0
  pushl $41
8010858e:	6a 29                	push   $0x29
  jmp alltraps
80108590:	e9 69 f8 ff ff       	jmp    80107dfe <alltraps>

80108595 <vector42>:
.globl vector42
vector42:
  pushl $0
80108595:	6a 00                	push   $0x0
  pushl $42
80108597:	6a 2a                	push   $0x2a
  jmp alltraps
80108599:	e9 60 f8 ff ff       	jmp    80107dfe <alltraps>

8010859e <vector43>:
.globl vector43
vector43:
  pushl $0
8010859e:	6a 00                	push   $0x0
  pushl $43
801085a0:	6a 2b                	push   $0x2b
  jmp alltraps
801085a2:	e9 57 f8 ff ff       	jmp    80107dfe <alltraps>

801085a7 <vector44>:
.globl vector44
vector44:
  pushl $0
801085a7:	6a 00                	push   $0x0
  pushl $44
801085a9:	6a 2c                	push   $0x2c
  jmp alltraps
801085ab:	e9 4e f8 ff ff       	jmp    80107dfe <alltraps>

801085b0 <vector45>:
.globl vector45
vector45:
  pushl $0
801085b0:	6a 00                	push   $0x0
  pushl $45
801085b2:	6a 2d                	push   $0x2d
  jmp alltraps
801085b4:	e9 45 f8 ff ff       	jmp    80107dfe <alltraps>

801085b9 <vector46>:
.globl vector46
vector46:
  pushl $0
801085b9:	6a 00                	push   $0x0
  pushl $46
801085bb:	6a 2e                	push   $0x2e
  jmp alltraps
801085bd:	e9 3c f8 ff ff       	jmp    80107dfe <alltraps>

801085c2 <vector47>:
.globl vector47
vector47:
  pushl $0
801085c2:	6a 00                	push   $0x0
  pushl $47
801085c4:	6a 2f                	push   $0x2f
  jmp alltraps
801085c6:	e9 33 f8 ff ff       	jmp    80107dfe <alltraps>

801085cb <vector48>:
.globl vector48
vector48:
  pushl $0
801085cb:	6a 00                	push   $0x0
  pushl $48
801085cd:	6a 30                	push   $0x30
  jmp alltraps
801085cf:	e9 2a f8 ff ff       	jmp    80107dfe <alltraps>

801085d4 <vector49>:
.globl vector49
vector49:
  pushl $0
801085d4:	6a 00                	push   $0x0
  pushl $49
801085d6:	6a 31                	push   $0x31
  jmp alltraps
801085d8:	e9 21 f8 ff ff       	jmp    80107dfe <alltraps>

801085dd <vector50>:
.globl vector50
vector50:
  pushl $0
801085dd:	6a 00                	push   $0x0
  pushl $50
801085df:	6a 32                	push   $0x32
  jmp alltraps
801085e1:	e9 18 f8 ff ff       	jmp    80107dfe <alltraps>

801085e6 <vector51>:
.globl vector51
vector51:
  pushl $0
801085e6:	6a 00                	push   $0x0
  pushl $51
801085e8:	6a 33                	push   $0x33
  jmp alltraps
801085ea:	e9 0f f8 ff ff       	jmp    80107dfe <alltraps>

801085ef <vector52>:
.globl vector52
vector52:
  pushl $0
801085ef:	6a 00                	push   $0x0
  pushl $52
801085f1:	6a 34                	push   $0x34
  jmp alltraps
801085f3:	e9 06 f8 ff ff       	jmp    80107dfe <alltraps>

801085f8 <vector53>:
.globl vector53
vector53:
  pushl $0
801085f8:	6a 00                	push   $0x0
  pushl $53
801085fa:	6a 35                	push   $0x35
  jmp alltraps
801085fc:	e9 fd f7 ff ff       	jmp    80107dfe <alltraps>

80108601 <vector54>:
.globl vector54
vector54:
  pushl $0
80108601:	6a 00                	push   $0x0
  pushl $54
80108603:	6a 36                	push   $0x36
  jmp alltraps
80108605:	e9 f4 f7 ff ff       	jmp    80107dfe <alltraps>

8010860a <vector55>:
.globl vector55
vector55:
  pushl $0
8010860a:	6a 00                	push   $0x0
  pushl $55
8010860c:	6a 37                	push   $0x37
  jmp alltraps
8010860e:	e9 eb f7 ff ff       	jmp    80107dfe <alltraps>

80108613 <vector56>:
.globl vector56
vector56:
  pushl $0
80108613:	6a 00                	push   $0x0
  pushl $56
80108615:	6a 38                	push   $0x38
  jmp alltraps
80108617:	e9 e2 f7 ff ff       	jmp    80107dfe <alltraps>

8010861c <vector57>:
.globl vector57
vector57:
  pushl $0
8010861c:	6a 00                	push   $0x0
  pushl $57
8010861e:	6a 39                	push   $0x39
  jmp alltraps
80108620:	e9 d9 f7 ff ff       	jmp    80107dfe <alltraps>

80108625 <vector58>:
.globl vector58
vector58:
  pushl $0
80108625:	6a 00                	push   $0x0
  pushl $58
80108627:	6a 3a                	push   $0x3a
  jmp alltraps
80108629:	e9 d0 f7 ff ff       	jmp    80107dfe <alltraps>

8010862e <vector59>:
.globl vector59
vector59:
  pushl $0
8010862e:	6a 00                	push   $0x0
  pushl $59
80108630:	6a 3b                	push   $0x3b
  jmp alltraps
80108632:	e9 c7 f7 ff ff       	jmp    80107dfe <alltraps>

80108637 <vector60>:
.globl vector60
vector60:
  pushl $0
80108637:	6a 00                	push   $0x0
  pushl $60
80108639:	6a 3c                	push   $0x3c
  jmp alltraps
8010863b:	e9 be f7 ff ff       	jmp    80107dfe <alltraps>

80108640 <vector61>:
.globl vector61
vector61:
  pushl $0
80108640:	6a 00                	push   $0x0
  pushl $61
80108642:	6a 3d                	push   $0x3d
  jmp alltraps
80108644:	e9 b5 f7 ff ff       	jmp    80107dfe <alltraps>

80108649 <vector62>:
.globl vector62
vector62:
  pushl $0
80108649:	6a 00                	push   $0x0
  pushl $62
8010864b:	6a 3e                	push   $0x3e
  jmp alltraps
8010864d:	e9 ac f7 ff ff       	jmp    80107dfe <alltraps>

80108652 <vector63>:
.globl vector63
vector63:
  pushl $0
80108652:	6a 00                	push   $0x0
  pushl $63
80108654:	6a 3f                	push   $0x3f
  jmp alltraps
80108656:	e9 a3 f7 ff ff       	jmp    80107dfe <alltraps>

8010865b <vector64>:
.globl vector64
vector64:
  pushl $0
8010865b:	6a 00                	push   $0x0
  pushl $64
8010865d:	6a 40                	push   $0x40
  jmp alltraps
8010865f:	e9 9a f7 ff ff       	jmp    80107dfe <alltraps>

80108664 <vector65>:
.globl vector65
vector65:
  pushl $0
80108664:	6a 00                	push   $0x0
  pushl $65
80108666:	6a 41                	push   $0x41
  jmp alltraps
80108668:	e9 91 f7 ff ff       	jmp    80107dfe <alltraps>

8010866d <vector66>:
.globl vector66
vector66:
  pushl $0
8010866d:	6a 00                	push   $0x0
  pushl $66
8010866f:	6a 42                	push   $0x42
  jmp alltraps
80108671:	e9 88 f7 ff ff       	jmp    80107dfe <alltraps>

80108676 <vector67>:
.globl vector67
vector67:
  pushl $0
80108676:	6a 00                	push   $0x0
  pushl $67
80108678:	6a 43                	push   $0x43
  jmp alltraps
8010867a:	e9 7f f7 ff ff       	jmp    80107dfe <alltraps>

8010867f <vector68>:
.globl vector68
vector68:
  pushl $0
8010867f:	6a 00                	push   $0x0
  pushl $68
80108681:	6a 44                	push   $0x44
  jmp alltraps
80108683:	e9 76 f7 ff ff       	jmp    80107dfe <alltraps>

80108688 <vector69>:
.globl vector69
vector69:
  pushl $0
80108688:	6a 00                	push   $0x0
  pushl $69
8010868a:	6a 45                	push   $0x45
  jmp alltraps
8010868c:	e9 6d f7 ff ff       	jmp    80107dfe <alltraps>

80108691 <vector70>:
.globl vector70
vector70:
  pushl $0
80108691:	6a 00                	push   $0x0
  pushl $70
80108693:	6a 46                	push   $0x46
  jmp alltraps
80108695:	e9 64 f7 ff ff       	jmp    80107dfe <alltraps>

8010869a <vector71>:
.globl vector71
vector71:
  pushl $0
8010869a:	6a 00                	push   $0x0
  pushl $71
8010869c:	6a 47                	push   $0x47
  jmp alltraps
8010869e:	e9 5b f7 ff ff       	jmp    80107dfe <alltraps>

801086a3 <vector72>:
.globl vector72
vector72:
  pushl $0
801086a3:	6a 00                	push   $0x0
  pushl $72
801086a5:	6a 48                	push   $0x48
  jmp alltraps
801086a7:	e9 52 f7 ff ff       	jmp    80107dfe <alltraps>

801086ac <vector73>:
.globl vector73
vector73:
  pushl $0
801086ac:	6a 00                	push   $0x0
  pushl $73
801086ae:	6a 49                	push   $0x49
  jmp alltraps
801086b0:	e9 49 f7 ff ff       	jmp    80107dfe <alltraps>

801086b5 <vector74>:
.globl vector74
vector74:
  pushl $0
801086b5:	6a 00                	push   $0x0
  pushl $74
801086b7:	6a 4a                	push   $0x4a
  jmp alltraps
801086b9:	e9 40 f7 ff ff       	jmp    80107dfe <alltraps>

801086be <vector75>:
.globl vector75
vector75:
  pushl $0
801086be:	6a 00                	push   $0x0
  pushl $75
801086c0:	6a 4b                	push   $0x4b
  jmp alltraps
801086c2:	e9 37 f7 ff ff       	jmp    80107dfe <alltraps>

801086c7 <vector76>:
.globl vector76
vector76:
  pushl $0
801086c7:	6a 00                	push   $0x0
  pushl $76
801086c9:	6a 4c                	push   $0x4c
  jmp alltraps
801086cb:	e9 2e f7 ff ff       	jmp    80107dfe <alltraps>

801086d0 <vector77>:
.globl vector77
vector77:
  pushl $0
801086d0:	6a 00                	push   $0x0
  pushl $77
801086d2:	6a 4d                	push   $0x4d
  jmp alltraps
801086d4:	e9 25 f7 ff ff       	jmp    80107dfe <alltraps>

801086d9 <vector78>:
.globl vector78
vector78:
  pushl $0
801086d9:	6a 00                	push   $0x0
  pushl $78
801086db:	6a 4e                	push   $0x4e
  jmp alltraps
801086dd:	e9 1c f7 ff ff       	jmp    80107dfe <alltraps>

801086e2 <vector79>:
.globl vector79
vector79:
  pushl $0
801086e2:	6a 00                	push   $0x0
  pushl $79
801086e4:	6a 4f                	push   $0x4f
  jmp alltraps
801086e6:	e9 13 f7 ff ff       	jmp    80107dfe <alltraps>

801086eb <vector80>:
.globl vector80
vector80:
  pushl $0
801086eb:	6a 00                	push   $0x0
  pushl $80
801086ed:	6a 50                	push   $0x50
  jmp alltraps
801086ef:	e9 0a f7 ff ff       	jmp    80107dfe <alltraps>

801086f4 <vector81>:
.globl vector81
vector81:
  pushl $0
801086f4:	6a 00                	push   $0x0
  pushl $81
801086f6:	6a 51                	push   $0x51
  jmp alltraps
801086f8:	e9 01 f7 ff ff       	jmp    80107dfe <alltraps>

801086fd <vector82>:
.globl vector82
vector82:
  pushl $0
801086fd:	6a 00                	push   $0x0
  pushl $82
801086ff:	6a 52                	push   $0x52
  jmp alltraps
80108701:	e9 f8 f6 ff ff       	jmp    80107dfe <alltraps>

80108706 <vector83>:
.globl vector83
vector83:
  pushl $0
80108706:	6a 00                	push   $0x0
  pushl $83
80108708:	6a 53                	push   $0x53
  jmp alltraps
8010870a:	e9 ef f6 ff ff       	jmp    80107dfe <alltraps>

8010870f <vector84>:
.globl vector84
vector84:
  pushl $0
8010870f:	6a 00                	push   $0x0
  pushl $84
80108711:	6a 54                	push   $0x54
  jmp alltraps
80108713:	e9 e6 f6 ff ff       	jmp    80107dfe <alltraps>

80108718 <vector85>:
.globl vector85
vector85:
  pushl $0
80108718:	6a 00                	push   $0x0
  pushl $85
8010871a:	6a 55                	push   $0x55
  jmp alltraps
8010871c:	e9 dd f6 ff ff       	jmp    80107dfe <alltraps>

80108721 <vector86>:
.globl vector86
vector86:
  pushl $0
80108721:	6a 00                	push   $0x0
  pushl $86
80108723:	6a 56                	push   $0x56
  jmp alltraps
80108725:	e9 d4 f6 ff ff       	jmp    80107dfe <alltraps>

8010872a <vector87>:
.globl vector87
vector87:
  pushl $0
8010872a:	6a 00                	push   $0x0
  pushl $87
8010872c:	6a 57                	push   $0x57
  jmp alltraps
8010872e:	e9 cb f6 ff ff       	jmp    80107dfe <alltraps>

80108733 <vector88>:
.globl vector88
vector88:
  pushl $0
80108733:	6a 00                	push   $0x0
  pushl $88
80108735:	6a 58                	push   $0x58
  jmp alltraps
80108737:	e9 c2 f6 ff ff       	jmp    80107dfe <alltraps>

8010873c <vector89>:
.globl vector89
vector89:
  pushl $0
8010873c:	6a 00                	push   $0x0
  pushl $89
8010873e:	6a 59                	push   $0x59
  jmp alltraps
80108740:	e9 b9 f6 ff ff       	jmp    80107dfe <alltraps>

80108745 <vector90>:
.globl vector90
vector90:
  pushl $0
80108745:	6a 00                	push   $0x0
  pushl $90
80108747:	6a 5a                	push   $0x5a
  jmp alltraps
80108749:	e9 b0 f6 ff ff       	jmp    80107dfe <alltraps>

8010874e <vector91>:
.globl vector91
vector91:
  pushl $0
8010874e:	6a 00                	push   $0x0
  pushl $91
80108750:	6a 5b                	push   $0x5b
  jmp alltraps
80108752:	e9 a7 f6 ff ff       	jmp    80107dfe <alltraps>

80108757 <vector92>:
.globl vector92
vector92:
  pushl $0
80108757:	6a 00                	push   $0x0
  pushl $92
80108759:	6a 5c                	push   $0x5c
  jmp alltraps
8010875b:	e9 9e f6 ff ff       	jmp    80107dfe <alltraps>

80108760 <vector93>:
.globl vector93
vector93:
  pushl $0
80108760:	6a 00                	push   $0x0
  pushl $93
80108762:	6a 5d                	push   $0x5d
  jmp alltraps
80108764:	e9 95 f6 ff ff       	jmp    80107dfe <alltraps>

80108769 <vector94>:
.globl vector94
vector94:
  pushl $0
80108769:	6a 00                	push   $0x0
  pushl $94
8010876b:	6a 5e                	push   $0x5e
  jmp alltraps
8010876d:	e9 8c f6 ff ff       	jmp    80107dfe <alltraps>

80108772 <vector95>:
.globl vector95
vector95:
  pushl $0
80108772:	6a 00                	push   $0x0
  pushl $95
80108774:	6a 5f                	push   $0x5f
  jmp alltraps
80108776:	e9 83 f6 ff ff       	jmp    80107dfe <alltraps>

8010877b <vector96>:
.globl vector96
vector96:
  pushl $0
8010877b:	6a 00                	push   $0x0
  pushl $96
8010877d:	6a 60                	push   $0x60
  jmp alltraps
8010877f:	e9 7a f6 ff ff       	jmp    80107dfe <alltraps>

80108784 <vector97>:
.globl vector97
vector97:
  pushl $0
80108784:	6a 00                	push   $0x0
  pushl $97
80108786:	6a 61                	push   $0x61
  jmp alltraps
80108788:	e9 71 f6 ff ff       	jmp    80107dfe <alltraps>

8010878d <vector98>:
.globl vector98
vector98:
  pushl $0
8010878d:	6a 00                	push   $0x0
  pushl $98
8010878f:	6a 62                	push   $0x62
  jmp alltraps
80108791:	e9 68 f6 ff ff       	jmp    80107dfe <alltraps>

80108796 <vector99>:
.globl vector99
vector99:
  pushl $0
80108796:	6a 00                	push   $0x0
  pushl $99
80108798:	6a 63                	push   $0x63
  jmp alltraps
8010879a:	e9 5f f6 ff ff       	jmp    80107dfe <alltraps>

8010879f <vector100>:
.globl vector100
vector100:
  pushl $0
8010879f:	6a 00                	push   $0x0
  pushl $100
801087a1:	6a 64                	push   $0x64
  jmp alltraps
801087a3:	e9 56 f6 ff ff       	jmp    80107dfe <alltraps>

801087a8 <vector101>:
.globl vector101
vector101:
  pushl $0
801087a8:	6a 00                	push   $0x0
  pushl $101
801087aa:	6a 65                	push   $0x65
  jmp alltraps
801087ac:	e9 4d f6 ff ff       	jmp    80107dfe <alltraps>

801087b1 <vector102>:
.globl vector102
vector102:
  pushl $0
801087b1:	6a 00                	push   $0x0
  pushl $102
801087b3:	6a 66                	push   $0x66
  jmp alltraps
801087b5:	e9 44 f6 ff ff       	jmp    80107dfe <alltraps>

801087ba <vector103>:
.globl vector103
vector103:
  pushl $0
801087ba:	6a 00                	push   $0x0
  pushl $103
801087bc:	6a 67                	push   $0x67
  jmp alltraps
801087be:	e9 3b f6 ff ff       	jmp    80107dfe <alltraps>

801087c3 <vector104>:
.globl vector104
vector104:
  pushl $0
801087c3:	6a 00                	push   $0x0
  pushl $104
801087c5:	6a 68                	push   $0x68
  jmp alltraps
801087c7:	e9 32 f6 ff ff       	jmp    80107dfe <alltraps>

801087cc <vector105>:
.globl vector105
vector105:
  pushl $0
801087cc:	6a 00                	push   $0x0
  pushl $105
801087ce:	6a 69                	push   $0x69
  jmp alltraps
801087d0:	e9 29 f6 ff ff       	jmp    80107dfe <alltraps>

801087d5 <vector106>:
.globl vector106
vector106:
  pushl $0
801087d5:	6a 00                	push   $0x0
  pushl $106
801087d7:	6a 6a                	push   $0x6a
  jmp alltraps
801087d9:	e9 20 f6 ff ff       	jmp    80107dfe <alltraps>

801087de <vector107>:
.globl vector107
vector107:
  pushl $0
801087de:	6a 00                	push   $0x0
  pushl $107
801087e0:	6a 6b                	push   $0x6b
  jmp alltraps
801087e2:	e9 17 f6 ff ff       	jmp    80107dfe <alltraps>

801087e7 <vector108>:
.globl vector108
vector108:
  pushl $0
801087e7:	6a 00                	push   $0x0
  pushl $108
801087e9:	6a 6c                	push   $0x6c
  jmp alltraps
801087eb:	e9 0e f6 ff ff       	jmp    80107dfe <alltraps>

801087f0 <vector109>:
.globl vector109
vector109:
  pushl $0
801087f0:	6a 00                	push   $0x0
  pushl $109
801087f2:	6a 6d                	push   $0x6d
  jmp alltraps
801087f4:	e9 05 f6 ff ff       	jmp    80107dfe <alltraps>

801087f9 <vector110>:
.globl vector110
vector110:
  pushl $0
801087f9:	6a 00                	push   $0x0
  pushl $110
801087fb:	6a 6e                	push   $0x6e
  jmp alltraps
801087fd:	e9 fc f5 ff ff       	jmp    80107dfe <alltraps>

80108802 <vector111>:
.globl vector111
vector111:
  pushl $0
80108802:	6a 00                	push   $0x0
  pushl $111
80108804:	6a 6f                	push   $0x6f
  jmp alltraps
80108806:	e9 f3 f5 ff ff       	jmp    80107dfe <alltraps>

8010880b <vector112>:
.globl vector112
vector112:
  pushl $0
8010880b:	6a 00                	push   $0x0
  pushl $112
8010880d:	6a 70                	push   $0x70
  jmp alltraps
8010880f:	e9 ea f5 ff ff       	jmp    80107dfe <alltraps>

80108814 <vector113>:
.globl vector113
vector113:
  pushl $0
80108814:	6a 00                	push   $0x0
  pushl $113
80108816:	6a 71                	push   $0x71
  jmp alltraps
80108818:	e9 e1 f5 ff ff       	jmp    80107dfe <alltraps>

8010881d <vector114>:
.globl vector114
vector114:
  pushl $0
8010881d:	6a 00                	push   $0x0
  pushl $114
8010881f:	6a 72                	push   $0x72
  jmp alltraps
80108821:	e9 d8 f5 ff ff       	jmp    80107dfe <alltraps>

80108826 <vector115>:
.globl vector115
vector115:
  pushl $0
80108826:	6a 00                	push   $0x0
  pushl $115
80108828:	6a 73                	push   $0x73
  jmp alltraps
8010882a:	e9 cf f5 ff ff       	jmp    80107dfe <alltraps>

8010882f <vector116>:
.globl vector116
vector116:
  pushl $0
8010882f:	6a 00                	push   $0x0
  pushl $116
80108831:	6a 74                	push   $0x74
  jmp alltraps
80108833:	e9 c6 f5 ff ff       	jmp    80107dfe <alltraps>

80108838 <vector117>:
.globl vector117
vector117:
  pushl $0
80108838:	6a 00                	push   $0x0
  pushl $117
8010883a:	6a 75                	push   $0x75
  jmp alltraps
8010883c:	e9 bd f5 ff ff       	jmp    80107dfe <alltraps>

80108841 <vector118>:
.globl vector118
vector118:
  pushl $0
80108841:	6a 00                	push   $0x0
  pushl $118
80108843:	6a 76                	push   $0x76
  jmp alltraps
80108845:	e9 b4 f5 ff ff       	jmp    80107dfe <alltraps>

8010884a <vector119>:
.globl vector119
vector119:
  pushl $0
8010884a:	6a 00                	push   $0x0
  pushl $119
8010884c:	6a 77                	push   $0x77
  jmp alltraps
8010884e:	e9 ab f5 ff ff       	jmp    80107dfe <alltraps>

80108853 <vector120>:
.globl vector120
vector120:
  pushl $0
80108853:	6a 00                	push   $0x0
  pushl $120
80108855:	6a 78                	push   $0x78
  jmp alltraps
80108857:	e9 a2 f5 ff ff       	jmp    80107dfe <alltraps>

8010885c <vector121>:
.globl vector121
vector121:
  pushl $0
8010885c:	6a 00                	push   $0x0
  pushl $121
8010885e:	6a 79                	push   $0x79
  jmp alltraps
80108860:	e9 99 f5 ff ff       	jmp    80107dfe <alltraps>

80108865 <vector122>:
.globl vector122
vector122:
  pushl $0
80108865:	6a 00                	push   $0x0
  pushl $122
80108867:	6a 7a                	push   $0x7a
  jmp alltraps
80108869:	e9 90 f5 ff ff       	jmp    80107dfe <alltraps>

8010886e <vector123>:
.globl vector123
vector123:
  pushl $0
8010886e:	6a 00                	push   $0x0
  pushl $123
80108870:	6a 7b                	push   $0x7b
  jmp alltraps
80108872:	e9 87 f5 ff ff       	jmp    80107dfe <alltraps>

80108877 <vector124>:
.globl vector124
vector124:
  pushl $0
80108877:	6a 00                	push   $0x0
  pushl $124
80108879:	6a 7c                	push   $0x7c
  jmp alltraps
8010887b:	e9 7e f5 ff ff       	jmp    80107dfe <alltraps>

80108880 <vector125>:
.globl vector125
vector125:
  pushl $0
80108880:	6a 00                	push   $0x0
  pushl $125
80108882:	6a 7d                	push   $0x7d
  jmp alltraps
80108884:	e9 75 f5 ff ff       	jmp    80107dfe <alltraps>

80108889 <vector126>:
.globl vector126
vector126:
  pushl $0
80108889:	6a 00                	push   $0x0
  pushl $126
8010888b:	6a 7e                	push   $0x7e
  jmp alltraps
8010888d:	e9 6c f5 ff ff       	jmp    80107dfe <alltraps>

80108892 <vector127>:
.globl vector127
vector127:
  pushl $0
80108892:	6a 00                	push   $0x0
  pushl $127
80108894:	6a 7f                	push   $0x7f
  jmp alltraps
80108896:	e9 63 f5 ff ff       	jmp    80107dfe <alltraps>

8010889b <vector128>:
.globl vector128
vector128:
  pushl $0
8010889b:	6a 00                	push   $0x0
  pushl $128
8010889d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801088a2:	e9 57 f5 ff ff       	jmp    80107dfe <alltraps>

801088a7 <vector129>:
.globl vector129
vector129:
  pushl $0
801088a7:	6a 00                	push   $0x0
  pushl $129
801088a9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801088ae:	e9 4b f5 ff ff       	jmp    80107dfe <alltraps>

801088b3 <vector130>:
.globl vector130
vector130:
  pushl $0
801088b3:	6a 00                	push   $0x0
  pushl $130
801088b5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801088ba:	e9 3f f5 ff ff       	jmp    80107dfe <alltraps>

801088bf <vector131>:
.globl vector131
vector131:
  pushl $0
801088bf:	6a 00                	push   $0x0
  pushl $131
801088c1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801088c6:	e9 33 f5 ff ff       	jmp    80107dfe <alltraps>

801088cb <vector132>:
.globl vector132
vector132:
  pushl $0
801088cb:	6a 00                	push   $0x0
  pushl $132
801088cd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801088d2:	e9 27 f5 ff ff       	jmp    80107dfe <alltraps>

801088d7 <vector133>:
.globl vector133
vector133:
  pushl $0
801088d7:	6a 00                	push   $0x0
  pushl $133
801088d9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801088de:	e9 1b f5 ff ff       	jmp    80107dfe <alltraps>

801088e3 <vector134>:
.globl vector134
vector134:
  pushl $0
801088e3:	6a 00                	push   $0x0
  pushl $134
801088e5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801088ea:	e9 0f f5 ff ff       	jmp    80107dfe <alltraps>

801088ef <vector135>:
.globl vector135
vector135:
  pushl $0
801088ef:	6a 00                	push   $0x0
  pushl $135
801088f1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801088f6:	e9 03 f5 ff ff       	jmp    80107dfe <alltraps>

801088fb <vector136>:
.globl vector136
vector136:
  pushl $0
801088fb:	6a 00                	push   $0x0
  pushl $136
801088fd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108902:	e9 f7 f4 ff ff       	jmp    80107dfe <alltraps>

80108907 <vector137>:
.globl vector137
vector137:
  pushl $0
80108907:	6a 00                	push   $0x0
  pushl $137
80108909:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010890e:	e9 eb f4 ff ff       	jmp    80107dfe <alltraps>

80108913 <vector138>:
.globl vector138
vector138:
  pushl $0
80108913:	6a 00                	push   $0x0
  pushl $138
80108915:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010891a:	e9 df f4 ff ff       	jmp    80107dfe <alltraps>

8010891f <vector139>:
.globl vector139
vector139:
  pushl $0
8010891f:	6a 00                	push   $0x0
  pushl $139
80108921:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108926:	e9 d3 f4 ff ff       	jmp    80107dfe <alltraps>

8010892b <vector140>:
.globl vector140
vector140:
  pushl $0
8010892b:	6a 00                	push   $0x0
  pushl $140
8010892d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108932:	e9 c7 f4 ff ff       	jmp    80107dfe <alltraps>

80108937 <vector141>:
.globl vector141
vector141:
  pushl $0
80108937:	6a 00                	push   $0x0
  pushl $141
80108939:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010893e:	e9 bb f4 ff ff       	jmp    80107dfe <alltraps>

80108943 <vector142>:
.globl vector142
vector142:
  pushl $0
80108943:	6a 00                	push   $0x0
  pushl $142
80108945:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010894a:	e9 af f4 ff ff       	jmp    80107dfe <alltraps>

8010894f <vector143>:
.globl vector143
vector143:
  pushl $0
8010894f:	6a 00                	push   $0x0
  pushl $143
80108951:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108956:	e9 a3 f4 ff ff       	jmp    80107dfe <alltraps>

8010895b <vector144>:
.globl vector144
vector144:
  pushl $0
8010895b:	6a 00                	push   $0x0
  pushl $144
8010895d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108962:	e9 97 f4 ff ff       	jmp    80107dfe <alltraps>

80108967 <vector145>:
.globl vector145
vector145:
  pushl $0
80108967:	6a 00                	push   $0x0
  pushl $145
80108969:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010896e:	e9 8b f4 ff ff       	jmp    80107dfe <alltraps>

80108973 <vector146>:
.globl vector146
vector146:
  pushl $0
80108973:	6a 00                	push   $0x0
  pushl $146
80108975:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010897a:	e9 7f f4 ff ff       	jmp    80107dfe <alltraps>

8010897f <vector147>:
.globl vector147
vector147:
  pushl $0
8010897f:	6a 00                	push   $0x0
  pushl $147
80108981:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108986:	e9 73 f4 ff ff       	jmp    80107dfe <alltraps>

8010898b <vector148>:
.globl vector148
vector148:
  pushl $0
8010898b:	6a 00                	push   $0x0
  pushl $148
8010898d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108992:	e9 67 f4 ff ff       	jmp    80107dfe <alltraps>

80108997 <vector149>:
.globl vector149
vector149:
  pushl $0
80108997:	6a 00                	push   $0x0
  pushl $149
80108999:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010899e:	e9 5b f4 ff ff       	jmp    80107dfe <alltraps>

801089a3 <vector150>:
.globl vector150
vector150:
  pushl $0
801089a3:	6a 00                	push   $0x0
  pushl $150
801089a5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801089aa:	e9 4f f4 ff ff       	jmp    80107dfe <alltraps>

801089af <vector151>:
.globl vector151
vector151:
  pushl $0
801089af:	6a 00                	push   $0x0
  pushl $151
801089b1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801089b6:	e9 43 f4 ff ff       	jmp    80107dfe <alltraps>

801089bb <vector152>:
.globl vector152
vector152:
  pushl $0
801089bb:	6a 00                	push   $0x0
  pushl $152
801089bd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801089c2:	e9 37 f4 ff ff       	jmp    80107dfe <alltraps>

801089c7 <vector153>:
.globl vector153
vector153:
  pushl $0
801089c7:	6a 00                	push   $0x0
  pushl $153
801089c9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801089ce:	e9 2b f4 ff ff       	jmp    80107dfe <alltraps>

801089d3 <vector154>:
.globl vector154
vector154:
  pushl $0
801089d3:	6a 00                	push   $0x0
  pushl $154
801089d5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801089da:	e9 1f f4 ff ff       	jmp    80107dfe <alltraps>

801089df <vector155>:
.globl vector155
vector155:
  pushl $0
801089df:	6a 00                	push   $0x0
  pushl $155
801089e1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801089e6:	e9 13 f4 ff ff       	jmp    80107dfe <alltraps>

801089eb <vector156>:
.globl vector156
vector156:
  pushl $0
801089eb:	6a 00                	push   $0x0
  pushl $156
801089ed:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801089f2:	e9 07 f4 ff ff       	jmp    80107dfe <alltraps>

801089f7 <vector157>:
.globl vector157
vector157:
  pushl $0
801089f7:	6a 00                	push   $0x0
  pushl $157
801089f9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801089fe:	e9 fb f3 ff ff       	jmp    80107dfe <alltraps>

80108a03 <vector158>:
.globl vector158
vector158:
  pushl $0
80108a03:	6a 00                	push   $0x0
  pushl $158
80108a05:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108a0a:	e9 ef f3 ff ff       	jmp    80107dfe <alltraps>

80108a0f <vector159>:
.globl vector159
vector159:
  pushl $0
80108a0f:	6a 00                	push   $0x0
  pushl $159
80108a11:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108a16:	e9 e3 f3 ff ff       	jmp    80107dfe <alltraps>

80108a1b <vector160>:
.globl vector160
vector160:
  pushl $0
80108a1b:	6a 00                	push   $0x0
  pushl $160
80108a1d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108a22:	e9 d7 f3 ff ff       	jmp    80107dfe <alltraps>

80108a27 <vector161>:
.globl vector161
vector161:
  pushl $0
80108a27:	6a 00                	push   $0x0
  pushl $161
80108a29:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108a2e:	e9 cb f3 ff ff       	jmp    80107dfe <alltraps>

80108a33 <vector162>:
.globl vector162
vector162:
  pushl $0
80108a33:	6a 00                	push   $0x0
  pushl $162
80108a35:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108a3a:	e9 bf f3 ff ff       	jmp    80107dfe <alltraps>

80108a3f <vector163>:
.globl vector163
vector163:
  pushl $0
80108a3f:	6a 00                	push   $0x0
  pushl $163
80108a41:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108a46:	e9 b3 f3 ff ff       	jmp    80107dfe <alltraps>

80108a4b <vector164>:
.globl vector164
vector164:
  pushl $0
80108a4b:	6a 00                	push   $0x0
  pushl $164
80108a4d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108a52:	e9 a7 f3 ff ff       	jmp    80107dfe <alltraps>

80108a57 <vector165>:
.globl vector165
vector165:
  pushl $0
80108a57:	6a 00                	push   $0x0
  pushl $165
80108a59:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108a5e:	e9 9b f3 ff ff       	jmp    80107dfe <alltraps>

80108a63 <vector166>:
.globl vector166
vector166:
  pushl $0
80108a63:	6a 00                	push   $0x0
  pushl $166
80108a65:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108a6a:	e9 8f f3 ff ff       	jmp    80107dfe <alltraps>

80108a6f <vector167>:
.globl vector167
vector167:
  pushl $0
80108a6f:	6a 00                	push   $0x0
  pushl $167
80108a71:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108a76:	e9 83 f3 ff ff       	jmp    80107dfe <alltraps>

80108a7b <vector168>:
.globl vector168
vector168:
  pushl $0
80108a7b:	6a 00                	push   $0x0
  pushl $168
80108a7d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108a82:	e9 77 f3 ff ff       	jmp    80107dfe <alltraps>

80108a87 <vector169>:
.globl vector169
vector169:
  pushl $0
80108a87:	6a 00                	push   $0x0
  pushl $169
80108a89:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108a8e:	e9 6b f3 ff ff       	jmp    80107dfe <alltraps>

80108a93 <vector170>:
.globl vector170
vector170:
  pushl $0
80108a93:	6a 00                	push   $0x0
  pushl $170
80108a95:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108a9a:	e9 5f f3 ff ff       	jmp    80107dfe <alltraps>

80108a9f <vector171>:
.globl vector171
vector171:
  pushl $0
80108a9f:	6a 00                	push   $0x0
  pushl $171
80108aa1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108aa6:	e9 53 f3 ff ff       	jmp    80107dfe <alltraps>

80108aab <vector172>:
.globl vector172
vector172:
  pushl $0
80108aab:	6a 00                	push   $0x0
  pushl $172
80108aad:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108ab2:	e9 47 f3 ff ff       	jmp    80107dfe <alltraps>

80108ab7 <vector173>:
.globl vector173
vector173:
  pushl $0
80108ab7:	6a 00                	push   $0x0
  pushl $173
80108ab9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108abe:	e9 3b f3 ff ff       	jmp    80107dfe <alltraps>

80108ac3 <vector174>:
.globl vector174
vector174:
  pushl $0
80108ac3:	6a 00                	push   $0x0
  pushl $174
80108ac5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108aca:	e9 2f f3 ff ff       	jmp    80107dfe <alltraps>

80108acf <vector175>:
.globl vector175
vector175:
  pushl $0
80108acf:	6a 00                	push   $0x0
  pushl $175
80108ad1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108ad6:	e9 23 f3 ff ff       	jmp    80107dfe <alltraps>

80108adb <vector176>:
.globl vector176
vector176:
  pushl $0
80108adb:	6a 00                	push   $0x0
  pushl $176
80108add:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108ae2:	e9 17 f3 ff ff       	jmp    80107dfe <alltraps>

80108ae7 <vector177>:
.globl vector177
vector177:
  pushl $0
80108ae7:	6a 00                	push   $0x0
  pushl $177
80108ae9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108aee:	e9 0b f3 ff ff       	jmp    80107dfe <alltraps>

80108af3 <vector178>:
.globl vector178
vector178:
  pushl $0
80108af3:	6a 00                	push   $0x0
  pushl $178
80108af5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108afa:	e9 ff f2 ff ff       	jmp    80107dfe <alltraps>

80108aff <vector179>:
.globl vector179
vector179:
  pushl $0
80108aff:	6a 00                	push   $0x0
  pushl $179
80108b01:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108b06:	e9 f3 f2 ff ff       	jmp    80107dfe <alltraps>

80108b0b <vector180>:
.globl vector180
vector180:
  pushl $0
80108b0b:	6a 00                	push   $0x0
  pushl $180
80108b0d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108b12:	e9 e7 f2 ff ff       	jmp    80107dfe <alltraps>

80108b17 <vector181>:
.globl vector181
vector181:
  pushl $0
80108b17:	6a 00                	push   $0x0
  pushl $181
80108b19:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108b1e:	e9 db f2 ff ff       	jmp    80107dfe <alltraps>

80108b23 <vector182>:
.globl vector182
vector182:
  pushl $0
80108b23:	6a 00                	push   $0x0
  pushl $182
80108b25:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108b2a:	e9 cf f2 ff ff       	jmp    80107dfe <alltraps>

80108b2f <vector183>:
.globl vector183
vector183:
  pushl $0
80108b2f:	6a 00                	push   $0x0
  pushl $183
80108b31:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108b36:	e9 c3 f2 ff ff       	jmp    80107dfe <alltraps>

80108b3b <vector184>:
.globl vector184
vector184:
  pushl $0
80108b3b:	6a 00                	push   $0x0
  pushl $184
80108b3d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108b42:	e9 b7 f2 ff ff       	jmp    80107dfe <alltraps>

80108b47 <vector185>:
.globl vector185
vector185:
  pushl $0
80108b47:	6a 00                	push   $0x0
  pushl $185
80108b49:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108b4e:	e9 ab f2 ff ff       	jmp    80107dfe <alltraps>

80108b53 <vector186>:
.globl vector186
vector186:
  pushl $0
80108b53:	6a 00                	push   $0x0
  pushl $186
80108b55:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108b5a:	e9 9f f2 ff ff       	jmp    80107dfe <alltraps>

80108b5f <vector187>:
.globl vector187
vector187:
  pushl $0
80108b5f:	6a 00                	push   $0x0
  pushl $187
80108b61:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108b66:	e9 93 f2 ff ff       	jmp    80107dfe <alltraps>

80108b6b <vector188>:
.globl vector188
vector188:
  pushl $0
80108b6b:	6a 00                	push   $0x0
  pushl $188
80108b6d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108b72:	e9 87 f2 ff ff       	jmp    80107dfe <alltraps>

80108b77 <vector189>:
.globl vector189
vector189:
  pushl $0
80108b77:	6a 00                	push   $0x0
  pushl $189
80108b79:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108b7e:	e9 7b f2 ff ff       	jmp    80107dfe <alltraps>

80108b83 <vector190>:
.globl vector190
vector190:
  pushl $0
80108b83:	6a 00                	push   $0x0
  pushl $190
80108b85:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108b8a:	e9 6f f2 ff ff       	jmp    80107dfe <alltraps>

80108b8f <vector191>:
.globl vector191
vector191:
  pushl $0
80108b8f:	6a 00                	push   $0x0
  pushl $191
80108b91:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108b96:	e9 63 f2 ff ff       	jmp    80107dfe <alltraps>

80108b9b <vector192>:
.globl vector192
vector192:
  pushl $0
80108b9b:	6a 00                	push   $0x0
  pushl $192
80108b9d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108ba2:	e9 57 f2 ff ff       	jmp    80107dfe <alltraps>

80108ba7 <vector193>:
.globl vector193
vector193:
  pushl $0
80108ba7:	6a 00                	push   $0x0
  pushl $193
80108ba9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108bae:	e9 4b f2 ff ff       	jmp    80107dfe <alltraps>

80108bb3 <vector194>:
.globl vector194
vector194:
  pushl $0
80108bb3:	6a 00                	push   $0x0
  pushl $194
80108bb5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108bba:	e9 3f f2 ff ff       	jmp    80107dfe <alltraps>

80108bbf <vector195>:
.globl vector195
vector195:
  pushl $0
80108bbf:	6a 00                	push   $0x0
  pushl $195
80108bc1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108bc6:	e9 33 f2 ff ff       	jmp    80107dfe <alltraps>

80108bcb <vector196>:
.globl vector196
vector196:
  pushl $0
80108bcb:	6a 00                	push   $0x0
  pushl $196
80108bcd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108bd2:	e9 27 f2 ff ff       	jmp    80107dfe <alltraps>

80108bd7 <vector197>:
.globl vector197
vector197:
  pushl $0
80108bd7:	6a 00                	push   $0x0
  pushl $197
80108bd9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108bde:	e9 1b f2 ff ff       	jmp    80107dfe <alltraps>

80108be3 <vector198>:
.globl vector198
vector198:
  pushl $0
80108be3:	6a 00                	push   $0x0
  pushl $198
80108be5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108bea:	e9 0f f2 ff ff       	jmp    80107dfe <alltraps>

80108bef <vector199>:
.globl vector199
vector199:
  pushl $0
80108bef:	6a 00                	push   $0x0
  pushl $199
80108bf1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108bf6:	e9 03 f2 ff ff       	jmp    80107dfe <alltraps>

80108bfb <vector200>:
.globl vector200
vector200:
  pushl $0
80108bfb:	6a 00                	push   $0x0
  pushl $200
80108bfd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108c02:	e9 f7 f1 ff ff       	jmp    80107dfe <alltraps>

80108c07 <vector201>:
.globl vector201
vector201:
  pushl $0
80108c07:	6a 00                	push   $0x0
  pushl $201
80108c09:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108c0e:	e9 eb f1 ff ff       	jmp    80107dfe <alltraps>

80108c13 <vector202>:
.globl vector202
vector202:
  pushl $0
80108c13:	6a 00                	push   $0x0
  pushl $202
80108c15:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108c1a:	e9 df f1 ff ff       	jmp    80107dfe <alltraps>

80108c1f <vector203>:
.globl vector203
vector203:
  pushl $0
80108c1f:	6a 00                	push   $0x0
  pushl $203
80108c21:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108c26:	e9 d3 f1 ff ff       	jmp    80107dfe <alltraps>

80108c2b <vector204>:
.globl vector204
vector204:
  pushl $0
80108c2b:	6a 00                	push   $0x0
  pushl $204
80108c2d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108c32:	e9 c7 f1 ff ff       	jmp    80107dfe <alltraps>

80108c37 <vector205>:
.globl vector205
vector205:
  pushl $0
80108c37:	6a 00                	push   $0x0
  pushl $205
80108c39:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108c3e:	e9 bb f1 ff ff       	jmp    80107dfe <alltraps>

80108c43 <vector206>:
.globl vector206
vector206:
  pushl $0
80108c43:	6a 00                	push   $0x0
  pushl $206
80108c45:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108c4a:	e9 af f1 ff ff       	jmp    80107dfe <alltraps>

80108c4f <vector207>:
.globl vector207
vector207:
  pushl $0
80108c4f:	6a 00                	push   $0x0
  pushl $207
80108c51:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108c56:	e9 a3 f1 ff ff       	jmp    80107dfe <alltraps>

80108c5b <vector208>:
.globl vector208
vector208:
  pushl $0
80108c5b:	6a 00                	push   $0x0
  pushl $208
80108c5d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108c62:	e9 97 f1 ff ff       	jmp    80107dfe <alltraps>

80108c67 <vector209>:
.globl vector209
vector209:
  pushl $0
80108c67:	6a 00                	push   $0x0
  pushl $209
80108c69:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108c6e:	e9 8b f1 ff ff       	jmp    80107dfe <alltraps>

80108c73 <vector210>:
.globl vector210
vector210:
  pushl $0
80108c73:	6a 00                	push   $0x0
  pushl $210
80108c75:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108c7a:	e9 7f f1 ff ff       	jmp    80107dfe <alltraps>

80108c7f <vector211>:
.globl vector211
vector211:
  pushl $0
80108c7f:	6a 00                	push   $0x0
  pushl $211
80108c81:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108c86:	e9 73 f1 ff ff       	jmp    80107dfe <alltraps>

80108c8b <vector212>:
.globl vector212
vector212:
  pushl $0
80108c8b:	6a 00                	push   $0x0
  pushl $212
80108c8d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108c92:	e9 67 f1 ff ff       	jmp    80107dfe <alltraps>

80108c97 <vector213>:
.globl vector213
vector213:
  pushl $0
80108c97:	6a 00                	push   $0x0
  pushl $213
80108c99:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108c9e:	e9 5b f1 ff ff       	jmp    80107dfe <alltraps>

80108ca3 <vector214>:
.globl vector214
vector214:
  pushl $0
80108ca3:	6a 00                	push   $0x0
  pushl $214
80108ca5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108caa:	e9 4f f1 ff ff       	jmp    80107dfe <alltraps>

80108caf <vector215>:
.globl vector215
vector215:
  pushl $0
80108caf:	6a 00                	push   $0x0
  pushl $215
80108cb1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108cb6:	e9 43 f1 ff ff       	jmp    80107dfe <alltraps>

80108cbb <vector216>:
.globl vector216
vector216:
  pushl $0
80108cbb:	6a 00                	push   $0x0
  pushl $216
80108cbd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108cc2:	e9 37 f1 ff ff       	jmp    80107dfe <alltraps>

80108cc7 <vector217>:
.globl vector217
vector217:
  pushl $0
80108cc7:	6a 00                	push   $0x0
  pushl $217
80108cc9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108cce:	e9 2b f1 ff ff       	jmp    80107dfe <alltraps>

80108cd3 <vector218>:
.globl vector218
vector218:
  pushl $0
80108cd3:	6a 00                	push   $0x0
  pushl $218
80108cd5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108cda:	e9 1f f1 ff ff       	jmp    80107dfe <alltraps>

80108cdf <vector219>:
.globl vector219
vector219:
  pushl $0
80108cdf:	6a 00                	push   $0x0
  pushl $219
80108ce1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108ce6:	e9 13 f1 ff ff       	jmp    80107dfe <alltraps>

80108ceb <vector220>:
.globl vector220
vector220:
  pushl $0
80108ceb:	6a 00                	push   $0x0
  pushl $220
80108ced:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108cf2:	e9 07 f1 ff ff       	jmp    80107dfe <alltraps>

80108cf7 <vector221>:
.globl vector221
vector221:
  pushl $0
80108cf7:	6a 00                	push   $0x0
  pushl $221
80108cf9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108cfe:	e9 fb f0 ff ff       	jmp    80107dfe <alltraps>

80108d03 <vector222>:
.globl vector222
vector222:
  pushl $0
80108d03:	6a 00                	push   $0x0
  pushl $222
80108d05:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108d0a:	e9 ef f0 ff ff       	jmp    80107dfe <alltraps>

80108d0f <vector223>:
.globl vector223
vector223:
  pushl $0
80108d0f:	6a 00                	push   $0x0
  pushl $223
80108d11:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108d16:	e9 e3 f0 ff ff       	jmp    80107dfe <alltraps>

80108d1b <vector224>:
.globl vector224
vector224:
  pushl $0
80108d1b:	6a 00                	push   $0x0
  pushl $224
80108d1d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108d22:	e9 d7 f0 ff ff       	jmp    80107dfe <alltraps>

80108d27 <vector225>:
.globl vector225
vector225:
  pushl $0
80108d27:	6a 00                	push   $0x0
  pushl $225
80108d29:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108d2e:	e9 cb f0 ff ff       	jmp    80107dfe <alltraps>

80108d33 <vector226>:
.globl vector226
vector226:
  pushl $0
80108d33:	6a 00                	push   $0x0
  pushl $226
80108d35:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108d3a:	e9 bf f0 ff ff       	jmp    80107dfe <alltraps>

80108d3f <vector227>:
.globl vector227
vector227:
  pushl $0
80108d3f:	6a 00                	push   $0x0
  pushl $227
80108d41:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108d46:	e9 b3 f0 ff ff       	jmp    80107dfe <alltraps>

80108d4b <vector228>:
.globl vector228
vector228:
  pushl $0
80108d4b:	6a 00                	push   $0x0
  pushl $228
80108d4d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108d52:	e9 a7 f0 ff ff       	jmp    80107dfe <alltraps>

80108d57 <vector229>:
.globl vector229
vector229:
  pushl $0
80108d57:	6a 00                	push   $0x0
  pushl $229
80108d59:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108d5e:	e9 9b f0 ff ff       	jmp    80107dfe <alltraps>

80108d63 <vector230>:
.globl vector230
vector230:
  pushl $0
80108d63:	6a 00                	push   $0x0
  pushl $230
80108d65:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108d6a:	e9 8f f0 ff ff       	jmp    80107dfe <alltraps>

80108d6f <vector231>:
.globl vector231
vector231:
  pushl $0
80108d6f:	6a 00                	push   $0x0
  pushl $231
80108d71:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108d76:	e9 83 f0 ff ff       	jmp    80107dfe <alltraps>

80108d7b <vector232>:
.globl vector232
vector232:
  pushl $0
80108d7b:	6a 00                	push   $0x0
  pushl $232
80108d7d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108d82:	e9 77 f0 ff ff       	jmp    80107dfe <alltraps>

80108d87 <vector233>:
.globl vector233
vector233:
  pushl $0
80108d87:	6a 00                	push   $0x0
  pushl $233
80108d89:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108d8e:	e9 6b f0 ff ff       	jmp    80107dfe <alltraps>

80108d93 <vector234>:
.globl vector234
vector234:
  pushl $0
80108d93:	6a 00                	push   $0x0
  pushl $234
80108d95:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108d9a:	e9 5f f0 ff ff       	jmp    80107dfe <alltraps>

80108d9f <vector235>:
.globl vector235
vector235:
  pushl $0
80108d9f:	6a 00                	push   $0x0
  pushl $235
80108da1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108da6:	e9 53 f0 ff ff       	jmp    80107dfe <alltraps>

80108dab <vector236>:
.globl vector236
vector236:
  pushl $0
80108dab:	6a 00                	push   $0x0
  pushl $236
80108dad:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108db2:	e9 47 f0 ff ff       	jmp    80107dfe <alltraps>

80108db7 <vector237>:
.globl vector237
vector237:
  pushl $0
80108db7:	6a 00                	push   $0x0
  pushl $237
80108db9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108dbe:	e9 3b f0 ff ff       	jmp    80107dfe <alltraps>

80108dc3 <vector238>:
.globl vector238
vector238:
  pushl $0
80108dc3:	6a 00                	push   $0x0
  pushl $238
80108dc5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108dca:	e9 2f f0 ff ff       	jmp    80107dfe <alltraps>

80108dcf <vector239>:
.globl vector239
vector239:
  pushl $0
80108dcf:	6a 00                	push   $0x0
  pushl $239
80108dd1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108dd6:	e9 23 f0 ff ff       	jmp    80107dfe <alltraps>

80108ddb <vector240>:
.globl vector240
vector240:
  pushl $0
80108ddb:	6a 00                	push   $0x0
  pushl $240
80108ddd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108de2:	e9 17 f0 ff ff       	jmp    80107dfe <alltraps>

80108de7 <vector241>:
.globl vector241
vector241:
  pushl $0
80108de7:	6a 00                	push   $0x0
  pushl $241
80108de9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108dee:	e9 0b f0 ff ff       	jmp    80107dfe <alltraps>

80108df3 <vector242>:
.globl vector242
vector242:
  pushl $0
80108df3:	6a 00                	push   $0x0
  pushl $242
80108df5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108dfa:	e9 ff ef ff ff       	jmp    80107dfe <alltraps>

80108dff <vector243>:
.globl vector243
vector243:
  pushl $0
80108dff:	6a 00                	push   $0x0
  pushl $243
80108e01:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108e06:	e9 f3 ef ff ff       	jmp    80107dfe <alltraps>

80108e0b <vector244>:
.globl vector244
vector244:
  pushl $0
80108e0b:	6a 00                	push   $0x0
  pushl $244
80108e0d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108e12:	e9 e7 ef ff ff       	jmp    80107dfe <alltraps>

80108e17 <vector245>:
.globl vector245
vector245:
  pushl $0
80108e17:	6a 00                	push   $0x0
  pushl $245
80108e19:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108e1e:	e9 db ef ff ff       	jmp    80107dfe <alltraps>

80108e23 <vector246>:
.globl vector246
vector246:
  pushl $0
80108e23:	6a 00                	push   $0x0
  pushl $246
80108e25:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108e2a:	e9 cf ef ff ff       	jmp    80107dfe <alltraps>

80108e2f <vector247>:
.globl vector247
vector247:
  pushl $0
80108e2f:	6a 00                	push   $0x0
  pushl $247
80108e31:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108e36:	e9 c3 ef ff ff       	jmp    80107dfe <alltraps>

80108e3b <vector248>:
.globl vector248
vector248:
  pushl $0
80108e3b:	6a 00                	push   $0x0
  pushl $248
80108e3d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108e42:	e9 b7 ef ff ff       	jmp    80107dfe <alltraps>

80108e47 <vector249>:
.globl vector249
vector249:
  pushl $0
80108e47:	6a 00                	push   $0x0
  pushl $249
80108e49:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108e4e:	e9 ab ef ff ff       	jmp    80107dfe <alltraps>

80108e53 <vector250>:
.globl vector250
vector250:
  pushl $0
80108e53:	6a 00                	push   $0x0
  pushl $250
80108e55:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108e5a:	e9 9f ef ff ff       	jmp    80107dfe <alltraps>

80108e5f <vector251>:
.globl vector251
vector251:
  pushl $0
80108e5f:	6a 00                	push   $0x0
  pushl $251
80108e61:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108e66:	e9 93 ef ff ff       	jmp    80107dfe <alltraps>

80108e6b <vector252>:
.globl vector252
vector252:
  pushl $0
80108e6b:	6a 00                	push   $0x0
  pushl $252
80108e6d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108e72:	e9 87 ef ff ff       	jmp    80107dfe <alltraps>

80108e77 <vector253>:
.globl vector253
vector253:
  pushl $0
80108e77:	6a 00                	push   $0x0
  pushl $253
80108e79:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108e7e:	e9 7b ef ff ff       	jmp    80107dfe <alltraps>

80108e83 <vector254>:
.globl vector254
vector254:
  pushl $0
80108e83:	6a 00                	push   $0x0
  pushl $254
80108e85:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108e8a:	e9 6f ef ff ff       	jmp    80107dfe <alltraps>

80108e8f <vector255>:
.globl vector255
vector255:
  pushl $0
80108e8f:	6a 00                	push   $0x0
  pushl $255
80108e91:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108e96:	e9 63 ef ff ff       	jmp    80107dfe <alltraps>

80108e9b <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108e9b:	55                   	push   %ebp
80108e9c:	89 e5                	mov    %esp,%ebp
80108e9e:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ea4:	83 e8 01             	sub    $0x1,%eax
80108ea7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108eab:	8b 45 08             	mov    0x8(%ebp),%eax
80108eae:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80108eb5:	c1 e8 10             	shr    $0x10,%eax
80108eb8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108ebc:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108ebf:	0f 01 10             	lgdtl  (%eax)
}
80108ec2:	90                   	nop
80108ec3:	c9                   	leave  
80108ec4:	c3                   	ret    

80108ec5 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108ec5:	55                   	push   %ebp
80108ec6:	89 e5                	mov    %esp,%ebp
80108ec8:	83 ec 04             	sub    $0x4,%esp
80108ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80108ece:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108ed2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108ed6:	0f 00 d8             	ltr    %ax
}
80108ed9:	90                   	nop
80108eda:	c9                   	leave  
80108edb:	c3                   	ret    

80108edc <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108edc:	55                   	push   %ebp
80108edd:	89 e5                	mov    %esp,%ebp
80108edf:	83 ec 04             	sub    $0x4,%esp
80108ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80108ee5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108ee9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108eed:	8e e8                	mov    %eax,%gs
}
80108eef:	90                   	nop
80108ef0:	c9                   	leave  
80108ef1:	c3                   	ret    

80108ef2 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108ef2:	55                   	push   %ebp
80108ef3:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80108ef8:	0f 22 d8             	mov    %eax,%cr3
}
80108efb:	90                   	nop
80108efc:	5d                   	pop    %ebp
80108efd:	c3                   	ret    

80108efe <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108efe:	55                   	push   %ebp
80108eff:	89 e5                	mov    %esp,%ebp
80108f01:	8b 45 08             	mov    0x8(%ebp),%eax
80108f04:	05 00 00 00 80       	add    $0x80000000,%eax
80108f09:	5d                   	pop    %ebp
80108f0a:	c3                   	ret    

80108f0b <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108f0b:	55                   	push   %ebp
80108f0c:	89 e5                	mov    %esp,%ebp
80108f0e:	8b 45 08             	mov    0x8(%ebp),%eax
80108f11:	05 00 00 00 80       	add    $0x80000000,%eax
80108f16:	5d                   	pop    %ebp
80108f17:	c3                   	ret    

80108f18 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108f18:	55                   	push   %ebp
80108f19:	89 e5                	mov    %esp,%ebp
80108f1b:	53                   	push   %ebx
80108f1c:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108f1f:	e8 52 a1 ff ff       	call   80103076 <cpunum>
80108f24:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108f2a:	05 80 43 11 80       	add    $0x80114380,%eax
80108f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f35:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f3e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f47:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f4e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108f52:	83 e2 f0             	and    $0xfffffff0,%edx
80108f55:	83 ca 0a             	or     $0xa,%edx
80108f58:	88 50 7d             	mov    %dl,0x7d(%eax)
80108f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f5e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108f62:	83 ca 10             	or     $0x10,%edx
80108f65:	88 50 7d             	mov    %dl,0x7d(%eax)
80108f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f6b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108f6f:	83 e2 9f             	and    $0xffffff9f,%edx
80108f72:	88 50 7d             	mov    %dl,0x7d(%eax)
80108f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f78:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108f7c:	83 ca 80             	or     $0xffffff80,%edx
80108f7f:	88 50 7d             	mov    %dl,0x7d(%eax)
80108f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f85:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108f89:	83 ca 0f             	or     $0xf,%edx
80108f8c:	88 50 7e             	mov    %dl,0x7e(%eax)
80108f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f92:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108f96:	83 e2 ef             	and    $0xffffffef,%edx
80108f99:	88 50 7e             	mov    %dl,0x7e(%eax)
80108f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f9f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108fa3:	83 e2 df             	and    $0xffffffdf,%edx
80108fa6:	88 50 7e             	mov    %dl,0x7e(%eax)
80108fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fac:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108fb0:	83 ca 40             	or     $0x40,%edx
80108fb3:	88 50 7e             	mov    %dl,0x7e(%eax)
80108fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fb9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108fbd:	83 ca 80             	or     $0xffffff80,%edx
80108fc0:	88 50 7e             	mov    %dl,0x7e(%eax)
80108fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc6:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fcd:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108fd4:	ff ff 
80108fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fd9:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108fe0:	00 00 
80108fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fe5:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fef:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108ff6:	83 e2 f0             	and    $0xfffffff0,%edx
80108ff9:	83 ca 02             	or     $0x2,%edx
80108ffc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109002:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109005:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010900c:	83 ca 10             	or     $0x10,%edx
8010900f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109018:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010901f:	83 e2 9f             	and    $0xffffff9f,%edx
80109022:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109028:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010902b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109032:	83 ca 80             	or     $0xffffff80,%edx
80109035:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010903b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010903e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109045:	83 ca 0f             	or     $0xf,%edx
80109048:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010904e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109051:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109058:	83 e2 ef             	and    $0xffffffef,%edx
8010905b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109064:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010906b:	83 e2 df             	and    $0xffffffdf,%edx
8010906e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109074:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109077:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010907e:	83 ca 40             	or     $0x40,%edx
80109081:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010908a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109091:	83 ca 80             	or     $0xffffff80,%edx
80109094:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010909a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010909d:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801090a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090a7:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801090ae:	ff ff 
801090b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090b3:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801090ba:	00 00 
801090bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090bf:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801090c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090c9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801090d0:	83 e2 f0             	and    $0xfffffff0,%edx
801090d3:	83 ca 0a             	or     $0xa,%edx
801090d6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801090dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090df:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801090e6:	83 ca 10             	or     $0x10,%edx
801090e9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801090ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090f2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801090f9:	83 ca 60             	or     $0x60,%edx
801090fc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109105:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010910c:	83 ca 80             	or     $0xffffff80,%edx
8010910f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109118:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010911f:	83 ca 0f             	or     $0xf,%edx
80109122:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010912b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109132:	83 e2 ef             	and    $0xffffffef,%edx
80109135:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010913b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010913e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109145:	83 e2 df             	and    $0xffffffdf,%edx
80109148:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010914e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109151:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109158:	83 ca 40             	or     $0x40,%edx
8010915b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109164:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010916b:	83 ca 80             	or     $0xffffff80,%edx
8010916e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109177:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010917e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109181:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80109188:	ff ff 
8010918a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010918d:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80109194:	00 00 
80109196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109199:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801091a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091a3:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801091aa:	83 e2 f0             	and    $0xfffffff0,%edx
801091ad:	83 ca 02             	or     $0x2,%edx
801091b0:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801091b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091b9:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801091c0:	83 ca 10             	or     $0x10,%edx
801091c3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801091c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091cc:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801091d3:	83 ca 60             	or     $0x60,%edx
801091d6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801091dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091df:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801091e6:	83 ca 80             	or     $0xffffff80,%edx
801091e9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801091ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091f2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801091f9:	83 ca 0f             	or     $0xf,%edx
801091fc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109205:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010920c:	83 e2 ef             	and    $0xffffffef,%edx
8010920f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109215:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109218:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010921f:	83 e2 df             	and    $0xffffffdf,%edx
80109222:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010922b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109232:	83 ca 40             	or     $0x40,%edx
80109235:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010923b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010923e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109245:	83 ca 80             	or     $0xffffff80,%edx
80109248:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010924e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109251:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80109258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010925b:	05 b4 00 00 00       	add    $0xb4,%eax
80109260:	89 c3                	mov    %eax,%ebx
80109262:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109265:	05 b4 00 00 00       	add    $0xb4,%eax
8010926a:	c1 e8 10             	shr    $0x10,%eax
8010926d:	89 c2                	mov    %eax,%edx
8010926f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109272:	05 b4 00 00 00       	add    $0xb4,%eax
80109277:	c1 e8 18             	shr    $0x18,%eax
8010927a:	89 c1                	mov    %eax,%ecx
8010927c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010927f:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80109286:	00 00 
80109288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010928b:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80109292:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109295:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
8010929b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010929e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801092a5:	83 e2 f0             	and    $0xfffffff0,%edx
801092a8:	83 ca 02             	or     $0x2,%edx
801092ab:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801092b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092b4:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801092bb:	83 ca 10             	or     $0x10,%edx
801092be:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801092c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092c7:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801092ce:	83 e2 9f             	and    $0xffffff9f,%edx
801092d1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801092d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092da:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801092e1:	83 ca 80             	or     $0xffffff80,%edx
801092e4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801092ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092ed:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801092f4:	83 e2 f0             	and    $0xfffffff0,%edx
801092f7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801092fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109300:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109307:	83 e2 ef             	and    $0xffffffef,%edx
8010930a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109313:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010931a:	83 e2 df             	and    $0xffffffdf,%edx
8010931d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109326:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010932d:	83 ca 40             	or     $0x40,%edx
80109330:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109339:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109340:	83 ca 80             	or     $0xffffff80,%edx
80109343:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010934c:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80109352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109355:	83 c0 70             	add    $0x70,%eax
80109358:	83 ec 08             	sub    $0x8,%esp
8010935b:	6a 38                	push   $0x38
8010935d:	50                   	push   %eax
8010935e:	e8 38 fb ff ff       	call   80108e9b <lgdt>
80109363:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80109366:	83 ec 0c             	sub    $0xc,%esp
80109369:	6a 18                	push   $0x18
8010936b:	e8 6c fb ff ff       	call   80108edc <loadgs>
80109370:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80109373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109376:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010937c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109383:	00 00 00 00 
}
80109387:	90                   	nop
80109388:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010938b:	c9                   	leave  
8010938c:	c3                   	ret    

8010938d <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010938d:	55                   	push   %ebp
8010938e:	89 e5                	mov    %esp,%ebp
80109390:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80109393:	8b 45 0c             	mov    0xc(%ebp),%eax
80109396:	c1 e8 16             	shr    $0x16,%eax
80109399:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801093a0:	8b 45 08             	mov    0x8(%ebp),%eax
801093a3:	01 d0                	add    %edx,%eax
801093a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801093a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093ab:	8b 00                	mov    (%eax),%eax
801093ad:	83 e0 01             	and    $0x1,%eax
801093b0:	85 c0                	test   %eax,%eax
801093b2:	74 18                	je     801093cc <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801093b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093b7:	8b 00                	mov    (%eax),%eax
801093b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801093be:	50                   	push   %eax
801093bf:	e8 47 fb ff ff       	call   80108f0b <p2v>
801093c4:	83 c4 04             	add    $0x4,%esp
801093c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801093ca:	eb 48                	jmp    80109414 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801093cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801093d0:	74 0e                	je     801093e0 <walkpgdir+0x53>
801093d2:	e8 39 99 ff ff       	call   80102d10 <kalloc>
801093d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801093da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801093de:	75 07                	jne    801093e7 <walkpgdir+0x5a>
      return 0;
801093e0:	b8 00 00 00 00       	mov    $0x0,%eax
801093e5:	eb 44                	jmp    8010942b <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801093e7:	83 ec 04             	sub    $0x4,%esp
801093ea:	68 00 10 00 00       	push   $0x1000
801093ef:	6a 00                	push   $0x0
801093f1:	ff 75 f4             	pushl  -0xc(%ebp)
801093f4:	e8 b0 d4 ff ff       	call   801068a9 <memset>
801093f9:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801093fc:	83 ec 0c             	sub    $0xc,%esp
801093ff:	ff 75 f4             	pushl  -0xc(%ebp)
80109402:	e8 f7 fa ff ff       	call   80108efe <v2p>
80109407:	83 c4 10             	add    $0x10,%esp
8010940a:	83 c8 07             	or     $0x7,%eax
8010940d:	89 c2                	mov    %eax,%edx
8010940f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109412:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80109414:	8b 45 0c             	mov    0xc(%ebp),%eax
80109417:	c1 e8 0c             	shr    $0xc,%eax
8010941a:	25 ff 03 00 00       	and    $0x3ff,%eax
8010941f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109429:	01 d0                	add    %edx,%eax
}
8010942b:	c9                   	leave  
8010942c:	c3                   	ret    

8010942d <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010942d:	55                   	push   %ebp
8010942e:	89 e5                	mov    %esp,%ebp
80109430:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80109433:	8b 45 0c             	mov    0xc(%ebp),%eax
80109436:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010943b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010943e:	8b 55 0c             	mov    0xc(%ebp),%edx
80109441:	8b 45 10             	mov    0x10(%ebp),%eax
80109444:	01 d0                	add    %edx,%eax
80109446:	83 e8 01             	sub    $0x1,%eax
80109449:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010944e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80109451:	83 ec 04             	sub    $0x4,%esp
80109454:	6a 01                	push   $0x1
80109456:	ff 75 f4             	pushl  -0xc(%ebp)
80109459:	ff 75 08             	pushl  0x8(%ebp)
8010945c:	e8 2c ff ff ff       	call   8010938d <walkpgdir>
80109461:	83 c4 10             	add    $0x10,%esp
80109464:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109467:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010946b:	75 07                	jne    80109474 <mappages+0x47>
      return -1;
8010946d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109472:	eb 47                	jmp    801094bb <mappages+0x8e>
    if(*pte & PTE_P)
80109474:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109477:	8b 00                	mov    (%eax),%eax
80109479:	83 e0 01             	and    $0x1,%eax
8010947c:	85 c0                	test   %eax,%eax
8010947e:	74 0d                	je     8010948d <mappages+0x60>
      panic("remap");
80109480:	83 ec 0c             	sub    $0xc,%esp
80109483:	68 bc a4 10 80       	push   $0x8010a4bc
80109488:	e8 d9 70 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
8010948d:	8b 45 18             	mov    0x18(%ebp),%eax
80109490:	0b 45 14             	or     0x14(%ebp),%eax
80109493:	83 c8 01             	or     $0x1,%eax
80109496:	89 c2                	mov    %eax,%edx
80109498:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010949b:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010949d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801094a3:	74 10                	je     801094b5 <mappages+0x88>
      break;
    a += PGSIZE;
801094a5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801094ac:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801094b3:	eb 9c                	jmp    80109451 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801094b5:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801094b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801094bb:	c9                   	leave  
801094bc:	c3                   	ret    

801094bd <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801094bd:	55                   	push   %ebp
801094be:	89 e5                	mov    %esp,%ebp
801094c0:	53                   	push   %ebx
801094c1:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801094c4:	e8 47 98 ff ff       	call   80102d10 <kalloc>
801094c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801094cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801094d0:	75 0a                	jne    801094dc <setupkvm+0x1f>
    return 0;
801094d2:	b8 00 00 00 00       	mov    $0x0,%eax
801094d7:	e9 8e 00 00 00       	jmp    8010956a <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801094dc:	83 ec 04             	sub    $0x4,%esp
801094df:	68 00 10 00 00       	push   $0x1000
801094e4:	6a 00                	push   $0x0
801094e6:	ff 75 f0             	pushl  -0x10(%ebp)
801094e9:	e8 bb d3 ff ff       	call   801068a9 <memset>
801094ee:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801094f1:	83 ec 0c             	sub    $0xc,%esp
801094f4:	68 00 00 00 0e       	push   $0xe000000
801094f9:	e8 0d fa ff ff       	call   80108f0b <p2v>
801094fe:	83 c4 10             	add    $0x10,%esp
80109501:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80109506:	76 0d                	jbe    80109515 <setupkvm+0x58>
    panic("PHYSTOP too high");
80109508:	83 ec 0c             	sub    $0xc,%esp
8010950b:	68 c2 a4 10 80       	push   $0x8010a4c2
80109510:	e8 51 70 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109515:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
8010951c:	eb 40                	jmp    8010955e <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010951e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109521:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80109524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109527:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010952a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010952d:	8b 58 08             	mov    0x8(%eax),%ebx
80109530:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109533:	8b 40 04             	mov    0x4(%eax),%eax
80109536:	29 c3                	sub    %eax,%ebx
80109538:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010953b:	8b 00                	mov    (%eax),%eax
8010953d:	83 ec 0c             	sub    $0xc,%esp
80109540:	51                   	push   %ecx
80109541:	52                   	push   %edx
80109542:	53                   	push   %ebx
80109543:	50                   	push   %eax
80109544:	ff 75 f0             	pushl  -0x10(%ebp)
80109547:	e8 e1 fe ff ff       	call   8010942d <mappages>
8010954c:	83 c4 20             	add    $0x20,%esp
8010954f:	85 c0                	test   %eax,%eax
80109551:	79 07                	jns    8010955a <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109553:	b8 00 00 00 00       	mov    $0x0,%eax
80109558:	eb 10                	jmp    8010956a <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010955a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010955e:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
80109565:	72 b7                	jb     8010951e <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109567:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010956a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010956d:	c9                   	leave  
8010956e:	c3                   	ret    

8010956f <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010956f:	55                   	push   %ebp
80109570:	89 e5                	mov    %esp,%ebp
80109572:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109575:	e8 43 ff ff ff       	call   801094bd <setupkvm>
8010957a:	a3 58 79 11 80       	mov    %eax,0x80117958
  switchkvm();
8010957f:	e8 03 00 00 00       	call   80109587 <switchkvm>
}
80109584:	90                   	nop
80109585:	c9                   	leave  
80109586:	c3                   	ret    

80109587 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109587:	55                   	push   %ebp
80109588:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010958a:	a1 58 79 11 80       	mov    0x80117958,%eax
8010958f:	50                   	push   %eax
80109590:	e8 69 f9 ff ff       	call   80108efe <v2p>
80109595:	83 c4 04             	add    $0x4,%esp
80109598:	50                   	push   %eax
80109599:	e8 54 f9 ff ff       	call   80108ef2 <lcr3>
8010959e:	83 c4 04             	add    $0x4,%esp
}
801095a1:	90                   	nop
801095a2:	c9                   	leave  
801095a3:	c3                   	ret    

801095a4 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801095a4:	55                   	push   %ebp
801095a5:	89 e5                	mov    %esp,%ebp
801095a7:	56                   	push   %esi
801095a8:	53                   	push   %ebx
  pushcli();
801095a9:	e8 f5 d1 ff ff       	call   801067a3 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801095ae:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801095b4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801095bb:	83 c2 08             	add    $0x8,%edx
801095be:	89 d6                	mov    %edx,%esi
801095c0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801095c7:	83 c2 08             	add    $0x8,%edx
801095ca:	c1 ea 10             	shr    $0x10,%edx
801095cd:	89 d3                	mov    %edx,%ebx
801095cf:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801095d6:	83 c2 08             	add    $0x8,%edx
801095d9:	c1 ea 18             	shr    $0x18,%edx
801095dc:	89 d1                	mov    %edx,%ecx
801095de:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801095e5:	67 00 
801095e7:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801095ee:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801095f4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801095fb:	83 e2 f0             	and    $0xfffffff0,%edx
801095fe:	83 ca 09             	or     $0x9,%edx
80109601:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109607:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010960e:	83 ca 10             	or     $0x10,%edx
80109611:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109617:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010961e:	83 e2 9f             	and    $0xffffff9f,%edx
80109621:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109627:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010962e:	83 ca 80             	or     $0xffffff80,%edx
80109631:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109637:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010963e:	83 e2 f0             	and    $0xfffffff0,%edx
80109641:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109647:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010964e:	83 e2 ef             	and    $0xffffffef,%edx
80109651:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109657:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010965e:	83 e2 df             	and    $0xffffffdf,%edx
80109661:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109667:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010966e:	83 ca 40             	or     $0x40,%edx
80109671:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109677:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010967e:	83 e2 7f             	and    $0x7f,%edx
80109681:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109687:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010968d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109693:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010969a:	83 e2 ef             	and    $0xffffffef,%edx
8010969d:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801096a3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801096a9:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801096af:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801096b5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801096bc:	8b 52 08             	mov    0x8(%edx),%edx
801096bf:	81 c2 00 10 00 00    	add    $0x1000,%edx
801096c5:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801096c8:	83 ec 0c             	sub    $0xc,%esp
801096cb:	6a 30                	push   $0x30
801096cd:	e8 f3 f7 ff ff       	call   80108ec5 <ltr>
801096d2:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801096d5:	8b 45 08             	mov    0x8(%ebp),%eax
801096d8:	8b 40 04             	mov    0x4(%eax),%eax
801096db:	85 c0                	test   %eax,%eax
801096dd:	75 0d                	jne    801096ec <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801096df:	83 ec 0c             	sub    $0xc,%esp
801096e2:	68 d3 a4 10 80       	push   $0x8010a4d3
801096e7:	e8 7a 6e ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801096ec:	8b 45 08             	mov    0x8(%ebp),%eax
801096ef:	8b 40 04             	mov    0x4(%eax),%eax
801096f2:	83 ec 0c             	sub    $0xc,%esp
801096f5:	50                   	push   %eax
801096f6:	e8 03 f8 ff ff       	call   80108efe <v2p>
801096fb:	83 c4 10             	add    $0x10,%esp
801096fe:	83 ec 0c             	sub    $0xc,%esp
80109701:	50                   	push   %eax
80109702:	e8 eb f7 ff ff       	call   80108ef2 <lcr3>
80109707:	83 c4 10             	add    $0x10,%esp
  popcli();
8010970a:	e8 d9 d0 ff ff       	call   801067e8 <popcli>
}
8010970f:	90                   	nop
80109710:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109713:	5b                   	pop    %ebx
80109714:	5e                   	pop    %esi
80109715:	5d                   	pop    %ebp
80109716:	c3                   	ret    

80109717 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109717:	55                   	push   %ebp
80109718:	89 e5                	mov    %esp,%ebp
8010971a:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010971d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109724:	76 0d                	jbe    80109733 <inituvm+0x1c>
    panic("inituvm: more than a page");
80109726:	83 ec 0c             	sub    $0xc,%esp
80109729:	68 e7 a4 10 80       	push   $0x8010a4e7
8010972e:	e8 33 6e ff ff       	call   80100566 <panic>
  mem = kalloc();
80109733:	e8 d8 95 ff ff       	call   80102d10 <kalloc>
80109738:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010973b:	83 ec 04             	sub    $0x4,%esp
8010973e:	68 00 10 00 00       	push   $0x1000
80109743:	6a 00                	push   $0x0
80109745:	ff 75 f4             	pushl  -0xc(%ebp)
80109748:	e8 5c d1 ff ff       	call   801068a9 <memset>
8010974d:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109750:	83 ec 0c             	sub    $0xc,%esp
80109753:	ff 75 f4             	pushl  -0xc(%ebp)
80109756:	e8 a3 f7 ff ff       	call   80108efe <v2p>
8010975b:	83 c4 10             	add    $0x10,%esp
8010975e:	83 ec 0c             	sub    $0xc,%esp
80109761:	6a 06                	push   $0x6
80109763:	50                   	push   %eax
80109764:	68 00 10 00 00       	push   $0x1000
80109769:	6a 00                	push   $0x0
8010976b:	ff 75 08             	pushl  0x8(%ebp)
8010976e:	e8 ba fc ff ff       	call   8010942d <mappages>
80109773:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109776:	83 ec 04             	sub    $0x4,%esp
80109779:	ff 75 10             	pushl  0x10(%ebp)
8010977c:	ff 75 0c             	pushl  0xc(%ebp)
8010977f:	ff 75 f4             	pushl  -0xc(%ebp)
80109782:	e8 e1 d1 ff ff       	call   80106968 <memmove>
80109787:	83 c4 10             	add    $0x10,%esp
}
8010978a:	90                   	nop
8010978b:	c9                   	leave  
8010978c:	c3                   	ret    

8010978d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010978d:	55                   	push   %ebp
8010978e:	89 e5                	mov    %esp,%ebp
80109790:	53                   	push   %ebx
80109791:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109794:	8b 45 0c             	mov    0xc(%ebp),%eax
80109797:	25 ff 0f 00 00       	and    $0xfff,%eax
8010979c:	85 c0                	test   %eax,%eax
8010979e:	74 0d                	je     801097ad <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801097a0:	83 ec 0c             	sub    $0xc,%esp
801097a3:	68 04 a5 10 80       	push   $0x8010a504
801097a8:	e8 b9 6d ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801097ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801097b4:	e9 95 00 00 00       	jmp    8010984e <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801097b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801097bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097bf:	01 d0                	add    %edx,%eax
801097c1:	83 ec 04             	sub    $0x4,%esp
801097c4:	6a 00                	push   $0x0
801097c6:	50                   	push   %eax
801097c7:	ff 75 08             	pushl  0x8(%ebp)
801097ca:	e8 be fb ff ff       	call   8010938d <walkpgdir>
801097cf:	83 c4 10             	add    $0x10,%esp
801097d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801097d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801097d9:	75 0d                	jne    801097e8 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801097db:	83 ec 0c             	sub    $0xc,%esp
801097de:	68 27 a5 10 80       	push   $0x8010a527
801097e3:	e8 7e 6d ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801097e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097eb:	8b 00                	mov    (%eax),%eax
801097ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801097f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801097f5:	8b 45 18             	mov    0x18(%ebp),%eax
801097f8:	2b 45 f4             	sub    -0xc(%ebp),%eax
801097fb:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109800:	77 0b                	ja     8010980d <loaduvm+0x80>
      n = sz - i;
80109802:	8b 45 18             	mov    0x18(%ebp),%eax
80109805:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109808:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010980b:	eb 07                	jmp    80109814 <loaduvm+0x87>
    else
      n = PGSIZE;
8010980d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109814:	8b 55 14             	mov    0x14(%ebp),%edx
80109817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010981a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010981d:	83 ec 0c             	sub    $0xc,%esp
80109820:	ff 75 e8             	pushl  -0x18(%ebp)
80109823:	e8 e3 f6 ff ff       	call   80108f0b <p2v>
80109828:	83 c4 10             	add    $0x10,%esp
8010982b:	ff 75 f0             	pushl  -0x10(%ebp)
8010982e:	53                   	push   %ebx
8010982f:	50                   	push   %eax
80109830:	ff 75 10             	pushl  0x10(%ebp)
80109833:	e8 4a 87 ff ff       	call   80101f82 <readi>
80109838:	83 c4 10             	add    $0x10,%esp
8010983b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010983e:	74 07                	je     80109847 <loaduvm+0xba>
      return -1;
80109840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109845:	eb 18                	jmp    8010985f <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109847:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010984e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109851:	3b 45 18             	cmp    0x18(%ebp),%eax
80109854:	0f 82 5f ff ff ff    	jb     801097b9 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010985a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010985f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109862:	c9                   	leave  
80109863:	c3                   	ret    

80109864 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109864:	55                   	push   %ebp
80109865:	89 e5                	mov    %esp,%ebp
80109867:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010986a:	8b 45 10             	mov    0x10(%ebp),%eax
8010986d:	85 c0                	test   %eax,%eax
8010986f:	79 0a                	jns    8010987b <allocuvm+0x17>
    return 0;
80109871:	b8 00 00 00 00       	mov    $0x0,%eax
80109876:	e9 b0 00 00 00       	jmp    8010992b <allocuvm+0xc7>
  if(newsz < oldsz)
8010987b:	8b 45 10             	mov    0x10(%ebp),%eax
8010987e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109881:	73 08                	jae    8010988b <allocuvm+0x27>
    return oldsz;
80109883:	8b 45 0c             	mov    0xc(%ebp),%eax
80109886:	e9 a0 00 00 00       	jmp    8010992b <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
8010988b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010988e:	05 ff 0f 00 00       	add    $0xfff,%eax
80109893:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109898:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010989b:	eb 7f                	jmp    8010991c <allocuvm+0xb8>
    mem = kalloc();
8010989d:	e8 6e 94 ff ff       	call   80102d10 <kalloc>
801098a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801098a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801098a9:	75 2b                	jne    801098d6 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801098ab:	83 ec 0c             	sub    $0xc,%esp
801098ae:	68 45 a5 10 80       	push   $0x8010a545
801098b3:	e8 0e 6b ff ff       	call   801003c6 <cprintf>
801098b8:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801098bb:	83 ec 04             	sub    $0x4,%esp
801098be:	ff 75 0c             	pushl  0xc(%ebp)
801098c1:	ff 75 10             	pushl  0x10(%ebp)
801098c4:	ff 75 08             	pushl  0x8(%ebp)
801098c7:	e8 61 00 00 00       	call   8010992d <deallocuvm>
801098cc:	83 c4 10             	add    $0x10,%esp
      return 0;
801098cf:	b8 00 00 00 00       	mov    $0x0,%eax
801098d4:	eb 55                	jmp    8010992b <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
801098d6:	83 ec 04             	sub    $0x4,%esp
801098d9:	68 00 10 00 00       	push   $0x1000
801098de:	6a 00                	push   $0x0
801098e0:	ff 75 f0             	pushl  -0x10(%ebp)
801098e3:	e8 c1 cf ff ff       	call   801068a9 <memset>
801098e8:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801098eb:	83 ec 0c             	sub    $0xc,%esp
801098ee:	ff 75 f0             	pushl  -0x10(%ebp)
801098f1:	e8 08 f6 ff ff       	call   80108efe <v2p>
801098f6:	83 c4 10             	add    $0x10,%esp
801098f9:	89 c2                	mov    %eax,%edx
801098fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098fe:	83 ec 0c             	sub    $0xc,%esp
80109901:	6a 06                	push   $0x6
80109903:	52                   	push   %edx
80109904:	68 00 10 00 00       	push   $0x1000
80109909:	50                   	push   %eax
8010990a:	ff 75 08             	pushl  0x8(%ebp)
8010990d:	e8 1b fb ff ff       	call   8010942d <mappages>
80109912:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109915:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010991c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010991f:	3b 45 10             	cmp    0x10(%ebp),%eax
80109922:	0f 82 75 ff ff ff    	jb     8010989d <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109928:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010992b:	c9                   	leave  
8010992c:	c3                   	ret    

8010992d <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010992d:	55                   	push   %ebp
8010992e:	89 e5                	mov    %esp,%ebp
80109930:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109933:	8b 45 10             	mov    0x10(%ebp),%eax
80109936:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109939:	72 08                	jb     80109943 <deallocuvm+0x16>
    return oldsz;
8010993b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010993e:	e9 a5 00 00 00       	jmp    801099e8 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109943:	8b 45 10             	mov    0x10(%ebp),%eax
80109946:	05 ff 0f 00 00       	add    $0xfff,%eax
8010994b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109950:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109953:	e9 81 00 00 00       	jmp    801099d9 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010995b:	83 ec 04             	sub    $0x4,%esp
8010995e:	6a 00                	push   $0x0
80109960:	50                   	push   %eax
80109961:	ff 75 08             	pushl  0x8(%ebp)
80109964:	e8 24 fa ff ff       	call   8010938d <walkpgdir>
80109969:	83 c4 10             	add    $0x10,%esp
8010996c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010996f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109973:	75 09                	jne    8010997e <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109975:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010997c:	eb 54                	jmp    801099d2 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
8010997e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109981:	8b 00                	mov    (%eax),%eax
80109983:	83 e0 01             	and    $0x1,%eax
80109986:	85 c0                	test   %eax,%eax
80109988:	74 48                	je     801099d2 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
8010998a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010998d:	8b 00                	mov    (%eax),%eax
8010998f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109994:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109997:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010999b:	75 0d                	jne    801099aa <deallocuvm+0x7d>
        panic("kfree");
8010999d:	83 ec 0c             	sub    $0xc,%esp
801099a0:	68 5d a5 10 80       	push   $0x8010a55d
801099a5:	e8 bc 6b ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
801099aa:	83 ec 0c             	sub    $0xc,%esp
801099ad:	ff 75 ec             	pushl  -0x14(%ebp)
801099b0:	e8 56 f5 ff ff       	call   80108f0b <p2v>
801099b5:	83 c4 10             	add    $0x10,%esp
801099b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801099bb:	83 ec 0c             	sub    $0xc,%esp
801099be:	ff 75 e8             	pushl  -0x18(%ebp)
801099c1:	e8 ad 92 ff ff       	call   80102c73 <kfree>
801099c6:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801099c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801099d2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801099d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801099df:	0f 82 73 ff ff ff    	jb     80109958 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801099e5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801099e8:	c9                   	leave  
801099e9:	c3                   	ret    

801099ea <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801099ea:	55                   	push   %ebp
801099eb:	89 e5                	mov    %esp,%ebp
801099ed:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801099f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801099f4:	75 0d                	jne    80109a03 <freevm+0x19>
    panic("freevm: no pgdir");
801099f6:	83 ec 0c             	sub    $0xc,%esp
801099f9:	68 63 a5 10 80       	push   $0x8010a563
801099fe:	e8 63 6b ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109a03:	83 ec 04             	sub    $0x4,%esp
80109a06:	6a 00                	push   $0x0
80109a08:	68 00 00 00 80       	push   $0x80000000
80109a0d:	ff 75 08             	pushl  0x8(%ebp)
80109a10:	e8 18 ff ff ff       	call   8010992d <deallocuvm>
80109a15:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109a18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109a1f:	eb 4f                	jmp    80109a70 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80109a2e:	01 d0                	add    %edx,%eax
80109a30:	8b 00                	mov    (%eax),%eax
80109a32:	83 e0 01             	and    $0x1,%eax
80109a35:	85 c0                	test   %eax,%eax
80109a37:	74 33                	je     80109a6c <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109a43:	8b 45 08             	mov    0x8(%ebp),%eax
80109a46:	01 d0                	add    %edx,%eax
80109a48:	8b 00                	mov    (%eax),%eax
80109a4a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a4f:	83 ec 0c             	sub    $0xc,%esp
80109a52:	50                   	push   %eax
80109a53:	e8 b3 f4 ff ff       	call   80108f0b <p2v>
80109a58:	83 c4 10             	add    $0x10,%esp
80109a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109a5e:	83 ec 0c             	sub    $0xc,%esp
80109a61:	ff 75 f0             	pushl  -0x10(%ebp)
80109a64:	e8 0a 92 ff ff       	call   80102c73 <kfree>
80109a69:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109a6c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109a70:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109a77:	76 a8                	jbe    80109a21 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109a79:	83 ec 0c             	sub    $0xc,%esp
80109a7c:	ff 75 08             	pushl  0x8(%ebp)
80109a7f:	e8 ef 91 ff ff       	call   80102c73 <kfree>
80109a84:	83 c4 10             	add    $0x10,%esp
}
80109a87:	90                   	nop
80109a88:	c9                   	leave  
80109a89:	c3                   	ret    

80109a8a <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109a8a:	55                   	push   %ebp
80109a8b:	89 e5                	mov    %esp,%ebp
80109a8d:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109a90:	83 ec 04             	sub    $0x4,%esp
80109a93:	6a 00                	push   $0x0
80109a95:	ff 75 0c             	pushl  0xc(%ebp)
80109a98:	ff 75 08             	pushl  0x8(%ebp)
80109a9b:	e8 ed f8 ff ff       	call   8010938d <walkpgdir>
80109aa0:	83 c4 10             	add    $0x10,%esp
80109aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109aa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109aaa:	75 0d                	jne    80109ab9 <clearpteu+0x2f>
    panic("clearpteu");
80109aac:	83 ec 0c             	sub    $0xc,%esp
80109aaf:	68 74 a5 10 80       	push   $0x8010a574
80109ab4:	e8 ad 6a ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109abc:	8b 00                	mov    (%eax),%eax
80109abe:	83 e0 fb             	and    $0xfffffffb,%eax
80109ac1:	89 c2                	mov    %eax,%edx
80109ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ac6:	89 10                	mov    %edx,(%eax)
}
80109ac8:	90                   	nop
80109ac9:	c9                   	leave  
80109aca:	c3                   	ret    

80109acb <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109acb:	55                   	push   %ebp
80109acc:	89 e5                	mov    %esp,%ebp
80109ace:	53                   	push   %ebx
80109acf:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109ad2:	e8 e6 f9 ff ff       	call   801094bd <setupkvm>
80109ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109ada:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109ade:	75 0a                	jne    80109aea <copyuvm+0x1f>
    return 0;
80109ae0:	b8 00 00 00 00       	mov    $0x0,%eax
80109ae5:	e9 f8 00 00 00       	jmp    80109be2 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109aea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109af1:	e9 c4 00 00 00       	jmp    80109bba <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109af9:	83 ec 04             	sub    $0x4,%esp
80109afc:	6a 00                	push   $0x0
80109afe:	50                   	push   %eax
80109aff:	ff 75 08             	pushl  0x8(%ebp)
80109b02:	e8 86 f8 ff ff       	call   8010938d <walkpgdir>
80109b07:	83 c4 10             	add    $0x10,%esp
80109b0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109b0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109b11:	75 0d                	jne    80109b20 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109b13:	83 ec 0c             	sub    $0xc,%esp
80109b16:	68 7e a5 10 80       	push   $0x8010a57e
80109b1b:	e8 46 6a ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109b23:	8b 00                	mov    (%eax),%eax
80109b25:	83 e0 01             	and    $0x1,%eax
80109b28:	85 c0                	test   %eax,%eax
80109b2a:	75 0d                	jne    80109b39 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109b2c:	83 ec 0c             	sub    $0xc,%esp
80109b2f:	68 98 a5 10 80       	push   $0x8010a598
80109b34:	e8 2d 6a ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109b3c:	8b 00                	mov    (%eax),%eax
80109b3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109b43:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109b49:	8b 00                	mov    (%eax),%eax
80109b4b:	25 ff 0f 00 00       	and    $0xfff,%eax
80109b50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109b53:	e8 b8 91 ff ff       	call   80102d10 <kalloc>
80109b58:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109b5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109b5f:	74 6a                	je     80109bcb <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109b61:	83 ec 0c             	sub    $0xc,%esp
80109b64:	ff 75 e8             	pushl  -0x18(%ebp)
80109b67:	e8 9f f3 ff ff       	call   80108f0b <p2v>
80109b6c:	83 c4 10             	add    $0x10,%esp
80109b6f:	83 ec 04             	sub    $0x4,%esp
80109b72:	68 00 10 00 00       	push   $0x1000
80109b77:	50                   	push   %eax
80109b78:	ff 75 e0             	pushl  -0x20(%ebp)
80109b7b:	e8 e8 cd ff ff       	call   80106968 <memmove>
80109b80:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109b83:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109b86:	83 ec 0c             	sub    $0xc,%esp
80109b89:	ff 75 e0             	pushl  -0x20(%ebp)
80109b8c:	e8 6d f3 ff ff       	call   80108efe <v2p>
80109b91:	83 c4 10             	add    $0x10,%esp
80109b94:	89 c2                	mov    %eax,%edx
80109b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b99:	83 ec 0c             	sub    $0xc,%esp
80109b9c:	53                   	push   %ebx
80109b9d:	52                   	push   %edx
80109b9e:	68 00 10 00 00       	push   $0x1000
80109ba3:	50                   	push   %eax
80109ba4:	ff 75 f0             	pushl  -0x10(%ebp)
80109ba7:	e8 81 f8 ff ff       	call   8010942d <mappages>
80109bac:	83 c4 20             	add    $0x20,%esp
80109baf:	85 c0                	test   %eax,%eax
80109bb1:	78 1b                	js     80109bce <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109bb3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bbd:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109bc0:	0f 82 30 ff ff ff    	jb     80109af6 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bc9:	eb 17                	jmp    80109be2 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109bcb:	90                   	nop
80109bcc:	eb 01                	jmp    80109bcf <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109bce:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109bcf:	83 ec 0c             	sub    $0xc,%esp
80109bd2:	ff 75 f0             	pushl  -0x10(%ebp)
80109bd5:	e8 10 fe ff ff       	call   801099ea <freevm>
80109bda:	83 c4 10             	add    $0x10,%esp
  return 0;
80109bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109be2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109be5:	c9                   	leave  
80109be6:	c3                   	ret    

80109be7 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109be7:	55                   	push   %ebp
80109be8:	89 e5                	mov    %esp,%ebp
80109bea:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109bed:	83 ec 04             	sub    $0x4,%esp
80109bf0:	6a 00                	push   $0x0
80109bf2:	ff 75 0c             	pushl  0xc(%ebp)
80109bf5:	ff 75 08             	pushl  0x8(%ebp)
80109bf8:	e8 90 f7 ff ff       	call   8010938d <walkpgdir>
80109bfd:	83 c4 10             	add    $0x10,%esp
80109c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c06:	8b 00                	mov    (%eax),%eax
80109c08:	83 e0 01             	and    $0x1,%eax
80109c0b:	85 c0                	test   %eax,%eax
80109c0d:	75 07                	jne    80109c16 <uva2ka+0x2f>
    return 0;
80109c0f:	b8 00 00 00 00       	mov    $0x0,%eax
80109c14:	eb 29                	jmp    80109c3f <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c19:	8b 00                	mov    (%eax),%eax
80109c1b:	83 e0 04             	and    $0x4,%eax
80109c1e:	85 c0                	test   %eax,%eax
80109c20:	75 07                	jne    80109c29 <uva2ka+0x42>
    return 0;
80109c22:	b8 00 00 00 00       	mov    $0x0,%eax
80109c27:	eb 16                	jmp    80109c3f <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c2c:	8b 00                	mov    (%eax),%eax
80109c2e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c33:	83 ec 0c             	sub    $0xc,%esp
80109c36:	50                   	push   %eax
80109c37:	e8 cf f2 ff ff       	call   80108f0b <p2v>
80109c3c:	83 c4 10             	add    $0x10,%esp
}
80109c3f:	c9                   	leave  
80109c40:	c3                   	ret    

80109c41 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109c41:	55                   	push   %ebp
80109c42:	89 e5                	mov    %esp,%ebp
80109c44:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109c47:	8b 45 10             	mov    0x10(%ebp),%eax
80109c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109c4d:	eb 7f                	jmp    80109cce <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c57:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109c5d:	83 ec 08             	sub    $0x8,%esp
80109c60:	50                   	push   %eax
80109c61:	ff 75 08             	pushl  0x8(%ebp)
80109c64:	e8 7e ff ff ff       	call   80109be7 <uva2ka>
80109c69:	83 c4 10             	add    $0x10,%esp
80109c6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109c6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109c73:	75 07                	jne    80109c7c <copyout+0x3b>
      return -1;
80109c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109c7a:	eb 61                	jmp    80109cdd <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109c7f:	2b 45 0c             	sub    0xc(%ebp),%eax
80109c82:	05 00 10 00 00       	add    $0x1000,%eax
80109c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c8d:	3b 45 14             	cmp    0x14(%ebp),%eax
80109c90:	76 06                	jbe    80109c98 <copyout+0x57>
      n = len;
80109c92:	8b 45 14             	mov    0x14(%ebp),%eax
80109c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109c98:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c9b:	2b 45 ec             	sub    -0x14(%ebp),%eax
80109c9e:	89 c2                	mov    %eax,%edx
80109ca0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ca3:	01 d0                	add    %edx,%eax
80109ca5:	83 ec 04             	sub    $0x4,%esp
80109ca8:	ff 75 f0             	pushl  -0x10(%ebp)
80109cab:	ff 75 f4             	pushl  -0xc(%ebp)
80109cae:	50                   	push   %eax
80109caf:	e8 b4 cc ff ff       	call   80106968 <memmove>
80109cb4:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109cba:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109cc0:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109cc6:	05 00 10 00 00       	add    $0x1000,%eax
80109ccb:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109cce:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109cd2:	0f 85 77 ff ff ff    	jne    80109c4f <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109cd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109cdd:	c9                   	leave  
80109cde:	c3                   	ret    
