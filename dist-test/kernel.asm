
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
8010003d:	68 50 95 10 80       	push   $0x80109550
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 83 5e 00 00       	call   80105ecf <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

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
  initlock(&bcache.lock, "bcache");

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
801000c1:	e8 2b 5e 00 00       	call   80105ef1 <acquire>
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
8010010c:	e8 47 5e 00 00       	call   80105f58 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 ed 50 00 00       	call   80105219 <sleep>
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
80100188:	e8 cb 5d 00 00       	call   80105f58 <release>
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
801001aa:	68 57 95 10 80       	push   $0x80109557
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
80100204:	68 68 95 10 80       	push   $0x80109568
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
80100243:	68 6f 95 10 80       	push   $0x8010956f
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 97 5c 00 00       	call   80105ef1 <acquire>
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
801002b9:	e8 b1 50 00 00       	call   8010536f <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 8a 5c 00 00       	call   80105f58 <release>
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
801003e2:	e8 0a 5b 00 00       	call   80105ef1 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 76 95 10 80       	push   $0x80109576
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
801004cd:	c7 45 ec 7f 95 10 80 	movl   $0x8010957f,-0x14(%ebp)
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
8010055b:	e8 f8 59 00 00       	call   80105f58 <release>
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
8010058b:	68 86 95 10 80       	push   $0x80109586
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
801005aa:	68 95 95 10 80       	push   $0x80109595
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 e3 59 00 00       	call   80105faa <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 97 95 10 80       	push   $0x80109597
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
801006ca:	68 9b 95 10 80       	push   $0x8010959b
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
801006f7:	e8 17 5b 00 00       	call   80106213 <memmove>
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
80100721:	e8 2e 5a 00 00       	call   80106154 <memset>
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
801007b6:	e8 1b 74 00 00       	call   80107bd6 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 0e 74 00 00       	call   80107bd6 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 01 74 00 00       	call   80107bd6 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 f1 73 00 00       	call   80107bd6 <uartputc>
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
80100825:	68 e0 c5 10 80       	push   $0x8010c5e0
8010082a:	e8 c2 56 00 00       	call   80105ef1 <acquire>
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
8010089b:	a1 28 18 11 80       	mov    0x80111828,%eax
801008a0:	83 e8 01             	sub    $0x1,%eax
801008a3:	a3 28 18 11 80       	mov    %eax,0x80111828
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
801008b8:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008be:	a1 24 18 11 80       	mov    0x80111824,%eax
801008c3:	39 c2                	cmp    %eax,%edx
801008c5:	0f 84 12 01 00 00    	je     801009dd <consoleintr+0x1e4>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008cb:	a1 28 18 11 80       	mov    0x80111828,%eax
801008d0:	83 e8 01             	sub    $0x1,%eax
801008d3:	83 e0 7f             	and    $0x7f,%eax
801008d6:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
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
801008e6:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008ec:	a1 24 18 11 80       	mov    0x80111824,%eax
801008f1:	39 c2                	cmp    %eax,%edx
801008f3:	0f 84 e4 00 00 00    	je     801009dd <consoleintr+0x1e4>
        input.e--;
801008f9:	a1 28 18 11 80       	mov    0x80111828,%eax
801008fe:	83 e8 01             	sub    $0x1,%eax
80100901:	a3 28 18 11 80       	mov    %eax,0x80111828
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
80100955:	8b 15 28 18 11 80    	mov    0x80111828,%edx
8010095b:	a1 20 18 11 80       	mov    0x80111820,%eax
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
8010097c:	a1 28 18 11 80       	mov    0x80111828,%eax
80100981:	8d 50 01             	lea    0x1(%eax),%edx
80100984:	89 15 28 18 11 80    	mov    %edx,0x80111828
8010098a:	83 e0 7f             	and    $0x7f,%eax
8010098d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100990:	88 90 a0 17 11 80    	mov    %dl,-0x7feee860(%eax)
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
801009b0:	a1 28 18 11 80       	mov    0x80111828,%eax
801009b5:	8b 15 20 18 11 80    	mov    0x80111820,%edx
801009bb:	83 ea 80             	sub    $0xffffff80,%edx
801009be:	39 d0                	cmp    %edx,%eax
801009c0:	75 1a                	jne    801009dc <consoleintr+0x1e3>
          input.w = input.e;
801009c2:	a1 28 18 11 80       	mov    0x80111828,%eax
801009c7:	a3 24 18 11 80       	mov    %eax,0x80111824
          wakeup(&input.r);
801009cc:	83 ec 0c             	sub    $0xc,%esp
801009cf:	68 20 18 11 80       	push   $0x80111820
801009d4:	e8 96 49 00 00       	call   8010536f <wakeup>
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
801009f2:	68 e0 c5 10 80       	push   $0x8010c5e0
801009f7:	e8 5c 55 00 00       	call   80105f58 <release>
801009fc:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a03:	74 05                	je     80100a0a <consoleintr+0x211>
    procdump();  // now call procdump() wo. cons.lock held
80100a05:	e8 37 4b 00 00       	call   80105541 <procdump>
  }
  if (f) {
80100a0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a0e:	74 05                	je     80100a15 <consoleintr+0x21c>
    free_length();
80100a10:	e8 29 4f 00 00       	call   8010593e <free_length>
  }
  if (r) {
80100a15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a19:	74 05                	je     80100a20 <consoleintr+0x227>
    display_ready();
80100a1b:	e8 aa 4f 00 00       	call   801059ca <display_ready>
  }
  if (s) {
80100a20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a24:	74 05                	je     80100a2b <consoleintr+0x232>
    display_sleep();
80100a26:	e8 59 50 00 00       	call   80105a84 <display_sleep>
  }
  if (z) {
80100a2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a2f:	74 05                	je     80100a36 <consoleintr+0x23d>
    display_zombie();
80100a31:	e8 08 51 00 00       	call   80105b3e <display_zombie>
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
80100a56:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a5b:	e8 91 54 00 00       	call   80105ef1 <acquire>
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
80100a78:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a7d:	e8 d6 54 00 00       	call   80105f58 <release>
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
80100aa0:	68 e0 c5 10 80       	push   $0x8010c5e0
80100aa5:	68 20 18 11 80       	push   $0x80111820
80100aaa:	e8 6a 47 00 00       	call   80105219 <sleep>
80100aaf:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100ab2:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100ab8:	a1 24 18 11 80       	mov    0x80111824,%eax
80100abd:	39 c2                	cmp    %eax,%edx
80100abf:	74 a7                	je     80100a68 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ac1:	a1 20 18 11 80       	mov    0x80111820,%eax
80100ac6:	8d 50 01             	lea    0x1(%eax),%edx
80100ac9:	89 15 20 18 11 80    	mov    %edx,0x80111820
80100acf:	83 e0 7f             	and    $0x7f,%eax
80100ad2:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
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
80100aed:	a1 20 18 11 80       	mov    0x80111820,%eax
80100af2:	83 e8 01             	sub    $0x1,%eax
80100af5:	a3 20 18 11 80       	mov    %eax,0x80111820
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
80100b23:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b28:	e8 2b 54 00 00       	call   80105f58 <release>
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
80100b61:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b66:	e8 86 53 00 00       	call   80105ef1 <acquire>
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
80100ba3:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ba8:	e8 ab 53 00 00       	call   80105f58 <release>
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
80100bcc:	68 ae 95 10 80       	push   $0x801095ae
80100bd1:	68 e0 c5 10 80       	push   $0x8010c5e0
80100bd6:	e8 f4 52 00 00       	call   80105ecf <initlock>
80100bdb:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bde:	c7 05 ec 21 11 80 4a 	movl   $0x80100b4a,0x801121ec
80100be5:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be8:	c7 05 e8 21 11 80 39 	movl   $0x80100a39,0x801121e8
80100bef:	0a 10 80 
  cons.locking = 1;
80100bf2:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
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
80100c94:	e8 92 80 00 00       	call   80108d2b <setupkvm>
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
80100d1a:	e8 b3 83 00 00       	call   801090d2 <allocuvm>
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
80100d4d:	e8 a9 82 00 00       	call   80108ffb <loaduvm>
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
80100dbc:	e8 11 83 00 00       	call   801090d2 <allocuvm>
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
80100de0:	e8 13 85 00 00       	call   801092f8 <clearpteu>
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
80100e19:	e8 83 55 00 00       	call   801063a1 <strlen>
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
80100e46:	e8 56 55 00 00       	call   801063a1 <strlen>
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
80100e6c:	e8 3e 86 00 00       	call   801094af <copyout>
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
80100f08:	e8 a2 85 00 00       	call   801094af <copyout>
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
80100f59:	e8 f9 53 00 00       	call   80106357 <safestrcpy>
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
80100faf:	e8 5e 7e 00 00       	call   80108e12 <switchuvm>
80100fb4:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fb7:	83 ec 0c             	sub    $0xc,%esp
80100fba:	ff 75 d0             	pushl  -0x30(%ebp)
80100fbd:	e8 96 82 00 00       	call   80109258 <freevm>
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
80100ff7:	e8 5c 82 00 00       	call   80109258 <freevm>
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
80101028:	68 b6 95 10 80       	push   $0x801095b6
8010102d:	68 40 18 11 80       	push   $0x80111840
80101032:	e8 98 4e 00 00       	call   80105ecf <initlock>
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
80101046:	68 40 18 11 80       	push   $0x80111840
8010104b:	e8 a1 4e 00 00       	call   80105ef1 <acquire>
80101050:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101053:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
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
80101073:	68 40 18 11 80       	push   $0x80111840
80101078:	e8 db 4e 00 00       	call   80105f58 <release>
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
80101089:	b8 d4 21 11 80       	mov    $0x801121d4,%eax
8010108e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101091:	72 c9                	jb     8010105c <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101093:	83 ec 0c             	sub    $0xc,%esp
80101096:	68 40 18 11 80       	push   $0x80111840
8010109b:	e8 b8 4e 00 00       	call   80105f58 <release>
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
801010b3:	68 40 18 11 80       	push   $0x80111840
801010b8:	e8 34 4e 00 00       	call   80105ef1 <acquire>
801010bd:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010c0:	8b 45 08             	mov    0x8(%ebp),%eax
801010c3:	8b 40 04             	mov    0x4(%eax),%eax
801010c6:	85 c0                	test   %eax,%eax
801010c8:	7f 0d                	jg     801010d7 <filedup+0x2d>
    panic("filedup");
801010ca:	83 ec 0c             	sub    $0xc,%esp
801010cd:	68 bd 95 10 80       	push   $0x801095bd
801010d2:	e8 8f f4 ff ff       	call   80100566 <panic>
  f->ref++;
801010d7:	8b 45 08             	mov    0x8(%ebp),%eax
801010da:	8b 40 04             	mov    0x4(%eax),%eax
801010dd:	8d 50 01             	lea    0x1(%eax),%edx
801010e0:	8b 45 08             	mov    0x8(%ebp),%eax
801010e3:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010e6:	83 ec 0c             	sub    $0xc,%esp
801010e9:	68 40 18 11 80       	push   $0x80111840
801010ee:	e8 65 4e 00 00       	call   80105f58 <release>
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
80101104:	68 40 18 11 80       	push   $0x80111840
80101109:	e8 e3 4d 00 00       	call   80105ef1 <acquire>
8010110e:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101111:	8b 45 08             	mov    0x8(%ebp),%eax
80101114:	8b 40 04             	mov    0x4(%eax),%eax
80101117:	85 c0                	test   %eax,%eax
80101119:	7f 0d                	jg     80101128 <fileclose+0x2d>
    panic("fileclose");
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	68 c5 95 10 80       	push   $0x801095c5
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
80101144:	68 40 18 11 80       	push   $0x80111840
80101149:	e8 0a 4e 00 00       	call   80105f58 <release>
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
80101192:	68 40 18 11 80       	push   $0x80111840
80101197:	e8 bc 4d 00 00       	call   80105f58 <release>
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
801012e6:	68 cf 95 10 80       	push   $0x801095cf
801012eb:	e8 76 f2 ff ff       	call   80100566 <panic>
}
801012f0:	c9                   	leave  
801012f1:	c3                   	ret    

801012f2 <filewrite>:

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
801013e9:	68 d8 95 10 80       	push   $0x801095d8
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
8010141f:	68 e8 95 10 80       	push   $0x801095e8
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
80101457:	e8 b7 4d 00 00       	call   80106213 <memmove>
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
8010149d:	e8 b2 4c 00 00       	call   80106154 <memset>
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
801014f0:	a1 58 22 11 80       	mov    0x80112258,%eax
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
801015ce:	a1 40 22 11 80       	mov    0x80112240,%eax
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
801015f0:	8b 15 40 22 11 80    	mov    0x80112240,%edx
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
80101604:	68 f4 95 10 80       	push   $0x801095f4
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
80101619:	68 40 22 11 80       	push   $0x80112240
8010161e:	ff 75 08             	pushl  0x8(%ebp)
80101621:	e8 08 fe ff ff       	call   8010142e <readsb>
80101626:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101629:	8b 45 0c             	mov    0xc(%ebp),%eax
8010162c:	c1 e8 0c             	shr    $0xc,%eax
8010162f:	89 c2                	mov    %eax,%edx
80101631:	a1 58 22 11 80       	mov    0x80112258,%eax
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
80101697:	68 0a 96 10 80       	push   $0x8010960a
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
801016f4:	68 1d 96 10 80       	push   $0x8010961d
801016f9:	68 60 22 11 80       	push   $0x80112260
801016fe:	e8 cc 47 00 00       	call   80105ecf <initlock>
80101703:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101706:	83 ec 08             	sub    $0x8,%esp
80101709:	68 40 22 11 80       	push   $0x80112240
8010170e:	ff 75 08             	pushl  0x8(%ebp)
80101711:	e8 18 fd ff ff       	call   8010142e <readsb>
80101716:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101719:	a1 58 22 11 80       	mov    0x80112258,%eax
8010171e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101721:	8b 3d 54 22 11 80    	mov    0x80112254,%edi
80101727:	8b 35 50 22 11 80    	mov    0x80112250,%esi
8010172d:	8b 1d 4c 22 11 80    	mov    0x8011224c,%ebx
80101733:	8b 0d 48 22 11 80    	mov    0x80112248,%ecx
80101739:	8b 15 44 22 11 80    	mov    0x80112244,%edx
8010173f:	a1 40 22 11 80       	mov    0x80112240,%eax
80101744:	ff 75 e4             	pushl  -0x1c(%ebp)
80101747:	57                   	push   %edi
80101748:	56                   	push   %esi
80101749:	53                   	push   %ebx
8010174a:	51                   	push   %ecx
8010174b:	52                   	push   %edx
8010174c:	50                   	push   %eax
8010174d:	68 24 96 10 80       	push   $0x80109624
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
80101784:	a1 54 22 11 80       	mov    0x80112254,%eax
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
801017c6:	e8 89 49 00 00       	call   80106154 <memset>
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
8010181a:	8b 15 48 22 11 80    	mov    0x80112248,%edx
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
8010182e:	68 77 96 10 80       	push   $0x80109677
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
8010184b:	a1 54 22 11 80       	mov    0x80112254,%eax
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
801018d4:	e8 3a 49 00 00       	call   80106213 <memmove>
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
80101904:	68 60 22 11 80       	push   $0x80112260
80101909:	e8 e3 45 00 00       	call   80105ef1 <acquire>
8010190e:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101911:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101918:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
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
80101952:	68 60 22 11 80       	push   $0x80112260
80101957:	e8 fc 45 00 00       	call   80105f58 <release>
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
8010197e:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
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
80101990:	68 89 96 10 80       	push   $0x80109689
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
801019c8:	68 60 22 11 80       	push   $0x80112260
801019cd:	e8 86 45 00 00       	call   80105f58 <release>
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
801019e3:	68 60 22 11 80       	push   $0x80112260
801019e8:	e8 04 45 00 00       	call   80105ef1 <acquire>
801019ed:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019f0:	8b 45 08             	mov    0x8(%ebp),%eax
801019f3:	8b 40 08             	mov    0x8(%eax),%eax
801019f6:	8d 50 01             	lea    0x1(%eax),%edx
801019f9:	8b 45 08             	mov    0x8(%ebp),%eax
801019fc:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019ff:	83 ec 0c             	sub    $0xc,%esp
80101a02:	68 60 22 11 80       	push   $0x80112260
80101a07:	e8 4c 45 00 00       	call   80105f58 <release>
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
80101a2d:	68 99 96 10 80       	push   $0x80109699
80101a32:	e8 2f eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a37:	83 ec 0c             	sub    $0xc,%esp
80101a3a:	68 60 22 11 80       	push   $0x80112260
80101a3f:	e8 ad 44 00 00       	call   80105ef1 <acquire>
80101a44:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a47:	eb 13                	jmp    80101a5c <ilock+0x48>
    sleep(ip, &icache.lock);
80101a49:	83 ec 08             	sub    $0x8,%esp
80101a4c:	68 60 22 11 80       	push   $0x80112260
80101a51:	ff 75 08             	pushl  0x8(%ebp)
80101a54:	e8 c0 37 00 00       	call   80105219 <sleep>
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
80101a7d:	68 60 22 11 80       	push   $0x80112260
80101a82:	e8 d1 44 00 00       	call   80105f58 <release>
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
80101aa6:	a1 54 22 11 80       	mov    0x80112254,%eax
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
80101b2f:	e8 df 46 00 00       	call   80106213 <memmove>
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
80101b65:	68 9f 96 10 80       	push   $0x8010969f
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
80101b98:	68 ae 96 10 80       	push   $0x801096ae
80101b9d:	e8 c4 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101ba2:	83 ec 0c             	sub    $0xc,%esp
80101ba5:	68 60 22 11 80       	push   $0x80112260
80101baa:	e8 42 43 00 00       	call   80105ef1 <acquire>
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
80101bc9:	e8 a1 37 00 00       	call   8010536f <wakeup>
80101bce:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bd1:	83 ec 0c             	sub    $0xc,%esp
80101bd4:	68 60 22 11 80       	push   $0x80112260
80101bd9:	e8 7a 43 00 00       	call   80105f58 <release>
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
80101bed:	68 60 22 11 80       	push   $0x80112260
80101bf2:	e8 fa 42 00 00       	call   80105ef1 <acquire>
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
80101c3a:	68 b6 96 10 80       	push   $0x801096b6
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
80101c58:	68 60 22 11 80       	push   $0x80112260
80101c5d:	e8 f6 42 00 00       	call   80105f58 <release>
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
80101c8d:	68 60 22 11 80       	push   $0x80112260
80101c92:	e8 5a 42 00 00       	call   80105ef1 <acquire>
80101c97:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ca4:	83 ec 0c             	sub    $0xc,%esp
80101ca7:	ff 75 08             	pushl  0x8(%ebp)
80101caa:	e8 c0 36 00 00       	call   8010536f <wakeup>
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
80101cc4:	68 60 22 11 80       	push   $0x80112260
80101cc9:	e8 8a 42 00 00       	call   80105f58 <release>
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
80101e09:	68 c0 96 10 80       	push   $0x801096c0
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
80101fb6:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101fbd:	85 c0                	test   %eax,%eax
80101fbf:	75 0a                	jne    80101fcb <readi+0x49>
      return -1;
80101fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc6:	e9 0c 01 00 00       	jmp    801020d7 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fce:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fd2:	98                   	cwtl   
80101fd3:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
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
801020a0:	e8 6e 41 00 00       	call   80106213 <memmove>
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
8010210d:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80102114:	85 c0                	test   %eax,%eax
80102116:	75 0a                	jne    80102122 <writei+0x49>
      return -1;
80102118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010211d:	e9 3d 01 00 00       	jmp    8010225f <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102122:	8b 45 08             	mov    0x8(%ebp),%eax
80102125:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102129:	98                   	cwtl   
8010212a:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
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
801021f2:	e8 1c 40 00 00       	call   80106213 <memmove>
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
80102272:	e8 32 40 00 00       	call   801062a9 <strncmp>
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
80102292:	68 d3 96 10 80       	push   $0x801096d3
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
801022c1:	68 e5 96 10 80       	push   $0x801096e5
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
80102396:	68 e5 96 10 80       	push   $0x801096e5
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
801023d1:	e8 29 3f 00 00       	call   801062ff <strncpy>
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
801023fd:	68 f2 96 10 80       	push   $0x801096f2
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
80102473:	e8 9b 3d 00 00       	call   80106213 <memmove>
80102478:	83 c4 10             	add    $0x10,%esp
8010247b:	eb 26                	jmp    801024a3 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102480:	83 ec 04             	sub    $0x4,%esp
80102483:	50                   	push   %eax
80102484:	ff 75 f4             	pushl  -0xc(%ebp)
80102487:	ff 75 0c             	pushl  0xc(%ebp)
8010248a:	e8 84 3d 00 00       	call   80106213 <memmove>
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
801026df:	68 fa 96 10 80       	push   $0x801096fa
801026e4:	68 20 c6 10 80       	push   $0x8010c620
801026e9:	e8 e1 37 00 00       	call   80105ecf <initlock>
801026ee:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026f1:	83 ec 0c             	sub    $0xc,%esp
801026f4:	6a 0e                	push   $0xe
801026f6:	e8 da 18 00 00       	call   80103fd5 <picenable>
801026fb:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026fe:	a1 60 39 11 80       	mov    0x80113960,%eax
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
80102753:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
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
80102793:	68 fe 96 10 80       	push   $0x801096fe
80102798:	e8 c9 dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
8010279d:	8b 45 08             	mov    0x8(%ebp),%eax
801027a0:	8b 40 08             	mov    0x8(%eax),%eax
801027a3:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027a8:	76 0d                	jbe    801027b7 <idestart+0x33>
    panic("incorrect blockno");
801027aa:	83 ec 0c             	sub    $0xc,%esp
801027ad:	68 07 97 10 80       	push   $0x80109707
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
801027d6:	68 fe 96 10 80       	push   $0x801096fe
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
801028eb:	68 20 c6 10 80       	push   $0x8010c620
801028f0:	e8 fc 35 00 00       	call   80105ef1 <acquire>
801028f5:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028f8:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102900:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102904:	75 15                	jne    8010291b <ideintr+0x39>
    release(&idelock);
80102906:	83 ec 0c             	sub    $0xc,%esp
80102909:	68 20 c6 10 80       	push   $0x8010c620
8010290e:	e8 45 36 00 00       	call   80105f58 <release>
80102913:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102916:	e9 9a 00 00 00       	jmp    801029b5 <ideintr+0xd3>
  }
  idequeue = b->qnext;
8010291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291e:	8b 40 14             	mov    0x14(%eax),%eax
80102921:	a3 54 c6 10 80       	mov    %eax,0x8010c654

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
80102983:	e8 e7 29 00 00       	call   8010536f <wakeup>
80102988:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010298b:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102990:	85 c0                	test   %eax,%eax
80102992:	74 11                	je     801029a5 <ideintr+0xc3>
    idestart(idequeue);
80102994:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102999:	83 ec 0c             	sub    $0xc,%esp
8010299c:	50                   	push   %eax
8010299d:	e8 e2 fd ff ff       	call   80102784 <idestart>
801029a2:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801029a5:	83 ec 0c             	sub    $0xc,%esp
801029a8:	68 20 c6 10 80       	push   $0x8010c620
801029ad:	e8 a6 35 00 00       	call   80105f58 <release>
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
801029cc:	68 19 97 10 80       	push   $0x80109719
801029d1:	e8 90 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029d6:	8b 45 08             	mov    0x8(%ebp),%eax
801029d9:	8b 00                	mov    (%eax),%eax
801029db:	83 e0 06             	and    $0x6,%eax
801029de:	83 f8 02             	cmp    $0x2,%eax
801029e1:	75 0d                	jne    801029f0 <iderw+0x39>
    panic("iderw: nothing to do");
801029e3:	83 ec 0c             	sub    $0xc,%esp
801029e6:	68 2d 97 10 80       	push   $0x8010972d
801029eb:	e8 76 db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801029f0:	8b 45 08             	mov    0x8(%ebp),%eax
801029f3:	8b 40 04             	mov    0x4(%eax),%eax
801029f6:	85 c0                	test   %eax,%eax
801029f8:	74 16                	je     80102a10 <iderw+0x59>
801029fa:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801029ff:	85 c0                	test   %eax,%eax
80102a01:	75 0d                	jne    80102a10 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102a03:	83 ec 0c             	sub    $0xc,%esp
80102a06:	68 42 97 10 80       	push   $0x80109742
80102a0b:	e8 56 db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a10:	83 ec 0c             	sub    $0xc,%esp
80102a13:	68 20 c6 10 80       	push   $0x8010c620
80102a18:	e8 d4 34 00 00       	call   80105ef1 <acquire>
80102a1d:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a20:	8b 45 08             	mov    0x8(%ebp),%eax
80102a23:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a2a:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
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
80102a4f:	a1 54 c6 10 80       	mov    0x8010c654,%eax
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
80102a6c:	68 20 c6 10 80       	push   $0x8010c620
80102a71:	ff 75 08             	pushl  0x8(%ebp)
80102a74:	e8 a0 27 00 00       	call   80105219 <sleep>
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
80102a8c:	68 20 c6 10 80       	push   $0x8010c620
80102a91:	e8 c2 34 00 00       	call   80105f58 <release>
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
80102a9f:	a1 34 32 11 80       	mov    0x80113234,%eax
80102aa4:	8b 55 08             	mov    0x8(%ebp),%edx
80102aa7:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102aa9:	a1 34 32 11 80       	mov    0x80113234,%eax
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
80102ab6:	a1 34 32 11 80       	mov    0x80113234,%eax
80102abb:	8b 55 08             	mov    0x8(%ebp),%edx
80102abe:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102ac0:	a1 34 32 11 80       	mov    0x80113234,%eax
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
80102ad4:	a1 64 33 11 80       	mov    0x80113364,%eax
80102ad9:	85 c0                	test   %eax,%eax
80102adb:	0f 84 a0 00 00 00    	je     80102b81 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ae1:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
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
80102b10:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
80102b17:	0f b6 c0             	movzbl %al,%eax
80102b1a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b1d:	74 10                	je     80102b2f <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b1f:	83 ec 0c             	sub    $0xc,%esp
80102b22:	68 60 97 10 80       	push   $0x80109760
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
80102b87:	a1 64 33 11 80       	mov    0x80113364,%eax
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
80102be2:	68 92 97 10 80       	push   $0x80109792
80102be7:	68 40 32 11 80       	push   $0x80113240
80102bec:	e8 de 32 00 00       	call   80105ecf <initlock>
80102bf1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102bf4:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
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
80102c29:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
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
80102c85:	81 7d 08 3c 67 11 80 	cmpl   $0x8011673c,0x8(%ebp)
80102c8c:	72 12                	jb     80102ca0 <kfree+0x2d>
80102c8e:	ff 75 08             	pushl  0x8(%ebp)
80102c91:	e8 36 ff ff ff       	call   80102bcc <v2p>
80102c96:	83 c4 04             	add    $0x4,%esp
80102c99:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c9e:	76 0d                	jbe    80102cad <kfree+0x3a>
    panic("kfree");
80102ca0:	83 ec 0c             	sub    $0xc,%esp
80102ca3:	68 97 97 10 80       	push   $0x80109797
80102ca8:	e8 b9 d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102cad:	83 ec 04             	sub    $0x4,%esp
80102cb0:	68 00 10 00 00       	push   $0x1000
80102cb5:	6a 01                	push   $0x1
80102cb7:	ff 75 08             	pushl  0x8(%ebp)
80102cba:	e8 95 34 00 00       	call   80106154 <memset>
80102cbf:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cc2:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cc7:	85 c0                	test   %eax,%eax
80102cc9:	74 10                	je     80102cdb <kfree+0x68>
    acquire(&kmem.lock);
80102ccb:	83 ec 0c             	sub    $0xc,%esp
80102cce:	68 40 32 11 80       	push   $0x80113240
80102cd3:	e8 19 32 00 00       	call   80105ef1 <acquire>
80102cd8:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80102cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ce1:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cea:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cef:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102cf4:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cf9:	85 c0                	test   %eax,%eax
80102cfb:	74 10                	je     80102d0d <kfree+0x9a>
    release(&kmem.lock);
80102cfd:	83 ec 0c             	sub    $0xc,%esp
80102d00:	68 40 32 11 80       	push   $0x80113240
80102d05:	e8 4e 32 00 00       	call   80105f58 <release>
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
80102d16:	a1 74 32 11 80       	mov    0x80113274,%eax
80102d1b:	85 c0                	test   %eax,%eax
80102d1d:	74 10                	je     80102d2f <kalloc+0x1f>
    acquire(&kmem.lock);
80102d1f:	83 ec 0c             	sub    $0xc,%esp
80102d22:	68 40 32 11 80       	push   $0x80113240
80102d27:	e8 c5 31 00 00       	call   80105ef1 <acquire>
80102d2c:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d2f:	a1 78 32 11 80       	mov    0x80113278,%eax
80102d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d3b:	74 0a                	je     80102d47 <kalloc+0x37>
    kmem.freelist = r->next;
80102d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d40:	8b 00                	mov    (%eax),%eax
80102d42:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102d47:	a1 74 32 11 80       	mov    0x80113274,%eax
80102d4c:	85 c0                	test   %eax,%eax
80102d4e:	74 10                	je     80102d60 <kalloc+0x50>
    release(&kmem.lock);
80102d50:	83 ec 0c             	sub    $0xc,%esp
80102d53:	68 40 32 11 80       	push   $0x80113240
80102d58:	e8 fb 31 00 00       	call   80105f58 <release>
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
80102dc5:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dca:	83 c8 40             	or     $0x40,%eax
80102dcd:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
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
80102de8:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
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
80102e05:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e0a:	0f b6 00             	movzbl (%eax),%eax
80102e0d:	83 c8 40             	or     $0x40,%eax
80102e10:	0f b6 c0             	movzbl %al,%eax
80102e13:	f7 d0                	not    %eax
80102e15:	89 c2                	mov    %eax,%edx
80102e17:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e1c:	21 d0                	and    %edx,%eax
80102e1e:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102e23:	b8 00 00 00 00       	mov    $0x0,%eax
80102e28:	e9 a2 00 00 00       	jmp    80102ecf <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e2d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e32:	83 e0 40             	and    $0x40,%eax
80102e35:	85 c0                	test   %eax,%eax
80102e37:	74 14                	je     80102e4d <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e39:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e40:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e45:	83 e0 bf             	and    $0xffffffbf,%eax
80102e48:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e50:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e55:	0f b6 00             	movzbl (%eax),%eax
80102e58:	0f b6 d0             	movzbl %al,%edx
80102e5b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e60:	09 d0                	or     %edx,%eax
80102e62:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e6a:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102e6f:	0f b6 00             	movzbl (%eax),%eax
80102e72:	0f b6 d0             	movzbl %al,%edx
80102e75:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e7a:	31 d0                	xor    %edx,%eax
80102e7c:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e81:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e86:	83 e0 03             	and    $0x3,%eax
80102e89:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e93:	01 d0                	add    %edx,%eax
80102e95:	0f b6 00             	movzbl (%eax),%eax
80102e98:	0f b6 c0             	movzbl %al,%eax
80102e9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e9e:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
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
80102f39:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f3e:	8b 55 08             	mov    0x8(%ebp),%edx
80102f41:	c1 e2 02             	shl    $0x2,%edx
80102f44:	01 c2                	add    %eax,%edx
80102f46:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f49:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f4b:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f50:	83 c0 20             	add    $0x20,%eax
80102f53:	8b 00                	mov    (%eax),%eax
}
80102f55:	90                   	nop
80102f56:	5d                   	pop    %ebp
80102f57:	c3                   	ret    

80102f58 <lapicinit>:

void
lapicinit(void)
{
80102f58:	55                   	push   %ebp
80102f59:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102f5b:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80102fce:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
80103050:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
8010308a:	a1 60 c6 10 80       	mov    0x8010c660,%eax
8010308f:	8d 50 01             	lea    0x1(%eax),%edx
80103092:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80103098:	85 c0                	test   %eax,%eax
8010309a:	75 14                	jne    801030b0 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
8010309c:	8b 45 04             	mov    0x4(%ebp),%eax
8010309f:	83 ec 08             	sub    $0x8,%esp
801030a2:	50                   	push   %eax
801030a3:	68 a0 97 10 80       	push   $0x801097a0
801030a8:	e8 19 d3 ff ff       	call   801003c6 <cprintf>
801030ad:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801030b0:	a1 7c 32 11 80       	mov    0x8011327c,%eax
801030b5:	85 c0                	test   %eax,%eax
801030b7:	74 0f                	je     801030c8 <cpunum+0x52>
    return lapic[ID]>>24;
801030b9:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
801030d2:	a1 7c 32 11 80       	mov    0x8011327c,%eax
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
801032ce:	e8 e8 2e 00 00       	call   801061bb <memcmp>
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
801033e2:	68 cc 97 10 80       	push   $0x801097cc
801033e7:	68 80 32 11 80       	push   $0x80113280
801033ec:	e8 de 2a 00 00       	call   80105ecf <initlock>
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
80103409:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
8010340e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103411:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = dev;
80103416:	8b 45 08             	mov    0x8(%ebp),%eax
80103419:	a3 c4 32 11 80       	mov    %eax,0x801132c4
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
80103438:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010343e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103441:	01 d0                	add    %edx,%eax
80103443:	83 c0 01             	add    $0x1,%eax
80103446:	89 c2                	mov    %eax,%edx
80103448:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010344d:	83 ec 08             	sub    $0x8,%esp
80103450:	52                   	push   %edx
80103451:	50                   	push   %eax
80103452:	e8 5f cd ff ff       	call   801001b6 <bread>
80103457:	83 c4 10             	add    $0x10,%esp
8010345a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010345d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103460:	83 c0 10             	add    $0x10,%eax
80103463:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010346a:	89 c2                	mov    %eax,%edx
8010346c:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
80103497:	e8 77 2d 00 00       	call   80106213 <memmove>
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
801034cd:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
801034e4:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801034e9:	89 c2                	mov    %eax,%edx
801034eb:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
8010350e:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
80103513:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010351a:	eb 1b                	jmp    80103537 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010351c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010351f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103522:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103526:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103529:	83 c2 10             	add    $0x10,%edx
8010352c:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103533:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103537:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
80103558:	a1 b4 32 11 80       	mov    0x801132b4,%eax
8010355d:	89 c2                	mov    %eax,%edx
8010355f:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
8010357d:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
80103583:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103586:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103588:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010358f:	eb 1b                	jmp    801035ac <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103594:	83 c0 10             	add    $0x10,%eax
80103597:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
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
801035ac:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
801035e5:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
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
80103600:	68 80 32 11 80       	push   $0x80113280
80103605:	e8 e7 28 00 00       	call   80105ef1 <acquire>
8010360a:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010360d:	a1 c0 32 11 80       	mov    0x801132c0,%eax
80103612:	85 c0                	test   %eax,%eax
80103614:	74 17                	je     8010362d <begin_op+0x36>
      sleep(&log, &log.lock);
80103616:	83 ec 08             	sub    $0x8,%esp
80103619:	68 80 32 11 80       	push   $0x80113280
8010361e:	68 80 32 11 80       	push   $0x80113280
80103623:	e8 f1 1b 00 00       	call   80105219 <sleep>
80103628:	83 c4 10             	add    $0x10,%esp
8010362b:	eb e0                	jmp    8010360d <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010362d:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
80103633:	a1 bc 32 11 80       	mov    0x801132bc,%eax
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
8010364e:	68 80 32 11 80       	push   $0x80113280
80103653:	68 80 32 11 80       	push   $0x80113280
80103658:	e8 bc 1b 00 00       	call   80105219 <sleep>
8010365d:	83 c4 10             	add    $0x10,%esp
80103660:	eb ab                	jmp    8010360d <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103662:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103667:	83 c0 01             	add    $0x1,%eax
8010366a:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
8010366f:	83 ec 0c             	sub    $0xc,%esp
80103672:	68 80 32 11 80       	push   $0x80113280
80103677:	e8 dc 28 00 00       	call   80105f58 <release>
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
80103693:	68 80 32 11 80       	push   $0x80113280
80103698:	e8 54 28 00 00       	call   80105ef1 <acquire>
8010369d:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801036a0:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801036a5:	83 e8 01             	sub    $0x1,%eax
801036a8:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
801036ad:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801036b2:	85 c0                	test   %eax,%eax
801036b4:	74 0d                	je     801036c3 <end_op+0x40>
    panic("log.committing");
801036b6:	83 ec 0c             	sub    $0xc,%esp
801036b9:	68 d0 97 10 80       	push   $0x801097d0
801036be:	e8 a3 ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801036c3:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801036c8:	85 c0                	test   %eax,%eax
801036ca:	75 13                	jne    801036df <end_op+0x5c>
    do_commit = 1;
801036cc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036d3:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
801036da:	00 00 00 
801036dd:	eb 10                	jmp    801036ef <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801036df:	83 ec 0c             	sub    $0xc,%esp
801036e2:	68 80 32 11 80       	push   $0x80113280
801036e7:	e8 83 1c 00 00       	call   8010536f <wakeup>
801036ec:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036ef:	83 ec 0c             	sub    $0xc,%esp
801036f2:	68 80 32 11 80       	push   $0x80113280
801036f7:	e8 5c 28 00 00       	call   80105f58 <release>
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
8010370d:	68 80 32 11 80       	push   $0x80113280
80103712:	e8 da 27 00 00       	call   80105ef1 <acquire>
80103717:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010371a:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
80103721:	00 00 00 
    wakeup(&log);
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 80 32 11 80       	push   $0x80113280
8010372c:	e8 3e 1c 00 00       	call   8010536f <wakeup>
80103731:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103734:	83 ec 0c             	sub    $0xc,%esp
80103737:	68 80 32 11 80       	push   $0x80113280
8010373c:	e8 17 28 00 00       	call   80105f58 <release>
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
80103759:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103762:	01 d0                	add    %edx,%eax
80103764:	83 c0 01             	add    $0x1,%eax
80103767:	89 c2                	mov    %eax,%edx
80103769:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010376e:	83 ec 08             	sub    $0x8,%esp
80103771:	52                   	push   %edx
80103772:	50                   	push   %eax
80103773:	e8 3e ca ff ff       	call   801001b6 <bread>
80103778:	83 c4 10             	add    $0x10,%esp
8010377b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010377e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103781:	83 c0 10             	add    $0x10,%eax
80103784:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010378b:	89 c2                	mov    %eax,%edx
8010378d:	a1 c4 32 11 80       	mov    0x801132c4,%eax
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
801037b8:	e8 56 2a 00 00       	call   80106213 <memmove>
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
801037ee:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
80103805:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010380a:	85 c0                	test   %eax,%eax
8010380c:	7e 1e                	jle    8010382c <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010380e:	e8 34 ff ff ff       	call   80103747 <write_log>
    write_head();    // Write header to disk -- the real commit
80103813:	e8 3a fd ff ff       	call   80103552 <write_head>
    install_trans(); // Now install writes to home locations
80103818:	e8 09 fc ff ff       	call   80103426 <install_trans>
    log.lh.n = 0; 
8010381d:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
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
80103835:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010383a:	83 f8 1d             	cmp    $0x1d,%eax
8010383d:	7f 12                	jg     80103851 <log_write+0x22>
8010383f:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103844:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
8010384a:	83 ea 01             	sub    $0x1,%edx
8010384d:	39 d0                	cmp    %edx,%eax
8010384f:	7c 0d                	jl     8010385e <log_write+0x2f>
    panic("too big a transaction");
80103851:	83 ec 0c             	sub    $0xc,%esp
80103854:	68 df 97 10 80       	push   $0x801097df
80103859:	e8 08 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010385e:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103863:	85 c0                	test   %eax,%eax
80103865:	7f 0d                	jg     80103874 <log_write+0x45>
    panic("log_write outside of trans");
80103867:	83 ec 0c             	sub    $0xc,%esp
8010386a:	68 f5 97 10 80       	push   $0x801097f5
8010386f:	e8 f2 cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103874:	83 ec 0c             	sub    $0xc,%esp
80103877:	68 80 32 11 80       	push   $0x80113280
8010387c:	e8 70 26 00 00       	call   80105ef1 <acquire>
80103881:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103884:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010388b:	eb 1d                	jmp    801038aa <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010388d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103890:	83 c0 10             	add    $0x10,%eax
80103893:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
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
801038aa:	a1 c8 32 11 80       	mov    0x801132c8,%eax
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
801038c5:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
801038cc:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801038d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038d4:	75 0d                	jne    801038e3 <log_write+0xb4>
    log.lh.n++;
801038d6:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801038db:	83 c0 01             	add    $0x1,%eax
801038de:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
801038e3:	8b 45 08             	mov    0x8(%ebp),%eax
801038e6:	8b 00                	mov    (%eax),%eax
801038e8:	83 c8 04             	or     $0x4,%eax
801038eb:	89 c2                	mov    %eax,%edx
801038ed:	8b 45 08             	mov    0x8(%ebp),%eax
801038f0:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038f2:	83 ec 0c             	sub    $0xc,%esp
801038f5:	68 80 32 11 80       	push   $0x80113280
801038fa:	e8 59 26 00 00       	call   80105f58 <release>
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
80103952:	68 3c 67 11 80       	push   $0x8011673c
80103957:	e8 7d f2 ff ff       	call   80102bd9 <kinit1>
8010395c:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
8010395f:	e8 79 54 00 00       	call   80108ddd <kvmalloc>
  mpinit();        // collect info about this machine
80103964:	e8 43 04 00 00       	call   80103dac <mpinit>
  lapicinit();
80103969:	e8 ea f5 ff ff       	call   80102f58 <lapicinit>
  seginit();       // set up segments
8010396e:	e8 13 4e 00 00       	call   80108786 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103973:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103979:	0f b6 00             	movzbl (%eax),%eax
8010397c:	0f b6 c0             	movzbl %al,%eax
8010397f:	83 ec 08             	sub    $0x8,%esp
80103982:	50                   	push   %eax
80103983:	68 10 98 10 80       	push   $0x80109810
80103988:	e8 39 ca ff ff       	call   801003c6 <cprintf>
8010398d:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103990:	e8 6d 06 00 00       	call   80104002 <picinit>
  ioapicinit();    // another interrupt controller
80103995:	e8 34 f1 ff ff       	call   80102ace <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010399a:	e8 24 d2 ff ff       	call   80100bc3 <consoleinit>
  uartinit();      // serial port
8010399f:	e8 3e 41 00 00       	call   80107ae2 <uartinit>
  pinit();         // process table
801039a4:	e8 5d 0b 00 00       	call   80104506 <pinit>
  tvinit();        // trap vectors
801039a9:	e8 30 3d 00 00       	call   801076de <tvinit>
  binit();         // buffer cache
801039ae:	e8 81 c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039b3:	e8 67 d6 ff ff       	call   8010101f <fileinit>
  ideinit();       // disk
801039b8:	e8 19 ed ff ff       	call   801026d6 <ideinit>
  if(!ismp)
801039bd:	a1 64 33 11 80       	mov    0x80113364,%eax
801039c2:	85 c0                	test   %eax,%eax
801039c4:	75 05                	jne    801039cb <main+0x92>
    timerinit();   // uniprocessor timer
801039c6:	e8 64 3c 00 00       	call   8010762f <timerinit>
  startothers();   // start other processors
801039cb:	e8 7f 00 00 00       	call   80103a4f <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039d0:	83 ec 08             	sub    $0x8,%esp
801039d3:	68 00 00 00 8e       	push   $0x8e000000
801039d8:	68 00 00 40 80       	push   $0x80400000
801039dd:	e8 30 f2 ff ff       	call   80102c12 <kinit2>
801039e2:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039e5:	e8 f3 0c 00 00       	call   801046dd <userinit>
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
801039f5:	e8 fb 53 00 00       	call   80108df5 <switchkvm>
  seginit();
801039fa:	e8 87 4d 00 00       	call   80108786 <seginit>
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
80103a1f:	68 27 98 10 80       	push   $0x80109827
80103a24:	e8 9d c9 ff ff       	call   801003c6 <cprintf>
80103a29:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a2c:	e8 0e 3e 00 00       	call   8010783f <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a31:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a37:	05 a8 00 00 00       	add    $0xa8,%eax
80103a3c:	83 ec 08             	sub    $0x8,%esp
80103a3f:	6a 01                	push   $0x1
80103a41:	50                   	push   %eax
80103a42:	e8 d8 fe ff ff       	call   8010391f <xchg>
80103a47:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a4a:	e8 1c 15 00 00       	call   80104f6b <scheduler>

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
80103a6f:	68 2c c5 10 80       	push   $0x8010c52c
80103a74:	ff 75 f0             	pushl  -0x10(%ebp)
80103a77:	e8 97 27 00 00       	call   80106213 <memmove>
80103a7c:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a7f:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
80103a86:	e9 90 00 00 00       	jmp    80103b1b <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a8b:	e8 e6 f5 ff ff       	call   80103076 <cpunum>
80103a90:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a96:	05 80 33 11 80       	add    $0x80113380,%eax
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
80103ace:	68 00 b0 10 80       	push   $0x8010b000
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
80103b1b:	a1 60 39 11 80       	mov    0x80113960,%eax
80103b20:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b26:	05 80 33 11 80       	add    $0x80113380,%eax
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
80103b86:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103b8b:	89 c2                	mov    %eax,%edx
80103b8d:	b8 80 33 11 80       	mov    $0x80113380,%eax
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
80103c05:	68 38 98 10 80       	push   $0x80109838
80103c0a:	ff 75 f4             	pushl  -0xc(%ebp)
80103c0d:	e8 a9 25 00 00       	call   801061bb <memcmp>
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
80103d43:	68 3d 98 10 80       	push   $0x8010983d
80103d48:	ff 75 f0             	pushl  -0x10(%ebp)
80103d4b:	e8 6b 24 00 00       	call   801061bb <memcmp>
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
80103db2:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103db9:	33 11 80 
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
80103dd8:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103ddf:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de5:	8b 40 24             	mov    0x24(%eax),%eax
80103de8:	a3 7c 32 11 80       	mov    %eax,0x8011327c
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
80103e1f:	8b 04 85 80 98 10 80 	mov    -0x7fef6780(,%eax,4),%eax
80103e26:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e31:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e35:	0f b6 d0             	movzbl %al,%edx
80103e38:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e3d:	39 c2                	cmp    %eax,%edx
80103e3f:	74 2b                	je     80103e6c <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e41:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e44:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e48:	0f b6 d0             	movzbl %al,%edx
80103e4b:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e50:	83 ec 04             	sub    $0x4,%esp
80103e53:	52                   	push   %edx
80103e54:	50                   	push   %eax
80103e55:	68 42 98 10 80       	push   $0x80109842
80103e5a:	e8 67 c5 ff ff       	call   801003c6 <cprintf>
80103e5f:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e62:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
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
80103e7d:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e82:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e88:	05 80 33 11 80       	add    $0x80113380,%eax
80103e8d:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103e92:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e97:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103e9d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ea3:	05 80 33 11 80       	add    $0x80113380,%eax
80103ea8:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103eaa:	a1 60 39 11 80       	mov    0x80113960,%eax
80103eaf:	83 c0 01             	add    $0x1,%eax
80103eb2:	a3 60 39 11 80       	mov    %eax,0x80113960
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
80103eca:	a2 60 33 11 80       	mov    %al,0x80113360
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
80103ee8:	68 60 98 10 80       	push   $0x80109860
80103eed:	e8 d4 c4 ff ff       	call   801003c6 <cprintf>
80103ef2:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103ef5:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
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
80103f0b:	a1 64 33 11 80       	mov    0x80113364,%eax
80103f10:	85 c0                	test   %eax,%eax
80103f12:	75 1d                	jne    80103f31 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f14:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103f1b:	00 00 00 
    lapic = 0;
80103f1e:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103f25:	00 00 00 
    ioapicid = 0;
80103f28:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
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
80103fa1:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
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
80103fea:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
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
801040c8:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801040cf:	66 83 f8 ff          	cmp    $0xffff,%ax
801040d3:	74 13                	je     801040e8 <picinit+0xe6>
    picsetmask(irqmask);
801040d5:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
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
80104189:	68 94 98 10 80       	push   $0x80109894
8010418e:	50                   	push   %eax
8010418f:	e8 3b 1d 00 00       	call   80105ecf <initlock>
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
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

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
8010424b:	e8 a1 1c 00 00       	call   80105ef1 <acquire>
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
80104272:	e8 f8 10 00 00       	call   8010536f <wakeup>
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
80104295:	e8 d5 10 00 00       	call   8010536f <wakeup>
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
801042be:	e8 95 1c 00 00       	call   80105f58 <release>
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
801042dd:	e8 76 1c 00 00       	call   80105f58 <release>
801042e2:	83 c4 10             	add    $0x10,%esp
}
801042e5:	90                   	nop
801042e6:	c9                   	leave  
801042e7:	c3                   	ret    

801042e8 <pipewrite>:

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
801042f5:	e8 f7 1b 00 00       	call   80105ef1 <acquire>
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
8010432a:	e8 29 1c 00 00       	call   80105f58 <release>
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
80104348:	e8 22 10 00 00       	call   8010536f <wakeup>
8010434d:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104350:	8b 45 08             	mov    0x8(%ebp),%eax
80104353:	8b 55 08             	mov    0x8(%ebp),%edx
80104356:	81 c2 38 02 00 00    	add    $0x238,%edx
8010435c:	83 ec 08             	sub    $0x8,%esp
8010435f:	50                   	push   %eax
80104360:	52                   	push   %edx
80104361:	e8 b3 0e 00 00       	call   80105219 <sleep>
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
801043ca:	e8 a0 0f 00 00       	call   8010536f <wakeup>
801043cf:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043d2:	8b 45 08             	mov    0x8(%ebp),%eax
801043d5:	83 ec 0c             	sub    $0xc,%esp
801043d8:	50                   	push   %eax
801043d9:	e8 7a 1b 00 00       	call   80105f58 <release>
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
801043f4:	e8 f8 1a 00 00       	call   80105ef1 <acquire>
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
80104412:	e8 41 1b 00 00       	call   80105f58 <release>
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
80104435:	e8 df 0d 00 00       	call   80105219 <sleep>
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
801044c9:	e8 a1 0e 00 00       	call   8010536f <wakeup>
801044ce:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044d1:	8b 45 08             	mov    0x8(%ebp),%eax
801044d4:	83 ec 0c             	sub    $0xc,%esp
801044d7:	50                   	push   %eax
801044d8:	e8 7b 1a 00 00       	call   80105f58 <release>
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
static void exit_helper(struct proc** sList);
static void wait_helper(struct proc** sList, int* hk);

void
pinit(void)
{
80104506:	55                   	push   %ebp
80104507:	89 e5                	mov    %esp,%ebp
80104509:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010450c:	83 ec 08             	sub    $0x8,%esp
8010450f:	68 9c 98 10 80       	push   $0x8010989c
80104514:	68 80 39 11 80       	push   $0x80113980
80104519:	e8 b1 19 00 00       	call   80105ecf <initlock>
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
8010452d:	68 80 39 11 80       	push   $0x80113980
80104532:	e8 ba 19 00 00       	call   80105ef1 <acquire>
80104537:	83 c4 10             	add    $0x10,%esp
  #else
  // Check to make sure the ptable has free procs available
  // remove from list wont return a negative number in this
  // case because we check p and the list against null before
  // passing it in to the function. 
  p = ptable.pLists.free;
8010453a:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
8010453f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p) {
80104542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104546:	0f 84 86 00 00 00    	je     801045d2 <allocproc+0xae>
    remove_from_list(&ptable.pLists.free, p);
8010454c:	83 ec 08             	sub    $0x8,%esp
8010454f:	ff 75 f4             	pushl  -0xc(%ebp)
80104552:	68 b4 5e 11 80       	push   $0x80115eb4
80104557:	e8 41 17 00 00       	call   80105c9d <remove_from_list>
8010455c:	83 c4 10             	add    $0x10,%esp
    assert_state(p, UNUSED);
8010455f:	83 ec 08             	sub    $0x8,%esp
80104562:	6a 00                	push   $0x0
80104564:	ff 75 f4             	pushl  -0xc(%ebp)
80104567:	e8 10 17 00 00       	call   80105c7c <assert_state>
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
80104582:	68 b8 5e 11 80       	push   $0x80115eb8
80104587:	e8 bd 17 00 00       	call   80105d49 <add_to_list>
8010458c:	83 c4 10             	add    $0x10,%esp
  #endif
  p->pid = nextpid++;
8010458f:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104594:	8d 50 01             	lea    0x1(%eax),%edx
80104597:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010459d:	89 c2                	mov    %eax,%edx
8010459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a2:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
801045a5:	83 ec 0c             	sub    $0xc,%esp
801045a8:	68 80 39 11 80       	push   $0x80113980
801045ad:	e8 a6 19 00 00       	call   80105f58 <release>
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
801045d5:	68 80 39 11 80       	push   $0x80113980
801045da:	e8 79 19 00 00       	call   80105f58 <release>
801045df:	83 c4 10             	add    $0x10,%esp
  return 0;
801045e2:	b8 00 00 00 00       	mov    $0x0,%eax
801045e7:	e9 ef 00 00 00       	jmp    801046db <allocproc+0x1b7>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    acquire(&ptable.lock);
801045ec:	83 ec 0c             	sub    $0xc,%esp
801045ef:	68 80 39 11 80       	push   $0x80113980
801045f4:	e8 f8 18 00 00       	call   80105ef1 <acquire>
801045f9:	83 c4 10             	add    $0x10,%esp
    #ifdef CS333_P3P4
    remove_from_list(&ptable.pLists.embryo, p);
801045fc:	83 ec 08             	sub    $0x8,%esp
801045ff:	ff 75 f4             	pushl  -0xc(%ebp)
80104602:	68 b8 5e 11 80       	push   $0x80115eb8
80104607:	e8 91 16 00 00       	call   80105c9d <remove_from_list>
8010460c:	83 c4 10             	add    $0x10,%esp
    assert_state(p, EMBRYO);
8010460f:	83 ec 08             	sub    $0x8,%esp
80104612:	6a 01                	push   $0x1
80104614:	ff 75 f4             	pushl  -0xc(%ebp)
80104617:	e8 60 16 00 00       	call   80105c7c <assert_state>
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
80104631:	68 b4 5e 11 80       	push   $0x80115eb4
80104636:	e8 0e 17 00 00       	call   80105d49 <add_to_list>
8010463b:	83 c4 10             	add    $0x10,%esp
    #endif
    release(&ptable.lock);
8010463e:	83 ec 0c             	sub    $0xc,%esp
80104641:	68 80 39 11 80       	push   $0x80113980
80104646:	e8 0d 19 00 00       	call   80105f58 <release>
8010464b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010464e:	b8 00 00 00 00       	mov    $0x0,%eax
80104653:	e9 83 00 00 00       	jmp    801046db <allocproc+0x1b7>
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
80104677:	ba 8c 76 10 80       	mov    $0x8010768c,%edx
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
8010469c:	e8 b3 1a 00 00       	call   80106154 <memset>
801046a1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801046a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a7:	8b 40 1c             	mov    0x1c(%eax),%eax
801046aa:	ba d3 51 10 80       	mov    $0x801051d3,%edx
801046af:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // My code Allocate start ticks to global ticks variable
801046b2:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
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
  return p;
801046d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801046db:	c9                   	leave  
801046dc:	c3                   	ret    

801046dd <userinit>:

// Set up first user process.
void
userinit(void)
{
801046dd:	55                   	push   %ebp
801046de:	89 e5                	mov    %esp,%ebp
801046e0:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  acquire(&ptable.lock);
801046e3:	83 ec 0c             	sub    $0xc,%esp
801046e6:	68 80 39 11 80       	push   $0x80113980
801046eb:	e8 01 18 00 00       	call   80105ef1 <acquire>
801046f0:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.free = 0;
801046f3:	c7 05 b4 5e 11 80 00 	movl   $0x0,0x80115eb4
801046fa:	00 00 00 
  ptable.pLists.embryo = 0;
801046fd:	c7 05 b8 5e 11 80 00 	movl   $0x0,0x80115eb8
80104704:	00 00 00 
  ptable.pLists.ready = 0;
80104707:	c7 05 bc 5e 11 80 00 	movl   $0x0,0x80115ebc
8010470e:	00 00 00 
  ptable.pLists.running = 0;
80104711:	c7 05 c0 5e 11 80 00 	movl   $0x0,0x80115ec0
80104718:	00 00 00 
  ptable.pLists.sleep = 0;
8010471b:	c7 05 c4 5e 11 80 00 	movl   $0x0,0x80115ec4
80104722:	00 00 00 
  ptable.pLists.zombie = 0;
80104725:	c7 05 c8 5e 11 80 00 	movl   $0x0,0x80115ec8
8010472c:	00 00 00 

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010472f:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104736:	eb 1c                	jmp    80104754 <userinit+0x77>
    add_to_list(&ptable.pLists.free, UNUSED, p);  
80104738:	83 ec 04             	sub    $0x4,%esp
8010473b:	ff 75 f4             	pushl  -0xc(%ebp)
8010473e:	6a 00                	push   $0x0
80104740:	68 b4 5e 11 80       	push   $0x80115eb4
80104745:	e8 ff 15 00 00       	call   80105d49 <add_to_list>
8010474a:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.running = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010474d:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104754:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
8010475b:	72 db                	jb     80104738 <userinit+0x5b>
    add_to_list(&ptable.pLists.free, UNUSED, p);  
  release(&ptable.lock);
8010475d:	83 ec 0c             	sub    $0xc,%esp
80104760:	68 80 39 11 80       	push   $0x80113980
80104765:	e8 ee 17 00 00       	call   80105f58 <release>
8010476a:	83 c4 10             	add    $0x10,%esp

  p = allocproc();
8010476d:	e8 b2 fd ff ff       	call   80104524 <allocproc>
80104772:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104778:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
8010477d:	e8 a9 45 00 00       	call   80108d2b <setupkvm>
80104782:	89 c2                	mov    %eax,%edx
80104784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104787:	89 50 04             	mov    %edx,0x4(%eax)
8010478a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478d:	8b 40 04             	mov    0x4(%eax),%eax
80104790:	85 c0                	test   %eax,%eax
80104792:	75 0d                	jne    801047a1 <userinit+0xc4>
    panic("userinit: out of memory?");
80104794:	83 ec 0c             	sub    $0xc,%esp
80104797:	68 a3 98 10 80       	push   $0x801098a3
8010479c:	e8 c5 bd ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047a1:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a9:	8b 40 04             	mov    0x4(%eax),%eax
801047ac:	83 ec 04             	sub    $0x4,%esp
801047af:	52                   	push   %edx
801047b0:	68 00 c5 10 80       	push   $0x8010c500
801047b5:	50                   	push   %eax
801047b6:	e8 ca 47 00 00       	call   80108f85 <inituvm>
801047bb:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801047be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c1:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801047c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ca:	8b 40 18             	mov    0x18(%eax),%eax
801047cd:	83 ec 04             	sub    $0x4,%esp
801047d0:	6a 4c                	push   $0x4c
801047d2:	6a 00                	push   $0x0
801047d4:	50                   	push   %eax
801047d5:	e8 7a 19 00 00       	call   80106154 <memset>
801047da:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801047dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e0:	8b 40 18             	mov    0x18(%eax),%eax
801047e3:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801047e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ec:	8b 40 18             	mov    0x18(%eax),%eax
801047ef:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801047f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f8:	8b 40 18             	mov    0x18(%eax),%eax
801047fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047fe:	8b 52 18             	mov    0x18(%edx),%edx
80104801:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104805:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480c:	8b 40 18             	mov    0x18(%eax),%eax
8010480f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104812:	8b 52 18             	mov    0x18(%edx),%edx
80104815:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104819:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010481d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104820:	8b 40 18             	mov    0x18(%eax),%eax
80104823:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010482a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482d:	8b 40 18             	mov    0x18(%eax),%eax
80104830:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483a:	8b 40 18             	mov    0x18(%eax),%eax
8010483d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->uid = DEFAULTUID; // p2
80104844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104847:	c7 80 80 00 00 00 0a 	movl   $0xa,0x80(%eax)
8010484e:	00 00 00 
  p->gid = DEFAULTGID; // p2
80104851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104854:	c7 80 84 00 00 00 0a 	movl   $0xa,0x84(%eax)
8010485b:	00 00 00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010485e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104861:	83 c0 6c             	add    $0x6c,%eax
80104864:	83 ec 04             	sub    $0x4,%esp
80104867:	6a 10                	push   $0x10
80104869:	68 bc 98 10 80       	push   $0x801098bc
8010486e:	50                   	push   %eax
8010486f:	e8 e3 1a 00 00       	call   80106357 <safestrcpy>
80104874:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104877:	83 ec 0c             	sub    $0xc,%esp
8010487a:	68 c5 98 10 80       	push   $0x801098c5
8010487f:	e8 4e dd ff ff       	call   801025d2 <namei>
80104884:	83 c4 10             	add    $0x10,%esp
80104887:	89 c2                	mov    %eax,%edx
80104889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010488c:	89 50 68             	mov    %edx,0x68(%eax)

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
8010488f:	83 ec 0c             	sub    $0xc,%esp
80104892:	68 80 39 11 80       	push   $0x80113980
80104897:	e8 55 16 00 00       	call   80105ef1 <acquire>
8010489c:	83 c4 10             	add    $0x10,%esp
  remove_from_list(&ptable.pLists.embryo, p);
8010489f:	83 ec 08             	sub    $0x8,%esp
801048a2:	ff 75 f4             	pushl  -0xc(%ebp)
801048a5:	68 b8 5e 11 80       	push   $0x80115eb8
801048aa:	e8 ee 13 00 00       	call   80105c9d <remove_from_list>
801048af:	83 c4 10             	add    $0x10,%esp
  assert_state(p, EMBRYO);
801048b2:	83 ec 08             	sub    $0x8,%esp
801048b5:	6a 01                	push   $0x1
801048b7:	ff 75 f4             	pushl  -0xc(%ebp)
801048ba:	e8 bd 13 00 00       	call   80105c7c <assert_state>
801048bf:	83 c4 10             	add    $0x10,%esp
  #endif
  p->state = RUNNABLE;
801048c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  // Since it is the first process to be made I directly add to
  // the front of the ready list. Ocurrences after this use the
  // add to ready function. 
  ptable.pLists.ready = p;
801048cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048cf:	a3 bc 5e 11 80       	mov    %eax,0x80115ebc
  p->next = 0;
801048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d7:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801048de:	00 00 00 
  release(&ptable.lock);
801048e1:	83 ec 0c             	sub    $0xc,%esp
801048e4:	68 80 39 11 80       	push   $0x80113980
801048e9:	e8 6a 16 00 00       	call   80105f58 <release>
801048ee:	83 c4 10             	add    $0x10,%esp
  #endif
}
801048f1:	90                   	nop
801048f2:	c9                   	leave  
801048f3:	c3                   	ret    

801048f4 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801048fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104900:	8b 00                	mov    (%eax),%eax
80104902:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104905:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104909:	7e 31                	jle    8010493c <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010490b:	8b 55 08             	mov    0x8(%ebp),%edx
8010490e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104911:	01 c2                	add    %eax,%edx
80104913:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104919:	8b 40 04             	mov    0x4(%eax),%eax
8010491c:	83 ec 04             	sub    $0x4,%esp
8010491f:	52                   	push   %edx
80104920:	ff 75 f4             	pushl  -0xc(%ebp)
80104923:	50                   	push   %eax
80104924:	e8 a9 47 00 00       	call   801090d2 <allocuvm>
80104929:	83 c4 10             	add    $0x10,%esp
8010492c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010492f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104933:	75 3e                	jne    80104973 <growproc+0x7f>
      return -1;
80104935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010493a:	eb 59                	jmp    80104995 <growproc+0xa1>
  } else if(n < 0){
8010493c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104940:	79 31                	jns    80104973 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104942:	8b 55 08             	mov    0x8(%ebp),%edx
80104945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104948:	01 c2                	add    %eax,%edx
8010494a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104950:	8b 40 04             	mov    0x4(%eax),%eax
80104953:	83 ec 04             	sub    $0x4,%esp
80104956:	52                   	push   %edx
80104957:	ff 75 f4             	pushl  -0xc(%ebp)
8010495a:	50                   	push   %eax
8010495b:	e8 3b 48 00 00       	call   8010919b <deallocuvm>
80104960:	83 c4 10             	add    $0x10,%esp
80104963:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010496a:	75 07                	jne    80104973 <growproc+0x7f>
      return -1;
8010496c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104971:	eb 22                	jmp    80104995 <growproc+0xa1>
  }
  proc->sz = sz;
80104973:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104979:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010497c:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010497e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104984:	83 ec 0c             	sub    $0xc,%esp
80104987:	50                   	push   %eax
80104988:	e8 85 44 00 00       	call   80108e12 <switchuvm>
8010498d:	83 c4 10             	add    $0x10,%esp
  return 0;
80104990:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104995:	c9                   	leave  
80104996:	c3                   	ret    

80104997 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104997:	55                   	push   %ebp
80104998:	89 e5                	mov    %esp,%ebp
8010499a:	57                   	push   %edi
8010499b:	56                   	push   %esi
8010499c:	53                   	push   %ebx
8010499d:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801049a0:	e8 7f fb ff ff       	call   80104524 <allocproc>
801049a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049ac:	75 0a                	jne    801049b8 <fork+0x21>
    return -1;
801049ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b3:	e9 4d 02 00 00       	jmp    80104c05 <fork+0x26e>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801049b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049be:	8b 10                	mov    (%eax),%edx
801049c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c6:	8b 40 04             	mov    0x4(%eax),%eax
801049c9:	83 ec 08             	sub    $0x8,%esp
801049cc:	52                   	push   %edx
801049cd:	50                   	push   %eax
801049ce:	e8 66 49 00 00       	call   80109339 <copyuvm>
801049d3:	83 c4 10             	add    $0x10,%esp
801049d6:	89 c2                	mov    %eax,%edx
801049d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049db:	89 50 04             	mov    %edx,0x4(%eax)
801049de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049e1:	8b 40 04             	mov    0x4(%eax),%eax
801049e4:	85 c0                	test   %eax,%eax
801049e6:	0f 85 b4 00 00 00    	jne    80104aa0 <fork+0x109>
    kfree(np->kstack);
801049ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ef:	8b 40 08             	mov    0x8(%eax),%eax
801049f2:	83 ec 0c             	sub    $0xc,%esp
801049f5:	50                   	push   %eax
801049f6:	e8 78 e2 ff ff       	call   80102c73 <kfree>
801049fb:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801049fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	68 80 39 11 80       	push   $0x80113980
80104a10:	e8 dc 14 00 00       	call   80105ef1 <acquire>
80104a15:	83 c4 10             	add    $0x10,%esp
    int code = remove_from_list(&ptable.pLists.embryo, np);
80104a18:	83 ec 08             	sub    $0x8,%esp
80104a1b:	ff 75 e0             	pushl  -0x20(%ebp)
80104a1e:	68 b8 5e 11 80       	push   $0x80115eb8
80104a23:	e8 75 12 00 00       	call   80105c9d <remove_from_list>
80104a28:	83 c4 10             	add    $0x10,%esp
80104a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (code < 0)
80104a2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104a32:	79 0d                	jns    80104a41 <fork+0xaa>
      panic("ERROR: Couldn't remove from embryo.");
80104a34:	83 ec 0c             	sub    $0xc,%esp
80104a37:	68 c8 98 10 80       	push   $0x801098c8
80104a3c:	e8 25 bb ff ff       	call   80100566 <panic>
    assert_state(np, EMBRYO);
80104a41:	83 ec 08             	sub    $0x8,%esp
80104a44:	6a 01                	push   $0x1
80104a46:	ff 75 e0             	pushl  -0x20(%ebp)
80104a49:	e8 2e 12 00 00       	call   80105c7c <assert_state>
80104a4e:	83 c4 10             	add    $0x10,%esp
    #endif
    np->state = UNUSED;
80104a51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a54:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #ifdef CS333_P3P4
    int code2 = add_to_list(&ptable.pLists.free, UNUSED, np);
80104a5b:	83 ec 04             	sub    $0x4,%esp
80104a5e:	ff 75 e0             	pushl  -0x20(%ebp)
80104a61:	6a 00                	push   $0x0
80104a63:	68 b4 5e 11 80       	push   $0x80115eb4
80104a68:	e8 dc 12 00 00       	call   80105d49 <add_to_list>
80104a6d:	83 c4 10             	add    $0x10,%esp
80104a70:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (code2 < 0)
80104a73:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80104a77:	79 0d                	jns    80104a86 <fork+0xef>
      panic("ERROR: Couldn't add process back to free.");
80104a79:	83 ec 0c             	sub    $0xc,%esp
80104a7c:	68 ec 98 10 80       	push   $0x801098ec
80104a81:	e8 e0 ba ff ff       	call   80100566 <panic>
    release(&ptable.lock);
80104a86:	83 ec 0c             	sub    $0xc,%esp
80104a89:	68 80 39 11 80       	push   $0x80113980
80104a8e:	e8 c5 14 00 00       	call   80105f58 <release>
80104a93:	83 c4 10             	add    $0x10,%esp
    #endif
    return -1;
80104a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a9b:	e9 65 01 00 00       	jmp    80104c05 <fork+0x26e>
  }
  np->sz = proc->sz;
80104aa0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa6:	8b 10                	mov    (%eax),%edx
80104aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aab:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104aad:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ab7:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104aba:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104abd:	8b 50 18             	mov    0x18(%eax),%edx
80104ac0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac6:	8b 40 18             	mov    0x18(%eax),%eax
80104ac9:	89 c3                	mov    %eax,%ebx
80104acb:	b8 13 00 00 00       	mov    $0x13,%eax
80104ad0:	89 d7                	mov    %edx,%edi
80104ad2:	89 de                	mov    %ebx,%esi
80104ad4:	89 c1                	mov    %eax,%ecx
80104ad6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // I'm pretty sure that this is where we put the uid/gid copy
  np -> uid = proc -> uid; // p2
80104ad8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ade:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ae7:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np -> gid = proc -> gid; // p2
80104aed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104af9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104afc:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104b02:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b05:	8b 40 18             	mov    0x18(%eax),%eax
80104b08:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104b0f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b16:	eb 43                	jmp    80104b5b <fork+0x1c4>
    if(proc->ofile[i])
80104b18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b21:	83 c2 08             	add    $0x8,%edx
80104b24:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b28:	85 c0                	test   %eax,%eax
80104b2a:	74 2b                	je     80104b57 <fork+0x1c0>
      np->ofile[i] = filedup(proc->ofile[i]);
80104b2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b35:	83 c2 08             	add    $0x8,%edx
80104b38:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b3c:	83 ec 0c             	sub    $0xc,%esp
80104b3f:	50                   	push   %eax
80104b40:	e8 65 c5 ff ff       	call   801010aa <filedup>
80104b45:	83 c4 10             	add    $0x10,%esp
80104b48:	89 c1                	mov    %eax,%ecx
80104b4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b50:	83 c2 08             	add    $0x8,%edx
80104b53:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np -> gid = proc -> gid; // p2

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104b57:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b5b:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b5f:	7e b7                	jle    80104b18 <fork+0x181>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104b61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b67:	8b 40 68             	mov    0x68(%eax),%eax
80104b6a:	83 ec 0c             	sub    $0xc,%esp
80104b6d:	50                   	push   %eax
80104b6e:	e8 67 ce ff ff       	call   801019da <idup>
80104b73:	83 c4 10             	add    $0x10,%esp
80104b76:	89 c2                	mov    %eax,%edx
80104b78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b7b:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104b7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b84:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b87:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b8a:	83 c0 6c             	add    $0x6c,%eax
80104b8d:	83 ec 04             	sub    $0x4,%esp
80104b90:	6a 10                	push   $0x10
80104b92:	52                   	push   %edx
80104b93:	50                   	push   %eax
80104b94:	e8 be 17 00 00       	call   80106357 <safestrcpy>
80104b99:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104b9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b9f:	8b 40 10             	mov    0x10(%eax),%eax
80104ba2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104ba5:	83 ec 0c             	sub    $0xc,%esp
80104ba8:	68 80 39 11 80       	push   $0x80113980
80104bad:	e8 3f 13 00 00       	call   80105ef1 <acquire>
80104bb2:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.embryo, np);
80104bb5:	83 ec 08             	sub    $0x8,%esp
80104bb8:	ff 75 e0             	pushl  -0x20(%ebp)
80104bbb:	68 b8 5e 11 80       	push   $0x80115eb8
80104bc0:	e8 d8 10 00 00       	call   80105c9d <remove_from_list>
80104bc5:	83 c4 10             	add    $0x10,%esp
  assert_state(np, EMBRYO);
80104bc8:	83 ec 08             	sub    $0x8,%esp
80104bcb:	6a 01                	push   $0x1
80104bcd:	ff 75 e0             	pushl  -0x20(%ebp)
80104bd0:	e8 a7 10 00 00       	call   80105c7c <assert_state>
80104bd5:	83 c4 10             	add    $0x10,%esp
  #endif
  np->state = RUNNABLE;
80104bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bdb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  add_to_ready(np, RUNNABLE);
80104be2:	83 ec 08             	sub    $0x8,%esp
80104be5:	6a 03                	push   $0x3
80104be7:	ff 75 e0             	pushl  -0x20(%ebp)
80104bea:	e8 9b 11 00 00       	call   80105d8a <add_to_ready>
80104bef:	83 c4 10             	add    $0x10,%esp
  #endif
  release(&ptable.lock);
80104bf2:	83 ec 0c             	sub    $0xc,%esp
80104bf5:	68 80 39 11 80       	push   $0x80113980
80104bfa:	e8 59 13 00 00       	call   80105f58 <release>
80104bff:	83 c4 10             	add    $0x10,%esp
  return pid;
80104c02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80104c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c08:	5b                   	pop    %ebx
80104c09:	5e                   	pop    %esi
80104c0a:	5f                   	pop    %edi
80104c0b:	5d                   	pop    %ebp
80104c0c:	c3                   	ret    

80104c0d <exit>:
}

#else
void
exit(void)
{
80104c0d:	55                   	push   %ebp
80104c0e:	89 e5                	mov    %esp,%ebp
80104c10:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int fd;

  if (proc == initproc)
80104c13:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c1a:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104c1f:	39 c2                	cmp    %eax,%edx
80104c21:	75 0d                	jne    80104c30 <exit+0x23>
    panic("init exiting");
80104c23:	83 ec 0c             	sub    $0xc,%esp
80104c26:	68 16 99 10 80       	push   $0x80109916
80104c2b:	e8 36 b9 ff ff       	call   80100566 <panic>

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104c30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c37:	eb 48                	jmp    80104c81 <exit+0x74>
    if(proc->ofile[fd]) {
80104c39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c42:	83 c2 08             	add    $0x8,%edx
80104c45:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c49:	85 c0                	test   %eax,%eax
80104c4b:	74 30                	je     80104c7d <exit+0x70>
      fileclose(proc->ofile[fd]);
80104c4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c53:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c56:	83 c2 08             	add    $0x8,%edx
80104c59:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c5d:	83 ec 0c             	sub    $0xc,%esp
80104c60:	50                   	push   %eax
80104c61:	e8 95 c4 ff ff       	call   801010fb <fileclose>
80104c66:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104c69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c72:	83 c2 08             	add    $0x8,%edx
80104c75:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104c7c:	00 

  if (proc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104c7d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c81:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c85:	7e b2                	jle    80104c39 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104c87:	e8 6b e9 ff ff       	call   801035f7 <begin_op>
  iput(proc->cwd);
80104c8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c92:	8b 40 68             	mov    0x68(%eax),%eax
80104c95:	83 ec 0c             	sub    $0xc,%esp
80104c98:	50                   	push   %eax
80104c99:	e8 46 cf ff ff       	call   80101be4 <iput>
80104c9e:	83 c4 10             	add    $0x10,%esp
  end_op();
80104ca1:	e8 dd e9 ff ff       	call   80103683 <end_op>
  proc->cwd = 0;
80104ca6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cac:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104cb3:	83 ec 0c             	sub    $0xc,%esp
80104cb6:	68 80 39 11 80       	push   $0x80113980
80104cbb:	e8 31 12 00 00       	call   80105ef1 <acquire>
80104cc0:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104cc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc9:	8b 40 14             	mov    0x14(%eax),%eax
80104ccc:	83 ec 0c             	sub    $0xc,%esp
80104ccf:	50                   	push   %eax
80104cd0:	e8 2d 06 00 00       	call   80105302 <wakeup1>
80104cd5:	83 c4 10             	add    $0x10,%esp

  // Run exit helper to check process parents against the
  // currently running process. 
  exit_helper(&ptable.pLists.embryo);
80104cd8:	83 ec 0c             	sub    $0xc,%esp
80104cdb:	68 b8 5e 11 80       	push   $0x80115eb8
80104ce0:	e8 33 11 00 00       	call   80105e18 <exit_helper>
80104ce5:	83 c4 10             	add    $0x10,%esp
  exit_helper(&ptable.pLists.ready);
80104ce8:	83 ec 0c             	sub    $0xc,%esp
80104ceb:	68 bc 5e 11 80       	push   $0x80115ebc
80104cf0:	e8 23 11 00 00       	call   80105e18 <exit_helper>
80104cf5:	83 c4 10             	add    $0x10,%esp
  exit_helper(&ptable.pLists.running);
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	68 c0 5e 11 80       	push   $0x80115ec0
80104d00:	e8 13 11 00 00       	call   80105e18 <exit_helper>
80104d05:	83 c4 10             	add    $0x10,%esp
  exit_helper(&ptable.pLists.sleep);
80104d08:	83 ec 0c             	sub    $0xc,%esp
80104d0b:	68 c4 5e 11 80       	push   $0x80115ec4
80104d10:	e8 03 11 00 00       	call   80105e18 <exit_helper>
80104d15:	83 c4 10             	add    $0x10,%esp

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
80104d18:	a1 c8 5e 11 80       	mov    0x80115ec8,%eax
80104d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80104d20:	eb 39                	jmp    80104d5b <exit+0x14e>
    if (p->parent == proc) {
80104d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d25:	8b 50 14             	mov    0x14(%eax),%edx
80104d28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d2e:	39 c2                	cmp    %eax,%edx
80104d30:	75 1d                	jne    80104d4f <exit+0x142>
      p->parent = initproc;
80104d32:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d3b:	89 50 14             	mov    %edx,0x14(%eax)
      wakeup1(initproc);
80104d3e:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104d43:	83 ec 0c             	sub    $0xc,%esp
80104d46:	50                   	push   %eax
80104d47:	e8 b6 05 00 00       	call   80105302 <wakeup1>
80104d4c:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
80104d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d52:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  exit_helper(&ptable.pLists.sleep);

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
  while (p) {
80104d5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d5f:	75 c1                	jne    80104d22 <exit+0x115>
      wakeup1(initproc);
    }
    p = p->next;
  }

  remove_from_list(&ptable.pLists.running, proc);
80104d61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d67:	83 ec 08             	sub    $0x8,%esp
80104d6a:	50                   	push   %eax
80104d6b:	68 c0 5e 11 80       	push   $0x80115ec0
80104d70:	e8 28 0f 00 00       	call   80105c9d <remove_from_list>
80104d75:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
80104d78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d7e:	83 ec 08             	sub    $0x8,%esp
80104d81:	6a 04                	push   $0x4
80104d83:	50                   	push   %eax
80104d84:	e8 f3 0e 00 00       	call   80105c7c <assert_state>
80104d89:	83 c4 10             	add    $0x10,%esp
  proc->state = ZOMBIE;
80104d8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d92:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  add_to_list(&ptable.pLists.zombie, ZOMBIE, proc);
80104d99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d9f:	83 ec 04             	sub    $0x4,%esp
80104da2:	50                   	push   %eax
80104da3:	6a 05                	push   $0x5
80104da5:	68 c8 5e 11 80       	push   $0x80115ec8
80104daa:	e8 9a 0f 00 00       	call   80105d49 <add_to_list>
80104daf:	83 c4 10             	add    $0x10,%esp
  sched();
80104db2:	e8 b0 02 00 00       	call   80105067 <sched>
  panic("zombie exit");
80104db7:	83 ec 0c             	sub    $0xc,%esp
80104dba:	68 23 99 10 80       	push   $0x80109923
80104dbf:	e8 a2 b7 ff ff       	call   80100566 <panic>

80104dc4 <wait>:
}

#else
int
wait(void)
{
80104dc4:	55                   	push   %ebp
80104dc5:	89 e5                	mov    %esp,%ebp
80104dc7:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int havekids, pid;

  acquire(&ptable.lock);
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	68 80 39 11 80       	push   $0x80113980
80104dd2:	e8 1a 11 00 00       	call   80105ef1 <acquire>
80104dd7:	83 c4 10             	add    $0x10,%esp
  for(;;) {
    // Scan through table looking for zombie children
    havekids = 0;
80104dda:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

    // Run wait helper function to search each list and check
    // if process parent is the currently running process and
    // set havekids to 1 if that is the case.
    wait_helper(&ptable.pLists.embryo, &havekids);
80104de1:	83 ec 08             	sub    $0x8,%esp
80104de4:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104de7:	50                   	push   %eax
80104de8:	68 b8 5e 11 80       	push   $0x80115eb8
80104ded:	e8 67 10 00 00       	call   80105e59 <wait_helper>
80104df2:	83 c4 10             	add    $0x10,%esp
    wait_helper(&ptable.pLists.ready, &havekids);
80104df5:	83 ec 08             	sub    $0x8,%esp
80104df8:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104dfb:	50                   	push   %eax
80104dfc:	68 bc 5e 11 80       	push   $0x80115ebc
80104e01:	e8 53 10 00 00       	call   80105e59 <wait_helper>
80104e06:	83 c4 10             	add    $0x10,%esp
    wait_helper(&ptable.pLists.running, &havekids);
80104e09:	83 ec 08             	sub    $0x8,%esp
80104e0c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104e0f:	50                   	push   %eax
80104e10:	68 c0 5e 11 80       	push   $0x80115ec0
80104e15:	e8 3f 10 00 00       	call   80105e59 <wait_helper>
80104e1a:	83 c4 10             	add    $0x10,%esp
    wait_helper(&ptable.pLists.sleep, &havekids);
80104e1d:	83 ec 08             	sub    $0x8,%esp
80104e20:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104e23:	50                   	push   %eax
80104e24:	68 c4 5e 11 80       	push   $0x80115ec4
80104e29:	e8 2b 10 00 00       	call   80105e59 <wait_helper>
80104e2e:	83 c4 10             	add    $0x10,%esp

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
80104e31:	a1 c8 5e 11 80       	mov    0x80115ec8,%eax
80104e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104e39:	e9 da 00 00 00       	jmp    80104f18 <wait+0x154>
      if (p->parent == proc) {
80104e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e41:	8b 50 14             	mov    0x14(%eax),%edx
80104e44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e4a:	39 c2                	cmp    %eax,%edx
80104e4c:	0f 85 ba 00 00 00    	jne    80104f0c <wait+0x148>
        havekids = 1;
80104e52:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
        // Found one.
        pid = p->pid;
80104e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5c:	8b 40 10             	mov    0x10(%eax),%eax
80104e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        kfree(p->kstack);
80104e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e65:	8b 40 08             	mov    0x8(%eax),%eax
80104e68:	83 ec 0c             	sub    $0xc,%esp
80104e6b:	50                   	push   %eax
80104e6c:	e8 02 de ff ff       	call   80102c73 <kfree>
80104e71:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e81:	8b 40 04             	mov    0x4(%eax),%eax
80104e84:	83 ec 0c             	sub    $0xc,%esp
80104e87:	50                   	push   %eax
80104e88:	e8 cb 43 00 00       	call   80109258 <freevm>
80104e8d:	83 c4 10             	add    $0x10,%esp
        remove_from_list(&ptable.pLists.zombie, p);
80104e90:	83 ec 08             	sub    $0x8,%esp
80104e93:	ff 75 f4             	pushl  -0xc(%ebp)
80104e96:	68 c8 5e 11 80       	push   $0x80115ec8
80104e9b:	e8 fd 0d 00 00       	call   80105c9d <remove_from_list>
80104ea0:	83 c4 10             	add    $0x10,%esp
        assert_state(p, ZOMBIE);
80104ea3:	83 ec 08             	sub    $0x8,%esp
80104ea6:	6a 05                	push   $0x5
80104ea8:	ff 75 f4             	pushl  -0xc(%ebp)
80104eab:	e8 cc 0d 00 00       	call   80105c7c <assert_state>
80104eb0:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eca:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed4:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104edb:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        add_to_list(&ptable.pLists.free, UNUSED, p);
80104ee2:	83 ec 04             	sub    $0x4,%esp
80104ee5:	ff 75 f4             	pushl  -0xc(%ebp)
80104ee8:	6a 00                	push   $0x0
80104eea:	68 b4 5e 11 80       	push   $0x80115eb4
80104eef:	e8 55 0e 00 00       	call   80105d49 <add_to_list>
80104ef4:	83 c4 10             	add    $0x10,%esp
        release(&ptable.lock);
80104ef7:	83 ec 0c             	sub    $0xc,%esp
80104efa:	68 80 39 11 80       	push   $0x80113980
80104eff:	e8 54 10 00 00       	call   80105f58 <release>
80104f04:	83 c4 10             	add    $0x10,%esp
        return pid;
80104f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f0a:	eb 5d                	jmp    80104f69 <wait+0x1a5>
      }
      p = p->next;
80104f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f0f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    wait_helper(&ptable.pLists.sleep, &havekids);

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
    while (p) {
80104f18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104f1c:	0f 85 1c ff ff ff    	jne    80104e3e <wait+0x7a>
      }
      p = p->next;
    }

    // No point waiting if we don't have any children
    if (!havekids || proc->killed) {
80104f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f25:	85 c0                	test   %eax,%eax
80104f27:	74 0d                	je     80104f36 <wait+0x172>
80104f29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f2f:	8b 40 24             	mov    0x24(%eax),%eax
80104f32:	85 c0                	test   %eax,%eax
80104f34:	74 17                	je     80104f4d <wait+0x189>
      release(&ptable.lock);
80104f36:	83 ec 0c             	sub    $0xc,%esp
80104f39:	68 80 39 11 80       	push   $0x80113980
80104f3e:	e8 15 10 00 00       	call   80105f58 <release>
80104f43:	83 c4 10             	add    $0x10,%esp
      return -1;
80104f46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f4b:	eb 1c                	jmp    80104f69 <wait+0x1a5>
    }

    // Wait for children to exit. (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104f4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f53:	83 ec 08             	sub    $0x8,%esp
80104f56:	68 80 39 11 80       	push   $0x80113980
80104f5b:	50                   	push   %eax
80104f5c:	e8 b8 02 00 00       	call   80105219 <sleep>
80104f61:	83 c4 10             	add    $0x10,%esp
  }
80104f64:	e9 71 fe ff ff       	jmp    80104dda <wait+0x16>
}
80104f69:	c9                   	leave  
80104f6a:	c3                   	ret    

80104f6b <scheduler>:
}

#else
void
scheduler(void)
{
80104f6b:	55                   	push   %ebp
80104f6c:	89 e5                	mov    %esp,%ebp
80104f6e:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int idle;  // for checking if processor is idle

  for(;;) {
    // Enable interrupts on this processor.
    sti();
80104f71:	e8 89 f5 ff ff       	call   801044ff <sti>
    idle = 1;   // assume idle unless we schedule a process
80104f76:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    acquire(&ptable.lock);
80104f7d:	83 ec 0c             	sub    $0xc,%esp
80104f80:	68 80 39 11 80       	push   $0x80113980
80104f85:	e8 67 0f 00 00       	call   80105ef1 <acquire>
80104f8a:	83 c4 10             	add    $0x10,%esp
    p = ptable.pLists.ready;
80104f8d:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
80104f92:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if(p) {
80104f95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f99:	0f 84 9f 00 00 00    	je     8010503e <scheduler+0xd3>
      remove_from_list(&ptable.pLists.ready, p);
80104f9f:	83 ec 08             	sub    $0x8,%esp
80104fa2:	ff 75 f0             	pushl  -0x10(%ebp)
80104fa5:	68 bc 5e 11 80       	push   $0x80115ebc
80104faa:	e8 ee 0c 00 00       	call   80105c9d <remove_from_list>
80104faf:	83 c4 10             	add    $0x10,%esp
      assert_state(p, RUNNABLE);
80104fb2:	83 ec 08             	sub    $0x8,%esp
80104fb5:	6a 03                	push   $0x3
80104fb7:	ff 75 f0             	pushl  -0x10(%ebp)
80104fba:	e8 bd 0c 00 00       	call   80105c7c <assert_state>
80104fbf:	83 c4 10             	add    $0x10,%esp
      idle = 0;  // not idle this timeslice
80104fc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      proc = p;
80104fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fcc:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104fd2:	83 ec 0c             	sub    $0xc,%esp
80104fd5:	ff 75 f0             	pushl  -0x10(%ebp)
80104fd8:	e8 35 3e 00 00       	call   80108e12 <switchuvm>
80104fdd:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fe3:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      add_to_list(&ptable.pLists.running, RUNNING, p);
80104fea:	83 ec 04             	sub    $0x4,%esp
80104fed:	ff 75 f0             	pushl  -0x10(%ebp)
80104ff0:	6a 04                	push   $0x4
80104ff2:	68 c0 5e 11 80       	push   $0x80115ec0
80104ff7:	e8 4d 0d 00 00       	call   80105d49 <add_to_list>
80104ffc:	83 c4 10             	add    $0x10,%esp
      p->cpu_ticks_in = ticks;  // My code p3
80104fff:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
80105005:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105008:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
      swtch(&cpu->scheduler, proc->context);
8010500e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105014:	8b 40 1c             	mov    0x1c(%eax),%eax
80105017:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010501e:	83 c2 04             	add    $0x4,%edx
80105021:	83 ec 08             	sub    $0x8,%esp
80105024:	50                   	push   %eax
80105025:	52                   	push   %edx
80105026:	e8 9d 13 00 00       	call   801063c8 <swtch>
8010502b:	83 c4 10             	add    $0x10,%esp
      switchkvm();
8010502e:	e8 c2 3d 00 00       	call   80108df5 <switchkvm>
    
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0; 
80105033:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010503a:	00 00 00 00 
    }

    release(&ptable.lock);
8010503e:	83 ec 0c             	sub    $0xc,%esp
80105041:	68 80 39 11 80       	push   $0x80113980
80105046:	e8 0d 0f 00 00       	call   80105f58 <release>
8010504b:	83 c4 10             	add    $0x10,%esp
    if (idle) {
8010504e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105052:	0f 84 19 ff ff ff    	je     80104f71 <scheduler+0x6>
      sti();
80105058:	e8 a2 f4 ff ff       	call   801044ff <sti>
      hlt();
8010505d:	e8 86 f4 ff ff       	call   801044e8 <hlt>
    }
  }
80105062:	e9 0a ff ff ff       	jmp    80104f71 <scheduler+0x6>

80105067 <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
80105067:	55                   	push   %ebp
80105068:	89 e5                	mov    %esp,%ebp
8010506a:	53                   	push   %ebx
8010506b:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
8010506e:	83 ec 0c             	sub    $0xc,%esp
80105071:	68 80 39 11 80       	push   $0x80113980
80105076:	e8 a9 0f 00 00       	call   80106024 <holding>
8010507b:	83 c4 10             	add    $0x10,%esp
8010507e:	85 c0                	test   %eax,%eax
80105080:	75 0d                	jne    8010508f <sched+0x28>
    panic("sched ptable.lock");
80105082:	83 ec 0c             	sub    $0xc,%esp
80105085:	68 2f 99 10 80       	push   $0x8010992f
8010508a:	e8 d7 b4 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
8010508f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105095:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010509b:	83 f8 01             	cmp    $0x1,%eax
8010509e:	74 0d                	je     801050ad <sched+0x46>
    panic("sched locks");
801050a0:	83 ec 0c             	sub    $0xc,%esp
801050a3:	68 41 99 10 80       	push   $0x80109941
801050a8:	e8 b9 b4 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
801050ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050b3:	8b 40 0c             	mov    0xc(%eax),%eax
801050b6:	83 f8 04             	cmp    $0x4,%eax
801050b9:	75 0d                	jne    801050c8 <sched+0x61>
    panic("sched running");
801050bb:	83 ec 0c             	sub    $0xc,%esp
801050be:	68 4d 99 10 80       	push   $0x8010994d
801050c3:	e8 9e b4 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
801050c8:	e8 22 f4 ff ff       	call   801044ef <readeflags>
801050cd:	25 00 02 00 00       	and    $0x200,%eax
801050d2:	85 c0                	test   %eax,%eax
801050d4:	74 0d                	je     801050e3 <sched+0x7c>
    panic("sched interruptible");
801050d6:	83 ec 0c             	sub    $0xc,%esp
801050d9:	68 5b 99 10 80       	push   $0x8010995b
801050de:	e8 83 b4 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
801050e3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050e9:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801050ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // My code p2
801050f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050ff:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80105105:	8b 1d e0 66 11 80    	mov    0x801166e0,%ebx
8010510b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105112:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80105118:	29 d3                	sub    %edx,%ebx
8010511a:	89 da                	mov    %ebx,%edx
8010511c:	01 ca                	add    %ecx,%edx
8010511e:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
80105124:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010512a:	8b 40 04             	mov    0x4(%eax),%eax
8010512d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105134:	83 c2 1c             	add    $0x1c,%edx
80105137:	83 ec 08             	sub    $0x8,%esp
8010513a:	50                   	push   %eax
8010513b:	52                   	push   %edx
8010513c:	e8 87 12 00 00       	call   801063c8 <swtch>
80105141:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80105144:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010514a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010514d:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105153:	90                   	nop
80105154:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105157:	c9                   	leave  
80105158:	c3                   	ret    

80105159 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105159:	55                   	push   %ebp
8010515a:	89 e5                	mov    %esp,%ebp
8010515c:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010515f:	83 ec 0c             	sub    $0xc,%esp
80105162:	68 80 39 11 80       	push   $0x80113980
80105167:	e8 85 0d 00 00       	call   80105ef1 <acquire>
8010516c:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
8010516f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105175:	83 ec 08             	sub    $0x8,%esp
80105178:	50                   	push   %eax
80105179:	68 c0 5e 11 80       	push   $0x80115ec0
8010517e:	e8 1a 0b 00 00       	call   80105c9d <remove_from_list>
80105183:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
80105186:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010518c:	83 ec 08             	sub    $0x8,%esp
8010518f:	6a 04                	push   $0x4
80105191:	50                   	push   %eax
80105192:	e8 e5 0a 00 00       	call   80105c7c <assert_state>
80105197:	83 c4 10             	add    $0x10,%esp
  #endif
  proc->state = RUNNABLE;
8010519a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  add_to_ready(proc, RUNNABLE);
801051a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051ad:	83 ec 08             	sub    $0x8,%esp
801051b0:	6a 03                	push   $0x3
801051b2:	50                   	push   %eax
801051b3:	e8 d2 0b 00 00       	call   80105d8a <add_to_ready>
801051b8:	83 c4 10             	add    $0x10,%esp
  #endif
  sched();
801051bb:	e8 a7 fe ff ff       	call   80105067 <sched>
  release(&ptable.lock);
801051c0:	83 ec 0c             	sub    $0xc,%esp
801051c3:	68 80 39 11 80       	push   $0x80113980
801051c8:	e8 8b 0d 00 00       	call   80105f58 <release>
801051cd:	83 c4 10             	add    $0x10,%esp
}
801051d0:	90                   	nop
801051d1:	c9                   	leave  
801051d2:	c3                   	ret    

801051d3 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801051d3:	55                   	push   %ebp
801051d4:	89 e5                	mov    %esp,%ebp
801051d6:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801051d9:	83 ec 0c             	sub    $0xc,%esp
801051dc:	68 80 39 11 80       	push   $0x80113980
801051e1:	e8 72 0d 00 00       	call   80105f58 <release>
801051e6:	83 c4 10             	add    $0x10,%esp

  if (first) {
801051e9:	a1 20 c0 10 80       	mov    0x8010c020,%eax
801051ee:	85 c0                	test   %eax,%eax
801051f0:	74 24                	je     80105216 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801051f2:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
801051f9:	00 00 00 
    iinit(ROOTDEV);
801051fc:	83 ec 0c             	sub    $0xc,%esp
801051ff:	6a 01                	push   $0x1
80105201:	e8 e2 c4 ff ff       	call   801016e8 <iinit>
80105206:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80105209:	83 ec 0c             	sub    $0xc,%esp
8010520c:	6a 01                	push   $0x1
8010520e:	e8 c6 e1 ff ff       	call   801033d9 <initlog>
80105213:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105216:	90                   	nop
80105217:	c9                   	leave  
80105218:	c3                   	ret    

80105219 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105219:	55                   	push   %ebp
8010521a:	89 e5                	mov    %esp,%ebp
8010521c:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
8010521f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105225:	85 c0                	test   %eax,%eax
80105227:	75 0d                	jne    80105236 <sleep+0x1d>
    panic("sleep");
80105229:	83 ec 0c             	sub    $0xc,%esp
8010522c:	68 6f 99 10 80       	push   $0x8010996f
80105231:	e8 30 b3 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80105236:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
8010523d:	74 24                	je     80105263 <sleep+0x4a>
    acquire(&ptable.lock);
8010523f:	83 ec 0c             	sub    $0xc,%esp
80105242:	68 80 39 11 80       	push   $0x80113980
80105247:	e8 a5 0c 00 00       	call   80105ef1 <acquire>
8010524c:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
8010524f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105253:	74 0e                	je     80105263 <sleep+0x4a>
80105255:	83 ec 0c             	sub    $0xc,%esp
80105258:	ff 75 0c             	pushl  0xc(%ebp)
8010525b:	e8 f8 0c 00 00       	call   80105f58 <release>
80105260:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80105263:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105269:	8b 55 08             	mov    0x8(%ebp),%edx
8010526c:	89 50 20             	mov    %edx,0x20(%eax)
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
8010526f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105275:	83 ec 08             	sub    $0x8,%esp
80105278:	50                   	push   %eax
80105279:	68 c0 5e 11 80       	push   $0x80115ec0
8010527e:	e8 1a 0a 00 00       	call   80105c9d <remove_from_list>
80105283:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
80105286:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010528c:	83 ec 08             	sub    $0x8,%esp
8010528f:	6a 04                	push   $0x4
80105291:	50                   	push   %eax
80105292:	e8 e5 09 00 00       	call   80105c7c <assert_state>
80105297:	83 c4 10             	add    $0x10,%esp
  #endif
  proc->state = SLEEPING;
8010529a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052a0:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  #ifdef CS333_P3P4
  add_to_list(&ptable.pLists.sleep, SLEEPING, proc);
801052a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052ad:	83 ec 04             	sub    $0x4,%esp
801052b0:	50                   	push   %eax
801052b1:	6a 02                	push   $0x2
801052b3:	68 c4 5e 11 80       	push   $0x80115ec4
801052b8:	e8 8c 0a 00 00       	call   80105d49 <add_to_list>
801052bd:	83 c4 10             	add    $0x10,%esp
  #endif
  sched();
801052c0:	e8 a2 fd ff ff       	call   80105067 <sched>

  // Tidy up.
  proc->chan = 0;
801052c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052cb:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
801052d2:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
801052d9:	74 24                	je     801052ff <sleep+0xe6>
    release(&ptable.lock);
801052db:	83 ec 0c             	sub    $0xc,%esp
801052de:	68 80 39 11 80       	push   $0x80113980
801052e3:	e8 70 0c 00 00       	call   80105f58 <release>
801052e8:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
801052eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801052ef:	74 0e                	je     801052ff <sleep+0xe6>
801052f1:	83 ec 0c             	sub    $0xc,%esp
801052f4:	ff 75 0c             	pushl  0xc(%ebp)
801052f7:	e8 f5 0b 00 00       	call   80105ef1 <acquire>
801052fc:	83 c4 10             	add    $0x10,%esp
  }
}
801052ff:	90                   	nop
80105300:	c9                   	leave  
80105301:	c3                   	ret    

80105302 <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
80105302:	55                   	push   %ebp
80105303:	89 e5                	mov    %esp,%ebp
80105305:	83 ec 18             	sub    $0x18,%esp
  struct proc* p = ptable.pLists.sleep;
80105308:	a1 c4 5e 11 80       	mov    0x80115ec4,%eax
8010530d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80105310:	eb 54                	jmp    80105366 <wakeup1+0x64>
    if (p->chan == chan) {
80105312:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105315:	8b 40 20             	mov    0x20(%eax),%eax
80105318:	3b 45 08             	cmp    0x8(%ebp),%eax
8010531b:	75 3d                	jne    8010535a <wakeup1+0x58>
      remove_from_list(&ptable.pLists.sleep, p);
8010531d:	83 ec 08             	sub    $0x8,%esp
80105320:	ff 75 f4             	pushl  -0xc(%ebp)
80105323:	68 c4 5e 11 80       	push   $0x80115ec4
80105328:	e8 70 09 00 00       	call   80105c9d <remove_from_list>
8010532d:	83 c4 10             	add    $0x10,%esp
      assert_state(p, SLEEPING);
80105330:	83 ec 08             	sub    $0x8,%esp
80105333:	6a 02                	push   $0x2
80105335:	ff 75 f4             	pushl  -0xc(%ebp)
80105338:	e8 3f 09 00 00       	call   80105c7c <assert_state>
8010533d:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
80105340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105343:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      add_to_ready(p, RUNNABLE);
8010534a:	83 ec 08             	sub    $0x8,%esp
8010534d:	6a 03                	push   $0x3
8010534f:	ff 75 f4             	pushl  -0xc(%ebp)
80105352:	e8 33 0a 00 00       	call   80105d8a <add_to_ready>
80105357:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
8010535a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010535d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105363:	89 45 f4             	mov    %eax,-0xc(%ebp)
#else
static void
wakeup1(void *chan)
{
  struct proc* p = ptable.pLists.sleep;
  while (p) {
80105366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010536a:	75 a6                	jne    80105312 <wakeup1+0x10>
      p->state = RUNNABLE;
      add_to_ready(p, RUNNABLE);
    }
    p = p->next;
  }
}
8010536c:	90                   	nop
8010536d:	c9                   	leave  
8010536e:	c3                   	ret    

8010536f <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010536f:	55                   	push   %ebp
80105370:	89 e5                	mov    %esp,%ebp
80105372:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105375:	83 ec 0c             	sub    $0xc,%esp
80105378:	68 80 39 11 80       	push   $0x80113980
8010537d:	e8 6f 0b 00 00       	call   80105ef1 <acquire>
80105382:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105385:	83 ec 0c             	sub    $0xc,%esp
80105388:	ff 75 08             	pushl  0x8(%ebp)
8010538b:	e8 72 ff ff ff       	call   80105302 <wakeup1>
80105390:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105393:	83 ec 0c             	sub    $0xc,%esp
80105396:	68 80 39 11 80       	push   $0x80113980
8010539b:	e8 b8 0b 00 00       	call   80105f58 <release>
801053a0:	83 c4 10             	add    $0x10,%esp
}
801053a3:	90                   	nop
801053a4:	c9                   	leave  
801053a5:	c3                   	ret    

801053a6 <kill>:
}

#else
int
kill(int pid)
{
801053a6:	55                   	push   %ebp
801053a7:	89 e5                	mov    %esp,%ebp
801053a9:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;

  acquire(&ptable.lock);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	68 80 39 11 80       	push   $0x80113980
801053b4:	e8 38 0b 00 00       	call   80105ef1 <acquire>
801053b9:	83 c4 10             	add    $0x10,%esp
  // Search through embryo
  p = ptable.pLists.embryo;
801053bc:	a1 b8 5e 11 80       	mov    0x80115eb8,%eax
801053c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
801053c4:	eb 3d                	jmp    80105403 <kill+0x5d>
    if (p->pid == pid) {
801053c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c9:	8b 50 10             	mov    0x10(%eax),%edx
801053cc:	8b 45 08             	mov    0x8(%ebp),%eax
801053cf:	39 c2                	cmp    %eax,%edx
801053d1:	75 24                	jne    801053f7 <kill+0x51>
      p->killed = 1;
801053d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
801053dd:	83 ec 0c             	sub    $0xc,%esp
801053e0:	68 80 39 11 80       	push   $0x80113980
801053e5:	e8 6e 0b 00 00       	call   80105f58 <release>
801053ea:	83 c4 10             	add    $0x10,%esp
      return 0;
801053ed:	b8 00 00 00 00       	mov    $0x0,%eax
801053f2:	e9 48 01 00 00       	jmp    8010553f <kill+0x199>
    }
    p = p->next;
801053f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053fa:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc* p;

  acquire(&ptable.lock);
  // Search through embryo
  p = ptable.pLists.embryo;
  while (p) {
80105403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105407:	75 bd                	jne    801053c6 <kill+0x20>
      return 0;
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.ready;
80105409:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
8010540e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80105411:	eb 3d                	jmp    80105450 <kill+0xaa>
    if (p->pid == pid) {
80105413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105416:	8b 50 10             	mov    0x10(%eax),%edx
80105419:	8b 45 08             	mov    0x8(%ebp),%eax
8010541c:	39 c2                	cmp    %eax,%edx
8010541e:	75 24                	jne    80105444 <kill+0x9e>
      p->killed = 1;
80105420:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105423:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
8010542a:	83 ec 0c             	sub    $0xc,%esp
8010542d:	68 80 39 11 80       	push   $0x80113980
80105432:	e8 21 0b 00 00       	call   80105f58 <release>
80105437:	83 c4 10             	add    $0x10,%esp
      return 0;
8010543a:	b8 00 00 00 00       	mov    $0x0,%eax
8010543f:	e9 fb 00 00 00       	jmp    8010553f <kill+0x199>
    }
    p = p->next;
80105444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105447:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010544d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.ready;
  while (p) {
80105450:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105454:	75 bd                	jne    80105413 <kill+0x6d>
      return 0;
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.running;
80105456:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
8010545b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
8010545e:	eb 3d                	jmp    8010549d <kill+0xf7>
    if (p->pid == pid) {
80105460:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105463:	8b 50 10             	mov    0x10(%eax),%edx
80105466:	8b 45 08             	mov    0x8(%ebp),%eax
80105469:	39 c2                	cmp    %eax,%edx
8010546b:	75 24                	jne    80105491 <kill+0xeb>
      p->killed = 1;
8010546d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105470:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
80105477:	83 ec 0c             	sub    $0xc,%esp
8010547a:	68 80 39 11 80       	push   $0x80113980
8010547f:	e8 d4 0a 00 00       	call   80105f58 <release>
80105484:	83 c4 10             	add    $0x10,%esp
      return 0;
80105487:	b8 00 00 00 00       	mov    $0x0,%eax
8010548c:	e9 ae 00 00 00       	jmp    8010553f <kill+0x199>
    }
    p = p->next;
80105491:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105494:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010549a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.running;
  while (p) {
8010549d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054a1:	75 bd                	jne    80105460 <kill+0xba>
      return 0;
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
801054a3:	a1 c4 5e 11 80       	mov    0x80115ec4,%eax
801054a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
801054ab:	eb 77                	jmp    80105524 <kill+0x17e>
    if (p->pid == pid) {
801054ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b0:	8b 50 10             	mov    0x10(%eax),%edx
801054b3:	8b 45 08             	mov    0x8(%ebp),%eax
801054b6:	39 c2                	cmp    %eax,%edx
801054b8:	75 5e                	jne    80105518 <kill+0x172>
      p->killed = 1;
801054ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054bd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      remove_from_list(&ptable.pLists.sleep, p);
801054c4:	83 ec 08             	sub    $0x8,%esp
801054c7:	ff 75 f4             	pushl  -0xc(%ebp)
801054ca:	68 c4 5e 11 80       	push   $0x80115ec4
801054cf:	e8 c9 07 00 00       	call   80105c9d <remove_from_list>
801054d4:	83 c4 10             	add    $0x10,%esp
      assert_state(p, SLEEPING);
801054d7:	83 ec 08             	sub    $0x8,%esp
801054da:	6a 02                	push   $0x2
801054dc:	ff 75 f4             	pushl  -0xc(%ebp)
801054df:	e8 98 07 00 00       	call   80105c7c <assert_state>
801054e4:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
801054e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ea:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      add_to_ready(p, RUNNABLE);
801054f1:	83 ec 08             	sub    $0x8,%esp
801054f4:	6a 03                	push   $0x3
801054f6:	ff 75 f4             	pushl  -0xc(%ebp)
801054f9:	e8 8c 08 00 00       	call   80105d8a <add_to_ready>
801054fe:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
80105501:	83 ec 0c             	sub    $0xc,%esp
80105504:	68 80 39 11 80       	push   $0x80113980
80105509:	e8 4a 0a 00 00       	call   80105f58 <release>
8010550e:	83 c4 10             	add    $0x10,%esp
      return 0;
80105511:	b8 00 00 00 00       	mov    $0x0,%eax
80105516:	eb 27                	jmp    8010553f <kill+0x199>
    }
    p = p->next;
80105518:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010551b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105521:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
  while (p) {
80105524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105528:	75 83                	jne    801054ad <kill+0x107>
      return 0;
    }
    p = p->next;
  }

  release(&ptable.lock);
8010552a:	83 ec 0c             	sub    $0xc,%esp
8010552d:	68 80 39 11 80       	push   $0x80113980
80105532:	e8 21 0a 00 00       	call   80105f58 <release>
80105537:	83 c4 10             	add    $0x10,%esp
  return -1;
8010553a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010553f:	c9                   	leave  
80105540:	c3                   	ret    

80105541 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105541:	55                   	push   %ebp
80105542:	89 e5                	mov    %esp,%ebp
80105544:	53                   	push   %ebx
80105545:	83 ec 54             	sub    $0x54,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
80105548:	83 ec 08             	sub    $0x8,%esp
8010554b:	68 9f 99 10 80       	push   $0x8010999f
80105550:	68 a3 99 10 80       	push   $0x801099a3
80105555:	68 a7 99 10 80       	push   $0x801099a7
8010555a:	68 af 99 10 80       	push   $0x801099af
8010555f:	68 b5 99 10 80       	push   $0x801099b5
80105564:	68 ba 99 10 80       	push   $0x801099ba
80105569:	68 be 99 10 80       	push   $0x801099be
8010556e:	68 c2 99 10 80       	push   $0x801099c2
80105573:	68 c7 99 10 80       	push   $0x801099c7
80105578:	68 cc 99 10 80       	push   $0x801099cc
8010557d:	e8 44 ae ff ff       	call   801003c6 <cprintf>
80105582:	83 c4 30             	add    $0x30,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105585:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
8010558c:	e9 2a 02 00 00       	jmp    801057bb <procdump+0x27a>
    if(p->state == UNUSED)
80105591:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105594:	8b 40 0c             	mov    0xc(%eax),%eax
80105597:	85 c0                	test   %eax,%eax
80105599:	0f 84 14 02 00 00    	je     801057b3 <procdump+0x272>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010559f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a2:	8b 40 0c             	mov    0xc(%eax),%eax
801055a5:	83 f8 05             	cmp    $0x5,%eax
801055a8:	77 23                	ja     801055cd <procdump+0x8c>
801055aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ad:	8b 40 0c             	mov    0xc(%eax),%eax
801055b0:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801055b7:	85 c0                	test   %eax,%eax
801055b9:	74 12                	je     801055cd <procdump+0x8c>
      state = states[p->state];
801055bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055be:	8b 40 0c             	mov    0xc(%eax),%eax
801055c1:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801055c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801055cb:	eb 07                	jmp    801055d4 <procdump+0x93>
    else
      state = "???";
801055cd:	c7 45 ec f0 99 10 80 	movl   $0x801099f0,-0x14(%ebp)
    uint seconds = (ticks - p->start_ticks)/100;
801055d4:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
801055da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055dd:	8b 40 7c             	mov    0x7c(%eax),%eax
801055e0:	29 c2                	sub    %eax,%edx
801055e2:	89 d0                	mov    %edx,%eax
801055e4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801055e9:	f7 e2                	mul    %edx
801055eb:	89 d0                	mov    %edx,%eax
801055ed:	c1 e8 05             	shr    $0x5,%eax
801055f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint partial_seconds = (ticks - p->start_ticks)%100;
801055f3:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
801055f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055fc:	8b 40 7c             	mov    0x7c(%eax),%eax
801055ff:	89 d1                	mov    %edx,%ecx
80105601:	29 c1                	sub    %eax,%ecx
80105603:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105608:	89 c8                	mov    %ecx,%eax
8010560a:	f7 e2                	mul    %edx
8010560c:	89 d0                	mov    %edx,%eax
8010560e:	c1 e8 05             	shr    $0x5,%eax
80105611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105617:	6b c0 64             	imul   $0x64,%eax,%eax
8010561a:	29 c1                	sub    %eax,%ecx
8010561c:	89 c8                	mov    %ecx,%eax
8010561e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("%d\t %s\t %d\t %d\t", p->pid, p->name, p->uid, p->gid);
80105621:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105624:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
8010562a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010562d:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105633:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105636:	8d 58 6c             	lea    0x6c(%eax),%ebx
80105639:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010563c:	8b 40 10             	mov    0x10(%eax),%eax
8010563f:	83 ec 0c             	sub    $0xc,%esp
80105642:	51                   	push   %ecx
80105643:	52                   	push   %edx
80105644:	53                   	push   %ebx
80105645:	50                   	push   %eax
80105646:	68 f4 99 10 80       	push   $0x801099f4
8010564b:	e8 76 ad ff ff       	call   801003c6 <cprintf>
80105650:	83 c4 20             	add    $0x20,%esp
    if (p->parent)
80105653:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105656:	8b 40 14             	mov    0x14(%eax),%eax
80105659:	85 c0                	test   %eax,%eax
8010565b:	74 1c                	je     80105679 <procdump+0x138>
      cprintf("%d\t", p->parent->pid);
8010565d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105660:	8b 40 14             	mov    0x14(%eax),%eax
80105663:	8b 40 10             	mov    0x10(%eax),%eax
80105666:	83 ec 08             	sub    $0x8,%esp
80105669:	50                   	push   %eax
8010566a:	68 04 9a 10 80       	push   $0x80109a04
8010566f:	e8 52 ad ff ff       	call   801003c6 <cprintf>
80105674:	83 c4 10             	add    $0x10,%esp
80105677:	eb 17                	jmp    80105690 <procdump+0x14f>
    else
      cprintf("%d\t", p->pid);
80105679:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010567c:	8b 40 10             	mov    0x10(%eax),%eax
8010567f:	83 ec 08             	sub    $0x8,%esp
80105682:	50                   	push   %eax
80105683:	68 04 9a 10 80       	push   $0x80109a04
80105688:	e8 39 ad ff ff       	call   801003c6 <cprintf>
8010568d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %s\t %d.", state, seconds);
80105690:	83 ec 04             	sub    $0x4,%esp
80105693:	ff 75 e8             	pushl  -0x18(%ebp)
80105696:	ff 75 ec             	pushl  -0x14(%ebp)
80105699:	68 08 9a 10 80       	push   $0x80109a08
8010569e:	e8 23 ad ff ff       	call   801003c6 <cprintf>
801056a3:	83 c4 10             	add    $0x10,%esp
    if (partial_seconds < 10)
801056a6:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
801056aa:	77 10                	ja     801056bc <procdump+0x17b>
	cprintf("0");
801056ac:	83 ec 0c             	sub    $0xc,%esp
801056af:	68 11 9a 10 80       	push   $0x80109a11
801056b4:	e8 0d ad ff ff       	call   801003c6 <cprintf>
801056b9:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t", partial_seconds);
801056bc:	83 ec 08             	sub    $0x8,%esp
801056bf:	ff 75 e4             	pushl  -0x1c(%ebp)
801056c2:	68 04 9a 10 80       	push   $0x80109a04
801056c7:	e8 fa ac ff ff       	call   801003c6 <cprintf>
801056cc:	83 c4 10             	add    $0x10,%esp
    uint cpu_seconds = p->cpu_ticks_total/100;
801056cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056d2:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801056d8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801056dd:	f7 e2                	mul    %edx
801056df:	89 d0                	mov    %edx,%eax
801056e1:	c1 e8 05             	shr    $0x5,%eax
801056e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    uint cpu_partial_seconds = p->cpu_ticks_total%100;
801056e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056ea:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
801056f0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801056f5:	89 c8                	mov    %ecx,%eax
801056f7:	f7 e2                	mul    %edx
801056f9:	89 d0                	mov    %edx,%eax
801056fb:	c1 e8 05             	shr    $0x5,%eax
801056fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105701:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105704:	6b c0 64             	imul   $0x64,%eax,%eax
80105707:	29 c1                	sub    %eax,%ecx
80105709:	89 c8                	mov    %ecx,%eax
8010570b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (cpu_partial_seconds < 10)
8010570e:	83 7d dc 09          	cmpl   $0x9,-0x24(%ebp)
80105712:	77 18                	ja     8010572c <procdump+0x1eb>
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
80105714:	83 ec 04             	sub    $0x4,%esp
80105717:	ff 75 dc             	pushl  -0x24(%ebp)
8010571a:	ff 75 e0             	pushl  -0x20(%ebp)
8010571d:	68 13 9a 10 80       	push   $0x80109a13
80105722:	e8 9f ac ff ff       	call   801003c6 <cprintf>
80105727:	83 c4 10             	add    $0x10,%esp
8010572a:	eb 16                	jmp    80105742 <procdump+0x201>
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
8010572c:	83 ec 04             	sub    $0x4,%esp
8010572f:	ff 75 dc             	pushl  -0x24(%ebp)
80105732:	ff 75 e0             	pushl  -0x20(%ebp)
80105735:	68 1d 9a 10 80       	push   $0x80109a1d
8010573a:	e8 87 ac ff ff       	call   801003c6 <cprintf>
8010573f:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105742:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105745:	8b 40 0c             	mov    0xc(%eax),%eax
80105748:	83 f8 02             	cmp    $0x2,%eax
8010574b:	75 54                	jne    801057a1 <procdump+0x260>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010574d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105750:	8b 40 1c             	mov    0x1c(%eax),%eax
80105753:	8b 40 0c             	mov    0xc(%eax),%eax
80105756:	83 c0 08             	add    $0x8,%eax
80105759:	89 c2                	mov    %eax,%edx
8010575b:	83 ec 08             	sub    $0x8,%esp
8010575e:	8d 45 b4             	lea    -0x4c(%ebp),%eax
80105761:	50                   	push   %eax
80105762:	52                   	push   %edx
80105763:	e8 42 08 00 00       	call   80105faa <getcallerpcs>
80105768:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010576b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105772:	eb 1c                	jmp    80105790 <procdump+0x24f>
        cprintf(" %p", pc[i]);
80105774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105777:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
8010577b:	83 ec 08             	sub    $0x8,%esp
8010577e:	50                   	push   %eax
8010577f:	68 26 9a 10 80       	push   $0x80109a26
80105784:	e8 3d ac ff ff       	call   801003c6 <cprintf>
80105789:	83 c4 10             	add    $0x10,%esp
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010578c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105790:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105794:	7f 0b                	jg     801057a1 <procdump+0x260>
80105796:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105799:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
8010579d:	85 c0                	test   %eax,%eax
8010579f:	75 d3                	jne    80105774 <procdump+0x233>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801057a1:	83 ec 0c             	sub    $0xc,%esp
801057a4:	68 2a 9a 10 80       	push   $0x80109a2a
801057a9:	e8 18 ac ff ff       	call   801003c6 <cprintf>
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	eb 01                	jmp    801057b4 <procdump+0x273>
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801057b3:	90                   	nop
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801057b4:	81 45 f0 94 00 00 00 	addl   $0x94,-0x10(%ebp)
801057bb:	81 7d f0 b4 5e 11 80 	cmpl   $0x80115eb4,-0x10(%ebp)
801057c2:	0f 82 c9 fd ff ff    	jb     80105591 <procdump+0x50>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801057c8:	90                   	nop
801057c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057cc:	c9                   	leave  
801057cd:	c3                   	ret    

801057ce <getproc_helper>:

int
getproc_helper(int m, struct uproc* table)
{
801057ce:	55                   	push   %ebp
801057cf:	89 e5                	mov    %esp,%ebp
801057d1:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int i = 0;
801057d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
801057db:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801057e2:	e9 3d 01 00 00       	jmp    80105924 <getproc_helper+0x156>
  {
    if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
801057e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ea:	8b 40 0c             	mov    0xc(%eax),%eax
801057ed:	83 f8 04             	cmp    $0x4,%eax
801057f0:	74 1a                	je     8010580c <getproc_helper+0x3e>
801057f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f5:	8b 40 0c             	mov    0xc(%eax),%eax
801057f8:	83 f8 03             	cmp    $0x3,%eax
801057fb:	74 0f                	je     8010580c <getproc_helper+0x3e>
801057fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105800:	8b 40 0c             	mov    0xc(%eax),%eax
80105803:	83 f8 02             	cmp    $0x2,%eax
80105806:	0f 85 11 01 00 00    	jne    8010591d <getproc_helper+0x14f>
    {
      table[i].pid = p->pid;
8010580c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010580f:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105812:	8b 45 0c             	mov    0xc(%ebp),%eax
80105815:	01 c2                	add    %eax,%edx
80105817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010581a:	8b 40 10             	mov    0x10(%eax),%eax
8010581d:	89 02                	mov    %eax,(%edx)
      table[i].uid = p->uid;
8010581f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105822:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105825:	8b 45 0c             	mov    0xc(%ebp),%eax
80105828:	01 c2                	add    %eax,%edx
8010582a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010582d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105833:	89 42 04             	mov    %eax,0x4(%edx)
      table[i].gid = p->gid;
80105836:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105839:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010583c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010583f:	01 c2                	add    %eax,%edx
80105841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105844:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010584a:	89 42 08             	mov    %eax,0x8(%edx)
      if (p->parent)
8010584d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105850:	8b 40 14             	mov    0x14(%eax),%eax
80105853:	85 c0                	test   %eax,%eax
80105855:	74 19                	je     80105870 <getproc_helper+0xa2>
        table[i].ppid = p->parent->pid;
80105857:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010585a:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010585d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105860:	01 c2                	add    %eax,%edx
80105862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105865:	8b 40 14             	mov    0x14(%eax),%eax
80105868:	8b 40 10             	mov    0x10(%eax),%eax
8010586b:	89 42 0c             	mov    %eax,0xc(%edx)
8010586e:	eb 14                	jmp    80105884 <getproc_helper+0xb6>
      else
        table[i].ppid = p->pid;
80105870:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105873:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105876:	8b 45 0c             	mov    0xc(%ebp),%eax
80105879:	01 c2                	add    %eax,%edx
8010587b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010587e:	8b 40 10             	mov    0x10(%eax),%eax
80105881:	89 42 0c             	mov    %eax,0xc(%edx)
      table[i].elapsed_ticks = (ticks - p->start_ticks);
80105884:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105887:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010588a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010588d:	01 c2                	add    %eax,%edx
8010588f:	8b 0d e0 66 11 80    	mov    0x801166e0,%ecx
80105895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105898:	8b 40 7c             	mov    0x7c(%eax),%eax
8010589b:	29 c1                	sub    %eax,%ecx
8010589d:	89 c8                	mov    %ecx,%eax
8010589f:	89 42 10             	mov    %eax,0x10(%edx)
      table[i].CPU_total_ticks = p->cpu_ticks_total;
801058a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a5:	6b d0 5c             	imul   $0x5c,%eax,%edx
801058a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ab:	01 c2                	add    %eax,%edx
801058ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b0:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801058b6:	89 42 14             	mov    %eax,0x14(%edx)
      table[i].size = p->sz;
801058b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058bc:	6b d0 5c             	imul   $0x5c,%eax,%edx
801058bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801058c2:	01 c2                	add    %eax,%edx
801058c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c7:	8b 00                	mov    (%eax),%eax
801058c9:	89 42 38             	mov    %eax,0x38(%edx)
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
801058cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058cf:	8b 40 0c             	mov    0xc(%eax),%eax
801058d2:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801058d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058dc:	6b ca 5c             	imul   $0x5c,%edx,%ecx
801058df:	8b 55 0c             	mov    0xc(%ebp),%edx
801058e2:	01 ca                	add    %ecx,%edx
801058e4:	83 c2 18             	add    $0x18,%edx
801058e7:	83 ec 04             	sub    $0x4,%esp
801058ea:	6a 05                	push   $0x5
801058ec:	50                   	push   %eax
801058ed:	52                   	push   %edx
801058ee:	e8 0c 0a 00 00       	call   801062ff <strncpy>
801058f3:	83 c4 10             	add    $0x10,%esp
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
801058f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f9:	8d 50 6c             	lea    0x6c(%eax),%edx
801058fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ff:	6b c8 5c             	imul   $0x5c,%eax,%ecx
80105902:	8b 45 0c             	mov    0xc(%ebp),%eax
80105905:	01 c8                	add    %ecx,%eax
80105907:	83 c0 3c             	add    $0x3c,%eax
8010590a:	83 ec 04             	sub    $0x4,%esp
8010590d:	6a 11                	push   $0x11
8010590f:	52                   	push   %edx
80105910:	50                   	push   %eax
80105911:	e8 e9 09 00 00       	call   801062ff <strncpy>
80105916:	83 c4 10             	add    $0x10,%esp
      i++;
80105919:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
int
getproc_helper(int m, struct uproc* table)
{
  struct proc* p;
  int i = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
8010591d:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80105924:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
8010592b:	73 0c                	jae    80105939 <getproc_helper+0x16b>
8010592d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105930:	3b 45 08             	cmp    0x8(%ebp),%eax
80105933:	0f 8c ae fe ff ff    	jl     801057e7 <getproc_helper+0x19>
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
      i++;
    }
  }
  return i;  
80105939:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010593c:	c9                   	leave  
8010593d:	c3                   	ret    

8010593e <free_length>:

// Counts the number of procs in the free list when ctrl-f is pressed
void
free_length(void)
{
8010593e:	55                   	push   %ebp
8010593f:	89 e5                	mov    %esp,%ebp
80105941:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105944:	83 ec 0c             	sub    $0xc,%esp
80105947:	68 80 39 11 80       	push   $0x80113980
8010594c:	e8 a0 05 00 00       	call   80105ef1 <acquire>
80105951:	83 c4 10             	add    $0x10,%esp
  struct proc* f = ptable.pLists.free;
80105954:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80105959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
8010595c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (!f) {
80105963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105967:	75 35                	jne    8010599e <free_length+0x60>
    cprintf("Free List Size: %d\n", count);
80105969:	83 ec 08             	sub    $0x8,%esp
8010596c:	ff 75 f0             	pushl  -0x10(%ebp)
8010596f:	68 2c 9a 10 80       	push   $0x80109a2c
80105974:	e8 4d aa ff ff       	call   801003c6 <cprintf>
80105979:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
8010597c:	83 ec 0c             	sub    $0xc,%esp
8010597f:	68 80 39 11 80       	push   $0x80113980
80105984:	e8 cf 05 00 00       	call   80105f58 <release>
80105989:	83 c4 10             	add    $0x10,%esp
  }
  while (f)
8010598c:	eb 10                	jmp    8010599e <free_length+0x60>
  {
    ++count;
8010598e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    f = f->next;
80105992:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105995:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010599b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
  if (!f) {
    cprintf("Free List Size: %d\n", count);
    release(&ptable.lock);
  }
  while (f)
8010599e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059a2:	75 ea                	jne    8010598e <free_length+0x50>
  {
    ++count;
    f = f->next;
  }
  cprintf("Free List Size: %d\n", count);
801059a4:	83 ec 08             	sub    $0x8,%esp
801059a7:	ff 75 f0             	pushl  -0x10(%ebp)
801059aa:	68 2c 9a 10 80       	push   $0x80109a2c
801059af:	e8 12 aa ff ff       	call   801003c6 <cprintf>
801059b4:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801059b7:	83 ec 0c             	sub    $0xc,%esp
801059ba:	68 80 39 11 80       	push   $0x80113980
801059bf:	e8 94 05 00 00       	call   80105f58 <release>
801059c4:	83 c4 10             	add    $0x10,%esp
}
801059c7:	90                   	nop
801059c8:	c9                   	leave  
801059c9:	c3                   	ret    

801059ca <display_ready>:

// Displays the PIDs of all processes in the ready list
void
display_ready(void)
{
801059ca:	55                   	push   %ebp
801059cb:	89 e5                	mov    %esp,%ebp
801059cd:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	68 80 39 11 80       	push   $0x80113980
801059d8:	e8 14 05 00 00       	call   80105ef1 <acquire>
801059dd:	83 c4 10             	add    $0x10,%esp
  struct proc* r = ptable.pLists.ready;
801059e0:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
801059e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!r) {
801059e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059ec:	75 22                	jne    80105a10 <display_ready+0x46>
    cprintf("No processes currently in ready.\n");
801059ee:	83 ec 0c             	sub    $0xc,%esp
801059f1:	68 40 9a 10 80       	push   $0x80109a40
801059f6:	e8 cb a9 ff ff       	call   801003c6 <cprintf>
801059fb:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
801059fe:	83 ec 0c             	sub    $0xc,%esp
80105a01:	68 80 39 11 80       	push   $0x80113980
80105a06:	e8 4d 05 00 00       	call   80105f58 <release>
80105a0b:	83 c4 10             	add    $0x10,%esp
    return;
80105a0e:	eb 72                	jmp    80105a82 <display_ready+0xb8>
  }
  cprintf("Ready List Processes:\n");
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	68 62 9a 10 80       	push   $0x80109a62
80105a18:	e8 a9 a9 ff ff       	call   801003c6 <cprintf>
80105a1d:	83 c4 10             	add    $0x10,%esp
  while (r) {
80105a20:	eb 49                	jmp    80105a6b <display_ready+0xa1>
    if (!r->next)
80105a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a25:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a2b:	85 c0                	test   %eax,%eax
80105a2d:	75 19                	jne    80105a48 <display_ready+0x7e>
      cprintf("%d\n", r->pid);
80105a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a32:	8b 40 10             	mov    0x10(%eax),%eax
80105a35:	83 ec 08             	sub    $0x8,%esp
80105a38:	50                   	push   %eax
80105a39:	68 79 9a 10 80       	push   $0x80109a79
80105a3e:	e8 83 a9 ff ff       	call   801003c6 <cprintf>
80105a43:	83 c4 10             	add    $0x10,%esp
80105a46:	eb 17                	jmp    80105a5f <display_ready+0x95>
    else
      cprintf("%d -> ", r->pid);
80105a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4b:	8b 40 10             	mov    0x10(%eax),%eax
80105a4e:	83 ec 08             	sub    $0x8,%esp
80105a51:	50                   	push   %eax
80105a52:	68 7d 9a 10 80       	push   $0x80109a7d
80105a57:	e8 6a a9 ff ff       	call   801003c6 <cprintf>
80105a5c:	83 c4 10             	add    $0x10,%esp
    r = r->next;
80105a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a62:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in ready.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Ready List Processes:\n");
  while (r) {
80105a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a6f:	75 b1                	jne    80105a22 <display_ready+0x58>
      cprintf("%d\n", r->pid);
    else
      cprintf("%d -> ", r->pid);
    r = r->next;
  }
  release(&ptable.lock);
80105a71:	83 ec 0c             	sub    $0xc,%esp
80105a74:	68 80 39 11 80       	push   $0x80113980
80105a79:	e8 da 04 00 00       	call   80105f58 <release>
80105a7e:	83 c4 10             	add    $0x10,%esp
  return;
80105a81:	90                   	nop
}
80105a82:	c9                   	leave  
80105a83:	c3                   	ret    

80105a84 <display_sleep>:

// Displays the PIDs of all processes in the sleep list
void
display_sleep(void)
{
80105a84:	55                   	push   %ebp
80105a85:	89 e5                	mov    %esp,%ebp
80105a87:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105a8a:	83 ec 0c             	sub    $0xc,%esp
80105a8d:	68 80 39 11 80       	push   $0x80113980
80105a92:	e8 5a 04 00 00       	call   80105ef1 <acquire>
80105a97:	83 c4 10             	add    $0x10,%esp
  struct proc* s = ptable.pLists.sleep;
80105a9a:	a1 c4 5e 11 80       	mov    0x80115ec4,%eax
80105a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!s) {
80105aa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aa6:	75 22                	jne    80105aca <display_sleep+0x46>
    cprintf("No processes currently in sleep.\n");
80105aa8:	83 ec 0c             	sub    $0xc,%esp
80105aab:	68 84 9a 10 80       	push   $0x80109a84
80105ab0:	e8 11 a9 ff ff       	call   801003c6 <cprintf>
80105ab5:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	68 80 39 11 80       	push   $0x80113980
80105ac0:	e8 93 04 00 00       	call   80105f58 <release>
80105ac5:	83 c4 10             	add    $0x10,%esp
    return;
80105ac8:	eb 72                	jmp    80105b3c <display_sleep+0xb8>
  }
  cprintf("Sleep List Processes:\n");
80105aca:	83 ec 0c             	sub    $0xc,%esp
80105acd:	68 a6 9a 10 80       	push   $0x80109aa6
80105ad2:	e8 ef a8 ff ff       	call   801003c6 <cprintf>
80105ad7:	83 c4 10             	add    $0x10,%esp
  while (s) {
80105ada:	eb 49                	jmp    80105b25 <display_sleep+0xa1>
    if (!s->next)
80105adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105adf:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	75 19                	jne    80105b02 <display_sleep+0x7e>
      cprintf("%d\n", s->pid);
80105ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aec:	8b 40 10             	mov    0x10(%eax),%eax
80105aef:	83 ec 08             	sub    $0x8,%esp
80105af2:	50                   	push   %eax
80105af3:	68 79 9a 10 80       	push   $0x80109a79
80105af8:	e8 c9 a8 ff ff       	call   801003c6 <cprintf>
80105afd:	83 c4 10             	add    $0x10,%esp
80105b00:	eb 17                	jmp    80105b19 <display_sleep+0x95>
    else
      cprintf("%d -> ", s->pid);
80105b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b05:	8b 40 10             	mov    0x10(%eax),%eax
80105b08:	83 ec 08             	sub    $0x8,%esp
80105b0b:	50                   	push   %eax
80105b0c:	68 7d 9a 10 80       	push   $0x80109a7d
80105b11:	e8 b0 a8 ff ff       	call   801003c6 <cprintf>
80105b16:	83 c4 10             	add    $0x10,%esp
    s = s->next;
80105b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b1c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in sleep.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Sleep List Processes:\n");
  while (s) {
80105b25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b29:	75 b1                	jne    80105adc <display_sleep+0x58>
      cprintf("%d\n", s->pid);
    else
      cprintf("%d -> ", s->pid);
    s = s->next;
  }
  release(&ptable.lock);
80105b2b:	83 ec 0c             	sub    $0xc,%esp
80105b2e:	68 80 39 11 80       	push   $0x80113980
80105b33:	e8 20 04 00 00       	call   80105f58 <release>
80105b38:	83 c4 10             	add    $0x10,%esp
  return;
80105b3b:	90                   	nop
}
80105b3c:	c9                   	leave  
80105b3d:	c3                   	ret    

80105b3e <display_zombie>:

// Displays the PID/PPID of processes in the zombie list
void display_zombie(void)
{
80105b3e:	55                   	push   %ebp
80105b3f:	89 e5                	mov    %esp,%ebp
80105b41:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105b44:	83 ec 0c             	sub    $0xc,%esp
80105b47:	68 80 39 11 80       	push   $0x80113980
80105b4c:	e8 a0 03 00 00       	call   80105ef1 <acquire>
80105b51:	83 c4 10             	add    $0x10,%esp
  struct proc* z = ptable.pLists.zombie;
80105b54:	a1 c8 5e 11 80       	mov    0x80115ec8,%eax
80105b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!z) {
80105b5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b60:	75 25                	jne    80105b87 <display_zombie+0x49>
    cprintf("No processes currently in zombie.\n");
80105b62:	83 ec 0c             	sub    $0xc,%esp
80105b65:	68 c0 9a 10 80       	push   $0x80109ac0
80105b6a:	e8 57 a8 ff ff       	call   801003c6 <cprintf>
80105b6f:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105b72:	83 ec 0c             	sub    $0xc,%esp
80105b75:	68 80 39 11 80       	push   $0x80113980
80105b7a:	e8 d9 03 00 00       	call   80105f58 <release>
80105b7f:	83 c4 10             	add    $0x10,%esp
    return;
80105b82:	e9 f3 00 00 00       	jmp    80105c7a <display_zombie+0x13c>
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
80105b87:	83 ec 0c             	sub    $0xc,%esp
80105b8a:	68 e4 9a 10 80       	push   $0x80109ae4
80105b8f:	e8 32 a8 ff ff       	call   801003c6 <cprintf>
80105b94:	83 c4 10             	add    $0x10,%esp
  while (z) {
80105b97:	e9 c3 00 00 00       	jmp    80105c5f <display_zombie+0x121>
    if (!z->next) {
80105b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b9f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	75 56                	jne    80105bff <display_zombie+0xc1>
      cprintf("(%d", z->pid);
80105ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bac:	8b 40 10             	mov    0x10(%eax),%eax
80105baf:	83 ec 08             	sub    $0x8,%esp
80105bb2:	50                   	push   %eax
80105bb3:	68 03 9b 10 80       	push   $0x80109b03
80105bb8:	e8 09 a8 ff ff       	call   801003c6 <cprintf>
80105bbd:	83 c4 10             	add    $0x10,%esp
      if (z->parent)
80105bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc3:	8b 40 14             	mov    0x14(%eax),%eax
80105bc6:	85 c0                	test   %eax,%eax
80105bc8:	74 1c                	je     80105be6 <display_zombie+0xa8>
        cprintf(", %d)\n", z->parent->pid);
80105bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bcd:	8b 40 14             	mov    0x14(%eax),%eax
80105bd0:	8b 40 10             	mov    0x10(%eax),%eax
80105bd3:	83 ec 08             	sub    $0x8,%esp
80105bd6:	50                   	push   %eax
80105bd7:	68 07 9b 10 80       	push   $0x80109b07
80105bdc:	e8 e5 a7 ff ff       	call   801003c6 <cprintf>
80105be1:	83 c4 10             	add    $0x10,%esp
80105be4:	eb 6d                	jmp    80105c53 <display_zombie+0x115>
      else
        cprintf(", %d)\n", z->pid);
80105be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be9:	8b 40 10             	mov    0x10(%eax),%eax
80105bec:	83 ec 08             	sub    $0x8,%esp
80105bef:	50                   	push   %eax
80105bf0:	68 07 9b 10 80       	push   $0x80109b07
80105bf5:	e8 cc a7 ff ff       	call   801003c6 <cprintf>
80105bfa:	83 c4 10             	add    $0x10,%esp
80105bfd:	eb 54                	jmp    80105c53 <display_zombie+0x115>
    }
    else {
      cprintf("(%d", z->pid);
80105bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c02:	8b 40 10             	mov    0x10(%eax),%eax
80105c05:	83 ec 08             	sub    $0x8,%esp
80105c08:	50                   	push   %eax
80105c09:	68 03 9b 10 80       	push   $0x80109b03
80105c0e:	e8 b3 a7 ff ff       	call   801003c6 <cprintf>
80105c13:	83 c4 10             	add    $0x10,%esp
      if (z->parent)
80105c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c19:	8b 40 14             	mov    0x14(%eax),%eax
80105c1c:	85 c0                	test   %eax,%eax
80105c1e:	74 1c                	je     80105c3c <display_zombie+0xfe>
        cprintf(", %d) -> ", z->parent->pid);
80105c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c23:	8b 40 14             	mov    0x14(%eax),%eax
80105c26:	8b 40 10             	mov    0x10(%eax),%eax
80105c29:	83 ec 08             	sub    $0x8,%esp
80105c2c:	50                   	push   %eax
80105c2d:	68 0e 9b 10 80       	push   $0x80109b0e
80105c32:	e8 8f a7 ff ff       	call   801003c6 <cprintf>
80105c37:	83 c4 10             	add    $0x10,%esp
80105c3a:	eb 17                	jmp    80105c53 <display_zombie+0x115>
      else
        cprintf(", %d) -> ", z->pid);
80105c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3f:	8b 40 10             	mov    0x10(%eax),%eax
80105c42:	83 ec 08             	sub    $0x8,%esp
80105c45:	50                   	push   %eax
80105c46:	68 0e 9b 10 80       	push   $0x80109b0e
80105c4b:	e8 76 a7 ff ff       	call   801003c6 <cprintf>
80105c50:	83 c4 10             	add    $0x10,%esp
    }
    z = z->next;
80105c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c56:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in zombie.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
  while (z) {
80105c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c63:	0f 85 33 ff ff ff    	jne    80105b9c <display_zombie+0x5e>
      else
        cprintf(", %d) -> ", z->pid);
    }
    z = z->next;
  }
  release(&ptable.lock);
80105c69:	83 ec 0c             	sub    $0xc,%esp
80105c6c:	68 80 39 11 80       	push   $0x80113980
80105c71:	e8 e2 02 00 00       	call   80105f58 <release>
80105c76:	83 c4 10             	add    $0x10,%esp
  return;
80105c79:	90                   	nop
}
80105c7a:	c9                   	leave  
80105c7b:	c3                   	ret    

80105c7c <assert_state>:

// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
80105c7c:	55                   	push   %ebp
80105c7d:	89 e5                	mov    %esp,%ebp
80105c7f:	83 ec 08             	sub    $0x8,%esp
  if (p->state == state)
80105c82:	8b 45 08             	mov    0x8(%ebp),%eax
80105c85:	8b 40 0c             	mov    0xc(%eax),%eax
80105c88:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105c8b:	74 0d                	je     80105c9a <assert_state+0x1e>
    return;
  panic("ERROR: States do not match.");
80105c8d:	83 ec 0c             	sub    $0xc,%esp
80105c90:	68 18 9b 10 80       	push   $0x80109b18
80105c95:	e8 cc a8 ff ff       	call   80100566 <panic>
// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
  if (p->state == state)
    return;
80105c9a:	90                   	nop
  panic("ERROR: States do not match.");
}
80105c9b:	c9                   	leave  
80105c9c:	c3                   	ret    

80105c9d <remove_from_list>:

// Implementation of remove_from_list
static int
remove_from_list(struct proc** sList, struct proc* p)
{
80105c9d:	55                   	push   %ebp
80105c9e:	89 e5                	mov    %esp,%ebp
80105ca0:	83 ec 10             	sub    $0x10,%esp
  if (!p)
80105ca3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105ca7:	75 0a                	jne    80105cb3 <remove_from_list+0x16>
    return -1;
80105ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cae:	e9 94 00 00 00       	jmp    80105d47 <remove_from_list+0xaa>
  if (!sList)
80105cb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105cb7:	75 0a                	jne    80105cc3 <remove_from_list+0x26>
    return -1;
80105cb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cbe:	e9 84 00 00 00       	jmp    80105d47 <remove_from_list+0xaa>
  struct proc* curr = *sList;
80105cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80105cc6:	8b 00                	mov    (%eax),%eax
80105cc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc* prev;
  if (p == curr) {
80105ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105cd1:	75 62                	jne    80105d35 <remove_from_list+0x98>
    *sList = p->next;
80105cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cd6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105cdc:	8b 45 08             	mov    0x8(%ebp),%eax
80105cdf:	89 10                	mov    %edx,(%eax)
    p->next = 0;
80105ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ce4:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105ceb:	00 00 00 
    return 1;
80105cee:	b8 01 00 00 00       	mov    $0x1,%eax
80105cf3:	eb 52                	jmp    80105d47 <remove_from_list+0xaa>
  }
  while (curr->next) {
    prev = curr;
80105cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cf8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    curr = curr->next;
80105cfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cfe:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (p == curr) {
80105d07:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d0a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105d0d:	75 26                	jne    80105d35 <remove_from_list+0x98>
      prev->next = p->next;
80105d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d12:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105d18:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105d1b:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
      p->next = 0;
80105d21:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d24:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105d2b:	00 00 00 
      return 1;
80105d2e:	b8 01 00 00 00       	mov    $0x1,%eax
80105d33:	eb 12                	jmp    80105d47 <remove_from_list+0xaa>
  if (p == curr) {
    *sList = p->next;
    p->next = 0;
    return 1;
  }
  while (curr->next) {
80105d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d38:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d3e:	85 c0                	test   %eax,%eax
80105d40:	75 b3                	jne    80105cf5 <remove_from_list+0x58>
      prev->next = p->next;
      p->next = 0;
      return 1;
    }
  }
  return -1;
80105d42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d47:	c9                   	leave  
80105d48:	c3                   	ret    

80105d49 <add_to_list>:

// Implementation of add_to_list
static int
add_to_list(struct proc** sList, enum procstate state, struct proc* p)
{
80105d49:	55                   	push   %ebp
80105d4a:	89 e5                	mov    %esp,%ebp
80105d4c:	83 ec 08             	sub    $0x8,%esp
  if (!p)
80105d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105d53:	75 07                	jne    80105d5c <add_to_list+0x13>
    return -1;
80105d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5a:	eb 2c                	jmp    80105d88 <add_to_list+0x3f>
  assert_state(p, state);
80105d5c:	83 ec 08             	sub    $0x8,%esp
80105d5f:	ff 75 0c             	pushl  0xc(%ebp)
80105d62:	ff 75 10             	pushl  0x10(%ebp)
80105d65:	e8 12 ff ff ff       	call   80105c7c <assert_state>
80105d6a:	83 c4 10             	add    $0x10,%esp
  p->next = *sList;
80105d6d:	8b 45 08             	mov    0x8(%ebp),%eax
80105d70:	8b 10                	mov    (%eax),%edx
80105d72:	8b 45 10             	mov    0x10(%ebp),%eax
80105d75:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  *sList = p;
80105d7b:	8b 45 08             	mov    0x8(%ebp),%eax
80105d7e:	8b 55 10             	mov    0x10(%ebp),%edx
80105d81:	89 10                	mov    %edx,(%eax)
  return 0;
80105d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d88:	c9                   	leave  
80105d89:	c3                   	ret    

80105d8a <add_to_ready>:

// Implementation of add_to_ready
static int
add_to_ready(struct proc* p, enum procstate state)
{
80105d8a:	55                   	push   %ebp
80105d8b:	89 e5                	mov    %esp,%ebp
80105d8d:	83 ec 18             	sub    $0x18,%esp
  if (!p)
80105d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105d94:	75 07                	jne    80105d9d <add_to_ready+0x13>
    return -1;
80105d96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d9b:	eb 79                	jmp    80105e16 <add_to_ready+0x8c>
  assert_state(p, state);
80105d9d:	83 ec 08             	sub    $0x8,%esp
80105da0:	ff 75 0c             	pushl  0xc(%ebp)
80105da3:	ff 75 08             	pushl  0x8(%ebp)
80105da6:	e8 d1 fe ff ff       	call   80105c7c <assert_state>
80105dab:	83 c4 10             	add    $0x10,%esp
  if (!ptable.pLists.ready) {
80105dae:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
80105db3:	85 c0                	test   %eax,%eax
80105db5:	75 1e                	jne    80105dd5 <add_to_ready+0x4b>
    p->next = ptable.pLists.ready;
80105db7:	8b 15 bc 5e 11 80    	mov    0x80115ebc,%edx
80105dbd:	8b 45 08             	mov    0x8(%ebp),%eax
80105dc0:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    ptable.pLists.ready = p;
80105dc6:	8b 45 08             	mov    0x8(%ebp),%eax
80105dc9:	a3 bc 5e 11 80       	mov    %eax,0x80115ebc
    return 1;
80105dce:	b8 01 00 00 00       	mov    $0x1,%eax
80105dd3:	eb 41                	jmp    80105e16 <add_to_ready+0x8c>
  }
  struct proc* t = ptable.pLists.ready;
80105dd5:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
80105dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (t->next)
80105ddd:	eb 0c                	jmp    80105deb <add_to_ready+0x61>
    t = t->next;
80105ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p->next = ptable.pLists.ready;
    ptable.pLists.ready = p;
    return 1;
  }
  struct proc* t = ptable.pLists.ready;
  while (t->next)
80105deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dee:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105df4:	85 c0                	test   %eax,%eax
80105df6:	75 e7                	jne    80105ddf <add_to_ready+0x55>
    t = t->next;
  t->next = p;
80105df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfb:	8b 55 08             	mov    0x8(%ebp),%edx
80105dfe:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  p->next = 0;
80105e04:	8b 45 08             	mov    0x8(%ebp),%eax
80105e07:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105e0e:	00 00 00 
  return 0;
80105e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e16:	c9                   	leave  
80105e17:	c3                   	ret    

80105e18 <exit_helper>:

// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
80105e18:	55                   	push   %ebp
80105e19:	89 e5                	mov    %esp,%ebp
80105e1b:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = *sList;
80105e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80105e21:	8b 00                	mov    (%eax),%eax
80105e23:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
80105e26:	eb 28                	jmp    80105e50 <exit_helper+0x38>
    if (p->parent == proc)
80105e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e2b:	8b 50 14             	mov    0x14(%eax),%edx
80105e2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e34:	39 c2                	cmp    %eax,%edx
80105e36:	75 0c                	jne    80105e44 <exit_helper+0x2c>
      p->parent = initproc;
80105e38:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80105e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e41:	89 50 14             	mov    %edx,0x14(%eax)
    p = p->next;
80105e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e47:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
  struct proc* p = *sList;
  while (p) {
80105e50:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105e54:	75 d2                	jne    80105e28 <exit_helper+0x10>
    if (p->parent == proc)
      p->parent = initproc;
    p = p->next;
  }
}
80105e56:	90                   	nop
80105e57:	c9                   	leave  
80105e58:	c3                   	ret    

80105e59 <wait_helper>:

// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
80105e59:	55                   	push   %ebp
80105e5a:	89 e5                	mov    %esp,%ebp
80105e5c:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = *sList;
80105e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80105e62:	8b 00                	mov    (%eax),%eax
80105e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
80105e67:	eb 25                	jmp    80105e8e <wait_helper+0x35>
    if (p->parent == proc)
80105e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e6c:	8b 50 14             	mov    0x14(%eax),%edx
80105e6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e75:	39 c2                	cmp    %eax,%edx
80105e77:	75 09                	jne    80105e82 <wait_helper+0x29>
      *hk = 1;
80105e79:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e7c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    p = p->next;
80105e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e85:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
  struct proc* p = *sList;
  while (p) {
80105e8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105e92:	75 d5                	jne    80105e69 <wait_helper+0x10>
    if (p->parent == proc)
      *hk = 1;
    p = p->next;
  }
}
80105e94:	90                   	nop
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    

80105e97 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105e97:	55                   	push   %ebp
80105e98:	89 e5                	mov    %esp,%ebp
80105e9a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105e9d:	9c                   	pushf  
80105e9e:	58                   	pop    %eax
80105e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105ea5:	c9                   	leave  
80105ea6:	c3                   	ret    

80105ea7 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105ea7:	55                   	push   %ebp
80105ea8:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105eaa:	fa                   	cli    
}
80105eab:	90                   	nop
80105eac:	5d                   	pop    %ebp
80105ead:	c3                   	ret    

80105eae <sti>:

static inline void
sti(void)
{
80105eae:	55                   	push   %ebp
80105eaf:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105eb1:	fb                   	sti    
}
80105eb2:	90                   	nop
80105eb3:	5d                   	pop    %ebp
80105eb4:	c3                   	ret    

80105eb5 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105eb5:	55                   	push   %ebp
80105eb6:	89 e5                	mov    %esp,%ebp
80105eb8:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105ebb:	8b 55 08             	mov    0x8(%ebp),%edx
80105ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ec1:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105ec4:	f0 87 02             	lock xchg %eax,(%edx)
80105ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105ecd:	c9                   	leave  
80105ece:	c3                   	ret    

80105ecf <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105ecf:	55                   	push   %ebp
80105ed0:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
80105ed8:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105edb:	8b 45 08             	mov    0x8(%ebp),%eax
80105ede:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80105ee7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105eee:	90                   	nop
80105eef:	5d                   	pop    %ebp
80105ef0:	c3                   	ret    

80105ef1 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105ef1:	55                   	push   %ebp
80105ef2:	89 e5                	mov    %esp,%ebp
80105ef4:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105ef7:	e8 52 01 00 00       	call   8010604e <pushcli>
  if(holding(lk))
80105efc:	8b 45 08             	mov    0x8(%ebp),%eax
80105eff:	83 ec 0c             	sub    $0xc,%esp
80105f02:	50                   	push   %eax
80105f03:	e8 1c 01 00 00       	call   80106024 <holding>
80105f08:	83 c4 10             	add    $0x10,%esp
80105f0b:	85 c0                	test   %eax,%eax
80105f0d:	74 0d                	je     80105f1c <acquire+0x2b>
    panic("acquire");
80105f0f:	83 ec 0c             	sub    $0xc,%esp
80105f12:	68 34 9b 10 80       	push   $0x80109b34
80105f17:	e8 4a a6 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105f1c:	90                   	nop
80105f1d:	8b 45 08             	mov    0x8(%ebp),%eax
80105f20:	83 ec 08             	sub    $0x8,%esp
80105f23:	6a 01                	push   $0x1
80105f25:	50                   	push   %eax
80105f26:	e8 8a ff ff ff       	call   80105eb5 <xchg>
80105f2b:	83 c4 10             	add    $0x10,%esp
80105f2e:	85 c0                	test   %eax,%eax
80105f30:	75 eb                	jne    80105f1d <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105f32:	8b 45 08             	mov    0x8(%ebp),%eax
80105f35:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105f3c:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80105f42:	83 c0 0c             	add    $0xc,%eax
80105f45:	83 ec 08             	sub    $0x8,%esp
80105f48:	50                   	push   %eax
80105f49:	8d 45 08             	lea    0x8(%ebp),%eax
80105f4c:	50                   	push   %eax
80105f4d:	e8 58 00 00 00       	call   80105faa <getcallerpcs>
80105f52:	83 c4 10             	add    $0x10,%esp
}
80105f55:	90                   	nop
80105f56:	c9                   	leave  
80105f57:	c3                   	ret    

80105f58 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105f58:	55                   	push   %ebp
80105f59:	89 e5                	mov    %esp,%ebp
80105f5b:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105f5e:	83 ec 0c             	sub    $0xc,%esp
80105f61:	ff 75 08             	pushl  0x8(%ebp)
80105f64:	e8 bb 00 00 00       	call   80106024 <holding>
80105f69:	83 c4 10             	add    $0x10,%esp
80105f6c:	85 c0                	test   %eax,%eax
80105f6e:	75 0d                	jne    80105f7d <release+0x25>
    panic("release");
80105f70:	83 ec 0c             	sub    $0xc,%esp
80105f73:	68 3c 9b 10 80       	push   $0x80109b3c
80105f78:	e8 e9 a5 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80105f80:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105f87:	8b 45 08             	mov    0x8(%ebp),%eax
80105f8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105f91:	8b 45 08             	mov    0x8(%ebp),%eax
80105f94:	83 ec 08             	sub    $0x8,%esp
80105f97:	6a 00                	push   $0x0
80105f99:	50                   	push   %eax
80105f9a:	e8 16 ff ff ff       	call   80105eb5 <xchg>
80105f9f:	83 c4 10             	add    $0x10,%esp

  popcli();
80105fa2:	e8 ec 00 00 00       	call   80106093 <popcli>
}
80105fa7:	90                   	nop
80105fa8:	c9                   	leave  
80105fa9:	c3                   	ret    

80105faa <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105faa:	55                   	push   %ebp
80105fab:	89 e5                	mov    %esp,%ebp
80105fad:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80105fb3:	83 e8 08             	sub    $0x8,%eax
80105fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105fb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105fc0:	eb 38                	jmp    80105ffa <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105fc6:	74 53                	je     8010601b <getcallerpcs+0x71>
80105fc8:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105fcf:	76 4a                	jbe    8010601b <getcallerpcs+0x71>
80105fd1:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105fd5:	74 44                	je     8010601b <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105fda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fe4:	01 c2                	add    %eax,%edx
80105fe6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fe9:	8b 40 04             	mov    0x4(%eax),%eax
80105fec:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ff1:	8b 00                	mov    (%eax),%eax
80105ff3:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105ff6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105ffa:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105ffe:	7e c2                	jle    80105fc2 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106000:	eb 19                	jmp    8010601b <getcallerpcs+0x71>
    pcs[i] = 0;
80106002:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106005:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010600c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010600f:	01 d0                	add    %edx,%eax
80106011:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106017:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010601b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010601f:	7e e1                	jle    80106002 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80106021:	90                   	nop
80106022:	c9                   	leave  
80106023:	c3                   	ret    

80106024 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106024:	55                   	push   %ebp
80106025:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106027:	8b 45 08             	mov    0x8(%ebp),%eax
8010602a:	8b 00                	mov    (%eax),%eax
8010602c:	85 c0                	test   %eax,%eax
8010602e:	74 17                	je     80106047 <holding+0x23>
80106030:	8b 45 08             	mov    0x8(%ebp),%eax
80106033:	8b 50 08             	mov    0x8(%eax),%edx
80106036:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010603c:	39 c2                	cmp    %eax,%edx
8010603e:	75 07                	jne    80106047 <holding+0x23>
80106040:	b8 01 00 00 00       	mov    $0x1,%eax
80106045:	eb 05                	jmp    8010604c <holding+0x28>
80106047:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010604c:	5d                   	pop    %ebp
8010604d:	c3                   	ret    

8010604e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010604e:	55                   	push   %ebp
8010604f:	89 e5                	mov    %esp,%ebp
80106051:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80106054:	e8 3e fe ff ff       	call   80105e97 <readeflags>
80106059:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010605c:	e8 46 fe ff ff       	call   80105ea7 <cli>
  if(cpu->ncli++ == 0)
80106061:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106068:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010606e:	8d 48 01             	lea    0x1(%eax),%ecx
80106071:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106077:	85 c0                	test   %eax,%eax
80106079:	75 15                	jne    80106090 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010607b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106081:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106084:	81 e2 00 02 00 00    	and    $0x200,%edx
8010608a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80106090:	90                   	nop
80106091:	c9                   	leave  
80106092:	c3                   	ret    

80106093 <popcli>:

void
popcli(void)
{
80106093:	55                   	push   %ebp
80106094:	89 e5                	mov    %esp,%ebp
80106096:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106099:	e8 f9 fd ff ff       	call   80105e97 <readeflags>
8010609e:	25 00 02 00 00       	and    $0x200,%eax
801060a3:	85 c0                	test   %eax,%eax
801060a5:	74 0d                	je     801060b4 <popcli+0x21>
    panic("popcli - interruptible");
801060a7:	83 ec 0c             	sub    $0xc,%esp
801060aa:	68 44 9b 10 80       	push   $0x80109b44
801060af:	e8 b2 a4 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801060b4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801060ba:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801060c0:	83 ea 01             	sub    $0x1,%edx
801060c3:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801060c9:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801060cf:	85 c0                	test   %eax,%eax
801060d1:	79 0d                	jns    801060e0 <popcli+0x4d>
    panic("popcli");
801060d3:	83 ec 0c             	sub    $0xc,%esp
801060d6:	68 5b 9b 10 80       	push   $0x80109b5b
801060db:	e8 86 a4 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801060e0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801060e6:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801060ec:	85 c0                	test   %eax,%eax
801060ee:	75 15                	jne    80106105 <popcli+0x72>
801060f0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801060f6:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801060fc:	85 c0                	test   %eax,%eax
801060fe:	74 05                	je     80106105 <popcli+0x72>
    sti();
80106100:	e8 a9 fd ff ff       	call   80105eae <sti>
}
80106105:	90                   	nop
80106106:	c9                   	leave  
80106107:	c3                   	ret    

80106108 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106108:	55                   	push   %ebp
80106109:	89 e5                	mov    %esp,%ebp
8010610b:	57                   	push   %edi
8010610c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010610d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106110:	8b 55 10             	mov    0x10(%ebp),%edx
80106113:	8b 45 0c             	mov    0xc(%ebp),%eax
80106116:	89 cb                	mov    %ecx,%ebx
80106118:	89 df                	mov    %ebx,%edi
8010611a:	89 d1                	mov    %edx,%ecx
8010611c:	fc                   	cld    
8010611d:	f3 aa                	rep stos %al,%es:(%edi)
8010611f:	89 ca                	mov    %ecx,%edx
80106121:	89 fb                	mov    %edi,%ebx
80106123:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106126:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106129:	90                   	nop
8010612a:	5b                   	pop    %ebx
8010612b:	5f                   	pop    %edi
8010612c:	5d                   	pop    %ebp
8010612d:	c3                   	ret    

8010612e <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010612e:	55                   	push   %ebp
8010612f:	89 e5                	mov    %esp,%ebp
80106131:	57                   	push   %edi
80106132:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106133:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106136:	8b 55 10             	mov    0x10(%ebp),%edx
80106139:	8b 45 0c             	mov    0xc(%ebp),%eax
8010613c:	89 cb                	mov    %ecx,%ebx
8010613e:	89 df                	mov    %ebx,%edi
80106140:	89 d1                	mov    %edx,%ecx
80106142:	fc                   	cld    
80106143:	f3 ab                	rep stos %eax,%es:(%edi)
80106145:	89 ca                	mov    %ecx,%edx
80106147:	89 fb                	mov    %edi,%ebx
80106149:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010614c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010614f:	90                   	nop
80106150:	5b                   	pop    %ebx
80106151:	5f                   	pop    %edi
80106152:	5d                   	pop    %ebp
80106153:	c3                   	ret    

80106154 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106154:	55                   	push   %ebp
80106155:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106157:	8b 45 08             	mov    0x8(%ebp),%eax
8010615a:	83 e0 03             	and    $0x3,%eax
8010615d:	85 c0                	test   %eax,%eax
8010615f:	75 43                	jne    801061a4 <memset+0x50>
80106161:	8b 45 10             	mov    0x10(%ebp),%eax
80106164:	83 e0 03             	and    $0x3,%eax
80106167:	85 c0                	test   %eax,%eax
80106169:	75 39                	jne    801061a4 <memset+0x50>
    c &= 0xFF;
8010616b:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106172:	8b 45 10             	mov    0x10(%ebp),%eax
80106175:	c1 e8 02             	shr    $0x2,%eax
80106178:	89 c1                	mov    %eax,%ecx
8010617a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010617d:	c1 e0 18             	shl    $0x18,%eax
80106180:	89 c2                	mov    %eax,%edx
80106182:	8b 45 0c             	mov    0xc(%ebp),%eax
80106185:	c1 e0 10             	shl    $0x10,%eax
80106188:	09 c2                	or     %eax,%edx
8010618a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010618d:	c1 e0 08             	shl    $0x8,%eax
80106190:	09 d0                	or     %edx,%eax
80106192:	0b 45 0c             	or     0xc(%ebp),%eax
80106195:	51                   	push   %ecx
80106196:	50                   	push   %eax
80106197:	ff 75 08             	pushl  0x8(%ebp)
8010619a:	e8 8f ff ff ff       	call   8010612e <stosl>
8010619f:	83 c4 0c             	add    $0xc,%esp
801061a2:	eb 12                	jmp    801061b6 <memset+0x62>
  } else
    stosb(dst, c, n);
801061a4:	8b 45 10             	mov    0x10(%ebp),%eax
801061a7:	50                   	push   %eax
801061a8:	ff 75 0c             	pushl  0xc(%ebp)
801061ab:	ff 75 08             	pushl  0x8(%ebp)
801061ae:	e8 55 ff ff ff       	call   80106108 <stosb>
801061b3:	83 c4 0c             	add    $0xc,%esp
  return dst;
801061b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801061b9:	c9                   	leave  
801061ba:	c3                   	ret    

801061bb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801061bb:	55                   	push   %ebp
801061bc:	89 e5                	mov    %esp,%ebp
801061be:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801061c1:	8b 45 08             	mov    0x8(%ebp),%eax
801061c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801061c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801061ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801061cd:	eb 30                	jmp    801061ff <memcmp+0x44>
    if(*s1 != *s2)
801061cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061d2:	0f b6 10             	movzbl (%eax),%edx
801061d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801061d8:	0f b6 00             	movzbl (%eax),%eax
801061db:	38 c2                	cmp    %al,%dl
801061dd:	74 18                	je     801061f7 <memcmp+0x3c>
      return *s1 - *s2;
801061df:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061e2:	0f b6 00             	movzbl (%eax),%eax
801061e5:	0f b6 d0             	movzbl %al,%edx
801061e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801061eb:	0f b6 00             	movzbl (%eax),%eax
801061ee:	0f b6 c0             	movzbl %al,%eax
801061f1:	29 c2                	sub    %eax,%edx
801061f3:	89 d0                	mov    %edx,%eax
801061f5:	eb 1a                	jmp    80106211 <memcmp+0x56>
    s1++, s2++;
801061f7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801061fb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801061ff:	8b 45 10             	mov    0x10(%ebp),%eax
80106202:	8d 50 ff             	lea    -0x1(%eax),%edx
80106205:	89 55 10             	mov    %edx,0x10(%ebp)
80106208:	85 c0                	test   %eax,%eax
8010620a:	75 c3                	jne    801061cf <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010620c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106211:	c9                   	leave  
80106212:	c3                   	ret    

80106213 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106213:	55                   	push   %ebp
80106214:	89 e5                	mov    %esp,%ebp
80106216:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106219:	8b 45 0c             	mov    0xc(%ebp),%eax
8010621c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010621f:	8b 45 08             	mov    0x8(%ebp),%eax
80106222:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106225:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106228:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010622b:	73 54                	jae    80106281 <memmove+0x6e>
8010622d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106230:	8b 45 10             	mov    0x10(%ebp),%eax
80106233:	01 d0                	add    %edx,%eax
80106235:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106238:	76 47                	jbe    80106281 <memmove+0x6e>
    s += n;
8010623a:	8b 45 10             	mov    0x10(%ebp),%eax
8010623d:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106240:	8b 45 10             	mov    0x10(%ebp),%eax
80106243:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106246:	eb 13                	jmp    8010625b <memmove+0x48>
      *--d = *--s;
80106248:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010624c:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106250:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106253:	0f b6 10             	movzbl (%eax),%edx
80106256:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106259:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010625b:	8b 45 10             	mov    0x10(%ebp),%eax
8010625e:	8d 50 ff             	lea    -0x1(%eax),%edx
80106261:	89 55 10             	mov    %edx,0x10(%ebp)
80106264:	85 c0                	test   %eax,%eax
80106266:	75 e0                	jne    80106248 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106268:	eb 24                	jmp    8010628e <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
8010626a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010626d:	8d 50 01             	lea    0x1(%eax),%edx
80106270:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106273:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106276:	8d 4a 01             	lea    0x1(%edx),%ecx
80106279:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010627c:	0f b6 12             	movzbl (%edx),%edx
8010627f:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106281:	8b 45 10             	mov    0x10(%ebp),%eax
80106284:	8d 50 ff             	lea    -0x1(%eax),%edx
80106287:	89 55 10             	mov    %edx,0x10(%ebp)
8010628a:	85 c0                	test   %eax,%eax
8010628c:	75 dc                	jne    8010626a <memmove+0x57>
      *d++ = *s++;

  return dst;
8010628e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106291:	c9                   	leave  
80106292:	c3                   	ret    

80106293 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106293:	55                   	push   %ebp
80106294:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106296:	ff 75 10             	pushl  0x10(%ebp)
80106299:	ff 75 0c             	pushl  0xc(%ebp)
8010629c:	ff 75 08             	pushl  0x8(%ebp)
8010629f:	e8 6f ff ff ff       	call   80106213 <memmove>
801062a4:	83 c4 0c             	add    $0xc,%esp
}
801062a7:	c9                   	leave  
801062a8:	c3                   	ret    

801062a9 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801062a9:	55                   	push   %ebp
801062aa:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801062ac:	eb 0c                	jmp    801062ba <strncmp+0x11>
    n--, p++, q++;
801062ae:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801062b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801062b6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801062ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801062be:	74 1a                	je     801062da <strncmp+0x31>
801062c0:	8b 45 08             	mov    0x8(%ebp),%eax
801062c3:	0f b6 00             	movzbl (%eax),%eax
801062c6:	84 c0                	test   %al,%al
801062c8:	74 10                	je     801062da <strncmp+0x31>
801062ca:	8b 45 08             	mov    0x8(%ebp),%eax
801062cd:	0f b6 10             	movzbl (%eax),%edx
801062d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801062d3:	0f b6 00             	movzbl (%eax),%eax
801062d6:	38 c2                	cmp    %al,%dl
801062d8:	74 d4                	je     801062ae <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801062da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801062de:	75 07                	jne    801062e7 <strncmp+0x3e>
    return 0;
801062e0:	b8 00 00 00 00       	mov    $0x0,%eax
801062e5:	eb 16                	jmp    801062fd <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801062e7:	8b 45 08             	mov    0x8(%ebp),%eax
801062ea:	0f b6 00             	movzbl (%eax),%eax
801062ed:	0f b6 d0             	movzbl %al,%edx
801062f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801062f3:	0f b6 00             	movzbl (%eax),%eax
801062f6:	0f b6 c0             	movzbl %al,%eax
801062f9:	29 c2                	sub    %eax,%edx
801062fb:	89 d0                	mov    %edx,%eax
}
801062fd:	5d                   	pop    %ebp
801062fe:	c3                   	ret    

801062ff <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801062ff:	55                   	push   %ebp
80106300:	89 e5                	mov    %esp,%ebp
80106302:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106305:	8b 45 08             	mov    0x8(%ebp),%eax
80106308:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010630b:	90                   	nop
8010630c:	8b 45 10             	mov    0x10(%ebp),%eax
8010630f:	8d 50 ff             	lea    -0x1(%eax),%edx
80106312:	89 55 10             	mov    %edx,0x10(%ebp)
80106315:	85 c0                	test   %eax,%eax
80106317:	7e 2c                	jle    80106345 <strncpy+0x46>
80106319:	8b 45 08             	mov    0x8(%ebp),%eax
8010631c:	8d 50 01             	lea    0x1(%eax),%edx
8010631f:	89 55 08             	mov    %edx,0x8(%ebp)
80106322:	8b 55 0c             	mov    0xc(%ebp),%edx
80106325:	8d 4a 01             	lea    0x1(%edx),%ecx
80106328:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010632b:	0f b6 12             	movzbl (%edx),%edx
8010632e:	88 10                	mov    %dl,(%eax)
80106330:	0f b6 00             	movzbl (%eax),%eax
80106333:	84 c0                	test   %al,%al
80106335:	75 d5                	jne    8010630c <strncpy+0xd>
    ;
  while(n-- > 0)
80106337:	eb 0c                	jmp    80106345 <strncpy+0x46>
    *s++ = 0;
80106339:	8b 45 08             	mov    0x8(%ebp),%eax
8010633c:	8d 50 01             	lea    0x1(%eax),%edx
8010633f:	89 55 08             	mov    %edx,0x8(%ebp)
80106342:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106345:	8b 45 10             	mov    0x10(%ebp),%eax
80106348:	8d 50 ff             	lea    -0x1(%eax),%edx
8010634b:	89 55 10             	mov    %edx,0x10(%ebp)
8010634e:	85 c0                	test   %eax,%eax
80106350:	7f e7                	jg     80106339 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106352:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106355:	c9                   	leave  
80106356:	c3                   	ret    

80106357 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106357:	55                   	push   %ebp
80106358:	89 e5                	mov    %esp,%ebp
8010635a:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010635d:	8b 45 08             	mov    0x8(%ebp),%eax
80106360:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106363:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106367:	7f 05                	jg     8010636e <safestrcpy+0x17>
    return os;
80106369:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010636c:	eb 31                	jmp    8010639f <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010636e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106372:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106376:	7e 1e                	jle    80106396 <safestrcpy+0x3f>
80106378:	8b 45 08             	mov    0x8(%ebp),%eax
8010637b:	8d 50 01             	lea    0x1(%eax),%edx
8010637e:	89 55 08             	mov    %edx,0x8(%ebp)
80106381:	8b 55 0c             	mov    0xc(%ebp),%edx
80106384:	8d 4a 01             	lea    0x1(%edx),%ecx
80106387:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010638a:	0f b6 12             	movzbl (%edx),%edx
8010638d:	88 10                	mov    %dl,(%eax)
8010638f:	0f b6 00             	movzbl (%eax),%eax
80106392:	84 c0                	test   %al,%al
80106394:	75 d8                	jne    8010636e <safestrcpy+0x17>
    ;
  *s = 0;
80106396:	8b 45 08             	mov    0x8(%ebp),%eax
80106399:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010639c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010639f:	c9                   	leave  
801063a0:	c3                   	ret    

801063a1 <strlen>:

int
strlen(const char *s)
{
801063a1:	55                   	push   %ebp
801063a2:	89 e5                	mov    %esp,%ebp
801063a4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801063a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801063ae:	eb 04                	jmp    801063b4 <strlen+0x13>
801063b0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801063b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801063b7:	8b 45 08             	mov    0x8(%ebp),%eax
801063ba:	01 d0                	add    %edx,%eax
801063bc:	0f b6 00             	movzbl (%eax),%eax
801063bf:	84 c0                	test   %al,%al
801063c1:	75 ed                	jne    801063b0 <strlen+0xf>
    ;
  return n;
801063c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801063c6:	c9                   	leave  
801063c7:	c3                   	ret    

801063c8 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801063c8:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801063cc:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801063d0:	55                   	push   %ebp
  pushl %ebx
801063d1:	53                   	push   %ebx
  pushl %esi
801063d2:	56                   	push   %esi
  pushl %edi
801063d3:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801063d4:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801063d6:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801063d8:	5f                   	pop    %edi
  popl %esi
801063d9:	5e                   	pop    %esi
  popl %ebx
801063da:	5b                   	pop    %ebx
  popl %ebp
801063db:	5d                   	pop    %ebp
  ret
801063dc:	c3                   	ret    

801063dd <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801063dd:	55                   	push   %ebp
801063de:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801063e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063e6:	8b 00                	mov    (%eax),%eax
801063e8:	3b 45 08             	cmp    0x8(%ebp),%eax
801063eb:	76 12                	jbe    801063ff <fetchint+0x22>
801063ed:	8b 45 08             	mov    0x8(%ebp),%eax
801063f0:	8d 50 04             	lea    0x4(%eax),%edx
801063f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063f9:	8b 00                	mov    (%eax),%eax
801063fb:	39 c2                	cmp    %eax,%edx
801063fd:	76 07                	jbe    80106406 <fetchint+0x29>
    return -1;
801063ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106404:	eb 0f                	jmp    80106415 <fetchint+0x38>
  *ip = *(int*)(addr);
80106406:	8b 45 08             	mov    0x8(%ebp),%eax
80106409:	8b 10                	mov    (%eax),%edx
8010640b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010640e:	89 10                	mov    %edx,(%eax)
  return 0;
80106410:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106415:	5d                   	pop    %ebp
80106416:	c3                   	ret    

80106417 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106417:	55                   	push   %ebp
80106418:	89 e5                	mov    %esp,%ebp
8010641a:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010641d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106423:	8b 00                	mov    (%eax),%eax
80106425:	3b 45 08             	cmp    0x8(%ebp),%eax
80106428:	77 07                	ja     80106431 <fetchstr+0x1a>
    return -1;
8010642a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642f:	eb 46                	jmp    80106477 <fetchstr+0x60>
  *pp = (char*)addr;
80106431:	8b 55 08             	mov    0x8(%ebp),%edx
80106434:	8b 45 0c             	mov    0xc(%ebp),%eax
80106437:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106439:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010643f:	8b 00                	mov    (%eax),%eax
80106441:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106444:	8b 45 0c             	mov    0xc(%ebp),%eax
80106447:	8b 00                	mov    (%eax),%eax
80106449:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010644c:	eb 1c                	jmp    8010646a <fetchstr+0x53>
    if(*s == 0)
8010644e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106451:	0f b6 00             	movzbl (%eax),%eax
80106454:	84 c0                	test   %al,%al
80106456:	75 0e                	jne    80106466 <fetchstr+0x4f>
      return s - *pp;
80106458:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010645b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010645e:	8b 00                	mov    (%eax),%eax
80106460:	29 c2                	sub    %eax,%edx
80106462:	89 d0                	mov    %edx,%eax
80106464:	eb 11                	jmp    80106477 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106466:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010646a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010646d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106470:	72 dc                	jb     8010644e <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106472:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106477:	c9                   	leave  
80106478:	c3                   	ret    

80106479 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106479:	55                   	push   %ebp
8010647a:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010647c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106482:	8b 40 18             	mov    0x18(%eax),%eax
80106485:	8b 40 44             	mov    0x44(%eax),%eax
80106488:	8b 55 08             	mov    0x8(%ebp),%edx
8010648b:	c1 e2 02             	shl    $0x2,%edx
8010648e:	01 d0                	add    %edx,%eax
80106490:	83 c0 04             	add    $0x4,%eax
80106493:	ff 75 0c             	pushl  0xc(%ebp)
80106496:	50                   	push   %eax
80106497:	e8 41 ff ff ff       	call   801063dd <fetchint>
8010649c:	83 c4 08             	add    $0x8,%esp
}
8010649f:	c9                   	leave  
801064a0:	c3                   	ret    

801064a1 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801064a1:	55                   	push   %ebp
801064a2:	89 e5                	mov    %esp,%ebp
801064a4:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801064a7:	8d 45 fc             	lea    -0x4(%ebp),%eax
801064aa:	50                   	push   %eax
801064ab:	ff 75 08             	pushl  0x8(%ebp)
801064ae:	e8 c6 ff ff ff       	call   80106479 <argint>
801064b3:	83 c4 08             	add    $0x8,%esp
801064b6:	85 c0                	test   %eax,%eax
801064b8:	79 07                	jns    801064c1 <argptr+0x20>
    return -1;
801064ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064bf:	eb 3b                	jmp    801064fc <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801064c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064c7:	8b 00                	mov    (%eax),%eax
801064c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801064cc:	39 d0                	cmp    %edx,%eax
801064ce:	76 16                	jbe    801064e6 <argptr+0x45>
801064d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801064d3:	89 c2                	mov    %eax,%edx
801064d5:	8b 45 10             	mov    0x10(%ebp),%eax
801064d8:	01 c2                	add    %eax,%edx
801064da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064e0:	8b 00                	mov    (%eax),%eax
801064e2:	39 c2                	cmp    %eax,%edx
801064e4:	76 07                	jbe    801064ed <argptr+0x4c>
    return -1;
801064e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064eb:	eb 0f                	jmp    801064fc <argptr+0x5b>
  *pp = (char*)i;
801064ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
801064f0:	89 c2                	mov    %eax,%edx
801064f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801064f5:	89 10                	mov    %edx,(%eax)
  return 0;
801064f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064fc:	c9                   	leave  
801064fd:	c3                   	ret    

801064fe <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801064fe:	55                   	push   %ebp
801064ff:	89 e5                	mov    %esp,%ebp
80106501:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106504:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106507:	50                   	push   %eax
80106508:	ff 75 08             	pushl  0x8(%ebp)
8010650b:	e8 69 ff ff ff       	call   80106479 <argint>
80106510:	83 c4 08             	add    $0x8,%esp
80106513:	85 c0                	test   %eax,%eax
80106515:	79 07                	jns    8010651e <argstr+0x20>
    return -1;
80106517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010651c:	eb 0f                	jmp    8010652d <argstr+0x2f>
  return fetchstr(addr, pp);
8010651e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106521:	ff 75 0c             	pushl  0xc(%ebp)
80106524:	50                   	push   %eax
80106525:	e8 ed fe ff ff       	call   80106417 <fetchstr>
8010652a:	83 c4 08             	add    $0x8,%esp
}
8010652d:	c9                   	leave  
8010652e:	c3                   	ret    

8010652f <syscall>:
};
#endif 

void
syscall(void)
{
8010652f:	55                   	push   %ebp
80106530:	89 e5                	mov    %esp,%ebp
80106532:	53                   	push   %ebx
80106533:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106536:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010653c:	8b 40 18             	mov    0x18(%eax),%eax
8010653f:	8b 40 1c             	mov    0x1c(%eax),%eax
80106542:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106545:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106549:	7e 30                	jle    8010657b <syscall+0x4c>
8010654b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010654e:	83 f8 1d             	cmp    $0x1d,%eax
80106551:	77 28                	ja     8010657b <syscall+0x4c>
80106553:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106556:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010655d:	85 c0                	test   %eax,%eax
8010655f:	74 1a                	je     8010657b <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106561:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106567:	8b 58 18             	mov    0x18(%eax),%ebx
8010656a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010656d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80106574:	ff d0                	call   *%eax
80106576:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106579:	eb 34                	jmp    801065af <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010657b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106581:	8d 50 6c             	lea    0x6c(%eax),%edx
80106584:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010658a:	8b 40 10             	mov    0x10(%eax),%eax
8010658d:	ff 75 f4             	pushl  -0xc(%ebp)
80106590:	52                   	push   %edx
80106591:	50                   	push   %eax
80106592:	68 62 9b 10 80       	push   $0x80109b62
80106597:	e8 2a 9e ff ff       	call   801003c6 <cprintf>
8010659c:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010659f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065a5:	8b 40 18             	mov    0x18(%eax),%eax
801065a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801065af:	90                   	nop
801065b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065b3:	c9                   	leave  
801065b4:	c3                   	ret    

801065b5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801065b5:	55                   	push   %ebp
801065b6:	89 e5                	mov    %esp,%ebp
801065b8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801065bb:	83 ec 08             	sub    $0x8,%esp
801065be:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065c1:	50                   	push   %eax
801065c2:	ff 75 08             	pushl  0x8(%ebp)
801065c5:	e8 af fe ff ff       	call   80106479 <argint>
801065ca:	83 c4 10             	add    $0x10,%esp
801065cd:	85 c0                	test   %eax,%eax
801065cf:	79 07                	jns    801065d8 <argfd+0x23>
    return -1;
801065d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d6:	eb 50                	jmp    80106628 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801065d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065db:	85 c0                	test   %eax,%eax
801065dd:	78 21                	js     80106600 <argfd+0x4b>
801065df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065e2:	83 f8 0f             	cmp    $0xf,%eax
801065e5:	7f 19                	jg     80106600 <argfd+0x4b>
801065e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
801065f0:	83 c2 08             	add    $0x8,%edx
801065f3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801065f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065fe:	75 07                	jne    80106607 <argfd+0x52>
    return -1;
80106600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106605:	eb 21                	jmp    80106628 <argfd+0x73>
  if(pfd)
80106607:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010660b:	74 08                	je     80106615 <argfd+0x60>
    *pfd = fd;
8010660d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106610:	8b 45 0c             	mov    0xc(%ebp),%eax
80106613:	89 10                	mov    %edx,(%eax)
  if(pf)
80106615:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106619:	74 08                	je     80106623 <argfd+0x6e>
    *pf = f;
8010661b:	8b 45 10             	mov    0x10(%ebp),%eax
8010661e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106621:	89 10                	mov    %edx,(%eax)
  return 0;
80106623:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106628:	c9                   	leave  
80106629:	c3                   	ret    

8010662a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010662a:	55                   	push   %ebp
8010662b:	89 e5                	mov    %esp,%ebp
8010662d:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106630:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106637:	eb 30                	jmp    80106669 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106639:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010663f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106642:	83 c2 08             	add    $0x8,%edx
80106645:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106649:	85 c0                	test   %eax,%eax
8010664b:	75 18                	jne    80106665 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010664d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106653:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106656:	8d 4a 08             	lea    0x8(%edx),%ecx
80106659:	8b 55 08             	mov    0x8(%ebp),%edx
8010665c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106660:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106663:	eb 0f                	jmp    80106674 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106665:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106669:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010666d:	7e ca                	jle    80106639 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010666f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106674:	c9                   	leave  
80106675:	c3                   	ret    

80106676 <sys_dup>:

int
sys_dup(void)
{
80106676:	55                   	push   %ebp
80106677:	89 e5                	mov    %esp,%ebp
80106679:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010667c:	83 ec 04             	sub    $0x4,%esp
8010667f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106682:	50                   	push   %eax
80106683:	6a 00                	push   $0x0
80106685:	6a 00                	push   $0x0
80106687:	e8 29 ff ff ff       	call   801065b5 <argfd>
8010668c:	83 c4 10             	add    $0x10,%esp
8010668f:	85 c0                	test   %eax,%eax
80106691:	79 07                	jns    8010669a <sys_dup+0x24>
    return -1;
80106693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106698:	eb 31                	jmp    801066cb <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010669a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010669d:	83 ec 0c             	sub    $0xc,%esp
801066a0:	50                   	push   %eax
801066a1:	e8 84 ff ff ff       	call   8010662a <fdalloc>
801066a6:	83 c4 10             	add    $0x10,%esp
801066a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066b0:	79 07                	jns    801066b9 <sys_dup+0x43>
    return -1;
801066b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b7:	eb 12                	jmp    801066cb <sys_dup+0x55>
  filedup(f);
801066b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066bc:	83 ec 0c             	sub    $0xc,%esp
801066bf:	50                   	push   %eax
801066c0:	e8 e5 a9 ff ff       	call   801010aa <filedup>
801066c5:	83 c4 10             	add    $0x10,%esp
  return fd;
801066c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801066cb:	c9                   	leave  
801066cc:	c3                   	ret    

801066cd <sys_read>:

int
sys_read(void)
{
801066cd:	55                   	push   %ebp
801066ce:	89 e5                	mov    %esp,%ebp
801066d0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801066d3:	83 ec 04             	sub    $0x4,%esp
801066d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066d9:	50                   	push   %eax
801066da:	6a 00                	push   $0x0
801066dc:	6a 00                	push   $0x0
801066de:	e8 d2 fe ff ff       	call   801065b5 <argfd>
801066e3:	83 c4 10             	add    $0x10,%esp
801066e6:	85 c0                	test   %eax,%eax
801066e8:	78 2e                	js     80106718 <sys_read+0x4b>
801066ea:	83 ec 08             	sub    $0x8,%esp
801066ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066f0:	50                   	push   %eax
801066f1:	6a 02                	push   $0x2
801066f3:	e8 81 fd ff ff       	call   80106479 <argint>
801066f8:	83 c4 10             	add    $0x10,%esp
801066fb:	85 c0                	test   %eax,%eax
801066fd:	78 19                	js     80106718 <sys_read+0x4b>
801066ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106702:	83 ec 04             	sub    $0x4,%esp
80106705:	50                   	push   %eax
80106706:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106709:	50                   	push   %eax
8010670a:	6a 01                	push   $0x1
8010670c:	e8 90 fd ff ff       	call   801064a1 <argptr>
80106711:	83 c4 10             	add    $0x10,%esp
80106714:	85 c0                	test   %eax,%eax
80106716:	79 07                	jns    8010671f <sys_read+0x52>
    return -1;
80106718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671d:	eb 17                	jmp    80106736 <sys_read+0x69>
  return fileread(f, p, n);
8010671f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106722:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106728:	83 ec 04             	sub    $0x4,%esp
8010672b:	51                   	push   %ecx
8010672c:	52                   	push   %edx
8010672d:	50                   	push   %eax
8010672e:	e8 07 ab ff ff       	call   8010123a <fileread>
80106733:	83 c4 10             	add    $0x10,%esp
}
80106736:	c9                   	leave  
80106737:	c3                   	ret    

80106738 <sys_write>:

int
sys_write(void)
{
80106738:	55                   	push   %ebp
80106739:	89 e5                	mov    %esp,%ebp
8010673b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010673e:	83 ec 04             	sub    $0x4,%esp
80106741:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106744:	50                   	push   %eax
80106745:	6a 00                	push   $0x0
80106747:	6a 00                	push   $0x0
80106749:	e8 67 fe ff ff       	call   801065b5 <argfd>
8010674e:	83 c4 10             	add    $0x10,%esp
80106751:	85 c0                	test   %eax,%eax
80106753:	78 2e                	js     80106783 <sys_write+0x4b>
80106755:	83 ec 08             	sub    $0x8,%esp
80106758:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010675b:	50                   	push   %eax
8010675c:	6a 02                	push   $0x2
8010675e:	e8 16 fd ff ff       	call   80106479 <argint>
80106763:	83 c4 10             	add    $0x10,%esp
80106766:	85 c0                	test   %eax,%eax
80106768:	78 19                	js     80106783 <sys_write+0x4b>
8010676a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010676d:	83 ec 04             	sub    $0x4,%esp
80106770:	50                   	push   %eax
80106771:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106774:	50                   	push   %eax
80106775:	6a 01                	push   $0x1
80106777:	e8 25 fd ff ff       	call   801064a1 <argptr>
8010677c:	83 c4 10             	add    $0x10,%esp
8010677f:	85 c0                	test   %eax,%eax
80106781:	79 07                	jns    8010678a <sys_write+0x52>
    return -1;
80106783:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106788:	eb 17                	jmp    801067a1 <sys_write+0x69>
  return filewrite(f, p, n);
8010678a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010678d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106793:	83 ec 04             	sub    $0x4,%esp
80106796:	51                   	push   %ecx
80106797:	52                   	push   %edx
80106798:	50                   	push   %eax
80106799:	e8 54 ab ff ff       	call   801012f2 <filewrite>
8010679e:	83 c4 10             	add    $0x10,%esp
}
801067a1:	c9                   	leave  
801067a2:	c3                   	ret    

801067a3 <sys_close>:

int
sys_close(void)
{
801067a3:	55                   	push   %ebp
801067a4:	89 e5                	mov    %esp,%ebp
801067a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801067a9:	83 ec 04             	sub    $0x4,%esp
801067ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067af:	50                   	push   %eax
801067b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067b3:	50                   	push   %eax
801067b4:	6a 00                	push   $0x0
801067b6:	e8 fa fd ff ff       	call   801065b5 <argfd>
801067bb:	83 c4 10             	add    $0x10,%esp
801067be:	85 c0                	test   %eax,%eax
801067c0:	79 07                	jns    801067c9 <sys_close+0x26>
    return -1;
801067c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067c7:	eb 28                	jmp    801067f1 <sys_close+0x4e>
  proc->ofile[fd] = 0;
801067c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067d2:	83 c2 08             	add    $0x8,%edx
801067d5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801067dc:	00 
  fileclose(f);
801067dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067e0:	83 ec 0c             	sub    $0xc,%esp
801067e3:	50                   	push   %eax
801067e4:	e8 12 a9 ff ff       	call   801010fb <fileclose>
801067e9:	83 c4 10             	add    $0x10,%esp
  return 0;
801067ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067f1:	c9                   	leave  
801067f2:	c3                   	ret    

801067f3 <sys_fstat>:

int
sys_fstat(void)
{
801067f3:	55                   	push   %ebp
801067f4:	89 e5                	mov    %esp,%ebp
801067f6:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801067f9:	83 ec 04             	sub    $0x4,%esp
801067fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067ff:	50                   	push   %eax
80106800:	6a 00                	push   $0x0
80106802:	6a 00                	push   $0x0
80106804:	e8 ac fd ff ff       	call   801065b5 <argfd>
80106809:	83 c4 10             	add    $0x10,%esp
8010680c:	85 c0                	test   %eax,%eax
8010680e:	78 17                	js     80106827 <sys_fstat+0x34>
80106810:	83 ec 04             	sub    $0x4,%esp
80106813:	6a 14                	push   $0x14
80106815:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106818:	50                   	push   %eax
80106819:	6a 01                	push   $0x1
8010681b:	e8 81 fc ff ff       	call   801064a1 <argptr>
80106820:	83 c4 10             	add    $0x10,%esp
80106823:	85 c0                	test   %eax,%eax
80106825:	79 07                	jns    8010682e <sys_fstat+0x3b>
    return -1;
80106827:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010682c:	eb 13                	jmp    80106841 <sys_fstat+0x4e>
  return filestat(f, st);
8010682e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106831:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106834:	83 ec 08             	sub    $0x8,%esp
80106837:	52                   	push   %edx
80106838:	50                   	push   %eax
80106839:	e8 a5 a9 ff ff       	call   801011e3 <filestat>
8010683e:	83 c4 10             	add    $0x10,%esp
}
80106841:	c9                   	leave  
80106842:	c3                   	ret    

80106843 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106843:	55                   	push   %ebp
80106844:	89 e5                	mov    %esp,%ebp
80106846:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106849:	83 ec 08             	sub    $0x8,%esp
8010684c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010684f:	50                   	push   %eax
80106850:	6a 00                	push   $0x0
80106852:	e8 a7 fc ff ff       	call   801064fe <argstr>
80106857:	83 c4 10             	add    $0x10,%esp
8010685a:	85 c0                	test   %eax,%eax
8010685c:	78 15                	js     80106873 <sys_link+0x30>
8010685e:	83 ec 08             	sub    $0x8,%esp
80106861:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106864:	50                   	push   %eax
80106865:	6a 01                	push   $0x1
80106867:	e8 92 fc ff ff       	call   801064fe <argstr>
8010686c:	83 c4 10             	add    $0x10,%esp
8010686f:	85 c0                	test   %eax,%eax
80106871:	79 0a                	jns    8010687d <sys_link+0x3a>
    return -1;
80106873:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106878:	e9 68 01 00 00       	jmp    801069e5 <sys_link+0x1a2>

  begin_op();
8010687d:	e8 75 cd ff ff       	call   801035f7 <begin_op>
  if((ip = namei(old)) == 0){
80106882:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106885:	83 ec 0c             	sub    $0xc,%esp
80106888:	50                   	push   %eax
80106889:	e8 44 bd ff ff       	call   801025d2 <namei>
8010688e:	83 c4 10             	add    $0x10,%esp
80106891:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106898:	75 0f                	jne    801068a9 <sys_link+0x66>
    end_op();
8010689a:	e8 e4 cd ff ff       	call   80103683 <end_op>
    return -1;
8010689f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068a4:	e9 3c 01 00 00       	jmp    801069e5 <sys_link+0x1a2>
  }

  ilock(ip);
801068a9:	83 ec 0c             	sub    $0xc,%esp
801068ac:	ff 75 f4             	pushl  -0xc(%ebp)
801068af:	e8 60 b1 ff ff       	call   80101a14 <ilock>
801068b4:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801068b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ba:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801068be:	66 83 f8 01          	cmp    $0x1,%ax
801068c2:	75 1d                	jne    801068e1 <sys_link+0x9e>
    iunlockput(ip);
801068c4:	83 ec 0c             	sub    $0xc,%esp
801068c7:	ff 75 f4             	pushl  -0xc(%ebp)
801068ca:	e8 05 b4 ff ff       	call   80101cd4 <iunlockput>
801068cf:	83 c4 10             	add    $0x10,%esp
    end_op();
801068d2:	e8 ac cd ff ff       	call   80103683 <end_op>
    return -1;
801068d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068dc:	e9 04 01 00 00       	jmp    801069e5 <sys_link+0x1a2>
  }

  ip->nlink++;
801068e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068e4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801068e8:	83 c0 01             	add    $0x1,%eax
801068eb:	89 c2                	mov    %eax,%edx
801068ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068f0:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801068f4:	83 ec 0c             	sub    $0xc,%esp
801068f7:	ff 75 f4             	pushl  -0xc(%ebp)
801068fa:	e8 3b af ff ff       	call   8010183a <iupdate>
801068ff:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106902:	83 ec 0c             	sub    $0xc,%esp
80106905:	ff 75 f4             	pushl  -0xc(%ebp)
80106908:	e8 65 b2 ff ff       	call   80101b72 <iunlock>
8010690d:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106910:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106913:	83 ec 08             	sub    $0x8,%esp
80106916:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106919:	52                   	push   %edx
8010691a:	50                   	push   %eax
8010691b:	e8 ce bc ff ff       	call   801025ee <nameiparent>
80106920:	83 c4 10             	add    $0x10,%esp
80106923:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106926:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010692a:	74 71                	je     8010699d <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010692c:	83 ec 0c             	sub    $0xc,%esp
8010692f:	ff 75 f0             	pushl  -0x10(%ebp)
80106932:	e8 dd b0 ff ff       	call   80101a14 <ilock>
80106937:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010693a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010693d:	8b 10                	mov    (%eax),%edx
8010693f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106942:	8b 00                	mov    (%eax),%eax
80106944:	39 c2                	cmp    %eax,%edx
80106946:	75 1d                	jne    80106965 <sys_link+0x122>
80106948:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010694b:	8b 40 04             	mov    0x4(%eax),%eax
8010694e:	83 ec 04             	sub    $0x4,%esp
80106951:	50                   	push   %eax
80106952:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106955:	50                   	push   %eax
80106956:	ff 75 f0             	pushl  -0x10(%ebp)
80106959:	e8 d8 b9 ff ff       	call   80102336 <dirlink>
8010695e:	83 c4 10             	add    $0x10,%esp
80106961:	85 c0                	test   %eax,%eax
80106963:	79 10                	jns    80106975 <sys_link+0x132>
    iunlockput(dp);
80106965:	83 ec 0c             	sub    $0xc,%esp
80106968:	ff 75 f0             	pushl  -0x10(%ebp)
8010696b:	e8 64 b3 ff ff       	call   80101cd4 <iunlockput>
80106970:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106973:	eb 29                	jmp    8010699e <sys_link+0x15b>
  }
  iunlockput(dp);
80106975:	83 ec 0c             	sub    $0xc,%esp
80106978:	ff 75 f0             	pushl  -0x10(%ebp)
8010697b:	e8 54 b3 ff ff       	call   80101cd4 <iunlockput>
80106980:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106983:	83 ec 0c             	sub    $0xc,%esp
80106986:	ff 75 f4             	pushl  -0xc(%ebp)
80106989:	e8 56 b2 ff ff       	call   80101be4 <iput>
8010698e:	83 c4 10             	add    $0x10,%esp

  end_op();
80106991:	e8 ed cc ff ff       	call   80103683 <end_op>

  return 0;
80106996:	b8 00 00 00 00       	mov    $0x0,%eax
8010699b:	eb 48                	jmp    801069e5 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
8010699d:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
8010699e:	83 ec 0c             	sub    $0xc,%esp
801069a1:	ff 75 f4             	pushl  -0xc(%ebp)
801069a4:	e8 6b b0 ff ff       	call   80101a14 <ilock>
801069a9:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801069ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069af:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801069b3:	83 e8 01             	sub    $0x1,%eax
801069b6:	89 c2                	mov    %eax,%edx
801069b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069bb:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801069bf:	83 ec 0c             	sub    $0xc,%esp
801069c2:	ff 75 f4             	pushl  -0xc(%ebp)
801069c5:	e8 70 ae ff ff       	call   8010183a <iupdate>
801069ca:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801069cd:	83 ec 0c             	sub    $0xc,%esp
801069d0:	ff 75 f4             	pushl  -0xc(%ebp)
801069d3:	e8 fc b2 ff ff       	call   80101cd4 <iunlockput>
801069d8:	83 c4 10             	add    $0x10,%esp
  end_op();
801069db:	e8 a3 cc ff ff       	call   80103683 <end_op>
  return -1;
801069e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069e5:	c9                   	leave  
801069e6:	c3                   	ret    

801069e7 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801069e7:	55                   	push   %ebp
801069e8:	89 e5                	mov    %esp,%ebp
801069ea:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801069ed:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801069f4:	eb 40                	jmp    80106a36 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801069f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069f9:	6a 10                	push   $0x10
801069fb:	50                   	push   %eax
801069fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801069ff:	50                   	push   %eax
80106a00:	ff 75 08             	pushl  0x8(%ebp)
80106a03:	e8 7a b5 ff ff       	call   80101f82 <readi>
80106a08:	83 c4 10             	add    $0x10,%esp
80106a0b:	83 f8 10             	cmp    $0x10,%eax
80106a0e:	74 0d                	je     80106a1d <isdirempty+0x36>
      panic("isdirempty: readi");
80106a10:	83 ec 0c             	sub    $0xc,%esp
80106a13:	68 7e 9b 10 80       	push   $0x80109b7e
80106a18:	e8 49 9b ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80106a1d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106a21:	66 85 c0             	test   %ax,%ax
80106a24:	74 07                	je     80106a2d <isdirempty+0x46>
      return 0;
80106a26:	b8 00 00 00 00       	mov    $0x0,%eax
80106a2b:	eb 1b                	jmp    80106a48 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a30:	83 c0 10             	add    $0x10,%eax
80106a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a36:	8b 45 08             	mov    0x8(%ebp),%eax
80106a39:	8b 50 18             	mov    0x18(%eax),%edx
80106a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a3f:	39 c2                	cmp    %eax,%edx
80106a41:	77 b3                	ja     801069f6 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106a43:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106a48:	c9                   	leave  
80106a49:	c3                   	ret    

80106a4a <sys_unlink>:

int
sys_unlink(void)
{
80106a4a:	55                   	push   %ebp
80106a4b:	89 e5                	mov    %esp,%ebp
80106a4d:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106a50:	83 ec 08             	sub    $0x8,%esp
80106a53:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106a56:	50                   	push   %eax
80106a57:	6a 00                	push   $0x0
80106a59:	e8 a0 fa ff ff       	call   801064fe <argstr>
80106a5e:	83 c4 10             	add    $0x10,%esp
80106a61:	85 c0                	test   %eax,%eax
80106a63:	79 0a                	jns    80106a6f <sys_unlink+0x25>
    return -1;
80106a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a6a:	e9 bc 01 00 00       	jmp    80106c2b <sys_unlink+0x1e1>

  begin_op();
80106a6f:	e8 83 cb ff ff       	call   801035f7 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106a74:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106a77:	83 ec 08             	sub    $0x8,%esp
80106a7a:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106a7d:	52                   	push   %edx
80106a7e:	50                   	push   %eax
80106a7f:	e8 6a bb ff ff       	call   801025ee <nameiparent>
80106a84:	83 c4 10             	add    $0x10,%esp
80106a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a8e:	75 0f                	jne    80106a9f <sys_unlink+0x55>
    end_op();
80106a90:	e8 ee cb ff ff       	call   80103683 <end_op>
    return -1;
80106a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a9a:	e9 8c 01 00 00       	jmp    80106c2b <sys_unlink+0x1e1>
  }

  ilock(dp);
80106a9f:	83 ec 0c             	sub    $0xc,%esp
80106aa2:	ff 75 f4             	pushl  -0xc(%ebp)
80106aa5:	e8 6a af ff ff       	call   80101a14 <ilock>
80106aaa:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106aad:	83 ec 08             	sub    $0x8,%esp
80106ab0:	68 90 9b 10 80       	push   $0x80109b90
80106ab5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106ab8:	50                   	push   %eax
80106ab9:	e8 a3 b7 ff ff       	call   80102261 <namecmp>
80106abe:	83 c4 10             	add    $0x10,%esp
80106ac1:	85 c0                	test   %eax,%eax
80106ac3:	0f 84 4a 01 00 00    	je     80106c13 <sys_unlink+0x1c9>
80106ac9:	83 ec 08             	sub    $0x8,%esp
80106acc:	68 92 9b 10 80       	push   $0x80109b92
80106ad1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106ad4:	50                   	push   %eax
80106ad5:	e8 87 b7 ff ff       	call   80102261 <namecmp>
80106ada:	83 c4 10             	add    $0x10,%esp
80106add:	85 c0                	test   %eax,%eax
80106adf:	0f 84 2e 01 00 00    	je     80106c13 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106ae5:	83 ec 04             	sub    $0x4,%esp
80106ae8:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106aeb:	50                   	push   %eax
80106aec:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106aef:	50                   	push   %eax
80106af0:	ff 75 f4             	pushl  -0xc(%ebp)
80106af3:	e8 84 b7 ff ff       	call   8010227c <dirlookup>
80106af8:	83 c4 10             	add    $0x10,%esp
80106afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106afe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106b02:	0f 84 0a 01 00 00    	je     80106c12 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106b08:	83 ec 0c             	sub    $0xc,%esp
80106b0b:	ff 75 f0             	pushl  -0x10(%ebp)
80106b0e:	e8 01 af ff ff       	call   80101a14 <ilock>
80106b13:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b19:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106b1d:	66 85 c0             	test   %ax,%ax
80106b20:	7f 0d                	jg     80106b2f <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106b22:	83 ec 0c             	sub    $0xc,%esp
80106b25:	68 95 9b 10 80       	push   $0x80109b95
80106b2a:	e8 37 9a ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b32:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106b36:	66 83 f8 01          	cmp    $0x1,%ax
80106b3a:	75 25                	jne    80106b61 <sys_unlink+0x117>
80106b3c:	83 ec 0c             	sub    $0xc,%esp
80106b3f:	ff 75 f0             	pushl  -0x10(%ebp)
80106b42:	e8 a0 fe ff ff       	call   801069e7 <isdirempty>
80106b47:	83 c4 10             	add    $0x10,%esp
80106b4a:	85 c0                	test   %eax,%eax
80106b4c:	75 13                	jne    80106b61 <sys_unlink+0x117>
    iunlockput(ip);
80106b4e:	83 ec 0c             	sub    $0xc,%esp
80106b51:	ff 75 f0             	pushl  -0x10(%ebp)
80106b54:	e8 7b b1 ff ff       	call   80101cd4 <iunlockput>
80106b59:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106b5c:	e9 b2 00 00 00       	jmp    80106c13 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106b61:	83 ec 04             	sub    $0x4,%esp
80106b64:	6a 10                	push   $0x10
80106b66:	6a 00                	push   $0x0
80106b68:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106b6b:	50                   	push   %eax
80106b6c:	e8 e3 f5 ff ff       	call   80106154 <memset>
80106b71:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106b74:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106b77:	6a 10                	push   $0x10
80106b79:	50                   	push   %eax
80106b7a:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106b7d:	50                   	push   %eax
80106b7e:	ff 75 f4             	pushl  -0xc(%ebp)
80106b81:	e8 53 b5 ff ff       	call   801020d9 <writei>
80106b86:	83 c4 10             	add    $0x10,%esp
80106b89:	83 f8 10             	cmp    $0x10,%eax
80106b8c:	74 0d                	je     80106b9b <sys_unlink+0x151>
    panic("unlink: writei");
80106b8e:	83 ec 0c             	sub    $0xc,%esp
80106b91:	68 a7 9b 10 80       	push   $0x80109ba7
80106b96:	e8 cb 99 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80106b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b9e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106ba2:	66 83 f8 01          	cmp    $0x1,%ax
80106ba6:	75 21                	jne    80106bc9 <sys_unlink+0x17f>
    dp->nlink--;
80106ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bab:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106baf:	83 e8 01             	sub    $0x1,%eax
80106bb2:	89 c2                	mov    %eax,%edx
80106bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb7:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106bbb:	83 ec 0c             	sub    $0xc,%esp
80106bbe:	ff 75 f4             	pushl  -0xc(%ebp)
80106bc1:	e8 74 ac ff ff       	call   8010183a <iupdate>
80106bc6:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106bc9:	83 ec 0c             	sub    $0xc,%esp
80106bcc:	ff 75 f4             	pushl  -0xc(%ebp)
80106bcf:	e8 00 b1 ff ff       	call   80101cd4 <iunlockput>
80106bd4:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bda:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106bde:	83 e8 01             	sub    $0x1,%eax
80106be1:	89 c2                	mov    %eax,%edx
80106be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106be6:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106bea:	83 ec 0c             	sub    $0xc,%esp
80106bed:	ff 75 f0             	pushl  -0x10(%ebp)
80106bf0:	e8 45 ac ff ff       	call   8010183a <iupdate>
80106bf5:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106bf8:	83 ec 0c             	sub    $0xc,%esp
80106bfb:	ff 75 f0             	pushl  -0x10(%ebp)
80106bfe:	e8 d1 b0 ff ff       	call   80101cd4 <iunlockput>
80106c03:	83 c4 10             	add    $0x10,%esp

  end_op();
80106c06:	e8 78 ca ff ff       	call   80103683 <end_op>

  return 0;
80106c0b:	b8 00 00 00 00       	mov    $0x0,%eax
80106c10:	eb 19                	jmp    80106c2b <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106c12:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106c13:	83 ec 0c             	sub    $0xc,%esp
80106c16:	ff 75 f4             	pushl  -0xc(%ebp)
80106c19:	e8 b6 b0 ff ff       	call   80101cd4 <iunlockput>
80106c1e:	83 c4 10             	add    $0x10,%esp
  end_op();
80106c21:	e8 5d ca ff ff       	call   80103683 <end_op>
  return -1;
80106c26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c2b:	c9                   	leave  
80106c2c:	c3                   	ret    

80106c2d <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106c2d:	55                   	push   %ebp
80106c2e:	89 e5                	mov    %esp,%ebp
80106c30:	83 ec 38             	sub    $0x38,%esp
80106c33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c36:	8b 55 10             	mov    0x10(%ebp),%edx
80106c39:	8b 45 14             	mov    0x14(%ebp),%eax
80106c3c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106c40:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106c44:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106c48:	83 ec 08             	sub    $0x8,%esp
80106c4b:	8d 45 de             	lea    -0x22(%ebp),%eax
80106c4e:	50                   	push   %eax
80106c4f:	ff 75 08             	pushl  0x8(%ebp)
80106c52:	e8 97 b9 ff ff       	call   801025ee <nameiparent>
80106c57:	83 c4 10             	add    $0x10,%esp
80106c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c61:	75 0a                	jne    80106c6d <create+0x40>
    return 0;
80106c63:	b8 00 00 00 00       	mov    $0x0,%eax
80106c68:	e9 90 01 00 00       	jmp    80106dfd <create+0x1d0>
  ilock(dp);
80106c6d:	83 ec 0c             	sub    $0xc,%esp
80106c70:	ff 75 f4             	pushl  -0xc(%ebp)
80106c73:	e8 9c ad ff ff       	call   80101a14 <ilock>
80106c78:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106c7b:	83 ec 04             	sub    $0x4,%esp
80106c7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c81:	50                   	push   %eax
80106c82:	8d 45 de             	lea    -0x22(%ebp),%eax
80106c85:	50                   	push   %eax
80106c86:	ff 75 f4             	pushl  -0xc(%ebp)
80106c89:	e8 ee b5 ff ff       	call   8010227c <dirlookup>
80106c8e:	83 c4 10             	add    $0x10,%esp
80106c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106c94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106c98:	74 50                	je     80106cea <create+0xbd>
    iunlockput(dp);
80106c9a:	83 ec 0c             	sub    $0xc,%esp
80106c9d:	ff 75 f4             	pushl  -0xc(%ebp)
80106ca0:	e8 2f b0 ff ff       	call   80101cd4 <iunlockput>
80106ca5:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106ca8:	83 ec 0c             	sub    $0xc,%esp
80106cab:	ff 75 f0             	pushl  -0x10(%ebp)
80106cae:	e8 61 ad ff ff       	call   80101a14 <ilock>
80106cb3:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106cb6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106cbb:	75 15                	jne    80106cd2 <create+0xa5>
80106cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cc0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106cc4:	66 83 f8 02          	cmp    $0x2,%ax
80106cc8:	75 08                	jne    80106cd2 <create+0xa5>
      return ip;
80106cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ccd:	e9 2b 01 00 00       	jmp    80106dfd <create+0x1d0>
    iunlockput(ip);
80106cd2:	83 ec 0c             	sub    $0xc,%esp
80106cd5:	ff 75 f0             	pushl  -0x10(%ebp)
80106cd8:	e8 f7 af ff ff       	call   80101cd4 <iunlockput>
80106cdd:	83 c4 10             	add    $0x10,%esp
    return 0;
80106ce0:	b8 00 00 00 00       	mov    $0x0,%eax
80106ce5:	e9 13 01 00 00       	jmp    80106dfd <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106cea:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cf1:	8b 00                	mov    (%eax),%eax
80106cf3:	83 ec 08             	sub    $0x8,%esp
80106cf6:	52                   	push   %edx
80106cf7:	50                   	push   %eax
80106cf8:	e8 66 aa ff ff       	call   80101763 <ialloc>
80106cfd:	83 c4 10             	add    $0x10,%esp
80106d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106d03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d07:	75 0d                	jne    80106d16 <create+0xe9>
    panic("create: ialloc");
80106d09:	83 ec 0c             	sub    $0xc,%esp
80106d0c:	68 b6 9b 10 80       	push   $0x80109bb6
80106d11:	e8 50 98 ff ff       	call   80100566 <panic>

  ilock(ip);
80106d16:	83 ec 0c             	sub    $0xc,%esp
80106d19:	ff 75 f0             	pushl  -0x10(%ebp)
80106d1c:	e8 f3 ac ff ff       	call   80101a14 <ilock>
80106d21:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d27:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106d2b:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d32:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106d36:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d3d:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106d43:	83 ec 0c             	sub    $0xc,%esp
80106d46:	ff 75 f0             	pushl  -0x10(%ebp)
80106d49:	e8 ec aa ff ff       	call   8010183a <iupdate>
80106d4e:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106d51:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106d56:	75 6a                	jne    80106dc2 <create+0x195>
    dp->nlink++;  // for ".."
80106d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d5b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106d5f:	83 c0 01             	add    $0x1,%eax
80106d62:	89 c2                	mov    %eax,%edx
80106d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d67:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106d6b:	83 ec 0c             	sub    $0xc,%esp
80106d6e:	ff 75 f4             	pushl  -0xc(%ebp)
80106d71:	e8 c4 aa ff ff       	call   8010183a <iupdate>
80106d76:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d7c:	8b 40 04             	mov    0x4(%eax),%eax
80106d7f:	83 ec 04             	sub    $0x4,%esp
80106d82:	50                   	push   %eax
80106d83:	68 90 9b 10 80       	push   $0x80109b90
80106d88:	ff 75 f0             	pushl  -0x10(%ebp)
80106d8b:	e8 a6 b5 ff ff       	call   80102336 <dirlink>
80106d90:	83 c4 10             	add    $0x10,%esp
80106d93:	85 c0                	test   %eax,%eax
80106d95:	78 1e                	js     80106db5 <create+0x188>
80106d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d9a:	8b 40 04             	mov    0x4(%eax),%eax
80106d9d:	83 ec 04             	sub    $0x4,%esp
80106da0:	50                   	push   %eax
80106da1:	68 92 9b 10 80       	push   $0x80109b92
80106da6:	ff 75 f0             	pushl  -0x10(%ebp)
80106da9:	e8 88 b5 ff ff       	call   80102336 <dirlink>
80106dae:	83 c4 10             	add    $0x10,%esp
80106db1:	85 c0                	test   %eax,%eax
80106db3:	79 0d                	jns    80106dc2 <create+0x195>
      panic("create dots");
80106db5:	83 ec 0c             	sub    $0xc,%esp
80106db8:	68 c5 9b 10 80       	push   $0x80109bc5
80106dbd:	e8 a4 97 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106dc5:	8b 40 04             	mov    0x4(%eax),%eax
80106dc8:	83 ec 04             	sub    $0x4,%esp
80106dcb:	50                   	push   %eax
80106dcc:	8d 45 de             	lea    -0x22(%ebp),%eax
80106dcf:	50                   	push   %eax
80106dd0:	ff 75 f4             	pushl  -0xc(%ebp)
80106dd3:	e8 5e b5 ff ff       	call   80102336 <dirlink>
80106dd8:	83 c4 10             	add    $0x10,%esp
80106ddb:	85 c0                	test   %eax,%eax
80106ddd:	79 0d                	jns    80106dec <create+0x1bf>
    panic("create: dirlink");
80106ddf:	83 ec 0c             	sub    $0xc,%esp
80106de2:	68 d1 9b 10 80       	push   $0x80109bd1
80106de7:	e8 7a 97 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80106dec:	83 ec 0c             	sub    $0xc,%esp
80106def:	ff 75 f4             	pushl  -0xc(%ebp)
80106df2:	e8 dd ae ff ff       	call   80101cd4 <iunlockput>
80106df7:	83 c4 10             	add    $0x10,%esp

  return ip;
80106dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106dfd:	c9                   	leave  
80106dfe:	c3                   	ret    

80106dff <sys_open>:

int
sys_open(void)
{
80106dff:	55                   	push   %ebp
80106e00:	89 e5                	mov    %esp,%ebp
80106e02:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106e05:	83 ec 08             	sub    $0x8,%esp
80106e08:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106e0b:	50                   	push   %eax
80106e0c:	6a 00                	push   $0x0
80106e0e:	e8 eb f6 ff ff       	call   801064fe <argstr>
80106e13:	83 c4 10             	add    $0x10,%esp
80106e16:	85 c0                	test   %eax,%eax
80106e18:	78 15                	js     80106e2f <sys_open+0x30>
80106e1a:	83 ec 08             	sub    $0x8,%esp
80106e1d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106e20:	50                   	push   %eax
80106e21:	6a 01                	push   $0x1
80106e23:	e8 51 f6 ff ff       	call   80106479 <argint>
80106e28:	83 c4 10             	add    $0x10,%esp
80106e2b:	85 c0                	test   %eax,%eax
80106e2d:	79 0a                	jns    80106e39 <sys_open+0x3a>
    return -1;
80106e2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e34:	e9 61 01 00 00       	jmp    80106f9a <sys_open+0x19b>

  begin_op();
80106e39:	e8 b9 c7 ff ff       	call   801035f7 <begin_op>

  if(omode & O_CREATE){
80106e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e41:	25 00 02 00 00       	and    $0x200,%eax
80106e46:	85 c0                	test   %eax,%eax
80106e48:	74 2a                	je     80106e74 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106e4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106e4d:	6a 00                	push   $0x0
80106e4f:	6a 00                	push   $0x0
80106e51:	6a 02                	push   $0x2
80106e53:	50                   	push   %eax
80106e54:	e8 d4 fd ff ff       	call   80106c2d <create>
80106e59:	83 c4 10             	add    $0x10,%esp
80106e5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106e5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e63:	75 75                	jne    80106eda <sys_open+0xdb>
      end_op();
80106e65:	e8 19 c8 ff ff       	call   80103683 <end_op>
      return -1;
80106e6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e6f:	e9 26 01 00 00       	jmp    80106f9a <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106e74:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106e77:	83 ec 0c             	sub    $0xc,%esp
80106e7a:	50                   	push   %eax
80106e7b:	e8 52 b7 ff ff       	call   801025d2 <namei>
80106e80:	83 c4 10             	add    $0x10,%esp
80106e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e8a:	75 0f                	jne    80106e9b <sys_open+0x9c>
      end_op();
80106e8c:	e8 f2 c7 ff ff       	call   80103683 <end_op>
      return -1;
80106e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e96:	e9 ff 00 00 00       	jmp    80106f9a <sys_open+0x19b>
    }
    ilock(ip);
80106e9b:	83 ec 0c             	sub    $0xc,%esp
80106e9e:	ff 75 f4             	pushl  -0xc(%ebp)
80106ea1:	e8 6e ab ff ff       	call   80101a14 <ilock>
80106ea6:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eac:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106eb0:	66 83 f8 01          	cmp    $0x1,%ax
80106eb4:	75 24                	jne    80106eda <sys_open+0xdb>
80106eb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106eb9:	85 c0                	test   %eax,%eax
80106ebb:	74 1d                	je     80106eda <sys_open+0xdb>
      iunlockput(ip);
80106ebd:	83 ec 0c             	sub    $0xc,%esp
80106ec0:	ff 75 f4             	pushl  -0xc(%ebp)
80106ec3:	e8 0c ae ff ff       	call   80101cd4 <iunlockput>
80106ec8:	83 c4 10             	add    $0x10,%esp
      end_op();
80106ecb:	e8 b3 c7 ff ff       	call   80103683 <end_op>
      return -1;
80106ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ed5:	e9 c0 00 00 00       	jmp    80106f9a <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106eda:	e8 5e a1 ff ff       	call   8010103d <filealloc>
80106edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106ee2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ee6:	74 17                	je     80106eff <sys_open+0x100>
80106ee8:	83 ec 0c             	sub    $0xc,%esp
80106eeb:	ff 75 f0             	pushl  -0x10(%ebp)
80106eee:	e8 37 f7 ff ff       	call   8010662a <fdalloc>
80106ef3:	83 c4 10             	add    $0x10,%esp
80106ef6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106ef9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106efd:	79 2e                	jns    80106f2d <sys_open+0x12e>
    if(f)
80106eff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106f03:	74 0e                	je     80106f13 <sys_open+0x114>
      fileclose(f);
80106f05:	83 ec 0c             	sub    $0xc,%esp
80106f08:	ff 75 f0             	pushl  -0x10(%ebp)
80106f0b:	e8 eb a1 ff ff       	call   801010fb <fileclose>
80106f10:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106f13:	83 ec 0c             	sub    $0xc,%esp
80106f16:	ff 75 f4             	pushl  -0xc(%ebp)
80106f19:	e8 b6 ad ff ff       	call   80101cd4 <iunlockput>
80106f1e:	83 c4 10             	add    $0x10,%esp
    end_op();
80106f21:	e8 5d c7 ff ff       	call   80103683 <end_op>
    return -1;
80106f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f2b:	eb 6d                	jmp    80106f9a <sys_open+0x19b>
  }
  iunlock(ip);
80106f2d:	83 ec 0c             	sub    $0xc,%esp
80106f30:	ff 75 f4             	pushl  -0xc(%ebp)
80106f33:	e8 3a ac ff ff       	call   80101b72 <iunlock>
80106f38:	83 c4 10             	add    $0x10,%esp
  end_op();
80106f3b:	e8 43 c7 ff ff       	call   80103683 <end_op>

  f->type = FD_INODE;
80106f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f43:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f4f:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f55:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f5f:	83 e0 01             	and    $0x1,%eax
80106f62:	85 c0                	test   %eax,%eax
80106f64:	0f 94 c0             	sete   %al
80106f67:	89 c2                	mov    %eax,%edx
80106f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f6c:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106f6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f72:	83 e0 01             	and    $0x1,%eax
80106f75:	85 c0                	test   %eax,%eax
80106f77:	75 0a                	jne    80106f83 <sys_open+0x184>
80106f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f7c:	83 e0 02             	and    $0x2,%eax
80106f7f:	85 c0                	test   %eax,%eax
80106f81:	74 07                	je     80106f8a <sys_open+0x18b>
80106f83:	b8 01 00 00 00       	mov    $0x1,%eax
80106f88:	eb 05                	jmp    80106f8f <sys_open+0x190>
80106f8a:	b8 00 00 00 00       	mov    $0x0,%eax
80106f8f:	89 c2                	mov    %eax,%edx
80106f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f94:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106f9a:	c9                   	leave  
80106f9b:	c3                   	ret    

80106f9c <sys_mkdir>:

int
sys_mkdir(void)
{
80106f9c:	55                   	push   %ebp
80106f9d:	89 e5                	mov    %esp,%ebp
80106f9f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106fa2:	e8 50 c6 ff ff       	call   801035f7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106fa7:	83 ec 08             	sub    $0x8,%esp
80106faa:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fad:	50                   	push   %eax
80106fae:	6a 00                	push   $0x0
80106fb0:	e8 49 f5 ff ff       	call   801064fe <argstr>
80106fb5:	83 c4 10             	add    $0x10,%esp
80106fb8:	85 c0                	test   %eax,%eax
80106fba:	78 1b                	js     80106fd7 <sys_mkdir+0x3b>
80106fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fbf:	6a 00                	push   $0x0
80106fc1:	6a 00                	push   $0x0
80106fc3:	6a 01                	push   $0x1
80106fc5:	50                   	push   %eax
80106fc6:	e8 62 fc ff ff       	call   80106c2d <create>
80106fcb:	83 c4 10             	add    $0x10,%esp
80106fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fd5:	75 0c                	jne    80106fe3 <sys_mkdir+0x47>
    end_op();
80106fd7:	e8 a7 c6 ff ff       	call   80103683 <end_op>
    return -1;
80106fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fe1:	eb 18                	jmp    80106ffb <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106fe3:	83 ec 0c             	sub    $0xc,%esp
80106fe6:	ff 75 f4             	pushl  -0xc(%ebp)
80106fe9:	e8 e6 ac ff ff       	call   80101cd4 <iunlockput>
80106fee:	83 c4 10             	add    $0x10,%esp
  end_op();
80106ff1:	e8 8d c6 ff ff       	call   80103683 <end_op>
  return 0;
80106ff6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ffb:	c9                   	leave  
80106ffc:	c3                   	ret    

80106ffd <sys_mknod>:

int
sys_mknod(void)
{
80106ffd:	55                   	push   %ebp
80106ffe:	89 e5                	mov    %esp,%ebp
80107000:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107003:	e8 ef c5 ff ff       	call   801035f7 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107008:	83 ec 08             	sub    $0x8,%esp
8010700b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010700e:	50                   	push   %eax
8010700f:	6a 00                	push   $0x0
80107011:	e8 e8 f4 ff ff       	call   801064fe <argstr>
80107016:	83 c4 10             	add    $0x10,%esp
80107019:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010701c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107020:	78 4f                	js     80107071 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107022:	83 ec 08             	sub    $0x8,%esp
80107025:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107028:	50                   	push   %eax
80107029:	6a 01                	push   $0x1
8010702b:	e8 49 f4 ff ff       	call   80106479 <argint>
80107030:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107033:	85 c0                	test   %eax,%eax
80107035:	78 3a                	js     80107071 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107037:	83 ec 08             	sub    $0x8,%esp
8010703a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010703d:	50                   	push   %eax
8010703e:	6a 02                	push   $0x2
80107040:	e8 34 f4 ff ff       	call   80106479 <argint>
80107045:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107048:	85 c0                	test   %eax,%eax
8010704a:	78 25                	js     80107071 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010704c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010704f:	0f bf c8             	movswl %ax,%ecx
80107052:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107055:	0f bf d0             	movswl %ax,%edx
80107058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010705b:	51                   	push   %ecx
8010705c:	52                   	push   %edx
8010705d:	6a 03                	push   $0x3
8010705f:	50                   	push   %eax
80107060:	e8 c8 fb ff ff       	call   80106c2d <create>
80107065:	83 c4 10             	add    $0x10,%esp
80107068:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010706b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010706f:	75 0c                	jne    8010707d <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107071:	e8 0d c6 ff ff       	call   80103683 <end_op>
    return -1;
80107076:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010707b:	eb 18                	jmp    80107095 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010707d:	83 ec 0c             	sub    $0xc,%esp
80107080:	ff 75 f0             	pushl  -0x10(%ebp)
80107083:	e8 4c ac ff ff       	call   80101cd4 <iunlockput>
80107088:	83 c4 10             	add    $0x10,%esp
  end_op();
8010708b:	e8 f3 c5 ff ff       	call   80103683 <end_op>
  return 0;
80107090:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107095:	c9                   	leave  
80107096:	c3                   	ret    

80107097 <sys_chdir>:

int
sys_chdir(void)
{
80107097:	55                   	push   %ebp
80107098:	89 e5                	mov    %esp,%ebp
8010709a:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010709d:	e8 55 c5 ff ff       	call   801035f7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801070a2:	83 ec 08             	sub    $0x8,%esp
801070a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070a8:	50                   	push   %eax
801070a9:	6a 00                	push   $0x0
801070ab:	e8 4e f4 ff ff       	call   801064fe <argstr>
801070b0:	83 c4 10             	add    $0x10,%esp
801070b3:	85 c0                	test   %eax,%eax
801070b5:	78 18                	js     801070cf <sys_chdir+0x38>
801070b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070ba:	83 ec 0c             	sub    $0xc,%esp
801070bd:	50                   	push   %eax
801070be:	e8 0f b5 ff ff       	call   801025d2 <namei>
801070c3:	83 c4 10             	add    $0x10,%esp
801070c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801070c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801070cd:	75 0c                	jne    801070db <sys_chdir+0x44>
    end_op();
801070cf:	e8 af c5 ff ff       	call   80103683 <end_op>
    return -1;
801070d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070d9:	eb 6e                	jmp    80107149 <sys_chdir+0xb2>
  }
  ilock(ip);
801070db:	83 ec 0c             	sub    $0xc,%esp
801070de:	ff 75 f4             	pushl  -0xc(%ebp)
801070e1:	e8 2e a9 ff ff       	call   80101a14 <ilock>
801070e6:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801070e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070ec:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801070f0:	66 83 f8 01          	cmp    $0x1,%ax
801070f4:	74 1a                	je     80107110 <sys_chdir+0x79>
    iunlockput(ip);
801070f6:	83 ec 0c             	sub    $0xc,%esp
801070f9:	ff 75 f4             	pushl  -0xc(%ebp)
801070fc:	e8 d3 ab ff ff       	call   80101cd4 <iunlockput>
80107101:	83 c4 10             	add    $0x10,%esp
    end_op();
80107104:	e8 7a c5 ff ff       	call   80103683 <end_op>
    return -1;
80107109:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010710e:	eb 39                	jmp    80107149 <sys_chdir+0xb2>
  }
  iunlock(ip);
80107110:	83 ec 0c             	sub    $0xc,%esp
80107113:	ff 75 f4             	pushl  -0xc(%ebp)
80107116:	e8 57 aa ff ff       	call   80101b72 <iunlock>
8010711b:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010711e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107124:	8b 40 68             	mov    0x68(%eax),%eax
80107127:	83 ec 0c             	sub    $0xc,%esp
8010712a:	50                   	push   %eax
8010712b:	e8 b4 aa ff ff       	call   80101be4 <iput>
80107130:	83 c4 10             	add    $0x10,%esp
  end_op();
80107133:	e8 4b c5 ff ff       	call   80103683 <end_op>
  proc->cwd = ip;
80107138:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010713e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107141:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107144:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107149:	c9                   	leave  
8010714a:	c3                   	ret    

8010714b <sys_exec>:

int
sys_exec(void)
{
8010714b:	55                   	push   %ebp
8010714c:	89 e5                	mov    %esp,%ebp
8010714e:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107154:	83 ec 08             	sub    $0x8,%esp
80107157:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010715a:	50                   	push   %eax
8010715b:	6a 00                	push   $0x0
8010715d:	e8 9c f3 ff ff       	call   801064fe <argstr>
80107162:	83 c4 10             	add    $0x10,%esp
80107165:	85 c0                	test   %eax,%eax
80107167:	78 18                	js     80107181 <sys_exec+0x36>
80107169:	83 ec 08             	sub    $0x8,%esp
8010716c:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107172:	50                   	push   %eax
80107173:	6a 01                	push   $0x1
80107175:	e8 ff f2 ff ff       	call   80106479 <argint>
8010717a:	83 c4 10             	add    $0x10,%esp
8010717d:	85 c0                	test   %eax,%eax
8010717f:	79 0a                	jns    8010718b <sys_exec+0x40>
    return -1;
80107181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107186:	e9 c6 00 00 00       	jmp    80107251 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010718b:	83 ec 04             	sub    $0x4,%esp
8010718e:	68 80 00 00 00       	push   $0x80
80107193:	6a 00                	push   $0x0
80107195:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010719b:	50                   	push   %eax
8010719c:	e8 b3 ef ff ff       	call   80106154 <memset>
801071a1:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801071a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801071ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ae:	83 f8 1f             	cmp    $0x1f,%eax
801071b1:	76 0a                	jbe    801071bd <sys_exec+0x72>
      return -1;
801071b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071b8:	e9 94 00 00 00       	jmp    80107251 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801071bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c0:	c1 e0 02             	shl    $0x2,%eax
801071c3:	89 c2                	mov    %eax,%edx
801071c5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801071cb:	01 c2                	add    %eax,%edx
801071cd:	83 ec 08             	sub    $0x8,%esp
801071d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801071d6:	50                   	push   %eax
801071d7:	52                   	push   %edx
801071d8:	e8 00 f2 ff ff       	call   801063dd <fetchint>
801071dd:	83 c4 10             	add    $0x10,%esp
801071e0:	85 c0                	test   %eax,%eax
801071e2:	79 07                	jns    801071eb <sys_exec+0xa0>
      return -1;
801071e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071e9:	eb 66                	jmp    80107251 <sys_exec+0x106>
    if(uarg == 0){
801071eb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801071f1:	85 c0                	test   %eax,%eax
801071f3:	75 27                	jne    8010721c <sys_exec+0xd1>
      argv[i] = 0;
801071f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071f8:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801071ff:	00 00 00 00 
      break;
80107203:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107204:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107207:	83 ec 08             	sub    $0x8,%esp
8010720a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107210:	52                   	push   %edx
80107211:	50                   	push   %eax
80107212:	e8 04 9a ff ff       	call   80100c1b <exec>
80107217:	83 c4 10             	add    $0x10,%esp
8010721a:	eb 35                	jmp    80107251 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010721c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107222:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107225:	c1 e2 02             	shl    $0x2,%edx
80107228:	01 c2                	add    %eax,%edx
8010722a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107230:	83 ec 08             	sub    $0x8,%esp
80107233:	52                   	push   %edx
80107234:	50                   	push   %eax
80107235:	e8 dd f1 ff ff       	call   80106417 <fetchstr>
8010723a:	83 c4 10             	add    $0x10,%esp
8010723d:	85 c0                	test   %eax,%eax
8010723f:	79 07                	jns    80107248 <sys_exec+0xfd>
      return -1;
80107241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107246:	eb 09                	jmp    80107251 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107248:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010724c:	e9 5a ff ff ff       	jmp    801071ab <sys_exec+0x60>
  return exec(path, argv);
}
80107251:	c9                   	leave  
80107252:	c3                   	ret    

80107253 <sys_pipe>:

int
sys_pipe(void)
{
80107253:	55                   	push   %ebp
80107254:	89 e5                	mov    %esp,%ebp
80107256:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107259:	83 ec 04             	sub    $0x4,%esp
8010725c:	6a 08                	push   $0x8
8010725e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107261:	50                   	push   %eax
80107262:	6a 00                	push   $0x0
80107264:	e8 38 f2 ff ff       	call   801064a1 <argptr>
80107269:	83 c4 10             	add    $0x10,%esp
8010726c:	85 c0                	test   %eax,%eax
8010726e:	79 0a                	jns    8010727a <sys_pipe+0x27>
    return -1;
80107270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107275:	e9 af 00 00 00       	jmp    80107329 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
8010727a:	83 ec 08             	sub    $0x8,%esp
8010727d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107280:	50                   	push   %eax
80107281:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107284:	50                   	push   %eax
80107285:	e8 61 ce ff ff       	call   801040eb <pipealloc>
8010728a:	83 c4 10             	add    $0x10,%esp
8010728d:	85 c0                	test   %eax,%eax
8010728f:	79 0a                	jns    8010729b <sys_pipe+0x48>
    return -1;
80107291:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107296:	e9 8e 00 00 00       	jmp    80107329 <sys_pipe+0xd6>
  fd0 = -1;
8010729b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801072a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801072a5:	83 ec 0c             	sub    $0xc,%esp
801072a8:	50                   	push   %eax
801072a9:	e8 7c f3 ff ff       	call   8010662a <fdalloc>
801072ae:	83 c4 10             	add    $0x10,%esp
801072b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801072b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072b8:	78 18                	js     801072d2 <sys_pipe+0x7f>
801072ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072bd:	83 ec 0c             	sub    $0xc,%esp
801072c0:	50                   	push   %eax
801072c1:	e8 64 f3 ff ff       	call   8010662a <fdalloc>
801072c6:	83 c4 10             	add    $0x10,%esp
801072c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801072cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801072d0:	79 3f                	jns    80107311 <sys_pipe+0xbe>
    if(fd0 >= 0)
801072d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072d6:	78 14                	js     801072ec <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801072d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801072e1:	83 c2 08             	add    $0x8,%edx
801072e4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801072eb:	00 
    fileclose(rf);
801072ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
801072ef:	83 ec 0c             	sub    $0xc,%esp
801072f2:	50                   	push   %eax
801072f3:	e8 03 9e ff ff       	call   801010fb <fileclose>
801072f8:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801072fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072fe:	83 ec 0c             	sub    $0xc,%esp
80107301:	50                   	push   %eax
80107302:	e8 f4 9d ff ff       	call   801010fb <fileclose>
80107307:	83 c4 10             	add    $0x10,%esp
    return -1;
8010730a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010730f:	eb 18                	jmp    80107329 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107311:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107314:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107317:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107319:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010731c:	8d 50 04             	lea    0x4(%eax),%edx
8010731f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107322:	89 02                	mov    %eax,(%edx)
  return 0;
80107324:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107329:	c9                   	leave  
8010732a:	c3                   	ret    

8010732b <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
8010732b:	55                   	push   %ebp
8010732c:	89 e5                	mov    %esp,%ebp
8010732e:	83 ec 08             	sub    $0x8,%esp
80107331:	8b 55 08             	mov    0x8(%ebp),%edx
80107334:	8b 45 0c             	mov    0xc(%ebp),%eax
80107337:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010733b:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010733f:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107343:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107347:	66 ef                	out    %ax,(%dx)
}
80107349:	90                   	nop
8010734a:	c9                   	leave  
8010734b:	c3                   	ret    

8010734c <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
8010734c:	55                   	push   %ebp
8010734d:	89 e5                	mov    %esp,%ebp
8010734f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107352:	e8 40 d6 ff ff       	call   80104997 <fork>
}
80107357:	c9                   	leave  
80107358:	c3                   	ret    

80107359 <sys_exit>:

int
sys_exit(void)
{
80107359:	55                   	push   %ebp
8010735a:	89 e5                	mov    %esp,%ebp
8010735c:	83 ec 08             	sub    $0x8,%esp
  exit();
8010735f:	e8 a9 d8 ff ff       	call   80104c0d <exit>
  return 0;  // not reached
80107364:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107369:	c9                   	leave  
8010736a:	c3                   	ret    

8010736b <sys_wait>:

int
sys_wait(void)
{
8010736b:	55                   	push   %ebp
8010736c:	89 e5                	mov    %esp,%ebp
8010736e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107371:	e8 4e da ff ff       	call   80104dc4 <wait>
}
80107376:	c9                   	leave  
80107377:	c3                   	ret    

80107378 <sys_kill>:

int
sys_kill(void)
{
80107378:	55                   	push   %ebp
80107379:	89 e5                	mov    %esp,%ebp
8010737b:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010737e:	83 ec 08             	sub    $0x8,%esp
80107381:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107384:	50                   	push   %eax
80107385:	6a 00                	push   $0x0
80107387:	e8 ed f0 ff ff       	call   80106479 <argint>
8010738c:	83 c4 10             	add    $0x10,%esp
8010738f:	85 c0                	test   %eax,%eax
80107391:	79 07                	jns    8010739a <sys_kill+0x22>
    return -1;
80107393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107398:	eb 0f                	jmp    801073a9 <sys_kill+0x31>
  return kill(pid);
8010739a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739d:	83 ec 0c             	sub    $0xc,%esp
801073a0:	50                   	push   %eax
801073a1:	e8 00 e0 ff ff       	call   801053a6 <kill>
801073a6:	83 c4 10             	add    $0x10,%esp
}
801073a9:	c9                   	leave  
801073aa:	c3                   	ret    

801073ab <sys_getpid>:

int
sys_getpid(void)
{
801073ab:	55                   	push   %ebp
801073ac:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801073ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073b4:	8b 40 10             	mov    0x10(%eax),%eax
}
801073b7:	5d                   	pop    %ebp
801073b8:	c3                   	ret    

801073b9 <sys_sbrk>:

int
sys_sbrk(void)
{
801073b9:	55                   	push   %ebp
801073ba:	89 e5                	mov    %esp,%ebp
801073bc:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801073bf:	83 ec 08             	sub    $0x8,%esp
801073c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801073c5:	50                   	push   %eax
801073c6:	6a 00                	push   $0x0
801073c8:	e8 ac f0 ff ff       	call   80106479 <argint>
801073cd:	83 c4 10             	add    $0x10,%esp
801073d0:	85 c0                	test   %eax,%eax
801073d2:	79 07                	jns    801073db <sys_sbrk+0x22>
    return -1;
801073d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073d9:	eb 28                	jmp    80107403 <sys_sbrk+0x4a>
  addr = proc->sz;
801073db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073e1:	8b 00                	mov    (%eax),%eax
801073e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801073e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073e9:	83 ec 0c             	sub    $0xc,%esp
801073ec:	50                   	push   %eax
801073ed:	e8 02 d5 ff ff       	call   801048f4 <growproc>
801073f2:	83 c4 10             	add    $0x10,%esp
801073f5:	85 c0                	test   %eax,%eax
801073f7:	79 07                	jns    80107400 <sys_sbrk+0x47>
    return -1;
801073f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073fe:	eb 03                	jmp    80107403 <sys_sbrk+0x4a>
  return addr;
80107400:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107403:	c9                   	leave  
80107404:	c3                   	ret    

80107405 <sys_sleep>:

int
sys_sleep(void)
{
80107405:	55                   	push   %ebp
80107406:	89 e5                	mov    %esp,%ebp
80107408:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010740b:	83 ec 08             	sub    $0x8,%esp
8010740e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107411:	50                   	push   %eax
80107412:	6a 00                	push   $0x0
80107414:	e8 60 f0 ff ff       	call   80106479 <argint>
80107419:	83 c4 10             	add    $0x10,%esp
8010741c:	85 c0                	test   %eax,%eax
8010741e:	79 07                	jns    80107427 <sys_sleep+0x22>
    return -1;
80107420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107425:	eb 44                	jmp    8010746b <sys_sleep+0x66>
  ticks0 = ticks;
80107427:	a1 e0 66 11 80       	mov    0x801166e0,%eax
8010742c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010742f:	eb 26                	jmp    80107457 <sys_sleep+0x52>
    if(proc->killed){
80107431:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107437:	8b 40 24             	mov    0x24(%eax),%eax
8010743a:	85 c0                	test   %eax,%eax
8010743c:	74 07                	je     80107445 <sys_sleep+0x40>
      return -1;
8010743e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107443:	eb 26                	jmp    8010746b <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107445:	83 ec 08             	sub    $0x8,%esp
80107448:	6a 00                	push   $0x0
8010744a:	68 e0 66 11 80       	push   $0x801166e0
8010744f:	e8 c5 dd ff ff       	call   80105219 <sleep>
80107454:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107457:	a1 e0 66 11 80       	mov    0x801166e0,%eax
8010745c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010745f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107462:	39 d0                	cmp    %edx,%eax
80107464:	72 cb                	jb     80107431 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107466:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010746b:	c9                   	leave  
8010746c:	c3                   	ret    

8010746d <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
8010746d:	55                   	push   %ebp
8010746e:	89 e5                	mov    %esp,%ebp
80107470:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107473:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80107478:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
8010747b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010747e:	c9                   	leave  
8010747f:	c3                   	ret    

80107480 <sys_halt>:

//Turn of the computer
int sys_halt(void){
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107486:	83 ec 0c             	sub    $0xc,%esp
80107489:	68 e1 9b 10 80       	push   $0x80109be1
8010748e:	e8 33 8f ff ff       	call   801003c6 <cprintf>
80107493:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
80107496:	83 ec 08             	sub    $0x8,%esp
80107499:	68 00 20 00 00       	push   $0x2000
8010749e:	68 04 06 00 00       	push   $0x604
801074a3:	e8 83 fe ff ff       	call   8010732b <outw>
801074a8:	83 c4 10             	add    $0x10,%esp
  return 0;
801074ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
801074b0:	c9                   	leave  
801074b1:	c3                   	ret    

801074b2 <sys_date>:

// My implementation of sys_date()
int
sys_date(void)
{
801074b2:	55                   	push   %ebp
801074b3:	89 e5                	mov    %esp,%ebp
801074b5:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if (argptr(0, (void*)&d, sizeof(*d)) < 0)
801074b8:	83 ec 04             	sub    $0x4,%esp
801074bb:	6a 18                	push   $0x18
801074bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801074c0:	50                   	push   %eax
801074c1:	6a 00                	push   $0x0
801074c3:	e8 d9 ef ff ff       	call   801064a1 <argptr>
801074c8:	83 c4 10             	add    $0x10,%esp
801074cb:	85 c0                	test   %eax,%eax
801074cd:	79 07                	jns    801074d6 <sys_date+0x24>
    return -1;
801074cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074d4:	eb 14                	jmp    801074ea <sys_date+0x38>
  // MY CODE HERE
  cmostime(d);       
801074d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d9:	83 ec 0c             	sub    $0xc,%esp
801074dc:	50                   	push   %eax
801074dd:	e8 90 bd ff ff       	call   80103272 <cmostime>
801074e2:	83 c4 10             	add    $0x10,%esp
  return 0; 
801074e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801074ea:	c9                   	leave  
801074eb:	c3                   	ret    

801074ec <sys_getuid>:

// My implementation of sys_getuid
uint
sys_getuid(void)
{
801074ec:	55                   	push   %ebp
801074ed:	89 e5                	mov    %esp,%ebp
  return proc->uid;
801074ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074f5:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
801074fb:	5d                   	pop    %ebp
801074fc:	c3                   	ret    

801074fd <sys_getgid>:

// My implementation of sys_getgid
uint
sys_getgid(void)
{
801074fd:	55                   	push   %ebp
801074fe:	89 e5                	mov    %esp,%ebp
  return proc->gid;
80107500:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107506:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
8010750c:	5d                   	pop    %ebp
8010750d:	c3                   	ret    

8010750e <sys_getppid>:

// My implementation of sys_getppid
uint
sys_getppid(void)
{
8010750e:	55                   	push   %ebp
8010750f:	89 e5                	mov    %esp,%ebp
  return proc->parent ? proc->parent->pid : proc->pid;
80107511:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107517:	8b 40 14             	mov    0x14(%eax),%eax
8010751a:	85 c0                	test   %eax,%eax
8010751c:	74 0e                	je     8010752c <sys_getppid+0x1e>
8010751e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107524:	8b 40 14             	mov    0x14(%eax),%eax
80107527:	8b 40 10             	mov    0x10(%eax),%eax
8010752a:	eb 09                	jmp    80107535 <sys_getppid+0x27>
8010752c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107532:	8b 40 10             	mov    0x10(%eax),%eax
}
80107535:	5d                   	pop    %ebp
80107536:	c3                   	ret    

80107537 <sys_setuid>:


// Implementation of sys_setuid
int 
sys_setuid(void)
{
80107537:	55                   	push   %ebp
80107538:	89 e5                	mov    %esp,%ebp
8010753a:	83 ec 18             	sub    $0x18,%esp
  int id; // uid argument
  // Grab argument off the stack and store in id
  argint(0, &id);
8010753d:	83 ec 08             	sub    $0x8,%esp
80107540:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107543:	50                   	push   %eax
80107544:	6a 00                	push   $0x0
80107546:	e8 2e ef ff ff       	call   80106479 <argint>
8010754b:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
8010754e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107551:	85 c0                	test   %eax,%eax
80107553:	78 0a                	js     8010755f <sys_setuid+0x28>
80107555:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107558:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010755d:	7e 07                	jle    80107566 <sys_setuid+0x2f>
    return -1;
8010755f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107564:	eb 14                	jmp    8010757a <sys_setuid+0x43>
  proc->uid = id; 
80107566:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010756c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010756f:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80107575:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010757a:	c9                   	leave  
8010757b:	c3                   	ret    

8010757c <sys_setgid>:

// Implementation of sys_setgid
int
sys_setgid(void)
{
8010757c:	55                   	push   %ebp
8010757d:	89 e5                	mov    %esp,%ebp
8010757f:	83 ec 18             	sub    $0x18,%esp
  int id; // gid argument 
  // Grab argument off the stack and store in id
  argint(0, &id);
80107582:	83 ec 08             	sub    $0x8,%esp
80107585:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107588:	50                   	push   %eax
80107589:	6a 00                	push   $0x0
8010758b:	e8 e9 ee ff ff       	call   80106479 <argint>
80107590:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
80107593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107596:	85 c0                	test   %eax,%eax
80107598:	78 0a                	js     801075a4 <sys_setgid+0x28>
8010759a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759d:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801075a2:	7e 07                	jle    801075ab <sys_setgid+0x2f>
    return -1;
801075a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075a9:	eb 14                	jmp    801075bf <sys_setgid+0x43>
  proc->gid = id;
801075ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801075b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801075b4:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  return 0;
801075ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
801075bf:	c9                   	leave  
801075c0:	c3                   	ret    

801075c1 <sys_getprocs>:

// Implementation of sys_getprocs
int
sys_getprocs(void)
{
801075c1:	55                   	push   %ebp
801075c2:	89 e5                	mov    %esp,%ebp
801075c4:	83 ec 18             	sub    $0x18,%esp
  int m; // Max arg
  struct uproc* table;
  argint(0, &m);
801075c7:	83 ec 08             	sub    $0x8,%esp
801075ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801075cd:	50                   	push   %eax
801075ce:	6a 00                	push   $0x0
801075d0:	e8 a4 ee ff ff       	call   80106479 <argint>
801075d5:	83 c4 10             	add    $0x10,%esp
  if (m < 0)
801075d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075db:	85 c0                	test   %eax,%eax
801075dd:	79 07                	jns    801075e6 <sys_getprocs+0x25>
    return -1;
801075df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075e4:	eb 28                	jmp    8010760e <sys_getprocs+0x4d>
  argptr(1, (void*)&table, m);
801075e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e9:	83 ec 04             	sub    $0x4,%esp
801075ec:	50                   	push   %eax
801075ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
801075f0:	50                   	push   %eax
801075f1:	6a 01                	push   $0x1
801075f3:	e8 a9 ee ff ff       	call   801064a1 <argptr>
801075f8:	83 c4 10             	add    $0x10,%esp
  return getproc_helper(m, table);
801075fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801075fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107601:	83 ec 08             	sub    $0x8,%esp
80107604:	52                   	push   %edx
80107605:	50                   	push   %eax
80107606:	e8 c3 e1 ff ff       	call   801057ce <getproc_helper>
8010760b:	83 c4 10             	add    $0x10,%esp
}
8010760e:	c9                   	leave  
8010760f:	c3                   	ret    

80107610 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	83 ec 08             	sub    $0x8,%esp
80107616:	8b 55 08             	mov    0x8(%ebp),%edx
80107619:	8b 45 0c             	mov    0xc(%ebp),%eax
8010761c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107620:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107623:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107627:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010762b:	ee                   	out    %al,(%dx)
}
8010762c:	90                   	nop
8010762d:	c9                   	leave  
8010762e:	c3                   	ret    

8010762f <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010762f:	55                   	push   %ebp
80107630:	89 e5                	mov    %esp,%ebp
80107632:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107635:	6a 34                	push   $0x34
80107637:	6a 43                	push   $0x43
80107639:	e8 d2 ff ff ff       	call   80107610 <outb>
8010763e:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107641:	68 9c 00 00 00       	push   $0x9c
80107646:	6a 40                	push   $0x40
80107648:	e8 c3 ff ff ff       	call   80107610 <outb>
8010764d:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80107650:	6a 2e                	push   $0x2e
80107652:	6a 40                	push   $0x40
80107654:	e8 b7 ff ff ff       	call   80107610 <outb>
80107659:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
8010765c:	83 ec 0c             	sub    $0xc,%esp
8010765f:	6a 00                	push   $0x0
80107661:	e8 6f c9 ff ff       	call   80103fd5 <picenable>
80107666:	83 c4 10             	add    $0x10,%esp
}
80107669:	90                   	nop
8010766a:	c9                   	leave  
8010766b:	c3                   	ret    

8010766c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010766c:	1e                   	push   %ds
  pushl %es
8010766d:	06                   	push   %es
  pushl %fs
8010766e:	0f a0                	push   %fs
  pushl %gs
80107670:	0f a8                	push   %gs
  pushal
80107672:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107673:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107677:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107679:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010767b:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010767f:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107681:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107683:	54                   	push   %esp
  call trap
80107684:	e8 ce 01 00 00       	call   80107857 <trap>
  addl $4, %esp
80107689:	83 c4 04             	add    $0x4,%esp

8010768c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010768c:	61                   	popa   
  popl %gs
8010768d:	0f a9                	pop    %gs
  popl %fs
8010768f:	0f a1                	pop    %fs
  popl %es
80107691:	07                   	pop    %es
  popl %ds
80107692:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107693:	83 c4 08             	add    $0x8,%esp
  iret
80107696:	cf                   	iret   

80107697 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80107697:	55                   	push   %ebp
80107698:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
8010769a:	8b 45 08             	mov    0x8(%ebp),%eax
8010769d:	f0 ff 00             	lock incl (%eax)
}
801076a0:	90                   	nop
801076a1:	5d                   	pop    %ebp
801076a2:	c3                   	ret    

801076a3 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801076a3:	55                   	push   %ebp
801076a4:	89 e5                	mov    %esp,%ebp
801076a6:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801076a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801076ac:	83 e8 01             	sub    $0x1,%eax
801076af:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801076b3:	8b 45 08             	mov    0x8(%ebp),%eax
801076b6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801076ba:	8b 45 08             	mov    0x8(%ebp),%eax
801076bd:	c1 e8 10             	shr    $0x10,%eax
801076c0:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801076c4:	8d 45 fa             	lea    -0x6(%ebp),%eax
801076c7:	0f 01 18             	lidtl  (%eax)
}
801076ca:	90                   	nop
801076cb:	c9                   	leave  
801076cc:	c3                   	ret    

801076cd <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801076cd:	55                   	push   %ebp
801076ce:	89 e5                	mov    %esp,%ebp
801076d0:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801076d3:	0f 20 d0             	mov    %cr2,%eax
801076d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801076d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801076dc:	c9                   	leave  
801076dd:	c3                   	ret    

801076de <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
801076de:	55                   	push   %ebp
801076df:	89 e5                	mov    %esp,%ebp
801076e1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
801076e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801076eb:	e9 c3 00 00 00       	jmp    801077b3 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801076f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801076f3:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
801076fa:	89 c2                	mov    %eax,%edx
801076fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801076ff:	66 89 14 c5 e0 5e 11 	mov    %dx,-0x7feea120(,%eax,8)
80107706:	80 
80107707:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010770a:	66 c7 04 c5 e2 5e 11 	movw   $0x8,-0x7feea11e(,%eax,8)
80107711:	80 08 00 
80107714:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107717:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
8010771e:	80 
8010771f:	83 e2 e0             	and    $0xffffffe0,%edx
80107722:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
80107729:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010772c:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
80107733:	80 
80107734:	83 e2 1f             	and    $0x1f,%edx
80107737:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
8010773e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107741:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80107748:	80 
80107749:	83 e2 f0             	and    $0xfffffff0,%edx
8010774c:	83 ca 0e             	or     $0xe,%edx
8010774f:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80107756:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107759:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80107760:	80 
80107761:	83 e2 ef             	and    $0xffffffef,%edx
80107764:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
8010776b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010776e:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80107775:	80 
80107776:	83 e2 9f             	and    $0xffffff9f,%edx
80107779:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80107780:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107783:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
8010778a:	80 
8010778b:	83 ca 80             	or     $0xffffff80,%edx
8010778e:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80107795:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107798:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
8010779f:	c1 e8 10             	shr    $0x10,%eax
801077a2:	89 c2                	mov    %eax,%edx
801077a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801077a7:	66 89 14 c5 e6 5e 11 	mov    %dx,-0x7feea11a(,%eax,8)
801077ae:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801077af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801077b3:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
801077ba:	0f 8e 30 ff ff ff    	jle    801076f0 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801077c0:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
801077c5:	66 a3 e0 60 11 80    	mov    %ax,0x801160e0
801077cb:	66 c7 05 e2 60 11 80 	movw   $0x8,0x801160e2
801077d2:	08 00 
801077d4:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
801077db:	83 e0 e0             	and    $0xffffffe0,%eax
801077de:	a2 e4 60 11 80       	mov    %al,0x801160e4
801077e3:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
801077ea:	83 e0 1f             	and    $0x1f,%eax
801077ed:	a2 e4 60 11 80       	mov    %al,0x801160e4
801077f2:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
801077f9:	83 c8 0f             	or     $0xf,%eax
801077fc:	a2 e5 60 11 80       	mov    %al,0x801160e5
80107801:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107808:	83 e0 ef             	and    $0xffffffef,%eax
8010780b:	a2 e5 60 11 80       	mov    %al,0x801160e5
80107810:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107817:	83 c8 60             	or     $0x60,%eax
8010781a:	a2 e5 60 11 80       	mov    %al,0x801160e5
8010781f:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
80107826:	83 c8 80             	or     $0xffffff80,%eax
80107829:	a2 e5 60 11 80       	mov    %al,0x801160e5
8010782e:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80107833:	c1 e8 10             	shr    $0x10,%eax
80107836:	66 a3 e6 60 11 80    	mov    %ax,0x801160e6
  
}
8010783c:	90                   	nop
8010783d:	c9                   	leave  
8010783e:	c3                   	ret    

8010783f <idtinit>:

void
idtinit(void)
{
8010783f:	55                   	push   %ebp
80107840:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107842:	68 00 08 00 00       	push   $0x800
80107847:	68 e0 5e 11 80       	push   $0x80115ee0
8010784c:	e8 52 fe ff ff       	call   801076a3 <lidt>
80107851:	83 c4 08             	add    $0x8,%esp
}
80107854:	90                   	nop
80107855:	c9                   	leave  
80107856:	c3                   	ret    

80107857 <trap>:

void
trap(struct trapframe *tf)
{
80107857:	55                   	push   %ebp
80107858:	89 e5                	mov    %esp,%ebp
8010785a:	57                   	push   %edi
8010785b:	56                   	push   %esi
8010785c:	53                   	push   %ebx
8010785d:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107860:	8b 45 08             	mov    0x8(%ebp),%eax
80107863:	8b 40 30             	mov    0x30(%eax),%eax
80107866:	83 f8 40             	cmp    $0x40,%eax
80107869:	75 3e                	jne    801078a9 <trap+0x52>
    if(proc->killed)
8010786b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107871:	8b 40 24             	mov    0x24(%eax),%eax
80107874:	85 c0                	test   %eax,%eax
80107876:	74 05                	je     8010787d <trap+0x26>
      exit();
80107878:	e8 90 d3 ff ff       	call   80104c0d <exit>
    proc->tf = tf;
8010787d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107883:	8b 55 08             	mov    0x8(%ebp),%edx
80107886:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107889:	e8 a1 ec ff ff       	call   8010652f <syscall>
    if(proc->killed)
8010788e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107894:	8b 40 24             	mov    0x24(%eax),%eax
80107897:	85 c0                	test   %eax,%eax
80107899:	0f 84 fe 01 00 00    	je     80107a9d <trap+0x246>
      exit();
8010789f:	e8 69 d3 ff ff       	call   80104c0d <exit>
    return;
801078a4:	e9 f4 01 00 00       	jmp    80107a9d <trap+0x246>
  }

  switch(tf->trapno){
801078a9:	8b 45 08             	mov    0x8(%ebp),%eax
801078ac:	8b 40 30             	mov    0x30(%eax),%eax
801078af:	83 e8 20             	sub    $0x20,%eax
801078b2:	83 f8 1f             	cmp    $0x1f,%eax
801078b5:	0f 87 a3 00 00 00    	ja     8010795e <trap+0x107>
801078bb:	8b 04 85 94 9c 10 80 	mov    -0x7fef636c(,%eax,4),%eax
801078c2:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
801078c4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801078ca:	0f b6 00             	movzbl (%eax),%eax
801078cd:	84 c0                	test   %al,%al
801078cf:	75 20                	jne    801078f1 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
801078d1:	83 ec 0c             	sub    $0xc,%esp
801078d4:	68 e0 66 11 80       	push   $0x801166e0
801078d9:	e8 b9 fd ff ff       	call   80107697 <atom_inc>
801078de:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
801078e1:	83 ec 0c             	sub    $0xc,%esp
801078e4:	68 e0 66 11 80       	push   $0x801166e0
801078e9:	e8 81 da ff ff       	call   8010536f <wakeup>
801078ee:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801078f1:	e8 d9 b7 ff ff       	call   801030cf <lapiceoi>
    break;
801078f6:	e9 1c 01 00 00       	jmp    80107a17 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801078fb:	e8 e2 af ff ff       	call   801028e2 <ideintr>
    lapiceoi();
80107900:	e8 ca b7 ff ff       	call   801030cf <lapiceoi>
    break;
80107905:	e9 0d 01 00 00       	jmp    80107a17 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010790a:	e8 c2 b5 ff ff       	call   80102ed1 <kbdintr>
    lapiceoi();
8010790f:	e8 bb b7 ff ff       	call   801030cf <lapiceoi>
    break;
80107914:	e9 fe 00 00 00       	jmp    80107a17 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107919:	e8 60 03 00 00       	call   80107c7e <uartintr>
    lapiceoi();
8010791e:	e8 ac b7 ff ff       	call   801030cf <lapiceoi>
    break;
80107923:	e9 ef 00 00 00       	jmp    80107a17 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107928:	8b 45 08             	mov    0x8(%ebp),%eax
8010792b:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010792e:	8b 45 08             	mov    0x8(%ebp),%eax
80107931:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107935:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107938:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010793e:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107941:	0f b6 c0             	movzbl %al,%eax
80107944:	51                   	push   %ecx
80107945:	52                   	push   %edx
80107946:	50                   	push   %eax
80107947:	68 f4 9b 10 80       	push   $0x80109bf4
8010794c:	e8 75 8a ff ff       	call   801003c6 <cprintf>
80107951:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107954:	e8 76 b7 ff ff       	call   801030cf <lapiceoi>
    break;
80107959:	e9 b9 00 00 00       	jmp    80107a17 <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010795e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107964:	85 c0                	test   %eax,%eax
80107966:	74 11                	je     80107979 <trap+0x122>
80107968:	8b 45 08             	mov    0x8(%ebp),%eax
8010796b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010796f:	0f b7 c0             	movzwl %ax,%eax
80107972:	83 e0 03             	and    $0x3,%eax
80107975:	85 c0                	test   %eax,%eax
80107977:	75 40                	jne    801079b9 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107979:	e8 4f fd ff ff       	call   801076cd <rcr2>
8010797e:	89 c3                	mov    %eax,%ebx
80107980:	8b 45 08             	mov    0x8(%ebp),%eax
80107983:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107986:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010798c:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010798f:	0f b6 d0             	movzbl %al,%edx
80107992:	8b 45 08             	mov    0x8(%ebp),%eax
80107995:	8b 40 30             	mov    0x30(%eax),%eax
80107998:	83 ec 0c             	sub    $0xc,%esp
8010799b:	53                   	push   %ebx
8010799c:	51                   	push   %ecx
8010799d:	52                   	push   %edx
8010799e:	50                   	push   %eax
8010799f:	68 18 9c 10 80       	push   $0x80109c18
801079a4:	e8 1d 8a ff ff       	call   801003c6 <cprintf>
801079a9:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801079ac:	83 ec 0c             	sub    $0xc,%esp
801079af:	68 4a 9c 10 80       	push   $0x80109c4a
801079b4:	e8 ad 8b ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801079b9:	e8 0f fd ff ff       	call   801076cd <rcr2>
801079be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079c1:	8b 45 08             	mov    0x8(%ebp),%eax
801079c4:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801079c7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801079cd:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801079d0:	0f b6 d8             	movzbl %al,%ebx
801079d3:	8b 45 08             	mov    0x8(%ebp),%eax
801079d6:	8b 48 34             	mov    0x34(%eax),%ecx
801079d9:	8b 45 08             	mov    0x8(%ebp),%eax
801079dc:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801079df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801079e5:	8d 78 6c             	lea    0x6c(%eax),%edi
801079e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801079ee:	8b 40 10             	mov    0x10(%eax),%eax
801079f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801079f4:	56                   	push   %esi
801079f5:	53                   	push   %ebx
801079f6:	51                   	push   %ecx
801079f7:	52                   	push   %edx
801079f8:	57                   	push   %edi
801079f9:	50                   	push   %eax
801079fa:	68 50 9c 10 80       	push   $0x80109c50
801079ff:	e8 c2 89 ff ff       	call   801003c6 <cprintf>
80107a04:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107a07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a0d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107a14:	eb 01                	jmp    80107a17 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107a16:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107a17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a1d:	85 c0                	test   %eax,%eax
80107a1f:	74 24                	je     80107a45 <trap+0x1ee>
80107a21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a27:	8b 40 24             	mov    0x24(%eax),%eax
80107a2a:	85 c0                	test   %eax,%eax
80107a2c:	74 17                	je     80107a45 <trap+0x1ee>
80107a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80107a31:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107a35:	0f b7 c0             	movzwl %ax,%eax
80107a38:	83 e0 03             	and    $0x3,%eax
80107a3b:	83 f8 03             	cmp    $0x3,%eax
80107a3e:	75 05                	jne    80107a45 <trap+0x1ee>
    exit();
80107a40:	e8 c8 d1 ff ff       	call   80104c0d <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107a45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a4b:	85 c0                	test   %eax,%eax
80107a4d:	74 1e                	je     80107a6d <trap+0x216>
80107a4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a55:	8b 40 0c             	mov    0xc(%eax),%eax
80107a58:	83 f8 04             	cmp    $0x4,%eax
80107a5b:	75 10                	jne    80107a6d <trap+0x216>
80107a5d:	8b 45 08             	mov    0x8(%ebp),%eax
80107a60:	8b 40 30             	mov    0x30(%eax),%eax
80107a63:	83 f8 20             	cmp    $0x20,%eax
80107a66:	75 05                	jne    80107a6d <trap+0x216>
    yield();
80107a68:	e8 ec d6 ff ff       	call   80105159 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a73:	85 c0                	test   %eax,%eax
80107a75:	74 27                	je     80107a9e <trap+0x247>
80107a77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a7d:	8b 40 24             	mov    0x24(%eax),%eax
80107a80:	85 c0                	test   %eax,%eax
80107a82:	74 1a                	je     80107a9e <trap+0x247>
80107a84:	8b 45 08             	mov    0x8(%ebp),%eax
80107a87:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107a8b:	0f b7 c0             	movzwl %ax,%eax
80107a8e:	83 e0 03             	and    $0x3,%eax
80107a91:	83 f8 03             	cmp    $0x3,%eax
80107a94:	75 08                	jne    80107a9e <trap+0x247>
    exit();
80107a96:	e8 72 d1 ff ff       	call   80104c0d <exit>
80107a9b:	eb 01                	jmp    80107a9e <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107a9d:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107aa1:	5b                   	pop    %ebx
80107aa2:	5e                   	pop    %esi
80107aa3:	5f                   	pop    %edi
80107aa4:	5d                   	pop    %ebp
80107aa5:	c3                   	ret    

80107aa6 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80107aa6:	55                   	push   %ebp
80107aa7:	89 e5                	mov    %esp,%ebp
80107aa9:	83 ec 14             	sub    $0x14,%esp
80107aac:	8b 45 08             	mov    0x8(%ebp),%eax
80107aaf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107ab3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107ab7:	89 c2                	mov    %eax,%edx
80107ab9:	ec                   	in     (%dx),%al
80107aba:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107abd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107ac1:	c9                   	leave  
80107ac2:	c3                   	ret    

80107ac3 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107ac3:	55                   	push   %ebp
80107ac4:	89 e5                	mov    %esp,%ebp
80107ac6:	83 ec 08             	sub    $0x8,%esp
80107ac9:	8b 55 08             	mov    0x8(%ebp),%edx
80107acc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107acf:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107ad3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107ad6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107ada:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107ade:	ee                   	out    %al,(%dx)
}
80107adf:	90                   	nop
80107ae0:	c9                   	leave  
80107ae1:	c3                   	ret    

80107ae2 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107ae2:	55                   	push   %ebp
80107ae3:	89 e5                	mov    %esp,%ebp
80107ae5:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107ae8:	6a 00                	push   $0x0
80107aea:	68 fa 03 00 00       	push   $0x3fa
80107aef:	e8 cf ff ff ff       	call   80107ac3 <outb>
80107af4:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107af7:	68 80 00 00 00       	push   $0x80
80107afc:	68 fb 03 00 00       	push   $0x3fb
80107b01:	e8 bd ff ff ff       	call   80107ac3 <outb>
80107b06:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107b09:	6a 0c                	push   $0xc
80107b0b:	68 f8 03 00 00       	push   $0x3f8
80107b10:	e8 ae ff ff ff       	call   80107ac3 <outb>
80107b15:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107b18:	6a 00                	push   $0x0
80107b1a:	68 f9 03 00 00       	push   $0x3f9
80107b1f:	e8 9f ff ff ff       	call   80107ac3 <outb>
80107b24:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107b27:	6a 03                	push   $0x3
80107b29:	68 fb 03 00 00       	push   $0x3fb
80107b2e:	e8 90 ff ff ff       	call   80107ac3 <outb>
80107b33:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107b36:	6a 00                	push   $0x0
80107b38:	68 fc 03 00 00       	push   $0x3fc
80107b3d:	e8 81 ff ff ff       	call   80107ac3 <outb>
80107b42:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107b45:	6a 01                	push   $0x1
80107b47:	68 f9 03 00 00       	push   $0x3f9
80107b4c:	e8 72 ff ff ff       	call   80107ac3 <outb>
80107b51:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107b54:	68 fd 03 00 00       	push   $0x3fd
80107b59:	e8 48 ff ff ff       	call   80107aa6 <inb>
80107b5e:	83 c4 04             	add    $0x4,%esp
80107b61:	3c ff                	cmp    $0xff,%al
80107b63:	74 6e                	je     80107bd3 <uartinit+0xf1>
    return;
  uart = 1;
80107b65:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107b6c:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107b6f:	68 fa 03 00 00       	push   $0x3fa
80107b74:	e8 2d ff ff ff       	call   80107aa6 <inb>
80107b79:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107b7c:	68 f8 03 00 00       	push   $0x3f8
80107b81:	e8 20 ff ff ff       	call   80107aa6 <inb>
80107b86:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107b89:	83 ec 0c             	sub    $0xc,%esp
80107b8c:	6a 04                	push   $0x4
80107b8e:	e8 42 c4 ff ff       	call   80103fd5 <picenable>
80107b93:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107b96:	83 ec 08             	sub    $0x8,%esp
80107b99:	6a 00                	push   $0x0
80107b9b:	6a 04                	push   $0x4
80107b9d:	e8 e2 af ff ff       	call   80102b84 <ioapicenable>
80107ba2:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107ba5:	c7 45 f4 14 9d 10 80 	movl   $0x80109d14,-0xc(%ebp)
80107bac:	eb 19                	jmp    80107bc7 <uartinit+0xe5>
    uartputc(*p);
80107bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb1:	0f b6 00             	movzbl (%eax),%eax
80107bb4:	0f be c0             	movsbl %al,%eax
80107bb7:	83 ec 0c             	sub    $0xc,%esp
80107bba:	50                   	push   %eax
80107bbb:	e8 16 00 00 00       	call   80107bd6 <uartputc>
80107bc0:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107bc3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bca:	0f b6 00             	movzbl (%eax),%eax
80107bcd:	84 c0                	test   %al,%al
80107bcf:	75 dd                	jne    80107bae <uartinit+0xcc>
80107bd1:	eb 01                	jmp    80107bd4 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107bd3:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107bd4:	c9                   	leave  
80107bd5:	c3                   	ret    

80107bd6 <uartputc>:

void
uartputc(int c)
{
80107bd6:	55                   	push   %ebp
80107bd7:	89 e5                	mov    %esp,%ebp
80107bd9:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107bdc:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107be1:	85 c0                	test   %eax,%eax
80107be3:	74 53                	je     80107c38 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107be5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107bec:	eb 11                	jmp    80107bff <uartputc+0x29>
    microdelay(10);
80107bee:	83 ec 0c             	sub    $0xc,%esp
80107bf1:	6a 0a                	push   $0xa
80107bf3:	e8 f2 b4 ff ff       	call   801030ea <microdelay>
80107bf8:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107bfb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107bff:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107c03:	7f 1a                	jg     80107c1f <uartputc+0x49>
80107c05:	83 ec 0c             	sub    $0xc,%esp
80107c08:	68 fd 03 00 00       	push   $0x3fd
80107c0d:	e8 94 fe ff ff       	call   80107aa6 <inb>
80107c12:	83 c4 10             	add    $0x10,%esp
80107c15:	0f b6 c0             	movzbl %al,%eax
80107c18:	83 e0 20             	and    $0x20,%eax
80107c1b:	85 c0                	test   %eax,%eax
80107c1d:	74 cf                	je     80107bee <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80107c22:	0f b6 c0             	movzbl %al,%eax
80107c25:	83 ec 08             	sub    $0x8,%esp
80107c28:	50                   	push   %eax
80107c29:	68 f8 03 00 00       	push   $0x3f8
80107c2e:	e8 90 fe ff ff       	call   80107ac3 <outb>
80107c33:	83 c4 10             	add    $0x10,%esp
80107c36:	eb 01                	jmp    80107c39 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107c38:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107c39:	c9                   	leave  
80107c3a:	c3                   	ret    

80107c3b <uartgetc>:

static int
uartgetc(void)
{
80107c3b:	55                   	push   %ebp
80107c3c:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107c3e:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107c43:	85 c0                	test   %eax,%eax
80107c45:	75 07                	jne    80107c4e <uartgetc+0x13>
    return -1;
80107c47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c4c:	eb 2e                	jmp    80107c7c <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107c4e:	68 fd 03 00 00       	push   $0x3fd
80107c53:	e8 4e fe ff ff       	call   80107aa6 <inb>
80107c58:	83 c4 04             	add    $0x4,%esp
80107c5b:	0f b6 c0             	movzbl %al,%eax
80107c5e:	83 e0 01             	and    $0x1,%eax
80107c61:	85 c0                	test   %eax,%eax
80107c63:	75 07                	jne    80107c6c <uartgetc+0x31>
    return -1;
80107c65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c6a:	eb 10                	jmp    80107c7c <uartgetc+0x41>
  return inb(COM1+0);
80107c6c:	68 f8 03 00 00       	push   $0x3f8
80107c71:	e8 30 fe ff ff       	call   80107aa6 <inb>
80107c76:	83 c4 04             	add    $0x4,%esp
80107c79:	0f b6 c0             	movzbl %al,%eax
}
80107c7c:	c9                   	leave  
80107c7d:	c3                   	ret    

80107c7e <uartintr>:

void
uartintr(void)
{
80107c7e:	55                   	push   %ebp
80107c7f:	89 e5                	mov    %esp,%ebp
80107c81:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107c84:	83 ec 0c             	sub    $0xc,%esp
80107c87:	68 3b 7c 10 80       	push   $0x80107c3b
80107c8c:	e8 68 8b ff ff       	call   801007f9 <consoleintr>
80107c91:	83 c4 10             	add    $0x10,%esp
}
80107c94:	90                   	nop
80107c95:	c9                   	leave  
80107c96:	c3                   	ret    

80107c97 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107c97:	6a 00                	push   $0x0
  pushl $0
80107c99:	6a 00                	push   $0x0
  jmp alltraps
80107c9b:	e9 cc f9 ff ff       	jmp    8010766c <alltraps>

80107ca0 <vector1>:
.globl vector1
vector1:
  pushl $0
80107ca0:	6a 00                	push   $0x0
  pushl $1
80107ca2:	6a 01                	push   $0x1
  jmp alltraps
80107ca4:	e9 c3 f9 ff ff       	jmp    8010766c <alltraps>

80107ca9 <vector2>:
.globl vector2
vector2:
  pushl $0
80107ca9:	6a 00                	push   $0x0
  pushl $2
80107cab:	6a 02                	push   $0x2
  jmp alltraps
80107cad:	e9 ba f9 ff ff       	jmp    8010766c <alltraps>

80107cb2 <vector3>:
.globl vector3
vector3:
  pushl $0
80107cb2:	6a 00                	push   $0x0
  pushl $3
80107cb4:	6a 03                	push   $0x3
  jmp alltraps
80107cb6:	e9 b1 f9 ff ff       	jmp    8010766c <alltraps>

80107cbb <vector4>:
.globl vector4
vector4:
  pushl $0
80107cbb:	6a 00                	push   $0x0
  pushl $4
80107cbd:	6a 04                	push   $0x4
  jmp alltraps
80107cbf:	e9 a8 f9 ff ff       	jmp    8010766c <alltraps>

80107cc4 <vector5>:
.globl vector5
vector5:
  pushl $0
80107cc4:	6a 00                	push   $0x0
  pushl $5
80107cc6:	6a 05                	push   $0x5
  jmp alltraps
80107cc8:	e9 9f f9 ff ff       	jmp    8010766c <alltraps>

80107ccd <vector6>:
.globl vector6
vector6:
  pushl $0
80107ccd:	6a 00                	push   $0x0
  pushl $6
80107ccf:	6a 06                	push   $0x6
  jmp alltraps
80107cd1:	e9 96 f9 ff ff       	jmp    8010766c <alltraps>

80107cd6 <vector7>:
.globl vector7
vector7:
  pushl $0
80107cd6:	6a 00                	push   $0x0
  pushl $7
80107cd8:	6a 07                	push   $0x7
  jmp alltraps
80107cda:	e9 8d f9 ff ff       	jmp    8010766c <alltraps>

80107cdf <vector8>:
.globl vector8
vector8:
  pushl $8
80107cdf:	6a 08                	push   $0x8
  jmp alltraps
80107ce1:	e9 86 f9 ff ff       	jmp    8010766c <alltraps>

80107ce6 <vector9>:
.globl vector9
vector9:
  pushl $0
80107ce6:	6a 00                	push   $0x0
  pushl $9
80107ce8:	6a 09                	push   $0x9
  jmp alltraps
80107cea:	e9 7d f9 ff ff       	jmp    8010766c <alltraps>

80107cef <vector10>:
.globl vector10
vector10:
  pushl $10
80107cef:	6a 0a                	push   $0xa
  jmp alltraps
80107cf1:	e9 76 f9 ff ff       	jmp    8010766c <alltraps>

80107cf6 <vector11>:
.globl vector11
vector11:
  pushl $11
80107cf6:	6a 0b                	push   $0xb
  jmp alltraps
80107cf8:	e9 6f f9 ff ff       	jmp    8010766c <alltraps>

80107cfd <vector12>:
.globl vector12
vector12:
  pushl $12
80107cfd:	6a 0c                	push   $0xc
  jmp alltraps
80107cff:	e9 68 f9 ff ff       	jmp    8010766c <alltraps>

80107d04 <vector13>:
.globl vector13
vector13:
  pushl $13
80107d04:	6a 0d                	push   $0xd
  jmp alltraps
80107d06:	e9 61 f9 ff ff       	jmp    8010766c <alltraps>

80107d0b <vector14>:
.globl vector14
vector14:
  pushl $14
80107d0b:	6a 0e                	push   $0xe
  jmp alltraps
80107d0d:	e9 5a f9 ff ff       	jmp    8010766c <alltraps>

80107d12 <vector15>:
.globl vector15
vector15:
  pushl $0
80107d12:	6a 00                	push   $0x0
  pushl $15
80107d14:	6a 0f                	push   $0xf
  jmp alltraps
80107d16:	e9 51 f9 ff ff       	jmp    8010766c <alltraps>

80107d1b <vector16>:
.globl vector16
vector16:
  pushl $0
80107d1b:	6a 00                	push   $0x0
  pushl $16
80107d1d:	6a 10                	push   $0x10
  jmp alltraps
80107d1f:	e9 48 f9 ff ff       	jmp    8010766c <alltraps>

80107d24 <vector17>:
.globl vector17
vector17:
  pushl $17
80107d24:	6a 11                	push   $0x11
  jmp alltraps
80107d26:	e9 41 f9 ff ff       	jmp    8010766c <alltraps>

80107d2b <vector18>:
.globl vector18
vector18:
  pushl $0
80107d2b:	6a 00                	push   $0x0
  pushl $18
80107d2d:	6a 12                	push   $0x12
  jmp alltraps
80107d2f:	e9 38 f9 ff ff       	jmp    8010766c <alltraps>

80107d34 <vector19>:
.globl vector19
vector19:
  pushl $0
80107d34:	6a 00                	push   $0x0
  pushl $19
80107d36:	6a 13                	push   $0x13
  jmp alltraps
80107d38:	e9 2f f9 ff ff       	jmp    8010766c <alltraps>

80107d3d <vector20>:
.globl vector20
vector20:
  pushl $0
80107d3d:	6a 00                	push   $0x0
  pushl $20
80107d3f:	6a 14                	push   $0x14
  jmp alltraps
80107d41:	e9 26 f9 ff ff       	jmp    8010766c <alltraps>

80107d46 <vector21>:
.globl vector21
vector21:
  pushl $0
80107d46:	6a 00                	push   $0x0
  pushl $21
80107d48:	6a 15                	push   $0x15
  jmp alltraps
80107d4a:	e9 1d f9 ff ff       	jmp    8010766c <alltraps>

80107d4f <vector22>:
.globl vector22
vector22:
  pushl $0
80107d4f:	6a 00                	push   $0x0
  pushl $22
80107d51:	6a 16                	push   $0x16
  jmp alltraps
80107d53:	e9 14 f9 ff ff       	jmp    8010766c <alltraps>

80107d58 <vector23>:
.globl vector23
vector23:
  pushl $0
80107d58:	6a 00                	push   $0x0
  pushl $23
80107d5a:	6a 17                	push   $0x17
  jmp alltraps
80107d5c:	e9 0b f9 ff ff       	jmp    8010766c <alltraps>

80107d61 <vector24>:
.globl vector24
vector24:
  pushl $0
80107d61:	6a 00                	push   $0x0
  pushl $24
80107d63:	6a 18                	push   $0x18
  jmp alltraps
80107d65:	e9 02 f9 ff ff       	jmp    8010766c <alltraps>

80107d6a <vector25>:
.globl vector25
vector25:
  pushl $0
80107d6a:	6a 00                	push   $0x0
  pushl $25
80107d6c:	6a 19                	push   $0x19
  jmp alltraps
80107d6e:	e9 f9 f8 ff ff       	jmp    8010766c <alltraps>

80107d73 <vector26>:
.globl vector26
vector26:
  pushl $0
80107d73:	6a 00                	push   $0x0
  pushl $26
80107d75:	6a 1a                	push   $0x1a
  jmp alltraps
80107d77:	e9 f0 f8 ff ff       	jmp    8010766c <alltraps>

80107d7c <vector27>:
.globl vector27
vector27:
  pushl $0
80107d7c:	6a 00                	push   $0x0
  pushl $27
80107d7e:	6a 1b                	push   $0x1b
  jmp alltraps
80107d80:	e9 e7 f8 ff ff       	jmp    8010766c <alltraps>

80107d85 <vector28>:
.globl vector28
vector28:
  pushl $0
80107d85:	6a 00                	push   $0x0
  pushl $28
80107d87:	6a 1c                	push   $0x1c
  jmp alltraps
80107d89:	e9 de f8 ff ff       	jmp    8010766c <alltraps>

80107d8e <vector29>:
.globl vector29
vector29:
  pushl $0
80107d8e:	6a 00                	push   $0x0
  pushl $29
80107d90:	6a 1d                	push   $0x1d
  jmp alltraps
80107d92:	e9 d5 f8 ff ff       	jmp    8010766c <alltraps>

80107d97 <vector30>:
.globl vector30
vector30:
  pushl $0
80107d97:	6a 00                	push   $0x0
  pushl $30
80107d99:	6a 1e                	push   $0x1e
  jmp alltraps
80107d9b:	e9 cc f8 ff ff       	jmp    8010766c <alltraps>

80107da0 <vector31>:
.globl vector31
vector31:
  pushl $0
80107da0:	6a 00                	push   $0x0
  pushl $31
80107da2:	6a 1f                	push   $0x1f
  jmp alltraps
80107da4:	e9 c3 f8 ff ff       	jmp    8010766c <alltraps>

80107da9 <vector32>:
.globl vector32
vector32:
  pushl $0
80107da9:	6a 00                	push   $0x0
  pushl $32
80107dab:	6a 20                	push   $0x20
  jmp alltraps
80107dad:	e9 ba f8 ff ff       	jmp    8010766c <alltraps>

80107db2 <vector33>:
.globl vector33
vector33:
  pushl $0
80107db2:	6a 00                	push   $0x0
  pushl $33
80107db4:	6a 21                	push   $0x21
  jmp alltraps
80107db6:	e9 b1 f8 ff ff       	jmp    8010766c <alltraps>

80107dbb <vector34>:
.globl vector34
vector34:
  pushl $0
80107dbb:	6a 00                	push   $0x0
  pushl $34
80107dbd:	6a 22                	push   $0x22
  jmp alltraps
80107dbf:	e9 a8 f8 ff ff       	jmp    8010766c <alltraps>

80107dc4 <vector35>:
.globl vector35
vector35:
  pushl $0
80107dc4:	6a 00                	push   $0x0
  pushl $35
80107dc6:	6a 23                	push   $0x23
  jmp alltraps
80107dc8:	e9 9f f8 ff ff       	jmp    8010766c <alltraps>

80107dcd <vector36>:
.globl vector36
vector36:
  pushl $0
80107dcd:	6a 00                	push   $0x0
  pushl $36
80107dcf:	6a 24                	push   $0x24
  jmp alltraps
80107dd1:	e9 96 f8 ff ff       	jmp    8010766c <alltraps>

80107dd6 <vector37>:
.globl vector37
vector37:
  pushl $0
80107dd6:	6a 00                	push   $0x0
  pushl $37
80107dd8:	6a 25                	push   $0x25
  jmp alltraps
80107dda:	e9 8d f8 ff ff       	jmp    8010766c <alltraps>

80107ddf <vector38>:
.globl vector38
vector38:
  pushl $0
80107ddf:	6a 00                	push   $0x0
  pushl $38
80107de1:	6a 26                	push   $0x26
  jmp alltraps
80107de3:	e9 84 f8 ff ff       	jmp    8010766c <alltraps>

80107de8 <vector39>:
.globl vector39
vector39:
  pushl $0
80107de8:	6a 00                	push   $0x0
  pushl $39
80107dea:	6a 27                	push   $0x27
  jmp alltraps
80107dec:	e9 7b f8 ff ff       	jmp    8010766c <alltraps>

80107df1 <vector40>:
.globl vector40
vector40:
  pushl $0
80107df1:	6a 00                	push   $0x0
  pushl $40
80107df3:	6a 28                	push   $0x28
  jmp alltraps
80107df5:	e9 72 f8 ff ff       	jmp    8010766c <alltraps>

80107dfa <vector41>:
.globl vector41
vector41:
  pushl $0
80107dfa:	6a 00                	push   $0x0
  pushl $41
80107dfc:	6a 29                	push   $0x29
  jmp alltraps
80107dfe:	e9 69 f8 ff ff       	jmp    8010766c <alltraps>

80107e03 <vector42>:
.globl vector42
vector42:
  pushl $0
80107e03:	6a 00                	push   $0x0
  pushl $42
80107e05:	6a 2a                	push   $0x2a
  jmp alltraps
80107e07:	e9 60 f8 ff ff       	jmp    8010766c <alltraps>

80107e0c <vector43>:
.globl vector43
vector43:
  pushl $0
80107e0c:	6a 00                	push   $0x0
  pushl $43
80107e0e:	6a 2b                	push   $0x2b
  jmp alltraps
80107e10:	e9 57 f8 ff ff       	jmp    8010766c <alltraps>

80107e15 <vector44>:
.globl vector44
vector44:
  pushl $0
80107e15:	6a 00                	push   $0x0
  pushl $44
80107e17:	6a 2c                	push   $0x2c
  jmp alltraps
80107e19:	e9 4e f8 ff ff       	jmp    8010766c <alltraps>

80107e1e <vector45>:
.globl vector45
vector45:
  pushl $0
80107e1e:	6a 00                	push   $0x0
  pushl $45
80107e20:	6a 2d                	push   $0x2d
  jmp alltraps
80107e22:	e9 45 f8 ff ff       	jmp    8010766c <alltraps>

80107e27 <vector46>:
.globl vector46
vector46:
  pushl $0
80107e27:	6a 00                	push   $0x0
  pushl $46
80107e29:	6a 2e                	push   $0x2e
  jmp alltraps
80107e2b:	e9 3c f8 ff ff       	jmp    8010766c <alltraps>

80107e30 <vector47>:
.globl vector47
vector47:
  pushl $0
80107e30:	6a 00                	push   $0x0
  pushl $47
80107e32:	6a 2f                	push   $0x2f
  jmp alltraps
80107e34:	e9 33 f8 ff ff       	jmp    8010766c <alltraps>

80107e39 <vector48>:
.globl vector48
vector48:
  pushl $0
80107e39:	6a 00                	push   $0x0
  pushl $48
80107e3b:	6a 30                	push   $0x30
  jmp alltraps
80107e3d:	e9 2a f8 ff ff       	jmp    8010766c <alltraps>

80107e42 <vector49>:
.globl vector49
vector49:
  pushl $0
80107e42:	6a 00                	push   $0x0
  pushl $49
80107e44:	6a 31                	push   $0x31
  jmp alltraps
80107e46:	e9 21 f8 ff ff       	jmp    8010766c <alltraps>

80107e4b <vector50>:
.globl vector50
vector50:
  pushl $0
80107e4b:	6a 00                	push   $0x0
  pushl $50
80107e4d:	6a 32                	push   $0x32
  jmp alltraps
80107e4f:	e9 18 f8 ff ff       	jmp    8010766c <alltraps>

80107e54 <vector51>:
.globl vector51
vector51:
  pushl $0
80107e54:	6a 00                	push   $0x0
  pushl $51
80107e56:	6a 33                	push   $0x33
  jmp alltraps
80107e58:	e9 0f f8 ff ff       	jmp    8010766c <alltraps>

80107e5d <vector52>:
.globl vector52
vector52:
  pushl $0
80107e5d:	6a 00                	push   $0x0
  pushl $52
80107e5f:	6a 34                	push   $0x34
  jmp alltraps
80107e61:	e9 06 f8 ff ff       	jmp    8010766c <alltraps>

80107e66 <vector53>:
.globl vector53
vector53:
  pushl $0
80107e66:	6a 00                	push   $0x0
  pushl $53
80107e68:	6a 35                	push   $0x35
  jmp alltraps
80107e6a:	e9 fd f7 ff ff       	jmp    8010766c <alltraps>

80107e6f <vector54>:
.globl vector54
vector54:
  pushl $0
80107e6f:	6a 00                	push   $0x0
  pushl $54
80107e71:	6a 36                	push   $0x36
  jmp alltraps
80107e73:	e9 f4 f7 ff ff       	jmp    8010766c <alltraps>

80107e78 <vector55>:
.globl vector55
vector55:
  pushl $0
80107e78:	6a 00                	push   $0x0
  pushl $55
80107e7a:	6a 37                	push   $0x37
  jmp alltraps
80107e7c:	e9 eb f7 ff ff       	jmp    8010766c <alltraps>

80107e81 <vector56>:
.globl vector56
vector56:
  pushl $0
80107e81:	6a 00                	push   $0x0
  pushl $56
80107e83:	6a 38                	push   $0x38
  jmp alltraps
80107e85:	e9 e2 f7 ff ff       	jmp    8010766c <alltraps>

80107e8a <vector57>:
.globl vector57
vector57:
  pushl $0
80107e8a:	6a 00                	push   $0x0
  pushl $57
80107e8c:	6a 39                	push   $0x39
  jmp alltraps
80107e8e:	e9 d9 f7 ff ff       	jmp    8010766c <alltraps>

80107e93 <vector58>:
.globl vector58
vector58:
  pushl $0
80107e93:	6a 00                	push   $0x0
  pushl $58
80107e95:	6a 3a                	push   $0x3a
  jmp alltraps
80107e97:	e9 d0 f7 ff ff       	jmp    8010766c <alltraps>

80107e9c <vector59>:
.globl vector59
vector59:
  pushl $0
80107e9c:	6a 00                	push   $0x0
  pushl $59
80107e9e:	6a 3b                	push   $0x3b
  jmp alltraps
80107ea0:	e9 c7 f7 ff ff       	jmp    8010766c <alltraps>

80107ea5 <vector60>:
.globl vector60
vector60:
  pushl $0
80107ea5:	6a 00                	push   $0x0
  pushl $60
80107ea7:	6a 3c                	push   $0x3c
  jmp alltraps
80107ea9:	e9 be f7 ff ff       	jmp    8010766c <alltraps>

80107eae <vector61>:
.globl vector61
vector61:
  pushl $0
80107eae:	6a 00                	push   $0x0
  pushl $61
80107eb0:	6a 3d                	push   $0x3d
  jmp alltraps
80107eb2:	e9 b5 f7 ff ff       	jmp    8010766c <alltraps>

80107eb7 <vector62>:
.globl vector62
vector62:
  pushl $0
80107eb7:	6a 00                	push   $0x0
  pushl $62
80107eb9:	6a 3e                	push   $0x3e
  jmp alltraps
80107ebb:	e9 ac f7 ff ff       	jmp    8010766c <alltraps>

80107ec0 <vector63>:
.globl vector63
vector63:
  pushl $0
80107ec0:	6a 00                	push   $0x0
  pushl $63
80107ec2:	6a 3f                	push   $0x3f
  jmp alltraps
80107ec4:	e9 a3 f7 ff ff       	jmp    8010766c <alltraps>

80107ec9 <vector64>:
.globl vector64
vector64:
  pushl $0
80107ec9:	6a 00                	push   $0x0
  pushl $64
80107ecb:	6a 40                	push   $0x40
  jmp alltraps
80107ecd:	e9 9a f7 ff ff       	jmp    8010766c <alltraps>

80107ed2 <vector65>:
.globl vector65
vector65:
  pushl $0
80107ed2:	6a 00                	push   $0x0
  pushl $65
80107ed4:	6a 41                	push   $0x41
  jmp alltraps
80107ed6:	e9 91 f7 ff ff       	jmp    8010766c <alltraps>

80107edb <vector66>:
.globl vector66
vector66:
  pushl $0
80107edb:	6a 00                	push   $0x0
  pushl $66
80107edd:	6a 42                	push   $0x42
  jmp alltraps
80107edf:	e9 88 f7 ff ff       	jmp    8010766c <alltraps>

80107ee4 <vector67>:
.globl vector67
vector67:
  pushl $0
80107ee4:	6a 00                	push   $0x0
  pushl $67
80107ee6:	6a 43                	push   $0x43
  jmp alltraps
80107ee8:	e9 7f f7 ff ff       	jmp    8010766c <alltraps>

80107eed <vector68>:
.globl vector68
vector68:
  pushl $0
80107eed:	6a 00                	push   $0x0
  pushl $68
80107eef:	6a 44                	push   $0x44
  jmp alltraps
80107ef1:	e9 76 f7 ff ff       	jmp    8010766c <alltraps>

80107ef6 <vector69>:
.globl vector69
vector69:
  pushl $0
80107ef6:	6a 00                	push   $0x0
  pushl $69
80107ef8:	6a 45                	push   $0x45
  jmp alltraps
80107efa:	e9 6d f7 ff ff       	jmp    8010766c <alltraps>

80107eff <vector70>:
.globl vector70
vector70:
  pushl $0
80107eff:	6a 00                	push   $0x0
  pushl $70
80107f01:	6a 46                	push   $0x46
  jmp alltraps
80107f03:	e9 64 f7 ff ff       	jmp    8010766c <alltraps>

80107f08 <vector71>:
.globl vector71
vector71:
  pushl $0
80107f08:	6a 00                	push   $0x0
  pushl $71
80107f0a:	6a 47                	push   $0x47
  jmp alltraps
80107f0c:	e9 5b f7 ff ff       	jmp    8010766c <alltraps>

80107f11 <vector72>:
.globl vector72
vector72:
  pushl $0
80107f11:	6a 00                	push   $0x0
  pushl $72
80107f13:	6a 48                	push   $0x48
  jmp alltraps
80107f15:	e9 52 f7 ff ff       	jmp    8010766c <alltraps>

80107f1a <vector73>:
.globl vector73
vector73:
  pushl $0
80107f1a:	6a 00                	push   $0x0
  pushl $73
80107f1c:	6a 49                	push   $0x49
  jmp alltraps
80107f1e:	e9 49 f7 ff ff       	jmp    8010766c <alltraps>

80107f23 <vector74>:
.globl vector74
vector74:
  pushl $0
80107f23:	6a 00                	push   $0x0
  pushl $74
80107f25:	6a 4a                	push   $0x4a
  jmp alltraps
80107f27:	e9 40 f7 ff ff       	jmp    8010766c <alltraps>

80107f2c <vector75>:
.globl vector75
vector75:
  pushl $0
80107f2c:	6a 00                	push   $0x0
  pushl $75
80107f2e:	6a 4b                	push   $0x4b
  jmp alltraps
80107f30:	e9 37 f7 ff ff       	jmp    8010766c <alltraps>

80107f35 <vector76>:
.globl vector76
vector76:
  pushl $0
80107f35:	6a 00                	push   $0x0
  pushl $76
80107f37:	6a 4c                	push   $0x4c
  jmp alltraps
80107f39:	e9 2e f7 ff ff       	jmp    8010766c <alltraps>

80107f3e <vector77>:
.globl vector77
vector77:
  pushl $0
80107f3e:	6a 00                	push   $0x0
  pushl $77
80107f40:	6a 4d                	push   $0x4d
  jmp alltraps
80107f42:	e9 25 f7 ff ff       	jmp    8010766c <alltraps>

80107f47 <vector78>:
.globl vector78
vector78:
  pushl $0
80107f47:	6a 00                	push   $0x0
  pushl $78
80107f49:	6a 4e                	push   $0x4e
  jmp alltraps
80107f4b:	e9 1c f7 ff ff       	jmp    8010766c <alltraps>

80107f50 <vector79>:
.globl vector79
vector79:
  pushl $0
80107f50:	6a 00                	push   $0x0
  pushl $79
80107f52:	6a 4f                	push   $0x4f
  jmp alltraps
80107f54:	e9 13 f7 ff ff       	jmp    8010766c <alltraps>

80107f59 <vector80>:
.globl vector80
vector80:
  pushl $0
80107f59:	6a 00                	push   $0x0
  pushl $80
80107f5b:	6a 50                	push   $0x50
  jmp alltraps
80107f5d:	e9 0a f7 ff ff       	jmp    8010766c <alltraps>

80107f62 <vector81>:
.globl vector81
vector81:
  pushl $0
80107f62:	6a 00                	push   $0x0
  pushl $81
80107f64:	6a 51                	push   $0x51
  jmp alltraps
80107f66:	e9 01 f7 ff ff       	jmp    8010766c <alltraps>

80107f6b <vector82>:
.globl vector82
vector82:
  pushl $0
80107f6b:	6a 00                	push   $0x0
  pushl $82
80107f6d:	6a 52                	push   $0x52
  jmp alltraps
80107f6f:	e9 f8 f6 ff ff       	jmp    8010766c <alltraps>

80107f74 <vector83>:
.globl vector83
vector83:
  pushl $0
80107f74:	6a 00                	push   $0x0
  pushl $83
80107f76:	6a 53                	push   $0x53
  jmp alltraps
80107f78:	e9 ef f6 ff ff       	jmp    8010766c <alltraps>

80107f7d <vector84>:
.globl vector84
vector84:
  pushl $0
80107f7d:	6a 00                	push   $0x0
  pushl $84
80107f7f:	6a 54                	push   $0x54
  jmp alltraps
80107f81:	e9 e6 f6 ff ff       	jmp    8010766c <alltraps>

80107f86 <vector85>:
.globl vector85
vector85:
  pushl $0
80107f86:	6a 00                	push   $0x0
  pushl $85
80107f88:	6a 55                	push   $0x55
  jmp alltraps
80107f8a:	e9 dd f6 ff ff       	jmp    8010766c <alltraps>

80107f8f <vector86>:
.globl vector86
vector86:
  pushl $0
80107f8f:	6a 00                	push   $0x0
  pushl $86
80107f91:	6a 56                	push   $0x56
  jmp alltraps
80107f93:	e9 d4 f6 ff ff       	jmp    8010766c <alltraps>

80107f98 <vector87>:
.globl vector87
vector87:
  pushl $0
80107f98:	6a 00                	push   $0x0
  pushl $87
80107f9a:	6a 57                	push   $0x57
  jmp alltraps
80107f9c:	e9 cb f6 ff ff       	jmp    8010766c <alltraps>

80107fa1 <vector88>:
.globl vector88
vector88:
  pushl $0
80107fa1:	6a 00                	push   $0x0
  pushl $88
80107fa3:	6a 58                	push   $0x58
  jmp alltraps
80107fa5:	e9 c2 f6 ff ff       	jmp    8010766c <alltraps>

80107faa <vector89>:
.globl vector89
vector89:
  pushl $0
80107faa:	6a 00                	push   $0x0
  pushl $89
80107fac:	6a 59                	push   $0x59
  jmp alltraps
80107fae:	e9 b9 f6 ff ff       	jmp    8010766c <alltraps>

80107fb3 <vector90>:
.globl vector90
vector90:
  pushl $0
80107fb3:	6a 00                	push   $0x0
  pushl $90
80107fb5:	6a 5a                	push   $0x5a
  jmp alltraps
80107fb7:	e9 b0 f6 ff ff       	jmp    8010766c <alltraps>

80107fbc <vector91>:
.globl vector91
vector91:
  pushl $0
80107fbc:	6a 00                	push   $0x0
  pushl $91
80107fbe:	6a 5b                	push   $0x5b
  jmp alltraps
80107fc0:	e9 a7 f6 ff ff       	jmp    8010766c <alltraps>

80107fc5 <vector92>:
.globl vector92
vector92:
  pushl $0
80107fc5:	6a 00                	push   $0x0
  pushl $92
80107fc7:	6a 5c                	push   $0x5c
  jmp alltraps
80107fc9:	e9 9e f6 ff ff       	jmp    8010766c <alltraps>

80107fce <vector93>:
.globl vector93
vector93:
  pushl $0
80107fce:	6a 00                	push   $0x0
  pushl $93
80107fd0:	6a 5d                	push   $0x5d
  jmp alltraps
80107fd2:	e9 95 f6 ff ff       	jmp    8010766c <alltraps>

80107fd7 <vector94>:
.globl vector94
vector94:
  pushl $0
80107fd7:	6a 00                	push   $0x0
  pushl $94
80107fd9:	6a 5e                	push   $0x5e
  jmp alltraps
80107fdb:	e9 8c f6 ff ff       	jmp    8010766c <alltraps>

80107fe0 <vector95>:
.globl vector95
vector95:
  pushl $0
80107fe0:	6a 00                	push   $0x0
  pushl $95
80107fe2:	6a 5f                	push   $0x5f
  jmp alltraps
80107fe4:	e9 83 f6 ff ff       	jmp    8010766c <alltraps>

80107fe9 <vector96>:
.globl vector96
vector96:
  pushl $0
80107fe9:	6a 00                	push   $0x0
  pushl $96
80107feb:	6a 60                	push   $0x60
  jmp alltraps
80107fed:	e9 7a f6 ff ff       	jmp    8010766c <alltraps>

80107ff2 <vector97>:
.globl vector97
vector97:
  pushl $0
80107ff2:	6a 00                	push   $0x0
  pushl $97
80107ff4:	6a 61                	push   $0x61
  jmp alltraps
80107ff6:	e9 71 f6 ff ff       	jmp    8010766c <alltraps>

80107ffb <vector98>:
.globl vector98
vector98:
  pushl $0
80107ffb:	6a 00                	push   $0x0
  pushl $98
80107ffd:	6a 62                	push   $0x62
  jmp alltraps
80107fff:	e9 68 f6 ff ff       	jmp    8010766c <alltraps>

80108004 <vector99>:
.globl vector99
vector99:
  pushl $0
80108004:	6a 00                	push   $0x0
  pushl $99
80108006:	6a 63                	push   $0x63
  jmp alltraps
80108008:	e9 5f f6 ff ff       	jmp    8010766c <alltraps>

8010800d <vector100>:
.globl vector100
vector100:
  pushl $0
8010800d:	6a 00                	push   $0x0
  pushl $100
8010800f:	6a 64                	push   $0x64
  jmp alltraps
80108011:	e9 56 f6 ff ff       	jmp    8010766c <alltraps>

80108016 <vector101>:
.globl vector101
vector101:
  pushl $0
80108016:	6a 00                	push   $0x0
  pushl $101
80108018:	6a 65                	push   $0x65
  jmp alltraps
8010801a:	e9 4d f6 ff ff       	jmp    8010766c <alltraps>

8010801f <vector102>:
.globl vector102
vector102:
  pushl $0
8010801f:	6a 00                	push   $0x0
  pushl $102
80108021:	6a 66                	push   $0x66
  jmp alltraps
80108023:	e9 44 f6 ff ff       	jmp    8010766c <alltraps>

80108028 <vector103>:
.globl vector103
vector103:
  pushl $0
80108028:	6a 00                	push   $0x0
  pushl $103
8010802a:	6a 67                	push   $0x67
  jmp alltraps
8010802c:	e9 3b f6 ff ff       	jmp    8010766c <alltraps>

80108031 <vector104>:
.globl vector104
vector104:
  pushl $0
80108031:	6a 00                	push   $0x0
  pushl $104
80108033:	6a 68                	push   $0x68
  jmp alltraps
80108035:	e9 32 f6 ff ff       	jmp    8010766c <alltraps>

8010803a <vector105>:
.globl vector105
vector105:
  pushl $0
8010803a:	6a 00                	push   $0x0
  pushl $105
8010803c:	6a 69                	push   $0x69
  jmp alltraps
8010803e:	e9 29 f6 ff ff       	jmp    8010766c <alltraps>

80108043 <vector106>:
.globl vector106
vector106:
  pushl $0
80108043:	6a 00                	push   $0x0
  pushl $106
80108045:	6a 6a                	push   $0x6a
  jmp alltraps
80108047:	e9 20 f6 ff ff       	jmp    8010766c <alltraps>

8010804c <vector107>:
.globl vector107
vector107:
  pushl $0
8010804c:	6a 00                	push   $0x0
  pushl $107
8010804e:	6a 6b                	push   $0x6b
  jmp alltraps
80108050:	e9 17 f6 ff ff       	jmp    8010766c <alltraps>

80108055 <vector108>:
.globl vector108
vector108:
  pushl $0
80108055:	6a 00                	push   $0x0
  pushl $108
80108057:	6a 6c                	push   $0x6c
  jmp alltraps
80108059:	e9 0e f6 ff ff       	jmp    8010766c <alltraps>

8010805e <vector109>:
.globl vector109
vector109:
  pushl $0
8010805e:	6a 00                	push   $0x0
  pushl $109
80108060:	6a 6d                	push   $0x6d
  jmp alltraps
80108062:	e9 05 f6 ff ff       	jmp    8010766c <alltraps>

80108067 <vector110>:
.globl vector110
vector110:
  pushl $0
80108067:	6a 00                	push   $0x0
  pushl $110
80108069:	6a 6e                	push   $0x6e
  jmp alltraps
8010806b:	e9 fc f5 ff ff       	jmp    8010766c <alltraps>

80108070 <vector111>:
.globl vector111
vector111:
  pushl $0
80108070:	6a 00                	push   $0x0
  pushl $111
80108072:	6a 6f                	push   $0x6f
  jmp alltraps
80108074:	e9 f3 f5 ff ff       	jmp    8010766c <alltraps>

80108079 <vector112>:
.globl vector112
vector112:
  pushl $0
80108079:	6a 00                	push   $0x0
  pushl $112
8010807b:	6a 70                	push   $0x70
  jmp alltraps
8010807d:	e9 ea f5 ff ff       	jmp    8010766c <alltraps>

80108082 <vector113>:
.globl vector113
vector113:
  pushl $0
80108082:	6a 00                	push   $0x0
  pushl $113
80108084:	6a 71                	push   $0x71
  jmp alltraps
80108086:	e9 e1 f5 ff ff       	jmp    8010766c <alltraps>

8010808b <vector114>:
.globl vector114
vector114:
  pushl $0
8010808b:	6a 00                	push   $0x0
  pushl $114
8010808d:	6a 72                	push   $0x72
  jmp alltraps
8010808f:	e9 d8 f5 ff ff       	jmp    8010766c <alltraps>

80108094 <vector115>:
.globl vector115
vector115:
  pushl $0
80108094:	6a 00                	push   $0x0
  pushl $115
80108096:	6a 73                	push   $0x73
  jmp alltraps
80108098:	e9 cf f5 ff ff       	jmp    8010766c <alltraps>

8010809d <vector116>:
.globl vector116
vector116:
  pushl $0
8010809d:	6a 00                	push   $0x0
  pushl $116
8010809f:	6a 74                	push   $0x74
  jmp alltraps
801080a1:	e9 c6 f5 ff ff       	jmp    8010766c <alltraps>

801080a6 <vector117>:
.globl vector117
vector117:
  pushl $0
801080a6:	6a 00                	push   $0x0
  pushl $117
801080a8:	6a 75                	push   $0x75
  jmp alltraps
801080aa:	e9 bd f5 ff ff       	jmp    8010766c <alltraps>

801080af <vector118>:
.globl vector118
vector118:
  pushl $0
801080af:	6a 00                	push   $0x0
  pushl $118
801080b1:	6a 76                	push   $0x76
  jmp alltraps
801080b3:	e9 b4 f5 ff ff       	jmp    8010766c <alltraps>

801080b8 <vector119>:
.globl vector119
vector119:
  pushl $0
801080b8:	6a 00                	push   $0x0
  pushl $119
801080ba:	6a 77                	push   $0x77
  jmp alltraps
801080bc:	e9 ab f5 ff ff       	jmp    8010766c <alltraps>

801080c1 <vector120>:
.globl vector120
vector120:
  pushl $0
801080c1:	6a 00                	push   $0x0
  pushl $120
801080c3:	6a 78                	push   $0x78
  jmp alltraps
801080c5:	e9 a2 f5 ff ff       	jmp    8010766c <alltraps>

801080ca <vector121>:
.globl vector121
vector121:
  pushl $0
801080ca:	6a 00                	push   $0x0
  pushl $121
801080cc:	6a 79                	push   $0x79
  jmp alltraps
801080ce:	e9 99 f5 ff ff       	jmp    8010766c <alltraps>

801080d3 <vector122>:
.globl vector122
vector122:
  pushl $0
801080d3:	6a 00                	push   $0x0
  pushl $122
801080d5:	6a 7a                	push   $0x7a
  jmp alltraps
801080d7:	e9 90 f5 ff ff       	jmp    8010766c <alltraps>

801080dc <vector123>:
.globl vector123
vector123:
  pushl $0
801080dc:	6a 00                	push   $0x0
  pushl $123
801080de:	6a 7b                	push   $0x7b
  jmp alltraps
801080e0:	e9 87 f5 ff ff       	jmp    8010766c <alltraps>

801080e5 <vector124>:
.globl vector124
vector124:
  pushl $0
801080e5:	6a 00                	push   $0x0
  pushl $124
801080e7:	6a 7c                	push   $0x7c
  jmp alltraps
801080e9:	e9 7e f5 ff ff       	jmp    8010766c <alltraps>

801080ee <vector125>:
.globl vector125
vector125:
  pushl $0
801080ee:	6a 00                	push   $0x0
  pushl $125
801080f0:	6a 7d                	push   $0x7d
  jmp alltraps
801080f2:	e9 75 f5 ff ff       	jmp    8010766c <alltraps>

801080f7 <vector126>:
.globl vector126
vector126:
  pushl $0
801080f7:	6a 00                	push   $0x0
  pushl $126
801080f9:	6a 7e                	push   $0x7e
  jmp alltraps
801080fb:	e9 6c f5 ff ff       	jmp    8010766c <alltraps>

80108100 <vector127>:
.globl vector127
vector127:
  pushl $0
80108100:	6a 00                	push   $0x0
  pushl $127
80108102:	6a 7f                	push   $0x7f
  jmp alltraps
80108104:	e9 63 f5 ff ff       	jmp    8010766c <alltraps>

80108109 <vector128>:
.globl vector128
vector128:
  pushl $0
80108109:	6a 00                	push   $0x0
  pushl $128
8010810b:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108110:	e9 57 f5 ff ff       	jmp    8010766c <alltraps>

80108115 <vector129>:
.globl vector129
vector129:
  pushl $0
80108115:	6a 00                	push   $0x0
  pushl $129
80108117:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010811c:	e9 4b f5 ff ff       	jmp    8010766c <alltraps>

80108121 <vector130>:
.globl vector130
vector130:
  pushl $0
80108121:	6a 00                	push   $0x0
  pushl $130
80108123:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108128:	e9 3f f5 ff ff       	jmp    8010766c <alltraps>

8010812d <vector131>:
.globl vector131
vector131:
  pushl $0
8010812d:	6a 00                	push   $0x0
  pushl $131
8010812f:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108134:	e9 33 f5 ff ff       	jmp    8010766c <alltraps>

80108139 <vector132>:
.globl vector132
vector132:
  pushl $0
80108139:	6a 00                	push   $0x0
  pushl $132
8010813b:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108140:	e9 27 f5 ff ff       	jmp    8010766c <alltraps>

80108145 <vector133>:
.globl vector133
vector133:
  pushl $0
80108145:	6a 00                	push   $0x0
  pushl $133
80108147:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010814c:	e9 1b f5 ff ff       	jmp    8010766c <alltraps>

80108151 <vector134>:
.globl vector134
vector134:
  pushl $0
80108151:	6a 00                	push   $0x0
  pushl $134
80108153:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108158:	e9 0f f5 ff ff       	jmp    8010766c <alltraps>

8010815d <vector135>:
.globl vector135
vector135:
  pushl $0
8010815d:	6a 00                	push   $0x0
  pushl $135
8010815f:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108164:	e9 03 f5 ff ff       	jmp    8010766c <alltraps>

80108169 <vector136>:
.globl vector136
vector136:
  pushl $0
80108169:	6a 00                	push   $0x0
  pushl $136
8010816b:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108170:	e9 f7 f4 ff ff       	jmp    8010766c <alltraps>

80108175 <vector137>:
.globl vector137
vector137:
  pushl $0
80108175:	6a 00                	push   $0x0
  pushl $137
80108177:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010817c:	e9 eb f4 ff ff       	jmp    8010766c <alltraps>

80108181 <vector138>:
.globl vector138
vector138:
  pushl $0
80108181:	6a 00                	push   $0x0
  pushl $138
80108183:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108188:	e9 df f4 ff ff       	jmp    8010766c <alltraps>

8010818d <vector139>:
.globl vector139
vector139:
  pushl $0
8010818d:	6a 00                	push   $0x0
  pushl $139
8010818f:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108194:	e9 d3 f4 ff ff       	jmp    8010766c <alltraps>

80108199 <vector140>:
.globl vector140
vector140:
  pushl $0
80108199:	6a 00                	push   $0x0
  pushl $140
8010819b:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801081a0:	e9 c7 f4 ff ff       	jmp    8010766c <alltraps>

801081a5 <vector141>:
.globl vector141
vector141:
  pushl $0
801081a5:	6a 00                	push   $0x0
  pushl $141
801081a7:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801081ac:	e9 bb f4 ff ff       	jmp    8010766c <alltraps>

801081b1 <vector142>:
.globl vector142
vector142:
  pushl $0
801081b1:	6a 00                	push   $0x0
  pushl $142
801081b3:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801081b8:	e9 af f4 ff ff       	jmp    8010766c <alltraps>

801081bd <vector143>:
.globl vector143
vector143:
  pushl $0
801081bd:	6a 00                	push   $0x0
  pushl $143
801081bf:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801081c4:	e9 a3 f4 ff ff       	jmp    8010766c <alltraps>

801081c9 <vector144>:
.globl vector144
vector144:
  pushl $0
801081c9:	6a 00                	push   $0x0
  pushl $144
801081cb:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801081d0:	e9 97 f4 ff ff       	jmp    8010766c <alltraps>

801081d5 <vector145>:
.globl vector145
vector145:
  pushl $0
801081d5:	6a 00                	push   $0x0
  pushl $145
801081d7:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801081dc:	e9 8b f4 ff ff       	jmp    8010766c <alltraps>

801081e1 <vector146>:
.globl vector146
vector146:
  pushl $0
801081e1:	6a 00                	push   $0x0
  pushl $146
801081e3:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801081e8:	e9 7f f4 ff ff       	jmp    8010766c <alltraps>

801081ed <vector147>:
.globl vector147
vector147:
  pushl $0
801081ed:	6a 00                	push   $0x0
  pushl $147
801081ef:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801081f4:	e9 73 f4 ff ff       	jmp    8010766c <alltraps>

801081f9 <vector148>:
.globl vector148
vector148:
  pushl $0
801081f9:	6a 00                	push   $0x0
  pushl $148
801081fb:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108200:	e9 67 f4 ff ff       	jmp    8010766c <alltraps>

80108205 <vector149>:
.globl vector149
vector149:
  pushl $0
80108205:	6a 00                	push   $0x0
  pushl $149
80108207:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010820c:	e9 5b f4 ff ff       	jmp    8010766c <alltraps>

80108211 <vector150>:
.globl vector150
vector150:
  pushl $0
80108211:	6a 00                	push   $0x0
  pushl $150
80108213:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108218:	e9 4f f4 ff ff       	jmp    8010766c <alltraps>

8010821d <vector151>:
.globl vector151
vector151:
  pushl $0
8010821d:	6a 00                	push   $0x0
  pushl $151
8010821f:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108224:	e9 43 f4 ff ff       	jmp    8010766c <alltraps>

80108229 <vector152>:
.globl vector152
vector152:
  pushl $0
80108229:	6a 00                	push   $0x0
  pushl $152
8010822b:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108230:	e9 37 f4 ff ff       	jmp    8010766c <alltraps>

80108235 <vector153>:
.globl vector153
vector153:
  pushl $0
80108235:	6a 00                	push   $0x0
  pushl $153
80108237:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010823c:	e9 2b f4 ff ff       	jmp    8010766c <alltraps>

80108241 <vector154>:
.globl vector154
vector154:
  pushl $0
80108241:	6a 00                	push   $0x0
  pushl $154
80108243:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108248:	e9 1f f4 ff ff       	jmp    8010766c <alltraps>

8010824d <vector155>:
.globl vector155
vector155:
  pushl $0
8010824d:	6a 00                	push   $0x0
  pushl $155
8010824f:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108254:	e9 13 f4 ff ff       	jmp    8010766c <alltraps>

80108259 <vector156>:
.globl vector156
vector156:
  pushl $0
80108259:	6a 00                	push   $0x0
  pushl $156
8010825b:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108260:	e9 07 f4 ff ff       	jmp    8010766c <alltraps>

80108265 <vector157>:
.globl vector157
vector157:
  pushl $0
80108265:	6a 00                	push   $0x0
  pushl $157
80108267:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010826c:	e9 fb f3 ff ff       	jmp    8010766c <alltraps>

80108271 <vector158>:
.globl vector158
vector158:
  pushl $0
80108271:	6a 00                	push   $0x0
  pushl $158
80108273:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108278:	e9 ef f3 ff ff       	jmp    8010766c <alltraps>

8010827d <vector159>:
.globl vector159
vector159:
  pushl $0
8010827d:	6a 00                	push   $0x0
  pushl $159
8010827f:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108284:	e9 e3 f3 ff ff       	jmp    8010766c <alltraps>

80108289 <vector160>:
.globl vector160
vector160:
  pushl $0
80108289:	6a 00                	push   $0x0
  pushl $160
8010828b:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108290:	e9 d7 f3 ff ff       	jmp    8010766c <alltraps>

80108295 <vector161>:
.globl vector161
vector161:
  pushl $0
80108295:	6a 00                	push   $0x0
  pushl $161
80108297:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010829c:	e9 cb f3 ff ff       	jmp    8010766c <alltraps>

801082a1 <vector162>:
.globl vector162
vector162:
  pushl $0
801082a1:	6a 00                	push   $0x0
  pushl $162
801082a3:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801082a8:	e9 bf f3 ff ff       	jmp    8010766c <alltraps>

801082ad <vector163>:
.globl vector163
vector163:
  pushl $0
801082ad:	6a 00                	push   $0x0
  pushl $163
801082af:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801082b4:	e9 b3 f3 ff ff       	jmp    8010766c <alltraps>

801082b9 <vector164>:
.globl vector164
vector164:
  pushl $0
801082b9:	6a 00                	push   $0x0
  pushl $164
801082bb:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801082c0:	e9 a7 f3 ff ff       	jmp    8010766c <alltraps>

801082c5 <vector165>:
.globl vector165
vector165:
  pushl $0
801082c5:	6a 00                	push   $0x0
  pushl $165
801082c7:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801082cc:	e9 9b f3 ff ff       	jmp    8010766c <alltraps>

801082d1 <vector166>:
.globl vector166
vector166:
  pushl $0
801082d1:	6a 00                	push   $0x0
  pushl $166
801082d3:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801082d8:	e9 8f f3 ff ff       	jmp    8010766c <alltraps>

801082dd <vector167>:
.globl vector167
vector167:
  pushl $0
801082dd:	6a 00                	push   $0x0
  pushl $167
801082df:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801082e4:	e9 83 f3 ff ff       	jmp    8010766c <alltraps>

801082e9 <vector168>:
.globl vector168
vector168:
  pushl $0
801082e9:	6a 00                	push   $0x0
  pushl $168
801082eb:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801082f0:	e9 77 f3 ff ff       	jmp    8010766c <alltraps>

801082f5 <vector169>:
.globl vector169
vector169:
  pushl $0
801082f5:	6a 00                	push   $0x0
  pushl $169
801082f7:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801082fc:	e9 6b f3 ff ff       	jmp    8010766c <alltraps>

80108301 <vector170>:
.globl vector170
vector170:
  pushl $0
80108301:	6a 00                	push   $0x0
  pushl $170
80108303:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108308:	e9 5f f3 ff ff       	jmp    8010766c <alltraps>

8010830d <vector171>:
.globl vector171
vector171:
  pushl $0
8010830d:	6a 00                	push   $0x0
  pushl $171
8010830f:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108314:	e9 53 f3 ff ff       	jmp    8010766c <alltraps>

80108319 <vector172>:
.globl vector172
vector172:
  pushl $0
80108319:	6a 00                	push   $0x0
  pushl $172
8010831b:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108320:	e9 47 f3 ff ff       	jmp    8010766c <alltraps>

80108325 <vector173>:
.globl vector173
vector173:
  pushl $0
80108325:	6a 00                	push   $0x0
  pushl $173
80108327:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010832c:	e9 3b f3 ff ff       	jmp    8010766c <alltraps>

80108331 <vector174>:
.globl vector174
vector174:
  pushl $0
80108331:	6a 00                	push   $0x0
  pushl $174
80108333:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108338:	e9 2f f3 ff ff       	jmp    8010766c <alltraps>

8010833d <vector175>:
.globl vector175
vector175:
  pushl $0
8010833d:	6a 00                	push   $0x0
  pushl $175
8010833f:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108344:	e9 23 f3 ff ff       	jmp    8010766c <alltraps>

80108349 <vector176>:
.globl vector176
vector176:
  pushl $0
80108349:	6a 00                	push   $0x0
  pushl $176
8010834b:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108350:	e9 17 f3 ff ff       	jmp    8010766c <alltraps>

80108355 <vector177>:
.globl vector177
vector177:
  pushl $0
80108355:	6a 00                	push   $0x0
  pushl $177
80108357:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010835c:	e9 0b f3 ff ff       	jmp    8010766c <alltraps>

80108361 <vector178>:
.globl vector178
vector178:
  pushl $0
80108361:	6a 00                	push   $0x0
  pushl $178
80108363:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108368:	e9 ff f2 ff ff       	jmp    8010766c <alltraps>

8010836d <vector179>:
.globl vector179
vector179:
  pushl $0
8010836d:	6a 00                	push   $0x0
  pushl $179
8010836f:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108374:	e9 f3 f2 ff ff       	jmp    8010766c <alltraps>

80108379 <vector180>:
.globl vector180
vector180:
  pushl $0
80108379:	6a 00                	push   $0x0
  pushl $180
8010837b:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108380:	e9 e7 f2 ff ff       	jmp    8010766c <alltraps>

80108385 <vector181>:
.globl vector181
vector181:
  pushl $0
80108385:	6a 00                	push   $0x0
  pushl $181
80108387:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010838c:	e9 db f2 ff ff       	jmp    8010766c <alltraps>

80108391 <vector182>:
.globl vector182
vector182:
  pushl $0
80108391:	6a 00                	push   $0x0
  pushl $182
80108393:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108398:	e9 cf f2 ff ff       	jmp    8010766c <alltraps>

8010839d <vector183>:
.globl vector183
vector183:
  pushl $0
8010839d:	6a 00                	push   $0x0
  pushl $183
8010839f:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801083a4:	e9 c3 f2 ff ff       	jmp    8010766c <alltraps>

801083a9 <vector184>:
.globl vector184
vector184:
  pushl $0
801083a9:	6a 00                	push   $0x0
  pushl $184
801083ab:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801083b0:	e9 b7 f2 ff ff       	jmp    8010766c <alltraps>

801083b5 <vector185>:
.globl vector185
vector185:
  pushl $0
801083b5:	6a 00                	push   $0x0
  pushl $185
801083b7:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801083bc:	e9 ab f2 ff ff       	jmp    8010766c <alltraps>

801083c1 <vector186>:
.globl vector186
vector186:
  pushl $0
801083c1:	6a 00                	push   $0x0
  pushl $186
801083c3:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801083c8:	e9 9f f2 ff ff       	jmp    8010766c <alltraps>

801083cd <vector187>:
.globl vector187
vector187:
  pushl $0
801083cd:	6a 00                	push   $0x0
  pushl $187
801083cf:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801083d4:	e9 93 f2 ff ff       	jmp    8010766c <alltraps>

801083d9 <vector188>:
.globl vector188
vector188:
  pushl $0
801083d9:	6a 00                	push   $0x0
  pushl $188
801083db:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801083e0:	e9 87 f2 ff ff       	jmp    8010766c <alltraps>

801083e5 <vector189>:
.globl vector189
vector189:
  pushl $0
801083e5:	6a 00                	push   $0x0
  pushl $189
801083e7:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801083ec:	e9 7b f2 ff ff       	jmp    8010766c <alltraps>

801083f1 <vector190>:
.globl vector190
vector190:
  pushl $0
801083f1:	6a 00                	push   $0x0
  pushl $190
801083f3:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801083f8:	e9 6f f2 ff ff       	jmp    8010766c <alltraps>

801083fd <vector191>:
.globl vector191
vector191:
  pushl $0
801083fd:	6a 00                	push   $0x0
  pushl $191
801083ff:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108404:	e9 63 f2 ff ff       	jmp    8010766c <alltraps>

80108409 <vector192>:
.globl vector192
vector192:
  pushl $0
80108409:	6a 00                	push   $0x0
  pushl $192
8010840b:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108410:	e9 57 f2 ff ff       	jmp    8010766c <alltraps>

80108415 <vector193>:
.globl vector193
vector193:
  pushl $0
80108415:	6a 00                	push   $0x0
  pushl $193
80108417:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010841c:	e9 4b f2 ff ff       	jmp    8010766c <alltraps>

80108421 <vector194>:
.globl vector194
vector194:
  pushl $0
80108421:	6a 00                	push   $0x0
  pushl $194
80108423:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108428:	e9 3f f2 ff ff       	jmp    8010766c <alltraps>

8010842d <vector195>:
.globl vector195
vector195:
  pushl $0
8010842d:	6a 00                	push   $0x0
  pushl $195
8010842f:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108434:	e9 33 f2 ff ff       	jmp    8010766c <alltraps>

80108439 <vector196>:
.globl vector196
vector196:
  pushl $0
80108439:	6a 00                	push   $0x0
  pushl $196
8010843b:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108440:	e9 27 f2 ff ff       	jmp    8010766c <alltraps>

80108445 <vector197>:
.globl vector197
vector197:
  pushl $0
80108445:	6a 00                	push   $0x0
  pushl $197
80108447:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010844c:	e9 1b f2 ff ff       	jmp    8010766c <alltraps>

80108451 <vector198>:
.globl vector198
vector198:
  pushl $0
80108451:	6a 00                	push   $0x0
  pushl $198
80108453:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108458:	e9 0f f2 ff ff       	jmp    8010766c <alltraps>

8010845d <vector199>:
.globl vector199
vector199:
  pushl $0
8010845d:	6a 00                	push   $0x0
  pushl $199
8010845f:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108464:	e9 03 f2 ff ff       	jmp    8010766c <alltraps>

80108469 <vector200>:
.globl vector200
vector200:
  pushl $0
80108469:	6a 00                	push   $0x0
  pushl $200
8010846b:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108470:	e9 f7 f1 ff ff       	jmp    8010766c <alltraps>

80108475 <vector201>:
.globl vector201
vector201:
  pushl $0
80108475:	6a 00                	push   $0x0
  pushl $201
80108477:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010847c:	e9 eb f1 ff ff       	jmp    8010766c <alltraps>

80108481 <vector202>:
.globl vector202
vector202:
  pushl $0
80108481:	6a 00                	push   $0x0
  pushl $202
80108483:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108488:	e9 df f1 ff ff       	jmp    8010766c <alltraps>

8010848d <vector203>:
.globl vector203
vector203:
  pushl $0
8010848d:	6a 00                	push   $0x0
  pushl $203
8010848f:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108494:	e9 d3 f1 ff ff       	jmp    8010766c <alltraps>

80108499 <vector204>:
.globl vector204
vector204:
  pushl $0
80108499:	6a 00                	push   $0x0
  pushl $204
8010849b:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801084a0:	e9 c7 f1 ff ff       	jmp    8010766c <alltraps>

801084a5 <vector205>:
.globl vector205
vector205:
  pushl $0
801084a5:	6a 00                	push   $0x0
  pushl $205
801084a7:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801084ac:	e9 bb f1 ff ff       	jmp    8010766c <alltraps>

801084b1 <vector206>:
.globl vector206
vector206:
  pushl $0
801084b1:	6a 00                	push   $0x0
  pushl $206
801084b3:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801084b8:	e9 af f1 ff ff       	jmp    8010766c <alltraps>

801084bd <vector207>:
.globl vector207
vector207:
  pushl $0
801084bd:	6a 00                	push   $0x0
  pushl $207
801084bf:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801084c4:	e9 a3 f1 ff ff       	jmp    8010766c <alltraps>

801084c9 <vector208>:
.globl vector208
vector208:
  pushl $0
801084c9:	6a 00                	push   $0x0
  pushl $208
801084cb:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801084d0:	e9 97 f1 ff ff       	jmp    8010766c <alltraps>

801084d5 <vector209>:
.globl vector209
vector209:
  pushl $0
801084d5:	6a 00                	push   $0x0
  pushl $209
801084d7:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801084dc:	e9 8b f1 ff ff       	jmp    8010766c <alltraps>

801084e1 <vector210>:
.globl vector210
vector210:
  pushl $0
801084e1:	6a 00                	push   $0x0
  pushl $210
801084e3:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801084e8:	e9 7f f1 ff ff       	jmp    8010766c <alltraps>

801084ed <vector211>:
.globl vector211
vector211:
  pushl $0
801084ed:	6a 00                	push   $0x0
  pushl $211
801084ef:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801084f4:	e9 73 f1 ff ff       	jmp    8010766c <alltraps>

801084f9 <vector212>:
.globl vector212
vector212:
  pushl $0
801084f9:	6a 00                	push   $0x0
  pushl $212
801084fb:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108500:	e9 67 f1 ff ff       	jmp    8010766c <alltraps>

80108505 <vector213>:
.globl vector213
vector213:
  pushl $0
80108505:	6a 00                	push   $0x0
  pushl $213
80108507:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010850c:	e9 5b f1 ff ff       	jmp    8010766c <alltraps>

80108511 <vector214>:
.globl vector214
vector214:
  pushl $0
80108511:	6a 00                	push   $0x0
  pushl $214
80108513:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108518:	e9 4f f1 ff ff       	jmp    8010766c <alltraps>

8010851d <vector215>:
.globl vector215
vector215:
  pushl $0
8010851d:	6a 00                	push   $0x0
  pushl $215
8010851f:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108524:	e9 43 f1 ff ff       	jmp    8010766c <alltraps>

80108529 <vector216>:
.globl vector216
vector216:
  pushl $0
80108529:	6a 00                	push   $0x0
  pushl $216
8010852b:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108530:	e9 37 f1 ff ff       	jmp    8010766c <alltraps>

80108535 <vector217>:
.globl vector217
vector217:
  pushl $0
80108535:	6a 00                	push   $0x0
  pushl $217
80108537:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010853c:	e9 2b f1 ff ff       	jmp    8010766c <alltraps>

80108541 <vector218>:
.globl vector218
vector218:
  pushl $0
80108541:	6a 00                	push   $0x0
  pushl $218
80108543:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108548:	e9 1f f1 ff ff       	jmp    8010766c <alltraps>

8010854d <vector219>:
.globl vector219
vector219:
  pushl $0
8010854d:	6a 00                	push   $0x0
  pushl $219
8010854f:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108554:	e9 13 f1 ff ff       	jmp    8010766c <alltraps>

80108559 <vector220>:
.globl vector220
vector220:
  pushl $0
80108559:	6a 00                	push   $0x0
  pushl $220
8010855b:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108560:	e9 07 f1 ff ff       	jmp    8010766c <alltraps>

80108565 <vector221>:
.globl vector221
vector221:
  pushl $0
80108565:	6a 00                	push   $0x0
  pushl $221
80108567:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010856c:	e9 fb f0 ff ff       	jmp    8010766c <alltraps>

80108571 <vector222>:
.globl vector222
vector222:
  pushl $0
80108571:	6a 00                	push   $0x0
  pushl $222
80108573:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108578:	e9 ef f0 ff ff       	jmp    8010766c <alltraps>

8010857d <vector223>:
.globl vector223
vector223:
  pushl $0
8010857d:	6a 00                	push   $0x0
  pushl $223
8010857f:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108584:	e9 e3 f0 ff ff       	jmp    8010766c <alltraps>

80108589 <vector224>:
.globl vector224
vector224:
  pushl $0
80108589:	6a 00                	push   $0x0
  pushl $224
8010858b:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108590:	e9 d7 f0 ff ff       	jmp    8010766c <alltraps>

80108595 <vector225>:
.globl vector225
vector225:
  pushl $0
80108595:	6a 00                	push   $0x0
  pushl $225
80108597:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010859c:	e9 cb f0 ff ff       	jmp    8010766c <alltraps>

801085a1 <vector226>:
.globl vector226
vector226:
  pushl $0
801085a1:	6a 00                	push   $0x0
  pushl $226
801085a3:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801085a8:	e9 bf f0 ff ff       	jmp    8010766c <alltraps>

801085ad <vector227>:
.globl vector227
vector227:
  pushl $0
801085ad:	6a 00                	push   $0x0
  pushl $227
801085af:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801085b4:	e9 b3 f0 ff ff       	jmp    8010766c <alltraps>

801085b9 <vector228>:
.globl vector228
vector228:
  pushl $0
801085b9:	6a 00                	push   $0x0
  pushl $228
801085bb:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801085c0:	e9 a7 f0 ff ff       	jmp    8010766c <alltraps>

801085c5 <vector229>:
.globl vector229
vector229:
  pushl $0
801085c5:	6a 00                	push   $0x0
  pushl $229
801085c7:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801085cc:	e9 9b f0 ff ff       	jmp    8010766c <alltraps>

801085d1 <vector230>:
.globl vector230
vector230:
  pushl $0
801085d1:	6a 00                	push   $0x0
  pushl $230
801085d3:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801085d8:	e9 8f f0 ff ff       	jmp    8010766c <alltraps>

801085dd <vector231>:
.globl vector231
vector231:
  pushl $0
801085dd:	6a 00                	push   $0x0
  pushl $231
801085df:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801085e4:	e9 83 f0 ff ff       	jmp    8010766c <alltraps>

801085e9 <vector232>:
.globl vector232
vector232:
  pushl $0
801085e9:	6a 00                	push   $0x0
  pushl $232
801085eb:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801085f0:	e9 77 f0 ff ff       	jmp    8010766c <alltraps>

801085f5 <vector233>:
.globl vector233
vector233:
  pushl $0
801085f5:	6a 00                	push   $0x0
  pushl $233
801085f7:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801085fc:	e9 6b f0 ff ff       	jmp    8010766c <alltraps>

80108601 <vector234>:
.globl vector234
vector234:
  pushl $0
80108601:	6a 00                	push   $0x0
  pushl $234
80108603:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108608:	e9 5f f0 ff ff       	jmp    8010766c <alltraps>

8010860d <vector235>:
.globl vector235
vector235:
  pushl $0
8010860d:	6a 00                	push   $0x0
  pushl $235
8010860f:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108614:	e9 53 f0 ff ff       	jmp    8010766c <alltraps>

80108619 <vector236>:
.globl vector236
vector236:
  pushl $0
80108619:	6a 00                	push   $0x0
  pushl $236
8010861b:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108620:	e9 47 f0 ff ff       	jmp    8010766c <alltraps>

80108625 <vector237>:
.globl vector237
vector237:
  pushl $0
80108625:	6a 00                	push   $0x0
  pushl $237
80108627:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010862c:	e9 3b f0 ff ff       	jmp    8010766c <alltraps>

80108631 <vector238>:
.globl vector238
vector238:
  pushl $0
80108631:	6a 00                	push   $0x0
  pushl $238
80108633:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108638:	e9 2f f0 ff ff       	jmp    8010766c <alltraps>

8010863d <vector239>:
.globl vector239
vector239:
  pushl $0
8010863d:	6a 00                	push   $0x0
  pushl $239
8010863f:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108644:	e9 23 f0 ff ff       	jmp    8010766c <alltraps>

80108649 <vector240>:
.globl vector240
vector240:
  pushl $0
80108649:	6a 00                	push   $0x0
  pushl $240
8010864b:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108650:	e9 17 f0 ff ff       	jmp    8010766c <alltraps>

80108655 <vector241>:
.globl vector241
vector241:
  pushl $0
80108655:	6a 00                	push   $0x0
  pushl $241
80108657:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010865c:	e9 0b f0 ff ff       	jmp    8010766c <alltraps>

80108661 <vector242>:
.globl vector242
vector242:
  pushl $0
80108661:	6a 00                	push   $0x0
  pushl $242
80108663:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108668:	e9 ff ef ff ff       	jmp    8010766c <alltraps>

8010866d <vector243>:
.globl vector243
vector243:
  pushl $0
8010866d:	6a 00                	push   $0x0
  pushl $243
8010866f:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108674:	e9 f3 ef ff ff       	jmp    8010766c <alltraps>

80108679 <vector244>:
.globl vector244
vector244:
  pushl $0
80108679:	6a 00                	push   $0x0
  pushl $244
8010867b:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108680:	e9 e7 ef ff ff       	jmp    8010766c <alltraps>

80108685 <vector245>:
.globl vector245
vector245:
  pushl $0
80108685:	6a 00                	push   $0x0
  pushl $245
80108687:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010868c:	e9 db ef ff ff       	jmp    8010766c <alltraps>

80108691 <vector246>:
.globl vector246
vector246:
  pushl $0
80108691:	6a 00                	push   $0x0
  pushl $246
80108693:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108698:	e9 cf ef ff ff       	jmp    8010766c <alltraps>

8010869d <vector247>:
.globl vector247
vector247:
  pushl $0
8010869d:	6a 00                	push   $0x0
  pushl $247
8010869f:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801086a4:	e9 c3 ef ff ff       	jmp    8010766c <alltraps>

801086a9 <vector248>:
.globl vector248
vector248:
  pushl $0
801086a9:	6a 00                	push   $0x0
  pushl $248
801086ab:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801086b0:	e9 b7 ef ff ff       	jmp    8010766c <alltraps>

801086b5 <vector249>:
.globl vector249
vector249:
  pushl $0
801086b5:	6a 00                	push   $0x0
  pushl $249
801086b7:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801086bc:	e9 ab ef ff ff       	jmp    8010766c <alltraps>

801086c1 <vector250>:
.globl vector250
vector250:
  pushl $0
801086c1:	6a 00                	push   $0x0
  pushl $250
801086c3:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801086c8:	e9 9f ef ff ff       	jmp    8010766c <alltraps>

801086cd <vector251>:
.globl vector251
vector251:
  pushl $0
801086cd:	6a 00                	push   $0x0
  pushl $251
801086cf:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801086d4:	e9 93 ef ff ff       	jmp    8010766c <alltraps>

801086d9 <vector252>:
.globl vector252
vector252:
  pushl $0
801086d9:	6a 00                	push   $0x0
  pushl $252
801086db:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801086e0:	e9 87 ef ff ff       	jmp    8010766c <alltraps>

801086e5 <vector253>:
.globl vector253
vector253:
  pushl $0
801086e5:	6a 00                	push   $0x0
  pushl $253
801086e7:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801086ec:	e9 7b ef ff ff       	jmp    8010766c <alltraps>

801086f1 <vector254>:
.globl vector254
vector254:
  pushl $0
801086f1:	6a 00                	push   $0x0
  pushl $254
801086f3:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801086f8:	e9 6f ef ff ff       	jmp    8010766c <alltraps>

801086fd <vector255>:
.globl vector255
vector255:
  pushl $0
801086fd:	6a 00                	push   $0x0
  pushl $255
801086ff:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108704:	e9 63 ef ff ff       	jmp    8010766c <alltraps>

80108709 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108709:	55                   	push   %ebp
8010870a:	89 e5                	mov    %esp,%ebp
8010870c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010870f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108712:	83 e8 01             	sub    $0x1,%eax
80108715:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108719:	8b 45 08             	mov    0x8(%ebp),%eax
8010871c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108720:	8b 45 08             	mov    0x8(%ebp),%eax
80108723:	c1 e8 10             	shr    $0x10,%eax
80108726:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010872a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010872d:	0f 01 10             	lgdtl  (%eax)
}
80108730:	90                   	nop
80108731:	c9                   	leave  
80108732:	c3                   	ret    

80108733 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108733:	55                   	push   %ebp
80108734:	89 e5                	mov    %esp,%ebp
80108736:	83 ec 04             	sub    $0x4,%esp
80108739:	8b 45 08             	mov    0x8(%ebp),%eax
8010873c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108740:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108744:	0f 00 d8             	ltr    %ax
}
80108747:	90                   	nop
80108748:	c9                   	leave  
80108749:	c3                   	ret    

8010874a <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010874a:	55                   	push   %ebp
8010874b:	89 e5                	mov    %esp,%ebp
8010874d:	83 ec 04             	sub    $0x4,%esp
80108750:	8b 45 08             	mov    0x8(%ebp),%eax
80108753:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108757:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010875b:	8e e8                	mov    %eax,%gs
}
8010875d:	90                   	nop
8010875e:	c9                   	leave  
8010875f:	c3                   	ret    

80108760 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108760:	55                   	push   %ebp
80108761:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108763:	8b 45 08             	mov    0x8(%ebp),%eax
80108766:	0f 22 d8             	mov    %eax,%cr3
}
80108769:	90                   	nop
8010876a:	5d                   	pop    %ebp
8010876b:	c3                   	ret    

8010876c <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010876c:	55                   	push   %ebp
8010876d:	89 e5                	mov    %esp,%ebp
8010876f:	8b 45 08             	mov    0x8(%ebp),%eax
80108772:	05 00 00 00 80       	add    $0x80000000,%eax
80108777:	5d                   	pop    %ebp
80108778:	c3                   	ret    

80108779 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108779:	55                   	push   %ebp
8010877a:	89 e5                	mov    %esp,%ebp
8010877c:	8b 45 08             	mov    0x8(%ebp),%eax
8010877f:	05 00 00 00 80       	add    $0x80000000,%eax
80108784:	5d                   	pop    %ebp
80108785:	c3                   	ret    

80108786 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108786:	55                   	push   %ebp
80108787:	89 e5                	mov    %esp,%ebp
80108789:	53                   	push   %ebx
8010878a:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010878d:	e8 e4 a8 ff ff       	call   80103076 <cpunum>
80108792:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108798:	05 80 33 11 80       	add    $0x80113380,%eax
8010879d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801087a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a3:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801087a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ac:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801087b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087b5:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801087b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087bc:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801087c0:	83 e2 f0             	and    $0xfffffff0,%edx
801087c3:	83 ca 0a             	or     $0xa,%edx
801087c6:	88 50 7d             	mov    %dl,0x7d(%eax)
801087c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087cc:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801087d0:	83 ca 10             	or     $0x10,%edx
801087d3:	88 50 7d             	mov    %dl,0x7d(%eax)
801087d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d9:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801087dd:	83 e2 9f             	and    $0xffffff9f,%edx
801087e0:	88 50 7d             	mov    %dl,0x7d(%eax)
801087e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e6:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801087ea:	83 ca 80             	or     $0xffffff80,%edx
801087ed:	88 50 7d             	mov    %dl,0x7d(%eax)
801087f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087f3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801087f7:	83 ca 0f             	or     $0xf,%edx
801087fa:	88 50 7e             	mov    %dl,0x7e(%eax)
801087fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108800:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108804:	83 e2 ef             	and    $0xffffffef,%edx
80108807:	88 50 7e             	mov    %dl,0x7e(%eax)
8010880a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010880d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108811:	83 e2 df             	and    $0xffffffdf,%edx
80108814:	88 50 7e             	mov    %dl,0x7e(%eax)
80108817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010881a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010881e:	83 ca 40             	or     $0x40,%edx
80108821:	88 50 7e             	mov    %dl,0x7e(%eax)
80108824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108827:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010882b:	83 ca 80             	or     $0xffffff80,%edx
8010882e:	88 50 7e             	mov    %dl,0x7e(%eax)
80108831:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108834:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010883b:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108842:	ff ff 
80108844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108847:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010884e:	00 00 
80108850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108853:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010885a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010885d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108864:	83 e2 f0             	and    $0xfffffff0,%edx
80108867:	83 ca 02             	or     $0x2,%edx
8010886a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108873:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010887a:	83 ca 10             	or     $0x10,%edx
8010887d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108886:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010888d:	83 e2 9f             	and    $0xffffff9f,%edx
80108890:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108899:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801088a0:	83 ca 80             	or     $0xffffff80,%edx
801088a3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801088a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ac:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801088b3:	83 ca 0f             	or     $0xf,%edx
801088b6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801088bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088bf:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801088c6:	83 e2 ef             	and    $0xffffffef,%edx
801088c9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801088cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d2:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801088d9:	83 e2 df             	and    $0xffffffdf,%edx
801088dc:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801088e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801088ec:	83 ca 40             	or     $0x40,%edx
801088ef:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801088f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088f8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801088ff:	83 ca 80             	or     $0xffffff80,%edx
80108902:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010890b:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108915:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010891c:	ff ff 
8010891e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108921:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108928:	00 00 
8010892a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010892d:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108937:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010893e:	83 e2 f0             	and    $0xfffffff0,%edx
80108941:	83 ca 0a             	or     $0xa,%edx
80108944:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010894a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010894d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108954:	83 ca 10             	or     $0x10,%edx
80108957:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010895d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108960:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108967:	83 ca 60             	or     $0x60,%edx
8010896a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108973:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010897a:	83 ca 80             	or     $0xffffff80,%edx
8010897d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108986:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010898d:	83 ca 0f             	or     $0xf,%edx
80108990:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108999:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801089a0:	83 e2 ef             	and    $0xffffffef,%edx
801089a3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801089a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ac:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801089b3:	83 e2 df             	and    $0xffffffdf,%edx
801089b6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801089bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089bf:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801089c6:	83 ca 40             	or     $0x40,%edx
801089c9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801089cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089d2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801089d9:	83 ca 80             	or     $0xffffff80,%edx
801089dc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801089e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089e5:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801089ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ef:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801089f6:	ff ff 
801089f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089fb:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108a02:	00 00 
80108a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a07:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a11:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108a18:	83 e2 f0             	and    $0xfffffff0,%edx
80108a1b:	83 ca 02             	or     $0x2,%edx
80108a1e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a27:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108a2e:	83 ca 10             	or     $0x10,%edx
80108a31:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a3a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108a41:	83 ca 60             	or     $0x60,%edx
80108a44:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a4d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108a54:	83 ca 80             	or     $0xffffff80,%edx
80108a57:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a60:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108a67:	83 ca 0f             	or     $0xf,%edx
80108a6a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a73:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108a7a:	83 e2 ef             	and    $0xffffffef,%edx
80108a7d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a86:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108a8d:	83 e2 df             	and    $0xffffffdf,%edx
80108a90:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a99:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108aa0:	83 ca 40             	or     $0x40,%edx
80108aa3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aac:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ab3:	83 ca 80             	or     $0xffffff80,%edx
80108ab6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abf:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac9:	05 b4 00 00 00       	add    $0xb4,%eax
80108ace:	89 c3                	mov    %eax,%ebx
80108ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad3:	05 b4 00 00 00       	add    $0xb4,%eax
80108ad8:	c1 e8 10             	shr    $0x10,%eax
80108adb:	89 c2                	mov    %eax,%edx
80108add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ae0:	05 b4 00 00 00       	add    $0xb4,%eax
80108ae5:	c1 e8 18             	shr    $0x18,%eax
80108ae8:	89 c1                	mov    %eax,%ecx
80108aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aed:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108af4:	00 00 
80108af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af9:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b03:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b0c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108b13:	83 e2 f0             	and    $0xfffffff0,%edx
80108b16:	83 ca 02             	or     $0x2,%edx
80108b19:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b22:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108b29:	83 ca 10             	or     $0x10,%edx
80108b2c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b35:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108b3c:	83 e2 9f             	and    $0xffffff9f,%edx
80108b3f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b48:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108b4f:	83 ca 80             	or     $0xffffff80,%edx
80108b52:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108b62:	83 e2 f0             	and    $0xfffffff0,%edx
80108b65:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b6e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108b75:	83 e2 ef             	and    $0xffffffef,%edx
80108b78:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b81:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108b88:	83 e2 df             	and    $0xffffffdf,%edx
80108b8b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b94:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108b9b:	83 ca 40             	or     $0x40,%edx
80108b9e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ba7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108bae:	83 ca 80             	or     $0xffffff80,%edx
80108bb1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bba:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc3:	83 c0 70             	add    $0x70,%eax
80108bc6:	83 ec 08             	sub    $0x8,%esp
80108bc9:	6a 38                	push   $0x38
80108bcb:	50                   	push   %eax
80108bcc:	e8 38 fb ff ff       	call   80108709 <lgdt>
80108bd1:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108bd4:	83 ec 0c             	sub    $0xc,%esp
80108bd7:	6a 18                	push   $0x18
80108bd9:	e8 6c fb ff ff       	call   8010874a <loadgs>
80108bde:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be4:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108bea:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108bf1:	00 00 00 00 
}
80108bf5:	90                   	nop
80108bf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108bf9:	c9                   	leave  
80108bfa:	c3                   	ret    

80108bfb <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108bfb:	55                   	push   %ebp
80108bfc:	89 e5                	mov    %esp,%ebp
80108bfe:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108c01:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c04:	c1 e8 16             	shr    $0x16,%eax
80108c07:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80108c11:	01 d0                	add    %edx,%eax
80108c13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c19:	8b 00                	mov    (%eax),%eax
80108c1b:	83 e0 01             	and    $0x1,%eax
80108c1e:	85 c0                	test   %eax,%eax
80108c20:	74 18                	je     80108c3a <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c25:	8b 00                	mov    (%eax),%eax
80108c27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c2c:	50                   	push   %eax
80108c2d:	e8 47 fb ff ff       	call   80108779 <p2v>
80108c32:	83 c4 04             	add    $0x4,%esp
80108c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108c38:	eb 48                	jmp    80108c82 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108c3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108c3e:	74 0e                	je     80108c4e <walkpgdir+0x53>
80108c40:	e8 cb a0 ff ff       	call   80102d10 <kalloc>
80108c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108c4c:	75 07                	jne    80108c55 <walkpgdir+0x5a>
      return 0;
80108c4e:	b8 00 00 00 00       	mov    $0x0,%eax
80108c53:	eb 44                	jmp    80108c99 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108c55:	83 ec 04             	sub    $0x4,%esp
80108c58:	68 00 10 00 00       	push   $0x1000
80108c5d:	6a 00                	push   $0x0
80108c5f:	ff 75 f4             	pushl  -0xc(%ebp)
80108c62:	e8 ed d4 ff ff       	call   80106154 <memset>
80108c67:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108c6a:	83 ec 0c             	sub    $0xc,%esp
80108c6d:	ff 75 f4             	pushl  -0xc(%ebp)
80108c70:	e8 f7 fa ff ff       	call   8010876c <v2p>
80108c75:	83 c4 10             	add    $0x10,%esp
80108c78:	83 c8 07             	or     $0x7,%eax
80108c7b:	89 c2                	mov    %eax,%edx
80108c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c80:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108c82:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c85:	c1 e8 0c             	shr    $0xc,%eax
80108c88:	25 ff 03 00 00       	and    $0x3ff,%eax
80108c8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c97:	01 d0                	add    %edx,%eax
}
80108c99:	c9                   	leave  
80108c9a:	c3                   	ret    

80108c9b <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108c9b:	55                   	push   %ebp
80108c9c:	89 e5                	mov    %esp,%ebp
80108c9e:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ca4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108cac:	8b 55 0c             	mov    0xc(%ebp),%edx
80108caf:	8b 45 10             	mov    0x10(%ebp),%eax
80108cb2:	01 d0                	add    %edx,%eax
80108cb4:	83 e8 01             	sub    $0x1,%eax
80108cb7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108cbf:	83 ec 04             	sub    $0x4,%esp
80108cc2:	6a 01                	push   $0x1
80108cc4:	ff 75 f4             	pushl  -0xc(%ebp)
80108cc7:	ff 75 08             	pushl  0x8(%ebp)
80108cca:	e8 2c ff ff ff       	call   80108bfb <walkpgdir>
80108ccf:	83 c4 10             	add    $0x10,%esp
80108cd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108cd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108cd9:	75 07                	jne    80108ce2 <mappages+0x47>
      return -1;
80108cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ce0:	eb 47                	jmp    80108d29 <mappages+0x8e>
    if(*pte & PTE_P)
80108ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ce5:	8b 00                	mov    (%eax),%eax
80108ce7:	83 e0 01             	and    $0x1,%eax
80108cea:	85 c0                	test   %eax,%eax
80108cec:	74 0d                	je     80108cfb <mappages+0x60>
      panic("remap");
80108cee:	83 ec 0c             	sub    $0xc,%esp
80108cf1:	68 1c 9d 10 80       	push   $0x80109d1c
80108cf6:	e8 6b 78 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80108cfb:	8b 45 18             	mov    0x18(%ebp),%eax
80108cfe:	0b 45 14             	or     0x14(%ebp),%eax
80108d01:	83 c8 01             	or     $0x1,%eax
80108d04:	89 c2                	mov    %eax,%edx
80108d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d09:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d0e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108d11:	74 10                	je     80108d23 <mappages+0x88>
      break;
    a += PGSIZE;
80108d13:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108d1a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108d21:	eb 9c                	jmp    80108cbf <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108d23:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108d24:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d29:	c9                   	leave  
80108d2a:	c3                   	ret    

80108d2b <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108d2b:	55                   	push   %ebp
80108d2c:	89 e5                	mov    %esp,%ebp
80108d2e:	53                   	push   %ebx
80108d2f:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108d32:	e8 d9 9f ff ff       	call   80102d10 <kalloc>
80108d37:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108d3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108d3e:	75 0a                	jne    80108d4a <setupkvm+0x1f>
    return 0;
80108d40:	b8 00 00 00 00       	mov    $0x0,%eax
80108d45:	e9 8e 00 00 00       	jmp    80108dd8 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108d4a:	83 ec 04             	sub    $0x4,%esp
80108d4d:	68 00 10 00 00       	push   $0x1000
80108d52:	6a 00                	push   $0x0
80108d54:	ff 75 f0             	pushl  -0x10(%ebp)
80108d57:	e8 f8 d3 ff ff       	call   80106154 <memset>
80108d5c:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108d5f:	83 ec 0c             	sub    $0xc,%esp
80108d62:	68 00 00 00 0e       	push   $0xe000000
80108d67:	e8 0d fa ff ff       	call   80108779 <p2v>
80108d6c:	83 c4 10             	add    $0x10,%esp
80108d6f:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108d74:	76 0d                	jbe    80108d83 <setupkvm+0x58>
    panic("PHYSTOP too high");
80108d76:	83 ec 0c             	sub    $0xc,%esp
80108d79:	68 22 9d 10 80       	push   $0x80109d22
80108d7e:	e8 e3 77 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108d83:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108d8a:	eb 40                	jmp    80108dcc <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d8f:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d95:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d9b:	8b 58 08             	mov    0x8(%eax),%ebx
80108d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da1:	8b 40 04             	mov    0x4(%eax),%eax
80108da4:	29 c3                	sub    %eax,%ebx
80108da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da9:	8b 00                	mov    (%eax),%eax
80108dab:	83 ec 0c             	sub    $0xc,%esp
80108dae:	51                   	push   %ecx
80108daf:	52                   	push   %edx
80108db0:	53                   	push   %ebx
80108db1:	50                   	push   %eax
80108db2:	ff 75 f0             	pushl  -0x10(%ebp)
80108db5:	e8 e1 fe ff ff       	call   80108c9b <mappages>
80108dba:	83 c4 20             	add    $0x20,%esp
80108dbd:	85 c0                	test   %eax,%eax
80108dbf:	79 07                	jns    80108dc8 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108dc1:	b8 00 00 00 00       	mov    $0x0,%eax
80108dc6:	eb 10                	jmp    80108dd8 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108dc8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108dcc:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108dd3:	72 b7                	jb     80108d8c <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108dd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108ddb:	c9                   	leave  
80108ddc:	c3                   	ret    

80108ddd <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108ddd:	55                   	push   %ebp
80108dde:	89 e5                	mov    %esp,%ebp
80108de0:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108de3:	e8 43 ff ff ff       	call   80108d2b <setupkvm>
80108de8:	a3 38 67 11 80       	mov    %eax,0x80116738
  switchkvm();
80108ded:	e8 03 00 00 00       	call   80108df5 <switchkvm>
}
80108df2:	90                   	nop
80108df3:	c9                   	leave  
80108df4:	c3                   	ret    

80108df5 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108df5:	55                   	push   %ebp
80108df6:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108df8:	a1 38 67 11 80       	mov    0x80116738,%eax
80108dfd:	50                   	push   %eax
80108dfe:	e8 69 f9 ff ff       	call   8010876c <v2p>
80108e03:	83 c4 04             	add    $0x4,%esp
80108e06:	50                   	push   %eax
80108e07:	e8 54 f9 ff ff       	call   80108760 <lcr3>
80108e0c:	83 c4 04             	add    $0x4,%esp
}
80108e0f:	90                   	nop
80108e10:	c9                   	leave  
80108e11:	c3                   	ret    

80108e12 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108e12:	55                   	push   %ebp
80108e13:	89 e5                	mov    %esp,%ebp
80108e15:	56                   	push   %esi
80108e16:	53                   	push   %ebx
  pushcli();
80108e17:	e8 32 d2 ff ff       	call   8010604e <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108e1c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108e22:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108e29:	83 c2 08             	add    $0x8,%edx
80108e2c:	89 d6                	mov    %edx,%esi
80108e2e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108e35:	83 c2 08             	add    $0x8,%edx
80108e38:	c1 ea 10             	shr    $0x10,%edx
80108e3b:	89 d3                	mov    %edx,%ebx
80108e3d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108e44:	83 c2 08             	add    $0x8,%edx
80108e47:	c1 ea 18             	shr    $0x18,%edx
80108e4a:	89 d1                	mov    %edx,%ecx
80108e4c:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108e53:	67 00 
80108e55:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108e5c:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108e62:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108e69:	83 e2 f0             	and    $0xfffffff0,%edx
80108e6c:	83 ca 09             	or     $0x9,%edx
80108e6f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108e75:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108e7c:	83 ca 10             	or     $0x10,%edx
80108e7f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108e85:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108e8c:	83 e2 9f             	and    $0xffffff9f,%edx
80108e8f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108e95:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108e9c:	83 ca 80             	or     $0xffffff80,%edx
80108e9f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108ea5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108eac:	83 e2 f0             	and    $0xfffffff0,%edx
80108eaf:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108eb5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108ebc:	83 e2 ef             	and    $0xffffffef,%edx
80108ebf:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108ec5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108ecc:	83 e2 df             	and    $0xffffffdf,%edx
80108ecf:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108ed5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108edc:	83 ca 40             	or     $0x40,%edx
80108edf:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108ee5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108eec:	83 e2 7f             	and    $0x7f,%edx
80108eef:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108ef5:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108efb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108f01:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108f08:	83 e2 ef             	and    $0xffffffef,%edx
80108f0b:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108f11:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108f17:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108f1d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108f23:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108f2a:	8b 52 08             	mov    0x8(%edx),%edx
80108f2d:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108f33:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108f36:	83 ec 0c             	sub    $0xc,%esp
80108f39:	6a 30                	push   $0x30
80108f3b:	e8 f3 f7 ff ff       	call   80108733 <ltr>
80108f40:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108f43:	8b 45 08             	mov    0x8(%ebp),%eax
80108f46:	8b 40 04             	mov    0x4(%eax),%eax
80108f49:	85 c0                	test   %eax,%eax
80108f4b:	75 0d                	jne    80108f5a <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108f4d:	83 ec 0c             	sub    $0xc,%esp
80108f50:	68 33 9d 10 80       	push   $0x80109d33
80108f55:	e8 0c 76 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108f5a:	8b 45 08             	mov    0x8(%ebp),%eax
80108f5d:	8b 40 04             	mov    0x4(%eax),%eax
80108f60:	83 ec 0c             	sub    $0xc,%esp
80108f63:	50                   	push   %eax
80108f64:	e8 03 f8 ff ff       	call   8010876c <v2p>
80108f69:	83 c4 10             	add    $0x10,%esp
80108f6c:	83 ec 0c             	sub    $0xc,%esp
80108f6f:	50                   	push   %eax
80108f70:	e8 eb f7 ff ff       	call   80108760 <lcr3>
80108f75:	83 c4 10             	add    $0x10,%esp
  popcli();
80108f78:	e8 16 d1 ff ff       	call   80106093 <popcli>
}
80108f7d:	90                   	nop
80108f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108f81:	5b                   	pop    %ebx
80108f82:	5e                   	pop    %esi
80108f83:	5d                   	pop    %ebp
80108f84:	c3                   	ret    

80108f85 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108f85:	55                   	push   %ebp
80108f86:	89 e5                	mov    %esp,%ebp
80108f88:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108f8b:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108f92:	76 0d                	jbe    80108fa1 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108f94:	83 ec 0c             	sub    $0xc,%esp
80108f97:	68 47 9d 10 80       	push   $0x80109d47
80108f9c:	e8 c5 75 ff ff       	call   80100566 <panic>
  mem = kalloc();
80108fa1:	e8 6a 9d ff ff       	call   80102d10 <kalloc>
80108fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108fa9:	83 ec 04             	sub    $0x4,%esp
80108fac:	68 00 10 00 00       	push   $0x1000
80108fb1:	6a 00                	push   $0x0
80108fb3:	ff 75 f4             	pushl  -0xc(%ebp)
80108fb6:	e8 99 d1 ff ff       	call   80106154 <memset>
80108fbb:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108fbe:	83 ec 0c             	sub    $0xc,%esp
80108fc1:	ff 75 f4             	pushl  -0xc(%ebp)
80108fc4:	e8 a3 f7 ff ff       	call   8010876c <v2p>
80108fc9:	83 c4 10             	add    $0x10,%esp
80108fcc:	83 ec 0c             	sub    $0xc,%esp
80108fcf:	6a 06                	push   $0x6
80108fd1:	50                   	push   %eax
80108fd2:	68 00 10 00 00       	push   $0x1000
80108fd7:	6a 00                	push   $0x0
80108fd9:	ff 75 08             	pushl  0x8(%ebp)
80108fdc:	e8 ba fc ff ff       	call   80108c9b <mappages>
80108fe1:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108fe4:	83 ec 04             	sub    $0x4,%esp
80108fe7:	ff 75 10             	pushl  0x10(%ebp)
80108fea:	ff 75 0c             	pushl  0xc(%ebp)
80108fed:	ff 75 f4             	pushl  -0xc(%ebp)
80108ff0:	e8 1e d2 ff ff       	call   80106213 <memmove>
80108ff5:	83 c4 10             	add    $0x10,%esp
}
80108ff8:	90                   	nop
80108ff9:	c9                   	leave  
80108ffa:	c3                   	ret    

80108ffb <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108ffb:	55                   	push   %ebp
80108ffc:	89 e5                	mov    %esp,%ebp
80108ffe:	53                   	push   %ebx
80108fff:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109002:	8b 45 0c             	mov    0xc(%ebp),%eax
80109005:	25 ff 0f 00 00       	and    $0xfff,%eax
8010900a:	85 c0                	test   %eax,%eax
8010900c:	74 0d                	je     8010901b <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010900e:	83 ec 0c             	sub    $0xc,%esp
80109011:	68 64 9d 10 80       	push   $0x80109d64
80109016:	e8 4b 75 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010901b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109022:	e9 95 00 00 00       	jmp    801090bc <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109027:	8b 55 0c             	mov    0xc(%ebp),%edx
8010902a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010902d:	01 d0                	add    %edx,%eax
8010902f:	83 ec 04             	sub    $0x4,%esp
80109032:	6a 00                	push   $0x0
80109034:	50                   	push   %eax
80109035:	ff 75 08             	pushl  0x8(%ebp)
80109038:	e8 be fb ff ff       	call   80108bfb <walkpgdir>
8010903d:	83 c4 10             	add    $0x10,%esp
80109040:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109043:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109047:	75 0d                	jne    80109056 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109049:	83 ec 0c             	sub    $0xc,%esp
8010904c:	68 87 9d 10 80       	push   $0x80109d87
80109051:	e8 10 75 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109056:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109059:	8b 00                	mov    (%eax),%eax
8010905b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109060:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109063:	8b 45 18             	mov    0x18(%ebp),%eax
80109066:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109069:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010906e:	77 0b                	ja     8010907b <loaduvm+0x80>
      n = sz - i;
80109070:	8b 45 18             	mov    0x18(%ebp),%eax
80109073:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109076:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109079:	eb 07                	jmp    80109082 <loaduvm+0x87>
    else
      n = PGSIZE;
8010907b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109082:	8b 55 14             	mov    0x14(%ebp),%edx
80109085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109088:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010908b:	83 ec 0c             	sub    $0xc,%esp
8010908e:	ff 75 e8             	pushl  -0x18(%ebp)
80109091:	e8 e3 f6 ff ff       	call   80108779 <p2v>
80109096:	83 c4 10             	add    $0x10,%esp
80109099:	ff 75 f0             	pushl  -0x10(%ebp)
8010909c:	53                   	push   %ebx
8010909d:	50                   	push   %eax
8010909e:	ff 75 10             	pushl  0x10(%ebp)
801090a1:	e8 dc 8e ff ff       	call   80101f82 <readi>
801090a6:	83 c4 10             	add    $0x10,%esp
801090a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801090ac:	74 07                	je     801090b5 <loaduvm+0xba>
      return -1;
801090ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801090b3:	eb 18                	jmp    801090cd <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801090b5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801090bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090bf:	3b 45 18             	cmp    0x18(%ebp),%eax
801090c2:	0f 82 5f ff ff ff    	jb     80109027 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801090c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801090cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801090d0:	c9                   	leave  
801090d1:	c3                   	ret    

801090d2 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801090d2:	55                   	push   %ebp
801090d3:	89 e5                	mov    %esp,%ebp
801090d5:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801090d8:	8b 45 10             	mov    0x10(%ebp),%eax
801090db:	85 c0                	test   %eax,%eax
801090dd:	79 0a                	jns    801090e9 <allocuvm+0x17>
    return 0;
801090df:	b8 00 00 00 00       	mov    $0x0,%eax
801090e4:	e9 b0 00 00 00       	jmp    80109199 <allocuvm+0xc7>
  if(newsz < oldsz)
801090e9:	8b 45 10             	mov    0x10(%ebp),%eax
801090ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
801090ef:	73 08                	jae    801090f9 <allocuvm+0x27>
    return oldsz;
801090f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801090f4:	e9 a0 00 00 00       	jmp    80109199 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
801090f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801090fc:	05 ff 0f 00 00       	add    $0xfff,%eax
80109101:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109109:	eb 7f                	jmp    8010918a <allocuvm+0xb8>
    mem = kalloc();
8010910b:	e8 00 9c ff ff       	call   80102d10 <kalloc>
80109110:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109113:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109117:	75 2b                	jne    80109144 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109119:	83 ec 0c             	sub    $0xc,%esp
8010911c:	68 a5 9d 10 80       	push   $0x80109da5
80109121:	e8 a0 72 ff ff       	call   801003c6 <cprintf>
80109126:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109129:	83 ec 04             	sub    $0x4,%esp
8010912c:	ff 75 0c             	pushl  0xc(%ebp)
8010912f:	ff 75 10             	pushl  0x10(%ebp)
80109132:	ff 75 08             	pushl  0x8(%ebp)
80109135:	e8 61 00 00 00       	call   8010919b <deallocuvm>
8010913a:	83 c4 10             	add    $0x10,%esp
      return 0;
8010913d:	b8 00 00 00 00       	mov    $0x0,%eax
80109142:	eb 55                	jmp    80109199 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109144:	83 ec 04             	sub    $0x4,%esp
80109147:	68 00 10 00 00       	push   $0x1000
8010914c:	6a 00                	push   $0x0
8010914e:	ff 75 f0             	pushl  -0x10(%ebp)
80109151:	e8 fe cf ff ff       	call   80106154 <memset>
80109156:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109159:	83 ec 0c             	sub    $0xc,%esp
8010915c:	ff 75 f0             	pushl  -0x10(%ebp)
8010915f:	e8 08 f6 ff ff       	call   8010876c <v2p>
80109164:	83 c4 10             	add    $0x10,%esp
80109167:	89 c2                	mov    %eax,%edx
80109169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010916c:	83 ec 0c             	sub    $0xc,%esp
8010916f:	6a 06                	push   $0x6
80109171:	52                   	push   %edx
80109172:	68 00 10 00 00       	push   $0x1000
80109177:	50                   	push   %eax
80109178:	ff 75 08             	pushl  0x8(%ebp)
8010917b:	e8 1b fb ff ff       	call   80108c9b <mappages>
80109180:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109183:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010918a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010918d:	3b 45 10             	cmp    0x10(%ebp),%eax
80109190:	0f 82 75 ff ff ff    	jb     8010910b <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109196:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109199:	c9                   	leave  
8010919a:	c3                   	ret    

8010919b <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010919b:	55                   	push   %ebp
8010919c:	89 e5                	mov    %esp,%ebp
8010919e:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801091a1:	8b 45 10             	mov    0x10(%ebp),%eax
801091a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801091a7:	72 08                	jb     801091b1 <deallocuvm+0x16>
    return oldsz;
801091a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801091ac:	e9 a5 00 00 00       	jmp    80109256 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801091b1:	8b 45 10             	mov    0x10(%ebp),%eax
801091b4:	05 ff 0f 00 00       	add    $0xfff,%eax
801091b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801091be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801091c1:	e9 81 00 00 00       	jmp    80109247 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801091c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091c9:	83 ec 04             	sub    $0x4,%esp
801091cc:	6a 00                	push   $0x0
801091ce:	50                   	push   %eax
801091cf:	ff 75 08             	pushl  0x8(%ebp)
801091d2:	e8 24 fa ff ff       	call   80108bfb <walkpgdir>
801091d7:	83 c4 10             	add    $0x10,%esp
801091da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801091dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801091e1:	75 09                	jne    801091ec <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801091e3:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801091ea:	eb 54                	jmp    80109240 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801091ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091ef:	8b 00                	mov    (%eax),%eax
801091f1:	83 e0 01             	and    $0x1,%eax
801091f4:	85 c0                	test   %eax,%eax
801091f6:	74 48                	je     80109240 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801091f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091fb:	8b 00                	mov    (%eax),%eax
801091fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109202:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109205:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109209:	75 0d                	jne    80109218 <deallocuvm+0x7d>
        panic("kfree");
8010920b:	83 ec 0c             	sub    $0xc,%esp
8010920e:	68 bd 9d 10 80       	push   $0x80109dbd
80109213:	e8 4e 73 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109218:	83 ec 0c             	sub    $0xc,%esp
8010921b:	ff 75 ec             	pushl  -0x14(%ebp)
8010921e:	e8 56 f5 ff ff       	call   80108779 <p2v>
80109223:	83 c4 10             	add    $0x10,%esp
80109226:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109229:	83 ec 0c             	sub    $0xc,%esp
8010922c:	ff 75 e8             	pushl  -0x18(%ebp)
8010922f:	e8 3f 9a ff ff       	call   80102c73 <kfree>
80109234:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109237:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010923a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109240:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109247:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010924a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010924d:	0f 82 73 ff ff ff    	jb     801091c6 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109253:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109256:	c9                   	leave  
80109257:	c3                   	ret    

80109258 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109258:	55                   	push   %ebp
80109259:	89 e5                	mov    %esp,%ebp
8010925b:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010925e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109262:	75 0d                	jne    80109271 <freevm+0x19>
    panic("freevm: no pgdir");
80109264:	83 ec 0c             	sub    $0xc,%esp
80109267:	68 c3 9d 10 80       	push   $0x80109dc3
8010926c:	e8 f5 72 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109271:	83 ec 04             	sub    $0x4,%esp
80109274:	6a 00                	push   $0x0
80109276:	68 00 00 00 80       	push   $0x80000000
8010927b:	ff 75 08             	pushl  0x8(%ebp)
8010927e:	e8 18 ff ff ff       	call   8010919b <deallocuvm>
80109283:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109286:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010928d:	eb 4f                	jmp    801092de <freevm+0x86>
    if(pgdir[i] & PTE_P){
8010928f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109292:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109299:	8b 45 08             	mov    0x8(%ebp),%eax
8010929c:	01 d0                	add    %edx,%eax
8010929e:	8b 00                	mov    (%eax),%eax
801092a0:	83 e0 01             	and    $0x1,%eax
801092a3:	85 c0                	test   %eax,%eax
801092a5:	74 33                	je     801092da <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801092a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801092b1:	8b 45 08             	mov    0x8(%ebp),%eax
801092b4:	01 d0                	add    %edx,%eax
801092b6:	8b 00                	mov    (%eax),%eax
801092b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801092bd:	83 ec 0c             	sub    $0xc,%esp
801092c0:	50                   	push   %eax
801092c1:	e8 b3 f4 ff ff       	call   80108779 <p2v>
801092c6:	83 c4 10             	add    $0x10,%esp
801092c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801092cc:	83 ec 0c             	sub    $0xc,%esp
801092cf:	ff 75 f0             	pushl  -0x10(%ebp)
801092d2:	e8 9c 99 ff ff       	call   80102c73 <kfree>
801092d7:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801092da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801092de:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801092e5:	76 a8                	jbe    8010928f <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801092e7:	83 ec 0c             	sub    $0xc,%esp
801092ea:	ff 75 08             	pushl  0x8(%ebp)
801092ed:	e8 81 99 ff ff       	call   80102c73 <kfree>
801092f2:	83 c4 10             	add    $0x10,%esp
}
801092f5:	90                   	nop
801092f6:	c9                   	leave  
801092f7:	c3                   	ret    

801092f8 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801092f8:	55                   	push   %ebp
801092f9:	89 e5                	mov    %esp,%ebp
801092fb:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801092fe:	83 ec 04             	sub    $0x4,%esp
80109301:	6a 00                	push   $0x0
80109303:	ff 75 0c             	pushl  0xc(%ebp)
80109306:	ff 75 08             	pushl  0x8(%ebp)
80109309:	e8 ed f8 ff ff       	call   80108bfb <walkpgdir>
8010930e:	83 c4 10             	add    $0x10,%esp
80109311:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109318:	75 0d                	jne    80109327 <clearpteu+0x2f>
    panic("clearpteu");
8010931a:	83 ec 0c             	sub    $0xc,%esp
8010931d:	68 d4 9d 10 80       	push   $0x80109dd4
80109322:	e8 3f 72 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010932a:	8b 00                	mov    (%eax),%eax
8010932c:	83 e0 fb             	and    $0xfffffffb,%eax
8010932f:	89 c2                	mov    %eax,%edx
80109331:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109334:	89 10                	mov    %edx,(%eax)
}
80109336:	90                   	nop
80109337:	c9                   	leave  
80109338:	c3                   	ret    

80109339 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109339:	55                   	push   %ebp
8010933a:	89 e5                	mov    %esp,%ebp
8010933c:	53                   	push   %ebx
8010933d:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109340:	e8 e6 f9 ff ff       	call   80108d2b <setupkvm>
80109345:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109348:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010934c:	75 0a                	jne    80109358 <copyuvm+0x1f>
    return 0;
8010934e:	b8 00 00 00 00       	mov    $0x0,%eax
80109353:	e9 f8 00 00 00       	jmp    80109450 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010935f:	e9 c4 00 00 00       	jmp    80109428 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109367:	83 ec 04             	sub    $0x4,%esp
8010936a:	6a 00                	push   $0x0
8010936c:	50                   	push   %eax
8010936d:	ff 75 08             	pushl  0x8(%ebp)
80109370:	e8 86 f8 ff ff       	call   80108bfb <walkpgdir>
80109375:	83 c4 10             	add    $0x10,%esp
80109378:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010937b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010937f:	75 0d                	jne    8010938e <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109381:	83 ec 0c             	sub    $0xc,%esp
80109384:	68 de 9d 10 80       	push   $0x80109dde
80109389:	e8 d8 71 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
8010938e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109391:	8b 00                	mov    (%eax),%eax
80109393:	83 e0 01             	and    $0x1,%eax
80109396:	85 c0                	test   %eax,%eax
80109398:	75 0d                	jne    801093a7 <copyuvm+0x6e>
      panic("copyuvm: page not present");
8010939a:	83 ec 0c             	sub    $0xc,%esp
8010939d:	68 f8 9d 10 80       	push   $0x80109df8
801093a2:	e8 bf 71 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801093a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801093aa:	8b 00                	mov    (%eax),%eax
801093ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801093b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801093b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801093b7:	8b 00                	mov    (%eax),%eax
801093b9:	25 ff 0f 00 00       	and    $0xfff,%eax
801093be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801093c1:	e8 4a 99 ff ff       	call   80102d10 <kalloc>
801093c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801093c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801093cd:	74 6a                	je     80109439 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801093cf:	83 ec 0c             	sub    $0xc,%esp
801093d2:	ff 75 e8             	pushl  -0x18(%ebp)
801093d5:	e8 9f f3 ff ff       	call   80108779 <p2v>
801093da:	83 c4 10             	add    $0x10,%esp
801093dd:	83 ec 04             	sub    $0x4,%esp
801093e0:	68 00 10 00 00       	push   $0x1000
801093e5:	50                   	push   %eax
801093e6:	ff 75 e0             	pushl  -0x20(%ebp)
801093e9:	e8 25 ce ff ff       	call   80106213 <memmove>
801093ee:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801093f1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801093f4:	83 ec 0c             	sub    $0xc,%esp
801093f7:	ff 75 e0             	pushl  -0x20(%ebp)
801093fa:	e8 6d f3 ff ff       	call   8010876c <v2p>
801093ff:	83 c4 10             	add    $0x10,%esp
80109402:	89 c2                	mov    %eax,%edx
80109404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109407:	83 ec 0c             	sub    $0xc,%esp
8010940a:	53                   	push   %ebx
8010940b:	52                   	push   %edx
8010940c:	68 00 10 00 00       	push   $0x1000
80109411:	50                   	push   %eax
80109412:	ff 75 f0             	pushl  -0x10(%ebp)
80109415:	e8 81 f8 ff ff       	call   80108c9b <mappages>
8010941a:	83 c4 20             	add    $0x20,%esp
8010941d:	85 c0                	test   %eax,%eax
8010941f:	78 1b                	js     8010943c <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109421:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010942b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010942e:	0f 82 30 ff ff ff    	jb     80109364 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109434:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109437:	eb 17                	jmp    80109450 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109439:	90                   	nop
8010943a:	eb 01                	jmp    8010943d <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010943c:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010943d:	83 ec 0c             	sub    $0xc,%esp
80109440:	ff 75 f0             	pushl  -0x10(%ebp)
80109443:	e8 10 fe ff ff       	call   80109258 <freevm>
80109448:	83 c4 10             	add    $0x10,%esp
  return 0;
8010944b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109450:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109453:	c9                   	leave  
80109454:	c3                   	ret    

80109455 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109455:	55                   	push   %ebp
80109456:	89 e5                	mov    %esp,%ebp
80109458:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010945b:	83 ec 04             	sub    $0x4,%esp
8010945e:	6a 00                	push   $0x0
80109460:	ff 75 0c             	pushl  0xc(%ebp)
80109463:	ff 75 08             	pushl  0x8(%ebp)
80109466:	e8 90 f7 ff ff       	call   80108bfb <walkpgdir>
8010946b:	83 c4 10             	add    $0x10,%esp
8010946e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109474:	8b 00                	mov    (%eax),%eax
80109476:	83 e0 01             	and    $0x1,%eax
80109479:	85 c0                	test   %eax,%eax
8010947b:	75 07                	jne    80109484 <uva2ka+0x2f>
    return 0;
8010947d:	b8 00 00 00 00       	mov    $0x0,%eax
80109482:	eb 29                	jmp    801094ad <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109484:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109487:	8b 00                	mov    (%eax),%eax
80109489:	83 e0 04             	and    $0x4,%eax
8010948c:	85 c0                	test   %eax,%eax
8010948e:	75 07                	jne    80109497 <uva2ka+0x42>
    return 0;
80109490:	b8 00 00 00 00       	mov    $0x0,%eax
80109495:	eb 16                	jmp    801094ad <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109497:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010949a:	8b 00                	mov    (%eax),%eax
8010949c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094a1:	83 ec 0c             	sub    $0xc,%esp
801094a4:	50                   	push   %eax
801094a5:	e8 cf f2 ff ff       	call   80108779 <p2v>
801094aa:	83 c4 10             	add    $0x10,%esp
}
801094ad:	c9                   	leave  
801094ae:	c3                   	ret    

801094af <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801094af:	55                   	push   %ebp
801094b0:	89 e5                	mov    %esp,%ebp
801094b2:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801094b5:	8b 45 10             	mov    0x10(%ebp),%eax
801094b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801094bb:	eb 7f                	jmp    8010953c <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801094bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801094c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801094c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801094cb:	83 ec 08             	sub    $0x8,%esp
801094ce:	50                   	push   %eax
801094cf:	ff 75 08             	pushl  0x8(%ebp)
801094d2:	e8 7e ff ff ff       	call   80109455 <uva2ka>
801094d7:	83 c4 10             	add    $0x10,%esp
801094da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801094dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801094e1:	75 07                	jne    801094ea <copyout+0x3b>
      return -1;
801094e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801094e8:	eb 61                	jmp    8010954b <copyout+0x9c>
    n = PGSIZE - (va - va0);
801094ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801094ed:	2b 45 0c             	sub    0xc(%ebp),%eax
801094f0:	05 00 10 00 00       	add    $0x1000,%eax
801094f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801094f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094fb:	3b 45 14             	cmp    0x14(%ebp),%eax
801094fe:	76 06                	jbe    80109506 <copyout+0x57>
      n = len;
80109500:	8b 45 14             	mov    0x14(%ebp),%eax
80109503:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109506:	8b 45 0c             	mov    0xc(%ebp),%eax
80109509:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010950c:	89 c2                	mov    %eax,%edx
8010950e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109511:	01 d0                	add    %edx,%eax
80109513:	83 ec 04             	sub    $0x4,%esp
80109516:	ff 75 f0             	pushl  -0x10(%ebp)
80109519:	ff 75 f4             	pushl  -0xc(%ebp)
8010951c:	50                   	push   %eax
8010951d:	e8 f1 cc ff ff       	call   80106213 <memmove>
80109522:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109525:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109528:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010952b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010952e:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109531:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109534:	05 00 10 00 00       	add    $0x1000,%eax
80109539:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010953c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109540:	0f 85 77 ff ff ff    	jne    801094bd <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109546:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010954b:	c9                   	leave  
8010954c:	c3                   	ret    
