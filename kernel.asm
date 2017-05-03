
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
8010002d:	b8 dd 38 10 80       	mov    $0x801038dd,%eax
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
8010003d:	68 80 8e 10 80       	push   $0x80108e80
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 b5 57 00 00       	call   80105801 <initlock>
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
801000c1:	e8 5d 57 00 00       	call   80105823 <acquire>
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
8010010c:	e8 79 57 00 00       	call   8010588a <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 0f 4f 00 00       	call   8010503b <sleep>
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
80100188:	e8 fd 56 00 00       	call   8010588a <release>
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
801001aa:	68 87 8e 10 80       	push   $0x80108e87
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
801001e2:	e8 74 27 00 00       	call   8010295b <iderw>
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
80100204:	68 98 8e 10 80       	push   $0x80108e98
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
80100223:	e8 33 27 00 00       	call   8010295b <iderw>
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
80100243:	68 9f 8e 10 80       	push   $0x80108e9f
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 c9 55 00 00       	call   80105823 <acquire>
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
801002b9:	e8 64 4e 00 00       	call   80105122 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 bc 55 00 00       	call   8010588a <release>
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
801003e2:	e8 3c 54 00 00       	call   80105823 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 a6 8e 10 80       	push   $0x80108ea6
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
801004cd:	c7 45 ec af 8e 10 80 	movl   $0x80108eaf,-0x14(%ebp)
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
8010055b:	e8 2a 53 00 00       	call   8010588a <release>
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
8010058b:	68 b6 8e 10 80       	push   $0x80108eb6
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
801005aa:	68 c5 8e 10 80       	push   $0x80108ec5
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 15 53 00 00       	call   801058dc <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 c7 8e 10 80       	push   $0x80108ec7
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
801006ca:	68 cb 8e 10 80       	push   $0x80108ecb
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
801006f7:	e8 49 54 00 00       	call   80105b45 <memmove>
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
80100721:	e8 60 53 00 00       	call   80105a86 <memset>
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
801007b6:	e8 4d 6d 00 00       	call   80107508 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 40 6d 00 00       	call   80107508 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 33 6d 00 00       	call   80107508 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 23 6d 00 00       	call   80107508 <uartputc>
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
  int r = 0;
8010080d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
//  int s = 0;
//  int z = 0;

  acquire(&cons.lock);
80100814:	83 ec 0c             	sub    $0xc,%esp
80100817:	68 e0 c5 10 80       	push   $0x8010c5e0
8010081c:	e8 02 50 00 00       	call   80105823 <acquire>
80100821:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100824:	e9 6e 01 00 00       	jmp    80100997 <consoleintr+0x19e>
    switch(c){
80100829:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010082c:	83 f8 10             	cmp    $0x10,%eax
8010082f:	74 30                	je     80100861 <consoleintr+0x68>
80100831:	83 f8 10             	cmp    $0x10,%eax
80100834:	7f 13                	jg     80100849 <consoleintr+0x50>
80100836:	83 f8 06             	cmp    $0x6,%eax
80100839:	0f 84 ae 00 00 00    	je     801008ed <consoleintr+0xf4>
8010083f:	83 f8 08             	cmp    $0x8,%eax
80100842:	74 74                	je     801008b8 <consoleintr+0xbf>
80100844:	e9 bc 00 00 00       	jmp    80100905 <consoleintr+0x10c>
80100849:	83 f8 15             	cmp    $0x15,%eax
8010084c:	74 3c                	je     8010088a <consoleintr+0x91>
8010084e:	83 f8 7f             	cmp    $0x7f,%eax
80100851:	74 65                	je     801008b8 <consoleintr+0xbf>
80100853:	83 f8 12             	cmp    $0x12,%eax
80100856:	0f 84 9d 00 00 00    	je     801008f9 <consoleintr+0x100>
8010085c:	e9 a4 00 00 00       	jmp    80100905 <consoleintr+0x10c>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100861:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100868:	e9 2a 01 00 00       	jmp    80100997 <consoleintr+0x19e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010086d:	a1 28 18 11 80       	mov    0x80111828,%eax
80100872:	83 e8 01             	sub    $0x1,%eax
80100875:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
8010087a:	83 ec 0c             	sub    $0xc,%esp
8010087d:	68 00 01 00 00       	push   $0x100
80100882:	e8 0b ff ff ff       	call   80100792 <consputc>
80100887:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010088a:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100890:	a1 24 18 11 80       	mov    0x80111824,%eax
80100895:	39 c2                	cmp    %eax,%edx
80100897:	0f 84 fa 00 00 00    	je     80100997 <consoleintr+0x19e>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010089d:	a1 28 18 11 80       	mov    0x80111828,%eax
801008a2:	83 e8 01             	sub    $0x1,%eax
801008a5:	83 e0 7f             	and    $0x7f,%eax
801008a8:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008af:	3c 0a                	cmp    $0xa,%al
801008b1:	75 ba                	jne    8010086d <consoleintr+0x74>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008b3:	e9 df 00 00 00       	jmp    80100997 <consoleintr+0x19e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008b8:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008be:	a1 24 18 11 80       	mov    0x80111824,%eax
801008c3:	39 c2                	cmp    %eax,%edx
801008c5:	0f 84 cc 00 00 00    	je     80100997 <consoleintr+0x19e>
        input.e--;
801008cb:	a1 28 18 11 80       	mov    0x80111828,%eax
801008d0:	83 e8 01             	sub    $0x1,%eax
801008d3:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
801008d8:	83 ec 0c             	sub    $0xc,%esp
801008db:	68 00 01 00 00       	push   $0x100
801008e0:	e8 ad fe ff ff       	call   80100792 <consputc>
801008e5:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008e8:	e9 aa 00 00 00       	jmp    80100997 <consoleintr+0x19e>
    case C('F'):
      f = 1;
801008ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
801008f4:	e9 9e 00 00 00       	jmp    80100997 <consoleintr+0x19e>
    case C('R'):
      r = 1;
801008f9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
      break;
80100900:	e9 92 00 00 00       	jmp    80100997 <consoleintr+0x19e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100905:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100909:	0f 84 87 00 00 00    	je     80100996 <consoleintr+0x19d>
8010090f:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100915:	a1 20 18 11 80       	mov    0x80111820,%eax
8010091a:	29 c2                	sub    %eax,%edx
8010091c:	89 d0                	mov    %edx,%eax
8010091e:	83 f8 7f             	cmp    $0x7f,%eax
80100921:	77 73                	ja     80100996 <consoleintr+0x19d>
        c = (c == '\r') ? '\n' : c;
80100923:	83 7d e8 0d          	cmpl   $0xd,-0x18(%ebp)
80100927:	74 05                	je     8010092e <consoleintr+0x135>
80100929:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010092c:	eb 05                	jmp    80100933 <consoleintr+0x13a>
8010092e:	b8 0a 00 00 00       	mov    $0xa,%eax
80100933:	89 45 e8             	mov    %eax,-0x18(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100936:	a1 28 18 11 80       	mov    0x80111828,%eax
8010093b:	8d 50 01             	lea    0x1(%eax),%edx
8010093e:	89 15 28 18 11 80    	mov    %edx,0x80111828
80100944:	83 e0 7f             	and    $0x7f,%eax
80100947:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010094a:	88 90 a0 17 11 80    	mov    %dl,-0x7feee860(%eax)
        consputc(c);
80100950:	83 ec 0c             	sub    $0xc,%esp
80100953:	ff 75 e8             	pushl  -0x18(%ebp)
80100956:	e8 37 fe ff ff       	call   80100792 <consputc>
8010095b:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010095e:	83 7d e8 0a          	cmpl   $0xa,-0x18(%ebp)
80100962:	74 18                	je     8010097c <consoleintr+0x183>
80100964:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
80100968:	74 12                	je     8010097c <consoleintr+0x183>
8010096a:	a1 28 18 11 80       	mov    0x80111828,%eax
8010096f:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100975:	83 ea 80             	sub    $0xffffff80,%edx
80100978:	39 d0                	cmp    %edx,%eax
8010097a:	75 1a                	jne    80100996 <consoleintr+0x19d>
          input.w = input.e;
8010097c:	a1 28 18 11 80       	mov    0x80111828,%eax
80100981:	a3 24 18 11 80       	mov    %eax,0x80111824
          wakeup(&input.r);
80100986:	83 ec 0c             	sub    $0xc,%esp
80100989:	68 20 18 11 80       	push   $0x80111820
8010098e:	e8 8f 47 00 00       	call   80105122 <wakeup>
80100993:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100996:	90                   	nop
  int r = 0;
//  int s = 0;
//  int z = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100997:	8b 45 08             	mov    0x8(%ebp),%eax
8010099a:	ff d0                	call   *%eax
8010099c:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010099f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801009a3:	0f 89 80 fe ff ff    	jns    80100829 <consoleintr+0x30>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009a9:	83 ec 0c             	sub    $0xc,%esp
801009ac:	68 e0 c5 10 80       	push   $0x8010c5e0
801009b1:	e8 d4 4e 00 00       	call   8010588a <release>
801009b6:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009bd:	74 05                	je     801009c4 <consoleintr+0x1cb>
    procdump();  // now call procdump() wo. cons.lock held
801009bf:	e8 1e 48 00 00       	call   801051e2 <procdump>
  }
  if(f) {
801009c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009c8:	74 05                	je     801009cf <consoleintr+0x1d6>
    free_length();
801009ca:	e8 10 4c 00 00       	call   801055df <free_length>
  }
  if(r) {
801009cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801009d3:	74 05                	je     801009da <consoleintr+0x1e1>
    display_ready();
801009d5:	e8 61 4c 00 00       	call   8010563b <display_ready>
  }
}
801009da:	90                   	nop
801009db:	c9                   	leave  
801009dc:	c3                   	ret    

801009dd <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009dd:	55                   	push   %ebp
801009de:	89 e5                	mov    %esp,%ebp
801009e0:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009e3:	83 ec 0c             	sub    $0xc,%esp
801009e6:	ff 75 08             	pushl  0x8(%ebp)
801009e9:	e8 28 11 00 00       	call   80101b16 <iunlock>
801009ee:	83 c4 10             	add    $0x10,%esp
  target = n;
801009f1:	8b 45 10             	mov    0x10(%ebp),%eax
801009f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009f7:	83 ec 0c             	sub    $0xc,%esp
801009fa:	68 e0 c5 10 80       	push   $0x8010c5e0
801009ff:	e8 1f 4e 00 00       	call   80105823 <acquire>
80100a04:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a07:	e9 ac 00 00 00       	jmp    80100ab8 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a12:	8b 40 24             	mov    0x24(%eax),%eax
80100a15:	85 c0                	test   %eax,%eax
80100a17:	74 28                	je     80100a41 <consoleread+0x64>
        release(&cons.lock);
80100a19:	83 ec 0c             	sub    $0xc,%esp
80100a1c:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a21:	e8 64 4e 00 00       	call   8010588a <release>
80100a26:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a29:	83 ec 0c             	sub    $0xc,%esp
80100a2c:	ff 75 08             	pushl  0x8(%ebp)
80100a2f:	e8 84 0f 00 00       	call   801019b8 <ilock>
80100a34:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a3c:	e9 ab 00 00 00       	jmp    80100aec <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a41:	83 ec 08             	sub    $0x8,%esp
80100a44:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a49:	68 20 18 11 80       	push   $0x80111820
80100a4e:	e8 e8 45 00 00       	call   8010503b <sleep>
80100a53:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a56:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100a5c:	a1 24 18 11 80       	mov    0x80111824,%eax
80100a61:	39 c2                	cmp    %eax,%edx
80100a63:	74 a7                	je     80100a0c <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a65:	a1 20 18 11 80       	mov    0x80111820,%eax
80100a6a:	8d 50 01             	lea    0x1(%eax),%edx
80100a6d:	89 15 20 18 11 80    	mov    %edx,0x80111820
80100a73:	83 e0 7f             	and    $0x7f,%eax
80100a76:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
80100a7d:	0f be c0             	movsbl %al,%eax
80100a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a83:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a87:	75 17                	jne    80100aa0 <consoleread+0xc3>
      if(n < target){
80100a89:	8b 45 10             	mov    0x10(%ebp),%eax
80100a8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a8f:	73 2f                	jae    80100ac0 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a91:	a1 20 18 11 80       	mov    0x80111820,%eax
80100a96:	83 e8 01             	sub    $0x1,%eax
80100a99:	a3 20 18 11 80       	mov    %eax,0x80111820
      }
      break;
80100a9e:	eb 20                	jmp    80100ac0 <consoleread+0xe3>
    }
    *dst++ = c;
80100aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100aa3:	8d 50 01             	lea    0x1(%eax),%edx
80100aa6:	89 55 0c             	mov    %edx,0xc(%ebp)
80100aa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100aac:	88 10                	mov    %dl,(%eax)
    --n;
80100aae:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100ab2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100ab6:	74 0b                	je     80100ac3 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100ab8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100abc:	7f 98                	jg     80100a56 <consoleread+0x79>
80100abe:	eb 04                	jmp    80100ac4 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100ac0:	90                   	nop
80100ac1:	eb 01                	jmp    80100ac4 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100ac3:	90                   	nop
  }
  release(&cons.lock);
80100ac4:	83 ec 0c             	sub    $0xc,%esp
80100ac7:	68 e0 c5 10 80       	push   $0x8010c5e0
80100acc:	e8 b9 4d 00 00       	call   8010588a <release>
80100ad1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ad4:	83 ec 0c             	sub    $0xc,%esp
80100ad7:	ff 75 08             	pushl  0x8(%ebp)
80100ada:	e8 d9 0e 00 00       	call   801019b8 <ilock>
80100adf:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100ae2:	8b 45 10             	mov    0x10(%ebp),%eax
80100ae5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ae8:	29 c2                	sub    %eax,%edx
80100aea:	89 d0                	mov    %edx,%eax
}
80100aec:	c9                   	leave  
80100aed:	c3                   	ret    

80100aee <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100aee:	55                   	push   %ebp
80100aef:	89 e5                	mov    %esp,%ebp
80100af1:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100af4:	83 ec 0c             	sub    $0xc,%esp
80100af7:	ff 75 08             	pushl  0x8(%ebp)
80100afa:	e8 17 10 00 00       	call   80101b16 <iunlock>
80100aff:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b02:	83 ec 0c             	sub    $0xc,%esp
80100b05:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b0a:	e8 14 4d 00 00       	call   80105823 <acquire>
80100b0f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b19:	eb 21                	jmp    80100b3c <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b21:	01 d0                	add    %edx,%eax
80100b23:	0f b6 00             	movzbl (%eax),%eax
80100b26:	0f be c0             	movsbl %al,%eax
80100b29:	0f b6 c0             	movzbl %al,%eax
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	50                   	push   %eax
80100b30:	e8 5d fc ff ff       	call   80100792 <consputc>
80100b35:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b38:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b3f:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b42:	7c d7                	jl     80100b1b <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b44:	83 ec 0c             	sub    $0xc,%esp
80100b47:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b4c:	e8 39 4d 00 00       	call   8010588a <release>
80100b51:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b54:	83 ec 0c             	sub    $0xc,%esp
80100b57:	ff 75 08             	pushl  0x8(%ebp)
80100b5a:	e8 59 0e 00 00       	call   801019b8 <ilock>
80100b5f:	83 c4 10             	add    $0x10,%esp

  return n;
80100b62:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b65:	c9                   	leave  
80100b66:	c3                   	ret    

80100b67 <consoleinit>:

void
consoleinit(void)
{
80100b67:	55                   	push   %ebp
80100b68:	89 e5                	mov    %esp,%ebp
80100b6a:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b6d:	83 ec 08             	sub    $0x8,%esp
80100b70:	68 de 8e 10 80       	push   $0x80108ede
80100b75:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b7a:	e8 82 4c 00 00       	call   80105801 <initlock>
80100b7f:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b82:	c7 05 ec 21 11 80 ee 	movl   $0x80100aee,0x801121ec
80100b89:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b8c:	c7 05 e8 21 11 80 dd 	movl   $0x801009dd,0x801121e8
80100b93:	09 10 80 
  cons.locking = 1;
80100b96:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b9d:	00 00 00 

  picenable(IRQ_KBD);
80100ba0:	83 ec 0c             	sub    $0xc,%esp
80100ba3:	6a 01                	push   $0x1
80100ba5:	e8 cf 33 00 00       	call   80103f79 <picenable>
80100baa:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100bad:	83 ec 08             	sub    $0x8,%esp
80100bb0:	6a 00                	push   $0x0
80100bb2:	6a 01                	push   $0x1
80100bb4:	e8 6f 1f 00 00       	call   80102b28 <ioapicenable>
80100bb9:	83 c4 10             	add    $0x10,%esp
}
80100bbc:	90                   	nop
80100bbd:	c9                   	leave  
80100bbe:	c3                   	ret    

80100bbf <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bbf:	55                   	push   %ebp
80100bc0:	89 e5                	mov    %esp,%ebp
80100bc2:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100bc8:	e8 ce 29 00 00       	call   8010359b <begin_op>
  if((ip = namei(path)) == 0){
80100bcd:	83 ec 0c             	sub    $0xc,%esp
80100bd0:	ff 75 08             	pushl  0x8(%ebp)
80100bd3:	e8 9e 19 00 00       	call   80102576 <namei>
80100bd8:	83 c4 10             	add    $0x10,%esp
80100bdb:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bde:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100be2:	75 0f                	jne    80100bf3 <exec+0x34>
    end_op();
80100be4:	e8 3e 2a 00 00       	call   80103627 <end_op>
    return -1;
80100be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bee:	e9 ce 03 00 00       	jmp    80100fc1 <exec+0x402>
  }
  ilock(ip);
80100bf3:	83 ec 0c             	sub    $0xc,%esp
80100bf6:	ff 75 d8             	pushl  -0x28(%ebp)
80100bf9:	e8 ba 0d 00 00       	call   801019b8 <ilock>
80100bfe:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c01:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c08:	6a 34                	push   $0x34
80100c0a:	6a 00                	push   $0x0
80100c0c:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100c12:	50                   	push   %eax
80100c13:	ff 75 d8             	pushl  -0x28(%ebp)
80100c16:	e8 0b 13 00 00       	call   80101f26 <readi>
80100c1b:	83 c4 10             	add    $0x10,%esp
80100c1e:	83 f8 33             	cmp    $0x33,%eax
80100c21:	0f 86 49 03 00 00    	jbe    80100f70 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c27:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c2d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c32:	0f 85 3b 03 00 00    	jne    80100f73 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c38:	e8 20 7a 00 00       	call   8010865d <setupkvm>
80100c3d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c40:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c44:	0f 84 2c 03 00 00    	je     80100f76 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c4a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c51:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c58:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c61:	e9 ab 00 00 00       	jmp    80100d11 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c69:	6a 20                	push   $0x20
80100c6b:	50                   	push   %eax
80100c6c:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c72:	50                   	push   %eax
80100c73:	ff 75 d8             	pushl  -0x28(%ebp)
80100c76:	e8 ab 12 00 00       	call   80101f26 <readi>
80100c7b:	83 c4 10             	add    $0x10,%esp
80100c7e:	83 f8 20             	cmp    $0x20,%eax
80100c81:	0f 85 f2 02 00 00    	jne    80100f79 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c87:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c8d:	83 f8 01             	cmp    $0x1,%eax
80100c90:	75 71                	jne    80100d03 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c92:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c98:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c9e:	39 c2                	cmp    %eax,%edx
80100ca0:	0f 82 d6 02 00 00    	jb     80100f7c <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ca6:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100cac:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100cb2:	01 d0                	add    %edx,%eax
80100cb4:	83 ec 04             	sub    $0x4,%esp
80100cb7:	50                   	push   %eax
80100cb8:	ff 75 e0             	pushl  -0x20(%ebp)
80100cbb:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cbe:	e8 41 7d 00 00       	call   80108a04 <allocuvm>
80100cc3:	83 c4 10             	add    $0x10,%esp
80100cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ccd:	0f 84 ac 02 00 00    	je     80100f7f <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cd3:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cd9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cdf:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100ce5:	83 ec 0c             	sub    $0xc,%esp
80100ce8:	52                   	push   %edx
80100ce9:	50                   	push   %eax
80100cea:	ff 75 d8             	pushl  -0x28(%ebp)
80100ced:	51                   	push   %ecx
80100cee:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf1:	e8 37 7c 00 00       	call   8010892d <loaduvm>
80100cf6:	83 c4 20             	add    $0x20,%esp
80100cf9:	85 c0                	test   %eax,%eax
80100cfb:	0f 88 81 02 00 00    	js     80100f82 <exec+0x3c3>
80100d01:	eb 01                	jmp    80100d04 <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d03:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d04:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d08:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d0b:	83 c0 20             	add    $0x20,%eax
80100d0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d11:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d18:	0f b7 c0             	movzwl %ax,%eax
80100d1b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d1e:	0f 8f 42 ff ff ff    	jg     80100c66 <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d24:	83 ec 0c             	sub    $0xc,%esp
80100d27:	ff 75 d8             	pushl  -0x28(%ebp)
80100d2a:	e8 49 0f 00 00       	call   80101c78 <iunlockput>
80100d2f:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d32:	e8 f0 28 00 00       	call   80103627 <end_op>
  ip = 0;
80100d37:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d41:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d51:	05 00 20 00 00       	add    $0x2000,%eax
80100d56:	83 ec 04             	sub    $0x4,%esp
80100d59:	50                   	push   %eax
80100d5a:	ff 75 e0             	pushl  -0x20(%ebp)
80100d5d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d60:	e8 9f 7c 00 00       	call   80108a04 <allocuvm>
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d6b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d6f:	0f 84 10 02 00 00    	je     80100f85 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d78:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d7d:	83 ec 08             	sub    $0x8,%esp
80100d80:	50                   	push   %eax
80100d81:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d84:	e8 a1 7e 00 00       	call   80108c2a <clearpteu>
80100d89:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d8f:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d92:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d99:	e9 96 00 00 00       	jmp    80100e34 <exec+0x275>
    if(argc >= MAXARG)
80100d9e:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100da2:	0f 87 e0 01 00 00    	ja     80100f88 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100da8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100db2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db5:	01 d0                	add    %edx,%eax
80100db7:	8b 00                	mov    (%eax),%eax
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	50                   	push   %eax
80100dbd:	e8 11 4f 00 00       	call   80105cd3 <strlen>
80100dc2:	83 c4 10             	add    $0x10,%esp
80100dc5:	89 c2                	mov    %eax,%edx
80100dc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dca:	29 d0                	sub    %edx,%eax
80100dcc:	83 e8 01             	sub    $0x1,%eax
80100dcf:	83 e0 fc             	and    $0xfffffffc,%eax
80100dd2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100de2:	01 d0                	add    %edx,%eax
80100de4:	8b 00                	mov    (%eax),%eax
80100de6:	83 ec 0c             	sub    $0xc,%esp
80100de9:	50                   	push   %eax
80100dea:	e8 e4 4e 00 00       	call   80105cd3 <strlen>
80100def:	83 c4 10             	add    $0x10,%esp
80100df2:	83 c0 01             	add    $0x1,%eax
80100df5:	89 c1                	mov    %eax,%ecx
80100df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e01:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e04:	01 d0                	add    %edx,%eax
80100e06:	8b 00                	mov    (%eax),%eax
80100e08:	51                   	push   %ecx
80100e09:	50                   	push   %eax
80100e0a:	ff 75 dc             	pushl  -0x24(%ebp)
80100e0d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e10:	e8 cc 7f 00 00       	call   80108de1 <copyout>
80100e15:	83 c4 10             	add    $0x10,%esp
80100e18:	85 c0                	test   %eax,%eax
80100e1a:	0f 88 6b 01 00 00    	js     80100f8b <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e23:	8d 50 03             	lea    0x3(%eax),%edx
80100e26:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e29:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e30:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e41:	01 d0                	add    %edx,%eax
80100e43:	8b 00                	mov    (%eax),%eax
80100e45:	85 c0                	test   %eax,%eax
80100e47:	0f 85 51 ff ff ff    	jne    80100d9e <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e50:	83 c0 03             	add    $0x3,%eax
80100e53:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e5a:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e5e:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e65:	ff ff ff 
  ustack[1] = argc;
80100e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6b:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e74:	83 c0 01             	add    $0x1,%eax
80100e77:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e81:	29 d0                	sub    %edx,%eax
80100e83:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8c:	83 c0 04             	add    $0x4,%eax
80100e8f:	c1 e0 02             	shl    $0x2,%eax
80100e92:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e98:	83 c0 04             	add    $0x4,%eax
80100e9b:	c1 e0 02             	shl    $0x2,%eax
80100e9e:	50                   	push   %eax
80100e9f:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100ea5:	50                   	push   %eax
80100ea6:	ff 75 dc             	pushl  -0x24(%ebp)
80100ea9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100eac:	e8 30 7f 00 00       	call   80108de1 <copyout>
80100eb1:	83 c4 10             	add    $0x10,%esp
80100eb4:	85 c0                	test   %eax,%eax
80100eb6:	0f 88 d2 00 00 00    	js     80100f8e <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80100ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ec8:	eb 17                	jmp    80100ee1 <exec+0x322>
    if(*s == '/')
80100eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ecd:	0f b6 00             	movzbl (%eax),%eax
80100ed0:	3c 2f                	cmp    $0x2f,%al
80100ed2:	75 09                	jne    80100edd <exec+0x31e>
      last = s+1;
80100ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ed7:	83 c0 01             	add    $0x1,%eax
80100eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100edd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ee4:	0f b6 00             	movzbl (%eax),%eax
80100ee7:	84 c0                	test   %al,%al
80100ee9:	75 df                	jne    80100eca <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100eeb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef1:	83 c0 6c             	add    $0x6c,%eax
80100ef4:	83 ec 04             	sub    $0x4,%esp
80100ef7:	6a 10                	push   $0x10
80100ef9:	ff 75 f0             	pushl  -0x10(%ebp)
80100efc:	50                   	push   %eax
80100efd:	e8 87 4d 00 00       	call   80105c89 <safestrcpy>
80100f02:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0b:	8b 40 04             	mov    0x4(%eax),%eax
80100f0e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f17:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f1a:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f23:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f26:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f2e:	8b 40 18             	mov    0x18(%eax),%eax
80100f31:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f37:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f40:	8b 40 18             	mov    0x18(%eax),%eax
80100f43:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f46:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f4f:	83 ec 0c             	sub    $0xc,%esp
80100f52:	50                   	push   %eax
80100f53:	e8 ec 77 00 00       	call   80108744 <switchuvm>
80100f58:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	ff 75 d0             	pushl  -0x30(%ebp)
80100f61:	e8 24 7c 00 00       	call   80108b8a <freevm>
80100f66:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f69:	b8 00 00 00 00       	mov    $0x0,%eax
80100f6e:	eb 51                	jmp    80100fc1 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f70:	90                   	nop
80100f71:	eb 1c                	jmp    80100f8f <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f73:	90                   	nop
80100f74:	eb 19                	jmp    80100f8f <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f76:	90                   	nop
80100f77:	eb 16                	jmp    80100f8f <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f79:	90                   	nop
80100f7a:	eb 13                	jmp    80100f8f <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f7c:	90                   	nop
80100f7d:	eb 10                	jmp    80100f8f <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f7f:	90                   	nop
80100f80:	eb 0d                	jmp    80100f8f <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f82:	90                   	nop
80100f83:	eb 0a                	jmp    80100f8f <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100f85:	90                   	nop
80100f86:	eb 07                	jmp    80100f8f <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f88:	90                   	nop
80100f89:	eb 04                	jmp    80100f8f <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f8b:	90                   	nop
80100f8c:	eb 01                	jmp    80100f8f <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f8e:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f8f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f93:	74 0e                	je     80100fa3 <exec+0x3e4>
    freevm(pgdir);
80100f95:	83 ec 0c             	sub    $0xc,%esp
80100f98:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f9b:	e8 ea 7b 00 00       	call   80108b8a <freevm>
80100fa0:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fa3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fa7:	74 13                	je     80100fbc <exec+0x3fd>
    iunlockput(ip);
80100fa9:	83 ec 0c             	sub    $0xc,%esp
80100fac:	ff 75 d8             	pushl  -0x28(%ebp)
80100faf:	e8 c4 0c 00 00       	call   80101c78 <iunlockput>
80100fb4:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fb7:	e8 6b 26 00 00       	call   80103627 <end_op>
  }
  return -1;
80100fbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fc1:	c9                   	leave  
80100fc2:	c3                   	ret    

80100fc3 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fc3:	55                   	push   %ebp
80100fc4:	89 e5                	mov    %esp,%ebp
80100fc6:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fc9:	83 ec 08             	sub    $0x8,%esp
80100fcc:	68 e6 8e 10 80       	push   $0x80108ee6
80100fd1:	68 40 18 11 80       	push   $0x80111840
80100fd6:	e8 26 48 00 00       	call   80105801 <initlock>
80100fdb:	83 c4 10             	add    $0x10,%esp
}
80100fde:	90                   	nop
80100fdf:	c9                   	leave  
80100fe0:	c3                   	ret    

80100fe1 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fe1:	55                   	push   %ebp
80100fe2:	89 e5                	mov    %esp,%ebp
80100fe4:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fe7:	83 ec 0c             	sub    $0xc,%esp
80100fea:	68 40 18 11 80       	push   $0x80111840
80100fef:	e8 2f 48 00 00       	call   80105823 <acquire>
80100ff4:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ff7:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
80100ffe:	eb 2d                	jmp    8010102d <filealloc+0x4c>
    if(f->ref == 0){
80101000:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101003:	8b 40 04             	mov    0x4(%eax),%eax
80101006:	85 c0                	test   %eax,%eax
80101008:	75 1f                	jne    80101029 <filealloc+0x48>
      f->ref = 1;
8010100a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010100d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	68 40 18 11 80       	push   $0x80111840
8010101c:	e8 69 48 00 00       	call   8010588a <release>
80101021:	83 c4 10             	add    $0x10,%esp
      return f;
80101024:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101027:	eb 23                	jmp    8010104c <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101029:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010102d:	b8 d4 21 11 80       	mov    $0x801121d4,%eax
80101032:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101035:	72 c9                	jb     80101000 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101037:	83 ec 0c             	sub    $0xc,%esp
8010103a:	68 40 18 11 80       	push   $0x80111840
8010103f:	e8 46 48 00 00       	call   8010588a <release>
80101044:	83 c4 10             	add    $0x10,%esp
  return 0;
80101047:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010104c:	c9                   	leave  
8010104d:	c3                   	ret    

8010104e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010104e:	55                   	push   %ebp
8010104f:	89 e5                	mov    %esp,%ebp
80101051:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	68 40 18 11 80       	push   $0x80111840
8010105c:	e8 c2 47 00 00       	call   80105823 <acquire>
80101061:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101064:	8b 45 08             	mov    0x8(%ebp),%eax
80101067:	8b 40 04             	mov    0x4(%eax),%eax
8010106a:	85 c0                	test   %eax,%eax
8010106c:	7f 0d                	jg     8010107b <filedup+0x2d>
    panic("filedup");
8010106e:	83 ec 0c             	sub    $0xc,%esp
80101071:	68 ed 8e 10 80       	push   $0x80108eed
80101076:	e8 eb f4 ff ff       	call   80100566 <panic>
  f->ref++;
8010107b:	8b 45 08             	mov    0x8(%ebp),%eax
8010107e:	8b 40 04             	mov    0x4(%eax),%eax
80101081:	8d 50 01             	lea    0x1(%eax),%edx
80101084:	8b 45 08             	mov    0x8(%ebp),%eax
80101087:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010108a:	83 ec 0c             	sub    $0xc,%esp
8010108d:	68 40 18 11 80       	push   $0x80111840
80101092:	e8 f3 47 00 00       	call   8010588a <release>
80101097:	83 c4 10             	add    $0x10,%esp
  return f;
8010109a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010109d:	c9                   	leave  
8010109e:	c3                   	ret    

8010109f <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010109f:	55                   	push   %ebp
801010a0:	89 e5                	mov    %esp,%ebp
801010a2:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010a5:	83 ec 0c             	sub    $0xc,%esp
801010a8:	68 40 18 11 80       	push   $0x80111840
801010ad:	e8 71 47 00 00       	call   80105823 <acquire>
801010b2:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b5:	8b 45 08             	mov    0x8(%ebp),%eax
801010b8:	8b 40 04             	mov    0x4(%eax),%eax
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 0d                	jg     801010cc <fileclose+0x2d>
    panic("fileclose");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 f5 8e 10 80       	push   $0x80108ef5
801010c7:	e8 9a f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
801010cc:	8b 45 08             	mov    0x8(%ebp),%eax
801010cf:	8b 40 04             	mov    0x4(%eax),%eax
801010d2:	8d 50 ff             	lea    -0x1(%eax),%edx
801010d5:	8b 45 08             	mov    0x8(%ebp),%eax
801010d8:	89 50 04             	mov    %edx,0x4(%eax)
801010db:	8b 45 08             	mov    0x8(%ebp),%eax
801010de:	8b 40 04             	mov    0x4(%eax),%eax
801010e1:	85 c0                	test   %eax,%eax
801010e3:	7e 15                	jle    801010fa <fileclose+0x5b>
    release(&ftable.lock);
801010e5:	83 ec 0c             	sub    $0xc,%esp
801010e8:	68 40 18 11 80       	push   $0x80111840
801010ed:	e8 98 47 00 00       	call   8010588a <release>
801010f2:	83 c4 10             	add    $0x10,%esp
801010f5:	e9 8b 00 00 00       	jmp    80101185 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010fa:	8b 45 08             	mov    0x8(%ebp),%eax
801010fd:	8b 10                	mov    (%eax),%edx
801010ff:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101102:	8b 50 04             	mov    0x4(%eax),%edx
80101105:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101108:	8b 50 08             	mov    0x8(%eax),%edx
8010110b:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010110e:	8b 50 0c             	mov    0xc(%eax),%edx
80101111:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101114:	8b 50 10             	mov    0x10(%eax),%edx
80101117:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010111a:	8b 40 14             	mov    0x14(%eax),%eax
8010111d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101120:	8b 45 08             	mov    0x8(%ebp),%eax
80101123:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010112a:	8b 45 08             	mov    0x8(%ebp),%eax
8010112d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	68 40 18 11 80       	push   $0x80111840
8010113b:	e8 4a 47 00 00       	call   8010588a <release>
80101140:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101143:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101146:	83 f8 01             	cmp    $0x1,%eax
80101149:	75 19                	jne    80101164 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010114b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010114f:	0f be d0             	movsbl %al,%edx
80101152:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101155:	83 ec 08             	sub    $0x8,%esp
80101158:	52                   	push   %edx
80101159:	50                   	push   %eax
8010115a:	e8 83 30 00 00       	call   801041e2 <pipeclose>
8010115f:	83 c4 10             	add    $0x10,%esp
80101162:	eb 21                	jmp    80101185 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101164:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101167:	83 f8 02             	cmp    $0x2,%eax
8010116a:	75 19                	jne    80101185 <fileclose+0xe6>
    begin_op();
8010116c:	e8 2a 24 00 00       	call   8010359b <begin_op>
    iput(ff.ip);
80101171:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	50                   	push   %eax
80101178:	e8 0b 0a 00 00       	call   80101b88 <iput>
8010117d:	83 c4 10             	add    $0x10,%esp
    end_op();
80101180:	e8 a2 24 00 00       	call   80103627 <end_op>
  }
}
80101185:	c9                   	leave  
80101186:	c3                   	ret    

80101187 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101187:	55                   	push   %ebp
80101188:	89 e5                	mov    %esp,%ebp
8010118a:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010118d:	8b 45 08             	mov    0x8(%ebp),%eax
80101190:	8b 00                	mov    (%eax),%eax
80101192:	83 f8 02             	cmp    $0x2,%eax
80101195:	75 40                	jne    801011d7 <filestat+0x50>
    ilock(f->ip);
80101197:	8b 45 08             	mov    0x8(%ebp),%eax
8010119a:	8b 40 10             	mov    0x10(%eax),%eax
8010119d:	83 ec 0c             	sub    $0xc,%esp
801011a0:	50                   	push   %eax
801011a1:	e8 12 08 00 00       	call   801019b8 <ilock>
801011a6:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011a9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ac:	8b 40 10             	mov    0x10(%eax),%eax
801011af:	83 ec 08             	sub    $0x8,%esp
801011b2:	ff 75 0c             	pushl  0xc(%ebp)
801011b5:	50                   	push   %eax
801011b6:	e8 25 0d 00 00       	call   80101ee0 <stati>
801011bb:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011be:	8b 45 08             	mov    0x8(%ebp),%eax
801011c1:	8b 40 10             	mov    0x10(%eax),%eax
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	50                   	push   %eax
801011c8:	e8 49 09 00 00       	call   80101b16 <iunlock>
801011cd:	83 c4 10             	add    $0x10,%esp
    return 0;
801011d0:	b8 00 00 00 00       	mov    $0x0,%eax
801011d5:	eb 05                	jmp    801011dc <filestat+0x55>
  }
  return -1;
801011d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011dc:	c9                   	leave  
801011dd:	c3                   	ret    

801011de <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011de:	55                   	push   %ebp
801011df:	89 e5                	mov    %esp,%ebp
801011e1:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011e4:	8b 45 08             	mov    0x8(%ebp),%eax
801011e7:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011eb:	84 c0                	test   %al,%al
801011ed:	75 0a                	jne    801011f9 <fileread+0x1b>
    return -1;
801011ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011f4:	e9 9b 00 00 00       	jmp    80101294 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011f9:	8b 45 08             	mov    0x8(%ebp),%eax
801011fc:	8b 00                	mov    (%eax),%eax
801011fe:	83 f8 01             	cmp    $0x1,%eax
80101201:	75 1a                	jne    8010121d <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101203:	8b 45 08             	mov    0x8(%ebp),%eax
80101206:	8b 40 0c             	mov    0xc(%eax),%eax
80101209:	83 ec 04             	sub    $0x4,%esp
8010120c:	ff 75 10             	pushl  0x10(%ebp)
8010120f:	ff 75 0c             	pushl  0xc(%ebp)
80101212:	50                   	push   %eax
80101213:	e8 72 31 00 00       	call   8010438a <piperead>
80101218:	83 c4 10             	add    $0x10,%esp
8010121b:	eb 77                	jmp    80101294 <fileread+0xb6>
  if(f->type == FD_INODE){
8010121d:	8b 45 08             	mov    0x8(%ebp),%eax
80101220:	8b 00                	mov    (%eax),%eax
80101222:	83 f8 02             	cmp    $0x2,%eax
80101225:	75 60                	jne    80101287 <fileread+0xa9>
    ilock(f->ip);
80101227:	8b 45 08             	mov    0x8(%ebp),%eax
8010122a:	8b 40 10             	mov    0x10(%eax),%eax
8010122d:	83 ec 0c             	sub    $0xc,%esp
80101230:	50                   	push   %eax
80101231:	e8 82 07 00 00       	call   801019b8 <ilock>
80101236:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101239:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010123c:	8b 45 08             	mov    0x8(%ebp),%eax
8010123f:	8b 50 14             	mov    0x14(%eax),%edx
80101242:	8b 45 08             	mov    0x8(%ebp),%eax
80101245:	8b 40 10             	mov    0x10(%eax),%eax
80101248:	51                   	push   %ecx
80101249:	52                   	push   %edx
8010124a:	ff 75 0c             	pushl  0xc(%ebp)
8010124d:	50                   	push   %eax
8010124e:	e8 d3 0c 00 00       	call   80101f26 <readi>
80101253:	83 c4 10             	add    $0x10,%esp
80101256:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010125d:	7e 11                	jle    80101270 <fileread+0x92>
      f->off += r;
8010125f:	8b 45 08             	mov    0x8(%ebp),%eax
80101262:	8b 50 14             	mov    0x14(%eax),%edx
80101265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101268:	01 c2                	add    %eax,%edx
8010126a:	8b 45 08             	mov    0x8(%ebp),%eax
8010126d:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	8b 40 10             	mov    0x10(%eax),%eax
80101276:	83 ec 0c             	sub    $0xc,%esp
80101279:	50                   	push   %eax
8010127a:	e8 97 08 00 00       	call   80101b16 <iunlock>
8010127f:	83 c4 10             	add    $0x10,%esp
    return r;
80101282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101285:	eb 0d                	jmp    80101294 <fileread+0xb6>
  }
  panic("fileread");
80101287:	83 ec 0c             	sub    $0xc,%esp
8010128a:	68 ff 8e 10 80       	push   $0x80108eff
8010128f:	e8 d2 f2 ff ff       	call   80100566 <panic>
}
80101294:	c9                   	leave  
80101295:	c3                   	ret    

80101296 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101296:	55                   	push   %ebp
80101297:	89 e5                	mov    %esp,%ebp
80101299:	53                   	push   %ebx
8010129a:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010129d:	8b 45 08             	mov    0x8(%ebp),%eax
801012a0:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012a4:	84 c0                	test   %al,%al
801012a6:	75 0a                	jne    801012b2 <filewrite+0x1c>
    return -1;
801012a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012ad:	e9 1b 01 00 00       	jmp    801013cd <filewrite+0x137>
  if(f->type == FD_PIPE)
801012b2:	8b 45 08             	mov    0x8(%ebp),%eax
801012b5:	8b 00                	mov    (%eax),%eax
801012b7:	83 f8 01             	cmp    $0x1,%eax
801012ba:	75 1d                	jne    801012d9 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012bc:	8b 45 08             	mov    0x8(%ebp),%eax
801012bf:	8b 40 0c             	mov    0xc(%eax),%eax
801012c2:	83 ec 04             	sub    $0x4,%esp
801012c5:	ff 75 10             	pushl  0x10(%ebp)
801012c8:	ff 75 0c             	pushl  0xc(%ebp)
801012cb:	50                   	push   %eax
801012cc:	e8 bb 2f 00 00       	call   8010428c <pipewrite>
801012d1:	83 c4 10             	add    $0x10,%esp
801012d4:	e9 f4 00 00 00       	jmp    801013cd <filewrite+0x137>
  if(f->type == FD_INODE){
801012d9:	8b 45 08             	mov    0x8(%ebp),%eax
801012dc:	8b 00                	mov    (%eax),%eax
801012de:	83 f8 02             	cmp    $0x2,%eax
801012e1:	0f 85 d9 00 00 00    	jne    801013c0 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801012e7:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012f5:	e9 a3 00 00 00       	jmp    8010139d <filewrite+0x107>
      int n1 = n - i;
801012fa:	8b 45 10             	mov    0x10(%ebp),%eax
801012fd:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101300:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101303:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101306:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101309:	7e 06                	jle    80101311 <filewrite+0x7b>
        n1 = max;
8010130b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010130e:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101311:	e8 85 22 00 00       	call   8010359b <begin_op>
      ilock(f->ip);
80101316:	8b 45 08             	mov    0x8(%ebp),%eax
80101319:	8b 40 10             	mov    0x10(%eax),%eax
8010131c:	83 ec 0c             	sub    $0xc,%esp
8010131f:	50                   	push   %eax
80101320:	e8 93 06 00 00       	call   801019b8 <ilock>
80101325:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010132b:	8b 45 08             	mov    0x8(%ebp),%eax
8010132e:	8b 50 14             	mov    0x14(%eax),%edx
80101331:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101334:	8b 45 0c             	mov    0xc(%ebp),%eax
80101337:	01 c3                	add    %eax,%ebx
80101339:	8b 45 08             	mov    0x8(%ebp),%eax
8010133c:	8b 40 10             	mov    0x10(%eax),%eax
8010133f:	51                   	push   %ecx
80101340:	52                   	push   %edx
80101341:	53                   	push   %ebx
80101342:	50                   	push   %eax
80101343:	e8 35 0d 00 00       	call   8010207d <writei>
80101348:	83 c4 10             	add    $0x10,%esp
8010134b:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010134e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101352:	7e 11                	jle    80101365 <filewrite+0xcf>
        f->off += r;
80101354:	8b 45 08             	mov    0x8(%ebp),%eax
80101357:	8b 50 14             	mov    0x14(%eax),%edx
8010135a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010135d:	01 c2                	add    %eax,%edx
8010135f:	8b 45 08             	mov    0x8(%ebp),%eax
80101362:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101365:	8b 45 08             	mov    0x8(%ebp),%eax
80101368:	8b 40 10             	mov    0x10(%eax),%eax
8010136b:	83 ec 0c             	sub    $0xc,%esp
8010136e:	50                   	push   %eax
8010136f:	e8 a2 07 00 00       	call   80101b16 <iunlock>
80101374:	83 c4 10             	add    $0x10,%esp
      end_op();
80101377:	e8 ab 22 00 00       	call   80103627 <end_op>

      if(r < 0)
8010137c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101380:	78 29                	js     801013ab <filewrite+0x115>
        break;
      if(r != n1)
80101382:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101385:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101388:	74 0d                	je     80101397 <filewrite+0x101>
        panic("short filewrite");
8010138a:	83 ec 0c             	sub    $0xc,%esp
8010138d:	68 08 8f 10 80       	push   $0x80108f08
80101392:	e8 cf f1 ff ff       	call   80100566 <panic>
      i += r;
80101397:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010139a:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010139d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a0:	3b 45 10             	cmp    0x10(%ebp),%eax
801013a3:	0f 8c 51 ff ff ff    	jl     801012fa <filewrite+0x64>
801013a9:	eb 01                	jmp    801013ac <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801013ab:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801013ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013af:	3b 45 10             	cmp    0x10(%ebp),%eax
801013b2:	75 05                	jne    801013b9 <filewrite+0x123>
801013b4:	8b 45 10             	mov    0x10(%ebp),%eax
801013b7:	eb 14                	jmp    801013cd <filewrite+0x137>
801013b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013be:	eb 0d                	jmp    801013cd <filewrite+0x137>
  }
  panic("filewrite");
801013c0:	83 ec 0c             	sub    $0xc,%esp
801013c3:	68 18 8f 10 80       	push   $0x80108f18
801013c8:	e8 99 f1 ff ff       	call   80100566 <panic>
}
801013cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013d0:	c9                   	leave  
801013d1:	c3                   	ret    

801013d2 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013d2:	55                   	push   %ebp
801013d3:	89 e5                	mov    %esp,%ebp
801013d5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801013d8:	8b 45 08             	mov    0x8(%ebp),%eax
801013db:	83 ec 08             	sub    $0x8,%esp
801013de:	6a 01                	push   $0x1
801013e0:	50                   	push   %eax
801013e1:	e8 d0 ed ff ff       	call   801001b6 <bread>
801013e6:	83 c4 10             	add    $0x10,%esp
801013e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ef:	83 c0 18             	add    $0x18,%eax
801013f2:	83 ec 04             	sub    $0x4,%esp
801013f5:	6a 1c                	push   $0x1c
801013f7:	50                   	push   %eax
801013f8:	ff 75 0c             	pushl  0xc(%ebp)
801013fb:	e8 45 47 00 00       	call   80105b45 <memmove>
80101400:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101403:	83 ec 0c             	sub    $0xc,%esp
80101406:	ff 75 f4             	pushl  -0xc(%ebp)
80101409:	e8 20 ee ff ff       	call   8010022e <brelse>
8010140e:	83 c4 10             	add    $0x10,%esp
}
80101411:	90                   	nop
80101412:	c9                   	leave  
80101413:	c3                   	ret    

80101414 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101414:	55                   	push   %ebp
80101415:	89 e5                	mov    %esp,%ebp
80101417:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010141a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010141d:	8b 45 08             	mov    0x8(%ebp),%eax
80101420:	83 ec 08             	sub    $0x8,%esp
80101423:	52                   	push   %edx
80101424:	50                   	push   %eax
80101425:	e8 8c ed ff ff       	call   801001b6 <bread>
8010142a:	83 c4 10             	add    $0x10,%esp
8010142d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101433:	83 c0 18             	add    $0x18,%eax
80101436:	83 ec 04             	sub    $0x4,%esp
80101439:	68 00 02 00 00       	push   $0x200
8010143e:	6a 00                	push   $0x0
80101440:	50                   	push   %eax
80101441:	e8 40 46 00 00       	call   80105a86 <memset>
80101446:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101449:	83 ec 0c             	sub    $0xc,%esp
8010144c:	ff 75 f4             	pushl  -0xc(%ebp)
8010144f:	e8 7f 23 00 00       	call   801037d3 <log_write>
80101454:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101457:	83 ec 0c             	sub    $0xc,%esp
8010145a:	ff 75 f4             	pushl  -0xc(%ebp)
8010145d:	e8 cc ed ff ff       	call   8010022e <brelse>
80101462:	83 c4 10             	add    $0x10,%esp
}
80101465:	90                   	nop
80101466:	c9                   	leave  
80101467:	c3                   	ret    

80101468 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101468:	55                   	push   %ebp
80101469:	89 e5                	mov    %esp,%ebp
8010146b:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010146e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101475:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010147c:	e9 13 01 00 00       	jmp    80101594 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101484:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010148a:	85 c0                	test   %eax,%eax
8010148c:	0f 48 c2             	cmovs  %edx,%eax
8010148f:	c1 f8 0c             	sar    $0xc,%eax
80101492:	89 c2                	mov    %eax,%edx
80101494:	a1 58 22 11 80       	mov    0x80112258,%eax
80101499:	01 d0                	add    %edx,%eax
8010149b:	83 ec 08             	sub    $0x8,%esp
8010149e:	50                   	push   %eax
8010149f:	ff 75 08             	pushl  0x8(%ebp)
801014a2:	e8 0f ed ff ff       	call   801001b6 <bread>
801014a7:	83 c4 10             	add    $0x10,%esp
801014aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014b4:	e9 a6 00 00 00       	jmp    8010155f <balloc+0xf7>
      m = 1 << (bi % 8);
801014b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014bc:	99                   	cltd   
801014bd:	c1 ea 1d             	shr    $0x1d,%edx
801014c0:	01 d0                	add    %edx,%eax
801014c2:	83 e0 07             	and    $0x7,%eax
801014c5:	29 d0                	sub    %edx,%eax
801014c7:	ba 01 00 00 00       	mov    $0x1,%edx
801014cc:	89 c1                	mov    %eax,%ecx
801014ce:	d3 e2                	shl    %cl,%edx
801014d0:	89 d0                	mov    %edx,%eax
801014d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d8:	8d 50 07             	lea    0x7(%eax),%edx
801014db:	85 c0                	test   %eax,%eax
801014dd:	0f 48 c2             	cmovs  %edx,%eax
801014e0:	c1 f8 03             	sar    $0x3,%eax
801014e3:	89 c2                	mov    %eax,%edx
801014e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014e8:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801014ed:	0f b6 c0             	movzbl %al,%eax
801014f0:	23 45 e8             	and    -0x18(%ebp),%eax
801014f3:	85 c0                	test   %eax,%eax
801014f5:	75 64                	jne    8010155b <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801014f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014fa:	8d 50 07             	lea    0x7(%eax),%edx
801014fd:	85 c0                	test   %eax,%eax
801014ff:	0f 48 c2             	cmovs  %edx,%eax
80101502:	c1 f8 03             	sar    $0x3,%eax
80101505:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101508:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010150d:	89 d1                	mov    %edx,%ecx
8010150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101512:	09 ca                	or     %ecx,%edx
80101514:	89 d1                	mov    %edx,%ecx
80101516:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101519:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010151d:	83 ec 0c             	sub    $0xc,%esp
80101520:	ff 75 ec             	pushl  -0x14(%ebp)
80101523:	e8 ab 22 00 00       	call   801037d3 <log_write>
80101528:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010152b:	83 ec 0c             	sub    $0xc,%esp
8010152e:	ff 75 ec             	pushl  -0x14(%ebp)
80101531:	e8 f8 ec ff ff       	call   8010022e <brelse>
80101536:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101539:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010153c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010153f:	01 c2                	add    %eax,%edx
80101541:	8b 45 08             	mov    0x8(%ebp),%eax
80101544:	83 ec 08             	sub    $0x8,%esp
80101547:	52                   	push   %edx
80101548:	50                   	push   %eax
80101549:	e8 c6 fe ff ff       	call   80101414 <bzero>
8010154e:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101551:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101554:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101557:	01 d0                	add    %edx,%eax
80101559:	eb 57                	jmp    801015b2 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010155b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010155f:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101566:	7f 17                	jg     8010157f <balloc+0x117>
80101568:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010156b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156e:	01 d0                	add    %edx,%eax
80101570:	89 c2                	mov    %eax,%edx
80101572:	a1 40 22 11 80       	mov    0x80112240,%eax
80101577:	39 c2                	cmp    %eax,%edx
80101579:	0f 82 3a ff ff ff    	jb     801014b9 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010157f:	83 ec 0c             	sub    $0xc,%esp
80101582:	ff 75 ec             	pushl  -0x14(%ebp)
80101585:	e8 a4 ec ff ff       	call   8010022e <brelse>
8010158a:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010158d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101594:	8b 15 40 22 11 80    	mov    0x80112240,%edx
8010159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010159d:	39 c2                	cmp    %eax,%edx
8010159f:	0f 87 dc fe ff ff    	ja     80101481 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015a5:	83 ec 0c             	sub    $0xc,%esp
801015a8:	68 24 8f 10 80       	push   $0x80108f24
801015ad:	e8 b4 ef ff ff       	call   80100566 <panic>
}
801015b2:	c9                   	leave  
801015b3:	c3                   	ret    

801015b4 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015b4:	55                   	push   %ebp
801015b5:	89 e5                	mov    %esp,%ebp
801015b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015ba:	83 ec 08             	sub    $0x8,%esp
801015bd:	68 40 22 11 80       	push   $0x80112240
801015c2:	ff 75 08             	pushl  0x8(%ebp)
801015c5:	e8 08 fe ff ff       	call   801013d2 <readsb>
801015ca:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801015d0:	c1 e8 0c             	shr    $0xc,%eax
801015d3:	89 c2                	mov    %eax,%edx
801015d5:	a1 58 22 11 80       	mov    0x80112258,%eax
801015da:	01 c2                	add    %eax,%edx
801015dc:	8b 45 08             	mov    0x8(%ebp),%eax
801015df:	83 ec 08             	sub    $0x8,%esp
801015e2:	52                   	push   %edx
801015e3:	50                   	push   %eax
801015e4:	e8 cd eb ff ff       	call   801001b6 <bread>
801015e9:	83 c4 10             	add    $0x10,%esp
801015ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801015f2:	25 ff 0f 00 00       	and    $0xfff,%eax
801015f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015fd:	99                   	cltd   
801015fe:	c1 ea 1d             	shr    $0x1d,%edx
80101601:	01 d0                	add    %edx,%eax
80101603:	83 e0 07             	and    $0x7,%eax
80101606:	29 d0                	sub    %edx,%eax
80101608:	ba 01 00 00 00       	mov    $0x1,%edx
8010160d:	89 c1                	mov    %eax,%ecx
8010160f:	d3 e2                	shl    %cl,%edx
80101611:	89 d0                	mov    %edx,%eax
80101613:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101616:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101619:	8d 50 07             	lea    0x7(%eax),%edx
8010161c:	85 c0                	test   %eax,%eax
8010161e:	0f 48 c2             	cmovs  %edx,%eax
80101621:	c1 f8 03             	sar    $0x3,%eax
80101624:	89 c2                	mov    %eax,%edx
80101626:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101629:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010162e:	0f b6 c0             	movzbl %al,%eax
80101631:	23 45 ec             	and    -0x14(%ebp),%eax
80101634:	85 c0                	test   %eax,%eax
80101636:	75 0d                	jne    80101645 <bfree+0x91>
    panic("freeing free block");
80101638:	83 ec 0c             	sub    $0xc,%esp
8010163b:	68 3a 8f 10 80       	push   $0x80108f3a
80101640:	e8 21 ef ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
80101645:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101648:	8d 50 07             	lea    0x7(%eax),%edx
8010164b:	85 c0                	test   %eax,%eax
8010164d:	0f 48 c2             	cmovs  %edx,%eax
80101650:	c1 f8 03             	sar    $0x3,%eax
80101653:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101656:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010165b:	89 d1                	mov    %edx,%ecx
8010165d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101660:	f7 d2                	not    %edx
80101662:	21 ca                	and    %ecx,%edx
80101664:	89 d1                	mov    %edx,%ecx
80101666:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101669:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010166d:	83 ec 0c             	sub    $0xc,%esp
80101670:	ff 75 f4             	pushl  -0xc(%ebp)
80101673:	e8 5b 21 00 00       	call   801037d3 <log_write>
80101678:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010167b:	83 ec 0c             	sub    $0xc,%esp
8010167e:	ff 75 f4             	pushl  -0xc(%ebp)
80101681:	e8 a8 eb ff ff       	call   8010022e <brelse>
80101686:	83 c4 10             	add    $0x10,%esp
}
80101689:	90                   	nop
8010168a:	c9                   	leave  
8010168b:	c3                   	ret    

8010168c <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010168c:	55                   	push   %ebp
8010168d:	89 e5                	mov    %esp,%ebp
8010168f:	57                   	push   %edi
80101690:	56                   	push   %esi
80101691:	53                   	push   %ebx
80101692:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101695:	83 ec 08             	sub    $0x8,%esp
80101698:	68 4d 8f 10 80       	push   $0x80108f4d
8010169d:	68 60 22 11 80       	push   $0x80112260
801016a2:	e8 5a 41 00 00       	call   80105801 <initlock>
801016a7:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801016aa:	83 ec 08             	sub    $0x8,%esp
801016ad:	68 40 22 11 80       	push   $0x80112240
801016b2:	ff 75 08             	pushl  0x8(%ebp)
801016b5:	e8 18 fd ff ff       	call   801013d2 <readsb>
801016ba:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801016bd:	a1 58 22 11 80       	mov    0x80112258,%eax
801016c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801016c5:	8b 3d 54 22 11 80    	mov    0x80112254,%edi
801016cb:	8b 35 50 22 11 80    	mov    0x80112250,%esi
801016d1:	8b 1d 4c 22 11 80    	mov    0x8011224c,%ebx
801016d7:	8b 0d 48 22 11 80    	mov    0x80112248,%ecx
801016dd:	8b 15 44 22 11 80    	mov    0x80112244,%edx
801016e3:	a1 40 22 11 80       	mov    0x80112240,%eax
801016e8:	ff 75 e4             	pushl  -0x1c(%ebp)
801016eb:	57                   	push   %edi
801016ec:	56                   	push   %esi
801016ed:	53                   	push   %ebx
801016ee:	51                   	push   %ecx
801016ef:	52                   	push   %edx
801016f0:	50                   	push   %eax
801016f1:	68 54 8f 10 80       	push   $0x80108f54
801016f6:	e8 cb ec ff ff       	call   801003c6 <cprintf>
801016fb:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801016fe:	90                   	nop
801016ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101702:	5b                   	pop    %ebx
80101703:	5e                   	pop    %esi
80101704:	5f                   	pop    %edi
80101705:	5d                   	pop    %ebp
80101706:	c3                   	ret    

80101707 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101707:	55                   	push   %ebp
80101708:	89 e5                	mov    %esp,%ebp
8010170a:	83 ec 28             	sub    $0x28,%esp
8010170d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101710:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101714:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010171b:	e9 9e 00 00 00       	jmp    801017be <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101723:	c1 e8 03             	shr    $0x3,%eax
80101726:	89 c2                	mov    %eax,%edx
80101728:	a1 54 22 11 80       	mov    0x80112254,%eax
8010172d:	01 d0                	add    %edx,%eax
8010172f:	83 ec 08             	sub    $0x8,%esp
80101732:	50                   	push   %eax
80101733:	ff 75 08             	pushl  0x8(%ebp)
80101736:	e8 7b ea ff ff       	call   801001b6 <bread>
8010173b:	83 c4 10             	add    $0x10,%esp
8010173e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101744:	8d 50 18             	lea    0x18(%eax),%edx
80101747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010174a:	83 e0 07             	and    $0x7,%eax
8010174d:	c1 e0 06             	shl    $0x6,%eax
80101750:	01 d0                	add    %edx,%eax
80101752:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101755:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101758:	0f b7 00             	movzwl (%eax),%eax
8010175b:	66 85 c0             	test   %ax,%ax
8010175e:	75 4c                	jne    801017ac <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101760:	83 ec 04             	sub    $0x4,%esp
80101763:	6a 40                	push   $0x40
80101765:	6a 00                	push   $0x0
80101767:	ff 75 ec             	pushl  -0x14(%ebp)
8010176a:	e8 17 43 00 00       	call   80105a86 <memset>
8010176f:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101772:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101775:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101779:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010177c:	83 ec 0c             	sub    $0xc,%esp
8010177f:	ff 75 f0             	pushl  -0x10(%ebp)
80101782:	e8 4c 20 00 00       	call   801037d3 <log_write>
80101787:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010178a:	83 ec 0c             	sub    $0xc,%esp
8010178d:	ff 75 f0             	pushl  -0x10(%ebp)
80101790:	e8 99 ea ff ff       	call   8010022e <brelse>
80101795:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179b:	83 ec 08             	sub    $0x8,%esp
8010179e:	50                   	push   %eax
8010179f:	ff 75 08             	pushl  0x8(%ebp)
801017a2:	e8 f8 00 00 00       	call   8010189f <iget>
801017a7:	83 c4 10             	add    $0x10,%esp
801017aa:	eb 30                	jmp    801017dc <ialloc+0xd5>
    }
    brelse(bp);
801017ac:	83 ec 0c             	sub    $0xc,%esp
801017af:	ff 75 f0             	pushl  -0x10(%ebp)
801017b2:	e8 77 ea ff ff       	call   8010022e <brelse>
801017b7:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801017ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801017be:	8b 15 48 22 11 80    	mov    0x80112248,%edx
801017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c7:	39 c2                	cmp    %eax,%edx
801017c9:	0f 87 51 ff ff ff    	ja     80101720 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801017cf:	83 ec 0c             	sub    $0xc,%esp
801017d2:	68 a7 8f 10 80       	push   $0x80108fa7
801017d7:	e8 8a ed ff ff       	call   80100566 <panic>
}
801017dc:	c9                   	leave  
801017dd:	c3                   	ret    

801017de <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801017de:	55                   	push   %ebp
801017df:	89 e5                	mov    %esp,%ebp
801017e1:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e4:	8b 45 08             	mov    0x8(%ebp),%eax
801017e7:	8b 40 04             	mov    0x4(%eax),%eax
801017ea:	c1 e8 03             	shr    $0x3,%eax
801017ed:	89 c2                	mov    %eax,%edx
801017ef:	a1 54 22 11 80       	mov    0x80112254,%eax
801017f4:	01 c2                	add    %eax,%edx
801017f6:	8b 45 08             	mov    0x8(%ebp),%eax
801017f9:	8b 00                	mov    (%eax),%eax
801017fb:	83 ec 08             	sub    $0x8,%esp
801017fe:	52                   	push   %edx
801017ff:	50                   	push   %eax
80101800:	e8 b1 e9 ff ff       	call   801001b6 <bread>
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010180b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180e:	8d 50 18             	lea    0x18(%eax),%edx
80101811:	8b 45 08             	mov    0x8(%ebp),%eax
80101814:	8b 40 04             	mov    0x4(%eax),%eax
80101817:	83 e0 07             	and    $0x7,%eax
8010181a:	c1 e0 06             	shl    $0x6,%eax
8010181d:	01 d0                	add    %edx,%eax
8010181f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101822:	8b 45 08             	mov    0x8(%ebp),%eax
80101825:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101829:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010182c:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010182f:	8b 45 08             	mov    0x8(%ebp),%eax
80101832:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101836:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101839:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010183d:	8b 45 08             	mov    0x8(%ebp),%eax
80101840:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101844:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101847:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010184b:	8b 45 08             	mov    0x8(%ebp),%eax
8010184e:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101852:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101855:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101859:	8b 45 08             	mov    0x8(%ebp),%eax
8010185c:	8b 50 18             	mov    0x18(%eax),%edx
8010185f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101862:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101865:	8b 45 08             	mov    0x8(%ebp),%eax
80101868:	8d 50 1c             	lea    0x1c(%eax),%edx
8010186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010186e:	83 c0 0c             	add    $0xc,%eax
80101871:	83 ec 04             	sub    $0x4,%esp
80101874:	6a 34                	push   $0x34
80101876:	52                   	push   %edx
80101877:	50                   	push   %eax
80101878:	e8 c8 42 00 00       	call   80105b45 <memmove>
8010187d:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101880:	83 ec 0c             	sub    $0xc,%esp
80101883:	ff 75 f4             	pushl  -0xc(%ebp)
80101886:	e8 48 1f 00 00       	call   801037d3 <log_write>
8010188b:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010188e:	83 ec 0c             	sub    $0xc,%esp
80101891:	ff 75 f4             	pushl  -0xc(%ebp)
80101894:	e8 95 e9 ff ff       	call   8010022e <brelse>
80101899:	83 c4 10             	add    $0x10,%esp
}
8010189c:	90                   	nop
8010189d:	c9                   	leave  
8010189e:	c3                   	ret    

8010189f <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010189f:	55                   	push   %ebp
801018a0:	89 e5                	mov    %esp,%ebp
801018a2:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018a5:	83 ec 0c             	sub    $0xc,%esp
801018a8:	68 60 22 11 80       	push   $0x80112260
801018ad:	e8 71 3f 00 00       	call   80105823 <acquire>
801018b2:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801018b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018bc:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
801018c3:	eb 5d                	jmp    80101922 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c8:	8b 40 08             	mov    0x8(%eax),%eax
801018cb:	85 c0                	test   %eax,%eax
801018cd:	7e 39                	jle    80101908 <iget+0x69>
801018cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d2:	8b 00                	mov    (%eax),%eax
801018d4:	3b 45 08             	cmp    0x8(%ebp),%eax
801018d7:	75 2f                	jne    80101908 <iget+0x69>
801018d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018dc:	8b 40 04             	mov    0x4(%eax),%eax
801018df:	3b 45 0c             	cmp    0xc(%ebp),%eax
801018e2:	75 24                	jne    80101908 <iget+0x69>
      ip->ref++;
801018e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e7:	8b 40 08             	mov    0x8(%eax),%eax
801018ea:	8d 50 01             	lea    0x1(%eax),%edx
801018ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f0:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018f3:	83 ec 0c             	sub    $0xc,%esp
801018f6:	68 60 22 11 80       	push   $0x80112260
801018fb:	e8 8a 3f 00 00       	call   8010588a <release>
80101900:	83 c4 10             	add    $0x10,%esp
      return ip;
80101903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101906:	eb 74                	jmp    8010197c <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101908:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010190c:	75 10                	jne    8010191e <iget+0x7f>
8010190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101911:	8b 40 08             	mov    0x8(%eax),%eax
80101914:	85 c0                	test   %eax,%eax
80101916:	75 06                	jne    8010191e <iget+0x7f>
      empty = ip;
80101918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010191e:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101922:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
80101929:	72 9a                	jb     801018c5 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010192b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010192f:	75 0d                	jne    8010193e <iget+0x9f>
    panic("iget: no inodes");
80101931:	83 ec 0c             	sub    $0xc,%esp
80101934:	68 b9 8f 10 80       	push   $0x80108fb9
80101939:	e8 28 ec ff ff       	call   80100566 <panic>

  ip = empty;
8010193e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101941:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101947:	8b 55 08             	mov    0x8(%ebp),%edx
8010194a:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010194f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101952:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101958:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010195f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101962:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101969:	83 ec 0c             	sub    $0xc,%esp
8010196c:	68 60 22 11 80       	push   $0x80112260
80101971:	e8 14 3f 00 00       	call   8010588a <release>
80101976:	83 c4 10             	add    $0x10,%esp

  return ip;
80101979:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010197c:	c9                   	leave  
8010197d:	c3                   	ret    

8010197e <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010197e:	55                   	push   %ebp
8010197f:	89 e5                	mov    %esp,%ebp
80101981:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101984:	83 ec 0c             	sub    $0xc,%esp
80101987:	68 60 22 11 80       	push   $0x80112260
8010198c:	e8 92 3e 00 00       	call   80105823 <acquire>
80101991:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101994:	8b 45 08             	mov    0x8(%ebp),%eax
80101997:	8b 40 08             	mov    0x8(%eax),%eax
8010199a:	8d 50 01             	lea    0x1(%eax),%edx
8010199d:	8b 45 08             	mov    0x8(%ebp),%eax
801019a0:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019a3:	83 ec 0c             	sub    $0xc,%esp
801019a6:	68 60 22 11 80       	push   $0x80112260
801019ab:	e8 da 3e 00 00       	call   8010588a <release>
801019b0:	83 c4 10             	add    $0x10,%esp
  return ip;
801019b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019b6:	c9                   	leave  
801019b7:	c3                   	ret    

801019b8 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801019b8:	55                   	push   %ebp
801019b9:	89 e5                	mov    %esp,%ebp
801019bb:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801019be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019c2:	74 0a                	je     801019ce <ilock+0x16>
801019c4:	8b 45 08             	mov    0x8(%ebp),%eax
801019c7:	8b 40 08             	mov    0x8(%eax),%eax
801019ca:	85 c0                	test   %eax,%eax
801019cc:	7f 0d                	jg     801019db <ilock+0x23>
    panic("ilock");
801019ce:	83 ec 0c             	sub    $0xc,%esp
801019d1:	68 c9 8f 10 80       	push   $0x80108fc9
801019d6:	e8 8b eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
801019db:	83 ec 0c             	sub    $0xc,%esp
801019de:	68 60 22 11 80       	push   $0x80112260
801019e3:	e8 3b 3e 00 00       	call   80105823 <acquire>
801019e8:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801019eb:	eb 13                	jmp    80101a00 <ilock+0x48>
    sleep(ip, &icache.lock);
801019ed:	83 ec 08             	sub    $0x8,%esp
801019f0:	68 60 22 11 80       	push   $0x80112260
801019f5:	ff 75 08             	pushl  0x8(%ebp)
801019f8:	e8 3e 36 00 00       	call   8010503b <sleep>
801019fd:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101a00:	8b 45 08             	mov    0x8(%ebp),%eax
80101a03:	8b 40 0c             	mov    0xc(%eax),%eax
80101a06:	83 e0 01             	and    $0x1,%eax
80101a09:	85 c0                	test   %eax,%eax
80101a0b:	75 e0                	jne    801019ed <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	8b 40 0c             	mov    0xc(%eax),%eax
80101a13:	83 c8 01             	or     $0x1,%eax
80101a16:	89 c2                	mov    %eax,%edx
80101a18:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1b:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a1e:	83 ec 0c             	sub    $0xc,%esp
80101a21:	68 60 22 11 80       	push   $0x80112260
80101a26:	e8 5f 3e 00 00       	call   8010588a <release>
80101a2b:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a31:	8b 40 0c             	mov    0xc(%eax),%eax
80101a34:	83 e0 02             	and    $0x2,%eax
80101a37:	85 c0                	test   %eax,%eax
80101a39:	0f 85 d4 00 00 00    	jne    80101b13 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a42:	8b 40 04             	mov    0x4(%eax),%eax
80101a45:	c1 e8 03             	shr    $0x3,%eax
80101a48:	89 c2                	mov    %eax,%edx
80101a4a:	a1 54 22 11 80       	mov    0x80112254,%eax
80101a4f:	01 c2                	add    %eax,%edx
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	8b 00                	mov    (%eax),%eax
80101a56:	83 ec 08             	sub    $0x8,%esp
80101a59:	52                   	push   %edx
80101a5a:	50                   	push   %eax
80101a5b:	e8 56 e7 ff ff       	call   801001b6 <bread>
80101a60:	83 c4 10             	add    $0x10,%esp
80101a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a69:	8d 50 18             	lea    0x18(%eax),%edx
80101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6f:	8b 40 04             	mov    0x4(%eax),%eax
80101a72:	83 e0 07             	and    $0x7,%eax
80101a75:	c1 e0 06             	shl    $0x6,%eax
80101a78:	01 d0                	add    %edx,%eax
80101a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a80:	0f b7 10             	movzwl (%eax),%edx
80101a83:	8b 45 08             	mov    0x8(%ebp),%eax
80101a86:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a8d:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a91:	8b 45 08             	mov    0x8(%ebp),%eax
80101a94:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a9b:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa2:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa9:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101aad:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab0:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab7:	8b 50 08             	mov    0x8(%eax),%edx
80101aba:	8b 45 08             	mov    0x8(%ebp),%eax
80101abd:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ac3:	8d 50 0c             	lea    0xc(%eax),%edx
80101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac9:	83 c0 1c             	add    $0x1c,%eax
80101acc:	83 ec 04             	sub    $0x4,%esp
80101acf:	6a 34                	push   $0x34
80101ad1:	52                   	push   %edx
80101ad2:	50                   	push   %eax
80101ad3:	e8 6d 40 00 00       	call   80105b45 <memmove>
80101ad8:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101adb:	83 ec 0c             	sub    $0xc,%esp
80101ade:	ff 75 f4             	pushl  -0xc(%ebp)
80101ae1:	e8 48 e7 ff ff       	call   8010022e <brelse>
80101ae6:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aec:	8b 40 0c             	mov    0xc(%eax),%eax
80101aef:	83 c8 02             	or     $0x2,%eax
80101af2:	89 c2                	mov    %eax,%edx
80101af4:	8b 45 08             	mov    0x8(%ebp),%eax
80101af7:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101afa:	8b 45 08             	mov    0x8(%ebp),%eax
80101afd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b01:	66 85 c0             	test   %ax,%ax
80101b04:	75 0d                	jne    80101b13 <ilock+0x15b>
      panic("ilock: no type");
80101b06:	83 ec 0c             	sub    $0xc,%esp
80101b09:	68 cf 8f 10 80       	push   $0x80108fcf
80101b0e:	e8 53 ea ff ff       	call   80100566 <panic>
  }
}
80101b13:	90                   	nop
80101b14:	c9                   	leave  
80101b15:	c3                   	ret    

80101b16 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b16:	55                   	push   %ebp
80101b17:	89 e5                	mov    %esp,%ebp
80101b19:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b20:	74 17                	je     80101b39 <iunlock+0x23>
80101b22:	8b 45 08             	mov    0x8(%ebp),%eax
80101b25:	8b 40 0c             	mov    0xc(%eax),%eax
80101b28:	83 e0 01             	and    $0x1,%eax
80101b2b:	85 c0                	test   %eax,%eax
80101b2d:	74 0a                	je     80101b39 <iunlock+0x23>
80101b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b32:	8b 40 08             	mov    0x8(%eax),%eax
80101b35:	85 c0                	test   %eax,%eax
80101b37:	7f 0d                	jg     80101b46 <iunlock+0x30>
    panic("iunlock");
80101b39:	83 ec 0c             	sub    $0xc,%esp
80101b3c:	68 de 8f 10 80       	push   $0x80108fde
80101b41:	e8 20 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	68 60 22 11 80       	push   $0x80112260
80101b4e:	e8 d0 3c 00 00       	call   80105823 <acquire>
80101b53:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101b56:	8b 45 08             	mov    0x8(%ebp),%eax
80101b59:	8b 40 0c             	mov    0xc(%eax),%eax
80101b5c:	83 e0 fe             	and    $0xfffffffe,%eax
80101b5f:	89 c2                	mov    %eax,%edx
80101b61:	8b 45 08             	mov    0x8(%ebp),%eax
80101b64:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b67:	83 ec 0c             	sub    $0xc,%esp
80101b6a:	ff 75 08             	pushl  0x8(%ebp)
80101b6d:	e8 b0 35 00 00       	call   80105122 <wakeup>
80101b72:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101b75:	83 ec 0c             	sub    $0xc,%esp
80101b78:	68 60 22 11 80       	push   $0x80112260
80101b7d:	e8 08 3d 00 00       	call   8010588a <release>
80101b82:	83 c4 10             	add    $0x10,%esp
}
80101b85:	90                   	nop
80101b86:	c9                   	leave  
80101b87:	c3                   	ret    

80101b88 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b88:	55                   	push   %ebp
80101b89:	89 e5                	mov    %esp,%ebp
80101b8b:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b8e:	83 ec 0c             	sub    $0xc,%esp
80101b91:	68 60 22 11 80       	push   $0x80112260
80101b96:	e8 88 3c 00 00       	call   80105823 <acquire>
80101b9b:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba1:	8b 40 08             	mov    0x8(%eax),%eax
80101ba4:	83 f8 01             	cmp    $0x1,%eax
80101ba7:	0f 85 a9 00 00 00    	jne    80101c56 <iput+0xce>
80101bad:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb0:	8b 40 0c             	mov    0xc(%eax),%eax
80101bb3:	83 e0 02             	and    $0x2,%eax
80101bb6:	85 c0                	test   %eax,%eax
80101bb8:	0f 84 98 00 00 00    	je     80101c56 <iput+0xce>
80101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101bc5:	66 85 c0             	test   %ax,%ax
80101bc8:	0f 85 88 00 00 00    	jne    80101c56 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101bce:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd1:	8b 40 0c             	mov    0xc(%eax),%eax
80101bd4:	83 e0 01             	and    $0x1,%eax
80101bd7:	85 c0                	test   %eax,%eax
80101bd9:	74 0d                	je     80101be8 <iput+0x60>
      panic("iput busy");
80101bdb:	83 ec 0c             	sub    $0xc,%esp
80101bde:	68 e6 8f 10 80       	push   $0x80108fe6
80101be3:	e8 7e e9 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101be8:	8b 45 08             	mov    0x8(%ebp),%eax
80101beb:	8b 40 0c             	mov    0xc(%eax),%eax
80101bee:	83 c8 01             	or     $0x1,%eax
80101bf1:	89 c2                	mov    %eax,%edx
80101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf6:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101bf9:	83 ec 0c             	sub    $0xc,%esp
80101bfc:	68 60 22 11 80       	push   $0x80112260
80101c01:	e8 84 3c 00 00       	call   8010588a <release>
80101c06:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c09:	83 ec 0c             	sub    $0xc,%esp
80101c0c:	ff 75 08             	pushl  0x8(%ebp)
80101c0f:	e8 a8 01 00 00       	call   80101dbc <itrunc>
80101c14:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c17:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1a:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c20:	83 ec 0c             	sub    $0xc,%esp
80101c23:	ff 75 08             	pushl  0x8(%ebp)
80101c26:	e8 b3 fb ff ff       	call   801017de <iupdate>
80101c2b:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c2e:	83 ec 0c             	sub    $0xc,%esp
80101c31:	68 60 22 11 80       	push   $0x80112260
80101c36:	e8 e8 3b 00 00       	call   80105823 <acquire>
80101c3b:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c41:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c48:	83 ec 0c             	sub    $0xc,%esp
80101c4b:	ff 75 08             	pushl  0x8(%ebp)
80101c4e:	e8 cf 34 00 00       	call   80105122 <wakeup>
80101c53:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101c56:	8b 45 08             	mov    0x8(%ebp),%eax
80101c59:	8b 40 08             	mov    0x8(%eax),%eax
80101c5c:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c62:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c65:	83 ec 0c             	sub    $0xc,%esp
80101c68:	68 60 22 11 80       	push   $0x80112260
80101c6d:	e8 18 3c 00 00       	call   8010588a <release>
80101c72:	83 c4 10             	add    $0x10,%esp
}
80101c75:	90                   	nop
80101c76:	c9                   	leave  
80101c77:	c3                   	ret    

80101c78 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c78:	55                   	push   %ebp
80101c79:	89 e5                	mov    %esp,%ebp
80101c7b:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
80101c81:	ff 75 08             	pushl  0x8(%ebp)
80101c84:	e8 8d fe ff ff       	call   80101b16 <iunlock>
80101c89:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	ff 75 08             	pushl  0x8(%ebp)
80101c92:	e8 f1 fe ff ff       	call   80101b88 <iput>
80101c97:	83 c4 10             	add    $0x10,%esp
}
80101c9a:	90                   	nop
80101c9b:	c9                   	leave  
80101c9c:	c3                   	ret    

80101c9d <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c9d:	55                   	push   %ebp
80101c9e:	89 e5                	mov    %esp,%ebp
80101ca0:	53                   	push   %ebx
80101ca1:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101ca4:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101ca8:	77 42                	ja     80101cec <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101caa:	8b 45 08             	mov    0x8(%ebp),%eax
80101cad:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cb0:	83 c2 04             	add    $0x4,%edx
80101cb3:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cbe:	75 24                	jne    80101ce4 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc3:	8b 00                	mov    (%eax),%eax
80101cc5:	83 ec 0c             	sub    $0xc,%esp
80101cc8:	50                   	push   %eax
80101cc9:	e8 9a f7 ff ff       	call   80101468 <balloc>
80101cce:	83 c4 10             	add    $0x10,%esp
80101cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cda:	8d 4a 04             	lea    0x4(%edx),%ecx
80101cdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ce0:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ce7:	e9 cb 00 00 00       	jmp    80101db7 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101cec:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101cf0:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101cf4:	0f 87 b0 00 00 00    	ja     80101daa <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfd:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d07:	75 1d                	jne    80101d26 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d09:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0c:	8b 00                	mov    (%eax),%eax
80101d0e:	83 ec 0c             	sub    $0xc,%esp
80101d11:	50                   	push   %eax
80101d12:	e8 51 f7 ff ff       	call   80101468 <balloc>
80101d17:	83 c4 10             	add    $0x10,%esp
80101d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d23:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d26:	8b 45 08             	mov    0x8(%ebp),%eax
80101d29:	8b 00                	mov    (%eax),%eax
80101d2b:	83 ec 08             	sub    $0x8,%esp
80101d2e:	ff 75 f4             	pushl  -0xc(%ebp)
80101d31:	50                   	push   %eax
80101d32:	e8 7f e4 ff ff       	call   801001b6 <bread>
80101d37:	83 c4 10             	add    $0x10,%esp
80101d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d40:	83 c0 18             	add    $0x18,%eax
80101d43:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d49:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d53:	01 d0                	add    %edx,%eax
80101d55:	8b 00                	mov    (%eax),%eax
80101d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d5e:	75 37                	jne    80101d97 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101d60:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d6d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d70:	8b 45 08             	mov    0x8(%ebp),%eax
80101d73:	8b 00                	mov    (%eax),%eax
80101d75:	83 ec 0c             	sub    $0xc,%esp
80101d78:	50                   	push   %eax
80101d79:	e8 ea f6 ff ff       	call   80101468 <balloc>
80101d7e:	83 c4 10             	add    $0x10,%esp
80101d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d87:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d89:	83 ec 0c             	sub    $0xc,%esp
80101d8c:	ff 75 f0             	pushl  -0x10(%ebp)
80101d8f:	e8 3f 1a 00 00       	call   801037d3 <log_write>
80101d94:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d97:	83 ec 0c             	sub    $0xc,%esp
80101d9a:	ff 75 f0             	pushl  -0x10(%ebp)
80101d9d:	e8 8c e4 ff ff       	call   8010022e <brelse>
80101da2:	83 c4 10             	add    $0x10,%esp
    return addr;
80101da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101da8:	eb 0d                	jmp    80101db7 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101daa:	83 ec 0c             	sub    $0xc,%esp
80101dad:	68 f0 8f 10 80       	push   $0x80108ff0
80101db2:	e8 af e7 ff ff       	call   80100566 <panic>
}
80101db7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101dba:	c9                   	leave  
80101dbb:	c3                   	ret    

80101dbc <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101dbc:	55                   	push   %ebp
80101dbd:	89 e5                	mov    %esp,%ebp
80101dbf:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101dc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101dc9:	eb 45                	jmp    80101e10 <itrunc+0x54>
    if(ip->addrs[i]){
80101dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dd1:	83 c2 04             	add    $0x4,%edx
80101dd4:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101dd8:	85 c0                	test   %eax,%eax
80101dda:	74 30                	je     80101e0c <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101de2:	83 c2 04             	add    $0x4,%edx
80101de5:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101de9:	8b 55 08             	mov    0x8(%ebp),%edx
80101dec:	8b 12                	mov    (%edx),%edx
80101dee:	83 ec 08             	sub    $0x8,%esp
80101df1:	50                   	push   %eax
80101df2:	52                   	push   %edx
80101df3:	e8 bc f7 ff ff       	call   801015b4 <bfree>
80101df8:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e01:	83 c2 04             	add    $0x4,%edx
80101e04:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e0b:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e0c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e10:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e14:	7e b5                	jle    80101dcb <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101e16:	8b 45 08             	mov    0x8(%ebp),%eax
80101e19:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e1c:	85 c0                	test   %eax,%eax
80101e1e:	0f 84 a1 00 00 00    	je     80101ec5 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e24:	8b 45 08             	mov    0x8(%ebp),%eax
80101e27:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2d:	8b 00                	mov    (%eax),%eax
80101e2f:	83 ec 08             	sub    $0x8,%esp
80101e32:	52                   	push   %edx
80101e33:	50                   	push   %eax
80101e34:	e8 7d e3 ff ff       	call   801001b6 <bread>
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e42:	83 c0 18             	add    $0x18,%eax
80101e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e48:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e4f:	eb 3c                	jmp    80101e8d <itrunc+0xd1>
      if(a[j])
80101e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e5e:	01 d0                	add    %edx,%eax
80101e60:	8b 00                	mov    (%eax),%eax
80101e62:	85 c0                	test   %eax,%eax
80101e64:	74 23                	je     80101e89 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e70:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e73:	01 d0                	add    %edx,%eax
80101e75:	8b 00                	mov    (%eax),%eax
80101e77:	8b 55 08             	mov    0x8(%ebp),%edx
80101e7a:	8b 12                	mov    (%edx),%edx
80101e7c:	83 ec 08             	sub    $0x8,%esp
80101e7f:	50                   	push   %eax
80101e80:	52                   	push   %edx
80101e81:	e8 2e f7 ff ff       	call   801015b4 <bfree>
80101e86:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e89:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e90:	83 f8 7f             	cmp    $0x7f,%eax
80101e93:	76 bc                	jbe    80101e51 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	ff 75 ec             	pushl  -0x14(%ebp)
80101e9b:	e8 8e e3 ff ff       	call   8010022e <brelse>
80101ea0:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ea3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea6:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ea9:	8b 55 08             	mov    0x8(%ebp),%edx
80101eac:	8b 12                	mov    (%edx),%edx
80101eae:	83 ec 08             	sub    $0x8,%esp
80101eb1:	50                   	push   %eax
80101eb2:	52                   	push   %edx
80101eb3:	e8 fc f6 ff ff       	call   801015b4 <bfree>
80101eb8:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101ebb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebe:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec8:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101ecf:	83 ec 0c             	sub    $0xc,%esp
80101ed2:	ff 75 08             	pushl  0x8(%ebp)
80101ed5:	e8 04 f9 ff ff       	call   801017de <iupdate>
80101eda:	83 c4 10             	add    $0x10,%esp
}
80101edd:	90                   	nop
80101ede:	c9                   	leave  
80101edf:	c3                   	ret    

80101ee0 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee6:	8b 00                	mov    (%eax),%eax
80101ee8:	89 c2                	mov    %eax,%edx
80101eea:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eed:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ef0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef3:	8b 50 04             	mov    0x4(%eax),%edx
80101ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ef9:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101efc:	8b 45 08             	mov    0x8(%ebp),%eax
80101eff:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f03:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f06:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f09:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0c:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f10:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f13:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f17:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1a:	8b 50 18             	mov    0x18(%eax),%edx
80101f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f20:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f23:	90                   	nop
80101f24:	5d                   	pop    %ebp
80101f25:	c3                   	ret    

80101f26 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f26:	55                   	push   %ebp
80101f27:	89 e5                	mov    %esp,%ebp
80101f29:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f33:	66 83 f8 03          	cmp    $0x3,%ax
80101f37:	75 5c                	jne    80101f95 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f39:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f40:	66 85 c0             	test   %ax,%ax
80101f43:	78 20                	js     80101f65 <readi+0x3f>
80101f45:	8b 45 08             	mov    0x8(%ebp),%eax
80101f48:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f4c:	66 83 f8 09          	cmp    $0x9,%ax
80101f50:	7f 13                	jg     80101f65 <readi+0x3f>
80101f52:	8b 45 08             	mov    0x8(%ebp),%eax
80101f55:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f59:	98                   	cwtl   
80101f5a:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101f61:	85 c0                	test   %eax,%eax
80101f63:	75 0a                	jne    80101f6f <readi+0x49>
      return -1;
80101f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6a:	e9 0c 01 00 00       	jmp    8010207b <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f72:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f76:	98                   	cwtl   
80101f77:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101f7e:	8b 55 14             	mov    0x14(%ebp),%edx
80101f81:	83 ec 04             	sub    $0x4,%esp
80101f84:	52                   	push   %edx
80101f85:	ff 75 0c             	pushl  0xc(%ebp)
80101f88:	ff 75 08             	pushl  0x8(%ebp)
80101f8b:	ff d0                	call   *%eax
80101f8d:	83 c4 10             	add    $0x10,%esp
80101f90:	e9 e6 00 00 00       	jmp    8010207b <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101f95:	8b 45 08             	mov    0x8(%ebp),%eax
80101f98:	8b 40 18             	mov    0x18(%eax),%eax
80101f9b:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f9e:	72 0d                	jb     80101fad <readi+0x87>
80101fa0:	8b 55 10             	mov    0x10(%ebp),%edx
80101fa3:	8b 45 14             	mov    0x14(%ebp),%eax
80101fa6:	01 d0                	add    %edx,%eax
80101fa8:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fab:	73 0a                	jae    80101fb7 <readi+0x91>
    return -1;
80101fad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fb2:	e9 c4 00 00 00       	jmp    8010207b <readi+0x155>
  if(off + n > ip->size)
80101fb7:	8b 55 10             	mov    0x10(%ebp),%edx
80101fba:	8b 45 14             	mov    0x14(%ebp),%eax
80101fbd:	01 c2                	add    %eax,%edx
80101fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc2:	8b 40 18             	mov    0x18(%eax),%eax
80101fc5:	39 c2                	cmp    %eax,%edx
80101fc7:	76 0c                	jbe    80101fd5 <readi+0xaf>
    n = ip->size - off;
80101fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcc:	8b 40 18             	mov    0x18(%eax),%eax
80101fcf:	2b 45 10             	sub    0x10(%ebp),%eax
80101fd2:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fdc:	e9 8b 00 00 00       	jmp    8010206c <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fe1:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe4:	c1 e8 09             	shr    $0x9,%eax
80101fe7:	83 ec 08             	sub    $0x8,%esp
80101fea:	50                   	push   %eax
80101feb:	ff 75 08             	pushl  0x8(%ebp)
80101fee:	e8 aa fc ff ff       	call   80101c9d <bmap>
80101ff3:	83 c4 10             	add    $0x10,%esp
80101ff6:	89 c2                	mov    %eax,%edx
80101ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffb:	8b 00                	mov    (%eax),%eax
80101ffd:	83 ec 08             	sub    $0x8,%esp
80102000:	52                   	push   %edx
80102001:	50                   	push   %eax
80102002:	e8 af e1 ff ff       	call   801001b6 <bread>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010200d:	8b 45 10             	mov    0x10(%ebp),%eax
80102010:	25 ff 01 00 00       	and    $0x1ff,%eax
80102015:	ba 00 02 00 00       	mov    $0x200,%edx
8010201a:	29 c2                	sub    %eax,%edx
8010201c:	8b 45 14             	mov    0x14(%ebp),%eax
8010201f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102022:	39 c2                	cmp    %eax,%edx
80102024:	0f 46 c2             	cmovbe %edx,%eax
80102027:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010202a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010202d:	8d 50 18             	lea    0x18(%eax),%edx
80102030:	8b 45 10             	mov    0x10(%ebp),%eax
80102033:	25 ff 01 00 00       	and    $0x1ff,%eax
80102038:	01 d0                	add    %edx,%eax
8010203a:	83 ec 04             	sub    $0x4,%esp
8010203d:	ff 75 ec             	pushl  -0x14(%ebp)
80102040:	50                   	push   %eax
80102041:	ff 75 0c             	pushl  0xc(%ebp)
80102044:	e8 fc 3a 00 00       	call   80105b45 <memmove>
80102049:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010204c:	83 ec 0c             	sub    $0xc,%esp
8010204f:	ff 75 f0             	pushl  -0x10(%ebp)
80102052:	e8 d7 e1 ff ff       	call   8010022e <brelse>
80102057:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010205a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010205d:	01 45 f4             	add    %eax,-0xc(%ebp)
80102060:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102063:	01 45 10             	add    %eax,0x10(%ebp)
80102066:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102069:	01 45 0c             	add    %eax,0xc(%ebp)
8010206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010206f:	3b 45 14             	cmp    0x14(%ebp),%eax
80102072:	0f 82 69 ff ff ff    	jb     80101fe1 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102078:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010207b:	c9                   	leave  
8010207c:	c3                   	ret    

8010207d <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010207d:	55                   	push   %ebp
8010207e:	89 e5                	mov    %esp,%ebp
80102080:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102083:	8b 45 08             	mov    0x8(%ebp),%eax
80102086:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010208a:	66 83 f8 03          	cmp    $0x3,%ax
8010208e:	75 5c                	jne    801020ec <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102090:	8b 45 08             	mov    0x8(%ebp),%eax
80102093:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102097:	66 85 c0             	test   %ax,%ax
8010209a:	78 20                	js     801020bc <writei+0x3f>
8010209c:	8b 45 08             	mov    0x8(%ebp),%eax
8010209f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020a3:	66 83 f8 09          	cmp    $0x9,%ax
801020a7:	7f 13                	jg     801020bc <writei+0x3f>
801020a9:	8b 45 08             	mov    0x8(%ebp),%eax
801020ac:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020b0:	98                   	cwtl   
801020b1:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
801020b8:	85 c0                	test   %eax,%eax
801020ba:	75 0a                	jne    801020c6 <writei+0x49>
      return -1;
801020bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c1:	e9 3d 01 00 00       	jmp    80102203 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
801020c6:	8b 45 08             	mov    0x8(%ebp),%eax
801020c9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020cd:	98                   	cwtl   
801020ce:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
801020d5:	8b 55 14             	mov    0x14(%ebp),%edx
801020d8:	83 ec 04             	sub    $0x4,%esp
801020db:	52                   	push   %edx
801020dc:	ff 75 0c             	pushl  0xc(%ebp)
801020df:	ff 75 08             	pushl  0x8(%ebp)
801020e2:	ff d0                	call   *%eax
801020e4:	83 c4 10             	add    $0x10,%esp
801020e7:	e9 17 01 00 00       	jmp    80102203 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801020ec:	8b 45 08             	mov    0x8(%ebp),%eax
801020ef:	8b 40 18             	mov    0x18(%eax),%eax
801020f2:	3b 45 10             	cmp    0x10(%ebp),%eax
801020f5:	72 0d                	jb     80102104 <writei+0x87>
801020f7:	8b 55 10             	mov    0x10(%ebp),%edx
801020fa:	8b 45 14             	mov    0x14(%ebp),%eax
801020fd:	01 d0                	add    %edx,%eax
801020ff:	3b 45 10             	cmp    0x10(%ebp),%eax
80102102:	73 0a                	jae    8010210e <writei+0x91>
    return -1;
80102104:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102109:	e9 f5 00 00 00       	jmp    80102203 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010210e:	8b 55 10             	mov    0x10(%ebp),%edx
80102111:	8b 45 14             	mov    0x14(%ebp),%eax
80102114:	01 d0                	add    %edx,%eax
80102116:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010211b:	76 0a                	jbe    80102127 <writei+0xaa>
    return -1;
8010211d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102122:	e9 dc 00 00 00       	jmp    80102203 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102127:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010212e:	e9 99 00 00 00       	jmp    801021cc <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102133:	8b 45 10             	mov    0x10(%ebp),%eax
80102136:	c1 e8 09             	shr    $0x9,%eax
80102139:	83 ec 08             	sub    $0x8,%esp
8010213c:	50                   	push   %eax
8010213d:	ff 75 08             	pushl  0x8(%ebp)
80102140:	e8 58 fb ff ff       	call   80101c9d <bmap>
80102145:	83 c4 10             	add    $0x10,%esp
80102148:	89 c2                	mov    %eax,%edx
8010214a:	8b 45 08             	mov    0x8(%ebp),%eax
8010214d:	8b 00                	mov    (%eax),%eax
8010214f:	83 ec 08             	sub    $0x8,%esp
80102152:	52                   	push   %edx
80102153:	50                   	push   %eax
80102154:	e8 5d e0 ff ff       	call   801001b6 <bread>
80102159:	83 c4 10             	add    $0x10,%esp
8010215c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010215f:	8b 45 10             	mov    0x10(%ebp),%eax
80102162:	25 ff 01 00 00       	and    $0x1ff,%eax
80102167:	ba 00 02 00 00       	mov    $0x200,%edx
8010216c:	29 c2                	sub    %eax,%edx
8010216e:	8b 45 14             	mov    0x14(%ebp),%eax
80102171:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102174:	39 c2                	cmp    %eax,%edx
80102176:	0f 46 c2             	cmovbe %edx,%eax
80102179:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010217f:	8d 50 18             	lea    0x18(%eax),%edx
80102182:	8b 45 10             	mov    0x10(%ebp),%eax
80102185:	25 ff 01 00 00       	and    $0x1ff,%eax
8010218a:	01 d0                	add    %edx,%eax
8010218c:	83 ec 04             	sub    $0x4,%esp
8010218f:	ff 75 ec             	pushl  -0x14(%ebp)
80102192:	ff 75 0c             	pushl  0xc(%ebp)
80102195:	50                   	push   %eax
80102196:	e8 aa 39 00 00       	call   80105b45 <memmove>
8010219b:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010219e:	83 ec 0c             	sub    $0xc,%esp
801021a1:	ff 75 f0             	pushl  -0x10(%ebp)
801021a4:	e8 2a 16 00 00       	call   801037d3 <log_write>
801021a9:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021ac:	83 ec 0c             	sub    $0xc,%esp
801021af:	ff 75 f0             	pushl  -0x10(%ebp)
801021b2:	e8 77 e0 ff ff       	call   8010022e <brelse>
801021b7:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021bd:	01 45 f4             	add    %eax,-0xc(%ebp)
801021c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021c3:	01 45 10             	add    %eax,0x10(%ebp)
801021c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021c9:	01 45 0c             	add    %eax,0xc(%ebp)
801021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021cf:	3b 45 14             	cmp    0x14(%ebp),%eax
801021d2:	0f 82 5b ff ff ff    	jb     80102133 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801021d8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021dc:	74 22                	je     80102200 <writei+0x183>
801021de:	8b 45 08             	mov    0x8(%ebp),%eax
801021e1:	8b 40 18             	mov    0x18(%eax),%eax
801021e4:	3b 45 10             	cmp    0x10(%ebp),%eax
801021e7:	73 17                	jae    80102200 <writei+0x183>
    ip->size = off;
801021e9:	8b 45 08             	mov    0x8(%ebp),%eax
801021ec:	8b 55 10             	mov    0x10(%ebp),%edx
801021ef:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801021f2:	83 ec 0c             	sub    $0xc,%esp
801021f5:	ff 75 08             	pushl  0x8(%ebp)
801021f8:	e8 e1 f5 ff ff       	call   801017de <iupdate>
801021fd:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102200:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102203:	c9                   	leave  
80102204:	c3                   	ret    

80102205 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102205:	55                   	push   %ebp
80102206:	89 e5                	mov    %esp,%ebp
80102208:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010220b:	83 ec 04             	sub    $0x4,%esp
8010220e:	6a 0e                	push   $0xe
80102210:	ff 75 0c             	pushl  0xc(%ebp)
80102213:	ff 75 08             	pushl  0x8(%ebp)
80102216:	e8 c0 39 00 00       	call   80105bdb <strncmp>
8010221b:	83 c4 10             	add    $0x10,%esp
}
8010221e:	c9                   	leave  
8010221f:	c3                   	ret    

80102220 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102226:	8b 45 08             	mov    0x8(%ebp),%eax
80102229:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010222d:	66 83 f8 01          	cmp    $0x1,%ax
80102231:	74 0d                	je     80102240 <dirlookup+0x20>
    panic("dirlookup not DIR");
80102233:	83 ec 0c             	sub    $0xc,%esp
80102236:	68 03 90 10 80       	push   $0x80109003
8010223b:	e8 26 e3 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102247:	eb 7b                	jmp    801022c4 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102249:	6a 10                	push   $0x10
8010224b:	ff 75 f4             	pushl  -0xc(%ebp)
8010224e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102251:	50                   	push   %eax
80102252:	ff 75 08             	pushl  0x8(%ebp)
80102255:	e8 cc fc ff ff       	call   80101f26 <readi>
8010225a:	83 c4 10             	add    $0x10,%esp
8010225d:	83 f8 10             	cmp    $0x10,%eax
80102260:	74 0d                	je     8010226f <dirlookup+0x4f>
      panic("dirlink read");
80102262:	83 ec 0c             	sub    $0xc,%esp
80102265:	68 15 90 10 80       	push   $0x80109015
8010226a:	e8 f7 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
8010226f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102273:	66 85 c0             	test   %ax,%ax
80102276:	74 47                	je     801022bf <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102278:	83 ec 08             	sub    $0x8,%esp
8010227b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010227e:	83 c0 02             	add    $0x2,%eax
80102281:	50                   	push   %eax
80102282:	ff 75 0c             	pushl  0xc(%ebp)
80102285:	e8 7b ff ff ff       	call   80102205 <namecmp>
8010228a:	83 c4 10             	add    $0x10,%esp
8010228d:	85 c0                	test   %eax,%eax
8010228f:	75 2f                	jne    801022c0 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102291:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102295:	74 08                	je     8010229f <dirlookup+0x7f>
        *poff = off;
80102297:	8b 45 10             	mov    0x10(%ebp),%eax
8010229a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010229d:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010229f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022a3:	0f b7 c0             	movzwl %ax,%eax
801022a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
801022ac:	8b 00                	mov    (%eax),%eax
801022ae:	83 ec 08             	sub    $0x8,%esp
801022b1:	ff 75 f0             	pushl  -0x10(%ebp)
801022b4:	50                   	push   %eax
801022b5:	e8 e5 f5 ff ff       	call   8010189f <iget>
801022ba:	83 c4 10             	add    $0x10,%esp
801022bd:	eb 19                	jmp    801022d8 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801022bf:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801022c0:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801022c4:	8b 45 08             	mov    0x8(%ebp),%eax
801022c7:	8b 40 18             	mov    0x18(%eax),%eax
801022ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801022cd:	0f 87 76 ff ff ff    	ja     80102249 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801022d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022d8:	c9                   	leave  
801022d9:	c3                   	ret    

801022da <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022da:	55                   	push   %ebp
801022db:	89 e5                	mov    %esp,%ebp
801022dd:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022e0:	83 ec 04             	sub    $0x4,%esp
801022e3:	6a 00                	push   $0x0
801022e5:	ff 75 0c             	pushl  0xc(%ebp)
801022e8:	ff 75 08             	pushl  0x8(%ebp)
801022eb:	e8 30 ff ff ff       	call   80102220 <dirlookup>
801022f0:	83 c4 10             	add    $0x10,%esp
801022f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022fa:	74 18                	je     80102314 <dirlink+0x3a>
    iput(ip);
801022fc:	83 ec 0c             	sub    $0xc,%esp
801022ff:	ff 75 f0             	pushl  -0x10(%ebp)
80102302:	e8 81 f8 ff ff       	call   80101b88 <iput>
80102307:	83 c4 10             	add    $0x10,%esp
    return -1;
8010230a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010230f:	e9 9c 00 00 00       	jmp    801023b0 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010231b:	eb 39                	jmp    80102356 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102320:	6a 10                	push   $0x10
80102322:	50                   	push   %eax
80102323:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102326:	50                   	push   %eax
80102327:	ff 75 08             	pushl  0x8(%ebp)
8010232a:	e8 f7 fb ff ff       	call   80101f26 <readi>
8010232f:	83 c4 10             	add    $0x10,%esp
80102332:	83 f8 10             	cmp    $0x10,%eax
80102335:	74 0d                	je     80102344 <dirlink+0x6a>
      panic("dirlink read");
80102337:	83 ec 0c             	sub    $0xc,%esp
8010233a:	68 15 90 10 80       	push   $0x80109015
8010233f:	e8 22 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102344:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102348:	66 85 c0             	test   %ax,%ax
8010234b:	74 18                	je     80102365 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102350:	83 c0 10             	add    $0x10,%eax
80102353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102356:	8b 45 08             	mov    0x8(%ebp),%eax
80102359:	8b 50 18             	mov    0x18(%eax),%edx
8010235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010235f:	39 c2                	cmp    %eax,%edx
80102361:	77 ba                	ja     8010231d <dirlink+0x43>
80102363:	eb 01                	jmp    80102366 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102365:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102366:	83 ec 04             	sub    $0x4,%esp
80102369:	6a 0e                	push   $0xe
8010236b:	ff 75 0c             	pushl  0xc(%ebp)
8010236e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102371:	83 c0 02             	add    $0x2,%eax
80102374:	50                   	push   %eax
80102375:	e8 b7 38 00 00       	call   80105c31 <strncpy>
8010237a:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010237d:	8b 45 10             	mov    0x10(%ebp),%eax
80102380:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102387:	6a 10                	push   $0x10
80102389:	50                   	push   %eax
8010238a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010238d:	50                   	push   %eax
8010238e:	ff 75 08             	pushl  0x8(%ebp)
80102391:	e8 e7 fc ff ff       	call   8010207d <writei>
80102396:	83 c4 10             	add    $0x10,%esp
80102399:	83 f8 10             	cmp    $0x10,%eax
8010239c:	74 0d                	je     801023ab <dirlink+0xd1>
    panic("dirlink");
8010239e:	83 ec 0c             	sub    $0xc,%esp
801023a1:	68 22 90 10 80       	push   $0x80109022
801023a6:	e8 bb e1 ff ff       	call   80100566 <panic>
  
  return 0;
801023ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023b0:	c9                   	leave  
801023b1:	c3                   	ret    

801023b2 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801023b2:	55                   	push   %ebp
801023b3:	89 e5                	mov    %esp,%ebp
801023b5:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801023b8:	eb 04                	jmp    801023be <skipelem+0xc>
    path++;
801023ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801023be:	8b 45 08             	mov    0x8(%ebp),%eax
801023c1:	0f b6 00             	movzbl (%eax),%eax
801023c4:	3c 2f                	cmp    $0x2f,%al
801023c6:	74 f2                	je     801023ba <skipelem+0x8>
    path++;
  if(*path == 0)
801023c8:	8b 45 08             	mov    0x8(%ebp),%eax
801023cb:	0f b6 00             	movzbl (%eax),%eax
801023ce:	84 c0                	test   %al,%al
801023d0:	75 07                	jne    801023d9 <skipelem+0x27>
    return 0;
801023d2:	b8 00 00 00 00       	mov    $0x0,%eax
801023d7:	eb 7b                	jmp    80102454 <skipelem+0xa2>
  s = path;
801023d9:	8b 45 08             	mov    0x8(%ebp),%eax
801023dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023df:	eb 04                	jmp    801023e5 <skipelem+0x33>
    path++;
801023e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801023e5:	8b 45 08             	mov    0x8(%ebp),%eax
801023e8:	0f b6 00             	movzbl (%eax),%eax
801023eb:	3c 2f                	cmp    $0x2f,%al
801023ed:	74 0a                	je     801023f9 <skipelem+0x47>
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
801023f2:	0f b6 00             	movzbl (%eax),%eax
801023f5:	84 c0                	test   %al,%al
801023f7:	75 e8                	jne    801023e1 <skipelem+0x2f>
    path++;
  len = path - s;
801023f9:	8b 55 08             	mov    0x8(%ebp),%edx
801023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ff:	29 c2                	sub    %eax,%edx
80102401:	89 d0                	mov    %edx,%eax
80102403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102406:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010240a:	7e 15                	jle    80102421 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010240c:	83 ec 04             	sub    $0x4,%esp
8010240f:	6a 0e                	push   $0xe
80102411:	ff 75 f4             	pushl  -0xc(%ebp)
80102414:	ff 75 0c             	pushl  0xc(%ebp)
80102417:	e8 29 37 00 00       	call   80105b45 <memmove>
8010241c:	83 c4 10             	add    $0x10,%esp
8010241f:	eb 26                	jmp    80102447 <skipelem+0x95>
  else {
    memmove(name, s, len);
80102421:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102424:	83 ec 04             	sub    $0x4,%esp
80102427:	50                   	push   %eax
80102428:	ff 75 f4             	pushl  -0xc(%ebp)
8010242b:	ff 75 0c             	pushl  0xc(%ebp)
8010242e:	e8 12 37 00 00       	call   80105b45 <memmove>
80102433:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102436:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102439:	8b 45 0c             	mov    0xc(%ebp),%eax
8010243c:	01 d0                	add    %edx,%eax
8010243e:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102441:	eb 04                	jmp    80102447 <skipelem+0x95>
    path++;
80102443:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102447:	8b 45 08             	mov    0x8(%ebp),%eax
8010244a:	0f b6 00             	movzbl (%eax),%eax
8010244d:	3c 2f                	cmp    $0x2f,%al
8010244f:	74 f2                	je     80102443 <skipelem+0x91>
    path++;
  return path;
80102451:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102454:	c9                   	leave  
80102455:	c3                   	ret    

80102456 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102456:	55                   	push   %ebp
80102457:	89 e5                	mov    %esp,%ebp
80102459:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010245c:	8b 45 08             	mov    0x8(%ebp),%eax
8010245f:	0f b6 00             	movzbl (%eax),%eax
80102462:	3c 2f                	cmp    $0x2f,%al
80102464:	75 17                	jne    8010247d <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102466:	83 ec 08             	sub    $0x8,%esp
80102469:	6a 01                	push   $0x1
8010246b:	6a 01                	push   $0x1
8010246d:	e8 2d f4 ff ff       	call   8010189f <iget>
80102472:	83 c4 10             	add    $0x10,%esp
80102475:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102478:	e9 bb 00 00 00       	jmp    80102538 <namex+0xe2>
  else
    ip = idup(proc->cwd);
8010247d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102483:	8b 40 68             	mov    0x68(%eax),%eax
80102486:	83 ec 0c             	sub    $0xc,%esp
80102489:	50                   	push   %eax
8010248a:	e8 ef f4 ff ff       	call   8010197e <idup>
8010248f:	83 c4 10             	add    $0x10,%esp
80102492:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102495:	e9 9e 00 00 00       	jmp    80102538 <namex+0xe2>
    ilock(ip);
8010249a:	83 ec 0c             	sub    $0xc,%esp
8010249d:	ff 75 f4             	pushl  -0xc(%ebp)
801024a0:	e8 13 f5 ff ff       	call   801019b8 <ilock>
801024a5:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024ab:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801024af:	66 83 f8 01          	cmp    $0x1,%ax
801024b3:	74 18                	je     801024cd <namex+0x77>
      iunlockput(ip);
801024b5:	83 ec 0c             	sub    $0xc,%esp
801024b8:	ff 75 f4             	pushl  -0xc(%ebp)
801024bb:	e8 b8 f7 ff ff       	call   80101c78 <iunlockput>
801024c0:	83 c4 10             	add    $0x10,%esp
      return 0;
801024c3:	b8 00 00 00 00       	mov    $0x0,%eax
801024c8:	e9 a7 00 00 00       	jmp    80102574 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
801024cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024d1:	74 20                	je     801024f3 <namex+0x9d>
801024d3:	8b 45 08             	mov    0x8(%ebp),%eax
801024d6:	0f b6 00             	movzbl (%eax),%eax
801024d9:	84 c0                	test   %al,%al
801024db:	75 16                	jne    801024f3 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
801024dd:	83 ec 0c             	sub    $0xc,%esp
801024e0:	ff 75 f4             	pushl  -0xc(%ebp)
801024e3:	e8 2e f6 ff ff       	call   80101b16 <iunlock>
801024e8:	83 c4 10             	add    $0x10,%esp
      return ip;
801024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024ee:	e9 81 00 00 00       	jmp    80102574 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024f3:	83 ec 04             	sub    $0x4,%esp
801024f6:	6a 00                	push   $0x0
801024f8:	ff 75 10             	pushl  0x10(%ebp)
801024fb:	ff 75 f4             	pushl  -0xc(%ebp)
801024fe:	e8 1d fd ff ff       	call   80102220 <dirlookup>
80102503:	83 c4 10             	add    $0x10,%esp
80102506:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102509:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010250d:	75 15                	jne    80102524 <namex+0xce>
      iunlockput(ip);
8010250f:	83 ec 0c             	sub    $0xc,%esp
80102512:	ff 75 f4             	pushl  -0xc(%ebp)
80102515:	e8 5e f7 ff ff       	call   80101c78 <iunlockput>
8010251a:	83 c4 10             	add    $0x10,%esp
      return 0;
8010251d:	b8 00 00 00 00       	mov    $0x0,%eax
80102522:	eb 50                	jmp    80102574 <namex+0x11e>
    }
    iunlockput(ip);
80102524:	83 ec 0c             	sub    $0xc,%esp
80102527:	ff 75 f4             	pushl  -0xc(%ebp)
8010252a:	e8 49 f7 ff ff       	call   80101c78 <iunlockput>
8010252f:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102532:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102535:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102538:	83 ec 08             	sub    $0x8,%esp
8010253b:	ff 75 10             	pushl  0x10(%ebp)
8010253e:	ff 75 08             	pushl  0x8(%ebp)
80102541:	e8 6c fe ff ff       	call   801023b2 <skipelem>
80102546:	83 c4 10             	add    $0x10,%esp
80102549:	89 45 08             	mov    %eax,0x8(%ebp)
8010254c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102550:	0f 85 44 ff ff ff    	jne    8010249a <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102556:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010255a:	74 15                	je     80102571 <namex+0x11b>
    iput(ip);
8010255c:	83 ec 0c             	sub    $0xc,%esp
8010255f:	ff 75 f4             	pushl  -0xc(%ebp)
80102562:	e8 21 f6 ff ff       	call   80101b88 <iput>
80102567:	83 c4 10             	add    $0x10,%esp
    return 0;
8010256a:	b8 00 00 00 00       	mov    $0x0,%eax
8010256f:	eb 03                	jmp    80102574 <namex+0x11e>
  }
  return ip;
80102571:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102574:	c9                   	leave  
80102575:	c3                   	ret    

80102576 <namei>:

struct inode*
namei(char *path)
{
80102576:	55                   	push   %ebp
80102577:	89 e5                	mov    %esp,%ebp
80102579:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010257c:	83 ec 04             	sub    $0x4,%esp
8010257f:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102582:	50                   	push   %eax
80102583:	6a 00                	push   $0x0
80102585:	ff 75 08             	pushl  0x8(%ebp)
80102588:	e8 c9 fe ff ff       	call   80102456 <namex>
8010258d:	83 c4 10             	add    $0x10,%esp
}
80102590:	c9                   	leave  
80102591:	c3                   	ret    

80102592 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102592:	55                   	push   %ebp
80102593:	89 e5                	mov    %esp,%ebp
80102595:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102598:	83 ec 04             	sub    $0x4,%esp
8010259b:	ff 75 0c             	pushl  0xc(%ebp)
8010259e:	6a 01                	push   $0x1
801025a0:	ff 75 08             	pushl  0x8(%ebp)
801025a3:	e8 ae fe ff ff       	call   80102456 <namex>
801025a8:	83 c4 10             	add    $0x10,%esp
}
801025ab:	c9                   	leave  
801025ac:	c3                   	ret    

801025ad <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801025ad:	55                   	push   %ebp
801025ae:	89 e5                	mov    %esp,%ebp
801025b0:	83 ec 14             	sub    $0x14,%esp
801025b3:	8b 45 08             	mov    0x8(%ebp),%eax
801025b6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ba:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801025be:	89 c2                	mov    %eax,%edx
801025c0:	ec                   	in     (%dx),%al
801025c1:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801025c4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801025c8:	c9                   	leave  
801025c9:	c3                   	ret    

801025ca <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801025ca:	55                   	push   %ebp
801025cb:	89 e5                	mov    %esp,%ebp
801025cd:	57                   	push   %edi
801025ce:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025cf:	8b 55 08             	mov    0x8(%ebp),%edx
801025d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025d5:	8b 45 10             	mov    0x10(%ebp),%eax
801025d8:	89 cb                	mov    %ecx,%ebx
801025da:	89 df                	mov    %ebx,%edi
801025dc:	89 c1                	mov    %eax,%ecx
801025de:	fc                   	cld    
801025df:	f3 6d                	rep insl (%dx),%es:(%edi)
801025e1:	89 c8                	mov    %ecx,%eax
801025e3:	89 fb                	mov    %edi,%ebx
801025e5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025e8:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801025eb:	90                   	nop
801025ec:	5b                   	pop    %ebx
801025ed:	5f                   	pop    %edi
801025ee:	5d                   	pop    %ebp
801025ef:	c3                   	ret    

801025f0 <outb>:

static inline void
outb(ushort port, uchar data)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	83 ec 08             	sub    $0x8,%esp
801025f6:	8b 55 08             	mov    0x8(%ebp),%edx
801025f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801025fc:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102600:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102603:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102607:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010260b:	ee                   	out    %al,(%dx)
}
8010260c:	90                   	nop
8010260d:	c9                   	leave  
8010260e:	c3                   	ret    

8010260f <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010260f:	55                   	push   %ebp
80102610:	89 e5                	mov    %esp,%ebp
80102612:	56                   	push   %esi
80102613:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102614:	8b 55 08             	mov    0x8(%ebp),%edx
80102617:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010261a:	8b 45 10             	mov    0x10(%ebp),%eax
8010261d:	89 cb                	mov    %ecx,%ebx
8010261f:	89 de                	mov    %ebx,%esi
80102621:	89 c1                	mov    %eax,%ecx
80102623:	fc                   	cld    
80102624:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102626:	89 c8                	mov    %ecx,%eax
80102628:	89 f3                	mov    %esi,%ebx
8010262a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010262d:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102630:	90                   	nop
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    

80102635 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
80102638:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010263b:	90                   	nop
8010263c:	68 f7 01 00 00       	push   $0x1f7
80102641:	e8 67 ff ff ff       	call   801025ad <inb>
80102646:	83 c4 04             	add    $0x4,%esp
80102649:	0f b6 c0             	movzbl %al,%eax
8010264c:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010264f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102652:	25 c0 00 00 00       	and    $0xc0,%eax
80102657:	83 f8 40             	cmp    $0x40,%eax
8010265a:	75 e0                	jne    8010263c <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010265c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102660:	74 11                	je     80102673 <idewait+0x3e>
80102662:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102665:	83 e0 21             	and    $0x21,%eax
80102668:	85 c0                	test   %eax,%eax
8010266a:	74 07                	je     80102673 <idewait+0x3e>
    return -1;
8010266c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102671:	eb 05                	jmp    80102678 <idewait+0x43>
  return 0;
80102673:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102678:	c9                   	leave  
80102679:	c3                   	ret    

8010267a <ideinit>:

void
ideinit(void)
{
8010267a:	55                   	push   %ebp
8010267b:	89 e5                	mov    %esp,%ebp
8010267d:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102680:	83 ec 08             	sub    $0x8,%esp
80102683:	68 2a 90 10 80       	push   $0x8010902a
80102688:	68 20 c6 10 80       	push   $0x8010c620
8010268d:	e8 6f 31 00 00       	call   80105801 <initlock>
80102692:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102695:	83 ec 0c             	sub    $0xc,%esp
80102698:	6a 0e                	push   $0xe
8010269a:	e8 da 18 00 00       	call   80103f79 <picenable>
8010269f:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026a2:	a1 60 39 11 80       	mov    0x80113960,%eax
801026a7:	83 e8 01             	sub    $0x1,%eax
801026aa:	83 ec 08             	sub    $0x8,%esp
801026ad:	50                   	push   %eax
801026ae:	6a 0e                	push   $0xe
801026b0:	e8 73 04 00 00       	call   80102b28 <ioapicenable>
801026b5:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801026b8:	83 ec 0c             	sub    $0xc,%esp
801026bb:	6a 00                	push   $0x0
801026bd:	e8 73 ff ff ff       	call   80102635 <idewait>
801026c2:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801026c5:	83 ec 08             	sub    $0x8,%esp
801026c8:	68 f0 00 00 00       	push   $0xf0
801026cd:	68 f6 01 00 00       	push   $0x1f6
801026d2:	e8 19 ff ff ff       	call   801025f0 <outb>
801026d7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801026da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026e1:	eb 24                	jmp    80102707 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801026e3:	83 ec 0c             	sub    $0xc,%esp
801026e6:	68 f7 01 00 00       	push   $0x1f7
801026eb:	e8 bd fe ff ff       	call   801025ad <inb>
801026f0:	83 c4 10             	add    $0x10,%esp
801026f3:	84 c0                	test   %al,%al
801026f5:	74 0c                	je     80102703 <ideinit+0x89>
      havedisk1 = 1;
801026f7:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801026fe:	00 00 00 
      break;
80102701:	eb 0d                	jmp    80102710 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102703:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102707:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010270e:	7e d3                	jle    801026e3 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102710:	83 ec 08             	sub    $0x8,%esp
80102713:	68 e0 00 00 00       	push   $0xe0
80102718:	68 f6 01 00 00       	push   $0x1f6
8010271d:	e8 ce fe ff ff       	call   801025f0 <outb>
80102722:	83 c4 10             	add    $0x10,%esp
}
80102725:	90                   	nop
80102726:	c9                   	leave  
80102727:	c3                   	ret    

80102728 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102728:	55                   	push   %ebp
80102729:	89 e5                	mov    %esp,%ebp
8010272b:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010272e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102732:	75 0d                	jne    80102741 <idestart+0x19>
    panic("idestart");
80102734:	83 ec 0c             	sub    $0xc,%esp
80102737:	68 2e 90 10 80       	push   $0x8010902e
8010273c:	e8 25 de ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102741:	8b 45 08             	mov    0x8(%ebp),%eax
80102744:	8b 40 08             	mov    0x8(%eax),%eax
80102747:	3d cf 07 00 00       	cmp    $0x7cf,%eax
8010274c:	76 0d                	jbe    8010275b <idestart+0x33>
    panic("incorrect blockno");
8010274e:	83 ec 0c             	sub    $0xc,%esp
80102751:	68 37 90 10 80       	push   $0x80109037
80102756:	e8 0b de ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010275b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102762:	8b 45 08             	mov    0x8(%ebp),%eax
80102765:	8b 50 08             	mov    0x8(%eax),%edx
80102768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276b:	0f af c2             	imul   %edx,%eax
8010276e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102771:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102775:	7e 0d                	jle    80102784 <idestart+0x5c>
80102777:	83 ec 0c             	sub    $0xc,%esp
8010277a:	68 2e 90 10 80       	push   $0x8010902e
8010277f:	e8 e2 dd ff ff       	call   80100566 <panic>
  
  idewait(0);
80102784:	83 ec 0c             	sub    $0xc,%esp
80102787:	6a 00                	push   $0x0
80102789:	e8 a7 fe ff ff       	call   80102635 <idewait>
8010278e:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102791:	83 ec 08             	sub    $0x8,%esp
80102794:	6a 00                	push   $0x0
80102796:	68 f6 03 00 00       	push   $0x3f6
8010279b:	e8 50 fe ff ff       	call   801025f0 <outb>
801027a0:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a6:	0f b6 c0             	movzbl %al,%eax
801027a9:	83 ec 08             	sub    $0x8,%esp
801027ac:	50                   	push   %eax
801027ad:	68 f2 01 00 00       	push   $0x1f2
801027b2:	e8 39 fe ff ff       	call   801025f0 <outb>
801027b7:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801027ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027bd:	0f b6 c0             	movzbl %al,%eax
801027c0:	83 ec 08             	sub    $0x8,%esp
801027c3:	50                   	push   %eax
801027c4:	68 f3 01 00 00       	push   $0x1f3
801027c9:	e8 22 fe ff ff       	call   801025f0 <outb>
801027ce:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801027d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027d4:	c1 f8 08             	sar    $0x8,%eax
801027d7:	0f b6 c0             	movzbl %al,%eax
801027da:	83 ec 08             	sub    $0x8,%esp
801027dd:	50                   	push   %eax
801027de:	68 f4 01 00 00       	push   $0x1f4
801027e3:	e8 08 fe ff ff       	call   801025f0 <outb>
801027e8:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027ee:	c1 f8 10             	sar    $0x10,%eax
801027f1:	0f b6 c0             	movzbl %al,%eax
801027f4:	83 ec 08             	sub    $0x8,%esp
801027f7:	50                   	push   %eax
801027f8:	68 f5 01 00 00       	push   $0x1f5
801027fd:	e8 ee fd ff ff       	call   801025f0 <outb>
80102802:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102805:	8b 45 08             	mov    0x8(%ebp),%eax
80102808:	8b 40 04             	mov    0x4(%eax),%eax
8010280b:	83 e0 01             	and    $0x1,%eax
8010280e:	c1 e0 04             	shl    $0x4,%eax
80102811:	89 c2                	mov    %eax,%edx
80102813:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102816:	c1 f8 18             	sar    $0x18,%eax
80102819:	83 e0 0f             	and    $0xf,%eax
8010281c:	09 d0                	or     %edx,%eax
8010281e:	83 c8 e0             	or     $0xffffffe0,%eax
80102821:	0f b6 c0             	movzbl %al,%eax
80102824:	83 ec 08             	sub    $0x8,%esp
80102827:	50                   	push   %eax
80102828:	68 f6 01 00 00       	push   $0x1f6
8010282d:	e8 be fd ff ff       	call   801025f0 <outb>
80102832:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102835:	8b 45 08             	mov    0x8(%ebp),%eax
80102838:	8b 00                	mov    (%eax),%eax
8010283a:	83 e0 04             	and    $0x4,%eax
8010283d:	85 c0                	test   %eax,%eax
8010283f:	74 30                	je     80102871 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102841:	83 ec 08             	sub    $0x8,%esp
80102844:	6a 30                	push   $0x30
80102846:	68 f7 01 00 00       	push   $0x1f7
8010284b:	e8 a0 fd ff ff       	call   801025f0 <outb>
80102850:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102853:	8b 45 08             	mov    0x8(%ebp),%eax
80102856:	83 c0 18             	add    $0x18,%eax
80102859:	83 ec 04             	sub    $0x4,%esp
8010285c:	68 80 00 00 00       	push   $0x80
80102861:	50                   	push   %eax
80102862:	68 f0 01 00 00       	push   $0x1f0
80102867:	e8 a3 fd ff ff       	call   8010260f <outsl>
8010286c:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
8010286f:	eb 12                	jmp    80102883 <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102871:	83 ec 08             	sub    $0x8,%esp
80102874:	6a 20                	push   $0x20
80102876:	68 f7 01 00 00       	push   $0x1f7
8010287b:	e8 70 fd ff ff       	call   801025f0 <outb>
80102880:	83 c4 10             	add    $0x10,%esp
  }
}
80102883:	90                   	nop
80102884:	c9                   	leave  
80102885:	c3                   	ret    

80102886 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102886:	55                   	push   %ebp
80102887:	89 e5                	mov    %esp,%ebp
80102889:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010288c:	83 ec 0c             	sub    $0xc,%esp
8010288f:	68 20 c6 10 80       	push   $0x8010c620
80102894:	e8 8a 2f 00 00       	call   80105823 <acquire>
80102899:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
8010289c:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028a8:	75 15                	jne    801028bf <ideintr+0x39>
    release(&idelock);
801028aa:	83 ec 0c             	sub    $0xc,%esp
801028ad:	68 20 c6 10 80       	push   $0x8010c620
801028b2:	e8 d3 2f 00 00       	call   8010588a <release>
801028b7:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801028ba:	e9 9a 00 00 00       	jmp    80102959 <ideintr+0xd3>
  }
  idequeue = b->qnext;
801028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c2:	8b 40 14             	mov    0x14(%eax),%eax
801028c5:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028cd:	8b 00                	mov    (%eax),%eax
801028cf:	83 e0 04             	and    $0x4,%eax
801028d2:	85 c0                	test   %eax,%eax
801028d4:	75 2d                	jne    80102903 <ideintr+0x7d>
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	6a 01                	push   $0x1
801028db:	e8 55 fd ff ff       	call   80102635 <idewait>
801028e0:	83 c4 10             	add    $0x10,%esp
801028e3:	85 c0                	test   %eax,%eax
801028e5:	78 1c                	js     80102903 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ea:	83 c0 18             	add    $0x18,%eax
801028ed:	83 ec 04             	sub    $0x4,%esp
801028f0:	68 80 00 00 00       	push   $0x80
801028f5:	50                   	push   %eax
801028f6:	68 f0 01 00 00       	push   $0x1f0
801028fb:	e8 ca fc ff ff       	call   801025ca <insl>
80102900:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102906:	8b 00                	mov    (%eax),%eax
80102908:	83 c8 02             	or     $0x2,%eax
8010290b:	89 c2                	mov    %eax,%edx
8010290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102910:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102915:	8b 00                	mov    (%eax),%eax
80102917:	83 e0 fb             	and    $0xfffffffb,%eax
8010291a:	89 c2                	mov    %eax,%edx
8010291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291f:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102921:	83 ec 0c             	sub    $0xc,%esp
80102924:	ff 75 f4             	pushl  -0xc(%ebp)
80102927:	e8 f6 27 00 00       	call   80105122 <wakeup>
8010292c:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010292f:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102934:	85 c0                	test   %eax,%eax
80102936:	74 11                	je     80102949 <ideintr+0xc3>
    idestart(idequeue);
80102938:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010293d:	83 ec 0c             	sub    $0xc,%esp
80102940:	50                   	push   %eax
80102941:	e8 e2 fd ff ff       	call   80102728 <idestart>
80102946:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102949:	83 ec 0c             	sub    $0xc,%esp
8010294c:	68 20 c6 10 80       	push   $0x8010c620
80102951:	e8 34 2f 00 00       	call   8010588a <release>
80102956:	83 c4 10             	add    $0x10,%esp
}
80102959:	c9                   	leave  
8010295a:	c3                   	ret    

8010295b <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010295b:	55                   	push   %ebp
8010295c:	89 e5                	mov    %esp,%ebp
8010295e:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102961:	8b 45 08             	mov    0x8(%ebp),%eax
80102964:	8b 00                	mov    (%eax),%eax
80102966:	83 e0 01             	and    $0x1,%eax
80102969:	85 c0                	test   %eax,%eax
8010296b:	75 0d                	jne    8010297a <iderw+0x1f>
    panic("iderw: buf not busy");
8010296d:	83 ec 0c             	sub    $0xc,%esp
80102970:	68 49 90 10 80       	push   $0x80109049
80102975:	e8 ec db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010297a:	8b 45 08             	mov    0x8(%ebp),%eax
8010297d:	8b 00                	mov    (%eax),%eax
8010297f:	83 e0 06             	and    $0x6,%eax
80102982:	83 f8 02             	cmp    $0x2,%eax
80102985:	75 0d                	jne    80102994 <iderw+0x39>
    panic("iderw: nothing to do");
80102987:	83 ec 0c             	sub    $0xc,%esp
8010298a:	68 5d 90 10 80       	push   $0x8010905d
8010298f:	e8 d2 db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102994:	8b 45 08             	mov    0x8(%ebp),%eax
80102997:	8b 40 04             	mov    0x4(%eax),%eax
8010299a:	85 c0                	test   %eax,%eax
8010299c:	74 16                	je     801029b4 <iderw+0x59>
8010299e:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801029a3:	85 c0                	test   %eax,%eax
801029a5:	75 0d                	jne    801029b4 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801029a7:	83 ec 0c             	sub    $0xc,%esp
801029aa:	68 72 90 10 80       	push   $0x80109072
801029af:	e8 b2 db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029b4:	83 ec 0c             	sub    $0xc,%esp
801029b7:	68 20 c6 10 80       	push   $0x8010c620
801029bc:	e8 62 2e 00 00       	call   80105823 <acquire>
801029c1:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029c4:	8b 45 08             	mov    0x8(%ebp),%eax
801029c7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029ce:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801029d5:	eb 0b                	jmp    801029e2 <iderw+0x87>
801029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029da:	8b 00                	mov    (%eax),%eax
801029dc:	83 c0 14             	add    $0x14,%eax
801029df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e5:	8b 00                	mov    (%eax),%eax
801029e7:	85 c0                	test   %eax,%eax
801029e9:	75 ec                	jne    801029d7 <iderw+0x7c>
    ;
  *pp = b;
801029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029ee:	8b 55 08             	mov    0x8(%ebp),%edx
801029f1:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801029f3:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801029f8:	3b 45 08             	cmp    0x8(%ebp),%eax
801029fb:	75 23                	jne    80102a20 <iderw+0xc5>
    idestart(b);
801029fd:	83 ec 0c             	sub    $0xc,%esp
80102a00:	ff 75 08             	pushl  0x8(%ebp)
80102a03:	e8 20 fd ff ff       	call   80102728 <idestart>
80102a08:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a0b:	eb 13                	jmp    80102a20 <iderw+0xc5>
    sleep(b, &idelock);
80102a0d:	83 ec 08             	sub    $0x8,%esp
80102a10:	68 20 c6 10 80       	push   $0x8010c620
80102a15:	ff 75 08             	pushl  0x8(%ebp)
80102a18:	e8 1e 26 00 00       	call   8010503b <sleep>
80102a1d:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a20:	8b 45 08             	mov    0x8(%ebp),%eax
80102a23:	8b 00                	mov    (%eax),%eax
80102a25:	83 e0 06             	and    $0x6,%eax
80102a28:	83 f8 02             	cmp    $0x2,%eax
80102a2b:	75 e0                	jne    80102a0d <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a2d:	83 ec 0c             	sub    $0xc,%esp
80102a30:	68 20 c6 10 80       	push   $0x8010c620
80102a35:	e8 50 2e 00 00       	call   8010588a <release>
80102a3a:	83 c4 10             	add    $0x10,%esp
}
80102a3d:	90                   	nop
80102a3e:	c9                   	leave  
80102a3f:	c3                   	ret    

80102a40 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a43:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a48:	8b 55 08             	mov    0x8(%ebp),%edx
80102a4b:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a4d:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a52:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a55:	5d                   	pop    %ebp
80102a56:	c3                   	ret    

80102a57 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a57:	55                   	push   %ebp
80102a58:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a5a:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a5f:	8b 55 08             	mov    0x8(%ebp),%edx
80102a62:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a64:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a69:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a6c:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a6f:	90                   	nop
80102a70:	5d                   	pop    %ebp
80102a71:	c3                   	ret    

80102a72 <ioapicinit>:

void
ioapicinit(void)
{
80102a72:	55                   	push   %ebp
80102a73:	89 e5                	mov    %esp,%ebp
80102a75:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102a78:	a1 64 33 11 80       	mov    0x80113364,%eax
80102a7d:	85 c0                	test   %eax,%eax
80102a7f:	0f 84 a0 00 00 00    	je     80102b25 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a85:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
80102a8c:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a8f:	6a 01                	push   $0x1
80102a91:	e8 aa ff ff ff       	call   80102a40 <ioapicread>
80102a96:	83 c4 04             	add    $0x4,%esp
80102a99:	c1 e8 10             	shr    $0x10,%eax
80102a9c:	25 ff 00 00 00       	and    $0xff,%eax
80102aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102aa4:	6a 00                	push   $0x0
80102aa6:	e8 95 ff ff ff       	call   80102a40 <ioapicread>
80102aab:	83 c4 04             	add    $0x4,%esp
80102aae:	c1 e8 18             	shr    $0x18,%eax
80102ab1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102ab4:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
80102abb:	0f b6 c0             	movzbl %al,%eax
80102abe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102ac1:	74 10                	je     80102ad3 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ac3:	83 ec 0c             	sub    $0xc,%esp
80102ac6:	68 90 90 10 80       	push   $0x80109090
80102acb:	e8 f6 d8 ff ff       	call   801003c6 <cprintf>
80102ad0:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ad3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ada:	eb 3f                	jmp    80102b1b <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102adf:	83 c0 20             	add    $0x20,%eax
80102ae2:	0d 00 00 01 00       	or     $0x10000,%eax
80102ae7:	89 c2                	mov    %eax,%edx
80102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aec:	83 c0 08             	add    $0x8,%eax
80102aef:	01 c0                	add    %eax,%eax
80102af1:	83 ec 08             	sub    $0x8,%esp
80102af4:	52                   	push   %edx
80102af5:	50                   	push   %eax
80102af6:	e8 5c ff ff ff       	call   80102a57 <ioapicwrite>
80102afb:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b01:	83 c0 08             	add    $0x8,%eax
80102b04:	01 c0                	add    %eax,%eax
80102b06:	83 c0 01             	add    $0x1,%eax
80102b09:	83 ec 08             	sub    $0x8,%esp
80102b0c:	6a 00                	push   $0x0
80102b0e:	50                   	push   %eax
80102b0f:	e8 43 ff ff ff       	call   80102a57 <ioapicwrite>
80102b14:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b21:	7e b9                	jle    80102adc <ioapicinit+0x6a>
80102b23:	eb 01                	jmp    80102b26 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102b25:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b26:	c9                   	leave  
80102b27:	c3                   	ret    

80102b28 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b28:	55                   	push   %ebp
80102b29:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b2b:	a1 64 33 11 80       	mov    0x80113364,%eax
80102b30:	85 c0                	test   %eax,%eax
80102b32:	74 39                	je     80102b6d <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b34:	8b 45 08             	mov    0x8(%ebp),%eax
80102b37:	83 c0 20             	add    $0x20,%eax
80102b3a:	89 c2                	mov    %eax,%edx
80102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b3f:	83 c0 08             	add    $0x8,%eax
80102b42:	01 c0                	add    %eax,%eax
80102b44:	52                   	push   %edx
80102b45:	50                   	push   %eax
80102b46:	e8 0c ff ff ff       	call   80102a57 <ioapicwrite>
80102b4b:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b51:	c1 e0 18             	shl    $0x18,%eax
80102b54:	89 c2                	mov    %eax,%edx
80102b56:	8b 45 08             	mov    0x8(%ebp),%eax
80102b59:	83 c0 08             	add    $0x8,%eax
80102b5c:	01 c0                	add    %eax,%eax
80102b5e:	83 c0 01             	add    $0x1,%eax
80102b61:	52                   	push   %edx
80102b62:	50                   	push   %eax
80102b63:	e8 ef fe ff ff       	call   80102a57 <ioapicwrite>
80102b68:	83 c4 08             	add    $0x8,%esp
80102b6b:	eb 01                	jmp    80102b6e <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102b6d:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102b6e:	c9                   	leave  
80102b6f:	c3                   	ret    

80102b70 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	8b 45 08             	mov    0x8(%ebp),%eax
80102b76:	05 00 00 00 80       	add    $0x80000000,%eax
80102b7b:	5d                   	pop    %ebp
80102b7c:	c3                   	ret    

80102b7d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b7d:	55                   	push   %ebp
80102b7e:	89 e5                	mov    %esp,%ebp
80102b80:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b83:	83 ec 08             	sub    $0x8,%esp
80102b86:	68 c2 90 10 80       	push   $0x801090c2
80102b8b:	68 40 32 11 80       	push   $0x80113240
80102b90:	e8 6c 2c 00 00       	call   80105801 <initlock>
80102b95:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b98:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102b9f:	00 00 00 
  freerange(vstart, vend);
80102ba2:	83 ec 08             	sub    $0x8,%esp
80102ba5:	ff 75 0c             	pushl  0xc(%ebp)
80102ba8:	ff 75 08             	pushl  0x8(%ebp)
80102bab:	e8 2a 00 00 00       	call   80102bda <freerange>
80102bb0:	83 c4 10             	add    $0x10,%esp
}
80102bb3:	90                   	nop
80102bb4:	c9                   	leave  
80102bb5:	c3                   	ret    

80102bb6 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102bb6:	55                   	push   %ebp
80102bb7:	89 e5                	mov    %esp,%ebp
80102bb9:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102bbc:	83 ec 08             	sub    $0x8,%esp
80102bbf:	ff 75 0c             	pushl  0xc(%ebp)
80102bc2:	ff 75 08             	pushl  0x8(%ebp)
80102bc5:	e8 10 00 00 00       	call   80102bda <freerange>
80102bca:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102bcd:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102bd4:	00 00 00 
}
80102bd7:	90                   	nop
80102bd8:	c9                   	leave  
80102bd9:	c3                   	ret    

80102bda <freerange>:

void
freerange(void *vstart, void *vend)
{
80102bda:	55                   	push   %ebp
80102bdb:	89 e5                	mov    %esp,%ebp
80102bdd:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102be0:	8b 45 08             	mov    0x8(%ebp),%eax
80102be3:	05 ff 0f 00 00       	add    $0xfff,%eax
80102be8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bf0:	eb 15                	jmp    80102c07 <freerange+0x2d>
    kfree(p);
80102bf2:	83 ec 0c             	sub    $0xc,%esp
80102bf5:	ff 75 f4             	pushl  -0xc(%ebp)
80102bf8:	e8 1a 00 00 00       	call   80102c17 <kfree>
80102bfd:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c00:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c0a:	05 00 10 00 00       	add    $0x1000,%eax
80102c0f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c12:	76 de                	jbe    80102bf2 <freerange+0x18>
    kfree(p);
}
80102c14:	90                   	nop
80102c15:	c9                   	leave  
80102c16:	c3                   	ret    

80102c17 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c17:	55                   	push   %ebp
80102c18:	89 e5                	mov    %esp,%ebp
80102c1a:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102c1d:	8b 45 08             	mov    0x8(%ebp),%eax
80102c20:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c25:	85 c0                	test   %eax,%eax
80102c27:	75 1b                	jne    80102c44 <kfree+0x2d>
80102c29:	81 7d 08 3c 67 11 80 	cmpl   $0x8011673c,0x8(%ebp)
80102c30:	72 12                	jb     80102c44 <kfree+0x2d>
80102c32:	ff 75 08             	pushl  0x8(%ebp)
80102c35:	e8 36 ff ff ff       	call   80102b70 <v2p>
80102c3a:	83 c4 04             	add    $0x4,%esp
80102c3d:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c42:	76 0d                	jbe    80102c51 <kfree+0x3a>
    panic("kfree");
80102c44:	83 ec 0c             	sub    $0xc,%esp
80102c47:	68 c7 90 10 80       	push   $0x801090c7
80102c4c:	e8 15 d9 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c51:	83 ec 04             	sub    $0x4,%esp
80102c54:	68 00 10 00 00       	push   $0x1000
80102c59:	6a 01                	push   $0x1
80102c5b:	ff 75 08             	pushl  0x8(%ebp)
80102c5e:	e8 23 2e 00 00       	call   80105a86 <memset>
80102c63:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c66:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c6b:	85 c0                	test   %eax,%eax
80102c6d:	74 10                	je     80102c7f <kfree+0x68>
    acquire(&kmem.lock);
80102c6f:	83 ec 0c             	sub    $0xc,%esp
80102c72:	68 40 32 11 80       	push   $0x80113240
80102c77:	e8 a7 2b 00 00       	call   80105823 <acquire>
80102c7c:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c7f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c85:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c8e:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c93:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102c98:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c9d:	85 c0                	test   %eax,%eax
80102c9f:	74 10                	je     80102cb1 <kfree+0x9a>
    release(&kmem.lock);
80102ca1:	83 ec 0c             	sub    $0xc,%esp
80102ca4:	68 40 32 11 80       	push   $0x80113240
80102ca9:	e8 dc 2b 00 00       	call   8010588a <release>
80102cae:	83 c4 10             	add    $0x10,%esp
}
80102cb1:	90                   	nop
80102cb2:	c9                   	leave  
80102cb3:	c3                   	ret    

80102cb4 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102cb4:	55                   	push   %ebp
80102cb5:	89 e5                	mov    %esp,%ebp
80102cb7:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102cba:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cbf:	85 c0                	test   %eax,%eax
80102cc1:	74 10                	je     80102cd3 <kalloc+0x1f>
    acquire(&kmem.lock);
80102cc3:	83 ec 0c             	sub    $0xc,%esp
80102cc6:	68 40 32 11 80       	push   $0x80113240
80102ccb:	e8 53 2b 00 00       	call   80105823 <acquire>
80102cd0:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102cd3:	a1 78 32 11 80       	mov    0x80113278,%eax
80102cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102cdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102cdf:	74 0a                	je     80102ceb <kalloc+0x37>
    kmem.freelist = r->next;
80102ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce4:	8b 00                	mov    (%eax),%eax
80102ce6:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102ceb:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cf0:	85 c0                	test   %eax,%eax
80102cf2:	74 10                	je     80102d04 <kalloc+0x50>
    release(&kmem.lock);
80102cf4:	83 ec 0c             	sub    $0xc,%esp
80102cf7:	68 40 32 11 80       	push   $0x80113240
80102cfc:	e8 89 2b 00 00       	call   8010588a <release>
80102d01:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d07:	c9                   	leave  
80102d08:	c3                   	ret    

80102d09 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102d09:	55                   	push   %ebp
80102d0a:	89 e5                	mov    %esp,%ebp
80102d0c:	83 ec 14             	sub    $0x14,%esp
80102d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80102d12:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d16:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d1a:	89 c2                	mov    %eax,%edx
80102d1c:	ec                   	in     (%dx),%al
80102d1d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d20:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d24:	c9                   	leave  
80102d25:	c3                   	ret    

80102d26 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d26:	55                   	push   %ebp
80102d27:	89 e5                	mov    %esp,%ebp
80102d29:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d2c:	6a 64                	push   $0x64
80102d2e:	e8 d6 ff ff ff       	call   80102d09 <inb>
80102d33:	83 c4 04             	add    $0x4,%esp
80102d36:	0f b6 c0             	movzbl %al,%eax
80102d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d3f:	83 e0 01             	and    $0x1,%eax
80102d42:	85 c0                	test   %eax,%eax
80102d44:	75 0a                	jne    80102d50 <kbdgetc+0x2a>
    return -1;
80102d46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d4b:	e9 23 01 00 00       	jmp    80102e73 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d50:	6a 60                	push   $0x60
80102d52:	e8 b2 ff ff ff       	call   80102d09 <inb>
80102d57:	83 c4 04             	add    $0x4,%esp
80102d5a:	0f b6 c0             	movzbl %al,%eax
80102d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d60:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d67:	75 17                	jne    80102d80 <kbdgetc+0x5a>
    shift |= E0ESC;
80102d69:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d6e:	83 c8 40             	or     $0x40,%eax
80102d71:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102d76:	b8 00 00 00 00       	mov    $0x0,%eax
80102d7b:	e9 f3 00 00 00       	jmp    80102e73 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d80:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d83:	25 80 00 00 00       	and    $0x80,%eax
80102d88:	85 c0                	test   %eax,%eax
80102d8a:	74 45                	je     80102dd1 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d8c:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d91:	83 e0 40             	and    $0x40,%eax
80102d94:	85 c0                	test   %eax,%eax
80102d96:	75 08                	jne    80102da0 <kbdgetc+0x7a>
80102d98:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d9b:	83 e0 7f             	and    $0x7f,%eax
80102d9e:	eb 03                	jmp    80102da3 <kbdgetc+0x7d>
80102da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102da3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102da6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102da9:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102dae:	0f b6 00             	movzbl (%eax),%eax
80102db1:	83 c8 40             	or     $0x40,%eax
80102db4:	0f b6 c0             	movzbl %al,%eax
80102db7:	f7 d0                	not    %eax
80102db9:	89 c2                	mov    %eax,%edx
80102dbb:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dc0:	21 d0                	and    %edx,%eax
80102dc2:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102dc7:	b8 00 00 00 00       	mov    $0x0,%eax
80102dcc:	e9 a2 00 00 00       	jmp    80102e73 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102dd1:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dd6:	83 e0 40             	and    $0x40,%eax
80102dd9:	85 c0                	test   %eax,%eax
80102ddb:	74 14                	je     80102df1 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ddd:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102de4:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102de9:	83 e0 bf             	and    $0xffffffbf,%eax
80102dec:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102df1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df4:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102df9:	0f b6 00             	movzbl (%eax),%eax
80102dfc:	0f b6 d0             	movzbl %al,%edx
80102dff:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e04:	09 d0                	or     %edx,%eax
80102e06:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102e0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e0e:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102e13:	0f b6 00             	movzbl (%eax),%eax
80102e16:	0f b6 d0             	movzbl %al,%edx
80102e19:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e1e:	31 d0                	xor    %edx,%eax
80102e20:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e25:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e2a:	83 e0 03             	and    $0x3,%eax
80102e2d:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e37:	01 d0                	add    %edx,%eax
80102e39:	0f b6 00             	movzbl (%eax),%eax
80102e3c:	0f b6 c0             	movzbl %al,%eax
80102e3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e42:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e47:	83 e0 08             	and    $0x8,%eax
80102e4a:	85 c0                	test   %eax,%eax
80102e4c:	74 22                	je     80102e70 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e4e:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e52:	76 0c                	jbe    80102e60 <kbdgetc+0x13a>
80102e54:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e58:	77 06                	ja     80102e60 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e5a:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e5e:	eb 10                	jmp    80102e70 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e60:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e64:	76 0a                	jbe    80102e70 <kbdgetc+0x14a>
80102e66:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e6a:	77 04                	ja     80102e70 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e6c:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e73:	c9                   	leave  
80102e74:	c3                   	ret    

80102e75 <kbdintr>:

void
kbdintr(void)
{
80102e75:	55                   	push   %ebp
80102e76:	89 e5                	mov    %esp,%ebp
80102e78:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e7b:	83 ec 0c             	sub    $0xc,%esp
80102e7e:	68 26 2d 10 80       	push   $0x80102d26
80102e83:	e8 71 d9 ff ff       	call   801007f9 <consoleintr>
80102e88:	83 c4 10             	add    $0x10,%esp
}
80102e8b:	90                   	nop
80102e8c:	c9                   	leave  
80102e8d:	c3                   	ret    

80102e8e <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102e8e:	55                   	push   %ebp
80102e8f:	89 e5                	mov    %esp,%ebp
80102e91:	83 ec 14             	sub    $0x14,%esp
80102e94:	8b 45 08             	mov    0x8(%ebp),%eax
80102e97:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e9b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e9f:	89 c2                	mov    %eax,%edx
80102ea1:	ec                   	in     (%dx),%al
80102ea2:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ea5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ea9:	c9                   	leave  
80102eaa:	c3                   	ret    

80102eab <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102eab:	55                   	push   %ebp
80102eac:	89 e5                	mov    %esp,%ebp
80102eae:	83 ec 08             	sub    $0x8,%esp
80102eb1:	8b 55 08             	mov    0x8(%ebp),%edx
80102eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80102eb7:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102ebb:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ebe:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102ec2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ec6:	ee                   	out    %al,(%dx)
}
80102ec7:	90                   	nop
80102ec8:	c9                   	leave  
80102ec9:	c3                   	ret    

80102eca <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102eca:	55                   	push   %ebp
80102ecb:	89 e5                	mov    %esp,%ebp
80102ecd:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102ed0:	9c                   	pushf  
80102ed1:	58                   	pop    %eax
80102ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102ed8:	c9                   	leave  
80102ed9:	c3                   	ret    

80102eda <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102eda:	55                   	push   %ebp
80102edb:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102edd:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ee2:	8b 55 08             	mov    0x8(%ebp),%edx
80102ee5:	c1 e2 02             	shl    $0x2,%edx
80102ee8:	01 c2                	add    %eax,%edx
80102eea:	8b 45 0c             	mov    0xc(%ebp),%eax
80102eed:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102eef:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ef4:	83 c0 20             	add    $0x20,%eax
80102ef7:	8b 00                	mov    (%eax),%eax
}
80102ef9:	90                   	nop
80102efa:	5d                   	pop    %ebp
80102efb:	c3                   	ret    

80102efc <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102efc:	55                   	push   %ebp
80102efd:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102eff:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f04:	85 c0                	test   %eax,%eax
80102f06:	0f 84 0b 01 00 00    	je     80103017 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f0c:	68 3f 01 00 00       	push   $0x13f
80102f11:	6a 3c                	push   $0x3c
80102f13:	e8 c2 ff ff ff       	call   80102eda <lapicw>
80102f18:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f1b:	6a 0b                	push   $0xb
80102f1d:	68 f8 00 00 00       	push   $0xf8
80102f22:	e8 b3 ff ff ff       	call   80102eda <lapicw>
80102f27:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f2a:	68 20 00 02 00       	push   $0x20020
80102f2f:	68 c8 00 00 00       	push   $0xc8
80102f34:	e8 a1 ff ff ff       	call   80102eda <lapicw>
80102f39:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102f3c:	68 80 96 98 00       	push   $0x989680
80102f41:	68 e0 00 00 00       	push   $0xe0
80102f46:	e8 8f ff ff ff       	call   80102eda <lapicw>
80102f4b:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f4e:	68 00 00 01 00       	push   $0x10000
80102f53:	68 d4 00 00 00       	push   $0xd4
80102f58:	e8 7d ff ff ff       	call   80102eda <lapicw>
80102f5d:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f60:	68 00 00 01 00       	push   $0x10000
80102f65:	68 d8 00 00 00       	push   $0xd8
80102f6a:	e8 6b ff ff ff       	call   80102eda <lapicw>
80102f6f:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f72:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f77:	83 c0 30             	add    $0x30,%eax
80102f7a:	8b 00                	mov    (%eax),%eax
80102f7c:	c1 e8 10             	shr    $0x10,%eax
80102f7f:	0f b6 c0             	movzbl %al,%eax
80102f82:	83 f8 03             	cmp    $0x3,%eax
80102f85:	76 12                	jbe    80102f99 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102f87:	68 00 00 01 00       	push   $0x10000
80102f8c:	68 d0 00 00 00       	push   $0xd0
80102f91:	e8 44 ff ff ff       	call   80102eda <lapicw>
80102f96:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f99:	6a 33                	push   $0x33
80102f9b:	68 dc 00 00 00       	push   $0xdc
80102fa0:	e8 35 ff ff ff       	call   80102eda <lapicw>
80102fa5:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102fa8:	6a 00                	push   $0x0
80102faa:	68 a0 00 00 00       	push   $0xa0
80102faf:	e8 26 ff ff ff       	call   80102eda <lapicw>
80102fb4:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102fb7:	6a 00                	push   $0x0
80102fb9:	68 a0 00 00 00       	push   $0xa0
80102fbe:	e8 17 ff ff ff       	call   80102eda <lapicw>
80102fc3:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102fc6:	6a 00                	push   $0x0
80102fc8:	6a 2c                	push   $0x2c
80102fca:	e8 0b ff ff ff       	call   80102eda <lapicw>
80102fcf:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102fd2:	6a 00                	push   $0x0
80102fd4:	68 c4 00 00 00       	push   $0xc4
80102fd9:	e8 fc fe ff ff       	call   80102eda <lapicw>
80102fde:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102fe1:	68 00 85 08 00       	push   $0x88500
80102fe6:	68 c0 00 00 00       	push   $0xc0
80102feb:	e8 ea fe ff ff       	call   80102eda <lapicw>
80102ff0:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102ff3:	90                   	nop
80102ff4:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ff9:	05 00 03 00 00       	add    $0x300,%eax
80102ffe:	8b 00                	mov    (%eax),%eax
80103000:	25 00 10 00 00       	and    $0x1000,%eax
80103005:	85 c0                	test   %eax,%eax
80103007:	75 eb                	jne    80102ff4 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103009:	6a 00                	push   $0x0
8010300b:	6a 20                	push   $0x20
8010300d:	e8 c8 fe ff ff       	call   80102eda <lapicw>
80103012:	83 c4 08             	add    $0x8,%esp
80103015:	eb 01                	jmp    80103018 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80103017:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103018:	c9                   	leave  
80103019:	c3                   	ret    

8010301a <cpunum>:

int
cpunum(void)
{
8010301a:	55                   	push   %ebp
8010301b:	89 e5                	mov    %esp,%ebp
8010301d:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103020:	e8 a5 fe ff ff       	call   80102eca <readeflags>
80103025:	25 00 02 00 00       	and    $0x200,%eax
8010302a:	85 c0                	test   %eax,%eax
8010302c:	74 26                	je     80103054 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010302e:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80103033:	8d 50 01             	lea    0x1(%eax),%edx
80103036:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
8010303c:	85 c0                	test   %eax,%eax
8010303e:	75 14                	jne    80103054 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103040:	8b 45 04             	mov    0x4(%ebp),%eax
80103043:	83 ec 08             	sub    $0x8,%esp
80103046:	50                   	push   %eax
80103047:	68 d0 90 10 80       	push   $0x801090d0
8010304c:	e8 75 d3 ff ff       	call   801003c6 <cprintf>
80103051:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103054:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80103059:	85 c0                	test   %eax,%eax
8010305b:	74 0f                	je     8010306c <cpunum+0x52>
    return lapic[ID]>>24;
8010305d:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80103062:	83 c0 20             	add    $0x20,%eax
80103065:	8b 00                	mov    (%eax),%eax
80103067:	c1 e8 18             	shr    $0x18,%eax
8010306a:	eb 05                	jmp    80103071 <cpunum+0x57>
  return 0;
8010306c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103071:	c9                   	leave  
80103072:	c3                   	ret    

80103073 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103073:	55                   	push   %ebp
80103074:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103076:	a1 7c 32 11 80       	mov    0x8011327c,%eax
8010307b:	85 c0                	test   %eax,%eax
8010307d:	74 0c                	je     8010308b <lapiceoi+0x18>
    lapicw(EOI, 0);
8010307f:	6a 00                	push   $0x0
80103081:	6a 2c                	push   $0x2c
80103083:	e8 52 fe ff ff       	call   80102eda <lapicw>
80103088:	83 c4 08             	add    $0x8,%esp
}
8010308b:	90                   	nop
8010308c:	c9                   	leave  
8010308d:	c3                   	ret    

8010308e <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010308e:	55                   	push   %ebp
8010308f:	89 e5                	mov    %esp,%ebp
}
80103091:	90                   	nop
80103092:	5d                   	pop    %ebp
80103093:	c3                   	ret    

80103094 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103094:	55                   	push   %ebp
80103095:	89 e5                	mov    %esp,%ebp
80103097:	83 ec 14             	sub    $0x14,%esp
8010309a:	8b 45 08             	mov    0x8(%ebp),%eax
8010309d:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801030a0:	6a 0f                	push   $0xf
801030a2:	6a 70                	push   $0x70
801030a4:	e8 02 fe ff ff       	call   80102eab <outb>
801030a9:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801030ac:	6a 0a                	push   $0xa
801030ae:	6a 71                	push   $0x71
801030b0:	e8 f6 fd ff ff       	call   80102eab <outb>
801030b5:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801030b8:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801030bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030c2:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801030c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030ca:	83 c0 02             	add    $0x2,%eax
801030cd:	8b 55 0c             	mov    0xc(%ebp),%edx
801030d0:	c1 ea 04             	shr    $0x4,%edx
801030d3:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801030d6:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030da:	c1 e0 18             	shl    $0x18,%eax
801030dd:	50                   	push   %eax
801030de:	68 c4 00 00 00       	push   $0xc4
801030e3:	e8 f2 fd ff ff       	call   80102eda <lapicw>
801030e8:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801030eb:	68 00 c5 00 00       	push   $0xc500
801030f0:	68 c0 00 00 00       	push   $0xc0
801030f5:	e8 e0 fd ff ff       	call   80102eda <lapicw>
801030fa:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030fd:	68 c8 00 00 00       	push   $0xc8
80103102:	e8 87 ff ff ff       	call   8010308e <microdelay>
80103107:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010310a:	68 00 85 00 00       	push   $0x8500
8010310f:	68 c0 00 00 00       	push   $0xc0
80103114:	e8 c1 fd ff ff       	call   80102eda <lapicw>
80103119:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010311c:	6a 64                	push   $0x64
8010311e:	e8 6b ff ff ff       	call   8010308e <microdelay>
80103123:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103126:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010312d:	eb 3d                	jmp    8010316c <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010312f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103133:	c1 e0 18             	shl    $0x18,%eax
80103136:	50                   	push   %eax
80103137:	68 c4 00 00 00       	push   $0xc4
8010313c:	e8 99 fd ff ff       	call   80102eda <lapicw>
80103141:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103144:	8b 45 0c             	mov    0xc(%ebp),%eax
80103147:	c1 e8 0c             	shr    $0xc,%eax
8010314a:	80 cc 06             	or     $0x6,%ah
8010314d:	50                   	push   %eax
8010314e:	68 c0 00 00 00       	push   $0xc0
80103153:	e8 82 fd ff ff       	call   80102eda <lapicw>
80103158:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010315b:	68 c8 00 00 00       	push   $0xc8
80103160:	e8 29 ff ff ff       	call   8010308e <microdelay>
80103165:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103168:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010316c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103170:	7e bd                	jle    8010312f <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103172:	90                   	nop
80103173:	c9                   	leave  
80103174:	c3                   	ret    

80103175 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103175:	55                   	push   %ebp
80103176:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103178:	8b 45 08             	mov    0x8(%ebp),%eax
8010317b:	0f b6 c0             	movzbl %al,%eax
8010317e:	50                   	push   %eax
8010317f:	6a 70                	push   $0x70
80103181:	e8 25 fd ff ff       	call   80102eab <outb>
80103186:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103189:	68 c8 00 00 00       	push   $0xc8
8010318e:	e8 fb fe ff ff       	call   8010308e <microdelay>
80103193:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103196:	6a 71                	push   $0x71
80103198:	e8 f1 fc ff ff       	call   80102e8e <inb>
8010319d:	83 c4 04             	add    $0x4,%esp
801031a0:	0f b6 c0             	movzbl %al,%eax
}
801031a3:	c9                   	leave  
801031a4:	c3                   	ret    

801031a5 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801031a5:	55                   	push   %ebp
801031a6:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801031a8:	6a 00                	push   $0x0
801031aa:	e8 c6 ff ff ff       	call   80103175 <cmos_read>
801031af:	83 c4 04             	add    $0x4,%esp
801031b2:	89 c2                	mov    %eax,%edx
801031b4:	8b 45 08             	mov    0x8(%ebp),%eax
801031b7:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801031b9:	6a 02                	push   $0x2
801031bb:	e8 b5 ff ff ff       	call   80103175 <cmos_read>
801031c0:	83 c4 04             	add    $0x4,%esp
801031c3:	89 c2                	mov    %eax,%edx
801031c5:	8b 45 08             	mov    0x8(%ebp),%eax
801031c8:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801031cb:	6a 04                	push   $0x4
801031cd:	e8 a3 ff ff ff       	call   80103175 <cmos_read>
801031d2:	83 c4 04             	add    $0x4,%esp
801031d5:	89 c2                	mov    %eax,%edx
801031d7:	8b 45 08             	mov    0x8(%ebp),%eax
801031da:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801031dd:	6a 07                	push   $0x7
801031df:	e8 91 ff ff ff       	call   80103175 <cmos_read>
801031e4:	83 c4 04             	add    $0x4,%esp
801031e7:	89 c2                	mov    %eax,%edx
801031e9:	8b 45 08             	mov    0x8(%ebp),%eax
801031ec:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801031ef:	6a 08                	push   $0x8
801031f1:	e8 7f ff ff ff       	call   80103175 <cmos_read>
801031f6:	83 c4 04             	add    $0x4,%esp
801031f9:	89 c2                	mov    %eax,%edx
801031fb:	8b 45 08             	mov    0x8(%ebp),%eax
801031fe:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103201:	6a 09                	push   $0x9
80103203:	e8 6d ff ff ff       	call   80103175 <cmos_read>
80103208:	83 c4 04             	add    $0x4,%esp
8010320b:	89 c2                	mov    %eax,%edx
8010320d:	8b 45 08             	mov    0x8(%ebp),%eax
80103210:	89 50 14             	mov    %edx,0x14(%eax)
}
80103213:	90                   	nop
80103214:	c9                   	leave  
80103215:	c3                   	ret    

80103216 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103216:	55                   	push   %ebp
80103217:	89 e5                	mov    %esp,%ebp
80103219:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010321c:	6a 0b                	push   $0xb
8010321e:	e8 52 ff ff ff       	call   80103175 <cmos_read>
80103223:	83 c4 04             	add    $0x4,%esp
80103226:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010322c:	83 e0 04             	and    $0x4,%eax
8010322f:	85 c0                	test   %eax,%eax
80103231:	0f 94 c0             	sete   %al
80103234:	0f b6 c0             	movzbl %al,%eax
80103237:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010323a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010323d:	50                   	push   %eax
8010323e:	e8 62 ff ff ff       	call   801031a5 <fill_rtcdate>
80103243:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103246:	6a 0a                	push   $0xa
80103248:	e8 28 ff ff ff       	call   80103175 <cmos_read>
8010324d:	83 c4 04             	add    $0x4,%esp
80103250:	25 80 00 00 00       	and    $0x80,%eax
80103255:	85 c0                	test   %eax,%eax
80103257:	75 27                	jne    80103280 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103259:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010325c:	50                   	push   %eax
8010325d:	e8 43 ff ff ff       	call   801031a5 <fill_rtcdate>
80103262:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103265:	83 ec 04             	sub    $0x4,%esp
80103268:	6a 18                	push   $0x18
8010326a:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010326d:	50                   	push   %eax
8010326e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103271:	50                   	push   %eax
80103272:	e8 76 28 00 00       	call   80105aed <memcmp>
80103277:	83 c4 10             	add    $0x10,%esp
8010327a:	85 c0                	test   %eax,%eax
8010327c:	74 05                	je     80103283 <cmostime+0x6d>
8010327e:	eb ba                	jmp    8010323a <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103280:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103281:	eb b7                	jmp    8010323a <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
80103283:	90                   	nop
  }

  // convert
  if (bcd) {
80103284:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103288:	0f 84 b4 00 00 00    	je     80103342 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010328e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103291:	c1 e8 04             	shr    $0x4,%eax
80103294:	89 c2                	mov    %eax,%edx
80103296:	89 d0                	mov    %edx,%eax
80103298:	c1 e0 02             	shl    $0x2,%eax
8010329b:	01 d0                	add    %edx,%eax
8010329d:	01 c0                	add    %eax,%eax
8010329f:	89 c2                	mov    %eax,%edx
801032a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032a4:	83 e0 0f             	and    $0xf,%eax
801032a7:	01 d0                	add    %edx,%eax
801032a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801032ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032af:	c1 e8 04             	shr    $0x4,%eax
801032b2:	89 c2                	mov    %eax,%edx
801032b4:	89 d0                	mov    %edx,%eax
801032b6:	c1 e0 02             	shl    $0x2,%eax
801032b9:	01 d0                	add    %edx,%eax
801032bb:	01 c0                	add    %eax,%eax
801032bd:	89 c2                	mov    %eax,%edx
801032bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032c2:	83 e0 0f             	and    $0xf,%eax
801032c5:	01 d0                	add    %edx,%eax
801032c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801032ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032cd:	c1 e8 04             	shr    $0x4,%eax
801032d0:	89 c2                	mov    %eax,%edx
801032d2:	89 d0                	mov    %edx,%eax
801032d4:	c1 e0 02             	shl    $0x2,%eax
801032d7:	01 d0                	add    %edx,%eax
801032d9:	01 c0                	add    %eax,%eax
801032db:	89 c2                	mov    %eax,%edx
801032dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032e0:	83 e0 0f             	and    $0xf,%eax
801032e3:	01 d0                	add    %edx,%eax
801032e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801032e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032eb:	c1 e8 04             	shr    $0x4,%eax
801032ee:	89 c2                	mov    %eax,%edx
801032f0:	89 d0                	mov    %edx,%eax
801032f2:	c1 e0 02             	shl    $0x2,%eax
801032f5:	01 d0                	add    %edx,%eax
801032f7:	01 c0                	add    %eax,%eax
801032f9:	89 c2                	mov    %eax,%edx
801032fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032fe:	83 e0 0f             	and    $0xf,%eax
80103301:	01 d0                	add    %edx,%eax
80103303:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103306:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103309:	c1 e8 04             	shr    $0x4,%eax
8010330c:	89 c2                	mov    %eax,%edx
8010330e:	89 d0                	mov    %edx,%eax
80103310:	c1 e0 02             	shl    $0x2,%eax
80103313:	01 d0                	add    %edx,%eax
80103315:	01 c0                	add    %eax,%eax
80103317:	89 c2                	mov    %eax,%edx
80103319:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010331c:	83 e0 0f             	and    $0xf,%eax
8010331f:	01 d0                	add    %edx,%eax
80103321:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103324:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103327:	c1 e8 04             	shr    $0x4,%eax
8010332a:	89 c2                	mov    %eax,%edx
8010332c:	89 d0                	mov    %edx,%eax
8010332e:	c1 e0 02             	shl    $0x2,%eax
80103331:	01 d0                	add    %edx,%eax
80103333:	01 c0                	add    %eax,%eax
80103335:	89 c2                	mov    %eax,%edx
80103337:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010333a:	83 e0 0f             	and    $0xf,%eax
8010333d:	01 d0                	add    %edx,%eax
8010333f:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103342:	8b 45 08             	mov    0x8(%ebp),%eax
80103345:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103348:	89 10                	mov    %edx,(%eax)
8010334a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010334d:	89 50 04             	mov    %edx,0x4(%eax)
80103350:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103353:	89 50 08             	mov    %edx,0x8(%eax)
80103356:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103359:	89 50 0c             	mov    %edx,0xc(%eax)
8010335c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010335f:	89 50 10             	mov    %edx,0x10(%eax)
80103362:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103365:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103368:	8b 45 08             	mov    0x8(%ebp),%eax
8010336b:	8b 40 14             	mov    0x14(%eax),%eax
8010336e:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103374:	8b 45 08             	mov    0x8(%ebp),%eax
80103377:	89 50 14             	mov    %edx,0x14(%eax)
}
8010337a:	90                   	nop
8010337b:	c9                   	leave  
8010337c:	c3                   	ret    

8010337d <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010337d:	55                   	push   %ebp
8010337e:	89 e5                	mov    %esp,%ebp
80103380:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103383:	83 ec 08             	sub    $0x8,%esp
80103386:	68 fc 90 10 80       	push   $0x801090fc
8010338b:	68 80 32 11 80       	push   $0x80113280
80103390:	e8 6c 24 00 00       	call   80105801 <initlock>
80103395:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103398:	83 ec 08             	sub    $0x8,%esp
8010339b:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010339e:	50                   	push   %eax
8010339f:	ff 75 08             	pushl  0x8(%ebp)
801033a2:	e8 2b e0 ff ff       	call   801013d2 <readsb>
801033a7:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801033aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033ad:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
801033b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033b5:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = dev;
801033ba:	8b 45 08             	mov    0x8(%ebp),%eax
801033bd:	a3 c4 32 11 80       	mov    %eax,0x801132c4
  recover_from_log();
801033c2:	e8 b2 01 00 00       	call   80103579 <recover_from_log>
}
801033c7:	90                   	nop
801033c8:	c9                   	leave  
801033c9:	c3                   	ret    

801033ca <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801033ca:	55                   	push   %ebp
801033cb:	89 e5                	mov    %esp,%ebp
801033cd:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d7:	e9 95 00 00 00       	jmp    80103471 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801033dc:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
801033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033e5:	01 d0                	add    %edx,%eax
801033e7:	83 c0 01             	add    $0x1,%eax
801033ea:	89 c2                	mov    %eax,%edx
801033ec:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033f1:	83 ec 08             	sub    $0x8,%esp
801033f4:	52                   	push   %edx
801033f5:	50                   	push   %eax
801033f6:	e8 bb cd ff ff       	call   801001b6 <bread>
801033fb:	83 c4 10             	add    $0x10,%esp
801033fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103404:	83 c0 10             	add    $0x10,%eax
80103407:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010340e:	89 c2                	mov    %eax,%edx
80103410:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103415:	83 ec 08             	sub    $0x8,%esp
80103418:	52                   	push   %edx
80103419:	50                   	push   %eax
8010341a:	e8 97 cd ff ff       	call   801001b6 <bread>
8010341f:	83 c4 10             	add    $0x10,%esp
80103422:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103425:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103428:	8d 50 18             	lea    0x18(%eax),%edx
8010342b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010342e:	83 c0 18             	add    $0x18,%eax
80103431:	83 ec 04             	sub    $0x4,%esp
80103434:	68 00 02 00 00       	push   $0x200
80103439:	52                   	push   %edx
8010343a:	50                   	push   %eax
8010343b:	e8 05 27 00 00       	call   80105b45 <memmove>
80103440:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103443:	83 ec 0c             	sub    $0xc,%esp
80103446:	ff 75 ec             	pushl  -0x14(%ebp)
80103449:	e8 a1 cd ff ff       	call   801001ef <bwrite>
8010344e:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103451:	83 ec 0c             	sub    $0xc,%esp
80103454:	ff 75 f0             	pushl  -0x10(%ebp)
80103457:	e8 d2 cd ff ff       	call   8010022e <brelse>
8010345c:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010345f:	83 ec 0c             	sub    $0xc,%esp
80103462:	ff 75 ec             	pushl  -0x14(%ebp)
80103465:	e8 c4 cd ff ff       	call   8010022e <brelse>
8010346a:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010346d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103471:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103476:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103479:	0f 8f 5d ff ff ff    	jg     801033dc <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010347f:	90                   	nop
80103480:	c9                   	leave  
80103481:	c3                   	ret    

80103482 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103482:	55                   	push   %ebp
80103483:	89 e5                	mov    %esp,%ebp
80103485:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103488:	a1 b4 32 11 80       	mov    0x801132b4,%eax
8010348d:	89 c2                	mov    %eax,%edx
8010348f:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103494:	83 ec 08             	sub    $0x8,%esp
80103497:	52                   	push   %edx
80103498:	50                   	push   %eax
80103499:	e8 18 cd ff ff       	call   801001b6 <bread>
8010349e:	83 c4 10             	add    $0x10,%esp
801034a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801034a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a7:	83 c0 18             	add    $0x18,%eax
801034aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801034ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034b0:	8b 00                	mov    (%eax),%eax
801034b2:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
801034b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034be:	eb 1b                	jmp    801034db <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801034c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034c6:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801034ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034cd:	83 c2 10             	add    $0x10,%edx
801034d0:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801034d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034db:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801034e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034e3:	7f db                	jg     801034c0 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801034e5:	83 ec 0c             	sub    $0xc,%esp
801034e8:	ff 75 f0             	pushl  -0x10(%ebp)
801034eb:	e8 3e cd ff ff       	call   8010022e <brelse>
801034f0:	83 c4 10             	add    $0x10,%esp
}
801034f3:	90                   	nop
801034f4:	c9                   	leave  
801034f5:	c3                   	ret    

801034f6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034f6:	55                   	push   %ebp
801034f7:	89 e5                	mov    %esp,%ebp
801034f9:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034fc:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103501:	89 c2                	mov    %eax,%edx
80103503:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103508:	83 ec 08             	sub    $0x8,%esp
8010350b:	52                   	push   %edx
8010350c:	50                   	push   %eax
8010350d:	e8 a4 cc ff ff       	call   801001b6 <bread>
80103512:	83 c4 10             	add    $0x10,%esp
80103515:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010351b:	83 c0 18             	add    $0x18,%eax
8010351e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103521:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
80103527:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010352a:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010352c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103533:	eb 1b                	jmp    80103550 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103538:	83 c0 10             	add    $0x10,%eax
8010353b:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
80103542:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103545:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103548:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010354c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103550:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103555:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103558:	7f db                	jg     80103535 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010355a:	83 ec 0c             	sub    $0xc,%esp
8010355d:	ff 75 f0             	pushl  -0x10(%ebp)
80103560:	e8 8a cc ff ff       	call   801001ef <bwrite>
80103565:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103568:	83 ec 0c             	sub    $0xc,%esp
8010356b:	ff 75 f0             	pushl  -0x10(%ebp)
8010356e:	e8 bb cc ff ff       	call   8010022e <brelse>
80103573:	83 c4 10             	add    $0x10,%esp
}
80103576:	90                   	nop
80103577:	c9                   	leave  
80103578:	c3                   	ret    

80103579 <recover_from_log>:

static void
recover_from_log(void)
{
80103579:	55                   	push   %ebp
8010357a:	89 e5                	mov    %esp,%ebp
8010357c:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010357f:	e8 fe fe ff ff       	call   80103482 <read_head>
  install_trans(); // if committed, copy from log to disk
80103584:	e8 41 fe ff ff       	call   801033ca <install_trans>
  log.lh.n = 0;
80103589:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
80103590:	00 00 00 
  write_head(); // clear the log
80103593:	e8 5e ff ff ff       	call   801034f6 <write_head>
}
80103598:	90                   	nop
80103599:	c9                   	leave  
8010359a:	c3                   	ret    

8010359b <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010359b:	55                   	push   %ebp
8010359c:	89 e5                	mov    %esp,%ebp
8010359e:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801035a1:	83 ec 0c             	sub    $0xc,%esp
801035a4:	68 80 32 11 80       	push   $0x80113280
801035a9:	e8 75 22 00 00       	call   80105823 <acquire>
801035ae:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801035b1:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801035b6:	85 c0                	test   %eax,%eax
801035b8:	74 17                	je     801035d1 <begin_op+0x36>
      sleep(&log, &log.lock);
801035ba:	83 ec 08             	sub    $0x8,%esp
801035bd:	68 80 32 11 80       	push   $0x80113280
801035c2:	68 80 32 11 80       	push   $0x80113280
801035c7:	e8 6f 1a 00 00       	call   8010503b <sleep>
801035cc:	83 c4 10             	add    $0x10,%esp
801035cf:	eb e0                	jmp    801035b1 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035d1:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
801035d7:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801035dc:	8d 50 01             	lea    0x1(%eax),%edx
801035df:	89 d0                	mov    %edx,%eax
801035e1:	c1 e0 02             	shl    $0x2,%eax
801035e4:	01 d0                	add    %edx,%eax
801035e6:	01 c0                	add    %eax,%eax
801035e8:	01 c8                	add    %ecx,%eax
801035ea:	83 f8 1e             	cmp    $0x1e,%eax
801035ed:	7e 17                	jle    80103606 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801035ef:	83 ec 08             	sub    $0x8,%esp
801035f2:	68 80 32 11 80       	push   $0x80113280
801035f7:	68 80 32 11 80       	push   $0x80113280
801035fc:	e8 3a 1a 00 00       	call   8010503b <sleep>
80103601:	83 c4 10             	add    $0x10,%esp
80103604:	eb ab                	jmp    801035b1 <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103606:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010360b:	83 c0 01             	add    $0x1,%eax
8010360e:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
80103613:	83 ec 0c             	sub    $0xc,%esp
80103616:	68 80 32 11 80       	push   $0x80113280
8010361b:	e8 6a 22 00 00       	call   8010588a <release>
80103620:	83 c4 10             	add    $0x10,%esp
      break;
80103623:	90                   	nop
    }
  }
}
80103624:	90                   	nop
80103625:	c9                   	leave  
80103626:	c3                   	ret    

80103627 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103627:	55                   	push   %ebp
80103628:	89 e5                	mov    %esp,%ebp
8010362a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
8010362d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	68 80 32 11 80       	push   $0x80113280
8010363c:	e8 e2 21 00 00       	call   80105823 <acquire>
80103641:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103644:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103649:	83 e8 01             	sub    $0x1,%eax
8010364c:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
80103651:	a1 c0 32 11 80       	mov    0x801132c0,%eax
80103656:	85 c0                	test   %eax,%eax
80103658:	74 0d                	je     80103667 <end_op+0x40>
    panic("log.committing");
8010365a:	83 ec 0c             	sub    $0xc,%esp
8010365d:	68 00 91 10 80       	push   $0x80109100
80103662:	e8 ff ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103667:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010366c:	85 c0                	test   %eax,%eax
8010366e:	75 13                	jne    80103683 <end_op+0x5c>
    do_commit = 1;
80103670:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103677:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
8010367e:	00 00 00 
80103681:	eb 10                	jmp    80103693 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103683:	83 ec 0c             	sub    $0xc,%esp
80103686:	68 80 32 11 80       	push   $0x80113280
8010368b:	e8 92 1a 00 00       	call   80105122 <wakeup>
80103690:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103693:	83 ec 0c             	sub    $0xc,%esp
80103696:	68 80 32 11 80       	push   $0x80113280
8010369b:	e8 ea 21 00 00       	call   8010588a <release>
801036a0:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801036a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801036a7:	74 3f                	je     801036e8 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801036a9:	e8 f5 00 00 00       	call   801037a3 <commit>
    acquire(&log.lock);
801036ae:	83 ec 0c             	sub    $0xc,%esp
801036b1:	68 80 32 11 80       	push   $0x80113280
801036b6:	e8 68 21 00 00       	call   80105823 <acquire>
801036bb:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801036be:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
801036c5:	00 00 00 
    wakeup(&log);
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	68 80 32 11 80       	push   $0x80113280
801036d0:	e8 4d 1a 00 00       	call   80105122 <wakeup>
801036d5:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801036d8:	83 ec 0c             	sub    $0xc,%esp
801036db:	68 80 32 11 80       	push   $0x80113280
801036e0:	e8 a5 21 00 00       	call   8010588a <release>
801036e5:	83 c4 10             	add    $0x10,%esp
  }
}
801036e8:	90                   	nop
801036e9:	c9                   	leave  
801036ea:	c3                   	ret    

801036eb <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801036eb:	55                   	push   %ebp
801036ec:	89 e5                	mov    %esp,%ebp
801036ee:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036f8:	e9 95 00 00 00       	jmp    80103792 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036fd:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
80103703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103706:	01 d0                	add    %edx,%eax
80103708:	83 c0 01             	add    $0x1,%eax
8010370b:	89 c2                	mov    %eax,%edx
8010370d:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103712:	83 ec 08             	sub    $0x8,%esp
80103715:	52                   	push   %edx
80103716:	50                   	push   %eax
80103717:	e8 9a ca ff ff       	call   801001b6 <bread>
8010371c:	83 c4 10             	add    $0x10,%esp
8010371f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103725:	83 c0 10             	add    $0x10,%eax
80103728:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010372f:	89 c2                	mov    %eax,%edx
80103731:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103736:	83 ec 08             	sub    $0x8,%esp
80103739:	52                   	push   %edx
8010373a:	50                   	push   %eax
8010373b:	e8 76 ca ff ff       	call   801001b6 <bread>
80103740:	83 c4 10             	add    $0x10,%esp
80103743:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103746:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103749:	8d 50 18             	lea    0x18(%eax),%edx
8010374c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010374f:	83 c0 18             	add    $0x18,%eax
80103752:	83 ec 04             	sub    $0x4,%esp
80103755:	68 00 02 00 00       	push   $0x200
8010375a:	52                   	push   %edx
8010375b:	50                   	push   %eax
8010375c:	e8 e4 23 00 00       	call   80105b45 <memmove>
80103761:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103764:	83 ec 0c             	sub    $0xc,%esp
80103767:	ff 75 f0             	pushl  -0x10(%ebp)
8010376a:	e8 80 ca ff ff       	call   801001ef <bwrite>
8010376f:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103772:	83 ec 0c             	sub    $0xc,%esp
80103775:	ff 75 ec             	pushl  -0x14(%ebp)
80103778:	e8 b1 ca ff ff       	call   8010022e <brelse>
8010377d:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103780:	83 ec 0c             	sub    $0xc,%esp
80103783:	ff 75 f0             	pushl  -0x10(%ebp)
80103786:	e8 a3 ca ff ff       	call   8010022e <brelse>
8010378b:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010378e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103792:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103797:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010379a:	0f 8f 5d ff ff ff    	jg     801036fd <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801037a0:	90                   	nop
801037a1:	c9                   	leave  
801037a2:	c3                   	ret    

801037a3 <commit>:

static void
commit()
{
801037a3:	55                   	push   %ebp
801037a4:	89 e5                	mov    %esp,%ebp
801037a6:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801037a9:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037ae:	85 c0                	test   %eax,%eax
801037b0:	7e 1e                	jle    801037d0 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801037b2:	e8 34 ff ff ff       	call   801036eb <write_log>
    write_head();    // Write header to disk -- the real commit
801037b7:	e8 3a fd ff ff       	call   801034f6 <write_head>
    install_trans(); // Now install writes to home locations
801037bc:	e8 09 fc ff ff       	call   801033ca <install_trans>
    log.lh.n = 0; 
801037c1:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801037c8:	00 00 00 
    write_head();    // Erase the transaction from the log
801037cb:	e8 26 fd ff ff       	call   801034f6 <write_head>
  }
}
801037d0:	90                   	nop
801037d1:	c9                   	leave  
801037d2:	c3                   	ret    

801037d3 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037d3:	55                   	push   %ebp
801037d4:	89 e5                	mov    %esp,%ebp
801037d6:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037d9:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037de:	83 f8 1d             	cmp    $0x1d,%eax
801037e1:	7f 12                	jg     801037f5 <log_write+0x22>
801037e3:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037e8:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
801037ee:	83 ea 01             	sub    $0x1,%edx
801037f1:	39 d0                	cmp    %edx,%eax
801037f3:	7c 0d                	jl     80103802 <log_write+0x2f>
    panic("too big a transaction");
801037f5:	83 ec 0c             	sub    $0xc,%esp
801037f8:	68 0f 91 10 80       	push   $0x8010910f
801037fd:	e8 64 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103802:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103807:	85 c0                	test   %eax,%eax
80103809:	7f 0d                	jg     80103818 <log_write+0x45>
    panic("log_write outside of trans");
8010380b:	83 ec 0c             	sub    $0xc,%esp
8010380e:	68 25 91 10 80       	push   $0x80109125
80103813:	e8 4e cd ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103818:	83 ec 0c             	sub    $0xc,%esp
8010381b:	68 80 32 11 80       	push   $0x80113280
80103820:	e8 fe 1f 00 00       	call   80105823 <acquire>
80103825:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103828:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010382f:	eb 1d                	jmp    8010384e <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103831:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103834:	83 c0 10             	add    $0x10,%eax
80103837:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010383e:	89 c2                	mov    %eax,%edx
80103840:	8b 45 08             	mov    0x8(%ebp),%eax
80103843:	8b 40 08             	mov    0x8(%eax),%eax
80103846:	39 c2                	cmp    %eax,%edx
80103848:	74 10                	je     8010385a <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
8010384a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010384e:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103853:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103856:	7f d9                	jg     80103831 <log_write+0x5e>
80103858:	eb 01                	jmp    8010385b <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
8010385a:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
8010385b:	8b 45 08             	mov    0x8(%ebp),%eax
8010385e:	8b 40 08             	mov    0x8(%eax),%eax
80103861:	89 c2                	mov    %eax,%edx
80103863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103866:	83 c0 10             	add    $0x10,%eax
80103869:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
80103870:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103875:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103878:	75 0d                	jne    80103887 <log_write+0xb4>
    log.lh.n++;
8010387a:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010387f:	83 c0 01             	add    $0x1,%eax
80103882:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
80103887:	8b 45 08             	mov    0x8(%ebp),%eax
8010388a:	8b 00                	mov    (%eax),%eax
8010388c:	83 c8 04             	or     $0x4,%eax
8010388f:	89 c2                	mov    %eax,%edx
80103891:	8b 45 08             	mov    0x8(%ebp),%eax
80103894:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103896:	83 ec 0c             	sub    $0xc,%esp
80103899:	68 80 32 11 80       	push   $0x80113280
8010389e:	e8 e7 1f 00 00       	call   8010588a <release>
801038a3:	83 c4 10             	add    $0x10,%esp
}
801038a6:	90                   	nop
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    

801038a9 <v2p>:
801038a9:	55                   	push   %ebp
801038aa:	89 e5                	mov    %esp,%ebp
801038ac:	8b 45 08             	mov    0x8(%ebp),%eax
801038af:	05 00 00 00 80       	add    $0x80000000,%eax
801038b4:	5d                   	pop    %ebp
801038b5:	c3                   	ret    

801038b6 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801038b6:	55                   	push   %ebp
801038b7:	89 e5                	mov    %esp,%ebp
801038b9:	8b 45 08             	mov    0x8(%ebp),%eax
801038bc:	05 00 00 00 80       	add    $0x80000000,%eax
801038c1:	5d                   	pop    %ebp
801038c2:	c3                   	ret    

801038c3 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801038c3:	55                   	push   %ebp
801038c4:	89 e5                	mov    %esp,%ebp
801038c6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038c9:	8b 55 08             	mov    0x8(%ebp),%edx
801038cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801038cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
801038d2:	f0 87 02             	lock xchg %eax,(%edx)
801038d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801038d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801038db:	c9                   	leave  
801038dc:	c3                   	ret    

801038dd <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801038dd:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038e1:	83 e4 f0             	and    $0xfffffff0,%esp
801038e4:	ff 71 fc             	pushl  -0x4(%ecx)
801038e7:	55                   	push   %ebp
801038e8:	89 e5                	mov    %esp,%ebp
801038ea:	51                   	push   %ecx
801038eb:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038ee:	83 ec 08             	sub    $0x8,%esp
801038f1:	68 00 00 40 80       	push   $0x80400000
801038f6:	68 3c 67 11 80       	push   $0x8011673c
801038fb:	e8 7d f2 ff ff       	call   80102b7d <kinit1>
80103900:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103903:	e8 07 4e 00 00       	call   8010870f <kvmalloc>
  mpinit();        // collect info about this machine
80103908:	e8 43 04 00 00       	call   80103d50 <mpinit>
  lapicinit();
8010390d:	e8 ea f5 ff ff       	call   80102efc <lapicinit>
  seginit();       // set up segments
80103912:	e8 a1 47 00 00       	call   801080b8 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103917:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010391d:	0f b6 00             	movzbl (%eax),%eax
80103920:	0f b6 c0             	movzbl %al,%eax
80103923:	83 ec 08             	sub    $0x8,%esp
80103926:	50                   	push   %eax
80103927:	68 40 91 10 80       	push   $0x80109140
8010392c:	e8 95 ca ff ff       	call   801003c6 <cprintf>
80103931:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103934:	e8 6d 06 00 00       	call   80103fa6 <picinit>
  ioapicinit();    // another interrupt controller
80103939:	e8 34 f1 ff ff       	call   80102a72 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010393e:	e8 24 d2 ff ff       	call   80100b67 <consoleinit>
  uartinit();      // serial port
80103943:	e8 cc 3a 00 00       	call   80107414 <uartinit>
  pinit();         // process table
80103948:	e8 5d 0b 00 00       	call   801044aa <pinit>
  tvinit();        // trap vectors
8010394d:	e8 be 36 00 00       	call   80107010 <tvinit>
  binit();         // buffer cache
80103952:	e8 dd c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103957:	e8 67 d6 ff ff       	call   80100fc3 <fileinit>
  ideinit();       // disk
8010395c:	e8 19 ed ff ff       	call   8010267a <ideinit>
  if(!ismp)
80103961:	a1 64 33 11 80       	mov    0x80113364,%eax
80103966:	85 c0                	test   %eax,%eax
80103968:	75 05                	jne    8010396f <main+0x92>
    timerinit();   // uniprocessor timer
8010396a:	e8 f2 35 00 00       	call   80106f61 <timerinit>
  startothers();   // start other processors
8010396f:	e8 7f 00 00 00       	call   801039f3 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103974:	83 ec 08             	sub    $0x8,%esp
80103977:	68 00 00 00 8e       	push   $0x8e000000
8010397c:	68 00 00 40 80       	push   $0x80400000
80103981:	e8 30 f2 ff ff       	call   80102bb6 <kinit2>
80103986:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103989:	e8 f9 0c 00 00       	call   80104687 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
8010398e:	e8 1a 00 00 00       	call   801039ad <mpmain>

80103993 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103993:	55                   	push   %ebp
80103994:	89 e5                	mov    %esp,%ebp
80103996:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103999:	e8 89 4d 00 00       	call   80108727 <switchkvm>
  seginit();
8010399e:	e8 15 47 00 00       	call   801080b8 <seginit>
  lapicinit();
801039a3:	e8 54 f5 ff ff       	call   80102efc <lapicinit>
  mpmain();
801039a8:	e8 00 00 00 00       	call   801039ad <mpmain>

801039ad <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801039ad:	55                   	push   %ebp
801039ae:	89 e5                	mov    %esp,%ebp
801039b0:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801039b3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039b9:	0f b6 00             	movzbl (%eax),%eax
801039bc:	0f b6 c0             	movzbl %al,%eax
801039bf:	83 ec 08             	sub    $0x8,%esp
801039c2:	50                   	push   %eax
801039c3:	68 57 91 10 80       	push   $0x80109157
801039c8:	e8 f9 c9 ff ff       	call   801003c6 <cprintf>
801039cd:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801039d0:	e8 9c 37 00 00       	call   80107171 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801039d5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039db:	05 a8 00 00 00       	add    $0xa8,%eax
801039e0:	83 ec 08             	sub    $0x8,%esp
801039e3:	6a 01                	push   $0x1
801039e5:	50                   	push   %eax
801039e6:	e8 d8 fe ff ff       	call   801038c3 <xchg>
801039eb:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801039ee:	e8 f8 13 00 00       	call   80104deb <scheduler>

801039f3 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801039f3:	55                   	push   %ebp
801039f4:	89 e5                	mov    %esp,%ebp
801039f6:	53                   	push   %ebx
801039f7:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801039fa:	68 00 70 00 00       	push   $0x7000
801039ff:	e8 b2 fe ff ff       	call   801038b6 <p2v>
80103a04:	83 c4 04             	add    $0x4,%esp
80103a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a0a:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a0f:	83 ec 04             	sub    $0x4,%esp
80103a12:	50                   	push   %eax
80103a13:	68 2c c5 10 80       	push   $0x8010c52c
80103a18:	ff 75 f0             	pushl  -0x10(%ebp)
80103a1b:	e8 25 21 00 00       	call   80105b45 <memmove>
80103a20:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a23:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
80103a2a:	e9 90 00 00 00       	jmp    80103abf <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a2f:	e8 e6 f5 ff ff       	call   8010301a <cpunum>
80103a34:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a3a:	05 80 33 11 80       	add    $0x80113380,%eax
80103a3f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a42:	74 73                	je     80103ab7 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a44:	e8 6b f2 ff ff       	call   80102cb4 <kalloc>
80103a49:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a4f:	83 e8 04             	sub    $0x4,%eax
80103a52:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103a55:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103a5b:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a60:	83 e8 08             	sub    $0x8,%eax
80103a63:	c7 00 93 39 10 80    	movl   $0x80103993,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a6c:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103a6f:	83 ec 0c             	sub    $0xc,%esp
80103a72:	68 00 b0 10 80       	push   $0x8010b000
80103a77:	e8 2d fe ff ff       	call   801038a9 <v2p>
80103a7c:	83 c4 10             	add    $0x10,%esp
80103a7f:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103a81:	83 ec 0c             	sub    $0xc,%esp
80103a84:	ff 75 f0             	pushl  -0x10(%ebp)
80103a87:	e8 1d fe ff ff       	call   801038a9 <v2p>
80103a8c:	83 c4 10             	add    $0x10,%esp
80103a8f:	89 c2                	mov    %eax,%edx
80103a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a94:	0f b6 00             	movzbl (%eax),%eax
80103a97:	0f b6 c0             	movzbl %al,%eax
80103a9a:	83 ec 08             	sub    $0x8,%esp
80103a9d:	52                   	push   %edx
80103a9e:	50                   	push   %eax
80103a9f:	e8 f0 f5 ff ff       	call   80103094 <lapicstartap>
80103aa4:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103aa7:	90                   	nop
80103aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aab:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103ab1:	85 c0                	test   %eax,%eax
80103ab3:	74 f3                	je     80103aa8 <startothers+0xb5>
80103ab5:	eb 01                	jmp    80103ab8 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103ab7:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103ab8:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103abf:	a1 60 39 11 80       	mov    0x80113960,%eax
80103ac4:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103aca:	05 80 33 11 80       	add    $0x80113380,%eax
80103acf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103ad2:	0f 87 57 ff ff ff    	ja     80103a2f <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103ad8:	90                   	nop
80103ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103adc:	c9                   	leave  
80103add:	c3                   	ret    

80103ade <p2v>:
80103ade:	55                   	push   %ebp
80103adf:	89 e5                	mov    %esp,%ebp
80103ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ae4:	05 00 00 00 80       	add    $0x80000000,%eax
80103ae9:	5d                   	pop    %ebp
80103aea:	c3                   	ret    

80103aeb <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103aeb:	55                   	push   %ebp
80103aec:	89 e5                	mov    %esp,%ebp
80103aee:	83 ec 14             	sub    $0x14,%esp
80103af1:	8b 45 08             	mov    0x8(%ebp),%eax
80103af4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103af8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103afc:	89 c2                	mov    %eax,%edx
80103afe:	ec                   	in     (%dx),%al
80103aff:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b02:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103b06:	c9                   	leave  
80103b07:	c3                   	ret    

80103b08 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b08:	55                   	push   %ebp
80103b09:	89 e5                	mov    %esp,%ebp
80103b0b:	83 ec 08             	sub    $0x8,%esp
80103b0e:	8b 55 08             	mov    0x8(%ebp),%edx
80103b11:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b14:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b18:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b1b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b1f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b23:	ee                   	out    %al,(%dx)
}
80103b24:	90                   	nop
80103b25:	c9                   	leave  
80103b26:	c3                   	ret    

80103b27 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b27:	55                   	push   %ebp
80103b28:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b2a:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103b2f:	89 c2                	mov    %eax,%edx
80103b31:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103b36:	29 c2                	sub    %eax,%edx
80103b38:	89 d0                	mov    %edx,%eax
80103b3a:	c1 f8 02             	sar    $0x2,%eax
80103b3d:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103b43:	5d                   	pop    %ebp
80103b44:	c3                   	ret    

80103b45 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103b45:	55                   	push   %ebp
80103b46:	89 e5                	mov    %esp,%ebp
80103b48:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103b4b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103b59:	eb 15                	jmp    80103b70 <sum+0x2b>
    sum += addr[i];
80103b5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103b61:	01 d0                	add    %edx,%eax
80103b63:	0f b6 00             	movzbl (%eax),%eax
80103b66:	0f b6 c0             	movzbl %al,%eax
80103b69:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103b6c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103b70:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b73:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103b76:	7c e3                	jl     80103b5b <sum+0x16>
    sum += addr[i];
  return sum;
80103b78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103b7b:	c9                   	leave  
80103b7c:	c3                   	ret    

80103b7d <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b7d:	55                   	push   %ebp
80103b7e:	89 e5                	mov    %esp,%ebp
80103b80:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103b83:	ff 75 08             	pushl  0x8(%ebp)
80103b86:	e8 53 ff ff ff       	call   80103ade <p2v>
80103b8b:	83 c4 04             	add    $0x4,%esp
80103b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b91:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b97:	01 d0                	add    %edx,%eax
80103b99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ba2:	eb 36                	jmp    80103bda <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ba4:	83 ec 04             	sub    $0x4,%esp
80103ba7:	6a 04                	push   $0x4
80103ba9:	68 68 91 10 80       	push   $0x80109168
80103bae:	ff 75 f4             	pushl  -0xc(%ebp)
80103bb1:	e8 37 1f 00 00       	call   80105aed <memcmp>
80103bb6:	83 c4 10             	add    $0x10,%esp
80103bb9:	85 c0                	test   %eax,%eax
80103bbb:	75 19                	jne    80103bd6 <mpsearch1+0x59>
80103bbd:	83 ec 08             	sub    $0x8,%esp
80103bc0:	6a 10                	push   $0x10
80103bc2:	ff 75 f4             	pushl  -0xc(%ebp)
80103bc5:	e8 7b ff ff ff       	call   80103b45 <sum>
80103bca:	83 c4 10             	add    $0x10,%esp
80103bcd:	84 c0                	test   %al,%al
80103bcf:	75 05                	jne    80103bd6 <mpsearch1+0x59>
      return (struct mp*)p;
80103bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd4:	eb 11                	jmp    80103be7 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103bd6:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bdd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103be0:	72 c2                	jb     80103ba4 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103be2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103be7:	c9                   	leave  
80103be8:	c3                   	ret    

80103be9 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103be9:	55                   	push   %ebp
80103bea:	89 e5                	mov    %esp,%ebp
80103bec:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103bef:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf9:	83 c0 0f             	add    $0xf,%eax
80103bfc:	0f b6 00             	movzbl (%eax),%eax
80103bff:	0f b6 c0             	movzbl %al,%eax
80103c02:	c1 e0 08             	shl    $0x8,%eax
80103c05:	89 c2                	mov    %eax,%edx
80103c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c0a:	83 c0 0e             	add    $0xe,%eax
80103c0d:	0f b6 00             	movzbl (%eax),%eax
80103c10:	0f b6 c0             	movzbl %al,%eax
80103c13:	09 d0                	or     %edx,%eax
80103c15:	c1 e0 04             	shl    $0x4,%eax
80103c18:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c1f:	74 21                	je     80103c42 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103c21:	83 ec 08             	sub    $0x8,%esp
80103c24:	68 00 04 00 00       	push   $0x400
80103c29:	ff 75 f0             	pushl  -0x10(%ebp)
80103c2c:	e8 4c ff ff ff       	call   80103b7d <mpsearch1>
80103c31:	83 c4 10             	add    $0x10,%esp
80103c34:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c3b:	74 51                	je     80103c8e <mpsearch+0xa5>
      return mp;
80103c3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c40:	eb 61                	jmp    80103ca3 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c45:	83 c0 14             	add    $0x14,%eax
80103c48:	0f b6 00             	movzbl (%eax),%eax
80103c4b:	0f b6 c0             	movzbl %al,%eax
80103c4e:	c1 e0 08             	shl    $0x8,%eax
80103c51:	89 c2                	mov    %eax,%edx
80103c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c56:	83 c0 13             	add    $0x13,%eax
80103c59:	0f b6 00             	movzbl (%eax),%eax
80103c5c:	0f b6 c0             	movzbl %al,%eax
80103c5f:	09 d0                	or     %edx,%eax
80103c61:	c1 e0 0a             	shl    $0xa,%eax
80103c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c6a:	2d 00 04 00 00       	sub    $0x400,%eax
80103c6f:	83 ec 08             	sub    $0x8,%esp
80103c72:	68 00 04 00 00       	push   $0x400
80103c77:	50                   	push   %eax
80103c78:	e8 00 ff ff ff       	call   80103b7d <mpsearch1>
80103c7d:	83 c4 10             	add    $0x10,%esp
80103c80:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c87:	74 05                	je     80103c8e <mpsearch+0xa5>
      return mp;
80103c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c8c:	eb 15                	jmp    80103ca3 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103c8e:	83 ec 08             	sub    $0x8,%esp
80103c91:	68 00 00 01 00       	push   $0x10000
80103c96:	68 00 00 0f 00       	push   $0xf0000
80103c9b:	e8 dd fe ff ff       	call   80103b7d <mpsearch1>
80103ca0:	83 c4 10             	add    $0x10,%esp
}
80103ca3:	c9                   	leave  
80103ca4:	c3                   	ret    

80103ca5 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ca5:	55                   	push   %ebp
80103ca6:	89 e5                	mov    %esp,%ebp
80103ca8:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103cab:	e8 39 ff ff ff       	call   80103be9 <mpsearch>
80103cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cb7:	74 0a                	je     80103cc3 <mpconfig+0x1e>
80103cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cbc:	8b 40 04             	mov    0x4(%eax),%eax
80103cbf:	85 c0                	test   %eax,%eax
80103cc1:	75 0a                	jne    80103ccd <mpconfig+0x28>
    return 0;
80103cc3:	b8 00 00 00 00       	mov    $0x0,%eax
80103cc8:	e9 81 00 00 00       	jmp    80103d4e <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd0:	8b 40 04             	mov    0x4(%eax),%eax
80103cd3:	83 ec 0c             	sub    $0xc,%esp
80103cd6:	50                   	push   %eax
80103cd7:	e8 02 fe ff ff       	call   80103ade <p2v>
80103cdc:	83 c4 10             	add    $0x10,%esp
80103cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ce2:	83 ec 04             	sub    $0x4,%esp
80103ce5:	6a 04                	push   $0x4
80103ce7:	68 6d 91 10 80       	push   $0x8010916d
80103cec:	ff 75 f0             	pushl  -0x10(%ebp)
80103cef:	e8 f9 1d 00 00       	call   80105aed <memcmp>
80103cf4:	83 c4 10             	add    $0x10,%esp
80103cf7:	85 c0                	test   %eax,%eax
80103cf9:	74 07                	je     80103d02 <mpconfig+0x5d>
    return 0;
80103cfb:	b8 00 00 00 00       	mov    $0x0,%eax
80103d00:	eb 4c                	jmp    80103d4e <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d05:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d09:	3c 01                	cmp    $0x1,%al
80103d0b:	74 12                	je     80103d1f <mpconfig+0x7a>
80103d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d10:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d14:	3c 04                	cmp    $0x4,%al
80103d16:	74 07                	je     80103d1f <mpconfig+0x7a>
    return 0;
80103d18:	b8 00 00 00 00       	mov    $0x0,%eax
80103d1d:	eb 2f                	jmp    80103d4e <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d22:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d26:	0f b7 c0             	movzwl %ax,%eax
80103d29:	83 ec 08             	sub    $0x8,%esp
80103d2c:	50                   	push   %eax
80103d2d:	ff 75 f0             	pushl  -0x10(%ebp)
80103d30:	e8 10 fe ff ff       	call   80103b45 <sum>
80103d35:	83 c4 10             	add    $0x10,%esp
80103d38:	84 c0                	test   %al,%al
80103d3a:	74 07                	je     80103d43 <mpconfig+0x9e>
    return 0;
80103d3c:	b8 00 00 00 00       	mov    $0x0,%eax
80103d41:	eb 0b                	jmp    80103d4e <mpconfig+0xa9>
  *pmp = mp;
80103d43:	8b 45 08             	mov    0x8(%ebp),%eax
80103d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d49:	89 10                	mov    %edx,(%eax)
  return conf;
80103d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d4e:	c9                   	leave  
80103d4f:	c3                   	ret    

80103d50 <mpinit>:

void
mpinit(void)
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103d56:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103d5d:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103d60:	83 ec 0c             	sub    $0xc,%esp
80103d63:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103d66:	50                   	push   %eax
80103d67:	e8 39 ff ff ff       	call   80103ca5 <mpconfig>
80103d6c:	83 c4 10             	add    $0x10,%esp
80103d6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d76:	0f 84 96 01 00 00    	je     80103f12 <mpinit+0x1c2>
    return;
  ismp = 1;
80103d7c:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103d83:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d89:	8b 40 24             	mov    0x24(%eax),%eax
80103d8c:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d94:	83 c0 2c             	add    $0x2c,%eax
80103d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d9d:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103da1:	0f b7 d0             	movzwl %ax,%edx
80103da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103da7:	01 d0                	add    %edx,%eax
80103da9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103dac:	e9 f2 00 00 00       	jmp    80103ea3 <mpinit+0x153>
    switch(*p){
80103db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db4:	0f b6 00             	movzbl (%eax),%eax
80103db7:	0f b6 c0             	movzbl %al,%eax
80103dba:	83 f8 04             	cmp    $0x4,%eax
80103dbd:	0f 87 bc 00 00 00    	ja     80103e7f <mpinit+0x12f>
80103dc3:	8b 04 85 b0 91 10 80 	mov    -0x7fef6e50(,%eax,4),%eax
80103dca:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103dd5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103dd9:	0f b6 d0             	movzbl %al,%edx
80103ddc:	a1 60 39 11 80       	mov    0x80113960,%eax
80103de1:	39 c2                	cmp    %eax,%edx
80103de3:	74 2b                	je     80103e10 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103de5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103de8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103dec:	0f b6 d0             	movzbl %al,%edx
80103def:	a1 60 39 11 80       	mov    0x80113960,%eax
80103df4:	83 ec 04             	sub    $0x4,%esp
80103df7:	52                   	push   %edx
80103df8:	50                   	push   %eax
80103df9:	68 72 91 10 80       	push   $0x80109172
80103dfe:	e8 c3 c5 ff ff       	call   801003c6 <cprintf>
80103e03:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e06:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103e0d:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e10:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e13:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103e17:	0f b6 c0             	movzbl %al,%eax
80103e1a:	83 e0 02             	and    $0x2,%eax
80103e1d:	85 c0                	test   %eax,%eax
80103e1f:	74 15                	je     80103e36 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103e21:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e26:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e2c:	05 80 33 11 80       	add    $0x80113380,%eax
80103e31:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103e36:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e3b:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103e41:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e47:	05 80 33 11 80       	add    $0x80113380,%eax
80103e4c:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103e4e:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e53:	83 c0 01             	add    $0x1,%eax
80103e56:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103e5b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103e5f:	eb 42                	jmp    80103ea3 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e6a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e6e:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103e73:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e77:	eb 2a                	jmp    80103ea3 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103e79:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e7d:	eb 24                	jmp    80103ea3 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e82:	0f b6 00             	movzbl (%eax),%eax
80103e85:	0f b6 c0             	movzbl %al,%eax
80103e88:	83 ec 08             	sub    $0x8,%esp
80103e8b:	50                   	push   %eax
80103e8c:	68 90 91 10 80       	push   $0x80109190
80103e91:	e8 30 c5 ff ff       	call   801003c6 <cprintf>
80103e96:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103e99:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103ea0:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ea6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ea9:	0f 82 02 ff ff ff    	jb     80103db1 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103eaf:	a1 64 33 11 80       	mov    0x80113364,%eax
80103eb4:	85 c0                	test   %eax,%eax
80103eb6:	75 1d                	jne    80103ed5 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103eb8:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103ebf:	00 00 00 
    lapic = 0;
80103ec2:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103ec9:	00 00 00 
    ioapicid = 0;
80103ecc:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103ed3:	eb 3e                	jmp    80103f13 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ed8:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103edc:	84 c0                	test   %al,%al
80103ede:	74 33                	je     80103f13 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103ee0:	83 ec 08             	sub    $0x8,%esp
80103ee3:	6a 70                	push   $0x70
80103ee5:	6a 22                	push   $0x22
80103ee7:	e8 1c fc ff ff       	call   80103b08 <outb>
80103eec:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103eef:	83 ec 0c             	sub    $0xc,%esp
80103ef2:	6a 23                	push   $0x23
80103ef4:	e8 f2 fb ff ff       	call   80103aeb <inb>
80103ef9:	83 c4 10             	add    $0x10,%esp
80103efc:	83 c8 01             	or     $0x1,%eax
80103eff:	0f b6 c0             	movzbl %al,%eax
80103f02:	83 ec 08             	sub    $0x8,%esp
80103f05:	50                   	push   %eax
80103f06:	6a 23                	push   $0x23
80103f08:	e8 fb fb ff ff       	call   80103b08 <outb>
80103f0d:	83 c4 10             	add    $0x10,%esp
80103f10:	eb 01                	jmp    80103f13 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103f12:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103f13:	c9                   	leave  
80103f14:	c3                   	ret    

80103f15 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103f15:	55                   	push   %ebp
80103f16:	89 e5                	mov    %esp,%ebp
80103f18:	83 ec 08             	sub    $0x8,%esp
80103f1b:	8b 55 08             	mov    0x8(%ebp),%edx
80103f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f21:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103f25:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f28:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f2c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f30:	ee                   	out    %al,(%dx)
}
80103f31:	90                   	nop
80103f32:	c9                   	leave  
80103f33:	c3                   	ret    

80103f34 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f34:	55                   	push   %ebp
80103f35:	89 e5                	mov    %esp,%ebp
80103f37:	83 ec 04             	sub    $0x4,%esp
80103f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f41:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f45:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103f4b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f4f:	0f b6 c0             	movzbl %al,%eax
80103f52:	50                   	push   %eax
80103f53:	6a 21                	push   $0x21
80103f55:	e8 bb ff ff ff       	call   80103f15 <outb>
80103f5a:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103f5d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f61:	66 c1 e8 08          	shr    $0x8,%ax
80103f65:	0f b6 c0             	movzbl %al,%eax
80103f68:	50                   	push   %eax
80103f69:	68 a1 00 00 00       	push   $0xa1
80103f6e:	e8 a2 ff ff ff       	call   80103f15 <outb>
80103f73:	83 c4 08             	add    $0x8,%esp
}
80103f76:	90                   	nop
80103f77:	c9                   	leave  
80103f78:	c3                   	ret    

80103f79 <picenable>:

void
picenable(int irq)
{
80103f79:	55                   	push   %ebp
80103f7a:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7f:	ba 01 00 00 00       	mov    $0x1,%edx
80103f84:	89 c1                	mov    %eax,%ecx
80103f86:	d3 e2                	shl    %cl,%edx
80103f88:	89 d0                	mov    %edx,%eax
80103f8a:	f7 d0                	not    %eax
80103f8c:	89 c2                	mov    %eax,%edx
80103f8e:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f95:	21 d0                	and    %edx,%eax
80103f97:	0f b7 c0             	movzwl %ax,%eax
80103f9a:	50                   	push   %eax
80103f9b:	e8 94 ff ff ff       	call   80103f34 <picsetmask>
80103fa0:	83 c4 04             	add    $0x4,%esp
}
80103fa3:	90                   	nop
80103fa4:	c9                   	leave  
80103fa5:	c3                   	ret    

80103fa6 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103fa6:	55                   	push   %ebp
80103fa7:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103fa9:	68 ff 00 00 00       	push   $0xff
80103fae:	6a 21                	push   $0x21
80103fb0:	e8 60 ff ff ff       	call   80103f15 <outb>
80103fb5:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103fb8:	68 ff 00 00 00       	push   $0xff
80103fbd:	68 a1 00 00 00       	push   $0xa1
80103fc2:	e8 4e ff ff ff       	call   80103f15 <outb>
80103fc7:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103fca:	6a 11                	push   $0x11
80103fcc:	6a 20                	push   $0x20
80103fce:	e8 42 ff ff ff       	call   80103f15 <outb>
80103fd3:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103fd6:	6a 20                	push   $0x20
80103fd8:	6a 21                	push   $0x21
80103fda:	e8 36 ff ff ff       	call   80103f15 <outb>
80103fdf:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103fe2:	6a 04                	push   $0x4
80103fe4:	6a 21                	push   $0x21
80103fe6:	e8 2a ff ff ff       	call   80103f15 <outb>
80103feb:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103fee:	6a 03                	push   $0x3
80103ff0:	6a 21                	push   $0x21
80103ff2:	e8 1e ff ff ff       	call   80103f15 <outb>
80103ff7:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103ffa:	6a 11                	push   $0x11
80103ffc:	68 a0 00 00 00       	push   $0xa0
80104001:	e8 0f ff ff ff       	call   80103f15 <outb>
80104006:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104009:	6a 28                	push   $0x28
8010400b:	68 a1 00 00 00       	push   $0xa1
80104010:	e8 00 ff ff ff       	call   80103f15 <outb>
80104015:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104018:	6a 02                	push   $0x2
8010401a:	68 a1 00 00 00       	push   $0xa1
8010401f:	e8 f1 fe ff ff       	call   80103f15 <outb>
80104024:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104027:	6a 03                	push   $0x3
80104029:	68 a1 00 00 00       	push   $0xa1
8010402e:	e8 e2 fe ff ff       	call   80103f15 <outb>
80104033:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104036:	6a 68                	push   $0x68
80104038:	6a 20                	push   $0x20
8010403a:	e8 d6 fe ff ff       	call   80103f15 <outb>
8010403f:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104042:	6a 0a                	push   $0xa
80104044:	6a 20                	push   $0x20
80104046:	e8 ca fe ff ff       	call   80103f15 <outb>
8010404b:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
8010404e:	6a 68                	push   $0x68
80104050:	68 a0 00 00 00       	push   $0xa0
80104055:	e8 bb fe ff ff       	call   80103f15 <outb>
8010405a:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
8010405d:	6a 0a                	push   $0xa
8010405f:	68 a0 00 00 00       	push   $0xa0
80104064:	e8 ac fe ff ff       	call   80103f15 <outb>
80104069:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
8010406c:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104073:	66 83 f8 ff          	cmp    $0xffff,%ax
80104077:	74 13                	je     8010408c <picinit+0xe6>
    picsetmask(irqmask);
80104079:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104080:	0f b7 c0             	movzwl %ax,%eax
80104083:	50                   	push   %eax
80104084:	e8 ab fe ff ff       	call   80103f34 <picsetmask>
80104089:	83 c4 04             	add    $0x4,%esp
}
8010408c:	90                   	nop
8010408d:	c9                   	leave  
8010408e:	c3                   	ret    

8010408f <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010408f:	55                   	push   %ebp
80104090:	89 e5                	mov    %esp,%ebp
80104092:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010409c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010409f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801040a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a8:	8b 10                	mov    (%eax),%edx
801040aa:	8b 45 08             	mov    0x8(%ebp),%eax
801040ad:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801040af:	e8 2d cf ff ff       	call   80100fe1 <filealloc>
801040b4:	89 c2                	mov    %eax,%edx
801040b6:	8b 45 08             	mov    0x8(%ebp),%eax
801040b9:	89 10                	mov    %edx,(%eax)
801040bb:	8b 45 08             	mov    0x8(%ebp),%eax
801040be:	8b 00                	mov    (%eax),%eax
801040c0:	85 c0                	test   %eax,%eax
801040c2:	0f 84 cb 00 00 00    	je     80104193 <pipealloc+0x104>
801040c8:	e8 14 cf ff ff       	call   80100fe1 <filealloc>
801040cd:	89 c2                	mov    %eax,%edx
801040cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d2:	89 10                	mov    %edx,(%eax)
801040d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d7:	8b 00                	mov    (%eax),%eax
801040d9:	85 c0                	test   %eax,%eax
801040db:	0f 84 b2 00 00 00    	je     80104193 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801040e1:	e8 ce eb ff ff       	call   80102cb4 <kalloc>
801040e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801040e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040ed:	0f 84 9f 00 00 00    	je     80104192 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801040f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f6:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801040fd:	00 00 00 
  p->writeopen = 1;
80104100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104103:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010410a:	00 00 00 
  p->nwrite = 0;
8010410d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104110:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104117:	00 00 00 
  p->nread = 0;
8010411a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104124:	00 00 00 
  initlock(&p->lock, "pipe");
80104127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412a:	83 ec 08             	sub    $0x8,%esp
8010412d:	68 c4 91 10 80       	push   $0x801091c4
80104132:	50                   	push   %eax
80104133:	e8 c9 16 00 00       	call   80105801 <initlock>
80104138:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010413b:	8b 45 08             	mov    0x8(%ebp),%eax
8010413e:	8b 00                	mov    (%eax),%eax
80104140:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104146:	8b 45 08             	mov    0x8(%ebp),%eax
80104149:	8b 00                	mov    (%eax),%eax
8010414b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010414f:	8b 45 08             	mov    0x8(%ebp),%eax
80104152:	8b 00                	mov    (%eax),%eax
80104154:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104158:	8b 45 08             	mov    0x8(%ebp),%eax
8010415b:	8b 00                	mov    (%eax),%eax
8010415d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104160:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104163:	8b 45 0c             	mov    0xc(%ebp),%eax
80104166:	8b 00                	mov    (%eax),%eax
80104168:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010416e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104171:	8b 00                	mov    (%eax),%eax
80104173:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104177:	8b 45 0c             	mov    0xc(%ebp),%eax
8010417a:	8b 00                	mov    (%eax),%eax
8010417c:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104180:	8b 45 0c             	mov    0xc(%ebp),%eax
80104183:	8b 00                	mov    (%eax),%eax
80104185:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104188:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010418b:	b8 00 00 00 00       	mov    $0x0,%eax
80104190:	eb 4e                	jmp    801041e0 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104192:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80104193:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104197:	74 0e                	je     801041a7 <pipealloc+0x118>
    kfree((char*)p);
80104199:	83 ec 0c             	sub    $0xc,%esp
8010419c:	ff 75 f4             	pushl  -0xc(%ebp)
8010419f:	e8 73 ea ff ff       	call   80102c17 <kfree>
801041a4:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801041a7:	8b 45 08             	mov    0x8(%ebp),%eax
801041aa:	8b 00                	mov    (%eax),%eax
801041ac:	85 c0                	test   %eax,%eax
801041ae:	74 11                	je     801041c1 <pipealloc+0x132>
    fileclose(*f0);
801041b0:	8b 45 08             	mov    0x8(%ebp),%eax
801041b3:	8b 00                	mov    (%eax),%eax
801041b5:	83 ec 0c             	sub    $0xc,%esp
801041b8:	50                   	push   %eax
801041b9:	e8 e1 ce ff ff       	call   8010109f <fileclose>
801041be:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801041c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c4:	8b 00                	mov    (%eax),%eax
801041c6:	85 c0                	test   %eax,%eax
801041c8:	74 11                	je     801041db <pipealloc+0x14c>
    fileclose(*f1);
801041ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801041cd:	8b 00                	mov    (%eax),%eax
801041cf:	83 ec 0c             	sub    $0xc,%esp
801041d2:	50                   	push   %eax
801041d3:	e8 c7 ce ff ff       	call   8010109f <fileclose>
801041d8:	83 c4 10             	add    $0x10,%esp
  return -1;
801041db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041e0:	c9                   	leave  
801041e1:	c3                   	ret    

801041e2 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801041e2:	55                   	push   %ebp
801041e3:	89 e5                	mov    %esp,%ebp
801041e5:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801041e8:	8b 45 08             	mov    0x8(%ebp),%eax
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	50                   	push   %eax
801041ef:	e8 2f 16 00 00       	call   80105823 <acquire>
801041f4:	83 c4 10             	add    $0x10,%esp
  if(writable){
801041f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801041fb:	74 23                	je     80104220 <pipeclose+0x3e>
    p->writeopen = 0;
801041fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104200:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104207:	00 00 00 
    wakeup(&p->nread);
8010420a:	8b 45 08             	mov    0x8(%ebp),%eax
8010420d:	05 34 02 00 00       	add    $0x234,%eax
80104212:	83 ec 0c             	sub    $0xc,%esp
80104215:	50                   	push   %eax
80104216:	e8 07 0f 00 00       	call   80105122 <wakeup>
8010421b:	83 c4 10             	add    $0x10,%esp
8010421e:	eb 21                	jmp    80104241 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104220:	8b 45 08             	mov    0x8(%ebp),%eax
80104223:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010422a:	00 00 00 
    wakeup(&p->nwrite);
8010422d:	8b 45 08             	mov    0x8(%ebp),%eax
80104230:	05 38 02 00 00       	add    $0x238,%eax
80104235:	83 ec 0c             	sub    $0xc,%esp
80104238:	50                   	push   %eax
80104239:	e8 e4 0e 00 00       	call   80105122 <wakeup>
8010423e:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104241:	8b 45 08             	mov    0x8(%ebp),%eax
80104244:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010424a:	85 c0                	test   %eax,%eax
8010424c:	75 2c                	jne    8010427a <pipeclose+0x98>
8010424e:	8b 45 08             	mov    0x8(%ebp),%eax
80104251:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104257:	85 c0                	test   %eax,%eax
80104259:	75 1f                	jne    8010427a <pipeclose+0x98>
    release(&p->lock);
8010425b:	8b 45 08             	mov    0x8(%ebp),%eax
8010425e:	83 ec 0c             	sub    $0xc,%esp
80104261:	50                   	push   %eax
80104262:	e8 23 16 00 00       	call   8010588a <release>
80104267:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010426a:	83 ec 0c             	sub    $0xc,%esp
8010426d:	ff 75 08             	pushl  0x8(%ebp)
80104270:	e8 a2 e9 ff ff       	call   80102c17 <kfree>
80104275:	83 c4 10             	add    $0x10,%esp
80104278:	eb 0f                	jmp    80104289 <pipeclose+0xa7>
  } else
    release(&p->lock);
8010427a:	8b 45 08             	mov    0x8(%ebp),%eax
8010427d:	83 ec 0c             	sub    $0xc,%esp
80104280:	50                   	push   %eax
80104281:	e8 04 16 00 00       	call   8010588a <release>
80104286:	83 c4 10             	add    $0x10,%esp
}
80104289:	90                   	nop
8010428a:	c9                   	leave  
8010428b:	c3                   	ret    

8010428c <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010428c:	55                   	push   %ebp
8010428d:	89 e5                	mov    %esp,%ebp
8010428f:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104292:	8b 45 08             	mov    0x8(%ebp),%eax
80104295:	83 ec 0c             	sub    $0xc,%esp
80104298:	50                   	push   %eax
80104299:	e8 85 15 00 00       	call   80105823 <acquire>
8010429e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801042a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042a8:	e9 ad 00 00 00       	jmp    8010435a <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801042ad:	8b 45 08             	mov    0x8(%ebp),%eax
801042b0:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042b6:	85 c0                	test   %eax,%eax
801042b8:	74 0d                	je     801042c7 <pipewrite+0x3b>
801042ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042c0:	8b 40 24             	mov    0x24(%eax),%eax
801042c3:	85 c0                	test   %eax,%eax
801042c5:	74 19                	je     801042e0 <pipewrite+0x54>
        release(&p->lock);
801042c7:	8b 45 08             	mov    0x8(%ebp),%eax
801042ca:	83 ec 0c             	sub    $0xc,%esp
801042cd:	50                   	push   %eax
801042ce:	e8 b7 15 00 00       	call   8010588a <release>
801042d3:	83 c4 10             	add    $0x10,%esp
        return -1;
801042d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042db:	e9 a8 00 00 00       	jmp    80104388 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801042e0:	8b 45 08             	mov    0x8(%ebp),%eax
801042e3:	05 34 02 00 00       	add    $0x234,%eax
801042e8:	83 ec 0c             	sub    $0xc,%esp
801042eb:	50                   	push   %eax
801042ec:	e8 31 0e 00 00       	call   80105122 <wakeup>
801042f1:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801042f4:	8b 45 08             	mov    0x8(%ebp),%eax
801042f7:	8b 55 08             	mov    0x8(%ebp),%edx
801042fa:	81 c2 38 02 00 00    	add    $0x238,%edx
80104300:	83 ec 08             	sub    $0x8,%esp
80104303:	50                   	push   %eax
80104304:	52                   	push   %edx
80104305:	e8 31 0d 00 00       	call   8010503b <sleep>
8010430a:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010430d:	8b 45 08             	mov    0x8(%ebp),%eax
80104310:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104316:	8b 45 08             	mov    0x8(%ebp),%eax
80104319:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010431f:	05 00 02 00 00       	add    $0x200,%eax
80104324:	39 c2                	cmp    %eax,%edx
80104326:	74 85                	je     801042ad <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104328:	8b 45 08             	mov    0x8(%ebp),%eax
8010432b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104331:	8d 48 01             	lea    0x1(%eax),%ecx
80104334:	8b 55 08             	mov    0x8(%ebp),%edx
80104337:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010433d:	25 ff 01 00 00       	and    $0x1ff,%eax
80104342:	89 c1                	mov    %eax,%ecx
80104344:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104347:	8b 45 0c             	mov    0xc(%ebp),%eax
8010434a:	01 d0                	add    %edx,%eax
8010434c:	0f b6 10             	movzbl (%eax),%edx
8010434f:	8b 45 08             	mov    0x8(%ebp),%eax
80104352:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104356:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010435a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435d:	3b 45 10             	cmp    0x10(%ebp),%eax
80104360:	7c ab                	jl     8010430d <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104362:	8b 45 08             	mov    0x8(%ebp),%eax
80104365:	05 34 02 00 00       	add    $0x234,%eax
8010436a:	83 ec 0c             	sub    $0xc,%esp
8010436d:	50                   	push   %eax
8010436e:	e8 af 0d 00 00       	call   80105122 <wakeup>
80104373:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104376:	8b 45 08             	mov    0x8(%ebp),%eax
80104379:	83 ec 0c             	sub    $0xc,%esp
8010437c:	50                   	push   %eax
8010437d:	e8 08 15 00 00       	call   8010588a <release>
80104382:	83 c4 10             	add    $0x10,%esp
  return n;
80104385:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104388:	c9                   	leave  
80104389:	c3                   	ret    

8010438a <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010438a:	55                   	push   %ebp
8010438b:	89 e5                	mov    %esp,%ebp
8010438d:	53                   	push   %ebx
8010438e:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104391:	8b 45 08             	mov    0x8(%ebp),%eax
80104394:	83 ec 0c             	sub    $0xc,%esp
80104397:	50                   	push   %eax
80104398:	e8 86 14 00 00       	call   80105823 <acquire>
8010439d:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043a0:	eb 3f                	jmp    801043e1 <piperead+0x57>
    if(proc->killed){
801043a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043a8:	8b 40 24             	mov    0x24(%eax),%eax
801043ab:	85 c0                	test   %eax,%eax
801043ad:	74 19                	je     801043c8 <piperead+0x3e>
      release(&p->lock);
801043af:	8b 45 08             	mov    0x8(%ebp),%eax
801043b2:	83 ec 0c             	sub    $0xc,%esp
801043b5:	50                   	push   %eax
801043b6:	e8 cf 14 00 00       	call   8010588a <release>
801043bb:	83 c4 10             	add    $0x10,%esp
      return -1;
801043be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043c3:	e9 bf 00 00 00       	jmp    80104487 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801043c8:	8b 45 08             	mov    0x8(%ebp),%eax
801043cb:	8b 55 08             	mov    0x8(%ebp),%edx
801043ce:	81 c2 34 02 00 00    	add    $0x234,%edx
801043d4:	83 ec 08             	sub    $0x8,%esp
801043d7:	50                   	push   %eax
801043d8:	52                   	push   %edx
801043d9:	e8 5d 0c 00 00       	call   8010503b <sleep>
801043de:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043e1:	8b 45 08             	mov    0x8(%ebp),%eax
801043e4:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801043ea:	8b 45 08             	mov    0x8(%ebp),%eax
801043ed:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043f3:	39 c2                	cmp    %eax,%edx
801043f5:	75 0d                	jne    80104404 <piperead+0x7a>
801043f7:	8b 45 08             	mov    0x8(%ebp),%eax
801043fa:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104400:	85 c0                	test   %eax,%eax
80104402:	75 9e                	jne    801043a2 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010440b:	eb 49                	jmp    80104456 <piperead+0xcc>
    if(p->nread == p->nwrite)
8010440d:	8b 45 08             	mov    0x8(%ebp),%eax
80104410:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104416:	8b 45 08             	mov    0x8(%ebp),%eax
80104419:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010441f:	39 c2                	cmp    %eax,%edx
80104421:	74 3d                	je     80104460 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104423:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104426:	8b 45 0c             	mov    0xc(%ebp),%eax
80104429:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010442c:	8b 45 08             	mov    0x8(%ebp),%eax
8010442f:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104435:	8d 48 01             	lea    0x1(%eax),%ecx
80104438:	8b 55 08             	mov    0x8(%ebp),%edx
8010443b:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104441:	25 ff 01 00 00       	and    $0x1ff,%eax
80104446:	89 c2                	mov    %eax,%edx
80104448:	8b 45 08             	mov    0x8(%ebp),%eax
8010444b:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104450:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104452:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104456:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104459:	3b 45 10             	cmp    0x10(%ebp),%eax
8010445c:	7c af                	jl     8010440d <piperead+0x83>
8010445e:	eb 01                	jmp    80104461 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
80104460:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104461:	8b 45 08             	mov    0x8(%ebp),%eax
80104464:	05 38 02 00 00       	add    $0x238,%eax
80104469:	83 ec 0c             	sub    $0xc,%esp
8010446c:	50                   	push   %eax
8010446d:	e8 b0 0c 00 00       	call   80105122 <wakeup>
80104472:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104475:	8b 45 08             	mov    0x8(%ebp),%eax
80104478:	83 ec 0c             	sub    $0xc,%esp
8010447b:	50                   	push   %eax
8010447c:	e8 09 14 00 00       	call   8010588a <release>
80104481:	83 c4 10             	add    $0x10,%esp
  return i;
80104484:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010448a:	c9                   	leave  
8010448b:	c3                   	ret    

8010448c <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
8010448c:	55                   	push   %ebp
8010448d:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
8010448f:	f4                   	hlt    
}
80104490:	90                   	nop
80104491:	5d                   	pop    %ebp
80104492:	c3                   	ret    

80104493 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104493:	55                   	push   %ebp
80104494:	89 e5                	mov    %esp,%ebp
80104496:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104499:	9c                   	pushf  
8010449a:	58                   	pop    %eax
8010449b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010449e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801044a1:	c9                   	leave  
801044a2:	c3                   	ret    

801044a3 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801044a3:	55                   	push   %ebp
801044a4:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801044a6:	fb                   	sti    
}
801044a7:	90                   	nop
801044a8:	5d                   	pop    %ebp
801044a9:	c3                   	ret    

801044aa <pinit>:
static int add_to_list(struct proc** sList, enum procstate state, struct proc* p);
static int add_to_ready(struct proc* p, enum procstate state);

void
pinit(void)
{
801044aa:	55                   	push   %ebp
801044ab:	89 e5                	mov    %esp,%ebp
801044ad:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801044b0:	83 ec 08             	sub    $0x8,%esp
801044b3:	68 cc 91 10 80       	push   $0x801091cc
801044b8:	68 80 39 11 80       	push   $0x80113980
801044bd:	e8 3f 13 00 00       	call   80105801 <initlock>
801044c2:	83 c4 10             	add    $0x10,%esp
}
801044c5:	90                   	nop
801044c6:	c9                   	leave  
801044c7:	c3                   	ret    

801044c8 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801044c8:	55                   	push   %ebp
801044c9:	89 e5                	mov    %esp,%ebp
801044cb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801044ce:	83 ec 0c             	sub    $0xc,%esp
801044d1:	68 80 39 11 80       	push   $0x80113980
801044d6:	e8 48 13 00 00       	call   80105823 <acquire>
801044db:	83 c4 10             	add    $0x10,%esp
  //#ifndef CS333_P3P4
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044de:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801044e5:	eb 11                	jmp    801044f8 <allocproc+0x30>
    if(p->state == UNUSED)
801044e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ea:	8b 40 0c             	mov    0xc(%eax),%eax
801044ed:	85 c0                	test   %eax,%eax
801044ef:	74 3d                	je     8010452e <allocproc+0x66>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  //#ifndef CS333_P3P4
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f1:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
801044f8:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
801044ff:	72 e6                	jb     801044e7 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  //#else
  p = ptable.pLists.free;
80104501:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80104506:	89 45 f4             	mov    %eax,-0xc(%ebp)
  remove_from_list(&ptable.pLists.free, p);
80104509:	83 ec 08             	sub    $0x8,%esp
8010450c:	ff 75 f4             	pushl  -0xc(%ebp)
8010450f:	68 b4 5e 11 80       	push   $0x80115eb4
80104514:	e8 ce 11 00 00       	call   801056e7 <remove_from_list>
80104519:	83 c4 10             	add    $0x10,%esp
  assert_state(p, UNUSED);
8010451c:	83 ec 08             	sub    $0x8,%esp
8010451f:	6a 00                	push   $0x0
80104521:	ff 75 f4             	pushl  -0xc(%ebp)
80104524:	e8 9d 11 00 00       	call   801056c6 <assert_state>
80104529:	83 c4 10             	add    $0x10,%esp
  goto found;
8010452c:	eb 01                	jmp    8010452f <allocproc+0x67>

  acquire(&ptable.lock);
  //#ifndef CS333_P3P4
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
8010452e:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  // Remove the lower 3 lines once flag is working when enabled
  p = ptable.pLists.free;
8010452f:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80104534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  remove_from_list(&ptable.pLists.free, p);
80104537:	83 ec 08             	sub    $0x8,%esp
8010453a:	ff 75 f4             	pushl  -0xc(%ebp)
8010453d:	68 b4 5e 11 80       	push   $0x80115eb4
80104542:	e8 a0 11 00 00       	call   801056e7 <remove_from_list>
80104547:	83 c4 10             	add    $0x10,%esp
  assert_state(p, UNUSED);
8010454a:	83 ec 08             	sub    $0x8,%esp
8010454d:	6a 00                	push   $0x0
8010454f:	ff 75 f4             	pushl  -0xc(%ebp)
80104552:	e8 6f 11 00 00       	call   801056c6 <assert_state>
80104557:	83 c4 10             	add    $0x10,%esp
  p->state = EMBRYO;
8010455a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455d:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  //#ifdef CS333_P3P4
  add_to_list(&ptable.pLists.embryo, EMBRYO, p);
80104564:	83 ec 04             	sub    $0x4,%esp
80104567:	ff 75 f4             	pushl  -0xc(%ebp)
8010456a:	6a 01                	push   $0x1
8010456c:	68 b8 5e 11 80       	push   $0x80115eb8
80104571:	e8 ab 11 00 00       	call   80105721 <add_to_list>
80104576:	83 c4 10             	add    $0x10,%esp
  //#endif
  p->pid = nextpid++;
80104579:	a1 04 c0 10 80       	mov    0x8010c004,%eax
8010457e:	8d 50 01             	lea    0x1(%eax),%edx
80104581:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104587:	89 c2                	mov    %eax,%edx
80104589:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458c:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
8010458f:	83 ec 0c             	sub    $0xc,%esp
80104592:	68 80 39 11 80       	push   $0x80113980
80104597:	e8 ee 12 00 00       	call   8010588a <release>
8010459c:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010459f:	e8 10 e7 ff ff       	call   80102cb4 <kalloc>
801045a4:	89 c2                	mov    %eax,%edx
801045a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a9:	89 50 08             	mov    %edx,0x8(%eax)
801045ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045af:	8b 40 08             	mov    0x8(%eax),%eax
801045b2:	85 c0                	test   %eax,%eax
801045b4:	75 4c                	jne    80104602 <allocproc+0x13a>
    //#ifdef CS333_P3P4
    remove_from_list(&ptable.pLists.embryo, p);
801045b6:	83 ec 08             	sub    $0x8,%esp
801045b9:	ff 75 f4             	pushl  -0xc(%ebp)
801045bc:	68 b8 5e 11 80       	push   $0x80115eb8
801045c1:	e8 21 11 00 00       	call   801056e7 <remove_from_list>
801045c6:	83 c4 10             	add    $0x10,%esp
    assert_state(p, EMBRYO);
801045c9:	83 ec 08             	sub    $0x8,%esp
801045cc:	6a 01                	push   $0x1
801045ce:	ff 75 f4             	pushl  -0xc(%ebp)
801045d1:	e8 f0 10 00 00       	call   801056c6 <assert_state>
801045d6:	83 c4 10             	add    $0x10,%esp
    //#endif
    p->state = UNUSED;
801045d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    //#ifdef CS333_P3P4
    add_to_list(&ptable.pLists.free, UNUSED, p);
801045e3:	83 ec 04             	sub    $0x4,%esp
801045e6:	ff 75 f4             	pushl  -0xc(%ebp)
801045e9:	6a 00                	push   $0x0
801045eb:	68 b4 5e 11 80       	push   $0x80115eb4
801045f0:	e8 2c 11 00 00       	call   80105721 <add_to_list>
801045f5:	83 c4 10             	add    $0x10,%esp
    //#endif
    return 0;
801045f8:	b8 00 00 00 00       	mov    $0x0,%eax
801045fd:	e9 83 00 00 00       	jmp    80104685 <allocproc+0x1bd>
  }
  sp = p->kstack + KSTACKSIZE;
80104602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104605:	8b 40 08             	mov    0x8(%eax),%eax
80104608:	05 00 10 00 00       	add    $0x1000,%eax
8010460d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104610:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104617:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010461a:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010461d:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104621:	ba be 6f 10 80       	mov    $0x80106fbe,%edx
80104626:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104629:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010462b:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010462f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104632:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104635:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010463e:	83 ec 04             	sub    $0x4,%esp
80104641:	6a 14                	push   $0x14
80104643:	6a 00                	push   $0x0
80104645:	50                   	push   %eax
80104646:	e8 3b 14 00 00       	call   80105a86 <memset>
8010464b:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010464e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104651:	8b 40 1c             	mov    0x1c(%eax),%eax
80104654:	ba f5 4f 10 80       	mov    $0x80104ff5,%edx
80104659:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // My code Allocate start ticks to global ticks variable
8010465c:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
80104662:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104665:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total = 0; // My code p2
80104668:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466b:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104672:	00 00 00 
  p->cpu_ticks_in = 0;    // My code p2
80104675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104678:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010467f:	00 00 00 
  return p;
80104682:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104685:	c9                   	leave  
80104686:	c3                   	ret    

80104687 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104687:	55                   	push   %ebp
80104688:	89 e5                	mov    %esp,%ebp
8010468a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  ptable.pLists.free = 0;
8010468d:	c7 05 b4 5e 11 80 00 	movl   $0x0,0x80115eb4
80104694:	00 00 00 
  ptable.pLists.embryo = 0;
80104697:	c7 05 b8 5e 11 80 00 	movl   $0x0,0x80115eb8
8010469e:	00 00 00 
  ptable.pLists.ready = 0;
801046a1:	c7 05 bc 5e 11 80 00 	movl   $0x0,0x80115ebc
801046a8:	00 00 00 
  ptable.pLists.running = 0;
801046ab:	c7 05 c0 5e 11 80 00 	movl   $0x0,0x80115ec0
801046b2:	00 00 00 
  ptable.pLists.sleep = 0;
801046b5:	c7 05 c4 5e 11 80 00 	movl   $0x0,0x80115ec4
801046bc:	00 00 00 
  ptable.pLists.zombie = 0;
801046bf:	c7 05 c8 5e 11 80 00 	movl   $0x0,0x80115ec8
801046c6:	00 00 00 

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c9:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801046d0:	eb 1c                	jmp    801046ee <userinit+0x67>
    add_to_list(&ptable.pLists.free, UNUSED, p);  
801046d2:	83 ec 04             	sub    $0x4,%esp
801046d5:	ff 75 f4             	pushl  -0xc(%ebp)
801046d8:	6a 00                	push   $0x0
801046da:	68 b4 5e 11 80       	push   $0x80115eb4
801046df:	e8 3d 10 00 00       	call   80105721 <add_to_list>
801046e4:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.running = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046e7:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
801046ee:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
801046f5:	72 db                	jb     801046d2 <userinit+0x4b>
    add_to_list(&ptable.pLists.free, UNUSED, p);  

  p = allocproc();
801046f7:	e8 cc fd ff ff       	call   801044c8 <allocproc>
801046fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801046ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104702:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104707:	e8 51 3f 00 00       	call   8010865d <setupkvm>
8010470c:	89 c2                	mov    %eax,%edx
8010470e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104711:	89 50 04             	mov    %edx,0x4(%eax)
80104714:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104717:	8b 40 04             	mov    0x4(%eax),%eax
8010471a:	85 c0                	test   %eax,%eax
8010471c:	75 0d                	jne    8010472b <userinit+0xa4>
    panic("userinit: out of memory?");
8010471e:	83 ec 0c             	sub    $0xc,%esp
80104721:	68 d3 91 10 80       	push   $0x801091d3
80104726:	e8 3b be ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010472b:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104733:	8b 40 04             	mov    0x4(%eax),%eax
80104736:	83 ec 04             	sub    $0x4,%esp
80104739:	52                   	push   %edx
8010473a:	68 00 c5 10 80       	push   $0x8010c500
8010473f:	50                   	push   %eax
80104740:	e8 72 41 00 00       	call   801088b7 <inituvm>
80104745:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474b:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104754:	8b 40 18             	mov    0x18(%eax),%eax
80104757:	83 ec 04             	sub    $0x4,%esp
8010475a:	6a 4c                	push   $0x4c
8010475c:	6a 00                	push   $0x0
8010475e:	50                   	push   %eax
8010475f:	e8 22 13 00 00       	call   80105a86 <memset>
80104764:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476a:	8b 40 18             	mov    0x18(%eax),%eax
8010476d:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104776:	8b 40 18             	mov    0x18(%eax),%eax
80104779:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010477f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104782:	8b 40 18             	mov    0x18(%eax),%eax
80104785:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104788:	8b 52 18             	mov    0x18(%edx),%edx
8010478b:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010478f:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104796:	8b 40 18             	mov    0x18(%eax),%eax
80104799:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010479c:	8b 52 18             	mov    0x18(%edx),%edx
8010479f:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047a3:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801047a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047aa:	8b 40 18             	mov    0x18(%eax),%eax
801047ad:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801047b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b7:	8b 40 18             	mov    0x18(%eax),%eax
801047ba:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801047c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c4:	8b 40 18             	mov    0x18(%eax),%eax
801047c7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->uid = DEFAULTUID; // p2
801047ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d1:	c7 80 80 00 00 00 0a 	movl   $0xa,0x80(%eax)
801047d8:	00 00 00 
  p->gid = DEFAULTGID; // p2
801047db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047de:	c7 80 84 00 00 00 0a 	movl   $0xa,0x84(%eax)
801047e5:	00 00 00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
801047e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047eb:	83 c0 6c             	add    $0x6c,%eax
801047ee:	83 ec 04             	sub    $0x4,%esp
801047f1:	6a 10                	push   $0x10
801047f3:	68 ec 91 10 80       	push   $0x801091ec
801047f8:	50                   	push   %eax
801047f9:	e8 8b 14 00 00       	call   80105c89 <safestrcpy>
801047fe:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104801:	83 ec 0c             	sub    $0xc,%esp
80104804:	68 f5 91 10 80       	push   $0x801091f5
80104809:	e8 68 dd ff ff       	call   80102576 <namei>
8010480e:	83 c4 10             	add    $0x10,%esp
80104811:	89 c2                	mov    %eax,%edx
80104813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104816:	89 50 68             	mov    %edx,0x68(%eax)

  // Will use ifdefs when flag works
  // ifdef
  acquire(&ptable.lock);
80104819:	83 ec 0c             	sub    $0xc,%esp
8010481c:	68 80 39 11 80       	push   $0x80113980
80104821:	e8 fd 0f 00 00       	call   80105823 <acquire>
80104826:	83 c4 10             	add    $0x10,%esp
  remove_from_list(&ptable.pLists.embryo, p);
80104829:	83 ec 08             	sub    $0x8,%esp
8010482c:	ff 75 f4             	pushl  -0xc(%ebp)
8010482f:	68 b8 5e 11 80       	push   $0x80115eb8
80104834:	e8 ae 0e 00 00       	call   801056e7 <remove_from_list>
80104839:	83 c4 10             	add    $0x10,%esp
  assert_state(p, EMBRYO);
8010483c:	83 ec 08             	sub    $0x8,%esp
8010483f:	6a 01                	push   $0x1
80104841:	ff 75 f4             	pushl  -0xc(%ebp)
80104844:	e8 7d 0e 00 00       	call   801056c6 <assert_state>
80104849:	83 c4 10             	add    $0x10,%esp
  // endif
  p->state = RUNNABLE;
8010484c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  // ifdef
  ptable.pLists.ready = p;
80104856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104859:	a3 bc 5e 11 80       	mov    %eax,0x80115ebc
  p->next = 0;
8010485e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104861:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104868:	00 00 00 
  release(&ptable.lock);
8010486b:	83 ec 0c             	sub    $0xc,%esp
8010486e:	68 80 39 11 80       	push   $0x80113980
80104873:	e8 12 10 00 00       	call   8010588a <release>
80104878:	83 c4 10             	add    $0x10,%esp
  // endif
  cprintf("Name: %s State: %d\n", p->name, p->state);
8010487b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487e:	8b 40 0c             	mov    0xc(%eax),%eax
80104881:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104884:	83 c2 6c             	add    $0x6c,%edx
80104887:	83 ec 04             	sub    $0x4,%esp
8010488a:	50                   	push   %eax
8010488b:	52                   	push   %edx
8010488c:	68 f7 91 10 80       	push   $0x801091f7
80104891:	e8 30 bb ff ff       	call   801003c6 <cprintf>
80104896:	83 c4 10             	add    $0x10,%esp
}
80104899:	90                   	nop
8010489a:	c9                   	leave  
8010489b:	c3                   	ret    

8010489c <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010489c:	55                   	push   %ebp
8010489d:	89 e5                	mov    %esp,%ebp
8010489f:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801048a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a8:	8b 00                	mov    (%eax),%eax
801048aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801048ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048b1:	7e 31                	jle    801048e4 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801048b3:	8b 55 08             	mov    0x8(%ebp),%edx
801048b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b9:	01 c2                	add    %eax,%edx
801048bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c1:	8b 40 04             	mov    0x4(%eax),%eax
801048c4:	83 ec 04             	sub    $0x4,%esp
801048c7:	52                   	push   %edx
801048c8:	ff 75 f4             	pushl  -0xc(%ebp)
801048cb:	50                   	push   %eax
801048cc:	e8 33 41 00 00       	call   80108a04 <allocuvm>
801048d1:	83 c4 10             	add    $0x10,%esp
801048d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048db:	75 3e                	jne    8010491b <growproc+0x7f>
      return -1;
801048dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e2:	eb 59                	jmp    8010493d <growproc+0xa1>
  } else if(n < 0){
801048e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048e8:	79 31                	jns    8010491b <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801048ea:	8b 55 08             	mov    0x8(%ebp),%edx
801048ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f0:	01 c2                	add    %eax,%edx
801048f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f8:	8b 40 04             	mov    0x4(%eax),%eax
801048fb:	83 ec 04             	sub    $0x4,%esp
801048fe:	52                   	push   %edx
801048ff:	ff 75 f4             	pushl  -0xc(%ebp)
80104902:	50                   	push   %eax
80104903:	e8 c5 41 00 00       	call   80108acd <deallocuvm>
80104908:	83 c4 10             	add    $0x10,%esp
8010490b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010490e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104912:	75 07                	jne    8010491b <growproc+0x7f>
      return -1;
80104914:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104919:	eb 22                	jmp    8010493d <growproc+0xa1>
  }
  proc->sz = sz;
8010491b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104921:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104924:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104926:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010492c:	83 ec 0c             	sub    $0xc,%esp
8010492f:	50                   	push   %eax
80104930:	e8 0f 3e 00 00       	call   80108744 <switchuvm>
80104935:	83 c4 10             	add    $0x10,%esp
  return 0;
80104938:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010493d:	c9                   	leave  
8010493e:	c3                   	ret    

8010493f <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010493f:	55                   	push   %ebp
80104940:	89 e5                	mov    %esp,%ebp
80104942:	57                   	push   %edi
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104948:	e8 7b fb ff ff       	call   801044c8 <allocproc>
8010494d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104950:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104954:	75 0a                	jne    80104960 <fork+0x21>
    return -1;
80104956:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010495b:	e9 21 02 00 00       	jmp    80104b81 <fork+0x242>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104960:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104966:	8b 10                	mov    (%eax),%edx
80104968:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010496e:	8b 40 04             	mov    0x4(%eax),%eax
80104971:	83 ec 08             	sub    $0x8,%esp
80104974:	52                   	push   %edx
80104975:	50                   	push   %eax
80104976:	e8 f0 42 00 00       	call   80108c6b <copyuvm>
8010497b:	83 c4 10             	add    $0x10,%esp
8010497e:	89 c2                	mov    %eax,%edx
80104980:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104983:	89 50 04             	mov    %edx,0x4(%eax)
80104986:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104989:	8b 40 04             	mov    0x4(%eax),%eax
8010498c:	85 c0                	test   %eax,%eax
8010498e:	0f 85 88 00 00 00    	jne    80104a1c <fork+0xdd>
    kfree(np->kstack);
80104994:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104997:	8b 40 08             	mov    0x8(%eax),%eax
8010499a:	83 ec 0c             	sub    $0xc,%esp
8010499d:	50                   	push   %eax
8010499e:	e8 74 e2 ff ff       	call   80102c17 <kfree>
801049a3:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801049a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    // ifdef
    acquire(&ptable.lock);
801049b0:	83 ec 0c             	sub    $0xc,%esp
801049b3:	68 80 39 11 80       	push   $0x80113980
801049b8:	e8 66 0e 00 00       	call   80105823 <acquire>
801049bd:	83 c4 10             	add    $0x10,%esp
    remove_from_list(&ptable.pLists.embryo, np);
801049c0:	83 ec 08             	sub    $0x8,%esp
801049c3:	ff 75 e0             	pushl  -0x20(%ebp)
801049c6:	68 b8 5e 11 80       	push   $0x80115eb8
801049cb:	e8 17 0d 00 00       	call   801056e7 <remove_from_list>
801049d0:	83 c4 10             	add    $0x10,%esp
    assert_state(np, EMBRYO);
801049d3:	83 ec 08             	sub    $0x8,%esp
801049d6:	6a 01                	push   $0x1
801049d8:	ff 75 e0             	pushl  -0x20(%ebp)
801049db:	e8 e6 0c 00 00       	call   801056c6 <assert_state>
801049e0:	83 c4 10             	add    $0x10,%esp
    // endif
    np->state = UNUSED;
801049e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    // ifdef
    add_to_list(&ptable.pLists.free, UNUSED, np);
801049ed:	83 ec 04             	sub    $0x4,%esp
801049f0:	ff 75 e0             	pushl  -0x20(%ebp)
801049f3:	6a 00                	push   $0x0
801049f5:	68 b4 5e 11 80       	push   $0x80115eb4
801049fa:	e8 22 0d 00 00       	call   80105721 <add_to_list>
801049ff:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104a02:	83 ec 0c             	sub    $0xc,%esp
80104a05:	68 80 39 11 80       	push   $0x80113980
80104a0a:	e8 7b 0e 00 00       	call   8010588a <release>
80104a0f:	83 c4 10             	add    $0x10,%esp
    // endif
    return -1;
80104a12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a17:	e9 65 01 00 00       	jmp    80104b81 <fork+0x242>
  }
  np->sz = proc->sz;
80104a1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a22:	8b 10                	mov    (%eax),%edx
80104a24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a27:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104a29:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a30:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a33:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104a36:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a39:	8b 50 18             	mov    0x18(%eax),%edx
80104a3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a42:	8b 40 18             	mov    0x18(%eax),%eax
80104a45:	89 c3                	mov    %eax,%ebx
80104a47:	b8 13 00 00 00       	mov    $0x13,%eax
80104a4c:	89 d7                	mov    %edx,%edi
80104a4e:	89 de                	mov    %ebx,%esi
80104a50:	89 c1                	mov    %eax,%ecx
80104a52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // I'm pretty sure that this is where we put the uid/gid copy
  np -> uid = proc -> uid; // p2
80104a54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a5a:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104a60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a63:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np -> gid = proc -> gid; // p2
80104a69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a6f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104a75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a78:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104a7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a81:	8b 40 18             	mov    0x18(%eax),%eax
80104a84:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104a8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104a92:	eb 43                	jmp    80104ad7 <fork+0x198>
    if(proc->ofile[i])
80104a94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a9d:	83 c2 08             	add    $0x8,%edx
80104aa0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104aa4:	85 c0                	test   %eax,%eax
80104aa6:	74 2b                	je     80104ad3 <fork+0x194>
      np->ofile[i] = filedup(proc->ofile[i]);
80104aa8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104ab1:	83 c2 08             	add    $0x8,%edx
80104ab4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ab8:	83 ec 0c             	sub    $0xc,%esp
80104abb:	50                   	push   %eax
80104abc:	e8 8d c5 ff ff       	call   8010104e <filedup>
80104ac1:	83 c4 10             	add    $0x10,%esp
80104ac4:	89 c1                	mov    %eax,%ecx
80104ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ac9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104acc:	83 c2 08             	add    $0x8,%edx
80104acf:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np -> gid = proc -> gid; // p2

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104ad3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104ad7:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104adb:	7e b7                	jle    80104a94 <fork+0x155>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104add:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae3:	8b 40 68             	mov    0x68(%eax),%eax
80104ae6:	83 ec 0c             	sub    $0xc,%esp
80104ae9:	50                   	push   %eax
80104aea:	e8 8f ce ff ff       	call   8010197e <idup>
80104aef:	83 c4 10             	add    $0x10,%esp
80104af2:	89 c2                	mov    %eax,%edx
80104af4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104af7:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104afa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b00:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b06:	83 c0 6c             	add    $0x6c,%eax
80104b09:	83 ec 04             	sub    $0x4,%esp
80104b0c:	6a 10                	push   $0x10
80104b0e:	52                   	push   %edx
80104b0f:	50                   	push   %eax
80104b10:	e8 74 11 00 00       	call   80105c89 <safestrcpy>
80104b15:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104b18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b1b:	8b 40 10             	mov    0x10(%eax),%eax
80104b1e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104b21:	83 ec 0c             	sub    $0xc,%esp
80104b24:	68 80 39 11 80       	push   $0x80113980
80104b29:	e8 f5 0c 00 00       	call   80105823 <acquire>
80104b2e:	83 c4 10             	add    $0x10,%esp
  // ifdef
  remove_from_list(&ptable.pLists.embryo, np);
80104b31:	83 ec 08             	sub    $0x8,%esp
80104b34:	ff 75 e0             	pushl  -0x20(%ebp)
80104b37:	68 b8 5e 11 80       	push   $0x80115eb8
80104b3c:	e8 a6 0b 00 00       	call   801056e7 <remove_from_list>
80104b41:	83 c4 10             	add    $0x10,%esp
  assert_state(np, EMBRYO);
80104b44:	83 ec 08             	sub    $0x8,%esp
80104b47:	6a 01                	push   $0x1
80104b49:	ff 75 e0             	pushl  -0x20(%ebp)
80104b4c:	e8 75 0b 00 00       	call   801056c6 <assert_state>
80104b51:	83 c4 10             	add    $0x10,%esp
  // endif
  np->state = RUNNABLE;
80104b54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  // ifdef
  add_to_ready(np, RUNNABLE);
80104b5e:	83 ec 08             	sub    $0x8,%esp
80104b61:	6a 03                	push   $0x3
80104b63:	ff 75 e0             	pushl  -0x20(%ebp)
80104b66:	e8 f7 0b 00 00       	call   80105762 <add_to_ready>
80104b6b:	83 c4 10             	add    $0x10,%esp
  // endif
  release(&ptable.lock);
80104b6e:	83 ec 0c             	sub    $0xc,%esp
80104b71:	68 80 39 11 80       	push   $0x80113980
80104b76:	e8 0f 0d 00 00       	call   8010588a <release>
80104b7b:	83 c4 10             	add    $0x10,%esp
  return pid;
80104b7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b84:	5b                   	pop    %ebx
80104b85:	5e                   	pop    %esi
80104b86:	5f                   	pop    %edi
80104b87:	5d                   	pop    %ebp
80104b88:	c3                   	ret    

80104b89 <exit>:
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
80104b89:	55                   	push   %ebp
80104b8a:	89 e5                	mov    %esp,%ebp
80104b8c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104b8f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b96:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104b9b:	39 c2                	cmp    %eax,%edx
80104b9d:	75 0d                	jne    80104bac <exit+0x23>
    panic("init exiting");
80104b9f:	83 ec 0c             	sub    $0xc,%esp
80104ba2:	68 0b 92 10 80       	push   $0x8010920b
80104ba7:	e8 ba b9 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104bac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104bb3:	eb 48                	jmp    80104bfd <exit+0x74>
    if(proc->ofile[fd]){
80104bb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bbe:	83 c2 08             	add    $0x8,%edx
80104bc1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104bc5:	85 c0                	test   %eax,%eax
80104bc7:	74 30                	je     80104bf9 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104bc9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bd2:	83 c2 08             	add    $0x8,%edx
80104bd5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104bd9:	83 ec 0c             	sub    $0xc,%esp
80104bdc:	50                   	push   %eax
80104bdd:	e8 bd c4 ff ff       	call   8010109f <fileclose>
80104be2:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104be5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104beb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bee:	83 c2 08             	add    $0x8,%edx
80104bf1:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104bf8:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104bf9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104bfd:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c01:	7e b2                	jle    80104bb5 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104c03:	e8 93 e9 ff ff       	call   8010359b <begin_op>
  iput(proc->cwd);
80104c08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c0e:	8b 40 68             	mov    0x68(%eax),%eax
80104c11:	83 ec 0c             	sub    $0xc,%esp
80104c14:	50                   	push   %eax
80104c15:	e8 6e cf ff ff       	call   80101b88 <iput>
80104c1a:	83 c4 10             	add    $0x10,%esp
  end_op();
80104c1d:	e8 05 ea ff ff       	call   80103627 <end_op>
  proc->cwd = 0;
80104c22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c28:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104c2f:	83 ec 0c             	sub    $0xc,%esp
80104c32:	68 80 39 11 80       	push   $0x80113980
80104c37:	e8 e7 0b 00 00       	call   80105823 <acquire>
80104c3c:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104c3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c45:	8b 40 14             	mov    0x14(%eax),%eax
80104c48:	83 ec 0c             	sub    $0xc,%esp
80104c4b:	50                   	push   %eax
80104c4c:	e8 8f 04 00 00       	call   801050e0 <wakeup1>
80104c51:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c54:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104c5b:	eb 3f                	jmp    80104c9c <exit+0x113>
    if(p->parent == proc){
80104c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c60:	8b 50 14             	mov    0x14(%eax),%edx
80104c63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c69:	39 c2                	cmp    %eax,%edx
80104c6b:	75 28                	jne    80104c95 <exit+0x10c>
      p->parent = initproc;
80104c6d:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c76:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c7c:	8b 40 0c             	mov    0xc(%eax),%eax
80104c7f:	83 f8 05             	cmp    $0x5,%eax
80104c82:	75 11                	jne    80104c95 <exit+0x10c>
        wakeup1(initproc);
80104c84:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104c89:	83 ec 0c             	sub    $0xc,%esp
80104c8c:	50                   	push   %eax
80104c8d:	e8 4e 04 00 00       	call   801050e0 <wakeup1>
80104c92:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c95:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104c9c:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104ca3:	72 b8                	jb     80104c5d <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104ca5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cab:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104cb2:	e8 11 02 00 00       	call   80104ec8 <sched>
  panic("zombie exit");
80104cb7:	83 ec 0c             	sub    $0xc,%esp
80104cba:	68 18 92 10 80       	push   $0x80109218
80104cbf:	e8 a2 b8 ff ff       	call   80100566 <panic>

80104cc4 <wait>:
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104cca:	83 ec 0c             	sub    $0xc,%esp
80104ccd:	68 80 39 11 80       	push   $0x80113980
80104cd2:	e8 4c 0b 00 00       	call   80105823 <acquire>
80104cd7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104cda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ce1:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104ce8:	e9 a9 00 00 00       	jmp    80104d96 <wait+0xd2>
      if(p->parent != proc)
80104ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf0:	8b 50 14             	mov    0x14(%eax),%edx
80104cf3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf9:	39 c2                	cmp    %eax,%edx
80104cfb:	0f 85 8d 00 00 00    	jne    80104d8e <wait+0xca>
        continue;
      havekids = 1;
80104d01:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d0b:	8b 40 0c             	mov    0xc(%eax),%eax
80104d0e:	83 f8 05             	cmp    $0x5,%eax
80104d11:	75 7c                	jne    80104d8f <wait+0xcb>
        // Found one.
        pid = p->pid;
80104d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d16:	8b 40 10             	mov    0x10(%eax),%eax
80104d19:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d1f:	8b 40 08             	mov    0x8(%eax),%eax
80104d22:	83 ec 0c             	sub    $0xc,%esp
80104d25:	50                   	push   %eax
80104d26:	e8 ec de ff ff       	call   80102c17 <kfree>
80104d2b:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d3b:	8b 40 04             	mov    0x4(%eax),%eax
80104d3e:	83 ec 0c             	sub    $0xc,%esp
80104d41:	50                   	push   %eax
80104d42:	e8 43 3e 00 00       	call   80108b8a <freevm>
80104d47:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d4d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d57:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d61:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d72:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104d79:	83 ec 0c             	sub    $0xc,%esp
80104d7c:	68 80 39 11 80       	push   $0x80113980
80104d81:	e8 04 0b 00 00       	call   8010588a <release>
80104d86:	83 c4 10             	add    $0x10,%esp
        return pid;
80104d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d8c:	eb 5b                	jmp    80104de9 <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104d8e:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d8f:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104d96:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104d9d:	0f 82 4a ff ff ff    	jb     80104ced <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104da3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104da7:	74 0d                	je     80104db6 <wait+0xf2>
80104da9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104daf:	8b 40 24             	mov    0x24(%eax),%eax
80104db2:	85 c0                	test   %eax,%eax
80104db4:	74 17                	je     80104dcd <wait+0x109>
      release(&ptable.lock);
80104db6:	83 ec 0c             	sub    $0xc,%esp
80104db9:	68 80 39 11 80       	push   $0x80113980
80104dbe:	e8 c7 0a 00 00       	call   8010588a <release>
80104dc3:	83 c4 10             	add    $0x10,%esp
      return -1;
80104dc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dcb:	eb 1c                	jmp    80104de9 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104dcd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dd3:	83 ec 08             	sub    $0x8,%esp
80104dd6:	68 80 39 11 80       	push   $0x80113980
80104ddb:	50                   	push   %eax
80104ddc:	e8 5a 02 00 00       	call   8010503b <sleep>
80104de1:	83 c4 10             	add    $0x10,%esp
  }
80104de4:	e9 f1 fe ff ff       	jmp    80104cda <wait+0x16>
}
80104de9:	c9                   	leave  
80104dea:	c3                   	ret    

80104deb <scheduler>:
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
80104deb:	55                   	push   %ebp
80104dec:	89 e5                	mov    %esp,%ebp
80104dee:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104df1:	e8 ad f6 ff ff       	call   801044a3 <sti>

    idle = 1;  // assume idle unless we schedule a process
80104df6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104dfd:	83 ec 0c             	sub    $0xc,%esp
80104e00:	68 80 39 11 80       	push   $0x80113980
80104e05:	e8 19 0a 00 00       	call   80105823 <acquire>
80104e0a:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e0d:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104e14:	eb 7c                	jmp    80104e92 <scheduler+0xa7>
      if(p->state != RUNNABLE)
80104e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e19:	8b 40 0c             	mov    0xc(%eax),%eax
80104e1c:	83 f8 03             	cmp    $0x3,%eax
80104e1f:	75 69                	jne    80104e8a <scheduler+0x9f>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
80104e21:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      proc = p;
80104e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e2b:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104e31:	83 ec 0c             	sub    $0xc,%esp
80104e34:	ff 75 f4             	pushl  -0xc(%ebp)
80104e37:	e8 08 39 00 00       	call   80108744 <switchuvm>
80104e3c:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e42:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      p->cpu_ticks_in = ticks; // My code p2
80104e49:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
80104e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e52:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
      swtch(&cpu->scheduler, proc->context);
80104e58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e5e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e61:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104e68:	83 c2 04             	add    $0x4,%edx
80104e6b:	83 ec 08             	sub    $0x8,%esp
80104e6e:	50                   	push   %eax
80104e6f:	52                   	push   %edx
80104e70:	e8 85 0e 00 00       	call   80105cfa <swtch>
80104e75:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104e78:	e8 aa 38 00 00       	call   80108727 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104e7d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104e84:	00 00 00 00 
80104e88:	eb 01                	jmp    80104e8b <scheduler+0xa0>
    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104e8a:	90                   	nop
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e8b:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104e92:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104e99:	0f 82 77 ff ff ff    	jb     80104e16 <scheduler+0x2b>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104e9f:	83 ec 0c             	sub    $0xc,%esp
80104ea2:	68 80 39 11 80       	push   $0x80113980
80104ea7:	e8 de 09 00 00       	call   8010588a <release>
80104eac:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
80104eaf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104eb3:	0f 84 38 ff ff ff    	je     80104df1 <scheduler+0x6>
      sti();
80104eb9:	e8 e5 f5 ff ff       	call   801044a3 <sti>
      hlt();
80104ebe:	e8 c9 f5 ff ff       	call   8010448c <hlt>
    }
  }
80104ec3:	e9 29 ff ff ff       	jmp    80104df1 <scheduler+0x6>

80104ec8 <sched>:
// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
80104ec8:	55                   	push   %ebp
80104ec9:	89 e5                	mov    %esp,%ebp
80104ecb:	53                   	push   %ebx
80104ecc:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80104ecf:	83 ec 0c             	sub    $0xc,%esp
80104ed2:	68 80 39 11 80       	push   $0x80113980
80104ed7:	e8 7a 0a 00 00       	call   80105956 <holding>
80104edc:	83 c4 10             	add    $0x10,%esp
80104edf:	85 c0                	test   %eax,%eax
80104ee1:	75 0d                	jne    80104ef0 <sched+0x28>
    panic("sched ptable.lock");
80104ee3:	83 ec 0c             	sub    $0xc,%esp
80104ee6:	68 24 92 10 80       	push   $0x80109224
80104eeb:	e8 76 b6 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104ef0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ef6:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104efc:	83 f8 01             	cmp    $0x1,%eax
80104eff:	74 0d                	je     80104f0e <sched+0x46>
    panic("sched locks");
80104f01:	83 ec 0c             	sub    $0xc,%esp
80104f04:	68 36 92 10 80       	push   $0x80109236
80104f09:	e8 58 b6 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104f0e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f14:	8b 40 0c             	mov    0xc(%eax),%eax
80104f17:	83 f8 04             	cmp    $0x4,%eax
80104f1a:	75 0d                	jne    80104f29 <sched+0x61>
    panic("sched running");
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	68 42 92 10 80       	push   $0x80109242
80104f24:	e8 3d b6 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104f29:	e8 65 f5 ff ff       	call   80104493 <readeflags>
80104f2e:	25 00 02 00 00       	and    $0x200,%eax
80104f33:	85 c0                	test   %eax,%eax
80104f35:	74 0d                	je     80104f44 <sched+0x7c>
    panic("sched interruptible");
80104f37:	83 ec 0c             	sub    $0xc,%esp
80104f3a:	68 50 92 10 80       	push   $0x80109250
80104f3f:	e8 22 b6 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104f44:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f4a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // My code p2
80104f53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f59:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f60:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80104f66:	8b 1d e0 66 11 80    	mov    0x801166e0,%ebx
80104f6c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f73:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80104f79:	29 d3                	sub    %edx,%ebx
80104f7b:	89 da                	mov    %ebx,%edx
80104f7d:	01 ca                	add    %ecx,%edx
80104f7f:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
80104f85:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f8b:	8b 40 04             	mov    0x4(%eax),%eax
80104f8e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f95:	83 c2 1c             	add    $0x1c,%edx
80104f98:	83 ec 08             	sub    $0x8,%esp
80104f9b:	50                   	push   %eax
80104f9c:	52                   	push   %edx
80104f9d:	e8 58 0d 00 00       	call   80105cfa <swtch>
80104fa2:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104fa5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fab:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fae:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104fb4:	90                   	nop
80104fb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fb8:	c9                   	leave  
80104fb9:	c3                   	ret    

80104fba <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104fba:	55                   	push   %ebp
80104fbb:	89 e5                	mov    %esp,%ebp
80104fbd:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104fc0:	83 ec 0c             	sub    $0xc,%esp
80104fc3:	68 80 39 11 80       	push   $0x80113980
80104fc8:	e8 56 08 00 00       	call   80105823 <acquire>
80104fcd:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
  assert_state(proc, RUNNING);
  #endif
  proc->state = RUNNABLE;
80104fd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fd6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  add_to_ready(proc, RUNNABLE);
  #endif
  sched();
80104fdd:	e8 e6 fe ff ff       	call   80104ec8 <sched>
  release(&ptable.lock);
80104fe2:	83 ec 0c             	sub    $0xc,%esp
80104fe5:	68 80 39 11 80       	push   $0x80113980
80104fea:	e8 9b 08 00 00       	call   8010588a <release>
80104fef:	83 c4 10             	add    $0x10,%esp
}
80104ff2:	90                   	nop
80104ff3:	c9                   	leave  
80104ff4:	c3                   	ret    

80104ff5 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104ff5:	55                   	push   %ebp
80104ff6:	89 e5                	mov    %esp,%ebp
80104ff8:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104ffb:	83 ec 0c             	sub    $0xc,%esp
80104ffe:	68 80 39 11 80       	push   $0x80113980
80105003:	e8 82 08 00 00       	call   8010588a <release>
80105008:	83 c4 10             	add    $0x10,%esp

  if (first) {
8010500b:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80105010:	85 c0                	test   %eax,%eax
80105012:	74 24                	je     80105038 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105014:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
8010501b:	00 00 00 
    iinit(ROOTDEV);
8010501e:	83 ec 0c             	sub    $0xc,%esp
80105021:	6a 01                	push   $0x1
80105023:	e8 64 c6 ff ff       	call   8010168c <iinit>
80105028:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
8010502b:	83 ec 0c             	sub    $0xc,%esp
8010502e:	6a 01                	push   $0x1
80105030:	e8 48 e3 ff ff       	call   8010337d <initlog>
80105035:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105038:	90                   	nop
80105039:	c9                   	leave  
8010503a:	c3                   	ret    

8010503b <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
8010503b:	55                   	push   %ebp
8010503c:	89 e5                	mov    %esp,%ebp
8010503e:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80105041:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105047:	85 c0                	test   %eax,%eax
80105049:	75 0d                	jne    80105058 <sleep+0x1d>
    panic("sleep");
8010504b:	83 ec 0c             	sub    $0xc,%esp
8010504e:	68 64 92 10 80       	push   $0x80109264
80105053:	e8 0e b5 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80105058:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
8010505f:	74 24                	je     80105085 <sleep+0x4a>
    acquire(&ptable.lock);
80105061:	83 ec 0c             	sub    $0xc,%esp
80105064:	68 80 39 11 80       	push   $0x80113980
80105069:	e8 b5 07 00 00       	call   80105823 <acquire>
8010506e:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105071:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105075:	74 0e                	je     80105085 <sleep+0x4a>
80105077:	83 ec 0c             	sub    $0xc,%esp
8010507a:	ff 75 0c             	pushl  0xc(%ebp)
8010507d:	e8 08 08 00 00       	call   8010588a <release>
80105082:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80105085:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010508b:	8b 55 08             	mov    0x8(%ebp),%edx
8010508e:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80105091:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105097:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
8010509e:	e8 25 fe ff ff       	call   80104ec8 <sched>

  // Tidy up.
  proc->chan = 0;
801050a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050a9:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
801050b0:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
801050b7:	74 24                	je     801050dd <sleep+0xa2>
    release(&ptable.lock);
801050b9:	83 ec 0c             	sub    $0xc,%esp
801050bc:	68 80 39 11 80       	push   $0x80113980
801050c1:	e8 c4 07 00 00       	call   8010588a <release>
801050c6:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
801050c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801050cd:	74 0e                	je     801050dd <sleep+0xa2>
801050cf:	83 ec 0c             	sub    $0xc,%esp
801050d2:	ff 75 0c             	pushl  0xc(%ebp)
801050d5:	e8 49 07 00 00       	call   80105823 <acquire>
801050da:	83 c4 10             	add    $0x10,%esp
  }
}
801050dd:	90                   	nop
801050de:	c9                   	leave  
801050df:	c3                   	ret    

801050e0 <wakeup1>:
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050e6:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
801050ed:	eb 27                	jmp    80105116 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
801050ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050f2:	8b 40 0c             	mov    0xc(%eax),%eax
801050f5:	83 f8 02             	cmp    $0x2,%eax
801050f8:	75 15                	jne    8010510f <wakeup1+0x2f>
801050fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050fd:	8b 40 20             	mov    0x20(%eax),%eax
80105100:	3b 45 08             	cmp    0x8(%ebp),%eax
80105103:	75 0a                	jne    8010510f <wakeup1+0x2f>
      p->state = RUNNABLE;
80105105:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105108:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010510f:	81 45 fc 94 00 00 00 	addl   $0x94,-0x4(%ebp)
80105116:	81 7d fc b4 5e 11 80 	cmpl   $0x80115eb4,-0x4(%ebp)
8010511d:	72 d0                	jb     801050ef <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
8010511f:	90                   	nop
80105120:	c9                   	leave  
80105121:	c3                   	ret    

80105122 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105122:	55                   	push   %ebp
80105123:	89 e5                	mov    %esp,%ebp
80105125:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105128:	83 ec 0c             	sub    $0xc,%esp
8010512b:	68 80 39 11 80       	push   $0x80113980
80105130:	e8 ee 06 00 00       	call   80105823 <acquire>
80105135:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	ff 75 08             	pushl  0x8(%ebp)
8010513e:	e8 9d ff ff ff       	call   801050e0 <wakeup1>
80105143:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105146:	83 ec 0c             	sub    $0xc,%esp
80105149:	68 80 39 11 80       	push   $0x80113980
8010514e:	e8 37 07 00 00       	call   8010588a <release>
80105153:	83 c4 10             	add    $0x10,%esp
}
80105156:	90                   	nop
80105157:	c9                   	leave  
80105158:	c3                   	ret    

80105159 <kill>:
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
80105159:	55                   	push   %ebp
8010515a:	89 e5                	mov    %esp,%ebp
8010515c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010515f:	83 ec 0c             	sub    $0xc,%esp
80105162:	68 80 39 11 80       	push   $0x80113980
80105167:	e8 b7 06 00 00       	call   80105823 <acquire>
8010516c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010516f:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80105176:	eb 4a                	jmp    801051c2 <kill+0x69>
    if(p->pid == pid){
80105178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010517b:	8b 50 10             	mov    0x10(%eax),%edx
8010517e:	8b 45 08             	mov    0x8(%ebp),%eax
80105181:	39 c2                	cmp    %eax,%edx
80105183:	75 36                	jne    801051bb <kill+0x62>
      p->killed = 1;
80105185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105188:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010518f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105192:	8b 40 0c             	mov    0xc(%eax),%eax
80105195:	83 f8 02             	cmp    $0x2,%eax
80105198:	75 0a                	jne    801051a4 <kill+0x4b>
        p->state = RUNNABLE;
8010519a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	68 80 39 11 80       	push   $0x80113980
801051ac:	e8 d9 06 00 00       	call   8010588a <release>
801051b1:	83 c4 10             	add    $0x10,%esp
      return 0;
801051b4:	b8 00 00 00 00       	mov    $0x0,%eax
801051b9:	eb 25                	jmp    801051e0 <kill+0x87>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051bb:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
801051c2:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
801051c9:	72 ad                	jb     80105178 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801051cb:	83 ec 0c             	sub    $0xc,%esp
801051ce:	68 80 39 11 80       	push   $0x80113980
801051d3:	e8 b2 06 00 00       	call   8010588a <release>
801051d8:	83 c4 10             	add    $0x10,%esp
  return -1;
801051db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051e0:	c9                   	leave  
801051e1:	c3                   	ret    

801051e2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801051e2:	55                   	push   %ebp
801051e3:	89 e5                	mov    %esp,%ebp
801051e5:	53                   	push   %ebx
801051e6:	83 ec 54             	sub    $0x54,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
801051e9:	83 ec 08             	sub    $0x8,%esp
801051ec:	68 94 92 10 80       	push   $0x80109294
801051f1:	68 98 92 10 80       	push   $0x80109298
801051f6:	68 9c 92 10 80       	push   $0x8010929c
801051fb:	68 a4 92 10 80       	push   $0x801092a4
80105200:	68 aa 92 10 80       	push   $0x801092aa
80105205:	68 af 92 10 80       	push   $0x801092af
8010520a:	68 b3 92 10 80       	push   $0x801092b3
8010520f:	68 b7 92 10 80       	push   $0x801092b7
80105214:	68 bc 92 10 80       	push   $0x801092bc
80105219:	68 c0 92 10 80       	push   $0x801092c0
8010521e:	e8 a3 b1 ff ff       	call   801003c6 <cprintf>
80105223:	83 c4 30             	add    $0x30,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105226:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
8010522d:	e9 2a 02 00 00       	jmp    8010545c <procdump+0x27a>
    if(p->state == UNUSED)
80105232:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105235:	8b 40 0c             	mov    0xc(%eax),%eax
80105238:	85 c0                	test   %eax,%eax
8010523a:	0f 84 14 02 00 00    	je     80105454 <procdump+0x272>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105240:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105243:	8b 40 0c             	mov    0xc(%eax),%eax
80105246:	83 f8 05             	cmp    $0x5,%eax
80105249:	77 23                	ja     8010526e <procdump+0x8c>
8010524b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010524e:	8b 40 0c             	mov    0xc(%eax),%eax
80105251:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80105258:	85 c0                	test   %eax,%eax
8010525a:	74 12                	je     8010526e <procdump+0x8c>
      state = states[p->state];
8010525c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010525f:	8b 40 0c             	mov    0xc(%eax),%eax
80105262:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80105269:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010526c:	eb 07                	jmp    80105275 <procdump+0x93>
    else
      state = "???";
8010526e:	c7 45 ec e4 92 10 80 	movl   $0x801092e4,-0x14(%ebp)
    uint seconds = (ticks - p->start_ticks)/100;
80105275:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
8010527b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010527e:	8b 40 7c             	mov    0x7c(%eax),%eax
80105281:	29 c2                	sub    %eax,%edx
80105283:	89 d0                	mov    %edx,%eax
80105285:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010528a:	f7 e2                	mul    %edx
8010528c:	89 d0                	mov    %edx,%eax
8010528e:	c1 e8 05             	shr    $0x5,%eax
80105291:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint partial_seconds = (ticks - p->start_ticks)%100;
80105294:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
8010529a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010529d:	8b 40 7c             	mov    0x7c(%eax),%eax
801052a0:	89 d1                	mov    %edx,%ecx
801052a2:	29 c1                	sub    %eax,%ecx
801052a4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801052a9:	89 c8                	mov    %ecx,%eax
801052ab:	f7 e2                	mul    %edx
801052ad:	89 d0                	mov    %edx,%eax
801052af:	c1 e8 05             	shr    $0x5,%eax
801052b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801052b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801052b8:	6b c0 64             	imul   $0x64,%eax,%eax
801052bb:	29 c1                	sub    %eax,%ecx
801052bd:	89 c8                	mov    %ecx,%eax
801052bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("%d\t %s\t %d\t %d\t", p->pid, p->name, p->uid, p->gid);
801052c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052c5:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801052cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052ce:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801052d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052d7:	8d 58 6c             	lea    0x6c(%eax),%ebx
801052da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052dd:	8b 40 10             	mov    0x10(%eax),%eax
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	51                   	push   %ecx
801052e4:	52                   	push   %edx
801052e5:	53                   	push   %ebx
801052e6:	50                   	push   %eax
801052e7:	68 e8 92 10 80       	push   $0x801092e8
801052ec:	e8 d5 b0 ff ff       	call   801003c6 <cprintf>
801052f1:	83 c4 20             	add    $0x20,%esp
    if (p->parent)
801052f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052f7:	8b 40 14             	mov    0x14(%eax),%eax
801052fa:	85 c0                	test   %eax,%eax
801052fc:	74 1c                	je     8010531a <procdump+0x138>
      cprintf("%d\t", p->parent->pid);
801052fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105301:	8b 40 14             	mov    0x14(%eax),%eax
80105304:	8b 40 10             	mov    0x10(%eax),%eax
80105307:	83 ec 08             	sub    $0x8,%esp
8010530a:	50                   	push   %eax
8010530b:	68 f8 92 10 80       	push   $0x801092f8
80105310:	e8 b1 b0 ff ff       	call   801003c6 <cprintf>
80105315:	83 c4 10             	add    $0x10,%esp
80105318:	eb 17                	jmp    80105331 <procdump+0x14f>
    else
      cprintf("%d\t", p->pid);
8010531a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010531d:	8b 40 10             	mov    0x10(%eax),%eax
80105320:	83 ec 08             	sub    $0x8,%esp
80105323:	50                   	push   %eax
80105324:	68 f8 92 10 80       	push   $0x801092f8
80105329:	e8 98 b0 ff ff       	call   801003c6 <cprintf>
8010532e:	83 c4 10             	add    $0x10,%esp
    cprintf(" %s\t %d.", state, seconds);
80105331:	83 ec 04             	sub    $0x4,%esp
80105334:	ff 75 e8             	pushl  -0x18(%ebp)
80105337:	ff 75 ec             	pushl  -0x14(%ebp)
8010533a:	68 fc 92 10 80       	push   $0x801092fc
8010533f:	e8 82 b0 ff ff       	call   801003c6 <cprintf>
80105344:	83 c4 10             	add    $0x10,%esp
    if (partial_seconds < 10)
80105347:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
8010534b:	77 10                	ja     8010535d <procdump+0x17b>
	cprintf("0");
8010534d:	83 ec 0c             	sub    $0xc,%esp
80105350:	68 05 93 10 80       	push   $0x80109305
80105355:	e8 6c b0 ff ff       	call   801003c6 <cprintf>
8010535a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t", partial_seconds);
8010535d:	83 ec 08             	sub    $0x8,%esp
80105360:	ff 75 e4             	pushl  -0x1c(%ebp)
80105363:	68 f8 92 10 80       	push   $0x801092f8
80105368:	e8 59 b0 ff ff       	call   801003c6 <cprintf>
8010536d:	83 c4 10             	add    $0x10,%esp
    uint cpu_seconds = p->cpu_ticks_total/100;
80105370:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105373:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105379:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010537e:	f7 e2                	mul    %edx
80105380:	89 d0                	mov    %edx,%eax
80105382:	c1 e8 05             	shr    $0x5,%eax
80105385:	89 45 e0             	mov    %eax,-0x20(%ebp)
    uint cpu_partial_seconds = p->cpu_ticks_total%100;
80105388:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010538b:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80105391:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105396:	89 c8                	mov    %ecx,%eax
80105398:	f7 e2                	mul    %edx
8010539a:	89 d0                	mov    %edx,%eax
8010539c:	c1 e8 05             	shr    $0x5,%eax
8010539f:	89 45 dc             	mov    %eax,-0x24(%ebp)
801053a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801053a5:	6b c0 64             	imul   $0x64,%eax,%eax
801053a8:	29 c1                	sub    %eax,%ecx
801053aa:	89 c8                	mov    %ecx,%eax
801053ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (cpu_partial_seconds < 10)
801053af:	83 7d dc 09          	cmpl   $0x9,-0x24(%ebp)
801053b3:	77 18                	ja     801053cd <procdump+0x1eb>
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
801053b5:	83 ec 04             	sub    $0x4,%esp
801053b8:	ff 75 dc             	pushl  -0x24(%ebp)
801053bb:	ff 75 e0             	pushl  -0x20(%ebp)
801053be:	68 07 93 10 80       	push   $0x80109307
801053c3:	e8 fe af ff ff       	call   801003c6 <cprintf>
801053c8:	83 c4 10             	add    $0x10,%esp
801053cb:	eb 16                	jmp    801053e3 <procdump+0x201>
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
801053cd:	83 ec 04             	sub    $0x4,%esp
801053d0:	ff 75 dc             	pushl  -0x24(%ebp)
801053d3:	ff 75 e0             	pushl  -0x20(%ebp)
801053d6:	68 11 93 10 80       	push   $0x80109311
801053db:	e8 e6 af ff ff       	call   801003c6 <cprintf>
801053e0:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801053e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053e6:	8b 40 0c             	mov    0xc(%eax),%eax
801053e9:	83 f8 02             	cmp    $0x2,%eax
801053ec:	75 54                	jne    80105442 <procdump+0x260>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801053ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053f1:	8b 40 1c             	mov    0x1c(%eax),%eax
801053f4:	8b 40 0c             	mov    0xc(%eax),%eax
801053f7:	83 c0 08             	add    $0x8,%eax
801053fa:	89 c2                	mov    %eax,%edx
801053fc:	83 ec 08             	sub    $0x8,%esp
801053ff:	8d 45 b4             	lea    -0x4c(%ebp),%eax
80105402:	50                   	push   %eax
80105403:	52                   	push   %edx
80105404:	e8 d3 04 00 00       	call   801058dc <getcallerpcs>
80105409:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010540c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105413:	eb 1c                	jmp    80105431 <procdump+0x24f>
        cprintf(" %p", pc[i]);
80105415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105418:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
8010541c:	83 ec 08             	sub    $0x8,%esp
8010541f:	50                   	push   %eax
80105420:	68 1a 93 10 80       	push   $0x8010931a
80105425:	e8 9c af ff ff       	call   801003c6 <cprintf>
8010542a:	83 c4 10             	add    $0x10,%esp
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010542d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105431:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105435:	7f 0b                	jg     80105442 <procdump+0x260>
80105437:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543a:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
8010543e:	85 c0                	test   %eax,%eax
80105440:	75 d3                	jne    80105415 <procdump+0x233>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105442:	83 ec 0c             	sub    $0xc,%esp
80105445:	68 1e 93 10 80       	push   $0x8010931e
8010544a:	e8 77 af ff ff       	call   801003c6 <cprintf>
8010544f:	83 c4 10             	add    $0x10,%esp
80105452:	eb 01                	jmp    80105455 <procdump+0x273>
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105454:	90                   	nop
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105455:	81 45 f0 94 00 00 00 	addl   $0x94,-0x10(%ebp)
8010545c:	81 7d f0 b4 5e 11 80 	cmpl   $0x80115eb4,-0x10(%ebp)
80105463:	0f 82 c9 fd ff ff    	jb     80105232 <procdump+0x50>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105469:	90                   	nop
8010546a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010546d:	c9                   	leave  
8010546e:	c3                   	ret    

8010546f <getproc_helper>:

int
getproc_helper(int m, struct uproc* table)
{
8010546f:	55                   	push   %ebp
80105470:	89 e5                	mov    %esp,%ebp
80105472:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int i = 0;
80105475:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
8010547c:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80105483:	e9 3d 01 00 00       	jmp    801055c5 <getproc_helper+0x156>
  {
    if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
80105488:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010548b:	8b 40 0c             	mov    0xc(%eax),%eax
8010548e:	83 f8 04             	cmp    $0x4,%eax
80105491:	74 1a                	je     801054ad <getproc_helper+0x3e>
80105493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105496:	8b 40 0c             	mov    0xc(%eax),%eax
80105499:	83 f8 03             	cmp    $0x3,%eax
8010549c:	74 0f                	je     801054ad <getproc_helper+0x3e>
8010549e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a1:	8b 40 0c             	mov    0xc(%eax),%eax
801054a4:	83 f8 02             	cmp    $0x2,%eax
801054a7:	0f 85 11 01 00 00    	jne    801055be <getproc_helper+0x14f>
    {
      table[i].pid = p->pid;
801054ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054b0:	6b d0 5c             	imul   $0x5c,%eax,%edx
801054b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801054b6:	01 c2                	add    %eax,%edx
801054b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054bb:	8b 40 10             	mov    0x10(%eax),%eax
801054be:	89 02                	mov    %eax,(%edx)
      table[i].uid = p->uid;
801054c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054c3:	6b d0 5c             	imul   $0x5c,%eax,%edx
801054c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c9:	01 c2                	add    %eax,%edx
801054cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ce:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801054d4:	89 42 04             	mov    %eax,0x4(%edx)
      table[i].gid = p->gid;
801054d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054da:	6b d0 5c             	imul   $0x5c,%eax,%edx
801054dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801054e0:	01 c2                	add    %eax,%edx
801054e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801054eb:	89 42 08             	mov    %eax,0x8(%edx)
      if (p->parent)
801054ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f1:	8b 40 14             	mov    0x14(%eax),%eax
801054f4:	85 c0                	test   %eax,%eax
801054f6:	74 19                	je     80105511 <getproc_helper+0xa2>
        table[i].ppid = p->parent->pid;
801054f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054fb:	6b d0 5c             	imul   $0x5c,%eax,%edx
801054fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105501:	01 c2                	add    %eax,%edx
80105503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105506:	8b 40 14             	mov    0x14(%eax),%eax
80105509:	8b 40 10             	mov    0x10(%eax),%eax
8010550c:	89 42 0c             	mov    %eax,0xc(%edx)
8010550f:	eb 14                	jmp    80105525 <getproc_helper+0xb6>
      else
        table[i].ppid = p->pid;
80105511:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105514:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105517:	8b 45 0c             	mov    0xc(%ebp),%eax
8010551a:	01 c2                	add    %eax,%edx
8010551c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010551f:	8b 40 10             	mov    0x10(%eax),%eax
80105522:	89 42 0c             	mov    %eax,0xc(%edx)
      table[i].elapsed_ticks = (ticks - p->start_ticks);
80105525:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105528:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010552b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010552e:	01 c2                	add    %eax,%edx
80105530:	8b 0d e0 66 11 80    	mov    0x801166e0,%ecx
80105536:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105539:	8b 40 7c             	mov    0x7c(%eax),%eax
8010553c:	29 c1                	sub    %eax,%ecx
8010553e:	89 c8                	mov    %ecx,%eax
80105540:	89 42 10             	mov    %eax,0x10(%edx)
      table[i].CPU_total_ticks = p->cpu_ticks_total;
80105543:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105546:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105549:	8b 45 0c             	mov    0xc(%ebp),%eax
8010554c:	01 c2                	add    %eax,%edx
8010554e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105551:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105557:	89 42 14             	mov    %eax,0x14(%edx)
      table[i].size = p->sz;
8010555a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010555d:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105560:	8b 45 0c             	mov    0xc(%ebp),%eax
80105563:	01 c2                	add    %eax,%edx
80105565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105568:	8b 00                	mov    (%eax),%eax
8010556a:	89 42 38             	mov    %eax,0x38(%edx)
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
8010556d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105570:	8b 40 0c             	mov    0xc(%eax),%eax
80105573:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
8010557a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010557d:	6b ca 5c             	imul   $0x5c,%edx,%ecx
80105580:	8b 55 0c             	mov    0xc(%ebp),%edx
80105583:	01 ca                	add    %ecx,%edx
80105585:	83 c2 18             	add    $0x18,%edx
80105588:	83 ec 04             	sub    $0x4,%esp
8010558b:	6a 05                	push   $0x5
8010558d:	50                   	push   %eax
8010558e:	52                   	push   %edx
8010558f:	e8 9d 06 00 00       	call   80105c31 <strncpy>
80105594:	83 c4 10             	add    $0x10,%esp
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
80105597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010559a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010559d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a0:	6b c8 5c             	imul   $0x5c,%eax,%ecx
801055a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801055a6:	01 c8                	add    %ecx,%eax
801055a8:	83 c0 3c             	add    $0x3c,%eax
801055ab:	83 ec 04             	sub    $0x4,%esp
801055ae:	6a 11                	push   $0x11
801055b0:	52                   	push   %edx
801055b1:	50                   	push   %eax
801055b2:	e8 7a 06 00 00       	call   80105c31 <strncpy>
801055b7:	83 c4 10             	add    $0x10,%esp
      i++;
801055ba:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
int
getproc_helper(int m, struct uproc* table)
{
  struct proc* p;
  int i = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
801055be:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
801055c5:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
801055cc:	73 0c                	jae    801055da <getproc_helper+0x16b>
801055ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055d1:	3b 45 08             	cmp    0x8(%ebp),%eax
801055d4:	0f 8c ae fe ff ff    	jl     80105488 <getproc_helper+0x19>
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
      i++;
    }
  }
  return i;  
801055da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801055dd:	c9                   	leave  
801055de:	c3                   	ret    

801055df <free_length>:

// Counts the number of procs in the free list when ctrl-f is pressed
void
free_length()
{
801055df:	55                   	push   %ebp
801055e0:	89 e5                	mov    %esp,%ebp
801055e2:	83 ec 18             	sub    $0x18,%esp
  struct proc* f = ptable.pLists.free;
801055e5:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
801055ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
801055ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (!f)
801055f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055f8:	75 25                	jne    8010561f <free_length+0x40>
    cprintf("Free List Size: %d\n", count);
801055fa:	83 ec 08             	sub    $0x8,%esp
801055fd:	ff 75 f0             	pushl  -0x10(%ebp)
80105600:	68 20 93 10 80       	push   $0x80109320
80105605:	e8 bc ad ff ff       	call   801003c6 <cprintf>
8010560a:	83 c4 10             	add    $0x10,%esp
  while (f)
8010560d:	eb 10                	jmp    8010561f <free_length+0x40>
  {
    ++count;
8010560f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    f = f->next;
80105613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105616:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010561c:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc* f = ptable.pLists.free;
  int count = 0;
  if (!f)
    cprintf("Free List Size: %d\n", count);
  while (f)
8010561f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105623:	75 ea                	jne    8010560f <free_length+0x30>
  {
    ++count;
    f = f->next;
  }
  cprintf("Free List Size: %d\n", count);
80105625:	83 ec 08             	sub    $0x8,%esp
80105628:	ff 75 f0             	pushl  -0x10(%ebp)
8010562b:	68 20 93 10 80       	push   $0x80109320
80105630:	e8 91 ad ff ff       	call   801003c6 <cprintf>
80105635:	83 c4 10             	add    $0x10,%esp
}
80105638:	90                   	nop
80105639:	c9                   	leave  
8010563a:	c3                   	ret    

8010563b <display_ready>:

// Displays the PIDs of all processes in the ready list
void
display_ready()
{
8010563b:	55                   	push   %ebp
8010563c:	89 e5                	mov    %esp,%ebp
8010563e:	83 ec 18             	sub    $0x18,%esp
  if (!ptable.pLists.ready)
80105641:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
80105646:	85 c0                	test   %eax,%eax
80105648:	75 10                	jne    8010565a <display_ready+0x1f>
    cprintf("No processes currently in ready.\n");
8010564a:	83 ec 0c             	sub    $0xc,%esp
8010564d:	68 34 93 10 80       	push   $0x80109334
80105652:	e8 6f ad ff ff       	call   801003c6 <cprintf>
80105657:	83 c4 10             	add    $0x10,%esp
  struct proc* t = ptable.pLists.ready;
8010565a:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
8010565f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (t) {
80105662:	eb 49                	jmp    801056ad <display_ready+0x72>
    if (!t->next)
80105664:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105667:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010566d:	85 c0                	test   %eax,%eax
8010566f:	75 19                	jne    8010568a <display_ready+0x4f>
      cprintf("%d", t->pid);
80105671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105674:	8b 40 10             	mov    0x10(%eax),%eax
80105677:	83 ec 08             	sub    $0x8,%esp
8010567a:	50                   	push   %eax
8010567b:	68 56 93 10 80       	push   $0x80109356
80105680:	e8 41 ad ff ff       	call   801003c6 <cprintf>
80105685:	83 c4 10             	add    $0x10,%esp
80105688:	eb 17                	jmp    801056a1 <display_ready+0x66>
    else
      cprintf("%d -> ", t->pid);
8010568a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010568d:	8b 40 10             	mov    0x10(%eax),%eax
80105690:	83 ec 08             	sub    $0x8,%esp
80105693:	50                   	push   %eax
80105694:	68 59 93 10 80       	push   $0x80109359
80105699:	e8 28 ad ff ff       	call   801003c6 <cprintf>
8010569e:	83 c4 10             	add    $0x10,%esp
    t = t->next;
801056a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801056aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
display_ready()
{
  if (!ptable.pLists.ready)
    cprintf("No processes currently in ready.\n");
  struct proc* t = ptable.pLists.ready;
  while (t) {
801056ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056b1:	75 b1                	jne    80105664 <display_ready+0x29>
      cprintf("%d", t->pid);
    else
      cprintf("%d -> ", t->pid);
    t = t->next;
  }
  cprintf("\n");
801056b3:	83 ec 0c             	sub    $0xc,%esp
801056b6:	68 1e 93 10 80       	push   $0x8010931e
801056bb:	e8 06 ad ff ff       	call   801003c6 <cprintf>
801056c0:	83 c4 10             	add    $0x10,%esp
}
801056c3:	90                   	nop
801056c4:	c9                   	leave  
801056c5:	c3                   	ret    

801056c6 <assert_state>:

// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
801056c6:	55                   	push   %ebp
801056c7:	89 e5                	mov    %esp,%ebp
801056c9:	83 ec 08             	sub    $0x8,%esp
  if (p->state == state)
801056cc:	8b 45 08             	mov    0x8(%ebp),%eax
801056cf:	8b 40 0c             	mov    0xc(%eax),%eax
801056d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801056d5:	74 0d                	je     801056e4 <assert_state+0x1e>
    return;
  panic("ERROR: States do not match.");
801056d7:	83 ec 0c             	sub    $0xc,%esp
801056da:	68 60 93 10 80       	push   $0x80109360
801056df:	e8 82 ae ff ff       	call   80100566 <panic>
// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
  if (p->state == state)
    return;
801056e4:	90                   	nop
  panic("ERROR: States do not match.");
}
801056e5:	c9                   	leave  
801056e6:	c3                   	ret    

801056e7 <remove_from_list>:

// Implementation of remove_from_list
static int
remove_from_list(struct proc** sList, struct proc* p)
{
801056e7:	55                   	push   %ebp
801056e8:	89 e5                	mov    %esp,%ebp
  if (!sList)
801056ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801056ee:	75 07                	jne    801056f7 <remove_from_list+0x10>
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f5:	eb 28                	jmp    8010571f <remove_from_list+0x38>
  p = *sList;
801056f7:	8b 45 08             	mov    0x8(%ebp),%eax
801056fa:	8b 00                	mov    (%eax),%eax
801056fc:	89 45 0c             	mov    %eax,0xc(%ebp)
  *sList = p->next;
801056ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105702:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105708:	8b 45 08             	mov    0x8(%ebp),%eax
8010570b:	89 10                	mov    %edx,(%eax)
  p->next = 0;
8010570d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105710:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105717:	00 00 00 
  return 0;
8010571a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010571f:	5d                   	pop    %ebp
80105720:	c3                   	ret    

80105721 <add_to_list>:

// Implementation of add_to_list
static int
add_to_list(struct proc** sList, enum procstate state, struct proc* p)
{
80105721:	55                   	push   %ebp
80105722:	89 e5                	mov    %esp,%ebp
80105724:	83 ec 08             	sub    $0x8,%esp
  if (!p)
80105727:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010572b:	75 07                	jne    80105734 <add_to_list+0x13>
    return -1;
8010572d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105732:	eb 2c                	jmp    80105760 <add_to_list+0x3f>
  assert_state(p, state);
80105734:	83 ec 08             	sub    $0x8,%esp
80105737:	ff 75 0c             	pushl  0xc(%ebp)
8010573a:	ff 75 10             	pushl  0x10(%ebp)
8010573d:	e8 84 ff ff ff       	call   801056c6 <assert_state>
80105742:	83 c4 10             	add    $0x10,%esp
  p->next = *sList;
80105745:	8b 45 08             	mov    0x8(%ebp),%eax
80105748:	8b 10                	mov    (%eax),%edx
8010574a:	8b 45 10             	mov    0x10(%ebp),%eax
8010574d:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  *sList = p;
80105753:	8b 45 08             	mov    0x8(%ebp),%eax
80105756:	8b 55 10             	mov    0x10(%ebp),%edx
80105759:	89 10                	mov    %edx,(%eax)
  return 0;
8010575b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105760:	c9                   	leave  
80105761:	c3                   	ret    

80105762 <add_to_ready>:

// Implementation of add_to_ready
static int
add_to_ready(struct proc* p, enum procstate state)
{
80105762:	55                   	push   %ebp
80105763:	89 e5                	mov    %esp,%ebp
80105765:	83 ec 18             	sub    $0x18,%esp
  if (!p)
80105768:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010576c:	75 07                	jne    80105775 <add_to_ready+0x13>
    return -1;
8010576e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105773:	eb 52                	jmp    801057c7 <add_to_ready+0x65>
  assert_state(p, state);
80105775:	83 ec 08             	sub    $0x8,%esp
80105778:	ff 75 0c             	pushl  0xc(%ebp)
8010577b:	ff 75 08             	pushl  0x8(%ebp)
8010577e:	e8 43 ff ff ff       	call   801056c6 <assert_state>
80105783:	83 c4 10             	add    $0x10,%esp
  struct proc* t = ptable.pLists.ready;
80105786:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
8010578b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (t->next)
8010578e:	eb 0c                	jmp    8010579c <add_to_ready+0x3a>
    t = t->next;
80105790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105793:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105799:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  if (!p)
    return -1;
  assert_state(p, state);
  struct proc* t = ptable.pLists.ready;
  while (t->next)
8010579c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010579f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801057a5:	85 c0                	test   %eax,%eax
801057a7:	75 e7                	jne    80105790 <add_to_ready+0x2e>
    t = t->next;
  t->next = p;
801057a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ac:	8b 55 08             	mov    0x8(%ebp),%edx
801057af:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  p->next = 0;
801057b5:	8b 45 08             	mov    0x8(%ebp),%eax
801057b8:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801057bf:	00 00 00 
  return 0;
801057c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057c7:	c9                   	leave  
801057c8:	c3                   	ret    

801057c9 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801057c9:	55                   	push   %ebp
801057ca:	89 e5                	mov    %esp,%ebp
801057cc:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801057cf:	9c                   	pushf  
801057d0:	58                   	pop    %eax
801057d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801057d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057d7:	c9                   	leave  
801057d8:	c3                   	ret    

801057d9 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801057d9:	55                   	push   %ebp
801057da:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801057dc:	fa                   	cli    
}
801057dd:	90                   	nop
801057de:	5d                   	pop    %ebp
801057df:	c3                   	ret    

801057e0 <sti>:

static inline void
sti(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801057e3:	fb                   	sti    
}
801057e4:	90                   	nop
801057e5:	5d                   	pop    %ebp
801057e6:	c3                   	ret    

801057e7 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801057e7:	55                   	push   %ebp
801057e8:	89 e5                	mov    %esp,%ebp
801057ea:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801057ed:	8b 55 08             	mov    0x8(%ebp),%edx
801057f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057f6:	f0 87 02             	lock xchg %eax,(%edx)
801057f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801057fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057ff:	c9                   	leave  
80105800:	c3                   	ret    

80105801 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105801:	55                   	push   %ebp
80105802:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105804:	8b 45 08             	mov    0x8(%ebp),%eax
80105807:	8b 55 0c             	mov    0xc(%ebp),%edx
8010580a:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010580d:	8b 45 08             	mov    0x8(%ebp),%eax
80105810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105816:	8b 45 08             	mov    0x8(%ebp),%eax
80105819:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105820:	90                   	nop
80105821:	5d                   	pop    %ebp
80105822:	c3                   	ret    

80105823 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105823:	55                   	push   %ebp
80105824:	89 e5                	mov    %esp,%ebp
80105826:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105829:	e8 52 01 00 00       	call   80105980 <pushcli>
  if(holding(lk))
8010582e:	8b 45 08             	mov    0x8(%ebp),%eax
80105831:	83 ec 0c             	sub    $0xc,%esp
80105834:	50                   	push   %eax
80105835:	e8 1c 01 00 00       	call   80105956 <holding>
8010583a:	83 c4 10             	add    $0x10,%esp
8010583d:	85 c0                	test   %eax,%eax
8010583f:	74 0d                	je     8010584e <acquire+0x2b>
    panic("acquire");
80105841:	83 ec 0c             	sub    $0xc,%esp
80105844:	68 7c 93 10 80       	push   $0x8010937c
80105849:	e8 18 ad ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010584e:	90                   	nop
8010584f:	8b 45 08             	mov    0x8(%ebp),%eax
80105852:	83 ec 08             	sub    $0x8,%esp
80105855:	6a 01                	push   $0x1
80105857:	50                   	push   %eax
80105858:	e8 8a ff ff ff       	call   801057e7 <xchg>
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	85 c0                	test   %eax,%eax
80105862:	75 eb                	jne    8010584f <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105864:	8b 45 08             	mov    0x8(%ebp),%eax
80105867:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010586e:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105871:	8b 45 08             	mov    0x8(%ebp),%eax
80105874:	83 c0 0c             	add    $0xc,%eax
80105877:	83 ec 08             	sub    $0x8,%esp
8010587a:	50                   	push   %eax
8010587b:	8d 45 08             	lea    0x8(%ebp),%eax
8010587e:	50                   	push   %eax
8010587f:	e8 58 00 00 00       	call   801058dc <getcallerpcs>
80105884:	83 c4 10             	add    $0x10,%esp
}
80105887:	90                   	nop
80105888:	c9                   	leave  
80105889:	c3                   	ret    

8010588a <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010588a:	55                   	push   %ebp
8010588b:	89 e5                	mov    %esp,%ebp
8010588d:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	ff 75 08             	pushl  0x8(%ebp)
80105896:	e8 bb 00 00 00       	call   80105956 <holding>
8010589b:	83 c4 10             	add    $0x10,%esp
8010589e:	85 c0                	test   %eax,%eax
801058a0:	75 0d                	jne    801058af <release+0x25>
    panic("release");
801058a2:	83 ec 0c             	sub    $0xc,%esp
801058a5:	68 84 93 10 80       	push   $0x80109384
801058aa:	e8 b7 ac ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801058af:	8b 45 08             	mov    0x8(%ebp),%eax
801058b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801058b9:	8b 45 08             	mov    0x8(%ebp),%eax
801058bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801058c3:	8b 45 08             	mov    0x8(%ebp),%eax
801058c6:	83 ec 08             	sub    $0x8,%esp
801058c9:	6a 00                	push   $0x0
801058cb:	50                   	push   %eax
801058cc:	e8 16 ff ff ff       	call   801057e7 <xchg>
801058d1:	83 c4 10             	add    $0x10,%esp

  popcli();
801058d4:	e8 ec 00 00 00       	call   801059c5 <popcli>
}
801058d9:	90                   	nop
801058da:	c9                   	leave  
801058db:	c3                   	ret    

801058dc <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801058dc:	55                   	push   %ebp
801058dd:	89 e5                	mov    %esp,%ebp
801058df:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801058e2:	8b 45 08             	mov    0x8(%ebp),%eax
801058e5:	83 e8 08             	sub    $0x8,%eax
801058e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801058eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801058f2:	eb 38                	jmp    8010592c <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801058f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801058f8:	74 53                	je     8010594d <getcallerpcs+0x71>
801058fa:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105901:	76 4a                	jbe    8010594d <getcallerpcs+0x71>
80105903:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105907:	74 44                	je     8010594d <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105909:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010590c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105913:	8b 45 0c             	mov    0xc(%ebp),%eax
80105916:	01 c2                	add    %eax,%edx
80105918:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010591b:	8b 40 04             	mov    0x4(%eax),%eax
8010591e:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105920:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105923:	8b 00                	mov    (%eax),%eax
80105925:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105928:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010592c:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105930:	7e c2                	jle    801058f4 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105932:	eb 19                	jmp    8010594d <getcallerpcs+0x71>
    pcs[i] = 0;
80105934:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105937:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010593e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105941:	01 d0                	add    %edx,%eax
80105943:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105949:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010594d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105951:	7e e1                	jle    80105934 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105953:	90                   	nop
80105954:	c9                   	leave  
80105955:	c3                   	ret    

80105956 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105956:	55                   	push   %ebp
80105957:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105959:	8b 45 08             	mov    0x8(%ebp),%eax
8010595c:	8b 00                	mov    (%eax),%eax
8010595e:	85 c0                	test   %eax,%eax
80105960:	74 17                	je     80105979 <holding+0x23>
80105962:	8b 45 08             	mov    0x8(%ebp),%eax
80105965:	8b 50 08             	mov    0x8(%eax),%edx
80105968:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010596e:	39 c2                	cmp    %eax,%edx
80105970:	75 07                	jne    80105979 <holding+0x23>
80105972:	b8 01 00 00 00       	mov    $0x1,%eax
80105977:	eb 05                	jmp    8010597e <holding+0x28>
80105979:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010597e:	5d                   	pop    %ebp
8010597f:	c3                   	ret    

80105980 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105986:	e8 3e fe ff ff       	call   801057c9 <readeflags>
8010598b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010598e:	e8 46 fe ff ff       	call   801057d9 <cli>
  if(cpu->ncli++ == 0)
80105993:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010599a:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801059a0:	8d 48 01             	lea    0x1(%eax),%ecx
801059a3:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801059a9:	85 c0                	test   %eax,%eax
801059ab:	75 15                	jne    801059c2 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801059ad:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801059b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059b6:	81 e2 00 02 00 00    	and    $0x200,%edx
801059bc:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801059c2:	90                   	nop
801059c3:	c9                   	leave  
801059c4:	c3                   	ret    

801059c5 <popcli>:

void
popcli(void)
{
801059c5:	55                   	push   %ebp
801059c6:	89 e5                	mov    %esp,%ebp
801059c8:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801059cb:	e8 f9 fd ff ff       	call   801057c9 <readeflags>
801059d0:	25 00 02 00 00       	and    $0x200,%eax
801059d5:	85 c0                	test   %eax,%eax
801059d7:	74 0d                	je     801059e6 <popcli+0x21>
    panic("popcli - interruptible");
801059d9:	83 ec 0c             	sub    $0xc,%esp
801059dc:	68 8c 93 10 80       	push   $0x8010938c
801059e1:	e8 80 ab ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801059e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801059ec:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801059f2:	83 ea 01             	sub    $0x1,%edx
801059f5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801059fb:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105a01:	85 c0                	test   %eax,%eax
80105a03:	79 0d                	jns    80105a12 <popcli+0x4d>
    panic("popcli");
80105a05:	83 ec 0c             	sub    $0xc,%esp
80105a08:	68 a3 93 10 80       	push   $0x801093a3
80105a0d:	e8 54 ab ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105a12:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105a18:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105a1e:	85 c0                	test   %eax,%eax
80105a20:	75 15                	jne    80105a37 <popcli+0x72>
80105a22:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105a28:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105a2e:	85 c0                	test   %eax,%eax
80105a30:	74 05                	je     80105a37 <popcli+0x72>
    sti();
80105a32:	e8 a9 fd ff ff       	call   801057e0 <sti>
}
80105a37:	90                   	nop
80105a38:	c9                   	leave  
80105a39:	c3                   	ret    

80105a3a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105a3a:	55                   	push   %ebp
80105a3b:	89 e5                	mov    %esp,%ebp
80105a3d:	57                   	push   %edi
80105a3e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105a3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105a42:	8b 55 10             	mov    0x10(%ebp),%edx
80105a45:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a48:	89 cb                	mov    %ecx,%ebx
80105a4a:	89 df                	mov    %ebx,%edi
80105a4c:	89 d1                	mov    %edx,%ecx
80105a4e:	fc                   	cld    
80105a4f:	f3 aa                	rep stos %al,%es:(%edi)
80105a51:	89 ca                	mov    %ecx,%edx
80105a53:	89 fb                	mov    %edi,%ebx
80105a55:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105a58:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105a5b:	90                   	nop
80105a5c:	5b                   	pop    %ebx
80105a5d:	5f                   	pop    %edi
80105a5e:	5d                   	pop    %ebp
80105a5f:	c3                   	ret    

80105a60 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	57                   	push   %edi
80105a64:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105a65:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105a68:	8b 55 10             	mov    0x10(%ebp),%edx
80105a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a6e:	89 cb                	mov    %ecx,%ebx
80105a70:	89 df                	mov    %ebx,%edi
80105a72:	89 d1                	mov    %edx,%ecx
80105a74:	fc                   	cld    
80105a75:	f3 ab                	rep stos %eax,%es:(%edi)
80105a77:	89 ca                	mov    %ecx,%edx
80105a79:	89 fb                	mov    %edi,%ebx
80105a7b:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105a7e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105a81:	90                   	nop
80105a82:	5b                   	pop    %ebx
80105a83:	5f                   	pop    %edi
80105a84:	5d                   	pop    %ebp
80105a85:	c3                   	ret    

80105a86 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105a86:	55                   	push   %ebp
80105a87:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105a89:	8b 45 08             	mov    0x8(%ebp),%eax
80105a8c:	83 e0 03             	and    $0x3,%eax
80105a8f:	85 c0                	test   %eax,%eax
80105a91:	75 43                	jne    80105ad6 <memset+0x50>
80105a93:	8b 45 10             	mov    0x10(%ebp),%eax
80105a96:	83 e0 03             	and    $0x3,%eax
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	75 39                	jne    80105ad6 <memset+0x50>
    c &= 0xFF;
80105a9d:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105aa4:	8b 45 10             	mov    0x10(%ebp),%eax
80105aa7:	c1 e8 02             	shr    $0x2,%eax
80105aaa:	89 c1                	mov    %eax,%ecx
80105aac:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aaf:	c1 e0 18             	shl    $0x18,%eax
80105ab2:	89 c2                	mov    %eax,%edx
80105ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ab7:	c1 e0 10             	shl    $0x10,%eax
80105aba:	09 c2                	or     %eax,%edx
80105abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105abf:	c1 e0 08             	shl    $0x8,%eax
80105ac2:	09 d0                	or     %edx,%eax
80105ac4:	0b 45 0c             	or     0xc(%ebp),%eax
80105ac7:	51                   	push   %ecx
80105ac8:	50                   	push   %eax
80105ac9:	ff 75 08             	pushl  0x8(%ebp)
80105acc:	e8 8f ff ff ff       	call   80105a60 <stosl>
80105ad1:	83 c4 0c             	add    $0xc,%esp
80105ad4:	eb 12                	jmp    80105ae8 <memset+0x62>
  } else
    stosb(dst, c, n);
80105ad6:	8b 45 10             	mov    0x10(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	ff 75 0c             	pushl  0xc(%ebp)
80105add:	ff 75 08             	pushl  0x8(%ebp)
80105ae0:	e8 55 ff ff ff       	call   80105a3a <stosb>
80105ae5:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105ae8:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105aeb:	c9                   	leave  
80105aec:	c3                   	ret    

80105aed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105aed:	55                   	push   %ebp
80105aee:	89 e5                	mov    %esp,%ebp
80105af0:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105af3:	8b 45 08             	mov    0x8(%ebp),%eax
80105af6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105af9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105afc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105aff:	eb 30                	jmp    80105b31 <memcmp+0x44>
    if(*s1 != *s2)
80105b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b04:	0f b6 10             	movzbl (%eax),%edx
80105b07:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105b0a:	0f b6 00             	movzbl (%eax),%eax
80105b0d:	38 c2                	cmp    %al,%dl
80105b0f:	74 18                	je     80105b29 <memcmp+0x3c>
      return *s1 - *s2;
80105b11:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b14:	0f b6 00             	movzbl (%eax),%eax
80105b17:	0f b6 d0             	movzbl %al,%edx
80105b1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105b1d:	0f b6 00             	movzbl (%eax),%eax
80105b20:	0f b6 c0             	movzbl %al,%eax
80105b23:	29 c2                	sub    %eax,%edx
80105b25:	89 d0                	mov    %edx,%eax
80105b27:	eb 1a                	jmp    80105b43 <memcmp+0x56>
    s1++, s2++;
80105b29:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b2d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105b31:	8b 45 10             	mov    0x10(%ebp),%eax
80105b34:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b37:	89 55 10             	mov    %edx,0x10(%ebp)
80105b3a:	85 c0                	test   %eax,%eax
80105b3c:	75 c3                	jne    80105b01 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105b3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b43:	c9                   	leave  
80105b44:	c3                   	ret    

80105b45 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105b45:	55                   	push   %ebp
80105b46:	89 e5                	mov    %esp,%ebp
80105b48:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105b51:	8b 45 08             	mov    0x8(%ebp),%eax
80105b54:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105b5d:	73 54                	jae    80105bb3 <memmove+0x6e>
80105b5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b62:	8b 45 10             	mov    0x10(%ebp),%eax
80105b65:	01 d0                	add    %edx,%eax
80105b67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105b6a:	76 47                	jbe    80105bb3 <memmove+0x6e>
    s += n;
80105b6c:	8b 45 10             	mov    0x10(%ebp),%eax
80105b6f:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105b72:	8b 45 10             	mov    0x10(%ebp),%eax
80105b75:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105b78:	eb 13                	jmp    80105b8d <memmove+0x48>
      *--d = *--s;
80105b7a:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105b7e:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b85:	0f b6 10             	movzbl (%eax),%edx
80105b88:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105b8b:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105b8d:	8b 45 10             	mov    0x10(%ebp),%eax
80105b90:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b93:	89 55 10             	mov    %edx,0x10(%ebp)
80105b96:	85 c0                	test   %eax,%eax
80105b98:	75 e0                	jne    80105b7a <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105b9a:	eb 24                	jmp    80105bc0 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105b9f:	8d 50 01             	lea    0x1(%eax),%edx
80105ba2:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105ba5:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ba8:	8d 4a 01             	lea    0x1(%edx),%ecx
80105bab:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105bae:	0f b6 12             	movzbl (%edx),%edx
80105bb1:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105bb3:	8b 45 10             	mov    0x10(%ebp),%eax
80105bb6:	8d 50 ff             	lea    -0x1(%eax),%edx
80105bb9:	89 55 10             	mov    %edx,0x10(%ebp)
80105bbc:	85 c0                	test   %eax,%eax
80105bbe:	75 dc                	jne    80105b9c <memmove+0x57>
      *d++ = *s++;

  return dst;
80105bc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105bc3:	c9                   	leave  
80105bc4:	c3                   	ret    

80105bc5 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105bc5:	55                   	push   %ebp
80105bc6:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105bc8:	ff 75 10             	pushl  0x10(%ebp)
80105bcb:	ff 75 0c             	pushl  0xc(%ebp)
80105bce:	ff 75 08             	pushl  0x8(%ebp)
80105bd1:	e8 6f ff ff ff       	call   80105b45 <memmove>
80105bd6:	83 c4 0c             	add    $0xc,%esp
}
80105bd9:	c9                   	leave  
80105bda:	c3                   	ret    

80105bdb <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105bdb:	55                   	push   %ebp
80105bdc:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105bde:	eb 0c                	jmp    80105bec <strncmp+0x11>
    n--, p++, q++;
80105be0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105be4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105be8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105bec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105bf0:	74 1a                	je     80105c0c <strncmp+0x31>
80105bf2:	8b 45 08             	mov    0x8(%ebp),%eax
80105bf5:	0f b6 00             	movzbl (%eax),%eax
80105bf8:	84 c0                	test   %al,%al
80105bfa:	74 10                	je     80105c0c <strncmp+0x31>
80105bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80105bff:	0f b6 10             	movzbl (%eax),%edx
80105c02:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c05:	0f b6 00             	movzbl (%eax),%eax
80105c08:	38 c2                	cmp    %al,%dl
80105c0a:	74 d4                	je     80105be0 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105c0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c10:	75 07                	jne    80105c19 <strncmp+0x3e>
    return 0;
80105c12:	b8 00 00 00 00       	mov    $0x0,%eax
80105c17:	eb 16                	jmp    80105c2f <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105c19:	8b 45 08             	mov    0x8(%ebp),%eax
80105c1c:	0f b6 00             	movzbl (%eax),%eax
80105c1f:	0f b6 d0             	movzbl %al,%edx
80105c22:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c25:	0f b6 00             	movzbl (%eax),%eax
80105c28:	0f b6 c0             	movzbl %al,%eax
80105c2b:	29 c2                	sub    %eax,%edx
80105c2d:	89 d0                	mov    %edx,%eax
}
80105c2f:	5d                   	pop    %ebp
80105c30:	c3                   	ret    

80105c31 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105c31:	55                   	push   %ebp
80105c32:	89 e5                	mov    %esp,%ebp
80105c34:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105c37:	8b 45 08             	mov    0x8(%ebp),%eax
80105c3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105c3d:	90                   	nop
80105c3e:	8b 45 10             	mov    0x10(%ebp),%eax
80105c41:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c44:	89 55 10             	mov    %edx,0x10(%ebp)
80105c47:	85 c0                	test   %eax,%eax
80105c49:	7e 2c                	jle    80105c77 <strncpy+0x46>
80105c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80105c4e:	8d 50 01             	lea    0x1(%eax),%edx
80105c51:	89 55 08             	mov    %edx,0x8(%ebp)
80105c54:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c57:	8d 4a 01             	lea    0x1(%edx),%ecx
80105c5a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105c5d:	0f b6 12             	movzbl (%edx),%edx
80105c60:	88 10                	mov    %dl,(%eax)
80105c62:	0f b6 00             	movzbl (%eax),%eax
80105c65:	84 c0                	test   %al,%al
80105c67:	75 d5                	jne    80105c3e <strncpy+0xd>
    ;
  while(n-- > 0)
80105c69:	eb 0c                	jmp    80105c77 <strncpy+0x46>
    *s++ = 0;
80105c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80105c6e:	8d 50 01             	lea    0x1(%eax),%edx
80105c71:	89 55 08             	mov    %edx,0x8(%ebp)
80105c74:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105c77:	8b 45 10             	mov    0x10(%ebp),%eax
80105c7a:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c7d:	89 55 10             	mov    %edx,0x10(%ebp)
80105c80:	85 c0                	test   %eax,%eax
80105c82:	7f e7                	jg     80105c6b <strncpy+0x3a>
    *s++ = 0;
  return os;
80105c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105c87:	c9                   	leave  
80105c88:	c3                   	ret    

80105c89 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105c89:	55                   	push   %ebp
80105c8a:	89 e5                	mov    %esp,%ebp
80105c8c:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105c8f:	8b 45 08             	mov    0x8(%ebp),%eax
80105c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105c95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c99:	7f 05                	jg     80105ca0 <safestrcpy+0x17>
    return os;
80105c9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c9e:	eb 31                	jmp    80105cd1 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105ca0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105ca4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105ca8:	7e 1e                	jle    80105cc8 <safestrcpy+0x3f>
80105caa:	8b 45 08             	mov    0x8(%ebp),%eax
80105cad:	8d 50 01             	lea    0x1(%eax),%edx
80105cb0:	89 55 08             	mov    %edx,0x8(%ebp)
80105cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80105cb6:	8d 4a 01             	lea    0x1(%edx),%ecx
80105cb9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105cbc:	0f b6 12             	movzbl (%edx),%edx
80105cbf:	88 10                	mov    %dl,(%eax)
80105cc1:	0f b6 00             	movzbl (%eax),%eax
80105cc4:	84 c0                	test   %al,%al
80105cc6:	75 d8                	jne    80105ca0 <safestrcpy+0x17>
    ;
  *s = 0;
80105cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80105ccb:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105cd1:	c9                   	leave  
80105cd2:	c3                   	ret    

80105cd3 <strlen>:

int
strlen(const char *s)
{
80105cd3:	55                   	push   %ebp
80105cd4:	89 e5                	mov    %esp,%ebp
80105cd6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105ce0:	eb 04                	jmp    80105ce6 <strlen+0x13>
80105ce2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105ce6:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80105cec:	01 d0                	add    %edx,%eax
80105cee:	0f b6 00             	movzbl (%eax),%eax
80105cf1:	84 c0                	test   %al,%al
80105cf3:	75 ed                	jne    80105ce2 <strlen+0xf>
    ;
  return n;
80105cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105cf8:	c9                   	leave  
80105cf9:	c3                   	ret    

80105cfa <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105cfa:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105cfe:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105d02:	55                   	push   %ebp
  pushl %ebx
80105d03:	53                   	push   %ebx
  pushl %esi
80105d04:	56                   	push   %esi
  pushl %edi
80105d05:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105d06:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105d08:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105d0a:	5f                   	pop    %edi
  popl %esi
80105d0b:	5e                   	pop    %esi
  popl %ebx
80105d0c:	5b                   	pop    %ebx
  popl %ebp
80105d0d:	5d                   	pop    %ebp
  ret
80105d0e:	c3                   	ret    

80105d0f <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105d0f:	55                   	push   %ebp
80105d10:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105d12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d18:	8b 00                	mov    (%eax),%eax
80105d1a:	3b 45 08             	cmp    0x8(%ebp),%eax
80105d1d:	76 12                	jbe    80105d31 <fetchint+0x22>
80105d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80105d22:	8d 50 04             	lea    0x4(%eax),%edx
80105d25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d2b:	8b 00                	mov    (%eax),%eax
80105d2d:	39 c2                	cmp    %eax,%edx
80105d2f:	76 07                	jbe    80105d38 <fetchint+0x29>
    return -1;
80105d31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d36:	eb 0f                	jmp    80105d47 <fetchint+0x38>
  *ip = *(int*)(addr);
80105d38:	8b 45 08             	mov    0x8(%ebp),%eax
80105d3b:	8b 10                	mov    (%eax),%edx
80105d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d40:	89 10                	mov    %edx,(%eax)
  return 0;
80105d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d47:	5d                   	pop    %ebp
80105d48:	c3                   	ret    

80105d49 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105d49:	55                   	push   %ebp
80105d4a:	89 e5                	mov    %esp,%ebp
80105d4c:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105d4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d55:	8b 00                	mov    (%eax),%eax
80105d57:	3b 45 08             	cmp    0x8(%ebp),%eax
80105d5a:	77 07                	ja     80105d63 <fetchstr+0x1a>
    return -1;
80105d5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d61:	eb 46                	jmp    80105da9 <fetchstr+0x60>
  *pp = (char*)addr;
80105d63:	8b 55 08             	mov    0x8(%ebp),%edx
80105d66:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d69:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105d6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d71:	8b 00                	mov    (%eax),%eax
80105d73:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105d76:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d79:	8b 00                	mov    (%eax),%eax
80105d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105d7e:	eb 1c                	jmp    80105d9c <fetchstr+0x53>
    if(*s == 0)
80105d80:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d83:	0f b6 00             	movzbl (%eax),%eax
80105d86:	84 c0                	test   %al,%al
80105d88:	75 0e                	jne    80105d98 <fetchstr+0x4f>
      return s - *pp;
80105d8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d90:	8b 00                	mov    (%eax),%eax
80105d92:	29 c2                	sub    %eax,%edx
80105d94:	89 d0                	mov    %edx,%eax
80105d96:	eb 11                	jmp    80105da9 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105d98:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105d9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d9f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105da2:	72 dc                	jb     80105d80 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105da4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105da9:	c9                   	leave  
80105daa:	c3                   	ret    

80105dab <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105dab:	55                   	push   %ebp
80105dac:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105dae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105db4:	8b 40 18             	mov    0x18(%eax),%eax
80105db7:	8b 40 44             	mov    0x44(%eax),%eax
80105dba:	8b 55 08             	mov    0x8(%ebp),%edx
80105dbd:	c1 e2 02             	shl    $0x2,%edx
80105dc0:	01 d0                	add    %edx,%eax
80105dc2:	83 c0 04             	add    $0x4,%eax
80105dc5:	ff 75 0c             	pushl  0xc(%ebp)
80105dc8:	50                   	push   %eax
80105dc9:	e8 41 ff ff ff       	call   80105d0f <fetchint>
80105dce:	83 c4 08             	add    $0x8,%esp
}
80105dd1:	c9                   	leave  
80105dd2:	c3                   	ret    

80105dd3 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105dd3:	55                   	push   %ebp
80105dd4:	89 e5                	mov    %esp,%ebp
80105dd6:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105dd9:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105ddc:	50                   	push   %eax
80105ddd:	ff 75 08             	pushl  0x8(%ebp)
80105de0:	e8 c6 ff ff ff       	call   80105dab <argint>
80105de5:	83 c4 08             	add    $0x8,%esp
80105de8:	85 c0                	test   %eax,%eax
80105dea:	79 07                	jns    80105df3 <argptr+0x20>
    return -1;
80105dec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df1:	eb 3b                	jmp    80105e2e <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105df3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105df9:	8b 00                	mov    (%eax),%eax
80105dfb:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105dfe:	39 d0                	cmp    %edx,%eax
80105e00:	76 16                	jbe    80105e18 <argptr+0x45>
80105e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e05:	89 c2                	mov    %eax,%edx
80105e07:	8b 45 10             	mov    0x10(%ebp),%eax
80105e0a:	01 c2                	add    %eax,%edx
80105e0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e12:	8b 00                	mov    (%eax),%eax
80105e14:	39 c2                	cmp    %eax,%edx
80105e16:	76 07                	jbe    80105e1f <argptr+0x4c>
    return -1;
80105e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e1d:	eb 0f                	jmp    80105e2e <argptr+0x5b>
  *pp = (char*)i;
80105e1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e22:	89 c2                	mov    %eax,%edx
80105e24:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e27:	89 10                	mov    %edx,(%eax)
  return 0;
80105e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e2e:	c9                   	leave  
80105e2f:	c3                   	ret    

80105e30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105e36:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105e39:	50                   	push   %eax
80105e3a:	ff 75 08             	pushl  0x8(%ebp)
80105e3d:	e8 69 ff ff ff       	call   80105dab <argint>
80105e42:	83 c4 08             	add    $0x8,%esp
80105e45:	85 c0                	test   %eax,%eax
80105e47:	79 07                	jns    80105e50 <argstr+0x20>
    return -1;
80105e49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4e:	eb 0f                	jmp    80105e5f <argstr+0x2f>
  return fetchstr(addr, pp);
80105e50:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e53:	ff 75 0c             	pushl  0xc(%ebp)
80105e56:	50                   	push   %eax
80105e57:	e8 ed fe ff ff       	call   80105d49 <fetchstr>
80105e5c:	83 c4 08             	add    $0x8,%esp
}
80105e5f:	c9                   	leave  
80105e60:	c3                   	ret    

80105e61 <syscall>:
};
#endif 

void
syscall(void)
{
80105e61:	55                   	push   %ebp
80105e62:	89 e5                	mov    %esp,%ebp
80105e64:	53                   	push   %ebx
80105e65:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105e68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e6e:	8b 40 18             	mov    0x18(%eax),%eax
80105e71:	8b 40 1c             	mov    0x1c(%eax),%eax
80105e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105e77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e7b:	7e 30                	jle    80105ead <syscall+0x4c>
80105e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e80:	83 f8 1d             	cmp    $0x1d,%eax
80105e83:	77 28                	ja     80105ead <syscall+0x4c>
80105e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e88:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105e8f:	85 c0                	test   %eax,%eax
80105e91:	74 1a                	je     80105ead <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105e93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e99:	8b 58 18             	mov    0x18(%eax),%ebx
80105e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e9f:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105ea6:	ff d0                	call   *%eax
80105ea8:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105eab:	eb 34                	jmp    80105ee1 <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105eb3:	8d 50 6c             	lea    0x6c(%eax),%edx
80105eb6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105ebc:	8b 40 10             	mov    0x10(%eax),%eax
80105ebf:	ff 75 f4             	pushl  -0xc(%ebp)
80105ec2:	52                   	push   %edx
80105ec3:	50                   	push   %eax
80105ec4:	68 aa 93 10 80       	push   $0x801093aa
80105ec9:	e8 f8 a4 ff ff       	call   801003c6 <cprintf>
80105ece:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105ed1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ed7:	8b 40 18             	mov    0x18(%eax),%eax
80105eda:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105ee1:	90                   	nop
80105ee2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ee5:	c9                   	leave  
80105ee6:	c3                   	ret    

80105ee7 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105ee7:	55                   	push   %ebp
80105ee8:	89 e5                	mov    %esp,%ebp
80105eea:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105eed:	83 ec 08             	sub    $0x8,%esp
80105ef0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ef3:	50                   	push   %eax
80105ef4:	ff 75 08             	pushl  0x8(%ebp)
80105ef7:	e8 af fe ff ff       	call   80105dab <argint>
80105efc:	83 c4 10             	add    $0x10,%esp
80105eff:	85 c0                	test   %eax,%eax
80105f01:	79 07                	jns    80105f0a <argfd+0x23>
    return -1;
80105f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f08:	eb 50                	jmp    80105f5a <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0d:	85 c0                	test   %eax,%eax
80105f0f:	78 21                	js     80105f32 <argfd+0x4b>
80105f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f14:	83 f8 0f             	cmp    $0xf,%eax
80105f17:	7f 19                	jg     80105f32 <argfd+0x4b>
80105f19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f22:	83 c2 08             	add    $0x8,%edx
80105f25:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f30:	75 07                	jne    80105f39 <argfd+0x52>
    return -1;
80105f32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f37:	eb 21                	jmp    80105f5a <argfd+0x73>
  if(pfd)
80105f39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105f3d:	74 08                	je     80105f47 <argfd+0x60>
    *pfd = fd;
80105f3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f42:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f45:	89 10                	mov    %edx,(%eax)
  if(pf)
80105f47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105f4b:	74 08                	je     80105f55 <argfd+0x6e>
    *pf = f;
80105f4d:	8b 45 10             	mov    0x10(%ebp),%eax
80105f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f53:	89 10                	mov    %edx,(%eax)
  return 0;
80105f55:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f5a:	c9                   	leave  
80105f5b:	c3                   	ret    

80105f5c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105f5c:	55                   	push   %ebp
80105f5d:	89 e5                	mov    %esp,%ebp
80105f5f:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105f62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105f69:	eb 30                	jmp    80105f9b <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105f6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f71:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105f74:	83 c2 08             	add    $0x8,%edx
80105f77:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105f7b:	85 c0                	test   %eax,%eax
80105f7d:	75 18                	jne    80105f97 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105f7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f85:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105f88:	8d 4a 08             	lea    0x8(%edx),%ecx
80105f8b:	8b 55 08             	mov    0x8(%ebp),%edx
80105f8e:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f95:	eb 0f                	jmp    80105fa6 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105f97:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105f9b:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105f9f:	7e ca                	jle    80105f6b <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105fa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fa6:	c9                   	leave  
80105fa7:	c3                   	ret    

80105fa8 <sys_dup>:

int
sys_dup(void)
{
80105fa8:	55                   	push   %ebp
80105fa9:	89 e5                	mov    %esp,%ebp
80105fab:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105fae:	83 ec 04             	sub    $0x4,%esp
80105fb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fb4:	50                   	push   %eax
80105fb5:	6a 00                	push   $0x0
80105fb7:	6a 00                	push   $0x0
80105fb9:	e8 29 ff ff ff       	call   80105ee7 <argfd>
80105fbe:	83 c4 10             	add    $0x10,%esp
80105fc1:	85 c0                	test   %eax,%eax
80105fc3:	79 07                	jns    80105fcc <sys_dup+0x24>
    return -1;
80105fc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fca:	eb 31                	jmp    80105ffd <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fcf:	83 ec 0c             	sub    $0xc,%esp
80105fd2:	50                   	push   %eax
80105fd3:	e8 84 ff ff ff       	call   80105f5c <fdalloc>
80105fd8:	83 c4 10             	add    $0x10,%esp
80105fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fe2:	79 07                	jns    80105feb <sys_dup+0x43>
    return -1;
80105fe4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe9:	eb 12                	jmp    80105ffd <sys_dup+0x55>
  filedup(f);
80105feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fee:	83 ec 0c             	sub    $0xc,%esp
80105ff1:	50                   	push   %eax
80105ff2:	e8 57 b0 ff ff       	call   8010104e <filedup>
80105ff7:	83 c4 10             	add    $0x10,%esp
  return fd;
80105ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105ffd:	c9                   	leave  
80105ffe:	c3                   	ret    

80105fff <sys_read>:

int
sys_read(void)
{
80105fff:	55                   	push   %ebp
80106000:	89 e5                	mov    %esp,%ebp
80106002:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106005:	83 ec 04             	sub    $0x4,%esp
80106008:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010600b:	50                   	push   %eax
8010600c:	6a 00                	push   $0x0
8010600e:	6a 00                	push   $0x0
80106010:	e8 d2 fe ff ff       	call   80105ee7 <argfd>
80106015:	83 c4 10             	add    $0x10,%esp
80106018:	85 c0                	test   %eax,%eax
8010601a:	78 2e                	js     8010604a <sys_read+0x4b>
8010601c:	83 ec 08             	sub    $0x8,%esp
8010601f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106022:	50                   	push   %eax
80106023:	6a 02                	push   $0x2
80106025:	e8 81 fd ff ff       	call   80105dab <argint>
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	85 c0                	test   %eax,%eax
8010602f:	78 19                	js     8010604a <sys_read+0x4b>
80106031:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106034:	83 ec 04             	sub    $0x4,%esp
80106037:	50                   	push   %eax
80106038:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010603b:	50                   	push   %eax
8010603c:	6a 01                	push   $0x1
8010603e:	e8 90 fd ff ff       	call   80105dd3 <argptr>
80106043:	83 c4 10             	add    $0x10,%esp
80106046:	85 c0                	test   %eax,%eax
80106048:	79 07                	jns    80106051 <sys_read+0x52>
    return -1;
8010604a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604f:	eb 17                	jmp    80106068 <sys_read+0x69>
  return fileread(f, p, n);
80106051:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106054:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010605a:	83 ec 04             	sub    $0x4,%esp
8010605d:	51                   	push   %ecx
8010605e:	52                   	push   %edx
8010605f:	50                   	push   %eax
80106060:	e8 79 b1 ff ff       	call   801011de <fileread>
80106065:	83 c4 10             	add    $0x10,%esp
}
80106068:	c9                   	leave  
80106069:	c3                   	ret    

8010606a <sys_write>:

int
sys_write(void)
{
8010606a:	55                   	push   %ebp
8010606b:	89 e5                	mov    %esp,%ebp
8010606d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106070:	83 ec 04             	sub    $0x4,%esp
80106073:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106076:	50                   	push   %eax
80106077:	6a 00                	push   $0x0
80106079:	6a 00                	push   $0x0
8010607b:	e8 67 fe ff ff       	call   80105ee7 <argfd>
80106080:	83 c4 10             	add    $0x10,%esp
80106083:	85 c0                	test   %eax,%eax
80106085:	78 2e                	js     801060b5 <sys_write+0x4b>
80106087:	83 ec 08             	sub    $0x8,%esp
8010608a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010608d:	50                   	push   %eax
8010608e:	6a 02                	push   $0x2
80106090:	e8 16 fd ff ff       	call   80105dab <argint>
80106095:	83 c4 10             	add    $0x10,%esp
80106098:	85 c0                	test   %eax,%eax
8010609a:	78 19                	js     801060b5 <sys_write+0x4b>
8010609c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010609f:	83 ec 04             	sub    $0x4,%esp
801060a2:	50                   	push   %eax
801060a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060a6:	50                   	push   %eax
801060a7:	6a 01                	push   $0x1
801060a9:	e8 25 fd ff ff       	call   80105dd3 <argptr>
801060ae:	83 c4 10             	add    $0x10,%esp
801060b1:	85 c0                	test   %eax,%eax
801060b3:	79 07                	jns    801060bc <sys_write+0x52>
    return -1;
801060b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ba:	eb 17                	jmp    801060d3 <sys_write+0x69>
  return filewrite(f, p, n);
801060bc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801060bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
801060c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c5:	83 ec 04             	sub    $0x4,%esp
801060c8:	51                   	push   %ecx
801060c9:	52                   	push   %edx
801060ca:	50                   	push   %eax
801060cb:	e8 c6 b1 ff ff       	call   80101296 <filewrite>
801060d0:	83 c4 10             	add    $0x10,%esp
}
801060d3:	c9                   	leave  
801060d4:	c3                   	ret    

801060d5 <sys_close>:

int
sys_close(void)
{
801060d5:	55                   	push   %ebp
801060d6:	89 e5                	mov    %esp,%ebp
801060d8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801060db:	83 ec 04             	sub    $0x4,%esp
801060de:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060e1:	50                   	push   %eax
801060e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060e5:	50                   	push   %eax
801060e6:	6a 00                	push   $0x0
801060e8:	e8 fa fd ff ff       	call   80105ee7 <argfd>
801060ed:	83 c4 10             	add    $0x10,%esp
801060f0:	85 c0                	test   %eax,%eax
801060f2:	79 07                	jns    801060fb <sys_close+0x26>
    return -1;
801060f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f9:	eb 28                	jmp    80106123 <sys_close+0x4e>
  proc->ofile[fd] = 0;
801060fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106101:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106104:	83 c2 08             	add    $0x8,%edx
80106107:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010610e:	00 
  fileclose(f);
8010610f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106112:	83 ec 0c             	sub    $0xc,%esp
80106115:	50                   	push   %eax
80106116:	e8 84 af ff ff       	call   8010109f <fileclose>
8010611b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010611e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106123:	c9                   	leave  
80106124:	c3                   	ret    

80106125 <sys_fstat>:

int
sys_fstat(void)
{
80106125:	55                   	push   %ebp
80106126:	89 e5                	mov    %esp,%ebp
80106128:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010612b:	83 ec 04             	sub    $0x4,%esp
8010612e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106131:	50                   	push   %eax
80106132:	6a 00                	push   $0x0
80106134:	6a 00                	push   $0x0
80106136:	e8 ac fd ff ff       	call   80105ee7 <argfd>
8010613b:	83 c4 10             	add    $0x10,%esp
8010613e:	85 c0                	test   %eax,%eax
80106140:	78 17                	js     80106159 <sys_fstat+0x34>
80106142:	83 ec 04             	sub    $0x4,%esp
80106145:	6a 14                	push   $0x14
80106147:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010614a:	50                   	push   %eax
8010614b:	6a 01                	push   $0x1
8010614d:	e8 81 fc ff ff       	call   80105dd3 <argptr>
80106152:	83 c4 10             	add    $0x10,%esp
80106155:	85 c0                	test   %eax,%eax
80106157:	79 07                	jns    80106160 <sys_fstat+0x3b>
    return -1;
80106159:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010615e:	eb 13                	jmp    80106173 <sys_fstat+0x4e>
  return filestat(f, st);
80106160:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106166:	83 ec 08             	sub    $0x8,%esp
80106169:	52                   	push   %edx
8010616a:	50                   	push   %eax
8010616b:	e8 17 b0 ff ff       	call   80101187 <filestat>
80106170:	83 c4 10             	add    $0x10,%esp
}
80106173:	c9                   	leave  
80106174:	c3                   	ret    

80106175 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106175:	55                   	push   %ebp
80106176:	89 e5                	mov    %esp,%ebp
80106178:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010617b:	83 ec 08             	sub    $0x8,%esp
8010617e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106181:	50                   	push   %eax
80106182:	6a 00                	push   $0x0
80106184:	e8 a7 fc ff ff       	call   80105e30 <argstr>
80106189:	83 c4 10             	add    $0x10,%esp
8010618c:	85 c0                	test   %eax,%eax
8010618e:	78 15                	js     801061a5 <sys_link+0x30>
80106190:	83 ec 08             	sub    $0x8,%esp
80106193:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106196:	50                   	push   %eax
80106197:	6a 01                	push   $0x1
80106199:	e8 92 fc ff ff       	call   80105e30 <argstr>
8010619e:	83 c4 10             	add    $0x10,%esp
801061a1:	85 c0                	test   %eax,%eax
801061a3:	79 0a                	jns    801061af <sys_link+0x3a>
    return -1;
801061a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061aa:	e9 68 01 00 00       	jmp    80106317 <sys_link+0x1a2>

  begin_op();
801061af:	e8 e7 d3 ff ff       	call   8010359b <begin_op>
  if((ip = namei(old)) == 0){
801061b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801061b7:	83 ec 0c             	sub    $0xc,%esp
801061ba:	50                   	push   %eax
801061bb:	e8 b6 c3 ff ff       	call   80102576 <namei>
801061c0:	83 c4 10             	add    $0x10,%esp
801061c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061ca:	75 0f                	jne    801061db <sys_link+0x66>
    end_op();
801061cc:	e8 56 d4 ff ff       	call   80103627 <end_op>
    return -1;
801061d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061d6:	e9 3c 01 00 00       	jmp    80106317 <sys_link+0x1a2>
  }

  ilock(ip);
801061db:	83 ec 0c             	sub    $0xc,%esp
801061de:	ff 75 f4             	pushl  -0xc(%ebp)
801061e1:	e8 d2 b7 ff ff       	call   801019b8 <ilock>
801061e6:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801061e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ec:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061f0:	66 83 f8 01          	cmp    $0x1,%ax
801061f4:	75 1d                	jne    80106213 <sys_link+0x9e>
    iunlockput(ip);
801061f6:	83 ec 0c             	sub    $0xc,%esp
801061f9:	ff 75 f4             	pushl  -0xc(%ebp)
801061fc:	e8 77 ba ff ff       	call   80101c78 <iunlockput>
80106201:	83 c4 10             	add    $0x10,%esp
    end_op();
80106204:	e8 1e d4 ff ff       	call   80103627 <end_op>
    return -1;
80106209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010620e:	e9 04 01 00 00       	jmp    80106317 <sys_link+0x1a2>
  }

  ip->nlink++;
80106213:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106216:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010621a:	83 c0 01             	add    $0x1,%eax
8010621d:	89 c2                	mov    %eax,%edx
8010621f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106222:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106226:	83 ec 0c             	sub    $0xc,%esp
80106229:	ff 75 f4             	pushl  -0xc(%ebp)
8010622c:	e8 ad b5 ff ff       	call   801017de <iupdate>
80106231:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106234:	83 ec 0c             	sub    $0xc,%esp
80106237:	ff 75 f4             	pushl  -0xc(%ebp)
8010623a:	e8 d7 b8 ff ff       	call   80101b16 <iunlock>
8010623f:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106242:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106245:	83 ec 08             	sub    $0x8,%esp
80106248:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010624b:	52                   	push   %edx
8010624c:	50                   	push   %eax
8010624d:	e8 40 c3 ff ff       	call   80102592 <nameiparent>
80106252:	83 c4 10             	add    $0x10,%esp
80106255:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106258:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010625c:	74 71                	je     801062cf <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010625e:	83 ec 0c             	sub    $0xc,%esp
80106261:	ff 75 f0             	pushl  -0x10(%ebp)
80106264:	e8 4f b7 ff ff       	call   801019b8 <ilock>
80106269:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010626c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010626f:	8b 10                	mov    (%eax),%edx
80106271:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106274:	8b 00                	mov    (%eax),%eax
80106276:	39 c2                	cmp    %eax,%edx
80106278:	75 1d                	jne    80106297 <sys_link+0x122>
8010627a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627d:	8b 40 04             	mov    0x4(%eax),%eax
80106280:	83 ec 04             	sub    $0x4,%esp
80106283:	50                   	push   %eax
80106284:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106287:	50                   	push   %eax
80106288:	ff 75 f0             	pushl  -0x10(%ebp)
8010628b:	e8 4a c0 ff ff       	call   801022da <dirlink>
80106290:	83 c4 10             	add    $0x10,%esp
80106293:	85 c0                	test   %eax,%eax
80106295:	79 10                	jns    801062a7 <sys_link+0x132>
    iunlockput(dp);
80106297:	83 ec 0c             	sub    $0xc,%esp
8010629a:	ff 75 f0             	pushl  -0x10(%ebp)
8010629d:	e8 d6 b9 ff ff       	call   80101c78 <iunlockput>
801062a2:	83 c4 10             	add    $0x10,%esp
    goto bad;
801062a5:	eb 29                	jmp    801062d0 <sys_link+0x15b>
  }
  iunlockput(dp);
801062a7:	83 ec 0c             	sub    $0xc,%esp
801062aa:	ff 75 f0             	pushl  -0x10(%ebp)
801062ad:	e8 c6 b9 ff ff       	call   80101c78 <iunlockput>
801062b2:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801062b5:	83 ec 0c             	sub    $0xc,%esp
801062b8:	ff 75 f4             	pushl  -0xc(%ebp)
801062bb:	e8 c8 b8 ff ff       	call   80101b88 <iput>
801062c0:	83 c4 10             	add    $0x10,%esp

  end_op();
801062c3:	e8 5f d3 ff ff       	call   80103627 <end_op>

  return 0;
801062c8:	b8 00 00 00 00       	mov    $0x0,%eax
801062cd:	eb 48                	jmp    80106317 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801062cf:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	ff 75 f4             	pushl  -0xc(%ebp)
801062d6:	e8 dd b6 ff ff       	call   801019b8 <ilock>
801062db:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801062de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801062e5:	83 e8 01             	sub    $0x1,%eax
801062e8:	89 c2                	mov    %eax,%edx
801062ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ed:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801062f1:	83 ec 0c             	sub    $0xc,%esp
801062f4:	ff 75 f4             	pushl  -0xc(%ebp)
801062f7:	e8 e2 b4 ff ff       	call   801017de <iupdate>
801062fc:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801062ff:	83 ec 0c             	sub    $0xc,%esp
80106302:	ff 75 f4             	pushl  -0xc(%ebp)
80106305:	e8 6e b9 ff ff       	call   80101c78 <iunlockput>
8010630a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010630d:	e8 15 d3 ff ff       	call   80103627 <end_op>
  return -1;
80106312:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106317:	c9                   	leave  
80106318:	c3                   	ret    

80106319 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106319:	55                   	push   %ebp
8010631a:	89 e5                	mov    %esp,%ebp
8010631c:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010631f:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106326:	eb 40                	jmp    80106368 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010632b:	6a 10                	push   $0x10
8010632d:	50                   	push   %eax
8010632e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106331:	50                   	push   %eax
80106332:	ff 75 08             	pushl  0x8(%ebp)
80106335:	e8 ec bb ff ff       	call   80101f26 <readi>
8010633a:	83 c4 10             	add    $0x10,%esp
8010633d:	83 f8 10             	cmp    $0x10,%eax
80106340:	74 0d                	je     8010634f <isdirempty+0x36>
      panic("isdirempty: readi");
80106342:	83 ec 0c             	sub    $0xc,%esp
80106345:	68 c6 93 10 80       	push   $0x801093c6
8010634a:	e8 17 a2 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
8010634f:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106353:	66 85 c0             	test   %ax,%ax
80106356:	74 07                	je     8010635f <isdirempty+0x46>
      return 0;
80106358:	b8 00 00 00 00       	mov    $0x0,%eax
8010635d:	eb 1b                	jmp    8010637a <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010635f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106362:	83 c0 10             	add    $0x10,%eax
80106365:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106368:	8b 45 08             	mov    0x8(%ebp),%eax
8010636b:	8b 50 18             	mov    0x18(%eax),%edx
8010636e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106371:	39 c2                	cmp    %eax,%edx
80106373:	77 b3                	ja     80106328 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106375:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010637a:	c9                   	leave  
8010637b:	c3                   	ret    

8010637c <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010637c:	55                   	push   %ebp
8010637d:	89 e5                	mov    %esp,%ebp
8010637f:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106382:	83 ec 08             	sub    $0x8,%esp
80106385:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106388:	50                   	push   %eax
80106389:	6a 00                	push   $0x0
8010638b:	e8 a0 fa ff ff       	call   80105e30 <argstr>
80106390:	83 c4 10             	add    $0x10,%esp
80106393:	85 c0                	test   %eax,%eax
80106395:	79 0a                	jns    801063a1 <sys_unlink+0x25>
    return -1;
80106397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010639c:	e9 bc 01 00 00       	jmp    8010655d <sys_unlink+0x1e1>

  begin_op();
801063a1:	e8 f5 d1 ff ff       	call   8010359b <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801063a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
801063a9:	83 ec 08             	sub    $0x8,%esp
801063ac:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801063af:	52                   	push   %edx
801063b0:	50                   	push   %eax
801063b1:	e8 dc c1 ff ff       	call   80102592 <nameiparent>
801063b6:	83 c4 10             	add    $0x10,%esp
801063b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063c0:	75 0f                	jne    801063d1 <sys_unlink+0x55>
    end_op();
801063c2:	e8 60 d2 ff ff       	call   80103627 <end_op>
    return -1;
801063c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063cc:	e9 8c 01 00 00       	jmp    8010655d <sys_unlink+0x1e1>
  }

  ilock(dp);
801063d1:	83 ec 0c             	sub    $0xc,%esp
801063d4:	ff 75 f4             	pushl  -0xc(%ebp)
801063d7:	e8 dc b5 ff ff       	call   801019b8 <ilock>
801063dc:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801063df:	83 ec 08             	sub    $0x8,%esp
801063e2:	68 d8 93 10 80       	push   $0x801093d8
801063e7:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801063ea:	50                   	push   %eax
801063eb:	e8 15 be ff ff       	call   80102205 <namecmp>
801063f0:	83 c4 10             	add    $0x10,%esp
801063f3:	85 c0                	test   %eax,%eax
801063f5:	0f 84 4a 01 00 00    	je     80106545 <sys_unlink+0x1c9>
801063fb:	83 ec 08             	sub    $0x8,%esp
801063fe:	68 da 93 10 80       	push   $0x801093da
80106403:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106406:	50                   	push   %eax
80106407:	e8 f9 bd ff ff       	call   80102205 <namecmp>
8010640c:	83 c4 10             	add    $0x10,%esp
8010640f:	85 c0                	test   %eax,%eax
80106411:	0f 84 2e 01 00 00    	je     80106545 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106417:	83 ec 04             	sub    $0x4,%esp
8010641a:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010641d:	50                   	push   %eax
8010641e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106421:	50                   	push   %eax
80106422:	ff 75 f4             	pushl  -0xc(%ebp)
80106425:	e8 f6 bd ff ff       	call   80102220 <dirlookup>
8010642a:	83 c4 10             	add    $0x10,%esp
8010642d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106434:	0f 84 0a 01 00 00    	je     80106544 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
8010643a:	83 ec 0c             	sub    $0xc,%esp
8010643d:	ff 75 f0             	pushl  -0x10(%ebp)
80106440:	e8 73 b5 ff ff       	call   801019b8 <ilock>
80106445:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106448:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010644b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010644f:	66 85 c0             	test   %ax,%ax
80106452:	7f 0d                	jg     80106461 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106454:	83 ec 0c             	sub    $0xc,%esp
80106457:	68 dd 93 10 80       	push   $0x801093dd
8010645c:	e8 05 a1 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106461:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106464:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106468:	66 83 f8 01          	cmp    $0x1,%ax
8010646c:	75 25                	jne    80106493 <sys_unlink+0x117>
8010646e:	83 ec 0c             	sub    $0xc,%esp
80106471:	ff 75 f0             	pushl  -0x10(%ebp)
80106474:	e8 a0 fe ff ff       	call   80106319 <isdirempty>
80106479:	83 c4 10             	add    $0x10,%esp
8010647c:	85 c0                	test   %eax,%eax
8010647e:	75 13                	jne    80106493 <sys_unlink+0x117>
    iunlockput(ip);
80106480:	83 ec 0c             	sub    $0xc,%esp
80106483:	ff 75 f0             	pushl  -0x10(%ebp)
80106486:	e8 ed b7 ff ff       	call   80101c78 <iunlockput>
8010648b:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010648e:	e9 b2 00 00 00       	jmp    80106545 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106493:	83 ec 04             	sub    $0x4,%esp
80106496:	6a 10                	push   $0x10
80106498:	6a 00                	push   $0x0
8010649a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010649d:	50                   	push   %eax
8010649e:	e8 e3 f5 ff ff       	call   80105a86 <memset>
801064a3:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801064a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
801064a9:	6a 10                	push   $0x10
801064ab:	50                   	push   %eax
801064ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
801064af:	50                   	push   %eax
801064b0:	ff 75 f4             	pushl  -0xc(%ebp)
801064b3:	e8 c5 bb ff ff       	call   8010207d <writei>
801064b8:	83 c4 10             	add    $0x10,%esp
801064bb:	83 f8 10             	cmp    $0x10,%eax
801064be:	74 0d                	je     801064cd <sys_unlink+0x151>
    panic("unlink: writei");
801064c0:	83 ec 0c             	sub    $0xc,%esp
801064c3:	68 ef 93 10 80       	push   $0x801093ef
801064c8:	e8 99 a0 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801064cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064d0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801064d4:	66 83 f8 01          	cmp    $0x1,%ax
801064d8:	75 21                	jne    801064fb <sys_unlink+0x17f>
    dp->nlink--;
801064da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064dd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801064e1:	83 e8 01             	sub    $0x1,%eax
801064e4:	89 c2                	mov    %eax,%edx
801064e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e9:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801064ed:	83 ec 0c             	sub    $0xc,%esp
801064f0:	ff 75 f4             	pushl  -0xc(%ebp)
801064f3:	e8 e6 b2 ff ff       	call   801017de <iupdate>
801064f8:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801064fb:	83 ec 0c             	sub    $0xc,%esp
801064fe:	ff 75 f4             	pushl  -0xc(%ebp)
80106501:	e8 72 b7 ff ff       	call   80101c78 <iunlockput>
80106506:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106509:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010650c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106510:	83 e8 01             	sub    $0x1,%eax
80106513:	89 c2                	mov    %eax,%edx
80106515:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106518:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010651c:	83 ec 0c             	sub    $0xc,%esp
8010651f:	ff 75 f0             	pushl  -0x10(%ebp)
80106522:	e8 b7 b2 ff ff       	call   801017de <iupdate>
80106527:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010652a:	83 ec 0c             	sub    $0xc,%esp
8010652d:	ff 75 f0             	pushl  -0x10(%ebp)
80106530:	e8 43 b7 ff ff       	call   80101c78 <iunlockput>
80106535:	83 c4 10             	add    $0x10,%esp

  end_op();
80106538:	e8 ea d0 ff ff       	call   80103627 <end_op>

  return 0;
8010653d:	b8 00 00 00 00       	mov    $0x0,%eax
80106542:	eb 19                	jmp    8010655d <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106544:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106545:	83 ec 0c             	sub    $0xc,%esp
80106548:	ff 75 f4             	pushl  -0xc(%ebp)
8010654b:	e8 28 b7 ff ff       	call   80101c78 <iunlockput>
80106550:	83 c4 10             	add    $0x10,%esp
  end_op();
80106553:	e8 cf d0 ff ff       	call   80103627 <end_op>
  return -1;
80106558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010655d:	c9                   	leave  
8010655e:	c3                   	ret    

8010655f <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010655f:	55                   	push   %ebp
80106560:	89 e5                	mov    %esp,%ebp
80106562:	83 ec 38             	sub    $0x38,%esp
80106565:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106568:	8b 55 10             	mov    0x10(%ebp),%edx
8010656b:	8b 45 14             	mov    0x14(%ebp),%eax
8010656e:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106572:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106576:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010657a:	83 ec 08             	sub    $0x8,%esp
8010657d:	8d 45 de             	lea    -0x22(%ebp),%eax
80106580:	50                   	push   %eax
80106581:	ff 75 08             	pushl  0x8(%ebp)
80106584:	e8 09 c0 ff ff       	call   80102592 <nameiparent>
80106589:	83 c4 10             	add    $0x10,%esp
8010658c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010658f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106593:	75 0a                	jne    8010659f <create+0x40>
    return 0;
80106595:	b8 00 00 00 00       	mov    $0x0,%eax
8010659a:	e9 90 01 00 00       	jmp    8010672f <create+0x1d0>
  ilock(dp);
8010659f:	83 ec 0c             	sub    $0xc,%esp
801065a2:	ff 75 f4             	pushl  -0xc(%ebp)
801065a5:	e8 0e b4 ff ff       	call   801019b8 <ilock>
801065aa:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801065ad:	83 ec 04             	sub    $0x4,%esp
801065b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801065b3:	50                   	push   %eax
801065b4:	8d 45 de             	lea    -0x22(%ebp),%eax
801065b7:	50                   	push   %eax
801065b8:	ff 75 f4             	pushl  -0xc(%ebp)
801065bb:	e8 60 bc ff ff       	call   80102220 <dirlookup>
801065c0:	83 c4 10             	add    $0x10,%esp
801065c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801065c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801065ca:	74 50                	je     8010661c <create+0xbd>
    iunlockput(dp);
801065cc:	83 ec 0c             	sub    $0xc,%esp
801065cf:	ff 75 f4             	pushl  -0xc(%ebp)
801065d2:	e8 a1 b6 ff ff       	call   80101c78 <iunlockput>
801065d7:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801065da:	83 ec 0c             	sub    $0xc,%esp
801065dd:	ff 75 f0             	pushl  -0x10(%ebp)
801065e0:	e8 d3 b3 ff ff       	call   801019b8 <ilock>
801065e5:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801065e8:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801065ed:	75 15                	jne    80106604 <create+0xa5>
801065ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065f2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801065f6:	66 83 f8 02          	cmp    $0x2,%ax
801065fa:	75 08                	jne    80106604 <create+0xa5>
      return ip;
801065fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065ff:	e9 2b 01 00 00       	jmp    8010672f <create+0x1d0>
    iunlockput(ip);
80106604:	83 ec 0c             	sub    $0xc,%esp
80106607:	ff 75 f0             	pushl  -0x10(%ebp)
8010660a:	e8 69 b6 ff ff       	call   80101c78 <iunlockput>
8010660f:	83 c4 10             	add    $0x10,%esp
    return 0;
80106612:	b8 00 00 00 00       	mov    $0x0,%eax
80106617:	e9 13 01 00 00       	jmp    8010672f <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010661c:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106620:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106623:	8b 00                	mov    (%eax),%eax
80106625:	83 ec 08             	sub    $0x8,%esp
80106628:	52                   	push   %edx
80106629:	50                   	push   %eax
8010662a:	e8 d8 b0 ff ff       	call   80101707 <ialloc>
8010662f:	83 c4 10             	add    $0x10,%esp
80106632:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106639:	75 0d                	jne    80106648 <create+0xe9>
    panic("create: ialloc");
8010663b:	83 ec 0c             	sub    $0xc,%esp
8010663e:	68 fe 93 10 80       	push   $0x801093fe
80106643:	e8 1e 9f ff ff       	call   80100566 <panic>

  ilock(ip);
80106648:	83 ec 0c             	sub    $0xc,%esp
8010664b:	ff 75 f0             	pushl  -0x10(%ebp)
8010664e:	e8 65 b3 ff ff       	call   801019b8 <ilock>
80106653:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106656:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106659:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010665d:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106661:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106664:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106668:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010666c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010666f:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106675:	83 ec 0c             	sub    $0xc,%esp
80106678:	ff 75 f0             	pushl  -0x10(%ebp)
8010667b:	e8 5e b1 ff ff       	call   801017de <iupdate>
80106680:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106683:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106688:	75 6a                	jne    801066f4 <create+0x195>
    dp->nlink++;  // for ".."
8010668a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010668d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106691:	83 c0 01             	add    $0x1,%eax
80106694:	89 c2                	mov    %eax,%edx
80106696:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106699:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010669d:	83 ec 0c             	sub    $0xc,%esp
801066a0:	ff 75 f4             	pushl  -0xc(%ebp)
801066a3:	e8 36 b1 ff ff       	call   801017de <iupdate>
801066a8:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801066ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066ae:	8b 40 04             	mov    0x4(%eax),%eax
801066b1:	83 ec 04             	sub    $0x4,%esp
801066b4:	50                   	push   %eax
801066b5:	68 d8 93 10 80       	push   $0x801093d8
801066ba:	ff 75 f0             	pushl  -0x10(%ebp)
801066bd:	e8 18 bc ff ff       	call   801022da <dirlink>
801066c2:	83 c4 10             	add    $0x10,%esp
801066c5:	85 c0                	test   %eax,%eax
801066c7:	78 1e                	js     801066e7 <create+0x188>
801066c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066cc:	8b 40 04             	mov    0x4(%eax),%eax
801066cf:	83 ec 04             	sub    $0x4,%esp
801066d2:	50                   	push   %eax
801066d3:	68 da 93 10 80       	push   $0x801093da
801066d8:	ff 75 f0             	pushl  -0x10(%ebp)
801066db:	e8 fa bb ff ff       	call   801022da <dirlink>
801066e0:	83 c4 10             	add    $0x10,%esp
801066e3:	85 c0                	test   %eax,%eax
801066e5:	79 0d                	jns    801066f4 <create+0x195>
      panic("create dots");
801066e7:	83 ec 0c             	sub    $0xc,%esp
801066ea:	68 0d 94 10 80       	push   $0x8010940d
801066ef:	e8 72 9e ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801066f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066f7:	8b 40 04             	mov    0x4(%eax),%eax
801066fa:	83 ec 04             	sub    $0x4,%esp
801066fd:	50                   	push   %eax
801066fe:	8d 45 de             	lea    -0x22(%ebp),%eax
80106701:	50                   	push   %eax
80106702:	ff 75 f4             	pushl  -0xc(%ebp)
80106705:	e8 d0 bb ff ff       	call   801022da <dirlink>
8010670a:	83 c4 10             	add    $0x10,%esp
8010670d:	85 c0                	test   %eax,%eax
8010670f:	79 0d                	jns    8010671e <create+0x1bf>
    panic("create: dirlink");
80106711:	83 ec 0c             	sub    $0xc,%esp
80106714:	68 19 94 10 80       	push   $0x80109419
80106719:	e8 48 9e ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010671e:	83 ec 0c             	sub    $0xc,%esp
80106721:	ff 75 f4             	pushl  -0xc(%ebp)
80106724:	e8 4f b5 ff ff       	call   80101c78 <iunlockput>
80106729:	83 c4 10             	add    $0x10,%esp

  return ip;
8010672c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010672f:	c9                   	leave  
80106730:	c3                   	ret    

80106731 <sys_open>:

int
sys_open(void)
{
80106731:	55                   	push   %ebp
80106732:	89 e5                	mov    %esp,%ebp
80106734:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106737:	83 ec 08             	sub    $0x8,%esp
8010673a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010673d:	50                   	push   %eax
8010673e:	6a 00                	push   $0x0
80106740:	e8 eb f6 ff ff       	call   80105e30 <argstr>
80106745:	83 c4 10             	add    $0x10,%esp
80106748:	85 c0                	test   %eax,%eax
8010674a:	78 15                	js     80106761 <sys_open+0x30>
8010674c:	83 ec 08             	sub    $0x8,%esp
8010674f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106752:	50                   	push   %eax
80106753:	6a 01                	push   $0x1
80106755:	e8 51 f6 ff ff       	call   80105dab <argint>
8010675a:	83 c4 10             	add    $0x10,%esp
8010675d:	85 c0                	test   %eax,%eax
8010675f:	79 0a                	jns    8010676b <sys_open+0x3a>
    return -1;
80106761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106766:	e9 61 01 00 00       	jmp    801068cc <sys_open+0x19b>

  begin_op();
8010676b:	e8 2b ce ff ff       	call   8010359b <begin_op>

  if(omode & O_CREATE){
80106770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106773:	25 00 02 00 00       	and    $0x200,%eax
80106778:	85 c0                	test   %eax,%eax
8010677a:	74 2a                	je     801067a6 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010677c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010677f:	6a 00                	push   $0x0
80106781:	6a 00                	push   $0x0
80106783:	6a 02                	push   $0x2
80106785:	50                   	push   %eax
80106786:	e8 d4 fd ff ff       	call   8010655f <create>
8010678b:	83 c4 10             	add    $0x10,%esp
8010678e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106795:	75 75                	jne    8010680c <sys_open+0xdb>
      end_op();
80106797:	e8 8b ce ff ff       	call   80103627 <end_op>
      return -1;
8010679c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a1:	e9 26 01 00 00       	jmp    801068cc <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801067a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801067a9:	83 ec 0c             	sub    $0xc,%esp
801067ac:	50                   	push   %eax
801067ad:	e8 c4 bd ff ff       	call   80102576 <namei>
801067b2:	83 c4 10             	add    $0x10,%esp
801067b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067bc:	75 0f                	jne    801067cd <sys_open+0x9c>
      end_op();
801067be:	e8 64 ce ff ff       	call   80103627 <end_op>
      return -1;
801067c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067c8:	e9 ff 00 00 00       	jmp    801068cc <sys_open+0x19b>
    }
    ilock(ip);
801067cd:	83 ec 0c             	sub    $0xc,%esp
801067d0:	ff 75 f4             	pushl  -0xc(%ebp)
801067d3:	e8 e0 b1 ff ff       	call   801019b8 <ilock>
801067d8:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801067db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067de:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801067e2:	66 83 f8 01          	cmp    $0x1,%ax
801067e6:	75 24                	jne    8010680c <sys_open+0xdb>
801067e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067eb:	85 c0                	test   %eax,%eax
801067ed:	74 1d                	je     8010680c <sys_open+0xdb>
      iunlockput(ip);
801067ef:	83 ec 0c             	sub    $0xc,%esp
801067f2:	ff 75 f4             	pushl  -0xc(%ebp)
801067f5:	e8 7e b4 ff ff       	call   80101c78 <iunlockput>
801067fa:	83 c4 10             	add    $0x10,%esp
      end_op();
801067fd:	e8 25 ce ff ff       	call   80103627 <end_op>
      return -1;
80106802:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106807:	e9 c0 00 00 00       	jmp    801068cc <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010680c:	e8 d0 a7 ff ff       	call   80100fe1 <filealloc>
80106811:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106814:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106818:	74 17                	je     80106831 <sys_open+0x100>
8010681a:	83 ec 0c             	sub    $0xc,%esp
8010681d:	ff 75 f0             	pushl  -0x10(%ebp)
80106820:	e8 37 f7 ff ff       	call   80105f5c <fdalloc>
80106825:	83 c4 10             	add    $0x10,%esp
80106828:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010682b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010682f:	79 2e                	jns    8010685f <sys_open+0x12e>
    if(f)
80106831:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106835:	74 0e                	je     80106845 <sys_open+0x114>
      fileclose(f);
80106837:	83 ec 0c             	sub    $0xc,%esp
8010683a:	ff 75 f0             	pushl  -0x10(%ebp)
8010683d:	e8 5d a8 ff ff       	call   8010109f <fileclose>
80106842:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106845:	83 ec 0c             	sub    $0xc,%esp
80106848:	ff 75 f4             	pushl  -0xc(%ebp)
8010684b:	e8 28 b4 ff ff       	call   80101c78 <iunlockput>
80106850:	83 c4 10             	add    $0x10,%esp
    end_op();
80106853:	e8 cf cd ff ff       	call   80103627 <end_op>
    return -1;
80106858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010685d:	eb 6d                	jmp    801068cc <sys_open+0x19b>
  }
  iunlock(ip);
8010685f:	83 ec 0c             	sub    $0xc,%esp
80106862:	ff 75 f4             	pushl  -0xc(%ebp)
80106865:	e8 ac b2 ff ff       	call   80101b16 <iunlock>
8010686a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010686d:	e8 b5 cd ff ff       	call   80103627 <end_op>

  f->type = FD_INODE;
80106872:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106875:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010687b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010687e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106881:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106884:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106887:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010688e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106891:	83 e0 01             	and    $0x1,%eax
80106894:	85 c0                	test   %eax,%eax
80106896:	0f 94 c0             	sete   %al
80106899:	89 c2                	mov    %eax,%edx
8010689b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010689e:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801068a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068a4:	83 e0 01             	and    $0x1,%eax
801068a7:	85 c0                	test   %eax,%eax
801068a9:	75 0a                	jne    801068b5 <sys_open+0x184>
801068ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068ae:	83 e0 02             	and    $0x2,%eax
801068b1:	85 c0                	test   %eax,%eax
801068b3:	74 07                	je     801068bc <sys_open+0x18b>
801068b5:	b8 01 00 00 00       	mov    $0x1,%eax
801068ba:	eb 05                	jmp    801068c1 <sys_open+0x190>
801068bc:	b8 00 00 00 00       	mov    $0x0,%eax
801068c1:	89 c2                	mov    %eax,%edx
801068c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068c6:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801068c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801068cc:	c9                   	leave  
801068cd:	c3                   	ret    

801068ce <sys_mkdir>:

int
sys_mkdir(void)
{
801068ce:	55                   	push   %ebp
801068cf:	89 e5                	mov    %esp,%ebp
801068d1:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801068d4:	e8 c2 cc ff ff       	call   8010359b <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801068d9:	83 ec 08             	sub    $0x8,%esp
801068dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068df:	50                   	push   %eax
801068e0:	6a 00                	push   $0x0
801068e2:	e8 49 f5 ff ff       	call   80105e30 <argstr>
801068e7:	83 c4 10             	add    $0x10,%esp
801068ea:	85 c0                	test   %eax,%eax
801068ec:	78 1b                	js     80106909 <sys_mkdir+0x3b>
801068ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068f1:	6a 00                	push   $0x0
801068f3:	6a 00                	push   $0x0
801068f5:	6a 01                	push   $0x1
801068f7:	50                   	push   %eax
801068f8:	e8 62 fc ff ff       	call   8010655f <create>
801068fd:	83 c4 10             	add    $0x10,%esp
80106900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106907:	75 0c                	jne    80106915 <sys_mkdir+0x47>
    end_op();
80106909:	e8 19 cd ff ff       	call   80103627 <end_op>
    return -1;
8010690e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106913:	eb 18                	jmp    8010692d <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106915:	83 ec 0c             	sub    $0xc,%esp
80106918:	ff 75 f4             	pushl  -0xc(%ebp)
8010691b:	e8 58 b3 ff ff       	call   80101c78 <iunlockput>
80106920:	83 c4 10             	add    $0x10,%esp
  end_op();
80106923:	e8 ff cc ff ff       	call   80103627 <end_op>
  return 0;
80106928:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010692d:	c9                   	leave  
8010692e:	c3                   	ret    

8010692f <sys_mknod>:

int
sys_mknod(void)
{
8010692f:	55                   	push   %ebp
80106930:	89 e5                	mov    %esp,%ebp
80106932:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106935:	e8 61 cc ff ff       	call   8010359b <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010693a:	83 ec 08             	sub    $0x8,%esp
8010693d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106940:	50                   	push   %eax
80106941:	6a 00                	push   $0x0
80106943:	e8 e8 f4 ff ff       	call   80105e30 <argstr>
80106948:	83 c4 10             	add    $0x10,%esp
8010694b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010694e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106952:	78 4f                	js     801069a3 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106954:	83 ec 08             	sub    $0x8,%esp
80106957:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010695a:	50                   	push   %eax
8010695b:	6a 01                	push   $0x1
8010695d:	e8 49 f4 ff ff       	call   80105dab <argint>
80106962:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106965:	85 c0                	test   %eax,%eax
80106967:	78 3a                	js     801069a3 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106969:	83 ec 08             	sub    $0x8,%esp
8010696c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010696f:	50                   	push   %eax
80106970:	6a 02                	push   $0x2
80106972:	e8 34 f4 ff ff       	call   80105dab <argint>
80106977:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010697a:	85 c0                	test   %eax,%eax
8010697c:	78 25                	js     801069a3 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010697e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106981:	0f bf c8             	movswl %ax,%ecx
80106984:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106987:	0f bf d0             	movswl %ax,%edx
8010698a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010698d:	51                   	push   %ecx
8010698e:	52                   	push   %edx
8010698f:	6a 03                	push   $0x3
80106991:	50                   	push   %eax
80106992:	e8 c8 fb ff ff       	call   8010655f <create>
80106997:	83 c4 10             	add    $0x10,%esp
8010699a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010699d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801069a1:	75 0c                	jne    801069af <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801069a3:	e8 7f cc ff ff       	call   80103627 <end_op>
    return -1;
801069a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069ad:	eb 18                	jmp    801069c7 <sys_mknod+0x98>
  }
  iunlockput(ip);
801069af:	83 ec 0c             	sub    $0xc,%esp
801069b2:	ff 75 f0             	pushl  -0x10(%ebp)
801069b5:	e8 be b2 ff ff       	call   80101c78 <iunlockput>
801069ba:	83 c4 10             	add    $0x10,%esp
  end_op();
801069bd:	e8 65 cc ff ff       	call   80103627 <end_op>
  return 0;
801069c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069c7:	c9                   	leave  
801069c8:	c3                   	ret    

801069c9 <sys_chdir>:

int
sys_chdir(void)
{
801069c9:	55                   	push   %ebp
801069ca:	89 e5                	mov    %esp,%ebp
801069cc:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801069cf:	e8 c7 cb ff ff       	call   8010359b <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801069d4:	83 ec 08             	sub    $0x8,%esp
801069d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069da:	50                   	push   %eax
801069db:	6a 00                	push   $0x0
801069dd:	e8 4e f4 ff ff       	call   80105e30 <argstr>
801069e2:	83 c4 10             	add    $0x10,%esp
801069e5:	85 c0                	test   %eax,%eax
801069e7:	78 18                	js     80106a01 <sys_chdir+0x38>
801069e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069ec:	83 ec 0c             	sub    $0xc,%esp
801069ef:	50                   	push   %eax
801069f0:	e8 81 bb ff ff       	call   80102576 <namei>
801069f5:	83 c4 10             	add    $0x10,%esp
801069f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069ff:	75 0c                	jne    80106a0d <sys_chdir+0x44>
    end_op();
80106a01:	e8 21 cc ff ff       	call   80103627 <end_op>
    return -1;
80106a06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a0b:	eb 6e                	jmp    80106a7b <sys_chdir+0xb2>
  }
  ilock(ip);
80106a0d:	83 ec 0c             	sub    $0xc,%esp
80106a10:	ff 75 f4             	pushl  -0xc(%ebp)
80106a13:	e8 a0 af ff ff       	call   801019b8 <ilock>
80106a18:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a1e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106a22:	66 83 f8 01          	cmp    $0x1,%ax
80106a26:	74 1a                	je     80106a42 <sys_chdir+0x79>
    iunlockput(ip);
80106a28:	83 ec 0c             	sub    $0xc,%esp
80106a2b:	ff 75 f4             	pushl  -0xc(%ebp)
80106a2e:	e8 45 b2 ff ff       	call   80101c78 <iunlockput>
80106a33:	83 c4 10             	add    $0x10,%esp
    end_op();
80106a36:	e8 ec cb ff ff       	call   80103627 <end_op>
    return -1;
80106a3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a40:	eb 39                	jmp    80106a7b <sys_chdir+0xb2>
  }
  iunlock(ip);
80106a42:	83 ec 0c             	sub    $0xc,%esp
80106a45:	ff 75 f4             	pushl  -0xc(%ebp)
80106a48:	e8 c9 b0 ff ff       	call   80101b16 <iunlock>
80106a4d:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106a50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a56:	8b 40 68             	mov    0x68(%eax),%eax
80106a59:	83 ec 0c             	sub    $0xc,%esp
80106a5c:	50                   	push   %eax
80106a5d:	e8 26 b1 ff ff       	call   80101b88 <iput>
80106a62:	83 c4 10             	add    $0x10,%esp
  end_op();
80106a65:	e8 bd cb ff ff       	call   80103627 <end_op>
  proc->cwd = ip;
80106a6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a73:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a7b:	c9                   	leave  
80106a7c:	c3                   	ret    

80106a7d <sys_exec>:

int
sys_exec(void)
{
80106a7d:	55                   	push   %ebp
80106a7e:	89 e5                	mov    %esp,%ebp
80106a80:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106a86:	83 ec 08             	sub    $0x8,%esp
80106a89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a8c:	50                   	push   %eax
80106a8d:	6a 00                	push   $0x0
80106a8f:	e8 9c f3 ff ff       	call   80105e30 <argstr>
80106a94:	83 c4 10             	add    $0x10,%esp
80106a97:	85 c0                	test   %eax,%eax
80106a99:	78 18                	js     80106ab3 <sys_exec+0x36>
80106a9b:	83 ec 08             	sub    $0x8,%esp
80106a9e:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106aa4:	50                   	push   %eax
80106aa5:	6a 01                	push   $0x1
80106aa7:	e8 ff f2 ff ff       	call   80105dab <argint>
80106aac:	83 c4 10             	add    $0x10,%esp
80106aaf:	85 c0                	test   %eax,%eax
80106ab1:	79 0a                	jns    80106abd <sys_exec+0x40>
    return -1;
80106ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ab8:	e9 c6 00 00 00       	jmp    80106b83 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106abd:	83 ec 04             	sub    $0x4,%esp
80106ac0:	68 80 00 00 00       	push   $0x80
80106ac5:	6a 00                	push   $0x0
80106ac7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106acd:	50                   	push   %eax
80106ace:	e8 b3 ef ff ff       	call   80105a86 <memset>
80106ad3:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106ad6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ae0:	83 f8 1f             	cmp    $0x1f,%eax
80106ae3:	76 0a                	jbe    80106aef <sys_exec+0x72>
      return -1;
80106ae5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aea:	e9 94 00 00 00       	jmp    80106b83 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106af2:	c1 e0 02             	shl    $0x2,%eax
80106af5:	89 c2                	mov    %eax,%edx
80106af7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106afd:	01 c2                	add    %eax,%edx
80106aff:	83 ec 08             	sub    $0x8,%esp
80106b02:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106b08:	50                   	push   %eax
80106b09:	52                   	push   %edx
80106b0a:	e8 00 f2 ff ff       	call   80105d0f <fetchint>
80106b0f:	83 c4 10             	add    $0x10,%esp
80106b12:	85 c0                	test   %eax,%eax
80106b14:	79 07                	jns    80106b1d <sys_exec+0xa0>
      return -1;
80106b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b1b:	eb 66                	jmp    80106b83 <sys_exec+0x106>
    if(uarg == 0){
80106b1d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106b23:	85 c0                	test   %eax,%eax
80106b25:	75 27                	jne    80106b4e <sys_exec+0xd1>
      argv[i] = 0;
80106b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2a:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106b31:	00 00 00 00 
      break;
80106b35:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b39:	83 ec 08             	sub    $0x8,%esp
80106b3c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106b42:	52                   	push   %edx
80106b43:	50                   	push   %eax
80106b44:	e8 76 a0 ff ff       	call   80100bbf <exec>
80106b49:	83 c4 10             	add    $0x10,%esp
80106b4c:	eb 35                	jmp    80106b83 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106b4e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106b54:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b57:	c1 e2 02             	shl    $0x2,%edx
80106b5a:	01 c2                	add    %eax,%edx
80106b5c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106b62:	83 ec 08             	sub    $0x8,%esp
80106b65:	52                   	push   %edx
80106b66:	50                   	push   %eax
80106b67:	e8 dd f1 ff ff       	call   80105d49 <fetchstr>
80106b6c:	83 c4 10             	add    $0x10,%esp
80106b6f:	85 c0                	test   %eax,%eax
80106b71:	79 07                	jns    80106b7a <sys_exec+0xfd>
      return -1;
80106b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b78:	eb 09                	jmp    80106b83 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106b7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106b7e:	e9 5a ff ff ff       	jmp    80106add <sys_exec+0x60>
  return exec(path, argv);
}
80106b83:	c9                   	leave  
80106b84:	c3                   	ret    

80106b85 <sys_pipe>:

int
sys_pipe(void)
{
80106b85:	55                   	push   %ebp
80106b86:	89 e5                	mov    %esp,%ebp
80106b88:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106b8b:	83 ec 04             	sub    $0x4,%esp
80106b8e:	6a 08                	push   $0x8
80106b90:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b93:	50                   	push   %eax
80106b94:	6a 00                	push   $0x0
80106b96:	e8 38 f2 ff ff       	call   80105dd3 <argptr>
80106b9b:	83 c4 10             	add    $0x10,%esp
80106b9e:	85 c0                	test   %eax,%eax
80106ba0:	79 0a                	jns    80106bac <sys_pipe+0x27>
    return -1;
80106ba2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ba7:	e9 af 00 00 00       	jmp    80106c5b <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106bac:	83 ec 08             	sub    $0x8,%esp
80106baf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106bb2:	50                   	push   %eax
80106bb3:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106bb6:	50                   	push   %eax
80106bb7:	e8 d3 d4 ff ff       	call   8010408f <pipealloc>
80106bbc:	83 c4 10             	add    $0x10,%esp
80106bbf:	85 c0                	test   %eax,%eax
80106bc1:	79 0a                	jns    80106bcd <sys_pipe+0x48>
    return -1;
80106bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bc8:	e9 8e 00 00 00       	jmp    80106c5b <sys_pipe+0xd6>
  fd0 = -1;
80106bcd:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106bd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106bd7:	83 ec 0c             	sub    $0xc,%esp
80106bda:	50                   	push   %eax
80106bdb:	e8 7c f3 ff ff       	call   80105f5c <fdalloc>
80106be0:	83 c4 10             	add    $0x10,%esp
80106be3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106be6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106bea:	78 18                	js     80106c04 <sys_pipe+0x7f>
80106bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bef:	83 ec 0c             	sub    $0xc,%esp
80106bf2:	50                   	push   %eax
80106bf3:	e8 64 f3 ff ff       	call   80105f5c <fdalloc>
80106bf8:	83 c4 10             	add    $0x10,%esp
80106bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106bfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106c02:	79 3f                	jns    80106c43 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c08:	78 14                	js     80106c1e <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106c0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c13:	83 c2 08             	add    $0x8,%edx
80106c16:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106c1d:	00 
    fileclose(rf);
80106c1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106c21:	83 ec 0c             	sub    $0xc,%esp
80106c24:	50                   	push   %eax
80106c25:	e8 75 a4 ff ff       	call   8010109f <fileclose>
80106c2a:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106c2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c30:	83 ec 0c             	sub    $0xc,%esp
80106c33:	50                   	push   %eax
80106c34:	e8 66 a4 ff ff       	call   8010109f <fileclose>
80106c39:	83 c4 10             	add    $0x10,%esp
    return -1;
80106c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c41:	eb 18                	jmp    80106c5b <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106c46:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c49:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106c4e:	8d 50 04             	lea    0x4(%eax),%edx
80106c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c54:	89 02                	mov    %eax,(%edx)
  return 0;
80106c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c5b:	c9                   	leave  
80106c5c:	c3                   	ret    

80106c5d <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80106c5d:	55                   	push   %ebp
80106c5e:	89 e5                	mov    %esp,%ebp
80106c60:	83 ec 08             	sub    $0x8,%esp
80106c63:	8b 55 08             	mov    0x8(%ebp),%edx
80106c66:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c69:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106c6d:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c71:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106c75:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106c79:	66 ef                	out    %ax,(%dx)
}
80106c7b:	90                   	nop
80106c7c:	c9                   	leave  
80106c7d:	c3                   	ret    

80106c7e <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
80106c7e:	55                   	push   %ebp
80106c7f:	89 e5                	mov    %esp,%ebp
80106c81:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106c84:	e8 b6 dc ff ff       	call   8010493f <fork>
}
80106c89:	c9                   	leave  
80106c8a:	c3                   	ret    

80106c8b <sys_exit>:

int
sys_exit(void)
{
80106c8b:	55                   	push   %ebp
80106c8c:	89 e5                	mov    %esp,%ebp
80106c8e:	83 ec 08             	sub    $0x8,%esp
  exit();
80106c91:	e8 f3 de ff ff       	call   80104b89 <exit>
  return 0;  // not reached
80106c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c9b:	c9                   	leave  
80106c9c:	c3                   	ret    

80106c9d <sys_wait>:

int
sys_wait(void)
{
80106c9d:	55                   	push   %ebp
80106c9e:	89 e5                	mov    %esp,%ebp
80106ca0:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106ca3:	e8 1c e0 ff ff       	call   80104cc4 <wait>
}
80106ca8:	c9                   	leave  
80106ca9:	c3                   	ret    

80106caa <sys_kill>:

int
sys_kill(void)
{
80106caa:	55                   	push   %ebp
80106cab:	89 e5                	mov    %esp,%ebp
80106cad:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106cb0:	83 ec 08             	sub    $0x8,%esp
80106cb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cb6:	50                   	push   %eax
80106cb7:	6a 00                	push   $0x0
80106cb9:	e8 ed f0 ff ff       	call   80105dab <argint>
80106cbe:	83 c4 10             	add    $0x10,%esp
80106cc1:	85 c0                	test   %eax,%eax
80106cc3:	79 07                	jns    80106ccc <sys_kill+0x22>
    return -1;
80106cc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cca:	eb 0f                	jmp    80106cdb <sys_kill+0x31>
  return kill(pid);
80106ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ccf:	83 ec 0c             	sub    $0xc,%esp
80106cd2:	50                   	push   %eax
80106cd3:	e8 81 e4 ff ff       	call   80105159 <kill>
80106cd8:	83 c4 10             	add    $0x10,%esp
}
80106cdb:	c9                   	leave  
80106cdc:	c3                   	ret    

80106cdd <sys_getpid>:

int
sys_getpid(void)
{
80106cdd:	55                   	push   %ebp
80106cde:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106ce0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ce6:	8b 40 10             	mov    0x10(%eax),%eax
}
80106ce9:	5d                   	pop    %ebp
80106cea:	c3                   	ret    

80106ceb <sys_sbrk>:

int
sys_sbrk(void)
{
80106ceb:	55                   	push   %ebp
80106cec:	89 e5                	mov    %esp,%ebp
80106cee:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106cf1:	83 ec 08             	sub    $0x8,%esp
80106cf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cf7:	50                   	push   %eax
80106cf8:	6a 00                	push   $0x0
80106cfa:	e8 ac f0 ff ff       	call   80105dab <argint>
80106cff:	83 c4 10             	add    $0x10,%esp
80106d02:	85 c0                	test   %eax,%eax
80106d04:	79 07                	jns    80106d0d <sys_sbrk+0x22>
    return -1;
80106d06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d0b:	eb 28                	jmp    80106d35 <sys_sbrk+0x4a>
  addr = proc->sz;
80106d0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d13:	8b 00                	mov    (%eax),%eax
80106d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d1b:	83 ec 0c             	sub    $0xc,%esp
80106d1e:	50                   	push   %eax
80106d1f:	e8 78 db ff ff       	call   8010489c <growproc>
80106d24:	83 c4 10             	add    $0x10,%esp
80106d27:	85 c0                	test   %eax,%eax
80106d29:	79 07                	jns    80106d32 <sys_sbrk+0x47>
    return -1;
80106d2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d30:	eb 03                	jmp    80106d35 <sys_sbrk+0x4a>
  return addr;
80106d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106d35:	c9                   	leave  
80106d36:	c3                   	ret    

80106d37 <sys_sleep>:

int
sys_sleep(void)
{
80106d37:	55                   	push   %ebp
80106d38:	89 e5                	mov    %esp,%ebp
80106d3a:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106d3d:	83 ec 08             	sub    $0x8,%esp
80106d40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d43:	50                   	push   %eax
80106d44:	6a 00                	push   $0x0
80106d46:	e8 60 f0 ff ff       	call   80105dab <argint>
80106d4b:	83 c4 10             	add    $0x10,%esp
80106d4e:	85 c0                	test   %eax,%eax
80106d50:	79 07                	jns    80106d59 <sys_sleep+0x22>
    return -1;
80106d52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d57:	eb 44                	jmp    80106d9d <sys_sleep+0x66>
  ticks0 = ticks;
80106d59:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80106d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106d61:	eb 26                	jmp    80106d89 <sys_sleep+0x52>
    if(proc->killed){
80106d63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d69:	8b 40 24             	mov    0x24(%eax),%eax
80106d6c:	85 c0                	test   %eax,%eax
80106d6e:	74 07                	je     80106d77 <sys_sleep+0x40>
      return -1;
80106d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d75:	eb 26                	jmp    80106d9d <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80106d77:	83 ec 08             	sub    $0x8,%esp
80106d7a:	6a 00                	push   $0x0
80106d7c:	68 e0 66 11 80       	push   $0x801166e0
80106d81:	e8 b5 e2 ff ff       	call   8010503b <sleep>
80106d86:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106d89:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80106d8e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106d91:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d94:	39 d0                	cmp    %edx,%eax
80106d96:	72 cb                	jb     80106d63 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80106d98:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d9d:	c9                   	leave  
80106d9e:	c3                   	ret    

80106d9f <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80106d9f:	55                   	push   %ebp
80106da0:	89 e5                	mov    %esp,%ebp
80106da2:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80106da5:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80106daa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80106dad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106db0:	c9                   	leave  
80106db1:	c3                   	ret    

80106db2 <sys_halt>:

//Turn of the computer
int sys_halt(void){
80106db2:	55                   	push   %ebp
80106db3:	89 e5                	mov    %esp,%ebp
80106db5:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80106db8:	83 ec 0c             	sub    $0xc,%esp
80106dbb:	68 29 94 10 80       	push   $0x80109429
80106dc0:	e8 01 96 ff ff       	call   801003c6 <cprintf>
80106dc5:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
80106dc8:	83 ec 08             	sub    $0x8,%esp
80106dcb:	68 00 20 00 00       	push   $0x2000
80106dd0:	68 04 06 00 00       	push   $0x604
80106dd5:	e8 83 fe ff ff       	call   80106c5d <outw>
80106dda:	83 c4 10             	add    $0x10,%esp
  return 0;
80106ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106de2:	c9                   	leave  
80106de3:	c3                   	ret    

80106de4 <sys_date>:

// My implementation of sys_date()
int
sys_date(void)
{
80106de4:	55                   	push   %ebp
80106de5:	89 e5                	mov    %esp,%ebp
80106de7:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if (argptr(0, (void*)&d, sizeof(*d)) < 0)
80106dea:	83 ec 04             	sub    $0x4,%esp
80106ded:	6a 18                	push   $0x18
80106def:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106df2:	50                   	push   %eax
80106df3:	6a 00                	push   $0x0
80106df5:	e8 d9 ef ff ff       	call   80105dd3 <argptr>
80106dfa:	83 c4 10             	add    $0x10,%esp
80106dfd:	85 c0                	test   %eax,%eax
80106dff:	79 07                	jns    80106e08 <sys_date+0x24>
    return -1;
80106e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e06:	eb 14                	jmp    80106e1c <sys_date+0x38>
  // MY CODE HERE
  cmostime(d);       
80106e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e0b:	83 ec 0c             	sub    $0xc,%esp
80106e0e:	50                   	push   %eax
80106e0f:	e8 02 c4 ff ff       	call   80103216 <cmostime>
80106e14:	83 c4 10             	add    $0x10,%esp
  return 0; 
80106e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e1c:	c9                   	leave  
80106e1d:	c3                   	ret    

80106e1e <sys_getuid>:

// My implementation of sys_getuid
uint
sys_getuid(void)
{
80106e1e:	55                   	push   %ebp
80106e1f:	89 e5                	mov    %esp,%ebp
  return proc->uid;
80106e21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e27:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80106e2d:	5d                   	pop    %ebp
80106e2e:	c3                   	ret    

80106e2f <sys_getgid>:

// My implementation of sys_getgid
uint
sys_getgid(void)
{
80106e2f:	55                   	push   %ebp
80106e30:	89 e5                	mov    %esp,%ebp
  return proc->gid;
80106e32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e38:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80106e3e:	5d                   	pop    %ebp
80106e3f:	c3                   	ret    

80106e40 <sys_getppid>:

// My implementation of sys_getppid
uint
sys_getppid(void)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
  return proc->parent ? proc->parent->pid : proc->pid;
80106e43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e49:	8b 40 14             	mov    0x14(%eax),%eax
80106e4c:	85 c0                	test   %eax,%eax
80106e4e:	74 0e                	je     80106e5e <sys_getppid+0x1e>
80106e50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e56:	8b 40 14             	mov    0x14(%eax),%eax
80106e59:	8b 40 10             	mov    0x10(%eax),%eax
80106e5c:	eb 09                	jmp    80106e67 <sys_getppid+0x27>
80106e5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e64:	8b 40 10             	mov    0x10(%eax),%eax
}
80106e67:	5d                   	pop    %ebp
80106e68:	c3                   	ret    

80106e69 <sys_setuid>:


// Implementation of sys_setuid
int 
sys_setuid(void)
{
80106e69:	55                   	push   %ebp
80106e6a:	89 e5                	mov    %esp,%ebp
80106e6c:	83 ec 18             	sub    $0x18,%esp
  int id; // uid argument
  // Grab argument off the stack and store in id
  argint(0, &id);
80106e6f:	83 ec 08             	sub    $0x8,%esp
80106e72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e75:	50                   	push   %eax
80106e76:	6a 00                	push   $0x0
80106e78:	e8 2e ef ff ff       	call   80105dab <argint>
80106e7d:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
80106e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e83:	85 c0                	test   %eax,%eax
80106e85:	78 0a                	js     80106e91 <sys_setuid+0x28>
80106e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e8a:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106e8f:	7e 07                	jle    80106e98 <sys_setuid+0x2f>
    return -1;
80106e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e96:	eb 14                	jmp    80106eac <sys_setuid+0x43>
  proc->uid = id; 
80106e98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ea1:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80106ea7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106eac:	c9                   	leave  
80106ead:	c3                   	ret    

80106eae <sys_setgid>:

// Implementation of sys_setgid
int
sys_setgid(void)
{
80106eae:	55                   	push   %ebp
80106eaf:	89 e5                	mov    %esp,%ebp
80106eb1:	83 ec 18             	sub    $0x18,%esp
  int id; // gid argument 
  // Grab argument off the stack and store in id
  argint(0, &id);
80106eb4:	83 ec 08             	sub    $0x8,%esp
80106eb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106eba:	50                   	push   %eax
80106ebb:	6a 00                	push   $0x0
80106ebd:	e8 e9 ee ff ff       	call   80105dab <argint>
80106ec2:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
80106ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ec8:	85 c0                	test   %eax,%eax
80106eca:	78 0a                	js     80106ed6 <sys_setgid+0x28>
80106ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ecf:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106ed4:	7e 07                	jle    80106edd <sys_setgid+0x2f>
    return -1;
80106ed6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106edb:	eb 14                	jmp    80106ef1 <sys_setgid+0x43>
  proc->gid = id;
80106edd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ee6:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  return 0;
80106eec:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ef1:	c9                   	leave  
80106ef2:	c3                   	ret    

80106ef3 <sys_getprocs>:

// Implementation of sys_getprocs
int
sys_getprocs(void)
{
80106ef3:	55                   	push   %ebp
80106ef4:	89 e5                	mov    %esp,%ebp
80106ef6:	83 ec 18             	sub    $0x18,%esp
  int m; // Max arg
  struct uproc* table;
  argint(0, &m);
80106ef9:	83 ec 08             	sub    $0x8,%esp
80106efc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106eff:	50                   	push   %eax
80106f00:	6a 00                	push   $0x0
80106f02:	e8 a4 ee ff ff       	call   80105dab <argint>
80106f07:	83 c4 10             	add    $0x10,%esp
  if (m < 0)
80106f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f0d:	85 c0                	test   %eax,%eax
80106f0f:	79 07                	jns    80106f18 <sys_getprocs+0x25>
    return -1;
80106f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f16:	eb 28                	jmp    80106f40 <sys_getprocs+0x4d>
  argptr(1, (void*)&table, m);
80106f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f1b:	83 ec 04             	sub    $0x4,%esp
80106f1e:	50                   	push   %eax
80106f1f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f22:	50                   	push   %eax
80106f23:	6a 01                	push   $0x1
80106f25:	e8 a9 ee ff ff       	call   80105dd3 <argptr>
80106f2a:	83 c4 10             	add    $0x10,%esp
  return getproc_helper(m, table);
80106f2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f33:	83 ec 08             	sub    $0x8,%esp
80106f36:	52                   	push   %edx
80106f37:	50                   	push   %eax
80106f38:	e8 32 e5 ff ff       	call   8010546f <getproc_helper>
80106f3d:	83 c4 10             	add    $0x10,%esp
}
80106f40:	c9                   	leave  
80106f41:	c3                   	ret    

80106f42 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106f42:	55                   	push   %ebp
80106f43:	89 e5                	mov    %esp,%ebp
80106f45:	83 ec 08             	sub    $0x8,%esp
80106f48:	8b 55 08             	mov    0x8(%ebp),%edx
80106f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f4e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106f52:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f55:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106f59:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106f5d:	ee                   	out    %al,(%dx)
}
80106f5e:	90                   	nop
80106f5f:	c9                   	leave  
80106f60:	c3                   	ret    

80106f61 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106f61:	55                   	push   %ebp
80106f62:	89 e5                	mov    %esp,%ebp
80106f64:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106f67:	6a 34                	push   $0x34
80106f69:	6a 43                	push   $0x43
80106f6b:	e8 d2 ff ff ff       	call   80106f42 <outb>
80106f70:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106f73:	68 9c 00 00 00       	push   $0x9c
80106f78:	6a 40                	push   $0x40
80106f7a:	e8 c3 ff ff ff       	call   80106f42 <outb>
80106f7f:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106f82:	6a 2e                	push   $0x2e
80106f84:	6a 40                	push   $0x40
80106f86:	e8 b7 ff ff ff       	call   80106f42 <outb>
80106f8b:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106f8e:	83 ec 0c             	sub    $0xc,%esp
80106f91:	6a 00                	push   $0x0
80106f93:	e8 e1 cf ff ff       	call   80103f79 <picenable>
80106f98:	83 c4 10             	add    $0x10,%esp
}
80106f9b:	90                   	nop
80106f9c:	c9                   	leave  
80106f9d:	c3                   	ret    

80106f9e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106f9e:	1e                   	push   %ds
  pushl %es
80106f9f:	06                   	push   %es
  pushl %fs
80106fa0:	0f a0                	push   %fs
  pushl %gs
80106fa2:	0f a8                	push   %gs
  pushal
80106fa4:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106fa5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106fa9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106fab:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106fad:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106fb1:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106fb3:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106fb5:	54                   	push   %esp
  call trap
80106fb6:	e8 ce 01 00 00       	call   80107189 <trap>
  addl $4, %esp
80106fbb:	83 c4 04             	add    $0x4,%esp

80106fbe <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106fbe:	61                   	popa   
  popl %gs
80106fbf:	0f a9                	pop    %gs
  popl %fs
80106fc1:	0f a1                	pop    %fs
  popl %es
80106fc3:	07                   	pop    %es
  popl %ds
80106fc4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106fc5:	83 c4 08             	add    $0x8,%esp
  iret
80106fc8:	cf                   	iret   

80106fc9 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80106fc9:	55                   	push   %ebp
80106fca:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80106fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80106fcf:	f0 ff 00             	lock incl (%eax)
}
80106fd2:	90                   	nop
80106fd3:	5d                   	pop    %ebp
80106fd4:	c3                   	ret    

80106fd5 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106fd5:	55                   	push   %ebp
80106fd6:	89 e5                	mov    %esp,%ebp
80106fd8:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fde:	83 e8 01             	sub    $0x1,%eax
80106fe1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106fe5:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106fec:	8b 45 08             	mov    0x8(%ebp),%eax
80106fef:	c1 e8 10             	shr    $0x10,%eax
80106ff2:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106ff6:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ff9:	0f 01 18             	lidtl  (%eax)
}
80106ffc:	90                   	nop
80106ffd:	c9                   	leave  
80106ffe:	c3                   	ret    

80106fff <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106fff:	55                   	push   %ebp
80107000:	89 e5                	mov    %esp,%ebp
80107002:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107005:	0f 20 d0             	mov    %cr2,%eax
80107008:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010700b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010700e:	c9                   	leave  
8010700f:	c3                   	ret    

80107010 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107016:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010701d:	e9 c3 00 00 00       	jmp    801070e5 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107022:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107025:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
8010702c:	89 c2                	mov    %eax,%edx
8010702e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107031:	66 89 14 c5 e0 5e 11 	mov    %dx,-0x7feea120(,%eax,8)
80107038:	80 
80107039:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010703c:	66 c7 04 c5 e2 5e 11 	movw   $0x8,-0x7feea11e(,%eax,8)
80107043:	80 08 00 
80107046:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107049:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
80107050:	80 
80107051:	83 e2 e0             	and    $0xffffffe0,%edx
80107054:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
8010705b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010705e:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
80107065:	80 
80107066:	83 e2 1f             	and    $0x1f,%edx
80107069:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
80107070:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107073:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
8010707a:	80 
8010707b:	83 e2 f0             	and    $0xfffffff0,%edx
8010707e:	83 ca 0e             	or     $0xe,%edx
80107081:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80107088:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010708b:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80107092:	80 
80107093:	83 e2 ef             	and    $0xffffffef,%edx
80107096:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
8010709d:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070a0:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
801070a7:	80 
801070a8:	83 e2 9f             	and    $0xffffff9f,%edx
801070ab:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
801070b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070b5:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
801070bc:	80 
801070bd:	83 ca 80             	or     $0xffffff80,%edx
801070c0:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
801070c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070ca:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
801070d1:	c1 e8 10             	shr    $0x10,%eax
801070d4:	89 c2                	mov    %eax,%edx
801070d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070d9:	66 89 14 c5 e6 5e 11 	mov    %dx,-0x7feea11a(,%eax,8)
801070e0:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801070e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801070e5:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
801070ec:	0f 8e 30 ff ff ff    	jle    80107022 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801070f2:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
801070f7:	66 a3 e0 60 11 80    	mov    %ax,0x801160e0
801070fd:	66 c7 05 e2 60 11 80 	movw   $0x8,0x801160e2
80107104:	08 00 
80107106:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
8010710d:	83 e0 e0             	and    $0xffffffe0,%eax
80107110:	a2 e4 60 11 80       	mov    %al,0x801160e4
80107115:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
8010711c:	83 e0 1f             	and    $0x1f,%eax
8010711f:	a2 e4 60 11 80       	mov    %al,0x801160e4
80107124:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
8010712b:	83 c8 0f             	or     $0xf,%eax
8010712e:	a2 e5 60 11 80       	mov    %al,0x801160e5
80107133:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
8010713a:	83 e0 ef             	and    $0xffffffef,%eax
8010713d:	a2 e5 60 11 80       	mov    %al,0x801160e5
80107142:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107149:	83 c8 60             	or     $0x60,%eax
8010714c:	a2 e5 60 11 80       	mov    %al,0x801160e5
80107151:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107158:	83 c8 80             	or     $0xffffff80,%eax
8010715b:	a2 e5 60 11 80       	mov    %al,0x801160e5
80107160:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80107165:	c1 e8 10             	shr    $0x10,%eax
80107168:	66 a3 e6 60 11 80    	mov    %ax,0x801160e6
  
}
8010716e:	90                   	nop
8010716f:	c9                   	leave  
80107170:	c3                   	ret    

80107171 <idtinit>:

void
idtinit(void)
{
80107171:	55                   	push   %ebp
80107172:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107174:	68 00 08 00 00       	push   $0x800
80107179:	68 e0 5e 11 80       	push   $0x80115ee0
8010717e:	e8 52 fe ff ff       	call   80106fd5 <lidt>
80107183:	83 c4 08             	add    $0x8,%esp
}
80107186:	90                   	nop
80107187:	c9                   	leave  
80107188:	c3                   	ret    

80107189 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107189:	55                   	push   %ebp
8010718a:	89 e5                	mov    %esp,%ebp
8010718c:	57                   	push   %edi
8010718d:	56                   	push   %esi
8010718e:	53                   	push   %ebx
8010718f:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107192:	8b 45 08             	mov    0x8(%ebp),%eax
80107195:	8b 40 30             	mov    0x30(%eax),%eax
80107198:	83 f8 40             	cmp    $0x40,%eax
8010719b:	75 3e                	jne    801071db <trap+0x52>
    if(proc->killed)
8010719d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071a3:	8b 40 24             	mov    0x24(%eax),%eax
801071a6:	85 c0                	test   %eax,%eax
801071a8:	74 05                	je     801071af <trap+0x26>
      exit();
801071aa:	e8 da d9 ff ff       	call   80104b89 <exit>
    proc->tf = tf;
801071af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071b5:	8b 55 08             	mov    0x8(%ebp),%edx
801071b8:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801071bb:	e8 a1 ec ff ff       	call   80105e61 <syscall>
    if(proc->killed)
801071c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071c6:	8b 40 24             	mov    0x24(%eax),%eax
801071c9:	85 c0                	test   %eax,%eax
801071cb:	0f 84 fe 01 00 00    	je     801073cf <trap+0x246>
      exit();
801071d1:	e8 b3 d9 ff ff       	call   80104b89 <exit>
    return;
801071d6:	e9 f4 01 00 00       	jmp    801073cf <trap+0x246>
  }

  switch(tf->trapno){
801071db:	8b 45 08             	mov    0x8(%ebp),%eax
801071de:	8b 40 30             	mov    0x30(%eax),%eax
801071e1:	83 e8 20             	sub    $0x20,%eax
801071e4:	83 f8 1f             	cmp    $0x1f,%eax
801071e7:	0f 87 a3 00 00 00    	ja     80107290 <trap+0x107>
801071ed:	8b 04 85 dc 94 10 80 	mov    -0x7fef6b24(,%eax,4),%eax
801071f4:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
801071f6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801071fc:	0f b6 00             	movzbl (%eax),%eax
801071ff:	84 c0                	test   %al,%al
80107201:	75 20                	jne    80107223 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107203:	83 ec 0c             	sub    $0xc,%esp
80107206:	68 e0 66 11 80       	push   $0x801166e0
8010720b:	e8 b9 fd ff ff       	call   80106fc9 <atom_inc>
80107210:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107213:	83 ec 0c             	sub    $0xc,%esp
80107216:	68 e0 66 11 80       	push   $0x801166e0
8010721b:	e8 02 df ff ff       	call   80105122 <wakeup>
80107220:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107223:	e8 4b be ff ff       	call   80103073 <lapiceoi>
    break;
80107228:	e9 1c 01 00 00       	jmp    80107349 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010722d:	e8 54 b6 ff ff       	call   80102886 <ideintr>
    lapiceoi();
80107232:	e8 3c be ff ff       	call   80103073 <lapiceoi>
    break;
80107237:	e9 0d 01 00 00       	jmp    80107349 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010723c:	e8 34 bc ff ff       	call   80102e75 <kbdintr>
    lapiceoi();
80107241:	e8 2d be ff ff       	call   80103073 <lapiceoi>
    break;
80107246:	e9 fe 00 00 00       	jmp    80107349 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010724b:	e8 60 03 00 00       	call   801075b0 <uartintr>
    lapiceoi();
80107250:	e8 1e be ff ff       	call   80103073 <lapiceoi>
    break;
80107255:	e9 ef 00 00 00       	jmp    80107349 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010725a:	8b 45 08             	mov    0x8(%ebp),%eax
8010725d:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107260:	8b 45 08             	mov    0x8(%ebp),%eax
80107263:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107267:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010726a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107270:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107273:	0f b6 c0             	movzbl %al,%eax
80107276:	51                   	push   %ecx
80107277:	52                   	push   %edx
80107278:	50                   	push   %eax
80107279:	68 3c 94 10 80       	push   $0x8010943c
8010727e:	e8 43 91 ff ff       	call   801003c6 <cprintf>
80107283:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107286:	e8 e8 bd ff ff       	call   80103073 <lapiceoi>
    break;
8010728b:	e9 b9 00 00 00       	jmp    80107349 <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107290:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107296:	85 c0                	test   %eax,%eax
80107298:	74 11                	je     801072ab <trap+0x122>
8010729a:	8b 45 08             	mov    0x8(%ebp),%eax
8010729d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801072a1:	0f b7 c0             	movzwl %ax,%eax
801072a4:	83 e0 03             	and    $0x3,%eax
801072a7:	85 c0                	test   %eax,%eax
801072a9:	75 40                	jne    801072eb <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801072ab:	e8 4f fd ff ff       	call   80106fff <rcr2>
801072b0:	89 c3                	mov    %eax,%ebx
801072b2:	8b 45 08             	mov    0x8(%ebp),%eax
801072b5:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801072b8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801072be:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801072c1:	0f b6 d0             	movzbl %al,%edx
801072c4:	8b 45 08             	mov    0x8(%ebp),%eax
801072c7:	8b 40 30             	mov    0x30(%eax),%eax
801072ca:	83 ec 0c             	sub    $0xc,%esp
801072cd:	53                   	push   %ebx
801072ce:	51                   	push   %ecx
801072cf:	52                   	push   %edx
801072d0:	50                   	push   %eax
801072d1:	68 60 94 10 80       	push   $0x80109460
801072d6:	e8 eb 90 ff ff       	call   801003c6 <cprintf>
801072db:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801072de:	83 ec 0c             	sub    $0xc,%esp
801072e1:	68 92 94 10 80       	push   $0x80109492
801072e6:	e8 7b 92 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801072eb:	e8 0f fd ff ff       	call   80106fff <rcr2>
801072f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072f3:	8b 45 08             	mov    0x8(%ebp),%eax
801072f6:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801072f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801072ff:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107302:	0f b6 d8             	movzbl %al,%ebx
80107305:	8b 45 08             	mov    0x8(%ebp),%eax
80107308:	8b 48 34             	mov    0x34(%eax),%ecx
8010730b:	8b 45 08             	mov    0x8(%ebp),%eax
8010730e:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107311:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107317:	8d 78 6c             	lea    0x6c(%eax),%edi
8010731a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107320:	8b 40 10             	mov    0x10(%eax),%eax
80107323:	ff 75 e4             	pushl  -0x1c(%ebp)
80107326:	56                   	push   %esi
80107327:	53                   	push   %ebx
80107328:	51                   	push   %ecx
80107329:	52                   	push   %edx
8010732a:	57                   	push   %edi
8010732b:	50                   	push   %eax
8010732c:	68 98 94 10 80       	push   $0x80109498
80107331:	e8 90 90 ff ff       	call   801003c6 <cprintf>
80107336:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107339:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010733f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107346:	eb 01                	jmp    80107349 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107348:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107349:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010734f:	85 c0                	test   %eax,%eax
80107351:	74 24                	je     80107377 <trap+0x1ee>
80107353:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107359:	8b 40 24             	mov    0x24(%eax),%eax
8010735c:	85 c0                	test   %eax,%eax
8010735e:	74 17                	je     80107377 <trap+0x1ee>
80107360:	8b 45 08             	mov    0x8(%ebp),%eax
80107363:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107367:	0f b7 c0             	movzwl %ax,%eax
8010736a:	83 e0 03             	and    $0x3,%eax
8010736d:	83 f8 03             	cmp    $0x3,%eax
80107370:	75 05                	jne    80107377 <trap+0x1ee>
    exit();
80107372:	e8 12 d8 ff ff       	call   80104b89 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107377:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010737d:	85 c0                	test   %eax,%eax
8010737f:	74 1e                	je     8010739f <trap+0x216>
80107381:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107387:	8b 40 0c             	mov    0xc(%eax),%eax
8010738a:	83 f8 04             	cmp    $0x4,%eax
8010738d:	75 10                	jne    8010739f <trap+0x216>
8010738f:	8b 45 08             	mov    0x8(%ebp),%eax
80107392:	8b 40 30             	mov    0x30(%eax),%eax
80107395:	83 f8 20             	cmp    $0x20,%eax
80107398:	75 05                	jne    8010739f <trap+0x216>
    yield();
8010739a:	e8 1b dc ff ff       	call   80104fba <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010739f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073a5:	85 c0                	test   %eax,%eax
801073a7:	74 27                	je     801073d0 <trap+0x247>
801073a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073af:	8b 40 24             	mov    0x24(%eax),%eax
801073b2:	85 c0                	test   %eax,%eax
801073b4:	74 1a                	je     801073d0 <trap+0x247>
801073b6:	8b 45 08             	mov    0x8(%ebp),%eax
801073b9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801073bd:	0f b7 c0             	movzwl %ax,%eax
801073c0:	83 e0 03             	and    $0x3,%eax
801073c3:	83 f8 03             	cmp    $0x3,%eax
801073c6:	75 08                	jne    801073d0 <trap+0x247>
    exit();
801073c8:	e8 bc d7 ff ff       	call   80104b89 <exit>
801073cd:	eb 01                	jmp    801073d0 <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801073cf:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801073d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d3:	5b                   	pop    %ebx
801073d4:	5e                   	pop    %esi
801073d5:	5f                   	pop    %edi
801073d6:	5d                   	pop    %ebp
801073d7:	c3                   	ret    

801073d8 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801073d8:	55                   	push   %ebp
801073d9:	89 e5                	mov    %esp,%ebp
801073db:	83 ec 14             	sub    $0x14,%esp
801073de:	8b 45 08             	mov    0x8(%ebp),%eax
801073e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801073e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801073e9:	89 c2                	mov    %eax,%edx
801073eb:	ec                   	in     (%dx),%al
801073ec:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801073ef:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801073f3:	c9                   	leave  
801073f4:	c3                   	ret    

801073f5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801073f5:	55                   	push   %ebp
801073f6:	89 e5                	mov    %esp,%ebp
801073f8:	83 ec 08             	sub    $0x8,%esp
801073fb:	8b 55 08             	mov    0x8(%ebp),%edx
801073fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80107401:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107405:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107408:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010740c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107410:	ee                   	out    %al,(%dx)
}
80107411:	90                   	nop
80107412:	c9                   	leave  
80107413:	c3                   	ret    

80107414 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107414:	55                   	push   %ebp
80107415:	89 e5                	mov    %esp,%ebp
80107417:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010741a:	6a 00                	push   $0x0
8010741c:	68 fa 03 00 00       	push   $0x3fa
80107421:	e8 cf ff ff ff       	call   801073f5 <outb>
80107426:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107429:	68 80 00 00 00       	push   $0x80
8010742e:	68 fb 03 00 00       	push   $0x3fb
80107433:	e8 bd ff ff ff       	call   801073f5 <outb>
80107438:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010743b:	6a 0c                	push   $0xc
8010743d:	68 f8 03 00 00       	push   $0x3f8
80107442:	e8 ae ff ff ff       	call   801073f5 <outb>
80107447:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
8010744a:	6a 00                	push   $0x0
8010744c:	68 f9 03 00 00       	push   $0x3f9
80107451:	e8 9f ff ff ff       	call   801073f5 <outb>
80107456:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107459:	6a 03                	push   $0x3
8010745b:	68 fb 03 00 00       	push   $0x3fb
80107460:	e8 90 ff ff ff       	call   801073f5 <outb>
80107465:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107468:	6a 00                	push   $0x0
8010746a:	68 fc 03 00 00       	push   $0x3fc
8010746f:	e8 81 ff ff ff       	call   801073f5 <outb>
80107474:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107477:	6a 01                	push   $0x1
80107479:	68 f9 03 00 00       	push   $0x3f9
8010747e:	e8 72 ff ff ff       	call   801073f5 <outb>
80107483:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107486:	68 fd 03 00 00       	push   $0x3fd
8010748b:	e8 48 ff ff ff       	call   801073d8 <inb>
80107490:	83 c4 04             	add    $0x4,%esp
80107493:	3c ff                	cmp    $0xff,%al
80107495:	74 6e                	je     80107505 <uartinit+0xf1>
    return;
  uart = 1;
80107497:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
8010749e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801074a1:	68 fa 03 00 00       	push   $0x3fa
801074a6:	e8 2d ff ff ff       	call   801073d8 <inb>
801074ab:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801074ae:	68 f8 03 00 00       	push   $0x3f8
801074b3:	e8 20 ff ff ff       	call   801073d8 <inb>
801074b8:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801074bb:	83 ec 0c             	sub    $0xc,%esp
801074be:	6a 04                	push   $0x4
801074c0:	e8 b4 ca ff ff       	call   80103f79 <picenable>
801074c5:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801074c8:	83 ec 08             	sub    $0x8,%esp
801074cb:	6a 00                	push   $0x0
801074cd:	6a 04                	push   $0x4
801074cf:	e8 54 b6 ff ff       	call   80102b28 <ioapicenable>
801074d4:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801074d7:	c7 45 f4 5c 95 10 80 	movl   $0x8010955c,-0xc(%ebp)
801074de:	eb 19                	jmp    801074f9 <uartinit+0xe5>
    uartputc(*p);
801074e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e3:	0f b6 00             	movzbl (%eax),%eax
801074e6:	0f be c0             	movsbl %al,%eax
801074e9:	83 ec 0c             	sub    $0xc,%esp
801074ec:	50                   	push   %eax
801074ed:	e8 16 00 00 00       	call   80107508 <uartputc>
801074f2:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801074f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801074f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074fc:	0f b6 00             	movzbl (%eax),%eax
801074ff:	84 c0                	test   %al,%al
80107501:	75 dd                	jne    801074e0 <uartinit+0xcc>
80107503:	eb 01                	jmp    80107506 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107505:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107506:	c9                   	leave  
80107507:	c3                   	ret    

80107508 <uartputc>:

void
uartputc(int c)
{
80107508:	55                   	push   %ebp
80107509:	89 e5                	mov    %esp,%ebp
8010750b:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010750e:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107513:	85 c0                	test   %eax,%eax
80107515:	74 53                	je     8010756a <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107517:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010751e:	eb 11                	jmp    80107531 <uartputc+0x29>
    microdelay(10);
80107520:	83 ec 0c             	sub    $0xc,%esp
80107523:	6a 0a                	push   $0xa
80107525:	e8 64 bb ff ff       	call   8010308e <microdelay>
8010752a:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010752d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107531:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107535:	7f 1a                	jg     80107551 <uartputc+0x49>
80107537:	83 ec 0c             	sub    $0xc,%esp
8010753a:	68 fd 03 00 00       	push   $0x3fd
8010753f:	e8 94 fe ff ff       	call   801073d8 <inb>
80107544:	83 c4 10             	add    $0x10,%esp
80107547:	0f b6 c0             	movzbl %al,%eax
8010754a:	83 e0 20             	and    $0x20,%eax
8010754d:	85 c0                	test   %eax,%eax
8010754f:	74 cf                	je     80107520 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107551:	8b 45 08             	mov    0x8(%ebp),%eax
80107554:	0f b6 c0             	movzbl %al,%eax
80107557:	83 ec 08             	sub    $0x8,%esp
8010755a:	50                   	push   %eax
8010755b:	68 f8 03 00 00       	push   $0x3f8
80107560:	e8 90 fe ff ff       	call   801073f5 <outb>
80107565:	83 c4 10             	add    $0x10,%esp
80107568:	eb 01                	jmp    8010756b <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
8010756a:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
8010756b:	c9                   	leave  
8010756c:	c3                   	ret    

8010756d <uartgetc>:

static int
uartgetc(void)
{
8010756d:	55                   	push   %ebp
8010756e:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107570:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107575:	85 c0                	test   %eax,%eax
80107577:	75 07                	jne    80107580 <uartgetc+0x13>
    return -1;
80107579:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010757e:	eb 2e                	jmp    801075ae <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107580:	68 fd 03 00 00       	push   $0x3fd
80107585:	e8 4e fe ff ff       	call   801073d8 <inb>
8010758a:	83 c4 04             	add    $0x4,%esp
8010758d:	0f b6 c0             	movzbl %al,%eax
80107590:	83 e0 01             	and    $0x1,%eax
80107593:	85 c0                	test   %eax,%eax
80107595:	75 07                	jne    8010759e <uartgetc+0x31>
    return -1;
80107597:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010759c:	eb 10                	jmp    801075ae <uartgetc+0x41>
  return inb(COM1+0);
8010759e:	68 f8 03 00 00       	push   $0x3f8
801075a3:	e8 30 fe ff ff       	call   801073d8 <inb>
801075a8:	83 c4 04             	add    $0x4,%esp
801075ab:	0f b6 c0             	movzbl %al,%eax
}
801075ae:	c9                   	leave  
801075af:	c3                   	ret    

801075b0 <uartintr>:

void
uartintr(void)
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801075b6:	83 ec 0c             	sub    $0xc,%esp
801075b9:	68 6d 75 10 80       	push   $0x8010756d
801075be:	e8 36 92 ff ff       	call   801007f9 <consoleintr>
801075c3:	83 c4 10             	add    $0x10,%esp
}
801075c6:	90                   	nop
801075c7:	c9                   	leave  
801075c8:	c3                   	ret    

801075c9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801075c9:	6a 00                	push   $0x0
  pushl $0
801075cb:	6a 00                	push   $0x0
  jmp alltraps
801075cd:	e9 cc f9 ff ff       	jmp    80106f9e <alltraps>

801075d2 <vector1>:
.globl vector1
vector1:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $1
801075d4:	6a 01                	push   $0x1
  jmp alltraps
801075d6:	e9 c3 f9 ff ff       	jmp    80106f9e <alltraps>

801075db <vector2>:
.globl vector2
vector2:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $2
801075dd:	6a 02                	push   $0x2
  jmp alltraps
801075df:	e9 ba f9 ff ff       	jmp    80106f9e <alltraps>

801075e4 <vector3>:
.globl vector3
vector3:
  pushl $0
801075e4:	6a 00                	push   $0x0
  pushl $3
801075e6:	6a 03                	push   $0x3
  jmp alltraps
801075e8:	e9 b1 f9 ff ff       	jmp    80106f9e <alltraps>

801075ed <vector4>:
.globl vector4
vector4:
  pushl $0
801075ed:	6a 00                	push   $0x0
  pushl $4
801075ef:	6a 04                	push   $0x4
  jmp alltraps
801075f1:	e9 a8 f9 ff ff       	jmp    80106f9e <alltraps>

801075f6 <vector5>:
.globl vector5
vector5:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $5
801075f8:	6a 05                	push   $0x5
  jmp alltraps
801075fa:	e9 9f f9 ff ff       	jmp    80106f9e <alltraps>

801075ff <vector6>:
.globl vector6
vector6:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $6
80107601:	6a 06                	push   $0x6
  jmp alltraps
80107603:	e9 96 f9 ff ff       	jmp    80106f9e <alltraps>

80107608 <vector7>:
.globl vector7
vector7:
  pushl $0
80107608:	6a 00                	push   $0x0
  pushl $7
8010760a:	6a 07                	push   $0x7
  jmp alltraps
8010760c:	e9 8d f9 ff ff       	jmp    80106f9e <alltraps>

80107611 <vector8>:
.globl vector8
vector8:
  pushl $8
80107611:	6a 08                	push   $0x8
  jmp alltraps
80107613:	e9 86 f9 ff ff       	jmp    80106f9e <alltraps>

80107618 <vector9>:
.globl vector9
vector9:
  pushl $0
80107618:	6a 00                	push   $0x0
  pushl $9
8010761a:	6a 09                	push   $0x9
  jmp alltraps
8010761c:	e9 7d f9 ff ff       	jmp    80106f9e <alltraps>

80107621 <vector10>:
.globl vector10
vector10:
  pushl $10
80107621:	6a 0a                	push   $0xa
  jmp alltraps
80107623:	e9 76 f9 ff ff       	jmp    80106f9e <alltraps>

80107628 <vector11>:
.globl vector11
vector11:
  pushl $11
80107628:	6a 0b                	push   $0xb
  jmp alltraps
8010762a:	e9 6f f9 ff ff       	jmp    80106f9e <alltraps>

8010762f <vector12>:
.globl vector12
vector12:
  pushl $12
8010762f:	6a 0c                	push   $0xc
  jmp alltraps
80107631:	e9 68 f9 ff ff       	jmp    80106f9e <alltraps>

80107636 <vector13>:
.globl vector13
vector13:
  pushl $13
80107636:	6a 0d                	push   $0xd
  jmp alltraps
80107638:	e9 61 f9 ff ff       	jmp    80106f9e <alltraps>

8010763d <vector14>:
.globl vector14
vector14:
  pushl $14
8010763d:	6a 0e                	push   $0xe
  jmp alltraps
8010763f:	e9 5a f9 ff ff       	jmp    80106f9e <alltraps>

80107644 <vector15>:
.globl vector15
vector15:
  pushl $0
80107644:	6a 00                	push   $0x0
  pushl $15
80107646:	6a 0f                	push   $0xf
  jmp alltraps
80107648:	e9 51 f9 ff ff       	jmp    80106f9e <alltraps>

8010764d <vector16>:
.globl vector16
vector16:
  pushl $0
8010764d:	6a 00                	push   $0x0
  pushl $16
8010764f:	6a 10                	push   $0x10
  jmp alltraps
80107651:	e9 48 f9 ff ff       	jmp    80106f9e <alltraps>

80107656 <vector17>:
.globl vector17
vector17:
  pushl $17
80107656:	6a 11                	push   $0x11
  jmp alltraps
80107658:	e9 41 f9 ff ff       	jmp    80106f9e <alltraps>

8010765d <vector18>:
.globl vector18
vector18:
  pushl $0
8010765d:	6a 00                	push   $0x0
  pushl $18
8010765f:	6a 12                	push   $0x12
  jmp alltraps
80107661:	e9 38 f9 ff ff       	jmp    80106f9e <alltraps>

80107666 <vector19>:
.globl vector19
vector19:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $19
80107668:	6a 13                	push   $0x13
  jmp alltraps
8010766a:	e9 2f f9 ff ff       	jmp    80106f9e <alltraps>

8010766f <vector20>:
.globl vector20
vector20:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $20
80107671:	6a 14                	push   $0x14
  jmp alltraps
80107673:	e9 26 f9 ff ff       	jmp    80106f9e <alltraps>

80107678 <vector21>:
.globl vector21
vector21:
  pushl $0
80107678:	6a 00                	push   $0x0
  pushl $21
8010767a:	6a 15                	push   $0x15
  jmp alltraps
8010767c:	e9 1d f9 ff ff       	jmp    80106f9e <alltraps>

80107681 <vector22>:
.globl vector22
vector22:
  pushl $0
80107681:	6a 00                	push   $0x0
  pushl $22
80107683:	6a 16                	push   $0x16
  jmp alltraps
80107685:	e9 14 f9 ff ff       	jmp    80106f9e <alltraps>

8010768a <vector23>:
.globl vector23
vector23:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $23
8010768c:	6a 17                	push   $0x17
  jmp alltraps
8010768e:	e9 0b f9 ff ff       	jmp    80106f9e <alltraps>

80107693 <vector24>:
.globl vector24
vector24:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $24
80107695:	6a 18                	push   $0x18
  jmp alltraps
80107697:	e9 02 f9 ff ff       	jmp    80106f9e <alltraps>

8010769c <vector25>:
.globl vector25
vector25:
  pushl $0
8010769c:	6a 00                	push   $0x0
  pushl $25
8010769e:	6a 19                	push   $0x19
  jmp alltraps
801076a0:	e9 f9 f8 ff ff       	jmp    80106f9e <alltraps>

801076a5 <vector26>:
.globl vector26
vector26:
  pushl $0
801076a5:	6a 00                	push   $0x0
  pushl $26
801076a7:	6a 1a                	push   $0x1a
  jmp alltraps
801076a9:	e9 f0 f8 ff ff       	jmp    80106f9e <alltraps>

801076ae <vector27>:
.globl vector27
vector27:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $27
801076b0:	6a 1b                	push   $0x1b
  jmp alltraps
801076b2:	e9 e7 f8 ff ff       	jmp    80106f9e <alltraps>

801076b7 <vector28>:
.globl vector28
vector28:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $28
801076b9:	6a 1c                	push   $0x1c
  jmp alltraps
801076bb:	e9 de f8 ff ff       	jmp    80106f9e <alltraps>

801076c0 <vector29>:
.globl vector29
vector29:
  pushl $0
801076c0:	6a 00                	push   $0x0
  pushl $29
801076c2:	6a 1d                	push   $0x1d
  jmp alltraps
801076c4:	e9 d5 f8 ff ff       	jmp    80106f9e <alltraps>

801076c9 <vector30>:
.globl vector30
vector30:
  pushl $0
801076c9:	6a 00                	push   $0x0
  pushl $30
801076cb:	6a 1e                	push   $0x1e
  jmp alltraps
801076cd:	e9 cc f8 ff ff       	jmp    80106f9e <alltraps>

801076d2 <vector31>:
.globl vector31
vector31:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $31
801076d4:	6a 1f                	push   $0x1f
  jmp alltraps
801076d6:	e9 c3 f8 ff ff       	jmp    80106f9e <alltraps>

801076db <vector32>:
.globl vector32
vector32:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $32
801076dd:	6a 20                	push   $0x20
  jmp alltraps
801076df:	e9 ba f8 ff ff       	jmp    80106f9e <alltraps>

801076e4 <vector33>:
.globl vector33
vector33:
  pushl $0
801076e4:	6a 00                	push   $0x0
  pushl $33
801076e6:	6a 21                	push   $0x21
  jmp alltraps
801076e8:	e9 b1 f8 ff ff       	jmp    80106f9e <alltraps>

801076ed <vector34>:
.globl vector34
vector34:
  pushl $0
801076ed:	6a 00                	push   $0x0
  pushl $34
801076ef:	6a 22                	push   $0x22
  jmp alltraps
801076f1:	e9 a8 f8 ff ff       	jmp    80106f9e <alltraps>

801076f6 <vector35>:
.globl vector35
vector35:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $35
801076f8:	6a 23                	push   $0x23
  jmp alltraps
801076fa:	e9 9f f8 ff ff       	jmp    80106f9e <alltraps>

801076ff <vector36>:
.globl vector36
vector36:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $36
80107701:	6a 24                	push   $0x24
  jmp alltraps
80107703:	e9 96 f8 ff ff       	jmp    80106f9e <alltraps>

80107708 <vector37>:
.globl vector37
vector37:
  pushl $0
80107708:	6a 00                	push   $0x0
  pushl $37
8010770a:	6a 25                	push   $0x25
  jmp alltraps
8010770c:	e9 8d f8 ff ff       	jmp    80106f9e <alltraps>

80107711 <vector38>:
.globl vector38
vector38:
  pushl $0
80107711:	6a 00                	push   $0x0
  pushl $38
80107713:	6a 26                	push   $0x26
  jmp alltraps
80107715:	e9 84 f8 ff ff       	jmp    80106f9e <alltraps>

8010771a <vector39>:
.globl vector39
vector39:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $39
8010771c:	6a 27                	push   $0x27
  jmp alltraps
8010771e:	e9 7b f8 ff ff       	jmp    80106f9e <alltraps>

80107723 <vector40>:
.globl vector40
vector40:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $40
80107725:	6a 28                	push   $0x28
  jmp alltraps
80107727:	e9 72 f8 ff ff       	jmp    80106f9e <alltraps>

8010772c <vector41>:
.globl vector41
vector41:
  pushl $0
8010772c:	6a 00                	push   $0x0
  pushl $41
8010772e:	6a 29                	push   $0x29
  jmp alltraps
80107730:	e9 69 f8 ff ff       	jmp    80106f9e <alltraps>

80107735 <vector42>:
.globl vector42
vector42:
  pushl $0
80107735:	6a 00                	push   $0x0
  pushl $42
80107737:	6a 2a                	push   $0x2a
  jmp alltraps
80107739:	e9 60 f8 ff ff       	jmp    80106f9e <alltraps>

8010773e <vector43>:
.globl vector43
vector43:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $43
80107740:	6a 2b                	push   $0x2b
  jmp alltraps
80107742:	e9 57 f8 ff ff       	jmp    80106f9e <alltraps>

80107747 <vector44>:
.globl vector44
vector44:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $44
80107749:	6a 2c                	push   $0x2c
  jmp alltraps
8010774b:	e9 4e f8 ff ff       	jmp    80106f9e <alltraps>

80107750 <vector45>:
.globl vector45
vector45:
  pushl $0
80107750:	6a 00                	push   $0x0
  pushl $45
80107752:	6a 2d                	push   $0x2d
  jmp alltraps
80107754:	e9 45 f8 ff ff       	jmp    80106f9e <alltraps>

80107759 <vector46>:
.globl vector46
vector46:
  pushl $0
80107759:	6a 00                	push   $0x0
  pushl $46
8010775b:	6a 2e                	push   $0x2e
  jmp alltraps
8010775d:	e9 3c f8 ff ff       	jmp    80106f9e <alltraps>

80107762 <vector47>:
.globl vector47
vector47:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $47
80107764:	6a 2f                	push   $0x2f
  jmp alltraps
80107766:	e9 33 f8 ff ff       	jmp    80106f9e <alltraps>

8010776b <vector48>:
.globl vector48
vector48:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $48
8010776d:	6a 30                	push   $0x30
  jmp alltraps
8010776f:	e9 2a f8 ff ff       	jmp    80106f9e <alltraps>

80107774 <vector49>:
.globl vector49
vector49:
  pushl $0
80107774:	6a 00                	push   $0x0
  pushl $49
80107776:	6a 31                	push   $0x31
  jmp alltraps
80107778:	e9 21 f8 ff ff       	jmp    80106f9e <alltraps>

8010777d <vector50>:
.globl vector50
vector50:
  pushl $0
8010777d:	6a 00                	push   $0x0
  pushl $50
8010777f:	6a 32                	push   $0x32
  jmp alltraps
80107781:	e9 18 f8 ff ff       	jmp    80106f9e <alltraps>

80107786 <vector51>:
.globl vector51
vector51:
  pushl $0
80107786:	6a 00                	push   $0x0
  pushl $51
80107788:	6a 33                	push   $0x33
  jmp alltraps
8010778a:	e9 0f f8 ff ff       	jmp    80106f9e <alltraps>

8010778f <vector52>:
.globl vector52
vector52:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $52
80107791:	6a 34                	push   $0x34
  jmp alltraps
80107793:	e9 06 f8 ff ff       	jmp    80106f9e <alltraps>

80107798 <vector53>:
.globl vector53
vector53:
  pushl $0
80107798:	6a 00                	push   $0x0
  pushl $53
8010779a:	6a 35                	push   $0x35
  jmp alltraps
8010779c:	e9 fd f7 ff ff       	jmp    80106f9e <alltraps>

801077a1 <vector54>:
.globl vector54
vector54:
  pushl $0
801077a1:	6a 00                	push   $0x0
  pushl $54
801077a3:	6a 36                	push   $0x36
  jmp alltraps
801077a5:	e9 f4 f7 ff ff       	jmp    80106f9e <alltraps>

801077aa <vector55>:
.globl vector55
vector55:
  pushl $0
801077aa:	6a 00                	push   $0x0
  pushl $55
801077ac:	6a 37                	push   $0x37
  jmp alltraps
801077ae:	e9 eb f7 ff ff       	jmp    80106f9e <alltraps>

801077b3 <vector56>:
.globl vector56
vector56:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $56
801077b5:	6a 38                	push   $0x38
  jmp alltraps
801077b7:	e9 e2 f7 ff ff       	jmp    80106f9e <alltraps>

801077bc <vector57>:
.globl vector57
vector57:
  pushl $0
801077bc:	6a 00                	push   $0x0
  pushl $57
801077be:	6a 39                	push   $0x39
  jmp alltraps
801077c0:	e9 d9 f7 ff ff       	jmp    80106f9e <alltraps>

801077c5 <vector58>:
.globl vector58
vector58:
  pushl $0
801077c5:	6a 00                	push   $0x0
  pushl $58
801077c7:	6a 3a                	push   $0x3a
  jmp alltraps
801077c9:	e9 d0 f7 ff ff       	jmp    80106f9e <alltraps>

801077ce <vector59>:
.globl vector59
vector59:
  pushl $0
801077ce:	6a 00                	push   $0x0
  pushl $59
801077d0:	6a 3b                	push   $0x3b
  jmp alltraps
801077d2:	e9 c7 f7 ff ff       	jmp    80106f9e <alltraps>

801077d7 <vector60>:
.globl vector60
vector60:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $60
801077d9:	6a 3c                	push   $0x3c
  jmp alltraps
801077db:	e9 be f7 ff ff       	jmp    80106f9e <alltraps>

801077e0 <vector61>:
.globl vector61
vector61:
  pushl $0
801077e0:	6a 00                	push   $0x0
  pushl $61
801077e2:	6a 3d                	push   $0x3d
  jmp alltraps
801077e4:	e9 b5 f7 ff ff       	jmp    80106f9e <alltraps>

801077e9 <vector62>:
.globl vector62
vector62:
  pushl $0
801077e9:	6a 00                	push   $0x0
  pushl $62
801077eb:	6a 3e                	push   $0x3e
  jmp alltraps
801077ed:	e9 ac f7 ff ff       	jmp    80106f9e <alltraps>

801077f2 <vector63>:
.globl vector63
vector63:
  pushl $0
801077f2:	6a 00                	push   $0x0
  pushl $63
801077f4:	6a 3f                	push   $0x3f
  jmp alltraps
801077f6:	e9 a3 f7 ff ff       	jmp    80106f9e <alltraps>

801077fb <vector64>:
.globl vector64
vector64:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $64
801077fd:	6a 40                	push   $0x40
  jmp alltraps
801077ff:	e9 9a f7 ff ff       	jmp    80106f9e <alltraps>

80107804 <vector65>:
.globl vector65
vector65:
  pushl $0
80107804:	6a 00                	push   $0x0
  pushl $65
80107806:	6a 41                	push   $0x41
  jmp alltraps
80107808:	e9 91 f7 ff ff       	jmp    80106f9e <alltraps>

8010780d <vector66>:
.globl vector66
vector66:
  pushl $0
8010780d:	6a 00                	push   $0x0
  pushl $66
8010780f:	6a 42                	push   $0x42
  jmp alltraps
80107811:	e9 88 f7 ff ff       	jmp    80106f9e <alltraps>

80107816 <vector67>:
.globl vector67
vector67:
  pushl $0
80107816:	6a 00                	push   $0x0
  pushl $67
80107818:	6a 43                	push   $0x43
  jmp alltraps
8010781a:	e9 7f f7 ff ff       	jmp    80106f9e <alltraps>

8010781f <vector68>:
.globl vector68
vector68:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $68
80107821:	6a 44                	push   $0x44
  jmp alltraps
80107823:	e9 76 f7 ff ff       	jmp    80106f9e <alltraps>

80107828 <vector69>:
.globl vector69
vector69:
  pushl $0
80107828:	6a 00                	push   $0x0
  pushl $69
8010782a:	6a 45                	push   $0x45
  jmp alltraps
8010782c:	e9 6d f7 ff ff       	jmp    80106f9e <alltraps>

80107831 <vector70>:
.globl vector70
vector70:
  pushl $0
80107831:	6a 00                	push   $0x0
  pushl $70
80107833:	6a 46                	push   $0x46
  jmp alltraps
80107835:	e9 64 f7 ff ff       	jmp    80106f9e <alltraps>

8010783a <vector71>:
.globl vector71
vector71:
  pushl $0
8010783a:	6a 00                	push   $0x0
  pushl $71
8010783c:	6a 47                	push   $0x47
  jmp alltraps
8010783e:	e9 5b f7 ff ff       	jmp    80106f9e <alltraps>

80107843 <vector72>:
.globl vector72
vector72:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $72
80107845:	6a 48                	push   $0x48
  jmp alltraps
80107847:	e9 52 f7 ff ff       	jmp    80106f9e <alltraps>

8010784c <vector73>:
.globl vector73
vector73:
  pushl $0
8010784c:	6a 00                	push   $0x0
  pushl $73
8010784e:	6a 49                	push   $0x49
  jmp alltraps
80107850:	e9 49 f7 ff ff       	jmp    80106f9e <alltraps>

80107855 <vector74>:
.globl vector74
vector74:
  pushl $0
80107855:	6a 00                	push   $0x0
  pushl $74
80107857:	6a 4a                	push   $0x4a
  jmp alltraps
80107859:	e9 40 f7 ff ff       	jmp    80106f9e <alltraps>

8010785e <vector75>:
.globl vector75
vector75:
  pushl $0
8010785e:	6a 00                	push   $0x0
  pushl $75
80107860:	6a 4b                	push   $0x4b
  jmp alltraps
80107862:	e9 37 f7 ff ff       	jmp    80106f9e <alltraps>

80107867 <vector76>:
.globl vector76
vector76:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $76
80107869:	6a 4c                	push   $0x4c
  jmp alltraps
8010786b:	e9 2e f7 ff ff       	jmp    80106f9e <alltraps>

80107870 <vector77>:
.globl vector77
vector77:
  pushl $0
80107870:	6a 00                	push   $0x0
  pushl $77
80107872:	6a 4d                	push   $0x4d
  jmp alltraps
80107874:	e9 25 f7 ff ff       	jmp    80106f9e <alltraps>

80107879 <vector78>:
.globl vector78
vector78:
  pushl $0
80107879:	6a 00                	push   $0x0
  pushl $78
8010787b:	6a 4e                	push   $0x4e
  jmp alltraps
8010787d:	e9 1c f7 ff ff       	jmp    80106f9e <alltraps>

80107882 <vector79>:
.globl vector79
vector79:
  pushl $0
80107882:	6a 00                	push   $0x0
  pushl $79
80107884:	6a 4f                	push   $0x4f
  jmp alltraps
80107886:	e9 13 f7 ff ff       	jmp    80106f9e <alltraps>

8010788b <vector80>:
.globl vector80
vector80:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $80
8010788d:	6a 50                	push   $0x50
  jmp alltraps
8010788f:	e9 0a f7 ff ff       	jmp    80106f9e <alltraps>

80107894 <vector81>:
.globl vector81
vector81:
  pushl $0
80107894:	6a 00                	push   $0x0
  pushl $81
80107896:	6a 51                	push   $0x51
  jmp alltraps
80107898:	e9 01 f7 ff ff       	jmp    80106f9e <alltraps>

8010789d <vector82>:
.globl vector82
vector82:
  pushl $0
8010789d:	6a 00                	push   $0x0
  pushl $82
8010789f:	6a 52                	push   $0x52
  jmp alltraps
801078a1:	e9 f8 f6 ff ff       	jmp    80106f9e <alltraps>

801078a6 <vector83>:
.globl vector83
vector83:
  pushl $0
801078a6:	6a 00                	push   $0x0
  pushl $83
801078a8:	6a 53                	push   $0x53
  jmp alltraps
801078aa:	e9 ef f6 ff ff       	jmp    80106f9e <alltraps>

801078af <vector84>:
.globl vector84
vector84:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $84
801078b1:	6a 54                	push   $0x54
  jmp alltraps
801078b3:	e9 e6 f6 ff ff       	jmp    80106f9e <alltraps>

801078b8 <vector85>:
.globl vector85
vector85:
  pushl $0
801078b8:	6a 00                	push   $0x0
  pushl $85
801078ba:	6a 55                	push   $0x55
  jmp alltraps
801078bc:	e9 dd f6 ff ff       	jmp    80106f9e <alltraps>

801078c1 <vector86>:
.globl vector86
vector86:
  pushl $0
801078c1:	6a 00                	push   $0x0
  pushl $86
801078c3:	6a 56                	push   $0x56
  jmp alltraps
801078c5:	e9 d4 f6 ff ff       	jmp    80106f9e <alltraps>

801078ca <vector87>:
.globl vector87
vector87:
  pushl $0
801078ca:	6a 00                	push   $0x0
  pushl $87
801078cc:	6a 57                	push   $0x57
  jmp alltraps
801078ce:	e9 cb f6 ff ff       	jmp    80106f9e <alltraps>

801078d3 <vector88>:
.globl vector88
vector88:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $88
801078d5:	6a 58                	push   $0x58
  jmp alltraps
801078d7:	e9 c2 f6 ff ff       	jmp    80106f9e <alltraps>

801078dc <vector89>:
.globl vector89
vector89:
  pushl $0
801078dc:	6a 00                	push   $0x0
  pushl $89
801078de:	6a 59                	push   $0x59
  jmp alltraps
801078e0:	e9 b9 f6 ff ff       	jmp    80106f9e <alltraps>

801078e5 <vector90>:
.globl vector90
vector90:
  pushl $0
801078e5:	6a 00                	push   $0x0
  pushl $90
801078e7:	6a 5a                	push   $0x5a
  jmp alltraps
801078e9:	e9 b0 f6 ff ff       	jmp    80106f9e <alltraps>

801078ee <vector91>:
.globl vector91
vector91:
  pushl $0
801078ee:	6a 00                	push   $0x0
  pushl $91
801078f0:	6a 5b                	push   $0x5b
  jmp alltraps
801078f2:	e9 a7 f6 ff ff       	jmp    80106f9e <alltraps>

801078f7 <vector92>:
.globl vector92
vector92:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $92
801078f9:	6a 5c                	push   $0x5c
  jmp alltraps
801078fb:	e9 9e f6 ff ff       	jmp    80106f9e <alltraps>

80107900 <vector93>:
.globl vector93
vector93:
  pushl $0
80107900:	6a 00                	push   $0x0
  pushl $93
80107902:	6a 5d                	push   $0x5d
  jmp alltraps
80107904:	e9 95 f6 ff ff       	jmp    80106f9e <alltraps>

80107909 <vector94>:
.globl vector94
vector94:
  pushl $0
80107909:	6a 00                	push   $0x0
  pushl $94
8010790b:	6a 5e                	push   $0x5e
  jmp alltraps
8010790d:	e9 8c f6 ff ff       	jmp    80106f9e <alltraps>

80107912 <vector95>:
.globl vector95
vector95:
  pushl $0
80107912:	6a 00                	push   $0x0
  pushl $95
80107914:	6a 5f                	push   $0x5f
  jmp alltraps
80107916:	e9 83 f6 ff ff       	jmp    80106f9e <alltraps>

8010791b <vector96>:
.globl vector96
vector96:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $96
8010791d:	6a 60                	push   $0x60
  jmp alltraps
8010791f:	e9 7a f6 ff ff       	jmp    80106f9e <alltraps>

80107924 <vector97>:
.globl vector97
vector97:
  pushl $0
80107924:	6a 00                	push   $0x0
  pushl $97
80107926:	6a 61                	push   $0x61
  jmp alltraps
80107928:	e9 71 f6 ff ff       	jmp    80106f9e <alltraps>

8010792d <vector98>:
.globl vector98
vector98:
  pushl $0
8010792d:	6a 00                	push   $0x0
  pushl $98
8010792f:	6a 62                	push   $0x62
  jmp alltraps
80107931:	e9 68 f6 ff ff       	jmp    80106f9e <alltraps>

80107936 <vector99>:
.globl vector99
vector99:
  pushl $0
80107936:	6a 00                	push   $0x0
  pushl $99
80107938:	6a 63                	push   $0x63
  jmp alltraps
8010793a:	e9 5f f6 ff ff       	jmp    80106f9e <alltraps>

8010793f <vector100>:
.globl vector100
vector100:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $100
80107941:	6a 64                	push   $0x64
  jmp alltraps
80107943:	e9 56 f6 ff ff       	jmp    80106f9e <alltraps>

80107948 <vector101>:
.globl vector101
vector101:
  pushl $0
80107948:	6a 00                	push   $0x0
  pushl $101
8010794a:	6a 65                	push   $0x65
  jmp alltraps
8010794c:	e9 4d f6 ff ff       	jmp    80106f9e <alltraps>

80107951 <vector102>:
.globl vector102
vector102:
  pushl $0
80107951:	6a 00                	push   $0x0
  pushl $102
80107953:	6a 66                	push   $0x66
  jmp alltraps
80107955:	e9 44 f6 ff ff       	jmp    80106f9e <alltraps>

8010795a <vector103>:
.globl vector103
vector103:
  pushl $0
8010795a:	6a 00                	push   $0x0
  pushl $103
8010795c:	6a 67                	push   $0x67
  jmp alltraps
8010795e:	e9 3b f6 ff ff       	jmp    80106f9e <alltraps>

80107963 <vector104>:
.globl vector104
vector104:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $104
80107965:	6a 68                	push   $0x68
  jmp alltraps
80107967:	e9 32 f6 ff ff       	jmp    80106f9e <alltraps>

8010796c <vector105>:
.globl vector105
vector105:
  pushl $0
8010796c:	6a 00                	push   $0x0
  pushl $105
8010796e:	6a 69                	push   $0x69
  jmp alltraps
80107970:	e9 29 f6 ff ff       	jmp    80106f9e <alltraps>

80107975 <vector106>:
.globl vector106
vector106:
  pushl $0
80107975:	6a 00                	push   $0x0
  pushl $106
80107977:	6a 6a                	push   $0x6a
  jmp alltraps
80107979:	e9 20 f6 ff ff       	jmp    80106f9e <alltraps>

8010797e <vector107>:
.globl vector107
vector107:
  pushl $0
8010797e:	6a 00                	push   $0x0
  pushl $107
80107980:	6a 6b                	push   $0x6b
  jmp alltraps
80107982:	e9 17 f6 ff ff       	jmp    80106f9e <alltraps>

80107987 <vector108>:
.globl vector108
vector108:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $108
80107989:	6a 6c                	push   $0x6c
  jmp alltraps
8010798b:	e9 0e f6 ff ff       	jmp    80106f9e <alltraps>

80107990 <vector109>:
.globl vector109
vector109:
  pushl $0
80107990:	6a 00                	push   $0x0
  pushl $109
80107992:	6a 6d                	push   $0x6d
  jmp alltraps
80107994:	e9 05 f6 ff ff       	jmp    80106f9e <alltraps>

80107999 <vector110>:
.globl vector110
vector110:
  pushl $0
80107999:	6a 00                	push   $0x0
  pushl $110
8010799b:	6a 6e                	push   $0x6e
  jmp alltraps
8010799d:	e9 fc f5 ff ff       	jmp    80106f9e <alltraps>

801079a2 <vector111>:
.globl vector111
vector111:
  pushl $0
801079a2:	6a 00                	push   $0x0
  pushl $111
801079a4:	6a 6f                	push   $0x6f
  jmp alltraps
801079a6:	e9 f3 f5 ff ff       	jmp    80106f9e <alltraps>

801079ab <vector112>:
.globl vector112
vector112:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $112
801079ad:	6a 70                	push   $0x70
  jmp alltraps
801079af:	e9 ea f5 ff ff       	jmp    80106f9e <alltraps>

801079b4 <vector113>:
.globl vector113
vector113:
  pushl $0
801079b4:	6a 00                	push   $0x0
  pushl $113
801079b6:	6a 71                	push   $0x71
  jmp alltraps
801079b8:	e9 e1 f5 ff ff       	jmp    80106f9e <alltraps>

801079bd <vector114>:
.globl vector114
vector114:
  pushl $0
801079bd:	6a 00                	push   $0x0
  pushl $114
801079bf:	6a 72                	push   $0x72
  jmp alltraps
801079c1:	e9 d8 f5 ff ff       	jmp    80106f9e <alltraps>

801079c6 <vector115>:
.globl vector115
vector115:
  pushl $0
801079c6:	6a 00                	push   $0x0
  pushl $115
801079c8:	6a 73                	push   $0x73
  jmp alltraps
801079ca:	e9 cf f5 ff ff       	jmp    80106f9e <alltraps>

801079cf <vector116>:
.globl vector116
vector116:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $116
801079d1:	6a 74                	push   $0x74
  jmp alltraps
801079d3:	e9 c6 f5 ff ff       	jmp    80106f9e <alltraps>

801079d8 <vector117>:
.globl vector117
vector117:
  pushl $0
801079d8:	6a 00                	push   $0x0
  pushl $117
801079da:	6a 75                	push   $0x75
  jmp alltraps
801079dc:	e9 bd f5 ff ff       	jmp    80106f9e <alltraps>

801079e1 <vector118>:
.globl vector118
vector118:
  pushl $0
801079e1:	6a 00                	push   $0x0
  pushl $118
801079e3:	6a 76                	push   $0x76
  jmp alltraps
801079e5:	e9 b4 f5 ff ff       	jmp    80106f9e <alltraps>

801079ea <vector119>:
.globl vector119
vector119:
  pushl $0
801079ea:	6a 00                	push   $0x0
  pushl $119
801079ec:	6a 77                	push   $0x77
  jmp alltraps
801079ee:	e9 ab f5 ff ff       	jmp    80106f9e <alltraps>

801079f3 <vector120>:
.globl vector120
vector120:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $120
801079f5:	6a 78                	push   $0x78
  jmp alltraps
801079f7:	e9 a2 f5 ff ff       	jmp    80106f9e <alltraps>

801079fc <vector121>:
.globl vector121
vector121:
  pushl $0
801079fc:	6a 00                	push   $0x0
  pushl $121
801079fe:	6a 79                	push   $0x79
  jmp alltraps
80107a00:	e9 99 f5 ff ff       	jmp    80106f9e <alltraps>

80107a05 <vector122>:
.globl vector122
vector122:
  pushl $0
80107a05:	6a 00                	push   $0x0
  pushl $122
80107a07:	6a 7a                	push   $0x7a
  jmp alltraps
80107a09:	e9 90 f5 ff ff       	jmp    80106f9e <alltraps>

80107a0e <vector123>:
.globl vector123
vector123:
  pushl $0
80107a0e:	6a 00                	push   $0x0
  pushl $123
80107a10:	6a 7b                	push   $0x7b
  jmp alltraps
80107a12:	e9 87 f5 ff ff       	jmp    80106f9e <alltraps>

80107a17 <vector124>:
.globl vector124
vector124:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $124
80107a19:	6a 7c                	push   $0x7c
  jmp alltraps
80107a1b:	e9 7e f5 ff ff       	jmp    80106f9e <alltraps>

80107a20 <vector125>:
.globl vector125
vector125:
  pushl $0
80107a20:	6a 00                	push   $0x0
  pushl $125
80107a22:	6a 7d                	push   $0x7d
  jmp alltraps
80107a24:	e9 75 f5 ff ff       	jmp    80106f9e <alltraps>

80107a29 <vector126>:
.globl vector126
vector126:
  pushl $0
80107a29:	6a 00                	push   $0x0
  pushl $126
80107a2b:	6a 7e                	push   $0x7e
  jmp alltraps
80107a2d:	e9 6c f5 ff ff       	jmp    80106f9e <alltraps>

80107a32 <vector127>:
.globl vector127
vector127:
  pushl $0
80107a32:	6a 00                	push   $0x0
  pushl $127
80107a34:	6a 7f                	push   $0x7f
  jmp alltraps
80107a36:	e9 63 f5 ff ff       	jmp    80106f9e <alltraps>

80107a3b <vector128>:
.globl vector128
vector128:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $128
80107a3d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107a42:	e9 57 f5 ff ff       	jmp    80106f9e <alltraps>

80107a47 <vector129>:
.globl vector129
vector129:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $129
80107a49:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107a4e:	e9 4b f5 ff ff       	jmp    80106f9e <alltraps>

80107a53 <vector130>:
.globl vector130
vector130:
  pushl $0
80107a53:	6a 00                	push   $0x0
  pushl $130
80107a55:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107a5a:	e9 3f f5 ff ff       	jmp    80106f9e <alltraps>

80107a5f <vector131>:
.globl vector131
vector131:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $131
80107a61:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107a66:	e9 33 f5 ff ff       	jmp    80106f9e <alltraps>

80107a6b <vector132>:
.globl vector132
vector132:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $132
80107a6d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107a72:	e9 27 f5 ff ff       	jmp    80106f9e <alltraps>

80107a77 <vector133>:
.globl vector133
vector133:
  pushl $0
80107a77:	6a 00                	push   $0x0
  pushl $133
80107a79:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107a7e:	e9 1b f5 ff ff       	jmp    80106f9e <alltraps>

80107a83 <vector134>:
.globl vector134
vector134:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $134
80107a85:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107a8a:	e9 0f f5 ff ff       	jmp    80106f9e <alltraps>

80107a8f <vector135>:
.globl vector135
vector135:
  pushl $0
80107a8f:	6a 00                	push   $0x0
  pushl $135
80107a91:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107a96:	e9 03 f5 ff ff       	jmp    80106f9e <alltraps>

80107a9b <vector136>:
.globl vector136
vector136:
  pushl $0
80107a9b:	6a 00                	push   $0x0
  pushl $136
80107a9d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107aa2:	e9 f7 f4 ff ff       	jmp    80106f9e <alltraps>

80107aa7 <vector137>:
.globl vector137
vector137:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $137
80107aa9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107aae:	e9 eb f4 ff ff       	jmp    80106f9e <alltraps>

80107ab3 <vector138>:
.globl vector138
vector138:
  pushl $0
80107ab3:	6a 00                	push   $0x0
  pushl $138
80107ab5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107aba:	e9 df f4 ff ff       	jmp    80106f9e <alltraps>

80107abf <vector139>:
.globl vector139
vector139:
  pushl $0
80107abf:	6a 00                	push   $0x0
  pushl $139
80107ac1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107ac6:	e9 d3 f4 ff ff       	jmp    80106f9e <alltraps>

80107acb <vector140>:
.globl vector140
vector140:
  pushl $0
80107acb:	6a 00                	push   $0x0
  pushl $140
80107acd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107ad2:	e9 c7 f4 ff ff       	jmp    80106f9e <alltraps>

80107ad7 <vector141>:
.globl vector141
vector141:
  pushl $0
80107ad7:	6a 00                	push   $0x0
  pushl $141
80107ad9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107ade:	e9 bb f4 ff ff       	jmp    80106f9e <alltraps>

80107ae3 <vector142>:
.globl vector142
vector142:
  pushl $0
80107ae3:	6a 00                	push   $0x0
  pushl $142
80107ae5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107aea:	e9 af f4 ff ff       	jmp    80106f9e <alltraps>

80107aef <vector143>:
.globl vector143
vector143:
  pushl $0
80107aef:	6a 00                	push   $0x0
  pushl $143
80107af1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107af6:	e9 a3 f4 ff ff       	jmp    80106f9e <alltraps>

80107afb <vector144>:
.globl vector144
vector144:
  pushl $0
80107afb:	6a 00                	push   $0x0
  pushl $144
80107afd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107b02:	e9 97 f4 ff ff       	jmp    80106f9e <alltraps>

80107b07 <vector145>:
.globl vector145
vector145:
  pushl $0
80107b07:	6a 00                	push   $0x0
  pushl $145
80107b09:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107b0e:	e9 8b f4 ff ff       	jmp    80106f9e <alltraps>

80107b13 <vector146>:
.globl vector146
vector146:
  pushl $0
80107b13:	6a 00                	push   $0x0
  pushl $146
80107b15:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107b1a:	e9 7f f4 ff ff       	jmp    80106f9e <alltraps>

80107b1f <vector147>:
.globl vector147
vector147:
  pushl $0
80107b1f:	6a 00                	push   $0x0
  pushl $147
80107b21:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107b26:	e9 73 f4 ff ff       	jmp    80106f9e <alltraps>

80107b2b <vector148>:
.globl vector148
vector148:
  pushl $0
80107b2b:	6a 00                	push   $0x0
  pushl $148
80107b2d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107b32:	e9 67 f4 ff ff       	jmp    80106f9e <alltraps>

80107b37 <vector149>:
.globl vector149
vector149:
  pushl $0
80107b37:	6a 00                	push   $0x0
  pushl $149
80107b39:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107b3e:	e9 5b f4 ff ff       	jmp    80106f9e <alltraps>

80107b43 <vector150>:
.globl vector150
vector150:
  pushl $0
80107b43:	6a 00                	push   $0x0
  pushl $150
80107b45:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107b4a:	e9 4f f4 ff ff       	jmp    80106f9e <alltraps>

80107b4f <vector151>:
.globl vector151
vector151:
  pushl $0
80107b4f:	6a 00                	push   $0x0
  pushl $151
80107b51:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107b56:	e9 43 f4 ff ff       	jmp    80106f9e <alltraps>

80107b5b <vector152>:
.globl vector152
vector152:
  pushl $0
80107b5b:	6a 00                	push   $0x0
  pushl $152
80107b5d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107b62:	e9 37 f4 ff ff       	jmp    80106f9e <alltraps>

80107b67 <vector153>:
.globl vector153
vector153:
  pushl $0
80107b67:	6a 00                	push   $0x0
  pushl $153
80107b69:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107b6e:	e9 2b f4 ff ff       	jmp    80106f9e <alltraps>

80107b73 <vector154>:
.globl vector154
vector154:
  pushl $0
80107b73:	6a 00                	push   $0x0
  pushl $154
80107b75:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107b7a:	e9 1f f4 ff ff       	jmp    80106f9e <alltraps>

80107b7f <vector155>:
.globl vector155
vector155:
  pushl $0
80107b7f:	6a 00                	push   $0x0
  pushl $155
80107b81:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107b86:	e9 13 f4 ff ff       	jmp    80106f9e <alltraps>

80107b8b <vector156>:
.globl vector156
vector156:
  pushl $0
80107b8b:	6a 00                	push   $0x0
  pushl $156
80107b8d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107b92:	e9 07 f4 ff ff       	jmp    80106f9e <alltraps>

80107b97 <vector157>:
.globl vector157
vector157:
  pushl $0
80107b97:	6a 00                	push   $0x0
  pushl $157
80107b99:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107b9e:	e9 fb f3 ff ff       	jmp    80106f9e <alltraps>

80107ba3 <vector158>:
.globl vector158
vector158:
  pushl $0
80107ba3:	6a 00                	push   $0x0
  pushl $158
80107ba5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107baa:	e9 ef f3 ff ff       	jmp    80106f9e <alltraps>

80107baf <vector159>:
.globl vector159
vector159:
  pushl $0
80107baf:	6a 00                	push   $0x0
  pushl $159
80107bb1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107bb6:	e9 e3 f3 ff ff       	jmp    80106f9e <alltraps>

80107bbb <vector160>:
.globl vector160
vector160:
  pushl $0
80107bbb:	6a 00                	push   $0x0
  pushl $160
80107bbd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107bc2:	e9 d7 f3 ff ff       	jmp    80106f9e <alltraps>

80107bc7 <vector161>:
.globl vector161
vector161:
  pushl $0
80107bc7:	6a 00                	push   $0x0
  pushl $161
80107bc9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107bce:	e9 cb f3 ff ff       	jmp    80106f9e <alltraps>

80107bd3 <vector162>:
.globl vector162
vector162:
  pushl $0
80107bd3:	6a 00                	push   $0x0
  pushl $162
80107bd5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107bda:	e9 bf f3 ff ff       	jmp    80106f9e <alltraps>

80107bdf <vector163>:
.globl vector163
vector163:
  pushl $0
80107bdf:	6a 00                	push   $0x0
  pushl $163
80107be1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107be6:	e9 b3 f3 ff ff       	jmp    80106f9e <alltraps>

80107beb <vector164>:
.globl vector164
vector164:
  pushl $0
80107beb:	6a 00                	push   $0x0
  pushl $164
80107bed:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107bf2:	e9 a7 f3 ff ff       	jmp    80106f9e <alltraps>

80107bf7 <vector165>:
.globl vector165
vector165:
  pushl $0
80107bf7:	6a 00                	push   $0x0
  pushl $165
80107bf9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107bfe:	e9 9b f3 ff ff       	jmp    80106f9e <alltraps>

80107c03 <vector166>:
.globl vector166
vector166:
  pushl $0
80107c03:	6a 00                	push   $0x0
  pushl $166
80107c05:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107c0a:	e9 8f f3 ff ff       	jmp    80106f9e <alltraps>

80107c0f <vector167>:
.globl vector167
vector167:
  pushl $0
80107c0f:	6a 00                	push   $0x0
  pushl $167
80107c11:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107c16:	e9 83 f3 ff ff       	jmp    80106f9e <alltraps>

80107c1b <vector168>:
.globl vector168
vector168:
  pushl $0
80107c1b:	6a 00                	push   $0x0
  pushl $168
80107c1d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107c22:	e9 77 f3 ff ff       	jmp    80106f9e <alltraps>

80107c27 <vector169>:
.globl vector169
vector169:
  pushl $0
80107c27:	6a 00                	push   $0x0
  pushl $169
80107c29:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107c2e:	e9 6b f3 ff ff       	jmp    80106f9e <alltraps>

80107c33 <vector170>:
.globl vector170
vector170:
  pushl $0
80107c33:	6a 00                	push   $0x0
  pushl $170
80107c35:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107c3a:	e9 5f f3 ff ff       	jmp    80106f9e <alltraps>

80107c3f <vector171>:
.globl vector171
vector171:
  pushl $0
80107c3f:	6a 00                	push   $0x0
  pushl $171
80107c41:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107c46:	e9 53 f3 ff ff       	jmp    80106f9e <alltraps>

80107c4b <vector172>:
.globl vector172
vector172:
  pushl $0
80107c4b:	6a 00                	push   $0x0
  pushl $172
80107c4d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107c52:	e9 47 f3 ff ff       	jmp    80106f9e <alltraps>

80107c57 <vector173>:
.globl vector173
vector173:
  pushl $0
80107c57:	6a 00                	push   $0x0
  pushl $173
80107c59:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107c5e:	e9 3b f3 ff ff       	jmp    80106f9e <alltraps>

80107c63 <vector174>:
.globl vector174
vector174:
  pushl $0
80107c63:	6a 00                	push   $0x0
  pushl $174
80107c65:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107c6a:	e9 2f f3 ff ff       	jmp    80106f9e <alltraps>

80107c6f <vector175>:
.globl vector175
vector175:
  pushl $0
80107c6f:	6a 00                	push   $0x0
  pushl $175
80107c71:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107c76:	e9 23 f3 ff ff       	jmp    80106f9e <alltraps>

80107c7b <vector176>:
.globl vector176
vector176:
  pushl $0
80107c7b:	6a 00                	push   $0x0
  pushl $176
80107c7d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107c82:	e9 17 f3 ff ff       	jmp    80106f9e <alltraps>

80107c87 <vector177>:
.globl vector177
vector177:
  pushl $0
80107c87:	6a 00                	push   $0x0
  pushl $177
80107c89:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107c8e:	e9 0b f3 ff ff       	jmp    80106f9e <alltraps>

80107c93 <vector178>:
.globl vector178
vector178:
  pushl $0
80107c93:	6a 00                	push   $0x0
  pushl $178
80107c95:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107c9a:	e9 ff f2 ff ff       	jmp    80106f9e <alltraps>

80107c9f <vector179>:
.globl vector179
vector179:
  pushl $0
80107c9f:	6a 00                	push   $0x0
  pushl $179
80107ca1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107ca6:	e9 f3 f2 ff ff       	jmp    80106f9e <alltraps>

80107cab <vector180>:
.globl vector180
vector180:
  pushl $0
80107cab:	6a 00                	push   $0x0
  pushl $180
80107cad:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107cb2:	e9 e7 f2 ff ff       	jmp    80106f9e <alltraps>

80107cb7 <vector181>:
.globl vector181
vector181:
  pushl $0
80107cb7:	6a 00                	push   $0x0
  pushl $181
80107cb9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107cbe:	e9 db f2 ff ff       	jmp    80106f9e <alltraps>

80107cc3 <vector182>:
.globl vector182
vector182:
  pushl $0
80107cc3:	6a 00                	push   $0x0
  pushl $182
80107cc5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107cca:	e9 cf f2 ff ff       	jmp    80106f9e <alltraps>

80107ccf <vector183>:
.globl vector183
vector183:
  pushl $0
80107ccf:	6a 00                	push   $0x0
  pushl $183
80107cd1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107cd6:	e9 c3 f2 ff ff       	jmp    80106f9e <alltraps>

80107cdb <vector184>:
.globl vector184
vector184:
  pushl $0
80107cdb:	6a 00                	push   $0x0
  pushl $184
80107cdd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107ce2:	e9 b7 f2 ff ff       	jmp    80106f9e <alltraps>

80107ce7 <vector185>:
.globl vector185
vector185:
  pushl $0
80107ce7:	6a 00                	push   $0x0
  pushl $185
80107ce9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107cee:	e9 ab f2 ff ff       	jmp    80106f9e <alltraps>

80107cf3 <vector186>:
.globl vector186
vector186:
  pushl $0
80107cf3:	6a 00                	push   $0x0
  pushl $186
80107cf5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107cfa:	e9 9f f2 ff ff       	jmp    80106f9e <alltraps>

80107cff <vector187>:
.globl vector187
vector187:
  pushl $0
80107cff:	6a 00                	push   $0x0
  pushl $187
80107d01:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107d06:	e9 93 f2 ff ff       	jmp    80106f9e <alltraps>

80107d0b <vector188>:
.globl vector188
vector188:
  pushl $0
80107d0b:	6a 00                	push   $0x0
  pushl $188
80107d0d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107d12:	e9 87 f2 ff ff       	jmp    80106f9e <alltraps>

80107d17 <vector189>:
.globl vector189
vector189:
  pushl $0
80107d17:	6a 00                	push   $0x0
  pushl $189
80107d19:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107d1e:	e9 7b f2 ff ff       	jmp    80106f9e <alltraps>

80107d23 <vector190>:
.globl vector190
vector190:
  pushl $0
80107d23:	6a 00                	push   $0x0
  pushl $190
80107d25:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107d2a:	e9 6f f2 ff ff       	jmp    80106f9e <alltraps>

80107d2f <vector191>:
.globl vector191
vector191:
  pushl $0
80107d2f:	6a 00                	push   $0x0
  pushl $191
80107d31:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107d36:	e9 63 f2 ff ff       	jmp    80106f9e <alltraps>

80107d3b <vector192>:
.globl vector192
vector192:
  pushl $0
80107d3b:	6a 00                	push   $0x0
  pushl $192
80107d3d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107d42:	e9 57 f2 ff ff       	jmp    80106f9e <alltraps>

80107d47 <vector193>:
.globl vector193
vector193:
  pushl $0
80107d47:	6a 00                	push   $0x0
  pushl $193
80107d49:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107d4e:	e9 4b f2 ff ff       	jmp    80106f9e <alltraps>

80107d53 <vector194>:
.globl vector194
vector194:
  pushl $0
80107d53:	6a 00                	push   $0x0
  pushl $194
80107d55:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107d5a:	e9 3f f2 ff ff       	jmp    80106f9e <alltraps>

80107d5f <vector195>:
.globl vector195
vector195:
  pushl $0
80107d5f:	6a 00                	push   $0x0
  pushl $195
80107d61:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107d66:	e9 33 f2 ff ff       	jmp    80106f9e <alltraps>

80107d6b <vector196>:
.globl vector196
vector196:
  pushl $0
80107d6b:	6a 00                	push   $0x0
  pushl $196
80107d6d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107d72:	e9 27 f2 ff ff       	jmp    80106f9e <alltraps>

80107d77 <vector197>:
.globl vector197
vector197:
  pushl $0
80107d77:	6a 00                	push   $0x0
  pushl $197
80107d79:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107d7e:	e9 1b f2 ff ff       	jmp    80106f9e <alltraps>

80107d83 <vector198>:
.globl vector198
vector198:
  pushl $0
80107d83:	6a 00                	push   $0x0
  pushl $198
80107d85:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107d8a:	e9 0f f2 ff ff       	jmp    80106f9e <alltraps>

80107d8f <vector199>:
.globl vector199
vector199:
  pushl $0
80107d8f:	6a 00                	push   $0x0
  pushl $199
80107d91:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107d96:	e9 03 f2 ff ff       	jmp    80106f9e <alltraps>

80107d9b <vector200>:
.globl vector200
vector200:
  pushl $0
80107d9b:	6a 00                	push   $0x0
  pushl $200
80107d9d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107da2:	e9 f7 f1 ff ff       	jmp    80106f9e <alltraps>

80107da7 <vector201>:
.globl vector201
vector201:
  pushl $0
80107da7:	6a 00                	push   $0x0
  pushl $201
80107da9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107dae:	e9 eb f1 ff ff       	jmp    80106f9e <alltraps>

80107db3 <vector202>:
.globl vector202
vector202:
  pushl $0
80107db3:	6a 00                	push   $0x0
  pushl $202
80107db5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107dba:	e9 df f1 ff ff       	jmp    80106f9e <alltraps>

80107dbf <vector203>:
.globl vector203
vector203:
  pushl $0
80107dbf:	6a 00                	push   $0x0
  pushl $203
80107dc1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107dc6:	e9 d3 f1 ff ff       	jmp    80106f9e <alltraps>

80107dcb <vector204>:
.globl vector204
vector204:
  pushl $0
80107dcb:	6a 00                	push   $0x0
  pushl $204
80107dcd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107dd2:	e9 c7 f1 ff ff       	jmp    80106f9e <alltraps>

80107dd7 <vector205>:
.globl vector205
vector205:
  pushl $0
80107dd7:	6a 00                	push   $0x0
  pushl $205
80107dd9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107dde:	e9 bb f1 ff ff       	jmp    80106f9e <alltraps>

80107de3 <vector206>:
.globl vector206
vector206:
  pushl $0
80107de3:	6a 00                	push   $0x0
  pushl $206
80107de5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107dea:	e9 af f1 ff ff       	jmp    80106f9e <alltraps>

80107def <vector207>:
.globl vector207
vector207:
  pushl $0
80107def:	6a 00                	push   $0x0
  pushl $207
80107df1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107df6:	e9 a3 f1 ff ff       	jmp    80106f9e <alltraps>

80107dfb <vector208>:
.globl vector208
vector208:
  pushl $0
80107dfb:	6a 00                	push   $0x0
  pushl $208
80107dfd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107e02:	e9 97 f1 ff ff       	jmp    80106f9e <alltraps>

80107e07 <vector209>:
.globl vector209
vector209:
  pushl $0
80107e07:	6a 00                	push   $0x0
  pushl $209
80107e09:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107e0e:	e9 8b f1 ff ff       	jmp    80106f9e <alltraps>

80107e13 <vector210>:
.globl vector210
vector210:
  pushl $0
80107e13:	6a 00                	push   $0x0
  pushl $210
80107e15:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107e1a:	e9 7f f1 ff ff       	jmp    80106f9e <alltraps>

80107e1f <vector211>:
.globl vector211
vector211:
  pushl $0
80107e1f:	6a 00                	push   $0x0
  pushl $211
80107e21:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107e26:	e9 73 f1 ff ff       	jmp    80106f9e <alltraps>

80107e2b <vector212>:
.globl vector212
vector212:
  pushl $0
80107e2b:	6a 00                	push   $0x0
  pushl $212
80107e2d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107e32:	e9 67 f1 ff ff       	jmp    80106f9e <alltraps>

80107e37 <vector213>:
.globl vector213
vector213:
  pushl $0
80107e37:	6a 00                	push   $0x0
  pushl $213
80107e39:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107e3e:	e9 5b f1 ff ff       	jmp    80106f9e <alltraps>

80107e43 <vector214>:
.globl vector214
vector214:
  pushl $0
80107e43:	6a 00                	push   $0x0
  pushl $214
80107e45:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107e4a:	e9 4f f1 ff ff       	jmp    80106f9e <alltraps>

80107e4f <vector215>:
.globl vector215
vector215:
  pushl $0
80107e4f:	6a 00                	push   $0x0
  pushl $215
80107e51:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107e56:	e9 43 f1 ff ff       	jmp    80106f9e <alltraps>

80107e5b <vector216>:
.globl vector216
vector216:
  pushl $0
80107e5b:	6a 00                	push   $0x0
  pushl $216
80107e5d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107e62:	e9 37 f1 ff ff       	jmp    80106f9e <alltraps>

80107e67 <vector217>:
.globl vector217
vector217:
  pushl $0
80107e67:	6a 00                	push   $0x0
  pushl $217
80107e69:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107e6e:	e9 2b f1 ff ff       	jmp    80106f9e <alltraps>

80107e73 <vector218>:
.globl vector218
vector218:
  pushl $0
80107e73:	6a 00                	push   $0x0
  pushl $218
80107e75:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107e7a:	e9 1f f1 ff ff       	jmp    80106f9e <alltraps>

80107e7f <vector219>:
.globl vector219
vector219:
  pushl $0
80107e7f:	6a 00                	push   $0x0
  pushl $219
80107e81:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107e86:	e9 13 f1 ff ff       	jmp    80106f9e <alltraps>

80107e8b <vector220>:
.globl vector220
vector220:
  pushl $0
80107e8b:	6a 00                	push   $0x0
  pushl $220
80107e8d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107e92:	e9 07 f1 ff ff       	jmp    80106f9e <alltraps>

80107e97 <vector221>:
.globl vector221
vector221:
  pushl $0
80107e97:	6a 00                	push   $0x0
  pushl $221
80107e99:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107e9e:	e9 fb f0 ff ff       	jmp    80106f9e <alltraps>

80107ea3 <vector222>:
.globl vector222
vector222:
  pushl $0
80107ea3:	6a 00                	push   $0x0
  pushl $222
80107ea5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107eaa:	e9 ef f0 ff ff       	jmp    80106f9e <alltraps>

80107eaf <vector223>:
.globl vector223
vector223:
  pushl $0
80107eaf:	6a 00                	push   $0x0
  pushl $223
80107eb1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107eb6:	e9 e3 f0 ff ff       	jmp    80106f9e <alltraps>

80107ebb <vector224>:
.globl vector224
vector224:
  pushl $0
80107ebb:	6a 00                	push   $0x0
  pushl $224
80107ebd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107ec2:	e9 d7 f0 ff ff       	jmp    80106f9e <alltraps>

80107ec7 <vector225>:
.globl vector225
vector225:
  pushl $0
80107ec7:	6a 00                	push   $0x0
  pushl $225
80107ec9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107ece:	e9 cb f0 ff ff       	jmp    80106f9e <alltraps>

80107ed3 <vector226>:
.globl vector226
vector226:
  pushl $0
80107ed3:	6a 00                	push   $0x0
  pushl $226
80107ed5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107eda:	e9 bf f0 ff ff       	jmp    80106f9e <alltraps>

80107edf <vector227>:
.globl vector227
vector227:
  pushl $0
80107edf:	6a 00                	push   $0x0
  pushl $227
80107ee1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107ee6:	e9 b3 f0 ff ff       	jmp    80106f9e <alltraps>

80107eeb <vector228>:
.globl vector228
vector228:
  pushl $0
80107eeb:	6a 00                	push   $0x0
  pushl $228
80107eed:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107ef2:	e9 a7 f0 ff ff       	jmp    80106f9e <alltraps>

80107ef7 <vector229>:
.globl vector229
vector229:
  pushl $0
80107ef7:	6a 00                	push   $0x0
  pushl $229
80107ef9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107efe:	e9 9b f0 ff ff       	jmp    80106f9e <alltraps>

80107f03 <vector230>:
.globl vector230
vector230:
  pushl $0
80107f03:	6a 00                	push   $0x0
  pushl $230
80107f05:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107f0a:	e9 8f f0 ff ff       	jmp    80106f9e <alltraps>

80107f0f <vector231>:
.globl vector231
vector231:
  pushl $0
80107f0f:	6a 00                	push   $0x0
  pushl $231
80107f11:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107f16:	e9 83 f0 ff ff       	jmp    80106f9e <alltraps>

80107f1b <vector232>:
.globl vector232
vector232:
  pushl $0
80107f1b:	6a 00                	push   $0x0
  pushl $232
80107f1d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107f22:	e9 77 f0 ff ff       	jmp    80106f9e <alltraps>

80107f27 <vector233>:
.globl vector233
vector233:
  pushl $0
80107f27:	6a 00                	push   $0x0
  pushl $233
80107f29:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107f2e:	e9 6b f0 ff ff       	jmp    80106f9e <alltraps>

80107f33 <vector234>:
.globl vector234
vector234:
  pushl $0
80107f33:	6a 00                	push   $0x0
  pushl $234
80107f35:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107f3a:	e9 5f f0 ff ff       	jmp    80106f9e <alltraps>

80107f3f <vector235>:
.globl vector235
vector235:
  pushl $0
80107f3f:	6a 00                	push   $0x0
  pushl $235
80107f41:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107f46:	e9 53 f0 ff ff       	jmp    80106f9e <alltraps>

80107f4b <vector236>:
.globl vector236
vector236:
  pushl $0
80107f4b:	6a 00                	push   $0x0
  pushl $236
80107f4d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107f52:	e9 47 f0 ff ff       	jmp    80106f9e <alltraps>

80107f57 <vector237>:
.globl vector237
vector237:
  pushl $0
80107f57:	6a 00                	push   $0x0
  pushl $237
80107f59:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107f5e:	e9 3b f0 ff ff       	jmp    80106f9e <alltraps>

80107f63 <vector238>:
.globl vector238
vector238:
  pushl $0
80107f63:	6a 00                	push   $0x0
  pushl $238
80107f65:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107f6a:	e9 2f f0 ff ff       	jmp    80106f9e <alltraps>

80107f6f <vector239>:
.globl vector239
vector239:
  pushl $0
80107f6f:	6a 00                	push   $0x0
  pushl $239
80107f71:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107f76:	e9 23 f0 ff ff       	jmp    80106f9e <alltraps>

80107f7b <vector240>:
.globl vector240
vector240:
  pushl $0
80107f7b:	6a 00                	push   $0x0
  pushl $240
80107f7d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107f82:	e9 17 f0 ff ff       	jmp    80106f9e <alltraps>

80107f87 <vector241>:
.globl vector241
vector241:
  pushl $0
80107f87:	6a 00                	push   $0x0
  pushl $241
80107f89:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107f8e:	e9 0b f0 ff ff       	jmp    80106f9e <alltraps>

80107f93 <vector242>:
.globl vector242
vector242:
  pushl $0
80107f93:	6a 00                	push   $0x0
  pushl $242
80107f95:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107f9a:	e9 ff ef ff ff       	jmp    80106f9e <alltraps>

80107f9f <vector243>:
.globl vector243
vector243:
  pushl $0
80107f9f:	6a 00                	push   $0x0
  pushl $243
80107fa1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107fa6:	e9 f3 ef ff ff       	jmp    80106f9e <alltraps>

80107fab <vector244>:
.globl vector244
vector244:
  pushl $0
80107fab:	6a 00                	push   $0x0
  pushl $244
80107fad:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107fb2:	e9 e7 ef ff ff       	jmp    80106f9e <alltraps>

80107fb7 <vector245>:
.globl vector245
vector245:
  pushl $0
80107fb7:	6a 00                	push   $0x0
  pushl $245
80107fb9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107fbe:	e9 db ef ff ff       	jmp    80106f9e <alltraps>

80107fc3 <vector246>:
.globl vector246
vector246:
  pushl $0
80107fc3:	6a 00                	push   $0x0
  pushl $246
80107fc5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107fca:	e9 cf ef ff ff       	jmp    80106f9e <alltraps>

80107fcf <vector247>:
.globl vector247
vector247:
  pushl $0
80107fcf:	6a 00                	push   $0x0
  pushl $247
80107fd1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107fd6:	e9 c3 ef ff ff       	jmp    80106f9e <alltraps>

80107fdb <vector248>:
.globl vector248
vector248:
  pushl $0
80107fdb:	6a 00                	push   $0x0
  pushl $248
80107fdd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107fe2:	e9 b7 ef ff ff       	jmp    80106f9e <alltraps>

80107fe7 <vector249>:
.globl vector249
vector249:
  pushl $0
80107fe7:	6a 00                	push   $0x0
  pushl $249
80107fe9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107fee:	e9 ab ef ff ff       	jmp    80106f9e <alltraps>

80107ff3 <vector250>:
.globl vector250
vector250:
  pushl $0
80107ff3:	6a 00                	push   $0x0
  pushl $250
80107ff5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107ffa:	e9 9f ef ff ff       	jmp    80106f9e <alltraps>

80107fff <vector251>:
.globl vector251
vector251:
  pushl $0
80107fff:	6a 00                	push   $0x0
  pushl $251
80108001:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108006:	e9 93 ef ff ff       	jmp    80106f9e <alltraps>

8010800b <vector252>:
.globl vector252
vector252:
  pushl $0
8010800b:	6a 00                	push   $0x0
  pushl $252
8010800d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108012:	e9 87 ef ff ff       	jmp    80106f9e <alltraps>

80108017 <vector253>:
.globl vector253
vector253:
  pushl $0
80108017:	6a 00                	push   $0x0
  pushl $253
80108019:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010801e:	e9 7b ef ff ff       	jmp    80106f9e <alltraps>

80108023 <vector254>:
.globl vector254
vector254:
  pushl $0
80108023:	6a 00                	push   $0x0
  pushl $254
80108025:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010802a:	e9 6f ef ff ff       	jmp    80106f9e <alltraps>

8010802f <vector255>:
.globl vector255
vector255:
  pushl $0
8010802f:	6a 00                	push   $0x0
  pushl $255
80108031:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108036:	e9 63 ef ff ff       	jmp    80106f9e <alltraps>

8010803b <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010803b:	55                   	push   %ebp
8010803c:	89 e5                	mov    %esp,%ebp
8010803e:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108041:	8b 45 0c             	mov    0xc(%ebp),%eax
80108044:	83 e8 01             	sub    $0x1,%eax
80108047:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010804b:	8b 45 08             	mov    0x8(%ebp),%eax
8010804e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108052:	8b 45 08             	mov    0x8(%ebp),%eax
80108055:	c1 e8 10             	shr    $0x10,%eax
80108058:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010805c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010805f:	0f 01 10             	lgdtl  (%eax)
}
80108062:	90                   	nop
80108063:	c9                   	leave  
80108064:	c3                   	ret    

80108065 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108065:	55                   	push   %ebp
80108066:	89 e5                	mov    %esp,%ebp
80108068:	83 ec 04             	sub    $0x4,%esp
8010806b:	8b 45 08             	mov    0x8(%ebp),%eax
8010806e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108072:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108076:	0f 00 d8             	ltr    %ax
}
80108079:	90                   	nop
8010807a:	c9                   	leave  
8010807b:	c3                   	ret    

8010807c <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010807c:	55                   	push   %ebp
8010807d:	89 e5                	mov    %esp,%ebp
8010807f:	83 ec 04             	sub    $0x4,%esp
80108082:	8b 45 08             	mov    0x8(%ebp),%eax
80108085:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108089:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010808d:	8e e8                	mov    %eax,%gs
}
8010808f:	90                   	nop
80108090:	c9                   	leave  
80108091:	c3                   	ret    

80108092 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108092:	55                   	push   %ebp
80108093:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108095:	8b 45 08             	mov    0x8(%ebp),%eax
80108098:	0f 22 d8             	mov    %eax,%cr3
}
8010809b:	90                   	nop
8010809c:	5d                   	pop    %ebp
8010809d:	c3                   	ret    

8010809e <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010809e:	55                   	push   %ebp
8010809f:	89 e5                	mov    %esp,%ebp
801080a1:	8b 45 08             	mov    0x8(%ebp),%eax
801080a4:	05 00 00 00 80       	add    $0x80000000,%eax
801080a9:	5d                   	pop    %ebp
801080aa:	c3                   	ret    

801080ab <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801080ab:	55                   	push   %ebp
801080ac:	89 e5                	mov    %esp,%ebp
801080ae:	8b 45 08             	mov    0x8(%ebp),%eax
801080b1:	05 00 00 00 80       	add    $0x80000000,%eax
801080b6:	5d                   	pop    %ebp
801080b7:	c3                   	ret    

801080b8 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801080b8:	55                   	push   %ebp
801080b9:	89 e5                	mov    %esp,%ebp
801080bb:	53                   	push   %ebx
801080bc:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801080bf:	e8 56 af ff ff       	call   8010301a <cpunum>
801080c4:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801080ca:	05 80 33 11 80       	add    $0x80113380,%eax
801080cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801080d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d5:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801080db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080de:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801080e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e7:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801080eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ee:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801080f2:	83 e2 f0             	and    $0xfffffff0,%edx
801080f5:	83 ca 0a             	or     $0xa,%edx
801080f8:	88 50 7d             	mov    %dl,0x7d(%eax)
801080fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fe:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108102:	83 ca 10             	or     $0x10,%edx
80108105:	88 50 7d             	mov    %dl,0x7d(%eax)
80108108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010810f:	83 e2 9f             	and    $0xffffff9f,%edx
80108112:	88 50 7d             	mov    %dl,0x7d(%eax)
80108115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108118:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010811c:	83 ca 80             	or     $0xffffff80,%edx
8010811f:	88 50 7d             	mov    %dl,0x7d(%eax)
80108122:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108125:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108129:	83 ca 0f             	or     $0xf,%edx
8010812c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010812f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108132:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108136:	83 e2 ef             	and    $0xffffffef,%edx
80108139:	88 50 7e             	mov    %dl,0x7e(%eax)
8010813c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108143:	83 e2 df             	and    $0xffffffdf,%edx
80108146:	88 50 7e             	mov    %dl,0x7e(%eax)
80108149:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108150:	83 ca 40             	or     $0x40,%edx
80108153:	88 50 7e             	mov    %dl,0x7e(%eax)
80108156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108159:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010815d:	83 ca 80             	or     $0xffffff80,%edx
80108160:	88 50 7e             	mov    %dl,0x7e(%eax)
80108163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108166:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010816a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816d:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108174:	ff ff 
80108176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108179:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108180:	00 00 
80108182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108185:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010818c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108196:	83 e2 f0             	and    $0xfffffff0,%edx
80108199:	83 ca 02             	or     $0x2,%edx
8010819c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801081a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801081ac:	83 ca 10             	or     $0x10,%edx
801081af:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801081b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801081bf:	83 e2 9f             	and    $0xffffff9f,%edx
801081c2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801081c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cb:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801081d2:	83 ca 80             	or     $0xffffff80,%edx
801081d5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801081db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081de:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801081e5:	83 ca 0f             	or     $0xf,%edx
801081e8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801081ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801081f8:	83 e2 ef             	and    $0xffffffef,%edx
801081fb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108201:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108204:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010820b:	83 e2 df             	and    $0xffffffdf,%edx
8010820e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108217:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010821e:	83 ca 40             	or     $0x40,%edx
80108221:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108231:	83 ca 80             	or     $0xffffff80,%edx
80108234:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010823a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823d:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108247:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010824e:	ff ff 
80108250:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108253:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010825a:	00 00 
8010825c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825f:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108266:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108269:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108270:	83 e2 f0             	and    $0xfffffff0,%edx
80108273:	83 ca 0a             	or     $0xa,%edx
80108276:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010827c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108286:	83 ca 10             	or     $0x10,%edx
80108289:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010828f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108292:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108299:	83 ca 60             	or     $0x60,%edx
8010829c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801082a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801082ac:	83 ca 80             	or     $0xffffff80,%edx
801082af:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801082b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801082bf:	83 ca 0f             	or     $0xf,%edx
801082c2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801082c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082cb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801082d2:	83 e2 ef             	and    $0xffffffef,%edx
801082d5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801082db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082de:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801082e5:	83 e2 df             	and    $0xffffffdf,%edx
801082e8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801082ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801082f8:	83 ca 40             	or     $0x40,%edx
801082fb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108304:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010830b:	83 ca 80             	or     $0xffffff80,%edx
8010830e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108317:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010831e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108321:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108328:	ff ff 
8010832a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832d:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108334:	00 00 
80108336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108339:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108343:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010834a:	83 e2 f0             	and    $0xfffffff0,%edx
8010834d:	83 ca 02             	or     $0x2,%edx
80108350:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108359:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108360:	83 ca 10             	or     $0x10,%edx
80108363:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108369:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108373:	83 ca 60             	or     $0x60,%edx
80108376:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010837c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108386:	83 ca 80             	or     $0xffffff80,%edx
80108389:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010838f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108392:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108399:	83 ca 0f             	or     $0xf,%edx
8010839c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801083a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801083ac:	83 e2 ef             	and    $0xffffffef,%edx
801083af:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801083b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801083bf:	83 e2 df             	and    $0xffffffdf,%edx
801083c2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801083c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083cb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801083d2:	83 ca 40             	or     $0x40,%edx
801083d5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801083db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083de:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801083e5:	83 ca 80             	or     $0xffffff80,%edx
801083e8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801083ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f1:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801083f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083fb:	05 b4 00 00 00       	add    $0xb4,%eax
80108400:	89 c3                	mov    %eax,%ebx
80108402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108405:	05 b4 00 00 00       	add    $0xb4,%eax
8010840a:	c1 e8 10             	shr    $0x10,%eax
8010840d:	89 c2                	mov    %eax,%edx
8010840f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108412:	05 b4 00 00 00       	add    $0xb4,%eax
80108417:	c1 e8 18             	shr    $0x18,%eax
8010841a:	89 c1                	mov    %eax,%ecx
8010841c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010841f:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108426:	00 00 
80108428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010842b:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108435:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
8010843b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108445:	83 e2 f0             	and    $0xfffffff0,%edx
80108448:	83 ca 02             	or     $0x2,%edx
8010844b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108451:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108454:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010845b:	83 ca 10             	or     $0x10,%edx
8010845e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108464:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108467:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010846e:	83 e2 9f             	and    $0xffffff9f,%edx
80108471:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108477:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010847a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108481:	83 ca 80             	or     $0xffffff80,%edx
80108484:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010848a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010848d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108494:	83 e2 f0             	and    $0xfffffff0,%edx
80108497:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010849d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801084a7:	83 e2 ef             	and    $0xffffffef,%edx
801084aa:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801084b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801084ba:	83 e2 df             	and    $0xffffffdf,%edx
801084bd:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801084c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801084cd:	83 ca 40             	or     $0x40,%edx
801084d0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801084d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801084e0:	83 ca 80             	or     $0xffffff80,%edx
801084e3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801084e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ec:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801084f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084f5:	83 c0 70             	add    $0x70,%eax
801084f8:	83 ec 08             	sub    $0x8,%esp
801084fb:	6a 38                	push   $0x38
801084fd:	50                   	push   %eax
801084fe:	e8 38 fb ff ff       	call   8010803b <lgdt>
80108503:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108506:	83 ec 0c             	sub    $0xc,%esp
80108509:	6a 18                	push   $0x18
8010850b:	e8 6c fb ff ff       	call   8010807c <loadgs>
80108510:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108516:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010851c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108523:	00 00 00 00 
}
80108527:	90                   	nop
80108528:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010852b:	c9                   	leave  
8010852c:	c3                   	ret    

8010852d <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010852d:	55                   	push   %ebp
8010852e:	89 e5                	mov    %esp,%ebp
80108530:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108533:	8b 45 0c             	mov    0xc(%ebp),%eax
80108536:	c1 e8 16             	shr    $0x16,%eax
80108539:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108540:	8b 45 08             	mov    0x8(%ebp),%eax
80108543:	01 d0                	add    %edx,%eax
80108545:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108548:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010854b:	8b 00                	mov    (%eax),%eax
8010854d:	83 e0 01             	and    $0x1,%eax
80108550:	85 c0                	test   %eax,%eax
80108552:	74 18                	je     8010856c <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108554:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108557:	8b 00                	mov    (%eax),%eax
80108559:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010855e:	50                   	push   %eax
8010855f:	e8 47 fb ff ff       	call   801080ab <p2v>
80108564:	83 c4 04             	add    $0x4,%esp
80108567:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010856a:	eb 48                	jmp    801085b4 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010856c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108570:	74 0e                	je     80108580 <walkpgdir+0x53>
80108572:	e8 3d a7 ff ff       	call   80102cb4 <kalloc>
80108577:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010857a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010857e:	75 07                	jne    80108587 <walkpgdir+0x5a>
      return 0;
80108580:	b8 00 00 00 00       	mov    $0x0,%eax
80108585:	eb 44                	jmp    801085cb <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108587:	83 ec 04             	sub    $0x4,%esp
8010858a:	68 00 10 00 00       	push   $0x1000
8010858f:	6a 00                	push   $0x0
80108591:	ff 75 f4             	pushl  -0xc(%ebp)
80108594:	e8 ed d4 ff ff       	call   80105a86 <memset>
80108599:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010859c:	83 ec 0c             	sub    $0xc,%esp
8010859f:	ff 75 f4             	pushl  -0xc(%ebp)
801085a2:	e8 f7 fa ff ff       	call   8010809e <v2p>
801085a7:	83 c4 10             	add    $0x10,%esp
801085aa:	83 c8 07             	or     $0x7,%eax
801085ad:	89 c2                	mov    %eax,%edx
801085af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085b2:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801085b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801085b7:	c1 e8 0c             	shr    $0xc,%eax
801085ba:	25 ff 03 00 00       	and    $0x3ff,%eax
801085bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c9:	01 d0                	add    %edx,%eax
}
801085cb:	c9                   	leave  
801085cc:	c3                   	ret    

801085cd <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801085cd:	55                   	push   %ebp
801085ce:	89 e5                	mov    %esp,%ebp
801085d0:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801085d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801085d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801085de:	8b 55 0c             	mov    0xc(%ebp),%edx
801085e1:	8b 45 10             	mov    0x10(%ebp),%eax
801085e4:	01 d0                	add    %edx,%eax
801085e6:	83 e8 01             	sub    $0x1,%eax
801085e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801085f1:	83 ec 04             	sub    $0x4,%esp
801085f4:	6a 01                	push   $0x1
801085f6:	ff 75 f4             	pushl  -0xc(%ebp)
801085f9:	ff 75 08             	pushl  0x8(%ebp)
801085fc:	e8 2c ff ff ff       	call   8010852d <walkpgdir>
80108601:	83 c4 10             	add    $0x10,%esp
80108604:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108607:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010860b:	75 07                	jne    80108614 <mappages+0x47>
      return -1;
8010860d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108612:	eb 47                	jmp    8010865b <mappages+0x8e>
    if(*pte & PTE_P)
80108614:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108617:	8b 00                	mov    (%eax),%eax
80108619:	83 e0 01             	and    $0x1,%eax
8010861c:	85 c0                	test   %eax,%eax
8010861e:	74 0d                	je     8010862d <mappages+0x60>
      panic("remap");
80108620:	83 ec 0c             	sub    $0xc,%esp
80108623:	68 64 95 10 80       	push   $0x80109564
80108628:	e8 39 7f ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
8010862d:	8b 45 18             	mov    0x18(%ebp),%eax
80108630:	0b 45 14             	or     0x14(%ebp),%eax
80108633:	83 c8 01             	or     $0x1,%eax
80108636:	89 c2                	mov    %eax,%edx
80108638:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010863b:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010863d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108640:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108643:	74 10                	je     80108655 <mappages+0x88>
      break;
    a += PGSIZE;
80108645:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010864c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108653:	eb 9c                	jmp    801085f1 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108655:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108656:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010865b:	c9                   	leave  
8010865c:	c3                   	ret    

8010865d <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010865d:	55                   	push   %ebp
8010865e:	89 e5                	mov    %esp,%ebp
80108660:	53                   	push   %ebx
80108661:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108664:	e8 4b a6 ff ff       	call   80102cb4 <kalloc>
80108669:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010866c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108670:	75 0a                	jne    8010867c <setupkvm+0x1f>
    return 0;
80108672:	b8 00 00 00 00       	mov    $0x0,%eax
80108677:	e9 8e 00 00 00       	jmp    8010870a <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
8010867c:	83 ec 04             	sub    $0x4,%esp
8010867f:	68 00 10 00 00       	push   $0x1000
80108684:	6a 00                	push   $0x0
80108686:	ff 75 f0             	pushl  -0x10(%ebp)
80108689:	e8 f8 d3 ff ff       	call   80105a86 <memset>
8010868e:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108691:	83 ec 0c             	sub    $0xc,%esp
80108694:	68 00 00 00 0e       	push   $0xe000000
80108699:	e8 0d fa ff ff       	call   801080ab <p2v>
8010869e:	83 c4 10             	add    $0x10,%esp
801086a1:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801086a6:	76 0d                	jbe    801086b5 <setupkvm+0x58>
    panic("PHYSTOP too high");
801086a8:	83 ec 0c             	sub    $0xc,%esp
801086ab:	68 6a 95 10 80       	push   $0x8010956a
801086b0:	e8 b1 7e ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801086b5:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801086bc:	eb 40                	jmp    801086fe <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801086be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c1:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801086c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c7:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801086ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086cd:	8b 58 08             	mov    0x8(%eax),%ebx
801086d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086d3:	8b 40 04             	mov    0x4(%eax),%eax
801086d6:	29 c3                	sub    %eax,%ebx
801086d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086db:	8b 00                	mov    (%eax),%eax
801086dd:	83 ec 0c             	sub    $0xc,%esp
801086e0:	51                   	push   %ecx
801086e1:	52                   	push   %edx
801086e2:	53                   	push   %ebx
801086e3:	50                   	push   %eax
801086e4:	ff 75 f0             	pushl  -0x10(%ebp)
801086e7:	e8 e1 fe ff ff       	call   801085cd <mappages>
801086ec:	83 c4 20             	add    $0x20,%esp
801086ef:	85 c0                	test   %eax,%eax
801086f1:	79 07                	jns    801086fa <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801086f3:	b8 00 00 00 00       	mov    $0x0,%eax
801086f8:	eb 10                	jmp    8010870a <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801086fa:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801086fe:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108705:	72 b7                	jb     801086be <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108707:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010870a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010870d:	c9                   	leave  
8010870e:	c3                   	ret    

8010870f <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010870f:	55                   	push   %ebp
80108710:	89 e5                	mov    %esp,%ebp
80108712:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108715:	e8 43 ff ff ff       	call   8010865d <setupkvm>
8010871a:	a3 38 67 11 80       	mov    %eax,0x80116738
  switchkvm();
8010871f:	e8 03 00 00 00       	call   80108727 <switchkvm>
}
80108724:	90                   	nop
80108725:	c9                   	leave  
80108726:	c3                   	ret    

80108727 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108727:	55                   	push   %ebp
80108728:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010872a:	a1 38 67 11 80       	mov    0x80116738,%eax
8010872f:	50                   	push   %eax
80108730:	e8 69 f9 ff ff       	call   8010809e <v2p>
80108735:	83 c4 04             	add    $0x4,%esp
80108738:	50                   	push   %eax
80108739:	e8 54 f9 ff ff       	call   80108092 <lcr3>
8010873e:	83 c4 04             	add    $0x4,%esp
}
80108741:	90                   	nop
80108742:	c9                   	leave  
80108743:	c3                   	ret    

80108744 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108744:	55                   	push   %ebp
80108745:	89 e5                	mov    %esp,%ebp
80108747:	56                   	push   %esi
80108748:	53                   	push   %ebx
  pushcli();
80108749:	e8 32 d2 ff ff       	call   80105980 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010874e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108754:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010875b:	83 c2 08             	add    $0x8,%edx
8010875e:	89 d6                	mov    %edx,%esi
80108760:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108767:	83 c2 08             	add    $0x8,%edx
8010876a:	c1 ea 10             	shr    $0x10,%edx
8010876d:	89 d3                	mov    %edx,%ebx
8010876f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108776:	83 c2 08             	add    $0x8,%edx
80108779:	c1 ea 18             	shr    $0x18,%edx
8010877c:	89 d1                	mov    %edx,%ecx
8010877e:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108785:	67 00 
80108787:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
8010878e:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108794:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010879b:	83 e2 f0             	and    $0xfffffff0,%edx
8010879e:	83 ca 09             	or     $0x9,%edx
801087a1:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801087a7:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801087ae:	83 ca 10             	or     $0x10,%edx
801087b1:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801087b7:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801087be:	83 e2 9f             	and    $0xffffff9f,%edx
801087c1:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801087c7:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801087ce:	83 ca 80             	or     $0xffffff80,%edx
801087d1:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801087d7:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801087de:	83 e2 f0             	and    $0xfffffff0,%edx
801087e1:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801087e7:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801087ee:	83 e2 ef             	and    $0xffffffef,%edx
801087f1:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801087f7:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801087fe:	83 e2 df             	and    $0xffffffdf,%edx
80108801:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108807:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010880e:	83 ca 40             	or     $0x40,%edx
80108811:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108817:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010881e:	83 e2 7f             	and    $0x7f,%edx
80108821:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108827:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010882d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108833:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010883a:	83 e2 ef             	and    $0xffffffef,%edx
8010883d:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108843:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108849:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010884f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108855:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010885c:	8b 52 08             	mov    0x8(%edx),%edx
8010885f:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108865:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108868:	83 ec 0c             	sub    $0xc,%esp
8010886b:	6a 30                	push   $0x30
8010886d:	e8 f3 f7 ff ff       	call   80108065 <ltr>
80108872:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108875:	8b 45 08             	mov    0x8(%ebp),%eax
80108878:	8b 40 04             	mov    0x4(%eax),%eax
8010887b:	85 c0                	test   %eax,%eax
8010887d:	75 0d                	jne    8010888c <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010887f:	83 ec 0c             	sub    $0xc,%esp
80108882:	68 7b 95 10 80       	push   $0x8010957b
80108887:	e8 da 7c ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010888c:	8b 45 08             	mov    0x8(%ebp),%eax
8010888f:	8b 40 04             	mov    0x4(%eax),%eax
80108892:	83 ec 0c             	sub    $0xc,%esp
80108895:	50                   	push   %eax
80108896:	e8 03 f8 ff ff       	call   8010809e <v2p>
8010889b:	83 c4 10             	add    $0x10,%esp
8010889e:	83 ec 0c             	sub    $0xc,%esp
801088a1:	50                   	push   %eax
801088a2:	e8 eb f7 ff ff       	call   80108092 <lcr3>
801088a7:	83 c4 10             	add    $0x10,%esp
  popcli();
801088aa:	e8 16 d1 ff ff       	call   801059c5 <popcli>
}
801088af:	90                   	nop
801088b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801088b3:	5b                   	pop    %ebx
801088b4:	5e                   	pop    %esi
801088b5:	5d                   	pop    %ebp
801088b6:	c3                   	ret    

801088b7 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801088b7:	55                   	push   %ebp
801088b8:	89 e5                	mov    %esp,%ebp
801088ba:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801088bd:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801088c4:	76 0d                	jbe    801088d3 <inituvm+0x1c>
    panic("inituvm: more than a page");
801088c6:	83 ec 0c             	sub    $0xc,%esp
801088c9:	68 8f 95 10 80       	push   $0x8010958f
801088ce:	e8 93 7c ff ff       	call   80100566 <panic>
  mem = kalloc();
801088d3:	e8 dc a3 ff ff       	call   80102cb4 <kalloc>
801088d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801088db:	83 ec 04             	sub    $0x4,%esp
801088de:	68 00 10 00 00       	push   $0x1000
801088e3:	6a 00                	push   $0x0
801088e5:	ff 75 f4             	pushl  -0xc(%ebp)
801088e8:	e8 99 d1 ff ff       	call   80105a86 <memset>
801088ed:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801088f0:	83 ec 0c             	sub    $0xc,%esp
801088f3:	ff 75 f4             	pushl  -0xc(%ebp)
801088f6:	e8 a3 f7 ff ff       	call   8010809e <v2p>
801088fb:	83 c4 10             	add    $0x10,%esp
801088fe:	83 ec 0c             	sub    $0xc,%esp
80108901:	6a 06                	push   $0x6
80108903:	50                   	push   %eax
80108904:	68 00 10 00 00       	push   $0x1000
80108909:	6a 00                	push   $0x0
8010890b:	ff 75 08             	pushl  0x8(%ebp)
8010890e:	e8 ba fc ff ff       	call   801085cd <mappages>
80108913:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108916:	83 ec 04             	sub    $0x4,%esp
80108919:	ff 75 10             	pushl  0x10(%ebp)
8010891c:	ff 75 0c             	pushl  0xc(%ebp)
8010891f:	ff 75 f4             	pushl  -0xc(%ebp)
80108922:	e8 1e d2 ff ff       	call   80105b45 <memmove>
80108927:	83 c4 10             	add    $0x10,%esp
}
8010892a:	90                   	nop
8010892b:	c9                   	leave  
8010892c:	c3                   	ret    

8010892d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010892d:	55                   	push   %ebp
8010892e:	89 e5                	mov    %esp,%ebp
80108930:	53                   	push   %ebx
80108931:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108934:	8b 45 0c             	mov    0xc(%ebp),%eax
80108937:	25 ff 0f 00 00       	and    $0xfff,%eax
8010893c:	85 c0                	test   %eax,%eax
8010893e:	74 0d                	je     8010894d <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108940:	83 ec 0c             	sub    $0xc,%esp
80108943:	68 ac 95 10 80       	push   $0x801095ac
80108948:	e8 19 7c ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010894d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108954:	e9 95 00 00 00       	jmp    801089ee <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108959:	8b 55 0c             	mov    0xc(%ebp),%edx
8010895c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010895f:	01 d0                	add    %edx,%eax
80108961:	83 ec 04             	sub    $0x4,%esp
80108964:	6a 00                	push   $0x0
80108966:	50                   	push   %eax
80108967:	ff 75 08             	pushl  0x8(%ebp)
8010896a:	e8 be fb ff ff       	call   8010852d <walkpgdir>
8010896f:	83 c4 10             	add    $0x10,%esp
80108972:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108975:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108979:	75 0d                	jne    80108988 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010897b:	83 ec 0c             	sub    $0xc,%esp
8010897e:	68 cf 95 10 80       	push   $0x801095cf
80108983:	e8 de 7b ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108988:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010898b:	8b 00                	mov    (%eax),%eax
8010898d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108992:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108995:	8b 45 18             	mov    0x18(%ebp),%eax
80108998:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010899b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801089a0:	77 0b                	ja     801089ad <loaduvm+0x80>
      n = sz - i;
801089a2:	8b 45 18             	mov    0x18(%ebp),%eax
801089a5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801089a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801089ab:	eb 07                	jmp    801089b4 <loaduvm+0x87>
    else
      n = PGSIZE;
801089ad:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801089b4:	8b 55 14             	mov    0x14(%ebp),%edx
801089b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ba:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801089bd:	83 ec 0c             	sub    $0xc,%esp
801089c0:	ff 75 e8             	pushl  -0x18(%ebp)
801089c3:	e8 e3 f6 ff ff       	call   801080ab <p2v>
801089c8:	83 c4 10             	add    $0x10,%esp
801089cb:	ff 75 f0             	pushl  -0x10(%ebp)
801089ce:	53                   	push   %ebx
801089cf:	50                   	push   %eax
801089d0:	ff 75 10             	pushl  0x10(%ebp)
801089d3:	e8 4e 95 ff ff       	call   80101f26 <readi>
801089d8:	83 c4 10             	add    $0x10,%esp
801089db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801089de:	74 07                	je     801089e7 <loaduvm+0xba>
      return -1;
801089e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801089e5:	eb 18                	jmp    801089ff <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801089e7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f1:	3b 45 18             	cmp    0x18(%ebp),%eax
801089f4:	0f 82 5f ff ff ff    	jb     80108959 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801089fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801089ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108a02:	c9                   	leave  
80108a03:	c3                   	ret    

80108a04 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108a04:	55                   	push   %ebp
80108a05:	89 e5                	mov    %esp,%ebp
80108a07:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108a0a:	8b 45 10             	mov    0x10(%ebp),%eax
80108a0d:	85 c0                	test   %eax,%eax
80108a0f:	79 0a                	jns    80108a1b <allocuvm+0x17>
    return 0;
80108a11:	b8 00 00 00 00       	mov    $0x0,%eax
80108a16:	e9 b0 00 00 00       	jmp    80108acb <allocuvm+0xc7>
  if(newsz < oldsz)
80108a1b:	8b 45 10             	mov    0x10(%ebp),%eax
80108a1e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a21:	73 08                	jae    80108a2b <allocuvm+0x27>
    return oldsz;
80108a23:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a26:	e9 a0 00 00 00       	jmp    80108acb <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a2e:	05 ff 0f 00 00       	add    $0xfff,%eax
80108a33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108a3b:	eb 7f                	jmp    80108abc <allocuvm+0xb8>
    mem = kalloc();
80108a3d:	e8 72 a2 ff ff       	call   80102cb4 <kalloc>
80108a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108a45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a49:	75 2b                	jne    80108a76 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108a4b:	83 ec 0c             	sub    $0xc,%esp
80108a4e:	68 ed 95 10 80       	push   $0x801095ed
80108a53:	e8 6e 79 ff ff       	call   801003c6 <cprintf>
80108a58:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108a5b:	83 ec 04             	sub    $0x4,%esp
80108a5e:	ff 75 0c             	pushl  0xc(%ebp)
80108a61:	ff 75 10             	pushl  0x10(%ebp)
80108a64:	ff 75 08             	pushl  0x8(%ebp)
80108a67:	e8 61 00 00 00       	call   80108acd <deallocuvm>
80108a6c:	83 c4 10             	add    $0x10,%esp
      return 0;
80108a6f:	b8 00 00 00 00       	mov    $0x0,%eax
80108a74:	eb 55                	jmp    80108acb <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108a76:	83 ec 04             	sub    $0x4,%esp
80108a79:	68 00 10 00 00       	push   $0x1000
80108a7e:	6a 00                	push   $0x0
80108a80:	ff 75 f0             	pushl  -0x10(%ebp)
80108a83:	e8 fe cf ff ff       	call   80105a86 <memset>
80108a88:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108a8b:	83 ec 0c             	sub    $0xc,%esp
80108a8e:	ff 75 f0             	pushl  -0x10(%ebp)
80108a91:	e8 08 f6 ff ff       	call   8010809e <v2p>
80108a96:	83 c4 10             	add    $0x10,%esp
80108a99:	89 c2                	mov    %eax,%edx
80108a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a9e:	83 ec 0c             	sub    $0xc,%esp
80108aa1:	6a 06                	push   $0x6
80108aa3:	52                   	push   %edx
80108aa4:	68 00 10 00 00       	push   $0x1000
80108aa9:	50                   	push   %eax
80108aaa:	ff 75 08             	pushl  0x8(%ebp)
80108aad:	e8 1b fb ff ff       	call   801085cd <mappages>
80108ab2:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108ab5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abf:	3b 45 10             	cmp    0x10(%ebp),%eax
80108ac2:	0f 82 75 ff ff ff    	jb     80108a3d <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108ac8:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108acb:	c9                   	leave  
80108acc:	c3                   	ret    

80108acd <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108acd:	55                   	push   %ebp
80108ace:	89 e5                	mov    %esp,%ebp
80108ad0:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108ad3:	8b 45 10             	mov    0x10(%ebp),%eax
80108ad6:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108ad9:	72 08                	jb     80108ae3 <deallocuvm+0x16>
    return oldsz;
80108adb:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ade:	e9 a5 00 00 00       	jmp    80108b88 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108ae3:	8b 45 10             	mov    0x10(%ebp),%eax
80108ae6:	05 ff 0f 00 00       	add    $0xfff,%eax
80108aeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108af3:	e9 81 00 00 00       	jmp    80108b79 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108afb:	83 ec 04             	sub    $0x4,%esp
80108afe:	6a 00                	push   $0x0
80108b00:	50                   	push   %eax
80108b01:	ff 75 08             	pushl  0x8(%ebp)
80108b04:	e8 24 fa ff ff       	call   8010852d <walkpgdir>
80108b09:	83 c4 10             	add    $0x10,%esp
80108b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108b0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b13:	75 09                	jne    80108b1e <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108b15:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108b1c:	eb 54                	jmp    80108b72 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b21:	8b 00                	mov    (%eax),%eax
80108b23:	83 e0 01             	and    $0x1,%eax
80108b26:	85 c0                	test   %eax,%eax
80108b28:	74 48                	je     80108b72 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b2d:	8b 00                	mov    (%eax),%eax
80108b2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108b37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b3b:	75 0d                	jne    80108b4a <deallocuvm+0x7d>
        panic("kfree");
80108b3d:	83 ec 0c             	sub    $0xc,%esp
80108b40:	68 05 96 10 80       	push   $0x80109605
80108b45:	e8 1c 7a ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80108b4a:	83 ec 0c             	sub    $0xc,%esp
80108b4d:	ff 75 ec             	pushl  -0x14(%ebp)
80108b50:	e8 56 f5 ff ff       	call   801080ab <p2v>
80108b55:	83 c4 10             	add    $0x10,%esp
80108b58:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108b5b:	83 ec 0c             	sub    $0xc,%esp
80108b5e:	ff 75 e8             	pushl  -0x18(%ebp)
80108b61:	e8 b1 a0 ff ff       	call   80102c17 <kfree>
80108b66:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108b72:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b7c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b7f:	0f 82 73 ff ff ff    	jb     80108af8 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108b85:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108b88:	c9                   	leave  
80108b89:	c3                   	ret    

80108b8a <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108b8a:	55                   	push   %ebp
80108b8b:	89 e5                	mov    %esp,%ebp
80108b8d:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108b90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108b94:	75 0d                	jne    80108ba3 <freevm+0x19>
    panic("freevm: no pgdir");
80108b96:	83 ec 0c             	sub    $0xc,%esp
80108b99:	68 0b 96 10 80       	push   $0x8010960b
80108b9e:	e8 c3 79 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108ba3:	83 ec 04             	sub    $0x4,%esp
80108ba6:	6a 00                	push   $0x0
80108ba8:	68 00 00 00 80       	push   $0x80000000
80108bad:	ff 75 08             	pushl  0x8(%ebp)
80108bb0:	e8 18 ff ff ff       	call   80108acd <deallocuvm>
80108bb5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108bb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108bbf:	eb 4f                	jmp    80108c10 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80108bce:	01 d0                	add    %edx,%eax
80108bd0:	8b 00                	mov    (%eax),%eax
80108bd2:	83 e0 01             	and    $0x1,%eax
80108bd5:	85 c0                	test   %eax,%eax
80108bd7:	74 33                	je     80108c0c <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108be3:	8b 45 08             	mov    0x8(%ebp),%eax
80108be6:	01 d0                	add    %edx,%eax
80108be8:	8b 00                	mov    (%eax),%eax
80108bea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bef:	83 ec 0c             	sub    $0xc,%esp
80108bf2:	50                   	push   %eax
80108bf3:	e8 b3 f4 ff ff       	call   801080ab <p2v>
80108bf8:	83 c4 10             	add    $0x10,%esp
80108bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108bfe:	83 ec 0c             	sub    $0xc,%esp
80108c01:	ff 75 f0             	pushl  -0x10(%ebp)
80108c04:	e8 0e a0 ff ff       	call   80102c17 <kfree>
80108c09:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108c0c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108c10:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108c17:	76 a8                	jbe    80108bc1 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108c19:	83 ec 0c             	sub    $0xc,%esp
80108c1c:	ff 75 08             	pushl  0x8(%ebp)
80108c1f:	e8 f3 9f ff ff       	call   80102c17 <kfree>
80108c24:	83 c4 10             	add    $0x10,%esp
}
80108c27:	90                   	nop
80108c28:	c9                   	leave  
80108c29:	c3                   	ret    

80108c2a <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108c2a:	55                   	push   %ebp
80108c2b:	89 e5                	mov    %esp,%ebp
80108c2d:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108c30:	83 ec 04             	sub    $0x4,%esp
80108c33:	6a 00                	push   $0x0
80108c35:	ff 75 0c             	pushl  0xc(%ebp)
80108c38:	ff 75 08             	pushl  0x8(%ebp)
80108c3b:	e8 ed f8 ff ff       	call   8010852d <walkpgdir>
80108c40:	83 c4 10             	add    $0x10,%esp
80108c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108c4a:	75 0d                	jne    80108c59 <clearpteu+0x2f>
    panic("clearpteu");
80108c4c:	83 ec 0c             	sub    $0xc,%esp
80108c4f:	68 1c 96 10 80       	push   $0x8010961c
80108c54:	e8 0d 79 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c5c:	8b 00                	mov    (%eax),%eax
80108c5e:	83 e0 fb             	and    $0xfffffffb,%eax
80108c61:	89 c2                	mov    %eax,%edx
80108c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c66:	89 10                	mov    %edx,(%eax)
}
80108c68:	90                   	nop
80108c69:	c9                   	leave  
80108c6a:	c3                   	ret    

80108c6b <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108c6b:	55                   	push   %ebp
80108c6c:	89 e5                	mov    %esp,%ebp
80108c6e:	53                   	push   %ebx
80108c6f:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108c72:	e8 e6 f9 ff ff       	call   8010865d <setupkvm>
80108c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108c7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108c7e:	75 0a                	jne    80108c8a <copyuvm+0x1f>
    return 0;
80108c80:	b8 00 00 00 00       	mov    $0x0,%eax
80108c85:	e9 f8 00 00 00       	jmp    80108d82 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108c8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108c91:	e9 c4 00 00 00       	jmp    80108d5a <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c99:	83 ec 04             	sub    $0x4,%esp
80108c9c:	6a 00                	push   $0x0
80108c9e:	50                   	push   %eax
80108c9f:	ff 75 08             	pushl  0x8(%ebp)
80108ca2:	e8 86 f8 ff ff       	call   8010852d <walkpgdir>
80108ca7:	83 c4 10             	add    $0x10,%esp
80108caa:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108cad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108cb1:	75 0d                	jne    80108cc0 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108cb3:	83 ec 0c             	sub    $0xc,%esp
80108cb6:	68 26 96 10 80       	push   $0x80109626
80108cbb:	e8 a6 78 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cc3:	8b 00                	mov    (%eax),%eax
80108cc5:	83 e0 01             	and    $0x1,%eax
80108cc8:	85 c0                	test   %eax,%eax
80108cca:	75 0d                	jne    80108cd9 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108ccc:	83 ec 0c             	sub    $0xc,%esp
80108ccf:	68 40 96 10 80       	push   $0x80109640
80108cd4:	e8 8d 78 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cdc:	8b 00                	mov    (%eax),%eax
80108cde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ce3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108ce6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ce9:	8b 00                	mov    (%eax),%eax
80108ceb:	25 ff 0f 00 00       	and    $0xfff,%eax
80108cf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108cf3:	e8 bc 9f ff ff       	call   80102cb4 <kalloc>
80108cf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108cfb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108cff:	74 6a                	je     80108d6b <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108d01:	83 ec 0c             	sub    $0xc,%esp
80108d04:	ff 75 e8             	pushl  -0x18(%ebp)
80108d07:	e8 9f f3 ff ff       	call   801080ab <p2v>
80108d0c:	83 c4 10             	add    $0x10,%esp
80108d0f:	83 ec 04             	sub    $0x4,%esp
80108d12:	68 00 10 00 00       	push   $0x1000
80108d17:	50                   	push   %eax
80108d18:	ff 75 e0             	pushl  -0x20(%ebp)
80108d1b:	e8 25 ce ff ff       	call   80105b45 <memmove>
80108d20:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108d23:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108d26:	83 ec 0c             	sub    $0xc,%esp
80108d29:	ff 75 e0             	pushl  -0x20(%ebp)
80108d2c:	e8 6d f3 ff ff       	call   8010809e <v2p>
80108d31:	83 c4 10             	add    $0x10,%esp
80108d34:	89 c2                	mov    %eax,%edx
80108d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d39:	83 ec 0c             	sub    $0xc,%esp
80108d3c:	53                   	push   %ebx
80108d3d:	52                   	push   %edx
80108d3e:	68 00 10 00 00       	push   $0x1000
80108d43:	50                   	push   %eax
80108d44:	ff 75 f0             	pushl  -0x10(%ebp)
80108d47:	e8 81 f8 ff ff       	call   801085cd <mappages>
80108d4c:	83 c4 20             	add    $0x20,%esp
80108d4f:	85 c0                	test   %eax,%eax
80108d51:	78 1b                	js     80108d6e <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108d53:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d5d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108d60:	0f 82 30 ff ff ff    	jb     80108c96 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d69:	eb 17                	jmp    80108d82 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108d6b:	90                   	nop
80108d6c:	eb 01                	jmp    80108d6f <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108d6e:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108d6f:	83 ec 0c             	sub    $0xc,%esp
80108d72:	ff 75 f0             	pushl  -0x10(%ebp)
80108d75:	e8 10 fe ff ff       	call   80108b8a <freevm>
80108d7a:	83 c4 10             	add    $0x10,%esp
  return 0;
80108d7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108d85:	c9                   	leave  
80108d86:	c3                   	ret    

80108d87 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108d87:	55                   	push   %ebp
80108d88:	89 e5                	mov    %esp,%ebp
80108d8a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108d8d:	83 ec 04             	sub    $0x4,%esp
80108d90:	6a 00                	push   $0x0
80108d92:	ff 75 0c             	pushl  0xc(%ebp)
80108d95:	ff 75 08             	pushl  0x8(%ebp)
80108d98:	e8 90 f7 ff ff       	call   8010852d <walkpgdir>
80108d9d:	83 c4 10             	add    $0x10,%esp
80108da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da6:	8b 00                	mov    (%eax),%eax
80108da8:	83 e0 01             	and    $0x1,%eax
80108dab:	85 c0                	test   %eax,%eax
80108dad:	75 07                	jne    80108db6 <uva2ka+0x2f>
    return 0;
80108daf:	b8 00 00 00 00       	mov    $0x0,%eax
80108db4:	eb 29                	jmp    80108ddf <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db9:	8b 00                	mov    (%eax),%eax
80108dbb:	83 e0 04             	and    $0x4,%eax
80108dbe:	85 c0                	test   %eax,%eax
80108dc0:	75 07                	jne    80108dc9 <uva2ka+0x42>
    return 0;
80108dc2:	b8 00 00 00 00       	mov    $0x0,%eax
80108dc7:	eb 16                	jmp    80108ddf <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dcc:	8b 00                	mov    (%eax),%eax
80108dce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108dd3:	83 ec 0c             	sub    $0xc,%esp
80108dd6:	50                   	push   %eax
80108dd7:	e8 cf f2 ff ff       	call   801080ab <p2v>
80108ddc:	83 c4 10             	add    $0x10,%esp
}
80108ddf:	c9                   	leave  
80108de0:	c3                   	ret    

80108de1 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108de1:	55                   	push   %ebp
80108de2:	89 e5                	mov    %esp,%ebp
80108de4:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108de7:	8b 45 10             	mov    0x10(%ebp),%eax
80108dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108ded:	eb 7f                	jmp    80108e6e <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108def:	8b 45 0c             	mov    0xc(%ebp),%eax
80108df2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108df7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dfd:	83 ec 08             	sub    $0x8,%esp
80108e00:	50                   	push   %eax
80108e01:	ff 75 08             	pushl  0x8(%ebp)
80108e04:	e8 7e ff ff ff       	call   80108d87 <uva2ka>
80108e09:	83 c4 10             	add    $0x10,%esp
80108e0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108e0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108e13:	75 07                	jne    80108e1c <copyout+0x3b>
      return -1;
80108e15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e1a:	eb 61                	jmp    80108e7d <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108e1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e1f:	2b 45 0c             	sub    0xc(%ebp),%eax
80108e22:	05 00 10 00 00       	add    $0x1000,%eax
80108e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e2d:	3b 45 14             	cmp    0x14(%ebp),%eax
80108e30:	76 06                	jbe    80108e38 <copyout+0x57>
      n = len;
80108e32:	8b 45 14             	mov    0x14(%ebp),%eax
80108e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108e38:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e3b:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108e3e:	89 c2                	mov    %eax,%edx
80108e40:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e43:	01 d0                	add    %edx,%eax
80108e45:	83 ec 04             	sub    $0x4,%esp
80108e48:	ff 75 f0             	pushl  -0x10(%ebp)
80108e4b:	ff 75 f4             	pushl  -0xc(%ebp)
80108e4e:	50                   	push   %eax
80108e4f:	e8 f1 cc ff ff       	call   80105b45 <memmove>
80108e54:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e5a:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e60:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e66:	05 00 10 00 00       	add    $0x1000,%eax
80108e6b:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108e6e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108e72:	0f 85 77 ff ff ff    	jne    80108def <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108e78:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e7d:	c9                   	leave  
80108e7e:	c3                   	ret    
