
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
8010003d:	68 9c 8b 10 80       	push   $0x80108b9c
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 d2 54 00 00       	call   8010551e <initlock>
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
801000c1:	e8 7a 54 00 00       	call   80105540 <acquire>
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
8010010c:	e8 96 54 00 00       	call   801055a7 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 58 4d 00 00       	call   80104e84 <sleep>
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
80100188:	e8 1a 54 00 00       	call   801055a7 <release>
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
801001aa:	68 a3 8b 10 80       	push   $0x80108ba3
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
80100204:	68 b4 8b 10 80       	push   $0x80108bb4
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
80100243:	68 bb 8b 10 80       	push   $0x80108bbb
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 e6 52 00 00       	call   80105540 <acquire>
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
801002b9:	e8 ad 4c 00 00       	call   80104f6b <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 d9 52 00 00       	call   801055a7 <release>
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
801003e2:	e8 59 51 00 00       	call   80105540 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 c2 8b 10 80       	push   $0x80108bc2
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
801004cd:	c7 45 ec cb 8b 10 80 	movl   $0x80108bcb,-0x14(%ebp)
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
8010055b:	e8 47 50 00 00       	call   801055a7 <release>
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
8010058b:	68 d2 8b 10 80       	push   $0x80108bd2
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
801005aa:	68 e1 8b 10 80       	push   $0x80108be1
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 32 50 00 00       	call   801055f9 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 e3 8b 10 80       	push   $0x80108be3
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
801006ca:	68 e7 8b 10 80       	push   $0x80108be7
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
801006f7:	e8 66 51 00 00       	call   80105862 <memmove>
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
80100721:	e8 7d 50 00 00       	call   801057a3 <memset>
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
801007b6:	e8 6a 6a 00 00       	call   80107225 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 5d 6a 00 00       	call   80107225 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 50 6a 00 00       	call   80107225 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 40 6a 00 00       	call   80107225 <uartputc>
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
80100815:	e8 26 4d 00 00       	call   80105540 <acquire>
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
80100972:	e8 f4 45 00 00       	call   80104f6b <wakeup>
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
80100995:	e8 0d 4c 00 00       	call   801055a7 <release>
8010099a:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010099d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009a1:	74 05                	je     801009a8 <consoleintr+0x1af>
    procdump();  // now call procdump() wo. cons.lock held
801009a3:	e8 83 46 00 00       	call   8010502b <procdump>
  }
  if(f == 1) {
801009a8:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
801009ac:	75 05                	jne    801009b3 <consoleintr+0x1ba>
    free_length();
801009ae:	e8 05 49 00 00       	call   801052b8 <free_length>
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
801009d8:	e8 63 4b 00 00       	call   80105540 <acquire>
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
801009fa:	e8 a8 4b 00 00       	call   801055a7 <release>
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
80100a27:	e8 58 44 00 00       	call   80104e84 <sleep>
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
80100aa5:	e8 fd 4a 00 00       	call   801055a7 <release>
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
80100ae3:	e8 58 4a 00 00       	call   80105540 <acquire>
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
80100b25:	e8 7d 4a 00 00       	call   801055a7 <release>
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
80100b49:	68 fa 8b 10 80       	push   $0x80108bfa
80100b4e:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b53:	e8 c6 49 00 00       	call   8010551e <initlock>
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
80100c11:	e8 64 77 00 00       	call   8010837a <setupkvm>
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
80100c97:	e8 85 7a 00 00       	call   80108721 <allocuvm>
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
80100cca:	e8 7b 79 00 00       	call   8010864a <loaduvm>
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
80100d39:	e8 e3 79 00 00       	call   80108721 <allocuvm>
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
80100d5d:	e8 e5 7b 00 00       	call   80108947 <clearpteu>
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
80100d96:	e8 55 4c 00 00       	call   801059f0 <strlen>
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
80100dc3:	e8 28 4c 00 00       	call   801059f0 <strlen>
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
80100de9:	e8 10 7d 00 00       	call   80108afe <copyout>
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
80100e85:	e8 74 7c 00 00       	call   80108afe <copyout>
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
80100ed6:	e8 cb 4a 00 00       	call   801059a6 <safestrcpy>
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
80100f2c:	e8 30 75 00 00       	call   80108461 <switchuvm>
80100f31:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f34:	83 ec 0c             	sub    $0xc,%esp
80100f37:	ff 75 d0             	pushl  -0x30(%ebp)
80100f3a:	e8 68 79 00 00       	call   801088a7 <freevm>
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
80100f74:	e8 2e 79 00 00       	call   801088a7 <freevm>
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
80100fa5:	68 02 8c 10 80       	push   $0x80108c02
80100faa:	68 40 18 11 80       	push   $0x80111840
80100faf:	e8 6a 45 00 00       	call   8010551e <initlock>
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
80100fc8:	e8 73 45 00 00       	call   80105540 <acquire>
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
80100ff5:	e8 ad 45 00 00       	call   801055a7 <release>
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
80101018:	e8 8a 45 00 00       	call   801055a7 <release>
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
80101035:	e8 06 45 00 00       	call   80105540 <acquire>
8010103a:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010103d:	8b 45 08             	mov    0x8(%ebp),%eax
80101040:	8b 40 04             	mov    0x4(%eax),%eax
80101043:	85 c0                	test   %eax,%eax
80101045:	7f 0d                	jg     80101054 <filedup+0x2d>
    panic("filedup");
80101047:	83 ec 0c             	sub    $0xc,%esp
8010104a:	68 09 8c 10 80       	push   $0x80108c09
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
8010106b:	e8 37 45 00 00       	call   801055a7 <release>
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
80101086:	e8 b5 44 00 00       	call   80105540 <acquire>
8010108b:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010108e:	8b 45 08             	mov    0x8(%ebp),%eax
80101091:	8b 40 04             	mov    0x4(%eax),%eax
80101094:	85 c0                	test   %eax,%eax
80101096:	7f 0d                	jg     801010a5 <fileclose+0x2d>
    panic("fileclose");
80101098:	83 ec 0c             	sub    $0xc,%esp
8010109b:	68 11 8c 10 80       	push   $0x80108c11
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
801010c6:	e8 dc 44 00 00       	call   801055a7 <release>
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
80101114:	e8 8e 44 00 00       	call   801055a7 <release>
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
80101263:	68 1b 8c 10 80       	push   $0x80108c1b
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
80101366:	68 24 8c 10 80       	push   $0x80108c24
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
8010139c:	68 34 8c 10 80       	push   $0x80108c34
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
801013d4:	e8 89 44 00 00       	call   80105862 <memmove>
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
8010141a:	e8 84 43 00 00       	call   801057a3 <memset>
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
80101581:	68 40 8c 10 80       	push   $0x80108c40
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
80101614:	68 56 8c 10 80       	push   $0x80108c56
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
80101671:	68 69 8c 10 80       	push   $0x80108c69
80101676:	68 60 22 11 80       	push   $0x80112260
8010167b:	e8 9e 3e 00 00       	call   8010551e <initlock>
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
801016ca:	68 70 8c 10 80       	push   $0x80108c70
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
80101743:	e8 5b 40 00 00       	call   801057a3 <memset>
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
801017ab:	68 c3 8c 10 80       	push   $0x80108cc3
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
80101851:	e8 0c 40 00 00       	call   80105862 <memmove>
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
80101886:	e8 b5 3c 00 00       	call   80105540 <acquire>
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
801018d4:	e8 ce 3c 00 00       	call   801055a7 <release>
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
8010190d:	68 d5 8c 10 80       	push   $0x80108cd5
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
8010194a:	e8 58 3c 00 00       	call   801055a7 <release>
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
80101965:	e8 d6 3b 00 00       	call   80105540 <acquire>
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
80101984:	e8 1e 3c 00 00       	call   801055a7 <release>
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
801019aa:	68 e5 8c 10 80       	push   $0x80108ce5
801019af:	e8 b2 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
801019b4:	83 ec 0c             	sub    $0xc,%esp
801019b7:	68 60 22 11 80       	push   $0x80112260
801019bc:	e8 7f 3b 00 00       	call   80105540 <acquire>
801019c1:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801019c4:	eb 13                	jmp    801019d9 <ilock+0x48>
    sleep(ip, &icache.lock);
801019c6:	83 ec 08             	sub    $0x8,%esp
801019c9:	68 60 22 11 80       	push   $0x80112260
801019ce:	ff 75 08             	pushl  0x8(%ebp)
801019d1:	e8 ae 34 00 00       	call   80104e84 <sleep>
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
801019ff:	e8 a3 3b 00 00       	call   801055a7 <release>
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
80101aac:	e8 b1 3d 00 00       	call   80105862 <memmove>
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
80101ae2:	68 eb 8c 10 80       	push   $0x80108ceb
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
80101b15:	68 fa 8c 10 80       	push   $0x80108cfa
80101b1a:	e8 47 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b1f:	83 ec 0c             	sub    $0xc,%esp
80101b22:	68 60 22 11 80       	push   $0x80112260
80101b27:	e8 14 3a 00 00       	call   80105540 <acquire>
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
80101b46:	e8 20 34 00 00       	call   80104f6b <wakeup>
80101b4b:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101b4e:	83 ec 0c             	sub    $0xc,%esp
80101b51:	68 60 22 11 80       	push   $0x80112260
80101b56:	e8 4c 3a 00 00       	call   801055a7 <release>
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
80101b6f:	e8 cc 39 00 00       	call   80105540 <acquire>
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
80101bb7:	68 02 8d 10 80       	push   $0x80108d02
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
80101bda:	e8 c8 39 00 00       	call   801055a7 <release>
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
80101c0f:	e8 2c 39 00 00       	call   80105540 <acquire>
80101c14:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c17:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c21:	83 ec 0c             	sub    $0xc,%esp
80101c24:	ff 75 08             	pushl  0x8(%ebp)
80101c27:	e8 3f 33 00 00       	call   80104f6b <wakeup>
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
80101c46:	e8 5c 39 00 00       	call   801055a7 <release>
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
80101d86:	68 0c 8d 10 80       	push   $0x80108d0c
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
8010201d:	e8 40 38 00 00       	call   80105862 <memmove>
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
8010216f:	e8 ee 36 00 00       	call   80105862 <memmove>
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
801021ef:	e8 04 37 00 00       	call   801058f8 <strncmp>
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
8010220f:	68 1f 8d 10 80       	push   $0x80108d1f
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
8010223e:	68 31 8d 10 80       	push   $0x80108d31
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
80102313:	68 31 8d 10 80       	push   $0x80108d31
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
8010234e:	e8 fb 35 00 00       	call   8010594e <strncpy>
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
8010237a:	68 3e 8d 10 80       	push   $0x80108d3e
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
801023f0:	e8 6d 34 00 00       	call   80105862 <memmove>
801023f5:	83 c4 10             	add    $0x10,%esp
801023f8:	eb 26                	jmp    80102420 <skipelem+0x95>
  else {
    memmove(name, s, len);
801023fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023fd:	83 ec 04             	sub    $0x4,%esp
80102400:	50                   	push   %eax
80102401:	ff 75 f4             	pushl  -0xc(%ebp)
80102404:	ff 75 0c             	pushl  0xc(%ebp)
80102407:	e8 56 34 00 00       	call   80105862 <memmove>
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
8010265c:	68 46 8d 10 80       	push   $0x80108d46
80102661:	68 20 c6 10 80       	push   $0x8010c620
80102666:	e8 b3 2e 00 00       	call   8010551e <initlock>
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
80102710:	68 4a 8d 10 80       	push   $0x80108d4a
80102715:	e8 4c de ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
8010271a:	8b 45 08             	mov    0x8(%ebp),%eax
8010271d:	8b 40 08             	mov    0x8(%eax),%eax
80102720:	3d cf 07 00 00       	cmp    $0x7cf,%eax
80102725:	76 0d                	jbe    80102734 <idestart+0x33>
    panic("incorrect blockno");
80102727:	83 ec 0c             	sub    $0xc,%esp
8010272a:	68 53 8d 10 80       	push   $0x80108d53
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
80102753:	68 4a 8d 10 80       	push   $0x80108d4a
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
8010286d:	e8 ce 2c 00 00       	call   80105540 <acquire>
80102872:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102875:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010287a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010287d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102881:	75 15                	jne    80102898 <ideintr+0x39>
    release(&idelock);
80102883:	83 ec 0c             	sub    $0xc,%esp
80102886:	68 20 c6 10 80       	push   $0x8010c620
8010288b:	e8 17 2d 00 00       	call   801055a7 <release>
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
80102900:	e8 66 26 00 00       	call   80104f6b <wakeup>
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
8010292a:	e8 78 2c 00 00       	call   801055a7 <release>
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
80102949:	68 65 8d 10 80       	push   $0x80108d65
8010294e:	e8 13 dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102953:	8b 45 08             	mov    0x8(%ebp),%eax
80102956:	8b 00                	mov    (%eax),%eax
80102958:	83 e0 06             	and    $0x6,%eax
8010295b:	83 f8 02             	cmp    $0x2,%eax
8010295e:	75 0d                	jne    8010296d <iderw+0x39>
    panic("iderw: nothing to do");
80102960:	83 ec 0c             	sub    $0xc,%esp
80102963:	68 79 8d 10 80       	push   $0x80108d79
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
80102983:	68 8e 8d 10 80       	push   $0x80108d8e
80102988:	e8 d9 db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010298d:	83 ec 0c             	sub    $0xc,%esp
80102990:	68 20 c6 10 80       	push   $0x8010c620
80102995:	e8 a6 2b 00 00       	call   80105540 <acquire>
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
801029f1:	e8 8e 24 00 00       	call   80104e84 <sleep>
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
80102a0e:	e8 94 2b 00 00       	call   801055a7 <release>
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
80102a9f:	68 ac 8d 10 80       	push   $0x80108dac
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
80102b5f:	68 de 8d 10 80       	push   $0x80108dde
80102b64:	68 40 32 11 80       	push   $0x80113240
80102b69:	e8 b0 29 00 00       	call   8010551e <initlock>
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
80102c20:	68 e3 8d 10 80       	push   $0x80108de3
80102c25:	e8 3c d9 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c2a:	83 ec 04             	sub    $0x4,%esp
80102c2d:	68 00 10 00 00       	push   $0x1000
80102c32:	6a 01                	push   $0x1
80102c34:	ff 75 08             	pushl  0x8(%ebp)
80102c37:	e8 67 2b 00 00       	call   801057a3 <memset>
80102c3c:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c3f:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c44:	85 c0                	test   %eax,%eax
80102c46:	74 10                	je     80102c58 <kfree+0x68>
    acquire(&kmem.lock);
80102c48:	83 ec 0c             	sub    $0xc,%esp
80102c4b:	68 40 32 11 80       	push   $0x80113240
80102c50:	e8 eb 28 00 00       	call   80105540 <acquire>
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
80102c82:	e8 20 29 00 00       	call   801055a7 <release>
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
80102ca4:	e8 97 28 00 00       	call   80105540 <acquire>
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
80102cd5:	e8 cd 28 00 00       	call   801055a7 <release>
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
80103020:	68 ec 8d 10 80       	push   $0x80108dec
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
8010324b:	e8 ba 25 00 00       	call   8010580a <memcmp>
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
8010335f:	68 18 8e 10 80       	push   $0x80108e18
80103364:	68 80 32 11 80       	push   $0x80113280
80103369:	e8 b0 21 00 00       	call   8010551e <initlock>
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
80103414:	e8 49 24 00 00       	call   80105862 <memmove>
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
80103582:	e8 b9 1f 00 00       	call   80105540 <acquire>
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
801035a0:	e8 df 18 00 00       	call   80104e84 <sleep>
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
801035d5:	e8 aa 18 00 00       	call   80104e84 <sleep>
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
801035f4:	e8 ae 1f 00 00       	call   801055a7 <release>
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
80103615:	e8 26 1f 00 00       	call   80105540 <acquire>
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
80103636:	68 1c 8e 10 80       	push   $0x80108e1c
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
80103664:	e8 02 19 00 00       	call   80104f6b <wakeup>
80103669:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010366c:	83 ec 0c             	sub    $0xc,%esp
8010366f:	68 80 32 11 80       	push   $0x80113280
80103674:	e8 2e 1f 00 00       	call   801055a7 <release>
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
8010368f:	e8 ac 1e 00 00       	call   80105540 <acquire>
80103694:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103697:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
8010369e:	00 00 00 
    wakeup(&log);
801036a1:	83 ec 0c             	sub    $0xc,%esp
801036a4:	68 80 32 11 80       	push   $0x80113280
801036a9:	e8 bd 18 00 00       	call   80104f6b <wakeup>
801036ae:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801036b1:	83 ec 0c             	sub    $0xc,%esp
801036b4:	68 80 32 11 80       	push   $0x80113280
801036b9:	e8 e9 1e 00 00       	call   801055a7 <release>
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
80103735:	e8 28 21 00 00       	call   80105862 <memmove>
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
801037d1:	68 2b 8e 10 80       	push   $0x80108e2b
801037d6:	e8 8b cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
801037db:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801037e0:	85 c0                	test   %eax,%eax
801037e2:	7f 0d                	jg     801037f1 <log_write+0x45>
    panic("log_write outside of trans");
801037e4:	83 ec 0c             	sub    $0xc,%esp
801037e7:	68 41 8e 10 80       	push   $0x80108e41
801037ec:	e8 75 cd ff ff       	call   80100566 <panic>

  acquire(&log.lock);
801037f1:	83 ec 0c             	sub    $0xc,%esp
801037f4:	68 80 32 11 80       	push   $0x80113280
801037f9:	e8 42 1d 00 00       	call   80105540 <acquire>
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
80103877:	e8 2b 1d 00 00       	call   801055a7 <release>
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
801038dc:	e8 4b 4b 00 00       	call   8010842c <kvmalloc>
  mpinit();        // collect info about this machine
801038e1:	e8 43 04 00 00       	call   80103d29 <mpinit>
  lapicinit();
801038e6:	e8 ea f5 ff ff       	call   80102ed5 <lapicinit>
  seginit();       // set up segments
801038eb:	e8 e5 44 00 00       	call   80107dd5 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801038f0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038f6:	0f b6 00             	movzbl (%eax),%eax
801038f9:	0f b6 c0             	movzbl %al,%eax
801038fc:	83 ec 08             	sub    $0x8,%esp
801038ff:	50                   	push   %eax
80103900:	68 5c 8e 10 80       	push   $0x80108e5c
80103905:	e8 bc ca ff ff       	call   801003c6 <cprintf>
8010390a:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010390d:	e8 6d 06 00 00       	call   80103f7f <picinit>
  ioapicinit();    // another interrupt controller
80103912:	e8 34 f1 ff ff       	call   80102a4b <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103917:	e8 24 d2 ff ff       	call   80100b40 <consoleinit>
  uartinit();      // serial port
8010391c:	e8 10 38 00 00       	call   80107131 <uartinit>
  pinit();         // process table
80103921:	e8 5d 0b 00 00       	call   80104483 <pinit>
  tvinit();        // trap vectors
80103926:	e8 02 34 00 00       	call   80106d2d <tvinit>
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
80103943:	e8 36 33 00 00       	call   80106c7e <timerinit>
  startothers();   // start other processors
80103948:	e8 7f 00 00 00       	call   801039cc <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010394d:	83 ec 08             	sub    $0x8,%esp
80103950:	68 00 00 00 8e       	push   $0x8e000000
80103955:	68 00 00 40 80       	push   $0x80400000
8010395a:	e8 30 f2 ff ff       	call   80102b8f <kinit2>
8010395f:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103962:	e8 6e 0c 00 00       	call   801045d5 <userinit>
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
80103972:	e8 cd 4a 00 00       	call   80108444 <switchkvm>
  seginit();
80103977:	e8 59 44 00 00       	call   80107dd5 <seginit>
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
8010399c:	68 73 8e 10 80       	push   $0x80108e73
801039a1:	e8 20 ca ff ff       	call   801003c6 <cprintf>
801039a6:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801039a9:	e8 e0 34 00 00       	call   80106e8e <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801039ae:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039b4:	05 a8 00 00 00       	add    $0xa8,%eax
801039b9:	83 ec 08             	sub    $0x8,%esp
801039bc:	6a 01                	push   $0x1
801039be:	50                   	push   %eax
801039bf:	e8 d8 fe ff ff       	call   8010389c <xchg>
801039c4:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801039c7:	e8 68 12 00 00       	call   80104c34 <scheduler>

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
801039f4:	e8 69 1e 00 00       	call   80105862 <memmove>
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
80103b82:	68 84 8e 10 80       	push   $0x80108e84
80103b87:	ff 75 f4             	pushl  -0xc(%ebp)
80103b8a:	e8 7b 1c 00 00       	call   8010580a <memcmp>
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
80103cc0:	68 89 8e 10 80       	push   $0x80108e89
80103cc5:	ff 75 f0             	pushl  -0x10(%ebp)
80103cc8:	e8 3d 1b 00 00       	call   8010580a <memcmp>
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
80103d9c:	8b 04 85 cc 8e 10 80 	mov    -0x7fef7134(,%eax,4),%eax
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
80103dd2:	68 8e 8e 10 80       	push   $0x80108e8e
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
80103e65:	68 ac 8e 10 80       	push   $0x80108eac
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
80104106:	68 e0 8e 10 80       	push   $0x80108ee0
8010410b:	50                   	push   %eax
8010410c:	e8 0d 14 00 00       	call   8010551e <initlock>
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
801041c8:	e8 73 13 00 00       	call   80105540 <acquire>
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
801041ef:	e8 77 0d 00 00       	call   80104f6b <wakeup>
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
80104212:	e8 54 0d 00 00       	call   80104f6b <wakeup>
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
8010423b:	e8 67 13 00 00       	call   801055a7 <release>
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
8010425a:	e8 48 13 00 00       	call   801055a7 <release>
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
80104272:	e8 c9 12 00 00       	call   80105540 <acquire>
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
801042a7:	e8 fb 12 00 00       	call   801055a7 <release>
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
801042c5:	e8 a1 0c 00 00       	call   80104f6b <wakeup>
801042ca:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801042cd:	8b 45 08             	mov    0x8(%ebp),%eax
801042d0:	8b 55 08             	mov    0x8(%ebp),%edx
801042d3:	81 c2 38 02 00 00    	add    $0x238,%edx
801042d9:	83 ec 08             	sub    $0x8,%esp
801042dc:	50                   	push   %eax
801042dd:	52                   	push   %edx
801042de:	e8 a1 0b 00 00       	call   80104e84 <sleep>
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
80104347:	e8 1f 0c 00 00       	call   80104f6b <wakeup>
8010434c:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010434f:	8b 45 08             	mov    0x8(%ebp),%eax
80104352:	83 ec 0c             	sub    $0xc,%esp
80104355:	50                   	push   %eax
80104356:	e8 4c 12 00 00       	call   801055a7 <release>
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
80104371:	e8 ca 11 00 00       	call   80105540 <acquire>
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
8010438f:	e8 13 12 00 00       	call   801055a7 <release>
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
801043b2:	e8 cd 0a 00 00       	call   80104e84 <sleep>
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
80104446:	e8 20 0b 00 00       	call   80104f6b <wakeup>
8010444b:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010444e:	8b 45 08             	mov    0x8(%ebp),%eax
80104451:	83 ec 0c             	sub    $0xc,%esp
80104454:	50                   	push   %eax
80104455:	e8 4d 11 00 00       	call   801055a7 <release>
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
8010448c:	68 e8 8e 10 80       	push   $0x80108ee8
80104491:	68 80 39 11 80       	push   $0x80113980
80104496:	e8 83 10 00 00       	call   8010551e <initlock>
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
801044af:	e8 8c 10 00 00       	call   80105540 <acquire>
801044b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044b7:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801044be:	eb 11                	jmp    801044d1 <allocproc+0x30>
    if(p->state == UNUSED)
801044c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c3:	8b 40 0c             	mov    0xc(%eax),%eax
801044c6:	85 c0                	test   %eax,%eax
801044c8:	74 2a                	je     801044f4 <allocproc+0x53>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044ca:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
801044d1:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
801044d8:	72 e6                	jb     801044c0 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801044da:	83 ec 0c             	sub    $0xc,%esp
801044dd:	68 80 39 11 80       	push   $0x80113980
801044e2:	e8 c0 10 00 00       	call   801055a7 <release>
801044e7:	83 c4 10             	add    $0x10,%esp
  return 0;
801044ea:	b8 00 00 00 00       	mov    $0x0,%eax
801044ef:	e9 df 00 00 00       	jmp    801045d3 <allocproc+0x132>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
801044f4:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801044f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f8:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801044ff:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104504:	8d 50 01             	lea    0x1(%eax),%edx
80104507:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010450d:	89 c2                	mov    %eax,%edx
8010450f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104512:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
80104515:	83 ec 0c             	sub    $0xc,%esp
80104518:	68 80 39 11 80       	push   $0x80113980
8010451d:	e8 85 10 00 00       	call   801055a7 <release>
80104522:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104525:	e8 63 e7 ff ff       	call   80102c8d <kalloc>
8010452a:	89 c2                	mov    %eax,%edx
8010452c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452f:	89 50 08             	mov    %edx,0x8(%eax)
80104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104535:	8b 40 08             	mov    0x8(%eax),%eax
80104538:	85 c0                	test   %eax,%eax
8010453a:	75 14                	jne    80104550 <allocproc+0xaf>
    p->state = UNUSED;
8010453c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104546:	b8 00 00 00 00       	mov    $0x0,%eax
8010454b:	e9 83 00 00 00       	jmp    801045d3 <allocproc+0x132>
  }
  sp = p->kstack + KSTACKSIZE;
80104550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104553:	8b 40 08             	mov    0x8(%eax),%eax
80104556:	05 00 10 00 00       	add    $0x1000,%eax
8010455b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010455e:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104565:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104568:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010456b:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010456f:	ba db 6c 10 80       	mov    $0x80106cdb,%edx
80104574:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104577:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104579:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010457d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104580:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104583:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104589:	8b 40 1c             	mov    0x1c(%eax),%eax
8010458c:	83 ec 04             	sub    $0x4,%esp
8010458f:	6a 14                	push   $0x14
80104591:	6a 00                	push   $0x0
80104593:	50                   	push   %eax
80104594:	e8 0a 12 00 00       	call   801057a3 <memset>
80104599:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010459c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459f:	8b 40 1c             	mov    0x1c(%eax),%eax
801045a2:	ba 3e 4e 10 80       	mov    $0x80104e3e,%edx
801045a7:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // My code Allocate start ticks to global ticks variable
801045aa:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
801045b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b3:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total = 0; // My code p2
801045b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b9:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
801045c0:	00 00 00 
  p->cpu_ticks_in = 0;    // My code p2
801045c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c6:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
801045cd:	00 00 00 
  return p;
801045d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801045d3:	c9                   	leave  
801045d4:	c3                   	ret    

801045d5 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801045d5:	55                   	push   %ebp
801045d6:	89 e5                	mov    %esp,%ebp
801045d8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  ptable.pLists.free = 0;
801045db:	c7 05 b4 5e 11 80 00 	movl   $0x0,0x80115eb4
801045e2:	00 00 00 
  ptable.pLists.embryo = 0;
801045e5:	c7 05 b8 5e 11 80 00 	movl   $0x0,0x80115eb8
801045ec:	00 00 00 
  ptable.pLists.ready = 0;
801045ef:	c7 05 bc 5e 11 80 00 	movl   $0x0,0x80115ebc
801045f6:	00 00 00 
  ptable.pLists.running = 0;
801045f9:	c7 05 c0 5e 11 80 00 	movl   $0x0,0x80115ec0
80104600:	00 00 00 
  ptable.pLists.sleep = 0;
80104603:	c7 05 c4 5e 11 80 00 	movl   $0x0,0x80115ec4
8010460a:	00 00 00 
  ptable.pLists.zombie = 0;
8010460d:	c7 05 c8 5e 11 80 00 	movl   $0x0,0x80115ec8
80104614:	00 00 00 

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104617:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010461e:	eb 1c                	jmp    8010463c <userinit+0x67>
    add_to_list(&ptable.pLists.free, UNUSED, p);  
80104620:	83 ec 04             	sub    $0x4,%esp
80104623:	ff 75 f4             	pushl  -0xc(%ebp)
80104626:	6a 00                	push   $0x0
80104628:	68 b4 5e 11 80       	push   $0x80115eb4
8010462d:	e8 73 0e 00 00       	call   801054a5 <add_to_list>
80104632:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.running = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104635:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
8010463c:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104643:	72 db                	jb     80104620 <userinit+0x4b>
    add_to_list(&ptable.pLists.free, UNUSED, p);  

  p = allocproc();
80104645:	e8 57 fe ff ff       	call   801044a1 <allocproc>
8010464a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010464d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104650:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104655:	e8 20 3d 00 00       	call   8010837a <setupkvm>
8010465a:	89 c2                	mov    %eax,%edx
8010465c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465f:	89 50 04             	mov    %edx,0x4(%eax)
80104662:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104665:	8b 40 04             	mov    0x4(%eax),%eax
80104668:	85 c0                	test   %eax,%eax
8010466a:	75 0d                	jne    80104679 <userinit+0xa4>
    panic("userinit: out of memory?");
8010466c:	83 ec 0c             	sub    $0xc,%esp
8010466f:	68 ef 8e 10 80       	push   $0x80108eef
80104674:	e8 ed be ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104679:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010467e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104681:	8b 40 04             	mov    0x4(%eax),%eax
80104684:	83 ec 04             	sub    $0x4,%esp
80104687:	52                   	push   %edx
80104688:	68 00 c5 10 80       	push   $0x8010c500
8010468d:	50                   	push   %eax
8010468e:	e8 41 3f 00 00       	call   801085d4 <inituvm>
80104693:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104696:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104699:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010469f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a2:	8b 40 18             	mov    0x18(%eax),%eax
801046a5:	83 ec 04             	sub    $0x4,%esp
801046a8:	6a 4c                	push   $0x4c
801046aa:	6a 00                	push   $0x0
801046ac:	50                   	push   %eax
801046ad:	e8 f1 10 00 00       	call   801057a3 <memset>
801046b2:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801046b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b8:	8b 40 18             	mov    0x18(%eax),%eax
801046bb:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801046c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c4:	8b 40 18             	mov    0x18(%eax),%eax
801046c7:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801046cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d0:	8b 40 18             	mov    0x18(%eax),%eax
801046d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046d6:	8b 52 18             	mov    0x18(%edx),%edx
801046d9:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801046dd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801046e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e4:	8b 40 18             	mov    0x18(%eax),%eax
801046e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046ea:	8b 52 18             	mov    0x18(%edx),%edx
801046ed:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801046f1:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801046f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f8:	8b 40 18             	mov    0x18(%eax),%eax
801046fb:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104705:	8b 40 18             	mov    0x18(%eax),%eax
80104708:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104712:	8b 40 18             	mov    0x18(%eax),%eax
80104715:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->uid = DEFAULTUID; // p2
8010471c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471f:	c7 80 80 00 00 00 0a 	movl   $0xa,0x80(%eax)
80104726:	00 00 00 
  p->gid = DEFAULTGID; // p2
80104729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010472c:	c7 80 84 00 00 00 0a 	movl   $0xa,0x84(%eax)
80104733:	00 00 00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104739:	83 c0 6c             	add    $0x6c,%eax
8010473c:	83 ec 04             	sub    $0x4,%esp
8010473f:	6a 10                	push   $0x10
80104741:	68 08 8f 10 80       	push   $0x80108f08
80104746:	50                   	push   %eax
80104747:	e8 5a 12 00 00       	call   801059a6 <safestrcpy>
8010474c:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
8010474f:	83 ec 0c             	sub    $0xc,%esp
80104752:	68 11 8f 10 80       	push   $0x80108f11
80104757:	e8 f3 dd ff ff       	call   8010254f <namei>
8010475c:	83 c4 10             	add    $0x10,%esp
8010475f:	89 c2                	mov    %eax,%edx
80104761:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104764:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
80104767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104771:	90                   	nop
80104772:	c9                   	leave  
80104773:	c3                   	ret    

80104774 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010477a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104780:	8b 00                	mov    (%eax),%eax
80104782:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104785:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104789:	7e 31                	jle    801047bc <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010478b:	8b 55 08             	mov    0x8(%ebp),%edx
8010478e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104791:	01 c2                	add    %eax,%edx
80104793:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104799:	8b 40 04             	mov    0x4(%eax),%eax
8010479c:	83 ec 04             	sub    $0x4,%esp
8010479f:	52                   	push   %edx
801047a0:	ff 75 f4             	pushl  -0xc(%ebp)
801047a3:	50                   	push   %eax
801047a4:	e8 78 3f 00 00       	call   80108721 <allocuvm>
801047a9:	83 c4 10             	add    $0x10,%esp
801047ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047b3:	75 3e                	jne    801047f3 <growproc+0x7f>
      return -1;
801047b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047ba:	eb 59                	jmp    80104815 <growproc+0xa1>
  } else if(n < 0){
801047bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047c0:	79 31                	jns    801047f3 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801047c2:	8b 55 08             	mov    0x8(%ebp),%edx
801047c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c8:	01 c2                	add    %eax,%edx
801047ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047d0:	8b 40 04             	mov    0x4(%eax),%eax
801047d3:	83 ec 04             	sub    $0x4,%esp
801047d6:	52                   	push   %edx
801047d7:	ff 75 f4             	pushl  -0xc(%ebp)
801047da:	50                   	push   %eax
801047db:	e8 0a 40 00 00       	call   801087ea <deallocuvm>
801047e0:	83 c4 10             	add    $0x10,%esp
801047e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047ea:	75 07                	jne    801047f3 <growproc+0x7f>
      return -1;
801047ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047f1:	eb 22                	jmp    80104815 <growproc+0xa1>
  }
  proc->sz = sz;
801047f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047fc:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801047fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104804:	83 ec 0c             	sub    $0xc,%esp
80104807:	50                   	push   %eax
80104808:	e8 54 3c 00 00       	call   80108461 <switchuvm>
8010480d:	83 c4 10             	add    $0x10,%esp
  return 0;
80104810:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104815:	c9                   	leave  
80104816:	c3                   	ret    

80104817 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104817:	55                   	push   %ebp
80104818:	89 e5                	mov    %esp,%ebp
8010481a:	57                   	push   %edi
8010481b:	56                   	push   %esi
8010481c:	53                   	push   %ebx
8010481d:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104820:	e8 7c fc ff ff       	call   801044a1 <allocproc>
80104825:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104828:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010482c:	75 0a                	jne    80104838 <fork+0x21>
    return -1;
8010482e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104833:	e9 92 01 00 00       	jmp    801049ca <fork+0x1b3>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104838:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010483e:	8b 10                	mov    (%eax),%edx
80104840:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104846:	8b 40 04             	mov    0x4(%eax),%eax
80104849:	83 ec 08             	sub    $0x8,%esp
8010484c:	52                   	push   %edx
8010484d:	50                   	push   %eax
8010484e:	e8 35 41 00 00       	call   80108988 <copyuvm>
80104853:	83 c4 10             	add    $0x10,%esp
80104856:	89 c2                	mov    %eax,%edx
80104858:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010485b:	89 50 04             	mov    %edx,0x4(%eax)
8010485e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104861:	8b 40 04             	mov    0x4(%eax),%eax
80104864:	85 c0                	test   %eax,%eax
80104866:	75 30                	jne    80104898 <fork+0x81>
    kfree(np->kstack);
80104868:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010486b:	8b 40 08             	mov    0x8(%eax),%eax
8010486e:	83 ec 0c             	sub    $0xc,%esp
80104871:	50                   	push   %eax
80104872:	e8 79 e3 ff ff       	call   80102bf0 <kfree>
80104877:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010487a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010487d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104884:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104887:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010488e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104893:	e9 32 01 00 00       	jmp    801049ca <fork+0x1b3>
  }
  np->sz = proc->sz;
80104898:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010489e:	8b 10                	mov    (%eax),%edx
801048a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048a3:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801048a5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048af:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801048b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048b5:	8b 50 18             	mov    0x18(%eax),%edx
801048b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048be:	8b 40 18             	mov    0x18(%eax),%eax
801048c1:	89 c3                	mov    %eax,%ebx
801048c3:	b8 13 00 00 00       	mov    $0x13,%eax
801048c8:	89 d7                	mov    %edx,%edi
801048ca:	89 de                	mov    %ebx,%esi
801048cc:	89 c1                	mov    %eax,%ecx
801048ce:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // I'm pretty sure that this is where we put the uid/gid copy
  np -> uid = proc -> uid; // p2
801048d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d6:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801048dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048df:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np -> gid = proc -> gid; // p2
801048e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048eb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
801048f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048f4:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801048fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048fd:	8b 40 18             	mov    0x18(%eax),%eax
80104900:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104907:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010490e:	eb 43                	jmp    80104953 <fork+0x13c>
    if(proc->ofile[i])
80104910:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104916:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104919:	83 c2 08             	add    $0x8,%edx
8010491c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104920:	85 c0                	test   %eax,%eax
80104922:	74 2b                	je     8010494f <fork+0x138>
      np->ofile[i] = filedup(proc->ofile[i]);
80104924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010492a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010492d:	83 c2 08             	add    $0x8,%edx
80104930:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104934:	83 ec 0c             	sub    $0xc,%esp
80104937:	50                   	push   %eax
80104938:	e8 ea c6 ff ff       	call   80101027 <filedup>
8010493d:	83 c4 10             	add    $0x10,%esp
80104940:	89 c1                	mov    %eax,%ecx
80104942:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104945:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104948:	83 c2 08             	add    $0x8,%edx
8010494b:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np -> gid = proc -> gid; // p2

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010494f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104953:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104957:	7e b7                	jle    80104910 <fork+0xf9>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104959:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495f:	8b 40 68             	mov    0x68(%eax),%eax
80104962:	83 ec 0c             	sub    $0xc,%esp
80104965:	50                   	push   %eax
80104966:	e8 ec cf ff ff       	call   80101957 <idup>
8010496b:	83 c4 10             	add    $0x10,%esp
8010496e:	89 c2                	mov    %eax,%edx
80104970:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104973:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104976:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497c:	8d 50 6c             	lea    0x6c(%eax),%edx
8010497f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104982:	83 c0 6c             	add    $0x6c,%eax
80104985:	83 ec 04             	sub    $0x4,%esp
80104988:	6a 10                	push   $0x10
8010498a:	52                   	push   %edx
8010498b:	50                   	push   %eax
8010498c:	e8 15 10 00 00       	call   801059a6 <safestrcpy>
80104991:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104994:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104997:	8b 40 10             	mov    0x10(%eax),%eax
8010499a:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010499d:	83 ec 0c             	sub    $0xc,%esp
801049a0:	68 80 39 11 80       	push   $0x80113980
801049a5:	e8 96 0b 00 00       	call   80105540 <acquire>
801049aa:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801049ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049b0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801049b7:	83 ec 0c             	sub    $0xc,%esp
801049ba:	68 80 39 11 80       	push   $0x80113980
801049bf:	e8 e3 0b 00 00       	call   801055a7 <release>
801049c4:	83 c4 10             	add    $0x10,%esp
  
  return pid;
801049c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801049ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049cd:	5b                   	pop    %ebx
801049ce:	5e                   	pop    %esi
801049cf:	5f                   	pop    %edi
801049d0:	5d                   	pop    %ebp
801049d1:	c3                   	ret    

801049d2 <exit>:
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
801049d2:	55                   	push   %ebp
801049d3:	89 e5                	mov    %esp,%ebp
801049d5:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801049d8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049df:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801049e4:	39 c2                	cmp    %eax,%edx
801049e6:	75 0d                	jne    801049f5 <exit+0x23>
    panic("init exiting");
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	68 13 8f 10 80       	push   $0x80108f13
801049f0:	e8 71 bb ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801049f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801049fc:	eb 48                	jmp    80104a46 <exit+0x74>
    if(proc->ofile[fd]){
801049fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a04:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a07:	83 c2 08             	add    $0x8,%edx
80104a0a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a0e:	85 c0                	test   %eax,%eax
80104a10:	74 30                	je     80104a42 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104a12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a18:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a1b:	83 c2 08             	add    $0x8,%edx
80104a1e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a22:	83 ec 0c             	sub    $0xc,%esp
80104a25:	50                   	push   %eax
80104a26:	e8 4d c6 ff ff       	call   80101078 <fileclose>
80104a2b:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a34:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a37:	83 c2 08             	add    $0x8,%edx
80104a3a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a41:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a42:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a46:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a4a:	7e b2                	jle    801049fe <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104a4c:	e8 23 eb ff ff       	call   80103574 <begin_op>
  iput(proc->cwd);
80104a51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a57:	8b 40 68             	mov    0x68(%eax),%eax
80104a5a:	83 ec 0c             	sub    $0xc,%esp
80104a5d:	50                   	push   %eax
80104a5e:	e8 fe d0 ff ff       	call   80101b61 <iput>
80104a63:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a66:	e8 95 eb ff ff       	call   80103600 <end_op>
  proc->cwd = 0;
80104a6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a71:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104a78:	83 ec 0c             	sub    $0xc,%esp
80104a7b:	68 80 39 11 80       	push   $0x80113980
80104a80:	e8 bb 0a 00 00       	call   80105540 <acquire>
80104a85:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104a88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8e:	8b 40 14             	mov    0x14(%eax),%eax
80104a91:	83 ec 0c             	sub    $0xc,%esp
80104a94:	50                   	push   %eax
80104a95:	e8 8f 04 00 00       	call   80104f29 <wakeup1>
80104a9a:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a9d:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104aa4:	eb 3f                	jmp    80104ae5 <exit+0x113>
    if(p->parent == proc){
80104aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa9:	8b 50 14             	mov    0x14(%eax),%edx
80104aac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab2:	39 c2                	cmp    %eax,%edx
80104ab4:	75 28                	jne    80104ade <exit+0x10c>
      p->parent = initproc;
80104ab6:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104abf:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac5:	8b 40 0c             	mov    0xc(%eax),%eax
80104ac8:	83 f8 05             	cmp    $0x5,%eax
80104acb:	75 11                	jne    80104ade <exit+0x10c>
        wakeup1(initproc);
80104acd:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104ad2:	83 ec 0c             	sub    $0xc,%esp
80104ad5:	50                   	push   %eax
80104ad6:	e8 4e 04 00 00       	call   80104f29 <wakeup1>
80104adb:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ade:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104ae5:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104aec:	72 b8                	jb     80104aa6 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104aee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af4:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104afb:	e8 11 02 00 00       	call   80104d11 <sched>
  panic("zombie exit");
80104b00:	83 ec 0c             	sub    $0xc,%esp
80104b03:	68 20 8f 10 80       	push   $0x80108f20
80104b08:	e8 59 ba ff ff       	call   80100566 <panic>

80104b0d <wait>:
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
80104b0d:	55                   	push   %ebp
80104b0e:	89 e5                	mov    %esp,%ebp
80104b10:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b13:	83 ec 0c             	sub    $0xc,%esp
80104b16:	68 80 39 11 80       	push   $0x80113980
80104b1b:	e8 20 0a 00 00       	call   80105540 <acquire>
80104b20:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b2a:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104b31:	e9 a9 00 00 00       	jmp    80104bdf <wait+0xd2>
      if(p->parent != proc)
80104b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b39:	8b 50 14             	mov    0x14(%eax),%edx
80104b3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b42:	39 c2                	cmp    %eax,%edx
80104b44:	0f 85 8d 00 00 00    	jne    80104bd7 <wait+0xca>
        continue;
      havekids = 1;
80104b4a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b54:	8b 40 0c             	mov    0xc(%eax),%eax
80104b57:	83 f8 05             	cmp    $0x5,%eax
80104b5a:	75 7c                	jne    80104bd8 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b5f:	8b 40 10             	mov    0x10(%eax),%eax
80104b62:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b68:	8b 40 08             	mov    0x8(%eax),%eax
80104b6b:	83 ec 0c             	sub    $0xc,%esp
80104b6e:	50                   	push   %eax
80104b6f:	e8 7c e0 ff ff       	call   80102bf0 <kfree>
80104b74:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b84:	8b 40 04             	mov    0x4(%eax),%eax
80104b87:	83 ec 0c             	sub    $0xc,%esp
80104b8a:	50                   	push   %eax
80104b8b:	e8 17 3d 00 00       	call   801088a7 <freevm>
80104b90:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b96:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104baa:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb4:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbb:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104bc2:	83 ec 0c             	sub    $0xc,%esp
80104bc5:	68 80 39 11 80       	push   $0x80113980
80104bca:	e8 d8 09 00 00       	call   801055a7 <release>
80104bcf:	83 c4 10             	add    $0x10,%esp
        return pid;
80104bd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bd5:	eb 5b                	jmp    80104c32 <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104bd7:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bd8:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104bdf:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104be6:	0f 82 4a ff ff ff    	jb     80104b36 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104bec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bf0:	74 0d                	je     80104bff <wait+0xf2>
80104bf2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf8:	8b 40 24             	mov    0x24(%eax),%eax
80104bfb:	85 c0                	test   %eax,%eax
80104bfd:	74 17                	je     80104c16 <wait+0x109>
      release(&ptable.lock);
80104bff:	83 ec 0c             	sub    $0xc,%esp
80104c02:	68 80 39 11 80       	push   $0x80113980
80104c07:	e8 9b 09 00 00       	call   801055a7 <release>
80104c0c:	83 c4 10             	add    $0x10,%esp
      return -1;
80104c0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c14:	eb 1c                	jmp    80104c32 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c1c:	83 ec 08             	sub    $0x8,%esp
80104c1f:	68 80 39 11 80       	push   $0x80113980
80104c24:	50                   	push   %eax
80104c25:	e8 5a 02 00 00       	call   80104e84 <sleep>
80104c2a:	83 c4 10             	add    $0x10,%esp
  }
80104c2d:	e9 f1 fe ff ff       	jmp    80104b23 <wait+0x16>
}
80104c32:	c9                   	leave  
80104c33:	c3                   	ret    

80104c34 <scheduler>:
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c3a:	e8 3d f8 ff ff       	call   8010447c <sti>

    idle = 1;  // assume idle unless we schedule a process
80104c3f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c46:	83 ec 0c             	sub    $0xc,%esp
80104c49:	68 80 39 11 80       	push   $0x80113980
80104c4e:	e8 ed 08 00 00       	call   80105540 <acquire>
80104c53:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c56:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104c5d:	eb 7c                	jmp    80104cdb <scheduler+0xa7>
      if(p->state != RUNNABLE)
80104c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c62:	8b 40 0c             	mov    0xc(%eax),%eax
80104c65:	83 f8 03             	cmp    $0x3,%eax
80104c68:	75 69                	jne    80104cd3 <scheduler+0x9f>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
80104c6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      proc = p;
80104c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c74:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104c7a:	83 ec 0c             	sub    $0xc,%esp
80104c7d:	ff 75 f4             	pushl  -0xc(%ebp)
80104c80:	e8 dc 37 00 00       	call   80108461 <switchuvm>
80104c85:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8b:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      p->cpu_ticks_in = ticks; // My code p2
80104c92:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
80104c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c9b:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
      swtch(&cpu->scheduler, proc->context);
80104ca1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca7:	8b 40 1c             	mov    0x1c(%eax),%eax
80104caa:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104cb1:	83 c2 04             	add    $0x4,%edx
80104cb4:	83 ec 08             	sub    $0x8,%esp
80104cb7:	50                   	push   %eax
80104cb8:	52                   	push   %edx
80104cb9:	e8 59 0d 00 00       	call   80105a17 <swtch>
80104cbe:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104cc1:	e8 7e 37 00 00       	call   80108444 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104cc6:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104ccd:	00 00 00 00 
80104cd1:	eb 01                	jmp    80104cd4 <scheduler+0xa0>
    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104cd3:	90                   	nop
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cd4:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104cdb:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104ce2:	0f 82 77 ff ff ff    	jb     80104c5f <scheduler+0x2b>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104ce8:	83 ec 0c             	sub    $0xc,%esp
80104ceb:	68 80 39 11 80       	push   $0x80113980
80104cf0:	e8 b2 08 00 00       	call   801055a7 <release>
80104cf5:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
80104cf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104cfc:	0f 84 38 ff ff ff    	je     80104c3a <scheduler+0x6>
      sti();
80104d02:	e8 75 f7 ff ff       	call   8010447c <sti>
      hlt();
80104d07:	e8 59 f7 ff ff       	call   80104465 <hlt>
    }
  }
80104d0c:	e9 29 ff ff ff       	jmp    80104c3a <scheduler+0x6>

80104d11 <sched>:
// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
80104d11:	55                   	push   %ebp
80104d12:	89 e5                	mov    %esp,%ebp
80104d14:	53                   	push   %ebx
80104d15:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d18:	83 ec 0c             	sub    $0xc,%esp
80104d1b:	68 80 39 11 80       	push   $0x80113980
80104d20:	e8 4e 09 00 00       	call   80105673 <holding>
80104d25:	83 c4 10             	add    $0x10,%esp
80104d28:	85 c0                	test   %eax,%eax
80104d2a:	75 0d                	jne    80104d39 <sched+0x28>
    panic("sched ptable.lock");
80104d2c:	83 ec 0c             	sub    $0xc,%esp
80104d2f:	68 2c 8f 10 80       	push   $0x80108f2c
80104d34:	e8 2d b8 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104d39:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d3f:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d45:	83 f8 01             	cmp    $0x1,%eax
80104d48:	74 0d                	je     80104d57 <sched+0x46>
    panic("sched locks");
80104d4a:	83 ec 0c             	sub    $0xc,%esp
80104d4d:	68 3e 8f 10 80       	push   $0x80108f3e
80104d52:	e8 0f b8 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104d57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d5d:	8b 40 0c             	mov    0xc(%eax),%eax
80104d60:	83 f8 04             	cmp    $0x4,%eax
80104d63:	75 0d                	jne    80104d72 <sched+0x61>
    panic("sched running");
80104d65:	83 ec 0c             	sub    $0xc,%esp
80104d68:	68 4a 8f 10 80       	push   $0x80108f4a
80104d6d:	e8 f4 b7 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104d72:	e8 f5 f6 ff ff       	call   8010446c <readeflags>
80104d77:	25 00 02 00 00       	and    $0x200,%eax
80104d7c:	85 c0                	test   %eax,%eax
80104d7e:	74 0d                	je     80104d8d <sched+0x7c>
    panic("sched interruptible");
80104d80:	83 ec 0c             	sub    $0xc,%esp
80104d83:	68 58 8f 10 80       	push   $0x80108f58
80104d88:	e8 d9 b7 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104d8d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d93:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // My code p2
80104d9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104da9:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80104daf:	8b 1d e0 66 11 80    	mov    0x801166e0,%ebx
80104db5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104dbc:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80104dc2:	29 d3                	sub    %edx,%ebx
80104dc4:	89 da                	mov    %ebx,%edx
80104dc6:	01 ca                	add    %ecx,%edx
80104dc8:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
80104dce:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dd4:	8b 40 04             	mov    0x4(%eax),%eax
80104dd7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104dde:	83 c2 1c             	add    $0x1c,%edx
80104de1:	83 ec 08             	sub    $0x8,%esp
80104de4:	50                   	push   %eax
80104de5:	52                   	push   %edx
80104de6:	e8 2c 0c 00 00       	call   80105a17 <swtch>
80104deb:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104dee:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104df4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104df7:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104dfd:	90                   	nop
80104dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e01:	c9                   	leave  
80104e02:	c3                   	ret    

80104e03 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104e03:	55                   	push   %ebp
80104e04:	89 e5                	mov    %esp,%ebp
80104e06:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104e09:	83 ec 0c             	sub    $0xc,%esp
80104e0c:	68 80 39 11 80       	push   $0x80113980
80104e11:	e8 2a 07 00 00       	call   80105540 <acquire>
80104e16:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104e19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e1f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104e26:	e8 e6 fe ff ff       	call   80104d11 <sched>
  release(&ptable.lock);
80104e2b:	83 ec 0c             	sub    $0xc,%esp
80104e2e:	68 80 39 11 80       	push   $0x80113980
80104e33:	e8 6f 07 00 00       	call   801055a7 <release>
80104e38:	83 c4 10             	add    $0x10,%esp
}
80104e3b:	90                   	nop
80104e3c:	c9                   	leave  
80104e3d:	c3                   	ret    

80104e3e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104e3e:	55                   	push   %ebp
80104e3f:	89 e5                	mov    %esp,%ebp
80104e41:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104e44:	83 ec 0c             	sub    $0xc,%esp
80104e47:	68 80 39 11 80       	push   $0x80113980
80104e4c:	e8 56 07 00 00       	call   801055a7 <release>
80104e51:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104e54:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80104e59:	85 c0                	test   %eax,%eax
80104e5b:	74 24                	je     80104e81 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104e5d:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80104e64:	00 00 00 
    iinit(ROOTDEV);
80104e67:	83 ec 0c             	sub    $0xc,%esp
80104e6a:	6a 01                	push   $0x1
80104e6c:	e8 f4 c7 ff ff       	call   80101665 <iinit>
80104e71:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104e74:	83 ec 0c             	sub    $0xc,%esp
80104e77:	6a 01                	push   $0x1
80104e79:	e8 d8 e4 ff ff       	call   80103356 <initlog>
80104e7e:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104e81:	90                   	nop
80104e82:	c9                   	leave  
80104e83:	c3                   	ret    

80104e84 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104e8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e90:	85 c0                	test   %eax,%eax
80104e92:	75 0d                	jne    80104ea1 <sleep+0x1d>
    panic("sleep");
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	68 6c 8f 10 80       	push   $0x80108f6c
80104e9c:	e8 c5 b6 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80104ea1:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104ea8:	74 24                	je     80104ece <sleep+0x4a>
    acquire(&ptable.lock);
80104eaa:	83 ec 0c             	sub    $0xc,%esp
80104ead:	68 80 39 11 80       	push   $0x80113980
80104eb2:	e8 89 06 00 00       	call   80105540 <acquire>
80104eb7:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80104eba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104ebe:	74 0e                	je     80104ece <sleep+0x4a>
80104ec0:	83 ec 0c             	sub    $0xc,%esp
80104ec3:	ff 75 0c             	pushl  0xc(%ebp)
80104ec6:	e8 dc 06 00 00       	call   801055a7 <release>
80104ecb:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104ece:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ed4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ed7:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104eda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ee0:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104ee7:	e8 25 fe ff ff       	call   80104d11 <sched>

  // Tidy up.
  proc->chan = 0;
80104eec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ef2:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
80104ef9:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104f00:	74 24                	je     80104f26 <sleep+0xa2>
    release(&ptable.lock);
80104f02:	83 ec 0c             	sub    $0xc,%esp
80104f05:	68 80 39 11 80       	push   $0x80113980
80104f0a:	e8 98 06 00 00       	call   801055a7 <release>
80104f0f:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
80104f12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104f16:	74 0e                	je     80104f26 <sleep+0xa2>
80104f18:	83 ec 0c             	sub    $0xc,%esp
80104f1b:	ff 75 0c             	pushl  0xc(%ebp)
80104f1e:	e8 1d 06 00 00       	call   80105540 <acquire>
80104f23:	83 c4 10             	add    $0x10,%esp
  }
}
80104f26:	90                   	nop
80104f27:	c9                   	leave  
80104f28:	c3                   	ret    

80104f29 <wakeup1>:
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104f29:	55                   	push   %ebp
80104f2a:	89 e5                	mov    %esp,%ebp
80104f2c:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f2f:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104f36:	eb 27                	jmp    80104f5f <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f3b:	8b 40 0c             	mov    0xc(%eax),%eax
80104f3e:	83 f8 02             	cmp    $0x2,%eax
80104f41:	75 15                	jne    80104f58 <wakeup1+0x2f>
80104f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f46:	8b 40 20             	mov    0x20(%eax),%eax
80104f49:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f4c:	75 0a                	jne    80104f58 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f51:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f58:	81 45 fc 94 00 00 00 	addl   $0x94,-0x4(%ebp)
80104f5f:	81 7d fc b4 5e 11 80 	cmpl   $0x80115eb4,-0x4(%ebp)
80104f66:	72 d0                	jb     80104f38 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104f68:	90                   	nop
80104f69:	c9                   	leave  
80104f6a:	c3                   	ret    

80104f6b <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f6b:	55                   	push   %ebp
80104f6c:	89 e5                	mov    %esp,%ebp
80104f6e:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104f71:	83 ec 0c             	sub    $0xc,%esp
80104f74:	68 80 39 11 80       	push   $0x80113980
80104f79:	e8 c2 05 00 00       	call   80105540 <acquire>
80104f7e:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f81:	83 ec 0c             	sub    $0xc,%esp
80104f84:	ff 75 08             	pushl  0x8(%ebp)
80104f87:	e8 9d ff ff ff       	call   80104f29 <wakeup1>
80104f8c:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104f8f:	83 ec 0c             	sub    $0xc,%esp
80104f92:	68 80 39 11 80       	push   $0x80113980
80104f97:	e8 0b 06 00 00       	call   801055a7 <release>
80104f9c:	83 c4 10             	add    $0x10,%esp
}
80104f9f:	90                   	nop
80104fa0:	c9                   	leave  
80104fa1:	c3                   	ret    

80104fa2 <kill>:
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
80104fa2:	55                   	push   %ebp
80104fa3:	89 e5                	mov    %esp,%ebp
80104fa5:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	68 80 39 11 80       	push   $0x80113980
80104fb0:	e8 8b 05 00 00       	call   80105540 <acquire>
80104fb5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fb8:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104fbf:	eb 4a                	jmp    8010500b <kill+0x69>
    if(p->pid == pid){
80104fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc4:	8b 50 10             	mov    0x10(%eax),%edx
80104fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fca:	39 c2                	cmp    %eax,%edx
80104fcc:	75 36                	jne    80105004 <kill+0x62>
      p->killed = 1;
80104fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fdb:	8b 40 0c             	mov    0xc(%eax),%eax
80104fde:	83 f8 02             	cmp    $0x2,%eax
80104fe1:	75 0a                	jne    80104fed <kill+0x4b>
        p->state = RUNNABLE;
80104fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104fed:	83 ec 0c             	sub    $0xc,%esp
80104ff0:	68 80 39 11 80       	push   $0x80113980
80104ff5:	e8 ad 05 00 00       	call   801055a7 <release>
80104ffa:	83 c4 10             	add    $0x10,%esp
      return 0;
80104ffd:	b8 00 00 00 00       	mov    $0x0,%eax
80105002:	eb 25                	jmp    80105029 <kill+0x87>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105004:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
8010500b:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80105012:	72 ad                	jb     80104fc1 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	68 80 39 11 80       	push   $0x80113980
8010501c:	e8 86 05 00 00       	call   801055a7 <release>
80105021:	83 c4 10             	add    $0x10,%esp
  return -1;
80105024:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105029:	c9                   	leave  
8010502a:	c3                   	ret    

8010502b <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010502b:	55                   	push   %ebp
8010502c:	89 e5                	mov    %esp,%ebp
8010502e:	53                   	push   %ebx
8010502f:	83 ec 54             	sub    $0x54,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
80105032:	83 ec 08             	sub    $0x8,%esp
80105035:	68 9c 8f 10 80       	push   $0x80108f9c
8010503a:	68 a0 8f 10 80       	push   $0x80108fa0
8010503f:	68 a4 8f 10 80       	push   $0x80108fa4
80105044:	68 ac 8f 10 80       	push   $0x80108fac
80105049:	68 b2 8f 10 80       	push   $0x80108fb2
8010504e:	68 b7 8f 10 80       	push   $0x80108fb7
80105053:	68 bb 8f 10 80       	push   $0x80108fbb
80105058:	68 bf 8f 10 80       	push   $0x80108fbf
8010505d:	68 c4 8f 10 80       	push   $0x80108fc4
80105062:	68 c8 8f 10 80       	push   $0x80108fc8
80105067:	e8 5a b3 ff ff       	call   801003c6 <cprintf>
8010506c:	83 c4 30             	add    $0x30,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010506f:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80105076:	e9 2a 02 00 00       	jmp    801052a5 <procdump+0x27a>
    if(p->state == UNUSED)
8010507b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010507e:	8b 40 0c             	mov    0xc(%eax),%eax
80105081:	85 c0                	test   %eax,%eax
80105083:	0f 84 14 02 00 00    	je     8010529d <procdump+0x272>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105089:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010508c:	8b 40 0c             	mov    0xc(%eax),%eax
8010508f:	83 f8 05             	cmp    $0x5,%eax
80105092:	77 23                	ja     801050b7 <procdump+0x8c>
80105094:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105097:	8b 40 0c             	mov    0xc(%eax),%eax
8010509a:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801050a1:	85 c0                	test   %eax,%eax
801050a3:	74 12                	je     801050b7 <procdump+0x8c>
      state = states[p->state];
801050a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050a8:	8b 40 0c             	mov    0xc(%eax),%eax
801050ab:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801050b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801050b5:	eb 07                	jmp    801050be <procdump+0x93>
    else
      state = "???";
801050b7:	c7 45 ec ec 8f 10 80 	movl   $0x80108fec,-0x14(%ebp)
    uint seconds = (ticks - p->start_ticks)/100;
801050be:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
801050c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050c7:	8b 40 7c             	mov    0x7c(%eax),%eax
801050ca:	29 c2                	sub    %eax,%edx
801050cc:	89 d0                	mov    %edx,%eax
801050ce:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801050d3:	f7 e2                	mul    %edx
801050d5:	89 d0                	mov    %edx,%eax
801050d7:	c1 e8 05             	shr    $0x5,%eax
801050da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint partial_seconds = (ticks - p->start_ticks)%100;
801050dd:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
801050e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050e6:	8b 40 7c             	mov    0x7c(%eax),%eax
801050e9:	89 d1                	mov    %edx,%ecx
801050eb:	29 c1                	sub    %eax,%ecx
801050ed:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801050f2:	89 c8                	mov    %ecx,%eax
801050f4:	f7 e2                	mul    %edx
801050f6:	89 d0                	mov    %edx,%eax
801050f8:	c1 e8 05             	shr    $0x5,%eax
801050fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801050fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105101:	6b c0 64             	imul   $0x64,%eax,%eax
80105104:	29 c1                	sub    %eax,%ecx
80105106:	89 c8                	mov    %ecx,%eax
80105108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("%d\t %s\t %d\t %d\t", p->pid, p->name, p->uid, p->gid);
8010510b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010510e:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105117:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010511d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105120:	8d 58 6c             	lea    0x6c(%eax),%ebx
80105123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105126:	8b 40 10             	mov    0x10(%eax),%eax
80105129:	83 ec 0c             	sub    $0xc,%esp
8010512c:	51                   	push   %ecx
8010512d:	52                   	push   %edx
8010512e:	53                   	push   %ebx
8010512f:	50                   	push   %eax
80105130:	68 f0 8f 10 80       	push   $0x80108ff0
80105135:	e8 8c b2 ff ff       	call   801003c6 <cprintf>
8010513a:	83 c4 20             	add    $0x20,%esp
    if (p->parent)
8010513d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105140:	8b 40 14             	mov    0x14(%eax),%eax
80105143:	85 c0                	test   %eax,%eax
80105145:	74 1c                	je     80105163 <procdump+0x138>
      cprintf("%d\t", p->parent->pid);
80105147:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010514a:	8b 40 14             	mov    0x14(%eax),%eax
8010514d:	8b 40 10             	mov    0x10(%eax),%eax
80105150:	83 ec 08             	sub    $0x8,%esp
80105153:	50                   	push   %eax
80105154:	68 00 90 10 80       	push   $0x80109000
80105159:	e8 68 b2 ff ff       	call   801003c6 <cprintf>
8010515e:	83 c4 10             	add    $0x10,%esp
80105161:	eb 17                	jmp    8010517a <procdump+0x14f>
    else
      cprintf("%d\t", p->pid);
80105163:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105166:	8b 40 10             	mov    0x10(%eax),%eax
80105169:	83 ec 08             	sub    $0x8,%esp
8010516c:	50                   	push   %eax
8010516d:	68 00 90 10 80       	push   $0x80109000
80105172:	e8 4f b2 ff ff       	call   801003c6 <cprintf>
80105177:	83 c4 10             	add    $0x10,%esp
    cprintf(" %s\t %d.", state, seconds);
8010517a:	83 ec 04             	sub    $0x4,%esp
8010517d:	ff 75 e8             	pushl  -0x18(%ebp)
80105180:	ff 75 ec             	pushl  -0x14(%ebp)
80105183:	68 04 90 10 80       	push   $0x80109004
80105188:	e8 39 b2 ff ff       	call   801003c6 <cprintf>
8010518d:	83 c4 10             	add    $0x10,%esp
    if (partial_seconds < 10)
80105190:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
80105194:	77 10                	ja     801051a6 <procdump+0x17b>
	cprintf("0");
80105196:	83 ec 0c             	sub    $0xc,%esp
80105199:	68 0d 90 10 80       	push   $0x8010900d
8010519e:	e8 23 b2 ff ff       	call   801003c6 <cprintf>
801051a3:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t", partial_seconds);
801051a6:	83 ec 08             	sub    $0x8,%esp
801051a9:	ff 75 e4             	pushl  -0x1c(%ebp)
801051ac:	68 00 90 10 80       	push   $0x80109000
801051b1:	e8 10 b2 ff ff       	call   801003c6 <cprintf>
801051b6:	83 c4 10             	add    $0x10,%esp
    uint cpu_seconds = p->cpu_ticks_total/100;
801051b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051bc:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801051c2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801051c7:	f7 e2                	mul    %edx
801051c9:	89 d0                	mov    %edx,%eax
801051cb:	c1 e8 05             	shr    $0x5,%eax
801051ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    uint cpu_partial_seconds = p->cpu_ticks_total%100;
801051d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051d4:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
801051da:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801051df:	89 c8                	mov    %ecx,%eax
801051e1:	f7 e2                	mul    %edx
801051e3:	89 d0                	mov    %edx,%eax
801051e5:	c1 e8 05             	shr    $0x5,%eax
801051e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801051eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801051ee:	6b c0 64             	imul   $0x64,%eax,%eax
801051f1:	29 c1                	sub    %eax,%ecx
801051f3:	89 c8                	mov    %ecx,%eax
801051f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (cpu_partial_seconds < 10)
801051f8:	83 7d dc 09          	cmpl   $0x9,-0x24(%ebp)
801051fc:	77 18                	ja     80105216 <procdump+0x1eb>
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
801051fe:	83 ec 04             	sub    $0x4,%esp
80105201:	ff 75 dc             	pushl  -0x24(%ebp)
80105204:	ff 75 e0             	pushl  -0x20(%ebp)
80105207:	68 0f 90 10 80       	push   $0x8010900f
8010520c:	e8 b5 b1 ff ff       	call   801003c6 <cprintf>
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	eb 16                	jmp    8010522c <procdump+0x201>
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
80105216:	83 ec 04             	sub    $0x4,%esp
80105219:	ff 75 dc             	pushl  -0x24(%ebp)
8010521c:	ff 75 e0             	pushl  -0x20(%ebp)
8010521f:	68 19 90 10 80       	push   $0x80109019
80105224:	e8 9d b1 ff ff       	call   801003c6 <cprintf>
80105229:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
8010522c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010522f:	8b 40 0c             	mov    0xc(%eax),%eax
80105232:	83 f8 02             	cmp    $0x2,%eax
80105235:	75 54                	jne    8010528b <procdump+0x260>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105237:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010523a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010523d:	8b 40 0c             	mov    0xc(%eax),%eax
80105240:	83 c0 08             	add    $0x8,%eax
80105243:	89 c2                	mov    %eax,%edx
80105245:	83 ec 08             	sub    $0x8,%esp
80105248:	8d 45 b4             	lea    -0x4c(%ebp),%eax
8010524b:	50                   	push   %eax
8010524c:	52                   	push   %edx
8010524d:	e8 a7 03 00 00       	call   801055f9 <getcallerpcs>
80105252:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105255:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010525c:	eb 1c                	jmp    8010527a <procdump+0x24f>
        cprintf(" %p", pc[i]);
8010525e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105261:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
80105265:	83 ec 08             	sub    $0x8,%esp
80105268:	50                   	push   %eax
80105269:	68 22 90 10 80       	push   $0x80109022
8010526e:	e8 53 b1 ff ff       	call   801003c6 <cprintf>
80105273:	83 c4 10             	add    $0x10,%esp
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105276:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010527a:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010527e:	7f 0b                	jg     8010528b <procdump+0x260>
80105280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105283:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
80105287:	85 c0                	test   %eax,%eax
80105289:	75 d3                	jne    8010525e <procdump+0x233>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010528b:	83 ec 0c             	sub    $0xc,%esp
8010528e:	68 26 90 10 80       	push   $0x80109026
80105293:	e8 2e b1 ff ff       	call   801003c6 <cprintf>
80105298:	83 c4 10             	add    $0x10,%esp
8010529b:	eb 01                	jmp    8010529e <procdump+0x273>
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
8010529d:	90                   	nop
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010529e:	81 45 f0 94 00 00 00 	addl   $0x94,-0x10(%ebp)
801052a5:	81 7d f0 b4 5e 11 80 	cmpl   $0x80115eb4,-0x10(%ebp)
801052ac:	0f 82 c9 fd ff ff    	jb     8010507b <procdump+0x50>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801052b2:	90                   	nop
801052b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052b6:	c9                   	leave  
801052b7:	c3                   	ret    

801052b8 <free_length>:

// Counts the number of procs in the free list when ctrl-f is pressed
void
free_length()
{
801052b8:	55                   	push   %ebp
801052b9:	89 e5                	mov    %esp,%ebp
801052bb:	83 ec 18             	sub    $0x18,%esp
  struct proc* f = ptable.pLists.free;
801052be:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
801052c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
801052c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (!f)
801052cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052d1:	75 25                	jne    801052f8 <free_length+0x40>
    cprintf("Free List Size: %d\n", count);
801052d3:	83 ec 08             	sub    $0x8,%esp
801052d6:	ff 75 f0             	pushl  -0x10(%ebp)
801052d9:	68 28 90 10 80       	push   $0x80109028
801052de:	e8 e3 b0 ff ff       	call   801003c6 <cprintf>
801052e3:	83 c4 10             	add    $0x10,%esp
  while (f)
801052e6:	eb 10                	jmp    801052f8 <free_length+0x40>
  {
    ++count;
801052e8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    f = f->next;
801052ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ef:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801052f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc* f = ptable.pLists.free;
  int count = 0;
  if (!f)
    cprintf("Free List Size: %d\n", count);
  while (f)
801052f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052fc:	75 ea                	jne    801052e8 <free_length+0x30>
  {
    ++count;
    f = f->next;
  }
  cprintf("Free List Size: %d\n", count);
801052fe:	83 ec 08             	sub    $0x8,%esp
80105301:	ff 75 f0             	pushl  -0x10(%ebp)
80105304:	68 28 90 10 80       	push   $0x80109028
80105309:	e8 b8 b0 ff ff       	call   801003c6 <cprintf>
8010530e:	83 c4 10             	add    $0x10,%esp
}
80105311:	90                   	nop
80105312:	c9                   	leave  
80105313:	c3                   	ret    

80105314 <getproc_helper>:

int
getproc_helper(int m, struct uproc* table)
{
80105314:	55                   	push   %ebp
80105315:	89 e5                	mov    %esp,%ebp
80105317:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int i = 0;
8010531a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
80105321:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80105328:	e9 3d 01 00 00       	jmp    8010546a <getproc_helper+0x156>
  {
    if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
8010532d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105330:	8b 40 0c             	mov    0xc(%eax),%eax
80105333:	83 f8 04             	cmp    $0x4,%eax
80105336:	74 1a                	je     80105352 <getproc_helper+0x3e>
80105338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010533b:	8b 40 0c             	mov    0xc(%eax),%eax
8010533e:	83 f8 03             	cmp    $0x3,%eax
80105341:	74 0f                	je     80105352 <getproc_helper+0x3e>
80105343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105346:	8b 40 0c             	mov    0xc(%eax),%eax
80105349:	83 f8 02             	cmp    $0x2,%eax
8010534c:	0f 85 11 01 00 00    	jne    80105463 <getproc_helper+0x14f>
    {
      table[i].pid = p->pid;
80105352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105355:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105358:	8b 45 0c             	mov    0xc(%ebp),%eax
8010535b:	01 c2                	add    %eax,%edx
8010535d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105360:	8b 40 10             	mov    0x10(%eax),%eax
80105363:	89 02                	mov    %eax,(%edx)
      table[i].uid = p->uid;
80105365:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105368:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010536b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010536e:	01 c2                	add    %eax,%edx
80105370:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105373:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105379:	89 42 04             	mov    %eax,0x4(%edx)
      table[i].gid = p->gid;
8010537c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010537f:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105382:	8b 45 0c             	mov    0xc(%ebp),%eax
80105385:	01 c2                	add    %eax,%edx
80105387:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010538a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105390:	89 42 08             	mov    %eax,0x8(%edx)
      if (p->parent)
80105393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105396:	8b 40 14             	mov    0x14(%eax),%eax
80105399:	85 c0                	test   %eax,%eax
8010539b:	74 19                	je     801053b6 <getproc_helper+0xa2>
        table[i].ppid = p->parent->pid;
8010539d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053a0:	6b d0 5c             	imul   $0x5c,%eax,%edx
801053a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801053a6:	01 c2                	add    %eax,%edx
801053a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ab:	8b 40 14             	mov    0x14(%eax),%eax
801053ae:	8b 40 10             	mov    0x10(%eax),%eax
801053b1:	89 42 0c             	mov    %eax,0xc(%edx)
801053b4:	eb 14                	jmp    801053ca <getproc_helper+0xb6>
      else
        table[i].ppid = p->pid;
801053b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053b9:	6b d0 5c             	imul   $0x5c,%eax,%edx
801053bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801053bf:	01 c2                	add    %eax,%edx
801053c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c4:	8b 40 10             	mov    0x10(%eax),%eax
801053c7:	89 42 0c             	mov    %eax,0xc(%edx)
      table[i].elapsed_ticks = (ticks - p->start_ticks);
801053ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053cd:	6b d0 5c             	imul   $0x5c,%eax,%edx
801053d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801053d3:	01 c2                	add    %eax,%edx
801053d5:	8b 0d e0 66 11 80    	mov    0x801166e0,%ecx
801053db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053de:	8b 40 7c             	mov    0x7c(%eax),%eax
801053e1:	29 c1                	sub    %eax,%ecx
801053e3:	89 c8                	mov    %ecx,%eax
801053e5:	89 42 10             	mov    %eax,0x10(%edx)
      table[i].CPU_total_ticks = p->cpu_ticks_total;
801053e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053eb:	6b d0 5c             	imul   $0x5c,%eax,%edx
801053ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f1:	01 c2                	add    %eax,%edx
801053f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f6:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801053fc:	89 42 14             	mov    %eax,0x14(%edx)
      table[i].size = p->sz;
801053ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105402:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105405:	8b 45 0c             	mov    0xc(%ebp),%eax
80105408:	01 c2                	add    %eax,%edx
8010540a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010540d:	8b 00                	mov    (%eax),%eax
8010540f:	89 42 38             	mov    %eax,0x38(%edx)
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
80105412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105415:	8b 40 0c             	mov    0xc(%eax),%eax
80105418:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
8010541f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105422:	6b ca 5c             	imul   $0x5c,%edx,%ecx
80105425:	8b 55 0c             	mov    0xc(%ebp),%edx
80105428:	01 ca                	add    %ecx,%edx
8010542a:	83 c2 18             	add    $0x18,%edx
8010542d:	83 ec 04             	sub    $0x4,%esp
80105430:	6a 05                	push   $0x5
80105432:	50                   	push   %eax
80105433:	52                   	push   %edx
80105434:	e8 15 05 00 00       	call   8010594e <strncpy>
80105439:	83 c4 10             	add    $0x10,%esp
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
8010543c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543f:	8d 50 6c             	lea    0x6c(%eax),%edx
80105442:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105445:	6b c8 5c             	imul   $0x5c,%eax,%ecx
80105448:	8b 45 0c             	mov    0xc(%ebp),%eax
8010544b:	01 c8                	add    %ecx,%eax
8010544d:	83 c0 3c             	add    $0x3c,%eax
80105450:	83 ec 04             	sub    $0x4,%esp
80105453:	6a 11                	push   $0x11
80105455:	52                   	push   %edx
80105456:	50                   	push   %eax
80105457:	e8 f2 04 00 00       	call   8010594e <strncpy>
8010545c:	83 c4 10             	add    $0x10,%esp
      i++;
8010545f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
int
getproc_helper(int m, struct uproc* table)
{
  struct proc* p;
  int i = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
80105463:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
8010546a:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80105471:	73 0c                	jae    8010547f <getproc_helper+0x16b>
80105473:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105476:	3b 45 08             	cmp    0x8(%ebp),%eax
80105479:	0f 8c ae fe ff ff    	jl     8010532d <getproc_helper+0x19>
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
      i++;
    }
  }
  return i;  
8010547f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105482:	c9                   	leave  
80105483:	c3                   	ret    

80105484 <assert_state>:

// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
80105484:	55                   	push   %ebp
80105485:	89 e5                	mov    %esp,%ebp
80105487:	83 ec 08             	sub    $0x8,%esp
  if (p->state == state)
8010548a:	8b 45 08             	mov    0x8(%ebp),%eax
8010548d:	8b 40 0c             	mov    0xc(%eax),%eax
80105490:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105493:	74 0d                	je     801054a2 <assert_state+0x1e>
    return;
  panic("ERROR: States do not match.");
80105495:	83 ec 0c             	sub    $0xc,%esp
80105498:	68 3c 90 10 80       	push   $0x8010903c
8010549d:	e8 c4 b0 ff ff       	call   80100566 <panic>
// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
  if (p->state == state)
    return;
801054a2:	90                   	nop
  panic("ERROR: States do not match.");
}
801054a3:	c9                   	leave  
801054a4:	c3                   	ret    

801054a5 <add_to_list>:
*/

// Implementation of add_to_list
static int
add_to_list(struct proc** sList, enum procstate state, struct proc* p)
{
801054a5:	55                   	push   %ebp
801054a6:	89 e5                	mov    %esp,%ebp
801054a8:	83 ec 08             	sub    $0x8,%esp
  if (!p)
801054ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054af:	75 07                	jne    801054b8 <add_to_list+0x13>
    return -1;
801054b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b6:	eb 2c                	jmp    801054e4 <add_to_list+0x3f>
  assert_state(p, state);
801054b8:	83 ec 08             	sub    $0x8,%esp
801054bb:	ff 75 0c             	pushl  0xc(%ebp)
801054be:	ff 75 10             	pushl  0x10(%ebp)
801054c1:	e8 be ff ff ff       	call   80105484 <assert_state>
801054c6:	83 c4 10             	add    $0x10,%esp
  p->next = *sList;
801054c9:	8b 45 08             	mov    0x8(%ebp),%eax
801054cc:	8b 10                	mov    (%eax),%edx
801054ce:	8b 45 10             	mov    0x10(%ebp),%eax
801054d1:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  *sList = p;
801054d7:	8b 45 08             	mov    0x8(%ebp),%eax
801054da:	8b 55 10             	mov    0x10(%ebp),%edx
801054dd:	89 10                	mov    %edx,(%eax)
  return 0;
801054df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054e4:	c9                   	leave  
801054e5:	c3                   	ret    

801054e6 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801054e6:	55                   	push   %ebp
801054e7:	89 e5                	mov    %esp,%ebp
801054e9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801054ec:	9c                   	pushf  
801054ed:	58                   	pop    %eax
801054ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801054f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054f4:	c9                   	leave  
801054f5:	c3                   	ret    

801054f6 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801054f6:	55                   	push   %ebp
801054f7:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801054f9:	fa                   	cli    
}
801054fa:	90                   	nop
801054fb:	5d                   	pop    %ebp
801054fc:	c3                   	ret    

801054fd <sti>:

static inline void
sti(void)
{
801054fd:	55                   	push   %ebp
801054fe:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105500:	fb                   	sti    
}
80105501:	90                   	nop
80105502:	5d                   	pop    %ebp
80105503:	c3                   	ret    

80105504 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105504:	55                   	push   %ebp
80105505:	89 e5                	mov    %esp,%ebp
80105507:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010550a:	8b 55 08             	mov    0x8(%ebp),%edx
8010550d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105510:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105513:	f0 87 02             	lock xchg %eax,(%edx)
80105516:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105519:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010551c:	c9                   	leave  
8010551d:	c3                   	ret    

8010551e <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010551e:	55                   	push   %ebp
8010551f:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105521:	8b 45 08             	mov    0x8(%ebp),%eax
80105524:	8b 55 0c             	mov    0xc(%ebp),%edx
80105527:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010552a:	8b 45 08             	mov    0x8(%ebp),%eax
8010552d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105533:	8b 45 08             	mov    0x8(%ebp),%eax
80105536:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010553d:	90                   	nop
8010553e:	5d                   	pop    %ebp
8010553f:	c3                   	ret    

80105540 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105546:	e8 52 01 00 00       	call   8010569d <pushcli>
  if(holding(lk))
8010554b:	8b 45 08             	mov    0x8(%ebp),%eax
8010554e:	83 ec 0c             	sub    $0xc,%esp
80105551:	50                   	push   %eax
80105552:	e8 1c 01 00 00       	call   80105673 <holding>
80105557:	83 c4 10             	add    $0x10,%esp
8010555a:	85 c0                	test   %eax,%eax
8010555c:	74 0d                	je     8010556b <acquire+0x2b>
    panic("acquire");
8010555e:	83 ec 0c             	sub    $0xc,%esp
80105561:	68 58 90 10 80       	push   $0x80109058
80105566:	e8 fb af ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010556b:	90                   	nop
8010556c:	8b 45 08             	mov    0x8(%ebp),%eax
8010556f:	83 ec 08             	sub    $0x8,%esp
80105572:	6a 01                	push   $0x1
80105574:	50                   	push   %eax
80105575:	e8 8a ff ff ff       	call   80105504 <xchg>
8010557a:	83 c4 10             	add    $0x10,%esp
8010557d:	85 c0                	test   %eax,%eax
8010557f:	75 eb                	jne    8010556c <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105581:	8b 45 08             	mov    0x8(%ebp),%eax
80105584:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010558b:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010558e:	8b 45 08             	mov    0x8(%ebp),%eax
80105591:	83 c0 0c             	add    $0xc,%eax
80105594:	83 ec 08             	sub    $0x8,%esp
80105597:	50                   	push   %eax
80105598:	8d 45 08             	lea    0x8(%ebp),%eax
8010559b:	50                   	push   %eax
8010559c:	e8 58 00 00 00       	call   801055f9 <getcallerpcs>
801055a1:	83 c4 10             	add    $0x10,%esp
}
801055a4:	90                   	nop
801055a5:	c9                   	leave  
801055a6:	c3                   	ret    

801055a7 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801055a7:	55                   	push   %ebp
801055a8:	89 e5                	mov    %esp,%ebp
801055aa:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801055ad:	83 ec 0c             	sub    $0xc,%esp
801055b0:	ff 75 08             	pushl  0x8(%ebp)
801055b3:	e8 bb 00 00 00       	call   80105673 <holding>
801055b8:	83 c4 10             	add    $0x10,%esp
801055bb:	85 c0                	test   %eax,%eax
801055bd:	75 0d                	jne    801055cc <release+0x25>
    panic("release");
801055bf:	83 ec 0c             	sub    $0xc,%esp
801055c2:	68 60 90 10 80       	push   $0x80109060
801055c7:	e8 9a af ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801055cc:	8b 45 08             	mov    0x8(%ebp),%eax
801055cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801055d6:	8b 45 08             	mov    0x8(%ebp),%eax
801055d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801055e0:	8b 45 08             	mov    0x8(%ebp),%eax
801055e3:	83 ec 08             	sub    $0x8,%esp
801055e6:	6a 00                	push   $0x0
801055e8:	50                   	push   %eax
801055e9:	e8 16 ff ff ff       	call   80105504 <xchg>
801055ee:	83 c4 10             	add    $0x10,%esp

  popcli();
801055f1:	e8 ec 00 00 00       	call   801056e2 <popcli>
}
801055f6:	90                   	nop
801055f7:	c9                   	leave  
801055f8:	c3                   	ret    

801055f9 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801055f9:	55                   	push   %ebp
801055fa:	89 e5                	mov    %esp,%ebp
801055fc:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801055ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105602:	83 e8 08             	sub    $0x8,%eax
80105605:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105608:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010560f:	eb 38                	jmp    80105649 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105611:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105615:	74 53                	je     8010566a <getcallerpcs+0x71>
80105617:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010561e:	76 4a                	jbe    8010566a <getcallerpcs+0x71>
80105620:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105624:	74 44                	je     8010566a <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105626:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105629:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105630:	8b 45 0c             	mov    0xc(%ebp),%eax
80105633:	01 c2                	add    %eax,%edx
80105635:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105638:	8b 40 04             	mov    0x4(%eax),%eax
8010563b:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010563d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105640:	8b 00                	mov    (%eax),%eax
80105642:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105645:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105649:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010564d:	7e c2                	jle    80105611 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010564f:	eb 19                	jmp    8010566a <getcallerpcs+0x71>
    pcs[i] = 0;
80105651:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105654:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010565b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010565e:	01 d0                	add    %edx,%eax
80105660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105666:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010566a:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010566e:	7e e1                	jle    80105651 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105670:	90                   	nop
80105671:	c9                   	leave  
80105672:	c3                   	ret    

80105673 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105673:	55                   	push   %ebp
80105674:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105676:	8b 45 08             	mov    0x8(%ebp),%eax
80105679:	8b 00                	mov    (%eax),%eax
8010567b:	85 c0                	test   %eax,%eax
8010567d:	74 17                	je     80105696 <holding+0x23>
8010567f:	8b 45 08             	mov    0x8(%ebp),%eax
80105682:	8b 50 08             	mov    0x8(%eax),%edx
80105685:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010568b:	39 c2                	cmp    %eax,%edx
8010568d:	75 07                	jne    80105696 <holding+0x23>
8010568f:	b8 01 00 00 00       	mov    $0x1,%eax
80105694:	eb 05                	jmp    8010569b <holding+0x28>
80105696:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010569b:	5d                   	pop    %ebp
8010569c:	c3                   	ret    

8010569d <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010569d:	55                   	push   %ebp
8010569e:	89 e5                	mov    %esp,%ebp
801056a0:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801056a3:	e8 3e fe ff ff       	call   801054e6 <readeflags>
801056a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801056ab:	e8 46 fe ff ff       	call   801054f6 <cli>
  if(cpu->ncli++ == 0)
801056b0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801056b7:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801056bd:	8d 48 01             	lea    0x1(%eax),%ecx
801056c0:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801056c6:	85 c0                	test   %eax,%eax
801056c8:	75 15                	jne    801056df <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801056ca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056d3:	81 e2 00 02 00 00    	and    $0x200,%edx
801056d9:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801056df:	90                   	nop
801056e0:	c9                   	leave  
801056e1:	c3                   	ret    

801056e2 <popcli>:

void
popcli(void)
{
801056e2:	55                   	push   %ebp
801056e3:	89 e5                	mov    %esp,%ebp
801056e5:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801056e8:	e8 f9 fd ff ff       	call   801054e6 <readeflags>
801056ed:	25 00 02 00 00       	and    $0x200,%eax
801056f2:	85 c0                	test   %eax,%eax
801056f4:	74 0d                	je     80105703 <popcli+0x21>
    panic("popcli - interruptible");
801056f6:	83 ec 0c             	sub    $0xc,%esp
801056f9:	68 68 90 10 80       	push   $0x80109068
801056fe:	e8 63 ae ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80105703:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105709:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010570f:	83 ea 01             	sub    $0x1,%edx
80105712:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105718:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010571e:	85 c0                	test   %eax,%eax
80105720:	79 0d                	jns    8010572f <popcli+0x4d>
    panic("popcli");
80105722:	83 ec 0c             	sub    $0xc,%esp
80105725:	68 7f 90 10 80       	push   $0x8010907f
8010572a:	e8 37 ae ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010572f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105735:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010573b:	85 c0                	test   %eax,%eax
8010573d:	75 15                	jne    80105754 <popcli+0x72>
8010573f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105745:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010574b:	85 c0                	test   %eax,%eax
8010574d:	74 05                	je     80105754 <popcli+0x72>
    sti();
8010574f:	e8 a9 fd ff ff       	call   801054fd <sti>
}
80105754:	90                   	nop
80105755:	c9                   	leave  
80105756:	c3                   	ret    

80105757 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105757:	55                   	push   %ebp
80105758:	89 e5                	mov    %esp,%ebp
8010575a:	57                   	push   %edi
8010575b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010575c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010575f:	8b 55 10             	mov    0x10(%ebp),%edx
80105762:	8b 45 0c             	mov    0xc(%ebp),%eax
80105765:	89 cb                	mov    %ecx,%ebx
80105767:	89 df                	mov    %ebx,%edi
80105769:	89 d1                	mov    %edx,%ecx
8010576b:	fc                   	cld    
8010576c:	f3 aa                	rep stos %al,%es:(%edi)
8010576e:	89 ca                	mov    %ecx,%edx
80105770:	89 fb                	mov    %edi,%ebx
80105772:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105775:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105778:	90                   	nop
80105779:	5b                   	pop    %ebx
8010577a:	5f                   	pop    %edi
8010577b:	5d                   	pop    %ebp
8010577c:	c3                   	ret    

8010577d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010577d:	55                   	push   %ebp
8010577e:	89 e5                	mov    %esp,%ebp
80105780:	57                   	push   %edi
80105781:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105782:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105785:	8b 55 10             	mov    0x10(%ebp),%edx
80105788:	8b 45 0c             	mov    0xc(%ebp),%eax
8010578b:	89 cb                	mov    %ecx,%ebx
8010578d:	89 df                	mov    %ebx,%edi
8010578f:	89 d1                	mov    %edx,%ecx
80105791:	fc                   	cld    
80105792:	f3 ab                	rep stos %eax,%es:(%edi)
80105794:	89 ca                	mov    %ecx,%edx
80105796:	89 fb                	mov    %edi,%ebx
80105798:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010579b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010579e:	90                   	nop
8010579f:	5b                   	pop    %ebx
801057a0:	5f                   	pop    %edi
801057a1:	5d                   	pop    %ebp
801057a2:	c3                   	ret    

801057a3 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801057a3:	55                   	push   %ebp
801057a4:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801057a6:	8b 45 08             	mov    0x8(%ebp),%eax
801057a9:	83 e0 03             	and    $0x3,%eax
801057ac:	85 c0                	test   %eax,%eax
801057ae:	75 43                	jne    801057f3 <memset+0x50>
801057b0:	8b 45 10             	mov    0x10(%ebp),%eax
801057b3:	83 e0 03             	and    $0x3,%eax
801057b6:	85 c0                	test   %eax,%eax
801057b8:	75 39                	jne    801057f3 <memset+0x50>
    c &= 0xFF;
801057ba:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801057c1:	8b 45 10             	mov    0x10(%ebp),%eax
801057c4:	c1 e8 02             	shr    $0x2,%eax
801057c7:	89 c1                	mov    %eax,%ecx
801057c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801057cc:	c1 e0 18             	shl    $0x18,%eax
801057cf:	89 c2                	mov    %eax,%edx
801057d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801057d4:	c1 e0 10             	shl    $0x10,%eax
801057d7:	09 c2                	or     %eax,%edx
801057d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801057dc:	c1 e0 08             	shl    $0x8,%eax
801057df:	09 d0                	or     %edx,%eax
801057e1:	0b 45 0c             	or     0xc(%ebp),%eax
801057e4:	51                   	push   %ecx
801057e5:	50                   	push   %eax
801057e6:	ff 75 08             	pushl  0x8(%ebp)
801057e9:	e8 8f ff ff ff       	call   8010577d <stosl>
801057ee:	83 c4 0c             	add    $0xc,%esp
801057f1:	eb 12                	jmp    80105805 <memset+0x62>
  } else
    stosb(dst, c, n);
801057f3:	8b 45 10             	mov    0x10(%ebp),%eax
801057f6:	50                   	push   %eax
801057f7:	ff 75 0c             	pushl  0xc(%ebp)
801057fa:	ff 75 08             	pushl  0x8(%ebp)
801057fd:	e8 55 ff ff ff       	call   80105757 <stosb>
80105802:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105805:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105808:	c9                   	leave  
80105809:	c3                   	ret    

8010580a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010580a:	55                   	push   %ebp
8010580b:	89 e5                	mov    %esp,%ebp
8010580d:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105810:	8b 45 08             	mov    0x8(%ebp),%eax
80105813:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105816:	8b 45 0c             	mov    0xc(%ebp),%eax
80105819:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010581c:	eb 30                	jmp    8010584e <memcmp+0x44>
    if(*s1 != *s2)
8010581e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105821:	0f b6 10             	movzbl (%eax),%edx
80105824:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105827:	0f b6 00             	movzbl (%eax),%eax
8010582a:	38 c2                	cmp    %al,%dl
8010582c:	74 18                	je     80105846 <memcmp+0x3c>
      return *s1 - *s2;
8010582e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105831:	0f b6 00             	movzbl (%eax),%eax
80105834:	0f b6 d0             	movzbl %al,%edx
80105837:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010583a:	0f b6 00             	movzbl (%eax),%eax
8010583d:	0f b6 c0             	movzbl %al,%eax
80105840:	29 c2                	sub    %eax,%edx
80105842:	89 d0                	mov    %edx,%eax
80105844:	eb 1a                	jmp    80105860 <memcmp+0x56>
    s1++, s2++;
80105846:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010584a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010584e:	8b 45 10             	mov    0x10(%ebp),%eax
80105851:	8d 50 ff             	lea    -0x1(%eax),%edx
80105854:	89 55 10             	mov    %edx,0x10(%ebp)
80105857:	85 c0                	test   %eax,%eax
80105859:	75 c3                	jne    8010581e <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010585b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105860:	c9                   	leave  
80105861:	c3                   	ret    

80105862 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105862:	55                   	push   %ebp
80105863:	89 e5                	mov    %esp,%ebp
80105865:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105868:	8b 45 0c             	mov    0xc(%ebp),%eax
8010586b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010586e:	8b 45 08             	mov    0x8(%ebp),%eax
80105871:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105874:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105877:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010587a:	73 54                	jae    801058d0 <memmove+0x6e>
8010587c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010587f:	8b 45 10             	mov    0x10(%ebp),%eax
80105882:	01 d0                	add    %edx,%eax
80105884:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105887:	76 47                	jbe    801058d0 <memmove+0x6e>
    s += n;
80105889:	8b 45 10             	mov    0x10(%ebp),%eax
8010588c:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010588f:	8b 45 10             	mov    0x10(%ebp),%eax
80105892:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105895:	eb 13                	jmp    801058aa <memmove+0x48>
      *--d = *--s;
80105897:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010589b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010589f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058a2:	0f b6 10             	movzbl (%eax),%edx
801058a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058a8:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801058aa:	8b 45 10             	mov    0x10(%ebp),%eax
801058ad:	8d 50 ff             	lea    -0x1(%eax),%edx
801058b0:	89 55 10             	mov    %edx,0x10(%ebp)
801058b3:	85 c0                	test   %eax,%eax
801058b5:	75 e0                	jne    80105897 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801058b7:	eb 24                	jmp    801058dd <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801058b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058bc:	8d 50 01             	lea    0x1(%eax),%edx
801058bf:	89 55 f8             	mov    %edx,-0x8(%ebp)
801058c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058c5:	8d 4a 01             	lea    0x1(%edx),%ecx
801058c8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801058cb:	0f b6 12             	movzbl (%edx),%edx
801058ce:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801058d0:	8b 45 10             	mov    0x10(%ebp),%eax
801058d3:	8d 50 ff             	lea    -0x1(%eax),%edx
801058d6:	89 55 10             	mov    %edx,0x10(%ebp)
801058d9:	85 c0                	test   %eax,%eax
801058db:	75 dc                	jne    801058b9 <memmove+0x57>
      *d++ = *s++;

  return dst;
801058dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
801058e0:	c9                   	leave  
801058e1:	c3                   	ret    

801058e2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801058e2:	55                   	push   %ebp
801058e3:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801058e5:	ff 75 10             	pushl  0x10(%ebp)
801058e8:	ff 75 0c             	pushl  0xc(%ebp)
801058eb:	ff 75 08             	pushl  0x8(%ebp)
801058ee:	e8 6f ff ff ff       	call   80105862 <memmove>
801058f3:	83 c4 0c             	add    $0xc,%esp
}
801058f6:	c9                   	leave  
801058f7:	c3                   	ret    

801058f8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801058f8:	55                   	push   %ebp
801058f9:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801058fb:	eb 0c                	jmp    80105909 <strncmp+0x11>
    n--, p++, q++;
801058fd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105901:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105905:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105909:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010590d:	74 1a                	je     80105929 <strncmp+0x31>
8010590f:	8b 45 08             	mov    0x8(%ebp),%eax
80105912:	0f b6 00             	movzbl (%eax),%eax
80105915:	84 c0                	test   %al,%al
80105917:	74 10                	je     80105929 <strncmp+0x31>
80105919:	8b 45 08             	mov    0x8(%ebp),%eax
8010591c:	0f b6 10             	movzbl (%eax),%edx
8010591f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105922:	0f b6 00             	movzbl (%eax),%eax
80105925:	38 c2                	cmp    %al,%dl
80105927:	74 d4                	je     801058fd <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105929:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010592d:	75 07                	jne    80105936 <strncmp+0x3e>
    return 0;
8010592f:	b8 00 00 00 00       	mov    $0x0,%eax
80105934:	eb 16                	jmp    8010594c <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105936:	8b 45 08             	mov    0x8(%ebp),%eax
80105939:	0f b6 00             	movzbl (%eax),%eax
8010593c:	0f b6 d0             	movzbl %al,%edx
8010593f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105942:	0f b6 00             	movzbl (%eax),%eax
80105945:	0f b6 c0             	movzbl %al,%eax
80105948:	29 c2                	sub    %eax,%edx
8010594a:	89 d0                	mov    %edx,%eax
}
8010594c:	5d                   	pop    %ebp
8010594d:	c3                   	ret    

8010594e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010594e:	55                   	push   %ebp
8010594f:	89 e5                	mov    %esp,%ebp
80105951:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105954:	8b 45 08             	mov    0x8(%ebp),%eax
80105957:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010595a:	90                   	nop
8010595b:	8b 45 10             	mov    0x10(%ebp),%eax
8010595e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105961:	89 55 10             	mov    %edx,0x10(%ebp)
80105964:	85 c0                	test   %eax,%eax
80105966:	7e 2c                	jle    80105994 <strncpy+0x46>
80105968:	8b 45 08             	mov    0x8(%ebp),%eax
8010596b:	8d 50 01             	lea    0x1(%eax),%edx
8010596e:	89 55 08             	mov    %edx,0x8(%ebp)
80105971:	8b 55 0c             	mov    0xc(%ebp),%edx
80105974:	8d 4a 01             	lea    0x1(%edx),%ecx
80105977:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010597a:	0f b6 12             	movzbl (%edx),%edx
8010597d:	88 10                	mov    %dl,(%eax)
8010597f:	0f b6 00             	movzbl (%eax),%eax
80105982:	84 c0                	test   %al,%al
80105984:	75 d5                	jne    8010595b <strncpy+0xd>
    ;
  while(n-- > 0)
80105986:	eb 0c                	jmp    80105994 <strncpy+0x46>
    *s++ = 0;
80105988:	8b 45 08             	mov    0x8(%ebp),%eax
8010598b:	8d 50 01             	lea    0x1(%eax),%edx
8010598e:	89 55 08             	mov    %edx,0x8(%ebp)
80105991:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105994:	8b 45 10             	mov    0x10(%ebp),%eax
80105997:	8d 50 ff             	lea    -0x1(%eax),%edx
8010599a:	89 55 10             	mov    %edx,0x10(%ebp)
8010599d:	85 c0                	test   %eax,%eax
8010599f:	7f e7                	jg     80105988 <strncpy+0x3a>
    *s++ = 0;
  return os;
801059a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059a4:	c9                   	leave  
801059a5:	c3                   	ret    

801059a6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801059a6:	55                   	push   %ebp
801059a7:	89 e5                	mov    %esp,%ebp
801059a9:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801059ac:	8b 45 08             	mov    0x8(%ebp),%eax
801059af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801059b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059b6:	7f 05                	jg     801059bd <safestrcpy+0x17>
    return os;
801059b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059bb:	eb 31                	jmp    801059ee <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801059bd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801059c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059c5:	7e 1e                	jle    801059e5 <safestrcpy+0x3f>
801059c7:	8b 45 08             	mov    0x8(%ebp),%eax
801059ca:	8d 50 01             	lea    0x1(%eax),%edx
801059cd:	89 55 08             	mov    %edx,0x8(%ebp)
801059d0:	8b 55 0c             	mov    0xc(%ebp),%edx
801059d3:	8d 4a 01             	lea    0x1(%edx),%ecx
801059d6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801059d9:	0f b6 12             	movzbl (%edx),%edx
801059dc:	88 10                	mov    %dl,(%eax)
801059de:	0f b6 00             	movzbl (%eax),%eax
801059e1:	84 c0                	test   %al,%al
801059e3:	75 d8                	jne    801059bd <safestrcpy+0x17>
    ;
  *s = 0;
801059e5:	8b 45 08             	mov    0x8(%ebp),%eax
801059e8:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801059eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059ee:	c9                   	leave  
801059ef:	c3                   	ret    

801059f0 <strlen>:

int
strlen(const char *s)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801059f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801059fd:	eb 04                	jmp    80105a03 <strlen+0x13>
801059ff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a03:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a06:	8b 45 08             	mov    0x8(%ebp),%eax
80105a09:	01 d0                	add    %edx,%eax
80105a0b:	0f b6 00             	movzbl (%eax),%eax
80105a0e:	84 c0                	test   %al,%al
80105a10:	75 ed                	jne    801059ff <strlen+0xf>
    ;
  return n;
80105a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a15:	c9                   	leave  
80105a16:	c3                   	ret    

80105a17 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105a17:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105a1b:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105a1f:	55                   	push   %ebp
  pushl %ebx
80105a20:	53                   	push   %ebx
  pushl %esi
80105a21:	56                   	push   %esi
  pushl %edi
80105a22:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105a23:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105a25:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105a27:	5f                   	pop    %edi
  popl %esi
80105a28:	5e                   	pop    %esi
  popl %ebx
80105a29:	5b                   	pop    %ebx
  popl %ebp
80105a2a:	5d                   	pop    %ebp
  ret
80105a2b:	c3                   	ret    

80105a2c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105a2c:	55                   	push   %ebp
80105a2d:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105a2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a35:	8b 00                	mov    (%eax),%eax
80105a37:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a3a:	76 12                	jbe    80105a4e <fetchint+0x22>
80105a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80105a3f:	8d 50 04             	lea    0x4(%eax),%edx
80105a42:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a48:	8b 00                	mov    (%eax),%eax
80105a4a:	39 c2                	cmp    %eax,%edx
80105a4c:	76 07                	jbe    80105a55 <fetchint+0x29>
    return -1;
80105a4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a53:	eb 0f                	jmp    80105a64 <fetchint+0x38>
  *ip = *(int*)(addr);
80105a55:	8b 45 08             	mov    0x8(%ebp),%eax
80105a58:	8b 10                	mov    (%eax),%edx
80105a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a5d:	89 10                	mov    %edx,(%eax)
  return 0;
80105a5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a64:	5d                   	pop    %ebp
80105a65:	c3                   	ret    

80105a66 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105a66:	55                   	push   %ebp
80105a67:	89 e5                	mov    %esp,%ebp
80105a69:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105a6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a72:	8b 00                	mov    (%eax),%eax
80105a74:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a77:	77 07                	ja     80105a80 <fetchstr+0x1a>
    return -1;
80105a79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7e:	eb 46                	jmp    80105ac6 <fetchstr+0x60>
  *pp = (char*)addr;
80105a80:	8b 55 08             	mov    0x8(%ebp),%edx
80105a83:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a86:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105a88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a8e:	8b 00                	mov    (%eax),%eax
80105a90:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105a93:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a96:	8b 00                	mov    (%eax),%eax
80105a98:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105a9b:	eb 1c                	jmp    80105ab9 <fetchstr+0x53>
    if(*s == 0)
80105a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aa0:	0f b6 00             	movzbl (%eax),%eax
80105aa3:	84 c0                	test   %al,%al
80105aa5:	75 0e                	jne    80105ab5 <fetchstr+0x4f>
      return s - *pp;
80105aa7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aad:	8b 00                	mov    (%eax),%eax
80105aaf:	29 c2                	sub    %eax,%edx
80105ab1:	89 d0                	mov    %edx,%eax
80105ab3:	eb 11                	jmp    80105ac6 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105ab5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105abc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105abf:	72 dc                	jb     80105a9d <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105ac1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ac6:	c9                   	leave  
80105ac7:	c3                   	ret    

80105ac8 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105ac8:	55                   	push   %ebp
80105ac9:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105acb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ad1:	8b 40 18             	mov    0x18(%eax),%eax
80105ad4:	8b 40 44             	mov    0x44(%eax),%eax
80105ad7:	8b 55 08             	mov    0x8(%ebp),%edx
80105ada:	c1 e2 02             	shl    $0x2,%edx
80105add:	01 d0                	add    %edx,%eax
80105adf:	83 c0 04             	add    $0x4,%eax
80105ae2:	ff 75 0c             	pushl  0xc(%ebp)
80105ae5:	50                   	push   %eax
80105ae6:	e8 41 ff ff ff       	call   80105a2c <fetchint>
80105aeb:	83 c4 08             	add    $0x8,%esp
}
80105aee:	c9                   	leave  
80105aef:	c3                   	ret    

80105af0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105af6:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105af9:	50                   	push   %eax
80105afa:	ff 75 08             	pushl  0x8(%ebp)
80105afd:	e8 c6 ff ff ff       	call   80105ac8 <argint>
80105b02:	83 c4 08             	add    $0x8,%esp
80105b05:	85 c0                	test   %eax,%eax
80105b07:	79 07                	jns    80105b10 <argptr+0x20>
    return -1;
80105b09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b0e:	eb 3b                	jmp    80105b4b <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105b10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b16:	8b 00                	mov    (%eax),%eax
80105b18:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b1b:	39 d0                	cmp    %edx,%eax
80105b1d:	76 16                	jbe    80105b35 <argptr+0x45>
80105b1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b22:	89 c2                	mov    %eax,%edx
80105b24:	8b 45 10             	mov    0x10(%ebp),%eax
80105b27:	01 c2                	add    %eax,%edx
80105b29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b2f:	8b 00                	mov    (%eax),%eax
80105b31:	39 c2                	cmp    %eax,%edx
80105b33:	76 07                	jbe    80105b3c <argptr+0x4c>
    return -1;
80105b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3a:	eb 0f                	jmp    80105b4b <argptr+0x5b>
  *pp = (char*)i;
80105b3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b3f:	89 c2                	mov    %eax,%edx
80105b41:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b44:	89 10                	mov    %edx,(%eax)
  return 0;
80105b46:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b4b:	c9                   	leave  
80105b4c:	c3                   	ret    

80105b4d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105b4d:	55                   	push   %ebp
80105b4e:	89 e5                	mov    %esp,%ebp
80105b50:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105b53:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b56:	50                   	push   %eax
80105b57:	ff 75 08             	pushl  0x8(%ebp)
80105b5a:	e8 69 ff ff ff       	call   80105ac8 <argint>
80105b5f:	83 c4 08             	add    $0x8,%esp
80105b62:	85 c0                	test   %eax,%eax
80105b64:	79 07                	jns    80105b6d <argstr+0x20>
    return -1;
80105b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6b:	eb 0f                	jmp    80105b7c <argstr+0x2f>
  return fetchstr(addr, pp);
80105b6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b70:	ff 75 0c             	pushl  0xc(%ebp)
80105b73:	50                   	push   %eax
80105b74:	e8 ed fe ff ff       	call   80105a66 <fetchstr>
80105b79:	83 c4 08             	add    $0x8,%esp
}
80105b7c:	c9                   	leave  
80105b7d:	c3                   	ret    

80105b7e <syscall>:
};
#endif 

void
syscall(void)
{
80105b7e:	55                   	push   %ebp
80105b7f:	89 e5                	mov    %esp,%ebp
80105b81:	53                   	push   %ebx
80105b82:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105b85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b8b:	8b 40 18             	mov    0x18(%eax),%eax
80105b8e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105b91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105b94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b98:	7e 30                	jle    80105bca <syscall+0x4c>
80105b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b9d:	83 f8 1d             	cmp    $0x1d,%eax
80105ba0:	77 28                	ja     80105bca <syscall+0x4c>
80105ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba5:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105bac:	85 c0                	test   %eax,%eax
80105bae:	74 1a                	je     80105bca <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105bb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bb6:	8b 58 18             	mov    0x18(%eax),%ebx
80105bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bbc:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105bc3:	ff d0                	call   *%eax
80105bc5:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105bc8:	eb 34                	jmp    80105bfe <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105bca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bd0:	8d 50 6c             	lea    0x6c(%eax),%edx
80105bd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105bd9:	8b 40 10             	mov    0x10(%eax),%eax
80105bdc:	ff 75 f4             	pushl  -0xc(%ebp)
80105bdf:	52                   	push   %edx
80105be0:	50                   	push   %eax
80105be1:	68 86 90 10 80       	push   $0x80109086
80105be6:	e8 db a7 ff ff       	call   801003c6 <cprintf>
80105beb:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105bee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bf4:	8b 40 18             	mov    0x18(%eax),%eax
80105bf7:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105bfe:	90                   	nop
80105bff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c02:	c9                   	leave  
80105c03:	c3                   	ret    

80105c04 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105c04:	55                   	push   %ebp
80105c05:	89 e5                	mov    %esp,%ebp
80105c07:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105c0a:	83 ec 08             	sub    $0x8,%esp
80105c0d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c10:	50                   	push   %eax
80105c11:	ff 75 08             	pushl  0x8(%ebp)
80105c14:	e8 af fe ff ff       	call   80105ac8 <argint>
80105c19:	83 c4 10             	add    $0x10,%esp
80105c1c:	85 c0                	test   %eax,%eax
80105c1e:	79 07                	jns    80105c27 <argfd+0x23>
    return -1;
80105c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c25:	eb 50                	jmp    80105c77 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2a:	85 c0                	test   %eax,%eax
80105c2c:	78 21                	js     80105c4f <argfd+0x4b>
80105c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c31:	83 f8 0f             	cmp    $0xf,%eax
80105c34:	7f 19                	jg     80105c4f <argfd+0x4b>
80105c36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c3f:	83 c2 08             	add    $0x8,%edx
80105c42:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c4d:	75 07                	jne    80105c56 <argfd+0x52>
    return -1;
80105c4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c54:	eb 21                	jmp    80105c77 <argfd+0x73>
  if(pfd)
80105c56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105c5a:	74 08                	je     80105c64 <argfd+0x60>
    *pfd = fd;
80105c5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c62:	89 10                	mov    %edx,(%eax)
  if(pf)
80105c64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c68:	74 08                	je     80105c72 <argfd+0x6e>
    *pf = f;
80105c6a:	8b 45 10             	mov    0x10(%ebp),%eax
80105c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c70:	89 10                	mov    %edx,(%eax)
  return 0;
80105c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c77:	c9                   	leave  
80105c78:	c3                   	ret    

80105c79 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105c79:	55                   	push   %ebp
80105c7a:	89 e5                	mov    %esp,%ebp
80105c7c:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105c86:	eb 30                	jmp    80105cb8 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105c88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c91:	83 c2 08             	add    $0x8,%edx
80105c94:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	75 18                	jne    80105cb4 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105c9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ca2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ca5:	8d 4a 08             	lea    0x8(%edx),%ecx
80105ca8:	8b 55 08             	mov    0x8(%ebp),%edx
80105cab:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cb2:	eb 0f                	jmp    80105cc3 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105cb4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105cb8:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105cbc:	7e ca                	jle    80105c88 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105cbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc3:	c9                   	leave  
80105cc4:	c3                   	ret    

80105cc5 <sys_dup>:

int
sys_dup(void)
{
80105cc5:	55                   	push   %ebp
80105cc6:	89 e5                	mov    %esp,%ebp
80105cc8:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105ccb:	83 ec 04             	sub    $0x4,%esp
80105cce:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cd1:	50                   	push   %eax
80105cd2:	6a 00                	push   $0x0
80105cd4:	6a 00                	push   $0x0
80105cd6:	e8 29 ff ff ff       	call   80105c04 <argfd>
80105cdb:	83 c4 10             	add    $0x10,%esp
80105cde:	85 c0                	test   %eax,%eax
80105ce0:	79 07                	jns    80105ce9 <sys_dup+0x24>
    return -1;
80105ce2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce7:	eb 31                	jmp    80105d1a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cec:	83 ec 0c             	sub    $0xc,%esp
80105cef:	50                   	push   %eax
80105cf0:	e8 84 ff ff ff       	call   80105c79 <fdalloc>
80105cf5:	83 c4 10             	add    $0x10,%esp
80105cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cff:	79 07                	jns    80105d08 <sys_dup+0x43>
    return -1;
80105d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d06:	eb 12                	jmp    80105d1a <sys_dup+0x55>
  filedup(f);
80105d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0b:	83 ec 0c             	sub    $0xc,%esp
80105d0e:	50                   	push   %eax
80105d0f:	e8 13 b3 ff ff       	call   80101027 <filedup>
80105d14:	83 c4 10             	add    $0x10,%esp
  return fd;
80105d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105d1a:	c9                   	leave  
80105d1b:	c3                   	ret    

80105d1c <sys_read>:

int
sys_read(void)
{
80105d1c:	55                   	push   %ebp
80105d1d:	89 e5                	mov    %esp,%ebp
80105d1f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d22:	83 ec 04             	sub    $0x4,%esp
80105d25:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d28:	50                   	push   %eax
80105d29:	6a 00                	push   $0x0
80105d2b:	6a 00                	push   $0x0
80105d2d:	e8 d2 fe ff ff       	call   80105c04 <argfd>
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	85 c0                	test   %eax,%eax
80105d37:	78 2e                	js     80105d67 <sys_read+0x4b>
80105d39:	83 ec 08             	sub    $0x8,%esp
80105d3c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d3f:	50                   	push   %eax
80105d40:	6a 02                	push   $0x2
80105d42:	e8 81 fd ff ff       	call   80105ac8 <argint>
80105d47:	83 c4 10             	add    $0x10,%esp
80105d4a:	85 c0                	test   %eax,%eax
80105d4c:	78 19                	js     80105d67 <sys_read+0x4b>
80105d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d51:	83 ec 04             	sub    $0x4,%esp
80105d54:	50                   	push   %eax
80105d55:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d58:	50                   	push   %eax
80105d59:	6a 01                	push   $0x1
80105d5b:	e8 90 fd ff ff       	call   80105af0 <argptr>
80105d60:	83 c4 10             	add    $0x10,%esp
80105d63:	85 c0                	test   %eax,%eax
80105d65:	79 07                	jns    80105d6e <sys_read+0x52>
    return -1;
80105d67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d6c:	eb 17                	jmp    80105d85 <sys_read+0x69>
  return fileread(f, p, n);
80105d6e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105d71:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d77:	83 ec 04             	sub    $0x4,%esp
80105d7a:	51                   	push   %ecx
80105d7b:	52                   	push   %edx
80105d7c:	50                   	push   %eax
80105d7d:	e8 35 b4 ff ff       	call   801011b7 <fileread>
80105d82:	83 c4 10             	add    $0x10,%esp
}
80105d85:	c9                   	leave  
80105d86:	c3                   	ret    

80105d87 <sys_write>:

int
sys_write(void)
{
80105d87:	55                   	push   %ebp
80105d88:	89 e5                	mov    %esp,%ebp
80105d8a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d8d:	83 ec 04             	sub    $0x4,%esp
80105d90:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d93:	50                   	push   %eax
80105d94:	6a 00                	push   $0x0
80105d96:	6a 00                	push   $0x0
80105d98:	e8 67 fe ff ff       	call   80105c04 <argfd>
80105d9d:	83 c4 10             	add    $0x10,%esp
80105da0:	85 c0                	test   %eax,%eax
80105da2:	78 2e                	js     80105dd2 <sys_write+0x4b>
80105da4:	83 ec 08             	sub    $0x8,%esp
80105da7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105daa:	50                   	push   %eax
80105dab:	6a 02                	push   $0x2
80105dad:	e8 16 fd ff ff       	call   80105ac8 <argint>
80105db2:	83 c4 10             	add    $0x10,%esp
80105db5:	85 c0                	test   %eax,%eax
80105db7:	78 19                	js     80105dd2 <sys_write+0x4b>
80105db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dbc:	83 ec 04             	sub    $0x4,%esp
80105dbf:	50                   	push   %eax
80105dc0:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dc3:	50                   	push   %eax
80105dc4:	6a 01                	push   $0x1
80105dc6:	e8 25 fd ff ff       	call   80105af0 <argptr>
80105dcb:	83 c4 10             	add    $0x10,%esp
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	79 07                	jns    80105dd9 <sys_write+0x52>
    return -1;
80105dd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd7:	eb 17                	jmp    80105df0 <sys_write+0x69>
  return filewrite(f, p, n);
80105dd9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105ddc:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de2:	83 ec 04             	sub    $0x4,%esp
80105de5:	51                   	push   %ecx
80105de6:	52                   	push   %edx
80105de7:	50                   	push   %eax
80105de8:	e8 82 b4 ff ff       	call   8010126f <filewrite>
80105ded:	83 c4 10             	add    $0x10,%esp
}
80105df0:	c9                   	leave  
80105df1:	c3                   	ret    

80105df2 <sys_close>:

int
sys_close(void)
{
80105df2:	55                   	push   %ebp
80105df3:	89 e5                	mov    %esp,%ebp
80105df5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105df8:	83 ec 04             	sub    $0x4,%esp
80105dfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dfe:	50                   	push   %eax
80105dff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e02:	50                   	push   %eax
80105e03:	6a 00                	push   $0x0
80105e05:	e8 fa fd ff ff       	call   80105c04 <argfd>
80105e0a:	83 c4 10             	add    $0x10,%esp
80105e0d:	85 c0                	test   %eax,%eax
80105e0f:	79 07                	jns    80105e18 <sys_close+0x26>
    return -1;
80105e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e16:	eb 28                	jmp    80105e40 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105e18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e21:	83 c2 08             	add    $0x8,%edx
80105e24:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105e2b:	00 
  fileclose(f);
80105e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e2f:	83 ec 0c             	sub    $0xc,%esp
80105e32:	50                   	push   %eax
80105e33:	e8 40 b2 ff ff       	call   80101078 <fileclose>
80105e38:	83 c4 10             	add    $0x10,%esp
  return 0;
80105e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e40:	c9                   	leave  
80105e41:	c3                   	ret    

80105e42 <sys_fstat>:

int
sys_fstat(void)
{
80105e42:	55                   	push   %ebp
80105e43:	89 e5                	mov    %esp,%ebp
80105e45:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105e48:	83 ec 04             	sub    $0x4,%esp
80105e4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e4e:	50                   	push   %eax
80105e4f:	6a 00                	push   $0x0
80105e51:	6a 00                	push   $0x0
80105e53:	e8 ac fd ff ff       	call   80105c04 <argfd>
80105e58:	83 c4 10             	add    $0x10,%esp
80105e5b:	85 c0                	test   %eax,%eax
80105e5d:	78 17                	js     80105e76 <sys_fstat+0x34>
80105e5f:	83 ec 04             	sub    $0x4,%esp
80105e62:	6a 14                	push   $0x14
80105e64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e67:	50                   	push   %eax
80105e68:	6a 01                	push   $0x1
80105e6a:	e8 81 fc ff ff       	call   80105af0 <argptr>
80105e6f:	83 c4 10             	add    $0x10,%esp
80105e72:	85 c0                	test   %eax,%eax
80105e74:	79 07                	jns    80105e7d <sys_fstat+0x3b>
    return -1;
80105e76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e7b:	eb 13                	jmp    80105e90 <sys_fstat+0x4e>
  return filestat(f, st);
80105e7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e83:	83 ec 08             	sub    $0x8,%esp
80105e86:	52                   	push   %edx
80105e87:	50                   	push   %eax
80105e88:	e8 d3 b2 ff ff       	call   80101160 <filestat>
80105e8d:	83 c4 10             	add    $0x10,%esp
}
80105e90:	c9                   	leave  
80105e91:	c3                   	ret    

80105e92 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105e92:	55                   	push   %ebp
80105e93:	89 e5                	mov    %esp,%ebp
80105e95:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105e98:	83 ec 08             	sub    $0x8,%esp
80105e9b:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105e9e:	50                   	push   %eax
80105e9f:	6a 00                	push   $0x0
80105ea1:	e8 a7 fc ff ff       	call   80105b4d <argstr>
80105ea6:	83 c4 10             	add    $0x10,%esp
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	78 15                	js     80105ec2 <sys_link+0x30>
80105ead:	83 ec 08             	sub    $0x8,%esp
80105eb0:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105eb3:	50                   	push   %eax
80105eb4:	6a 01                	push   $0x1
80105eb6:	e8 92 fc ff ff       	call   80105b4d <argstr>
80105ebb:	83 c4 10             	add    $0x10,%esp
80105ebe:	85 c0                	test   %eax,%eax
80105ec0:	79 0a                	jns    80105ecc <sys_link+0x3a>
    return -1;
80105ec2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec7:	e9 68 01 00 00       	jmp    80106034 <sys_link+0x1a2>

  begin_op();
80105ecc:	e8 a3 d6 ff ff       	call   80103574 <begin_op>
  if((ip = namei(old)) == 0){
80105ed1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105ed4:	83 ec 0c             	sub    $0xc,%esp
80105ed7:	50                   	push   %eax
80105ed8:	e8 72 c6 ff ff       	call   8010254f <namei>
80105edd:	83 c4 10             	add    $0x10,%esp
80105ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ee7:	75 0f                	jne    80105ef8 <sys_link+0x66>
    end_op();
80105ee9:	e8 12 d7 ff ff       	call   80103600 <end_op>
    return -1;
80105eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef3:	e9 3c 01 00 00       	jmp    80106034 <sys_link+0x1a2>
  }

  ilock(ip);
80105ef8:	83 ec 0c             	sub    $0xc,%esp
80105efb:	ff 75 f4             	pushl  -0xc(%ebp)
80105efe:	e8 8e ba ff ff       	call   80101991 <ilock>
80105f03:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f09:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f0d:	66 83 f8 01          	cmp    $0x1,%ax
80105f11:	75 1d                	jne    80105f30 <sys_link+0x9e>
    iunlockput(ip);
80105f13:	83 ec 0c             	sub    $0xc,%esp
80105f16:	ff 75 f4             	pushl  -0xc(%ebp)
80105f19:	e8 33 bd ff ff       	call   80101c51 <iunlockput>
80105f1e:	83 c4 10             	add    $0x10,%esp
    end_op();
80105f21:	e8 da d6 ff ff       	call   80103600 <end_op>
    return -1;
80105f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f2b:	e9 04 01 00 00       	jmp    80106034 <sys_link+0x1a2>
  }

  ip->nlink++;
80105f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f33:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f37:	83 c0 01             	add    $0x1,%eax
80105f3a:	89 c2                	mov    %eax,%edx
80105f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105f43:	83 ec 0c             	sub    $0xc,%esp
80105f46:	ff 75 f4             	pushl  -0xc(%ebp)
80105f49:	e8 69 b8 ff ff       	call   801017b7 <iupdate>
80105f4e:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105f51:	83 ec 0c             	sub    $0xc,%esp
80105f54:	ff 75 f4             	pushl  -0xc(%ebp)
80105f57:	e8 93 bb ff ff       	call   80101aef <iunlock>
80105f5c:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105f5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f62:	83 ec 08             	sub    $0x8,%esp
80105f65:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105f68:	52                   	push   %edx
80105f69:	50                   	push   %eax
80105f6a:	e8 fc c5 ff ff       	call   8010256b <nameiparent>
80105f6f:	83 c4 10             	add    $0x10,%esp
80105f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f79:	74 71                	je     80105fec <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105f7b:	83 ec 0c             	sub    $0xc,%esp
80105f7e:	ff 75 f0             	pushl  -0x10(%ebp)
80105f81:	e8 0b ba ff ff       	call   80101991 <ilock>
80105f86:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f8c:	8b 10                	mov    (%eax),%edx
80105f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f91:	8b 00                	mov    (%eax),%eax
80105f93:	39 c2                	cmp    %eax,%edx
80105f95:	75 1d                	jne    80105fb4 <sys_link+0x122>
80105f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f9a:	8b 40 04             	mov    0x4(%eax),%eax
80105f9d:	83 ec 04             	sub    $0x4,%esp
80105fa0:	50                   	push   %eax
80105fa1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105fa4:	50                   	push   %eax
80105fa5:	ff 75 f0             	pushl  -0x10(%ebp)
80105fa8:	e8 06 c3 ff ff       	call   801022b3 <dirlink>
80105fad:	83 c4 10             	add    $0x10,%esp
80105fb0:	85 c0                	test   %eax,%eax
80105fb2:	79 10                	jns    80105fc4 <sys_link+0x132>
    iunlockput(dp);
80105fb4:	83 ec 0c             	sub    $0xc,%esp
80105fb7:	ff 75 f0             	pushl  -0x10(%ebp)
80105fba:	e8 92 bc ff ff       	call   80101c51 <iunlockput>
80105fbf:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105fc2:	eb 29                	jmp    80105fed <sys_link+0x15b>
  }
  iunlockput(dp);
80105fc4:	83 ec 0c             	sub    $0xc,%esp
80105fc7:	ff 75 f0             	pushl  -0x10(%ebp)
80105fca:	e8 82 bc ff ff       	call   80101c51 <iunlockput>
80105fcf:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105fd2:	83 ec 0c             	sub    $0xc,%esp
80105fd5:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd8:	e8 84 bb ff ff       	call   80101b61 <iput>
80105fdd:	83 c4 10             	add    $0x10,%esp

  end_op();
80105fe0:	e8 1b d6 ff ff       	call   80103600 <end_op>

  return 0;
80105fe5:	b8 00 00 00 00       	mov    $0x0,%eax
80105fea:	eb 48                	jmp    80106034 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105fec:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105fed:	83 ec 0c             	sub    $0xc,%esp
80105ff0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ff3:	e8 99 b9 ff ff       	call   80101991 <ilock>
80105ff8:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ffe:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106002:	83 e8 01             	sub    $0x1,%eax
80106005:	89 c2                	mov    %eax,%edx
80106007:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010600a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010600e:	83 ec 0c             	sub    $0xc,%esp
80106011:	ff 75 f4             	pushl  -0xc(%ebp)
80106014:	e8 9e b7 ff ff       	call   801017b7 <iupdate>
80106019:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010601c:	83 ec 0c             	sub    $0xc,%esp
8010601f:	ff 75 f4             	pushl  -0xc(%ebp)
80106022:	e8 2a bc ff ff       	call   80101c51 <iunlockput>
80106027:	83 c4 10             	add    $0x10,%esp
  end_op();
8010602a:	e8 d1 d5 ff ff       	call   80103600 <end_op>
  return -1;
8010602f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106034:	c9                   	leave  
80106035:	c3                   	ret    

80106036 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106036:	55                   	push   %ebp
80106037:	89 e5                	mov    %esp,%ebp
80106039:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010603c:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106043:	eb 40                	jmp    80106085 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106048:	6a 10                	push   $0x10
8010604a:	50                   	push   %eax
8010604b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010604e:	50                   	push   %eax
8010604f:	ff 75 08             	pushl  0x8(%ebp)
80106052:	e8 a8 be ff ff       	call   80101eff <readi>
80106057:	83 c4 10             	add    $0x10,%esp
8010605a:	83 f8 10             	cmp    $0x10,%eax
8010605d:	74 0d                	je     8010606c <isdirempty+0x36>
      panic("isdirempty: readi");
8010605f:	83 ec 0c             	sub    $0xc,%esp
80106062:	68 a2 90 10 80       	push   $0x801090a2
80106067:	e8 fa a4 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
8010606c:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106070:	66 85 c0             	test   %ax,%ax
80106073:	74 07                	je     8010607c <isdirempty+0x46>
      return 0;
80106075:	b8 00 00 00 00       	mov    $0x0,%eax
8010607a:	eb 1b                	jmp    80106097 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010607c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607f:	83 c0 10             	add    $0x10,%eax
80106082:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106085:	8b 45 08             	mov    0x8(%ebp),%eax
80106088:	8b 50 18             	mov    0x18(%eax),%edx
8010608b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010608e:	39 c2                	cmp    %eax,%edx
80106090:	77 b3                	ja     80106045 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106092:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106097:	c9                   	leave  
80106098:	c3                   	ret    

80106099 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106099:	55                   	push   %ebp
8010609a:	89 e5                	mov    %esp,%ebp
8010609c:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010609f:	83 ec 08             	sub    $0x8,%esp
801060a2:	8d 45 cc             	lea    -0x34(%ebp),%eax
801060a5:	50                   	push   %eax
801060a6:	6a 00                	push   $0x0
801060a8:	e8 a0 fa ff ff       	call   80105b4d <argstr>
801060ad:	83 c4 10             	add    $0x10,%esp
801060b0:	85 c0                	test   %eax,%eax
801060b2:	79 0a                	jns    801060be <sys_unlink+0x25>
    return -1;
801060b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b9:	e9 bc 01 00 00       	jmp    8010627a <sys_unlink+0x1e1>

  begin_op();
801060be:	e8 b1 d4 ff ff       	call   80103574 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801060c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801060c6:	83 ec 08             	sub    $0x8,%esp
801060c9:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801060cc:	52                   	push   %edx
801060cd:	50                   	push   %eax
801060ce:	e8 98 c4 ff ff       	call   8010256b <nameiparent>
801060d3:	83 c4 10             	add    $0x10,%esp
801060d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060dd:	75 0f                	jne    801060ee <sys_unlink+0x55>
    end_op();
801060df:	e8 1c d5 ff ff       	call   80103600 <end_op>
    return -1;
801060e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e9:	e9 8c 01 00 00       	jmp    8010627a <sys_unlink+0x1e1>
  }

  ilock(dp);
801060ee:	83 ec 0c             	sub    $0xc,%esp
801060f1:	ff 75 f4             	pushl  -0xc(%ebp)
801060f4:	e8 98 b8 ff ff       	call   80101991 <ilock>
801060f9:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801060fc:	83 ec 08             	sub    $0x8,%esp
801060ff:	68 b4 90 10 80       	push   $0x801090b4
80106104:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106107:	50                   	push   %eax
80106108:	e8 d1 c0 ff ff       	call   801021de <namecmp>
8010610d:	83 c4 10             	add    $0x10,%esp
80106110:	85 c0                	test   %eax,%eax
80106112:	0f 84 4a 01 00 00    	je     80106262 <sys_unlink+0x1c9>
80106118:	83 ec 08             	sub    $0x8,%esp
8010611b:	68 b6 90 10 80       	push   $0x801090b6
80106120:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106123:	50                   	push   %eax
80106124:	e8 b5 c0 ff ff       	call   801021de <namecmp>
80106129:	83 c4 10             	add    $0x10,%esp
8010612c:	85 c0                	test   %eax,%eax
8010612e:	0f 84 2e 01 00 00    	je     80106262 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106134:	83 ec 04             	sub    $0x4,%esp
80106137:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010613a:	50                   	push   %eax
8010613b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010613e:	50                   	push   %eax
8010613f:	ff 75 f4             	pushl  -0xc(%ebp)
80106142:	e8 b2 c0 ff ff       	call   801021f9 <dirlookup>
80106147:	83 c4 10             	add    $0x10,%esp
8010614a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010614d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106151:	0f 84 0a 01 00 00    	je     80106261 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106157:	83 ec 0c             	sub    $0xc,%esp
8010615a:	ff 75 f0             	pushl  -0x10(%ebp)
8010615d:	e8 2f b8 ff ff       	call   80101991 <ilock>
80106162:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106165:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106168:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010616c:	66 85 c0             	test   %ax,%ax
8010616f:	7f 0d                	jg     8010617e <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106171:	83 ec 0c             	sub    $0xc,%esp
80106174:	68 b9 90 10 80       	push   $0x801090b9
80106179:	e8 e8 a3 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010617e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106181:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106185:	66 83 f8 01          	cmp    $0x1,%ax
80106189:	75 25                	jne    801061b0 <sys_unlink+0x117>
8010618b:	83 ec 0c             	sub    $0xc,%esp
8010618e:	ff 75 f0             	pushl  -0x10(%ebp)
80106191:	e8 a0 fe ff ff       	call   80106036 <isdirempty>
80106196:	83 c4 10             	add    $0x10,%esp
80106199:	85 c0                	test   %eax,%eax
8010619b:	75 13                	jne    801061b0 <sys_unlink+0x117>
    iunlockput(ip);
8010619d:	83 ec 0c             	sub    $0xc,%esp
801061a0:	ff 75 f0             	pushl  -0x10(%ebp)
801061a3:	e8 a9 ba ff ff       	call   80101c51 <iunlockput>
801061a8:	83 c4 10             	add    $0x10,%esp
    goto bad;
801061ab:	e9 b2 00 00 00       	jmp    80106262 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801061b0:	83 ec 04             	sub    $0x4,%esp
801061b3:	6a 10                	push   $0x10
801061b5:	6a 00                	push   $0x0
801061b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061ba:	50                   	push   %eax
801061bb:	e8 e3 f5 ff ff       	call   801057a3 <memset>
801061c0:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801061c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
801061c6:	6a 10                	push   $0x10
801061c8:	50                   	push   %eax
801061c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061cc:	50                   	push   %eax
801061cd:	ff 75 f4             	pushl  -0xc(%ebp)
801061d0:	e8 81 be ff ff       	call   80102056 <writei>
801061d5:	83 c4 10             	add    $0x10,%esp
801061d8:	83 f8 10             	cmp    $0x10,%eax
801061db:	74 0d                	je     801061ea <sys_unlink+0x151>
    panic("unlink: writei");
801061dd:	83 ec 0c             	sub    $0xc,%esp
801061e0:	68 cb 90 10 80       	push   $0x801090cb
801061e5:	e8 7c a3 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801061ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ed:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061f1:	66 83 f8 01          	cmp    $0x1,%ax
801061f5:	75 21                	jne    80106218 <sys_unlink+0x17f>
    dp->nlink--;
801061f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061fa:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801061fe:	83 e8 01             	sub    $0x1,%eax
80106201:	89 c2                	mov    %eax,%edx
80106203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106206:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010620a:	83 ec 0c             	sub    $0xc,%esp
8010620d:	ff 75 f4             	pushl  -0xc(%ebp)
80106210:	e8 a2 b5 ff ff       	call   801017b7 <iupdate>
80106215:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106218:	83 ec 0c             	sub    $0xc,%esp
8010621b:	ff 75 f4             	pushl  -0xc(%ebp)
8010621e:	e8 2e ba ff ff       	call   80101c51 <iunlockput>
80106223:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106226:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106229:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010622d:	83 e8 01             	sub    $0x1,%eax
80106230:	89 c2                	mov    %eax,%edx
80106232:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106235:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106239:	83 ec 0c             	sub    $0xc,%esp
8010623c:	ff 75 f0             	pushl  -0x10(%ebp)
8010623f:	e8 73 b5 ff ff       	call   801017b7 <iupdate>
80106244:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106247:	83 ec 0c             	sub    $0xc,%esp
8010624a:	ff 75 f0             	pushl  -0x10(%ebp)
8010624d:	e8 ff b9 ff ff       	call   80101c51 <iunlockput>
80106252:	83 c4 10             	add    $0x10,%esp

  end_op();
80106255:	e8 a6 d3 ff ff       	call   80103600 <end_op>

  return 0;
8010625a:	b8 00 00 00 00       	mov    $0x0,%eax
8010625f:	eb 19                	jmp    8010627a <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106261:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106262:	83 ec 0c             	sub    $0xc,%esp
80106265:	ff 75 f4             	pushl  -0xc(%ebp)
80106268:	e8 e4 b9 ff ff       	call   80101c51 <iunlockput>
8010626d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106270:	e8 8b d3 ff ff       	call   80103600 <end_op>
  return -1;
80106275:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010627a:	c9                   	leave  
8010627b:	c3                   	ret    

8010627c <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010627c:	55                   	push   %ebp
8010627d:	89 e5                	mov    %esp,%ebp
8010627f:	83 ec 38             	sub    $0x38,%esp
80106282:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106285:	8b 55 10             	mov    0x10(%ebp),%edx
80106288:	8b 45 14             	mov    0x14(%ebp),%eax
8010628b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010628f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106293:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106297:	83 ec 08             	sub    $0x8,%esp
8010629a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010629d:	50                   	push   %eax
8010629e:	ff 75 08             	pushl  0x8(%ebp)
801062a1:	e8 c5 c2 ff ff       	call   8010256b <nameiparent>
801062a6:	83 c4 10             	add    $0x10,%esp
801062a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062b0:	75 0a                	jne    801062bc <create+0x40>
    return 0;
801062b2:	b8 00 00 00 00       	mov    $0x0,%eax
801062b7:	e9 90 01 00 00       	jmp    8010644c <create+0x1d0>
  ilock(dp);
801062bc:	83 ec 0c             	sub    $0xc,%esp
801062bf:	ff 75 f4             	pushl  -0xc(%ebp)
801062c2:	e8 ca b6 ff ff       	call   80101991 <ilock>
801062c7:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801062ca:	83 ec 04             	sub    $0x4,%esp
801062cd:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062d0:	50                   	push   %eax
801062d1:	8d 45 de             	lea    -0x22(%ebp),%eax
801062d4:	50                   	push   %eax
801062d5:	ff 75 f4             	pushl  -0xc(%ebp)
801062d8:	e8 1c bf ff ff       	call   801021f9 <dirlookup>
801062dd:	83 c4 10             	add    $0x10,%esp
801062e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062e7:	74 50                	je     80106339 <create+0xbd>
    iunlockput(dp);
801062e9:	83 ec 0c             	sub    $0xc,%esp
801062ec:	ff 75 f4             	pushl  -0xc(%ebp)
801062ef:	e8 5d b9 ff ff       	call   80101c51 <iunlockput>
801062f4:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801062f7:	83 ec 0c             	sub    $0xc,%esp
801062fa:	ff 75 f0             	pushl  -0x10(%ebp)
801062fd:	e8 8f b6 ff ff       	call   80101991 <ilock>
80106302:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106305:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010630a:	75 15                	jne    80106321 <create+0xa5>
8010630c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010630f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106313:	66 83 f8 02          	cmp    $0x2,%ax
80106317:	75 08                	jne    80106321 <create+0xa5>
      return ip;
80106319:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010631c:	e9 2b 01 00 00       	jmp    8010644c <create+0x1d0>
    iunlockput(ip);
80106321:	83 ec 0c             	sub    $0xc,%esp
80106324:	ff 75 f0             	pushl  -0x10(%ebp)
80106327:	e8 25 b9 ff ff       	call   80101c51 <iunlockput>
8010632c:	83 c4 10             	add    $0x10,%esp
    return 0;
8010632f:	b8 00 00 00 00       	mov    $0x0,%eax
80106334:	e9 13 01 00 00       	jmp    8010644c <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106339:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010633d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106340:	8b 00                	mov    (%eax),%eax
80106342:	83 ec 08             	sub    $0x8,%esp
80106345:	52                   	push   %edx
80106346:	50                   	push   %eax
80106347:	e8 94 b3 ff ff       	call   801016e0 <ialloc>
8010634c:	83 c4 10             	add    $0x10,%esp
8010634f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106352:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106356:	75 0d                	jne    80106365 <create+0xe9>
    panic("create: ialloc");
80106358:	83 ec 0c             	sub    $0xc,%esp
8010635b:	68 da 90 10 80       	push   $0x801090da
80106360:	e8 01 a2 ff ff       	call   80100566 <panic>

  ilock(ip);
80106365:	83 ec 0c             	sub    $0xc,%esp
80106368:	ff 75 f0             	pushl  -0x10(%ebp)
8010636b:	e8 21 b6 ff ff       	call   80101991 <ilock>
80106370:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106376:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010637a:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010637e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106381:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106385:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106389:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010638c:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106392:	83 ec 0c             	sub    $0xc,%esp
80106395:	ff 75 f0             	pushl  -0x10(%ebp)
80106398:	e8 1a b4 ff ff       	call   801017b7 <iupdate>
8010639d:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801063a0:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801063a5:	75 6a                	jne    80106411 <create+0x195>
    dp->nlink++;  // for ".."
801063a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063aa:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801063ae:	83 c0 01             	add    $0x1,%eax
801063b1:	89 c2                	mov    %eax,%edx
801063b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b6:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801063ba:	83 ec 0c             	sub    $0xc,%esp
801063bd:	ff 75 f4             	pushl  -0xc(%ebp)
801063c0:	e8 f2 b3 ff ff       	call   801017b7 <iupdate>
801063c5:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801063c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063cb:	8b 40 04             	mov    0x4(%eax),%eax
801063ce:	83 ec 04             	sub    $0x4,%esp
801063d1:	50                   	push   %eax
801063d2:	68 b4 90 10 80       	push   $0x801090b4
801063d7:	ff 75 f0             	pushl  -0x10(%ebp)
801063da:	e8 d4 be ff ff       	call   801022b3 <dirlink>
801063df:	83 c4 10             	add    $0x10,%esp
801063e2:	85 c0                	test   %eax,%eax
801063e4:	78 1e                	js     80106404 <create+0x188>
801063e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063e9:	8b 40 04             	mov    0x4(%eax),%eax
801063ec:	83 ec 04             	sub    $0x4,%esp
801063ef:	50                   	push   %eax
801063f0:	68 b6 90 10 80       	push   $0x801090b6
801063f5:	ff 75 f0             	pushl  -0x10(%ebp)
801063f8:	e8 b6 be ff ff       	call   801022b3 <dirlink>
801063fd:	83 c4 10             	add    $0x10,%esp
80106400:	85 c0                	test   %eax,%eax
80106402:	79 0d                	jns    80106411 <create+0x195>
      panic("create dots");
80106404:	83 ec 0c             	sub    $0xc,%esp
80106407:	68 e9 90 10 80       	push   $0x801090e9
8010640c:	e8 55 a1 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106411:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106414:	8b 40 04             	mov    0x4(%eax),%eax
80106417:	83 ec 04             	sub    $0x4,%esp
8010641a:	50                   	push   %eax
8010641b:	8d 45 de             	lea    -0x22(%ebp),%eax
8010641e:	50                   	push   %eax
8010641f:	ff 75 f4             	pushl  -0xc(%ebp)
80106422:	e8 8c be ff ff       	call   801022b3 <dirlink>
80106427:	83 c4 10             	add    $0x10,%esp
8010642a:	85 c0                	test   %eax,%eax
8010642c:	79 0d                	jns    8010643b <create+0x1bf>
    panic("create: dirlink");
8010642e:	83 ec 0c             	sub    $0xc,%esp
80106431:	68 f5 90 10 80       	push   $0x801090f5
80106436:	e8 2b a1 ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010643b:	83 ec 0c             	sub    $0xc,%esp
8010643e:	ff 75 f4             	pushl  -0xc(%ebp)
80106441:	e8 0b b8 ff ff       	call   80101c51 <iunlockput>
80106446:	83 c4 10             	add    $0x10,%esp

  return ip;
80106449:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010644c:	c9                   	leave  
8010644d:	c3                   	ret    

8010644e <sys_open>:

int
sys_open(void)
{
8010644e:	55                   	push   %ebp
8010644f:	89 e5                	mov    %esp,%ebp
80106451:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106454:	83 ec 08             	sub    $0x8,%esp
80106457:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010645a:	50                   	push   %eax
8010645b:	6a 00                	push   $0x0
8010645d:	e8 eb f6 ff ff       	call   80105b4d <argstr>
80106462:	83 c4 10             	add    $0x10,%esp
80106465:	85 c0                	test   %eax,%eax
80106467:	78 15                	js     8010647e <sys_open+0x30>
80106469:	83 ec 08             	sub    $0x8,%esp
8010646c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010646f:	50                   	push   %eax
80106470:	6a 01                	push   $0x1
80106472:	e8 51 f6 ff ff       	call   80105ac8 <argint>
80106477:	83 c4 10             	add    $0x10,%esp
8010647a:	85 c0                	test   %eax,%eax
8010647c:	79 0a                	jns    80106488 <sys_open+0x3a>
    return -1;
8010647e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106483:	e9 61 01 00 00       	jmp    801065e9 <sys_open+0x19b>

  begin_op();
80106488:	e8 e7 d0 ff ff       	call   80103574 <begin_op>

  if(omode & O_CREATE){
8010648d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106490:	25 00 02 00 00       	and    $0x200,%eax
80106495:	85 c0                	test   %eax,%eax
80106497:	74 2a                	je     801064c3 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106499:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010649c:	6a 00                	push   $0x0
8010649e:	6a 00                	push   $0x0
801064a0:	6a 02                	push   $0x2
801064a2:	50                   	push   %eax
801064a3:	e8 d4 fd ff ff       	call   8010627c <create>
801064a8:	83 c4 10             	add    $0x10,%esp
801064ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801064ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064b2:	75 75                	jne    80106529 <sys_open+0xdb>
      end_op();
801064b4:	e8 47 d1 ff ff       	call   80103600 <end_op>
      return -1;
801064b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064be:	e9 26 01 00 00       	jmp    801065e9 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801064c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064c6:	83 ec 0c             	sub    $0xc,%esp
801064c9:	50                   	push   %eax
801064ca:	e8 80 c0 ff ff       	call   8010254f <namei>
801064cf:	83 c4 10             	add    $0x10,%esp
801064d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064d9:	75 0f                	jne    801064ea <sys_open+0x9c>
      end_op();
801064db:	e8 20 d1 ff ff       	call   80103600 <end_op>
      return -1;
801064e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e5:	e9 ff 00 00 00       	jmp    801065e9 <sys_open+0x19b>
    }
    ilock(ip);
801064ea:	83 ec 0c             	sub    $0xc,%esp
801064ed:	ff 75 f4             	pushl  -0xc(%ebp)
801064f0:	e8 9c b4 ff ff       	call   80101991 <ilock>
801064f5:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801064f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064fb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801064ff:	66 83 f8 01          	cmp    $0x1,%ax
80106503:	75 24                	jne    80106529 <sys_open+0xdb>
80106505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106508:	85 c0                	test   %eax,%eax
8010650a:	74 1d                	je     80106529 <sys_open+0xdb>
      iunlockput(ip);
8010650c:	83 ec 0c             	sub    $0xc,%esp
8010650f:	ff 75 f4             	pushl  -0xc(%ebp)
80106512:	e8 3a b7 ff ff       	call   80101c51 <iunlockput>
80106517:	83 c4 10             	add    $0x10,%esp
      end_op();
8010651a:	e8 e1 d0 ff ff       	call   80103600 <end_op>
      return -1;
8010651f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106524:	e9 c0 00 00 00       	jmp    801065e9 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106529:	e8 8c aa ff ff       	call   80100fba <filealloc>
8010652e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106531:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106535:	74 17                	je     8010654e <sys_open+0x100>
80106537:	83 ec 0c             	sub    $0xc,%esp
8010653a:	ff 75 f0             	pushl  -0x10(%ebp)
8010653d:	e8 37 f7 ff ff       	call   80105c79 <fdalloc>
80106542:	83 c4 10             	add    $0x10,%esp
80106545:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106548:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010654c:	79 2e                	jns    8010657c <sys_open+0x12e>
    if(f)
8010654e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106552:	74 0e                	je     80106562 <sys_open+0x114>
      fileclose(f);
80106554:	83 ec 0c             	sub    $0xc,%esp
80106557:	ff 75 f0             	pushl  -0x10(%ebp)
8010655a:	e8 19 ab ff ff       	call   80101078 <fileclose>
8010655f:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106562:	83 ec 0c             	sub    $0xc,%esp
80106565:	ff 75 f4             	pushl  -0xc(%ebp)
80106568:	e8 e4 b6 ff ff       	call   80101c51 <iunlockput>
8010656d:	83 c4 10             	add    $0x10,%esp
    end_op();
80106570:	e8 8b d0 ff ff       	call   80103600 <end_op>
    return -1;
80106575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010657a:	eb 6d                	jmp    801065e9 <sys_open+0x19b>
  }
  iunlock(ip);
8010657c:	83 ec 0c             	sub    $0xc,%esp
8010657f:	ff 75 f4             	pushl  -0xc(%ebp)
80106582:	e8 68 b5 ff ff       	call   80101aef <iunlock>
80106587:	83 c4 10             	add    $0x10,%esp
  end_op();
8010658a:	e8 71 d0 ff ff       	call   80103600 <end_op>

  f->type = FD_INODE;
8010658f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106592:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010659b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010659e:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801065a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065a4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801065ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065ae:	83 e0 01             	and    $0x1,%eax
801065b1:	85 c0                	test   %eax,%eax
801065b3:	0f 94 c0             	sete   %al
801065b6:	89 c2                	mov    %eax,%edx
801065b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065bb:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065c1:	83 e0 01             	and    $0x1,%eax
801065c4:	85 c0                	test   %eax,%eax
801065c6:	75 0a                	jne    801065d2 <sys_open+0x184>
801065c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065cb:	83 e0 02             	and    $0x2,%eax
801065ce:	85 c0                	test   %eax,%eax
801065d0:	74 07                	je     801065d9 <sys_open+0x18b>
801065d2:	b8 01 00 00 00       	mov    $0x1,%eax
801065d7:	eb 05                	jmp    801065de <sys_open+0x190>
801065d9:	b8 00 00 00 00       	mov    $0x0,%eax
801065de:	89 c2                	mov    %eax,%edx
801065e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065e3:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801065e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801065e9:	c9                   	leave  
801065ea:	c3                   	ret    

801065eb <sys_mkdir>:

int
sys_mkdir(void)
{
801065eb:	55                   	push   %ebp
801065ec:	89 e5                	mov    %esp,%ebp
801065ee:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065f1:	e8 7e cf ff ff       	call   80103574 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801065f6:	83 ec 08             	sub    $0x8,%esp
801065f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065fc:	50                   	push   %eax
801065fd:	6a 00                	push   $0x0
801065ff:	e8 49 f5 ff ff       	call   80105b4d <argstr>
80106604:	83 c4 10             	add    $0x10,%esp
80106607:	85 c0                	test   %eax,%eax
80106609:	78 1b                	js     80106626 <sys_mkdir+0x3b>
8010660b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010660e:	6a 00                	push   $0x0
80106610:	6a 00                	push   $0x0
80106612:	6a 01                	push   $0x1
80106614:	50                   	push   %eax
80106615:	e8 62 fc ff ff       	call   8010627c <create>
8010661a:	83 c4 10             	add    $0x10,%esp
8010661d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106624:	75 0c                	jne    80106632 <sys_mkdir+0x47>
    end_op();
80106626:	e8 d5 cf ff ff       	call   80103600 <end_op>
    return -1;
8010662b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106630:	eb 18                	jmp    8010664a <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106632:	83 ec 0c             	sub    $0xc,%esp
80106635:	ff 75 f4             	pushl  -0xc(%ebp)
80106638:	e8 14 b6 ff ff       	call   80101c51 <iunlockput>
8010663d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106640:	e8 bb cf ff ff       	call   80103600 <end_op>
  return 0;
80106645:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010664a:	c9                   	leave  
8010664b:	c3                   	ret    

8010664c <sys_mknod>:

int
sys_mknod(void)
{
8010664c:	55                   	push   %ebp
8010664d:	89 e5                	mov    %esp,%ebp
8010664f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106652:	e8 1d cf ff ff       	call   80103574 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106657:	83 ec 08             	sub    $0x8,%esp
8010665a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010665d:	50                   	push   %eax
8010665e:	6a 00                	push   $0x0
80106660:	e8 e8 f4 ff ff       	call   80105b4d <argstr>
80106665:	83 c4 10             	add    $0x10,%esp
80106668:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010666b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010666f:	78 4f                	js     801066c0 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106671:	83 ec 08             	sub    $0x8,%esp
80106674:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106677:	50                   	push   %eax
80106678:	6a 01                	push   $0x1
8010667a:	e8 49 f4 ff ff       	call   80105ac8 <argint>
8010667f:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106682:	85 c0                	test   %eax,%eax
80106684:	78 3a                	js     801066c0 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106686:	83 ec 08             	sub    $0x8,%esp
80106689:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010668c:	50                   	push   %eax
8010668d:	6a 02                	push   $0x2
8010668f:	e8 34 f4 ff ff       	call   80105ac8 <argint>
80106694:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106697:	85 c0                	test   %eax,%eax
80106699:	78 25                	js     801066c0 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010669b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010669e:	0f bf c8             	movswl %ax,%ecx
801066a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066a4:	0f bf d0             	movswl %ax,%edx
801066a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801066aa:	51                   	push   %ecx
801066ab:	52                   	push   %edx
801066ac:	6a 03                	push   $0x3
801066ae:	50                   	push   %eax
801066af:	e8 c8 fb ff ff       	call   8010627c <create>
801066b4:	83 c4 10             	add    $0x10,%esp
801066b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066be:	75 0c                	jne    801066cc <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801066c0:	e8 3b cf ff ff       	call   80103600 <end_op>
    return -1;
801066c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ca:	eb 18                	jmp    801066e4 <sys_mknod+0x98>
  }
  iunlockput(ip);
801066cc:	83 ec 0c             	sub    $0xc,%esp
801066cf:	ff 75 f0             	pushl  -0x10(%ebp)
801066d2:	e8 7a b5 ff ff       	call   80101c51 <iunlockput>
801066d7:	83 c4 10             	add    $0x10,%esp
  end_op();
801066da:	e8 21 cf ff ff       	call   80103600 <end_op>
  return 0;
801066df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066e4:	c9                   	leave  
801066e5:	c3                   	ret    

801066e6 <sys_chdir>:

int
sys_chdir(void)
{
801066e6:	55                   	push   %ebp
801066e7:	89 e5                	mov    %esp,%ebp
801066e9:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801066ec:	e8 83 ce ff ff       	call   80103574 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801066f1:	83 ec 08             	sub    $0x8,%esp
801066f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066f7:	50                   	push   %eax
801066f8:	6a 00                	push   $0x0
801066fa:	e8 4e f4 ff ff       	call   80105b4d <argstr>
801066ff:	83 c4 10             	add    $0x10,%esp
80106702:	85 c0                	test   %eax,%eax
80106704:	78 18                	js     8010671e <sys_chdir+0x38>
80106706:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106709:	83 ec 0c             	sub    $0xc,%esp
8010670c:	50                   	push   %eax
8010670d:	e8 3d be ff ff       	call   8010254f <namei>
80106712:	83 c4 10             	add    $0x10,%esp
80106715:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010671c:	75 0c                	jne    8010672a <sys_chdir+0x44>
    end_op();
8010671e:	e8 dd ce ff ff       	call   80103600 <end_op>
    return -1;
80106723:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106728:	eb 6e                	jmp    80106798 <sys_chdir+0xb2>
  }
  ilock(ip);
8010672a:	83 ec 0c             	sub    $0xc,%esp
8010672d:	ff 75 f4             	pushl  -0xc(%ebp)
80106730:	e8 5c b2 ff ff       	call   80101991 <ilock>
80106735:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010673f:	66 83 f8 01          	cmp    $0x1,%ax
80106743:	74 1a                	je     8010675f <sys_chdir+0x79>
    iunlockput(ip);
80106745:	83 ec 0c             	sub    $0xc,%esp
80106748:	ff 75 f4             	pushl  -0xc(%ebp)
8010674b:	e8 01 b5 ff ff       	call   80101c51 <iunlockput>
80106750:	83 c4 10             	add    $0x10,%esp
    end_op();
80106753:	e8 a8 ce ff ff       	call   80103600 <end_op>
    return -1;
80106758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010675d:	eb 39                	jmp    80106798 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010675f:	83 ec 0c             	sub    $0xc,%esp
80106762:	ff 75 f4             	pushl  -0xc(%ebp)
80106765:	e8 85 b3 ff ff       	call   80101aef <iunlock>
8010676a:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010676d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106773:	8b 40 68             	mov    0x68(%eax),%eax
80106776:	83 ec 0c             	sub    $0xc,%esp
80106779:	50                   	push   %eax
8010677a:	e8 e2 b3 ff ff       	call   80101b61 <iput>
8010677f:	83 c4 10             	add    $0x10,%esp
  end_op();
80106782:	e8 79 ce ff ff       	call   80103600 <end_op>
  proc->cwd = ip;
80106787:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010678d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106790:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106793:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106798:	c9                   	leave  
80106799:	c3                   	ret    

8010679a <sys_exec>:

int
sys_exec(void)
{
8010679a:	55                   	push   %ebp
8010679b:	89 e5                	mov    %esp,%ebp
8010679d:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801067a3:	83 ec 08             	sub    $0x8,%esp
801067a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067a9:	50                   	push   %eax
801067aa:	6a 00                	push   $0x0
801067ac:	e8 9c f3 ff ff       	call   80105b4d <argstr>
801067b1:	83 c4 10             	add    $0x10,%esp
801067b4:	85 c0                	test   %eax,%eax
801067b6:	78 18                	js     801067d0 <sys_exec+0x36>
801067b8:	83 ec 08             	sub    $0x8,%esp
801067bb:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801067c1:	50                   	push   %eax
801067c2:	6a 01                	push   $0x1
801067c4:	e8 ff f2 ff ff       	call   80105ac8 <argint>
801067c9:	83 c4 10             	add    $0x10,%esp
801067cc:	85 c0                	test   %eax,%eax
801067ce:	79 0a                	jns    801067da <sys_exec+0x40>
    return -1;
801067d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067d5:	e9 c6 00 00 00       	jmp    801068a0 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801067da:	83 ec 04             	sub    $0x4,%esp
801067dd:	68 80 00 00 00       	push   $0x80
801067e2:	6a 00                	push   $0x0
801067e4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801067ea:	50                   	push   %eax
801067eb:	e8 b3 ef ff ff       	call   801057a3 <memset>
801067f0:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801067f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801067fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067fd:	83 f8 1f             	cmp    $0x1f,%eax
80106800:	76 0a                	jbe    8010680c <sys_exec+0x72>
      return -1;
80106802:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106807:	e9 94 00 00 00       	jmp    801068a0 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010680c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010680f:	c1 e0 02             	shl    $0x2,%eax
80106812:	89 c2                	mov    %eax,%edx
80106814:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010681a:	01 c2                	add    %eax,%edx
8010681c:	83 ec 08             	sub    $0x8,%esp
8010681f:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106825:	50                   	push   %eax
80106826:	52                   	push   %edx
80106827:	e8 00 f2 ff ff       	call   80105a2c <fetchint>
8010682c:	83 c4 10             	add    $0x10,%esp
8010682f:	85 c0                	test   %eax,%eax
80106831:	79 07                	jns    8010683a <sys_exec+0xa0>
      return -1;
80106833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106838:	eb 66                	jmp    801068a0 <sys_exec+0x106>
    if(uarg == 0){
8010683a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106840:	85 c0                	test   %eax,%eax
80106842:	75 27                	jne    8010686b <sys_exec+0xd1>
      argv[i] = 0;
80106844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106847:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010684e:	00 00 00 00 
      break;
80106852:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106853:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106856:	83 ec 08             	sub    $0x8,%esp
80106859:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010685f:	52                   	push   %edx
80106860:	50                   	push   %eax
80106861:	e8 32 a3 ff ff       	call   80100b98 <exec>
80106866:	83 c4 10             	add    $0x10,%esp
80106869:	eb 35                	jmp    801068a0 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010686b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106871:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106874:	c1 e2 02             	shl    $0x2,%edx
80106877:	01 c2                	add    %eax,%edx
80106879:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010687f:	83 ec 08             	sub    $0x8,%esp
80106882:	52                   	push   %edx
80106883:	50                   	push   %eax
80106884:	e8 dd f1 ff ff       	call   80105a66 <fetchstr>
80106889:	83 c4 10             	add    $0x10,%esp
8010688c:	85 c0                	test   %eax,%eax
8010688e:	79 07                	jns    80106897 <sys_exec+0xfd>
      return -1;
80106890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106895:	eb 09                	jmp    801068a0 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106897:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010689b:	e9 5a ff ff ff       	jmp    801067fa <sys_exec+0x60>
  return exec(path, argv);
}
801068a0:	c9                   	leave  
801068a1:	c3                   	ret    

801068a2 <sys_pipe>:

int
sys_pipe(void)
{
801068a2:	55                   	push   %ebp
801068a3:	89 e5                	mov    %esp,%ebp
801068a5:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801068a8:	83 ec 04             	sub    $0x4,%esp
801068ab:	6a 08                	push   $0x8
801068ad:	8d 45 ec             	lea    -0x14(%ebp),%eax
801068b0:	50                   	push   %eax
801068b1:	6a 00                	push   $0x0
801068b3:	e8 38 f2 ff ff       	call   80105af0 <argptr>
801068b8:	83 c4 10             	add    $0x10,%esp
801068bb:	85 c0                	test   %eax,%eax
801068bd:	79 0a                	jns    801068c9 <sys_pipe+0x27>
    return -1;
801068bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c4:	e9 af 00 00 00       	jmp    80106978 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801068c9:	83 ec 08             	sub    $0x8,%esp
801068cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801068cf:	50                   	push   %eax
801068d0:	8d 45 e8             	lea    -0x18(%ebp),%eax
801068d3:	50                   	push   %eax
801068d4:	e8 8f d7 ff ff       	call   80104068 <pipealloc>
801068d9:	83 c4 10             	add    $0x10,%esp
801068dc:	85 c0                	test   %eax,%eax
801068de:	79 0a                	jns    801068ea <sys_pipe+0x48>
    return -1;
801068e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e5:	e9 8e 00 00 00       	jmp    80106978 <sys_pipe+0xd6>
  fd0 = -1;
801068ea:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801068f4:	83 ec 0c             	sub    $0xc,%esp
801068f7:	50                   	push   %eax
801068f8:	e8 7c f3 ff ff       	call   80105c79 <fdalloc>
801068fd:	83 c4 10             	add    $0x10,%esp
80106900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106907:	78 18                	js     80106921 <sys_pipe+0x7f>
80106909:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010690c:	83 ec 0c             	sub    $0xc,%esp
8010690f:	50                   	push   %eax
80106910:	e8 64 f3 ff ff       	call   80105c79 <fdalloc>
80106915:	83 c4 10             	add    $0x10,%esp
80106918:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010691b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010691f:	79 3f                	jns    80106960 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106921:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106925:	78 14                	js     8010693b <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106927:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010692d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106930:	83 c2 08             	add    $0x8,%edx
80106933:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010693a:	00 
    fileclose(rf);
8010693b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010693e:	83 ec 0c             	sub    $0xc,%esp
80106941:	50                   	push   %eax
80106942:	e8 31 a7 ff ff       	call   80101078 <fileclose>
80106947:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010694a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010694d:	83 ec 0c             	sub    $0xc,%esp
80106950:	50                   	push   %eax
80106951:	e8 22 a7 ff ff       	call   80101078 <fileclose>
80106956:	83 c4 10             	add    $0x10,%esp
    return -1;
80106959:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695e:	eb 18                	jmp    80106978 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106960:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106963:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106966:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106968:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010696b:	8d 50 04             	lea    0x4(%eax),%edx
8010696e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106971:	89 02                	mov    %eax,(%edx)
  return 0;
80106973:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106978:	c9                   	leave  
80106979:	c3                   	ret    

8010697a <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
8010697a:	55                   	push   %ebp
8010697b:	89 e5                	mov    %esp,%ebp
8010697d:	83 ec 08             	sub    $0x8,%esp
80106980:	8b 55 08             	mov    0x8(%ebp),%edx
80106983:	8b 45 0c             	mov    0xc(%ebp),%eax
80106986:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010698a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010698e:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106992:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106996:	66 ef                	out    %ax,(%dx)
}
80106998:	90                   	nop
80106999:	c9                   	leave  
8010699a:	c3                   	ret    

8010699b <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
8010699b:	55                   	push   %ebp
8010699c:	89 e5                	mov    %esp,%ebp
8010699e:	83 ec 08             	sub    $0x8,%esp
  return fork();
801069a1:	e8 71 de ff ff       	call   80104817 <fork>
}
801069a6:	c9                   	leave  
801069a7:	c3                   	ret    

801069a8 <sys_exit>:

int
sys_exit(void)
{
801069a8:	55                   	push   %ebp
801069a9:	89 e5                	mov    %esp,%ebp
801069ab:	83 ec 08             	sub    $0x8,%esp
  exit();
801069ae:	e8 1f e0 ff ff       	call   801049d2 <exit>
  return 0;  // not reached
801069b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069b8:	c9                   	leave  
801069b9:	c3                   	ret    

801069ba <sys_wait>:

int
sys_wait(void)
{
801069ba:	55                   	push   %ebp
801069bb:	89 e5                	mov    %esp,%ebp
801069bd:	83 ec 08             	sub    $0x8,%esp
  return wait();
801069c0:	e8 48 e1 ff ff       	call   80104b0d <wait>
}
801069c5:	c9                   	leave  
801069c6:	c3                   	ret    

801069c7 <sys_kill>:

int
sys_kill(void)
{
801069c7:	55                   	push   %ebp
801069c8:	89 e5                	mov    %esp,%ebp
801069ca:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801069cd:	83 ec 08             	sub    $0x8,%esp
801069d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069d3:	50                   	push   %eax
801069d4:	6a 00                	push   $0x0
801069d6:	e8 ed f0 ff ff       	call   80105ac8 <argint>
801069db:	83 c4 10             	add    $0x10,%esp
801069de:	85 c0                	test   %eax,%eax
801069e0:	79 07                	jns    801069e9 <sys_kill+0x22>
    return -1;
801069e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069e7:	eb 0f                	jmp    801069f8 <sys_kill+0x31>
  return kill(pid);
801069e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069ec:	83 ec 0c             	sub    $0xc,%esp
801069ef:	50                   	push   %eax
801069f0:	e8 ad e5 ff ff       	call   80104fa2 <kill>
801069f5:	83 c4 10             	add    $0x10,%esp
}
801069f8:	c9                   	leave  
801069f9:	c3                   	ret    

801069fa <sys_getpid>:

int
sys_getpid(void)
{
801069fa:	55                   	push   %ebp
801069fb:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801069fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a03:	8b 40 10             	mov    0x10(%eax),%eax
}
80106a06:	5d                   	pop    %ebp
80106a07:	c3                   	ret    

80106a08 <sys_sbrk>:

int
sys_sbrk(void)
{
80106a08:	55                   	push   %ebp
80106a09:	89 e5                	mov    %esp,%ebp
80106a0b:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106a0e:	83 ec 08             	sub    $0x8,%esp
80106a11:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a14:	50                   	push   %eax
80106a15:	6a 00                	push   $0x0
80106a17:	e8 ac f0 ff ff       	call   80105ac8 <argint>
80106a1c:	83 c4 10             	add    $0x10,%esp
80106a1f:	85 c0                	test   %eax,%eax
80106a21:	79 07                	jns    80106a2a <sys_sbrk+0x22>
    return -1;
80106a23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a28:	eb 28                	jmp    80106a52 <sys_sbrk+0x4a>
  addr = proc->sz;
80106a2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a30:	8b 00                	mov    (%eax),%eax
80106a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a38:	83 ec 0c             	sub    $0xc,%esp
80106a3b:	50                   	push   %eax
80106a3c:	e8 33 dd ff ff       	call   80104774 <growproc>
80106a41:	83 c4 10             	add    $0x10,%esp
80106a44:	85 c0                	test   %eax,%eax
80106a46:	79 07                	jns    80106a4f <sys_sbrk+0x47>
    return -1;
80106a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a4d:	eb 03                	jmp    80106a52 <sys_sbrk+0x4a>
  return addr;
80106a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a52:	c9                   	leave  
80106a53:	c3                   	ret    

80106a54 <sys_sleep>:

int
sys_sleep(void)
{
80106a54:	55                   	push   %ebp
80106a55:	89 e5                	mov    %esp,%ebp
80106a57:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106a5a:	83 ec 08             	sub    $0x8,%esp
80106a5d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a60:	50                   	push   %eax
80106a61:	6a 00                	push   $0x0
80106a63:	e8 60 f0 ff ff       	call   80105ac8 <argint>
80106a68:	83 c4 10             	add    $0x10,%esp
80106a6b:	85 c0                	test   %eax,%eax
80106a6d:	79 07                	jns    80106a76 <sys_sleep+0x22>
    return -1;
80106a6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a74:	eb 44                	jmp    80106aba <sys_sleep+0x66>
  ticks0 = ticks;
80106a76:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80106a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106a7e:	eb 26                	jmp    80106aa6 <sys_sleep+0x52>
    if(proc->killed){
80106a80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a86:	8b 40 24             	mov    0x24(%eax),%eax
80106a89:	85 c0                	test   %eax,%eax
80106a8b:	74 07                	je     80106a94 <sys_sleep+0x40>
      return -1;
80106a8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a92:	eb 26                	jmp    80106aba <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80106a94:	83 ec 08             	sub    $0x8,%esp
80106a97:	6a 00                	push   $0x0
80106a99:	68 e0 66 11 80       	push   $0x801166e0
80106a9e:	e8 e1 e3 ff ff       	call   80104e84 <sleep>
80106aa3:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106aa6:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80106aab:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106aae:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106ab1:	39 d0                	cmp    %edx,%eax
80106ab3:	72 cb                	jb     80106a80 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80106ab5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106aba:	c9                   	leave  
80106abb:	c3                   	ret    

80106abc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80106abc:	55                   	push   %ebp
80106abd:	89 e5                	mov    %esp,%ebp
80106abf:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80106ac2:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80106ac7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80106aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106acd:	c9                   	leave  
80106ace:	c3                   	ret    

80106acf <sys_halt>:

//Turn of the computer
int sys_halt(void){
80106acf:	55                   	push   %ebp
80106ad0:	89 e5                	mov    %esp,%ebp
80106ad2:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80106ad5:	83 ec 0c             	sub    $0xc,%esp
80106ad8:	68 05 91 10 80       	push   $0x80109105
80106add:	e8 e4 98 ff ff       	call   801003c6 <cprintf>
80106ae2:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
80106ae5:	83 ec 08             	sub    $0x8,%esp
80106ae8:	68 00 20 00 00       	push   $0x2000
80106aed:	68 04 06 00 00       	push   $0x604
80106af2:	e8 83 fe ff ff       	call   8010697a <outw>
80106af7:	83 c4 10             	add    $0x10,%esp
  return 0;
80106afa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106aff:	c9                   	leave  
80106b00:	c3                   	ret    

80106b01 <sys_date>:

// My implementation of sys_date()
int
sys_date(void)
{
80106b01:	55                   	push   %ebp
80106b02:	89 e5                	mov    %esp,%ebp
80106b04:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if (argptr(0, (void*)&d, sizeof(*d)) < 0)
80106b07:	83 ec 04             	sub    $0x4,%esp
80106b0a:	6a 18                	push   $0x18
80106b0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b0f:	50                   	push   %eax
80106b10:	6a 00                	push   $0x0
80106b12:	e8 d9 ef ff ff       	call   80105af0 <argptr>
80106b17:	83 c4 10             	add    $0x10,%esp
80106b1a:	85 c0                	test   %eax,%eax
80106b1c:	79 07                	jns    80106b25 <sys_date+0x24>
    return -1;
80106b1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b23:	eb 14                	jmp    80106b39 <sys_date+0x38>
  // MY CODE HERE
  cmostime(d);       
80106b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b28:	83 ec 0c             	sub    $0xc,%esp
80106b2b:	50                   	push   %eax
80106b2c:	e8 be c6 ff ff       	call   801031ef <cmostime>
80106b31:	83 c4 10             	add    $0x10,%esp
  return 0; 
80106b34:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b39:	c9                   	leave  
80106b3a:	c3                   	ret    

80106b3b <sys_getuid>:

// My implementation of sys_getuid
uint
sys_getuid(void)
{
80106b3b:	55                   	push   %ebp
80106b3c:	89 e5                	mov    %esp,%ebp
  return proc->uid;
80106b3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b44:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80106b4a:	5d                   	pop    %ebp
80106b4b:	c3                   	ret    

80106b4c <sys_getgid>:

// My implementation of sys_getgid
uint
sys_getgid(void)
{
80106b4c:	55                   	push   %ebp
80106b4d:	89 e5                	mov    %esp,%ebp
  return proc->gid;
80106b4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b55:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80106b5b:	5d                   	pop    %ebp
80106b5c:	c3                   	ret    

80106b5d <sys_getppid>:

// My implementation of sys_getppid
uint
sys_getppid(void)
{
80106b5d:	55                   	push   %ebp
80106b5e:	89 e5                	mov    %esp,%ebp
  return proc->parent ? proc->parent->pid : proc->pid;
80106b60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b66:	8b 40 14             	mov    0x14(%eax),%eax
80106b69:	85 c0                	test   %eax,%eax
80106b6b:	74 0e                	je     80106b7b <sys_getppid+0x1e>
80106b6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b73:	8b 40 14             	mov    0x14(%eax),%eax
80106b76:	8b 40 10             	mov    0x10(%eax),%eax
80106b79:	eb 09                	jmp    80106b84 <sys_getppid+0x27>
80106b7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b81:	8b 40 10             	mov    0x10(%eax),%eax
}
80106b84:	5d                   	pop    %ebp
80106b85:	c3                   	ret    

80106b86 <sys_setuid>:


// Implementation of sys_setuid
int 
sys_setuid(void)
{
80106b86:	55                   	push   %ebp
80106b87:	89 e5                	mov    %esp,%ebp
80106b89:	83 ec 18             	sub    $0x18,%esp
  int id; // uid argument
  // Grab argument off the stack and store in id
  argint(0, &id);
80106b8c:	83 ec 08             	sub    $0x8,%esp
80106b8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b92:	50                   	push   %eax
80106b93:	6a 00                	push   $0x0
80106b95:	e8 2e ef ff ff       	call   80105ac8 <argint>
80106b9a:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
80106b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ba0:	85 c0                	test   %eax,%eax
80106ba2:	78 0a                	js     80106bae <sys_setuid+0x28>
80106ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ba7:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106bac:	7e 07                	jle    80106bb5 <sys_setuid+0x2f>
    return -1;
80106bae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bb3:	eb 14                	jmp    80106bc9 <sys_setuid+0x43>
  proc->uid = id; 
80106bb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106bbe:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80106bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bc9:	c9                   	leave  
80106bca:	c3                   	ret    

80106bcb <sys_setgid>:

// Implementation of sys_setgid
int
sys_setgid(void)
{
80106bcb:	55                   	push   %ebp
80106bcc:	89 e5                	mov    %esp,%ebp
80106bce:	83 ec 18             	sub    $0x18,%esp
  int id; // gid argument 
  // Grab argument off the stack and store in id
  argint(0, &id);
80106bd1:	83 ec 08             	sub    $0x8,%esp
80106bd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bd7:	50                   	push   %eax
80106bd8:	6a 00                	push   $0x0
80106bda:	e8 e9 ee ff ff       	call   80105ac8 <argint>
80106bdf:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
80106be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106be5:	85 c0                	test   %eax,%eax
80106be7:	78 0a                	js     80106bf3 <sys_setgid+0x28>
80106be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bec:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106bf1:	7e 07                	jle    80106bfa <sys_setgid+0x2f>
    return -1;
80106bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bf8:	eb 14                	jmp    80106c0e <sys_setgid+0x43>
  proc->gid = id;
80106bfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c03:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  return 0;
80106c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c0e:	c9                   	leave  
80106c0f:	c3                   	ret    

80106c10 <sys_getprocs>:

// Implementation of sys_getprocs
int
sys_getprocs(void)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	83 ec 18             	sub    $0x18,%esp
  int m; // Max arg
  struct uproc* table;
  argint(0, &m);
80106c16:	83 ec 08             	sub    $0x8,%esp
80106c19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c1c:	50                   	push   %eax
80106c1d:	6a 00                	push   $0x0
80106c1f:	e8 a4 ee ff ff       	call   80105ac8 <argint>
80106c24:	83 c4 10             	add    $0x10,%esp
  if (m < 0)
80106c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c2a:	85 c0                	test   %eax,%eax
80106c2c:	79 07                	jns    80106c35 <sys_getprocs+0x25>
    return -1;
80106c2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c33:	eb 28                	jmp    80106c5d <sys_getprocs+0x4d>
  argptr(1, (void*)&table, m);
80106c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c38:	83 ec 04             	sub    $0x4,%esp
80106c3b:	50                   	push   %eax
80106c3c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c3f:	50                   	push   %eax
80106c40:	6a 01                	push   $0x1
80106c42:	e8 a9 ee ff ff       	call   80105af0 <argptr>
80106c47:	83 c4 10             	add    $0x10,%esp
  return getproc_helper(m, table);
80106c4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c50:	83 ec 08             	sub    $0x8,%esp
80106c53:	52                   	push   %edx
80106c54:	50                   	push   %eax
80106c55:	e8 ba e6 ff ff       	call   80105314 <getproc_helper>
80106c5a:	83 c4 10             	add    $0x10,%esp
}
80106c5d:	c9                   	leave  
80106c5e:	c3                   	ret    

80106c5f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106c5f:	55                   	push   %ebp
80106c60:	89 e5                	mov    %esp,%ebp
80106c62:	83 ec 08             	sub    $0x8,%esp
80106c65:	8b 55 08             	mov    0x8(%ebp),%edx
80106c68:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c6b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106c6f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c72:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106c76:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106c7a:	ee                   	out    %al,(%dx)
}
80106c7b:	90                   	nop
80106c7c:	c9                   	leave  
80106c7d:	c3                   	ret    

80106c7e <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106c7e:	55                   	push   %ebp
80106c7f:	89 e5                	mov    %esp,%ebp
80106c81:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106c84:	6a 34                	push   $0x34
80106c86:	6a 43                	push   $0x43
80106c88:	e8 d2 ff ff ff       	call   80106c5f <outb>
80106c8d:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106c90:	68 9c 00 00 00       	push   $0x9c
80106c95:	6a 40                	push   $0x40
80106c97:	e8 c3 ff ff ff       	call   80106c5f <outb>
80106c9c:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106c9f:	6a 2e                	push   $0x2e
80106ca1:	6a 40                	push   $0x40
80106ca3:	e8 b7 ff ff ff       	call   80106c5f <outb>
80106ca8:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106cab:	83 ec 0c             	sub    $0xc,%esp
80106cae:	6a 00                	push   $0x0
80106cb0:	e8 9d d2 ff ff       	call   80103f52 <picenable>
80106cb5:	83 c4 10             	add    $0x10,%esp
}
80106cb8:	90                   	nop
80106cb9:	c9                   	leave  
80106cba:	c3                   	ret    

80106cbb <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106cbb:	1e                   	push   %ds
  pushl %es
80106cbc:	06                   	push   %es
  pushl %fs
80106cbd:	0f a0                	push   %fs
  pushl %gs
80106cbf:	0f a8                	push   %gs
  pushal
80106cc1:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106cc2:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106cc6:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106cc8:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106cca:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106cce:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106cd0:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106cd2:	54                   	push   %esp
  call trap
80106cd3:	e8 ce 01 00 00       	call   80106ea6 <trap>
  addl $4, %esp
80106cd8:	83 c4 04             	add    $0x4,%esp

80106cdb <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106cdb:	61                   	popa   
  popl %gs
80106cdc:	0f a9                	pop    %gs
  popl %fs
80106cde:	0f a1                	pop    %fs
  popl %es
80106ce0:	07                   	pop    %es
  popl %ds
80106ce1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106ce2:	83 c4 08             	add    $0x8,%esp
  iret
80106ce5:	cf                   	iret   

80106ce6 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80106ce6:	55                   	push   %ebp
80106ce7:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80106ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80106cec:	f0 ff 00             	lock incl (%eax)
}
80106cef:	90                   	nop
80106cf0:	5d                   	pop    %ebp
80106cf1:	c3                   	ret    

80106cf2 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106cf2:	55                   	push   %ebp
80106cf3:	89 e5                	mov    %esp,%ebp
80106cf5:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cfb:	83 e8 01             	sub    $0x1,%eax
80106cfe:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106d02:	8b 45 08             	mov    0x8(%ebp),%eax
80106d05:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106d09:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0c:	c1 e8 10             	shr    $0x10,%eax
80106d0f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106d13:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106d16:	0f 01 18             	lidtl  (%eax)
}
80106d19:	90                   	nop
80106d1a:	c9                   	leave  
80106d1b:	c3                   	ret    

80106d1c <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106d1c:	55                   	push   %ebp
80106d1d:	89 e5                	mov    %esp,%ebp
80106d1f:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106d22:	0f 20 d0             	mov    %cr2,%eax
80106d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d2b:	c9                   	leave  
80106d2c:	c3                   	ret    

80106d2d <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80106d2d:	55                   	push   %ebp
80106d2e:	89 e5                	mov    %esp,%ebp
80106d30:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80106d33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106d3a:	e9 c3 00 00 00       	jmp    80106e02 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106d3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106d42:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80106d49:	89 c2                	mov    %eax,%edx
80106d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106d4e:	66 89 14 c5 e0 5e 11 	mov    %dx,-0x7feea120(,%eax,8)
80106d55:	80 
80106d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106d59:	66 c7 04 c5 e2 5e 11 	movw   $0x8,-0x7feea11e(,%eax,8)
80106d60:	80 08 00 
80106d63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106d66:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
80106d6d:	80 
80106d6e:	83 e2 e0             	and    $0xffffffe0,%edx
80106d71:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
80106d78:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106d7b:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
80106d82:	80 
80106d83:	83 e2 1f             	and    $0x1f,%edx
80106d86:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
80106d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106d90:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80106d97:	80 
80106d98:	83 e2 f0             	and    $0xfffffff0,%edx
80106d9b:	83 ca 0e             	or     $0xe,%edx
80106d9e:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80106da5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106da8:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80106daf:	80 
80106db0:	83 e2 ef             	and    $0xffffffef,%edx
80106db3:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80106dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dbd:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80106dc4:	80 
80106dc5:	83 e2 9f             	and    $0xffffff9f,%edx
80106dc8:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80106dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dd2:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80106dd9:	80 
80106dda:	83 ca 80             	or     $0xffffff80,%edx
80106ddd:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80106de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106de7:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80106dee:	c1 e8 10             	shr    $0x10,%eax
80106df1:	89 c2                	mov    %eax,%edx
80106df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106df6:	66 89 14 c5 e6 5e 11 	mov    %dx,-0x7feea11a(,%eax,8)
80106dfd:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106dfe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106e02:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80106e09:	0f 8e 30 ff ff ff    	jle    80106d3f <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e0f:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80106e14:	66 a3 e0 60 11 80    	mov    %ax,0x801160e0
80106e1a:	66 c7 05 e2 60 11 80 	movw   $0x8,0x801160e2
80106e21:	08 00 
80106e23:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
80106e2a:	83 e0 e0             	and    $0xffffffe0,%eax
80106e2d:	a2 e4 60 11 80       	mov    %al,0x801160e4
80106e32:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
80106e39:	83 e0 1f             	and    $0x1f,%eax
80106e3c:	a2 e4 60 11 80       	mov    %al,0x801160e4
80106e41:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80106e48:	83 c8 0f             	or     $0xf,%eax
80106e4b:	a2 e5 60 11 80       	mov    %al,0x801160e5
80106e50:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80106e57:	83 e0 ef             	and    $0xffffffef,%eax
80106e5a:	a2 e5 60 11 80       	mov    %al,0x801160e5
80106e5f:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80106e66:	83 c8 60             	or     $0x60,%eax
80106e69:	a2 e5 60 11 80       	mov    %al,0x801160e5
80106e6e:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80106e75:	83 c8 80             	or     $0xffffff80,%eax
80106e78:	a2 e5 60 11 80       	mov    %al,0x801160e5
80106e7d:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80106e82:	c1 e8 10             	shr    $0x10,%eax
80106e85:	66 a3 e6 60 11 80    	mov    %ax,0x801160e6
  
}
80106e8b:	90                   	nop
80106e8c:	c9                   	leave  
80106e8d:	c3                   	ret    

80106e8e <idtinit>:

void
idtinit(void)
{
80106e8e:	55                   	push   %ebp
80106e8f:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106e91:	68 00 08 00 00       	push   $0x800
80106e96:	68 e0 5e 11 80       	push   $0x80115ee0
80106e9b:	e8 52 fe ff ff       	call   80106cf2 <lidt>
80106ea0:	83 c4 08             	add    $0x8,%esp
}
80106ea3:	90                   	nop
80106ea4:	c9                   	leave  
80106ea5:	c3                   	ret    

80106ea6 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106ea6:	55                   	push   %ebp
80106ea7:	89 e5                	mov    %esp,%ebp
80106ea9:	57                   	push   %edi
80106eaa:	56                   	push   %esi
80106eab:	53                   	push   %ebx
80106eac:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106eaf:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb2:	8b 40 30             	mov    0x30(%eax),%eax
80106eb5:	83 f8 40             	cmp    $0x40,%eax
80106eb8:	75 3e                	jne    80106ef8 <trap+0x52>
    if(proc->killed)
80106eba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ec0:	8b 40 24             	mov    0x24(%eax),%eax
80106ec3:	85 c0                	test   %eax,%eax
80106ec5:	74 05                	je     80106ecc <trap+0x26>
      exit();
80106ec7:	e8 06 db ff ff       	call   801049d2 <exit>
    proc->tf = tf;
80106ecc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ed2:	8b 55 08             	mov    0x8(%ebp),%edx
80106ed5:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106ed8:	e8 a1 ec ff ff       	call   80105b7e <syscall>
    if(proc->killed)
80106edd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ee3:	8b 40 24             	mov    0x24(%eax),%eax
80106ee6:	85 c0                	test   %eax,%eax
80106ee8:	0f 84 fe 01 00 00    	je     801070ec <trap+0x246>
      exit();
80106eee:	e8 df da ff ff       	call   801049d2 <exit>
    return;
80106ef3:	e9 f4 01 00 00       	jmp    801070ec <trap+0x246>
  }

  switch(tf->trapno){
80106ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80106efb:	8b 40 30             	mov    0x30(%eax),%eax
80106efe:	83 e8 20             	sub    $0x20,%eax
80106f01:	83 f8 1f             	cmp    $0x1f,%eax
80106f04:	0f 87 a3 00 00 00    	ja     80106fad <trap+0x107>
80106f0a:	8b 04 85 b8 91 10 80 	mov    -0x7fef6e48(,%eax,4),%eax
80106f11:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80106f13:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f19:	0f b6 00             	movzbl (%eax),%eax
80106f1c:	84 c0                	test   %al,%al
80106f1e:	75 20                	jne    80106f40 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80106f20:	83 ec 0c             	sub    $0xc,%esp
80106f23:	68 e0 66 11 80       	push   $0x801166e0
80106f28:	e8 b9 fd ff ff       	call   80106ce6 <atom_inc>
80106f2d:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80106f30:	83 ec 0c             	sub    $0xc,%esp
80106f33:	68 e0 66 11 80       	push   $0x801166e0
80106f38:	e8 2e e0 ff ff       	call   80104f6b <wakeup>
80106f3d:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106f40:	e8 07 c1 ff ff       	call   8010304c <lapiceoi>
    break;
80106f45:	e9 1c 01 00 00       	jmp    80107066 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106f4a:	e8 10 b9 ff ff       	call   8010285f <ideintr>
    lapiceoi();
80106f4f:	e8 f8 c0 ff ff       	call   8010304c <lapiceoi>
    break;
80106f54:	e9 0d 01 00 00       	jmp    80107066 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106f59:	e8 f0 be ff ff       	call   80102e4e <kbdintr>
    lapiceoi();
80106f5e:	e8 e9 c0 ff ff       	call   8010304c <lapiceoi>
    break;
80106f63:	e9 fe 00 00 00       	jmp    80107066 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106f68:	e8 60 03 00 00       	call   801072cd <uartintr>
    lapiceoi();
80106f6d:	e8 da c0 ff ff       	call   8010304c <lapiceoi>
    break;
80106f72:	e9 ef 00 00 00       	jmp    80107066 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f77:	8b 45 08             	mov    0x8(%ebp),%eax
80106f7a:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80106f80:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f84:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106f87:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f8d:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f90:	0f b6 c0             	movzbl %al,%eax
80106f93:	51                   	push   %ecx
80106f94:	52                   	push   %edx
80106f95:	50                   	push   %eax
80106f96:	68 18 91 10 80       	push   $0x80109118
80106f9b:	e8 26 94 ff ff       	call   801003c6 <cprintf>
80106fa0:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106fa3:	e8 a4 c0 ff ff       	call   8010304c <lapiceoi>
    break;
80106fa8:	e9 b9 00 00 00       	jmp    80107066 <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106fad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fb3:	85 c0                	test   %eax,%eax
80106fb5:	74 11                	je     80106fc8 <trap+0x122>
80106fb7:	8b 45 08             	mov    0x8(%ebp),%eax
80106fba:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106fbe:	0f b7 c0             	movzwl %ax,%eax
80106fc1:	83 e0 03             	and    $0x3,%eax
80106fc4:	85 c0                	test   %eax,%eax
80106fc6:	75 40                	jne    80107008 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106fc8:	e8 4f fd ff ff       	call   80106d1c <rcr2>
80106fcd:	89 c3                	mov    %eax,%ebx
80106fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80106fd2:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106fd5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106fdb:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106fde:	0f b6 d0             	movzbl %al,%edx
80106fe1:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe4:	8b 40 30             	mov    0x30(%eax),%eax
80106fe7:	83 ec 0c             	sub    $0xc,%esp
80106fea:	53                   	push   %ebx
80106feb:	51                   	push   %ecx
80106fec:	52                   	push   %edx
80106fed:	50                   	push   %eax
80106fee:	68 3c 91 10 80       	push   $0x8010913c
80106ff3:	e8 ce 93 ff ff       	call   801003c6 <cprintf>
80106ff8:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106ffb:	83 ec 0c             	sub    $0xc,%esp
80106ffe:	68 6e 91 10 80       	push   $0x8010916e
80107003:	e8 5e 95 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107008:	e8 0f fd ff ff       	call   80106d1c <rcr2>
8010700d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107010:	8b 45 08             	mov    0x8(%ebp),%eax
80107013:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107016:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010701c:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010701f:	0f b6 d8             	movzbl %al,%ebx
80107022:	8b 45 08             	mov    0x8(%ebp),%eax
80107025:	8b 48 34             	mov    0x34(%eax),%ecx
80107028:	8b 45 08             	mov    0x8(%ebp),%eax
8010702b:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010702e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107034:	8d 78 6c             	lea    0x6c(%eax),%edi
80107037:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010703d:	8b 40 10             	mov    0x10(%eax),%eax
80107040:	ff 75 e4             	pushl  -0x1c(%ebp)
80107043:	56                   	push   %esi
80107044:	53                   	push   %ebx
80107045:	51                   	push   %ecx
80107046:	52                   	push   %edx
80107047:	57                   	push   %edi
80107048:	50                   	push   %eax
80107049:	68 74 91 10 80       	push   $0x80109174
8010704e:	e8 73 93 ff ff       	call   801003c6 <cprintf>
80107053:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107056:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010705c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107063:	eb 01                	jmp    80107066 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107065:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107066:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010706c:	85 c0                	test   %eax,%eax
8010706e:	74 24                	je     80107094 <trap+0x1ee>
80107070:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107076:	8b 40 24             	mov    0x24(%eax),%eax
80107079:	85 c0                	test   %eax,%eax
8010707b:	74 17                	je     80107094 <trap+0x1ee>
8010707d:	8b 45 08             	mov    0x8(%ebp),%eax
80107080:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107084:	0f b7 c0             	movzwl %ax,%eax
80107087:	83 e0 03             	and    $0x3,%eax
8010708a:	83 f8 03             	cmp    $0x3,%eax
8010708d:	75 05                	jne    80107094 <trap+0x1ee>
    exit();
8010708f:	e8 3e d9 ff ff       	call   801049d2 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107094:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010709a:	85 c0                	test   %eax,%eax
8010709c:	74 1e                	je     801070bc <trap+0x216>
8010709e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070a4:	8b 40 0c             	mov    0xc(%eax),%eax
801070a7:	83 f8 04             	cmp    $0x4,%eax
801070aa:	75 10                	jne    801070bc <trap+0x216>
801070ac:	8b 45 08             	mov    0x8(%ebp),%eax
801070af:	8b 40 30             	mov    0x30(%eax),%eax
801070b2:	83 f8 20             	cmp    $0x20,%eax
801070b5:	75 05                	jne    801070bc <trap+0x216>
    yield();
801070b7:	e8 47 dd ff ff       	call   80104e03 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801070bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070c2:	85 c0                	test   %eax,%eax
801070c4:	74 27                	je     801070ed <trap+0x247>
801070c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070cc:	8b 40 24             	mov    0x24(%eax),%eax
801070cf:	85 c0                	test   %eax,%eax
801070d1:	74 1a                	je     801070ed <trap+0x247>
801070d3:	8b 45 08             	mov    0x8(%ebp),%eax
801070d6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801070da:	0f b7 c0             	movzwl %ax,%eax
801070dd:	83 e0 03             	and    $0x3,%eax
801070e0:	83 f8 03             	cmp    $0x3,%eax
801070e3:	75 08                	jne    801070ed <trap+0x247>
    exit();
801070e5:	e8 e8 d8 ff ff       	call   801049d2 <exit>
801070ea:	eb 01                	jmp    801070ed <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801070ec:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801070ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f0:	5b                   	pop    %ebx
801070f1:	5e                   	pop    %esi
801070f2:	5f                   	pop    %edi
801070f3:	5d                   	pop    %ebp
801070f4:	c3                   	ret    

801070f5 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801070f5:	55                   	push   %ebp
801070f6:	89 e5                	mov    %esp,%ebp
801070f8:	83 ec 14             	sub    $0x14,%esp
801070fb:	8b 45 08             	mov    0x8(%ebp),%eax
801070fe:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107102:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107106:	89 c2                	mov    %eax,%edx
80107108:	ec                   	in     (%dx),%al
80107109:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010710c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107110:	c9                   	leave  
80107111:	c3                   	ret    

80107112 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107112:	55                   	push   %ebp
80107113:	89 e5                	mov    %esp,%ebp
80107115:	83 ec 08             	sub    $0x8,%esp
80107118:	8b 55 08             	mov    0x8(%ebp),%edx
8010711b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010711e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107122:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107125:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107129:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010712d:	ee                   	out    %al,(%dx)
}
8010712e:	90                   	nop
8010712f:	c9                   	leave  
80107130:	c3                   	ret    

80107131 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107131:	55                   	push   %ebp
80107132:	89 e5                	mov    %esp,%ebp
80107134:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107137:	6a 00                	push   $0x0
80107139:	68 fa 03 00 00       	push   $0x3fa
8010713e:	e8 cf ff ff ff       	call   80107112 <outb>
80107143:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107146:	68 80 00 00 00       	push   $0x80
8010714b:	68 fb 03 00 00       	push   $0x3fb
80107150:	e8 bd ff ff ff       	call   80107112 <outb>
80107155:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107158:	6a 0c                	push   $0xc
8010715a:	68 f8 03 00 00       	push   $0x3f8
8010715f:	e8 ae ff ff ff       	call   80107112 <outb>
80107164:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107167:	6a 00                	push   $0x0
80107169:	68 f9 03 00 00       	push   $0x3f9
8010716e:	e8 9f ff ff ff       	call   80107112 <outb>
80107173:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107176:	6a 03                	push   $0x3
80107178:	68 fb 03 00 00       	push   $0x3fb
8010717d:	e8 90 ff ff ff       	call   80107112 <outb>
80107182:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107185:	6a 00                	push   $0x0
80107187:	68 fc 03 00 00       	push   $0x3fc
8010718c:	e8 81 ff ff ff       	call   80107112 <outb>
80107191:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107194:	6a 01                	push   $0x1
80107196:	68 f9 03 00 00       	push   $0x3f9
8010719b:	e8 72 ff ff ff       	call   80107112 <outb>
801071a0:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801071a3:	68 fd 03 00 00       	push   $0x3fd
801071a8:	e8 48 ff ff ff       	call   801070f5 <inb>
801071ad:	83 c4 04             	add    $0x4,%esp
801071b0:	3c ff                	cmp    $0xff,%al
801071b2:	74 6e                	je     80107222 <uartinit+0xf1>
    return;
  uart = 1;
801071b4:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
801071bb:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801071be:	68 fa 03 00 00       	push   $0x3fa
801071c3:	e8 2d ff ff ff       	call   801070f5 <inb>
801071c8:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801071cb:	68 f8 03 00 00       	push   $0x3f8
801071d0:	e8 20 ff ff ff       	call   801070f5 <inb>
801071d5:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801071d8:	83 ec 0c             	sub    $0xc,%esp
801071db:	6a 04                	push   $0x4
801071dd:	e8 70 cd ff ff       	call   80103f52 <picenable>
801071e2:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801071e5:	83 ec 08             	sub    $0x8,%esp
801071e8:	6a 00                	push   $0x0
801071ea:	6a 04                	push   $0x4
801071ec:	e8 10 b9 ff ff       	call   80102b01 <ioapicenable>
801071f1:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801071f4:	c7 45 f4 38 92 10 80 	movl   $0x80109238,-0xc(%ebp)
801071fb:	eb 19                	jmp    80107216 <uartinit+0xe5>
    uartputc(*p);
801071fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107200:	0f b6 00             	movzbl (%eax),%eax
80107203:	0f be c0             	movsbl %al,%eax
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	50                   	push   %eax
8010720a:	e8 16 00 00 00       	call   80107225 <uartputc>
8010720f:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107212:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107219:	0f b6 00             	movzbl (%eax),%eax
8010721c:	84 c0                	test   %al,%al
8010721e:	75 dd                	jne    801071fd <uartinit+0xcc>
80107220:	eb 01                	jmp    80107223 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107222:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107223:	c9                   	leave  
80107224:	c3                   	ret    

80107225 <uartputc>:

void
uartputc(int c)
{
80107225:	55                   	push   %ebp
80107226:	89 e5                	mov    %esp,%ebp
80107228:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010722b:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107230:	85 c0                	test   %eax,%eax
80107232:	74 53                	je     80107287 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107234:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010723b:	eb 11                	jmp    8010724e <uartputc+0x29>
    microdelay(10);
8010723d:	83 ec 0c             	sub    $0xc,%esp
80107240:	6a 0a                	push   $0xa
80107242:	e8 20 be ff ff       	call   80103067 <microdelay>
80107247:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010724a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010724e:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107252:	7f 1a                	jg     8010726e <uartputc+0x49>
80107254:	83 ec 0c             	sub    $0xc,%esp
80107257:	68 fd 03 00 00       	push   $0x3fd
8010725c:	e8 94 fe ff ff       	call   801070f5 <inb>
80107261:	83 c4 10             	add    $0x10,%esp
80107264:	0f b6 c0             	movzbl %al,%eax
80107267:	83 e0 20             	and    $0x20,%eax
8010726a:	85 c0                	test   %eax,%eax
8010726c:	74 cf                	je     8010723d <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
8010726e:	8b 45 08             	mov    0x8(%ebp),%eax
80107271:	0f b6 c0             	movzbl %al,%eax
80107274:	83 ec 08             	sub    $0x8,%esp
80107277:	50                   	push   %eax
80107278:	68 f8 03 00 00       	push   $0x3f8
8010727d:	e8 90 fe ff ff       	call   80107112 <outb>
80107282:	83 c4 10             	add    $0x10,%esp
80107285:	eb 01                	jmp    80107288 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107287:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107288:	c9                   	leave  
80107289:	c3                   	ret    

8010728a <uartgetc>:

static int
uartgetc(void)
{
8010728a:	55                   	push   %ebp
8010728b:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010728d:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107292:	85 c0                	test   %eax,%eax
80107294:	75 07                	jne    8010729d <uartgetc+0x13>
    return -1;
80107296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010729b:	eb 2e                	jmp    801072cb <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010729d:	68 fd 03 00 00       	push   $0x3fd
801072a2:	e8 4e fe ff ff       	call   801070f5 <inb>
801072a7:	83 c4 04             	add    $0x4,%esp
801072aa:	0f b6 c0             	movzbl %al,%eax
801072ad:	83 e0 01             	and    $0x1,%eax
801072b0:	85 c0                	test   %eax,%eax
801072b2:	75 07                	jne    801072bb <uartgetc+0x31>
    return -1;
801072b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072b9:	eb 10                	jmp    801072cb <uartgetc+0x41>
  return inb(COM1+0);
801072bb:	68 f8 03 00 00       	push   $0x3f8
801072c0:	e8 30 fe ff ff       	call   801070f5 <inb>
801072c5:	83 c4 04             	add    $0x4,%esp
801072c8:	0f b6 c0             	movzbl %al,%eax
}
801072cb:	c9                   	leave  
801072cc:	c3                   	ret    

801072cd <uartintr>:

void
uartintr(void)
{
801072cd:	55                   	push   %ebp
801072ce:	89 e5                	mov    %esp,%ebp
801072d0:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801072d3:	83 ec 0c             	sub    $0xc,%esp
801072d6:	68 8a 72 10 80       	push   $0x8010728a
801072db:	e8 19 95 ff ff       	call   801007f9 <consoleintr>
801072e0:	83 c4 10             	add    $0x10,%esp
}
801072e3:	90                   	nop
801072e4:	c9                   	leave  
801072e5:	c3                   	ret    

801072e6 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801072e6:	6a 00                	push   $0x0
  pushl $0
801072e8:	6a 00                	push   $0x0
  jmp alltraps
801072ea:	e9 cc f9 ff ff       	jmp    80106cbb <alltraps>

801072ef <vector1>:
.globl vector1
vector1:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $1
801072f1:	6a 01                	push   $0x1
  jmp alltraps
801072f3:	e9 c3 f9 ff ff       	jmp    80106cbb <alltraps>

801072f8 <vector2>:
.globl vector2
vector2:
  pushl $0
801072f8:	6a 00                	push   $0x0
  pushl $2
801072fa:	6a 02                	push   $0x2
  jmp alltraps
801072fc:	e9 ba f9 ff ff       	jmp    80106cbb <alltraps>

80107301 <vector3>:
.globl vector3
vector3:
  pushl $0
80107301:	6a 00                	push   $0x0
  pushl $3
80107303:	6a 03                	push   $0x3
  jmp alltraps
80107305:	e9 b1 f9 ff ff       	jmp    80106cbb <alltraps>

8010730a <vector4>:
.globl vector4
vector4:
  pushl $0
8010730a:	6a 00                	push   $0x0
  pushl $4
8010730c:	6a 04                	push   $0x4
  jmp alltraps
8010730e:	e9 a8 f9 ff ff       	jmp    80106cbb <alltraps>

80107313 <vector5>:
.globl vector5
vector5:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $5
80107315:	6a 05                	push   $0x5
  jmp alltraps
80107317:	e9 9f f9 ff ff       	jmp    80106cbb <alltraps>

8010731c <vector6>:
.globl vector6
vector6:
  pushl $0
8010731c:	6a 00                	push   $0x0
  pushl $6
8010731e:	6a 06                	push   $0x6
  jmp alltraps
80107320:	e9 96 f9 ff ff       	jmp    80106cbb <alltraps>

80107325 <vector7>:
.globl vector7
vector7:
  pushl $0
80107325:	6a 00                	push   $0x0
  pushl $7
80107327:	6a 07                	push   $0x7
  jmp alltraps
80107329:	e9 8d f9 ff ff       	jmp    80106cbb <alltraps>

8010732e <vector8>:
.globl vector8
vector8:
  pushl $8
8010732e:	6a 08                	push   $0x8
  jmp alltraps
80107330:	e9 86 f9 ff ff       	jmp    80106cbb <alltraps>

80107335 <vector9>:
.globl vector9
vector9:
  pushl $0
80107335:	6a 00                	push   $0x0
  pushl $9
80107337:	6a 09                	push   $0x9
  jmp alltraps
80107339:	e9 7d f9 ff ff       	jmp    80106cbb <alltraps>

8010733e <vector10>:
.globl vector10
vector10:
  pushl $10
8010733e:	6a 0a                	push   $0xa
  jmp alltraps
80107340:	e9 76 f9 ff ff       	jmp    80106cbb <alltraps>

80107345 <vector11>:
.globl vector11
vector11:
  pushl $11
80107345:	6a 0b                	push   $0xb
  jmp alltraps
80107347:	e9 6f f9 ff ff       	jmp    80106cbb <alltraps>

8010734c <vector12>:
.globl vector12
vector12:
  pushl $12
8010734c:	6a 0c                	push   $0xc
  jmp alltraps
8010734e:	e9 68 f9 ff ff       	jmp    80106cbb <alltraps>

80107353 <vector13>:
.globl vector13
vector13:
  pushl $13
80107353:	6a 0d                	push   $0xd
  jmp alltraps
80107355:	e9 61 f9 ff ff       	jmp    80106cbb <alltraps>

8010735a <vector14>:
.globl vector14
vector14:
  pushl $14
8010735a:	6a 0e                	push   $0xe
  jmp alltraps
8010735c:	e9 5a f9 ff ff       	jmp    80106cbb <alltraps>

80107361 <vector15>:
.globl vector15
vector15:
  pushl $0
80107361:	6a 00                	push   $0x0
  pushl $15
80107363:	6a 0f                	push   $0xf
  jmp alltraps
80107365:	e9 51 f9 ff ff       	jmp    80106cbb <alltraps>

8010736a <vector16>:
.globl vector16
vector16:
  pushl $0
8010736a:	6a 00                	push   $0x0
  pushl $16
8010736c:	6a 10                	push   $0x10
  jmp alltraps
8010736e:	e9 48 f9 ff ff       	jmp    80106cbb <alltraps>

80107373 <vector17>:
.globl vector17
vector17:
  pushl $17
80107373:	6a 11                	push   $0x11
  jmp alltraps
80107375:	e9 41 f9 ff ff       	jmp    80106cbb <alltraps>

8010737a <vector18>:
.globl vector18
vector18:
  pushl $0
8010737a:	6a 00                	push   $0x0
  pushl $18
8010737c:	6a 12                	push   $0x12
  jmp alltraps
8010737e:	e9 38 f9 ff ff       	jmp    80106cbb <alltraps>

80107383 <vector19>:
.globl vector19
vector19:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $19
80107385:	6a 13                	push   $0x13
  jmp alltraps
80107387:	e9 2f f9 ff ff       	jmp    80106cbb <alltraps>

8010738c <vector20>:
.globl vector20
vector20:
  pushl $0
8010738c:	6a 00                	push   $0x0
  pushl $20
8010738e:	6a 14                	push   $0x14
  jmp alltraps
80107390:	e9 26 f9 ff ff       	jmp    80106cbb <alltraps>

80107395 <vector21>:
.globl vector21
vector21:
  pushl $0
80107395:	6a 00                	push   $0x0
  pushl $21
80107397:	6a 15                	push   $0x15
  jmp alltraps
80107399:	e9 1d f9 ff ff       	jmp    80106cbb <alltraps>

8010739e <vector22>:
.globl vector22
vector22:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $22
801073a0:	6a 16                	push   $0x16
  jmp alltraps
801073a2:	e9 14 f9 ff ff       	jmp    80106cbb <alltraps>

801073a7 <vector23>:
.globl vector23
vector23:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $23
801073a9:	6a 17                	push   $0x17
  jmp alltraps
801073ab:	e9 0b f9 ff ff       	jmp    80106cbb <alltraps>

801073b0 <vector24>:
.globl vector24
vector24:
  pushl $0
801073b0:	6a 00                	push   $0x0
  pushl $24
801073b2:	6a 18                	push   $0x18
  jmp alltraps
801073b4:	e9 02 f9 ff ff       	jmp    80106cbb <alltraps>

801073b9 <vector25>:
.globl vector25
vector25:
  pushl $0
801073b9:	6a 00                	push   $0x0
  pushl $25
801073bb:	6a 19                	push   $0x19
  jmp alltraps
801073bd:	e9 f9 f8 ff ff       	jmp    80106cbb <alltraps>

801073c2 <vector26>:
.globl vector26
vector26:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $26
801073c4:	6a 1a                	push   $0x1a
  jmp alltraps
801073c6:	e9 f0 f8 ff ff       	jmp    80106cbb <alltraps>

801073cb <vector27>:
.globl vector27
vector27:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $27
801073cd:	6a 1b                	push   $0x1b
  jmp alltraps
801073cf:	e9 e7 f8 ff ff       	jmp    80106cbb <alltraps>

801073d4 <vector28>:
.globl vector28
vector28:
  pushl $0
801073d4:	6a 00                	push   $0x0
  pushl $28
801073d6:	6a 1c                	push   $0x1c
  jmp alltraps
801073d8:	e9 de f8 ff ff       	jmp    80106cbb <alltraps>

801073dd <vector29>:
.globl vector29
vector29:
  pushl $0
801073dd:	6a 00                	push   $0x0
  pushl $29
801073df:	6a 1d                	push   $0x1d
  jmp alltraps
801073e1:	e9 d5 f8 ff ff       	jmp    80106cbb <alltraps>

801073e6 <vector30>:
.globl vector30
vector30:
  pushl $0
801073e6:	6a 00                	push   $0x0
  pushl $30
801073e8:	6a 1e                	push   $0x1e
  jmp alltraps
801073ea:	e9 cc f8 ff ff       	jmp    80106cbb <alltraps>

801073ef <vector31>:
.globl vector31
vector31:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $31
801073f1:	6a 1f                	push   $0x1f
  jmp alltraps
801073f3:	e9 c3 f8 ff ff       	jmp    80106cbb <alltraps>

801073f8 <vector32>:
.globl vector32
vector32:
  pushl $0
801073f8:	6a 00                	push   $0x0
  pushl $32
801073fa:	6a 20                	push   $0x20
  jmp alltraps
801073fc:	e9 ba f8 ff ff       	jmp    80106cbb <alltraps>

80107401 <vector33>:
.globl vector33
vector33:
  pushl $0
80107401:	6a 00                	push   $0x0
  pushl $33
80107403:	6a 21                	push   $0x21
  jmp alltraps
80107405:	e9 b1 f8 ff ff       	jmp    80106cbb <alltraps>

8010740a <vector34>:
.globl vector34
vector34:
  pushl $0
8010740a:	6a 00                	push   $0x0
  pushl $34
8010740c:	6a 22                	push   $0x22
  jmp alltraps
8010740e:	e9 a8 f8 ff ff       	jmp    80106cbb <alltraps>

80107413 <vector35>:
.globl vector35
vector35:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $35
80107415:	6a 23                	push   $0x23
  jmp alltraps
80107417:	e9 9f f8 ff ff       	jmp    80106cbb <alltraps>

8010741c <vector36>:
.globl vector36
vector36:
  pushl $0
8010741c:	6a 00                	push   $0x0
  pushl $36
8010741e:	6a 24                	push   $0x24
  jmp alltraps
80107420:	e9 96 f8 ff ff       	jmp    80106cbb <alltraps>

80107425 <vector37>:
.globl vector37
vector37:
  pushl $0
80107425:	6a 00                	push   $0x0
  pushl $37
80107427:	6a 25                	push   $0x25
  jmp alltraps
80107429:	e9 8d f8 ff ff       	jmp    80106cbb <alltraps>

8010742e <vector38>:
.globl vector38
vector38:
  pushl $0
8010742e:	6a 00                	push   $0x0
  pushl $38
80107430:	6a 26                	push   $0x26
  jmp alltraps
80107432:	e9 84 f8 ff ff       	jmp    80106cbb <alltraps>

80107437 <vector39>:
.globl vector39
vector39:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $39
80107439:	6a 27                	push   $0x27
  jmp alltraps
8010743b:	e9 7b f8 ff ff       	jmp    80106cbb <alltraps>

80107440 <vector40>:
.globl vector40
vector40:
  pushl $0
80107440:	6a 00                	push   $0x0
  pushl $40
80107442:	6a 28                	push   $0x28
  jmp alltraps
80107444:	e9 72 f8 ff ff       	jmp    80106cbb <alltraps>

80107449 <vector41>:
.globl vector41
vector41:
  pushl $0
80107449:	6a 00                	push   $0x0
  pushl $41
8010744b:	6a 29                	push   $0x29
  jmp alltraps
8010744d:	e9 69 f8 ff ff       	jmp    80106cbb <alltraps>

80107452 <vector42>:
.globl vector42
vector42:
  pushl $0
80107452:	6a 00                	push   $0x0
  pushl $42
80107454:	6a 2a                	push   $0x2a
  jmp alltraps
80107456:	e9 60 f8 ff ff       	jmp    80106cbb <alltraps>

8010745b <vector43>:
.globl vector43
vector43:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $43
8010745d:	6a 2b                	push   $0x2b
  jmp alltraps
8010745f:	e9 57 f8 ff ff       	jmp    80106cbb <alltraps>

80107464 <vector44>:
.globl vector44
vector44:
  pushl $0
80107464:	6a 00                	push   $0x0
  pushl $44
80107466:	6a 2c                	push   $0x2c
  jmp alltraps
80107468:	e9 4e f8 ff ff       	jmp    80106cbb <alltraps>

8010746d <vector45>:
.globl vector45
vector45:
  pushl $0
8010746d:	6a 00                	push   $0x0
  pushl $45
8010746f:	6a 2d                	push   $0x2d
  jmp alltraps
80107471:	e9 45 f8 ff ff       	jmp    80106cbb <alltraps>

80107476 <vector46>:
.globl vector46
vector46:
  pushl $0
80107476:	6a 00                	push   $0x0
  pushl $46
80107478:	6a 2e                	push   $0x2e
  jmp alltraps
8010747a:	e9 3c f8 ff ff       	jmp    80106cbb <alltraps>

8010747f <vector47>:
.globl vector47
vector47:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $47
80107481:	6a 2f                	push   $0x2f
  jmp alltraps
80107483:	e9 33 f8 ff ff       	jmp    80106cbb <alltraps>

80107488 <vector48>:
.globl vector48
vector48:
  pushl $0
80107488:	6a 00                	push   $0x0
  pushl $48
8010748a:	6a 30                	push   $0x30
  jmp alltraps
8010748c:	e9 2a f8 ff ff       	jmp    80106cbb <alltraps>

80107491 <vector49>:
.globl vector49
vector49:
  pushl $0
80107491:	6a 00                	push   $0x0
  pushl $49
80107493:	6a 31                	push   $0x31
  jmp alltraps
80107495:	e9 21 f8 ff ff       	jmp    80106cbb <alltraps>

8010749a <vector50>:
.globl vector50
vector50:
  pushl $0
8010749a:	6a 00                	push   $0x0
  pushl $50
8010749c:	6a 32                	push   $0x32
  jmp alltraps
8010749e:	e9 18 f8 ff ff       	jmp    80106cbb <alltraps>

801074a3 <vector51>:
.globl vector51
vector51:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $51
801074a5:	6a 33                	push   $0x33
  jmp alltraps
801074a7:	e9 0f f8 ff ff       	jmp    80106cbb <alltraps>

801074ac <vector52>:
.globl vector52
vector52:
  pushl $0
801074ac:	6a 00                	push   $0x0
  pushl $52
801074ae:	6a 34                	push   $0x34
  jmp alltraps
801074b0:	e9 06 f8 ff ff       	jmp    80106cbb <alltraps>

801074b5 <vector53>:
.globl vector53
vector53:
  pushl $0
801074b5:	6a 00                	push   $0x0
  pushl $53
801074b7:	6a 35                	push   $0x35
  jmp alltraps
801074b9:	e9 fd f7 ff ff       	jmp    80106cbb <alltraps>

801074be <vector54>:
.globl vector54
vector54:
  pushl $0
801074be:	6a 00                	push   $0x0
  pushl $54
801074c0:	6a 36                	push   $0x36
  jmp alltraps
801074c2:	e9 f4 f7 ff ff       	jmp    80106cbb <alltraps>

801074c7 <vector55>:
.globl vector55
vector55:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $55
801074c9:	6a 37                	push   $0x37
  jmp alltraps
801074cb:	e9 eb f7 ff ff       	jmp    80106cbb <alltraps>

801074d0 <vector56>:
.globl vector56
vector56:
  pushl $0
801074d0:	6a 00                	push   $0x0
  pushl $56
801074d2:	6a 38                	push   $0x38
  jmp alltraps
801074d4:	e9 e2 f7 ff ff       	jmp    80106cbb <alltraps>

801074d9 <vector57>:
.globl vector57
vector57:
  pushl $0
801074d9:	6a 00                	push   $0x0
  pushl $57
801074db:	6a 39                	push   $0x39
  jmp alltraps
801074dd:	e9 d9 f7 ff ff       	jmp    80106cbb <alltraps>

801074e2 <vector58>:
.globl vector58
vector58:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $58
801074e4:	6a 3a                	push   $0x3a
  jmp alltraps
801074e6:	e9 d0 f7 ff ff       	jmp    80106cbb <alltraps>

801074eb <vector59>:
.globl vector59
vector59:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $59
801074ed:	6a 3b                	push   $0x3b
  jmp alltraps
801074ef:	e9 c7 f7 ff ff       	jmp    80106cbb <alltraps>

801074f4 <vector60>:
.globl vector60
vector60:
  pushl $0
801074f4:	6a 00                	push   $0x0
  pushl $60
801074f6:	6a 3c                	push   $0x3c
  jmp alltraps
801074f8:	e9 be f7 ff ff       	jmp    80106cbb <alltraps>

801074fd <vector61>:
.globl vector61
vector61:
  pushl $0
801074fd:	6a 00                	push   $0x0
  pushl $61
801074ff:	6a 3d                	push   $0x3d
  jmp alltraps
80107501:	e9 b5 f7 ff ff       	jmp    80106cbb <alltraps>

80107506 <vector62>:
.globl vector62
vector62:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $62
80107508:	6a 3e                	push   $0x3e
  jmp alltraps
8010750a:	e9 ac f7 ff ff       	jmp    80106cbb <alltraps>

8010750f <vector63>:
.globl vector63
vector63:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $63
80107511:	6a 3f                	push   $0x3f
  jmp alltraps
80107513:	e9 a3 f7 ff ff       	jmp    80106cbb <alltraps>

80107518 <vector64>:
.globl vector64
vector64:
  pushl $0
80107518:	6a 00                	push   $0x0
  pushl $64
8010751a:	6a 40                	push   $0x40
  jmp alltraps
8010751c:	e9 9a f7 ff ff       	jmp    80106cbb <alltraps>

80107521 <vector65>:
.globl vector65
vector65:
  pushl $0
80107521:	6a 00                	push   $0x0
  pushl $65
80107523:	6a 41                	push   $0x41
  jmp alltraps
80107525:	e9 91 f7 ff ff       	jmp    80106cbb <alltraps>

8010752a <vector66>:
.globl vector66
vector66:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $66
8010752c:	6a 42                	push   $0x42
  jmp alltraps
8010752e:	e9 88 f7 ff ff       	jmp    80106cbb <alltraps>

80107533 <vector67>:
.globl vector67
vector67:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $67
80107535:	6a 43                	push   $0x43
  jmp alltraps
80107537:	e9 7f f7 ff ff       	jmp    80106cbb <alltraps>

8010753c <vector68>:
.globl vector68
vector68:
  pushl $0
8010753c:	6a 00                	push   $0x0
  pushl $68
8010753e:	6a 44                	push   $0x44
  jmp alltraps
80107540:	e9 76 f7 ff ff       	jmp    80106cbb <alltraps>

80107545 <vector69>:
.globl vector69
vector69:
  pushl $0
80107545:	6a 00                	push   $0x0
  pushl $69
80107547:	6a 45                	push   $0x45
  jmp alltraps
80107549:	e9 6d f7 ff ff       	jmp    80106cbb <alltraps>

8010754e <vector70>:
.globl vector70
vector70:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $70
80107550:	6a 46                	push   $0x46
  jmp alltraps
80107552:	e9 64 f7 ff ff       	jmp    80106cbb <alltraps>

80107557 <vector71>:
.globl vector71
vector71:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $71
80107559:	6a 47                	push   $0x47
  jmp alltraps
8010755b:	e9 5b f7 ff ff       	jmp    80106cbb <alltraps>

80107560 <vector72>:
.globl vector72
vector72:
  pushl $0
80107560:	6a 00                	push   $0x0
  pushl $72
80107562:	6a 48                	push   $0x48
  jmp alltraps
80107564:	e9 52 f7 ff ff       	jmp    80106cbb <alltraps>

80107569 <vector73>:
.globl vector73
vector73:
  pushl $0
80107569:	6a 00                	push   $0x0
  pushl $73
8010756b:	6a 49                	push   $0x49
  jmp alltraps
8010756d:	e9 49 f7 ff ff       	jmp    80106cbb <alltraps>

80107572 <vector74>:
.globl vector74
vector74:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $74
80107574:	6a 4a                	push   $0x4a
  jmp alltraps
80107576:	e9 40 f7 ff ff       	jmp    80106cbb <alltraps>

8010757b <vector75>:
.globl vector75
vector75:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $75
8010757d:	6a 4b                	push   $0x4b
  jmp alltraps
8010757f:	e9 37 f7 ff ff       	jmp    80106cbb <alltraps>

80107584 <vector76>:
.globl vector76
vector76:
  pushl $0
80107584:	6a 00                	push   $0x0
  pushl $76
80107586:	6a 4c                	push   $0x4c
  jmp alltraps
80107588:	e9 2e f7 ff ff       	jmp    80106cbb <alltraps>

8010758d <vector77>:
.globl vector77
vector77:
  pushl $0
8010758d:	6a 00                	push   $0x0
  pushl $77
8010758f:	6a 4d                	push   $0x4d
  jmp alltraps
80107591:	e9 25 f7 ff ff       	jmp    80106cbb <alltraps>

80107596 <vector78>:
.globl vector78
vector78:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $78
80107598:	6a 4e                	push   $0x4e
  jmp alltraps
8010759a:	e9 1c f7 ff ff       	jmp    80106cbb <alltraps>

8010759f <vector79>:
.globl vector79
vector79:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $79
801075a1:	6a 4f                	push   $0x4f
  jmp alltraps
801075a3:	e9 13 f7 ff ff       	jmp    80106cbb <alltraps>

801075a8 <vector80>:
.globl vector80
vector80:
  pushl $0
801075a8:	6a 00                	push   $0x0
  pushl $80
801075aa:	6a 50                	push   $0x50
  jmp alltraps
801075ac:	e9 0a f7 ff ff       	jmp    80106cbb <alltraps>

801075b1 <vector81>:
.globl vector81
vector81:
  pushl $0
801075b1:	6a 00                	push   $0x0
  pushl $81
801075b3:	6a 51                	push   $0x51
  jmp alltraps
801075b5:	e9 01 f7 ff ff       	jmp    80106cbb <alltraps>

801075ba <vector82>:
.globl vector82
vector82:
  pushl $0
801075ba:	6a 00                	push   $0x0
  pushl $82
801075bc:	6a 52                	push   $0x52
  jmp alltraps
801075be:	e9 f8 f6 ff ff       	jmp    80106cbb <alltraps>

801075c3 <vector83>:
.globl vector83
vector83:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $83
801075c5:	6a 53                	push   $0x53
  jmp alltraps
801075c7:	e9 ef f6 ff ff       	jmp    80106cbb <alltraps>

801075cc <vector84>:
.globl vector84
vector84:
  pushl $0
801075cc:	6a 00                	push   $0x0
  pushl $84
801075ce:	6a 54                	push   $0x54
  jmp alltraps
801075d0:	e9 e6 f6 ff ff       	jmp    80106cbb <alltraps>

801075d5 <vector85>:
.globl vector85
vector85:
  pushl $0
801075d5:	6a 00                	push   $0x0
  pushl $85
801075d7:	6a 55                	push   $0x55
  jmp alltraps
801075d9:	e9 dd f6 ff ff       	jmp    80106cbb <alltraps>

801075de <vector86>:
.globl vector86
vector86:
  pushl $0
801075de:	6a 00                	push   $0x0
  pushl $86
801075e0:	6a 56                	push   $0x56
  jmp alltraps
801075e2:	e9 d4 f6 ff ff       	jmp    80106cbb <alltraps>

801075e7 <vector87>:
.globl vector87
vector87:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $87
801075e9:	6a 57                	push   $0x57
  jmp alltraps
801075eb:	e9 cb f6 ff ff       	jmp    80106cbb <alltraps>

801075f0 <vector88>:
.globl vector88
vector88:
  pushl $0
801075f0:	6a 00                	push   $0x0
  pushl $88
801075f2:	6a 58                	push   $0x58
  jmp alltraps
801075f4:	e9 c2 f6 ff ff       	jmp    80106cbb <alltraps>

801075f9 <vector89>:
.globl vector89
vector89:
  pushl $0
801075f9:	6a 00                	push   $0x0
  pushl $89
801075fb:	6a 59                	push   $0x59
  jmp alltraps
801075fd:	e9 b9 f6 ff ff       	jmp    80106cbb <alltraps>

80107602 <vector90>:
.globl vector90
vector90:
  pushl $0
80107602:	6a 00                	push   $0x0
  pushl $90
80107604:	6a 5a                	push   $0x5a
  jmp alltraps
80107606:	e9 b0 f6 ff ff       	jmp    80106cbb <alltraps>

8010760b <vector91>:
.globl vector91
vector91:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $91
8010760d:	6a 5b                	push   $0x5b
  jmp alltraps
8010760f:	e9 a7 f6 ff ff       	jmp    80106cbb <alltraps>

80107614 <vector92>:
.globl vector92
vector92:
  pushl $0
80107614:	6a 00                	push   $0x0
  pushl $92
80107616:	6a 5c                	push   $0x5c
  jmp alltraps
80107618:	e9 9e f6 ff ff       	jmp    80106cbb <alltraps>

8010761d <vector93>:
.globl vector93
vector93:
  pushl $0
8010761d:	6a 00                	push   $0x0
  pushl $93
8010761f:	6a 5d                	push   $0x5d
  jmp alltraps
80107621:	e9 95 f6 ff ff       	jmp    80106cbb <alltraps>

80107626 <vector94>:
.globl vector94
vector94:
  pushl $0
80107626:	6a 00                	push   $0x0
  pushl $94
80107628:	6a 5e                	push   $0x5e
  jmp alltraps
8010762a:	e9 8c f6 ff ff       	jmp    80106cbb <alltraps>

8010762f <vector95>:
.globl vector95
vector95:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $95
80107631:	6a 5f                	push   $0x5f
  jmp alltraps
80107633:	e9 83 f6 ff ff       	jmp    80106cbb <alltraps>

80107638 <vector96>:
.globl vector96
vector96:
  pushl $0
80107638:	6a 00                	push   $0x0
  pushl $96
8010763a:	6a 60                	push   $0x60
  jmp alltraps
8010763c:	e9 7a f6 ff ff       	jmp    80106cbb <alltraps>

80107641 <vector97>:
.globl vector97
vector97:
  pushl $0
80107641:	6a 00                	push   $0x0
  pushl $97
80107643:	6a 61                	push   $0x61
  jmp alltraps
80107645:	e9 71 f6 ff ff       	jmp    80106cbb <alltraps>

8010764a <vector98>:
.globl vector98
vector98:
  pushl $0
8010764a:	6a 00                	push   $0x0
  pushl $98
8010764c:	6a 62                	push   $0x62
  jmp alltraps
8010764e:	e9 68 f6 ff ff       	jmp    80106cbb <alltraps>

80107653 <vector99>:
.globl vector99
vector99:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $99
80107655:	6a 63                	push   $0x63
  jmp alltraps
80107657:	e9 5f f6 ff ff       	jmp    80106cbb <alltraps>

8010765c <vector100>:
.globl vector100
vector100:
  pushl $0
8010765c:	6a 00                	push   $0x0
  pushl $100
8010765e:	6a 64                	push   $0x64
  jmp alltraps
80107660:	e9 56 f6 ff ff       	jmp    80106cbb <alltraps>

80107665 <vector101>:
.globl vector101
vector101:
  pushl $0
80107665:	6a 00                	push   $0x0
  pushl $101
80107667:	6a 65                	push   $0x65
  jmp alltraps
80107669:	e9 4d f6 ff ff       	jmp    80106cbb <alltraps>

8010766e <vector102>:
.globl vector102
vector102:
  pushl $0
8010766e:	6a 00                	push   $0x0
  pushl $102
80107670:	6a 66                	push   $0x66
  jmp alltraps
80107672:	e9 44 f6 ff ff       	jmp    80106cbb <alltraps>

80107677 <vector103>:
.globl vector103
vector103:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $103
80107679:	6a 67                	push   $0x67
  jmp alltraps
8010767b:	e9 3b f6 ff ff       	jmp    80106cbb <alltraps>

80107680 <vector104>:
.globl vector104
vector104:
  pushl $0
80107680:	6a 00                	push   $0x0
  pushl $104
80107682:	6a 68                	push   $0x68
  jmp alltraps
80107684:	e9 32 f6 ff ff       	jmp    80106cbb <alltraps>

80107689 <vector105>:
.globl vector105
vector105:
  pushl $0
80107689:	6a 00                	push   $0x0
  pushl $105
8010768b:	6a 69                	push   $0x69
  jmp alltraps
8010768d:	e9 29 f6 ff ff       	jmp    80106cbb <alltraps>

80107692 <vector106>:
.globl vector106
vector106:
  pushl $0
80107692:	6a 00                	push   $0x0
  pushl $106
80107694:	6a 6a                	push   $0x6a
  jmp alltraps
80107696:	e9 20 f6 ff ff       	jmp    80106cbb <alltraps>

8010769b <vector107>:
.globl vector107
vector107:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $107
8010769d:	6a 6b                	push   $0x6b
  jmp alltraps
8010769f:	e9 17 f6 ff ff       	jmp    80106cbb <alltraps>

801076a4 <vector108>:
.globl vector108
vector108:
  pushl $0
801076a4:	6a 00                	push   $0x0
  pushl $108
801076a6:	6a 6c                	push   $0x6c
  jmp alltraps
801076a8:	e9 0e f6 ff ff       	jmp    80106cbb <alltraps>

801076ad <vector109>:
.globl vector109
vector109:
  pushl $0
801076ad:	6a 00                	push   $0x0
  pushl $109
801076af:	6a 6d                	push   $0x6d
  jmp alltraps
801076b1:	e9 05 f6 ff ff       	jmp    80106cbb <alltraps>

801076b6 <vector110>:
.globl vector110
vector110:
  pushl $0
801076b6:	6a 00                	push   $0x0
  pushl $110
801076b8:	6a 6e                	push   $0x6e
  jmp alltraps
801076ba:	e9 fc f5 ff ff       	jmp    80106cbb <alltraps>

801076bf <vector111>:
.globl vector111
vector111:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $111
801076c1:	6a 6f                	push   $0x6f
  jmp alltraps
801076c3:	e9 f3 f5 ff ff       	jmp    80106cbb <alltraps>

801076c8 <vector112>:
.globl vector112
vector112:
  pushl $0
801076c8:	6a 00                	push   $0x0
  pushl $112
801076ca:	6a 70                	push   $0x70
  jmp alltraps
801076cc:	e9 ea f5 ff ff       	jmp    80106cbb <alltraps>

801076d1 <vector113>:
.globl vector113
vector113:
  pushl $0
801076d1:	6a 00                	push   $0x0
  pushl $113
801076d3:	6a 71                	push   $0x71
  jmp alltraps
801076d5:	e9 e1 f5 ff ff       	jmp    80106cbb <alltraps>

801076da <vector114>:
.globl vector114
vector114:
  pushl $0
801076da:	6a 00                	push   $0x0
  pushl $114
801076dc:	6a 72                	push   $0x72
  jmp alltraps
801076de:	e9 d8 f5 ff ff       	jmp    80106cbb <alltraps>

801076e3 <vector115>:
.globl vector115
vector115:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $115
801076e5:	6a 73                	push   $0x73
  jmp alltraps
801076e7:	e9 cf f5 ff ff       	jmp    80106cbb <alltraps>

801076ec <vector116>:
.globl vector116
vector116:
  pushl $0
801076ec:	6a 00                	push   $0x0
  pushl $116
801076ee:	6a 74                	push   $0x74
  jmp alltraps
801076f0:	e9 c6 f5 ff ff       	jmp    80106cbb <alltraps>

801076f5 <vector117>:
.globl vector117
vector117:
  pushl $0
801076f5:	6a 00                	push   $0x0
  pushl $117
801076f7:	6a 75                	push   $0x75
  jmp alltraps
801076f9:	e9 bd f5 ff ff       	jmp    80106cbb <alltraps>

801076fe <vector118>:
.globl vector118
vector118:
  pushl $0
801076fe:	6a 00                	push   $0x0
  pushl $118
80107700:	6a 76                	push   $0x76
  jmp alltraps
80107702:	e9 b4 f5 ff ff       	jmp    80106cbb <alltraps>

80107707 <vector119>:
.globl vector119
vector119:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $119
80107709:	6a 77                	push   $0x77
  jmp alltraps
8010770b:	e9 ab f5 ff ff       	jmp    80106cbb <alltraps>

80107710 <vector120>:
.globl vector120
vector120:
  pushl $0
80107710:	6a 00                	push   $0x0
  pushl $120
80107712:	6a 78                	push   $0x78
  jmp alltraps
80107714:	e9 a2 f5 ff ff       	jmp    80106cbb <alltraps>

80107719 <vector121>:
.globl vector121
vector121:
  pushl $0
80107719:	6a 00                	push   $0x0
  pushl $121
8010771b:	6a 79                	push   $0x79
  jmp alltraps
8010771d:	e9 99 f5 ff ff       	jmp    80106cbb <alltraps>

80107722 <vector122>:
.globl vector122
vector122:
  pushl $0
80107722:	6a 00                	push   $0x0
  pushl $122
80107724:	6a 7a                	push   $0x7a
  jmp alltraps
80107726:	e9 90 f5 ff ff       	jmp    80106cbb <alltraps>

8010772b <vector123>:
.globl vector123
vector123:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $123
8010772d:	6a 7b                	push   $0x7b
  jmp alltraps
8010772f:	e9 87 f5 ff ff       	jmp    80106cbb <alltraps>

80107734 <vector124>:
.globl vector124
vector124:
  pushl $0
80107734:	6a 00                	push   $0x0
  pushl $124
80107736:	6a 7c                	push   $0x7c
  jmp alltraps
80107738:	e9 7e f5 ff ff       	jmp    80106cbb <alltraps>

8010773d <vector125>:
.globl vector125
vector125:
  pushl $0
8010773d:	6a 00                	push   $0x0
  pushl $125
8010773f:	6a 7d                	push   $0x7d
  jmp alltraps
80107741:	e9 75 f5 ff ff       	jmp    80106cbb <alltraps>

80107746 <vector126>:
.globl vector126
vector126:
  pushl $0
80107746:	6a 00                	push   $0x0
  pushl $126
80107748:	6a 7e                	push   $0x7e
  jmp alltraps
8010774a:	e9 6c f5 ff ff       	jmp    80106cbb <alltraps>

8010774f <vector127>:
.globl vector127
vector127:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $127
80107751:	6a 7f                	push   $0x7f
  jmp alltraps
80107753:	e9 63 f5 ff ff       	jmp    80106cbb <alltraps>

80107758 <vector128>:
.globl vector128
vector128:
  pushl $0
80107758:	6a 00                	push   $0x0
  pushl $128
8010775a:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010775f:	e9 57 f5 ff ff       	jmp    80106cbb <alltraps>

80107764 <vector129>:
.globl vector129
vector129:
  pushl $0
80107764:	6a 00                	push   $0x0
  pushl $129
80107766:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010776b:	e9 4b f5 ff ff       	jmp    80106cbb <alltraps>

80107770 <vector130>:
.globl vector130
vector130:
  pushl $0
80107770:	6a 00                	push   $0x0
  pushl $130
80107772:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107777:	e9 3f f5 ff ff       	jmp    80106cbb <alltraps>

8010777c <vector131>:
.globl vector131
vector131:
  pushl $0
8010777c:	6a 00                	push   $0x0
  pushl $131
8010777e:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107783:	e9 33 f5 ff ff       	jmp    80106cbb <alltraps>

80107788 <vector132>:
.globl vector132
vector132:
  pushl $0
80107788:	6a 00                	push   $0x0
  pushl $132
8010778a:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010778f:	e9 27 f5 ff ff       	jmp    80106cbb <alltraps>

80107794 <vector133>:
.globl vector133
vector133:
  pushl $0
80107794:	6a 00                	push   $0x0
  pushl $133
80107796:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010779b:	e9 1b f5 ff ff       	jmp    80106cbb <alltraps>

801077a0 <vector134>:
.globl vector134
vector134:
  pushl $0
801077a0:	6a 00                	push   $0x0
  pushl $134
801077a2:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801077a7:	e9 0f f5 ff ff       	jmp    80106cbb <alltraps>

801077ac <vector135>:
.globl vector135
vector135:
  pushl $0
801077ac:	6a 00                	push   $0x0
  pushl $135
801077ae:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801077b3:	e9 03 f5 ff ff       	jmp    80106cbb <alltraps>

801077b8 <vector136>:
.globl vector136
vector136:
  pushl $0
801077b8:	6a 00                	push   $0x0
  pushl $136
801077ba:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801077bf:	e9 f7 f4 ff ff       	jmp    80106cbb <alltraps>

801077c4 <vector137>:
.globl vector137
vector137:
  pushl $0
801077c4:	6a 00                	push   $0x0
  pushl $137
801077c6:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801077cb:	e9 eb f4 ff ff       	jmp    80106cbb <alltraps>

801077d0 <vector138>:
.globl vector138
vector138:
  pushl $0
801077d0:	6a 00                	push   $0x0
  pushl $138
801077d2:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801077d7:	e9 df f4 ff ff       	jmp    80106cbb <alltraps>

801077dc <vector139>:
.globl vector139
vector139:
  pushl $0
801077dc:	6a 00                	push   $0x0
  pushl $139
801077de:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801077e3:	e9 d3 f4 ff ff       	jmp    80106cbb <alltraps>

801077e8 <vector140>:
.globl vector140
vector140:
  pushl $0
801077e8:	6a 00                	push   $0x0
  pushl $140
801077ea:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801077ef:	e9 c7 f4 ff ff       	jmp    80106cbb <alltraps>

801077f4 <vector141>:
.globl vector141
vector141:
  pushl $0
801077f4:	6a 00                	push   $0x0
  pushl $141
801077f6:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801077fb:	e9 bb f4 ff ff       	jmp    80106cbb <alltraps>

80107800 <vector142>:
.globl vector142
vector142:
  pushl $0
80107800:	6a 00                	push   $0x0
  pushl $142
80107802:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107807:	e9 af f4 ff ff       	jmp    80106cbb <alltraps>

8010780c <vector143>:
.globl vector143
vector143:
  pushl $0
8010780c:	6a 00                	push   $0x0
  pushl $143
8010780e:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107813:	e9 a3 f4 ff ff       	jmp    80106cbb <alltraps>

80107818 <vector144>:
.globl vector144
vector144:
  pushl $0
80107818:	6a 00                	push   $0x0
  pushl $144
8010781a:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010781f:	e9 97 f4 ff ff       	jmp    80106cbb <alltraps>

80107824 <vector145>:
.globl vector145
vector145:
  pushl $0
80107824:	6a 00                	push   $0x0
  pushl $145
80107826:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010782b:	e9 8b f4 ff ff       	jmp    80106cbb <alltraps>

80107830 <vector146>:
.globl vector146
vector146:
  pushl $0
80107830:	6a 00                	push   $0x0
  pushl $146
80107832:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107837:	e9 7f f4 ff ff       	jmp    80106cbb <alltraps>

8010783c <vector147>:
.globl vector147
vector147:
  pushl $0
8010783c:	6a 00                	push   $0x0
  pushl $147
8010783e:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107843:	e9 73 f4 ff ff       	jmp    80106cbb <alltraps>

80107848 <vector148>:
.globl vector148
vector148:
  pushl $0
80107848:	6a 00                	push   $0x0
  pushl $148
8010784a:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010784f:	e9 67 f4 ff ff       	jmp    80106cbb <alltraps>

80107854 <vector149>:
.globl vector149
vector149:
  pushl $0
80107854:	6a 00                	push   $0x0
  pushl $149
80107856:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010785b:	e9 5b f4 ff ff       	jmp    80106cbb <alltraps>

80107860 <vector150>:
.globl vector150
vector150:
  pushl $0
80107860:	6a 00                	push   $0x0
  pushl $150
80107862:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107867:	e9 4f f4 ff ff       	jmp    80106cbb <alltraps>

8010786c <vector151>:
.globl vector151
vector151:
  pushl $0
8010786c:	6a 00                	push   $0x0
  pushl $151
8010786e:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107873:	e9 43 f4 ff ff       	jmp    80106cbb <alltraps>

80107878 <vector152>:
.globl vector152
vector152:
  pushl $0
80107878:	6a 00                	push   $0x0
  pushl $152
8010787a:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010787f:	e9 37 f4 ff ff       	jmp    80106cbb <alltraps>

80107884 <vector153>:
.globl vector153
vector153:
  pushl $0
80107884:	6a 00                	push   $0x0
  pushl $153
80107886:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010788b:	e9 2b f4 ff ff       	jmp    80106cbb <alltraps>

80107890 <vector154>:
.globl vector154
vector154:
  pushl $0
80107890:	6a 00                	push   $0x0
  pushl $154
80107892:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107897:	e9 1f f4 ff ff       	jmp    80106cbb <alltraps>

8010789c <vector155>:
.globl vector155
vector155:
  pushl $0
8010789c:	6a 00                	push   $0x0
  pushl $155
8010789e:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801078a3:	e9 13 f4 ff ff       	jmp    80106cbb <alltraps>

801078a8 <vector156>:
.globl vector156
vector156:
  pushl $0
801078a8:	6a 00                	push   $0x0
  pushl $156
801078aa:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801078af:	e9 07 f4 ff ff       	jmp    80106cbb <alltraps>

801078b4 <vector157>:
.globl vector157
vector157:
  pushl $0
801078b4:	6a 00                	push   $0x0
  pushl $157
801078b6:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801078bb:	e9 fb f3 ff ff       	jmp    80106cbb <alltraps>

801078c0 <vector158>:
.globl vector158
vector158:
  pushl $0
801078c0:	6a 00                	push   $0x0
  pushl $158
801078c2:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801078c7:	e9 ef f3 ff ff       	jmp    80106cbb <alltraps>

801078cc <vector159>:
.globl vector159
vector159:
  pushl $0
801078cc:	6a 00                	push   $0x0
  pushl $159
801078ce:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801078d3:	e9 e3 f3 ff ff       	jmp    80106cbb <alltraps>

801078d8 <vector160>:
.globl vector160
vector160:
  pushl $0
801078d8:	6a 00                	push   $0x0
  pushl $160
801078da:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801078df:	e9 d7 f3 ff ff       	jmp    80106cbb <alltraps>

801078e4 <vector161>:
.globl vector161
vector161:
  pushl $0
801078e4:	6a 00                	push   $0x0
  pushl $161
801078e6:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801078eb:	e9 cb f3 ff ff       	jmp    80106cbb <alltraps>

801078f0 <vector162>:
.globl vector162
vector162:
  pushl $0
801078f0:	6a 00                	push   $0x0
  pushl $162
801078f2:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801078f7:	e9 bf f3 ff ff       	jmp    80106cbb <alltraps>

801078fc <vector163>:
.globl vector163
vector163:
  pushl $0
801078fc:	6a 00                	push   $0x0
  pushl $163
801078fe:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107903:	e9 b3 f3 ff ff       	jmp    80106cbb <alltraps>

80107908 <vector164>:
.globl vector164
vector164:
  pushl $0
80107908:	6a 00                	push   $0x0
  pushl $164
8010790a:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010790f:	e9 a7 f3 ff ff       	jmp    80106cbb <alltraps>

80107914 <vector165>:
.globl vector165
vector165:
  pushl $0
80107914:	6a 00                	push   $0x0
  pushl $165
80107916:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010791b:	e9 9b f3 ff ff       	jmp    80106cbb <alltraps>

80107920 <vector166>:
.globl vector166
vector166:
  pushl $0
80107920:	6a 00                	push   $0x0
  pushl $166
80107922:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107927:	e9 8f f3 ff ff       	jmp    80106cbb <alltraps>

8010792c <vector167>:
.globl vector167
vector167:
  pushl $0
8010792c:	6a 00                	push   $0x0
  pushl $167
8010792e:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107933:	e9 83 f3 ff ff       	jmp    80106cbb <alltraps>

80107938 <vector168>:
.globl vector168
vector168:
  pushl $0
80107938:	6a 00                	push   $0x0
  pushl $168
8010793a:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010793f:	e9 77 f3 ff ff       	jmp    80106cbb <alltraps>

80107944 <vector169>:
.globl vector169
vector169:
  pushl $0
80107944:	6a 00                	push   $0x0
  pushl $169
80107946:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010794b:	e9 6b f3 ff ff       	jmp    80106cbb <alltraps>

80107950 <vector170>:
.globl vector170
vector170:
  pushl $0
80107950:	6a 00                	push   $0x0
  pushl $170
80107952:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107957:	e9 5f f3 ff ff       	jmp    80106cbb <alltraps>

8010795c <vector171>:
.globl vector171
vector171:
  pushl $0
8010795c:	6a 00                	push   $0x0
  pushl $171
8010795e:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107963:	e9 53 f3 ff ff       	jmp    80106cbb <alltraps>

80107968 <vector172>:
.globl vector172
vector172:
  pushl $0
80107968:	6a 00                	push   $0x0
  pushl $172
8010796a:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010796f:	e9 47 f3 ff ff       	jmp    80106cbb <alltraps>

80107974 <vector173>:
.globl vector173
vector173:
  pushl $0
80107974:	6a 00                	push   $0x0
  pushl $173
80107976:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010797b:	e9 3b f3 ff ff       	jmp    80106cbb <alltraps>

80107980 <vector174>:
.globl vector174
vector174:
  pushl $0
80107980:	6a 00                	push   $0x0
  pushl $174
80107982:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107987:	e9 2f f3 ff ff       	jmp    80106cbb <alltraps>

8010798c <vector175>:
.globl vector175
vector175:
  pushl $0
8010798c:	6a 00                	push   $0x0
  pushl $175
8010798e:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107993:	e9 23 f3 ff ff       	jmp    80106cbb <alltraps>

80107998 <vector176>:
.globl vector176
vector176:
  pushl $0
80107998:	6a 00                	push   $0x0
  pushl $176
8010799a:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010799f:	e9 17 f3 ff ff       	jmp    80106cbb <alltraps>

801079a4 <vector177>:
.globl vector177
vector177:
  pushl $0
801079a4:	6a 00                	push   $0x0
  pushl $177
801079a6:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801079ab:	e9 0b f3 ff ff       	jmp    80106cbb <alltraps>

801079b0 <vector178>:
.globl vector178
vector178:
  pushl $0
801079b0:	6a 00                	push   $0x0
  pushl $178
801079b2:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801079b7:	e9 ff f2 ff ff       	jmp    80106cbb <alltraps>

801079bc <vector179>:
.globl vector179
vector179:
  pushl $0
801079bc:	6a 00                	push   $0x0
  pushl $179
801079be:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801079c3:	e9 f3 f2 ff ff       	jmp    80106cbb <alltraps>

801079c8 <vector180>:
.globl vector180
vector180:
  pushl $0
801079c8:	6a 00                	push   $0x0
  pushl $180
801079ca:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801079cf:	e9 e7 f2 ff ff       	jmp    80106cbb <alltraps>

801079d4 <vector181>:
.globl vector181
vector181:
  pushl $0
801079d4:	6a 00                	push   $0x0
  pushl $181
801079d6:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801079db:	e9 db f2 ff ff       	jmp    80106cbb <alltraps>

801079e0 <vector182>:
.globl vector182
vector182:
  pushl $0
801079e0:	6a 00                	push   $0x0
  pushl $182
801079e2:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801079e7:	e9 cf f2 ff ff       	jmp    80106cbb <alltraps>

801079ec <vector183>:
.globl vector183
vector183:
  pushl $0
801079ec:	6a 00                	push   $0x0
  pushl $183
801079ee:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801079f3:	e9 c3 f2 ff ff       	jmp    80106cbb <alltraps>

801079f8 <vector184>:
.globl vector184
vector184:
  pushl $0
801079f8:	6a 00                	push   $0x0
  pushl $184
801079fa:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801079ff:	e9 b7 f2 ff ff       	jmp    80106cbb <alltraps>

80107a04 <vector185>:
.globl vector185
vector185:
  pushl $0
80107a04:	6a 00                	push   $0x0
  pushl $185
80107a06:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107a0b:	e9 ab f2 ff ff       	jmp    80106cbb <alltraps>

80107a10 <vector186>:
.globl vector186
vector186:
  pushl $0
80107a10:	6a 00                	push   $0x0
  pushl $186
80107a12:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107a17:	e9 9f f2 ff ff       	jmp    80106cbb <alltraps>

80107a1c <vector187>:
.globl vector187
vector187:
  pushl $0
80107a1c:	6a 00                	push   $0x0
  pushl $187
80107a1e:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107a23:	e9 93 f2 ff ff       	jmp    80106cbb <alltraps>

80107a28 <vector188>:
.globl vector188
vector188:
  pushl $0
80107a28:	6a 00                	push   $0x0
  pushl $188
80107a2a:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107a2f:	e9 87 f2 ff ff       	jmp    80106cbb <alltraps>

80107a34 <vector189>:
.globl vector189
vector189:
  pushl $0
80107a34:	6a 00                	push   $0x0
  pushl $189
80107a36:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107a3b:	e9 7b f2 ff ff       	jmp    80106cbb <alltraps>

80107a40 <vector190>:
.globl vector190
vector190:
  pushl $0
80107a40:	6a 00                	push   $0x0
  pushl $190
80107a42:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107a47:	e9 6f f2 ff ff       	jmp    80106cbb <alltraps>

80107a4c <vector191>:
.globl vector191
vector191:
  pushl $0
80107a4c:	6a 00                	push   $0x0
  pushl $191
80107a4e:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107a53:	e9 63 f2 ff ff       	jmp    80106cbb <alltraps>

80107a58 <vector192>:
.globl vector192
vector192:
  pushl $0
80107a58:	6a 00                	push   $0x0
  pushl $192
80107a5a:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107a5f:	e9 57 f2 ff ff       	jmp    80106cbb <alltraps>

80107a64 <vector193>:
.globl vector193
vector193:
  pushl $0
80107a64:	6a 00                	push   $0x0
  pushl $193
80107a66:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107a6b:	e9 4b f2 ff ff       	jmp    80106cbb <alltraps>

80107a70 <vector194>:
.globl vector194
vector194:
  pushl $0
80107a70:	6a 00                	push   $0x0
  pushl $194
80107a72:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107a77:	e9 3f f2 ff ff       	jmp    80106cbb <alltraps>

80107a7c <vector195>:
.globl vector195
vector195:
  pushl $0
80107a7c:	6a 00                	push   $0x0
  pushl $195
80107a7e:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107a83:	e9 33 f2 ff ff       	jmp    80106cbb <alltraps>

80107a88 <vector196>:
.globl vector196
vector196:
  pushl $0
80107a88:	6a 00                	push   $0x0
  pushl $196
80107a8a:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107a8f:	e9 27 f2 ff ff       	jmp    80106cbb <alltraps>

80107a94 <vector197>:
.globl vector197
vector197:
  pushl $0
80107a94:	6a 00                	push   $0x0
  pushl $197
80107a96:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107a9b:	e9 1b f2 ff ff       	jmp    80106cbb <alltraps>

80107aa0 <vector198>:
.globl vector198
vector198:
  pushl $0
80107aa0:	6a 00                	push   $0x0
  pushl $198
80107aa2:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107aa7:	e9 0f f2 ff ff       	jmp    80106cbb <alltraps>

80107aac <vector199>:
.globl vector199
vector199:
  pushl $0
80107aac:	6a 00                	push   $0x0
  pushl $199
80107aae:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107ab3:	e9 03 f2 ff ff       	jmp    80106cbb <alltraps>

80107ab8 <vector200>:
.globl vector200
vector200:
  pushl $0
80107ab8:	6a 00                	push   $0x0
  pushl $200
80107aba:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107abf:	e9 f7 f1 ff ff       	jmp    80106cbb <alltraps>

80107ac4 <vector201>:
.globl vector201
vector201:
  pushl $0
80107ac4:	6a 00                	push   $0x0
  pushl $201
80107ac6:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107acb:	e9 eb f1 ff ff       	jmp    80106cbb <alltraps>

80107ad0 <vector202>:
.globl vector202
vector202:
  pushl $0
80107ad0:	6a 00                	push   $0x0
  pushl $202
80107ad2:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107ad7:	e9 df f1 ff ff       	jmp    80106cbb <alltraps>

80107adc <vector203>:
.globl vector203
vector203:
  pushl $0
80107adc:	6a 00                	push   $0x0
  pushl $203
80107ade:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107ae3:	e9 d3 f1 ff ff       	jmp    80106cbb <alltraps>

80107ae8 <vector204>:
.globl vector204
vector204:
  pushl $0
80107ae8:	6a 00                	push   $0x0
  pushl $204
80107aea:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107aef:	e9 c7 f1 ff ff       	jmp    80106cbb <alltraps>

80107af4 <vector205>:
.globl vector205
vector205:
  pushl $0
80107af4:	6a 00                	push   $0x0
  pushl $205
80107af6:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107afb:	e9 bb f1 ff ff       	jmp    80106cbb <alltraps>

80107b00 <vector206>:
.globl vector206
vector206:
  pushl $0
80107b00:	6a 00                	push   $0x0
  pushl $206
80107b02:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107b07:	e9 af f1 ff ff       	jmp    80106cbb <alltraps>

80107b0c <vector207>:
.globl vector207
vector207:
  pushl $0
80107b0c:	6a 00                	push   $0x0
  pushl $207
80107b0e:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107b13:	e9 a3 f1 ff ff       	jmp    80106cbb <alltraps>

80107b18 <vector208>:
.globl vector208
vector208:
  pushl $0
80107b18:	6a 00                	push   $0x0
  pushl $208
80107b1a:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107b1f:	e9 97 f1 ff ff       	jmp    80106cbb <alltraps>

80107b24 <vector209>:
.globl vector209
vector209:
  pushl $0
80107b24:	6a 00                	push   $0x0
  pushl $209
80107b26:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107b2b:	e9 8b f1 ff ff       	jmp    80106cbb <alltraps>

80107b30 <vector210>:
.globl vector210
vector210:
  pushl $0
80107b30:	6a 00                	push   $0x0
  pushl $210
80107b32:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107b37:	e9 7f f1 ff ff       	jmp    80106cbb <alltraps>

80107b3c <vector211>:
.globl vector211
vector211:
  pushl $0
80107b3c:	6a 00                	push   $0x0
  pushl $211
80107b3e:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107b43:	e9 73 f1 ff ff       	jmp    80106cbb <alltraps>

80107b48 <vector212>:
.globl vector212
vector212:
  pushl $0
80107b48:	6a 00                	push   $0x0
  pushl $212
80107b4a:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107b4f:	e9 67 f1 ff ff       	jmp    80106cbb <alltraps>

80107b54 <vector213>:
.globl vector213
vector213:
  pushl $0
80107b54:	6a 00                	push   $0x0
  pushl $213
80107b56:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107b5b:	e9 5b f1 ff ff       	jmp    80106cbb <alltraps>

80107b60 <vector214>:
.globl vector214
vector214:
  pushl $0
80107b60:	6a 00                	push   $0x0
  pushl $214
80107b62:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107b67:	e9 4f f1 ff ff       	jmp    80106cbb <alltraps>

80107b6c <vector215>:
.globl vector215
vector215:
  pushl $0
80107b6c:	6a 00                	push   $0x0
  pushl $215
80107b6e:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107b73:	e9 43 f1 ff ff       	jmp    80106cbb <alltraps>

80107b78 <vector216>:
.globl vector216
vector216:
  pushl $0
80107b78:	6a 00                	push   $0x0
  pushl $216
80107b7a:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107b7f:	e9 37 f1 ff ff       	jmp    80106cbb <alltraps>

80107b84 <vector217>:
.globl vector217
vector217:
  pushl $0
80107b84:	6a 00                	push   $0x0
  pushl $217
80107b86:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107b8b:	e9 2b f1 ff ff       	jmp    80106cbb <alltraps>

80107b90 <vector218>:
.globl vector218
vector218:
  pushl $0
80107b90:	6a 00                	push   $0x0
  pushl $218
80107b92:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107b97:	e9 1f f1 ff ff       	jmp    80106cbb <alltraps>

80107b9c <vector219>:
.globl vector219
vector219:
  pushl $0
80107b9c:	6a 00                	push   $0x0
  pushl $219
80107b9e:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107ba3:	e9 13 f1 ff ff       	jmp    80106cbb <alltraps>

80107ba8 <vector220>:
.globl vector220
vector220:
  pushl $0
80107ba8:	6a 00                	push   $0x0
  pushl $220
80107baa:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107baf:	e9 07 f1 ff ff       	jmp    80106cbb <alltraps>

80107bb4 <vector221>:
.globl vector221
vector221:
  pushl $0
80107bb4:	6a 00                	push   $0x0
  pushl $221
80107bb6:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107bbb:	e9 fb f0 ff ff       	jmp    80106cbb <alltraps>

80107bc0 <vector222>:
.globl vector222
vector222:
  pushl $0
80107bc0:	6a 00                	push   $0x0
  pushl $222
80107bc2:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107bc7:	e9 ef f0 ff ff       	jmp    80106cbb <alltraps>

80107bcc <vector223>:
.globl vector223
vector223:
  pushl $0
80107bcc:	6a 00                	push   $0x0
  pushl $223
80107bce:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107bd3:	e9 e3 f0 ff ff       	jmp    80106cbb <alltraps>

80107bd8 <vector224>:
.globl vector224
vector224:
  pushl $0
80107bd8:	6a 00                	push   $0x0
  pushl $224
80107bda:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107bdf:	e9 d7 f0 ff ff       	jmp    80106cbb <alltraps>

80107be4 <vector225>:
.globl vector225
vector225:
  pushl $0
80107be4:	6a 00                	push   $0x0
  pushl $225
80107be6:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107beb:	e9 cb f0 ff ff       	jmp    80106cbb <alltraps>

80107bf0 <vector226>:
.globl vector226
vector226:
  pushl $0
80107bf0:	6a 00                	push   $0x0
  pushl $226
80107bf2:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107bf7:	e9 bf f0 ff ff       	jmp    80106cbb <alltraps>

80107bfc <vector227>:
.globl vector227
vector227:
  pushl $0
80107bfc:	6a 00                	push   $0x0
  pushl $227
80107bfe:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107c03:	e9 b3 f0 ff ff       	jmp    80106cbb <alltraps>

80107c08 <vector228>:
.globl vector228
vector228:
  pushl $0
80107c08:	6a 00                	push   $0x0
  pushl $228
80107c0a:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107c0f:	e9 a7 f0 ff ff       	jmp    80106cbb <alltraps>

80107c14 <vector229>:
.globl vector229
vector229:
  pushl $0
80107c14:	6a 00                	push   $0x0
  pushl $229
80107c16:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107c1b:	e9 9b f0 ff ff       	jmp    80106cbb <alltraps>

80107c20 <vector230>:
.globl vector230
vector230:
  pushl $0
80107c20:	6a 00                	push   $0x0
  pushl $230
80107c22:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107c27:	e9 8f f0 ff ff       	jmp    80106cbb <alltraps>

80107c2c <vector231>:
.globl vector231
vector231:
  pushl $0
80107c2c:	6a 00                	push   $0x0
  pushl $231
80107c2e:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107c33:	e9 83 f0 ff ff       	jmp    80106cbb <alltraps>

80107c38 <vector232>:
.globl vector232
vector232:
  pushl $0
80107c38:	6a 00                	push   $0x0
  pushl $232
80107c3a:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107c3f:	e9 77 f0 ff ff       	jmp    80106cbb <alltraps>

80107c44 <vector233>:
.globl vector233
vector233:
  pushl $0
80107c44:	6a 00                	push   $0x0
  pushl $233
80107c46:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107c4b:	e9 6b f0 ff ff       	jmp    80106cbb <alltraps>

80107c50 <vector234>:
.globl vector234
vector234:
  pushl $0
80107c50:	6a 00                	push   $0x0
  pushl $234
80107c52:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107c57:	e9 5f f0 ff ff       	jmp    80106cbb <alltraps>

80107c5c <vector235>:
.globl vector235
vector235:
  pushl $0
80107c5c:	6a 00                	push   $0x0
  pushl $235
80107c5e:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107c63:	e9 53 f0 ff ff       	jmp    80106cbb <alltraps>

80107c68 <vector236>:
.globl vector236
vector236:
  pushl $0
80107c68:	6a 00                	push   $0x0
  pushl $236
80107c6a:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107c6f:	e9 47 f0 ff ff       	jmp    80106cbb <alltraps>

80107c74 <vector237>:
.globl vector237
vector237:
  pushl $0
80107c74:	6a 00                	push   $0x0
  pushl $237
80107c76:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107c7b:	e9 3b f0 ff ff       	jmp    80106cbb <alltraps>

80107c80 <vector238>:
.globl vector238
vector238:
  pushl $0
80107c80:	6a 00                	push   $0x0
  pushl $238
80107c82:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107c87:	e9 2f f0 ff ff       	jmp    80106cbb <alltraps>

80107c8c <vector239>:
.globl vector239
vector239:
  pushl $0
80107c8c:	6a 00                	push   $0x0
  pushl $239
80107c8e:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107c93:	e9 23 f0 ff ff       	jmp    80106cbb <alltraps>

80107c98 <vector240>:
.globl vector240
vector240:
  pushl $0
80107c98:	6a 00                	push   $0x0
  pushl $240
80107c9a:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107c9f:	e9 17 f0 ff ff       	jmp    80106cbb <alltraps>

80107ca4 <vector241>:
.globl vector241
vector241:
  pushl $0
80107ca4:	6a 00                	push   $0x0
  pushl $241
80107ca6:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107cab:	e9 0b f0 ff ff       	jmp    80106cbb <alltraps>

80107cb0 <vector242>:
.globl vector242
vector242:
  pushl $0
80107cb0:	6a 00                	push   $0x0
  pushl $242
80107cb2:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107cb7:	e9 ff ef ff ff       	jmp    80106cbb <alltraps>

80107cbc <vector243>:
.globl vector243
vector243:
  pushl $0
80107cbc:	6a 00                	push   $0x0
  pushl $243
80107cbe:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107cc3:	e9 f3 ef ff ff       	jmp    80106cbb <alltraps>

80107cc8 <vector244>:
.globl vector244
vector244:
  pushl $0
80107cc8:	6a 00                	push   $0x0
  pushl $244
80107cca:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107ccf:	e9 e7 ef ff ff       	jmp    80106cbb <alltraps>

80107cd4 <vector245>:
.globl vector245
vector245:
  pushl $0
80107cd4:	6a 00                	push   $0x0
  pushl $245
80107cd6:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107cdb:	e9 db ef ff ff       	jmp    80106cbb <alltraps>

80107ce0 <vector246>:
.globl vector246
vector246:
  pushl $0
80107ce0:	6a 00                	push   $0x0
  pushl $246
80107ce2:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107ce7:	e9 cf ef ff ff       	jmp    80106cbb <alltraps>

80107cec <vector247>:
.globl vector247
vector247:
  pushl $0
80107cec:	6a 00                	push   $0x0
  pushl $247
80107cee:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107cf3:	e9 c3 ef ff ff       	jmp    80106cbb <alltraps>

80107cf8 <vector248>:
.globl vector248
vector248:
  pushl $0
80107cf8:	6a 00                	push   $0x0
  pushl $248
80107cfa:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107cff:	e9 b7 ef ff ff       	jmp    80106cbb <alltraps>

80107d04 <vector249>:
.globl vector249
vector249:
  pushl $0
80107d04:	6a 00                	push   $0x0
  pushl $249
80107d06:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107d0b:	e9 ab ef ff ff       	jmp    80106cbb <alltraps>

80107d10 <vector250>:
.globl vector250
vector250:
  pushl $0
80107d10:	6a 00                	push   $0x0
  pushl $250
80107d12:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107d17:	e9 9f ef ff ff       	jmp    80106cbb <alltraps>

80107d1c <vector251>:
.globl vector251
vector251:
  pushl $0
80107d1c:	6a 00                	push   $0x0
  pushl $251
80107d1e:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107d23:	e9 93 ef ff ff       	jmp    80106cbb <alltraps>

80107d28 <vector252>:
.globl vector252
vector252:
  pushl $0
80107d28:	6a 00                	push   $0x0
  pushl $252
80107d2a:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107d2f:	e9 87 ef ff ff       	jmp    80106cbb <alltraps>

80107d34 <vector253>:
.globl vector253
vector253:
  pushl $0
80107d34:	6a 00                	push   $0x0
  pushl $253
80107d36:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107d3b:	e9 7b ef ff ff       	jmp    80106cbb <alltraps>

80107d40 <vector254>:
.globl vector254
vector254:
  pushl $0
80107d40:	6a 00                	push   $0x0
  pushl $254
80107d42:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107d47:	e9 6f ef ff ff       	jmp    80106cbb <alltraps>

80107d4c <vector255>:
.globl vector255
vector255:
  pushl $0
80107d4c:	6a 00                	push   $0x0
  pushl $255
80107d4e:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107d53:	e9 63 ef ff ff       	jmp    80106cbb <alltraps>

80107d58 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107d58:	55                   	push   %ebp
80107d59:	89 e5                	mov    %esp,%ebp
80107d5b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d61:	83 e8 01             	sub    $0x1,%eax
80107d64:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107d68:	8b 45 08             	mov    0x8(%ebp),%eax
80107d6b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d72:	c1 e8 10             	shr    $0x10,%eax
80107d75:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107d79:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107d7c:	0f 01 10             	lgdtl  (%eax)
}
80107d7f:	90                   	nop
80107d80:	c9                   	leave  
80107d81:	c3                   	ret    

80107d82 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107d82:	55                   	push   %ebp
80107d83:	89 e5                	mov    %esp,%ebp
80107d85:	83 ec 04             	sub    $0x4,%esp
80107d88:	8b 45 08             	mov    0x8(%ebp),%eax
80107d8b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107d8f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107d93:	0f 00 d8             	ltr    %ax
}
80107d96:	90                   	nop
80107d97:	c9                   	leave  
80107d98:	c3                   	ret    

80107d99 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107d99:	55                   	push   %ebp
80107d9a:	89 e5                	mov    %esp,%ebp
80107d9c:	83 ec 04             	sub    $0x4,%esp
80107d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80107da2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107da6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107daa:	8e e8                	mov    %eax,%gs
}
80107dac:	90                   	nop
80107dad:	c9                   	leave  
80107dae:	c3                   	ret    

80107daf <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107daf:	55                   	push   %ebp
80107db0:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107db2:	8b 45 08             	mov    0x8(%ebp),%eax
80107db5:	0f 22 d8             	mov    %eax,%cr3
}
80107db8:	90                   	nop
80107db9:	5d                   	pop    %ebp
80107dba:	c3                   	ret    

80107dbb <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107dbb:	55                   	push   %ebp
80107dbc:	89 e5                	mov    %esp,%ebp
80107dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80107dc1:	05 00 00 00 80       	add    $0x80000000,%eax
80107dc6:	5d                   	pop    %ebp
80107dc7:	c3                   	ret    

80107dc8 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107dc8:	55                   	push   %ebp
80107dc9:	89 e5                	mov    %esp,%ebp
80107dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80107dce:	05 00 00 00 80       	add    $0x80000000,%eax
80107dd3:	5d                   	pop    %ebp
80107dd4:	c3                   	ret    

80107dd5 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107dd5:	55                   	push   %ebp
80107dd6:	89 e5                	mov    %esp,%ebp
80107dd8:	53                   	push   %ebx
80107dd9:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107ddc:	e8 12 b2 ff ff       	call   80102ff3 <cpunum>
80107de1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107de7:	05 80 33 11 80       	add    $0x80113380,%eax
80107dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df2:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfb:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e04:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e0f:	83 e2 f0             	and    $0xfffffff0,%edx
80107e12:	83 ca 0a             	or     $0xa,%edx
80107e15:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e1f:	83 ca 10             	or     $0x10,%edx
80107e22:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e28:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e2c:	83 e2 9f             	and    $0xffffff9f,%edx
80107e2f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e35:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e39:	83 ca 80             	or     $0xffffff80,%edx
80107e3c:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e42:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e46:	83 ca 0f             	or     $0xf,%edx
80107e49:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e53:	83 e2 ef             	and    $0xffffffef,%edx
80107e56:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e60:	83 e2 df             	and    $0xffffffdf,%edx
80107e63:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e69:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e6d:	83 ca 40             	or     $0x40,%edx
80107e70:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e76:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e7a:	83 ca 80             	or     $0xffffff80,%edx
80107e7d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e83:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e8a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107e91:	ff ff 
80107e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e96:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107e9d:	00 00 
80107e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea2:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eac:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107eb3:	83 e2 f0             	and    $0xfffffff0,%edx
80107eb6:	83 ca 02             	or     $0x2,%edx
80107eb9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ec9:	83 ca 10             	or     $0x10,%edx
80107ecc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107edc:	83 e2 9f             	and    $0xffffff9f,%edx
80107edf:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107eef:	83 ca 80             	or     $0xffffff80,%edx
80107ef2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f02:	83 ca 0f             	or     $0xf,%edx
80107f05:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f15:	83 e2 ef             	and    $0xffffffef,%edx
80107f18:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f21:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f28:	83 e2 df             	and    $0xffffffdf,%edx
80107f2b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f34:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f3b:	83 ca 40             	or     $0x40,%edx
80107f3e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f47:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f4e:	83 ca 80             	or     $0xffffff80,%edx
80107f51:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f64:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107f6b:	ff ff 
80107f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f70:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107f77:	00 00 
80107f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f86:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f8d:	83 e2 f0             	and    $0xfffffff0,%edx
80107f90:	83 ca 0a             	or     $0xa,%edx
80107f93:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fa3:	83 ca 10             	or     $0x10,%edx
80107fa6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107faf:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fb6:	83 ca 60             	or     $0x60,%edx
80107fb9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fc9:	83 ca 80             	or     $0xffffff80,%edx
80107fcc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107fdc:	83 ca 0f             	or     $0xf,%edx
80107fdf:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107fef:	83 e2 ef             	and    $0xffffffef,%edx
80107ff2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108002:	83 e2 df             	and    $0xffffffdf,%edx
80108005:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010800b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108015:	83 ca 40             	or     $0x40,%edx
80108018:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010801e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108021:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108028:	83 ca 80             	or     $0xffffff80,%edx
8010802b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108031:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108034:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010803b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803e:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108045:	ff ff 
80108047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804a:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108051:	00 00 
80108053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108056:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010805d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108060:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108067:	83 e2 f0             	and    $0xfffffff0,%edx
8010806a:	83 ca 02             	or     $0x2,%edx
8010806d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108073:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108076:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010807d:	83 ca 10             	or     $0x10,%edx
80108080:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108089:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108090:	83 ca 60             	or     $0x60,%edx
80108093:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801080a3:	83 ca 80             	or     $0xffffff80,%edx
801080a6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801080ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080af:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801080b6:	83 ca 0f             	or     $0xf,%edx
801080b9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801080bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801080c9:	83 e2 ef             	and    $0xffffffef,%edx
801080cc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801080d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801080dc:	83 e2 df             	and    $0xffffffdf,%edx
801080df:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801080e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801080ef:	83 ca 40             	or     $0x40,%edx
801080f2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801080f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108102:	83 ca 80             	or     $0xffffff80,%edx
80108105:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010810b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810e:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108118:	05 b4 00 00 00       	add    $0xb4,%eax
8010811d:	89 c3                	mov    %eax,%ebx
8010811f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108122:	05 b4 00 00 00       	add    $0xb4,%eax
80108127:	c1 e8 10             	shr    $0x10,%eax
8010812a:	89 c2                	mov    %eax,%edx
8010812c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812f:	05 b4 00 00 00       	add    $0xb4,%eax
80108134:	c1 e8 18             	shr    $0x18,%eax
80108137:	89 c1                	mov    %eax,%ecx
80108139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813c:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108143:	00 00 
80108145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108148:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010814f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108152:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108162:	83 e2 f0             	and    $0xfffffff0,%edx
80108165:	83 ca 02             	or     $0x2,%edx
80108168:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010816e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108171:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108178:	83 ca 10             	or     $0x10,%edx
8010817b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108184:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010818b:	83 e2 9f             	and    $0xffffff9f,%edx
8010818e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108197:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010819e:	83 ca 80             	or     $0xffffff80,%edx
801081a1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801081a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081aa:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801081b1:	83 e2 f0             	and    $0xfffffff0,%edx
801081b4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801081ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081bd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801081c4:	83 e2 ef             	and    $0xffffffef,%edx
801081c7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801081cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801081d7:	83 e2 df             	and    $0xffffffdf,%edx
801081da:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801081e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801081ea:	83 ca 40             	or     $0x40,%edx
801081ed:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801081f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801081fd:	83 ca 80             	or     $0xffffff80,%edx
80108200:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108206:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108209:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010820f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108212:	83 c0 70             	add    $0x70,%eax
80108215:	83 ec 08             	sub    $0x8,%esp
80108218:	6a 38                	push   $0x38
8010821a:	50                   	push   %eax
8010821b:	e8 38 fb ff ff       	call   80107d58 <lgdt>
80108220:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108223:	83 ec 0c             	sub    $0xc,%esp
80108226:	6a 18                	push   $0x18
80108228:	e8 6c fb ff ff       	call   80107d99 <loadgs>
8010822d:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108230:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108233:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108239:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108240:	00 00 00 00 
}
80108244:	90                   	nop
80108245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108248:	c9                   	leave  
80108249:	c3                   	ret    

8010824a <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010824a:	55                   	push   %ebp
8010824b:	89 e5                	mov    %esp,%ebp
8010824d:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108250:	8b 45 0c             	mov    0xc(%ebp),%eax
80108253:	c1 e8 16             	shr    $0x16,%eax
80108256:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010825d:	8b 45 08             	mov    0x8(%ebp),%eax
80108260:	01 d0                	add    %edx,%eax
80108262:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108265:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108268:	8b 00                	mov    (%eax),%eax
8010826a:	83 e0 01             	and    $0x1,%eax
8010826d:	85 c0                	test   %eax,%eax
8010826f:	74 18                	je     80108289 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108271:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108274:	8b 00                	mov    (%eax),%eax
80108276:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010827b:	50                   	push   %eax
8010827c:	e8 47 fb ff ff       	call   80107dc8 <p2v>
80108281:	83 c4 04             	add    $0x4,%esp
80108284:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108287:	eb 48                	jmp    801082d1 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108289:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010828d:	74 0e                	je     8010829d <walkpgdir+0x53>
8010828f:	e8 f9 a9 ff ff       	call   80102c8d <kalloc>
80108294:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108297:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010829b:	75 07                	jne    801082a4 <walkpgdir+0x5a>
      return 0;
8010829d:	b8 00 00 00 00       	mov    $0x0,%eax
801082a2:	eb 44                	jmp    801082e8 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801082a4:	83 ec 04             	sub    $0x4,%esp
801082a7:	68 00 10 00 00       	push   $0x1000
801082ac:	6a 00                	push   $0x0
801082ae:	ff 75 f4             	pushl  -0xc(%ebp)
801082b1:	e8 ed d4 ff ff       	call   801057a3 <memset>
801082b6:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801082b9:	83 ec 0c             	sub    $0xc,%esp
801082bc:	ff 75 f4             	pushl  -0xc(%ebp)
801082bf:	e8 f7 fa ff ff       	call   80107dbb <v2p>
801082c4:	83 c4 10             	add    $0x10,%esp
801082c7:	83 c8 07             	or     $0x7,%eax
801082ca:	89 c2                	mov    %eax,%edx
801082cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082cf:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801082d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801082d4:	c1 e8 0c             	shr    $0xc,%eax
801082d7:	25 ff 03 00 00       	and    $0x3ff,%eax
801082dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e6:	01 d0                	add    %edx,%eax
}
801082e8:	c9                   	leave  
801082e9:	c3                   	ret    

801082ea <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801082ea:	55                   	push   %ebp
801082eb:	89 e5                	mov    %esp,%ebp
801082ed:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801082f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801082f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801082fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801082fe:	8b 45 10             	mov    0x10(%ebp),%eax
80108301:	01 d0                	add    %edx,%eax
80108303:	83 e8 01             	sub    $0x1,%eax
80108306:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010830b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010830e:	83 ec 04             	sub    $0x4,%esp
80108311:	6a 01                	push   $0x1
80108313:	ff 75 f4             	pushl  -0xc(%ebp)
80108316:	ff 75 08             	pushl  0x8(%ebp)
80108319:	e8 2c ff ff ff       	call   8010824a <walkpgdir>
8010831e:	83 c4 10             	add    $0x10,%esp
80108321:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108324:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108328:	75 07                	jne    80108331 <mappages+0x47>
      return -1;
8010832a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010832f:	eb 47                	jmp    80108378 <mappages+0x8e>
    if(*pte & PTE_P)
80108331:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108334:	8b 00                	mov    (%eax),%eax
80108336:	83 e0 01             	and    $0x1,%eax
80108339:	85 c0                	test   %eax,%eax
8010833b:	74 0d                	je     8010834a <mappages+0x60>
      panic("remap");
8010833d:	83 ec 0c             	sub    $0xc,%esp
80108340:	68 40 92 10 80       	push   $0x80109240
80108345:	e8 1c 82 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
8010834a:	8b 45 18             	mov    0x18(%ebp),%eax
8010834d:	0b 45 14             	or     0x14(%ebp),%eax
80108350:	83 c8 01             	or     $0x1,%eax
80108353:	89 c2                	mov    %eax,%edx
80108355:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108358:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010835a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108360:	74 10                	je     80108372 <mappages+0x88>
      break;
    a += PGSIZE;
80108362:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108369:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108370:	eb 9c                	jmp    8010830e <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108372:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108373:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108378:	c9                   	leave  
80108379:	c3                   	ret    

8010837a <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010837a:	55                   	push   %ebp
8010837b:	89 e5                	mov    %esp,%ebp
8010837d:	53                   	push   %ebx
8010837e:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108381:	e8 07 a9 ff ff       	call   80102c8d <kalloc>
80108386:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108389:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010838d:	75 0a                	jne    80108399 <setupkvm+0x1f>
    return 0;
8010838f:	b8 00 00 00 00       	mov    $0x0,%eax
80108394:	e9 8e 00 00 00       	jmp    80108427 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108399:	83 ec 04             	sub    $0x4,%esp
8010839c:	68 00 10 00 00       	push   $0x1000
801083a1:	6a 00                	push   $0x0
801083a3:	ff 75 f0             	pushl  -0x10(%ebp)
801083a6:	e8 f8 d3 ff ff       	call   801057a3 <memset>
801083ab:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801083ae:	83 ec 0c             	sub    $0xc,%esp
801083b1:	68 00 00 00 0e       	push   $0xe000000
801083b6:	e8 0d fa ff ff       	call   80107dc8 <p2v>
801083bb:	83 c4 10             	add    $0x10,%esp
801083be:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801083c3:	76 0d                	jbe    801083d2 <setupkvm+0x58>
    panic("PHYSTOP too high");
801083c5:	83 ec 0c             	sub    $0xc,%esp
801083c8:	68 46 92 10 80       	push   $0x80109246
801083cd:	e8 94 81 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801083d2:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801083d9:	eb 40                	jmp    8010841b <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801083db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083de:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801083e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e4:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801083e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ea:	8b 58 08             	mov    0x8(%eax),%ebx
801083ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f0:	8b 40 04             	mov    0x4(%eax),%eax
801083f3:	29 c3                	sub    %eax,%ebx
801083f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f8:	8b 00                	mov    (%eax),%eax
801083fa:	83 ec 0c             	sub    $0xc,%esp
801083fd:	51                   	push   %ecx
801083fe:	52                   	push   %edx
801083ff:	53                   	push   %ebx
80108400:	50                   	push   %eax
80108401:	ff 75 f0             	pushl  -0x10(%ebp)
80108404:	e8 e1 fe ff ff       	call   801082ea <mappages>
80108409:	83 c4 20             	add    $0x20,%esp
8010840c:	85 c0                	test   %eax,%eax
8010840e:	79 07                	jns    80108417 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108410:	b8 00 00 00 00       	mov    $0x0,%eax
80108415:	eb 10                	jmp    80108427 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108417:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010841b:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108422:	72 b7                	jb     801083db <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108424:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010842a:	c9                   	leave  
8010842b:	c3                   	ret    

8010842c <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010842c:	55                   	push   %ebp
8010842d:	89 e5                	mov    %esp,%ebp
8010842f:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108432:	e8 43 ff ff ff       	call   8010837a <setupkvm>
80108437:	a3 38 67 11 80       	mov    %eax,0x80116738
  switchkvm();
8010843c:	e8 03 00 00 00       	call   80108444 <switchkvm>
}
80108441:	90                   	nop
80108442:	c9                   	leave  
80108443:	c3                   	ret    

80108444 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108444:	55                   	push   %ebp
80108445:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108447:	a1 38 67 11 80       	mov    0x80116738,%eax
8010844c:	50                   	push   %eax
8010844d:	e8 69 f9 ff ff       	call   80107dbb <v2p>
80108452:	83 c4 04             	add    $0x4,%esp
80108455:	50                   	push   %eax
80108456:	e8 54 f9 ff ff       	call   80107daf <lcr3>
8010845b:	83 c4 04             	add    $0x4,%esp
}
8010845e:	90                   	nop
8010845f:	c9                   	leave  
80108460:	c3                   	ret    

80108461 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108461:	55                   	push   %ebp
80108462:	89 e5                	mov    %esp,%ebp
80108464:	56                   	push   %esi
80108465:	53                   	push   %ebx
  pushcli();
80108466:	e8 32 d2 ff ff       	call   8010569d <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010846b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108471:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108478:	83 c2 08             	add    $0x8,%edx
8010847b:	89 d6                	mov    %edx,%esi
8010847d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108484:	83 c2 08             	add    $0x8,%edx
80108487:	c1 ea 10             	shr    $0x10,%edx
8010848a:	89 d3                	mov    %edx,%ebx
8010848c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108493:	83 c2 08             	add    $0x8,%edx
80108496:	c1 ea 18             	shr    $0x18,%edx
80108499:	89 d1                	mov    %edx,%ecx
8010849b:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801084a2:	67 00 
801084a4:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801084ab:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801084b1:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801084b8:	83 e2 f0             	and    $0xfffffff0,%edx
801084bb:	83 ca 09             	or     $0x9,%edx
801084be:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801084c4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801084cb:	83 ca 10             	or     $0x10,%edx
801084ce:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801084d4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801084db:	83 e2 9f             	and    $0xffffff9f,%edx
801084de:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801084e4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801084eb:	83 ca 80             	or     $0xffffff80,%edx
801084ee:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801084f4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801084fb:	83 e2 f0             	and    $0xfffffff0,%edx
801084fe:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108504:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010850b:	83 e2 ef             	and    $0xffffffef,%edx
8010850e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108514:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010851b:	83 e2 df             	and    $0xffffffdf,%edx
8010851e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108524:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010852b:	83 ca 40             	or     $0x40,%edx
8010852e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108534:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010853b:	83 e2 7f             	and    $0x7f,%edx
8010853e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108544:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010854a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108550:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108557:	83 e2 ef             	and    $0xffffffef,%edx
8010855a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108560:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108566:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010856c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108572:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108579:	8b 52 08             	mov    0x8(%edx),%edx
8010857c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108582:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108585:	83 ec 0c             	sub    $0xc,%esp
80108588:	6a 30                	push   $0x30
8010858a:	e8 f3 f7 ff ff       	call   80107d82 <ltr>
8010858f:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108592:	8b 45 08             	mov    0x8(%ebp),%eax
80108595:	8b 40 04             	mov    0x4(%eax),%eax
80108598:	85 c0                	test   %eax,%eax
8010859a:	75 0d                	jne    801085a9 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010859c:	83 ec 0c             	sub    $0xc,%esp
8010859f:	68 57 92 10 80       	push   $0x80109257
801085a4:	e8 bd 7f ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801085a9:	8b 45 08             	mov    0x8(%ebp),%eax
801085ac:	8b 40 04             	mov    0x4(%eax),%eax
801085af:	83 ec 0c             	sub    $0xc,%esp
801085b2:	50                   	push   %eax
801085b3:	e8 03 f8 ff ff       	call   80107dbb <v2p>
801085b8:	83 c4 10             	add    $0x10,%esp
801085bb:	83 ec 0c             	sub    $0xc,%esp
801085be:	50                   	push   %eax
801085bf:	e8 eb f7 ff ff       	call   80107daf <lcr3>
801085c4:	83 c4 10             	add    $0x10,%esp
  popcli();
801085c7:	e8 16 d1 ff ff       	call   801056e2 <popcli>
}
801085cc:	90                   	nop
801085cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801085d0:	5b                   	pop    %ebx
801085d1:	5e                   	pop    %esi
801085d2:	5d                   	pop    %ebp
801085d3:	c3                   	ret    

801085d4 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801085d4:	55                   	push   %ebp
801085d5:	89 e5                	mov    %esp,%ebp
801085d7:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801085da:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801085e1:	76 0d                	jbe    801085f0 <inituvm+0x1c>
    panic("inituvm: more than a page");
801085e3:	83 ec 0c             	sub    $0xc,%esp
801085e6:	68 6b 92 10 80       	push   $0x8010926b
801085eb:	e8 76 7f ff ff       	call   80100566 <panic>
  mem = kalloc();
801085f0:	e8 98 a6 ff ff       	call   80102c8d <kalloc>
801085f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801085f8:	83 ec 04             	sub    $0x4,%esp
801085fb:	68 00 10 00 00       	push   $0x1000
80108600:	6a 00                	push   $0x0
80108602:	ff 75 f4             	pushl  -0xc(%ebp)
80108605:	e8 99 d1 ff ff       	call   801057a3 <memset>
8010860a:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010860d:	83 ec 0c             	sub    $0xc,%esp
80108610:	ff 75 f4             	pushl  -0xc(%ebp)
80108613:	e8 a3 f7 ff ff       	call   80107dbb <v2p>
80108618:	83 c4 10             	add    $0x10,%esp
8010861b:	83 ec 0c             	sub    $0xc,%esp
8010861e:	6a 06                	push   $0x6
80108620:	50                   	push   %eax
80108621:	68 00 10 00 00       	push   $0x1000
80108626:	6a 00                	push   $0x0
80108628:	ff 75 08             	pushl  0x8(%ebp)
8010862b:	e8 ba fc ff ff       	call   801082ea <mappages>
80108630:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108633:	83 ec 04             	sub    $0x4,%esp
80108636:	ff 75 10             	pushl  0x10(%ebp)
80108639:	ff 75 0c             	pushl  0xc(%ebp)
8010863c:	ff 75 f4             	pushl  -0xc(%ebp)
8010863f:	e8 1e d2 ff ff       	call   80105862 <memmove>
80108644:	83 c4 10             	add    $0x10,%esp
}
80108647:	90                   	nop
80108648:	c9                   	leave  
80108649:	c3                   	ret    

8010864a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010864a:	55                   	push   %ebp
8010864b:	89 e5                	mov    %esp,%ebp
8010864d:	53                   	push   %ebx
8010864e:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108651:	8b 45 0c             	mov    0xc(%ebp),%eax
80108654:	25 ff 0f 00 00       	and    $0xfff,%eax
80108659:	85 c0                	test   %eax,%eax
8010865b:	74 0d                	je     8010866a <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010865d:	83 ec 0c             	sub    $0xc,%esp
80108660:	68 88 92 10 80       	push   $0x80109288
80108665:	e8 fc 7e ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010866a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108671:	e9 95 00 00 00       	jmp    8010870b <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108676:	8b 55 0c             	mov    0xc(%ebp),%edx
80108679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010867c:	01 d0                	add    %edx,%eax
8010867e:	83 ec 04             	sub    $0x4,%esp
80108681:	6a 00                	push   $0x0
80108683:	50                   	push   %eax
80108684:	ff 75 08             	pushl  0x8(%ebp)
80108687:	e8 be fb ff ff       	call   8010824a <walkpgdir>
8010868c:	83 c4 10             	add    $0x10,%esp
8010868f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108692:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108696:	75 0d                	jne    801086a5 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108698:	83 ec 0c             	sub    $0xc,%esp
8010869b:	68 ab 92 10 80       	push   $0x801092ab
801086a0:	e8 c1 7e ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801086a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086a8:	8b 00                	mov    (%eax),%eax
801086aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086af:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801086b2:	8b 45 18             	mov    0x18(%ebp),%eax
801086b5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801086b8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801086bd:	77 0b                	ja     801086ca <loaduvm+0x80>
      n = sz - i;
801086bf:	8b 45 18             	mov    0x18(%ebp),%eax
801086c2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801086c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801086c8:	eb 07                	jmp    801086d1 <loaduvm+0x87>
    else
      n = PGSIZE;
801086ca:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801086d1:	8b 55 14             	mov    0x14(%ebp),%edx
801086d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086d7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801086da:	83 ec 0c             	sub    $0xc,%esp
801086dd:	ff 75 e8             	pushl  -0x18(%ebp)
801086e0:	e8 e3 f6 ff ff       	call   80107dc8 <p2v>
801086e5:	83 c4 10             	add    $0x10,%esp
801086e8:	ff 75 f0             	pushl  -0x10(%ebp)
801086eb:	53                   	push   %ebx
801086ec:	50                   	push   %eax
801086ed:	ff 75 10             	pushl  0x10(%ebp)
801086f0:	e8 0a 98 ff ff       	call   80101eff <readi>
801086f5:	83 c4 10             	add    $0x10,%esp
801086f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801086fb:	74 07                	je     80108704 <loaduvm+0xba>
      return -1;
801086fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108702:	eb 18                	jmp    8010871c <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108704:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010870b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010870e:	3b 45 18             	cmp    0x18(%ebp),%eax
80108711:	0f 82 5f ff ff ff    	jb     80108676 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108717:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010871c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010871f:	c9                   	leave  
80108720:	c3                   	ret    

80108721 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108721:	55                   	push   %ebp
80108722:	89 e5                	mov    %esp,%ebp
80108724:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108727:	8b 45 10             	mov    0x10(%ebp),%eax
8010872a:	85 c0                	test   %eax,%eax
8010872c:	79 0a                	jns    80108738 <allocuvm+0x17>
    return 0;
8010872e:	b8 00 00 00 00       	mov    $0x0,%eax
80108733:	e9 b0 00 00 00       	jmp    801087e8 <allocuvm+0xc7>
  if(newsz < oldsz)
80108738:	8b 45 10             	mov    0x10(%ebp),%eax
8010873b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010873e:	73 08                	jae    80108748 <allocuvm+0x27>
    return oldsz;
80108740:	8b 45 0c             	mov    0xc(%ebp),%eax
80108743:	e9 a0 00 00 00       	jmp    801087e8 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108748:	8b 45 0c             	mov    0xc(%ebp),%eax
8010874b:	05 ff 0f 00 00       	add    $0xfff,%eax
80108750:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108758:	eb 7f                	jmp    801087d9 <allocuvm+0xb8>
    mem = kalloc();
8010875a:	e8 2e a5 ff ff       	call   80102c8d <kalloc>
8010875f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108762:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108766:	75 2b                	jne    80108793 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108768:	83 ec 0c             	sub    $0xc,%esp
8010876b:	68 c9 92 10 80       	push   $0x801092c9
80108770:	e8 51 7c ff ff       	call   801003c6 <cprintf>
80108775:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108778:	83 ec 04             	sub    $0x4,%esp
8010877b:	ff 75 0c             	pushl  0xc(%ebp)
8010877e:	ff 75 10             	pushl  0x10(%ebp)
80108781:	ff 75 08             	pushl  0x8(%ebp)
80108784:	e8 61 00 00 00       	call   801087ea <deallocuvm>
80108789:	83 c4 10             	add    $0x10,%esp
      return 0;
8010878c:	b8 00 00 00 00       	mov    $0x0,%eax
80108791:	eb 55                	jmp    801087e8 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108793:	83 ec 04             	sub    $0x4,%esp
80108796:	68 00 10 00 00       	push   $0x1000
8010879b:	6a 00                	push   $0x0
8010879d:	ff 75 f0             	pushl  -0x10(%ebp)
801087a0:	e8 fe cf ff ff       	call   801057a3 <memset>
801087a5:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801087a8:	83 ec 0c             	sub    $0xc,%esp
801087ab:	ff 75 f0             	pushl  -0x10(%ebp)
801087ae:	e8 08 f6 ff ff       	call   80107dbb <v2p>
801087b3:	83 c4 10             	add    $0x10,%esp
801087b6:	89 c2                	mov    %eax,%edx
801087b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087bb:	83 ec 0c             	sub    $0xc,%esp
801087be:	6a 06                	push   $0x6
801087c0:	52                   	push   %edx
801087c1:	68 00 10 00 00       	push   $0x1000
801087c6:	50                   	push   %eax
801087c7:	ff 75 08             	pushl  0x8(%ebp)
801087ca:	e8 1b fb ff ff       	call   801082ea <mappages>
801087cf:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801087d2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801087d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087dc:	3b 45 10             	cmp    0x10(%ebp),%eax
801087df:	0f 82 75 ff ff ff    	jb     8010875a <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801087e5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801087e8:	c9                   	leave  
801087e9:	c3                   	ret    

801087ea <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801087ea:	55                   	push   %ebp
801087eb:	89 e5                	mov    %esp,%ebp
801087ed:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801087f0:	8b 45 10             	mov    0x10(%ebp),%eax
801087f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801087f6:	72 08                	jb     80108800 <deallocuvm+0x16>
    return oldsz;
801087f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801087fb:	e9 a5 00 00 00       	jmp    801088a5 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108800:	8b 45 10             	mov    0x10(%ebp),%eax
80108803:	05 ff 0f 00 00       	add    $0xfff,%eax
80108808:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010880d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108810:	e9 81 00 00 00       	jmp    80108896 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108818:	83 ec 04             	sub    $0x4,%esp
8010881b:	6a 00                	push   $0x0
8010881d:	50                   	push   %eax
8010881e:	ff 75 08             	pushl  0x8(%ebp)
80108821:	e8 24 fa ff ff       	call   8010824a <walkpgdir>
80108826:	83 c4 10             	add    $0x10,%esp
80108829:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010882c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108830:	75 09                	jne    8010883b <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108832:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108839:	eb 54                	jmp    8010888f <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
8010883b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010883e:	8b 00                	mov    (%eax),%eax
80108840:	83 e0 01             	and    $0x1,%eax
80108843:	85 c0                	test   %eax,%eax
80108845:	74 48                	je     8010888f <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108847:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010884a:	8b 00                	mov    (%eax),%eax
8010884c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108851:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108854:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108858:	75 0d                	jne    80108867 <deallocuvm+0x7d>
        panic("kfree");
8010885a:	83 ec 0c             	sub    $0xc,%esp
8010885d:	68 e1 92 10 80       	push   $0x801092e1
80108862:	e8 ff 7c ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80108867:	83 ec 0c             	sub    $0xc,%esp
8010886a:	ff 75 ec             	pushl  -0x14(%ebp)
8010886d:	e8 56 f5 ff ff       	call   80107dc8 <p2v>
80108872:	83 c4 10             	add    $0x10,%esp
80108875:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108878:	83 ec 0c             	sub    $0xc,%esp
8010887b:	ff 75 e8             	pushl  -0x18(%ebp)
8010887e:	e8 6d a3 ff ff       	call   80102bf0 <kfree>
80108883:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108886:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108889:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010888f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108899:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010889c:	0f 82 73 ff ff ff    	jb     80108815 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801088a2:	8b 45 10             	mov    0x10(%ebp),%eax
}
801088a5:	c9                   	leave  
801088a6:	c3                   	ret    

801088a7 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801088a7:	55                   	push   %ebp
801088a8:	89 e5                	mov    %esp,%ebp
801088aa:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801088ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801088b1:	75 0d                	jne    801088c0 <freevm+0x19>
    panic("freevm: no pgdir");
801088b3:	83 ec 0c             	sub    $0xc,%esp
801088b6:	68 e7 92 10 80       	push   $0x801092e7
801088bb:	e8 a6 7c ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801088c0:	83 ec 04             	sub    $0x4,%esp
801088c3:	6a 00                	push   $0x0
801088c5:	68 00 00 00 80       	push   $0x80000000
801088ca:	ff 75 08             	pushl  0x8(%ebp)
801088cd:	e8 18 ff ff ff       	call   801087ea <deallocuvm>
801088d2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801088d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801088dc:	eb 4f                	jmp    8010892d <freevm+0x86>
    if(pgdir[i] & PTE_P){
801088de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801088e8:	8b 45 08             	mov    0x8(%ebp),%eax
801088eb:	01 d0                	add    %edx,%eax
801088ed:	8b 00                	mov    (%eax),%eax
801088ef:	83 e0 01             	and    $0x1,%eax
801088f2:	85 c0                	test   %eax,%eax
801088f4:	74 33                	je     80108929 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801088f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108900:	8b 45 08             	mov    0x8(%ebp),%eax
80108903:	01 d0                	add    %edx,%eax
80108905:	8b 00                	mov    (%eax),%eax
80108907:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010890c:	83 ec 0c             	sub    $0xc,%esp
8010890f:	50                   	push   %eax
80108910:	e8 b3 f4 ff ff       	call   80107dc8 <p2v>
80108915:	83 c4 10             	add    $0x10,%esp
80108918:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010891b:	83 ec 0c             	sub    $0xc,%esp
8010891e:	ff 75 f0             	pushl  -0x10(%ebp)
80108921:	e8 ca a2 ff ff       	call   80102bf0 <kfree>
80108926:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108929:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010892d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108934:	76 a8                	jbe    801088de <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108936:	83 ec 0c             	sub    $0xc,%esp
80108939:	ff 75 08             	pushl  0x8(%ebp)
8010893c:	e8 af a2 ff ff       	call   80102bf0 <kfree>
80108941:	83 c4 10             	add    $0x10,%esp
}
80108944:	90                   	nop
80108945:	c9                   	leave  
80108946:	c3                   	ret    

80108947 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108947:	55                   	push   %ebp
80108948:	89 e5                	mov    %esp,%ebp
8010894a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010894d:	83 ec 04             	sub    $0x4,%esp
80108950:	6a 00                	push   $0x0
80108952:	ff 75 0c             	pushl  0xc(%ebp)
80108955:	ff 75 08             	pushl  0x8(%ebp)
80108958:	e8 ed f8 ff ff       	call   8010824a <walkpgdir>
8010895d:	83 c4 10             	add    $0x10,%esp
80108960:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108967:	75 0d                	jne    80108976 <clearpteu+0x2f>
    panic("clearpteu");
80108969:	83 ec 0c             	sub    $0xc,%esp
8010896c:	68 f8 92 10 80       	push   $0x801092f8
80108971:	e8 f0 7b ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108979:	8b 00                	mov    (%eax),%eax
8010897b:	83 e0 fb             	and    $0xfffffffb,%eax
8010897e:	89 c2                	mov    %eax,%edx
80108980:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108983:	89 10                	mov    %edx,(%eax)
}
80108985:	90                   	nop
80108986:	c9                   	leave  
80108987:	c3                   	ret    

80108988 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108988:	55                   	push   %ebp
80108989:	89 e5                	mov    %esp,%ebp
8010898b:	53                   	push   %ebx
8010898c:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010898f:	e8 e6 f9 ff ff       	call   8010837a <setupkvm>
80108994:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108997:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010899b:	75 0a                	jne    801089a7 <copyuvm+0x1f>
    return 0;
8010899d:	b8 00 00 00 00       	mov    $0x0,%eax
801089a2:	e9 f8 00 00 00       	jmp    80108a9f <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
801089a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801089ae:	e9 c4 00 00 00       	jmp    80108a77 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801089b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089b6:	83 ec 04             	sub    $0x4,%esp
801089b9:	6a 00                	push   $0x0
801089bb:	50                   	push   %eax
801089bc:	ff 75 08             	pushl  0x8(%ebp)
801089bf:	e8 86 f8 ff ff       	call   8010824a <walkpgdir>
801089c4:	83 c4 10             	add    $0x10,%esp
801089c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801089ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801089ce:	75 0d                	jne    801089dd <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801089d0:	83 ec 0c             	sub    $0xc,%esp
801089d3:	68 02 93 10 80       	push   $0x80109302
801089d8:	e8 89 7b ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
801089dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089e0:	8b 00                	mov    (%eax),%eax
801089e2:	83 e0 01             	and    $0x1,%eax
801089e5:	85 c0                	test   %eax,%eax
801089e7:	75 0d                	jne    801089f6 <copyuvm+0x6e>
      panic("copyuvm: page not present");
801089e9:	83 ec 0c             	sub    $0xc,%esp
801089ec:	68 1c 93 10 80       	push   $0x8010931c
801089f1:	e8 70 7b ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801089f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089f9:	8b 00                	mov    (%eax),%eax
801089fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a00:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a06:	8b 00                	mov    (%eax),%eax
80108a08:	25 ff 0f 00 00       	and    $0xfff,%eax
80108a0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108a10:	e8 78 a2 ff ff       	call   80102c8d <kalloc>
80108a15:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108a18:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108a1c:	74 6a                	je     80108a88 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108a1e:	83 ec 0c             	sub    $0xc,%esp
80108a21:	ff 75 e8             	pushl  -0x18(%ebp)
80108a24:	e8 9f f3 ff ff       	call   80107dc8 <p2v>
80108a29:	83 c4 10             	add    $0x10,%esp
80108a2c:	83 ec 04             	sub    $0x4,%esp
80108a2f:	68 00 10 00 00       	push   $0x1000
80108a34:	50                   	push   %eax
80108a35:	ff 75 e0             	pushl  -0x20(%ebp)
80108a38:	e8 25 ce ff ff       	call   80105862 <memmove>
80108a3d:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108a40:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108a43:	83 ec 0c             	sub    $0xc,%esp
80108a46:	ff 75 e0             	pushl  -0x20(%ebp)
80108a49:	e8 6d f3 ff ff       	call   80107dbb <v2p>
80108a4e:	83 c4 10             	add    $0x10,%esp
80108a51:	89 c2                	mov    %eax,%edx
80108a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a56:	83 ec 0c             	sub    $0xc,%esp
80108a59:	53                   	push   %ebx
80108a5a:	52                   	push   %edx
80108a5b:	68 00 10 00 00       	push   $0x1000
80108a60:	50                   	push   %eax
80108a61:	ff 75 f0             	pushl  -0x10(%ebp)
80108a64:	e8 81 f8 ff ff       	call   801082ea <mappages>
80108a69:	83 c4 20             	add    $0x20,%esp
80108a6c:	85 c0                	test   %eax,%eax
80108a6e:	78 1b                	js     80108a8b <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108a70:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a7a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a7d:	0f 82 30 ff ff ff    	jb     801089b3 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a86:	eb 17                	jmp    80108a9f <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108a88:	90                   	nop
80108a89:	eb 01                	jmp    80108a8c <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108a8b:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108a8c:	83 ec 0c             	sub    $0xc,%esp
80108a8f:	ff 75 f0             	pushl  -0x10(%ebp)
80108a92:	e8 10 fe ff ff       	call   801088a7 <freevm>
80108a97:	83 c4 10             	add    $0x10,%esp
  return 0;
80108a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108aa2:	c9                   	leave  
80108aa3:	c3                   	ret    

80108aa4 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108aa4:	55                   	push   %ebp
80108aa5:	89 e5                	mov    %esp,%ebp
80108aa7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108aaa:	83 ec 04             	sub    $0x4,%esp
80108aad:	6a 00                	push   $0x0
80108aaf:	ff 75 0c             	pushl  0xc(%ebp)
80108ab2:	ff 75 08             	pushl  0x8(%ebp)
80108ab5:	e8 90 f7 ff ff       	call   8010824a <walkpgdir>
80108aba:	83 c4 10             	add    $0x10,%esp
80108abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac3:	8b 00                	mov    (%eax),%eax
80108ac5:	83 e0 01             	and    $0x1,%eax
80108ac8:	85 c0                	test   %eax,%eax
80108aca:	75 07                	jne    80108ad3 <uva2ka+0x2f>
    return 0;
80108acc:	b8 00 00 00 00       	mov    $0x0,%eax
80108ad1:	eb 29                	jmp    80108afc <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad6:	8b 00                	mov    (%eax),%eax
80108ad8:	83 e0 04             	and    $0x4,%eax
80108adb:	85 c0                	test   %eax,%eax
80108add:	75 07                	jne    80108ae6 <uva2ka+0x42>
    return 0;
80108adf:	b8 00 00 00 00       	mov    $0x0,%eax
80108ae4:	eb 16                	jmp    80108afc <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ae9:	8b 00                	mov    (%eax),%eax
80108aeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108af0:	83 ec 0c             	sub    $0xc,%esp
80108af3:	50                   	push   %eax
80108af4:	e8 cf f2 ff ff       	call   80107dc8 <p2v>
80108af9:	83 c4 10             	add    $0x10,%esp
}
80108afc:	c9                   	leave  
80108afd:	c3                   	ret    

80108afe <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108afe:	55                   	push   %ebp
80108aff:	89 e5                	mov    %esp,%ebp
80108b01:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108b04:	8b 45 10             	mov    0x10(%ebp),%eax
80108b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108b0a:	eb 7f                	jmp    80108b8b <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b14:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b1a:	83 ec 08             	sub    $0x8,%esp
80108b1d:	50                   	push   %eax
80108b1e:	ff 75 08             	pushl  0x8(%ebp)
80108b21:	e8 7e ff ff ff       	call   80108aa4 <uva2ka>
80108b26:	83 c4 10             	add    $0x10,%esp
80108b29:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108b2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108b30:	75 07                	jne    80108b39 <copyout+0x3b>
      return -1;
80108b32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108b37:	eb 61                	jmp    80108b9a <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b3c:	2b 45 0c             	sub    0xc(%ebp),%eax
80108b3f:	05 00 10 00 00       	add    $0x1000,%eax
80108b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b4a:	3b 45 14             	cmp    0x14(%ebp),%eax
80108b4d:	76 06                	jbe    80108b55 <copyout+0x57>
      n = len;
80108b4f:	8b 45 14             	mov    0x14(%ebp),%eax
80108b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108b55:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b58:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108b5b:	89 c2                	mov    %eax,%edx
80108b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b60:	01 d0                	add    %edx,%eax
80108b62:	83 ec 04             	sub    $0x4,%esp
80108b65:	ff 75 f0             	pushl  -0x10(%ebp)
80108b68:	ff 75 f4             	pushl  -0xc(%ebp)
80108b6b:	50                   	push   %eax
80108b6c:	e8 f1 cc ff ff       	call   80105862 <memmove>
80108b71:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b77:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b7d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b83:	05 00 10 00 00       	add    $0x1000,%eax
80108b88:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108b8b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108b8f:	0f 85 77 ff ff ff    	jne    80108b0c <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b9a:	c9                   	leave  
80108b9b:	c3                   	ret    
