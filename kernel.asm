
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
8010003d:	68 c8 99 10 80       	push   $0x801099c8
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 c1 62 00 00       	call   8010630d <initlock>
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
801000c1:	e8 69 62 00 00       	call   8010632f <acquire>
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
8010010c:	e8 85 62 00 00       	call   80106396 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 c5 51 00 00       	call   801052f1 <sleep>
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
80100188:	e8 09 62 00 00       	call   80106396 <release>
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
801001aa:	68 cf 99 10 80       	push   $0x801099cf
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
80100204:	68 e0 99 10 80       	push   $0x801099e0
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
80100243:	68 e7 99 10 80       	push   $0x801099e7
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 d5 60 00 00       	call   8010632f <acquire>
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
801002b9:	e8 89 51 00 00       	call   80105447 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 c8 60 00 00       	call   80106396 <release>
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
801003e2:	e8 48 5f 00 00       	call   8010632f <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 ee 99 10 80       	push   $0x801099ee
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
801004cd:	c7 45 ec f7 99 10 80 	movl   $0x801099f7,-0x14(%ebp)
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
8010055b:	e8 36 5e 00 00       	call   80106396 <release>
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
8010058b:	68 fe 99 10 80       	push   $0x801099fe
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
801005aa:	68 0d 9a 10 80       	push   $0x80109a0d
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 21 5e 00 00       	call   801063e8 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 0f 9a 10 80       	push   $0x80109a0f
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
801006ca:	68 13 9a 10 80       	push   $0x80109a13
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
801006f7:	e8 55 5f 00 00       	call   80106651 <memmove>
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
80100721:	e8 6c 5e 00 00       	call   80106592 <memset>
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
801007b6:	e8 96 78 00 00       	call   80108051 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 89 78 00 00       	call   80108051 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 7c 78 00 00       	call   80108051 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 6c 78 00 00       	call   80108051 <uartputc>
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
8010082a:	e8 00 5b 00 00       	call   8010632f <acquire>
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
801009d4:	e8 6e 4a 00 00       	call   80105447 <wakeup>
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
801009f7:	e8 9a 59 00 00       	call   80106396 <release>
801009fc:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a03:	74 05                	je     80100a0a <consoleintr+0x211>
    procdump();  // now call procdump() wo. cons.lock held
80100a05:	e8 2c 4c 00 00       	call   80105636 <procdump>
  }
  if (f) {
80100a0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a0e:	74 05                	je     80100a15 <consoleintr+0x21c>
    free_length();
80100a10:	e8 99 50 00 00       	call   80105aae <free_length>
  }
  if (r) {
80100a15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a19:	74 05                	je     80100a20 <consoleintr+0x227>
    display_ready();
80100a1b:	e8 1a 51 00 00       	call   80105b3a <display_ready>
  }
  if (s) {
80100a20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a24:	74 05                	je     80100a2b <consoleintr+0x232>
    display_sleep();
80100a26:	e8 ee 51 00 00       	call   80105c19 <display_sleep>
  }
  if (z) {
80100a2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a2f:	74 05                	je     80100a36 <consoleintr+0x23d>
    display_zombie();
80100a31:	e8 9d 52 00 00       	call   80105cd3 <display_zombie>
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
80100a5b:	e8 cf 58 00 00       	call   8010632f <acquire>
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
80100a7d:	e8 14 59 00 00       	call   80106396 <release>
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
80100aaa:	e8 42 48 00 00       	call   801052f1 <sleep>
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
80100b28:	e8 69 58 00 00       	call   80106396 <release>
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
80100b66:	e8 c4 57 00 00       	call   8010632f <acquire>
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
80100ba8:	e8 e9 57 00 00       	call   80106396 <release>
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
80100bcc:	68 26 9a 10 80       	push   $0x80109a26
80100bd1:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bd6:	e8 32 57 00 00       	call   8010630d <initlock>
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
80100c94:	e8 0d 85 00 00       	call   801091a6 <setupkvm>
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
80100d1a:	e8 2e 88 00 00       	call   8010954d <allocuvm>
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
80100d4d:	e8 24 87 00 00       	call   80109476 <loaduvm>
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
80100dbc:	e8 8c 87 00 00       	call   8010954d <allocuvm>
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
80100de0:	e8 8e 89 00 00       	call   80109773 <clearpteu>
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
80100e19:	e8 c1 59 00 00       	call   801067df <strlen>
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
80100e46:	e8 94 59 00 00       	call   801067df <strlen>
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
80100e6c:	e8 b9 8a 00 00       	call   8010992a <copyout>
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
80100f08:	e8 1d 8a 00 00       	call   8010992a <copyout>
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
80100f59:	e8 37 58 00 00       	call   80106795 <safestrcpy>
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
80100faf:	e8 d9 82 00 00       	call   8010928d <switchuvm>
80100fb4:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fb7:	83 ec 0c             	sub    $0xc,%esp
80100fba:	ff 75 d0             	pushl  -0x30(%ebp)
80100fbd:	e8 11 87 00 00       	call   801096d3 <freevm>
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
80100ff7:	e8 d7 86 00 00       	call   801096d3 <freevm>
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
80101028:	68 2e 9a 10 80       	push   $0x80109a2e
8010102d:	68 40 28 11 80       	push   $0x80112840
80101032:	e8 d6 52 00 00       	call   8010630d <initlock>
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
8010104b:	e8 df 52 00 00       	call   8010632f <acquire>
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
80101078:	e8 19 53 00 00       	call   80106396 <release>
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
8010109b:	e8 f6 52 00 00       	call   80106396 <release>
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
801010b8:	e8 72 52 00 00       	call   8010632f <acquire>
801010bd:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010c0:	8b 45 08             	mov    0x8(%ebp),%eax
801010c3:	8b 40 04             	mov    0x4(%eax),%eax
801010c6:	85 c0                	test   %eax,%eax
801010c8:	7f 0d                	jg     801010d7 <filedup+0x2d>
    panic("filedup");
801010ca:	83 ec 0c             	sub    $0xc,%esp
801010cd:	68 35 9a 10 80       	push   $0x80109a35
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
801010ee:	e8 a3 52 00 00       	call   80106396 <release>
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
80101109:	e8 21 52 00 00       	call   8010632f <acquire>
8010110e:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101111:	8b 45 08             	mov    0x8(%ebp),%eax
80101114:	8b 40 04             	mov    0x4(%eax),%eax
80101117:	85 c0                	test   %eax,%eax
80101119:	7f 0d                	jg     80101128 <fileclose+0x2d>
    panic("fileclose");
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	68 3d 9a 10 80       	push   $0x80109a3d
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
80101149:	e8 48 52 00 00       	call   80106396 <release>
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
80101197:	e8 fa 51 00 00       	call   80106396 <release>
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
801012e6:	68 47 9a 10 80       	push   $0x80109a47
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
801013e9:	68 50 9a 10 80       	push   $0x80109a50
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
8010141f:	68 60 9a 10 80       	push   $0x80109a60
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
80101457:	e8 f5 51 00 00       	call   80106651 <memmove>
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
8010149d:	e8 f0 50 00 00       	call   80106592 <memset>
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
80101604:	68 6c 9a 10 80       	push   $0x80109a6c
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
80101697:	68 82 9a 10 80       	push   $0x80109a82
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
801016f4:	68 95 9a 10 80       	push   $0x80109a95
801016f9:	68 60 32 11 80       	push   $0x80113260
801016fe:	e8 0a 4c 00 00       	call   8010630d <initlock>
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
8010174d:	68 9c 9a 10 80       	push   $0x80109a9c
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
801017c6:	e8 c7 4d 00 00       	call   80106592 <memset>
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
8010182e:	68 ef 9a 10 80       	push   $0x80109aef
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
801018d4:	e8 78 4d 00 00       	call   80106651 <memmove>
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
80101909:	e8 21 4a 00 00       	call   8010632f <acquire>
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
80101957:	e8 3a 4a 00 00       	call   80106396 <release>
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
80101990:	68 01 9b 10 80       	push   $0x80109b01
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
801019cd:	e8 c4 49 00 00       	call   80106396 <release>
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
801019e8:	e8 42 49 00 00       	call   8010632f <acquire>
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
80101a07:	e8 8a 49 00 00       	call   80106396 <release>
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
80101a2d:	68 11 9b 10 80       	push   $0x80109b11
80101a32:	e8 2f eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a37:	83 ec 0c             	sub    $0xc,%esp
80101a3a:	68 60 32 11 80       	push   $0x80113260
80101a3f:	e8 eb 48 00 00       	call   8010632f <acquire>
80101a44:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a47:	eb 13                	jmp    80101a5c <ilock+0x48>
    sleep(ip, &icache.lock);
80101a49:	83 ec 08             	sub    $0x8,%esp
80101a4c:	68 60 32 11 80       	push   $0x80113260
80101a51:	ff 75 08             	pushl  0x8(%ebp)
80101a54:	e8 98 38 00 00       	call   801052f1 <sleep>
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
80101a82:	e8 0f 49 00 00       	call   80106396 <release>
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
80101b2f:	e8 1d 4b 00 00       	call   80106651 <memmove>
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
80101b65:	68 17 9b 10 80       	push   $0x80109b17
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
80101b98:	68 26 9b 10 80       	push   $0x80109b26
80101b9d:	e8 c4 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101ba2:	83 ec 0c             	sub    $0xc,%esp
80101ba5:	68 60 32 11 80       	push   $0x80113260
80101baa:	e8 80 47 00 00       	call   8010632f <acquire>
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
80101bc9:	e8 79 38 00 00       	call   80105447 <wakeup>
80101bce:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bd1:	83 ec 0c             	sub    $0xc,%esp
80101bd4:	68 60 32 11 80       	push   $0x80113260
80101bd9:	e8 b8 47 00 00       	call   80106396 <release>
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
80101bf2:	e8 38 47 00 00       	call   8010632f <acquire>
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
80101c3a:	68 2e 9b 10 80       	push   $0x80109b2e
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
80101c5d:	e8 34 47 00 00       	call   80106396 <release>
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
80101c92:	e8 98 46 00 00       	call   8010632f <acquire>
80101c97:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ca4:	83 ec 0c             	sub    $0xc,%esp
80101ca7:	ff 75 08             	pushl  0x8(%ebp)
80101caa:	e8 98 37 00 00       	call   80105447 <wakeup>
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
80101cc9:	e8 c8 46 00 00       	call   80106396 <release>
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
80101e09:	68 38 9b 10 80       	push   $0x80109b38
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
801020a0:	e8 ac 45 00 00       	call   80106651 <memmove>
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
801021f2:	e8 5a 44 00 00       	call   80106651 <memmove>
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
80102272:	e8 70 44 00 00       	call   801066e7 <strncmp>
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
80102292:	68 4b 9b 10 80       	push   $0x80109b4b
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
801022c1:	68 5d 9b 10 80       	push   $0x80109b5d
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
80102396:	68 5d 9b 10 80       	push   $0x80109b5d
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
801023d1:	e8 67 43 00 00       	call   8010673d <strncpy>
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
801023fd:	68 6a 9b 10 80       	push   $0x80109b6a
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
80102473:	e8 d9 41 00 00       	call   80106651 <memmove>
80102478:	83 c4 10             	add    $0x10,%esp
8010247b:	eb 26                	jmp    801024a3 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102480:	83 ec 04             	sub    $0x4,%esp
80102483:	50                   	push   %eax
80102484:	ff 75 f4             	pushl  -0xc(%ebp)
80102487:	ff 75 0c             	pushl  0xc(%ebp)
8010248a:	e8 c2 41 00 00       	call   80106651 <memmove>
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
801026df:	68 72 9b 10 80       	push   $0x80109b72
801026e4:	68 20 d6 10 80       	push   $0x8010d620
801026e9:	e8 1f 3c 00 00       	call   8010630d <initlock>
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
80102793:	68 76 9b 10 80       	push   $0x80109b76
80102798:	e8 c9 dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
8010279d:	8b 45 08             	mov    0x8(%ebp),%eax
801027a0:	8b 40 08             	mov    0x8(%eax),%eax
801027a3:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027a8:	76 0d                	jbe    801027b7 <idestart+0x33>
    panic("incorrect blockno");
801027aa:	83 ec 0c             	sub    $0xc,%esp
801027ad:	68 7f 9b 10 80       	push   $0x80109b7f
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
801027d6:	68 76 9b 10 80       	push   $0x80109b76
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
801028f0:	e8 3a 3a 00 00       	call   8010632f <acquire>
801028f5:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028f8:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801028fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102900:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102904:	75 15                	jne    8010291b <ideintr+0x39>
    release(&idelock);
80102906:	83 ec 0c             	sub    $0xc,%esp
80102909:	68 20 d6 10 80       	push   $0x8010d620
8010290e:	e8 83 3a 00 00       	call   80106396 <release>
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
80102983:	e8 bf 2a 00 00       	call   80105447 <wakeup>
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
801029ad:	e8 e4 39 00 00       	call   80106396 <release>
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
801029cc:	68 91 9b 10 80       	push   $0x80109b91
801029d1:	e8 90 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029d6:	8b 45 08             	mov    0x8(%ebp),%eax
801029d9:	8b 00                	mov    (%eax),%eax
801029db:	83 e0 06             	and    $0x6,%eax
801029de:	83 f8 02             	cmp    $0x2,%eax
801029e1:	75 0d                	jne    801029f0 <iderw+0x39>
    panic("iderw: nothing to do");
801029e3:	83 ec 0c             	sub    $0xc,%esp
801029e6:	68 a5 9b 10 80       	push   $0x80109ba5
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
80102a06:	68 ba 9b 10 80       	push   $0x80109bba
80102a0b:	e8 56 db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a10:	83 ec 0c             	sub    $0xc,%esp
80102a13:	68 20 d6 10 80       	push   $0x8010d620
80102a18:	e8 12 39 00 00       	call   8010632f <acquire>
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
80102a74:	e8 78 28 00 00       	call   801052f1 <sleep>
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
80102a91:	e8 00 39 00 00       	call   80106396 <release>
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
80102b22:	68 d8 9b 10 80       	push   $0x80109bd8
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
80102be2:	68 0a 9c 10 80       	push   $0x80109c0a
80102be7:	68 40 42 11 80       	push   $0x80114240
80102bec:	e8 1c 37 00 00       	call   8010630d <initlock>
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
80102c85:	81 7d 08 5c 78 11 80 	cmpl   $0x8011785c,0x8(%ebp)
80102c8c:	72 12                	jb     80102ca0 <kfree+0x2d>
80102c8e:	ff 75 08             	pushl  0x8(%ebp)
80102c91:	e8 36 ff ff ff       	call   80102bcc <v2p>
80102c96:	83 c4 04             	add    $0x4,%esp
80102c99:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c9e:	76 0d                	jbe    80102cad <kfree+0x3a>
    panic("kfree");
80102ca0:	83 ec 0c             	sub    $0xc,%esp
80102ca3:	68 0f 9c 10 80       	push   $0x80109c0f
80102ca8:	e8 b9 d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102cad:	83 ec 04             	sub    $0x4,%esp
80102cb0:	68 00 10 00 00       	push   $0x1000
80102cb5:	6a 01                	push   $0x1
80102cb7:	ff 75 08             	pushl  0x8(%ebp)
80102cba:	e8 d3 38 00 00       	call   80106592 <memset>
80102cbf:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cc2:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cc7:	85 c0                	test   %eax,%eax
80102cc9:	74 10                	je     80102cdb <kfree+0x68>
    acquire(&kmem.lock);
80102ccb:	83 ec 0c             	sub    $0xc,%esp
80102cce:	68 40 42 11 80       	push   $0x80114240
80102cd3:	e8 57 36 00 00       	call   8010632f <acquire>
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
80102d05:	e8 8c 36 00 00       	call   80106396 <release>
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
80102d27:	e8 03 36 00 00       	call   8010632f <acquire>
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
80102d58:	e8 39 36 00 00       	call   80106396 <release>
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
801030a3:	68 18 9c 10 80       	push   $0x80109c18
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
801032ce:	e8 26 33 00 00       	call   801065f9 <memcmp>
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
801033e2:	68 44 9c 10 80       	push   $0x80109c44
801033e7:	68 80 42 11 80       	push   $0x80114280
801033ec:	e8 1c 2f 00 00       	call   8010630d <initlock>
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
80103497:	e8 b5 31 00 00       	call   80106651 <memmove>
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
80103605:	e8 25 2d 00 00       	call   8010632f <acquire>
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
80103623:	e8 c9 1c 00 00       	call   801052f1 <sleep>
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
80103658:	e8 94 1c 00 00       	call   801052f1 <sleep>
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
80103677:	e8 1a 2d 00 00       	call   80106396 <release>
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
80103698:	e8 92 2c 00 00       	call   8010632f <acquire>
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
801036b9:	68 48 9c 10 80       	push   $0x80109c48
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
801036e7:	e8 5b 1d 00 00       	call   80105447 <wakeup>
801036ec:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036ef:	83 ec 0c             	sub    $0xc,%esp
801036f2:	68 80 42 11 80       	push   $0x80114280
801036f7:	e8 9a 2c 00 00       	call   80106396 <release>
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
80103712:	e8 18 2c 00 00       	call   8010632f <acquire>
80103717:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010371a:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
80103721:	00 00 00 
    wakeup(&log);
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 80 42 11 80       	push   $0x80114280
8010372c:	e8 16 1d 00 00       	call   80105447 <wakeup>
80103731:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103734:	83 ec 0c             	sub    $0xc,%esp
80103737:	68 80 42 11 80       	push   $0x80114280
8010373c:	e8 55 2c 00 00       	call   80106396 <release>
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
801037b8:	e8 94 2e 00 00       	call   80106651 <memmove>
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
80103854:	68 57 9c 10 80       	push   $0x80109c57
80103859:	e8 08 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010385e:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103863:	85 c0                	test   %eax,%eax
80103865:	7f 0d                	jg     80103874 <log_write+0x45>
    panic("log_write outside of trans");
80103867:	83 ec 0c             	sub    $0xc,%esp
8010386a:	68 6d 9c 10 80       	push   $0x80109c6d
8010386f:	e8 f2 cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103874:	83 ec 0c             	sub    $0xc,%esp
80103877:	68 80 42 11 80       	push   $0x80114280
8010387c:	e8 ae 2a 00 00       	call   8010632f <acquire>
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
801038fa:	e8 97 2a 00 00       	call   80106396 <release>
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
80103952:	68 5c 78 11 80       	push   $0x8011785c
80103957:	e8 7d f2 ff ff       	call   80102bd9 <kinit1>
8010395c:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
8010395f:	e8 f4 58 00 00       	call   80109258 <kvmalloc>
  mpinit();        // collect info about this machine
80103964:	e8 43 04 00 00       	call   80103dac <mpinit>
  lapicinit();
80103969:	e8 ea f5 ff ff       	call   80102f58 <lapicinit>
  seginit();       // set up segments
8010396e:	e8 8e 52 00 00       	call   80108c01 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103973:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103979:	0f b6 00             	movzbl (%eax),%eax
8010397c:	0f b6 c0             	movzbl %al,%eax
8010397f:	83 ec 08             	sub    $0x8,%esp
80103982:	50                   	push   %eax
80103983:	68 88 9c 10 80       	push   $0x80109c88
80103988:	e8 39 ca ff ff       	call   801003c6 <cprintf>
8010398d:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103990:	e8 6d 06 00 00       	call   80104002 <picinit>
  ioapicinit();    // another interrupt controller
80103995:	e8 34 f1 ff ff       	call   80102ace <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010399a:	e8 24 d2 ff ff       	call   80100bc3 <consoleinit>
  uartinit();      // serial port
8010399f:	e8 b9 45 00 00       	call   80107f5d <uartinit>
  pinit();         // process table
801039a4:	e8 5d 0b 00 00       	call   80104506 <pinit>
  tvinit();        // trap vectors
801039a9:	e8 ab 41 00 00       	call   80107b59 <tvinit>
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
801039c6:	e8 df 40 00 00       	call   80107aaa <timerinit>
  startothers();   // start other processors
801039cb:	e8 7f 00 00 00       	call   80103a4f <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039d0:	83 ec 08             	sub    $0x8,%esp
801039d3:	68 00 00 00 8e       	push   $0x8e000000
801039d8:	68 00 00 40 80       	push   $0x80400000
801039dd:	e8 30 f2 ff ff       	call   80102c12 <kinit2>
801039e2:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039e5:	e8 00 0d 00 00       	call   801046ea <userinit>
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
801039f5:	e8 76 58 00 00       	call   80109270 <switchkvm>
  seginit();
801039fa:	e8 02 52 00 00       	call   80108c01 <seginit>
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
80103a1f:	68 9f 9c 10 80       	push   $0x80109c9f
80103a24:	e8 9d c9 ff ff       	call   801003c6 <cprintf>
80103a29:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a2c:	e8 89 42 00 00       	call   80107cba <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a31:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a37:	05 a8 00 00 00       	add    $0xa8,%eax
80103a3c:	83 ec 08             	sub    $0x8,%esp
80103a3f:	6a 01                	push   $0x1
80103a41:	50                   	push   %eax
80103a42:	e8 d8 fe ff ff       	call   8010391f <xchg>
80103a47:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a4a:	e8 a0 15 00 00       	call   80104fef <scheduler>

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
80103a77:	e8 d5 2b 00 00       	call   80106651 <memmove>
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
80103c05:	68 b0 9c 10 80       	push   $0x80109cb0
80103c0a:	ff 75 f4             	pushl  -0xc(%ebp)
80103c0d:	e8 e7 29 00 00       	call   801065f9 <memcmp>
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
80103d43:	68 b5 9c 10 80       	push   $0x80109cb5
80103d48:	ff 75 f0             	pushl  -0x10(%ebp)
80103d4b:	e8 a9 28 00 00       	call   801065f9 <memcmp>
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
80103e1f:	8b 04 85 f8 9c 10 80 	mov    -0x7fef6308(,%eax,4),%eax
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
80103e55:	68 ba 9c 10 80       	push   $0x80109cba
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
80103ee8:	68 d8 9c 10 80       	push   $0x80109cd8
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
80104189:	68 0c 9d 10 80       	push   $0x80109d0c
8010418e:	50                   	push   %eax
8010418f:	e8 79 21 00 00       	call   8010630d <initlock>
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
8010424b:	e8 df 20 00 00       	call   8010632f <acquire>
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
80104272:	e8 d0 11 00 00       	call   80105447 <wakeup>
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
80104295:	e8 ad 11 00 00       	call   80105447 <wakeup>
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
801042be:	e8 d3 20 00 00       	call   80106396 <release>
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
801042dd:	e8 b4 20 00 00       	call   80106396 <release>
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
801042f5:	e8 35 20 00 00       	call   8010632f <acquire>
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
8010432a:	e8 67 20 00 00       	call   80106396 <release>
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
80104348:	e8 fa 10 00 00       	call   80105447 <wakeup>
8010434d:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104350:	8b 45 08             	mov    0x8(%ebp),%eax
80104353:	8b 55 08             	mov    0x8(%ebp),%edx
80104356:	81 c2 38 02 00 00    	add    $0x238,%edx
8010435c:	83 ec 08             	sub    $0x8,%esp
8010435f:	50                   	push   %eax
80104360:	52                   	push   %edx
80104361:	e8 8b 0f 00 00       	call   801052f1 <sleep>
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
801043ca:	e8 78 10 00 00       	call   80105447 <wakeup>
801043cf:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043d2:	8b 45 08             	mov    0x8(%ebp),%eax
801043d5:	83 ec 0c             	sub    $0xc,%esp
801043d8:	50                   	push   %eax
801043d9:	e8 b8 1f 00 00       	call   80106396 <release>
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
801043f4:	e8 36 1f 00 00       	call   8010632f <acquire>
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
80104412:	e8 7f 1f 00 00       	call   80106396 <release>
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
80104435:	e8 b7 0e 00 00       	call   801052f1 <sleep>
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
801044c9:	e8 79 0f 00 00       	call   80105447 <wakeup>
801044ce:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044d1:	8b 45 08             	mov    0x8(%ebp),%eax
801044d4:	83 ec 0c             	sub    $0xc,%esp
801044d7:	50                   	push   %eax
801044d8:	e8 b9 1e 00 00       	call   80106396 <release>
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
static int search_and_set_ready(int pid, int prio);
#endif

void
pinit(void)
{
80104506:	55                   	push   %ebp
80104507:	89 e5                	mov    %esp,%ebp
80104509:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010450c:	83 ec 08             	sub    $0x8,%esp
8010450f:	68 14 9d 10 80       	push   $0x80109d14
80104514:	68 80 49 11 80       	push   $0x80114980
80104519:	e8 ef 1d 00 00       	call   8010630d <initlock>
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
80104532:	e8 f8 1d 00 00       	call   8010632f <acquire>
80104537:	83 c4 10             	add    $0x10,%esp
  #else
  // Check to make sure the ptable has free procs available
  // remove from list wont return a negative number in this
  // case because we check p and the list against null before
  // passing it in to the function. 
  p = ptable.pLists.free;
8010453a:	a1 b4 6f 11 80       	mov    0x80116fb4,%eax
8010453f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p) {
80104542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104546:	0f 84 86 00 00 00    	je     801045d2 <allocproc+0xae>
    remove_from_list(&ptable.pLists.free, p);
8010454c:	83 ec 08             	sub    $0x8,%esp
8010454f:	ff 75 f4             	pushl  -0xc(%ebp)
80104552:	68 b4 6f 11 80       	push   $0x80116fb4
80104557:	e8 d6 18 00 00       	call   80105e32 <remove_from_list>
8010455c:	83 c4 10             	add    $0x10,%esp
    assert_state(p, UNUSED);
8010455f:	83 ec 08             	sub    $0x8,%esp
80104562:	6a 00                	push   $0x0
80104564:	ff 75 f4             	pushl  -0xc(%ebp)
80104567:	e8 a5 18 00 00       	call   80105e11 <assert_state>
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
80104582:	68 b8 6f 11 80       	push   $0x80116fb8
80104587:	e8 52 19 00 00       	call   80105ede <add_to_list>
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
801045ad:	e8 e4 1d 00 00       	call   80106396 <release>
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
801045da:	e8 b7 1d 00 00       	call   80106396 <release>
801045df:	83 c4 10             	add    $0x10,%esp
  return 0;
801045e2:	b8 00 00 00 00       	mov    $0x0,%eax
801045e7:	e9 fc 00 00 00       	jmp    801046e8 <allocproc+0x1c4>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    acquire(&ptable.lock);
801045ec:	83 ec 0c             	sub    $0xc,%esp
801045ef:	68 80 49 11 80       	push   $0x80114980
801045f4:	e8 36 1d 00 00       	call   8010632f <acquire>
801045f9:	83 c4 10             	add    $0x10,%esp
    #ifdef CS333_P3P4
    remove_from_list(&ptable.pLists.embryo, p);
801045fc:	83 ec 08             	sub    $0x8,%esp
801045ff:	ff 75 f4             	pushl  -0xc(%ebp)
80104602:	68 b8 6f 11 80       	push   $0x80116fb8
80104607:	e8 26 18 00 00       	call   80105e32 <remove_from_list>
8010460c:	83 c4 10             	add    $0x10,%esp
    assert_state(p, EMBRYO);
8010460f:	83 ec 08             	sub    $0x8,%esp
80104612:	6a 01                	push   $0x1
80104614:	ff 75 f4             	pushl  -0xc(%ebp)
80104617:	e8 f5 17 00 00       	call   80105e11 <assert_state>
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
80104631:	68 b4 6f 11 80       	push   $0x80116fb4
80104636:	e8 a3 18 00 00       	call   80105ede <add_to_list>
8010463b:	83 c4 10             	add    $0x10,%esp
    #endif
    release(&ptable.lock);
8010463e:	83 ec 0c             	sub    $0xc,%esp
80104641:	68 80 49 11 80       	push   $0x80114980
80104646:	e8 4b 1d 00 00       	call   80106396 <release>
8010464b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010464e:	b8 00 00 00 00       	mov    $0x0,%eax
80104653:	e9 90 00 00 00       	jmp    801046e8 <allocproc+0x1c4>
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
80104677:	ba 07 7b 10 80       	mov    $0x80107b07,%edx
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
8010469c:	e8 f1 1e 00 00       	call   80106592 <memset>
801046a1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801046a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a7:	8b 40 1c             	mov    0x1c(%eax),%eax
801046aa:	ba ab 52 10 80       	mov    $0x801052ab,%edx
801046af:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // My code Allocate start ticks to global ticks variable
801046b2:	8b 15 00 78 11 80    	mov    0x80117800,%edx
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
  #ifdef P4
  p->priority = 0;        // My code p4
801046d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046db:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801046e2:	00 00 00 
  #endif
  return p;
801046e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801046e8:	c9                   	leave  
801046e9:	c3                   	ret    

801046ea <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801046ea:	55                   	push   %ebp
801046eb:	89 e5                	mov    %esp,%ebp
801046ed:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  acquire(&ptable.lock);
801046f0:	83 ec 0c             	sub    $0xc,%esp
801046f3:	68 80 49 11 80       	push   $0x80114980
801046f8:	e8 32 1c 00 00       	call   8010632f <acquire>
801046fd:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.free = 0;
80104700:	c7 05 b4 6f 11 80 00 	movl   $0x0,0x80116fb4
80104707:	00 00 00 
  ptable.pLists.embryo = 0;
8010470a:	c7 05 b8 6f 11 80 00 	movl   $0x0,0x80116fb8
80104711:	00 00 00 
  ptable.pLists.running = 0;
80104714:	c7 05 d4 6f 11 80 00 	movl   $0x0,0x80116fd4
8010471b:	00 00 00 
  ptable.pLists.sleep = 0;
8010471e:	c7 05 d8 6f 11 80 00 	movl   $0x0,0x80116fd8
80104725:	00 00 00 
  ptable.pLists.zombie = 0;
80104728:	c7 05 dc 6f 11 80 00 	movl   $0x0,0x80116fdc
8010472f:	00 00 00 
  #ifndef P4
  ptable.pLists.ready = 0;
  #else
  for (int i = 0; i < MAX+1; i++)
80104732:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104739:	eb 17                	jmp    80104752 <userinit+0x68>
    ptable.pLists.ready[i] = 0;
8010473b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010473e:	05 8c 09 00 00       	add    $0x98c,%eax
80104743:	c7 04 85 8c 49 11 80 	movl   $0x0,-0x7feeb674(,%eax,4)
8010474a:	00 00 00 00 
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  #ifndef P4
  ptable.pLists.ready = 0;
  #else
  for (int i = 0; i < MAX+1; i++)
8010474e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104752:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80104756:	7e e3                	jle    8010473b <userinit+0x51>
    ptable.pLists.ready[i] = 0;
  #endif

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104758:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
8010475f:	eb 1c                	jmp    8010477d <userinit+0x93>
    add_to_list(&ptable.pLists.free, UNUSED, p);  
80104761:	83 ec 04             	sub    $0x4,%esp
80104764:	ff 75 f4             	pushl  -0xc(%ebp)
80104767:	6a 00                	push   $0x0
80104769:	68 b4 6f 11 80       	push   $0x80116fb4
8010476e:	e8 6b 17 00 00       	call   80105ede <add_to_list>
80104773:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX+1; i++)
    ptable.pLists.ready[i] = 0;
  #endif

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104776:	81 45 f4 98 00 00 00 	addl   $0x98,-0xc(%ebp)
8010477d:	81 7d f4 b4 6f 11 80 	cmpl   $0x80116fb4,-0xc(%ebp)
80104784:	72 db                	jb     80104761 <userinit+0x77>
    add_to_list(&ptable.pLists.free, UNUSED, p);  

  #ifdef P4
  ptable.promote_at_time = 500;                         // P4: Init promote time to 5 seconds..
80104786:	c7 05 e0 6f 11 80 f4 	movl   $0x1f4,0x80116fe0
8010478d:	01 00 00 
  #endif
  release(&ptable.lock);
80104790:	83 ec 0c             	sub    $0xc,%esp
80104793:	68 80 49 11 80       	push   $0x80114980
80104798:	e8 f9 1b 00 00       	call   80106396 <release>
8010479d:	83 c4 10             	add    $0x10,%esp
  
  p = allocproc();
801047a0:	e8 7f fd ff ff       	call   80104524 <allocproc>
801047a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801047a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ab:	a3 68 d6 10 80       	mov    %eax,0x8010d668
  if((p->pgdir = setupkvm()) == 0)
801047b0:	e8 f1 49 00 00       	call   801091a6 <setupkvm>
801047b5:	89 c2                	mov    %eax,%edx
801047b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ba:	89 50 04             	mov    %edx,0x4(%eax)
801047bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c0:	8b 40 04             	mov    0x4(%eax),%eax
801047c3:	85 c0                	test   %eax,%eax
801047c5:	75 0d                	jne    801047d4 <userinit+0xea>
    panic("userinit: out of memory?");
801047c7:	83 ec 0c             	sub    $0xc,%esp
801047ca:	68 1b 9d 10 80       	push   $0x80109d1b
801047cf:	e8 92 bd ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047d4:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047dc:	8b 40 04             	mov    0x4(%eax),%eax
801047df:	83 ec 04             	sub    $0x4,%esp
801047e2:	52                   	push   %edx
801047e3:	68 00 d5 10 80       	push   $0x8010d500
801047e8:	50                   	push   %eax
801047e9:	e8 12 4c 00 00       	call   80109400 <inituvm>
801047ee:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801047f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f4:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801047fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047fd:	8b 40 18             	mov    0x18(%eax),%eax
80104800:	83 ec 04             	sub    $0x4,%esp
80104803:	6a 4c                	push   $0x4c
80104805:	6a 00                	push   $0x0
80104807:	50                   	push   %eax
80104808:	e8 85 1d 00 00       	call   80106592 <memset>
8010480d:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104810:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104813:	8b 40 18             	mov    0x18(%eax),%eax
80104816:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010481c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481f:	8b 40 18             	mov    0x18(%eax),%eax
80104822:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482b:	8b 40 18             	mov    0x18(%eax),%eax
8010482e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104831:	8b 52 18             	mov    0x18(%edx),%edx
80104834:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104838:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010483c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483f:	8b 40 18             	mov    0x18(%eax),%eax
80104842:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104845:	8b 52 18             	mov    0x18(%edx),%edx
80104848:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010484c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104853:	8b 40 18             	mov    0x18(%eax),%eax
80104856:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010485d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104860:	8b 40 18             	mov    0x18(%eax),%eax
80104863:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010486a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010486d:	8b 40 18             	mov    0x18(%eax),%eax
80104870:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->uid = DEFAULTUID; // p2
80104877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487a:	c7 80 80 00 00 00 0a 	movl   $0xa,0x80(%eax)
80104881:	00 00 00 
  p->gid = DEFAULTGID; // p2
80104884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104887:	c7 80 84 00 00 00 0a 	movl   $0xa,0x84(%eax)
8010488e:	00 00 00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104891:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104894:	83 c0 6c             	add    $0x6c,%eax
80104897:	83 ec 04             	sub    $0x4,%esp
8010489a:	6a 10                	push   $0x10
8010489c:	68 34 9d 10 80       	push   $0x80109d34
801048a1:	50                   	push   %eax
801048a2:	e8 ee 1e 00 00       	call   80106795 <safestrcpy>
801048a7:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801048aa:	83 ec 0c             	sub    $0xc,%esp
801048ad:	68 3d 9d 10 80       	push   $0x80109d3d
801048b2:	e8 1b dd ff ff       	call   801025d2 <namei>
801048b7:	83 c4 10             	add    $0x10,%esp
801048ba:	89 c2                	mov    %eax,%edx
801048bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048bf:	89 50 68             	mov    %edx,0x68(%eax)

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
801048c2:	83 ec 0c             	sub    $0xc,%esp
801048c5:	68 80 49 11 80       	push   $0x80114980
801048ca:	e8 60 1a 00 00       	call   8010632f <acquire>
801048cf:	83 c4 10             	add    $0x10,%esp
  remove_from_list(&ptable.pLists.embryo, p);
801048d2:	83 ec 08             	sub    $0x8,%esp
801048d5:	ff 75 f4             	pushl  -0xc(%ebp)
801048d8:	68 b8 6f 11 80       	push   $0x80116fb8
801048dd:	e8 50 15 00 00       	call   80105e32 <remove_from_list>
801048e2:	83 c4 10             	add    $0x10,%esp
  assert_state(p, EMBRYO);
801048e5:	83 ec 08             	sub    $0x8,%esp
801048e8:	6a 01                	push   $0x1
801048ea:	ff 75 f4             	pushl  -0xc(%ebp)
801048ed:	e8 1f 15 00 00       	call   80105e11 <assert_state>
801048f2:	83 c4 10             	add    $0x10,%esp
  #endif
  p->state = RUNNABLE;
801048f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  // the front of the ready list. Ocurrences after this use the
  // add to ready function.
  #ifndef P4                                                                 // NEW IFNDEF P4
  ptable.pLists.ready = p;
  #else
  ptable.pLists.ready[0] = p;
801048ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104902:	a3 bc 6f 11 80       	mov    %eax,0x80116fbc
  #endif
  p->next = 0;
80104907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490a:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104911:	00 00 00 
  release(&ptable.lock);
80104914:	83 ec 0c             	sub    $0xc,%esp
80104917:	68 80 49 11 80       	push   $0x80114980
8010491c:	e8 75 1a 00 00       	call   80106396 <release>
80104921:	83 c4 10             	add    $0x10,%esp
  #endif
}
80104924:	90                   	nop
80104925:	c9                   	leave  
80104926:	c3                   	ret    

80104927 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104927:	55                   	push   %ebp
80104928:	89 e5                	mov    %esp,%ebp
8010492a:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010492d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104933:	8b 00                	mov    (%eax),%eax
80104935:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104938:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010493c:	7e 31                	jle    8010496f <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010493e:	8b 55 08             	mov    0x8(%ebp),%edx
80104941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104944:	01 c2                	add    %eax,%edx
80104946:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010494c:	8b 40 04             	mov    0x4(%eax),%eax
8010494f:	83 ec 04             	sub    $0x4,%esp
80104952:	52                   	push   %edx
80104953:	ff 75 f4             	pushl  -0xc(%ebp)
80104956:	50                   	push   %eax
80104957:	e8 f1 4b 00 00       	call   8010954d <allocuvm>
8010495c:	83 c4 10             	add    $0x10,%esp
8010495f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104962:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104966:	75 3e                	jne    801049a6 <growproc+0x7f>
      return -1;
80104968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010496d:	eb 59                	jmp    801049c8 <growproc+0xa1>
  } else if(n < 0){
8010496f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104973:	79 31                	jns    801049a6 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104975:	8b 55 08             	mov    0x8(%ebp),%edx
80104978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010497b:	01 c2                	add    %eax,%edx
8010497d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104983:	8b 40 04             	mov    0x4(%eax),%eax
80104986:	83 ec 04             	sub    $0x4,%esp
80104989:	52                   	push   %edx
8010498a:	ff 75 f4             	pushl  -0xc(%ebp)
8010498d:	50                   	push   %eax
8010498e:	e8 83 4c 00 00       	call   80109616 <deallocuvm>
80104993:	83 c4 10             	add    $0x10,%esp
80104996:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104999:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010499d:	75 07                	jne    801049a6 <growproc+0x7f>
      return -1;
8010499f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049a4:	eb 22                	jmp    801049c8 <growproc+0xa1>
  }
  proc->sz = sz;
801049a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049af:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801049b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049b7:	83 ec 0c             	sub    $0xc,%esp
801049ba:	50                   	push   %eax
801049bb:	e8 cd 48 00 00       	call   8010928d <switchuvm>
801049c0:	83 c4 10             	add    $0x10,%esp
  return 0;
801049c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049c8:	c9                   	leave  
801049c9:	c3                   	ret    

801049ca <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801049ca:	55                   	push   %ebp
801049cb:	89 e5                	mov    %esp,%ebp
801049cd:	57                   	push   %edi
801049ce:	56                   	push   %esi
801049cf:	53                   	push   %ebx
801049d0:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801049d3:	e8 4c fb ff ff       	call   80104524 <allocproc>
801049d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049df:	75 0a                	jne    801049eb <fork+0x21>
    return -1;
801049e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049e6:	e9 4d 02 00 00       	jmp    80104c38 <fork+0x26e>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801049eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f1:	8b 10                	mov    (%eax),%edx
801049f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f9:	8b 40 04             	mov    0x4(%eax),%eax
801049fc:	83 ec 08             	sub    $0x8,%esp
801049ff:	52                   	push   %edx
80104a00:	50                   	push   %eax
80104a01:	e8 ae 4d 00 00       	call   801097b4 <copyuvm>
80104a06:	83 c4 10             	add    $0x10,%esp
80104a09:	89 c2                	mov    %eax,%edx
80104a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a0e:	89 50 04             	mov    %edx,0x4(%eax)
80104a11:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a14:	8b 40 04             	mov    0x4(%eax),%eax
80104a17:	85 c0                	test   %eax,%eax
80104a19:	0f 85 b4 00 00 00    	jne    80104ad3 <fork+0x109>
    kfree(np->kstack);
80104a1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a22:	8b 40 08             	mov    0x8(%eax),%eax
80104a25:	83 ec 0c             	sub    $0xc,%esp
80104a28:	50                   	push   %eax
80104a29:	e8 45 e2 ff ff       	call   80102c73 <kfree>
80104a2e:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a34:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104a3b:	83 ec 0c             	sub    $0xc,%esp
80104a3e:	68 80 49 11 80       	push   $0x80114980
80104a43:	e8 e7 18 00 00       	call   8010632f <acquire>
80104a48:	83 c4 10             	add    $0x10,%esp
    int code = remove_from_list(&ptable.pLists.embryo, np);
80104a4b:	83 ec 08             	sub    $0x8,%esp
80104a4e:	ff 75 e0             	pushl  -0x20(%ebp)
80104a51:	68 b8 6f 11 80       	push   $0x80116fb8
80104a56:	e8 d7 13 00 00       	call   80105e32 <remove_from_list>
80104a5b:	83 c4 10             	add    $0x10,%esp
80104a5e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (code < 0)
80104a61:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104a65:	79 0d                	jns    80104a74 <fork+0xaa>
      panic("ERROR: Couldn't remove from embryo.");
80104a67:	83 ec 0c             	sub    $0xc,%esp
80104a6a:	68 40 9d 10 80       	push   $0x80109d40
80104a6f:	e8 f2 ba ff ff       	call   80100566 <panic>
    assert_state(np, EMBRYO);
80104a74:	83 ec 08             	sub    $0x8,%esp
80104a77:	6a 01                	push   $0x1
80104a79:	ff 75 e0             	pushl  -0x20(%ebp)
80104a7c:	e8 90 13 00 00       	call   80105e11 <assert_state>
80104a81:	83 c4 10             	add    $0x10,%esp
    #endif
    np->state = UNUSED;
80104a84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a87:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #ifdef CS333_P3P4
    int code2 = add_to_list(&ptable.pLists.free, UNUSED, np);
80104a8e:	83 ec 04             	sub    $0x4,%esp
80104a91:	ff 75 e0             	pushl  -0x20(%ebp)
80104a94:	6a 00                	push   $0x0
80104a96:	68 b4 6f 11 80       	push   $0x80116fb4
80104a9b:	e8 3e 14 00 00       	call   80105ede <add_to_list>
80104aa0:	83 c4 10             	add    $0x10,%esp
80104aa3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (code2 < 0)
80104aa6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80104aaa:	79 0d                	jns    80104ab9 <fork+0xef>
      panic("ERROR: Couldn't add process back to free.");
80104aac:	83 ec 0c             	sub    $0xc,%esp
80104aaf:	68 64 9d 10 80       	push   $0x80109d64
80104ab4:	e8 ad ba ff ff       	call   80100566 <panic>
    release(&ptable.lock);
80104ab9:	83 ec 0c             	sub    $0xc,%esp
80104abc:	68 80 49 11 80       	push   $0x80114980
80104ac1:	e8 d0 18 00 00       	call   80106396 <release>
80104ac6:	83 c4 10             	add    $0x10,%esp
    #endif
    return -1;
80104ac9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ace:	e9 65 01 00 00       	jmp    80104c38 <fork+0x26e>
  }
  np->sz = proc->sz;
80104ad3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ad9:	8b 10                	mov    (%eax),%edx
80104adb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ade:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104ae0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aea:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104af0:	8b 50 18             	mov    0x18(%eax),%edx
80104af3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af9:	8b 40 18             	mov    0x18(%eax),%eax
80104afc:	89 c3                	mov    %eax,%ebx
80104afe:	b8 13 00 00 00       	mov    $0x13,%eax
80104b03:	89 d7                	mov    %edx,%edi
80104b05:	89 de                	mov    %ebx,%esi
80104b07:	89 c1                	mov    %eax,%ecx
80104b09:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // I'm pretty sure that this is where we put the uid/gid copy
  np -> uid = proc -> uid; // p2
80104b0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b11:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104b17:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b1a:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np -> gid = proc -> gid; // p2
80104b20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b26:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104b2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b2f:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104b35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b38:	8b 40 18             	mov    0x18(%eax),%eax
80104b3b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104b42:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b49:	eb 43                	jmp    80104b8e <fork+0x1c4>
    if(proc->ofile[i])
80104b4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b54:	83 c2 08             	add    $0x8,%edx
80104b57:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b5b:	85 c0                	test   %eax,%eax
80104b5d:	74 2b                	je     80104b8a <fork+0x1c0>
      np->ofile[i] = filedup(proc->ofile[i]);
80104b5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b68:	83 c2 08             	add    $0x8,%edx
80104b6b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b6f:	83 ec 0c             	sub    $0xc,%esp
80104b72:	50                   	push   %eax
80104b73:	e8 32 c5 ff ff       	call   801010aa <filedup>
80104b78:	83 c4 10             	add    $0x10,%esp
80104b7b:	89 c1                	mov    %eax,%ecx
80104b7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b83:	83 c2 08             	add    $0x8,%edx
80104b86:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np -> gid = proc -> gid; // p2

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104b8a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b8e:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b92:	7e b7                	jle    80104b4b <fork+0x181>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104b94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b9a:	8b 40 68             	mov    0x68(%eax),%eax
80104b9d:	83 ec 0c             	sub    $0xc,%esp
80104ba0:	50                   	push   %eax
80104ba1:	e8 34 ce ff ff       	call   801019da <idup>
80104ba6:	83 c4 10             	add    $0x10,%esp
80104ba9:	89 c2                	mov    %eax,%edx
80104bab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bae:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104bb1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb7:	8d 50 6c             	lea    0x6c(%eax),%edx
80104bba:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bbd:	83 c0 6c             	add    $0x6c,%eax
80104bc0:	83 ec 04             	sub    $0x4,%esp
80104bc3:	6a 10                	push   $0x10
80104bc5:	52                   	push   %edx
80104bc6:	50                   	push   %eax
80104bc7:	e8 c9 1b 00 00       	call   80106795 <safestrcpy>
80104bcc:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bd2:	8b 40 10             	mov    0x10(%eax),%eax
80104bd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104bd8:	83 ec 0c             	sub    $0xc,%esp
80104bdb:	68 80 49 11 80       	push   $0x80114980
80104be0:	e8 4a 17 00 00       	call   8010632f <acquire>
80104be5:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.embryo, np);
80104be8:	83 ec 08             	sub    $0x8,%esp
80104beb:	ff 75 e0             	pushl  -0x20(%ebp)
80104bee:	68 b8 6f 11 80       	push   $0x80116fb8
80104bf3:	e8 3a 12 00 00       	call   80105e32 <remove_from_list>
80104bf8:	83 c4 10             	add    $0x10,%esp
  assert_state(np, EMBRYO);
80104bfb:	83 ec 08             	sub    $0x8,%esp
80104bfe:	6a 01                	push   $0x1
80104c00:	ff 75 e0             	pushl  -0x20(%ebp)
80104c03:	e8 09 12 00 00       	call   80105e11 <assert_state>
80104c08:	83 c4 10             	add    $0x10,%esp
  #endif
  np->state = RUNNABLE;
80104c0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c0e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  add_to_ready(np, RUNNABLE);
80104c15:	83 ec 08             	sub    $0x8,%esp
80104c18:	6a 03                	push   $0x3
80104c1a:	ff 75 e0             	pushl  -0x20(%ebp)
80104c1d:	e8 fd 12 00 00       	call   80105f1f <add_to_ready>
80104c22:	83 c4 10             	add    $0x10,%esp
  #endif
  release(&ptable.lock);
80104c25:	83 ec 0c             	sub    $0xc,%esp
80104c28:	68 80 49 11 80       	push   $0x80114980
80104c2d:	e8 64 17 00 00       	call   80106396 <release>
80104c32:	83 c4 10             	add    $0x10,%esp
  return pid;
80104c35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80104c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c3b:	5b                   	pop    %ebx
80104c3c:	5e                   	pop    %esi
80104c3d:	5f                   	pop    %edi
80104c3e:	5d                   	pop    %ebp
80104c3f:	c3                   	ret    

80104c40 <exit>:
}

#else
void
exit(void)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int fd;

  if (proc == initproc)
80104c46:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c4d:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104c52:	39 c2                	cmp    %eax,%edx
80104c54:	75 0d                	jne    80104c63 <exit+0x23>
    panic("init exiting");
80104c56:	83 ec 0c             	sub    $0xc,%esp
80104c59:	68 8e 9d 10 80       	push   $0x80109d8e
80104c5e:	e8 03 b9 ff ff       	call   80100566 <panic>

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104c63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c6a:	eb 48                	jmp    80104cb4 <exit+0x74>
    if(proc->ofile[fd]) {
80104c6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c72:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c75:	83 c2 08             	add    $0x8,%edx
80104c78:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c7c:	85 c0                	test   %eax,%eax
80104c7e:	74 30                	je     80104cb0 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104c80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c86:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c89:	83 c2 08             	add    $0x8,%edx
80104c8c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c90:	83 ec 0c             	sub    $0xc,%esp
80104c93:	50                   	push   %eax
80104c94:	e8 62 c4 ff ff       	call   801010fb <fileclose>
80104c99:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104c9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ca5:	83 c2 08             	add    $0x8,%edx
80104ca8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104caf:	00 

  if (proc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104cb0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104cb4:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104cb8:	7e b2                	jle    80104c6c <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104cba:	e8 38 e9 ff ff       	call   801035f7 <begin_op>
  iput(proc->cwd);
80104cbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc5:	8b 40 68             	mov    0x68(%eax),%eax
80104cc8:	83 ec 0c             	sub    $0xc,%esp
80104ccb:	50                   	push   %eax
80104ccc:	e8 13 cf ff ff       	call   80101be4 <iput>
80104cd1:	83 c4 10             	add    $0x10,%esp
  end_op();
80104cd4:	e8 aa e9 ff ff       	call   80103683 <end_op>
  proc->cwd = 0;
80104cd9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cdf:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104ce6:	83 ec 0c             	sub    $0xc,%esp
80104ce9:	68 80 49 11 80       	push   $0x80114980
80104cee:	e8 3c 16 00 00       	call   8010632f <acquire>
80104cf3:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104cf6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cfc:	8b 40 14             	mov    0x14(%eax),%eax
80104cff:	83 ec 0c             	sub    $0xc,%esp
80104d02:	50                   	push   %eax
80104d03:	e8 d2 06 00 00       	call   801053da <wakeup1>
80104d08:	83 c4 10             	add    $0x10,%esp

  // Run exit helper to check process parents against the
  // currently running process. 
  exit_helper(&ptable.pLists.embryo);
80104d0b:	83 ec 0c             	sub    $0xc,%esp
80104d0e:	68 b8 6f 11 80       	push   $0x80116fb8
80104d13:	e8 d8 12 00 00       	call   80105ff0 <exit_helper>
80104d18:	83 c4 10             	add    $0x10,%esp
  #ifndef P4
  exit_helper(&ptable.pLists.ready);
  #else
  for (int i = 0; i < MAX+1; i++)
80104d1b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104d22:	eb 23                	jmp    80104d47 <exit+0x107>
    exit_helper(&ptable.pLists.ready[i]);
80104d24:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d27:	05 8c 09 00 00       	add    $0x98c,%eax
80104d2c:	c1 e0 02             	shl    $0x2,%eax
80104d2f:	05 80 49 11 80       	add    $0x80114980,%eax
80104d34:	83 c0 0c             	add    $0xc,%eax
80104d37:	83 ec 0c             	sub    $0xc,%esp
80104d3a:	50                   	push   %eax
80104d3b:	e8 b0 12 00 00       	call   80105ff0 <exit_helper>
80104d40:	83 c4 10             	add    $0x10,%esp
  // currently running process. 
  exit_helper(&ptable.pLists.embryo);
  #ifndef P4
  exit_helper(&ptable.pLists.ready);
  #else
  for (int i = 0; i < MAX+1; i++)
80104d43:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104d47:	83 7d ec 05          	cmpl   $0x5,-0x14(%ebp)
80104d4b:	7e d7                	jle    80104d24 <exit+0xe4>
    exit_helper(&ptable.pLists.ready[i]);
  #endif
  exit_helper(&ptable.pLists.running);
80104d4d:	83 ec 0c             	sub    $0xc,%esp
80104d50:	68 d4 6f 11 80       	push   $0x80116fd4
80104d55:	e8 96 12 00 00       	call   80105ff0 <exit_helper>
80104d5a:	83 c4 10             	add    $0x10,%esp
  exit_helper(&ptable.pLists.sleep);
80104d5d:	83 ec 0c             	sub    $0xc,%esp
80104d60:	68 d8 6f 11 80       	push   $0x80116fd8
80104d65:	e8 86 12 00 00       	call   80105ff0 <exit_helper>
80104d6a:	83 c4 10             	add    $0x10,%esp

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
80104d6d:	a1 dc 6f 11 80       	mov    0x80116fdc,%eax
80104d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80104d75:	eb 39                	jmp    80104db0 <exit+0x170>
    if (p->parent == proc) {
80104d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d7a:	8b 50 14             	mov    0x14(%eax),%edx
80104d7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d83:	39 c2                	cmp    %eax,%edx
80104d85:	75 1d                	jne    80104da4 <exit+0x164>
      p->parent = initproc;
80104d87:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d90:	89 50 14             	mov    %edx,0x14(%eax)
      wakeup1(initproc);
80104d93:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	50                   	push   %eax
80104d9c:	e8 39 06 00 00       	call   801053da <wakeup1>
80104da1:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
80104da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da7:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  exit_helper(&ptable.pLists.sleep);

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
  while (p) {
80104db0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104db4:	75 c1                	jne    80104d77 <exit+0x137>
      wakeup1(initproc);
    }
    p = p->next;
  }

  remove_from_list(&ptable.pLists.running, proc);
80104db6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dbc:	83 ec 08             	sub    $0x8,%esp
80104dbf:	50                   	push   %eax
80104dc0:	68 d4 6f 11 80       	push   $0x80116fd4
80104dc5:	e8 68 10 00 00       	call   80105e32 <remove_from_list>
80104dca:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
80104dcd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dd3:	83 ec 08             	sub    $0x8,%esp
80104dd6:	6a 04                	push   $0x4
80104dd8:	50                   	push   %eax
80104dd9:	e8 33 10 00 00       	call   80105e11 <assert_state>
80104dde:	83 c4 10             	add    $0x10,%esp
  proc->state = ZOMBIE;
80104de1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de7:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  add_to_list(&ptable.pLists.zombie, ZOMBIE, proc);
80104dee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104df4:	83 ec 04             	sub    $0x4,%esp
80104df7:	50                   	push   %eax
80104df8:	6a 05                	push   $0x5
80104dfa:	68 dc 6f 11 80       	push   $0x80116fdc
80104dff:	e8 da 10 00 00       	call   80105ede <add_to_list>
80104e04:	83 c4 10             	add    $0x10,%esp
  sched();
80104e07:	e8 33 03 00 00       	call   8010513f <sched>
  panic("zombie exit");
80104e0c:	83 ec 0c             	sub    $0xc,%esp
80104e0f:	68 9b 9d 10 80       	push   $0x80109d9b
80104e14:	e8 4d b7 ff ff       	call   80100566 <panic>

80104e19 <wait>:
}

#else
int
wait(void)
{
80104e19:	55                   	push   %ebp
80104e1a:	89 e5                	mov    %esp,%ebp
80104e1c:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int havekids, pid;

  acquire(&ptable.lock);
80104e1f:	83 ec 0c             	sub    $0xc,%esp
80104e22:	68 80 49 11 80       	push   $0x80114980
80104e27:	e8 03 15 00 00       	call   8010632f <acquire>
80104e2c:	83 c4 10             	add    $0x10,%esp
  for(;;) {
    // Scan through table looking for zombie children
    havekids = 0;
80104e2f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    // Run wait helper function to search each list and check
    // if process parent is the currently running process and
    // set havekids to 1 if that is the case.
    wait_helper(&ptable.pLists.embryo, &havekids);
80104e36:	83 ec 08             	sub    $0x8,%esp
80104e39:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104e3c:	50                   	push   %eax
80104e3d:	68 b8 6f 11 80       	push   $0x80116fb8
80104e42:	e8 ea 11 00 00       	call   80106031 <wait_helper>
80104e47:	83 c4 10             	add    $0x10,%esp
    #ifndef P4
    wait_helper(&ptable.pLists.ready, &havekids);
    #else
    for (int i = 0; i < MAX+1; i++)
80104e4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104e51:	eb 27                	jmp    80104e7a <wait+0x61>
      wait_helper(&ptable.pLists.ready[i], &havekids);
80104e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e56:	05 8c 09 00 00       	add    $0x98c,%eax
80104e5b:	c1 e0 02             	shl    $0x2,%eax
80104e5e:	05 80 49 11 80       	add    $0x80114980,%eax
80104e63:	8d 50 0c             	lea    0xc(%eax),%edx
80104e66:	83 ec 08             	sub    $0x8,%esp
80104e69:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104e6c:	50                   	push   %eax
80104e6d:	52                   	push   %edx
80104e6e:	e8 be 11 00 00       	call   80106031 <wait_helper>
80104e73:	83 c4 10             	add    $0x10,%esp
    // set havekids to 1 if that is the case.
    wait_helper(&ptable.pLists.embryo, &havekids);
    #ifndef P4
    wait_helper(&ptable.pLists.ready, &havekids);
    #else
    for (int i = 0; i < MAX+1; i++)
80104e76:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104e7a:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80104e7e:	7e d3                	jle    80104e53 <wait+0x3a>
      wait_helper(&ptable.pLists.ready[i], &havekids);
    #endif
    wait_helper(&ptable.pLists.running, &havekids);
80104e80:	83 ec 08             	sub    $0x8,%esp
80104e83:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104e86:	50                   	push   %eax
80104e87:	68 d4 6f 11 80       	push   $0x80116fd4
80104e8c:	e8 a0 11 00 00       	call   80106031 <wait_helper>
80104e91:	83 c4 10             	add    $0x10,%esp
    wait_helper(&ptable.pLists.sleep, &havekids);
80104e94:	83 ec 08             	sub    $0x8,%esp
80104e97:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104e9a:	50                   	push   %eax
80104e9b:	68 d8 6f 11 80       	push   $0x80116fd8
80104ea0:	e8 8c 11 00 00       	call   80106031 <wait_helper>
80104ea5:	83 c4 10             	add    $0x10,%esp

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
80104ea8:	a1 dc 6f 11 80       	mov    0x80116fdc,%eax
80104ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104eb0:	e9 e7 00 00 00       	jmp    80104f9c <wait+0x183>
      if (p->parent == proc) {
80104eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb8:	8b 50 14             	mov    0x14(%eax),%edx
80104ebb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ec1:	39 c2                	cmp    %eax,%edx
80104ec3:	0f 85 c7 00 00 00    	jne    80104f90 <wait+0x177>
        havekids = 1;
80104ec9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
        // Found one.
        pid = p->pid;
80104ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed3:	8b 40 10             	mov    0x10(%eax),%eax
80104ed6:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104edc:	8b 40 08             	mov    0x8(%eax),%eax
80104edf:	83 ec 0c             	sub    $0xc,%esp
80104ee2:	50                   	push   %eax
80104ee3:	e8 8b dd ff ff       	call   80102c73 <kfree>
80104ee8:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef8:	8b 40 04             	mov    0x4(%eax),%eax
80104efb:	83 ec 0c             	sub    $0xc,%esp
80104efe:	50                   	push   %eax
80104eff:	e8 cf 47 00 00       	call   801096d3 <freevm>
80104f04:	83 c4 10             	add    $0x10,%esp
        remove_from_list(&ptable.pLists.zombie, p);
80104f07:	83 ec 08             	sub    $0x8,%esp
80104f0a:	ff 75 f4             	pushl  -0xc(%ebp)
80104f0d:	68 dc 6f 11 80       	push   $0x80116fdc
80104f12:	e8 1b 0f 00 00       	call   80105e32 <remove_from_list>
80104f17:	83 c4 10             	add    $0x10,%esp
        assert_state(p, ZOMBIE);
80104f1a:	83 ec 08             	sub    $0x8,%esp
80104f1d:	6a 05                	push   $0x5
80104f1f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f22:	e8 ea 0e 00 00       	call   80105e11 <assert_state>
80104f27:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f37:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f41:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f52:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->priority = 0;
80104f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f5c:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104f63:	00 00 00 
        add_to_list(&ptable.pLists.free, UNUSED, p);
80104f66:	83 ec 04             	sub    $0x4,%esp
80104f69:	ff 75 f4             	pushl  -0xc(%ebp)
80104f6c:	6a 00                	push   $0x0
80104f6e:	68 b4 6f 11 80       	push   $0x80116fb4
80104f73:	e8 66 0f 00 00       	call   80105ede <add_to_list>
80104f78:	83 c4 10             	add    $0x10,%esp
        release(&ptable.lock);
80104f7b:	83 ec 0c             	sub    $0xc,%esp
80104f7e:	68 80 49 11 80       	push   $0x80114980
80104f83:	e8 0e 14 00 00       	call   80106396 <release>
80104f88:	83 c4 10             	add    $0x10,%esp
        return pid;
80104f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f8e:	eb 5d                	jmp    80104fed <wait+0x1d4>
      }
      p = p->next;
80104f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f93:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
    wait_helper(&ptable.pLists.sleep, &havekids);

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
    while (p) {
80104f9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104fa0:	0f 85 0f ff ff ff    	jne    80104eb5 <wait+0x9c>
      }
      p = p->next;
    }

    // No point waiting if we don't have any children
    if (!havekids || proc->killed) {
80104fa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104fa9:	85 c0                	test   %eax,%eax
80104fab:	74 0d                	je     80104fba <wait+0x1a1>
80104fad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fb3:	8b 40 24             	mov    0x24(%eax),%eax
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	74 17                	je     80104fd1 <wait+0x1b8>
      release(&ptable.lock);
80104fba:	83 ec 0c             	sub    $0xc,%esp
80104fbd:	68 80 49 11 80       	push   $0x80114980
80104fc2:	e8 cf 13 00 00       	call   80106396 <release>
80104fc7:	83 c4 10             	add    $0x10,%esp
      return -1;
80104fca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fcf:	eb 1c                	jmp    80104fed <wait+0x1d4>
    }

    // Wait for children to exit. (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104fd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fd7:	83 ec 08             	sub    $0x8,%esp
80104fda:	68 80 49 11 80       	push   $0x80114980
80104fdf:	50                   	push   %eax
80104fe0:	e8 0c 03 00 00       	call   801052f1 <sleep>
80104fe5:	83 c4 10             	add    $0x10,%esp
  }
80104fe8:	e9 42 fe ff ff       	jmp    80104e2f <wait+0x16>
}
80104fed:	c9                   	leave  
80104fee:	c3                   	ret    

80104fef <scheduler>:
}

#else
void
scheduler(void)
{
80104fef:	55                   	push   %ebp
80104ff0:	89 e5                	mov    %esp,%ebp
80104ff2:	83 ec 18             	sub    $0x18,%esp
  #endif

  for(;;) {

    // Enable interrupts on this processor.
    sti();
80104ff5:	e8 05 f5 ff ff       	call   801044ff <sti>
    idle = 1;   // assume idle unless we schedule a process
80104ffa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    
    acquire(&ptable.lock);
80105001:	83 ec 0c             	sub    $0xc,%esp
80105004:	68 80 49 11 80       	push   $0x80114980
80105009:	e8 21 13 00 00       	call   8010632f <acquire>
8010500e:	83 c4 10             	add    $0x10,%esp
    #ifdef P4
    promo = ticks; // Set promo to ticks and check if promo needs to happen
80105011:	a1 00 78 11 80       	mov    0x80117800,%eax
80105016:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (promo == ptable.promote_at_time) {
80105019:	a1 e0 6f 11 80       	mov    0x80116fe0,%eax
8010501e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105021:	75 0f                	jne    80105032 <scheduler+0x43>
      //Perform promotion here
      //Increment promote_at_time
      ptable.promote_at_time = ticks + TICKS_TO_PROMOTE;
80105023:	a1 00 78 11 80       	mov    0x80117800,%eax
80105028:	05 f4 01 00 00       	add    $0x1f4,%eax
8010502d:	a3 e0 6f 11 80       	mov    %eax,0x80116fe0
    }
    #endif    
    
    for (int i = 0; i < MAX+1; i++) {
80105032:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105039:	e9 ce 00 00 00       	jmp    8010510c <scheduler+0x11d>
      p = ptable.pLists.ready[i];                                              // P4 changes
8010503e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105041:	05 8c 09 00 00       	add    $0x98c,%eax
80105046:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
8010504d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(p) {
80105050:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80105054:	0f 84 ae 00 00 00    	je     80105108 <scheduler+0x119>
        remove_from_list(&ptable.pLists.ready[i], p);
8010505a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010505d:	05 8c 09 00 00       	add    $0x98c,%eax
80105062:	c1 e0 02             	shl    $0x2,%eax
80105065:	05 80 49 11 80       	add    $0x80114980,%eax
8010506a:	83 c0 0c             	add    $0xc,%eax
8010506d:	83 ec 08             	sub    $0x8,%esp
80105070:	ff 75 e8             	pushl  -0x18(%ebp)
80105073:	50                   	push   %eax
80105074:	e8 b9 0d 00 00       	call   80105e32 <remove_from_list>
80105079:	83 c4 10             	add    $0x10,%esp
        assert_state(p, RUNNABLE);
8010507c:	83 ec 08             	sub    $0x8,%esp
8010507f:	6a 03                	push   $0x3
80105081:	ff 75 e8             	pushl  -0x18(%ebp)
80105084:	e8 88 0d 00 00       	call   80105e11 <assert_state>
80105089:	83 c4 10             	add    $0x10,%esp
        idle = 0;  // not idle this timeslice
8010508c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        proc = p;
80105093:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105096:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
        switchuvm(p);
8010509c:	83 ec 0c             	sub    $0xc,%esp
8010509f:	ff 75 e8             	pushl  -0x18(%ebp)
801050a2:	e8 e6 41 00 00       	call   8010928d <switchuvm>
801050a7:	83 c4 10             	add    $0x10,%esp
        p->state = RUNNING;
801050aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801050ad:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
        add_to_list(&ptable.pLists.running, RUNNING, p);
801050b4:	83 ec 04             	sub    $0x4,%esp
801050b7:	ff 75 e8             	pushl  -0x18(%ebp)
801050ba:	6a 04                	push   $0x4
801050bc:	68 d4 6f 11 80       	push   $0x80116fd4
801050c1:	e8 18 0e 00 00       	call   80105ede <add_to_list>
801050c6:	83 c4 10             	add    $0x10,%esp
        p->cpu_ticks_in = ticks;  // My code p3
801050c9:	8b 15 00 78 11 80    	mov    0x80117800,%edx
801050cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801050d2:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
        swtch(&cpu->scheduler, proc->context);
801050d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050de:	8b 40 1c             	mov    0x1c(%eax),%eax
801050e1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050e8:	83 c2 04             	add    $0x4,%edx
801050eb:	83 ec 08             	sub    $0x8,%esp
801050ee:	50                   	push   %eax
801050ef:	52                   	push   %edx
801050f0:	e8 11 17 00 00       	call   80106806 <swtch>
801050f5:	83 c4 10             	add    $0x10,%esp
        switchkvm();
801050f8:	e8 73 41 00 00       	call   80109270 <switchkvm>
    
        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0; 
801050fd:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80105104:	00 00 00 00 
      //Increment promote_at_time
      ptable.promote_at_time = ticks + TICKS_TO_PROMOTE;
    }
    #endif    
    
    for (int i = 0; i < MAX+1; i++) {
80105108:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010510c:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80105110:	0f 8e 28 ff ff ff    	jle    8010503e <scheduler+0x4f>
        // It should have changed its p->state before coming back.
        proc = 0; 
      }
    }

    release(&ptable.lock);
80105116:	83 ec 0c             	sub    $0xc,%esp
80105119:	68 80 49 11 80       	push   $0x80114980
8010511e:	e8 73 12 00 00       	call   80106396 <release>
80105123:	83 c4 10             	add    $0x10,%esp
    if (idle) {
80105126:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010512a:	0f 84 c5 fe ff ff    	je     80104ff5 <scheduler+0x6>
      sti();
80105130:	e8 ca f3 ff ff       	call   801044ff <sti>
      hlt();
80105135:	e8 ae f3 ff ff       	call   801044e8 <hlt>
    }
  }
8010513a:	e9 b6 fe ff ff       	jmp    80104ff5 <scheduler+0x6>

8010513f <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
8010513f:	55                   	push   %ebp
80105140:	89 e5                	mov    %esp,%ebp
80105142:	53                   	push   %ebx
80105143:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80105146:	83 ec 0c             	sub    $0xc,%esp
80105149:	68 80 49 11 80       	push   $0x80114980
8010514e:	e8 0f 13 00 00       	call   80106462 <holding>
80105153:	83 c4 10             	add    $0x10,%esp
80105156:	85 c0                	test   %eax,%eax
80105158:	75 0d                	jne    80105167 <sched+0x28>
    panic("sched ptable.lock");
8010515a:	83 ec 0c             	sub    $0xc,%esp
8010515d:	68 a7 9d 10 80       	push   $0x80109da7
80105162:	e8 ff b3 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80105167:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010516d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105173:	83 f8 01             	cmp    $0x1,%eax
80105176:	74 0d                	je     80105185 <sched+0x46>
    panic("sched locks");
80105178:	83 ec 0c             	sub    $0xc,%esp
8010517b:	68 b9 9d 10 80       	push   $0x80109db9
80105180:	e8 e1 b3 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80105185:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010518b:	8b 40 0c             	mov    0xc(%eax),%eax
8010518e:	83 f8 04             	cmp    $0x4,%eax
80105191:	75 0d                	jne    801051a0 <sched+0x61>
    panic("sched running");
80105193:	83 ec 0c             	sub    $0xc,%esp
80105196:	68 c5 9d 10 80       	push   $0x80109dc5
8010519b:	e8 c6 b3 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
801051a0:	e8 4a f3 ff ff       	call   801044ef <readeflags>
801051a5:	25 00 02 00 00       	and    $0x200,%eax
801051aa:	85 c0                	test   %eax,%eax
801051ac:	74 0d                	je     801051bb <sched+0x7c>
    panic("sched interruptible");
801051ae:	83 ec 0c             	sub    $0xc,%esp
801051b1:	68 d3 9d 10 80       	push   $0x80109dd3
801051b6:	e8 ab b3 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
801051bb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051c1:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801051c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // My code p2
801051ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051d0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051d7:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801051dd:	8b 1d 00 78 11 80    	mov    0x80117800,%ebx
801051e3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051ea:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801051f0:	29 d3                	sub    %edx,%ebx
801051f2:	89 da                	mov    %ebx,%edx
801051f4:	01 ca                	add    %ecx,%edx
801051f6:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
801051fc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105202:	8b 40 04             	mov    0x4(%eax),%eax
80105205:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010520c:	83 c2 1c             	add    $0x1c,%edx
8010520f:	83 ec 08             	sub    $0x8,%esp
80105212:	50                   	push   %eax
80105213:	52                   	push   %edx
80105214:	e8 ed 15 00 00       	call   80106806 <swtch>
80105219:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
8010521c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105222:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105225:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010522b:	90                   	nop
8010522c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010522f:	c9                   	leave  
80105230:	c3                   	ret    

80105231 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105231:	55                   	push   %ebp
80105232:	89 e5                	mov    %esp,%ebp
80105234:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105237:	83 ec 0c             	sub    $0xc,%esp
8010523a:	68 80 49 11 80       	push   $0x80114980
8010523f:	e8 eb 10 00 00       	call   8010632f <acquire>
80105244:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
80105247:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010524d:	83 ec 08             	sub    $0x8,%esp
80105250:	50                   	push   %eax
80105251:	68 d4 6f 11 80       	push   $0x80116fd4
80105256:	e8 d7 0b 00 00       	call   80105e32 <remove_from_list>
8010525b:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
8010525e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105264:	83 ec 08             	sub    $0x8,%esp
80105267:	6a 04                	push   $0x4
80105269:	50                   	push   %eax
8010526a:	e8 a2 0b 00 00       	call   80105e11 <assert_state>
8010526f:	83 c4 10             	add    $0x10,%esp
  #endif
  proc->state = RUNNABLE;
80105272:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105278:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  add_to_ready(proc, RUNNABLE);
8010527f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105285:	83 ec 08             	sub    $0x8,%esp
80105288:	6a 03                	push   $0x3
8010528a:	50                   	push   %eax
8010528b:	e8 8f 0c 00 00       	call   80105f1f <add_to_ready>
80105290:	83 c4 10             	add    $0x10,%esp
  #endif
  sched();
80105293:	e8 a7 fe ff ff       	call   8010513f <sched>
  release(&ptable.lock);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	68 80 49 11 80       	push   $0x80114980
801052a0:	e8 f1 10 00 00       	call   80106396 <release>
801052a5:	83 c4 10             	add    $0x10,%esp
}
801052a8:	90                   	nop
801052a9:	c9                   	leave  
801052aa:	c3                   	ret    

801052ab <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801052ab:	55                   	push   %ebp
801052ac:	89 e5                	mov    %esp,%ebp
801052ae:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801052b1:	83 ec 0c             	sub    $0xc,%esp
801052b4:	68 80 49 11 80       	push   $0x80114980
801052b9:	e8 d8 10 00 00       	call   80106396 <release>
801052be:	83 c4 10             	add    $0x10,%esp

  if (first) {
801052c1:	a1 20 d0 10 80       	mov    0x8010d020,%eax
801052c6:	85 c0                	test   %eax,%eax
801052c8:	74 24                	je     801052ee <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801052ca:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
801052d1:	00 00 00 
    iinit(ROOTDEV);
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	6a 01                	push   $0x1
801052d9:	e8 0a c4 ff ff       	call   801016e8 <iinit>
801052de:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801052e1:	83 ec 0c             	sub    $0xc,%esp
801052e4:	6a 01                	push   $0x1
801052e6:	e8 ee e0 ff ff       	call   801033d9 <initlog>
801052eb:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801052ee:	90                   	nop
801052ef:	c9                   	leave  
801052f0:	c3                   	ret    

801052f1 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
801052f1:	55                   	push   %ebp
801052f2:	89 e5                	mov    %esp,%ebp
801052f4:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
801052f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052fd:	85 c0                	test   %eax,%eax
801052ff:	75 0d                	jne    8010530e <sleep+0x1d>
    panic("sleep");
80105301:	83 ec 0c             	sub    $0xc,%esp
80105304:	68 e7 9d 10 80       	push   $0x80109de7
80105309:	e8 58 b2 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
8010530e:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
80105315:	74 24                	je     8010533b <sleep+0x4a>
    acquire(&ptable.lock);
80105317:	83 ec 0c             	sub    $0xc,%esp
8010531a:	68 80 49 11 80       	push   $0x80114980
8010531f:	e8 0b 10 00 00       	call   8010632f <acquire>
80105324:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105327:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010532b:	74 0e                	je     8010533b <sleep+0x4a>
8010532d:	83 ec 0c             	sub    $0xc,%esp
80105330:	ff 75 0c             	pushl  0xc(%ebp)
80105333:	e8 5e 10 00 00       	call   80106396 <release>
80105338:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
8010533b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105341:	8b 55 08             	mov    0x8(%ebp),%edx
80105344:	89 50 20             	mov    %edx,0x20(%eax)
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
80105347:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010534d:	83 ec 08             	sub    $0x8,%esp
80105350:	50                   	push   %eax
80105351:	68 d4 6f 11 80       	push   $0x80116fd4
80105356:	e8 d7 0a 00 00       	call   80105e32 <remove_from_list>
8010535b:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
8010535e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105364:	83 ec 08             	sub    $0x8,%esp
80105367:	6a 04                	push   $0x4
80105369:	50                   	push   %eax
8010536a:	e8 a2 0a 00 00       	call   80105e11 <assert_state>
8010536f:	83 c4 10             	add    $0x10,%esp
  #endif
  proc->state = SLEEPING;
80105372:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105378:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  #ifdef CS333_P3P4
  add_to_list(&ptable.pLists.sleep, SLEEPING, proc);
8010537f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105385:	83 ec 04             	sub    $0x4,%esp
80105388:	50                   	push   %eax
80105389:	6a 02                	push   $0x2
8010538b:	68 d8 6f 11 80       	push   $0x80116fd8
80105390:	e8 49 0b 00 00       	call   80105ede <add_to_list>
80105395:	83 c4 10             	add    $0x10,%esp
  #endif
  sched();
80105398:	e8 a2 fd ff ff       	call   8010513f <sched>

  // Tidy up.
  proc->chan = 0;
8010539d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053a3:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
801053aa:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801053b1:	74 24                	je     801053d7 <sleep+0xe6>
    release(&ptable.lock);
801053b3:	83 ec 0c             	sub    $0xc,%esp
801053b6:	68 80 49 11 80       	push   $0x80114980
801053bb:	e8 d6 0f 00 00       	call   80106396 <release>
801053c0:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
801053c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801053c7:	74 0e                	je     801053d7 <sleep+0xe6>
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	ff 75 0c             	pushl  0xc(%ebp)
801053cf:	e8 5b 0f 00 00       	call   8010632f <acquire>
801053d4:	83 c4 10             	add    $0x10,%esp
  }
}
801053d7:	90                   	nop
801053d8:	c9                   	leave  
801053d9:	c3                   	ret    

801053da <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
801053da:	55                   	push   %ebp
801053db:	89 e5                	mov    %esp,%ebp
801053dd:	83 ec 18             	sub    $0x18,%esp
  struct proc* p = ptable.pLists.sleep;
801053e0:	a1 d8 6f 11 80       	mov    0x80116fd8,%eax
801053e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
801053e8:	eb 54                	jmp    8010543e <wakeup1+0x64>
    if (p->chan == chan) {
801053ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ed:	8b 40 20             	mov    0x20(%eax),%eax
801053f0:	3b 45 08             	cmp    0x8(%ebp),%eax
801053f3:	75 3d                	jne    80105432 <wakeup1+0x58>
      remove_from_list(&ptable.pLists.sleep, p);
801053f5:	83 ec 08             	sub    $0x8,%esp
801053f8:	ff 75 f4             	pushl  -0xc(%ebp)
801053fb:	68 d8 6f 11 80       	push   $0x80116fd8
80105400:	e8 2d 0a 00 00       	call   80105e32 <remove_from_list>
80105405:	83 c4 10             	add    $0x10,%esp
      assert_state(p, SLEEPING);
80105408:	83 ec 08             	sub    $0x8,%esp
8010540b:	6a 02                	push   $0x2
8010540d:	ff 75 f4             	pushl  -0xc(%ebp)
80105410:	e8 fc 09 00 00       	call   80105e11 <assert_state>
80105415:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
80105418:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010541b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      add_to_ready(p, RUNNABLE);
80105422:	83 ec 08             	sub    $0x8,%esp
80105425:	6a 03                	push   $0x3
80105427:	ff 75 f4             	pushl  -0xc(%ebp)
8010542a:	e8 f0 0a 00 00       	call   80105f1f <add_to_ready>
8010542f:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
80105432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105435:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010543b:	89 45 f4             	mov    %eax,-0xc(%ebp)
#else
static void
wakeup1(void *chan)
{
  struct proc* p = ptable.pLists.sleep;
  while (p) {
8010543e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105442:	75 a6                	jne    801053ea <wakeup1+0x10>
      p->state = RUNNABLE;
      add_to_ready(p, RUNNABLE);
    }
    p = p->next;
  }
}
80105444:	90                   	nop
80105445:	c9                   	leave  
80105446:	c3                   	ret    

80105447 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105447:	55                   	push   %ebp
80105448:	89 e5                	mov    %esp,%ebp
8010544a:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010544d:	83 ec 0c             	sub    $0xc,%esp
80105450:	68 80 49 11 80       	push   $0x80114980
80105455:	e8 d5 0e 00 00       	call   8010632f <acquire>
8010545a:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010545d:	83 ec 0c             	sub    $0xc,%esp
80105460:	ff 75 08             	pushl  0x8(%ebp)
80105463:	e8 72 ff ff ff       	call   801053da <wakeup1>
80105468:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010546b:	83 ec 0c             	sub    $0xc,%esp
8010546e:	68 80 49 11 80       	push   $0x80114980
80105473:	e8 1e 0f 00 00       	call   80106396 <release>
80105478:	83 c4 10             	add    $0x10,%esp
}
8010547b:	90                   	nop
8010547c:	c9                   	leave  
8010547d:	c3                   	ret    

8010547e <kill>:
}

#else
int
kill(int pid)
{
8010547e:	55                   	push   %ebp
8010547f:	89 e5                	mov    %esp,%ebp
80105481:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;

  acquire(&ptable.lock);
80105484:	83 ec 0c             	sub    $0xc,%esp
80105487:	68 80 49 11 80       	push   $0x80114980
8010548c:	e8 9e 0e 00 00       	call   8010632f <acquire>
80105491:	83 c4 10             	add    $0x10,%esp
  // Search through embryo
  p = ptable.pLists.embryo;
80105494:	a1 b8 6f 11 80       	mov    0x80116fb8,%eax
80105499:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
8010549c:	eb 3d                	jmp    801054db <kill+0x5d>
    if (p->pid == pid) {
8010549e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a1:	8b 50 10             	mov    0x10(%eax),%edx
801054a4:	8b 45 08             	mov    0x8(%ebp),%eax
801054a7:	39 c2                	cmp    %eax,%edx
801054a9:	75 24                	jne    801054cf <kill+0x51>
      p->killed = 1;
801054ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ae:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
801054b5:	83 ec 0c             	sub    $0xc,%esp
801054b8:	68 80 49 11 80       	push   $0x80114980
801054bd:	e8 d4 0e 00 00       	call   80106396 <release>
801054c2:	83 c4 10             	add    $0x10,%esp
      return 0;
801054c5:	b8 00 00 00 00       	mov    $0x0,%eax
801054ca:	e9 65 01 00 00       	jmp    80105634 <kill+0x1b6>
    }
    p = p->next;
801054cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d2:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801054d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc* p;

  acquire(&ptable.lock);
  // Search through embryo
  p = ptable.pLists.embryo;
  while (p) {
801054db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054df:	75 bd                	jne    8010549e <kill+0x20>
      return 0;
    }
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
801054e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801054e8:	eb 5b                	jmp    80105545 <kill+0xc7>
    p = ptable.pLists.ready[i];
801054ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054ed:	05 8c 09 00 00       	add    $0x98c,%eax
801054f2:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
801054f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801054fc:	eb 3d                	jmp    8010553b <kill+0xbd>
      if (p->pid == pid) {
801054fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105501:	8b 50 10             	mov    0x10(%eax),%edx
80105504:	8b 45 08             	mov    0x8(%ebp),%eax
80105507:	39 c2                	cmp    %eax,%edx
80105509:	75 24                	jne    8010552f <kill+0xb1>
        p->killed = 1;
8010550b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        release(&ptable.lock);
80105515:	83 ec 0c             	sub    $0xc,%esp
80105518:	68 80 49 11 80       	push   $0x80114980
8010551d:	e8 74 0e 00 00       	call   80106396 <release>
80105522:	83 c4 10             	add    $0x10,%esp
        return 0;
80105525:	b8 00 00 00 00       	mov    $0x0,%eax
8010552a:	e9 05 01 00 00       	jmp    80105634 <kill+0x1b6>
      }
      p = p->next;
8010552f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105532:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105538:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
    p = ptable.pLists.ready[i];
    while (p) {
8010553b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010553f:	75 bd                	jne    801054fe <kill+0x80>
      return 0;
    }
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
80105541:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105545:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80105549:	7e 9f                	jle    801054ea <kill+0x6c>
      }
      p = p->next;
    }
  }
  // Search through embryo
  p = ptable.pLists.running;
8010554b:	a1 d4 6f 11 80       	mov    0x80116fd4,%eax
80105550:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80105553:	eb 3d                	jmp    80105592 <kill+0x114>
    if (p->pid == pid) {
80105555:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105558:	8b 50 10             	mov    0x10(%eax),%edx
8010555b:	8b 45 08             	mov    0x8(%ebp),%eax
8010555e:	39 c2                	cmp    %eax,%edx
80105560:	75 24                	jne    80105586 <kill+0x108>
      p->killed = 1;
80105562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105565:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
8010556c:	83 ec 0c             	sub    $0xc,%esp
8010556f:	68 80 49 11 80       	push   $0x80114980
80105574:	e8 1d 0e 00 00       	call   80106396 <release>
80105579:	83 c4 10             	add    $0x10,%esp
      return 0;
8010557c:	b8 00 00 00 00       	mov    $0x0,%eax
80105581:	e9 ae 00 00 00       	jmp    80105634 <kill+0x1b6>
    }
    p = p->next;
80105586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105589:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010558f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      p = p->next;
    }
  }
  // Search through embryo
  p = ptable.pLists.running;
  while (p) {
80105592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105596:	75 bd                	jne    80105555 <kill+0xd7>
      return 0;
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
80105598:	a1 d8 6f 11 80       	mov    0x80116fd8,%eax
8010559d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
801055a0:	eb 77                	jmp    80105619 <kill+0x19b>
    if (p->pid == pid) {
801055a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a5:	8b 50 10             	mov    0x10(%eax),%edx
801055a8:	8b 45 08             	mov    0x8(%ebp),%eax
801055ab:	39 c2                	cmp    %eax,%edx
801055ad:	75 5e                	jne    8010560d <kill+0x18f>
      p->killed = 1;
801055af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      remove_from_list(&ptable.pLists.sleep, p);
801055b9:	83 ec 08             	sub    $0x8,%esp
801055bc:	ff 75 f4             	pushl  -0xc(%ebp)
801055bf:	68 d8 6f 11 80       	push   $0x80116fd8
801055c4:	e8 69 08 00 00       	call   80105e32 <remove_from_list>
801055c9:	83 c4 10             	add    $0x10,%esp
      assert_state(p, SLEEPING);
801055cc:	83 ec 08             	sub    $0x8,%esp
801055cf:	6a 02                	push   $0x2
801055d1:	ff 75 f4             	pushl  -0xc(%ebp)
801055d4:	e8 38 08 00 00       	call   80105e11 <assert_state>
801055d9:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
801055dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      add_to_ready(p, RUNNABLE);
801055e6:	83 ec 08             	sub    $0x8,%esp
801055e9:	6a 03                	push   $0x3
801055eb:	ff 75 f4             	pushl  -0xc(%ebp)
801055ee:	e8 2c 09 00 00       	call   80105f1f <add_to_ready>
801055f3:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
801055f6:	83 ec 0c             	sub    $0xc,%esp
801055f9:	68 80 49 11 80       	push   $0x80114980
801055fe:	e8 93 0d 00 00       	call   80106396 <release>
80105603:	83 c4 10             	add    $0x10,%esp
      return 0;
80105606:	b8 00 00 00 00       	mov    $0x0,%eax
8010560b:	eb 27                	jmp    80105634 <kill+0x1b6>
    }
    p = p->next;
8010560d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105610:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105616:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
  while (p) {
80105619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010561d:	75 83                	jne    801055a2 <kill+0x124>
      return 0;
    }
    p = p->next;
  }

  release(&ptable.lock);
8010561f:	83 ec 0c             	sub    $0xc,%esp
80105622:	68 80 49 11 80       	push   $0x80114980
80105627:	e8 6a 0d 00 00       	call   80106396 <release>
8010562c:	83 c4 10             	add    $0x10,%esp
  return -1;
8010562f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105634:	c9                   	leave  
80105635:	c3                   	ret    

80105636 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105636:	55                   	push   %ebp
80105637:	89 e5                	mov    %esp,%ebp
80105639:	53                   	push   %ebx
8010563a:	83 ec 54             	sub    $0x54,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
8010563d:	83 ec 04             	sub    $0x4,%esp
80105640:	68 17 9e 10 80       	push   $0x80109e17
80105645:	68 1b 9e 10 80       	push   $0x80109e1b
8010564a:	68 1f 9e 10 80       	push   $0x80109e1f
8010564f:	68 27 9e 10 80       	push   $0x80109e27
80105654:	68 2d 9e 10 80       	push   $0x80109e2d
80105659:	68 32 9e 10 80       	push   $0x80109e32
8010565e:	68 37 9e 10 80       	push   $0x80109e37
80105663:	68 3b 9e 10 80       	push   $0x80109e3b
80105668:	68 3f 9e 10 80       	push   $0x80109e3f
8010566d:	68 44 9e 10 80       	push   $0x80109e44
80105672:	68 48 9e 10 80       	push   $0x80109e48
80105677:	e8 4a ad ff ff       	call   801003c6 <cprintf>
8010567c:	83 c4 30             	add    $0x30,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010567f:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
80105686:	e9 31 02 00 00       	jmp    801058bc <procdump+0x286>
    if(p->state == UNUSED)
8010568b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010568e:	8b 40 0c             	mov    0xc(%eax),%eax
80105691:	85 c0                	test   %eax,%eax
80105693:	0f 84 1b 02 00 00    	je     801058b4 <procdump+0x27e>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105699:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010569c:	8b 40 0c             	mov    0xc(%eax),%eax
8010569f:	83 f8 05             	cmp    $0x5,%eax
801056a2:	77 23                	ja     801056c7 <procdump+0x91>
801056a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a7:	8b 40 0c             	mov    0xc(%eax),%eax
801056aa:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801056b1:	85 c0                	test   %eax,%eax
801056b3:	74 12                	je     801056c7 <procdump+0x91>
      state = states[p->state];
801056b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056b8:	8b 40 0c             	mov    0xc(%eax),%eax
801056bb:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801056c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801056c5:	eb 07                	jmp    801056ce <procdump+0x98>
    else
      state = "???";
801056c7:	c7 45 ec 70 9e 10 80 	movl   $0x80109e70,-0x14(%ebp)
    uint seconds = (ticks - p->start_ticks)/100;
801056ce:	8b 15 00 78 11 80    	mov    0x80117800,%edx
801056d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056d7:	8b 40 7c             	mov    0x7c(%eax),%eax
801056da:	29 c2                	sub    %eax,%edx
801056dc:	89 d0                	mov    %edx,%eax
801056de:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801056e3:	f7 e2                	mul    %edx
801056e5:	89 d0                	mov    %edx,%eax
801056e7:	c1 e8 05             	shr    $0x5,%eax
801056ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint partial_seconds = (ticks - p->start_ticks)%100;
801056ed:	8b 15 00 78 11 80    	mov    0x80117800,%edx
801056f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f6:	8b 40 7c             	mov    0x7c(%eax),%eax
801056f9:	89 d1                	mov    %edx,%ecx
801056fb:	29 c1                	sub    %eax,%ecx
801056fd:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105702:	89 c8                	mov    %ecx,%eax
80105704:	f7 e2                	mul    %edx
80105706:	89 d0                	mov    %edx,%eax
80105708:	c1 e8 05             	shr    $0x5,%eax
8010570b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010570e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105711:	6b c0 64             	imul   $0x64,%eax,%eax
80105714:	29 c1                	sub    %eax,%ecx
80105716:	89 c8                	mov    %ecx,%eax
80105718:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("%d\t %s\t %d\t %d\t", p->pid, p->name, p->uid, p->gid);
8010571b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010571e:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105724:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105727:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010572d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105730:	8d 58 6c             	lea    0x6c(%eax),%ebx
80105733:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105736:	8b 40 10             	mov    0x10(%eax),%eax
80105739:	83 ec 0c             	sub    $0xc,%esp
8010573c:	51                   	push   %ecx
8010573d:	52                   	push   %edx
8010573e:	53                   	push   %ebx
8010573f:	50                   	push   %eax
80105740:	68 74 9e 10 80       	push   $0x80109e74
80105745:	e8 7c ac ff ff       	call   801003c6 <cprintf>
8010574a:	83 c4 20             	add    $0x20,%esp
    if (p->parent)
8010574d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105750:	8b 40 14             	mov    0x14(%eax),%eax
80105753:	85 c0                	test   %eax,%eax
80105755:	74 1c                	je     80105773 <procdump+0x13d>
      cprintf(" %d\t", p->parent->pid);
80105757:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010575a:	8b 40 14             	mov    0x14(%eax),%eax
8010575d:	8b 40 10             	mov    0x10(%eax),%eax
80105760:	83 ec 08             	sub    $0x8,%esp
80105763:	50                   	push   %eax
80105764:	68 84 9e 10 80       	push   $0x80109e84
80105769:	e8 58 ac ff ff       	call   801003c6 <cprintf>
8010576e:	83 c4 10             	add    $0x10,%esp
80105771:	eb 17                	jmp    8010578a <procdump+0x154>
    else
      cprintf(" %d\t", p->pid);
80105773:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105776:	8b 40 10             	mov    0x10(%eax),%eax
80105779:	83 ec 08             	sub    $0x8,%esp
8010577c:	50                   	push   %eax
8010577d:	68 84 9e 10 80       	push   $0x80109e84
80105782:	e8 3f ac ff ff       	call   801003c6 <cprintf>
80105787:	83 c4 10             	add    $0x10,%esp
    cprintf(" %d\t %s\t %d.", p->priority, state, seconds);
8010578a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010578d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105793:	ff 75 e8             	pushl  -0x18(%ebp)
80105796:	ff 75 ec             	pushl  -0x14(%ebp)
80105799:	50                   	push   %eax
8010579a:	68 89 9e 10 80       	push   $0x80109e89
8010579f:	e8 22 ac ff ff       	call   801003c6 <cprintf>
801057a4:	83 c4 10             	add    $0x10,%esp
    if (partial_seconds < 10)
801057a7:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
801057ab:	77 10                	ja     801057bd <procdump+0x187>
	cprintf("0");
801057ad:	83 ec 0c             	sub    $0xc,%esp
801057b0:	68 96 9e 10 80       	push   $0x80109e96
801057b5:	e8 0c ac ff ff       	call   801003c6 <cprintf>
801057ba:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t", partial_seconds);
801057bd:	83 ec 08             	sub    $0x8,%esp
801057c0:	ff 75 e4             	pushl  -0x1c(%ebp)
801057c3:	68 98 9e 10 80       	push   $0x80109e98
801057c8:	e8 f9 ab ff ff       	call   801003c6 <cprintf>
801057cd:	83 c4 10             	add    $0x10,%esp
    uint cpu_seconds = p->cpu_ticks_total/100;
801057d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d3:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801057d9:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801057de:	f7 e2                	mul    %edx
801057e0:	89 d0                	mov    %edx,%eax
801057e2:	c1 e8 05             	shr    $0x5,%eax
801057e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    uint cpu_partial_seconds = p->cpu_ticks_total%100;
801057e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057eb:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
801057f1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801057f6:	89 c8                	mov    %ecx,%eax
801057f8:	f7 e2                	mul    %edx
801057fa:	89 d0                	mov    %edx,%eax
801057fc:	c1 e8 05             	shr    $0x5,%eax
801057ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105802:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105805:	6b c0 64             	imul   $0x64,%eax,%eax
80105808:	29 c1                	sub    %eax,%ecx
8010580a:	89 c8                	mov    %ecx,%eax
8010580c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (cpu_partial_seconds < 10)
8010580f:	83 7d dc 09          	cmpl   $0x9,-0x24(%ebp)
80105813:	77 18                	ja     8010582d <procdump+0x1f7>
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
80105815:	83 ec 04             	sub    $0x4,%esp
80105818:	ff 75 dc             	pushl  -0x24(%ebp)
8010581b:	ff 75 e0             	pushl  -0x20(%ebp)
8010581e:	68 9c 9e 10 80       	push   $0x80109e9c
80105823:	e8 9e ab ff ff       	call   801003c6 <cprintf>
80105828:	83 c4 10             	add    $0x10,%esp
8010582b:	eb 16                	jmp    80105843 <procdump+0x20d>
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
8010582d:	83 ec 04             	sub    $0x4,%esp
80105830:	ff 75 dc             	pushl  -0x24(%ebp)
80105833:	ff 75 e0             	pushl  -0x20(%ebp)
80105836:	68 a6 9e 10 80       	push   $0x80109ea6
8010583b:	e8 86 ab ff ff       	call   801003c6 <cprintf>
80105840:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105846:	8b 40 0c             	mov    0xc(%eax),%eax
80105849:	83 f8 02             	cmp    $0x2,%eax
8010584c:	75 54                	jne    801058a2 <procdump+0x26c>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010584e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105851:	8b 40 1c             	mov    0x1c(%eax),%eax
80105854:	8b 40 0c             	mov    0xc(%eax),%eax
80105857:	83 c0 08             	add    $0x8,%eax
8010585a:	89 c2                	mov    %eax,%edx
8010585c:	83 ec 08             	sub    $0x8,%esp
8010585f:	8d 45 b4             	lea    -0x4c(%ebp),%eax
80105862:	50                   	push   %eax
80105863:	52                   	push   %edx
80105864:	e8 7f 0b 00 00       	call   801063e8 <getcallerpcs>
80105869:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010586c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105873:	eb 1c                	jmp    80105891 <procdump+0x25b>
        cprintf(" %p", pc[i]);
80105875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105878:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
8010587c:	83 ec 08             	sub    $0x8,%esp
8010587f:	50                   	push   %eax
80105880:	68 af 9e 10 80       	push   $0x80109eaf
80105885:	e8 3c ab ff ff       	call   801003c6 <cprintf>
8010588a:	83 c4 10             	add    $0x10,%esp
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010588d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105891:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105895:	7f 0b                	jg     801058a2 <procdump+0x26c>
80105897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010589a:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
8010589e:	85 c0                	test   %eax,%eax
801058a0:	75 d3                	jne    80105875 <procdump+0x23f>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801058a2:	83 ec 0c             	sub    $0xc,%esp
801058a5:	68 b3 9e 10 80       	push   $0x80109eb3
801058aa:	e8 17 ab ff ff       	call   801003c6 <cprintf>
801058af:	83 c4 10             	add    $0x10,%esp
801058b2:	eb 01                	jmp    801058b5 <procdump+0x27f>
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801058b4:	90                   	nop
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801058b5:	81 45 f0 98 00 00 00 	addl   $0x98,-0x10(%ebp)
801058bc:	81 7d f0 b4 6f 11 80 	cmpl   $0x80116fb4,-0x10(%ebp)
801058c3:	0f 82 c2 fd ff ff    	jb     8010568b <procdump+0x55>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801058c9:	90                   	nop
801058ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058cd:	c9                   	leave  
801058ce:	c3                   	ret    

801058cf <getproc_helper>:

int
getproc_helper(int m, struct uproc* table)
{
801058cf:	55                   	push   %ebp
801058d0:	89 e5                	mov    %esp,%ebp
801058d2:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int i = 0;
801058d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
801058dc:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
801058e3:	e9 ac 01 00 00       	jmp    80105a94 <getproc_helper+0x1c5>
  {
    if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
801058e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058eb:	8b 40 0c             	mov    0xc(%eax),%eax
801058ee:	83 f8 04             	cmp    $0x4,%eax
801058f1:	74 1a                	je     8010590d <getproc_helper+0x3e>
801058f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f6:	8b 40 0c             	mov    0xc(%eax),%eax
801058f9:	83 f8 03             	cmp    $0x3,%eax
801058fc:	74 0f                	je     8010590d <getproc_helper+0x3e>
801058fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105901:	8b 40 0c             	mov    0xc(%eax),%eax
80105904:	83 f8 02             	cmp    $0x2,%eax
80105907:	0f 85 80 01 00 00    	jne    80105a8d <getproc_helper+0x1be>
    {
      table[i].pid = p->pid;
8010590d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105910:	89 d0                	mov    %edx,%eax
80105912:	01 c0                	add    %eax,%eax
80105914:	01 d0                	add    %edx,%eax
80105916:	c1 e0 05             	shl    $0x5,%eax
80105919:	89 c2                	mov    %eax,%edx
8010591b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010591e:	01 c2                	add    %eax,%edx
80105920:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105923:	8b 40 10             	mov    0x10(%eax),%eax
80105926:	89 02                	mov    %eax,(%edx)
      table[i].uid = p->uid;
80105928:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010592b:	89 d0                	mov    %edx,%eax
8010592d:	01 c0                	add    %eax,%eax
8010592f:	01 d0                	add    %edx,%eax
80105931:	c1 e0 05             	shl    $0x5,%eax
80105934:	89 c2                	mov    %eax,%edx
80105936:	8b 45 0c             	mov    0xc(%ebp),%eax
80105939:	01 c2                	add    %eax,%edx
8010593b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593e:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105944:	89 42 04             	mov    %eax,0x4(%edx)
      table[i].gid = p->gid;
80105947:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010594a:	89 d0                	mov    %edx,%eax
8010594c:	01 c0                	add    %eax,%eax
8010594e:	01 d0                	add    %edx,%eax
80105950:	c1 e0 05             	shl    $0x5,%eax
80105953:	89 c2                	mov    %eax,%edx
80105955:	8b 45 0c             	mov    0xc(%ebp),%eax
80105958:	01 c2                	add    %eax,%edx
8010595a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010595d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105963:	89 42 08             	mov    %eax,0x8(%edx)
      if (p->parent)
80105966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105969:	8b 40 14             	mov    0x14(%eax),%eax
8010596c:	85 c0                	test   %eax,%eax
8010596e:	74 21                	je     80105991 <getproc_helper+0xc2>
        table[i].ppid = p->parent->pid;
80105970:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105973:	89 d0                	mov    %edx,%eax
80105975:	01 c0                	add    %eax,%eax
80105977:	01 d0                	add    %edx,%eax
80105979:	c1 e0 05             	shl    $0x5,%eax
8010597c:	89 c2                	mov    %eax,%edx
8010597e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105981:	01 c2                	add    %eax,%edx
80105983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105986:	8b 40 14             	mov    0x14(%eax),%eax
80105989:	8b 40 10             	mov    0x10(%eax),%eax
8010598c:	89 42 0c             	mov    %eax,0xc(%edx)
8010598f:	eb 1c                	jmp    801059ad <getproc_helper+0xde>
      else
        table[i].ppid = p->pid;
80105991:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105994:	89 d0                	mov    %edx,%eax
80105996:	01 c0                	add    %eax,%eax
80105998:	01 d0                	add    %edx,%eax
8010599a:	c1 e0 05             	shl    $0x5,%eax
8010599d:	89 c2                	mov    %eax,%edx
8010599f:	8b 45 0c             	mov    0xc(%ebp),%eax
801059a2:	01 c2                	add    %eax,%edx
801059a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a7:	8b 40 10             	mov    0x10(%eax),%eax
801059aa:	89 42 0c             	mov    %eax,0xc(%edx)
      table[i].priority = p->priority;
801059ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059b0:	89 d0                	mov    %edx,%eax
801059b2:	01 c0                	add    %eax,%eax
801059b4:	01 d0                	add    %edx,%eax
801059b6:	c1 e0 05             	shl    $0x5,%eax
801059b9:	89 c2                	mov    %eax,%edx
801059bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801059be:	01 c2                	add    %eax,%edx
801059c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059c9:	89 42 10             	mov    %eax,0x10(%edx)
      table[i].elapsed_ticks = (ticks - p->start_ticks);
801059cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059cf:	89 d0                	mov    %edx,%eax
801059d1:	01 c0                	add    %eax,%eax
801059d3:	01 d0                	add    %edx,%eax
801059d5:	c1 e0 05             	shl    $0x5,%eax
801059d8:	89 c2                	mov    %eax,%edx
801059da:	8b 45 0c             	mov    0xc(%ebp),%eax
801059dd:	01 c2                	add    %eax,%edx
801059df:	8b 0d 00 78 11 80    	mov    0x80117800,%ecx
801059e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e8:	8b 40 7c             	mov    0x7c(%eax),%eax
801059eb:	29 c1                	sub    %eax,%ecx
801059ed:	89 c8                	mov    %ecx,%eax
801059ef:	89 42 14             	mov    %eax,0x14(%edx)
      table[i].CPU_total_ticks = p->cpu_ticks_total;
801059f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059f5:	89 d0                	mov    %edx,%eax
801059f7:	01 c0                	add    %eax,%eax
801059f9:	01 d0                	add    %edx,%eax
801059fb:	c1 e0 05             	shl    $0x5,%eax
801059fe:	89 c2                	mov    %eax,%edx
80105a00:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a03:	01 c2                	add    %eax,%edx
80105a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a08:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105a0e:	89 42 18             	mov    %eax,0x18(%edx)
      table[i].size = p->sz;
80105a11:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a14:	89 d0                	mov    %edx,%eax
80105a16:	01 c0                	add    %eax,%eax
80105a18:	01 d0                	add    %edx,%eax
80105a1a:	c1 e0 05             	shl    $0x5,%eax
80105a1d:	89 c2                	mov    %eax,%edx
80105a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a22:	01 c2                	add    %eax,%edx
80105a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a27:	8b 00                	mov    (%eax),%eax
80105a29:	89 42 3c             	mov    %eax,0x3c(%edx)
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
80105a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a2f:	8b 40 0c             	mov    0xc(%eax),%eax
80105a32:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
80105a39:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a3c:	89 d0                	mov    %edx,%eax
80105a3e:	01 c0                	add    %eax,%eax
80105a40:	01 d0                	add    %edx,%eax
80105a42:	c1 e0 05             	shl    $0x5,%eax
80105a45:	89 c2                	mov    %eax,%edx
80105a47:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a4a:	01 d0                	add    %edx,%eax
80105a4c:	83 c0 1c             	add    $0x1c,%eax
80105a4f:	83 ec 04             	sub    $0x4,%esp
80105a52:	6a 05                	push   $0x5
80105a54:	51                   	push   %ecx
80105a55:	50                   	push   %eax
80105a56:	e8 e2 0c 00 00       	call   8010673d <strncpy>
80105a5b:	83 c4 10             	add    $0x10,%esp
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
80105a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a61:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105a64:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a67:	89 d0                	mov    %edx,%eax
80105a69:	01 c0                	add    %eax,%eax
80105a6b:	01 d0                	add    %edx,%eax
80105a6d:	c1 e0 05             	shl    $0x5,%eax
80105a70:	89 c2                	mov    %eax,%edx
80105a72:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a75:	01 d0                	add    %edx,%eax
80105a77:	83 c0 40             	add    $0x40,%eax
80105a7a:	83 ec 04             	sub    $0x4,%esp
80105a7d:	6a 11                	push   $0x11
80105a7f:	51                   	push   %ecx
80105a80:	50                   	push   %eax
80105a81:	e8 b7 0c 00 00       	call   8010673d <strncpy>
80105a86:	83 c4 10             	add    $0x10,%esp
      i++;
80105a89:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
int
getproc_helper(int m, struct uproc* table)
{
  struct proc* p;
  int i = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
80105a8d:	81 45 f4 98 00 00 00 	addl   $0x98,-0xc(%ebp)
80105a94:	81 7d f4 b4 6f 11 80 	cmpl   $0x80116fb4,-0xc(%ebp)
80105a9b:	73 0c                	jae    80105aa9 <getproc_helper+0x1da>
80105a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa0:	3b 45 08             	cmp    0x8(%ebp),%eax
80105aa3:	0f 8c 3f fe ff ff    	jl     801058e8 <getproc_helper+0x19>
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
      i++;
    }
  }
  return i;  
80105aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105aac:	c9                   	leave  
80105aad:	c3                   	ret    

80105aae <free_length>:

// Counts the number of procs in the free list when ctrl-f is pressed
void
free_length(void)
{
80105aae:	55                   	push   %ebp
80105aaf:	89 e5                	mov    %esp,%ebp
80105ab1:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105ab4:	83 ec 0c             	sub    $0xc,%esp
80105ab7:	68 80 49 11 80       	push   $0x80114980
80105abc:	e8 6e 08 00 00       	call   8010632f <acquire>
80105ac1:	83 c4 10             	add    $0x10,%esp
  struct proc* f = ptable.pLists.free;
80105ac4:	a1 b4 6f 11 80       	mov    0x80116fb4,%eax
80105ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
80105acc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (!f) {
80105ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ad7:	75 35                	jne    80105b0e <free_length+0x60>
    cprintf("Free List Size: %d\n", count);
80105ad9:	83 ec 08             	sub    $0x8,%esp
80105adc:	ff 75 f0             	pushl  -0x10(%ebp)
80105adf:	68 b5 9e 10 80       	push   $0x80109eb5
80105ae4:	e8 dd a8 ff ff       	call   801003c6 <cprintf>
80105ae9:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105aec:	83 ec 0c             	sub    $0xc,%esp
80105aef:	68 80 49 11 80       	push   $0x80114980
80105af4:	e8 9d 08 00 00       	call   80106396 <release>
80105af9:	83 c4 10             	add    $0x10,%esp
  }
  while (f)
80105afc:	eb 10                	jmp    80105b0e <free_length+0x60>
  {
    ++count;
80105afe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    f = f->next;
80105b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b05:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
  if (!f) {
    cprintf("Free List Size: %d\n", count);
    release(&ptable.lock);
  }
  while (f)
80105b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b12:	75 ea                	jne    80105afe <free_length+0x50>
  {
    ++count;
    f = f->next;
  }
  cprintf("Free List Size: %d\n", count);
80105b14:	83 ec 08             	sub    $0x8,%esp
80105b17:	ff 75 f0             	pushl  -0x10(%ebp)
80105b1a:	68 b5 9e 10 80       	push   $0x80109eb5
80105b1f:	e8 a2 a8 ff ff       	call   801003c6 <cprintf>
80105b24:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105b27:	83 ec 0c             	sub    $0xc,%esp
80105b2a:	68 80 49 11 80       	push   $0x80114980
80105b2f:	e8 62 08 00 00       	call   80106396 <release>
80105b34:	83 c4 10             	add    $0x10,%esp
}
80105b37:	90                   	nop
80105b38:	c9                   	leave  
80105b39:	c3                   	ret    

80105b3a <display_ready>:

// Displays the PIDs of all processes in the ready list
void
display_ready(void)
{
80105b3a:	55                   	push   %ebp
80105b3b:	89 e5                	mov    %esp,%ebp
80105b3d:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	68 80 49 11 80       	push   $0x80114980
80105b48:	e8 e2 07 00 00       	call   8010632f <acquire>
80105b4d:	83 c4 10             	add    $0x10,%esp
    else
      cprintf("%d -> ", r->pid);
    r = r->next;
  }
  #else
  cprintf("Ready List Processes:\n");
80105b50:	83 ec 0c             	sub    $0xc,%esp
80105b53:	68 c9 9e 10 80       	push   $0x80109ec9
80105b58:	e8 69 a8 ff ff       	call   801003c6 <cprintf>
80105b5d:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX+1; i++) {
80105b60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105b67:	e9 90 00 00 00       	jmp    80105bfc <display_ready+0xc2>
    cprintf("List %d: ", i);
80105b6c:	83 ec 08             	sub    $0x8,%esp
80105b6f:	ff 75 f4             	pushl  -0xc(%ebp)
80105b72:	68 e0 9e 10 80       	push   $0x80109ee0
80105b77:	e8 4a a8 ff ff       	call   801003c6 <cprintf>
80105b7c:	83 c4 10             	add    $0x10,%esp
    struct proc* r = ptable.pLists.ready[i];
80105b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b82:	05 8c 09 00 00       	add    $0x98c,%eax
80105b87:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80105b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!r) {
80105b91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b95:	75 5b                	jne    80105bf2 <display_ready+0xb8>
      cprintf("\n");
80105b97:	83 ec 0c             	sub    $0xc,%esp
80105b9a:	68 b3 9e 10 80       	push   $0x80109eb3
80105b9f:	e8 22 a8 ff ff       	call   801003c6 <cprintf>
80105ba4:	83 c4 10             	add    $0x10,%esp
      continue;
80105ba7:	eb 4f                	jmp    80105bf8 <display_ready+0xbe>
    }
    while (r) {
      if (!r->next)
80105ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bac:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105bb2:	85 c0                	test   %eax,%eax
80105bb4:	75 19                	jne    80105bcf <display_ready+0x95>
        cprintf("%d\n", r->pid);
80105bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb9:	8b 40 10             	mov    0x10(%eax),%eax
80105bbc:	83 ec 08             	sub    $0x8,%esp
80105bbf:	50                   	push   %eax
80105bc0:	68 ea 9e 10 80       	push   $0x80109eea
80105bc5:	e8 fc a7 ff ff       	call   801003c6 <cprintf>
80105bca:	83 c4 10             	add    $0x10,%esp
80105bcd:	eb 17                	jmp    80105be6 <display_ready+0xac>
      else
        cprintf("%d -> ", r->pid);
80105bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd2:	8b 40 10             	mov    0x10(%eax),%eax
80105bd5:	83 ec 08             	sub    $0x8,%esp
80105bd8:	50                   	push   %eax
80105bd9:	68 ee 9e 10 80       	push   $0x80109eee
80105bde:	e8 e3 a7 ff ff       	call   801003c6 <cprintf>
80105be3:	83 c4 10             	add    $0x10,%esp
      r = r->next;
80105be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be9:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct proc* r = ptable.pLists.ready[i];
    if (!r) {
      cprintf("\n");
      continue;
    }
    while (r) {
80105bf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bf6:	75 b1                	jne    80105ba9 <display_ready+0x6f>
      cprintf("%d -> ", r->pid);
    r = r->next;
  }
  #else
  cprintf("Ready List Processes:\n");
  for (int i = 0; i < MAX+1; i++) {
80105bf8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105bfc:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
80105c00:	0f 8e 66 ff ff ff    	jle    80105b6c <display_ready+0x32>
        cprintf("%d -> ", r->pid);
      r = r->next;
    }
  }
  #endif
  release(&ptable.lock);
80105c06:	83 ec 0c             	sub    $0xc,%esp
80105c09:	68 80 49 11 80       	push   $0x80114980
80105c0e:	e8 83 07 00 00       	call   80106396 <release>
80105c13:	83 c4 10             	add    $0x10,%esp
  return;
80105c16:	90                   	nop
}
80105c17:	c9                   	leave  
80105c18:	c3                   	ret    

80105c19 <display_sleep>:

// Displays the PIDs of all processes in the sleep list
void
display_sleep(void)
{
80105c19:	55                   	push   %ebp
80105c1a:	89 e5                	mov    %esp,%ebp
80105c1c:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105c1f:	83 ec 0c             	sub    $0xc,%esp
80105c22:	68 80 49 11 80       	push   $0x80114980
80105c27:	e8 03 07 00 00       	call   8010632f <acquire>
80105c2c:	83 c4 10             	add    $0x10,%esp
  struct proc* s = ptable.pLists.sleep;
80105c2f:	a1 d8 6f 11 80       	mov    0x80116fd8,%eax
80105c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!s) {
80105c37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c3b:	75 22                	jne    80105c5f <display_sleep+0x46>
    cprintf("No processes currently in sleep.\n");
80105c3d:	83 ec 0c             	sub    $0xc,%esp
80105c40:	68 f8 9e 10 80       	push   $0x80109ef8
80105c45:	e8 7c a7 ff ff       	call   801003c6 <cprintf>
80105c4a:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105c4d:	83 ec 0c             	sub    $0xc,%esp
80105c50:	68 80 49 11 80       	push   $0x80114980
80105c55:	e8 3c 07 00 00       	call   80106396 <release>
80105c5a:	83 c4 10             	add    $0x10,%esp
    return;
80105c5d:	eb 72                	jmp    80105cd1 <display_sleep+0xb8>
  }
  cprintf("Sleep List Processes:\n");
80105c5f:	83 ec 0c             	sub    $0xc,%esp
80105c62:	68 1a 9f 10 80       	push   $0x80109f1a
80105c67:	e8 5a a7 ff ff       	call   801003c6 <cprintf>
80105c6c:	83 c4 10             	add    $0x10,%esp
  while (s) {
80105c6f:	eb 49                	jmp    80105cba <display_sleep+0xa1>
    if (!s->next)
80105c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c74:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c7a:	85 c0                	test   %eax,%eax
80105c7c:	75 19                	jne    80105c97 <display_sleep+0x7e>
      cprintf("%d\n", s->pid);
80105c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c81:	8b 40 10             	mov    0x10(%eax),%eax
80105c84:	83 ec 08             	sub    $0x8,%esp
80105c87:	50                   	push   %eax
80105c88:	68 ea 9e 10 80       	push   $0x80109eea
80105c8d:	e8 34 a7 ff ff       	call   801003c6 <cprintf>
80105c92:	83 c4 10             	add    $0x10,%esp
80105c95:	eb 17                	jmp    80105cae <display_sleep+0x95>
    else
      cprintf("%d -> ", s->pid);
80105c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9a:	8b 40 10             	mov    0x10(%eax),%eax
80105c9d:	83 ec 08             	sub    $0x8,%esp
80105ca0:	50                   	push   %eax
80105ca1:	68 ee 9e 10 80       	push   $0x80109eee
80105ca6:	e8 1b a7 ff ff       	call   801003c6 <cprintf>
80105cab:	83 c4 10             	add    $0x10,%esp
    s = s->next;
80105cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb1:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in sleep.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Sleep List Processes:\n");
  while (s) {
80105cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cbe:	75 b1                	jne    80105c71 <display_sleep+0x58>
      cprintf("%d\n", s->pid);
    else
      cprintf("%d -> ", s->pid);
    s = s->next;
  }
  release(&ptable.lock);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	68 80 49 11 80       	push   $0x80114980
80105cc8:	e8 c9 06 00 00       	call   80106396 <release>
80105ccd:	83 c4 10             	add    $0x10,%esp
  return;
80105cd0:	90                   	nop
}
80105cd1:	c9                   	leave  
80105cd2:	c3                   	ret    

80105cd3 <display_zombie>:

// Displays the PID/PPID of processes in the zombie list
void display_zombie(void)
{
80105cd3:	55                   	push   %ebp
80105cd4:	89 e5                	mov    %esp,%ebp
80105cd6:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105cd9:	83 ec 0c             	sub    $0xc,%esp
80105cdc:	68 80 49 11 80       	push   $0x80114980
80105ce1:	e8 49 06 00 00       	call   8010632f <acquire>
80105ce6:	83 c4 10             	add    $0x10,%esp
  struct proc* z = ptable.pLists.zombie;
80105ce9:	a1 dc 6f 11 80       	mov    0x80116fdc,%eax
80105cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!z) {
80105cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cf5:	75 25                	jne    80105d1c <display_zombie+0x49>
    cprintf("No processes currently in zombie.\n");
80105cf7:	83 ec 0c             	sub    $0xc,%esp
80105cfa:	68 34 9f 10 80       	push   $0x80109f34
80105cff:	e8 c2 a6 ff ff       	call   801003c6 <cprintf>
80105d04:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105d07:	83 ec 0c             	sub    $0xc,%esp
80105d0a:	68 80 49 11 80       	push   $0x80114980
80105d0f:	e8 82 06 00 00       	call   80106396 <release>
80105d14:	83 c4 10             	add    $0x10,%esp
    return;
80105d17:	e9 f3 00 00 00       	jmp    80105e0f <display_zombie+0x13c>
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
80105d1c:	83 ec 0c             	sub    $0xc,%esp
80105d1f:	68 58 9f 10 80       	push   $0x80109f58
80105d24:	e8 9d a6 ff ff       	call   801003c6 <cprintf>
80105d29:	83 c4 10             	add    $0x10,%esp
  while (z) {
80105d2c:	e9 c3 00 00 00       	jmp    80105df4 <display_zombie+0x121>
    if (!z->next) {
80105d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d34:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105d3a:	85 c0                	test   %eax,%eax
80105d3c:	75 56                	jne    80105d94 <display_zombie+0xc1>
      cprintf("(%d", z->pid);
80105d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d41:	8b 40 10             	mov    0x10(%eax),%eax
80105d44:	83 ec 08             	sub    $0x8,%esp
80105d47:	50                   	push   %eax
80105d48:	68 77 9f 10 80       	push   $0x80109f77
80105d4d:	e8 74 a6 ff ff       	call   801003c6 <cprintf>
80105d52:	83 c4 10             	add    $0x10,%esp
      if (z->parent)
80105d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d58:	8b 40 14             	mov    0x14(%eax),%eax
80105d5b:	85 c0                	test   %eax,%eax
80105d5d:	74 1c                	je     80105d7b <display_zombie+0xa8>
        cprintf(", %d)\n", z->parent->pid);
80105d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d62:	8b 40 14             	mov    0x14(%eax),%eax
80105d65:	8b 40 10             	mov    0x10(%eax),%eax
80105d68:	83 ec 08             	sub    $0x8,%esp
80105d6b:	50                   	push   %eax
80105d6c:	68 7b 9f 10 80       	push   $0x80109f7b
80105d71:	e8 50 a6 ff ff       	call   801003c6 <cprintf>
80105d76:	83 c4 10             	add    $0x10,%esp
80105d79:	eb 6d                	jmp    80105de8 <display_zombie+0x115>
      else
        cprintf(", %d)\n", z->pid);
80105d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d7e:	8b 40 10             	mov    0x10(%eax),%eax
80105d81:	83 ec 08             	sub    $0x8,%esp
80105d84:	50                   	push   %eax
80105d85:	68 7b 9f 10 80       	push   $0x80109f7b
80105d8a:	e8 37 a6 ff ff       	call   801003c6 <cprintf>
80105d8f:	83 c4 10             	add    $0x10,%esp
80105d92:	eb 54                	jmp    80105de8 <display_zombie+0x115>
    }
    else {
      cprintf("(%d", z->pid);
80105d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d97:	8b 40 10             	mov    0x10(%eax),%eax
80105d9a:	83 ec 08             	sub    $0x8,%esp
80105d9d:	50                   	push   %eax
80105d9e:	68 77 9f 10 80       	push   $0x80109f77
80105da3:	e8 1e a6 ff ff       	call   801003c6 <cprintf>
80105da8:	83 c4 10             	add    $0x10,%esp
      if (z->parent)
80105dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dae:	8b 40 14             	mov    0x14(%eax),%eax
80105db1:	85 c0                	test   %eax,%eax
80105db3:	74 1c                	je     80105dd1 <display_zombie+0xfe>
        cprintf(", %d) -> ", z->parent->pid);
80105db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db8:	8b 40 14             	mov    0x14(%eax),%eax
80105dbb:	8b 40 10             	mov    0x10(%eax),%eax
80105dbe:	83 ec 08             	sub    $0x8,%esp
80105dc1:	50                   	push   %eax
80105dc2:	68 82 9f 10 80       	push   $0x80109f82
80105dc7:	e8 fa a5 ff ff       	call   801003c6 <cprintf>
80105dcc:	83 c4 10             	add    $0x10,%esp
80105dcf:	eb 17                	jmp    80105de8 <display_zombie+0x115>
      else
        cprintf(", %d) -> ", z->pid);
80105dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd4:	8b 40 10             	mov    0x10(%eax),%eax
80105dd7:	83 ec 08             	sub    $0x8,%esp
80105dda:	50                   	push   %eax
80105ddb:	68 82 9f 10 80       	push   $0x80109f82
80105de0:	e8 e1 a5 ff ff       	call   801003c6 <cprintf>
80105de5:	83 c4 10             	add    $0x10,%esp
    }
    z = z->next;
80105de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105deb:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in zombie.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
  while (z) {
80105df4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105df8:	0f 85 33 ff ff ff    	jne    80105d31 <display_zombie+0x5e>
      else
        cprintf(", %d) -> ", z->pid);
    }
    z = z->next;
  }
  release(&ptable.lock);
80105dfe:	83 ec 0c             	sub    $0xc,%esp
80105e01:	68 80 49 11 80       	push   $0x80114980
80105e06:	e8 8b 05 00 00       	call   80106396 <release>
80105e0b:	83 c4 10             	add    $0x10,%esp
  return;
80105e0e:	90                   	nop
}
80105e0f:	c9                   	leave  
80105e10:	c3                   	ret    

80105e11 <assert_state>:

// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
80105e11:	55                   	push   %ebp
80105e12:	89 e5                	mov    %esp,%ebp
80105e14:	83 ec 08             	sub    $0x8,%esp
  if (p->state == state)
80105e17:	8b 45 08             	mov    0x8(%ebp),%eax
80105e1a:	8b 40 0c             	mov    0xc(%eax),%eax
80105e1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105e20:	74 0d                	je     80105e2f <assert_state+0x1e>
    return;
  panic("ERROR: States do not match.");
80105e22:	83 ec 0c             	sub    $0xc,%esp
80105e25:	68 8c 9f 10 80       	push   $0x80109f8c
80105e2a:	e8 37 a7 ff ff       	call   80100566 <panic>
// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
  if (p->state == state)
    return;
80105e2f:	90                   	nop
  panic("ERROR: States do not match.");
}
80105e30:	c9                   	leave  
80105e31:	c3                   	ret    

80105e32 <remove_from_list>:

// Implementation of remove_from_list
static int
remove_from_list(struct proc** sList, struct proc* p)
{
80105e32:	55                   	push   %ebp
80105e33:	89 e5                	mov    %esp,%ebp
80105e35:	83 ec 10             	sub    $0x10,%esp
  if (!p)
80105e38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105e3c:	75 0a                	jne    80105e48 <remove_from_list+0x16>
    return -1;
80105e3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e43:	e9 94 00 00 00       	jmp    80105edc <remove_from_list+0xaa>
  if (!sList)
80105e48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105e4c:	75 0a                	jne    80105e58 <remove_from_list+0x26>
    return -1;
80105e4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e53:	e9 84 00 00 00       	jmp    80105edc <remove_from_list+0xaa>
  struct proc* curr = *sList;
80105e58:	8b 45 08             	mov    0x8(%ebp),%eax
80105e5b:	8b 00                	mov    (%eax),%eax
80105e5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc* prev;
  if (p == curr) {
80105e60:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e63:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105e66:	75 62                	jne    80105eca <remove_from_list+0x98>
    *sList = p->next;
80105e68:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e6b:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105e71:	8b 45 08             	mov    0x8(%ebp),%eax
80105e74:	89 10                	mov    %edx,(%eax)
    p->next = 0;
80105e76:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e79:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80105e80:	00 00 00 
    return 1;
80105e83:	b8 01 00 00 00       	mov    $0x1,%eax
80105e88:	eb 52                	jmp    80105edc <remove_from_list+0xaa>
  }
  while (curr->next) {
    prev = curr;
80105e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    curr = curr->next;
80105e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e93:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105e99:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (p == curr) {
80105e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e9f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105ea2:	75 26                	jne    80105eca <remove_from_list+0x98>
      prev->next = p->next;
80105ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ea7:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105eb0:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      p->next = 0;
80105eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80105eb9:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80105ec0:	00 00 00 
      return 1;
80105ec3:	b8 01 00 00 00       	mov    $0x1,%eax
80105ec8:	eb 12                	jmp    80105edc <remove_from_list+0xaa>
  if (p == curr) {
    *sList = p->next;
    p->next = 0;
    return 1;
  }
  while (curr->next) {
80105eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ecd:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105ed3:	85 c0                	test   %eax,%eax
80105ed5:	75 b3                	jne    80105e8a <remove_from_list+0x58>
      prev->next = p->next;
      p->next = 0;
      return 1;
    }
  }
  return -1;
80105ed7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105edc:	c9                   	leave  
80105edd:	c3                   	ret    

80105ede <add_to_list>:

// Implementation of add_to_list
static int
add_to_list(struct proc** sList, enum procstate state, struct proc* p)
{
80105ede:	55                   	push   %ebp
80105edf:	89 e5                	mov    %esp,%ebp
80105ee1:	83 ec 08             	sub    $0x8,%esp
  if (!p)
80105ee4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105ee8:	75 07                	jne    80105ef1 <add_to_list+0x13>
    return -1;
80105eea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eef:	eb 2c                	jmp    80105f1d <add_to_list+0x3f>
  assert_state(p, state);
80105ef1:	83 ec 08             	sub    $0x8,%esp
80105ef4:	ff 75 0c             	pushl  0xc(%ebp)
80105ef7:	ff 75 10             	pushl  0x10(%ebp)
80105efa:	e8 12 ff ff ff       	call   80105e11 <assert_state>
80105eff:	83 c4 10             	add    $0x10,%esp
  p->next = *sList;
80105f02:	8b 45 08             	mov    0x8(%ebp),%eax
80105f05:	8b 10                	mov    (%eax),%edx
80105f07:	8b 45 10             	mov    0x10(%ebp),%eax
80105f0a:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  *sList = p;
80105f10:	8b 45 08             	mov    0x8(%ebp),%eax
80105f13:	8b 55 10             	mov    0x10(%ebp),%edx
80105f16:	89 10                	mov    %edx,(%eax)
  return 0;
80105f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f1d:	c9                   	leave  
80105f1e:	c3                   	ret    

80105f1f <add_to_ready>:

// Implementation of add_to_ready
static int
add_to_ready(struct proc* p, enum procstate state)
{
80105f1f:	55                   	push   %ebp
80105f20:	89 e5                	mov    %esp,%ebp
80105f22:	83 ec 18             	sub    $0x18,%esp
  if (!p)
80105f25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105f29:	75 0a                	jne    80105f35 <add_to_ready+0x16>
    return -1;
80105f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f30:	e9 b9 00 00 00       	jmp    80105fee <add_to_ready+0xcf>
  assert_state(p, state);
80105f35:	83 ec 08             	sub    $0x8,%esp
80105f38:	ff 75 0c             	pushl  0xc(%ebp)
80105f3b:	ff 75 08             	pushl  0x8(%ebp)
80105f3e:	e8 ce fe ff ff       	call   80105e11 <assert_state>
80105f43:	83 c4 10             	add    $0x10,%esp
    t = t->next;
  t->next = p;
  p->next = 0;
  return 0;
  #else                                                   // NEW ADD_TO_READY
  if (!ptable.pLists.ready[p->priority]) {
80105f46:	8b 45 08             	mov    0x8(%ebp),%eax
80105f49:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f4f:	05 8c 09 00 00       	add    $0x98c,%eax
80105f54:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80105f5b:	85 c0                	test   %eax,%eax
80105f5d:	75 3e                	jne    80105f9d <add_to_ready+0x7e>
    p->next = ptable.pLists.ready[p->priority];
80105f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80105f62:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f68:	05 8c 09 00 00       	add    $0x98c,%eax
80105f6d:	8b 14 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%edx
80105f74:	8b 45 08             	mov    0x8(%ebp),%eax
80105f77:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    ptable.pLists.ready[p->priority] = p;
80105f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80105f80:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f86:	8d 90 8c 09 00 00    	lea    0x98c(%eax),%edx
80105f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80105f8f:	89 04 95 8c 49 11 80 	mov    %eax,-0x7feeb674(,%edx,4)
    return 1;
80105f96:	b8 01 00 00 00       	mov    $0x1,%eax
80105f9b:	eb 51                	jmp    80105fee <add_to_ready+0xcf>
  }
  struct proc* t = ptable.pLists.ready[p->priority];
80105f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80105fa0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105fa6:	05 8c 09 00 00       	add    $0x98c,%eax
80105fab:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80105fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (t->next)
80105fb5:	eb 0c                	jmp    80105fc3 <add_to_ready+0xa4>
    t = t->next;
80105fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fba:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p->next = ptable.pLists.ready[p->priority];
    ptable.pLists.ready[p->priority] = p;
    return 1;
  }
  struct proc* t = ptable.pLists.ready[p->priority];
  while (t->next)
80105fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc6:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105fcc:	85 c0                	test   %eax,%eax
80105fce:	75 e7                	jne    80105fb7 <add_to_ready+0x98>
    t = t->next;
  t->next = p;
80105fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd3:	8b 55 08             	mov    0x8(%ebp),%edx
80105fd6:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  p->next = 0;
80105fdc:	8b 45 08             	mov    0x8(%ebp),%eax
80105fdf:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80105fe6:	00 00 00 
  return 0;
80105fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  #endif
}
80105fee:	c9                   	leave  
80105fef:	c3                   	ret    

80105ff0 <exit_helper>:

// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = *sList;
80105ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80105ff9:	8b 00                	mov    (%eax),%eax
80105ffb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
80105ffe:	eb 28                	jmp    80106028 <exit_helper+0x38>
    if (p->parent == proc)
80106000:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106003:	8b 50 14             	mov    0x14(%eax),%edx
80106006:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010600c:	39 c2                	cmp    %eax,%edx
8010600e:	75 0c                	jne    8010601c <exit_helper+0x2c>
      p->parent = initproc;
80106010:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80106016:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106019:	89 50 14             	mov    %edx,0x14(%eax)
    p = p->next;
8010601c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010601f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106025:	89 45 fc             	mov    %eax,-0x4(%ebp)
// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
  struct proc* p = *sList;
  while (p) {
80106028:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010602c:	75 d2                	jne    80106000 <exit_helper+0x10>
    if (p->parent == proc)
      p->parent = initproc;
    p = p->next;
  }
}
8010602e:	90                   	nop
8010602f:	c9                   	leave  
80106030:	c3                   	ret    

80106031 <wait_helper>:

// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
80106031:	55                   	push   %ebp
80106032:	89 e5                	mov    %esp,%ebp
80106034:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = *sList;
80106037:	8b 45 08             	mov    0x8(%ebp),%eax
8010603a:	8b 00                	mov    (%eax),%eax
8010603c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
8010603f:	eb 25                	jmp    80106066 <wait_helper+0x35>
    if (p->parent == proc)
80106041:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106044:	8b 50 14             	mov    0x14(%eax),%edx
80106047:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010604d:	39 c2                	cmp    %eax,%edx
8010604f:	75 09                	jne    8010605a <wait_helper+0x29>
      *hk = 1;
80106051:	8b 45 0c             	mov    0xc(%ebp),%eax
80106054:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    p = p->next;
8010605a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010605d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106063:	89 45 fc             	mov    %eax,-0x4(%ebp)
// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
  struct proc* p = *sList;
  while (p) {
80106066:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010606a:	75 d5                	jne    80106041 <wait_helper+0x10>
    if (p->parent == proc)
      *hk = 1;
    p = p->next;
  }
}
8010606c:	90                   	nop
8010606d:	c9                   	leave  
8010606e:	c3                   	ret    

8010606f <set_priority>:

#ifdef P4
// Implementation of helper for set priority system call
int
set_priority(int pid, int priority)
{
8010606f:	55                   	push   %ebp
80106070:	89 e5                	mov    %esp,%ebp
80106072:	83 ec 18             	sub    $0x18,%esp
  if (pid < 0)
80106075:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106079:	79 0a                	jns    80106085 <set_priority+0x16>
    return -1;
8010607b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106080:	e9 fd 00 00 00       	jmp    80106182 <set_priority+0x113>
  if (priority < 0 || priority > MAX)
80106085:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106089:	78 06                	js     80106091 <set_priority+0x22>
8010608b:	83 7d 0c 05          	cmpl   $0x5,0xc(%ebp)
8010608f:	7e 0a                	jle    8010609b <set_priority+0x2c>
    return -1;
80106091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106096:	e9 e7 00 00 00       	jmp    80106182 <set_priority+0x113>

  int hold = holding(&ptable.lock);
8010609b:	83 ec 0c             	sub    $0xc,%esp
8010609e:	68 80 49 11 80       	push   $0x80114980
801060a3:	e8 ba 03 00 00       	call   80106462 <holding>
801060a8:	83 c4 10             	add    $0x10,%esp
801060ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!hold) acquire(&ptable.lock);
801060ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060b2:	75 10                	jne    801060c4 <set_priority+0x55>
801060b4:	83 ec 0c             	sub    $0xc,%esp
801060b7:	68 80 49 11 80       	push   $0x80114980
801060bc:	e8 6e 02 00 00       	call   8010632f <acquire>
801060c1:	83 c4 10             	add    $0x10,%esp
  if (search_and_set(&ptable.pLists.running, pid, priority) == 0) {
801060c4:	83 ec 04             	sub    $0x4,%esp
801060c7:	ff 75 0c             	pushl  0xc(%ebp)
801060ca:	ff 75 08             	pushl  0x8(%ebp)
801060cd:	68 d4 6f 11 80       	push   $0x80116fd4
801060d2:	e8 ad 00 00 00       	call   80106184 <search_and_set>
801060d7:	83 c4 10             	add    $0x10,%esp
801060da:	85 c0                	test   %eax,%eax
801060dc:	75 20                	jne    801060fe <set_priority+0x8f>
    if (!hold) release(&ptable.lock);
801060de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060e2:	75 10                	jne    801060f4 <set_priority+0x85>
801060e4:	83 ec 0c             	sub    $0xc,%esp
801060e7:	68 80 49 11 80       	push   $0x80114980
801060ec:	e8 a5 02 00 00       	call   80106396 <release>
801060f1:	83 c4 10             	add    $0x10,%esp
    return 0;
801060f4:	b8 00 00 00 00       	mov    $0x0,%eax
801060f9:	e9 84 00 00 00       	jmp    80106182 <set_priority+0x113>
  }
  if (search_and_set(&ptable.pLists.sleep, pid, priority) == 0) {
801060fe:	83 ec 04             	sub    $0x4,%esp
80106101:	ff 75 0c             	pushl  0xc(%ebp)
80106104:	ff 75 08             	pushl  0x8(%ebp)
80106107:	68 d8 6f 11 80       	push   $0x80116fd8
8010610c:	e8 73 00 00 00       	call   80106184 <search_and_set>
80106111:	83 c4 10             	add    $0x10,%esp
80106114:	85 c0                	test   %eax,%eax
80106116:	75 1d                	jne    80106135 <set_priority+0xc6>
    if (!hold) release(&ptable.lock);
80106118:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010611c:	75 10                	jne    8010612e <set_priority+0xbf>
8010611e:	83 ec 0c             	sub    $0xc,%esp
80106121:	68 80 49 11 80       	push   $0x80114980
80106126:	e8 6b 02 00 00       	call   80106396 <release>
8010612b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010612e:	b8 00 00 00 00       	mov    $0x0,%eax
80106133:	eb 4d                	jmp    80106182 <set_priority+0x113>
  }
  if (search_and_set_ready(pid, priority) == 0) {
80106135:	83 ec 08             	sub    $0x8,%esp
80106138:	ff 75 0c             	pushl  0xc(%ebp)
8010613b:	ff 75 08             	pushl  0x8(%ebp)
8010613e:	e8 ae 00 00 00       	call   801061f1 <search_and_set_ready>
80106143:	83 c4 10             	add    $0x10,%esp
80106146:	85 c0                	test   %eax,%eax
80106148:	75 1d                	jne    80106167 <set_priority+0xf8>
    if (!hold) release(&ptable.lock);
8010614a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010614e:	75 10                	jne    80106160 <set_priority+0xf1>
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	68 80 49 11 80       	push   $0x80114980
80106158:	e8 39 02 00 00       	call   80106396 <release>
8010615d:	83 c4 10             	add    $0x10,%esp
    return 0;
80106160:	b8 00 00 00 00       	mov    $0x0,%eax
80106165:	eb 1b                	jmp    80106182 <set_priority+0x113>
  }
  if (!hold) release(&ptable.lock);
80106167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010616b:	75 10                	jne    8010617d <set_priority+0x10e>
8010616d:	83 ec 0c             	sub    $0xc,%esp
80106170:	68 80 49 11 80       	push   $0x80114980
80106175:	e8 1c 02 00 00       	call   80106396 <release>
8010617a:	83 c4 10             	add    $0x10,%esp
  return -1; // Failed to find process with PID matching arg pid
8010617d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106182:	c9                   	leave  
80106183:	c3                   	ret    

80106184 <search_and_set>:
// Searches a list for a proc with PID pid and sets its priority
// to the value passed in via prio argument
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int 
search_and_set(struct proc** sList, int pid, int prio)
{
80106184:	55                   	push   %ebp
80106185:	89 e5                	mov    %esp,%ebp
80106187:	83 ec 10             	sub    $0x10,%esp
  if (!sList)
8010618a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010618e:	75 07                	jne    80106197 <search_and_set+0x13>
    return -1; // Null list
80106190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106195:	eb 58                	jmp    801061ef <search_and_set+0x6b>
  struct proc* p = *sList;
80106197:	8b 45 08             	mov    0x8(%ebp),%eax
8010619a:	8b 00                	mov    (%eax),%eax
8010619c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
8010619f:	eb 43                	jmp    801061e4 <search_and_set+0x60>
    if (p->pid == pid) {
801061a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061a4:	8b 50 10             	mov    0x10(%eax),%edx
801061a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801061aa:	39 c2                	cmp    %eax,%edx
801061ac:	75 2a                	jne    801061d8 <search_and_set+0x54>
      if (p->priority == prio)
801061ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061b1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801061b7:	8b 45 10             	mov    0x10(%ebp),%eax
801061ba:	39 c2                	cmp    %eax,%edx
801061bc:	75 07                	jne    801061c5 <search_and_set+0x41>
        return 1; // No change necessary 
801061be:	b8 01 00 00 00       	mov    $0x1,%eax
801061c3:	eb 2a                	jmp    801061ef <search_and_set+0x6b>
      else {
        p->priority = prio;
801061c5:	8b 55 10             	mov    0x10(%ebp),%edx
801061c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061cb:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        return 0; // Success!
801061d1:	b8 00 00 00 00       	mov    $0x0,%eax
801061d6:	eb 17                	jmp    801061ef <search_and_set+0x6b>
      }
    }
    p = p->next;
801061d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061db:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801061e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
search_and_set(struct proc** sList, int pid, int prio)
{
  if (!sList)
    return -1; // Null list
  struct proc* p = *sList;
  while (p) {
801061e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801061e8:	75 b7                	jne    801061a1 <search_and_set+0x1d>
        return 0; // Success!
      }
    }
    p = p->next;
  }
  return -2; // Not found
801061ea:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
801061ef:	c9                   	leave  
801061f0:	c3                   	ret    

801061f1 <search_and_set_ready>:
// Specifically handles the ready list since the process also needs
// to be moved to a different ready queue.
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int
search_and_set_ready(int pid, int prio)
{
801061f1:	55                   	push   %ebp
801061f2:	89 e5                	mov    %esp,%ebp
801061f4:	83 ec 18             	sub    $0x18,%esp
  for (int i = 0; i < MAX+1; i++) {
801061f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801061fe:	e9 c1 00 00 00       	jmp    801062c4 <search_and_set_ready+0xd3>
    if (!ptable.pLists.ready[i])
80106203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106206:	05 8c 09 00 00       	add    $0x98c,%eax
8010620b:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80106212:	85 c0                	test   %eax,%eax
80106214:	0f 84 a5 00 00 00    	je     801062bf <search_and_set_ready+0xce>
      continue;
    struct proc* p = ptable.pLists.ready[i];
8010621a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010621d:	05 8c 09 00 00       	add    $0x98c,%eax
80106222:	8b 04 85 8c 49 11 80 	mov    -0x7feeb674(,%eax,4),%eax
80106229:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (p) {
8010622c:	e9 82 00 00 00       	jmp    801062b3 <search_and_set_ready+0xc2>
      if (p->pid == pid) {
80106231:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106234:	8b 50 10             	mov    0x10(%eax),%edx
80106237:	8b 45 08             	mov    0x8(%ebp),%eax
8010623a:	39 c2                	cmp    %eax,%edx
8010623c:	75 69                	jne    801062a7 <search_and_set_ready+0xb6>
        if (p->priority == prio)
8010623e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106241:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80106247:	8b 45 0c             	mov    0xc(%ebp),%eax
8010624a:	39 c2                	cmp    %eax,%edx
8010624c:	75 07                	jne    80106255 <search_and_set_ready+0x64>
          return -1; // No changes need to be made since prio already matches
8010624e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106253:	eb 7e                	jmp    801062d3 <search_and_set_ready+0xe2>
        else {
          p->priority = prio;
80106255:	8b 55 0c             	mov    0xc(%ebp),%edx
80106258:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625b:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
          remove_from_list(&ptable.pLists.ready[i], p);
80106261:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106264:	05 8c 09 00 00       	add    $0x98c,%eax
80106269:	c1 e0 02             	shl    $0x2,%eax
8010626c:	05 80 49 11 80       	add    $0x80114980,%eax
80106271:	83 c0 0c             	add    $0xc,%eax
80106274:	ff 75 f0             	pushl  -0x10(%ebp)
80106277:	50                   	push   %eax
80106278:	e8 b5 fb ff ff       	call   80105e32 <remove_from_list>
8010627d:	83 c4 08             	add    $0x8,%esp
          assert_state(p, RUNNABLE);
80106280:	83 ec 08             	sub    $0x8,%esp
80106283:	6a 03                	push   $0x3
80106285:	ff 75 f0             	pushl  -0x10(%ebp)
80106288:	e8 84 fb ff ff       	call   80105e11 <assert_state>
8010628d:	83 c4 10             	add    $0x10,%esp
          add_to_ready(p, RUNNABLE);
80106290:	83 ec 08             	sub    $0x8,%esp
80106293:	6a 03                	push   $0x3
80106295:	ff 75 f0             	pushl  -0x10(%ebp)
80106298:	e8 82 fc ff ff       	call   80105f1f <add_to_ready>
8010629d:	83 c4 10             	add    $0x10,%esp
          return 0;
801062a0:	b8 00 00 00 00       	mov    $0x0,%eax
801062a5:	eb 2c                	jmp    801062d3 <search_and_set_ready+0xe2>
        }
      }
      p = p->next;  
801062a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062aa:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801062b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
  for (int i = 0; i < MAX+1; i++) {
    if (!ptable.pLists.ready[i])
      continue;
    struct proc* p = ptable.pLists.ready[i];
    while (p) {
801062b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062b7:	0f 85 74 ff ff ff    	jne    80106231 <search_and_set_ready+0x40>
801062bd:	eb 01                	jmp    801062c0 <search_and_set_ready+0xcf>
static int
search_and_set_ready(int pid, int prio)
{
  for (int i = 0; i < MAX+1; i++) {
    if (!ptable.pLists.ready[i])
      continue;
801062bf:	90                   	nop
// to be moved to a different ready queue.
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int
search_and_set_ready(int pid, int prio)
{
  for (int i = 0; i < MAX+1; i++) {
801062c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801062c4:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
801062c8:	0f 8e 35 ff ff ff    	jle    80106203 <search_and_set_ready+0x12>
        }
      }
      p = p->next;  
    }
  }
  return -1;
801062ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062d3:	c9                   	leave  
801062d4:	c3                   	ret    

801062d5 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801062d5:	55                   	push   %ebp
801062d6:	89 e5                	mov    %esp,%ebp
801062d8:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801062db:	9c                   	pushf  
801062dc:	58                   	pop    %eax
801062dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801062e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801062e3:	c9                   	leave  
801062e4:	c3                   	ret    

801062e5 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801062e5:	55                   	push   %ebp
801062e6:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801062e8:	fa                   	cli    
}
801062e9:	90                   	nop
801062ea:	5d                   	pop    %ebp
801062eb:	c3                   	ret    

801062ec <sti>:

static inline void
sti(void)
{
801062ec:	55                   	push   %ebp
801062ed:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801062ef:	fb                   	sti    
}
801062f0:	90                   	nop
801062f1:	5d                   	pop    %ebp
801062f2:	c3                   	ret    

801062f3 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801062f3:	55                   	push   %ebp
801062f4:	89 e5                	mov    %esp,%ebp
801062f6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801062f9:	8b 55 08             	mov    0x8(%ebp),%edx
801062fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801062ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106302:	f0 87 02             	lock xchg %eax,(%edx)
80106305:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80106308:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010630b:	c9                   	leave  
8010630c:	c3                   	ret    

8010630d <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010630d:	55                   	push   %ebp
8010630e:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80106310:	8b 45 08             	mov    0x8(%ebp),%eax
80106313:	8b 55 0c             	mov    0xc(%ebp),%edx
80106316:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80106319:	8b 45 08             	mov    0x8(%ebp),%eax
8010631c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106322:	8b 45 08             	mov    0x8(%ebp),%eax
80106325:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010632c:	90                   	nop
8010632d:	5d                   	pop    %ebp
8010632e:	c3                   	ret    

8010632f <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010632f:	55                   	push   %ebp
80106330:	89 e5                	mov    %esp,%ebp
80106332:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106335:	e8 52 01 00 00       	call   8010648c <pushcli>
  if(holding(lk))
8010633a:	8b 45 08             	mov    0x8(%ebp),%eax
8010633d:	83 ec 0c             	sub    $0xc,%esp
80106340:	50                   	push   %eax
80106341:	e8 1c 01 00 00       	call   80106462 <holding>
80106346:	83 c4 10             	add    $0x10,%esp
80106349:	85 c0                	test   %eax,%eax
8010634b:	74 0d                	je     8010635a <acquire+0x2b>
    panic("acquire");
8010634d:	83 ec 0c             	sub    $0xc,%esp
80106350:	68 a8 9f 10 80       	push   $0x80109fa8
80106355:	e8 0c a2 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010635a:	90                   	nop
8010635b:	8b 45 08             	mov    0x8(%ebp),%eax
8010635e:	83 ec 08             	sub    $0x8,%esp
80106361:	6a 01                	push   $0x1
80106363:	50                   	push   %eax
80106364:	e8 8a ff ff ff       	call   801062f3 <xchg>
80106369:	83 c4 10             	add    $0x10,%esp
8010636c:	85 c0                	test   %eax,%eax
8010636e:	75 eb                	jne    8010635b <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80106370:	8b 45 08             	mov    0x8(%ebp),%eax
80106373:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010637a:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010637d:	8b 45 08             	mov    0x8(%ebp),%eax
80106380:	83 c0 0c             	add    $0xc,%eax
80106383:	83 ec 08             	sub    $0x8,%esp
80106386:	50                   	push   %eax
80106387:	8d 45 08             	lea    0x8(%ebp),%eax
8010638a:	50                   	push   %eax
8010638b:	e8 58 00 00 00       	call   801063e8 <getcallerpcs>
80106390:	83 c4 10             	add    $0x10,%esp
}
80106393:	90                   	nop
80106394:	c9                   	leave  
80106395:	c3                   	ret    

80106396 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80106396:	55                   	push   %ebp
80106397:	89 e5                	mov    %esp,%ebp
80106399:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010639c:	83 ec 0c             	sub    $0xc,%esp
8010639f:	ff 75 08             	pushl  0x8(%ebp)
801063a2:	e8 bb 00 00 00       	call   80106462 <holding>
801063a7:	83 c4 10             	add    $0x10,%esp
801063aa:	85 c0                	test   %eax,%eax
801063ac:	75 0d                	jne    801063bb <release+0x25>
    panic("release");
801063ae:	83 ec 0c             	sub    $0xc,%esp
801063b1:	68 b0 9f 10 80       	push   $0x80109fb0
801063b6:	e8 ab a1 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801063bb:	8b 45 08             	mov    0x8(%ebp),%eax
801063be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801063c5:	8b 45 08             	mov    0x8(%ebp),%eax
801063c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801063cf:	8b 45 08             	mov    0x8(%ebp),%eax
801063d2:	83 ec 08             	sub    $0x8,%esp
801063d5:	6a 00                	push   $0x0
801063d7:	50                   	push   %eax
801063d8:	e8 16 ff ff ff       	call   801062f3 <xchg>
801063dd:	83 c4 10             	add    $0x10,%esp

  popcli();
801063e0:	e8 ec 00 00 00       	call   801064d1 <popcli>
}
801063e5:	90                   	nop
801063e6:	c9                   	leave  
801063e7:	c3                   	ret    

801063e8 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801063e8:	55                   	push   %ebp
801063e9:	89 e5                	mov    %esp,%ebp
801063eb:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801063ee:	8b 45 08             	mov    0x8(%ebp),%eax
801063f1:	83 e8 08             	sub    $0x8,%eax
801063f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801063f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801063fe:	eb 38                	jmp    80106438 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106400:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106404:	74 53                	je     80106459 <getcallerpcs+0x71>
80106406:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010640d:	76 4a                	jbe    80106459 <getcallerpcs+0x71>
8010640f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80106413:	74 44                	je     80106459 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80106415:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106418:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010641f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106422:	01 c2                	add    %eax,%edx
80106424:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106427:	8b 40 04             	mov    0x4(%eax),%eax
8010642a:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010642c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010642f:	8b 00                	mov    (%eax),%eax
80106431:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106434:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106438:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010643c:	7e c2                	jle    80106400 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010643e:	eb 19                	jmp    80106459 <getcallerpcs+0x71>
    pcs[i] = 0;
80106440:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106443:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010644a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010644d:	01 d0                	add    %edx,%eax
8010644f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106455:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106459:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010645d:	7e e1                	jle    80106440 <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010645f:	90                   	nop
80106460:	c9                   	leave  
80106461:	c3                   	ret    

80106462 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106462:	55                   	push   %ebp
80106463:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106465:	8b 45 08             	mov    0x8(%ebp),%eax
80106468:	8b 00                	mov    (%eax),%eax
8010646a:	85 c0                	test   %eax,%eax
8010646c:	74 17                	je     80106485 <holding+0x23>
8010646e:	8b 45 08             	mov    0x8(%ebp),%eax
80106471:	8b 50 08             	mov    0x8(%eax),%edx
80106474:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010647a:	39 c2                	cmp    %eax,%edx
8010647c:	75 07                	jne    80106485 <holding+0x23>
8010647e:	b8 01 00 00 00       	mov    $0x1,%eax
80106483:	eb 05                	jmp    8010648a <holding+0x28>
80106485:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010648a:	5d                   	pop    %ebp
8010648b:	c3                   	ret    

8010648c <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010648c:	55                   	push   %ebp
8010648d:	89 e5                	mov    %esp,%ebp
8010648f:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80106492:	e8 3e fe ff ff       	call   801062d5 <readeflags>
80106497:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010649a:	e8 46 fe ff ff       	call   801062e5 <cli>
  if(cpu->ncli++ == 0)
8010649f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801064a6:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801064ac:	8d 48 01             	lea    0x1(%eax),%ecx
801064af:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801064b5:	85 c0                	test   %eax,%eax
801064b7:	75 15                	jne    801064ce <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801064b9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
801064c2:	81 e2 00 02 00 00    	and    $0x200,%edx
801064c8:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801064ce:	90                   	nop
801064cf:	c9                   	leave  
801064d0:	c3                   	ret    

801064d1 <popcli>:

void
popcli(void)
{
801064d1:	55                   	push   %ebp
801064d2:	89 e5                	mov    %esp,%ebp
801064d4:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801064d7:	e8 f9 fd ff ff       	call   801062d5 <readeflags>
801064dc:	25 00 02 00 00       	and    $0x200,%eax
801064e1:	85 c0                	test   %eax,%eax
801064e3:	74 0d                	je     801064f2 <popcli+0x21>
    panic("popcli - interruptible");
801064e5:	83 ec 0c             	sub    $0xc,%esp
801064e8:	68 b8 9f 10 80       	push   $0x80109fb8
801064ed:	e8 74 a0 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801064f2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064f8:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801064fe:	83 ea 01             	sub    $0x1,%edx
80106501:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106507:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010650d:	85 c0                	test   %eax,%eax
8010650f:	79 0d                	jns    8010651e <popcli+0x4d>
    panic("popcli");
80106511:	83 ec 0c             	sub    $0xc,%esp
80106514:	68 cf 9f 10 80       	push   $0x80109fcf
80106519:	e8 48 a0 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010651e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106524:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010652a:	85 c0                	test   %eax,%eax
8010652c:	75 15                	jne    80106543 <popcli+0x72>
8010652e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106534:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010653a:	85 c0                	test   %eax,%eax
8010653c:	74 05                	je     80106543 <popcli+0x72>
    sti();
8010653e:	e8 a9 fd ff ff       	call   801062ec <sti>
}
80106543:	90                   	nop
80106544:	c9                   	leave  
80106545:	c3                   	ret    

80106546 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106546:	55                   	push   %ebp
80106547:	89 e5                	mov    %esp,%ebp
80106549:	57                   	push   %edi
8010654a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010654b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010654e:	8b 55 10             	mov    0x10(%ebp),%edx
80106551:	8b 45 0c             	mov    0xc(%ebp),%eax
80106554:	89 cb                	mov    %ecx,%ebx
80106556:	89 df                	mov    %ebx,%edi
80106558:	89 d1                	mov    %edx,%ecx
8010655a:	fc                   	cld    
8010655b:	f3 aa                	rep stos %al,%es:(%edi)
8010655d:	89 ca                	mov    %ecx,%edx
8010655f:	89 fb                	mov    %edi,%ebx
80106561:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106564:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106567:	90                   	nop
80106568:	5b                   	pop    %ebx
80106569:	5f                   	pop    %edi
8010656a:	5d                   	pop    %ebp
8010656b:	c3                   	ret    

8010656c <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010656c:	55                   	push   %ebp
8010656d:	89 e5                	mov    %esp,%ebp
8010656f:	57                   	push   %edi
80106570:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106571:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106574:	8b 55 10             	mov    0x10(%ebp),%edx
80106577:	8b 45 0c             	mov    0xc(%ebp),%eax
8010657a:	89 cb                	mov    %ecx,%ebx
8010657c:	89 df                	mov    %ebx,%edi
8010657e:	89 d1                	mov    %edx,%ecx
80106580:	fc                   	cld    
80106581:	f3 ab                	rep stos %eax,%es:(%edi)
80106583:	89 ca                	mov    %ecx,%edx
80106585:	89 fb                	mov    %edi,%ebx
80106587:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010658a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010658d:	90                   	nop
8010658e:	5b                   	pop    %ebx
8010658f:	5f                   	pop    %edi
80106590:	5d                   	pop    %ebp
80106591:	c3                   	ret    

80106592 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106592:	55                   	push   %ebp
80106593:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106595:	8b 45 08             	mov    0x8(%ebp),%eax
80106598:	83 e0 03             	and    $0x3,%eax
8010659b:	85 c0                	test   %eax,%eax
8010659d:	75 43                	jne    801065e2 <memset+0x50>
8010659f:	8b 45 10             	mov    0x10(%ebp),%eax
801065a2:	83 e0 03             	and    $0x3,%eax
801065a5:	85 c0                	test   %eax,%eax
801065a7:	75 39                	jne    801065e2 <memset+0x50>
    c &= 0xFF;
801065a9:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801065b0:	8b 45 10             	mov    0x10(%ebp),%eax
801065b3:	c1 e8 02             	shr    $0x2,%eax
801065b6:	89 c1                	mov    %eax,%ecx
801065b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801065bb:	c1 e0 18             	shl    $0x18,%eax
801065be:	89 c2                	mov    %eax,%edx
801065c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801065c3:	c1 e0 10             	shl    $0x10,%eax
801065c6:	09 c2                	or     %eax,%edx
801065c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801065cb:	c1 e0 08             	shl    $0x8,%eax
801065ce:	09 d0                	or     %edx,%eax
801065d0:	0b 45 0c             	or     0xc(%ebp),%eax
801065d3:	51                   	push   %ecx
801065d4:	50                   	push   %eax
801065d5:	ff 75 08             	pushl  0x8(%ebp)
801065d8:	e8 8f ff ff ff       	call   8010656c <stosl>
801065dd:	83 c4 0c             	add    $0xc,%esp
801065e0:	eb 12                	jmp    801065f4 <memset+0x62>
  } else
    stosb(dst, c, n);
801065e2:	8b 45 10             	mov    0x10(%ebp),%eax
801065e5:	50                   	push   %eax
801065e6:	ff 75 0c             	pushl  0xc(%ebp)
801065e9:	ff 75 08             	pushl  0x8(%ebp)
801065ec:	e8 55 ff ff ff       	call   80106546 <stosb>
801065f1:	83 c4 0c             	add    $0xc,%esp
  return dst;
801065f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801065f7:	c9                   	leave  
801065f8:	c3                   	ret    

801065f9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801065f9:	55                   	push   %ebp
801065fa:	89 e5                	mov    %esp,%ebp
801065fc:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801065ff:	8b 45 08             	mov    0x8(%ebp),%eax
80106602:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106605:	8b 45 0c             	mov    0xc(%ebp),%eax
80106608:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010660b:	eb 30                	jmp    8010663d <memcmp+0x44>
    if(*s1 != *s2)
8010660d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106610:	0f b6 10             	movzbl (%eax),%edx
80106613:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106616:	0f b6 00             	movzbl (%eax),%eax
80106619:	38 c2                	cmp    %al,%dl
8010661b:	74 18                	je     80106635 <memcmp+0x3c>
      return *s1 - *s2;
8010661d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106620:	0f b6 00             	movzbl (%eax),%eax
80106623:	0f b6 d0             	movzbl %al,%edx
80106626:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106629:	0f b6 00             	movzbl (%eax),%eax
8010662c:	0f b6 c0             	movzbl %al,%eax
8010662f:	29 c2                	sub    %eax,%edx
80106631:	89 d0                	mov    %edx,%eax
80106633:	eb 1a                	jmp    8010664f <memcmp+0x56>
    s1++, s2++;
80106635:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106639:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010663d:	8b 45 10             	mov    0x10(%ebp),%eax
80106640:	8d 50 ff             	lea    -0x1(%eax),%edx
80106643:	89 55 10             	mov    %edx,0x10(%ebp)
80106646:	85 c0                	test   %eax,%eax
80106648:	75 c3                	jne    8010660d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010664a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010664f:	c9                   	leave  
80106650:	c3                   	ret    

80106651 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106651:	55                   	push   %ebp
80106652:	89 e5                	mov    %esp,%ebp
80106654:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106657:	8b 45 0c             	mov    0xc(%ebp),%eax
8010665a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010665d:	8b 45 08             	mov    0x8(%ebp),%eax
80106660:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106663:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106666:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106669:	73 54                	jae    801066bf <memmove+0x6e>
8010666b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010666e:	8b 45 10             	mov    0x10(%ebp),%eax
80106671:	01 d0                	add    %edx,%eax
80106673:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106676:	76 47                	jbe    801066bf <memmove+0x6e>
    s += n;
80106678:	8b 45 10             	mov    0x10(%ebp),%eax
8010667b:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010667e:	8b 45 10             	mov    0x10(%ebp),%eax
80106681:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106684:	eb 13                	jmp    80106699 <memmove+0x48>
      *--d = *--s;
80106686:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010668a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010668e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106691:	0f b6 10             	movzbl (%eax),%edx
80106694:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106697:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106699:	8b 45 10             	mov    0x10(%ebp),%eax
8010669c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010669f:	89 55 10             	mov    %edx,0x10(%ebp)
801066a2:	85 c0                	test   %eax,%eax
801066a4:	75 e0                	jne    80106686 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801066a6:	eb 24                	jmp    801066cc <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801066a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801066ab:	8d 50 01             	lea    0x1(%eax),%edx
801066ae:	89 55 f8             	mov    %edx,-0x8(%ebp)
801066b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801066b4:	8d 4a 01             	lea    0x1(%edx),%ecx
801066b7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801066ba:	0f b6 12             	movzbl (%edx),%edx
801066bd:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801066bf:	8b 45 10             	mov    0x10(%ebp),%eax
801066c2:	8d 50 ff             	lea    -0x1(%eax),%edx
801066c5:	89 55 10             	mov    %edx,0x10(%ebp)
801066c8:	85 c0                	test   %eax,%eax
801066ca:	75 dc                	jne    801066a8 <memmove+0x57>
      *d++ = *s++;

  return dst;
801066cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
801066cf:	c9                   	leave  
801066d0:	c3                   	ret    

801066d1 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801066d1:	55                   	push   %ebp
801066d2:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801066d4:	ff 75 10             	pushl  0x10(%ebp)
801066d7:	ff 75 0c             	pushl  0xc(%ebp)
801066da:	ff 75 08             	pushl  0x8(%ebp)
801066dd:	e8 6f ff ff ff       	call   80106651 <memmove>
801066e2:	83 c4 0c             	add    $0xc,%esp
}
801066e5:	c9                   	leave  
801066e6:	c3                   	ret    

801066e7 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801066e7:	55                   	push   %ebp
801066e8:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801066ea:	eb 0c                	jmp    801066f8 <strncmp+0x11>
    n--, p++, q++;
801066ec:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801066f0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801066f4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801066f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066fc:	74 1a                	je     80106718 <strncmp+0x31>
801066fe:	8b 45 08             	mov    0x8(%ebp),%eax
80106701:	0f b6 00             	movzbl (%eax),%eax
80106704:	84 c0                	test   %al,%al
80106706:	74 10                	je     80106718 <strncmp+0x31>
80106708:	8b 45 08             	mov    0x8(%ebp),%eax
8010670b:	0f b6 10             	movzbl (%eax),%edx
8010670e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106711:	0f b6 00             	movzbl (%eax),%eax
80106714:	38 c2                	cmp    %al,%dl
80106716:	74 d4                	je     801066ec <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106718:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010671c:	75 07                	jne    80106725 <strncmp+0x3e>
    return 0;
8010671e:	b8 00 00 00 00       	mov    $0x0,%eax
80106723:	eb 16                	jmp    8010673b <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106725:	8b 45 08             	mov    0x8(%ebp),%eax
80106728:	0f b6 00             	movzbl (%eax),%eax
8010672b:	0f b6 d0             	movzbl %al,%edx
8010672e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106731:	0f b6 00             	movzbl (%eax),%eax
80106734:	0f b6 c0             	movzbl %al,%eax
80106737:	29 c2                	sub    %eax,%edx
80106739:	89 d0                	mov    %edx,%eax
}
8010673b:	5d                   	pop    %ebp
8010673c:	c3                   	ret    

8010673d <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010673d:	55                   	push   %ebp
8010673e:	89 e5                	mov    %esp,%ebp
80106740:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106743:	8b 45 08             	mov    0x8(%ebp),%eax
80106746:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106749:	90                   	nop
8010674a:	8b 45 10             	mov    0x10(%ebp),%eax
8010674d:	8d 50 ff             	lea    -0x1(%eax),%edx
80106750:	89 55 10             	mov    %edx,0x10(%ebp)
80106753:	85 c0                	test   %eax,%eax
80106755:	7e 2c                	jle    80106783 <strncpy+0x46>
80106757:	8b 45 08             	mov    0x8(%ebp),%eax
8010675a:	8d 50 01             	lea    0x1(%eax),%edx
8010675d:	89 55 08             	mov    %edx,0x8(%ebp)
80106760:	8b 55 0c             	mov    0xc(%ebp),%edx
80106763:	8d 4a 01             	lea    0x1(%edx),%ecx
80106766:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106769:	0f b6 12             	movzbl (%edx),%edx
8010676c:	88 10                	mov    %dl,(%eax)
8010676e:	0f b6 00             	movzbl (%eax),%eax
80106771:	84 c0                	test   %al,%al
80106773:	75 d5                	jne    8010674a <strncpy+0xd>
    ;
  while(n-- > 0)
80106775:	eb 0c                	jmp    80106783 <strncpy+0x46>
    *s++ = 0;
80106777:	8b 45 08             	mov    0x8(%ebp),%eax
8010677a:	8d 50 01             	lea    0x1(%eax),%edx
8010677d:	89 55 08             	mov    %edx,0x8(%ebp)
80106780:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106783:	8b 45 10             	mov    0x10(%ebp),%eax
80106786:	8d 50 ff             	lea    -0x1(%eax),%edx
80106789:	89 55 10             	mov    %edx,0x10(%ebp)
8010678c:	85 c0                	test   %eax,%eax
8010678e:	7f e7                	jg     80106777 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106790:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106793:	c9                   	leave  
80106794:	c3                   	ret    

80106795 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106795:	55                   	push   %ebp
80106796:	89 e5                	mov    %esp,%ebp
80106798:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010679b:	8b 45 08             	mov    0x8(%ebp),%eax
8010679e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801067a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801067a5:	7f 05                	jg     801067ac <safestrcpy+0x17>
    return os;
801067a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801067aa:	eb 31                	jmp    801067dd <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801067ac:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801067b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801067b4:	7e 1e                	jle    801067d4 <safestrcpy+0x3f>
801067b6:	8b 45 08             	mov    0x8(%ebp),%eax
801067b9:	8d 50 01             	lea    0x1(%eax),%edx
801067bc:	89 55 08             	mov    %edx,0x8(%ebp)
801067bf:	8b 55 0c             	mov    0xc(%ebp),%edx
801067c2:	8d 4a 01             	lea    0x1(%edx),%ecx
801067c5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801067c8:	0f b6 12             	movzbl (%edx),%edx
801067cb:	88 10                	mov    %dl,(%eax)
801067cd:	0f b6 00             	movzbl (%eax),%eax
801067d0:	84 c0                	test   %al,%al
801067d2:	75 d8                	jne    801067ac <safestrcpy+0x17>
    ;
  *s = 0;
801067d4:	8b 45 08             	mov    0x8(%ebp),%eax
801067d7:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801067da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801067dd:	c9                   	leave  
801067de:	c3                   	ret    

801067df <strlen>:

int
strlen(const char *s)
{
801067df:	55                   	push   %ebp
801067e0:	89 e5                	mov    %esp,%ebp
801067e2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801067e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801067ec:	eb 04                	jmp    801067f2 <strlen+0x13>
801067ee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801067f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801067f5:	8b 45 08             	mov    0x8(%ebp),%eax
801067f8:	01 d0                	add    %edx,%eax
801067fa:	0f b6 00             	movzbl (%eax),%eax
801067fd:	84 c0                	test   %al,%al
801067ff:	75 ed                	jne    801067ee <strlen+0xf>
    ;
  return n;
80106801:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106804:	c9                   	leave  
80106805:	c3                   	ret    

80106806 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106806:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010680a:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010680e:	55                   	push   %ebp
  pushl %ebx
8010680f:	53                   	push   %ebx
  pushl %esi
80106810:	56                   	push   %esi
  pushl %edi
80106811:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106812:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106814:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106816:	5f                   	pop    %edi
  popl %esi
80106817:	5e                   	pop    %esi
  popl %ebx
80106818:	5b                   	pop    %ebx
  popl %ebp
80106819:	5d                   	pop    %ebp
  ret
8010681a:	c3                   	ret    

8010681b <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010681b:	55                   	push   %ebp
8010681c:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010681e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106824:	8b 00                	mov    (%eax),%eax
80106826:	3b 45 08             	cmp    0x8(%ebp),%eax
80106829:	76 12                	jbe    8010683d <fetchint+0x22>
8010682b:	8b 45 08             	mov    0x8(%ebp),%eax
8010682e:	8d 50 04             	lea    0x4(%eax),%edx
80106831:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106837:	8b 00                	mov    (%eax),%eax
80106839:	39 c2                	cmp    %eax,%edx
8010683b:	76 07                	jbe    80106844 <fetchint+0x29>
    return -1;
8010683d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106842:	eb 0f                	jmp    80106853 <fetchint+0x38>
  *ip = *(int*)(addr);
80106844:	8b 45 08             	mov    0x8(%ebp),%eax
80106847:	8b 10                	mov    (%eax),%edx
80106849:	8b 45 0c             	mov    0xc(%ebp),%eax
8010684c:	89 10                	mov    %edx,(%eax)
  return 0;
8010684e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106853:	5d                   	pop    %ebp
80106854:	c3                   	ret    

80106855 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106855:	55                   	push   %ebp
80106856:	89 e5                	mov    %esp,%ebp
80106858:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010685b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106861:	8b 00                	mov    (%eax),%eax
80106863:	3b 45 08             	cmp    0x8(%ebp),%eax
80106866:	77 07                	ja     8010686f <fetchstr+0x1a>
    return -1;
80106868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010686d:	eb 46                	jmp    801068b5 <fetchstr+0x60>
  *pp = (char*)addr;
8010686f:	8b 55 08             	mov    0x8(%ebp),%edx
80106872:	8b 45 0c             	mov    0xc(%ebp),%eax
80106875:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106877:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010687d:	8b 00                	mov    (%eax),%eax
8010687f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106882:	8b 45 0c             	mov    0xc(%ebp),%eax
80106885:	8b 00                	mov    (%eax),%eax
80106887:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010688a:	eb 1c                	jmp    801068a8 <fetchstr+0x53>
    if(*s == 0)
8010688c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010688f:	0f b6 00             	movzbl (%eax),%eax
80106892:	84 c0                	test   %al,%al
80106894:	75 0e                	jne    801068a4 <fetchstr+0x4f>
      return s - *pp;
80106896:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106899:	8b 45 0c             	mov    0xc(%ebp),%eax
8010689c:	8b 00                	mov    (%eax),%eax
8010689e:	29 c2                	sub    %eax,%edx
801068a0:	89 d0                	mov    %edx,%eax
801068a2:	eb 11                	jmp    801068b5 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801068a4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801068a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801068ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801068ae:	72 dc                	jb     8010688c <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801068b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068b5:	c9                   	leave  
801068b6:	c3                   	ret    

801068b7 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801068b7:	55                   	push   %ebp
801068b8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801068ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068c0:	8b 40 18             	mov    0x18(%eax),%eax
801068c3:	8b 40 44             	mov    0x44(%eax),%eax
801068c6:	8b 55 08             	mov    0x8(%ebp),%edx
801068c9:	c1 e2 02             	shl    $0x2,%edx
801068cc:	01 d0                	add    %edx,%eax
801068ce:	83 c0 04             	add    $0x4,%eax
801068d1:	ff 75 0c             	pushl  0xc(%ebp)
801068d4:	50                   	push   %eax
801068d5:	e8 41 ff ff ff       	call   8010681b <fetchint>
801068da:	83 c4 08             	add    $0x8,%esp
}
801068dd:	c9                   	leave  
801068de:	c3                   	ret    

801068df <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801068df:	55                   	push   %ebp
801068e0:	89 e5                	mov    %esp,%ebp
801068e2:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801068e5:	8d 45 fc             	lea    -0x4(%ebp),%eax
801068e8:	50                   	push   %eax
801068e9:	ff 75 08             	pushl  0x8(%ebp)
801068ec:	e8 c6 ff ff ff       	call   801068b7 <argint>
801068f1:	83 c4 08             	add    $0x8,%esp
801068f4:	85 c0                	test   %eax,%eax
801068f6:	79 07                	jns    801068ff <argptr+0x20>
    return -1;
801068f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068fd:	eb 3b                	jmp    8010693a <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801068ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106905:	8b 00                	mov    (%eax),%eax
80106907:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010690a:	39 d0                	cmp    %edx,%eax
8010690c:	76 16                	jbe    80106924 <argptr+0x45>
8010690e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106911:	89 c2                	mov    %eax,%edx
80106913:	8b 45 10             	mov    0x10(%ebp),%eax
80106916:	01 c2                	add    %eax,%edx
80106918:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010691e:	8b 00                	mov    (%eax),%eax
80106920:	39 c2                	cmp    %eax,%edx
80106922:	76 07                	jbe    8010692b <argptr+0x4c>
    return -1;
80106924:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106929:	eb 0f                	jmp    8010693a <argptr+0x5b>
  *pp = (char*)i;
8010692b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010692e:	89 c2                	mov    %eax,%edx
80106930:	8b 45 0c             	mov    0xc(%ebp),%eax
80106933:	89 10                	mov    %edx,(%eax)
  return 0;
80106935:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010693a:	c9                   	leave  
8010693b:	c3                   	ret    

8010693c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010693c:	55                   	push   %ebp
8010693d:	89 e5                	mov    %esp,%ebp
8010693f:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106942:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106945:	50                   	push   %eax
80106946:	ff 75 08             	pushl  0x8(%ebp)
80106949:	e8 69 ff ff ff       	call   801068b7 <argint>
8010694e:	83 c4 08             	add    $0x8,%esp
80106951:	85 c0                	test   %eax,%eax
80106953:	79 07                	jns    8010695c <argstr+0x20>
    return -1;
80106955:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695a:	eb 0f                	jmp    8010696b <argstr+0x2f>
  return fetchstr(addr, pp);
8010695c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010695f:	ff 75 0c             	pushl  0xc(%ebp)
80106962:	50                   	push   %eax
80106963:	e8 ed fe ff ff       	call   80106855 <fetchstr>
80106968:	83 c4 08             	add    $0x8,%esp
}
8010696b:	c9                   	leave  
8010696c:	c3                   	ret    

8010696d <syscall>:
};
#endif 

void
syscall(void)
{
8010696d:	55                   	push   %ebp
8010696e:	89 e5                	mov    %esp,%ebp
80106970:	53                   	push   %ebx
80106971:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106974:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010697a:	8b 40 18             	mov    0x18(%eax),%eax
8010697d:	8b 40 1c             	mov    0x1c(%eax),%eax
80106980:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106983:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106987:	7e 30                	jle    801069b9 <syscall+0x4c>
80106989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010698c:	83 f8 1e             	cmp    $0x1e,%eax
8010698f:	77 28                	ja     801069b9 <syscall+0x4c>
80106991:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106994:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
8010699b:	85 c0                	test   %eax,%eax
8010699d:	74 1a                	je     801069b9 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
8010699f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069a5:	8b 58 18             	mov    0x18(%eax),%ebx
801069a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069ab:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801069b2:	ff d0                	call   *%eax
801069b4:	89 43 1c             	mov    %eax,0x1c(%ebx)
801069b7:	eb 34                	jmp    801069ed <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801069b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069bf:	8d 50 6c             	lea    0x6c(%eax),%edx
801069c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801069c8:	8b 40 10             	mov    0x10(%eax),%eax
801069cb:	ff 75 f4             	pushl  -0xc(%ebp)
801069ce:	52                   	push   %edx
801069cf:	50                   	push   %eax
801069d0:	68 d6 9f 10 80       	push   $0x80109fd6
801069d5:	e8 ec 99 ff ff       	call   801003c6 <cprintf>
801069da:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801069dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069e3:	8b 40 18             	mov    0x18(%eax),%eax
801069e6:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801069ed:	90                   	nop
801069ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801069f1:	c9                   	leave  
801069f2:	c3                   	ret    

801069f3 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801069f3:	55                   	push   %ebp
801069f4:	89 e5                	mov    %esp,%ebp
801069f6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801069f9:	83 ec 08             	sub    $0x8,%esp
801069fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069ff:	50                   	push   %eax
80106a00:	ff 75 08             	pushl  0x8(%ebp)
80106a03:	e8 af fe ff ff       	call   801068b7 <argint>
80106a08:	83 c4 10             	add    $0x10,%esp
80106a0b:	85 c0                	test   %eax,%eax
80106a0d:	79 07                	jns    80106a16 <argfd+0x23>
    return -1;
80106a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a14:	eb 50                	jmp    80106a66 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a19:	85 c0                	test   %eax,%eax
80106a1b:	78 21                	js     80106a3e <argfd+0x4b>
80106a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a20:	83 f8 0f             	cmp    $0xf,%eax
80106a23:	7f 19                	jg     80106a3e <argfd+0x4b>
80106a25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a2e:	83 c2 08             	add    $0x8,%edx
80106a31:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a3c:	75 07                	jne    80106a45 <argfd+0x52>
    return -1;
80106a3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a43:	eb 21                	jmp    80106a66 <argfd+0x73>
  if(pfd)
80106a45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106a49:	74 08                	je     80106a53 <argfd+0x60>
    *pfd = fd;
80106a4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a51:	89 10                	mov    %edx,(%eax)
  if(pf)
80106a53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106a57:	74 08                	je     80106a61 <argfd+0x6e>
    *pf = f;
80106a59:	8b 45 10             	mov    0x10(%ebp),%eax
80106a5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a5f:	89 10                	mov    %edx,(%eax)
  return 0;
80106a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a66:	c9                   	leave  
80106a67:	c3                   	ret    

80106a68 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106a68:	55                   	push   %ebp
80106a69:	89 e5                	mov    %esp,%ebp
80106a6b:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106a6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106a75:	eb 30                	jmp    80106aa7 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106a77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a80:	83 c2 08             	add    $0x8,%edx
80106a83:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106a87:	85 c0                	test   %eax,%eax
80106a89:	75 18                	jne    80106aa3 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106a8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a91:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a94:	8d 4a 08             	lea    0x8(%edx),%ecx
80106a97:	8b 55 08             	mov    0x8(%ebp),%edx
80106a9a:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106a9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106aa1:	eb 0f                	jmp    80106ab2 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106aa3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106aa7:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106aab:	7e ca                	jle    80106a77 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106aad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ab2:	c9                   	leave  
80106ab3:	c3                   	ret    

80106ab4 <sys_dup>:

int
sys_dup(void)
{
80106ab4:	55                   	push   %ebp
80106ab5:	89 e5                	mov    %esp,%ebp
80106ab7:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106aba:	83 ec 04             	sub    $0x4,%esp
80106abd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ac0:	50                   	push   %eax
80106ac1:	6a 00                	push   $0x0
80106ac3:	6a 00                	push   $0x0
80106ac5:	e8 29 ff ff ff       	call   801069f3 <argfd>
80106aca:	83 c4 10             	add    $0x10,%esp
80106acd:	85 c0                	test   %eax,%eax
80106acf:	79 07                	jns    80106ad8 <sys_dup+0x24>
    return -1;
80106ad1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ad6:	eb 31                	jmp    80106b09 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106adb:	83 ec 0c             	sub    $0xc,%esp
80106ade:	50                   	push   %eax
80106adf:	e8 84 ff ff ff       	call   80106a68 <fdalloc>
80106ae4:	83 c4 10             	add    $0x10,%esp
80106ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106aee:	79 07                	jns    80106af7 <sys_dup+0x43>
    return -1;
80106af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106af5:	eb 12                	jmp    80106b09 <sys_dup+0x55>
  filedup(f);
80106af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106afa:	83 ec 0c             	sub    $0xc,%esp
80106afd:	50                   	push   %eax
80106afe:	e8 a7 a5 ff ff       	call   801010aa <filedup>
80106b03:	83 c4 10             	add    $0x10,%esp
  return fd;
80106b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106b09:	c9                   	leave  
80106b0a:	c3                   	ret    

80106b0b <sys_read>:

int
sys_read(void)
{
80106b0b:	55                   	push   %ebp
80106b0c:	89 e5                	mov    %esp,%ebp
80106b0e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106b11:	83 ec 04             	sub    $0x4,%esp
80106b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b17:	50                   	push   %eax
80106b18:	6a 00                	push   $0x0
80106b1a:	6a 00                	push   $0x0
80106b1c:	e8 d2 fe ff ff       	call   801069f3 <argfd>
80106b21:	83 c4 10             	add    $0x10,%esp
80106b24:	85 c0                	test   %eax,%eax
80106b26:	78 2e                	js     80106b56 <sys_read+0x4b>
80106b28:	83 ec 08             	sub    $0x8,%esp
80106b2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b2e:	50                   	push   %eax
80106b2f:	6a 02                	push   $0x2
80106b31:	e8 81 fd ff ff       	call   801068b7 <argint>
80106b36:	83 c4 10             	add    $0x10,%esp
80106b39:	85 c0                	test   %eax,%eax
80106b3b:	78 19                	js     80106b56 <sys_read+0x4b>
80106b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b40:	83 ec 04             	sub    $0x4,%esp
80106b43:	50                   	push   %eax
80106b44:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b47:	50                   	push   %eax
80106b48:	6a 01                	push   $0x1
80106b4a:	e8 90 fd ff ff       	call   801068df <argptr>
80106b4f:	83 c4 10             	add    $0x10,%esp
80106b52:	85 c0                	test   %eax,%eax
80106b54:	79 07                	jns    80106b5d <sys_read+0x52>
    return -1;
80106b56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b5b:	eb 17                	jmp    80106b74 <sys_read+0x69>
  return fileread(f, p, n);
80106b5d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106b60:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b66:	83 ec 04             	sub    $0x4,%esp
80106b69:	51                   	push   %ecx
80106b6a:	52                   	push   %edx
80106b6b:	50                   	push   %eax
80106b6c:	e8 c9 a6 ff ff       	call   8010123a <fileread>
80106b71:	83 c4 10             	add    $0x10,%esp
}
80106b74:	c9                   	leave  
80106b75:	c3                   	ret    

80106b76 <sys_write>:

int
sys_write(void)
{
80106b76:	55                   	push   %ebp
80106b77:	89 e5                	mov    %esp,%ebp
80106b79:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106b7c:	83 ec 04             	sub    $0x4,%esp
80106b7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b82:	50                   	push   %eax
80106b83:	6a 00                	push   $0x0
80106b85:	6a 00                	push   $0x0
80106b87:	e8 67 fe ff ff       	call   801069f3 <argfd>
80106b8c:	83 c4 10             	add    $0x10,%esp
80106b8f:	85 c0                	test   %eax,%eax
80106b91:	78 2e                	js     80106bc1 <sys_write+0x4b>
80106b93:	83 ec 08             	sub    $0x8,%esp
80106b96:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b99:	50                   	push   %eax
80106b9a:	6a 02                	push   $0x2
80106b9c:	e8 16 fd ff ff       	call   801068b7 <argint>
80106ba1:	83 c4 10             	add    $0x10,%esp
80106ba4:	85 c0                	test   %eax,%eax
80106ba6:	78 19                	js     80106bc1 <sys_write+0x4b>
80106ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bab:	83 ec 04             	sub    $0x4,%esp
80106bae:	50                   	push   %eax
80106baf:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106bb2:	50                   	push   %eax
80106bb3:	6a 01                	push   $0x1
80106bb5:	e8 25 fd ff ff       	call   801068df <argptr>
80106bba:	83 c4 10             	add    $0x10,%esp
80106bbd:	85 c0                	test   %eax,%eax
80106bbf:	79 07                	jns    80106bc8 <sys_write+0x52>
    return -1;
80106bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bc6:	eb 17                	jmp    80106bdf <sys_write+0x69>
  return filewrite(f, p, n);
80106bc8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106bcb:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bd1:	83 ec 04             	sub    $0x4,%esp
80106bd4:	51                   	push   %ecx
80106bd5:	52                   	push   %edx
80106bd6:	50                   	push   %eax
80106bd7:	e8 16 a7 ff ff       	call   801012f2 <filewrite>
80106bdc:	83 c4 10             	add    $0x10,%esp
}
80106bdf:	c9                   	leave  
80106be0:	c3                   	ret    

80106be1 <sys_close>:

int
sys_close(void)
{
80106be1:	55                   	push   %ebp
80106be2:	89 e5                	mov    %esp,%ebp
80106be4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106be7:	83 ec 04             	sub    $0x4,%esp
80106bea:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bed:	50                   	push   %eax
80106bee:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bf1:	50                   	push   %eax
80106bf2:	6a 00                	push   $0x0
80106bf4:	e8 fa fd ff ff       	call   801069f3 <argfd>
80106bf9:	83 c4 10             	add    $0x10,%esp
80106bfc:	85 c0                	test   %eax,%eax
80106bfe:	79 07                	jns    80106c07 <sys_close+0x26>
    return -1;
80106c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c05:	eb 28                	jmp    80106c2f <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106c07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c10:	83 c2 08             	add    $0x8,%edx
80106c13:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106c1a:	00 
  fileclose(f);
80106c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c1e:	83 ec 0c             	sub    $0xc,%esp
80106c21:	50                   	push   %eax
80106c22:	e8 d4 a4 ff ff       	call   801010fb <fileclose>
80106c27:	83 c4 10             	add    $0x10,%esp
  return 0;
80106c2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c2f:	c9                   	leave  
80106c30:	c3                   	ret    

80106c31 <sys_fstat>:

int
sys_fstat(void)
{
80106c31:	55                   	push   %ebp
80106c32:	89 e5                	mov    %esp,%ebp
80106c34:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106c37:	83 ec 04             	sub    $0x4,%esp
80106c3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c3d:	50                   	push   %eax
80106c3e:	6a 00                	push   $0x0
80106c40:	6a 00                	push   $0x0
80106c42:	e8 ac fd ff ff       	call   801069f3 <argfd>
80106c47:	83 c4 10             	add    $0x10,%esp
80106c4a:	85 c0                	test   %eax,%eax
80106c4c:	78 17                	js     80106c65 <sys_fstat+0x34>
80106c4e:	83 ec 04             	sub    $0x4,%esp
80106c51:	6a 14                	push   $0x14
80106c53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c56:	50                   	push   %eax
80106c57:	6a 01                	push   $0x1
80106c59:	e8 81 fc ff ff       	call   801068df <argptr>
80106c5e:	83 c4 10             	add    $0x10,%esp
80106c61:	85 c0                	test   %eax,%eax
80106c63:	79 07                	jns    80106c6c <sys_fstat+0x3b>
    return -1;
80106c65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c6a:	eb 13                	jmp    80106c7f <sys_fstat+0x4e>
  return filestat(f, st);
80106c6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c72:	83 ec 08             	sub    $0x8,%esp
80106c75:	52                   	push   %edx
80106c76:	50                   	push   %eax
80106c77:	e8 67 a5 ff ff       	call   801011e3 <filestat>
80106c7c:	83 c4 10             	add    $0x10,%esp
}
80106c7f:	c9                   	leave  
80106c80:	c3                   	ret    

80106c81 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106c81:	55                   	push   %ebp
80106c82:	89 e5                	mov    %esp,%ebp
80106c84:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106c87:	83 ec 08             	sub    $0x8,%esp
80106c8a:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106c8d:	50                   	push   %eax
80106c8e:	6a 00                	push   $0x0
80106c90:	e8 a7 fc ff ff       	call   8010693c <argstr>
80106c95:	83 c4 10             	add    $0x10,%esp
80106c98:	85 c0                	test   %eax,%eax
80106c9a:	78 15                	js     80106cb1 <sys_link+0x30>
80106c9c:	83 ec 08             	sub    $0x8,%esp
80106c9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106ca2:	50                   	push   %eax
80106ca3:	6a 01                	push   $0x1
80106ca5:	e8 92 fc ff ff       	call   8010693c <argstr>
80106caa:	83 c4 10             	add    $0x10,%esp
80106cad:	85 c0                	test   %eax,%eax
80106caf:	79 0a                	jns    80106cbb <sys_link+0x3a>
    return -1;
80106cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cb6:	e9 68 01 00 00       	jmp    80106e23 <sys_link+0x1a2>

  begin_op();
80106cbb:	e8 37 c9 ff ff       	call   801035f7 <begin_op>
  if((ip = namei(old)) == 0){
80106cc0:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106cc3:	83 ec 0c             	sub    $0xc,%esp
80106cc6:	50                   	push   %eax
80106cc7:	e8 06 b9 ff ff       	call   801025d2 <namei>
80106ccc:	83 c4 10             	add    $0x10,%esp
80106ccf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106cd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106cd6:	75 0f                	jne    80106ce7 <sys_link+0x66>
    end_op();
80106cd8:	e8 a6 c9 ff ff       	call   80103683 <end_op>
    return -1;
80106cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ce2:	e9 3c 01 00 00       	jmp    80106e23 <sys_link+0x1a2>
  }

  ilock(ip);
80106ce7:	83 ec 0c             	sub    $0xc,%esp
80106cea:	ff 75 f4             	pushl  -0xc(%ebp)
80106ced:	e8 22 ad ff ff       	call   80101a14 <ilock>
80106cf2:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cf8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106cfc:	66 83 f8 01          	cmp    $0x1,%ax
80106d00:	75 1d                	jne    80106d1f <sys_link+0x9e>
    iunlockput(ip);
80106d02:	83 ec 0c             	sub    $0xc,%esp
80106d05:	ff 75 f4             	pushl  -0xc(%ebp)
80106d08:	e8 c7 af ff ff       	call   80101cd4 <iunlockput>
80106d0d:	83 c4 10             	add    $0x10,%esp
    end_op();
80106d10:	e8 6e c9 ff ff       	call   80103683 <end_op>
    return -1;
80106d15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d1a:	e9 04 01 00 00       	jmp    80106e23 <sys_link+0x1a2>
  }

  ip->nlink++;
80106d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d22:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106d26:	83 c0 01             	add    $0x1,%eax
80106d29:	89 c2                	mov    %eax,%edx
80106d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d2e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106d32:	83 ec 0c             	sub    $0xc,%esp
80106d35:	ff 75 f4             	pushl  -0xc(%ebp)
80106d38:	e8 fd aa ff ff       	call   8010183a <iupdate>
80106d3d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106d40:	83 ec 0c             	sub    $0xc,%esp
80106d43:	ff 75 f4             	pushl  -0xc(%ebp)
80106d46:	e8 27 ae ff ff       	call   80101b72 <iunlock>
80106d4b:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106d4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d51:	83 ec 08             	sub    $0x8,%esp
80106d54:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106d57:	52                   	push   %edx
80106d58:	50                   	push   %eax
80106d59:	e8 90 b8 ff ff       	call   801025ee <nameiparent>
80106d5e:	83 c4 10             	add    $0x10,%esp
80106d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d68:	74 71                	je     80106ddb <sys_link+0x15a>
    goto bad;
  ilock(dp);
80106d6a:	83 ec 0c             	sub    $0xc,%esp
80106d6d:	ff 75 f0             	pushl  -0x10(%ebp)
80106d70:	e8 9f ac ff ff       	call   80101a14 <ilock>
80106d75:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d7b:	8b 10                	mov    (%eax),%edx
80106d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d80:	8b 00                	mov    (%eax),%eax
80106d82:	39 c2                	cmp    %eax,%edx
80106d84:	75 1d                	jne    80106da3 <sys_link+0x122>
80106d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d89:	8b 40 04             	mov    0x4(%eax),%eax
80106d8c:	83 ec 04             	sub    $0x4,%esp
80106d8f:	50                   	push   %eax
80106d90:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106d93:	50                   	push   %eax
80106d94:	ff 75 f0             	pushl  -0x10(%ebp)
80106d97:	e8 9a b5 ff ff       	call   80102336 <dirlink>
80106d9c:	83 c4 10             	add    $0x10,%esp
80106d9f:	85 c0                	test   %eax,%eax
80106da1:	79 10                	jns    80106db3 <sys_link+0x132>
    iunlockput(dp);
80106da3:	83 ec 0c             	sub    $0xc,%esp
80106da6:	ff 75 f0             	pushl  -0x10(%ebp)
80106da9:	e8 26 af ff ff       	call   80101cd4 <iunlockput>
80106dae:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106db1:	eb 29                	jmp    80106ddc <sys_link+0x15b>
  }
  iunlockput(dp);
80106db3:	83 ec 0c             	sub    $0xc,%esp
80106db6:	ff 75 f0             	pushl  -0x10(%ebp)
80106db9:	e8 16 af ff ff       	call   80101cd4 <iunlockput>
80106dbe:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106dc1:	83 ec 0c             	sub    $0xc,%esp
80106dc4:	ff 75 f4             	pushl  -0xc(%ebp)
80106dc7:	e8 18 ae ff ff       	call   80101be4 <iput>
80106dcc:	83 c4 10             	add    $0x10,%esp

  end_op();
80106dcf:	e8 af c8 ff ff       	call   80103683 <end_op>

  return 0;
80106dd4:	b8 00 00 00 00       	mov    $0x0,%eax
80106dd9:	eb 48                	jmp    80106e23 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106ddb:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80106ddc:	83 ec 0c             	sub    $0xc,%esp
80106ddf:	ff 75 f4             	pushl  -0xc(%ebp)
80106de2:	e8 2d ac ff ff       	call   80101a14 <ilock>
80106de7:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ded:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106df1:	83 e8 01             	sub    $0x1,%eax
80106df4:	89 c2                	mov    %eax,%edx
80106df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df9:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106dfd:	83 ec 0c             	sub    $0xc,%esp
80106e00:	ff 75 f4             	pushl  -0xc(%ebp)
80106e03:	e8 32 aa ff ff       	call   8010183a <iupdate>
80106e08:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106e0b:	83 ec 0c             	sub    $0xc,%esp
80106e0e:	ff 75 f4             	pushl  -0xc(%ebp)
80106e11:	e8 be ae ff ff       	call   80101cd4 <iunlockput>
80106e16:	83 c4 10             	add    $0x10,%esp
  end_op();
80106e19:	e8 65 c8 ff ff       	call   80103683 <end_op>
  return -1;
80106e1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e23:	c9                   	leave  
80106e24:	c3                   	ret    

80106e25 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106e25:	55                   	push   %ebp
80106e26:	89 e5                	mov    %esp,%ebp
80106e28:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106e2b:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106e32:	eb 40                	jmp    80106e74 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e37:	6a 10                	push   $0x10
80106e39:	50                   	push   %eax
80106e3a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106e3d:	50                   	push   %eax
80106e3e:	ff 75 08             	pushl  0x8(%ebp)
80106e41:	e8 3c b1 ff ff       	call   80101f82 <readi>
80106e46:	83 c4 10             	add    $0x10,%esp
80106e49:	83 f8 10             	cmp    $0x10,%eax
80106e4c:	74 0d                	je     80106e5b <isdirempty+0x36>
      panic("isdirempty: readi");
80106e4e:	83 ec 0c             	sub    $0xc,%esp
80106e51:	68 f2 9f 10 80       	push   $0x80109ff2
80106e56:	e8 0b 97 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80106e5b:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106e5f:	66 85 c0             	test   %ax,%ax
80106e62:	74 07                	je     80106e6b <isdirempty+0x46>
      return 0;
80106e64:	b8 00 00 00 00       	mov    $0x0,%eax
80106e69:	eb 1b                	jmp    80106e86 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e6e:	83 c0 10             	add    $0x10,%eax
80106e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e74:	8b 45 08             	mov    0x8(%ebp),%eax
80106e77:	8b 50 18             	mov    0x18(%eax),%edx
80106e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e7d:	39 c2                	cmp    %eax,%edx
80106e7f:	77 b3                	ja     80106e34 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106e81:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106e86:	c9                   	leave  
80106e87:	c3                   	ret    

80106e88 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106e88:	55                   	push   %ebp
80106e89:	89 e5                	mov    %esp,%ebp
80106e8b:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106e8e:	83 ec 08             	sub    $0x8,%esp
80106e91:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106e94:	50                   	push   %eax
80106e95:	6a 00                	push   $0x0
80106e97:	e8 a0 fa ff ff       	call   8010693c <argstr>
80106e9c:	83 c4 10             	add    $0x10,%esp
80106e9f:	85 c0                	test   %eax,%eax
80106ea1:	79 0a                	jns    80106ead <sys_unlink+0x25>
    return -1;
80106ea3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ea8:	e9 bc 01 00 00       	jmp    80107069 <sys_unlink+0x1e1>

  begin_op();
80106ead:	e8 45 c7 ff ff       	call   801035f7 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106eb2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106eb5:	83 ec 08             	sub    $0x8,%esp
80106eb8:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106ebb:	52                   	push   %edx
80106ebc:	50                   	push   %eax
80106ebd:	e8 2c b7 ff ff       	call   801025ee <nameiparent>
80106ec2:	83 c4 10             	add    $0x10,%esp
80106ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ec8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ecc:	75 0f                	jne    80106edd <sys_unlink+0x55>
    end_op();
80106ece:	e8 b0 c7 ff ff       	call   80103683 <end_op>
    return -1;
80106ed3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ed8:	e9 8c 01 00 00       	jmp    80107069 <sys_unlink+0x1e1>
  }

  ilock(dp);
80106edd:	83 ec 0c             	sub    $0xc,%esp
80106ee0:	ff 75 f4             	pushl  -0xc(%ebp)
80106ee3:	e8 2c ab ff ff       	call   80101a14 <ilock>
80106ee8:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106eeb:	83 ec 08             	sub    $0x8,%esp
80106eee:	68 04 a0 10 80       	push   $0x8010a004
80106ef3:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106ef6:	50                   	push   %eax
80106ef7:	e8 65 b3 ff ff       	call   80102261 <namecmp>
80106efc:	83 c4 10             	add    $0x10,%esp
80106eff:	85 c0                	test   %eax,%eax
80106f01:	0f 84 4a 01 00 00    	je     80107051 <sys_unlink+0x1c9>
80106f07:	83 ec 08             	sub    $0x8,%esp
80106f0a:	68 06 a0 10 80       	push   $0x8010a006
80106f0f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106f12:	50                   	push   %eax
80106f13:	e8 49 b3 ff ff       	call   80102261 <namecmp>
80106f18:	83 c4 10             	add    $0x10,%esp
80106f1b:	85 c0                	test   %eax,%eax
80106f1d:	0f 84 2e 01 00 00    	je     80107051 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106f23:	83 ec 04             	sub    $0x4,%esp
80106f26:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106f29:	50                   	push   %eax
80106f2a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106f2d:	50                   	push   %eax
80106f2e:	ff 75 f4             	pushl  -0xc(%ebp)
80106f31:	e8 46 b3 ff ff       	call   8010227c <dirlookup>
80106f36:	83 c4 10             	add    $0x10,%esp
80106f39:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106f3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106f40:	0f 84 0a 01 00 00    	je     80107050 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106f46:	83 ec 0c             	sub    $0xc,%esp
80106f49:	ff 75 f0             	pushl  -0x10(%ebp)
80106f4c:	e8 c3 aa ff ff       	call   80101a14 <ilock>
80106f51:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f57:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106f5b:	66 85 c0             	test   %ax,%ax
80106f5e:	7f 0d                	jg     80106f6d <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106f60:	83 ec 0c             	sub    $0xc,%esp
80106f63:	68 09 a0 10 80       	push   $0x8010a009
80106f68:	e8 f9 95 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f70:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106f74:	66 83 f8 01          	cmp    $0x1,%ax
80106f78:	75 25                	jne    80106f9f <sys_unlink+0x117>
80106f7a:	83 ec 0c             	sub    $0xc,%esp
80106f7d:	ff 75 f0             	pushl  -0x10(%ebp)
80106f80:	e8 a0 fe ff ff       	call   80106e25 <isdirempty>
80106f85:	83 c4 10             	add    $0x10,%esp
80106f88:	85 c0                	test   %eax,%eax
80106f8a:	75 13                	jne    80106f9f <sys_unlink+0x117>
    iunlockput(ip);
80106f8c:	83 ec 0c             	sub    $0xc,%esp
80106f8f:	ff 75 f0             	pushl  -0x10(%ebp)
80106f92:	e8 3d ad ff ff       	call   80101cd4 <iunlockput>
80106f97:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106f9a:	e9 b2 00 00 00       	jmp    80107051 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106f9f:	83 ec 04             	sub    $0x4,%esp
80106fa2:	6a 10                	push   $0x10
80106fa4:	6a 00                	push   $0x0
80106fa6:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106fa9:	50                   	push   %eax
80106faa:	e8 e3 f5 ff ff       	call   80106592 <memset>
80106faf:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106fb2:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106fb5:	6a 10                	push   $0x10
80106fb7:	50                   	push   %eax
80106fb8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106fbb:	50                   	push   %eax
80106fbc:	ff 75 f4             	pushl  -0xc(%ebp)
80106fbf:	e8 15 b1 ff ff       	call   801020d9 <writei>
80106fc4:	83 c4 10             	add    $0x10,%esp
80106fc7:	83 f8 10             	cmp    $0x10,%eax
80106fca:	74 0d                	je     80106fd9 <sys_unlink+0x151>
    panic("unlink: writei");
80106fcc:	83 ec 0c             	sub    $0xc,%esp
80106fcf:	68 1b a0 10 80       	push   $0x8010a01b
80106fd4:	e8 8d 95 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80106fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fdc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106fe0:	66 83 f8 01          	cmp    $0x1,%ax
80106fe4:	75 21                	jne    80107007 <sys_unlink+0x17f>
    dp->nlink--;
80106fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fe9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106fed:	83 e8 01             	sub    $0x1,%eax
80106ff0:	89 c2                	mov    %eax,%edx
80106ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ff5:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106ff9:	83 ec 0c             	sub    $0xc,%esp
80106ffc:	ff 75 f4             	pushl  -0xc(%ebp)
80106fff:	e8 36 a8 ff ff       	call   8010183a <iupdate>
80107004:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80107007:	83 ec 0c             	sub    $0xc,%esp
8010700a:	ff 75 f4             	pushl  -0xc(%ebp)
8010700d:	e8 c2 ac ff ff       	call   80101cd4 <iunlockput>
80107012:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80107015:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107018:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010701c:	83 e8 01             	sub    $0x1,%eax
8010701f:	89 c2                	mov    %eax,%edx
80107021:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107024:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107028:	83 ec 0c             	sub    $0xc,%esp
8010702b:	ff 75 f0             	pushl  -0x10(%ebp)
8010702e:	e8 07 a8 ff ff       	call   8010183a <iupdate>
80107033:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107036:	83 ec 0c             	sub    $0xc,%esp
80107039:	ff 75 f0             	pushl  -0x10(%ebp)
8010703c:	e8 93 ac ff ff       	call   80101cd4 <iunlockput>
80107041:	83 c4 10             	add    $0x10,%esp

  end_op();
80107044:	e8 3a c6 ff ff       	call   80103683 <end_op>

  return 0;
80107049:	b8 00 00 00 00       	mov    $0x0,%eax
8010704e:	eb 19                	jmp    80107069 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80107050:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80107051:	83 ec 0c             	sub    $0xc,%esp
80107054:	ff 75 f4             	pushl  -0xc(%ebp)
80107057:	e8 78 ac ff ff       	call   80101cd4 <iunlockput>
8010705c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010705f:	e8 1f c6 ff ff       	call   80103683 <end_op>
  return -1;
80107064:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107069:	c9                   	leave  
8010706a:	c3                   	ret    

8010706b <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010706b:	55                   	push   %ebp
8010706c:	89 e5                	mov    %esp,%ebp
8010706e:	83 ec 38             	sub    $0x38,%esp
80107071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107074:	8b 55 10             	mov    0x10(%ebp),%edx
80107077:	8b 45 14             	mov    0x14(%ebp),%eax
8010707a:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010707e:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80107082:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80107086:	83 ec 08             	sub    $0x8,%esp
80107089:	8d 45 de             	lea    -0x22(%ebp),%eax
8010708c:	50                   	push   %eax
8010708d:	ff 75 08             	pushl  0x8(%ebp)
80107090:	e8 59 b5 ff ff       	call   801025ee <nameiparent>
80107095:	83 c4 10             	add    $0x10,%esp
80107098:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010709b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010709f:	75 0a                	jne    801070ab <create+0x40>
    return 0;
801070a1:	b8 00 00 00 00       	mov    $0x0,%eax
801070a6:	e9 90 01 00 00       	jmp    8010723b <create+0x1d0>
  ilock(dp);
801070ab:	83 ec 0c             	sub    $0xc,%esp
801070ae:	ff 75 f4             	pushl  -0xc(%ebp)
801070b1:	e8 5e a9 ff ff       	call   80101a14 <ilock>
801070b6:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801070b9:	83 ec 04             	sub    $0x4,%esp
801070bc:	8d 45 ec             	lea    -0x14(%ebp),%eax
801070bf:	50                   	push   %eax
801070c0:	8d 45 de             	lea    -0x22(%ebp),%eax
801070c3:	50                   	push   %eax
801070c4:	ff 75 f4             	pushl  -0xc(%ebp)
801070c7:	e8 b0 b1 ff ff       	call   8010227c <dirlookup>
801070cc:	83 c4 10             	add    $0x10,%esp
801070cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801070d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801070d6:	74 50                	je     80107128 <create+0xbd>
    iunlockput(dp);
801070d8:	83 ec 0c             	sub    $0xc,%esp
801070db:	ff 75 f4             	pushl  -0xc(%ebp)
801070de:	e8 f1 ab ff ff       	call   80101cd4 <iunlockput>
801070e3:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801070e6:	83 ec 0c             	sub    $0xc,%esp
801070e9:	ff 75 f0             	pushl  -0x10(%ebp)
801070ec:	e8 23 a9 ff ff       	call   80101a14 <ilock>
801070f1:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801070f4:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801070f9:	75 15                	jne    80107110 <create+0xa5>
801070fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070fe:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107102:	66 83 f8 02          	cmp    $0x2,%ax
80107106:	75 08                	jne    80107110 <create+0xa5>
      return ip;
80107108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010710b:	e9 2b 01 00 00       	jmp    8010723b <create+0x1d0>
    iunlockput(ip);
80107110:	83 ec 0c             	sub    $0xc,%esp
80107113:	ff 75 f0             	pushl  -0x10(%ebp)
80107116:	e8 b9 ab ff ff       	call   80101cd4 <iunlockput>
8010711b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010711e:	b8 00 00 00 00       	mov    $0x0,%eax
80107123:	e9 13 01 00 00       	jmp    8010723b <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80107128:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010712c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010712f:	8b 00                	mov    (%eax),%eax
80107131:	83 ec 08             	sub    $0x8,%esp
80107134:	52                   	push   %edx
80107135:	50                   	push   %eax
80107136:	e8 28 a6 ff ff       	call   80101763 <ialloc>
8010713b:	83 c4 10             	add    $0x10,%esp
8010713e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107141:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107145:	75 0d                	jne    80107154 <create+0xe9>
    panic("create: ialloc");
80107147:	83 ec 0c             	sub    $0xc,%esp
8010714a:	68 2a a0 10 80       	push   $0x8010a02a
8010714f:	e8 12 94 ff ff       	call   80100566 <panic>

  ilock(ip);
80107154:	83 ec 0c             	sub    $0xc,%esp
80107157:	ff 75 f0             	pushl  -0x10(%ebp)
8010715a:	e8 b5 a8 ff ff       	call   80101a14 <ilock>
8010715f:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107162:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107165:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80107169:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010716d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107170:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107174:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107178:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010717b:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80107181:	83 ec 0c             	sub    $0xc,%esp
80107184:	ff 75 f0             	pushl  -0x10(%ebp)
80107187:	e8 ae a6 ff ff       	call   8010183a <iupdate>
8010718c:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010718f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80107194:	75 6a                	jne    80107200 <create+0x195>
    dp->nlink++;  // for ".."
80107196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107199:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010719d:	83 c0 01             	add    $0x1,%eax
801071a0:	89 c2                	mov    %eax,%edx
801071a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071a5:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801071a9:	83 ec 0c             	sub    $0xc,%esp
801071ac:	ff 75 f4             	pushl  -0xc(%ebp)
801071af:	e8 86 a6 ff ff       	call   8010183a <iupdate>
801071b4:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801071b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071ba:	8b 40 04             	mov    0x4(%eax),%eax
801071bd:	83 ec 04             	sub    $0x4,%esp
801071c0:	50                   	push   %eax
801071c1:	68 04 a0 10 80       	push   $0x8010a004
801071c6:	ff 75 f0             	pushl  -0x10(%ebp)
801071c9:	e8 68 b1 ff ff       	call   80102336 <dirlink>
801071ce:	83 c4 10             	add    $0x10,%esp
801071d1:	85 c0                	test   %eax,%eax
801071d3:	78 1e                	js     801071f3 <create+0x188>
801071d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d8:	8b 40 04             	mov    0x4(%eax),%eax
801071db:	83 ec 04             	sub    $0x4,%esp
801071de:	50                   	push   %eax
801071df:	68 06 a0 10 80       	push   $0x8010a006
801071e4:	ff 75 f0             	pushl  -0x10(%ebp)
801071e7:	e8 4a b1 ff ff       	call   80102336 <dirlink>
801071ec:	83 c4 10             	add    $0x10,%esp
801071ef:	85 c0                	test   %eax,%eax
801071f1:	79 0d                	jns    80107200 <create+0x195>
      panic("create dots");
801071f3:	83 ec 0c             	sub    $0xc,%esp
801071f6:	68 39 a0 10 80       	push   $0x8010a039
801071fb:	e8 66 93 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80107200:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107203:	8b 40 04             	mov    0x4(%eax),%eax
80107206:	83 ec 04             	sub    $0x4,%esp
80107209:	50                   	push   %eax
8010720a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010720d:	50                   	push   %eax
8010720e:	ff 75 f4             	pushl  -0xc(%ebp)
80107211:	e8 20 b1 ff ff       	call   80102336 <dirlink>
80107216:	83 c4 10             	add    $0x10,%esp
80107219:	85 c0                	test   %eax,%eax
8010721b:	79 0d                	jns    8010722a <create+0x1bf>
    panic("create: dirlink");
8010721d:	83 ec 0c             	sub    $0xc,%esp
80107220:	68 45 a0 10 80       	push   $0x8010a045
80107225:	e8 3c 93 ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010722a:	83 ec 0c             	sub    $0xc,%esp
8010722d:	ff 75 f4             	pushl  -0xc(%ebp)
80107230:	e8 9f aa ff ff       	call   80101cd4 <iunlockput>
80107235:	83 c4 10             	add    $0x10,%esp

  return ip;
80107238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010723b:	c9                   	leave  
8010723c:	c3                   	ret    

8010723d <sys_open>:

int
sys_open(void)
{
8010723d:	55                   	push   %ebp
8010723e:	89 e5                	mov    %esp,%ebp
80107240:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107243:	83 ec 08             	sub    $0x8,%esp
80107246:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107249:	50                   	push   %eax
8010724a:	6a 00                	push   $0x0
8010724c:	e8 eb f6 ff ff       	call   8010693c <argstr>
80107251:	83 c4 10             	add    $0x10,%esp
80107254:	85 c0                	test   %eax,%eax
80107256:	78 15                	js     8010726d <sys_open+0x30>
80107258:	83 ec 08             	sub    $0x8,%esp
8010725b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010725e:	50                   	push   %eax
8010725f:	6a 01                	push   $0x1
80107261:	e8 51 f6 ff ff       	call   801068b7 <argint>
80107266:	83 c4 10             	add    $0x10,%esp
80107269:	85 c0                	test   %eax,%eax
8010726b:	79 0a                	jns    80107277 <sys_open+0x3a>
    return -1;
8010726d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107272:	e9 61 01 00 00       	jmp    801073d8 <sys_open+0x19b>

  begin_op();
80107277:	e8 7b c3 ff ff       	call   801035f7 <begin_op>

  if(omode & O_CREATE){
8010727c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010727f:	25 00 02 00 00       	and    $0x200,%eax
80107284:	85 c0                	test   %eax,%eax
80107286:	74 2a                	je     801072b2 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80107288:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010728b:	6a 00                	push   $0x0
8010728d:	6a 00                	push   $0x0
8010728f:	6a 02                	push   $0x2
80107291:	50                   	push   %eax
80107292:	e8 d4 fd ff ff       	call   8010706b <create>
80107297:	83 c4 10             	add    $0x10,%esp
8010729a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010729d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072a1:	75 75                	jne    80107318 <sys_open+0xdb>
      end_op();
801072a3:	e8 db c3 ff ff       	call   80103683 <end_op>
      return -1;
801072a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072ad:	e9 26 01 00 00       	jmp    801073d8 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801072b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801072b5:	83 ec 0c             	sub    $0xc,%esp
801072b8:	50                   	push   %eax
801072b9:	e8 14 b3 ff ff       	call   801025d2 <namei>
801072be:	83 c4 10             	add    $0x10,%esp
801072c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801072c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072c8:	75 0f                	jne    801072d9 <sys_open+0x9c>
      end_op();
801072ca:	e8 b4 c3 ff ff       	call   80103683 <end_op>
      return -1;
801072cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072d4:	e9 ff 00 00 00       	jmp    801073d8 <sys_open+0x19b>
    }
    ilock(ip);
801072d9:	83 ec 0c             	sub    $0xc,%esp
801072dc:	ff 75 f4             	pushl  -0xc(%ebp)
801072df:	e8 30 a7 ff ff       	call   80101a14 <ilock>
801072e4:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801072e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ea:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801072ee:	66 83 f8 01          	cmp    $0x1,%ax
801072f2:	75 24                	jne    80107318 <sys_open+0xdb>
801072f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072f7:	85 c0                	test   %eax,%eax
801072f9:	74 1d                	je     80107318 <sys_open+0xdb>
      iunlockput(ip);
801072fb:	83 ec 0c             	sub    $0xc,%esp
801072fe:	ff 75 f4             	pushl  -0xc(%ebp)
80107301:	e8 ce a9 ff ff       	call   80101cd4 <iunlockput>
80107306:	83 c4 10             	add    $0x10,%esp
      end_op();
80107309:	e8 75 c3 ff ff       	call   80103683 <end_op>
      return -1;
8010730e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107313:	e9 c0 00 00 00       	jmp    801073d8 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80107318:	e8 20 9d ff ff       	call   8010103d <filealloc>
8010731d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107320:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107324:	74 17                	je     8010733d <sys_open+0x100>
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	ff 75 f0             	pushl  -0x10(%ebp)
8010732c:	e8 37 f7 ff ff       	call   80106a68 <fdalloc>
80107331:	83 c4 10             	add    $0x10,%esp
80107334:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107337:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010733b:	79 2e                	jns    8010736b <sys_open+0x12e>
    if(f)
8010733d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107341:	74 0e                	je     80107351 <sys_open+0x114>
      fileclose(f);
80107343:	83 ec 0c             	sub    $0xc,%esp
80107346:	ff 75 f0             	pushl  -0x10(%ebp)
80107349:	e8 ad 9d ff ff       	call   801010fb <fileclose>
8010734e:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107351:	83 ec 0c             	sub    $0xc,%esp
80107354:	ff 75 f4             	pushl  -0xc(%ebp)
80107357:	e8 78 a9 ff ff       	call   80101cd4 <iunlockput>
8010735c:	83 c4 10             	add    $0x10,%esp
    end_op();
8010735f:	e8 1f c3 ff ff       	call   80103683 <end_op>
    return -1;
80107364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107369:	eb 6d                	jmp    801073d8 <sys_open+0x19b>
  }
  iunlock(ip);
8010736b:	83 ec 0c             	sub    $0xc,%esp
8010736e:	ff 75 f4             	pushl  -0xc(%ebp)
80107371:	e8 fc a7 ff ff       	call   80101b72 <iunlock>
80107376:	83 c4 10             	add    $0x10,%esp
  end_op();
80107379:	e8 05 c3 ff ff       	call   80103683 <end_op>

  f->type = FD_INODE;
8010737e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107381:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80107387:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010738a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010738d:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107390:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107393:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010739a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010739d:	83 e0 01             	and    $0x1,%eax
801073a0:	85 c0                	test   %eax,%eax
801073a2:	0f 94 c0             	sete   %al
801073a5:	89 c2                	mov    %eax,%edx
801073a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073aa:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801073ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073b0:	83 e0 01             	and    $0x1,%eax
801073b3:	85 c0                	test   %eax,%eax
801073b5:	75 0a                	jne    801073c1 <sys_open+0x184>
801073b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073ba:	83 e0 02             	and    $0x2,%eax
801073bd:	85 c0                	test   %eax,%eax
801073bf:	74 07                	je     801073c8 <sys_open+0x18b>
801073c1:	b8 01 00 00 00       	mov    $0x1,%eax
801073c6:	eb 05                	jmp    801073cd <sys_open+0x190>
801073c8:	b8 00 00 00 00       	mov    $0x0,%eax
801073cd:	89 c2                	mov    %eax,%edx
801073cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073d2:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801073d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801073d8:	c9                   	leave  
801073d9:	c3                   	ret    

801073da <sys_mkdir>:

int
sys_mkdir(void)
{
801073da:	55                   	push   %ebp
801073db:	89 e5                	mov    %esp,%ebp
801073dd:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801073e0:	e8 12 c2 ff ff       	call   801035f7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801073e5:	83 ec 08             	sub    $0x8,%esp
801073e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801073eb:	50                   	push   %eax
801073ec:	6a 00                	push   $0x0
801073ee:	e8 49 f5 ff ff       	call   8010693c <argstr>
801073f3:	83 c4 10             	add    $0x10,%esp
801073f6:	85 c0                	test   %eax,%eax
801073f8:	78 1b                	js     80107415 <sys_mkdir+0x3b>
801073fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073fd:	6a 00                	push   $0x0
801073ff:	6a 00                	push   $0x0
80107401:	6a 01                	push   $0x1
80107403:	50                   	push   %eax
80107404:	e8 62 fc ff ff       	call   8010706b <create>
80107409:	83 c4 10             	add    $0x10,%esp
8010740c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010740f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107413:	75 0c                	jne    80107421 <sys_mkdir+0x47>
    end_op();
80107415:	e8 69 c2 ff ff       	call   80103683 <end_op>
    return -1;
8010741a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010741f:	eb 18                	jmp    80107439 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107421:	83 ec 0c             	sub    $0xc,%esp
80107424:	ff 75 f4             	pushl  -0xc(%ebp)
80107427:	e8 a8 a8 ff ff       	call   80101cd4 <iunlockput>
8010742c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010742f:	e8 4f c2 ff ff       	call   80103683 <end_op>
  return 0;
80107434:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107439:	c9                   	leave  
8010743a:	c3                   	ret    

8010743b <sys_mknod>:

int
sys_mknod(void)
{
8010743b:	55                   	push   %ebp
8010743c:	89 e5                	mov    %esp,%ebp
8010743e:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107441:	e8 b1 c1 ff ff       	call   801035f7 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107446:	83 ec 08             	sub    $0x8,%esp
80107449:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010744c:	50                   	push   %eax
8010744d:	6a 00                	push   $0x0
8010744f:	e8 e8 f4 ff ff       	call   8010693c <argstr>
80107454:	83 c4 10             	add    $0x10,%esp
80107457:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010745a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010745e:	78 4f                	js     801074af <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107460:	83 ec 08             	sub    $0x8,%esp
80107463:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107466:	50                   	push   %eax
80107467:	6a 01                	push   $0x1
80107469:	e8 49 f4 ff ff       	call   801068b7 <argint>
8010746e:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107471:	85 c0                	test   %eax,%eax
80107473:	78 3a                	js     801074af <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107475:	83 ec 08             	sub    $0x8,%esp
80107478:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010747b:	50                   	push   %eax
8010747c:	6a 02                	push   $0x2
8010747e:	e8 34 f4 ff ff       	call   801068b7 <argint>
80107483:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107486:	85 c0                	test   %eax,%eax
80107488:	78 25                	js     801074af <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010748a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010748d:	0f bf c8             	movswl %ax,%ecx
80107490:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107493:	0f bf d0             	movswl %ax,%edx
80107496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107499:	51                   	push   %ecx
8010749a:	52                   	push   %edx
8010749b:	6a 03                	push   $0x3
8010749d:	50                   	push   %eax
8010749e:	e8 c8 fb ff ff       	call   8010706b <create>
801074a3:	83 c4 10             	add    $0x10,%esp
801074a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801074a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801074ad:	75 0c                	jne    801074bb <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801074af:	e8 cf c1 ff ff       	call   80103683 <end_op>
    return -1;
801074b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074b9:	eb 18                	jmp    801074d3 <sys_mknod+0x98>
  }
  iunlockput(ip);
801074bb:	83 ec 0c             	sub    $0xc,%esp
801074be:	ff 75 f0             	pushl  -0x10(%ebp)
801074c1:	e8 0e a8 ff ff       	call   80101cd4 <iunlockput>
801074c6:	83 c4 10             	add    $0x10,%esp
  end_op();
801074c9:	e8 b5 c1 ff ff       	call   80103683 <end_op>
  return 0;
801074ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801074d3:	c9                   	leave  
801074d4:	c3                   	ret    

801074d5 <sys_chdir>:

int
sys_chdir(void)
{
801074d5:	55                   	push   %ebp
801074d6:	89 e5                	mov    %esp,%ebp
801074d8:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801074db:	e8 17 c1 ff ff       	call   801035f7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801074e0:	83 ec 08             	sub    $0x8,%esp
801074e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801074e6:	50                   	push   %eax
801074e7:	6a 00                	push   $0x0
801074e9:	e8 4e f4 ff ff       	call   8010693c <argstr>
801074ee:	83 c4 10             	add    $0x10,%esp
801074f1:	85 c0                	test   %eax,%eax
801074f3:	78 18                	js     8010750d <sys_chdir+0x38>
801074f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074f8:	83 ec 0c             	sub    $0xc,%esp
801074fb:	50                   	push   %eax
801074fc:	e8 d1 b0 ff ff       	call   801025d2 <namei>
80107501:	83 c4 10             	add    $0x10,%esp
80107504:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107507:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010750b:	75 0c                	jne    80107519 <sys_chdir+0x44>
    end_op();
8010750d:	e8 71 c1 ff ff       	call   80103683 <end_op>
    return -1;
80107512:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107517:	eb 6e                	jmp    80107587 <sys_chdir+0xb2>
  }
  ilock(ip);
80107519:	83 ec 0c             	sub    $0xc,%esp
8010751c:	ff 75 f4             	pushl  -0xc(%ebp)
8010751f:	e8 f0 a4 ff ff       	call   80101a14 <ilock>
80107524:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010752e:	66 83 f8 01          	cmp    $0x1,%ax
80107532:	74 1a                	je     8010754e <sys_chdir+0x79>
    iunlockput(ip);
80107534:	83 ec 0c             	sub    $0xc,%esp
80107537:	ff 75 f4             	pushl  -0xc(%ebp)
8010753a:	e8 95 a7 ff ff       	call   80101cd4 <iunlockput>
8010753f:	83 c4 10             	add    $0x10,%esp
    end_op();
80107542:	e8 3c c1 ff ff       	call   80103683 <end_op>
    return -1;
80107547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010754c:	eb 39                	jmp    80107587 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010754e:	83 ec 0c             	sub    $0xc,%esp
80107551:	ff 75 f4             	pushl  -0xc(%ebp)
80107554:	e8 19 a6 ff ff       	call   80101b72 <iunlock>
80107559:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010755c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107562:	8b 40 68             	mov    0x68(%eax),%eax
80107565:	83 ec 0c             	sub    $0xc,%esp
80107568:	50                   	push   %eax
80107569:	e8 76 a6 ff ff       	call   80101be4 <iput>
8010756e:	83 c4 10             	add    $0x10,%esp
  end_op();
80107571:	e8 0d c1 ff ff       	call   80103683 <end_op>
  proc->cwd = ip;
80107576:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010757c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010757f:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107582:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107587:	c9                   	leave  
80107588:	c3                   	ret    

80107589 <sys_exec>:

int
sys_exec(void)
{
80107589:	55                   	push   %ebp
8010758a:	89 e5                	mov    %esp,%ebp
8010758c:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107592:	83 ec 08             	sub    $0x8,%esp
80107595:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107598:	50                   	push   %eax
80107599:	6a 00                	push   $0x0
8010759b:	e8 9c f3 ff ff       	call   8010693c <argstr>
801075a0:	83 c4 10             	add    $0x10,%esp
801075a3:	85 c0                	test   %eax,%eax
801075a5:	78 18                	js     801075bf <sys_exec+0x36>
801075a7:	83 ec 08             	sub    $0x8,%esp
801075aa:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801075b0:	50                   	push   %eax
801075b1:	6a 01                	push   $0x1
801075b3:	e8 ff f2 ff ff       	call   801068b7 <argint>
801075b8:	83 c4 10             	add    $0x10,%esp
801075bb:	85 c0                	test   %eax,%eax
801075bd:	79 0a                	jns    801075c9 <sys_exec+0x40>
    return -1;
801075bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075c4:	e9 c6 00 00 00       	jmp    8010768f <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801075c9:	83 ec 04             	sub    $0x4,%esp
801075cc:	68 80 00 00 00       	push   $0x80
801075d1:	6a 00                	push   $0x0
801075d3:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801075d9:	50                   	push   %eax
801075da:	e8 b3 ef ff ff       	call   80106592 <memset>
801075df:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801075e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801075e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ec:	83 f8 1f             	cmp    $0x1f,%eax
801075ef:	76 0a                	jbe    801075fb <sys_exec+0x72>
      return -1;
801075f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075f6:	e9 94 00 00 00       	jmp    8010768f <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801075fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fe:	c1 e0 02             	shl    $0x2,%eax
80107601:	89 c2                	mov    %eax,%edx
80107603:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107609:	01 c2                	add    %eax,%edx
8010760b:	83 ec 08             	sub    $0x8,%esp
8010760e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107614:	50                   	push   %eax
80107615:	52                   	push   %edx
80107616:	e8 00 f2 ff ff       	call   8010681b <fetchint>
8010761b:	83 c4 10             	add    $0x10,%esp
8010761e:	85 c0                	test   %eax,%eax
80107620:	79 07                	jns    80107629 <sys_exec+0xa0>
      return -1;
80107622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107627:	eb 66                	jmp    8010768f <sys_exec+0x106>
    if(uarg == 0){
80107629:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010762f:	85 c0                	test   %eax,%eax
80107631:	75 27                	jne    8010765a <sys_exec+0xd1>
      argv[i] = 0;
80107633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107636:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010763d:	00 00 00 00 
      break;
80107641:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107642:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107645:	83 ec 08             	sub    $0x8,%esp
80107648:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010764e:	52                   	push   %edx
8010764f:	50                   	push   %eax
80107650:	e8 c6 95 ff ff       	call   80100c1b <exec>
80107655:	83 c4 10             	add    $0x10,%esp
80107658:	eb 35                	jmp    8010768f <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010765a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107660:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107663:	c1 e2 02             	shl    $0x2,%edx
80107666:	01 c2                	add    %eax,%edx
80107668:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010766e:	83 ec 08             	sub    $0x8,%esp
80107671:	52                   	push   %edx
80107672:	50                   	push   %eax
80107673:	e8 dd f1 ff ff       	call   80106855 <fetchstr>
80107678:	83 c4 10             	add    $0x10,%esp
8010767b:	85 c0                	test   %eax,%eax
8010767d:	79 07                	jns    80107686 <sys_exec+0xfd>
      return -1;
8010767f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107684:	eb 09                	jmp    8010768f <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107686:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010768a:	e9 5a ff ff ff       	jmp    801075e9 <sys_exec+0x60>
  return exec(path, argv);
}
8010768f:	c9                   	leave  
80107690:	c3                   	ret    

80107691 <sys_pipe>:

int
sys_pipe(void)
{
80107691:	55                   	push   %ebp
80107692:	89 e5                	mov    %esp,%ebp
80107694:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107697:	83 ec 04             	sub    $0x4,%esp
8010769a:	6a 08                	push   $0x8
8010769c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010769f:	50                   	push   %eax
801076a0:	6a 00                	push   $0x0
801076a2:	e8 38 f2 ff ff       	call   801068df <argptr>
801076a7:	83 c4 10             	add    $0x10,%esp
801076aa:	85 c0                	test   %eax,%eax
801076ac:	79 0a                	jns    801076b8 <sys_pipe+0x27>
    return -1;
801076ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076b3:	e9 af 00 00 00       	jmp    80107767 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801076b8:	83 ec 08             	sub    $0x8,%esp
801076bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801076be:	50                   	push   %eax
801076bf:	8d 45 e8             	lea    -0x18(%ebp),%eax
801076c2:	50                   	push   %eax
801076c3:	e8 23 ca ff ff       	call   801040eb <pipealloc>
801076c8:	83 c4 10             	add    $0x10,%esp
801076cb:	85 c0                	test   %eax,%eax
801076cd:	79 0a                	jns    801076d9 <sys_pipe+0x48>
    return -1;
801076cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076d4:	e9 8e 00 00 00       	jmp    80107767 <sys_pipe+0xd6>
  fd0 = -1;
801076d9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801076e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801076e3:	83 ec 0c             	sub    $0xc,%esp
801076e6:	50                   	push   %eax
801076e7:	e8 7c f3 ff ff       	call   80106a68 <fdalloc>
801076ec:	83 c4 10             	add    $0x10,%esp
801076ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801076f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801076f6:	78 18                	js     80107710 <sys_pipe+0x7f>
801076f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076fb:	83 ec 0c             	sub    $0xc,%esp
801076fe:	50                   	push   %eax
801076ff:	e8 64 f3 ff ff       	call   80106a68 <fdalloc>
80107704:	83 c4 10             	add    $0x10,%esp
80107707:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010770a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010770e:	79 3f                	jns    8010774f <sys_pipe+0xbe>
    if(fd0 >= 0)
80107710:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107714:	78 14                	js     8010772a <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107716:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010771c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010771f:	83 c2 08             	add    $0x8,%edx
80107722:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107729:	00 
    fileclose(rf);
8010772a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010772d:	83 ec 0c             	sub    $0xc,%esp
80107730:	50                   	push   %eax
80107731:	e8 c5 99 ff ff       	call   801010fb <fileclose>
80107736:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010773c:	83 ec 0c             	sub    $0xc,%esp
8010773f:	50                   	push   %eax
80107740:	e8 b6 99 ff ff       	call   801010fb <fileclose>
80107745:	83 c4 10             	add    $0x10,%esp
    return -1;
80107748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010774d:	eb 18                	jmp    80107767 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
8010774f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107752:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107755:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107757:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010775a:	8d 50 04             	lea    0x4(%eax),%edx
8010775d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107760:	89 02                	mov    %eax,(%edx)
  return 0;
80107762:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107767:	c9                   	leave  
80107768:	c3                   	ret    

80107769 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107769:	55                   	push   %ebp
8010776a:	89 e5                	mov    %esp,%ebp
8010776c:	83 ec 08             	sub    $0x8,%esp
8010776f:	8b 55 08             	mov    0x8(%ebp),%edx
80107772:	8b 45 0c             	mov    0xc(%ebp),%eax
80107775:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107779:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010777d:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107781:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107785:	66 ef                	out    %ax,(%dx)
}
80107787:	90                   	nop
80107788:	c9                   	leave  
80107789:	c3                   	ret    

8010778a <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
8010778a:	55                   	push   %ebp
8010778b:	89 e5                	mov    %esp,%ebp
8010778d:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107790:	e8 35 d2 ff ff       	call   801049ca <fork>
}
80107795:	c9                   	leave  
80107796:	c3                   	ret    

80107797 <sys_exit>:

int
sys_exit(void)
{
80107797:	55                   	push   %ebp
80107798:	89 e5                	mov    %esp,%ebp
8010779a:	83 ec 08             	sub    $0x8,%esp
  exit();
8010779d:	e8 9e d4 ff ff       	call   80104c40 <exit>
  return 0;  // not reached
801077a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801077a7:	c9                   	leave  
801077a8:	c3                   	ret    

801077a9 <sys_wait>:

int
sys_wait(void)
{
801077a9:	55                   	push   %ebp
801077aa:	89 e5                	mov    %esp,%ebp
801077ac:	83 ec 08             	sub    $0x8,%esp
  return wait();
801077af:	e8 65 d6 ff ff       	call   80104e19 <wait>
}
801077b4:	c9                   	leave  
801077b5:	c3                   	ret    

801077b6 <sys_kill>:

int
sys_kill(void)
{
801077b6:	55                   	push   %ebp
801077b7:	89 e5                	mov    %esp,%ebp
801077b9:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801077bc:	83 ec 08             	sub    $0x8,%esp
801077bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801077c2:	50                   	push   %eax
801077c3:	6a 00                	push   $0x0
801077c5:	e8 ed f0 ff ff       	call   801068b7 <argint>
801077ca:	83 c4 10             	add    $0x10,%esp
801077cd:	85 c0                	test   %eax,%eax
801077cf:	79 07                	jns    801077d8 <sys_kill+0x22>
    return -1;
801077d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077d6:	eb 0f                	jmp    801077e7 <sys_kill+0x31>
  return kill(pid);
801077d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077db:	83 ec 0c             	sub    $0xc,%esp
801077de:	50                   	push   %eax
801077df:	e8 9a dc ff ff       	call   8010547e <kill>
801077e4:	83 c4 10             	add    $0x10,%esp
}
801077e7:	c9                   	leave  
801077e8:	c3                   	ret    

801077e9 <sys_getpid>:

int
sys_getpid(void)
{
801077e9:	55                   	push   %ebp
801077ea:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801077ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077f2:	8b 40 10             	mov    0x10(%eax),%eax
}
801077f5:	5d                   	pop    %ebp
801077f6:	c3                   	ret    

801077f7 <sys_sbrk>:

int
sys_sbrk(void)
{
801077f7:	55                   	push   %ebp
801077f8:	89 e5                	mov    %esp,%ebp
801077fa:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801077fd:	83 ec 08             	sub    $0x8,%esp
80107800:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107803:	50                   	push   %eax
80107804:	6a 00                	push   $0x0
80107806:	e8 ac f0 ff ff       	call   801068b7 <argint>
8010780b:	83 c4 10             	add    $0x10,%esp
8010780e:	85 c0                	test   %eax,%eax
80107810:	79 07                	jns    80107819 <sys_sbrk+0x22>
    return -1;
80107812:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107817:	eb 28                	jmp    80107841 <sys_sbrk+0x4a>
  addr = proc->sz;
80107819:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010781f:	8b 00                	mov    (%eax),%eax
80107821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107827:	83 ec 0c             	sub    $0xc,%esp
8010782a:	50                   	push   %eax
8010782b:	e8 f7 d0 ff ff       	call   80104927 <growproc>
80107830:	83 c4 10             	add    $0x10,%esp
80107833:	85 c0                	test   %eax,%eax
80107835:	79 07                	jns    8010783e <sys_sbrk+0x47>
    return -1;
80107837:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010783c:	eb 03                	jmp    80107841 <sys_sbrk+0x4a>
  return addr;
8010783e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107841:	c9                   	leave  
80107842:	c3                   	ret    

80107843 <sys_sleep>:

int
sys_sleep(void)
{
80107843:	55                   	push   %ebp
80107844:	89 e5                	mov    %esp,%ebp
80107846:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107849:	83 ec 08             	sub    $0x8,%esp
8010784c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010784f:	50                   	push   %eax
80107850:	6a 00                	push   $0x0
80107852:	e8 60 f0 ff ff       	call   801068b7 <argint>
80107857:	83 c4 10             	add    $0x10,%esp
8010785a:	85 c0                	test   %eax,%eax
8010785c:	79 07                	jns    80107865 <sys_sleep+0x22>
    return -1;
8010785e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107863:	eb 44                	jmp    801078a9 <sys_sleep+0x66>
  ticks0 = ticks;
80107865:	a1 00 78 11 80       	mov    0x80117800,%eax
8010786a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010786d:	eb 26                	jmp    80107895 <sys_sleep+0x52>
    if(proc->killed){
8010786f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107875:	8b 40 24             	mov    0x24(%eax),%eax
80107878:	85 c0                	test   %eax,%eax
8010787a:	74 07                	je     80107883 <sys_sleep+0x40>
      return -1;
8010787c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107881:	eb 26                	jmp    801078a9 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107883:	83 ec 08             	sub    $0x8,%esp
80107886:	6a 00                	push   $0x0
80107888:	68 00 78 11 80       	push   $0x80117800
8010788d:	e8 5f da ff ff       	call   801052f1 <sleep>
80107892:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107895:	a1 00 78 11 80       	mov    0x80117800,%eax
8010789a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010789d:	8b 55 f0             	mov    -0x10(%ebp),%edx
801078a0:	39 d0                	cmp    %edx,%eax
801078a2:	72 cb                	jb     8010786f <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
801078a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801078a9:	c9                   	leave  
801078aa:	c3                   	ret    

801078ab <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
801078ab:	55                   	push   %ebp
801078ac:	89 e5                	mov    %esp,%ebp
801078ae:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
801078b1:	a1 00 78 11 80       	mov    0x80117800,%eax
801078b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
801078b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801078bc:	c9                   	leave  
801078bd:	c3                   	ret    

801078be <sys_halt>:

//Turn of the computer
int sys_halt(void){
801078be:	55                   	push   %ebp
801078bf:	89 e5                	mov    %esp,%ebp
801078c1:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
801078c4:	83 ec 0c             	sub    $0xc,%esp
801078c7:	68 55 a0 10 80       	push   $0x8010a055
801078cc:	e8 f5 8a ff ff       	call   801003c6 <cprintf>
801078d1:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
801078d4:	83 ec 08             	sub    $0x8,%esp
801078d7:	68 00 20 00 00       	push   $0x2000
801078dc:	68 04 06 00 00       	push   $0x604
801078e1:	e8 83 fe ff ff       	call   80107769 <outw>
801078e6:	83 c4 10             	add    $0x10,%esp
  return 0;
801078e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801078ee:	c9                   	leave  
801078ef:	c3                   	ret    

801078f0 <sys_date>:

// My implementation of sys_date()
int
sys_date(void)
{
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if (argptr(0, (void*)&d, sizeof(*d)) < 0)
801078f6:	83 ec 04             	sub    $0x4,%esp
801078f9:	6a 18                	push   $0x18
801078fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801078fe:	50                   	push   %eax
801078ff:	6a 00                	push   $0x0
80107901:	e8 d9 ef ff ff       	call   801068df <argptr>
80107906:	83 c4 10             	add    $0x10,%esp
80107909:	85 c0                	test   %eax,%eax
8010790b:	79 07                	jns    80107914 <sys_date+0x24>
    return -1;
8010790d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107912:	eb 14                	jmp    80107928 <sys_date+0x38>
  // MY CODE HERE
  cmostime(d);       
80107914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107917:	83 ec 0c             	sub    $0xc,%esp
8010791a:	50                   	push   %eax
8010791b:	e8 52 b9 ff ff       	call   80103272 <cmostime>
80107920:	83 c4 10             	add    $0x10,%esp
  return 0; 
80107923:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107928:	c9                   	leave  
80107929:	c3                   	ret    

8010792a <sys_getuid>:

// My implementation of sys_getuid
uint
sys_getuid(void)
{
8010792a:	55                   	push   %ebp
8010792b:	89 e5                	mov    %esp,%ebp
  return proc->uid;
8010792d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107933:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107939:	5d                   	pop    %ebp
8010793a:	c3                   	ret    

8010793b <sys_getgid>:

// My implementation of sys_getgid
uint
sys_getgid(void)
{
8010793b:	55                   	push   %ebp
8010793c:	89 e5                	mov    %esp,%ebp
  return proc->gid;
8010793e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107944:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
8010794a:	5d                   	pop    %ebp
8010794b:	c3                   	ret    

8010794c <sys_getppid>:

// My implementation of sys_getppid
uint
sys_getppid(void)
{
8010794c:	55                   	push   %ebp
8010794d:	89 e5                	mov    %esp,%ebp
  return proc->parent ? proc->parent->pid : proc->pid;
8010794f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107955:	8b 40 14             	mov    0x14(%eax),%eax
80107958:	85 c0                	test   %eax,%eax
8010795a:	74 0e                	je     8010796a <sys_getppid+0x1e>
8010795c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107962:	8b 40 14             	mov    0x14(%eax),%eax
80107965:	8b 40 10             	mov    0x10(%eax),%eax
80107968:	eb 09                	jmp    80107973 <sys_getppid+0x27>
8010796a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107970:	8b 40 10             	mov    0x10(%eax),%eax
}
80107973:	5d                   	pop    %ebp
80107974:	c3                   	ret    

80107975 <sys_setuid>:


// Implementation of sys_setuid
int 
sys_setuid(void)
{
80107975:	55                   	push   %ebp
80107976:	89 e5                	mov    %esp,%ebp
80107978:	83 ec 18             	sub    $0x18,%esp
  int id; // uid argument
  // Grab argument off the stack and store in id
  argint(0, &id);
8010797b:	83 ec 08             	sub    $0x8,%esp
8010797e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107981:	50                   	push   %eax
80107982:	6a 00                	push   $0x0
80107984:	e8 2e ef ff ff       	call   801068b7 <argint>
80107989:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
8010798c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798f:	85 c0                	test   %eax,%eax
80107991:	78 0a                	js     8010799d <sys_setuid+0x28>
80107993:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107996:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010799b:	7e 07                	jle    801079a4 <sys_setuid+0x2f>
    return -1;
8010799d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079a2:	eb 14                	jmp    801079b8 <sys_setuid+0x43>
  proc->uid = id; 
801079a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801079aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801079ad:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
801079b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079b8:	c9                   	leave  
801079b9:	c3                   	ret    

801079ba <sys_setgid>:

// Implementation of sys_setgid
int
sys_setgid(void)
{
801079ba:	55                   	push   %ebp
801079bb:	89 e5                	mov    %esp,%ebp
801079bd:	83 ec 18             	sub    $0x18,%esp
  int id; // gid argument 
  // Grab argument off the stack and store in id
  argint(0, &id);
801079c0:	83 ec 08             	sub    $0x8,%esp
801079c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801079c6:	50                   	push   %eax
801079c7:	6a 00                	push   $0x0
801079c9:	e8 e9 ee ff ff       	call   801068b7 <argint>
801079ce:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
801079d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d4:	85 c0                	test   %eax,%eax
801079d6:	78 0a                	js     801079e2 <sys_setgid+0x28>
801079d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079db:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801079e0:	7e 07                	jle    801079e9 <sys_setgid+0x2f>
    return -1;
801079e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079e7:	eb 14                	jmp    801079fd <sys_setgid+0x43>
  proc->gid = id;
801079e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801079ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
801079f2:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  return 0;
801079f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079fd:	c9                   	leave  
801079fe:	c3                   	ret    

801079ff <sys_getprocs>:

// Implementation of sys_getprocs
int
sys_getprocs(void)
{
801079ff:	55                   	push   %ebp
80107a00:	89 e5                	mov    %esp,%ebp
80107a02:	83 ec 18             	sub    $0x18,%esp
  int m; // Max arg
  struct uproc* table;
  argint(0, &m);
80107a05:	83 ec 08             	sub    $0x8,%esp
80107a08:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107a0b:	50                   	push   %eax
80107a0c:	6a 00                	push   $0x0
80107a0e:	e8 a4 ee ff ff       	call   801068b7 <argint>
80107a13:	83 c4 10             	add    $0x10,%esp
  if (m < 0)
80107a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a19:	85 c0                	test   %eax,%eax
80107a1b:	79 07                	jns    80107a24 <sys_getprocs+0x25>
    return -1;
80107a1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a22:	eb 28                	jmp    80107a4c <sys_getprocs+0x4d>
  argptr(1, (void*)&table, m);
80107a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a27:	83 ec 04             	sub    $0x4,%esp
80107a2a:	50                   	push   %eax
80107a2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a2e:	50                   	push   %eax
80107a2f:	6a 01                	push   $0x1
80107a31:	e8 a9 ee ff ff       	call   801068df <argptr>
80107a36:	83 c4 10             	add    $0x10,%esp
  return getproc_helper(m, table);
80107a39:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3f:	83 ec 08             	sub    $0x8,%esp
80107a42:	52                   	push   %edx
80107a43:	50                   	push   %eax
80107a44:	e8 86 de ff ff       	call   801058cf <getproc_helper>
80107a49:	83 c4 10             	add    $0x10,%esp
}
80107a4c:	c9                   	leave  
80107a4d:	c3                   	ret    

80107a4e <sys_setpriority>:

#ifdef P4
// Implementation of sys_setpriority
int
sys_setpriority(void)
{
80107a4e:	55                   	push   %ebp
80107a4f:	89 e5                	mov    %esp,%ebp
80107a51:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int prio;

  argint(0, &pid);
80107a54:	83 ec 08             	sub    $0x8,%esp
80107a57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107a5a:	50                   	push   %eax
80107a5b:	6a 00                	push   $0x0
80107a5d:	e8 55 ee ff ff       	call   801068b7 <argint>
80107a62:	83 c4 10             	add    $0x10,%esp
  argint(1, &prio);
80107a65:	83 ec 08             	sub    $0x8,%esp
80107a68:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a6b:	50                   	push   %eax
80107a6c:	6a 01                	push   $0x1
80107a6e:	e8 44 ee ff ff       	call   801068b7 <argint>
80107a73:	83 c4 10             	add    $0x10,%esp
  return set_priority(pid, prio);
80107a76:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7c:	83 ec 08             	sub    $0x8,%esp
80107a7f:	52                   	push   %edx
80107a80:	50                   	push   %eax
80107a81:	e8 e9 e5 ff ff       	call   8010606f <set_priority>
80107a86:	83 c4 10             	add    $0x10,%esp
}
80107a89:	c9                   	leave  
80107a8a:	c3                   	ret    

80107a8b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107a8b:	55                   	push   %ebp
80107a8c:	89 e5                	mov    %esp,%ebp
80107a8e:	83 ec 08             	sub    $0x8,%esp
80107a91:	8b 55 08             	mov    0x8(%ebp),%edx
80107a94:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a97:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107a9b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107a9e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107aa2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107aa6:	ee                   	out    %al,(%dx)
}
80107aa7:	90                   	nop
80107aa8:	c9                   	leave  
80107aa9:	c3                   	ret    

80107aaa <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80107aaa:	55                   	push   %ebp
80107aab:	89 e5                	mov    %esp,%ebp
80107aad:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107ab0:	6a 34                	push   $0x34
80107ab2:	6a 43                	push   $0x43
80107ab4:	e8 d2 ff ff ff       	call   80107a8b <outb>
80107ab9:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107abc:	68 9c 00 00 00       	push   $0x9c
80107ac1:	6a 40                	push   $0x40
80107ac3:	e8 c3 ff ff ff       	call   80107a8b <outb>
80107ac8:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80107acb:	6a 2e                	push   $0x2e
80107acd:	6a 40                	push   $0x40
80107acf:	e8 b7 ff ff ff       	call   80107a8b <outb>
80107ad4:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80107ad7:	83 ec 0c             	sub    $0xc,%esp
80107ada:	6a 00                	push   $0x0
80107adc:	e8 f4 c4 ff ff       	call   80103fd5 <picenable>
80107ae1:	83 c4 10             	add    $0x10,%esp
}
80107ae4:	90                   	nop
80107ae5:	c9                   	leave  
80107ae6:	c3                   	ret    

80107ae7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107ae7:	1e                   	push   %ds
  pushl %es
80107ae8:	06                   	push   %es
  pushl %fs
80107ae9:	0f a0                	push   %fs
  pushl %gs
80107aeb:	0f a8                	push   %gs
  pushal
80107aed:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107aee:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107af2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107af4:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107af6:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107afa:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107afc:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107afe:	54                   	push   %esp
  call trap
80107aff:	e8 ce 01 00 00       	call   80107cd2 <trap>
  addl $4, %esp
80107b04:	83 c4 04             	add    $0x4,%esp

80107b07 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107b07:	61                   	popa   
  popl %gs
80107b08:	0f a9                	pop    %gs
  popl %fs
80107b0a:	0f a1                	pop    %fs
  popl %es
80107b0c:	07                   	pop    %es
  popl %ds
80107b0d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107b0e:	83 c4 08             	add    $0x8,%esp
  iret
80107b11:	cf                   	iret   

80107b12 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80107b12:	55                   	push   %ebp
80107b13:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80107b15:	8b 45 08             	mov    0x8(%ebp),%eax
80107b18:	f0 ff 00             	lock incl (%eax)
}
80107b1b:	90                   	nop
80107b1c:	5d                   	pop    %ebp
80107b1d:	c3                   	ret    

80107b1e <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107b1e:	55                   	push   %ebp
80107b1f:	89 e5                	mov    %esp,%ebp
80107b21:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107b24:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b27:	83 e8 01             	sub    $0x1,%eax
80107b2a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80107b31:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107b35:	8b 45 08             	mov    0x8(%ebp),%eax
80107b38:	c1 e8 10             	shr    $0x10,%eax
80107b3b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107b3f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107b42:	0f 01 18             	lidtl  (%eax)
}
80107b45:	90                   	nop
80107b46:	c9                   	leave  
80107b47:	c3                   	ret    

80107b48 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80107b48:	55                   	push   %ebp
80107b49:	89 e5                	mov    %esp,%ebp
80107b4b:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107b4e:	0f 20 d0             	mov    %cr2,%eax
80107b51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107b57:	c9                   	leave  
80107b58:	c3                   	ret    

80107b59 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80107b59:	55                   	push   %ebp
80107b5a:	89 e5                	mov    %esp,%ebp
80107b5c:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107b5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107b66:	e9 c3 00 00 00       	jmp    80107c2e <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b6e:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
80107b75:	89 c2                	mov    %eax,%edx
80107b77:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b7a:	66 89 14 c5 00 70 11 	mov    %dx,-0x7fee9000(,%eax,8)
80107b81:	80 
80107b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b85:	66 c7 04 c5 02 70 11 	movw   $0x8,-0x7fee8ffe(,%eax,8)
80107b8c:	80 08 00 
80107b8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b92:	0f b6 14 c5 04 70 11 	movzbl -0x7fee8ffc(,%eax,8),%edx
80107b99:	80 
80107b9a:	83 e2 e0             	and    $0xffffffe0,%edx
80107b9d:	88 14 c5 04 70 11 80 	mov    %dl,-0x7fee8ffc(,%eax,8)
80107ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ba7:	0f b6 14 c5 04 70 11 	movzbl -0x7fee8ffc(,%eax,8),%edx
80107bae:	80 
80107baf:	83 e2 1f             	and    $0x1f,%edx
80107bb2:	88 14 c5 04 70 11 80 	mov    %dl,-0x7fee8ffc(,%eax,8)
80107bb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bbc:	0f b6 14 c5 05 70 11 	movzbl -0x7fee8ffb(,%eax,8),%edx
80107bc3:	80 
80107bc4:	83 e2 f0             	and    $0xfffffff0,%edx
80107bc7:	83 ca 0e             	or     $0xe,%edx
80107bca:	88 14 c5 05 70 11 80 	mov    %dl,-0x7fee8ffb(,%eax,8)
80107bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bd4:	0f b6 14 c5 05 70 11 	movzbl -0x7fee8ffb(,%eax,8),%edx
80107bdb:	80 
80107bdc:	83 e2 ef             	and    $0xffffffef,%edx
80107bdf:	88 14 c5 05 70 11 80 	mov    %dl,-0x7fee8ffb(,%eax,8)
80107be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107be9:	0f b6 14 c5 05 70 11 	movzbl -0x7fee8ffb(,%eax,8),%edx
80107bf0:	80 
80107bf1:	83 e2 9f             	and    $0xffffff9f,%edx
80107bf4:	88 14 c5 05 70 11 80 	mov    %dl,-0x7fee8ffb(,%eax,8)
80107bfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bfe:	0f b6 14 c5 05 70 11 	movzbl -0x7fee8ffb(,%eax,8),%edx
80107c05:	80 
80107c06:	83 ca 80             	or     $0xffffff80,%edx
80107c09:	88 14 c5 05 70 11 80 	mov    %dl,-0x7fee8ffb(,%eax,8)
80107c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c13:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
80107c1a:	c1 e8 10             	shr    $0x10,%eax
80107c1d:	89 c2                	mov    %eax,%edx
80107c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c22:	66 89 14 c5 06 70 11 	mov    %dx,-0x7fee8ffa(,%eax,8)
80107c29:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107c2a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107c2e:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107c35:	0f 8e 30 ff ff ff    	jle    80107b6b <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107c3b:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107c40:	66 a3 00 72 11 80    	mov    %ax,0x80117200
80107c46:	66 c7 05 02 72 11 80 	movw   $0x8,0x80117202
80107c4d:	08 00 
80107c4f:	0f b6 05 04 72 11 80 	movzbl 0x80117204,%eax
80107c56:	83 e0 e0             	and    $0xffffffe0,%eax
80107c59:	a2 04 72 11 80       	mov    %al,0x80117204
80107c5e:	0f b6 05 04 72 11 80 	movzbl 0x80117204,%eax
80107c65:	83 e0 1f             	and    $0x1f,%eax
80107c68:	a2 04 72 11 80       	mov    %al,0x80117204
80107c6d:	0f b6 05 05 72 11 80 	movzbl 0x80117205,%eax
80107c74:	83 c8 0f             	or     $0xf,%eax
80107c77:	a2 05 72 11 80       	mov    %al,0x80117205
80107c7c:	0f b6 05 05 72 11 80 	movzbl 0x80117205,%eax
80107c83:	83 e0 ef             	and    $0xffffffef,%eax
80107c86:	a2 05 72 11 80       	mov    %al,0x80117205
80107c8b:	0f b6 05 05 72 11 80 	movzbl 0x80117205,%eax
80107c92:	83 c8 60             	or     $0x60,%eax
80107c95:	a2 05 72 11 80       	mov    %al,0x80117205
80107c9a:	0f b6 05 05 72 11 80 	movzbl 0x80117205,%eax
80107ca1:	83 c8 80             	or     $0xffffff80,%eax
80107ca4:	a2 05 72 11 80       	mov    %al,0x80117205
80107ca9:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107cae:	c1 e8 10             	shr    $0x10,%eax
80107cb1:	66 a3 06 72 11 80    	mov    %ax,0x80117206
  
}
80107cb7:	90                   	nop
80107cb8:	c9                   	leave  
80107cb9:	c3                   	ret    

80107cba <idtinit>:

void
idtinit(void)
{
80107cba:	55                   	push   %ebp
80107cbb:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107cbd:	68 00 08 00 00       	push   $0x800
80107cc2:	68 00 70 11 80       	push   $0x80117000
80107cc7:	e8 52 fe ff ff       	call   80107b1e <lidt>
80107ccc:	83 c4 08             	add    $0x8,%esp
}
80107ccf:	90                   	nop
80107cd0:	c9                   	leave  
80107cd1:	c3                   	ret    

80107cd2 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107cd2:	55                   	push   %ebp
80107cd3:	89 e5                	mov    %esp,%ebp
80107cd5:	57                   	push   %edi
80107cd6:	56                   	push   %esi
80107cd7:	53                   	push   %ebx
80107cd8:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80107cde:	8b 40 30             	mov    0x30(%eax),%eax
80107ce1:	83 f8 40             	cmp    $0x40,%eax
80107ce4:	75 3e                	jne    80107d24 <trap+0x52>
    if(proc->killed)
80107ce6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cec:	8b 40 24             	mov    0x24(%eax),%eax
80107cef:	85 c0                	test   %eax,%eax
80107cf1:	74 05                	je     80107cf8 <trap+0x26>
      exit();
80107cf3:	e8 48 cf ff ff       	call   80104c40 <exit>
    proc->tf = tf;
80107cf8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cfe:	8b 55 08             	mov    0x8(%ebp),%edx
80107d01:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107d04:	e8 64 ec ff ff       	call   8010696d <syscall>
    if(proc->killed)
80107d09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d0f:	8b 40 24             	mov    0x24(%eax),%eax
80107d12:	85 c0                	test   %eax,%eax
80107d14:	0f 84 fe 01 00 00    	je     80107f18 <trap+0x246>
      exit();
80107d1a:	e8 21 cf ff ff       	call   80104c40 <exit>
    return;
80107d1f:	e9 f4 01 00 00       	jmp    80107f18 <trap+0x246>
  }

  switch(tf->trapno){
80107d24:	8b 45 08             	mov    0x8(%ebp),%eax
80107d27:	8b 40 30             	mov    0x30(%eax),%eax
80107d2a:	83 e8 20             	sub    $0x20,%eax
80107d2d:	83 f8 1f             	cmp    $0x1f,%eax
80107d30:	0f 87 a3 00 00 00    	ja     80107dd9 <trap+0x107>
80107d36:	8b 04 85 08 a1 10 80 	mov    -0x7fef5ef8(,%eax,4),%eax
80107d3d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80107d3f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d45:	0f b6 00             	movzbl (%eax),%eax
80107d48:	84 c0                	test   %al,%al
80107d4a:	75 20                	jne    80107d6c <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107d4c:	83 ec 0c             	sub    $0xc,%esp
80107d4f:	68 00 78 11 80       	push   $0x80117800
80107d54:	e8 b9 fd ff ff       	call   80107b12 <atom_inc>
80107d59:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107d5c:	83 ec 0c             	sub    $0xc,%esp
80107d5f:	68 00 78 11 80       	push   $0x80117800
80107d64:	e8 de d6 ff ff       	call   80105447 <wakeup>
80107d69:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107d6c:	e8 5e b3 ff ff       	call   801030cf <lapiceoi>
    break;
80107d71:	e9 1c 01 00 00       	jmp    80107e92 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107d76:	e8 67 ab ff ff       	call   801028e2 <ideintr>
    lapiceoi();
80107d7b:	e8 4f b3 ff ff       	call   801030cf <lapiceoi>
    break;
80107d80:	e9 0d 01 00 00       	jmp    80107e92 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107d85:	e8 47 b1 ff ff       	call   80102ed1 <kbdintr>
    lapiceoi();
80107d8a:	e8 40 b3 ff ff       	call   801030cf <lapiceoi>
    break;
80107d8f:	e9 fe 00 00 00       	jmp    80107e92 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107d94:	e8 60 03 00 00       	call   801080f9 <uartintr>
    lapiceoi();
80107d99:	e8 31 b3 ff ff       	call   801030cf <lapiceoi>
    break;
80107d9e:	e9 ef 00 00 00       	jmp    80107e92 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107da3:	8b 45 08             	mov    0x8(%ebp),%eax
80107da6:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107da9:	8b 45 08             	mov    0x8(%ebp),%eax
80107dac:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107db0:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107db3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107db9:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107dbc:	0f b6 c0             	movzbl %al,%eax
80107dbf:	51                   	push   %ecx
80107dc0:	52                   	push   %edx
80107dc1:	50                   	push   %eax
80107dc2:	68 68 a0 10 80       	push   $0x8010a068
80107dc7:	e8 fa 85 ff ff       	call   801003c6 <cprintf>
80107dcc:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107dcf:	e8 fb b2 ff ff       	call   801030cf <lapiceoi>
    break;
80107dd4:	e9 b9 00 00 00       	jmp    80107e92 <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107dd9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ddf:	85 c0                	test   %eax,%eax
80107de1:	74 11                	je     80107df4 <trap+0x122>
80107de3:	8b 45 08             	mov    0x8(%ebp),%eax
80107de6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107dea:	0f b7 c0             	movzwl %ax,%eax
80107ded:	83 e0 03             	and    $0x3,%eax
80107df0:	85 c0                	test   %eax,%eax
80107df2:	75 40                	jne    80107e34 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107df4:	e8 4f fd ff ff       	call   80107b48 <rcr2>
80107df9:	89 c3                	mov    %eax,%ebx
80107dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80107dfe:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107e01:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e07:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107e0a:	0f b6 d0             	movzbl %al,%edx
80107e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80107e10:	8b 40 30             	mov    0x30(%eax),%eax
80107e13:	83 ec 0c             	sub    $0xc,%esp
80107e16:	53                   	push   %ebx
80107e17:	51                   	push   %ecx
80107e18:	52                   	push   %edx
80107e19:	50                   	push   %eax
80107e1a:	68 8c a0 10 80       	push   $0x8010a08c
80107e1f:	e8 a2 85 ff ff       	call   801003c6 <cprintf>
80107e24:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107e27:	83 ec 0c             	sub    $0xc,%esp
80107e2a:	68 be a0 10 80       	push   $0x8010a0be
80107e2f:	e8 32 87 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e34:	e8 0f fd ff ff       	call   80107b48 <rcr2>
80107e39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e3c:	8b 45 08             	mov    0x8(%ebp),%eax
80107e3f:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107e42:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e48:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e4b:	0f b6 d8             	movzbl %al,%ebx
80107e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80107e51:	8b 48 34             	mov    0x34(%eax),%ecx
80107e54:	8b 45 08             	mov    0x8(%ebp),%eax
80107e57:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107e5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e60:	8d 78 6c             	lea    0x6c(%eax),%edi
80107e63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e69:	8b 40 10             	mov    0x10(%eax),%eax
80107e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e6f:	56                   	push   %esi
80107e70:	53                   	push   %ebx
80107e71:	51                   	push   %ecx
80107e72:	52                   	push   %edx
80107e73:	57                   	push   %edi
80107e74:	50                   	push   %eax
80107e75:	68 c4 a0 10 80       	push   $0x8010a0c4
80107e7a:	e8 47 85 ff ff       	call   801003c6 <cprintf>
80107e7f:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107e82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e88:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107e8f:	eb 01                	jmp    80107e92 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107e91:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107e92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e98:	85 c0                	test   %eax,%eax
80107e9a:	74 24                	je     80107ec0 <trap+0x1ee>
80107e9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ea2:	8b 40 24             	mov    0x24(%eax),%eax
80107ea5:	85 c0                	test   %eax,%eax
80107ea7:	74 17                	je     80107ec0 <trap+0x1ee>
80107ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80107eac:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107eb0:	0f b7 c0             	movzwl %ax,%eax
80107eb3:	83 e0 03             	and    $0x3,%eax
80107eb6:	83 f8 03             	cmp    $0x3,%eax
80107eb9:	75 05                	jne    80107ec0 <trap+0x1ee>
    exit();
80107ebb:	e8 80 cd ff ff       	call   80104c40 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107ec0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ec6:	85 c0                	test   %eax,%eax
80107ec8:	74 1e                	je     80107ee8 <trap+0x216>
80107eca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ed0:	8b 40 0c             	mov    0xc(%eax),%eax
80107ed3:	83 f8 04             	cmp    $0x4,%eax
80107ed6:	75 10                	jne    80107ee8 <trap+0x216>
80107ed8:	8b 45 08             	mov    0x8(%ebp),%eax
80107edb:	8b 40 30             	mov    0x30(%eax),%eax
80107ede:	83 f8 20             	cmp    $0x20,%eax
80107ee1:	75 05                	jne    80107ee8 <trap+0x216>
    yield();
80107ee3:	e8 49 d3 ff ff       	call   80105231 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107ee8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107eee:	85 c0                	test   %eax,%eax
80107ef0:	74 27                	je     80107f19 <trap+0x247>
80107ef2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ef8:	8b 40 24             	mov    0x24(%eax),%eax
80107efb:	85 c0                	test   %eax,%eax
80107efd:	74 1a                	je     80107f19 <trap+0x247>
80107eff:	8b 45 08             	mov    0x8(%ebp),%eax
80107f02:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107f06:	0f b7 c0             	movzwl %ax,%eax
80107f09:	83 e0 03             	and    $0x3,%eax
80107f0c:	83 f8 03             	cmp    $0x3,%eax
80107f0f:	75 08                	jne    80107f19 <trap+0x247>
    exit();
80107f11:	e8 2a cd ff ff       	call   80104c40 <exit>
80107f16:	eb 01                	jmp    80107f19 <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107f18:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107f19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f1c:	5b                   	pop    %ebx
80107f1d:	5e                   	pop    %esi
80107f1e:	5f                   	pop    %edi
80107f1f:	5d                   	pop    %ebp
80107f20:	c3                   	ret    

80107f21 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80107f21:	55                   	push   %ebp
80107f22:	89 e5                	mov    %esp,%ebp
80107f24:	83 ec 14             	sub    $0x14,%esp
80107f27:	8b 45 08             	mov    0x8(%ebp),%eax
80107f2a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107f2e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107f32:	89 c2                	mov    %eax,%edx
80107f34:	ec                   	in     (%dx),%al
80107f35:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107f38:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107f3c:	c9                   	leave  
80107f3d:	c3                   	ret    

80107f3e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107f3e:	55                   	push   %ebp
80107f3f:	89 e5                	mov    %esp,%ebp
80107f41:	83 ec 08             	sub    $0x8,%esp
80107f44:	8b 55 08             	mov    0x8(%ebp),%edx
80107f47:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f4a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107f4e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107f51:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107f55:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107f59:	ee                   	out    %al,(%dx)
}
80107f5a:	90                   	nop
80107f5b:	c9                   	leave  
80107f5c:	c3                   	ret    

80107f5d <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107f5d:	55                   	push   %ebp
80107f5e:	89 e5                	mov    %esp,%ebp
80107f60:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107f63:	6a 00                	push   $0x0
80107f65:	68 fa 03 00 00       	push   $0x3fa
80107f6a:	e8 cf ff ff ff       	call   80107f3e <outb>
80107f6f:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107f72:	68 80 00 00 00       	push   $0x80
80107f77:	68 fb 03 00 00       	push   $0x3fb
80107f7c:	e8 bd ff ff ff       	call   80107f3e <outb>
80107f81:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107f84:	6a 0c                	push   $0xc
80107f86:	68 f8 03 00 00       	push   $0x3f8
80107f8b:	e8 ae ff ff ff       	call   80107f3e <outb>
80107f90:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107f93:	6a 00                	push   $0x0
80107f95:	68 f9 03 00 00       	push   $0x3f9
80107f9a:	e8 9f ff ff ff       	call   80107f3e <outb>
80107f9f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107fa2:	6a 03                	push   $0x3
80107fa4:	68 fb 03 00 00       	push   $0x3fb
80107fa9:	e8 90 ff ff ff       	call   80107f3e <outb>
80107fae:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107fb1:	6a 00                	push   $0x0
80107fb3:	68 fc 03 00 00       	push   $0x3fc
80107fb8:	e8 81 ff ff ff       	call   80107f3e <outb>
80107fbd:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107fc0:	6a 01                	push   $0x1
80107fc2:	68 f9 03 00 00       	push   $0x3f9
80107fc7:	e8 72 ff ff ff       	call   80107f3e <outb>
80107fcc:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107fcf:	68 fd 03 00 00       	push   $0x3fd
80107fd4:	e8 48 ff ff ff       	call   80107f21 <inb>
80107fd9:	83 c4 04             	add    $0x4,%esp
80107fdc:	3c ff                	cmp    $0xff,%al
80107fde:	74 6e                	je     8010804e <uartinit+0xf1>
    return;
  uart = 1;
80107fe0:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
80107fe7:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107fea:	68 fa 03 00 00       	push   $0x3fa
80107fef:	e8 2d ff ff ff       	call   80107f21 <inb>
80107ff4:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107ff7:	68 f8 03 00 00       	push   $0x3f8
80107ffc:	e8 20 ff ff ff       	call   80107f21 <inb>
80108001:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80108004:	83 ec 0c             	sub    $0xc,%esp
80108007:	6a 04                	push   $0x4
80108009:	e8 c7 bf ff ff       	call   80103fd5 <picenable>
8010800e:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80108011:	83 ec 08             	sub    $0x8,%esp
80108014:	6a 00                	push   $0x0
80108016:	6a 04                	push   $0x4
80108018:	e8 67 ab ff ff       	call   80102b84 <ioapicenable>
8010801d:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108020:	c7 45 f4 88 a1 10 80 	movl   $0x8010a188,-0xc(%ebp)
80108027:	eb 19                	jmp    80108042 <uartinit+0xe5>
    uartputc(*p);
80108029:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802c:	0f b6 00             	movzbl (%eax),%eax
8010802f:	0f be c0             	movsbl %al,%eax
80108032:	83 ec 0c             	sub    $0xc,%esp
80108035:	50                   	push   %eax
80108036:	e8 16 00 00 00       	call   80108051 <uartputc>
8010803b:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010803e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108045:	0f b6 00             	movzbl (%eax),%eax
80108048:	84 c0                	test   %al,%al
8010804a:	75 dd                	jne    80108029 <uartinit+0xcc>
8010804c:	eb 01                	jmp    8010804f <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010804e:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010804f:	c9                   	leave  
80108050:	c3                   	ret    

80108051 <uartputc>:

void
uartputc(int c)
{
80108051:	55                   	push   %ebp
80108052:	89 e5                	mov    %esp,%ebp
80108054:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80108057:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
8010805c:	85 c0                	test   %eax,%eax
8010805e:	74 53                	je     801080b3 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108060:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108067:	eb 11                	jmp    8010807a <uartputc+0x29>
    microdelay(10);
80108069:	83 ec 0c             	sub    $0xc,%esp
8010806c:	6a 0a                	push   $0xa
8010806e:	e8 77 b0 ff ff       	call   801030ea <microdelay>
80108073:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108076:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010807a:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010807e:	7f 1a                	jg     8010809a <uartputc+0x49>
80108080:	83 ec 0c             	sub    $0xc,%esp
80108083:	68 fd 03 00 00       	push   $0x3fd
80108088:	e8 94 fe ff ff       	call   80107f21 <inb>
8010808d:	83 c4 10             	add    $0x10,%esp
80108090:	0f b6 c0             	movzbl %al,%eax
80108093:	83 e0 20             	and    $0x20,%eax
80108096:	85 c0                	test   %eax,%eax
80108098:	74 cf                	je     80108069 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
8010809a:	8b 45 08             	mov    0x8(%ebp),%eax
8010809d:	0f b6 c0             	movzbl %al,%eax
801080a0:	83 ec 08             	sub    $0x8,%esp
801080a3:	50                   	push   %eax
801080a4:	68 f8 03 00 00       	push   $0x3f8
801080a9:	e8 90 fe ff ff       	call   80107f3e <outb>
801080ae:	83 c4 10             	add    $0x10,%esp
801080b1:	eb 01                	jmp    801080b4 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801080b3:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801080b4:	c9                   	leave  
801080b5:	c3                   	ret    

801080b6 <uartgetc>:

static int
uartgetc(void)
{
801080b6:	55                   	push   %ebp
801080b7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801080b9:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
801080be:	85 c0                	test   %eax,%eax
801080c0:	75 07                	jne    801080c9 <uartgetc+0x13>
    return -1;
801080c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080c7:	eb 2e                	jmp    801080f7 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801080c9:	68 fd 03 00 00       	push   $0x3fd
801080ce:	e8 4e fe ff ff       	call   80107f21 <inb>
801080d3:	83 c4 04             	add    $0x4,%esp
801080d6:	0f b6 c0             	movzbl %al,%eax
801080d9:	83 e0 01             	and    $0x1,%eax
801080dc:	85 c0                	test   %eax,%eax
801080de:	75 07                	jne    801080e7 <uartgetc+0x31>
    return -1;
801080e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080e5:	eb 10                	jmp    801080f7 <uartgetc+0x41>
  return inb(COM1+0);
801080e7:	68 f8 03 00 00       	push   $0x3f8
801080ec:	e8 30 fe ff ff       	call   80107f21 <inb>
801080f1:	83 c4 04             	add    $0x4,%esp
801080f4:	0f b6 c0             	movzbl %al,%eax
}
801080f7:	c9                   	leave  
801080f8:	c3                   	ret    

801080f9 <uartintr>:

void
uartintr(void)
{
801080f9:	55                   	push   %ebp
801080fa:	89 e5                	mov    %esp,%ebp
801080fc:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801080ff:	83 ec 0c             	sub    $0xc,%esp
80108102:	68 b6 80 10 80       	push   $0x801080b6
80108107:	e8 ed 86 ff ff       	call   801007f9 <consoleintr>
8010810c:	83 c4 10             	add    $0x10,%esp
}
8010810f:	90                   	nop
80108110:	c9                   	leave  
80108111:	c3                   	ret    

80108112 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80108112:	6a 00                	push   $0x0
  pushl $0
80108114:	6a 00                	push   $0x0
  jmp alltraps
80108116:	e9 cc f9 ff ff       	jmp    80107ae7 <alltraps>

8010811b <vector1>:
.globl vector1
vector1:
  pushl $0
8010811b:	6a 00                	push   $0x0
  pushl $1
8010811d:	6a 01                	push   $0x1
  jmp alltraps
8010811f:	e9 c3 f9 ff ff       	jmp    80107ae7 <alltraps>

80108124 <vector2>:
.globl vector2
vector2:
  pushl $0
80108124:	6a 00                	push   $0x0
  pushl $2
80108126:	6a 02                	push   $0x2
  jmp alltraps
80108128:	e9 ba f9 ff ff       	jmp    80107ae7 <alltraps>

8010812d <vector3>:
.globl vector3
vector3:
  pushl $0
8010812d:	6a 00                	push   $0x0
  pushl $3
8010812f:	6a 03                	push   $0x3
  jmp alltraps
80108131:	e9 b1 f9 ff ff       	jmp    80107ae7 <alltraps>

80108136 <vector4>:
.globl vector4
vector4:
  pushl $0
80108136:	6a 00                	push   $0x0
  pushl $4
80108138:	6a 04                	push   $0x4
  jmp alltraps
8010813a:	e9 a8 f9 ff ff       	jmp    80107ae7 <alltraps>

8010813f <vector5>:
.globl vector5
vector5:
  pushl $0
8010813f:	6a 00                	push   $0x0
  pushl $5
80108141:	6a 05                	push   $0x5
  jmp alltraps
80108143:	e9 9f f9 ff ff       	jmp    80107ae7 <alltraps>

80108148 <vector6>:
.globl vector6
vector6:
  pushl $0
80108148:	6a 00                	push   $0x0
  pushl $6
8010814a:	6a 06                	push   $0x6
  jmp alltraps
8010814c:	e9 96 f9 ff ff       	jmp    80107ae7 <alltraps>

80108151 <vector7>:
.globl vector7
vector7:
  pushl $0
80108151:	6a 00                	push   $0x0
  pushl $7
80108153:	6a 07                	push   $0x7
  jmp alltraps
80108155:	e9 8d f9 ff ff       	jmp    80107ae7 <alltraps>

8010815a <vector8>:
.globl vector8
vector8:
  pushl $8
8010815a:	6a 08                	push   $0x8
  jmp alltraps
8010815c:	e9 86 f9 ff ff       	jmp    80107ae7 <alltraps>

80108161 <vector9>:
.globl vector9
vector9:
  pushl $0
80108161:	6a 00                	push   $0x0
  pushl $9
80108163:	6a 09                	push   $0x9
  jmp alltraps
80108165:	e9 7d f9 ff ff       	jmp    80107ae7 <alltraps>

8010816a <vector10>:
.globl vector10
vector10:
  pushl $10
8010816a:	6a 0a                	push   $0xa
  jmp alltraps
8010816c:	e9 76 f9 ff ff       	jmp    80107ae7 <alltraps>

80108171 <vector11>:
.globl vector11
vector11:
  pushl $11
80108171:	6a 0b                	push   $0xb
  jmp alltraps
80108173:	e9 6f f9 ff ff       	jmp    80107ae7 <alltraps>

80108178 <vector12>:
.globl vector12
vector12:
  pushl $12
80108178:	6a 0c                	push   $0xc
  jmp alltraps
8010817a:	e9 68 f9 ff ff       	jmp    80107ae7 <alltraps>

8010817f <vector13>:
.globl vector13
vector13:
  pushl $13
8010817f:	6a 0d                	push   $0xd
  jmp alltraps
80108181:	e9 61 f9 ff ff       	jmp    80107ae7 <alltraps>

80108186 <vector14>:
.globl vector14
vector14:
  pushl $14
80108186:	6a 0e                	push   $0xe
  jmp alltraps
80108188:	e9 5a f9 ff ff       	jmp    80107ae7 <alltraps>

8010818d <vector15>:
.globl vector15
vector15:
  pushl $0
8010818d:	6a 00                	push   $0x0
  pushl $15
8010818f:	6a 0f                	push   $0xf
  jmp alltraps
80108191:	e9 51 f9 ff ff       	jmp    80107ae7 <alltraps>

80108196 <vector16>:
.globl vector16
vector16:
  pushl $0
80108196:	6a 00                	push   $0x0
  pushl $16
80108198:	6a 10                	push   $0x10
  jmp alltraps
8010819a:	e9 48 f9 ff ff       	jmp    80107ae7 <alltraps>

8010819f <vector17>:
.globl vector17
vector17:
  pushl $17
8010819f:	6a 11                	push   $0x11
  jmp alltraps
801081a1:	e9 41 f9 ff ff       	jmp    80107ae7 <alltraps>

801081a6 <vector18>:
.globl vector18
vector18:
  pushl $0
801081a6:	6a 00                	push   $0x0
  pushl $18
801081a8:	6a 12                	push   $0x12
  jmp alltraps
801081aa:	e9 38 f9 ff ff       	jmp    80107ae7 <alltraps>

801081af <vector19>:
.globl vector19
vector19:
  pushl $0
801081af:	6a 00                	push   $0x0
  pushl $19
801081b1:	6a 13                	push   $0x13
  jmp alltraps
801081b3:	e9 2f f9 ff ff       	jmp    80107ae7 <alltraps>

801081b8 <vector20>:
.globl vector20
vector20:
  pushl $0
801081b8:	6a 00                	push   $0x0
  pushl $20
801081ba:	6a 14                	push   $0x14
  jmp alltraps
801081bc:	e9 26 f9 ff ff       	jmp    80107ae7 <alltraps>

801081c1 <vector21>:
.globl vector21
vector21:
  pushl $0
801081c1:	6a 00                	push   $0x0
  pushl $21
801081c3:	6a 15                	push   $0x15
  jmp alltraps
801081c5:	e9 1d f9 ff ff       	jmp    80107ae7 <alltraps>

801081ca <vector22>:
.globl vector22
vector22:
  pushl $0
801081ca:	6a 00                	push   $0x0
  pushl $22
801081cc:	6a 16                	push   $0x16
  jmp alltraps
801081ce:	e9 14 f9 ff ff       	jmp    80107ae7 <alltraps>

801081d3 <vector23>:
.globl vector23
vector23:
  pushl $0
801081d3:	6a 00                	push   $0x0
  pushl $23
801081d5:	6a 17                	push   $0x17
  jmp alltraps
801081d7:	e9 0b f9 ff ff       	jmp    80107ae7 <alltraps>

801081dc <vector24>:
.globl vector24
vector24:
  pushl $0
801081dc:	6a 00                	push   $0x0
  pushl $24
801081de:	6a 18                	push   $0x18
  jmp alltraps
801081e0:	e9 02 f9 ff ff       	jmp    80107ae7 <alltraps>

801081e5 <vector25>:
.globl vector25
vector25:
  pushl $0
801081e5:	6a 00                	push   $0x0
  pushl $25
801081e7:	6a 19                	push   $0x19
  jmp alltraps
801081e9:	e9 f9 f8 ff ff       	jmp    80107ae7 <alltraps>

801081ee <vector26>:
.globl vector26
vector26:
  pushl $0
801081ee:	6a 00                	push   $0x0
  pushl $26
801081f0:	6a 1a                	push   $0x1a
  jmp alltraps
801081f2:	e9 f0 f8 ff ff       	jmp    80107ae7 <alltraps>

801081f7 <vector27>:
.globl vector27
vector27:
  pushl $0
801081f7:	6a 00                	push   $0x0
  pushl $27
801081f9:	6a 1b                	push   $0x1b
  jmp alltraps
801081fb:	e9 e7 f8 ff ff       	jmp    80107ae7 <alltraps>

80108200 <vector28>:
.globl vector28
vector28:
  pushl $0
80108200:	6a 00                	push   $0x0
  pushl $28
80108202:	6a 1c                	push   $0x1c
  jmp alltraps
80108204:	e9 de f8 ff ff       	jmp    80107ae7 <alltraps>

80108209 <vector29>:
.globl vector29
vector29:
  pushl $0
80108209:	6a 00                	push   $0x0
  pushl $29
8010820b:	6a 1d                	push   $0x1d
  jmp alltraps
8010820d:	e9 d5 f8 ff ff       	jmp    80107ae7 <alltraps>

80108212 <vector30>:
.globl vector30
vector30:
  pushl $0
80108212:	6a 00                	push   $0x0
  pushl $30
80108214:	6a 1e                	push   $0x1e
  jmp alltraps
80108216:	e9 cc f8 ff ff       	jmp    80107ae7 <alltraps>

8010821b <vector31>:
.globl vector31
vector31:
  pushl $0
8010821b:	6a 00                	push   $0x0
  pushl $31
8010821d:	6a 1f                	push   $0x1f
  jmp alltraps
8010821f:	e9 c3 f8 ff ff       	jmp    80107ae7 <alltraps>

80108224 <vector32>:
.globl vector32
vector32:
  pushl $0
80108224:	6a 00                	push   $0x0
  pushl $32
80108226:	6a 20                	push   $0x20
  jmp alltraps
80108228:	e9 ba f8 ff ff       	jmp    80107ae7 <alltraps>

8010822d <vector33>:
.globl vector33
vector33:
  pushl $0
8010822d:	6a 00                	push   $0x0
  pushl $33
8010822f:	6a 21                	push   $0x21
  jmp alltraps
80108231:	e9 b1 f8 ff ff       	jmp    80107ae7 <alltraps>

80108236 <vector34>:
.globl vector34
vector34:
  pushl $0
80108236:	6a 00                	push   $0x0
  pushl $34
80108238:	6a 22                	push   $0x22
  jmp alltraps
8010823a:	e9 a8 f8 ff ff       	jmp    80107ae7 <alltraps>

8010823f <vector35>:
.globl vector35
vector35:
  pushl $0
8010823f:	6a 00                	push   $0x0
  pushl $35
80108241:	6a 23                	push   $0x23
  jmp alltraps
80108243:	e9 9f f8 ff ff       	jmp    80107ae7 <alltraps>

80108248 <vector36>:
.globl vector36
vector36:
  pushl $0
80108248:	6a 00                	push   $0x0
  pushl $36
8010824a:	6a 24                	push   $0x24
  jmp alltraps
8010824c:	e9 96 f8 ff ff       	jmp    80107ae7 <alltraps>

80108251 <vector37>:
.globl vector37
vector37:
  pushl $0
80108251:	6a 00                	push   $0x0
  pushl $37
80108253:	6a 25                	push   $0x25
  jmp alltraps
80108255:	e9 8d f8 ff ff       	jmp    80107ae7 <alltraps>

8010825a <vector38>:
.globl vector38
vector38:
  pushl $0
8010825a:	6a 00                	push   $0x0
  pushl $38
8010825c:	6a 26                	push   $0x26
  jmp alltraps
8010825e:	e9 84 f8 ff ff       	jmp    80107ae7 <alltraps>

80108263 <vector39>:
.globl vector39
vector39:
  pushl $0
80108263:	6a 00                	push   $0x0
  pushl $39
80108265:	6a 27                	push   $0x27
  jmp alltraps
80108267:	e9 7b f8 ff ff       	jmp    80107ae7 <alltraps>

8010826c <vector40>:
.globl vector40
vector40:
  pushl $0
8010826c:	6a 00                	push   $0x0
  pushl $40
8010826e:	6a 28                	push   $0x28
  jmp alltraps
80108270:	e9 72 f8 ff ff       	jmp    80107ae7 <alltraps>

80108275 <vector41>:
.globl vector41
vector41:
  pushl $0
80108275:	6a 00                	push   $0x0
  pushl $41
80108277:	6a 29                	push   $0x29
  jmp alltraps
80108279:	e9 69 f8 ff ff       	jmp    80107ae7 <alltraps>

8010827e <vector42>:
.globl vector42
vector42:
  pushl $0
8010827e:	6a 00                	push   $0x0
  pushl $42
80108280:	6a 2a                	push   $0x2a
  jmp alltraps
80108282:	e9 60 f8 ff ff       	jmp    80107ae7 <alltraps>

80108287 <vector43>:
.globl vector43
vector43:
  pushl $0
80108287:	6a 00                	push   $0x0
  pushl $43
80108289:	6a 2b                	push   $0x2b
  jmp alltraps
8010828b:	e9 57 f8 ff ff       	jmp    80107ae7 <alltraps>

80108290 <vector44>:
.globl vector44
vector44:
  pushl $0
80108290:	6a 00                	push   $0x0
  pushl $44
80108292:	6a 2c                	push   $0x2c
  jmp alltraps
80108294:	e9 4e f8 ff ff       	jmp    80107ae7 <alltraps>

80108299 <vector45>:
.globl vector45
vector45:
  pushl $0
80108299:	6a 00                	push   $0x0
  pushl $45
8010829b:	6a 2d                	push   $0x2d
  jmp alltraps
8010829d:	e9 45 f8 ff ff       	jmp    80107ae7 <alltraps>

801082a2 <vector46>:
.globl vector46
vector46:
  pushl $0
801082a2:	6a 00                	push   $0x0
  pushl $46
801082a4:	6a 2e                	push   $0x2e
  jmp alltraps
801082a6:	e9 3c f8 ff ff       	jmp    80107ae7 <alltraps>

801082ab <vector47>:
.globl vector47
vector47:
  pushl $0
801082ab:	6a 00                	push   $0x0
  pushl $47
801082ad:	6a 2f                	push   $0x2f
  jmp alltraps
801082af:	e9 33 f8 ff ff       	jmp    80107ae7 <alltraps>

801082b4 <vector48>:
.globl vector48
vector48:
  pushl $0
801082b4:	6a 00                	push   $0x0
  pushl $48
801082b6:	6a 30                	push   $0x30
  jmp alltraps
801082b8:	e9 2a f8 ff ff       	jmp    80107ae7 <alltraps>

801082bd <vector49>:
.globl vector49
vector49:
  pushl $0
801082bd:	6a 00                	push   $0x0
  pushl $49
801082bf:	6a 31                	push   $0x31
  jmp alltraps
801082c1:	e9 21 f8 ff ff       	jmp    80107ae7 <alltraps>

801082c6 <vector50>:
.globl vector50
vector50:
  pushl $0
801082c6:	6a 00                	push   $0x0
  pushl $50
801082c8:	6a 32                	push   $0x32
  jmp alltraps
801082ca:	e9 18 f8 ff ff       	jmp    80107ae7 <alltraps>

801082cf <vector51>:
.globl vector51
vector51:
  pushl $0
801082cf:	6a 00                	push   $0x0
  pushl $51
801082d1:	6a 33                	push   $0x33
  jmp alltraps
801082d3:	e9 0f f8 ff ff       	jmp    80107ae7 <alltraps>

801082d8 <vector52>:
.globl vector52
vector52:
  pushl $0
801082d8:	6a 00                	push   $0x0
  pushl $52
801082da:	6a 34                	push   $0x34
  jmp alltraps
801082dc:	e9 06 f8 ff ff       	jmp    80107ae7 <alltraps>

801082e1 <vector53>:
.globl vector53
vector53:
  pushl $0
801082e1:	6a 00                	push   $0x0
  pushl $53
801082e3:	6a 35                	push   $0x35
  jmp alltraps
801082e5:	e9 fd f7 ff ff       	jmp    80107ae7 <alltraps>

801082ea <vector54>:
.globl vector54
vector54:
  pushl $0
801082ea:	6a 00                	push   $0x0
  pushl $54
801082ec:	6a 36                	push   $0x36
  jmp alltraps
801082ee:	e9 f4 f7 ff ff       	jmp    80107ae7 <alltraps>

801082f3 <vector55>:
.globl vector55
vector55:
  pushl $0
801082f3:	6a 00                	push   $0x0
  pushl $55
801082f5:	6a 37                	push   $0x37
  jmp alltraps
801082f7:	e9 eb f7 ff ff       	jmp    80107ae7 <alltraps>

801082fc <vector56>:
.globl vector56
vector56:
  pushl $0
801082fc:	6a 00                	push   $0x0
  pushl $56
801082fe:	6a 38                	push   $0x38
  jmp alltraps
80108300:	e9 e2 f7 ff ff       	jmp    80107ae7 <alltraps>

80108305 <vector57>:
.globl vector57
vector57:
  pushl $0
80108305:	6a 00                	push   $0x0
  pushl $57
80108307:	6a 39                	push   $0x39
  jmp alltraps
80108309:	e9 d9 f7 ff ff       	jmp    80107ae7 <alltraps>

8010830e <vector58>:
.globl vector58
vector58:
  pushl $0
8010830e:	6a 00                	push   $0x0
  pushl $58
80108310:	6a 3a                	push   $0x3a
  jmp alltraps
80108312:	e9 d0 f7 ff ff       	jmp    80107ae7 <alltraps>

80108317 <vector59>:
.globl vector59
vector59:
  pushl $0
80108317:	6a 00                	push   $0x0
  pushl $59
80108319:	6a 3b                	push   $0x3b
  jmp alltraps
8010831b:	e9 c7 f7 ff ff       	jmp    80107ae7 <alltraps>

80108320 <vector60>:
.globl vector60
vector60:
  pushl $0
80108320:	6a 00                	push   $0x0
  pushl $60
80108322:	6a 3c                	push   $0x3c
  jmp alltraps
80108324:	e9 be f7 ff ff       	jmp    80107ae7 <alltraps>

80108329 <vector61>:
.globl vector61
vector61:
  pushl $0
80108329:	6a 00                	push   $0x0
  pushl $61
8010832b:	6a 3d                	push   $0x3d
  jmp alltraps
8010832d:	e9 b5 f7 ff ff       	jmp    80107ae7 <alltraps>

80108332 <vector62>:
.globl vector62
vector62:
  pushl $0
80108332:	6a 00                	push   $0x0
  pushl $62
80108334:	6a 3e                	push   $0x3e
  jmp alltraps
80108336:	e9 ac f7 ff ff       	jmp    80107ae7 <alltraps>

8010833b <vector63>:
.globl vector63
vector63:
  pushl $0
8010833b:	6a 00                	push   $0x0
  pushl $63
8010833d:	6a 3f                	push   $0x3f
  jmp alltraps
8010833f:	e9 a3 f7 ff ff       	jmp    80107ae7 <alltraps>

80108344 <vector64>:
.globl vector64
vector64:
  pushl $0
80108344:	6a 00                	push   $0x0
  pushl $64
80108346:	6a 40                	push   $0x40
  jmp alltraps
80108348:	e9 9a f7 ff ff       	jmp    80107ae7 <alltraps>

8010834d <vector65>:
.globl vector65
vector65:
  pushl $0
8010834d:	6a 00                	push   $0x0
  pushl $65
8010834f:	6a 41                	push   $0x41
  jmp alltraps
80108351:	e9 91 f7 ff ff       	jmp    80107ae7 <alltraps>

80108356 <vector66>:
.globl vector66
vector66:
  pushl $0
80108356:	6a 00                	push   $0x0
  pushl $66
80108358:	6a 42                	push   $0x42
  jmp alltraps
8010835a:	e9 88 f7 ff ff       	jmp    80107ae7 <alltraps>

8010835f <vector67>:
.globl vector67
vector67:
  pushl $0
8010835f:	6a 00                	push   $0x0
  pushl $67
80108361:	6a 43                	push   $0x43
  jmp alltraps
80108363:	e9 7f f7 ff ff       	jmp    80107ae7 <alltraps>

80108368 <vector68>:
.globl vector68
vector68:
  pushl $0
80108368:	6a 00                	push   $0x0
  pushl $68
8010836a:	6a 44                	push   $0x44
  jmp alltraps
8010836c:	e9 76 f7 ff ff       	jmp    80107ae7 <alltraps>

80108371 <vector69>:
.globl vector69
vector69:
  pushl $0
80108371:	6a 00                	push   $0x0
  pushl $69
80108373:	6a 45                	push   $0x45
  jmp alltraps
80108375:	e9 6d f7 ff ff       	jmp    80107ae7 <alltraps>

8010837a <vector70>:
.globl vector70
vector70:
  pushl $0
8010837a:	6a 00                	push   $0x0
  pushl $70
8010837c:	6a 46                	push   $0x46
  jmp alltraps
8010837e:	e9 64 f7 ff ff       	jmp    80107ae7 <alltraps>

80108383 <vector71>:
.globl vector71
vector71:
  pushl $0
80108383:	6a 00                	push   $0x0
  pushl $71
80108385:	6a 47                	push   $0x47
  jmp alltraps
80108387:	e9 5b f7 ff ff       	jmp    80107ae7 <alltraps>

8010838c <vector72>:
.globl vector72
vector72:
  pushl $0
8010838c:	6a 00                	push   $0x0
  pushl $72
8010838e:	6a 48                	push   $0x48
  jmp alltraps
80108390:	e9 52 f7 ff ff       	jmp    80107ae7 <alltraps>

80108395 <vector73>:
.globl vector73
vector73:
  pushl $0
80108395:	6a 00                	push   $0x0
  pushl $73
80108397:	6a 49                	push   $0x49
  jmp alltraps
80108399:	e9 49 f7 ff ff       	jmp    80107ae7 <alltraps>

8010839e <vector74>:
.globl vector74
vector74:
  pushl $0
8010839e:	6a 00                	push   $0x0
  pushl $74
801083a0:	6a 4a                	push   $0x4a
  jmp alltraps
801083a2:	e9 40 f7 ff ff       	jmp    80107ae7 <alltraps>

801083a7 <vector75>:
.globl vector75
vector75:
  pushl $0
801083a7:	6a 00                	push   $0x0
  pushl $75
801083a9:	6a 4b                	push   $0x4b
  jmp alltraps
801083ab:	e9 37 f7 ff ff       	jmp    80107ae7 <alltraps>

801083b0 <vector76>:
.globl vector76
vector76:
  pushl $0
801083b0:	6a 00                	push   $0x0
  pushl $76
801083b2:	6a 4c                	push   $0x4c
  jmp alltraps
801083b4:	e9 2e f7 ff ff       	jmp    80107ae7 <alltraps>

801083b9 <vector77>:
.globl vector77
vector77:
  pushl $0
801083b9:	6a 00                	push   $0x0
  pushl $77
801083bb:	6a 4d                	push   $0x4d
  jmp alltraps
801083bd:	e9 25 f7 ff ff       	jmp    80107ae7 <alltraps>

801083c2 <vector78>:
.globl vector78
vector78:
  pushl $0
801083c2:	6a 00                	push   $0x0
  pushl $78
801083c4:	6a 4e                	push   $0x4e
  jmp alltraps
801083c6:	e9 1c f7 ff ff       	jmp    80107ae7 <alltraps>

801083cb <vector79>:
.globl vector79
vector79:
  pushl $0
801083cb:	6a 00                	push   $0x0
  pushl $79
801083cd:	6a 4f                	push   $0x4f
  jmp alltraps
801083cf:	e9 13 f7 ff ff       	jmp    80107ae7 <alltraps>

801083d4 <vector80>:
.globl vector80
vector80:
  pushl $0
801083d4:	6a 00                	push   $0x0
  pushl $80
801083d6:	6a 50                	push   $0x50
  jmp alltraps
801083d8:	e9 0a f7 ff ff       	jmp    80107ae7 <alltraps>

801083dd <vector81>:
.globl vector81
vector81:
  pushl $0
801083dd:	6a 00                	push   $0x0
  pushl $81
801083df:	6a 51                	push   $0x51
  jmp alltraps
801083e1:	e9 01 f7 ff ff       	jmp    80107ae7 <alltraps>

801083e6 <vector82>:
.globl vector82
vector82:
  pushl $0
801083e6:	6a 00                	push   $0x0
  pushl $82
801083e8:	6a 52                	push   $0x52
  jmp alltraps
801083ea:	e9 f8 f6 ff ff       	jmp    80107ae7 <alltraps>

801083ef <vector83>:
.globl vector83
vector83:
  pushl $0
801083ef:	6a 00                	push   $0x0
  pushl $83
801083f1:	6a 53                	push   $0x53
  jmp alltraps
801083f3:	e9 ef f6 ff ff       	jmp    80107ae7 <alltraps>

801083f8 <vector84>:
.globl vector84
vector84:
  pushl $0
801083f8:	6a 00                	push   $0x0
  pushl $84
801083fa:	6a 54                	push   $0x54
  jmp alltraps
801083fc:	e9 e6 f6 ff ff       	jmp    80107ae7 <alltraps>

80108401 <vector85>:
.globl vector85
vector85:
  pushl $0
80108401:	6a 00                	push   $0x0
  pushl $85
80108403:	6a 55                	push   $0x55
  jmp alltraps
80108405:	e9 dd f6 ff ff       	jmp    80107ae7 <alltraps>

8010840a <vector86>:
.globl vector86
vector86:
  pushl $0
8010840a:	6a 00                	push   $0x0
  pushl $86
8010840c:	6a 56                	push   $0x56
  jmp alltraps
8010840e:	e9 d4 f6 ff ff       	jmp    80107ae7 <alltraps>

80108413 <vector87>:
.globl vector87
vector87:
  pushl $0
80108413:	6a 00                	push   $0x0
  pushl $87
80108415:	6a 57                	push   $0x57
  jmp alltraps
80108417:	e9 cb f6 ff ff       	jmp    80107ae7 <alltraps>

8010841c <vector88>:
.globl vector88
vector88:
  pushl $0
8010841c:	6a 00                	push   $0x0
  pushl $88
8010841e:	6a 58                	push   $0x58
  jmp alltraps
80108420:	e9 c2 f6 ff ff       	jmp    80107ae7 <alltraps>

80108425 <vector89>:
.globl vector89
vector89:
  pushl $0
80108425:	6a 00                	push   $0x0
  pushl $89
80108427:	6a 59                	push   $0x59
  jmp alltraps
80108429:	e9 b9 f6 ff ff       	jmp    80107ae7 <alltraps>

8010842e <vector90>:
.globl vector90
vector90:
  pushl $0
8010842e:	6a 00                	push   $0x0
  pushl $90
80108430:	6a 5a                	push   $0x5a
  jmp alltraps
80108432:	e9 b0 f6 ff ff       	jmp    80107ae7 <alltraps>

80108437 <vector91>:
.globl vector91
vector91:
  pushl $0
80108437:	6a 00                	push   $0x0
  pushl $91
80108439:	6a 5b                	push   $0x5b
  jmp alltraps
8010843b:	e9 a7 f6 ff ff       	jmp    80107ae7 <alltraps>

80108440 <vector92>:
.globl vector92
vector92:
  pushl $0
80108440:	6a 00                	push   $0x0
  pushl $92
80108442:	6a 5c                	push   $0x5c
  jmp alltraps
80108444:	e9 9e f6 ff ff       	jmp    80107ae7 <alltraps>

80108449 <vector93>:
.globl vector93
vector93:
  pushl $0
80108449:	6a 00                	push   $0x0
  pushl $93
8010844b:	6a 5d                	push   $0x5d
  jmp alltraps
8010844d:	e9 95 f6 ff ff       	jmp    80107ae7 <alltraps>

80108452 <vector94>:
.globl vector94
vector94:
  pushl $0
80108452:	6a 00                	push   $0x0
  pushl $94
80108454:	6a 5e                	push   $0x5e
  jmp alltraps
80108456:	e9 8c f6 ff ff       	jmp    80107ae7 <alltraps>

8010845b <vector95>:
.globl vector95
vector95:
  pushl $0
8010845b:	6a 00                	push   $0x0
  pushl $95
8010845d:	6a 5f                	push   $0x5f
  jmp alltraps
8010845f:	e9 83 f6 ff ff       	jmp    80107ae7 <alltraps>

80108464 <vector96>:
.globl vector96
vector96:
  pushl $0
80108464:	6a 00                	push   $0x0
  pushl $96
80108466:	6a 60                	push   $0x60
  jmp alltraps
80108468:	e9 7a f6 ff ff       	jmp    80107ae7 <alltraps>

8010846d <vector97>:
.globl vector97
vector97:
  pushl $0
8010846d:	6a 00                	push   $0x0
  pushl $97
8010846f:	6a 61                	push   $0x61
  jmp alltraps
80108471:	e9 71 f6 ff ff       	jmp    80107ae7 <alltraps>

80108476 <vector98>:
.globl vector98
vector98:
  pushl $0
80108476:	6a 00                	push   $0x0
  pushl $98
80108478:	6a 62                	push   $0x62
  jmp alltraps
8010847a:	e9 68 f6 ff ff       	jmp    80107ae7 <alltraps>

8010847f <vector99>:
.globl vector99
vector99:
  pushl $0
8010847f:	6a 00                	push   $0x0
  pushl $99
80108481:	6a 63                	push   $0x63
  jmp alltraps
80108483:	e9 5f f6 ff ff       	jmp    80107ae7 <alltraps>

80108488 <vector100>:
.globl vector100
vector100:
  pushl $0
80108488:	6a 00                	push   $0x0
  pushl $100
8010848a:	6a 64                	push   $0x64
  jmp alltraps
8010848c:	e9 56 f6 ff ff       	jmp    80107ae7 <alltraps>

80108491 <vector101>:
.globl vector101
vector101:
  pushl $0
80108491:	6a 00                	push   $0x0
  pushl $101
80108493:	6a 65                	push   $0x65
  jmp alltraps
80108495:	e9 4d f6 ff ff       	jmp    80107ae7 <alltraps>

8010849a <vector102>:
.globl vector102
vector102:
  pushl $0
8010849a:	6a 00                	push   $0x0
  pushl $102
8010849c:	6a 66                	push   $0x66
  jmp alltraps
8010849e:	e9 44 f6 ff ff       	jmp    80107ae7 <alltraps>

801084a3 <vector103>:
.globl vector103
vector103:
  pushl $0
801084a3:	6a 00                	push   $0x0
  pushl $103
801084a5:	6a 67                	push   $0x67
  jmp alltraps
801084a7:	e9 3b f6 ff ff       	jmp    80107ae7 <alltraps>

801084ac <vector104>:
.globl vector104
vector104:
  pushl $0
801084ac:	6a 00                	push   $0x0
  pushl $104
801084ae:	6a 68                	push   $0x68
  jmp alltraps
801084b0:	e9 32 f6 ff ff       	jmp    80107ae7 <alltraps>

801084b5 <vector105>:
.globl vector105
vector105:
  pushl $0
801084b5:	6a 00                	push   $0x0
  pushl $105
801084b7:	6a 69                	push   $0x69
  jmp alltraps
801084b9:	e9 29 f6 ff ff       	jmp    80107ae7 <alltraps>

801084be <vector106>:
.globl vector106
vector106:
  pushl $0
801084be:	6a 00                	push   $0x0
  pushl $106
801084c0:	6a 6a                	push   $0x6a
  jmp alltraps
801084c2:	e9 20 f6 ff ff       	jmp    80107ae7 <alltraps>

801084c7 <vector107>:
.globl vector107
vector107:
  pushl $0
801084c7:	6a 00                	push   $0x0
  pushl $107
801084c9:	6a 6b                	push   $0x6b
  jmp alltraps
801084cb:	e9 17 f6 ff ff       	jmp    80107ae7 <alltraps>

801084d0 <vector108>:
.globl vector108
vector108:
  pushl $0
801084d0:	6a 00                	push   $0x0
  pushl $108
801084d2:	6a 6c                	push   $0x6c
  jmp alltraps
801084d4:	e9 0e f6 ff ff       	jmp    80107ae7 <alltraps>

801084d9 <vector109>:
.globl vector109
vector109:
  pushl $0
801084d9:	6a 00                	push   $0x0
  pushl $109
801084db:	6a 6d                	push   $0x6d
  jmp alltraps
801084dd:	e9 05 f6 ff ff       	jmp    80107ae7 <alltraps>

801084e2 <vector110>:
.globl vector110
vector110:
  pushl $0
801084e2:	6a 00                	push   $0x0
  pushl $110
801084e4:	6a 6e                	push   $0x6e
  jmp alltraps
801084e6:	e9 fc f5 ff ff       	jmp    80107ae7 <alltraps>

801084eb <vector111>:
.globl vector111
vector111:
  pushl $0
801084eb:	6a 00                	push   $0x0
  pushl $111
801084ed:	6a 6f                	push   $0x6f
  jmp alltraps
801084ef:	e9 f3 f5 ff ff       	jmp    80107ae7 <alltraps>

801084f4 <vector112>:
.globl vector112
vector112:
  pushl $0
801084f4:	6a 00                	push   $0x0
  pushl $112
801084f6:	6a 70                	push   $0x70
  jmp alltraps
801084f8:	e9 ea f5 ff ff       	jmp    80107ae7 <alltraps>

801084fd <vector113>:
.globl vector113
vector113:
  pushl $0
801084fd:	6a 00                	push   $0x0
  pushl $113
801084ff:	6a 71                	push   $0x71
  jmp alltraps
80108501:	e9 e1 f5 ff ff       	jmp    80107ae7 <alltraps>

80108506 <vector114>:
.globl vector114
vector114:
  pushl $0
80108506:	6a 00                	push   $0x0
  pushl $114
80108508:	6a 72                	push   $0x72
  jmp alltraps
8010850a:	e9 d8 f5 ff ff       	jmp    80107ae7 <alltraps>

8010850f <vector115>:
.globl vector115
vector115:
  pushl $0
8010850f:	6a 00                	push   $0x0
  pushl $115
80108511:	6a 73                	push   $0x73
  jmp alltraps
80108513:	e9 cf f5 ff ff       	jmp    80107ae7 <alltraps>

80108518 <vector116>:
.globl vector116
vector116:
  pushl $0
80108518:	6a 00                	push   $0x0
  pushl $116
8010851a:	6a 74                	push   $0x74
  jmp alltraps
8010851c:	e9 c6 f5 ff ff       	jmp    80107ae7 <alltraps>

80108521 <vector117>:
.globl vector117
vector117:
  pushl $0
80108521:	6a 00                	push   $0x0
  pushl $117
80108523:	6a 75                	push   $0x75
  jmp alltraps
80108525:	e9 bd f5 ff ff       	jmp    80107ae7 <alltraps>

8010852a <vector118>:
.globl vector118
vector118:
  pushl $0
8010852a:	6a 00                	push   $0x0
  pushl $118
8010852c:	6a 76                	push   $0x76
  jmp alltraps
8010852e:	e9 b4 f5 ff ff       	jmp    80107ae7 <alltraps>

80108533 <vector119>:
.globl vector119
vector119:
  pushl $0
80108533:	6a 00                	push   $0x0
  pushl $119
80108535:	6a 77                	push   $0x77
  jmp alltraps
80108537:	e9 ab f5 ff ff       	jmp    80107ae7 <alltraps>

8010853c <vector120>:
.globl vector120
vector120:
  pushl $0
8010853c:	6a 00                	push   $0x0
  pushl $120
8010853e:	6a 78                	push   $0x78
  jmp alltraps
80108540:	e9 a2 f5 ff ff       	jmp    80107ae7 <alltraps>

80108545 <vector121>:
.globl vector121
vector121:
  pushl $0
80108545:	6a 00                	push   $0x0
  pushl $121
80108547:	6a 79                	push   $0x79
  jmp alltraps
80108549:	e9 99 f5 ff ff       	jmp    80107ae7 <alltraps>

8010854e <vector122>:
.globl vector122
vector122:
  pushl $0
8010854e:	6a 00                	push   $0x0
  pushl $122
80108550:	6a 7a                	push   $0x7a
  jmp alltraps
80108552:	e9 90 f5 ff ff       	jmp    80107ae7 <alltraps>

80108557 <vector123>:
.globl vector123
vector123:
  pushl $0
80108557:	6a 00                	push   $0x0
  pushl $123
80108559:	6a 7b                	push   $0x7b
  jmp alltraps
8010855b:	e9 87 f5 ff ff       	jmp    80107ae7 <alltraps>

80108560 <vector124>:
.globl vector124
vector124:
  pushl $0
80108560:	6a 00                	push   $0x0
  pushl $124
80108562:	6a 7c                	push   $0x7c
  jmp alltraps
80108564:	e9 7e f5 ff ff       	jmp    80107ae7 <alltraps>

80108569 <vector125>:
.globl vector125
vector125:
  pushl $0
80108569:	6a 00                	push   $0x0
  pushl $125
8010856b:	6a 7d                	push   $0x7d
  jmp alltraps
8010856d:	e9 75 f5 ff ff       	jmp    80107ae7 <alltraps>

80108572 <vector126>:
.globl vector126
vector126:
  pushl $0
80108572:	6a 00                	push   $0x0
  pushl $126
80108574:	6a 7e                	push   $0x7e
  jmp alltraps
80108576:	e9 6c f5 ff ff       	jmp    80107ae7 <alltraps>

8010857b <vector127>:
.globl vector127
vector127:
  pushl $0
8010857b:	6a 00                	push   $0x0
  pushl $127
8010857d:	6a 7f                	push   $0x7f
  jmp alltraps
8010857f:	e9 63 f5 ff ff       	jmp    80107ae7 <alltraps>

80108584 <vector128>:
.globl vector128
vector128:
  pushl $0
80108584:	6a 00                	push   $0x0
  pushl $128
80108586:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010858b:	e9 57 f5 ff ff       	jmp    80107ae7 <alltraps>

80108590 <vector129>:
.globl vector129
vector129:
  pushl $0
80108590:	6a 00                	push   $0x0
  pushl $129
80108592:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108597:	e9 4b f5 ff ff       	jmp    80107ae7 <alltraps>

8010859c <vector130>:
.globl vector130
vector130:
  pushl $0
8010859c:	6a 00                	push   $0x0
  pushl $130
8010859e:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801085a3:	e9 3f f5 ff ff       	jmp    80107ae7 <alltraps>

801085a8 <vector131>:
.globl vector131
vector131:
  pushl $0
801085a8:	6a 00                	push   $0x0
  pushl $131
801085aa:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801085af:	e9 33 f5 ff ff       	jmp    80107ae7 <alltraps>

801085b4 <vector132>:
.globl vector132
vector132:
  pushl $0
801085b4:	6a 00                	push   $0x0
  pushl $132
801085b6:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801085bb:	e9 27 f5 ff ff       	jmp    80107ae7 <alltraps>

801085c0 <vector133>:
.globl vector133
vector133:
  pushl $0
801085c0:	6a 00                	push   $0x0
  pushl $133
801085c2:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801085c7:	e9 1b f5 ff ff       	jmp    80107ae7 <alltraps>

801085cc <vector134>:
.globl vector134
vector134:
  pushl $0
801085cc:	6a 00                	push   $0x0
  pushl $134
801085ce:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801085d3:	e9 0f f5 ff ff       	jmp    80107ae7 <alltraps>

801085d8 <vector135>:
.globl vector135
vector135:
  pushl $0
801085d8:	6a 00                	push   $0x0
  pushl $135
801085da:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801085df:	e9 03 f5 ff ff       	jmp    80107ae7 <alltraps>

801085e4 <vector136>:
.globl vector136
vector136:
  pushl $0
801085e4:	6a 00                	push   $0x0
  pushl $136
801085e6:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801085eb:	e9 f7 f4 ff ff       	jmp    80107ae7 <alltraps>

801085f0 <vector137>:
.globl vector137
vector137:
  pushl $0
801085f0:	6a 00                	push   $0x0
  pushl $137
801085f2:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801085f7:	e9 eb f4 ff ff       	jmp    80107ae7 <alltraps>

801085fc <vector138>:
.globl vector138
vector138:
  pushl $0
801085fc:	6a 00                	push   $0x0
  pushl $138
801085fe:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108603:	e9 df f4 ff ff       	jmp    80107ae7 <alltraps>

80108608 <vector139>:
.globl vector139
vector139:
  pushl $0
80108608:	6a 00                	push   $0x0
  pushl $139
8010860a:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010860f:	e9 d3 f4 ff ff       	jmp    80107ae7 <alltraps>

80108614 <vector140>:
.globl vector140
vector140:
  pushl $0
80108614:	6a 00                	push   $0x0
  pushl $140
80108616:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010861b:	e9 c7 f4 ff ff       	jmp    80107ae7 <alltraps>

80108620 <vector141>:
.globl vector141
vector141:
  pushl $0
80108620:	6a 00                	push   $0x0
  pushl $141
80108622:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108627:	e9 bb f4 ff ff       	jmp    80107ae7 <alltraps>

8010862c <vector142>:
.globl vector142
vector142:
  pushl $0
8010862c:	6a 00                	push   $0x0
  pushl $142
8010862e:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108633:	e9 af f4 ff ff       	jmp    80107ae7 <alltraps>

80108638 <vector143>:
.globl vector143
vector143:
  pushl $0
80108638:	6a 00                	push   $0x0
  pushl $143
8010863a:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010863f:	e9 a3 f4 ff ff       	jmp    80107ae7 <alltraps>

80108644 <vector144>:
.globl vector144
vector144:
  pushl $0
80108644:	6a 00                	push   $0x0
  pushl $144
80108646:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010864b:	e9 97 f4 ff ff       	jmp    80107ae7 <alltraps>

80108650 <vector145>:
.globl vector145
vector145:
  pushl $0
80108650:	6a 00                	push   $0x0
  pushl $145
80108652:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108657:	e9 8b f4 ff ff       	jmp    80107ae7 <alltraps>

8010865c <vector146>:
.globl vector146
vector146:
  pushl $0
8010865c:	6a 00                	push   $0x0
  pushl $146
8010865e:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108663:	e9 7f f4 ff ff       	jmp    80107ae7 <alltraps>

80108668 <vector147>:
.globl vector147
vector147:
  pushl $0
80108668:	6a 00                	push   $0x0
  pushl $147
8010866a:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010866f:	e9 73 f4 ff ff       	jmp    80107ae7 <alltraps>

80108674 <vector148>:
.globl vector148
vector148:
  pushl $0
80108674:	6a 00                	push   $0x0
  pushl $148
80108676:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010867b:	e9 67 f4 ff ff       	jmp    80107ae7 <alltraps>

80108680 <vector149>:
.globl vector149
vector149:
  pushl $0
80108680:	6a 00                	push   $0x0
  pushl $149
80108682:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108687:	e9 5b f4 ff ff       	jmp    80107ae7 <alltraps>

8010868c <vector150>:
.globl vector150
vector150:
  pushl $0
8010868c:	6a 00                	push   $0x0
  pushl $150
8010868e:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108693:	e9 4f f4 ff ff       	jmp    80107ae7 <alltraps>

80108698 <vector151>:
.globl vector151
vector151:
  pushl $0
80108698:	6a 00                	push   $0x0
  pushl $151
8010869a:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010869f:	e9 43 f4 ff ff       	jmp    80107ae7 <alltraps>

801086a4 <vector152>:
.globl vector152
vector152:
  pushl $0
801086a4:	6a 00                	push   $0x0
  pushl $152
801086a6:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801086ab:	e9 37 f4 ff ff       	jmp    80107ae7 <alltraps>

801086b0 <vector153>:
.globl vector153
vector153:
  pushl $0
801086b0:	6a 00                	push   $0x0
  pushl $153
801086b2:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801086b7:	e9 2b f4 ff ff       	jmp    80107ae7 <alltraps>

801086bc <vector154>:
.globl vector154
vector154:
  pushl $0
801086bc:	6a 00                	push   $0x0
  pushl $154
801086be:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801086c3:	e9 1f f4 ff ff       	jmp    80107ae7 <alltraps>

801086c8 <vector155>:
.globl vector155
vector155:
  pushl $0
801086c8:	6a 00                	push   $0x0
  pushl $155
801086ca:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801086cf:	e9 13 f4 ff ff       	jmp    80107ae7 <alltraps>

801086d4 <vector156>:
.globl vector156
vector156:
  pushl $0
801086d4:	6a 00                	push   $0x0
  pushl $156
801086d6:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801086db:	e9 07 f4 ff ff       	jmp    80107ae7 <alltraps>

801086e0 <vector157>:
.globl vector157
vector157:
  pushl $0
801086e0:	6a 00                	push   $0x0
  pushl $157
801086e2:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801086e7:	e9 fb f3 ff ff       	jmp    80107ae7 <alltraps>

801086ec <vector158>:
.globl vector158
vector158:
  pushl $0
801086ec:	6a 00                	push   $0x0
  pushl $158
801086ee:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801086f3:	e9 ef f3 ff ff       	jmp    80107ae7 <alltraps>

801086f8 <vector159>:
.globl vector159
vector159:
  pushl $0
801086f8:	6a 00                	push   $0x0
  pushl $159
801086fa:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801086ff:	e9 e3 f3 ff ff       	jmp    80107ae7 <alltraps>

80108704 <vector160>:
.globl vector160
vector160:
  pushl $0
80108704:	6a 00                	push   $0x0
  pushl $160
80108706:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010870b:	e9 d7 f3 ff ff       	jmp    80107ae7 <alltraps>

80108710 <vector161>:
.globl vector161
vector161:
  pushl $0
80108710:	6a 00                	push   $0x0
  pushl $161
80108712:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108717:	e9 cb f3 ff ff       	jmp    80107ae7 <alltraps>

8010871c <vector162>:
.globl vector162
vector162:
  pushl $0
8010871c:	6a 00                	push   $0x0
  pushl $162
8010871e:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108723:	e9 bf f3 ff ff       	jmp    80107ae7 <alltraps>

80108728 <vector163>:
.globl vector163
vector163:
  pushl $0
80108728:	6a 00                	push   $0x0
  pushl $163
8010872a:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010872f:	e9 b3 f3 ff ff       	jmp    80107ae7 <alltraps>

80108734 <vector164>:
.globl vector164
vector164:
  pushl $0
80108734:	6a 00                	push   $0x0
  pushl $164
80108736:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010873b:	e9 a7 f3 ff ff       	jmp    80107ae7 <alltraps>

80108740 <vector165>:
.globl vector165
vector165:
  pushl $0
80108740:	6a 00                	push   $0x0
  pushl $165
80108742:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108747:	e9 9b f3 ff ff       	jmp    80107ae7 <alltraps>

8010874c <vector166>:
.globl vector166
vector166:
  pushl $0
8010874c:	6a 00                	push   $0x0
  pushl $166
8010874e:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108753:	e9 8f f3 ff ff       	jmp    80107ae7 <alltraps>

80108758 <vector167>:
.globl vector167
vector167:
  pushl $0
80108758:	6a 00                	push   $0x0
  pushl $167
8010875a:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010875f:	e9 83 f3 ff ff       	jmp    80107ae7 <alltraps>

80108764 <vector168>:
.globl vector168
vector168:
  pushl $0
80108764:	6a 00                	push   $0x0
  pushl $168
80108766:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010876b:	e9 77 f3 ff ff       	jmp    80107ae7 <alltraps>

80108770 <vector169>:
.globl vector169
vector169:
  pushl $0
80108770:	6a 00                	push   $0x0
  pushl $169
80108772:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108777:	e9 6b f3 ff ff       	jmp    80107ae7 <alltraps>

8010877c <vector170>:
.globl vector170
vector170:
  pushl $0
8010877c:	6a 00                	push   $0x0
  pushl $170
8010877e:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108783:	e9 5f f3 ff ff       	jmp    80107ae7 <alltraps>

80108788 <vector171>:
.globl vector171
vector171:
  pushl $0
80108788:	6a 00                	push   $0x0
  pushl $171
8010878a:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010878f:	e9 53 f3 ff ff       	jmp    80107ae7 <alltraps>

80108794 <vector172>:
.globl vector172
vector172:
  pushl $0
80108794:	6a 00                	push   $0x0
  pushl $172
80108796:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010879b:	e9 47 f3 ff ff       	jmp    80107ae7 <alltraps>

801087a0 <vector173>:
.globl vector173
vector173:
  pushl $0
801087a0:	6a 00                	push   $0x0
  pushl $173
801087a2:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801087a7:	e9 3b f3 ff ff       	jmp    80107ae7 <alltraps>

801087ac <vector174>:
.globl vector174
vector174:
  pushl $0
801087ac:	6a 00                	push   $0x0
  pushl $174
801087ae:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801087b3:	e9 2f f3 ff ff       	jmp    80107ae7 <alltraps>

801087b8 <vector175>:
.globl vector175
vector175:
  pushl $0
801087b8:	6a 00                	push   $0x0
  pushl $175
801087ba:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801087bf:	e9 23 f3 ff ff       	jmp    80107ae7 <alltraps>

801087c4 <vector176>:
.globl vector176
vector176:
  pushl $0
801087c4:	6a 00                	push   $0x0
  pushl $176
801087c6:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801087cb:	e9 17 f3 ff ff       	jmp    80107ae7 <alltraps>

801087d0 <vector177>:
.globl vector177
vector177:
  pushl $0
801087d0:	6a 00                	push   $0x0
  pushl $177
801087d2:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801087d7:	e9 0b f3 ff ff       	jmp    80107ae7 <alltraps>

801087dc <vector178>:
.globl vector178
vector178:
  pushl $0
801087dc:	6a 00                	push   $0x0
  pushl $178
801087de:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801087e3:	e9 ff f2 ff ff       	jmp    80107ae7 <alltraps>

801087e8 <vector179>:
.globl vector179
vector179:
  pushl $0
801087e8:	6a 00                	push   $0x0
  pushl $179
801087ea:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801087ef:	e9 f3 f2 ff ff       	jmp    80107ae7 <alltraps>

801087f4 <vector180>:
.globl vector180
vector180:
  pushl $0
801087f4:	6a 00                	push   $0x0
  pushl $180
801087f6:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801087fb:	e9 e7 f2 ff ff       	jmp    80107ae7 <alltraps>

80108800 <vector181>:
.globl vector181
vector181:
  pushl $0
80108800:	6a 00                	push   $0x0
  pushl $181
80108802:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108807:	e9 db f2 ff ff       	jmp    80107ae7 <alltraps>

8010880c <vector182>:
.globl vector182
vector182:
  pushl $0
8010880c:	6a 00                	push   $0x0
  pushl $182
8010880e:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108813:	e9 cf f2 ff ff       	jmp    80107ae7 <alltraps>

80108818 <vector183>:
.globl vector183
vector183:
  pushl $0
80108818:	6a 00                	push   $0x0
  pushl $183
8010881a:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010881f:	e9 c3 f2 ff ff       	jmp    80107ae7 <alltraps>

80108824 <vector184>:
.globl vector184
vector184:
  pushl $0
80108824:	6a 00                	push   $0x0
  pushl $184
80108826:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010882b:	e9 b7 f2 ff ff       	jmp    80107ae7 <alltraps>

80108830 <vector185>:
.globl vector185
vector185:
  pushl $0
80108830:	6a 00                	push   $0x0
  pushl $185
80108832:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108837:	e9 ab f2 ff ff       	jmp    80107ae7 <alltraps>

8010883c <vector186>:
.globl vector186
vector186:
  pushl $0
8010883c:	6a 00                	push   $0x0
  pushl $186
8010883e:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108843:	e9 9f f2 ff ff       	jmp    80107ae7 <alltraps>

80108848 <vector187>:
.globl vector187
vector187:
  pushl $0
80108848:	6a 00                	push   $0x0
  pushl $187
8010884a:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010884f:	e9 93 f2 ff ff       	jmp    80107ae7 <alltraps>

80108854 <vector188>:
.globl vector188
vector188:
  pushl $0
80108854:	6a 00                	push   $0x0
  pushl $188
80108856:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010885b:	e9 87 f2 ff ff       	jmp    80107ae7 <alltraps>

80108860 <vector189>:
.globl vector189
vector189:
  pushl $0
80108860:	6a 00                	push   $0x0
  pushl $189
80108862:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108867:	e9 7b f2 ff ff       	jmp    80107ae7 <alltraps>

8010886c <vector190>:
.globl vector190
vector190:
  pushl $0
8010886c:	6a 00                	push   $0x0
  pushl $190
8010886e:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108873:	e9 6f f2 ff ff       	jmp    80107ae7 <alltraps>

80108878 <vector191>:
.globl vector191
vector191:
  pushl $0
80108878:	6a 00                	push   $0x0
  pushl $191
8010887a:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010887f:	e9 63 f2 ff ff       	jmp    80107ae7 <alltraps>

80108884 <vector192>:
.globl vector192
vector192:
  pushl $0
80108884:	6a 00                	push   $0x0
  pushl $192
80108886:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010888b:	e9 57 f2 ff ff       	jmp    80107ae7 <alltraps>

80108890 <vector193>:
.globl vector193
vector193:
  pushl $0
80108890:	6a 00                	push   $0x0
  pushl $193
80108892:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108897:	e9 4b f2 ff ff       	jmp    80107ae7 <alltraps>

8010889c <vector194>:
.globl vector194
vector194:
  pushl $0
8010889c:	6a 00                	push   $0x0
  pushl $194
8010889e:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801088a3:	e9 3f f2 ff ff       	jmp    80107ae7 <alltraps>

801088a8 <vector195>:
.globl vector195
vector195:
  pushl $0
801088a8:	6a 00                	push   $0x0
  pushl $195
801088aa:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801088af:	e9 33 f2 ff ff       	jmp    80107ae7 <alltraps>

801088b4 <vector196>:
.globl vector196
vector196:
  pushl $0
801088b4:	6a 00                	push   $0x0
  pushl $196
801088b6:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801088bb:	e9 27 f2 ff ff       	jmp    80107ae7 <alltraps>

801088c0 <vector197>:
.globl vector197
vector197:
  pushl $0
801088c0:	6a 00                	push   $0x0
  pushl $197
801088c2:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801088c7:	e9 1b f2 ff ff       	jmp    80107ae7 <alltraps>

801088cc <vector198>:
.globl vector198
vector198:
  pushl $0
801088cc:	6a 00                	push   $0x0
  pushl $198
801088ce:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801088d3:	e9 0f f2 ff ff       	jmp    80107ae7 <alltraps>

801088d8 <vector199>:
.globl vector199
vector199:
  pushl $0
801088d8:	6a 00                	push   $0x0
  pushl $199
801088da:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801088df:	e9 03 f2 ff ff       	jmp    80107ae7 <alltraps>

801088e4 <vector200>:
.globl vector200
vector200:
  pushl $0
801088e4:	6a 00                	push   $0x0
  pushl $200
801088e6:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801088eb:	e9 f7 f1 ff ff       	jmp    80107ae7 <alltraps>

801088f0 <vector201>:
.globl vector201
vector201:
  pushl $0
801088f0:	6a 00                	push   $0x0
  pushl $201
801088f2:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801088f7:	e9 eb f1 ff ff       	jmp    80107ae7 <alltraps>

801088fc <vector202>:
.globl vector202
vector202:
  pushl $0
801088fc:	6a 00                	push   $0x0
  pushl $202
801088fe:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108903:	e9 df f1 ff ff       	jmp    80107ae7 <alltraps>

80108908 <vector203>:
.globl vector203
vector203:
  pushl $0
80108908:	6a 00                	push   $0x0
  pushl $203
8010890a:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010890f:	e9 d3 f1 ff ff       	jmp    80107ae7 <alltraps>

80108914 <vector204>:
.globl vector204
vector204:
  pushl $0
80108914:	6a 00                	push   $0x0
  pushl $204
80108916:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010891b:	e9 c7 f1 ff ff       	jmp    80107ae7 <alltraps>

80108920 <vector205>:
.globl vector205
vector205:
  pushl $0
80108920:	6a 00                	push   $0x0
  pushl $205
80108922:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108927:	e9 bb f1 ff ff       	jmp    80107ae7 <alltraps>

8010892c <vector206>:
.globl vector206
vector206:
  pushl $0
8010892c:	6a 00                	push   $0x0
  pushl $206
8010892e:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108933:	e9 af f1 ff ff       	jmp    80107ae7 <alltraps>

80108938 <vector207>:
.globl vector207
vector207:
  pushl $0
80108938:	6a 00                	push   $0x0
  pushl $207
8010893a:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010893f:	e9 a3 f1 ff ff       	jmp    80107ae7 <alltraps>

80108944 <vector208>:
.globl vector208
vector208:
  pushl $0
80108944:	6a 00                	push   $0x0
  pushl $208
80108946:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010894b:	e9 97 f1 ff ff       	jmp    80107ae7 <alltraps>

80108950 <vector209>:
.globl vector209
vector209:
  pushl $0
80108950:	6a 00                	push   $0x0
  pushl $209
80108952:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108957:	e9 8b f1 ff ff       	jmp    80107ae7 <alltraps>

8010895c <vector210>:
.globl vector210
vector210:
  pushl $0
8010895c:	6a 00                	push   $0x0
  pushl $210
8010895e:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108963:	e9 7f f1 ff ff       	jmp    80107ae7 <alltraps>

80108968 <vector211>:
.globl vector211
vector211:
  pushl $0
80108968:	6a 00                	push   $0x0
  pushl $211
8010896a:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010896f:	e9 73 f1 ff ff       	jmp    80107ae7 <alltraps>

80108974 <vector212>:
.globl vector212
vector212:
  pushl $0
80108974:	6a 00                	push   $0x0
  pushl $212
80108976:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010897b:	e9 67 f1 ff ff       	jmp    80107ae7 <alltraps>

80108980 <vector213>:
.globl vector213
vector213:
  pushl $0
80108980:	6a 00                	push   $0x0
  pushl $213
80108982:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108987:	e9 5b f1 ff ff       	jmp    80107ae7 <alltraps>

8010898c <vector214>:
.globl vector214
vector214:
  pushl $0
8010898c:	6a 00                	push   $0x0
  pushl $214
8010898e:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108993:	e9 4f f1 ff ff       	jmp    80107ae7 <alltraps>

80108998 <vector215>:
.globl vector215
vector215:
  pushl $0
80108998:	6a 00                	push   $0x0
  pushl $215
8010899a:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010899f:	e9 43 f1 ff ff       	jmp    80107ae7 <alltraps>

801089a4 <vector216>:
.globl vector216
vector216:
  pushl $0
801089a4:	6a 00                	push   $0x0
  pushl $216
801089a6:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801089ab:	e9 37 f1 ff ff       	jmp    80107ae7 <alltraps>

801089b0 <vector217>:
.globl vector217
vector217:
  pushl $0
801089b0:	6a 00                	push   $0x0
  pushl $217
801089b2:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801089b7:	e9 2b f1 ff ff       	jmp    80107ae7 <alltraps>

801089bc <vector218>:
.globl vector218
vector218:
  pushl $0
801089bc:	6a 00                	push   $0x0
  pushl $218
801089be:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801089c3:	e9 1f f1 ff ff       	jmp    80107ae7 <alltraps>

801089c8 <vector219>:
.globl vector219
vector219:
  pushl $0
801089c8:	6a 00                	push   $0x0
  pushl $219
801089ca:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801089cf:	e9 13 f1 ff ff       	jmp    80107ae7 <alltraps>

801089d4 <vector220>:
.globl vector220
vector220:
  pushl $0
801089d4:	6a 00                	push   $0x0
  pushl $220
801089d6:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801089db:	e9 07 f1 ff ff       	jmp    80107ae7 <alltraps>

801089e0 <vector221>:
.globl vector221
vector221:
  pushl $0
801089e0:	6a 00                	push   $0x0
  pushl $221
801089e2:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801089e7:	e9 fb f0 ff ff       	jmp    80107ae7 <alltraps>

801089ec <vector222>:
.globl vector222
vector222:
  pushl $0
801089ec:	6a 00                	push   $0x0
  pushl $222
801089ee:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801089f3:	e9 ef f0 ff ff       	jmp    80107ae7 <alltraps>

801089f8 <vector223>:
.globl vector223
vector223:
  pushl $0
801089f8:	6a 00                	push   $0x0
  pushl $223
801089fa:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801089ff:	e9 e3 f0 ff ff       	jmp    80107ae7 <alltraps>

80108a04 <vector224>:
.globl vector224
vector224:
  pushl $0
80108a04:	6a 00                	push   $0x0
  pushl $224
80108a06:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108a0b:	e9 d7 f0 ff ff       	jmp    80107ae7 <alltraps>

80108a10 <vector225>:
.globl vector225
vector225:
  pushl $0
80108a10:	6a 00                	push   $0x0
  pushl $225
80108a12:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108a17:	e9 cb f0 ff ff       	jmp    80107ae7 <alltraps>

80108a1c <vector226>:
.globl vector226
vector226:
  pushl $0
80108a1c:	6a 00                	push   $0x0
  pushl $226
80108a1e:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108a23:	e9 bf f0 ff ff       	jmp    80107ae7 <alltraps>

80108a28 <vector227>:
.globl vector227
vector227:
  pushl $0
80108a28:	6a 00                	push   $0x0
  pushl $227
80108a2a:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108a2f:	e9 b3 f0 ff ff       	jmp    80107ae7 <alltraps>

80108a34 <vector228>:
.globl vector228
vector228:
  pushl $0
80108a34:	6a 00                	push   $0x0
  pushl $228
80108a36:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108a3b:	e9 a7 f0 ff ff       	jmp    80107ae7 <alltraps>

80108a40 <vector229>:
.globl vector229
vector229:
  pushl $0
80108a40:	6a 00                	push   $0x0
  pushl $229
80108a42:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108a47:	e9 9b f0 ff ff       	jmp    80107ae7 <alltraps>

80108a4c <vector230>:
.globl vector230
vector230:
  pushl $0
80108a4c:	6a 00                	push   $0x0
  pushl $230
80108a4e:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108a53:	e9 8f f0 ff ff       	jmp    80107ae7 <alltraps>

80108a58 <vector231>:
.globl vector231
vector231:
  pushl $0
80108a58:	6a 00                	push   $0x0
  pushl $231
80108a5a:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108a5f:	e9 83 f0 ff ff       	jmp    80107ae7 <alltraps>

80108a64 <vector232>:
.globl vector232
vector232:
  pushl $0
80108a64:	6a 00                	push   $0x0
  pushl $232
80108a66:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108a6b:	e9 77 f0 ff ff       	jmp    80107ae7 <alltraps>

80108a70 <vector233>:
.globl vector233
vector233:
  pushl $0
80108a70:	6a 00                	push   $0x0
  pushl $233
80108a72:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108a77:	e9 6b f0 ff ff       	jmp    80107ae7 <alltraps>

80108a7c <vector234>:
.globl vector234
vector234:
  pushl $0
80108a7c:	6a 00                	push   $0x0
  pushl $234
80108a7e:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108a83:	e9 5f f0 ff ff       	jmp    80107ae7 <alltraps>

80108a88 <vector235>:
.globl vector235
vector235:
  pushl $0
80108a88:	6a 00                	push   $0x0
  pushl $235
80108a8a:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108a8f:	e9 53 f0 ff ff       	jmp    80107ae7 <alltraps>

80108a94 <vector236>:
.globl vector236
vector236:
  pushl $0
80108a94:	6a 00                	push   $0x0
  pushl $236
80108a96:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108a9b:	e9 47 f0 ff ff       	jmp    80107ae7 <alltraps>

80108aa0 <vector237>:
.globl vector237
vector237:
  pushl $0
80108aa0:	6a 00                	push   $0x0
  pushl $237
80108aa2:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108aa7:	e9 3b f0 ff ff       	jmp    80107ae7 <alltraps>

80108aac <vector238>:
.globl vector238
vector238:
  pushl $0
80108aac:	6a 00                	push   $0x0
  pushl $238
80108aae:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108ab3:	e9 2f f0 ff ff       	jmp    80107ae7 <alltraps>

80108ab8 <vector239>:
.globl vector239
vector239:
  pushl $0
80108ab8:	6a 00                	push   $0x0
  pushl $239
80108aba:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108abf:	e9 23 f0 ff ff       	jmp    80107ae7 <alltraps>

80108ac4 <vector240>:
.globl vector240
vector240:
  pushl $0
80108ac4:	6a 00                	push   $0x0
  pushl $240
80108ac6:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108acb:	e9 17 f0 ff ff       	jmp    80107ae7 <alltraps>

80108ad0 <vector241>:
.globl vector241
vector241:
  pushl $0
80108ad0:	6a 00                	push   $0x0
  pushl $241
80108ad2:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108ad7:	e9 0b f0 ff ff       	jmp    80107ae7 <alltraps>

80108adc <vector242>:
.globl vector242
vector242:
  pushl $0
80108adc:	6a 00                	push   $0x0
  pushl $242
80108ade:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108ae3:	e9 ff ef ff ff       	jmp    80107ae7 <alltraps>

80108ae8 <vector243>:
.globl vector243
vector243:
  pushl $0
80108ae8:	6a 00                	push   $0x0
  pushl $243
80108aea:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108aef:	e9 f3 ef ff ff       	jmp    80107ae7 <alltraps>

80108af4 <vector244>:
.globl vector244
vector244:
  pushl $0
80108af4:	6a 00                	push   $0x0
  pushl $244
80108af6:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108afb:	e9 e7 ef ff ff       	jmp    80107ae7 <alltraps>

80108b00 <vector245>:
.globl vector245
vector245:
  pushl $0
80108b00:	6a 00                	push   $0x0
  pushl $245
80108b02:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108b07:	e9 db ef ff ff       	jmp    80107ae7 <alltraps>

80108b0c <vector246>:
.globl vector246
vector246:
  pushl $0
80108b0c:	6a 00                	push   $0x0
  pushl $246
80108b0e:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108b13:	e9 cf ef ff ff       	jmp    80107ae7 <alltraps>

80108b18 <vector247>:
.globl vector247
vector247:
  pushl $0
80108b18:	6a 00                	push   $0x0
  pushl $247
80108b1a:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108b1f:	e9 c3 ef ff ff       	jmp    80107ae7 <alltraps>

80108b24 <vector248>:
.globl vector248
vector248:
  pushl $0
80108b24:	6a 00                	push   $0x0
  pushl $248
80108b26:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108b2b:	e9 b7 ef ff ff       	jmp    80107ae7 <alltraps>

80108b30 <vector249>:
.globl vector249
vector249:
  pushl $0
80108b30:	6a 00                	push   $0x0
  pushl $249
80108b32:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108b37:	e9 ab ef ff ff       	jmp    80107ae7 <alltraps>

80108b3c <vector250>:
.globl vector250
vector250:
  pushl $0
80108b3c:	6a 00                	push   $0x0
  pushl $250
80108b3e:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108b43:	e9 9f ef ff ff       	jmp    80107ae7 <alltraps>

80108b48 <vector251>:
.globl vector251
vector251:
  pushl $0
80108b48:	6a 00                	push   $0x0
  pushl $251
80108b4a:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108b4f:	e9 93 ef ff ff       	jmp    80107ae7 <alltraps>

80108b54 <vector252>:
.globl vector252
vector252:
  pushl $0
80108b54:	6a 00                	push   $0x0
  pushl $252
80108b56:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108b5b:	e9 87 ef ff ff       	jmp    80107ae7 <alltraps>

80108b60 <vector253>:
.globl vector253
vector253:
  pushl $0
80108b60:	6a 00                	push   $0x0
  pushl $253
80108b62:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108b67:	e9 7b ef ff ff       	jmp    80107ae7 <alltraps>

80108b6c <vector254>:
.globl vector254
vector254:
  pushl $0
80108b6c:	6a 00                	push   $0x0
  pushl $254
80108b6e:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108b73:	e9 6f ef ff ff       	jmp    80107ae7 <alltraps>

80108b78 <vector255>:
.globl vector255
vector255:
  pushl $0
80108b78:	6a 00                	push   $0x0
  pushl $255
80108b7a:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108b7f:	e9 63 ef ff ff       	jmp    80107ae7 <alltraps>

80108b84 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108b84:	55                   	push   %ebp
80108b85:	89 e5                	mov    %esp,%ebp
80108b87:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b8d:	83 e8 01             	sub    $0x1,%eax
80108b90:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108b94:	8b 45 08             	mov    0x8(%ebp),%eax
80108b97:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108b9b:	8b 45 08             	mov    0x8(%ebp),%eax
80108b9e:	c1 e8 10             	shr    $0x10,%eax
80108ba1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108ba5:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108ba8:	0f 01 10             	lgdtl  (%eax)
}
80108bab:	90                   	nop
80108bac:	c9                   	leave  
80108bad:	c3                   	ret    

80108bae <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108bae:	55                   	push   %ebp
80108baf:	89 e5                	mov    %esp,%ebp
80108bb1:	83 ec 04             	sub    $0x4,%esp
80108bb4:	8b 45 08             	mov    0x8(%ebp),%eax
80108bb7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108bbb:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108bbf:	0f 00 d8             	ltr    %ax
}
80108bc2:	90                   	nop
80108bc3:	c9                   	leave  
80108bc4:	c3                   	ret    

80108bc5 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108bc5:	55                   	push   %ebp
80108bc6:	89 e5                	mov    %esp,%ebp
80108bc8:	83 ec 04             	sub    $0x4,%esp
80108bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80108bce:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108bd2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108bd6:	8e e8                	mov    %eax,%gs
}
80108bd8:	90                   	nop
80108bd9:	c9                   	leave  
80108bda:	c3                   	ret    

80108bdb <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108bdb:	55                   	push   %ebp
80108bdc:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108bde:	8b 45 08             	mov    0x8(%ebp),%eax
80108be1:	0f 22 d8             	mov    %eax,%cr3
}
80108be4:	90                   	nop
80108be5:	5d                   	pop    %ebp
80108be6:	c3                   	ret    

80108be7 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108be7:	55                   	push   %ebp
80108be8:	89 e5                	mov    %esp,%ebp
80108bea:	8b 45 08             	mov    0x8(%ebp),%eax
80108bed:	05 00 00 00 80       	add    $0x80000000,%eax
80108bf2:	5d                   	pop    %ebp
80108bf3:	c3                   	ret    

80108bf4 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108bf4:	55                   	push   %ebp
80108bf5:	89 e5                	mov    %esp,%ebp
80108bf7:	8b 45 08             	mov    0x8(%ebp),%eax
80108bfa:	05 00 00 00 80       	add    $0x80000000,%eax
80108bff:	5d                   	pop    %ebp
80108c00:	c3                   	ret    

80108c01 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108c01:	55                   	push   %ebp
80108c02:	89 e5                	mov    %esp,%ebp
80108c04:	53                   	push   %ebx
80108c05:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108c08:	e8 69 a4 ff ff       	call   80103076 <cpunum>
80108c0d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108c13:	05 80 43 11 80       	add    $0x80114380,%eax
80108c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c1e:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c27:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c30:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c37:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c3b:	83 e2 f0             	and    $0xfffffff0,%edx
80108c3e:	83 ca 0a             	or     $0xa,%edx
80108c41:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c47:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c4b:	83 ca 10             	or     $0x10,%edx
80108c4e:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c54:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c58:	83 e2 9f             	and    $0xffffff9f,%edx
80108c5b:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c61:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c65:	83 ca 80             	or     $0xffffff80,%edx
80108c68:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c6e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c72:	83 ca 0f             	or     $0xf,%edx
80108c75:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c7b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c7f:	83 e2 ef             	and    $0xffffffef,%edx
80108c82:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c88:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c8c:	83 e2 df             	and    $0xffffffdf,%edx
80108c8f:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c95:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c99:	83 ca 40             	or     $0x40,%edx
80108c9c:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ca2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108ca6:	83 ca 80             	or     $0xffffff80,%edx
80108ca9:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108caf:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb6:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108cbd:	ff ff 
80108cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc2:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108cc9:	00 00 
80108ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cce:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108cdf:	83 e2 f0             	and    $0xfffffff0,%edx
80108ce2:	83 ca 02             	or     $0x2,%edx
80108ce5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cee:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108cf5:	83 ca 10             	or     $0x10,%edx
80108cf8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d01:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d08:	83 e2 9f             	and    $0xffffff9f,%edx
80108d0b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d14:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d1b:	83 ca 80             	or     $0xffffff80,%edx
80108d1e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d27:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d2e:	83 ca 0f             	or     $0xf,%edx
80108d31:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d3a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d41:	83 e2 ef             	and    $0xffffffef,%edx
80108d44:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d4d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d54:	83 e2 df             	and    $0xffffffdf,%edx
80108d57:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d60:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d67:	83 ca 40             	or     $0x40,%edx
80108d6a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d73:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d7a:	83 ca 80             	or     $0xffffff80,%edx
80108d7d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d86:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d90:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108d97:	ff ff 
80108d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d9c:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108da3:	00 00 
80108da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da8:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108db9:	83 e2 f0             	and    $0xfffffff0,%edx
80108dbc:	83 ca 0a             	or     $0xa,%edx
80108dbf:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dc8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108dcf:	83 ca 10             	or     $0x10,%edx
80108dd2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ddb:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108de2:	83 ca 60             	or     $0x60,%edx
80108de5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dee:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108df5:	83 ca 80             	or     $0xffffff80,%edx
80108df8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e01:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e08:	83 ca 0f             	or     $0xf,%edx
80108e0b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e14:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e1b:	83 e2 ef             	and    $0xffffffef,%edx
80108e1e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e27:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e2e:	83 e2 df             	and    $0xffffffdf,%edx
80108e31:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e3a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e41:	83 ca 40             	or     $0x40,%edx
80108e44:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e4d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e54:	83 ca 80             	or     $0xffffff80,%edx
80108e57:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e60:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e6a:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108e71:	ff ff 
80108e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e76:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108e7d:	00 00 
80108e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e82:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e8c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108e93:	83 e2 f0             	and    $0xfffffff0,%edx
80108e96:	83 ca 02             	or     $0x2,%edx
80108e99:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ea2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ea9:	83 ca 10             	or     $0x10,%edx
80108eac:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ebc:	83 ca 60             	or     $0x60,%edx
80108ebf:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ec8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ecf:	83 ca 80             	or     $0xffffff80,%edx
80108ed2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108edb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ee2:	83 ca 0f             	or     $0xf,%edx
80108ee5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eee:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ef5:	83 e2 ef             	and    $0xffffffef,%edx
80108ef8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f01:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f08:	83 e2 df             	and    $0xffffffdf,%edx
80108f0b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f14:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f1b:	83 ca 40             	or     $0x40,%edx
80108f1e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f27:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f2e:	83 ca 80             	or     $0xffffff80,%edx
80108f31:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f3a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f44:	05 b4 00 00 00       	add    $0xb4,%eax
80108f49:	89 c3                	mov    %eax,%ebx
80108f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f4e:	05 b4 00 00 00       	add    $0xb4,%eax
80108f53:	c1 e8 10             	shr    $0x10,%eax
80108f56:	89 c2                	mov    %eax,%edx
80108f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f5b:	05 b4 00 00 00       	add    $0xb4,%eax
80108f60:	c1 e8 18             	shr    $0x18,%eax
80108f63:	89 c1                	mov    %eax,%ecx
80108f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f68:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108f6f:	00 00 
80108f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f74:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f7e:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f87:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108f8e:	83 e2 f0             	and    $0xfffffff0,%edx
80108f91:	83 ca 02             	or     $0x2,%edx
80108f94:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f9d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108fa4:	83 ca 10             	or     $0x10,%edx
80108fa7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fb0:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108fb7:	83 e2 9f             	and    $0xffffff9f,%edx
80108fba:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108fca:	83 ca 80             	or     $0xffffff80,%edx
80108fcd:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fd6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108fdd:	83 e2 f0             	and    $0xfffffff0,%edx
80108fe0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fe9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108ff0:	83 e2 ef             	and    $0xffffffef,%edx
80108ff3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ffc:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109003:	83 e2 df             	and    $0xffffffdf,%edx
80109006:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010900c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010900f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109016:	83 ca 40             	or     $0x40,%edx
80109019:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010901f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109022:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109029:	83 ca 80             	or     $0xffffff80,%edx
8010902c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109032:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109035:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010903b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010903e:	83 c0 70             	add    $0x70,%eax
80109041:	83 ec 08             	sub    $0x8,%esp
80109044:	6a 38                	push   $0x38
80109046:	50                   	push   %eax
80109047:	e8 38 fb ff ff       	call   80108b84 <lgdt>
8010904c:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010904f:	83 ec 0c             	sub    $0xc,%esp
80109052:	6a 18                	push   $0x18
80109054:	e8 6c fb ff ff       	call   80108bc5 <loadgs>
80109059:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
8010905c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010905f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80109065:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010906c:	00 00 00 00 
}
80109070:	90                   	nop
80109071:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109074:	c9                   	leave  
80109075:	c3                   	ret    

80109076 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80109076:	55                   	push   %ebp
80109077:	89 e5                	mov    %esp,%ebp
80109079:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010907c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010907f:	c1 e8 16             	shr    $0x16,%eax
80109082:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109089:	8b 45 08             	mov    0x8(%ebp),%eax
8010908c:	01 d0                	add    %edx,%eax
8010908e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80109091:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109094:	8b 00                	mov    (%eax),%eax
80109096:	83 e0 01             	and    $0x1,%eax
80109099:	85 c0                	test   %eax,%eax
8010909b:	74 18                	je     801090b5 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010909d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090a0:	8b 00                	mov    (%eax),%eax
801090a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090a7:	50                   	push   %eax
801090a8:	e8 47 fb ff ff       	call   80108bf4 <p2v>
801090ad:	83 c4 04             	add    $0x4,%esp
801090b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801090b3:	eb 48                	jmp    801090fd <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801090b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801090b9:	74 0e                	je     801090c9 <walkpgdir+0x53>
801090bb:	e8 50 9c ff ff       	call   80102d10 <kalloc>
801090c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801090c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801090c7:	75 07                	jne    801090d0 <walkpgdir+0x5a>
      return 0;
801090c9:	b8 00 00 00 00       	mov    $0x0,%eax
801090ce:	eb 44                	jmp    80109114 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801090d0:	83 ec 04             	sub    $0x4,%esp
801090d3:	68 00 10 00 00       	push   $0x1000
801090d8:	6a 00                	push   $0x0
801090da:	ff 75 f4             	pushl  -0xc(%ebp)
801090dd:	e8 b0 d4 ff ff       	call   80106592 <memset>
801090e2:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801090e5:	83 ec 0c             	sub    $0xc,%esp
801090e8:	ff 75 f4             	pushl  -0xc(%ebp)
801090eb:	e8 f7 fa ff ff       	call   80108be7 <v2p>
801090f0:	83 c4 10             	add    $0x10,%esp
801090f3:	83 c8 07             	or     $0x7,%eax
801090f6:	89 c2                	mov    %eax,%edx
801090f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090fb:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801090fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80109100:	c1 e8 0c             	shr    $0xc,%eax
80109103:	25 ff 03 00 00       	and    $0x3ff,%eax
80109108:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010910f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109112:	01 d0                	add    %edx,%eax
}
80109114:	c9                   	leave  
80109115:	c3                   	ret    

80109116 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80109116:	55                   	push   %ebp
80109117:	89 e5                	mov    %esp,%ebp
80109119:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010911c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010911f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109124:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80109127:	8b 55 0c             	mov    0xc(%ebp),%edx
8010912a:	8b 45 10             	mov    0x10(%ebp),%eax
8010912d:	01 d0                	add    %edx,%eax
8010912f:	83 e8 01             	sub    $0x1,%eax
80109132:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109137:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010913a:	83 ec 04             	sub    $0x4,%esp
8010913d:	6a 01                	push   $0x1
8010913f:	ff 75 f4             	pushl  -0xc(%ebp)
80109142:	ff 75 08             	pushl  0x8(%ebp)
80109145:	e8 2c ff ff ff       	call   80109076 <walkpgdir>
8010914a:	83 c4 10             	add    $0x10,%esp
8010914d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109150:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109154:	75 07                	jne    8010915d <mappages+0x47>
      return -1;
80109156:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010915b:	eb 47                	jmp    801091a4 <mappages+0x8e>
    if(*pte & PTE_P)
8010915d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109160:	8b 00                	mov    (%eax),%eax
80109162:	83 e0 01             	and    $0x1,%eax
80109165:	85 c0                	test   %eax,%eax
80109167:	74 0d                	je     80109176 <mappages+0x60>
      panic("remap");
80109169:	83 ec 0c             	sub    $0xc,%esp
8010916c:	68 90 a1 10 80       	push   $0x8010a190
80109171:	e8 f0 73 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80109176:	8b 45 18             	mov    0x18(%ebp),%eax
80109179:	0b 45 14             	or     0x14(%ebp),%eax
8010917c:	83 c8 01             	or     $0x1,%eax
8010917f:	89 c2                	mov    %eax,%edx
80109181:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109184:	89 10                	mov    %edx,(%eax)
    if(a == last)
80109186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109189:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010918c:	74 10                	je     8010919e <mappages+0x88>
      break;
    a += PGSIZE;
8010918e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109195:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010919c:	eb 9c                	jmp    8010913a <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
8010919e:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010919f:	b8 00 00 00 00       	mov    $0x0,%eax
}
801091a4:	c9                   	leave  
801091a5:	c3                   	ret    

801091a6 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801091a6:	55                   	push   %ebp
801091a7:	89 e5                	mov    %esp,%ebp
801091a9:	53                   	push   %ebx
801091aa:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801091ad:	e8 5e 9b ff ff       	call   80102d10 <kalloc>
801091b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801091b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801091b9:	75 0a                	jne    801091c5 <setupkvm+0x1f>
    return 0;
801091bb:	b8 00 00 00 00       	mov    $0x0,%eax
801091c0:	e9 8e 00 00 00       	jmp    80109253 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801091c5:	83 ec 04             	sub    $0x4,%esp
801091c8:	68 00 10 00 00       	push   $0x1000
801091cd:	6a 00                	push   $0x0
801091cf:	ff 75 f0             	pushl  -0x10(%ebp)
801091d2:	e8 bb d3 ff ff       	call   80106592 <memset>
801091d7:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801091da:	83 ec 0c             	sub    $0xc,%esp
801091dd:	68 00 00 00 0e       	push   $0xe000000
801091e2:	e8 0d fa ff ff       	call   80108bf4 <p2v>
801091e7:	83 c4 10             	add    $0x10,%esp
801091ea:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801091ef:	76 0d                	jbe    801091fe <setupkvm+0x58>
    panic("PHYSTOP too high");
801091f1:	83 ec 0c             	sub    $0xc,%esp
801091f4:	68 96 a1 10 80       	push   $0x8010a196
801091f9:	e8 68 73 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801091fe:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
80109205:	eb 40                	jmp    80109247 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109207:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010920a:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010920d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109210:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109213:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109216:	8b 58 08             	mov    0x8(%eax),%ebx
80109219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010921c:	8b 40 04             	mov    0x4(%eax),%eax
8010921f:	29 c3                	sub    %eax,%ebx
80109221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109224:	8b 00                	mov    (%eax),%eax
80109226:	83 ec 0c             	sub    $0xc,%esp
80109229:	51                   	push   %ecx
8010922a:	52                   	push   %edx
8010922b:	53                   	push   %ebx
8010922c:	50                   	push   %eax
8010922d:	ff 75 f0             	pushl  -0x10(%ebp)
80109230:	e8 e1 fe ff ff       	call   80109116 <mappages>
80109235:	83 c4 20             	add    $0x20,%esp
80109238:	85 c0                	test   %eax,%eax
8010923a:	79 07                	jns    80109243 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010923c:	b8 00 00 00 00       	mov    $0x0,%eax
80109241:	eb 10                	jmp    80109253 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109243:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80109247:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
8010924e:	72 b7                	jb     80109207 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109256:	c9                   	leave  
80109257:	c3                   	ret    

80109258 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80109258:	55                   	push   %ebp
80109259:	89 e5                	mov    %esp,%ebp
8010925b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010925e:	e8 43 ff ff ff       	call   801091a6 <setupkvm>
80109263:	a3 58 78 11 80       	mov    %eax,0x80117858
  switchkvm();
80109268:	e8 03 00 00 00       	call   80109270 <switchkvm>
}
8010926d:	90                   	nop
8010926e:	c9                   	leave  
8010926f:	c3                   	ret    

80109270 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109270:	55                   	push   %ebp
80109271:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109273:	a1 58 78 11 80       	mov    0x80117858,%eax
80109278:	50                   	push   %eax
80109279:	e8 69 f9 ff ff       	call   80108be7 <v2p>
8010927e:	83 c4 04             	add    $0x4,%esp
80109281:	50                   	push   %eax
80109282:	e8 54 f9 ff ff       	call   80108bdb <lcr3>
80109287:	83 c4 04             	add    $0x4,%esp
}
8010928a:	90                   	nop
8010928b:	c9                   	leave  
8010928c:	c3                   	ret    

8010928d <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010928d:	55                   	push   %ebp
8010928e:	89 e5                	mov    %esp,%ebp
80109290:	56                   	push   %esi
80109291:	53                   	push   %ebx
  pushcli();
80109292:	e8 f5 d1 ff ff       	call   8010648c <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80109297:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010929d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801092a4:	83 c2 08             	add    $0x8,%edx
801092a7:	89 d6                	mov    %edx,%esi
801092a9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801092b0:	83 c2 08             	add    $0x8,%edx
801092b3:	c1 ea 10             	shr    $0x10,%edx
801092b6:	89 d3                	mov    %edx,%ebx
801092b8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801092bf:	83 c2 08             	add    $0x8,%edx
801092c2:	c1 ea 18             	shr    $0x18,%edx
801092c5:	89 d1                	mov    %edx,%ecx
801092c7:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801092ce:	67 00 
801092d0:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801092d7:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801092dd:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801092e4:	83 e2 f0             	and    $0xfffffff0,%edx
801092e7:	83 ca 09             	or     $0x9,%edx
801092ea:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801092f0:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801092f7:	83 ca 10             	or     $0x10,%edx
801092fa:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109300:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109307:	83 e2 9f             	and    $0xffffff9f,%edx
8010930a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109310:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109317:	83 ca 80             	or     $0xffffff80,%edx
8010931a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109320:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109327:	83 e2 f0             	and    $0xfffffff0,%edx
8010932a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109330:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109337:	83 e2 ef             	and    $0xffffffef,%edx
8010933a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109340:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109347:	83 e2 df             	and    $0xffffffdf,%edx
8010934a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109350:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109357:	83 ca 40             	or     $0x40,%edx
8010935a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109360:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109367:	83 e2 7f             	and    $0x7f,%edx
8010936a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109370:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80109376:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010937c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109383:	83 e2 ef             	and    $0xffffffef,%edx
80109386:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010938c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109392:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80109398:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010939e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801093a5:	8b 52 08             	mov    0x8(%edx),%edx
801093a8:	81 c2 00 10 00 00    	add    $0x1000,%edx
801093ae:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801093b1:	83 ec 0c             	sub    $0xc,%esp
801093b4:	6a 30                	push   $0x30
801093b6:	e8 f3 f7 ff ff       	call   80108bae <ltr>
801093bb:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801093be:	8b 45 08             	mov    0x8(%ebp),%eax
801093c1:	8b 40 04             	mov    0x4(%eax),%eax
801093c4:	85 c0                	test   %eax,%eax
801093c6:	75 0d                	jne    801093d5 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801093c8:	83 ec 0c             	sub    $0xc,%esp
801093cb:	68 a7 a1 10 80       	push   $0x8010a1a7
801093d0:	e8 91 71 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801093d5:	8b 45 08             	mov    0x8(%ebp),%eax
801093d8:	8b 40 04             	mov    0x4(%eax),%eax
801093db:	83 ec 0c             	sub    $0xc,%esp
801093de:	50                   	push   %eax
801093df:	e8 03 f8 ff ff       	call   80108be7 <v2p>
801093e4:	83 c4 10             	add    $0x10,%esp
801093e7:	83 ec 0c             	sub    $0xc,%esp
801093ea:	50                   	push   %eax
801093eb:	e8 eb f7 ff ff       	call   80108bdb <lcr3>
801093f0:	83 c4 10             	add    $0x10,%esp
  popcli();
801093f3:	e8 d9 d0 ff ff       	call   801064d1 <popcli>
}
801093f8:	90                   	nop
801093f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801093fc:	5b                   	pop    %ebx
801093fd:	5e                   	pop    %esi
801093fe:	5d                   	pop    %ebp
801093ff:	c3                   	ret    

80109400 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109400:	55                   	push   %ebp
80109401:	89 e5                	mov    %esp,%ebp
80109403:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80109406:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010940d:	76 0d                	jbe    8010941c <inituvm+0x1c>
    panic("inituvm: more than a page");
8010940f:	83 ec 0c             	sub    $0xc,%esp
80109412:	68 bb a1 10 80       	push   $0x8010a1bb
80109417:	e8 4a 71 ff ff       	call   80100566 <panic>
  mem = kalloc();
8010941c:	e8 ef 98 ff ff       	call   80102d10 <kalloc>
80109421:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80109424:	83 ec 04             	sub    $0x4,%esp
80109427:	68 00 10 00 00       	push   $0x1000
8010942c:	6a 00                	push   $0x0
8010942e:	ff 75 f4             	pushl  -0xc(%ebp)
80109431:	e8 5c d1 ff ff       	call   80106592 <memset>
80109436:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109439:	83 ec 0c             	sub    $0xc,%esp
8010943c:	ff 75 f4             	pushl  -0xc(%ebp)
8010943f:	e8 a3 f7 ff ff       	call   80108be7 <v2p>
80109444:	83 c4 10             	add    $0x10,%esp
80109447:	83 ec 0c             	sub    $0xc,%esp
8010944a:	6a 06                	push   $0x6
8010944c:	50                   	push   %eax
8010944d:	68 00 10 00 00       	push   $0x1000
80109452:	6a 00                	push   $0x0
80109454:	ff 75 08             	pushl  0x8(%ebp)
80109457:	e8 ba fc ff ff       	call   80109116 <mappages>
8010945c:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010945f:	83 ec 04             	sub    $0x4,%esp
80109462:	ff 75 10             	pushl  0x10(%ebp)
80109465:	ff 75 0c             	pushl  0xc(%ebp)
80109468:	ff 75 f4             	pushl  -0xc(%ebp)
8010946b:	e8 e1 d1 ff ff       	call   80106651 <memmove>
80109470:	83 c4 10             	add    $0x10,%esp
}
80109473:	90                   	nop
80109474:	c9                   	leave  
80109475:	c3                   	ret    

80109476 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109476:	55                   	push   %ebp
80109477:	89 e5                	mov    %esp,%ebp
80109479:	53                   	push   %ebx
8010947a:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010947d:	8b 45 0c             	mov    0xc(%ebp),%eax
80109480:	25 ff 0f 00 00       	and    $0xfff,%eax
80109485:	85 c0                	test   %eax,%eax
80109487:	74 0d                	je     80109496 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109489:	83 ec 0c             	sub    $0xc,%esp
8010948c:	68 d8 a1 10 80       	push   $0x8010a1d8
80109491:	e8 d0 70 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109496:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010949d:	e9 95 00 00 00       	jmp    80109537 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801094a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801094a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094a8:	01 d0                	add    %edx,%eax
801094aa:	83 ec 04             	sub    $0x4,%esp
801094ad:	6a 00                	push   $0x0
801094af:	50                   	push   %eax
801094b0:	ff 75 08             	pushl  0x8(%ebp)
801094b3:	e8 be fb ff ff       	call   80109076 <walkpgdir>
801094b8:	83 c4 10             	add    $0x10,%esp
801094bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801094be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801094c2:	75 0d                	jne    801094d1 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801094c4:	83 ec 0c             	sub    $0xc,%esp
801094c7:	68 fb a1 10 80       	push   $0x8010a1fb
801094cc:	e8 95 70 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801094d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801094d4:	8b 00                	mov    (%eax),%eax
801094d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094db:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801094de:	8b 45 18             	mov    0x18(%ebp),%eax
801094e1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801094e4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801094e9:	77 0b                	ja     801094f6 <loaduvm+0x80>
      n = sz - i;
801094eb:	8b 45 18             	mov    0x18(%ebp),%eax
801094ee:	2b 45 f4             	sub    -0xc(%ebp),%eax
801094f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801094f4:	eb 07                	jmp    801094fd <loaduvm+0x87>
    else
      n = PGSIZE;
801094f6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801094fd:	8b 55 14             	mov    0x14(%ebp),%edx
80109500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109503:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109506:	83 ec 0c             	sub    $0xc,%esp
80109509:	ff 75 e8             	pushl  -0x18(%ebp)
8010950c:	e8 e3 f6 ff ff       	call   80108bf4 <p2v>
80109511:	83 c4 10             	add    $0x10,%esp
80109514:	ff 75 f0             	pushl  -0x10(%ebp)
80109517:	53                   	push   %ebx
80109518:	50                   	push   %eax
80109519:	ff 75 10             	pushl  0x10(%ebp)
8010951c:	e8 61 8a ff ff       	call   80101f82 <readi>
80109521:	83 c4 10             	add    $0x10,%esp
80109524:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109527:	74 07                	je     80109530 <loaduvm+0xba>
      return -1;
80109529:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010952e:	eb 18                	jmp    80109548 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109530:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010953a:	3b 45 18             	cmp    0x18(%ebp),%eax
8010953d:	0f 82 5f ff ff ff    	jb     801094a2 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109543:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109548:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010954b:	c9                   	leave  
8010954c:	c3                   	ret    

8010954d <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010954d:	55                   	push   %ebp
8010954e:	89 e5                	mov    %esp,%ebp
80109550:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109553:	8b 45 10             	mov    0x10(%ebp),%eax
80109556:	85 c0                	test   %eax,%eax
80109558:	79 0a                	jns    80109564 <allocuvm+0x17>
    return 0;
8010955a:	b8 00 00 00 00       	mov    $0x0,%eax
8010955f:	e9 b0 00 00 00       	jmp    80109614 <allocuvm+0xc7>
  if(newsz < oldsz)
80109564:	8b 45 10             	mov    0x10(%ebp),%eax
80109567:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010956a:	73 08                	jae    80109574 <allocuvm+0x27>
    return oldsz;
8010956c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010956f:	e9 a0 00 00 00       	jmp    80109614 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109574:	8b 45 0c             	mov    0xc(%ebp),%eax
80109577:	05 ff 0f 00 00       	add    $0xfff,%eax
8010957c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109581:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109584:	eb 7f                	jmp    80109605 <allocuvm+0xb8>
    mem = kalloc();
80109586:	e8 85 97 ff ff       	call   80102d10 <kalloc>
8010958b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010958e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109592:	75 2b                	jne    801095bf <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109594:	83 ec 0c             	sub    $0xc,%esp
80109597:	68 19 a2 10 80       	push   $0x8010a219
8010959c:	e8 25 6e ff ff       	call   801003c6 <cprintf>
801095a1:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801095a4:	83 ec 04             	sub    $0x4,%esp
801095a7:	ff 75 0c             	pushl  0xc(%ebp)
801095aa:	ff 75 10             	pushl  0x10(%ebp)
801095ad:	ff 75 08             	pushl  0x8(%ebp)
801095b0:	e8 61 00 00 00       	call   80109616 <deallocuvm>
801095b5:	83 c4 10             	add    $0x10,%esp
      return 0;
801095b8:	b8 00 00 00 00       	mov    $0x0,%eax
801095bd:	eb 55                	jmp    80109614 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
801095bf:	83 ec 04             	sub    $0x4,%esp
801095c2:	68 00 10 00 00       	push   $0x1000
801095c7:	6a 00                	push   $0x0
801095c9:	ff 75 f0             	pushl  -0x10(%ebp)
801095cc:	e8 c1 cf ff ff       	call   80106592 <memset>
801095d1:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801095d4:	83 ec 0c             	sub    $0xc,%esp
801095d7:	ff 75 f0             	pushl  -0x10(%ebp)
801095da:	e8 08 f6 ff ff       	call   80108be7 <v2p>
801095df:	83 c4 10             	add    $0x10,%esp
801095e2:	89 c2                	mov    %eax,%edx
801095e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e7:	83 ec 0c             	sub    $0xc,%esp
801095ea:	6a 06                	push   $0x6
801095ec:	52                   	push   %edx
801095ed:	68 00 10 00 00       	push   $0x1000
801095f2:	50                   	push   %eax
801095f3:	ff 75 08             	pushl  0x8(%ebp)
801095f6:	e8 1b fb ff ff       	call   80109116 <mappages>
801095fb:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801095fe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109608:	3b 45 10             	cmp    0x10(%ebp),%eax
8010960b:	0f 82 75 ff ff ff    	jb     80109586 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109611:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109614:	c9                   	leave  
80109615:	c3                   	ret    

80109616 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109616:	55                   	push   %ebp
80109617:	89 e5                	mov    %esp,%ebp
80109619:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010961c:	8b 45 10             	mov    0x10(%ebp),%eax
8010961f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109622:	72 08                	jb     8010962c <deallocuvm+0x16>
    return oldsz;
80109624:	8b 45 0c             	mov    0xc(%ebp),%eax
80109627:	e9 a5 00 00 00       	jmp    801096d1 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
8010962c:	8b 45 10             	mov    0x10(%ebp),%eax
8010962f:	05 ff 0f 00 00       	add    $0xfff,%eax
80109634:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109639:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010963c:	e9 81 00 00 00       	jmp    801096c2 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109644:	83 ec 04             	sub    $0x4,%esp
80109647:	6a 00                	push   $0x0
80109649:	50                   	push   %eax
8010964a:	ff 75 08             	pushl  0x8(%ebp)
8010964d:	e8 24 fa ff ff       	call   80109076 <walkpgdir>
80109652:	83 c4 10             	add    $0x10,%esp
80109655:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109658:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010965c:	75 09                	jne    80109667 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
8010965e:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109665:	eb 54                	jmp    801096bb <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109667:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010966a:	8b 00                	mov    (%eax),%eax
8010966c:	83 e0 01             	and    $0x1,%eax
8010966f:	85 c0                	test   %eax,%eax
80109671:	74 48                	je     801096bb <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109673:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109676:	8b 00                	mov    (%eax),%eax
80109678:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010967d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109680:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109684:	75 0d                	jne    80109693 <deallocuvm+0x7d>
        panic("kfree");
80109686:	83 ec 0c             	sub    $0xc,%esp
80109689:	68 31 a2 10 80       	push   $0x8010a231
8010968e:	e8 d3 6e ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109693:	83 ec 0c             	sub    $0xc,%esp
80109696:	ff 75 ec             	pushl  -0x14(%ebp)
80109699:	e8 56 f5 ff ff       	call   80108bf4 <p2v>
8010969e:	83 c4 10             	add    $0x10,%esp
801096a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801096a4:	83 ec 0c             	sub    $0xc,%esp
801096a7:	ff 75 e8             	pushl  -0x18(%ebp)
801096aa:	e8 c4 95 ff ff       	call   80102c73 <kfree>
801096af:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801096b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801096bb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801096c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801096c8:	0f 82 73 ff ff ff    	jb     80109641 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801096ce:	8b 45 10             	mov    0x10(%ebp),%eax
}
801096d1:	c9                   	leave  
801096d2:	c3                   	ret    

801096d3 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801096d3:	55                   	push   %ebp
801096d4:	89 e5                	mov    %esp,%ebp
801096d6:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801096d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801096dd:	75 0d                	jne    801096ec <freevm+0x19>
    panic("freevm: no pgdir");
801096df:	83 ec 0c             	sub    $0xc,%esp
801096e2:	68 37 a2 10 80       	push   $0x8010a237
801096e7:	e8 7a 6e ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801096ec:	83 ec 04             	sub    $0x4,%esp
801096ef:	6a 00                	push   $0x0
801096f1:	68 00 00 00 80       	push   $0x80000000
801096f6:	ff 75 08             	pushl  0x8(%ebp)
801096f9:	e8 18 ff ff ff       	call   80109616 <deallocuvm>
801096fe:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109701:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109708:	eb 4f                	jmp    80109759 <freevm+0x86>
    if(pgdir[i] & PTE_P){
8010970a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010970d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109714:	8b 45 08             	mov    0x8(%ebp),%eax
80109717:	01 d0                	add    %edx,%eax
80109719:	8b 00                	mov    (%eax),%eax
8010971b:	83 e0 01             	and    $0x1,%eax
8010971e:	85 c0                	test   %eax,%eax
80109720:	74 33                	je     80109755 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109725:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010972c:	8b 45 08             	mov    0x8(%ebp),%eax
8010972f:	01 d0                	add    %edx,%eax
80109731:	8b 00                	mov    (%eax),%eax
80109733:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109738:	83 ec 0c             	sub    $0xc,%esp
8010973b:	50                   	push   %eax
8010973c:	e8 b3 f4 ff ff       	call   80108bf4 <p2v>
80109741:	83 c4 10             	add    $0x10,%esp
80109744:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109747:	83 ec 0c             	sub    $0xc,%esp
8010974a:	ff 75 f0             	pushl  -0x10(%ebp)
8010974d:	e8 21 95 ff ff       	call   80102c73 <kfree>
80109752:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109755:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109759:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109760:	76 a8                	jbe    8010970a <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109762:	83 ec 0c             	sub    $0xc,%esp
80109765:	ff 75 08             	pushl  0x8(%ebp)
80109768:	e8 06 95 ff ff       	call   80102c73 <kfree>
8010976d:	83 c4 10             	add    $0x10,%esp
}
80109770:	90                   	nop
80109771:	c9                   	leave  
80109772:	c3                   	ret    

80109773 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109773:	55                   	push   %ebp
80109774:	89 e5                	mov    %esp,%ebp
80109776:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109779:	83 ec 04             	sub    $0x4,%esp
8010977c:	6a 00                	push   $0x0
8010977e:	ff 75 0c             	pushl  0xc(%ebp)
80109781:	ff 75 08             	pushl  0x8(%ebp)
80109784:	e8 ed f8 ff ff       	call   80109076 <walkpgdir>
80109789:	83 c4 10             	add    $0x10,%esp
8010978c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010978f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109793:	75 0d                	jne    801097a2 <clearpteu+0x2f>
    panic("clearpteu");
80109795:	83 ec 0c             	sub    $0xc,%esp
80109798:	68 48 a2 10 80       	push   $0x8010a248
8010979d:	e8 c4 6d ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801097a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a5:	8b 00                	mov    (%eax),%eax
801097a7:	83 e0 fb             	and    $0xfffffffb,%eax
801097aa:	89 c2                	mov    %eax,%edx
801097ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097af:	89 10                	mov    %edx,(%eax)
}
801097b1:	90                   	nop
801097b2:	c9                   	leave  
801097b3:	c3                   	ret    

801097b4 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801097b4:	55                   	push   %ebp
801097b5:	89 e5                	mov    %esp,%ebp
801097b7:	53                   	push   %ebx
801097b8:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801097bb:	e8 e6 f9 ff ff       	call   801091a6 <setupkvm>
801097c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801097c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801097c7:	75 0a                	jne    801097d3 <copyuvm+0x1f>
    return 0;
801097c9:	b8 00 00 00 00       	mov    $0x0,%eax
801097ce:	e9 f8 00 00 00       	jmp    801098cb <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
801097d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801097da:	e9 c4 00 00 00       	jmp    801098a3 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801097df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097e2:	83 ec 04             	sub    $0x4,%esp
801097e5:	6a 00                	push   $0x0
801097e7:	50                   	push   %eax
801097e8:	ff 75 08             	pushl  0x8(%ebp)
801097eb:	e8 86 f8 ff ff       	call   80109076 <walkpgdir>
801097f0:	83 c4 10             	add    $0x10,%esp
801097f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801097f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801097fa:	75 0d                	jne    80109809 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801097fc:	83 ec 0c             	sub    $0xc,%esp
801097ff:	68 52 a2 10 80       	push   $0x8010a252
80109804:	e8 5d 6d ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109809:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010980c:	8b 00                	mov    (%eax),%eax
8010980e:	83 e0 01             	and    $0x1,%eax
80109811:	85 c0                	test   %eax,%eax
80109813:	75 0d                	jne    80109822 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109815:	83 ec 0c             	sub    $0xc,%esp
80109818:	68 6c a2 10 80       	push   $0x8010a26c
8010981d:	e8 44 6d ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109822:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109825:	8b 00                	mov    (%eax),%eax
80109827:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010982c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010982f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109832:	8b 00                	mov    (%eax),%eax
80109834:	25 ff 0f 00 00       	and    $0xfff,%eax
80109839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010983c:	e8 cf 94 ff ff       	call   80102d10 <kalloc>
80109841:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109844:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109848:	74 6a                	je     801098b4 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010984a:	83 ec 0c             	sub    $0xc,%esp
8010984d:	ff 75 e8             	pushl  -0x18(%ebp)
80109850:	e8 9f f3 ff ff       	call   80108bf4 <p2v>
80109855:	83 c4 10             	add    $0x10,%esp
80109858:	83 ec 04             	sub    $0x4,%esp
8010985b:	68 00 10 00 00       	push   $0x1000
80109860:	50                   	push   %eax
80109861:	ff 75 e0             	pushl  -0x20(%ebp)
80109864:	e8 e8 cd ff ff       	call   80106651 <memmove>
80109869:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010986c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010986f:	83 ec 0c             	sub    $0xc,%esp
80109872:	ff 75 e0             	pushl  -0x20(%ebp)
80109875:	e8 6d f3 ff ff       	call   80108be7 <v2p>
8010987a:	83 c4 10             	add    $0x10,%esp
8010987d:	89 c2                	mov    %eax,%edx
8010987f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109882:	83 ec 0c             	sub    $0xc,%esp
80109885:	53                   	push   %ebx
80109886:	52                   	push   %edx
80109887:	68 00 10 00 00       	push   $0x1000
8010988c:	50                   	push   %eax
8010988d:	ff 75 f0             	pushl  -0x10(%ebp)
80109890:	e8 81 f8 ff ff       	call   80109116 <mappages>
80109895:	83 c4 20             	add    $0x20,%esp
80109898:	85 c0                	test   %eax,%eax
8010989a:	78 1b                	js     801098b7 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010989c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801098a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801098a9:	0f 82 30 ff ff ff    	jb     801097df <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801098af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098b2:	eb 17                	jmp    801098cb <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801098b4:	90                   	nop
801098b5:	eb 01                	jmp    801098b8 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801098b7:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801098b8:	83 ec 0c             	sub    $0xc,%esp
801098bb:	ff 75 f0             	pushl  -0x10(%ebp)
801098be:	e8 10 fe ff ff       	call   801096d3 <freevm>
801098c3:	83 c4 10             	add    $0x10,%esp
  return 0;
801098c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801098cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801098ce:	c9                   	leave  
801098cf:	c3                   	ret    

801098d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801098d0:	55                   	push   %ebp
801098d1:	89 e5                	mov    %esp,%ebp
801098d3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801098d6:	83 ec 04             	sub    $0x4,%esp
801098d9:	6a 00                	push   $0x0
801098db:	ff 75 0c             	pushl  0xc(%ebp)
801098de:	ff 75 08             	pushl  0x8(%ebp)
801098e1:	e8 90 f7 ff ff       	call   80109076 <walkpgdir>
801098e6:	83 c4 10             	add    $0x10,%esp
801098e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801098ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098ef:	8b 00                	mov    (%eax),%eax
801098f1:	83 e0 01             	and    $0x1,%eax
801098f4:	85 c0                	test   %eax,%eax
801098f6:	75 07                	jne    801098ff <uva2ka+0x2f>
    return 0;
801098f8:	b8 00 00 00 00       	mov    $0x0,%eax
801098fd:	eb 29                	jmp    80109928 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801098ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109902:	8b 00                	mov    (%eax),%eax
80109904:	83 e0 04             	and    $0x4,%eax
80109907:	85 c0                	test   %eax,%eax
80109909:	75 07                	jne    80109912 <uva2ka+0x42>
    return 0;
8010990b:	b8 00 00 00 00       	mov    $0x0,%eax
80109910:	eb 16                	jmp    80109928 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109915:	8b 00                	mov    (%eax),%eax
80109917:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010991c:	83 ec 0c             	sub    $0xc,%esp
8010991f:	50                   	push   %eax
80109920:	e8 cf f2 ff ff       	call   80108bf4 <p2v>
80109925:	83 c4 10             	add    $0x10,%esp
}
80109928:	c9                   	leave  
80109929:	c3                   	ret    

8010992a <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010992a:	55                   	push   %ebp
8010992b:	89 e5                	mov    %esp,%ebp
8010992d:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109930:	8b 45 10             	mov    0x10(%ebp),%eax
80109933:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109936:	eb 7f                	jmp    801099b7 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109938:	8b 45 0c             	mov    0xc(%ebp),%eax
8010993b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109940:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109943:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109946:	83 ec 08             	sub    $0x8,%esp
80109949:	50                   	push   %eax
8010994a:	ff 75 08             	pushl  0x8(%ebp)
8010994d:	e8 7e ff ff ff       	call   801098d0 <uva2ka>
80109952:	83 c4 10             	add    $0x10,%esp
80109955:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109958:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010995c:	75 07                	jne    80109965 <copyout+0x3b>
      return -1;
8010995e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109963:	eb 61                	jmp    801099c6 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109965:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109968:	2b 45 0c             	sub    0xc(%ebp),%eax
8010996b:	05 00 10 00 00       	add    $0x1000,%eax
80109970:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109973:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109976:	3b 45 14             	cmp    0x14(%ebp),%eax
80109979:	76 06                	jbe    80109981 <copyout+0x57>
      n = len;
8010997b:	8b 45 14             	mov    0x14(%ebp),%eax
8010997e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109981:	8b 45 0c             	mov    0xc(%ebp),%eax
80109984:	2b 45 ec             	sub    -0x14(%ebp),%eax
80109987:	89 c2                	mov    %eax,%edx
80109989:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010998c:	01 d0                	add    %edx,%eax
8010998e:	83 ec 04             	sub    $0x4,%esp
80109991:	ff 75 f0             	pushl  -0x10(%ebp)
80109994:	ff 75 f4             	pushl  -0xc(%ebp)
80109997:	50                   	push   %eax
80109998:	e8 b4 cc ff ff       	call   80106651 <memmove>
8010999d:	83 c4 10             	add    $0x10,%esp
    len -= n;
801099a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099a3:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801099a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099a9:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801099ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801099af:	05 00 10 00 00       	add    $0x1000,%eax
801099b4:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801099b7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801099bb:	0f 85 77 ff ff ff    	jne    80109938 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801099c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801099c6:	c9                   	leave  
801099c7:	c3                   	ret    
