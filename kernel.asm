
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
80100028:	bc 90 e6 10 80       	mov    $0x8010e690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a9 3b 10 80       	mov    $0x80103ba9,%eax
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
8010003d:	68 ac a0 10 80       	push   $0x8010a0ac
80100042:	68 a0 e6 10 80       	push   $0x8010e6a0
80100047:	e8 4b 68 00 00       	call   80106897 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 b0 25 11 80 a4 	movl   $0x801125a4,0x801125b0
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b4 25 11 80 a4 	movl   $0x801125a4,0x801125b4
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 d4 e6 10 80 	movl   $0x8010e6d4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 b4 25 11 80       	mov    %eax,0x801125b4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 a4 25 11 80       	mov    $0x801125a4,%eax
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
801000bc:	68 a0 e6 10 80       	push   $0x8010e6a0
801000c1:	e8 f3 67 00 00       	call   801068b9 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 b4 25 11 80       	mov    0x801125b4,%eax
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
80100107:	68 a0 e6 10 80       	push   $0x8010e6a0
8010010c:	e8 0f 68 00 00       	call   80106920 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 a0 e6 10 80       	push   $0x8010e6a0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 ff 54 00 00       	call   8010562b <sleep>
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
8010013a:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 b0 25 11 80       	mov    0x801125b0,%eax
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
80100183:	68 a0 e6 10 80       	push   $0x8010e6a0
80100188:	e8 93 67 00 00       	call   80106920 <release>
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
8010019e:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 b3 a0 10 80       	push   $0x8010a0b3
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
801001e2:	e8 40 2a 00 00       	call   80102c27 <iderw>
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
80100204:	68 c4 a0 10 80       	push   $0x8010a0c4
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
80100223:	e8 ff 29 00 00       	call   80102c27 <iderw>
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
80100243:	68 cb a0 10 80       	push   $0x8010a0cb
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 a0 e6 10 80       	push   $0x8010e6a0
80100255:	e8 5f 66 00 00       	call   801068b9 <acquire>
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
8010027b:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 b4 25 11 80       	mov    %eax,0x801125b4

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
801002b9:	e8 46 55 00 00       	call   80105804 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 a0 e6 10 80       	push   $0x8010e6a0
801002c9:	e8 52 66 00 00       	call   80106920 <release>
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
801003cc:	a1 34 d6 10 80       	mov    0x8010d634,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 00 d6 10 80       	push   $0x8010d600
801003e2:	e8 d2 64 00 00       	call   801068b9 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 d2 a0 10 80       	push   $0x8010a0d2
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
801004cd:	c7 45 ec db a0 10 80 	movl   $0x8010a0db,-0x14(%ebp)
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
80100556:	68 00 d6 10 80       	push   $0x8010d600
8010055b:	e8 c0 63 00 00       	call   80106920 <release>
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
80100571:	c7 05 34 d6 10 80 00 	movl   $0x0,0x8010d634
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 e2 a0 10 80       	push   $0x8010a0e2
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
801005aa:	68 f1 a0 10 80       	push   $0x8010a0f1
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 ab 63 00 00       	call   80106972 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 f3 a0 10 80       	push   $0x8010a0f3
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
801005f5:	c7 05 e0 d5 10 80 01 	movl   $0x1,0x8010d5e0
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
801006ca:	68 f7 a0 10 80       	push   $0x8010a0f7
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
801006f7:	e8 df 64 00 00       	call   80106bdb <memmove>
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
80100721:	e8 f6 63 00 00       	call   80106b1c <memset>
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
80100798:	a1 e0 d5 10 80       	mov    0x8010d5e0,%eax
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
801007b6:	e8 79 7f 00 00       	call   80108734 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 6c 7f 00 00       	call   80108734 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 5f 7f 00 00       	call   80108734 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 4f 7f 00 00       	call   80108734 <uartputc>
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
80100825:	68 00 d6 10 80       	push   $0x8010d600
8010082a:	e8 8a 60 00 00       	call   801068b9 <acquire>
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
8010089b:	a1 48 28 11 80       	mov    0x80112848,%eax
801008a0:	83 e8 01             	sub    $0x1,%eax
801008a3:	a3 48 28 11 80       	mov    %eax,0x80112848
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
801008b8:	8b 15 48 28 11 80    	mov    0x80112848,%edx
801008be:	a1 44 28 11 80       	mov    0x80112844,%eax
801008c3:	39 c2                	cmp    %eax,%edx
801008c5:	0f 84 12 01 00 00    	je     801009dd <consoleintr+0x1e4>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008cb:	a1 48 28 11 80       	mov    0x80112848,%eax
801008d0:	83 e8 01             	sub    $0x1,%eax
801008d3:	83 e0 7f             	and    $0x7f,%eax
801008d6:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
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
801008e6:	8b 15 48 28 11 80    	mov    0x80112848,%edx
801008ec:	a1 44 28 11 80       	mov    0x80112844,%eax
801008f1:	39 c2                	cmp    %eax,%edx
801008f3:	0f 84 e4 00 00 00    	je     801009dd <consoleintr+0x1e4>
        input.e--;
801008f9:	a1 48 28 11 80       	mov    0x80112848,%eax
801008fe:	83 e8 01             	sub    $0x1,%eax
80100901:	a3 48 28 11 80       	mov    %eax,0x80112848
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
80100955:	8b 15 48 28 11 80    	mov    0x80112848,%edx
8010095b:	a1 40 28 11 80       	mov    0x80112840,%eax
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
8010097c:	a1 48 28 11 80       	mov    0x80112848,%eax
80100981:	8d 50 01             	lea    0x1(%eax),%edx
80100984:	89 15 48 28 11 80    	mov    %edx,0x80112848
8010098a:	83 e0 7f             	and    $0x7f,%eax
8010098d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100990:	88 90 c0 27 11 80    	mov    %dl,-0x7feed840(%eax)
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
801009b0:	a1 48 28 11 80       	mov    0x80112848,%eax
801009b5:	8b 15 40 28 11 80    	mov    0x80112840,%edx
801009bb:	83 ea 80             	sub    $0xffffff80,%edx
801009be:	39 d0                	cmp    %edx,%eax
801009c0:	75 1a                	jne    801009dc <consoleintr+0x1e3>
          input.w = input.e;
801009c2:	a1 48 28 11 80       	mov    0x80112848,%eax
801009c7:	a3 44 28 11 80       	mov    %eax,0x80112844
          wakeup(&input.r);
801009cc:	83 ec 0c             	sub    $0xc,%esp
801009cf:	68 40 28 11 80       	push   $0x80112840
801009d4:	e8 2b 4e 00 00       	call   80105804 <wakeup>
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
801009f2:	68 00 d6 10 80       	push   $0x8010d600
801009f7:	e8 24 5f 00 00       	call   80106920 <release>
801009fc:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a03:	74 05                	je     80100a0a <consoleintr+0x211>
    procdump();  // now call procdump() wo. cons.lock held
80100a05:	e8 e9 4f 00 00       	call   801059f3 <procdump>
  }
  if (f) {
80100a0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a0e:	74 05                	je     80100a15 <consoleintr+0x21c>
    free_length();
80100a10:	e8 56 54 00 00       	call   80105e6b <free_length>
  }
  if (r) {
80100a15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a19:	74 05                	je     80100a20 <consoleintr+0x227>
    display_ready();
80100a1b:	e8 d7 54 00 00       	call   80105ef7 <display_ready>
  }
  if (s) {
80100a20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a24:	74 05                	je     80100a2b <consoleintr+0x232>
    display_sleep();
80100a26:	e8 bf 55 00 00       	call   80105fea <display_sleep>
  }
  if (z) {
80100a2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a2f:	74 05                	je     80100a36 <consoleintr+0x23d>
    display_zombie();
80100a31:	e8 6e 56 00 00       	call   801060a4 <display_zombie>
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
80100a45:	e8 23 12 00 00       	call   80101c6d <iunlock>
80100a4a:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a4d:	8b 45 10             	mov    0x10(%ebp),%eax
80100a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a53:	83 ec 0c             	sub    $0xc,%esp
80100a56:	68 00 d6 10 80       	push   $0x8010d600
80100a5b:	e8 59 5e 00 00       	call   801068b9 <acquire>
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
80100a78:	68 00 d6 10 80       	push   $0x8010d600
80100a7d:	e8 9e 5e 00 00       	call   80106920 <release>
80100a82:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a85:	83 ec 0c             	sub    $0xc,%esp
80100a88:	ff 75 08             	pushl  0x8(%ebp)
80100a8b:	e8 57 10 00 00       	call   80101ae7 <ilock>
80100a90:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a98:	e9 ab 00 00 00       	jmp    80100b48 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a9d:	83 ec 08             	sub    $0x8,%esp
80100aa0:	68 00 d6 10 80       	push   $0x8010d600
80100aa5:	68 40 28 11 80       	push   $0x80112840
80100aaa:	e8 7c 4b 00 00       	call   8010562b <sleep>
80100aaf:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100ab2:	8b 15 40 28 11 80    	mov    0x80112840,%edx
80100ab8:	a1 44 28 11 80       	mov    0x80112844,%eax
80100abd:	39 c2                	cmp    %eax,%edx
80100abf:	74 a7                	je     80100a68 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ac1:	a1 40 28 11 80       	mov    0x80112840,%eax
80100ac6:	8d 50 01             	lea    0x1(%eax),%edx
80100ac9:	89 15 40 28 11 80    	mov    %edx,0x80112840
80100acf:	83 e0 7f             	and    $0x7f,%eax
80100ad2:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
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
80100aed:	a1 40 28 11 80       	mov    0x80112840,%eax
80100af2:	83 e8 01             	sub    $0x1,%eax
80100af5:	a3 40 28 11 80       	mov    %eax,0x80112840
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
80100b23:	68 00 d6 10 80       	push   $0x8010d600
80100b28:	e8 f3 5d 00 00       	call   80106920 <release>
80100b2d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b30:	83 ec 0c             	sub    $0xc,%esp
80100b33:	ff 75 08             	pushl  0x8(%ebp)
80100b36:	e8 ac 0f 00 00       	call   80101ae7 <ilock>
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
80100b56:	e8 12 11 00 00       	call   80101c6d <iunlock>
80100b5b:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b5e:	83 ec 0c             	sub    $0xc,%esp
80100b61:	68 00 d6 10 80       	push   $0x8010d600
80100b66:	e8 4e 5d 00 00       	call   801068b9 <acquire>
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
80100ba3:	68 00 d6 10 80       	push   $0x8010d600
80100ba8:	e8 73 5d 00 00       	call   80106920 <release>
80100bad:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bb0:	83 ec 0c             	sub    $0xc,%esp
80100bb3:	ff 75 08             	pushl  0x8(%ebp)
80100bb6:	e8 2c 0f 00 00       	call   80101ae7 <ilock>
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
80100bcc:	68 0a a1 10 80       	push   $0x8010a10a
80100bd1:	68 00 d6 10 80       	push   $0x8010d600
80100bd6:	e8 bc 5c 00 00       	call   80106897 <initlock>
80100bdb:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bde:	c7 05 0c 32 11 80 4a 	movl   $0x80100b4a,0x8011320c
80100be5:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be8:	c7 05 08 32 11 80 39 	movl   $0x80100a39,0x80113208
80100bef:	0a 10 80 
  cons.locking = 1;
80100bf2:	c7 05 34 d6 10 80 01 	movl   $0x1,0x8010d634
80100bf9:	00 00 00 

  picenable(IRQ_KBD);
80100bfc:	83 ec 0c             	sub    $0xc,%esp
80100bff:	6a 01                	push   $0x1
80100c01:	e8 3f 36 00 00       	call   80104245 <picenable>
80100c06:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c09:	83 ec 08             	sub    $0x8,%esp
80100c0c:	6a 00                	push   $0x0
80100c0e:	6a 01                	push   $0x1
80100c10:	e8 df 21 00 00       	call   80102df4 <ioapicenable>
80100c15:	83 c4 10             	add    $0x10,%esp
}
80100c18:	90                   	nop
80100c19:	c9                   	leave  
80100c1a:	c3                   	ret    

80100c1b <exec>:
#include "elf.h"
#include "stat.h"

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
80100c24:	e8 3e 2c 00 00       	call   80103867 <begin_op>
  if((ip = namei(path)) == 0){
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	ff 75 08             	pushl  0x8(%ebp)
80100c2f:	e8 c1 1a 00 00       	call   801026f5 <namei>
80100c34:	83 c4 10             	add    $0x10,%esp
80100c37:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c3e:	75 0f                	jne    80100c4f <exec+0x34>
    end_op();
80100c40:	e8 ae 2c 00 00       	call   801038f3 <end_op>
    return -1;
80100c45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c4a:	e9 79 04 00 00       	jmp    801010c8 <exec+0x4ad>
  }
  ilock(ip);
80100c4f:	83 ec 0c             	sub    $0xc,%esp
80100c52:	ff 75 d8             	pushl  -0x28(%ebp)
80100c55:	e8 8d 0e 00 00       	call   80101ae7 <ilock>
80100c5a:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c5d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)


  #ifdef CS333_P5
  struct stat *statp = 0;
80100c64:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  stati(ip, statp);
80100c6b:	83 ec 08             	sub    $0x8,%esp
80100c6e:	ff 75 d0             	pushl  -0x30(%ebp)
80100c71:	ff 75 d8             	pushl  -0x28(%ebp)
80100c74:	e8 be 13 00 00       	call   80102037 <stati>
80100c79:	83 c4 10             	add    $0x10,%esp
  // Check to see if the calling routine has read access
  // before the read operation occurs
  if (proc->uid == statp->uid) {
80100c7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c82:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80100c88:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100c8b:	0f b7 40 0e          	movzwl 0xe(%eax),%eax
80100c8f:	0f b7 c0             	movzwl %ax,%eax
80100c92:	39 c2                	cmp    %eax,%edx
80100c94:	75 13                	jne    80100ca9 <exec+0x8e>
    if (!statp->mode.flags.u_x)
80100c96:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100c99:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80100c9d:	83 e0 40             	and    $0x40,%eax
80100ca0:	84 c0                	test   %al,%al
80100ca2:	75 44                	jne    80100ce8 <exec+0xcd>
      goto bad;
80100ca4:	e9 ed 03 00 00       	jmp    80101096 <exec+0x47b>
  } else if (proc->gid == statp->gid) {
80100ca9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100caf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80100cb5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100cb8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80100cbc:	0f b7 c0             	movzwl %ax,%eax
80100cbf:	39 c2                	cmp    %eax,%edx
80100cc1:	75 13                	jne    80100cd6 <exec+0xbb>
    if (!statp->mode.flags.g_x)
80100cc3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100cc6:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80100cca:	83 e0 08             	and    $0x8,%eax
80100ccd:	84 c0                	test   %al,%al
80100ccf:	75 17                	jne    80100ce8 <exec+0xcd>
      goto bad;
80100cd1:	e9 c0 03 00 00       	jmp    80101096 <exec+0x47b>
  } else {
    if (!statp->mode.flags.o_x)
80100cd6:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100cd9:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80100cdd:	83 e0 01             	and    $0x1,%eax
80100ce0:	84 c0                	test   %al,%al
80100ce2:	0f 84 8c 03 00 00    	je     80101074 <exec+0x459>
      goto bad;
  }
  #endif

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100ce8:	6a 34                	push   $0x34
80100cea:	6a 00                	push   $0x0
80100cec:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100cf2:	50                   	push   %eax
80100cf3:	ff 75 d8             	pushl  -0x28(%ebp)
80100cf6:	e8 aa 13 00 00       	call   801020a5 <readi>
80100cfb:	83 c4 10             	add    $0x10,%esp
80100cfe:	83 f8 33             	cmp    $0x33,%eax
80100d01:	0f 86 70 03 00 00    	jbe    80101077 <exec+0x45c>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100d07:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100d0d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100d12:	0f 85 62 03 00 00    	jne    8010107a <exec+0x45f>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100d18:	e8 6c 8b 00 00       	call   80109889 <setupkvm>
80100d1d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100d20:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100d24:	0f 84 53 03 00 00    	je     8010107d <exec+0x462>
    goto bad;

  // Load program into memory.
  sz = 0;
80100d2a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100d38:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100d3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d41:	e9 ab 00 00 00       	jmp    80100df1 <exec+0x1d6>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d46:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d49:	6a 20                	push   $0x20
80100d4b:	50                   	push   %eax
80100d4c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100d52:	50                   	push   %eax
80100d53:	ff 75 d8             	pushl  -0x28(%ebp)
80100d56:	e8 4a 13 00 00       	call   801020a5 <readi>
80100d5b:	83 c4 10             	add    $0x10,%esp
80100d5e:	83 f8 20             	cmp    $0x20,%eax
80100d61:	0f 85 19 03 00 00    	jne    80101080 <exec+0x465>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100d67:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100d6d:	83 f8 01             	cmp    $0x1,%eax
80100d70:	75 71                	jne    80100de3 <exec+0x1c8>
      continue;
    if(ph.memsz < ph.filesz)
80100d72:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d78:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100d7e:	39 c2                	cmp    %eax,%edx
80100d80:	0f 82 fd 02 00 00    	jb     80101083 <exec+0x468>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d86:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d8c:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d92:	01 d0                	add    %edx,%eax
80100d94:	83 ec 04             	sub    $0x4,%esp
80100d97:	50                   	push   %eax
80100d98:	ff 75 e0             	pushl  -0x20(%ebp)
80100d9b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d9e:	e8 8d 8e 00 00       	call   80109c30 <allocuvm>
80100da3:	83 c4 10             	add    $0x10,%esp
80100da6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100da9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dad:	0f 84 d3 02 00 00    	je     80101086 <exec+0x46b>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100db3:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100db9:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100dbf:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100dc5:	83 ec 0c             	sub    $0xc,%esp
80100dc8:	52                   	push   %edx
80100dc9:	50                   	push   %eax
80100dca:	ff 75 d8             	pushl  -0x28(%ebp)
80100dcd:	51                   	push   %ecx
80100dce:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dd1:	e8 83 8d 00 00       	call   80109b59 <loaduvm>
80100dd6:	83 c4 20             	add    $0x20,%esp
80100dd9:	85 c0                	test   %eax,%eax
80100ddb:	0f 88 a8 02 00 00    	js     80101089 <exec+0x46e>
80100de1:	eb 01                	jmp    80100de4 <exec+0x1c9>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100de3:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100deb:	83 c0 20             	add    $0x20,%eax
80100dee:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100df1:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100df8:	0f b7 c0             	movzwl %ax,%eax
80100dfb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100dfe:	0f 8f 42 ff ff ff    	jg     80100d46 <exec+0x12b>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100e04:	83 ec 0c             	sub    $0xc,%esp
80100e07:	ff 75 d8             	pushl  -0x28(%ebp)
80100e0a:	e8 c0 0f 00 00       	call   80101dcf <iunlockput>
80100e0f:	83 c4 10             	add    $0x10,%esp
  end_op();
80100e12:	e8 dc 2a 00 00       	call   801038f3 <end_op>
  ip = 0;
80100e17:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100e1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e21:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e31:	05 00 20 00 00       	add    $0x2000,%eax
80100e36:	83 ec 04             	sub    $0x4,%esp
80100e39:	50                   	push   %eax
80100e3a:	ff 75 e0             	pushl  -0x20(%ebp)
80100e3d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e40:	e8 eb 8d 00 00       	call   80109c30 <allocuvm>
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e4b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e4f:	0f 84 37 02 00 00    	je     8010108c <exec+0x471>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e58:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e5d:	83 ec 08             	sub    $0x8,%esp
80100e60:	50                   	push   %eax
80100e61:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e64:	e8 ed 8f 00 00       	call   80109e56 <clearpteu>
80100e69:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100e6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e6f:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e72:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e79:	e9 96 00 00 00       	jmp    80100f14 <exec+0x2f9>
    if(argc >= MAXARG)
80100e7e:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e82:	0f 87 07 02 00 00    	ja     8010108f <exec+0x474>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e92:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e95:	01 d0                	add    %edx,%eax
80100e97:	8b 00                	mov    (%eax),%eax
80100e99:	83 ec 0c             	sub    $0xc,%esp
80100e9c:	50                   	push   %eax
80100e9d:	e8 c7 5e 00 00       	call   80106d69 <strlen>
80100ea2:	83 c4 10             	add    $0x10,%esp
80100ea5:	89 c2                	mov    %eax,%edx
80100ea7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100eaa:	29 d0                	sub    %edx,%eax
80100eac:	83 e8 01             	sub    $0x1,%eax
80100eaf:	83 e0 fc             	and    $0xfffffffc,%eax
80100eb2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100eb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ec2:	01 d0                	add    %edx,%eax
80100ec4:	8b 00                	mov    (%eax),%eax
80100ec6:	83 ec 0c             	sub    $0xc,%esp
80100ec9:	50                   	push   %eax
80100eca:	e8 9a 5e 00 00       	call   80106d69 <strlen>
80100ecf:	83 c4 10             	add    $0x10,%esp
80100ed2:	83 c0 01             	add    $0x1,%eax
80100ed5:	89 c1                	mov    %eax,%ecx
80100ed7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ee4:	01 d0                	add    %edx,%eax
80100ee6:	8b 00                	mov    (%eax),%eax
80100ee8:	51                   	push   %ecx
80100ee9:	50                   	push   %eax
80100eea:	ff 75 dc             	pushl  -0x24(%ebp)
80100eed:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ef0:	e8 18 91 00 00       	call   8010a00d <copyout>
80100ef5:	83 c4 10             	add    $0x10,%esp
80100ef8:	85 c0                	test   %eax,%eax
80100efa:	0f 88 92 01 00 00    	js     80101092 <exec+0x477>
      goto bad;
    ustack[3+argc] = sp;
80100f00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f03:	8d 50 03             	lea    0x3(%eax),%edx
80100f06:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f09:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f10:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f21:	01 d0                	add    %edx,%eax
80100f23:	8b 00                	mov    (%eax),%eax
80100f25:	85 c0                	test   %eax,%eax
80100f27:	0f 85 51 ff ff ff    	jne    80100e7e <exec+0x263>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f30:	83 c0 03             	add    $0x3,%eax
80100f33:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100f3a:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f3e:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100f45:	ff ff ff 
  ustack[1] = argc;
80100f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f4b:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f54:	83 c0 01             	add    $0x1,%eax
80100f57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f61:	29 d0                	sub    %edx,%eax
80100f63:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f6c:	83 c0 04             	add    $0x4,%eax
80100f6f:	c1 e0 02             	shl    $0x2,%eax
80100f72:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f78:	83 c0 04             	add    $0x4,%eax
80100f7b:	c1 e0 02             	shl    $0x2,%eax
80100f7e:	50                   	push   %eax
80100f7f:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100f85:	50                   	push   %eax
80100f86:	ff 75 dc             	pushl  -0x24(%ebp)
80100f89:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f8c:	e8 7c 90 00 00       	call   8010a00d <copyout>
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	85 c0                	test   %eax,%eax
80100f96:	0f 88 f9 00 00 00    	js     80101095 <exec+0x47a>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f9c:	8b 45 08             	mov    0x8(%ebp),%eax
80100f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100fa8:	eb 17                	jmp    80100fc1 <exec+0x3a6>
    if(*s == '/')
80100faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fad:	0f b6 00             	movzbl (%eax),%eax
80100fb0:	3c 2f                	cmp    $0x2f,%al
80100fb2:	75 09                	jne    80100fbd <exec+0x3a2>
      last = s+1;
80100fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb7:	83 c0 01             	add    $0x1,%eax
80100fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100fbd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc4:	0f b6 00             	movzbl (%eax),%eax
80100fc7:	84 c0                	test   %al,%al
80100fc9:	75 df                	jne    80100faa <exec+0x38f>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100fcb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fd1:	83 c0 6c             	add    $0x6c,%eax
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	6a 10                	push   $0x10
80100fd9:	ff 75 f0             	pushl  -0x10(%ebp)
80100fdc:	50                   	push   %eax
80100fdd:	e8 3d 5d 00 00       	call   80106d1f <safestrcpy>
80100fe2:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100fe5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100feb:	8b 40 04             	mov    0x4(%eax),%eax
80100fee:	89 45 cc             	mov    %eax,-0x34(%ebp)
  proc->pgdir = pgdir;
80100ff1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ff7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ffa:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ffd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101003:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101006:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80101008:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010100e:	8b 40 18             	mov    0x18(%eax),%eax
80101011:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80101017:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
8010101a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101020:	8b 40 18             	mov    0x18(%eax),%eax
80101023:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101026:	89 50 44             	mov    %edx,0x44(%eax)
  #ifdef CS333_P5
  // Process is allowed to be executed so set proc->uid to ip->uid
  if (statp->mode.flags.setuid)
80101029:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010102c:	0f b6 40 15          	movzbl 0x15(%eax),%eax
80101030:	83 e0 02             	and    $0x2,%eax
80101033:	84 c0                	test   %al,%al
80101035:	74 16                	je     8010104d <exec+0x432>
    proc->uid = statp->uid;
80101037:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010103d:	8b 55 d0             	mov    -0x30(%ebp),%edx
80101040:	0f b7 52 0e          	movzwl 0xe(%edx),%edx
80101044:	0f b7 d2             	movzwl %dx,%edx
80101047:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  #endif
  switchuvm(proc);
8010104d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101053:	83 ec 0c             	sub    $0xc,%esp
80101056:	50                   	push   %eax
80101057:	e8 14 89 00 00       	call   80109970 <switchuvm>
8010105c:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	ff 75 cc             	pushl  -0x34(%ebp)
80101065:	e8 4c 8d 00 00       	call   80109db6 <freevm>
8010106a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010106d:	b8 00 00 00 00       	mov    $0x0,%eax
80101072:	eb 54                	jmp    801010c8 <exec+0x4ad>
  } else if (proc->gid == statp->gid) {
    if (!statp->mode.flags.g_x)
      goto bad;
  } else {
    if (!statp->mode.flags.o_x)
      goto bad;
80101074:	90                   	nop
80101075:	eb 1f                	jmp    80101096 <exec+0x47b>
  }
  #endif

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80101077:	90                   	nop
80101078:	eb 1c                	jmp    80101096 <exec+0x47b>
  if(elf.magic != ELF_MAGIC)
    goto bad;
8010107a:	90                   	nop
8010107b:	eb 19                	jmp    80101096 <exec+0x47b>

  if((pgdir = setupkvm()) == 0)
    goto bad;
8010107d:	90                   	nop
8010107e:	eb 16                	jmp    80101096 <exec+0x47b>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80101080:	90                   	nop
80101081:	eb 13                	jmp    80101096 <exec+0x47b>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80101083:	90                   	nop
80101084:	eb 10                	jmp    80101096 <exec+0x47b>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80101086:	90                   	nop
80101087:	eb 0d                	jmp    80101096 <exec+0x47b>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80101089:	90                   	nop
8010108a:	eb 0a                	jmp    80101096 <exec+0x47b>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
8010108c:	90                   	nop
8010108d:	eb 07                	jmp    80101096 <exec+0x47b>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
8010108f:	90                   	nop
80101090:	eb 04                	jmp    80101096 <exec+0x47b>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80101092:	90                   	nop
80101093:	eb 01                	jmp    80101096 <exec+0x47b>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80101095:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80101096:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010109a:	74 0e                	je     801010aa <exec+0x48f>
    freevm(pgdir);
8010109c:	83 ec 0c             	sub    $0xc,%esp
8010109f:	ff 75 d4             	pushl  -0x2c(%ebp)
801010a2:	e8 0f 8d 00 00       	call   80109db6 <freevm>
801010a7:	83 c4 10             	add    $0x10,%esp
  if(ip){
801010aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801010ae:	74 13                	je     801010c3 <exec+0x4a8>
    iunlockput(ip);
801010b0:	83 ec 0c             	sub    $0xc,%esp
801010b3:	ff 75 d8             	pushl  -0x28(%ebp)
801010b6:	e8 14 0d 00 00       	call   80101dcf <iunlockput>
801010bb:	83 c4 10             	add    $0x10,%esp
    end_op();
801010be:	e8 30 28 00 00       	call   801038f3 <end_op>
  }
  return -1;
801010c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010c8:	c9                   	leave  
801010c9:	c3                   	ret    

801010ca <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010ca:	55                   	push   %ebp
801010cb:	89 e5                	mov    %esp,%ebp
801010cd:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
801010d0:	83 ec 08             	sub    $0x8,%esp
801010d3:	68 12 a1 10 80       	push   $0x8010a112
801010d8:	68 60 28 11 80       	push   $0x80112860
801010dd:	e8 b5 57 00 00       	call   80106897 <initlock>
801010e2:	83 c4 10             	add    $0x10,%esp
}
801010e5:	90                   	nop
801010e6:	c9                   	leave  
801010e7:	c3                   	ret    

801010e8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010e8:	55                   	push   %ebp
801010e9:	89 e5                	mov    %esp,%ebp
801010eb:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 60 28 11 80       	push   $0x80112860
801010f6:	e8 be 57 00 00       	call   801068b9 <acquire>
801010fb:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010fe:	c7 45 f4 94 28 11 80 	movl   $0x80112894,-0xc(%ebp)
80101105:	eb 2d                	jmp    80101134 <filealloc+0x4c>
    if(f->ref == 0){
80101107:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010110a:	8b 40 04             	mov    0x4(%eax),%eax
8010110d:	85 c0                	test   %eax,%eax
8010110f:	75 1f                	jne    80101130 <filealloc+0x48>
      f->ref = 1;
80101111:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101114:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	68 60 28 11 80       	push   $0x80112860
80101123:	e8 f8 57 00 00       	call   80106920 <release>
80101128:	83 c4 10             	add    $0x10,%esp
      return f;
8010112b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010112e:	eb 23                	jmp    80101153 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101130:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101134:	b8 f4 31 11 80       	mov    $0x801131f4,%eax
80101139:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010113c:	72 c9                	jb     80101107 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010113e:	83 ec 0c             	sub    $0xc,%esp
80101141:	68 60 28 11 80       	push   $0x80112860
80101146:	e8 d5 57 00 00       	call   80106920 <release>
8010114b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010114e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101153:	c9                   	leave  
80101154:	c3                   	ret    

80101155 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101155:	55                   	push   %ebp
80101156:	89 e5                	mov    %esp,%ebp
80101158:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	68 60 28 11 80       	push   $0x80112860
80101163:	e8 51 57 00 00       	call   801068b9 <acquire>
80101168:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010116b:	8b 45 08             	mov    0x8(%ebp),%eax
8010116e:	8b 40 04             	mov    0x4(%eax),%eax
80101171:	85 c0                	test   %eax,%eax
80101173:	7f 0d                	jg     80101182 <filedup+0x2d>
    panic("filedup");
80101175:	83 ec 0c             	sub    $0xc,%esp
80101178:	68 19 a1 10 80       	push   $0x8010a119
8010117d:	e8 e4 f3 ff ff       	call   80100566 <panic>
  f->ref++;
80101182:	8b 45 08             	mov    0x8(%ebp),%eax
80101185:	8b 40 04             	mov    0x4(%eax),%eax
80101188:	8d 50 01             	lea    0x1(%eax),%edx
8010118b:	8b 45 08             	mov    0x8(%ebp),%eax
8010118e:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	68 60 28 11 80       	push   $0x80112860
80101199:	e8 82 57 00 00       	call   80106920 <release>
8010119e:	83 c4 10             	add    $0x10,%esp
  return f;
801011a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801011a4:	c9                   	leave  
801011a5:	c3                   	ret    

801011a6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011a6:	55                   	push   %ebp
801011a7:	89 e5                	mov    %esp,%ebp
801011a9:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801011ac:	83 ec 0c             	sub    $0xc,%esp
801011af:	68 60 28 11 80       	push   $0x80112860
801011b4:	e8 00 57 00 00       	call   801068b9 <acquire>
801011b9:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011bc:	8b 45 08             	mov    0x8(%ebp),%eax
801011bf:	8b 40 04             	mov    0x4(%eax),%eax
801011c2:	85 c0                	test   %eax,%eax
801011c4:	7f 0d                	jg     801011d3 <fileclose+0x2d>
    panic("fileclose");
801011c6:	83 ec 0c             	sub    $0xc,%esp
801011c9:	68 21 a1 10 80       	push   $0x8010a121
801011ce:	e8 93 f3 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
801011d3:	8b 45 08             	mov    0x8(%ebp),%eax
801011d6:	8b 40 04             	mov    0x4(%eax),%eax
801011d9:	8d 50 ff             	lea    -0x1(%eax),%edx
801011dc:	8b 45 08             	mov    0x8(%ebp),%eax
801011df:	89 50 04             	mov    %edx,0x4(%eax)
801011e2:	8b 45 08             	mov    0x8(%ebp),%eax
801011e5:	8b 40 04             	mov    0x4(%eax),%eax
801011e8:	85 c0                	test   %eax,%eax
801011ea:	7e 15                	jle    80101201 <fileclose+0x5b>
    release(&ftable.lock);
801011ec:	83 ec 0c             	sub    $0xc,%esp
801011ef:	68 60 28 11 80       	push   $0x80112860
801011f4:	e8 27 57 00 00       	call   80106920 <release>
801011f9:	83 c4 10             	add    $0x10,%esp
801011fc:	e9 8b 00 00 00       	jmp    8010128c <fileclose+0xe6>
    return;
  }
  ff = *f;
80101201:	8b 45 08             	mov    0x8(%ebp),%eax
80101204:	8b 10                	mov    (%eax),%edx
80101206:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101209:	8b 50 04             	mov    0x4(%eax),%edx
8010120c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010120f:	8b 50 08             	mov    0x8(%eax),%edx
80101212:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101215:	8b 50 0c             	mov    0xc(%eax),%edx
80101218:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010121b:	8b 50 10             	mov    0x10(%eax),%edx
8010121e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101221:	8b 40 14             	mov    0x14(%eax),%eax
80101224:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101227:	8b 45 08             	mov    0x8(%ebp),%eax
8010122a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101231:	8b 45 08             	mov    0x8(%ebp),%eax
80101234:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010123a:	83 ec 0c             	sub    $0xc,%esp
8010123d:	68 60 28 11 80       	push   $0x80112860
80101242:	e8 d9 56 00 00       	call   80106920 <release>
80101247:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
8010124a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010124d:	83 f8 01             	cmp    $0x1,%eax
80101250:	75 19                	jne    8010126b <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101252:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101256:	0f be d0             	movsbl %al,%edx
80101259:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010125c:	83 ec 08             	sub    $0x8,%esp
8010125f:	52                   	push   %edx
80101260:	50                   	push   %eax
80101261:	e8 48 32 00 00       	call   801044ae <pipeclose>
80101266:	83 c4 10             	add    $0x10,%esp
80101269:	eb 21                	jmp    8010128c <fileclose+0xe6>
  else if(ff.type == FD_INODE){
8010126b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010126e:	83 f8 02             	cmp    $0x2,%eax
80101271:	75 19                	jne    8010128c <fileclose+0xe6>
    begin_op();
80101273:	e8 ef 25 00 00       	call   80103867 <begin_op>
    iput(ff.ip);
80101278:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010127b:	83 ec 0c             	sub    $0xc,%esp
8010127e:	50                   	push   %eax
8010127f:	e8 5b 0a 00 00       	call   80101cdf <iput>
80101284:	83 c4 10             	add    $0x10,%esp
    end_op();
80101287:	e8 67 26 00 00       	call   801038f3 <end_op>
  }
}
8010128c:	c9                   	leave  
8010128d:	c3                   	ret    

8010128e <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010128e:	55                   	push   %ebp
8010128f:	89 e5                	mov    %esp,%ebp
80101291:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101294:	8b 45 08             	mov    0x8(%ebp),%eax
80101297:	8b 00                	mov    (%eax),%eax
80101299:	83 f8 02             	cmp    $0x2,%eax
8010129c:	75 40                	jne    801012de <filestat+0x50>
    ilock(f->ip);
8010129e:	8b 45 08             	mov    0x8(%ebp),%eax
801012a1:	8b 40 10             	mov    0x10(%eax),%eax
801012a4:	83 ec 0c             	sub    $0xc,%esp
801012a7:	50                   	push   %eax
801012a8:	e8 3a 08 00 00       	call   80101ae7 <ilock>
801012ad:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801012b0:	8b 45 08             	mov    0x8(%ebp),%eax
801012b3:	8b 40 10             	mov    0x10(%eax),%eax
801012b6:	83 ec 08             	sub    $0x8,%esp
801012b9:	ff 75 0c             	pushl  0xc(%ebp)
801012bc:	50                   	push   %eax
801012bd:	e8 75 0d 00 00       	call   80102037 <stati>
801012c2:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801012c5:	8b 45 08             	mov    0x8(%ebp),%eax
801012c8:	8b 40 10             	mov    0x10(%eax),%eax
801012cb:	83 ec 0c             	sub    $0xc,%esp
801012ce:	50                   	push   %eax
801012cf:	e8 99 09 00 00       	call   80101c6d <iunlock>
801012d4:	83 c4 10             	add    $0x10,%esp
    return 0;
801012d7:	b8 00 00 00 00       	mov    $0x0,%eax
801012dc:	eb 05                	jmp    801012e3 <filestat+0x55>
  }
  return -1;
801012de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012e3:	c9                   	leave  
801012e4:	c3                   	ret    

801012e5 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012e5:	55                   	push   %ebp
801012e6:	89 e5                	mov    %esp,%ebp
801012e8:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801012f2:	84 c0                	test   %al,%al
801012f4:	75 0a                	jne    80101300 <fileread+0x1b>
    return -1;
801012f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012fb:	e9 9b 00 00 00       	jmp    8010139b <fileread+0xb6>
  if(f->type == FD_PIPE)
80101300:	8b 45 08             	mov    0x8(%ebp),%eax
80101303:	8b 00                	mov    (%eax),%eax
80101305:	83 f8 01             	cmp    $0x1,%eax
80101308:	75 1a                	jne    80101324 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010130a:	8b 45 08             	mov    0x8(%ebp),%eax
8010130d:	8b 40 0c             	mov    0xc(%eax),%eax
80101310:	83 ec 04             	sub    $0x4,%esp
80101313:	ff 75 10             	pushl  0x10(%ebp)
80101316:	ff 75 0c             	pushl  0xc(%ebp)
80101319:	50                   	push   %eax
8010131a:	e8 37 33 00 00       	call   80104656 <piperead>
8010131f:	83 c4 10             	add    $0x10,%esp
80101322:	eb 77                	jmp    8010139b <fileread+0xb6>
  if(f->type == FD_INODE){
80101324:	8b 45 08             	mov    0x8(%ebp),%eax
80101327:	8b 00                	mov    (%eax),%eax
80101329:	83 f8 02             	cmp    $0x2,%eax
8010132c:	75 60                	jne    8010138e <fileread+0xa9>
    ilock(f->ip);
8010132e:	8b 45 08             	mov    0x8(%ebp),%eax
80101331:	8b 40 10             	mov    0x10(%eax),%eax
80101334:	83 ec 0c             	sub    $0xc,%esp
80101337:	50                   	push   %eax
80101338:	e8 aa 07 00 00       	call   80101ae7 <ilock>
8010133d:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101340:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101343:	8b 45 08             	mov    0x8(%ebp),%eax
80101346:	8b 50 14             	mov    0x14(%eax),%edx
80101349:	8b 45 08             	mov    0x8(%ebp),%eax
8010134c:	8b 40 10             	mov    0x10(%eax),%eax
8010134f:	51                   	push   %ecx
80101350:	52                   	push   %edx
80101351:	ff 75 0c             	pushl  0xc(%ebp)
80101354:	50                   	push   %eax
80101355:	e8 4b 0d 00 00       	call   801020a5 <readi>
8010135a:	83 c4 10             	add    $0x10,%esp
8010135d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101364:	7e 11                	jle    80101377 <fileread+0x92>
      f->off += r;
80101366:	8b 45 08             	mov    0x8(%ebp),%eax
80101369:	8b 50 14             	mov    0x14(%eax),%edx
8010136c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136f:	01 c2                	add    %eax,%edx
80101371:	8b 45 08             	mov    0x8(%ebp),%eax
80101374:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101377:	8b 45 08             	mov    0x8(%ebp),%eax
8010137a:	8b 40 10             	mov    0x10(%eax),%eax
8010137d:	83 ec 0c             	sub    $0xc,%esp
80101380:	50                   	push   %eax
80101381:	e8 e7 08 00 00       	call   80101c6d <iunlock>
80101386:	83 c4 10             	add    $0x10,%esp
    return r;
80101389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138c:	eb 0d                	jmp    8010139b <fileread+0xb6>
  }
  panic("fileread");
8010138e:	83 ec 0c             	sub    $0xc,%esp
80101391:	68 2b a1 10 80       	push   $0x8010a12b
80101396:	e8 cb f1 ff ff       	call   80100566 <panic>
}
8010139b:	c9                   	leave  
8010139c:	c3                   	ret    

8010139d <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010139d:	55                   	push   %ebp
8010139e:	89 e5                	mov    %esp,%ebp
801013a0:	53                   	push   %ebx
801013a1:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801013a4:	8b 45 08             	mov    0x8(%ebp),%eax
801013a7:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801013ab:	84 c0                	test   %al,%al
801013ad:	75 0a                	jne    801013b9 <filewrite+0x1c>
    return -1;
801013af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013b4:	e9 1b 01 00 00       	jmp    801014d4 <filewrite+0x137>
  if(f->type == FD_PIPE)
801013b9:	8b 45 08             	mov    0x8(%ebp),%eax
801013bc:	8b 00                	mov    (%eax),%eax
801013be:	83 f8 01             	cmp    $0x1,%eax
801013c1:	75 1d                	jne    801013e0 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801013c3:	8b 45 08             	mov    0x8(%ebp),%eax
801013c6:	8b 40 0c             	mov    0xc(%eax),%eax
801013c9:	83 ec 04             	sub    $0x4,%esp
801013cc:	ff 75 10             	pushl  0x10(%ebp)
801013cf:	ff 75 0c             	pushl  0xc(%ebp)
801013d2:	50                   	push   %eax
801013d3:	e8 80 31 00 00       	call   80104558 <pipewrite>
801013d8:	83 c4 10             	add    $0x10,%esp
801013db:	e9 f4 00 00 00       	jmp    801014d4 <filewrite+0x137>
  if(f->type == FD_INODE){
801013e0:	8b 45 08             	mov    0x8(%ebp),%eax
801013e3:	8b 00                	mov    (%eax),%eax
801013e5:	83 f8 02             	cmp    $0x2,%eax
801013e8:	0f 85 d9 00 00 00    	jne    801014c7 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801013ee:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801013f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801013fc:	e9 a3 00 00 00       	jmp    801014a4 <filewrite+0x107>
      int n1 = n - i;
80101401:	8b 45 10             	mov    0x10(%ebp),%eax
80101404:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101407:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010140a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010140d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101410:	7e 06                	jle    80101418 <filewrite+0x7b>
        n1 = max;
80101412:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101415:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101418:	e8 4a 24 00 00       	call   80103867 <begin_op>
      ilock(f->ip);
8010141d:	8b 45 08             	mov    0x8(%ebp),%eax
80101420:	8b 40 10             	mov    0x10(%eax),%eax
80101423:	83 ec 0c             	sub    $0xc,%esp
80101426:	50                   	push   %eax
80101427:	e8 bb 06 00 00       	call   80101ae7 <ilock>
8010142c:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010142f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101432:	8b 45 08             	mov    0x8(%ebp),%eax
80101435:	8b 50 14             	mov    0x14(%eax),%edx
80101438:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010143b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010143e:	01 c3                	add    %eax,%ebx
80101440:	8b 45 08             	mov    0x8(%ebp),%eax
80101443:	8b 40 10             	mov    0x10(%eax),%eax
80101446:	51                   	push   %ecx
80101447:	52                   	push   %edx
80101448:	53                   	push   %ebx
80101449:	50                   	push   %eax
8010144a:	e8 ad 0d 00 00       	call   801021fc <writei>
8010144f:	83 c4 10             	add    $0x10,%esp
80101452:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101455:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101459:	7e 11                	jle    8010146c <filewrite+0xcf>
        f->off += r;
8010145b:	8b 45 08             	mov    0x8(%ebp),%eax
8010145e:	8b 50 14             	mov    0x14(%eax),%edx
80101461:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101464:	01 c2                	add    %eax,%edx
80101466:	8b 45 08             	mov    0x8(%ebp),%eax
80101469:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010146c:	8b 45 08             	mov    0x8(%ebp),%eax
8010146f:	8b 40 10             	mov    0x10(%eax),%eax
80101472:	83 ec 0c             	sub    $0xc,%esp
80101475:	50                   	push   %eax
80101476:	e8 f2 07 00 00       	call   80101c6d <iunlock>
8010147b:	83 c4 10             	add    $0x10,%esp
      end_op();
8010147e:	e8 70 24 00 00       	call   801038f3 <end_op>

      if(r < 0)
80101483:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101487:	78 29                	js     801014b2 <filewrite+0x115>
        break;
      if(r != n1)
80101489:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010148c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010148f:	74 0d                	je     8010149e <filewrite+0x101>
        panic("short filewrite");
80101491:	83 ec 0c             	sub    $0xc,%esp
80101494:	68 34 a1 10 80       	push   $0x8010a134
80101499:	e8 c8 f0 ff ff       	call   80100566 <panic>
      i += r;
8010149e:	8b 45 e8             	mov    -0x18(%ebp),%eax
801014a1:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801014a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014a7:	3b 45 10             	cmp    0x10(%ebp),%eax
801014aa:	0f 8c 51 ff ff ff    	jl     80101401 <filewrite+0x64>
801014b0:	eb 01                	jmp    801014b3 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801014b2:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014b6:	3b 45 10             	cmp    0x10(%ebp),%eax
801014b9:	75 05                	jne    801014c0 <filewrite+0x123>
801014bb:	8b 45 10             	mov    0x10(%ebp),%eax
801014be:	eb 14                	jmp    801014d4 <filewrite+0x137>
801014c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014c5:	eb 0d                	jmp    801014d4 <filewrite+0x137>
  }
  panic("filewrite");
801014c7:	83 ec 0c             	sub    $0xc,%esp
801014ca:	68 44 a1 10 80       	push   $0x8010a144
801014cf:	e8 92 f0 ff ff       	call   80100566 <panic>
}
801014d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014d7:	c9                   	leave  
801014d8:	c3                   	ret    

801014d9 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014d9:	55                   	push   %ebp
801014da:	89 e5                	mov    %esp,%ebp
801014dc:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801014df:	8b 45 08             	mov    0x8(%ebp),%eax
801014e2:	83 ec 08             	sub    $0x8,%esp
801014e5:	6a 01                	push   $0x1
801014e7:	50                   	push   %eax
801014e8:	e8 c9 ec ff ff       	call   801001b6 <bread>
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801014f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014f6:	83 c0 18             	add    $0x18,%eax
801014f9:	83 ec 04             	sub    $0x4,%esp
801014fc:	6a 1c                	push   $0x1c
801014fe:	50                   	push   %eax
801014ff:	ff 75 0c             	pushl  0xc(%ebp)
80101502:	e8 d4 56 00 00       	call   80106bdb <memmove>
80101507:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010150a:	83 ec 0c             	sub    $0xc,%esp
8010150d:	ff 75 f4             	pushl  -0xc(%ebp)
80101510:	e8 19 ed ff ff       	call   8010022e <brelse>
80101515:	83 c4 10             	add    $0x10,%esp
}
80101518:	90                   	nop
80101519:	c9                   	leave  
8010151a:	c3                   	ret    

8010151b <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010151b:	55                   	push   %ebp
8010151c:	89 e5                	mov    %esp,%ebp
8010151e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101521:	8b 55 0c             	mov    0xc(%ebp),%edx
80101524:	8b 45 08             	mov    0x8(%ebp),%eax
80101527:	83 ec 08             	sub    $0x8,%esp
8010152a:	52                   	push   %edx
8010152b:	50                   	push   %eax
8010152c:	e8 85 ec ff ff       	call   801001b6 <bread>
80101531:	83 c4 10             	add    $0x10,%esp
80101534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010153a:	83 c0 18             	add    $0x18,%eax
8010153d:	83 ec 04             	sub    $0x4,%esp
80101540:	68 00 02 00 00       	push   $0x200
80101545:	6a 00                	push   $0x0
80101547:	50                   	push   %eax
80101548:	e8 cf 55 00 00       	call   80106b1c <memset>
8010154d:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
80101553:	ff 75 f4             	pushl  -0xc(%ebp)
80101556:	e8 44 25 00 00       	call   80103a9f <log_write>
8010155b:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010155e:	83 ec 0c             	sub    $0xc,%esp
80101561:	ff 75 f4             	pushl  -0xc(%ebp)
80101564:	e8 c5 ec ff ff       	call   8010022e <brelse>
80101569:	83 c4 10             	add    $0x10,%esp
}
8010156c:	90                   	nop
8010156d:	c9                   	leave  
8010156e:	c3                   	ret    

8010156f <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010156f:	55                   	push   %ebp
80101570:	89 e5                	mov    %esp,%ebp
80101572:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101575:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010157c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101583:	e9 13 01 00 00       	jmp    8010169b <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010158b:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101591:	85 c0                	test   %eax,%eax
80101593:	0f 48 c2             	cmovs  %edx,%eax
80101596:	c1 f8 0c             	sar    $0xc,%eax
80101599:	89 c2                	mov    %eax,%edx
8010159b:	a1 78 32 11 80       	mov    0x80113278,%eax
801015a0:	01 d0                	add    %edx,%eax
801015a2:	83 ec 08             	sub    $0x8,%esp
801015a5:	50                   	push   %eax
801015a6:	ff 75 08             	pushl  0x8(%ebp)
801015a9:	e8 08 ec ff ff       	call   801001b6 <bread>
801015ae:	83 c4 10             	add    $0x10,%esp
801015b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801015bb:	e9 a6 00 00 00       	jmp    80101666 <balloc+0xf7>
      m = 1 << (bi % 8);
801015c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c3:	99                   	cltd   
801015c4:	c1 ea 1d             	shr    $0x1d,%edx
801015c7:	01 d0                	add    %edx,%eax
801015c9:	83 e0 07             	and    $0x7,%eax
801015cc:	29 d0                	sub    %edx,%eax
801015ce:	ba 01 00 00 00       	mov    $0x1,%edx
801015d3:	89 c1                	mov    %eax,%ecx
801015d5:	d3 e2                	shl    %cl,%edx
801015d7:	89 d0                	mov    %edx,%eax
801015d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015df:	8d 50 07             	lea    0x7(%eax),%edx
801015e2:	85 c0                	test   %eax,%eax
801015e4:	0f 48 c2             	cmovs  %edx,%eax
801015e7:	c1 f8 03             	sar    $0x3,%eax
801015ea:	89 c2                	mov    %eax,%edx
801015ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015ef:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015f4:	0f b6 c0             	movzbl %al,%eax
801015f7:	23 45 e8             	and    -0x18(%ebp),%eax
801015fa:	85 c0                	test   %eax,%eax
801015fc:	75 64                	jne    80101662 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801015fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101601:	8d 50 07             	lea    0x7(%eax),%edx
80101604:	85 c0                	test   %eax,%eax
80101606:	0f 48 c2             	cmovs  %edx,%eax
80101609:	c1 f8 03             	sar    $0x3,%eax
8010160c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010160f:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101614:	89 d1                	mov    %edx,%ecx
80101616:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101619:	09 ca                	or     %ecx,%edx
8010161b:	89 d1                	mov    %edx,%ecx
8010161d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101620:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101624:	83 ec 0c             	sub    $0xc,%esp
80101627:	ff 75 ec             	pushl  -0x14(%ebp)
8010162a:	e8 70 24 00 00       	call   80103a9f <log_write>
8010162f:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101632:	83 ec 0c             	sub    $0xc,%esp
80101635:	ff 75 ec             	pushl  -0x14(%ebp)
80101638:	e8 f1 eb ff ff       	call   8010022e <brelse>
8010163d:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101640:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101643:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101646:	01 c2                	add    %eax,%edx
80101648:	8b 45 08             	mov    0x8(%ebp),%eax
8010164b:	83 ec 08             	sub    $0x8,%esp
8010164e:	52                   	push   %edx
8010164f:	50                   	push   %eax
80101650:	e8 c6 fe ff ff       	call   8010151b <bzero>
80101655:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101658:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010165b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165e:	01 d0                	add    %edx,%eax
80101660:	eb 57                	jmp    801016b9 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101662:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101666:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010166d:	7f 17                	jg     80101686 <balloc+0x117>
8010166f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101672:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101675:	01 d0                	add    %edx,%eax
80101677:	89 c2                	mov    %eax,%edx
80101679:	a1 60 32 11 80       	mov    0x80113260,%eax
8010167e:	39 c2                	cmp    %eax,%edx
80101680:	0f 82 3a ff ff ff    	jb     801015c0 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101686:	83 ec 0c             	sub    $0xc,%esp
80101689:	ff 75 ec             	pushl  -0x14(%ebp)
8010168c:	e8 9d eb ff ff       	call   8010022e <brelse>
80101691:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101694:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010169b:	8b 15 60 32 11 80    	mov    0x80113260,%edx
801016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016a4:	39 c2                	cmp    %eax,%edx
801016a6:	0f 87 dc fe ff ff    	ja     80101588 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801016ac:	83 ec 0c             	sub    $0xc,%esp
801016af:	68 50 a1 10 80       	push   $0x8010a150
801016b4:	e8 ad ee ff ff       	call   80100566 <panic>
}
801016b9:	c9                   	leave  
801016ba:	c3                   	ret    

801016bb <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016bb:	55                   	push   %ebp
801016bc:	89 e5                	mov    %esp,%ebp
801016be:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801016c1:	83 ec 08             	sub    $0x8,%esp
801016c4:	68 60 32 11 80       	push   $0x80113260
801016c9:	ff 75 08             	pushl  0x8(%ebp)
801016cc:	e8 08 fe ff ff       	call   801014d9 <readsb>
801016d1:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801016d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801016d7:	c1 e8 0c             	shr    $0xc,%eax
801016da:	89 c2                	mov    %eax,%edx
801016dc:	a1 78 32 11 80       	mov    0x80113278,%eax
801016e1:	01 c2                	add    %eax,%edx
801016e3:	8b 45 08             	mov    0x8(%ebp),%eax
801016e6:	83 ec 08             	sub    $0x8,%esp
801016e9:	52                   	push   %edx
801016ea:	50                   	push   %eax
801016eb:	e8 c6 ea ff ff       	call   801001b6 <bread>
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801016f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801016f9:	25 ff 0f 00 00       	and    $0xfff,%eax
801016fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101701:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101704:	99                   	cltd   
80101705:	c1 ea 1d             	shr    $0x1d,%edx
80101708:	01 d0                	add    %edx,%eax
8010170a:	83 e0 07             	and    $0x7,%eax
8010170d:	29 d0                	sub    %edx,%eax
8010170f:	ba 01 00 00 00       	mov    $0x1,%edx
80101714:	89 c1                	mov    %eax,%ecx
80101716:	d3 e2                	shl    %cl,%edx
80101718:	89 d0                	mov    %edx,%eax
8010171a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101720:	8d 50 07             	lea    0x7(%eax),%edx
80101723:	85 c0                	test   %eax,%eax
80101725:	0f 48 c2             	cmovs  %edx,%eax
80101728:	c1 f8 03             	sar    $0x3,%eax
8010172b:	89 c2                	mov    %eax,%edx
8010172d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101730:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101735:	0f b6 c0             	movzbl %al,%eax
80101738:	23 45 ec             	and    -0x14(%ebp),%eax
8010173b:	85 c0                	test   %eax,%eax
8010173d:	75 0d                	jne    8010174c <bfree+0x91>
    panic("freeing free block");
8010173f:	83 ec 0c             	sub    $0xc,%esp
80101742:	68 66 a1 10 80       	push   $0x8010a166
80101747:	e8 1a ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
8010174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174f:	8d 50 07             	lea    0x7(%eax),%edx
80101752:	85 c0                	test   %eax,%eax
80101754:	0f 48 c2             	cmovs  %edx,%eax
80101757:	c1 f8 03             	sar    $0x3,%eax
8010175a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010175d:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101762:	89 d1                	mov    %edx,%ecx
80101764:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101767:	f7 d2                	not    %edx
80101769:	21 ca                	and    %ecx,%edx
8010176b:	89 d1                	mov    %edx,%ecx
8010176d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101770:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101774:	83 ec 0c             	sub    $0xc,%esp
80101777:	ff 75 f4             	pushl  -0xc(%ebp)
8010177a:	e8 20 23 00 00       	call   80103a9f <log_write>
8010177f:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101782:	83 ec 0c             	sub    $0xc,%esp
80101785:	ff 75 f4             	pushl  -0xc(%ebp)
80101788:	e8 a1 ea ff ff       	call   8010022e <brelse>
8010178d:	83 c4 10             	add    $0x10,%esp
}
80101790:	90                   	nop
80101791:	c9                   	leave  
80101792:	c3                   	ret    

80101793 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101793:	55                   	push   %ebp
80101794:	89 e5                	mov    %esp,%ebp
80101796:	57                   	push   %edi
80101797:	56                   	push   %esi
80101798:	53                   	push   %ebx
80101799:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
8010179c:	83 ec 08             	sub    $0x8,%esp
8010179f:	68 79 a1 10 80       	push   $0x8010a179
801017a4:	68 80 32 11 80       	push   $0x80113280
801017a9:	e8 e9 50 00 00       	call   80106897 <initlock>
801017ae:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801017b1:	83 ec 08             	sub    $0x8,%esp
801017b4:	68 60 32 11 80       	push   $0x80113260
801017b9:	ff 75 08             	pushl  0x8(%ebp)
801017bc:	e8 18 fd ff ff       	call   801014d9 <readsb>
801017c1:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801017c4:	a1 78 32 11 80       	mov    0x80113278,%eax
801017c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801017cc:	8b 3d 74 32 11 80    	mov    0x80113274,%edi
801017d2:	8b 35 70 32 11 80    	mov    0x80113270,%esi
801017d8:	8b 1d 6c 32 11 80    	mov    0x8011326c,%ebx
801017de:	8b 0d 68 32 11 80    	mov    0x80113268,%ecx
801017e4:	8b 15 64 32 11 80    	mov    0x80113264,%edx
801017ea:	a1 60 32 11 80       	mov    0x80113260,%eax
801017ef:	ff 75 e4             	pushl  -0x1c(%ebp)
801017f2:	57                   	push   %edi
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	51                   	push   %ecx
801017f6:	52                   	push   %edx
801017f7:	50                   	push   %eax
801017f8:	68 80 a1 10 80       	push   $0x8010a180
801017fd:	e8 c4 eb ff ff       	call   801003c6 <cprintf>
80101802:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101805:	90                   	nop
80101806:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101809:	5b                   	pop    %ebx
8010180a:	5e                   	pop    %esi
8010180b:	5f                   	pop    %edi
8010180c:	5d                   	pop    %ebp
8010180d:	c3                   	ret    

8010180e <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010180e:	55                   	push   %ebp
8010180f:	89 e5                	mov    %esp,%ebp
80101811:	83 ec 28             	sub    $0x28,%esp
80101814:	8b 45 0c             	mov    0xc(%ebp),%eax
80101817:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010181b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101822:	e9 9e 00 00 00       	jmp    801018c5 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182a:	c1 e8 03             	shr    $0x3,%eax
8010182d:	89 c2                	mov    %eax,%edx
8010182f:	a1 74 32 11 80       	mov    0x80113274,%eax
80101834:	01 d0                	add    %edx,%eax
80101836:	83 ec 08             	sub    $0x8,%esp
80101839:	50                   	push   %eax
8010183a:	ff 75 08             	pushl  0x8(%ebp)
8010183d:	e8 74 e9 ff ff       	call   801001b6 <bread>
80101842:	83 c4 10             	add    $0x10,%esp
80101845:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101848:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010184b:	8d 50 18             	lea    0x18(%eax),%edx
8010184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101851:	83 e0 07             	and    $0x7,%eax
80101854:	c1 e0 06             	shl    $0x6,%eax
80101857:	01 d0                	add    %edx,%eax
80101859:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010185c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010185f:	0f b7 00             	movzwl (%eax),%eax
80101862:	66 85 c0             	test   %ax,%ax
80101865:	75 4c                	jne    801018b3 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101867:	83 ec 04             	sub    $0x4,%esp
8010186a:	6a 40                	push   $0x40
8010186c:	6a 00                	push   $0x0
8010186e:	ff 75 ec             	pushl  -0x14(%ebp)
80101871:	e8 a6 52 00 00       	call   80106b1c <memset>
80101876:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101879:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010187c:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101880:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101883:	83 ec 0c             	sub    $0xc,%esp
80101886:	ff 75 f0             	pushl  -0x10(%ebp)
80101889:	e8 11 22 00 00       	call   80103a9f <log_write>
8010188e:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101891:	83 ec 0c             	sub    $0xc,%esp
80101894:	ff 75 f0             	pushl  -0x10(%ebp)
80101897:	e8 92 e9 ff ff       	call   8010022e <brelse>
8010189c:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010189f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a2:	83 ec 08             	sub    $0x8,%esp
801018a5:	50                   	push   %eax
801018a6:	ff 75 08             	pushl  0x8(%ebp)
801018a9:	e8 20 01 00 00       	call   801019ce <iget>
801018ae:	83 c4 10             	add    $0x10,%esp
801018b1:	eb 30                	jmp    801018e3 <ialloc+0xd5>
    }
    brelse(bp);
801018b3:	83 ec 0c             	sub    $0xc,%esp
801018b6:	ff 75 f0             	pushl  -0x10(%ebp)
801018b9:	e8 70 e9 ff ff       	call   8010022e <brelse>
801018be:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801018c5:	8b 15 68 32 11 80    	mov    0x80113268,%edx
801018cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ce:	39 c2                	cmp    %eax,%edx
801018d0:	0f 87 51 ff ff ff    	ja     80101827 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	68 d3 a1 10 80       	push   $0x8010a1d3
801018de:	e8 83 ec ff ff       	call   80100566 <panic>
}
801018e3:	c9                   	leave  
801018e4:	c3                   	ret    

801018e5 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801018e5:	55                   	push   %ebp
801018e6:	89 e5                	mov    %esp,%ebp
801018e8:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018eb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ee:	8b 40 04             	mov    0x4(%eax),%eax
801018f1:	c1 e8 03             	shr    $0x3,%eax
801018f4:	89 c2                	mov    %eax,%edx
801018f6:	a1 74 32 11 80       	mov    0x80113274,%eax
801018fb:	01 c2                	add    %eax,%edx
801018fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101900:	8b 00                	mov    (%eax),%eax
80101902:	83 ec 08             	sub    $0x8,%esp
80101905:	52                   	push   %edx
80101906:	50                   	push   %eax
80101907:	e8 aa e8 ff ff       	call   801001b6 <bread>
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101915:	8d 50 18             	lea    0x18(%eax),%edx
80101918:	8b 45 08             	mov    0x8(%ebp),%eax
8010191b:	8b 40 04             	mov    0x4(%eax),%eax
8010191e:	83 e0 07             	and    $0x7,%eax
80101921:	c1 e0 06             	shl    $0x6,%eax
80101924:	01 d0                	add    %edx,%eax
80101926:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101929:	8b 45 08             	mov    0x8(%ebp),%eax
8010192c:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101930:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101933:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101936:	8b 45 08             	mov    0x8(%ebp),%eax
80101939:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010193d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101940:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101944:	8b 45 08             	mov    0x8(%ebp),%eax
80101947:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010194b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194e:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101952:	8b 45 08             	mov    0x8(%ebp),%eax
80101955:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101959:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010195c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101960:	8b 45 08             	mov    0x8(%ebp),%eax
80101963:	8b 50 20             	mov    0x20(%eax),%edx
80101966:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101969:	89 50 10             	mov    %edx,0x10(%eax)
  #ifdef CS333_P5
  dip->uid = ip->uid;
8010196c:	8b 45 08             	mov    0x8(%ebp),%eax
8010196f:	0f b7 50 18          	movzwl 0x18(%eax),%edx
80101973:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101976:	66 89 50 08          	mov    %dx,0x8(%eax)
  dip->gid = ip->gid;
8010197a:	8b 45 08             	mov    0x8(%ebp),%eax
8010197d:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
80101981:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101984:	66 89 50 0a          	mov    %dx,0xa(%eax)
  dip->mode.as_int = ip->mode.as_int;
80101988:	8b 45 08             	mov    0x8(%ebp),%eax
8010198b:	8b 50 1c             	mov    0x1c(%eax),%edx
8010198e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101991:	89 50 0c             	mov    %edx,0xc(%eax)
  #endif
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101994:	8b 45 08             	mov    0x8(%ebp),%eax
80101997:	8d 50 24             	lea    0x24(%eax),%edx
8010199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199d:	83 c0 14             	add    $0x14,%eax
801019a0:	83 ec 04             	sub    $0x4,%esp
801019a3:	6a 2c                	push   $0x2c
801019a5:	52                   	push   %edx
801019a6:	50                   	push   %eax
801019a7:	e8 2f 52 00 00       	call   80106bdb <memmove>
801019ac:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801019af:	83 ec 0c             	sub    $0xc,%esp
801019b2:	ff 75 f4             	pushl  -0xc(%ebp)
801019b5:	e8 e5 20 00 00       	call   80103a9f <log_write>
801019ba:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801019bd:	83 ec 0c             	sub    $0xc,%esp
801019c0:	ff 75 f4             	pushl  -0xc(%ebp)
801019c3:	e8 66 e8 ff ff       	call   8010022e <brelse>
801019c8:	83 c4 10             	add    $0x10,%esp
}
801019cb:	90                   	nop
801019cc:	c9                   	leave  
801019cd:	c3                   	ret    

801019ce <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019ce:	55                   	push   %ebp
801019cf:	89 e5                	mov    %esp,%ebp
801019d1:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	68 80 32 11 80       	push   $0x80113280
801019dc:	e8 d8 4e 00 00       	call   801068b9 <acquire>
801019e1:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801019e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019eb:	c7 45 f4 b4 32 11 80 	movl   $0x801132b4,-0xc(%ebp)
801019f2:	eb 5d                	jmp    80101a51 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801019f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f7:	8b 40 08             	mov    0x8(%eax),%eax
801019fa:	85 c0                	test   %eax,%eax
801019fc:	7e 39                	jle    80101a37 <iget+0x69>
801019fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a01:	8b 00                	mov    (%eax),%eax
80101a03:	3b 45 08             	cmp    0x8(%ebp),%eax
80101a06:	75 2f                	jne    80101a37 <iget+0x69>
80101a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a0b:	8b 40 04             	mov    0x4(%eax),%eax
80101a0e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101a11:	75 24                	jne    80101a37 <iget+0x69>
      ip->ref++;
80101a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a16:	8b 40 08             	mov    0x8(%eax),%eax
80101a19:	8d 50 01             	lea    0x1(%eax),%edx
80101a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a1f:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a22:	83 ec 0c             	sub    $0xc,%esp
80101a25:	68 80 32 11 80       	push   $0x80113280
80101a2a:	e8 f1 4e 00 00       	call   80106920 <release>
80101a2f:	83 c4 10             	add    $0x10,%esp
      return ip;
80101a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a35:	eb 74                	jmp    80101aab <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a3b:	75 10                	jne    80101a4d <iget+0x7f>
80101a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a40:	8b 40 08             	mov    0x8(%eax),%eax
80101a43:	85 c0                	test   %eax,%eax
80101a45:	75 06                	jne    80101a4d <iget+0x7f>
      empty = ip;
80101a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a4d:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101a51:	81 7d f4 54 42 11 80 	cmpl   $0x80114254,-0xc(%ebp)
80101a58:	72 9a                	jb     801019f4 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a5e:	75 0d                	jne    80101a6d <iget+0x9f>
    panic("iget: no inodes");
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 e5 a1 10 80       	push   $0x8010a1e5
80101a68:	e8 f9 ea ff ff       	call   80100566 <panic>

  ip = empty;
80101a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a76:	8b 55 08             	mov    0x8(%ebp),%edx
80101a79:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101a81:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a87:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a91:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101a98:	83 ec 0c             	sub    $0xc,%esp
80101a9b:	68 80 32 11 80       	push   $0x80113280
80101aa0:	e8 7b 4e 00 00       	call   80106920 <release>
80101aa5:	83 c4 10             	add    $0x10,%esp

  return ip;
80101aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101aab:	c9                   	leave  
80101aac:	c3                   	ret    

80101aad <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101aad:	55                   	push   %ebp
80101aae:	89 e5                	mov    %esp,%ebp
80101ab0:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101ab3:	83 ec 0c             	sub    $0xc,%esp
80101ab6:	68 80 32 11 80       	push   $0x80113280
80101abb:	e8 f9 4d 00 00       	call   801068b9 <acquire>
80101ac0:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac6:	8b 40 08             	mov    0x8(%eax),%eax
80101ac9:	8d 50 01             	lea    0x1(%eax),%edx
80101acc:	8b 45 08             	mov    0x8(%ebp),%eax
80101acf:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ad2:	83 ec 0c             	sub    $0xc,%esp
80101ad5:	68 80 32 11 80       	push   $0x80113280
80101ada:	e8 41 4e 00 00       	call   80106920 <release>
80101adf:	83 c4 10             	add    $0x10,%esp
  return ip;
80101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ae5:	c9                   	leave  
80101ae6:	c3                   	ret    

80101ae7 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101ae7:	55                   	push   %ebp
80101ae8:	89 e5                	mov    %esp,%ebp
80101aea:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101aed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101af1:	74 0a                	je     80101afd <ilock+0x16>
80101af3:	8b 45 08             	mov    0x8(%ebp),%eax
80101af6:	8b 40 08             	mov    0x8(%eax),%eax
80101af9:	85 c0                	test   %eax,%eax
80101afb:	7f 0d                	jg     80101b0a <ilock+0x23>
    panic("ilock");
80101afd:	83 ec 0c             	sub    $0xc,%esp
80101b00:	68 f5 a1 10 80       	push   $0x8010a1f5
80101b05:	e8 5c ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b0a:	83 ec 0c             	sub    $0xc,%esp
80101b0d:	68 80 32 11 80       	push   $0x80113280
80101b12:	e8 a2 4d 00 00       	call   801068b9 <acquire>
80101b17:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101b1a:	eb 13                	jmp    80101b2f <ilock+0x48>
    sleep(ip, &icache.lock);
80101b1c:	83 ec 08             	sub    $0x8,%esp
80101b1f:	68 80 32 11 80       	push   $0x80113280
80101b24:	ff 75 08             	pushl  0x8(%ebp)
80101b27:	e8 ff 3a 00 00       	call   8010562b <sleep>
80101b2c:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b32:	8b 40 0c             	mov    0xc(%eax),%eax
80101b35:	83 e0 01             	and    $0x1,%eax
80101b38:	85 c0                	test   %eax,%eax
80101b3a:	75 e0                	jne    80101b1c <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3f:	8b 40 0c             	mov    0xc(%eax),%eax
80101b42:	83 c8 01             	or     $0x1,%eax
80101b45:	89 c2                	mov    %eax,%edx
80101b47:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4a:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101b4d:	83 ec 0c             	sub    $0xc,%esp
80101b50:	68 80 32 11 80       	push   $0x80113280
80101b55:	e8 c6 4d 00 00       	call   80106920 <release>
80101b5a:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b60:	8b 40 0c             	mov    0xc(%eax),%eax
80101b63:	83 e0 02             	and    $0x2,%eax
80101b66:	85 c0                	test   %eax,%eax
80101b68:	0f 85 fc 00 00 00    	jne    80101c6a <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b71:	8b 40 04             	mov    0x4(%eax),%eax
80101b74:	c1 e8 03             	shr    $0x3,%eax
80101b77:	89 c2                	mov    %eax,%edx
80101b79:	a1 74 32 11 80       	mov    0x80113274,%eax
80101b7e:	01 c2                	add    %eax,%edx
80101b80:	8b 45 08             	mov    0x8(%ebp),%eax
80101b83:	8b 00                	mov    (%eax),%eax
80101b85:	83 ec 08             	sub    $0x8,%esp
80101b88:	52                   	push   %edx
80101b89:	50                   	push   %eax
80101b8a:	e8 27 e6 ff ff       	call   801001b6 <bread>
80101b8f:	83 c4 10             	add    $0x10,%esp
80101b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b98:	8d 50 18             	lea    0x18(%eax),%edx
80101b9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9e:	8b 40 04             	mov    0x4(%eax),%eax
80101ba1:	83 e0 07             	and    $0x7,%eax
80101ba4:	c1 e0 06             	shl    $0x6,%eax
80101ba7:	01 d0                	add    %edx,%eax
80101ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101baf:	0f b7 10             	movzwl (%eax),%edx
80101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb5:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bbc:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc3:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bca:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101bce:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd1:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd8:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdf:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101be6:	8b 50 10             	mov    0x10(%eax),%edx
80101be9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bec:	89 50 20             	mov    %edx,0x20(%eax)
    #ifdef CS333_P5
    ip->uid = dip->uid;
80101bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bf2:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80101bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf9:	66 89 50 18          	mov    %dx,0x18(%eax)
    ip->gid = dip->gid;
80101bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c00:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
80101c04:	8b 45 08             	mov    0x8(%ebp),%eax
80101c07:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    ip->mode.as_int = dip->mode.as_int;
80101c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c0e:	8b 50 0c             	mov    0xc(%eax),%edx
80101c11:	8b 45 08             	mov    0x8(%ebp),%eax
80101c14:	89 50 1c             	mov    %edx,0x1c(%eax)
    #endif
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c1a:	8d 50 14             	lea    0x14(%eax),%edx
80101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c20:	83 c0 24             	add    $0x24,%eax
80101c23:	83 ec 04             	sub    $0x4,%esp
80101c26:	6a 2c                	push   $0x2c
80101c28:	52                   	push   %edx
80101c29:	50                   	push   %eax
80101c2a:	e8 ac 4f 00 00       	call   80106bdb <memmove>
80101c2f:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101c32:	83 ec 0c             	sub    $0xc,%esp
80101c35:	ff 75 f4             	pushl  -0xc(%ebp)
80101c38:	e8 f1 e5 ff ff       	call   8010022e <brelse>
80101c3d:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101c40:	8b 45 08             	mov    0x8(%ebp),%eax
80101c43:	8b 40 0c             	mov    0xc(%eax),%eax
80101c46:	83 c8 02             	or     $0x2,%eax
80101c49:	89 c2                	mov    %eax,%edx
80101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4e:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101c51:	8b 45 08             	mov    0x8(%ebp),%eax
80101c54:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101c58:	66 85 c0             	test   %ax,%ax
80101c5b:	75 0d                	jne    80101c6a <ilock+0x183>
      panic("ilock: no type");
80101c5d:	83 ec 0c             	sub    $0xc,%esp
80101c60:	68 fb a1 10 80       	push   $0x8010a1fb
80101c65:	e8 fc e8 ff ff       	call   80100566 <panic>
  }
}
80101c6a:	90                   	nop
80101c6b:	c9                   	leave  
80101c6c:	c3                   	ret    

80101c6d <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101c6d:	55                   	push   %ebp
80101c6e:	89 e5                	mov    %esp,%ebp
80101c70:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101c73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c77:	74 17                	je     80101c90 <iunlock+0x23>
80101c79:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7c:	8b 40 0c             	mov    0xc(%eax),%eax
80101c7f:	83 e0 01             	and    $0x1,%eax
80101c82:	85 c0                	test   %eax,%eax
80101c84:	74 0a                	je     80101c90 <iunlock+0x23>
80101c86:	8b 45 08             	mov    0x8(%ebp),%eax
80101c89:	8b 40 08             	mov    0x8(%eax),%eax
80101c8c:	85 c0                	test   %eax,%eax
80101c8e:	7f 0d                	jg     80101c9d <iunlock+0x30>
    panic("iunlock");
80101c90:	83 ec 0c             	sub    $0xc,%esp
80101c93:	68 0a a2 10 80       	push   $0x8010a20a
80101c98:	e8 c9 e8 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101c9d:	83 ec 0c             	sub    $0xc,%esp
80101ca0:	68 80 32 11 80       	push   $0x80113280
80101ca5:	e8 0f 4c 00 00       	call   801068b9 <acquire>
80101caa:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101cad:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb0:	8b 40 0c             	mov    0xc(%eax),%eax
80101cb3:	83 e0 fe             	and    $0xfffffffe,%eax
80101cb6:	89 c2                	mov    %eax,%edx
80101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbb:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
80101cc1:	ff 75 08             	pushl  0x8(%ebp)
80101cc4:	e8 3b 3b 00 00       	call   80105804 <wakeup>
80101cc9:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ccc:	83 ec 0c             	sub    $0xc,%esp
80101ccf:	68 80 32 11 80       	push   $0x80113280
80101cd4:	e8 47 4c 00 00       	call   80106920 <release>
80101cd9:	83 c4 10             	add    $0x10,%esp
}
80101cdc:	90                   	nop
80101cdd:	c9                   	leave  
80101cde:	c3                   	ret    

80101cdf <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101cdf:	55                   	push   %ebp
80101ce0:	89 e5                	mov    %esp,%ebp
80101ce2:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101ce5:	83 ec 0c             	sub    $0xc,%esp
80101ce8:	68 80 32 11 80       	push   $0x80113280
80101ced:	e8 c7 4b 00 00       	call   801068b9 <acquire>
80101cf2:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf8:	8b 40 08             	mov    0x8(%eax),%eax
80101cfb:	83 f8 01             	cmp    $0x1,%eax
80101cfe:	0f 85 a9 00 00 00    	jne    80101dad <iput+0xce>
80101d04:	8b 45 08             	mov    0x8(%ebp),%eax
80101d07:	8b 40 0c             	mov    0xc(%eax),%eax
80101d0a:	83 e0 02             	and    $0x2,%eax
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	0f 84 98 00 00 00    	je     80101dad <iput+0xce>
80101d15:	8b 45 08             	mov    0x8(%ebp),%eax
80101d18:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101d1c:	66 85 c0             	test   %ax,%ax
80101d1f:	0f 85 88 00 00 00    	jne    80101dad <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101d25:	8b 45 08             	mov    0x8(%ebp),%eax
80101d28:	8b 40 0c             	mov    0xc(%eax),%eax
80101d2b:	83 e0 01             	and    $0x1,%eax
80101d2e:	85 c0                	test   %eax,%eax
80101d30:	74 0d                	je     80101d3f <iput+0x60>
      panic("iput busy");
80101d32:	83 ec 0c             	sub    $0xc,%esp
80101d35:	68 12 a2 10 80       	push   $0x8010a212
80101d3a:	e8 27 e8 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d42:	8b 40 0c             	mov    0xc(%eax),%eax
80101d45:	83 c8 01             	or     $0x1,%eax
80101d48:	89 c2                	mov    %eax,%edx
80101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4d:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101d50:	83 ec 0c             	sub    $0xc,%esp
80101d53:	68 80 32 11 80       	push   $0x80113280
80101d58:	e8 c3 4b 00 00       	call   80106920 <release>
80101d5d:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101d60:	83 ec 0c             	sub    $0xc,%esp
80101d63:	ff 75 08             	pushl  0x8(%ebp)
80101d66:	e8 a8 01 00 00       	call   80101f13 <itrunc>
80101d6b:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d71:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101d77:	83 ec 0c             	sub    $0xc,%esp
80101d7a:	ff 75 08             	pushl  0x8(%ebp)
80101d7d:	e8 63 fb ff ff       	call   801018e5 <iupdate>
80101d82:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101d85:	83 ec 0c             	sub    $0xc,%esp
80101d88:	68 80 32 11 80       	push   $0x80113280
80101d8d:	e8 27 4b 00 00       	call   801068b9 <acquire>
80101d92:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101d95:	8b 45 08             	mov    0x8(%ebp),%eax
80101d98:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	ff 75 08             	pushl  0x8(%ebp)
80101da5:	e8 5a 3a 00 00       	call   80105804 <wakeup>
80101daa:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101dad:	8b 45 08             	mov    0x8(%ebp),%eax
80101db0:	8b 40 08             	mov    0x8(%eax),%eax
80101db3:	8d 50 ff             	lea    -0x1(%eax),%edx
80101db6:	8b 45 08             	mov    0x8(%ebp),%eax
80101db9:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101dbc:	83 ec 0c             	sub    $0xc,%esp
80101dbf:	68 80 32 11 80       	push   $0x80113280
80101dc4:	e8 57 4b 00 00       	call   80106920 <release>
80101dc9:	83 c4 10             	add    $0x10,%esp
}
80101dcc:	90                   	nop
80101dcd:	c9                   	leave  
80101dce:	c3                   	ret    

80101dcf <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101dcf:	55                   	push   %ebp
80101dd0:	89 e5                	mov    %esp,%ebp
80101dd2:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101dd5:	83 ec 0c             	sub    $0xc,%esp
80101dd8:	ff 75 08             	pushl  0x8(%ebp)
80101ddb:	e8 8d fe ff ff       	call   80101c6d <iunlock>
80101de0:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101de3:	83 ec 0c             	sub    $0xc,%esp
80101de6:	ff 75 08             	pushl  0x8(%ebp)
80101de9:	e8 f1 fe ff ff       	call   80101cdf <iput>
80101dee:	83 c4 10             	add    $0x10,%esp
}
80101df1:	90                   	nop
80101df2:	c9                   	leave  
80101df3:	c3                   	ret    

80101df4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101df4:	55                   	push   %ebp
80101df5:	89 e5                	mov    %esp,%ebp
80101df7:	53                   	push   %ebx
80101df8:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101dfb:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101dff:	77 42                	ja     80101e43 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101e01:	8b 45 08             	mov    0x8(%ebp),%eax
80101e04:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e07:	83 c2 08             	add    $0x8,%edx
80101e0a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e15:	75 24                	jne    80101e3b <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e17:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1a:	8b 00                	mov    (%eax),%eax
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	50                   	push   %eax
80101e20:	e8 4a f7 ff ff       	call   8010156f <balloc>
80101e25:	83 c4 10             	add    $0x10,%esp
80101e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e31:	8d 4a 08             	lea    0x8(%edx),%ecx
80101e34:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e37:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    return addr;
80101e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e3e:	e9 cb 00 00 00       	jmp    80101f0e <bmap+0x11a>
  }
  bn -= NDIRECT;
80101e43:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80101e47:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101e4b:	0f 87 b0 00 00 00    	ja     80101f01 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101e51:	8b 45 08             	mov    0x8(%ebp),%eax
80101e54:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e5e:	75 1d                	jne    80101e7d <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101e60:	8b 45 08             	mov    0x8(%ebp),%eax
80101e63:	8b 00                	mov    (%eax),%eax
80101e65:	83 ec 0c             	sub    $0xc,%esp
80101e68:	50                   	push   %eax
80101e69:	e8 01 f7 ff ff       	call   8010156f <balloc>
80101e6e:	83 c4 10             	add    $0x10,%esp
80101e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e74:	8b 45 08             	mov    0x8(%ebp),%eax
80101e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e7a:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e80:	8b 00                	mov    (%eax),%eax
80101e82:	83 ec 08             	sub    $0x8,%esp
80101e85:	ff 75 f4             	pushl  -0xc(%ebp)
80101e88:	50                   	push   %eax
80101e89:	e8 28 e3 ff ff       	call   801001b6 <bread>
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e97:	83 c0 18             	add    $0x18,%eax
80101e9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eaa:	01 d0                	add    %edx,%eax
80101eac:	8b 00                	mov    (%eax),%eax
80101eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101eb5:	75 37                	jne    80101eee <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec4:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101ec7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eca:	8b 00                	mov    (%eax),%eax
80101ecc:	83 ec 0c             	sub    $0xc,%esp
80101ecf:	50                   	push   %eax
80101ed0:	e8 9a f6 ff ff       	call   8010156f <balloc>
80101ed5:	83 c4 10             	add    $0x10,%esp
80101ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ede:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ee0:	83 ec 0c             	sub    $0xc,%esp
80101ee3:	ff 75 f0             	pushl  -0x10(%ebp)
80101ee6:	e8 b4 1b 00 00       	call   80103a9f <log_write>
80101eeb:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101eee:	83 ec 0c             	sub    $0xc,%esp
80101ef1:	ff 75 f0             	pushl  -0x10(%ebp)
80101ef4:	e8 35 e3 ff ff       	call   8010022e <brelse>
80101ef9:	83 c4 10             	add    $0x10,%esp
    return addr;
80101efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eff:	eb 0d                	jmp    80101f0e <bmap+0x11a>
  }

  panic("bmap: out of range");
80101f01:	83 ec 0c             	sub    $0xc,%esp
80101f04:	68 1c a2 10 80       	push   $0x8010a21c
80101f09:	e8 58 e6 ff ff       	call   80100566 <panic>
}
80101f0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f11:	c9                   	leave  
80101f12:	c3                   	ret    

80101f13 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101f13:	55                   	push   %ebp
80101f14:	89 e5                	mov    %esp,%ebp
80101f16:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f20:	eb 45                	jmp    80101f67 <itrunc+0x54>
    if(ip->addrs[i]){
80101f22:	8b 45 08             	mov    0x8(%ebp),%eax
80101f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f28:	83 c2 08             	add    $0x8,%edx
80101f2b:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101f2f:	85 c0                	test   %eax,%eax
80101f31:	74 30                	je     80101f63 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101f33:	8b 45 08             	mov    0x8(%ebp),%eax
80101f36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f39:	83 c2 08             	add    $0x8,%edx
80101f3c:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101f40:	8b 55 08             	mov    0x8(%ebp),%edx
80101f43:	8b 12                	mov    (%edx),%edx
80101f45:	83 ec 08             	sub    $0x8,%esp
80101f48:	50                   	push   %eax
80101f49:	52                   	push   %edx
80101f4a:	e8 6c f7 ff ff       	call   801016bb <bfree>
80101f4f:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101f52:	8b 45 08             	mov    0x8(%ebp),%eax
80101f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f58:	83 c2 08             	add    $0x8,%edx
80101f5b:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
80101f62:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f63:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101f67:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80101f6b:	7e b5                	jle    80101f22 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f70:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f73:	85 c0                	test   %eax,%eax
80101f75:	0f 84 a1 00 00 00    	je     8010201c <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7e:	8b 50 4c             	mov    0x4c(%eax),%edx
80101f81:	8b 45 08             	mov    0x8(%ebp),%eax
80101f84:	8b 00                	mov    (%eax),%eax
80101f86:	83 ec 08             	sub    $0x8,%esp
80101f89:	52                   	push   %edx
80101f8a:	50                   	push   %eax
80101f8b:	e8 26 e2 ff ff       	call   801001b6 <bread>
80101f90:	83 c4 10             	add    $0x10,%esp
80101f93:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101f96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f99:	83 c0 18             	add    $0x18,%eax
80101f9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101f9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101fa6:	eb 3c                	jmp    80101fe4 <itrunc+0xd1>
      if(a[j])
80101fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fb5:	01 d0                	add    %edx,%eax
80101fb7:	8b 00                	mov    (%eax),%eax
80101fb9:	85 c0                	test   %eax,%eax
80101fbb:	74 23                	je     80101fe0 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fc0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fca:	01 d0                	add    %edx,%eax
80101fcc:	8b 00                	mov    (%eax),%eax
80101fce:	8b 55 08             	mov    0x8(%ebp),%edx
80101fd1:	8b 12                	mov    (%edx),%edx
80101fd3:	83 ec 08             	sub    $0x8,%esp
80101fd6:	50                   	push   %eax
80101fd7:	52                   	push   %edx
80101fd8:	e8 de f6 ff ff       	call   801016bb <bfree>
80101fdd:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101fe0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fe7:	83 f8 7f             	cmp    $0x7f,%eax
80101fea:	76 bc                	jbe    80101fa8 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101fec:	83 ec 0c             	sub    $0xc,%esp
80101fef:	ff 75 ec             	pushl  -0x14(%ebp)
80101ff2:	e8 37 e2 ff ff       	call   8010022e <brelse>
80101ff7:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ffa:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffd:	8b 40 4c             	mov    0x4c(%eax),%eax
80102000:	8b 55 08             	mov    0x8(%ebp),%edx
80102003:	8b 12                	mov    (%edx),%edx
80102005:	83 ec 08             	sub    $0x8,%esp
80102008:	50                   	push   %eax
80102009:	52                   	push   %edx
8010200a:	e8 ac f6 ff ff       	call   801016bb <bfree>
8010200f:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80102012:	8b 45 08             	mov    0x8(%ebp),%eax
80102015:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
8010201c:	8b 45 08             	mov    0x8(%ebp),%eax
8010201f:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  iupdate(ip);
80102026:	83 ec 0c             	sub    $0xc,%esp
80102029:	ff 75 08             	pushl  0x8(%ebp)
8010202c:	e8 b4 f8 ff ff       	call   801018e5 <iupdate>
80102031:	83 c4 10             	add    $0x10,%esp
}
80102034:	90                   	nop
80102035:	c9                   	leave  
80102036:	c3                   	ret    

80102037 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80102037:	55                   	push   %ebp
80102038:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
8010203a:	8b 45 08             	mov    0x8(%ebp),%eax
8010203d:	8b 00                	mov    (%eax),%eax
8010203f:	89 c2                	mov    %eax,%edx
80102041:	8b 45 0c             	mov    0xc(%ebp),%eax
80102044:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80102047:	8b 45 08             	mov    0x8(%ebp),%eax
8010204a:	8b 50 04             	mov    0x4(%eax),%edx
8010204d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102050:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80102053:	8b 45 08             	mov    0x8(%ebp),%eax
80102056:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010205a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010205d:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80102060:	8b 45 08             	mov    0x8(%ebp),%eax
80102063:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80102067:	8b 45 0c             	mov    0xc(%ebp),%eax
8010206a:	66 89 50 0c          	mov    %dx,0xc(%eax)
  #ifdef CS333_P5
  st->uid = ip->uid;
8010206e:	8b 45 08             	mov    0x8(%ebp),%eax
80102071:	0f b7 50 18          	movzwl 0x18(%eax),%edx
80102075:	8b 45 0c             	mov    0xc(%ebp),%eax
80102078:	66 89 50 0e          	mov    %dx,0xe(%eax)
  st->gid = ip->gid;
8010207c:	8b 45 08             	mov    0x8(%ebp),%eax
8010207f:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
80102083:	8b 45 0c             	mov    0xc(%ebp),%eax
80102086:	66 89 50 10          	mov    %dx,0x10(%eax)
  st->mode.as_int = ip->mode.as_int;
8010208a:	8b 45 08             	mov    0x8(%ebp),%eax
8010208d:	8b 50 1c             	mov    0x1c(%eax),%edx
80102090:	8b 45 0c             	mov    0xc(%ebp),%eax
80102093:	89 50 14             	mov    %edx,0x14(%eax)
  #endif
  st->size = ip->size;
80102096:	8b 45 08             	mov    0x8(%ebp),%eax
80102099:	8b 50 20             	mov    0x20(%eax),%edx
8010209c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010209f:	89 50 18             	mov    %edx,0x18(%eax)
}
801020a2:	90                   	nop
801020a3:	5d                   	pop    %ebp
801020a4:	c3                   	ret    

801020a5 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801020a5:	55                   	push   %ebp
801020a6:	89 e5                	mov    %esp,%ebp
801020a8:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
801020ae:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020b2:	66 83 f8 03          	cmp    $0x3,%ax
801020b6:	75 5c                	jne    80102114 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020bf:	66 85 c0             	test   %ax,%ax
801020c2:	78 20                	js     801020e4 <readi+0x3f>
801020c4:	8b 45 08             	mov    0x8(%ebp),%eax
801020c7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020cb:	66 83 f8 09          	cmp    $0x9,%ax
801020cf:	7f 13                	jg     801020e4 <readi+0x3f>
801020d1:	8b 45 08             	mov    0x8(%ebp),%eax
801020d4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020d8:	98                   	cwtl   
801020d9:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
801020e0:	85 c0                	test   %eax,%eax
801020e2:	75 0a                	jne    801020ee <readi+0x49>
      return -1;
801020e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e9:	e9 0c 01 00 00       	jmp    801021fa <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
801020ee:	8b 45 08             	mov    0x8(%ebp),%eax
801020f1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020f5:	98                   	cwtl   
801020f6:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
801020fd:	8b 55 14             	mov    0x14(%ebp),%edx
80102100:	83 ec 04             	sub    $0x4,%esp
80102103:	52                   	push   %edx
80102104:	ff 75 0c             	pushl  0xc(%ebp)
80102107:	ff 75 08             	pushl  0x8(%ebp)
8010210a:	ff d0                	call   *%eax
8010210c:	83 c4 10             	add    $0x10,%esp
8010210f:	e9 e6 00 00 00       	jmp    801021fa <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80102114:	8b 45 08             	mov    0x8(%ebp),%eax
80102117:	8b 40 20             	mov    0x20(%eax),%eax
8010211a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010211d:	72 0d                	jb     8010212c <readi+0x87>
8010211f:	8b 55 10             	mov    0x10(%ebp),%edx
80102122:	8b 45 14             	mov    0x14(%ebp),%eax
80102125:	01 d0                	add    %edx,%eax
80102127:	3b 45 10             	cmp    0x10(%ebp),%eax
8010212a:	73 0a                	jae    80102136 <readi+0x91>
    return -1;
8010212c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102131:	e9 c4 00 00 00       	jmp    801021fa <readi+0x155>
  if(off + n > ip->size)
80102136:	8b 55 10             	mov    0x10(%ebp),%edx
80102139:	8b 45 14             	mov    0x14(%ebp),%eax
8010213c:	01 c2                	add    %eax,%edx
8010213e:	8b 45 08             	mov    0x8(%ebp),%eax
80102141:	8b 40 20             	mov    0x20(%eax),%eax
80102144:	39 c2                	cmp    %eax,%edx
80102146:	76 0c                	jbe    80102154 <readi+0xaf>
    n = ip->size - off;
80102148:	8b 45 08             	mov    0x8(%ebp),%eax
8010214b:	8b 40 20             	mov    0x20(%eax),%eax
8010214e:	2b 45 10             	sub    0x10(%ebp),%eax
80102151:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102154:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010215b:	e9 8b 00 00 00       	jmp    801021eb <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102160:	8b 45 10             	mov    0x10(%ebp),%eax
80102163:	c1 e8 09             	shr    $0x9,%eax
80102166:	83 ec 08             	sub    $0x8,%esp
80102169:	50                   	push   %eax
8010216a:	ff 75 08             	pushl  0x8(%ebp)
8010216d:	e8 82 fc ff ff       	call   80101df4 <bmap>
80102172:	83 c4 10             	add    $0x10,%esp
80102175:	89 c2                	mov    %eax,%edx
80102177:	8b 45 08             	mov    0x8(%ebp),%eax
8010217a:	8b 00                	mov    (%eax),%eax
8010217c:	83 ec 08             	sub    $0x8,%esp
8010217f:	52                   	push   %edx
80102180:	50                   	push   %eax
80102181:	e8 30 e0 ff ff       	call   801001b6 <bread>
80102186:	83 c4 10             	add    $0x10,%esp
80102189:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010218c:	8b 45 10             	mov    0x10(%ebp),%eax
8010218f:	25 ff 01 00 00       	and    $0x1ff,%eax
80102194:	ba 00 02 00 00       	mov    $0x200,%edx
80102199:	29 c2                	sub    %eax,%edx
8010219b:	8b 45 14             	mov    0x14(%ebp),%eax
8010219e:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021a1:	39 c2                	cmp    %eax,%edx
801021a3:	0f 46 c2             	cmovbe %edx,%eax
801021a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801021a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021ac:	8d 50 18             	lea    0x18(%eax),%edx
801021af:	8b 45 10             	mov    0x10(%ebp),%eax
801021b2:	25 ff 01 00 00       	and    $0x1ff,%eax
801021b7:	01 d0                	add    %edx,%eax
801021b9:	83 ec 04             	sub    $0x4,%esp
801021bc:	ff 75 ec             	pushl  -0x14(%ebp)
801021bf:	50                   	push   %eax
801021c0:	ff 75 0c             	pushl  0xc(%ebp)
801021c3:	e8 13 4a 00 00       	call   80106bdb <memmove>
801021c8:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021cb:	83 ec 0c             	sub    $0xc,%esp
801021ce:	ff 75 f0             	pushl  -0x10(%ebp)
801021d1:	e8 58 e0 ff ff       	call   8010022e <brelse>
801021d6:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021dc:	01 45 f4             	add    %eax,-0xc(%ebp)
801021df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021e2:	01 45 10             	add    %eax,0x10(%ebp)
801021e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021e8:	01 45 0c             	add    %eax,0xc(%ebp)
801021eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ee:	3b 45 14             	cmp    0x14(%ebp),%eax
801021f1:	0f 82 69 ff ff ff    	jb     80102160 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801021f7:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021fa:	c9                   	leave  
801021fb:	c3                   	ret    

801021fc <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801021fc:	55                   	push   %ebp
801021fd:	89 e5                	mov    %esp,%ebp
801021ff:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102202:	8b 45 08             	mov    0x8(%ebp),%eax
80102205:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102209:	66 83 f8 03          	cmp    $0x3,%ax
8010220d:	75 5c                	jne    8010226b <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010220f:	8b 45 08             	mov    0x8(%ebp),%eax
80102212:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102216:	66 85 c0             	test   %ax,%ax
80102219:	78 20                	js     8010223b <writei+0x3f>
8010221b:	8b 45 08             	mov    0x8(%ebp),%eax
8010221e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102222:	66 83 f8 09          	cmp    $0x9,%ax
80102226:	7f 13                	jg     8010223b <writei+0x3f>
80102228:	8b 45 08             	mov    0x8(%ebp),%eax
8010222b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010222f:	98                   	cwtl   
80102230:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
80102237:	85 c0                	test   %eax,%eax
80102239:	75 0a                	jne    80102245 <writei+0x49>
      return -1;
8010223b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102240:	e9 3d 01 00 00       	jmp    80102382 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102245:	8b 45 08             	mov    0x8(%ebp),%eax
80102248:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010224c:	98                   	cwtl   
8010224d:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
80102254:	8b 55 14             	mov    0x14(%ebp),%edx
80102257:	83 ec 04             	sub    $0x4,%esp
8010225a:	52                   	push   %edx
8010225b:	ff 75 0c             	pushl  0xc(%ebp)
8010225e:	ff 75 08             	pushl  0x8(%ebp)
80102261:	ff d0                	call   *%eax
80102263:	83 c4 10             	add    $0x10,%esp
80102266:	e9 17 01 00 00       	jmp    80102382 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
8010226b:	8b 45 08             	mov    0x8(%ebp),%eax
8010226e:	8b 40 20             	mov    0x20(%eax),%eax
80102271:	3b 45 10             	cmp    0x10(%ebp),%eax
80102274:	72 0d                	jb     80102283 <writei+0x87>
80102276:	8b 55 10             	mov    0x10(%ebp),%edx
80102279:	8b 45 14             	mov    0x14(%ebp),%eax
8010227c:	01 d0                	add    %edx,%eax
8010227e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102281:	73 0a                	jae    8010228d <writei+0x91>
    return -1;
80102283:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102288:	e9 f5 00 00 00       	jmp    80102382 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010228d:	8b 55 10             	mov    0x10(%ebp),%edx
80102290:	8b 45 14             	mov    0x14(%ebp),%eax
80102293:	01 d0                	add    %edx,%eax
80102295:	3d 00 14 01 00       	cmp    $0x11400,%eax
8010229a:	76 0a                	jbe    801022a6 <writei+0xaa>
    return -1;
8010229c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022a1:	e9 dc 00 00 00       	jmp    80102382 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022ad:	e9 99 00 00 00       	jmp    8010234b <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801022b2:	8b 45 10             	mov    0x10(%ebp),%eax
801022b5:	c1 e8 09             	shr    $0x9,%eax
801022b8:	83 ec 08             	sub    $0x8,%esp
801022bb:	50                   	push   %eax
801022bc:	ff 75 08             	pushl  0x8(%ebp)
801022bf:	e8 30 fb ff ff       	call   80101df4 <bmap>
801022c4:	83 c4 10             	add    $0x10,%esp
801022c7:	89 c2                	mov    %eax,%edx
801022c9:	8b 45 08             	mov    0x8(%ebp),%eax
801022cc:	8b 00                	mov    (%eax),%eax
801022ce:	83 ec 08             	sub    $0x8,%esp
801022d1:	52                   	push   %edx
801022d2:	50                   	push   %eax
801022d3:	e8 de de ff ff       	call   801001b6 <bread>
801022d8:	83 c4 10             	add    $0x10,%esp
801022db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801022de:	8b 45 10             	mov    0x10(%ebp),%eax
801022e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801022e6:	ba 00 02 00 00       	mov    $0x200,%edx
801022eb:	29 c2                	sub    %eax,%edx
801022ed:	8b 45 14             	mov    0x14(%ebp),%eax
801022f0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801022f3:	39 c2                	cmp    %eax,%edx
801022f5:	0f 46 c2             	cmovbe %edx,%eax
801022f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801022fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022fe:	8d 50 18             	lea    0x18(%eax),%edx
80102301:	8b 45 10             	mov    0x10(%ebp),%eax
80102304:	25 ff 01 00 00       	and    $0x1ff,%eax
80102309:	01 d0                	add    %edx,%eax
8010230b:	83 ec 04             	sub    $0x4,%esp
8010230e:	ff 75 ec             	pushl  -0x14(%ebp)
80102311:	ff 75 0c             	pushl  0xc(%ebp)
80102314:	50                   	push   %eax
80102315:	e8 c1 48 00 00       	call   80106bdb <memmove>
8010231a:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010231d:	83 ec 0c             	sub    $0xc,%esp
80102320:	ff 75 f0             	pushl  -0x10(%ebp)
80102323:	e8 77 17 00 00       	call   80103a9f <log_write>
80102328:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010232b:	83 ec 0c             	sub    $0xc,%esp
8010232e:	ff 75 f0             	pushl  -0x10(%ebp)
80102331:	e8 f8 de ff ff       	call   8010022e <brelse>
80102336:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102339:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010233c:	01 45 f4             	add    %eax,-0xc(%ebp)
8010233f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102342:	01 45 10             	add    %eax,0x10(%ebp)
80102345:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102348:	01 45 0c             	add    %eax,0xc(%ebp)
8010234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234e:	3b 45 14             	cmp    0x14(%ebp),%eax
80102351:	0f 82 5b ff ff ff    	jb     801022b2 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102357:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010235b:	74 22                	je     8010237f <writei+0x183>
8010235d:	8b 45 08             	mov    0x8(%ebp),%eax
80102360:	8b 40 20             	mov    0x20(%eax),%eax
80102363:	3b 45 10             	cmp    0x10(%ebp),%eax
80102366:	73 17                	jae    8010237f <writei+0x183>
    ip->size = off;
80102368:	8b 45 08             	mov    0x8(%ebp),%eax
8010236b:	8b 55 10             	mov    0x10(%ebp),%edx
8010236e:	89 50 20             	mov    %edx,0x20(%eax)
    iupdate(ip);
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	ff 75 08             	pushl  0x8(%ebp)
80102377:	e8 69 f5 ff ff       	call   801018e5 <iupdate>
8010237c:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010237f:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102382:	c9                   	leave  
80102383:	c3                   	ret    

80102384 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102384:	55                   	push   %ebp
80102385:	89 e5                	mov    %esp,%ebp
80102387:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010238a:	83 ec 04             	sub    $0x4,%esp
8010238d:	6a 0e                	push   $0xe
8010238f:	ff 75 0c             	pushl  0xc(%ebp)
80102392:	ff 75 08             	pushl  0x8(%ebp)
80102395:	e8 d7 48 00 00       	call   80106c71 <strncmp>
8010239a:	83 c4 10             	add    $0x10,%esp
}
8010239d:	c9                   	leave  
8010239e:	c3                   	ret    

8010239f <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010239f:	55                   	push   %ebp
801023a0:	89 e5                	mov    %esp,%ebp
801023a2:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
801023a8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023ac:	66 83 f8 01          	cmp    $0x1,%ax
801023b0:	74 0d                	je     801023bf <dirlookup+0x20>
    panic("dirlookup not DIR");
801023b2:	83 ec 0c             	sub    $0xc,%esp
801023b5:	68 2f a2 10 80       	push   $0x8010a22f
801023ba:	e8 a7 e1 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801023bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801023c6:	eb 7b                	jmp    80102443 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023c8:	6a 10                	push   $0x10
801023ca:	ff 75 f4             	pushl  -0xc(%ebp)
801023cd:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023d0:	50                   	push   %eax
801023d1:	ff 75 08             	pushl  0x8(%ebp)
801023d4:	e8 cc fc ff ff       	call   801020a5 <readi>
801023d9:	83 c4 10             	add    $0x10,%esp
801023dc:	83 f8 10             	cmp    $0x10,%eax
801023df:	74 0d                	je     801023ee <dirlookup+0x4f>
      panic("dirlink read");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 41 a2 10 80       	push   $0x8010a241
801023e9:	e8 78 e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801023ee:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801023f2:	66 85 c0             	test   %ax,%ax
801023f5:	74 47                	je     8010243e <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801023f7:	83 ec 08             	sub    $0x8,%esp
801023fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023fd:	83 c0 02             	add    $0x2,%eax
80102400:	50                   	push   %eax
80102401:	ff 75 0c             	pushl  0xc(%ebp)
80102404:	e8 7b ff ff ff       	call   80102384 <namecmp>
80102409:	83 c4 10             	add    $0x10,%esp
8010240c:	85 c0                	test   %eax,%eax
8010240e:	75 2f                	jne    8010243f <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102410:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102414:	74 08                	je     8010241e <dirlookup+0x7f>
        *poff = off;
80102416:	8b 45 10             	mov    0x10(%ebp),%eax
80102419:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010241c:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010241e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102422:	0f b7 c0             	movzwl %ax,%eax
80102425:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102428:	8b 45 08             	mov    0x8(%ebp),%eax
8010242b:	8b 00                	mov    (%eax),%eax
8010242d:	83 ec 08             	sub    $0x8,%esp
80102430:	ff 75 f0             	pushl  -0x10(%ebp)
80102433:	50                   	push   %eax
80102434:	e8 95 f5 ff ff       	call   801019ce <iget>
80102439:	83 c4 10             	add    $0x10,%esp
8010243c:	eb 19                	jmp    80102457 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010243e:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010243f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102443:	8b 45 08             	mov    0x8(%ebp),%eax
80102446:	8b 40 20             	mov    0x20(%eax),%eax
80102449:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010244c:	0f 87 76 ff ff ff    	ja     801023c8 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102452:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102457:	c9                   	leave  
80102458:	c3                   	ret    

80102459 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102459:	55                   	push   %ebp
8010245a:	89 e5                	mov    %esp,%ebp
8010245c:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010245f:	83 ec 04             	sub    $0x4,%esp
80102462:	6a 00                	push   $0x0
80102464:	ff 75 0c             	pushl  0xc(%ebp)
80102467:	ff 75 08             	pushl  0x8(%ebp)
8010246a:	e8 30 ff ff ff       	call   8010239f <dirlookup>
8010246f:	83 c4 10             	add    $0x10,%esp
80102472:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102475:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102479:	74 18                	je     80102493 <dirlink+0x3a>
    iput(ip);
8010247b:	83 ec 0c             	sub    $0xc,%esp
8010247e:	ff 75 f0             	pushl  -0x10(%ebp)
80102481:	e8 59 f8 ff ff       	call   80101cdf <iput>
80102486:	83 c4 10             	add    $0x10,%esp
    return -1;
80102489:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010248e:	e9 9c 00 00 00       	jmp    8010252f <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102493:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010249a:	eb 39                	jmp    801024d5 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010249f:	6a 10                	push   $0x10
801024a1:	50                   	push   %eax
801024a2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024a5:	50                   	push   %eax
801024a6:	ff 75 08             	pushl  0x8(%ebp)
801024a9:	e8 f7 fb ff ff       	call   801020a5 <readi>
801024ae:	83 c4 10             	add    $0x10,%esp
801024b1:	83 f8 10             	cmp    $0x10,%eax
801024b4:	74 0d                	je     801024c3 <dirlink+0x6a>
      panic("dirlink read");
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	68 41 a2 10 80       	push   $0x8010a241
801024be:	e8 a3 e0 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801024c3:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801024c7:	66 85 c0             	test   %ax,%ax
801024ca:	74 18                	je     801024e4 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024cf:	83 c0 10             	add    $0x10,%eax
801024d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024d5:	8b 45 08             	mov    0x8(%ebp),%eax
801024d8:	8b 50 20             	mov    0x20(%eax),%edx
801024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024de:	39 c2                	cmp    %eax,%edx
801024e0:	77 ba                	ja     8010249c <dirlink+0x43>
801024e2:	eb 01                	jmp    801024e5 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801024e4:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801024e5:	83 ec 04             	sub    $0x4,%esp
801024e8:	6a 0e                	push   $0xe
801024ea:	ff 75 0c             	pushl  0xc(%ebp)
801024ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024f0:	83 c0 02             	add    $0x2,%eax
801024f3:	50                   	push   %eax
801024f4:	e8 ce 47 00 00       	call   80106cc7 <strncpy>
801024f9:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801024fc:	8b 45 10             	mov    0x10(%ebp),%eax
801024ff:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102506:	6a 10                	push   $0x10
80102508:	50                   	push   %eax
80102509:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010250c:	50                   	push   %eax
8010250d:	ff 75 08             	pushl  0x8(%ebp)
80102510:	e8 e7 fc ff ff       	call   801021fc <writei>
80102515:	83 c4 10             	add    $0x10,%esp
80102518:	83 f8 10             	cmp    $0x10,%eax
8010251b:	74 0d                	je     8010252a <dirlink+0xd1>
    panic("dirlink");
8010251d:	83 ec 0c             	sub    $0xc,%esp
80102520:	68 4e a2 10 80       	push   $0x8010a24e
80102525:	e8 3c e0 ff ff       	call   80100566 <panic>
  
  return 0;
8010252a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010252f:	c9                   	leave  
80102530:	c3                   	ret    

80102531 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102531:	55                   	push   %ebp
80102532:	89 e5                	mov    %esp,%ebp
80102534:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102537:	eb 04                	jmp    8010253d <skipelem+0xc>
    path++;
80102539:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010253d:	8b 45 08             	mov    0x8(%ebp),%eax
80102540:	0f b6 00             	movzbl (%eax),%eax
80102543:	3c 2f                	cmp    $0x2f,%al
80102545:	74 f2                	je     80102539 <skipelem+0x8>
    path++;
  if(*path == 0)
80102547:	8b 45 08             	mov    0x8(%ebp),%eax
8010254a:	0f b6 00             	movzbl (%eax),%eax
8010254d:	84 c0                	test   %al,%al
8010254f:	75 07                	jne    80102558 <skipelem+0x27>
    return 0;
80102551:	b8 00 00 00 00       	mov    $0x0,%eax
80102556:	eb 7b                	jmp    801025d3 <skipelem+0xa2>
  s = path;
80102558:	8b 45 08             	mov    0x8(%ebp),%eax
8010255b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010255e:	eb 04                	jmp    80102564 <skipelem+0x33>
    path++;
80102560:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
80102567:	0f b6 00             	movzbl (%eax),%eax
8010256a:	3c 2f                	cmp    $0x2f,%al
8010256c:	74 0a                	je     80102578 <skipelem+0x47>
8010256e:	8b 45 08             	mov    0x8(%ebp),%eax
80102571:	0f b6 00             	movzbl (%eax),%eax
80102574:	84 c0                	test   %al,%al
80102576:	75 e8                	jne    80102560 <skipelem+0x2f>
    path++;
  len = path - s;
80102578:	8b 55 08             	mov    0x8(%ebp),%edx
8010257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010257e:	29 c2                	sub    %eax,%edx
80102580:	89 d0                	mov    %edx,%eax
80102582:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102585:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102589:	7e 15                	jle    801025a0 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010258b:	83 ec 04             	sub    $0x4,%esp
8010258e:	6a 0e                	push   $0xe
80102590:	ff 75 f4             	pushl  -0xc(%ebp)
80102593:	ff 75 0c             	pushl  0xc(%ebp)
80102596:	e8 40 46 00 00       	call   80106bdb <memmove>
8010259b:	83 c4 10             	add    $0x10,%esp
8010259e:	eb 26                	jmp    801025c6 <skipelem+0x95>
  else {
    memmove(name, s, len);
801025a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025a3:	83 ec 04             	sub    $0x4,%esp
801025a6:	50                   	push   %eax
801025a7:	ff 75 f4             	pushl  -0xc(%ebp)
801025aa:	ff 75 0c             	pushl  0xc(%ebp)
801025ad:	e8 29 46 00 00       	call   80106bdb <memmove>
801025b2:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801025b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801025b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801025bb:	01 d0                	add    %edx,%eax
801025bd:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801025c0:	eb 04                	jmp    801025c6 <skipelem+0x95>
    path++;
801025c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801025c6:	8b 45 08             	mov    0x8(%ebp),%eax
801025c9:	0f b6 00             	movzbl (%eax),%eax
801025cc:	3c 2f                	cmp    $0x2f,%al
801025ce:	74 f2                	je     801025c2 <skipelem+0x91>
    path++;
  return path;
801025d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801025d3:	c9                   	leave  
801025d4:	c3                   	ret    

801025d5 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801025d5:	55                   	push   %ebp
801025d6:	89 e5                	mov    %esp,%ebp
801025d8:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801025db:	8b 45 08             	mov    0x8(%ebp),%eax
801025de:	0f b6 00             	movzbl (%eax),%eax
801025e1:	3c 2f                	cmp    $0x2f,%al
801025e3:	75 17                	jne    801025fc <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801025e5:	83 ec 08             	sub    $0x8,%esp
801025e8:	6a 01                	push   $0x1
801025ea:	6a 01                	push   $0x1
801025ec:	e8 dd f3 ff ff       	call   801019ce <iget>
801025f1:	83 c4 10             	add    $0x10,%esp
801025f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801025f7:	e9 bb 00 00 00       	jmp    801026b7 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801025fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102602:	8b 40 68             	mov    0x68(%eax),%eax
80102605:	83 ec 0c             	sub    $0xc,%esp
80102608:	50                   	push   %eax
80102609:	e8 9f f4 ff ff       	call   80101aad <idup>
8010260e:	83 c4 10             	add    $0x10,%esp
80102611:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102614:	e9 9e 00 00 00       	jmp    801026b7 <namex+0xe2>
    ilock(ip);
80102619:	83 ec 0c             	sub    $0xc,%esp
8010261c:	ff 75 f4             	pushl  -0xc(%ebp)
8010261f:	e8 c3 f4 ff ff       	call   80101ae7 <ilock>
80102624:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102627:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010262a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010262e:	66 83 f8 01          	cmp    $0x1,%ax
80102632:	74 18                	je     8010264c <namex+0x77>
      iunlockput(ip);
80102634:	83 ec 0c             	sub    $0xc,%esp
80102637:	ff 75 f4             	pushl  -0xc(%ebp)
8010263a:	e8 90 f7 ff ff       	call   80101dcf <iunlockput>
8010263f:	83 c4 10             	add    $0x10,%esp
      return 0;
80102642:	b8 00 00 00 00       	mov    $0x0,%eax
80102647:	e9 a7 00 00 00       	jmp    801026f3 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
8010264c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102650:	74 20                	je     80102672 <namex+0x9d>
80102652:	8b 45 08             	mov    0x8(%ebp),%eax
80102655:	0f b6 00             	movzbl (%eax),%eax
80102658:	84 c0                	test   %al,%al
8010265a:	75 16                	jne    80102672 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
8010265c:	83 ec 0c             	sub    $0xc,%esp
8010265f:	ff 75 f4             	pushl  -0xc(%ebp)
80102662:	e8 06 f6 ff ff       	call   80101c6d <iunlock>
80102667:	83 c4 10             	add    $0x10,%esp
      return ip;
8010266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010266d:	e9 81 00 00 00       	jmp    801026f3 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102672:	83 ec 04             	sub    $0x4,%esp
80102675:	6a 00                	push   $0x0
80102677:	ff 75 10             	pushl  0x10(%ebp)
8010267a:	ff 75 f4             	pushl  -0xc(%ebp)
8010267d:	e8 1d fd ff ff       	call   8010239f <dirlookup>
80102682:	83 c4 10             	add    $0x10,%esp
80102685:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102688:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010268c:	75 15                	jne    801026a3 <namex+0xce>
      iunlockput(ip);
8010268e:	83 ec 0c             	sub    $0xc,%esp
80102691:	ff 75 f4             	pushl  -0xc(%ebp)
80102694:	e8 36 f7 ff ff       	call   80101dcf <iunlockput>
80102699:	83 c4 10             	add    $0x10,%esp
      return 0;
8010269c:	b8 00 00 00 00       	mov    $0x0,%eax
801026a1:	eb 50                	jmp    801026f3 <namex+0x11e>
    }
    iunlockput(ip);
801026a3:	83 ec 0c             	sub    $0xc,%esp
801026a6:	ff 75 f4             	pushl  -0xc(%ebp)
801026a9:	e8 21 f7 ff ff       	call   80101dcf <iunlockput>
801026ae:	83 c4 10             	add    $0x10,%esp
    ip = next;
801026b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801026b7:	83 ec 08             	sub    $0x8,%esp
801026ba:	ff 75 10             	pushl  0x10(%ebp)
801026bd:	ff 75 08             	pushl  0x8(%ebp)
801026c0:	e8 6c fe ff ff       	call   80102531 <skipelem>
801026c5:	83 c4 10             	add    $0x10,%esp
801026c8:	89 45 08             	mov    %eax,0x8(%ebp)
801026cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026cf:	0f 85 44 ff ff ff    	jne    80102619 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801026d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801026d9:	74 15                	je     801026f0 <namex+0x11b>
    iput(ip);
801026db:	83 ec 0c             	sub    $0xc,%esp
801026de:	ff 75 f4             	pushl  -0xc(%ebp)
801026e1:	e8 f9 f5 ff ff       	call   80101cdf <iput>
801026e6:	83 c4 10             	add    $0x10,%esp
    return 0;
801026e9:	b8 00 00 00 00       	mov    $0x0,%eax
801026ee:	eb 03                	jmp    801026f3 <namex+0x11e>
  }
  return ip;
801026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801026f3:	c9                   	leave  
801026f4:	c3                   	ret    

801026f5 <namei>:

struct inode*
namei(char *path)
{
801026f5:	55                   	push   %ebp
801026f6:	89 e5                	mov    %esp,%ebp
801026f8:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801026fb:	83 ec 04             	sub    $0x4,%esp
801026fe:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102701:	50                   	push   %eax
80102702:	6a 00                	push   $0x0
80102704:	ff 75 08             	pushl  0x8(%ebp)
80102707:	e8 c9 fe ff ff       	call   801025d5 <namex>
8010270c:	83 c4 10             	add    $0x10,%esp
}
8010270f:	c9                   	leave  
80102710:	c3                   	ret    

80102711 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102711:	55                   	push   %ebp
80102712:	89 e5                	mov    %esp,%ebp
80102714:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102717:	83 ec 04             	sub    $0x4,%esp
8010271a:	ff 75 0c             	pushl  0xc(%ebp)
8010271d:	6a 01                	push   $0x1
8010271f:	ff 75 08             	pushl  0x8(%ebp)
80102722:	e8 ae fe ff ff       	call   801025d5 <namex>
80102727:	83 c4 10             	add    $0x10,%esp
}
8010272a:	c9                   	leave  
8010272b:	c3                   	ret    

8010272c <chown_helper>:

#ifdef CS333_P5
int
chown_helper(char *pathname, int uowner)
{
8010272c:	55                   	push   %ebp
8010272d:	89 e5                	mov    %esp,%ebp
8010272f:	83 ec 18             	sub    $0x18,%esp
  begin_op();
80102732:	e8 30 11 00 00       	call   80103867 <begin_op>
  struct inode *in = namei(pathname);
80102737:	83 ec 0c             	sub    $0xc,%esp
8010273a:	ff 75 08             	pushl  0x8(%ebp)
8010273d:	e8 b3 ff ff ff       	call   801026f5 <namei>
80102742:	83 c4 10             	add    $0x10,%esp
80102745:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!in) {
80102748:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010274c:	75 0c                	jne    8010275a <chown_helper+0x2e>
    end_op();
8010274e:	e8 a0 11 00 00       	call   801038f3 <end_op>
    return -1;
80102753:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102758:	eb 40                	jmp    8010279a <chown_helper+0x6e>
  } else {
    ilock(in);
8010275a:	83 ec 0c             	sub    $0xc,%esp
8010275d:	ff 75 f4             	pushl  -0xc(%ebp)
80102760:	e8 82 f3 ff ff       	call   80101ae7 <ilock>
80102765:	83 c4 10             	add    $0x10,%esp
    in->uid = uowner;
80102768:	8b 45 0c             	mov    0xc(%ebp),%eax
8010276b:	89 c2                	mov    %eax,%edx
8010276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102770:	66 89 50 18          	mov    %dx,0x18(%eax)
    iupdate(in);
80102774:	83 ec 0c             	sub    $0xc,%esp
80102777:	ff 75 f4             	pushl  -0xc(%ebp)
8010277a:	e8 66 f1 ff ff       	call   801018e5 <iupdate>
8010277f:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(in);
80102782:	83 ec 0c             	sub    $0xc,%esp
80102785:	ff 75 f4             	pushl  -0xc(%ebp)
80102788:	e8 e0 f4 ff ff       	call   80101c6d <iunlock>
8010278d:	83 c4 10             	add    $0x10,%esp
  end_op();
80102790:	e8 5e 11 00 00       	call   801038f3 <end_op>
  return 0;
80102795:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010279a:	c9                   	leave  
8010279b:	c3                   	ret    

8010279c <chgrp_helper>:

int
chgrp_helper(char *pathname, int gowner)
{
8010279c:	55                   	push   %ebp
8010279d:	89 e5                	mov    %esp,%ebp
8010279f:	83 ec 18             	sub    $0x18,%esp
  begin_op();
801027a2:	e8 c0 10 00 00       	call   80103867 <begin_op>
  struct inode *in = namei(pathname);
801027a7:	83 ec 0c             	sub    $0xc,%esp
801027aa:	ff 75 08             	pushl  0x8(%ebp)
801027ad:	e8 43 ff ff ff       	call   801026f5 <namei>
801027b2:	83 c4 10             	add    $0x10,%esp
801027b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!in) {
801027b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027bc:	75 0c                	jne    801027ca <chgrp_helper+0x2e>
    end_op();
801027be:	e8 30 11 00 00       	call   801038f3 <end_op>
    return -1;
801027c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801027c8:	eb 40                	jmp    8010280a <chgrp_helper+0x6e>
  } else {
    ilock(in);
801027ca:	83 ec 0c             	sub    $0xc,%esp
801027cd:	ff 75 f4             	pushl  -0xc(%ebp)
801027d0:	e8 12 f3 ff ff       	call   80101ae7 <ilock>
801027d5:	83 c4 10             	add    $0x10,%esp
    in->gid = gowner;
801027d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801027db:	89 c2                	mov    %eax,%edx
801027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e0:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    iupdate(in);
801027e4:	83 ec 0c             	sub    $0xc,%esp
801027e7:	ff 75 f4             	pushl  -0xc(%ebp)
801027ea:	e8 f6 f0 ff ff       	call   801018e5 <iupdate>
801027ef:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(in);
801027f2:	83 ec 0c             	sub    $0xc,%esp
801027f5:	ff 75 f4             	pushl  -0xc(%ebp)
801027f8:	e8 70 f4 ff ff       	call   80101c6d <iunlock>
801027fd:	83 c4 10             	add    $0x10,%esp
  end_op();
80102800:	e8 ee 10 00 00       	call   801038f3 <end_op>
  return 0;
80102805:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010280a:	c9                   	leave  
8010280b:	c3                   	ret    

8010280c <chmod_helper>:

int
chmod_helper(char *pathname, int mode)
{
8010280c:	55                   	push   %ebp
8010280d:	89 e5                	mov    %esp,%ebp
8010280f:	83 ec 18             	sub    $0x18,%esp
  begin_op();
80102812:	e8 50 10 00 00       	call   80103867 <begin_op>
  struct inode *in = namei(pathname);
80102817:	83 ec 0c             	sub    $0xc,%esp
8010281a:	ff 75 08             	pushl  0x8(%ebp)
8010281d:	e8 d3 fe ff ff       	call   801026f5 <namei>
80102822:	83 c4 10             	add    $0x10,%esp
80102825:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!in) {
80102828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010282c:	75 0c                	jne    8010283a <chmod_helper+0x2e>
    end_op();
8010282e:	e8 c0 10 00 00       	call   801038f3 <end_op>
    return -1;
80102833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102838:	eb 3d                	jmp    80102877 <chmod_helper+0x6b>
  } else {
    ilock(in);
8010283a:	83 ec 0c             	sub    $0xc,%esp
8010283d:	ff 75 f4             	pushl  -0xc(%ebp)
80102840:	e8 a2 f2 ff ff       	call   80101ae7 <ilock>
80102845:	83 c4 10             	add    $0x10,%esp
    in->mode.as_int = mode; 
80102848:	8b 55 0c             	mov    0xc(%ebp),%edx
8010284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010284e:	89 50 1c             	mov    %edx,0x1c(%eax)
    iupdate(in);
80102851:	83 ec 0c             	sub    $0xc,%esp
80102854:	ff 75 f4             	pushl  -0xc(%ebp)
80102857:	e8 89 f0 ff ff       	call   801018e5 <iupdate>
8010285c:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(in);
8010285f:	83 ec 0c             	sub    $0xc,%esp
80102862:	ff 75 f4             	pushl  -0xc(%ebp)
80102865:	e8 03 f4 ff ff       	call   80101c6d <iunlock>
8010286a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010286d:	e8 81 10 00 00       	call   801038f3 <end_op>
  return 0;
80102872:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102877:	c9                   	leave  
80102878:	c3                   	ret    

80102879 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102879:	55                   	push   %ebp
8010287a:	89 e5                	mov    %esp,%ebp
8010287c:	83 ec 14             	sub    $0x14,%esp
8010287f:	8b 45 08             	mov    0x8(%ebp),%eax
80102882:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102886:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010288a:	89 c2                	mov    %eax,%edx
8010288c:	ec                   	in     (%dx),%al
8010288d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102890:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102894:	c9                   	leave  
80102895:	c3                   	ret    

80102896 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102896:	55                   	push   %ebp
80102897:	89 e5                	mov    %esp,%ebp
80102899:	57                   	push   %edi
8010289a:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010289b:	8b 55 08             	mov    0x8(%ebp),%edx
8010289e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028a1:	8b 45 10             	mov    0x10(%ebp),%eax
801028a4:	89 cb                	mov    %ecx,%ebx
801028a6:	89 df                	mov    %ebx,%edi
801028a8:	89 c1                	mov    %eax,%ecx
801028aa:	fc                   	cld    
801028ab:	f3 6d                	rep insl (%dx),%es:(%edi)
801028ad:	89 c8                	mov    %ecx,%eax
801028af:	89 fb                	mov    %edi,%ebx
801028b1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801028b4:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801028b7:	90                   	nop
801028b8:	5b                   	pop    %ebx
801028b9:	5f                   	pop    %edi
801028ba:	5d                   	pop    %ebp
801028bb:	c3                   	ret    

801028bc <outb>:

static inline void
outb(ushort port, uchar data)
{
801028bc:	55                   	push   %ebp
801028bd:	89 e5                	mov    %esp,%ebp
801028bf:	83 ec 08             	sub    $0x8,%esp
801028c2:	8b 55 08             	mov    0x8(%ebp),%edx
801028c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801028c8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801028cc:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028cf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801028d3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801028d7:	ee                   	out    %al,(%dx)
}
801028d8:	90                   	nop
801028d9:	c9                   	leave  
801028da:	c3                   	ret    

801028db <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801028db:	55                   	push   %ebp
801028dc:	89 e5                	mov    %esp,%ebp
801028de:	56                   	push   %esi
801028df:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801028e0:	8b 55 08             	mov    0x8(%ebp),%edx
801028e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028e6:	8b 45 10             	mov    0x10(%ebp),%eax
801028e9:	89 cb                	mov    %ecx,%ebx
801028eb:	89 de                	mov    %ebx,%esi
801028ed:	89 c1                	mov    %eax,%ecx
801028ef:	fc                   	cld    
801028f0:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801028f2:	89 c8                	mov    %ecx,%eax
801028f4:	89 f3                	mov    %esi,%ebx
801028f6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801028f9:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801028fc:	90                   	nop
801028fd:	5b                   	pop    %ebx
801028fe:	5e                   	pop    %esi
801028ff:	5d                   	pop    %ebp
80102900:	c3                   	ret    

80102901 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102901:	55                   	push   %ebp
80102902:	89 e5                	mov    %esp,%ebp
80102904:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102907:	90                   	nop
80102908:	68 f7 01 00 00       	push   $0x1f7
8010290d:	e8 67 ff ff ff       	call   80102879 <inb>
80102912:	83 c4 04             	add    $0x4,%esp
80102915:	0f b6 c0             	movzbl %al,%eax
80102918:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010291b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010291e:	25 c0 00 00 00       	and    $0xc0,%eax
80102923:	83 f8 40             	cmp    $0x40,%eax
80102926:	75 e0                	jne    80102908 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102928:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010292c:	74 11                	je     8010293f <idewait+0x3e>
8010292e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102931:	83 e0 21             	and    $0x21,%eax
80102934:	85 c0                	test   %eax,%eax
80102936:	74 07                	je     8010293f <idewait+0x3e>
    return -1;
80102938:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010293d:	eb 05                	jmp    80102944 <idewait+0x43>
  return 0;
8010293f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102944:	c9                   	leave  
80102945:	c3                   	ret    

80102946 <ideinit>:

void
ideinit(void)
{
80102946:	55                   	push   %ebp
80102947:	89 e5                	mov    %esp,%ebp
80102949:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
8010294c:	83 ec 08             	sub    $0x8,%esp
8010294f:	68 56 a2 10 80       	push   $0x8010a256
80102954:	68 40 d6 10 80       	push   $0x8010d640
80102959:	e8 39 3f 00 00       	call   80106897 <initlock>
8010295e:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102961:	83 ec 0c             	sub    $0xc,%esp
80102964:	6a 0e                	push   $0xe
80102966:	e8 da 18 00 00       	call   80104245 <picenable>
8010296b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010296e:	a1 80 49 11 80       	mov    0x80114980,%eax
80102973:	83 e8 01             	sub    $0x1,%eax
80102976:	83 ec 08             	sub    $0x8,%esp
80102979:	50                   	push   %eax
8010297a:	6a 0e                	push   $0xe
8010297c:	e8 73 04 00 00       	call   80102df4 <ioapicenable>
80102981:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102984:	83 ec 0c             	sub    $0xc,%esp
80102987:	6a 00                	push   $0x0
80102989:	e8 73 ff ff ff       	call   80102901 <idewait>
8010298e:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102991:	83 ec 08             	sub    $0x8,%esp
80102994:	68 f0 00 00 00       	push   $0xf0
80102999:	68 f6 01 00 00       	push   $0x1f6
8010299e:	e8 19 ff ff ff       	call   801028bc <outb>
801029a3:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801029a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029ad:	eb 24                	jmp    801029d3 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801029af:	83 ec 0c             	sub    $0xc,%esp
801029b2:	68 f7 01 00 00       	push   $0x1f7
801029b7:	e8 bd fe ff ff       	call   80102879 <inb>
801029bc:	83 c4 10             	add    $0x10,%esp
801029bf:	84 c0                	test   %al,%al
801029c1:	74 0c                	je     801029cf <ideinit+0x89>
      havedisk1 = 1;
801029c3:	c7 05 78 d6 10 80 01 	movl   $0x1,0x8010d678
801029ca:	00 00 00 
      break;
801029cd:	eb 0d                	jmp    801029dc <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801029cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801029d3:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801029da:	7e d3                	jle    801029af <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801029dc:	83 ec 08             	sub    $0x8,%esp
801029df:	68 e0 00 00 00       	push   $0xe0
801029e4:	68 f6 01 00 00       	push   $0x1f6
801029e9:	e8 ce fe ff ff       	call   801028bc <outb>
801029ee:	83 c4 10             	add    $0x10,%esp
}
801029f1:	90                   	nop
801029f2:	c9                   	leave  
801029f3:	c3                   	ret    

801029f4 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801029f4:	55                   	push   %ebp
801029f5:	89 e5                	mov    %esp,%ebp
801029f7:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801029fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801029fe:	75 0d                	jne    80102a0d <idestart+0x19>
    panic("idestart");
80102a00:	83 ec 0c             	sub    $0xc,%esp
80102a03:	68 5a a2 10 80       	push   $0x8010a25a
80102a08:	e8 59 db ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a10:	8b 40 08             	mov    0x8(%eax),%eax
80102a13:	3d cf 07 00 00       	cmp    $0x7cf,%eax
80102a18:	76 0d                	jbe    80102a27 <idestart+0x33>
    panic("incorrect blockno");
80102a1a:	83 ec 0c             	sub    $0xc,%esp
80102a1d:	68 63 a2 10 80       	push   $0x8010a263
80102a22:	e8 3f db ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102a27:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a31:	8b 50 08             	mov    0x8(%eax),%edx
80102a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a37:	0f af c2             	imul   %edx,%eax
80102a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102a3d:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102a41:	7e 0d                	jle    80102a50 <idestart+0x5c>
80102a43:	83 ec 0c             	sub    $0xc,%esp
80102a46:	68 5a a2 10 80       	push   $0x8010a25a
80102a4b:	e8 16 db ff ff       	call   80100566 <panic>
  
  idewait(0);
80102a50:	83 ec 0c             	sub    $0xc,%esp
80102a53:	6a 00                	push   $0x0
80102a55:	e8 a7 fe ff ff       	call   80102901 <idewait>
80102a5a:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102a5d:	83 ec 08             	sub    $0x8,%esp
80102a60:	6a 00                	push   $0x0
80102a62:	68 f6 03 00 00       	push   $0x3f6
80102a67:	e8 50 fe ff ff       	call   801028bc <outb>
80102a6c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a72:	0f b6 c0             	movzbl %al,%eax
80102a75:	83 ec 08             	sub    $0x8,%esp
80102a78:	50                   	push   %eax
80102a79:	68 f2 01 00 00       	push   $0x1f2
80102a7e:	e8 39 fe ff ff       	call   801028bc <outb>
80102a83:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a89:	0f b6 c0             	movzbl %al,%eax
80102a8c:	83 ec 08             	sub    $0x8,%esp
80102a8f:	50                   	push   %eax
80102a90:	68 f3 01 00 00       	push   $0x1f3
80102a95:	e8 22 fe ff ff       	call   801028bc <outb>
80102a9a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102aa0:	c1 f8 08             	sar    $0x8,%eax
80102aa3:	0f b6 c0             	movzbl %al,%eax
80102aa6:	83 ec 08             	sub    $0x8,%esp
80102aa9:	50                   	push   %eax
80102aaa:	68 f4 01 00 00       	push   $0x1f4
80102aaf:	e8 08 fe ff ff       	call   801028bc <outb>
80102ab4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102aba:	c1 f8 10             	sar    $0x10,%eax
80102abd:	0f b6 c0             	movzbl %al,%eax
80102ac0:	83 ec 08             	sub    $0x8,%esp
80102ac3:	50                   	push   %eax
80102ac4:	68 f5 01 00 00       	push   $0x1f5
80102ac9:	e8 ee fd ff ff       	call   801028bc <outb>
80102ace:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80102ad4:	8b 40 04             	mov    0x4(%eax),%eax
80102ad7:	83 e0 01             	and    $0x1,%eax
80102ada:	c1 e0 04             	shl    $0x4,%eax
80102add:	89 c2                	mov    %eax,%edx
80102adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ae2:	c1 f8 18             	sar    $0x18,%eax
80102ae5:	83 e0 0f             	and    $0xf,%eax
80102ae8:	09 d0                	or     %edx,%eax
80102aea:	83 c8 e0             	or     $0xffffffe0,%eax
80102aed:	0f b6 c0             	movzbl %al,%eax
80102af0:	83 ec 08             	sub    $0x8,%esp
80102af3:	50                   	push   %eax
80102af4:	68 f6 01 00 00       	push   $0x1f6
80102af9:	e8 be fd ff ff       	call   801028bc <outb>
80102afe:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102b01:	8b 45 08             	mov    0x8(%ebp),%eax
80102b04:	8b 00                	mov    (%eax),%eax
80102b06:	83 e0 04             	and    $0x4,%eax
80102b09:	85 c0                	test   %eax,%eax
80102b0b:	74 30                	je     80102b3d <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102b0d:	83 ec 08             	sub    $0x8,%esp
80102b10:	6a 30                	push   $0x30
80102b12:	68 f7 01 00 00       	push   $0x1f7
80102b17:	e8 a0 fd ff ff       	call   801028bc <outb>
80102b1c:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b22:	83 c0 18             	add    $0x18,%eax
80102b25:	83 ec 04             	sub    $0x4,%esp
80102b28:	68 80 00 00 00       	push   $0x80
80102b2d:	50                   	push   %eax
80102b2e:	68 f0 01 00 00       	push   $0x1f0
80102b33:	e8 a3 fd ff ff       	call   801028db <outsl>
80102b38:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102b3b:	eb 12                	jmp    80102b4f <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102b3d:	83 ec 08             	sub    $0x8,%esp
80102b40:	6a 20                	push   $0x20
80102b42:	68 f7 01 00 00       	push   $0x1f7
80102b47:	e8 70 fd ff ff       	call   801028bc <outb>
80102b4c:	83 c4 10             	add    $0x10,%esp
  }
}
80102b4f:	90                   	nop
80102b50:	c9                   	leave  
80102b51:	c3                   	ret    

80102b52 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102b52:	55                   	push   %ebp
80102b53:	89 e5                	mov    %esp,%ebp
80102b55:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102b58:	83 ec 0c             	sub    $0xc,%esp
80102b5b:	68 40 d6 10 80       	push   $0x8010d640
80102b60:	e8 54 3d 00 00       	call   801068b9 <acquire>
80102b65:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102b68:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b74:	75 15                	jne    80102b8b <ideintr+0x39>
    release(&idelock);
80102b76:	83 ec 0c             	sub    $0xc,%esp
80102b79:	68 40 d6 10 80       	push   $0x8010d640
80102b7e:	e8 9d 3d 00 00       	call   80106920 <release>
80102b83:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102b86:	e9 9a 00 00 00       	jmp    80102c25 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b8e:	8b 40 14             	mov    0x14(%eax),%eax
80102b91:	a3 74 d6 10 80       	mov    %eax,0x8010d674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b99:	8b 00                	mov    (%eax),%eax
80102b9b:	83 e0 04             	and    $0x4,%eax
80102b9e:	85 c0                	test   %eax,%eax
80102ba0:	75 2d                	jne    80102bcf <ideintr+0x7d>
80102ba2:	83 ec 0c             	sub    $0xc,%esp
80102ba5:	6a 01                	push   $0x1
80102ba7:	e8 55 fd ff ff       	call   80102901 <idewait>
80102bac:	83 c4 10             	add    $0x10,%esp
80102baf:	85 c0                	test   %eax,%eax
80102bb1:	78 1c                	js     80102bcf <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb6:	83 c0 18             	add    $0x18,%eax
80102bb9:	83 ec 04             	sub    $0x4,%esp
80102bbc:	68 80 00 00 00       	push   $0x80
80102bc1:	50                   	push   %eax
80102bc2:	68 f0 01 00 00       	push   $0x1f0
80102bc7:	e8 ca fc ff ff       	call   80102896 <insl>
80102bcc:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bd2:	8b 00                	mov    (%eax),%eax
80102bd4:	83 c8 02             	or     $0x2,%eax
80102bd7:	89 c2                	mov    %eax,%edx
80102bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bdc:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102be1:	8b 00                	mov    (%eax),%eax
80102be3:	83 e0 fb             	and    $0xfffffffb,%eax
80102be6:	89 c2                	mov    %eax,%edx
80102be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102beb:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102bed:	83 ec 0c             	sub    $0xc,%esp
80102bf0:	ff 75 f4             	pushl  -0xc(%ebp)
80102bf3:	e8 0c 2c 00 00       	call   80105804 <wakeup>
80102bf8:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102bfb:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102c00:	85 c0                	test   %eax,%eax
80102c02:	74 11                	je     80102c15 <ideintr+0xc3>
    idestart(idequeue);
80102c04:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102c09:	83 ec 0c             	sub    $0xc,%esp
80102c0c:	50                   	push   %eax
80102c0d:	e8 e2 fd ff ff       	call   801029f4 <idestart>
80102c12:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102c15:	83 ec 0c             	sub    $0xc,%esp
80102c18:	68 40 d6 10 80       	push   $0x8010d640
80102c1d:	e8 fe 3c 00 00       	call   80106920 <release>
80102c22:	83 c4 10             	add    $0x10,%esp
}
80102c25:	c9                   	leave  
80102c26:	c3                   	ret    

80102c27 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102c27:	55                   	push   %ebp
80102c28:	89 e5                	mov    %esp,%ebp
80102c2a:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102c2d:	8b 45 08             	mov    0x8(%ebp),%eax
80102c30:	8b 00                	mov    (%eax),%eax
80102c32:	83 e0 01             	and    $0x1,%eax
80102c35:	85 c0                	test   %eax,%eax
80102c37:	75 0d                	jne    80102c46 <iderw+0x1f>
    panic("iderw: buf not busy");
80102c39:	83 ec 0c             	sub    $0xc,%esp
80102c3c:	68 75 a2 10 80       	push   $0x8010a275
80102c41:	e8 20 d9 ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102c46:	8b 45 08             	mov    0x8(%ebp),%eax
80102c49:	8b 00                	mov    (%eax),%eax
80102c4b:	83 e0 06             	and    $0x6,%eax
80102c4e:	83 f8 02             	cmp    $0x2,%eax
80102c51:	75 0d                	jne    80102c60 <iderw+0x39>
    panic("iderw: nothing to do");
80102c53:	83 ec 0c             	sub    $0xc,%esp
80102c56:	68 89 a2 10 80       	push   $0x8010a289
80102c5b:	e8 06 d9 ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102c60:	8b 45 08             	mov    0x8(%ebp),%eax
80102c63:	8b 40 04             	mov    0x4(%eax),%eax
80102c66:	85 c0                	test   %eax,%eax
80102c68:	74 16                	je     80102c80 <iderw+0x59>
80102c6a:	a1 78 d6 10 80       	mov    0x8010d678,%eax
80102c6f:	85 c0                	test   %eax,%eax
80102c71:	75 0d                	jne    80102c80 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102c73:	83 ec 0c             	sub    $0xc,%esp
80102c76:	68 9e a2 10 80       	push   $0x8010a29e
80102c7b:	e8 e6 d8 ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102c80:	83 ec 0c             	sub    $0xc,%esp
80102c83:	68 40 d6 10 80       	push   $0x8010d640
80102c88:	e8 2c 3c 00 00       	call   801068b9 <acquire>
80102c8d:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102c90:	8b 45 08             	mov    0x8(%ebp),%eax
80102c93:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c9a:	c7 45 f4 74 d6 10 80 	movl   $0x8010d674,-0xc(%ebp)
80102ca1:	eb 0b                	jmp    80102cae <iderw+0x87>
80102ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ca6:	8b 00                	mov    (%eax),%eax
80102ca8:	83 c0 14             	add    $0x14,%eax
80102cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cb1:	8b 00                	mov    (%eax),%eax
80102cb3:	85 c0                	test   %eax,%eax
80102cb5:	75 ec                	jne    80102ca3 <iderw+0x7c>
    ;
  *pp = b;
80102cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cba:	8b 55 08             	mov    0x8(%ebp),%edx
80102cbd:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102cbf:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102cc4:	3b 45 08             	cmp    0x8(%ebp),%eax
80102cc7:	75 23                	jne    80102cec <iderw+0xc5>
    idestart(b);
80102cc9:	83 ec 0c             	sub    $0xc,%esp
80102ccc:	ff 75 08             	pushl  0x8(%ebp)
80102ccf:	e8 20 fd ff ff       	call   801029f4 <idestart>
80102cd4:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102cd7:	eb 13                	jmp    80102cec <iderw+0xc5>
    sleep(b, &idelock);
80102cd9:	83 ec 08             	sub    $0x8,%esp
80102cdc:	68 40 d6 10 80       	push   $0x8010d640
80102ce1:	ff 75 08             	pushl  0x8(%ebp)
80102ce4:	e8 42 29 00 00       	call   8010562b <sleep>
80102ce9:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102cec:	8b 45 08             	mov    0x8(%ebp),%eax
80102cef:	8b 00                	mov    (%eax),%eax
80102cf1:	83 e0 06             	and    $0x6,%eax
80102cf4:	83 f8 02             	cmp    $0x2,%eax
80102cf7:	75 e0                	jne    80102cd9 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102cf9:	83 ec 0c             	sub    $0xc,%esp
80102cfc:	68 40 d6 10 80       	push   $0x8010d640
80102d01:	e8 1a 3c 00 00       	call   80106920 <release>
80102d06:	83 c4 10             	add    $0x10,%esp
}
80102d09:	90                   	nop
80102d0a:	c9                   	leave  
80102d0b:	c3                   	ret    

80102d0c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102d0c:	55                   	push   %ebp
80102d0d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102d0f:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d14:	8b 55 08             	mov    0x8(%ebp),%edx
80102d17:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102d19:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d1e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102d21:	5d                   	pop    %ebp
80102d22:	c3                   	ret    

80102d23 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102d23:	55                   	push   %ebp
80102d24:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102d26:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d2b:	8b 55 08             	mov    0x8(%ebp),%edx
80102d2e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102d30:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d35:	8b 55 0c             	mov    0xc(%ebp),%edx
80102d38:	89 50 10             	mov    %edx,0x10(%eax)
}
80102d3b:	90                   	nop
80102d3c:	5d                   	pop    %ebp
80102d3d:	c3                   	ret    

80102d3e <ioapicinit>:

void
ioapicinit(void)
{
80102d3e:	55                   	push   %ebp
80102d3f:	89 e5                	mov    %esp,%ebp
80102d41:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102d44:	a1 84 43 11 80       	mov    0x80114384,%eax
80102d49:	85 c0                	test   %eax,%eax
80102d4b:	0f 84 a0 00 00 00    	je     80102df1 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102d51:	c7 05 54 42 11 80 00 	movl   $0xfec00000,0x80114254
80102d58:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102d5b:	6a 01                	push   $0x1
80102d5d:	e8 aa ff ff ff       	call   80102d0c <ioapicread>
80102d62:	83 c4 04             	add    $0x4,%esp
80102d65:	c1 e8 10             	shr    $0x10,%eax
80102d68:	25 ff 00 00 00       	and    $0xff,%eax
80102d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102d70:	6a 00                	push   $0x0
80102d72:	e8 95 ff ff ff       	call   80102d0c <ioapicread>
80102d77:	83 c4 04             	add    $0x4,%esp
80102d7a:	c1 e8 18             	shr    $0x18,%eax
80102d7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102d80:	0f b6 05 80 43 11 80 	movzbl 0x80114380,%eax
80102d87:	0f b6 c0             	movzbl %al,%eax
80102d8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102d8d:	74 10                	je     80102d9f <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102d8f:	83 ec 0c             	sub    $0xc,%esp
80102d92:	68 bc a2 10 80       	push   $0x8010a2bc
80102d97:	e8 2a d6 ff ff       	call   801003c6 <cprintf>
80102d9c:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102d9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102da6:	eb 3f                	jmp    80102de7 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dab:	83 c0 20             	add    $0x20,%eax
80102dae:	0d 00 00 01 00       	or     $0x10000,%eax
80102db3:	89 c2                	mov    %eax,%edx
80102db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102db8:	83 c0 08             	add    $0x8,%eax
80102dbb:	01 c0                	add    %eax,%eax
80102dbd:	83 ec 08             	sub    $0x8,%esp
80102dc0:	52                   	push   %edx
80102dc1:	50                   	push   %eax
80102dc2:	e8 5c ff ff ff       	call   80102d23 <ioapicwrite>
80102dc7:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dcd:	83 c0 08             	add    $0x8,%eax
80102dd0:	01 c0                	add    %eax,%eax
80102dd2:	83 c0 01             	add    $0x1,%eax
80102dd5:	83 ec 08             	sub    $0x8,%esp
80102dd8:	6a 00                	push   $0x0
80102dda:	50                   	push   %eax
80102ddb:	e8 43 ff ff ff       	call   80102d23 <ioapicwrite>
80102de0:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102de3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102ded:	7e b9                	jle    80102da8 <ioapicinit+0x6a>
80102def:	eb 01                	jmp    80102df2 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102df1:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102df2:	c9                   	leave  
80102df3:	c3                   	ret    

80102df4 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102df4:	55                   	push   %ebp
80102df5:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102df7:	a1 84 43 11 80       	mov    0x80114384,%eax
80102dfc:	85 c0                	test   %eax,%eax
80102dfe:	74 39                	je     80102e39 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102e00:	8b 45 08             	mov    0x8(%ebp),%eax
80102e03:	83 c0 20             	add    $0x20,%eax
80102e06:	89 c2                	mov    %eax,%edx
80102e08:	8b 45 08             	mov    0x8(%ebp),%eax
80102e0b:	83 c0 08             	add    $0x8,%eax
80102e0e:	01 c0                	add    %eax,%eax
80102e10:	52                   	push   %edx
80102e11:	50                   	push   %eax
80102e12:	e8 0c ff ff ff       	call   80102d23 <ioapicwrite>
80102e17:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e1d:	c1 e0 18             	shl    $0x18,%eax
80102e20:	89 c2                	mov    %eax,%edx
80102e22:	8b 45 08             	mov    0x8(%ebp),%eax
80102e25:	83 c0 08             	add    $0x8,%eax
80102e28:	01 c0                	add    %eax,%eax
80102e2a:	83 c0 01             	add    $0x1,%eax
80102e2d:	52                   	push   %edx
80102e2e:	50                   	push   %eax
80102e2f:	e8 ef fe ff ff       	call   80102d23 <ioapicwrite>
80102e34:	83 c4 08             	add    $0x8,%esp
80102e37:	eb 01                	jmp    80102e3a <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102e39:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102e3a:	c9                   	leave  
80102e3b:	c3                   	ret    

80102e3c <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102e3c:	55                   	push   %ebp
80102e3d:	89 e5                	mov    %esp,%ebp
80102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80102e42:	05 00 00 00 80       	add    $0x80000000,%eax
80102e47:	5d                   	pop    %ebp
80102e48:	c3                   	ret    

80102e49 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102e49:	55                   	push   %ebp
80102e4a:	89 e5                	mov    %esp,%ebp
80102e4c:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102e4f:	83 ec 08             	sub    $0x8,%esp
80102e52:	68 ee a2 10 80       	push   $0x8010a2ee
80102e57:	68 60 42 11 80       	push   $0x80114260
80102e5c:	e8 36 3a 00 00       	call   80106897 <initlock>
80102e61:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102e64:	c7 05 94 42 11 80 00 	movl   $0x0,0x80114294
80102e6b:	00 00 00 
  freerange(vstart, vend);
80102e6e:	83 ec 08             	sub    $0x8,%esp
80102e71:	ff 75 0c             	pushl  0xc(%ebp)
80102e74:	ff 75 08             	pushl  0x8(%ebp)
80102e77:	e8 2a 00 00 00       	call   80102ea6 <freerange>
80102e7c:	83 c4 10             	add    $0x10,%esp
}
80102e7f:	90                   	nop
80102e80:	c9                   	leave  
80102e81:	c3                   	ret    

80102e82 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102e82:	55                   	push   %ebp
80102e83:	89 e5                	mov    %esp,%ebp
80102e85:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102e88:	83 ec 08             	sub    $0x8,%esp
80102e8b:	ff 75 0c             	pushl  0xc(%ebp)
80102e8e:	ff 75 08             	pushl  0x8(%ebp)
80102e91:	e8 10 00 00 00       	call   80102ea6 <freerange>
80102e96:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102e99:	c7 05 94 42 11 80 01 	movl   $0x1,0x80114294
80102ea0:	00 00 00 
}
80102ea3:	90                   	nop
80102ea4:	c9                   	leave  
80102ea5:	c3                   	ret    

80102ea6 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ea6:	55                   	push   %ebp
80102ea7:	89 e5                	mov    %esp,%ebp
80102ea9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102eac:	8b 45 08             	mov    0x8(%ebp),%eax
80102eaf:	05 ff 0f 00 00       	add    $0xfff,%eax
80102eb4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102eb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ebc:	eb 15                	jmp    80102ed3 <freerange+0x2d>
    kfree(p);
80102ebe:	83 ec 0c             	sub    $0xc,%esp
80102ec1:	ff 75 f4             	pushl  -0xc(%ebp)
80102ec4:	e8 1a 00 00 00       	call   80102ee3 <kfree>
80102ec9:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ecc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ed6:	05 00 10 00 00       	add    $0x1000,%eax
80102edb:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ede:	76 de                	jbe    80102ebe <freerange+0x18>
    kfree(p);
}
80102ee0:	90                   	nop
80102ee1:	c9                   	leave  
80102ee2:	c3                   	ret    

80102ee3 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ee3:	55                   	push   %ebp
80102ee4:	89 e5                	mov    %esp,%ebp
80102ee6:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80102eec:	25 ff 0f 00 00       	and    $0xfff,%eax
80102ef1:	85 c0                	test   %eax,%eax
80102ef3:	75 1b                	jne    80102f10 <kfree+0x2d>
80102ef5:	81 7d 08 7c 79 11 80 	cmpl   $0x8011797c,0x8(%ebp)
80102efc:	72 12                	jb     80102f10 <kfree+0x2d>
80102efe:	ff 75 08             	pushl  0x8(%ebp)
80102f01:	e8 36 ff ff ff       	call   80102e3c <v2p>
80102f06:	83 c4 04             	add    $0x4,%esp
80102f09:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102f0e:	76 0d                	jbe    80102f1d <kfree+0x3a>
    panic("kfree");
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 f3 a2 10 80       	push   $0x8010a2f3
80102f18:	e8 49 d6 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102f1d:	83 ec 04             	sub    $0x4,%esp
80102f20:	68 00 10 00 00       	push   $0x1000
80102f25:	6a 01                	push   $0x1
80102f27:	ff 75 08             	pushl  0x8(%ebp)
80102f2a:	e8 ed 3b 00 00       	call   80106b1c <memset>
80102f2f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102f32:	a1 94 42 11 80       	mov    0x80114294,%eax
80102f37:	85 c0                	test   %eax,%eax
80102f39:	74 10                	je     80102f4b <kfree+0x68>
    acquire(&kmem.lock);
80102f3b:	83 ec 0c             	sub    $0xc,%esp
80102f3e:	68 60 42 11 80       	push   $0x80114260
80102f43:	e8 71 39 00 00       	call   801068b9 <acquire>
80102f48:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102f4b:	8b 45 08             	mov    0x8(%ebp),%eax
80102f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102f51:	8b 15 98 42 11 80    	mov    0x80114298,%edx
80102f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f5a:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f5f:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80102f64:	a1 94 42 11 80       	mov    0x80114294,%eax
80102f69:	85 c0                	test   %eax,%eax
80102f6b:	74 10                	je     80102f7d <kfree+0x9a>
    release(&kmem.lock);
80102f6d:	83 ec 0c             	sub    $0xc,%esp
80102f70:	68 60 42 11 80       	push   $0x80114260
80102f75:	e8 a6 39 00 00       	call   80106920 <release>
80102f7a:	83 c4 10             	add    $0x10,%esp
}
80102f7d:	90                   	nop
80102f7e:	c9                   	leave  
80102f7f:	c3                   	ret    

80102f80 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102f86:	a1 94 42 11 80       	mov    0x80114294,%eax
80102f8b:	85 c0                	test   %eax,%eax
80102f8d:	74 10                	je     80102f9f <kalloc+0x1f>
    acquire(&kmem.lock);
80102f8f:	83 ec 0c             	sub    $0xc,%esp
80102f92:	68 60 42 11 80       	push   $0x80114260
80102f97:	e8 1d 39 00 00       	call   801068b9 <acquire>
80102f9c:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102f9f:	a1 98 42 11 80       	mov    0x80114298,%eax
80102fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102fa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102fab:	74 0a                	je     80102fb7 <kalloc+0x37>
    kmem.freelist = r->next;
80102fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fb0:	8b 00                	mov    (%eax),%eax
80102fb2:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80102fb7:	a1 94 42 11 80       	mov    0x80114294,%eax
80102fbc:	85 c0                	test   %eax,%eax
80102fbe:	74 10                	je     80102fd0 <kalloc+0x50>
    release(&kmem.lock);
80102fc0:	83 ec 0c             	sub    $0xc,%esp
80102fc3:	68 60 42 11 80       	push   $0x80114260
80102fc8:	e8 53 39 00 00       	call   80106920 <release>
80102fcd:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102fd3:	c9                   	leave  
80102fd4:	c3                   	ret    

80102fd5 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102fd5:	55                   	push   %ebp
80102fd6:	89 e5                	mov    %esp,%ebp
80102fd8:	83 ec 14             	sub    $0x14,%esp
80102fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80102fde:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fe2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102fe6:	89 c2                	mov    %eax,%edx
80102fe8:	ec                   	in     (%dx),%al
80102fe9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102fec:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ff0:	c9                   	leave  
80102ff1:	c3                   	ret    

80102ff2 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102ff2:	55                   	push   %ebp
80102ff3:	89 e5                	mov    %esp,%ebp
80102ff5:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102ff8:	6a 64                	push   $0x64
80102ffa:	e8 d6 ff ff ff       	call   80102fd5 <inb>
80102fff:	83 c4 04             	add    $0x4,%esp
80103002:	0f b6 c0             	movzbl %al,%eax
80103005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80103008:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010300b:	83 e0 01             	and    $0x1,%eax
8010300e:	85 c0                	test   %eax,%eax
80103010:	75 0a                	jne    8010301c <kbdgetc+0x2a>
    return -1;
80103012:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103017:	e9 23 01 00 00       	jmp    8010313f <kbdgetc+0x14d>
  data = inb(KBDATAP);
8010301c:	6a 60                	push   $0x60
8010301e:	e8 b2 ff ff ff       	call   80102fd5 <inb>
80103023:	83 c4 04             	add    $0x4,%esp
80103026:	0f b6 c0             	movzbl %al,%eax
80103029:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
8010302c:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80103033:	75 17                	jne    8010304c <kbdgetc+0x5a>
    shift |= E0ESC;
80103035:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010303a:	83 c8 40             	or     $0x40,%eax
8010303d:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
80103042:	b8 00 00 00 00       	mov    $0x0,%eax
80103047:	e9 f3 00 00 00       	jmp    8010313f <kbdgetc+0x14d>
  } else if(data & 0x80){
8010304c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010304f:	25 80 00 00 00       	and    $0x80,%eax
80103054:	85 c0                	test   %eax,%eax
80103056:	74 45                	je     8010309d <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103058:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010305d:	83 e0 40             	and    $0x40,%eax
80103060:	85 c0                	test   %eax,%eax
80103062:	75 08                	jne    8010306c <kbdgetc+0x7a>
80103064:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103067:	83 e0 7f             	and    $0x7f,%eax
8010306a:	eb 03                	jmp    8010306f <kbdgetc+0x7d>
8010306c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010306f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80103072:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103075:	05 20 b0 10 80       	add    $0x8010b020,%eax
8010307a:	0f b6 00             	movzbl (%eax),%eax
8010307d:	83 c8 40             	or     $0x40,%eax
80103080:	0f b6 c0             	movzbl %al,%eax
80103083:	f7 d0                	not    %eax
80103085:	89 c2                	mov    %eax,%edx
80103087:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010308c:	21 d0                	and    %edx,%eax
8010308e:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
80103093:	b8 00 00 00 00       	mov    $0x0,%eax
80103098:	e9 a2 00 00 00       	jmp    8010313f <kbdgetc+0x14d>
  } else if(shift & E0ESC){
8010309d:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030a2:	83 e0 40             	and    $0x40,%eax
801030a5:	85 c0                	test   %eax,%eax
801030a7:	74 14                	je     801030bd <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801030a9:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801030b0:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030b5:	83 e0 bf             	and    $0xffffffbf,%eax
801030b8:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  }

  shift |= shiftcode[data];
801030bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030c0:	05 20 b0 10 80       	add    $0x8010b020,%eax
801030c5:	0f b6 00             	movzbl (%eax),%eax
801030c8:	0f b6 d0             	movzbl %al,%edx
801030cb:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030d0:	09 d0                	or     %edx,%eax
801030d2:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  shift ^= togglecode[data];
801030d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030da:	05 20 b1 10 80       	add    $0x8010b120,%eax
801030df:	0f b6 00             	movzbl (%eax),%eax
801030e2:	0f b6 d0             	movzbl %al,%edx
801030e5:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030ea:	31 d0                	xor    %edx,%eax
801030ec:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  c = charcode[shift & (CTL | SHIFT)][data];
801030f1:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030f6:	83 e0 03             	and    $0x3,%eax
801030f9:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80103100:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103103:	01 d0                	add    %edx,%eax
80103105:	0f b6 00             	movzbl (%eax),%eax
80103108:	0f b6 c0             	movzbl %al,%eax
8010310b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
8010310e:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103113:	83 e0 08             	and    $0x8,%eax
80103116:	85 c0                	test   %eax,%eax
80103118:	74 22                	je     8010313c <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
8010311a:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
8010311e:	76 0c                	jbe    8010312c <kbdgetc+0x13a>
80103120:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80103124:	77 06                	ja     8010312c <kbdgetc+0x13a>
      c += 'A' - 'a';
80103126:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
8010312a:	eb 10                	jmp    8010313c <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
8010312c:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80103130:	76 0a                	jbe    8010313c <kbdgetc+0x14a>
80103132:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80103136:	77 04                	ja     8010313c <kbdgetc+0x14a>
      c += 'a' - 'A';
80103138:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
8010313c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010313f:	c9                   	leave  
80103140:	c3                   	ret    

80103141 <kbdintr>:

void
kbdintr(void)
{
80103141:	55                   	push   %ebp
80103142:	89 e5                	mov    %esp,%ebp
80103144:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80103147:	83 ec 0c             	sub    $0xc,%esp
8010314a:	68 f2 2f 10 80       	push   $0x80102ff2
8010314f:	e8 a5 d6 ff ff       	call   801007f9 <consoleintr>
80103154:	83 c4 10             	add    $0x10,%esp
}
80103157:	90                   	nop
80103158:	c9                   	leave  
80103159:	c3                   	ret    

8010315a <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
8010315a:	55                   	push   %ebp
8010315b:	89 e5                	mov    %esp,%ebp
8010315d:	83 ec 14             	sub    $0x14,%esp
80103160:	8b 45 08             	mov    0x8(%ebp),%eax
80103163:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103167:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010316b:	89 c2                	mov    %eax,%edx
8010316d:	ec                   	in     (%dx),%al
8010316e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103171:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103175:	c9                   	leave  
80103176:	c3                   	ret    

80103177 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103177:	55                   	push   %ebp
80103178:	89 e5                	mov    %esp,%ebp
8010317a:	83 ec 08             	sub    $0x8,%esp
8010317d:	8b 55 08             	mov    0x8(%ebp),%edx
80103180:	8b 45 0c             	mov    0xc(%ebp),%eax
80103183:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103187:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010318a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010318e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103192:	ee                   	out    %al,(%dx)
}
80103193:	90                   	nop
80103194:	c9                   	leave  
80103195:	c3                   	ret    

80103196 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103196:	55                   	push   %ebp
80103197:	89 e5                	mov    %esp,%ebp
80103199:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010319c:	9c                   	pushf  
8010319d:	58                   	pop    %eax
8010319e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801031a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801031a4:	c9                   	leave  
801031a5:	c3                   	ret    

801031a6 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
801031a6:	55                   	push   %ebp
801031a7:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801031a9:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801031ae:	8b 55 08             	mov    0x8(%ebp),%edx
801031b1:	c1 e2 02             	shl    $0x2,%edx
801031b4:	01 c2                	add    %eax,%edx
801031b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801031b9:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801031bb:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801031c0:	83 c0 20             	add    $0x20,%eax
801031c3:	8b 00                	mov    (%eax),%eax
}
801031c5:	90                   	nop
801031c6:	5d                   	pop    %ebp
801031c7:	c3                   	ret    

801031c8 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
801031c8:	55                   	push   %ebp
801031c9:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
801031cb:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801031d0:	85 c0                	test   %eax,%eax
801031d2:	0f 84 0b 01 00 00    	je     801032e3 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801031d8:	68 3f 01 00 00       	push   $0x13f
801031dd:	6a 3c                	push   $0x3c
801031df:	e8 c2 ff ff ff       	call   801031a6 <lapicw>
801031e4:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801031e7:	6a 0b                	push   $0xb
801031e9:	68 f8 00 00 00       	push   $0xf8
801031ee:	e8 b3 ff ff ff       	call   801031a6 <lapicw>
801031f3:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801031f6:	68 20 00 02 00       	push   $0x20020
801031fb:	68 c8 00 00 00       	push   $0xc8
80103200:	e8 a1 ff ff ff       	call   801031a6 <lapicw>
80103205:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80103208:	68 80 96 98 00       	push   $0x989680
8010320d:	68 e0 00 00 00       	push   $0xe0
80103212:	e8 8f ff ff ff       	call   801031a6 <lapicw>
80103217:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
8010321a:	68 00 00 01 00       	push   $0x10000
8010321f:	68 d4 00 00 00       	push   $0xd4
80103224:	e8 7d ff ff ff       	call   801031a6 <lapicw>
80103229:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
8010322c:	68 00 00 01 00       	push   $0x10000
80103231:	68 d8 00 00 00       	push   $0xd8
80103236:	e8 6b ff ff ff       	call   801031a6 <lapicw>
8010323b:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010323e:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103243:	83 c0 30             	add    $0x30,%eax
80103246:	8b 00                	mov    (%eax),%eax
80103248:	c1 e8 10             	shr    $0x10,%eax
8010324b:	0f b6 c0             	movzbl %al,%eax
8010324e:	83 f8 03             	cmp    $0x3,%eax
80103251:	76 12                	jbe    80103265 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80103253:	68 00 00 01 00       	push   $0x10000
80103258:	68 d0 00 00 00       	push   $0xd0
8010325d:	e8 44 ff ff ff       	call   801031a6 <lapicw>
80103262:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103265:	6a 33                	push   $0x33
80103267:	68 dc 00 00 00       	push   $0xdc
8010326c:	e8 35 ff ff ff       	call   801031a6 <lapicw>
80103271:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103274:	6a 00                	push   $0x0
80103276:	68 a0 00 00 00       	push   $0xa0
8010327b:	e8 26 ff ff ff       	call   801031a6 <lapicw>
80103280:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103283:	6a 00                	push   $0x0
80103285:	68 a0 00 00 00       	push   $0xa0
8010328a:	e8 17 ff ff ff       	call   801031a6 <lapicw>
8010328f:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103292:	6a 00                	push   $0x0
80103294:	6a 2c                	push   $0x2c
80103296:	e8 0b ff ff ff       	call   801031a6 <lapicw>
8010329b:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010329e:	6a 00                	push   $0x0
801032a0:	68 c4 00 00 00       	push   $0xc4
801032a5:	e8 fc fe ff ff       	call   801031a6 <lapicw>
801032aa:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801032ad:	68 00 85 08 00       	push   $0x88500
801032b2:	68 c0 00 00 00       	push   $0xc0
801032b7:	e8 ea fe ff ff       	call   801031a6 <lapicw>
801032bc:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
801032bf:	90                   	nop
801032c0:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801032c5:	05 00 03 00 00       	add    $0x300,%eax
801032ca:	8b 00                	mov    (%eax),%eax
801032cc:	25 00 10 00 00       	and    $0x1000,%eax
801032d1:	85 c0                	test   %eax,%eax
801032d3:	75 eb                	jne    801032c0 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801032d5:	6a 00                	push   $0x0
801032d7:	6a 20                	push   $0x20
801032d9:	e8 c8 fe ff ff       	call   801031a6 <lapicw>
801032de:	83 c4 08             	add    $0x8,%esp
801032e1:	eb 01                	jmp    801032e4 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
801032e3:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801032e4:	c9                   	leave  
801032e5:	c3                   	ret    

801032e6 <cpunum>:

int
cpunum(void)
{
801032e6:	55                   	push   %ebp
801032e7:	89 e5                	mov    %esp,%ebp
801032e9:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801032ec:	e8 a5 fe ff ff       	call   80103196 <readeflags>
801032f1:	25 00 02 00 00       	and    $0x200,%eax
801032f6:	85 c0                	test   %eax,%eax
801032f8:	74 26                	je     80103320 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
801032fa:	a1 80 d6 10 80       	mov    0x8010d680,%eax
801032ff:	8d 50 01             	lea    0x1(%eax),%edx
80103302:	89 15 80 d6 10 80    	mov    %edx,0x8010d680
80103308:	85 c0                	test   %eax,%eax
8010330a:	75 14                	jne    80103320 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
8010330c:	8b 45 04             	mov    0x4(%ebp),%eax
8010330f:	83 ec 08             	sub    $0x8,%esp
80103312:	50                   	push   %eax
80103313:	68 fc a2 10 80       	push   $0x8010a2fc
80103318:	e8 a9 d0 ff ff       	call   801003c6 <cprintf>
8010331d:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103320:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103325:	85 c0                	test   %eax,%eax
80103327:	74 0f                	je     80103338 <cpunum+0x52>
    return lapic[ID]>>24;
80103329:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010332e:	83 c0 20             	add    $0x20,%eax
80103331:	8b 00                	mov    (%eax),%eax
80103333:	c1 e8 18             	shr    $0x18,%eax
80103336:	eb 05                	jmp    8010333d <cpunum+0x57>
  return 0;
80103338:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010333d:	c9                   	leave  
8010333e:	c3                   	ret    

8010333f <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010333f:	55                   	push   %ebp
80103340:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103342:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103347:	85 c0                	test   %eax,%eax
80103349:	74 0c                	je     80103357 <lapiceoi+0x18>
    lapicw(EOI, 0);
8010334b:	6a 00                	push   $0x0
8010334d:	6a 2c                	push   $0x2c
8010334f:	e8 52 fe ff ff       	call   801031a6 <lapicw>
80103354:	83 c4 08             	add    $0x8,%esp
}
80103357:	90                   	nop
80103358:	c9                   	leave  
80103359:	c3                   	ret    

8010335a <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010335a:	55                   	push   %ebp
8010335b:	89 e5                	mov    %esp,%ebp
}
8010335d:	90                   	nop
8010335e:	5d                   	pop    %ebp
8010335f:	c3                   	ret    

80103360 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	83 ec 14             	sub    $0x14,%esp
80103366:	8b 45 08             	mov    0x8(%ebp),%eax
80103369:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010336c:	6a 0f                	push   $0xf
8010336e:	6a 70                	push   $0x70
80103370:	e8 02 fe ff ff       	call   80103177 <outb>
80103375:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103378:	6a 0a                	push   $0xa
8010337a:	6a 71                	push   $0x71
8010337c:	e8 f6 fd ff ff       	call   80103177 <outb>
80103381:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103384:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010338b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010338e:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103393:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103396:	83 c0 02             	add    $0x2,%eax
80103399:	8b 55 0c             	mov    0xc(%ebp),%edx
8010339c:	c1 ea 04             	shr    $0x4,%edx
8010339f:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801033a2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801033a6:	c1 e0 18             	shl    $0x18,%eax
801033a9:	50                   	push   %eax
801033aa:	68 c4 00 00 00       	push   $0xc4
801033af:	e8 f2 fd ff ff       	call   801031a6 <lapicw>
801033b4:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801033b7:	68 00 c5 00 00       	push   $0xc500
801033bc:	68 c0 00 00 00       	push   $0xc0
801033c1:	e8 e0 fd ff ff       	call   801031a6 <lapicw>
801033c6:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801033c9:	68 c8 00 00 00       	push   $0xc8
801033ce:	e8 87 ff ff ff       	call   8010335a <microdelay>
801033d3:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801033d6:	68 00 85 00 00       	push   $0x8500
801033db:	68 c0 00 00 00       	push   $0xc0
801033e0:	e8 c1 fd ff ff       	call   801031a6 <lapicw>
801033e5:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801033e8:	6a 64                	push   $0x64
801033ea:	e8 6b ff ff ff       	call   8010335a <microdelay>
801033ef:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801033f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801033f9:	eb 3d                	jmp    80103438 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
801033fb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801033ff:	c1 e0 18             	shl    $0x18,%eax
80103402:	50                   	push   %eax
80103403:	68 c4 00 00 00       	push   $0xc4
80103408:	e8 99 fd ff ff       	call   801031a6 <lapicw>
8010340d:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103410:	8b 45 0c             	mov    0xc(%ebp),%eax
80103413:	c1 e8 0c             	shr    $0xc,%eax
80103416:	80 cc 06             	or     $0x6,%ah
80103419:	50                   	push   %eax
8010341a:	68 c0 00 00 00       	push   $0xc0
8010341f:	e8 82 fd ff ff       	call   801031a6 <lapicw>
80103424:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103427:	68 c8 00 00 00       	push   $0xc8
8010342c:	e8 29 ff ff ff       	call   8010335a <microdelay>
80103431:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103434:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103438:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010343c:	7e bd                	jle    801033fb <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010343e:	90                   	nop
8010343f:	c9                   	leave  
80103440:	c3                   	ret    

80103441 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103441:	55                   	push   %ebp
80103442:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103444:	8b 45 08             	mov    0x8(%ebp),%eax
80103447:	0f b6 c0             	movzbl %al,%eax
8010344a:	50                   	push   %eax
8010344b:	6a 70                	push   $0x70
8010344d:	e8 25 fd ff ff       	call   80103177 <outb>
80103452:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103455:	68 c8 00 00 00       	push   $0xc8
8010345a:	e8 fb fe ff ff       	call   8010335a <microdelay>
8010345f:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103462:	6a 71                	push   $0x71
80103464:	e8 f1 fc ff ff       	call   8010315a <inb>
80103469:	83 c4 04             	add    $0x4,%esp
8010346c:	0f b6 c0             	movzbl %al,%eax
}
8010346f:	c9                   	leave  
80103470:	c3                   	ret    

80103471 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103471:	55                   	push   %ebp
80103472:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103474:	6a 00                	push   $0x0
80103476:	e8 c6 ff ff ff       	call   80103441 <cmos_read>
8010347b:	83 c4 04             	add    $0x4,%esp
8010347e:	89 c2                	mov    %eax,%edx
80103480:	8b 45 08             	mov    0x8(%ebp),%eax
80103483:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103485:	6a 02                	push   $0x2
80103487:	e8 b5 ff ff ff       	call   80103441 <cmos_read>
8010348c:	83 c4 04             	add    $0x4,%esp
8010348f:	89 c2                	mov    %eax,%edx
80103491:	8b 45 08             	mov    0x8(%ebp),%eax
80103494:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103497:	6a 04                	push   $0x4
80103499:	e8 a3 ff ff ff       	call   80103441 <cmos_read>
8010349e:	83 c4 04             	add    $0x4,%esp
801034a1:	89 c2                	mov    %eax,%edx
801034a3:	8b 45 08             	mov    0x8(%ebp),%eax
801034a6:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801034a9:	6a 07                	push   $0x7
801034ab:	e8 91 ff ff ff       	call   80103441 <cmos_read>
801034b0:	83 c4 04             	add    $0x4,%esp
801034b3:	89 c2                	mov    %eax,%edx
801034b5:	8b 45 08             	mov    0x8(%ebp),%eax
801034b8:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801034bb:	6a 08                	push   $0x8
801034bd:	e8 7f ff ff ff       	call   80103441 <cmos_read>
801034c2:	83 c4 04             	add    $0x4,%esp
801034c5:	89 c2                	mov    %eax,%edx
801034c7:	8b 45 08             	mov    0x8(%ebp),%eax
801034ca:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801034cd:	6a 09                	push   $0x9
801034cf:	e8 6d ff ff ff       	call   80103441 <cmos_read>
801034d4:	83 c4 04             	add    $0x4,%esp
801034d7:	89 c2                	mov    %eax,%edx
801034d9:	8b 45 08             	mov    0x8(%ebp),%eax
801034dc:	89 50 14             	mov    %edx,0x14(%eax)
}
801034df:	90                   	nop
801034e0:	c9                   	leave  
801034e1:	c3                   	ret    

801034e2 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801034e2:	55                   	push   %ebp
801034e3:	89 e5                	mov    %esp,%ebp
801034e5:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801034e8:	6a 0b                	push   $0xb
801034ea:	e8 52 ff ff ff       	call   80103441 <cmos_read>
801034ef:	83 c4 04             	add    $0x4,%esp
801034f2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801034f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034f8:	83 e0 04             	and    $0x4,%eax
801034fb:	85 c0                	test   %eax,%eax
801034fd:	0f 94 c0             	sete   %al
80103500:	0f b6 c0             	movzbl %al,%eax
80103503:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103506:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103509:	50                   	push   %eax
8010350a:	e8 62 ff ff ff       	call   80103471 <fill_rtcdate>
8010350f:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103512:	6a 0a                	push   $0xa
80103514:	e8 28 ff ff ff       	call   80103441 <cmos_read>
80103519:	83 c4 04             	add    $0x4,%esp
8010351c:	25 80 00 00 00       	and    $0x80,%eax
80103521:	85 c0                	test   %eax,%eax
80103523:	75 27                	jne    8010354c <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103525:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103528:	50                   	push   %eax
80103529:	e8 43 ff ff ff       	call   80103471 <fill_rtcdate>
8010352e:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103531:	83 ec 04             	sub    $0x4,%esp
80103534:	6a 18                	push   $0x18
80103536:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103539:	50                   	push   %eax
8010353a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010353d:	50                   	push   %eax
8010353e:	e8 40 36 00 00       	call   80106b83 <memcmp>
80103543:	83 c4 10             	add    $0x10,%esp
80103546:	85 c0                	test   %eax,%eax
80103548:	74 05                	je     8010354f <cmostime+0x6d>
8010354a:	eb ba                	jmp    80103506 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
8010354c:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010354d:	eb b7                	jmp    80103506 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010354f:	90                   	nop
  }

  // convert
  if (bcd) {
80103550:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103554:	0f 84 b4 00 00 00    	je     8010360e <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010355a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010355d:	c1 e8 04             	shr    $0x4,%eax
80103560:	89 c2                	mov    %eax,%edx
80103562:	89 d0                	mov    %edx,%eax
80103564:	c1 e0 02             	shl    $0x2,%eax
80103567:	01 d0                	add    %edx,%eax
80103569:	01 c0                	add    %eax,%eax
8010356b:	89 c2                	mov    %eax,%edx
8010356d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103570:	83 e0 0f             	and    $0xf,%eax
80103573:	01 d0                	add    %edx,%eax
80103575:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103578:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010357b:	c1 e8 04             	shr    $0x4,%eax
8010357e:	89 c2                	mov    %eax,%edx
80103580:	89 d0                	mov    %edx,%eax
80103582:	c1 e0 02             	shl    $0x2,%eax
80103585:	01 d0                	add    %edx,%eax
80103587:	01 c0                	add    %eax,%eax
80103589:	89 c2                	mov    %eax,%edx
8010358b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010358e:	83 e0 0f             	and    $0xf,%eax
80103591:	01 d0                	add    %edx,%eax
80103593:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103596:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103599:	c1 e8 04             	shr    $0x4,%eax
8010359c:	89 c2                	mov    %eax,%edx
8010359e:	89 d0                	mov    %edx,%eax
801035a0:	c1 e0 02             	shl    $0x2,%eax
801035a3:	01 d0                	add    %edx,%eax
801035a5:	01 c0                	add    %eax,%eax
801035a7:	89 c2                	mov    %eax,%edx
801035a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035ac:	83 e0 0f             	and    $0xf,%eax
801035af:	01 d0                	add    %edx,%eax
801035b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801035b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035b7:	c1 e8 04             	shr    $0x4,%eax
801035ba:	89 c2                	mov    %eax,%edx
801035bc:	89 d0                	mov    %edx,%eax
801035be:	c1 e0 02             	shl    $0x2,%eax
801035c1:	01 d0                	add    %edx,%eax
801035c3:	01 c0                	add    %eax,%eax
801035c5:	89 c2                	mov    %eax,%edx
801035c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035ca:	83 e0 0f             	and    $0xf,%eax
801035cd:	01 d0                	add    %edx,%eax
801035cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801035d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801035d5:	c1 e8 04             	shr    $0x4,%eax
801035d8:	89 c2                	mov    %eax,%edx
801035da:	89 d0                	mov    %edx,%eax
801035dc:	c1 e0 02             	shl    $0x2,%eax
801035df:	01 d0                	add    %edx,%eax
801035e1:	01 c0                	add    %eax,%eax
801035e3:	89 c2                	mov    %eax,%edx
801035e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801035e8:	83 e0 0f             	and    $0xf,%eax
801035eb:	01 d0                	add    %edx,%eax
801035ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801035f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035f3:	c1 e8 04             	shr    $0x4,%eax
801035f6:	89 c2                	mov    %eax,%edx
801035f8:	89 d0                	mov    %edx,%eax
801035fa:	c1 e0 02             	shl    $0x2,%eax
801035fd:	01 d0                	add    %edx,%eax
801035ff:	01 c0                	add    %eax,%eax
80103601:	89 c2                	mov    %eax,%edx
80103603:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103606:	83 e0 0f             	and    $0xf,%eax
80103609:	01 d0                	add    %edx,%eax
8010360b:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010360e:	8b 45 08             	mov    0x8(%ebp),%eax
80103611:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103614:	89 10                	mov    %edx,(%eax)
80103616:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103619:	89 50 04             	mov    %edx,0x4(%eax)
8010361c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010361f:	89 50 08             	mov    %edx,0x8(%eax)
80103622:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103625:	89 50 0c             	mov    %edx,0xc(%eax)
80103628:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010362b:	89 50 10             	mov    %edx,0x10(%eax)
8010362e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103631:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103634:	8b 45 08             	mov    0x8(%ebp),%eax
80103637:	8b 40 14             	mov    0x14(%eax),%eax
8010363a:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103640:	8b 45 08             	mov    0x8(%ebp),%eax
80103643:	89 50 14             	mov    %edx,0x14(%eax)
}
80103646:	90                   	nop
80103647:	c9                   	leave  
80103648:	c3                   	ret    

80103649 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103649:	55                   	push   %ebp
8010364a:	89 e5                	mov    %esp,%ebp
8010364c:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010364f:	83 ec 08             	sub    $0x8,%esp
80103652:	68 28 a3 10 80       	push   $0x8010a328
80103657:	68 a0 42 11 80       	push   $0x801142a0
8010365c:	e8 36 32 00 00       	call   80106897 <initlock>
80103661:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103664:	83 ec 08             	sub    $0x8,%esp
80103667:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010366a:	50                   	push   %eax
8010366b:	ff 75 08             	pushl  0x8(%ebp)
8010366e:	e8 66 de ff ff       	call   801014d9 <readsb>
80103673:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103676:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103679:	a3 d4 42 11 80       	mov    %eax,0x801142d4
  log.size = sb.nlog;
8010367e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103681:	a3 d8 42 11 80       	mov    %eax,0x801142d8
  log.dev = dev;
80103686:	8b 45 08             	mov    0x8(%ebp),%eax
80103689:	a3 e4 42 11 80       	mov    %eax,0x801142e4
  recover_from_log();
8010368e:	e8 b2 01 00 00       	call   80103845 <recover_from_log>
}
80103693:	90                   	nop
80103694:	c9                   	leave  
80103695:	c3                   	ret    

80103696 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103696:	55                   	push   %ebp
80103697:	89 e5                	mov    %esp,%ebp
80103699:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010369c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036a3:	e9 95 00 00 00       	jmp    8010373d <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801036a8:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
801036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036b1:	01 d0                	add    %edx,%eax
801036b3:	83 c0 01             	add    $0x1,%eax
801036b6:	89 c2                	mov    %eax,%edx
801036b8:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801036bd:	83 ec 08             	sub    $0x8,%esp
801036c0:	52                   	push   %edx
801036c1:	50                   	push   %eax
801036c2:	e8 ef ca ff ff       	call   801001b6 <bread>
801036c7:	83 c4 10             	add    $0x10,%esp
801036ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801036cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d0:	83 c0 10             	add    $0x10,%eax
801036d3:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
801036da:	89 c2                	mov    %eax,%edx
801036dc:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801036e1:	83 ec 08             	sub    $0x8,%esp
801036e4:	52                   	push   %edx
801036e5:	50                   	push   %eax
801036e6:	e8 cb ca ff ff       	call   801001b6 <bread>
801036eb:	83 c4 10             	add    $0x10,%esp
801036ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801036f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036f4:	8d 50 18             	lea    0x18(%eax),%edx
801036f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036fa:	83 c0 18             	add    $0x18,%eax
801036fd:	83 ec 04             	sub    $0x4,%esp
80103700:	68 00 02 00 00       	push   $0x200
80103705:	52                   	push   %edx
80103706:	50                   	push   %eax
80103707:	e8 cf 34 00 00       	call   80106bdb <memmove>
8010370c:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010370f:	83 ec 0c             	sub    $0xc,%esp
80103712:	ff 75 ec             	pushl  -0x14(%ebp)
80103715:	e8 d5 ca ff ff       	call   801001ef <bwrite>
8010371a:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010371d:	83 ec 0c             	sub    $0xc,%esp
80103720:	ff 75 f0             	pushl  -0x10(%ebp)
80103723:	e8 06 cb ff ff       	call   8010022e <brelse>
80103728:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010372b:	83 ec 0c             	sub    $0xc,%esp
8010372e:	ff 75 ec             	pushl  -0x14(%ebp)
80103731:	e8 f8 ca ff ff       	call   8010022e <brelse>
80103736:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103739:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010373d:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103742:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103745:	0f 8f 5d ff ff ff    	jg     801036a8 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010374b:	90                   	nop
8010374c:	c9                   	leave  
8010374d:	c3                   	ret    

8010374e <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010374e:	55                   	push   %ebp
8010374f:	89 e5                	mov    %esp,%ebp
80103751:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103754:	a1 d4 42 11 80       	mov    0x801142d4,%eax
80103759:	89 c2                	mov    %eax,%edx
8010375b:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103760:	83 ec 08             	sub    $0x8,%esp
80103763:	52                   	push   %edx
80103764:	50                   	push   %eax
80103765:	e8 4c ca ff ff       	call   801001b6 <bread>
8010376a:	83 c4 10             	add    $0x10,%esp
8010376d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103770:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103773:	83 c0 18             	add    $0x18,%eax
80103776:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103779:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010377c:	8b 00                	mov    (%eax),%eax
8010377e:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  for (i = 0; i < log.lh.n; i++) {
80103783:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010378a:	eb 1b                	jmp    801037a7 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010378c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010378f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103792:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103796:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103799:	83 c2 10             	add    $0x10,%edx
8010379c:	89 04 95 ac 42 11 80 	mov    %eax,-0x7feebd54(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801037a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037a7:	a1 e8 42 11 80       	mov    0x801142e8,%eax
801037ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037af:	7f db                	jg     8010378c <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801037b1:	83 ec 0c             	sub    $0xc,%esp
801037b4:	ff 75 f0             	pushl  -0x10(%ebp)
801037b7:	e8 72 ca ff ff       	call   8010022e <brelse>
801037bc:	83 c4 10             	add    $0x10,%esp
}
801037bf:	90                   	nop
801037c0:	c9                   	leave  
801037c1:	c3                   	ret    

801037c2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801037c2:	55                   	push   %ebp
801037c3:	89 e5                	mov    %esp,%ebp
801037c5:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801037c8:	a1 d4 42 11 80       	mov    0x801142d4,%eax
801037cd:	89 c2                	mov    %eax,%edx
801037cf:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801037d4:	83 ec 08             	sub    $0x8,%esp
801037d7:	52                   	push   %edx
801037d8:	50                   	push   %eax
801037d9:	e8 d8 c9 ff ff       	call   801001b6 <bread>
801037de:	83 c4 10             	add    $0x10,%esp
801037e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801037e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037e7:	83 c0 18             	add    $0x18,%eax
801037ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801037ed:	8b 15 e8 42 11 80    	mov    0x801142e8,%edx
801037f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037f6:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801037f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037ff:	eb 1b                	jmp    8010381c <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103804:	83 c0 10             	add    $0x10,%eax
80103807:	8b 0c 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%ecx
8010380e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103811:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103814:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103818:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010381c:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103821:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103824:	7f db                	jg     80103801 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103826:	83 ec 0c             	sub    $0xc,%esp
80103829:	ff 75 f0             	pushl  -0x10(%ebp)
8010382c:	e8 be c9 ff ff       	call   801001ef <bwrite>
80103831:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103834:	83 ec 0c             	sub    $0xc,%esp
80103837:	ff 75 f0             	pushl  -0x10(%ebp)
8010383a:	e8 ef c9 ff ff       	call   8010022e <brelse>
8010383f:	83 c4 10             	add    $0x10,%esp
}
80103842:	90                   	nop
80103843:	c9                   	leave  
80103844:	c3                   	ret    

80103845 <recover_from_log>:

static void
recover_from_log(void)
{
80103845:	55                   	push   %ebp
80103846:	89 e5                	mov    %esp,%ebp
80103848:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010384b:	e8 fe fe ff ff       	call   8010374e <read_head>
  install_trans(); // if committed, copy from log to disk
80103850:	e8 41 fe ff ff       	call   80103696 <install_trans>
  log.lh.n = 0;
80103855:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
8010385c:	00 00 00 
  write_head(); // clear the log
8010385f:	e8 5e ff ff ff       	call   801037c2 <write_head>
}
80103864:	90                   	nop
80103865:	c9                   	leave  
80103866:	c3                   	ret    

80103867 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103867:	55                   	push   %ebp
80103868:	89 e5                	mov    %esp,%ebp
8010386a:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010386d:	83 ec 0c             	sub    $0xc,%esp
80103870:	68 a0 42 11 80       	push   $0x801142a0
80103875:	e8 3f 30 00 00       	call   801068b9 <acquire>
8010387a:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010387d:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80103882:	85 c0                	test   %eax,%eax
80103884:	74 17                	je     8010389d <begin_op+0x36>
      sleep(&log, &log.lock);
80103886:	83 ec 08             	sub    $0x8,%esp
80103889:	68 a0 42 11 80       	push   $0x801142a0
8010388e:	68 a0 42 11 80       	push   $0x801142a0
80103893:	e8 93 1d 00 00       	call   8010562b <sleep>
80103898:	83 c4 10             	add    $0x10,%esp
8010389b:	eb e0                	jmp    8010387d <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010389d:	8b 0d e8 42 11 80    	mov    0x801142e8,%ecx
801038a3:	a1 dc 42 11 80       	mov    0x801142dc,%eax
801038a8:	8d 50 01             	lea    0x1(%eax),%edx
801038ab:	89 d0                	mov    %edx,%eax
801038ad:	c1 e0 02             	shl    $0x2,%eax
801038b0:	01 d0                	add    %edx,%eax
801038b2:	01 c0                	add    %eax,%eax
801038b4:	01 c8                	add    %ecx,%eax
801038b6:	83 f8 1e             	cmp    $0x1e,%eax
801038b9:	7e 17                	jle    801038d2 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801038bb:	83 ec 08             	sub    $0x8,%esp
801038be:	68 a0 42 11 80       	push   $0x801142a0
801038c3:	68 a0 42 11 80       	push   $0x801142a0
801038c8:	e8 5e 1d 00 00       	call   8010562b <sleep>
801038cd:	83 c4 10             	add    $0x10,%esp
801038d0:	eb ab                	jmp    8010387d <begin_op+0x16>
    } else {
      log.outstanding += 1;
801038d2:	a1 dc 42 11 80       	mov    0x801142dc,%eax
801038d7:	83 c0 01             	add    $0x1,%eax
801038da:	a3 dc 42 11 80       	mov    %eax,0x801142dc
      release(&log.lock);
801038df:	83 ec 0c             	sub    $0xc,%esp
801038e2:	68 a0 42 11 80       	push   $0x801142a0
801038e7:	e8 34 30 00 00       	call   80106920 <release>
801038ec:	83 c4 10             	add    $0x10,%esp
      break;
801038ef:	90                   	nop
    }
  }
}
801038f0:	90                   	nop
801038f1:	c9                   	leave  
801038f2:	c3                   	ret    

801038f3 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801038f3:	55                   	push   %ebp
801038f4:	89 e5                	mov    %esp,%ebp
801038f6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801038f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103900:	83 ec 0c             	sub    $0xc,%esp
80103903:	68 a0 42 11 80       	push   $0x801142a0
80103908:	e8 ac 2f 00 00       	call   801068b9 <acquire>
8010390d:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103910:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103915:	83 e8 01             	sub    $0x1,%eax
80103918:	a3 dc 42 11 80       	mov    %eax,0x801142dc
  if(log.committing)
8010391d:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80103922:	85 c0                	test   %eax,%eax
80103924:	74 0d                	je     80103933 <end_op+0x40>
    panic("log.committing");
80103926:	83 ec 0c             	sub    $0xc,%esp
80103929:	68 2c a3 10 80       	push   $0x8010a32c
8010392e:	e8 33 cc ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103933:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103938:	85 c0                	test   %eax,%eax
8010393a:	75 13                	jne    8010394f <end_op+0x5c>
    do_commit = 1;
8010393c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103943:	c7 05 e0 42 11 80 01 	movl   $0x1,0x801142e0
8010394a:	00 00 00 
8010394d:	eb 10                	jmp    8010395f <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010394f:	83 ec 0c             	sub    $0xc,%esp
80103952:	68 a0 42 11 80       	push   $0x801142a0
80103957:	e8 a8 1e 00 00       	call   80105804 <wakeup>
8010395c:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010395f:	83 ec 0c             	sub    $0xc,%esp
80103962:	68 a0 42 11 80       	push   $0x801142a0
80103967:	e8 b4 2f 00 00       	call   80106920 <release>
8010396c:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010396f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103973:	74 3f                	je     801039b4 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103975:	e8 f5 00 00 00       	call   80103a6f <commit>
    acquire(&log.lock);
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	68 a0 42 11 80       	push   $0x801142a0
80103982:	e8 32 2f 00 00       	call   801068b9 <acquire>
80103987:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010398a:	c7 05 e0 42 11 80 00 	movl   $0x0,0x801142e0
80103991:	00 00 00 
    wakeup(&log);
80103994:	83 ec 0c             	sub    $0xc,%esp
80103997:	68 a0 42 11 80       	push   $0x801142a0
8010399c:	e8 63 1e 00 00       	call   80105804 <wakeup>
801039a1:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801039a4:	83 ec 0c             	sub    $0xc,%esp
801039a7:	68 a0 42 11 80       	push   $0x801142a0
801039ac:	e8 6f 2f 00 00       	call   80106920 <release>
801039b1:	83 c4 10             	add    $0x10,%esp
  }
}
801039b4:	90                   	nop
801039b5:	c9                   	leave  
801039b6:	c3                   	ret    

801039b7 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801039b7:	55                   	push   %ebp
801039b8:	89 e5                	mov    %esp,%ebp
801039ba:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801039bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039c4:	e9 95 00 00 00       	jmp    80103a5e <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801039c9:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
801039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039d2:	01 d0                	add    %edx,%eax
801039d4:	83 c0 01             	add    $0x1,%eax
801039d7:	89 c2                	mov    %eax,%edx
801039d9:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801039de:	83 ec 08             	sub    $0x8,%esp
801039e1:	52                   	push   %edx
801039e2:	50                   	push   %eax
801039e3:	e8 ce c7 ff ff       	call   801001b6 <bread>
801039e8:	83 c4 10             	add    $0x10,%esp
801039eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801039ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f1:	83 c0 10             	add    $0x10,%eax
801039f4:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
801039fb:	89 c2                	mov    %eax,%edx
801039fd:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103a02:	83 ec 08             	sub    $0x8,%esp
80103a05:	52                   	push   %edx
80103a06:	50                   	push   %eax
80103a07:	e8 aa c7 ff ff       	call   801001b6 <bread>
80103a0c:	83 c4 10             	add    $0x10,%esp
80103a0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103a12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a15:	8d 50 18             	lea    0x18(%eax),%edx
80103a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a1b:	83 c0 18             	add    $0x18,%eax
80103a1e:	83 ec 04             	sub    $0x4,%esp
80103a21:	68 00 02 00 00       	push   $0x200
80103a26:	52                   	push   %edx
80103a27:	50                   	push   %eax
80103a28:	e8 ae 31 00 00       	call   80106bdb <memmove>
80103a2d:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	ff 75 f0             	pushl  -0x10(%ebp)
80103a36:	e8 b4 c7 ff ff       	call   801001ef <bwrite>
80103a3b:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103a3e:	83 ec 0c             	sub    $0xc,%esp
80103a41:	ff 75 ec             	pushl  -0x14(%ebp)
80103a44:	e8 e5 c7 ff ff       	call   8010022e <brelse>
80103a49:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103a4c:	83 ec 0c             	sub    $0xc,%esp
80103a4f:	ff 75 f0             	pushl  -0x10(%ebp)
80103a52:	e8 d7 c7 ff ff       	call   8010022e <brelse>
80103a57:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103a5a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a5e:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103a63:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a66:	0f 8f 5d ff ff ff    	jg     801039c9 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103a6c:	90                   	nop
80103a6d:	c9                   	leave  
80103a6e:	c3                   	ret    

80103a6f <commit>:

static void
commit()
{
80103a6f:	55                   	push   %ebp
80103a70:	89 e5                	mov    %esp,%ebp
80103a72:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103a75:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103a7a:	85 c0                	test   %eax,%eax
80103a7c:	7e 1e                	jle    80103a9c <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103a7e:	e8 34 ff ff ff       	call   801039b7 <write_log>
    write_head();    // Write header to disk -- the real commit
80103a83:	e8 3a fd ff ff       	call   801037c2 <write_head>
    install_trans(); // Now install writes to home locations
80103a88:	e8 09 fc ff ff       	call   80103696 <install_trans>
    log.lh.n = 0; 
80103a8d:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103a94:	00 00 00 
    write_head();    // Erase the transaction from the log
80103a97:	e8 26 fd ff ff       	call   801037c2 <write_head>
  }
}
80103a9c:	90                   	nop
80103a9d:	c9                   	leave  
80103a9e:	c3                   	ret    

80103a9f <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103a9f:	55                   	push   %ebp
80103aa0:	89 e5                	mov    %esp,%ebp
80103aa2:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103aa5:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103aaa:	83 f8 1d             	cmp    $0x1d,%eax
80103aad:	7f 12                	jg     80103ac1 <log_write+0x22>
80103aaf:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103ab4:	8b 15 d8 42 11 80    	mov    0x801142d8,%edx
80103aba:	83 ea 01             	sub    $0x1,%edx
80103abd:	39 d0                	cmp    %edx,%eax
80103abf:	7c 0d                	jl     80103ace <log_write+0x2f>
    panic("too big a transaction");
80103ac1:	83 ec 0c             	sub    $0xc,%esp
80103ac4:	68 3b a3 10 80       	push   $0x8010a33b
80103ac9:	e8 98 ca ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103ace:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103ad3:	85 c0                	test   %eax,%eax
80103ad5:	7f 0d                	jg     80103ae4 <log_write+0x45>
    panic("log_write outside of trans");
80103ad7:	83 ec 0c             	sub    $0xc,%esp
80103ada:	68 51 a3 10 80       	push   $0x8010a351
80103adf:	e8 82 ca ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103ae4:	83 ec 0c             	sub    $0xc,%esp
80103ae7:	68 a0 42 11 80       	push   $0x801142a0
80103aec:	e8 c8 2d 00 00       	call   801068b9 <acquire>
80103af1:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103afb:	eb 1d                	jmp    80103b1a <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b00:	83 c0 10             	add    $0x10,%eax
80103b03:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103b0a:	89 c2                	mov    %eax,%edx
80103b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80103b0f:	8b 40 08             	mov    0x8(%eax),%eax
80103b12:	39 c2                	cmp    %eax,%edx
80103b14:	74 10                	je     80103b26 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103b16:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103b1a:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b1f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b22:	7f d9                	jg     80103afd <log_write+0x5e>
80103b24:	eb 01                	jmp    80103b27 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103b26:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103b27:	8b 45 08             	mov    0x8(%ebp),%eax
80103b2a:	8b 40 08             	mov    0x8(%eax),%eax
80103b2d:	89 c2                	mov    %eax,%edx
80103b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b32:	83 c0 10             	add    $0x10,%eax
80103b35:	89 14 85 ac 42 11 80 	mov    %edx,-0x7feebd54(,%eax,4)
  if (i == log.lh.n)
80103b3c:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b41:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b44:	75 0d                	jne    80103b53 <log_write+0xb4>
    log.lh.n++;
80103b46:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b4b:	83 c0 01             	add    $0x1,%eax
80103b4e:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  b->flags |= B_DIRTY; // prevent eviction
80103b53:	8b 45 08             	mov    0x8(%ebp),%eax
80103b56:	8b 00                	mov    (%eax),%eax
80103b58:	83 c8 04             	or     $0x4,%eax
80103b5b:	89 c2                	mov    %eax,%edx
80103b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80103b60:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103b62:	83 ec 0c             	sub    $0xc,%esp
80103b65:	68 a0 42 11 80       	push   $0x801142a0
80103b6a:	e8 b1 2d 00 00       	call   80106920 <release>
80103b6f:	83 c4 10             	add    $0x10,%esp
}
80103b72:	90                   	nop
80103b73:	c9                   	leave  
80103b74:	c3                   	ret    

80103b75 <v2p>:
80103b75:	55                   	push   %ebp
80103b76:	89 e5                	mov    %esp,%ebp
80103b78:	8b 45 08             	mov    0x8(%ebp),%eax
80103b7b:	05 00 00 00 80       	add    $0x80000000,%eax
80103b80:	5d                   	pop    %ebp
80103b81:	c3                   	ret    

80103b82 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103b82:	55                   	push   %ebp
80103b83:	89 e5                	mov    %esp,%ebp
80103b85:	8b 45 08             	mov    0x8(%ebp),%eax
80103b88:	05 00 00 00 80       	add    $0x80000000,%eax
80103b8d:	5d                   	pop    %ebp
80103b8e:	c3                   	ret    

80103b8f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103b8f:	55                   	push   %ebp
80103b90:	89 e5                	mov    %esp,%ebp
80103b92:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103b95:	8b 55 08             	mov    0x8(%ebp),%edx
80103b98:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103b9e:	f0 87 02             	lock xchg %eax,(%edx)
80103ba1:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103ba7:	c9                   	leave  
80103ba8:	c3                   	ret    

80103ba9 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103ba9:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103bad:	83 e4 f0             	and    $0xfffffff0,%esp
80103bb0:	ff 71 fc             	pushl  -0x4(%ecx)
80103bb3:	55                   	push   %ebp
80103bb4:	89 e5                	mov    %esp,%ebp
80103bb6:	51                   	push   %ecx
80103bb7:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103bba:	83 ec 08             	sub    $0x8,%esp
80103bbd:	68 00 00 40 80       	push   $0x80400000
80103bc2:	68 7c 79 11 80       	push   $0x8011797c
80103bc7:	e8 7d f2 ff ff       	call   80102e49 <kinit1>
80103bcc:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103bcf:	e8 67 5d 00 00       	call   8010993b <kvmalloc>
  mpinit();        // collect info about this machine
80103bd4:	e8 43 04 00 00       	call   8010401c <mpinit>
  lapicinit();
80103bd9:	e8 ea f5 ff ff       	call   801031c8 <lapicinit>
  seginit();       // set up segments
80103bde:	e8 01 57 00 00       	call   801092e4 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103be3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103be9:	0f b6 00             	movzbl (%eax),%eax
80103bec:	0f b6 c0             	movzbl %al,%eax
80103bef:	83 ec 08             	sub    $0x8,%esp
80103bf2:	50                   	push   %eax
80103bf3:	68 6c a3 10 80       	push   $0x8010a36c
80103bf8:	e8 c9 c7 ff ff       	call   801003c6 <cprintf>
80103bfd:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103c00:	e8 6d 06 00 00       	call   80104272 <picinit>
  ioapicinit();    // another interrupt controller
80103c05:	e8 34 f1 ff ff       	call   80102d3e <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103c0a:	e8 b4 cf ff ff       	call   80100bc3 <consoleinit>
  uartinit();      // serial port
80103c0f:	e8 2c 4a 00 00       	call   80108640 <uartinit>
  pinit();         // process table
80103c14:	e8 5d 0b 00 00       	call   80104776 <pinit>
  tvinit();        // trap vectors
80103c19:	e8 1e 46 00 00       	call   8010823c <tvinit>
  binit();         // buffer cache
80103c1e:	e8 11 c4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103c23:	e8 a2 d4 ff ff       	call   801010ca <fileinit>
  ideinit();       // disk
80103c28:	e8 19 ed ff ff       	call   80102946 <ideinit>
  if(!ismp)
80103c2d:	a1 84 43 11 80       	mov    0x80114384,%eax
80103c32:	85 c0                	test   %eax,%eax
80103c34:	75 05                	jne    80103c3b <main+0x92>
    timerinit();   // uniprocessor timer
80103c36:	e8 52 45 00 00       	call   8010818d <timerinit>
  startothers();   // start other processors
80103c3b:	e8 7f 00 00 00       	call   80103cbf <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103c40:	83 ec 08             	sub    $0x8,%esp
80103c43:	68 00 00 00 8e       	push   $0x8e000000
80103c48:	68 00 00 40 80       	push   $0x80400000
80103c4d:	e8 30 f2 ff ff       	call   80102e82 <kinit2>
80103c52:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103c55:	e8 0d 0d 00 00       	call   80104967 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103c5a:	e8 1a 00 00 00       	call   80103c79 <mpmain>

80103c5f <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103c5f:	55                   	push   %ebp
80103c60:	89 e5                	mov    %esp,%ebp
80103c62:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103c65:	e8 e9 5c 00 00       	call   80109953 <switchkvm>
  seginit();
80103c6a:	e8 75 56 00 00       	call   801092e4 <seginit>
  lapicinit();
80103c6f:	e8 54 f5 ff ff       	call   801031c8 <lapicinit>
  mpmain();
80103c74:	e8 00 00 00 00       	call   80103c79 <mpmain>

80103c79 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103c79:	55                   	push   %ebp
80103c7a:	89 e5                	mov    %esp,%ebp
80103c7c:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103c7f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c85:	0f b6 00             	movzbl (%eax),%eax
80103c88:	0f b6 c0             	movzbl %al,%eax
80103c8b:	83 ec 08             	sub    $0x8,%esp
80103c8e:	50                   	push   %eax
80103c8f:	68 83 a3 10 80       	push   $0x8010a383
80103c94:	e8 2d c7 ff ff       	call   801003c6 <cprintf>
80103c99:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103c9c:	e8 fc 46 00 00       	call   8010839d <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103ca1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ca7:	05 a8 00 00 00       	add    $0xa8,%eax
80103cac:	83 ec 08             	sub    $0x8,%esp
80103caf:	6a 01                	push   $0x1
80103cb1:	50                   	push   %eax
80103cb2:	e8 d8 fe ff ff       	call   80103b8f <xchg>
80103cb7:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103cba:	e8 bd 15 00 00       	call   8010527c <scheduler>

80103cbf <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103cbf:	55                   	push   %ebp
80103cc0:	89 e5                	mov    %esp,%ebp
80103cc2:	53                   	push   %ebx
80103cc3:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103cc6:	68 00 70 00 00       	push   $0x7000
80103ccb:	e8 b2 fe ff ff       	call   80103b82 <p2v>
80103cd0:	83 c4 04             	add    $0x4,%esp
80103cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103cd6:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103cdb:	83 ec 04             	sub    $0x4,%esp
80103cde:	50                   	push   %eax
80103cdf:	68 4c d5 10 80       	push   $0x8010d54c
80103ce4:	ff 75 f0             	pushl  -0x10(%ebp)
80103ce7:	e8 ef 2e 00 00       	call   80106bdb <memmove>
80103cec:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103cef:	c7 45 f4 a0 43 11 80 	movl   $0x801143a0,-0xc(%ebp)
80103cf6:	e9 90 00 00 00       	jmp    80103d8b <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103cfb:	e8 e6 f5 ff ff       	call   801032e6 <cpunum>
80103d00:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d06:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103d0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d0e:	74 73                	je     80103d83 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103d10:	e8 6b f2 ff ff       	call   80102f80 <kalloc>
80103d15:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d1b:	83 e8 04             	sub    $0x4,%eax
80103d1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103d21:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103d27:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d2c:	83 e8 08             	sub    $0x8,%eax
80103d2f:	c7 00 5f 3c 10 80    	movl   $0x80103c5f,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d38:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103d3b:	83 ec 0c             	sub    $0xc,%esp
80103d3e:	68 00 c0 10 80       	push   $0x8010c000
80103d43:	e8 2d fe ff ff       	call   80103b75 <v2p>
80103d48:	83 c4 10             	add    $0x10,%esp
80103d4b:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103d4d:	83 ec 0c             	sub    $0xc,%esp
80103d50:	ff 75 f0             	pushl  -0x10(%ebp)
80103d53:	e8 1d fe ff ff       	call   80103b75 <v2p>
80103d58:	83 c4 10             	add    $0x10,%esp
80103d5b:	89 c2                	mov    %eax,%edx
80103d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d60:	0f b6 00             	movzbl (%eax),%eax
80103d63:	0f b6 c0             	movzbl %al,%eax
80103d66:	83 ec 08             	sub    $0x8,%esp
80103d69:	52                   	push   %edx
80103d6a:	50                   	push   %eax
80103d6b:	e8 f0 f5 ff ff       	call   80103360 <lapicstartap>
80103d70:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103d73:	90                   	nop
80103d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d77:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103d7d:	85 c0                	test   %eax,%eax
80103d7f:	74 f3                	je     80103d74 <startothers+0xb5>
80103d81:	eb 01                	jmp    80103d84 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103d83:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103d84:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103d8b:	a1 80 49 11 80       	mov    0x80114980,%eax
80103d90:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d96:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103d9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d9e:	0f 87 57 ff ff ff    	ja     80103cfb <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103da4:	90                   	nop
80103da5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da8:	c9                   	leave  
80103da9:	c3                   	ret    

80103daa <p2v>:
80103daa:	55                   	push   %ebp
80103dab:	89 e5                	mov    %esp,%ebp
80103dad:	8b 45 08             	mov    0x8(%ebp),%eax
80103db0:	05 00 00 00 80       	add    $0x80000000,%eax
80103db5:	5d                   	pop    %ebp
80103db6:	c3                   	ret    

80103db7 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103db7:	55                   	push   %ebp
80103db8:	89 e5                	mov    %esp,%ebp
80103dba:	83 ec 14             	sub    $0x14,%esp
80103dbd:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc0:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103dc4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103dc8:	89 c2                	mov    %eax,%edx
80103dca:	ec                   	in     (%dx),%al
80103dcb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103dce:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103dd2:	c9                   	leave  
80103dd3:	c3                   	ret    

80103dd4 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103dd4:	55                   	push   %ebp
80103dd5:	89 e5                	mov    %esp,%ebp
80103dd7:	83 ec 08             	sub    $0x8,%esp
80103dda:	8b 55 08             	mov    0x8(%ebp),%edx
80103ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103de0:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103de4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103de7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103deb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103def:	ee                   	out    %al,(%dx)
}
80103df0:	90                   	nop
80103df1:	c9                   	leave  
80103df2:	c3                   	ret    

80103df3 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103df3:	55                   	push   %ebp
80103df4:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103df6:	a1 84 d6 10 80       	mov    0x8010d684,%eax
80103dfb:	89 c2                	mov    %eax,%edx
80103dfd:	b8 a0 43 11 80       	mov    $0x801143a0,%eax
80103e02:	29 c2                	sub    %eax,%edx
80103e04:	89 d0                	mov    %edx,%eax
80103e06:	c1 f8 02             	sar    $0x2,%eax
80103e09:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103e0f:	5d                   	pop    %ebp
80103e10:	c3                   	ret    

80103e11 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103e11:	55                   	push   %ebp
80103e12:	89 e5                	mov    %esp,%ebp
80103e14:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103e17:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103e25:	eb 15                	jmp    80103e3c <sum+0x2b>
    sum += addr[i];
80103e27:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103e2a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2d:	01 d0                	add    %edx,%eax
80103e2f:	0f b6 00             	movzbl (%eax),%eax
80103e32:	0f b6 c0             	movzbl %al,%eax
80103e35:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103e38:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103e3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103e42:	7c e3                	jl     80103e27 <sum+0x16>
    sum += addr[i];
  return sum;
80103e44:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103e47:	c9                   	leave  
80103e48:	c3                   	ret    

80103e49 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103e49:	55                   	push   %ebp
80103e4a:	89 e5                	mov    %esp,%ebp
80103e4c:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103e4f:	ff 75 08             	pushl  0x8(%ebp)
80103e52:	e8 53 ff ff ff       	call   80103daa <p2v>
80103e57:	83 c4 04             	add    $0x4,%esp
80103e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e63:	01 d0                	add    %edx,%eax
80103e65:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e6e:	eb 36                	jmp    80103ea6 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103e70:	83 ec 04             	sub    $0x4,%esp
80103e73:	6a 04                	push   $0x4
80103e75:	68 94 a3 10 80       	push   $0x8010a394
80103e7a:	ff 75 f4             	pushl  -0xc(%ebp)
80103e7d:	e8 01 2d 00 00       	call   80106b83 <memcmp>
80103e82:	83 c4 10             	add    $0x10,%esp
80103e85:	85 c0                	test   %eax,%eax
80103e87:	75 19                	jne    80103ea2 <mpsearch1+0x59>
80103e89:	83 ec 08             	sub    $0x8,%esp
80103e8c:	6a 10                	push   $0x10
80103e8e:	ff 75 f4             	pushl  -0xc(%ebp)
80103e91:	e8 7b ff ff ff       	call   80103e11 <sum>
80103e96:	83 c4 10             	add    $0x10,%esp
80103e99:	84 c0                	test   %al,%al
80103e9b:	75 05                	jne    80103ea2 <mpsearch1+0x59>
      return (struct mp*)p;
80103e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ea0:	eb 11                	jmp    80103eb3 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103ea2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ea9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103eac:	72 c2                	jb     80103e70 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103eb3:	c9                   	leave  
80103eb4:	c3                   	ret    

80103eb5 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103eb5:	55                   	push   %ebp
80103eb6:	89 e5                	mov    %esp,%ebp
80103eb8:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103ebb:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec5:	83 c0 0f             	add    $0xf,%eax
80103ec8:	0f b6 00             	movzbl (%eax),%eax
80103ecb:	0f b6 c0             	movzbl %al,%eax
80103ece:	c1 e0 08             	shl    $0x8,%eax
80103ed1:	89 c2                	mov    %eax,%edx
80103ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed6:	83 c0 0e             	add    $0xe,%eax
80103ed9:	0f b6 00             	movzbl (%eax),%eax
80103edc:	0f b6 c0             	movzbl %al,%eax
80103edf:	09 d0                	or     %edx,%eax
80103ee1:	c1 e0 04             	shl    $0x4,%eax
80103ee4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ee7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103eeb:	74 21                	je     80103f0e <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103eed:	83 ec 08             	sub    $0x8,%esp
80103ef0:	68 00 04 00 00       	push   $0x400
80103ef5:	ff 75 f0             	pushl  -0x10(%ebp)
80103ef8:	e8 4c ff ff ff       	call   80103e49 <mpsearch1>
80103efd:	83 c4 10             	add    $0x10,%esp
80103f00:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f07:	74 51                	je     80103f5a <mpsearch+0xa5>
      return mp;
80103f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f0c:	eb 61                	jmp    80103f6f <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f11:	83 c0 14             	add    $0x14,%eax
80103f14:	0f b6 00             	movzbl (%eax),%eax
80103f17:	0f b6 c0             	movzbl %al,%eax
80103f1a:	c1 e0 08             	shl    $0x8,%eax
80103f1d:	89 c2                	mov    %eax,%edx
80103f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f22:	83 c0 13             	add    $0x13,%eax
80103f25:	0f b6 00             	movzbl (%eax),%eax
80103f28:	0f b6 c0             	movzbl %al,%eax
80103f2b:	09 d0                	or     %edx,%eax
80103f2d:	c1 e0 0a             	shl    $0xa,%eax
80103f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f36:	2d 00 04 00 00       	sub    $0x400,%eax
80103f3b:	83 ec 08             	sub    $0x8,%esp
80103f3e:	68 00 04 00 00       	push   $0x400
80103f43:	50                   	push   %eax
80103f44:	e8 00 ff ff ff       	call   80103e49 <mpsearch1>
80103f49:	83 c4 10             	add    $0x10,%esp
80103f4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f53:	74 05                	je     80103f5a <mpsearch+0xa5>
      return mp;
80103f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f58:	eb 15                	jmp    80103f6f <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103f5a:	83 ec 08             	sub    $0x8,%esp
80103f5d:	68 00 00 01 00       	push   $0x10000
80103f62:	68 00 00 0f 00       	push   $0xf0000
80103f67:	e8 dd fe ff ff       	call   80103e49 <mpsearch1>
80103f6c:	83 c4 10             	add    $0x10,%esp
}
80103f6f:	c9                   	leave  
80103f70:	c3                   	ret    

80103f71 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103f71:	55                   	push   %ebp
80103f72:	89 e5                	mov    %esp,%ebp
80103f74:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103f77:	e8 39 ff ff ff       	call   80103eb5 <mpsearch>
80103f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f83:	74 0a                	je     80103f8f <mpconfig+0x1e>
80103f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f88:	8b 40 04             	mov    0x4(%eax),%eax
80103f8b:	85 c0                	test   %eax,%eax
80103f8d:	75 0a                	jne    80103f99 <mpconfig+0x28>
    return 0;
80103f8f:	b8 00 00 00 00       	mov    $0x0,%eax
80103f94:	e9 81 00 00 00       	jmp    8010401a <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f9c:	8b 40 04             	mov    0x4(%eax),%eax
80103f9f:	83 ec 0c             	sub    $0xc,%esp
80103fa2:	50                   	push   %eax
80103fa3:	e8 02 fe ff ff       	call   80103daa <p2v>
80103fa8:	83 c4 10             	add    $0x10,%esp
80103fab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103fae:	83 ec 04             	sub    $0x4,%esp
80103fb1:	6a 04                	push   $0x4
80103fb3:	68 99 a3 10 80       	push   $0x8010a399
80103fb8:	ff 75 f0             	pushl  -0x10(%ebp)
80103fbb:	e8 c3 2b 00 00       	call   80106b83 <memcmp>
80103fc0:	83 c4 10             	add    $0x10,%esp
80103fc3:	85 c0                	test   %eax,%eax
80103fc5:	74 07                	je     80103fce <mpconfig+0x5d>
    return 0;
80103fc7:	b8 00 00 00 00       	mov    $0x0,%eax
80103fcc:	eb 4c                	jmp    8010401a <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fd1:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103fd5:	3c 01                	cmp    $0x1,%al
80103fd7:	74 12                	je     80103feb <mpconfig+0x7a>
80103fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fdc:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103fe0:	3c 04                	cmp    $0x4,%al
80103fe2:	74 07                	je     80103feb <mpconfig+0x7a>
    return 0;
80103fe4:	b8 00 00 00 00       	mov    $0x0,%eax
80103fe9:	eb 2f                	jmp    8010401a <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fee:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103ff2:	0f b7 c0             	movzwl %ax,%eax
80103ff5:	83 ec 08             	sub    $0x8,%esp
80103ff8:	50                   	push   %eax
80103ff9:	ff 75 f0             	pushl  -0x10(%ebp)
80103ffc:	e8 10 fe ff ff       	call   80103e11 <sum>
80104001:	83 c4 10             	add    $0x10,%esp
80104004:	84 c0                	test   %al,%al
80104006:	74 07                	je     8010400f <mpconfig+0x9e>
    return 0;
80104008:	b8 00 00 00 00       	mov    $0x0,%eax
8010400d:	eb 0b                	jmp    8010401a <mpconfig+0xa9>
  *pmp = mp;
8010400f:	8b 45 08             	mov    0x8(%ebp),%eax
80104012:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104015:	89 10                	mov    %edx,(%eax)
  return conf;
80104017:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010401a:	c9                   	leave  
8010401b:	c3                   	ret    

8010401c <mpinit>:

void
mpinit(void)
{
8010401c:	55                   	push   %ebp
8010401d:	89 e5                	mov    %esp,%ebp
8010401f:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80104022:	c7 05 84 d6 10 80 a0 	movl   $0x801143a0,0x8010d684
80104029:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
8010402c:	83 ec 0c             	sub    $0xc,%esp
8010402f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104032:	50                   	push   %eax
80104033:	e8 39 ff ff ff       	call   80103f71 <mpconfig>
80104038:	83 c4 10             	add    $0x10,%esp
8010403b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010403e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104042:	0f 84 96 01 00 00    	je     801041de <mpinit+0x1c2>
    return;
  ismp = 1;
80104048:	c7 05 84 43 11 80 01 	movl   $0x1,0x80114384
8010404f:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80104052:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104055:	8b 40 24             	mov    0x24(%eax),%eax
80104058:	a3 9c 42 11 80       	mov    %eax,0x8011429c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010405d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104060:	83 c0 2c             	add    $0x2c,%eax
80104063:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104066:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104069:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010406d:	0f b7 d0             	movzwl %ax,%edx
80104070:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104073:	01 d0                	add    %edx,%eax
80104075:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104078:	e9 f2 00 00 00       	jmp    8010416f <mpinit+0x153>
    switch(*p){
8010407d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104080:	0f b6 00             	movzbl (%eax),%eax
80104083:	0f b6 c0             	movzbl %al,%eax
80104086:	83 f8 04             	cmp    $0x4,%eax
80104089:	0f 87 bc 00 00 00    	ja     8010414b <mpinit+0x12f>
8010408f:	8b 04 85 dc a3 10 80 	mov    -0x7fef5c24(,%eax,4),%eax
80104096:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80104098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
8010409e:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040a1:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040a5:	0f b6 d0             	movzbl %al,%edx
801040a8:	a1 80 49 11 80       	mov    0x80114980,%eax
801040ad:	39 c2                	cmp    %eax,%edx
801040af:	74 2b                	je     801040dc <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801040b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040b4:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040b8:	0f b6 d0             	movzbl %al,%edx
801040bb:	a1 80 49 11 80       	mov    0x80114980,%eax
801040c0:	83 ec 04             	sub    $0x4,%esp
801040c3:	52                   	push   %edx
801040c4:	50                   	push   %eax
801040c5:	68 9e a3 10 80       	push   $0x8010a39e
801040ca:	e8 f7 c2 ff ff       	call   801003c6 <cprintf>
801040cf:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
801040d2:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
801040d9:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801040dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040df:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801040e3:	0f b6 c0             	movzbl %al,%eax
801040e6:	83 e0 02             	and    $0x2,%eax
801040e9:	85 c0                	test   %eax,%eax
801040eb:	74 15                	je     80104102 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
801040ed:	a1 80 49 11 80       	mov    0x80114980,%eax
801040f2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801040f8:	05 a0 43 11 80       	add    $0x801143a0,%eax
801040fd:	a3 84 d6 10 80       	mov    %eax,0x8010d684
      cpus[ncpu].id = ncpu;
80104102:	a1 80 49 11 80       	mov    0x80114980,%eax
80104107:	8b 15 80 49 11 80    	mov    0x80114980,%edx
8010410d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80104113:	05 a0 43 11 80       	add    $0x801143a0,%eax
80104118:	88 10                	mov    %dl,(%eax)
      ncpu++;
8010411a:	a1 80 49 11 80       	mov    0x80114980,%eax
8010411f:	83 c0 01             	add    $0x1,%eax
80104122:	a3 80 49 11 80       	mov    %eax,0x80114980
      p += sizeof(struct mpproc);
80104127:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010412b:	eb 42                	jmp    8010416f <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010412d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104130:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80104133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104136:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010413a:	a2 80 43 11 80       	mov    %al,0x80114380
      p += sizeof(struct mpioapic);
8010413f:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104143:	eb 2a                	jmp    8010416f <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104145:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104149:	eb 24                	jmp    8010416f <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
8010414b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010414e:	0f b6 00             	movzbl (%eax),%eax
80104151:	0f b6 c0             	movzbl %al,%eax
80104154:	83 ec 08             	sub    $0x8,%esp
80104157:	50                   	push   %eax
80104158:	68 bc a3 10 80       	push   $0x8010a3bc
8010415d:	e8 64 c2 ff ff       	call   801003c6 <cprintf>
80104162:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80104165:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
8010416c:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010416f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104172:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104175:	0f 82 02 ff ff ff    	jb     8010407d <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
8010417b:	a1 84 43 11 80       	mov    0x80114384,%eax
80104180:	85 c0                	test   %eax,%eax
80104182:	75 1d                	jne    801041a1 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80104184:	c7 05 80 49 11 80 01 	movl   $0x1,0x80114980
8010418b:	00 00 00 
    lapic = 0;
8010418e:	c7 05 9c 42 11 80 00 	movl   $0x0,0x8011429c
80104195:	00 00 00 
    ioapicid = 0;
80104198:	c6 05 80 43 11 80 00 	movb   $0x0,0x80114380
    return;
8010419f:	eb 3e                	jmp    801041df <mpinit+0x1c3>
  }

  if(mp->imcrp){
801041a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801041a4:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801041a8:	84 c0                	test   %al,%al
801041aa:	74 33                	je     801041df <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801041ac:	83 ec 08             	sub    $0x8,%esp
801041af:	6a 70                	push   $0x70
801041b1:	6a 22                	push   $0x22
801041b3:	e8 1c fc ff ff       	call   80103dd4 <outb>
801041b8:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801041bb:	83 ec 0c             	sub    $0xc,%esp
801041be:	6a 23                	push   $0x23
801041c0:	e8 f2 fb ff ff       	call   80103db7 <inb>
801041c5:	83 c4 10             	add    $0x10,%esp
801041c8:	83 c8 01             	or     $0x1,%eax
801041cb:	0f b6 c0             	movzbl %al,%eax
801041ce:	83 ec 08             	sub    $0x8,%esp
801041d1:	50                   	push   %eax
801041d2:	6a 23                	push   $0x23
801041d4:	e8 fb fb ff ff       	call   80103dd4 <outb>
801041d9:	83 c4 10             	add    $0x10,%esp
801041dc:	eb 01                	jmp    801041df <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
801041de:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801041df:	c9                   	leave  
801041e0:	c3                   	ret    

801041e1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801041e1:	55                   	push   %ebp
801041e2:	89 e5                	mov    %esp,%ebp
801041e4:	83 ec 08             	sub    $0x8,%esp
801041e7:	8b 55 08             	mov    0x8(%ebp),%edx
801041ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801041ed:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801041f1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801041f4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801041f8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801041fc:	ee                   	out    %al,(%dx)
}
801041fd:	90                   	nop
801041fe:	c9                   	leave  
801041ff:	c3                   	ret    

80104200 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	83 ec 04             	sub    $0x4,%esp
80104206:	8b 45 08             	mov    0x8(%ebp),%eax
80104209:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
8010420d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104211:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80104217:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010421b:	0f b6 c0             	movzbl %al,%eax
8010421e:	50                   	push   %eax
8010421f:	6a 21                	push   $0x21
80104221:	e8 bb ff ff ff       	call   801041e1 <outb>
80104226:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80104229:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010422d:	66 c1 e8 08          	shr    $0x8,%ax
80104231:	0f b6 c0             	movzbl %al,%eax
80104234:	50                   	push   %eax
80104235:	68 a1 00 00 00       	push   $0xa1
8010423a:	e8 a2 ff ff ff       	call   801041e1 <outb>
8010423f:	83 c4 08             	add    $0x8,%esp
}
80104242:	90                   	nop
80104243:	c9                   	leave  
80104244:	c3                   	ret    

80104245 <picenable>:

void
picenable(int irq)
{
80104245:	55                   	push   %ebp
80104246:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80104248:	8b 45 08             	mov    0x8(%ebp),%eax
8010424b:	ba 01 00 00 00       	mov    $0x1,%edx
80104250:	89 c1                	mov    %eax,%ecx
80104252:	d3 e2                	shl    %cl,%edx
80104254:	89 d0                	mov    %edx,%eax
80104256:	f7 d0                	not    %eax
80104258:	89 c2                	mov    %eax,%edx
8010425a:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80104261:	21 d0                	and    %edx,%eax
80104263:	0f b7 c0             	movzwl %ax,%eax
80104266:	50                   	push   %eax
80104267:	e8 94 ff ff ff       	call   80104200 <picsetmask>
8010426c:	83 c4 04             	add    $0x4,%esp
}
8010426f:	90                   	nop
80104270:	c9                   	leave  
80104271:	c3                   	ret    

80104272 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104272:	55                   	push   %ebp
80104273:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104275:	68 ff 00 00 00       	push   $0xff
8010427a:	6a 21                	push   $0x21
8010427c:	e8 60 ff ff ff       	call   801041e1 <outb>
80104281:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104284:	68 ff 00 00 00       	push   $0xff
80104289:	68 a1 00 00 00       	push   $0xa1
8010428e:	e8 4e ff ff ff       	call   801041e1 <outb>
80104293:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104296:	6a 11                	push   $0x11
80104298:	6a 20                	push   $0x20
8010429a:	e8 42 ff ff ff       	call   801041e1 <outb>
8010429f:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
801042a2:	6a 20                	push   $0x20
801042a4:	6a 21                	push   $0x21
801042a6:	e8 36 ff ff ff       	call   801041e1 <outb>
801042ab:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
801042ae:	6a 04                	push   $0x4
801042b0:	6a 21                	push   $0x21
801042b2:	e8 2a ff ff ff       	call   801041e1 <outb>
801042b7:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801042ba:	6a 03                	push   $0x3
801042bc:	6a 21                	push   $0x21
801042be:	e8 1e ff ff ff       	call   801041e1 <outb>
801042c3:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
801042c6:	6a 11                	push   $0x11
801042c8:	68 a0 00 00 00       	push   $0xa0
801042cd:	e8 0f ff ff ff       	call   801041e1 <outb>
801042d2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
801042d5:	6a 28                	push   $0x28
801042d7:	68 a1 00 00 00       	push   $0xa1
801042dc:	e8 00 ff ff ff       	call   801041e1 <outb>
801042e1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801042e4:	6a 02                	push   $0x2
801042e6:	68 a1 00 00 00       	push   $0xa1
801042eb:	e8 f1 fe ff ff       	call   801041e1 <outb>
801042f0:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
801042f3:	6a 03                	push   $0x3
801042f5:	68 a1 00 00 00       	push   $0xa1
801042fa:	e8 e2 fe ff ff       	call   801041e1 <outb>
801042ff:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104302:	6a 68                	push   $0x68
80104304:	6a 20                	push   $0x20
80104306:	e8 d6 fe ff ff       	call   801041e1 <outb>
8010430b:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
8010430e:	6a 0a                	push   $0xa
80104310:	6a 20                	push   $0x20
80104312:	e8 ca fe ff ff       	call   801041e1 <outb>
80104317:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
8010431a:	6a 68                	push   $0x68
8010431c:	68 a0 00 00 00       	push   $0xa0
80104321:	e8 bb fe ff ff       	call   801041e1 <outb>
80104326:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104329:	6a 0a                	push   $0xa
8010432b:	68 a0 00 00 00       	push   $0xa0
80104330:	e8 ac fe ff ff       	call   801041e1 <outb>
80104335:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80104338:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010433f:	66 83 f8 ff          	cmp    $0xffff,%ax
80104343:	74 13                	je     80104358 <picinit+0xe6>
    picsetmask(irqmask);
80104345:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010434c:	0f b7 c0             	movzwl %ax,%eax
8010434f:	50                   	push   %eax
80104350:	e8 ab fe ff ff       	call   80104200 <picsetmask>
80104355:	83 c4 04             	add    $0x4,%esp
}
80104358:	90                   	nop
80104359:	c9                   	leave  
8010435a:	c3                   	ret    

8010435b <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010435b:	55                   	push   %ebp
8010435c:	89 e5                	mov    %esp,%ebp
8010435e:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104361:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104368:	8b 45 0c             	mov    0xc(%ebp),%eax
8010436b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104371:	8b 45 0c             	mov    0xc(%ebp),%eax
80104374:	8b 10                	mov    (%eax),%edx
80104376:	8b 45 08             	mov    0x8(%ebp),%eax
80104379:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010437b:	e8 68 cd ff ff       	call   801010e8 <filealloc>
80104380:	89 c2                	mov    %eax,%edx
80104382:	8b 45 08             	mov    0x8(%ebp),%eax
80104385:	89 10                	mov    %edx,(%eax)
80104387:	8b 45 08             	mov    0x8(%ebp),%eax
8010438a:	8b 00                	mov    (%eax),%eax
8010438c:	85 c0                	test   %eax,%eax
8010438e:	0f 84 cb 00 00 00    	je     8010445f <pipealloc+0x104>
80104394:	e8 4f cd ff ff       	call   801010e8 <filealloc>
80104399:	89 c2                	mov    %eax,%edx
8010439b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010439e:	89 10                	mov    %edx,(%eax)
801043a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801043a3:	8b 00                	mov    (%eax),%eax
801043a5:	85 c0                	test   %eax,%eax
801043a7:	0f 84 b2 00 00 00    	je     8010445f <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801043ad:	e8 ce eb ff ff       	call   80102f80 <kalloc>
801043b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043b9:	0f 84 9f 00 00 00    	je     8010445e <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801043bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c2:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801043c9:	00 00 00 
  p->writeopen = 1;
801043cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043cf:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801043d6:	00 00 00 
  p->nwrite = 0;
801043d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043dc:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801043e3:	00 00 00 
  p->nread = 0;
801043e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801043f0:	00 00 00 
  initlock(&p->lock, "pipe");
801043f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f6:	83 ec 08             	sub    $0x8,%esp
801043f9:	68 f0 a3 10 80       	push   $0x8010a3f0
801043fe:	50                   	push   %eax
801043ff:	e8 93 24 00 00       	call   80106897 <initlock>
80104404:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104407:	8b 45 08             	mov    0x8(%ebp),%eax
8010440a:	8b 00                	mov    (%eax),%eax
8010440c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104412:	8b 45 08             	mov    0x8(%ebp),%eax
80104415:	8b 00                	mov    (%eax),%eax
80104417:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010441b:	8b 45 08             	mov    0x8(%ebp),%eax
8010441e:	8b 00                	mov    (%eax),%eax
80104420:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104424:	8b 45 08             	mov    0x8(%ebp),%eax
80104427:	8b 00                	mov    (%eax),%eax
80104429:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010442c:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010442f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104432:	8b 00                	mov    (%eax),%eax
80104434:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010443a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010443d:	8b 00                	mov    (%eax),%eax
8010443f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104443:	8b 45 0c             	mov    0xc(%ebp),%eax
80104446:	8b 00                	mov    (%eax),%eax
80104448:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010444c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010444f:	8b 00                	mov    (%eax),%eax
80104451:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104454:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104457:	b8 00 00 00 00       	mov    $0x0,%eax
8010445c:	eb 4e                	jmp    801044ac <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
8010445e:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
8010445f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104463:	74 0e                	je     80104473 <pipealloc+0x118>
    kfree((char*)p);
80104465:	83 ec 0c             	sub    $0xc,%esp
80104468:	ff 75 f4             	pushl  -0xc(%ebp)
8010446b:	e8 73 ea ff ff       	call   80102ee3 <kfree>
80104470:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104473:	8b 45 08             	mov    0x8(%ebp),%eax
80104476:	8b 00                	mov    (%eax),%eax
80104478:	85 c0                	test   %eax,%eax
8010447a:	74 11                	je     8010448d <pipealloc+0x132>
    fileclose(*f0);
8010447c:	8b 45 08             	mov    0x8(%ebp),%eax
8010447f:	8b 00                	mov    (%eax),%eax
80104481:	83 ec 0c             	sub    $0xc,%esp
80104484:	50                   	push   %eax
80104485:	e8 1c cd ff ff       	call   801011a6 <fileclose>
8010448a:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010448d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104490:	8b 00                	mov    (%eax),%eax
80104492:	85 c0                	test   %eax,%eax
80104494:	74 11                	je     801044a7 <pipealloc+0x14c>
    fileclose(*f1);
80104496:	8b 45 0c             	mov    0xc(%ebp),%eax
80104499:	8b 00                	mov    (%eax),%eax
8010449b:	83 ec 0c             	sub    $0xc,%esp
8010449e:	50                   	push   %eax
8010449f:	e8 02 cd ff ff       	call   801011a6 <fileclose>
801044a4:	83 c4 10             	add    $0x10,%esp
  return -1;
801044a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044ac:	c9                   	leave  
801044ad:	c3                   	ret    

801044ae <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801044ae:	55                   	push   %ebp
801044af:	89 e5                	mov    %esp,%ebp
801044b1:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801044b4:	8b 45 08             	mov    0x8(%ebp),%eax
801044b7:	83 ec 0c             	sub    $0xc,%esp
801044ba:	50                   	push   %eax
801044bb:	e8 f9 23 00 00       	call   801068b9 <acquire>
801044c0:	83 c4 10             	add    $0x10,%esp
  if(writable){
801044c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801044c7:	74 23                	je     801044ec <pipeclose+0x3e>
    p->writeopen = 0;
801044c9:	8b 45 08             	mov    0x8(%ebp),%eax
801044cc:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801044d3:	00 00 00 
    wakeup(&p->nread);
801044d6:	8b 45 08             	mov    0x8(%ebp),%eax
801044d9:	05 34 02 00 00       	add    $0x234,%eax
801044de:	83 ec 0c             	sub    $0xc,%esp
801044e1:	50                   	push   %eax
801044e2:	e8 1d 13 00 00       	call   80105804 <wakeup>
801044e7:	83 c4 10             	add    $0x10,%esp
801044ea:	eb 21                	jmp    8010450d <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801044ec:	8b 45 08             	mov    0x8(%ebp),%eax
801044ef:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801044f6:	00 00 00 
    wakeup(&p->nwrite);
801044f9:	8b 45 08             	mov    0x8(%ebp),%eax
801044fc:	05 38 02 00 00       	add    $0x238,%eax
80104501:	83 ec 0c             	sub    $0xc,%esp
80104504:	50                   	push   %eax
80104505:	e8 fa 12 00 00       	call   80105804 <wakeup>
8010450a:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010450d:	8b 45 08             	mov    0x8(%ebp),%eax
80104510:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104516:	85 c0                	test   %eax,%eax
80104518:	75 2c                	jne    80104546 <pipeclose+0x98>
8010451a:	8b 45 08             	mov    0x8(%ebp),%eax
8010451d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104523:	85 c0                	test   %eax,%eax
80104525:	75 1f                	jne    80104546 <pipeclose+0x98>
    release(&p->lock);
80104527:	8b 45 08             	mov    0x8(%ebp),%eax
8010452a:	83 ec 0c             	sub    $0xc,%esp
8010452d:	50                   	push   %eax
8010452e:	e8 ed 23 00 00       	call   80106920 <release>
80104533:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104536:	83 ec 0c             	sub    $0xc,%esp
80104539:	ff 75 08             	pushl  0x8(%ebp)
8010453c:	e8 a2 e9 ff ff       	call   80102ee3 <kfree>
80104541:	83 c4 10             	add    $0x10,%esp
80104544:	eb 0f                	jmp    80104555 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104546:	8b 45 08             	mov    0x8(%ebp),%eax
80104549:	83 ec 0c             	sub    $0xc,%esp
8010454c:	50                   	push   %eax
8010454d:	e8 ce 23 00 00       	call   80106920 <release>
80104552:	83 c4 10             	add    $0x10,%esp
}
80104555:	90                   	nop
80104556:	c9                   	leave  
80104557:	c3                   	ret    

80104558 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104558:	55                   	push   %ebp
80104559:	89 e5                	mov    %esp,%ebp
8010455b:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010455e:	8b 45 08             	mov    0x8(%ebp),%eax
80104561:	83 ec 0c             	sub    $0xc,%esp
80104564:	50                   	push   %eax
80104565:	e8 4f 23 00 00       	call   801068b9 <acquire>
8010456a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
8010456d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104574:	e9 ad 00 00 00       	jmp    80104626 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104579:	8b 45 08             	mov    0x8(%ebp),%eax
8010457c:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104582:	85 c0                	test   %eax,%eax
80104584:	74 0d                	je     80104593 <pipewrite+0x3b>
80104586:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010458c:	8b 40 24             	mov    0x24(%eax),%eax
8010458f:	85 c0                	test   %eax,%eax
80104591:	74 19                	je     801045ac <pipewrite+0x54>
        release(&p->lock);
80104593:	8b 45 08             	mov    0x8(%ebp),%eax
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	50                   	push   %eax
8010459a:	e8 81 23 00 00       	call   80106920 <release>
8010459f:	83 c4 10             	add    $0x10,%esp
        return -1;
801045a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045a7:	e9 a8 00 00 00       	jmp    80104654 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801045ac:	8b 45 08             	mov    0x8(%ebp),%eax
801045af:	05 34 02 00 00       	add    $0x234,%eax
801045b4:	83 ec 0c             	sub    $0xc,%esp
801045b7:	50                   	push   %eax
801045b8:	e8 47 12 00 00       	call   80105804 <wakeup>
801045bd:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801045c0:	8b 45 08             	mov    0x8(%ebp),%eax
801045c3:	8b 55 08             	mov    0x8(%ebp),%edx
801045c6:	81 c2 38 02 00 00    	add    $0x238,%edx
801045cc:	83 ec 08             	sub    $0x8,%esp
801045cf:	50                   	push   %eax
801045d0:	52                   	push   %edx
801045d1:	e8 55 10 00 00       	call   8010562b <sleep>
801045d6:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801045d9:	8b 45 08             	mov    0x8(%ebp),%eax
801045dc:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801045e2:	8b 45 08             	mov    0x8(%ebp),%eax
801045e5:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801045eb:	05 00 02 00 00       	add    $0x200,%eax
801045f0:	39 c2                	cmp    %eax,%edx
801045f2:	74 85                	je     80104579 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801045f4:	8b 45 08             	mov    0x8(%ebp),%eax
801045f7:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801045fd:	8d 48 01             	lea    0x1(%eax),%ecx
80104600:	8b 55 08             	mov    0x8(%ebp),%edx
80104603:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104609:	25 ff 01 00 00       	and    $0x1ff,%eax
8010460e:	89 c1                	mov    %eax,%ecx
80104610:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104613:	8b 45 0c             	mov    0xc(%ebp),%eax
80104616:	01 d0                	add    %edx,%eax
80104618:	0f b6 10             	movzbl (%eax),%edx
8010461b:	8b 45 08             	mov    0x8(%ebp),%eax
8010461e:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104622:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104626:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104629:	3b 45 10             	cmp    0x10(%ebp),%eax
8010462c:	7c ab                	jl     801045d9 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010462e:	8b 45 08             	mov    0x8(%ebp),%eax
80104631:	05 34 02 00 00       	add    $0x234,%eax
80104636:	83 ec 0c             	sub    $0xc,%esp
80104639:	50                   	push   %eax
8010463a:	e8 c5 11 00 00       	call   80105804 <wakeup>
8010463f:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104642:	8b 45 08             	mov    0x8(%ebp),%eax
80104645:	83 ec 0c             	sub    $0xc,%esp
80104648:	50                   	push   %eax
80104649:	e8 d2 22 00 00       	call   80106920 <release>
8010464e:	83 c4 10             	add    $0x10,%esp
  return n;
80104651:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104654:	c9                   	leave  
80104655:	c3                   	ret    

80104656 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104656:	55                   	push   %ebp
80104657:	89 e5                	mov    %esp,%ebp
80104659:	53                   	push   %ebx
8010465a:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010465d:	8b 45 08             	mov    0x8(%ebp),%eax
80104660:	83 ec 0c             	sub    $0xc,%esp
80104663:	50                   	push   %eax
80104664:	e8 50 22 00 00       	call   801068b9 <acquire>
80104669:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010466c:	eb 3f                	jmp    801046ad <piperead+0x57>
    if(proc->killed){
8010466e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104674:	8b 40 24             	mov    0x24(%eax),%eax
80104677:	85 c0                	test   %eax,%eax
80104679:	74 19                	je     80104694 <piperead+0x3e>
      release(&p->lock);
8010467b:	8b 45 08             	mov    0x8(%ebp),%eax
8010467e:	83 ec 0c             	sub    $0xc,%esp
80104681:	50                   	push   %eax
80104682:	e8 99 22 00 00       	call   80106920 <release>
80104687:	83 c4 10             	add    $0x10,%esp
      return -1;
8010468a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010468f:	e9 bf 00 00 00       	jmp    80104753 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104694:	8b 45 08             	mov    0x8(%ebp),%eax
80104697:	8b 55 08             	mov    0x8(%ebp),%edx
8010469a:	81 c2 34 02 00 00    	add    $0x234,%edx
801046a0:	83 ec 08             	sub    $0x8,%esp
801046a3:	50                   	push   %eax
801046a4:	52                   	push   %edx
801046a5:	e8 81 0f 00 00       	call   8010562b <sleep>
801046aa:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801046ad:	8b 45 08             	mov    0x8(%ebp),%eax
801046b0:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801046b6:	8b 45 08             	mov    0x8(%ebp),%eax
801046b9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801046bf:	39 c2                	cmp    %eax,%edx
801046c1:	75 0d                	jne    801046d0 <piperead+0x7a>
801046c3:	8b 45 08             	mov    0x8(%ebp),%eax
801046c6:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801046cc:	85 c0                	test   %eax,%eax
801046ce:	75 9e                	jne    8010466e <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801046d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801046d7:	eb 49                	jmp    80104722 <piperead+0xcc>
    if(p->nread == p->nwrite)
801046d9:	8b 45 08             	mov    0x8(%ebp),%eax
801046dc:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801046e2:	8b 45 08             	mov    0x8(%ebp),%eax
801046e5:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801046eb:	39 c2                	cmp    %eax,%edx
801046ed:	74 3d                	je     8010472c <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801046ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801046f5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801046f8:	8b 45 08             	mov    0x8(%ebp),%eax
801046fb:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104701:	8d 48 01             	lea    0x1(%eax),%ecx
80104704:	8b 55 08             	mov    0x8(%ebp),%edx
80104707:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010470d:	25 ff 01 00 00       	and    $0x1ff,%eax
80104712:	89 c2                	mov    %eax,%edx
80104714:	8b 45 08             	mov    0x8(%ebp),%eax
80104717:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010471c:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010471e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104725:	3b 45 10             	cmp    0x10(%ebp),%eax
80104728:	7c af                	jl     801046d9 <piperead+0x83>
8010472a:	eb 01                	jmp    8010472d <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
8010472c:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010472d:	8b 45 08             	mov    0x8(%ebp),%eax
80104730:	05 38 02 00 00       	add    $0x238,%eax
80104735:	83 ec 0c             	sub    $0xc,%esp
80104738:	50                   	push   %eax
80104739:	e8 c6 10 00 00       	call   80105804 <wakeup>
8010473e:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104741:	8b 45 08             	mov    0x8(%ebp),%eax
80104744:	83 ec 0c             	sub    $0xc,%esp
80104747:	50                   	push   %eax
80104748:	e8 d3 21 00 00       	call   80106920 <release>
8010474d:	83 c4 10             	add    $0x10,%esp
  return i;
80104750:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104756:	c9                   	leave  
80104757:	c3                   	ret    

80104758 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
80104758:	55                   	push   %ebp
80104759:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
8010475b:	f4                   	hlt    
}
8010475c:	90                   	nop
8010475d:	5d                   	pop    %ebp
8010475e:	c3                   	ret    

8010475f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010475f:	55                   	push   %ebp
80104760:	89 e5                	mov    %esp,%ebp
80104762:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104765:	9c                   	pushf  
80104766:	58                   	pop    %eax
80104767:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010476a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010476d:	c9                   	leave  
8010476e:	c3                   	ret    

8010476f <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010476f:	55                   	push   %ebp
80104770:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104772:	fb                   	sti    
}
80104773:	90                   	nop
80104774:	5d                   	pop    %ebp
80104775:	c3                   	ret    

80104776 <pinit>:
static int promote_list(struct proc** list);
#endif

void
pinit(void)
{
80104776:	55                   	push   %ebp
80104777:	89 e5                	mov    %esp,%ebp
80104779:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010477c:	83 ec 08             	sub    $0x8,%esp
8010477f:	68 f8 a3 10 80       	push   $0x8010a3f8
80104784:	68 a0 49 11 80       	push   $0x801149a0
80104789:	e8 09 21 00 00       	call   80106897 <initlock>
8010478e:	83 c4 10             	add    $0x10,%esp
}
80104791:	90                   	nop
80104792:	c9                   	leave  
80104793:	c3                   	ret    

80104794 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010479a:	83 ec 0c             	sub    $0xc,%esp
8010479d:	68 a0 49 11 80       	push   $0x801149a0
801047a2:	e8 12 21 00 00       	call   801068b9 <acquire>
801047a7:	83 c4 10             	add    $0x10,%esp
  #else
  // Check to make sure the ptable has free procs available
  // remove from list wont return a negative number in this
  // case because we check p and the list against null before
  // passing it in to the function. 
  p = ptable.pLists.free;
801047aa:	a1 d4 70 11 80       	mov    0x801170d4,%eax
801047af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p) {
801047b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047b6:	0f 84 86 00 00 00    	je     80104842 <allocproc+0xae>
    remove_from_list(&ptable.pLists.free, p);
801047bc:	83 ec 08             	sub    $0x8,%esp
801047bf:	ff 75 f4             	pushl  -0xc(%ebp)
801047c2:	68 d4 70 11 80       	push   $0x801170d4
801047c7:	e8 37 1a 00 00       	call   80106203 <remove_from_list>
801047cc:	83 c4 10             	add    $0x10,%esp
    assert_state(p, UNUSED);
801047cf:	83 ec 08             	sub    $0x8,%esp
801047d2:	6a 00                	push   $0x0
801047d4:	ff 75 f4             	pushl  -0xc(%ebp)
801047d7:	e8 06 1a 00 00       	call   801061e2 <assert_state>
801047dc:	83 c4 10             	add    $0x10,%esp
    goto found;
801047df:	90                   	nop
  #endif
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801047e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e3:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  #ifdef CS333_P3P4
  // Process is checked against null before it reaches this function
  // so this function won't fail at this point.
  add_to_list(&ptable.pLists.embryo, EMBRYO, p);
801047ea:	83 ec 04             	sub    $0x4,%esp
801047ed:	ff 75 f4             	pushl  -0xc(%ebp)
801047f0:	6a 01                	push   $0x1
801047f2:	68 d8 70 11 80       	push   $0x801170d8
801047f7:	e8 b3 1a 00 00       	call   801062af <add_to_list>
801047fc:	83 c4 10             	add    $0x10,%esp
  #endif
  p->pid = nextpid++;
801047ff:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104804:	8d 50 01             	lea    0x1(%eax),%edx
80104807:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
8010480d:	89 c2                	mov    %eax,%edx
8010480f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104812:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
80104815:	83 ec 0c             	sub    $0xc,%esp
80104818:	68 a0 49 11 80       	push   $0x801149a0
8010481d:	e8 fe 20 00 00       	call   80106920 <release>
80104822:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104825:	e8 56 e7 ff ff       	call   80102f80 <kalloc>
8010482a:	89 c2                	mov    %eax,%edx
8010482c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482f:	89 50 08             	mov    %edx,0x8(%eax)
80104832:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104835:	8b 40 08             	mov    0x8(%eax),%eax
80104838:	85 c0                	test   %eax,%eax
8010483a:	0f 85 88 00 00 00    	jne    801048c8 <allocproc+0x134>
80104840:	eb 1a                	jmp    8010485c <allocproc+0xc8>
    remove_from_list(&ptable.pLists.free, p);
    assert_state(p, UNUSED);
    goto found;
  } 
  #endif
  release(&ptable.lock);
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	68 a0 49 11 80       	push   $0x801149a0
8010484a:	e8 d1 20 00 00       	call   80106920 <release>
8010484f:	83 c4 10             	add    $0x10,%esp
  return 0;
80104852:	b8 00 00 00 00       	mov    $0x0,%eax
80104857:	e9 09 01 00 00       	jmp    80104965 <allocproc+0x1d1>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    acquire(&ptable.lock);
8010485c:	83 ec 0c             	sub    $0xc,%esp
8010485f:	68 a0 49 11 80       	push   $0x801149a0
80104864:	e8 50 20 00 00       	call   801068b9 <acquire>
80104869:	83 c4 10             	add    $0x10,%esp
    #ifdef CS333_P3P4
    remove_from_list(&ptable.pLists.embryo, p);
8010486c:	83 ec 08             	sub    $0x8,%esp
8010486f:	ff 75 f4             	pushl  -0xc(%ebp)
80104872:	68 d8 70 11 80       	push   $0x801170d8
80104877:	e8 87 19 00 00       	call   80106203 <remove_from_list>
8010487c:	83 c4 10             	add    $0x10,%esp
    assert_state(p, EMBRYO);
8010487f:	83 ec 08             	sub    $0x8,%esp
80104882:	6a 01                	push   $0x1
80104884:	ff 75 f4             	pushl  -0xc(%ebp)
80104887:	e8 56 19 00 00       	call   801061e2 <assert_state>
8010488c:	83 c4 10             	add    $0x10,%esp
    #endif
    p->state = UNUSED;
8010488f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104892:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #ifdef CS333_P3P4
    add_to_list(&ptable.pLists.free, UNUSED, p);
80104899:	83 ec 04             	sub    $0x4,%esp
8010489c:	ff 75 f4             	pushl  -0xc(%ebp)
8010489f:	6a 00                	push   $0x0
801048a1:	68 d4 70 11 80       	push   $0x801170d4
801048a6:	e8 04 1a 00 00       	call   801062af <add_to_list>
801048ab:	83 c4 10             	add    $0x10,%esp
    #endif
    release(&ptable.lock);
801048ae:	83 ec 0c             	sub    $0xc,%esp
801048b1:	68 a0 49 11 80       	push   $0x801149a0
801048b6:	e8 65 20 00 00       	call   80106920 <release>
801048bb:	83 c4 10             	add    $0x10,%esp
    return 0;
801048be:	b8 00 00 00 00       	mov    $0x0,%eax
801048c3:	e9 9d 00 00 00       	jmp    80104965 <allocproc+0x1d1>
  }
  sp = p->kstack + KSTACKSIZE;
801048c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048cb:	8b 40 08             	mov    0x8(%eax),%eax
801048ce:	05 00 10 00 00       	add    $0x1000,%eax
801048d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801048d6:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801048da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048e0:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801048e3:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801048e7:	ba ea 81 10 80       	mov    $0x801081ea,%edx
801048ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048ef:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801048f1:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801048f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048fb:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801048fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104901:	8b 40 1c             	mov    0x1c(%eax),%eax
80104904:	83 ec 04             	sub    $0x4,%esp
80104907:	6a 14                	push   $0x14
80104909:	6a 00                	push   $0x0
8010490b:	50                   	push   %eax
8010490c:	e8 0b 22 00 00       	call   80106b1c <memset>
80104911:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104917:	8b 40 1c             	mov    0x1c(%eax),%eax
8010491a:	ba e5 55 10 80       	mov    $0x801055e5,%edx
8010491f:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // My code Allocate start ticks to global ticks variable
80104922:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80104928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010492b:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total = 0; // My code p2
8010492e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104931:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104938:	00 00 00 
  p->cpu_ticks_in = 0;    // My code p2
8010493b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010493e:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104945:	00 00 00 
  #ifdef CS333_P3P4
  p->priority = 0;        // My code p4
80104948:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010494b:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104952:	00 00 00 
  p->budget = DEFBUDGET;  // My code p4 TEST VAL
80104955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104958:	c7 80 94 00 00 00 f4 	movl   $0x1f4,0x94(%eax)
8010495f:	01 00 00 
  #endif
  return p;
80104962:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104965:	c9                   	leave  
80104966:	c3                   	ret    

80104967 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104967:	55                   	push   %ebp
80104968:	89 e5                	mov    %esp,%ebp
8010496a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  acquire(&ptable.lock);
8010496d:	83 ec 0c             	sub    $0xc,%esp
80104970:	68 a0 49 11 80       	push   $0x801149a0
80104975:	e8 3f 1f 00 00       	call   801068b9 <acquire>
8010497a:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.free = 0;
8010497d:	c7 05 d4 70 11 80 00 	movl   $0x0,0x801170d4
80104984:	00 00 00 
  ptable.pLists.embryo = 0;
80104987:	c7 05 d8 70 11 80 00 	movl   $0x0,0x801170d8
8010498e:	00 00 00 
  ptable.pLists.running = 0;
80104991:	c7 05 f4 70 11 80 00 	movl   $0x0,0x801170f4
80104998:	00 00 00 
  ptable.pLists.sleep = 0;
8010499b:	c7 05 f8 70 11 80 00 	movl   $0x0,0x801170f8
801049a2:	00 00 00 
  ptable.pLists.zombie = 0;
801049a5:	c7 05 fc 70 11 80 00 	movl   $0x0,0x801170fc
801049ac:	00 00 00 
  for (int i = 0; i < MAX+1; i++)
801049af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801049b6:	eb 17                	jmp    801049cf <userinit+0x68>
    ptable.pLists.ready[i] = 0;
801049b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049bb:	05 cc 09 00 00       	add    $0x9cc,%eax
801049c0:	c7 04 85 ac 49 11 80 	movl   $0x0,-0x7feeb654(,%eax,4)
801049c7:	00 00 00 00 
  ptable.pLists.free = 0;
  ptable.pLists.embryo = 0;
  ptable.pLists.running = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  for (int i = 0; i < MAX+1; i++)
801049cb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801049cf:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
801049d3:	7e e3                	jle    801049b8 <userinit+0x51>
    ptable.pLists.ready[i] = 0;

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049d5:	c7 45 f4 d4 49 11 80 	movl   $0x801149d4,-0xc(%ebp)
801049dc:	eb 1c                	jmp    801049fa <userinit+0x93>
    add_to_list(&ptable.pLists.free, UNUSED, p);  
801049de:	83 ec 04             	sub    $0x4,%esp
801049e1:	ff 75 f4             	pushl  -0xc(%ebp)
801049e4:	6a 00                	push   $0x0
801049e6:	68 d4 70 11 80       	push   $0x801170d4
801049eb:	e8 bf 18 00 00       	call   801062af <add_to_list>
801049f0:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.zombie = 0;
  for (int i = 0; i < MAX+1; i++)
    ptable.pLists.ready[i] = 0;

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049f3:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
801049fa:	81 7d f4 d4 70 11 80 	cmpl   $0x801170d4,-0xc(%ebp)
80104a01:	72 db                	jb     801049de <userinit+0x77>
    add_to_list(&ptable.pLists.free, UNUSED, p);  

  ptable.promote_at_time = TICKS_TO_PROMOTE;                         // P4: Init promote time to 5 seconds..
80104a03:	c7 05 00 71 11 80 20 	movl   $0x320,0x80117100
80104a0a:	03 00 00 
  release(&ptable.lock);
80104a0d:	83 ec 0c             	sub    $0xc,%esp
80104a10:	68 a0 49 11 80       	push   $0x801149a0
80104a15:	e8 06 1f 00 00       	call   80106920 <release>
80104a1a:	83 c4 10             	add    $0x10,%esp
  
  p = allocproc();
80104a1d:	e8 72 fd ff ff       	call   80104794 <allocproc>
80104a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a28:	a3 88 d6 10 80       	mov    %eax,0x8010d688
  if((p->pgdir = setupkvm()) == 0)
80104a2d:	e8 57 4e 00 00       	call   80109889 <setupkvm>
80104a32:	89 c2                	mov    %eax,%edx
80104a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a37:	89 50 04             	mov    %edx,0x4(%eax)
80104a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3d:	8b 40 04             	mov    0x4(%eax),%eax
80104a40:	85 c0                	test   %eax,%eax
80104a42:	75 0d                	jne    80104a51 <userinit+0xea>
    panic("userinit: out of memory?");
80104a44:	83 ec 0c             	sub    $0xc,%esp
80104a47:	68 ff a3 10 80       	push   $0x8010a3ff
80104a4c:	e8 15 bb ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104a51:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a59:	8b 40 04             	mov    0x4(%eax),%eax
80104a5c:	83 ec 04             	sub    $0x4,%esp
80104a5f:	52                   	push   %edx
80104a60:	68 20 d5 10 80       	push   $0x8010d520
80104a65:	50                   	push   %eax
80104a66:	e8 78 50 00 00       	call   80109ae3 <inituvm>
80104a6b:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a71:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a7a:	8b 40 18             	mov    0x18(%eax),%eax
80104a7d:	83 ec 04             	sub    $0x4,%esp
80104a80:	6a 4c                	push   $0x4c
80104a82:	6a 00                	push   $0x0
80104a84:	50                   	push   %eax
80104a85:	e8 92 20 00 00       	call   80106b1c <memset>
80104a8a:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a90:	8b 40 18             	mov    0x18(%eax),%eax
80104a93:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9c:	8b 40 18             	mov    0x18(%eax),%eax
80104a9f:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa8:	8b 40 18             	mov    0x18(%eax),%eax
80104aab:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aae:	8b 52 18             	mov    0x18(%edx),%edx
80104ab1:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104ab5:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104abc:	8b 40 18             	mov    0x18(%eax),%eax
80104abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ac2:	8b 52 18             	mov    0x18(%edx),%edx
80104ac5:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104ac9:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad0:	8b 40 18             	mov    0x18(%eax),%eax
80104ad3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104add:	8b 40 18             	mov    0x18(%eax),%eax
80104ae0:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aea:	8b 40 18             	mov    0x18(%eax),%eax
80104aed:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->uid = DEFAULTUID; // p2
80104af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104afe:	00 00 00 
  p->gid = DEFAULTGID; // p2
80104b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b04:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104b0b:	00 00 00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b11:	83 c0 6c             	add    $0x6c,%eax
80104b14:	83 ec 04             	sub    $0x4,%esp
80104b17:	6a 10                	push   $0x10
80104b19:	68 18 a4 10 80       	push   $0x8010a418
80104b1e:	50                   	push   %eax
80104b1f:	e8 fb 21 00 00       	call   80106d1f <safestrcpy>
80104b24:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104b27:	83 ec 0c             	sub    $0xc,%esp
80104b2a:	68 21 a4 10 80       	push   $0x8010a421
80104b2f:	e8 c1 db ff ff       	call   801026f5 <namei>
80104b34:	83 c4 10             	add    $0x10,%esp
80104b37:	89 c2                	mov    %eax,%edx
80104b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3c:	89 50 68             	mov    %edx,0x68(%eax)

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
80104b3f:	83 ec 0c             	sub    $0xc,%esp
80104b42:	68 a0 49 11 80       	push   $0x801149a0
80104b47:	e8 6d 1d 00 00       	call   801068b9 <acquire>
80104b4c:	83 c4 10             	add    $0x10,%esp
  remove_from_list(&ptable.pLists.embryo, p);
80104b4f:	83 ec 08             	sub    $0x8,%esp
80104b52:	ff 75 f4             	pushl  -0xc(%ebp)
80104b55:	68 d8 70 11 80       	push   $0x801170d8
80104b5a:	e8 a4 16 00 00       	call   80106203 <remove_from_list>
80104b5f:	83 c4 10             	add    $0x10,%esp
  assert_state(p, EMBRYO);
80104b62:	83 ec 08             	sub    $0x8,%esp
80104b65:	6a 01                	push   $0x1
80104b67:	ff 75 f4             	pushl  -0xc(%ebp)
80104b6a:	e8 73 16 00 00       	call   801061e2 <assert_state>
80104b6f:	83 c4 10             	add    $0x10,%esp
  #endif
  p->state = RUNNABLE;
80104b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  // Since it is the first process to be made I directly add to
  // the front of the ready list. Ocurrences after this use the
  // add to ready function.
  ptable.pLists.ready[0] = p;
80104b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b7f:	a3 dc 70 11 80       	mov    %eax,0x801170dc
  p->next = 0;
80104b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b87:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80104b8e:	00 00 00 
  release(&ptable.lock);
80104b91:	83 ec 0c             	sub    $0xc,%esp
80104b94:	68 a0 49 11 80       	push   $0x801149a0
80104b99:	e8 82 1d 00 00       	call   80106920 <release>
80104b9e:	83 c4 10             	add    $0x10,%esp
  #endif
}
80104ba1:	90                   	nop
80104ba2:	c9                   	leave  
80104ba3:	c3                   	ret    

80104ba4 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104ba4:	55                   	push   %ebp
80104ba5:	89 e5                	mov    %esp,%ebp
80104ba7:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104baa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb0:	8b 00                	mov    (%eax),%eax
80104bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104bb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104bb9:	7e 31                	jle    80104bec <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104bbb:	8b 55 08             	mov    0x8(%ebp),%edx
80104bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc1:	01 c2                	add    %eax,%edx
80104bc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bc9:	8b 40 04             	mov    0x4(%eax),%eax
80104bcc:	83 ec 04             	sub    $0x4,%esp
80104bcf:	52                   	push   %edx
80104bd0:	ff 75 f4             	pushl  -0xc(%ebp)
80104bd3:	50                   	push   %eax
80104bd4:	e8 57 50 00 00       	call   80109c30 <allocuvm>
80104bd9:	83 c4 10             	add    $0x10,%esp
80104bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104bdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104be3:	75 3e                	jne    80104c23 <growproc+0x7f>
      return -1;
80104be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bea:	eb 59                	jmp    80104c45 <growproc+0xa1>
  } else if(n < 0){
80104bec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104bf0:	79 31                	jns    80104c23 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104bf2:	8b 55 08             	mov    0x8(%ebp),%edx
80104bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf8:	01 c2                	add    %eax,%edx
80104bfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c00:	8b 40 04             	mov    0x4(%eax),%eax
80104c03:	83 ec 04             	sub    $0x4,%esp
80104c06:	52                   	push   %edx
80104c07:	ff 75 f4             	pushl  -0xc(%ebp)
80104c0a:	50                   	push   %eax
80104c0b:	e8 e9 50 00 00       	call   80109cf9 <deallocuvm>
80104c10:	83 c4 10             	add    $0x10,%esp
80104c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104c16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104c1a:	75 07                	jne    80104c23 <growproc+0x7f>
      return -1;
80104c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c21:	eb 22                	jmp    80104c45 <growproc+0xa1>
  }
  proc->sz = sz;
80104c23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c2c:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104c2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c34:	83 ec 0c             	sub    $0xc,%esp
80104c37:	50                   	push   %eax
80104c38:	e8 33 4d 00 00       	call   80109970 <switchuvm>
80104c3d:	83 c4 10             	add    $0x10,%esp
  return 0;
80104c40:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c45:	c9                   	leave  
80104c46:	c3                   	ret    

80104c47 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104c47:	55                   	push   %ebp
80104c48:	89 e5                	mov    %esp,%ebp
80104c4a:	57                   	push   %edi
80104c4b:	56                   	push   %esi
80104c4c:	53                   	push   %ebx
80104c4d:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104c50:	e8 3f fb ff ff       	call   80104794 <allocproc>
80104c55:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104c58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104c5c:	75 0a                	jne    80104c68 <fork+0x21>
    return -1;
80104c5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c63:	e9 4d 02 00 00       	jmp    80104eb5 <fork+0x26e>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104c68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c6e:	8b 10                	mov    (%eax),%edx
80104c70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c76:	8b 40 04             	mov    0x4(%eax),%eax
80104c79:	83 ec 08             	sub    $0x8,%esp
80104c7c:	52                   	push   %edx
80104c7d:	50                   	push   %eax
80104c7e:	e8 14 52 00 00       	call   80109e97 <copyuvm>
80104c83:	83 c4 10             	add    $0x10,%esp
80104c86:	89 c2                	mov    %eax,%edx
80104c88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c8b:	89 50 04             	mov    %edx,0x4(%eax)
80104c8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c91:	8b 40 04             	mov    0x4(%eax),%eax
80104c94:	85 c0                	test   %eax,%eax
80104c96:	0f 85 b4 00 00 00    	jne    80104d50 <fork+0x109>
    kfree(np->kstack);
80104c9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c9f:	8b 40 08             	mov    0x8(%eax),%eax
80104ca2:	83 ec 0c             	sub    $0xc,%esp
80104ca5:	50                   	push   %eax
80104ca6:	e8 38 e2 ff ff       	call   80102ee3 <kfree>
80104cab:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104cae:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cb1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104cb8:	83 ec 0c             	sub    $0xc,%esp
80104cbb:	68 a0 49 11 80       	push   $0x801149a0
80104cc0:	e8 f4 1b 00 00       	call   801068b9 <acquire>
80104cc5:	83 c4 10             	add    $0x10,%esp
    int code = remove_from_list(&ptable.pLists.embryo, np);
80104cc8:	83 ec 08             	sub    $0x8,%esp
80104ccb:	ff 75 e0             	pushl  -0x20(%ebp)
80104cce:	68 d8 70 11 80       	push   $0x801170d8
80104cd3:	e8 2b 15 00 00       	call   80106203 <remove_from_list>
80104cd8:	83 c4 10             	add    $0x10,%esp
80104cdb:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (code < 0)
80104cde:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104ce2:	79 0d                	jns    80104cf1 <fork+0xaa>
      panic("ERROR: Couldn't remove from embryo.");
80104ce4:	83 ec 0c             	sub    $0xc,%esp
80104ce7:	68 24 a4 10 80       	push   $0x8010a424
80104cec:	e8 75 b8 ff ff       	call   80100566 <panic>
    assert_state(np, EMBRYO);
80104cf1:	83 ec 08             	sub    $0x8,%esp
80104cf4:	6a 01                	push   $0x1
80104cf6:	ff 75 e0             	pushl  -0x20(%ebp)
80104cf9:	e8 e4 14 00 00       	call   801061e2 <assert_state>
80104cfe:	83 c4 10             	add    $0x10,%esp
    #endif
    np->state = UNUSED;
80104d01:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d04:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #ifdef CS333_P3P4
    int code2 = add_to_list(&ptable.pLists.free, UNUSED, np);
80104d0b:	83 ec 04             	sub    $0x4,%esp
80104d0e:	ff 75 e0             	pushl  -0x20(%ebp)
80104d11:	6a 00                	push   $0x0
80104d13:	68 d4 70 11 80       	push   $0x801170d4
80104d18:	e8 92 15 00 00       	call   801062af <add_to_list>
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (code2 < 0)
80104d23:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80104d27:	79 0d                	jns    80104d36 <fork+0xef>
      panic("ERROR: Couldn't add process back to free.");
80104d29:	83 ec 0c             	sub    $0xc,%esp
80104d2c:	68 48 a4 10 80       	push   $0x8010a448
80104d31:	e8 30 b8 ff ff       	call   80100566 <panic>
    release(&ptable.lock);
80104d36:	83 ec 0c             	sub    $0xc,%esp
80104d39:	68 a0 49 11 80       	push   $0x801149a0
80104d3e:	e8 dd 1b 00 00       	call   80106920 <release>
80104d43:	83 c4 10             	add    $0x10,%esp
    #endif
    return -1;
80104d46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d4b:	e9 65 01 00 00       	jmp    80104eb5 <fork+0x26e>
  }
  np->sz = proc->sz;
80104d50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d56:	8b 10                	mov    (%eax),%edx
80104d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d5b:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104d5d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d67:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d6d:	8b 50 18             	mov    0x18(%eax),%edx
80104d70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d76:	8b 40 18             	mov    0x18(%eax),%eax
80104d79:	89 c3                	mov    %eax,%ebx
80104d7b:	b8 13 00 00 00       	mov    $0x13,%eax
80104d80:	89 d7                	mov    %edx,%edi
80104d82:	89 de                	mov    %ebx,%esi
80104d84:	89 c1                	mov    %eax,%ecx
80104d86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // I'm pretty sure that this is where we put the uid/gid copy
  np -> uid = proc -> uid; // p2
80104d88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d8e:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d97:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np -> gid = proc -> gid; // p2
80104d9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104da9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dac:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104db5:	8b 40 18             	mov    0x18(%eax),%eax
80104db8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104dbf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104dc6:	eb 43                	jmp    80104e0b <fork+0x1c4>
    if(proc->ofile[i])
80104dc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104dd1:	83 c2 08             	add    $0x8,%edx
80104dd4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104dd8:	85 c0                	test   %eax,%eax
80104dda:	74 2b                	je     80104e07 <fork+0x1c0>
      np->ofile[i] = filedup(proc->ofile[i]);
80104ddc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104de5:	83 c2 08             	add    $0x8,%edx
80104de8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104dec:	83 ec 0c             	sub    $0xc,%esp
80104def:	50                   	push   %eax
80104df0:	e8 60 c3 ff ff       	call   80101155 <filedup>
80104df5:	83 c4 10             	add    $0x10,%esp
80104df8:	89 c1                	mov    %eax,%ecx
80104dfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dfd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e00:	83 c2 08             	add    $0x8,%edx
80104e03:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np -> gid = proc -> gid; // p2

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104e07:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104e0b:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104e0f:	7e b7                	jle    80104dc8 <fork+0x181>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104e11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e17:	8b 40 68             	mov    0x68(%eax),%eax
80104e1a:	83 ec 0c             	sub    $0xc,%esp
80104e1d:	50                   	push   %eax
80104e1e:	e8 8a cc ff ff       	call   80101aad <idup>
80104e23:	83 c4 10             	add    $0x10,%esp
80104e26:	89 c2                	mov    %eax,%edx
80104e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e2b:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104e2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e34:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e3a:	83 c0 6c             	add    $0x6c,%eax
80104e3d:	83 ec 04             	sub    $0x4,%esp
80104e40:	6a 10                	push   $0x10
80104e42:	52                   	push   %edx
80104e43:	50                   	push   %eax
80104e44:	e8 d6 1e 00 00       	call   80106d1f <safestrcpy>
80104e49:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e4f:	8b 40 10             	mov    0x10(%eax),%eax
80104e52:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104e55:	83 ec 0c             	sub    $0xc,%esp
80104e58:	68 a0 49 11 80       	push   $0x801149a0
80104e5d:	e8 57 1a 00 00       	call   801068b9 <acquire>
80104e62:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.embryo, np);
80104e65:	83 ec 08             	sub    $0x8,%esp
80104e68:	ff 75 e0             	pushl  -0x20(%ebp)
80104e6b:	68 d8 70 11 80       	push   $0x801170d8
80104e70:	e8 8e 13 00 00       	call   80106203 <remove_from_list>
80104e75:	83 c4 10             	add    $0x10,%esp
  assert_state(np, EMBRYO);
80104e78:	83 ec 08             	sub    $0x8,%esp
80104e7b:	6a 01                	push   $0x1
80104e7d:	ff 75 e0             	pushl  -0x20(%ebp)
80104e80:	e8 5d 13 00 00       	call   801061e2 <assert_state>
80104e85:	83 c4 10             	add    $0x10,%esp
  #endif
  np->state = RUNNABLE;
80104e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e8b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  add_to_ready(np, RUNNABLE);
80104e92:	83 ec 08             	sub    $0x8,%esp
80104e95:	6a 03                	push   $0x3
80104e97:	ff 75 e0             	pushl  -0x20(%ebp)
80104e9a:	e8 51 14 00 00       	call   801062f0 <add_to_ready>
80104e9f:	83 c4 10             	add    $0x10,%esp
  #endif
  release(&ptable.lock);
80104ea2:	83 ec 0c             	sub    $0xc,%esp
80104ea5:	68 a0 49 11 80       	push   $0x801149a0
80104eaa:	e8 71 1a 00 00       	call   80106920 <release>
80104eaf:	83 c4 10             	add    $0x10,%esp
  return pid;
80104eb2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80104eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb8:	5b                   	pop    %ebx
80104eb9:	5e                   	pop    %esi
80104eba:	5f                   	pop    %edi
80104ebb:	5d                   	pop    %ebp
80104ebc:	c3                   	ret    

80104ebd <exit>:
}

#else
void
exit(void)
{
80104ebd:	55                   	push   %ebp
80104ebe:	89 e5                	mov    %esp,%ebp
80104ec0:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int fd;

  if (proc == initproc)
80104ec3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104eca:	a1 88 d6 10 80       	mov    0x8010d688,%eax
80104ecf:	39 c2                	cmp    %eax,%edx
80104ed1:	75 0d                	jne    80104ee0 <exit+0x23>
    panic("init exiting");
80104ed3:	83 ec 0c             	sub    $0xc,%esp
80104ed6:	68 72 a4 10 80       	push   $0x8010a472
80104edb:	e8 86 b6 ff ff       	call   80100566 <panic>

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104ee0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104ee7:	eb 48                	jmp    80104f31 <exit+0x74>
    if(proc->ofile[fd]) {
80104ee9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eef:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ef2:	83 c2 08             	add    $0x8,%edx
80104ef5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ef9:	85 c0                	test   %eax,%eax
80104efb:	74 30                	je     80104f2d <exit+0x70>
      fileclose(proc->ofile[fd]);
80104efd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f06:	83 c2 08             	add    $0x8,%edx
80104f09:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f0d:	83 ec 0c             	sub    $0xc,%esp
80104f10:	50                   	push   %eax
80104f11:	e8 90 c2 ff ff       	call   801011a6 <fileclose>
80104f16:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104f19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f22:	83 c2 08             	add    $0x8,%edx
80104f25:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104f2c:	00 

  if (proc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104f2d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104f31:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104f35:	7e b2                	jle    80104ee9 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104f37:	e8 2b e9 ff ff       	call   80103867 <begin_op>
  iput(proc->cwd);
80104f3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f42:	8b 40 68             	mov    0x68(%eax),%eax
80104f45:	83 ec 0c             	sub    $0xc,%esp
80104f48:	50                   	push   %eax
80104f49:	e8 91 cd ff ff       	call   80101cdf <iput>
80104f4e:	83 c4 10             	add    $0x10,%esp
  end_op();
80104f51:	e8 9d e9 ff ff       	call   801038f3 <end_op>
  proc->cwd = 0;
80104f56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f5c:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104f63:	83 ec 0c             	sub    $0xc,%esp
80104f66:	68 a0 49 11 80       	push   $0x801149a0
80104f6b:	e8 49 19 00 00       	call   801068b9 <acquire>
80104f70:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104f73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f79:	8b 40 14             	mov    0x14(%eax),%eax
80104f7c:	83 ec 0c             	sub    $0xc,%esp
80104f7f:	50                   	push   %eax
80104f80:	e8 12 08 00 00       	call   80105797 <wakeup1>
80104f85:	83 c4 10             	add    $0x10,%esp

  // Run exit helper to check process parents against the
  // currently running process. 
  exit_helper(&ptable.pLists.embryo);
80104f88:	83 ec 0c             	sub    $0xc,%esp
80104f8b:	68 d8 70 11 80       	push   $0x801170d8
80104f90:	e8 2c 14 00 00       	call   801063c1 <exit_helper>
80104f95:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX+1; i++)
80104f98:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104f9f:	eb 23                	jmp    80104fc4 <exit+0x107>
    exit_helper(&ptable.pLists.ready[i]);
80104fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fa4:	05 cc 09 00 00       	add    $0x9cc,%eax
80104fa9:	c1 e0 02             	shl    $0x2,%eax
80104fac:	05 a0 49 11 80       	add    $0x801149a0,%eax
80104fb1:	83 c0 0c             	add    $0xc,%eax
80104fb4:	83 ec 0c             	sub    $0xc,%esp
80104fb7:	50                   	push   %eax
80104fb8:	e8 04 14 00 00       	call   801063c1 <exit_helper>
80104fbd:	83 c4 10             	add    $0x10,%esp
  wakeup1(proc->parent);

  // Run exit helper to check process parents against the
  // currently running process. 
  exit_helper(&ptable.pLists.embryo);
  for (int i = 0; i < MAX+1; i++)
80104fc0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104fc4:	83 7d ec 05          	cmpl   $0x5,-0x14(%ebp)
80104fc8:	7e d7                	jle    80104fa1 <exit+0xe4>
    exit_helper(&ptable.pLists.ready[i]);
  exit_helper(&ptable.pLists.running);
80104fca:	83 ec 0c             	sub    $0xc,%esp
80104fcd:	68 f4 70 11 80       	push   $0x801170f4
80104fd2:	e8 ea 13 00 00       	call   801063c1 <exit_helper>
80104fd7:	83 c4 10             	add    $0x10,%esp
  exit_helper(&ptable.pLists.sleep);
80104fda:	83 ec 0c             	sub    $0xc,%esp
80104fdd:	68 f8 70 11 80       	push   $0x801170f8
80104fe2:	e8 da 13 00 00       	call   801063c1 <exit_helper>
80104fe7:	83 c4 10             	add    $0x10,%esp

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
80104fea:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80104fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80104ff2:	eb 39                	jmp    8010502d <exit+0x170>
    if (p->parent == proc) {
80104ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff7:	8b 50 14             	mov    0x14(%eax),%edx
80104ffa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105000:	39 c2                	cmp    %eax,%edx
80105002:	75 1d                	jne    80105021 <exit+0x164>
      p->parent = initproc;
80105004:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
8010500a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010500d:	89 50 14             	mov    %edx,0x14(%eax)
      wakeup1(initproc);
80105010:	a1 88 d6 10 80       	mov    0x8010d688,%eax
80105015:	83 ec 0c             	sub    $0xc,%esp
80105018:	50                   	push   %eax
80105019:	e8 79 07 00 00       	call   80105797 <wakeup1>
8010501e:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
80105021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105024:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010502a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  exit_helper(&ptable.pLists.sleep);

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
  while (p) {
8010502d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105031:	75 c1                	jne    80104ff4 <exit+0x137>
      wakeup1(initproc);
    }
    p = p->next;
  }

  remove_from_list(&ptable.pLists.running, proc);
80105033:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105039:	83 ec 08             	sub    $0x8,%esp
8010503c:	50                   	push   %eax
8010503d:	68 f4 70 11 80       	push   $0x801170f4
80105042:	e8 bc 11 00 00       	call   80106203 <remove_from_list>
80105047:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
8010504a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105050:	83 ec 08             	sub    $0x8,%esp
80105053:	6a 04                	push   $0x4
80105055:	50                   	push   %eax
80105056:	e8 87 11 00 00       	call   801061e2 <assert_state>
8010505b:	83 c4 10             	add    $0x10,%esp
  proc->state = ZOMBIE;
8010505e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105064:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  add_to_list(&ptable.pLists.zombie, ZOMBIE, proc);
8010506b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105071:	83 ec 04             	sub    $0x4,%esp
80105074:	50                   	push   %eax
80105075:	6a 05                	push   $0x5
80105077:	68 fc 70 11 80       	push   $0x801170fc
8010507c:	e8 2e 12 00 00       	call   801062af <add_to_list>
80105081:	83 c4 10             	add    $0x10,%esp
  sched();
80105084:	e8 6d 03 00 00       	call   801053f6 <sched>
  panic("zombie exit");
80105089:	83 ec 0c             	sub    $0xc,%esp
8010508c:	68 7f a4 10 80       	push   $0x8010a47f
80105091:	e8 d0 b4 ff ff       	call   80100566 <panic>

80105096 <wait>:
}

#else
int
wait(void)
{
80105096:	55                   	push   %ebp
80105097:	89 e5                	mov    %esp,%ebp
80105099:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int havekids, pid;

  acquire(&ptable.lock);
8010509c:	83 ec 0c             	sub    $0xc,%esp
8010509f:	68 a0 49 11 80       	push   $0x801149a0
801050a4:	e8 10 18 00 00       	call   801068b9 <acquire>
801050a9:	83 c4 10             	add    $0x10,%esp
  for(;;) {
    // Scan through table looking for zombie children
    havekids = 0;
801050ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
801050b3:	a1 fc 70 11 80       	mov    0x801170fc,%eax
801050b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801050bb:	e9 f7 00 00 00       	jmp    801051b7 <wait+0x121>
      if (p->parent == proc) {
801050c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c3:	8b 50 14             	mov    0x14(%eax),%edx
801050c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050cc:	39 c2                	cmp    %eax,%edx
801050ce:	0f 85 d7 00 00 00    	jne    801051ab <wait+0x115>
        havekids = 1;
801050d4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
        // Found one.
        pid = p->pid;
801050db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050de:	8b 40 10             	mov    0x10(%eax),%eax
801050e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801050e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e7:	8b 40 08             	mov    0x8(%eax),%eax
801050ea:	83 ec 0c             	sub    $0xc,%esp
801050ed:	50                   	push   %eax
801050ee:	e8 f0 dd ff ff       	call   80102ee3 <kfree>
801050f3:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801050f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80105100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105103:	8b 40 04             	mov    0x4(%eax),%eax
80105106:	83 ec 0c             	sub    $0xc,%esp
80105109:	50                   	push   %eax
8010510a:	e8 a7 4c 00 00       	call   80109db6 <freevm>
8010510f:	83 c4 10             	add    $0x10,%esp
        remove_from_list(&ptable.pLists.zombie, p);
80105112:	83 ec 08             	sub    $0x8,%esp
80105115:	ff 75 f4             	pushl  -0xc(%ebp)
80105118:	68 fc 70 11 80       	push   $0x801170fc
8010511d:	e8 e1 10 00 00       	call   80106203 <remove_from_list>
80105122:	83 c4 10             	add    $0x10,%esp
        assert_state(p, ZOMBIE);
80105125:	83 ec 08             	sub    $0x8,%esp
80105128:	6a 05                	push   $0x5
8010512a:	ff 75 f4             	pushl  -0xc(%ebp)
8010512d:	e8 b0 10 00 00       	call   801061e2 <assert_state>
80105132:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80105135:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105138:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
8010513f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105142:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80105149:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010514c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80105153:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105156:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010515a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010515d:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->priority = 0;
80105164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105167:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010516e:	00 00 00 
        p->budget = 0;
80105171:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105174:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
8010517b:	00 00 00 
        add_to_list(&ptable.pLists.free, UNUSED, p);
8010517e:	83 ec 04             	sub    $0x4,%esp
80105181:	ff 75 f4             	pushl  -0xc(%ebp)
80105184:	6a 00                	push   $0x0
80105186:	68 d4 70 11 80       	push   $0x801170d4
8010518b:	e8 1f 11 00 00       	call   801062af <add_to_list>
80105190:	83 c4 10             	add    $0x10,%esp
        release(&ptable.lock);
80105193:	83 ec 0c             	sub    $0xc,%esp
80105196:	68 a0 49 11 80       	push   $0x801149a0
8010519b:	e8 80 17 00 00       	call   80106920 <release>
801051a0:	83 c4 10             	add    $0x10,%esp
        return pid;
801051a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051a6:	e9 cf 00 00 00       	jmp    8010527a <wait+0x1e4>
      }
      p = p->next;
801051ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ae:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801051b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    havekids = 0;

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
    while (p) {
801051b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051bb:	0f 85 ff fe ff ff    	jne    801050c0 <wait+0x2a>
    }

    // Run wait helper function to search each list and check
    // if process parent is the currently running process and
    // set havekids to 1 if that is the case.
    wait_helper(&ptable.pLists.embryo, &havekids);
801051c1:	83 ec 08             	sub    $0x8,%esp
801051c4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801051c7:	50                   	push   %eax
801051c8:	68 d8 70 11 80       	push   $0x801170d8
801051cd:	e8 30 12 00 00       	call   80106402 <wait_helper>
801051d2:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < MAX+1; i++)
801051d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801051dc:	eb 27                	jmp    80105205 <wait+0x16f>
      wait_helper(&ptable.pLists.ready[i], &havekids);
801051de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051e1:	05 cc 09 00 00       	add    $0x9cc,%eax
801051e6:	c1 e0 02             	shl    $0x2,%eax
801051e9:	05 a0 49 11 80       	add    $0x801149a0,%eax
801051ee:	8d 50 0c             	lea    0xc(%eax),%edx
801051f1:	83 ec 08             	sub    $0x8,%esp
801051f4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801051f7:	50                   	push   %eax
801051f8:	52                   	push   %edx
801051f9:	e8 04 12 00 00       	call   80106402 <wait_helper>
801051fe:	83 c4 10             	add    $0x10,%esp

    // Run wait helper function to search each list and check
    // if process parent is the currently running process and
    // set havekids to 1 if that is the case.
    wait_helper(&ptable.pLists.embryo, &havekids);
    for (int i = 0; i < MAX+1; i++)
80105201:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105205:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80105209:	7e d3                	jle    801051de <wait+0x148>
      wait_helper(&ptable.pLists.ready[i], &havekids);
    wait_helper(&ptable.pLists.running, &havekids);
8010520b:	83 ec 08             	sub    $0x8,%esp
8010520e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105211:	50                   	push   %eax
80105212:	68 f4 70 11 80       	push   $0x801170f4
80105217:	e8 e6 11 00 00       	call   80106402 <wait_helper>
8010521c:	83 c4 10             	add    $0x10,%esp
    wait_helper(&ptable.pLists.sleep, &havekids);
8010521f:	83 ec 08             	sub    $0x8,%esp
80105222:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105225:	50                   	push   %eax
80105226:	68 f8 70 11 80       	push   $0x801170f8
8010522b:	e8 d2 11 00 00       	call   80106402 <wait_helper>
80105230:	83 c4 10             	add    $0x10,%esp

    // No point waiting if we don't have any children
    if (!havekids || proc->killed) {
80105233:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105236:	85 c0                	test   %eax,%eax
80105238:	74 0d                	je     80105247 <wait+0x1b1>
8010523a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105240:	8b 40 24             	mov    0x24(%eax),%eax
80105243:	85 c0                	test   %eax,%eax
80105245:	74 17                	je     8010525e <wait+0x1c8>
      release(&ptable.lock);
80105247:	83 ec 0c             	sub    $0xc,%esp
8010524a:	68 a0 49 11 80       	push   $0x801149a0
8010524f:	e8 cc 16 00 00       	call   80106920 <release>
80105254:	83 c4 10             	add    $0x10,%esp
      return -1;
80105257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525c:	eb 1c                	jmp    8010527a <wait+0x1e4>
    }

    // Wait for children to exit. (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
8010525e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105264:	83 ec 08             	sub    $0x8,%esp
80105267:	68 a0 49 11 80       	push   $0x801149a0
8010526c:	50                   	push   %eax
8010526d:	e8 b9 03 00 00       	call   8010562b <sleep>
80105272:	83 c4 10             	add    $0x10,%esp
  }
80105275:	e9 32 fe ff ff       	jmp    801050ac <wait+0x16>
}
8010527a:	c9                   	leave  
8010527b:	c3                   	ret    

8010527c <scheduler>:
}

#else
void
scheduler(void)
{
8010527c:	55                   	push   %ebp
8010527d:	89 e5                	mov    %esp,%ebp
8010527f:	83 ec 18             	sub    $0x18,%esp
  struct proc* p = 0;
80105282:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int idle;  // for checking if processor is idle

  for(;;) {

    // Enable interrupts on this processor.
    sti();
80105289:	e8 e1 f4 ff ff       	call   8010476f <sti>
    idle = 1;   // assume idle unless we schedule a process
8010528e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    
    acquire(&ptable.lock); 
80105295:	83 ec 0c             	sub    $0xc,%esp
80105298:	68 a0 49 11 80       	push   $0x801149a0
8010529d:	e8 17 16 00 00       	call   801068b9 <acquire>
801052a2:	83 c4 10             	add    $0x10,%esp

    for (int i = 0; i < MAX+1; i++) {
801052a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801052ac:	e9 12 01 00 00       	jmp    801053c3 <scheduler+0x147>
      if (ticks == ptable.promote_at_time) {
801052b1:	8b 15 00 71 11 80    	mov    0x80117100,%edx
801052b7:	a1 20 79 11 80       	mov    0x80117920,%eax
801052bc:	39 c2                	cmp    %eax,%edx
801052be:	75 14                	jne    801052d4 <scheduler+0x58>
        priority_promotion();
801052c0:	e8 e1 13 00 00       	call   801066a6 <priority_promotion>
        ptable.promote_at_time = ticks + TICKS_TO_PROMOTE;
801052c5:	a1 20 79 11 80       	mov    0x80117920,%eax
801052ca:	05 20 03 00 00       	add    $0x320,%eax
801052cf:	a3 00 71 11 80       	mov    %eax,0x80117100
      }

      if (!ptable.pLists.ready[i])
801052d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052d7:	05 cc 09 00 00       	add    $0x9cc,%eax
801052dc:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
801052e3:	85 c0                	test   %eax,%eax
801052e5:	0f 84 d3 00 00 00    	je     801053be <scheduler+0x142>
        continue;
      p = ptable.pLists.ready[i];                                              // P4 changes
801052eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052ee:	05 cc 09 00 00       	add    $0x9cc,%eax
801052f3:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
801052fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p) {
801052fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105301:	0f 84 b8 00 00 00    	je     801053bf <scheduler+0x143>
        remove_from_list(&ptable.pLists.ready[i], p);
80105307:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010530a:	05 cc 09 00 00       	add    $0x9cc,%eax
8010530f:	c1 e0 02             	shl    $0x2,%eax
80105312:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105317:	83 c0 0c             	add    $0xc,%eax
8010531a:	83 ec 08             	sub    $0x8,%esp
8010531d:	ff 75 ec             	pushl  -0x14(%ebp)
80105320:	50                   	push   %eax
80105321:	e8 dd 0e 00 00       	call   80106203 <remove_from_list>
80105326:	83 c4 10             	add    $0x10,%esp
        assert_state(p, RUNNABLE);
80105329:	83 ec 08             	sub    $0x8,%esp
8010532c:	6a 03                	push   $0x3
8010532e:	ff 75 ec             	pushl  -0x14(%ebp)
80105331:	e8 ac 0e 00 00       	call   801061e2 <assert_state>
80105336:	83 c4 10             	add    $0x10,%esp
        idle = 0;  // not idle this timeslice
80105339:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        proc = p;
80105340:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105343:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
        switchuvm(p);
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	ff 75 ec             	pushl  -0x14(%ebp)
8010534f:	e8 1c 46 00 00       	call   80109970 <switchuvm>
80105354:	83 c4 10             	add    $0x10,%esp
        p->state = RUNNING;
80105357:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010535a:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
        add_to_list(&ptable.pLists.running, RUNNING, p);
80105361:	83 ec 04             	sub    $0x4,%esp
80105364:	ff 75 ec             	pushl  -0x14(%ebp)
80105367:	6a 04                	push   $0x4
80105369:	68 f4 70 11 80       	push   $0x801170f4
8010536e:	e8 3c 0f 00 00       	call   801062af <add_to_list>
80105373:	83 c4 10             	add    $0x10,%esp
        p->cpu_ticks_in = ticks;  // My code p3
80105376:	8b 15 20 79 11 80    	mov    0x80117920,%edx
8010537c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010537f:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
        swtch(&cpu->scheduler, proc->context);
80105385:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010538b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010538e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105395:	83 c2 04             	add    $0x4,%edx
80105398:	83 ec 08             	sub    $0x8,%esp
8010539b:	50                   	push   %eax
8010539c:	52                   	push   %edx
8010539d:	e8 ee 19 00 00       	call   80106d90 <swtch>
801053a2:	83 c4 10             	add    $0x10,%esp
        switchkvm();
801053a5:	e8 a9 45 00 00       	call   80109953 <switchkvm>
    
        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0; 
801053aa:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801053b1:	00 00 00 00 
        i = -1; // Set i to -1 so it increments to 0 and begins with the first queue again
801053b5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
801053bc:	eb 01                	jmp    801053bf <scheduler+0x143>
        priority_promotion();
        ptable.promote_at_time = ticks + TICKS_TO_PROMOTE;
      }

      if (!ptable.pLists.ready[i])
        continue;
801053be:	90                   	nop
    sti();
    idle = 1;   // assume idle unless we schedule a process
    
    acquire(&ptable.lock); 

    for (int i = 0; i < MAX+1; i++) {
801053bf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801053c3:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
801053c7:	0f 8e e4 fe ff ff    	jle    801052b1 <scheduler+0x35>
        proc = 0; 
        i = -1; // Set i to -1 so it increments to 0 and begins with the first queue again
      }
    }

    release(&ptable.lock);
801053cd:	83 ec 0c             	sub    $0xc,%esp
801053d0:	68 a0 49 11 80       	push   $0x801149a0
801053d5:	e8 46 15 00 00       	call   80106920 <release>
801053da:	83 c4 10             	add    $0x10,%esp
    if (idle) {
801053dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053e1:	0f 84 a2 fe ff ff    	je     80105289 <scheduler+0xd>
      sti();
801053e7:	e8 83 f3 ff ff       	call   8010476f <sti>
      hlt();
801053ec:	e8 67 f3 ff ff       	call   80104758 <hlt>
    }
  }
801053f1:	e9 93 fe ff ff       	jmp    80105289 <scheduler+0xd>

801053f6 <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
801053f6:	55                   	push   %ebp
801053f7:	89 e5                	mov    %esp,%ebp
801053f9:	53                   	push   %ebx
801053fa:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
801053fd:	83 ec 0c             	sub    $0xc,%esp
80105400:	68 a0 49 11 80       	push   $0x801149a0
80105405:	e8 e2 15 00 00       	call   801069ec <holding>
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	85 c0                	test   %eax,%eax
8010540f:	75 0d                	jne    8010541e <sched+0x28>
    panic("sched ptable.lock");
80105411:	83 ec 0c             	sub    $0xc,%esp
80105414:	68 8b a4 10 80       	push   $0x8010a48b
80105419:	e8 48 b1 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
8010541e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105424:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010542a:	83 f8 01             	cmp    $0x1,%eax
8010542d:	74 0d                	je     8010543c <sched+0x46>
    panic("sched locks");
8010542f:	83 ec 0c             	sub    $0xc,%esp
80105432:	68 9d a4 10 80       	push   $0x8010a49d
80105437:	e8 2a b1 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
8010543c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105442:	8b 40 0c             	mov    0xc(%eax),%eax
80105445:	83 f8 04             	cmp    $0x4,%eax
80105448:	75 0d                	jne    80105457 <sched+0x61>
    panic("sched running");
8010544a:	83 ec 0c             	sub    $0xc,%esp
8010544d:	68 a9 a4 10 80       	push   $0x8010a4a9
80105452:	e8 0f b1 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80105457:	e8 03 f3 ff ff       	call   8010475f <readeflags>
8010545c:	25 00 02 00 00       	and    $0x200,%eax
80105461:	85 c0                	test   %eax,%eax
80105463:	74 0d                	je     80105472 <sched+0x7c>
    panic("sched interruptible");
80105465:	83 ec 0c             	sub    $0xc,%esp
80105468:	68 b7 a4 10 80       	push   $0x8010a4b7
8010546d:	e8 f4 b0 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80105472:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105478:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010547e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // My code p2
80105481:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105487:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010548e:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80105494:	8b 1d 20 79 11 80    	mov    0x80117920,%ebx
8010549a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054a1:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801054a7:	29 d3                	sub    %edx,%ebx
801054a9:	89 da                	mov    %ebx,%edx
801054ab:	01 ca                	add    %ecx,%edx
801054ad:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
801054b3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054b9:	8b 40 04             	mov    0x4(%eax),%eax
801054bc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054c3:	83 c2 1c             	add    $0x1c,%edx
801054c6:	83 ec 08             	sub    $0x8,%esp
801054c9:	50                   	push   %eax
801054ca:	52                   	push   %edx
801054cb:	e8 c0 18 00 00       	call   80106d90 <swtch>
801054d0:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
801054d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054dc:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801054e2:	90                   	nop
801054e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054e6:	c9                   	leave  
801054e7:	c3                   	ret    

801054e8 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
801054e8:	55                   	push   %ebp
801054e9:	89 e5                	mov    %esp,%ebp
801054eb:	53                   	push   %ebx
801054ec:	83 ec 04             	sub    $0x4,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801054ef:	83 ec 0c             	sub    $0xc,%esp
801054f2:	68 a0 49 11 80       	push   $0x801149a0
801054f7:	e8 bd 13 00 00       	call   801068b9 <acquire>
801054fc:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
801054ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105505:	83 ec 08             	sub    $0x8,%esp
80105508:	50                   	push   %eax
80105509:	68 f4 70 11 80       	push   $0x801170f4
8010550e:	e8 f0 0c 00 00       	call   80106203 <remove_from_list>
80105513:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
80105516:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010551c:	83 ec 08             	sub    $0x8,%esp
8010551f:	6a 04                	push   $0x4
80105521:	50                   	push   %eax
80105522:	e8 bb 0c 00 00       	call   801061e2 <assert_state>
80105527:	83 c4 10             	add    $0x10,%esp
  #endif
  proc->state = RUNNABLE;
8010552a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105530:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
80105537:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010553d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105544:	8b 8a 94 00 00 00    	mov    0x94(%edx),%ecx
8010554a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105551:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
80105557:	8b 15 20 79 11 80    	mov    0x80117920,%edx
8010555d:	29 d3                	sub    %edx,%ebx
8010555f:	89 da                	mov    %ebx,%edx
80105561:	01 ca                	add    %ecx,%edx
80105563:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  if (proc->budget <= 0 && proc->priority < MAX) {
80105569:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010556f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105575:	85 c0                	test   %eax,%eax
80105577:	75 3d                	jne    801055b6 <yield+0xce>
80105579:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010557f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105585:	83 f8 04             	cmp    $0x4,%eax
80105588:	77 2c                	ja     801055b6 <yield+0xce>
    proc->priority = proc->priority+1;
8010558a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105590:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105597:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
8010559d:	83 c2 01             	add    $0x1,%edx
801055a0:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    proc->budget = DEFBUDGET;
801055a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055ac:	c7 80 94 00 00 00 f4 	movl   $0x1f4,0x94(%eax)
801055b3:	01 00 00 
  }
  add_to_ready(proc, RUNNABLE);
801055b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055bc:	83 ec 08             	sub    $0x8,%esp
801055bf:	6a 03                	push   $0x3
801055c1:	50                   	push   %eax
801055c2:	e8 29 0d 00 00       	call   801062f0 <add_to_ready>
801055c7:	83 c4 10             	add    $0x10,%esp
  #endif
  sched();
801055ca:	e8 27 fe ff ff       	call   801053f6 <sched>
  release(&ptable.lock);
801055cf:	83 ec 0c             	sub    $0xc,%esp
801055d2:	68 a0 49 11 80       	push   $0x801149a0
801055d7:	e8 44 13 00 00       	call   80106920 <release>
801055dc:	83 c4 10             	add    $0x10,%esp
}
801055df:	90                   	nop
801055e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055e3:	c9                   	leave  
801055e4:	c3                   	ret    

801055e5 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801055e5:	55                   	push   %ebp
801055e6:	89 e5                	mov    %esp,%ebp
801055e8:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801055eb:	83 ec 0c             	sub    $0xc,%esp
801055ee:	68 a0 49 11 80       	push   $0x801149a0
801055f3:	e8 28 13 00 00       	call   80106920 <release>
801055f8:	83 c4 10             	add    $0x10,%esp

  if (first) {
801055fb:	a1 20 d0 10 80       	mov    0x8010d020,%eax
80105600:	85 c0                	test   %eax,%eax
80105602:	74 24                	je     80105628 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105604:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
8010560b:	00 00 00 
    iinit(ROOTDEV);
8010560e:	83 ec 0c             	sub    $0xc,%esp
80105611:	6a 01                	push   $0x1
80105613:	e8 7b c1 ff ff       	call   80101793 <iinit>
80105618:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
8010561b:	83 ec 0c             	sub    $0xc,%esp
8010561e:	6a 01                	push   $0x1
80105620:	e8 24 e0 ff ff       	call   80103649 <initlog>
80105625:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105628:	90                   	nop
80105629:	c9                   	leave  
8010562a:	c3                   	ret    

8010562b <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
8010562b:	55                   	push   %ebp
8010562c:	89 e5                	mov    %esp,%ebp
8010562e:	53                   	push   %ebx
8010562f:	83 ec 04             	sub    $0x4,%esp
  if(proc == 0)
80105632:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105638:	85 c0                	test   %eax,%eax
8010563a:	75 0d                	jne    80105649 <sleep+0x1e>
    panic("sleep");
8010563c:	83 ec 0c             	sub    $0xc,%esp
8010563f:	68 cb a4 10 80       	push   $0x8010a4cb
80105644:	e8 1d af ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80105649:	81 7d 0c a0 49 11 80 	cmpl   $0x801149a0,0xc(%ebp)
80105650:	74 24                	je     80105676 <sleep+0x4b>
    acquire(&ptable.lock);
80105652:	83 ec 0c             	sub    $0xc,%esp
80105655:	68 a0 49 11 80       	push   $0x801149a0
8010565a:	e8 5a 12 00 00       	call   801068b9 <acquire>
8010565f:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105662:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105666:	74 0e                	je     80105676 <sleep+0x4b>
80105668:	83 ec 0c             	sub    $0xc,%esp
8010566b:	ff 75 0c             	pushl  0xc(%ebp)
8010566e:	e8 ad 12 00 00       	call   80106920 <release>
80105673:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80105676:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010567c:	8b 55 08             	mov    0x8(%ebp),%edx
8010567f:	89 50 20             	mov    %edx,0x20(%eax)
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
80105682:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105688:	83 ec 08             	sub    $0x8,%esp
8010568b:	50                   	push   %eax
8010568c:	68 f4 70 11 80       	push   $0x801170f4
80105691:	e8 6d 0b 00 00       	call   80106203 <remove_from_list>
80105696:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
80105699:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010569f:	83 ec 08             	sub    $0x8,%esp
801056a2:	6a 04                	push   $0x4
801056a4:	50                   	push   %eax
801056a5:	e8 38 0b 00 00       	call   801061e2 <assert_state>
801056aa:	83 c4 10             	add    $0x10,%esp
  #endif
  proc->state = SLEEPING;
801056ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  #ifdef CS333_P3P4
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
801056ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801056c7:	8b 8a 94 00 00 00    	mov    0x94(%edx),%ecx
801056cd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801056d4:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
801056da:	8b 15 20 79 11 80    	mov    0x80117920,%edx
801056e0:	29 d3                	sub    %edx,%ebx
801056e2:	89 da                	mov    %ebx,%edx
801056e4:	01 ca                	add    %ecx,%edx
801056e6:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  if (proc->budget <= 0 && proc->priority < MAX) {
801056ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056f2:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801056f8:	85 c0                	test   %eax,%eax
801056fa:	75 3d                	jne    80105739 <sleep+0x10e>
801056fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105702:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105708:	83 f8 04             	cmp    $0x4,%eax
8010570b:	77 2c                	ja     80105739 <sleep+0x10e>
    proc->priority = proc->priority+1;
8010570d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105713:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010571a:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
80105720:	83 c2 01             	add    $0x1,%edx
80105723:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    proc->budget = DEFBUDGET;
80105729:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010572f:	c7 80 94 00 00 00 f4 	movl   $0x1f4,0x94(%eax)
80105736:	01 00 00 
  }
  add_to_list(&ptable.pLists.sleep, SLEEPING, proc);
80105739:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010573f:	83 ec 04             	sub    $0x4,%esp
80105742:	50                   	push   %eax
80105743:	6a 02                	push   $0x2
80105745:	68 f8 70 11 80       	push   $0x801170f8
8010574a:	e8 60 0b 00 00       	call   801062af <add_to_list>
8010574f:	83 c4 10             	add    $0x10,%esp
  #endif
  sched();
80105752:	e8 9f fc ff ff       	call   801053f6 <sched>

  // Tidy up.
  proc->chan = 0;
80105757:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010575d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
80105764:	81 7d 0c a0 49 11 80 	cmpl   $0x801149a0,0xc(%ebp)
8010576b:	74 24                	je     80105791 <sleep+0x166>
    release(&ptable.lock);
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	68 a0 49 11 80       	push   $0x801149a0
80105775:	e8 a6 11 00 00       	call   80106920 <release>
8010577a:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
8010577d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105781:	74 0e                	je     80105791 <sleep+0x166>
80105783:	83 ec 0c             	sub    $0xc,%esp
80105786:	ff 75 0c             	pushl  0xc(%ebp)
80105789:	e8 2b 11 00 00       	call   801068b9 <acquire>
8010578e:	83 c4 10             	add    $0x10,%esp
  }
}
80105791:	90                   	nop
80105792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105795:	c9                   	leave  
80105796:	c3                   	ret    

80105797 <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
80105797:	55                   	push   %ebp
80105798:	89 e5                	mov    %esp,%ebp
8010579a:	83 ec 18             	sub    $0x18,%esp
  struct proc* p = ptable.pLists.sleep;
8010579d:	a1 f8 70 11 80       	mov    0x801170f8,%eax
801057a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
801057a5:	eb 54                	jmp    801057fb <wakeup1+0x64>
    if (p->chan == chan) {
801057a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057aa:	8b 40 20             	mov    0x20(%eax),%eax
801057ad:	3b 45 08             	cmp    0x8(%ebp),%eax
801057b0:	75 3d                	jne    801057ef <wakeup1+0x58>
      remove_from_list(&ptable.pLists.sleep, p);
801057b2:	83 ec 08             	sub    $0x8,%esp
801057b5:	ff 75 f4             	pushl  -0xc(%ebp)
801057b8:	68 f8 70 11 80       	push   $0x801170f8
801057bd:	e8 41 0a 00 00       	call   80106203 <remove_from_list>
801057c2:	83 c4 10             	add    $0x10,%esp
      assert_state(p, SLEEPING);
801057c5:	83 ec 08             	sub    $0x8,%esp
801057c8:	6a 02                	push   $0x2
801057ca:	ff 75 f4             	pushl  -0xc(%ebp)
801057cd:	e8 10 0a 00 00       	call   801061e2 <assert_state>
801057d2:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
801057d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      add_to_ready(p, RUNNABLE);
801057df:	83 ec 08             	sub    $0x8,%esp
801057e2:	6a 03                	push   $0x3
801057e4:	ff 75 f4             	pushl  -0xc(%ebp)
801057e7:	e8 04 0b 00 00       	call   801062f0 <add_to_ready>
801057ec:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
801057ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f2:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801057f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
#else
static void
wakeup1(void *chan)
{
  struct proc* p = ptable.pLists.sleep;
  while (p) {
801057fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057ff:	75 a6                	jne    801057a7 <wakeup1+0x10>
      p->state = RUNNABLE;
      add_to_ready(p, RUNNABLE);
    }
    p = p->next;
  }
}
80105801:	90                   	nop
80105802:	c9                   	leave  
80105803:	c3                   	ret    

80105804 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105804:	55                   	push   %ebp
80105805:	89 e5                	mov    %esp,%ebp
80105807:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010580a:	83 ec 0c             	sub    $0xc,%esp
8010580d:	68 a0 49 11 80       	push   $0x801149a0
80105812:	e8 a2 10 00 00       	call   801068b9 <acquire>
80105817:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010581a:	83 ec 0c             	sub    $0xc,%esp
8010581d:	ff 75 08             	pushl  0x8(%ebp)
80105820:	e8 72 ff ff ff       	call   80105797 <wakeup1>
80105825:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	68 a0 49 11 80       	push   $0x801149a0
80105830:	e8 eb 10 00 00       	call   80106920 <release>
80105835:	83 c4 10             	add    $0x10,%esp
}
80105838:	90                   	nop
80105839:	c9                   	leave  
8010583a:	c3                   	ret    

8010583b <kill>:
}

#else
int
kill(int pid)
{
8010583b:	55                   	push   %ebp
8010583c:	89 e5                	mov    %esp,%ebp
8010583e:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;

  acquire(&ptable.lock);
80105841:	83 ec 0c             	sub    $0xc,%esp
80105844:	68 a0 49 11 80       	push   $0x801149a0
80105849:	e8 6b 10 00 00       	call   801068b9 <acquire>
8010584e:	83 c4 10             	add    $0x10,%esp
  // Search through embryo
  p = ptable.pLists.embryo;
80105851:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80105856:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80105859:	eb 3d                	jmp    80105898 <kill+0x5d>
    if (p->pid == pid) {
8010585b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585e:	8b 50 10             	mov    0x10(%eax),%edx
80105861:	8b 45 08             	mov    0x8(%ebp),%eax
80105864:	39 c2                	cmp    %eax,%edx
80105866:	75 24                	jne    8010588c <kill+0x51>
      p->killed = 1;
80105868:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
80105872:	83 ec 0c             	sub    $0xc,%esp
80105875:	68 a0 49 11 80       	push   $0x801149a0
8010587a:	e8 a1 10 00 00       	call   80106920 <release>
8010587f:	83 c4 10             	add    $0x10,%esp
      return 0;
80105882:	b8 00 00 00 00       	mov    $0x0,%eax
80105887:	e9 65 01 00 00       	jmp    801059f1 <kill+0x1b6>
    }
    p = p->next;
8010588c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010588f:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105895:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc* p;

  acquire(&ptable.lock);
  // Search through embryo
  p = ptable.pLists.embryo;
  while (p) {
80105898:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010589c:	75 bd                	jne    8010585b <kill+0x20>
      return 0;
    }
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
8010589e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801058a5:	eb 5b                	jmp    80105902 <kill+0xc7>
    p = ptable.pLists.ready[i];
801058a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058aa:	05 cc 09 00 00       	add    $0x9cc,%eax
801058af:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
801058b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801058b9:	eb 3d                	jmp    801058f8 <kill+0xbd>
      if (p->pid == pid) {
801058bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058be:	8b 50 10             	mov    0x10(%eax),%edx
801058c1:	8b 45 08             	mov    0x8(%ebp),%eax
801058c4:	39 c2                	cmp    %eax,%edx
801058c6:	75 24                	jne    801058ec <kill+0xb1>
        p->killed = 1;
801058c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058cb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        release(&ptable.lock);
801058d2:	83 ec 0c             	sub    $0xc,%esp
801058d5:	68 a0 49 11 80       	push   $0x801149a0
801058da:	e8 41 10 00 00       	call   80106920 <release>
801058df:	83 c4 10             	add    $0x10,%esp
        return 0;
801058e2:	b8 00 00 00 00       	mov    $0x0,%eax
801058e7:	e9 05 01 00 00       	jmp    801059f1 <kill+0x1b6>
      }
      p = p->next;
801058ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ef:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801058f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
    p = ptable.pLists.ready[i];
    while (p) {
801058f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058fc:	75 bd                	jne    801058bb <kill+0x80>
      return 0;
    }
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
801058fe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105902:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80105906:	7e 9f                	jle    801058a7 <kill+0x6c>
      }
      p = p->next;
    }
  }
  // Search through embryo
  p = ptable.pLists.running;
80105908:	a1 f4 70 11 80       	mov    0x801170f4,%eax
8010590d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80105910:	eb 3d                	jmp    8010594f <kill+0x114>
    if (p->pid == pid) {
80105912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105915:	8b 50 10             	mov    0x10(%eax),%edx
80105918:	8b 45 08             	mov    0x8(%ebp),%eax
8010591b:	39 c2                	cmp    %eax,%edx
8010591d:	75 24                	jne    80105943 <kill+0x108>
      p->killed = 1;
8010591f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105922:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
80105929:	83 ec 0c             	sub    $0xc,%esp
8010592c:	68 a0 49 11 80       	push   $0x801149a0
80105931:	e8 ea 0f 00 00       	call   80106920 <release>
80105936:	83 c4 10             	add    $0x10,%esp
      return 0;
80105939:	b8 00 00 00 00       	mov    $0x0,%eax
8010593e:	e9 ae 00 00 00       	jmp    801059f1 <kill+0x1b6>
    }
    p = p->next;
80105943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105946:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010594c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      p = p->next;
    }
  }
  // Search through embryo
  p = ptable.pLists.running;
  while (p) {
8010594f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105953:	75 bd                	jne    80105912 <kill+0xd7>
      return 0;
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
80105955:	a1 f8 70 11 80       	mov    0x801170f8,%eax
8010595a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
8010595d:	eb 77                	jmp    801059d6 <kill+0x19b>
    if (p->pid == pid) {
8010595f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105962:	8b 50 10             	mov    0x10(%eax),%edx
80105965:	8b 45 08             	mov    0x8(%ebp),%eax
80105968:	39 c2                	cmp    %eax,%edx
8010596a:	75 5e                	jne    801059ca <kill+0x18f>
      p->killed = 1;
8010596c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      remove_from_list(&ptable.pLists.sleep, p);
80105976:	83 ec 08             	sub    $0x8,%esp
80105979:	ff 75 f4             	pushl  -0xc(%ebp)
8010597c:	68 f8 70 11 80       	push   $0x801170f8
80105981:	e8 7d 08 00 00       	call   80106203 <remove_from_list>
80105986:	83 c4 10             	add    $0x10,%esp
      assert_state(p, SLEEPING);
80105989:	83 ec 08             	sub    $0x8,%esp
8010598c:	6a 02                	push   $0x2
8010598e:	ff 75 f4             	pushl  -0xc(%ebp)
80105991:	e8 4c 08 00 00       	call   801061e2 <assert_state>
80105996:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
80105999:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010599c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      add_to_ready(p, RUNNABLE);
801059a3:	83 ec 08             	sub    $0x8,%esp
801059a6:	6a 03                	push   $0x3
801059a8:	ff 75 f4             	pushl  -0xc(%ebp)
801059ab:	e8 40 09 00 00       	call   801062f0 <add_to_ready>
801059b0:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
801059b3:	83 ec 0c             	sub    $0xc,%esp
801059b6:	68 a0 49 11 80       	push   $0x801149a0
801059bb:	e8 60 0f 00 00       	call   80106920 <release>
801059c0:	83 c4 10             	add    $0x10,%esp
      return 0;
801059c3:	b8 00 00 00 00       	mov    $0x0,%eax
801059c8:	eb 27                	jmp    801059f1 <kill+0x1b6>
    }
    p = p->next;
801059ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059cd:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801059d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
  while (p) {
801059d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059da:	75 83                	jne    8010595f <kill+0x124>
      return 0;
    }
    p = p->next;
  }

  release(&ptable.lock);
801059dc:	83 ec 0c             	sub    $0xc,%esp
801059df:	68 a0 49 11 80       	push   $0x801149a0
801059e4:	e8 37 0f 00 00       	call   80106920 <release>
801059e9:	83 c4 10             	add    $0x10,%esp
  return -1;
801059ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f1:	c9                   	leave  
801059f2:	c3                   	ret    

801059f3 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801059f3:	55                   	push   %ebp
801059f4:	89 e5                	mov    %esp,%ebp
801059f6:	53                   	push   %ebx
801059f7:	83 ec 54             	sub    $0x54,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
801059fa:	83 ec 04             	sub    $0x4,%esp
801059fd:	68 fb a4 10 80       	push   $0x8010a4fb
80105a02:	68 ff a4 10 80       	push   $0x8010a4ff
80105a07:	68 03 a5 10 80       	push   $0x8010a503
80105a0c:	68 0b a5 10 80       	push   $0x8010a50b
80105a11:	68 11 a5 10 80       	push   $0x8010a511
80105a16:	68 16 a5 10 80       	push   $0x8010a516
80105a1b:	68 1b a5 10 80       	push   $0x8010a51b
80105a20:	68 1f a5 10 80       	push   $0x8010a51f
80105a25:	68 23 a5 10 80       	push   $0x8010a523
80105a2a:	68 28 a5 10 80       	push   $0x8010a528
80105a2f:	68 2c a5 10 80       	push   $0x8010a52c
80105a34:	e8 8d a9 ff ff       	call   801003c6 <cprintf>
80105a39:	83 c4 30             	add    $0x30,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105a3c:	c7 45 f0 d4 49 11 80 	movl   $0x801149d4,-0x10(%ebp)
80105a43:	e9 31 02 00 00       	jmp    80105c79 <procdump+0x286>
    if(p->state == UNUSED)
80105a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a4b:	8b 40 0c             	mov    0xc(%eax),%eax
80105a4e:	85 c0                	test   %eax,%eax
80105a50:	0f 84 1b 02 00 00    	je     80105c71 <procdump+0x27e>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a59:	8b 40 0c             	mov    0xc(%eax),%eax
80105a5c:	83 f8 05             	cmp    $0x5,%eax
80105a5f:	77 23                	ja     80105a84 <procdump+0x91>
80105a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a64:	8b 40 0c             	mov    0xc(%eax),%eax
80105a67:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105a6e:	85 c0                	test   %eax,%eax
80105a70:	74 12                	je     80105a84 <procdump+0x91>
      state = states[p->state];
80105a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a75:	8b 40 0c             	mov    0xc(%eax),%eax
80105a78:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105a7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105a82:	eb 07                	jmp    80105a8b <procdump+0x98>
    else
      state = "???";
80105a84:	c7 45 ec 55 a5 10 80 	movl   $0x8010a555,-0x14(%ebp)
    uint seconds = (ticks - p->start_ticks)/100;
80105a8b:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a94:	8b 40 7c             	mov    0x7c(%eax),%eax
80105a97:	29 c2                	sub    %eax,%edx
80105a99:	89 d0                	mov    %edx,%eax
80105a9b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105aa0:	f7 e2                	mul    %edx
80105aa2:	89 d0                	mov    %edx,%eax
80105aa4:	c1 e8 05             	shr    $0x5,%eax
80105aa7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint partial_seconds = (ticks - p->start_ticks)%100;
80105aaa:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab3:	8b 40 7c             	mov    0x7c(%eax),%eax
80105ab6:	89 d1                	mov    %edx,%ecx
80105ab8:	29 c1                	sub    %eax,%ecx
80105aba:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105abf:	89 c8                	mov    %ecx,%eax
80105ac1:	f7 e2                	mul    %edx
80105ac3:	89 d0                	mov    %edx,%eax
80105ac5:	c1 e8 05             	shr    $0x5,%eax
80105ac8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ace:	6b c0 64             	imul   $0x64,%eax,%eax
80105ad1:	29 c1                	sub    %eax,%ecx
80105ad3:	89 c8                	mov    %ecx,%eax
80105ad5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("%d\t %s\t\t %d\t %d\t", p->pid, p->name, p->uid, p->gid);
80105ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105adb:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ae4:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aed:	8d 58 6c             	lea    0x6c(%eax),%ebx
80105af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af3:	8b 40 10             	mov    0x10(%eax),%eax
80105af6:	83 ec 0c             	sub    $0xc,%esp
80105af9:	51                   	push   %ecx
80105afa:	52                   	push   %edx
80105afb:	53                   	push   %ebx
80105afc:	50                   	push   %eax
80105afd:	68 59 a5 10 80       	push   $0x8010a559
80105b02:	e8 bf a8 ff ff       	call   801003c6 <cprintf>
80105b07:	83 c4 20             	add    $0x20,%esp
    if (p->parent)
80105b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b0d:	8b 40 14             	mov    0x14(%eax),%eax
80105b10:	85 c0                	test   %eax,%eax
80105b12:	74 1c                	je     80105b30 <procdump+0x13d>
      cprintf(" %d\t", p->parent->pid);
80105b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b17:	8b 40 14             	mov    0x14(%eax),%eax
80105b1a:	8b 40 10             	mov    0x10(%eax),%eax
80105b1d:	83 ec 08             	sub    $0x8,%esp
80105b20:	50                   	push   %eax
80105b21:	68 6a a5 10 80       	push   $0x8010a56a
80105b26:	e8 9b a8 ff ff       	call   801003c6 <cprintf>
80105b2b:	83 c4 10             	add    $0x10,%esp
80105b2e:	eb 17                	jmp    80105b47 <procdump+0x154>
    else
      cprintf(" %d\t", p->pid);
80105b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b33:	8b 40 10             	mov    0x10(%eax),%eax
80105b36:	83 ec 08             	sub    $0x8,%esp
80105b39:	50                   	push   %eax
80105b3a:	68 6a a5 10 80       	push   $0x8010a56a
80105b3f:	e8 82 a8 ff ff       	call   801003c6 <cprintf>
80105b44:	83 c4 10             	add    $0x10,%esp
    cprintf(" %d\t %s\t %d.", p->priority, state, seconds);
80105b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b50:	ff 75 e8             	pushl  -0x18(%ebp)
80105b53:	ff 75 ec             	pushl  -0x14(%ebp)
80105b56:	50                   	push   %eax
80105b57:	68 6f a5 10 80       	push   $0x8010a56f
80105b5c:	e8 65 a8 ff ff       	call   801003c6 <cprintf>
80105b61:	83 c4 10             	add    $0x10,%esp
    if (partial_seconds < 10)
80105b64:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
80105b68:	77 10                	ja     80105b7a <procdump+0x187>
	cprintf("0");
80105b6a:	83 ec 0c             	sub    $0xc,%esp
80105b6d:	68 7c a5 10 80       	push   $0x8010a57c
80105b72:	e8 4f a8 ff ff       	call   801003c6 <cprintf>
80105b77:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t", partial_seconds);
80105b7a:	83 ec 08             	sub    $0x8,%esp
80105b7d:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b80:	68 7e a5 10 80       	push   $0x8010a57e
80105b85:	e8 3c a8 ff ff       	call   801003c6 <cprintf>
80105b8a:	83 c4 10             	add    $0x10,%esp
    uint cpu_seconds = p->cpu_ticks_total/100;
80105b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b90:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105b96:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105b9b:	f7 e2                	mul    %edx
80105b9d:	89 d0                	mov    %edx,%eax
80105b9f:	c1 e8 05             	shr    $0x5,%eax
80105ba2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    uint cpu_partial_seconds = p->cpu_ticks_total%100;
80105ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ba8:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80105bae:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105bb3:	89 c8                	mov    %ecx,%eax
80105bb5:	f7 e2                	mul    %edx
80105bb7:	89 d0                	mov    %edx,%eax
80105bb9:	c1 e8 05             	shr    $0x5,%eax
80105bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105bbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bc2:	6b c0 64             	imul   $0x64,%eax,%eax
80105bc5:	29 c1                	sub    %eax,%ecx
80105bc7:	89 c8                	mov    %ecx,%eax
80105bc9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (cpu_partial_seconds < 10)
80105bcc:	83 7d dc 09          	cmpl   $0x9,-0x24(%ebp)
80105bd0:	77 18                	ja     80105bea <procdump+0x1f7>
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
80105bd2:	83 ec 04             	sub    $0x4,%esp
80105bd5:	ff 75 dc             	pushl  -0x24(%ebp)
80105bd8:	ff 75 e0             	pushl  -0x20(%ebp)
80105bdb:	68 82 a5 10 80       	push   $0x8010a582
80105be0:	e8 e1 a7 ff ff       	call   801003c6 <cprintf>
80105be5:	83 c4 10             	add    $0x10,%esp
80105be8:	eb 16                	jmp    80105c00 <procdump+0x20d>
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
80105bea:	83 ec 04             	sub    $0x4,%esp
80105bed:	ff 75 dc             	pushl  -0x24(%ebp)
80105bf0:	ff 75 e0             	pushl  -0x20(%ebp)
80105bf3:	68 8c a5 10 80       	push   $0x8010a58c
80105bf8:	e8 c9 a7 ff ff       	call   801003c6 <cprintf>
80105bfd:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c03:	8b 40 0c             	mov    0xc(%eax),%eax
80105c06:	83 f8 02             	cmp    $0x2,%eax
80105c09:	75 54                	jne    80105c5f <procdump+0x26c>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c11:	8b 40 0c             	mov    0xc(%eax),%eax
80105c14:	83 c0 08             	add    $0x8,%eax
80105c17:	89 c2                	mov    %eax,%edx
80105c19:	83 ec 08             	sub    $0x8,%esp
80105c1c:	8d 45 b4             	lea    -0x4c(%ebp),%eax
80105c1f:	50                   	push   %eax
80105c20:	52                   	push   %edx
80105c21:	e8 4c 0d 00 00       	call   80106972 <getcallerpcs>
80105c26:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105c29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105c30:	eb 1c                	jmp    80105c4e <procdump+0x25b>
        cprintf(" %p", pc[i]);
80105c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c35:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
80105c39:	83 ec 08             	sub    $0x8,%esp
80105c3c:	50                   	push   %eax
80105c3d:	68 95 a5 10 80       	push   $0x8010a595
80105c42:	e8 7f a7 ff ff       	call   801003c6 <cprintf>
80105c47:	83 c4 10             	add    $0x10,%esp
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105c4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105c4e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105c52:	7f 0b                	jg     80105c5f <procdump+0x26c>
80105c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c57:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
80105c5b:	85 c0                	test   %eax,%eax
80105c5d:	75 d3                	jne    80105c32 <procdump+0x23f>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105c5f:	83 ec 0c             	sub    $0xc,%esp
80105c62:	68 99 a5 10 80       	push   $0x8010a599
80105c67:	e8 5a a7 ff ff       	call   801003c6 <cprintf>
80105c6c:	83 c4 10             	add    $0x10,%esp
80105c6f:	eb 01                	jmp    80105c72 <procdump+0x27f>
  uint pc[10];
  
  cprintf("%s\t %s\t\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105c71:	90                   	nop
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105c72:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105c79:	81 7d f0 d4 70 11 80 	cmpl   $0x801170d4,-0x10(%ebp)
80105c80:	0f 82 c2 fd ff ff    	jb     80105a48 <procdump+0x55>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105c86:	90                   	nop
80105c87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c8a:	c9                   	leave  
80105c8b:	c3                   	ret    

80105c8c <getproc_helper>:

int
getproc_helper(int m, struct uproc* table)
{
80105c8c:	55                   	push   %ebp
80105c8d:	89 e5                	mov    %esp,%ebp
80105c8f:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int i = 0;
80105c92:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
80105c99:	c7 45 f4 d4 49 11 80 	movl   $0x801149d4,-0xc(%ebp)
80105ca0:	e9 ac 01 00 00       	jmp    80105e51 <getproc_helper+0x1c5>
  {
    if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
80105ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca8:	8b 40 0c             	mov    0xc(%eax),%eax
80105cab:	83 f8 04             	cmp    $0x4,%eax
80105cae:	74 1a                	je     80105cca <getproc_helper+0x3e>
80105cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb3:	8b 40 0c             	mov    0xc(%eax),%eax
80105cb6:	83 f8 03             	cmp    $0x3,%eax
80105cb9:	74 0f                	je     80105cca <getproc_helper+0x3e>
80105cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cbe:	8b 40 0c             	mov    0xc(%eax),%eax
80105cc1:	83 f8 02             	cmp    $0x2,%eax
80105cc4:	0f 85 80 01 00 00    	jne    80105e4a <getproc_helper+0x1be>
    {
      table[i].pid = p->pid;
80105cca:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ccd:	89 d0                	mov    %edx,%eax
80105ccf:	01 c0                	add    %eax,%eax
80105cd1:	01 d0                	add    %edx,%eax
80105cd3:	c1 e0 05             	shl    $0x5,%eax
80105cd6:	89 c2                	mov    %eax,%edx
80105cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cdb:	01 c2                	add    %eax,%edx
80105cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce0:	8b 40 10             	mov    0x10(%eax),%eax
80105ce3:	89 02                	mov    %eax,(%edx)
      table[i].uid = p->uid;
80105ce5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ce8:	89 d0                	mov    %edx,%eax
80105cea:	01 c0                	add    %eax,%eax
80105cec:	01 d0                	add    %edx,%eax
80105cee:	c1 e0 05             	shl    $0x5,%eax
80105cf1:	89 c2                	mov    %eax,%edx
80105cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cf6:	01 c2                	add    %eax,%edx
80105cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfb:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105d01:	89 42 04             	mov    %eax,0x4(%edx)
      table[i].gid = p->gid;
80105d04:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d07:	89 d0                	mov    %edx,%eax
80105d09:	01 c0                	add    %eax,%eax
80105d0b:	01 d0                	add    %edx,%eax
80105d0d:	c1 e0 05             	shl    $0x5,%eax
80105d10:	89 c2                	mov    %eax,%edx
80105d12:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d15:	01 c2                	add    %eax,%edx
80105d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d1a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105d20:	89 42 08             	mov    %eax,0x8(%edx)
      if (p->parent)
80105d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d26:	8b 40 14             	mov    0x14(%eax),%eax
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	74 21                	je     80105d4e <getproc_helper+0xc2>
        table[i].ppid = p->parent->pid;
80105d2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d30:	89 d0                	mov    %edx,%eax
80105d32:	01 c0                	add    %eax,%eax
80105d34:	01 d0                	add    %edx,%eax
80105d36:	c1 e0 05             	shl    $0x5,%eax
80105d39:	89 c2                	mov    %eax,%edx
80105d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d3e:	01 c2                	add    %eax,%edx
80105d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d43:	8b 40 14             	mov    0x14(%eax),%eax
80105d46:	8b 40 10             	mov    0x10(%eax),%eax
80105d49:	89 42 0c             	mov    %eax,0xc(%edx)
80105d4c:	eb 1c                	jmp    80105d6a <getproc_helper+0xde>
      else
        table[i].ppid = p->pid;
80105d4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d51:	89 d0                	mov    %edx,%eax
80105d53:	01 c0                	add    %eax,%eax
80105d55:	01 d0                	add    %edx,%eax
80105d57:	c1 e0 05             	shl    $0x5,%eax
80105d5a:	89 c2                	mov    %eax,%edx
80105d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d5f:	01 c2                	add    %eax,%edx
80105d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d64:	8b 40 10             	mov    0x10(%eax),%eax
80105d67:	89 42 0c             	mov    %eax,0xc(%edx)
      table[i].priority = p->priority;
80105d6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d6d:	89 d0                	mov    %edx,%eax
80105d6f:	01 c0                	add    %eax,%eax
80105d71:	01 d0                	add    %edx,%eax
80105d73:	c1 e0 05             	shl    $0x5,%eax
80105d76:	89 c2                	mov    %eax,%edx
80105d78:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d7b:	01 c2                	add    %eax,%edx
80105d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d80:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d86:	89 42 10             	mov    %eax,0x10(%edx)
      table[i].elapsed_ticks = (ticks - p->start_ticks);
80105d89:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d8c:	89 d0                	mov    %edx,%eax
80105d8e:	01 c0                	add    %eax,%eax
80105d90:	01 d0                	add    %edx,%eax
80105d92:	c1 e0 05             	shl    $0x5,%eax
80105d95:	89 c2                	mov    %eax,%edx
80105d97:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d9a:	01 c2                	add    %eax,%edx
80105d9c:	8b 0d 20 79 11 80    	mov    0x80117920,%ecx
80105da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da5:	8b 40 7c             	mov    0x7c(%eax),%eax
80105da8:	29 c1                	sub    %eax,%ecx
80105daa:	89 c8                	mov    %ecx,%eax
80105dac:	89 42 14             	mov    %eax,0x14(%edx)
      table[i].CPU_total_ticks = p->cpu_ticks_total;
80105daf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105db2:	89 d0                	mov    %edx,%eax
80105db4:	01 c0                	add    %eax,%eax
80105db6:	01 d0                	add    %edx,%eax
80105db8:	c1 e0 05             	shl    $0x5,%eax
80105dbb:	89 c2                	mov    %eax,%edx
80105dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dc0:	01 c2                	add    %eax,%edx
80105dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc5:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105dcb:	89 42 18             	mov    %eax,0x18(%edx)
      table[i].size = p->sz;
80105dce:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105dd1:	89 d0                	mov    %edx,%eax
80105dd3:	01 c0                	add    %eax,%eax
80105dd5:	01 d0                	add    %edx,%eax
80105dd7:	c1 e0 05             	shl    $0x5,%eax
80105dda:	89 c2                	mov    %eax,%edx
80105ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ddf:	01 c2                	add    %eax,%edx
80105de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de4:	8b 00                	mov    (%eax),%eax
80105de6:	89 42 3c             	mov    %eax,0x3c(%edx)
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
80105de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dec:	8b 40 0c             	mov    0xc(%eax),%eax
80105def:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
80105df6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105df9:	89 d0                	mov    %edx,%eax
80105dfb:	01 c0                	add    %eax,%eax
80105dfd:	01 d0                	add    %edx,%eax
80105dff:	c1 e0 05             	shl    $0x5,%eax
80105e02:	89 c2                	mov    %eax,%edx
80105e04:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e07:	01 d0                	add    %edx,%eax
80105e09:	83 c0 1c             	add    $0x1c,%eax
80105e0c:	83 ec 04             	sub    $0x4,%esp
80105e0f:	6a 05                	push   $0x5
80105e11:	51                   	push   %ecx
80105e12:	50                   	push   %eax
80105e13:	e8 af 0e 00 00       	call   80106cc7 <strncpy>
80105e18:	83 c4 10             	add    $0x10,%esp
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
80105e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1e:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105e21:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e24:	89 d0                	mov    %edx,%eax
80105e26:	01 c0                	add    %eax,%eax
80105e28:	01 d0                	add    %edx,%eax
80105e2a:	c1 e0 05             	shl    $0x5,%eax
80105e2d:	89 c2                	mov    %eax,%edx
80105e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e32:	01 d0                	add    %edx,%eax
80105e34:	83 c0 40             	add    $0x40,%eax
80105e37:	83 ec 04             	sub    $0x4,%esp
80105e3a:	6a 11                	push   $0x11
80105e3c:	51                   	push   %ecx
80105e3d:	50                   	push   %eax
80105e3e:	e8 84 0e 00 00       	call   80106cc7 <strncpy>
80105e43:	83 c4 10             	add    $0x10,%esp
      i++;
80105e46:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
int
getproc_helper(int m, struct uproc* table)
{
  struct proc* p;
  int i = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
80105e4a:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80105e51:	81 7d f4 d4 70 11 80 	cmpl   $0x801170d4,-0xc(%ebp)
80105e58:	73 0c                	jae    80105e66 <getproc_helper+0x1da>
80105e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5d:	3b 45 08             	cmp    0x8(%ebp),%eax
80105e60:	0f 8c 3f fe ff ff    	jl     80105ca5 <getproc_helper+0x19>
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
      i++;
    }
  }
  return i;  
80105e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e69:	c9                   	leave  
80105e6a:	c3                   	ret    

80105e6b <free_length>:

// Counts the number of procs in the free list when ctrl-f is pressed
void
free_length(void)
{
80105e6b:	55                   	push   %ebp
80105e6c:	89 e5                	mov    %esp,%ebp
80105e6e:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105e71:	83 ec 0c             	sub    $0xc,%esp
80105e74:	68 a0 49 11 80       	push   $0x801149a0
80105e79:	e8 3b 0a 00 00       	call   801068b9 <acquire>
80105e7e:	83 c4 10             	add    $0x10,%esp
  struct proc* f = ptable.pLists.free;
80105e81:	a1 d4 70 11 80       	mov    0x801170d4,%eax
80105e86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
80105e89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (!f) {
80105e90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e94:	75 35                	jne    80105ecb <free_length+0x60>
    cprintf("Free List Size: %d\n", count);
80105e96:	83 ec 08             	sub    $0x8,%esp
80105e99:	ff 75 f0             	pushl  -0x10(%ebp)
80105e9c:	68 9b a5 10 80       	push   $0x8010a59b
80105ea1:	e8 20 a5 ff ff       	call   801003c6 <cprintf>
80105ea6:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105ea9:	83 ec 0c             	sub    $0xc,%esp
80105eac:	68 a0 49 11 80       	push   $0x801149a0
80105eb1:	e8 6a 0a 00 00       	call   80106920 <release>
80105eb6:	83 c4 10             	add    $0x10,%esp
  }
  while (f)
80105eb9:	eb 10                	jmp    80105ecb <free_length+0x60>
  {
    ++count;
80105ebb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    f = f->next;
80105ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec2:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
  if (!f) {
    cprintf("Free List Size: %d\n", count);
    release(&ptable.lock);
  }
  while (f)
80105ecb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ecf:	75 ea                	jne    80105ebb <free_length+0x50>
  {
    ++count;
    f = f->next;
  }
  cprintf("Free List Size: %d\n", count);
80105ed1:	83 ec 08             	sub    $0x8,%esp
80105ed4:	ff 75 f0             	pushl  -0x10(%ebp)
80105ed7:	68 9b a5 10 80       	push   $0x8010a59b
80105edc:	e8 e5 a4 ff ff       	call   801003c6 <cprintf>
80105ee1:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105ee4:	83 ec 0c             	sub    $0xc,%esp
80105ee7:	68 a0 49 11 80       	push   $0x801149a0
80105eec:	e8 2f 0a 00 00       	call   80106920 <release>
80105ef1:	83 c4 10             	add    $0x10,%esp
}
80105ef4:	90                   	nop
80105ef5:	c9                   	leave  
80105ef6:	c3                   	ret    

80105ef7 <display_ready>:

// Displays the PIDs of all processes in the ready list
void
display_ready(void)
{
80105ef7:	55                   	push   %ebp
80105ef8:	89 e5                	mov    %esp,%ebp
80105efa:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105efd:	83 ec 0c             	sub    $0xc,%esp
80105f00:	68 a0 49 11 80       	push   $0x801149a0
80105f05:	e8 af 09 00 00       	call   801068b9 <acquire>
80105f0a:	83 c4 10             	add    $0x10,%esp
  cprintf("Ready List Processes:\n");
80105f0d:	83 ec 0c             	sub    $0xc,%esp
80105f10:	68 af a5 10 80       	push   $0x8010a5af
80105f15:	e8 ac a4 ff ff       	call   801003c6 <cprintf>
80105f1a:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX+1; i++) {
80105f1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105f24:	e9 a4 00 00 00       	jmp    80105fcd <display_ready+0xd6>
    cprintf("Queue %d: ", i);
80105f29:	83 ec 08             	sub    $0x8,%esp
80105f2c:	ff 75 f4             	pushl  -0xc(%ebp)
80105f2f:	68 c6 a5 10 80       	push   $0x8010a5c6
80105f34:	e8 8d a4 ff ff       	call   801003c6 <cprintf>
80105f39:	83 c4 10             	add    $0x10,%esp
    struct proc* r = ptable.pLists.ready[i];
80105f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3f:	05 cc 09 00 00       	add    $0x9cc,%eax
80105f44:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
80105f4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!r) {
80105f4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f52:	75 6f                	jne    80105fc3 <display_ready+0xcc>
      cprintf("\n");
80105f54:	83 ec 0c             	sub    $0xc,%esp
80105f57:	68 99 a5 10 80       	push   $0x8010a599
80105f5c:	e8 65 a4 ff ff       	call   801003c6 <cprintf>
80105f61:	83 c4 10             	add    $0x10,%esp
      continue;
80105f64:	eb 63                	jmp    80105fc9 <display_ready+0xd2>
    }
    while (r) {
      if (!r->next)
80105f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f69:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105f6f:	85 c0                	test   %eax,%eax
80105f71:	75 23                	jne    80105f96 <display_ready+0x9f>
        cprintf("(%d, %d)\n", r->pid, r->budget);
80105f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f76:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f7f:	8b 40 10             	mov    0x10(%eax),%eax
80105f82:	83 ec 04             	sub    $0x4,%esp
80105f85:	52                   	push   %edx
80105f86:	50                   	push   %eax
80105f87:	68 d1 a5 10 80       	push   $0x8010a5d1
80105f8c:	e8 35 a4 ff ff       	call   801003c6 <cprintf>
80105f91:	83 c4 10             	add    $0x10,%esp
80105f94:	eb 21                	jmp    80105fb7 <display_ready+0xc0>
      else
        cprintf("(%d, %d) -> ", r->pid, r->budget);
80105f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f99:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa2:	8b 40 10             	mov    0x10(%eax),%eax
80105fa5:	83 ec 04             	sub    $0x4,%esp
80105fa8:	52                   	push   %edx
80105fa9:	50                   	push   %eax
80105faa:	68 db a5 10 80       	push   $0x8010a5db
80105faf:	e8 12 a4 ff ff       	call   801003c6 <cprintf>
80105fb4:	83 c4 10             	add    $0x10,%esp
      r = r->next;
80105fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fba:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct proc* r = ptable.pLists.ready[i];
    if (!r) {
      cprintf("\n");
      continue;
    }
    while (r) {
80105fc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fc7:	75 9d                	jne    80105f66 <display_ready+0x6f>
void
display_ready(void)
{
  acquire(&ptable.lock);
  cprintf("Ready List Processes:\n");
  for (int i = 0; i < MAX+1; i++) {
80105fc9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105fcd:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
80105fd1:	0f 8e 52 ff ff ff    	jle    80105f29 <display_ready+0x32>
      else
        cprintf("(%d, %d) -> ", r->pid, r->budget);
      r = r->next;
    }
  }
  release(&ptable.lock);
80105fd7:	83 ec 0c             	sub    $0xc,%esp
80105fda:	68 a0 49 11 80       	push   $0x801149a0
80105fdf:	e8 3c 09 00 00       	call   80106920 <release>
80105fe4:	83 c4 10             	add    $0x10,%esp
  return;
80105fe7:	90                   	nop
}
80105fe8:	c9                   	leave  
80105fe9:	c3                   	ret    

80105fea <display_sleep>:

// Displays the PIDs of all processes in the sleep list
void
display_sleep(void)
{
80105fea:	55                   	push   %ebp
80105feb:	89 e5                	mov    %esp,%ebp
80105fed:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105ff0:	83 ec 0c             	sub    $0xc,%esp
80105ff3:	68 a0 49 11 80       	push   $0x801149a0
80105ff8:	e8 bc 08 00 00       	call   801068b9 <acquire>
80105ffd:	83 c4 10             	add    $0x10,%esp
  struct proc* s = ptable.pLists.sleep;
80106000:	a1 f8 70 11 80       	mov    0x801170f8,%eax
80106005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!s) {
80106008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010600c:	75 22                	jne    80106030 <display_sleep+0x46>
    cprintf("No processes currently in sleep.\n");
8010600e:	83 ec 0c             	sub    $0xc,%esp
80106011:	68 e8 a5 10 80       	push   $0x8010a5e8
80106016:	e8 ab a3 ff ff       	call   801003c6 <cprintf>
8010601b:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
8010601e:	83 ec 0c             	sub    $0xc,%esp
80106021:	68 a0 49 11 80       	push   $0x801149a0
80106026:	e8 f5 08 00 00       	call   80106920 <release>
8010602b:	83 c4 10             	add    $0x10,%esp
    return;
8010602e:	eb 72                	jmp    801060a2 <display_sleep+0xb8>
  }
  cprintf("Sleep List Processes:\n");
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	68 0a a6 10 80       	push   $0x8010a60a
80106038:	e8 89 a3 ff ff       	call   801003c6 <cprintf>
8010603d:	83 c4 10             	add    $0x10,%esp
  while (s) {
80106040:	eb 49                	jmp    8010608b <display_sleep+0xa1>
    if (!s->next)
80106042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106045:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010604b:	85 c0                	test   %eax,%eax
8010604d:	75 19                	jne    80106068 <display_sleep+0x7e>
      cprintf("%d\n", s->pid);
8010604f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106052:	8b 40 10             	mov    0x10(%eax),%eax
80106055:	83 ec 08             	sub    $0x8,%esp
80106058:	50                   	push   %eax
80106059:	68 21 a6 10 80       	push   $0x8010a621
8010605e:	e8 63 a3 ff ff       	call   801003c6 <cprintf>
80106063:	83 c4 10             	add    $0x10,%esp
80106066:	eb 17                	jmp    8010607f <display_sleep+0x95>
    else
      cprintf("%d -> ", s->pid);
80106068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606b:	8b 40 10             	mov    0x10(%eax),%eax
8010606e:	83 ec 08             	sub    $0x8,%esp
80106071:	50                   	push   %eax
80106072:	68 25 a6 10 80       	push   $0x8010a625
80106077:	e8 4a a3 ff ff       	call   801003c6 <cprintf>
8010607c:	83 c4 10             	add    $0x10,%esp
    s = s->next;
8010607f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106082:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106088:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in sleep.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Sleep List Processes:\n");
  while (s) {
8010608b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010608f:	75 b1                	jne    80106042 <display_sleep+0x58>
      cprintf("%d\n", s->pid);
    else
      cprintf("%d -> ", s->pid);
    s = s->next;
  }
  release(&ptable.lock);
80106091:	83 ec 0c             	sub    $0xc,%esp
80106094:	68 a0 49 11 80       	push   $0x801149a0
80106099:	e8 82 08 00 00       	call   80106920 <release>
8010609e:	83 c4 10             	add    $0x10,%esp
  return;
801060a1:	90                   	nop
}
801060a2:	c9                   	leave  
801060a3:	c3                   	ret    

801060a4 <display_zombie>:

// Displays the PID/PPID of processes in the zombie list
void display_zombie(void)
{
801060a4:	55                   	push   %ebp
801060a5:	89 e5                	mov    %esp,%ebp
801060a7:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801060aa:	83 ec 0c             	sub    $0xc,%esp
801060ad:	68 a0 49 11 80       	push   $0x801149a0
801060b2:	e8 02 08 00 00       	call   801068b9 <acquire>
801060b7:	83 c4 10             	add    $0x10,%esp
  struct proc* z = ptable.pLists.zombie;
801060ba:	a1 fc 70 11 80       	mov    0x801170fc,%eax
801060bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!z) {
801060c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060c6:	75 25                	jne    801060ed <display_zombie+0x49>
    cprintf("No processes currently in zombie.\n");
801060c8:	83 ec 0c             	sub    $0xc,%esp
801060cb:	68 2c a6 10 80       	push   $0x8010a62c
801060d0:	e8 f1 a2 ff ff       	call   801003c6 <cprintf>
801060d5:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
801060d8:	83 ec 0c             	sub    $0xc,%esp
801060db:	68 a0 49 11 80       	push   $0x801149a0
801060e0:	e8 3b 08 00 00       	call   80106920 <release>
801060e5:	83 c4 10             	add    $0x10,%esp
    return;
801060e8:	e9 f3 00 00 00       	jmp    801061e0 <display_zombie+0x13c>
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
801060ed:	83 ec 0c             	sub    $0xc,%esp
801060f0:	68 50 a6 10 80       	push   $0x8010a650
801060f5:	e8 cc a2 ff ff       	call   801003c6 <cprintf>
801060fa:	83 c4 10             	add    $0x10,%esp
  while (z) {
801060fd:	e9 c3 00 00 00       	jmp    801061c5 <display_zombie+0x121>
    if (!z->next) {
80106102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106105:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010610b:	85 c0                	test   %eax,%eax
8010610d:	75 56                	jne    80106165 <display_zombie+0xc1>
      cprintf("(%d", z->pid);
8010610f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106112:	8b 40 10             	mov    0x10(%eax),%eax
80106115:	83 ec 08             	sub    $0x8,%esp
80106118:	50                   	push   %eax
80106119:	68 6f a6 10 80       	push   $0x8010a66f
8010611e:	e8 a3 a2 ff ff       	call   801003c6 <cprintf>
80106123:	83 c4 10             	add    $0x10,%esp
      if (z->parent)
80106126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106129:	8b 40 14             	mov    0x14(%eax),%eax
8010612c:	85 c0                	test   %eax,%eax
8010612e:	74 1c                	je     8010614c <display_zombie+0xa8>
        cprintf(", %d)\n", z->parent->pid);
80106130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106133:	8b 40 14             	mov    0x14(%eax),%eax
80106136:	8b 40 10             	mov    0x10(%eax),%eax
80106139:	83 ec 08             	sub    $0x8,%esp
8010613c:	50                   	push   %eax
8010613d:	68 73 a6 10 80       	push   $0x8010a673
80106142:	e8 7f a2 ff ff       	call   801003c6 <cprintf>
80106147:	83 c4 10             	add    $0x10,%esp
8010614a:	eb 6d                	jmp    801061b9 <display_zombie+0x115>
      else
        cprintf(", %d)\n", z->pid);
8010614c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010614f:	8b 40 10             	mov    0x10(%eax),%eax
80106152:	83 ec 08             	sub    $0x8,%esp
80106155:	50                   	push   %eax
80106156:	68 73 a6 10 80       	push   $0x8010a673
8010615b:	e8 66 a2 ff ff       	call   801003c6 <cprintf>
80106160:	83 c4 10             	add    $0x10,%esp
80106163:	eb 54                	jmp    801061b9 <display_zombie+0x115>
    }
    else {
      cprintf("(%d", z->pid);
80106165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106168:	8b 40 10             	mov    0x10(%eax),%eax
8010616b:	83 ec 08             	sub    $0x8,%esp
8010616e:	50                   	push   %eax
8010616f:	68 6f a6 10 80       	push   $0x8010a66f
80106174:	e8 4d a2 ff ff       	call   801003c6 <cprintf>
80106179:	83 c4 10             	add    $0x10,%esp
      if (z->parent)
8010617c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617f:	8b 40 14             	mov    0x14(%eax),%eax
80106182:	85 c0                	test   %eax,%eax
80106184:	74 1c                	je     801061a2 <display_zombie+0xfe>
        cprintf(", %d) -> ", z->parent->pid);
80106186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106189:	8b 40 14             	mov    0x14(%eax),%eax
8010618c:	8b 40 10             	mov    0x10(%eax),%eax
8010618f:	83 ec 08             	sub    $0x8,%esp
80106192:	50                   	push   %eax
80106193:	68 7a a6 10 80       	push   $0x8010a67a
80106198:	e8 29 a2 ff ff       	call   801003c6 <cprintf>
8010619d:	83 c4 10             	add    $0x10,%esp
801061a0:	eb 17                	jmp    801061b9 <display_zombie+0x115>
      else
        cprintf(", %d) -> ", z->pid);
801061a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a5:	8b 40 10             	mov    0x10(%eax),%eax
801061a8:	83 ec 08             	sub    $0x8,%esp
801061ab:	50                   	push   %eax
801061ac:	68 7a a6 10 80       	push   $0x8010a67a
801061b1:	e8 10 a2 ff ff       	call   801003c6 <cprintf>
801061b6:	83 c4 10             	add    $0x10,%esp
    }
    z = z->next;
801061b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061bc:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801061c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in zombie.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
  while (z) {
801061c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061c9:	0f 85 33 ff ff ff    	jne    80106102 <display_zombie+0x5e>
      else
        cprintf(", %d) -> ", z->pid);
    }
    z = z->next;
  }
  release(&ptable.lock);
801061cf:	83 ec 0c             	sub    $0xc,%esp
801061d2:	68 a0 49 11 80       	push   $0x801149a0
801061d7:	e8 44 07 00 00       	call   80106920 <release>
801061dc:	83 c4 10             	add    $0x10,%esp
  return;
801061df:	90                   	nop
}
801061e0:	c9                   	leave  
801061e1:	c3                   	ret    

801061e2 <assert_state>:

// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
801061e2:	55                   	push   %ebp
801061e3:	89 e5                	mov    %esp,%ebp
801061e5:	83 ec 08             	sub    $0x8,%esp
  if (p->state == state)
801061e8:	8b 45 08             	mov    0x8(%ebp),%eax
801061eb:	8b 40 0c             	mov    0xc(%eax),%eax
801061ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
801061f1:	74 0d                	je     80106200 <assert_state+0x1e>
    return;
  panic("ERROR: States do not match.");
801061f3:	83 ec 0c             	sub    $0xc,%esp
801061f6:	68 84 a6 10 80       	push   $0x8010a684
801061fb:	e8 66 a3 ff ff       	call   80100566 <panic>
// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
  if (p->state == state)
    return;
80106200:	90                   	nop
  panic("ERROR: States do not match.");
}
80106201:	c9                   	leave  
80106202:	c3                   	ret    

80106203 <remove_from_list>:

// Implementation of remove_from_list
static int
remove_from_list(struct proc** sList, struct proc* p)
{
80106203:	55                   	push   %ebp
80106204:	89 e5                	mov    %esp,%ebp
80106206:	83 ec 10             	sub    $0x10,%esp
  if (!p)
80106209:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010620d:	75 0a                	jne    80106219 <remove_from_list+0x16>
    return -1;
8010620f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106214:	e9 94 00 00 00       	jmp    801062ad <remove_from_list+0xaa>
  if (!sList)
80106219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010621d:	75 0a                	jne    80106229 <remove_from_list+0x26>
    return -1;
8010621f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106224:	e9 84 00 00 00       	jmp    801062ad <remove_from_list+0xaa>
  struct proc* curr = *sList;
80106229:	8b 45 08             	mov    0x8(%ebp),%eax
8010622c:	8b 00                	mov    (%eax),%eax
8010622e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc* prev;
  if (p == curr) {
80106231:	8b 45 0c             	mov    0xc(%ebp),%eax
80106234:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80106237:	75 62                	jne    8010629b <remove_from_list+0x98>
    *sList = p->next;
80106239:	8b 45 0c             	mov    0xc(%ebp),%eax
8010623c:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80106242:	8b 45 08             	mov    0x8(%ebp),%eax
80106245:	89 10                	mov    %edx,(%eax)
    p->next = 0;
80106247:	8b 45 0c             	mov    0xc(%ebp),%eax
8010624a:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80106251:	00 00 00 
    return 1;
80106254:	b8 01 00 00 00       	mov    $0x1,%eax
80106259:	eb 52                	jmp    801062ad <remove_from_list+0xaa>
  }
  while (curr->next) {
    prev = curr;
8010625b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010625e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    curr = curr->next;
80106261:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106264:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010626a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (p == curr) {
8010626d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106270:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80106273:	75 26                	jne    8010629b <remove_from_list+0x98>
      prev->next = p->next;
80106275:	8b 45 0c             	mov    0xc(%ebp),%eax
80106278:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010627e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106281:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
      p->next = 0;
80106287:	8b 45 0c             	mov    0xc(%ebp),%eax
8010628a:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80106291:	00 00 00 
      return 1;
80106294:	b8 01 00 00 00       	mov    $0x1,%eax
80106299:	eb 12                	jmp    801062ad <remove_from_list+0xaa>
  if (p == curr) {
    *sList = p->next;
    p->next = 0;
    return 1;
  }
  while (curr->next) {
8010629b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010629e:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801062a4:	85 c0                	test   %eax,%eax
801062a6:	75 b3                	jne    8010625b <remove_from_list+0x58>
      prev->next = p->next;
      p->next = 0;
      return 1;
    }
  }
  return -1;
801062a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062ad:	c9                   	leave  
801062ae:	c3                   	ret    

801062af <add_to_list>:

// Implementation of add_to_list
static int
add_to_list(struct proc** sList, enum procstate state, struct proc* p)
{
801062af:	55                   	push   %ebp
801062b0:	89 e5                	mov    %esp,%ebp
801062b2:	83 ec 08             	sub    $0x8,%esp
  if (!p)
801062b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801062b9:	75 07                	jne    801062c2 <add_to_list+0x13>
    return -1;
801062bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c0:	eb 2c                	jmp    801062ee <add_to_list+0x3f>
  assert_state(p, state);
801062c2:	83 ec 08             	sub    $0x8,%esp
801062c5:	ff 75 0c             	pushl  0xc(%ebp)
801062c8:	ff 75 10             	pushl  0x10(%ebp)
801062cb:	e8 12 ff ff ff       	call   801061e2 <assert_state>
801062d0:	83 c4 10             	add    $0x10,%esp
  p->next = *sList;
801062d3:	8b 45 08             	mov    0x8(%ebp),%eax
801062d6:	8b 10                	mov    (%eax),%edx
801062d8:	8b 45 10             	mov    0x10(%ebp),%eax
801062db:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  *sList = p;
801062e1:	8b 45 08             	mov    0x8(%ebp),%eax
801062e4:	8b 55 10             	mov    0x10(%ebp),%edx
801062e7:	89 10                	mov    %edx,(%eax)
  return 0;
801062e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062ee:	c9                   	leave  
801062ef:	c3                   	ret    

801062f0 <add_to_ready>:

// Implementation of add_to_ready
static int
add_to_ready(struct proc* p, enum procstate state)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	83 ec 18             	sub    $0x18,%esp
  if (!p)
801062f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801062fa:	75 0a                	jne    80106306 <add_to_ready+0x16>
    return -1;
801062fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106301:	e9 b9 00 00 00       	jmp    801063bf <add_to_ready+0xcf>
  assert_state(p, state);
80106306:	83 ec 08             	sub    $0x8,%esp
80106309:	ff 75 0c             	pushl  0xc(%ebp)
8010630c:	ff 75 08             	pushl  0x8(%ebp)
8010630f:	e8 ce fe ff ff       	call   801061e2 <assert_state>
80106314:	83 c4 10             	add    $0x10,%esp
  if (!ptable.pLists.ready[p->priority]) {
80106317:	8b 45 08             	mov    0x8(%ebp),%eax
8010631a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106320:	05 cc 09 00 00       	add    $0x9cc,%eax
80106325:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
8010632c:	85 c0                	test   %eax,%eax
8010632e:	75 3e                	jne    8010636e <add_to_ready+0x7e>
    p->next = ptable.pLists.ready[p->priority];
80106330:	8b 45 08             	mov    0x8(%ebp),%eax
80106333:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106339:	05 cc 09 00 00       	add    $0x9cc,%eax
8010633e:	8b 14 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%edx
80106345:	8b 45 08             	mov    0x8(%ebp),%eax
80106348:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    ptable.pLists.ready[p->priority] = p;
8010634e:	8b 45 08             	mov    0x8(%ebp),%eax
80106351:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106357:	8d 90 cc 09 00 00    	lea    0x9cc(%eax),%edx
8010635d:	8b 45 08             	mov    0x8(%ebp),%eax
80106360:	89 04 95 ac 49 11 80 	mov    %eax,-0x7feeb654(,%edx,4)
    return 1;
80106367:	b8 01 00 00 00       	mov    $0x1,%eax
8010636c:	eb 51                	jmp    801063bf <add_to_ready+0xcf>
  }
  struct proc* t = ptable.pLists.ready[p->priority];
8010636e:	8b 45 08             	mov    0x8(%ebp),%eax
80106371:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106377:	05 cc 09 00 00       	add    $0x9cc,%eax
8010637c:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
80106383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (t->next)
80106386:	eb 0c                	jmp    80106394 <add_to_ready+0xa4>
    t = t->next;
80106388:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010638b:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106391:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p->next = ptable.pLists.ready[p->priority];
    ptable.pLists.ready[p->priority] = p;
    return 1;
  }
  struct proc* t = ptable.pLists.ready[p->priority];
  while (t->next)
80106394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106397:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010639d:	85 c0                	test   %eax,%eax
8010639f:	75 e7                	jne    80106388 <add_to_ready+0x98>
    t = t->next;
  t->next = p;
801063a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a4:	8b 55 08             	mov    0x8(%ebp),%edx
801063a7:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  p->next = 0;
801063ad:	8b 45 08             	mov    0x8(%ebp),%eax
801063b0:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
801063b7:	00 00 00 
  return 0;
801063ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063bf:	c9                   	leave  
801063c0:	c3                   	ret    

801063c1 <exit_helper>:

// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
801063c1:	55                   	push   %ebp
801063c2:	89 e5                	mov    %esp,%ebp
801063c4:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = *sList;
801063c7:	8b 45 08             	mov    0x8(%ebp),%eax
801063ca:	8b 00                	mov    (%eax),%eax
801063cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
801063cf:	eb 28                	jmp    801063f9 <exit_helper+0x38>
    if (p->parent == proc)
801063d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801063d4:	8b 50 14             	mov    0x14(%eax),%edx
801063d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063dd:	39 c2                	cmp    %eax,%edx
801063df:	75 0c                	jne    801063ed <exit_helper+0x2c>
      p->parent = initproc;
801063e1:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
801063e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801063ea:	89 50 14             	mov    %edx,0x14(%eax)
    p = p->next;
801063ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
801063f0:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801063f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
  struct proc* p = *sList;
  while (p) {
801063f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801063fd:	75 d2                	jne    801063d1 <exit_helper+0x10>
    if (p->parent == proc)
      p->parent = initproc;
    p = p->next;
  }
}
801063ff:	90                   	nop
80106400:	c9                   	leave  
80106401:	c3                   	ret    

80106402 <wait_helper>:

// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
80106402:	55                   	push   %ebp
80106403:	89 e5                	mov    %esp,%ebp
80106405:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = *sList;
80106408:	8b 45 08             	mov    0x8(%ebp),%eax
8010640b:	8b 00                	mov    (%eax),%eax
8010640d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
80106410:	eb 25                	jmp    80106437 <wait_helper+0x35>
    if (p->parent == proc)
80106412:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106415:	8b 50 14             	mov    0x14(%eax),%edx
80106418:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010641e:	39 c2                	cmp    %eax,%edx
80106420:	75 09                	jne    8010642b <wait_helper+0x29>
      *hk = 1;
80106422:	8b 45 0c             	mov    0xc(%ebp),%eax
80106425:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    p = p->next;
8010642b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010642e:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106434:	89 45 fc             	mov    %eax,-0x4(%ebp)
// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
  struct proc* p = *sList;
  while (p) {
80106437:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010643b:	75 d5                	jne    80106412 <wait_helper+0x10>
    if (p->parent == proc)
      *hk = 1;
    p = p->next;
  }
}
8010643d:	90                   	nop
8010643e:	c9                   	leave  
8010643f:	c3                   	ret    

80106440 <set_priority>:

#ifdef CS333_P3P4
// Implementation of helper for set priority system call
int
set_priority(int pid, int priority)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	83 ec 18             	sub    $0x18,%esp
  if (pid < 0)
80106446:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010644a:	79 0a                	jns    80106456 <set_priority+0x16>
    return -1;
8010644c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106451:	e9 fd 00 00 00       	jmp    80106553 <set_priority+0x113>
  if (priority < 0 || priority > MAX)
80106456:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010645a:	78 06                	js     80106462 <set_priority+0x22>
8010645c:	83 7d 0c 05          	cmpl   $0x5,0xc(%ebp)
80106460:	7e 0a                	jle    8010646c <set_priority+0x2c>
    return -2;
80106462:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80106467:	e9 e7 00 00 00       	jmp    80106553 <set_priority+0x113>

  int hold = holding(&ptable.lock);
8010646c:	83 ec 0c             	sub    $0xc,%esp
8010646f:	68 a0 49 11 80       	push   $0x801149a0
80106474:	e8 73 05 00 00       	call   801069ec <holding>
80106479:	83 c4 10             	add    $0x10,%esp
8010647c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!hold) acquire(&ptable.lock);
8010647f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106483:	75 10                	jne    80106495 <set_priority+0x55>
80106485:	83 ec 0c             	sub    $0xc,%esp
80106488:	68 a0 49 11 80       	push   $0x801149a0
8010648d:	e8 27 04 00 00       	call   801068b9 <acquire>
80106492:	83 c4 10             	add    $0x10,%esp
  if (search_and_set(&ptable.pLists.running, pid, priority) == 0) {
80106495:	83 ec 04             	sub    $0x4,%esp
80106498:	ff 75 0c             	pushl  0xc(%ebp)
8010649b:	ff 75 08             	pushl  0x8(%ebp)
8010649e:	68 f4 70 11 80       	push   $0x801170f4
801064a3:	e8 ad 00 00 00       	call   80106555 <search_and_set>
801064a8:	83 c4 10             	add    $0x10,%esp
801064ab:	85 c0                	test   %eax,%eax
801064ad:	75 20                	jne    801064cf <set_priority+0x8f>
    if (!hold) release(&ptable.lock);
801064af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064b3:	75 10                	jne    801064c5 <set_priority+0x85>
801064b5:	83 ec 0c             	sub    $0xc,%esp
801064b8:	68 a0 49 11 80       	push   $0x801149a0
801064bd:	e8 5e 04 00 00       	call   80106920 <release>
801064c2:	83 c4 10             	add    $0x10,%esp
    return 0;
801064c5:	b8 00 00 00 00       	mov    $0x0,%eax
801064ca:	e9 84 00 00 00       	jmp    80106553 <set_priority+0x113>
  }
  if (search_and_set(&ptable.pLists.sleep, pid, priority) == 0) {
801064cf:	83 ec 04             	sub    $0x4,%esp
801064d2:	ff 75 0c             	pushl  0xc(%ebp)
801064d5:	ff 75 08             	pushl  0x8(%ebp)
801064d8:	68 f8 70 11 80       	push   $0x801170f8
801064dd:	e8 73 00 00 00       	call   80106555 <search_and_set>
801064e2:	83 c4 10             	add    $0x10,%esp
801064e5:	85 c0                	test   %eax,%eax
801064e7:	75 1d                	jne    80106506 <set_priority+0xc6>
    if (!hold) release(&ptable.lock);
801064e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064ed:	75 10                	jne    801064ff <set_priority+0xbf>
801064ef:	83 ec 0c             	sub    $0xc,%esp
801064f2:	68 a0 49 11 80       	push   $0x801149a0
801064f7:	e8 24 04 00 00       	call   80106920 <release>
801064fc:	83 c4 10             	add    $0x10,%esp
    return 0;
801064ff:	b8 00 00 00 00       	mov    $0x0,%eax
80106504:	eb 4d                	jmp    80106553 <set_priority+0x113>
  }
  if (search_and_set_ready(pid, priority) == 0) {
80106506:	83 ec 08             	sub    $0x8,%esp
80106509:	ff 75 0c             	pushl  0xc(%ebp)
8010650c:	ff 75 08             	pushl  0x8(%ebp)
8010650f:	e8 ae 00 00 00       	call   801065c2 <search_and_set_ready>
80106514:	83 c4 10             	add    $0x10,%esp
80106517:	85 c0                	test   %eax,%eax
80106519:	75 1d                	jne    80106538 <set_priority+0xf8>
    if (!hold) release(&ptable.lock);
8010651b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010651f:	75 10                	jne    80106531 <set_priority+0xf1>
80106521:	83 ec 0c             	sub    $0xc,%esp
80106524:	68 a0 49 11 80       	push   $0x801149a0
80106529:	e8 f2 03 00 00       	call   80106920 <release>
8010652e:	83 c4 10             	add    $0x10,%esp
    return 0;
80106531:	b8 00 00 00 00       	mov    $0x0,%eax
80106536:	eb 1b                	jmp    80106553 <set_priority+0x113>
  }
  if (!hold) release(&ptable.lock);
80106538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010653c:	75 10                	jne    8010654e <set_priority+0x10e>
8010653e:	83 ec 0c             	sub    $0xc,%esp
80106541:	68 a0 49 11 80       	push   $0x801149a0
80106546:	e8 d5 03 00 00       	call   80106920 <release>
8010654b:	83 c4 10             	add    $0x10,%esp
  return -1; // Failed to find process with PID matching arg pid
8010654e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106553:	c9                   	leave  
80106554:	c3                   	ret    

80106555 <search_and_set>:
// Searches a list for a proc with PID pid and sets its priority
// to the value passed in via prio argument
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int 
search_and_set(struct proc** sList, int pid, int prio)
{
80106555:	55                   	push   %ebp
80106556:	89 e5                	mov    %esp,%ebp
80106558:	83 ec 10             	sub    $0x10,%esp
  if (!sList)
8010655b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010655f:	75 07                	jne    80106568 <search_and_set+0x13>
    return -1; // Null list
80106561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106566:	eb 58                	jmp    801065c0 <search_and_set+0x6b>
  struct proc* p = *sList;
80106568:	8b 45 08             	mov    0x8(%ebp),%eax
8010656b:	8b 00                	mov    (%eax),%eax
8010656d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
80106570:	eb 43                	jmp    801065b5 <search_and_set+0x60>
    if (p->pid == pid) {
80106572:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106575:	8b 50 10             	mov    0x10(%eax),%edx
80106578:	8b 45 0c             	mov    0xc(%ebp),%eax
8010657b:	39 c2                	cmp    %eax,%edx
8010657d:	75 2a                	jne    801065a9 <search_and_set+0x54>
      if (p->priority == prio)
8010657f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106582:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80106588:	8b 45 10             	mov    0x10(%ebp),%eax
8010658b:	39 c2                	cmp    %eax,%edx
8010658d:	75 07                	jne    80106596 <search_and_set+0x41>
        return 1; // No change necessary 
8010658f:	b8 01 00 00 00       	mov    $0x1,%eax
80106594:	eb 2a                	jmp    801065c0 <search_and_set+0x6b>
      else {
        p->priority = prio;
80106596:	8b 55 10             	mov    0x10(%ebp),%edx
80106599:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010659c:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        return 0; // Success!
801065a2:	b8 00 00 00 00       	mov    $0x0,%eax
801065a7:	eb 17                	jmp    801065c0 <search_and_set+0x6b>
      }
    }
    p = p->next;
801065a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065ac:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801065b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
search_and_set(struct proc** sList, int pid, int prio)
{
  if (!sList)
    return -1; // Null list
  struct proc* p = *sList;
  while (p) {
801065b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801065b9:	75 b7                	jne    80106572 <search_and_set+0x1d>
        return 0; // Success!
      }
    }
    p = p->next;
  }
  return -2; // Not found
801065bb:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
801065c0:	c9                   	leave  
801065c1:	c3                   	ret    

801065c2 <search_and_set_ready>:
// Specifically handles the ready list since the process also needs
// to be moved to a different ready queue.
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int
search_and_set_ready(int pid, int prio)
{
801065c2:	55                   	push   %ebp
801065c3:	89 e5                	mov    %esp,%ebp
801065c5:	83 ec 18             	sub    $0x18,%esp
  for (int i = 0; i < MAX+1; i++) {
801065c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801065cf:	e9 c1 00 00 00       	jmp    80106695 <search_and_set_ready+0xd3>
    if (!ptable.pLists.ready[i])
801065d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d7:	05 cc 09 00 00       	add    $0x9cc,%eax
801065dc:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
801065e3:	85 c0                	test   %eax,%eax
801065e5:	0f 84 a5 00 00 00    	je     80106690 <search_and_set_ready+0xce>
      continue;
    struct proc* p = ptable.pLists.ready[i];
801065eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ee:	05 cc 09 00 00       	add    $0x9cc,%eax
801065f3:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
801065fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (p) {
801065fd:	e9 82 00 00 00       	jmp    80106684 <search_and_set_ready+0xc2>
      if (p->pid == pid) {
80106602:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106605:	8b 50 10             	mov    0x10(%eax),%edx
80106608:	8b 45 08             	mov    0x8(%ebp),%eax
8010660b:	39 c2                	cmp    %eax,%edx
8010660d:	75 69                	jne    80106678 <search_and_set_ready+0xb6>
        if (p->priority == prio)
8010660f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106612:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80106618:	8b 45 0c             	mov    0xc(%ebp),%eax
8010661b:	39 c2                	cmp    %eax,%edx
8010661d:	75 07                	jne    80106626 <search_and_set_ready+0x64>
          return 1; // No changes need to be made since prio already matches
8010661f:	b8 01 00 00 00       	mov    $0x1,%eax
80106624:	eb 7e                	jmp    801066a4 <search_and_set_ready+0xe2>
        else {
          p->priority = prio;
80106626:	8b 55 0c             	mov    0xc(%ebp),%edx
80106629:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010662c:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
          remove_from_list(&ptable.pLists.ready[i], p);
80106632:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106635:	05 cc 09 00 00       	add    $0x9cc,%eax
8010663a:	c1 e0 02             	shl    $0x2,%eax
8010663d:	05 a0 49 11 80       	add    $0x801149a0,%eax
80106642:	83 c0 0c             	add    $0xc,%eax
80106645:	ff 75 f0             	pushl  -0x10(%ebp)
80106648:	50                   	push   %eax
80106649:	e8 b5 fb ff ff       	call   80106203 <remove_from_list>
8010664e:	83 c4 08             	add    $0x8,%esp
          assert_state(p, RUNNABLE);
80106651:	83 ec 08             	sub    $0x8,%esp
80106654:	6a 03                	push   $0x3
80106656:	ff 75 f0             	pushl  -0x10(%ebp)
80106659:	e8 84 fb ff ff       	call   801061e2 <assert_state>
8010665e:	83 c4 10             	add    $0x10,%esp
          add_to_ready(p, RUNNABLE);
80106661:	83 ec 08             	sub    $0x8,%esp
80106664:	6a 03                	push   $0x3
80106666:	ff 75 f0             	pushl  -0x10(%ebp)
80106669:	e8 82 fc ff ff       	call   801062f0 <add_to_ready>
8010666e:	83 c4 10             	add    $0x10,%esp
          return 0;
80106671:	b8 00 00 00 00       	mov    $0x0,%eax
80106676:	eb 2c                	jmp    801066a4 <search_and_set_ready+0xe2>
        }
      }
      p = p->next;  
80106678:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010667b:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106681:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
  for (int i = 0; i < MAX+1; i++) {
    if (!ptable.pLists.ready[i])
      continue;
    struct proc* p = ptable.pLists.ready[i];
    while (p) {
80106684:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106688:	0f 85 74 ff ff ff    	jne    80106602 <search_and_set_ready+0x40>
8010668e:	eb 01                	jmp    80106691 <search_and_set_ready+0xcf>
static int
search_and_set_ready(int pid, int prio)
{
  for (int i = 0; i < MAX+1; i++) {
    if (!ptable.pLists.ready[i])
      continue;
80106690:	90                   	nop
// to be moved to a different ready queue.
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int
search_and_set_ready(int pid, int prio)
{
  for (int i = 0; i < MAX+1; i++) {
80106691:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106695:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
80106699:	0f 8e 35 ff ff ff    	jle    801065d4 <search_and_set_ready+0x12>
        }
      }
      p = p->next;  
    }
  }
  return -2;
8010669f:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
801066a4:	c9                   	leave  
801066a5:	c3                   	ret    

801066a6 <priority_promotion>:
#endif

#ifdef CS333_P3P4
static int 
priority_promotion()
{
801066a6:	55                   	push   %ebp
801066a7:	89 e5                	mov    %esp,%ebp
801066a9:	83 ec 18             	sub    $0x18,%esp
  int hold = holding(&ptable.lock);
801066ac:	83 ec 0c             	sub    $0xc,%esp
801066af:	68 a0 49 11 80       	push   $0x801149a0
801066b4:	e8 33 03 00 00       	call   801069ec <holding>
801066b9:	83 c4 10             	add    $0x10,%esp
801066bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (!hold) acquire(&ptable.lock);
801066bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801066c3:	75 10                	jne    801066d5 <priority_promotion+0x2f>
801066c5:	83 ec 0c             	sub    $0xc,%esp
801066c8:	68 a0 49 11 80       	push   $0x801149a0
801066cd:	e8 e7 01 00 00       	call   801068b9 <acquire>
801066d2:	83 c4 10             	add    $0x10,%esp
  if (MAX == 0)     // Only one list so simple round robin scheduler
    return -1;
  promote_list(&ptable.pLists.running);
801066d5:	83 ec 0c             	sub    $0xc,%esp
801066d8:	68 f4 70 11 80       	push   $0x801170f4
801066dd:	e8 25 01 00 00       	call   80106807 <promote_list>
801066e2:	83 c4 10             	add    $0x10,%esp
  promote_list(&ptable.pLists.sleep);
801066e5:	83 ec 0c             	sub    $0xc,%esp
801066e8:	68 f8 70 11 80       	push   $0x801170f8
801066ed:	e8 15 01 00 00       	call   80106807 <promote_list>
801066f2:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX; i++) {
801066f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801066fc:	e9 df 00 00 00       	jmp    801067e0 <priority_promotion+0x13a>
    if (!ptable.pLists.ready[i+1])
80106701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106704:	83 c0 01             	add    $0x1,%eax
80106707:	05 cc 09 00 00       	add    $0x9cc,%eax
8010670c:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
80106713:	85 c0                	test   %eax,%eax
80106715:	0f 84 c0 00 00 00    	je     801067db <priority_promotion+0x135>
      continue;
    promote_list(&ptable.pLists.ready[i+1]);
8010671b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010671e:	83 c0 01             	add    $0x1,%eax
80106721:	05 cc 09 00 00       	add    $0x9cc,%eax
80106726:	c1 e0 02             	shl    $0x2,%eax
80106729:	05 a0 49 11 80       	add    $0x801149a0,%eax
8010672e:	83 c0 0c             	add    $0xc,%eax
80106731:	83 ec 0c             	sub    $0xc,%esp
80106734:	50                   	push   %eax
80106735:	e8 cd 00 00 00       	call   80106807 <promote_list>
8010673a:	83 c4 10             	add    $0x10,%esp
    struct proc* p = ptable.pLists.ready[i];
8010673d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106740:	05 cc 09 00 00       	add    $0x9cc,%eax
80106745:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
8010674c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!p) {
8010674f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106753:	75 46                	jne    8010679b <priority_promotion+0xf5>
      ptable.pLists.ready[i] = ptable.pLists.ready[i+1];
80106755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106758:	83 c0 01             	add    $0x1,%eax
8010675b:	05 cc 09 00 00       	add    $0x9cc,%eax
80106760:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
80106767:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010676a:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80106770:	89 04 95 ac 49 11 80 	mov    %eax,-0x7feeb654(,%edx,4)
      ptable.pLists.ready[i+1] = 0;
80106777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010677a:	83 c0 01             	add    $0x1,%eax
8010677d:	05 cc 09 00 00       	add    $0x9cc,%eax
80106782:	c7 04 85 ac 49 11 80 	movl   $0x0,-0x7feeb654(,%eax,4)
80106789:	00 00 00 00 
8010678d:	eb 4d                	jmp    801067dc <priority_promotion+0x136>
    } else {
      while (p->next)
        p = p->next;
8010678f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106792:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106798:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct proc* p = ptable.pLists.ready[i];
    if (!p) {
      ptable.pLists.ready[i] = ptable.pLists.ready[i+1];
      ptable.pLists.ready[i+1] = 0;
    } else {
      while (p->next)
8010679b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010679e:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801067a4:	85 c0                	test   %eax,%eax
801067a6:	75 e7                	jne    8010678f <priority_promotion+0xe9>
        p = p->next;
      p->next = ptable.pLists.ready[i+1];
801067a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ab:	83 c0 01             	add    $0x1,%eax
801067ae:	05 cc 09 00 00       	add    $0x9cc,%eax
801067b3:	8b 14 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%edx
801067ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067bd:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
      ptable.pLists.ready[i+1] = 0;
801067c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067c6:	83 c0 01             	add    $0x1,%eax
801067c9:	05 cc 09 00 00       	add    $0x9cc,%eax
801067ce:	c7 04 85 ac 49 11 80 	movl   $0x0,-0x7feeb654(,%eax,4)
801067d5:	00 00 00 00 
801067d9:	eb 01                	jmp    801067dc <priority_promotion+0x136>
    return -1;
  promote_list(&ptable.pLists.running);
  promote_list(&ptable.pLists.sleep);
  for (int i = 0; i < MAX; i++) {
    if (!ptable.pLists.ready[i+1])
      continue;
801067db:	90                   	nop
  if (!hold) acquire(&ptable.lock);
  if (MAX == 0)     // Only one list so simple round robin scheduler
    return -1;
  promote_list(&ptable.pLists.running);
  promote_list(&ptable.pLists.sleep);
  for (int i = 0; i < MAX; i++) {
801067dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801067e0:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801067e4:	0f 8e 17 ff ff ff    	jle    80106701 <priority_promotion+0x5b>
        p = p->next;
      p->next = ptable.pLists.ready[i+1];
      ptable.pLists.ready[i+1] = 0;
    }
  }
  if (!hold) release(&ptable.lock);
801067ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801067ee:	75 10                	jne    80106800 <priority_promotion+0x15a>
801067f0:	83 ec 0c             	sub    $0xc,%esp
801067f3:	68 a0 49 11 80       	push   $0x801149a0
801067f8:	e8 23 01 00 00       	call   80106920 <release>
801067fd:	83 c4 10             	add    $0x10,%esp
  return 1; 
80106800:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106805:	c9                   	leave  
80106806:	c3                   	ret    

80106807 <promote_list>:
#endif

#ifdef CS333_P3P4
static int 
promote_list(struct proc** list)
{
80106807:	55                   	push   %ebp
80106808:	89 e5                	mov    %esp,%ebp
8010680a:	83 ec 10             	sub    $0x10,%esp
  if (!list)
8010680d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106811:	75 07                	jne    8010681a <promote_list+0x13>
    return -1;
80106813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106818:	eb 43                	jmp    8010685d <promote_list+0x56>

  struct proc* p = *list;
8010681a:	8b 45 08             	mov    0x8(%ebp),%eax
8010681d:	8b 00                	mov    (%eax),%eax
8010681f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
80106822:	eb 2e                	jmp    80106852 <promote_list+0x4b>
    if (p->priority > 0)
80106824:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106827:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010682d:	85 c0                	test   %eax,%eax
8010682f:	74 15                	je     80106846 <promote_list+0x3f>
      p->priority = p->priority-1;
80106831:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106834:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010683a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010683d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106840:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    p = p->next;
80106846:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106849:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010684f:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  if (!list)
    return -1;

  struct proc* p = *list;
  while (p) {
80106852:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106856:	75 cc                	jne    80106824 <promote_list+0x1d>
    if (p->priority > 0)
      p->priority = p->priority-1;
    p = p->next;
  }
  return 0;
80106858:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010685d:	c9                   	leave  
8010685e:	c3                   	ret    

8010685f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010685f:	55                   	push   %ebp
80106860:	89 e5                	mov    %esp,%ebp
80106862:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106865:	9c                   	pushf  
80106866:	58                   	pop    %eax
80106867:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010686a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010686d:	c9                   	leave  
8010686e:	c3                   	ret    

8010686f <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010686f:	55                   	push   %ebp
80106870:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80106872:	fa                   	cli    
}
80106873:	90                   	nop
80106874:	5d                   	pop    %ebp
80106875:	c3                   	ret    

80106876 <sti>:

static inline void
sti(void)
{
80106876:	55                   	push   %ebp
80106877:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80106879:	fb                   	sti    
}
8010687a:	90                   	nop
8010687b:	5d                   	pop    %ebp
8010687c:	c3                   	ret    

8010687d <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010687d:	55                   	push   %ebp
8010687e:	89 e5                	mov    %esp,%ebp
80106880:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80106883:	8b 55 08             	mov    0x8(%ebp),%edx
80106886:	8b 45 0c             	mov    0xc(%ebp),%eax
80106889:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010688c:	f0 87 02             	lock xchg %eax,(%edx)
8010688f:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80106892:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106895:	c9                   	leave  
80106896:	c3                   	ret    

80106897 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106897:	55                   	push   %ebp
80106898:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010689a:	8b 45 08             	mov    0x8(%ebp),%eax
8010689d:	8b 55 0c             	mov    0xc(%ebp),%edx
801068a0:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801068a3:	8b 45 08             	mov    0x8(%ebp),%eax
801068a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801068ac:	8b 45 08             	mov    0x8(%ebp),%eax
801068af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801068b6:	90                   	nop
801068b7:	5d                   	pop    %ebp
801068b8:	c3                   	ret    

801068b9 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801068b9:	55                   	push   %ebp
801068ba:	89 e5                	mov    %esp,%ebp
801068bc:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801068bf:	e8 52 01 00 00       	call   80106a16 <pushcli>
  if(holding(lk))
801068c4:	8b 45 08             	mov    0x8(%ebp),%eax
801068c7:	83 ec 0c             	sub    $0xc,%esp
801068ca:	50                   	push   %eax
801068cb:	e8 1c 01 00 00       	call   801069ec <holding>
801068d0:	83 c4 10             	add    $0x10,%esp
801068d3:	85 c0                	test   %eax,%eax
801068d5:	74 0d                	je     801068e4 <acquire+0x2b>
    panic("acquire");
801068d7:	83 ec 0c             	sub    $0xc,%esp
801068da:	68 a0 a6 10 80       	push   $0x8010a6a0
801068df:	e8 82 9c ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801068e4:	90                   	nop
801068e5:	8b 45 08             	mov    0x8(%ebp),%eax
801068e8:	83 ec 08             	sub    $0x8,%esp
801068eb:	6a 01                	push   $0x1
801068ed:	50                   	push   %eax
801068ee:	e8 8a ff ff ff       	call   8010687d <xchg>
801068f3:	83 c4 10             	add    $0x10,%esp
801068f6:	85 c0                	test   %eax,%eax
801068f8:	75 eb                	jne    801068e5 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801068fa:	8b 45 08             	mov    0x8(%ebp),%eax
801068fd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106904:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80106907:	8b 45 08             	mov    0x8(%ebp),%eax
8010690a:	83 c0 0c             	add    $0xc,%eax
8010690d:	83 ec 08             	sub    $0x8,%esp
80106910:	50                   	push   %eax
80106911:	8d 45 08             	lea    0x8(%ebp),%eax
80106914:	50                   	push   %eax
80106915:	e8 58 00 00 00       	call   80106972 <getcallerpcs>
8010691a:	83 c4 10             	add    $0x10,%esp
}
8010691d:	90                   	nop
8010691e:	c9                   	leave  
8010691f:	c3                   	ret    

80106920 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80106926:	83 ec 0c             	sub    $0xc,%esp
80106929:	ff 75 08             	pushl  0x8(%ebp)
8010692c:	e8 bb 00 00 00       	call   801069ec <holding>
80106931:	83 c4 10             	add    $0x10,%esp
80106934:	85 c0                	test   %eax,%eax
80106936:	75 0d                	jne    80106945 <release+0x25>
    panic("release");
80106938:	83 ec 0c             	sub    $0xc,%esp
8010693b:	68 a8 a6 10 80       	push   $0x8010a6a8
80106940:	e8 21 9c ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80106945:	8b 45 08             	mov    0x8(%ebp),%eax
80106948:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010694f:	8b 45 08             	mov    0x8(%ebp),%eax
80106952:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80106959:	8b 45 08             	mov    0x8(%ebp),%eax
8010695c:	83 ec 08             	sub    $0x8,%esp
8010695f:	6a 00                	push   $0x0
80106961:	50                   	push   %eax
80106962:	e8 16 ff ff ff       	call   8010687d <xchg>
80106967:	83 c4 10             	add    $0x10,%esp

  popcli();
8010696a:	e8 ec 00 00 00       	call   80106a5b <popcli>
}
8010696f:	90                   	nop
80106970:	c9                   	leave  
80106971:	c3                   	ret    

80106972 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106972:	55                   	push   %ebp
80106973:	89 e5                	mov    %esp,%ebp
80106975:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80106978:	8b 45 08             	mov    0x8(%ebp),%eax
8010697b:	83 e8 08             	sub    $0x8,%eax
8010697e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80106981:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80106988:	eb 38                	jmp    801069c2 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010698a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010698e:	74 53                	je     801069e3 <getcallerpcs+0x71>
80106990:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80106997:	76 4a                	jbe    801069e3 <getcallerpcs+0x71>
80106999:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010699d:	74 44                	je     801069e3 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010699f:	8b 45 f8             	mov    -0x8(%ebp),%eax
801069a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801069a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801069ac:	01 c2                	add    %eax,%edx
801069ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069b1:	8b 40 04             	mov    0x4(%eax),%eax
801069b4:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801069b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069b9:	8b 00                	mov    (%eax),%eax
801069bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801069be:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801069c2:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801069c6:	7e c2                	jle    8010698a <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801069c8:	eb 19                	jmp    801069e3 <getcallerpcs+0x71>
    pcs[i] = 0;
801069ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
801069cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801069d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801069d7:	01 d0                	add    %edx,%eax
801069d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801069df:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801069e3:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801069e7:	7e e1                	jle    801069ca <getcallerpcs+0x58>
    pcs[i] = 0;
}
801069e9:	90                   	nop
801069ea:	c9                   	leave  
801069eb:	c3                   	ret    

801069ec <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801069ec:	55                   	push   %ebp
801069ed:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801069ef:	8b 45 08             	mov    0x8(%ebp),%eax
801069f2:	8b 00                	mov    (%eax),%eax
801069f4:	85 c0                	test   %eax,%eax
801069f6:	74 17                	je     80106a0f <holding+0x23>
801069f8:	8b 45 08             	mov    0x8(%ebp),%eax
801069fb:	8b 50 08             	mov    0x8(%eax),%edx
801069fe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a04:	39 c2                	cmp    %eax,%edx
80106a06:	75 07                	jne    80106a0f <holding+0x23>
80106a08:	b8 01 00 00 00       	mov    $0x1,%eax
80106a0d:	eb 05                	jmp    80106a14 <holding+0x28>
80106a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a14:	5d                   	pop    %ebp
80106a15:	c3                   	ret    

80106a16 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106a16:	55                   	push   %ebp
80106a17:	89 e5                	mov    %esp,%ebp
80106a19:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80106a1c:	e8 3e fe ff ff       	call   8010685f <readeflags>
80106a21:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80106a24:	e8 46 fe ff ff       	call   8010686f <cli>
  if(cpu->ncli++ == 0)
80106a29:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106a30:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80106a36:	8d 48 01             	lea    0x1(%eax),%ecx
80106a39:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106a3f:	85 c0                	test   %eax,%eax
80106a41:	75 15                	jne    80106a58 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80106a43:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a49:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a4c:	81 e2 00 02 00 00    	and    $0x200,%edx
80106a52:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80106a58:	90                   	nop
80106a59:	c9                   	leave  
80106a5a:	c3                   	ret    

80106a5b <popcli>:

void
popcli(void)
{
80106a5b:	55                   	push   %ebp
80106a5c:	89 e5                	mov    %esp,%ebp
80106a5e:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106a61:	e8 f9 fd ff ff       	call   8010685f <readeflags>
80106a66:	25 00 02 00 00       	and    $0x200,%eax
80106a6b:	85 c0                	test   %eax,%eax
80106a6d:	74 0d                	je     80106a7c <popcli+0x21>
    panic("popcli - interruptible");
80106a6f:	83 ec 0c             	sub    $0xc,%esp
80106a72:	68 b0 a6 10 80       	push   $0x8010a6b0
80106a77:	e8 ea 9a ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106a7c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a82:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106a88:	83 ea 01             	sub    $0x1,%edx
80106a8b:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106a91:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a97:	85 c0                	test   %eax,%eax
80106a99:	79 0d                	jns    80106aa8 <popcli+0x4d>
    panic("popcli");
80106a9b:	83 ec 0c             	sub    $0xc,%esp
80106a9e:	68 c7 a6 10 80       	push   $0x8010a6c7
80106aa3:	e8 be 9a ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106aa8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106aae:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106ab4:	85 c0                	test   %eax,%eax
80106ab6:	75 15                	jne    80106acd <popcli+0x72>
80106ab8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106abe:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106ac4:	85 c0                	test   %eax,%eax
80106ac6:	74 05                	je     80106acd <popcli+0x72>
    sti();
80106ac8:	e8 a9 fd ff ff       	call   80106876 <sti>
}
80106acd:	90                   	nop
80106ace:	c9                   	leave  
80106acf:	c3                   	ret    

80106ad0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106ad5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106ad8:	8b 55 10             	mov    0x10(%ebp),%edx
80106adb:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ade:	89 cb                	mov    %ecx,%ebx
80106ae0:	89 df                	mov    %ebx,%edi
80106ae2:	89 d1                	mov    %edx,%ecx
80106ae4:	fc                   	cld    
80106ae5:	f3 aa                	rep stos %al,%es:(%edi)
80106ae7:	89 ca                	mov    %ecx,%edx
80106ae9:	89 fb                	mov    %edi,%ebx
80106aeb:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106aee:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106af1:	90                   	nop
80106af2:	5b                   	pop    %ebx
80106af3:	5f                   	pop    %edi
80106af4:	5d                   	pop    %ebp
80106af5:	c3                   	ret    

80106af6 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106af6:	55                   	push   %ebp
80106af7:	89 e5                	mov    %esp,%ebp
80106af9:	57                   	push   %edi
80106afa:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106afb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106afe:	8b 55 10             	mov    0x10(%ebp),%edx
80106b01:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b04:	89 cb                	mov    %ecx,%ebx
80106b06:	89 df                	mov    %ebx,%edi
80106b08:	89 d1                	mov    %edx,%ecx
80106b0a:	fc                   	cld    
80106b0b:	f3 ab                	rep stos %eax,%es:(%edi)
80106b0d:	89 ca                	mov    %ecx,%edx
80106b0f:	89 fb                	mov    %edi,%ebx
80106b11:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106b14:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106b17:	90                   	nop
80106b18:	5b                   	pop    %ebx
80106b19:	5f                   	pop    %edi
80106b1a:	5d                   	pop    %ebp
80106b1b:	c3                   	ret    

80106b1c <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106b1c:	55                   	push   %ebp
80106b1d:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b22:	83 e0 03             	and    $0x3,%eax
80106b25:	85 c0                	test   %eax,%eax
80106b27:	75 43                	jne    80106b6c <memset+0x50>
80106b29:	8b 45 10             	mov    0x10(%ebp),%eax
80106b2c:	83 e0 03             	and    $0x3,%eax
80106b2f:	85 c0                	test   %eax,%eax
80106b31:	75 39                	jne    80106b6c <memset+0x50>
    c &= 0xFF;
80106b33:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106b3a:	8b 45 10             	mov    0x10(%ebp),%eax
80106b3d:	c1 e8 02             	shr    $0x2,%eax
80106b40:	89 c1                	mov    %eax,%ecx
80106b42:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b45:	c1 e0 18             	shl    $0x18,%eax
80106b48:	89 c2                	mov    %eax,%edx
80106b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b4d:	c1 e0 10             	shl    $0x10,%eax
80106b50:	09 c2                	or     %eax,%edx
80106b52:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b55:	c1 e0 08             	shl    $0x8,%eax
80106b58:	09 d0                	or     %edx,%eax
80106b5a:	0b 45 0c             	or     0xc(%ebp),%eax
80106b5d:	51                   	push   %ecx
80106b5e:	50                   	push   %eax
80106b5f:	ff 75 08             	pushl  0x8(%ebp)
80106b62:	e8 8f ff ff ff       	call   80106af6 <stosl>
80106b67:	83 c4 0c             	add    $0xc,%esp
80106b6a:	eb 12                	jmp    80106b7e <memset+0x62>
  } else
    stosb(dst, c, n);
80106b6c:	8b 45 10             	mov    0x10(%ebp),%eax
80106b6f:	50                   	push   %eax
80106b70:	ff 75 0c             	pushl  0xc(%ebp)
80106b73:	ff 75 08             	pushl  0x8(%ebp)
80106b76:	e8 55 ff ff ff       	call   80106ad0 <stosb>
80106b7b:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106b7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106b81:	c9                   	leave  
80106b82:	c3                   	ret    

80106b83 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106b83:	55                   	push   %ebp
80106b84:	89 e5                	mov    %esp,%ebp
80106b86:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106b89:	8b 45 08             	mov    0x8(%ebp),%eax
80106b8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b92:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106b95:	eb 30                	jmp    80106bc7 <memcmp+0x44>
    if(*s1 != *s2)
80106b97:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b9a:	0f b6 10             	movzbl (%eax),%edx
80106b9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106ba0:	0f b6 00             	movzbl (%eax),%eax
80106ba3:	38 c2                	cmp    %al,%dl
80106ba5:	74 18                	je     80106bbf <memcmp+0x3c>
      return *s1 - *s2;
80106ba7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106baa:	0f b6 00             	movzbl (%eax),%eax
80106bad:	0f b6 d0             	movzbl %al,%edx
80106bb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bb3:	0f b6 00             	movzbl (%eax),%eax
80106bb6:	0f b6 c0             	movzbl %al,%eax
80106bb9:	29 c2                	sub    %eax,%edx
80106bbb:	89 d0                	mov    %edx,%eax
80106bbd:	eb 1a                	jmp    80106bd9 <memcmp+0x56>
    s1++, s2++;
80106bbf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106bc3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106bc7:	8b 45 10             	mov    0x10(%ebp),%eax
80106bca:	8d 50 ff             	lea    -0x1(%eax),%edx
80106bcd:	89 55 10             	mov    %edx,0x10(%ebp)
80106bd0:	85 c0                	test   %eax,%eax
80106bd2:	75 c3                	jne    80106b97 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bd9:	c9                   	leave  
80106bda:	c3                   	ret    

80106bdb <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106bdb:	55                   	push   %ebp
80106bdc:	89 e5                	mov    %esp,%ebp
80106bde:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106be1:	8b 45 0c             	mov    0xc(%ebp),%eax
80106be4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106be7:	8b 45 08             	mov    0x8(%ebp),%eax
80106bea:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106bed:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bf0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106bf3:	73 54                	jae    80106c49 <memmove+0x6e>
80106bf5:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106bf8:	8b 45 10             	mov    0x10(%ebp),%eax
80106bfb:	01 d0                	add    %edx,%eax
80106bfd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106c00:	76 47                	jbe    80106c49 <memmove+0x6e>
    s += n;
80106c02:	8b 45 10             	mov    0x10(%ebp),%eax
80106c05:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106c08:	8b 45 10             	mov    0x10(%ebp),%eax
80106c0b:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106c0e:	eb 13                	jmp    80106c23 <memmove+0x48>
      *--d = *--s;
80106c10:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106c14:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c1b:	0f b6 10             	movzbl (%eax),%edx
80106c1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106c21:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106c23:	8b 45 10             	mov    0x10(%ebp),%eax
80106c26:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c29:	89 55 10             	mov    %edx,0x10(%ebp)
80106c2c:	85 c0                	test   %eax,%eax
80106c2e:	75 e0                	jne    80106c10 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106c30:	eb 24                	jmp    80106c56 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106c32:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106c35:	8d 50 01             	lea    0x1(%eax),%edx
80106c38:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106c3b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c3e:	8d 4a 01             	lea    0x1(%edx),%ecx
80106c41:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106c44:	0f b6 12             	movzbl (%edx),%edx
80106c47:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106c49:	8b 45 10             	mov    0x10(%ebp),%eax
80106c4c:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c4f:	89 55 10             	mov    %edx,0x10(%ebp)
80106c52:	85 c0                	test   %eax,%eax
80106c54:	75 dc                	jne    80106c32 <memmove+0x57>
      *d++ = *s++;

  return dst;
80106c56:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106c59:	c9                   	leave  
80106c5a:	c3                   	ret    

80106c5b <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106c5b:	55                   	push   %ebp
80106c5c:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106c5e:	ff 75 10             	pushl  0x10(%ebp)
80106c61:	ff 75 0c             	pushl  0xc(%ebp)
80106c64:	ff 75 08             	pushl  0x8(%ebp)
80106c67:	e8 6f ff ff ff       	call   80106bdb <memmove>
80106c6c:	83 c4 0c             	add    $0xc,%esp
}
80106c6f:	c9                   	leave  
80106c70:	c3                   	ret    

80106c71 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106c71:	55                   	push   %ebp
80106c72:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106c74:	eb 0c                	jmp    80106c82 <strncmp+0x11>
    n--, p++, q++;
80106c76:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106c7a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106c7e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c86:	74 1a                	je     80106ca2 <strncmp+0x31>
80106c88:	8b 45 08             	mov    0x8(%ebp),%eax
80106c8b:	0f b6 00             	movzbl (%eax),%eax
80106c8e:	84 c0                	test   %al,%al
80106c90:	74 10                	je     80106ca2 <strncmp+0x31>
80106c92:	8b 45 08             	mov    0x8(%ebp),%eax
80106c95:	0f b6 10             	movzbl (%eax),%edx
80106c98:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c9b:	0f b6 00             	movzbl (%eax),%eax
80106c9e:	38 c2                	cmp    %al,%dl
80106ca0:	74 d4                	je     80106c76 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106ca2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106ca6:	75 07                	jne    80106caf <strncmp+0x3e>
    return 0;
80106ca8:	b8 00 00 00 00       	mov    $0x0,%eax
80106cad:	eb 16                	jmp    80106cc5 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106caf:	8b 45 08             	mov    0x8(%ebp),%eax
80106cb2:	0f b6 00             	movzbl (%eax),%eax
80106cb5:	0f b6 d0             	movzbl %al,%edx
80106cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cbb:	0f b6 00             	movzbl (%eax),%eax
80106cbe:	0f b6 c0             	movzbl %al,%eax
80106cc1:	29 c2                	sub    %eax,%edx
80106cc3:	89 d0                	mov    %edx,%eax
}
80106cc5:	5d                   	pop    %ebp
80106cc6:	c3                   	ret    

80106cc7 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106cc7:	55                   	push   %ebp
80106cc8:	89 e5                	mov    %esp,%ebp
80106cca:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106ccd:	8b 45 08             	mov    0x8(%ebp),%eax
80106cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106cd3:	90                   	nop
80106cd4:	8b 45 10             	mov    0x10(%ebp),%eax
80106cd7:	8d 50 ff             	lea    -0x1(%eax),%edx
80106cda:	89 55 10             	mov    %edx,0x10(%ebp)
80106cdd:	85 c0                	test   %eax,%eax
80106cdf:	7e 2c                	jle    80106d0d <strncpy+0x46>
80106ce1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce4:	8d 50 01             	lea    0x1(%eax),%edx
80106ce7:	89 55 08             	mov    %edx,0x8(%ebp)
80106cea:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ced:	8d 4a 01             	lea    0x1(%edx),%ecx
80106cf0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106cf3:	0f b6 12             	movzbl (%edx),%edx
80106cf6:	88 10                	mov    %dl,(%eax)
80106cf8:	0f b6 00             	movzbl (%eax),%eax
80106cfb:	84 c0                	test   %al,%al
80106cfd:	75 d5                	jne    80106cd4 <strncpy+0xd>
    ;
  while(n-- > 0)
80106cff:	eb 0c                	jmp    80106d0d <strncpy+0x46>
    *s++ = 0;
80106d01:	8b 45 08             	mov    0x8(%ebp),%eax
80106d04:	8d 50 01             	lea    0x1(%eax),%edx
80106d07:	89 55 08             	mov    %edx,0x8(%ebp)
80106d0a:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106d0d:	8b 45 10             	mov    0x10(%ebp),%eax
80106d10:	8d 50 ff             	lea    -0x1(%eax),%edx
80106d13:	89 55 10             	mov    %edx,0x10(%ebp)
80106d16:	85 c0                	test   %eax,%eax
80106d18:	7f e7                	jg     80106d01 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d1d:	c9                   	leave  
80106d1e:	c3                   	ret    

80106d1f <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106d1f:	55                   	push   %ebp
80106d20:	89 e5                	mov    %esp,%ebp
80106d22:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106d25:	8b 45 08             	mov    0x8(%ebp),%eax
80106d28:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106d2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106d2f:	7f 05                	jg     80106d36 <safestrcpy+0x17>
    return os;
80106d31:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106d34:	eb 31                	jmp    80106d67 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106d36:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106d3e:	7e 1e                	jle    80106d5e <safestrcpy+0x3f>
80106d40:	8b 45 08             	mov    0x8(%ebp),%eax
80106d43:	8d 50 01             	lea    0x1(%eax),%edx
80106d46:	89 55 08             	mov    %edx,0x8(%ebp)
80106d49:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d4c:	8d 4a 01             	lea    0x1(%edx),%ecx
80106d4f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106d52:	0f b6 12             	movzbl (%edx),%edx
80106d55:	88 10                	mov    %dl,(%eax)
80106d57:	0f b6 00             	movzbl (%eax),%eax
80106d5a:	84 c0                	test   %al,%al
80106d5c:	75 d8                	jne    80106d36 <safestrcpy+0x17>
    ;
  *s = 0;
80106d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80106d61:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d67:	c9                   	leave  
80106d68:	c3                   	ret    

80106d69 <strlen>:

int
strlen(const char *s)
{
80106d69:	55                   	push   %ebp
80106d6a:	89 e5                	mov    %esp,%ebp
80106d6c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106d6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106d76:	eb 04                	jmp    80106d7c <strlen+0x13>
80106d78:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106d7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d82:	01 d0                	add    %edx,%eax
80106d84:	0f b6 00             	movzbl (%eax),%eax
80106d87:	84 c0                	test   %al,%al
80106d89:	75 ed                	jne    80106d78 <strlen+0xf>
    ;
  return n;
80106d8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d8e:	c9                   	leave  
80106d8f:	c3                   	ret    

80106d90 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106d90:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106d94:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106d98:	55                   	push   %ebp
  pushl %ebx
80106d99:	53                   	push   %ebx
  pushl %esi
80106d9a:	56                   	push   %esi
  pushl %edi
80106d9b:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106d9c:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106d9e:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106da0:	5f                   	pop    %edi
  popl %esi
80106da1:	5e                   	pop    %esi
  popl %ebx
80106da2:	5b                   	pop    %ebx
  popl %ebp
80106da3:	5d                   	pop    %ebp
  ret
80106da4:	c3                   	ret    

80106da5 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106da5:	55                   	push   %ebp
80106da6:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106da8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dae:	8b 00                	mov    (%eax),%eax
80106db0:	3b 45 08             	cmp    0x8(%ebp),%eax
80106db3:	76 12                	jbe    80106dc7 <fetchint+0x22>
80106db5:	8b 45 08             	mov    0x8(%ebp),%eax
80106db8:	8d 50 04             	lea    0x4(%eax),%edx
80106dbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dc1:	8b 00                	mov    (%eax),%eax
80106dc3:	39 c2                	cmp    %eax,%edx
80106dc5:	76 07                	jbe    80106dce <fetchint+0x29>
    return -1;
80106dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dcc:	eb 0f                	jmp    80106ddd <fetchint+0x38>
  *ip = *(int*)(addr);
80106dce:	8b 45 08             	mov    0x8(%ebp),%eax
80106dd1:	8b 10                	mov    (%eax),%edx
80106dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dd6:	89 10                	mov    %edx,(%eax)
  return 0;
80106dd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ddd:	5d                   	pop    %ebp
80106dde:	c3                   	ret    

80106ddf <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106ddf:	55                   	push   %ebp
80106de0:	89 e5                	mov    %esp,%ebp
80106de2:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106de5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106deb:	8b 00                	mov    (%eax),%eax
80106ded:	3b 45 08             	cmp    0x8(%ebp),%eax
80106df0:	77 07                	ja     80106df9 <fetchstr+0x1a>
    return -1;
80106df2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106df7:	eb 46                	jmp    80106e3f <fetchstr+0x60>
  *pp = (char*)addr;
80106df9:	8b 55 08             	mov    0x8(%ebp),%edx
80106dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dff:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106e01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e07:	8b 00                	mov    (%eax),%eax
80106e09:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e0f:	8b 00                	mov    (%eax),%eax
80106e11:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106e14:	eb 1c                	jmp    80106e32 <fetchstr+0x53>
    if(*s == 0)
80106e16:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e19:	0f b6 00             	movzbl (%eax),%eax
80106e1c:	84 c0                	test   %al,%al
80106e1e:	75 0e                	jne    80106e2e <fetchstr+0x4f>
      return s - *pp;
80106e20:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e23:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e26:	8b 00                	mov    (%eax),%eax
80106e28:	29 c2                	sub    %eax,%edx
80106e2a:	89 d0                	mov    %edx,%eax
80106e2c:	eb 11                	jmp    80106e3f <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106e2e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106e38:	72 dc                	jb     80106e16 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106e3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e3f:	c9                   	leave  
80106e40:	c3                   	ret    

80106e41 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106e41:	55                   	push   %ebp
80106e42:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106e44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e4a:	8b 40 18             	mov    0x18(%eax),%eax
80106e4d:	8b 40 44             	mov    0x44(%eax),%eax
80106e50:	8b 55 08             	mov    0x8(%ebp),%edx
80106e53:	c1 e2 02             	shl    $0x2,%edx
80106e56:	01 d0                	add    %edx,%eax
80106e58:	83 c0 04             	add    $0x4,%eax
80106e5b:	ff 75 0c             	pushl  0xc(%ebp)
80106e5e:	50                   	push   %eax
80106e5f:	e8 41 ff ff ff       	call   80106da5 <fetchint>
80106e64:	83 c4 08             	add    $0x8,%esp
}
80106e67:	c9                   	leave  
80106e68:	c3                   	ret    

80106e69 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106e69:	55                   	push   %ebp
80106e6a:	89 e5                	mov    %esp,%ebp
80106e6c:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106e6f:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e72:	50                   	push   %eax
80106e73:	ff 75 08             	pushl  0x8(%ebp)
80106e76:	e8 c6 ff ff ff       	call   80106e41 <argint>
80106e7b:	83 c4 08             	add    $0x8,%esp
80106e7e:	85 c0                	test   %eax,%eax
80106e80:	79 07                	jns    80106e89 <argptr+0x20>
    return -1;
80106e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e87:	eb 3b                	jmp    80106ec4 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106e89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e8f:	8b 00                	mov    (%eax),%eax
80106e91:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e94:	39 d0                	cmp    %edx,%eax
80106e96:	76 16                	jbe    80106eae <argptr+0x45>
80106e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e9b:	89 c2                	mov    %eax,%edx
80106e9d:	8b 45 10             	mov    0x10(%ebp),%eax
80106ea0:	01 c2                	add    %eax,%edx
80106ea2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ea8:	8b 00                	mov    (%eax),%eax
80106eaa:	39 c2                	cmp    %eax,%edx
80106eac:	76 07                	jbe    80106eb5 <argptr+0x4c>
    return -1;
80106eae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eb3:	eb 0f                	jmp    80106ec4 <argptr+0x5b>
  *pp = (char*)i;
80106eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106eb8:	89 c2                	mov    %eax,%edx
80106eba:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ebd:	89 10                	mov    %edx,(%eax)
  return 0;
80106ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ec4:	c9                   	leave  
80106ec5:	c3                   	ret    

80106ec6 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106ec6:	55                   	push   %ebp
80106ec7:	89 e5                	mov    %esp,%ebp
80106ec9:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106ecc:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106ecf:	50                   	push   %eax
80106ed0:	ff 75 08             	pushl  0x8(%ebp)
80106ed3:	e8 69 ff ff ff       	call   80106e41 <argint>
80106ed8:	83 c4 08             	add    $0x8,%esp
80106edb:	85 c0                	test   %eax,%eax
80106edd:	79 07                	jns    80106ee6 <argstr+0x20>
    return -1;
80106edf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ee4:	eb 0f                	jmp    80106ef5 <argstr+0x2f>
  return fetchstr(addr, pp);
80106ee6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ee9:	ff 75 0c             	pushl  0xc(%ebp)
80106eec:	50                   	push   %eax
80106eed:	e8 ed fe ff ff       	call   80106ddf <fetchstr>
80106ef2:	83 c4 08             	add    $0x8,%esp
}
80106ef5:	c9                   	leave  
80106ef6:	c3                   	ret    

80106ef7 <syscall>:
};
#endif 

void
syscall(void)
{
80106ef7:	55                   	push   %ebp
80106ef8:	89 e5                	mov    %esp,%ebp
80106efa:	53                   	push   %ebx
80106efb:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106efe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f04:	8b 40 18             	mov    0x18(%eax),%eax
80106f07:	8b 40 1c             	mov    0x1c(%eax),%eax
80106f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106f11:	7e 30                	jle    80106f43 <syscall+0x4c>
80106f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f16:	83 f8 21             	cmp    $0x21,%eax
80106f19:	77 28                	ja     80106f43 <syscall+0x4c>
80106f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f1e:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106f25:	85 c0                	test   %eax,%eax
80106f27:	74 1a                	je     80106f43 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106f29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f2f:	8b 58 18             	mov    0x18(%eax),%ebx
80106f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f35:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106f3c:	ff d0                	call   *%eax
80106f3e:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106f41:	eb 34                	jmp    80106f77 <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80106f43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f49:	8d 50 6c             	lea    0x6c(%eax),%edx
80106f4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106f52:	8b 40 10             	mov    0x10(%eax),%eax
80106f55:	ff 75 f4             	pushl  -0xc(%ebp)
80106f58:	52                   	push   %edx
80106f59:	50                   	push   %eax
80106f5a:	68 ce a6 10 80       	push   $0x8010a6ce
80106f5f:	e8 62 94 ff ff       	call   801003c6 <cprintf>
80106f64:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106f67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f6d:	8b 40 18             	mov    0x18(%eax),%eax
80106f70:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106f77:	90                   	nop
80106f78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106f7b:	c9                   	leave  
80106f7c:	c3                   	ret    

80106f7d <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106f7d:	55                   	push   %ebp
80106f7e:	89 e5                	mov    %esp,%ebp
80106f80:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106f83:	83 ec 08             	sub    $0x8,%esp
80106f86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f89:	50                   	push   %eax
80106f8a:	ff 75 08             	pushl  0x8(%ebp)
80106f8d:	e8 af fe ff ff       	call   80106e41 <argint>
80106f92:	83 c4 10             	add    $0x10,%esp
80106f95:	85 c0                	test   %eax,%eax
80106f97:	79 07                	jns    80106fa0 <argfd+0x23>
    return -1;
80106f99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f9e:	eb 50                	jmp    80106ff0 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fa3:	85 c0                	test   %eax,%eax
80106fa5:	78 21                	js     80106fc8 <argfd+0x4b>
80106fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106faa:	83 f8 0f             	cmp    $0xf,%eax
80106fad:	7f 19                	jg     80106fc8 <argfd+0x4b>
80106faf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fb8:	83 c2 08             	add    $0x8,%edx
80106fbb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fc6:	75 07                	jne    80106fcf <argfd+0x52>
    return -1;
80106fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fcd:	eb 21                	jmp    80106ff0 <argfd+0x73>
  if(pfd)
80106fcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106fd3:	74 08                	je     80106fdd <argfd+0x60>
    *pfd = fd;
80106fd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fdb:	89 10                	mov    %edx,(%eax)
  if(pf)
80106fdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106fe1:	74 08                	je     80106feb <argfd+0x6e>
    *pf = f;
80106fe3:	8b 45 10             	mov    0x10(%ebp),%eax
80106fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106fe9:	89 10                	mov    %edx,(%eax)
  return 0;
80106feb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ff0:	c9                   	leave  
80106ff1:	c3                   	ret    

80106ff2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106ff2:	55                   	push   %ebp
80106ff3:	89 e5                	mov    %esp,%ebp
80106ff5:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106ff8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106fff:	eb 30                	jmp    80107031 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80107001:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107007:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010700a:	83 c2 08             	add    $0x8,%edx
8010700d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80107011:	85 c0                	test   %eax,%eax
80107013:	75 18                	jne    8010702d <fdalloc+0x3b>
      proc->ofile[fd] = f;
80107015:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010701b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010701e:	8d 4a 08             	lea    0x8(%edx),%ecx
80107021:	8b 55 08             	mov    0x8(%ebp),%edx
80107024:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80107028:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010702b:	eb 0f                	jmp    8010703c <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010702d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107031:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80107035:	7e ca                	jle    80107001 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80107037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010703c:	c9                   	leave  
8010703d:	c3                   	ret    

8010703e <sys_dup>:

int
sys_dup(void)
{
8010703e:	55                   	push   %ebp
8010703f:	89 e5                	mov    %esp,%ebp
80107041:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80107044:	83 ec 04             	sub    $0x4,%esp
80107047:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010704a:	50                   	push   %eax
8010704b:	6a 00                	push   $0x0
8010704d:	6a 00                	push   $0x0
8010704f:	e8 29 ff ff ff       	call   80106f7d <argfd>
80107054:	83 c4 10             	add    $0x10,%esp
80107057:	85 c0                	test   %eax,%eax
80107059:	79 07                	jns    80107062 <sys_dup+0x24>
    return -1;
8010705b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107060:	eb 31                	jmp    80107093 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80107062:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107065:	83 ec 0c             	sub    $0xc,%esp
80107068:	50                   	push   %eax
80107069:	e8 84 ff ff ff       	call   80106ff2 <fdalloc>
8010706e:	83 c4 10             	add    $0x10,%esp
80107071:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107074:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107078:	79 07                	jns    80107081 <sys_dup+0x43>
    return -1;
8010707a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010707f:	eb 12                	jmp    80107093 <sys_dup+0x55>
  filedup(f);
80107081:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107084:	83 ec 0c             	sub    $0xc,%esp
80107087:	50                   	push   %eax
80107088:	e8 c8 a0 ff ff       	call   80101155 <filedup>
8010708d:	83 c4 10             	add    $0x10,%esp
  return fd;
80107090:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107093:	c9                   	leave  
80107094:	c3                   	ret    

80107095 <sys_read>:

int
sys_read(void)
{
80107095:	55                   	push   %ebp
80107096:	89 e5                	mov    %esp,%ebp
80107098:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010709b:	83 ec 04             	sub    $0x4,%esp
8010709e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070a1:	50                   	push   %eax
801070a2:	6a 00                	push   $0x0
801070a4:	6a 00                	push   $0x0
801070a6:	e8 d2 fe ff ff       	call   80106f7d <argfd>
801070ab:	83 c4 10             	add    $0x10,%esp
801070ae:	85 c0                	test   %eax,%eax
801070b0:	78 2e                	js     801070e0 <sys_read+0x4b>
801070b2:	83 ec 08             	sub    $0x8,%esp
801070b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070b8:	50                   	push   %eax
801070b9:	6a 02                	push   $0x2
801070bb:	e8 81 fd ff ff       	call   80106e41 <argint>
801070c0:	83 c4 10             	add    $0x10,%esp
801070c3:	85 c0                	test   %eax,%eax
801070c5:	78 19                	js     801070e0 <sys_read+0x4b>
801070c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070ca:	83 ec 04             	sub    $0x4,%esp
801070cd:	50                   	push   %eax
801070ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801070d1:	50                   	push   %eax
801070d2:	6a 01                	push   $0x1
801070d4:	e8 90 fd ff ff       	call   80106e69 <argptr>
801070d9:	83 c4 10             	add    $0x10,%esp
801070dc:	85 c0                	test   %eax,%eax
801070de:	79 07                	jns    801070e7 <sys_read+0x52>
    return -1;
801070e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070e5:	eb 17                	jmp    801070fe <sys_read+0x69>
  return fileread(f, p, n);
801070e7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801070ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
801070ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070f0:	83 ec 04             	sub    $0x4,%esp
801070f3:	51                   	push   %ecx
801070f4:	52                   	push   %edx
801070f5:	50                   	push   %eax
801070f6:	e8 ea a1 ff ff       	call   801012e5 <fileread>
801070fb:	83 c4 10             	add    $0x10,%esp
}
801070fe:	c9                   	leave  
801070ff:	c3                   	ret    

80107100 <sys_write>:

int
sys_write(void)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80107106:	83 ec 04             	sub    $0x4,%esp
80107109:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010710c:	50                   	push   %eax
8010710d:	6a 00                	push   $0x0
8010710f:	6a 00                	push   $0x0
80107111:	e8 67 fe ff ff       	call   80106f7d <argfd>
80107116:	83 c4 10             	add    $0x10,%esp
80107119:	85 c0                	test   %eax,%eax
8010711b:	78 2e                	js     8010714b <sys_write+0x4b>
8010711d:	83 ec 08             	sub    $0x8,%esp
80107120:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107123:	50                   	push   %eax
80107124:	6a 02                	push   $0x2
80107126:	e8 16 fd ff ff       	call   80106e41 <argint>
8010712b:	83 c4 10             	add    $0x10,%esp
8010712e:	85 c0                	test   %eax,%eax
80107130:	78 19                	js     8010714b <sys_write+0x4b>
80107132:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107135:	83 ec 04             	sub    $0x4,%esp
80107138:	50                   	push   %eax
80107139:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010713c:	50                   	push   %eax
8010713d:	6a 01                	push   $0x1
8010713f:	e8 25 fd ff ff       	call   80106e69 <argptr>
80107144:	83 c4 10             	add    $0x10,%esp
80107147:	85 c0                	test   %eax,%eax
80107149:	79 07                	jns    80107152 <sys_write+0x52>
    return -1;
8010714b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107150:	eb 17                	jmp    80107169 <sys_write+0x69>
  return filewrite(f, p, n);
80107152:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107155:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010715b:	83 ec 04             	sub    $0x4,%esp
8010715e:	51                   	push   %ecx
8010715f:	52                   	push   %edx
80107160:	50                   	push   %eax
80107161:	e8 37 a2 ff ff       	call   8010139d <filewrite>
80107166:	83 c4 10             	add    $0x10,%esp
}
80107169:	c9                   	leave  
8010716a:	c3                   	ret    

8010716b <sys_close>:

int
sys_close(void)
{
8010716b:	55                   	push   %ebp
8010716c:	89 e5                	mov    %esp,%ebp
8010716e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80107171:	83 ec 04             	sub    $0x4,%esp
80107174:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107177:	50                   	push   %eax
80107178:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010717b:	50                   	push   %eax
8010717c:	6a 00                	push   $0x0
8010717e:	e8 fa fd ff ff       	call   80106f7d <argfd>
80107183:	83 c4 10             	add    $0x10,%esp
80107186:	85 c0                	test   %eax,%eax
80107188:	79 07                	jns    80107191 <sys_close+0x26>
    return -1;
8010718a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010718f:	eb 28                	jmp    801071b9 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80107191:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107197:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010719a:	83 c2 08             	add    $0x8,%edx
8010719d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801071a4:	00 
  fileclose(f);
801071a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071a8:	83 ec 0c             	sub    $0xc,%esp
801071ab:	50                   	push   %eax
801071ac:	e8 f5 9f ff ff       	call   801011a6 <fileclose>
801071b1:	83 c4 10             	add    $0x10,%esp
  return 0;
801071b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801071b9:	c9                   	leave  
801071ba:	c3                   	ret    

801071bb <sys_fstat>:

int
sys_fstat(void)
{
801071bb:	55                   	push   %ebp
801071bc:	89 e5                	mov    %esp,%ebp
801071be:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801071c1:	83 ec 04             	sub    $0x4,%esp
801071c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801071c7:	50                   	push   %eax
801071c8:	6a 00                	push   $0x0
801071ca:	6a 00                	push   $0x0
801071cc:	e8 ac fd ff ff       	call   80106f7d <argfd>
801071d1:	83 c4 10             	add    $0x10,%esp
801071d4:	85 c0                	test   %eax,%eax
801071d6:	78 17                	js     801071ef <sys_fstat+0x34>
801071d8:	83 ec 04             	sub    $0x4,%esp
801071db:	6a 1c                	push   $0x1c
801071dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801071e0:	50                   	push   %eax
801071e1:	6a 01                	push   $0x1
801071e3:	e8 81 fc ff ff       	call   80106e69 <argptr>
801071e8:	83 c4 10             	add    $0x10,%esp
801071eb:	85 c0                	test   %eax,%eax
801071ed:	79 07                	jns    801071f6 <sys_fstat+0x3b>
    return -1;
801071ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071f4:	eb 13                	jmp    80107209 <sys_fstat+0x4e>
  return filestat(f, st);
801071f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801071f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071fc:	83 ec 08             	sub    $0x8,%esp
801071ff:	52                   	push   %edx
80107200:	50                   	push   %eax
80107201:	e8 88 a0 ff ff       	call   8010128e <filestat>
80107206:	83 c4 10             	add    $0x10,%esp
}
80107209:	c9                   	leave  
8010720a:	c3                   	ret    

8010720b <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010720b:	55                   	push   %ebp
8010720c:	89 e5                	mov    %esp,%ebp
8010720e:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80107211:	83 ec 08             	sub    $0x8,%esp
80107214:	8d 45 d8             	lea    -0x28(%ebp),%eax
80107217:	50                   	push   %eax
80107218:	6a 00                	push   $0x0
8010721a:	e8 a7 fc ff ff       	call   80106ec6 <argstr>
8010721f:	83 c4 10             	add    $0x10,%esp
80107222:	85 c0                	test   %eax,%eax
80107224:	78 15                	js     8010723b <sys_link+0x30>
80107226:	83 ec 08             	sub    $0x8,%esp
80107229:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010722c:	50                   	push   %eax
8010722d:	6a 01                	push   $0x1
8010722f:	e8 92 fc ff ff       	call   80106ec6 <argstr>
80107234:	83 c4 10             	add    $0x10,%esp
80107237:	85 c0                	test   %eax,%eax
80107239:	79 0a                	jns    80107245 <sys_link+0x3a>
    return -1;
8010723b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107240:	e9 68 01 00 00       	jmp    801073ad <sys_link+0x1a2>

  begin_op();
80107245:	e8 1d c6 ff ff       	call   80103867 <begin_op>
  if((ip = namei(old)) == 0){
8010724a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010724d:	83 ec 0c             	sub    $0xc,%esp
80107250:	50                   	push   %eax
80107251:	e8 9f b4 ff ff       	call   801026f5 <namei>
80107256:	83 c4 10             	add    $0x10,%esp
80107259:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010725c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107260:	75 0f                	jne    80107271 <sys_link+0x66>
    end_op();
80107262:	e8 8c c6 ff ff       	call   801038f3 <end_op>
    return -1;
80107267:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010726c:	e9 3c 01 00 00       	jmp    801073ad <sys_link+0x1a2>
  }

  ilock(ip);
80107271:	83 ec 0c             	sub    $0xc,%esp
80107274:	ff 75 f4             	pushl  -0xc(%ebp)
80107277:	e8 6b a8 ff ff       	call   80101ae7 <ilock>
8010727c:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010727f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107282:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107286:	66 83 f8 01          	cmp    $0x1,%ax
8010728a:	75 1d                	jne    801072a9 <sys_link+0x9e>
    iunlockput(ip);
8010728c:	83 ec 0c             	sub    $0xc,%esp
8010728f:	ff 75 f4             	pushl  -0xc(%ebp)
80107292:	e8 38 ab ff ff       	call   80101dcf <iunlockput>
80107297:	83 c4 10             	add    $0x10,%esp
    end_op();
8010729a:	e8 54 c6 ff ff       	call   801038f3 <end_op>
    return -1;
8010729f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072a4:	e9 04 01 00 00       	jmp    801073ad <sys_link+0x1a2>
  }

  ip->nlink++;
801072a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ac:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801072b0:	83 c0 01             	add    $0x1,%eax
801072b3:	89 c2                	mov    %eax,%edx
801072b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072b8:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801072bc:	83 ec 0c             	sub    $0xc,%esp
801072bf:	ff 75 f4             	pushl  -0xc(%ebp)
801072c2:	e8 1e a6 ff ff       	call   801018e5 <iupdate>
801072c7:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801072ca:	83 ec 0c             	sub    $0xc,%esp
801072cd:	ff 75 f4             	pushl  -0xc(%ebp)
801072d0:	e8 98 a9 ff ff       	call   80101c6d <iunlock>
801072d5:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801072d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801072db:	83 ec 08             	sub    $0x8,%esp
801072de:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801072e1:	52                   	push   %edx
801072e2:	50                   	push   %eax
801072e3:	e8 29 b4 ff ff       	call   80102711 <nameiparent>
801072e8:	83 c4 10             	add    $0x10,%esp
801072eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801072ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801072f2:	74 71                	je     80107365 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801072f4:	83 ec 0c             	sub    $0xc,%esp
801072f7:	ff 75 f0             	pushl  -0x10(%ebp)
801072fa:	e8 e8 a7 ff ff       	call   80101ae7 <ilock>
801072ff:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80107302:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107305:	8b 10                	mov    (%eax),%edx
80107307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730a:	8b 00                	mov    (%eax),%eax
8010730c:	39 c2                	cmp    %eax,%edx
8010730e:	75 1d                	jne    8010732d <sys_link+0x122>
80107310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107313:	8b 40 04             	mov    0x4(%eax),%eax
80107316:	83 ec 04             	sub    $0x4,%esp
80107319:	50                   	push   %eax
8010731a:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010731d:	50                   	push   %eax
8010731e:	ff 75 f0             	pushl  -0x10(%ebp)
80107321:	e8 33 b1 ff ff       	call   80102459 <dirlink>
80107326:	83 c4 10             	add    $0x10,%esp
80107329:	85 c0                	test   %eax,%eax
8010732b:	79 10                	jns    8010733d <sys_link+0x132>
    iunlockput(dp);
8010732d:	83 ec 0c             	sub    $0xc,%esp
80107330:	ff 75 f0             	pushl  -0x10(%ebp)
80107333:	e8 97 aa ff ff       	call   80101dcf <iunlockput>
80107338:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010733b:	eb 29                	jmp    80107366 <sys_link+0x15b>
  }
  iunlockput(dp);
8010733d:	83 ec 0c             	sub    $0xc,%esp
80107340:	ff 75 f0             	pushl  -0x10(%ebp)
80107343:	e8 87 aa ff ff       	call   80101dcf <iunlockput>
80107348:	83 c4 10             	add    $0x10,%esp
  iput(ip);
8010734b:	83 ec 0c             	sub    $0xc,%esp
8010734e:	ff 75 f4             	pushl  -0xc(%ebp)
80107351:	e8 89 a9 ff ff       	call   80101cdf <iput>
80107356:	83 c4 10             	add    $0x10,%esp

  end_op();
80107359:	e8 95 c5 ff ff       	call   801038f3 <end_op>

  return 0;
8010735e:	b8 00 00 00 00       	mov    $0x0,%eax
80107363:	eb 48                	jmp    801073ad <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80107365:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80107366:	83 ec 0c             	sub    $0xc,%esp
80107369:	ff 75 f4             	pushl  -0xc(%ebp)
8010736c:	e8 76 a7 ff ff       	call   80101ae7 <ilock>
80107371:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80107374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107377:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010737b:	83 e8 01             	sub    $0x1,%eax
8010737e:	89 c2                	mov    %eax,%edx
80107380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107383:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107387:	83 ec 0c             	sub    $0xc,%esp
8010738a:	ff 75 f4             	pushl  -0xc(%ebp)
8010738d:	e8 53 a5 ff ff       	call   801018e5 <iupdate>
80107392:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107395:	83 ec 0c             	sub    $0xc,%esp
80107398:	ff 75 f4             	pushl  -0xc(%ebp)
8010739b:	e8 2f aa ff ff       	call   80101dcf <iunlockput>
801073a0:	83 c4 10             	add    $0x10,%esp
  end_op();
801073a3:	e8 4b c5 ff ff       	call   801038f3 <end_op>
  return -1;
801073a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073ad:	c9                   	leave  
801073ae:	c3                   	ret    

801073af <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801073af:	55                   	push   %ebp
801073b0:	89 e5                	mov    %esp,%ebp
801073b2:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801073b5:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801073bc:	eb 40                	jmp    801073fe <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801073be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c1:	6a 10                	push   $0x10
801073c3:	50                   	push   %eax
801073c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801073c7:	50                   	push   %eax
801073c8:	ff 75 08             	pushl  0x8(%ebp)
801073cb:	e8 d5 ac ff ff       	call   801020a5 <readi>
801073d0:	83 c4 10             	add    $0x10,%esp
801073d3:	83 f8 10             	cmp    $0x10,%eax
801073d6:	74 0d                	je     801073e5 <isdirempty+0x36>
      panic("isdirempty: readi");
801073d8:	83 ec 0c             	sub    $0xc,%esp
801073db:	68 ea a6 10 80       	push   $0x8010a6ea
801073e0:	e8 81 91 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
801073e5:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801073e9:	66 85 c0             	test   %ax,%ax
801073ec:	74 07                	je     801073f5 <isdirempty+0x46>
      return 0;
801073ee:	b8 00 00 00 00       	mov    $0x0,%eax
801073f3:	eb 1b                	jmp    80107410 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801073f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f8:	83 c0 10             	add    $0x10,%eax
801073fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073fe:	8b 45 08             	mov    0x8(%ebp),%eax
80107401:	8b 50 20             	mov    0x20(%eax),%edx
80107404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107407:	39 c2                	cmp    %eax,%edx
80107409:	77 b3                	ja     801073be <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010740b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107410:	c9                   	leave  
80107411:	c3                   	ret    

80107412 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80107412:	55                   	push   %ebp
80107413:	89 e5                	mov    %esp,%ebp
80107415:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80107418:	83 ec 08             	sub    $0x8,%esp
8010741b:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010741e:	50                   	push   %eax
8010741f:	6a 00                	push   $0x0
80107421:	e8 a0 fa ff ff       	call   80106ec6 <argstr>
80107426:	83 c4 10             	add    $0x10,%esp
80107429:	85 c0                	test   %eax,%eax
8010742b:	79 0a                	jns    80107437 <sys_unlink+0x25>
    return -1;
8010742d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107432:	e9 bc 01 00 00       	jmp    801075f3 <sys_unlink+0x1e1>

  begin_op();
80107437:	e8 2b c4 ff ff       	call   80103867 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010743c:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010743f:	83 ec 08             	sub    $0x8,%esp
80107442:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80107445:	52                   	push   %edx
80107446:	50                   	push   %eax
80107447:	e8 c5 b2 ff ff       	call   80102711 <nameiparent>
8010744c:	83 c4 10             	add    $0x10,%esp
8010744f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107456:	75 0f                	jne    80107467 <sys_unlink+0x55>
    end_op();
80107458:	e8 96 c4 ff ff       	call   801038f3 <end_op>
    return -1;
8010745d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107462:	e9 8c 01 00 00       	jmp    801075f3 <sys_unlink+0x1e1>
  }

  ilock(dp);
80107467:	83 ec 0c             	sub    $0xc,%esp
8010746a:	ff 75 f4             	pushl  -0xc(%ebp)
8010746d:	e8 75 a6 ff ff       	call   80101ae7 <ilock>
80107472:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80107475:	83 ec 08             	sub    $0x8,%esp
80107478:	68 fc a6 10 80       	push   $0x8010a6fc
8010747d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107480:	50                   	push   %eax
80107481:	e8 fe ae ff ff       	call   80102384 <namecmp>
80107486:	83 c4 10             	add    $0x10,%esp
80107489:	85 c0                	test   %eax,%eax
8010748b:	0f 84 4a 01 00 00    	je     801075db <sys_unlink+0x1c9>
80107491:	83 ec 08             	sub    $0x8,%esp
80107494:	68 fe a6 10 80       	push   $0x8010a6fe
80107499:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010749c:	50                   	push   %eax
8010749d:	e8 e2 ae ff ff       	call   80102384 <namecmp>
801074a2:	83 c4 10             	add    $0x10,%esp
801074a5:	85 c0                	test   %eax,%eax
801074a7:	0f 84 2e 01 00 00    	je     801075db <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801074ad:	83 ec 04             	sub    $0x4,%esp
801074b0:	8d 45 c8             	lea    -0x38(%ebp),%eax
801074b3:	50                   	push   %eax
801074b4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801074b7:	50                   	push   %eax
801074b8:	ff 75 f4             	pushl  -0xc(%ebp)
801074bb:	e8 df ae ff ff       	call   8010239f <dirlookup>
801074c0:	83 c4 10             	add    $0x10,%esp
801074c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801074c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801074ca:	0f 84 0a 01 00 00    	je     801075da <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
801074d0:	83 ec 0c             	sub    $0xc,%esp
801074d3:	ff 75 f0             	pushl  -0x10(%ebp)
801074d6:	e8 0c a6 ff ff       	call   80101ae7 <ilock>
801074db:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801074de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074e1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801074e5:	66 85 c0             	test   %ax,%ax
801074e8:	7f 0d                	jg     801074f7 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801074ea:	83 ec 0c             	sub    $0xc,%esp
801074ed:	68 01 a7 10 80       	push   $0x8010a701
801074f2:	e8 6f 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801074f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074fa:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801074fe:	66 83 f8 01          	cmp    $0x1,%ax
80107502:	75 25                	jne    80107529 <sys_unlink+0x117>
80107504:	83 ec 0c             	sub    $0xc,%esp
80107507:	ff 75 f0             	pushl  -0x10(%ebp)
8010750a:	e8 a0 fe ff ff       	call   801073af <isdirempty>
8010750f:	83 c4 10             	add    $0x10,%esp
80107512:	85 c0                	test   %eax,%eax
80107514:	75 13                	jne    80107529 <sys_unlink+0x117>
    iunlockput(ip);
80107516:	83 ec 0c             	sub    $0xc,%esp
80107519:	ff 75 f0             	pushl  -0x10(%ebp)
8010751c:	e8 ae a8 ff ff       	call   80101dcf <iunlockput>
80107521:	83 c4 10             	add    $0x10,%esp
    goto bad;
80107524:	e9 b2 00 00 00       	jmp    801075db <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80107529:	83 ec 04             	sub    $0x4,%esp
8010752c:	6a 10                	push   $0x10
8010752e:	6a 00                	push   $0x0
80107530:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107533:	50                   	push   %eax
80107534:	e8 e3 f5 ff ff       	call   80106b1c <memset>
80107539:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010753c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010753f:	6a 10                	push   $0x10
80107541:	50                   	push   %eax
80107542:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107545:	50                   	push   %eax
80107546:	ff 75 f4             	pushl  -0xc(%ebp)
80107549:	e8 ae ac ff ff       	call   801021fc <writei>
8010754e:	83 c4 10             	add    $0x10,%esp
80107551:	83 f8 10             	cmp    $0x10,%eax
80107554:	74 0d                	je     80107563 <sys_unlink+0x151>
    panic("unlink: writei");
80107556:	83 ec 0c             	sub    $0xc,%esp
80107559:	68 13 a7 10 80       	push   $0x8010a713
8010755e:	e8 03 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80107563:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107566:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010756a:	66 83 f8 01          	cmp    $0x1,%ax
8010756e:	75 21                	jne    80107591 <sys_unlink+0x17f>
    dp->nlink--;
80107570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107573:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107577:	83 e8 01             	sub    $0x1,%eax
8010757a:	89 c2                	mov    %eax,%edx
8010757c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010757f:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107583:	83 ec 0c             	sub    $0xc,%esp
80107586:	ff 75 f4             	pushl  -0xc(%ebp)
80107589:	e8 57 a3 ff ff       	call   801018e5 <iupdate>
8010758e:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80107591:	83 ec 0c             	sub    $0xc,%esp
80107594:	ff 75 f4             	pushl  -0xc(%ebp)
80107597:	e8 33 a8 ff ff       	call   80101dcf <iunlockput>
8010759c:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010759f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075a2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801075a6:	83 e8 01             	sub    $0x1,%eax
801075a9:	89 c2                	mov    %eax,%edx
801075ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075ae:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801075b2:	83 ec 0c             	sub    $0xc,%esp
801075b5:	ff 75 f0             	pushl  -0x10(%ebp)
801075b8:	e8 28 a3 ff ff       	call   801018e5 <iupdate>
801075bd:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801075c0:	83 ec 0c             	sub    $0xc,%esp
801075c3:	ff 75 f0             	pushl  -0x10(%ebp)
801075c6:	e8 04 a8 ff ff       	call   80101dcf <iunlockput>
801075cb:	83 c4 10             	add    $0x10,%esp

  end_op();
801075ce:	e8 20 c3 ff ff       	call   801038f3 <end_op>

  return 0;
801075d3:	b8 00 00 00 00       	mov    $0x0,%eax
801075d8:	eb 19                	jmp    801075f3 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801075da:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
801075db:	83 ec 0c             	sub    $0xc,%esp
801075de:	ff 75 f4             	pushl  -0xc(%ebp)
801075e1:	e8 e9 a7 ff ff       	call   80101dcf <iunlockput>
801075e6:	83 c4 10             	add    $0x10,%esp
  end_op();
801075e9:	e8 05 c3 ff ff       	call   801038f3 <end_op>
  return -1;
801075ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075f3:	c9                   	leave  
801075f4:	c3                   	ret    

801075f5 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801075f5:	55                   	push   %ebp
801075f6:	89 e5                	mov    %esp,%ebp
801075f8:	83 ec 38             	sub    $0x38,%esp
801075fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075fe:	8b 55 10             	mov    0x10(%ebp),%edx
80107601:	8b 45 14             	mov    0x14(%ebp),%eax
80107604:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80107608:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010760c:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80107610:	83 ec 08             	sub    $0x8,%esp
80107613:	8d 45 de             	lea    -0x22(%ebp),%eax
80107616:	50                   	push   %eax
80107617:	ff 75 08             	pushl  0x8(%ebp)
8010761a:	e8 f2 b0 ff ff       	call   80102711 <nameiparent>
8010761f:	83 c4 10             	add    $0x10,%esp
80107622:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107629:	75 0a                	jne    80107635 <create+0x40>
    return 0;
8010762b:	b8 00 00 00 00       	mov    $0x0,%eax
80107630:	e9 ac 01 00 00       	jmp    801077e1 <create+0x1ec>
  ilock(dp);
80107635:	83 ec 0c             	sub    $0xc,%esp
80107638:	ff 75 f4             	pushl  -0xc(%ebp)
8010763b:	e8 a7 a4 ff ff       	call   80101ae7 <ilock>
80107640:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80107643:	83 ec 04             	sub    $0x4,%esp
80107646:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107649:	50                   	push   %eax
8010764a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010764d:	50                   	push   %eax
8010764e:	ff 75 f4             	pushl  -0xc(%ebp)
80107651:	e8 49 ad ff ff       	call   8010239f <dirlookup>
80107656:	83 c4 10             	add    $0x10,%esp
80107659:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010765c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107660:	74 50                	je     801076b2 <create+0xbd>
    iunlockput(dp);
80107662:	83 ec 0c             	sub    $0xc,%esp
80107665:	ff 75 f4             	pushl  -0xc(%ebp)
80107668:	e8 62 a7 ff ff       	call   80101dcf <iunlockput>
8010766d:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80107670:	83 ec 0c             	sub    $0xc,%esp
80107673:	ff 75 f0             	pushl  -0x10(%ebp)
80107676:	e8 6c a4 ff ff       	call   80101ae7 <ilock>
8010767b:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010767e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80107683:	75 15                	jne    8010769a <create+0xa5>
80107685:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107688:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010768c:	66 83 f8 02          	cmp    $0x2,%ax
80107690:	75 08                	jne    8010769a <create+0xa5>
      return ip;
80107692:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107695:	e9 47 01 00 00       	jmp    801077e1 <create+0x1ec>
    iunlockput(ip);
8010769a:	83 ec 0c             	sub    $0xc,%esp
8010769d:	ff 75 f0             	pushl  -0x10(%ebp)
801076a0:	e8 2a a7 ff ff       	call   80101dcf <iunlockput>
801076a5:	83 c4 10             	add    $0x10,%esp
    return 0;
801076a8:	b8 00 00 00 00       	mov    $0x0,%eax
801076ad:	e9 2f 01 00 00       	jmp    801077e1 <create+0x1ec>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801076b2:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801076b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b9:	8b 00                	mov    (%eax),%eax
801076bb:	83 ec 08             	sub    $0x8,%esp
801076be:	52                   	push   %edx
801076bf:	50                   	push   %eax
801076c0:	e8 49 a1 ff ff       	call   8010180e <ialloc>
801076c5:	83 c4 10             	add    $0x10,%esp
801076c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801076cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801076cf:	75 0d                	jne    801076de <create+0xe9>
    panic("create: ialloc");
801076d1:	83 ec 0c             	sub    $0xc,%esp
801076d4:	68 22 a7 10 80       	push   $0x8010a722
801076d9:	e8 88 8e ff ff       	call   80100566 <panic>

  ilock(ip);
801076de:	83 ec 0c             	sub    $0xc,%esp
801076e1:	ff 75 f0             	pushl  -0x10(%ebp)
801076e4:	e8 fe a3 ff ff       	call   80101ae7 <ilock>
801076e9:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801076ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076ef:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801076f3:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801076f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076fa:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801076fe:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107702:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107705:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  #ifdef CS333_P5
  ip->uid = DEFAULTUID;
8010770b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010770e:	66 c7 40 18 00 00    	movw   $0x0,0x18(%eax)
  ip->gid = DEFAULTGID;
80107714:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107717:	66 c7 40 1a 00 00    	movw   $0x0,0x1a(%eax)
  ip->mode.as_int = DEFAULTMODE;
8010771d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107720:	c7 40 1c ed 01 00 00 	movl   $0x1ed,0x1c(%eax)
  #endif
  iupdate(ip);
80107727:	83 ec 0c             	sub    $0xc,%esp
8010772a:	ff 75 f0             	pushl  -0x10(%ebp)
8010772d:	e8 b3 a1 ff ff       	call   801018e5 <iupdate>
80107732:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80107735:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010773a:	75 6a                	jne    801077a6 <create+0x1b1>
    dp->nlink++;  // for ".."
8010773c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107743:	83 c0 01             	add    $0x1,%eax
80107746:	89 c2                	mov    %eax,%edx
80107748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774b:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010774f:	83 ec 0c             	sub    $0xc,%esp
80107752:	ff 75 f4             	pushl  -0xc(%ebp)
80107755:	e8 8b a1 ff ff       	call   801018e5 <iupdate>
8010775a:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010775d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107760:	8b 40 04             	mov    0x4(%eax),%eax
80107763:	83 ec 04             	sub    $0x4,%esp
80107766:	50                   	push   %eax
80107767:	68 fc a6 10 80       	push   $0x8010a6fc
8010776c:	ff 75 f0             	pushl  -0x10(%ebp)
8010776f:	e8 e5 ac ff ff       	call   80102459 <dirlink>
80107774:	83 c4 10             	add    $0x10,%esp
80107777:	85 c0                	test   %eax,%eax
80107779:	78 1e                	js     80107799 <create+0x1a4>
8010777b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777e:	8b 40 04             	mov    0x4(%eax),%eax
80107781:	83 ec 04             	sub    $0x4,%esp
80107784:	50                   	push   %eax
80107785:	68 fe a6 10 80       	push   $0x8010a6fe
8010778a:	ff 75 f0             	pushl  -0x10(%ebp)
8010778d:	e8 c7 ac ff ff       	call   80102459 <dirlink>
80107792:	83 c4 10             	add    $0x10,%esp
80107795:	85 c0                	test   %eax,%eax
80107797:	79 0d                	jns    801077a6 <create+0x1b1>
      panic("create dots");
80107799:	83 ec 0c             	sub    $0xc,%esp
8010779c:	68 31 a7 10 80       	push   $0x8010a731
801077a1:	e8 c0 8d ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801077a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077a9:	8b 40 04             	mov    0x4(%eax),%eax
801077ac:	83 ec 04             	sub    $0x4,%esp
801077af:	50                   	push   %eax
801077b0:	8d 45 de             	lea    -0x22(%ebp),%eax
801077b3:	50                   	push   %eax
801077b4:	ff 75 f4             	pushl  -0xc(%ebp)
801077b7:	e8 9d ac ff ff       	call   80102459 <dirlink>
801077bc:	83 c4 10             	add    $0x10,%esp
801077bf:	85 c0                	test   %eax,%eax
801077c1:	79 0d                	jns    801077d0 <create+0x1db>
    panic("create: dirlink");
801077c3:	83 ec 0c             	sub    $0xc,%esp
801077c6:	68 3d a7 10 80       	push   $0x8010a73d
801077cb:	e8 96 8d ff ff       	call   80100566 <panic>

  iunlockput(dp);
801077d0:	83 ec 0c             	sub    $0xc,%esp
801077d3:	ff 75 f4             	pushl  -0xc(%ebp)
801077d6:	e8 f4 a5 ff ff       	call   80101dcf <iunlockput>
801077db:	83 c4 10             	add    $0x10,%esp

  return ip;
801077de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801077e1:	c9                   	leave  
801077e2:	c3                   	ret    

801077e3 <sys_open>:

int
sys_open(void)
{
801077e3:	55                   	push   %ebp
801077e4:	89 e5                	mov    %esp,%ebp
801077e6:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801077e9:	83 ec 08             	sub    $0x8,%esp
801077ec:	8d 45 e8             	lea    -0x18(%ebp),%eax
801077ef:	50                   	push   %eax
801077f0:	6a 00                	push   $0x0
801077f2:	e8 cf f6 ff ff       	call   80106ec6 <argstr>
801077f7:	83 c4 10             	add    $0x10,%esp
801077fa:	85 c0                	test   %eax,%eax
801077fc:	78 15                	js     80107813 <sys_open+0x30>
801077fe:	83 ec 08             	sub    $0x8,%esp
80107801:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107804:	50                   	push   %eax
80107805:	6a 01                	push   $0x1
80107807:	e8 35 f6 ff ff       	call   80106e41 <argint>
8010780c:	83 c4 10             	add    $0x10,%esp
8010780f:	85 c0                	test   %eax,%eax
80107811:	79 0a                	jns    8010781d <sys_open+0x3a>
    return -1;
80107813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107818:	e9 61 01 00 00       	jmp    8010797e <sys_open+0x19b>

  begin_op();
8010781d:	e8 45 c0 ff ff       	call   80103867 <begin_op>

  if(omode & O_CREATE){
80107822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107825:	25 00 02 00 00       	and    $0x200,%eax
8010782a:	85 c0                	test   %eax,%eax
8010782c:	74 2a                	je     80107858 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010782e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107831:	6a 00                	push   $0x0
80107833:	6a 00                	push   $0x0
80107835:	6a 02                	push   $0x2
80107837:	50                   	push   %eax
80107838:	e8 b8 fd ff ff       	call   801075f5 <create>
8010783d:	83 c4 10             	add    $0x10,%esp
80107840:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80107843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107847:	75 75                	jne    801078be <sys_open+0xdb>
      end_op();
80107849:	e8 a5 c0 ff ff       	call   801038f3 <end_op>
      return -1;
8010784e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107853:	e9 26 01 00 00       	jmp    8010797e <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80107858:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010785b:	83 ec 0c             	sub    $0xc,%esp
8010785e:	50                   	push   %eax
8010785f:	e8 91 ae ff ff       	call   801026f5 <namei>
80107864:	83 c4 10             	add    $0x10,%esp
80107867:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010786a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010786e:	75 0f                	jne    8010787f <sys_open+0x9c>
      end_op();
80107870:	e8 7e c0 ff ff       	call   801038f3 <end_op>
      return -1;
80107875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010787a:	e9 ff 00 00 00       	jmp    8010797e <sys_open+0x19b>
    }
    ilock(ip);
8010787f:	83 ec 0c             	sub    $0xc,%esp
80107882:	ff 75 f4             	pushl  -0xc(%ebp)
80107885:	e8 5d a2 ff ff       	call   80101ae7 <ilock>
8010788a:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010788d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107890:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107894:	66 83 f8 01          	cmp    $0x1,%ax
80107898:	75 24                	jne    801078be <sys_open+0xdb>
8010789a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010789d:	85 c0                	test   %eax,%eax
8010789f:	74 1d                	je     801078be <sys_open+0xdb>
      iunlockput(ip);
801078a1:	83 ec 0c             	sub    $0xc,%esp
801078a4:	ff 75 f4             	pushl  -0xc(%ebp)
801078a7:	e8 23 a5 ff ff       	call   80101dcf <iunlockput>
801078ac:	83 c4 10             	add    $0x10,%esp
      end_op();
801078af:	e8 3f c0 ff ff       	call   801038f3 <end_op>
      return -1;
801078b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078b9:	e9 c0 00 00 00       	jmp    8010797e <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801078be:	e8 25 98 ff ff       	call   801010e8 <filealloc>
801078c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078ca:	74 17                	je     801078e3 <sys_open+0x100>
801078cc:	83 ec 0c             	sub    $0xc,%esp
801078cf:	ff 75 f0             	pushl  -0x10(%ebp)
801078d2:	e8 1b f7 ff ff       	call   80106ff2 <fdalloc>
801078d7:	83 c4 10             	add    $0x10,%esp
801078da:	89 45 ec             	mov    %eax,-0x14(%ebp)
801078dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801078e1:	79 2e                	jns    80107911 <sys_open+0x12e>
    if(f)
801078e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078e7:	74 0e                	je     801078f7 <sys_open+0x114>
      fileclose(f);
801078e9:	83 ec 0c             	sub    $0xc,%esp
801078ec:	ff 75 f0             	pushl  -0x10(%ebp)
801078ef:	e8 b2 98 ff ff       	call   801011a6 <fileclose>
801078f4:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801078f7:	83 ec 0c             	sub    $0xc,%esp
801078fa:	ff 75 f4             	pushl  -0xc(%ebp)
801078fd:	e8 cd a4 ff ff       	call   80101dcf <iunlockput>
80107902:	83 c4 10             	add    $0x10,%esp
    end_op();
80107905:	e8 e9 bf ff ff       	call   801038f3 <end_op>
    return -1;
8010790a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010790f:	eb 6d                	jmp    8010797e <sys_open+0x19b>
  }
  iunlock(ip);
80107911:	83 ec 0c             	sub    $0xc,%esp
80107914:	ff 75 f4             	pushl  -0xc(%ebp)
80107917:	e8 51 a3 ff ff       	call   80101c6d <iunlock>
8010791c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010791f:	e8 cf bf ff ff       	call   801038f3 <end_op>

  f->type = FD_INODE;
80107924:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107927:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010792d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107930:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107933:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107936:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107939:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80107940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107943:	83 e0 01             	and    $0x1,%eax
80107946:	85 c0                	test   %eax,%eax
80107948:	0f 94 c0             	sete   %al
8010794b:	89 c2                	mov    %eax,%edx
8010794d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107950:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107956:	83 e0 01             	and    $0x1,%eax
80107959:	85 c0                	test   %eax,%eax
8010795b:	75 0a                	jne    80107967 <sys_open+0x184>
8010795d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107960:	83 e0 02             	and    $0x2,%eax
80107963:	85 c0                	test   %eax,%eax
80107965:	74 07                	je     8010796e <sys_open+0x18b>
80107967:	b8 01 00 00 00       	mov    $0x1,%eax
8010796c:	eb 05                	jmp    80107973 <sys_open+0x190>
8010796e:	b8 00 00 00 00       	mov    $0x0,%eax
80107973:	89 c2                	mov    %eax,%edx
80107975:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107978:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010797b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010797e:	c9                   	leave  
8010797f:	c3                   	ret    

80107980 <sys_mkdir>:

int
sys_mkdir(void)
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107986:	e8 dc be ff ff       	call   80103867 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010798b:	83 ec 08             	sub    $0x8,%esp
8010798e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107991:	50                   	push   %eax
80107992:	6a 00                	push   $0x0
80107994:	e8 2d f5 ff ff       	call   80106ec6 <argstr>
80107999:	83 c4 10             	add    $0x10,%esp
8010799c:	85 c0                	test   %eax,%eax
8010799e:	78 1b                	js     801079bb <sys_mkdir+0x3b>
801079a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079a3:	6a 00                	push   $0x0
801079a5:	6a 00                	push   $0x0
801079a7:	6a 01                	push   $0x1
801079a9:	50                   	push   %eax
801079aa:	e8 46 fc ff ff       	call   801075f5 <create>
801079af:	83 c4 10             	add    $0x10,%esp
801079b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079b9:	75 0c                	jne    801079c7 <sys_mkdir+0x47>
    end_op();
801079bb:	e8 33 bf ff ff       	call   801038f3 <end_op>
    return -1;
801079c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079c5:	eb 18                	jmp    801079df <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801079c7:	83 ec 0c             	sub    $0xc,%esp
801079ca:	ff 75 f4             	pushl  -0xc(%ebp)
801079cd:	e8 fd a3 ff ff       	call   80101dcf <iunlockput>
801079d2:	83 c4 10             	add    $0x10,%esp
  end_op();
801079d5:	e8 19 bf ff ff       	call   801038f3 <end_op>
  return 0;
801079da:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079df:	c9                   	leave  
801079e0:	c3                   	ret    

801079e1 <sys_mknod>:

int
sys_mknod(void)
{
801079e1:	55                   	push   %ebp
801079e2:	89 e5                	mov    %esp,%ebp
801079e4:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801079e7:	e8 7b be ff ff       	call   80103867 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801079ec:	83 ec 08             	sub    $0x8,%esp
801079ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
801079f2:	50                   	push   %eax
801079f3:	6a 00                	push   $0x0
801079f5:	e8 cc f4 ff ff       	call   80106ec6 <argstr>
801079fa:	83 c4 10             	add    $0x10,%esp
801079fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a04:	78 4f                	js     80107a55 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107a06:	83 ec 08             	sub    $0x8,%esp
80107a09:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107a0c:	50                   	push   %eax
80107a0d:	6a 01                	push   $0x1
80107a0f:	e8 2d f4 ff ff       	call   80106e41 <argint>
80107a14:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107a17:	85 c0                	test   %eax,%eax
80107a19:	78 3a                	js     80107a55 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107a1b:	83 ec 08             	sub    $0x8,%esp
80107a1e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107a21:	50                   	push   %eax
80107a22:	6a 02                	push   $0x2
80107a24:	e8 18 f4 ff ff       	call   80106e41 <argint>
80107a29:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107a2c:	85 c0                	test   %eax,%eax
80107a2e:	78 25                	js     80107a55 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80107a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a33:	0f bf c8             	movswl %ax,%ecx
80107a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107a39:	0f bf d0             	movswl %ax,%edx
80107a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107a3f:	51                   	push   %ecx
80107a40:	52                   	push   %edx
80107a41:	6a 03                	push   $0x3
80107a43:	50                   	push   %eax
80107a44:	e8 ac fb ff ff       	call   801075f5 <create>
80107a49:	83 c4 10             	add    $0x10,%esp
80107a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a53:	75 0c                	jne    80107a61 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107a55:	e8 99 be ff ff       	call   801038f3 <end_op>
    return -1;
80107a5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a5f:	eb 18                	jmp    80107a79 <sys_mknod+0x98>
  }
  iunlockput(ip);
80107a61:	83 ec 0c             	sub    $0xc,%esp
80107a64:	ff 75 f0             	pushl  -0x10(%ebp)
80107a67:	e8 63 a3 ff ff       	call   80101dcf <iunlockput>
80107a6c:	83 c4 10             	add    $0x10,%esp
  end_op();
80107a6f:	e8 7f be ff ff       	call   801038f3 <end_op>
  return 0;
80107a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107a79:	c9                   	leave  
80107a7a:	c3                   	ret    

80107a7b <sys_chdir>:

int
sys_chdir(void)
{
80107a7b:	55                   	push   %ebp
80107a7c:	89 e5                	mov    %esp,%ebp
80107a7e:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107a81:	e8 e1 bd ff ff       	call   80103867 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107a86:	83 ec 08             	sub    $0x8,%esp
80107a89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a8c:	50                   	push   %eax
80107a8d:	6a 00                	push   $0x0
80107a8f:	e8 32 f4 ff ff       	call   80106ec6 <argstr>
80107a94:	83 c4 10             	add    $0x10,%esp
80107a97:	85 c0                	test   %eax,%eax
80107a99:	78 18                	js     80107ab3 <sys_chdir+0x38>
80107a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a9e:	83 ec 0c             	sub    $0xc,%esp
80107aa1:	50                   	push   %eax
80107aa2:	e8 4e ac ff ff       	call   801026f5 <namei>
80107aa7:	83 c4 10             	add    $0x10,%esp
80107aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107aad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ab1:	75 0c                	jne    80107abf <sys_chdir+0x44>
    end_op();
80107ab3:	e8 3b be ff ff       	call   801038f3 <end_op>
    return -1;
80107ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107abd:	eb 6e                	jmp    80107b2d <sys_chdir+0xb2>
  }
  ilock(ip);
80107abf:	83 ec 0c             	sub    $0xc,%esp
80107ac2:	ff 75 f4             	pushl  -0xc(%ebp)
80107ac5:	e8 1d a0 ff ff       	call   80101ae7 <ilock>
80107aca:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107ad4:	66 83 f8 01          	cmp    $0x1,%ax
80107ad8:	74 1a                	je     80107af4 <sys_chdir+0x79>
    iunlockput(ip);
80107ada:	83 ec 0c             	sub    $0xc,%esp
80107add:	ff 75 f4             	pushl  -0xc(%ebp)
80107ae0:	e8 ea a2 ff ff       	call   80101dcf <iunlockput>
80107ae5:	83 c4 10             	add    $0x10,%esp
    end_op();
80107ae8:	e8 06 be ff ff       	call   801038f3 <end_op>
    return -1;
80107aed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107af2:	eb 39                	jmp    80107b2d <sys_chdir+0xb2>
  }
  iunlock(ip);
80107af4:	83 ec 0c             	sub    $0xc,%esp
80107af7:	ff 75 f4             	pushl  -0xc(%ebp)
80107afa:	e8 6e a1 ff ff       	call   80101c6d <iunlock>
80107aff:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107b02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b08:	8b 40 68             	mov    0x68(%eax),%eax
80107b0b:	83 ec 0c             	sub    $0xc,%esp
80107b0e:	50                   	push   %eax
80107b0f:	e8 cb a1 ff ff       	call   80101cdf <iput>
80107b14:	83 c4 10             	add    $0x10,%esp
  end_op();
80107b17:	e8 d7 bd ff ff       	call   801038f3 <end_op>
  proc->cwd = ip;
80107b1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b22:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107b25:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107b28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b2d:	c9                   	leave  
80107b2e:	c3                   	ret    

80107b2f <sys_exec>:

int
sys_exec(void)
{
80107b2f:	55                   	push   %ebp
80107b30:	89 e5                	mov    %esp,%ebp
80107b32:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107b38:	83 ec 08             	sub    $0x8,%esp
80107b3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107b3e:	50                   	push   %eax
80107b3f:	6a 00                	push   $0x0
80107b41:	e8 80 f3 ff ff       	call   80106ec6 <argstr>
80107b46:	83 c4 10             	add    $0x10,%esp
80107b49:	85 c0                	test   %eax,%eax
80107b4b:	78 18                	js     80107b65 <sys_exec+0x36>
80107b4d:	83 ec 08             	sub    $0x8,%esp
80107b50:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107b56:	50                   	push   %eax
80107b57:	6a 01                	push   $0x1
80107b59:	e8 e3 f2 ff ff       	call   80106e41 <argint>
80107b5e:	83 c4 10             	add    $0x10,%esp
80107b61:	85 c0                	test   %eax,%eax
80107b63:	79 0a                	jns    80107b6f <sys_exec+0x40>
    return -1;
80107b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b6a:	e9 c6 00 00 00       	jmp    80107c35 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107b6f:	83 ec 04             	sub    $0x4,%esp
80107b72:	68 80 00 00 00       	push   $0x80
80107b77:	6a 00                	push   $0x0
80107b79:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107b7f:	50                   	push   %eax
80107b80:	e8 97 ef ff ff       	call   80106b1c <memset>
80107b85:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b92:	83 f8 1f             	cmp    $0x1f,%eax
80107b95:	76 0a                	jbe    80107ba1 <sys_exec+0x72>
      return -1;
80107b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b9c:	e9 94 00 00 00       	jmp    80107c35 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba4:	c1 e0 02             	shl    $0x2,%eax
80107ba7:	89 c2                	mov    %eax,%edx
80107ba9:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107baf:	01 c2                	add    %eax,%edx
80107bb1:	83 ec 08             	sub    $0x8,%esp
80107bb4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107bba:	50                   	push   %eax
80107bbb:	52                   	push   %edx
80107bbc:	e8 e4 f1 ff ff       	call   80106da5 <fetchint>
80107bc1:	83 c4 10             	add    $0x10,%esp
80107bc4:	85 c0                	test   %eax,%eax
80107bc6:	79 07                	jns    80107bcf <sys_exec+0xa0>
      return -1;
80107bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bcd:	eb 66                	jmp    80107c35 <sys_exec+0x106>
    if(uarg == 0){
80107bcf:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107bd5:	85 c0                	test   %eax,%eax
80107bd7:	75 27                	jne    80107c00 <sys_exec+0xd1>
      argv[i] = 0;
80107bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bdc:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107be3:	00 00 00 00 
      break;
80107be7:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107beb:	83 ec 08             	sub    $0x8,%esp
80107bee:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107bf4:	52                   	push   %edx
80107bf5:	50                   	push   %eax
80107bf6:	e8 20 90 ff ff       	call   80100c1b <exec>
80107bfb:	83 c4 10             	add    $0x10,%esp
80107bfe:	eb 35                	jmp    80107c35 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107c00:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c09:	c1 e2 02             	shl    $0x2,%edx
80107c0c:	01 c2                	add    %eax,%edx
80107c0e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107c14:	83 ec 08             	sub    $0x8,%esp
80107c17:	52                   	push   %edx
80107c18:	50                   	push   %eax
80107c19:	e8 c1 f1 ff ff       	call   80106ddf <fetchstr>
80107c1e:	83 c4 10             	add    $0x10,%esp
80107c21:	85 c0                	test   %eax,%eax
80107c23:	79 07                	jns    80107c2c <sys_exec+0xfd>
      return -1;
80107c25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c2a:	eb 09                	jmp    80107c35 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107c2c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107c30:	e9 5a ff ff ff       	jmp    80107b8f <sys_exec+0x60>
  return exec(path, argv);
}
80107c35:	c9                   	leave  
80107c36:	c3                   	ret    

80107c37 <sys_pipe>:

int
sys_pipe(void)
{
80107c37:	55                   	push   %ebp
80107c38:	89 e5                	mov    %esp,%ebp
80107c3a:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107c3d:	83 ec 04             	sub    $0x4,%esp
80107c40:	6a 08                	push   $0x8
80107c42:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107c45:	50                   	push   %eax
80107c46:	6a 00                	push   $0x0
80107c48:	e8 1c f2 ff ff       	call   80106e69 <argptr>
80107c4d:	83 c4 10             	add    $0x10,%esp
80107c50:	85 c0                	test   %eax,%eax
80107c52:	79 0a                	jns    80107c5e <sys_pipe+0x27>
    return -1;
80107c54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c59:	e9 af 00 00 00       	jmp    80107d0d <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107c5e:	83 ec 08             	sub    $0x8,%esp
80107c61:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107c64:	50                   	push   %eax
80107c65:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107c68:	50                   	push   %eax
80107c69:	e8 ed c6 ff ff       	call   8010435b <pipealloc>
80107c6e:	83 c4 10             	add    $0x10,%esp
80107c71:	85 c0                	test   %eax,%eax
80107c73:	79 0a                	jns    80107c7f <sys_pipe+0x48>
    return -1;
80107c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c7a:	e9 8e 00 00 00       	jmp    80107d0d <sys_pipe+0xd6>
  fd0 = -1;
80107c7f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c89:	83 ec 0c             	sub    $0xc,%esp
80107c8c:	50                   	push   %eax
80107c8d:	e8 60 f3 ff ff       	call   80106ff2 <fdalloc>
80107c92:	83 c4 10             	add    $0x10,%esp
80107c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c9c:	78 18                	js     80107cb6 <sys_pipe+0x7f>
80107c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ca1:	83 ec 0c             	sub    $0xc,%esp
80107ca4:	50                   	push   %eax
80107ca5:	e8 48 f3 ff ff       	call   80106ff2 <fdalloc>
80107caa:	83 c4 10             	add    $0x10,%esp
80107cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107cb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107cb4:	79 3f                	jns    80107cf5 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107cb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107cba:	78 14                	js     80107cd0 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107cbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107cc5:	83 c2 08             	add    $0x8,%edx
80107cc8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107ccf:	00 
    fileclose(rf);
80107cd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107cd3:	83 ec 0c             	sub    $0xc,%esp
80107cd6:	50                   	push   %eax
80107cd7:	e8 ca 94 ff ff       	call   801011a6 <fileclose>
80107cdc:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107cdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ce2:	83 ec 0c             	sub    $0xc,%esp
80107ce5:	50                   	push   %eax
80107ce6:	e8 bb 94 ff ff       	call   801011a6 <fileclose>
80107ceb:	83 c4 10             	add    $0x10,%esp
    return -1;
80107cee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cf3:	eb 18                	jmp    80107d0d <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107cfb:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d00:	8d 50 04             	lea    0x4(%eax),%edx
80107d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d06:	89 02                	mov    %eax,(%edx)
  return 0;
80107d08:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d0d:	c9                   	leave  
80107d0e:	c3                   	ret    

80107d0f <sys_chmod>:

#ifdef CS333_P5
// Implementation of chmod system call
int
sys_chmod(void)
{
80107d0f:	55                   	push   %ebp
80107d10:	89 e5                	mov    %esp,%ebp
80107d12:	83 ec 18             	sub    $0x18,%esp
  char *pn;
  int md;
  
  if(argptr(0, (void*)&pn, sizeof(*pn)) < 0)
80107d15:	83 ec 04             	sub    $0x4,%esp
80107d18:	6a 01                	push   $0x1
80107d1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d1d:	50                   	push   %eax
80107d1e:	6a 00                	push   $0x0
80107d20:	e8 44 f1 ff ff       	call   80106e69 <argptr>
80107d25:	83 c4 10             	add    $0x10,%esp
80107d28:	85 c0                	test   %eax,%eax
80107d2a:	79 07                	jns    80107d33 <sys_chmod+0x24>
    return -1;
80107d2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d31:	eb 3d                	jmp    80107d70 <sys_chmod+0x61>
  if (argint(1, &md) < 0)
80107d33:	83 ec 08             	sub    $0x8,%esp
80107d36:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d39:	50                   	push   %eax
80107d3a:	6a 01                	push   $0x1
80107d3c:	e8 00 f1 ff ff       	call   80106e41 <argint>
80107d41:	83 c4 10             	add    $0x10,%esp
80107d44:	85 c0                	test   %eax,%eax
80107d46:	79 07                	jns    80107d4f <sys_chmod+0x40>
    return -1;
80107d48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d4d:	eb 21                	jmp    80107d70 <sys_chmod+0x61>
  // Error check lower bound
  if (md < 0)
80107d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d52:	85 c0                	test   %eax,%eax
80107d54:	79 07                	jns    80107d5d <sys_chmod+0x4e>
    return -1; 
80107d56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d5b:	eb 13                	jmp    80107d70 <sys_chmod+0x61>
  return chmod_helper(pn, md);
80107d5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d63:	83 ec 08             	sub    $0x8,%esp
80107d66:	52                   	push   %edx
80107d67:	50                   	push   %eax
80107d68:	e8 9f aa ff ff       	call   8010280c <chmod_helper>
80107d6d:	83 c4 10             	add    $0x10,%esp
}
80107d70:	c9                   	leave  
80107d71:	c3                   	ret    

80107d72 <sys_chown>:

// Implementation of chown system call
int
sys_chown(void)
{
80107d72:	55                   	push   %ebp
80107d73:	89 e5                	mov    %esp,%ebp
80107d75:	83 ec 18             	sub    $0x18,%esp
  char *pn;
  int owner;

  if (argptr(0, (void*)&pn, sizeof(*pn)) < 0)
80107d78:	83 ec 04             	sub    $0x4,%esp
80107d7b:	6a 01                	push   $0x1
80107d7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d80:	50                   	push   %eax
80107d81:	6a 00                	push   $0x0
80107d83:	e8 e1 f0 ff ff       	call   80106e69 <argptr>
80107d88:	83 c4 10             	add    $0x10,%esp
80107d8b:	85 c0                	test   %eax,%eax
80107d8d:	79 07                	jns    80107d96 <sys_chown+0x24>
    return -1;
80107d8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d94:	eb 47                	jmp    80107ddd <sys_chown+0x6b>
  if (argint(1, &owner) < 0) 
80107d96:	83 ec 08             	sub    $0x8,%esp
80107d99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d9c:	50                   	push   %eax
80107d9d:	6a 01                	push   $0x1
80107d9f:	e8 9d f0 ff ff       	call   80106e41 <argint>
80107da4:	83 c4 10             	add    $0x10,%esp
80107da7:	85 c0                	test   %eax,%eax
80107da9:	79 07                	jns    80107db2 <sys_chown+0x40>
    return -1;
80107dab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107db0:	eb 2b                	jmp    80107ddd <sys_chown+0x6b>
  if (owner < 0 || owner > 32767)
80107db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107db5:	85 c0                	test   %eax,%eax
80107db7:	78 0a                	js     80107dc3 <sys_chown+0x51>
80107db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dbc:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107dc1:	7e 07                	jle    80107dca <sys_chown+0x58>
    return -1;
80107dc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107dc8:	eb 13                	jmp    80107ddd <sys_chown+0x6b>
  else
    return chown_helper(pn, owner);
80107dca:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd0:	83 ec 08             	sub    $0x8,%esp
80107dd3:	52                   	push   %edx
80107dd4:	50                   	push   %eax
80107dd5:	e8 52 a9 ff ff       	call   8010272c <chown_helper>
80107dda:	83 c4 10             	add    $0x10,%esp
}
80107ddd:	c9                   	leave  
80107dde:	c3                   	ret    

80107ddf <sys_chgrp>:

// Implementation of chgrp system call
int
sys_chgrp(void)
{
80107ddf:	55                   	push   %ebp
80107de0:	89 e5                	mov    %esp,%ebp
80107de2:	83 ec 18             	sub    $0x18,%esp
  char *pn;
  int owner;

  if (argptr(0, (void*)&pn, sizeof(*pn)) < 0)
80107de5:	83 ec 04             	sub    $0x4,%esp
80107de8:	6a 01                	push   $0x1
80107dea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107ded:	50                   	push   %eax
80107dee:	6a 00                	push   $0x0
80107df0:	e8 74 f0 ff ff       	call   80106e69 <argptr>
80107df5:	83 c4 10             	add    $0x10,%esp
80107df8:	85 c0                	test   %eax,%eax
80107dfa:	79 07                	jns    80107e03 <sys_chgrp+0x24>
    return -1;
80107dfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e01:	eb 47                	jmp    80107e4a <sys_chgrp+0x6b>
  if (argint(1, &owner) < 0)
80107e03:	83 ec 08             	sub    $0x8,%esp
80107e06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107e09:	50                   	push   %eax
80107e0a:	6a 01                	push   $0x1
80107e0c:	e8 30 f0 ff ff       	call   80106e41 <argint>
80107e11:	83 c4 10             	add    $0x10,%esp
80107e14:	85 c0                	test   %eax,%eax
80107e16:	79 07                	jns    80107e1f <sys_chgrp+0x40>
    return -1;
80107e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e1d:	eb 2b                	jmp    80107e4a <sys_chgrp+0x6b>
  if (owner < 0 || owner > 32767)
80107e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e22:	85 c0                	test   %eax,%eax
80107e24:	78 0a                	js     80107e30 <sys_chgrp+0x51>
80107e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e29:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107e2e:	7e 07                	jle    80107e37 <sys_chgrp+0x58>
    return -1;
80107e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e35:	eb 13                	jmp    80107e4a <sys_chgrp+0x6b>
  else
    return chgrp_helper(pn, owner);
80107e37:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3d:	83 ec 08             	sub    $0x8,%esp
80107e40:	52                   	push   %edx
80107e41:	50                   	push   %eax
80107e42:	e8 55 a9 ff ff       	call   8010279c <chgrp_helper>
80107e47:	83 c4 10             	add    $0x10,%esp
}
80107e4a:	c9                   	leave  
80107e4b:	c3                   	ret    

80107e4c <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107e4c:	55                   	push   %ebp
80107e4d:	89 e5                	mov    %esp,%ebp
80107e4f:	83 ec 08             	sub    $0x8,%esp
80107e52:	8b 55 08             	mov    0x8(%ebp),%edx
80107e55:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e58:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107e5c:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107e60:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107e64:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107e68:	66 ef                	out    %ax,(%dx)
}
80107e6a:	90                   	nop
80107e6b:	c9                   	leave  
80107e6c:	c3                   	ret    

80107e6d <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
80107e6d:	55                   	push   %ebp
80107e6e:	89 e5                	mov    %esp,%ebp
80107e70:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107e73:	e8 cf cd ff ff       	call   80104c47 <fork>
}
80107e78:	c9                   	leave  
80107e79:	c3                   	ret    

80107e7a <sys_exit>:

int
sys_exit(void)
{
80107e7a:	55                   	push   %ebp
80107e7b:	89 e5                	mov    %esp,%ebp
80107e7d:	83 ec 08             	sub    $0x8,%esp
  exit();
80107e80:	e8 38 d0 ff ff       	call   80104ebd <exit>
  return 0;  // not reached
80107e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e8a:	c9                   	leave  
80107e8b:	c3                   	ret    

80107e8c <sys_wait>:

int
sys_wait(void)
{
80107e8c:	55                   	push   %ebp
80107e8d:	89 e5                	mov    %esp,%ebp
80107e8f:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107e92:	e8 ff d1 ff ff       	call   80105096 <wait>
}
80107e97:	c9                   	leave  
80107e98:	c3                   	ret    

80107e99 <sys_kill>:

int
sys_kill(void)
{
80107e99:	55                   	push   %ebp
80107e9a:	89 e5                	mov    %esp,%ebp
80107e9c:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107e9f:	83 ec 08             	sub    $0x8,%esp
80107ea2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107ea5:	50                   	push   %eax
80107ea6:	6a 00                	push   $0x0
80107ea8:	e8 94 ef ff ff       	call   80106e41 <argint>
80107ead:	83 c4 10             	add    $0x10,%esp
80107eb0:	85 c0                	test   %eax,%eax
80107eb2:	79 07                	jns    80107ebb <sys_kill+0x22>
    return -1;
80107eb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107eb9:	eb 0f                	jmp    80107eca <sys_kill+0x31>
  return kill(pid);
80107ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebe:	83 ec 0c             	sub    $0xc,%esp
80107ec1:	50                   	push   %eax
80107ec2:	e8 74 d9 ff ff       	call   8010583b <kill>
80107ec7:	83 c4 10             	add    $0x10,%esp
}
80107eca:	c9                   	leave  
80107ecb:	c3                   	ret    

80107ecc <sys_getpid>:

int
sys_getpid(void)
{
80107ecc:	55                   	push   %ebp
80107ecd:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107ecf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ed5:	8b 40 10             	mov    0x10(%eax),%eax
}
80107ed8:	5d                   	pop    %ebp
80107ed9:	c3                   	ret    

80107eda <sys_sbrk>:

int
sys_sbrk(void)
{
80107eda:	55                   	push   %ebp
80107edb:	89 e5                	mov    %esp,%ebp
80107edd:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107ee0:	83 ec 08             	sub    $0x8,%esp
80107ee3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107ee6:	50                   	push   %eax
80107ee7:	6a 00                	push   $0x0
80107ee9:	e8 53 ef ff ff       	call   80106e41 <argint>
80107eee:	83 c4 10             	add    $0x10,%esp
80107ef1:	85 c0                	test   %eax,%eax
80107ef3:	79 07                	jns    80107efc <sys_sbrk+0x22>
    return -1;
80107ef5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107efa:	eb 28                	jmp    80107f24 <sys_sbrk+0x4a>
  addr = proc->sz;
80107efc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f02:	8b 00                	mov    (%eax),%eax
80107f04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f0a:	83 ec 0c             	sub    $0xc,%esp
80107f0d:	50                   	push   %eax
80107f0e:	e8 91 cc ff ff       	call   80104ba4 <growproc>
80107f13:	83 c4 10             	add    $0x10,%esp
80107f16:	85 c0                	test   %eax,%eax
80107f18:	79 07                	jns    80107f21 <sys_sbrk+0x47>
    return -1;
80107f1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f1f:	eb 03                	jmp    80107f24 <sys_sbrk+0x4a>
  return addr;
80107f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107f24:	c9                   	leave  
80107f25:	c3                   	ret    

80107f26 <sys_sleep>:

int
sys_sleep(void)
{
80107f26:	55                   	push   %ebp
80107f27:	89 e5                	mov    %esp,%ebp
80107f29:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107f2c:	83 ec 08             	sub    $0x8,%esp
80107f2f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107f32:	50                   	push   %eax
80107f33:	6a 00                	push   $0x0
80107f35:	e8 07 ef ff ff       	call   80106e41 <argint>
80107f3a:	83 c4 10             	add    $0x10,%esp
80107f3d:	85 c0                	test   %eax,%eax
80107f3f:	79 07                	jns    80107f48 <sys_sleep+0x22>
    return -1;
80107f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f46:	eb 44                	jmp    80107f8c <sys_sleep+0x66>
  ticks0 = ticks;
80107f48:	a1 20 79 11 80       	mov    0x80117920,%eax
80107f4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107f50:	eb 26                	jmp    80107f78 <sys_sleep+0x52>
    if(proc->killed){
80107f52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f58:	8b 40 24             	mov    0x24(%eax),%eax
80107f5b:	85 c0                	test   %eax,%eax
80107f5d:	74 07                	je     80107f66 <sys_sleep+0x40>
      return -1;
80107f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f64:	eb 26                	jmp    80107f8c <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107f66:	83 ec 08             	sub    $0x8,%esp
80107f69:	6a 00                	push   $0x0
80107f6b:	68 20 79 11 80       	push   $0x80117920
80107f70:	e8 b6 d6 ff ff       	call   8010562b <sleep>
80107f75:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107f78:	a1 20 79 11 80       	mov    0x80117920,%eax
80107f7d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107f80:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107f83:	39 d0                	cmp    %edx,%eax
80107f85:	72 cb                	jb     80107f52 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f8c:	c9                   	leave  
80107f8d:	c3                   	ret    

80107f8e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80107f8e:	55                   	push   %ebp
80107f8f:	89 e5                	mov    %esp,%ebp
80107f91:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107f94:	a1 20 79 11 80       	mov    0x80117920,%eax
80107f99:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107f9f:	c9                   	leave  
80107fa0:	c3                   	ret    

80107fa1 <sys_halt>:

//Turn of the computer
int sys_halt(void){
80107fa1:	55                   	push   %ebp
80107fa2:	89 e5                	mov    %esp,%ebp
80107fa4:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107fa7:	83 ec 0c             	sub    $0xc,%esp
80107faa:	68 4d a7 10 80       	push   $0x8010a74d
80107faf:	e8 12 84 ff ff       	call   801003c6 <cprintf>
80107fb4:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
80107fb7:	83 ec 08             	sub    $0x8,%esp
80107fba:	68 00 20 00 00       	push   $0x2000
80107fbf:	68 04 06 00 00       	push   $0x604
80107fc4:	e8 83 fe ff ff       	call   80107e4c <outw>
80107fc9:	83 c4 10             	add    $0x10,%esp
  return 0;
80107fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fd1:	c9                   	leave  
80107fd2:	c3                   	ret    

80107fd3 <sys_date>:

// My implementation of sys_date()
int
sys_date(void)
{
80107fd3:	55                   	push   %ebp
80107fd4:	89 e5                	mov    %esp,%ebp
80107fd6:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if (argptr(0, (void*)&d, sizeof(*d)) < 0)
80107fd9:	83 ec 04             	sub    $0x4,%esp
80107fdc:	6a 18                	push   $0x18
80107fde:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107fe1:	50                   	push   %eax
80107fe2:	6a 00                	push   $0x0
80107fe4:	e8 80 ee ff ff       	call   80106e69 <argptr>
80107fe9:	83 c4 10             	add    $0x10,%esp
80107fec:	85 c0                	test   %eax,%eax
80107fee:	79 07                	jns    80107ff7 <sys_date+0x24>
    return -1;
80107ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ff5:	eb 14                	jmp    8010800b <sys_date+0x38>
  // MY CODE HERE
  cmostime(d);       
80107ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffa:	83 ec 0c             	sub    $0xc,%esp
80107ffd:	50                   	push   %eax
80107ffe:	e8 df b4 ff ff       	call   801034e2 <cmostime>
80108003:	83 c4 10             	add    $0x10,%esp
  return 0; 
80108006:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010800b:	c9                   	leave  
8010800c:	c3                   	ret    

8010800d <sys_getuid>:

// My implementation of sys_getuid
uint
sys_getuid(void)
{
8010800d:	55                   	push   %ebp
8010800e:	89 e5                	mov    %esp,%ebp
  return proc->uid;
80108010:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108016:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
8010801c:	5d                   	pop    %ebp
8010801d:	c3                   	ret    

8010801e <sys_getgid>:

// My implementation of sys_getgid
uint
sys_getgid(void)
{
8010801e:	55                   	push   %ebp
8010801f:	89 e5                	mov    %esp,%ebp
  return proc->gid;
80108021:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108027:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
8010802d:	5d                   	pop    %ebp
8010802e:	c3                   	ret    

8010802f <sys_getppid>:

// My implementation of sys_getppid
uint
sys_getppid(void)
{
8010802f:	55                   	push   %ebp
80108030:	89 e5                	mov    %esp,%ebp
  return proc->parent ? proc->parent->pid : proc->pid;
80108032:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108038:	8b 40 14             	mov    0x14(%eax),%eax
8010803b:	85 c0                	test   %eax,%eax
8010803d:	74 0e                	je     8010804d <sys_getppid+0x1e>
8010803f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108045:	8b 40 14             	mov    0x14(%eax),%eax
80108048:	8b 40 10             	mov    0x10(%eax),%eax
8010804b:	eb 09                	jmp    80108056 <sys_getppid+0x27>
8010804d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108053:	8b 40 10             	mov    0x10(%eax),%eax
}
80108056:	5d                   	pop    %ebp
80108057:	c3                   	ret    

80108058 <sys_setuid>:


// Implementation of sys_setuid
int 
sys_setuid(void)
{
80108058:	55                   	push   %ebp
80108059:	89 e5                	mov    %esp,%ebp
8010805b:	83 ec 18             	sub    $0x18,%esp
  int id; // uid argument
  // Grab argument off the stack and store in id
  argint(0, &id);
8010805e:	83 ec 08             	sub    $0x8,%esp
80108061:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108064:	50                   	push   %eax
80108065:	6a 00                	push   $0x0
80108067:	e8 d5 ed ff ff       	call   80106e41 <argint>
8010806c:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
8010806f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108072:	85 c0                	test   %eax,%eax
80108074:	78 0a                	js     80108080 <sys_setuid+0x28>
80108076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108079:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010807e:	7e 07                	jle    80108087 <sys_setuid+0x2f>
    return -1;
80108080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108085:	eb 14                	jmp    8010809b <sys_setuid+0x43>
  proc->uid = id; 
80108087:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010808d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108090:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80108096:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010809b:	c9                   	leave  
8010809c:	c3                   	ret    

8010809d <sys_setgid>:

// Implementation of sys_setgid
int
sys_setgid(void)
{
8010809d:	55                   	push   %ebp
8010809e:	89 e5                	mov    %esp,%ebp
801080a0:	83 ec 18             	sub    $0x18,%esp
  int id; // gid argument 
  // Grab argument off the stack and store in id
  argint(0, &id);
801080a3:	83 ec 08             	sub    $0x8,%esp
801080a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801080a9:	50                   	push   %eax
801080aa:	6a 00                	push   $0x0
801080ac:	e8 90 ed ff ff       	call   80106e41 <argint>
801080b1:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
801080b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b7:	85 c0                	test   %eax,%eax
801080b9:	78 0a                	js     801080c5 <sys_setgid+0x28>
801080bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080be:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801080c3:	7e 07                	jle    801080cc <sys_setgid+0x2f>
    return -1;
801080c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080ca:	eb 14                	jmp    801080e0 <sys_setgid+0x43>
  proc->gid = id;
801080cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801080d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801080d5:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  return 0;
801080db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080e0:	c9                   	leave  
801080e1:	c3                   	ret    

801080e2 <sys_getprocs>:

// Implementation of sys_getprocs
int
sys_getprocs(void)
{
801080e2:	55                   	push   %ebp
801080e3:	89 e5                	mov    %esp,%ebp
801080e5:	83 ec 18             	sub    $0x18,%esp
  int m; // Max arg
  struct uproc* table;
  argint(0, &m);
801080e8:	83 ec 08             	sub    $0x8,%esp
801080eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801080ee:	50                   	push   %eax
801080ef:	6a 00                	push   $0x0
801080f1:	e8 4b ed ff ff       	call   80106e41 <argint>
801080f6:	83 c4 10             	add    $0x10,%esp
  if (m < 0)
801080f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fc:	85 c0                	test   %eax,%eax
801080fe:	79 07                	jns    80108107 <sys_getprocs+0x25>
    return -1;
80108100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108105:	eb 28                	jmp    8010812f <sys_getprocs+0x4d>
  argptr(1, (void*)&table, m);
80108107:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810a:	83 ec 04             	sub    $0x4,%esp
8010810d:	50                   	push   %eax
8010810e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80108111:	50                   	push   %eax
80108112:	6a 01                	push   $0x1
80108114:	e8 50 ed ff ff       	call   80106e69 <argptr>
80108119:	83 c4 10             	add    $0x10,%esp
  return getproc_helper(m, table);
8010811c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010811f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108122:	83 ec 08             	sub    $0x8,%esp
80108125:	52                   	push   %edx
80108126:	50                   	push   %eax
80108127:	e8 60 db ff ff       	call   80105c8c <getproc_helper>
8010812c:	83 c4 10             	add    $0x10,%esp
}
8010812f:	c9                   	leave  
80108130:	c3                   	ret    

80108131 <sys_setpriority>:

#ifdef CS333_P3P4
// Implementation of sys_setpriority
int
sys_setpriority(void)
{
80108131:	55                   	push   %ebp
80108132:	89 e5                	mov    %esp,%ebp
80108134:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int prio;

  argint(0, &pid);
80108137:	83 ec 08             	sub    $0x8,%esp
8010813a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010813d:	50                   	push   %eax
8010813e:	6a 00                	push   $0x0
80108140:	e8 fc ec ff ff       	call   80106e41 <argint>
80108145:	83 c4 10             	add    $0x10,%esp
  argint(1, &prio);
80108148:	83 ec 08             	sub    $0x8,%esp
8010814b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010814e:	50                   	push   %eax
8010814f:	6a 01                	push   $0x1
80108151:	e8 eb ec ff ff       	call   80106e41 <argint>
80108156:	83 c4 10             	add    $0x10,%esp
  return set_priority(pid, prio);
80108159:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010815c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815f:	83 ec 08             	sub    $0x8,%esp
80108162:	52                   	push   %edx
80108163:	50                   	push   %eax
80108164:	e8 d7 e2 ff ff       	call   80106440 <set_priority>
80108169:	83 c4 10             	add    $0x10,%esp
}
8010816c:	c9                   	leave  
8010816d:	c3                   	ret    

8010816e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010816e:	55                   	push   %ebp
8010816f:	89 e5                	mov    %esp,%ebp
80108171:	83 ec 08             	sub    $0x8,%esp
80108174:	8b 55 08             	mov    0x8(%ebp),%edx
80108177:	8b 45 0c             	mov    0xc(%ebp),%eax
8010817a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010817e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108181:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108185:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108189:	ee                   	out    %al,(%dx)
}
8010818a:	90                   	nop
8010818b:	c9                   	leave  
8010818c:	c3                   	ret    

8010818d <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010818d:	55                   	push   %ebp
8010818e:	89 e5                	mov    %esp,%ebp
80108190:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80108193:	6a 34                	push   $0x34
80108195:	6a 43                	push   $0x43
80108197:	e8 d2 ff ff ff       	call   8010816e <outb>
8010819c:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
8010819f:	68 9c 00 00 00       	push   $0x9c
801081a4:	6a 40                	push   $0x40
801081a6:	e8 c3 ff ff ff       	call   8010816e <outb>
801081ab:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801081ae:	6a 2e                	push   $0x2e
801081b0:	6a 40                	push   $0x40
801081b2:	e8 b7 ff ff ff       	call   8010816e <outb>
801081b7:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801081ba:	83 ec 0c             	sub    $0xc,%esp
801081bd:	6a 00                	push   $0x0
801081bf:	e8 81 c0 ff ff       	call   80104245 <picenable>
801081c4:	83 c4 10             	add    $0x10,%esp
}
801081c7:	90                   	nop
801081c8:	c9                   	leave  
801081c9:	c3                   	ret    

801081ca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801081ca:	1e                   	push   %ds
  pushl %es
801081cb:	06                   	push   %es
  pushl %fs
801081cc:	0f a0                	push   %fs
  pushl %gs
801081ce:	0f a8                	push   %gs
  pushal
801081d0:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801081d1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801081d5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801081d7:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801081d9:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801081dd:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801081df:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801081e1:	54                   	push   %esp
  call trap
801081e2:	e8 ce 01 00 00       	call   801083b5 <trap>
  addl $4, %esp
801081e7:	83 c4 04             	add    $0x4,%esp

801081ea <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801081ea:	61                   	popa   
  popl %gs
801081eb:	0f a9                	pop    %gs
  popl %fs
801081ed:	0f a1                	pop    %fs
  popl %es
801081ef:	07                   	pop    %es
  popl %ds
801081f0:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801081f1:	83 c4 08             	add    $0x8,%esp
  iret
801081f4:	cf                   	iret   

801081f5 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
801081f5:	55                   	push   %ebp
801081f6:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
801081f8:	8b 45 08             	mov    0x8(%ebp),%eax
801081fb:	f0 ff 00             	lock incl (%eax)
}
801081fe:	90                   	nop
801081ff:	5d                   	pop    %ebp
80108200:	c3                   	ret    

80108201 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80108201:	55                   	push   %ebp
80108202:	89 e5                	mov    %esp,%ebp
80108204:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108207:	8b 45 0c             	mov    0xc(%ebp),%eax
8010820a:	83 e8 01             	sub    $0x1,%eax
8010820d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108211:	8b 45 08             	mov    0x8(%ebp),%eax
80108214:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108218:	8b 45 08             	mov    0x8(%ebp),%eax
8010821b:	c1 e8 10             	shr    $0x10,%eax
8010821e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80108222:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108225:	0f 01 18             	lidtl  (%eax)
}
80108228:	90                   	nop
80108229:	c9                   	leave  
8010822a:	c3                   	ret    

8010822b <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010822b:	55                   	push   %ebp
8010822c:	89 e5                	mov    %esp,%ebp
8010822e:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108231:	0f 20 d0             	mov    %cr2,%eax
80108234:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80108237:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010823a:	c9                   	leave  
8010823b:	c3                   	ret    

8010823c <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
8010823c:	55                   	push   %ebp
8010823d:	89 e5                	mov    %esp,%ebp
8010823f:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80108242:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80108249:	e9 c3 00 00 00       	jmp    80108311 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010824e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108251:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
80108258:	89 c2                	mov    %eax,%edx
8010825a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010825d:	66 89 14 c5 20 71 11 	mov    %dx,-0x7fee8ee0(,%eax,8)
80108264:	80 
80108265:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108268:	66 c7 04 c5 22 71 11 	movw   $0x8,-0x7fee8ede(,%eax,8)
8010826f:	80 08 00 
80108272:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108275:	0f b6 14 c5 24 71 11 	movzbl -0x7fee8edc(,%eax,8),%edx
8010827c:	80 
8010827d:	83 e2 e0             	and    $0xffffffe0,%edx
80108280:	88 14 c5 24 71 11 80 	mov    %dl,-0x7fee8edc(,%eax,8)
80108287:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010828a:	0f b6 14 c5 24 71 11 	movzbl -0x7fee8edc(,%eax,8),%edx
80108291:	80 
80108292:	83 e2 1f             	and    $0x1f,%edx
80108295:	88 14 c5 24 71 11 80 	mov    %dl,-0x7fee8edc(,%eax,8)
8010829c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010829f:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
801082a6:	80 
801082a7:	83 e2 f0             	and    $0xfffffff0,%edx
801082aa:	83 ca 0e             	or     $0xe,%edx
801082ad:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
801082b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082b7:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
801082be:	80 
801082bf:	83 e2 ef             	and    $0xffffffef,%edx
801082c2:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
801082c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082cc:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
801082d3:	80 
801082d4:	83 e2 9f             	and    $0xffffff9f,%edx
801082d7:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
801082de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082e1:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
801082e8:	80 
801082e9:	83 ca 80             	or     $0xffffff80,%edx
801082ec:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
801082f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082f6:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
801082fd:	c1 e8 10             	shr    $0x10,%eax
80108300:	89 c2                	mov    %eax,%edx
80108302:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108305:	66 89 14 c5 26 71 11 	mov    %dx,-0x7fee8eda(,%eax,8)
8010830c:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010830d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80108311:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80108318:	0f 8e 30 ff ff ff    	jle    8010824e <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010831e:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
80108323:	66 a3 20 73 11 80    	mov    %ax,0x80117320
80108329:	66 c7 05 22 73 11 80 	movw   $0x8,0x80117322
80108330:	08 00 
80108332:	0f b6 05 24 73 11 80 	movzbl 0x80117324,%eax
80108339:	83 e0 e0             	and    $0xffffffe0,%eax
8010833c:	a2 24 73 11 80       	mov    %al,0x80117324
80108341:	0f b6 05 24 73 11 80 	movzbl 0x80117324,%eax
80108348:	83 e0 1f             	and    $0x1f,%eax
8010834b:	a2 24 73 11 80       	mov    %al,0x80117324
80108350:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108357:	83 c8 0f             	or     $0xf,%eax
8010835a:	a2 25 73 11 80       	mov    %al,0x80117325
8010835f:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108366:	83 e0 ef             	and    $0xffffffef,%eax
80108369:	a2 25 73 11 80       	mov    %al,0x80117325
8010836e:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108375:	83 c8 60             	or     $0x60,%eax
80108378:	a2 25 73 11 80       	mov    %al,0x80117325
8010837d:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108384:	83 c8 80             	or     $0xffffff80,%eax
80108387:	a2 25 73 11 80       	mov    %al,0x80117325
8010838c:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
80108391:	c1 e8 10             	shr    $0x10,%eax
80108394:	66 a3 26 73 11 80    	mov    %ax,0x80117326
  
}
8010839a:	90                   	nop
8010839b:	c9                   	leave  
8010839c:	c3                   	ret    

8010839d <idtinit>:

void
idtinit(void)
{
8010839d:	55                   	push   %ebp
8010839e:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801083a0:	68 00 08 00 00       	push   $0x800
801083a5:	68 20 71 11 80       	push   $0x80117120
801083aa:	e8 52 fe ff ff       	call   80108201 <lidt>
801083af:	83 c4 08             	add    $0x8,%esp
}
801083b2:	90                   	nop
801083b3:	c9                   	leave  
801083b4:	c3                   	ret    

801083b5 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801083b5:	55                   	push   %ebp
801083b6:	89 e5                	mov    %esp,%ebp
801083b8:	57                   	push   %edi
801083b9:	56                   	push   %esi
801083ba:	53                   	push   %ebx
801083bb:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801083be:	8b 45 08             	mov    0x8(%ebp),%eax
801083c1:	8b 40 30             	mov    0x30(%eax),%eax
801083c4:	83 f8 40             	cmp    $0x40,%eax
801083c7:	75 3e                	jne    80108407 <trap+0x52>
    if(proc->killed)
801083c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083cf:	8b 40 24             	mov    0x24(%eax),%eax
801083d2:	85 c0                	test   %eax,%eax
801083d4:	74 05                	je     801083db <trap+0x26>
      exit();
801083d6:	e8 e2 ca ff ff       	call   80104ebd <exit>
    proc->tf = tf;
801083db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083e1:	8b 55 08             	mov    0x8(%ebp),%edx
801083e4:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801083e7:	e8 0b eb ff ff       	call   80106ef7 <syscall>
    if(proc->killed)
801083ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083f2:	8b 40 24             	mov    0x24(%eax),%eax
801083f5:	85 c0                	test   %eax,%eax
801083f7:	0f 84 fe 01 00 00    	je     801085fb <trap+0x246>
      exit();
801083fd:	e8 bb ca ff ff       	call   80104ebd <exit>
    return;
80108402:	e9 f4 01 00 00       	jmp    801085fb <trap+0x246>
  }

  switch(tf->trapno){
80108407:	8b 45 08             	mov    0x8(%ebp),%eax
8010840a:	8b 40 30             	mov    0x30(%eax),%eax
8010840d:	83 e8 20             	sub    $0x20,%eax
80108410:	83 f8 1f             	cmp    $0x1f,%eax
80108413:	0f 87 a3 00 00 00    	ja     801084bc <trap+0x107>
80108419:	8b 04 85 00 a8 10 80 	mov    -0x7fef5800(,%eax,4),%eax
80108420:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80108422:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108428:	0f b6 00             	movzbl (%eax),%eax
8010842b:	84 c0                	test   %al,%al
8010842d:	75 20                	jne    8010844f <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
8010842f:	83 ec 0c             	sub    $0xc,%esp
80108432:	68 20 79 11 80       	push   $0x80117920
80108437:	e8 b9 fd ff ff       	call   801081f5 <atom_inc>
8010843c:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
8010843f:	83 ec 0c             	sub    $0xc,%esp
80108442:	68 20 79 11 80       	push   $0x80117920
80108447:	e8 b8 d3 ff ff       	call   80105804 <wakeup>
8010844c:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010844f:	e8 eb ae ff ff       	call   8010333f <lapiceoi>
    break;
80108454:	e9 1c 01 00 00       	jmp    80108575 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80108459:	e8 f4 a6 ff ff       	call   80102b52 <ideintr>
    lapiceoi();
8010845e:	e8 dc ae ff ff       	call   8010333f <lapiceoi>
    break;
80108463:	e9 0d 01 00 00       	jmp    80108575 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80108468:	e8 d4 ac ff ff       	call   80103141 <kbdintr>
    lapiceoi();
8010846d:	e8 cd ae ff ff       	call   8010333f <lapiceoi>
    break;
80108472:	e9 fe 00 00 00       	jmp    80108575 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80108477:	e8 60 03 00 00       	call   801087dc <uartintr>
    lapiceoi();
8010847c:	e8 be ae ff ff       	call   8010333f <lapiceoi>
    break;
80108481:	e9 ef 00 00 00       	jmp    80108575 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108486:	8b 45 08             	mov    0x8(%ebp),%eax
80108489:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010848c:	8b 45 08             	mov    0x8(%ebp),%eax
8010848f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108493:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80108496:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010849c:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010849f:	0f b6 c0             	movzbl %al,%eax
801084a2:	51                   	push   %ecx
801084a3:	52                   	push   %edx
801084a4:	50                   	push   %eax
801084a5:	68 60 a7 10 80       	push   $0x8010a760
801084aa:	e8 17 7f ff ff       	call   801003c6 <cprintf>
801084af:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801084b2:	e8 88 ae ff ff       	call   8010333f <lapiceoi>
    break;
801084b7:	e9 b9 00 00 00       	jmp    80108575 <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801084bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801084c2:	85 c0                	test   %eax,%eax
801084c4:	74 11                	je     801084d7 <trap+0x122>
801084c6:	8b 45 08             	mov    0x8(%ebp),%eax
801084c9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801084cd:	0f b7 c0             	movzwl %ax,%eax
801084d0:	83 e0 03             	and    $0x3,%eax
801084d3:	85 c0                	test   %eax,%eax
801084d5:	75 40                	jne    80108517 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801084d7:	e8 4f fd ff ff       	call   8010822b <rcr2>
801084dc:	89 c3                	mov    %eax,%ebx
801084de:	8b 45 08             	mov    0x8(%ebp),%eax
801084e1:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801084e4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084ea:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801084ed:	0f b6 d0             	movzbl %al,%edx
801084f0:	8b 45 08             	mov    0x8(%ebp),%eax
801084f3:	8b 40 30             	mov    0x30(%eax),%eax
801084f6:	83 ec 0c             	sub    $0xc,%esp
801084f9:	53                   	push   %ebx
801084fa:	51                   	push   %ecx
801084fb:	52                   	push   %edx
801084fc:	50                   	push   %eax
801084fd:	68 84 a7 10 80       	push   $0x8010a784
80108502:	e8 bf 7e ff ff       	call   801003c6 <cprintf>
80108507:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010850a:	83 ec 0c             	sub    $0xc,%esp
8010850d:	68 b6 a7 10 80       	push   $0x8010a7b6
80108512:	e8 4f 80 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108517:	e8 0f fd ff ff       	call   8010822b <rcr2>
8010851c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010851f:	8b 45 08             	mov    0x8(%ebp),%eax
80108522:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80108525:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010852b:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010852e:	0f b6 d8             	movzbl %al,%ebx
80108531:	8b 45 08             	mov    0x8(%ebp),%eax
80108534:	8b 48 34             	mov    0x34(%eax),%ecx
80108537:	8b 45 08             	mov    0x8(%ebp),%eax
8010853a:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010853d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108543:	8d 78 6c             	lea    0x6c(%eax),%edi
80108546:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010854c:	8b 40 10             	mov    0x10(%eax),%eax
8010854f:	ff 75 e4             	pushl  -0x1c(%ebp)
80108552:	56                   	push   %esi
80108553:	53                   	push   %ebx
80108554:	51                   	push   %ecx
80108555:	52                   	push   %edx
80108556:	57                   	push   %edi
80108557:	50                   	push   %eax
80108558:	68 bc a7 10 80       	push   $0x8010a7bc
8010855d:	e8 64 7e ff ff       	call   801003c6 <cprintf>
80108562:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80108565:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010856b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80108572:	eb 01                	jmp    80108575 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80108574:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80108575:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010857b:	85 c0                	test   %eax,%eax
8010857d:	74 24                	je     801085a3 <trap+0x1ee>
8010857f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108585:	8b 40 24             	mov    0x24(%eax),%eax
80108588:	85 c0                	test   %eax,%eax
8010858a:	74 17                	je     801085a3 <trap+0x1ee>
8010858c:	8b 45 08             	mov    0x8(%ebp),%eax
8010858f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108593:	0f b7 c0             	movzwl %ax,%eax
80108596:	83 e0 03             	and    $0x3,%eax
80108599:	83 f8 03             	cmp    $0x3,%eax
8010859c:	75 05                	jne    801085a3 <trap+0x1ee>
    exit();
8010859e:	e8 1a c9 ff ff       	call   80104ebd <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801085a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085a9:	85 c0                	test   %eax,%eax
801085ab:	74 1e                	je     801085cb <trap+0x216>
801085ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085b3:	8b 40 0c             	mov    0xc(%eax),%eax
801085b6:	83 f8 04             	cmp    $0x4,%eax
801085b9:	75 10                	jne    801085cb <trap+0x216>
801085bb:	8b 45 08             	mov    0x8(%ebp),%eax
801085be:	8b 40 30             	mov    0x30(%eax),%eax
801085c1:	83 f8 20             	cmp    $0x20,%eax
801085c4:	75 05                	jne    801085cb <trap+0x216>
    yield();
801085c6:	e8 1d cf ff ff       	call   801054e8 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801085cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085d1:	85 c0                	test   %eax,%eax
801085d3:	74 27                	je     801085fc <trap+0x247>
801085d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085db:	8b 40 24             	mov    0x24(%eax),%eax
801085de:	85 c0                	test   %eax,%eax
801085e0:	74 1a                	je     801085fc <trap+0x247>
801085e2:	8b 45 08             	mov    0x8(%ebp),%eax
801085e5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801085e9:	0f b7 c0             	movzwl %ax,%eax
801085ec:	83 e0 03             	and    $0x3,%eax
801085ef:	83 f8 03             	cmp    $0x3,%eax
801085f2:	75 08                	jne    801085fc <trap+0x247>
    exit();
801085f4:	e8 c4 c8 ff ff       	call   80104ebd <exit>
801085f9:	eb 01                	jmp    801085fc <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801085fb:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801085fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085ff:	5b                   	pop    %ebx
80108600:	5e                   	pop    %esi
80108601:	5f                   	pop    %edi
80108602:	5d                   	pop    %ebp
80108603:	c3                   	ret    

80108604 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80108604:	55                   	push   %ebp
80108605:	89 e5                	mov    %esp,%ebp
80108607:	83 ec 14             	sub    $0x14,%esp
8010860a:	8b 45 08             	mov    0x8(%ebp),%eax
8010860d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80108611:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80108615:	89 c2                	mov    %eax,%edx
80108617:	ec                   	in     (%dx),%al
80108618:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010861b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010861f:	c9                   	leave  
80108620:	c3                   	ret    

80108621 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80108621:	55                   	push   %ebp
80108622:	89 e5                	mov    %esp,%ebp
80108624:	83 ec 08             	sub    $0x8,%esp
80108627:	8b 55 08             	mov    0x8(%ebp),%edx
8010862a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010862d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80108631:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108634:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108638:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010863c:	ee                   	out    %al,(%dx)
}
8010863d:	90                   	nop
8010863e:	c9                   	leave  
8010863f:	c3                   	ret    

80108640 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80108640:	55                   	push   %ebp
80108641:	89 e5                	mov    %esp,%ebp
80108643:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80108646:	6a 00                	push   $0x0
80108648:	68 fa 03 00 00       	push   $0x3fa
8010864d:	e8 cf ff ff ff       	call   80108621 <outb>
80108652:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80108655:	68 80 00 00 00       	push   $0x80
8010865a:	68 fb 03 00 00       	push   $0x3fb
8010865f:	e8 bd ff ff ff       	call   80108621 <outb>
80108664:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80108667:	6a 0c                	push   $0xc
80108669:	68 f8 03 00 00       	push   $0x3f8
8010866e:	e8 ae ff ff ff       	call   80108621 <outb>
80108673:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80108676:	6a 00                	push   $0x0
80108678:	68 f9 03 00 00       	push   $0x3f9
8010867d:	e8 9f ff ff ff       	call   80108621 <outb>
80108682:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80108685:	6a 03                	push   $0x3
80108687:	68 fb 03 00 00       	push   $0x3fb
8010868c:	e8 90 ff ff ff       	call   80108621 <outb>
80108691:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80108694:	6a 00                	push   $0x0
80108696:	68 fc 03 00 00       	push   $0x3fc
8010869b:	e8 81 ff ff ff       	call   80108621 <outb>
801086a0:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801086a3:	6a 01                	push   $0x1
801086a5:	68 f9 03 00 00       	push   $0x3f9
801086aa:	e8 72 ff ff ff       	call   80108621 <outb>
801086af:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801086b2:	68 fd 03 00 00       	push   $0x3fd
801086b7:	e8 48 ff ff ff       	call   80108604 <inb>
801086bc:	83 c4 04             	add    $0x4,%esp
801086bf:	3c ff                	cmp    $0xff,%al
801086c1:	74 6e                	je     80108731 <uartinit+0xf1>
    return;
  uart = 1;
801086c3:	c7 05 8c d6 10 80 01 	movl   $0x1,0x8010d68c
801086ca:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801086cd:	68 fa 03 00 00       	push   $0x3fa
801086d2:	e8 2d ff ff ff       	call   80108604 <inb>
801086d7:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801086da:	68 f8 03 00 00       	push   $0x3f8
801086df:	e8 20 ff ff ff       	call   80108604 <inb>
801086e4:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801086e7:	83 ec 0c             	sub    $0xc,%esp
801086ea:	6a 04                	push   $0x4
801086ec:	e8 54 bb ff ff       	call   80104245 <picenable>
801086f1:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801086f4:	83 ec 08             	sub    $0x8,%esp
801086f7:	6a 00                	push   $0x0
801086f9:	6a 04                	push   $0x4
801086fb:	e8 f4 a6 ff ff       	call   80102df4 <ioapicenable>
80108700:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108703:	c7 45 f4 80 a8 10 80 	movl   $0x8010a880,-0xc(%ebp)
8010870a:	eb 19                	jmp    80108725 <uartinit+0xe5>
    uartputc(*p);
8010870c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010870f:	0f b6 00             	movzbl (%eax),%eax
80108712:	0f be c0             	movsbl %al,%eax
80108715:	83 ec 0c             	sub    $0xc,%esp
80108718:	50                   	push   %eax
80108719:	e8 16 00 00 00       	call   80108734 <uartputc>
8010871e:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108721:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108728:	0f b6 00             	movzbl (%eax),%eax
8010872b:	84 c0                	test   %al,%al
8010872d:	75 dd                	jne    8010870c <uartinit+0xcc>
8010872f:	eb 01                	jmp    80108732 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80108731:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80108732:	c9                   	leave  
80108733:	c3                   	ret    

80108734 <uartputc>:

void
uartputc(int c)
{
80108734:	55                   	push   %ebp
80108735:	89 e5                	mov    %esp,%ebp
80108737:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010873a:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
8010873f:	85 c0                	test   %eax,%eax
80108741:	74 53                	je     80108796 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108743:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010874a:	eb 11                	jmp    8010875d <uartputc+0x29>
    microdelay(10);
8010874c:	83 ec 0c             	sub    $0xc,%esp
8010874f:	6a 0a                	push   $0xa
80108751:	e8 04 ac ff ff       	call   8010335a <microdelay>
80108756:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108759:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010875d:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108761:	7f 1a                	jg     8010877d <uartputc+0x49>
80108763:	83 ec 0c             	sub    $0xc,%esp
80108766:	68 fd 03 00 00       	push   $0x3fd
8010876b:	e8 94 fe ff ff       	call   80108604 <inb>
80108770:	83 c4 10             	add    $0x10,%esp
80108773:	0f b6 c0             	movzbl %al,%eax
80108776:	83 e0 20             	and    $0x20,%eax
80108779:	85 c0                	test   %eax,%eax
8010877b:	74 cf                	je     8010874c <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
8010877d:	8b 45 08             	mov    0x8(%ebp),%eax
80108780:	0f b6 c0             	movzbl %al,%eax
80108783:	83 ec 08             	sub    $0x8,%esp
80108786:	50                   	push   %eax
80108787:	68 f8 03 00 00       	push   $0x3f8
8010878c:	e8 90 fe ff ff       	call   80108621 <outb>
80108791:	83 c4 10             	add    $0x10,%esp
80108794:	eb 01                	jmp    80108797 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108796:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80108797:	c9                   	leave  
80108798:	c3                   	ret    

80108799 <uartgetc>:

static int
uartgetc(void)
{
80108799:	55                   	push   %ebp
8010879a:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010879c:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
801087a1:	85 c0                	test   %eax,%eax
801087a3:	75 07                	jne    801087ac <uartgetc+0x13>
    return -1;
801087a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087aa:	eb 2e                	jmp    801087da <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801087ac:	68 fd 03 00 00       	push   $0x3fd
801087b1:	e8 4e fe ff ff       	call   80108604 <inb>
801087b6:	83 c4 04             	add    $0x4,%esp
801087b9:	0f b6 c0             	movzbl %al,%eax
801087bc:	83 e0 01             	and    $0x1,%eax
801087bf:	85 c0                	test   %eax,%eax
801087c1:	75 07                	jne    801087ca <uartgetc+0x31>
    return -1;
801087c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087c8:	eb 10                	jmp    801087da <uartgetc+0x41>
  return inb(COM1+0);
801087ca:	68 f8 03 00 00       	push   $0x3f8
801087cf:	e8 30 fe ff ff       	call   80108604 <inb>
801087d4:	83 c4 04             	add    $0x4,%esp
801087d7:	0f b6 c0             	movzbl %al,%eax
}
801087da:	c9                   	leave  
801087db:	c3                   	ret    

801087dc <uartintr>:

void
uartintr(void)
{
801087dc:	55                   	push   %ebp
801087dd:	89 e5                	mov    %esp,%ebp
801087df:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801087e2:	83 ec 0c             	sub    $0xc,%esp
801087e5:	68 99 87 10 80       	push   $0x80108799
801087ea:	e8 0a 80 ff ff       	call   801007f9 <consoleintr>
801087ef:	83 c4 10             	add    $0x10,%esp
}
801087f2:	90                   	nop
801087f3:	c9                   	leave  
801087f4:	c3                   	ret    

801087f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801087f5:	6a 00                	push   $0x0
  pushl $0
801087f7:	6a 00                	push   $0x0
  jmp alltraps
801087f9:	e9 cc f9 ff ff       	jmp    801081ca <alltraps>

801087fe <vector1>:
.globl vector1
vector1:
  pushl $0
801087fe:	6a 00                	push   $0x0
  pushl $1
80108800:	6a 01                	push   $0x1
  jmp alltraps
80108802:	e9 c3 f9 ff ff       	jmp    801081ca <alltraps>

80108807 <vector2>:
.globl vector2
vector2:
  pushl $0
80108807:	6a 00                	push   $0x0
  pushl $2
80108809:	6a 02                	push   $0x2
  jmp alltraps
8010880b:	e9 ba f9 ff ff       	jmp    801081ca <alltraps>

80108810 <vector3>:
.globl vector3
vector3:
  pushl $0
80108810:	6a 00                	push   $0x0
  pushl $3
80108812:	6a 03                	push   $0x3
  jmp alltraps
80108814:	e9 b1 f9 ff ff       	jmp    801081ca <alltraps>

80108819 <vector4>:
.globl vector4
vector4:
  pushl $0
80108819:	6a 00                	push   $0x0
  pushl $4
8010881b:	6a 04                	push   $0x4
  jmp alltraps
8010881d:	e9 a8 f9 ff ff       	jmp    801081ca <alltraps>

80108822 <vector5>:
.globl vector5
vector5:
  pushl $0
80108822:	6a 00                	push   $0x0
  pushl $5
80108824:	6a 05                	push   $0x5
  jmp alltraps
80108826:	e9 9f f9 ff ff       	jmp    801081ca <alltraps>

8010882b <vector6>:
.globl vector6
vector6:
  pushl $0
8010882b:	6a 00                	push   $0x0
  pushl $6
8010882d:	6a 06                	push   $0x6
  jmp alltraps
8010882f:	e9 96 f9 ff ff       	jmp    801081ca <alltraps>

80108834 <vector7>:
.globl vector7
vector7:
  pushl $0
80108834:	6a 00                	push   $0x0
  pushl $7
80108836:	6a 07                	push   $0x7
  jmp alltraps
80108838:	e9 8d f9 ff ff       	jmp    801081ca <alltraps>

8010883d <vector8>:
.globl vector8
vector8:
  pushl $8
8010883d:	6a 08                	push   $0x8
  jmp alltraps
8010883f:	e9 86 f9 ff ff       	jmp    801081ca <alltraps>

80108844 <vector9>:
.globl vector9
vector9:
  pushl $0
80108844:	6a 00                	push   $0x0
  pushl $9
80108846:	6a 09                	push   $0x9
  jmp alltraps
80108848:	e9 7d f9 ff ff       	jmp    801081ca <alltraps>

8010884d <vector10>:
.globl vector10
vector10:
  pushl $10
8010884d:	6a 0a                	push   $0xa
  jmp alltraps
8010884f:	e9 76 f9 ff ff       	jmp    801081ca <alltraps>

80108854 <vector11>:
.globl vector11
vector11:
  pushl $11
80108854:	6a 0b                	push   $0xb
  jmp alltraps
80108856:	e9 6f f9 ff ff       	jmp    801081ca <alltraps>

8010885b <vector12>:
.globl vector12
vector12:
  pushl $12
8010885b:	6a 0c                	push   $0xc
  jmp alltraps
8010885d:	e9 68 f9 ff ff       	jmp    801081ca <alltraps>

80108862 <vector13>:
.globl vector13
vector13:
  pushl $13
80108862:	6a 0d                	push   $0xd
  jmp alltraps
80108864:	e9 61 f9 ff ff       	jmp    801081ca <alltraps>

80108869 <vector14>:
.globl vector14
vector14:
  pushl $14
80108869:	6a 0e                	push   $0xe
  jmp alltraps
8010886b:	e9 5a f9 ff ff       	jmp    801081ca <alltraps>

80108870 <vector15>:
.globl vector15
vector15:
  pushl $0
80108870:	6a 00                	push   $0x0
  pushl $15
80108872:	6a 0f                	push   $0xf
  jmp alltraps
80108874:	e9 51 f9 ff ff       	jmp    801081ca <alltraps>

80108879 <vector16>:
.globl vector16
vector16:
  pushl $0
80108879:	6a 00                	push   $0x0
  pushl $16
8010887b:	6a 10                	push   $0x10
  jmp alltraps
8010887d:	e9 48 f9 ff ff       	jmp    801081ca <alltraps>

80108882 <vector17>:
.globl vector17
vector17:
  pushl $17
80108882:	6a 11                	push   $0x11
  jmp alltraps
80108884:	e9 41 f9 ff ff       	jmp    801081ca <alltraps>

80108889 <vector18>:
.globl vector18
vector18:
  pushl $0
80108889:	6a 00                	push   $0x0
  pushl $18
8010888b:	6a 12                	push   $0x12
  jmp alltraps
8010888d:	e9 38 f9 ff ff       	jmp    801081ca <alltraps>

80108892 <vector19>:
.globl vector19
vector19:
  pushl $0
80108892:	6a 00                	push   $0x0
  pushl $19
80108894:	6a 13                	push   $0x13
  jmp alltraps
80108896:	e9 2f f9 ff ff       	jmp    801081ca <alltraps>

8010889b <vector20>:
.globl vector20
vector20:
  pushl $0
8010889b:	6a 00                	push   $0x0
  pushl $20
8010889d:	6a 14                	push   $0x14
  jmp alltraps
8010889f:	e9 26 f9 ff ff       	jmp    801081ca <alltraps>

801088a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801088a4:	6a 00                	push   $0x0
  pushl $21
801088a6:	6a 15                	push   $0x15
  jmp alltraps
801088a8:	e9 1d f9 ff ff       	jmp    801081ca <alltraps>

801088ad <vector22>:
.globl vector22
vector22:
  pushl $0
801088ad:	6a 00                	push   $0x0
  pushl $22
801088af:	6a 16                	push   $0x16
  jmp alltraps
801088b1:	e9 14 f9 ff ff       	jmp    801081ca <alltraps>

801088b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801088b6:	6a 00                	push   $0x0
  pushl $23
801088b8:	6a 17                	push   $0x17
  jmp alltraps
801088ba:	e9 0b f9 ff ff       	jmp    801081ca <alltraps>

801088bf <vector24>:
.globl vector24
vector24:
  pushl $0
801088bf:	6a 00                	push   $0x0
  pushl $24
801088c1:	6a 18                	push   $0x18
  jmp alltraps
801088c3:	e9 02 f9 ff ff       	jmp    801081ca <alltraps>

801088c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801088c8:	6a 00                	push   $0x0
  pushl $25
801088ca:	6a 19                	push   $0x19
  jmp alltraps
801088cc:	e9 f9 f8 ff ff       	jmp    801081ca <alltraps>

801088d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801088d1:	6a 00                	push   $0x0
  pushl $26
801088d3:	6a 1a                	push   $0x1a
  jmp alltraps
801088d5:	e9 f0 f8 ff ff       	jmp    801081ca <alltraps>

801088da <vector27>:
.globl vector27
vector27:
  pushl $0
801088da:	6a 00                	push   $0x0
  pushl $27
801088dc:	6a 1b                	push   $0x1b
  jmp alltraps
801088de:	e9 e7 f8 ff ff       	jmp    801081ca <alltraps>

801088e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801088e3:	6a 00                	push   $0x0
  pushl $28
801088e5:	6a 1c                	push   $0x1c
  jmp alltraps
801088e7:	e9 de f8 ff ff       	jmp    801081ca <alltraps>

801088ec <vector29>:
.globl vector29
vector29:
  pushl $0
801088ec:	6a 00                	push   $0x0
  pushl $29
801088ee:	6a 1d                	push   $0x1d
  jmp alltraps
801088f0:	e9 d5 f8 ff ff       	jmp    801081ca <alltraps>

801088f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801088f5:	6a 00                	push   $0x0
  pushl $30
801088f7:	6a 1e                	push   $0x1e
  jmp alltraps
801088f9:	e9 cc f8 ff ff       	jmp    801081ca <alltraps>

801088fe <vector31>:
.globl vector31
vector31:
  pushl $0
801088fe:	6a 00                	push   $0x0
  pushl $31
80108900:	6a 1f                	push   $0x1f
  jmp alltraps
80108902:	e9 c3 f8 ff ff       	jmp    801081ca <alltraps>

80108907 <vector32>:
.globl vector32
vector32:
  pushl $0
80108907:	6a 00                	push   $0x0
  pushl $32
80108909:	6a 20                	push   $0x20
  jmp alltraps
8010890b:	e9 ba f8 ff ff       	jmp    801081ca <alltraps>

80108910 <vector33>:
.globl vector33
vector33:
  pushl $0
80108910:	6a 00                	push   $0x0
  pushl $33
80108912:	6a 21                	push   $0x21
  jmp alltraps
80108914:	e9 b1 f8 ff ff       	jmp    801081ca <alltraps>

80108919 <vector34>:
.globl vector34
vector34:
  pushl $0
80108919:	6a 00                	push   $0x0
  pushl $34
8010891b:	6a 22                	push   $0x22
  jmp alltraps
8010891d:	e9 a8 f8 ff ff       	jmp    801081ca <alltraps>

80108922 <vector35>:
.globl vector35
vector35:
  pushl $0
80108922:	6a 00                	push   $0x0
  pushl $35
80108924:	6a 23                	push   $0x23
  jmp alltraps
80108926:	e9 9f f8 ff ff       	jmp    801081ca <alltraps>

8010892b <vector36>:
.globl vector36
vector36:
  pushl $0
8010892b:	6a 00                	push   $0x0
  pushl $36
8010892d:	6a 24                	push   $0x24
  jmp alltraps
8010892f:	e9 96 f8 ff ff       	jmp    801081ca <alltraps>

80108934 <vector37>:
.globl vector37
vector37:
  pushl $0
80108934:	6a 00                	push   $0x0
  pushl $37
80108936:	6a 25                	push   $0x25
  jmp alltraps
80108938:	e9 8d f8 ff ff       	jmp    801081ca <alltraps>

8010893d <vector38>:
.globl vector38
vector38:
  pushl $0
8010893d:	6a 00                	push   $0x0
  pushl $38
8010893f:	6a 26                	push   $0x26
  jmp alltraps
80108941:	e9 84 f8 ff ff       	jmp    801081ca <alltraps>

80108946 <vector39>:
.globl vector39
vector39:
  pushl $0
80108946:	6a 00                	push   $0x0
  pushl $39
80108948:	6a 27                	push   $0x27
  jmp alltraps
8010894a:	e9 7b f8 ff ff       	jmp    801081ca <alltraps>

8010894f <vector40>:
.globl vector40
vector40:
  pushl $0
8010894f:	6a 00                	push   $0x0
  pushl $40
80108951:	6a 28                	push   $0x28
  jmp alltraps
80108953:	e9 72 f8 ff ff       	jmp    801081ca <alltraps>

80108958 <vector41>:
.globl vector41
vector41:
  pushl $0
80108958:	6a 00                	push   $0x0
  pushl $41
8010895a:	6a 29                	push   $0x29
  jmp alltraps
8010895c:	e9 69 f8 ff ff       	jmp    801081ca <alltraps>

80108961 <vector42>:
.globl vector42
vector42:
  pushl $0
80108961:	6a 00                	push   $0x0
  pushl $42
80108963:	6a 2a                	push   $0x2a
  jmp alltraps
80108965:	e9 60 f8 ff ff       	jmp    801081ca <alltraps>

8010896a <vector43>:
.globl vector43
vector43:
  pushl $0
8010896a:	6a 00                	push   $0x0
  pushl $43
8010896c:	6a 2b                	push   $0x2b
  jmp alltraps
8010896e:	e9 57 f8 ff ff       	jmp    801081ca <alltraps>

80108973 <vector44>:
.globl vector44
vector44:
  pushl $0
80108973:	6a 00                	push   $0x0
  pushl $44
80108975:	6a 2c                	push   $0x2c
  jmp alltraps
80108977:	e9 4e f8 ff ff       	jmp    801081ca <alltraps>

8010897c <vector45>:
.globl vector45
vector45:
  pushl $0
8010897c:	6a 00                	push   $0x0
  pushl $45
8010897e:	6a 2d                	push   $0x2d
  jmp alltraps
80108980:	e9 45 f8 ff ff       	jmp    801081ca <alltraps>

80108985 <vector46>:
.globl vector46
vector46:
  pushl $0
80108985:	6a 00                	push   $0x0
  pushl $46
80108987:	6a 2e                	push   $0x2e
  jmp alltraps
80108989:	e9 3c f8 ff ff       	jmp    801081ca <alltraps>

8010898e <vector47>:
.globl vector47
vector47:
  pushl $0
8010898e:	6a 00                	push   $0x0
  pushl $47
80108990:	6a 2f                	push   $0x2f
  jmp alltraps
80108992:	e9 33 f8 ff ff       	jmp    801081ca <alltraps>

80108997 <vector48>:
.globl vector48
vector48:
  pushl $0
80108997:	6a 00                	push   $0x0
  pushl $48
80108999:	6a 30                	push   $0x30
  jmp alltraps
8010899b:	e9 2a f8 ff ff       	jmp    801081ca <alltraps>

801089a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801089a0:	6a 00                	push   $0x0
  pushl $49
801089a2:	6a 31                	push   $0x31
  jmp alltraps
801089a4:	e9 21 f8 ff ff       	jmp    801081ca <alltraps>

801089a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801089a9:	6a 00                	push   $0x0
  pushl $50
801089ab:	6a 32                	push   $0x32
  jmp alltraps
801089ad:	e9 18 f8 ff ff       	jmp    801081ca <alltraps>

801089b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801089b2:	6a 00                	push   $0x0
  pushl $51
801089b4:	6a 33                	push   $0x33
  jmp alltraps
801089b6:	e9 0f f8 ff ff       	jmp    801081ca <alltraps>

801089bb <vector52>:
.globl vector52
vector52:
  pushl $0
801089bb:	6a 00                	push   $0x0
  pushl $52
801089bd:	6a 34                	push   $0x34
  jmp alltraps
801089bf:	e9 06 f8 ff ff       	jmp    801081ca <alltraps>

801089c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801089c4:	6a 00                	push   $0x0
  pushl $53
801089c6:	6a 35                	push   $0x35
  jmp alltraps
801089c8:	e9 fd f7 ff ff       	jmp    801081ca <alltraps>

801089cd <vector54>:
.globl vector54
vector54:
  pushl $0
801089cd:	6a 00                	push   $0x0
  pushl $54
801089cf:	6a 36                	push   $0x36
  jmp alltraps
801089d1:	e9 f4 f7 ff ff       	jmp    801081ca <alltraps>

801089d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801089d6:	6a 00                	push   $0x0
  pushl $55
801089d8:	6a 37                	push   $0x37
  jmp alltraps
801089da:	e9 eb f7 ff ff       	jmp    801081ca <alltraps>

801089df <vector56>:
.globl vector56
vector56:
  pushl $0
801089df:	6a 00                	push   $0x0
  pushl $56
801089e1:	6a 38                	push   $0x38
  jmp alltraps
801089e3:	e9 e2 f7 ff ff       	jmp    801081ca <alltraps>

801089e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801089e8:	6a 00                	push   $0x0
  pushl $57
801089ea:	6a 39                	push   $0x39
  jmp alltraps
801089ec:	e9 d9 f7 ff ff       	jmp    801081ca <alltraps>

801089f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801089f1:	6a 00                	push   $0x0
  pushl $58
801089f3:	6a 3a                	push   $0x3a
  jmp alltraps
801089f5:	e9 d0 f7 ff ff       	jmp    801081ca <alltraps>

801089fa <vector59>:
.globl vector59
vector59:
  pushl $0
801089fa:	6a 00                	push   $0x0
  pushl $59
801089fc:	6a 3b                	push   $0x3b
  jmp alltraps
801089fe:	e9 c7 f7 ff ff       	jmp    801081ca <alltraps>

80108a03 <vector60>:
.globl vector60
vector60:
  pushl $0
80108a03:	6a 00                	push   $0x0
  pushl $60
80108a05:	6a 3c                	push   $0x3c
  jmp alltraps
80108a07:	e9 be f7 ff ff       	jmp    801081ca <alltraps>

80108a0c <vector61>:
.globl vector61
vector61:
  pushl $0
80108a0c:	6a 00                	push   $0x0
  pushl $61
80108a0e:	6a 3d                	push   $0x3d
  jmp alltraps
80108a10:	e9 b5 f7 ff ff       	jmp    801081ca <alltraps>

80108a15 <vector62>:
.globl vector62
vector62:
  pushl $0
80108a15:	6a 00                	push   $0x0
  pushl $62
80108a17:	6a 3e                	push   $0x3e
  jmp alltraps
80108a19:	e9 ac f7 ff ff       	jmp    801081ca <alltraps>

80108a1e <vector63>:
.globl vector63
vector63:
  pushl $0
80108a1e:	6a 00                	push   $0x0
  pushl $63
80108a20:	6a 3f                	push   $0x3f
  jmp alltraps
80108a22:	e9 a3 f7 ff ff       	jmp    801081ca <alltraps>

80108a27 <vector64>:
.globl vector64
vector64:
  pushl $0
80108a27:	6a 00                	push   $0x0
  pushl $64
80108a29:	6a 40                	push   $0x40
  jmp alltraps
80108a2b:	e9 9a f7 ff ff       	jmp    801081ca <alltraps>

80108a30 <vector65>:
.globl vector65
vector65:
  pushl $0
80108a30:	6a 00                	push   $0x0
  pushl $65
80108a32:	6a 41                	push   $0x41
  jmp alltraps
80108a34:	e9 91 f7 ff ff       	jmp    801081ca <alltraps>

80108a39 <vector66>:
.globl vector66
vector66:
  pushl $0
80108a39:	6a 00                	push   $0x0
  pushl $66
80108a3b:	6a 42                	push   $0x42
  jmp alltraps
80108a3d:	e9 88 f7 ff ff       	jmp    801081ca <alltraps>

80108a42 <vector67>:
.globl vector67
vector67:
  pushl $0
80108a42:	6a 00                	push   $0x0
  pushl $67
80108a44:	6a 43                	push   $0x43
  jmp alltraps
80108a46:	e9 7f f7 ff ff       	jmp    801081ca <alltraps>

80108a4b <vector68>:
.globl vector68
vector68:
  pushl $0
80108a4b:	6a 00                	push   $0x0
  pushl $68
80108a4d:	6a 44                	push   $0x44
  jmp alltraps
80108a4f:	e9 76 f7 ff ff       	jmp    801081ca <alltraps>

80108a54 <vector69>:
.globl vector69
vector69:
  pushl $0
80108a54:	6a 00                	push   $0x0
  pushl $69
80108a56:	6a 45                	push   $0x45
  jmp alltraps
80108a58:	e9 6d f7 ff ff       	jmp    801081ca <alltraps>

80108a5d <vector70>:
.globl vector70
vector70:
  pushl $0
80108a5d:	6a 00                	push   $0x0
  pushl $70
80108a5f:	6a 46                	push   $0x46
  jmp alltraps
80108a61:	e9 64 f7 ff ff       	jmp    801081ca <alltraps>

80108a66 <vector71>:
.globl vector71
vector71:
  pushl $0
80108a66:	6a 00                	push   $0x0
  pushl $71
80108a68:	6a 47                	push   $0x47
  jmp alltraps
80108a6a:	e9 5b f7 ff ff       	jmp    801081ca <alltraps>

80108a6f <vector72>:
.globl vector72
vector72:
  pushl $0
80108a6f:	6a 00                	push   $0x0
  pushl $72
80108a71:	6a 48                	push   $0x48
  jmp alltraps
80108a73:	e9 52 f7 ff ff       	jmp    801081ca <alltraps>

80108a78 <vector73>:
.globl vector73
vector73:
  pushl $0
80108a78:	6a 00                	push   $0x0
  pushl $73
80108a7a:	6a 49                	push   $0x49
  jmp alltraps
80108a7c:	e9 49 f7 ff ff       	jmp    801081ca <alltraps>

80108a81 <vector74>:
.globl vector74
vector74:
  pushl $0
80108a81:	6a 00                	push   $0x0
  pushl $74
80108a83:	6a 4a                	push   $0x4a
  jmp alltraps
80108a85:	e9 40 f7 ff ff       	jmp    801081ca <alltraps>

80108a8a <vector75>:
.globl vector75
vector75:
  pushl $0
80108a8a:	6a 00                	push   $0x0
  pushl $75
80108a8c:	6a 4b                	push   $0x4b
  jmp alltraps
80108a8e:	e9 37 f7 ff ff       	jmp    801081ca <alltraps>

80108a93 <vector76>:
.globl vector76
vector76:
  pushl $0
80108a93:	6a 00                	push   $0x0
  pushl $76
80108a95:	6a 4c                	push   $0x4c
  jmp alltraps
80108a97:	e9 2e f7 ff ff       	jmp    801081ca <alltraps>

80108a9c <vector77>:
.globl vector77
vector77:
  pushl $0
80108a9c:	6a 00                	push   $0x0
  pushl $77
80108a9e:	6a 4d                	push   $0x4d
  jmp alltraps
80108aa0:	e9 25 f7 ff ff       	jmp    801081ca <alltraps>

80108aa5 <vector78>:
.globl vector78
vector78:
  pushl $0
80108aa5:	6a 00                	push   $0x0
  pushl $78
80108aa7:	6a 4e                	push   $0x4e
  jmp alltraps
80108aa9:	e9 1c f7 ff ff       	jmp    801081ca <alltraps>

80108aae <vector79>:
.globl vector79
vector79:
  pushl $0
80108aae:	6a 00                	push   $0x0
  pushl $79
80108ab0:	6a 4f                	push   $0x4f
  jmp alltraps
80108ab2:	e9 13 f7 ff ff       	jmp    801081ca <alltraps>

80108ab7 <vector80>:
.globl vector80
vector80:
  pushl $0
80108ab7:	6a 00                	push   $0x0
  pushl $80
80108ab9:	6a 50                	push   $0x50
  jmp alltraps
80108abb:	e9 0a f7 ff ff       	jmp    801081ca <alltraps>

80108ac0 <vector81>:
.globl vector81
vector81:
  pushl $0
80108ac0:	6a 00                	push   $0x0
  pushl $81
80108ac2:	6a 51                	push   $0x51
  jmp alltraps
80108ac4:	e9 01 f7 ff ff       	jmp    801081ca <alltraps>

80108ac9 <vector82>:
.globl vector82
vector82:
  pushl $0
80108ac9:	6a 00                	push   $0x0
  pushl $82
80108acb:	6a 52                	push   $0x52
  jmp alltraps
80108acd:	e9 f8 f6 ff ff       	jmp    801081ca <alltraps>

80108ad2 <vector83>:
.globl vector83
vector83:
  pushl $0
80108ad2:	6a 00                	push   $0x0
  pushl $83
80108ad4:	6a 53                	push   $0x53
  jmp alltraps
80108ad6:	e9 ef f6 ff ff       	jmp    801081ca <alltraps>

80108adb <vector84>:
.globl vector84
vector84:
  pushl $0
80108adb:	6a 00                	push   $0x0
  pushl $84
80108add:	6a 54                	push   $0x54
  jmp alltraps
80108adf:	e9 e6 f6 ff ff       	jmp    801081ca <alltraps>

80108ae4 <vector85>:
.globl vector85
vector85:
  pushl $0
80108ae4:	6a 00                	push   $0x0
  pushl $85
80108ae6:	6a 55                	push   $0x55
  jmp alltraps
80108ae8:	e9 dd f6 ff ff       	jmp    801081ca <alltraps>

80108aed <vector86>:
.globl vector86
vector86:
  pushl $0
80108aed:	6a 00                	push   $0x0
  pushl $86
80108aef:	6a 56                	push   $0x56
  jmp alltraps
80108af1:	e9 d4 f6 ff ff       	jmp    801081ca <alltraps>

80108af6 <vector87>:
.globl vector87
vector87:
  pushl $0
80108af6:	6a 00                	push   $0x0
  pushl $87
80108af8:	6a 57                	push   $0x57
  jmp alltraps
80108afa:	e9 cb f6 ff ff       	jmp    801081ca <alltraps>

80108aff <vector88>:
.globl vector88
vector88:
  pushl $0
80108aff:	6a 00                	push   $0x0
  pushl $88
80108b01:	6a 58                	push   $0x58
  jmp alltraps
80108b03:	e9 c2 f6 ff ff       	jmp    801081ca <alltraps>

80108b08 <vector89>:
.globl vector89
vector89:
  pushl $0
80108b08:	6a 00                	push   $0x0
  pushl $89
80108b0a:	6a 59                	push   $0x59
  jmp alltraps
80108b0c:	e9 b9 f6 ff ff       	jmp    801081ca <alltraps>

80108b11 <vector90>:
.globl vector90
vector90:
  pushl $0
80108b11:	6a 00                	push   $0x0
  pushl $90
80108b13:	6a 5a                	push   $0x5a
  jmp alltraps
80108b15:	e9 b0 f6 ff ff       	jmp    801081ca <alltraps>

80108b1a <vector91>:
.globl vector91
vector91:
  pushl $0
80108b1a:	6a 00                	push   $0x0
  pushl $91
80108b1c:	6a 5b                	push   $0x5b
  jmp alltraps
80108b1e:	e9 a7 f6 ff ff       	jmp    801081ca <alltraps>

80108b23 <vector92>:
.globl vector92
vector92:
  pushl $0
80108b23:	6a 00                	push   $0x0
  pushl $92
80108b25:	6a 5c                	push   $0x5c
  jmp alltraps
80108b27:	e9 9e f6 ff ff       	jmp    801081ca <alltraps>

80108b2c <vector93>:
.globl vector93
vector93:
  pushl $0
80108b2c:	6a 00                	push   $0x0
  pushl $93
80108b2e:	6a 5d                	push   $0x5d
  jmp alltraps
80108b30:	e9 95 f6 ff ff       	jmp    801081ca <alltraps>

80108b35 <vector94>:
.globl vector94
vector94:
  pushl $0
80108b35:	6a 00                	push   $0x0
  pushl $94
80108b37:	6a 5e                	push   $0x5e
  jmp alltraps
80108b39:	e9 8c f6 ff ff       	jmp    801081ca <alltraps>

80108b3e <vector95>:
.globl vector95
vector95:
  pushl $0
80108b3e:	6a 00                	push   $0x0
  pushl $95
80108b40:	6a 5f                	push   $0x5f
  jmp alltraps
80108b42:	e9 83 f6 ff ff       	jmp    801081ca <alltraps>

80108b47 <vector96>:
.globl vector96
vector96:
  pushl $0
80108b47:	6a 00                	push   $0x0
  pushl $96
80108b49:	6a 60                	push   $0x60
  jmp alltraps
80108b4b:	e9 7a f6 ff ff       	jmp    801081ca <alltraps>

80108b50 <vector97>:
.globl vector97
vector97:
  pushl $0
80108b50:	6a 00                	push   $0x0
  pushl $97
80108b52:	6a 61                	push   $0x61
  jmp alltraps
80108b54:	e9 71 f6 ff ff       	jmp    801081ca <alltraps>

80108b59 <vector98>:
.globl vector98
vector98:
  pushl $0
80108b59:	6a 00                	push   $0x0
  pushl $98
80108b5b:	6a 62                	push   $0x62
  jmp alltraps
80108b5d:	e9 68 f6 ff ff       	jmp    801081ca <alltraps>

80108b62 <vector99>:
.globl vector99
vector99:
  pushl $0
80108b62:	6a 00                	push   $0x0
  pushl $99
80108b64:	6a 63                	push   $0x63
  jmp alltraps
80108b66:	e9 5f f6 ff ff       	jmp    801081ca <alltraps>

80108b6b <vector100>:
.globl vector100
vector100:
  pushl $0
80108b6b:	6a 00                	push   $0x0
  pushl $100
80108b6d:	6a 64                	push   $0x64
  jmp alltraps
80108b6f:	e9 56 f6 ff ff       	jmp    801081ca <alltraps>

80108b74 <vector101>:
.globl vector101
vector101:
  pushl $0
80108b74:	6a 00                	push   $0x0
  pushl $101
80108b76:	6a 65                	push   $0x65
  jmp alltraps
80108b78:	e9 4d f6 ff ff       	jmp    801081ca <alltraps>

80108b7d <vector102>:
.globl vector102
vector102:
  pushl $0
80108b7d:	6a 00                	push   $0x0
  pushl $102
80108b7f:	6a 66                	push   $0x66
  jmp alltraps
80108b81:	e9 44 f6 ff ff       	jmp    801081ca <alltraps>

80108b86 <vector103>:
.globl vector103
vector103:
  pushl $0
80108b86:	6a 00                	push   $0x0
  pushl $103
80108b88:	6a 67                	push   $0x67
  jmp alltraps
80108b8a:	e9 3b f6 ff ff       	jmp    801081ca <alltraps>

80108b8f <vector104>:
.globl vector104
vector104:
  pushl $0
80108b8f:	6a 00                	push   $0x0
  pushl $104
80108b91:	6a 68                	push   $0x68
  jmp alltraps
80108b93:	e9 32 f6 ff ff       	jmp    801081ca <alltraps>

80108b98 <vector105>:
.globl vector105
vector105:
  pushl $0
80108b98:	6a 00                	push   $0x0
  pushl $105
80108b9a:	6a 69                	push   $0x69
  jmp alltraps
80108b9c:	e9 29 f6 ff ff       	jmp    801081ca <alltraps>

80108ba1 <vector106>:
.globl vector106
vector106:
  pushl $0
80108ba1:	6a 00                	push   $0x0
  pushl $106
80108ba3:	6a 6a                	push   $0x6a
  jmp alltraps
80108ba5:	e9 20 f6 ff ff       	jmp    801081ca <alltraps>

80108baa <vector107>:
.globl vector107
vector107:
  pushl $0
80108baa:	6a 00                	push   $0x0
  pushl $107
80108bac:	6a 6b                	push   $0x6b
  jmp alltraps
80108bae:	e9 17 f6 ff ff       	jmp    801081ca <alltraps>

80108bb3 <vector108>:
.globl vector108
vector108:
  pushl $0
80108bb3:	6a 00                	push   $0x0
  pushl $108
80108bb5:	6a 6c                	push   $0x6c
  jmp alltraps
80108bb7:	e9 0e f6 ff ff       	jmp    801081ca <alltraps>

80108bbc <vector109>:
.globl vector109
vector109:
  pushl $0
80108bbc:	6a 00                	push   $0x0
  pushl $109
80108bbe:	6a 6d                	push   $0x6d
  jmp alltraps
80108bc0:	e9 05 f6 ff ff       	jmp    801081ca <alltraps>

80108bc5 <vector110>:
.globl vector110
vector110:
  pushl $0
80108bc5:	6a 00                	push   $0x0
  pushl $110
80108bc7:	6a 6e                	push   $0x6e
  jmp alltraps
80108bc9:	e9 fc f5 ff ff       	jmp    801081ca <alltraps>

80108bce <vector111>:
.globl vector111
vector111:
  pushl $0
80108bce:	6a 00                	push   $0x0
  pushl $111
80108bd0:	6a 6f                	push   $0x6f
  jmp alltraps
80108bd2:	e9 f3 f5 ff ff       	jmp    801081ca <alltraps>

80108bd7 <vector112>:
.globl vector112
vector112:
  pushl $0
80108bd7:	6a 00                	push   $0x0
  pushl $112
80108bd9:	6a 70                	push   $0x70
  jmp alltraps
80108bdb:	e9 ea f5 ff ff       	jmp    801081ca <alltraps>

80108be0 <vector113>:
.globl vector113
vector113:
  pushl $0
80108be0:	6a 00                	push   $0x0
  pushl $113
80108be2:	6a 71                	push   $0x71
  jmp alltraps
80108be4:	e9 e1 f5 ff ff       	jmp    801081ca <alltraps>

80108be9 <vector114>:
.globl vector114
vector114:
  pushl $0
80108be9:	6a 00                	push   $0x0
  pushl $114
80108beb:	6a 72                	push   $0x72
  jmp alltraps
80108bed:	e9 d8 f5 ff ff       	jmp    801081ca <alltraps>

80108bf2 <vector115>:
.globl vector115
vector115:
  pushl $0
80108bf2:	6a 00                	push   $0x0
  pushl $115
80108bf4:	6a 73                	push   $0x73
  jmp alltraps
80108bf6:	e9 cf f5 ff ff       	jmp    801081ca <alltraps>

80108bfb <vector116>:
.globl vector116
vector116:
  pushl $0
80108bfb:	6a 00                	push   $0x0
  pushl $116
80108bfd:	6a 74                	push   $0x74
  jmp alltraps
80108bff:	e9 c6 f5 ff ff       	jmp    801081ca <alltraps>

80108c04 <vector117>:
.globl vector117
vector117:
  pushl $0
80108c04:	6a 00                	push   $0x0
  pushl $117
80108c06:	6a 75                	push   $0x75
  jmp alltraps
80108c08:	e9 bd f5 ff ff       	jmp    801081ca <alltraps>

80108c0d <vector118>:
.globl vector118
vector118:
  pushl $0
80108c0d:	6a 00                	push   $0x0
  pushl $118
80108c0f:	6a 76                	push   $0x76
  jmp alltraps
80108c11:	e9 b4 f5 ff ff       	jmp    801081ca <alltraps>

80108c16 <vector119>:
.globl vector119
vector119:
  pushl $0
80108c16:	6a 00                	push   $0x0
  pushl $119
80108c18:	6a 77                	push   $0x77
  jmp alltraps
80108c1a:	e9 ab f5 ff ff       	jmp    801081ca <alltraps>

80108c1f <vector120>:
.globl vector120
vector120:
  pushl $0
80108c1f:	6a 00                	push   $0x0
  pushl $120
80108c21:	6a 78                	push   $0x78
  jmp alltraps
80108c23:	e9 a2 f5 ff ff       	jmp    801081ca <alltraps>

80108c28 <vector121>:
.globl vector121
vector121:
  pushl $0
80108c28:	6a 00                	push   $0x0
  pushl $121
80108c2a:	6a 79                	push   $0x79
  jmp alltraps
80108c2c:	e9 99 f5 ff ff       	jmp    801081ca <alltraps>

80108c31 <vector122>:
.globl vector122
vector122:
  pushl $0
80108c31:	6a 00                	push   $0x0
  pushl $122
80108c33:	6a 7a                	push   $0x7a
  jmp alltraps
80108c35:	e9 90 f5 ff ff       	jmp    801081ca <alltraps>

80108c3a <vector123>:
.globl vector123
vector123:
  pushl $0
80108c3a:	6a 00                	push   $0x0
  pushl $123
80108c3c:	6a 7b                	push   $0x7b
  jmp alltraps
80108c3e:	e9 87 f5 ff ff       	jmp    801081ca <alltraps>

80108c43 <vector124>:
.globl vector124
vector124:
  pushl $0
80108c43:	6a 00                	push   $0x0
  pushl $124
80108c45:	6a 7c                	push   $0x7c
  jmp alltraps
80108c47:	e9 7e f5 ff ff       	jmp    801081ca <alltraps>

80108c4c <vector125>:
.globl vector125
vector125:
  pushl $0
80108c4c:	6a 00                	push   $0x0
  pushl $125
80108c4e:	6a 7d                	push   $0x7d
  jmp alltraps
80108c50:	e9 75 f5 ff ff       	jmp    801081ca <alltraps>

80108c55 <vector126>:
.globl vector126
vector126:
  pushl $0
80108c55:	6a 00                	push   $0x0
  pushl $126
80108c57:	6a 7e                	push   $0x7e
  jmp alltraps
80108c59:	e9 6c f5 ff ff       	jmp    801081ca <alltraps>

80108c5e <vector127>:
.globl vector127
vector127:
  pushl $0
80108c5e:	6a 00                	push   $0x0
  pushl $127
80108c60:	6a 7f                	push   $0x7f
  jmp alltraps
80108c62:	e9 63 f5 ff ff       	jmp    801081ca <alltraps>

80108c67 <vector128>:
.globl vector128
vector128:
  pushl $0
80108c67:	6a 00                	push   $0x0
  pushl $128
80108c69:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108c6e:	e9 57 f5 ff ff       	jmp    801081ca <alltraps>

80108c73 <vector129>:
.globl vector129
vector129:
  pushl $0
80108c73:	6a 00                	push   $0x0
  pushl $129
80108c75:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108c7a:	e9 4b f5 ff ff       	jmp    801081ca <alltraps>

80108c7f <vector130>:
.globl vector130
vector130:
  pushl $0
80108c7f:	6a 00                	push   $0x0
  pushl $130
80108c81:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108c86:	e9 3f f5 ff ff       	jmp    801081ca <alltraps>

80108c8b <vector131>:
.globl vector131
vector131:
  pushl $0
80108c8b:	6a 00                	push   $0x0
  pushl $131
80108c8d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108c92:	e9 33 f5 ff ff       	jmp    801081ca <alltraps>

80108c97 <vector132>:
.globl vector132
vector132:
  pushl $0
80108c97:	6a 00                	push   $0x0
  pushl $132
80108c99:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108c9e:	e9 27 f5 ff ff       	jmp    801081ca <alltraps>

80108ca3 <vector133>:
.globl vector133
vector133:
  pushl $0
80108ca3:	6a 00                	push   $0x0
  pushl $133
80108ca5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108caa:	e9 1b f5 ff ff       	jmp    801081ca <alltraps>

80108caf <vector134>:
.globl vector134
vector134:
  pushl $0
80108caf:	6a 00                	push   $0x0
  pushl $134
80108cb1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108cb6:	e9 0f f5 ff ff       	jmp    801081ca <alltraps>

80108cbb <vector135>:
.globl vector135
vector135:
  pushl $0
80108cbb:	6a 00                	push   $0x0
  pushl $135
80108cbd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108cc2:	e9 03 f5 ff ff       	jmp    801081ca <alltraps>

80108cc7 <vector136>:
.globl vector136
vector136:
  pushl $0
80108cc7:	6a 00                	push   $0x0
  pushl $136
80108cc9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108cce:	e9 f7 f4 ff ff       	jmp    801081ca <alltraps>

80108cd3 <vector137>:
.globl vector137
vector137:
  pushl $0
80108cd3:	6a 00                	push   $0x0
  pushl $137
80108cd5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108cda:	e9 eb f4 ff ff       	jmp    801081ca <alltraps>

80108cdf <vector138>:
.globl vector138
vector138:
  pushl $0
80108cdf:	6a 00                	push   $0x0
  pushl $138
80108ce1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108ce6:	e9 df f4 ff ff       	jmp    801081ca <alltraps>

80108ceb <vector139>:
.globl vector139
vector139:
  pushl $0
80108ceb:	6a 00                	push   $0x0
  pushl $139
80108ced:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108cf2:	e9 d3 f4 ff ff       	jmp    801081ca <alltraps>

80108cf7 <vector140>:
.globl vector140
vector140:
  pushl $0
80108cf7:	6a 00                	push   $0x0
  pushl $140
80108cf9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108cfe:	e9 c7 f4 ff ff       	jmp    801081ca <alltraps>

80108d03 <vector141>:
.globl vector141
vector141:
  pushl $0
80108d03:	6a 00                	push   $0x0
  pushl $141
80108d05:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108d0a:	e9 bb f4 ff ff       	jmp    801081ca <alltraps>

80108d0f <vector142>:
.globl vector142
vector142:
  pushl $0
80108d0f:	6a 00                	push   $0x0
  pushl $142
80108d11:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108d16:	e9 af f4 ff ff       	jmp    801081ca <alltraps>

80108d1b <vector143>:
.globl vector143
vector143:
  pushl $0
80108d1b:	6a 00                	push   $0x0
  pushl $143
80108d1d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108d22:	e9 a3 f4 ff ff       	jmp    801081ca <alltraps>

80108d27 <vector144>:
.globl vector144
vector144:
  pushl $0
80108d27:	6a 00                	push   $0x0
  pushl $144
80108d29:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108d2e:	e9 97 f4 ff ff       	jmp    801081ca <alltraps>

80108d33 <vector145>:
.globl vector145
vector145:
  pushl $0
80108d33:	6a 00                	push   $0x0
  pushl $145
80108d35:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108d3a:	e9 8b f4 ff ff       	jmp    801081ca <alltraps>

80108d3f <vector146>:
.globl vector146
vector146:
  pushl $0
80108d3f:	6a 00                	push   $0x0
  pushl $146
80108d41:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108d46:	e9 7f f4 ff ff       	jmp    801081ca <alltraps>

80108d4b <vector147>:
.globl vector147
vector147:
  pushl $0
80108d4b:	6a 00                	push   $0x0
  pushl $147
80108d4d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108d52:	e9 73 f4 ff ff       	jmp    801081ca <alltraps>

80108d57 <vector148>:
.globl vector148
vector148:
  pushl $0
80108d57:	6a 00                	push   $0x0
  pushl $148
80108d59:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108d5e:	e9 67 f4 ff ff       	jmp    801081ca <alltraps>

80108d63 <vector149>:
.globl vector149
vector149:
  pushl $0
80108d63:	6a 00                	push   $0x0
  pushl $149
80108d65:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108d6a:	e9 5b f4 ff ff       	jmp    801081ca <alltraps>

80108d6f <vector150>:
.globl vector150
vector150:
  pushl $0
80108d6f:	6a 00                	push   $0x0
  pushl $150
80108d71:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108d76:	e9 4f f4 ff ff       	jmp    801081ca <alltraps>

80108d7b <vector151>:
.globl vector151
vector151:
  pushl $0
80108d7b:	6a 00                	push   $0x0
  pushl $151
80108d7d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108d82:	e9 43 f4 ff ff       	jmp    801081ca <alltraps>

80108d87 <vector152>:
.globl vector152
vector152:
  pushl $0
80108d87:	6a 00                	push   $0x0
  pushl $152
80108d89:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108d8e:	e9 37 f4 ff ff       	jmp    801081ca <alltraps>

80108d93 <vector153>:
.globl vector153
vector153:
  pushl $0
80108d93:	6a 00                	push   $0x0
  pushl $153
80108d95:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108d9a:	e9 2b f4 ff ff       	jmp    801081ca <alltraps>

80108d9f <vector154>:
.globl vector154
vector154:
  pushl $0
80108d9f:	6a 00                	push   $0x0
  pushl $154
80108da1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108da6:	e9 1f f4 ff ff       	jmp    801081ca <alltraps>

80108dab <vector155>:
.globl vector155
vector155:
  pushl $0
80108dab:	6a 00                	push   $0x0
  pushl $155
80108dad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108db2:	e9 13 f4 ff ff       	jmp    801081ca <alltraps>

80108db7 <vector156>:
.globl vector156
vector156:
  pushl $0
80108db7:	6a 00                	push   $0x0
  pushl $156
80108db9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108dbe:	e9 07 f4 ff ff       	jmp    801081ca <alltraps>

80108dc3 <vector157>:
.globl vector157
vector157:
  pushl $0
80108dc3:	6a 00                	push   $0x0
  pushl $157
80108dc5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108dca:	e9 fb f3 ff ff       	jmp    801081ca <alltraps>

80108dcf <vector158>:
.globl vector158
vector158:
  pushl $0
80108dcf:	6a 00                	push   $0x0
  pushl $158
80108dd1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108dd6:	e9 ef f3 ff ff       	jmp    801081ca <alltraps>

80108ddb <vector159>:
.globl vector159
vector159:
  pushl $0
80108ddb:	6a 00                	push   $0x0
  pushl $159
80108ddd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108de2:	e9 e3 f3 ff ff       	jmp    801081ca <alltraps>

80108de7 <vector160>:
.globl vector160
vector160:
  pushl $0
80108de7:	6a 00                	push   $0x0
  pushl $160
80108de9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108dee:	e9 d7 f3 ff ff       	jmp    801081ca <alltraps>

80108df3 <vector161>:
.globl vector161
vector161:
  pushl $0
80108df3:	6a 00                	push   $0x0
  pushl $161
80108df5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108dfa:	e9 cb f3 ff ff       	jmp    801081ca <alltraps>

80108dff <vector162>:
.globl vector162
vector162:
  pushl $0
80108dff:	6a 00                	push   $0x0
  pushl $162
80108e01:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108e06:	e9 bf f3 ff ff       	jmp    801081ca <alltraps>

80108e0b <vector163>:
.globl vector163
vector163:
  pushl $0
80108e0b:	6a 00                	push   $0x0
  pushl $163
80108e0d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108e12:	e9 b3 f3 ff ff       	jmp    801081ca <alltraps>

80108e17 <vector164>:
.globl vector164
vector164:
  pushl $0
80108e17:	6a 00                	push   $0x0
  pushl $164
80108e19:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108e1e:	e9 a7 f3 ff ff       	jmp    801081ca <alltraps>

80108e23 <vector165>:
.globl vector165
vector165:
  pushl $0
80108e23:	6a 00                	push   $0x0
  pushl $165
80108e25:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108e2a:	e9 9b f3 ff ff       	jmp    801081ca <alltraps>

80108e2f <vector166>:
.globl vector166
vector166:
  pushl $0
80108e2f:	6a 00                	push   $0x0
  pushl $166
80108e31:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108e36:	e9 8f f3 ff ff       	jmp    801081ca <alltraps>

80108e3b <vector167>:
.globl vector167
vector167:
  pushl $0
80108e3b:	6a 00                	push   $0x0
  pushl $167
80108e3d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108e42:	e9 83 f3 ff ff       	jmp    801081ca <alltraps>

80108e47 <vector168>:
.globl vector168
vector168:
  pushl $0
80108e47:	6a 00                	push   $0x0
  pushl $168
80108e49:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108e4e:	e9 77 f3 ff ff       	jmp    801081ca <alltraps>

80108e53 <vector169>:
.globl vector169
vector169:
  pushl $0
80108e53:	6a 00                	push   $0x0
  pushl $169
80108e55:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108e5a:	e9 6b f3 ff ff       	jmp    801081ca <alltraps>

80108e5f <vector170>:
.globl vector170
vector170:
  pushl $0
80108e5f:	6a 00                	push   $0x0
  pushl $170
80108e61:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108e66:	e9 5f f3 ff ff       	jmp    801081ca <alltraps>

80108e6b <vector171>:
.globl vector171
vector171:
  pushl $0
80108e6b:	6a 00                	push   $0x0
  pushl $171
80108e6d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108e72:	e9 53 f3 ff ff       	jmp    801081ca <alltraps>

80108e77 <vector172>:
.globl vector172
vector172:
  pushl $0
80108e77:	6a 00                	push   $0x0
  pushl $172
80108e79:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108e7e:	e9 47 f3 ff ff       	jmp    801081ca <alltraps>

80108e83 <vector173>:
.globl vector173
vector173:
  pushl $0
80108e83:	6a 00                	push   $0x0
  pushl $173
80108e85:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108e8a:	e9 3b f3 ff ff       	jmp    801081ca <alltraps>

80108e8f <vector174>:
.globl vector174
vector174:
  pushl $0
80108e8f:	6a 00                	push   $0x0
  pushl $174
80108e91:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108e96:	e9 2f f3 ff ff       	jmp    801081ca <alltraps>

80108e9b <vector175>:
.globl vector175
vector175:
  pushl $0
80108e9b:	6a 00                	push   $0x0
  pushl $175
80108e9d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108ea2:	e9 23 f3 ff ff       	jmp    801081ca <alltraps>

80108ea7 <vector176>:
.globl vector176
vector176:
  pushl $0
80108ea7:	6a 00                	push   $0x0
  pushl $176
80108ea9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108eae:	e9 17 f3 ff ff       	jmp    801081ca <alltraps>

80108eb3 <vector177>:
.globl vector177
vector177:
  pushl $0
80108eb3:	6a 00                	push   $0x0
  pushl $177
80108eb5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108eba:	e9 0b f3 ff ff       	jmp    801081ca <alltraps>

80108ebf <vector178>:
.globl vector178
vector178:
  pushl $0
80108ebf:	6a 00                	push   $0x0
  pushl $178
80108ec1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108ec6:	e9 ff f2 ff ff       	jmp    801081ca <alltraps>

80108ecb <vector179>:
.globl vector179
vector179:
  pushl $0
80108ecb:	6a 00                	push   $0x0
  pushl $179
80108ecd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108ed2:	e9 f3 f2 ff ff       	jmp    801081ca <alltraps>

80108ed7 <vector180>:
.globl vector180
vector180:
  pushl $0
80108ed7:	6a 00                	push   $0x0
  pushl $180
80108ed9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108ede:	e9 e7 f2 ff ff       	jmp    801081ca <alltraps>

80108ee3 <vector181>:
.globl vector181
vector181:
  pushl $0
80108ee3:	6a 00                	push   $0x0
  pushl $181
80108ee5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108eea:	e9 db f2 ff ff       	jmp    801081ca <alltraps>

80108eef <vector182>:
.globl vector182
vector182:
  pushl $0
80108eef:	6a 00                	push   $0x0
  pushl $182
80108ef1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108ef6:	e9 cf f2 ff ff       	jmp    801081ca <alltraps>

80108efb <vector183>:
.globl vector183
vector183:
  pushl $0
80108efb:	6a 00                	push   $0x0
  pushl $183
80108efd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108f02:	e9 c3 f2 ff ff       	jmp    801081ca <alltraps>

80108f07 <vector184>:
.globl vector184
vector184:
  pushl $0
80108f07:	6a 00                	push   $0x0
  pushl $184
80108f09:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108f0e:	e9 b7 f2 ff ff       	jmp    801081ca <alltraps>

80108f13 <vector185>:
.globl vector185
vector185:
  pushl $0
80108f13:	6a 00                	push   $0x0
  pushl $185
80108f15:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108f1a:	e9 ab f2 ff ff       	jmp    801081ca <alltraps>

80108f1f <vector186>:
.globl vector186
vector186:
  pushl $0
80108f1f:	6a 00                	push   $0x0
  pushl $186
80108f21:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108f26:	e9 9f f2 ff ff       	jmp    801081ca <alltraps>

80108f2b <vector187>:
.globl vector187
vector187:
  pushl $0
80108f2b:	6a 00                	push   $0x0
  pushl $187
80108f2d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108f32:	e9 93 f2 ff ff       	jmp    801081ca <alltraps>

80108f37 <vector188>:
.globl vector188
vector188:
  pushl $0
80108f37:	6a 00                	push   $0x0
  pushl $188
80108f39:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108f3e:	e9 87 f2 ff ff       	jmp    801081ca <alltraps>

80108f43 <vector189>:
.globl vector189
vector189:
  pushl $0
80108f43:	6a 00                	push   $0x0
  pushl $189
80108f45:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108f4a:	e9 7b f2 ff ff       	jmp    801081ca <alltraps>

80108f4f <vector190>:
.globl vector190
vector190:
  pushl $0
80108f4f:	6a 00                	push   $0x0
  pushl $190
80108f51:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108f56:	e9 6f f2 ff ff       	jmp    801081ca <alltraps>

80108f5b <vector191>:
.globl vector191
vector191:
  pushl $0
80108f5b:	6a 00                	push   $0x0
  pushl $191
80108f5d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108f62:	e9 63 f2 ff ff       	jmp    801081ca <alltraps>

80108f67 <vector192>:
.globl vector192
vector192:
  pushl $0
80108f67:	6a 00                	push   $0x0
  pushl $192
80108f69:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108f6e:	e9 57 f2 ff ff       	jmp    801081ca <alltraps>

80108f73 <vector193>:
.globl vector193
vector193:
  pushl $0
80108f73:	6a 00                	push   $0x0
  pushl $193
80108f75:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108f7a:	e9 4b f2 ff ff       	jmp    801081ca <alltraps>

80108f7f <vector194>:
.globl vector194
vector194:
  pushl $0
80108f7f:	6a 00                	push   $0x0
  pushl $194
80108f81:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108f86:	e9 3f f2 ff ff       	jmp    801081ca <alltraps>

80108f8b <vector195>:
.globl vector195
vector195:
  pushl $0
80108f8b:	6a 00                	push   $0x0
  pushl $195
80108f8d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108f92:	e9 33 f2 ff ff       	jmp    801081ca <alltraps>

80108f97 <vector196>:
.globl vector196
vector196:
  pushl $0
80108f97:	6a 00                	push   $0x0
  pushl $196
80108f99:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108f9e:	e9 27 f2 ff ff       	jmp    801081ca <alltraps>

80108fa3 <vector197>:
.globl vector197
vector197:
  pushl $0
80108fa3:	6a 00                	push   $0x0
  pushl $197
80108fa5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108faa:	e9 1b f2 ff ff       	jmp    801081ca <alltraps>

80108faf <vector198>:
.globl vector198
vector198:
  pushl $0
80108faf:	6a 00                	push   $0x0
  pushl $198
80108fb1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108fb6:	e9 0f f2 ff ff       	jmp    801081ca <alltraps>

80108fbb <vector199>:
.globl vector199
vector199:
  pushl $0
80108fbb:	6a 00                	push   $0x0
  pushl $199
80108fbd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108fc2:	e9 03 f2 ff ff       	jmp    801081ca <alltraps>

80108fc7 <vector200>:
.globl vector200
vector200:
  pushl $0
80108fc7:	6a 00                	push   $0x0
  pushl $200
80108fc9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108fce:	e9 f7 f1 ff ff       	jmp    801081ca <alltraps>

80108fd3 <vector201>:
.globl vector201
vector201:
  pushl $0
80108fd3:	6a 00                	push   $0x0
  pushl $201
80108fd5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108fda:	e9 eb f1 ff ff       	jmp    801081ca <alltraps>

80108fdf <vector202>:
.globl vector202
vector202:
  pushl $0
80108fdf:	6a 00                	push   $0x0
  pushl $202
80108fe1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108fe6:	e9 df f1 ff ff       	jmp    801081ca <alltraps>

80108feb <vector203>:
.globl vector203
vector203:
  pushl $0
80108feb:	6a 00                	push   $0x0
  pushl $203
80108fed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108ff2:	e9 d3 f1 ff ff       	jmp    801081ca <alltraps>

80108ff7 <vector204>:
.globl vector204
vector204:
  pushl $0
80108ff7:	6a 00                	push   $0x0
  pushl $204
80108ff9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108ffe:	e9 c7 f1 ff ff       	jmp    801081ca <alltraps>

80109003 <vector205>:
.globl vector205
vector205:
  pushl $0
80109003:	6a 00                	push   $0x0
  pushl $205
80109005:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010900a:	e9 bb f1 ff ff       	jmp    801081ca <alltraps>

8010900f <vector206>:
.globl vector206
vector206:
  pushl $0
8010900f:	6a 00                	push   $0x0
  pushl $206
80109011:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80109016:	e9 af f1 ff ff       	jmp    801081ca <alltraps>

8010901b <vector207>:
.globl vector207
vector207:
  pushl $0
8010901b:	6a 00                	push   $0x0
  pushl $207
8010901d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80109022:	e9 a3 f1 ff ff       	jmp    801081ca <alltraps>

80109027 <vector208>:
.globl vector208
vector208:
  pushl $0
80109027:	6a 00                	push   $0x0
  pushl $208
80109029:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010902e:	e9 97 f1 ff ff       	jmp    801081ca <alltraps>

80109033 <vector209>:
.globl vector209
vector209:
  pushl $0
80109033:	6a 00                	push   $0x0
  pushl $209
80109035:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010903a:	e9 8b f1 ff ff       	jmp    801081ca <alltraps>

8010903f <vector210>:
.globl vector210
vector210:
  pushl $0
8010903f:	6a 00                	push   $0x0
  pushl $210
80109041:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80109046:	e9 7f f1 ff ff       	jmp    801081ca <alltraps>

8010904b <vector211>:
.globl vector211
vector211:
  pushl $0
8010904b:	6a 00                	push   $0x0
  pushl $211
8010904d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80109052:	e9 73 f1 ff ff       	jmp    801081ca <alltraps>

80109057 <vector212>:
.globl vector212
vector212:
  pushl $0
80109057:	6a 00                	push   $0x0
  pushl $212
80109059:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010905e:	e9 67 f1 ff ff       	jmp    801081ca <alltraps>

80109063 <vector213>:
.globl vector213
vector213:
  pushl $0
80109063:	6a 00                	push   $0x0
  pushl $213
80109065:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010906a:	e9 5b f1 ff ff       	jmp    801081ca <alltraps>

8010906f <vector214>:
.globl vector214
vector214:
  pushl $0
8010906f:	6a 00                	push   $0x0
  pushl $214
80109071:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80109076:	e9 4f f1 ff ff       	jmp    801081ca <alltraps>

8010907b <vector215>:
.globl vector215
vector215:
  pushl $0
8010907b:	6a 00                	push   $0x0
  pushl $215
8010907d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80109082:	e9 43 f1 ff ff       	jmp    801081ca <alltraps>

80109087 <vector216>:
.globl vector216
vector216:
  pushl $0
80109087:	6a 00                	push   $0x0
  pushl $216
80109089:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010908e:	e9 37 f1 ff ff       	jmp    801081ca <alltraps>

80109093 <vector217>:
.globl vector217
vector217:
  pushl $0
80109093:	6a 00                	push   $0x0
  pushl $217
80109095:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010909a:	e9 2b f1 ff ff       	jmp    801081ca <alltraps>

8010909f <vector218>:
.globl vector218
vector218:
  pushl $0
8010909f:	6a 00                	push   $0x0
  pushl $218
801090a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801090a6:	e9 1f f1 ff ff       	jmp    801081ca <alltraps>

801090ab <vector219>:
.globl vector219
vector219:
  pushl $0
801090ab:	6a 00                	push   $0x0
  pushl $219
801090ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801090b2:	e9 13 f1 ff ff       	jmp    801081ca <alltraps>

801090b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801090b7:	6a 00                	push   $0x0
  pushl $220
801090b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801090be:	e9 07 f1 ff ff       	jmp    801081ca <alltraps>

801090c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801090c3:	6a 00                	push   $0x0
  pushl $221
801090c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801090ca:	e9 fb f0 ff ff       	jmp    801081ca <alltraps>

801090cf <vector222>:
.globl vector222
vector222:
  pushl $0
801090cf:	6a 00                	push   $0x0
  pushl $222
801090d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801090d6:	e9 ef f0 ff ff       	jmp    801081ca <alltraps>

801090db <vector223>:
.globl vector223
vector223:
  pushl $0
801090db:	6a 00                	push   $0x0
  pushl $223
801090dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801090e2:	e9 e3 f0 ff ff       	jmp    801081ca <alltraps>

801090e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801090e7:	6a 00                	push   $0x0
  pushl $224
801090e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801090ee:	e9 d7 f0 ff ff       	jmp    801081ca <alltraps>

801090f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801090f3:	6a 00                	push   $0x0
  pushl $225
801090f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801090fa:	e9 cb f0 ff ff       	jmp    801081ca <alltraps>

801090ff <vector226>:
.globl vector226
vector226:
  pushl $0
801090ff:	6a 00                	push   $0x0
  pushl $226
80109101:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80109106:	e9 bf f0 ff ff       	jmp    801081ca <alltraps>

8010910b <vector227>:
.globl vector227
vector227:
  pushl $0
8010910b:	6a 00                	push   $0x0
  pushl $227
8010910d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80109112:	e9 b3 f0 ff ff       	jmp    801081ca <alltraps>

80109117 <vector228>:
.globl vector228
vector228:
  pushl $0
80109117:	6a 00                	push   $0x0
  pushl $228
80109119:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010911e:	e9 a7 f0 ff ff       	jmp    801081ca <alltraps>

80109123 <vector229>:
.globl vector229
vector229:
  pushl $0
80109123:	6a 00                	push   $0x0
  pushl $229
80109125:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010912a:	e9 9b f0 ff ff       	jmp    801081ca <alltraps>

8010912f <vector230>:
.globl vector230
vector230:
  pushl $0
8010912f:	6a 00                	push   $0x0
  pushl $230
80109131:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80109136:	e9 8f f0 ff ff       	jmp    801081ca <alltraps>

8010913b <vector231>:
.globl vector231
vector231:
  pushl $0
8010913b:	6a 00                	push   $0x0
  pushl $231
8010913d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80109142:	e9 83 f0 ff ff       	jmp    801081ca <alltraps>

80109147 <vector232>:
.globl vector232
vector232:
  pushl $0
80109147:	6a 00                	push   $0x0
  pushl $232
80109149:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010914e:	e9 77 f0 ff ff       	jmp    801081ca <alltraps>

80109153 <vector233>:
.globl vector233
vector233:
  pushl $0
80109153:	6a 00                	push   $0x0
  pushl $233
80109155:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010915a:	e9 6b f0 ff ff       	jmp    801081ca <alltraps>

8010915f <vector234>:
.globl vector234
vector234:
  pushl $0
8010915f:	6a 00                	push   $0x0
  pushl $234
80109161:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80109166:	e9 5f f0 ff ff       	jmp    801081ca <alltraps>

8010916b <vector235>:
.globl vector235
vector235:
  pushl $0
8010916b:	6a 00                	push   $0x0
  pushl $235
8010916d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80109172:	e9 53 f0 ff ff       	jmp    801081ca <alltraps>

80109177 <vector236>:
.globl vector236
vector236:
  pushl $0
80109177:	6a 00                	push   $0x0
  pushl $236
80109179:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010917e:	e9 47 f0 ff ff       	jmp    801081ca <alltraps>

80109183 <vector237>:
.globl vector237
vector237:
  pushl $0
80109183:	6a 00                	push   $0x0
  pushl $237
80109185:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010918a:	e9 3b f0 ff ff       	jmp    801081ca <alltraps>

8010918f <vector238>:
.globl vector238
vector238:
  pushl $0
8010918f:	6a 00                	push   $0x0
  pushl $238
80109191:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80109196:	e9 2f f0 ff ff       	jmp    801081ca <alltraps>

8010919b <vector239>:
.globl vector239
vector239:
  pushl $0
8010919b:	6a 00                	push   $0x0
  pushl $239
8010919d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801091a2:	e9 23 f0 ff ff       	jmp    801081ca <alltraps>

801091a7 <vector240>:
.globl vector240
vector240:
  pushl $0
801091a7:	6a 00                	push   $0x0
  pushl $240
801091a9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801091ae:	e9 17 f0 ff ff       	jmp    801081ca <alltraps>

801091b3 <vector241>:
.globl vector241
vector241:
  pushl $0
801091b3:	6a 00                	push   $0x0
  pushl $241
801091b5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801091ba:	e9 0b f0 ff ff       	jmp    801081ca <alltraps>

801091bf <vector242>:
.globl vector242
vector242:
  pushl $0
801091bf:	6a 00                	push   $0x0
  pushl $242
801091c1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801091c6:	e9 ff ef ff ff       	jmp    801081ca <alltraps>

801091cb <vector243>:
.globl vector243
vector243:
  pushl $0
801091cb:	6a 00                	push   $0x0
  pushl $243
801091cd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801091d2:	e9 f3 ef ff ff       	jmp    801081ca <alltraps>

801091d7 <vector244>:
.globl vector244
vector244:
  pushl $0
801091d7:	6a 00                	push   $0x0
  pushl $244
801091d9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801091de:	e9 e7 ef ff ff       	jmp    801081ca <alltraps>

801091e3 <vector245>:
.globl vector245
vector245:
  pushl $0
801091e3:	6a 00                	push   $0x0
  pushl $245
801091e5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801091ea:	e9 db ef ff ff       	jmp    801081ca <alltraps>

801091ef <vector246>:
.globl vector246
vector246:
  pushl $0
801091ef:	6a 00                	push   $0x0
  pushl $246
801091f1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801091f6:	e9 cf ef ff ff       	jmp    801081ca <alltraps>

801091fb <vector247>:
.globl vector247
vector247:
  pushl $0
801091fb:	6a 00                	push   $0x0
  pushl $247
801091fd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80109202:	e9 c3 ef ff ff       	jmp    801081ca <alltraps>

80109207 <vector248>:
.globl vector248
vector248:
  pushl $0
80109207:	6a 00                	push   $0x0
  pushl $248
80109209:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010920e:	e9 b7 ef ff ff       	jmp    801081ca <alltraps>

80109213 <vector249>:
.globl vector249
vector249:
  pushl $0
80109213:	6a 00                	push   $0x0
  pushl $249
80109215:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010921a:	e9 ab ef ff ff       	jmp    801081ca <alltraps>

8010921f <vector250>:
.globl vector250
vector250:
  pushl $0
8010921f:	6a 00                	push   $0x0
  pushl $250
80109221:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80109226:	e9 9f ef ff ff       	jmp    801081ca <alltraps>

8010922b <vector251>:
.globl vector251
vector251:
  pushl $0
8010922b:	6a 00                	push   $0x0
  pushl $251
8010922d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80109232:	e9 93 ef ff ff       	jmp    801081ca <alltraps>

80109237 <vector252>:
.globl vector252
vector252:
  pushl $0
80109237:	6a 00                	push   $0x0
  pushl $252
80109239:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010923e:	e9 87 ef ff ff       	jmp    801081ca <alltraps>

80109243 <vector253>:
.globl vector253
vector253:
  pushl $0
80109243:	6a 00                	push   $0x0
  pushl $253
80109245:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010924a:	e9 7b ef ff ff       	jmp    801081ca <alltraps>

8010924f <vector254>:
.globl vector254
vector254:
  pushl $0
8010924f:	6a 00                	push   $0x0
  pushl $254
80109251:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80109256:	e9 6f ef ff ff       	jmp    801081ca <alltraps>

8010925b <vector255>:
.globl vector255
vector255:
  pushl $0
8010925b:	6a 00                	push   $0x0
  pushl $255
8010925d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80109262:	e9 63 ef ff ff       	jmp    801081ca <alltraps>

80109267 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80109267:	55                   	push   %ebp
80109268:	89 e5                	mov    %esp,%ebp
8010926a:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010926d:	8b 45 0c             	mov    0xc(%ebp),%eax
80109270:	83 e8 01             	sub    $0x1,%eax
80109273:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80109277:	8b 45 08             	mov    0x8(%ebp),%eax
8010927a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010927e:	8b 45 08             	mov    0x8(%ebp),%eax
80109281:	c1 e8 10             	shr    $0x10,%eax
80109284:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80109288:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010928b:	0f 01 10             	lgdtl  (%eax)
}
8010928e:	90                   	nop
8010928f:	c9                   	leave  
80109290:	c3                   	ret    

80109291 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80109291:	55                   	push   %ebp
80109292:	89 e5                	mov    %esp,%ebp
80109294:	83 ec 04             	sub    $0x4,%esp
80109297:	8b 45 08             	mov    0x8(%ebp),%eax
8010929a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010929e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801092a2:	0f 00 d8             	ltr    %ax
}
801092a5:	90                   	nop
801092a6:	c9                   	leave  
801092a7:	c3                   	ret    

801092a8 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801092a8:	55                   	push   %ebp
801092a9:	89 e5                	mov    %esp,%ebp
801092ab:	83 ec 04             	sub    $0x4,%esp
801092ae:	8b 45 08             	mov    0x8(%ebp),%eax
801092b1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801092b5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801092b9:	8e e8                	mov    %eax,%gs
}
801092bb:	90                   	nop
801092bc:	c9                   	leave  
801092bd:	c3                   	ret    

801092be <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801092be:	55                   	push   %ebp
801092bf:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801092c1:	8b 45 08             	mov    0x8(%ebp),%eax
801092c4:	0f 22 d8             	mov    %eax,%cr3
}
801092c7:	90                   	nop
801092c8:	5d                   	pop    %ebp
801092c9:	c3                   	ret    

801092ca <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801092ca:	55                   	push   %ebp
801092cb:	89 e5                	mov    %esp,%ebp
801092cd:	8b 45 08             	mov    0x8(%ebp),%eax
801092d0:	05 00 00 00 80       	add    $0x80000000,%eax
801092d5:	5d                   	pop    %ebp
801092d6:	c3                   	ret    

801092d7 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801092d7:	55                   	push   %ebp
801092d8:	89 e5                	mov    %esp,%ebp
801092da:	8b 45 08             	mov    0x8(%ebp),%eax
801092dd:	05 00 00 00 80       	add    $0x80000000,%eax
801092e2:	5d                   	pop    %ebp
801092e3:	c3                   	ret    

801092e4 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801092e4:	55                   	push   %ebp
801092e5:	89 e5                	mov    %esp,%ebp
801092e7:	53                   	push   %ebx
801092e8:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801092eb:	e8 f6 9f ff ff       	call   801032e6 <cpunum>
801092f0:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801092f6:	05 a0 43 11 80       	add    $0x801143a0,%eax
801092fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801092fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109301:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80109307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010930a:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80109310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109313:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80109317:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010931e:	83 e2 f0             	and    $0xfffffff0,%edx
80109321:	83 ca 0a             	or     $0xa,%edx
80109324:	88 50 7d             	mov    %dl,0x7d(%eax)
80109327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010932a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010932e:	83 ca 10             	or     $0x10,%edx
80109331:	88 50 7d             	mov    %dl,0x7d(%eax)
80109334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109337:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010933b:	83 e2 9f             	and    $0xffffff9f,%edx
8010933e:	88 50 7d             	mov    %dl,0x7d(%eax)
80109341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109344:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109348:	83 ca 80             	or     $0xffffff80,%edx
8010934b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010934e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109351:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109355:	83 ca 0f             	or     $0xf,%edx
80109358:	88 50 7e             	mov    %dl,0x7e(%eax)
8010935b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010935e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109362:	83 e2 ef             	and    $0xffffffef,%edx
80109365:	88 50 7e             	mov    %dl,0x7e(%eax)
80109368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010936b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010936f:	83 e2 df             	and    $0xffffffdf,%edx
80109372:	88 50 7e             	mov    %dl,0x7e(%eax)
80109375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109378:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010937c:	83 ca 40             	or     $0x40,%edx
8010937f:	88 50 7e             	mov    %dl,0x7e(%eax)
80109382:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109385:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109389:	83 ca 80             	or     $0xffffff80,%edx
8010938c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010938f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109392:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80109396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109399:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801093a0:	ff ff 
801093a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a5:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801093ac:	00 00 
801093ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093b1:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801093b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093bb:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093c2:	83 e2 f0             	and    $0xfffffff0,%edx
801093c5:	83 ca 02             	or     $0x2,%edx
801093c8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801093ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093d1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093d8:	83 ca 10             	or     $0x10,%edx
801093db:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801093e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093e4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093eb:	83 e2 9f             	and    $0xffffff9f,%edx
801093ee:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801093f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093f7:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093fe:	83 ca 80             	or     $0xffffff80,%edx
80109401:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010940a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109411:	83 ca 0f             	or     $0xf,%edx
80109414:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010941a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010941d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109424:	83 e2 ef             	and    $0xffffffef,%edx
80109427:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010942d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109430:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109437:	83 e2 df             	and    $0xffffffdf,%edx
8010943a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109440:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109443:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010944a:	83 ca 40             	or     $0x40,%edx
8010944d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109456:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010945d:	83 ca 80             	or     $0xffffff80,%edx
80109460:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109469:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80109470:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109473:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010947a:	ff ff 
8010947c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010947f:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80109486:	00 00 
80109488:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010948b:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80109492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109495:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010949c:	83 e2 f0             	and    $0xfffffff0,%edx
8010949f:	83 ca 0a             	or     $0xa,%edx
801094a2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ab:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801094b2:	83 ca 10             	or     $0x10,%edx
801094b5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094be:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801094c5:	83 ca 60             	or     $0x60,%edx
801094c8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094d1:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801094d8:	83 ca 80             	or     $0xffffff80,%edx
801094db:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801094eb:	83 ca 0f             	or     $0xf,%edx
801094ee:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801094f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094f7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801094fe:	83 e2 ef             	and    $0xffffffef,%edx
80109501:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010950a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109511:	83 e2 df             	and    $0xffffffdf,%edx
80109514:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010951a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010951d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109524:	83 ca 40             	or     $0x40,%edx
80109527:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010952d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109530:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109537:	83 ca 80             	or     $0xffffff80,%edx
8010953a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109543:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010954a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010954d:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80109554:	ff ff 
80109556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109559:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80109560:	00 00 
80109562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109565:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010956c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010956f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109576:	83 e2 f0             	and    $0xfffffff0,%edx
80109579:	83 ca 02             	or     $0x2,%edx
8010957c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109585:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010958c:	83 ca 10             	or     $0x10,%edx
8010958f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109595:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109598:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010959f:	83 ca 60             	or     $0x60,%edx
801095a2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801095a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ab:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801095b2:	83 ca 80             	or     $0xffffff80,%edx
801095b5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801095bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095be:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095c5:	83 ca 0f             	or     $0xf,%edx
801095c8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801095ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095d1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095d8:	83 e2 ef             	and    $0xffffffef,%edx
801095db:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801095e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095eb:	83 e2 df             	and    $0xffffffdf,%edx
801095ee:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801095f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095fe:	83 ca 40             	or     $0x40,%edx
80109601:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010960a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109611:	83 ca 80             	or     $0xffffff80,%edx
80109614:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010961a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010961d:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80109624:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109627:	05 b4 00 00 00       	add    $0xb4,%eax
8010962c:	89 c3                	mov    %eax,%ebx
8010962e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109631:	05 b4 00 00 00       	add    $0xb4,%eax
80109636:	c1 e8 10             	shr    $0x10,%eax
80109639:	89 c2                	mov    %eax,%edx
8010963b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010963e:	05 b4 00 00 00       	add    $0xb4,%eax
80109643:	c1 e8 18             	shr    $0x18,%eax
80109646:	89 c1                	mov    %eax,%ecx
80109648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010964b:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80109652:	00 00 
80109654:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109657:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010965e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109661:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80109667:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010966a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109671:	83 e2 f0             	and    $0xfffffff0,%edx
80109674:	83 ca 02             	or     $0x2,%edx
80109677:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010967d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109680:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109687:	83 ca 10             	or     $0x10,%edx
8010968a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109693:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010969a:	83 e2 9f             	and    $0xffffff9f,%edx
8010969d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801096a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a6:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801096ad:	83 ca 80             	or     $0xffffff80,%edx
801096b0:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801096b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096b9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096c0:	83 e2 f0             	and    $0xfffffff0,%edx
801096c3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096cc:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096d3:	83 e2 ef             	and    $0xffffffef,%edx
801096d6:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096df:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096e6:	83 e2 df             	and    $0xffffffdf,%edx
801096e9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096f2:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096f9:	83 ca 40             	or     $0x40,%edx
801096fc:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109705:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010970c:	83 ca 80             	or     $0xffffff80,%edx
8010970f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109718:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010971e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109721:	83 c0 70             	add    $0x70,%eax
80109724:	83 ec 08             	sub    $0x8,%esp
80109727:	6a 38                	push   $0x38
80109729:	50                   	push   %eax
8010972a:	e8 38 fb ff ff       	call   80109267 <lgdt>
8010972f:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80109732:	83 ec 0c             	sub    $0xc,%esp
80109735:	6a 18                	push   $0x18
80109737:	e8 6c fb ff ff       	call   801092a8 <loadgs>
8010973c:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
8010973f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109742:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80109748:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010974f:	00 00 00 00 
}
80109753:	90                   	nop
80109754:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109757:	c9                   	leave  
80109758:	c3                   	ret    

80109759 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80109759:	55                   	push   %ebp
8010975a:	89 e5                	mov    %esp,%ebp
8010975c:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010975f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109762:	c1 e8 16             	shr    $0x16,%eax
80109765:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010976c:	8b 45 08             	mov    0x8(%ebp),%eax
8010976f:	01 d0                	add    %edx,%eax
80109771:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80109774:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109777:	8b 00                	mov    (%eax),%eax
80109779:	83 e0 01             	and    $0x1,%eax
8010977c:	85 c0                	test   %eax,%eax
8010977e:	74 18                	je     80109798 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80109780:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109783:	8b 00                	mov    (%eax),%eax
80109785:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010978a:	50                   	push   %eax
8010978b:	e8 47 fb ff ff       	call   801092d7 <p2v>
80109790:	83 c4 04             	add    $0x4,%esp
80109793:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109796:	eb 48                	jmp    801097e0 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80109798:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010979c:	74 0e                	je     801097ac <walkpgdir+0x53>
8010979e:	e8 dd 97 ff ff       	call   80102f80 <kalloc>
801097a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801097a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801097aa:	75 07                	jne    801097b3 <walkpgdir+0x5a>
      return 0;
801097ac:	b8 00 00 00 00       	mov    $0x0,%eax
801097b1:	eb 44                	jmp    801097f7 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801097b3:	83 ec 04             	sub    $0x4,%esp
801097b6:	68 00 10 00 00       	push   $0x1000
801097bb:	6a 00                	push   $0x0
801097bd:	ff 75 f4             	pushl  -0xc(%ebp)
801097c0:	e8 57 d3 ff ff       	call   80106b1c <memset>
801097c5:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801097c8:	83 ec 0c             	sub    $0xc,%esp
801097cb:	ff 75 f4             	pushl  -0xc(%ebp)
801097ce:	e8 f7 fa ff ff       	call   801092ca <v2p>
801097d3:	83 c4 10             	add    $0x10,%esp
801097d6:	83 c8 07             	or     $0x7,%eax
801097d9:	89 c2                	mov    %eax,%edx
801097db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097de:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801097e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801097e3:	c1 e8 0c             	shr    $0xc,%eax
801097e6:	25 ff 03 00 00       	and    $0x3ff,%eax
801097eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801097f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097f5:	01 d0                	add    %edx,%eax
}
801097f7:	c9                   	leave  
801097f8:	c3                   	ret    

801097f9 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801097f9:	55                   	push   %ebp
801097fa:	89 e5                	mov    %esp,%ebp
801097fc:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801097ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80109802:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109807:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010980a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010980d:	8b 45 10             	mov    0x10(%ebp),%eax
80109810:	01 d0                	add    %edx,%eax
80109812:	83 e8 01             	sub    $0x1,%eax
80109815:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010981a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010981d:	83 ec 04             	sub    $0x4,%esp
80109820:	6a 01                	push   $0x1
80109822:	ff 75 f4             	pushl  -0xc(%ebp)
80109825:	ff 75 08             	pushl  0x8(%ebp)
80109828:	e8 2c ff ff ff       	call   80109759 <walkpgdir>
8010982d:	83 c4 10             	add    $0x10,%esp
80109830:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109833:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109837:	75 07                	jne    80109840 <mappages+0x47>
      return -1;
80109839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010983e:	eb 47                	jmp    80109887 <mappages+0x8e>
    if(*pte & PTE_P)
80109840:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109843:	8b 00                	mov    (%eax),%eax
80109845:	83 e0 01             	and    $0x1,%eax
80109848:	85 c0                	test   %eax,%eax
8010984a:	74 0d                	je     80109859 <mappages+0x60>
      panic("remap");
8010984c:	83 ec 0c             	sub    $0xc,%esp
8010984f:	68 88 a8 10 80       	push   $0x8010a888
80109854:	e8 0d 6d ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80109859:	8b 45 18             	mov    0x18(%ebp),%eax
8010985c:	0b 45 14             	or     0x14(%ebp),%eax
8010985f:	83 c8 01             	or     $0x1,%eax
80109862:	89 c2                	mov    %eax,%edx
80109864:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109867:	89 10                	mov    %edx,(%eax)
    if(a == last)
80109869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010986c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010986f:	74 10                	je     80109881 <mappages+0x88>
      break;
    a += PGSIZE;
80109871:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109878:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010987f:	eb 9c                	jmp    8010981d <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80109881:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109882:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109887:	c9                   	leave  
80109888:	c3                   	ret    

80109889 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80109889:	55                   	push   %ebp
8010988a:	89 e5                	mov    %esp,%ebp
8010988c:	53                   	push   %ebx
8010988d:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80109890:	e8 eb 96 ff ff       	call   80102f80 <kalloc>
80109895:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109898:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010989c:	75 0a                	jne    801098a8 <setupkvm+0x1f>
    return 0;
8010989e:	b8 00 00 00 00       	mov    $0x0,%eax
801098a3:	e9 8e 00 00 00       	jmp    80109936 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801098a8:	83 ec 04             	sub    $0x4,%esp
801098ab:	68 00 10 00 00       	push   $0x1000
801098b0:	6a 00                	push   $0x0
801098b2:	ff 75 f0             	pushl  -0x10(%ebp)
801098b5:	e8 62 d2 ff ff       	call   80106b1c <memset>
801098ba:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801098bd:	83 ec 0c             	sub    $0xc,%esp
801098c0:	68 00 00 00 0e       	push   $0xe000000
801098c5:	e8 0d fa ff ff       	call   801092d7 <p2v>
801098ca:	83 c4 10             	add    $0x10,%esp
801098cd:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801098d2:	76 0d                	jbe    801098e1 <setupkvm+0x58>
    panic("PHYSTOP too high");
801098d4:	83 ec 0c             	sub    $0xc,%esp
801098d7:	68 8e a8 10 80       	push   $0x8010a88e
801098dc:	e8 85 6c ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801098e1:	c7 45 f4 e0 d4 10 80 	movl   $0x8010d4e0,-0xc(%ebp)
801098e8:	eb 40                	jmp    8010992a <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801098ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098ed:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801098f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098f3:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801098f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098f9:	8b 58 08             	mov    0x8(%eax),%ebx
801098fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098ff:	8b 40 04             	mov    0x4(%eax),%eax
80109902:	29 c3                	sub    %eax,%ebx
80109904:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109907:	8b 00                	mov    (%eax),%eax
80109909:	83 ec 0c             	sub    $0xc,%esp
8010990c:	51                   	push   %ecx
8010990d:	52                   	push   %edx
8010990e:	53                   	push   %ebx
8010990f:	50                   	push   %eax
80109910:	ff 75 f0             	pushl  -0x10(%ebp)
80109913:	e8 e1 fe ff ff       	call   801097f9 <mappages>
80109918:	83 c4 20             	add    $0x20,%esp
8010991b:	85 c0                	test   %eax,%eax
8010991d:	79 07                	jns    80109926 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010991f:	b8 00 00 00 00       	mov    $0x0,%eax
80109924:	eb 10                	jmp    80109936 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109926:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010992a:	81 7d f4 20 d5 10 80 	cmpl   $0x8010d520,-0xc(%ebp)
80109931:	72 b7                	jb     801098ea <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109933:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109939:	c9                   	leave  
8010993a:	c3                   	ret    

8010993b <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010993b:	55                   	push   %ebp
8010993c:	89 e5                	mov    %esp,%ebp
8010993e:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109941:	e8 43 ff ff ff       	call   80109889 <setupkvm>
80109946:	a3 78 79 11 80       	mov    %eax,0x80117978
  switchkvm();
8010994b:	e8 03 00 00 00       	call   80109953 <switchkvm>
}
80109950:	90                   	nop
80109951:	c9                   	leave  
80109952:	c3                   	ret    

80109953 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109953:	55                   	push   %ebp
80109954:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109956:	a1 78 79 11 80       	mov    0x80117978,%eax
8010995b:	50                   	push   %eax
8010995c:	e8 69 f9 ff ff       	call   801092ca <v2p>
80109961:	83 c4 04             	add    $0x4,%esp
80109964:	50                   	push   %eax
80109965:	e8 54 f9 ff ff       	call   801092be <lcr3>
8010996a:	83 c4 04             	add    $0x4,%esp
}
8010996d:	90                   	nop
8010996e:	c9                   	leave  
8010996f:	c3                   	ret    

80109970 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109970:	55                   	push   %ebp
80109971:	89 e5                	mov    %esp,%ebp
80109973:	56                   	push   %esi
80109974:	53                   	push   %ebx
  pushcli();
80109975:	e8 9c d0 ff ff       	call   80106a16 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010997a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109980:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109987:	83 c2 08             	add    $0x8,%edx
8010998a:	89 d6                	mov    %edx,%esi
8010998c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109993:	83 c2 08             	add    $0x8,%edx
80109996:	c1 ea 10             	shr    $0x10,%edx
80109999:	89 d3                	mov    %edx,%ebx
8010999b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801099a2:	83 c2 08             	add    $0x8,%edx
801099a5:	c1 ea 18             	shr    $0x18,%edx
801099a8:	89 d1                	mov    %edx,%ecx
801099aa:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801099b1:	67 00 
801099b3:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801099ba:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801099c0:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099c7:	83 e2 f0             	and    $0xfffffff0,%edx
801099ca:	83 ca 09             	or     $0x9,%edx
801099cd:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801099d3:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099da:	83 ca 10             	or     $0x10,%edx
801099dd:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801099e3:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099ea:	83 e2 9f             	and    $0xffffff9f,%edx
801099ed:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801099f3:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099fa:	83 ca 80             	or     $0xffffff80,%edx
801099fd:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109a03:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a0a:	83 e2 f0             	and    $0xfffffff0,%edx
80109a0d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a13:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a1a:	83 e2 ef             	and    $0xffffffef,%edx
80109a1d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a23:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a2a:	83 e2 df             	and    $0xffffffdf,%edx
80109a2d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a33:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a3a:	83 ca 40             	or     $0x40,%edx
80109a3d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a43:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a4a:	83 e2 7f             	and    $0x7f,%edx
80109a4d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a53:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80109a59:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109a5f:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109a66:	83 e2 ef             	and    $0xffffffef,%edx
80109a69:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109a6f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109a75:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80109a7b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109a81:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109a88:	8b 52 08             	mov    0x8(%edx),%edx
80109a8b:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109a91:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109a94:	83 ec 0c             	sub    $0xc,%esp
80109a97:	6a 30                	push   $0x30
80109a99:	e8 f3 f7 ff ff       	call   80109291 <ltr>
80109a9e:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109aa1:	8b 45 08             	mov    0x8(%ebp),%eax
80109aa4:	8b 40 04             	mov    0x4(%eax),%eax
80109aa7:	85 c0                	test   %eax,%eax
80109aa9:	75 0d                	jne    80109ab8 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80109aab:	83 ec 0c             	sub    $0xc,%esp
80109aae:	68 9f a8 10 80       	push   $0x8010a89f
80109ab3:	e8 ae 6a ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80109abb:	8b 40 04             	mov    0x4(%eax),%eax
80109abe:	83 ec 0c             	sub    $0xc,%esp
80109ac1:	50                   	push   %eax
80109ac2:	e8 03 f8 ff ff       	call   801092ca <v2p>
80109ac7:	83 c4 10             	add    $0x10,%esp
80109aca:	83 ec 0c             	sub    $0xc,%esp
80109acd:	50                   	push   %eax
80109ace:	e8 eb f7 ff ff       	call   801092be <lcr3>
80109ad3:	83 c4 10             	add    $0x10,%esp
  popcli();
80109ad6:	e8 80 cf ff ff       	call   80106a5b <popcli>
}
80109adb:	90                   	nop
80109adc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109adf:	5b                   	pop    %ebx
80109ae0:	5e                   	pop    %esi
80109ae1:	5d                   	pop    %ebp
80109ae2:	c3                   	ret    

80109ae3 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109ae3:	55                   	push   %ebp
80109ae4:	89 e5                	mov    %esp,%ebp
80109ae6:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80109ae9:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109af0:	76 0d                	jbe    80109aff <inituvm+0x1c>
    panic("inituvm: more than a page");
80109af2:	83 ec 0c             	sub    $0xc,%esp
80109af5:	68 b3 a8 10 80       	push   $0x8010a8b3
80109afa:	e8 67 6a ff ff       	call   80100566 <panic>
  mem = kalloc();
80109aff:	e8 7c 94 ff ff       	call   80102f80 <kalloc>
80109b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80109b07:	83 ec 04             	sub    $0x4,%esp
80109b0a:	68 00 10 00 00       	push   $0x1000
80109b0f:	6a 00                	push   $0x0
80109b11:	ff 75 f4             	pushl  -0xc(%ebp)
80109b14:	e8 03 d0 ff ff       	call   80106b1c <memset>
80109b19:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109b1c:	83 ec 0c             	sub    $0xc,%esp
80109b1f:	ff 75 f4             	pushl  -0xc(%ebp)
80109b22:	e8 a3 f7 ff ff       	call   801092ca <v2p>
80109b27:	83 c4 10             	add    $0x10,%esp
80109b2a:	83 ec 0c             	sub    $0xc,%esp
80109b2d:	6a 06                	push   $0x6
80109b2f:	50                   	push   %eax
80109b30:	68 00 10 00 00       	push   $0x1000
80109b35:	6a 00                	push   $0x0
80109b37:	ff 75 08             	pushl  0x8(%ebp)
80109b3a:	e8 ba fc ff ff       	call   801097f9 <mappages>
80109b3f:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109b42:	83 ec 04             	sub    $0x4,%esp
80109b45:	ff 75 10             	pushl  0x10(%ebp)
80109b48:	ff 75 0c             	pushl  0xc(%ebp)
80109b4b:	ff 75 f4             	pushl  -0xc(%ebp)
80109b4e:	e8 88 d0 ff ff       	call   80106bdb <memmove>
80109b53:	83 c4 10             	add    $0x10,%esp
}
80109b56:	90                   	nop
80109b57:	c9                   	leave  
80109b58:	c3                   	ret    

80109b59 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109b59:	55                   	push   %ebp
80109b5a:	89 e5                	mov    %esp,%ebp
80109b5c:	53                   	push   %ebx
80109b5d:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109b60:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b63:	25 ff 0f 00 00       	and    $0xfff,%eax
80109b68:	85 c0                	test   %eax,%eax
80109b6a:	74 0d                	je     80109b79 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109b6c:	83 ec 0c             	sub    $0xc,%esp
80109b6f:	68 d0 a8 10 80       	push   $0x8010a8d0
80109b74:	e8 ed 69 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109b80:	e9 95 00 00 00       	jmp    80109c1a <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109b85:	8b 55 0c             	mov    0xc(%ebp),%edx
80109b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b8b:	01 d0                	add    %edx,%eax
80109b8d:	83 ec 04             	sub    $0x4,%esp
80109b90:	6a 00                	push   $0x0
80109b92:	50                   	push   %eax
80109b93:	ff 75 08             	pushl  0x8(%ebp)
80109b96:	e8 be fb ff ff       	call   80109759 <walkpgdir>
80109b9b:	83 c4 10             	add    $0x10,%esp
80109b9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109ba1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109ba5:	75 0d                	jne    80109bb4 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109ba7:	83 ec 0c             	sub    $0xc,%esp
80109baa:	68 f3 a8 10 80       	push   $0x8010a8f3
80109baf:	e8 b2 69 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109bb7:	8b 00                	mov    (%eax),%eax
80109bb9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109bbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109bc1:	8b 45 18             	mov    0x18(%ebp),%eax
80109bc4:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109bc7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109bcc:	77 0b                	ja     80109bd9 <loaduvm+0x80>
      n = sz - i;
80109bce:	8b 45 18             	mov    0x18(%ebp),%eax
80109bd1:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109bd7:	eb 07                	jmp    80109be0 <loaduvm+0x87>
    else
      n = PGSIZE;
80109bd9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109be0:	8b 55 14             	mov    0x14(%ebp),%edx
80109be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109be6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109be9:	83 ec 0c             	sub    $0xc,%esp
80109bec:	ff 75 e8             	pushl  -0x18(%ebp)
80109bef:	e8 e3 f6 ff ff       	call   801092d7 <p2v>
80109bf4:	83 c4 10             	add    $0x10,%esp
80109bf7:	ff 75 f0             	pushl  -0x10(%ebp)
80109bfa:	53                   	push   %ebx
80109bfb:	50                   	push   %eax
80109bfc:	ff 75 10             	pushl  0x10(%ebp)
80109bff:	e8 a1 84 ff ff       	call   801020a5 <readi>
80109c04:	83 c4 10             	add    $0x10,%esp
80109c07:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109c0a:	74 07                	je     80109c13 <loaduvm+0xba>
      return -1;
80109c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109c11:	eb 18                	jmp    80109c2b <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109c13:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c1d:	3b 45 18             	cmp    0x18(%ebp),%eax
80109c20:	0f 82 5f ff ff ff    	jb     80109b85 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109c26:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109c2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109c2e:	c9                   	leave  
80109c2f:	c3                   	ret    

80109c30 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109c30:	55                   	push   %ebp
80109c31:	89 e5                	mov    %esp,%ebp
80109c33:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109c36:	8b 45 10             	mov    0x10(%ebp),%eax
80109c39:	85 c0                	test   %eax,%eax
80109c3b:	79 0a                	jns    80109c47 <allocuvm+0x17>
    return 0;
80109c3d:	b8 00 00 00 00       	mov    $0x0,%eax
80109c42:	e9 b0 00 00 00       	jmp    80109cf7 <allocuvm+0xc7>
  if(newsz < oldsz)
80109c47:	8b 45 10             	mov    0x10(%ebp),%eax
80109c4a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109c4d:	73 08                	jae    80109c57 <allocuvm+0x27>
    return oldsz;
80109c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c52:	e9 a0 00 00 00       	jmp    80109cf7 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109c57:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c5a:	05 ff 0f 00 00       	add    $0xfff,%eax
80109c5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109c67:	eb 7f                	jmp    80109ce8 <allocuvm+0xb8>
    mem = kalloc();
80109c69:	e8 12 93 ff ff       	call   80102f80 <kalloc>
80109c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109c71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109c75:	75 2b                	jne    80109ca2 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109c77:	83 ec 0c             	sub    $0xc,%esp
80109c7a:	68 11 a9 10 80       	push   $0x8010a911
80109c7f:	e8 42 67 ff ff       	call   801003c6 <cprintf>
80109c84:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109c87:	83 ec 04             	sub    $0x4,%esp
80109c8a:	ff 75 0c             	pushl  0xc(%ebp)
80109c8d:	ff 75 10             	pushl  0x10(%ebp)
80109c90:	ff 75 08             	pushl  0x8(%ebp)
80109c93:	e8 61 00 00 00       	call   80109cf9 <deallocuvm>
80109c98:	83 c4 10             	add    $0x10,%esp
      return 0;
80109c9b:	b8 00 00 00 00       	mov    $0x0,%eax
80109ca0:	eb 55                	jmp    80109cf7 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109ca2:	83 ec 04             	sub    $0x4,%esp
80109ca5:	68 00 10 00 00       	push   $0x1000
80109caa:	6a 00                	push   $0x0
80109cac:	ff 75 f0             	pushl  -0x10(%ebp)
80109caf:	e8 68 ce ff ff       	call   80106b1c <memset>
80109cb4:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109cb7:	83 ec 0c             	sub    $0xc,%esp
80109cba:	ff 75 f0             	pushl  -0x10(%ebp)
80109cbd:	e8 08 f6 ff ff       	call   801092ca <v2p>
80109cc2:	83 c4 10             	add    $0x10,%esp
80109cc5:	89 c2                	mov    %eax,%edx
80109cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cca:	83 ec 0c             	sub    $0xc,%esp
80109ccd:	6a 06                	push   $0x6
80109ccf:	52                   	push   %edx
80109cd0:	68 00 10 00 00       	push   $0x1000
80109cd5:	50                   	push   %eax
80109cd6:	ff 75 08             	pushl  0x8(%ebp)
80109cd9:	e8 1b fb ff ff       	call   801097f9 <mappages>
80109cde:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109ce1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ceb:	3b 45 10             	cmp    0x10(%ebp),%eax
80109cee:	0f 82 75 ff ff ff    	jb     80109c69 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109cf4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109cf7:	c9                   	leave  
80109cf8:	c3                   	ret    

80109cf9 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109cf9:	55                   	push   %ebp
80109cfa:	89 e5                	mov    %esp,%ebp
80109cfc:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109cff:	8b 45 10             	mov    0x10(%ebp),%eax
80109d02:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109d05:	72 08                	jb     80109d0f <deallocuvm+0x16>
    return oldsz;
80109d07:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d0a:	e9 a5 00 00 00       	jmp    80109db4 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109d0f:	8b 45 10             	mov    0x10(%ebp),%eax
80109d12:	05 ff 0f 00 00       	add    $0xfff,%eax
80109d17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109d1f:	e9 81 00 00 00       	jmp    80109da5 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d27:	83 ec 04             	sub    $0x4,%esp
80109d2a:	6a 00                	push   $0x0
80109d2c:	50                   	push   %eax
80109d2d:	ff 75 08             	pushl  0x8(%ebp)
80109d30:	e8 24 fa ff ff       	call   80109759 <walkpgdir>
80109d35:	83 c4 10             	add    $0x10,%esp
80109d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109d3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109d3f:	75 09                	jne    80109d4a <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109d41:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109d48:	eb 54                	jmp    80109d9e <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d4d:	8b 00                	mov    (%eax),%eax
80109d4f:	83 e0 01             	and    $0x1,%eax
80109d52:	85 c0                	test   %eax,%eax
80109d54:	74 48                	je     80109d9e <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d59:	8b 00                	mov    (%eax),%eax
80109d5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109d60:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109d63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109d67:	75 0d                	jne    80109d76 <deallocuvm+0x7d>
        panic("kfree");
80109d69:	83 ec 0c             	sub    $0xc,%esp
80109d6c:	68 29 a9 10 80       	push   $0x8010a929
80109d71:	e8 f0 67 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109d76:	83 ec 0c             	sub    $0xc,%esp
80109d79:	ff 75 ec             	pushl  -0x14(%ebp)
80109d7c:	e8 56 f5 ff ff       	call   801092d7 <p2v>
80109d81:	83 c4 10             	add    $0x10,%esp
80109d84:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109d87:	83 ec 0c             	sub    $0xc,%esp
80109d8a:	ff 75 e8             	pushl  -0x18(%ebp)
80109d8d:	e8 51 91 ff ff       	call   80102ee3 <kfree>
80109d92:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109d9e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109da8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109dab:	0f 82 73 ff ff ff    	jb     80109d24 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109db1:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109db4:	c9                   	leave  
80109db5:	c3                   	ret    

80109db6 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109db6:	55                   	push   %ebp
80109db7:	89 e5                	mov    %esp,%ebp
80109db9:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109dbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109dc0:	75 0d                	jne    80109dcf <freevm+0x19>
    panic("freevm: no pgdir");
80109dc2:	83 ec 0c             	sub    $0xc,%esp
80109dc5:	68 2f a9 10 80       	push   $0x8010a92f
80109dca:	e8 97 67 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109dcf:	83 ec 04             	sub    $0x4,%esp
80109dd2:	6a 00                	push   $0x0
80109dd4:	68 00 00 00 80       	push   $0x80000000
80109dd9:	ff 75 08             	pushl  0x8(%ebp)
80109ddc:	e8 18 ff ff ff       	call   80109cf9 <deallocuvm>
80109de1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109de4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109deb:	eb 4f                	jmp    80109e3c <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109df0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109df7:	8b 45 08             	mov    0x8(%ebp),%eax
80109dfa:	01 d0                	add    %edx,%eax
80109dfc:	8b 00                	mov    (%eax),%eax
80109dfe:	83 e0 01             	and    $0x1,%eax
80109e01:	85 c0                	test   %eax,%eax
80109e03:	74 33                	je     80109e38 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80109e12:	01 d0                	add    %edx,%eax
80109e14:	8b 00                	mov    (%eax),%eax
80109e16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109e1b:	83 ec 0c             	sub    $0xc,%esp
80109e1e:	50                   	push   %eax
80109e1f:	e8 b3 f4 ff ff       	call   801092d7 <p2v>
80109e24:	83 c4 10             	add    $0x10,%esp
80109e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109e2a:	83 ec 0c             	sub    $0xc,%esp
80109e2d:	ff 75 f0             	pushl  -0x10(%ebp)
80109e30:	e8 ae 90 ff ff       	call   80102ee3 <kfree>
80109e35:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109e38:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109e3c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109e43:	76 a8                	jbe    80109ded <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109e45:	83 ec 0c             	sub    $0xc,%esp
80109e48:	ff 75 08             	pushl  0x8(%ebp)
80109e4b:	e8 93 90 ff ff       	call   80102ee3 <kfree>
80109e50:	83 c4 10             	add    $0x10,%esp
}
80109e53:	90                   	nop
80109e54:	c9                   	leave  
80109e55:	c3                   	ret    

80109e56 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109e56:	55                   	push   %ebp
80109e57:	89 e5                	mov    %esp,%ebp
80109e59:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109e5c:	83 ec 04             	sub    $0x4,%esp
80109e5f:	6a 00                	push   $0x0
80109e61:	ff 75 0c             	pushl  0xc(%ebp)
80109e64:	ff 75 08             	pushl  0x8(%ebp)
80109e67:	e8 ed f8 ff ff       	call   80109759 <walkpgdir>
80109e6c:	83 c4 10             	add    $0x10,%esp
80109e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109e72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109e76:	75 0d                	jne    80109e85 <clearpteu+0x2f>
    panic("clearpteu");
80109e78:	83 ec 0c             	sub    $0xc,%esp
80109e7b:	68 40 a9 10 80       	push   $0x8010a940
80109e80:	e8 e1 66 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e88:	8b 00                	mov    (%eax),%eax
80109e8a:	83 e0 fb             	and    $0xfffffffb,%eax
80109e8d:	89 c2                	mov    %eax,%edx
80109e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e92:	89 10                	mov    %edx,(%eax)
}
80109e94:	90                   	nop
80109e95:	c9                   	leave  
80109e96:	c3                   	ret    

80109e97 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109e97:	55                   	push   %ebp
80109e98:	89 e5                	mov    %esp,%ebp
80109e9a:	53                   	push   %ebx
80109e9b:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109e9e:	e8 e6 f9 ff ff       	call   80109889 <setupkvm>
80109ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109ea6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109eaa:	75 0a                	jne    80109eb6 <copyuvm+0x1f>
    return 0;
80109eac:	b8 00 00 00 00       	mov    $0x0,%eax
80109eb1:	e9 f8 00 00 00       	jmp    80109fae <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109eb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109ebd:	e9 c4 00 00 00       	jmp    80109f86 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ec5:	83 ec 04             	sub    $0x4,%esp
80109ec8:	6a 00                	push   $0x0
80109eca:	50                   	push   %eax
80109ecb:	ff 75 08             	pushl  0x8(%ebp)
80109ece:	e8 86 f8 ff ff       	call   80109759 <walkpgdir>
80109ed3:	83 c4 10             	add    $0x10,%esp
80109ed6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109ed9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109edd:	75 0d                	jne    80109eec <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109edf:	83 ec 0c             	sub    $0xc,%esp
80109ee2:	68 4a a9 10 80       	push   $0x8010a94a
80109ee7:	e8 7a 66 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109eef:	8b 00                	mov    (%eax),%eax
80109ef1:	83 e0 01             	and    $0x1,%eax
80109ef4:	85 c0                	test   %eax,%eax
80109ef6:	75 0d                	jne    80109f05 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109ef8:	83 ec 0c             	sub    $0xc,%esp
80109efb:	68 64 a9 10 80       	push   $0x8010a964
80109f00:	e8 61 66 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f08:	8b 00                	mov    (%eax),%eax
80109f0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109f0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f15:	8b 00                	mov    (%eax),%eax
80109f17:	25 ff 0f 00 00       	and    $0xfff,%eax
80109f1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109f1f:	e8 5c 90 ff ff       	call   80102f80 <kalloc>
80109f24:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109f27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109f2b:	74 6a                	je     80109f97 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109f2d:	83 ec 0c             	sub    $0xc,%esp
80109f30:	ff 75 e8             	pushl  -0x18(%ebp)
80109f33:	e8 9f f3 ff ff       	call   801092d7 <p2v>
80109f38:	83 c4 10             	add    $0x10,%esp
80109f3b:	83 ec 04             	sub    $0x4,%esp
80109f3e:	68 00 10 00 00       	push   $0x1000
80109f43:	50                   	push   %eax
80109f44:	ff 75 e0             	pushl  -0x20(%ebp)
80109f47:	e8 8f cc ff ff       	call   80106bdb <memmove>
80109f4c:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109f4f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109f52:	83 ec 0c             	sub    $0xc,%esp
80109f55:	ff 75 e0             	pushl  -0x20(%ebp)
80109f58:	e8 6d f3 ff ff       	call   801092ca <v2p>
80109f5d:	83 c4 10             	add    $0x10,%esp
80109f60:	89 c2                	mov    %eax,%edx
80109f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f65:	83 ec 0c             	sub    $0xc,%esp
80109f68:	53                   	push   %ebx
80109f69:	52                   	push   %edx
80109f6a:	68 00 10 00 00       	push   $0x1000
80109f6f:	50                   	push   %eax
80109f70:	ff 75 f0             	pushl  -0x10(%ebp)
80109f73:	e8 81 f8 ff ff       	call   801097f9 <mappages>
80109f78:	83 c4 20             	add    $0x20,%esp
80109f7b:	85 c0                	test   %eax,%eax
80109f7d:	78 1b                	js     80109f9a <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109f7f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f89:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109f8c:	0f 82 30 ff ff ff    	jb     80109ec2 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f95:	eb 17                	jmp    80109fae <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109f97:	90                   	nop
80109f98:	eb 01                	jmp    80109f9b <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109f9a:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109f9b:	83 ec 0c             	sub    $0xc,%esp
80109f9e:	ff 75 f0             	pushl  -0x10(%ebp)
80109fa1:	e8 10 fe ff ff       	call   80109db6 <freevm>
80109fa6:	83 c4 10             	add    $0x10,%esp
  return 0;
80109fa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109fb1:	c9                   	leave  
80109fb2:	c3                   	ret    

80109fb3 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109fb3:	55                   	push   %ebp
80109fb4:	89 e5                	mov    %esp,%ebp
80109fb6:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109fb9:	83 ec 04             	sub    $0x4,%esp
80109fbc:	6a 00                	push   $0x0
80109fbe:	ff 75 0c             	pushl  0xc(%ebp)
80109fc1:	ff 75 08             	pushl  0x8(%ebp)
80109fc4:	e8 90 f7 ff ff       	call   80109759 <walkpgdir>
80109fc9:	83 c4 10             	add    $0x10,%esp
80109fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fd2:	8b 00                	mov    (%eax),%eax
80109fd4:	83 e0 01             	and    $0x1,%eax
80109fd7:	85 c0                	test   %eax,%eax
80109fd9:	75 07                	jne    80109fe2 <uva2ka+0x2f>
    return 0;
80109fdb:	b8 00 00 00 00       	mov    $0x0,%eax
80109fe0:	eb 29                	jmp    8010a00b <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fe5:	8b 00                	mov    (%eax),%eax
80109fe7:	83 e0 04             	and    $0x4,%eax
80109fea:	85 c0                	test   %eax,%eax
80109fec:	75 07                	jne    80109ff5 <uva2ka+0x42>
    return 0;
80109fee:	b8 00 00 00 00       	mov    $0x0,%eax
80109ff3:	eb 16                	jmp    8010a00b <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ff8:	8b 00                	mov    (%eax),%eax
80109ffa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109fff:	83 ec 0c             	sub    $0xc,%esp
8010a002:	50                   	push   %eax
8010a003:	e8 cf f2 ff ff       	call   801092d7 <p2v>
8010a008:	83 c4 10             	add    $0x10,%esp
}
8010a00b:	c9                   	leave  
8010a00c:	c3                   	ret    

8010a00d <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010a00d:	55                   	push   %ebp
8010a00e:	89 e5                	mov    %esp,%ebp
8010a010:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010a013:	8b 45 10             	mov    0x10(%ebp),%eax
8010a016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010a019:	eb 7f                	jmp    8010a09a <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010a01b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a01e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a023:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010a026:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a029:	83 ec 08             	sub    $0x8,%esp
8010a02c:	50                   	push   %eax
8010a02d:	ff 75 08             	pushl  0x8(%ebp)
8010a030:	e8 7e ff ff ff       	call   80109fb3 <uva2ka>
8010a035:	83 c4 10             	add    $0x10,%esp
8010a038:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010a03b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010a03f:	75 07                	jne    8010a048 <copyout+0x3b>
      return -1;
8010a041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010a046:	eb 61                	jmp    8010a0a9 <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010a048:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a04b:	2b 45 0c             	sub    0xc(%ebp),%eax
8010a04e:	05 00 10 00 00       	add    $0x1000,%eax
8010a053:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010a056:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a059:	3b 45 14             	cmp    0x14(%ebp),%eax
8010a05c:	76 06                	jbe    8010a064 <copyout+0x57>
      n = len;
8010a05e:	8b 45 14             	mov    0x14(%ebp),%eax
8010a061:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010a064:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a067:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010a06a:	89 c2                	mov    %eax,%edx
8010a06c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a06f:	01 d0                	add    %edx,%eax
8010a071:	83 ec 04             	sub    $0x4,%esp
8010a074:	ff 75 f0             	pushl  -0x10(%ebp)
8010a077:	ff 75 f4             	pushl  -0xc(%ebp)
8010a07a:	50                   	push   %eax
8010a07b:	e8 5b cb ff ff       	call   80106bdb <memmove>
8010a080:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010a083:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a086:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010a089:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a08c:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010a08f:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a092:	05 00 10 00 00       	add    $0x1000,%eax
8010a097:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010a09a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010a09e:	0f 85 77 ff ff ff    	jne    8010a01b <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010a0a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a0a9:	c9                   	leave  
8010a0aa:	c3                   	ret    
